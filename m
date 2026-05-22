Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 298AFCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 571146B0093; Fri, 22 May 2026 09:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509416B0098; Fri, 22 May 2026 09:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4461E6B0099; Fri, 22 May 2026 09:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 347AC6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:15:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88FF314087F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:15:35 +0000 (UTC)
X-FDA: 84795102630.03.61A0100
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9C9C240005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:15:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=txzCGNSz;
	spf=pass (imf11.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779455733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=F+ecG0X94+FeO8dSnkv4AZz+6bKXxGyiG/aKDMvQzjg=;
	b=FbRAE/t2NUWgyzmis0U9heegDlWrQYUpSHVVJ42LukmKCw9jjCxl3WG3eUSGmDahlNMdUe
	f9RFdrzlHwdTAHxceZBLtBPEufEESuMFdhJd8cg8q+r8jkDNy/N4cteBe+b3x4BwDRvagS
	hrq30NYaGUw1D5Rh/+BFRGHxoQSwsDI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=txzCGNSz;
	spf=pass (imf11.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779455733; a=rsa-sha256;
	cv=none;
	b=bjjAPoDQ56gO2oSjIAwhF/6SKvFqwbCgvAsnDEuKSbSuZJwckyyZv9+BJ6W0l/Tqfk1g3e
	p15MvvLLGI5LtaiRqRTbKWrGC1aSPbcSDDr6gKzvd9uK4JyCgS6nCNck8d2ZvoFxK875zI
	mplS6cv+ohOxQ1cwnWd1vFfRERqCbjw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779455731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=F+ecG0X94+FeO8dSnkv4AZz+6bKXxGyiG/aKDMvQzjg=;
	b=txzCGNSzXs/jXl8Ju7ZzwPkZ02mk5yPUjn6VMMJQn2dISDpR5LEDcnpAuv2phqU0Nv3n0j
	/pdijzPUrc0bU4zHLQDL7AXqH4i7rSaBB80MbgaU6nV56vvVUbRTpBw7OzKQzHM7ZUMhmu
	x+6mXDY9IxYM3pNx+52QddBplwUdokw=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: minchan@kernel.org,
	digetx@gmail.com,
	jhubbard@nvidia.com,
	gregkh@linuxfoundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm/cma_sysfs: Skip inactive CMA areas in sysfs
Date: Fri, 22 May 2026 21:14:34 +0800
Message-ID: <20260522131434.78532-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9C9C240005
X-Stat-Signature: tsgq5gfjetz4dhbzrn3ozne3rqnoh89f
X-HE-Tag: 1779455733-396720
X-HE-Meta: U2FsdGVkX1+1lSWAeIPElWsuYB8UpisA/nZCwOEnm4pCIc3DTDiqpCRtdbzg/mlzK6JYLz/8VGJ44Ojhemns40ehSj1k1boNrB8/xeoS1lpRugldtO7g3zZFpVhqhs94HN7Yj1qvbsywKYqW0oEfBerW23yXW0XJ6dxKeWRU2p4YxXNYY0Z4SrnnWwKY5qB/IkL4Qx5g/X9k87o1d9ZMd+Mf0PPYDCYY6nKWQOaGaMaMVwH4IkUWMbcwo6I25sqBPnCvkxDk4SqoXOPot0r7tRb9JSZbgd+bRhzbCXLx3EVtbS9TAg6IOzfGwOMHQTj2PbpnQRpQDvWO12Rq6gr01udFyTfiU4LEPoqX8REQ99fKmKYFFOHV7GbMWFT0q7eZwpqEUaZ9uddPOUxro3RwRnfdgZP5qmu/5dVAzyG8kcSmKAXc5aLR1EYaljNjNgOIXrDad7TKTtNlimLzCD9TrzvlXJdYYFednNUPHNdvZQ+sirdU/N5ZGhPq2SjfZnly1b68jVvhyqADni7GuNQR8cgx2pdvViMhaLAWvU7e6Kq8RO4KuWhclPKBDCb7kbZyeDjGBUbh4Co3UO2xY37wDW/87qQqz8C8jV2nzf3UA0ycLOJTv/CxRBQS/yjNkV2/7VowS3ioGhmtoKuEglxYUUaiFJtc57okqwHiX4mKIO3TTLYspYwaHyaHF9RxcYZPGQi9Yb5ln/C7TD9v8DOuCWkE1Rz0mObvA5jHc09FpFI7ohWmiGFFPL3K8D+3oVma6JlyXJOkb0fvIHQp1JD1r0S+6bQDWqJXzCY4E4dibJkRew1Lb2qkl3gcg4lA121BVuCpmU/RHDxasATdXb6AEW6gVwGl/F6uSerH57VO9jbbP/IW7erP8T6EN+QpgchySuO7Rr6fC4PrLChCuU84UA+bHQQrhXCXicM3UORskZKBA2g8i7mOXvAvBrudrjzMC5AprwBkw7duwnRvHg6
 9yojBZXP
 AmeYfcS/vDwBGSwr9HkzfaCbvSWSVxQoNa8h5UFH1EaJI6lEs5RKBMj81/OwRs6A8Mtn3Ano0VMk/LfjaaI8w+ZSBM4YrkJ/PUlcOU+i6ZqSCoepcvOxg0VSRq+dzgnU8elIBYauBDG0Y7RXRFt/MiDFeaQeOdN/3fz+jGYaFzlA/GeooYhRc6Ws0fo0VfO2lYuRfLKnm1dqgjyaxQH/0VVoljwOXDcQTR0jyQDPGOLaWMXIZ0nymmEOvmYXIaU0eWeIC4xI978sO57FSfJxWiv87Ca+zskoRgMtrQmA1dviLcuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

cma_activate_area() can fail after a CMA area has already been added to
cma_areas[].  In that case the area is left in the global array, but it
does not reach the point where CMA_ACTIVATED is set.

cma_sysfs_init() currently walks all cma_area_count entries and creates
sysfs files for every area, including ones that failed activation.  These
areas are not usable CMA areas and should not be exposed to userspace as
valid CMA regions.

Skip CMA areas that did not reach CMA_ACTIVATED when creating the sysfs
objects.  Since inactive entries can now be skipped, make the error
unwind tolerate entries that never had cma_kobj initialized.

Fixes: 43ca106fa8ec ("mm: cma: support sysfs")
Reported-by: David Hildenbrand (Arm) <david@kernel.org>
Reported-by: Muchun Song <songmuchun@bytedance.com>
Closes: https://lore.kernel.org/linux-mm/55481a8b-dcfc-4bef-ba59-aa0b43dca88b@kernel.org/
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/cma_sysfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/cma_sysfs.c b/mm/cma_sysfs.c
index f52b696bc46d..d5bf792c6245 100644
--- a/mm/cma_sysfs.c
+++ b/mm/cma_sysfs.c
@@ -117,13 +117,16 @@ static int __init cma_sysfs_init(void)
 		return -ENOMEM;
 
 	for (i = 0; i < cma_area_count; i++) {
+		cma = &cma_areas[i];
+		if (!test_bit(CMA_ACTIVATED, &cma->flags))
+			continue;
+
 		cma_kobj = kzalloc_obj(*cma_kobj);
 		if (!cma_kobj) {
 			err = -ENOMEM;
 			goto out;
 		}
 
-		cma = &cma_areas[i];
 		cma->cma_kobj = cma_kobj;
 		cma_kobj->cma = cma;
 		err = kobject_init_and_add(&cma_kobj->kobj, &cma_ktype,
@@ -138,7 +141,8 @@ static int __init cma_sysfs_init(void)
 out:
 	while (--i >= 0) {
 		cma = &cma_areas[i];
-		kobject_put(&cma->cma_kobj->kobj);
+		if (cma->cma_kobj)
+			kobject_put(&cma->cma_kobj->kobj);
 	}
 	kobject_put(cma_kobj_root);
 
-- 
2.50.1 (Apple Git-155)


