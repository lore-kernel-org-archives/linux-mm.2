Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 553D2C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57B376B0114; Thu, 23 Jul 2026 03:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504166B0119; Thu, 23 Jul 2026 03:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C93B6B0116; Thu, 23 Jul 2026 03:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA3A16B0116
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:50:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E389803F8
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:44 +0000 (UTC)
X-FDA: 85019269608.09.F4A25A0
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7BB85180004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="XWJ+Y/P/";
	spf=pass (imf06.hostedemail.com: domain of 30cdhagcKCEIn2iwgewksskpi.gsqpmry1-qqozego.svk@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=30cdhagcKCEIn2iwgewksskpi.gsqpmry1-qqozego.svk@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784793042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWxJcdKUwtMW5XvZ+xp1cU8oxCOA1ugDuHmrhdptgLY=;
	b=CR/O1Aqfxx0VqyYUfCMUAsPjeiQIR6aWs9rK8Hhdr/LAc4ttqVl3fRfN3w272ddUp6YuXI
	5LAr3BfIVZ2Z1nSexElLohc4GxuoSLm22fj4J97n5XaxH5hGEK8cwlJbv2M144fOsQhTYY
	CAFlgqLiDrvawmHa2OZcd73NaZaXd6I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="XWJ+Y/P/";
	spf=pass (imf06.hostedemail.com: domain of 30cdhagcKCEIn2iwgewksskpi.gsqpmry1-qqozego.svk@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=30cdhagcKCEIn2iwgewksskpi.gsqpmry1-qqozego.svk@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784793042;
	b=NLfMmhDcj4jZJ00YVDTtHzjcezz9zP9ShTZl9y3T/bfCVY4JooQVVvU3OF+5pxN/Tfwsdo
	UaHUH62FfqKz5b/HHACIqRsSmAFDOqzdSjT71oVWIAyOYplcKWgrNEWARAlUb1REPPe/E5
	yEp5DE9ftjJ4yhv5vP2y/DXa2cVwYOk=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38edd45cbc4so204661a91.3
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784793041; x=1785397841; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XWxJcdKUwtMW5XvZ+xp1cU8oxCOA1ugDuHmrhdptgLY=;
        b=XWJ+Y/P/YtI8GtogSkeXNHZs7dFDbX/GgbQ7Z7HqKMKb+H+bOMnnEM+OBxOzMUOOJ6
         ct57HicMa+2qkRaKJ20D+mVyGYsbavMfnFM7Iam91rYvIXGW18CsDID7cNK2GviGJJ/8
         f4N9Hb1Vva8CnS+htsjqBl3SMt7+4hpe0D34+2gp2I20cOpBPBqtsu4asHRKCyMjXA77
         jIRe9r7um+5ttdJXNeAY+p1CZQqZ1hWO68HpUHHVqx4dmz1NrraODwdeoo/FN2heKdJD
         lOc9oLmYCBnUbHipVckN/mmZutceyyAllNUW01QdHmdZfnPLOaMzhPouZV//P8XcEMcv
         x6sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793041; x=1785397841;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XWxJcdKUwtMW5XvZ+xp1cU8oxCOA1ugDuHmrhdptgLY=;
        b=I14cebz2HP0LCri/lm+IsbBTsfAYShXQMsziLp8MVPxRIMNAhkqts65HyCJNCDgw7i
         95EjyKSDqdvkDPR/VTh+hNtoStJlSLhaWxDJXPkJHXBNiIWsRO+I3ymY8VZBryflx5Ox
         d+uhs+x/L3WfLHy3F9Nnx3WX+lrSQKa5lPa7bMMkEyUsmQ9xCAn/trkMv15tJ+V/3Jy7
         xVgmdZXDJOrxGUR8R++6+MNJ9+nN+YhhfOmyWlXXA4rxy8PC7ACoZIRwnAbtERj6SUSP
         p5WucLT27SVuq5Q/H4cjPvD/kxjAk9QMbQ1H9RRrBs9Y7BqJRiI2sNyUvZkYF5VJdq7J
         YqQQ==
X-Forwarded-Encrypted: i=1; AHgh+RpCh2OnAV51m1NB/GrX7Gx3yz09VXMVvxQXeW/fKChQmRZk/rp+P+iZSN/A7TqybLh5W0ZbYFMjDQ==@kvack.org
X-Gm-Message-State: AOJu0Yxxc6yDHcZ6+Lgu+W+DfH97lf+F1V/CMpW5cM/QIdmgyL7HZBGM
	8cYUqzXgJBhimL1RVE9YHTFvnFQLL0+PBJrKDkIq/eXCtH/VnyxIvjCtQeRv/H2HNYfTLkjPiwp
	oC6/KOpCP2w==
X-Received: from dled3-n2.prod.google.com ([2002:a05:701b:42c3:20b0:13c:f3ec:de14])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d10:b0:38c:a59b:5189
 with SMTP id 98e67ed59e1d1-38ec698af76mr1930616a91.15.1784793041228; Thu, 23
 Jul 2026 00:50:41 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:15 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-12-jyescas@google.com>
Subject: [RFC PATCH 11/16] mm: Sets the migrate type in gfp_t flags
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BB85180004
X-Rspamd-Server: rspam01
X-Stat-Signature: tozo315azctxyd5j9xgab4pj6htxwgak
X-HE-Tag: 1784793042-237153
X-HE-Meta: U2FsdGVkX19Gktnd370fQjhuyDUNZY1MLcHNOSlTt4rbCgPXTRB3gtr3cAnh52sgYJX5BpKLwun6ZxtLQzQmlEIjNmxicqdyBrroacz4rQtF3Esno1bTL9bGUCSIop8GjtGbO9lHkzZoPkuDczRDg2lHARtbWSzWdQwz+WNaUf1Xt/nhum76Z67KwhtP3Jl8PHzEKQlPEIRodOMqU2X87hO/1j9sAK/FvKl/x1wK9U9rqsqV7B+Wd//VvnkCGg+2raQPkImkLi1NMEhEsjVwHQceUUdwLirIxziCeWhbmMfKhIhK62m+uaVr0Oa1tsuNAniWn4qDvBHVLkTnwDP94R/ElHiLPL2bHQWd7SfpG9oOyGDBK+i5DviS3AXwVu9hLYGbSDlZX/9s53Rh5j0Br0jSzpXnbyknAD/pFyOuTeWlgFVz1pL8lIM0SZ5HZ22naL1K1wgNec+q2aT9E1/L2e6xIxgsBEX3mC9Zeeo4O65cRNM4FA8a7PwN9ty78AnHTUsBTWBzdw12XJhgbS6seWm4l1ELbboUv8eFMXtTJ+OBfH5yZqdHO3WCQvXbfoZY5ClxJETUB1TIrsqsnSv3CsC0Ne322Fj4lgFDPe7smSipYpTfRmYfMIz72lDPBX7vYO/9lf1mqOLecw7/RC+TcG2J8L4tXwINwuADwg7DJSsDcnGWU/dFfPFJFiGyOIv2VaNVyLPSPjjtu2XbsLdfo4PvNcQNYTaFA7/3U8KKskI78eT6aadgASeChDW6LuIhKTX9QR8QrPKamnoTL1qvvwhFF7W7oov8dLYXW78CvMAJEIJRAsObdgjpFm88BS8tcrB7C2Vk/M2nunHDe90SFhtz1EgjDmjypy/z4W8btVGFAqI/1aBTyO4Cm5qQ/dlpB77GYM1MmqhMYU89dB8evp85qV+NEiuRPKBRpRnj8FI3RfH3IABsb2JXMH+plOq7LpgWQiFInmShc6Qd4n3
 vzOY6Our
 34Fl430DksBZgU3RZXWpsKsmSUt1NE8CF9LJ6hLX2k8RXY91CNF4mvBh8AcMf6dNibbPErUN+cUJsIRNQm9WHCYd5QQKM2Olf6CuiUK5SRr4LjdOodsBQBoCxZO3WTP71CWd69AvM7QfDCsGrWQlqmWTSydOLKwN65JuyDnbPHZHYtPGtK9hxaydI4Uq9TOtFdjXvUt3kHHMbhsWdS5cckGpCgA8Q8+aVOUFIUH1TQTOvl/C9dDkXihv7gnFyNE9ZLeKOSa96QA3nNtS+N3/aZ+xWaN/0y45eohzpPKJe6ZNp+Gz1U37hbnBxpdTwNVLNV94ETxixrjRlJiduP00w/hcBHTQRsDkmGEHtsupEmg9FOZHMYJKzXpICtC66HKM4U7B0Dckx3eKlxjQuyIa1PTOPE7TQgix7OtzAW9T/cBC/vgsu1JiBaA0O0A4CAkFo2LT28Q7F2z47KTLnZjv0yT6xHgUmP7JJawyMnnPahJSjpMDqtKpScsk2ixqC02ArCYqZ4bNpteo8ACXPPCmh/AEcSE9Hr+LfYZFCHYeRtCkMUwIAmnt3iNaXrsannmThmC3rSDBGQpUUE44M/EsD3ZbJgV9hQ8wbj8CThSS4qTC6l+/+YanOu7BDnre0rTBiZYC9XuV0Pe8w+i9Kp3VfGtSagEKGRdXcHK6CQMHdTSSjwHk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change sets the selected migrate type in gfp_t flags.

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 5c00e9134a66..d91f49880f8d 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -156,6 +156,24 @@ inline void set_zone_to_alloc_from(int zone_idx, gfp_t *flags_ptr)
 	}
 }
 
+inline void set_migrate_type_to_alloc_from(int migrate_type, gfp_t *flags_ptr)
+{
+	switch (migrate_type) {
+	case MIGRATE_UNMOVABLE:
+		*flags_ptr &= ~(__GFP_RECLAIMABLE | __GFP_MOVABLE);
+		break;
+	case MIGRATE_RECLAIMABLE:
+		*flags_ptr |= __GFP_RECLAIMABLE;
+		break;
+	case MIGRATE_HIGHATOMIC:
+		*flags_ptr |= __GFP_HIGH;
+		break;
+	case MIGRATE_MOVABLE: default:
+		*flags_ptr |= __GFP_MOVABLE;
+		break;
+	}
+}
+
 /**
  * req_page_alloc_write() - Allocates the pages on the requested node, zone,
  * order and migrate type. Once the allocation is performed, a file is created
@@ -180,6 +198,7 @@ static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
 		return -ENOMEM;
 
 	set_zone_to_alloc_from(req->zone_idx, &flags);
+	set_migrate_type_to_alloc_from(req->migrate_type, &flags);
 
 	return cnt;
 }
-- 
2.55.0.229.g6434b31f56-goog


