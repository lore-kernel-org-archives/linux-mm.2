Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232B4C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0A08E0008; Wed,  6 Aug 2025 12:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0AA8E0003; Wed,  6 Aug 2025 12:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88FF28E0008; Wed,  6 Aug 2025 12:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 771DD8E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:18:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23722136664
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:18:41 +0000 (UTC)
X-FDA: 83746840842.26.262753D
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id E7D7310000A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:18:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EAhZgYzC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754497118;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2V8Av5scJE14Rv5wfsiXUc3HN8xsIIfjL3a9op53nI=;
	b=BrxfCF0JZk335/4RM2itowXrBHl1yoql3HiNKfiwp/mPqf9ptiLehPX/jqTN81f5aUQxzl
	OybOpt67QKOF45Qdxhw3g5m0CgMiWUjjpSq35Vn/K53J0Lw2iV+km9DgMZuTHNIilEdj4X
	uGQaq+/e66WrdqqfzHBUEyKWvbkl0Zs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754497118; a=rsa-sha256;
	cv=none;
	b=S6W1Aap8wCMBzIGnhIEBJOtvVEy8TIC06RsN+/y9Ex5qa/dsnW52r6gJDlo4LSsUKmQ/cs
	++MOXOp3ehn5sfxhHj5+5/ap4lmxb/xHAoNsygcUGfSL2dt+hBJxl6OldFFEhpGQ2V+nBP
	afkOV73SWxDzNi+LKgDgZtiVnZqO1hU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EAhZgYzC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7e699d1179cso4428085a.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 09:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754497118; x=1755101918; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S2V8Av5scJE14Rv5wfsiXUc3HN8xsIIfjL3a9op53nI=;
        b=EAhZgYzCYbSF5vEnE5DVuaWLfxRf+j/HpRN5vYEAO79nkn0wFO/izU8tVMKiYvIegj
         2ZYv8Vr7IZP+HnkARL4TTijkgOdsYssKv8HyiDT+1grDuYwq75BhMIgGDSesjGbN2Zuw
         oRSHtMd165Nmp0RolGExQWyDIKDn4R7tdq4wOc3CmqwzbbKYGNy/4bRpBvaTFEBy+XSd
         gvh90vBTcJhcCHSCZX6WdWQaXMH7OnVotl8ovH4Wu8PZOv66U7WjwCfxCtx4Luowdw8G
         dApcuokHvyjFcVtIw1wPAetU9BONZLvsX5xEvohLAHJhGxxAW5C0NRl7j6K6alWLoHUo
         NbUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754497118; x=1755101918;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S2V8Av5scJE14Rv5wfsiXUc3HN8xsIIfjL3a9op53nI=;
        b=UTl9BvAl8DH3EpYKuzzYPNMT54mLYb0TDBRmbWEQ+mLG138NVUWDWO03wyVaMuSlrP
         DHCTlUmQgL3gOchzxJCJ4uIg6mEXJwswsIMLJM7vmIcKa42KiF1N+uqg2S79sINc+JDn
         NoEX20gknv9JL2e4S+ICiQUYh2UMTo+wo1NgoDRLOgKPryd7UhNQqIv2IGgWO9iEahVZ
         GQWXP8leNyy252M3Bw/3DPx95Tuz/cqjc3EqvwPslksx+oYi/vDeZ1rwIUZvQuNTHshg
         jLvoG6+cOdEo8DD0jusrk3gAkzcYxLxbhom6+W/L80h27L/9ly/9DIuou9iaI3b0sSQH
         RZ4g==
X-Gm-Message-State: AOJu0YwqYotGclyLZ6eyu9acmtGrdVPhekn50ftXifT9r5uzG3ArP0ea
	ZkPacfyJEK29kxkWQpFYiqrqRxomj9uvD4aHJdBsywccyroq1fXci4sNgyBOuiVLJ2I=
X-Gm-Gg: ASbGnctYjt/XuBtFuylNpoLGBh4OkPJJS98t30jt8UGrfOoy8zkyB5eogmdFV/YaJg+
	0Bej/tmyHdXyoiinOO1c2AojvCGEnFy2+jp6xLBerMGuEr9eUEa1DNXu+n07KlFQ0RBVRmfi5Tc
	yyCHPH1ufO872fHdxTfPE9FW7CnkmLKcL7JdHz02jQvz2EKdAIX4VOk5lL0YyoROwy0NYTu39F/
	IS5llB/nJrt1kQ1Yw3khOMoYiEbbJTXjmYhg6O7sW6TvSo6/vA1qzYRASnGocFhV6TRXofINt5q
	UEWhEKDClXMCkdMppVuvcY69mMHY3YIRJgk5FMjSmpIW+o+ogwB+TPh5+PKbcKdw8Fu2V2Tja21
	gudLWTSngeV0VzCRi0BHDnxBrL+ouNNAzb9jKhA==
