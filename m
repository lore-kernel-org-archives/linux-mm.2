Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FBA5C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 809A16B00A9; Wed, 12 Aug 2026 04:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794B16B00AA; Wed, 12 Aug 2026 04:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6826B6B00AF; Wed, 12 Aug 2026 04:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 447196B00A9
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:17:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF04916033F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:17:48 +0000 (UTC)
X-FDA: 85091913816.10.6D2430E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0F902180003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:17:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jlrI6VGT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786522667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rUPKq19ute4e/df9ITifTzrOJePqrUKcOigGJrc6Xv4=;
	b=dvy3jDlPs8Tu79OdF1u1nOL6GvLLz5B6/Pg0OEOTjsmBhQlQqy9T5Xs3ImUIQpVkd7M5rz
	5xqj8b9qo3Y1DfMsKvFozBUjdKZkoh0bQ6Gd0L+0VvJ5UGpXTzKJrn5Z8YtG5nzWGMMBUq
	3BbmpI9tGT5x3FIEF2P9Vm1C6QjEnBM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jlrI6VGT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786522667;
	b=I0/q1UzGkeSb4GY3yXEwF1KVbGTOtvchariSyv8Nf8KbIR5cgwm9U/Y8rS3L8o5ZDEi6nW
	FUkQLzegIEHjYvHlgLbxB4HGfedUfZPEeuJA7K5otMVulI3VI7Qe6gG/VyMmtEGkkpO4hP
	pZ6X3As0suQZFYWUyZ+YzMpkz+tUsZk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D8B4243FFD;
	Wed, 12 Aug 2026 08:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC57C1F00A3A;
	Wed, 12 Aug 2026 08:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786522665;
	bh=rUPKq19ute4e/df9ITifTzrOJePqrUKcOigGJrc6Xv4=;
	h=From:Date:Subject:To:Cc;
	b=jlrI6VGTznU6HDN4gGZLQRdHLaTVS+lRv3AYOoJ5HFdlC9BkzAFxkiVC/LXYs6Nf+
	 qHSSZY+Bh8HwtwWJIbykKRfCx9lEPEslje6v7NYdIDwzItNMuy5xqy+ySQYq87K8Vx
	 CJ03Xz+5+XRV8cV8WoYZZc1keHW5ojKGAA0vCl4cTN5juOP1PJln4L5z8ud362oPl4
	 EdS7BXA2ALfdxXa1eQXW3IRQSKzw1Y0O9ZxS2v8hQCJnTIgUdZH6vV4dEaEsMl82pk
	 MGbjU7GHrQu2NEyhR4q8CVu8mMC4vbQzdWTXGkY7KRAuingOuKed0NFV/nQuhO5Lxz
	 +pSg/C4lSa+0w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 12 Aug 2026 11:17:40 +0300
Subject: [PATCH v2] selftests/mm: thuge-gen: fix test_shmget() for
 PAGE_SIZE check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-selftests-thuge-gen-fix-v2-1-9adaa693e73b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WOQQ7CIBREr2JYi9LWVuvKe5gugH4KWsDwaaNpe
 nehHsD81ZuZP5mFIAQDSK67hQSYDRrvEpT7HZGauwGo6ROTkpUNu7CWIowqAkakUU/JHsBRZd6
 05pLVqm4qdpYkfb8CJHlrvnc/xkk8QMZclxOCI1ARuJM6S9b6aI/W0slh5GKEnNEGow+fbd5c5
 K7/S+aCpmuLVp1E1Reluj0hOBgPPgykW9f1C6P/eDv1AAAA
