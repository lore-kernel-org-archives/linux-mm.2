Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47407C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:00:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DF526B00A5; Thu, 10 Sep 2026 07:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5846B00A6; Thu, 10 Sep 2026 07:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2B86B00A7; Thu, 10 Sep 2026 07:00:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F35C6B00A5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:00:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08ACE1A04D1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:32 +0000 (UTC)
X-FDA: 85197559104.29.EA4825C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5C8CC40005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PUSLtGkW;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kEZ6nz/JFEHq+6k02cM7QTBhs2+peJoyslzMnyOEfRs=;
	b=Kg3CqBmyOVvxQdMjxVYwgBBMKF+zNlcw5UO+aesGQFFVp4DMo/9Ecjd51tiiPyAkNpTJ2l
	dB2cszKyuq+YDekqY2fF1EZ5ynbpPlDKTq4ged1Gqmd5JIql16R8J+Cu2MmqqO0VccuNWS
	kwEh3FCSA4NSXfj4Pgq42ejdDMu0VY0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038030;
	b=vKv1AvDbu3pKU0iayVZEkYWkAg4q1G8fXud8i9y9vjBrLQ3rfS6ZaI0PZQB5hdkjPZs1tF
	DnS58zrsqiz+mc5QBhF+fY7fmxl4tk+yWHRAE5usa3d5uvIJW7PnQzPqIiuyUrw8wJRsVP
	d1h+6kXuFZu0aiNzVbSlJicsIjda6EU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PUSLtGkW;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0097760216;
	Thu, 10 Sep 2026 11:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02D71F000FF;
	Thu, 10 Sep 2026 11:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038029;
	bh=kEZ6nz/JFEHq+6k02cM7QTBhs2+peJoyslzMnyOEfRs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PUSLtGkWdQoW+cSKLEstDTvjtTeqxWgpfsBiiGWDFJ6/TgdE8RnkfKbvYkWH/mxQq
	 iUD1GMaIaoNEzflLY2zAsXaOXhLynyxr7XCAvjSidp0vG+Vlvpv1umfrZBFuiD+q4J
	 vMN83RdUZQ/KPVcNidMa0lqABo/fOw/x4yahPoo8IiglMd0D2/43P5RRDSNf/AiNOZ
	 B0CVFCFz5ZgnHe0oSLZFnDjvOO/B2T/TzHSRHyKLeRjC+cwqEULVvkA8uN5R4I9TJ9
	 E5bjtHmqPaP86CNViLqsXoTbKl8X34Gxt08GmhG4jkmeu3a60XAy8Au3/CHJ58ob3a
	 a0Hvww47S/I/w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 10 Sep 2026 14:00:08 +0300
