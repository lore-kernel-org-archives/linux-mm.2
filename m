Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05324D5B16D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 03:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E4A36B0007; Sun, 14 Dec 2025 22:05:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695AA6B0008; Sun, 14 Dec 2025 22:05:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585306B000A; Sun, 14 Dec 2025 22:05:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE9E6B0007
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 22:05:20 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E888FBE304
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:05:19 +0000 (UTC)
X-FDA: 84220214358.10.622E118
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 01489180017
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:05:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="L/okEJwK";
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765767918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBRV01n6Z10+Z5Vfi/wD7Tb0wVdvo9mjj3mwV2A1JME=;
	b=qExFLg08krxBpD2EqQH/zQUZUh6cuMrFmD1aRSKRLGL9HdAxZSN/Al5NJWkAnH33CtnKh6
	st5pkggrqfMd2W1E7tJXhyc/rRyjqz5Q1EwiCu7SosP+obcxZ7HVyYgFUgfbuyZf9pH9DZ
	JS0CZm5ZQyeaSM8oxgMm2S9GRsvXqec=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="L/okEJwK";
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765767918; a=rsa-sha256;
	cv=none;
	b=ANi+6MQx7o95ZJM+cK5M1754NNMmB1CIrdKeriLsNKcDbSlIneDQ1u9u8icuzJWntzSmDw
	UB2rSylrl9l+x8RX5j3tc4PDsWCxKRlUNGC4O3Ak82rg07FNGKXJKsaDBlTvDayOnzgA1f
	OYdS8//4mYEevtiJmfE5mSv+NzHsw7s=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7bf0ad0cb87so3585827b3a.2
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 19:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765767917; x=1766372717; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LBRV01n6Z10+Z5Vfi/wD7Tb0wVdvo9mjj3mwV2A1JME=;
        b=L/okEJwKKFcMnva4ZPxLVCNP6KLC6FGBvfPjtKhBV5zUc/5zqjQuIPVtxJWNOAsJLM
         jCX0rvzd76E5g7HKllnwhWkK2nSItgN428ANUhD3/f4JVgMi+33yTaflZXewjW+42szB
         lV0wxad2IeVTz9atZVyPwxNXds5PpZ3bgMghgKJnMRtO1Jb21YZaqatY5cl+P+VJ80zS
         e7MbiDwCgOTaB8ikqQv9Z9UQ0VMXYZVp2tJ3j8aqIrofHLrFt7NRnwE6f2mBrsHgx5y0
         Nsogi2Ny5XwoM548ARhcdpoHuRk+mHUvrJD3mSwG7DHO7i7Zpf1cGa75yJ3MACq6TefX
         rygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765767917; x=1766372717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LBRV01n6Z10+Z5Vfi/wD7Tb0wVdvo9mjj3mwV2A1JME=;
        b=RoduJUsDmJZWTxDfvQIJyv9E7g6IsL9c1TizLK5Yif5Syb4+2xVFYj6u1f/Y04WxDt
         nfZZtLymyXQRbVtVkazm0ryENbuH1lHL8+d1eY/OuhRxOxRgXP0JHENgt/Oyjmn9fYii
         UgAJkdERpEJrnjYOsTHkL2pIbJ/IIeo7MoCBRSrrJPx3uV0MEyCBB00w12tV6+eMAkB0
         ymiFUAlVXU1GWOOFo04mjUwTdUdXaF7n/F+4n5kIAMEmQ9HQg1RRx38Tv/wi/H1FvWxl
         s2GHV8x4r4mBJnl893u+M2AgtNuEPAWg6Hk0t+MlBFzTS8z90xpH5UolqwDgxOiiFlQI
         3OGA==
X-Forwarded-Encrypted: i=1; AJvYcCXe37W+auTIXvDbAQDBIN4KK51r6rdbTmshAb48i5HjBhChplQqpcH8unlHxVKLM6pIPsN5M3xusQ==@kvack.org
X-Gm-Message-State: AOJu0YwSF5ll//f+o1XYpTOusVtthRCpCnpvE0Au0nDkgWbkNuX44fzL
	pEoWj3QboSvlJK+eVO8Sr8JKWTHjPVbYg60+wGDz2w/HhULuy6lvmBs6
