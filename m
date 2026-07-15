Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3312C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671786B00B9; Wed, 15 Jul 2026 14:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6496A6B00BA; Wed, 15 Jul 2026 14:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5603A6B00BB; Wed, 15 Jul 2026 14:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD996B00B9
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:16:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88F1DA0155
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:20 +0000 (UTC)
X-FDA: 84991815720.20.89779C5
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id A7722140008
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=soHMfzNX;
	spf=pass (imf09.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784139378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RipBZIycyhdDriy0xY08qbrpkk/gJ3+/YM3pixpsFXk=;
	b=lvRUh5wS+rsb21GwaYD4KanBLOqLBASI+u/D1MtXoFgAtLuWYuG1WjwAjGhcfko6nD45hZ
	dYeA/h+w7V2Ahvgn/zdVtavKprlJpql7mIy8rg4F7eAatwMi2hcetFSS6oTbLOwGmMJv5K
	NdbxhLr/gOtcIJkI7zc4t0oZHd0wrSU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=soHMfzNX;
	spf=pass (imf09.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784139378;
	b=dhnt1zwOQ21IBhJnniEmFODBCcNuHbUm6KE6jTpkgQccHVR7hb2JsCTNM5DydJwzJKbkC8
	LIo7rv4PJuwi7AsvcQqfLs7LwT7B2IPMAGpuKXeip72/tgkD0PIX5prvAShZvSjnFC4QHj
	U/jpyu5t0RAzYwVeNvw1ecCfyHpZA5U=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c9aea40d799so1155702a12.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784139377; x=1784744177; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=RipBZIycyhdDriy0xY08qbrpkk/gJ3+/YM3pixpsFXk=;
        b=soHMfzNXk6E5PAQHsAR4J+pvMFoOor5SaDKpXWsZhrkALNLYJSwlDIuCj9HY0yA2fk
         JnQm6vIsB2mrLAbvFVy8c8pQQ95SQEfPvn1GWUtB7Kd1IrJpRwUO7ASRculEz4D+uE0Q
         dCDSC9rAvhAS1T1Wc2fZlj0lc6wa+dMVENG+kLCPbeKV2q48eke2XOM26gEdRO4XtIB8
         xMJ4aUqdoqynp2agoDCfIYEaXOpQ31xfTZwBe6IhW6WGQeN46POuIyPoFtdACQfKlvTh
         QS3eUMbuCm1lIhCkaUoLyEdtdyZun5aAJA9m5GS2uSBsqi1RA9hzBybXBqGYgafP9Ayt
         Oavg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784139377; x=1784744177;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RipBZIycyhdDriy0xY08qbrpkk/gJ3+/YM3pixpsFXk=;
        b=Ejn5HgV50D914fWL9+27uw09Sz5hm+/kcwYHcG71zHkjjIatPodxlPgNElwvbg3406
         UckSC5JVzSFnm+fwh+NtCagQh5WYlb36XOvm5ZUaqfHpJUxwDgBETQ6oX1LTsZyuAxwn
         IrUqsyK9tenlAel7qfxQ6U/xXPrdnKS/o5rlx5vqJQwrBPossPb5NIekCj+hIefyn8WR
         fh76gcgd+Ynu87hiws0jCObYmN2Tl5+VVb1W/VJVh8zyiuvErCLU8e6q0LSZHzUuTCzH
         3Nai4FN79RzuF6k3BnZRT+AEBVeIkYsZrI3PiPRt1N6SjfNT94IggwwABbOi1kEbBWTW
         ciPw==
X-Forwarded-Encrypted: i=1; AHgh+Rq9Gvkezl7YdlYCXXV9ICjHOTFOLtV1jgPXSR/HX4dtnleIOhgzaEFmGiHw1NxZoTKMcJQ+59U6KA==@kvack.org
X-Gm-Message-State: AOJu0YxtLw9QFKALjesCEVTnAA1TqavP0hCtrm1IiEEkMA3abkIcyBxD
	XsJu/9WBf1Tr/QZb46tJBQY/uw88+5HQBYRbX2lc3Lfo4UqLgqpxGaW9
X-Gm-Gg: AfdE7ckLcAyol4IVFsBNDhcl5ar3/dMb7srfm/gXa9CppECt9BNixOlo/gMHli1jKax
	o0p7eDPpphUaBfNBN+oW2GRAbjbcEAQ0tsFqg0XjNLgnxjY01gj/7IiF4az6LV6eA4jwOGG+hOj
	Iks176Z+e0uVG7Zj6cF14rfDEekhFBaL6XkN4qWtD3ezeFMY5iUkhe0Rh6R+Y0kKAyuFAiMk4Op
	7yia0aWTqXhtCz/xK2KEuRPrcMHiTVXR4RWWO/6+HYdFbAsbc1fNeWWPARF4rdgMHaJmVQYblUx
	ICBa4mPRUX0qCueBBZj27RUdVhbqgcB63EWAQ0tNItxj26STIn2bpV50a9Xx1IEmQVGlwXXAH75
	ZiNL5QkZTNKyJxzPM5UGXuUQELYKuUqZm/Po4YW0zCty8WFRiXYBPJeoQ3kfRI6WByuSw2PF3X2
	hhH5eeFPvVeu4oabFqA9U+L++Mx4AiuDqpYRVtTehEkiaI3fzOwNQRdrxZBLY=
X-Received: by 2002:a05:6a20:9149:b0:3bf:aa1f:4881 with SMTP id adf61e73a8af0-3c110ad509cmr19061608637.56.1784139377267;
        Wed, 15 Jul 2026 11:16:17 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb25902b597sm620902a12.32.2026.07.15.11.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 11:16:16 -0700 (PDT)
Subject: [PATCH v9 3/8] selftests/mm: add HMM test for mmap lock-dropping
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
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Wed, 15 Jul 2026 11:16:13 -0700
Message-ID: <178413937354.1155966.16649896548407894107.stgit@skinsburskii>
In-Reply-To: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A7722140008
X-Stat-Signature: 88tze6qmqdgbksz5fssgibr4aak1c7ty
X-HE-Tag: 1784139378-181220
X-HE-Meta: U2FsdGVkX1/Onsux8FFxyECSIEikpIPhZLxlAIaTajqZnNYgRej3ztIj9MfFe2ACbExA8I3z64+xFZ0MEKzNbqEMcJCjON20B3NV3+JhleZFBACWa6z+GC35aPrXCu9zCWVq5mm4qlQ791tdGCrgznAb9R6Vgi396bY+bZTzkc5HDsEd3QQsClmhtdw2zeaRVlRq1FkWGL3TrhtQvpE/4GTRxFf6BSk6MpcRMW27Jf9UEPlPp3KRfF5M6QxPdeCmgY3jO7jgKvykLXM3F4IoWO4ewgTYhZMNxOj8cblecYj2JK+nyq5WlrOzNQwjgRORjH1uuGFtAIIhQyG+S9AM12fWTukAumh7QmFzCgpJVj1PL16+46AfUgLnEHDAlz3hglVFMag/3GHs9zmYjkaN1tU80ZCD0WzzfDYl/tR6BxaMsV5H1tXdY1IN+JbcSsxTtrniOiY5nSFVCzmmZcojlCjbP+6ohXW/mig1sZa097d6W9yZxG5MVs5KlwNQzFIgT0jcGiHeQC8Y/hytczW0AdQroqwMr3dwAD/cHf3UN2SQIS4oC4OAbqe6vgUCu5+2SooQn9+ZSvmN1fuMWV6+kLVp6sWY8XkSgS6TWMvniy7dr8smNvVoLEJWKDyxjwQnkDeYdKjf1wbiuoiMzjvRBdbC7AZrtU+5nthHJVWyg9j9iNYngyuwd8hjWxRAa+DHqn3Okbk43nfIMWmPwUvXj3gof669PXNHPsuB69MGpukLg0Z3zVEt08G5J78KfFqpm+IvqpJvH6TAEGhPJSxXj5sxESUHlpL003zlW5LZ/gjgkrT5VqSgnlRuCbOByc+AFAAMauYyHxNNxlA/nEolz8+q37ZHh8GQYFwDFQ9uZgrpsx4DZ/syCJScOKJUibuAAgz+kyopDLjgwIHo22uLpTdq1+tVhM1VCzbJXMnuhvxpg8ROghLIMZnNjwWPPnJ3CPWWa645AhOZsbgpoeg
 ewzKGTtf
 nJn+K2OZ7Czy4nrXL3urcDHBCN1gErwFDcWZ2FH30Z+CjHyse95DEWl9+sKWEbXznP6xLO9TtN9ZGtnAD1yWOJbxTKNHMc/EDw+LZ0kWy0X+CvqTxEj2I7f1LyPU43rPDEnvv8r2Rc+al9m9TUBrwJkpeCvM0YrkPzQIxzTtVoGkwVUYR10yNDw98vtc5FWl6XxWNDUM1AGUqohpItDHb6VC9QedwxzYKqNIoB6HDeovCb/UClTCJPwMgK1j23+7X98WyVZmB1S07P5S4tIxQkPliDy7toiEp9utv1MufLycnVKNUvv5JZqo9G63L0vyk/X3uH/2jbmgIWDHdf4TH+KpBFt1M9Z61oIJ4C8iehariKi6R+V/7x1BZoOy2fxYTsnC+45KvriptK6GiB7/5APbAhcLILDZDvTazhVnW8h2erfRSLLeYOjQ5i85uJNNK1oU8qEB8+d4xDjlAWKnVXoCzQ3FUZxKCYUOX3dMhviMpaiSMi9J3jV/ktPKr5d+PrhLHiDbx+6H6xg9Vdf1kT+Bp4dJ+AIHU31XOWYZRPVe5x2KMWv4jEtzdMB9fod40LEeeUxuQzS9ly3RAAKMURiuspYznxZSj4N/T2fppliatSBLUT+Gu7EU6zw43ITRb4/wu
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



