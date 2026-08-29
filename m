Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65F4CC61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8BF6B00A2; Sat, 29 Aug 2026 03:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759006B00A3; Sat, 29 Aug 2026 03:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F336B00A4; Sat, 29 Aug 2026 03:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31D9A6B00A2
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:47:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A32B91A064C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:47:56 +0000 (UTC)
X-FDA: 85153528152.07.48005F5
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id D6562180002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:47:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gVaDrtpN;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7vGEGo1ju5lk19uFkoLxptYJ6h4M8dZ1YyQasiBTx1o=;
	b=JZtr2QKWViWZXDkdrsfLTTnDIlrFVyOlnNmwJi2/3m1ZJj/APVX9dO8LF0nN5sIcjfjRU7
	F77aeaUX0QYzOvJ2VNG8Cbho4eq4OtAHD5Bey+VTswG7CgD5w6USVy0IU3d6tDIQkD6SUN
	IPIik2QSYOZj5B2SGXeId9VUEiYDp9U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989674;
	b=KvcCxkGs2s5EtG/pTlzvHjnTAtU09jZOjq3AW6lnetGfNpD6rcAGWEUJZKgmczaH1CVDrD
	jJ/d02ndy9/tqmek8T8bogbQ5ohxt91qSGZDDNpp+NFuBFU4Dljs2hHjeilpaJAlP9iFGK
	nLPfxFDZbBGPD1mh+FPYpOgq3og4+hk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gVaDrtpN;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-853e2610bb4so2043602b3a.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989674; x=1788594474; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7vGEGo1ju5lk19uFkoLxptYJ6h4M8dZ1YyQasiBTx1o=;
        b=gVaDrtpN0N50gF1jQ7Cu+H5v/ozY1ah4xtrG+sVTovTxV+aJ3sVnf8/YNm6h+ZnxfV
         Q6HSQv89E9gbfv4rkfcBouSaoLMrzqkgYKwhegs7WWFfE2I/+hoesnZ3szaInghxA4GF
         3A+jlBEOW1YI+KbA9//3ZKYJoTkD3y+7qkuqla2TaJzYmT4rkbsp+/ckF8s1Qrpj/TYY
         ETCjG30UndiGmsUMMN7zQxRr+HVfOw09QzvrTW4A+a69z/wE7eZGxQujue/7APPz01P5
         SPl/IOtCVJW26jmFkutQvRYG236EaPyNzEU7ZygDZ23FyibSPp9YZTspsO0ObO/UxM37
         zpNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989674; x=1788594474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7vGEGo1ju5lk19uFkoLxptYJ6h4M8dZ1YyQasiBTx1o=;
        b=DU4vDiSVDD2wbuXVeFSKTeqNf5RQ8Py3a3nSiJWicvgUKYZkw0MEomSg3Oba1awWS6
         ZJIN3XPIYQzE6nr4b4NF5ry+wjXwYqSKZUYmzW3h6C7ljtyZ6Y/vrMGm6hDmJdsf6dvD
         7MIc2+6zuZW0STD3iIVGmLG0abbcAKtL2stOLMZQtnQG4oJLdW2CjDiayvCnPecGtp0J
         OpkP2Pdc0nCsKXZcc8Hb1K/n80ns9Uc5pPFVnAEBuyMAn/BicqsXJl9MFYfXq2xWgIzg
         k/cGRCAhSxNr2i7LFaNfhYyUcK1YoGrbJ3/xPxSB3FYWa/4qGRM9Zh5O8ArCGjK0POKm
         SokA==
X-Gm-Message-State: AFuF++kqHTCsAyDBEAbyNCfqHXnupZvaZkN3hxKVMS+8+LI6WyWivn+K
	9HsSmn+oGbuXUVxNAjmIN+eyz2GM+aA/TBvNd/PUZbsYDAgn0C8g4QnDUBH8mA==
X-Gm-Gg: AR+sD12Ys7NChXq+7wyCREYCLqcvBBEnNz73NhhXY1022tonSQuj6BztfxGRebKOCyr
	lDJbc3Hx57X8PHC0yjpGOSatl8be/eqhfS3ldNlhdzAMuikfqJfVa/EFMVF+bEXDQIReyAdIdam
	I9/bdGcKVYOG7zwK89Nla7JHqoGu0TWNUX8FtmLBpeXiigArBMJqoiBOdhnfdN1kXR2EodB7GP4
	CTK8IUYCJz3W1xClMQ5znjFgpU1p0jg3xE3PFR8YflkyFGL7n9BA4PkWk+GDTAJ3O0pmnNLiVbc
	iRjUSWYe5HGB5Kv64NTg6Lgc2xWqzpA9QdPlnTpr1LVmkidH/6jYJ+Whd1SNk7wAPeOdzgUxiG0
	nntj2BsLdZs93QffXw5MFrGJtdysef3+X+lg5zt41OT5RXEOjZK8CxvUNdoey8DDNBgmqdFNCaj
	gNEtGltK49QKtg5DzbKSzJdPD8SY7gSYX7r4R00fOF86/szUwbsiBdkK3NQe+LCv2J6N5Y9lHNY
	fy0Ja894HTYjALhC/7INRPTEpBH
