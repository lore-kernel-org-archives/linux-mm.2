Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0FBDFF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECEEE6B00BA; Sun, 26 Apr 2026 17:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3AE6B00BC; Sun, 26 Apr 2026 17:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB896B00BD; Sun, 26 Apr 2026 17:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7BE66B00BA
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 795EBC032C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:33 +0000 (UTC)
X-FDA: 84702046506.29.C4A870D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 47C2D18000E
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SwcsLbti;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fYAXl7F7h4aq1MzyiFunWzYtUjLEe/+xUEddBLdqVEQ=;
	b=sutpmEVSRFzY8acF4mt5dJEPmHGBZtCSe/ImBEtyg/heFknNhF1w/9yFW6mGpp04Uwg1ET
	1dcpLTv7qx8xahsehjLFVlus6RdcPbuN7aa+rPlihpMAeqIpzhE9f9I7JICohcRleWi1Zh
	PS6mgK6OvDgIxqvOzzpkQw32LJ3mR/Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240111; a=rsa-sha256;
	cv=none;
	b=g1vnMsMIM49MkQ4qZgmdByVKdLxWtj1stV/54KaaYW27o5l1dI6Eq8sNkENZyxAeL/0XEI
	hJ17pyeDYUXkz/lyeInnayV8bSU0ZEnJgcnaXZ8AhYpYYLgmEI9Ve7uXyoEHeGT+m3rTJP
	2d3auh+NxrgayFK32kF88tbVpJGSnqs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SwcsLbti;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fYAXl7F7h4aq1MzyiFunWzYtUjLEe/+xUEddBLdqVEQ=;
	b=SwcsLbtitcVK8jbszpUgM3IryzkOa1gNUYYMushC/1zT9kgtGN6nN6cGsqnJLeC7HS74zb
	6A2OavUx2pj2sP964qLQZitSLAeAgnJSuysnXscGMyTXI0NYgGRPc+xsv905j/N+UP+xzL
	+R9v0tPcdF5zB0dcEgpw8c7nRUodC28=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-gpbkTib3OyanlmZ0puCyYQ-1; Sun, 26 Apr 2026 17:48:29 -0400
X-MC-Unique: gpbkTib3OyanlmZ0puCyYQ-1
X-Mimecast-MFC-AGG-ID: gpbkTib3OyanlmZ0puCyYQ_1777240108
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43d1fec59c9so6059652f8f.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240108; x=1777844908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fYAXl7F7h4aq1MzyiFunWzYtUjLEe/+xUEddBLdqVEQ=;
        b=P/5UK0J8c7bmvLfqS+AgQEIg0DRZXGwU+T2vCss3nzRte0wgvTvM5nz0OxV89bYrUL
         ZRofJeUc8HhCo9z+G4CJti+Syh7Gy8DBKfqwERSN4laf7+sD8T/PNsnHymkZpTbYdzkn
         mMRwBe/wHBdshWvqggUl1Me26MlP+YJ/kubj/iU84afzQVCUINxU8ARPmHY5PJXq4VVc
         DqiusDtYVrp3uv2dgxDQib5/dzXERlp1IMmJRjXRjnwCkOMUQ4bwn4fesnUc5rBaLJiJ
         dFM8ZAxrZIeDz/VzGpSbbk8Ko7yMtyH6hFz/YpWEvyoMtq2QfDohzYts4CfS2uB2rHrL
         mDWA==
X-Forwarded-Encrypted: i=1; AFNElJ/cNcQN9FBYHJgY17dL8804Rm+NSBNKlYAPDalKL6uNfNSuj0iI+0p3p8sp9mayBDV1wph8/wbEaQ==@kvack.org
X-Gm-Message-State: AOJu0YwlvMEKGD4sgdAByjoLlrtI83G0xJe1ZY1QFCMIiah8aoPjh0jn
	l1r2Sy213oG9XPATHiNrGE9+tESXcPsbvAm8/zLhGW7kJOboWCBSaR8Cbs1s+QtGdrek4hbV+ZT
	C3zVD+Ie6xzfZmdXLj2ylzu2hb1jWYhLzWP0l9zVDNUlQ0JOodz+e
