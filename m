Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12999C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 03:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23FE76B0092; Wed,  9 Sep 2026 23:43:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216CC6B0093; Wed,  9 Sep 2026 23:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12CF66B0095; Wed,  9 Sep 2026 23:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA5396B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:43:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D9E4803AD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:43:42 +0000 (UTC)
X-FDA: 85196458284.20.8F37662
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6732140007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:43:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b=J3WnzGiY;
	spf=pass (imf11.hostedemail.com: domain of weir@nebusec.ai designates 209.85.216.42 as permitted sender) smtp.mailfrom=weir@nebusec.ai;
	dmarc=pass (policy=quarantine) header.from=nebusec.ai
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789011820;
	b=FGoYaeyO61si0KtUyZFuNztit2C5BQL3TrNlyiHoKgSkHrc2AY+kYqLdVILSA9DyWF6CSP
	GRGfOPYn/oflEgESCfnZN7kP6bnIBV2QYND21DWG/8dPHW6Ays0iG3pYGbJHXxpKb5FGe1
	x709hFfiQKx2FWBTtQz5bgJWeoIwUx4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b=J3WnzGiY;
	spf=pass (imf11.hostedemail.com: domain of weir@nebusec.ai designates 209.85.216.42 as permitted sender) smtp.mailfrom=weir@nebusec.ai;
	dmarc=pass (policy=quarantine) header.from=nebusec.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789011820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydxvuCpF8MX31xaXDcVB+798sPkM4DfyIgw4BQpeeWU=;
	b=xx8M4PhBZatRVLjmjGY0RyZFZTPIB15h5CkTWsYFe3gcADKtXh1Hbynftq15rrydLAyPRv
	cWRmJd3Td1mfp9gY8sqW1YyJ9wvuj1U4/HHn3L80wJuhDkEXlsuCvRhHxVy69mhcqqwdl0
	+8JIn1tcJti/BpcbGY+MIDICMPX8oUw=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-381b831d535so10410296a91.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 20:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789011819; x=1789616619; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ydxvuCpF8MX31xaXDcVB+798sPkM4DfyIgw4BQpeeWU=;
        b=J3WnzGiYC4P368LyC4YXSS+CjrXyZCFSuAtNd8q3bDnrEMIY2KhQZuee1hDx3ucBUL
         fto0keGokGw9ZgYvHWHwHl/F2BXTz236bjJ9xrcet/YvoFR6nXLt8WgWWbNeXfb9y/9+
         uuq29HwUep8fL6QmEakZEvBnAg6fKvBj1U6vF5hThjS8oCFgtAOHqQC3gJftFz9DweS+
         /dqE/g+mxZSw6wSOD07hWgQda274gM5xPM19nuiphFuipFFxTwTZpmYkpLYZ2HQZCy+r
         dgQzx3BcL0oO++iUh42vGqyByRtpVfsIRdQ11wmFkk4eNFuCVooMlNSxG68rJIm/mwD5
         wxuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789011819; x=1789616619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ydxvuCpF8MX31xaXDcVB+798sPkM4DfyIgw4BQpeeWU=;
        b=nJ51hDGUIoZUo/JI7AZ1SmOzeV3LyQqhKMPiXnPbRpUHBizhBDRie3ff+OgnmYUlcg
         WQoAZ5LMw3MG8IsAUK7TRwSQEsKtvYaTkef7xeEaoPoyoD00Q9OBbnjgO6snvyI45RHD
         T/egWPe7xoTlPX2zMcCCmMKmlUeiF5W64sDjXphJYqFb5pdtKlik5iRU/duV/8nmR912
         mTbaHPtbN6ancUpxpVkbZKbY+97pVIADWPvPLow+5K4SIU+cFuJfRoRu+X8Ze9m9pF3+
         V14eZPNVgq/PS0IUmilWBo4hXfnfXSPv2A03OOcaa3Hyq439AUStH9qJwPhdMwn7HSbO
         U3ag==
X-Gm-Message-State: AFuF++kEjt1uYuqFFBOZHp9rg4UgM//2WTSe5MeBeHfaVS8Aj7uk8u4A
	w0hsNUQsVIEBnMUVEPB4rKJJt0nQ6JvsLnsG2e93DcXDSJZrH2iRgo8g8B9Qu7ZyQQsbtV/Os7G
	XF3PbtFZwX8g=
