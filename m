Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF43EDF16E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 14:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FE456B0005; Fri, 13 Feb 2026 09:33:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E00A6B008A; Fri, 13 Feb 2026 09:33:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11FF06B0088; Fri, 13 Feb 2026 09:33:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB87E6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:33:42 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C31213B2AF
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:33:42 +0000 (UTC)
X-FDA: 84439677084.05.BBAEA06
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3207A180009
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:33:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf06.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770993220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7zlauq2NXmYcYr161AptaUs9JIe11MydsXKwgR9OyVs=;
	b=3phJ0287sucfDW/AZPTxEcBM/wPjM7xlWKHBGKZyw1vr40Nw/b86uc3GYEfJaovduntofy
	5bBKuURUtZ7w2qPdARjxMbbC7gMUzUpjIpJcCIvdOXXIy0CHaePzs9QrXQXpSNQvHOsN1t
	Tb+iMZWVj9vlR8jSVOcsOKg9lYasSmI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770993220; a=rsa-sha256;
	cv=none;
	b=Hposb4gx0hHsDsetlgdammywAMRBgY4qqAGZWCMHQZuUscNUAj/+61YtvzvibzX/xu+xg1
	baq7f2dwwb1i7Ezhi4kfUJK8rezAO9iujJAt9J7EJ5YefSxQa1es+aeuxwamnbeNHDXgAq
	tngBKN0r6eaL8ECcaa+SA5wrp3IEl2w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf06.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 13 Feb 2026 23:33:35 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 13 Feb 2026 23:33:35 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com,
	taejoon.song@lge.com, austin.kim@lge.com
Subject: Re: [RFC PATCH v2 v2 1/5] mm: swap: introduce swap tier
 infrastructure
Message-ID: <aY82PzT1GSfmznTv@yjaykim-PowerEdge-T330>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <20260126065242.1221862-2-youngjun.park@lge.com>
 <CACePvbVML6ZNJBWU9YSUCWwrbGd2eXMcsWxs6yFssfyBoEk5Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbVML6ZNJBWU9YSUCWwrbGd2eXMcsWxs6yFssfyBoEk5Uw@mail.gmail.com>
X-Rspamd-Queue-Id: 3207A180009
X-Stat-Signature: 36o4ro3q5i1hb9eqw39hbjzmb96agzjj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770993218-865451
X-HE-Meta: U2FsdGVkX19NAbvHF/s7b7gYTISo5y+yQnUqkzr6KSaXTaOV94scCG7c9WUsismdFJzhxDQkbJ6WS9Tz0FsRVfQ0+ILjXpfDgF+bHwX+mLWiZEkTGVXXpQSfzop2oAEjRt8iRWa97OspAMZKUCziwNC8SHsuNYBAAxa5soc2taofJ7+7L6BWoerG3gHSOcEu4rEc87f/1APoy/Aq2pauCAhEErpu7VbATVhGF69HnGlUhOVKvBA0WfjxuaInAN9RkWmLDL0rmjenotkbD5HL7bPsswty7Ng1lYjB4lDvMri7Rssi+bEc0ZKvGW1B7b6pRVfj1Ovwddr+pF7eislJv0J9I/Culy1+iz/JRE6J7NMqAH2avlp5m+U79BUUgRQrzD44JULOqqIbMfUWpEW4vr/fWx24rz0KtLGIiYmhfAShE6Mp+iwul1+8r03ujiWiVW650MC7aHdSxkEP09hRBayaP+SMl713Rx28xgfTBsGRaW4nmy4z8Fit/Fq8iVGHxoLk1uRXoZw7cm5WxZstLIsEjY2M3xfarshnmNZ6Xt8RJtfZeoHcMzaOAml6y8FK63JQcrXWD44v9bC7SRoTd3AhDFdosHKIFVebqWEmMC8TR4gkm5oC/mO70TVKsxUi4ZbcyU+EkQYKGhl2PkJ2o/KxC7mMqwsXCNQJLJuC9WNMrqkIJAzxQAX521lq9yaAD0rJ52vVpEunf9ra7+44TKOXFbRR8OypthY51BQeQh8WZtz1V9jS9ayAdTaFybhTnTpvTC0M72NHd0PcZQRnrtxbsyMMkgS1tzqhz/TS/3X0BZm0Az2xuLKwK/CvbNivsxkkcxArrMdmDvY6QECwoD86CS+zWSusPrInHKpNnR232G7IwEagHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 01:07:45AM -0800, Chris Li wrote:
> > +}
> > +
> > +int swap_tiers_add(const char *name, int prio)
> 
> When we add, modify, remove a tier. The simple case is there is no
> swap file under any tiers.
> But if the modification causes some swap files to jump to different
> tiers. That might be problematic.

I missed one comment. 

The tier of existing swapfiles is immutable once assigned at swapon.
I removed tier reference.
Instead of reference counting, each operation validates the tier
range at operation time to guarantee this invariant.

- add:    Does not change existing swapfiles' tier. New tier may
          split priority range, but existing assignments stay.
- remove: Rejected with -EBUSY if any swapfile is attached.
- modify: Rejected if the change would cause any swapfile to
          move to a different tier.

So swapfiles never jump between tiers at runtime.

Youngjun Park

