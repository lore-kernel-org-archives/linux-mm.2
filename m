Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF003C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5616B00DB; Fri, 10 Jul 2026 17:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2EE06B00DD; Fri, 10 Jul 2026 17:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E156B00DE; Fri, 10 Jul 2026 17:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 771EF6B00DB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:27:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D731DC3283
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:27:10 +0000 (UTC)
X-FDA: 84974152620.30.DB00AE8
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0974E80004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:27:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="D/80s8Kr";
	spf=pass (imf30.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rz6324+iAv2KNy97kcq58R5fN0X8s7ommcJ7e4qhr4M=;
	b=beadgoDo8l/r20NOEAyQC4pS25w5WnaKqXn2JoKmwRCoeUrtiuI0505uTGN0Kx4Ee730qL
	0Uk2/tQyzIMlgo4HKM17m4vDGOzHIclPthGg+gvADu8ieSelbVNyU/gp7qvwybMco67DPm
	VlBWqAKlkzvpdZqMaawH4p/1syINFac=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="D/80s8Kr";
	spf=pass (imf30.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718829;
	b=hZJlbOWd9s8uHlFGXDgXQgXWuizeEL2QxuKzMvvS7Z684eoQ1MjnrafpqpzEgFy+B8gsho
	Um5Ek4jWuyg7o4yzPn5kKTvzlOMyFt6LmnN3uxXJg2BiycCTr70X+W65xKZVmMg+Lyi+M6
	1ORK0QSFV9dY49+HEESuWqpwBEnKOPI=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cca0c5799eso13433785ad.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783718828; x=1784323628; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=rz6324+iAv2KNy97kcq58R5fN0X8s7ommcJ7e4qhr4M=;
        b=D/80s8KrLQnxTWhCq97TcQ3AABSS+ujkMmBWA/Ij9FWpoBt7EWIf68GRQ0nQJ1V4U3
         Uvw0vgN91bXOrLnZrnj9Jvz/yY6Od640YTRmUgP+EQHQ8omT8TPugRo3yDsr4y9KCsZK
         3XbszXCN7Td7oQJ3Q/FM3jVyFL4xCqY/ez4KO4CCuKXhrhIHsLV0Rau0DuYr83pRVpAF
         ++vuoXDjB2I9BNyHXr3MXwctyK7XGqXaGuJ7TipLKYLDmAGGsTt7srvN67FvgF/BhY7y
         pVDZirrmeIH6GShsNBtkh2dxXECE9JXjxiksHnvK71PNkoWRu6vknICu6LCrKIsT/dfU
         FBCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718828; x=1784323628;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rz6324+iAv2KNy97kcq58R5fN0X8s7ommcJ7e4qhr4M=;
        b=Bp9pqhsOSAY6eCcl8SfxytIYZC6CHl1LUcESSyS49Rh71uYSUT5Jz8bsOS8NJmGpNw
         YKxlSNvrLDYHLHoJ4Pbge5l0OEqpUio7ycBruwn6HvKmURPD7P8zPjbAHdRBPTu6ggUv
         kEpWt0WhnNeY1JtbTOVZJylZ2r7XN1XUaromiPqXkgELXpNOyuRw9DWP3fZPvp9d84cm
         tlCWxTs3wMFiUuQqHDdymhRA6m6CgI3IIQzgaImrMVPlsQ7EqTWEFCTSEoL9gc8iHXhO
         NAIpIZkVcT9ZyttvscfkFSXrwWfYnYrRK1qeaYE60mseI3pS2gR0XfuWPiuafk2fePPg
         n6Cw==
X-Forwarded-Encrypted: i=1; AHgh+RqnQphSgZ1qCtBTg6ezrpVB+3ZQrmnbHhT9tXZ6Wo3ZXbilsGsBmJGc8YIHmkdspUQQjGlwXdPcjQ==@kvack.org
X-Gm-Message-State: AOJu0YwxI1R7c+GD+kGv+kcLvn2zgAF+jlnpruCCjYNP7OJxNIXikGhz
	cXCdDS+vg4Dp8WSQzf62K23N4bzXXD+4czwg/nKjMBwE50/DpVgyxKOW
X-Gm-Gg: AfdE7cltSBnzuMeTi2rJoYuOY1FAX32g57KY9LWiLKDEhtOaK6iFXL9hxI//0a+iDFO
	wetg5LxxC5GLalEAlNSdzKxLFxdS1zc9U90t04G8L+kMk9s7cNf+P8m8r0J4Vz5mutzvespcNtQ
	6uhcmTKzALGWWDt0eXetF4owmjXu6ILXgyz8y7ETkJqgb2C3zNVE3k9tkUCKGphNK3aGBzO5gc8
	kw58TVuLh90tCEvxhAizW5PP0yIS4mFhbrj08jxsE5TX+aWaFftzGJ/6J0wdE2Ay2gQg20fAbBE
	ePgS9K1KieM4R8HBiCp4tRqSYdxsZ7uh2E2ViUXZ7+ERtFI0E0i4eP9ADcRZKu/DFBm+ZD4Lp6h
	rok21IAJf+GER8kdf/HWivr6qDqrYPztdZ7f9bD0Zus8lMosa72/udDIonN2DEwa6I951Xljrf6
	kqvBr3CPxkV928MLRPlaYLVQTbXt0saS5OyIIPyf+VXGiA8Ifdr0tyXYoCNoJAUbeSREIOMA==
X-Received: by 2002:a17:902:d98b:b0:2ca:1bbe:c3d0 with SMTP id d9443c01a7336-2ce9f3d5e4amr6769265ad.43.1783718827906;
        Fri, 10 Jul 2026 14:27:07 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d3bd33sm65951165ad.58.2026.07.10.14.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:27:07 -0700 (PDT)
Subject: [PATCH v8 6/8] RDMA/umem: Use hmm_range_fault_unlocked_timeout() for
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
Date: Fri, 10 Jul 2026 14:27:05 -0700
Message-ID: <178371882559.900500.4008217424194230517.stgit@skinsburskii>
In-Reply-To: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0974E80004
X-Stat-Signature: hbqnrom87shx8x7emyhi1fhinfdho9ae
X-HE-Tag: 1783718828-961821
X-HE-Meta: U2FsdGVkX1+c2rFojvJXuU7uODQ7EBZ9+xLzE1ytP3OBlpbH3DzF6tjVpJBF7HbWJAjvJurHPQ41hWQgUi64a8cTIo2jaG9Xpph0JmDU8TIGVjIh5dq7G+NciaMfmYndepodwym2hjlTyesUfOUuTmI3lhavL9TO+NsZgWP743oMvrYCtFkFL6S8fDfbP4Beke8YhF3zdqIUz/74tyRynwmH3blm7l/kJDEkBNedXxni/SgJNuSpGvjFMlndmWTg3vKKbH1yM0bv294QKEq9drvmZvORLBsiVa2JxEJtiZpudpVwvcj674qcC1RIgBnj4MUDheW08daLCiEb3D/gMxVEmJ21XrXtTo5lSMCSsxwueTVwomFhknQuk9HCIPOHAcnFzU8XGfBifvz4qUu90bEOWfvnFDHvY5S6TCNP4XHyBfVkZVIIeRXtzN0t2F0VjB3DjW5yo9TFEY1SbqwCjo1IW7qCJPKVgL4uq4UvnkglZwCc3LiGIQIGIpeA2aE2/PPVoFzQvBkHnGuVnQU/Kzba01evHE10CkW0dLtaO7JmL7q96UIGEub1CzggdOovULBOp1P2XZvq0kC+9pws5E+OorwV1QI/Jm2FsrV5SWxt8j+gooO4/srL/r4zW9XRAKNIWasDOgukoW3A5P1BGLPVQg8DVA8kDTUK/x9MyanrOoxCgdpLVS4PXCX6CUzJhidjOTzHS0kKiOAdvaRShqHJB734+CanhubY68um8j0kQgiibNRbu5enrzDwoRYBJLMO/P6rZx3i1kGgM9sMxHLuIf2TWoddGV1wmuhvv3sOnbGrFU5jqdNIOkeZnrWMjT/VzSjELF6L8Z7OCwol5+I/tRg25s8+pzzuwzeQe5ei/9qGVf7iKeo8Vnulwtr9A6u4tlibClFVblMG3a3T1RG3204vgKguYEv1UCNSweVIoJ5KLCVbg57J7ZJ0RtHweTuIdfNOIOFkRtTTgrE
 QPTtg7AS
 X8bCkyviY4N7nyuMAkDJ/CnbnFc9wTitRhN6vWcZXoGOCIxD4Jdby+PELIlwfsEsxHuco+fFADCkzGnjqLJQnWhML3KtLTnSW15/cZPR0njsnhuJ/F1PXI3/kpB0mZj0MHBS85/X7Cm18nDOxJYzbmPaBFlD44hGLAur7iAmL2VqnLxjSIdThJJhYt+UmRYX3m+S8JsNWHpyotgSzcZNT4kc2jD4yx4D8sCEPnpT15Bnuaxf9mh2TfvhU7+f9v7U2qNBMrnh8YMMMBYI+RB9IEVsrbumCshcDbzDkj7kQCOqO5iVjSTNthh/yEtfJ4kC1dZQo23n+uIFwEpXEOPU+J4lU0PGMquHAkwDOhzHlQkhckpMwTVEU2BIQSacdSLNK7Yx/y6kBg5CYnTc85izgvNjqd9LrsJgJaXo86dPRJoLklXvkHxc+5kF1IvmeMrzF6SJATsQwt73QzGj4VLtVuCo/t7wM3+iR3bTp/C8JVt+RXF3tTLfQ5j2xoRpXj9H8Tina8obWxYnuQuXh3YRO3EWUkfuwZKNsnwpwcoTl8UfxbZDRRz17nZDOVmCXdqT4S/BLeJbjeyV3ATs=
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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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



