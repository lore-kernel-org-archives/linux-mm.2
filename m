Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04190CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 10:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6048A6B0005; Thu, 11 Jun 2026 06:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DBD86B0088; Thu, 11 Jun 2026 06:02:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CABF6B008C; Thu, 11 Jun 2026 06:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D08A6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:02:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D52D41C226D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:02:03 +0000 (UTC)
X-FDA: 84867190926.19.4D40ADE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4A33B40010
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:02:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cxkPnPGR;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781172122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7UQfP1YxizekUK5kBwNkIE8MO8+eXgLAl0KPnDKl73Q=;
	b=hTtia7KY8xFTPdaKOEjY6s1V95nITV3BKPvS05nHAGYQOS0XnIeJtSrJDrYpYQ5dKBzkx7
	t7sL8VbUkyygcS66ebA1jgxIrczth6iCZ47fRTYWgrX6qABVb136TLe2V5Pvxh3KLVrn/N
	p9Af4UFTkdygzqxFIRSCrpeBN3d+R7U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cxkPnPGR;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781172122;
	b=ZxoidxMFRNZQjvpcQu8yrFzYrROz+NVvwZIcoy3j88FCiiFtK2yWEZWxhfgEe4lv0jnWf+
	0g1DgXRlBcr2rdSyuUVg/nB2CmT3f/2KkYf/+Is6UeGGHD06umWJfJDO2FMVzhtM3vQ32F
	fqiNAFh5r0WsBGT6EhM86VvQ/OiBzE4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ACC6D6001D;
	Thu, 11 Jun 2026 10:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8706D1F00893;
	Thu, 11 Jun 2026 10:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781172121;
	bh=7UQfP1YxizekUK5kBwNkIE8MO8+eXgLAl0KPnDKl73Q=;
	h=From:Date:Subject:To:Cc;
	b=cxkPnPGREf1vKQgkfjyrjPLaAePUQaLKLGYnyakzhJ13F0NoKNU/qv1sIbTW2albR
	 ecgmCAjsGMX2bVwzhXmgx1IMUh0hZuLT7tMHeoq5RaOYh9qBgc+7Oh7tZ5OonLQ3+T
	 UJ+JuiPxtLJkYlM3AyKvF6qaSAfg/ChHS4qlhX0zMDghQk3w3Kp3EE5kTcpdwjwJ30
	 pGVi3VnTmRV86EMuP904eSV+rjwLrJn+wSK4B6pPK/VbzC7y/nRAeNY8LnXnx1LEvF
	 xP2kbPnUOUIeXCdMy275ZOlSWpqZg/8acHrQO7xt1Ey561BF75PWNXpmNqPrtj8haH
	 2EhWbl7F0K9gg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 11 Jun 2026 12:01:55 +0200
Subject: [PATCH] selftests: mm: fix and speedup "droppable" test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJKHKmoC/x3MQQqAIBBA0avIrBNSIamrRITmVAOhohJBePek5
 Vv8/0LGRJhhYi8kvClT8A2iY7Cdxh/IyTWD7OXQD0Jwl0KMxl64FsyFK620dXoUbrfQophwp+c
 fzkutHx5EE79gAAAA
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
 Anthony Yznaga <anthony.yznaga@oracle.com>, Mark Brown <broonie@kernel.org>, 
 Sarthak Sharma <sarthak.sharma@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Aishwarya TCV <Aishwarya.TCV@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4A33B40010
X-Stat-Signature: egtpusapu5g454nh751wcxp7wf8sewpg
X-Rspam-User: 
X-HE-Tag: 1781172122-670683
X-HE-Meta: U2FsdGVkX19UqV6k9ZzVIok1V0gEfhEQEu6A2QDX2CSqnoX9KC7j25F+EnDofkwrdPhDDhXqlVb3aGE3Yj+gE7bO+MHwfj1SdJKRS9q7wWdYggu+6q+j98+u7PiWzs8Ws7LHUOdOlJRHJ2nXO1f4GGiNFT5f9Dpz+Wu7DCHkcLXembl/fbMfnEKh+2MfI1FdApRxswv7QJJ5+D3SqzygK50yqIr48Lt3yobxDqILrDmToSEfzMUj9R+alvDykgcbvb1lYNqsDNe+kf+1DjuvIr5Zj0SUW6n7H6uGqWeBOZDV8eUqRFIyHOsbJUgc+6SKISlCf9/fPn/809JZI/RbKGpVC51IRgtj704kxTBBBcR00DPhRHDAkuL2195HFez5Jcjr5m4rxKBmCPuFz6LrzKF6d8UbfQA1iJ1xVV2Vj3BdpJ51xbWaUSpHnqP2S9GdPZBAOPAB8R2by2t6cZVk7D3uauXK1329b8+tOru3XXZstwr6e/IZdfpnw/jaLi0vH1O3evMV/0c8uP5dBMtX8jLHsmKehAWF5CLTP9hy/KNrQp3tFnwzw+kj101j6Na+zksCAiZuWhhekRACmLdzY48DtHIdip82Gzt2TnrdMpXGoKAqvq5l2MY8zfdOK1JaTafUMGboy/O1nhL/g6ZCImZnWSWtNxlCqCq57aeoYfEHBnHk9akAF7qh6eBpigvrVcONqjLnwfKKqEPV/5zhSQ3dHB+BqBjUFQ1O55Z2Lf2Ng7ka9LB3WhdOobo8q+CjfctEXt3jElEoLqJGT1m+t3fAKuIo6dt+Hxlp9Icb4+fFsbMpxvClVuHCATWGwvBq9bAs+NsJOOza10qE2Awo/HuvndyfsoaBfhDqfRj1VrSk2XiEVYxCqXY+FaLG+4rrrSXMp5uX5gWoKKx+ppEaE8cigAVku8Kb7XmAEb/NAfvFHukWtEV/+IqrKeUd7YjDvjdrB/yVwVIXoZzhrY+
 YHMk/qOF
 zQyay9DlVwKBNIAXDIhTOr3OJEqtT/us9r99dUnNtvNWzJA3Acxh1u6trb8iFifZmrac9pZH2/sqKB1pzy0oQxkpHzy87v+95VOdliRVJO+d9kGso4DRQ7tO/tCt1hLJM6bOgxwy6pX/DARcXjxoJxnby2ePDDWAYx1/EX93Jfr2qXzdjlrUe4mCqm0Lbo/yU1JysDUDOi1p7ZQLCZJY6xXmfZ7kTnNUg2x5mw25v/YSAqmdllxeWMoJQiyGJRedOEyQexHnHd6yNaCIM+AdNG7AumYxbWYRRbBA6N77gEqd+2sEIcxqUc7/ltw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The droppable test currently relies on creating memory pressure in a
