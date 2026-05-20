Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AB80CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42066B0095; Wed, 20 May 2026 10:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1A8B6B0096; Wed, 20 May 2026 10:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30056B0098; Wed, 20 May 2026 10:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C219A6B0095
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:09:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C5EDC17AF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:09:44 +0000 (UTC)
X-FDA: 84787981488.13.FACE11E
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5A5144000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:09:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nE8dWwjk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779286182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HonzK+xjy2hB8uLYFwTsLPswGX7Gaa21jEP54HMpyCw=;
	b=jpaVob7kNSPJCiqic4dmUUB5p/I5iB/s4Q5binUKounTcgtxVgjW7aZpnqTJDCYAGYv2wc
	5ChvO7fWEHqGORj2zJEDqI0lgmege5TyyPKWCnPVHVEzBE+VQc09sVMVTGZOiM7RwPB2qZ
	P8OxcOxlKo72V1e4yWr4bswX2KUpzW0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779286182; a=rsa-sha256;
	cv=none;
	b=tR+xtPnLj3sLy51X0YXYDudD0q+NubmvCaudq3DXZgu38CKW7ziXbiCLnCDZ0Kue9CT1b3
	28C4PXnLTiYMt5xPQg8oRdUuC/qDFiuYraMAXdsmJKrA0vkF4NtUx4ZGMGeHdGYgghkbTn
	VLZ7s04ajwfGf+5GOBiNG/PKhmNJ6/Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nE8dWwjk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-83ef1d17904so4848450b3a.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 07:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779286181; x=1779890981; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HonzK+xjy2hB8uLYFwTsLPswGX7Gaa21jEP54HMpyCw=;
        b=nE8dWwjknvSuI/6EFfo2fN6MjnA+yVPzIZ+k7kJs8mypIGCTncV8pznkmjUh3UTSSX
         T46Uf/qkBx5BasDaGk7BEm1wjNBJweAt65lii+R9vdEo+rXLxsOqUJcqUiCaKMAH8DP4
         ynJciuk3vKd6k+0+QX5fRuhHRBxyahZknMDMA+o/xvmSTkxFsqyCPxt7fwzknmnM2ARc
         80Z/K/ew3IAIksLdTeKDY2uAJl2pQW8O48np9Q9Xbe/s/5bBG0OiHxM1BMkxgdeBX3TV
         JVCDnQ1fwdQx3lM+BCFXmqfF/8Pj0+kUOdGO48NaylDrx4k2mXLH3/MAHRwuoL7HRzQe
         tDvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779286181; x=1779890981;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HonzK+xjy2hB8uLYFwTsLPswGX7Gaa21jEP54HMpyCw=;
        b=D5HQnjwzItBAfH1uUW5ErwqOCXR6gtaA3QXgTCGRNeU+gduJosOkudqCZLKIn0PMJX
         Q2by3DjTlXjfHqSU2Ndl0WLw5UOUM/pcVjl0QfXcbt7g+8N/8Vq+DixLUdTMSGSbJM4j
         dz9r1JN1IV1nE6bpwthNmYHR1KV4OXB9JsKkUMyvlTxdp+OQTqznCGusWRzQxlTqIBfp
         xLjzaS497cujJgV3XTfpLoFTMpDFSU8fx9CYUqHymL2unnXRNR/8aHN9+9nlzGSEbkZs
         oSPBAqrOwA6k9SRJ59yvcUwjiAGBgMFTG9QNH6ghmyd6b3BPFj4ksyMfhzN+dHl/TyGe
         N5uQ==
X-Forwarded-Encrypted: i=1; AFNElJ+kYDCisPKhQzK7dGawFsnKNyX7GIMc/pksg6SUMUh+n5BHL1nGD+jueP0KQLx0qD9GDiF26d675A==@kvack.org
X-Gm-Message-State: AOJu0YzEzzZl4lYuX6fhirN/gqwduLy03Vor28cyaw+WYeF9Hsp0RI8f
	WiDUukNMT9FZGMoV5VZ2NKCXSuiYHyvmY/A6kMcIqVDlsACpanVVpCGq
X-Gm-Gg: Acq92OGWVszH/yiRHYoDfO2ZlzeVcLKhSmQn76tovr1D3oxpZHXuH1Xn54fK03dkPkP
	ojPfAPCO27sb7UOs28PszDP0gG3iJGA4POWwJm6pwbryAyatDX+a4L0VPwy/DZGOO6UUa9sKoRH
	KtvtD9kSFe3IttSNAG1BmTdQ07hgaWq6ueDjxEOHo3l0iJaTQImaG9RdvqLgbnkPPUdi6XrVptm
	kratLWfS9VuaigAccbQNGtD4c0H4hH5+ByqMWYq4fmn5DBi1o9h4SjLE1y9gKZhTlbj5KWPkF4m
	Dt+dY7D22AH/A+nNED+aXe3IF+ywAlTF5Ae2e305so6X9d5KuDB2hq4mkAI2B0WduYE9P6xxcZw
	4377AcLjlVkFWNkLssVAmiZrWB3uQYO4+gZx1CCIGx/UGk4ap+5rUtmx7wNvl14KozqJN+4ohlB
	lH19Iizsnmjgouf46EcIPyH70ewVT0p5j/ybiTQQ//EZkV96UTLdlyF9DJm12nkVId8WNN63v+t
	DXBLbJYoCOK7wvn7IA=
