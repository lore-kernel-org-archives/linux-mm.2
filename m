Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20CA7F433D6
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 08:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3696B00A8; Fri, 17 Apr 2026 04:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9F36B00A9; Fri, 17 Apr 2026 04:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BFBD6B00AA; Fri, 17 Apr 2026 04:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF2B36B00A8
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:12:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91829BC9B3
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:12:24 +0000 (UTC)
X-FDA: 84667330608.27.EEC96AE
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id A9BBC40008
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:12:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fDcW0GPY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776413542; a=rsa-sha256;
	cv=none;
	b=Lz8J92j3LcX75pfApx+Gs/3SpuzBdVfIIY6eJnEg2EdW4KriL7ucv86tgUV567Q7FDRVZY
	/3ehuzB+OVEKE4hJCXioo/UcHCTNn2cFGQIuHNphp6TsIa1bfobkOSJRqac7y7aCc94caJ
	ytjBxEIicZJ2mYoxcSQ/WfO03RA7Upo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fDcW0GPY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776413542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FVUfbekTe9VVF70JZx+Y2dELk9ZGKMrf0H0ErIcWXs=;
	b=aZYOBg4vY5wuNjYQKhSgHBS3vbhvKzsw6HMzUFfuqHya2rMH9OPT/enzW+rw6NlzmLVN2E
	WPqbcuLBxqjNW/LHvJ7OnJj8Wlup3YBOw39O+2O7E9QlRo30ZgGBkp/TbtDxS4CF/WMMav
	CdDPEdKqJ68xpCekTYuGgPqAtt6QnOg=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-12c726c30efso364650c88.1
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776413541; x=1777018341; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8FVUfbekTe9VVF70JZx+Y2dELk9ZGKMrf0H0ErIcWXs=;
        b=fDcW0GPYYpSsO/GUC8dYtZyROfh6DdPvDPNdG30I5jhKW71nDVdFY/qxYNJ6f8yxWy
         pE9TzkV4FSu49/WTFEf2Zlr0HvU8ZkUWvqK+vYcu6m6vYmEI8OF85Y5eqyBIOhOL1Zk/
         zKc4IHPL8946El+8U9zbu2g06iFbxRea1IR8Qc3bC2Vmcdzw2Cl0NwjLcZ0SzBylghaC
         f++bC8H1m9p/T3U7EJ+1EyWy0x5abPxcUDkgY24lKxjWuNyLG63N6QHKx4hN1AUX/vvo
         suDDaBjb8nHRDPmVKX7WbPfu6FpdPGzorYK0XimCLjo18En3MAU1B8RI0TbuHpiPVNDi
         DC2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776413541; x=1777018341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8FVUfbekTe9VVF70JZx+Y2dELk9ZGKMrf0H0ErIcWXs=;
        b=pw6vFSSLVNEBI1npZ87mRxLEqYDzvd/MX58+1CYut0STG0AGdc8+3IQhhLumGpyYgb
         vg+vzgkl18oceShVzBvTP63wodLn0FrzpV3+dp0zVa6o1j5Dr+pOZgTCIl0a64qSkNpW
         aPn8Nsxb+oeSWzHPzqJplhWx+WQXi45WV/3Bmgl9y2rJpqeIgZQSocooFWbnVWODd2LR
         x6d3FA79gQoq6YPaOCPP8jJ7cDPPHVAvXV/VeWKVWLM7S8yQ9hfI98Koxqvas3KPLiCT
         ZeA60rIZRzYCnjckVbxEszjEHxqdAaO3HRX2n6rH/R2YGpyUXXMN8BiZx0YKelECBYei
         Gh9g==
X-Forwarded-Encrypted: i=1; AFNElJ88mvdOcyqqXBkHU2qkE+XgrFtgpsGS/BeGeHsx8UXeFCSYINxXS2062EfPQnDXLQPNGIFxE2cE9w==@kvack.org
X-Gm-Message-State: AOJu0YzMC8JkOEd/KUwpkkrXNjcs+H5jDYmpHkz4mBIItYjvd6ewnaLx
	z0llFu2JvINhNfhp8OMcUUtlGM3c1MUZm+xOwe8Usz15zf3yY1JP4SHw
X-Gm-Gg: AeBDieuvOYapV24u4Jh8Q/0WhuNTtwRCiDFg7SJH1xHXfdm6FmBccvQi7DEZgy/Z945
	ZS+XWwiVx2/517THTKq35P4Ff5kyS0scuqVhQyGeglztXdobiQ3N3lGwJLLpqMy/MLUR8JbWwC2
	OSFBbiwP1aJZ+rv7PR3TpUF5wsoHejJDpFpnGqn/za/isUI91zbS2XCKvKwdZGB+avTmP4eLNur
	1BB6/NXCDRDQxot+sUnuHhZdFPdAJI5RqrWGscVzP/zhhjRhV994sCxA0NyRTo2k+bIGa+xH81W
	IAfn8Qk42chMzO9qVBZLSOZED+LyI3rSxzra3W+baSeEI7XWvaQ+hqPIipE3vR6uP93B8j/qY73
	t5GVSo9rFwzy4Bq6yavhHkKHGq4NLIpTAY/mp3CQLYmklFuW06Q0GqT/nJp4VMAydJ6E6vpJuGt
	+mNK/F+pl5afM4UePJC3LxUsnReq0fdiMBbjK/xg2vTAywVw==
