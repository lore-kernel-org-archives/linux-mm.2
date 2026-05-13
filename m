Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55C55CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1566B0093; Tue, 12 May 2026 22:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A82B76B0095; Tue, 12 May 2026 22:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998C46B0096; Tue, 12 May 2026 22:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8ADDB6B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:40:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4FE6A1C0563
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:40:32 +0000 (UTC)
X-FDA: 84760843104.06.258F957
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6299740003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:40:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=qPoz18DP;
	spf=pass (imf07.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778640030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12QRuygVdUNScmIiUvD+OobPWDFOvMqeD94n+2kqzQE=;
	b=WdsRea6FLLV70pMZkMWVOJqJEfTlYJSvB6YC2EzwMJP3kZctEkhPgXdYn3jUe9ohGZ7pT+
	Vuz/k1KOkQKD23fir2IWxCAyxeQGhXgHF/4XS2Lmv60ozCWfyjPvyFv2E7SwmuFZCNAiMe
	MPpy9kqYnO/FswNGp2ycePaAig48Ta0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=qPoz18DP;
	spf=pass (imf07.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778640030; a=rsa-sha256;
	cv=none;
	b=6jk3UkCWgYnGLVbfunLnDnjnayKaFG2cPMHj7KFBGv2bh5+dUcUr/6Dsqo7blME2GRgSJr
	Kh8kpzna3bfM03PiRvmBpjCHwO9WfZbnaKnmtetT1lEYiFYvuGnuet5sLtwd/7nl3sd0ZG
	7FBH9VTrw//P0fELhHBggMymoyjmN9s=
Received: from skinsburskii-cloud-desktop.internal.cloudapp.net (unknown [4.155.116.186])
	by linux.microsoft.com (Postfix) with ESMTPSA id B933220B7168;
	Tue, 12 May 2026 19:40:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B933220B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1778640025;
	bh=12QRuygVdUNScmIiUvD+OobPWDFOvMqeD94n+2kqzQE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=qPoz18DPzPasmS8GOj1l7fHu+XMEwXfSZT+PY40RaDbqyNwtVhATpV5JVKurbRm1M
	 G3+Wa/0wOmmccM8Z27vGhUrvECVnRSiCcNQg+wNnO9GbIf0tf7CGTclVS4qlIzOFxq
	 Sgu64xzG3Fxro39uwgRCQtc54KfiI4+ZRcoP8hzM=
Subject: [PATCH v2 3/3] selftests/mm: add userfaultfd test for HMM unlockable
 path
From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
To: kys@microsoft.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Date: Wed, 13 May 2026 02:40:28 +0000
Message-ID: 
 <177864002802.82528.12119708338755599533.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
In-Reply-To: 
 <177863991557.82528.15288076059759579141.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
References: 
 <177863991557.82528.15288076059759579141.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xdaw7mz6xoszz1yphjhccanmdmjwi6k5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6299740003
X-Rspam-User: 
X-HE-Tag: 1778640030-378817
X-HE-Meta: U2FsdGVkX1/6LjXlIeDQjnFNC9lNxe97ln2nfLRAlp0SO2GVfFYV0SvE+ON5awBEJcEN35OAFRU2P6Fz1Vsz9gC9Od/OxXWpKssKXtCXLOVKzIVK/sSLcIywoMgfZESZOSqRPrShCbaUbj846UbSrhifUXcadlvU5skGPmuysbOLZ3r18OrOFua867uqHZwLrlma4fO6rx0uojRUM83wJ8/+36BNE4n/BZiezzXPr/mx/WKy35/FTC2oSpZ0VAPYtzp3rCBq54S4VkcnUwM7f/SS0DhllVg2l1gaI4bH66cFwNJsB1+1RBGmlb9Fr1XB8muvaiV71J5AO9TcSc/m12YX1rXV+VpWKcC4HpE5VdVYsfJAl8w2OTXg3+AR6uIJzF+QhJ8xIzqTDVvCEPnEIgaxGhj+NrwnW3b36vr3VofqgEhY3lMMYaPMo1jgegD7LXS9Q1xzUbRYqzU3/ca1HG1Cq5cHTljwyX+1rsnyyhpul2VfDh7/bGDEhSJyhM2zyAMel+8woFAxMSB1sVga647zv8cyqaP2udjm0rxgCRTijJfEPpbHnYvkM/unhuc9d8meWUWFBwAa7J6ZrmS9mpmCqKAewJlRzDcC6NqQZspNYjwiuxV65M7iogspYFTrEyNANSsh3FVBx53OIg2WzaR8Fi0Ep4xy1VmhrBD1H6HbbAWeHH+kvegz/xOiM1WBHzNLMJ9ATn1ML49PH3W/IAI5vVTSHWtxZNjLoJKTD5/NfQfybtjfOHcL6YinJfGG2VJ7rDU//h4vFp65nvhXxU4QTNAt+yy4cuJ3uITEn4vfUroXkeyUDW6rZqArhZiXnrGFbGH7VeC500HllBOo+vgZ9DjoNA2zCzS58XD3J/YrVMD3mUK++GCnJXNSJvtaPdn/v47+ShAP1gYUCgN7iOwxfzgcInh8KzLi8X6bPdis3pguUHQysH/xTEvXM7PGGOJpMDVaqGnXI94Pfa3
 73JCrMoE
 hnfRUv2LPXFf16SiFc8Y9ZEQNIwMhjx7Mmphm0t+m7Q/9HR5iSL5/McY1NwNQuWU2tpWV6rI6xvH6q2XDyRZaMfpDMCuWw9UUe7YCaLyRE6rOvXlKB6ftsMOs5P5w01RIBRXDOKILc9JscJrBjVPXBRyOD6tS82Wht55YXBG070zsnJo5DsVcGWOYBiyOBHqtkEWiv5Ee6fl2lMwT1qNVPRA+aIVoWsMJ30w2rYD6OHQunB9VUL4pv29WBztK82zRiCY+/g5AfrG+ONKIVV46hP+E1kaR2l3ttZf4lck7VR20Kc4=
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

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
---
 lib/test_hmm.c                         |  122 ++++++++++++++++++++++++++++++
 lib/test_hmm_uapi.h                    |    1 
 tools/testing/selftests/mm/hmm-tests.c |  132 ++++++++++++++++++++++++++++++++
 3 files changed, 255 insertions(+)

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
index e8328c89d855e..12e988b96c158 100644
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
@@ -2852,4 +2855,133 @@ TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
 					&thp_results, &regular_results);
 	}
 }
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



