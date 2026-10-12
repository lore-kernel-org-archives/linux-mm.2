Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1623CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 20:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAC4D6B008A; Mon, 12 Oct 2026 16:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83AF6B008C; Mon, 12 Oct 2026 16:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72C56B0092; Mon, 12 Oct 2026 16:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64FFB6B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:08:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DF02C09D2
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:08:29 +0000 (UTC)
X-FDA: 85315061538.22.58A3D75
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 63A48C000B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:08:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=utexas.edu header.s=google header.b=Y9tfxPxw;
	spf=pass (imf10.hostedemail.com: domain of peizheliu@utexas.edu designates 209.85.160.41 as permitted sender) smtp.mailfrom=peizheliu@utexas.edu;
	dmarc=pass (policy=none) header.from=utexas.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791835707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=C5VkKI5ZAzJ6cEJcZ3ResShuIP8Oeib9ArzUWA2J4tg=;
	b=F3/FqB6DXB6c+2AKdzUqrS8mNANOhpXDYE9ClvD14UHQjItjhPviE/zfC8HIKQIBvmaNOS
	YyQ2ddW029KWlizWvM0050zruDXJZ2QJwpSyNwM0KvQKpO3nXV0jYzxFeaNwFqFPkZaaWS
	rErulxqQsfyD0QrwWXDbmWjikW335YM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=utexas.edu header.s=google header.b=Y9tfxPxw;
	spf=pass (imf10.hostedemail.com: domain of peizheliu@utexas.edu designates 209.85.160.41 as permitted sender) smtp.mailfrom=peizheliu@utexas.edu;
	dmarc=pass (policy=none) header.from=utexas.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791835707;
	b=lTa9ZHBNZUMpDH9mB9qHWKh5nOITaJSL1Ci0rM8XH1RF8qkoghpzQPVv1KlMXOvgU/rvCV
	QbcFC/2gBs8jjw9c2ugNZvrsipz9Mpf0KBsZzv1t+HJ2lsNn6np4o4mpXrNAtpCrc0fx7q
	C8WuILEAFOccOXbCq0bzfhRLNParLzk=
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-43bf9548df4so1950177fac.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=utexas.edu; s=google; t=1791835706; x=1792440506; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=C5VkKI5ZAzJ6cEJcZ3ResShuIP8Oeib9ArzUWA2J4tg=;
        b=Y9tfxPxw7rB4fRCtI2TXR95nQqAvyRRwjtd+sovKILAyGmwtIZ8tjWlc33XAyJCuMh
         sxleZrkvLdhEVRNX6L/zsiECUf8B0zdmVYsKjfyA6NkiqY8BcSo4Pdf2KQrEJ4deuOVK
         fSQ4HRM6QF8KZfQuVBML03eDZSXKi+NQCJd/TjnTGy0mE9W6UFBZn9ytkn7rpfhnq0L/
         pVb7K2WMGeLMvymPw49StROJ4UcMHtt5CHWbOKZFGdYQNNELFPpKOc3eNiP1SxJSQIUG
         grwM27Ahu4t1DzYySvgYo8e4/aQDqZ8dZn/sOhKVn/rpd44H03DPnpO2x8aTKX9Q+3gC
         bwxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791835706; x=1792440506;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C5VkKI5ZAzJ6cEJcZ3ResShuIP8Oeib9ArzUWA2J4tg=;
        b=HMKjRSm2WgB5+uYmAb2mG3Da6+Dql/Qo07ZcQyyjHC2Uv8q89FMGAws9xiVsqv3tGb
         Ww0hdPu+FbjOZtVXb7e2RE6gzmfvhDfOt1d0+S7u6KS1xXfmmGVUFg5TnLN22fwGL2fy
         GcwarDJCgUIZU1QYUd+mmKihKv8O9KGDEH66oCAU8LDxoavAOkI7azhJDPb1DkmrCLvO
         HPWT6JN6me2DMVZmL+EiInjZBdsP7AHNYGSY9F4Invd2iAq4WKZaICleHQC3pQGIOU4i
         vwbhyGulr7sVVrtrwodXaeOB7g1WQdkgqWgFWtY4NFOHgOTGG9RHxkEWeyX7Y9mkR+zK
         ZN9A==
