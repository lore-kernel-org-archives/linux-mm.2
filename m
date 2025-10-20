Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC279CCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 03:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12CF48E0008; Sun, 19 Oct 2025 23:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DDAF8E0002; Sun, 19 Oct 2025 23:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE71E8E0008; Sun, 19 Oct 2025 23:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA4228E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 23:12:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6C88C06E1
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:12:00 +0000 (UTC)
X-FDA: 84017018400.02.FAFE45A
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id B82BE80002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:11:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DqKX8QeP;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760929918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hYVUw+fPmZYdBu0dYV8qfxQD/UKizDlu37nXhCW5PwU=;
	b=4MyrnwKpbu3Z4cKnjLqn3DnydBH3ZxSlO7a1jEemF3yougQxs+EL5mJqtjKbwdVbxMVbq+
	+CrFLEl9NKiFim1/lKnsDB9Tsl/gcy5TBxCEPhWLe6p+kDJUr9IcqDkBuf0oSgbCOGNo/6
	0AE07ZSloopaJiiVzEHBYJwgmySXc0o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760929918; a=rsa-sha256;
	cv=none;
	b=QvprE7HItmImOFA4VW9Kap2Z7ErPne6K7HRseG5m+MqqOi8vvJThiJIEo5tTedteIlxAd8
	/ckkXtQ3D4p5mEGfMHJjL5NBLV4fasnEEzyck0c1Fi7HZdSYqjIchOFxTBfZnRW+qkUiFu
	H0fHsyLdh3bYe6nByZUhIMV+L9d1+Yo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DqKX8QeP;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-78118e163e5so4097809b3a.0
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760929917; x=1761534717; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hYVUw+fPmZYdBu0dYV8qfxQD/UKizDlu37nXhCW5PwU=;
        b=DqKX8QePRca+EHwJVV4YkoC2FcWI2UgiDoGGIQYSlVHKyXSFx+53ua7UwoQK1ssiV3
         z8Iym1lZycFeVJIa5A2uFmPDBvOfQ3tgvwOpgdVqi4XLtys7mAKk3NCIMuJFI5mxMwA6
         S8dJ/rTgnNjGVzVDpDuqavZNZHxRnWdFAEIheNVfiSnlKMrkCWfDWTMnS7zJb93wEARR
         loNi8yHMO5HeTDJAs1Y7AF1pLVo68w1mf0V0wIVc36nNOenluYRQoBzQkGTs69bF/6sm
         xpcI3+jgN/QuR++7aUHp1qVlPlDjVxJh2Uz4X4jA2IBpXJx0iG16cvkjVuoWtEbS77fd
         x/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760929917; x=1761534717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hYVUw+fPmZYdBu0dYV8qfxQD/UKizDlu37nXhCW5PwU=;
        b=izB3Fbcc/8U26Fo3aZ0W5HofPxzChpDZJfAmqA51ITvAvmTnOwsoeX6b+lMU/jAZ7m
         3Jm4Ditj9MUeNMkEGqSF21lpxK96irjLJAeIE2b0sIFmn6hSa6sz8pALakPrioapBaZt
         neRnsjBV0BAngVgi6ksd4E+SPB6ZZT9/ZjDL0EmDlkmGc6wj/IRn70RsI5boTYSDaNMj
         QP+T7Yw8yu5BaxHAfP1HLlOrooqAfbEv2Y21vkLT5AAKulZnRSxllj6RpUGsvxMoBrwD
         SqWeM+tdALOppyrbJUUvIElwHinkvD3XelLa5L3i/ufTqmcHVhjna7MRsEQnO3Jxv42j
         IgwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGii+9rRGUziBs+eF4Au2jURP5irYwAjDCWdmdIqZGjkRporT9N5nUN1qjsaEqABGaKfLIPiwh1A==@kvack.org
X-Gm-Message-State: AOJu0YyOhDJhcC3JgUALKDGCtK8u2JD8B4i11JqYYJqfj+gq27OdBYyf
	IlNsSYRzZT/Vjk1fTLoEYsGzfMHhsY9L1Jni1bHxDDrjTIfa6js39jIH