X-Gm-Gg: AY/fxX6vAlyUiMnwaiCaidjVU3Cu4cJ/zm6KpDl5kX3pIWN8Z7PQyFn2kDW6uOFURpl
	T4V/2hWoQiNHxbv3WeB0wKAI1Y3WTWiP1TpdilGQV94sN1BrO/8HKUiP0kyWhBIK+LY7EIzuaa0
	gvkbwzjeAsgcBTsPLU9xU74sNCZfjq71oLUClsQQpwA+/2av602SzGmnBmPbyer5uyOQeHZz6Kg
	vVDgme2TLucxlJsfVDbVM7srD4EEhc2pePovjvpNukIoGeac32wLf7ALDig3YNjHVnC9/CXnR/3
	hF8MgxZ+vV+xQw/0gLqO0A2BCi2H0dJRSPGAc/HggM/oVqeCCPe/wd8VllDJHUPyyw7mcHJTtzT
	lfwMpOrTH+C1Nx1DDl3S2B5b6+p8qsJZ5eOcSEWjf/tZKrXFpsCFIfggZJFlbIu3psWTuLeNv3g
	mMG+8uKgqybjoExnnz3w==
X-Google-Smtp-Source: AGHT+IEn+Y8AE3kEX5AkB/sFeGPR4t6lVQuTq+UDwlWj5SFZcATCZ4c86Jekd4k01WrcvjN481NL6w==
X-Received: by 2002:a05:6a20:3d8b:b0:364:13c3:3dd0 with SMTP id adf61e73a8af0-369ae58ce09mr8734759637.36.1765767916868;
        Sun, 14 Dec 2025 19:05:16 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4a::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2ad5663dsm11335787a12.17.2025.12.14.19.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 19:05:16 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com,
	miklos@szeredi.hu,
	linux-mm@kvack.org,
	athul.krishna.kr@protonmail.com,
	j.neuschaefer@gmx.net,
	carnil@debian.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings in wait_sb_inodes()
Date: Sun, 14 Dec 2025 19:00:43 -0800
Message-ID: <20251215030043.1431306-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251215030043.1431306-1-joannelkoong@gmail.com>
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 01489180017
X-Stat-Signature: b1winh8bbe4dqqamzkrqujx5g5ppr5hy
X-HE-Tag: 1765767917-600572
X-HE-Meta: U2FsdGVkX1+b+Ah87pAeJdYFtcU7PuLzV9W3JqtExo79WCJlnV0nsGuLWVVtg6kW0o9CDJUg38n58ylPP5DZRETMiuhZSNQiBY+ttptbZTUJ6IOrL3+XPcEUg+zewFEMvhHORW0UFHEA3MrCUvnMh9N+mHuzEKsG9iETQtZxvpdQSp34ymJWRlcjXLyNwElMXRRkgsMq2HKqyPFOc6b/USKgTjsw7qLCmB5mEk6S0saAUR4NKjjvHR1+6ntoyMsn419SnR7nq3BNEAQLV9ia0uRzPXItxL3hCySEpHw0QdnJDoRrOI7Kfve1XWlj4vfd1QumHnunlINo67mhoSbuWnIuKAiWfIPiI6L22x3NvH+A50aoDEVg1SpkAZzbCHCEXuvMEBKruyqnrdmiSUoQvg/Ya+nkKYbsmBsmJMxZ0LUukc9QxFgdkC/YcafBWgSDRCtkNeglxzl6/8uMeeyYCRGbBX5jeph7OuiHsJtLoCdSlg58uNcwViFSrGozUeSnQ8rz/v9OY1J7jxdkdeB9HSJdx1rkBW3yaEUEcx7GaYKzuaJhaV+XcRmYQSngymaZmOFi0QvCkxaH3T7FNgyR4OcXCI4G8Y/wyWyFhgSl+WRqCTnUoKX0vCH9VHuz4BThBi2tdBfu2lnA/XCHBcZSZBzp2O5+0n8lyg4t1DZi30SkUbeqLk6fp5kqPdaCbQ3sWF/Pt1npPyvlpQeiFGDHNJCY6M+RTv9mHd5Qu0shobfLORPZCYYwZsF5A0uWoNcboUHyCu0iKdkcb7xkvE+7tjDtmWZ8DhKX+PRKjgjNfUWls4Q6S9T8rYdu7GXSP/0ZcpHbGPxeEMunb3kOl5N5wfarniSc2emKYTFsEiG0INCyTbDbSQKHbjeeqKgVGBQbq2nD85xTozyb8pNqCNBl+fW4Ky/hmYGfQFBYdO4xHE7vdTID/Ff5KeLUrYM6Wnf+JykngQHgLPq7SAcd4Er
 FwCc/z5s
 ly+DwbJHSwoHAk8RI59f4i+JPWWEM1AR5a+0kPqNzlWQ2sMCpZl6Sg+CJ2+rpsq/vEmnz0bczRQbVfaWUUJzORbmdLYwZgckAbjklU7PaXr+Tq2lsk5/B5pp4d1BRnmNLwAyM+liOUE5czOz07D12NukXx1CVGnEjv9SP+SE1vePsIB0gIal93W87MKsaNQ0DGEEJSBVDIUKW4XT1G7n6povp2mZVwpySrUi/DYyxNGbLCu/YcQtigCLuSQT3xcArcu8mhohReTnGOlHT2IN15WazT9ecygK+RuAAjcr62BnS0zmGczRLElJiJKqd3xpWsTXMeIqUHW1x/OX6DDu/iS79aiauMUr+LQTOhut4rOInPevU4lqiHYYcJ8MlxnUu4ntF1j8wVhcR3AXeYZbwzveyJ8sXkQ6BAqIxw4Rj60LyjJ8zv8bPk4NO4pRQo58yXdWNF4TeRACnmMzx4fxYcZL22ErLezCjd5YfpZa5FyfCYF3AOgW8z+mzA5xUO30tvLzp1ulHr+4nkPPSrotSQLJOcsksR7xcpyuOeUDe11nKLyH6XGejk/4PAZdk93hNbz1uWCAwmsDp3a95h+QYVbV5X4c45P/ZObKZjrstJguW8w0efeIaufEh2YVIdysGswPK2wgnHsAYSQbYguXJvDQpvrMGpEPk0ZI3AjvByr3xu8D0YBnkAxJ4LA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Skip waiting on writeback for inodes that belong to mappings that do not
