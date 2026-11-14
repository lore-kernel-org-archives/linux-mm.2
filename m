Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D62606A339
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vbhrlrxd
Received: by kanga.kvack.org (Postfix)
	id BABF96B05BC; Sat, 14 Nov 2026 09:50:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5D2F6B05BD; Sat, 14 Nov 2026 09:50:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B5B6B05BE; Sat, 14 Nov 2026 09:50:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 617DB6B05BC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:50:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D398F160416
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:50:27 +0000 (UTC)
X-FDA: 85434010494.15.0A89D71
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 17DDC1A0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:50:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vbhrlrxd;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJc/y2I20WRTL00Fzg1UskbrU2jIAE41tHgcdSdOm3s=;
	b=zHBGRI5JJ+1m99sinOgeu814wjXCYA4ufWuR4bZg+F/oTzQQwvRNMynbngA2kzQnbzsz0E
	CKuOPA1I4xE8UZw7y6gQ9jyPC+Ru4Shv0o8CUozAatifv/lQswlboEZ1zbz6SP7lmtiLwg
	978wdK6b0e4mF+LsS5KXoip22Sk7XP0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667826;
	b=PQvjrpBF3g5gnPcs894hhMDE1LlGBre6IIx71dggeQBLOJjHFbdDJhfJzX37gRRZsuszhY
	K2vg/NMVmDUSsibLQ7T6spPblPI/ponBgJs3XGCkHIGrNQR8xM0RAzJPz58vKx/MuYpaZU
	fUlYIXYXTNlCnVzz+r2mhTgUyN4tHko=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vbhrlrxd;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ed06b725fdso20516285ad.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667825; x=1795272625; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lJc/y2I20WRTL00Fzg1UskbrU2jIAE41tHgcdSdOm3s=;
        b=vbhrlrxdE206/F3LHlFEt/BV4KYQ5xaGqIcn1IWWejqeA1j0vLK9ee80J2s2zddFf6
         WlpBt5K0yFmiQA5XpgCeMvbtPtPDVPRH3RUjMQNwldZD9IKcA71H9T7jzNgu1wpdh4uE
         SnHxU7VbDH3LK6XgpNoRsPtgi/25da//6xF6uIc5JuQww+0mHzjdRRSZf8Sjwzn5Y7XV
         ViimLpNI6npgFDsacnbG+liLBB7KopZVF987lzoMJlJBL75zHjBzZ5Y4H/RueZZjUKHa
         TWcZI6QEv8YSdvtKxXSRpuwhZmftxJLK/p86gFPol0wrHPdP6RoaNYQp05OyeMK9vZQC
         /N2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667825; x=1795272625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lJc/y2I20WRTL00Fzg1UskbrU2jIAE41tHgcdSdOm3s=;
        b=b2fz/pTDe1nacqOpRP9c12T5rF9S0NVRMgz0KcGVMgOl9deeTaV3K5lHdOLuqhZg94
         U9JDSqDzKM9jVWVFhfY1tw21LUpqGxDMyih/6BMkKbUswjMxo/OE/SmeGkBak+9fK29J
         A1zWlf3GdDwd1Q/6cW/DyV4JkHbhmMtP/Fygy/998imrbVDcHl1/7V3se24LsdK+MTcv
         dsHod88X95M4ogDVDJlQVKDO/2gSZBRlwyNNHVbOrVZv8ds2HGH42mCz/FKyQjGbTc5v
         h7EHu2eTlLAuI0ZmF5l64216SAD4ddIF0A3VTF4KcliiyN7Td7gn2HHWB9LV2ihNjEtY
         WVog==
X-Gm-Message-State: APuU4Z8V2RJwakFF51gdEypdNFoAgjkzf6NlGUidmfw0nzF6SKGZoylT
	mBD9wOHWFb+5+10zQGI9shTx3ZEPr5yR7kLg8MIbhRyL5qK9RRMaRoG5ABr/vA==
X-Gm-Gg: AYBFou0CwFgMZ/hVHRH1Giy9dUoWLyXqpS+YT3aAJ0kniwuiJLEpdmQJDEvg7K88WEN
	voIie87VrFPmFAMBRbwP3QL6smyn81neC837Z2QaKw3HnSV4h/Y1iLiEI1Lhm02zygojXgmyM44
	KBfk2TYVpZ1PQv+bHDn4Mm51BcrXTbcMUbgCoFmi6zVCb/Rv2+HLSXpht+viIHNP3voi3DhfkEP
	3L2yz+A6/ZIkVD3zh9mNIm8f5cfBbtTbGn6Hu8MJC65QiRtWFSNlkdSnfBRm0YLbgqKGsVgOr57
	371ctaUSf9XYaM1Uvwi5coBjyUDH5bQNippa6LE+J4HJHQ0lSbUSF6FbiIstX4K2C+t0/hZLnQ+
	9WxaaBsUYDZyN3HZtMOqeHTO1QXutjO7qDRa/a4SKQ0oth2Lioi1noMBtang79M2fkdwFazD/3j
	IBkHLEZlorcUUYlCC3xMPWSZ1jjPJACQbN/kuIv52xtEzHcctOmuwHHOdocpuChY68qi5+n8Xxa
	NxSujyLUkqZcqTK6mXIyIvdd3X8c30/yOJTO6jLY+kNZTzqZjxNL0LltwOzXiUoKtbPV000+HjJ
	fV5USw+6LZVwYKLNS4DyMoE9pyg2EzElAJhJTBE1FeGuJeQymuGO0x7oQxmPZLQ8EHAr