X-Google-Smtp-Source: AGHT+IGtwj+7xMQjpcrNPb4NOoKMCSSUbHYA/8w8TOKtmXnOhSASyNJ1d9KeQ8Tqwyjf9iYGjSUHLw==
X-Received: by 2002:a05:620a:4150:b0:7e6:7c82:f0ec with SMTP id af79cd13be357-7e814d27a51mr553391185a.17.1754497117544;
        Wed, 06 Aug 2025 09:18:37 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e7fa35144esm464081885a.48.2025.08.06.09.18.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 06 Aug 2025 09:18:37 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v2 1/3] mm, swap: only scan one cluster in fragment list
Date: Thu,  7 Aug 2025 00:17:46 +0800
Message-ID: <20250806161748.76651-2-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250806161748.76651-1-ryncsn@gmail.com>
References: <20250806161748.76651-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8ojwowgze3hyyytcpcx5zcfo6w1n1mrd
X-Rspamd-Queue-Id: E7D7310000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754497118-321709
X-HE-Meta: U2FsdGVkX19ALJ780zVlFUENe7qd8IPO/8OCS8FoUgDFiFktA3FkK30ubmJtMbHYxehvFeW/xRV62z8xKAtuC+82op6IAHnAezX49Yf/xhcFmesUxDG5hwkojYpyX1X+TcnmAc1VJWsFPq17eMHlyfP5/aUCFPVBOtjMmBn/4VdBBCKS25NFAJDFdnG93INKWvc0aO+xEai4hS9jH3NdQ+4icrGu/chYWZ1+QMCV4bGyBM5modqNc+biQzoke8Eo9IPzWrdxOtWW/js24Jn6BlqXkoMGZjvmLXMB0smltyo9tfHi/PpM5YG4/tfd6+GZurCWf6aotsnuq8cx8doCEyclkUlhchY32+q/62Z0pX3xWsN8ke4PDHTBVzDKlzJMW7FRDAMCwXWM4oDpZq50cuqDZHFPAelwpB0E76jf2wgLAr5SUIHriUGUmK+NQGK7lRgAhf8ik2u1MP1a4FQuWZ/GVp/pajSxz0rKgSG8lgCVKPNHmi66nNBr2qJZsbB4j0/Tk4gtMzqIG071FglK+HK5iTRYCECuokPBhQksV3F9wwwPECYHsqSFcCCpwyGavQVYnITEbNWe4Vrr+5cddsIaO28NHpxrNGHEXxtzCHXo+QqQQ5RnYFnN2blulVZoaV61iokPkOGbxIYk/BF68XdcgZl8nWZOeldJyO0TPPkG6v4cSmRpGnp7uHU/EdXRI9mSAxj0NafqbSg+2YLM33Suz3IYwIC1Y9vlDJXY1Roe2IdYF0vorf63EGVuQVoc2j30tH3l0hCs6btl+/r1FKRYgboMzR3x10FYlC8gQEmj5sTqSJyNayuDg/bAfehGEx9nGMDIir3cQmGhy/8VxGS5mAmKcmAOpGJzlQwJQ/ObHV8G1s0jqiTBR4aPA0CZF757BA6gAyIQuDIpGCvZtwTXH3igamHBNQXmfHjGDD4+fBLzuJxzd6mrXHHxXLTjhClFtd4TIQmPAsi4krC
 Z6w+RiIj
 Si1SMZj78u4nmKT/sFMC8ji6JzaAgnx0jeDYvGiDHbMseXvbXo100QWlG6aCn09EFWtjy3610PkKN8qJwPlKFtzqWGBgsyUuaHQOdWb2Qv5RtnBLCpvzpkhJgznSCw4QyecARUs8rgyPUC9mMfJmHB/+J4+4qZ65rxf2khWmHdL7sv960QgQ8il/wzqPgu5WmeUrfdPb0yFgPdjHARQeamOxCZ3hqzlRGh6z9AmADHy3ln48mAEBUJYee3JMdTRUSvFEqU9B6nOMLrZgqIWp5o7xWPbqnJ1WikF1V6l8efS92M98PQOMfehV813JuWY8hd8gxoGPh9XZ78p0kUPDGND9Tkzyp5S2CoSLi7+IWp2POF4MOV5DZwjHWcYO+te/EG1k41hgFVz3stLzU8yoEV+Cof1g4sPa9FFEb1qdthzBuRu+hp1X33AF4uT4Gdk/ChX5B5D7Z/3rq1tZMUYO6MxiFv+ulwY5EqJTSfgLVhrbvK/d4/A8HBXpDHa7rKdh7RUWpy641jIqnxZTy/0neZep4td2PMPBPqi+YjNr7h+7F9js1k1JWh5I1If2NjSANenN6mz0bCjemzO033fUu1/arooqMMw0u1CaeJLdsc3IH+N6tns2H2dyXdJMAMm664dy4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Fragment clusters were mostly failing high order allocation already.
