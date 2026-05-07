Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01248CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20ED36B00AA; Thu,  7 May 2026 18:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF1E6B00AC; Thu,  7 May 2026 18:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE316B00B2; Thu,  7 May 2026 18:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EEFCF6B00AA
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:22:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9185A1C0536
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:37 +0000 (UTC)
X-FDA: 84742049154.19.41E36FA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 178C040002
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MHOc6abl;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ka3oylQNziq94hqi5anbLpSAA5gWdZ5Hm2jMq8WmIng=;
	b=GdHRUsPEPFPRJ4ihnzblfOFp2mcBi6dPX5jGqC4YvnPVYLpZ5zmQeopnE2RuJcK6V8ACwA
	8MBINqEi20B7TqhomjCnJcmxkg9DLlvqIG0Co3MUV2JisAT2PfbMgIDSzfBnZXqLT+GgZl
	CBmtpOJLblN2rO4mdKcnRK9hWNr/etE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192555; a=rsa-sha256;
	cv=none;
	b=ZKzdf/nOPXTy6RXiaI98ubgt8ncb7PsKmOO0I5cPLc5UzoW+C+uEiVaAoWchpVJI3ZX2jV
	86ZSvA3rN+m39wsWIjkkW0F7TKxc0OGZVGUA2iaEyDjl4BjyrZ7F5QBXcuiZkQAvk+HqS7
	/JYOylp+wSpfPIKqg39ZfzBjBcRVh7Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MHOc6abl;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ka3oylQNziq94hqi5anbLpSAA5gWdZ5Hm2jMq8WmIng=;
	b=MHOc6ablwBdTRvojNn+jvFeGcG2uRDfjoM09ZPVbUdJw0KRMzvbAPoqerXMIVV5VAWJukD
	N/imxmQgo2Gy59B/4LItgcWDob7PmX0QrAkbUsCIv827f4xoo0BLtPEi/GeYjRA7ksHz9a
	mzG1oVp+LiSfx8f0GjqihVuh3MjqYTg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-xcIQVsCLOgeStNBLFKme_w-1; Thu, 07 May 2026 18:22:32 -0400
X-MC-Unique: xcIQVsCLOgeStNBLFKme_w-1
X-Mimecast-MFC-AGG-ID: xcIQVsCLOgeStNBLFKme_w_1778192552
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-488dcaf2f2fso9881325e9.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:22:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192551; x=1778797351;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ka3oylQNziq94hqi5anbLpSAA5gWdZ5Hm2jMq8WmIng=;
        b=PX9K3oTzn8nSz4sLk+VE3c2VTKMFIujvOVTITswU65wkSZ62TOEmsnt7ZjxwcxOklk
         5JZBY2fZhaiYayikYpsqIV5zqgVGE1XrCabp3+YvIEZelJmvOWET19+cOjqZmojaAtBk
         SFBPEt/llocy9eYpGxv2MP2HJBWYh6MKG15+XuDnBRZ0JHvmgNB9NewFlkAYQZh6p2hR
         zPp7ouBzfGQuKXAr6mMwxwEHD0gaKnG+7iYY8TnuCB8x/h3UpLlyKLgMRdCp9bDmfuaP
         wmG5OIucwwvj6hfXBYRge3sUqZeJr2KQHYZOfDvuxcIF6+oa35qNLA3/SilwtBu+aaOt
         GN3w==
X-Forwarded-Encrypted: i=1; AFNElJ/mBmhuAgz7gvKOi4WyMnn1Jz3k2QJ49iodg80f7ljTqHq/JMSei5ffuDEWqieJZ3ADPe9WNUia4A==@kvack.org
X-Gm-Message-State: AOJu0Yxoqc/Q6uIjVxVrFpBW9R412X/5vSZnILacHuC+ywlmW6rkrbtC
	jR9DkI25TUS+0ha3fY6iuLmNoarv8LeUabNEm/x1t4HzhWFCLKCGL4g/2Kmc4eg2DFort64/6Ib
	EFtJTyp+Am1O2UTxhBD1YDgNL8yLaJvbmb5kr0KphJiUqEK+iWfYF
X-Gm-Gg: AeBDies/9vw0L3fSWoQhg4Qu1hBGNz0mXWngwLPATBGtIuFI2E/rSevWb+U7SgwwKYL
	p5rWhyFhU4EdrswbjfOAsUu7SveqQsaKfSQOXO6ij1xLNBV34GtFo2zaBdDSzDdJI9z1qv1n423
	ejMSgoJW46UTx3xkupvjlVbD6k4ctTdpsFiweHxhV8o471KZJ4aBrwV9q2HQCQz9vx/hm9g0AnF
	NfX9lqGU+/V3gtXtgfInE7zsqysoojdGCgjLxCZxNw/MaLps24h6txnN7BfU6aJOfZA8G7awMkt
	5jWp2tvh8rbgIghYOsKmdbb8QKPkkCt3Bd87Gyb5x+hJs8srJEWUafyqdaSGCQHmbl9bdC63BAb
	gbt8W43FjpIki7r7M86HPE/i8XSxlEdjP/2nRXGOR
X-Received: by 2002:a05:600c:4e43:b0:485:30d4:6b9e with SMTP id 5b1f17b1804b1-48e51f4c1e5mr172323035e9.21.1778192551356;
        Thu, 07 May 2026 15:22:31 -0700 (PDT)
