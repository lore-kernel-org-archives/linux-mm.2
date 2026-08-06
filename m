Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53A1CC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FFAE6B009B; Wed,  5 Aug 2026 21:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D8956B009E; Wed,  5 Aug 2026 21:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 915B26B009F; Wed,  5 Aug 2026 21:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39CEF6B009B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:11:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4256F80616
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:11:47 +0000 (UTC)
X-FDA: 85069067454.21.34B5CDD
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9DFBD1A0006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:11:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HcYVW062;
	spf=pass (imf19.hostedemail.com: domain of 3UN9zagcKCDketZnXVnbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3UN9zagcKCDketZnXVnbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v2eQsWE6/2RUaKCIRrlhYiV3zZI+x2OroGpQf2kxf/g=;
	b=i8neFY0Zp4UpFyuKoqovp8nrjYoHwPggmrd94gSMPv/l/iCknBkBH5hqsKy3wIufTrg5Zd
	yYHXetYdCwNVPOnXGzjq9Ii8NAhhVBV0q2AaJ+oVPOuyQzHy3T9JkLhd5x0jfIYSFfjJ9T
	thmeaao0Wz93NNdJSNm00HfxdR7OaOE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978705;
	b=RNpvDTX3FPhw6VBjiwTmRiHckiz0ZC1G7p5N7oJseAJZgNFW428Uiqe6ETlIZBbrYpBGJ4
	X6QYFQ9q+BrZDE5KI7y8+/KNp/31H//EbRzoZLJDLNdXFDhLxDfL95e6v28CRkKqcNE1aQ
	Wlqg2Bd6oMCjtU4S0S5zkJi+NuafT84=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HcYVW062;
	spf=pass (imf19.hostedemail.com: domain of 3UN9zagcKCDketZnXVnbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3UN9zagcKCDketZnXVnbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ce7fabf76so2635938a91.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978704; x=1786583504; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v2eQsWE6/2RUaKCIRrlhYiV3zZI+x2OroGpQf2kxf/g=;
        b=HcYVW062jU8421kB7JAtQkk4p/Is40DzQ3wEoj+aSqK258erw2orpNPdq5y3EhirZq
         lqFq0rC38oKuxMEibMtf9jvuPj6KGv54DeDMYOKakVnO/7nF5fKWaPy9K4l2uuGVv4Cw
         iw8zTkk41+FvyVtCV3ukOdsFTYyIqxXRiOtiHQgv7P9KJjwgITV0mSWU9yflNWqgZfK3
         kWtliKCDDPsbWNzzHFTFMljnMlEHbVcu+pyVO+GygrFTfVVsfOduWOAJRFdMEoWBJEHC
         51MvtP7RdM2gGF0woJqy/5wYDrf13gDXo5p7+0nEWGln//KTVp51oi/GqRleXmjHzDp6
         F2uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978704; x=1786583504;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v2eQsWE6/2RUaKCIRrlhYiV3zZI+x2OroGpQf2kxf/g=;
        b=VoswLPOxsZDwyghz/Px/mk+L4BMboqQoYNsA2UlKBXtR8z/Nku1zZvVB/SLFGOZYK3
         603TMGLrW+XoPV/DbSxRWqHuqAnkiaZ4PMB064CMD6tlp+1rPMMfooiWAosB1nLZW8Js
         7uh6KLBsbGC92JAgEjgEePUwPBT5HcLq6WxRI797sXrqn/WqVcbiLCBYNgSPQ+n1WOC1
         bltQyS9jG5SttTmoRFts9O/icUoXlg0Bb7in4P7gwpZYwkCLzGVoKCFf0ky4XPgiL6j4
         dFwQGht7C8IvzkXndYwjlPr4+z9rKJdkYFZAvc9+yRv632AE2msqU13WO/QVgBbdmCVm
         FI0w==
X-Forwarded-Encrypted: i=1; AHgh+RrV06YCj3fw+D5dnYHEE5GHgBHkSlbEJG+BFFCArrA/uB9QYSdiwq/Td+EBoVF35ZHRXsWMPp9Byw==@kvack.org
X-Gm-Message-State: AOJu0YxBkM3jgC7xCeAC6NrqhZaied1gkhGqeMHgwzgaTP6C75kVOAqe
	OEkdPBbAHL9/+CGmzUmdT60PMRDcJ/Fl+k0BRCbEVHNvv5hDuGcUH0STenSiGpBz7h7LieiQmnQ
	m5V6LMg2XeA==
X-Received: from dloo4.prod.google.com ([2002:a05:7023:a44:b0:13d:1fe2:b775])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a8d:b0:38e:57a3:f218
 with SMTP id 98e67ed59e1d1-3903c5b9f70mr9731131a91.13.1785978704313; Wed, 05
 Aug 2026 18:11:44 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:03 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-3-jyescas@google.com>
Subject: [RFC PATCH v2 02/16] mm: Define structs for allocation requests and
 store allocations
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9DFBD1A0006
X-Stat-Signature: ir1zmpp9c63ee39kzy9su9wgspcujbuq
X-Rspam-User: 
X-HE-Tag: 1785978705-884342
X-HE-Meta: U2FsdGVkX1842R9FJS+sqqN6ocAUJhJkfRL/spXwOuPqs2vC+03N07Mdy5w2mM3INeRGZ/6nqeqrPIVN4xJyqX4wFck34gY6g24aYUt/llIZb+KLFrrCt3PFrZ+1iVnANLSw80lIwRyMipgkQ5who6hVKt4bY8lXo/oHvIrb1+eNrm8PqdwLnoy5dkua1aZ/uV8Ckwg+aKk/jXaofDoW9eKwn1APd083OOE0o2rKVOFnEHDa1otNKB+Z2v2EoAVWQUiUabtBUTrqAf5iwZlSmzQIjU7JJKWYt73W1YIQU+ru03f8mO1i4bPP5Z8LB5QSv+P+GkUxCJ4MlLZgxlP2pEU7OSJIFdPuIoePb8W8sahd43gd42x7RH6IoRqmecFrMxnGcOtgZzOkrwA0z+hrFwIptxmciCVb4uhdompMG+BuAQug/bUZKDk7Y4zITlomRiLgqzdsFnMUE57anwuiXd1/Y3/T43dgikU2s4HD/2Kkj3n1w6uUGTe6qiMfz+OZvchDOjHy58mqo8kyfm5JTJw1aCZmsH2Tu/OCv6/hO9sgfhWDv2iOSDi1av0BQDThBEQJkpW+PjFsQX9pTad1GbnFidHhozQongtlwEcAtkxHYt1JCZqoTslFQYUhVyfI5L1B332tLYwP5G4JYMDWwAwVcYN1NsmEs7qjp9vUI4iEVPP0aPBDIaJn7NCwf2b+yrjP0eWRjriuWexje6VDq9Zyq/h1mkM2Xs5x29X7FBLkS1Hms2afTgx0/aXQSHZmMWmGp8UqW8BbYKnJteynRBpQvC9X0a9H1reZTFm8uuod/M4lFMXv2CqfnYMYZpX9PDo9YhxLtvny1JfhjEItPUdIbfMu3bOS6o3b6LCdPUedObdreaYA95d6kAb5Rm9nVJNW+Go/NJ84ntrxT+nDU38rFcX++9YL5GlUf7+E8rN7KiGInFrPKQc6tRGbJE1f+x/zSz58yYd6mnqNMS2
 itqycJ8J
 RoUS6ngvXVVaDE1sIBjmA+2HZZptORHVrFyGzqdnIkFy4BJt+b5aLylibcLlBtTEEhNlamFy4u/HplwGiPf4Dq0BizjezVF2KrtQGVQijiNrNNzRylYABc1rSyt6gWOG2DSCbDNaMz0M89HfX7VagFfbb8Kj8EbFn7+/3EJk56RwArXzGiLaApmDRQ6HGQcz2P3uS86qGFGkeJBS4uHnv4gH6TEINet4oI4aDz5nnw1cyKxOf9K9Axh9zpUuRIMMDN/Y/2+cuUL1qjKLVO3w8qm4TVM+U4+Z20ArUztjWbk6f5x8wymt7MNfa0mBE0p+UO3O+/1FFS33nE64mduY2SngUPe0Hxf5MghY5/Et/h3b/RDR++bgf7SStHExQFeJGZFWeL/7OAhmnYHwEFcKyNX3gzb+PDLDz3/OU0qT6C/1v2pWm8xhBE2bo33+CGjjBBwptiSqe+fycUwc8eNbzJQ4/9Nym8Q7EcU2wPCPEp92J20Cl5gBDjsYNVlFDy1mzAg9fP9QE9QtZ/X7vlBd9j7HcWgm6dKKNJIu8tJwOwiMxz2a3SIxDbydf1uYT9YMhdEp1IRT5guDIrIyoR6MRroIYKhtNhGJAT09F5+eALwYxB2ZRmNsvH1AUIQ==
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

Changes in v2:
	- Fix comment block. Add an extra * at the beginning.

 mm/page_alloc_hogger.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 1d31e981920e..caeb2e5e8579 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -91,6 +91,34 @@
 
 static struct dentry *mmdir;
 
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
+/**
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
2.55.0.629.g250fe7f194-goog


