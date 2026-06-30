Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F7F0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58166B00EC; Tue, 30 Jun 2026 11:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08956B00EF; Tue, 30 Jun 2026 11:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1F786B00F2; Tue, 30 Jun 2026 11:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 803506B00EC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:21:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0854BC2A0E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:21:48 +0000 (UTC)
X-FDA: 84936943896.29.0D0FD36
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1E986120007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:21:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sM3v0Olk;
	spf=pass (imf29.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782832906;
	b=K5AHSzoz7pDaWgjTqEsvlZUMW0uhLIGcpkONATt/U+dx9LoBOa9ebaKQWO5doYFoYZje87
	KICvzYlnTMaELy89EbNDJ5+Vv8314JdwrWDZChNnOaQnG5fYcS7pOoiVS2KRUViyt/q8T7
	H8PyCm6fAhhJ9CdjSoUksLrwoUqKMvU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782832906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uOi+3GdOe+ezUoAPCNx4QDJRphwXMA4gdByDmvY1xU4=;
	b=uI+guuzp/qPG/UlB/8qiyd9Em953HXXFSZuPn9xjaTCnQ09sAk287J30t78Rvs65Hl5P9a
	OK2zr9p/5zBhWznGpy3HN07QxSewjJtdhDO7XxJp85Ts/dmm8CaU2HGnxLUUFUZK7XHGQY
	d3NMYPHrni0UDa15bhvwaVJ1vloP/aw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sM3v0Olk;
	spf=pass (imf29.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c88cc025f54so2762714a12.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782832905; x=1783437705; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uOi+3GdOe+ezUoAPCNx4QDJRphwXMA4gdByDmvY1xU4=;
        b=sM3v0OlkzsqXoojBqnmdxT3FCzJFOWxm70vnemFtirm8MBIzpQkB7Q+1Aso8Sy1JEN
         ezpIsh2nm3NzhpFdEBge6Anu7mEtWFV00mhOcwh8+ey47f1AhN3kEEoqM4OZF8L6quEX
         E5gq9tx41eygvxT/7JHmrm97bZP/noTJm3H7nV/JotwrBJyh5uMqQD41A7IqvRpYHgkc
         vjkmQUUVX+Vjm9w87hogmaSg9SA/6bhE7BVmJnJ3DmSqJcGXBu62NyhEXwxlK7dCigqG
         ZAUWzVHTs8e8LzpxeAZyCTi4mXfS3/T4pP0UIMZf1tL964idi92tbMKBSpxfeKQPjDqG
         4IgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782832905; x=1783437705;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uOi+3GdOe+ezUoAPCNx4QDJRphwXMA4gdByDmvY1xU4=;
        b=epXLUM2+T1m+ucPmyQAMY6uq5+wDEA8P5ftMr8+z0SF70towvh7ON0BcK4NXxVb8XI
         M350eEWoQPKegy0JexAxe1ng6ZOLWUStplTXLG6JpUGjOLJ2A6f98hMeKl3NrWCFwJaP
         Ycc/mUdPj8mdZGMZfNb6PDFk+gFN0OarniEfDh9drKRGQKt3eXgcZw9Yw4IEpPAC/oGl
         aZ+d7KSi/Wq9m+Id2MdQKnq6zQwz6UUJnFtxOdNxHrY+e+FybOtmxKGseL5z6nj1nsR9
         NG8qGKSDWbD1hCIV62FAgG1vLnpby/9sStHUxTnYXC/OYnLVH6h7R9y3aFT20IA74wsS
         4rbA==
X-Forwarded-Encrypted: i=1; AFNElJ/L9cPq15EUv0s6HVLS4hZ+hLl5iyXDfVXKpBSdIfq22n93qmmw9jbo0+obgS2i0Mh/RPNkmD4n1Q==@kvack.org
X-Gm-Message-State: AOJu0Yx2D1bkv/pT+wXNZrR8WefXhvKRy7GLKBagHmX4xc1UzqntF7st
	RzXP0ukNqIDjzaqeFcLmVCWEr1xd5Djm5S8YW7VLUdvQIy2uXmMjl9HE
X-Gm-Gg: AfdE7clw3+8S9GSY/cz15vjv+WcA4buMVORyskKg/OCng4z+o3+E2LijwZbCQAq3bma
	hAQhCnPfL/sV3xxQVWR84hKCetibLqWf4Q18dGJO/cozJ466DZkaSPnNKAUMKdiF47acZ9YDas1
	Wnm5q+jNrVajAkMFEB61tiZU+1o4AURdhMZCT/W0NSSGMjx62sO6remq5u3Tgej+ZdcmPlxIAJ7
	iFs7IyXPdAYaaZo2nadhvX2tFlv0UCNm/JfNH3fvuXqSdAefeVgc//d9UEyvDF7kejjKyJ/+Pj0
	VxKVitbBEF58ztVIMnfkF/ICL9yAr6R9PnQ8QRc9qTAHtgpTNFmYWdghxYY9JJU+DJXwFV9pR0G
	Ie2qBqyxObjs4IQrjWJL4MoTovgsU6dFYIIoOuUVJqqCWQsHYgoun2VZoRhuI6i9cyAckhIVbGD
	qA5MTD0f2Aiy8ATOdLA+JkibNlkzF6nH/t+XV5vP/c5oJVsjxTwmQOV8gpv3w=
X-Received: by 2002:a05:6a20:9145:b0:3bf:6c08:fba8 with SMTP id adf61e73a8af0-3bfc547e6c1mr3588664637.60.1782832904691;
        Tue, 30 Jun 2026 08:21:44 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9bbf95be56sm1810819a12.16.2026.06.30.08.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:21:44 -0700 (PDT)
Subject: [PATCH v4 3/3] selftests/mm: add userfaultfd test for HMM unlockable
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
Date: Tue, 30 Jun 2026 08:21:42 -0700
Message-ID: <178283290282.183052.2776436831525629180.stgit@skinsburskii>
In-Reply-To: <178283277041.183052.6873574850714079228.stgit@skinsburskii>
References: <178283277041.183052.6873574850714079228.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1E986120007
X-Stat-Signature: ptoeuyztf39a94boss1a3wfuwtb1uyeo
X-HE-Tag: 1782832905-928555
X-HE-Meta: U2FsdGVkX1+fwGjI1QkVkYCQZHRI3VuGidFbkyFDItUmea9qsIcUzRUl9liY/r5JNV5HdrS3lkArcjPP39ISNuuCUe3z7xp8HEIIEzACnOoEkESLQzrsBbNj43CMMPql1S3QFN52+KF/BnAt5EXT6KOFF5xr8EUvJLoxuEY8P/SPm8wDmxOdRkrA7ufVYVETqOULz3oX51YhTnZJ9UDI53s4hS5MeNpaAeMNILaEp0DztrMXyYNEE6LLx0+y1/b8grSCBZxZ2bnyPpabrU2g1gjBVbPFmTMB9yV5anJ/qtMyzt4J5IyHwbYTo3SacLUg51SGcDFh10Y+a3lmr4kToSj7y4pSyM7pOJ56lms2XKGyl8HLdjRGLFqrHvomHexId2mOU0u/v0pVKFE62rWf6f6aYKrjlNlC2ySiFMbG8wsC5j15BEI0P+I6cKcGi1D/GoQ9Q72Rf1mr/MaWWPvy+6wAahKbw73R0A/O/XJZaNxV4Tn92fPOG3SEt8NeTFA8y710CjKpbX3SqhrSU61fLINecOZc/8NLaw6nvUGSMF3gDtoRGddXKwrD7OJ3JNmbwNw/6TPtiLrylUAnC6oR3sUJZf3D8PYfVmU3SxjalkUwgQ6UiC6GRW3bNXQ8Jtxaa/AME43QCfa70mOhAfhOM47g5ADhviDsfLnemHy8PvL/0yONYZLope3GWGJ2zMcH/e+EVMt3vZFeWi1lOpKSOuiRoU34vC7zs/VcsAjXL6GgCqUm6nt6ZahqGix4AZNShdKh0qzs1lODzlMyDp2jDPlOWLkKtQjlPu/4Cyhp6iy/nfptOw5q8kDLBgK6m7hrpf2Uxh0R2JJZOk9t0+Z2M59WtI+NdA9HXD5yYXwwC/zZgiUcmqXdVq2YA6D1tmANW8jktlTaT7iZF+L9oCPv5vv1cD5Nm9o++nS415YMJ5/gTM+VTgSLCcrt24DYjRg+VdVT97N0dv4SFtmntC3
 m5n8Ezaz
 0OKfT8730RFCwNruqh+M19tNusTqUwcWOq+Kqjn8bYd1krvg3oitx9kkgkg0otyZTED97rQLpUMT4OthN30ocDqNg1/h5J6L01u/6BfxGr5VertaYXetSvfxblP3xo6hup2qPCqSFi3gDM3ZkmDSok9S+fGZP+aNi1oo1q/l/8osyWvvA5H+Ig5KmpYDzkjJa7Yx60jsWqu5HvjDnlJ0AvrqDU6wfwwU1xWZ+ieMxrIos8hmwgqHOXLqjkZo7OOX9Rupvc3YkooUAappaIaBfQwuiYDY+7DPGdRwwzCa6sjSj/rcVDglk31tGLcRBtBGFONLcgh+db11BPZdkMa6xB2ln+rwZbb3tvdaj58J8rghvSYd/TP4ToN2sTEOUMs0Sy9uoNYy/Smun3+GH8eJ8mIBX6Ne1WXufuHQP03knTxssTGhCYJeG5UN9lANw8Ti6Vwn08vkZwISMG5pG6UmNETM0nqh9/oPlBG9eC+HHZstI1hOoS3+c54nlFvbXR+DcEA5f2K8E6YdLLlFn+X9G8N5rwfl/icXJ5n54
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

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
 lib/test_hmm.c                         |  122 ++++++++++++++++++++++++++
 lib/test_hmm_uapi.h                    |    1 
 tools/testing/selftests/mm/hmm-tests.c |  149 ++++++++++++++++++++++++++++++++
 3 files changed, 272 insertions(+)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index c4adbf98fac7..085e3b941b83 100644
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
index e4c49699f3f7..ce3449d04e92 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -28,6 +28,10 @@
 #include <sys/mman.h>
 #include <sys/ioctl.h>
 #include <sys/time.h>
+#include <sys/syscall.h>
+#include <sys/eventfd.h>
+#include <linux/userfaultfd.h>
+#include <poll.h>
 
 /*
  * This is a private UAPI to the kernel test module so it isn't exported
@@ -2948,4 +2952,149 @@ TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
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



