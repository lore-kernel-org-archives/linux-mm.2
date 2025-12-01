Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4EFDD116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 18:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCC9B6B00B4; Mon,  1 Dec 2025 13:19:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3C06B00B5; Mon,  1 Dec 2025 13:19:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA0A6B00B6; Mon,  1 Dec 2025 13:19:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B37F6B00B4
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:19:04 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1B03C01AC
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:19:01 +0000 (UTC)
X-FDA: 84171713682.20.F6F1D8D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id DE5F6C0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:18:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fjKhYWLF;
	spf=pass (imf22.hostedemail.com: domain of audra@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764613140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=blQqdapcXTSPJCxD7giptBV8MOZKLLZchAntN5zGTII=;
	b=eClF1isDa17IRwAnSChVyekvR0GSmAsmk8NLN8z+bf3uT8RVt9OMdKlyW9C0a3o83bUL/8
	3OUZXMxVdATcY9lV/dyIYoBHguycdLejk4f7yxGy4dQwlgU/FIu/XmcJUtg10LsDV/Lamg
	D2w7CquL5yLZiDLvl6iCcYpKc7wnF2U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764613140; a=rsa-sha256;
	cv=none;
	b=we6+G9M67k5TIpadUQg4ZL2xGUMo+i46gW5PtxETT/lQT/O2u3f3WGxdIBHnvIYh/47/bm
	9aF/YI6tMoDz2iUG9HeyF6usuT7dSLN+ik9VG5oHniqLHB3upuoPw3fhxDYe7jgY0Pgbp/
	Yv+jIdGgLIcFy8t55jxsVifXREjzwuQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fjKhYWLF;
	spf=pass (imf22.hostedemail.com: domain of audra@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764613139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=blQqdapcXTSPJCxD7giptBV8MOZKLLZchAntN5zGTII=;
	b=fjKhYWLFpZtQGEaOc2yjYM2mJhMk2QVkYOH30zPYSvF1xmFmf1mLyPMgyNdQt8wnRBbOlU
	eqfPRGeJmSsJxT/G5tAmOFjWlnuqov5Y52KxS5d+4IMoJw2VD/5ZtB3c5drSg2gKiLmyK/
	58DNnD0W8dLx2e86Oh5/lr5e5mKdiz8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-EE7U_QUePPmhg0hqYqD6fg-1; Mon,
 01 Dec 2025 13:18:55 -0500
X-MC-Unique: EE7U_QUePPmhg0hqYqD6fg-1
X-Mimecast-MFC-AGG-ID: EE7U_QUePPmhg0hqYqD6fg_1764613133
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 86C70195608D;
	Mon,  1 Dec 2025 18:18:53 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.13])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E8C241800451;
	Mon,  1 Dec 2025 18:18:50 +0000 (UTC)
From: Audra Mitchell <audra@redhat.com>
To: shuah@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	surenb@google.com,
	rppt@kernel.org,
	vbabka@suse.cz,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	david@kernel.org,
	urezki@gmail.com,
	raquini@redhat.com,
	akpm@linux-foundation.org
