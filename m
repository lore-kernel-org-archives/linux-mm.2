Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F6BC87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 07:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3BDB6B0092; Mon, 28 Jul 2025 03:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED7E6B0093; Mon, 28 Jul 2025 03:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC846B0095; Mon, 28 Jul 2025 03:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CECC6B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 03:53:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F70AC0120
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:53:45 +0000 (UTC)
X-FDA: 83712909210.20.0FEE36C
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 632D9C0005
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:53:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B3x9Xiy+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753689223; a=rsa-sha256;
	cv=none;
	b=O99R9TDiJk+I3JUf1VsWRXzSAv5a45tyf3LwOO3NplLCktQl41+L1eekMDNn5Zz+ytm+cX
	Sye5KemJBKKBdDC94iKGXbWcNbIf/oNABDyfkwJ/r68ytgo90d7HF3boTpqsX1ndcYpezz
	/7Ptb3E6Oxk4UpLyJz7zOfIyLabW4Ro=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B3x9Xiy+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753689223;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WK9dh6JH6yfakGJA4pFDq4glQrsDDuFzovtqS8CVL90=;
	b=ex6UnOFv3lPOMPIcQs/55Cj7tvIyLfwX8Jf5bDxih+tXvniRuNfkU9u7U9JhlrmdrPxHgc
	ub8iYVx266v9Z3tiszoYQxX/vhIiiLsgwZjq5bkJHFAnGg3lStIuk7SE58pdo5lHpOUo0W
	JwURax/klCnEafX0doW+Q7ZfJVFL8L8=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b3226307787so3397822a12.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 00:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753689221; x=1754294021; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WK9dh6JH6yfakGJA4pFDq4glQrsDDuFzovtqS8CVL90=;
        b=B3x9Xiy+91JRxhfyf3DhDwVqJtG/j9icMG7Q4yxbRI8eIjmbJiebR+REsMeaKbKk/Z
         lPmjBKbSb5iCuxbNVpub7NTUijhA9k6lzmTxlh4kl+gka2mKVTkvuOIS7+LuntKYkeUm
         8lZuio4gW1eD/7GzSShG2HaUBb5JsfG3nP5moTQtQdGpuHzHbdiLsCV+83vTSZ73gMyJ
         Qkn3nw6pTBDYTGQx5uhrgKHbSGAfXXfPbU1OAAbOEI969ELAZY+4LauIfOjf1McfB7YI
         n1Md+o2V8jJdgtorokPAgqxvCuiOc5+VyqEZMLiIrgvQzqwVxLGoI8m+UVJvOWJlNDFU
         Hu2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753689221; x=1754294021;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WK9dh6JH6yfakGJA4pFDq4glQrsDDuFzovtqS8CVL90=;
        b=agLZs71c5UV+Jl4wDAoK6yEjX2YMbp/vqaa2L6L54I5YlMdxgEGU58D26JmRMUYi8/
         aqIUsXsE1Gdc533yonUqgb/4p787rr3vESusi16n4sQY4qgwk1C8hPFwbcaHwca08I3e
         dFHGE5XDiRcSLbGjtAXeZ7mxaIgeViHxvRBZMOgOhWdRliHAoYPyxJ4lilE0OJF7PhKT
         dwhyOt2MyrFpC3yr91rXIC0mHUFobGCGGq9Er6+c15hYO7VzM7gkuSTVsphTi2u0yuyZ
         qnD85kmCrKsqCBR4kMwesjvUgoDCCp4V8gKCUCKiVs/BZlJ1l4As6gH39zOLKO7EtPMm
         RmKg==
X-Gm-Message-State: AOJu0YwRm5H9UUm9M8RiLY5Fcfqm0i8IgOoB3ceqejxhGfO134ZnZ4JG
	ShtqY5mkfhxmwoILyh3tafkDoWM1RyRsPq2DvuYLgER29a4psw2aa2a3VujmcjCm2cY=
