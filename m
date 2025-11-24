Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C40CCFD348
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959046B007B; Mon, 24 Nov 2025 14:16:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909A66B0088; Mon, 24 Nov 2025 14:16:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D18A6B0089; Mon, 24 Nov 2025 14:16:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6834E6B007B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:16:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39D481A0501
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:15 +0000 (UTC)
X-FDA: 84146456310.14.08871ED
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1E68F40007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RcVqDgIc;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obraih8eLf0OOjYF+WhdrywBlHz95tFwt0h0OBRMkZ8=;
	b=xf8+Zt+w+1+WYCnV05qQiXhf1Tk7rrD8hWMh/OsgGWRh3heM3e0vieoLZih7RNTFyJgQvA
	mZitlfscFz9cQB8sau864wCG2IvCY11+ZcDP/FVSkjjTi1Z20IUI7Xr+ZcZBw35yYEFXF6
	YrE0gSHuju+riCT799XMscJhV22Cbww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011773; a=rsa-sha256;
	cv=none;
	b=FJhNO6Eaw89hdb8KTuWoTXR1Czk4N9zwZqgTZkm6Td5GaBZcqRwMQtA4uQLv8sTwjr+kmS
	PlX0968cL+UFd22D63MhL5yGxNGwHcU9sA3adDqBz9hkaaR41R7BSbGToag25JLh7V3lno
	THEJ5V3SYn9T0Dz7HqSP5blvvNkZEHY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RcVqDgIc;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-297d4a56f97so68908115ad.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011772; x=1764616572; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=obraih8eLf0OOjYF+WhdrywBlHz95tFwt0h0OBRMkZ8=;
        b=RcVqDgIc+/UtRGB7Zu9VRLvW24a4pYz3A9z5ex84EJLM/nYYB8icMjA/6dpeaLfn0z
         qX0P+wHUcuDv2vWIlAeUegPcGb5Wf766I0VEhzvE6l1Kq1z2ka5KZ9Isb6NHMl/trdP6
         vxiLZN1QLEyIpKj7ZZCNSp7dZkPccbv0G70W/O1WSfW76GzKaONnxL49pgUCEMRdPOGs
         4/+ZoKGqNEMtwJjpvDT0BuTLoSgYafBf+iAwfvHb6OYJPh3cSP7KrBKxLa4rUcBMd4N7
         Wr+7qtjQtNGC98jwgWjtgiLy5OvjwjLamARfvKhRn4WCiycEQxrXaldbtNDvkE9OYYCG
         Jtuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011772; x=1764616572;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=obraih8eLf0OOjYF+WhdrywBlHz95tFwt0h0OBRMkZ8=;
        b=fIZ2A2eAKsP+ez8WfVv77dd+jqn+kGYZKD6rVUQ1NBRTmQFURcQzR4pA/RLst3g3ZY
         bBTh0M2StMyHvBQ43i671OO55S1u99iEQmzETMGUGbK2gYClKTSdU/TmHMBNZrTSgSeJ
         znCg4/khp78L6Bxr+2KvhARhlfql3cwwzvQbCnNMeaF5w1F0WXdD2EYs/ztjBc7Zibgj
         v1qzHrOep0NepXjKyjy5ll/Kp6ifWykUWBw48LavLE8vytTQnxKBFRxXInxkcvTHds65
         HNMnvX9p6weS7S52c0xk+obRwMgY+cV4QCIib0BAA/bdciVdL57RnTzf0cNsvBgD9UAd
         39pg==
X-Gm-Message-State: AOJu0Yw6wueqI/C2dgK4byOE/9e9pjEVm1Fw5B+MIEIvdkipiNERHESy
	5z6/6JHaINmZJtbq0rgLrM39rsUv+g3P71s3aErWzUDXTlXHNprhpHCw
