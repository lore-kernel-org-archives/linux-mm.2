Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527A1C531C7
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 21:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2EF46B00B2; Wed, 22 Jul 2026 17:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF986B00B4; Wed, 22 Jul 2026 17:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0AD56B00B5; Wed, 22 Jul 2026 17:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 599F66B00B2
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:44:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CDD2EA0CE8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:44:54 +0000 (UTC)
X-FDA: 85017742908.08.3FA82CC
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id C6DCE180007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:44:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c0vG4vxb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784756692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3cb8/RR6ht/AFgcmZ+ZVlj45R/ECVd/hJBDF8v5cizE=;
	b=PW16nXd1DSn8n+KFWg3hicX4IThkoVifvFztWvrHkkEgoQoEpklFdXQ0fDDpTIwK+PLpTB
	MFsRxIFSOn8869BA0ifZTvJ9+qjBd5I8SCZmCyMh9FgbvgBG9+0BXTotcRTYpJkneWyvCN
	HhY6Fl4OLm2UpFXc4ikFyLNG7sgrtQA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c0vG4vxb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784756692;
	b=bZwMxS65cqQsiKP3a3pmvJqi6KP0n4iHVxLANSiQnmOEF++8+JxDvpBHa7XMaowndEo1bG
	XIVIVB8c9AvUP2fqJnBiYtObAwD0zGnWmXnxuyzRFHn/a3DxHB4NImmTx23EAaX/MrmllG
	ow7E9j3lW7c9UC+XaFj9JJWi8AIc/Ps=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8487088510aso13122680b3a.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784756692; x=1785361492; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3cb8/RR6ht/AFgcmZ+ZVlj45R/ECVd/hJBDF8v5cizE=;
        b=c0vG4vxbHi6gMs7CXPVXzpyCkDCQLhaIvBIZZ46n8usHinGgPiB/uVJIxuU2RyzBHB
         EtpDKRA0kVaBP8gLVKK9M3euW2SpXIAwY2MlT0r+bpT6O3B5DV0mWPtlsbqUuVTai1oE
         xvqT+T04pFxL4aXmJYEtqVTGasASMrwFieVykeGyoVEo0lYd2I4wHQwUEDf+A5DDnxG3
         eELQwCfYTxE7AezQR8Mo03wgsJM5FQuONrQSXo2cmo3xs7vZZOneT3EUOjLVIoKy7OfR
         UPXDfy8Lw+6XmbTC1Wy9mQD3N+/dE0kBy9Uos6Vs8KRdBrZbK7iHJvjlZql3KuccMhuD
         ktXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784756692; x=1785361492;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3cb8/RR6ht/AFgcmZ+ZVlj45R/ECVd/hJBDF8v5cizE=;
        b=gjFGRdfyPokpPZAYjek0P6FmGP7oxydtuuWHP7hNNVrOHUFeaGA0f06wTB0SeexvTF
         KnySt39WWw9V/5oYlRUShWV7vbv4F26J8kScoadeVB3o8eiM3BPrHVF+oeO3/ksO8PNu
         oqouxHV2wWtOR/e0046N5/bLrYUjZR7xPWhX5R9j4IyUI+s2zAolMLK/LRuFQ4p4P2uE
         gcIv84iabXR2Oc4iGzUYBsRhuB/p5pOzJeU1vK7DW7weEHz7PuFNglAvcGdI1bcwyEa/
         pvD1Emdxq77gmS2qRggGAvaZ0PuzHI/9Vj57GVictEH9R947+fFPNp8vnO6BoQe3kU8c
         F9cA==
X-Gm-Message-State: AOJu0YwaEMrgJgav3Cmd2A94iiB4LjlBPvJDiupznBW+3YHN8CXOBimA
	1c7iwT2Lf0L7Fw2s0yc0/JPYNgrmXzpmjpQ/s4lFUUSIqDYVVeB8ZyrY
X-Gm-Gg: AR+sD13F2sPriLPmPuNnadm3TX8035mMzr6ZkYT/HyFv7A+xdMW4Lzyj0jqJHscr8Qg
	7I3eknWE3kEH3chNXqT1JIBP156TXKAyQArrTDOk6Ju1oEKkgJmMoyb/ihn8o4lzsbI4stIIuOd
	1DFMb/gd9zZjpVwqrwYm18QnPurVAN5t0zoRQcV2MG13fCIhDVaOXF9JVgC8dJe2PLpDKwt8Rcl
	VeV88b8R2LNQ2OB1ejdtS/Rq4sb75fjXB+KPc/k30sUMpxq/SuTYFBd6ohuErAp5BVNx5FfYRow
	9T0ZEwNvQP9QZg7yfbF1URPUHRDssDrkrYTW3+G3UHVAYp9JrhNmo1Qx6sTKGQAE7ZVo0xPrYYH
	TZmiOycsBesgWJkDHCLD4wuzYsS0u/rp1M3StA6hV7khxpwxXbhHGAuBok6L0AssvQ7R98RayDn
	K9cmJZzSyKk9DdSmvagvccELnGHXJ2L1A4t0xxeTkAMJoIn1giVns0iz+t8PM=