X-Received: by 2002:a05:7022:6b99:b0:12c:2dd7:9099 with SMTP id a92af1059eb24-12c73f9fb84mr680694c88.30.1776413541268;
        Fri, 17 Apr 2026 01:12:21 -0700 (PDT)
Received: from localhost.localdomain ([104.28.152.117])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c74a20c55sm1161356c88.13.2026.04.17.01.12.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 17 Apr 2026 01:12:20 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: willy@infradead.org
Cc: 21cnbao@gmail.com,
	corbet@lwn.net,
	davem@davemloft.net,
	edumazet@google.com,
	hannes@cmpxchg.org,
	horms@kernel.org,
	jackmanb@google.com,
	kuba@kernel.org,
	kuniyu@google.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linyunsheng@huawei.com,
	mhocko@suse.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	surenb@google.com,
	v-songbaohua@oppo.com,
	vbabka@suse.cz,
	willemb@google.com,
	zhouhuacai@oppo.com,
	ziy@nvidia.com,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
Date: Fri, 17 Apr 2026 16:11:34 +0800
Message-ID: <20260417081138.23426-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aO11jqD6jgNs5h8K@casper.infradead.org>
References: <aO11jqD6jgNs5h8K@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A9BBC40008
X-Rspamd-Server: rspam12
X-Stat-Signature: g4ra11xxea46i6xucnaun9oq3zei8yow
X-Rspam-User: 
X-HE-Tag: 1776413542-274929
X-HE-Meta: U2FsdGVkX18KPO5bzj4u84ISK7lrlfRIj8joM3zUExma3PZWn7bPrxa5DCBPnIY8XNTX3Lqc15kMyh0ouYZAUtP0b2p94lR3KZEw+hNyhV1KKe0UmFZzgOpPdnBoqNcF+I/MFBt67IlxMG+/Ngz5ULBKpIXmuoHJVHbS3lQ/1QMaj4H1xwK/zkciSa8Sw715v0RxH3PN2jdd3xr/hdborw9mUGctVY20P6zmuwNJ2CY4cJtep6oruB64sXzv4PBDbfeF3pwRr9Li+xVa+zuo0gMJQaNB4QZnVbDRp4SEsXR8ootvvCdxXgIaJUlsZgmkpc8tQeytsh1NC3RKfEUpggcrcrtMw3jmgo8ogpL64XcJJHVCLyIEJVv1erttXuUBe71uR8+ao8nYYpobdZWTNIRMBvDwxhiO1AWgPhE7QvhGbRfGBXF7qMXcNFgHGbssBvnCf3wiIPoq2m75+sKANUFDDhO3axvRiqFG/aYZoUn7r2QsvRKYT3nIxrgHoD883kXo1aTBj5Ek0Oj8jDtDlwmTU+kdak4EBcexztSTjM3wijqRSa+zc+/RwZL7qpVbe5A3OQyJESTs0ntwSyzySauC027ahIJgkc1rJnE8SPm2kHE6zzPXv6Tgqz+sdjMFeZ/b0uDiSvZwwOgJbvsvAG8Qe86ozsSoSUtPCEEtMdyc3ylghCAAT3UTQeBXfPXMAfdoW+dyp0FAjeaUCzDnQkkKmTtqyKvskja7QO6Yy0tfWNPp8LIqC9TbgsYHm3qkvxV6SdRSMjgTUC7gVOAZ6MIQih9PHFvpOPaZYELKepiRHB0b17EogtCp4ZMZWub7uM51bq0Ij2ie78p17nwruOgPU0HcEAlHf6tVv9+8zBMwxxnptskSfydZWOUMRBqaTFj9McCLlFnVc7ipDqd615pTbCwuu4xGfV2yaJtgN5xfoV1CF5T8pecIQgEJAxJZScwWDGSkzpdYQtU+JBG
 u9CMCaL+
 j/f3l1/9ZDSm50B0v6Vhz7vYxuVuX78bmjvu6mqBcoWke4d0LUkk4c4DV6iRY02UYvxadx58HaI/qa35NHy20DBZYlH3Gj/7RFuCxk9TbGc4QtfrXNCGduSwfBMeSF3Y70pzhuczis8YgvpFQVDe0IPurmu3cEr9AGld1HDUQtRE5D9kCDETPNXAUfxLXojKwi0c8kM8kAmLRFhrBps/nqE6AHBZDBf0unbGgihU4AqQetkra9ke+t3xPW4Mj5LV/u45n7qOssJr7ld1U/9ZrA9rQkJtbdVV6vHNsEfUSz9dOln+8bG4iNWyysYX1wtO7aS7HRRpEdz+eMtugUh77/2cMOA1URkyC7AhHCOdLktAHDQUonw8i1Plciuj+KtUPIcGn8wfA8O7KVccXIVgqSgxkDZmj47Eo/NunLLG6rWSnnW1PZ2/L0+1LCbP0bAb3EIG+9DT3zoGx244uFjoiwzJkr4w32bXvihV3Qci6YHLGmaG455C+aRnpElR19+y/Ni6nq6A2l2cH4Q+aJWtOpCWN5h3TBA3OUAClS9qlNrVw3z3+rhVGJyW0KN69BeDJWxc2zumyIx6g6d0AA72fuGIQ+tg+1ORXVey4kkmFkuFKLPsOcj3IRrOSKlGwN/YUY9iG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matthew, Barry,