have data integrity guarantees (denoted by the AS_NO_DATA_INTEGRITY
mapping flag).

This restores fuse back to prior behavior where syncs are no-ops. This
is needed because otherwise, if a system is running a faulty fuse
server that does not reply to issued write requests, this will cause
wait_sb_inodes() to wait forever.

Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal rb tree")
Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
Reported-by: J. Neuschäfer <j.neuschaefer@gmx.net>
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fs-writeback.c       |  3 ++-
 fs/fuse/file.c          |  4 +++-
 include/linux/pagemap.h | 11 +++++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6800886c4d10..ab2e279ed3c2 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2751,7 +2751,8 @@ static void wait_sb_inodes(struct super_block *sb)
 		 * do not have the mapping lock. Skip it here, wb completion
 		 * will remove it.
 		 */
-		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
+		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
+		    mapping_no_data_integrity(mapping))
 			continue;
 
 		spin_unlock_irq(&sb->s_inode_wblist_lock);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 01bc894e9c2b..3b2a171e652f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3200,8 +3200,10 @@ void fuse_init_file_inode(struct inode *inode, unsigned int flags)
 
 	inode->i_fop = &fuse_file_operations;
 	inode->i_data.a_ops = &fuse_file_aops;
-	if (fc->writeback_cache)
+	if (fc->writeback_cache) {
 		mapping_set_writeback_may_deadlock_on_reclaim(&inode->i_data);
+		mapping_set_no_data_integrity(&inode->i_data);
+	}
 
 	INIT_LIST_HEAD(&fi->write_files);
 	INIT_LIST_HEAD(&fi->queued_writes);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 31a848485ad9..ec442af3f886 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_NO_DATA_INTEGRITY = 11, /* no data integrity guarantees */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -345,6 +346,16 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
+static inline void mapping_set_no_data_integrity(struct address_space *mapping)
+{
+	set_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
+}
+
+static inline bool mapping_no_data_integrity(const struct address_space *mapping)
+{
+	return test_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
 {
 	return mapping->gfp_mask;
-- 
2.47.3


