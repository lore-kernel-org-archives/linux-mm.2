Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78BD2C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692026B00A5; Tue,  7 Jul 2026 15:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66A5D6B00A6; Tue,  7 Jul 2026 15:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580A36B00A7; Tue,  7 Jul 2026 15:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 297616B00A5
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:47:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3AE31C8279
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:47:13 +0000 (UTC)
X-FDA: 84963014346.10.138A18C
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id CBE2E1C0003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:47:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PrBiMF4l;
	spf=pass (imf21.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2IYT3wu5l+zIbtBD2s88iZ7TNagS/VHstd2UWbDbN8=;
	b=gAZqZWv7ZQVp9ARiyb0FvkwVCb1WMZ5oXR6FfRhf5V2SgUEKJIyh26snJwUAXbZVyZwRQ0
	Rio+KhK5dIkmJmB0PYrYkBK57G4NhT30mCItQXEA/VmkIDx+UoKqOpr+0ME69y2yXTYfZW
	iyhx1S7bfu9xT38u4fnyP7srw002nLI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PrBiMF4l;
	spf=pass (imf21.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453631;
	b=vdvcE7VG1Dt8UBgzfnyNQz1zcmRq8movRNK3zDIt1MJCI42EIYnl/w0gUEa1b8AG8ZaSOt
	CYD1qXC/OkRbMQMnA9X6tJAu9PbPOGZ5ZbbAYIvVLTlzTgjdfyM0WcYkHHMF1CLAV2UW28
	fR3Smt0nkcH22eFwaNsnBd48mF2U1Ng=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38759bcd877so1472172a91.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783453631; x=1784058431; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L2IYT3wu5l+zIbtBD2s88iZ7TNagS/VHstd2UWbDbN8=;
        b=PrBiMF4lipGDehz3Jjq7+Lmp3VDye6xI8jCtua9dQqR8PNbOulNR1UPZFB6ZJjGVbX
         6jqWkjVEfPcoEjHeysJj5b+lCmMNaGAvd1VvlwFbuPAw20ZyEED8UYcxW6ymRiVUO+gn
         /pF4wsF3Wk4K5hiT9pVKPjW+EC2VmE7gtvlNpk3ltXRoOm2EfLE/pmDdb0lb2bziXxDi
         8XFpbkH/t79umZfJ9L+zbumQyPLAp90M76goN0szam4/qlccyyI0d1X4IBRFQEPumgic
         VJbYRnpBXGFFQDRve+h9GCkd7QFm0L4KRZuM4+dewHPK0B/RyrWalAk6ktZrOjOivQ+7
         eH1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783453631; x=1784058431;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L2IYT3wu5l+zIbtBD2s88iZ7TNagS/VHstd2UWbDbN8=;
        b=opGT+O+H46w476LOHKocW9aK8Ip1ifDaVk5kaFANNPqY5xPp/cqlKZyjpFxvhACuj+
         o31cfbSKTM3se3Nu41wBwyX+vyh3CadvlW5OgwdBWDeTX4zh/pdUx15vj7tj+5fzaoiA
         4P6e7Fi0spxKrJELCjf1F/8mbYfbGp3YumBoErXkI3TPxnw/qpwjZM1BQ09zrgvoa9qc
         zLSOhQtT+J1WJ5dxhoFxT32rxdXMXkdcZOiAvp5DJqrnuIc0Ao7dpOYqLCVLP8Yn047f
         yDpkErE2Y1IdO6+luFPzSKERNWf/2/qr/wgR2J0RCKDIEamdahAcV6KRqmZsKnri2pcm
         bnGA==
X-Forwarded-Encrypted: i=1; AHgh+RrCfMgxaP2b+DaANmBLsK7vyVu3R/ypHbWWLHcsCazKXgU0FqRYMS41RuU4lMi1B2QmKHzp1YXqkg==@kvack.org
X-Gm-Message-State: AOJu0YwmoItw7Re+3eYf8bX0IpXOpS2uWbfuXQDUwVkBGC792uLFs3ml
	O4wUBRb7GW1o9b5oXbdZphAVYSEfdCsD3+7NewCMpkpc3Qj6XFMuGEO9
X-Gm-Gg: AfdE7ckweiykE8tVFzv9Q8BTX2V0Isw12+e5JHnCcEjsxHg4jc7Bm0pS/2SBkogPhXh
	Im461ANfsV3WXaXtKnLq3QfYel8dzkrLOC5oNtF9DhPvCSY5TcjUl5c5Uusk7+ok/KK90J27Vto
	SlkYHgCTS/ouUB48VDEbZy22pnukY2X9zV5gihY919FOfIn7417oODUyRwasb1mXK9lK6od12qZ
	88H+gQ8l7sFNWOwx6qA3zr08jzfCgItELgqOjdkW6JOvw5SvtQ6MaQSXd5grY1jnHHxs4c8ciHT
	1ScKAza8xs94cHW/5pkXhifYWmF7vEBfF5ia1BCrfLnrSJ8eUnM7SrG9QoDwKdpiQzy044esuw/
	QAmAzyAfQVudXIMGhGrnCvTiHnr+uE3QtXWjMQ5VIzblei2TV/vNL3nC9XCe3GukEPta6nuRcto
	LYsV1sQds47asQZgrR2WEgLxBFdAYXFxitr7M1Wqq8vhXl6iNsEUB/EBP/2js=
X-Received: by 2002:a17:90b:5683:b0:37c:607b:2cd9 with SMTP id 98e67ed59e1d1-3875298135amr6064743a91.0.1783453630717;
        Tue, 07 Jul 2026 12:47:10 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-387d36676desm1639922a91.10.2026.07.07.12.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:47:10 -0700 (PDT)
Subject: [PATCH v7 3/8] selftests/mm: add HMM tests for mmap lock-dropping
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
Date: Tue, 07 Jul 2026 12:47:08 -0700
Message-ID: <178345362882.660027.7469490514544148781.stgit@skinsburskii>
In-Reply-To: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CBE2E1C0003
X-Stat-Signature: hcxk6unfubkorktiotp1ifksb3ts89g9
X-HE-Tag: 1783453631-202001
X-HE-Meta: U2FsdGVkX18ioMJj8GlWOW6xPc/ucwWYHAc9oVhECiCMlvcIiKQ+ez5DuhuJLmQXdCiQDN9BN+p16EetuhnH1kNu8MxMxpkVt9UKfUhGZWFyaMI8Y/ldveNaTEHvW+CdZjZsOES7ZJuIxpJEfZF/AIXFHdS6cCffZGgT/q6FoFTVxRK9BnwtCc5WJiTAjSUVabydVJDvz/abHGTLCKqBQUtbi9KHO4dT7CFWstrJhNsda9dXXkYSvF7WHbIA3fVQeYgQkrkwfFiEM4LQksa6LKjVx5PVUPCTXM+caq0PlnmFapc7zz6ZMHn9g4LiMUTpfuLXYRp9wVS9Ff3/6r9ZCV12hcxt7g5EaNqisqQeoWZEzay0etv5vR6ZOk0CpnZXPm8F7CK4GR+CXbDh/ftXaVh06dfZHw5t7FPqk6BDnyQUT7UMg7rSjiDxjyOUR2njvWkFNLIxvJa3fbuzVCgkBC+tF38P7o1c+ZjPCoROnkQD6MRUoBl8ELzXIwjUutTsexGG6cYQ4abA8gGh9DeWHSuqMNKTCq21CF6vi+1IlGMENnGNtEMWeGVEOH+PaRINfBPe3DS/H0yRt1epcog11fSU0NCwXQ8QVc9VfIj/LI7yEcGHffBmrGPWWY+e06B8ZB9+Qzj0xkU7pQ3LqH7DmwFBuvoZtPqkkhzfJOJsxRYSENI2CUdc9hJ8RoIRNMSppzJ5ZRuTwGMb69+iV68ORk0efz11OmRl1Ih+7acSCVHlBNDHDTdRwtcj4Mi/MgOHsSN+ukgDnr5dvLxSm+GGGklHobLOrqQcSjDu9Gb1QZtyfCtnvpXHohaaeqfg+f5ARvwMSiCydF01Nv+mtg03EsZksi6pXvZIlWvXUaVo+yCv7hMzafumdFHECqsxoAAn1csDOgOuW2BN+ZDSawbcQfVMESNcpdThGOa7bbm2SUaCbDE/Dxwux/0pVAIUjF+o1DHjoyW9DWleO12hX9S
 eMRJddUK
 0UmuAttO4AprWFSLAvWJv3uirreKmfBhmDXHMYmkSKLqxCD4oTpR6js2Kyv9LNUzVnTl0Rhbn9IN9Bd1EsXFHgTACWjeWxkRQM+ntkhDlTNORDqlGbXWNRsA9DFtDtZU0DZM2BWUdXkOrHYjXH2Ss/zbgtDFLKhJM1tIDbUiyDJ6m1qLrHKX7opJmC+/S8p4FZZCGQ4PWqLit/272TYtsCpObCipMsgMqgE059nhG0EPhEbVdku6S101p8xFAy50g9gu8hPZE91cGKr0hseKSceqsBaOwaYITe8KnIP3ayxdkG0Mn0bOup7FzfXiUNYZwMPW+jPQFNA8BHOcArph0ExErXCK6hOLKy75qIvCNEJwsXeTBvWfh621joEpP63sl+jkfCS5cbK9l6NtzPfJOJbn0kbKjeoaHS2Y2qgSscgGViwVwWDT3GxBCvMFUu5klJ6k8AsPsdYDzsgKA8SpuMeKSHtDiIOaJ2VFCEM1beprKP9v7K946G2FX/uGdIdSid9O2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test_hmm coverage for the HMM lock-dropping fault path. The test module
gets new HMM_DMIRROR_READ_UNLOCKED and HMM_DMIRROR_READ_UNLOCKED_TIMEOUT
ioctls that both call hmm_range_fault_unlocked_timeout(). The unlocked
ioctl passes a timeout of 0 to exercise the unbounded retry mode, while the
timeout ioctl passes HMM_RANGE_DEFAULT_TIMEOUT converted to jiffies.

Add a userfaultfd_read selftest that registers an anonymous mapping with
UFFDIO_REGISTER_MODE_MISSING, services the faults from a handler thread
with UFFDIO_COPY, and verifies that HMM can read back the data supplied by
the handler. This exercises the path where handle_mm_fault() drops
mmap_lock and hmm_range_fault_unlocked_timeout() restarts the walk
internally.

Add a userfaultfd_timeout selftest for the finite-timeout mode. It
registers a missing-mode userfaultfd range without a data-supplying
handler, then closes the userfaultfd after the timeout window so the
blocked fault can unwind and hmm_range_fault_unlocked_timeout() can return
-EBUSY.

Assisted-by: GitHub-Copilot:claude-opus-4.6
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 lib/test_hmm.c                         |  111 ++++++++++++++++
 lib/test_hmm_uapi.h                    |    3 
 tools/testing/selftests/mm/hmm-tests.c |  220 ++++++++++++++++++++++++++++++++
 3 files changed, 334 insertions(+)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 45c0cb992218..02a98887c290 100644
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
@@ -1572,6 +1675,14 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 		dmirror->flags = cmd.npages;
 		ret = 0;
 		break;
+	case HMM_DMIRROR_READ_UNLOCKED:
+		ret = dmirror_read_unlocked(dmirror, &cmd, 0);
+		break;
+	case HMM_DMIRROR_READ_UNLOCKED_TIMEOUT:
+		ret = dmirror_read_unlocked(dmirror, &cmd,
+				msecs_to_jiffies(
+					HMM_RANGE_DEFAULT_TIMEOUT));
+		break;
 
 	default:
 		return -EINVAL;
diff --git a/lib/test_hmm_uapi.h b/lib/test_hmm_uapi.h
index f94c6d457338..249ab2d9e3b2 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -38,6 +38,9 @@ struct hmm_dmirror_cmd {
 #define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x06, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_RELEASE		_IOWR('H', 0x07, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_FLAGS		_IOWR('H', 0x08, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_READ_UNLOCKED	_IOWR('H', 0x09, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_READ_UNLOCKED_TIMEOUT \
+	_IOWR('H', 0x0a, struct hmm_dmirror_cmd)
 
 #define HMM_DMIRROR_FLAG_FAIL_ALLOC	(1ULL << 0)
 
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 2f2b9879d100..dc031d2e2aae 100644
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
@@ -2949,4 +2953,220 @@ TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
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
+struct uffd_close_args {
+	int uffd;
+	unsigned int delay_us;
+};
+
+static void *uffd_close_thread(void *arg)
+{
+	struct uffd_close_args *args = arg;
+
+	usleep(args->delay_us);
+	close(args->uffd);
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
+TEST_F(hmm, userfaultfd_timeout)
+{
+	struct uffd_close_args close_args;
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	pthread_t thread;
+	int uffd;
+	int ret;
+	struct uffdio_api api;
+	struct uffdio_register reg;
+
+	npages = 4;
+	size = npages << self->page_shift;
+
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
+	buffer->ptr = mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   -1, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	reg.range.start = (unsigned long)buffer->ptr;
+	reg.range.len = size;
+	reg.mode = UFFDIO_REGISTER_MODE_MISSING;
+	ret = ioctl(uffd, UFFDIO_REGISTER, &reg);
+	ASSERT_EQ(ret, 0);
+
+	close_args.uffd = uffd;
+	close_args.delay_us = 1500 * 1000;
+	ret = pthread_create(&thread, NULL, uffd_close_thread, &close_args);
+	ASSERT_EQ(ret, 0);
+
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_READ_UNLOCKED_TIMEOUT,
+			    buffer, npages);
+	pthread_join(thread, NULL);
+	ASSERT_EQ(ret, -EBUSY);
+
+	hmm_buffer_free(buffer);
+}
+
 TEST_HARNESS_MAIN



