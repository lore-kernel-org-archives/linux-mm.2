Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91112C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757AB6B00AB; Tue,  7 Jul 2026 15:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F736B00AC; Tue,  7 Jul 2026 15:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D596B00AD; Tue,  7 Jul 2026 15:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37DA76B00AB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:47:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B4E43168F4E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:47:34 +0000 (UTC)
X-FDA: 84963015228.27.2F676D1
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id D8902A0010
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:47:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pEfiY46u;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MurgedTImf2dmSaSEEivYoY5j30SVqg6Is/CYFnqB6k=;
	b=jcz/xecQQP2CY6eXzyWipgt+KdujAV5YSDDXcm78t88Sc2SABOO1yQolMnJBzBfpuqG9ql
	eFjQcyj7+RWB4GR+VYiGGeANHFBwAdJgXZje0CTaQs4MHjhAd8GOPhIJn9sMJOEIZQW+vl
	h/PARAaW3ctevoJqCD1+FSiIR0Qnqpw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pEfiY46u;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453652;
	b=3Lt4cn6QSX5kfb/BS5wqeIeu7VwlRYc920aIsQXZRfkC8X2jWaYpeYRU6XdYLY6jQjX6Ga
	NPacr2iJPKDkaGotlJDjuM1xb0iVtvKJr4Sy5v3DHhpk6K24mEE7s8q6/RmWuL7YMFZEn8
	6U7gStH42iHi8Bn/MyaKDCpUAdXnDG4=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2caed617615so38589085ad.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783453652; x=1784058452; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MurgedTImf2dmSaSEEivYoY5j30SVqg6Is/CYFnqB6k=;
        b=pEfiY46ui3dGML+hVwa7BmwTOTXBHnGVj3IcCL7SJTOHTHBbRy8i3H9gew0W6zlhFM
         CqiNAylNmUJYUOePeXcWNpqceiBGYjkTHyMZlZi6aXUsukV/YafWI0LMo35RSRHChu/N
         ojl8LP8FZouvElF6MEX7/1O94YPqnC1k2JDKXt8+rgeG8dGeDNuThvpViQuB4r1jiV81
         51ykWpj9s61ipMWEwiPCZJUzT7UpXHqMcept5RTZM+nvowaQ+pnhNJRdUD/Fg6WVspmW
         Lgusv74P33XdXnqMzVrz+NKTbH+H/1bnoD4XUlDlb87YOGzDf7zjEogWab0JjAQ91aRQ
         5JSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783453652; x=1784058452;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MurgedTImf2dmSaSEEivYoY5j30SVqg6Is/CYFnqB6k=;
        b=sVbSsO+sR5dCnAD5CIHtvFVNeD3r7HOqLnZfQNZjKAX9dj3DQkCNFIvgwaV6jo3JjP
         qK9FxdL61SfN+yjBOq27TRz7wZ3b/S6BhAnPj+I/qxRH8A9QdCcjNyppDk5NK2MJ9jBd
         8Lv79aO2kv4iP//9Z9e5ax9JE2063LxgZ4ivDGmBlChnokfV3VeMfRtO22Xpce4aFTB+
         rEEdVoaeZFqOMfzCNDFGKDUWep+Ei/FnBO9BYCdzMIo9kKoePY/AVHMm3yBj9Zkvi0md
         zKbc88UL2/nBn7b12/r5pmEp6YYQCjOeqHYxdd9kz+23t/sodk63eNoQ0HCKaAJFU9e8
         1c4Q==
X-Forwarded-Encrypted: i=1; AHgh+Rodnys0BzriwORH7rUSsOsI/yVQNHgqpoRgcV7rm9TLvGTtnIrjIp8xEBYeJI8mq2oDorNOqoLgZw==@kvack.org
X-Gm-Message-State: AOJu0Yzkwh7B0uuF3LqrT/+W0lfjWn0iaUYfePDfbIlCXEcemD/Ls1dM
	A58jnXiz9rxIRu9FE1qFhEuS/G7bsg/fXK2Agifyw5lMixzfRUSBK8Nb
