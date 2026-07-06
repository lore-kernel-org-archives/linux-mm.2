Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48286C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 341406B00A1; Mon,  6 Jul 2026 07:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318726B00A2; Mon,  6 Jul 2026 07:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D436B00A3; Mon,  6 Jul 2026 07:44:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA8526B00A1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:44:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79EA5140392
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:44:01 +0000 (UTC)
X-FDA: 84958167882.04.169A412
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id BB95A40005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:43:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f22GEhXg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783338239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5TFw0gU1rn6tLxDQ8mBtqEUuGJ9pKHatkm4r6fL5Jdc=;
	b=r8cEXN3j+yIlIpApmVeQ0xRS1Xd+x8ytpOYeUDwPYYDw1T8rsiOSz4Acrab3pcfm+rla5U
	nKg/qdhxJRg+IAFJVHQ8BhJRQ9AvCMGY4lVXNuGUYtfNlJr1dkCTH/j44vbSxOQlu7fvmS
	d4zaiYk80wAcHCd+WsTODJo1buEoplk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f22GEhXg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783338240;
	b=T0f2Dm5hTvnuKmzpeHldnKBbody2KALN4BdVC0ST5IYo5gm+wcKZX+zubVoBY5UkcNaqw0
	QE1KIxoBFqhPFogAzsEgX4kmvq5KBDGUQLGdVMrjUWV4fl/RaNbqtepOH/t8+3qIiVQqLl
	piafAVjtxDS6V7jfYgwvBRec7madyzk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783338238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5TFw0gU1rn6tLxDQ8mBtqEUuGJ9pKHatkm4r6fL5Jdc=;
	b=f22GEhXge9OTzVk6yrelxk+myUj2VpVV/pEFZqawjxneUFVJvTUQigT06NAzmQfVa2N6hX
	2xYjzCPALPlwm7p0A/pXNMH+kXw+NcXe957K5daLYo6+7UjSlV0braT+FtVo8zT/Ivi2Lw
	h6R39yepwxF0TaoEo9/BMFu8RJ28vdk=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 5/6] mm/migrate_device: move softleaf_to_folio() inside device-private branch
Date: Mon,  6 Jul 2026 04:42:07 -0700
Message-ID: <20260706114320.1643046-6-usama.arif@linux.dev>
In-Reply-To: <20260706114320.1643046-1-usama.arif@linux.dev>
References: <20260706114320.1643046-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BB95A40005
X-Stat-Signature: 7bd1max8bfkigngx3xn7jttiq8yhkdhn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783338239-884216
X-HE-Meta: U2FsdGVkX1905BNHum3WL7+sdGgvnCvMnKyHJbTaOkGHLekAMbo4H+fz6en6YpMsNSJm74sbf2AvxtuTJo+Iq4lYWJ0M0RhufJTN/ZrkXmTCt3z8fDgzfK2F2+SKcHUE8iBL7ZnOVtkf0nkVkqTXDxw7w/RYQE+FW5nA264U4kwmqmCtbg+j2e1zZpMX43LCqMqh8bTFNNeamY7rN+Sr+qSJh0bzftQ7dUyzads3M6Y/FUlgsCK4fwhQt9Ew3dqURO/p4MdLwi+0S4qSCju14rIVfB8lYjd4DYddOMxZ3D3sKqmJOeWgm3F8RTHrem83oNLdP2JK55Tb5XkS0B3iVQURNJnvhxbxFLR2ew64BO6UvspGvEDkdovAsWfZRAS28uuYPXw28mkGBdRsIgjh+4tZVNt6VVHLi3HcZ8i6Q+g8jf3SVoUxCq4ZLVhmcBoRcOOfLO9I7qMrTi3HW9UUiW/+IZ3y1ND5/9oYZYUwdHL1dPz9wZyEv+x+HmW+yFOlvbHeknVOywqFXWb4rgrYFesxPHaA5RW8OuY7kaKCryHvqcI5qFzcsKdejzLbGhjZe7ALKCG2gYIO4GWLnlSM1s6IvSFUpPU8wxsQsn7lz0k3hv7y2PaVdH4x0oJZweVLPs3vWCFQRIM91IVnjPd//6nhDIRfo/c2L6ENoFPGXo3r3Ld74bx6AhEK+gcd7Q2oKU8acvn9H4tgNZ7ygqd6ihQWFiBJP3WsdPX1CIeR9hGG104PKh9nE6fU3DvaaZRHsV1yIeI7OxHlZBtpOhY2qBPmNyUL23AZA7kUFyxWFNuiAqYPIwszRz8wtapdlha4fqqF/7PiCqxgGgMp5Zc6GgDDPH/scsKslnl5xyvM9RVRL6Oh6P8/e4nJQUv/RxlInJ8InCzfOWKgMiJ3jof/hdyIEqARq05aR/gNjwm6zgWoN0S/Y4oAZxiCpd7iaVIiNy8hKGnIGo1C1Q16gNZ
 9/DyjpoU
 Hfmp+LF/qWTult5Ch5+rE4Csm4f3xPaP+Bp4TpExOUwZPdc3VN4xAH7scIoOwaCeSGJko+yF57VNftU4QWFc//TSTaHdKoa7Qh2t9kupFNpiZxn/p6SnkMuerK6rFCbN/UyJlkIq7EfKB/4LOAY94aB5HraVMqtp5gbQWtuSJ6/poRsZWp/3QN01ZEYmwDdA6C3Y0HQwMstCfNB8GAqojV50JJt7rXljvyuDGFOdi1Sqkxdg8BdZWSiHda6SKIBRBZaHV0g3Wj/m+dU7C71RVdVLSAwE8xDc5yPXfdXsA6AdCcFY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_vma_collect_pmd() calls softleaf_to_folio() on a non-present
PMD before checking the entry's type.  softleaf_to_folio() converts
the entry's offset to a PFN, which is only meaningful for migration
or device-private entries.

A PMD swap entry's offset is a swap offset, not a PFN, so the
lookup would either return a bogus folio pointer or trip pfn_to_page
validation on a debug kernel.  In the non-device-private path the
returned folio is then unused (the OR short-circuits to
migrate_vma_collect_skip()), but the lookup itself is already
unsafe.

Move the softleaf_to_folio() call inside the device-private branch
where the folio is actually needed, mirroring the equivalent
change_non_present_huge_pmd() fix.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/migrate_device.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index aa948db49501..36287e958b2a 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -166,11 +166,14 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 	} else if (!pmd_present(*pmdp)) {
 		const softleaf_t entry = softleaf_from_pmd(*pmdp);
 
-		folio = softleaf_to_folio(entry);
-
 		if (!softleaf_is_device_private(entry) ||
-			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
-			(folio->pgmap->owner != migrate->pgmap_owner)) {
+		    !(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE)) {
+			spin_unlock(ptl);
+			return migrate_vma_collect_skip(start, end, walk);
+		}
+
+		folio = softleaf_to_folio(entry);
+		if (folio->pgmap->owner != migrate->pgmap_owner) {
 			spin_unlock(ptl);
 			return migrate_vma_collect_skip(start, end, walk);
 		}
-- 
2.53.0-Meta


