Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF743D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 12:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A50B6B002D; Mon,  1 Dec 2025 07:29:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255596B008C; Mon,  1 Dec 2025 07:29:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1445D6B0092; Mon,  1 Dec 2025 07:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 013516B002D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:29:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A63AF1DF156
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:29:50 +0000 (UTC)
X-FDA: 84170833740.10.341EFA6
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	by imf27.hostedemail.com (Postfix) with ESMTP id BA8FC40004
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:29:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h5p7Gxmk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764592188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkcKCSwxS1bv/iV/Sg0OoUr6EksjxSiSti7P7JUxDRg=;
	b=wmi+/8tPHLtyB1GW0HDKca08qHp4lr9ZPLvRgv/WKHKLfsCnvc3La2lTyN5l+f2WIOvxVU
	0Sph5MYOx84YXuDkagBv4SOyFbFg1v9xf8Oc/do2RXlIO5DGMRItthRuOMp/gSuRPSy94O
	x6FDaUJ2FxDmbH5XKuzfZj3dx8W4sG4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h5p7Gxmk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764592188; a=rsa-sha256;
	cv=none;
	b=pe/w7Evq6q7WUARKhhCKXB32xxuNU9SpfBqk0Y+L5sFYvVECGsr3XT7xmVIISerWDz/Qrt
	um6O/GwuYOedD9LuyfqPc4H8IU0jYVdzyeMVPS54jx0k2oM3+m7TmsFNH7fsGEDDYc4JMI
	1s0LWMF5zNpDMfVYh7ptte4AjpLK+og=
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-7b89c1ce9easo4933620b3a.2
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 04:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764592187; x=1765196987; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VkcKCSwxS1bv/iV/Sg0OoUr6EksjxSiSti7P7JUxDRg=;
        b=h5p7GxmkyEWI1fm4pqinzg7OiBAOtpB9davazIICk2NuoZ6/aB0Y4kemDEu/WbOfXB
         /ijebZrMakYG/QbKU9EqIIQipGy9tpUP8tPG6QNOW1qNBnwu6NF7nVBUuf0WyJFhkKeO
         Qr03V8U3l4pwKY6xihoUFApkxW0rf5y6B4kyp3KG4J4nx75nuiE8OEG1oVYwuRJpjv4w
         z/5Tl4OOsPvYrfGYxCCr8ynS1jPPXXvTT5WrAEjSQahI8ObvL2pD3yQxdSLbo4R3yOKc
         xgvV9VyQ2QtMXomwGNPLTTFt9pz0cK+15p6pT1Xu4L6zaP1xFZeGXhAWXJyXPBe+OLNE
         wARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764592187; x=1765196987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VkcKCSwxS1bv/iV/Sg0OoUr6EksjxSiSti7P7JUxDRg=;
        b=KKD+DN/RwZGaaZYDMB89B9s9ihPv0+WhPr6tz7FY3vIf6Tse7NdkUZh1Q0ZRF5l2ZB
         TonbHVC/ltrwwEAKwWRAWLZwjj2MV+/ACzOaClVxD876ScKfCEGbcgGcCNh71BF6Twff
         rPZUfLL43f5FjaxKJxK6vu0+wfCltiNaDAY/KskpktEaJiE/QCN4TLCAZF82BkV3JYdn
         X3pcO5xvt/zXrbbavHvVamiFvF9juF6cY3zJYa7vVtQFToYPTqQxwcuuq8c2hxKu1DPM
         cNHH50X5db/H4Cz8rsP+jVJkvej2FLgJbuNoRMiYi/xfd6bxJIOBnWEQQ1fqmAXWYPA7
         VnRQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0s9ApwHoF8R0aTDXxzH0PKzWe2SiiQmvTPPFmcvXR57RcvPcnTrdMVcGlC5pHl7zGxiBr9MsHiw==@kvack.org
X-Gm-Message-State: AOJu0Yxo0lAZVTWuizXw8Pk74+FEFzyZ7kSjgjCGz7mp7e2badWNMFXn
	LIYJ3urblk4d45Tfh4FlK3i+JYw/Mu88m1LM5kOy/6wog8wgB7GaiZbd
