Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD83C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7C76B0096; Fri, 18 Sep 2026 14:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51826B0098; Fri, 18 Sep 2026 14:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40BA6B0099; Fri, 18 Sep 2026 14:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 81BBD6B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:02:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01BC1A077E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:02:54 +0000 (UTC)
X-FDA: 85227653910.05.BD97C15
Received: from mail-oa2-f12.google.com (mail-oa2-f12.google.com [74.125.231.76])
	by imf05.hostedemail.com (Postfix) with ESMTP id 39FA1100011
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:02:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Al37AW1a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.231.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Al37AW1a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.231.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789754573;
	b=Pyhd75cksOG+F7zuV+vTkm01ZWADgQeamzrPAMmzu2MyXY5LFrxgsNbBSNhdCmzm7uIghf
	oSdfovrJBujzAFQySUTjIhWt8Q7rj/CvLFJXhn2qOO0wX22ZJ6lL+2Yoh3RKWkTjvAJ3yV
	yv/ZleeDobW6JQfeSHgDIw0JobKi1eg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789754573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=im6K772PTWgmT32pMTVGaO8Gd5j7dB48NMbCPlbIlg4=;
	b=qL6dky5xI5/4vPe6GQJdLo0deltTjPjDXpeaneoTLabuThnnms0nUtnMomTpKISZOT2CZm
	CKkUOlRUWPy638ctFgtDFHSH95lStJAaOZtS64QF2w5Xc/OSwrv1vnrMOQ5RMdQKssu6vt
	ElbRVwflL6m/1FzgBj4q2KpUs94pMwY=
Received: by mail-oa2-f12.google.com with SMTP id 586e51a60fabf-47be948a50fso756680fac.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754572; x=1790359372; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=im6K772PTWgmT32pMTVGaO8Gd5j7dB48NMbCPlbIlg4=;
        b=Al37AW1apD3TpziMSMrLgW6k49CGyY7UERdGf7cnbFwnWCFJQ5CtVshHTucHYDRG6M
         iQ8REUNd/u12j0Q5Xstk0e7vpvXxCHf6WrcuKF0t+y/8eqbOIppGICcK2+B+U8VZ4HS4
         N/ouokEMHfJtShU6JFzj3Q6CryYtGt5IeLAGMH5M0ndb+QzbwCC+X7678DdhBXKSh0te
         6k0B3q3jXgGeQSxqb2dWIwd2t4VfZ+E3sHLWMYA8nN89pHiokQ86TvJrcO9zIUrMKv/m
         sS4T/wiBQbfHthlBFGrwtSdxhsWPNPU23wIyhDJtxrEwsMh++EexImmzTiHOI98OQNVq
         fpiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754572; x=1790359372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=im6K772PTWgmT32pMTVGaO8Gd5j7dB48NMbCPlbIlg4=;
        b=1RmoKrE9v4e3xl4YWQl1t46FnimrwrEaiognEC5IQmi4BbWq/V4gkwbk5+625WtlDU
         7VbHus9PWtl5rlEkRtaZclQ+htlAxs1RwBT7jVwg2x3auHFCwnAWMP4y9UCbwX9DV3CV
         QKyn+Qca7yCWjIYn8XMAysX844CsBF87aE16+dJRsdyerTSKkUTkJ0FZYhQoaplTxREx
         t+B67wxmnqCDqHzYqV9vveIbfYlYLh5uqBZepxNWxj7fPEaQmxXVE+PnACzmkMJ3geYg
         MZ/5kWx/ReHdDyqLsYpIURX8G1+2fept91iNtSENqxL4OURf182GESPz6ju/WlomCBfG
         8miw==
X-Forwarded-Encrypted: i=1; AKwUvBzUUH4fcx6sfKcjRlo/WhaFQTCLYzAaSMMYmQjLWIzswJ8r54OGY6wM8R+1fORWYSvC8bCd+CSwXg==@kvack.org
X-Gm-Message-State: AFuF++kGQB8ClytwXNQUAAsBOI/vLfwrkvBZfrSMKDLYUl8Mx53LlG7z
	ZgsxvdFVVA7YcC8efPUoPQxeNn5NcDSDqWMdqgg1JA0HjWMcAGKZqjhC
