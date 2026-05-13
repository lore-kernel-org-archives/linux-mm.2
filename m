Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B32CCD484C
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC9BF6B00A6; Wed, 13 May 2026 00:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79F96B00A8; Wed, 13 May 2026 00:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91626B00A9; Wed, 13 May 2026 00:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A74DA6B00A6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:47:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6FC2914070F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:47:31 +0000 (UTC)
X-FDA: 84761163102.02.1E6282F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id C1A1A40006
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:47:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fypoJlnY;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778647649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQVHFBSeLLSRdwrdL0R8BCOPn2xo48mAH13JK+CARy0=;
	b=q4puV207Y3LHoM4Ckj9tjzXySeNOORHer+3+y1stnqzt+TW36wiFDdv+64AQ6OEaniEXHP
	iGWLvH4xGmo60XVoxvELsBPOrvHeFRPdBRruefQPwqeJ1B0w1ClvLz0qthE/jF0gGIgmlV
	NK7iXCLjCwEvaHEGcRDqzlJrNSpdSRw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fypoJlnY;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778647649; a=rsa-sha256;
	cv=none;
	b=a4GjrVlmHVwaRDAG7hA8fqNW22MYHXeYbGV2X3b8dEQPRAHkCU3WMKwgYuEHl9fIts4N8m
	Vj0qegtf0pFkZvlzc2zmu3v1yy9o9z1zapvQw8ATRnOeV4ZYpYDv8WYrg650GSSyJLeXS/
	PXXDTnfFb0qQNPj4W5/7XyjRiMRxY70=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E4951CE0;
	Tue, 12 May 2026 21:47:23 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 995D73F7B4;
	Tue, 12 May 2026 21:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778647648; bh=iOSPl55Bxk6YfqCKxXO93syHE1k8ylFOL8zG5k+VWfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fypoJlnYx1WM9LUZPlxzbewydDqBg7qQn8k61MYWm0J/mlRh7a7H8DqUhaOBte4DX
	 TeryiXPOVIXihT08YvxL3ggERzQkj+AYv2G9eIm44I+OKgIcdVbkYIR+hKiX7tyiYL
	 EO/9qQEd//kdJLokCKezxf+tnz/DQCM3Aei1wj2c=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC V2 11/14] arm64/mm: Override read-write accessors for vm_page_prot
Date: Wed, 13 May 2026 10:15:44 +0530
Message-ID: <20260513044547.4128549-12-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513044547.4128549-1-anshuman.khandual@arm.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C1A1A40006
X-Rspam-User: 
X-Stat-Signature: wfu4d796kes1x57ogufbcan3cn517ct5
X-HE-Tag: 1778647649-636760
X-HE-Meta: U2FsdGVkX1+/8L4t8qu47Xxh2fCZC7w0C3gh56s+hGYHS3nZxAQDIQLv10iEqIAz5BCxyJ5s3Q+j5hog5XeC86Bwfax4icbuXMFYtMhUaqS7XZDlLQqXeI5w3a7bykKLsCR32PgPcyoYeDS1924CJAJ6uIb7YctC9GuGhOjEFHtm72lcoj3ecV/g8vVnA4lL/gCGLKUjMMv1r6QvyDKh/L/AkksBiKL+PXC9LwKEXcBhhxRiH9MP3Ucw6bhFLQ4lSQlV/8uGr3te3Hbl1W0Rcb3VphRhy35j/HUxxNz7RAhsNj3blME8N6EtU6JREZj39HsK+O1cw7+fxdS1jx6uqlvNiNadeLonB/ghE6lte4963UroFprid7D6WCodyMrK89s9SDbYQELnWKNtztdSb0eGvp51VPRexsRHAn24Gb437pyObxtM0EDnrGKNGlvnQlyUmI9B/aGmF9PrVIWAmx7s3s0OrAohcQx096McKDvYBi6vVveWavmfZ/d3p7yVmDXW6eZsLREDzPDKu2xt3SD5UbSQuIs0o9SlF76Yzoyx56rEAAZZ4CYsfav0hnmmllBztJAnSbu/ynp73SeZZ2EWmjaa/XjSO4Oo2LgVeBvltLOU3wYU2N2E7hZ4DtcHQ+9ML0npMtuVzDSCzTGi9sieL4dD8gqGk8iS2Kqxq7/VZblnec4LFCVQs8m8skFkqgo4x5tMIq8ddiiLi0Ego+TpvnHtyT/2gdbzqhkImi4whVEZwKxvL8siTVzq9LSugRrrE/HaQBP4S3RrwGqliA2EZvUwK/y68eGA6PfOBC4O89+RnwmbKjBlBjZLKtEzyT0Vs85peMD6eL/+pWSpYHxmhbWWwufSBcfMZupX+v5joBqZMLTcl48n1pXGXJyFs3e8s/tg9KdDLcHYq9l8qmSZ57w6JpRhrPj8N8AavJuo+ACQkwu955Ztczb3l4UiMyiiCduhMvuKWFyJ++O
 EUsly8uX
 TAnZW6EfrWNd/IZSgXJX/Gq70dt6j9OJDYaHyyp2euE3ypwM6EIWFNnm525qOoiF0sB056bPHRP/A29u/OfpnBu7B0ewh0LHjdcJMbyo+mBxKaI6dKhBq2t7wAc4cvi1bnbF96Yqy26ZNZ09oJGUJgP1+qJk0pzXPI74blpbvwSl2EgQIjOeWNRFRFE0R0ovSckAPiFSAX13fT/Wi8Y0DPC+hXY+cquXdaBQx7u9wKxDpcXMUyCGcjOyg1fy6KKeiql6m3cbvNMaOEgjVcnxb8fkV5l8xFBQHasm8t9X/WsbCSLk5aT7ojwU9mQ363ERT+QDCyB0MNKXBrRIBYxhAzB1D1LDfF4pOsKRn6uqbyDb9tQZQwo+frOjy9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Override pgprot_[read|write]() accessors using pxxval_[get|set]() providing
required single copy atomic operation for vma->vm_page_prot.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in RFC V2:

- Dropped _once from pgprot_read/write() per Mike
- Renamed all ptdesc_ instances as pxxval_ instead

 arch/arm64/include/asm/pgtable.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4065b68e8d79..c9457d133ae9 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -122,6 +122,18 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
 	return pxxval_get(*pgdp);
 }
 
+#define pgprot_read pgprot_read
+static inline pgprot_t pgprot_read(pgprot_t *prot)
+{
+	return pxxval_get(*prot);
+}
+
+#define pgprot_write pgprot_write
+static inline void pgprot_write(pgprot_t *prot, pgprot_t val)
+{
+	pxxval_set(*prot, val);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
-- 
2.43.0