X-Gm-Gg: ASbGncs7RDIoOic/QCAF2eWZQ3O1ozmWeirnOe/te8zYKXixdHjJ5XHsla+aAZmuuLb
	GK3NP4sR5k7rCptmYxr3XGBQdBDC5MEYo3nCCjWbnHAPHWZ3h3mJjsfKfOvVKjzGTCZS7MHk2+7
	Fw9p4aACWT08oQ1ge76iGa14Bmoty9iIF7uiw39JsnqZjCWRyckNx4M91jK969utVR/TWtTxpGS
	W6iCTYJkOidh7SkX+nE1aEftabB+8fez1oldvu7UroVrMwVs6R8XSxupjum2GYknUxAwmcn6EXm
	RSrq5JiMv+lo4PFbXpNr/tXVNsl5Hsvo/EKnO21D92sfO7Y35HZIiSvG2yQNGGSmryuXSOlnLlk
	EniB2CJYLV7aLKwUxGIWSGipbeLkCK4Q6l1eBK2I2Vud/9vdC49rM+FRJHJlsod/SkN27OY+9Vi
	qpeW6DSR6SgdflWJe0RvfDe9wng2Ck2uArNSOVqXNeXhBRrlaN
X-Google-Smtp-Source: AGHT+IGe78PocrlSrCBER8KtPpbn93UgwXznFo2T6cbCpPDjFbaqSNvsNNClyif7SLSaUJ9xOH6mGA==
X-Received: by 2002:a17:903:2f8d:b0:298:52a9:31d4 with SMTP id d9443c01a7336-29b6c6b87c7mr163646585ad.54.1764011771769;
        Mon, 24 Nov 2025 11:16:11 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:16:11 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:50 +0800
Subject: [PATCH v3 07/19] mm/shmem: never bypass the swap cache for
 SWP_SYNCHRONOUS_IO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-7-33f54f707a5c@tencent.com>
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
In-Reply-To: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=7744;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=mFJMctr8NWLbKAoBn+MFMi16Ti5CS/gXXQ3s4bOVo4E=;
 b=N17pfrXCrtJLWjiS9vI4Ie7s945niM4NnEl9K/tyR45NMLgbtHmGvPybvJANfb0UFKeSi3Dw3
 r2NC3i5ugLwCmwUc7hkTIJ9Nv8FQo2FjRze+wmW33V8R+Whs4ivMfnz
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1E68F40007
X-Stat-Signature: 3zkqqwqy6xbkc7thmhromfcrth3sdfwn
X-Rspam-User: 
X-HE-Tag: 1764011772-376212
X-HE-Meta: U2FsdGVkX1/s0L+zxMrPCBLW3DLNHBLND+R0U+ZcIr7IiKfpxD5CEHnjSiEtcCe9CMDJe4EjdyUs8SMGTZPMsn11J4aX72bfGFPndx/OEf+ryYhwA5uYlLvuFXBdAh4XRICTG8kIKekklOcms9h1/7fsvVcW8sv0LR00lAvNcmbvciXtQF0FuvjwKxWOO2Zz3dnHjiVb9KD7ClzXWhFSmqz25lhaXvuDNCKpr49Ldx+wuxWI3HaLfo17wktfYD0dXfPp21UJrmYU8P/ChpiX1s1hCUrDuHGrR5TdE8NfF+fEbMGlg29Uv2tNn4rVdype6VLk2iIGdnA9SKwj46dqxmlUrRiRswWiQVefbUZ2x7LdFd5YDzIMytOrtoCdVBH7S1ARfCb6mhloyaeCsIx/V/HAXsL1H0W6XrNt8VDkptk2zea10VJwFZbO/7dGLbIdcs3DsJ7m2yzfpQfP+E00Jme2V3iqoUWWWFwcPRdxeQmAMjoB/jGKuLyhmy2vN+hjDZhYNNLsPWSTgMJpLbsKz3NsgCgaVlD6jny82RwCgRWmCEEV7lvWPnLlp2KHXXvDuf/qTwTO09uRWypmMvafVleZxbQOAU0ETMqgJ6/LdQEsPBf6tuooumlkY/uHfk20wgNsw3O5dnbYszBko/4wwZT79Ljks1BkzASQqTQdb39fGt4ZUtmJ9y5UZm05ooMO/JycZKvOJb4g7sKGPwbTfoVTI57tPjSs4fbvvtBFuIkninTxYWblWp0tl1G01CSRFEWUoFRFrbjconAFLKGc6o378HkjGPUCu5W/ys+wTNEE+t3cCZ39AKeznbOQh/p4818/+PU9Bkcr0yW1jb+lgjGW1UPyJRYNS1PL4o7v8Wf0akOCHpwKPTL2ykCCxWiPYmI3CisPO16S8Y9J7emBKz/LimJ0JLuc6shMuVVZNHIZB3lPU/0KMOffW8q515jeKDoRU+akWz2fS+RK209
 2GGYzLTt
 bJAFGc6wukYTCqt5J7iKkbA/u61Ow7kXcB6lNDJtppje99ADSkd/OruloG/HNJ7VlkMaEgYPB4TqM9JanAw1GxWx3qo1kWMIcLs/rk0yACjQZEnNhPVBQkfmwvQsVx7bY7YrRAKStaMcvvWjjl4WtAJbolywNvgx+RkW89e3Qb07k+k6ZEMTjKa04z33yWLYzQ/LUxGOw1ODv3qZ5CDY31mXujLYqZ7uDspaVXiuQng0PuUrW8Kgg+5N6RGflmCUcqgOVnas91l8RDkaqKLAo+BMy6YUG3uQxk7EacHaPsJI4u8+HiKDr8M872KZxYT3Hn4+41M/Y16WOAF4MFPGNAbevGnjxAyE1D9PmeORMKxSWH09XKK18ZbHXgynvvccnyz+Ms4KIakyari5bPrf+rstTKIOL2MRMwhFztjxr6CebFQG1DWkuPTzHewP8EH3qDwzV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now the overhead of the swap cache is trivial to none, bypassing the
