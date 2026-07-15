Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E9FEC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16AD36B00BE; Wed, 15 Jul 2026 14:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142056B00BF; Wed, 15 Jul 2026 14:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0585D6B00C0; Wed, 15 Jul 2026 14:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D00E46B00BE
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:16:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61E9B16024E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:57 +0000 (UTC)
X-FDA: 84991817274.26.540B79E
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id 850D6A000D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JtwmJh+Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784139415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kQ5Orso9YJMZEBfqLHTmR8qEZ0VQA0+aPO2YU4j8nyU=;
	b=759ssaW9n1TYG6JE4KiJZIcbdYBpgWE2huqQ6BnGGo4vQYKEeX6meF15F0ZpPdX4Ss6Mwz
	N0TPJbmSTA4mxIGgPhwMOFHe7ijLE4CDMGNgl9AXp2Gve/6CEJDkyFpoHEhTYb0ma/N+r2
	2KuFFa9S0Q9z7O1gOEPK20Sx24DKsMM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JtwmJh+Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784139415;
	b=LvNx3tNjRrN1hRVE3Rsv+ifu0QDQ0BkqqZ7HrGstfwJ0QI/WTDmpL5ZeUq+MI0PTrDYBxb
	kR6rwARExLH9U3UmM6NlS8gfpyW6y7J/HQD/+I5D3G/bjRlO9oWveFlfD3UdNAtx0BlTWE
	r1Uj5YItqmPuymF1wQAISSkYNsoziyw=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-845b6d9bf39so2580881b3a.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784139414; x=1784744214; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=kQ5Orso9YJMZEBfqLHTmR8qEZ0VQA0+aPO2YU4j8nyU=;
        b=JtwmJh+YRqqeucrHCrK3ha/VSaNb3fjcyZpTIAgkA7NnkBitYaNA0uR073X/ehu57s
         cR/kqwJHV5QEwR35X/HJure5kEb+kmLvOCrbEKmmwcvJn0mV+E1HXvIOgPmUkNfZnlw7
         +gn+/AyKk/y9Q48V9kkPB0kMPG+JX/UArRkxSVG2OpOpsJZ9972rXA5VPUHXvUW5amQH
         17XQ4+gedu44I648YMMj9j03Pbyf+rsjEj2iv13J+eFJLp29o6BteMQyGqLyEap4ILfX
         m/8CZBS+nuAcTFUgd6rryikl85UhzWMhX4eOfO/r31AeZ19797jT/+EsbkCRPn9/XsWK
         0bCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784139414; x=1784744214;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kQ5Orso9YJMZEBfqLHTmR8qEZ0VQA0+aPO2YU4j8nyU=;
        b=X4eaKblUmJtHw7KvUKKdG4HL0dttG7ZJgQ37MT3h8FdBj19N8c+PZqvPWnixmJmqRy
         /+OHXzv/xhk44NJbttLArBn3hyNNvx8HKRIrq3b1YGbVliduZjvHV1SwhCFL9vhCIKlX
         gq5q4sUhKNkAVGRoFIRcvzX4fx3+C9sNI6ZLkHh0rDXsqz5azTG5ZNeXMkYKRNjveX5/
         i/OBXCHiXu89U/yrLb5PKbbIXUEw09hh2jbwSKaz4ryyxNSPKQXTbmQuO+BVi+43KpSr
         f6V17jr7N/xIyr1tWy9iQsq17VZlAWYiUDhYMGsE4SKVcQMMJ7/4w9xITZkPQYdXyrMG
         qFiw==
X-Forwarded-Encrypted: i=1; AHgh+RoPKQR4PQ8jiri6nNN8NClltymr+bgfHXnDDkBLbX4TdnJ+InK8I96wApT3r8jzI43mkGgkBf8lpA==@kvack.org
X-Gm-Message-State: AOJu0Yw9CB1l0D3Gnf2kArRLPToMj8CgV3CoAUW+W268bt5czjlQy6s+
	8Dq1zfL0Jcsb9odz/up+aNRmXuPKb/5UwBibOVx+Vb8Aw8vdHEbziBGw
X-Gm-Gg: AfdE7clDLaH/WD2LgRqW4vcX9zFuhHPPk0rEiRTmBTD2aG5h0I+nHP9RHctHxMpUhPd
	Uv04//nzbZymp87b5mUUAt+3AZizKbGVBxL/QrxfK/jCaoItalCy7isG+B9PZ044FTuzVBzRqCL
	aQwRbDiuae+rEBZZtKQlI603m1vQeP+OjW6kYFiyFpVsmLHl6FzwdF3Kjo5oMTQjCje4NKJwSBi
	egiaNhlkgIjrIQiJmkFOoJjfobJaX91pXlPXJPowuWh38RmhlZjQEbyhSCRuM/SuUOw97JFQNwB
	Yv/DVu1wVMkax+nuwCIgq8Rmj5ZuyYsBYsAjGaJjnMnD/jVKwbp7Qwn0dDjjwdSYladgDCWHtpn
	j/787xkfcdOaYXccLqR/l/t4YLs5wGoSp65LEEjIW1dVgQyox96oqdBNuzPRPzsFK5fDceeSXDk
	DbEemqf3aDxUIiCaVQswrrhriV+MV09LfKBUDyZw6u7eA4TXvzxDXKtgQFi/4=
