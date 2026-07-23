Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB821C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC76B6B0092; Thu, 23 Jul 2026 13:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E326B0095; Thu, 23 Jul 2026 13:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F0B6B0096; Thu, 23 Jul 2026 13:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 781546B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:36:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0151E140114
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:52 +0000 (UTC)
X-FDA: 85020746706.04.F718EC4
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 25315100006
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dhIspb8W;
	spf=pass (imf05.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784828211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3cb8/RR6ht/AFgcmZ+ZVlj45R/ECVd/hJBDF8v5cizE=;
	b=cgOYJAUjXLQICu4I4TGGKMJwYHcjgAWiyEVIO3PvhRLfLgTJwA0Swcsj/z9IjEQz4sxdgR
	EalbG9GHB8vtJFqgAKqU35bx9skO+l/TqdeNM9mYEEkv7jlzaOvySzJPo0DM6BcL/HcYIr
	7bGObF7Uf6MOybLZqkk63agVHfBhDtM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784828211;
	b=5a9scjFPdLSRdsDbTJs4VOWLpMiRS7D/9kQyfyOOsn3js7yEtAohdKpDKJ8lx+e79dGhhK
	ZK9/T7JRihnBnQCg3mEYKDE7YArfFBGaq078Leq+G7XogstZCMz86iEk/96Wzrj1d9l0mh
	msOeZaxA7250S4KiKkno1sedljOjcmI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dhIspb8W;
	spf=pass (imf05.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-845b6d9bf39so906461b3a.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784828210; x=1785433010; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3cb8/RR6ht/AFgcmZ+ZVlj45R/ECVd/hJBDF8v5cizE=;
        b=dhIspb8WDjEB+nCYOI1MLxvRSV8dLV3ZlJX5bo09b9Cn0W8sJVMaEayivH6bvCwPWy
         MzIvzkvY+seykK1FDHY5Ulv/ZrniM5L5tH/Xw2ZXXqbqO+N0VjK4iGV/c7/7Jy+oAqNw
         ZQSM0/rlKoMiDjVnUSfs30t2zZpqx9xJFP5x43SkaqWYK7F3tO9KRlVQqhFBrA+mawN7
         i0X9wm4qXMhrgSfmjvYd24T2EsfcQjshJcA8TVhsgEtIfuQBUDOdj4tk8Wu7ktBew+yx
         MZi3I1EP/KUHPtZfmPzoCceO8tQSx2cje0eTR8VaHT8pJYSeeDfvr70M8UL6J28vH2WB
         QdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784828210; x=1785433010;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3cb8/RR6ht/AFgcmZ+ZVlj45R/ECVd/hJBDF8v5cizE=;
        b=E7YUYVl2jTFUpmgNHtxXUJ0FXddEfZ4HdhewMXg/isOKkxgKrihQcKsDPKD7Giq7A5
         jcG+cM9gBb5/fSXoCimTtBrxfdJEUUmtWgUe34R2fTmXYvdR93VhuhEv9c+Ww03YqY34
         GDpROkeGFwSmvZqpJIkqRSdJBiW1HcxZpMYd7fLyb410TnF++UPJ/atQwEcfCd71jNbK
         1RZAXem6OhDOMJdrKBhL7Di6WSr50uOTEyJS9R5s6jf+rI2PyU3dzPhIYSlaydmGc5QR
         68fOVTkrgDqVnJ+8oBpQVZbOnIosu+Nuo1HbNOCia0vFsg4uspWsIalN9vQwG6ij/e94
         VhQA==
X-Gm-Message-State: AOJu0YxKa5QbY9LyChlG5Pi2PidjJO/Ac+1BIq2GPF3B6x54FEGEyvvJ
	TWrvXDFUrOWcL2oS5ZkGl/MTYdHQXgw6H/kQri/cvCO4tevvJanmHDrh
X-Gm-Gg: AR+sD12bbrjcsCMfLDDKDJZ3L2sAqC3Z3j2+1vjtuy4KiwsRE6lmtVoDWkT7bNE4sMA
	tIi4FWgpcXEHU9f//cqktIQMggoOTEhW32808aZwgbzvo6KN5y6YdkWhyUkOJWslAxpBlzaYzZ2
	/kCzgbkDxFaPufFfjiexM0qVx9m3srk3Kt8iJVp94WfnlMwv2291jwr0Yk5flXp8b9Y6GyE8cZE
	ZCvxXZQOAa2X0QgfXjWM5Jjkql9tB5SWr/OPu4AVMQOckCkHUE0Bun1gHRBz9u+4RIeVNvyUREm
	TIF436+r4krZbqvxk4gqxVo24D1zbn49pQhY/k4BUDEHZH4s14lmUsM1JspHJHE2HuC0FHRD+E/
	G8z0jRdA3FehKXW/zCw7tJhlndh/98L1raLJbMK7J0nGObWNEw7PxXllbI5guT5T1qp0CvZAHJR
	OcQ7ht/8/6qOSJX/TZiTvbX7i/NX6DThX37m6ORG4fZwk5xWSM
X-Received: by 2002:a05:6a00:1743:b0:848:2a69:97be with SMTP id d2e1a72fcca58-84e2e83fdd3mr3652722b3a.10.1784828209948;
        Thu, 23 Jul 2026 10:36:49 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e20622dedsm2691612b3a.11.2026.07.23.10.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:36:49 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Thu, 23 Jul 2026 10:36:35 -0700
Subject: [PATCH v11 3/8] selftests/mm: add HMM test for mmap lock-dropping
 faults
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-hmm-v10-v11-3-c55b003a4b61@gmail.com>
References: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
In-Reply-To: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784828202; l=9280;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=AMv7G8JGzmbmB+WwCDHthj1N45IFPqE+bBj6HkmdaG8=;
 b=BuqNY2TIJTKZ+JDj0LwhTCH9DL3tOw+s1oGAQTVqbv/O0Es16a2w6TtDqCrW+/bkwYm1G/T+y
 TC27ldxQkp6C6wCnvMt0iWL55Wyx6EropXrTYx43zSnmS/uz5vWN/I1
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 25315100006
X-Stat-Signature: nbwgairgjyb6wgc8tyetwt98iomuc1di
X-Rspam-User: 
X-HE-Tag: 1784828211-265266
X-HE-Meta: U2FsdGVkX18bE4GuCHCaIcr2JqO+1PzPKSuo/nD4bLDAwnGsJSSEZl2CJXY7sOEPhBVS7RI+JFyd4DH+YAof1e33NpHZWVCSu3FGNJw1HiSlLkOwviLuv3p/oTW72f7jARHC5rFbxM9q5FEGLLP1NvM5KCO9WWmhwbK7rERDAgwvSFyzu2m+n/ZWpFUdi3Tz9wZrhRC/y12umvaJBemb0wvegqpDQe/AShvcj7sPia2qca/FIrpHgd5dbEAgBPUOVGdmLrDhIb94lB2G8QTLfiq2Xh0q4KQz6lEXaCop8ywwXA2Bus2CpLfBUtXCA7gcKUyZWKGOApzCqH9WPOmRXjLPeRvcaB8TfYHgXt19x5w6vw2FZuTzvcbrgdDsYgzu5LElfFBbi/KYadRoSjG5OeCaWK0aIEBF8lelUe6mQ3TNuV4MM1vSp0TWWVHa4P0TT7pEmFb1dLh5VuRC45xjcuNs4KZq6fyfVrzHnzAvdHX6K5xp8I7nSLGjBZ2W3Cwxff92ZYRKg+pg/jyPwIosG7+JqDCxf77oF8DxjMCkaSdlATANENQLibqe5fKt1GZpa8JcRPQkVnAxDnYrZ2UCG1qMr7WvTOc61JHyZslsG6cGUVtMlk3Py9IG4M4Kpr1fC4tJsEd5zE7/TMINQjUIJJrjbFIaAXW9oolZMA5tIbrFd5RgJWS25g/OIAnSfgxpnMShjc/vYQDAtAPqFLB5v7WjztML5AEte53+/TyCnEM7PQz0ccQlqHZxAnyaa8Jt+y4ZaTfpsg/Y+kLWrFrsmYzMn8zouoKHNGA7P5vvXl7hRBdZVn+Jf+Och+kbr8i4RD2v1ObtjQRNR2lEDGNuioIh0nYOoZrORriZPT8z700ZtE53OFEbFlcv9npoDF0GTIcN98V1u9TBRtUhsA7vCXmyxVgAK7Azdf3F3MIoS7Pzn0nsqr6gZIggxhWkf/kLEUh1SW/8ARM+7ayCRQM
 H4v+1W5s
 1h/qtqr748o0p7qlmu756a75byOC32aJ7udxX61KcoMpMjvE+Buo+lARfVJj9plfEtiKRnoaPc6Bw4jYrWb4n+bPKeOkJVSNHM/8Awx0oVcGH0PmslFFtpREN6//OyvKwa/bb7raYhLqTHPMyZOOuSP7y19L3O+Bnpnh7AgPh/rJgmMacUUgHU/UiX7ohnn66k+D+YRT2MRH7XHWkAUgOBcO0MiNRWLw4Cp86MH+xZVARLCCOOeJzMDmWzBNGe90HAy/12mC+fLJm8tb7Q2mHrgxJN5tmnCya02lJrq4hYAfoCTIqJvdsIxh1PpzSsNmG/9mVXK6ucXPpvS/HRNUc16MzlXaq2dl91N3V+MDP+qPD+qgkF8yR5vGrJXVIOzs9mp5wfQMam7nzl6jCjyNidcYloftTsaTN7KAtiRrP601u7W8ag8Ifag+xT4kD7qY63txl1p4UN9QjsJdzSpCohBTTe6vt//saVkgoXbR+B44l+zUSz70BZjFIulZ27HiT01STDL1oKNuTXnI2xGc/mIJd90whCxAm8AVIG9ySQJaBKMk=
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