swap cache is no longer a valid optimization.

We have removed the cache bypass swapin for anon memory, now do the same
for shmem. Many helpers and functions can be dropped now.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/shmem.c    | 65 +++++++++++++++++------------------------------------------
 mm/swap.h     |  4 ----
 mm/swapfile.c | 35 +++++++++-----------------------
 3 files changed, 27 insertions(+), 77 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index ad18172ff831..d08248fd67ff 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2001,10 +2001,9 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		swp_entry_t entry, int order, gfp_t gfp)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct folio *new, *swapcache;
 	int nr_pages = 1 << order;
-	struct folio *new;
 	gfp_t alloc_gfp;
-	void *shadow;
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
@@ -2044,34 +2043,19 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		goto fallback;
 	}
 
-	/*
-	 * Prevent parallel swapin from proceeding with the swap cache flag.
-	 *
-	 * Of course there is another possible concurrent scenario as well,
-	 * that is to say, the swap cache flag of a large folio has already
-	 * been set by swapcache_prepare(), while another thread may have
-	 * already split the large swap entry stored in the shmem mapping.
-	 * In this case, shmem_add_to_page_cache() will help identify the
-	 * concurrent swapin and return -EEXIST.
-	 */
-	if (swapcache_prepare(entry, nr_pages)) {
+	swapcache = swapin_folio(entry, new);
+	if (swapcache != new) {
 		folio_put(new);
-		new = ERR_PTR(-EEXIST);
-		/* Try smaller folio to avoid cache conflict */
-		goto fallback;
+		if (!swapcache) {
+			/*
+			 * The new folio is charged already, swapin can
+			 * only fail due to another raced swapin.
+			 */
+			new = ERR_PTR(-EEXIST);
+			goto fallback;
+		}
 	}
-
-	__folio_set_locked(new);
-	__folio_set_swapbacked(new);
-	new->swap = entry;
-
-	memcg1_swapin(entry, nr_pages);
-	shadow = swap_cache_get_shadow(entry);
-	if (shadow)
-		workingset_refault(new, shadow);
-	folio_add_lru(new);
-	swap_read_folio(new, NULL);
-	return new;
+	return swapcache;
 fallback:
 	/* Order 0 swapin failed, nothing to fallback to, abort */
 	if (!order)
@@ -2161,8 +2145,7 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 }
 
 static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
