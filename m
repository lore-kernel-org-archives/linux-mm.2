Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D11BCAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 20:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A85A28E000A; Thu, 11 Sep 2025 16:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35FF8E0001; Thu, 11 Sep 2025 16:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9737A8E000A; Thu, 11 Sep 2025 16:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 84C868E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:01:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EAA71DF2D9
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:01:27 +0000 (UTC)
X-FDA: 83878039014.21.8FDF438
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 660074000B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:01:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ewFZ9qag;
	spf=pass (imf12.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757620885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/U4YTn7fpmVQukBqbILryxn0c5nCuyfdigbDju2+Dzs=;
	b=NcPNywUb/mcMz0dc4q8CycUvhb8XjCYYUz7+cW+/pi5epbJXB1LMQcvjdhCxCy9aB7U5uP
	paN5fDX8J9q5m/vZ/IZFChXsrlK6ps6suDTiV6Jvw2VqPI4xdWSOONtMZASLBKsN7BEpW0
	8gSOzLXNFmfE23dEPUokhCJjDbH5TOk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ewFZ9qag;
	spf=pass (imf12.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757620885; a=rsa-sha256;
	cv=none;
	b=2AANttxF9LqrGyMri8nyek69kZtY4qnDEcCQA/oD/p/mQCvvrniQSfs8v1JDAznKP+nYqI
	pq4UiUpfsbjsm9D/2+ps/MsXXfNXX2ix37X8+o/8Mh6gqLV5BW2fYeAgrKU/3Zg6VWYlHk
	7KULlQBho00+um0dHKdXqn32W8Mins0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C08EE601DC;
	Thu, 11 Sep 2025 20:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD03C4CEF0;
	Thu, 11 Sep 2025 20:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757620884;
	bh=Qzr8/A76jVpLTPp7Q8t0kpdacUM2Z39JWFofjP91B14=;
	h=From:To:Cc:Subject:Date:From;
	b=ewFZ9qagCkWWOHKPaGk6FaTxU5ux9FIoq6PyNr8Fy6dPmX9Plw+T+vEF0IKs2Yk21
	 FwwZK3n1I1YgZ4ads7hk4DkckZABdgaO5XH36n/HGWnejFWMxAe/Mb9bnCgtDkPL6p
	 np1pp99COBJ126YsrmYi+16heXaWI2WG5aDeF5jOJN7RRrACiIcOmKPwoWTpIA+kyF
	 a62IfYq6Nsa/IoelpYUTHQRBJdRJPSI9ICwPOsYP9PVy4GqP1zq9qhg7jlJ3i1pDSD
	 VQ0syg/ISBnCURXztv8dh3/qAfsUzkRmaqahJOKEnwzmq3d5cdpm3KF+QpYDyja32y
	 5Z6xup9Vn60Gw==
From: Eric Biggers <ebiggers@kernel.org>
To: Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	kasan-dev@googlegroups.com
Cc: Dmitry Vyukov <dvyukov@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2] kmsan: Fix out-of-bounds access to shadow memory
Date: Thu, 11 Sep 2025 12:58:58 -0700
Message-ID: <20250911195858.394235-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 660074000B
X-Rspamd-Server: rspam05
X-Stat-Signature: 3zb45nryx3dthp361zn6613rhu9whatk
X-Rspam-User: 
X-HE-Tag: 1757620885-139014
X-HE-Meta: U2FsdGVkX1/MKYWh4ZPoc+gQgQXqQftC+ZtyIP4DkYycwa6sYD6D1i43LerwGRgKeGTtvojqnkGqhQ0jIntIyifCAjV79wsxCNz5WUObamXZi/Jf+0GlnK7T551Wwf0b4WcTWLvGY9fdv8L5VCZd7cexFu4fhhQwietxJ0XMA9Us+Y3AFy8gI/bhZ1XKyMJgyWmQehdXFmVQvBg8cgAWwWsXirPL913lWxnEeT6NCvWATi7JQN8BDUZmMd8FAUPTNzCkTCX6kUjr9n3BO7HBofKpb+OBqp6Ou7abHL+HDHbveDjlb+OEBhh97ypD8dgCqEQWWk88X8FgpoLbPqsZ6dzjSX4rC6KfoJ2NuxRW/2l+l8hpVfsSX+pY48GogmDhIu8iudaz8en9uzr4aJf3Vmwty/qHAgoxaAacjVpXjxbMGcixoAZfx2VhJr8Du7kb9JUEZiSXRZFctl/jI/bH1BODuqc6vX3QDF9xZSgaYj5NgRG+AUJxDm0cdONnmHlVsR1Jfc/zfimod+H1/QGnvQWQ0AJL1B8svX+xCdwTahEzR6LcHSgBXZJy2+Kr7Plg4y+nitoh7kjI1cyPRUxBrkGqMvK7ryJuNLB5J53+zn7PfwgJ5oBw4Yro6xgdMAXUtBaLwaZvobz2OuNXsOt/TeEFO7XyTNnDFxjpSs+1rOLkUYGK649DKLLL4RklGPNw84PGTgovscZXddHy+XiKuEeDiBrebz9vI2OA9hbklqUd+YbuOAb3z35FbPLqtYwSvZdJW+oMRGjB7B5NA/H+DIcZgh95uJIR4WdE4LLKtTxdlkxcnuQQzdX7LpMs1MXug0Y40vBxgmhVEsitwcETcgaAYiYHEaoR7eSf2n2Z/EGIHjE66n6KoDmXsSumddzq1TsMbvbqVo3NmreG2D9a3MlpjIKubQQoriJWO1M0RqGU96NoDswC2Cv6tY1jS0J8RZd6LfAkwNdFX3wb4qh
 jeUvA9rL
 VerMnsw32fmKy1ocAtJCmBDEymwZw+ahH7hdAVBVXPcLN6WPpJAXyknrfOjS17pqQFczwaMnmKA8KzLtxb3de4CNjdNKl6v1itesEZ3HrHv34nWoZ6YWCqr2s3F67DAKFwv4d7ysM09gQitC5UAvocU2Z6l7BaRo7EhQa4kKA905nmADqINFKNKm9wi3tYLB9WUCVk8YXFBTuJpHcmyyzxfVbqCuBGaj6V7XFiqKtKgzD6H4dshEEad3put+FjEc0efKvTH+GHYvEyAi78APp71uiAVdkFmv4NyLE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
kmsan_internal_set_shadow_origin():

    BUG: unable to handle page fault for address: ffffbc3840291000
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
    Oops: 0000 [#1] SMP NOPTI
    CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G                 N  6.17.0-rc3 #10 PREEMPT(voluntary)
    Tainted: [N]=TEST
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
    RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
    [...]
    Call Trace:
    <TASK>
    __msan_memset+0xee/0x1a0
    sha224_final+0x9e/0x350
    test_hash_buffer_overruns+0x46f/0x5f0
    ? kmsan_get_shadow_origin_ptr+0x46/0xa0
    ? __pfx_test_hash_buffer_overruns+0x10/0x10
    kunit_try_run_case+0x198/0xa00

This occurs when memset() is called on a buffer that is not 4-byte
aligned and extends to the end of a guard page, i.e. the next page is
unmapped.

The bug is that the loop at the end of
kmsan_internal_set_shadow_origin() accesses the wrong shadow memory
bytes when the address is not 4-byte aligned.  Since each 4 bytes are
associated with an origin, it rounds the address and size so that it can
access all the origins that contain the buffer.  However, when it checks
the corresponding shadow bytes for a particular origin, it incorrectly
uses the original unrounded shadow address.  This results in reads from
shadow memory beyond the end of the buffer's shadow memory, which
crashes when that memory is not mapped.

To fix this, correctly align the shadow address before accessing the 4
shadow bytes corresponding to each origin.

Fixes: 2ef3cec44c60 ("kmsan: do not wipe out origin when doing partial unpoisoning")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

v2: Added test case to kmsan_test.

 mm/kmsan/core.c       | 10 +++++++---
 mm/kmsan/kmsan_test.c | 16 ++++++++++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/mm/kmsan/core.c b/mm/kmsan/core.c
index 1ea711786c522..8bca7fece47f0 100644
--- a/mm/kmsan/core.c
+++ b/mm/kmsan/core.c
@@ -193,11 +193,12 @@ depot_stack_handle_t kmsan_internal_chain_origin(depot_stack_handle_t id)
 
 void kmsan_internal_set_shadow_origin(void *addr, size_t size, int b,
 				      u32 origin, bool checked)
 {
 	u64 address = (u64)addr;
-	u32 *shadow_start, *origin_start;
+	void *shadow_start;
+	u32 *aligned_shadow, *origin_start;
 	size_t pad = 0;
 
 	KMSAN_WARN_ON(!kmsan_metadata_is_contiguous(addr, size));
 	shadow_start = kmsan_get_metadata(addr, KMSAN_META_SHADOW);
 	if (!shadow_start) {
@@ -212,13 +213,16 @@ void kmsan_internal_set_shadow_origin(void *addr, size_t size, int b,
 		}
 		return;
 	}
 	__memset(shadow_start, b, size);
 
-	if (!IS_ALIGNED(address, KMSAN_ORIGIN_SIZE)) {
+	if (IS_ALIGNED(address, KMSAN_ORIGIN_SIZE)) {
+		aligned_shadow = shadow_start;
+	} else {
 		pad = address % KMSAN_ORIGIN_SIZE;
 		address -= pad;
+		aligned_shadow = shadow_start - pad;
 		size += pad;
 	}
 	size = ALIGN(size, KMSAN_ORIGIN_SIZE);
 	origin_start =
 		(u32 *)kmsan_get_metadata((void *)address, KMSAN_META_ORIGIN);
@@ -228,11 +232,11 @@ void kmsan_internal_set_shadow_origin(void *addr, size_t size, int b,
 	 * and unconditionally overwrite the old origin slot.
 	 * If the new origin is zero, overwrite the old origin slot iff the
 	 * corresponding shadow slot is zero.
 	 */
 	for (int i = 0; i < size / KMSAN_ORIGIN_SIZE; i++) {
-		if (origin || !shadow_start[i])
+		if (origin || !aligned_shadow[i])
 			origin_start[i] = origin;
 	}
 }
 
 struct page *kmsan_vmalloc_to_page_or_null(void *vaddr)
diff --git a/mm/kmsan/kmsan_test.c b/mm/kmsan/kmsan_test.c
index c6c5b2bbede0c..902ec48b1e3e6 100644
--- a/mm/kmsan/kmsan_test.c
+++ b/mm/kmsan/kmsan_test.c
@@ -554,10 +554,25 @@ static void test_memcpy_initialized_gap(struct kunit *test)
 
 DEFINE_TEST_MEMSETXX(16)
 DEFINE_TEST_MEMSETXX(32)
 DEFINE_TEST_MEMSETXX(64)
 
+/* Test case: ensure that KMSAN does not access shadow memory out of bounds. */
+static void test_memset_on_guarded_buffer(struct kunit *test)
+{
+	void *buf = vmalloc(PAGE_SIZE);
+
+	kunit_info(test,
+		   "memset() on ends of guarded buffer should not crash\n");
+
+	for (size_t size = 0; size <= 128; size++) {
+		memset(buf, 0xff, size);
+		memset(buf + PAGE_SIZE - size, 0xff, size);
+	}
+	vfree(buf);
+}
+
 static noinline void fibonacci(int *array, int size, int start)
 {
 	if (start < 2 || (start == size))
 		return;
 	array[start] = array[start - 1] + array[start - 2];
@@ -675,10 +690,11 @@ static struct kunit_case kmsan_test_cases[] = {
 	KUNIT_CASE(test_memcpy_aligned_to_unaligned),
 	KUNIT_CASE(test_memcpy_initialized_gap),
 	KUNIT_CASE(test_memset16),
 	KUNIT_CASE(test_memset32),
 	KUNIT_CASE(test_memset64),
+	KUNIT_CASE(test_memset_on_guarded_buffer),
 	KUNIT_CASE(test_long_origin_chain),
 	KUNIT_CASE(test_stackdepot_roundtrip),
 	KUNIT_CASE(test_unpoison_memory),
 	KUNIT_CASE(test_copy_from_kernel_nofault),
 	{},

base-commit: e59a039119c3ec241228adf12dca0dd4398104d0
-- 
2.51.0