X-Gm-Gg: ASbGnct0rWONcwVzrd2xWDqDTzRFM0rfHkEuDdBOz9h4xJ+dpy9neyZ0xox0P6bkPHN
	kA8aotVQM8r/T2YiIgJ3SjoPZDbMqIBszAONdSG/UNJaSItlSxwGn4mLeM2hpHIL9boy2VUHQrf
	vtOsPsKZjnX4wnWMBjhQ2DAI732QKCHxbLVEUcolK8k0mamFaqtydWgtMZSnEn/Kk9BggU7hfSe
	XqUDA83846Dt0YBiXuf9KQs+8Q1bpVs5GWtj2bkFzTbQETJDlKuwMvyyCso5XlbuipATZcf6dS9
	E48x76ZFi9Fu/gTE6yviEtgJgMa+LAZ1aNEB1pTxLJz73kcEH+LQewaajTnAgaIVXx9aAwG5OSd
	8BZrdx3Qh/oapO/+eMASocb4N8WluQ48uaFb+Sq3beUOlrYEiML4Wy0+jXTDLd5Fh5erdxT3UhM
	zL5fGhgi7CvTuTWO3W/O5mWxcbdz1CgNrxR3JJ4SmI
X-Google-Smtp-Source: AGHT+IF4qiKYYrriCit52NOBwzoUaKDxVA0F/Uj9jTkB91/QV6fGlsElE56OWu3htp/1+IovxbcUZw==
X-Received: by 2002:a17:902:f710:b0:271:9b0e:54ca with SMTP id d9443c01a7336-29091af4271mr204346835ad.13.1760929917575;
        Sun, 19 Oct 2025 20:11:57 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1da1:a41d:2120:6ebb:ce22:6a12])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471d5794sm66007245ad.53.2025.10.19.20.11.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 20:11:57 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	david@redhat.com,
	ziy@nvidia.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v11 mm-new 04/10] mm: thp: decouple THP allocation between swap and page fault paths
Date: Mon, 20 Oct 2025 11:10:54 +0800
Message-Id: <20251020031100.49917-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251020031100.49917-1-laoar.shao@gmail.com>
References: <20251020031100.49917-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: zi16sywnixfooocpnacdbttwphs3oy3t
X-Rspam-User: 
X-Rspamd-Queue-Id: B82BE80002
X-HE-Tag: 1760929918-781709
X-HE-Meta: U2FsdGVkX19f5JX9HECHz5qoAo2RwByw+yGzRC56xTiQ8VyYARXJ1MJO30SCavd8yQWKP8jESuFXTxEJEpLz1kMWYvdGikNBXdmZEld7e+wnPKugYcoDVyv6QJMzXy4670EvYo+FgRJIBuZj+IMymYwoX2OUuE+bV2FgxNPqCVSj8LwaMsUcWifJFT5ZQLOKNygCCJP3bIbNNAg/6NlJfhXsLWUsbRe1wp5LFQPTge+t58VupcRSXqHgxZAxK1W/Zrc4dBZ5c4Y1gvHrAiQCGbKiKTFBR9mfNfaSju6FucWLMq/JI7yWn3u7EBlIH00hJUBszaMc0ZhlEagK0B3kdSfXeenW8+xxbbdna53lkfkQQ9rFN3qlSM+DLsTb+gF8xATNz2Wcg1+9UM7lLS7uNx8XrSNpoVsnoTfoN8R7lV4XRjKPBiD/Np9ZdZ+OC2HWNx+DlnYFH7cq53XUsAIk9DBIMO4Zjb2+BezrAwU5D7ePgFwBGbTFMMwjv/7mJe2YRAcBu8Go6vyZsDaCgDmPFPhGC4W7B00mq+7K4NbUM3VgCUtTagiM+k7ennlTu/rxkW898ZFOdTJcQMioKysAcG0sbsspw/AhnXdr0UT5L8YgePu12HycKbPlhDRy19X50B30Vn80WAfeGPptLmGvz5ewHMZR9rqmvWj4yo/3pmrOgG6nMsJAJowxTpub1GhvgolZUi6lJLsWZoPOoF/TWamK/3bVWAJxLjuNzNcDLjAHCYW5yKvJzTsL11lVSGjweRQuI4++BsTZRW7m+uVhp9gXOl6yq2xJeHhS9Bsy56w83n9L5fP8XslB0DRyPiw70kHOE96w00Ml2KZHDEra/YJpNgLoOfc2ruzxCNnMIszl7E/KYeDxZqW+jYEUKpiSK5CL2jjA58rHL0ld9PSdgrrUdu7Oe1WWkauw1wG0PZelpnEb/Bxp5WkjQuvjYtwUPPo81/mt7ge7M2zyTOl
 q741KMxU
 5Ch+Q7iyUq2UaOo2QenG9HPwy4CYz5DceHi55YDY9xbi3L507uADbmqkTHKiTwpJHuw1GqLLjFK9SFNaBkhn/nUG9IgM2/+dVS3jkayPZ3WaGzYFogjcOwyb/WM2tjjgSc5qB0dJeLiKSvKMEgSpMfhzWYbc6KMflBL1fHNlbLxrEtm1P0UFHHDyp/F02mQXUTk958O0Esg120iVaTDfaxztcdbFzrBCC3gMkEDo+eYwEPmXcqBAKJLWxjkNeF+IVtHiGpE+RNXnI2eh/MTSbHM/isAhN4QfgmXsaH3uzUUzlGLlYRHQVQG73Q2TZ6i+eYsmwfpF+2sVbUBDTPbOebr2ruZh9t6TGBJrSedA19D/n5YrG69GVfa8iFVsC4DiuJtppBJWHm75f/AUwddKiNC9yY3Kmj9eQEqGYaKNNTH3Ef3eELRJVN9ods3zCeDlYaP7FN9ns3dm3TKfl35g3iB9kpNoSQxu4vvdAtlGRIJa4DJocB1VtP5qkCErXBTr1Ttq9m/a5IeqopIJKq5nPDfxU7VBLd5QmLPUE2aQiGOGAKl6QUfJ+jl3CiGWvZZ3DbxS2y0ArzXjSIKzfcFHqzB7wZbIyJdaZMomACDRUEUIywY4pWSr5yb89Hg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new BPF capability enables finer-grained THP policy decisions by
