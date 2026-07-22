Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66292C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 21:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ED496B00BC; Wed, 22 Jul 2026 17:45:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5769B6B00BE; Wed, 22 Jul 2026 17:45:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0BC6B00BF; Wed, 22 Jul 2026 17:45:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 012006B00BC
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:45:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69DDC1C055C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:45:03 +0000 (UTC)
X-FDA: 85017743286.05.B1E5DB0
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6235C180005
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:45:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fvPRz2ui;
	spf=pass (imf06.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784756701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TSbIIq+MW5ujNCU6weGrEYnGd53JSmfWB5BOONHtR2c=;
	b=CS2Nw5xPpL2/W1RYrjp3Osl9VfUGqVV6D6650aH+7FF6B9qXK5AtERpdkS6296Igy6wAFv
	cGlQr4T7rxBCgfRnS8YE+KPhDSbLP7aqx8VA0JpHTNlOAZ0zWt0ZANDqHpt0XakffoLDFO
	tCNJeUCE7OgOELsS7Zp47wQazRRUWKs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fvPRz2ui;
	spf=pass (imf06.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784756701;
	b=tsS1hwAaTFRHcV21ab6mi5aGZDPD9gWQ3yBt2bXMUxZ+3lv1dmtf4kZMZaHZr4reM3nDx/
	oSAjCu9oqrMryJPpzQgZLAMvDVdA24H4G2d54qvt+hzEjmBkgg+wTYe+9wFUdcGu+5/JQd
	GuVXTPA0CzRON/+qpyA9J3cjCkwN4OQ=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84867f07d63so14622254b3a.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784756700; x=1785361500; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TSbIIq+MW5ujNCU6weGrEYnGd53JSmfWB5BOONHtR2c=;
        b=fvPRz2uiljgjwVdTKySmBQ9yNRY98Hy3OY5UA5FiMUP9mAjhjIacIVnRKeYYzWPnjm
         AtlgpKBW4ZAg7SJFlpAyPXsOQ42zNbsU5baa9Y8Dl0XLZEL3SDq2n9k6D4V8eLH6Ls5f
         x6t+674e6mVuGkQHaxP1cO3WLNUOsOzOo/ZoEmBofR8Ym9qzPzEVBvGcbpXXXCM4UVzj
         U/wDr2aEj/6BlFJV6jZIYzsCXt78/G0UUcMBdWt+OcoBU6AccSUurhxQXF6rXS3hw7qQ
         NRNYAs6K3SulnlWAMBOuy+igslMpNYIUR+80Mf7812GBEUUVunaqvykeF2XvXReJQFtl
         vj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784756700; x=1785361500;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TSbIIq+MW5ujNCU6weGrEYnGd53JSmfWB5BOONHtR2c=;
        b=apqU0KBv0VBUR0frHt2Ym4xarpJFM3N06HMlWrzzJwdOrxtSmzRCIzZnV6n1bkBl2Z
         yEBFFWbaWOX2wZvkG5g8s4erRhxh7EMSonKqjYgNt4L/NocKVrWF+xL5biIiLuggdJLs
         ymkfB9BDbib/Wsh1UQIgsJemgN8ZzjFasXtkmqJBfD78CN9USEbgtzaFtFUz0TJVZS+O
         D3gtd6qVPWVw//GzUEN6HncVBgK40fc3tF2m7FNoIFmvppD7tXJOsMyF5OHb4J3pflp5
         Ch+FDFf7tAiA+2pTrrHdDQ8O5VMtzully0WvJeUMgNNLCaC72y0MLrEdjrb6VZg+1iK7
         QOww==
X-Gm-Message-State: AOJu0Yx4go2aA9U+yr4c40TDQ4KEeYoMsiprR+aIBb1qllbtNjJbOqU4
	bnGipEbatl+XC1b5y+qBNTLy3vsGN6Au+ZmVOmcpaw4TJq0m+aT8Kyec
X-Gm-Gg: AR+sD101noomIbBPOy7FakDpV6mjmhnNMK5ywbasS5G8SyULkUTP+v3fY+4w68dpvV2
	S89b3NNzeZTm/AIbKjfZH9OPQ7EbVUFk3T53zq2ggXsdbFuGqW83boCH2vTnAMgWlL1fIOhm0kE
	Mkom4QDaQI4YH1JDycauMPCMAvLVLylCTNmOmqARJj5yGcMCxlJ9iDLcFaVh/w1RSkUXZIA4ScC
	+z8tv3sN3A/jPHUFl/uWUk1uTt5C/GWygNOO8P/gaWnRnALVZzVGIgjiXmSd31JKonnLaFXP4hh
	K6MJSH9yYMathCFtpRYAeKdNvnB29xPUwbazJYdlDFdwmal5S/rDMfnLoTXjtpaZxvm7tSekPdN
	XiHkk41IilMfCRJiQFo9mKY09X7QC151k1Q4OrKP43bw3DyO2yF1Qxc/RtyCIwPPkHIpkudFsXQ
	kt+tjHH9VOEXbH37+mGXryilCHjim6jQv064waOu4tIHfItv1J
X-Received: by 2002:a05:6a00:94f7:b0:848:467d:293e with SMTP id d2e1a72fcca58-84e2baddf66mr627847b3a.43.1784756700316;
        Wed, 22 Jul 2026 14:45:00 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17237c3fsm1946297b3a.9.2026.07.22.14.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:44:59 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Wed, 22 Jul 2026 14:44:30 -0700
Subject: [PATCH v10 8/8] drm/gpusvm: Use hmm_range_fault_unlocked_timeout()
 for range faults
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hmm-v10-v1-8-606464dd601a@gmail.com>
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
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784756683; l=5001;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=JxcTBTW6lEzlUH9pe80rZJYyQZGUPa2uP7JaZIpbDO4=;
 b=t5pXaIaExV86XNOZX4rodLg/qlkvO7z8UzQMAKDvBSpVBwUgOqPA+1uKWVHHstjr3FsmGAV1u
 FhiXQ8BfH3FAK6QXFIhXuSWoEAqA3lYTf5A7cJupNOmjpSFDJW/pEX3
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspamd-Queue-Id: 6235C180005
X-Rspam-User: 
X-Stat-Signature: 6xqqhr8zhwhrxpy6uo7thgq1qdgt4yx8
X-Rspamd-Server: rspam04
X-HE-Tag: 1784756701-987369
X-HE-Meta: U2FsdGVkX1/dOrRfnbiarhOacbrQZvRs+Mu7xSxnFbhuzWzy2IndT6YmKswQjC/3haw1KeR0EASeIO7PDpNQFIYX0E04NhIigCU0Nr8wTwX6S+L6Lm2Ogqy32YlFed6OkCfruE0gF+0/HXrN9foEfE7SuAWKj1Evl9qQsszVtY8/BGzSCQFH4NKlgJWTe53iIyulXQMepWV6VKK6RIHvntFwnq3sdrYIecjOvk0PB3/1PGGU3Sz9OvGXRYF4R+RU7PE27kVWaq3WDCwGpN3i/pnzcDISChone+yhaRRdGYsUS75uEM2A65YyrVrYoHoRm7ipM18msdnPixONql5Z9cd8WL6jyHx8zFTj2ln3rk3Teqx/mPWage/s8yBW8fpNpa6LCyn8psipCIXgK+vmA0fuEulnAaibYBbHZsVuWSebeUrACskJWLfo3DkensEmRVw7ZXYj7f26BnsQ/88JoeO80rT162J4pk6vaXHZoivNIijRnretjUVkTpyWO9bIahAN+2YhI1wcder8WyATfSSsCUG0/s2ZJLztkPbfgAr2EbuBU829DOmdbyJJ5BZsJaeJuNIptygzj1xrsk+AvmvoWpsPh9Yqxm+HLWw1vFZiNEIWsco33Qs7+qfR5kC6oXycGX9EUx3cmF1lz8UcxeLvVKNJH4szJaMqAFwbfkrujx0KICG2NRPbeiBTw+c7PaXQYxLWdGPkstUQTCwEafZMdXkHzyUogwdjOi2gQQCZXSRkbTccAV7iN9gEyAwAnrLL+1Zi4MAScDnGLF7KOgHoDnBXTkx9U4mQAHQ/63x4JB6HyeguhL/0vPmDdtl4zs+/iHIeCsx1hbOEwpsYt6e99zK3EgVr+LgDzCxOpFkRJ1pZLFuPQNlDtFlq+DXHRf5IfbQZXv27Ibd/46yHNyP6HlWH9MHxK99EpcJr4e0xmD8V6WiHbAYrN/d9tQHn80XdLlDRYS/P7P+F3I4
 DrCYOdWP
 xyvroGbDpfYwAMT99SXxFGaMf9+DDB14k956wjjoAme5h0wJkwc+Ik+0CdMIVeeLxxnSlMaq0styF4Y/oBY+dRFs2tVDzxMTpKRzxX3nWbNgrGw4FTAl4bBqsSOuN2zgtnPvbFTe8mMMJSyeJVgthOpR0mgv2M6w4P2oTluf0pKDkTkeWYMrXJz9gCKoKtt1y68HAdf+EiLZqWpuLq1OdKANu8LuRhQ1FFVokKMBgKnoSt/wHBis+Z5FoyLke58MGPAlLLs9VGkb5QEI50rTX5US+qhhoxLFYA6ZYPggExloUVVIIPEv+5lsYPWogunJGt52bpsM2gp12bhHSoCaTX42QwnNPsIO9gn0lS/qv+ZrdbTtwSDb0Yh4TNWOjDsJy/eij4dQEWV5OsRIC8LH0MaKXus2WcDXzUE48ZFAlbUdgWdkN9ZI1HtBrYfEakQX2Nc2qf0F0iAAYpAdPdpRmRhm6y3ysTBME0uSbsxGJ/3e7ZbYyw+Exk3cpfg==
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
index 958cb605aedd..b946f920b7a0 100644
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
@@ -1422,9 +1407,11 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 	struct dma_iova_state *state = &svm_pages->state;
 
 retry:
-	if (time_after(jiffies, timeout))
+	if (time_after_eq(jiffies, timeout))
 		return -EBUSY;
 
+	remaining = timeout - jiffies;
+
 	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
 	if (drm_gpusvm_pages_valid_unlocked(gpusvm, svm_pages))
 		goto set_seqno;
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