X-Gm-Gg: AYBFou1iYq0Bj8CBKYnPWBWypMOAbYo9ZlmC1POGvMQtg1iq/qMPH5Bnl/ALzilFoe6
	1f+tCa7a+xgfmg5b2xU27LykmkgxWcGPgM4ozfgVaLWJEBhnjHRXP6E1phZLebVMSERetbv7kmR
	jm89VG6xbLBxSylio20GbIA2DfESRdJkNxaTF53SI+/p9NJfGp6ROMrIMjU4Mads8HoRGjxt/wT
	kYsC/o2J/3Hj8IpQYPNZshbEGkqZbE08qANeTYy1qOgfML6GxzmInLeh7yM8cSivgqNsPeHNnqW
	bM2aQEn9A/5UTmg2aN0AB2xSYREQfF+wOFQDrTHKSC4Hf+eR411XAJkdCIWMOA3vJXY5YfyzSQ4
	goFu4nDLf+H9g5o3E2m5Dfou468RJc1tZCzkp/TQGA85UM47PmMa5rpaNZNHL1Sy7zpdOgMsfo0
	QSJl/N4hB2DohtulCsWRKypKy/Ovp/jfehRJfKZrGtq0sK+yH5XvtGiTpLvFcnWfYOWyv8Z24Sk
	ciD5aHY3g==
X-Received: by 2002:a17:90b:5148:b0:39b:ac66:bbc with SMTP id 98e67ed59e1d1-39bac660f43mr13398793a91.7.1789011819097;
        Wed, 09 Sep 2026 20:43:39 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([167.71.204.91])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d770bc2e1sm2916192a91.1.2026.09.09.20.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 20:43:38 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	notasas@gmail.com,
	vega@nebusec.ai,
	rakukuip@gmail.com,
	weir@nebusec.ai
Subject: [PATCH v3 1/1] mm/memory: constrain generic_access_phys() to page boundary
Date: Thu, 10 Sep 2026 11:42:50 +0800
Message-ID: <e06e28a46c2a176238f03b5740df0913e57c2861.1788842306.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788842306.git.rakukuip@gmail.com>
References: <cover.1788842306.git.rakukuip@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6732140007
X-Stat-Signature: y9qwhsub5j9jhfqma3j83rhs7t4o6gzy
X-Rspam-User: 
X-HE-Tag: 1789011820-602219
X-HE-Meta: U2FsdGVkX1/Zz2toIKcbklsZPzp9LNy+wFkO+pqmQQT4Y6XwthsnPZ90cM64o361cBCF+Kxrmbdt0Sl2mwfhvQrfGVvHANrQVtiRKfEQlj5nTRSCYW0Q7I/7Wmg2BXJCd3ERrqJ77EB/B2gsMFzYnXBkkgFsoz3lSoSzsMmBJJIyaO26vkjdh7C0cxDKUIRyROn9UHbQM2OQiLogBGIWjN6a8eR7e6iDypI9Z+7d1HXzRojfDi2vOnkai5qmBWQ7kC8mCTq5o2I8YkY9aaHMs45oRG+zxkZMg1TcUoMgmlwMD/iL0/CoK9EwiYvwZYPQBBtrJ9MPzd8//4ifKgqRex+Y5buYX0ZiqqE1jouOo+mU1HLtGdysMxKo9tOYtaPr8bZao59zCp1Po9ae9wwfa/zgoribQgJETyYYlC7rzHMDfFPLZDLYaS93hnwI3jofofPXTo/aMtoTsrFFgOQEfSr6tOekoFyOxWuCsLPgcdYcLRLrbX6HoL5Cx9yMgo+014z+5hSUT+DHaBSQ6xqZ9RPTtAGMlfY0i4Yj2iJgcclJIs2sPa9O20dbepqkNVr8wSIL7wm9Hbju97PllTMNbaCY2rZToWKPyZhuuTAYSar7KfFenK4RHO3UKGJtIXdMoq7gMsYEoehN77ViiMLntQ2ibw2HP1AM77XhVQUKmlkyR2H8po6fPb1P8aAiMedv0cT1lVPuAg/1A9CfY5doQBjK1o+Xv3nY0Y3kn+djsMqxr+b/rYyCEvj8ueFHPyXGfnXiF16uDcWsQgFqu4K41u0FdsTT93GRfXmhmC2ObWOU8k08IATLOj/zm0jK7rHfkKjlgl8gC7fuzECNp2atZnAfLQyIciV3766qcxnfDYSO78C/XhL7Fmrz+vJqlAmR5aVlbNoi3b2L2jk6ryb/Q2jzkYoftmu3hTG8oj2RDgV8MXoKmCiSznEYWlxan7fImR23nUPwkBoYT10c8EF
 GGCsBaf7
 jdusfC7LWEiRpx7XCosSO+tjKv0g7O5pRQu0mFVATuw0SNkGE+Q7h7ttZzBHc2jExdK2BV0bh/k5ksnuojV919xvX/TX4XDYo0t2Yi9XhBpfLYsf+u6Dy7zYSlO/fFe5gLLBnIOSnr5YnsNFszVBsbgVdGAvSLvBLkio6MNXU4AZZs95PNgtD+9zZyCqGYTIZkPERmkkHQAAGNtBzlxiiAChSkymKAKY/Vlksfmkkd7m6K8qBZTdxbQSyz7P9GuJ7IbzIvpg452mDeIM0MDTJXa8Z2zhKxI02n3RAXt4htjcP1C59u5sOSK0tXXkVVQtuG9xbmAvZduCgIx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luxiao Xu <rakukuip@gmail.com>

