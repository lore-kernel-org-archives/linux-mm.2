Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 900F5C624A6
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0D556B0088; Sun, 22 Feb 2026 03:50:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25386B00B8; Sun, 22 Feb 2026 03:50:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5656B00BA; Sun, 22 Feb 2026 03:50:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7B026B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:50:13 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4FA4316048B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:13 +0000 (UTC)
X-FDA: 84471470706.22.5A7D3FF
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id 910102000B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Bkw44O7M;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750211; a=rsa-sha256;
	cv=none;
	b=1wq4HnqoSN0nRdUdhCC8xlsYSuxJRdoXSHH+0GJPYNEaZu8kJvcIdeaypUOxNCJqc4L7Xv
	wAKcT9lXt+4tmMK35Qt+l7qC5u4i3Z8U/ziD+BwtrTcdAXHVBP/qvWP4cm9vLsS5+DchAY
	hEihKdXM77xBLFZJjdVSt6coy7BqHTU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Bkw44O7M;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qy4WnBkIkvEh/axNS8gHjhsiSAf6nP1SGd3uu4mb5rI=;
	b=GYEOzopnK1Ni4DnuVVcqTa0ATksRHbShu8b1pNY9NBluiT5+tR7rM08XlQD2kpDPEroRFo
	MldjEqnlaehbGktn72k2BvK8cGgKIpJJ74zukOXF12xo4rSOE37nEko3hQyNnbQVH63RlG
	XaatUiTLnYBfCyA5c89r8l5e/EZ6hrY=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-506a93ba42dso38127351cf.1
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750211; x=1772355011; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qy4WnBkIkvEh/axNS8gHjhsiSAf6nP1SGd3uu4mb5rI=;
        b=Bkw44O7MpLVONp9qKzituojm4UWSGi2NAAztmPvzo14KwUym+HzhBHDXiyQGXBTNGn
         EGuxGCGwJJpowt2QdWSF0EASUefQ8GFTDzNQMwZcnWbYEK0UroqBugi1Po+O10u7QmUx
         OYe/sNU2rOMmwquPXTPFxoeANVsIKLlvydc/HezfYMPsP3VOh0ZKZp+V0Go3ryBDCtG/
         flffQKLSTmSxkVORMVD+C96g0zyU4zyU7JasOu3gAe7SkF9XFaPBuapl0GZjDJXPR7G5
         7ad3Ueu1rlnsDw2beLpRE4cc2oiIkt4Hrgn2ID9qUxAE+oEekmWch7Bs1EGDk2M/dlyq
         mlRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750211; x=1772355011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qy4WnBkIkvEh/axNS8gHjhsiSAf6nP1SGd3uu4mb5rI=;
        b=v2kMetpaBDcvQUparyX4Vs20b2fGKRwXEwyHjRa4NYSSZIJnqDjFPxG0vmtU3ZHqc1
         P0JIyBbgFdJRx6LR0xlxzbh09eugQyEyZzicgco6rCa6bgoP6VXBKs8ONLnO1H6xkrdf
         qY4BC3ZHN0hksrw6Id5ZMPUW3LFlIuzlbGvVu6X9x1uaE0U1UcN+ZznnkCSQvxpKvruk
         EhXRjnOXqk6xQn7ZAR/agksbFEkRIqP6I9/j4Wdk4cX41sTZl0RVfWEqI1+nEJ7UOJTU
         mNgSHqTsaZTQW5Ml7zeodifDDoAa2tPDF7831SacLFkkcSaN1jk1OgW/9mUs828PHT/6
         dHjg==
X-Forwarded-Encrypted: i=1; AJvYcCX7AtnashA3qCXCLAfJ7ruovNAF5jWbMvzS+0OhaEJHMYf4uvbKOG/ThHABpyKNgbnShQPMFofqHg==@kvack.org
X-Gm-Message-State: AOJu0YwIbksBTlCEu0WmkqYtu8j+jIVr/uDpV9smpyU8rsRAu15UjBvI
	ZUPkg+zr+waIax99LIzx+vn+bMiAPnr8MxKMbEMbX3YowmwJDE54yKOacJV5tEL2u4Y=
