Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B393D2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 17:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE2286B0088; Sun, 11 Jan 2026 12:55:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCD686B0089; Sun, 11 Jan 2026 12:55:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACBF16B008A; Sun, 11 Jan 2026 12:55:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F5F66B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:55:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40B538D26F
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 17:55:13 +0000 (UTC)
X-FDA: 84320434506.03.5A62C7D
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5145F140008
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 17:55:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=imcWK57f;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768154111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mn2Hr5PSunu94OsN9KDSKjc7Q62FgkjIKfj/HXbAqXQ=;
	b=JEBWr+Rqj9SEoGktxH6CrYG8DzqgVVYlf9pQWaBb9bvVtB/wdwEZWLi7N6JXksgo8X5jNQ
	M257nqW/WDGNG96eNG/BG4nKRMWMC52WItgxe/VMeOJKfAPArBjnbANBlyQGf0qjCmMpfd
	hmHNur7rPBJ2UdZrMfZS+IdEdNl9OAE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=imcWK57f;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768154111; a=rsa-sha256;
	cv=none;
	b=psUEpFqbYMXci2qKmjPJLt/WXemuYnVJi6ypmQGqHAfAN8qDCS3hvRjRsyfhrt17DHyz16
	U0VgR/mKD9vuBGFHke2pjvbZqjlqWuUXGH+NaTApZEhMzN61f2ZRB/3Hzwv9EHDXXAsSm+
	cxv4zDNBNhbEKjuskqTgzfI4BDgTO/Q=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a0833b5aeeso57587215ad.1
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 09:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768154110; x=1768758910; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mn2Hr5PSunu94OsN9KDSKjc7Q62FgkjIKfj/HXbAqXQ=;
        b=imcWK57flPFby4P/eEoSx13b0J9z8jmQDKM7FGXLplqASMWEnSKQGD2CLO+iWyyLcX
         4nEMPd54we2RqrROUrFbNrnQuS8ZUSuEmPvcySQI4XrOB6P8GmUxu5INPy25fgiM1Oef
         ka45yyIPjag09A9VBXgSyb6OtEnNGtgH/xOpfrCqtxOPR4YwJGwZjO2KFpBc04qpbPa2
         oYPZwVbydKaRVOE8X7AzMhUT+CUhdZEJ0tAWQ7/5fPTm+TSak7899dwllVYydfppXVHu
         gDmEBVUN0FLpMzOjvfLJh/mF+eNuoq1gEg65DfXAv4lAX1BeTCetpEvCoVuEQB1yoaLc
         IKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768154110; x=1768758910;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mn2Hr5PSunu94OsN9KDSKjc7Q62FgkjIKfj/HXbAqXQ=;
        b=M208wmtIOZeWRWPw7PuFKBxi8n0K2/TtTtVdrLH2MwN03RS6MN5ub1ZgNyvQTwvYdQ
         RsyDewAk8Q3PW3VDMO82E0l13WRedY+GVr/vOBTcjMpz1X2YZeQtW7N4sx56HerF+gdC
         +zNxbMh4roYJcfPlJ2vtHBWpZ963O/i99dkKiOtLNuuB/yQ72lrLDBccC9eqDe/EgR4P
         5z+4MWzZyxj6Zaz/dA3m6hjkb0v91/ogn9PmD1pGPDu6NbCg1ajosoOsTBm7ATNBaEKA
         3+qZXzla9Sy1k8Z/oQKFsitmxD+Tp3Y1MNhyVlXHeRvUgc8de6bS9dM800dXlACgDzBA
         H3Kw==
X-Gm-Message-State: AOJu0YzOOPOi+kTP4FKpRij7kVqCR29zRPtFZYeVD5LXUH8U7aNbT4mx
	oyM0aWkvTjTCbrnAcKoxYZuaTl1mYJpwRb2hgAxQkR9DdC9ObKE4OiUm