X-Received: by 2002:a05:600c:4e43:b0:485:30d4:6b9e with SMTP id 5b1f17b1804b1-48e51f4c1e5mr172322665e9.21.1778192550845;
        Thu, 07 May 2026 15:22:30 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e65607127sm10239565e9.1.2026.05.07.15.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:22:30 -0700 (PDT)
Date: Thu, 7 May 2026 18:22:28 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Subject: [PATCH v5 01/28] mm: mempolicy: fix interleave index for unaligned
 VMA start
Message-ID: <401fa82d946cd96ed200be5be4f911371e3f6f3c.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EFvoOfsu9sdGbA4RXviTDuKuypdUXotlbGUytPqfkYk_1778192552
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 178C040002
X-Stat-Signature: nufaxwjkzeki8cpsr4wesr11jsy5j3j7
X-Rspam-User: 
X-HE-Tag: 1778192554-230498
X-HE-Meta: U2FsdGVkX1/MXM6IgQZX2FSp3pfYNzkUePeLQrs6wf1mzvAcD420e7ns+dM/q7zHwdhKQOESY+XEHcZd5vKL9mcxImatWiCKRgv+Pr2Snd0jyKGPpimRI1E6Pnp3JoOf+zYAkDDrF9DC4VOOZD4DfWPemYR4iglvPBna4D78dHzDcZgoT4mFKBihtFb6FOIudF5WhZDRyr4BK9VsqXnit2Lt61Zr3w/w7f1S+IuQKdfn4Gb+I4yG1qlPZ68w+9NUvGoda5wfInkWDyFI9hazglaK2w3iBYdIqBV5HgOLVZvebYStXRoOjBjSyC1CfNPwED9YnDKKHOD+5wDa3F8soJvDRVfJD/O8Dchmkwct4SXJ9qBBKrEZwFOXJyqnbz9TaHeKXEaD8zw/22GFY7hw5CNF7dTUAbvoMd0EuXw6bPiY6ZZ001Uoxrv2ATy1yNb5ysM89Rz6tfHav8D5sDKbQ2NgAzHzZPJtfs0mBPxfoVi4Bz80OD6CGwPZAMwpqXjzbEnz/UH7Tod0W4rpfqjM7P+ZghCIY2v6aJGw5t5tN7jmqPCkXcEBgt3y6pvdwcsi29DNi6lb+J4gRhZBFtBFq30UkqiPcJ49dWaw1QGoC2DSw/SElU17x2o7bPsrfXZXM0HtxFhafVsT0YqHcSJeAZpbNxpxjeeTDe79PDiSuWmob9d1kUdWymifNwb50ArieP0LRj8FgABr4oKhvUmri73QBfArheLUJQS4503+DoI5W7+BY520yEodF+pGrGU7cVyxfqDwX4dtRJ+S/VLbEon3rtMNnmDiCA10/7sR6mUAfdigQ/mp17gUta12FkEl/sED/XoBg2JlqRZIjumybj40EbHRMpEDrv26T86qNJ6s/KTvCuTQAJ4Jb0YtTbjcsnnVKc+aftxXUxxVkqJKBSvvqrj8Q2TESqjw/u3aw48EbvTy+mGwS2vMovY86dPhGA03LdomlctaYwcWV5A
 jmVt/W+j
 ZsigeDVxi5fvl9v9QJ7OPoXjq8lekcwvmMS2rwUgfOm4TDWWYkkG2+782b/c+FycZkmConQzj15QjqHuqrJTq8bN7vOaeRfFjQfZujar/HxueNme+Zq/IsLy9Yre9QBL9K7JhO8Wbc50TOXBvTN9NzJ0Da3zjzAoEpAKykoktArKVCrLtuEM1q+CXsk43BJoz7abOvYuW9JV1m6soUd8xk2qZpsFm2A58JVdPoxwXWTc7toSfrPWK1kK/KS0cl9DfKo4t6iuoZRx0op4qAX1HhDdxfTWz7N6cLSW3Q14qCb0HZA7NVnLs/F4ml2HdkeTw7yQzBdncTUz1Ph5I1BT0icm6g7glpKdYpiK9sTcnRJsgSSITJXBEEX/Nwcxjj1hLHNu8im9Lxfy0gAc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The NUMA interleave index formula (addr - vm_start) >> shift
gives wrong results when vm_start is not aligned to the folio
size: the subtraction before the shift allows low bits to
affect the result via borrows.

Use (addr >> shift) - (vm_start >> shift) instead, which
independently aligns both values before computing the
difference.

No functional change for current callers: the fix only affects
NUMA interleave and weighted-interleave policies. The only current
large-order caller is drm_pagemap which does not use NUMA
interleave. All other callers use order 0 where the old and new
formulas are equivalent. However subsequent patches in this series
add large-order callers that pass unaligned fault addresses,
making this fix necessary.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 mm/mempolicy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index f0f85c89da82..583b64f2b4d3 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2043,7 +2043,8 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
 	if (pol->mode == MPOL_INTERLEAVE ||
 	    pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
 		*ilx += vma->vm_pgoff >> order;
-		*ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
+		*ilx += (addr >> (PAGE_SHIFT + order)) -
+			(vma->vm_start >> (PAGE_SHIFT + order));
 	}
 	return pol;
 }
-- 
MST


