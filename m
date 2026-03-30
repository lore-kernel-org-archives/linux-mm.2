Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B02DB1061B22
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 20:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71596B008C; Mon, 30 Mar 2026 16:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D487A6B0095; Mon, 30 Mar 2026 16:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8C2B6B0096; Mon, 30 Mar 2026 16:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9B9F6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:57:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56C3C1A088D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:57:04 +0000 (UTC)
X-FDA: 84603939168.20.04B3284
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2CD10A0007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:57:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=GLosHZyA;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774904222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkx0jjaeGcgjHSJFqfBmG/G2bLO7kuY+j9mFgCW8oA4=;
	b=rJn7m+A+gKPeqtqMVkE0OlepUQZiQrTIvspu3PGR0XzU7kBiAgV8lfjheZFCWGHH56/jzA
	N4HH4gFE8pYGmh9fLET8HizQW1a0PJbX4XCnypNfswTsHdGMGt8tcwX21UR4Us4EBuOWM1
	TtFwebg4rcMhGtXdFrXL+wyq1DtFplc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=GLosHZyA;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774904222; a=rsa-sha256;
	cv=none;
	b=LaKP3rOXgVMkhD2Q45HOdmFm8lg8CH/AiNqd+qtzGDv+oeyX45WN46m+L9a2TdDK7Gs75+
	TzX4ojXDxNUqurqhZ4N9HZygbdzrH7Icd0onQI0TYws0dWCzzkcM/6vDOTy6nDwujjFofN
	t1oSJmPHJR1G0ZRrAlhWd1z2zhHuyV0=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50b2d6f9d00so45193571cf.2
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1774904221; x=1775509021; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xkx0jjaeGcgjHSJFqfBmG/G2bLO7kuY+j9mFgCW8oA4=;
        b=GLosHZyA6decPIhH2MJ/VKB+dXkbVQGSXP4SMJY18WqEAhn397McgAAjJlsX/f0d5P
         uUpzjYtaqaMEGoiJ3mF/6lH2n1ejvpOt7G/QQid8pXjFe46UUESTeOHwMtQMmWXWngcb
         icU2XFAy/KDZMXcWFLxBUc4ob5xBo7tdzLkiOYjRMwt9wbnhboM/I398q15J08bpdLtr
         Pazls6vgC7agpUA0xzankGcSr49aezJKpmeK5uxzmbVZ3NkffNRywS/OK3uyEBodTPjM
         tzoMPCqxqOfLWI3oFDTmJKK6yKzZdT3sANJueiuKGgng2wZvqeJ1ChBxE35qlzfrwD4B
         vNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774904221; x=1775509021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xkx0jjaeGcgjHSJFqfBmG/G2bLO7kuY+j9mFgCW8oA4=;
        b=nCP+HqMA16gMJ9+iyiZHOH/M0o2SPHHOxGgiiWgSr8+p/lAUzM/6bM+fOphvcIj86b
         3sjQkd1flztgqpTXT7Uf5S9WRNnJGoSaxGC6hVYuvvFlJmYR0C+Vh/3UUIb1vlqf2ws5
         7X8/KaQOxRhs4Dpki+0D3rtpCNW9F6IQtlab0Aq7RxberliXN7fRX8Y1nSoxpOHkBOKH
         YpqnTLeP80sq1j40BzLYczjYmfsEnDuplotVhcfvUWabC/Vuvp9dUSO+XWtsmB/P9NDy
         bZlzbJWIq7pKCEU1VoRHMIknuRHBpt7AwzBsqRfTpQL/Ae3LEFnkGy8OCrx0ZwYuOfE0
         ELQg==
X-Forwarded-Encrypted: i=1; AJvYcCX2FUbll1xjvYjQzbB03KyyBOpqplT3JZbH8SMZNFdjqlj16OZLC9+pidvCQe1jCrQ51uuc5pK2Gw==@kvack.org
X-Gm-Message-State: AOJu0YyM+7XLMBdLz8veAj3wUdLInkna9AjtJcdCwcxpd0gFwEPhRqWp
	EvtmG/1ZJvoCn3ROj4GPUcgJxvKxzeD/rG3MyUoNszjzdjpX0YgMtSGiGp44/2ZQwFA=
X-Gm-Gg: ATEYQzze5SsNNPTu4McNwHnhj5zgqZ9QigSxzpT5c7mlsdZ2wyH2m/NleMQuHd0lHFP
	pY825A7yiq03g8VGpBaVCmz+pEBAfUEEm1Zbw442HiIQ94XJit1iEZ4NjLqRlQrBH0M0+T9LaHY
	DgelVvZQScqKAr0PdFP66Oo5Wbr4B1o8boDRO9Kpm27WCIAcWa7TON14kS2BwI7u8ekHoVbDQrF
	1E9tmZ35wqF/p6CMn2DMxmvRrKLylGw0EB8TReKCk5KWcUA7ONPWLFiFSYgW2HYiJ1+YH5M7lO2
	b0r+mgGTHh1TnlKTndRZYE8Rm5jXOzvCNh0pBK48UE0HjKTKQtIAkTsJ4Pvyk5nZFGhi6x85AZu
	29Afr73kSo7MmLwyj4ruYWyf7Ym1Fls/Yjn8+bsAkuEzmEI7uzxDKD9f77NSulfgLbUmftb8Vm2
	AD9/vUq26T2hVc+KkPdSgapg==