X-Received: by 2002:a05:6a00:10d1:b0:836:6f2e:bb6d with SMTP id d2e1a72fcca58-84a9d0e5e99mr412854b3a.14.1784139414332;
        Wed, 15 Jul 2026 11:16:54 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258ede81asm621883a12.11.2026.07.15.11.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 11:16:53 -0700 (PDT)
Subject: [PATCH v9 8/8] drm/gpusvm: Use hmm_range_fault_unlocked_timeout() for
 range faults
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
Date: Wed, 15 Jul 2026 11:16:52 -0700
Message-ID: <178413941236.1155966.14485211391150425997.stgit@skinsburskii>
In-Reply-To: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 850D6A000D
X-Stat-Signature: dwnkkgmhup1uf6x7bj31s85hq6jq1gxg
X-HE-Tag: 1784139415-299334
X-HE-Meta: U2FsdGVkX18iI0fP7hrrlJGy4vAaX56X7FTlYIg2+v/ZUk1uaiIEJmdOlo3Xoxc5ERMdcP/WAf02rRTii+ny0BdlYf6gzsJIFekhNoPqCzlp/br5bKj8flZz8SvjSd1pSNvL88LX6EMKUpEgRf0AqQCgiopFlpEHGQveWjmVwVq/W663aYqfxksvwmCshzmbJsNTY3I4FOuO7FjBYBgDf8v5MQEIFSj4igO3euN/uVmHeE4dnPifuDpd/HRkEybUpq8vSvHiesdCji+m3rh69dwDCeLxq42Sbw1vgbgQFBfYuBHZ4ZS5vMvY4xw798mOYC+d0ByKPmbLc04GBn7roHkG1Sa3rj1qnepYBoPQZZAIEZHbmkCGdP8X9hPs1BAnMVck1sEpPV8MwLA4HZAvRhGeRd457eD1+PydOxtO/NsseXpXLAGZiUT4akgj+ecm8n64tT7gCdEhVUrDVwfoaCDduucsHIeZJGHfynaG4/aaIKfFBUkX/lqV0rq4mOka22MjOOpdh1+UoaW6I1Tdb1fFhgN+7PxoadNQ1JJhd0T6LDQTClIPMkb7leeWBudCm6/Zyl2iV8zWZqlls3f4u973PBXQWCZrpEb1NQ+dsQAX7oEG8qvHczcoQ/F5Nit48WUitzGkzYriqZFVSnf2m36Y3ahvcVU64gFb6wtQl7B6SUFyJJtcQ4S20goVwWyyoVkzis7B8+gcBQeMC3QRYAfmQLLUszElKCLetR+ZxHmlqn6+9U4ErWypH9SaLYNH5LJgOGV/XPZochiUAFX0jRqFcZgWhCTAroQUpCCDRlm+x8922RbECWnLSVQLFQ+GsJMYMbXw/FBEn8e6LIQOxIZj8lB17BEmNGCkFuV4RE8W8Y4fn64oa/14cm1vcdxn2tFIG+I9D6LJJFQTq6ZUAXXy++5oOMR5vpYENKZASstBx42WfoCwg6oPmtrBEBCfOckn2a60gyp8ZUDOLZS
 ejjDBqwG
 VlIgI3ATGyMtf2Z8qnpHbVkq/vc61FLcbIz/hnNJYcD2exBSCHKUUKTdNrZjMtXZx2GMwuE9s7epxJRJ7vsxVyYPa8XX3erAdRxWYy25Ybb7WGDFIOexNfYlaWeHnutgJwf9NRJvMmo48DSJB2aGz9xbCgSJbykEpsu8GAeKi3gFjphLH266rQHAizXVsSjrIUTHcDD8mqwSEb+tDnYyCMVIwS/a6XRzaQN3j7ULcl/P0lgkokk8wfzMljwj8w2aSRVvD9Jwu3KTOrS1wc03Eebi0evjPMYWXnT4C0LzrbjU0wqNRZFsu6u4/yHNOLvtUccZsIWMYNQpM7o5RZ1Ck/l5aJfugPZ0hUx/Kn3P+uuKE5REezmgAvD3ARgBkgpagP0YwP9GjrAiEXaw5PAE1gfdF3Eudo2WwqABXtojRajOy6gZHlW/7AE7K5F60ZvEJ3JZ9fMw72AtqQIX4QjT6cJJKHyvv4Q8qcM+JdwTHYkujg4V9BOR8KXgqZKwKlyvATL8oapZcNcAOnVljow0gtsgaIa3NIkJ0tPVu/NvVCIynvm8UC59t9IWYgICetKy94A+y7XuSVd38ycg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several GPU SVM paths take mmap_read_lock() only to call hmm_range_fault()