X-Gm-Gg: ASbGncskpqMzpvsR2eQvT1UyJMCXiFSplDT1MNxOUdDfZBaqYvtXXz5qEKtZTe5gKax
	V6NNodqDLncf83Ab4WmIOQfu7ucYJJEvzOt2dBn1Btbyr6JlHV3tN+3oCHGBGPEqsiX4Sm/Kpnq
	McOMbdfpR0sHdva7I5FbCqS7VH2xhamger8xBGpxAyXWYGhkQBwH2TNe0c2G4IHdkPmH/lZfrwE
	9/Rhr/fDvVa2jTk0Cdki+5Dt3kPSdIHeflui7H+DZWNcFYE86j9PxIGBp2q1KxW4hmF/0lgSGSA
	fJdvIbePO+AI290kVWhUY/YAsOmOv+VWAoWmisa/kpBZsWQozjEvjsK4+34+R7s5Adi0AuB86P0
	NRmbuwRspRynM6yyFOZWq5iLrGbFwRy7ZForMiChi4arAYEK/fCtgX6M/vNaNPL1er//MBEWxwG
	t6VmzzjId39tg9qcNSkungi8kcI8nX1VPtWDe7Zn0=
X-Google-Smtp-Source: AGHT+IEE7DcwRriLu6ETXghELWAMW/87k1V07UOn4NNFRDygJlCVjtSakw3tpepulcWR95z5SHuocQ==
X-Received: by 2002:a05:6a00:13a3:b0:7a4:470a:8f59 with SMTP id d2e1a72fcca58-7c58c7a8631mr34610149b3a.13.1764592187387;
        Mon, 01 Dec 2025 04:29:47 -0800 (PST)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:b8f3:d910:6512:1367])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d150b66c67sm13494915b3a.13.2025.12.01.04.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 04:29:47 -0800 (PST)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: 21cnbao@gmail.com,
	zhongjinji@honor.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@suse.cz,
	weixugc@google.com,
	yuanchu@google.com,
	zhanghongru06@gmail.com,
	zhanghongru@xiaomi.com,
	ziy@nvidia.com
Subject: Re: [PATCH 2/3] mm/vmstat: get fragmentation statistics from per-migragetype count
Date: Mon,  1 Dec 2025 20:29:12 +0800
Message-ID: <20251201122912.348142-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAGsJ_4xtc7ipFKYNQkGa-dSn7C8S7-J8LURqYrehfgenfPT=+w@mail.gmail.com>
References: <CAGsJ_4xtc7ipFKYNQkGa-dSn7C8S7-J8LURqYrehfgenfPT=+w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BA8FC40004
X-Rspamd-Server: rspam11
X-Stat-Signature: x945eraqm5wetem8anuc6ggtm19bwu4g
X-HE-Tag: 1764592188-978244
X-HE-Meta: U2FsdGVkX1/uFkXTO76oC8vepfPrKsOOu//Ta7/kSXV3+Olr6jzWzpH7SwHi+ZijnPSl9vLLh57NsXz6KnZJwQvUSdaxoFHcmx44TaXuhrP2ofmu/N6U7fmMzty7T/ABDmGYSgKYFnWb2m2jlyW4VeqpjYbV53GrKBn68ajDWZ/WXFHl0AMC3ciEQDpDfFooyZL19j56/Jr4uQZwpm2At1/gbNXJ0qt4era33kM1+6H4K0hthl/hKMgVlSlo44aTwaWYLIdIoKkOZNyWgLp+fxuR4oDtBl0A9GuIlU8yH4p9ZZRs4fuUGnpr56LKlT3VVbMdN14qjazkde1+EG4QTYwspZjVwQkgKw3jjSB1QF3BE3WOnLYYOGVxfBTk4bJh9fvBZZoQUZlUlqLAGvr5Uw3Hr6CG0tJMAfTnCySdgO5dzN/gZQ15UKD6T90M/uV6a0K4PTFLC8izVDri3FdAjyicrlvyFpavNn7r3cIT/+Pbx1fvXDfWp1lQQObTBHATi5RqHug/LyxKv8u+WFPl9MiVAOv4N4FRmUzvj+KTAwtoQBX0P6kzWzIw8Cz/rBLMMhyNuuvb3CSUkLcMG9TNiug+W/vA9mmBYzLd2S3cAQltADCe5sBjQJKJXSQNzcNW9bwIsEPrkTOuMcvhNdu1cEF3DAtIrz4oiwOn0z1T+p19h8MOrDPsslUdb4TW0Rsk4/z61LsqXE6dhpn3iJTrnoaxH14NkM3HvGIhBoTLKVYcf+8K14Q9o288oVIiPg8tEiG67kYtl8Wt5tVJZhngYATlnrVI+HvRVn1NizMvPPXJS1DtTrglUWRqfnmwnRBXGHXjKtW8jwK/UgueW4DSuYLtNJPb3YTpe71CjvhFhP053AwRVUW8kih8ICQw6xHDN++A+YtIFSq5ly2L9YV2GFGd3CErvFGvAFQlxU4A0le2bf1PFyZ9Z88ZWHM45O7oqnEstXc/awlrQfGsvde
 XGijYYHq
 f6fCZdsdrhv9mFLW3jU70D2MGiKfVGxHNqBI4/s7wv5ac2XO4OcWn5rjH8Sk+nPzuaHMJ2tZDYzpzxdHIxY6geDnsXZjEsk6KtvEPrhYkxCbg/f0AfRZa4syrYPslU/nHXQtTR6X41c3DSu78G7nCGR9A3HfMVJtovQ1olcJ7MMRNGK/DOkZJs1MquXEJpIXKjam9k/X+tfnlmurXDRt6zDE8vBATF0E1FkIEtrv6x5mMQw6kjsno4va6l9TjGqYGp8UtWiyhm49HHJmoNmOjBQQbG63MHM3rO+0pkHzAb/GJsQr7+eKHBKEZl92CPG8dPHqWbhbNHokuFJpFWBR01pvZLiU4vX9DCvCnychfkXW8tYJV3ig5iTxI6naOrWcT6nDezz0YfWg1QYYmE/OqBArcJV+QN9kmUUUvaqmIQONdc7MXOFqYi6frOkYJE6ymDmsl+1EqIGSaoc03X/KaB3ODR4vZdBjfq2DKVO830smkbsP0p7P3BGKmm6g32enWQYxpN2itxe/ZCDg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Right. If we want the freecount to accurately reflect the current system
