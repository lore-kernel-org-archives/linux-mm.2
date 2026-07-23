Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32EE3C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10CCB6B00F6; Thu, 23 Jul 2026 03:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9516B00F8; Thu, 23 Jul 2026 03:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023D76B00F9; Thu, 23 Jul 2026 03:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCF976B00F6
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:49:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BB711403C0
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:49:37 +0000 (UTC)
X-FDA: 85019266794.15.E16BBAB
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf29.hostedemail.com (Postfix) with ESMTP id AE16C120002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:49:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NE2mSdK8;
	spf=pass (imf29.hostedemail.com: domain of 3jsdhagcKCP0o3jxhfxlttlqj.htrqnsz2-rrp0fhp.twl@flex--jyescas.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3jsdhagcKCP0o3jxhfxlttlqj.htrqnsz2-rrp0fhp.twl@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784792975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZ586ewl8Eu4hmRzC2pHlsJckKHztM0Smyid7ZkeCg4=;
	b=kUQhjPP8oI7FcwjxinQnklsBYMzuUf2fMafMGN+BESIIf2091u7iCNvKiiAl/gBMctew8h
	4p24+0Nr4d+oURHKHGMRJGWOSMswWuC1P6IxV9MVstmWOGuUC9e7ScCBr3QhtQxxWHDglf
	sykbc92y/2YWu+telTpD0xjeiJKKryI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784792975;
	b=D618UelQ/XMHBsyX43q5Pw6sonkRJ1sh2bk03PuqeuWiMGL+zEGlPj7M4jxIyayDaBkSz8
	8SZcm+FrV5TRuGeuvxOqsG1YfS6xFF+mCdxB7iKhvCeRBo0AVr/dUoQqim2p7i7VpzNkpF
	XWasvWIUAtaKvsWpDp73NtWF/EOTFHc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NE2mSdK8;
	spf=pass (imf29.hostedemail.com: domain of 3jsdhagcKCP0o3jxhfxlttlqj.htrqnsz2-rrp0fhp.twl@flex--jyescas.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3jsdhagcKCP0o3jxhfxlttlqj.htrqnsz2-rrp0fhp.twl@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38dbe39ce62so232041a91.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784792975; x=1785397775; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QZ586ewl8Eu4hmRzC2pHlsJckKHztM0Smyid7ZkeCg4=;
        b=NE2mSdK8JgHZY3l+OstIgoUJ1M9Uz/nGBVRmwJForNdi2Tea3cKNnycogcqbsW491e
         cD4RetEyoNgkLr3XG6vciqmuq9pbDxFJLbC8vRvZp0OtsPaRxW+TObq/6JSLGid8s+Ci
         b309SPCg7GDHUcscxOg4CR6UGgRF/g3P30/PcEYSyAF3M+597jiAk+GM/NjVK7yHmpE3
         Dzw10m32qmtHQOXpC0SOIPbPzXJeq7ZbExq95ZCUfDO5AllePLxDi8J8MhNIIf9XEwIn
         wtg/wm4x2/b0Ox9MVUqzcixnw50e3K/Ik0/2r8VLjzIE0F4+wUuzKp38Ydhg+4Atr7Tc
         8ArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784792975; x=1785397775;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QZ586ewl8Eu4hmRzC2pHlsJckKHztM0Smyid7ZkeCg4=;
        b=AbUZtJTg2I2jyVd7tkZxZxmeg05VXaRqdQmM2hKO3+aj93WWGGqd2WftzY0M52+kRr
         KCWk053y2vXUezsHBY3ha06CrX8gaRUzUEa2tGWyNACNiL7C/ZaQj+Kh3yRfpnUsaUmU
         N23ltotxogq0hTHPz5IBunmJU27fLqd9WkJ8bSqTPU+uda0h4WN44ws/67negcBt4a2Z
         C9WeLPyNgbc4ZpN9TJ/iZnfMhi47EZ7qXbKxXSpg0b6bYL2eXdfEHeOmrrJp55YISNt+
         /PgqFoEPkyGl+eREhagGi0XfdGKr9Fm/OGOV9oe0p/BD0fEeyyoR6vcBXMvG4v9h5ISy
         u4ow==
X-Forwarded-Encrypted: i=1; AHgh+RpJBN+5FXFLknlx8yn4UA7QOsxJX/q4y2hMjz+PUxBZ2JZonrqfBPmD+HwnkqWqCWYKcnIM9ooXkg==@kvack.org
X-Gm-Message-State: AOJu0YyHWDEkHi6usxYUTh4BvfrzJReceBUt8CvBwdxrZdiXI3Gga5my
	pVk06Yj1/k4hEzh9ZC2q4xqRPlZgro/vAKtvmp9mLu5Gh58YuSwVXwba7qLw2R47ofiKp3iHDKt
	Q0S6ONCl0/w==
X-Received: from dlec17-n2.prod.google.com ([2002:a05:701b:4291:20b0:13d:1fe2:b775])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b43:b0:38e:9784:dd47
 with SMTP id 98e67ed59e1d1-38ec83975aemr1731583a91.1.1784792974394; Thu, 23
 Jul 2026 00:49:34 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:06 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-3-jyescas@google.com>
Subject: [RFC PATCH 02/16] mm: Define structs for allocation requests and
 store allocations
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AE16C120002
X-Stat-Signature: niq1obbqzbnsh34ztonur59ffj1zncjr
X-Rspam-User: 
X-HE-Tag: 1784792975-938912
X-HE-Meta: U2FsdGVkX1+tMEKQjrg73FYDZ2EijUWcZ0X/HQiF9hsyN+CxXsv1vNSa8YCzUFlgaWAsh4V5DUD+p9Xb7OXkzVPUIaKR7trdLHdZRBJk7vS3sX/t3j1Hvy2tsC5RI1628BCBK+1tOTiz4cMvUjvGDBCewihF69KjAIpsaOqbhv86Ya/3CEOrvgaUWsPWMf7YwgV3l1nbYuLypMRWug2K/2xz4WvF+Mr5tv68ukkpxqEKMOtJFuoWFEpxdF7xBhucGEDahJBTYqJpQh08ZTDssHKw6CgLIqqAi640BzxSuWLefSrOLnyQdk1PZETlL6GHJ7GMOlX4Q9tPiHeC0gnQnrfG5GyA2fniLVAVgEa99t8R6xKtHhNuyJguOKcHEc6AivVYZTuHBbR1lU6CNauS9t06fEzVn3rpjizmSdo1ZJ01EypkvgoF6GRFlF0wKcmCxrty9Sh6Dm3hCDzr+VO33xj8CYxgMdbdwbn79N4Yl0cWXf0xN1uS//w2btHKTxYPs3GCDZrQiUVcyzMc/oQKfbjpraXKq55isrsNvxwBrmUWxdeogBiobC7pyZjtINQ1Ar9No9i70T7yET7NmogHmAeqkA1hee4A+hsuJXHegAdCaZlWePvSxEB8oOXT0PEx4G+QwG5MoXH+IDrKVSt/8VgB7FEkn64UnFeIMrJ445Bi1J8BkkQwUNVypdgOoVSfhl4t9bOsRfkDZIMnC4gwRWdJxs/+KJlrXhtCidvc4tgvJjDm52R9O38Mw6uailFo2Z7JuwMH2NIu7Vo/GNaGefA1+x7aNIKz5XoN/uWJPg0mG1hqc8Nj19t/uPMUzanBEPjtRRrb2xJ34VZCB50wbIFR3IRuAvbWMaQyeP4Yjnaa3ISYi3pxnlGDwzEqqV09LnGxG2dwOoMk4I06TrL8U5crT7AM5nOAb3vgRzYvnnpOIaMDUsf2X9NnB0QOwRY2Pj/UsAbuOgEhDQiTP4v
 Z5S/G7RN
 Cc0QrGpdRPHzmHhA93OWxHK4zFYbZkIMhpqTZWX0PRaidWbGNxf8V7i0gwsMMA251SW8nzGnl0TGVhH5SvNWFXOXJWpC9qUzu1Bfv0W8rlm6LX0NjcZ3th191uVvYhX1pCRTIpLuqa+mM6so3FfMea7KmngoWzrE4nw5Hj1Bs4fHhaC4esIoEddjlX9pBAHNFHWOswE6zXpS8Zww//vRdAXojHvb7W/GCrVzqGMFHTk7OQQySadovztqAt017HPdmjMVtYtQgA3//t+u2MQhH6IGAPLuaMugoov3BAKHXTWRRbsi9CVBi89s7Dk3BEsP4iOfKHw+7lCZWOlfX/1fN6yMRzRy9WqcW0WUgD0yRh1LbJt4Keqe9+DNm/IdPOk+18179tpTIrZbm7ZbUVW5duu4wyuKZiBano0lwygJm14FHQSYl9B0bNC0M9JrsUkmCkhAZvc1dLXHzwZ8zXC2CoDjllS1IYoi9Svknp+wjMBWI2dTd+xxuZqy7vCNbR+T5o849HxtsG6ErfVT1MgT5nNN4F6qK6HdFXGq+OToSQppIJmHcbc6v/FBqv2B3Nu08pTJmCuFgXlWWu24ZSPLZx0MWwqZjR8S5Xvl0s0NZWs6pYB+p+GD/lvG60w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change introduces the next structs:

- struct req_alloc to keep the request info for the allocation.

- struct page_alloc to store a pointer to the page that was
allocated, the request info and the file that represents this
allocation. This file will be used to free the allocation when
it is not longer needed.

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index dfdc2ee2eafe..47b08d056978 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -91,6 +91,34 @@
 
 struct dentry *mmdir;
 
+/**
+ * struct req_alloc - Represents the requested allocation
+ * @node_idx: The Node index to allocate from.
+ * @zone_idx: The Zone index to allocate from.
+ * @order: The Order of pages to allocate.
+ * @migrate_type: The Migrate type to allocate from.
+ * @parentdir: The parent dir where the file representing the alloc was created.
+ */
+struct req_alloc {
+	int node_idx;
+	int zone_idx;
+	int order;
+	int migrate_type;
+	struct dentry *parentdir;
+};
+
+/*
+ * struct page_alloc - Represents the page allocation.
+ * @page: The pointer to the page(s) allocated.
+ * @req_alloc: The details of the allocation.
+ * @alloc_dentry: The pointer to the file that represents the allocation.
+ */
+struct page_alloc {
+	struct page *page;
+	struct req_alloc *req_alloc;
+	struct dentry *alloc_dentry;
+};
+
 static int __init page_alloc_hogger_debugfs_init(void)
 {
 	mmdir = debugfs_create_dir("mm", NULL);
-- 
2.55.0.229.g6434b31f56-goog


