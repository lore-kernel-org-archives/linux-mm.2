Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 532491061B1F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 20:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C016B008C; Mon, 30 Mar 2026 16:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0C9E6B0098; Mon, 30 Mar 2026 16:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49E36B0099; Mon, 30 Mar 2026 16:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95DFA6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:41:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D77AE0E48
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:41:19 +0000 (UTC)
X-FDA: 84603899478.28.72FA007
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 02A1180011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:41:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=LMthJgIe;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=LMthJgIe;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774903277; a=rsa-sha256;
	cv=none;
	b=hp4lJbW8b+5hla3u14m+1y5qe0AETsVtPTS7KQ2uhMEIBxdaI3GBIEog9bmxHvv11z7c2b
	VSZUQLZv2LPnVw5C1Mzr1hiw6hIjXA+1UfCZP6g8WEIZlguS4NQwWtaZa3nntC9APu+JO9
	cUQetkwh82d1IlW6LWF2q52RwPs/59s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774903277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wXDBgKhrFka/ZVFt0EHIQCYNPYyORHFuU+s65Tm4Q4=;
	b=3e1AUPbtwz2Oj6d+6TCWXjtg625u8Qi/gpkig1qqW10zWoQeoIpz0MrC5KWy8AWiilD6Se
	sFd3J1o6eLblQoRcJjT4xFNN9VN1y7CZHZe5SvQOP1Q+f7bITlu15D0z0aapk6Sf2GnYpo
	ro2SYDwblQQWIv8+2I+GiJvwwlFb7eE=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cbb6d5f780so561314785a.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1774903276; x=1775508076; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4wXDBgKhrFka/ZVFt0EHIQCYNPYyORHFuU+s65Tm4Q4=;
        b=LMthJgIe66tzQ4II394ktA6i7HbWFWJLzekJQf21xkNoLXN9jWagtS6if9QUNWpd6V
         L/kYv28BB5L6rhhi1FYW6NH2sNcSk9S1T8W4RR3RxLUC0WbfptQjF6l1DsKEtN04zkOy
         9PKCR1sc1hdkDtOOP2Blx/46yG78qH3iUkvJ8Gu2Ghp6SxLphR8uOkn6x75jqBI6r1eT
         k18kw1SM3G4QYyTsuqYfI2xbM00v60LtyfemMR0ZCv+aAMvFA3mkaPPAUVjrw7wonKDk
         aX4zsLYlA/FXUqN1tKJ1QvMFFAAR3AcLlg10sssx5IHs1LGaLwHjU8oNCCf7zGG7yQ9k
         W1JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774903276; x=1775508076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4wXDBgKhrFka/ZVFt0EHIQCYNPYyORHFuU+s65Tm4Q4=;
        b=Lwh1fxVyk3vOJQqE+a0ifYkHtUe2ui1/qcLgQsadvCm0JhN6ObhVpA0ZhYibvajoSZ
         PHr5l4mvr2rNtMRJiKd6IC61Fg9O/+r/EgiTjiLxh1zBhvgx5T03HMU0bD/20AOF8Wy0
         vS/L3VZbOuNPQKO82dFLH3MvXt4baYMs4scBXaRcSUURyNfWjF/pdSiHbEb+WT7Zo8CA
         9hSIDOocTcfS4W4CsfsoNFvk6wY1DyuCH1prVhz4rScVLK3BAIssvpB6/34O7cFgePUm
         H4eKCIJHK+rBstxphTp7YG+CUestK7aAAcbCQ6POltjDa959OulTGXOyVEivtjd+BhEO
         aSBg==
X-Forwarded-Encrypted: i=1; AJvYcCWYvh2OrZI058kK/YM6qQ0HaVNcSATVPzcNeIh5a5DN4ZEpQUi7toBdUUIQNcQGdn4NDvez3NgY1A==@kvack.org
X-Gm-Message-State: AOJu0Yy2NUiWirpCRs8dK2+W7r0pBityoA2i5Ha+5oEbLsfo2eRB5Wgq
	p+FNqvJ7X6P0dcjCAkigomIJRX+FnKHyKpbNlHW5lrpbrKlEDfjP1/g0JyojUqniTjg=
X-Gm-Gg: ATEYQzzKBD1XATzuBxgypgqNQDj9hNxrpclqN5huk1nO76XKLZngpOhd6ylY2CveH65
	7AJnpS8bCCSfKWNaEitw/OhhyVHmOt4pC/kZ2FlyOyjYTmDDsNla1rycrFR5uL422NPRBO3AfoU
	MqONCQYiAO3GxuN9/cles0kisxNWAVnZ1+/Z4PCywnJNakmteII5KX2AhT9mRYhifPE50LeMYgj
	VYs9Yt04N5EoHIFkE737vqDlGRL6Vd03Gx/gMuE05yimWwsIJbv6nuw0TEowXYJ1iwo+z90ELdI
	4ktgj4lC5gkCS2fPTPE5MOqeqPvu8mSzu1L//x6Uf/sIqJcOaVIC2591h4NWK+MGqDRTdXd+YQy
	Vt5xtjkwQEWa9G6p4oKBWTXWzy+6FRgMHc+2iXMvUr5HIy5skNbDxKcTFXr/WkgmvRf45LXmiGe
	WQZDFtwmV9NKYTKI4B18ZBGw/rgb0sU8Zs
