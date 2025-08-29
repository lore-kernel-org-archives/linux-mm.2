Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5DA3CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 190EE8E0014; Fri, 29 Aug 2025 19:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1199B8E0001; Fri, 29 Aug 2025 19:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7208E0014; Fri, 29 Aug 2025 19:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB92C8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:40:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B9C413AB82
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:09 +0000 (UTC)
X-FDA: 83831415738.11.B3F49DF
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id B1E491C0013
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lYJrXF1X;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510807; a=rsa-sha256;
	cv=none;
	b=hN8btSUJLI/VN4gSQf98tvO7hL8l9+nSspJJ/VMO1If6UGM9CyZNKQuNHJDdOnOE7bzNHw
	8/HolWVbbLulEA8TWeMBVgb5dCoEiy8niRCaN9vQAL8lcbHJhNBLLLzeZJ0UocbG5SXFbs
	a/cfUVUFglPmQJli+lLPkKmnZaXonYk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lYJrXF1X;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+vnHoXREVrw0SidVRfvTvkEdr9pD8iMwbSpz5zwCXo=;
	b=MVN1TvDrF44OLHjwfTuKhR00THVKN7HHZd/teY6KzZKsawMj2hEuJJqGcet3l6J00MX9Io
	fLJr6tkvrG5YsMLcveDlXeH0VgZUqODQFTeB7gGokfjAsgNRAJAsqsEoX5IgFrVVyZhDsa
	eqdWhMLgDqkr434iYbtorIC7OzhFS5E=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-771fa8e4190so1847899b3a.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510806; x=1757115606; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E+vnHoXREVrw0SidVRfvTvkEdr9pD8iMwbSpz5zwCXo=;
        b=lYJrXF1XHdxmYk2MObP0tV2nMNfZZEfZsDa0dVIvqfJSB9vlPCrdVkrC2LxxQMvsSF
         KzZSpWc+/9l9FgXeriJ9rdSlWm6UIU8V1U+F/HcQ343AWnLwzo5/JlGGA6YGLQiktQ+u
         3Yzi5anUglTwz7dPPh96IL/knDCwtIkrST6ZVw3IOOebYp8pfR3ol3egEziQC86Uq0vM
         CnhYUz7u3xEe8EoipGnwbk6ijbqXxvMAotJO8kklHl4Es1BrPyN/WfZWAg8QQtvo8NBK
         yPTPYKL1Z9Tb5VirheQqSXpskIxN7/HhPuMAw4XAewKa8EUlyGBn4w/wZszMu2jSpGvs
         SjYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510806; x=1757115606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E+vnHoXREVrw0SidVRfvTvkEdr9pD8iMwbSpz5zwCXo=;
        b=YyjVZGVfViVtT3zF+qasSfihsZW3OhmLP9h1CL2haPaDrpKUitzYVOy3iJ7qe/R8ty
         TvPwMwIRe+ENeAtWkoCSUzmwkiv1xtwRHcxfeYaAtYnWwhdKOFyE89moq6JuhsNdKQnk
         3DdAGSwf9OLbkTIhGW4+fp9H0Ev9Zj7VWKM7iiNe6IfPSJ+KjATnkgtdWK3Dxi+qf2Ca
         eyxN9s+ZnMCAi5smhJnZzD8r5LE9nyNClWo4hQ1jxHwYDqcu/XjtrNvO8rokv7IdbeZf
         8ax9/lHrC5aebgCaP4tL1ZD/SdEVM6r1Gm4JpKoOaxeieDpqErt3FuTH7FR4r/XaqyUI
         BMzA==
X-Gm-Message-State: AOJu0Yy/jSLAc5huMMfHaO5jodacNBg9ZDNVtaPQ7bp6/4A+miPg8//W
	gfT/Q5Kk8AtOqsnzNFXj4IrB3BZRBmhp0eywmmDmodPFQ2GblX5eCEF+yyGEfg==
X-Gm-Gg: ASbGncsDhdfT2B/Ayv86aDkT75mx75iGZlyEnsK/PrztzsLHGRwadRkP8K9ZRWunt97
	C14ZSyDrhEY1DQakBTdo3n/Zxkry4E19MmDBKOwAQ3aQuzd/sRLrdqG/uESTB7J5sdLiR1nMdwQ
	llvhdkYAz4m5wu8/WpQWsvtKvGL2K3qni9dhZEa+UZJrs8C2jfhC0uTlF5a/HbWDeK5vXGFHFct
	INT+t1VT93tdCBSfMawjyFd82VsyA4ZEZwkZRI9xm0maZqfo1LxhBeNYUMRXVCKTDSw/2HIdXhB
	160MbdRoLR3PIixD0jVfu0m0LfikXeOdekRV1e2FmNi6SQtXUqBiPnL1KiYIt0G9kzvFB1fuZlu
	o3TTkhEBbM997qd2LR8f7k4mK/7Y8
