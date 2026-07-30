Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9C1C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04C816B0088; Thu, 30 Jul 2026 03:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F40996B0092; Thu, 30 Jul 2026 03:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56AC6B0093; Thu, 30 Jul 2026 03:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C71606B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:51:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5FAEDA1E19
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:51:14 +0000 (UTC)
X-FDA: 85044672468.14.ED622CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id CAF8F80008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:51:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CMccH9qZ;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785397872;
	b=i7z8eCzQqerZOZkTZ6OwKw6UNthEWXB7/M0h5R0fk3NLcfxIy6YdJYt36ze/XRcy/UYIGz
	3WY5drVnK8QQieu5gYzWy3/f8XjhcWohFTfoU4ZQdNsEa79KNY9VpjXAy0DsL7LrdpTBoi
	OI98sOFtmLbGIuhdPjYN58B1jTXVnyI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CMccH9qZ;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785397872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5w/82FCXijfhBdhNwVRgCGnxaefSRGHBnSyEBCZIdOY=;
	b=6qdCEt4OaFL7ttVO0pH5aU2MEIzxzkoRf+QmdDmPmFY3k0QkumWWaq2vp66dfUAoJkcOGu
	nP9T+mHdN/e/UhA6oaBIdPNhHxUDmSa+BL2JqUu4ghBBD/c4nqHkyjvqQkVa1m3/KPHaAs
	idYdm1YHE1yEFfElmAv3sUzsiua7JkM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4154F600AB;
	Thu, 30 Jul 2026 07:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802C41F000E9;
	Thu, 30 Jul 2026 07:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785397872;
	bh=5w/82FCXijfhBdhNwVRgCGnxaefSRGHBnSyEBCZIdOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CMccH9qZx/LKuV9Yn7iaAbmPI1x9Zf0qcQxwaRpLJcWKsmbvFXp/pSo2p7MGNJqT8
	 hlVPDbRIpWj/4Wfl4WX6mxeNnz9vc/2Sn0SBYWqYRUpa0Psr+xaMyRbyvMRIZ77Qim
	 xE0Fz5hGcOrcEoDDPkrf6crqMJH1HfI3husQjs9rxbTB74IL9p32m7+7+pMfNKPq36
	 v/abT6qHQOC/rNqHAFPyeWIxrZ24reB7vrtHk+vI9TmYH/vVcx2zvPEuh0+f5zUXVm
	 M4Blwuw5RY1uotXXIYCX+8ZNPkyIzt6jgMXV7ufUxpluDis3SL602qQC7DuAvmb7HB
	 MtjA1lRcLS07g==
Date: Thu, 30 Jul 2026 08:50:53 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Juan Yescas <jyescas@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, android-mm@google.com, fvdl@google.com, tkjos@google.com, 
	minchan@google.com, dskiba@google.com
Subject: Re: [RFC PATCH 00/16] Page Alloc Hogger
Message-ID: <amsCEe5qDn7CPWvF@lucifer>
References: <20260723074854.1013941-1-jyescas@google.com>
 <97605949-82c5-49e0-84b6-b42e8078b55d@kernel.org>
 <CAJDx_rjNhiS+J9eDkQxPF6B=jJ-Evr-M7NNeS_QcG7XWNDoEYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJDx_rjNhiS+J9eDkQxPF6B=jJ-Evr-M7NNeS_QcG7XWNDoEYQ@mail.gmail.com>