Subject: [PATCH] lib/test_vmalloc.c: Minor fixes to test_vmalloc.c
Date: Mon,  1 Dec 2025 13:18:48 -0500
Message-ID: <20251201181848.1216197-1-audra@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE5F6C0010
X-Stat-Signature: wj7byz615rye3j1w6ak9utrf1b9r8adq
X-Rspam-User: 
X-HE-Tag: 1764613139-953922
X-HE-Meta: U2FsdGVkX1/9VeekN0QIWHCGxGYmqK+IN8/LIVua7+ZCXAsS502k24WiueDXOINcGAL52jbQs9LtDjMlK4F95dmqM0UL4tNMSqkF8J+b1AT9TcqFnbgQiQ3F0fsHN133Xvjah6jsNCRELwsyitayEZvUXle/sjsMmgieNnbt/BZiqf+Mh9n+x4jW7X4ynEhbRfEaVmxbDOqzWJy+mU6bC4EUBl0F54quEqxt4oNgmhxz+/g6DVUpkrUGB1Yfn+HlzjO3XIMKsGWo2JpmNwAbvdWrItQiTuAor4tCz5uX+1nxk+VTHDHXhZHoHkNIxD5WtOwu8UuvopgvaZVDwoc/Oi4B7yyyJvZ1GQ6vRm1SHicXVzHweYmzGhq0O2CdFCgrTaik4DLZr0aCHgWg7Zd4ly/2Kx1liRQpU1SRdj+xYeOnMLRc8Qt+5oiau9DaFci4tcno/loCuAM24tBd7d2SPy3y7IbMlTO9Dly1KbIgFXgKdOL8PPUjFjczLXdKXeXbKAKLnp9KS/AuM4+eiNqbESYK98rUIPNRYHdN1w1a2cUEN38VRDEdIRk2FOyfDpdxcZcQemWnYQeI8pDXumwikuN1fGuUTajCvCwiF+y5enRgrK3rJZiYMVcl317drFIWuXCAw2g+3i7xuZwusVCzHmfiHqKIKiDIjwqDYcEUrywEA9kTZqF2d/cOHW98oIV2KpzqvduWdBh64BKHitHFPbGTnqLFp4Y5OAUTvKnHbZuk18zsTJUs7vVazdVnEv2s4H5bYiRa1I441SAy3tj4o6EN6Is08jHzoeM2bDWG5H9Z6/YQjUlp1dF/DJP3CR8dGtfA6p76PKv5FsyZhgui6d1w/7j14R49vpj04zlG2cw1wyZalf8bmlYiXHZC2NgUOV4FK74m+VKrfRhMS4qKtf/PWIL4PuSKRCbEeVbM3Wwprius4wabMjtaXqopePXjPvwxQxH9OdBNhK83Jv7
 c4Otc+nY
 lJNb3nfNvQXqDwRpNSwW+5OBt7t0z9sjJLtrQ+qI0mVjyjMUoHsjf++UpWpXlrDZA/f7qD/TacfgAeEDgJIEHLdliHJsw/q+MO7jWr0mTm7DbN1lppj9iwhy7j5L2t1EaaEMxIPwAz+bBAAhDzaiAxITYkstTs5fITYWN/VUKFUhrYNlIw2526ePa4muj57Fw10nh6PpvQ3u0IL5i3f5MKQW3e+NTzjWSlVd5aNU99j1qbCzHdRclcqCHRHqzaX05Nd3PxGBdum5uu+56P9mKyvaY+8jCsz7m559MrJ4JdlpG5HmmBvF2/2Kp42i5AIcP6rdAfb0pfSi4IDX9niJcHDW+USLmmQVp5hC1FZVQU8MeGRxNjI8ZF8kHC0XfKg2p2G8O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If PAGE_SIZE is larger than 4k and if you have a system with a
large number of CPUs, this test can require a very large amount
of memory leading to oom-killer firing. Given the type of allocation,
the kernel won't have anything to kill, causing the system to
stall. Add a parameter to the test_vmalloc driver to represent the
number of times a percpu object will be allocated. Calculate this
in test_vmalloc.sh to be 90% of available memory or the current
default of 35000, whichever is smaller.

Signed-off-by: Audra Mitchell <audra@redhat.com>
---
 lib/test_vmalloc.c                         | 11 +++++---
 tools/testing/selftests/mm/test_vmalloc.sh | 31 +++++++++++++++++++---
 2 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index 2815658ccc37..67e53cd6b619 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -57,6 +57,9 @@ __param(int, run_test_mask, 7,
 		/* Add a new test case description here. */
 );
 
+__param(int, nr_pcpu_objects, 35000,
+	"Number of pcpu objects to allocate for pcpu_alloc_test");
+
 /*
  * This is for synchronization of setup phase.
  */
@@ -292,24 +295,24 @@ pcpu_alloc_test(void)
 	size_t size, align;
 	int i;
 
-	pcpu = vmalloc(sizeof(void __percpu *) * 35000);
+	pcpu = vmalloc(sizeof(void __percpu *) * nr_pcpu_objects);
 	if (!pcpu)
 		return -1;
 