X-Gm-Gg: AeBDietkaeMk8GEjghmW7o7DUVvtXG4NxRjm0/CAmN6mEip3ZUuDVCyWhVGC1emW2iq
	Hcva7uSMIRXsKfmoCcxf9JkAuAPw9E2/6qKogHPoWn4NLCNpJXAP/zYsbnGyv0Pbc3wffcFSj+M
	MLzfL0lyjGo7eQf5jXdy+RH5C2Y3Uq08PoKzGzUeVYu5r2l+G7AxTcqyCh39/GSXmRGbgHZLZ6U
	d+LN7CIP5nRRjsFjNVx8TVvoyOb+9KJl7gT2mGtqV8YVTFapM7m6g6GVupOAB47dxLcunQdATX0
	LSWlb2xhZkCMYVqTFRm8agQLed1q/kguuOOuq4+THQNnePZDaAwK/mC1qiGSbDbZoRb/M0fQT8U
	V8mi5wJYzgHPhGBZ0TAfg1mtJCsGL2RvaHzxXv7l5k0ddoyqRWFSYSRMN
X-Received: by 2002:a05:6000:290c:b0:43d:772d:2b61 with SMTP id ffacd0b85a97d-43fe4073831mr59751634f8f.15.1777240108079;
        Sun, 26 Apr 2026 14:48:28 -0700 (PDT)
X-Received: by 2002:a05:6000:290c:b0:43d:772d:2b61 with SMTP id ffacd0b85a97d-43fe4073831mr59751578f8f.15.1777240107558;
        Sun, 26 Apr 2026 14:48:27 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a79esm79138134f8f.17.2026.04.26.14.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:48:27 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:48:24 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v4 17/22] mm: page_reporting: add per-page zeroed bitmap
 for host feedback
Message-ID: <aa79ecfd8ef49fc9d47eacc6a17d27cd8c6f8975.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: woyJdPsFBu79LJBeO8wOAkgREl-zJPbVLNNTLxvar4U_1777240108
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 47C2D18000E
X-Stat-Signature: j14sd9edcbj9n3zdszia51musq6m968i
X-Rspam-User: 
X-HE-Tag: 1777240111-96317
X-HE-Meta: U2FsdGVkX1+b7ENVgBfVaFgggvpNJRjJPWRRkgRgNiCLmNU2euhoJlejg4i4EYMHQ8/tRuvnCSDS5lBlkeJMkhIOGyKpNcH1A8IB242kKTUCyrays4gKsFXzSuWuvI0PTOmy241cN9JUhcdIhX4wXMMWsQFF2gHR9ne4vLHTfj513nu9KB6OjDjVsHfkV8ksZz8rSvDhS3FjlQIruTOZ+QH16bEmroYOD6Cfn2GSMaE/jd/cqlT8awcswipzlGuSTpZKP81bv6cylv1Ux0O4W5V9MMm8UiFhFfy3tkQxzYfOtqa/7zIdIeqFqrdgAYqItDVMN4eq9b3WalyQDdfwVNWBSUz6C9IyJIQ5rhGpfU3clncCOlBNQRsiJt69gM96g3BXdcsL38Ju3OEVo2tTVMzJ9gYgwsQjn60dtniaoIDMLTBX5QCfuIV52ofq7w6a1f7o8TmEA6TTKdAPH/h3AQdkhqOX8s1ZzxfVvG6MuG4AoNBy+ZT9lNEN45gfNPQdvlJcAJKzPENxLQhDIwaz53GAtYGM2o/pmdCL4c6iaizMKAFBKCv6fC9wgBLC11w3mKSg2eXEe3fr+U1rrs17xTfGywPbIrfu3nhXeh/dI2TIOpxtSlq1Ud65c7imPY4uSpELFjH357MZsOvqdMIig9z8Izd9zIlZ2W1Ogw4SXzVHwR9XIB660zk4Wx+WTfkhk6Xg6sCKHbrIsgR5y2FMmd1AmtNKCkcMLmQGQx6DPD/c790xWo7sqREG3n02h+yB1PXgk1c9jk5RTeEmblyQ8Ge5JThYayz2yVEtd1TDm+/ZnBqb8fyJ4yop9bS1PQsxczsq51Aby23v4G6cSZEqVj+SqEIIWnbrqVX0YpNIUCO9dIi4owrqQasOKEWOjZ/g/TlHA775VIg2uvAqhg0z0d7FM+RBVe6A+YoGYam0OkfzReD1YiH3q2ydlVnZw1LaUe/8bntP8v5Efi9ThrV
 U3ibb3rx
 G1VPliTOnUDnizzebraD83UM5B5T4wlVDUTDQ+3bLaLVyL2vVMvAIo5SRr612w+PJr1091sXq/W/3by8WunIWx8yVCWodY1cbwHCvugnZBLVF3QdUVgERtUiZZdcfnZoF4ncZWRTaBzIAcdyrnj1a76Jl4met7sltniz+3WK9WskDD7i5VOfCjvlC7s+/i4ozXVSNWNJMviTDRfsGuqrEFGWihRPY7Rgo6+MKLO/CX9EPoGzZ+Mjwnbqtu8SfpUj+dIUMFt5Bg/HYW4OYoYxHQr8mczKhLYfkIti8eKXytXOIiDEiaVEDaLlNOiGv+uxUe/PmJS1sLUjcgyIiugFHgNMuesvteydl84VUydXbm+jIBrcPeILNl8Ik4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The host may skip zeroing some reported pages (e.g., due to alignment
constraints or bounce buffer fallback in QEMU).  Currently, when
host_zeroes_pages is set, all reported pages are unconditionally
marked PG_zeroed -- even ones the host did not actually zero.