X-Forwarded-Encrypted: i=1; AKwUvBzQk1Vmd1sJrHBFlTIcHgAt7ufoh68vGBMXu0CYXsHy7MeQsT1UJq0Ik1oPzBH1ivhGZuec3DoEmw==@kvack.org
X-Gm-Message-State: AFq9FYKhmtn3o5Kv/4VNQmybLxGtnhc1T58GzvhnLeoLhmDj/+T1v3IX
	KQ+EO1U7Wqc3A6yWQqka1QfEQ8HR8ZSRf7WFqnxwLN2OqyPJpoK+qPgQK+vp4SpY+4Q=
X-Gm-Gg: AYBFou3kq1TT/rfMRkbbiMhRRuMiBF2ScMdEuqjaqnKx51njAGtUquVoF1iglXtzfpq
	UlTgtdge9lBPKXuDhSyqHcBo5baXmUPQyAIHJP8T0QoJtmehzJucbCbXqEUQnJVpWozXeBIZQ3W
	h0O4rUY9G/DftiGQmhP6RySKnu1BWY1W4nPMOqQRwT4f/b4ItvUSEK1QV2BYOPXflddxNkvpuTn
	DzCN6tALdM5YaZj4dcwRzDJ18nP55z8k06M8PSVPAcaQZP7asgOF5WecOhhFygLQQ6ILIKf19ql
	DpYtqINOwWhljXQw1b4v8qrmeBlNaSJK00dgy1cTYeg3n24prmog4d883AwLuoFctaKtX2vpR+a
	BP37AACEUXmrHm0Ks53g1zWrv7HudTtoAHz9Sf2egpRb/2i0pkr8yeyS0bUyWrYQ79vpS6UEOQZ
	vG9q60nIT1F3tl9JyiqKDDhg6bdfWRBX+ERZm8FyksgxdeUs0QfA1SNk0fT+UzNBd6QPxa+oLSs
	jLJjOcBdTNYznWy+BA/oQ==
X-Received: by 2002:a05:6870:63aa:b0:493:ab63:38b2 with SMTP id 586e51a60fabf-4a2a8b0cf44mr8930726fac.57.1791835706237;
        Mon, 12 Oct 2026 13:08:26 -0700 (PDT)
Received: from paizhang-U9.taila8073d.ts.net ([70.116.71.224])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a6aca4711csm2166166fac.4.2026.10.12.13.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 13:08:25 -0700 (PDT)
From: Peizhe Liu <peizheliu@utexas.edu>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	iommu@lists.linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] iommu/sva: Charge IOPF allocations to the faulting mm's memcg
Date: Mon, 12 Oct 2026 15:08:23 -0500
Message-ID: <20261012200823.699316-1-peizheliu@utexas.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 63A48C000B
X-Rspam-User: 
X-Stat-Signature: yduu5ggpxhw6qqbs66dsqcpabd6qyjxe
X-HE-Tag: 1791835707-349867
X-HE-Meta: U2FsdGVkX1+2tqSZg46SaYueR2lkCMFUyag+tqbK1htB6M0rv93Cc8opyRow5d/REu7jzv2ictqRQw2J4cxmfoXYleQD65+gq8DaqLPNU0bgYWTMk72m0xnYdwWPnLYeLX4lk4W1SC5OMz3T93DYJjg+zPVRNJgML2cJ8d3UTsfHsBJyp2OdUD5hQf0yTy6X9NUA9si7RisHqcjXgc1w4MQ3FOCieIzApmDmn/slOlMX7GHZZa4SkMWyYyHe/zXo/eC0mcJF72OVCOXsTph4xZKzr7JXj9+70xrncb2/xazS5BSv/Q7ujOwIToB6bRFGbsTH9rJNlZ/9dkDSFv8cdjO7pxInnBTH1mQdNwW7+0gzGoQKLBGO4Bh0THlAEcbWNHIFGmxLUTR11QYwb6dOFp/wBQVCdtI8rRrzwEWUObFKFMNhiKCGjCuFOxgihKsc2m2Dnz0qTv0UiJp6vTVexe1wR817SUQ2ZcNDimO5uXba1uFalKv/mLNUCUGiY3SvGXUeKp+5brCjfNy+jdO8fWuznlljpBadUxcdADNGG9G4sl6omWJleMmWtqXvP48w2nbXOs/qD3und/wbk8pCePIMonS/62OIOt/dlt0HuEPE61yuO/zh0GKiZc7UipuvPhB8l/YBCI5XCAiyEshDKoOgKm/aJW9XwI+8vq5c9L1+ZDRaIRuop8UuuDAJZYQbaNHea2jjM7YTzZKc6lv22jrLth9uDSMFssUGBVw73iKdB2J6acCveCssE3NLSsb5cQjyTc0dNUURnFrZ/aICLFDfy3S7/CDm1Z7tJpLKwvEj9xR02xO1ItPiadNZQkSb2YUlSVRONFu1vhbHZeuflgC4w4HgysR8D9U/M4mBY7R3VxmGXgK8v0A1NqPfAV1sonPpC1AFeM4/EZ5uxEbw6dCUkuBdGXLrxKKE82ynptz5NzuySTkyt5YGrIepzEKj5kZvh1c+WGWHyX36E7C
 FfuX9oiD
 F0XuviaHG7i6Xd2MaDEoTYc3pM1sczTruu7rJlqPnna8dppeg8leUHFs6xcOqfFA0/1mOkCT5t59+q0bHQZGL05LJUZKCduaAywug5hNa8m/aI80s18Bic/yY7NCJlPjxel9+keU6MHEea5ClZ5SygOn80q6r8vOxwXfv9x/sAj8BrJUIz6r64Dq2XjGWk3bpNLnHdjSuzpL8AblnpoNkqbetf46DEqoRGWbATf6t63kdxNspaW9C2ts2+4tVgvFi70PGXzRIauQF3krpji7PTBHUJm1nl6aFR3V9qam1viNF0Tc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