-					 struct folio *folio, swp_entry_t swap,
-					 bool skip_swapcache)
+					 struct folio *folio, swp_entry_t swap)
 {
 	struct address_space *mapping = inode->i_mapping;
 	swp_entry_t swapin_error;
@@ -2178,8 +2161,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
-	if (!skip_swapcache)
-		swap_cache_del_folio(folio);
+	swap_cache_del_folio(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
 	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
@@ -2279,7 +2261,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	softleaf_t index_entry;
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
-	bool skip_swapcache = false;
 	int error, nr_pages, order;
 	pgoff_t offset;
 
@@ -2322,7 +2303,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 				folio = NULL;
 				goto failed;
 			}
-			skip_swapcache = true;
 		} else {
 			/* Cached swapin only supports order 0 folio */
 			folio = shmem_swapin_cluster(swap, gfp, info, index);
@@ -2378,9 +2358,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	 * and swap cache folios are never partially freed.
 	 */
 	folio_lock(folio);
-	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
-	    shmem_confirm_swap(mapping, index, swap) < 0 ||
-	    folio->swap.val != swap.val) {
+	if (!folio_matches_swap_entry(folio, swap) ||
+	    shmem_confirm_swap(mapping, index, swap) < 0) {
 		error = -EEXIST;
 		goto unlock;
 	}
@@ -2412,12 +2391,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
-	if (skip_swapcache) {
-		folio->swap.val = 0;
-		swapcache_clear(si, swap, nr_pages);
-	} else {
-		swap_cache_del_folio(folio);
-	}
+	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
 	swap_free_nr(swap, nr_pages);
 	put_swap_device(si);
@@ -2428,14 +2402,11 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (shmem_confirm_swap(mapping, index, swap) < 0)
 		error = -EEXIST;
 	if (error == -EIO)
-		shmem_set_folio_swapin_error(inode, index, folio, swap,
-					     skip_swapcache);
+		shmem_set_folio_swapin_error(inode, index, folio, swap);
 unlock:
 	if (folio)
 		folio_unlock(folio);
 failed_nolock:
-	if (skip_swapcache)
-		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
 	if (folio)
 		folio_put(folio);
 	put_swap_device(si);
diff --git a/mm/swap.h b/mm/swap.h
index 214e7d041030..e0f05babe13a 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -403,10 +403,6 @@ static inline int swap_writeout(struct folio *folio,
 	return 0;
 }
 
-static inline void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr)
-{
-}
-
 static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
 	return NULL;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index ee6bb37ab174..5853db044031 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1610,22 +1610,6 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 }
 
-static void swap_entries_put_cache(struct swap_info_struct *si,
-				   swp_entry_t entry, int nr)
-{
-	unsigned long offset = swp_offset(entry);
-	struct swap_cluster_info *ci;
-
-	ci = swap_cluster_lock(si, offset);
-	if (swap_only_has_cache(si, offset, nr)) {
-		swap_entries_free(si, ci, entry, nr);
-	} else {
-		for (int i = 0; i < nr; i++, entry.val++)
-			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
-	}
-	swap_cluster_unlock(ci);
-}
-
 static bool swap_entries_put_map(struct swap_info_struct *si,
 				 swp_entry_t entry, int nr)
 {
@@ -1761,13 +1745,21 @@ void swap_free_nr(swp_entry_t entry, int nr_pages)
 void put_swap_folio(struct folio *folio, swp_entry_t entry)
 {
 	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	unsigned long offset = swp_offset(entry);
 	int size = 1 << swap_entry_order(folio_order(folio));
 
 	si = _swap_info_get(entry);
 	if (!si)
 		return;
 
-	swap_entries_put_cache(si, entry, size);
+	ci = swap_cluster_lock(si, offset);
+	if (swap_only_has_cache(si, offset, size))
+		swap_entries_free(si, ci, entry, size);
+	else
+		for (int i = 0; i < size; i++, entry.val++)
+			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
+	swap_cluster_unlock(ci);
 }
 
 int __swap_count(swp_entry_t entry)
@@ -3780,15 +3772,6 @@ int swapcache_prepare(swp_entry_t entry, int nr)
 	return __swap_duplicate(entry, SWAP_HAS_CACHE, nr);
 }
 
-/*
- * Caller should ensure entries belong to the same folio so
- * the entries won't span cross cluster boundary.
- */
-void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr)
-{
-	swap_entries_put_cache(si, entry, nr);
-}
-
 /*
  * add_swap_count_continuation - called when a swap count is duplicated
  * beyond SWAP_MAP_MAX, it allocates a new page and links that to the entry's

-- 
2.52.0


