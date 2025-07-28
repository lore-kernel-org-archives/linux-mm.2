Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FD7C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 07:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FA96B0095; Mon, 28 Jul 2025 03:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9776B0096; Mon, 28 Jul 2025 03:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA396B0098; Mon, 28 Jul 2025 03:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E01AF6B0095
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 03:53:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF4371401B1
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:53:48 +0000 (UTC)
X-FDA: 83712909336.05.7568519
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0942B1A0005
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:53:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e9ODp4KB;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753689227;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuE5xxPZv2QYtOzFC8IOGCR1dUU/2TmA/3KupH+/Iuw=;
	b=VezDqNcIqa/mEbBeaHLtq0BH7adS81VN6u+MOhNBU+p6FIBzfSLET4/ioQZfx3n5X9vZLn
	Xw2mEx1JtMf6ulmcd0vxJnTykTwJl1GQ/MOxdCykxNlfyG/1D+hg0bc91t+BuPuiJm517x
	tIYJC+l2+baIaYx5p/+31Fufd9cd+2I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e9ODp4KB;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753689227; a=rsa-sha256;
	cv=none;
	b=GrXsmoaCgee8hsA6Xd2MCPpn7EHV2PsxUd8GWl9kTGwx2TmNqR/VU6OkVjd/oQxHVOZbbf
	hsV1unWUJbdZjzDURd9HfzsJqitGTTVVsCGj+10J+yZ8S8LL5v+LtKjIK8rUZTZKtLlGcV
	VRC4LF9nnEtRxVGlMlsuHSgEKTMOGY0=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-236470b2dceso35453575ad.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 00:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753689225; x=1754294025; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CuE5xxPZv2QYtOzFC8IOGCR1dUU/2TmA/3KupH+/Iuw=;
        b=e9ODp4KBtONERi/iPeTws8BCE/AY85MCJMcFYyvnUVCI1tht+2AldfdtdpmuXZYyH9
         KCnpwSzYQEJgTWJE2vGrMd/0r3KMWb6QqGPdyAIwP7Rdx7ZDhocQE+GyfXGp6h+rxJA7
         nFuF+ZkgnK6EJyS+JumALhDJpp20FwdolD9mZHp6jfU4o26fOaEOnwJ+Xtb0IsK6LfWz
         yaEkZI8QrZIU7NWwIXZBf9PfCI5LTrrScMsl9RWUivk1L+RNj6RLU6mbLbwPD8x6J8pP
         A6ZkBkTBnG8odnK4/lNNnOiKgRo2LILDWErfgGC92hAx5N8XnhAqlyPCB6AkoXGiWwBj
         qvMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753689225; x=1754294025;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CuE5xxPZv2QYtOzFC8IOGCR1dUU/2TmA/3KupH+/Iuw=;
        b=dXID6Dj2ptFWQqj420kc/5dkRh5fpXl1FdZG4LeDSkrfpYI3c4mi8PoCiThUGDXobK
         k7U59qqfNTcPM+o2MLZHYZnPS4pOP1l9pem3YsYcrhkrai1XeXgSxiQPJ1wL70qbyvi5
         l+56TRLmqeLRgyC2lekjLIUcEZnEhuYbez1q866xrVxR0joLqEfVjGdDFCBx1Dcm6NK0
         xCnmwJt/Ocfh/y2YQDABeC94/LW4ddPp85OnP5um5KHM8luPeDJEve6sOKw6rY1YvAal
         VW7oYzqEkjnYp5FoxY5Dk3iRGCwoD6gRfwbXM1MAxDxG7qUM9w44j7MHATC87oB9XBSQ
         uvNg==
X-Gm-Message-State: AOJu0YzVFM0Ut6GmUuePf1IFIufXyaG3TVxiUKnhzInwCvIJgRcHZ3Fm
	+FOLiTR2kl7MoyYr3voaK5R6Q6pIzxE9PmiCTQx8R9hmHSCXFkAFdKBUvgYiF8lbMlo=
