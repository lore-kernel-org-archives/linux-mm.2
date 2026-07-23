Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A00B4C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B9D6B0096; Thu, 23 Jul 2026 13:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317D76B0098; Thu, 23 Jul 2026 13:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA9C6B0099; Thu, 23 Jul 2026 13:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE3EB6B0096
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:36:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B7AE14011A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:54 +0000 (UTC)
X-FDA: 85020746748.20.9B69F84
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8C10F140009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KssBK6/4";
	spf=pass (imf09.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784828212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3slUHnl834IP76VoxdiRinKrcbFYlUZTVsrXFJZ4JdY=;
	b=loTbOg64HbUYqRm0l/9DfEPGD/0/0PO3cdR4pShja0uIoP2zQ7TFwvi5z5Lnozm4n9+TWN
	Tg37GM1Wl1eInGpmLbZm0mXTSAZEICLp20664TlQLyE13DBI9VdI4220JwMDCwUtx3GxRI
	zT1pOGh6nXuF7Rr1cy/y27QeBDLlmCc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KssBK6/4";
	spf=pass (imf09.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784828212;
	b=GgHPhlah99sVw1HLQWS0uj70eUItvrFziSBfYI4dzc8pOlthuHJJ+ImjSBurHDEsJANuwF
	wSJoGYJbWlY93aH/o/BiEk+b50QHmX/7CaC2eZ2z5OI3OWSw/XFM39P6DBGBN8kxt8g56R
	i6Ttxb9IMGHie6RIVfslldR9UL1Etng=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8485b358552so974782b3a.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784828211; x=1785433011; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3slUHnl834IP76VoxdiRinKrcbFYlUZTVsrXFJZ4JdY=;
        b=KssBK6/4vLF+VqxOHAtKqTFamdx1ntZQFTXQVMV1s0zRyagUP52U+GF2408a6l9tFw
         9kmCsgGkR7sarsmhj0AFixGD7g1z/PmvP3YOpUEcwv75u6BJeSOXamlYNVEe3HrlGUri
         p5yO9PDq5ViLN6pLndCx5J31KdECL7vxbOdQVBTkPZZoTXM1U39pbOCFYPkWlmskI7XK
         R3Zqb76vnGKdTxTu+mk8hcyrLRCpIBCZCz7/Hh3Bkp4jc4FZ3Uh5rYwcCh+2EoDROTYi
         wNwU1msLPkrpd9mdkmQcGQuV7j5QtqSKDMfsRrhlbhxLzVPCxAm7fY+foeQZDUwecCsz
         6dFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784828211; x=1785433011;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3slUHnl834IP76VoxdiRinKrcbFYlUZTVsrXFJZ4JdY=;
        b=gWrg1uZTo5YTpZxr+htLarebLwta4CzEbtDVt41wAZUaAZ7LL2Nwbco7Tkk+VJT6XW
         f96qDYRcmsDCQYtn1U/7MqjwnbIBplNYVIYvM8WcmksaVZ4/hakSMmRDuCG3icMkamjO
         qgAaMvlDBEEQYrap0sGgo/vdvqgyOm5v57SwKCfq0sru20J5yQX283hi7cjEoqgJ75BC
         WgajbTrlpl4tfHK1krXvjhXaLSONB8S/7XOhVKHjLlI4bU1DsPg+Jp5T1vhrUaarNywC
         e+dleCMOfq/wOoRbdOjD+i1iM8uh0tyBaYByA6/KHmQBOqThpAqznD/HIDUaajOqnpL2
         4iLQ==
X-Gm-Message-State: AOJu0YwMvdz7HHJPwyYLKQ9NErxdPhH3zdTlHCtXl3QDpS0CrhmhkU60
	RTr5d7L91XhNp4KGMqN9B2Q7HPdZObolOSqf+mDMKapBlBP2AwLtewUU
X-Gm-Gg: AR+sD12mZLcfP24J3XDoD3eLNaJLKCu3bExMT3n0meglBNeLuqj+uj5SblM5sINqD85
	QuqDuNyg6Gj9TzlNou2urJhJXD0mYb3Vj1uRB/l3QxT0FiMP/CJvSf4Afw2kt4mSyD5qIu/6cz7
	W1GpWoftwhWztyyLdBebTwl6cZZD+jwiKwGK4IsSsREe0wmC/rkfomudp8Qy9AR3Avz9MKiDZhC
	8W4U8nBVGQdoGmf9txredocth13hESzaSq3TXzDDl61imU4s4S75Gq9x70sMMnjKkvYBi50pIg7
	PwaIFArYFn5ukxBziFNP616dOz7inTfnStwhOGV1CQt7QAQQiyYlci7gcdUAXgAQsIX3MuU2b7l
	VtEGyYYbJwOQ69yWAkqMkrTCdUd0syIMBvsMA1joBVGmPQ8E4RuQV2bQafMzbJoJijWdnHnAf1+
	MEMid87rcDeZ9vOr0A9xuntSUGhe8aDbI4ca9imQ/rIvUWnJ/yRIJtWHdgZwQ=
X-Received: by 2002:a05:6a00:27aa:b0:848:2d1d:836f with SMTP id d2e1a72fcca58-84e2bd6923fmr4526185b3a.28.1784828211456;
        Thu, 23 Jul 2026 10:36:51 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e20622dedsm2691612b3a.11.2026.07.23.10.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:36:51 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Thu, 23 Jul 2026 10:36:36 -0700
Subject: [PATCH v11 4/8] mshv: Use hmm_range_fault_unlocked_timeout() for
 region faults
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-hmm-v10-v11-4-c55b003a4b61@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784828202; l=3646;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=ZyAhBAfWZePcXjSsL7QqvsrSYU5bhX/lu/bgMYHTJjg=;
 b=U8sSsRw+6XM+qGDxpQuoe99V7LeZ+M1zXxyPfZetIcbxZBFVX+M/0/c0psrN63mtn0Gyjy1RN
 9IByi6+fiCLCWN+9DASYqtkcc69AC9zezCPbmBdSfWzMLLq1QDXujHn
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspamd-Queue-Id: 8C10F140009
X-Rspam-User: 
X-Stat-Signature: cod4tapsig9iu4aomznxp8cozffbhskq
X-Rspamd-Server: rspam04
X-HE-Tag: 1784828212-129868
X-HE-Meta: U2FsdGVkX1+6A97W/hFi9twuLhjG8LJUvy2mJeC22VTUMvtOwQAzZ9MULK7zAnW/9gxln+pKEdkwKYJOfeHIAJS73Y6JeJrS/oUA28WZ57x0DxaqmxhfzPgJcsJ2GVoZ6dQQ2z0L1mK9R9A7qRz0bYv0Y+aWd4BBk2NABJf+q8KEPG/+Q0AfR4+ZpVkYVDQjkOup/8pUmd4Wmdq6KT7j2FEo8ib9E7QF+70VVqO2h/Y830sQ8PTCMlPkD9m8yHTE4hhpMCUvQe/wN9oGhLrWyETnIUOShqSWpspasTGhmTBbQclwuHUe5UgS2sJsTMin2Ov5zjkuYdpOA+KCDFknT099H4mkze1ALOe8PuvG8Ls8WRSyZ/vkp1BLkM88CTUUW0vnFGTvb4yc/R6lunVgG3Zm97sVqWFzWA0ZUX6FJG+U6A9QUBS35OnlHcKHwNEICQ8BTTHyQetfi8l7RnaW6clixk9OQSr9mXeRKJ0UMCoXszdi7pl5Pq+brspEhxbGl9kd515mclNfCv/3Q5JOIUp4qSukWVhdvbU0J9RsqS4X8bdpx/BJD6NeMhgJqapjnxtboc4UIlG0jLZXVzaVSCrEBP2vmbFEBjecyBKXEsHEY9ZDGO9r/q7x4uKm1rYPTdtht+fYr3f2LOGdGbHj87tlfhwMYeZz6E7rU0uWnzt9LBeTvgefPtUC9gs3UBLuH9GKqIseNn/J2R9SO04sFmPtzzNII47t1/wNUGyXsiX6QRCVbN+VUmWnmqUqjUkvyaPENFih+3EorPPJmezUp5Z2rOfTWSJyiNp5T6JchKxDweOkDmmaOmTXrFCYkspcrKOUZDfL3sV1IShVeKJ4mzwkxSFiB6Ve4Y14HMDF8fwF0yPKth7WjngKJkhglnalXht8ThQnkIenasXYzK+xBj6ozxeh1ZI5gU5HkzTIIvIz3ZfPnmoY3ugXWR7grzpJ4hmHl7mJNnFB/YtsagC
 rwFU+nDs
 FZvXYTTCbU/kaIiXA8GiB5nO5kwEeUeXOEJ2l0Y52feTXvJrsmylAnWhvpuLhD6crHxaFVb30DAd2bfJmPrMAxky9LmKvCq+n5l3FpmbMnOqHwg9XJ7WMe4BX2PMVjphVHGhcpgz/rQaWNQpNR0JBCAtNJ5jFQSt+4Vzw6RJzFLT6y5wFvinPWn4Ev4eggUMmGg5SuQ/6P6v2jkEwo+cI3O+omrtG6NJ9/v5zVnip/68nWMyC5N4MWqiGkpghTPtrQbLSTLffNR3LFmF3rbyZUFX1pc9Hs4/rSdYBZJyCOyC3v7h7tNXf1UJpr3e3ZxTHM145n8Gq14cBs3AkrwTO62A/4DcT4ITvdITgk7lD8QItjKkbHzF2jFUogf7ILqMGvdA0W1Z0puYnMq+tED2iaL5szYEvbvCQWJhy/vrRkTjIs29SkAM69CqXC6uedGLgqwrcfoamCaBqKo9uGPmv6KeUkpL/FH2TloMtBDqQxPcO8IKgsTz2fvsxl3VmQwcyRnbmx+xVNnOe4BuynlRnXcTqBxut93Hwl2k/BE0zyNSHcsUOAcoHTfUfRyEkSo2ZThsNHgkKHKgeyDE67DG0bSNfuUkquzaAJGR2Wy8GZp5Zyp/ZQ9Q8gwJC0Q==
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