-	for (i = 0; i < 35000; i++) {
+	for (i = 0; i < nr_pcpu_objects; i++) {
 		size = get_random_u32_inclusive(1, PAGE_SIZE / 4);
 
 		/*
 		 * Maximum PAGE_SIZE
 		 */
-		align = 1 << get_random_u32_inclusive(1, 11);
+		align = 1 << get_random_u32_inclusive(1, PAGE_SHIFT - 1);
 
 		pcpu[i] = __alloc_percpu(size, align);
 		if (!pcpu[i])
 			rv = -1;
 	}
 
-	for (i = 0; i < 35000; i++)
+	for (i = 0; i < nr_pcpu_objects; i++)
 		free_percpu(pcpu[i]);
 
 	vfree(pcpu);
diff --git a/tools/testing/selftests/mm/test_vmalloc.sh b/tools/testing/selftests/mm/test_vmalloc.sh
index d39096723fca..b23d705bf570 100755
--- a/tools/testing/selftests/mm/test_vmalloc.sh
+++ b/tools/testing/selftests/mm/test_vmalloc.sh
@@ -13,6 +13,9 @@ TEST_NAME="vmalloc"
 DRIVER="test_${TEST_NAME}"
 NUM_CPUS=`grep -c ^processor /proc/cpuinfo`
 
+# Default number of times we allocate percpu objects:
+NR_PCPU_OBJECTS=35000
+
 # 1 if fails
 exitcode=1
 
@@ -27,6 +30,8 @@ PERF_PARAM="sequential_test_order=1 test_repeat_count=3"
 SMOKE_PARAM="test_loop_count=10000 test_repeat_count=10"
 STRESS_PARAM="nr_threads=$NUM_CPUS test_repeat_count=20"
 
+PCPU_OBJ_PARAM="nr_pcpu_objects=$NR_PCPU_OBJECTS"
+
 check_test_requirements()
 {
 	uid=$(id -u)
@@ -47,12 +52,30 @@ check_test_requirements()
 	fi
 }
 
+check_memory_requirement()
+{
+	# The pcpu_alloc_test allocates nr_pcpu_objects per cpu. If the
+	# PAGE_SIZE is on the larger side it is easier to set a value
+	# that can cause oom events during testing. Since we are
+	# testing the functionality of vmalloc and not the oom-killer,
+	# calculate what is 90% of available memory and divide it by
+	# the number of online CPUs.
+	pages=$(($(getconf _AVPHYS_PAGES) * 90 / 100 / $NUM_CPUS))
+
+	if (($pages < $NR_PCPU_OBJECTS)); then
+		echo "Updated nr_pcpu_objects to 90% of available memory."
+		echo "nr_pcpu_objects is now set to: $pages."
+		PCPU_OBJ_PARAM="nr_pcpu_objects=$pages"
+	fi
+}
+
 run_performance_check()
 {
 	echo "Run performance tests to evaluate how fast vmalloc allocation is."
 	echo "It runs all test cases on one single CPU with sequential order."
 
-	modprobe $DRIVER $PERF_PARAM > /dev/null 2>&1
+	check_memory_requirement
+	modprobe $DRIVER $PERF_PARAM $PCPU_OBJ_PARAM > /dev/null 2>&1
 	echo "Done."
 	echo "Check the kernel message buffer to see the summary."
 }
@@ -63,7 +86,8 @@ run_stability_check()
 	echo "available test cases are run by NUM_CPUS workers simultaneously."
 	echo "It will take time, so be patient."
 
-	modprobe $DRIVER $STRESS_PARAM > /dev/null 2>&1
+	check_memory_requirement
+	modprobe $DRIVER $STRESS_PARAM $PCPU_OBJ_PARAM > /dev/null 2>&1
 	echo "Done."
 	echo "Check the kernel ring buffer to see the summary."
 }
@@ -74,7 +98,8 @@ run_smoke_check()
 	echo "Please check $0 output how it can be used"
 	echo "for deep performance analysis as well as stress testing."
 
-	modprobe $DRIVER $SMOKE_PARAM > /dev/null 2>&1
+	check_memory_requirement
+	modprobe $DRIVER $SMOKE_PARAM $PCPU_OBJ_PARAM > /dev/null 2>&1
 	echo "Done."
 	echo "Check the kernel ring buffer to see the summary."
 }
-- 
2.51.0


