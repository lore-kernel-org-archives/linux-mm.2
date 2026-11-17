Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F2BA606A331
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=D0K5hEkf
Received: by kanga.kvack.org (Postfix)
	id 539C66B05B4; Tue, 17 Nov 2026 02:06:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511DE6B05B5; Tue, 17 Nov 2026 02:06:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38AF36B05B6; Tue, 17 Nov 2026 02:06:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0B26B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:06:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63306120213
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:34 +0000 (UTC)
X-FDA: 85443727908.08.BC71E46
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4954880004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D0K5hEkf;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899193;
	b=Rg4CGvia6MfLoo0gkPblpUL1R8C/1OJcLpsfwe68JEkODOd//CauWiaJDSIg4GY/weVdPy
	G91AeWBcZGOfaC4E8XFcQQdwvaLTAkduOwHAvPtHsZQ6VRFSutQ0I060mgDRjkF35tlO45
	nDv6Ikvv3+FWnrHXKuZSSOA5fx1AVkM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D0K5hEkf;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3NItBReUtOBWpHO0nf0rUAjTdM1Dh5h3BZRHNSIgwrA=;
	b=usDQkKSLGpw179PV0SbJnimnVyNoa4nKjAHTtMNIFp1LpjFPXDhHNOPfpgtmFAgH22muST
	66/7QulP6SWn9qvWlYNald46Ij8Nt+4dOi7rSxCQA+ZThcC3JDt9Zg4aqP/WWIq2np/So7
	nvViT320/BBo9nqgQ2cNpii0SV3r7gw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 985761682;
	Mon, 16 Nov 2026 23:06:27 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDF1E3FB7F;
	Mon, 16 Nov 2026 23:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899190; bh=QAGXNbzD0g0sHHdjDN/4c/Sx+cC3l60UDdZ0bXS07ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0K5hEkfCw9m9shseCLzkHCVRdi1eAy7puGMYpkj4yj2DQMdwmMeOxPNOdJW0aDB6
	 APo5YxDzM3z1YOuhWdAOf/Ep7TwFuoMvRYhoyIK59POQa2foDTv3dXMI0YYGUujhVd
	 4qGB7+5QaQgdd5g6+fmGLhnJ3hQ9M7fcwd6uoVsE=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V3 02/14] arm64/mm: Route all pgtable reads via ptval_get()
Date: Tue, 17 Nov 2026 12:36:01 +0530
Message-ID: <20261117070613.1183243-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gbhyy1ki111hgt61zzprfrd1z3jsjyge
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4954880004
X-HE-Tag: 1794899191-914802
X-HE-Meta: U2FsdGVkX1/ipS29d3BMOMBfAfOhRNr0WnfueOZ+DtBkX9Ax4YgkbXFPGKZe+YmtZn+KPpOAn0Ppxdu/Wp+jnYx67g+SQqOI63kVBS47XMxeQQ8kEYtN/cg6pQTGwmQAx+jkErM+LcgVQPE3b4dDpDGKaq3Qv2adibz9fGwGYYPOMfZBITfJyo6mmJIUcXeAv1QnznfAZBNxPbgRFmJkG0FY7A9/xm38TUyfz29Q78/JmGn6wUfxuAETAlBRioIYcEZrPjvSbAQtXfMmECFZNdEGuRqAxVomc8iy/WOhdVoFpqbzy01hcMAxhkzlp7ffvkPTBVKwUXTWDoVtUtett0bCOFBrNc6iCNIUsj8qKgptO6uC4LvXVpM4m40IpL2rRcK5MHdTc2CAu9FwwCNPQ42UGuqRfahQVgaDl9C7IG7UjCTIMekXPITPMTHLJcEC0SALmqsbyw4/ujXuKNgF5ksICYSE53O9EuEfX6UnDZmH860LglkRXloL2TunBYdBvDAhfVTC0LTn8QmTK+9956dbj93YJNbEFuOJp6nIRhyjkQg9tQYlXupTiRLUax+Y58ChZ/F5a4WFJnHZ/W/zsoZTdcQyX//L7jZnaEDu3h35KRR4Lst8ibQusSV1YgtK1ipGq1UzYymKbZm3fT+LonEcnSrawKBv9mHPblVxR6ISqMisdxGKtE9Pd1G25TXlhDEHMaNMtsheES+eXNBizbfU+SljbC0s4pCRF6Jcq2RxqUIu2Ofc1pxd054XcX8DdDEepuDE/CVfr9iX68YhSjm/RS5ewbdF1FvYfTEoovJrZpPNdb/Z+j7c8t4R2/KP/60iECKYaW75y2BSF0380XCP3P7UvoQlvcWoHIz3xBIuab8fN2mG+nPRRRKLXPXs8K7cXg6UkM3brOMbVf/na/WR7jNGcmQ21OaB3uhnVXmka2awiUVRA8BA8nCUD/mhJfhn/76OQedJvKD2n01
 916PknVE
 yhZGCMUDDUOzvPSBmzfe0AF/jnloKpd1FYTVtkHZmKxfHABM0IbjcZDG1kin1bcyvk2O1pd3jEX4vow/fJiO5vLt6t5JZGl8bgZ9JNOYtSOYbcCOX6aCjhWrhQEHFhD6TSaRFknnisMFiL1TCfhov3cEUFZHjDrLXopZfsPHT/vZekTkE/4Y5F8K8MClt9KZBkFuS3104SnU3BpuRFm/mWwyP7YeRdXg1wQ8TpzVZQ1d+tsDtL+NBAyUmkjFxh1bM26DLrwrDYNqgWrIcAB6ayGb5nexa59px/BpQYs8GAD+eZJVir3RTeGHEmDPj0lOk8WaLHxhUum39bHPaz4z8qTkeuct+ocSIHufZmqAziZ/rxdwxLKW43d8/P5MIbbrKPX5Cv76jw/CG/nKfbE4FPD3vqu1LJ1GMWcBVkQ1G1cXFk64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Define arm64 platform specific implementations for new pxdp_get() helpers.
These resolve into READ_ONCE(), thus ensuring required single copy atomic
semantics for the page table entry reads.

In future this infrastructure can be used for D128 to maintain single copy
atomicity semantics with inline asm blocks.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a760c65de5cbe..1c982ccc1e5e3 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -84,28 +84,30 @@ static inline void arch_leave_lazy_mmu_mode(void)
 	arch_flush_lazy_mmu_mode();
 }
 
+#define ptval_get(x)		READ_ONCE(x)
+
 #define pmdp_get pmdp_get
 static inline pmd_t pmdp_get(const pmd_t *pmdp)
 {
-	return READ_ONCE(*pmdp);
+	return ptval_get(*pmdp);
 }
 
 #define pudp_get pudp_get
 static inline pud_t pudp_get(const pud_t *pudp)
 {
-	return READ_ONCE(*pudp);
+	return ptval_get(*pudp);
 }
 
 #define p4dp_get p4dp_get
 static inline p4d_t p4dp_get(const p4d_t *p4dp)
 {
-	return READ_ONCE(*p4dp);
+	return ptval_get(*p4dp);
 }
 
 #define pgdp_get pgdp_get
 static inline pgd_t pgdp_get(const pgd_t *pgdp)
 {
-	return READ_ONCE(*pgdp);
+	return ptval_get(*pgdp);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -405,7 +407,7 @@ static inline void __set_pte(pte_t *ptep, pte_t pte)
 
 static inline pte_t __ptep_get(pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	return ptval_get(*ptep);
 }
 
 extern void __sync_icache_dcache(pte_t pteval);
-- 
2.43.0


