Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 175CEE93807
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 22:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB066B0093; Sun, 12 Apr 2026 18:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C26E6B0095; Sun, 12 Apr 2026 18:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D84F6B0096; Sun, 12 Apr 2026 18:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 285736B0093
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:50:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BEF71160BD5
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:50:56 +0000 (UTC)
X-FDA: 84651400512.02.0926DC2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8FAED40002
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:50:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BHi7sokF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776034254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGJCJcDO5/5MpQsdc/D5wN/ajh0fH6KE567pAXfVmHs=;
	b=lZbE+VqGQKYdfWckHfV9YIcL37ErfGYDVI83dWTZyu0OBpii75mECO8AgI8e58Vv0QZbpU
	pJFaItwiFdSFGWP9SDQHUQZRVVceokEJYeLnrrKt1TddgihqxMwE25MXucZbwyDzGGu3HQ
	kgyqjS1eZQGCQ7VPESUnkpbZJ4nbYRw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776034254; a=rsa-sha256;
	cv=none;
	b=skOL09uXzgzTx17QXKbCJra4Bk92Imz2JKtFfnzeAdrnDYcrO+pVybNSuN9IqLMBnklCSI
	pBMJq5hnMEK1m7uXTy1XKRIedzbu46ujHAla8rc59TYhRjx4mKx3SvpqnaPichFUkOC9cF
	uI6bFQNnCAVbs5O56DVugYYlhAq7wTY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BHi7sokF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776034253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jGJCJcDO5/5MpQsdc/D5wN/ajh0fH6KE567pAXfVmHs=;
	b=BHi7sokFECdBmg6F15dbrlbW1zyLN5f1nfZvxvOueBxwuVPD1RF2q2AE7Ptz0dex5zdR2L
	/jmxjPLcz2JLuUjBoWn9LS6vUNTYJVdRxl+C1DIc3mHSeC8noCVvTQvkaVbdpbt1yfTanA
	G4769kkhNuIBSQcAIMWh2KOBjidsT3k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-1F_eIsHRP9qwBRnO3kGt4A-1; Sun, 12 Apr 2026 18:50:52 -0400
X-MC-Unique: 1F_eIsHRP9qwBRnO3kGt4A-1
X-Mimecast-MFC-AGG-ID: 1F_eIsHRP9qwBRnO3kGt4A_1776034251
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43cfb72377bso3007139f8f.2
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:50:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776034251; x=1776639051;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jGJCJcDO5/5MpQsdc/D5wN/ajh0fH6KE567pAXfVmHs=;
        b=XQmkK9YGvoDUUGiD6ajppGTShCPcUs4hhGWLNrS42nYgQQ7Xyb1UwK8T6qzkPI7SMC
         qTnn/0EATMOvnB/g2L6+yr2yNqiN2J/+D2Ro9L+mXVZfxuXI2XK5JjoaTPFbehAg1IfN
         h23Ofb+Jek5cKV28qec0mLwYFPE+AHUA/MXxYvDgGfO0EN80U6ASsxcMSS1RWguDLUsz
         iypVBG46RwFMNZlDtweY9674Epb2/HQZli11UXnCc0hti2ExL5VSOitcD3SXJwXesH+d
         wvzgEg5Poj+YAIcWPTucUe1ozKY18YNhuf3P74IOh8qm4YcXHuEp5ebgb1+OdEX23pc1
         skzQ==
X-Forwarded-Encrypted: i=1; AFNElJ++QBVSz8UN/1o/cdq/6fY/FKfvtfRhjCwH9Kbe5i/ZLWTzKuD0tg53mkIrCLC9qw/A5nOfAHQMFA==@kvack.org
X-Gm-Message-State: AOJu0YzTdBbGlnusOtM+taVHCJ3P9pLyfd2d5EJhQReF1jHbE9SEG0GK
	NqHpKj4yhBaF2Puot9Au3l0rwR65bA8JFLL27MGj8V2oMx6bEGmaia0jcoZLlcuYgnWPtsWqQZq
	YH6A/uoEIsXFPiam7sVMALZKtcD9m8fCa+wNnzPnHTxvBKnQeqKYq
