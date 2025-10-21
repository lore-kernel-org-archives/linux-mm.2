Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C28ACCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 13:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DCDC8E0038; Tue, 21 Oct 2025 09:00:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166E88E002F; Tue, 21 Oct 2025 09:00:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F168E0038; Tue, 21 Oct 2025 09:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D53A78E002F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:00:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CC5F11A2EA
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:00:10 +0000 (UTC)
X-FDA: 84022129380.26.A003E5B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2E5A120003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:00:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iEMvARI9;
	spf=pass (imf03.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051608; a=rsa-sha256;
	cv=none;
	b=6WL7cD1RD1BcXp4lqfBsPVWDwhg1JHSLKaEQf985uq1l1auujk70OztNVyAEYKygxvKy0Z
	ZlAagQi3WaRouMY+kbnjj6Dq9WlRlFhSB/TVyswEdZleZ3VZIGQPRo+8dHc+P9dnnEAE/1
	RVbu5nuXNrbdgm39SKIxCyJZj91CopE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iEMvARI9;
	spf=pass (imf03.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+OTVNr68Ud6e3V7gLc8dmSyyby2S+Q4hsUbFdDpNzM=;
	b=aKk0V5CcmD0FpMOk8LofCflxzJmkAWvzSwk81g85i1ClRbOpyqgI0Vww/3Uoh41nAp1jmR
	QwB7sCI84xAooqeaHfhKjNtbEpX84kBqapnZRT7p58KTshwmH9W9IqITJ+CeSf4zJ7OqDM
	WUsD5pFjjgdZV0rfBFc0K1pRiXOmekA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O+OTVNr68Ud6e3V7gLc8dmSyyby2S+Q4hsUbFdDpNzM=;
	b=iEMvARI9agmC+cqmZQoZbJxUO/81U5XQgw4LqxmeZp+BDqXgBZ/NqM7IUlMiyShjikxJZL
	YEnMRmcexBCo+Y42d/tZLcebNEBXmP0h2QW2enDlqDdBDwIzmRYt11rp75w7uCAlkoSSRC
	JCrYGA379Ca7SNEj8/dSKNzSkUdn6YY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-ksSi-HgFOuiZJzCzpxOTcA-1; Tue, 21 Oct 2025 09:00:05 -0400
X-MC-Unique: ksSi-HgFOuiZJzCzpxOTcA-1
X-Mimecast-MFC-AGG-ID: ksSi-HgFOuiZJzCzpxOTcA_1761051605
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-471125c8bc1so61195835e9.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:00:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051604; x=1761656404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O+OTVNr68Ud6e3V7gLc8dmSyyby2S+Q4hsUbFdDpNzM=;
        b=TWpCXU6aUAvfO3wGdQgGCluDd8qHPTBaAFewSuFjOcIvGAM8flUeslP7Oo4UcumBJq
         UZ8oFWAmhvZbhHUlaz6NAQVKCrbsosN841VUVo+2f9Q1isyern2I8rQkQYq46o1vxq4N
         a9MkWPDDC7PImroms8hfS8LhCPUk3Zru3eEkLxHbM8mXwn41lXZWb5KOTtXgaB7tR0hG
         900L3sXrq8RKEXNcEod1xFocIAT0F0XupRuDrf4LCq59VZiCG0CvyjPfHS19sVrezY0b
         8eaQo9kFLhBSvwXDppeQG7qdfVqA7C4UYX5Dn4blLrp76GkJE9os4CfK1vc+zWtX5bqi
         ILBQ==
X-Gm-Message-State: AOJu0YwGQTWmTrWm5JcNCGPbdtuksTD9EUuU12R1aVsyxCWHR29NrYlb
	SXZy793fEQ15WkAqhj1SqrVcqAmECxq0Vg0n7OgllmtZVNOsgsCk0lTEjCixF2ZENhKHxv7f6CH
	46XspXG+qdKhvhynMx6FXy4JYdASZJJFzXSLnMSGEpwYct36/79nT
X-Gm-Gg: ASbGncsM3UfNGx3fB9SKh6TBfrjqvkyqRgZwyl+8AYzvQSz33WCEP2kjciVPVJb7EMO
	DBXC6SbY/b+wuDarpvSlO2HjnhGQOrVZnj6xAMEeLSpuCsUrd8r9wfZeUj1VNOt1KtMigC3BxX/
	bYmzM9Mp30f6VZXaBQD6mhqOQCf4oOQn/0j0Y2JrkTndu7qhULsKoWo1N9Y7s3xFGnPTZdMsRmE
	S3CW0kPL2QeyTMe9i+03Fi9muIfg8XtBMDpRNqT3MbXRRwTixP4IxHWXQYtsWYo5uSpn1AiJ2Mq
	FV4eUIgNVqsKXEBYwC6Xn6p0rm+VA/xt4TPv0S1FRY+zTyRIVrHJa4+Kq4DliUNFzoQFJs0yk71
	R04YeRaGXX8AtAb3TfvqmPBkQMpK8Lc5uEzoCKYr20V6MBMH3OjB/mdnTPmlO
X-Received: by 2002:a05:600c:3b8d:b0:46d:27b7:e7e5 with SMTP id 5b1f17b1804b1-47117917572mr150179045e9.32.1761051604293;
        Tue, 21 Oct 2025 06:00:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZFp/NfFGh9nzvdan/GtiYx6zHPVXBd5PXGxqlBj7uT7XLqj1hdDZYgamMo86fNe5GicJaNA==
X-Received: by 2002:a05:600c:3b8d:b0:46d:27b7:e7e5 with SMTP id 5b1f17b1804b1-47117917572mr150178725e9.32.1761051603807;
        Tue, 21 Oct 2025 06:00:03 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47114423862sm283718595e9.1.2025.10.21.06.00.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 06:00:03 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v1 14/23] mm/balloon_compaction: move internal helpers to memory_compaction.c
Date: Tue, 21 Oct 2025 14:59:19 +0200
Message-ID: <20251021125929.377194-15-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SkIUK7ZBa_h8FsSI3fDUJKZZkU-cu_JHAqA9QVrlhG4_1761051605
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: a91en4rhtbhc5bafpy5dy8bwhpwgwugk
X-Rspamd-Queue-Id: 2E5A120003
X-Rspamd-Server: rspam09
X-HE-Tag: 1761051608-855057
X-HE-Meta: U2FsdGVkX1/9b9Z2FEQ1owOwBGFybY/H0SobyyZ429dfUGA2F36MlrAvGKS5c3hwRURpqRsTUJ5NYNs3/OzCNhNgvSgQJCbjf6lD82iSqyN8IzWrERGxbvTjZEkTFswJrUY7zJ8b1NgvWCSwNF5YbTGmlfVJp5pAt+ymi5AAGWcVzsXbusw5gS8pvCPVg8r2MTzT75c3YVbGntxeoNem2ETN3UTKl2MWDxVm79v/HZHxIHZaADEo4e8BS8dE5xhWl1uKtT5RV8eC2+8wrjUZLHs2FLu52inG9KeEc9ljsZX5p/sbffA5A+av8pBH5wTMusmIHmO0DhRkky0HM/HofPRpNH8/zqi10dLueMxw8Kb5fWk8NKYD+gfqmP417byl5vtVJYbXBE8dTTnf+PWIg7s2cEIS+biYdIQWwSRH6pUeDCXWzjYDfuILqwQq1EJnA9KfFqJRf/5tCWanG+IItCfzxaSSm5WVczzlKtA5T7tK0UK7FnHi4/uaBVHr/KprVOQtAR/ZZQCgTdcbkqrtuX+iAGo4ejcqEvbqJUX/UGoT9eMDAIQAzDXmdxXPclwKTJtFZTOIbh3UqG2jAaeWK24BErGmLDww7iIN1jn1BpuMzVbwETYtilZ9UuJXJGsxFz4KCR1A2UBl4E5Qn0EbOa0P4QBx91bf9zOO6tSGdHocYWnhnf/l9Uc54/hh3bv1uedQjbkcbOAmDU5tPufPWUzBP06kn0eVqkE6hvqkAowFsh8TZ6yCCycX6FpBrUhmwfBb22bH7voBNKmi7mpomfXL+iREezwMg4UcsdHqgleAIsScl45/RAoK8ZbdW752iUHfjXabNl6RF3uRlTsqJSom+/kGwDedokzvLeDiM1p2j40cC8KXujv52Pp0k5iKm+nLzGMGseZSHUdWix0Nqwz2rJ2EZXevp+6D97qj27j4tiXmczChMue7NMcAOvGM1a3cc+QIeX+I8jIVa8s
 /7LC0jqh
 HwVtmLK0fXdDLN1WPACU46Zl0Vn4QCd0shBkyoUZnskVTv1OHPvtfbCDdJF2+/QGvut9Lrjf72UcVO+Q64SL4kZXK/mROD+t3eG1SmCHxGixfiKe1GhNULOTggyyGHRDwRk43YG26dY1ZrsLN9KGa2CzpMx95T0VRGC3RORsNkLokbqxDtZi7e6eJ5QbgupDK3LoFiASjmXoD5zgisY19zgBXjgQfX64x4M+mUVDE21UG/tjwdWwxeRYwCNzMOIlccJs+/Rmspz5vHppg9f0a1+tM/mzj8BIQ7ypHPPjq5wrvJ0yNRygRCexQ/uUY0Wl355HiSj5l1rtKd+HN5d2h2n+C2ht7hupukv/sWFX3ktkwI7l/47/vhYf3Sl+O6vTcm3r9D1Pu8psueDG6IbiMP1M4P3HgW8PTxTygsO2fSetrBYDTHJfKpQ6XYRrbLrKbWBJYskybNc5VzOcVjFkjz1/K4UX1YN9Qhm9Cespx1ZZ+AZvt5hirS8IOgDr3Oqxh9bSx7KVJ2+D53wZ1zlQaKN2+9V/MuK2eBBSdMKs9B9xBIcqOnu8ETRj3DReyR1D58IZZzf+IUqcOjIb6LjhonfU7Pg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's move the helpers that are not required by drivers anymore.

While at it, drop the doc of balloon_page_device() as it is trivial.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/balloon_compaction.h | 44 ------------------------------
 mm/balloon_compaction.c            | 38 ++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 44 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index d1d4739398978..eec8994056a44 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -75,48 +75,4 @@ static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 	balloon->migratepage = NULL;
 	balloon->adjust_managed_page_count = false;
 }
