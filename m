Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 625D2C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7FB6B00FE; Thu,  2 Jul 2026 20:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04216B0101; Thu,  2 Jul 2026 20:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5476B0102; Thu,  2 Jul 2026 20:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51C446B00FE
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:39:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 135681401EB
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:33:01 +0000 (UTC)
X-FDA: 84944532162.19.8FF6A5C
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id 306494000F
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:32:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DZ0xczi9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783013579;
	b=x1Lxyqrkl39U44cI3BoK/Iwwp6wfSspj/SzWLjgASZHYNtjDweeFQa5/HereNoHidUFk+P
	3bJaVNQ1EJ77FZnR/pRv9vLIN/HVEvesrR5l1uBhdGkAGODQiBje3KNBff84x+U73pd99J
	F4Y4W8UaosTfie65AyqI+VIUw9CEUz8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783013579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpKm74MkcnUAXi7kcxMdISx8NBsqRAdOaSBGzBZ0BBQ=;
	b=m5355rDYZszvLcudRdYhitUd3mSMcMzg1KduRvM/wtQb9pyZs9JTWv1xytRnSu2uhTB8Hs
	L8Kxv8CxtyNiXAQvU9BJGHyNyhkRuBu2YUWl8/S1tlPkNpTEsYIQ/LuRJ/XqvqNmDzTW8D
	VAd32WKNr3Yhj1roI3320tEJ+mB/k6M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DZ0xczi9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c7c61b5292so24710145ad.0
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 10:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783013578; x=1783618378; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bpKm74MkcnUAXi7kcxMdISx8NBsqRAdOaSBGzBZ0BBQ=;
        b=DZ0xczi9lzphYNrO4gkWrAFSMxtHgikwOFV8DRBEXU4JwYSE+FQubAfFtarM7jY8Nr
         Wah5pIrz5UsTqvsmYrgAuzd0dqFIeBBFDL2PnXUZcJyhp+B2d099Xn22gGzVZ8N6rmUi
         6/dq/S3GDzgr8juiBjbMMpeBbv8wwT9WEyqBpA4lDs+g71OVMGJXepMqZSqGqwny2UUB
         5n7aUhL63WVbAE38Ds2bLMkXPGcqo2UwITQc0vJjAofa1lMEwhdZW4kTsvoHo3KrmIuF
         9ED9eB3eVHdYERWa3I0kc1a3yKQDMKL5lY9sxQtSxMkRrLLg/jEDjU7nqxI82f0+3hF5
         EU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783013578; x=1783618378;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bpKm74MkcnUAXi7kcxMdISx8NBsqRAdOaSBGzBZ0BBQ=;
        b=RfViweaJ8aZvAWc78uHZeePUjt+dN9N8d0RvVzp8KNtJskHRxUVRsVewpeJKiPWgx5
         kNGCfWuAwrnzlyjtjyE7rFfLbVDoBO9oEKM8P9SuvlBKFk1FT7XQC1d7X7S06EgNT/cH
         wWJTZCXXDxSxNGOwLZV3nNkwPvgC2rDcnNv8402KcuREPUtcDlNXN07M8lpuNHniENI2
         Q6357m7TCCZPKoZeMVjz0g85VjvS0HgfZi+xzMuKesU31ViWtujuquPadxliIwSuZT2c
         aDZcfE4DyP+ly9KdEOIBkISrkutcVvM6QRMnL4QtnOZ+8VKqV04jz3uRca1f6VwN0NT+
         I8fg==
X-Forwarded-Encrypted: i=1; AHgh+RoZRU+xzQfoHGh+lXr+siVsqGRMwrXsdS/wn8Wd51f8y+Ic1ghrXDbLsOZdiwRTsgxUWw7C/JIBWw==@kvack.org
X-Gm-Message-State: AOJu0YwGJKXsg+bntIKIwtZ2Cp9NuqP9hwbcwnHnZHkIUfsZEZHGzKXi
	B9W64AMgYnWgv9/mZTH/nCDc1WlJ9XMZw8uUkGit6Xd/78ZIuBRwHd3U