iommu_sva_handle_mm() runs from the IOPF workqueue and calls
handle_mm_fault() for the faulting mm, but does not set the active
memcg. File-backed faults can allocate page cache through
mem_cgroup_charge(folio, NULL, gfp), which falls back to the root memcg
when the worker has neither an active memcg nor a current->mm. Page
cache faulted in by a device is therefore charged to root and escapes
the task's memory.max.

Set the active memcg to the one associated with the faulting mm while
handling the fault, and restore the previous value afterwards.

Fixes: fc36479db74e ("iommu: Add a page fault handler")
Signed-off-by: Peizhe Liu <peizheliu@utexas.edu>
---
Tested on a Xeon Gold 5512U with Intel DSA, based on iommu/next.
Before/after testing confirmed that the block-on-fault case charges
the page cache to the task's memcg after this change and is subject
to memory.max.

 drivers/iommu/iommu-sva.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index 9827cb804363..9a825fac61a5 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -2,6 +2,7 @@
 /*
  * Helpers for IOMMU drivers implementing SVA
  */
+#include <linux/memcontrol.h>
 #include <linux/mmu_context.h>
 #include <linux/mmu_notifier.h>
 #include <linux/mutex.h>
@@ -220,6 +221,7 @@ iommu_sva_handle_mm(struct iommu_fault *fault, struct mm_struct *mm)
 	unsigned int access_flags = 0;
 	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 	struct iommu_fault_page_request *prm = &fault->prm;
+	struct mem_cgroup *memcg, *old_memcg;
 	enum iommu_page_response_code status = IOMMU_PAGE_RESP_INVALID;
 
 	if (!(prm->flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID))
@@ -255,7 +257,11 @@ iommu_sva_handle_mm(struct iommu_fault *fault, struct mm_struct *mm)
 		/* Access fault */
 		goto out_put_mm;
 
+	memcg = get_mem_cgroup_from_mm(mm);
+	old_memcg = set_active_memcg(memcg);
 	ret = handle_mm_fault(vma, prm->addr, fault_flags, NULL);
+	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	status = ret & VM_FAULT_ERROR ? IOMMU_PAGE_RESP_INVALID :
 		IOMMU_PAGE_RESP_SUCCESS;
 

base-commit: c233d59828627bfaab750ec5546e81970475f951
-- 
2.53.0