Add a zeroed_bitmap to page_reporting_dev_info that the report()
callback can use to indicate which pages were actually zeroed.
Before calling report(), the framework initializes the bitmap:
all bits set if host_zeroes_pages (optimistic default), all clear
otherwise.  The driver's report() can then clear bits for pages
that were not zeroed.

page_reporting_drain() checks the bitmap per-page instead of the
global host_zeroes_pages flag.

No driver uses per-page feedback yet; the bitmap is pre-filled
based on host_zeroes_pages, so behavior is unchanged.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/page_reporting.h | 7 +++++++
 mm/page_reporting.c            | 8 ++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index 10faadfeb4fb..5b63de21949c 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -16,6 +16,13 @@ struct page_reporting_dev_info {
 	/* If true, host zeros reported pages on reclaim */
 	bool host_zeroes_pages;
 
+	/*
+	 * Per-page zeroed status, indexed by scatterlist position.
+	 * The driver's report() callback must clear the bitmap,
+	 * then set bits for pages that were actually zeroed.
+	 */
+	DECLARE_BITMAP(zeroed_bitmap, PAGE_REPORTING_CAPACITY);
+
 	/* work struct for processing reports */
 	struct delayed_work work;
 
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 6177d2413743..61f7f08d02d4 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -108,6 +108,7 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 		     struct scatterlist *sgl, unsigned int nents, bool reported)
 {
 	struct scatterlist *sg = sgl;
+	unsigned int i = 0;
 
 	/*
 	 * Drain the now reported pages back into their respective
@@ -122,7 +123,7 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 
 		/* If the pages were not reported due to error skip flagging */
 		if (!reported)
-			continue;
+			goto next;
 
 		/*
 		 * If page was not commingled with another page we can
@@ -133,9 +134,12 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 		 */
 		if (PageBuddy(page) && buddy_order(page) == order) {
 			__SetPageReported(page);
-			if (page_reporting_host_zeroes_pages())
+			if (page_reporting_host_zeroes_pages() &&
+			    test_bit(i, prdev->zeroed_bitmap))
 				__SetPageZeroed(page);
 		}
+next:
+		i++;
 	} while ((sg = sg_next(sg)));
 
 	/* reinitialize scatterlist now that it is empty */
-- 
MST