X-Received: by 2002:ac8:5848:0:b0:50b:41b7:d6c2 with SMTP id d75a77b69052e-50ba39353a2mr178029041cf.47.1774904220847;
        Mon, 30 Mar 2026 13:57:00 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50bb3df388dsm91004571cf.6.2026.03.30.13.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 13:57:00 -0700 (PDT)
Date: Mon, 30 Mar 2026 16:56:56 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: Re: [PATCH v3 7/7] mm: switch deferred split shrinker to list_lru -
 [s390] panic in __memcg_list_lru_alloc
Message-ID: <acrjmBx_hX-Aa_SH@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-8-hannes@cmpxchg.org>
 <4d3f8d79-3593-47df-9de8-f94f7f09a403@linux.ibm.com>
 <acrf5_rS7hO5Ec0Q@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acrf5_rS7hO5Ec0Q@cmpxchg.org>
X-Rspamd-Queue-Id: 2CD10A0007
X-Stat-Signature: 4as1onojra1rh7di6f9xq8chrbaf4ja6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774904221-706063
X-HE-Meta: U2FsdGVkX19mgt1w8QPLo42dCBvmTj7SiTUj2gL+RPpr2QczgqNEPYa3C1b2xppQKl4ZYZU8SCsWoe6iYF4hRYE3YQJNLetHwXNhCbrjgakr5SY7US9Tv60UUjAY4g+gil0zOJHn+Rsj17i72tCKGKVTL8KEFyiiZOWUce38T+pGV0uqkazJ1BRuzndxFIYR7ltiZ8mBaJrpNFX5AHw8tEjGR2Wj/IXc7tRqYW4kyQ64XfPHmIAsQ29Y4RAntFE4p1F1TRpCBibAkdIMqZWp4BeKl49WIdtNpPWU7XLxnV2bBkwYApeh4ACy9KaKPACxZlbrdHl3b8MrONROM8bxu1Ol0AEA3rcQJg9S2+EknwpxnlZbpS4oUCnr+AIAPfvtAKJcdBRjho+e9qQImejbCi7ydzGXGV6WVfKwnjSr4fOmbCCry3HBkxh9fmhepaHeP34OcSVlkA9YosthVDrj9kqWDSPFMe4cr2y4R1x9SQ04oWSbqfBGM19CWqPetNd2N67LLjnYOXjlzOOBMvFHoXvz7kEe0YqgbT/AEa1Jq3UeuRofOaRzdiJ9HBapY1OIAd4rXAhAKKzMZiEbTX/irTeLoAnDq5/mjRzrbne0mx/jwNEHYAs5ZM0T9zGKVtltqmIDqmCH37+3p+qjF1sqOoL8U55WEj35BaKdbUcD8lePzRu6dzkijCXyBmDx/9U67WP+yeyiWzT/r8qZx7UhWBMw+aGYLK/DGypFnLphSzNU9uBPs6kH42aNU/+2qtmWcF+PDjmEU0CyzBJccTSDdVF3MSpyxaG7FT70pY5vWIHmWOuImx3q5ZV3XJQikrY5txIhwOVuRtVFTn7zrqDPpwOHDOjgMW/Sk+hnjLIpBEypUQvXSUDBQz7gbW/ulqgzxVHc4zTC7vUSwsQ1vUNsUzbSIwVuYSH9osC4Cs+VwI0O+6HoAyKn8phsT/Kx0bIyXDKLqVhMaeFerN8ohlx
 qOrRo6LG
 WPFBhnAKxSTi5QL6akLh/4R7rShxZ6W9dw+H5zSet7pprVOBNGQXSuXPE833RVUsvMS0YVQyMGGQLUej+ei/NSgwfhlpZTU4pJF7kQiac1kX1QyMv1o5m8+27oXi7OVYKy8yIcpErx+TUl/pxWKIAowf5BUodnvO0/xzS5pZAIu1biKAJt9mictLlH5vcyH7/cWzJxFPST3NA0gr1Yj+OJYNdt9ku7BEskGAak9zcYVedE20W6Eutv4G9T7zgVZXkQ67ZDWfrglTE5y3kx9AoEVijRcZn1GMUTInYeZYjIe8+CDhiqsxgIFYO9WwqhBb4vM/OYYfwFBGrLmXRn/YVGfijFC4d+VdmqmR6F4sKw8YgJ5t/uZDXmRBndZ16fWCb22tS7M8y7neYX/XeHRkWa2oG4qGprbYkhUmDXIcdRfn+xRj30YywZZRFiyzH3xx9nQnFc3vNAbPyvhg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 04:41:16PM -0400, Johannes Weiner wrote:
> Hello Mikhail,
> 
> On Mon, Mar 30, 2026 at 06:37:01PM +0200, Mikhail Zaslonko wrote:
> > with this series in linux-next (since next-20260324) I see a reproducible panic on s390 in the
> > dump kernel when running NVMe standalone dump (ngdump).
> > This only happens in the 'capture kernel', normal boot of the same kernel works fine.
> > 
> > [   14.350676] Unable to handle kernel pointer dereference in virtual kernel address space
> > [   14.350682] Failing address: 4000000000000000 TEID: 4000000000000803 ESOP-2 FSI
> > [   14.350686] Fault in home space mode while using kernel ASCE.
> > [   14.350689] AS:0000000002798007 R3:000000002d2c4007 S:000000002d2c3001 P:000000000000013d 
> > [   14.350730] Oops: 0038 ilc:3 [#1]SMP 
> > [   14.350735] Modules linked in: dm_service_time zfcp scsi_transport_fc uvdevice diag288_wdt nvme prng aes_s390 nvme_core des_s390 libdes zcrypt_cex4 dm_mirror dm_region_hash dm_log scsi_dh_rdac scsi_dh_emc scsi_dh_alua paes_s390 crypto_engine pkey_cca pkey_ep11 zcrypt rng_core pkey_pckmo pkey dm_multipath autofs4
> > [   14.350760] CPU: 0 UID: 0 PID: 32 Comm: khugepaged Not tainted 7.0.0-rc5-next-20260324 
> > [   14.350762] Hardware name: IBM 3931 A01 704 (LPAR)
> > [   14.350764] Krnl PSW : 0704d00180000000 000003ffe0443a82 (__memcg_list_lru_alloc+0x52/0x1d0)
> > [   14.350774]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
> > [   14.350776] Krnl GPRS: 0000000000000402 00000000000bece0 0000000000000000 000003ffe1c17928
> > [   14.350778]            00000000001c24ca 0000000000000000 0000000000000000 000003ffe1c17948
> > [   14.350780]            0000000000000000 00000000000824c0 0000037200098000 4000000000000000
> > [   14.350782]            0000000000782400 0000000000000001 0000037fe00f39b8 0000037fe00f3918
> > [   14.350788] Krnl Code: 000003ffe0443a72: a7690000            lghi    %r6,0
> > [   14.350788]            000003ffe0443a76: e380f0a00004        lg      %r8,160(%r15)
> > [   14.350788]           *000003ffe0443a7c: e3b080b80004        lg      %r11,184(%r8)
> > [   14.350788]           >000003ffe0443a82: e330b9400012        lt      %r3,2368(%r11)
> > [   14.350788]            000003ffe0443a88: a7a40065            brc     10,000003ffe0443b52
> > [   14.350788]            000003ffe0443a8c: e3b0f0a00004        lg      %r11,160(%r15)
> > [   14.350788]            000003ffe0443a92: ec68006f007c        cgij    %r6,0,8,000003ffe0443b70
> > [   14.350788]            000003ffe0443a98: e300b9400014        lgf     %r0,2368(%r11)
> > [   14.350825] Call Trace:
> > [   14.350826]  [<000003ffe0443a82>] __memcg_list_lru_alloc+0x52/0x1d0 
> > [   14.350831]  [<000003ffe044529a>] folio_memcg_list_lru_alloc+0xba/0x150 
> > [   14.350834]  [<000003ffe04f279a>] alloc_charge_folio+0x18a/0x250 
> > [   14.350839]  [<000003ffe04f34dc>] collapse_huge_page+0x8c/0x890 
> > [   14.350841]  [<000003ffe04f4222>] collapse_scan_pmd+0x542/0x690 
> > [   14.350844]  [<000003ffe04f65b4>] collapse_single_pmd+0x144/0x240 
> > [   14.350847]  [<000003ffe04f69ce>] collapse_scan_mm_slot.constprop.0+0x31e/0x480 
> > [   14.350849]  [<000003ffe04f6d3c>] khugepaged+0x20c/0x210 
> > [   14.350852]  [<000003ffe019b0a8>] kthread+0x148/0x170 
> > [   14.350856]  [<000003ffe0119fec>] __ret_from_fork+0x3c/0x240 
> > [   14.350860]  [<000003ffe0ffa4b2>] ret_from_fork+0xa/0x30 
> > [   14.350865] Last Breaking-Event-Address:
> > [   14.350865]  [<000003ffe0445294>] folio_memcg_list_lru_alloc+0xb4/0x150
> > [   14.350870] Kernel panic - not syncing: Fatal exception: panic_on_oops

Can you verify whether the kdump kernel boots with
cgroup_disable=memory?

I think there is an issue with how we call __list_lru_init(). The
existing callsites had their own memcg_kmem_online() guards. But the
THP one does not, so we're creating a memcg-aware list_lru, but the
do-while hierarchy walk in __memcg_list_lru_alloc() runs into a NULL
memcg.

Can you try the below on top of that -next checkout?

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 1ccdd45b1d14..7c7024e33653 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -637,7 +637,7 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
 	else
 		lru->shrinker_id = -1;
 
-	if (mem_cgroup_kmem_disabled())
+	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
 		memcg_aware = false;
 #endif

