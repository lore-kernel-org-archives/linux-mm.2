Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06EB5C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5BC56B00BB; Mon,  6 Jul 2026 13:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33656B00BC; Mon,  6 Jul 2026 13:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A225E6B00BD; Mon,  6 Jul 2026 13:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 680696B00BB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:55:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2C9C401CB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:55:19 +0000 (UTC)
X-FDA: 84959103558.25.8233785
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 02F9380002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:55:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RFTLH89r;
	spf=pass (imf02.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783360518;
	b=NBwANPUL3jsw0A/lb3hXXT4PhvxYmTHxdMu9fjXePnDwv8DSvc8UTC7S8w+c2Yc7HVDhou
	X8LvLPGYCFxCwodkZ06HIs6QpAj2RuHbzYdBIzWrTKT6B/5DF/pCksop1q7MCAvd2l3w51
	jvyuPS1vwJ46DueizOGhUIzeGMKgJhw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RFTLH89r;
	spf=pass (imf02.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783360518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZO+FFwngeJDcSpYhEaatPCogWFYZkos6hWPOoVhGkjc=;
	b=sQhH52RF5WV5j1P+GwOFN35S9UKoKFaQd6BjaJKH6b8IzYPfZPA1dnWDk3qUDeiDOP2UCv
	GtkQh8hhvLoDVx+zbRov0feWKhpXhRzYPlp49n/5gye2IT15qAKUf8rdw8n+g4+QTlIxY8
	cYc9EGRpog2FoeaMiD4lG2R737Y2xJA=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-845e47133c9so51961b3a.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 10:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783360517; x=1783965317; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZO+FFwngeJDcSpYhEaatPCogWFYZkos6hWPOoVhGkjc=;
        b=RFTLH89rcsMK6nIeTu/XvukzevjohtiUE7TdEVTqrzYow0zsVpFS9nvhvXYuQ6tevv
         9Yp21QtRCM8mFNLTWyyOaV7c55vDgM5cLDRdS7EnHJb3A1aZ5nTSlmVKTiNlpnohlB4G
         UwVksfyeastjTlsnZ8ZbgoN4d/irMP67qeTWykjTC36sq8W/MLn9v9pAYo4PugliC/41
         szxE98Wxfb+0sFw1cK44VxLTybGHnEoSoLCPcwiuT8TmR7jbsn0Mg24NMTPHmuoT8Wp8
         CMP5bJAkMtVrl8jvdpO3FTcUDx8d6jRcAv0/d2h9LP4TbcUet9CKUgzkd87jcaUZ6AKZ
         gx2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360517; x=1783965317;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZO+FFwngeJDcSpYhEaatPCogWFYZkos6hWPOoVhGkjc=;
        b=VUVRm7M3WL/iGMHEZzYFAzyRoZJ1A8iddLrFDIYn8qAARmjUwieskAsehd1Id+5I9q
         R6DRCDqaPIPZ9sYUIAlHGB6FzYBJFPJWA4yjtsAIMUtFszNlguS7EL6twbg3oKmgCjlr
         6wOLlmx5x4D+QusMK22Z1Uca+4X6eCpim8jmhOmhtIg56e6SH4z4t9GkERtv6Gz+tH9t
         t5L8Le5+0Lwn+yUuAmUN4jowe0a9rGjfvuSjpNRhChLdbJdZyjytwHe8KR8baRPYehdF
         wFlr2CbR6L7hPZekiGwH9Pp8TmSg9eVHkhVMif5lJHZJ8HvAKy7cb/PPaflGoj8o6H8z
         ZnQg==
X-Forwarded-Encrypted: i=1; AHgh+Rq/E5jqh5aCFYFFy2uSpLpr6KSrD8ncnqb+vJ1ytg6DNMVJE9q6/qcVsA7HmebBnMilFb5QcxkkLg==@kvack.org
X-Gm-Message-State: AOJu0YwAUJmumv4xNB8ZtSPXqXqQzZMZV901zQWanh92Vkd/gUjjzTZt
	65TFQJE0bC+Uhh1ziTT3n5qizfJGN+qMOVvJQqLojr9zD4T/qYPJDh0z
X-Gm-Gg: AfdE7cmBLRJ1kZtYCLwsh6fC4Fsb/Df7gERe52G8L2fITjo2PDoa+ugitNHtuY7WzPn
	TY1L0aJ6X6JrYncGirswDJ8rOQwccLve80wQrUcDxIpRxCiEREy1uE4SkbBAx3CuUMOtmonFVOl
	G/GFvz3xdBBekNlsMuKCM1v96A7cxCiAl7AgPUkbo9CJWj7wEgw6UjIc72sDLkvOndHo04ELvca
	Pr9pNBof58x2pNwFx2S3ezRz1QbIV+jfnZxcJRg1p2icafzvgO4ulEKsqMjKv2IW16OE5C87POx
	oGun/YQKKK9cExSZFjj4tAPlguZb21eNsLy+lWrzQv/zm5L3M7Y9t/IVKzBgUB9kYb0uwtrHYOv
	j9l3Xvj2M2IINydIL548VkViUnxyK2U6dV7LsBxUyudrfECkVwSTXwJJdFlo8Y35zRCKjz2rRj+
	lRsOdRDEnNkvRkc60FAZaelYdKM5cYtefR5LKlo5ugX3PkEhHOSdxFCv1ILeDi2EZlQohWfw==
X-Received: by 2002:a05:6a00:244d:b0:842:63f5:d097 with SMTP id d2e1a72fcca58-847e17360d9mr13133036b3a.3.1783360516724;
        Mon, 06 Jul 2026 10:55:16 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6dd9237sm4266935b3a.59.2026.07.06.10.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 10:55:16 -0700 (PDT)
Subject: [PATCH v6 3/4] selftests/mm: add userfaultfd test for HMM unlocked
 path
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com, kys@microsoft.com,
 haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 longli@microsoft.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-hyperv@vger.kernel.org
Date: Mon, 06 Jul 2026 10:55:14 -0700
Message-ID: <178336051466.504354.2020914754190628869.stgit@skinsburskii>
In-Reply-To: <178336023903.504354.7500950448226027718.stgit@skinsburskii>
References: <178336023903.504354.7500950448226027718.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 02F9380002
X-Stat-Signature: adhkwwa7sjufhgzfineb8ici79wjxspz
X-HE-Tag: 1783360517-899061
X-HE-Meta: U2FsdGVkX1/QZM63WsraQdFn24a6l1ZLCSn9iawk0eIyPmY1o1cNUIcsVSoOi+vJricVqDjyxXkYJwrT+3MH+KZUTaF/btmMjTfeKmIf7vJ7Eg8pHTt8+PYJuSn2+tQ1xsw6NWqrfAbcQwdbfilZsHUXkcbyumsZi8FLpjGOKndOADMU5RyEMft68kT+YlWE3DLRJepER5QxtDDs568uYezWeX5wiViZLp0qTDubWBwSOmtRtd/43QWHV+OUANf4zqLgavphlrTmSuNXgeZYqmDq/DbDtQjd/yL1U5rXEubLLIZRh0SC6Nw+QusPuWzMJosP2PtRPxZtYBtHpPt1fZEi5etxnoXiH0ViS1fMhoPshplhUhqt9jgTEQmIAlsKAbYfrMkYd6phxyHCocXqzA8t1R2lzTSqOibixpiyP8VQRsg0JuNfC9gojjocpHJKJU5k4KwQWiiSt1dpwQjFAmIay6qKq9MEiXvweYDoBKOZ/Lk+ZJ5WMmqd6M83T4Y4ZfH2ABMBWtNwNw9FSHGaRuYAVavvMcoBFugE/kzWaaziIoj9oUnmNiKSLlU7FCZ3+kb8X36WVgaOqDXhIUHGLFXHVoCssO4+DdKmmm+vt6V6RFGAJoVlQZEal+o7xpNi9kToM2ABfKhh+sSkB0Bo1u2wa4ufxllmqU/3MOuA/IZo/cy81xs7045i5NfSliTXLme1KewkgFC61QcPEWythTBaQ1HiNP3bYv6Zi0kwpm1hstwqJPBK1Z+oRXIWSLWveWEwp6fsWDkgmTDVD/VEzb1uL28FaCjwaT0ij2NwRwDA/v3c8WFPInQc1NnQOi/R/LgNOpxD4M77GDl81dUE3mjnyr2vG50ZB7Jw2ajXuXCac9ihfSGeQJM6DRBdY1TgjX4jbv7x2mbz8nRq12UvO7ReNx0BMc66yB/bvCoVfF8CDsIoN5lLqXfI5UuI2ZGAoRbqrLk0VeyrnroUi1v
 qkO84QCW
 fktX1SYdZRr3MeDRi844Elt1viixJA2s/sIv35tY2WOLLODVteyT90Z5VbkrNyvXWjguUhfl11oQ5FcCBa+ys07i0xk0pFMpNx/RxrF70WyLUQ/c+UPkMfu0SJFpPYmKwORO0F/j6txFuz55sNB32+sFStzOZOS/aLaoBUobZFbF5YdjZEdadOYYXRL0bX9wjflC2caAs2U94WDQWLuR6VD8mpCvjfhekK/RspNvSD012TEk0PsUa14TbLN/q5drTE17L3TOz8g6i4GGdz9PIhpAHUTHjsfjIHn4X3JRCKTiFsFMg+0pADXStbaWVtuMjG/TCfG1aP0EsZXMJqZMzQyC3uFW93dMQ/ibUJC7N+fZHgiOQ//xtp0/2vTCp4rR+jKMGbcIxvEUVlouTkC0c0+uq54e/ZDcvdb/5a6Lr+xjeLOEAuXfTV1HL8m+UZXOw38q3Rcojvb1UyKSrOqjuXDnp/iq/bjqbmBP+Cmpsn7pwBHHPBX1T9OCUpnDiguBZyFwhVEFnPOZejJlQZKKIsk4NZYhPR75nxNyMwAxdNzgS8Js=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a selftest that exercises hmm_range_fault_unlocked() with a
userfaultfd-backed mapping. The test:

1. Creates an anonymous mmap region
2. Registers it with userfaultfd (UFFDIO_REGISTER_MODE_MISSING)
3. Spawns a handler thread that responds to page faults by filling
   pages with a known pattern (0xAB) via UFFDIO_COPY
4. Issues HMM_DMIRROR_READ_UNLOCKED to the test_hmm driver, which
   calls hmm_range_fault_unlocked() internally
5. Verifies the device read back the data provided by the userfaultfd
   handler

This requires changes to the test_hmm kernel module:
- New dmirror_range_fault_unlocked() that uses the new HMM API
- New dmirror_fault_unlocked() and dmirror_read_unlocked() wrappers
- New HMM_DMIRROR_READ_UNLOCKED ioctl (0x09)

Assisted-by: GitHub-Copilot:claude-opus-4.6
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 lib/test_hmm.c                         |  114 ++++++++++++++++++++++++
 lib/test_hmm_uapi.h                    |    1 
 tools/testing/selftests/mm/hmm-tests.c |  149 ++++++++++++++++++++++++++++++++
 3 files changed, 264 insertions(+)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 45c0cb992218..dcc3a23bb983 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -389,6 +389,76 @@ static int dmirror_range_fault(struct dmirror *dmirror,
 	return ret;
 }
 
+static int dmirror_range_fault_unlocked(struct dmirror *dmirror,
+					struct hmm_range *range)
+{
+	unsigned long timeout =
+		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	int ret;
+
+	while (true) {
+		if (time_after(jiffies, timeout)) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		range->notifier_seq = mmu_interval_read_begin(range->notifier);
+		ret = hmm_range_fault_unlocked(range);
+		if (ret) {
+			if (ret == -EBUSY)
+				continue;
+			goto out;
+		}
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
+				  unsigned long end, bool write)
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
+		ret = dmirror_range_fault_unlocked(dmirror, &range);
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
@@ -488,6 +558,47 @@ static int dmirror_read(struct dmirror *dmirror, struct hmm_dmirror_cmd *cmd)
 	return ret;
 }
 
+static int dmirror_read_unlocked(struct dmirror *dmirror,
+				 struct hmm_dmirror_cmd *cmd)
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
+		ret = dmirror_fault_unlocked(dmirror, start, end, false);
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
@@ -1572,6 +1683,9 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 		dmirror->flags = cmd.npages;
 		ret = 0;
 		break;
+	case HMM_DMIRROR_READ_UNLOCKED:
+		ret = dmirror_read_unlocked(dmirror, &cmd);
+		break;
 
 	default:
 		return -EINVAL;
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
index 2f2b9879d100..71765c4d80f3 100644
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
+ * hmm_range_fault_unlocked() path. This exercises the lock-drop retry
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
 TEST_HARNESS_MAIN



