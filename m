Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D35DC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 21:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59F906B00B4; Wed, 22 Jul 2026 17:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F916B00B6; Wed, 22 Jul 2026 17:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418126B00B7; Wed, 22 Jul 2026 17:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A56F76B00B4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:44:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9BADE1A030E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:44:56 +0000 (UTC)
X-FDA: 85017742992.27.7676019
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9F08940002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:44:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h0wo0fuy;
	spf=pass (imf01.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784756694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3slUHnl834IP76VoxdiRinKrcbFYlUZTVsrXFJZ4JdY=;
	b=rGZrnLvkOiksjn8Ee6xARBHltc6g/zKca/ZYVZ70RqzLD4CcwMThZAIe8QE2pcbBA0UJph
	VSHPlrnSWzQ5FjF6wVbR+eNzTdOoXmvxNle6FIs7HVxRJ5y6ucob9V8HEGcFE1onKoXqLc
	XrQxM9VwyWoXrfmNIKQHQMgUP59jxhg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784756694;
	b=CtAB+F7M3PHs9wSWONTVVNX5XWQwBMUPquPPVS88wWANZuQDxkexk4N2kQoEtNmGR2Xw9T
	xTuU0rMPs9rGYxdAPotB1tK8Ac3i05KhSKECDavjr1F4N8KQMiVtV+ycybB44utxJciB4q
	drv9QjtWe7hxgPsbkrd+Ni6/tCAJs9E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h0wo0fuy;
	spf=pass (imf01.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-84862b0d5aeso14253755b3a.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784756693; x=1785361493; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3slUHnl834IP76VoxdiRinKrcbFYlUZTVsrXFJZ4JdY=;
        b=h0wo0fuyfpD1I3dLG6Que5+AyNxdGP8rRR16XMaOV8k57umMXwzU8rlDKlP187ZvNJ
         0fbiOlvht3VQ6XR9FPeloUUd0EyAHVhXpRZV1P6tBshK+aHuX7kCJSkkGIJ8M7cOjRkh
         YIaCc0WhMKrh+nJpsec9n1espaJ+7BB7xMN9Zxqd1zt5S9Pi3yxJgWcLVkt+QKYmENZS
         TbQnajh+LXlnoGMoYGh+csHwodpXe+NgyBv0hgqP89ZeI0NaJQx7hPwb8fUYd9E33Pc4
         pAAMW/Bk13VnJEPGrFpyyrPflsEnRmCvY8qvCorrHiKsBA4ouU2bBRmtPS6XsEQUFqQ5
         VX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784756693; x=1785361493;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3slUHnl834IP76VoxdiRinKrcbFYlUZTVsrXFJZ4JdY=;
        b=VYHLbNQO9XsS2M/7QqM4FSpYb/qCOEE5iL1onRKoOnpnm/a2twIVMXNhtWXnIeGFsV
         Mir97WpWbce3r6nf1Rg3SfCre6LsUS/V8s3wKdOzdQfQX7g+dahdVUpy0UWOafm2TvG+
         YnU6mfnY1+LvL3MemBVr6MfLAYqGZjtEhOOvuXzIJZkBWE7ZDaeawDxtoQ78hxlPmh+Z
         v+jF0lA5T9F3QKXDSQPeskElw6/vxoGHuK26+GxJO0an1qsSPhi88+D2dFfb3kpEKvsU
         ezaAOk2kKkGMxH2mNInFKLt4jh4HnFlEMn2Rn5EcZeZGULYVSE0U1wtK+F6yQ3GHjAMj
         /qyw==
X-Gm-Message-State: AOJu0Yyw/5sJ9YHZWXvo3irHDP14g6B17gNagMwD0Ej1gZTz+D6VY6CR
	3zrc+qoIk0gAyArITY6ZBBPZSZjhlt1RqaqdbCPRBiASUPZUm4LmCl41
X-Gm-Gg: AR+sD10oZvENua1L4OKYE20Dl3sEAwAsQlCHU7mAAX558TslN+O9cteDD6sCpOsBauc
	ztO2W4lOtHKEbYRTCqwCPbQF4kXOKjPShu0bktvtwrdBeQZxd7m4ThebSBCFoLszdgGWDJZQZqZ
	oFR01RrB8kLc5fDLi0T2/saaOwvny08ZzutjogB0XWFd3dHuKg0Aiw1tcUmF+Gna5XyidPr5t1o
	2EyDGgOqbTVY5Lvu82DiNZbmpAupXMd8fki4NSMG+qmcye5WcBQ6axN0LaqbCOOLLGoKCXheqFy
	2UMMWvdbFyEtKBrAYJiOFLOUtlH4w95csyk3TYvtTGDT83lj8KER+bO0Ydw05BljjQ49gVJAVvB
	nhpkns2c4MuFuFw05e5W2/2PgubaVoqbArCBOGKvhqG/LLCfmvuArjxEiv/2y9M7kvpiKpbPsWo
	wDf8iAAc28XiRsewHk2Jcfgje15nknlQaqALLvIcGp5jE7GyQZ
X-Received: by 2002:a05:6a00:4fd3:b0:848:3fe2:c88b with SMTP id d2e1a72fcca58-84e2b7f59camr674000b3a.6.1784756693352;
        Wed, 22 Jul 2026 14:44:53 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17237c3fsm1946297b3a.9.2026.07.22.14.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:44:52 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Wed, 22 Jul 2026 14:44:26 -0700
Subject: [PATCH v10 4/8] mshv: Use hmm_range_fault_unlocked_timeout() for
 region faults
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hmm-v10-v1-4-606464dd601a@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784756683; l=3646;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=ZyAhBAfWZePcXjSsL7QqvsrSYU5bhX/lu/bgMYHTJjg=;
 b=tdDpNRsCNvmVGCNOZZ9HC3yxGmAH4ax4m27NmzACrsQovmkbRz97eJ93jI+rhX+xJ0J5zVBrq
 FSNwxKzSGzhDXRe3C8R+8iVP4estzVdVfYmBtDp3huLkA3AiN268Vyv
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspamd-Queue-Id: 9F08940002
X-Stat-Signature: h3kpd4jagqaw3f8grpjd9y7cuz94u5x4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784756694-752737
X-HE-Meta: U2FsdGVkX19yh8EBSdNYuva7vAXlEm+TMLTTWcUQG9kJMQkDmvJxeh3dfUiqyiRxEVK7IKnLsRYly3+nKdJqeVVJD9/p65twywbMlWww/kbwypcgD47W0zpeyfvfLJucECeYR/IdlXcHHajVd4L1hiHL9S5Rjh5khOs57CKEpNWZxmnkZTZ/6uGslEmoz/tl99i3aJPXTuS6V8j+slfPv9ri5nh2qu+CdwFF71tn6Teh6tvtPbWfTbuv3ZdksO9RC3TRdjL2ZlzGIDNyQ4LvZKAJhA/Ms+tWI/XaJlEVPbFbgfoXeq+4UL9SvVYslwJ3udHout6JMIEu3puWOIcng9HRVeGc/qBkto9eNwNfI5y0XaqZg/Nd/CwciLCfajLMz9sdKC5MEdfniQ7uAir6tr9mWfsbQIw1CLaJKcF4a5VUA1xmx87f5QkMDMZlPxClyLzI4MqWC2R5USTcvB498dQBnUWF0OjROA/KtOJYYM/devdN4eB7ZRduvY7z9TSZK3NPVDwqYnLnbqb17c69ghZpNI3gt/W5L8AijPFPo0Wqcl3IuG9YhUsUqkBbgrAA6Ln1othEB1tnR1xkCyLYdkHKPLcmaDx1svrK6TwrVpuqb4HvQFuSX4XqrxpFi9LGxAZYiye0AO40fg4vkEH1bg9B3l4SPuBZBRz1OqzcNib5FEYqV4mRv6vhBgFGsN0twQYBa5KCJA25OPZ9tEpuiIUkVcK9lcIk/KuH4MkIOxxYH23pwAOsN+sx6Yjm8etDobBl2odLf6elctRkBU19VJFNMeoWGxyrvUbO+AxiO0Bw+UvAVqq+9SlEaOyMZ5ItjgOedl5aw3mY06GTiqDhFzirIcVj7rO8vWZhRVLsPLyNnAB0UIn42aJXU99S9ww9rWRBAYCD1xHI6ldfWkhQSPxUo3c5B6JWO4qsCbbBF7xsSdxB7v4uXTddm3hWGPtDAd4r8pTbwb/3E77LdU6
 9xEJlBqB
 HO3NxRvuhg52VK5b0U0k3xG+KmbqZB0Xm7aW6gqGvWq96a8xHjng8CFqgTo0V7azv9p0bedOAHgpNQ+RSAuAN4R34mAleOcmQD3QxvueR++5++TneLCNn9weJSZReGAMC9hqGbOAOvZ1Qw5itYRt5m6j9s9qZWTeIRzr4+THfoEhSPE6D8MQkUg8S+SgvReQ/DU9g/MYOmF66huTp4YZkTLg4pk9wY+OvLq2qDUyzY9mGaVnJjJNv0AgVJUO/hmiZDDNXnxHMwR/6jvEh3z25ZgNtssvADuztkQKp0/SYz2gP3jEZIAy5C4UaR1ruSWzJZBXeyltJoxmLgeh2gH8scGYzfck96JvuIAetIcqkC6VxbnVc2NjPMc4p4B2jiu5cENE7xSKG6mpXoet0W5jo+ag6zBIH6j+/gSH1mOGul6KliBrEq2hAoQOd252DeEOpVc1fY12lBOrumV+6Gj9IznB+X5nJohzpNT71Elri/PPCpoocM43HKwyBZ+h8Cm1f5VzejSS8dgCs8V/LC5pOBtsUIY0Gdaqb93GjQOFrEQ4HAH5nGKa7xia+Y1CIW5MM7bTQuCP1b5JGN82if5rN6mm9Qyi7bj0rISkKm3afRugNBAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MSHV currently faults movable memory regions by taking mmap_read_lock()
around hmm_range_fault(). That prevents the fault path from handling VMAs
whose fault handlers need to drop mmap_lock, such as userfaultfd-backed
mappings.

Use hmm_range_fault_unlocked_timeout() instead. Passing a timeout of 0
preserves MSHV's existing unbounded retry behavior while letting the HMM
helper own mmap_lock acquisition and refresh range->notifier_seq internally
before walking the range. After the fault succeeds, MSHV still takes
mreg_mutex and checks mmu_interval_read_retry() before installing the pages
into the region, so the existing invalidation synchronization is preserved.

Fold the small fault-and-lock helper into mshv_region_range_fault(), since
the remaining retry path is just the standard "fault, take the driver lock,
check the interval notifier sequence" pattern.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/hv/mshv_regions.c | 54 +++++++++--------------------------------------
 1 file changed, 10 insertions(+), 44 deletions(-)

diff --git a/drivers/hv/mshv_regions.c b/drivers/hv/mshv_regions.c
index 6d65e5b42152..dddaade31b5d 100644
--- a/drivers/hv/mshv_regions.c
+++ b/drivers/hv/mshv_regions.c
@@ -381,46 +381,6 @@ int mshv_region_get(struct mshv_mem_region *region)
 	return kref_get_unless_zero(&region->mreg_refcount);
 }
 
-/**
- * mshv_region_hmm_fault_and_lock - Handle HMM faults and lock the memory region
- * @region: Pointer to the memory region structure
- * @range: Pointer to the HMM range structure
- *
- * This function performs the following steps:
- * 1. Reads the notifier sequence for the HMM range.
- * 2. Acquires a read lock on the memory map.
- * 3. Handles HMM faults for the specified range.
- * 4. Releases the read lock on the memory map.
- * 5. If successful, locks the memory region mutex.
- * 6. Verifies if the notifier sequence has changed during the operation.
- *    If it has, releases the mutex and returns -EBUSY to match with
- *    hmm_range_fault() return code for repeating.
- *
- * Return: 0 on success, a negative error code otherwise.
- */
-static int mshv_region_hmm_fault_and_lock(struct mshv_mem_region *region,
-					  struct hmm_range *range)
-{
-	int ret;
-
-	range->notifier_seq = mmu_interval_read_begin(range->notifier);
-	mmap_read_lock(region->mreg_mni.mm);
-	ret = hmm_range_fault(range);
-	mmap_read_unlock(region->mreg_mni.mm);
-	if (ret)
-		return ret;
-
-	mutex_lock(&region->mreg_mutex);
-
-	if (mmu_interval_read_retry(range->notifier, range->notifier_seq)) {
-		mutex_unlock(&region->mreg_mutex);
-		cond_resched();
-		return -EBUSY;
-	}
-
-	return 0;
-}
-
 /**
  * mshv_region_range_fault - Handle memory range faults for a given region.
  * @region: Pointer to the memory region structure.
@@ -452,13 +412,19 @@ static int mshv_region_range_fault(struct mshv_mem_region *region,
 	range.start = region->start_uaddr + page_offset * HV_HYP_PAGE_SIZE;
 	range.end = range.start + page_count * HV_HYP_PAGE_SIZE;
 
-	do {
-		ret = mshv_region_hmm_fault_and_lock(region, &range);
-	} while (ret == -EBUSY);
-
+again:
+	ret = hmm_range_fault_unlocked_timeout(&range, 0);
 	if (ret)
 		goto out;
 
+	mutex_lock(&region->mreg_mutex);
+
+	if (mmu_interval_read_retry(range.notifier, range.notifier_seq)) {
+		mutex_unlock(&region->mreg_mutex);
+		cond_resched();
+		goto again;
+	}
+
 	for (i = 0; i < page_count; i++)
 		region->mreg_pages[page_offset + i] = hmm_pfn_to_page(pfns[i]);
 

-- 
2.43.0