X-Gm-Gg: ASbGncv4TAlPs4W1ttJK+e0XDnyxfagqJE4J6t3RCWK6mOjWIZRJnqgJI6L6dne1AhS
	ZwUsLuHwfA07HxspMkWtvbGL1OU7tvqS1No5dG7n/WQ3h4rnPLItTvt5EXAi2KND9ekD8rW1dHn
	36qMWnw0L6SJJtP7TtfUzK5eWlwHJStRFdHdEVBgLzqOOLqWec5BP1cm6Eo6B+uR00+EnLkjgXe
	u2aDSC9Nfrm6uH7S2d3Iom/fBgXuefVFerHYMuukKF84oC+1BDoJDM3rMv/pkSn1DFv1nZP13yo
	TKjOwgIWspDnEFe0Ury1eQtWaGlf192RjD/fRswOYrUwMk6plUb9U33d5sqcCYVpdTIabeA5IP4
	yxtQIi+BGsU9tawjDQ/8wuLnlTN5BvmhV7N1h
X-Google-Smtp-Source: AGHT+IFulF7WReIYQE4qMeTpC92VcxNTmoJq5nsI6JchU0KIZO8LUZI5RQWcxlYsmeHQlANMK3MvXQ==
X-Received: by 2002:a17:902:fc84:b0:23f:e51b:2189 with SMTP id d9443c01a7336-23fe51b27dcmr99934935ad.17.1753689221027;
        Mon, 28 Jul 2025 00:53:41 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2401866c2a1sm20272305ad.4.2025.07.28.00.53.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Jul 2025 00:53:40 -0700 (PDT)
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
	Kairui Song <kasong@tencent.com>,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v6 2/8] mm/shmem, swap: avoid redundant Xarray lookup during swapin
Date: Mon, 28 Jul 2025 15:53:00 +0800
Message-ID: <20250728075306.12704-3-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250728075306.12704-1-ryncsn@gmail.com>
References: <20250728075306.12704-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 632D9C0005
X-Stat-Signature: fwfpjhu43osiksqr68ctcrom5kngtac1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753689223-989130
X-HE-Meta: U2FsdGVkX18ZOaX0txKOuMIfzYUsDNQ5CFw9XQzOQ9lX07hvEDUmpvpAWDWj7/5qJeDOjCpj2rXechWOb78qoCluSyxgvuSUIKHj4aU6v/46m7b51Inlz7Ye9DHVtwvfCco4VV9iEc6e7o2hep8eoJngBWNry/M6aMOYbwbYx2iUS0kSHUDPXZaLbwxoH6OTIKYNslemPXdExlWbVt6oOFareHLsvE/QXVOCnZKOHtOPWIcEKui6R/zpvJLVssxXvdLm/ekM+hQFGgcNPgdPVP1GNQEM+RKpUqTyEqpbiFhxma3mU+xHvzZNFv9ZCeqSAQpym2yJjrCesFLvb/W91wc2m+6TLPKE6NCxY6/xbDtC1ZCtMhmPoE4BNuYohycpjTGzf6hdr3ri2H5tyhum9c6jHhg92ZrhYlrBYhdWLzmoBxhajXhzGhLj+TkrzHAZesXFbcmNI822fVLl0YJfr20KXcMfpmeW9jMlNAW5SgYwjK2NcRmHa5NrCn3Ie/3ezyCeIURdq2Ix9YOkf77wDmDrUQFURkNEKiktSfu7A+FKymAB+J+D8foHhtKWeOiPsTFxa3o99eDBWLk46lhxBaNIDHuQp2+DSu/tBRAph7ICC4ROlhnO3HULqbte5X+kFF78uSYN9VhbDqzpftNU5h/njYjMAWyFG0Ec8JjtX91VClZgGJsmtAnvO00M4ljm2VAeUMcQvFjTshV0+MKl+HcE46+KXx87BA9S9dOouj2SPEHwUTGzXVTHSMpLGBxAkiY7rwdNAnvPb5dxNd41nBnqNaQF4gnq+gRIm8p/50ZoGE5wx9EzNq/EGLdpMXFm+Pf83caMgTGZZXe2wZNhz5YHr5QV9mq80oToKq4i1tNwm/7v30tbZLIOdWpdg6SjG12KXgU1nXfj/GhwepnNbwct8m1VHkKCY/Kk8YOkioj+l0NmdELaQQlOWErBdZUmOSMxLjC/cEI2yk8JY9P
 3Ip53ISd
 lij3CsR5eLqDFwyFT5mOERmMBqhBZ56l1MTF/ZNd1YpRTvXL1BPrudOT3GZQKz03J4Qf5ACCzhdxRHXYBckHl/kMekewqmrqOWAcRI4ejTn2nRdMKPcdk6U40UJ7cu9T/DbodmO0xV80v606PFim9qxNOCxgmJr70sXO0BhvGPNp5URZhe6zkJvm0oLQyaTXSIHfzAavHpIPMzAf06U8omY8hSwFFfF2gywPcZA7fTG7OkBvrjxELyGoCVR6UmosCFIaqXCXSn1LC0uClvvguSS96k3izl7pEEYg8L5uOXsxdyquKBoV9w1lgwh9IJoMXuqulFzwC5LKVXRtwJFQ2dTQFbtSsOOQ3dDdYg/xP2Byr4+g4tuEFMqGYpaNdXMfZVuFwqbNBXSKDVIPGNq3Yhv/wuK5XG1IoqnIfF55iE2qdWkdvKkB/xeG074X/5nSP14eQt3PCq/C/tCJIfMf6CpRgwW3JitNW+ShZWaePS/j8ANM6mZ2fgWRzdrcIy0f5jjeYam3JAZzsLyT9J2Q5H7I+B18T2Q0zk7XodXErgGPu2mW0Zei66i/Yv/4Hhs5IErsV5/Wpli0hc2W+hHMBJTIVBbrOw+LwWvU+rCZyCeuDaTHuFfhDXQnw3/VKfO5Q9uBuJp1ADScxehRUf7VCTckLO6fXnJMMsluQYYRWorvUfwXdghOWSgcKTCv6YjtQXNQcKstb27FY1n2mmHGTSG+T5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Currently shmem calls xa_get_order to get the swap radix entry order,
