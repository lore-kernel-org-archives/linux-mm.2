Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10070C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E17D36B008A; Mon, 13 Jul 2026 05:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8CC6B0092; Mon, 13 Jul 2026 05:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDF196B0093; Mon, 13 Jul 2026 05:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8F6A6B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:43:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35E8D1A09C9
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:43:18 +0000 (UTC)
X-FDA: 84983265276.26.FA5E682
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id 838C680003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:43:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="K/tCCsK6";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783935796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6yn5uVcVNjsZ0l+352af1mfQvFt8DdikhQFAm/QfWvY=;
	b=uYUcdjD5iyUBxjFXny34rrR/rVLNP/YVp5RBs08cPlVYVBGzA1dVM9eGoAw89l/Ut+Cvtt
	uwFUSYFnkBQ24p5kXwmcRelvRe5cAwOXHvpJZ2+M6sSPmDHsUDpJV6odYNi6soq/z5FGIV
	6tLJTLyVINPj7uYGpTYBB/LPojV30xU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="K/tCCsK6";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783935796;
	b=fkSC97ujoC6WNB4O2KyK30HoN8m+/6xG6/6xsqXORFoSxi9L96UdswzNPIaGnoEkQIpe+B
	I1JlmRLzjiBVGfdae4Nnu3yNqsDnUYqNkEVBU8/48v4RL64+7xntqO0x28yMaC+rqtA5pD
	zPnT5PAaWXweIoZsasH97ZnzWc/0N2o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=6yn5uVcVNjsZ0l+352af1mfQvFt8DdikhQFAm/QfWvY=; b=K/tCCsK6xPg3J8zc1+/qL6L7Pv
	o473DLr8msXdiYgLUufinukf8JFQgUi5AH1JciZqBI8wFT4cL7bKiVbvj1DwAanDE53iU7A1VmTfz
	dxltby4C61npIvcM+7Epy6AyRUQ1rC0kSQaqW79Ygkjvk7UMZrlJ1URvP0MRl1xNE42CJ9kQJpNZN
	hm58wO0rpCZFHkijeSxqF4bCCQax9hglYQEIG17Ly8v0RZo6iCguQ8FSwHNJCwGOdcRt1jfxpRByv
	eYG9FI96Rs8SfhP9Ux7trtyygugwDVOVQxlRGQrSHErrkII/xdR1a6YulXioZMPhSkY5PVhwRdTVM
	CnLcLMQQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjDBu-001PMT-23;
	Mon, 13 Jul 2026 09:43:10 +0000
Date: Mon, 13 Jul 2026 02:43:06 -0700
From: Breno Leitao <leitao@debian.org>
To: Guillaume Morin <guillaume@morinfr.org>, osalvador@suse.de, 
	avid@kernel.org
Cc: linux-mm@kvack.org, riel@surriel.com, 
	Muchun Song <muchun.song@linux.dev>
