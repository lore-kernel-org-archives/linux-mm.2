Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB52CC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 08:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3A26B00A2; Sun,  5 Jul 2026 04:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AADD6B00A4; Sun,  5 Jul 2026 04:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7496B00A5; Sun,  5 Jul 2026 04:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 653036B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 04:51:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9F07404CE
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:51:21 +0000 (UTC)
X-FDA: 84954103962.24.EB7B62B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C8F7C80007
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:51:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jWPJ6rU+;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783241479;
	b=FdxBhGv0KIV1iIv6KeIdXieXCaSRsEXk+rS+R6xsNycBZqROlo5owwwVYf+yzqEIenUiN+
	GiKdSvromCY0K5XYoMN8wOc6ZSiybQtJUpm06CuRS+aJCdmpKl3C1Qd9BwX9KMhComS2Lz
	TE6yHBRbElfsTswCtV8pHsmi44kCZrQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jWPJ6rU+;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783241479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFER0JTg0MnvGdQz+yRx4LxJwuvQANRQsRUh9Fc5KHk=;
	b=7tcN5kNWLwvgaL8pZeARWfOXhoad1qd1QJg5OMVvANOGPqgVNweB3N3pHvFxkAv6GW37Fu
	3xu5HmJqUjpectQsgAE2alfrroQpOQ/jPeC7br6OX1aA+oZHC+IGPnVBCalHQlR8dWw617
	DC0LdIsLEfC0EFeYJaw6hhmEr8Vm6l8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10AAE40217;
	Sun,  5 Jul 2026 08:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE181F000E9;
	Sun,  5 Jul 2026 08:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783241477;
	bh=XFER0JTg0MnvGdQz+yRx4LxJwuvQANRQsRUh9Fc5KHk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jWPJ6rU+KuF+lWRTG1lcB6g/hZQ6vFezaj4DZPhhOK3qmpJeMnsgdSKr9WR09wtKD
	 bnLMQmH1utE+UBm04kzhAvs+55vHp2EtBMNxsl+TzmrXF2dShdCa5O77l3C2o3Jzcm
	 mE6wMzXSZPPmZH7qr3ZbnQ2zIvjiFO6EvLhffQAc=
Date: Sun, 5 Jul 2026 01:51:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)"
 <david@kernel.org>, Gregory Price <gourry@gourry.net>, Zi Yan
 <ziy@nvidia.com>, Pankaj Gupta <pankaj.gupta@amd.com>, Jason Wang
 <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio
 =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexander
 Duyck <alexander.h.duyck@linux.intel.com>, virtualization@lists.linux.dev,
 linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: page_reporting: allow driver to set batch
 capacity
Message-Id: <20260705015116.bdf3335e9a955f057a6d9c5d@linux-foundation.org>
In-Reply-To: <20260705044139-mutt-send-email-mst@kernel.org>
References: <444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com>
	<20260705011635.9974cac7f0defec9961e85c4@linux-foundation.org>
	<20260705042313-mutt-send-email-mst@kernel.org>
	<20260705013956.36f649b5cb13409d9088838a@linux-foundation.org>
	<20260705044139-mutt-send-email-mst@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8F7C80007
X-Stat-Signature: 9mdpr1uiz6zbchnq9n37te1xznybbitc
X-HE-Tag: 1783241478-99123
X-HE-Meta: U2FsdGVkX1+IMBXFD6re6YzAB4HlLZTk8gf0q0D8pMjuI8wZPCMgPjGwJXT3MpFToRjl9RS5qHUW1j5v7hGr8Rk0NlsCegN7RqT1wmNG6xfwQ0Y2xY51fuSKOf62MPGeBwHqjJnE64mVglDBv8B1X1bfaWiVVShrk9eZJucv7+WtDiGFHfOjYfJ5VmBnlq1BNwAO8BNnB8rXpBDMv2gOuRDRFMTEHVG3Bx/9EMShxVeDRmrmyFjZhIa7lLCdXS+G+y4bVr8A5w8AEsfR+x0qkntEju6uwPoP+oWvxj2zEbyydmI+Tu0sVdJ/zr6I1JkIl+6xADKJCA/3Yz3vEvnCIQH2waw2Woc1T5wn2QmgkJ/xz/4xfoasTdbEoZPPnEhnW0MAQRR6EXzNmE1uA9dbXhP42+XDl8Wg6zr1FKpkU8GM3lNm+MpPF7u2TEVfymrJhq9cHTlzHh2DOnRJ4WTzV6+0D9AYkYvLiI+UAQ+HIRpFGJC88tAdy/3058Rc8Y80QWMdq3jGjUN/+4xWJHB0+0khmi70MyRRalUn7eacsRXucz19ekChGDgEx8ZnMtDsK6yiCe4ISThI+beAIjNYzQ/CAqDGsTVrAyxJtchBfwdPOFFjdy43SWjQSkr//z5AcQAHHrvipVDd/Bj3gQhhGXCgEZZ7i1MfNdP8bkusxNOBqVWkOaR7WYuVR49DWVGtLQ4G4STmk92WzfyiBEwHe6KogbNpqaY4UuufI2ik8k6EEiMc+l/saJ01z3BSkHFsAdo5fWtrgDjnz3hbw5A0hSShj2ozFioohRGxbP2FLkZfhZ09+H82UGdVnAY8HdWw86N1uKrQbyNNcK4WW+lOONGtIq4OsLsWcZZzoFHP/yMcRlfKNU6hY94TFUVEV2c6weCOKkcOV+L1o+PKNO8B7FclExub+wJhV/ghvpdpncr2/gMLNLmYA1cFZLWRGasu7k9O9zcP53L9oI9mDkX
 1oGGrdkv
 +xRyEO5iIuyjRmKBg/FDBsRdek0eLjc0y2JVFclo9S8ycBBc0LTdv8zi0Lee9Tro/ETbF+TZuPJFjF+WGlxTCP2Hbh2ul1OzF4CCQekn/vTl1ZvqhQU72y3FRX5zzshuZ8Ixsq4Tdez13VU+sbuDQlq4TvzZash9LSTjMhLv0EVddNVDMmitr0yknTh4Pt1UMjojI2f4mTtvjnRcEjNjSac6OSdwQZhhHr7gk/9SwKScRp6UsVkGe7U6/YovbSfuhl1C1Jj7sjl9sb5VxyYsx8xcHtOnpgwtuF9NhFr5bT1njK2k6uS9Jx+utFOC7LrkmJ2ku
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 5 Jul 2026 04:42:38 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Sun, Jul 05, 2026 at 01:39:56AM -0700, Andrew Morton wrote:
> > On Sun, 5 Jul 2026 04:25:53 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > > > If capacity is 0 or exceeds PAGE_REPORTING_CAPACITY, it defaults
> > > > > to PAGE_REPORTING_CAPACITY.  The 0 check and the clamping is done in
> > > > > page_reporting_register(), before the reporting work is scheduled,
> > > > > so we never get division by 0.
> > > > 
> > > > Thanks.  What's the priority here?  Should we fix 7.2?  Earlier?
> > > 
> > > If possible, I'd like it in 7.2, have a setup like this (small
> > > queue is useful for perf testing).
> > > It's very early in the cycle and the code seems straight forward...
> > > I judge the chances of breaking anything is tiny because
> > > it just failed probe previously.
> > 
> > No probs, I moved this to the the mm-hotfixes-unstable queue.  No cc:stable.
> 
> I suspect the Fixes tag will make their AI pick it anyway. But hey.

-stable maintainers have been asked not to do that - only backport
patches which have an explicit cc:stable.

So should I add one?