X-Gm-Gg: AfdE7cl30gmVT0ScBSDl2pXQMfi7Tjg4dhb2pD9wuafusbks6dhmCetLBVhLbcP14oe
	5j+CTMMdkEieAREIDr+C3OAwaMygLPDUFApSavEHqRdKRg6MtI9GdLT72e+eO4OWCiCLbCBqfrV
	NiKHIZ7jDPXvpFzVlPmH9eLXmvETEA1Mn6Iw8W2nPoGcQ0GEnFeKLV22cF96lJV0pT/wp2csrT0
	muHOvoErgv/NzLRStTPdV7MOvdUOX70dADi1IwKfWwZHhBNdqyvg26jvyQ8xmBIaPwqn4A++1MJ
	6etjz8K/xX9asLhCSfG4Ran8IeDrGkjOBMZpOPoZMMJP5zQKPQYf9HSJAMDB/Vsxhh1aIwCufX+
	YJNsXO7z9XUkdeAiS2dkb5r2P5sOxZC0skXggGTE4RKIy73RqSR/2sh4fAvfi/Z1HrtA072RHmV
	tJqOEzprf92ZP30KbYRZoY2Datpk0ZSV6zIeHsAyijs6Gfgas/KohKqLRgSj8=
X-Received: by 2002:a17:902:ef44:b0:2c9:cf62:6f61 with SMTP id d9443c01a7336-2ccbe616252mr63274975ad.17.1783453651528;
        Tue, 07 Jul 2026 12:47:31 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d1e0c4sm17270585ad.49.2026.07.07.12.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:47:31 -0700 (PDT)
Subject: [PATCH v7 6/8] RDMA/umem: Use hmm_range_fault_unlocked_timeout() for
 ODP faults
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
Date: Tue, 07 Jul 2026 12:47:29 -0700
Message-ID: <178345364975.660027.8790629832830633290.stgit@skinsburskii>
In-Reply-To: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D8902A0010
X-Stat-Signature: wiosrg1p3e7sbotpbpotnhwkdha3o4my
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783453652-638254
X-HE-Meta: U2FsdGVkX1+pGlenpVWLxfWbdbrrVThQBKDj0UJsnfoLV35M+SFcqIUPL+YZdnsvUWei7nrBFhnmXiemK9tDSUQJ9yeqT/fvDSS0TN0uZFh9+J0DhNZRrR5Rk3w2+f8+Ra1OzUknquvmLHAfWZo38M/Dm7EJXR8TlyUxYiu5j4faKje5XAYvUDMNU4yoMuYovDZ0XVkHtIXLD3y7KjEA2t3cVPk6UBAQg+V8LNnrAkd/+2CAdKgvPKrzm+Vg/m1VDLA9nehbiP6EsTgiPAHjPfkrRSQAg9lBrxDTZHgtaT2ppEe6DQg/2kOVw81gt7Wq8Yg0tkjDz+F2uFaWANfuJltWrcjSoc8AKSogN9q9oSERN5+IZnInl8ZzCU7o9lto006NsKEIrwaYiIz26AqKw8pf/ToOz1wIYZDkkhwuPLE3gUGmsJglv1hTxpxcPmQvt1Avv0xwULuQt1ZGGOyMnJbdMp/n+wZiMLnGFiUza74beBAEGpN3GbtYjb1z5iAHEg88Cafhh7pZwDbzc4UrjC087iT5JIG9iq7R+RDA2XL8tjJCJrNLUYVup/pjoIlm0yvtOWTEaUT224Ap9nfCzHuhfx7ttKyCF+9g3XZaJFFlQB5ajqUaV+GuFfT900OT2qOi2wbQRgNCqe72mpddLZTJOoMicjb0n/G4CVqm+FNsnTGfQNdFc/uh1O5DTdqujyWY0eiHQ6wX2ix88lwm21cXDAbP81pOdWuHl7lRE2ZEEKiR0eiOm+dw1+0miH8DNuow8VgXvPRpmRX/+ny7pfmJOVR0Djb6/5AxMhU17pC5rtcv0IitF52FPRI7CI1VXHBq2XTe2WHm8SlrhSJc5UQOTvGE3qaUXfyCaUjwWapC+qr0Xo4/vKEb86MCm8Iqal21WWw2utRWEZUKngoZ0pMry/gP98zkTDSVygqfj107r322jELnBlkLoyxTU/gOPR9h8TJpzacU9oXp1NY
 V4H+jSj6
 Z2rTRKx0m868PHwepwbto9uWHUd1kXIh0RdHgDbWy3Qa3w2fC3nlxz+AOY82ZwPMEKuzhKpkdkTg8wEXb+zT9sLRdVZAW2XEDBwm/HMo8j5bBRHcS5VKL35YJ+hRDZlyIewR1Xr9j5nV5HEDWC/rMFMjGW+RnaOovZckj7fyWtea9mFNV4h+Nvmjy+exavicjvnIuCK9G9Rn04LIYEzcoFgPBQH/BxaUmSCt4AvCE/VZ/fXd9+5Ql7YdAgRd7tU2lCeD3kU4HcHrWcMtf7BQnQljAszxYeDQROWYB/X4m7n2DrQoM8+r65HHhimvhRJY3KGl9IdWAvwfKhXrLa1ISdxElZFb/jxwc6GN6dMV0jz+Z+JFqJ1pEci3BfehxRgbzHanlt8STSGp9l2ZoHoxpUj9UUw6J70kjthdfSAF8R035X7jVfB0YF3sYONii2PA1Umrg+sq6YKU7hR30scg4ifW8C6YOapPRjWmj3V22+dF4muE0xLDeGE8D+EjtEziVOltd+O5qHIqCu1zthvmAFUY2uBzSqFqkeKxBcEEylfUcTMBnhL7iihs2fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ib_umem_odp_map_dma_and_lock() takes mmap_read_lock() only around