introducing separate handling for swap faults versus normal page faults.

As highlighted by Barry:

  We’ve observed that swapping in large folios can lead to more
  swap thrashing for some workloads- e.g. kernel build. Consequently,
  some workloads might prefer swapping in smaller folios than those
  allocated by alloc_anon_folio().

While prtcl() could potentially be extended to leverage this new policy,
doing so would require modifications to the uAPI.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>
---
 include/linux/huge_mm.h | 3 ++-
 mm/huge_memory.c        | 2 +-
 mm/memory.c             | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 5c280ab0897d..56b360a08500 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -96,9 +96,10 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
 
 enum tva_type {
 	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
-	TVA_PAGEFAULT,		/* Serving a page fault. */
+	TVA_PAGEFAULT,		/* Serving a non-swap page fault. */
 	TVA_KHUGEPAGED,		/* Khugepaged collapse. */
 	TVA_FORCED_COLLAPSE,	/* Forced collapse (e.g. MADV_COLLAPSE). */
+	TVA_SWAP_PAGEFAULT,	/* serving a swap page fault. */
 };
 
 #define thp_vma_allowable_order(vma, type, order) \
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2ad35e5d225e..e105604868a5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -102,7 +102,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 unsigned long orders)
 {
 	const bool smaps = type == TVA_SMAPS;
-	const bool in_pf = type == TVA_PAGEFAULT;
+	const bool in_pf = (type == TVA_PAGEFAULT || type == TVA_SWAP_PAGEFAULT);
 	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
 	unsigned long supported_orders;
 	vm_flags_t vm_flags = vma->vm_flags;
diff --git a/mm/memory.c b/mm/memory.c
index 8bb458de4fc0..7a242cb07d56 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4558,7 +4558,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
 	 */
-	orders = thp_vma_allowable_orders(vma, TVA_PAGEFAULT,
+	orders = thp_vma_allowable_orders(vma, TVA_SWAP_PAGEFAULT,
 					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 	orders = thp_swap_suitable_orders(swp_offset(entry),
-- 
2.47.3


