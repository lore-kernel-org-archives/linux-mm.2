Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3286C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 04:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2066B008A; Tue,  8 Sep 2026 00:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D635D6B0092; Tue,  8 Sep 2026 00:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78F26B0093; Tue,  8 Sep 2026 00:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A10B76B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 00:27:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43AB31C1FD1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:27:46 +0000 (UTC)
X-FDA: 85189311732.02.07FC704
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 20E9E180007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:27:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rGXTvjNf;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788841664;
	b=wW0+oTgqr+y9ifkdisGlKeWmjBe+7WQLoN5R0gpnCx7jopN89WE3HbMh2FVnGw6iB/3Br7
	PhmzcKI4Hvk3b4djJKPKF9hQVOnQ+x+Tkx4acPGfR6XwpIWEHbX25Yjnr8/tGJjaD1pgIv
	MR+tHYfyigw4cgS5sAiQFlv3UREG8q8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rGXTvjNf;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788841664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54x+ic7p5AvLCn1WaDLbC0t3N8vsMYyzJxRLU1kfPPg=;
	b=XSzT46qRzduhWI7J98T/dVglyeEcLcv3KLotPH1FL9IOHMVsc9UpSkAdzeS7xrwRZAtAyS
	z3Epf1r2PJa5uy9evS83c71iBu79iwBJx5w8jepOAbY72wpqp+tXa5IiGMbzJ7eRrFVRtb
	l8MkCQRZAfgzEL4UpMpWXrOjACo/PK0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 847191476;
	Mon,  7 Sep 2026 21:27:39 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A8713F528;
	Mon,  7 Sep 2026 21:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788841663; bh=hQJkvNi3bb05p4k/wBr7hrOWhHO3OdgSFqaZH/K7Pio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rGXTvjNfsjYZ5xTnn8tyhlFX0kFcSi6jAtuHU6+/Kt9ZQdNKwjGhAiOza7Kt7ZXc4
	 OUH3+1Dcia4bBZrF+87mn/ntKj0rOAVUloAmgg/kSoQk1iBamIQ4a7CUcJKuhm1cqU
	 bUgvStjtQYXc+HMvAzXwFeJ1V9ac38ruBW8clF84=
Date: Tue, 8 Sep 2026 09:57:39 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] arm64/mm: Move __check_safe_pte_update()
Message-ID: <afwvof4qixu5rzkgnpj272ntazog4zpdm6sietwugljizmtmel@q7ldx23yngl7>
References: <20260901065454.1906343-1-anshuman.khandual@arm.com>
 <20260901065454.1906343-2-anshuman.khandual@arm.com>
 <a70e45cc-dbf7-40da-81e8-ee6055f2692f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a70e45cc-dbf7-40da-81e8-ee6055f2692f@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 20E9E180007