> So, we try to do an order-3 allocation. kswapd runs and ...
> succeeds in creating order-3 pages? Or fails to?
From our reproducer runs, both happen. We observe intermittent order-3
successes, but also frequent high-order failures followed by order-0
fallback.

> If it fails, that's something we need to sort out.
Agreed. In this workload, the bottleneck appears to be contiguity, not
raw reclaimable memory shortage. Order-0 memory remains available while
suitable order-3 blocks are often unavailable.

> If it succeeds, now we have several order-3 pages, great. But where do
> they all go that we need to run kswapd again?
In our runs, order-3 pockets do show up, but they do not last long.
They get consumed quickly by ongoing skb demand, and the pressure returns.

To investigate this, we built a reproducer that keeps creating memory fragments 
while the network stack continuously requests order-3 allocations.[1][2]

Raw sample output (trimmed):
---------------------------------------------------------------------------------------------------
TIME       | BUDDYINFO (Normal Zone)        | MEMINFO                   | KSWAPD CPU & VMSTAT      
---------------------------------------------------------------------------------------------------
11:08:11   | ord0:11622 ord3:0              | Free:96MB Avail:1309MB    | CPU: 10.0%  scan:83107932
[*] PHASE 3: Triggering Order-3 Pressure (UDP Storm).
11:08:15   | ord0:52079 ord3:0              | Free:273MB Avail:1300MB   | CPU: 90.9%  scan:85328881
11:08:16   | ord0:102895 ord3:0             | Free:477MB Avail:1309MB   | CPU: 60.0%  scan:85873777
11:08:17   | ord0:115459 ord3:5             | Free:517MB Avail:1284MB   | CPU: 54.5%  scan:86584389
11:08:18   | ord0:115164 ord3:0             | Free:509MB Avail:1107MB   | CPU: 36.4%  scan:87083561
---------------------------------------------------------------------------------------------------

The current phenomenon we observed is: Free memory is plentiful, Order-0 
pages are abundant, and the network allocation has already successfully 
entered the fallback-to-order-0 path. Everything seems normal on the 
surface, yet kswapd remains trapped in a futile loop.

It appears that kswapd is stuck in the following logic: 
wakeup_kswapd -> pgdat_balance -> __zone_watermark_ok. 

Specifically, in __zone_watermark_ok():

        /* For a high-order request, check at least one suitable page is free */
        for (o = order; o < NR_PAGE_ORDERS; o++) {
                struct free_area *area = &z->free_area[o];
                int mt;

                if (!area->nr_free)
                        continue;

                for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
                        if (!free_area_empty(area, mt))
                                return true;
                }
        }

Because our reproducer keeps creating fragmentation while the network 
stack requests order-3, this loop continues to return 'false' for the 
high-order requirement, even though the system is functionally fine 
with order-0. To be clear, we are not intentionally creating "artificial" 
fragments just for the sake of it. Rather, we designed this reproducer to 
effectively stress-test and expose the existing feedback gap in the 
reclaim/compaction logic—helping to pinpoint why kswapd continues 
thumping CPU cycles to satisfy a watermark that the allocator has 
already abandoned in favor of order-0 fallback.

A related discussion in [3] helps reduce vmpressure noise in this area.
Useful, but it does not close the contiguity gap by itself: high-order
wake/reclaim can still repeat when contiguous blocks cannot be formed.

It seems the current situation directs us to take a much closer look at 
how kswapd behaves in these scenarios. After carefully reviewing 
everyone's input, we believe it is time to do some targeted work on 
handling these high-order page issues. 

We already have some rough ideas and plan to conduct further experiments 
in this area. We would appreciate a broader discussion to help address 
this potential oversight that we might have collectively missed.

Links:
[1] https://github.com/hack-kernel-just-for-fun/kswap/blob/main/kswapd_spin_repro.c
[2] https://github.com/hack-kernel-just-for-fun/kswap/blob/main/kswapd.sh
[3] https://lore.kernel.org/all/20260406195014.112521-1-jp.kobryn@linux.dev/#r

This was reproduced and cross-checked independently by our team
(Wang Lian <lianux.mm@gmail.com> and Kunwu Chan <kunwu.chan@gmail.com>).

--
Best Regards,
wang lian

