Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF7D8C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9ED6B008C; Tue, 14 Jul 2026 09:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A146B0092; Tue, 14 Jul 2026 09:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74BB16B0098; Tue, 14 Jul 2026 09:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F13C6B008C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:28:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B98FF160354
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:28:24 +0000 (UTC)
X-FDA: 84987461328.08.D668088
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0097E180002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:28:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lP3K0krZ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784035703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4NWkOyTUgNN9NiCMlPZ/SA4EFAV9liu5YT3JftznMo=;
	b=Z1/GH/LQ3AfbHAApMFI83LIyHn/wW3g64NkZfFq5IOGJtH7APmQtLbRIV7JFqC2as2xA/4
	eF1y5Hk9Oh05ufuhYZjzBKLvMbLfSnH6taHe6Z6Cq95wanduCMMHtlWbH5QvamPphBnipB
	i6HO8kefYc4NE89tJqQSuA8YCqsDHbQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lP3K0krZ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784035703;
	b=mdUaVsejlxhBXcmzoAO6hvGqvNoDVA9IBb/or2iYaBoZ/DoQKrIUCbZSxxvpXTZNBY685k
	AQPYjrs+AcVfODN+FyjayceQl/7msr3tweINIK1i9/fR/jHODWLLioD5Fui7aGej+1CtB5
	LjwJWYZM3L7m33N28B76uHiQE1gfO0Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8279C601ED;
	Tue, 14 Jul 2026 13:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1024E1F00A3E;
	Tue, 14 Jul 2026 13:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784035702;
	bh=h4NWkOyTUgNN9NiCMlPZ/SA4EFAV9liu5YT3JftznMo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lP3K0krZT7KuUIMbksx4cF6z3GlkKoEdsdZDCpLRlfuPTtfjcJHQYfY61LjbX+RFn
	 xsAzCWDSz7j3EDx5rjpzm9GAO081oPgUCEamq2oJ1LbuU78hMhuxIxIzzRB5vv0Gga
	 NfOu2mEqX8yh7AVtG7nYGDLo/x5AtUoi8sSPSdhsJuQHjXAOLn8ZKHYGB1hUWaZwKV
	 g/BsgXqyoXSGTPQWgEpJlG7IFDVA0zCK0AHmYJGTIWWYPsKM6dDisFp1KHxkXJXIEZ
	 KZzOjSkeivHRrO22IckyIwmLZC2oB/e0D4dV9ZuIV9HmhzGx5Kl/Fl7+BcLduZpwZc
	 rQrbmaGQiAyUQ==
Message-ID: <51bc272e-53ae-449c-9ac1-bdac2775e47e@kernel.org>
Date: Tue, 14 Jul 2026 15:28:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/kconfig: Drop redundant dependency wrappers
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Julian Braha <julianbraha@gmail.com>, Muchun Song <muchun.song@linux.dev>,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260712093326.8313-1-kaitao.cheng@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260712093326.8313-1-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dqzhecp8e4nnhtu9fy57u31g63jiy4i3
X-Rspamd-Queue-Id: 0097E180002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784035702-558105
X-HE-Meta: U2FsdGVkX18tdr/jqMll3TZzDDn6GFxBkujCuwoa1ed8BOH2hHpRAaWemVL7fMlviy/p5zPcdv7+C4TrPtimUcLwUTbZ7MdsF86bqKNJUxkEDV7bVU3CekKfRguKkzTKqUKcCQHsdifvG7ZGteAp76CUKArxwp/lPbkt/2tBeWBS0xBoAnq4NUQUNYGUU7ugcL2jprNydXrUiuky+JB5IdNioK3rqI9labt1MKpS8oG9AVBpVW3IERJRIXKWPrTR5AkToMs3olKLpdfcgpxWXiOW/SIETzrptEKQWMKFKyiaoCWEYrkddNIb9L3C9G9v9IHg0ENZ5P7u19k4RBAY60bvgFoCzA5ZJczSXVSAoPpdvqn88lxKxyP0TTjtCeZJv9yDQPquOij6Xf/iNZdK7cZ5n8abjvmzHtQj7NRHVd0uV7zz2Wmo4AuDzUrPG43NB+Gr46KAdqnYC3TU2y7Dks9gk9MyEQEss3HC73VgN88ogkhi6iaTeCPRM3HAYxczpEp61fnI23BJ6NpF8Nw1/EaU9w8x4OKB8HhYQzXcC0hnmTQsmEGrrRNK+V4oYo64CDfzsoo/XiwC/Iufd4Ika7fQ/4jJzLvFxX0k8OBo/u/RdavKjotHyLWtAtevX8q/b4Ciw9Wsedzt9qUFimsKmEWt7LIZGmKPnf7bvh8XUEnkdgPb5TkF4gsBIUfiGUCXcn1n0Fdpt1bLnEqlSOrLDqyRm9mDaS2WiOiSYUnDShM6Rez9JDIoetMrOqMejJ+PSEFllIo8aiGdcj1BfAMr3Mrul4MYA36ZlmXsjwPAzqVsfttPf6OR01w+ChS3hh2BhDfx+H37RmdASfEWfGCPSVaBGr9zQmd0AXSi/w/rGz0HwGszvrs3p2z2zPKDVmJLT88/ofsXG6ac8kyLPoEsll1HdH6AvmknI0CCYpbgyiyOMQK3zoO9jtmB24fmMjr+uvKxI0LQxLxsyr2218s
 Qsgh7uMB
 M74qBiTzwhntn14fM5ts692BLXIu1uCdoOS8/VjnDLyo0q7SeCcbxpJYqG6xoFBBLJ4YGQU08aFM/DQYVY9jkFWPPnO9Buaz79hkF70u+flB0PTdUdFPnez8OP7OMNL4e/SRtZ8upnyqQTcTXfAhYeJ3cNg+ef8Sq1ar2ijjydPPVx83QhtVdCEqyBPLEzFhkkhrs/Yy0Ag3ceKkVypb9zXMtgYM6f0HgQnMOxRQuXzTEr1uJBOhKJ97J13lnRGBsoWhY6OwcFZ9QkvkszsWYarwKBUnkTwLgkBowOsGyXAnStgK2JXDEDCOVHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/12/26 11:33, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> Some mm Kconfig entries repeat dependencies that are already expressed by
> their surrounding blocks or menus.
> 
> The zsmalloc allocator options menu already depends on ZSMALLOC, so the
> outer if ZSMALLOC block does not add any extra constraint. MEMORY_HOTREMOVE
> and MHP_MEMMAP_ON_MEMORY are both inside the if MEMORY_HOTPLUG block, so
> their local depends on MEMORY_HOTPLUG entries are redundant.
> 
> PTE_MARKER_UFFD_WP is the only entry under if USERFAULTFD. Move the
> USERFAULTFD dependency into the symbol itself and combine it with the
> architecture support dependency.
> 
> This keeps the same visibility and defaults while avoiding duplicate
> dependency expressions.
> 
> Suggested-by: Julian Braha <julianbraha@gmail.com>
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