X-Gm-Gg: AZuq6aJJLBG4XpSAzqbyMp4WemXEpOKq0goSyHySvzoublK2C9RxLTRVYJUgh6fL78R
	0U+/ec671futCl2UIwxeQX8/bTEqNpMm2ExcwL/bgQ5JW84+IqAYWYZrrP9N2DvX2IXwrFzIszh
	I7WaMiwMjsWDObBxFXXh+ricBrIB2/U4VkRNbnhDUUmegdvpDOEk8xCQ9xa8BF5rG6mvDhlRdeZ
	2lTCVEkpRCzX6nQJMwknnr884IyiwLIehKsTIDgf1Aoc1Fi1yxvSbZNOnHsBX0c0BA5/F1yTG/g
	bpPMW0ZnFPTILFGTmLEAUVDT3ZTfrA5MMj+s53j+gRUfYCPA/wbJzcY/LMa8kYiI4r2ifSRm21P
	YZYEwBay3Hmlmnisa/S7caj+d9ko+vewPC1nwfHixOwRLQm3gWcMJncQqiOUFEO5C/YF/pxSRXG
	JKfkk25Wz1keoIKIq0JC/SnBUrUbRscgNNPbfcGen2+XcWK4aoGHgomkQl2ZuYHAzJaIETevlVR
	Eq+lWFzFkw/VzQHC92Htx/tYw==
X-Received: by 2002:a05:622a:1789:b0:4ed:ddd9:1402 with SMTP id d75a77b69052e-5070bbddc75mr66100291cf.24.1771750210655;
        Sun, 22 Feb 2026 00:50:10 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:50:10 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 20/27] mm/gup: NP_OPS_LONGTERM_PIN - private node longterm pin support
Date: Sun, 22 Feb 2026 03:48:35 -0500
Message-ID: <20260222084842.1824063-21-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 910102000B
X-Stat-Signature: 75hjur4ndz7upq6nwzf5m9de3tquwf1d
X-HE-Tag: 1771750211-380446
X-HE-Meta: U2FsdGVkX1+5wbPkn/9VQyv5zt8kcNtYzU1Ce9+nbCD9/hxD8Vl+elHe2IH07y093Q4nyWGnZJ92psGhSU90jznR3zybW0DJbA87DvpQq5q4VIUykg6l/IOUBH947LurzBdsZRMc3iRDXdMig6cOquDqumrS9ptKLJn7/lZPG6LPnFoSmhq07a9fNQMQMxjYuwnZC8E7+9P2/vOrOsFBOLWpvomymFLuyGxXE0z9D8TIPcRwz+rOGczjEFvWxz+f8S94QGlgInFBfmE/m+gG+wOj9m8YIcRXc0Fbf93N6ac0WDHdhk5q442zhiDnt4oChq8lXNRMy6h9VORcB4XArJte2uzKgxljXIlNcNyKTxSHwPL+YkJlf4qUBdqqwiKbcUQqiVKKDJHbpGnLETH9g/bJq/r9UkOWkzMGPm2MsMfwt+wBezXfLRQQHJWW3vDQ8pKV8dx5Xg5iveDcdkN2vX6ejCeniWGR0IjI+w1VU+W6eM6uBABd4N5JGaZcE1gOeEdHPIRO4baypqHZ1RjP2tHvg2SEjVPib6QEnxYFpuWsjOIBKqksY4cYpRsKW0WkjFRwforgeg8QuG270xInABfcwd319aefBuJXEKXzhaSoKSLEFWDxv+U1bejg7Yi7RNSAPIFzF1nBHNNHX6tLooZzsVOg+g+Q2M5zjFg2+VnuqkY4IdlBVxjHpA6MW59PUtysPmjGPmqKy1CAmdWYGcP015/a0ljsdGEgY+nrTu+9362g5ImGnN4XsLjBqs5I5mle4xFA2Tl0KTFL/3abdW6M3qe+lnK8/5D5kZCI/Y2OC5PxZoBu5U6TON8VAJGbn6xr4ngMyBDOo+9OBEVlKalqf/cTlevyE4LC83LzY3Z4UsDCkc/2a9uAbYqJjk6Acd5lb1AfBswJrWZ4DWvPvntYP1UVRcmltUwLcVdpqZ7mE5X2OhbSzSvURMF4AtctKbrLXnL85M3xxMM20nJ
 wckojXu6
 aWZU8W06/SEfGH664gb9uZdfGzN4uMwJ6lPrghHusF1JK1IqpZxpYFI1u023Ni7IgUdfRkdnwGoAe1h0JlLXJPYjflD80XNH+Ndoyx6mrbRRK0iYfGelOXavuHWAKscRJffYSSkGImzo2BgDlyf3PI2rq/n0rRF1CseEYxou1iMMpJOpxm39RnpHbyje3nbcelV6m0Pz9dtooBKmf/wqPEd9OJj4TaaG54HLP0Yf7hu+8BzOUj7OHEkWKf2yhbuf4mH9uKvKz1RfTWxT9bsMQF/zy3mciml480ie+EpQRse9FXVDL7Xcqi2pvrwE69g3wrRl7mQFYlXhWbklf9+PxZX6K0T7QxHxjknfVozA5xJjCUtjl/SS7o9U+/NdPvoXbs+G6eXaRyyv1MoDzxRaVZ0vWvdnfsgs9H80jyQRFVjIRYUyxf1mMY3jkplsyKcEEdaytMlL/C/XkawU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Private node folios should not be longterm-pinnable by default.