X-Received: by 2002:a17:902:c401:b0:2cf:7db9:e13e with SMTP id d9443c01a7336-2ee0d9fce78mr42048925ad.3.1794667824888;
        Sat, 14 Nov 2026 06:50:24 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f8d708fsm20733985ad.58.2026.11.14.06.50.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:50:24 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v4 07/18] mm/swap: consolidate swap inuse accounting helpers
Date: Sat, 14 Nov 2026 22:50:09 +0800
Message-ID: <4e554bbb557d0456c953d73f008875f6d983b12f.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: biykktpfnsji5mj1dy7ir9q7rrdkpopn
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 17DDC1A0005
X-Rspam-User: 
X-HE-Tag: 1794667825-445961
X-HE-Meta: U2FsdGVkX19G8R1AsojF32eQgYWli12SgCFmhvEZ3PelclpPemv2/YLSO/ZUVMm2n2JRdck264Pv45RXIAy6Wet35tBlWFlS9xGeMufJwUO/opQti9+mwdeXpfC+QDhPFhOAkgS+XWspSkq/k9a84lBfM5lNaXxeRPQgM8qCTRslmTceYyjkAHBZ6aYG34uSONjfDpPQoGJI2WolPtq++bAep5AEiQhy5ePEfSq0hBjeubsrmC7TX0lgeiUiFrIj3ho5WnHsHYFeSEP6T4/1/hMjw8RIT2/h7uMURcylU3v6gQO8RCwDacFpHiWmqRvwMH9dcygHoWjdsZBEU3vSDBRPZ1j2T9pEC4WU2AYaZyYwap1zEVP83/yJHIvtEQJ9FMUtIGIBaRhN30P7S5us2NKl9zWU/mMAHr6cQBzfbznWSoT1fg3VObCeZIcr/CyKqJmPfDGxZAoBgnoWsqofZPS19DcgqFTHNvdunC1ndxj0GK20Kdx2tJ52ovm6ReMY0yyW4Dm+Pd4QrV9n5Mrj2SjYu0xulyKJjA49Ol2txew2yHV8SY5nuQiVpgtEac0yYDFIAAg7SAl7uFxUWxcLAqSX45TcvzcFlnWodxZzKxY4+ScQhkf6NImzh81O+toqEkhiuHB/UwYuH64jtr51Ds2DoiaMuylbNFMYJBKudAg16ytnByVI7sXMjYru6+dqtNiH3v4p6yTnC8SKfDz4at9GcQPNtAMVT9jDAh0NPdT5fPIacrkyoyJ7Y4MCuMoMQW7V9bNIbiwRD92FvXnr2LZhizTFKJLXEv40tMSqUjfP+s/vEDZKdUfGxzGis6299GmOuP+lNFItJ2nIt4wNfbq1fpfNPs9p1Nm2EmtHleS81p5b3EZ4fK2qHf/H+JObqSNwRrVTAytJP+XeJaitxwq4F+8rXkJrlR259XPPUKKyPcfxaH3qKew3rAuSNK8to8E23NErkC1g8H9gs3S
 b8YnMymn
 D5REngIE7vBknlPpM4k6rXn9pWgHou1nBrf6wY0WBREZc9vxcPidSt8mRURuX7cWMG07kssgYCxNAaCmXAQMRBw3iwuPFMvb59xVKwT2bDeNajGbl8Pcn7i8wSK/Qc4pdx8hmzrLmtmTrno62K+NicxpAId9t6rqcSMkGCr2dazRslATKVgogPK6uO38dqylUhMg8mKyF0vFjcan31eu0xS5DnFynzOrrsmE4erS6rhsLBoC6bKk3gX8j9v04sK6X69ojBliFVeEpWURKnnIRCUrTTqxHGtw8UYspXeu3Fj4KHXI+ivJ1nfYbBTaT7H5PCS0H15FzCLxxXOCVK3iTep0ZtnuSSSk8cIXVEHU0nMZAyAgljPiGHFR8jhABWF3flRhY6e9wiymtkGBumxiInXGIvwYBg42t9hBpvgFFnA+zSB0hU8aVJHpYgA2fkMgGCiZZzAcoYTZpRHJeFpVff12FGJWi/XrLXox1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Inline the swap_usage_add/sub helpers into their only callers and
