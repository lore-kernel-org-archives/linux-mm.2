Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231C2C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 22:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23416B0098; Tue, 14 Jul 2026 18:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4656B0099; Tue, 14 Jul 2026 18:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEAAE6B009B; Tue, 14 Jul 2026 18:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF6596B0098
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:21:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EDEB40551
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:21:55 +0000 (UTC)
X-FDA: 84988805790.12.9E6E6B2
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5FEEA40004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:21:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nrCwYXdx;
	spf=pass (imf17.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784067713;
	b=LZuoglupwGb6E8ZgqvW3H4YVwTJnHe5IrCMD0obZYnPSf+pwawDYNWTqzigy/pPXRumQ0x
	mxucBErSjdDDAtA/xRM3ldLCjNkR9bTc97DtP4mSA3Yznr75E1fwkrA754VRkDqYwpIL23
	NJPs+Q33589gZ9qKYdUKQ5HMo2ryiS4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nrCwYXdx;
	spf=pass (imf17.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784067713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUZJ2b06rpE59kyPt/lRc7T/ATHNB4Peeih6JEYSOE8=;
	b=CQi899R0aYF10JZCS261OvepqE4MGgo65KjFcNNVu9CQ+VKiLWjFF2LXJr913dmuhEBcEB
	a29Kg2PGqw51yqZ7yt+5UXOUNp5gnyktgQqXrSGt/vi7T9KMKt+xvkkBVK4BOFMMpUBT4X
	5nU3yzJ5L8MUHHPZ7z27FXm5kJx7rSg=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cea3004256so48377245ad.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784067712; x=1784672512; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=EUZJ2b06rpE59kyPt/lRc7T/ATHNB4Peeih6JEYSOE8=;
        b=nrCwYXdx2tfPenep8suIlzyV84+HDM7XPayCJhOuShA4EXhA91CtKvqFxioca5TJIJ
         SytmgtaM+5vMnjeTE6WslIDW7GnYQWio4MFh/bG6ILLz6spF9LgprqALInbtPLXOPKhm
         0Qzet0eRGPl8NNJUV3jO2Decjc1WF1XtR9BcAkSIY7n37BRqR0Lyervp5jbZhubA7aLx
         csyJM0AvBUgOGkTW6KC1SRWoFQQnpgbIE9oveOuT22+3AC/r0ebeJkJHRwj565DykABN
         2EE8eihtOIRedvSkcUchydoB4/j8OhvLEMusbNDaCGzd9Anz2wE75O05WolJ61Q48HI2
         M5OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784067712; x=1784672512;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EUZJ2b06rpE59kyPt/lRc7T/ATHNB4Peeih6JEYSOE8=;
        b=evAutXUDvv99QMDXrKe9r5aZOUZ3Mc6wk/QSRP08PmdTIcirGwHu1859wD3z6MFM/L
         STiusvIEyDOpeWEyi/lxoGY5eQQ0wOhflQ8neFmcINnFBTh9479rEEuBQZLdKcpWVFIT
         9TCG1u8FPV+AkH9F53hmTheYmIgpmKk46bLa+Y8ojemxcaND5G6W5CVnJ4mHPO0UT0gN
         KZC4c2aRXrFtq+E+YFNMwhUGhiyTDJhpuUOplWy5K/iaAJ52xg0gH4Akyp5T7kraOHW2
         GLp57MLqGB13mIE0dlbxQeh0zBcvl4NIaVMHXijHlorOScgje80xvdLfsLRKY+Gb9HBQ
         UqLw==
X-Forwarded-Encrypted: i=1; AHgh+RquL97QPdlrxt3qtNb+bo1dRxlCen8TRhqsZdymO1WvTRsMWCkzzmSqmGz6e1bjGtSSegVH2A9aGA==@kvack.org
X-Gm-Message-State: AOJu0YxqSUXdjQVNHWhI13A8lHDo5BNDzDwWBTk2yM1O0dXdPf800t6X
	wCXH2Lypqm6TfViDOBihDeZEvewGiLDbg3G+ipRoA8xgyVfPuXmBtgXi
X-Gm-Gg: AfdE7ck3gwUyNfMo0NMh4yWg5V4QyadU+wsH15+kWvyoohw9NHEDYbul0wBM44Y8mNM
	V5XeQkp93RxwAykCVh/X4zKZm1oxpss1Dv/Tw6UhorRWI4b3QYCqJRxFJLo+K5sfWYA1+koBNhS
	rfxYDXaXuLpm1sHolVIgNTpd9PngUrgeZ9rcYcJ12xGKcGWo6+q5hAugOK0RAF5EC//5Mqi7/Sh
	MADdlHPiuvGG7TgAKr1hpmpFRISGv5oJJsIZ6YN3Ubx14cw/bg/NdQ4KZCSm2uPDR8ZfZR5cltP
	0S8vk7s0jVOvGf6YJB1TlQak2+FWLIIDIzp5LvrKviGyoJe+QMbGpKBzY4tdNB1d6umDvSkg5ma
	sPjSG3ucTsH1azJFW1KkqFRmjKYMSGwg9bv3Q4wwuoojfLWH436xp9SBHDh8UK5+ouYblBaKkGC
	v8DVKhdGw4Smb8KhZunkwF/RhN2NutusPkGfCb0MxYMGOQEDlqLkymZbmlMiM=
X-Received: by 2002:a17:902:e751:b0:2cc:307c:51f2 with SMTP id d9443c01a7336-2cef143aec1mr42102315ad.22.1784067712200;
        Tue, 14 Jul 2026 15:21:52 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d1f030sm122554955ad.51.2026.07.14.15.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 15:21:51 -0700 (PDT)
Subject: [PATCH v2 4/4] fixup! drm/gpusvm: use
 hmm_range_fault_unlocked_timeout() for range faults
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, jgg@ziepe.ca,
 kees@kernel.org, leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com,
 ljs@kernel.org, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Tue, 14 Jul 2026 15:21:49 -0700
Message-ID: <178406770964.1106335.10099816010446253543.stgit@skinsburskii>
In-Reply-To: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5FEEA40004
X-Stat-Signature: 7oz5nmc4ck18n66t4daijsppwk4x96fm
X-HE-Tag: 1784067713-742018
X-HE-Meta: U2FsdGVkX1/qGyfOBcxL3QRZ1ykQTtRO5JXUf98UJ6aJeJ/xVU5pK+Ieh4rja6nCozVP/88hsvJs9lHVGgUq0wcWs2itaeIAsfM6i9OzwiGW4SJFqTE4pyQnpdp8e//3GdFcLcBGSwqT3Vh+/ZbzBlBCYo7ymqT66iFVc9gbhCWF5a3t/NKqKMkc2GLk+CgUyH2wGoB03lXZL4tf94KEbrG9TqVQHhvV7r/sn7EAIZ2zZe6DRDrl9cceZhQS56UAPLO353CmkSM/i0JsHGum32e1/+SrVTPRkUMWTrtaUwkNL7qrmNyj0Eo2veJZllTXBnbn91hwEC7kbQIT7wGLu+CS2M5cEUNsX2dOsEos5XLRRarHWliewY/uIknq0W4v9PrJ73A+yu3jeLdacvsjbnL316cPg12WPPivWCIu10uksc87TnrSEvG74EHTldQ9aePd6/ps87zdYk9XJIm8CQdgnpIGNeb7tOLCLoFyx2RDqPXaT37Sq+vQ2Gi32PuKIW/Wt47G9QtXdK88VOQPcL/CqjsPsT2RvQ4vORJi5oyswHsVUgyrc7VOKwpUCY5ft6pa2w6UzJeb932BgUlwFDuTJB4K3lneRU5rxCf9uDfTA18LYmqq3Wv6cFVbHMPOLYSQVZCf6QDUmYAFR4INSIwbeoiRQSqjFKt80TavQfmu3mUgV2/XbQLsQFmvPBc0baA2lekjiG6/ggOnLxNKJsVSuPIGVPovjz3JV1Fd5UIZXy1HXdVEpgD6Da9aiBEZZdNsxCLp+yR1yLe8nrOainyA6u4nUKOmMRhyRiLwAWDIdmtCeCwUh88gQcHAM5IOc9qh0DDT+hfTl/3JvZ86J3IyWyKHPZOJMkpPFuvaxYTE6Tr58Tn86SBfsuR5MAOw6vWsugr5jimqSYS2XRZDRR1dLIMXSSiFLB7lFNsbCDGvA4CaEl/cWXaUbDJLZMt0GdopxVhjXRbbrL17dKg
 lSMEBG4U
 EHNZDcnS6/0CgY95UvpwXsjFBqdQqSUKq4xhWk0GRwDoe9eqHUpxhmACFiQIebCW1Je70ZVcKb4p0k3+GMPV24MS0pTWZd+YtUbMxx3Cod+rWq11bDOCPA9eFm/DKwT1Kba+r8hAMHTMuagz7hXv0dNztxjPuCPLQ8Jw4SjIlWdpGtxWKQEkVW8jeCWU5qLbxQfeK2bsjKPUK7qOUz7/oBsO1odQYxVLdFOdRzia/r05bwWY8aJQl7e5PySMR2eMk8/sW4stxanQm2SLZbWBd+BWFpW8dECvZRHhadqFX3AajjUYfixor+VcoCzfSomJtXAWtTcAMbO6GLZzWPDGBm0HDIFcdPgReFU3ulx/N0YZJMdYxUq+DxNwivfFqJACD6zP/Xqgx06XrgdIHp0bLFE0K86rWnDAvk6wgD/OZR+wwI7XKfbLFy7jnyvce6bcox6HTJduKhbzQoaWxD2vnxsPYKhv+ih9dggfQB6jw7uqk5lSjKMjoQzv/UMdQ4x0U3zP4fWTflLGaXhDtr77m8jyMvpQZqktfv2dgDW2Lz1n95nYJB6lrmm7FqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The timeout passed to hmm_range_fault_unlocked_timeout() is a relative
retry budget for HMM's internal mmu-notifier retry loop. drm_gpusvm was
still keeping an absolute deadline around the outer driver retry logic
and passing the remaining time into HMM.

Pass HMM_RANGE_DEFAULT_TIMEOUT directly to
hmm_range_fault_unlocked_timeout() on each HMM fault attempt instead.
If HMM succeeds but the later drm_gpusvm-side mmu_interval_read_retry()
check observes an invalidation, retry with a fresh HMM retry budget.

This keeps the timeout focused on repeated notifier retries inside HMM,
while avoiding an outer deadline that also accounts unrelated driver-side
work after HMM has made progress.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/gpu/drm/drm_gpusvm.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index b8f2dd9982f5..76e8a0028c7f 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -852,8 +852,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
 		.end = end,
 		.dev_private_owner = dev_private_owner,
 	};
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	enum drm_gpusvm_scan_result state = DRM_GPUSVM_SCAN_UNPOPULATED, new_state;
 	unsigned long *pfns;
 	unsigned long npages = npages_in_range(start, end);
@@ -867,8 +866,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
 	hmm_range.hmm_pfns = pfns;
 
 retry:
-	err = hmm_range_fault_unlocked_timeout(&hmm_range,
-					       max(timeout - jiffies, 1L));
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
 	if (err)
 		goto err_free;
 
@@ -1459,8 +1457,7 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 		.dev_private_owner = ctx->device_private_page_owner,
 	};
 	void *zdd;
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	unsigned long i, j;
 	unsigned long npages = npages_in_range(pages_start, pages_end);
 	unsigned long num_dma_mapped;
@@ -1478,9 +1475,6 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 		return -EINVAL;
 
 retry:
-	if (time_after(jiffies, timeout))
-		return -EBUSY;
-
 	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
 	if (drm_gpusvm_pages_valid_unlocked(gpusvm, svm_pages))
 		goto set_seqno;
@@ -1495,8 +1489,7 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 	}
 
 	hmm_range.hmm_pfns = pfns;
-	err = hmm_range_fault_unlocked_timeout(&hmm_range,
-				max_t(long, timeout - jiffies, 1));
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
 	mmput(mm);
 	if (err)
 		goto err_free;
@@ -1718,8 +1711,7 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
 		.end = drm_gpusvm_range_end(range),
 		.dev_private_owner = NULL,
 	};
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	unsigned long *pfns;
 	unsigned long npages = npages_in_range(drm_gpusvm_range_start(range),
 					       drm_gpusvm_range_end(range));
@@ -1734,8 +1726,7 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
 		return -ENOMEM;
 
 	hmm_range.hmm_pfns = pfns;
-	err = hmm_range_fault_unlocked_timeout(&hmm_range,
-				max_t(long, timeout - jiffies, 1));
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
 
 	kvfree(pfns);
 	mmput(mm);



