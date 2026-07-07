Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 516CDC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6F56B008A; Tue,  7 Jul 2026 11:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BEA06B009D; Tue,  7 Jul 2026 11:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FAFD6B009E; Tue,  7 Jul 2026 11:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA98D6B008A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:34:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66F9BA03B2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:34:45 +0000 (UTC)
X-FDA: 84962378130.01.4857E9E
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7C97840014
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:34:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=cbP0GUWT;
	spf=none (imf11.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783438483;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cW1i2nsSqGec664NhqCRjOb/CVuLPA/uupdfC4+Q4iM=;
	b=TV3s9ZdygGqDQoSD49wPkxfcBYtZhsRgVOQrFDfDQdl+sS/H1EzOYGEU+I4FtE0ErPzq5Y
	zT5I67JOuX6njEkoiaL681mliP9XugojqpjK76cl1/CLDSwnUrIBBaoQWcuq/w3n1lUMrt
	Nro53aLLmn7eropZgKZHcVfDMupPgTI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=cbP0GUWT;
	spf=none (imf11.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783438483;
	b=0sr6SDCx1G/gYQgSGmrJBCZ5QYi+hK4YCtHfO3eNFRRmrmNeMFMbs7sLuC43BI5maeLekN
	WRN4qgK3xHw4XNOX/hjYqflTvET5SxVuJ/V52SsFxJI/F+Zm+kjmvLrso9UB8FM2nUtcN/
	udTrc4ZT/2YTwcssKZtdAjvrWeg2hmY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cW1i2nsSqGec664NhqCRjOb/CVuLPA/uupdfC4+Q4iM=; b=cbP0GUWTecrX6+QzFTOuGrg/ML
	sP1WAqoiMgHkO/UfOpf1RP6G7STdApB9Sqa5Q2j5+DumZDSKVgTAHcEvdVLNdQfUyfOPeikXydS4F
	aIO83IvQVFHcJHa9wVDa8zDuDbfoAAVU4soZ9ZlICSDvwByhTuou2aMTR7N82NsFXrMHpV2RZ7UDQ
	vPjfLEmWKL60siohRItl40x5InPPmgvilMzheygahePYah/p4EhCuuJm3OvSVckq8YtdzTbUCFB9c
	QtrdnqQdkd91USgiGA6nbDOJkX932vct6mpiGJvuDrbZSOZOKlGUJwjR7rElglPKtTjxPr1qBu2fk
	cGFXXK9w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47092)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1wh7oW-0000000013B-3tY9;
	Tue, 07 Jul 2026 16:34:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1wh7oT-000000006oU-389I;
	Tue, 07 Jul 2026 16:34:21 +0100
Date: Tue, 7 Jul 2026 16:34:21 +0100
From: Russell King <linux@armlinux.org.uk>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, akpm@linux-foundation.org,
	david@kernel.org, liam@infradead.org, liaohua4@huawei.com,
	lilinjie8@huawei.com, linusw@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mhocko@suse.com, rppt@kernel.org,
	sunnanyong@huawei.com, surenb@google.com, vbabka@kernel.org,
	xiqi2@huawei.com
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault()
 under CONFIG_DEBUG_USER
Message-ID: <ak0cfZPZIWz4v95K@shell.armlinux.org.uk>
References: <akzpuerKqOY7qfFi@shell.armlinux.org.uk>
 <20260707131409.79043-1-xieyuanbin1@huawei.com>
 <akz8aZUW23rpyrLO@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akz8aZUW23rpyrLO@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7C97840014
X-Stat-Signature: t8fq8fee1xx3jq75yskmpkir4ei1iqcz
X-HE-Tag: 1783438483-221006
X-HE-Meta: U2FsdGVkX1+oxlt/U2AFXuzU92RWi/xTR2fxwyU75qM+QTMQf43u9EwRAmSisAmJmMaQMkCYmZxJ1Oix9T5aictRxBr7cp/ffdm/qpVBoJMA5YQ29PjNz2q2x4hvviTRdAlBUwzAUrt0Q5cpvcXoRbs6lCZvAKZ74k69AMY/324sf2P87lDThBHBiAYk/Z9OXjbyL0B7ifJ/pcypN8nKNbIBKTwkz7RcL+ky4qEcfE6UDmRg5trrtH6DIQX31BFpaM/n6VEJ8Kmut3LouEPQ++XTgr6ZhXLw7qWHwG43UYi1SahH9FPevVuRb7RrMDXr6cFNYqSzmSCXcYPLXkID2tpyYMrSjqNweqftJy+XAWZoIb5dYe7IbDlO457TzxKi1rOtlRWp+SKhbNny7SW8jFbEJ/YEz/hQtA4nglwc2w1fJPetbgQ/scvSBJlMgs50YByvim9yLNqOWDWYfLuruZUcsZcl3DAv6JlbwgHq5SLpPQf/JV2oeWCpPcM9GIarsRE1XkL0bAOvym0zYLaa5q13sLP7i467/7IW8NgtJMuBCVvVWQO5mVZM89fC0cjkwd6Ze3lwZ6trFc4RoNuYSNSAaZLfzhYW/KwDb8cEic7JuYb8NhMklTGM3stM7iQhI5jDWQWDHnjOjrfV9906ScMIhd6xCAjYJHVzNXQXRX9HzfyIUpIbhoxu8kSiSHbulD+XtqSerhbZyhoqO0SyN5IREP+NYTX2EcBoIhWMAsykGIzjP38q92XmsaSXfC5fZ4YmMgt5EaqR19X00TmcgQGnHXrLuVMvceLQzQrshqUFIsWgIrFZQpqR4BNjtoazKjS3GT/24Lg9VKLJJHlTJXnOe7QEnQBiILziJN6mKVhFm1Cr5aQ+rckqDMIMdTItodj9awP8glOzUMAB80bMdybaOpCn7MtcYk4orTDmYEMiGacvXVwHdr8hEzRrcDQVa7UK1q2DEO/XOUBUvXs
 xghRGqY+
 tlNayNNPEmQOp0PvNnRr2skjAtvGFDp5Y5tQ3XWLWIvdemgKIMuVcIfS6Go6+s6ss9haS0lpxJGNz+omeUZgqOHV5xI/Fvgsxfm8sdzqPjAAG7kwCo2niset/47iGIjeECZ/YjEkxmj8CE2DHkcHpbBGgtNzeA53VA2PVQm2Tr7NgURXcFJR2nV1bMFsR35MCOa1C1/yg70HLkbi3LHY39KlI/WcdpcFKX7pACmTTW4ZymEbtCUxQZMXW4l2+R+J/oJz8x3nnnHPE/lW0rwpW5foCauorysJE8wSIBa05vyGfSFYmVCKZOSBhALG5aQfJCaXNJai8yg4egUOynuXj2xh4ykE4HQAfWZ6hoxVk2zEWtQ4pEAH2tTOXFXDnwElBaGxbA0UDnQvZXqYIaRNJgag/gAoXhvMkaAiNej6fK+/EkqOnXfqjrOgn39F9dryfrPz8Okz97+c0crKU377O8w143UhPWCzlKmg371Yu3CwpxztjiaYQk9LoZonkU5Riz6q5pnA5uSI0v5j9jK7ICuDZVYYqZWR/UQIY4ASqeV/9DVBKsQzvg7A1yQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 02:20:19PM +0100, Lorenzo Stoakes wrote:
> On Tue, Jul 07, 2026 at 09:14:09PM +0800, Xie Yuanbin wrote:
> > On Tue, 7 Jul 2026 12:57:45 +0100, Russell King wrote:
> > > No. This information is useful debug for kernel oops.
> >
> > For kernel oops, I think it should be `!user_mode(regs)`, Qi Xi's reply:
> >
> > On Tue, 7 Jul 2026 19:48:12 +0800, Qi Xi wrote:
> > > For do_DataAbort() fallback:
> > >
> > >	if (user_mode(regs)) {
> > >		if (addr < TASK_SIZE) {
> > >			mmap_read_lock(current->mm);
> > >			show_pte(KERN_ALERT, current->mm, addr);
> > >			mmap_read_unlock(current->mm);
> > >		}
> > >	} else {
> > >		show_pte(KERN_ALERT, current->mm, addr);
> > >	}
> >
> > changes nothing to kernel oops. It only skip show_pte() for user-mode
> > faults, and the fault addr is a kernel address, which means a user
> > program is trying to access a kernel address.
> > I think it is reasonable to skip show_pte() in this case?
> 
> Well the whole reason you're faulting here might be because a userland process
> did that right? The page tables should tell you (presumably on ARM32 :)
> 
> And I hate to repeat myself, maybe you didn't read the whole thread but... just
> use mmap_write_lock(), this isn't necessary?
> 
> What is this trying to achieve?
> 
> You're not in a hotpath, why are you bothering to conditionally take/not take
> the lock?

Unconditionally taking the lock could lead to a deadlock. Consider
the case where the mmap lock is held, and we get an unrecognised
abort from the kernel.

If we try to take the mmap lock again, we'll deadlock, which will
result in very little debug information being output - and the
system locks up. The only thing that would save such a case would
be if the user had decided to use a hardware watchdog, or is
physically present to press the reset button.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

