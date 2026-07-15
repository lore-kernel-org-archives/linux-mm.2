Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB8C9C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935346B00BC; Wed, 15 Jul 2026 14:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909316B00BD; Wed, 15 Jul 2026 14:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81FAF6B00BE; Wed, 15 Jul 2026 14:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3A96B00BC
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:16:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5B8C120287
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:42 +0000 (UTC)
X-FDA: 84991816644.09.1987C0A
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0003E20010
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o3kA96ci;
	spf=pass (imf03.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784139401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xews/oLHPsdqsmPpn1oXU4/lUwRmc6mOTrGvCA27l7U=;
	b=0AZLomK0DR7GaBcKtd0rZE4p87GP00Z18eodJDJh1UCrhMk6lVBbdCpsmZ1XT7hJfi2KdI
	jT7DWljxIccXmW3awzgtU2XZF+ptQFhrSI9yWPNhBMjxLJE3XCrfZBHJleOix8NxQgC1+Q
	IHJBzYBTp0mxZoyyQoj+kvcnlE1PZ1Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o3kA96ci;
	spf=pass (imf03.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784139401;
	b=1So/giCzFzc/HdsypwazDl2D66mleBYUraou/e5+RDFiHaIHZKG9anY6pgEN4bpPpzMYFw
	Cc7Abz/O9ZVuVykEUPgqsz0QWK3gv22X6zWmV45caBe+7aeSttgmBxpkuRDZyK+EH5Ky3B
	GgNrdaUsjIZnSlISE/fimrKSjTZisY0=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cae1a3a744so43743745ad.3
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784139400; x=1784744200; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=xews/oLHPsdqsmPpn1oXU4/lUwRmc6mOTrGvCA27l7U=;
        b=o3kA96ciRJLZmebH7N4U+1R+FM3TkKWLbiC/Vl3aGwn0hsMM0KO6RZ+tJnWfdwDB56
         V6BHkYaYJI8dwcANVgCtic730zlhxlpsao9S2JegQKHRuFSY06TDw0SRbYtPHpl+w1UT
         syU/qPN+tj4mgn038SUxCqyfC9lVHWWpGb9TyezGO+KDCfF89le2PL8JLvOUWOXHGB4j
         RAcMTZsRMpuW/xcz3f3a8CVc1wjWriXvUYyYhqYqBswa+Ietl41k7Xkb4+t8Zz21HI1a
         9StLZTPiqFhSx2leH1kJS+cQZ7+SjJN8ATujkIVbvWqfi5cjoCQEbL2s0CJJ/nUfuKMy
         S4yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784139400; x=1784744200;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xews/oLHPsdqsmPpn1oXU4/lUwRmc6mOTrGvCA27l7U=;
        b=kJHdnEA2QzUm6+D2yQQtuNQEA1xYw1t1ugeC1mBdozPhMHmrEk+rql+3MHB2TKcsWN
         z8lw1sEch9cWQA8wIitxMdKSjE3Ou6HbQ7BCgCnB2i2blMtdlywMaltfXkgPjw3WoreD
         P4S21toWLTDfOWAkJXQxyZwVQds9TO1I9UWI0f786Nc5xnOiyCQq0jp8ytZGjW1isjDi
         a9odpZNx5zOWP9kNXBOylKKvofcQsSPNp23F010BUaFLJDvRSoL8i7MU0HKjR56Hxc5b
         IkpQm/u5b08XDRgEH7Wa8WMPQHLxxTRbq0wdweVv6y8PWTrZGoB8FqGj/K4C9RpgWd/I
         cS0A==
X-Forwarded-Encrypted: i=1; AHgh+Rr+idao4Zn2mMoeZakc7zaNqSEn9d0M/FVILb7icJv/bl6kJurkW7qXlSUkDfWxn6lqqM5Q7GC7/Q==@kvack.org
X-Gm-Message-State: AOJu0YyO6G1WJuNDOSewk/vs6jqJiXZqbW+g/bbIVOV7zQzMNJskQhVX
	bXY4sHTDSlaLOI+trsbnwHLG/NayQFFYh+r6BkiUgCqOpA02SmqJBsbP
X-Gm-Gg: AfdE7cnG0r43CLuojl/FDQ9GtDbFVLt0Si2n34SG75Pqs8IvXEEWvdOoyQhdLjKXpkk
	ZfqvPtSDEpxJkn9FkVpayvDmjJXFmAM/Fy3bP+M4dwYO7irCriPjMNs9Mj+pyOdez8HM+C6TAWH
	JH2p+SYfnArydTmOK/nKYRlgxF6LLu/aSDS+d0RuAbnOz4imi+RSYC+V1aAC//oMycJoeT1Yqqn
	zahCd1fi5knsyw/9BvITF8M9i5kCVctVCLwSwiL6n13hlVFvUKLxxFje+GCV6oSnLfKMWP2N0UV
	OndWiOVr9ovxUjf1zDhQHw2jJqZTuR5ayk7t1ZzWauznXHeHlLiRFbnbgz6za8xKEWETrGxeuwb
	BXTYK+VJCxR/Haz0jjTCcaJl7lLdMxzIQH4294ThkDjHgj9z6gNOhkzKray9d4QSTwU6waeKPjj
	36rIkKQBE5OfpLRv9XwxH0xj5+eBtrgvC++zcIn+emCELD6WPwgLneYsLLN44=
X-Received: by 2002:a17:902:ccd2:b0:2c8:4c29:afeb with SMTP id d9443c01a7336-2cee9a64cf7mr89372715ad.8.1784139399557;
        Wed, 15 Jul 2026 11:16:39 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf10592040sm6621985ad.55.2026.07.15.11.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 11:16:38 -0700 (PDT)
Subject: [PATCH v9 6/8] RDMA/umem: Use hmm_range_fault_unlocked_timeout() for
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
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Wed, 15 Jul 2026 11:16:37 -0700
Message-ID: <178413939750.1155966.3639451690646685854.stgit@skinsburskii>
In-Reply-To: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0003E20010
X-Stat-Signature: 3hqcf8gmdi7c9iuwx1ubeq94x3pg3hoi
X-HE-Tag: 1784139400-436030
X-HE-Meta: U2FsdGVkX1/KXjLWWq67DNZfF+YpGqIJ38ZQvQC+Ezk+F1LrFnpjO14FMIHE5tKDUSIlTVXEOaWAT1Xku7bBDV3C9trnIbdK8vB47l9+D7sHuk4th85Di2zQGxWJxRrk9BjcXhJSNjRccyhp/NgwA9vpUxc3A0ynQaNRP5EwNX8p7msTJRoKsBWZoVhnOGc5IFp8IlEqPdzu4ycuLRX57TTSKkS80z3GzTm0jACI2NRMPc/WmqQgJl7SbImSeASaDbDZnQJANC2MEBiLN0mDboNYZhLy/p7FZ5FTMB/LEjlQ1oqpscy5DaJOLphW66GtdDS+OyyG2p92iEnAaOe5WnX2xkUS1oLwHoLOO/JJ1fwPo7tNvK2pX5kWuiWuM6RpewMFR2vg+XHBxtjCoCoRnVUWYFK4hlAGjKA8Eh05fxaXIvPLD0kMRPfvYv3DGd9G+HieNphz4164JiLqe/FHp7LQKWiHSEno5mH+NTsVU8Wz3tbyjZZPdlC1mdoWpA4FUEq6IMsaqRYNNo+OiP7NB4Y59ngQPQJ3hUrMhSnkB9HMB0ud6UCP94LyNxrs9iFERYW6YGpDwf6Mt+rJAzd7E7T+3lw36XOCkZmDJX3E/d5vLd8VcMiWjzx+XU1IMyDznofwG/iOyzVZp4EVrO7FlWJNWooADD4eUozzoOoGztGmVO+w7zbwsQJJJc2Bw/24/hV7sm8igDgVK3gELQh77V86bNkPH5jb4s/pIrdb2wALiS1wqf4uHxbZswa+u0w2oRtN8ar3eymemSAIMPDd4crfADEOtVPm6ovCjCkwIV0+aH+N8rfkthXtW/poJx07A1OzvqzauI9YJ3jyt22qJml0ZQlArLMgntM6RS8RZHBHz8olqTXCsyOmE1r6fdHuNXlDQTSjBMqzFSL1nsi0V46QjKU7pvpAA2ME/GFl3uA9n6Mkn+80lB7r5pSSgy6Jp8bbIXgq+V71edQ80Bc
 soOrft3l
 YfwJfxgXoR5KOL9y4RTHUXkX+2swdKnLZNbuizWXiBDtevYvTRxQDYfYHGAbIEHRAOAhvUgdboP8k1TKEq3FpUjjY/qizd/KyN7ApPmVJ+HZQR2ewhK1MeBnC8l3QW68bHGA5IB2c1/P+PtvPuNzWESzPO8UAJD2X/foN4kkDVVtCGYkNr9cJhJWtg/RP7VGi/TI7si0elwPQPhpV5hUrniq27PtdmHcIeg9iFIh+kEzij1oU5rwNFZZP7//2G2nVNyLuHuYuqwDjfvu5Sqb9cCwSh1IbTnsRuKWtl1BGnGMNMsKGHOL4uv3qaUHNIn496gG0O0FDiYrIJlriaG92bgge0LpQg+7dsEo58mayZNzFG3hZ/IUVrWrJX364f2AzrCcFc5ztGI4dyfwq8tKuzy6KERXNFESGAEyzpboxKS/a+T+Lk3sFs+I3o2PMhulJmPRvdudX4KnFuB2yAX0VPdBct4DFOQIhyiiueH54H5WFaZEf2EJz8Buw3NpHZUcdBsT3QOS3xKZOtglfa8O0YnHeGiQQnf6pGH3wDvFJHSoOUs2MrAc76w2mGxYCFaa1cYCThGPo6DHsBZ3zV8ETYDhuiDU3a9QFyLntYXR6u4G17zDWvP2vIu0TWhBMELv5qYzRzAY/xVbjkunx0NTKB7TKCg7JZiWsObX6sP4k96rHO6Qw9IEspCfiw/bSQ6l6lUb2
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