X-Gm-Gg: AY/fxX5frx8pbz9ox+K94TEFVQbaYzKjklBoqnzhl1Lf4dv3xX5rMutALx5/vYSMG3W
	AAfV7jcl3oA3GOd4D27oCOiLRGKTMtyhurxjziPnFV8TMFI886rF/7awin6h05BzrAUSz9aMWQG
	ZRY4ix9evKtWGcb1XTm6KrO/pO0gviypHI23z5H2k2NAZAHT5k3+EUh0WNcGYGpxV0nbM6WqZ+M
	AhCf8eBuorQPPcKpEFBc05b4cA1TcIvlnsCmoIeuCE69JpvnLx2ghAx7YGOHWHom5Sq25vWzLS0
	0kVw2luYrcf0ntKY0enGRw+o3rDttQEEraG7FJHIRZwTtWykgGPEiOr6QGsF4EPNwe8+wcNa+fa
	dDd4K9IQbFC9Xrkl1o/UoqKRhgUm/pp05MQm6K4sWqcdJTC8CGpXRvp8e+XX/PXytbYfRe1rH5C
	PfoFdbi6bqmF0LqQeCZSNP3jhOYZQ5tuBekMTdRb4zcV12cFfk
X-Google-Smtp-Source: AGHT+IGRjrIuMsl7ABTtavQCHRXkK5SahpOXls7YS4dgUaOY68TrcZCDlcWyyr8kisqTY0HybKOKCA==
X-Received: by 2002:a17:903:184:b0:29d:65ed:f481 with SMTP id d9443c01a7336-2a3ee3411bcmr170291295ad.0.1768154109952;
        Sun, 11 Jan 2026 09:55:09 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c3ae21sm150500795ad.7.2026.01.11.09.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 09:55:09 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 12 Jan 2026 01:53:36 +0800
Subject: [PATCH] mm/shmem, swap: fix race of truncate and swap entry split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-shmem-swap-fix-v1-1-0f347f4f6952@tencent.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqAMAzAviI9W1iHivgV8TBddT1MZQUVhn93e
 EwgyaCchBWGKkPiS1SOvQDVFSzB7Ruj+MJgje0MEaGGyBH1dieu8mDvDVvjqJlbDyU6Exf9D8f
 pfT+UL/4gYAAAAA==
X-Change-ID: 20260111-shmem-swap-fix-8d0e20a14b5d
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768154106; l=3256;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=y8LXMuvlkDlyCTV58KsaetOE+va9ri7lv7P7G8ssw0g=;
 b=RVEa+tGwO0D/Cduu3BeHX+GntDWMUg1Lbu+Rm6zDB+3EfubeQAdCLcFf/7clzYQEZ1TYn9esm
 O65mahA2w1DASc67hy1Xh1z739U0JTywGL2xQIYerk3c9KQ0UdMBG2A
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: 5145F140008
X-Stat-Signature: c8aj7yz54aoioo5co3xfnta68qip1gmd
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768154111-31722
X-HE-Meta: U2FsdGVkX19u4Bjw1LVrwZdEplwdNuGPZTjAqCU6/NZx0YRh2V1Ovp24eK82Vwn+uKV1+jNiQCOHVBOP+TjH4amcrOob8BpCISwBv1Opf7etPUbEGi/sGlwNTVxNofKH5GEIpPX8SfwXOsa8n38oGK4OxQYI4DbJNI1D/wWBf/PkdET60D3GH5rmTCQ6YMpv8B+Iy9hw7pYnraXNknVRl795j1h1Sn17iwVny+Ch5BQ32pK8ojRyKShMM+f7IwyelHS0qSkQnnjAfdP4ywd9cew0ABeENmuuju6JGof4VJASNtAZLsfLx8z1tBZ1899e0DjdtuXNVl1NVmSqmSn0/qa6hC2kD4OOZ5oCe1ex5omrJ2FUG4ZRa3ecmZ7NHzK+mm5UHN8JZ8zhOlBivAW7lu/znuuJT+A8Eu03TKcFRyoIRIDlNHnr2pKPAyOB4yclYFbZ7KOqOsiqspj8FgJSiHVYAnZycWSqkMAeqSO2ny6gUUtV2HkNPQyvUv48ZltnBCCaBvH7rsNrty3MGBHNeNHqVaobiz769C1LWnCku9IhoKah2k7sljGCQrHOuxHf4OQaIrwRfR+TOk3rysjc8wAu79avUQMUkbWrFTSYU0rAKHu9JqIsL/vSQ9y+RY9CV5URYn/uRhWfDP8nwkius8FdAk9h2eZERas7a7GuDNOse6/yvXW7pTbbq2H8W6kO2wZarGAoH+L+W34rMyfxKW/zejWIKKNMsU9w2zlBT3nundt6iwoXbaT2o7KrT5yQaZI61V5YXqdHo/WsO8kXyta2gkSSFA9YJPAsZI9FalGXFyFE+fOJaDKEeb4NbGXOcAMDTvf5YxMyzYlG6LsLO4P+aW6VehwavDY4GijgBaq6jtj1j9Gs4UGAUnBrsHyPyWHv3vb+z/GSTGv+M0qTSSpfHDexOE9l1CM8SKA4RlSAjsQDJdbvcWjwfqo0ndyNq7iGJyPci3vNRmTAU2a
 o/sanp0k
 iiRtqzPZpBi93gthh0FNcK78FOtQHvXMDi1cnDCuCw83LcdmQTFPqUZZAekqCKpNYEnfDvbzDuT+diGAPQDehy0bSRik0ml2PuCVfDpH1bHlVqJPLnJ7no8u7sFIICqzGTUexms8JUmh1y2LCbOLnDmMKnPNDkKbhXZCon4AZoRRBDCfP8B3KRsFejuVNHd66k0mLnyZA4cksayK9LBv4L2/O04KnQavcQThGj6oh1PsxEhK4YO9ASURfcECWFSNQJghNGRXk9LbitL96Q92oaantUffUzMUUj6XnTXyCiAKUotjV3Tka8pOxYJVhIZJinYMTlrZFjjS8kVdAqPK4KfdkOHAjP5nX8VMfvpC2hWFsZFc+sxvmEiszo7YRj37e11o6idk895072yzc+ZATmszKYw8W10ZR3zUjI5A/zfDPDb/qEkgnumtrF5+ppDaQCVJ5VQtaf+Ol6iC1Hg18NLA/P1MRl9PRS0bYM1iHSxaiUUHG0RuDrp+WIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The helper for shmem swap freeing is not handling the order of swap