X-Gm-Gg: ASbGncvP27iHhT6Jay2s3wIgTvPCwDrjIqPgafWZB8y749FfnNH7Lg6quWonJcqO1vK
	H2qOnCe1MZiYWNObQWZt/KOj6/ZhWdUzSWdYjGEVbvSPIeYjRI8BS9vSi6HHAfKTWwpCjGxx5eD
	65qHoMXRuu9xL7NonSl6wf3MZn+559B3ilz0pOIJ87JuLzF5coLYpXv7J2iiaMtej68JSpnsIlk
	h9iJ/EQVRl3QqkcO99OQEo/sDQqmg32ZyC5vY09VOOU+N5fIHqO3nLj7TB262txk8xPn6uTGF1t
	0vtQTLR3XTLhvLxJtKUJ2Y2zlRFDszXmwMiVNEJkke2r5bKWWqljvwEuOnwl2Tm2SGss3H7VKK6
	aozuqzLAQyArVrOSJwoh4fuCRRRkz8lKJxYeWlyUkM2netf8=
X-Google-Smtp-Source: AGHT+IGIxKq71r0WRuuN27uNO+LNm+gc+J/FwAAdMGJYoSQMX2/isJWZP3WNNZMOhjwCc2oEuIYTlg==
X-Received: by 2002:a17:902:f709:b0:23f:df56:c74c with SMTP id d9443c01a7336-23fdf56ca75mr72045305ad.14.1753689224929;
        Mon, 28 Jul 2025 00:53:44 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2401866c2a1sm20272305ad.4.2025.07.28.00.53.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Jul 2025 00:53:44 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Matthew Wilcox <willy@infradead.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v6 3/8] mm/shmem, swap: tidy up THP swapin checks
Date: Mon, 28 Jul 2025 15:53:01 +0800
Message-ID: <20250728075306.12704-4-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250728075306.12704-1-ryncsn@gmail.com>
References: <20250728075306.12704-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0942B1A0005
X-Rspamd-Server: rspam06
X-Stat-Signature: dwbn5ufypt16c4ai39gxzbw54qpwapqf
X-HE-Tag: 1753689226-478847
X-HE-Meta: U2FsdGVkX1+qd5cvI2yCebwyLXUM8pBigS6J+XmIjOhBq/3/CGlrvgkF16AgMh8hgWAB5vApOMp+OEm3nzrNim6wfs6Ddg78zlldGtE2ZTp8V5NFBIPzkkjLfZYYgLqPc6HadVym5Cj7JLihVNJwibPIskKfDI4XnDxQkXZxvcWF7Sek6Bq5ZHogT7T4IpvdAL6HaG7xDmMfdSRDfeMwIcuW7lByX+nPW4e5IRJB0iNyjDzdTcI3msQK09ildWXMvYhYyPLB3QPLu0OyjZCUukBJlHePx4KykaMAdKSYlvLflmOh/dVprtcZd7HnZfhrdJt3AIg5frruYjiYKGZYpjA2Jm9nZVJhEYBZ7RpjZk6He4b02KJ32I2GVoDmR7UQg3TCpm997PySp0BJhmaUPB45diJtb5dtaVQnBUMpc4ZIsIARySl3yJQsqiqWRCAFga2m2ZKawYpb0UkHlbEQdyFdk8oRL0KDtNb10mpp8NJWHuNwbBQHhzF5XVomscTG4xAFhL/a/gpqVFCWkbCYhMTouglmEsxEXLpBRMD7DFVYJ4/wO1BLmn1vwMtVDxaLuuQTfG4FE6FzHjB51usBN1kF+Dopy2QVXNmf4+/dNr0nMWfUNWhftSfADHU+WQT2ngnCJqQ4GgsCvAXi/g6WNn+Hv959jmV+ZX57tV2f2HUL7jclQhxzFpvUAoyXoW+kEUUJabgXCDiPxVw+QaPUZEecsPZVUzI0AWnxhAggiXUiq2ayT9xBa9x/FEcCmF1ElkXOMeACCweiyFp7llt4VPCip/Aq8crwB+qpsTVxRK8a5YNLtaoDo2b4NCIhHijNmyOuZ16w7fIVlQAw/mU1gNt8jN2RHgWvYg0gBhO3tkksyejanCe0t2XFsbrk7ZP4ivTQvG34sCWgSeNaZxeyr03G9VNzGGg1eaFq0cvZzVnpXz5frWZ7RB4r40NT1m37nIJnvBxeWqew1XDc2j1
 Wyi/kuen
 XzI897F1y3V0twzQvPMVozoIq7pHRF+HT/URIBt/lOzvC1rx9Cc8NJpGMq5ud0wnYZV5d0gs9IWoDsc9+kA7hXnghWd22bnaUFF/0odPV5cxJ7XAvvlRNIhHJUqn6/3tCUdk/+noV0PGb8g4QMILFzt2N+2dNC+AY9YVnNys/IIIIyDk+Z4+lCmuX2/2Wt5wv+DemBpm3TLAlQbJVHP2XjQKIo6QHiiiycu2vatGG+r52pUN/SUlcZas+W3otXKaYWaf/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Move all THP swapin related checks under CONFIG_TRANSPARENT_HUGEPAGE, so