child process to trigger dropping the droppable pages.

That not only takes a long time on some machines (allocating and filling
all that memory), on large machines this will not work as we hardcode the
area size to 134217728 bytes.

... further, we rely on timeouts to detect that memory was not dropped,
which is really suboptimal.

Instead, let's just use MADV_PAGEOUT on a 2 MiB region. MADV_PAGEOUT works
with droppable memory even without swap.

There is the low chance of MADV_PAGEOUT failing to drop a page because
of speculative references. We'll wait 1s and retry 10 times to
rule that unlikely case out as best as we can.

On a machine without swap:

	$ ./droppable
	TAP version 13
	1..1
	ok 1 madvise(MADV_PAGEOUT) behavior
	# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

Reported-by: Aishwarya TCV <Aishwarya.TCV@arm.com>
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 tools/testing/selftests/mm/droppable.c | 46 +++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/mm/droppable.c b/tools/testing/selftests/mm/droppable.c
index 30c8be37fcb9..57e1b6fc5569 100644
--- a/tools/testing/selftests/mm/droppable.c
+++ b/tools/testing/selftests/mm/droppable.c
@@ -17,10 +17,10 @@
 
 int main(int argc, char *argv[])
 {
-	size_t alloc_size = 134217728;
-	size_t page_size = getpagesize();
+	const size_t alloc_size = 2 * 1024 * 1024;
+	int retry_count = 10;
+	bool dropped;
 	void *alloc;
-	pid_t child;
 
 	ksft_print_header();
 	ksft_set_plan(1);
@@ -35,26 +35,32 @@ int main(int argc, char *argv[])
 		exit(KSFT_FAIL);
 	}
 	memset(alloc, 'A', alloc_size);
-	for (size_t i = 0; i < alloc_size; i += page_size)
-		assert(*(uint8_t *)(alloc + i));
-
-	child = fork();
-	assert(child >= 0);
-	if (!child) {
-		for (;;)
-			*(char *)malloc(page_size) = 'B';
-	}
 
-	for (bool done = false; !done;) {
-		for (size_t i = 0; i < alloc_size; i += page_size) {
-			if (!*(uint8_t *)(alloc + i)) {
-				done = true;
-				break;
+	while (retry_count--) {
+		if (madvise(alloc, alloc_size, MADV_PAGEOUT)) {
+			if (errno == EINVAL) {
+				ksft_test_result_skip("madvise(MADV_PAGEOUT) not supported\n");
+				exit(KSFT_SKIP);
 			}
+			ksft_test_result_fail("madvise(MADV_PAGEOUT) error: %s\n", strerror(errno));
+			exit(KSFT_FAIL);
 		}
+
+		dropped = memchr(alloc, 'A', alloc_size) == NULL;
+
+		/*
+		 * Speculative reference can temporarily prevent some
+		 * pages from getting dropped. So sleep and retry.
+		 *
+		 * If a page is not droppable for 10s, something
+		 * is seriously messed up and we want to fail.
+		 */
+		if (dropped)
+			break;
+		sleep(1);
 	}
-	kill(child, SIGTERM);
 
-	ksft_test_result_pass("MAP_DROPPABLE: PASS\n");
-	exit(KSFT_PASS);
+	ksft_test_result(dropped, "madvise(MADV_PAGEOUT) behavior\n");
+
+	ksft_finished();
 }

---

base-commit: d401506a8ee8ac6bc4a7767c17da036e9434a4a3

change-id: 20260611-droppable_test-3737bd791dfb

--

Cheers,

David