Subject: [PATCH v2 06/13] s390/cmf: Use kmalloc() for the CMB area
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-s390-cio-ready-v2-6-e931086fdde1@kernel.org>
References: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
In-Reply-To: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 5oyxwwbqednnak4yf8iyfigz5twegcus
X-Rspamd-Queue-Id: 5C8CC40005
X-HE-Tag: 1789038030-647738
X-HE-Meta: U2FsdGVkX1+wfQtlv0uAFjofYr0SJ1mHJwaeNL7g3ev0nZPFwuQ08M/64meGoe5eLSREBXco8nfzouDH1JKOhRSaX/ZdDvgHZedh2yeV99OFQJ4eDB+fVZYKaRpweBzLGAJamGGVzuwwthJ7BL1dtanhpa3x4F5qGi7naNkQTCLPLrTlQMJ1lzTGjSqts8OOw+SGLwzxallvZz5Hr/6T9z96O4yMkvL7PR5EVEi3zAsCav/O/NGM3WktUYz35Nsc3+ArGWcN0Y3BMLaAk7yUXBPn/H5xUXr4mXVTDlGo/AgXgjFZO5Su3lk+UPRWdikSZztUOB3dO8JJmv06AjSuNzi0qOis7vILvyFMmOIslS5yuzq8q4j1GFGRAREYyR94/LZYaTVlvrlJb0IEZ7jeGtB/r+O0qn0BTxsXez4/+o2yVNy2LZk5U90D4Qcp/22FCGByVlS1hHO090MKestP7nJsfSOG+M0GS8ZVHujQKcqf+pYpH8NVq/AbZ4dxvmazwguh7LSq8NXlrwxLvKTQij9d1SxOYnEHI0ogIAfSmG69C8t9U6RyDa6HimQpJ0m6JjNn6ryWosUpCuEvKmRDRkIKb351HSLtumpzog6HdvSA87joPeGlx9SKpvAPoxeZP8Ql77DmkpNdquXYhk0vhcd0YzvMn65wDwmlj1rEH6h2i8aVFkeJhryapXqsUhOSlQZ6zf1JJ0FHQW6Xv2iG1qAksX17gWOnKxq3OCYVZYH+rIuWmdVG07xq1WlGY288L2PP3WT/NejWytr8fU96c2vegBS+bUkjGm3dlz3o6C0yvXgvP4Kn62kFlaLy+Jx9OjHCop8kfCJ1MUTGXYqJAkJnlyprOzpFYpTP3e73vqua/SE+cdavi26ZoIW0CcguXKPT7gRJEo/JUt/zee0rTQt91lvpuMqoYP63wef9WRTPIw9CWsDALKCPic5duYDCG+kjmQJYr6SCi7lPBYN
 Iu2fciCP
 M78GA/ot7Xs8fLi1OjI2B2UhTKRNYMmx1wv5kD4no6LuQWSd8PkmYrvy3Gwa3bblRYN/1uoFXZQVHXmU7LNYeHS8fSpfqNkmkwgTdhXI5LTaurW0hrF9EzGUafHILz45U2rb7Ni8ofOqYLrdxFQhzRW/ii5w9vVTVIAgKgcQtWZT5UZP16ayc2GbF4goknKQuWhjJkPVmcBVXwiffOAfzqUJdHK6dOVl6csDo6bSX4qOZOjiCLScFBrG9o8Dlee4kyIEqInUYiA6MVTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_cmb() allocates the channel measurement block area shared by
devices using the basic channel measurement format.

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

The measurement block origin must be 32-byte aligned. Each CMB is
32 bytes, so kmalloc() provides the required alignment without rounding
the allocation to a power-of-two number of pages. Reject an empty area
before allocating it.

Replace use of __get_free_pages() with kmalloc() and free_pages() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/cmf.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/cmf.c b/drivers/s390/cio/cmf.c
index 92ab3d546fe47..8fd41a7dfc20b 100644
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -482,6 +482,9 @@ static int alloc_cmb(struct ccw_device *cdev)
 	ssize_t size;
 	struct cmb_data *cmb_data;
 
+	if (cmb_area.num_channels <= 0)
+		return -ENOMEM;
+
 	/* Allocate private cmb_data. */
 	cmb_data = kzalloc_obj(struct cmb_data);
 	if (!cmb_data)
@@ -501,12 +504,12 @@ static int alloc_cmb(struct ccw_device *cdev)
 		WARN_ON(!list_empty(&cmb_area.list));
 
 		spin_unlock(&cmb_area.lock);
-		mem = (void *)__get_free_pages(GFP_KERNEL, get_order(size));
+		mem = kmalloc(size, GFP_KERNEL);
 		spin_lock(&cmb_area.lock);
 
 		if (cmb_area.mem) {
 			/* ok, another thread was faster */
-			free_pages((unsigned long)mem, get_order(size));
+			kfree(mem);
 		} else if (!mem) {
 			/* no luck */
 			ret = -ENOMEM;
@@ -547,10 +550,8 @@ static void free_cmb(struct ccw_device *cdev)
 	list_del_init(&priv->cmb_list);
 
 	if (list_empty(&cmb_area.list)) {
-		ssize_t size;
-		size = sizeof(struct cmb) * cmb_area.num_channels;
 		cmf_activate(NULL, CMF_OFF);
-		free_pages((unsigned long)cmb_area.mem, get_order(size));
+		kfree(cmb_area.mem);
 		cmb_area.mem = NULL;
 	}
 	spin_unlock_irq(cdev->ccwlock);

-- 
2.53.0