X-Gm-Gg: AYBFou2JzvW1IkclfbOrVyOhdoueCoPoEqXrGBe1j+gIzZNv0PF+HUslAiHbC98RoLd
	l11DqbHwS1Q93quTuc36AKg/pUY8znGGAHlEzt5SWQAZaXqZUQrEfEuk9kBaBSrvjlZbdRjjP91
	IP7o5bay3NYcwr5DF+U7K/lZ5ptnmwPufiVR6yVr+XdsbZ0wirWSSao4yBDPxkdYHF8C0Su5rVp
	OHhW2ekj1IjiDJoaMbpFIHYN0MO4MeM1Z2Lwmjfnbh0IBqGxA8PZPZazvGHgr0Ds3G3Fo3T7/V3
	WaJDSFOSM6OZ5yYIlShlxiTrb6GepSVa1lF1EV10zYwhdZc+JU9HsJMr/Dp6/goyeMpywIZQrl/
	du70DmdATp4q8n201Xy7iL83vRFSRZmUy9S65tOdNHEAnvi/vWJboIlaP/a3MCdkj+3T1fiLvv1
	JK2OcBubnsYhs7Dbqlfca2ip9oGfj1zHRS/SjlkJb01IE4n5VP4hqyCJ6j8eEscuO50FPrIL2v5
	JO3CMFrRHJqVR2+WMFiXw==
X-Received: by 2002:a05:6870:b402:b0:47d:a38a:6218 with SMTP id 586e51a60fabf-486e6ac67d0mr3577258fac.25.1789754572094;
        Fri, 18 Sep 2026 11:02:52 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:40::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-48739852afasm1601298fac.7.2026.09.18.11.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:02:51 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v5 05/11] mm, swap: enable THP swapin for vswap entries
Date: Fri, 18 Sep 2026 11:02:35 -0700
Message-ID: <20260918180241.3424851-6-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 39FA1100011
X-Stat-Signature: gu3qqmctopkmy9uzzhkkowrfak39i784
X-Rspamd-Server: rspam01
X-HE-Tag: 1789754573-542138
X-HE-Meta: U2FsdGVkX1/VafWl3coC+d5HqANbyMR6x3ZxaYsJPTkZzZkh3meoB8FemujLBWf4TInDhV4R3vGltUxNLeWbne2IS0x/y0oG5iCZSUNunRdR/toDXql1J5Nwrsf6dvhnrKKtRdrMMd8iX+GBv5V2mVm4dMbXig/EgPEgklJxKbKJFdD/oqw3ZK3FTxvBkxkZ7Df26QdVHra7d2+3EW27FScKh5e8musvllqEXwSkGCpClC06Es85CytaNsfleYzsEgYK+ECx4KNgCb4ZJ2xiOR9yCq7g73h2NK2ou+8mvMgtRKl9nsC00//cyB0KFkJNWVf1YfExpy+oRx8cvz5pYnyv6Bhb1+CjSEHjuFp9mVUg8s+YpFnvGQ/2JvpEJ5C/7MojFpy8snR/TXG+4/QohZixVEBG5MzY0fTd/1QzuQMUaL/aol9bu4g17voPmHaIydBr0ee6qpi90GJKRPznu1cVdrv8NKjp6onBwFSpw3XXKSVAcMDUm84vN3nwlQF+04rdobHxiW4nRmIvty9XiUNx4+Gl2h6Xq+s0TmxUezuqHS3jHpKCenxxrGxCIjfVyyIWClLoy9wRzPQAZ1/n84LhYlqQVzP2CA3CD0cUqzN/+sy586c7VoCI6IE7i6fwq+6CrYPtXMKUZXy+ad8gGb69bSEeVRrMthDoW0MQC5M5w1mYgw5G5CFopTGNHv3bPVDVr9Ag0RVizcU71+7hwdIhxf3wbY2IwGzz9ezuKIhy71vg3Bs8q/SE8s4F1zzl6gJFrNRQ3oHet0SpLwfwXlVxDaO8Bl2J/tlq35wcFkfC+6U8cPnHT4XWfQ7F6ZTH0K41WqceAJF/3RRHNGGVSq+b7mmDLdYI7sPfXfBxv+jP7zXJkG2GmknOuC6t6CENKph8FZGwtaMf4LKPnZpBtRsoP+Guse5qoth96p17sEU63jePfzlmI0AUuYh4+JDfBt11vlb/ef2rzz+0QeI
 zdhBFpq8
 GB13yCuIHlHIJUFu/dX/dxmSBqKl+cJgdyNbjVFoOPALzZfDT5buSs+B9aunE6hAAiqxdrPS8Myk26B1e845wUu6ZDYpsW5mY+RbcbqSsDEzi0XjhY/g++CwcCPCM3XkaXSGXDtb7yQBlNcUU30VSAG8YssNhP+70fLP0n5ywEXHRQ6QRPZZSn4de3N6tmpKlJkiLn687+wz1T4WO6IlGRax9jfYLArB4zYwRgJjVF8iSib+yfInSx8jYacdRpeXa10T6hiLOgbaIXg/V38dR0t5X6fxwBrxJF93poLPPW4THYNfIiZ3XsnXF4lCgvoX/eroY7eRJObRdKSclDbpSeMzlPQfZ2T5mtaWDpqfrnYSgIR83rOCCh+8O0MPCss/A/PDLd95NBMHMewEjBkgaaI0kjOIyp7cefnt02NAg/Mbt0+leO8DLt0eMk8OKjIRAK/OuQ1v/PWZcqT9WQL3TGchgyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Swap a large anon folio back in as a unit when its vswap entries share a
