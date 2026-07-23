Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF0DC531F8
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A67256B009D; Thu, 23 Jul 2026 13:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3F0C6B009E; Thu, 23 Jul 2026 13:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CDF6B009F; Thu, 23 Jul 2026 13:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 533ED6B009D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:37:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C5D64011D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:37:01 +0000 (UTC)
X-FDA: 85020747042.06.8F23413
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 353FA100006
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hD5fRqKk;
	spf=pass (imf05.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784828219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8Qd33SMLkRtmqANiDW8AEhl0t9s2Dut7/75bk+4IdQ=;
	b=luvkilguMTaRAK072r3Lqi93hKOpzsKvTeE4F7Beumsiu9ovZQ5VM/EUaDke/8svKgiZIU
	NUXm9wLwnL1Kh0ROClfjEqvBCGfz5Cm2W/X0TzJ6Q8VV75jCtDCX8dS8od1MPRpQfEYnVc
	RHs85C1rBoBFh0NCoyjNqIs+rl+IO1Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hD5fRqKk;
	spf=pass (imf05.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784828219;
	b=1bPoZZvF9CPTKa0FqaSZ8vj2HP/U8XkjCqs3IgKmWea2xum9zqpBEZavRsGSLlD+DzmBXD
	cliXkmUWkpDajEdAygXHrtR8QnX4RTTltTvDNuDY4zIXKALq/dTU//X8+qDk83aVcTwLjU
	ZzWhpMvnA0d8EiwZyc91hBnKxZ2TM/Y=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84a652535dcso621041b3a.3
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784828218; x=1785433018; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i8Qd33SMLkRtmqANiDW8AEhl0t9s2Dut7/75bk+4IdQ=;
        b=hD5fRqKkW8lG5kgu/BaKs/irMNVfKK+jHOjOdbjWkpqOAfe2rBvy6+NK45koCpUREA
         Od5OVmANRVn2qaw6thSHOjkIUEmmzeJDCPWjKnugmapFzZzGaKW9LwhXIGxBxrmcS6o4
         1Kh5mcvteZqftFuf8lSCqxcxxssLanQnGmAzZ0+/J1hPnKmlIxf1edVInHIS+6OAVvot
         OutICufy/LiMob5nLbgxtgdfXXQVpiSqllpiJj6mAIczNOevP1GUGzK7MwxagLjA2bL1
         oOVl/0lyTVlKcIFLCJwUc+XODSE0dh5zkusClVE1J5OnGYnGqqdcuh6WAuXKC8mf+sAz
         zdxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784828218; x=1785433018;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i8Qd33SMLkRtmqANiDW8AEhl0t9s2Dut7/75bk+4IdQ=;
        b=Vc9S9B8r7jzceSay7FQvBVTr6HO1frkwh5fGp9ce+1w1c/S0YZ+PSE+J0M3v4fpsPb
         rUC6CSabCrRj1sBYy15zC3Io1aCuqdRIOPdJMQZNAWX5HowxpNoHrHOJlQ+C4+glHjtH
         /Odz4x6JBpteh4QecwH3zMAM8ZpY/qfF1dWsaBICHDlUzZ5poeoqP2jQEpmcDGD+nK83
         W5FP1PaW7PUbnan1Dol3B2uT2KuSKViS6UYrRG4vdJ8ndOtihSr48fCjHl+CxUdUcYyy
         y82ZVj7n8jhpDpdvhRDRH1dllsallWXP9L4VmUkbgqOEjup9a+uNQRn7ZoYIsz+GfSIq
         evBA==
X-Gm-Message-State: AOJu0YwrYsfOb0vUPLLdmVCbu3OGJV6B632XSkKB2scyhTXxMQKKnPST
	at/eZhCJNyq0AYmolmCZTWqxg1X1gH6SIuysxIIT/Y69NRCLXXMOI3w1
X-Gm-Gg: AR+sD12c367CO9nNM5I9SC/++VxWO46zTao9gpU5wcXH3RXZNi6HSx2+zf0rROEbm8K
	ywgn7U8IjWpb+qfgq2b6+RTc7GxeKdIktj6OXKcbLartKk5e5xagZ9R/gk7bDzB79vmJfSVPVcj
	sqG04FrySPgsS3zyjO+ktveDsa/0lKMfhL7iNTuA2P0305+NUbdX70QIhabnoEzDflXyJDp2lR4
	D541Xnto42BG7Bpy/i4t0lrXbkpnLKq8xu1k0W/KRak7Ku8Y4ZSLOlLXFZcM069Nt7hj66e9pI/
	4+MrzDywxxHmPRw5sBM81sTT8vNI1iC1Bd8aEAiWPGKFudCjVAVbSHDtthWG5XwIanZEKNQlxDc
	l9VdgBRoo3Wxd22kX7MPX1OAPmk1+AbZmux/rY7Kk4JZQEcJfzUSRU0JxhDvRTDjUjOg/dd+Rlr
	hzByRCZ8suLQFaShwANIzZJMn0nCgGmY1PRE0+vDDejfCcxSzB
X-Received: by 2002:a05:6a00:cd3:b0:848:88e6:95d3 with SMTP id d2e1a72fcca58-84e2bc4d259mr4728321b3a.72.1784828217972;
        Thu, 23 Jul 2026 10:36:57 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e20622dedsm2691612b3a.11.2026.07.23.10.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:36:57 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Thu, 23 Jul 2026 10:36:40 -0700
Subject: [PATCH v11 8/8] drm/gpusvm: Use hmm_range_fault_unlocked_timeout()
 for range faults
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-hmm-v10-v11-8-c55b003a4b61@gmail.com>
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
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784828202; l=4921;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=OHRNaT5JjbQYbg0HfVsh/goi/Wp2JeVv837tKjXheiU=;
 b=3mS7hpEm1cC4EjlfjSHzs08itt/haPD5UmH5YZzhkX5wXqdTOzSMnls0rW++T0vSS8hxNEDOH
 H/0vN9YPqS8C3NJp8Qfk40j/53Cv5CNaQqrwQS1NX9qK2UYGBofyGE6
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspam-User: 
X-Rspamd-Queue-Id: 353FA100006
X-Rspamd-Server: rspam01
X-Stat-Signature: efaoknxmdhrusf3fowzgm8d1nc7zbpak
X-HE-Tag: 1784828219-558550
X-HE-Meta: U2FsdGVkX19dhrZAu7zytY3Jj6d8d9sX09FcEm7Rmci5DcuHHRCwwT3i0Kc7N+PjPqjrpxdgFv1fB4vXGa+w2w3qrkGACgGZywwETh46ky5jF+SoX5X9FqDDpJssXD08k6tyuAutGi60tFufdH70YaXIOO7gPdM4JVMZyZFxxyNwpluf/fFoE2unDhvCsiwRNlOKNqPA7moECh/Tez4R0WD/Y59hkcOpdaS/lK40WjzR08Sgz2OvwU5edaJtTHjv+N5MJUnmQ1O9VgawqwV9wd93E/UitRHCy6Cs42aZKmvzLBR89dbIeyjPNIBFnVQZjMW2M82KTu3Vk4L2vEOXNJBp8Nev2BPfZwEgUeMQ4uHq92HGm1xM2sHj0Q6Hv+Z2/jgfVOkt10qXc1jaYJw9sK3m2UE4m0FxrdPa5h2jKuKJmkFPmUbpLRdytZH8217GiomwlZSv+1pu4lUwF7kpB8pa/q8IDlEvHEM1hieTZ41xfQ8GlGGDOtHwMx/5JspIUQ0Cy/7xJr7oZQL6m3/n53VJYIAGBalhgft2ODJGPytLBpulpRBke07mlZEjQDpwYC0FAl86Iaq2u+rb/tGImXF4YyyPpaOtBj07cXpVojV00VPu3h42RXO6jW2MXNn/YtCgw461qEMIIB+G2FrEF8eqa3ndS41oj0UV1Y5pRsCoHcSV+/DaSDMrcLfmrGZvRgII2JPKwg4Yxn54G4+s/YnP347dPvOcUF5c1mRSLPSJwKfDWyM7lTstwU23k0wWgSViPuQhBxUoukHQlWLQQrB0UVOkgyKp1rmhTdWMk+BxlQBRUuPWHM/P2kjFp+8LMEQrU9pFlodj9D38RbnsyopchgpaRKL19j5euR9WowwaXl6IQZXX5EekFxPcPbcaz0CdFFzTr136gpSe2rX+nTO1wcXMHwaUgv72kzX7E0Zej5VcwWZzHD0AtBBi8/fR0ucJMUtpFfN/o6p+/nx
 V/oXpcGC
 gO6JxDUVX19SxLE+25Ym4QNiKUAG+IgMzO3tLMJWYczBy/3mcUZEMP/7Pit7osTfDSK2f12R509kXymPgP8QewwKW2QdpqrAYBiX7L+ZCbGKGIBJae//jSYnShpc32L8IMZQiS3uByluTAoiqWe8Y1JnWzDozYzbVjy3cH3Oo6s+MEhxdWPALuKiqrTPY9GnfPGmjr5s1G7E/A4zXuwZRO1WVykQLzITwHOKjOGzb6bEW1gTHDHKK+d3e8ueKq/GGIgsyHljdw4CmFx29qyqRyYt3SayFlLziPP7Gdtyk04cFYWWP8RnenPKFmY4p9c5McvordbJXmuh8Rt+2fEaeFHtRa6Ftle5GIzNxJ1UQT1u/REG3rYSmfEcvhe74Czl2nVDXY2quMHer577SRtxwXU7iWbuWKeAK7S9F2i6gVN1xo6emhCmMvDmQtx6hvzaHDlSm59U/Y7rFiDho5TcXTlKy5ovjldrTHksOP9nwfT+L6ITlJR6erAuA3A==
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

drm_gpusvm_scan_mm() and drm_gpusvm_range_evict() pass
HMM_RANGE_DEFAULT_TIMEOUT as the helper retry budget for each HMM fault
attempt. drm_gpusvm_get_pages() keeps its existing absolute outer deadline
because it can be reached from GPU page-fault workers, where fatal signals
from the faulting process cannot stop an endless invalidation retry loop.
It passes the remaining time from that deadline to HMM for each fault
attempt.

Leave drm_gpusvm_check_pages() on hmm_range_fault() because that path is
called with the mmap lock already held by its caller.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/gpu/drm/drm_gpusvm.c | 60 ++++++++------------------------------------
 1 file changed, 10 insertions(+), 50 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index 958cb605aedd..e912e994beb2 100644
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
 
@@ -1408,6 +1392,7 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 	void *zdd;
 	unsigned long timeout =
 		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long remaining;
 	unsigned long i, j;
 	unsigned long npages = npages_in_range(pages_start, pages_end);
 	unsigned long num_dma_mapped;
@@ -1422,7 +1407,9 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 	struct dma_iova_state *state = &svm_pages->state;
 
 retry:
-	if (time_after(jiffies, timeout))
+	remaining = timeout - jiffies;
+
+	if (time_after_eq(jiffies, timeout))
 		return -EBUSY;
 
 	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
@@ -1439,21 +1426,7 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
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
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, remaining);
 	mmput(mm);
 	if (err)
 		goto err_free;
@@ -1720,8 +1693,7 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
 		.end = drm_gpusvm_range_end(range),
 		.dev_private_owner = NULL,
 	};
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	unsigned long *pfns;
 	unsigned long npages = npages_in_range(drm_gpusvm_range_start(range),
 					       drm_gpusvm_range_end(range));
@@ -1736,24 +1708,12 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
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
 

-- 
2.43.0