X-Stat-Signature: qucajx5pjzr9co5edj3ynk6f1idiipud
X-Rspam-User: 
X-HE-Tag: 1788841664-394994
X-HE-Meta: U2FsdGVkX18HkBWk+ir/zp48bF3ipCjMHk/5vy2YGYwf7nkOsQRnNFZy8XUQtJpmqNAW02yChU+RZAIGFwt3yaAKCsuppBY8jpT3FNKoCnbHE7sozNOmifYDc2YbUMWbo/5GEFMXlOMFBqGIc3qeKwxdyL7OYPOcD7v80PuFmx8KuhwWOKxcP1j78rP2yQzpd+yhiSNFlWYJe811yW3bU7LFzLhlEX3y/lkC1ymTdPHvi/SDpD84rlFzMOQZXYsH404R97rMs7rEjGaz5qP9p8K0boT6yZZlRDD5bi+nRymHu0RKa2FdSIK7S0FvnWy9AA1y+vtHG/zo+9YtiB1A884W/DtLsXHGw6v4GARCwZs1z3OuwYw5t0ZjQTdHcsnWO/Qa5pYNxjmAIZiVExc9IlCyct9oh/ADgz6BbFvLyThFf4p0tjg9KGVW+EJ6UWbE21+lnsH796VIryEBm9f9ZLLSoEP1pYsimKbtWOcnxxE4Vhy1uIjt7mLk7zsgCEBPnTdDo9bSktQ9+r9WdS7nqckTkuDowt2qN/MPQbxjfrLHPFnnPnsymhtK9FtSLYqVIrtOBicMVJ83Wlob9j5wUh4rVseuxSlHSH3qJyG6dp7cp5sMMIZQSJJeTECVNdAG063ZAALWMbafv/LyYwYj+Szl0Na7XJq2+oE5D2ypqdVGGGTXAGM6ZXPLZej7H83b6yg5slFFXshMobRpf8fBzm+fjx2EJB/hYsjfsXI7fcHMxLqE9O8AvT20DlN43/AMW3XuIypN4f76xi2/7+LPEcQlga7Deqw2gURwS5WQhmniEHktvZAg8HadNziLIR5aKLX2Elzvgu+qe0mqo3LMCG9NPDtXFd8GbCyIy0t2ct05cuuFYw7PcBTjsY0xmpvTFaE8o+eqKw9L/lYiDXBm0n4XkfATLWce3ZDU9WHXJLk7CgMPn5sNdNkFC3+w4paD6HG8bvo7kTcCWCghNxf
 LrWJZOX+
 LCRqGWvj3rlRciRjmDQAA49R6i1UrfmuE7Ghdnuzz7BzI5PnOSSHvG7MVVLdBJoNyTGt4BMAtDJvy6oxxijrN+b0ly9dTWgiR3SZQno6x1dSRCuIDj/kraZruqqfwK2Y7CVx9ZyZjmGW9tqiuC1yt9OSLA+bXVen49wEETCgSYadqmDIlEJlrxdH2enK/7wx2ArjmgBEdyC+xAPljNkvLbAboDnLjhXMTcAtew2Y0yTrM99LhyJrphX1KgaMyXngqHpY30A+0n0GKmpIs3mAAijFs4I0Y+YwPPz5YgHfqyklzO/OjSdqwXhOy8m73OHmSMWZXx5WBon2y/RuL+TqcTSZmYjio0EIVoAg34f0cIDX2kOsSE5QxtXNyROSF31wtNNRbzRSgaBI+zfCl+J0BCf2pb7BM+H6y01sfXVJFRApce/EmSMb/jLe3G62YPkIBNrv3/03VVquMRdFnupVeZXTxjsuZJx5P90/C0yI96QMWU3Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 05:48:18PM +0200, David Hildenbrand (Arm) wrote:
> On 9/1/26 08:54, Anshuman Khandual wrote:
> > The page table entry print helpers and related macros which are defined in
> > <linux/pgtable.h> will not be accessible in platform <asm/pgtable.h> which
> > is basically caused by cycling dependency.
> > 
> > Move __check_safe_pte_update() inside arch/arm64/mm/mmu.c as a preparation
> > for subsequent usage of the afore mentioned generic MM helpers.
> > 
> > This does not cause any functional change.
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> > Should __check_safe_pte_update() be wrapped in #ifdef CONFIG_DEBUG_VM
> > along with dropping off current IS_ENABLED() test. That would ensure
> > the function never gets called when CONFIG_DEBUG_VM is disabled. That
> > will preserve current behaviour as the inline function gets dropped
> > when CONFIG_DEBUG_VM remains disabled.
> > 
> >  arch/arm64/include/asm/pgtable.h | 47 +-------------------------------
> >  arch/arm64/mm/mmu.c              | 45 ++++++++++++++++++++++++++++++
> >  2 files changed, 46 insertions(+), 46 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > index e89ec5f4787b..61fbfab3e06e 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -387,52 +387,7 @@ static inline pte_t __ptep_get(pte_t *ptep)
> >  extern void __sync_icache_dcache(pte_t pteval);
> >  bool pgattr_change_is_safe(pteval_t old, pteval_t new);
> >  
> > -/*
> > - * PTE bits configuration in the presence of hardware Dirty Bit Management
> > - * (PTE_WRITE == PTE_DBM):
> > - *
> > - * Dirty  Writable | PTE_RDONLY  PTE_WRITE  PTE_DIRTY (sw)
> > - *   0      0      |   1           0          0
> > - *   0      1      |   1           1          0
> > - *   1      0      |   1           0          1
> > - *   1      1      |   0           1          x
> > - *
> > - * When hardware DBM is not present, the software PTE_DIRTY bit is updated via
> > - * the page fault mechanism. Checking the dirty status of a pte becomes:
> > - *
> > - *   PTE_DIRTY || (PTE_WRITE && !PTE_RDONLY)
> > - */
> > -
> > -static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep,
> > -					   pte_t pte)
> > -{
> > -	pte_t old_pte;
> > -
> > -	if (!IS_ENABLED(CONFIG_DEBUG_VM))
> > -		return;
> > -
> > -	old_pte = __ptep_get(ptep);
> > -
> > -	if (!pte_valid(old_pte) || !pte_valid(pte))
> > -		return;
> > -	if (mm != current->active_mm && atomic_read(&mm->mm_users) <= 1)
> > -		return;
> > -
> > -	/*
> > -	 * Check for potential race with hardware updates of the pte
> > -	 * (__ptep_set_access_flags safely changes valid ptes without going
> > -	 * through an invalid entry).
> > -	 */
> > -	VM_WARN_ONCE(!pte_young(pte),
> > -		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
> > -		     __func__, pte_val(old_pte), pte_val(pte));
> > -	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
> > -		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
> > -		     __func__, pte_val(old_pte), pte_val(pte));
> > -	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
> > -		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
> > -		     __func__, pte_val(old_pte), pte_val(pte));
> > -}
> > +void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte);
> >  
> 
> That implies that any __set_ptes_anysz() will invoke another function call that
> will not be optimized out.

Right.

> 
> You should likely keep most of __check_safe_pte_update() in the header as an
> inline function (or at least the CONFIG_DEBUG_VM check), and only move the "slow
> path" code.
> 
> Alternatively, make the whole thing #ifdef CONFIG_DEBUG_VM and provide an empty
> inline helper for !CONFIG_DEBUG_VM.
> 
> That's probably the cleanest, because performance with CONFIG_DEBUG_VM is not
> really relevant.

Agreed, I had asked exact same question earlier as well.

> > Should __check_safe_pte_update() be wrapped in #ifdef CONFIG_DEBUG_VM
> > along with dropping off current IS_ENABLED() test. That would ensure
> > the function never gets called when CONFIG_DEBUG_VM is disabled. That
> > will preserve current behaviour as the inline function gets dropped
> > when CONFIG_DEBUG_VM remains disabled.

Will fold in the following changes.

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 61fbfab3e06e..281a512f1fc6 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -387,7 +387,13 @@ static inline pte_t __ptep_get(pte_t *ptep)
 extern void __sync_icache_dcache(pte_t pteval);
 bool pgattr_change_is_safe(pteval_t old, pteval_t new);

+#ifdef CONFIG_DEBUG_VM
 void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte);
+#else
+static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
+{
+}
+#endif

 static inline void __sync_cache_and_tags(pte_t pte, unsigned int nr_pages)
 {
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index b5de4095d650..26f4cf7b753e 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2408,15 +2408,13 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)
  *
  *   PTE_DIRTY || (PTE_WRITE && !PTE_RDONLY)
  */
+#ifdef CONFIG_DEBUG_VM
 void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
 {
        char pte_str_old[PTVAL_STR_MAX];
        char pte_str[PTVAL_STR_MAX];
        pte_t old_pte;

-       if (!IS_ENABLED(CONFIG_DEBUG_VM))
-               return;
-
        old_pte = __ptep_get(ptep);

        if (!pte_valid(old_pte) || !pte_valid(pte))
@@ -2442,3 +2440,4 @@ void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
                     __func__, pte_str_old, pte_str);
 }
 #endif
+#endif

>
> 
> -- 
> Cheers,
> 
> David