X-Received: by 2002:a05:6a00:ae07:b0:842:63f5:d097 with SMTP id d2e1a72fcca58-854c6485ba9mr21043098b3a.3.1787989673723;
        Sat, 29 Aug 2026 00:47:53 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8569f49ed7asm1340256b3a.8.2026.08.29.00.47.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:47:53 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
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
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: [RESEND RFC PATCH v2 07/13] mm/swap: consolidate swap inuse accounting helpers
Date: Sat, 29 Aug 2026 15:47:44 +0800
Message-ID: <20260829-swap-pcp-priq-v2-resend-7-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8pe9pjsrizcbe5tc6te4bhienuomyg76
X-Rspamd-Queue-Id: D6562180002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787989674-613455
X-HE-Meta: U2FsdGVkX19pV3SuHdSR0DKGJdNJ+AQ1Ecyh4cah6j1fGAgyz2F6FpYqq8tokjkPTUgp3d4yfbmswR+lxBvus2BLk/R+mssk1mQpwNaFIqUD7If5Rs+u30tA2MAP1oOpXSfwHw9u4HdrJllfTp2taB/M86MP1/ctxpuMrlJxsJLuk7qOf+5DRkzyCxiGMaRdzLgzf9mYlMimE5GxQBkrgUyxEMHOV5pKbhjKImee2tVJH+4wyU9gqB7EZHMJa60QuVVVIjjMfwsc8Kfw5MgHG2JOlkEHHqJ7sYIs8Xv9942MsT7FPiP6XzsosNWsYsWkZWr7SmJ79534npkz6gHzHtKB+LVRg3RwORKI/bkeiIYpWgbWwshV/XHAmu7E9uZTEo7kzzEuug3GuoY7TA3oXSGo8admFAw77uOBgSv189f7Jn1I2IPnY3/bF5wiNzhO6BTckeaVkSefVK5x+H5+Gs9MxRK8CwipabqAxgkB0UR9qe+i8AjiI6CSerX6JWEavLqLi46bThVRwti2ZxW7zRaSiJWbxtvdO9xnGtGQ4jvOlbSV+e27VzKQ3tBI3AulzYdqa+oZSjaXTEcK2zh9WrQL2BdVWiHiA3Es9FT88NFnGScgr8ddytZpN7c6cQi7M6x569okNy+/DE7FExOdEGrxPLt5hJPCmWe+1POpU0eOTSEjtNF//JwUkQITbQOm+EENU0Hw3r2zZiI9ByGuAFuT7jzEdAI0dM5j20As44Xf1lpMQ97GaaVJVRSQRnNqxDtdFQm2pPNMrq3nITAj4IyQb4QIZgSgHm7GEP68uoUUIPfUFMOvvND0GRwBRASFkt3H28N1xAKTGj0Kw8cpCdslFO+5FMgH5kDYxu4WGaV/LJWR9HRK0C0lkFgTJWR8i3jzB5jWCwAK+Qh2db+m+Du+7gf8G0oIxwW6uXujrmMZFZeHM18r2WysLDgMykNXTjBlhU8TjEJCopllcSu
 LMbzYthA
 gQ3yTOkLfT1xVRH8U+vD4eYZ6HZ6KoJvwkfykOKVJRVYWKFztDYG5UxWkTDs2+qHc1OgP2VyoJfonrfCJOcnSD6IdGhLadZvdidq55IoxdMDLVMl1jERs6VDFP05bQqNu1d0PDXhs6NsWANaIJKt3hEnvL8bf/HAn4GTeqPyKw3ieehUzz8x0Hv2fPLRrp9mGMGw2aDkZhsZ3YTI0XN0ggT//DXNhEOkGwyPoBx3Jkjb3uh/9xgPaEJH0PY8qm4G2k2u8KzDBC4grbk7cbt/4LPzHrPST2kyStAwUI+f7C/AAoID813EyDq7NqPngVUimxv1G6a84Az96SWYJMRO/6S5384/0s9cFtz6jyJLEA77AoM52ZXIqYnK/SgDePOvSPqptk8mZPnXnY8HRVTUhmTSvRleBGdHpiBIOtZ3muMPs4B2XoeNpFaO+j91/LSowM64I2151c1FJ3DQpYspBvN7p+9aoBvT24Fq0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Inline the swap_usage_add/sub helpers into their only callers and
rename the callers to better reflect what they actually do: track
per-device inuse page counts.

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Tested-by: Kunwu Chan <kunwu.chan@linux.dev>
---
 mm/swapfile.c | 64 ++++++++++++++++++++++-----------------------------
 1 file changed, 27 insertions(+), 37 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6809c099eecc..1fa6945d6415 100644
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
@@ -984,7 +984,7 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 	if (cluster_is_empty(ci))
 		ci->order = order;
 	ci->count += nr_pages;
-	swap_range_alloc(si, nr_pages);
+	swap_device_inuse_add(si, nr_pages);
 
 	return true;
 }
@@ -1292,53 +1292,36 @@ static void add_to_avail_list(struct swap_info_struct *si)
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
 	unsigned int i;
 
 	for (i = 0; i < nr_entries; i++)
@@ -1362,7 +1345,14 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
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
@@ -1975,7 +1965,7 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	if (batch_id)
 		mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
 
-	swap_range_free(si, ci_head + ci_start, nr_pages);
+	swap_device_inuse_sub(si, ci_head + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
 
 	if (!ci->count)
@@ -2834,7 +2824,7 @@ static int try_to_unuse(unsigned int type)
 success:
 	/*
 	 * Make sure that further cleanups after try_to_unuse() returns happen
-	 * after swap_range_free() reduces si->inuse_pages to 0.
+	 * after swap_device_inuse_sub() reduces si->inuse_pages to 0.
 	 */
 	smp_mb();
 	return 0;
-- 
2.55.0


