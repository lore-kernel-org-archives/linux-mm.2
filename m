Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E65CD4F37
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9348E0014; Wed, 12 Nov 2025 20:47:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B82A18E002D; Wed, 12 Nov 2025 20:47:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25578E0014; Wed, 12 Nov 2025 20:47:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7148E0014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F8471407A5
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:20 +0000 (UTC)
X-FDA: 84103896240.30.3DA4089
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5FA311C0005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=g3PFHvGI;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf20.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998438; a=rsa-sha256;
	cv=none;
	b=3fPflnaeBbnqr9Jwjr4wapQ4zKlwzehWq6xCOQr9BckQBfW4FnRSUOAQMenIYtub6dhXe0
	W9zffQm3+/nGB7pNPL6OpS1am2biq/p6tDfRe4vKNWmIozIslNXsk8FIVDowumlnhth18l
	AouW64TMkpG9wsqv+20rpG7CtDzuaW8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=g3PFHvGI;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf20.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4yUqe5I7KDh5tDtHE97viYfWgw9C/nYwzFH0pWC45k=;
	b=CM73eEweXhd4vP63xC/O1lpaoY7aWdP7wR4gnIcAOzn5pVhr3pEKRXFJOlc4/SKlZJyYsC
	dNYZcooL18NcrA0/GFI+Ie/K3np7KNPRuQl6AqKvOMGJG50JeftITZAtzN7LoWMOqsSVE3
	J7wpcWX3VKb3Wmu+grya0tyT32w8IMI=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29586626fbeso2737095ad.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998437; x=1763603237; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O4yUqe5I7KDh5tDtHE97viYfWgw9C/nYwzFH0pWC45k=;
        b=g3PFHvGIIBtgUDcFRhSRu4ioluiTBaCgSiCixXdzrDxEFV6+xGuesbfA4K6V0m7nWS
         5f1CR4vc8XBiTEFwgWoSqusVAe6W+IkELuCfeGsu7CN1x18bTk4KFuoEjjPHfsLr/0NF
         amPKnLMt4jb9cRXnYqHxWSzg39mv7tIhXCavOFQOzHCtfrDl1exTA2UJD95JO5ho4E+a
         xAN6+xDYkbbIvyHN3F4KVK/aQqRkj0GkG/V3Z22Zxa2d14JuRjKZHXHKm8WeamKak+9U
         0Ls6/EvQx5MpyzNemBkGaub1Uvyccb6ZSZqRfa0QBi5EjqtBqjeBASkIWQiQwSahpOPf
         LHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998437; x=1763603237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O4yUqe5I7KDh5tDtHE97viYfWgw9C/nYwzFH0pWC45k=;
        b=khjhlCMi9oq4Two6a2senou2Q4UXHyltXuXfJqZ3q73Us8XtqETc5i0V4SwFp/q5qe
         O+uM/xpFi+U9csnJK5rIDsRqETeKTFpijDAvgKjbFQ73RhiVm2V5lZcfIzC2n4k222P4
         KD2VzSmAvHDd974z66Um61/Az228hYh7uRDf8ylwopPJPtB6/gtjGcbNYLbmBX5UZJeN
         kTa/R1aIa95WEoqUOF61ULcjgmwn/xpFTxRhXW+IpPFokrsImK5vAM+UuwwyeKhRwzvx
         JvmH7f/Db+5Ixc4GZhnwy2qC1eJ3gKVzV5emRdhDMRsFT2CC8Q4cGu6cM059UVAPTSee
         IDIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMvAJg1pVuoc9uKTnQQLdwuojEPIDKGupDQKqfOnRK08Fc1KwzW1G42uHBx2mfiz4lP47afqjuHw==@kvack.org
X-Gm-Message-State: AOJu0YxFhQIYY+PjLsxoPqlaLGVhW1uI34eE+0r8MuzcZqlyfkAL+3OT
	LqeXMKtkFDA7b+MNf/maHdV/Y//OgWVpkid8ga7ernIDyG5OjH1y8My47ak/c0YN7tI=
