Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E45DC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 08:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FE1D6B008A; Sat, 11 Jul 2026 04:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF8C6B008C; Sat, 11 Jul 2026 04:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6B86B0092; Sat, 11 Jul 2026 04:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E03516B008A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:05:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 752C8A0692
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:05:18 +0000 (UTC)
X-FDA: 84975760716.04.1E19838
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id DE6A61C0006
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:05:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RrA69GHo;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783757116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEJXi3Ipa/GF3uVFfVgIRTBsXVg1ufevqdVuD40f/4c=;
	b=fJSXZ+KDaptOuU5sXmp+37PlzBrxdhsTb2G6/B4rPzWXeguONaocWdmYPrSNN1kK3b6U1F
	Wxrf2RO6BIdubDNh3esKc/6sj8rJzD/0YTyHb3HQLwST8YWLx1Vvqo9gq9zX6Cha1ZA48t
	e7jwld+w7Dl7dNvXUMNmdQabtifJzBw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783757116;
	b=PK39/UkheANPs3DuclrxYmulYkG6cmVNidGeHrzAclIngPD8qDaNyAa/VpmZAxXh3WVZ2C
	JD5THkIwmALa5q013rQEs81jvH1kg9/yKx8J04Q2e2Lm0oJNW/eW9vDwhtWZMgzkSOQe7d
	7TczGqxT1K1GcBF5wybEI1q2Ph5YZNc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RrA69GHo;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 554CC60051;
	Sat, 11 Jul 2026 08:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A3C1F000E9;
	Sat, 11 Jul 2026 08:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783757116;
	bh=oEJXi3Ipa/GF3uVFfVgIRTBsXVg1ufevqdVuD40f/4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RrA69GHoEQEWSHV9FU+fJtMJB2iGQ06pVUQwtOrx8BpMO1GgoBGlvan9iYFRWTfNP
	 9GGC5tfncOgs7hIDPl0MF43uMuNPgPDJR0n149gZx4Bnm9sRD4kPH4jEaGUplQ+Ko7
	 INy66aVReGmFuTWGgR4BC/GBMV2Ll54xeCnx2JWTKiBLoOpSIZ3EaVcY9J/AHtNbg/
	 TjVgv122gKFOPu7uoXJgvJaRGVJM7rW/8D2ocoNsrL1BRoSFquwgMRG1+N0KtcKUBq
	 lyd2gOAlszvYPPmKIITFDPK3wZWBDHFJh9S2M6ySdIW1C5ACa3ykMpDNj09Sz+YlVZ
	 UFofibfsgZMSg==
Date: Sat, 11 Jul 2026 09:05:03 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: linux@armlinux.org.uk, akpm@linux-foundation.org, david@kernel.org, 
	liam@infradead.org, liaohua4@huawei.com, lilinjie8@huawei.com, linusw@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@suse.com, rppt@kernel.org, sunnanyong@huawei.com, surenb@google.com, 
	vbabka@kernel.org, wangkefeng.wang@huawei.com, xiqi2@huawei.com
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault()
 under CONFIG_DEBUG_USER
Message-ID: <alH4-zEWkSDK5EvK@lucifer>
References: <alHnqsIdcMghnUER@lucifer>
 <20260711075651.3114-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711075651.3114-1-xieyuanbin1@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DE6A61C0006