X-Received: by 2002:a05:620a:46a7:b0:8cd:b7bc:5184 with SMTP id af79cd13be357-8d01c617642mr1827202885a.8.1774903275859;
        Mon, 30 Mar 2026 13:41:15 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d027edc650sm677771885a.6.2026.03.30.13.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 13:41:15 -0700 (PDT)
Date: Mon, 30 Mar 2026 16:41:11 -0400
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
Message-ID: <acrf5_rS7hO5Ec0Q@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-8-hannes@cmpxchg.org>
 <4d3f8d79-3593-47df-9de8-f94f7f09a403@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d3f8d79-3593-47df-9de8-f94f7f09a403@linux.ibm.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 02A1180011
X-Stat-Signature: 3qm6u9errc1f6o4k57roh7zods6x134e
X-Rspam-User: 
X-HE-Tag: 1774903276-950231
X-HE-Meta: U2FsdGVkX1+vroVPueCLQCJW9m1fCAqDkJXaX0gUtSPac0JwKlfCydVpNQABKBAJj/LkoYxXnQJL6nDe7rjoDI8/0W31C5GmMrq/j+xkvzA+SF2urLDTtaxzFTIPoOVcvuS27RyQAkvHMbfA1+TOC/QNhllv5E5gZLYmOqxGYdiraSmFFI6A6FHNtXgjcgszF3Jbc2tn3aUyhlFMxvpQg521MNTM7yRd4xGtxxxedPJifrw3IpgNFZ30hLTWg0WFuh7/g7TwhZ1KcR7GMJt2ivxylzHW88EOpVrJrh3DHY9aiuvSLdstoAGOqd8BxDVE1CmTvaSgTB12lQIkfYpSHpaUaAMgxaL2aBTQoiIYbUZiZ+9jTA0OTAxoXTTEJ/DpHsJIzd9cV0qZx7/J0sleUrXN+WZfdueG1At7c+YuCOg2SNGV8r9AP515lROxkotYYCQ0OwKJLHbXH8ytZkaNU1Ah5RoL+wBrIuyqo4NAGwNYGyO64EQE/WtoO01Qa7Kfdx/0YWqcDUzi2cH4QX1FJbi2y9R+n6znXSItJeiVsNS4Q/kT5GVdiNiGlR6lgXQndijraG+RMMcSU5uS4R37FL0+t7ltl3lSZpzHcH1u25lyb5gaFH6CmY4N7RpXnDzBEPjH61gQovvsq3AKu1iMqkhXUwyxs6kxe0n8lWinEDtQ9IvKIfLBhryHgVwutatI26afj4PP8aqHjd7dF1ZREIRQv0jrt1gFSojSz5bJ2r4iV9Yz0j8stMzWNVdih2wK2mYmdKvA5vOZYoiVHqY6QWmhjoYCjQ9NixdsdNX2Ag89in6cv39y/Luq0yd8BoujOzs+O3pUj7wOfRREA4N1Sv4svo2tOy6s2unek2+pw5mr/eM4Lsq0oip+4Lka0xtqgVH9uA8fxqyP1jdZKK3QNv+yrqVbqGfxSaBxyJn0sXHYgCAtuedHeWZYMJjNxmiyfPiO41eeKLqQLjr7MBf
 mpqz9gY0
 maZYREc5x0viAYGr/t8AAwXq361ITBsaQhSfSt0IzF6MbeVUAK+ME0+5dsj4mDf/qZ1wiVDcglaYzqMl8dVbmSE5WR0VLVJPD5duJ2+cOsCcDgIGBYT3x2URB8GK4BrO4EcTmp1y/SRVzbWrCHXXuaOZIh8W9j08G/wRNGGgzCDNTVaZs+MtJnJXATenqxkG7AZdmmcdDbhfacm618/HypT2+ovYgg6ygPCkKv3V12KwGk53bdYS7ylHcZLNceQu/91QjIjcBHI08PZO9++tUHl7VCGVTXbW/v+pr2+p8QnaZ91X0degpS9KbffJcjr1RtYL+ACxnCODILAsG8jURjMpU9N3dIpkUi3lEvC7wll5VGz1bh3RNMs4Av8VOIN550LsurNx1bxYdvYr2qisEQ+8hLrrUT4lADpqdcyUgVepZL5G9htpo1Me9YZOs/FeGoFix2aXcEwoniIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Mikhail,