rename the callers to better reflect what they actually do: track
per-device inuse page counts.

Keep the existing accounting and allocation policy. In the inlined
full-device path, reclaim work is scheduled before availability removal
rather than afterwards. Slot-free notifications and zswap invalidation
retain their existing order.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 64 ++++++++++++++++++++++-----------------------------
 1 file changed, 27 insertions(+), 37 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 277a5c749987..aa020f2706b4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -49,8 +49,8 @@
 #include "internal.h"
 #include "swap.h"
 
-static void swap_range_alloc(struct swap_info_struct *si,
-			     unsigned int nr_entries);
+static void swap_device_inuse_add(struct swap_info_struct *si,
+				  unsigned int nr_entries);
 static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
@@ -1045,7 +1045,7 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 	if (cluster_is_empty(ci))
 		ci->order = order;
 	ci->count += nr_pages;
-	swap_range_alloc(si, nr_pages);
+	swap_device_inuse_add(si, nr_pages);
 
 	return true;
 }
@@ -1363,53 +1363,36 @@ static void add_to_avail_list(struct swap_info_struct *si)
 }
 
 /*
- * swap_usage_add / swap_usage_sub of each slot are serialized by ci->lock
- * within each cluster, so the total contribution to the global counter should
- * always be positive and cannot exceed the total number of usable slots.
+ * swap_device_inuse_add / swap_device_inuse_sub are called within cluster
+ * update critical sections and serialized by ci->lock within each cluster,
+ * so the total contribution to the global counter should always be positive
+ * and cannot exceed the total number of usable slots.
  */
-static bool swap_usage_add(struct swap_info_struct *si, unsigned int nr_entries)
+static void swap_device_inuse_add(struct swap_info_struct *si,
+				  unsigned int nr_entries)
 {
-	long val = atomic_long_add_return_relaxed(nr_entries, &si->inuse_pages);
+	long inuse_pages;
 
 	/*
 	 * If device is full, and SWAP_USAGE_OFFLIST_BIT is not set,
 	 * remove it from the plist.
 	 */
-	if (unlikely(val == si->pages)) {
-		del_from_avail_list(si, false);
-		return true;
-	}
-
-	return false;
-}
-
-static void swap_usage_sub(struct swap_info_struct *si, unsigned int nr_entries)
-{
-	long val = atomic_long_sub_return_relaxed(nr_entries, &si->inuse_pages);
-
-	/*
-	 * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
-	 * add it to the plist.
-	 */
-	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
-		add_to_avail_list(si);
-}
-
-static void swap_range_alloc(struct swap_info_struct *si,
-			     unsigned int nr_entries)
-{
-	if (swap_usage_add(si, nr_entries)) {
+	inuse_pages = atomic_long_add_return_relaxed(nr_entries, &si->inuse_pages);
+	if (unlikely(inuse_pages == si->pages)) {
 		if (vm_swap_full())
 			schedule_work(&si->reclaim_work);
+		del_from_avail_list(si, false);
 	}
+
 	atomic_long_sub(nr_entries, &nr_swap_pages);
 }
 
-static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
-			    unsigned int nr_entries)
+static void swap_device_inuse_sub(struct swap_info_struct *si, unsigned long offset,
+				  unsigned int nr_entries)
 {
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
+	long inuse_pages;
 
 	zswap_invalidate(si->type, offset, nr_entries);
 
@@ -1431,7 +1414,14 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	 */
 	smp_wmb();
 	atomic_long_add(nr_entries, &nr_swap_pages);
-	swap_usage_sub(si, nr_entries);
+
+	/*
+	 * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
+	 * add it back to the plist.
+	 */
+	inuse_pages = atomic_long_sub_return_relaxed(nr_entries, &si->inuse_pages);
+	if (unlikely(inuse_pages & SWAP_USAGE_OFFLIST_BIT))
+		add_to_avail_list(si);
 }
 
 static bool get_swap_device_info(struct swap_info_struct *si)
@@ -2059,7 +2049,7 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	if (batch_id)
 		mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
 
-	swap_range_free(si, ci_head + ci_start, nr_pages);
+	swap_device_inuse_sub(si, ci_head + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
 
 	if (!ci->count)
@@ -2999,7 +2989,7 @@ static int try_to_unuse(unsigned int type)
 success:
 	/*
 	 * Make sure that further cleanups after try_to_unuse() returns happen
-	 * after swap_range_free() reduces si->inuse_pages to 0.
+	 * after swap_device_inuse_sub() reduces si->inuse_pages to 0.
 	 */
 	smp_mb();
 	return 0;