X-Stat-Signature: sqt7n8w31xswbbptbgwa7j9xebyo1ttc
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CAF8F80008
X-Rspam-User: 
X-HE-Tag: 1785397872-412025
X-HE-Meta: U2FsdGVkX1/V1HzL7Jh88MRvHHSWqE5yScah5Dd7AiC9Ij222k0T5JePJ/ZzGbIZdRm37TFky0+tSBQ38ZrOi+9K/QV4zVOnTJGGnR7YnafAWSUeYq+W+4nlIWUx9lqtWjVaEfA/yiEXYG2HF4ZNHNL+8oNPu/EnKDunS8CGSjKl3An5IRoWhm5Svq0K/MvnN4eqLrgOhFPPO9N8CZ/ftwKEEqxNywDCVqjUrg6pub0Vk3+C2pwNq2q+In34eCOsuddwJK8tPiMu8bqc16++JRukbrjc3FZHqQLxfK7bace7UowtA5l823jTCpZDsTQDZJciqHlYHeu+tKj7r0V2ywlkEkpD1mvrbyT1QqyvJjqK9MZ/8YgYz+4ODB/2dJZLKExVixLUo9DV3UnBhxQRe9FPZwWdcmASLomhomJbb+jUNfefM3DMaMTzkcR+D9An8h60uz6qXo9Fs0FlISRLXVW+Ksj5h+/APgYLxJNehkFr2xn02qlnArvV9LRdFoSDCwbUZUWDHHqwUHZgyBBlLLk4bZu3b+n3GSRfvWY2gBzoT3rWH+rHJq/d1DxlSnwIgVJ2xaSR9hr6U6yxdIH1TxDWsZ4WCR6RAlxC6WbTC9tWNyc4mDPEhGO0vLhCqyNFtWyz694pLwJicKQbm6ZnyBdmnqiEkbhkwuNOb0CDTXTF4VcgKri9RUDtdf1Tsf+IxxtZI49Ck7cowFH2O+foyXMVxn7X7FuEEE1vTFTAF6skf3GwvNirVYQkjAf8B6BgPRWR6KU5Y4iyKe+S06YSD6Rz6OXNSv5+SXjirvplz312f0jo/soYnP1x+UTa8WA93VERvpInwd8jjszFn4jYpuxXU/XKesF6bJp1kbZ07DNFpW9CN4n9ZUYQVLk3p9/y/Nvpb15gvKATHQ8+Oal3xQdu3RQYdYTCqBfKeIF/ByNDAPXVm6OE7+6XyfmKvX86OZ5qZbaXABjOTAAZqM/
 jwXKQK3B
 ihmte56xaRcHDE8zRKC3L4VU1UNCsMQ9mpoX0wkNvtAs9J8v6AA4L7vsom5OP92R7wp3nDpS9A5+eRELzzxYEADdCZo9HYPhgHUaV8F0daVHZZAnLEr/fZA/wxHKsei0tfZoHg5HniD22JiR9/Rl09FjEsvdJ7lHyGChHi6JZoewlLGI1fPapGXGsq+qUnhddVqycVwZqDizKDp6uq4OhSZriycPxttRJa8gb0SPFjkgrFwcPRy21+rei0VL49liKYeWoW5HbwylA5h7gX5xlQwQ4EC1y5hGxFQOvwg0tQiuGLS+DP/BzfKxsEBwn16qqdq57RVVcNadDBEdX+yo0Vv6KxEakANDBn4+IpFh477J2N9v7z8N0mQzOaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 05:36:03PM -0700, Juan Yescas wrote:
> On Tue, Jul 28, 2026 at 12:29 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 7/23/26 09:47, Juan Yescas wrote:
> > > This patch series introduces the Page Alloc Hogger. The Page Alloc Hogger
> > > allows you to allocate memory pages from specific nodes, zones, migration
> > > types, and orders directly via debugfs. This provides key benefits for
> > > testing and debugging:
> >
> > Would it be feasible to carry this as an OOT debugging module? Would a lot of
> > symbols be missing to achieve that?
> >
>
> Thanks David for the comment.
>
> The only symbol that would be needed to have this module as OOT is
> "migratetype_names".

I mean you could hardcode these and be pretty safe :) I don't we're going
to add any time soon and if we did you'd probably need to change the module
code anyway?

I feel this debug module should be a noop in core.

Cheers, Lorenzo