On Mon, Mar 30, 2026 at 06:37:01PM +0200, Mikhail Zaslonko wrote:
> with this series in linux-next (since next-20260324) I see a reproducible panic on s390 in the
> dump kernel when running NVMe standalone dump (ngdump).
> This only happens in the 'capture kernel', normal boot of the same kernel works fine.
> 
> [   14.350676] Unable to handle kernel pointer dereference in virtual kernel address space
> [   14.350682] Failing address: 4000000000000000 TEID: 4000000000000803 ESOP-2 FSI
> [   14.350686] Fault in home space mode while using kernel ASCE.
> [   14.350689] AS:0000000002798007 R3:000000002d2c4007 S:000000002d2c3001 P:000000000000013d 
> [   14.350730] Oops: 0038 ilc:3 [#1]SMP 
> [   14.350735] Modules linked in: dm_service_time zfcp scsi_transport_fc uvdevice diag288_wdt nvme prng aes_s390 nvme_core des_s390 libdes zcrypt_cex4 dm_mirror dm_region_hash dm_log scsi_dh_rdac scsi_dh_emc scsi_dh_alua paes_s390 crypto_engine pkey_cca pkey_ep11 zcrypt rng_core pkey_pckmo pkey dm_multipath autofs4
> [   14.350760] CPU: 0 UID: 0 PID: 32 Comm: khugepaged Not tainted 7.0.0-rc5-next-20260324 
> [   14.350762] Hardware name: IBM 3931 A01 704 (LPAR)
> [   14.350764] Krnl PSW : 0704d00180000000 000003ffe0443a82 (__memcg_list_lru_alloc+0x52/0x1d0)
> [   14.350774]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
> [   14.350776] Krnl GPRS: 0000000000000402 00000000000bece0 0000000000000000 000003ffe1c17928
> [   14.350778]            00000000001c24ca 0000000000000000 0000000000000000 000003ffe1c17948
> [   14.350780]            0000000000000000 00000000000824c0 0000037200098000 4000000000000000
> [   14.350782]            0000000000782400 0000000000000001 0000037fe00f39b8 0000037fe00f3918
> [   14.350788] Krnl Code: 000003ffe0443a72: a7690000            lghi    %r6,0
> [   14.350788]            000003ffe0443a76: e380f0a00004        lg      %r8,160(%r15)
> [   14.350788]           *000003ffe0443a7c: e3b080b80004        lg      %r11,184(%r8)
> [   14.350788]           >000003ffe0443a82: e330b9400012        lt      %r3,2368(%r11)
> [   14.350788]            000003ffe0443a88: a7a40065            brc     10,000003ffe0443b52
> [   14.350788]            000003ffe0443a8c: e3b0f0a00004        lg      %r11,160(%r15)
> [   14.350788]            000003ffe0443a92: ec68006f007c        cgij    %r6,0,8,000003ffe0443b70
> [   14.350788]            000003ffe0443a98: e300b9400014        lgf     %r0,2368(%r11)
> [   14.350825] Call Trace:
> [   14.350826]  [<000003ffe0443a82>] __memcg_list_lru_alloc+0x52/0x1d0 
> [   14.350831]  [<000003ffe044529a>] folio_memcg_list_lru_alloc+0xba/0x150 
> [   14.350834]  [<000003ffe04f279a>] alloc_charge_folio+0x18a/0x250 
> [   14.350839]  [<000003ffe04f34dc>] collapse_huge_page+0x8c/0x890 
> [   14.350841]  [<000003ffe04f4222>] collapse_scan_pmd+0x542/0x690 
> [   14.350844]  [<000003ffe04f65b4>] collapse_single_pmd+0x144/0x240 
> [   14.350847]  [<000003ffe04f69ce>] collapse_scan_mm_slot.constprop.0+0x31e/0x480 
> [   14.350849]  [<000003ffe04f6d3c>] khugepaged+0x20c/0x210 
> [   14.350852]  [<000003ffe019b0a8>] kthread+0x148/0x170 
> [   14.350856]  [<000003ffe0119fec>] __ret_from_fork+0x3c/0x240 
> [   14.350860]  [<000003ffe0ffa4b2>] ret_from_fork+0xa/0x30 
> [   14.350865] Last Breaking-Event-Address:
> [   14.350865]  [<000003ffe0445294>] folio_memcg_list_lru_alloc+0xb4/0x150
> [   14.350870] Kernel panic - not syncing: Fatal exception: panic_on_oops

Thanks for the report. Would you be able to correlate the function
offset in __memcg_list_lru_alloc() to C code? It would be very useful
to understand *which* pointer or data structure it's tripping over.

thp_shrinker_init() is called before start_stop_khugepaged(), so I am
not sure how we could have invalid/uninitialized list_lru structures.

Could you extract the instruction stream sequence surrounding the
crash? I don't see a Code: line, but maybe you can correlate it with
objdump? And then correlate it with C code (make mm/list_lru.lst e.g.)

That would be super helpful. Sorry about the breakage.

