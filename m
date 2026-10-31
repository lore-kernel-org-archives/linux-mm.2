Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25932606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 07:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DHohPplR
Received: by kanga.kvack.org (Postfix)
	id 319156B05B4; Sat, 31 Oct 2026 03:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0186B05B5; Sat, 31 Oct 2026 03:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF376B05B6; Sat, 31 Oct 2026 03:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBDDB6B05B4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 03:29:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC94B1408CC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 07:29:04 +0000 (UTC)
X-FDA: 85382095008.10.0418709
Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1A0CFC0003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 07:29:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DHohPplR;
	spf=pass (imf22.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793431743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1GfHJENjm3HCl2SLDMEeoyrSRdru9fmVN3yznIPIXt8=;
	b=tPlZdFtHPvLefUh4LGuV7/kmwjTcdOGK9QZUo1TZvVUwb3JhP2OsmESHl24M1hMFWlZ/KG
	58SDPtHsnBLCmF6gw/pViVjJxC6rcxtfgTLmqFcu6x4RkFC1jUOjtumCwdyRnpb1jsKqri
	moB35GqG8rsrLF/OkAqjR//fu0KVZ18=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793431743;
	b=EgoX7BBT2gQmJi7B6PPjfCvSHjxSjPwzCvWZwaB87UzB8WCBhJ1HTY6IHvXrZ6WRpypvHl
	yBqleyCtnx3UwEi4YLZt92BI5XP8xc66QB55HI8RCb4JPqry3Oy8+JS0ENicOHxfQYxKfp
	wyDCPgR5+/KoQeg5GFqEETU9sSFC7VI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DHohPplR;
	spf=pass (imf22.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f7.google.com with SMTP id 98e67ed59e1d1-3ac63aee1ecso346520a91.0
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793431742; x=1794036542; darn=kvack.org;
        h=mime-version:content-transfer-encoding:content-type:subject
         :message-id:date:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1GfHJENjm3HCl2SLDMEeoyrSRdru9fmVN3yznIPIXt8=;
        b=DHohPplRPEAzeqUTj6HSUPS2uYoO7CjfYK4EQBEkMe57XLw4QsvcqIHjNEbum3hXcW
         5RMl7nlzJzw4CDe0iKVzkSkVd1N17I+lnnbU1cvQo5Gdop2b2Zx6THCSY6rm3CN+CJ/E
         s7rQKVM44wn6zC5qR+3QwyqzfiWN5c1yDCnF9UTzQboTdi8cTyzxgLxSjWLANb6hcQiY
         zfiRq27csBot0qrV95RT1+VNhmLPICE4MXhaCENIcEarWwyB2j/c58kIkr+vLS+XDNEb
         q11lymAzaY6I7fB4tK9+Nj49zhK9bRnFCZajqA/gF8cn+Bmz710R2e82dPF6oEauB2uV
         yrUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793431742; x=1794036542;
        h=mime-version:content-transfer-encoding:content-type:subject
         :message-id:date:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1GfHJENjm3HCl2SLDMEeoyrSRdru9fmVN3yznIPIXt8=;
        b=V9ZI6AP2cEf2rPSh5vyI1JeuIytKGBRNDDRv7gPxmYJ79IF0OqitVp9wyUK0qvS9vr
         MQvhsOfNsZIzi/XtptO0KYAmmwsVjzAfypGdRrylskukP+VcUflBKnhHfNWmLhRvBj1f
         YUD+UcGXQPIf5GX0nGNDcccJvUeVkE/8QmupJTJmQIbIa7ItjBgmL3/tQV7AbzHMm7XS
         +kobxqUsnvwyDrXNPHxvHQIK2WtEJBa3y2bDfOr9SAHMbrniiLSTMVcVLs/f1x230mrD
         JlN7mompmi016vCcWR0mGg0EbwdnIpm6n+gzguziFAlTc+UtMhE3CdykJUXHVZSrsFfP
         LUng==
X-Forwarded-Encrypted: i=1; AKwUvBxygSnB4l6EFq3oZ85eaYH/Ys1fRHkb1+tRpF9Oo49+x8L4wqbJ5awVipcCnoq0sBCT8YRX+MRqPw==@kvack.org
X-Gm-Message-State: AFq9FYIXJQPOCpi7p4EiKEFlf1bNMig757wvbC4f8F0rBGMbDaPuOHnY
	c8FUPIRqzMNOAqbl7lEUrPgyvGyv9V8dh1VTf5hQXxQj5Wk7z+FA3sBg
X-Gm-Gg: AYBFou29/Y71kLantc3bGlf5WHKiKYgfV+1xGk6LP3f/RKf16Hl33ImMYQnhOf+OZ1H
	l+4Idrw1ps65GN0QbHexOLoqQJaA6kdqjTBEcyIexqEHbEc1iEYki1cgg4rUoPkKqdhPDCOgZRF
	xBzABR3blLztziWXTRT9hthn6RdYU8MWC8hYy046yHZ4QrucHJi8Rqj5lpuXn0vYXRBkTkbANiP
	KnYV3axezinANGgufWhqxQhpCxdNnyvDvTyG2Tu8qCm3l+W7gXiVPz+BtOVS8/xFwuAv9p3c1yi
	45yMZrwP3x2EhQoNP0ENzNZEAcp7PHD3nTT10tZKLcziaPOG21CUT6c0OvvqSFce0o6jzWdcfx6
	iovAfxCg/wfqRbmySYa0tsJL5NVzvwmKpvUUvYrc9njsw0HDtkV4uVOBHS0xvc0FUmteosP/waX
	Dz7XehgXzbF3xIW/9oSntBiUg7zqSB35K35Dra10RtHQiHUGSlsDDuYy+1HMVFE7H5ehhkFbgD4
	UTtCL/pViiC402J36m9+KZrKdXshLGNTRwB76NPNNKDmJZNmuW/uOMSpOpyEUQXCr4rzkECZKk/
	Hfjy3bV2gDTm5DgG/KDqWXjIi5QiKsYdxqJ6QWBdtBD29cYjsG1psiB04pf/rGdvDXGQwOb1uHH
	6X0ed5Y7Y9UCWXXlB53iQSpxWrs3uRCcA
X-Received: by 2002:a17:90b:4f87:b0:3ac:af8d:c839 with SMTP id 98e67ed59e1d1-3ae897f6e6dmr3575891a91.35.1793431741819;
        Sat, 31 Oct 2026 00:29:01 -0700 (PDT)
Received: from [10.208.43.86] (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e98afe3sm11008530a91.12.2026.10.31.00.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 00:29:01 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>
Cc: Francois Dugast <francois.dugast@intel.com>,
 Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Sat, 31 Oct 2026 18:10:22 +1100
Message-ID: <179343062238.2.2773026701442863377@gmail.com>
Subject: [PATCH] mm/hmm: honor write requests for owned device-private pages
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1A0CFC0003
X-Stat-Signature: ioqr3zhxfhwqmhubtgz8tcqu617bhunb
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793431742-981940
X-HE-Meta: U2FsdGVkX1/Z8Z+WibkxwVkSpSNZt+A1WAgSW/hxfUyJXIpe/jmxPqHHx8v2+AyQxH2yxLwprsOr86mV5a8z7TO4/aIvREAIh3F9IoeAmnBBQ9W2vgIRIl4DcBYdKY2i+p3jbngzL2ZtMesPkcHoJ2ZPQBMrhllpRKD+dOQE1a2aiIb/EAZSCAcNZOTnR3vatJVF2HNjTa+fH+2kjngztW4EhkvtPYsU/rTjbt1cHkZd0URKNadN9Y5zwBxgy5d7WQpB1IPYOkbPfatPulLcGssbnLeB0sS4C+aMslCZNJotyyf/P74VW7sSVaDWxxs5GkeHl+NDEp/PJ6DyN6SPrFtSSeYK47PPRYpSDWvw8sR2QIbURTWZtA5H6ucs2XXNWk4luKWGoPuB+D0XSmH3IFS/B7KHCruNIUAoEKsYEA25CLPtlOViRR/GtHFpKaXC9mkDr2gEubG/nJtCb2o1tL5/tNnB8xS8nvHBRgCb2CDn7fwUS1VcMe1J4ivCxm1fnn3YJWyo/xLOz0AwzIFMu2YRl1+zvbDPFeg9moucfZjdjH710Agjxapp9gXQl7NhXzyV5OKImFfhh1zsYnKMgWKErPlQPZwESc6a9UnUF+q5UdtxU736mM4p3ERAfdSKfoAiWRAM5KWUuyg0d8DknR4ukMFgkv2UnkVWr6QEs2dA7+ptUU6Dw3xJKtjl5jW4/bcNtiDD9h7Bt+JPSkUxauOzjd9MtocI/bJq7IIx5erNZXIX6HWxPBztyG7iOP3GxeyDOCc7ZS0Q5wAz+Zd+hPsQAU5yrasGSOgBRuFa6UZw3oRZFoSzyKQqCOSW4trwEtbTEh18ArGhUqbphY1n58vjHBH9lrW++3bw/Pt4xekr7/2DPwLvuwJdDY/bwHiZodaWm++H8Ffm3JHUynTR0tgkwdLMt/f3pa9r38BuBTonjPD0l4qTWn0fHClSr8AmEz6HBESttdx9vsjT5ds
 Gz92qoAI
 vgTYlw9xw5/l5TsRyNv6Zwip2pBwQ9imzfU2YUrkue4OD00gAY4ytxsLzsXswEQ0PHNTbsybBXRDtsiKz7X+kiQbI3edcH7DSnuRVKQbFnxW0o/EEsNvH1aHYZcp2RCktWcFixa7+FWTP0j9s8ESkYJK3fRdFIDECYbK+b8ztcNzI482Xi4+l8v3RddOk7Tgm/cyYbLHPo8Y29hbQjwygp26e1gYTE1C3WxNe0b3+0Az+oI0fXV213u0QQNyf0DetaVnCxSYD7HLGlQbGgnJL3YL51yN/uO5OKfjCy05LfivEgL020aZUChQTDKqTB46vrawDEf+KI5f1piIhvFLJPotHYMvFPqRhU7x8LKCUMlx6X3yUx9FQOguTyOdQ7+Kn+AvZYmZMHuQx52U2D99zGAqjao3tftt4TZ3CvIFPpPU4LpXPo1RE4UEpmPnx36T38ISp/J0jHbWjTo8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The owner-matching device-private PTE and PMD paths return read-only
pages even when HMM_PFN_REQ_WRITE is requested. For example, after fork,
a write request can succeed without resolving COW or returning
HMM_PFN_WRITE. The test_hmm consumer then returns -EFAULT.

Check read-only entries for write faults before returning their PFNs.
Keep the fast path for writable entries and skip the PMD request scan
when no write request is possible.

Fixes: 10b9feee2d0d ("mm/hmm: populate PFNs from PMD swap entry")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
Found during code review and synthetic HMM testing.

Tested PTE and PMD write requests, COW and read-only VMAs with QEMU
test_hmm on x86-64. A separate test probe covered request flags. All
executed tests passed. Testing on a real GPU would be appreciated.
---
 mm/hmm.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 2f1e98c6b644..92957541ba95 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -268,15 +268,22 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		const softleaf_t entry = softleaf_from_pte(pte);
 
 		/*
-		 * Don't fault in device private pages owned by the caller,
-		 * just report the PFN.
+		 * Don't fault in device private pages owned by the caller unless
+		 * a write fault is required.
 		 */
 		if (softleaf_is_device_private(entry) &&
 		    page_pgmap(softleaf_to_page(entry))->owner ==
 		    range->dev_private_owner) {
 			cpu_flags = HMM_PFN_VALID;
-			if (softleaf_is_device_private_write(entry))
+			if (softleaf_is_device_private_write(entry)) {
 				cpu_flags |= HMM_PFN_WRITE;
+			} else {
+				required_fault =
+					hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags,
+							   cpu_flags);
+				if (required_fault)
+					goto fault;
+			}
 			new_pfn_flags = softleaf_to_pfn(entry) | cpu_flags;
 			goto out;
 		}
@@ -358,8 +365,15 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 		unsigned long pfn = softleaf_to_pfn(entry);
 		unsigned long i;
 
-		if (softleaf_is_device_private_write(entry))
+		if (softleaf_is_device_private_write(entry)) {
 			cpu_flags |= HMM_PFN_WRITE;
+		} else if ((range->default_flags | range->pfn_flags_mask) &
+			   HMM_PFN_REQ_WRITE) {
+			required_fault = hmm_range_need_fault(hmm_vma_walk,
+							      hmm_pfns, npages, cpu_flags);
+			if (required_fault)
+				return hmm_record_fault(addr, end, required_fault, walk);
+		}
 
 		/*
 		 * Fully populate the PFN list though subsequent PFNs could be

base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
-- 
2.56.0


