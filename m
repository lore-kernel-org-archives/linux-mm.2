Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29C6AC98307
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9396B00A7; Tue, 22 Sep 2026 13:33:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FA46B00A9; Tue, 22 Sep 2026 13:33:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5336B00AA; Tue, 22 Sep 2026 13:33:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEBE26B00A7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:33:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DD3D1605BF
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:33:04 +0000 (UTC)
X-FDA: 85242093888.28.3CB5EFD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4E8B84000A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:33:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DgfsXpYX;
	spf=pass (imf07.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790098382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OX3hsGsxEHoq3RKQiW6IXghSMDrWvO/i3oFhfjDRgB4=;
	b=GQdhlqRsIlaLQj+iG6u62qUx381psz71EDVtm3ltqiEZ9T9CXxw4tPTYSe9RQPSG1T9uRM
	0icudkKyVfnuFjCXOQLsAuIoW6bYhYwr5fuI5x2nB+Nc7vBuqI0zuIzO0j997LJLUjjIdA
	L417hacCzfMku5tASU3MGaARbT6g9KU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DgfsXpYX;
	spf=pass (imf07.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790098382;
	b=8FBPhgknlaavMSw0fj8+lJ3js9uJinRnFzmuEPsBrZQB6r7Bnjcx1nkt6HqyflPmS5g9Kf
	Mbkj4/rT9U887wGk/2+4Pht5wJ244gUNGMLFYJvr7DN53zPZTujAwJetNojdRe1zxrBOBP
	GD1dgx6LPwsMKgadsq/dGHxtteG9530=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F2AC1AED;
	Tue, 22 Sep 2026 10:32:58 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 269643F86C;
	Tue, 22 Sep 2026 10:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790098381; bh=67NvP4PmpCnowWkBeuojZg3SSMqBMwtXDXBIbaFjYiY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DgfsXpYXf+AULhg9SSync9g0KRdJYDwFtPkkElJ/a+wWRq0XRp4XhA/+AQcIjVicE
	 yO9uEDNDRHS6qYUxgDmH4JNy09PlmpfEqfv0MLS+ymlFYbWBDTSK3ieWYmPBLASNUU
	 5DDokOnKTfjJP4/bugtIcH+JIC+awj5G0TJ4BSC4=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:31:58 +0100
Subject: [PATCH v2 3/6] arm64: use hw_pte_val for HW PTE loads and stores
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0_arm-v2-3-a3f1ddff0a8a@arm.com>
References: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
In-Reply-To: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4E8B84000A
X-Stat-Signature: 7nh9ukn18dxxo51ghcrz8b4sc6e6rtej
X-HE-Tag: 1790098382-560042
X-HE-Meta: U2FsdGVkX18eSpn5UsFMs67aIQpWj6hJdRzKSI/7ml/zqZlWnCVtjiGaObnD8E3FXypZO94m0woIvF4M+vF/DfYjgcfnyUavDOTL751TeYkvwFaFnqHLXV0ldmTBYNhL2qBR0XSCt0aNj9UTtwvAaSTNv0ITYIw4SotwmTbD/ZH3RSAKuWOwMJlunpkjLrRxDpsgvQLy7ErdMhYYJT5I3tODLQIYlTQtbgmXGs/doyCj/1B+rOhDyGEuhN+Z2QY1vnTd1yUEwDhlhoAO0Ef3tb5OWO4xdBuXX8KO9tFbBhJDq/W3X3vQLCecGSqHDQFhsxJJ/sg1MXuuoZZhwSD6pnuelG2OTkqrmmqqW+6U9O1ps1SUQYp8yzYskHiRAXBlj6tgSsvmEf2/dDVwjG2vXagu8tF6h7BEQ0TDZYITAlc+BqgLWC9ZV6sVSUGhMJfv4Mt2INQ0mzGwI+oNs3UWWR2ecdxo9fY5vNZsZnfHxKw+cR7XyPi1eHh/ftDRBz1dcSezcmnzvx78CyGpgjZCgL6ByN32l0i09ZfDuYliHckV2myOO1JKtQQrEqVXC0kMDRjLIhdFqvVzJPjdQVH4bqFtHA+A5I+RJ5Lk1jAOHftdqr+KcKw59kjBFsHXR4wGjOPmgj9o3nKzZQSyHhiBZT2BlZ2HpIIuq9SncMiiwMbekqulNEOGt41AS/iT/3XmLrMfwyXPWijwQAxZ+kIoFnZHC/HIt+F89iMvSqDQaMhiv+68d6b+RzYsZG5VASCc+sRLWRKgRG2Tm1tUCwWILBGhDbYnOw+F22MyoDDhh4xEiFwln7g0UkbW/o5J23muI1EPMH3qj75VS+5jgEmVuBYASPApufwLzW9XzwTP+wAjYB96Axfpks3lLuuzTRGrQGFAcmhqAzdf9zAtYAd88aS+q0fgcogI4LbL/cBFsB9LNklCEq8qf1iS1F//FdaxASGcsqenGgcGJMbZaYR
 AdQNeogS
 KgZNIo1HMrm/SST2i7NAXg7H9cuj/CmHlhN5bGSyY+FjQ5KQ6T/g5/WTE8agP6SP42ujlSFNsQr2O8ZDx3bhlJJ2SQ1/cpPm0mSDFQl5kGI6Krynm0yWFBplRJ1/GWCt6g91KOSvLoKLY+3MlfRGEYupkwdGgZVSR/kz8GnLERNo7IjNmMdRV+cbpj/bu2GztxJ2jil9I1hL+o0OxJiCwClic2s+pxSHnNN6Jt8icjmyawHZjrP38+io9d6Z3kC7nKCAJv3XRtsFbPMC0eLqxGUxMAPhaipCTuUG2HhnDM7DbYa6oeCYwugC8c5jnCcNx5HNYWYCxUCvfNQjdvsf+f3jYVIa4DXtromSXUxTJKaF7k0rnqULDu1VEmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__ptep_get() returns a SW PTE value, while __set_pte_nosync() accepts
one. When HW PTE storage uses a distinct hw_pte_t, reading or writing
*ptep as a pte_t no longer satisfies those interfaces.

Use hw_pte_val() to expose the pteval_t stored in either the hw_pte_t
wrapper or its pte_t alias. __set_pte_nosync() writes pte_val(pte) to
that storage, while __ptep_get() reads it and reconstructs a pte_t with
__pte().

This avoids imposing a generic conversion interface between HW and SW
PTE representations, which may require architecture-specific context
in the future.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4768ec59de555..ce6580ab63128 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -360,7 +360,7 @@ static inline pte_t pte_clear_uffd(pte_t pte)
 
 static inline void __set_pte_nosync(hw_pte_t *ptep, pte_t pte)
 {
-	WRITE_ONCE(*ptep, pte);
+	WRITE_ONCE(hw_pte_val(*ptep), pte_val(pte));
 }
 
 static inline void __set_pte_complete(pte_t pte)
@@ -381,7 +381,7 @@ static inline void __set_pte(hw_pte_t *ptep, pte_t pte)
 
 static inline pte_t __ptep_get(hw_pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	return __pte(READ_ONCE(hw_pte_val(*ptep)));
 }
 
 extern void __sync_icache_dcache(pte_t pteval);

-- 
2.47.3