> state, we still need to take the zone lock.

Yeah, as I mentioned in patch (2/3), this implementation has accuracy
limitation:

    "Accuracy. Both implementations have accuracy limitations. The previous
    implementation required acquiring and releasing the zone lock for counting
    each order and migratetype, making it potentially inaccurate. Under high
    memory pressure, accuracy would further degrade due to zone lock
    contention or fragmentation. The new implementation collects data within a
    short time window, which helps maintain relatively small errors, and is
    unaffected by memory pressure. Furthermore, user-space memory management
    components inherently experience decision latency - by the time they
    process the collected data and execute actions, the memory state has
    already changed. This means that even perfectly accurate data at
    collection time becomes stale by decision time. Considering these factors,
    the accuracy trade-off introduced by the new implementation should be
    acceptable for practical use cases, offering a balance between performance
    and accuracy requirements."

Additional data:
1. average latency of pagetypeinfo_showfree_print() over 1,000,000 
   times is 4.67 us

2. average latency is 125 ns, if seq_printf() is taken out of the loop

Example code:

+unsigned long total_lat = 0;
+unsigned long total_count = 0;
+
 static void pagetypeinfo_showfree_print(struct seq_file *m,
                                        pg_data_t *pgdat, struct zone *zone)
 {
        int order, mtype;
+       ktime_t start;
+       u64 lat;
+       unsigned long freecounts[NR_PAGE_ORDERS][MIGRATE_TYPES]; /* ignore potential stack overflow */
+
+       start = ktime_get();
+       for (order = 0; order < NR_PAGE_ORDERS; ++order)
+               for (mtype = 0; mtype < MIGRATE_TYPES; mtype++)
+                       freecounts[order][mtype] = READ_ONCE(zone->free_area[order].mt_nr_free[mtype]);
+
+       lat = ktime_to_ns(ktime_sub(ktime_get(), start));
+       total_count++;
+       total_lat += lat;
 
        for (mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
                seq_printf(m, "Node %4d, zone %8s, type %12s ",
@@ -1594,7 +1609,7 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
                        bool overflow = false;
 
                        /* Keep the same output format for user-space tools compatibility */
-                       freecount = READ_ONCE(zone->free_area[order].mt_nr_free[mtype]);
+                       freecount = freecounts[order][mtype];
                        if (freecount >= 100000) {
                                overflow = true;
                                freecount = 100000;
@@ -1692,6 +1707,13 @@ static void pagetypeinfo_showmixedcount(struct seq_file *m, pg_data_t *pgdat)
 #endif /* CONFIG_PAGE_OWNER */
 }

I think both are small time window (if IRQ is disabled, latency is more
deterministic).

> Multiple independent WRITE_ONCE and READ_ONCE operations do not guarantee
> correctness. They may ensure single-copy atomicity per access, but not for the
> overall result.

I know this does not guarantee correctness of the overall result.
READ_ONCE() and WRITE_ONCE() in this patch are used to avoid potential
store tearing and read tearing caused by compiler optimizations.

In fact, I have already noticed /proc/buddyinfo, which collects data under
zone lock and uses data_race to avoid KCSAN reports. But I'm wondering if
we could remove its zone lock as well, for the same reasons as
/proc/pagetypeinfo.