contiguous run of physical swap slots on a synchronous IO device,
instead of always falling back to order-0 faults.

A zswap-backed or mixed-backing batch is still refused, and the fault
retries at a smaller order.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/memory.c     |  5 +++--
 mm/swap_state.c | 17 +++++++++++++----
 mm/zswap.c      |  6 +++++-
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index e9e05e31c4f8..e052de3b4461 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4882,9 +4882,10 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 	 * lack handling for such cases, so fallback to swapping in order-0
 	 * folio.
 	 *
-	 * THP swapin for vswap is not supported yet either.
+	 * Vswap entries are checked later, under the cluster lock in
+	 * __swap_cache_add_check().
 	 */
-	if (is_vswap_entry(entry) || !zswap_never_enabled())
+	if (!is_vswap_entry(entry) && !zswap_never_enabled())
 		return 0;
 
 	/*
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 657622cfd7f1..2107d05ae8d5 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -165,6 +165,9 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	unsigned int ci_off, ci_end;
 	unsigned long old_tb;
 	bool is_zero;
+	struct swap_cluster_info_dynamic *ci_dyn;
+	enum vswap_backing_type type;
+	int ret;
 
 	lockdep_assert_held(&ci->lock);
 
@@ -193,11 +196,17 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 		return 0;
 
 	/*
-	 * Reject a vswap batch so swap_cache_alloc_folio falls back to
-	 * order 0.
+	 * For a vswap entry batch, reject if the backing is not THP-amenable
+	 * (e.g. uniformly ZSWAP, or mixed). The order-fallback loop in
+	 * swap_cache_alloc_folio will retry with a smaller order on -EBUSY.
 	 */
-	if (is_vswap_entry(targ_entry))
-		return -EBUSY;
+	if (is_vswap_entry(targ_entry)) {
+		ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+		ret = __vswap_check_backing(ci_dyn, round_down(ci_off, nr),
+					    nr, &type);
+		if (ret != nr || type == VSWAP_ZSWAP)
+			return -EBUSY;
+	}
 
 	is_zero = __swap_table_test_zero(ci, ci_off);
 	ci_off = round_down(ci_off, nr);
diff --git a/mm/zswap.c b/mm/zswap.c
index bbfaeac00355..3e1aa295f9dd 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1688,9 +1688,13 @@ int zswap_load(struct folio *folio)
 	 * range on the backing device, so scan the range rather than rejecting
 	 * it outright. The caller has pinned every slot, so zswap cannot start
 	 * a store or a writeback into the range while we look.
+	 *
+	 * A vswap batch is checked when the folio enters the swap cache, and
+	 * its backing cannot change after that.
 	 */
 	if (folio_test_large(folio)) {
-		if (WARN_ON_ONCE(zswap_is_present(swp,
+		if (WARN_ON_ONCE(!swap_is_vswap(si) &&
+				 zswap_is_present(swp,
 						  folio_nr_pages(folio)))) {
 			folio_unlock(folio);
 			return -EIO;
-- 
2.53.0-Meta