A pinned folio is frozen in place, no migration, compaction, or
reclaim, so the service loses control for the duration of the pin.

Some services may depend on hot-unplugability and must disallow
longterm pinning.  Others (accelerators with shared CPU-device state)
need pinning to work.

Add NP_OPS_LONGTERM_PIN flag for services to opt in with. Hook into
folio_is_longterm_pinnable() in mm.h, which all GUP callers
out-of-line helper, node_private_allows_longterm_pin(),  called
only for N_MEMORY_PRIVATE nodes.

Without the flag: folio_is_longterm_pinnable() returns false, migration
fails (no __GFP_PRIVATE in GFP mask) and pin_user_pages(FOLL_LONGTERM)
returns -ENOMEM.

With the flag: pin succeeds and the folio stays on the private node.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/base/node.c          | 15 +++++++++++++++
 include/linux/mm.h           | 22 ++++++++++++++++++++++
 include/linux/node_private.h |  2 ++
 3 files changed, 39 insertions(+)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index da523aca18fa..5d2487fd54f4 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -866,6 +866,21 @@ void register_memory_blocks_under_node_hotplug(int nid, unsigned long start_pfn,
 static DEFINE_MUTEX(node_private_lock);
 static bool node_private_initialized;
 
+/**
+ * node_private_allows_longterm_pin - Check if a private node allows longterm pinning
+ * @nid: Node identifier
+ *
+ * Out-of-line helper for folio_is_longterm_pinnable() since mm.h cannot
+ * include node_private.h (circular dependency).
+ *
+ * Returns true if the node has NP_OPS_LONGTERM_PIN set.
+ */
+bool node_private_allows_longterm_pin(int nid)
+{
+	return node_private_has_flag(nid, NP_OPS_LONGTERM_PIN);
+}
+EXPORT_SYMBOL_GPL(node_private_allows_longterm_pin);
+
 /**
  * node_private_register - Register a private node
  * @nid: Node identifier
diff --git a/include/linux/mm.h b/include/linux/mm.h
index fb1819ad42c3..9088fd08aeb9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2192,6 +2192,13 @@ static inline bool is_zero_folio(const struct folio *folio)
 
 /* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
 #ifdef CONFIG_MIGRATION
+
+#ifdef CONFIG_NUMA
+bool node_private_allows_longterm_pin(int nid);
+#else
+static inline bool node_private_allows_longterm_pin(int nid) { return false; }
+#endif
+
 static inline bool folio_is_longterm_pinnable(struct folio *folio)
 {
 #ifdef CONFIG_CMA
@@ -2215,6 +2222,21 @@ static inline bool folio_is_longterm_pinnable(struct folio *folio)
 	if (folio_is_fsdax(folio))
 		return false;
 
+	/*
+	 * Private node folios are not longterm pinnable by default.
+	 * Services that support pinning opt in via NP_OPS_LONGTERM_PIN.
+	 * node_private_allows_longterm_pin() is out-of-line because
+	 * node_private.h includes mm.h (circular dependency).
+	 *
+	 * Guarded by CONFIG_NUMA because on !CONFIG_NUMA the single-node
+	 * node_state() stub returns true for node 0, which would make
+	 * all folios non-pinnable via the false-returning stub.
+	 */
+#ifdef CONFIG_NUMA
+	if (node_state(folio_nid(folio), N_MEMORY_PRIVATE))
+		return node_private_allows_longterm_pin(folio_nid(folio));
+#endif
+
 	/* Otherwise, non-movable zone folios can be pinned. */
 	return !folio_is_zone_movable(folio);
 
diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index fe0336773ddb..7a7438fb9eda 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -144,6 +144,8 @@ struct node_private_ops {
 #define NP_OPS_NUMA_BALANCING		BIT(5)
 /* Allow compaction to run on the node.  Service must start kcompactd. */
 #define NP_OPS_COMPACTION		BIT(6)
+/* Allow longterm DMA pinning (RDMA, VFIO, etc.) of folios on this node */
+#define NP_OPS_LONGTERM_PIN		BIT(7)
 
 /* Private node is OOM-eligible: reclaim can run and pages can be demoted here */
 #define NP_OPS_OOM_ELIGIBLE		(NP_OPS_RECLAIM | NP_OPS_DEMOTION)
-- 
2.53.0