requiring a full tree walk.  This can be easily combined with the swap
entry value checking (shmem_confirm_swap) to avoid the duplicated lookup
and abort early if the entry is gone already. Which should improve the
performance.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/shmem.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 1d0fd266c29b..da8edb363c75 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -512,15 +512,27 @@ static int shmem_replace_entry(struct address_space *mapping,
 
 /*
  * Sometimes, before we decide whether to proceed or to fail, we must check
- * that an entry was not already brought back from swap by a racing thread.
+ * that an entry was not already brought back or split by a racing thread.
  *
  * Checking folio is not enough: by the time a swapcache folio is locked, it
  * might be reused, and again be swapcache, using the same swap as before.
+ * Returns the swap entry's order if it still presents, else returns -1.
  */
-static bool shmem_confirm_swap(struct address_space *mapping,
-			       pgoff_t index, swp_entry_t swap)
+static int shmem_confirm_swap(struct address_space *mapping, pgoff_t index,
+			      swp_entry_t swap)
 {
-	return xa_load(&mapping->i_pages, index) == swp_to_radix_entry(swap);
+	XA_STATE(xas, &mapping->i_pages, index);
+	int ret = -1;
+	void *entry;
+
+	rcu_read_lock();
+	do {
+		entry = xas_load(&xas);
+		if (entry == swp_to_radix_entry(swap))
+			ret = xas_get_order(&xas);
+	} while (xas_retry(&xas, entry));
+	rcu_read_unlock();
+	return ret;
 }
 
 /*
@@ -2293,16 +2305,20 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		return -EIO;
 
 	si = get_swap_device(swap);
-	if (!si) {
-		if (!shmem_confirm_swap(mapping, index, swap))
+	order = shmem_confirm_swap(mapping, index, swap);
+	if (unlikely(!si)) {
+		if (order < 0)
 			return -EEXIST;
 		else
 			return -EINVAL;
 	}
+	if (unlikely(order < 0)) {
+		put_swap_device(si);
+		return -EEXIST;
+	}
 
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
-	order = xa_get_order(&mapping->i_pages, index);
 	if (!folio) {
 		int nr_pages = 1 << order;
 		bool fallback_order0 = false;
@@ -2412,7 +2428,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	 */
 	folio_lock(folio);
 	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
-	    !shmem_confirm_swap(mapping, index, swap) ||
+	    shmem_confirm_swap(mapping, index, swap) < 0 ||
 	    folio->swap.val != swap.val) {
 		error = -EEXIST;
 		goto unlock;
@@ -2460,7 +2476,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	*foliop = folio;
 	return 0;
 failed:
-	if (!shmem_confirm_swap(mapping, index, swap))
+	if (shmem_confirm_swap(mapping, index, swap) < 0)
 		error = -EEXIST;
 	if (error == -EIO)
 		shmem_set_folio_swapin_error(inode, index, folio, swap,
-- 
2.50.1


