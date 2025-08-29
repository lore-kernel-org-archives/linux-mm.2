Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC8B4CA0FFE
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4A48E0013; Fri, 29 Aug 2025 19:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81E718E0001; Fri, 29 Aug 2025 19:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64B0C8E0013; Fri, 29 Aug 2025 19:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 367F18E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:40:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE2EAC0A25
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:07 +0000 (UTC)
X-FDA: 83831415654.23.626994B
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1F0D7120002
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RXRVSQ5A;
	spf=pass (imf29.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfQECAMLyifBaWnZBOh3XwN8oA8V3Gk1yo9qRqEQKOs=;
	b=cRy+9uiLr8bFBmufbk1j4aGpvhpWgPFkeYa6fjXkKWbYVWnV5BdeghXcsZyHMg0jnBW/yE
	Z8QkWZckylQ/c96GQbCrc+i+tf3wHAP0AGGKpyLww1tcOPjw3drw75SjZDm17NU8Rjd61Z
	Gtd16BwS22Du5yFvPij0oZObVfo8wyE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510806; a=rsa-sha256;
	cv=none;
	b=TVLoyg/eaknk5oe9lZK15GUGpVaSU9sqlVFt9OBpQO4D6C3ndI07eGpWIk3SiozFGjtK67
	5DSQnWOQub5jefc6FM3T+qz8tCnvLcbDgMqJvab5pt/CfISI7LZ6j94khT5LXv0j7Y3SaD
	Xh0hIzdR4ccs7FaqAMhwR/txv2/rKak=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RXRVSQ5A;
	spf=pass (imf29.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b4cb3367d87so1090549a12.3
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510805; x=1757115605; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfQECAMLyifBaWnZBOh3XwN8oA8V3Gk1yo9qRqEQKOs=;
        b=RXRVSQ5As/+M667vvV0BNZ78rP++c87zDKj+jWBXLjeUlByeddCXSwZDBR6BKuLJeC
         1ulw0cpMcuh0firu1JEZiUfTBr8paFhVb5sRIrh+XdlxlPBMukvZTqiEvvB3HSZGlHvM
         bl+vdVxk4CRxn1xKSuZCbBmX9d6leBI0/cifmEOdaxrFwVncM6AbbfWW/BoAvyRbwGjJ
         7rJQ86JAYghCarxYW/8YbLLJbkKcUifCnRS3fhvQE81ArP6yD4R7U6ey9172ofQxJUKp
         lF+8E9Dnec2Js7Zr0uQLozT/x1mamdyr6vhVtb4BSsUdZSV+0AaJONXQP8aeieUrImrY
         wGXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510805; x=1757115605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cfQECAMLyifBaWnZBOh3XwN8oA8V3Gk1yo9qRqEQKOs=;
        b=bqDmdqz5/xAahvjmpDna6xttbQXbwxWaE6IqG1wxGR1GBGSk9t50AkAtdOzGprN4n5
         u1aGO1lg3LG8R3yDE5HIsqyDX/ZzCEteunxkXYiwJYAvFOczDDjT46AigFUUYuIsMAkK
         6f25Cd8+j1QeW82+aU6/HPLDks43p0MKUn+nxz6BZ9X01YbE4Q8OIlJ5ijQ9ZGd8NmSY
         WSzbDfSMasP8gP+REldaT/TzFKQOyeGzxAC9WbkyH1nwOO2EKMop7HwQF5Lf6dEU22oG
         uJ3iixOJ4CSbbdDXJO/sB35L9r+LepVRhhxmRlSk3msOMy4zw/Jt/KoYbzcwA+jwFiHf
         KIaA==
X-Gm-Message-State: AOJu0Yz/krvoqfDX0YZQyTpGzLiXrqKxPA6Zj13N4Fxtvht9hXLhvsiK
	AKhGka7U9VP366S/nkdBgrZdlbNLDepO+VLp1HZ/je5hIzAGeddIolTN+HdhmQ==
X-Gm-Gg: ASbGncubFBI/WI7hvg6F76pr8aqVCHVHl3LiUwDyC4BCNDrtV084KjGAOdmmzLke2ky
	Nex1U64Nvwn/2SGL5/TEbyMz9xekEfkQQbNLAH7iSIQ+NLi0fIVuQJ/Cc55HCnUyFrviy5JfJnf
	wjKiTgDLRicR6jBZxdRy5HGDabrQqICCffwxxoOX2/ChsKj7HEtsNK3IXmxwAeSetyUYs0+lnc2
	Ex+dVvB4edohSF8rG61iXKpVX0Dk9rRHJGT7u27IQ95GykqSYQgMFw977nVm6qPs/Fywobd1Iwv
	yTOPetLsa4BLR1hv2MOpMXWAnLXwC27QNd1BKFRtJUCnqPyDIp9qMmHpbuMuFHRnFsjr3Cuudsa
	8/p8zbdW/7B5tpPJi
X-Google-Smtp-Source: AGHT+IEc9ZHU+gnzs268+QcgurHyfBD8OsMkb5igTSS/wc4rJ1iP9uFrL7dvxIfpXo4L4ntKoVG79w==
X-Received: by 2002:a17:903:1d2:b0:234:a139:11fb with SMTP id d9443c01a7336-24944a0e8f3mr5573865ad.27.1756510804856;
        Fri, 29 Aug 2025 16:40:04 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:d::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2490658999fsm34959625ad.112.2025.08.29.16.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:40:04 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 10/12] iomap: refactor dirty bitmap iteration
Date: Fri, 29 Aug 2025 16:39:40 -0700
Message-ID: <20250829233942.3607248-11-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829233942.3607248-1-joannelkoong@gmail.com>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F0D7120002
X-Stat-Signature: smfchiqzmpc3ohe1795dw3cqpcfebsux
X-HE-Tag: 1756510805-297475
X-HE-Meta: U2FsdGVkX18bSYpJSXwVg5UwMF3bfkjNc1O1uVh7vLwd/sqoMYJYTGqrmiAf+9zwAPYvG0gYT1vS2UpRoa3tCM43dwauCIox+p3Vj1NGeQEI5yHopFFN4SwXe+yzUgLpH2RuFoWyJ/h8TTX/P/atQhhc9y9sDankyzyiNp0w+wCYzJNvoHlBxclApOV3mGdT07SSOu6zn59LpqyFGCHW+naghi21NVH1HrSb5aBBfU1tkmb1IL6tnLp5v/QnVzrGnXZlpo23AYtK0m18H2e/yjeVbu8Gzd70I+xxgY0CrmT/nq7tRKp0FsC+o2zJ5V43XiU6V6amRPiMmdM5NdukdfKzk6x/lquhgzgnRBus7YIXPSf8HO8CtCPdNrhw8SP70uKJ76n6s3+Uvqmglx1jdXd2nfYyz4u2e0G1vM9UTfTZTWM+fXrXCFHK5VidDO6a2HbP1JKHGDcs0j5xyfcfd7MXg97aR595MNlmep/tp/DAD0ns8m7eqeBU6w2Gc4Tfij7DpXMz2fhA/K9yWyFX2/w/w7vU22Ew/v8Lp3+AKyX6s6Q3sVEgUbzwGskbazRTh9pMuKMaelat6yiKDLkj+XPzqSP51ubEOsaIc5JNMrNBKvSDRnOAiIbY0y7quwFBqdR9zK71fYaBexiFVQMXv0BD3sJjC5BL9VXUyDRPxLEZJMlqzDdhBo/wMuV8AU8Ze9uHESx/GPU2XcLM3TYXVLh2bQkxvNnjDuOxSUI373FyQ6lmu4pU1hGChKaoKfVAav87cky6PE/SDGcYBfG3Vga6GkDjiS4Tqb/rcl9FMc8cYcgwc7/4trNY3jMRqFX9Ajizh80Y7YPFyjPkkFDwE+ZqbTsEGdtJT4XGJHlhfyCTZ+zDSmZCPTchlY3cd3sd3uqMIwaGc7qZSx5Llr1M9OJ4BjvMPOf5SmGeMZLY78an0SUIVwjxv1QI4nvYZR1RRuh3mn3RM8f0oJXrDx/
 H4EDWVHu
 PFyon5c0jhs6S3c9v3CVJMkdz5AasfPal6t/T/02Jl9mGLUgw5gPKPpa/sPzqKbDGSz3wPj3K+yD9QEsbdTdL1CwQIM2x+gQy/5smYxN+pFGzrQp0A+W1LrNhNwE2QXK87BNTNnqcz2GoyzUJ1EOaVUJBwdOVjv9ixdYWJXC1/TsNfLdFt+qNcEdwaxWso2GpmqpgG2FAF6TAsOdUquobASNiDl1X10jJtcFLddB0fA7Tlc8YtA60D1XU9drmpiLM7py1swj4ZXXRZfh/lnL7xsYs6rsZaSVtZV26tUnS3qpyjasdDubhcD30BPe0Gnzz925J+HSbnAdN3ZapNHZ9nLf5KshEi/DQctkOOSW2i74KCV3D/WrY79WQnLCMXe6qMMzxtDaQMqbYvgW9va1LIRzSGdCllgg6Z3lVsO4reHPSraRo4LH/2yZX+G71IGTBHwIKd+LOnB4Sqp808g6nHc80+W0POPcPYbfVkUQrpTQAYe/szCy9lFzSwnba3+WlgIvOeb6GUAvDqNvqfyfwWoSLHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use find_next_bit()/find_next_zero_bit() for iomap dirty bitmap
iteration. This uses __ffs() internally and is more efficient for
finding the next dirty or clean bit than manually iterating through the
bitmap range testing every bit.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
---
 fs/iomap/buffered-io.c | 67 ++++++++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 19 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index fd827398afd2..dc1a1f371412 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -75,13 +75,42 @@ static void iomap_set_range_uptodate(struct folio *folio, size_t off,
 		folio_mark_uptodate(folio);
 }
 
-static inline bool ifs_block_is_dirty(struct folio *folio,
-		struct iomap_folio_state *ifs, int block)
+/**
+ * ifs_next_dirty_block - find the next dirty block in the folio
+ * @folio: The folio
+ * @start_blk: Block number to begin searching at
+ * @end_blk: Last block number (inclusive) to search
+ *
+ * If no dirty block is found, this will return end_blk + 1.
+ */
+static unsigned ifs_next_dirty_block(struct folio *folio,
+		unsigned start_blk, unsigned end_blk)
 {
+	struct iomap_folio_state *ifs = folio->private;
 	struct inode *inode = folio->mapping->host;
-	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
+	unsigned int blks = i_blocks_per_folio(inode, folio);
+
+	return find_next_bit(ifs->state, blks + end_blk + 1,
+		blks + start_blk) - blks;
+}
+
+/**
+ * ifs_next_clean_block - find the next clean block in the folio
+ * @folio: The folio
+ * @start_blk: Block number to begin searching at
+ * @end_blk: Last block number (inclusive) to search
+ *
+ * If no clean block is found, this will return end_blk + 1.
+ */
+static unsigned ifs_next_clean_block(struct folio *folio,
+		unsigned start_blk, unsigned end_blk)
+{
+	struct iomap_folio_state *ifs = folio->private;
+	struct inode *inode = folio->mapping->host;
+	unsigned int blks = i_blocks_per_folio(inode, folio);
 
-	return test_bit(block + blks_per_folio, ifs->state);
+	return find_next_zero_bit(ifs->state, blks + end_blk + 1,
+		blks + start_blk) - blks;
 }
 
 static unsigned ifs_find_dirty_range(struct folio *folio,
@@ -92,18 +121,15 @@ static unsigned ifs_find_dirty_range(struct folio *folio,
 		offset_in_folio(folio, *range_start) >> inode->i_blkbits;
 	unsigned end_blk = min_not_zero(
 		offset_in_folio(folio, range_end) >> inode->i_blkbits,
-		i_blocks_per_folio(inode, folio));
-	unsigned nblks = 1;
+		i_blocks_per_folio(inode, folio)) - 1;
+	unsigned nblks;
 
-	while (!ifs_block_is_dirty(folio, ifs, start_blk))
-		if (++start_blk == end_blk)
-			return 0;
+	start_blk = ifs_next_dirty_block(folio, start_blk, end_blk);
+	if (start_blk > end_blk)
+		return 0;
 
-	while (start_blk + nblks < end_blk) {
-		if (!ifs_block_is_dirty(folio, ifs, start_blk + nblks))
-			break;
-		nblks++;
-	}
+	nblks = ifs_next_clean_block(folio, start_blk + 1, end_blk)
+		- start_blk;
 
 	*range_start = folio_pos(folio) + (start_blk << inode->i_blkbits);
 	return nblks << inode->i_blkbits;
@@ -1077,7 +1103,7 @@ static void iomap_write_delalloc_ifs_punch(struct inode *inode,
 		struct folio *folio, loff_t start_byte, loff_t end_byte,
 		struct iomap *iomap, iomap_punch_t punch)
 {
-	unsigned int first_blk, last_blk, i;
+	unsigned int first_blk, last_blk;
 	loff_t last_byte;
 	u8 blkbits = inode->i_blkbits;
 	struct iomap_folio_state *ifs;
@@ -1096,10 +1122,13 @@ static void iomap_write_delalloc_ifs_punch(struct inode *inode,
 			folio_pos(folio) + folio_size(folio) - 1);
 	first_blk = offset_in_folio(folio, start_byte) >> blkbits;
 	last_blk = offset_in_folio(folio, last_byte) >> blkbits;
-	for (i = first_blk; i <= last_blk; i++) {
-		if (!ifs_block_is_dirty(folio, ifs, i))
-			punch(inode, folio_pos(folio) + (i << blkbits),
-				    1 << blkbits, iomap);
+	while (first_blk <= last_blk) {
+		first_blk = ifs_next_clean_block(folio, first_blk, last_blk);
+		if (first_blk > last_blk)
+			break;
+		punch(inode, folio_pos(folio) + (first_blk << blkbits),
+			1 << blkbits, iomap);
+		first_blk++;
 	}
 }
 
-- 
2.47.3