Subject: Re: [BUG] mm/hugetlb: possible temporary resv underflow
Message-ID: <alSyhslcItgtqSHT@gmail.com>
References: <alEJkwn5VlTTH_ZX@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alEJkwn5VlTTH_ZX@bender.morinfr.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 838C680003
X-Stat-Signature: x13d7rffgi7ojhaocu9e4wjwaei9jdo5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783935796-615603
X-HE-Meta: U2FsdGVkX1+2vf4uVk+dA9xu3wtwQmiomqiS0H1Vwq3uHjYdXq5pQ3ZzktqxN4mAMXRE7miCasUP/IsAcJIcSoEklsYSn3X7OFlMYV3sTaWPMOf639yLN4+zpQ39gjxtFsHzMgAhjRW3EIlGkYvsvCUxMLhWwumW55cU/2PTylBNcF8/0bRO2Ys0uCUR9gTYx7HJotRGFCWX2l0OBIGawmoUf74R+gh2tgfBO1FySqrMJfEb1UZorp1utx7B3AXVhdoiiRWp6xMd5XAWA4LEhNPZa62ovvNOcAXOcnaxlGi8HMK8AgKcn4qmrKWq82pK3lzTY4PHVXPkg4CqJINVa+bbhxOaaZO7TqyXbfCtssaQ19/q1iwG4+QHul2XOqU/TnRCrUieHQdGY0FIXZQV5715Pd9+sec4PMKcyEbXp7nc9EmhNg0Xi+z8mUQyCh5B4gVwcORfm2jAqnBX51CB3JnkLntDb7ytzKqLLVwAUvxoQ/KrzC1EZ9QQhwMqOWuscMnU7c07pZF1X87qviKlvBHdu6GXaiKqEi4LKGQF9986pZvNECIbXmPH+98zOT5kPqoSuXkWjZZTCKpBEBy9v23JgRV+Kh0+AVOC3DX7i6qh+QNVQOixdpFM05MWXVHq6kO0POy4/q9MDy2G6clQVaHpLiTRpIb4TItKAZzIsvaL8lSfZzS5Ihv2+VUEmbPeseN71bGODGFrCLPJ5+O0RM7ITspaZv1jroM8+69C5IUci4VgZ/UHBc3h3PcmzmGkEqZGk8HYvFerjQSatRPNbrZYGOgufUCKKjLB2p7FE+BPh6KUET/HfOIQPVks5wWuciGY28ZJ7vLo5fE8RZJYrliLcHgvuGwabOg/s99ZfWbdLNaYng8vJBfvSaQCfwVlOVsejkDLgEkcuspewsbb2Z1NRmt/ZPYjHw06oXnW+8glWOjwaWPn1KuR4jpiMLYjtlJhDGxwI1CSKDB8LkW
 /98hWh0C
 m9iCNi1cKJQkYMHfOWhxlqMNcqr9HQ+r7+4x+p6b4kUXIuy/Syf2WiTECgZOgSswhSx4ArhOUvaVDO3+Qx62a0EmDOQVD4n8lltP5cv/mSdiAp8Kl1aYM4W+y53mdoXyzY2/pT8ZIL+epZQInLkg3akyewfNjaoRECIb39j+Fc0sTizNNNA8Cf2jSvbo9Fecw0en7HjFjNUA4Rp245nuPUZuF79xILTRTM9Cd+K0HyW+7unzHTWiSi4rwno8/yrjstG3xePGRwmuEUeUBbtEfm7VOMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Guillaume,

On Fri, Jul 10, 2026 at 05:02:43PM +0200, Guillaume Morin wrote:
> Hi,
> 
> We've encountered a temporary underflow in the reserved count after a fork when
> a parent unmaps a faulted hugetlb page before a child process. 
> 
> After a reservation is consumed (i.e the page is faulted), if there is a fork()
> and the parent munmaps the page before the child, the reserved count
> underflows. The count is restored when the child unmaps the page/exits. I have
> reproduced the issue in 6.12.95 and 6.18.38. I believe it's still present in
> 7.2-rc2 but didn't try to reproduce.

Thanks for the detailed report and the reproducer.

I reproduced the underflow on current linux-next (7.2.0-rc2-next-20260710)
with your program — it fires on every run. I also confirmed your
folio_mapcount() == 0 check fixes it: with it applied the underflow is gone
across many runs, and the existing hugetlb reservation selftests still pass.

> The patch that seems to have introduced the issue is df7a6d1f6405, "mm/hugetlb:
> restore the reservation if needed"
> 
> I am not sure what the best fix is but checking folio_mapcount() == 0 
> in __unmap_hugepage_range() seems to do the trick
> 
>                 adjust_reservation = false;
>  
>                 spin_lock_irq(&hugetlb_lock);
>                 if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
> -                   folio_test_anon(folio)) {
> +                   folio_test_anon(folio) &&
> +                   folio_mapcount(folio) == 0) {
>                         folio_set_hugetlb_restore_reserve(page_folio(page));
>                         /* Reservation to be adjusted after the spin lock */
>                         adjust_reservation = true;

The fix looks correct to me.

> Reproducer (it only works if HugePages_Rsvd is 0 at the beginning of the test)

Would you be up for turning your reproducer into an expansion of the selftest
I've added a while ago for the fix I've added a while ago:

    tools/testing/selftests/mm/hugetlb_madv_vs_map.c

Your case is a nice complement to it, so it'd be great to have it there.

