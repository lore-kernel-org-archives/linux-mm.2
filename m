Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66209C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 21:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37CD26B00B8; Wed, 22 Jul 2026 17:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32E3E6B00BA; Wed, 22 Jul 2026 17:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD716B00BB; Wed, 22 Jul 2026 17:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA9306B00B8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:45:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3ABFF1602EB
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:45:00 +0000 (UTC)
X-FDA: 85017743160.21.4415A26
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 33DD01C000E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:44:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HdrkWS3N;
	spf=pass (imf20.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784756698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hwr2PA6k/yzOHBkhyRcV60oQVyvCsFMHOEQ+QEbH+Ag=;
	b=ERpn90hv2HONmIzr392NyFgaj/+BwEJczuHeiCdH2sF/5bD4UoQWlNo5i4MRsmMrFGRepQ
	/CzCRF/3q80QrlVxbj2aWCJJOpbL6EfNWhJnDESPLnuDvor85IzCCaYYH1rkw2Gb+bA262
	8PBrsDBfHpPzVVGXZUGLibpO4vQHOuQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HdrkWS3N;
	spf=pass (imf20.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784756698;
	b=PGqlxvB+3tIFw26EM0i0DGcuc5YmF8PagxGLqS4EQLfHToRKr3NV9hC7XY7qtDwG8NR/ny
	epPtYRp8to9sPwwUjS31gcUY9TY5hg1PtIaiFhH44ZtB6VsVbbBnzftfVLK8pddQsOSHAm
	xjavcRZ3cWp3eHHAdjL6bL/uiyo/m+k=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-848d21bbaffso593754b3a.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784756697; x=1785361497; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hwr2PA6k/yzOHBkhyRcV60oQVyvCsFMHOEQ+QEbH+Ag=;
        b=HdrkWS3Nc2ddkfX+9nERSUtUKBLK4q1CqxLFp8Kr4oEtt7NNW155ikj0oWsB//cVg4
         Ng8FrYMrMiTPongmpijRRNESinfR224A0i+NgqJeVHLCPFs0n/LACBDZW+TQIpf7CIrW
         2/zSCaMGFalZ1ij/6i4wJ2iN170FtKYicNIPsTh0ylVVSTtYn80QxfTClTwMkLMGJib+
         XEzFfE6RKSBaHgySS9jFghkRdNC/HCwNKeh6g+Rti88SOhNoPywoj7Xx7nA0PbGGafIk
         cCQPE+cahXSm5s9Ihc2Lok8/FlobPzlqmdUN79a/YVnXMY6imJnJF7GLXQsKEpp4A7Pe
         JOfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784756697; x=1785361497;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hwr2PA6k/yzOHBkhyRcV60oQVyvCsFMHOEQ+QEbH+Ag=;
        b=PvXxA42iksGH33g8X/kY2SWmt7nRMufRmgDGy1JHoAf4LOC68O/swUVkDMTg2fzk8j
         e5IL1XCAp7HWAyKhrVVNhhXzemoxp4y2A1GYzWO9iqIJogIFhblrlIvAHMwX2Xz0qcmQ
         BN8gwbx+5RNlM4vaD1m1rTHuKY1i9BWv2pc66m5U5rPnQIYrMM/99oEOUga7XTps/WGy
         Ds1BtZev4OkCmillzPdjVVRbTCIdSrSRosT66r69+7/AlGRWCf9vRStHHbK/oueSTj68
         Ybv/cd0XuxbtB51YdYYzBUZmx+zPZPPisrvUWdI+L9Ime+DAGGOGlqcJyeIYHiic1TFj
         OcWg==
X-Gm-Message-State: AOJu0YwKSQX812O3ddp2+M0WiYdHMTWw4QoQhlaSzimqpjdwBhdlxI9M
	I+PNT4MzGZWJ+qvW9u4amvqkIoMHWxEdAlFhHf7KlvW6zMvV898m9TxGiIykhee2
X-Gm-Gg: AR+sD12m8VL+vPqc6RjLUfGp40QBiTkqMh1rGAfZ9aOgpIN+xM1JPRhVlnJZLYUkvIX
	Vd/0ruQ0yYtrhQ9UmBzj7UnOCZRoC/KkRS51ffQgOoZjGCii28P85LxGNtaTpYrOmPK2fpT3aAZ
	Ju2nXnW/903pJ70DZJLiV+Y63OfUQPvEhI4krpw2hYYYc+1e7FKjDPzwYb5fwmsOhr4SPEBRhB2
	Ktk7ELmZlasNFjUmADfFaMlxJ6Hv7YlEoNmG2ZwfcPkvxU57dxQGiYF2djc1yCWxoScXssjN2Qe
	xYHvsklttD44SOMMLriNtyL4pCZLeWt+AfbtFOpC1WzQgcAmqyAzDZHJ/dgQvRnxR7Ugv87X5gI
	jJMU/4CcZAOrPs55NiHwsry0jq0bnTZIxtdkLam1fVHa8Mc20igaGMSUT1LNAj3m7W3X3hWtICK
	f/ZaVJ/f3XxJn+uwId02sphISCxIz9j/4SiailHuVJsG26XDZq
X-Received: by 2002:a05:6a00:1388:b0:848:7b92:8e74 with SMTP id d2e1a72fcca58-84e2c1b9f43mr598680b3a.39.1784756697112;
        Wed, 22 Jul 2026 14:44:57 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17237c3fsm1946297b3a.9.2026.07.22.14.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:44:56 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Wed, 22 Jul 2026 14:44:28 -0700
Subject: [PATCH v10 6/8] RDMA/umem: Use hmm_range_fault_unlocked_timeout()
 for ODP faults
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hmm-v10-v1-6-606464dd601a@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784756683; l=2457;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=wCDSwsZ/5jgwWzEqFja4q7w3SxWPNbitK21qCohy6H8=;
 b=oTLl/A3KKM6QVfczDQir+MiwWd6xegg7AP0nwym7Jb+EYIV4zgzMMZlGO0Uy3Tv+0wtFJYifg
 zfmA30BQ0D/AoP9W2yBY0iwSakKcdy31nmnUIbQ0QmfiWeEgduaY6fE
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 33DD01C000E
X-Stat-Signature: nc7j1naxuxxyhkkwhh65yhmzm58fm8o7
X-HE-Tag: 1784756698-115637
X-HE-Meta: U2FsdGVkX19s7Q7xh/BU9yQkv4V/Tib5cc6/xY7KccPEnmyfTO7UMEWa9T5IVS2XCg1euZO+JZCjj7v0ClWgHm7KP3kZ5EkIgwJGp6YW/uvG560yT30JlFu3CVW1VNKNHP0+BYqZ4wZZpB4ZQZ89ZMsF8mqCIObvGO4Dka+oHEYWy7gLGLOTJmp37NzTMc2Tx3GWTUK22cjP/q70d6c7CTg8SsOGeppUHRNdkmV3Cnv09MME7vD+qfphrWIoODWQftzuNH1zqD1JiJWWjeZHwSmTcwmUJ97nRsqbAukDLWGd+gB16pbhbAHD5SF5z42+PNJEfOWNRv8rJvNwnIfdIMZxH+5cDnGR8rU6tpxs0lBiwZGq3KmGIKoGYphWUMs6W4DMd95r/ITmWIju1+zSjjyxxR4U9kYfFtrcfGaIAU81y5gxDwLyyzmPBNieCKzr3inylPkZmmXB0k5/Jpu/E6rnvVT9zyX+itetdPYMDhvhRLbL2rb5s3ggk7b0Bsduu7DE7eSQKSEe/lnaiz3YU4OUv9g4o0Urczc4XzPV03blLx70ZZRwJRWrQV4i7sS0nAaPs/0JKG2f6s0CFORQQQLrvPgpt55EeFjZm7BaXfC+gXsH7YhFSrHEJMivCo2UTI2cFRH/zgFv6oXW9Dg3B7kdXk+Ll/cX5/OQsJXYxnn1LejlKtbGNuVAhRRdq+/CpCpXPzlUWN6puVJJJkABk7+FUkdTztnVvAGP02bd+oO+1xtfg5lj8BjSE4+vJU3ruZXSz4VMeT4H6BL7KU/uy0Zh/e5k2HZh+oLGM7gs94OpBmI3XWJbOR9bv6CbOLwE4YKE1xLlMPyA7iHLyNYBKNma/OMCtFMMW8MF6K7bc5eKYVY7gufrkJ5Du3eS0ucGG8cGf6y8Y0244UTI7MtJY7pSjLB6PRns9xW43iDviJobJZ3txamgp4efiCjfM1PJMy9lpXBajSsHkj3p1SA
 bgCJVNWi
 KpXAdqwdZGNnOJ/hTWDNdwkoOCEPTeOGgxvUuotv3EHo1blpZw32jSomLSI1mryjiXuD5DY0hYvID+eoyDvjoE1YcsyT2iLW54QOnh1yWKT9VMvK5Lm1F3ntSVK8eC4LOfXBOYqdj/UW2GTO2oLyPawmuTTGXZiz9AkyWrG5qHxVRSuPgIQjfbdBkgVwMkOhWzPSGNXBEPs0AImwIwKZMQuWcG1m4/HVSsgVZo9sbMk4Es5bXOb0lxy3G5xtzQUoe0/tFgYx54LLHt8vJ3VXLSnduwHy+ViBjcSidhDGdW69D7T6tTaXBRF/h0S/jVerqsDxXkCf4z0sS9Z87mk0Ox9+jjqW7neCgCYNhKmnkDSNeOJpKmY7ORG/xp/daVukxE6idzo4v6uE2ppw7qzeoOVd6o6SoWHJHPrCeZjWcI24ELMM1Sj6VAHyGtTw51AwGfCza1UCFH/Jz9wHTthispKUlQc6vyd+S1H+zxi3BBS3ICJRVFUCYroOfYEe+/olrxIHop6ES6mLOra6S5m7tCl5wu+DeqWIw5kDbKxmbXgVRNFrEccDS6uZbIcU/J0mP6E0SgLaOPlPPjvaK2N3MTOEK1UTxB0U74D7gaiM7s2GEA1g=
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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/infiniband/core/umem_odp.c | 18 +++++-------------
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

-- 
2.43.0