X-Gm-Gg: ASbGncu/k3ZI9M5HwWqdxsaJT/hd0pge5E8jKtCFm6rYHYsDgGqecpphfe6fri91pK3
	vIltOBwlIwin8LatyPZKnVybGORTzgb+yyWtoqZDKtjw5XjzSGIYu6PGphWI6vX8qmPYCG8mwVT
	K9P8jQr1e8kZ45g6qznw5VYNHgrgRPv0GnHleI65Uu/lTqUG0Xd6oTCBe+9WAyBbp7j8YOlbuE9
	cGFg7rZPD33i3kTZUZCMdCD7F6g4B+I+psuNaScmQq0uow0c9j9fyuQgAMLfVHYvWsMgizDIRPX
	3t0/GH5ATRA6UFX/sUXjt3Db/+CXddRrEX72aOK9h7U2FWG2mW0lgMreJ7nvoBzA+o1psfdpw3E
	Q1dLXHjJlcDfRLCh0cqAfcPyFoYCTZF5/EfG8WMYKB51w4wXTqf9reAuoAxdGeNWUqIyFFigJC0
	svE69wZlUci2ePvgGPiMViRw==
X-Google-Smtp-Source: AGHT+IEA5LZxSWMzNWQDrd0LMkvyoxWg+oEw41rcCZaseACh+qy8KkMElZZ7w0AL6ikNL4f+5tupBA==
X-Received: by 2002:a17:902:da4b:b0:297:c0f0:42b3 with SMTP id d9443c01a7336-2984ed4b960mr68446245ad.25.1762998437335;
        Wed, 12 Nov 2025 17:47:17 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:17 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH v3 12/22] riscv: mm: Deduplicate _PAGE_CHG_MASK definition
Date: Wed, 12 Nov 2025 17:45:25 -0800
Message-ID: <20251113014656.2605447-13-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5FA311C0005
X-Stat-Signature: jsr6hoy1mohwpyf77nzo4k8he84d4ic1
X-HE-Tag: 1762998438-539081
X-HE-Meta: U2FsdGVkX193XCXuTTf0UnfcIkG2HkjeFtf5blej9boWSTTlF7NnduTnqBr7KLzPZFqnrJLBYAFwFsi6tpQjF5PIudRdFNCNP8JdJpwfm4/n8n9lOX+N6QPsJ9YUFkK+rypmIzttxZ7hve28uCM+jNY5f8Qx1XWFGaMtE/1RVwhsSCqmwNQbMaonOE4drEs1ei4gkf9/BARpOfkiZKbPbf8q4EPsGB6OCvauaLuzc/6wvuBSaPYbMIpg3DAv7ogGdbhqV6VT5aoiyOh7SHpMAxJyUO8nmGrkSRRh6SpboQJmqEGRAxfWhsqU9eZxnMu2Iv61WCzSqFDpH+oPtUBvp4d2UPgh/bbcfnQM1FvjwxpH48tPtwkKIlCJYp+bBAhd8uM6qojFFVVGa8RaAZXPx8jdekaHuD1gjH8V5Xd5Xnek/AtPIs3qAC553hhiTBd3dNdiwZxyY6AsirzYZJ+T6zRp8KWq8H8hXbsA73D4TDE3GpOmE+qKMuoz1a2KBmpUSuVRV65lh+LAe/MFgTr4G1RSKLnSy1fJInldE8eifjrxsI7kpXwYATu6/rcmTf/UCaEkSXraB+A0UroGOrb13RF9EkRpNQ1SWSMFAOQu1qThWzAFP36tAJ0R935WOHKixMFXZJcL5Cju+xOjrQ2M/hNsT36tyTZyIo9FFKmO0cb8ZkhrUZT1GlgIzXejRUM37caMu7bBHj5VaYcRq8onGnVf1uvbMC5z3TSd7y/NDLByPR/CBXuxO5Ab2tOZOeLUZPCpU0KWo7nZAUxTHFvJlDo9szloz7YIjzRN3urR64ukf6qBo9Phtyg36d45MLL7AeCM4yfGgIf8+OxkcffEhQtxPZ0gTzHSKIa6+rLpm6zztzwVUPh41Dvvl21jEKcUp4AUcsXOaiaDuei7a1UBH/60AUxWOE4uOq9Q13MoNKbOBcBVUNXZTnwCp0y+TP1p49NkS+BECHIGTMmlaTM
 9bIax92t
 ZtYIZQUNAX5loCg8c4Jxym9o/0osIHbO/zIbwuU8j4bepiUFi4ui8U+vdrtusSCcXcTpP3Ue8SG27N0mJTRsc056LSPe2KAPZpXQwlynMPsV0FTUW4JGDErW8r26dRbld01QlRHZGi26iE3zLdZFMTvn1jx0YA6lRsuNBmaNEeY4ZJ/LGfa1IfsIyYXtJ4jDIY3lx4pEuHY/km4PIrdZzjF6a9y6jInqvLZCNnHWvWVFDxX6EUt9E51FHymVgsGaNNC9IZcjamuq0CsBSDH4dMZuWbQosRXAC48VhoEvGMlpilltTMCeMHu7NRvEl07je5OO6fsY98oUZimMfhVmTgMDV5klMCYMHzV2y0jOcTuw/8+fGNQKwTrkImvb7jEZuGWuW458kvyfeOBgj38oxH4IM47c97hzVaDMKAz+2lFhpP/EsKwSW6oyjKKBMq2x1rlHwIkoadD+PZxG+/OYnBMlbc5tv42Tz1mOqHZ+5v7a8Koe1NrMi6720QfWqDmZZFxgE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The two existing definitions are equivalent because _PAGE_MTMASK is