and open-code mmu interval sequence setup before each HMM walk. They also
retry -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT expires.

Use hmm_range_fault_unlocked_timeout() for those faults. The HMM helper now
owns mmap_lock acquisition and refreshes range->notifier_seq for its
internal retries, while GPU SVM keeps its existing driver-lock validation
with mmu_interval_read_retry() after a successful fault.

Pass HMM_RANGE_DEFAULT_TIMEOUT as the helper retry budget for each HMM
fault attempt. This scopes the timeout to repeated HMM notifier retries
while preserving the outer retry loops that restart when the interval is
invalidated before GPU SVM updates or consumes the mapping state.

Leave drm_gpusvm_check_pages() on hmm_range_fault() because that path is
called with the mmap lock already held by its caller.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/gpu/drm/drm_gpusvm.c |   61 +++++-------------------------------------
 1 file changed, 7 insertions(+), 54 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index 958cb605aedd..de5bbfe58ee9 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -773,8 +773,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
 		.end = end,
 		.dev_private_owner = dev_private_owner,
 	};
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	enum drm_gpusvm_scan_result state = DRM_GPUSVM_SCAN_UNPOPULATED, new_state;
 	unsigned long *pfns;
 	unsigned long npages = npages_in_range(start, end);
@@ -788,22 +787,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
 	hmm_range.hmm_pfns = pfns;
 
 retry:
-	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
-	mmap_read_lock(range->gpusvm->mm);
-
-	while (true) {
-		err = hmm_range_fault(&hmm_range);
-		if (err == -EBUSY) {
-			if (time_after(jiffies, timeout))
-				break;
-
-			hmm_range.notifier_seq =
-				mmu_interval_read_begin(notifier);
-			continue;
-		}
-		break;
-	}
-	mmap_read_unlock(range->gpusvm->mm);
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
 	if (err)
 		goto err_free;
 
@@ -1406,8 +1390,7 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 		.dev_private_owner = ctx->device_private_page_owner,
 	};
 	void *zdd;
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	unsigned long i, j;
 	unsigned long npages = npages_in_range(pages_start, pages_end);
 	unsigned long num_dma_mapped;
@@ -1422,9 +1405,6 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 	struct dma_iova_state *state = &svm_pages->state;
 
 retry:
-	if (time_after(jiffies, timeout))
-		return -EBUSY;
-
 	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
 	if (drm_gpusvm_pages_valid_unlocked(gpusvm, svm_pages))
 		goto set_seqno;
@@ -1439,21 +1419,7 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 	}
 
 	hmm_range.hmm_pfns = pfns;
-	while (true) {
-		mmap_read_lock(mm);
-		err = hmm_range_fault(&hmm_range);
-		mmap_read_unlock(mm);
-
-		if (err == -EBUSY) {
-			if (time_after(jiffies, timeout))
-				break;
-
-			hmm_range.notifier_seq =
-				mmu_interval_read_begin(notifier);
-			continue;
-		}
-		break;
-	}
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
 	mmput(mm);
 	if (err)
 		goto err_free;
@@ -1720,8 +1686,7 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
 		.end = drm_gpusvm_range_end(range),
 		.dev_private_owner = NULL,
 	};
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	unsigned long *pfns;
 	unsigned long npages = npages_in_range(drm_gpusvm_range_start(range),
 					       drm_gpusvm_range_end(range));
@@ -1736,24 +1701,12 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
 		return -ENOMEM;
 
 	hmm_range.hmm_pfns = pfns;
-	while (!time_after(jiffies, timeout)) {
-		hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
-		if (time_after(jiffies, timeout)) {
-			err = -ETIME;
-			break;
-		}
-
-		mmap_read_lock(mm);
-		err = hmm_range_fault(&hmm_range);
-		mmap_read_unlock(mm);
-		if (err != -EBUSY)
-			break;
-	}
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
 
 	kvfree(pfns);
 	mmput(mm);
 
-	return err;
+	return err == -EBUSY ? -ETIME : err;
 }
 EXPORT_SYMBOL_GPL(drm_gpusvm_range_evict);
 