X-Received: by 2002:a05:6a00:124c:b0:835:6d99:3f88 with SMTP id d2e1a72fcca58-83f33d9d701mr26743378b3a.23.1779286181199;
        Wed, 20 May 2026 07:09:41 -0700 (PDT)
Received: from [192.168.0.159] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19c5b71fsm20108260b3a.29.2026.05.20.07.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 07:09:40 -0700 (PDT)
Subject: [PATCH v3 3/3] selftests/mm: add userfaultfd test for HMM unlockable
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
Date: Wed, 20 May 2026 07:09:39 -0700
Message-ID: <177928617968.589431.774568933682869957.stgit@skinsburskii>
In-Reply-To: <177928604779.589431.14703161356676674288.stgit@skinsburskii>
References: <177928604779.589431.14703161356676674288.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5A5144000C
X-Stat-Signature: c1g63w1ntjgh6ez8mgkogcsyi4n5pxkt
X-Rspam-User: 
X-HE-Tag: 1779286182-291302
X-HE-Meta: U2FsdGVkX18NuJRUq7a7tXhJaWq8qedfr/8GWhriCyI8cjwxzAXRJLt01/gdbAMq1xgQrj8mrkY/B/uvGZh6gtKoHpw5tcPrPdRfIUuVyg91oMb17PClvdEZE2LAbi31qInVGI+OR96zAg4MisbtWWoeXvh9SD3nvk/6FvZvrVaCU41CyNR4WVaIMuODTYc7t2ZT16mRxNd3OkizRz0nuTBrmWF4ltvZnVNTPFJZYwDX9h7Cgh0cahLPLQZB+3Z4yDHBw3eE9m1t9exyflbD0ZBsHF/zWi5Yuj4KkDpMtWTh+rn0J2rmxwltp7u1YrFnBVpJXl/snEbR9CQ+jhYUVyj3bHUsy72Hh8QcZLRMBVHZMi5yg/vhDgwlcGwHbuPgyWLlmmwPP4XOJi47Q9jwRddty25CsLQeZX5tjoaZ/XM5xEIBlbNWBfKehuAgOFRIcIJAigWnVb0HA383R5q5gm2c5H0sV4OQ0wpMV81014YP+HkJu6pCOHmamThda2AKnK2uqXPLco0w8HHsLeB/W86FX6+4MvtoPHlj5pHVBnkNNTxph9ltK17PGa0t14CsdpTP7TVROH04ID4NHk1ZSStHRhgJK9+UkvkB2+TuQPQ1jCG5sHPd0kRHI175BZJioi3XIhX/o53RMSOSV64LaTGDvAG583Ci/zdW8XROcoMz+JvR6HOaEvy6ITQK4bEJlsZAJghO7e6vpSPIF9ZAnQps5m9HftT3tBpeDAPzJokWyeCIEQCnPFy4zsfN9GEVg6uiGuhYWB83/CNWB8BhBiCTGwMLyIq7N+sKIb1HQlgx63nd8XBzvLGypLpOaauK+P/48XK5Jcn1hP0Ei0PkinPS5a/7J/AWSmLUgWXuudHhqXgQc4HU/8D31RteMO5YStQuNXeuK9XzQ+GQNOgeZHgX0h01IuGRWZMIDBBvcOGThnF9u58O9MWKr0bgqiTp+qVyuG5UNL52R5lnLvy
 TMICuKNm
 Hl0Jh7ZFA5ggRlNM3wYJRwYCxfppsGVqRWX/c14FcvR18NIuGin0CEM8jvC1YK1fgr3XUjqmJ9VVJdHCJnLbPzuukhJw4Gh3Ks2v7zd+DTjqzkeurZFB0YSCbh/3PKW+C1HlvZ/wS7Buzwb1xGP4XCnSVITpCzN9SzHB+KVat7EmGnVmUN3lLowZ5wsVPEegs5mPH+R1gCsMhi4cvDIkHHc8upfVO/XLHrXQyVMgH3c8Vp0p8hnszgs+92lLHFAVaddgDT2nuHk7KZCzl9SLeFDqjGcfpTs4ixzC/Jav7SQmpqAFGABfqbeDtFkVBtLTDmlOiDRpqRNXIIOxmAe7TfRZsN9ZmTQ7l+QUCiX2GUm17KTEzful7UPeS6abw7puGtlZWM4GuI/2m54Z9HOYJxaOCdo8LhxqZuoeJI/Ptn57uBq2epg+umZ61t10xONarofUdeTu5JWIulSnRLBHr/OymJCKpP6nVlB5Z1t46EUmQxr3b4kL61BE6pzux9wb7Xp/X82bSAuuzCBPj2UbmgRoqiw==
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
index 38996c4baa40..7cc7320c9494 100644
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
@@ -1549,6 +1668,9 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
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
index e1c8a679a4cf..cc5525be74b0 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -27,6 +27,10 @@
 #include <sys/mman.h>
 #include <sys/ioctl.h>
 #include <sys/time.h>
+#include <sys/syscall.h>
+#include <sys/eventfd.h>
+#include <linux/userfaultfd.h>
+#include <poll.h>
 
 /*
  * This is a private UAPI to the kernel test module so it isn't exported
@@ -2853,4 +2857,149 @@ TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
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



