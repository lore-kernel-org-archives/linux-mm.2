Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C5BAC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83676B00B2; Wed, 16 Sep 2026 08:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A656B00B3; Wed, 16 Sep 2026 08:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3F96B00B4; Wed, 16 Sep 2026 08:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB3276B00B2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:03:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37E2D1406F6
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:39 +0000 (UTC)
X-FDA: 85219490958.16.AFA0DFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5FC2F2000A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="loxsFHy/";
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560217;
	b=X2VX7VWO3Zcoy+5HSdGur1z/SxLuKh/lcrhU4OtCdH52s9eNKgFC3hRKgAiTNebcbbOKLW
	zFl1X7QVo77yxr1Rbr4N5EpBxwSNWrTh+aVWAAOZZARrNFzJsfpFuwnmrQDXpnhMg0j46A
	85tJksVHX5jD0iLxl0AAjk7cFpggjrs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="loxsFHy/";
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kEZ6nz/JFEHq+6k02cM7QTBhs2+peJoyslzMnyOEfRs=;
	b=v8xefahcE9NgbolR47TTMwMgI5wmMHT6CAX+s9AtAyjlu0fQKWG1fjsHEp4Ezbu0+8e1Ir
	q0tUYFyseBckthTadfSBVdPuRvbsz+z20Qxfgn38VqJ95d8olZN2p9iVFdxpu71yftZ7QV
	gTsuhjLwrzYIYcBDvnQS+3Rl8ZLX/ns=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD59543BD4;
	Wed, 16 Sep 2026 12:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89ECF1F0089A;
	Wed, 16 Sep 2026 12:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560216;
	bh=kEZ6nz/JFEHq+6k02cM7QTBhs2+peJoyslzMnyOEfRs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=loxsFHy/1eGz0qgPCeXN17uzD1ptVS/Qxc+rDq4qznAMqIVmpl8x1bPXVz5v78gGp
	 E+G037KiAiF17UQYrBj1C+2W71dMxMfTyy3ALvNjsrgjwwAZVOz/P4Ro0Y+qG95ij7
	 itVTEszggQCYKVFrYbDdNc+Fn2YpsR2xhwG7rOxTFF5BJr6p8N/b6YBsqzobih9x4o
	 ie1WGvsiiiF/P+/HmzjazSjiCv/4ZTAmi83l0qCDxHJTCh/15Ar6X704M3PAE8D6E6
	 0MEg+Pw6SzS2yKFpJWlhEqeuu1UG8qyjCVIquA4Dv3BgNvN5XgcddFG5N7Y2muRF7P
	 iu+6kR7AqO/lw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 16 Sep 2026 15:03:13 +0300
Subject: [PATCH v3 06/13] s390/cmf: Use kmalloc() for the CMB area
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-s390-cio-ready-v3-6-39e4894637d6@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5FC2F2000A
X-Stat-Signature: gpcn7ftufp99oupondf974zuz5d5rsxe
X-HE-Tag: 1789560217-53169
X-HE-Meta: U2FsdGVkX189KBCwjpL7UsjVRHewmSYWIrP1JMmZjCkS5GZY6QvmRBA+5Sxt5O3bXZdwoGXxNN7VZzOLdzthcn7/ebPKGk0Jf+6EtyFe54/QI8IqutEauhtztKPtkinhW37ZoxwVSv0Ddt0YuKHfYXSDa6R4BFCux7crrBQhUrhMHQBPs6YhsWSh+Qjl+Ibqp37mLl2KvvL/BHq8tihc/6eWJOR1+RFdb1TQqsYV9jCaEKEO7Yan9lpTppNIdfHLlf4CfK1dh3SaULxg2rDkqG9WMFZYYeJeAN2fKGZf/Qi+rnGaCxhTuMQNRX/sgucPbElbOHwYCVre2OM+Qu91P6CChAIBYCKhSsrU0rQTghs31XDindo4mrzpSMpMg1I49GU9LzTAwwdcRKguvMc10nAvMb6G6vVOSNVmFKfTA9Q4pZvQGNe9NhPdoPyrGMp93GgZKZbATUkQVa4FZFXdO6UsZXldpMcQxwspGEMvqQVGEZFWSyHF9l/Gd3UhGudXGJhTonnTriOI3kUQ6Pt/TfRVskZIrGIAF+tX53ARxLfjzTQsL9F9/Q5xNT/mSJqPMldjp1pxYUYJybUmW6TpdlUft4G7U7b4L4Uh5EKVnYuybQWY7AHTeKmtKyIHfEn/UoHzc5ZNH7+c5RGmx38LQ9mjZikdc4WIdyijAvQuJ+KAsdmD8Xmi94gCnG7gawdhLWznN+uoj6ZtXtbvMp6QEmjIHvIjrL+DfiDVVE00X6fY9rUqFcsxPp26rj7M0+d6gyxaTTblT/CIWtyBeLNsEyHiWsItWXkXdNPF/qKlBqXi431gpboCLd7V8qz5KuNhLhx9BUG3g0v6DbGW9N5REsa6/sEAoz7h2M34HasXD1p5YIGxGGBwb5kIhUhvHGGkL8qJJFr4JCxOQNV6gWGuFT/LBf3kYhKmSPcmWC05qxV7b4H8h9AwBiMj1AVax6tqDtVyNpxB01ZD12Z09MJ
 rNLAwD9S
 nJPbIXQUGkY36kwGflt/FY7eQH0BGxVAAahVmfjz8mHqXom6ThsPz6tR0VaSudaQoSbFeF5LLfO0ELsDvJ7VSxk7QCn/7AnY3L2CK8Yb70FUCJloRA33Qpgg1sOuL+9QYb7j1XVUFHP3msPkPumC4N6+zq7mDp4vIHbkhXl+EeSjzCCXzld4ufIseHMArJTx8h16p1A9wBhxECTa8bbQunzG3SF7EOu3Dj69aNp6IuCtE76V7+6AooQ3UzHFmcQkXabI2V+AsvkMcJHY=
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


