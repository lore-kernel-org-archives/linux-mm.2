Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A998CD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 01:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EB336B0088; Thu, 30 Apr 2026 21:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2566B008C; Thu, 30 Apr 2026 21:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8116B0093; Thu, 30 Apr 2026 21:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C2F26B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:24:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 551DA140B84
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:20:24 +0000 (UTC)
X-FDA: 84717095568.07.55F63D8
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 79B52A0002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:20:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=Qw+pghRX;
	spf=pass (imf25.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777598422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NQokjxZTbiFLs09VOKMOjg27YnTe4ff6NkYQggVffs=;
	b=CeFl1kN1tKgoL7FiLCiu/lU8Kyjs+PqPaeKS6x3yrMsx01DA1PFKJ+DOe10dFm9nCV84WO
	63HM3h778ofUSGzP0lSu00XahInVwswCM+a/aeq1F9XtCBEkbmdocGOlB8GdsVs0Zk6PH9
	NqqoaMe3Re5zNxAWDIPjjFEl/DyaF1w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777598422; a=rsa-sha256;
	cv=none;
	b=K32JPuK8tACLbO3KsoM2PodPtRgWJ5+hgCPI4d3Bcgt27K+rT0M3mcZJzFL4jf68O/UIFL
	/yV1D4PAzbO1UmIEjdcYHPtAmVY5qSv2Pyk5ruiY2nqW5x1LAuwPia+4TVHYkRO/DEe39P
	lXRy+Us3XaoQvS8pslEiBvcoG1/jlH4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=Qw+pghRX;
	spf=pass (imf25.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from skinsburskii-cloud-desktop.internal.cloudapp.net (unknown [4.155.116.186])
	by linux.microsoft.com (Postfix) with ESMTPSA id 05B3020B7165;
	Thu, 30 Apr 2026 18:20:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 05B3020B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1777598421;
	bh=+NQokjxZTbiFLs09VOKMOjg27YnTe4ff6NkYQggVffs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=Qw+pghRXv+sQrcuvnZU1OuLhy1365Aaci7GXMa2xUZaNKoy79+HHjrbQrHvINUk1+
	 WxJ/spHG8Pbk+S0MNt+TppPoC+3OWx2PJXFa69DUANzujCwjrNPuselYsKOera/ovA
	 rps81nmoA0mld6qVU8280YCxBDffHEEGTfKCBdI4=
Subject: [PATCH 3/3] selftests/mm: Add userfaultfd test for HMM unlockable
 path
From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
To: kys@microsoft.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, corbet@lwn.net, leon@kernel.org,
 longli@microsoft.com, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, wei.liu@kernel.org
Cc: linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 01 May 2026 01:20:20 +0000
Message-ID: 
 <177759842032.221039.9909074100094332429.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
In-Reply-To: 
 <177759835313.221039.2807391868456411507.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
References: 
 <177759835313.221039.2807391868456411507.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 79B52A0002
X-Stat-Signature: tqb7zg46tybgp5o9fcqa1zj1r9pe6h7u
X-Rspam-User: 
X-HE-Tag: 1777598422-150578
X-HE-Meta: U2FsdGVkX18etcROlc7PXhwgYzrS1qrH7Ucq/9B8z9CZY3stUwtzYSAiE7wLI5lLhNN5jH8L5YC61EngM7aiGPlg05xmF2C3Ya2Lt17OGFeUUlC1TtCOaQFpHos66eeEKtrkNbvlRpDucvsrHU9F7Kx2v1b2gCIaOjKhvwwoicS+s9W5IVtywBZWc+r9ZVXNzZPKFqqcAVeQ9yLLfU18A3qM5alAqe3m1bhKhQiPI5veQGvyUs3S7cLgAP8BeFgiE4zFxjXo0TDUlWIs9E0OD+Zb1AQQca/mbAC+SAX5bWfUiDf9DaNKRoLNyxYOjVHA2v+Ztidj9/IF74Z7G3wwY90Dfx4OzqY+7uhCKF2kswElrPJeWqSpmOf0Hb+vI2nc0lz5A+RSYKJICHdn3sjoZFgEOD4dDeRDasTFYaKCnPijoa/asulkg2Fh20TPBprwDUHT7/tuXYXM0WXIRpRHf/beAFBV6HZFWGAgkJpK3MhOVcAUbziQLvTtfe6GWkB/UCHnL6oDk6gg/vlAKZ8IJ8YOBvFvQVzzWQf3ExiLrjbhx7NmC8fwYvmIrrzdcRD8jB6gH1c5Sfw7i1Chw2siN+4XkM5poM9c0nlFbWKdFcrCbJxkILGa4nJu9LM36x0uk1XXPHGpfwy8yl2LdmdWOxX5W6STD0LNm0KJN26YO94YPAz7b5HdtUbqT3gkNQfKEngiKjRJirGPECa77cx9mAsenH4qW/3NjJ6o4YnOVvY+SxJFlV+kE0EEpgK6l4uZMhyahDjd/qhfkAb3FFgLJ/6k6KhD3h6L1Wk0ZjNG/rLIQ2e3eFI4lFumIZnftABnPmIro+/UCMRZIoVBd/RuVzvdDo83Tge4dvUVCuSKsTWYruODRONDAfjoyQ67lRCUd1ye+P3W996d92ThLiGsy2CMySkeWzWKjgDhGALUZjDnBgnp98wWQ7Dbsb92zxecPo70wjcZlgePmAFMfdr
 /HzoJJIQ
 4HF/Av/1Fle5UuGp5m+rwsSbFrITDFpV+zu0PLELHA2jrCNwLIJc1gZ4sJ2EFw3rjyFpoIH8NBOnR3VoeGykgJMXkk/4HzoZDrsycfUkefQ99KDWoqVXQoBloIkCKUXjar0c7adznI8a88Wzt5z3r6mxg3NkonUCug8x7ATY4Tv+r0c5xyZSzzDe1vJI7LBlT0Ql3i4hNL1SncydKGNlYQNIjnw2mFaCJFNWh/O4NEGaZ1KwBLewMfvp4EfTjaq0yLs6g0W3lhfAFH1osNS2IwQjlVQyyVxkNVpBtcntrfx6R5Ns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a selftest that exercises hmm_range_fault_unlockable() with a
userfaultfd-backed mapping. The test:

1. Creates an anonymous mmap region
2. Registers it with userfaultfd (UFFDIO_REGISTER_MODE_MISSING)
3. Spawns a handler thread that responds to page faults by filling
   pages with a known pattern (0xAB) via UFFDIO_COPY
4. Issues HMM_DMIRROR_READ_UNLOCKABLE to the test_hmm driver, which
   calls hmm_range_fault_unlockable() internally
5. Verifies the device read back the data provided by the userfaultfd
   handler

This requires changes to the test_hmm kernel module:
- New dmirror_range_fault_unlockable() that uses the new HMM API
- New dmirror_fault_unlockable() and dmirror_read_unlockable() wrappers
- New HMM_DMIRROR_READ_UNLOCKABLE ioctl (0x09)

Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
---
 lib/test_hmm.c                         |  122 +++++++++++++++++++++++++++++
 lib/test_hmm_uapi.h                    |    1 
 tools/testing/selftests/mm/hmm-tests.c |  133 ++++++++++++++++++++++++++++++++
 3 files changed, 256 insertions(+)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 0964d53365e61..20b14e279a8bd 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -327,6 +327,84 @@ static int dmirror_range_fault(struct dmirror *dmirror,
 	return ret;
 }
 
+static int dmirror_range_fault_unlockable(struct dmirror *dmirror,
+					  struct hmm_range *range)
+{
+	struct mm_struct *mm = dmirror->notifier.mm;
+	unsigned long timeout =
+		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	int locked;
+	int ret;
+
+	while (true) {
+		if (time_after(jiffies, timeout)) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		range->notifier_seq = mmu_interval_read_begin(range->notifier);
+		locked = 1;
+		mmap_read_lock(mm);
+		ret = hmm_range_fault_unlockable(range, &locked);
+		if (locked)
+			mmap_read_unlock(mm);
+		if (ret) {
+			if (ret == -EBUSY)
+				continue;
+			goto out;
+		}
+		if (!locked)
+			continue;
+
+		mutex_lock(&dmirror->mutex);
+		if (mmu_interval_read_retry(range->notifier,
+					    range->notifier_seq)) {
+			mutex_unlock(&dmirror->mutex);
+			continue;
+		}
+		break;
+	}
+
+	ret = dmirror_do_fault(dmirror, range);
+
+	mutex_unlock(&dmirror->mutex);
+out:
+	return ret;
+}
+
+static int dmirror_fault_unlockable(struct dmirror *dmirror,
+				    unsigned long start,
+				    unsigned long end, bool write)
+{
+	struct mm_struct *mm = dmirror->notifier.mm;
+	unsigned long addr;
+	unsigned long pfns[32];
+	struct hmm_range range = {
+		.notifier = &dmirror->notifier,
+		.hmm_pfns = pfns,
+		.pfn_flags_mask = 0,
+		.default_flags =
+			HMM_PFN_REQ_FAULT | (write ? HMM_PFN_REQ_WRITE : 0),
+		.dev_private_owner = dmirror->mdevice,
+	};
+	int ret = 0;
+
+	if (!mmget_not_zero(mm))
+		return 0;
+
+	for (addr = start; addr < end; addr = range.end) {
+		range.start = addr;
+		range.end = min(addr + (ARRAY_SIZE(pfns) << PAGE_SHIFT), end);
+
+		ret = dmirror_range_fault_unlockable(dmirror, &range);
+		if (ret)
+			break;
+	}
+
+	mmput(mm);
+	return ret;
+}
+
 static int dmirror_fault(struct dmirror *dmirror, unsigned long start,
 			 unsigned long end, bool write)
 {
@@ -426,6 +504,47 @@ static int dmirror_read(struct dmirror *dmirror, struct hmm_dmirror_cmd *cmd)
 	return ret;
 }
 
+static int dmirror_read_unlockable(struct dmirror *dmirror,
+				   struct hmm_dmirror_cmd *cmd)
+{
+	struct dmirror_bounce bounce;
+	unsigned long start, end;
+	unsigned long size = cmd->npages << PAGE_SHIFT;
+	int ret;
+
+	start = cmd->addr;
+	end = start + size;
+	if (end < start)
+		return -EINVAL;
+
+	ret = dmirror_bounce_init(&bounce, start, size);
+	if (ret)
+		return ret;
+
+	while (1) {
+		mutex_lock(&dmirror->mutex);
+		ret = dmirror_do_read(dmirror, start, end, &bounce);
+		mutex_unlock(&dmirror->mutex);
+		if (ret != -ENOENT)
+			break;
+
+		start = cmd->addr + (bounce.cpages << PAGE_SHIFT);
+		ret = dmirror_fault_unlockable(dmirror, start, end, false);
+		if (ret)
+			break;
+		cmd->faults++;
+	}
+
+	if (ret == 0) {
+		if (copy_to_user(u64_to_user_ptr(cmd->ptr), bounce.ptr,
+				 bounce.size))
+			ret = -EFAULT;
+	}
+	cmd->cpages = bounce.cpages;
+	dmirror_bounce_fini(&bounce);
+	return ret;
+}
+
 static int dmirror_do_write(struct dmirror *dmirror, unsigned long start,
 			    unsigned long end, struct dmirror_bounce *bounce)
 {
@@ -1537,6 +1656,9 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 		dmirror->flags = cmd.npages;
 		ret = 0;
 		break;
+	case HMM_DMIRROR_READ_UNLOCKABLE:
+		ret = dmirror_read_unlockable(dmirror, &cmd);
+		break;
 
 	default:
 		return -EINVAL;
diff --git a/lib/test_hmm_uapi.h b/lib/test_hmm_uapi.h
index f94c6d4573382..076df6df92275 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -38,6 +38,7 @@ struct hmm_dmirror_cmd {
 #define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x06, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_RELEASE		_IOWR('H', 0x07, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_FLAGS		_IOWR('H', 0x08, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_READ_UNLOCKABLE	_IOWR('H', 0x09, struct hmm_dmirror_cmd)
 
 #define HMM_DMIRROR_FLAG_FAIL_ALLOC	(1ULL << 0)
 
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e8328c89d855e..e7bf061747edd 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -26,6 +26,9 @@
 #include <sys/mman.h>
 #include <sys/ioctl.h>
 #include <sys/time.h>
+#include <sys/syscall.h>
+#include <linux/userfaultfd.h>
+#include <poll.h>
 
 
 /*
@@ -2852,4 +2855,134 @@ TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
 					&thp_results, &regular_results);
 	}
 }
+
+/*
+ * Test that HMM can fault in pages backed by userfaultfd using the
+ * hmm_range_fault_unlockable() path. This exercises the lock-drop retry
+ * logic in the HMM framework.
+ */
+struct uffd_thread_args {
+	int uffd;
+	void *page_buffer;
+	unsigned long page_size;
+};
+
+static void *uffd_handler_thread(void *arg)
+{
+	struct uffd_thread_args *args = arg;
+	struct uffd_msg msg;
+	struct uffdio_copy copy;
+	struct pollfd pollfd;
+	int ret;
+
+	pollfd.fd = args->uffd;
+	pollfd.events = POLLIN;
+
+	while (1) {
+		ret = poll(&pollfd, 1, 5000);
+		if (ret <= 0)
+			break;
+
+		ret = read(args->uffd, &msg, sizeof(msg));
+		if (ret != sizeof(msg))
+			break;
+
+		if (msg.event != UFFD_EVENT_PAGEFAULT)
+			break;
+
+		/* Fill the page with a known pattern */
+		memset(args->page_buffer, 0xAB, args->page_size);
+
+		copy.dst = msg.arg.pagefault.address & ~(args->page_size - 1);
+		copy.src = (unsigned long)args->page_buffer;
+		copy.len = args->page_size;
+		copy.mode = 0;
+		copy.copy = 0;
+
+		ret = ioctl(args->uffd, UFFDIO_COPY, &copy);
+		if (ret < 0)
+			break;
+	}
+
+	return NULL;
+}
+
+TEST_F(hmm, userfaultfd_read)
+{
+	struct hmm_buffer *buffer;
+	struct uffd_thread_args uffd_args;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	unsigned char *ptr;
+	pthread_t thread;
+	int uffd;
+	int ret;
+	struct uffdio_api api;
+	struct uffdio_register reg;
+
+	npages = 4;
+	size = npages << self->page_shift;
+
+	/* Create userfaultfd */
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (uffd < 0)
+		SKIP(return, "userfaultfd not available");
+
+	api.api = UFFD_API;
+	api.features = 0;
+	ret = ioctl(uffd, UFFDIO_API, &api);
+	ASSERT_EQ(ret, 0);
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+
+	/* Create anonymous mapping */
+	buffer->ptr = mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   -1, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Register the region with userfaultfd */
+	reg.range.start = (unsigned long)buffer->ptr;
+	reg.range.len = size;
+	reg.mode = UFFDIO_REGISTER_MODE_MISSING;
+	ret = ioctl(uffd, UFFDIO_REGISTER, &reg);
+	ASSERT_EQ(ret, 0);
+
+	/* Set up the handler thread */
+	uffd_args.uffd = uffd;
+	uffd_args.page_buffer = malloc(self->page_size);
+	ASSERT_NE(uffd_args.page_buffer, NULL);
+	uffd_args.page_size = self->page_size;
+
+	ret = pthread_create(&thread, NULL, uffd_handler_thread, &uffd_args);
+	ASSERT_EQ(ret, 0);
+
+	/*
+	 * Use the unlockable read path which allows the mmap lock to be
+	 * dropped during the fault, enabling userfaultfd resolution.
+	 */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_READ_UNLOCKABLE,
+			      buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Verify the device read the data filled by the uffd handler */
+	ptr = buffer->mirror;
+	for (i = 0; i < size; ++i)
+		ASSERT_EQ(ptr[i], (unsigned char)0xAB);
+
+	pthread_join(thread, NULL);
+	free(uffd_args.page_buffer);
+	close(uffd);
+	hmm_buffer_free(buffer);
+}
+
 TEST_HARNESS_MAIN