X-Google-Smtp-Source: AGHT+IGUC8tYoEWl9cRnzhp1CoqWk60f7qfxgsYVEWKJABEj1hf6h+rHiKHA4Ucd3Clfcw8GiV+kfQ==
X-Received: by 2002:a05:6a20:2589:b0:243:a96a:2c83 with SMTP id adf61e73a8af0-243d6f8a2e3mr466476637.53.1756510806401;
        Fri, 29 Aug 2025 16:40:06 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:43::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3276fcd48cesm9361902a91.19.2025.08.29.16.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:40:06 -0700 (PDT)
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
Subject: [PATCH v2 11/12] iomap: refactor uptodate bitmap iteration
Date: Fri, 29 Aug 2025 16:39:41 -0700
Message-ID: <20250829233942.3607248-12-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829233942.3607248-1-joannelkoong@gmail.com>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1E491C0013
X-Stat-Signature: owrzesc8i4cyhzbw4wd1aoz7cej3yemi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756510807-979324
X-HE-Meta: U2FsdGVkX18tW4BPu7zTDDXWQEXt4EM6PBFaB2ZfwCy8GF77Np5oWxDFqDGqto2Uh2XNG2evJ/d3FOUjUSzz6qRp8+h/u7N084BAxJyavroFXjtskIf+NcCETjAlWbMVu9Hz2kIgchemfOMubl34GvmHM0/ANh1C5qNlIUasNezdTHlXjiHD3sq0X8Rl7VaD760vISISAfzu8lt3nwPkpq+Uct3yeOUqyZCfBRtelIB5TOSyLJTANh6rcCF8IOUPFSJVr8dzzIRq+BiJvcqY+slem1lljcPCFZIrOKRucC5qlorLCAw+fDoDfD5BJH16DYY9nz6Eex1EtFoNZiyAvhMNA3uHL8bAW4c4DAXsW5XvehyYOiGHyY2Sqr1fWe2Uzih0OeZvUc8/dyMy994YPJ0fg7Vf2roBl6zHMtdM5/7ir1u8QOvLT7TIoDzCINk+AFmvNPeplLyGxgqeW2OEDpd6gCP6Pp80epTjyYUN9k9u3UsPtF2UeDgc7jIP0ERvzaYZ0XKH9M8IaxBGKm/dDl/7Nrjs57LLHjEebimTwC/1Ov/VmnG1my6MFZuL4WAtWoS3jMn9YNoOMlJlLURNj+sykvYS+AjH5aRSvtRVcehPZGvIN9x9CEUfa4XvNISxHqVMmf/FJXabgGv3BX/C1Xl5qSK5ta4DNIYFLxnV+4atWJ32WxlfYEMChTj5G3voF+ViO+uLhd0u1xc7yuIdJnTD3jLfPUjW2zO/PZ4nDyRM52w+uBtqP78VF2pBn/Tbf7bb+9TBDoZTaxgTmVxO8ky6LwQUvRAC36gJKlBSvdMp8peitxZkYSLL5sJUm9ODdDlHc9FnnkjicICC4EEVRDkR4Z0UE5jgalEU/zD7T7hCyKC1vw5FyvsMOvC7nz70dcvEj+R7g/1PErVUdUoM1XpU81dj08h+FVMYO2CPo8IkvrF0LGuu+mkhxSHPvl3cEhCJZFOrUKjbeCKFERu
 qE/umwGu
 FrDHHRk/doQOl0yO59nGFQVchhZsPqixMv4RMwtRGR7tYWOEk5WGNQHA0zhOeG8O3CDffJQO+KaYavp2PZeudTJr4/PVIvBmSwmG2eSDxo7EXpy3MeJCgRwYulEamUB45pV5lmCqPzbZu+CMWO2a5Is335b7Ix/MU6WQWCpUV+6f2L5cQ5QXiTbHbbcy1Ka+nT+1A/7fVMEKBMQlDhR2YFFoXROjFdgGDBEmaQNiLdrZdNe5vWxAEMIZtXC7ZJ6Mfper4JRKMWxfaws5L6RsrgktJmEEaXzBnMdoa3BQ7PHy+jbY25K072K0xWwPkDz1RJLCX0HyTZdEAPBvhiq1tJq84VXXzMg4s14tMyEd5n1YecZna0lSIfEXmg/aK1tYt9A0swUHcL3G6eb6Skt8+vn2Q5IvVpvQOoM35J4jRc908tsC7AT61SGBP2E0Z/i8Lzq5gqzlGNrLUreqW8BJioJDjd/PLQ6mt06bckuu2bhLSm8WZXQ6Xx0LETdFzVnTcCFNAuApmXsnxDBDznlm5328Z7cG/YOQh46VKI5FS/i67s3L4BJcD+khFQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use find_next_bit()/find_next_zero_bit() for iomap uptodate bitmap
