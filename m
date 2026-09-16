Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A799C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B536B00BE; Wed, 16 Sep 2026 08:03:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D58B6B00BF; Wed, 16 Sep 2026 08:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29E0E6B00C0; Wed, 16 Sep 2026 08:03:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 001236B00BE
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:03:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9AAA4140702
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:54 +0000 (UTC)
X-FDA: 85219491588.22.0A5A634
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id F1614C001C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ml42hJBd;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560233;
	b=k4+G2xL1DVxgTi/1fVtgR6nvXcWkhUVUIJgr8PIFCFP/zZo4KHhU3icF7vdwo7kRdtRtx5
	vtPBacgUp5S0P0lTPWBc+pqYwmvAJG7CAfFf1VH1QOLVny2HlWvht0GIp//ACmJLxxJClO
	LoMvgNWigpouEP/TpW69Z0E1FGgWtxk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ml42hJBd;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JO8zvszsozs4GkpHmyopZ7vErLCjHtSqmQPyVsRODfA=;
	b=XjOAvhWNWoEn/OMWIdri2QFssKmO2y0S8eK3F/OVdGwrHKXo/B82AJWY1A3MQuo9eKuf0f
	Vx9VwpS9IIIn522ynEBvydjkpMCNgS65zeEbcrFJthamahhQue71TPxPsYr3H63E0EAqS9
	Qu7htnq9wsiyYctW7Xpql2piLqAGfWs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D27543BD4;
	Wed, 16 Sep 2026 12:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1C71F00899;
	Wed, 16 Sep 2026 12:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560232;
	bh=JO8zvszsozs4GkpHmyopZ7vErLCjHtSqmQPyVsRODfA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ml42hJBdAQr2V10Uh2pmfR0pjHqFBHJj6PovDXwc8vewjqQGxlDhnIsDti0bpmfWy
	 qbcEynQD9O5UPH8qDpVSiyp7gR8W5fD10rfET67Dt1I/887weT9JoDXcW6ztZHOMEA
	 ZnS1R2vaQy2Z28heQ7hU6pB0wdeEqqPFKA+36oh8IGv5aULa5t9GvmzW0BcXls50mf
	 gHCOUdOBZkRK7++WyPFy2Gu0KrWQE2KlgRTn/hLip7vZ0s8+rwdaIHZa1np+GSIGud
	 xPUIUvIaOq7dEUBXw/UbQtzvvTCmX64FMucBy98Id0Aj2ELEnBk1BjrIOtK/qJjvgq
	 32Fq2RNvXUMIg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 16 Sep 2026 15:03:18 +0300
Subject: [PATCH v3 11/13] s390/qdio_setup: Use kmalloc() for the storage
 list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-s390-cio-ready-v3-11-39e4894637d6@kernel.org>
References: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
In-Reply-To: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F1614C001C
X-Rspam-User: 
X-Stat-Signature: s8sbfsfcyhnty6hmnt55m8osbjzjabx5
X-HE-Tag: 1789560232-680343
X-HE-Meta: U2FsdGVkX1/V9C2q+CmROMhIek0Ft8OLTQfwq/4/6Zg/ry1As5wlU/dTlaf+QPh4cRsgZNI8rdclebtAfoYqagAbUL7p71Fi6LcSg0tO0qGJ3g43zuROQt1CZXI3MVU+Og8RDXgGOqwcAgs89gcPlinVZbEFb+imZNjXvoQNPlqO/JOgxQNyh7E6lsRJ5eVV5vuYU0uxbxn8Lp0y4Jv3RBSo/Hj2aZZh3qms432PFs+tkak5h+3ntBtbDBjq2s2VPg2CmJGC+4Izezj9aJmbukBh4M1UYchpelW/xHGor9alT2SjuLHYCAhe4D0gD7/hhTiws3YcX4Sts9U3eVNMJVXmPm9uO4+B2SkaPvv11Bd4uiERFlj7CJQ6RIcKSWp2jtFmyaHCLpiYfEU9Av3VrTT91igAmyRmo0v1Tq1bDNt1QL23DmDLU4gCQ4doHC3ImGLdtX47oH+VxVhQSEXff6YIYzma4mGSdhM/hWRh3csrbcFO3X8+Y05ajphwJaYwc2EWXKKZgEnk6xdbSdD4UEDW7uJiS/7PpdhdCX7E7tjOY4MLzrQlD0DR4Ntp0o/1yKZH7v5NftUZkBsySVw1+J6kmb//xhEfW0gsXzcs876jJWqpY9Tz0RiyMGB4vlfKXfmY4EoEO5cp/ggHEK+Hnu90hcacIqw3JPSsUQ5r3Gr1zD2dUaDstQxPoO1Iv9bSk4la6Qpob83G6IVA4wJWZLPLi5DtJAP1k3XOsshL8ow9+8vKwPyt8md0J8KR+rKTlhcYMXzprhLwj3449f8OcbmMflXiyoyy2Uy07I97d+jbny5Q31/oG+jZu2yTfxxln2gZX8CBBOv45bOQhB2XD4qm08mSQ6hHP/ensDBsE4OJXuFWCsN5ooijpQyZmFDofnbQFSK9Pt5lD1DldCNPq+KiiJUHPYv/K+Kz42r5pozDslnHnBYnccbVoYwOZLcZIVitaE/9R43pJ1EHjGy
 xMqkg4Bf
 lcXE9Q1PhMEKebG1mKe/2XvZZur27mdUqRuI3JoigMKsWj44jof5p7PE4wZF2ITzvyTZzkyy7zdhQdBIDPyezSSXPmqLqrTVmqZEwRDPP/nNzvimVMgXHdVM0crBrYDNLSF7hfRLxwXUc37y0z9QFKR+Mjdex74Z2wA1kUh5pkzX93SIWE+ZyLK73A3r2Mdze1EOjF9x2U1ZMkPb+WMtEEsXJVmyZCo7mRq/mT+3To3BbaalMrCHi6FVPnv9+OoQGqeUCB7Lkwu1VLx04Ei4bWQewAevpnPLmI7PZouj5FO62ZbpCvM1PfRo6k1E9KLeH+ol3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__qdio_allocate_qs() allocates the storage list information block of a
queue.

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/qdio_setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index b6f2ff202fe64..d8e9c0872d15d 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -83,7 +83,7 @@ static void __qdio_free_queues(struct qdio_q **queues, unsigned int count)
 
 	for (i = 0; i < count; i++) {
 		q = queues[i];
-		free_page((unsigned long)q->sl_page);
+		kfree(q->sl_page);
 		kmem_cache_free(qdio_q_cache, q);
 	}
 }
@@ -109,7 +109,7 @@ static int __qdio_allocate_qs(struct qdio_q **irq_ptr_qs, int nr_queues)
 			return -ENOMEM;
 		}
 
-		q->sl_page = (void *)__get_free_page(GFP_KERNEL);
+		q->sl_page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!q->sl_page) {
 			kmem_cache_free(qdio_q_cache, q);
 			__qdio_free_queues(irq_ptr_qs, i);

-- 
2.53.0