hmm_range_fault(), then retries -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT
expires.

Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
the mmap lock and refreshes range->notifier_seq for its internal retries.
ODP keeps using HMM_RANGE_DEFAULT_TIMEOUT for each HMM fault attempt,
while interval invalidation retries continue to be handled by the existing
outer loop.

ODP still validates the interval notifier sequence while holding umem_mutex
before DMA mapping pages.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/infiniband/core/umem_odp.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 404fa1cc3254..9cc21cd762d9 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -329,7 +329,7 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 	struct mm_struct *owning_mm = umem_odp->umem.owning_mm;
 	int pfn_index, dma_index, ret = 0, start_idx;
 	unsigned int page_shift, hmm_order, pfn_start_idx;
-	unsigned long num_pfns, current_seq;
+	unsigned long num_pfns;
 	struct hmm_range range = {};
 	unsigned long timeout;
 
@@ -363,26 +363,18 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 	}
 
 	range.hmm_pfns = &(umem_odp->map.pfn_list[pfn_start_idx]);
-	timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 
 retry:
-	current_seq = range.notifier_seq =
-		mmu_interval_read_begin(&umem_odp->notifier);
-
-	mmap_read_lock(owning_mm);
-	ret = hmm_range_fault(&range);
-	mmap_read_unlock(owning_mm);
-	if (unlikely(ret)) {
-		if (ret == -EBUSY && !time_after(jiffies, timeout))
-			goto retry;
+	ret = hmm_range_fault_unlocked_timeout(&range, timeout);
+	if (unlikely(ret))
 		goto out_put_mm;
-	}
 
 	start_idx = (range.start - ib_umem_start(umem_odp)) >> page_shift;
 	dma_index = start_idx;
 
 	mutex_lock(&umem_odp->umem_mutex);
-	if (mmu_interval_read_retry(&umem_odp->notifier, current_seq)) {
+	if (mmu_interval_read_retry(&umem_odp->notifier, range.notifier_seq)) {
 		mutex_unlock(&umem_odp->umem_mutex);
 		goto retry;
 	}