defined as 0 on riscv32.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

(no changes since v1)

 arch/riscv/include/asm/pgtable-32.h | 5 -----
 arch/riscv/include/asm/pgtable-64.h | 7 -------
 arch/riscv/include/asm/pgtable.h    | 6 ++++++
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable-32.h b/arch/riscv/include/asm/pgtable-32.h
index 00f3369570a8..fa6c87015c48 100644
--- a/arch/riscv/include/asm/pgtable-32.h
+++ b/arch/riscv/include/asm/pgtable-32.h
@@ -28,11 +28,6 @@
 #define _PAGE_IO		0
 #define _PAGE_MTMASK		0
 
-/* Set of bits to preserve across pte_modify() */
-#define _PAGE_CHG_MASK  (~(unsigned long)(_PAGE_PRESENT | _PAGE_READ |	\
-					  _PAGE_WRITE | _PAGE_EXEC |	\
-					  _PAGE_USER | _PAGE_GLOBAL))
-
 static const __maybe_unused int pgtable_l4_enabled;
 static const __maybe_unused int pgtable_l5_enabled;
 
diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index 5532f8515450..093f0f41fd23 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -66,7 +66,6 @@ typedef struct {
 
 #define pmd_val(x)      ((x).pmd)
 #define __pmd(x)        ((pmd_t) { (x) })
-
 #define PTRS_PER_PMD    (PAGE_SIZE / sizeof(pmd_t))
 
 #define MAX_POSSIBLE_PHYSMEM_BITS 56
@@ -168,12 +167,6 @@ static inline u64 riscv_page_io(void)
 #define _PAGE_IO		riscv_page_io()
 #define _PAGE_MTMASK		riscv_page_mtmask()
 
-/* Set of bits to preserve across pte_modify() */
-#define _PAGE_CHG_MASK  (~(unsigned long)(_PAGE_PRESENT | _PAGE_READ |	\
-					  _PAGE_WRITE | _PAGE_EXEC |	\
-					  _PAGE_USER | _PAGE_GLOBAL |	\
-					  _PAGE_MTMASK))
-
 static inline int pud_present(pud_t pud)
 {
 	return (pud_val(pud) & _PAGE_PRESENT);
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index acfd48f92010..ba2fb1d475a3 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -207,6 +207,12 @@ extern struct pt_alloc_ops pt_ops __meminitdata;
 #define _PAGE_IOREMAP	((_PAGE_KERNEL & ~_PAGE_MTMASK) | _PAGE_IO)
 #define PAGE_KERNEL_IO		__pgprot(_PAGE_IOREMAP)
 
+/* Set of bits to preserve across pte_modify() */
+#define _PAGE_CHG_MASK  (~(unsigned long)(_PAGE_PRESENT | _PAGE_READ |	\
+					  _PAGE_WRITE | _PAGE_EXEC |	\
+					  _PAGE_USER | _PAGE_GLOBAL |	\
+					  _PAGE_MTMASK))
+
 extern pgd_t swapper_pg_dir[];
 extern pgd_t trampoline_pg_dir[];
 extern pgd_t early_pg_dir[];
-- 
2.47.2