X-Gm-Gg: AeBDieuGPjdNpbo54sR15GlxZr6Ss5b3q3rUpMX4sEhXpjR4h+xJKaGExlB0px6WPtt
	5TD3lzzHIw8CSLrx/4cuOIddtKlidoLsKfBD4eoAStDj7t45t89oi/5WHZ7gr+MymeWnveA5/9p
	x2U+WEYu0gyANnWSXhCQFGR9kUIVSYgeJpSb3yhtiAvUSfedrT9Kr+9dxa58g2VmzcXdsfr33L+
	kqAkre46xwRsgfdZIV5+tDleIij/dzy3Xhpg9OV+CZkLcTIpYJasxg8OGV7YwQFkHp7Ky7DTiOq
	is4W9g9eK3GUD8D47gV4Fw2NQj3XQV3N5aKVHA18fDwFVQ819w++Qe6ypctNczzEU83lpGYTqXV
	UYCYBVCBj1GFR9ga1PHHGA9AK9No0bp8VfxTArCZeIs0=
X-Received: by 2002:a5d:5f46:0:b0:43d:1cec:4766 with SMTP id ffacd0b85a97d-43d642b6b9cmr16170667f8f.23.1776034251185;
        Sun, 12 Apr 2026 15:50:51 -0700 (PDT)
X-Received: by 2002:a5d:5f46:0:b0:43d:1cec:4766 with SMTP id ffacd0b85a97d-43d642b6b9cmr16170628f8f.23.1776034250679;
        Sun, 12 Apr 2026 15:50:50 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63e46713sm28673200f8f.21.2026.04.12.15.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 15:50:49 -0700 (PDT)
Date: Sun, 12 Apr 2026 18:50:46 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 3/9] mm: add __GFP_PREZEROED flag and
 folio_test_clear_prezeroed()
Message-ID: <b21b0ba353330f24b9e10ee5bf01b60f32043327.1776033771.git.mst@redhat.com>
References: <cover.1776033471.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776033471.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4lzsNcdJeeK8YHr1bjc5qR8W1QU6IBFOMnIgJgXsU54_1776034251
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 8FAED40002
X-Stat-Signature: edwd8ityi4uaphcjtwjnn5536yocd3cr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776034254-674766
X-HE-Meta: U2FsdGVkX19Ccg3dUR0fLJQcmi2gGKG4UNZ9J98J083zB56j/g1khxoAGRhWY9kPyRuf0Kd3i6SoLerX9QM/eS4C+kdTu+93gFnqPcP37WisW8ciFdARlgYOtxzFYh7uGVCW6I+AXdUeZICxEXA0mYA6yyBx9lmHBEsl/iZDQTMGbNH30trj3hSyefmwirGKYrsrALXx8Q9xiXHwnHcbrLbaboM7Dk7RyHXdVpd89CL6FgfF5I4pK+cExSlDEi+GRO5MQi+oJALo5AC/tZAuSXTq8qttyY83NAQMa640x3VVySC8ILB19kTgv8CBPGWQ9enwpws5m1F1N8XT89MK717MMipzmui7gyI2U77wzhf7XMatFhiqj3z86PiR1oHBuVyiN5C3FlvcZG2cVGU8fyJbtDNbZcVy/oUvxinFYIkbTy6jz2TLxIUhI9u+TEH5NyABESRd+F1Aee2gKPuN/8QGEHo0aM7cxjad8+93BKKpMrVa1Yirv1v0iHmNngD3zS8/nYlFmO4WccommfiJqHg8UtNbNCztjKzczaeDPguOK/C60GfPqjiDYSkxFfD5XsvdIjlB3YNyBqyf0MaExcRWQtOGrqQw8upuBkmX60TRdgevMiLoZ3foKe3WPeYEbX08q96BahLR1iFW8evJ8kePnxo7oGqWaJ155qIAeLHndScuasLmKbwVXnAYDgIzK4xx2+BGcIDgyfRcZammU521JbIeAEgXXUXSQNCX4xewYuu3iGNblNYvUISXJ5K6NnvvCfXmy1GftfmwWB1c+1JNFedlID74kuYqhbVvQ8whq1w7Kn/gK7Usm0hhmqju/fXUVTIHDO8l1EbuSS1hTcloT1OCWvm4qtxNwz/LY4T4CBrPCqLb/2iGBAEOSqjeHJ7uPOXZnKmgeurkO2OKyk9jOW+KWM53kWt/AVG05W893aox7bme/5RZbJVal2+yst1Z5FDVAqhpCqdndu9
 xC092A5F
 lIEtEpTZd0SwpCPRIcLdVjogHjO6LHnxz+z5INlw6PJ9pc3oyYgWGuQZKJUDC1cI5K4QO3zG4ZraXWcu4WVLK0cp94W3Uckgnd7+PYxFfprYQtzysRYFE357siWFiGFFkeZFjvKPvrNWOPj7doT6wMUED9uQoJgb5o5oSBuStGXv/7cHj8ssC5/7BP7mkQ7jAfYYhq/mPLMVevioTUrkzYlCzMgDuMX2pAIJX5wT/kjUWYZYlBNn/wvsxlYJMiRlwb9tWT5qEEm8cHLOXUYzRZjqU65EpGtAG6V3Oa2mtP1iNdjEamDggVIWbfUV/bcdgzI00iUqboCRo+dSyjfn3dVzl29lXGnP5PNqv0qoyBr4XIuUaAcGLs3zbXZxhhABl24YEBB56UJ+t8qZKYliOU9sInw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The previous patch skips zeroing in post_alloc_hook() when