X-Gm-Gg: AfdE7cm/dXMII1+48ukeggtj2f7ZvPvYWwHUGQRmU0U2cXHMqPHVmoHrUY0bWEAQQDd
	awpSLgsiZmWUKnNqB1ByPcK2nCSJ2FrAo5zvhdf3+aiIm7R4UV8C2n1aN1sbMIOOiaekWOpRJlT
	2L8jz5evQJ4uDt7s//MUuwYKj93wiyVf7BIseYNrPUWT5Bb6OgShld4b3qC6Na8QRgdGknu5XdG
	REGi8oAcXt75dhYf/bhBruxUnTfn3QfyaceH2Jzc12TZLRykbTu3BS6m02OkQ5gL5mWYxsiBcuU
	J8fCyAvFhDNZ2kIQusoJT4MZAskxnek6qGzFUiOOoQSmxu0IpGqZRE1QYn2arCn/HsAGokr9w1F
	VsaJ0t42yKHkzJ3VX3A2SfXIqQ/IlfREKbjgYLYlK/UX4+nazQtAsZsFB/wRoLvUTYN1U3OCXAP
	TDD5YaOkavwUl6xl/l7ehdyucD7+1UQlzfUlBjT2ryr4uz4mBoc//yMxebwK4AmDZ8zP5INw==
X-Received: by 2002:a17:903:230b:b0:2c9:98e2:76aa with SMTP id d9443c01a7336-2ca9121f078mr64170995ad.38.1783013577753;
        Thu, 02 Jul 2026 10:32:57 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cac85f18a0sm3495305ad.18.2026.07.02.10.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 10:32:57 -0700 (PDT)
Subject: [PATCH v5 3/3] selftests/mm: add userfaultfd test for HMM unlockable
 path
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Date: Thu, 02 Jul 2026 10:32:56 -0700
Message-ID: <178301357638.373695.2211649363131731735.stgit@skinsburskii>
In-Reply-To: <178301344866.373695.16044452017467686329.stgit@skinsburskii>
References: <178301344866.373695.16044452017467686329.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: nwxntjnxm9xcddrqctuwcw3zap8aa1rq
X-Rspamd-Queue-Id: 306494000F
X-HE-Tag: 1783013579-679196
X-HE-Meta: U2FsdGVkX18k05po90kQpYYLhyL61L0VX6LtfSKGU3ZCLtORcXPdlO634B7aJ7vxmAGEbwBFaZWnkBMXrquMQq9nWN9Tcks5+GjZdNhhiwWPq8CKFwqJ9U2qvxFD9YzXICej7OTOcV/gnO5morhUbZO/dE5tTZ3M/edkV8OlZuzQj0jo7FgGoYUhQ1ZwecqnqnHYdk8vMT8uHvP7cRG0vbaLJH+/EcsiZiL9JyE2jaZAdSeqkUzSZ/7umhqhx+kxFCarpCNGwWRyVv+IpYzoge5ltT6RdEN9U64zpbMTrta5bMdEK+jaZzRo+iU8iJnpQ6GPNJCthGa98P7zaSiOfOss0p0IVhII/lcHoBaeD+wUaPtxJZXZ50tviHnJHFhAz5OEMVRMMmNRxRBf3UlaHxw9qukjAYj2UGC1NzslclpDlFJZ6jtaIL+U1qNUCufCUXCucVrpY1NIKd/VLo+kKeptrI6fJs08NkS6n8qvR0aGiWv6BGh1L+/miGjaWyp+ZbaSnNM74wU64vPUvy6twdI5ANvoSpJD1Reop1kP6EqrRBev/rvpYL9PrPGafysU1YtVN/Tm8ggkGbz01UW4AczRXFUut/A83oA4IvQeLOzovalbaJKBRT5ABs7HPGEIy105lb2bnfZldHGYsLAXCji27sMy1Qzcwz/az+RD8mSPGv6J3gjxasfX9S7r+X3TosmI9JvNyd1QNvPPGqE2etXBEnKprABL34KZyQkRb4bj4xm9+Bf+DezQupMvOkfs3x1M7KTNuwNnK+rgXgYv5xAGD3/wMIf2FgblFw4pJmahzZKn12O1UiB7j94RfKxDaXW8NYIaVnMp3k8LUww0EGpFPyMwDxiTw6BDQ/BzL+1bOUzKnbqlL9TklrmbXG23doEQZGALWSmp5wUFwUuyx1IUEvDbagLxhVFDhYZQHC+KBFqBvDkgwiO6qmXWI+yOg7iKqf8+KZStIMLJYGb
 k9Ki/uKq
 leHzLehJZW6IAZ6oSHcONgKcpfFxVOlTyoV9HxClI01ZYKWKz362QGosC2rdUybsRtWx3TbjEeOCyGaiZYBvdr/9Omy4WPHFMp7MFenPUq3011mLuFApuo+3LB3ES6ul1JGPBYSCg5HXWwltj0jvGYmEYd7ysL4T+t31r5prrE3wx/sYDyIUg3YMayF5AABNwMJJiVLNB6jV5aKnW+pK89pH5NwPJAnTCgfRaZEdOYEE3yOr0+YXRY10ZzGSylB66kt3hg3k42lEIKOPemWXF0Nbj/6+SAXEDSnA7JmJqNVFs0r/i4mEWyxbBRMPTf55bQojv1zaGSLW41NqWrxUpZgRGO+j9cypXfwK5xe7/MBwDUtpBnlQO92iEVW3SK9MW3iI/AXaOgbqniS1CDh3Rkxxf1c0h3jGcmfkbqTXqwatiMlAspbJA6Ix+J29Cwk12E1uL4q7lydJhThSM4s2cV6hc1Bkcq/yQ+63tmr0osn3157VJV0PnlKktlR+KJz/WimIe
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