iteration. This uses __ffs() internally and is more efficient for
finding the next uptodate or non-uptodate bit than manually iterating
through the bitmap range testing every bit.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
---
 fs/iomap/buffered-io.c | 74 +++++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 26 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index dc1a1f371412..4f021dcaaffe 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -37,10 +37,36 @@ static inline bool ifs_is_fully_uptodate(struct folio *folio,
 	return bitmap_full(ifs->state, i_blocks_per_folio(inode, folio));
 }
 
-static inline bool ifs_block_is_uptodate(struct iomap_folio_state *ifs,
-		unsigned int block)
+/**
+ * ifs_next_uptodate_block - find the next uptodate block in the folio
+ * @folio: The folio
+ * @start_blk: Block number to begin searching at
+ * @end_blk: Last block number (inclusive) to search
+ *
+ * If no uptodate block is found, this will return end_blk + 1.
+ */
+static unsigned ifs_next_uptodate_block(struct folio *folio,
+		unsigned start_blk, unsigned end_blk)
 {
-	return test_bit(block, ifs->state);
+	struct iomap_folio_state *ifs = folio->private;
+
+	return find_next_bit(ifs->state, end_blk + 1, start_blk);
+}
+
+/**
+ * ifs_next_nonuptodate_block - find the next non-uptodate block in the folio
+ * @folio: The folio
+ * @start_blk: Block number to begin searching at
+ * @end_blk: Last block number (inclusive) to search
+ *
+ * If no non-uptodate block is found, this will return end_blk + 1.
+ */
+static unsigned ifs_next_nonuptodate_block(struct folio *folio,
+		unsigned start_blk, unsigned end_blk)
+{
+	struct iomap_folio_state *ifs = folio->private;
+
+	return find_next_zero_bit(ifs->state, end_blk + 1, start_blk);
 }
 
 static bool ifs_set_range_uptodate(struct folio *folio,
@@ -266,24 +292,23 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 	 * to avoid reading in already uptodate ranges.
 	 */
 	if (ifs) {
-		unsigned int i;
-
-		/* move forward for each leading block marked uptodate */
-		for (i = first; i <= last; i++) {
-			if (!ifs_block_is_uptodate(ifs, i))
-				break;
-			*pos += block_size;
-			poff += block_size;
-			plen -= block_size;
-			first++;
-		}
-
-		/* truncate len if we find any trailing uptodate block(s) */
-		while (++i <= last) {
-			if (ifs_block_is_uptodate(ifs, i)) {
-				plen -= (last - i + 1) * block_size;
-				last = i - 1;
-				break;
+		unsigned next, bytes;
+
+		/* find the next non-uptodate block */
+		next = ifs_next_nonuptodate_block(folio, first, last);
+		bytes = (next - first) << block_bits;
+		*pos += bytes;
+		poff += bytes;
+		WARN_ON_ONCE(bytes > plen);
+		plen -= bytes;
+		first = next;
+
+		if (++next <= last) {
+			/* truncate len if we find any trailing uptodate block(s) */
+			next = ifs_next_uptodate_block(folio, next, last);
+			if (next <= last) {
+				plen -= (last - next + 1) << block_bits;
+				last = next - 1;
 			}
 		}
 	}
@@ -607,7 +632,7 @@ bool iomap_is_partially_uptodate(struct folio *folio, size_t from, size_t count)
 {
 	struct iomap_folio_state *ifs = folio->private;
 	struct inode *inode = folio->mapping->host;
-	unsigned first, last, i;
+	unsigned first, last;
 
 	if (!ifs)
 		return false;
@@ -619,10 +644,7 @@ bool iomap_is_partially_uptodate(struct folio *folio, size_t from, size_t count)
 	first = from >> inode->i_blkbits;
 	last = (from + count - 1) >> inode->i_blkbits;
 
-	for (i = first; i <= last; i++)
-		if (!ifs_block_is_uptodate(ifs, i))
-			return false;
-	return true;
+	return ifs_next_nonuptodate_block(folio, first, last) > last;
 }
 EXPORT_SYMBOL_GPL(iomap_is_partially_uptodate);
 
-- 
2.47.3