The reason we scan it through now is that a swap slot may get freed
without releasing the swap cache, so a swap map entry will end up in
HAS_CACHE only status, and the cluster won't be moved back to non-full
or free cluster list. This may cause a higher allocation failure rate.

Usually only !SWP_SYNCHRONOUS_IO devices may have a large number of
slots stuck in HAS_CACHE only status. Because when a !SWP_SYNCHRONOUS_IO
device's usage is low (!vm_swap_full()), it will try to lazy free
the swap cache.

But this fragment list scan out is a bit overkill. Fragmentation
is only an issue for the allocator when the device is getting full,
and by that time, swap will be releasing the swap cache aggressively
already. Only scan one fragment cluster at a time is good enough to
reclaim already pinned slots, and move the cluster back to nonfull.

And besides, only high order allocation requires iterating over the
list, order 0 allocation will succeed on the first attempt. And
high order allocation failure isn't a serious problem.

So the iteration of fragment clusters is trivial, but it will slow down
large allocation by a lot when the fragment cluster list is long.
So it's better to drop this fragment cluster iteration design.

Test on a 48c96t system, build linux kernel using 10G ZRAM, make -j48,
defconfig with 768M cgroup memory limit, on top of tmpfs, 4K folio
only:

Before: sys time: 4432.56s
After:  sys time: 4430.18s

Change to make -j96, 2G memory limit, 64kB mTHP enabled, and 10G ZRAM:

Before: sys time: 11609.69s  64kB/swpout: 1787051  64kB/swpout_fallback: 20917
After:  sys time: 5572.85s   64kB/swpout: 1797612  64kB/swpout_fallback: 19254

Change to 8G ZRAM:

Before: sys time: 21524.35s  64kB/swpout: 1687142  64kB/swpout_fallback: 128496
After:  sys time: 6278.45s   64kB/swpout: 1679127  64kB/swpout_fallback: 130942

Change to use 10G brd device with SWP_SYNCHRONOUS_IO flag removed:

Before: sys time: 7393.50s  64kB/swpout:1788246  swpout_fallback: 0
After:  sys time: 7399.88s  64kB/swpout:1784257  swpout_fallback: 0

Change to use 8G brd device with SWP_SYNCHRONOUS_IO flag removed:

Before: sys time: 26292.26s 64kB/swpout:1645236  swpout_fallback: 138945
After:  sys time: 9463.16s  64kB/swpout:1581376  swpout_fallback: 259979

The performance is a lot better for large folios, and the large order
allocation failure rate is only very slightly higher or unchanged even
for !SWP_SYNCHRONOUS_IO devices high pressure.

Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index b4f3cc712580..1f1110e37f68 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -926,32 +926,25 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		swap_reclaim_full_clusters(si, false);
 
 	if (order < PMD_ORDER) {
-		unsigned int frags = 0, frags_existing;
-
 		while ((ci = isolate_lock_cluster(si, &si->nonfull_clusters[order]))) {
 			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
 							order, usage);
 			if (found)
 				goto done;
-			/* Clusters failed to allocate are moved to frag_clusters */
-			frags++;
 		}
 
-		frags_existing = atomic_long_read(&si->frag_cluster_nr[order]);
-		while (frags < frags_existing &&
-		       (ci = isolate_lock_cluster(si, &si->frag_clusters[order]))) {
-			atomic_long_dec(&si->frag_cluster_nr[order]);
-			/*
-			 * Rotate the frag list to iterate, they were all
-			 * failing high order allocation or moved here due to
-			 * per-CPU usage, but they could contain newly released
-			 * reclaimable (eg. lazy-freed swap cache) slots.
-			 */
+		/*
+		 * Scan only one fragment cluster is good enough. Order 0
+		 * allocation will surely success, and large allocation
+		 * failure is not critical. Scanning one cluster still
+		 * keeps the list rotated and reclaimed (for HAS_CACHE).
+		 */
+		ci = isolate_lock_cluster(si, &si->frag_clusters[order]);
+		if (ci) {
 			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
 							order, usage);
 			if (found)
 				goto done;
-			frags++;
 		}
 	}
 
-- 
2.50.1