Assisted-by: GitHub-Copilot:claude-opus-4.6
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 lib/test_hmm.c                         |  122 ++++++++++++++++++++++++++
 lib/test_hmm_uapi.h                    |    1 
 tools/testing/selftests/mm/hmm-tests.c |  149 ++++++++++++++++++++++++++++++++
 3 files changed, 272 insertions(+)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 45c0cb992218..1219d22d551e 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -389,6 +389,84 @@ static int dmirror_range_fault(struct dmirror *dmirror,
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
+		return -EFAULT;
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
@@ -488,6 +566,47 @@ static int dmirror_read(struct dmirror *dmirror, struct hmm_dmirror_cmd *cmd)
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
@@ -1572,6 +1691,9 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 		dmirror->flags = cmd.npages;
 		ret = 0;
 		break;
+	case HMM_DMIRROR_READ_UNLOCKABLE:
+		ret = dmirror_read_unlockable(dmirror, &cmd);
+		break;
 
 	default:
 		return -EINVAL;
diff --git a/lib/test_hmm_uapi.h b/lib/test_hmm_uapi.h
index f94c6d457338..076df6df9227 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -38,6 +38,7 @@ struct hmm_dmirror_cmd {
 #define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x06, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_RELEASE		_IOWR('H', 0x07, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_FLAGS		_IOWR('H', 0x08, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_READ_UNLOCKABLE	_IOWR('H', 0x09, struct hmm_dmirror_cmd)
 
 #define HMM_DMIRROR_FLAG_FAIL_ALLOC	(1ULL << 0)
 
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 2f2b9879d100..17bc076f7553 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -29,6 +29,10 @@
 #include <sys/mman.h>
 #include <sys/ioctl.h>
 #include <sys/time.h>
+#include <sys/syscall.h>
+#include <sys/eventfd.h>
+#include <linux/userfaultfd.h>
+#include <poll.h>
 
 /*
  * This is a private UAPI to the kernel test module so it isn't exported
@@ -2949,4 +2953,149 @@ TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
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
+	int stop_fd;
+	void *page_buffer;
+	unsigned long page_size;
+};
+
+static void *uffd_handler_thread(void *arg)
+{
+	struct uffd_thread_args *args = arg;
+	struct uffd_msg msg;
+	struct uffdio_copy copy;
+	struct pollfd pollfd[2];
+	int ret;
+
+	pollfd[0].fd = args->uffd;
+	pollfd[0].events = POLLIN;
+	pollfd[1].fd = args->stop_fd;
+	pollfd[1].events = POLLIN;
+
+	while (1) {
+		ret = poll(pollfd, 2, -1);
+		if (ret <= 0)
+			break;
+		if (pollfd[1].revents)
+			break;
+		if (!(pollfd[0].revents & POLLIN))
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
+	int stop_fd;
+	int ret;
+	struct uffdio_api api;
+	struct uffdio_register reg;
+	uint64_t stop = 1;
+	ssize_t nwrite;
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
+	stop_fd = eventfd(0, EFD_CLOEXEC);
+	ASSERT_GE(stop_fd, 0);
+	uffd_args.stop_fd = stop_fd;
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
+	nwrite = write(stop_fd, &stop, sizeof(stop));
+	ASSERT_EQ(nwrite, sizeof(stop));
+	pthread_join(thread, NULL);
+	close(stop_fd);
+	free(uffd_args.page_buffer);
+	close(uffd);
+	hmm_buffer_free(buffer);
+}
+
 TEST_HARNESS_MAIN