-
-#ifdef CONFIG_BALLOON_COMPACTION
-/*
- * balloon_page_device - get the b_dev_info descriptor for the balloon device
- *			 that enqueues the given page.
- */
-static inline struct balloon_dev_info *balloon_page_device(struct page *page)
-{
-	return (struct balloon_dev_info *)page_private(page);
-}
-#endif /* CONFIG_BALLOON_COMPACTION */
-
-/*
- * balloon_page_insert - insert a page into the balloon's page list and make
- *			 the page->private assignment accordingly.
- * @balloon : pointer to balloon device
- * @page    : page to be assigned as a 'balloon page'
- *
- * Caller must ensure the balloon_pages_lock is held.
- */
-static inline void balloon_page_insert(struct balloon_dev_info *balloon,
-				       struct page *page)
-{
-	__SetPageOffline(page);
-	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION)) {
-		SetPageMovableOps(page);
-		set_page_private(page, (unsigned long)balloon);
-	}
-	list_add(&page->lru, &balloon->pages);
-}
-
-/*
- * balloon_page_finalize - prepare a balloon page that was removed from the
- *			   balloon list for release to the page allocator
- * @page: page to be released to the page allocator
- *
- * Caller must ensure the balloon_pages_lock is held.
- */
-static inline void balloon_page_finalize(struct page *page)
-{
-	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
-		set_page_private(page, 0);
-	/* PageOffline is sticky until the page is freed to the buddy. */
-}
 #endif /* _LINUX_BALLOON_COMPACTION_H */
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 709c57c00b481..717bc43732d09 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -17,6 +17,44 @@
  */
 static DEFINE_SPINLOCK(balloon_pages_lock);
 
+static inline struct balloon_dev_info *balloon_page_device(struct page *page)
+{
+	return (struct balloon_dev_info *)page_private(page);
+}
+
+/*
+ * balloon_page_insert - insert a page into the balloon's page list and make
+ *			 the page->private assignment accordingly.
+ * @balloon : pointer to balloon device
+ * @page    : page to be assigned as a 'balloon page'
+ *
+ * Caller must ensure the balloon_pages_lock is held.
+ */
+static inline void balloon_page_insert(struct balloon_dev_info *balloon,
+				       struct page *page)
+{
+	__SetPageOffline(page);
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION)) {
+		SetPageMovableOps(page);
+		set_page_private(page, (unsigned long)balloon);
+	}
+	list_add(&page->lru, &balloon->pages);
+}
+
+/*
+ * balloon_page_finalize - prepare a balloon page that was removed from the
+ *			   balloon list for release to the page allocator
+ * @page: page to be released to the page allocator
+ *
+ * Caller must ensure the balloon_pages_lock is held.
+ */
+static inline void balloon_page_finalize(struct page *page)
+{
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+		set_page_private(page, 0);
+	/* PageOffline is sticky until the page is freed to the buddy. */
+}
+
 static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
 				     struct page *page)
 {
-- 
2.51.0