entries correctly. It uses xa_cmpxchg_irq to erase the swap entry,
but it gets the entry order before that using xa_get_order
without lock protection. As a result the order could be a stalled value
if the entry is split after the xa_get_order and before the
xa_cmpxchg_irq. In fact that are more way for other races to occur
during the time window.

To fix that, open code the Xarray cmpxchg and put the order retrivial and
value checking in the same critical section. Also ensure the order won't
exceed the truncate border.

I observed random swapoff hangs and swap entry leaks when stress
testing ZSWAP with shmem. After applying this patch, the problem is resolved.

Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Cc: stable@vger.kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/shmem.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 0b4c8c70d017..e160da0cd30f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -961,18 +961,28 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
  * the number of pages being freed. 0 means entry not found in XArray (0 pages
  * being freed).
  */
-static long shmem_free_swap(struct address_space *mapping,
-			    pgoff_t index, void *radswap)
+static long shmem_free_swap(struct address_space *mapping, pgoff_t index,
+			    unsigned int max_nr, void *radswap)
 {
-	int order = xa_get_order(&mapping->i_pages, index);
-	void *old;
+	XA_STATE(xas, &mapping->i_pages, index);
+	unsigned int nr_pages = 0;
+	void *entry;
 
-	old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
-	if (old != radswap)
-		return 0;
-	swap_put_entries_direct(radix_to_swp_entry(radswap), 1 << order);
+	xas_lock_irq(&xas);
+	entry = xas_load(&xas);
+	if (entry == radswap) {
+		nr_pages = 1 << xas_get_order(&xas);
+		if (index == round_down(xas.xa_index, nr_pages) && nr_pages < max_nr)
+			xas_store(&xas, NULL);
+		else
+			nr_pages = 0;
+	}
+	xas_unlock_irq(&xas);
+
+	if (nr_pages)
+		swap_put_entries_direct(radix_to_swp_entry(radswap), nr_pages);
 
-	return 1 << order;
+	return nr_pages;
 }
 
 /*
@@ -1124,8 +1134,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				nr_swaps_freed += shmem_free_swap(mapping,
-							indices[i], folio);
+				nr_swaps_freed += shmem_free_swap(mapping, indices[i],
+								  end - indices[i], folio);
 				continue;
 			}
 
@@ -1195,7 +1205,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 
 				if (unfalloc)
 					continue;
-				swaps_freed = shmem_free_swap(mapping, indices[i], folio);
+				swaps_freed = shmem_free_swap(mapping, indices[i],
+							      end - indices[i], folio);
 				if (!swaps_freed) {
 					/* Swap was replaced by page: retry */
 					index = indices[i];

---
base-commit: ab3d40bdac831c67e130fda12f3011505556500f
change-id: 20260111-shmem-swap-fix-8d0e20a14b5d

Best regards,
-- 
Kairui Song <kasong@tencent.com>