they will be trimmed off by the compiler if not needed.

And add a WARN if shmem sees a order > 0 entry when
CONFIG_TRANSPARENT_HUGEPAGE is disabled, that should never happen unless
things went very wrong.

There should be no observable feature change except the new added WARN.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/shmem.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index da8edb363c75..881d440eeebb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2017,26 +2017,38 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		swp_entry_t entry, int order, gfp_t gfp)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	int nr_pages = 1 << order;
 	struct folio *new;
 	void *shadow;
-	int nr_pages;
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
 	 * limit chance of success with further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && order > 0) {
-		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		if (WARN_ON_ONCE(order))
+			return ERR_PTR(-EINVAL);
+	} else if (order) {
+		/*
+		 * If uffd is active for the vma, we need per-page fault
+		 * fidelity to maintain the uffd semantics, then fallback
+		 * to swapin order-0 folio, as well as for zswap case.
+		 * Any existing sub folio in the swap cache also blocks
+		 * mTHP swapin.
+		 */
+		if ((vma && unlikely(userfaultfd_armed(vma))) ||
+		     !zswap_never_enabled() ||
+		     non_swapcache_batch(entry, nr_pages) != nr_pages)
+			return ERR_PTR(-EINVAL);
 
-		gfp = limit_gfp_mask(huge_gfp, gfp);
+		gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
 	}
 
 	new = shmem_alloc_folio(gfp, order, info, index);
 	if (!new)
 		return ERR_PTR(-ENOMEM);
 
-	nr_pages = folio_nr_pages(new);
 	if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
 					   gfp, entry)) {
 		folio_put(new);
@@ -2320,9 +2332,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
-		int nr_pages = 1 << order;
-		bool fallback_order0 = false;
-
 		/* Or update major stats only when swapin succeeds?? */
 		if (fault_type) {
 			*fault_type |= VM_FAULT_MAJOR;
@@ -2330,20 +2339,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
 
-		/*
-		 * If uffd is active for the vma, we need per-page fault
-		 * fidelity to maintain the uffd semantics, then fallback
-		 * to swapin order-0 folio, as well as for zswap case.
-		 * Any existing sub folio in the swap cache also blocks
-		 * mTHP swapin.
-		 */
-		if (order > 0 && ((vma && unlikely(userfaultfd_armed(vma))) ||
-				  !zswap_never_enabled() ||
-				  non_swapcache_batch(swap, nr_pages) != nr_pages))
-			fallback_order0 = true;
-
 		/* Skip swapcache for synchronous device. */
-		if (!fallback_order0 && data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
+		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			folio = shmem_swap_alloc_folio(inode, vma, index, swap, order, gfp);
 			if (!IS_ERR(folio)) {
 				skip_swapcache = true;
-- 
2.50.1