__GFP_ZERO is used.  However, several page allocation paths
zero pages via folio_zero_user() or clear_user_highpage() after
allocation, not via __GFP_ZERO.

Add __GFP_PREZEROED gfp flag that tells post_alloc_hook() to
preserve the MAGIC_PAGE_ZEROED sentinel in page->private so the
caller can detect pre-zeroed pages and skip its own zeroing.
Add folio_test_clear_prezeroed() helper to check and clear
the sentinel.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/gfp_types.h |  5 +++++
 include/linux/mm.h        | 16 ++++++++++++++++
 mm/page_alloc.c           |  8 +++++++-
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 6c75df30a281..903f87c7fec9 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -56,6 +56,7 @@ enum {
 	___GFP_NOLOCKDEP_BIT,
 #endif
 	___GFP_NO_OBJ_EXT_BIT,
+	___GFP_PREZEROED_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -97,6 +98,7 @@ enum {
 #define ___GFP_NOLOCKDEP	0
 #endif
 #define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
+#define ___GFP_PREZEROED	BIT(___GFP_PREZEROED_BIT)
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -292,6 +294,9 @@ enum {
 #define __GFP_SKIP_ZERO ((__force gfp_t)___GFP_SKIP_ZERO)
 #define __GFP_SKIP_KASAN ((__force gfp_t)___GFP_SKIP_KASAN)
 
+/* Caller handles pre-zeroed pages; preserve MAGIC_PAGE_ZEROED in private */
+#define __GFP_PREZEROED ((__force gfp_t)___GFP_PREZEROED)
+
 /* Disable lockdep for GFP context tracking */
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 59fc77c4c90e..caa1de31bbca 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4820,6 +4820,22 @@ static inline bool user_alloc_needs_zeroing(void)
  */
 #define MAGIC_PAGE_ZEROED	0x5A45524FU	/* ZERO */
 
+/**
+ * folio_test_clear_prezeroed - test and clear the pre-zeroed marker.
+ * @folio: the folio to test.
+ *
+ * Returns true if the folio was pre-zeroed by the host, and clears
+ * the marker.  Callers can skip their own zeroing.
+ */
+static inline bool folio_test_clear_prezeroed(struct folio *folio)
+{
+	if (page_private(&folio->page) == MAGIC_PAGE_ZEROED) {
+		set_page_private(&folio->page, 0);
+		return true;
+	}
+	return false;
+}
+
 int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *status);
 int arch_set_shadow_stack_status(struct task_struct *t, unsigned long status);
 int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index efb65eee826b..fba8321c45ed 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1867,7 +1867,13 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
 	int i;
 
-	set_page_private(page, 0);
+	/*
+	 * If the page is pre-zeroed and the caller opted in via
+	 * __GFP_PREZEROED, preserve the marker so the caller can
+	 * skip its own zeroing.  Otherwise always clear private.
+	 */
+	if (!(prezeroed && (gfp_flags & __GFP_PREZEROED)))
+		set_page_private(page, 0);
 
 	/*
 	 * If the page is pre-zeroed, skip memory initialization.
-- 
MST


