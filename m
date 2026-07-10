Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DBB3C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB686B00C8; Fri, 10 Jul 2026 17:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4256B00C9; Fri, 10 Jul 2026 17:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9516B00CA; Fri, 10 Jul 2026 17:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00C086B00C8
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FD70C3707
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:48 +0000 (UTC)
X-FDA: 84974151696.26.CF2F45F
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id AC74B140007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l0wp+N6k;
	spf=pass (imf26.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RipBZIycyhdDriy0xY08qbrpkk/gJ3+/YM3pixpsFXk=;
	b=oYaBg4juNLmhFomU+NhGDKV2JaVSB2yJ0PduKxi4dNM/sDM1Rw6L6c+em0FeZlFh989Ec4
	v8LCUE50L7fDxEkoZsrqWabuiCxXJGv8UZjYIQvC4ltOT6I9M3P4zy5IH/nm4zM0qXKTzx
	k2raKaXNlVpP7ylGl8M/5WcIWrXxabg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l0wp+N6k;
	spf=pass (imf26.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718806;
	b=5nTgTcB/FBl+VpD8JqoCZgkUVXMQPToZOlJTGZyTdP0M0wrmUkomRUY0p8lqrQlNF+WX68
	uiWG62cQHyuevieJRdPoqQNSQVZklnhTRuOOYfwyP62kAjRhUIrVPddede8d+UzwhArWZ+
	ZNpvrbXkKjVtqbpLD0N/9ZNzKnBSbNY=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cc891373e0so13357405ad.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783718806; x=1784323606; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=RipBZIycyhdDriy0xY08qbrpkk/gJ3+/YM3pixpsFXk=;
        b=l0wp+N6kyvz0jiVd63Agyph8dYra8+rcB7OiQzx8AXY433YC7RApIbhaaCPsjxUV1G
         v6ojgqALPTat794v/KqT0Z10jgexW1Q9+5mY0/tVGpBdI7pDdozSNp9GcLlcwRYBMZQ4
         EvX40hCefP2hHx62icn/4zEbkPkFCnSYR4k+mQDzWa9Ht9PZrmG1qPPpvhMzNFXIeSdp
         0q/3t40S0wl0zNPxOIOGkCNNEZY3DIGTz+X2muTeeGdkLtYSpl3eFPn2HStzj5GLID1C
         G8o2wS0NlypCMOPp2Q7EnsS8/AssMJrBCrYkNuPrSidHOhwq8bszqbvFqg2YvIN+sKeI
         nW1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718806; x=1784323606;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RipBZIycyhdDriy0xY08qbrpkk/gJ3+/YM3pixpsFXk=;
        b=Dyx9DuXqbBWQaQlQRNumo+9CZIAtdjOwUJSiajVnraI3PO31+lyP2hDdhuRR3p3jYB
         2WMV60HiVK0mSuvdjp2kvf9HC9ATOjUsfj4zwhYTDHXPocwgoamxIl5/qvleMZIE5n2O
         wqHVLwOeQHLvRDbARpQ23EbqKlq8lhHfTlQh6obMXtl8TgNhbplQTGcW+VatSsA8lUIv
         v1Sh93zWhVRXLudgyVsrdvzA01um6qa6XY8HTRnlpZdHPW5AMWIOm+r37PO8vrb4Hu7U
         nqVrsi5D75VGMggAoCWpnQV5jLfmjAl7kqexVWtYTmdbvhKjlUnx+XebG0WwZT2g8oK+
         b7BA==
X-Forwarded-Encrypted: i=1; AHgh+RoI0wfIQG82ufCX65KvawMmK6VhPYA8Bm753L1tgmpGCcSZFpQl2Yhqonqq9o10tUFwY+CnAUOEow==@kvack.org
X-Gm-Message-State: AOJu0Ywb32JVYRBP41fSoGJq1GJo0me64cS7weD2LPgDGB5qlPrs6LAc
	Vlgf5ko0ZTdI1fjV0L0YwgaTPAdk9kpXhY7uuTAOx7K+vvdz6PT498cw
X-Gm-Gg: AfdE7cldkztqfXQxvb9PdGMPRehqeFREI97KD/O3E46BA8nk8cwSJmNBBa2t0VU4z2u
	r10SZPKOGzfTmwFQVokX+QInbEwIeeHOtVw4KZVIAW1WxW1/zV4p31EX9f0N3LJaa4GZ+AV7t9z
	roajHDlwrbituHYGJG6zvd1Qaz9QbKDljj2Hr1xa6cD5BoaB0BMlG7XWxkdtwb7k7Bwj11ehU1M
	gJTui1xi/+4SP+2+TVED+1CfksN9Lvc8wPcmSBlTCySy79TA7ivi6SumURF6avQaD4kZIygOU3c
	tCX0SX6rXCj+tfrKKXgKfx7BvaxHNBm+UsZ+SD8+Sb/yisVmjHhyjjw03dkt6fkal3RIMEjkq4m
	NRrNIBmTETWlducfXTPAavaRMIZW9d1tJkRwXoMWC11obfIu/GbfXC9j24+Z8AqlEEmFzc9I1V2
	AyxdjZwooSzNvkoekib3mTT8KhusRBlQiMRGEIJC7BKYuutFBt1lNnIb0pFQ8=
X-Received: by 2002:a17:902:d483:b0:2c9:e261:95c4 with SMTP id d9443c01a7336-2ce9f01d298mr7642895ad.30.1783718805605;
        Fri, 10 Jul 2026 14:26:45 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb75fsm65281555ad.8.2026.07.10.14.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:26:45 -0700 (PDT)
Subject: [PATCH v8 3/8] selftests/mm: add HMM test for mmap lock-dropping
 faults
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org, wei.liu@kernel.org,
 skinsburskii@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Fri, 10 Jul 2026 14:26:42 -0700
Message-ID: <178371880218.900500.12093463712908415421.stgit@skinsburskii>
In-Reply-To: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AC74B140007
X-Stat-Signature: godt38643zekphapwf738azecgrcon1i
X-HE-Tag: 1783718806-832087
X-HE-Meta: U2FsdGVkX1/Q/mWXfKevEqRHAx3P9ip6OkF5caQt4XWMHDOW+czNWGF6Wv5GpFJK/wWMyN/t9WRu6A6O1YZXCoqpfo7yANym4cPDLNwduOCDsG0S1o3B7VRyJuV0e5Hba5G/3Xy+5DpuzR667XoupOZl4emeq251gYrGG3BWR0RubvbJpSGe1KEpon3+iDCSktaJl/it2H4WaVzskJIO8RxwLmKSI5rdtPmOeaHUHoZjJwdXB7UeV/RrESXt1YjazoanSjooWPLceWiymKYriAWTEb6XDdG7glRn/UgtchCB5anTqVXQB6+7TGRcPKHttPp9O/ogsW4BJRCWVq0WNPYt9GQNXyn1R6SA2YVSALUbjV8jkh6Mm8ef2ytF/vMfNYS/7dYlcKdqW/gwsmB4KvywANypL3pjlE6s9tYrXrepsjckheuQDsjFTvrd6VjkMuaNoqy33WZYPZlWl6eoyNom6STNm6VPO4IAM37mcERpNNoToM/u2js3LFvFp0iXgU9u/woOffl48YxYxBYI0CoV3wVb1IaJ4RiQ7LX7NmhrwDGqj4EspKNxAE6VMIvieDnWEJYofHYTuWawjshExalxx/EW09zIYxzqdsEHwhYSpIQo4esroukInIxt+hP4OYvJ7Gyei7s739KdgJIc7Y/DOdWrcK0RMQjhMk2v0L5z6vDKekRza60ZOLD8uwahNmU0awtO0/zb4yZjqq1vurVRS1ihJpzXxb1bdne617YZOywPZMxRtUNqDC57A46e8aJyhIAHMYbdyzFeYfh5lJKKDSkamznI00eBs7njfgFz3lx9ThT2WqrW1LWyY57QshJWSX0OMYcbYKpwDZUg9ndgAHmANS9RWd5xvJ+i1MQD0KtTbXYP5fPLN8W1urKF1E+3mD7ATJUea/4fRDEhKkQ3dC6QN7xrdJozOwSBwZl2gQkO/i5FeVK9UiImgVy8R59VJSKtYulq7oMXFw+
 a8Nb3EJ1
 Mi/GtBAnRfcJkLx3qWFnOEchD2/yOETu5IwidBPWzkPCSibVa72SiGpPyuXNWFJ6avNDh1c0cdXEBGVrjV6jWjKzw42MMlR4ncWY3FZzoAddVFzImtDKYud+ImSOxSYaug81CEDuw6qYET1Xs2TQv1R/FfqRE9pRAqLIM6VR+bwJn7WVxYr3ZhitxNx+cSuy7MrY/k0/8mggG6GyPgNX2/jj4b2lGrKd5Rn0mUCh5mQlVcs7vnMKbcWYywVXvR5+33aZVHOdogv9T9ytX6CuvFQ0754tAYnzbxNBYuY0w5gn1ifCAKrMKUmvgTlUjU/pZX+dTUEsDodmV6TlPAOQ2RqdLSFwyBx6S9Q/E4Uev5EjIsODOe6NS6I62UcDJt9UjV29so/tOpS6vx//uikCRgvhu5OazYcEr6euGUhqMhefj6BtDHzPpto3nG7sHAcox7U6rhmqYNCbMGUdhhr6auR/J2HUepilEQeWRk0nXPEQ3uXkdPHjP3FrVYAEDoU7NCo+5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test_hmm coverage for the HMM lock-dropping fault path. The test module
gets a new HMM_DMIRROR_READ_UNLOCKED ioctl that calls
hmm_range_fault_unlocked_timeout() with a timeout of 0, exercising the
unbounded retry mode while allowing the mmap lock to be dropped during
fault handling.

Add a userfaultfd_read selftest that registers an anonymous mapping with
UFFDIO_REGISTER_MODE_MISSING, services the faults from a handler thread
with UFFDIO_COPY, and verifies that HMM can read back the data supplied by
the handler. This exercises the path where handle_mm_fault() drops
mmap_lock and hmm_range_fault_unlocked_timeout() restarts the walk
internally.

Assisted-by: GitHub-Copilot:claude-opus-4.6
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 lib/test_hmm.c                         |  107 +++++++++++++++++++++++
 lib/test_hmm_uapi.h                    |    1 
 tools/testing/selftests/mm/hmm-tests.c |  150 ++++++++++++++++++++++++++++++++
 3 files changed, 257 insertions(+), 1 deletion(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 45c0cb992218..6205fb313bd0 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -389,6 +389,67 @@ static int dmirror_range_fault(struct dmirror *dmirror,
 	return ret;
 }
 
+static int dmirror_range_fault_unlocked(struct dmirror *dmirror,
+					struct hmm_range *range,
+					unsigned long timeout)
+{
+	int ret;
+
+	while (true) {
+		ret = hmm_range_fault_unlocked_timeout(range, timeout);
+		if (ret)
+			goto out;
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
+static int dmirror_fault_unlocked(struct dmirror *dmirror,
+				  unsigned long start,
+				  unsigned long end, bool write,
+				  unsigned long timeout)
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
+		ret = dmirror_range_fault_unlocked(dmirror, &range, timeout);
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
@@ -488,6 +549,48 @@ static int dmirror_read(struct dmirror *dmirror, struct hmm_dmirror_cmd *cmd)
 	return ret;
 }
 
+static int dmirror_read_unlocked(struct dmirror *dmirror,
+				 struct hmm_dmirror_cmd *cmd,
+				 unsigned long timeout)
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
+		ret = dmirror_fault_unlocked(dmirror, start, end, false, timeout);
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
@@ -1572,7 +1675,9 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 		dmirror->flags = cmd.npages;
 		ret = 0;
 		break;
-
+	case HMM_DMIRROR_READ_UNLOCKED:
+		ret = dmirror_read_unlocked(dmirror, &cmd, 0);
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/lib/test_hmm_uapi.h b/lib/test_hmm_uapi.h
index f94c6d457338..ea9b0ec404fb 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -38,6 +38,7 @@ struct hmm_dmirror_cmd {
 #define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x06, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_RELEASE		_IOWR('H', 0x07, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_FLAGS		_IOWR('H', 0x08, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_READ_UNLOCKED	_IOWR('H', 0x09, struct hmm_dmirror_cmd)
 
 #define HMM_DMIRROR_FLAG_FAIL_ALLOC	(1ULL << 0)
 
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 6fccbdab02ee..5acb728666f8 100644
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
@@ -2952,4 +2956,150 @@ TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
 					&thp_results, &regular_results);
 	}
 }
+/*
+ * Test that HMM can fault in pages backed by userfaultfd using the
+ * hmm_range_fault_unlocked_timeout() path with no timeout. This exercises
+ * the lock-drop retry logic in the HMM framework.
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
+	 * Use the unlocked read path which allows the mmap lock to be
+	 * dropped during the fault, enabling userfaultfd resolution.
+	 */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_READ_UNLOCKED,
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
+
 TEST_HARNESS_MAIN