generic_access_phys() improperly validates the memory access range: it
only validates the start address using follow_pfnmap_start() and passes
PAGE_ALIGN(len + offset) to ioremap_prot().

This poses two problems:
1. In PFNMAP VMAs, consecutive virtual pages are not guaranteed to be
   physically contiguous, and individual PTEs may have different access
   permissions or writability.
2. The mapping may cross VMA boundaries if len extends beyond vma->vm_end.

Constrain the access in generic_access_phys() to at most the current page
boundary (PAGE_SIZE - offset) and map only a single PAGE_SIZE via
ioremap_prot(). Since the caller __access_remote_vm() already loops over
the requested length and handles partial transfers, it will naturally
iterate over the remaining pages.

Also add a missing (resource_size_t) cast during PFN re-validation to avoid
truncation on 32-bit PAE systems.

Fixes: 9cb12d7b4cca ("mm/memory.c: actually remap enough memory")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
---
v2 -> v3:
- Do not modify __access_remote_vm(); capping in generic_access_phys() is
  sufficient because the caller loop already handles partial transfers
  (David Hildenbrand).
- Drop unnecessary 'len <= 0' check.
- Add comment explaining the single-page limitation (David Hildenbrand).
- v2 Link: https://lore.kernel.org/all/cover.1788531737.git.rakukuip@gmail.com/

v1 -> v2:
- Drop internal multi-page loop in generic_access_phys(); clamp the chunk
  size leveraging the existing caller loop (David Hildenbrand).
- Map only PAGE_SIZE in generic_access_phys().
- Add missing (resource_size_t) cast when checking args.pfn (Andrew Morton).
---
 mm/memory.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..74fdf29c9c7e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6974,6 +6974,12 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	bool writable;
 	struct follow_pfnmap_args args = { .vma = vma, .address = addr };
 
+	/*
+	 * Limit access to one page at a time, as that's what follow_pfnmap_start()
+	 * guarantees; expect the caller to retry to read larger ranges.
+	 */
+	len = min_t(int, len, PAGE_SIZE - offset);
+
 retry:
 	if (follow_pfnmap_start(&args))
 		return -EINVAL;
@@ -6985,7 +6991,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	if ((write & FOLL_WRITE) && !writable)
 		return -EINVAL;
 
-	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
+	maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);
 	if (!maddr)
 		return -ENOMEM;
 
@@ -6993,7 +6999,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 		goto out_unmap;
 
 	if ((pgprot_val(prot) != pgprot_val(args.pgprot)) ||
-	    (phys_addr != (args.pfn << PAGE_SHIFT)) ||
+	    (phys_addr != ((resource_size_t)args.pfn << PAGE_SHIFT)) ||
 	    (writable != args.writable)) {
 		follow_pfnmap_end(&args);
 		iounmap(maddr);
-- 
2.43.0

