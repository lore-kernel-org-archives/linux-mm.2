Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82A34EDEBEA
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 19:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAB356B0099; Tue,  3 Mar 2026 14:48:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56D26B00A1; Tue,  3 Mar 2026 14:48:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964716B0099; Tue,  3 Mar 2026 14:48:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 804E06B0099
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:48:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D90413A6FB
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:48:54 +0000 (UTC)
X-FDA: 84505789788.15.1A4AEDE
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5F1E0C0006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:48:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G9FEWAMp;
	spf=pass (imf28.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772567332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dOCB92VFaJvp1/msg1aXr5lsyHqZuKZRc8ptpqCWqZQ=;
	b=kJkyeLlr8ZC4RCeXsNSeVHP6iAEm5N/DpRsk6RE2HFsywkVdKAHxSd2gVHUTQcrmEoHAVi
	YPUtzj1vuLry9ETPgNBDL/W3j5K2q/dcqBaEIWNipvCaUvy7vH5Bdxurl8zKcaCV3PTb0T
	n/1yPlspCo9h/wYvCvJ9S2Dt+QBMGjk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G9FEWAMp;
	spf=pass (imf28.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772567332; a=rsa-sha256;
	cv=none;
	b=aI56gPUUS1X/LH3nnTEvKQm/3iR7iKouF7NILTq1jup5oi+2VUdQTnBMl4vn2ar6Tk7hVX
	VRKgz0z417IjHsYFGEOpZC5kAQhk4O3jhYeReeGlau1X0u4oqupqgCqrofDQsZ6ikjhhhv
	3TCEMoCNZVvFC/XCBv8zydq4pzCdcRM=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1277d379936so7271159c88.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772567331; x=1773172131; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dOCB92VFaJvp1/msg1aXr5lsyHqZuKZRc8ptpqCWqZQ=;
        b=G9FEWAMpg1NvL5t25+iUUB14CEHirKclcU7MfmigyitYNcKM+1Goh2GJUFYumnQU20
         WFCWetSFSqlHDDuNg4x1DTtqJPDq/T8txSbsZx/PC45wzDYfgsSmMP+mGs3E+NTnqb8S
         1q89sgpONotMhZDrG/NTS9fUrjb0c/oj7pTPZ7S0fg4Hz8DqjS4TENms2br8XGTkOOut
         s++tEnKGz/8NxDwqMJ5ZP4ryxZlswTBAOGqFKSRJobU6UJeSSWg0kzs5Wqx2eClCSSAw
         frQNBeIFgx+6EivO9+0+oiC1ngumvdeWkt9YhaS+buBbVthhO8GOts1iyDh++ouc4L4K
         c1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772567331; x=1773172131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dOCB92VFaJvp1/msg1aXr5lsyHqZuKZRc8ptpqCWqZQ=;
        b=CHfTCnBA79/JDtdpObemmTLUaxp+etbLdsqhCKXoGP1y4TlvAxmZl4i6gIMjkdOqbX
         FhCqLCkp0YiwyUWsTwmgdn7h9FA39rwfKWFxlCLkSaiZH8i7wc89GznIg1yp6Huo6UBO
         2wjH3xILDwxXZzcf65kIIHsPSMPTjr9KS4YuHzuHMhS53FqWX2bd9ATlUITOqbaLk7Wu
         n3iwrgFXCNTQiG3GJ8oEUcsTixJsxwYsgQLTAYnPPt0/oI2zywEx19M08KEEkyDFzuro
         29s/P0AM45DCw6VAwSSJyDNw0IrI33EtJkRMd8sTpQndLAbkSrD0BaylZ6IS1p3Fs2n4
         +FEA==
X-Forwarded-Encrypted: i=1; AJvYcCX/KPpP3D009fFzbDbnbTmGgBLzQVpWg5m01DOtkXJ4L40eZ/YleP46JAtlfiv4MBhXOi3LvXzpVg==@kvack.org
X-Gm-Message-State: AOJu0YxoQ7AZGuhfKBew4qWuAwQMYpXD8HIsnADjmLu24x9JwPBIuYiw
	LGq29pKlAI4pUOYZMnoX3PHj+4gXDDOTi7b1+pGkZFfagqlm9eNxDeXX
X-Gm-Gg: ATEYQzyuJTT9qReJ2yZ+E85G0ETYe/Nk9pOBXWVCs2F/zzRxUbHFrvnUXHAWGsNFe3J
	7cXr8lbBjzzC/S35541pPPAOb8ccQRv4LJD5EQA5H68NLN3n6HdPmW3i5LsRkHnvmKgeeX/yAPx
	H3TTnNvSlywc0A+WEL6oaof1+br/i7A4XkhS9fwPtWve6GevT6jwq1I6TcToTWiQxQal+FCZnJN
	HrMdiGz/j3/PR/tbLDUG6egkasrFQ7QrWgmhRxBEQ3vw/UD95nVbIlkY/zApvhvWqfYlDTBTknd
	jMDfAIs3ZlnKoSo+aKPbcCi1MeG42x8+rO1gmbXd8ezJqgas+gbLuGm1imlS3XmZgHwnAq6g9eX
	VVL2z1sXORMMBwzWrEBPNq3bufbqK1WojF+PHMqAsMka6+LHvuCEBCbYkfu3mENz1/HOOtLE8Z+
	qUqEz7uqdJvSFuKq/Afpnrj4go+2+M/k+RBVldMAM+4IjyqusPr42BIAcMWlt2WxQoDnTXlLuPK
	l8zIjwWEclPZ7s=
X-Received: by 2002:a05:7022:48d:b0:119:e569:f61b with SMTP id a92af1059eb24-1278fb93eb2mr6842247c88.20.1772567331045;
        Tue, 03 Mar 2026 11:48:51 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-1279e9950cesm9258748c88.7.2026.03.03.11.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:48:50 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	Dave Hansen <dave.hansen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RESEND PATCH v7 4/4] x86/mm/pat: Convert split_large_page() to use ptdescs
Date: Tue,  3 Mar 2026 11:48:27 -0800
Message-ID: <20260303194828.1406905-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260303194828.1406905-1-vishal.moola@gmail.com>
References: <20260303194828.1406905-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 944nqe31wnsdgtwo5w5phw3aia7w31a3
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F1E0C0006
X-HE-Tag: 1772567332-364390
X-HE-Meta: U2FsdGVkX1/pCRwlTZwOR6U7yXRKQEpaw8eeMI2TTHgYw9gpnIOvMQ2FOYQN34rf+ZvoA4R61blBaQoFJ1YJ/DDrMJviDc6Xd98mhIBtvbtQ7+IBrU8Vjpe8WfeiVyF0FXtVwi4APDc+9pJBbjeY4Ch2uMO2K1wK6T41eUHsntgx4pRA4Z1/HRY6U4HOQkS704IDF/1qkiFmJoEVHcLGMCuLHPul5HU0L+sRNjn8lxF6oGey34EHLzCHrdhTLFXv4YAEsiQTjysBRFxNra7JJQ9/GdECWiqIA1PN/ZdrSXbzqRHzwVgnY/Gg0XuF5lwzmWVlSR4ZkBVpugcLSb5tz2uewuLctD+qWIdZgS41aAFw5hB7wz3mIiQ1hzQtNEzReLuDFDiX3kFmY3f1l/YrzNfYAWdQOjBd0fN+j4NUzdXUnpkLKJJE61tT4YYyqMjnMNr9JJBPJA8y7wC32Sl9HBKtsyGy7IJXYecJ90xDJnBSKQrUlrgbMO0pnuKV3U4neTOgDNF9yIfuI0cIDduKikDqQStzSBkengsXIc3kzTJ10BQYWCkq1TNZSWSFiTRFHD7oYOpSCeYbniHs/cjiZLxlSityxpm6TbEbsjPrUp43ahS7Oj85EFONDg/PmhIIrDLb4qfo36i0QpXpMS3rkDoIuUKgrvNqfOkk2nHtEC3UCocB+hmfLzJbi1TQgBY0j5INiC6zDEHW++WHucloRmTK9C79PUw2W2NmPjMsTIYDr6284U/MUrpxmy7AuRNTT16YKG8/IBD0mIRq/VAJUJw86pbVRUXi4OnkIQZ2cf0UYAthimNguMT5CQYgZvysIFlzqtbxd+CRQin4IGqgPBtFhs7pxaw7CEOUelNoqNaLt1S2H+uoT+izN07QaKrYtrBezLjrqjmAzL8gdciTPvc0SYR+mxVsrKKhcy3pJx35sJhRqk2pOkSHKbKxr24sCL7dSBKogQZha8M3ZjV
 KEQ7Novm
 QO0S7Pb4t1kEIE8EubBphN0/GDLB9Mszm0b5cf6ujocDjz8HlfpFcUPKgKcM4qc6+b/wIumCd27MomPA4oKihe8Td9GYSIcjHy+Co8SLCiLHt2/9pmbYkF2kGmrTK33/WLgDCvxHjhktk8+Ieg1GRlMtYaEn67jA4GAGzzAS5J+DvN3DEJIWcq2ZInKzPgActjz5spCS7GFm9X7Tv8a75Fdf9BcFBsJM36AcHapCu3/IPqlxrrwZeHZ4BobEWM/USsz39ayLHI191AJBc8qVQ3Jm3w1BtfWvxV3G8iI/1DifNwP8Cfrw/eon3YI+tqWzddXU6Q+pJj3C0Cpv9f4U6YV79skLfQlJVh7hCaak4pQ+W2ibNlt8u7Y5/Cva7hOVW+nBbcrw8FhzLJhtBXKVea1Hmp+jB997X9G5LoUy1yGAaabuYbxL1Le3+S7EKe20t1NyWmPtdgJFkkavqVng0MKwMBVU1inmgmz01hyYoUbhXjJBd/UfBe79Qi+SWQsaHFQARDZ2eF1gIUZhY+DK3mfVtjcvCvJYgPSTU6161CiHz7wx9pBhljvyxpxxG0EdwhlGQ6mU395PdTPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the ptdesc APIs for all page table allocation and free sites to
allow their separate allocation from struct page in the future.

Update split_large_page() to allocate a ptdesc instead of allocating a
page for use as a page table.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 17c1c28e3491..cba907c39718 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1119,9 +1119,10 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 
 static int
 __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
-		   struct page *base)
+		   struct ptdesc *ptdesc)
 {
 	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
+	struct page *base = ptdesc_page(ptdesc);
 	pte_t *pbase = (pte_t *)page_address(base);
 	unsigned int i, level;
 	pgprot_t ref_prot;
@@ -1226,18 +1227,18 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 			    unsigned long address)
 {
-	struct page *base;
+	struct ptdesc *ptdesc;
 
 	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
-	base = alloc_pages(GFP_KERNEL, 0);
+	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
 	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
-	if (!base)
+	if (!ptdesc)
 		return -ENOMEM;
 
-	if (__split_large_page(cpa, kpte, address, base))
-		__free_page(base);
+	if (__split_large_page(cpa, kpte, address, ptdesc))
+		pagetable_free(ptdesc);
 
 	return 0;
 }
-- 
2.53.0