X-Received: by 2002:a05:6a00:39a7:b0:848:7835:bbac with SMTP id d2e1a72fcca58-84e2c230baemr657561b3a.65.1784756691553;
        Wed, 22 Jul 2026 14:44:51 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17237c3fsm1946297b3a.9.2026.07.22.14.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:44:51 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Wed, 22 Jul 2026 14:44:25 -0700
Subject: [PATCH v10 3/8] selftests/mm: add HMM test for mmap lock-dropping
 faults
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hmm-v10-v1-3-606464dd601a@gmail.com>
References: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
In-Reply-To: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Min Ma <mamin506@gmail.com>, Lizhi Hou <lizhi.hou@amd.com>, 
 Oded Gabbay <ogabbay@kernel.org>, skinsburskii@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784756683; l=9280;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=AMv7G8JGzmbmB+WwCDHthj1N45IFPqE+bBj6HkmdaG8=;
 b=jxDT00qgIp0eckAnCieFk/yrH4UjraxIJmUAkidlQfO9sY38TOaO5atlFw18CN2G75txgsawI
 w9ZNh/wRC0pA9t3+i2E84MWvjLWEgZoL8WEkW8uvNLBA7ijJ2Vro8vy
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C6DCE180007
X-Rspam-User: 
X-Stat-Signature: ox775fbc5s1stmc3ee45rw6woee4gz8w
X-HE-Tag: 1784756692-770138
X-HE-Meta: U2FsdGVkX1+RFH8c+TawuCZBM5P6tA87wmr9RlTkUMMpshEZrZcPxUZO1fnaaSGe6UM1Q7iZFMPZH61UM+SLuHhDdQMeXOmFdf0oOtLnphOMjxblt+cUjWrBKKtHucrvNqND0j/lFdj+SnPfPImoXvzKe6iN1/h69VSxkN8ABHVJYxZRk2nyjj6VLh0bGeEL0aYE51F5cQ+J49AiBLYsX/zEcvju3dG4qB0DQeJeoem1ObIWV5mnk/ALxhji551nI7Rbu3GHqObla4NXssXRecwGfANJsU5wiLAN1gIyNHnSjzAd9CEER+RofU5XEDMpITzf1lcSvMJKKhZAaroUy23eL98rqSrGEUlUwVi2s5/e+gVrk6xsqpwtRgX4uKGIuAuZQCsg34kaH6EawRgYsJZ0CbsT/ThfpK1aF/Inn+QqjPCwOmWbgB3adPYyw9My9+Sx6XVxjVPmdGyUD7ErlrwrVHU/ufkA9D3+wLhor736T+edP70akSbUYeh8LhP6IlzOK2Y4okmkjAzI4DoJA5BnfEkf8fj+F8hm2M7onzJ9LRHULbfavPN0HPWX/aOFvPb/gMMCwK09kOAmUcMokzZSfhAZjuv+1jhbi162eNN5URBEKpah6M5nBf+l6VhJqogfx/+ysvvlQ0I7ELaNMHmQ+523MQS7Z5JMe3Oh2FkYxi19gDSYL/d0wwIZyG8OIjNG6qwzTPrzfnREnRrmjDaM4mXWeZR1njbAFNDd8EesEB5+3rhIXo24qmnjVPil+byKwYtuvDKKSgaeotoboblNIEftK/Xz0JU85AqSjk7Of1pu1QLsWqzo6g4rZ4Li0Pi/UoOaZpK74jLp6FGWmGsvRMO2+7SamijY0QtPMogsiIm0cd4Axt06KEhQyKxf1xbPyfPvdZM3fkILZzj4oFb/EpWKz/oHhUFTBL46lsgab3iAKhsq9AqE0POgT0V6OLhErV7W5m34s9fPUTe
 poxLkWXF
 VTxTNs7NppyBx//aSUl9KAwDbTyzOd8Bo26SV80q7h8a61Nc8lJs7us7tB6f5waXQR6WDkaJzLFQmcDnNdbXl6YNUQBRtRB4/703sob4plQIyIcuRQdY0tEybbSEinQykLhkv5X/XNzOtHGIvKkINFHagkzwE+2zszYP1jWeXH6/bs1RkrtYjVAtJRqPNIwqtB7xmNwx2knhhBj4oIk1hyTNkF31zEPvbRGKeck9zWG1//756geelwOGJY4msKLC8Y6mgTCOHv/cGQO+p4+lgpEfRcygn/kb3BZwV8CNKn75M6XnluKRnsLxZPoEvHuEmw/t2Od7u4QhNlipxO9GICuLDXthWX9gegQi+ymiV64N6BK0aZ0GIbXCRSW2xlr/ALQR7QiiolvTwoW/6DfTzr7ADe/2LbG2OPUJoOOmJMqqWS7dmds2L7ZHSoN1E2lUNRYjPaHzsYmFFk1mn69BzCpZV1oBv5S9jSwNymWTSSYSWhQx9LhWpl6dhFhsYCIyiuCn3QJ8ec+MaGnW/abmwX+NHRUJFE9LrrcxRddJ7uNk6Iwc=
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
 lib/test_hmm.c                         | 107 ++++++++++++++++++++++-
 lib/test_hmm_uapi.h                    |   1 +
 tools/testing/selftests/mm/hmm-tests.c | 150 +++++++++++++++++++++++++++++++++
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

-- 
2.43.0