X-Change-ID: 20260809-selftests-thuge-gen-fix-5ac05f56307c
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Sarthak Sharma <sarthak.sharma@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Stat-Signature: 7t7suamaw67qmn88ztq8wq6xn9quw9bf
X-Rspamd-Queue-Id: 0F902180003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786522666-157423
X-HE-Meta: U2FsdGVkX1+JwFvGwSH/tYjTDuMs+pWHSR/3Yu6cVGL5O6+2BZRYOq2EHItX/V46in/Nz9pv3eTT242HdLvhc0JVO3fymVKCEMii9OHghPWwdeKBgmBuNuFE1I9VZjG+PDfcufvu33ChWOf44e6h/BeeH39oERRcA0y0bhhPOZNXa42TFpgcnN+sMzSsvrsqt8pnCBDlBbjeDDkzIUMTiwAgHkMJXsB4860AX/76L0jJwu71OfuMbE2c3SuVzhoG6XqAv5Jp7UNxfStOEGPvDIR35OVeBQCk3H8usy0RMQfuc0KT8XLrG3bLnHgm6vCAea3rD+qJi8NOMhkggVGB560WbnwCBNxLR7B0bP99+2Scy/CDxQbl6zHEH/n9r2tsnZygXxNafG4RKdl2BJil/VNxhB+jJt4/Fk+X8uuh1MwDtH9FO3nQfUYPqW14DE46nRl9nD4Gdz9lmprvxqo/F/4B3rrqBD9a1jMZLwWa9n4fkV/2WWRPTxzpQRYUwWOjOUtb0OpEVWbUTKIuF7eZ2ktMDryT6am6p98HXXSGv945dgwbDOJ7glLr4+NoGROgwcGfbkEYOlXE2LlNB0VCp2GJktQ9lAzVeDDdpRsFHG9PEqenLTez37iOJNhIC3ipOTaPlQfTo+uVPZhlWu68Vz1hZ6VgBsUiYimF6ehV3MPjArvcwL5Ig5zJ2fLTglMFTQ9t4UdVreprf6+eK4tFLf8kFZefV1itxe0IF7poZt9YwXfF5UiCGrQSdi9Zkg2nUbL0M0/yueZFCcM/oXxq4W2fpXx3zE3oqES+UyKDbLyhk1yH+SGLoJtv4nFg8jCfTNQNPUGwhjF5b3Lr3xrG5hA9VrWwUCWVzl1BOC1SnBfL7Xr4XfvlZPCOCd6YLYnwGDmAdNV9FVSJnQVFOdVfYzBEyUE6oxU2B+jHO3DfSIfDzUgQ3O0kGUIgKIVK3y7s7s9YD+08lCFUy+YQQwa
 6WnOgBIb
 DwjvFt8yYeBRy8SMHbnagqJhPcrK6joKNhLqIB1H0cc7bNPPeceW+mKvCzbOD/I5CirHQ6gWYAH7AJW0tY44b0LebebYE32t/IG1zNA56z9MqpfbP7kqoC15t0/rs3VJaaMPQqVjot9TI0M5z0OAfDSCQzpY/1LsUS0ZE8QFJI1frZsfw0ulOYmoQoO5C7LRclEYZXMOm7+9p7DupIWA2slL6z1CZ4R8hoiKtUl5qYNL66nFfa7RsfVqUYPGyWf9SsQlqNRNaEtyZHdC2RKh7UeNBXE825/2lucclam7MQS38ZgqpF/bTWivueyVazqAd+20Db9OMQdCzePdfj7GWCYSIn8tU8Tu0wvnySF0ZuewBlP0U9qldul3IDHJ3p2AET78OpZ4lbZ+y5cfZ8hCNEkfaBZomGyLJPBowBOPBptjBJbH2v0rd5MWEpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB pages")
changed thuge-gen test to use common functions for reading hugetlb
attributes from sysfs, but it missed that the original read_free() function
special cased PAGE_SIZE tests.

For PAGE_SIZE tests, failure to read sysfs was ignored and read_free()
returned 0.

This allowed test_shmget() to essentially skip the check of how many huge
pages was consumed when it ran with PAGE_SIZE.

Commit 3199b0c09efa ("selftests/mm: fix read_file() return value check")
fixed checks for read_file() return value and this exposed the issue in
test_shmget() that checks the number of free hugetlb pages even for
PAGE_SIZE test, tries to access

/sys/kernel/mm/hugepages/hugepages-<PAGE_SIZE>/free_hugepages

and obviously fails there.

Gate the checks for free huge pages on size != getpagesize() and initialize
before and after variables to values matching PAGE_SIZE test.

Fixes: 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB pages")
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2 changes:
* Correct the commit message

v1: https://patch.msgid.link/20260809-selftests-thuge-gen-fix-v1-1-1919f4b3d12f@kernel.org
---
 tools/testing/selftests/mm/thuge-gen.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/thuge-gen.c b/tools/testing/selftests/mm/thuge-gen.c
index 22b9c2f1c35d..50d0805b65db 100644
--- a/tools/testing/selftests/mm/thuge-gen.c
+++ b/tools/testing/selftests/mm/thuge-gen.c
@@ -71,12 +71,16 @@ void test_mmap(unsigned long size, unsigned flags)
 
 void test_shmget(unsigned long size, unsigned flags)
 {
-	int id;
-	unsigned long before, after;
+	/* values for PAGE_SIZE test */
+	unsigned long before = NUM_PAGES;
+	unsigned long after = 0;
 	struct shm_info i;
 	char *map;
+	int id;
+
+	if (size != getpagesize())
+		before = hugetlb_free_pages(size);
 
-	before = hugetlb_free_pages(size);
 	id = shmget(IPC_PRIVATE, size * NUM_PAGES, IPC_CREAT|0600|flags);
 	if (id < 0) {
 		if (errno == EPERM) {
@@ -97,10 +101,11 @@ void test_shmget(unsigned long size, unsigned flags)
 	shmctl(id, IPC_RMID, NULL);
 
 	memset(map, 0xff, size*NUM_PAGES);
-	after = hugetlb_free_pages(size);
+	if (size != getpagesize())
+		after = hugetlb_free_pages(size);
 
 	show(size);
-	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
+	ksft_test_result((before - after) == NUM_PAGES,
 			 "%s: mmap %lu %x\n", __func__, size, flags);
 	if (shmdt(map))
 		ksft_exit_fail_msg("%s: shmdt: %s\n", __func__, strerror(errno));

---
base-commit: 17e5919bdca144d4e67337f53bf57d7811f62192
change-id: 20260809-selftests-thuge-gen-fix-5ac05f56307c

--
Sincerely yours,
Mike.