X-Stat-Signature: 5toqk7qohi8famzynssn9zfceukwdep7
X-HE-Tag: 1783757116-727419
X-HE-Meta: U2FsdGVkX1+pXaqBm150oLzVOsw+uVzF1iSceuMAwoPslggPA0rWGmYCscfXJ8BPjOiQoNtCLF1rhoezObMK2AhhedFYqd757lPPlmI5L1LijxdTrh/0a2hNS70EO6hvxtS0kLjLLOP1okHgXnZdwogD1MR2ulSNdTuoV/NhL/uJrkDykH49Yps6cISIYsAVViq93KABSguRjaQ7SnfuPd/yn8hPi+ylYvIx+yUVN3tMNX6j2JYorPDEHy7/NO04y/bDtiYEUweb+f9Rrk1HuOVY/N/PMjI1Ygp0cmSbjiu4vOcvECC2VfxvN7fo3tG/hO5fd/fCM/k6mejntDyNS+vOWF4d/hQyWR9B7xhQuafkzeg8LBaA+t1DxzMecN71bKFIneQuU0U7cLXruC5ScefshnvhDGRamW6srBSZCMG7aJvY0Lxc8MtdwYRE67ckCEsCaJrvJ4YHgrhWiGNdAfUBCFnJGcu5DTOcwupa1WKZ/dYJ2we/BT9aLXt5WVUv5MDbFJgswugeni+ioLiySnAlkL+SHOopXPJe0WsZQgXR6wLX0rDFY7yK1l0GlpKn85czhC24jofdYL2GFt+2oj33lGIxrl1OGcTf2fvLeQT4Y4bAvmmngBDg1BBhftVbYh5JVe+N9ZW5RidHsxOwgNIVrrjuYoEu8E5thI7UelQHn2g4Q7XtF8Hq0pR8RyxQ/72qmGHkmh3GvCP3UtsFDCnyBalXEh6tuPgAaAZbZD0MbfDQOJYAcJ1XIXhPsh8rNsNNi07HTzv4pjIFo/qRMQNrJ93ax7auempx8Xpvixzi7v7cJ25xxxyOj/RYSVGYDiwFvKQiI49xSGnv3IemcgD4d17MC8WZiKhGPGwGsFoKBtY/AQXS7vWHW9kbxccD1G9uIXO5xoR1bYXWZjtFYb4imhWXTA/m4pwPiLSWF2IChqVVc5fh1e++3/EidGcaA/8AkHJ07TuWOFw7mF5
 QN7e/VlE
 jTFI/OHTUgxPSMQvPQEzujw8D1CUMm0OF50Q67fWy+OPY0jfiO4Lz7hnuP4HQxs0nlbkU6VhDW0IKqWC1uV4C2eBS19lUnIYKOIyWVbmh1AUFZDtH9XkPPFihuBHN9arzum3jU4qb4/tPBxSRTE0yhtIW5h+3OF7oXsanmqVK6JHLioVGqSajkKwMs0vRqkGcw0d1iFPC1pEenPotZ+r3MT+m181S+c/HLDxeLcFaufwiOxp2xgiyNg0eFxDjsNivPJuv/JOQchbVJLX85gq9viJTA/3Eud38EKx98yK+VJM7nh3UiywSomzIbNBsNwFhHLBCd7BlvbMrQ+cIIMuxDnKun5eqkFN36xFXYZ+QjLwzr2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 11, 2026 at 03:56:51PM +0800, Xie Yuanbin wrote:
> On Sat, 11 Jul 2026 08:27:23 +0100, Lorenzo Stoakes wrote:
> > In general yeah but with mmap_write_trylock() after you add the attached
> > patch to a series (making sure to cc- the right people etc.)... but also,
> > wouldn't you just generally want this in show_pte()?
> >
> > Seems to me best way is to put the existing show_pte() into a __show_pte()
> > and then do show_pte() like (untested top of my head thing):
> >
> > void show_pte(const char *lvl, struct mm_struct *mm, unsigned long addr,
> > 	      bool is_user)
> > {
> > 	/* Write lock needed to account for concurrent downgraded munmap(). */
> > 	if (is_user && !mmap_write_trylock(mm)) {
> > 		printk("%s[%08lx] unable to acquire lock for PTE output\n",
> > 			lvl, addr);
> > 		return;
> > 	}
> > 	__show_pte(lvl, mm, addr);
> > 	if (is_user)
> > 		mmap_write_unlock(mm);
> > }
>
> For user faults, I think we don't need to worry about deadlock issues.
>
> As Russell King described, deadlock problems can only occur in kernel faults.
> On Tue, 7 Jul 2026 16:34:21 +0100, Russell King wrote:
> > Unconditionally taking the lock could lead to a deadlock. Consider
> > the case where the mmap lock is held, and we get an unrecognised
> > abort from the kernel.
>
> As we never return to user mode with mmap lock held, so for user faults,
> it is safe to acquire mmap lock. This is just the same with the syscall
> entry of `pkey_alloc`, we immediately acquire the mmap write lock:
> Link: https://elixir.bootlin.com/linux/v7.2-rc2/source/mm/mprotect.c#L1011
>
> For the kernel, the user faults entry and the system call entry are not
> fundamentally different; they are both kernel entry points.

OK given arm32 can't do any of the stuff that makes kernel faults an issue, and
if it's certain you can't deadlock on mmap write lock for VMA or non-VMA ranges
on user fault, then no need for the mmap write trylock, and just take the mmap
write lock unconditionally for user faults, and no lock for kernel faults I
guess?

