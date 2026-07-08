Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E78C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 711636B00BA; Tue,  7 Jul 2026 23:11:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E9476B00BC; Tue,  7 Jul 2026 23:11:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8386B00BD; Tue,  7 Jul 2026 23:11:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 163096B00BA
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7601FA0630
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:43 +0000 (UTC)
X-FDA: 84964134486.19.9EAD3CC
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id C84A31C0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gOTQdHoB;
	spf=pass (imf21.hostedemail.com: domain of 37L9NagoKCPsmwkrxjkwrqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jthoughton.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=37L9NagoKCPsmwkrxjkwrqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480301;
	b=niZE1alSR3IwAUt1hWmLoOt3yx6MsRL84bjqS/YPPIq4Qm1Fx/dGY+pDsnniaYG7uPdj5j
	JhrIoyfkaIGj+uzfaLAzJhz0dSDajDvKinporDXt3zYnOERc4l4FCI4aSP20z6ykHLbP05
	KIUsltsx/tPVFSNPHn6TcKt3n+UbHfg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gOTQdHoB;
	spf=pass (imf21.hostedemail.com: domain of 37L9NagoKCPsmwkrxjkwrqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jthoughton.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=37L9NagoKCPsmwkrxjkwrqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIZhGnigxQeniz/pqQO7mXj7CCL2nhO/uVgxmBbLKD8=;
	b=259pWNV8oa9NGWJvziR1apO8MJs/rBtsE959UvSvCQaaBVEAReXasPZffv9nrcsxiM0j3y
	zBtViYZSJeUUPie6B7vJ195ryUtOeWj+4nh1FABrdcKhQzhql2Uf/UnIwcO8EnHX/HA6q7
	bDK1ZzH0tRMRY6Sk1Ax9JZYvotDfrcY=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3811ae55313so227458a91.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480301; x=1784085101; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HIZhGnigxQeniz/pqQO7mXj7CCL2nhO/uVgxmBbLKD8=;
        b=gOTQdHoBoabZruBdoU7KNEZsVuh/EKhDPfi7AkkA6swH935w+4svgdYEXJLg8OwyvS
         VXs/pxAyFQVOBGGwQnswOdfsysMKbKgi2lqQ1xX4lqCYuTqJAYsKdAwZIN2JCVB0fyIJ
         8CSoT87RQIis/ldnQKpIg10nsrWmCwiywE7F9dZxfZObz1tTkYFfHUigwT34iM3I6H2h
         HLn5S6A2dheKELVdlXn/BwUfL4RBGtBtkJF3cLKmzCRs2dWWMVzUvneefJwkyquaHx8x
         MPUKxiKqBXckdg3KfE+x7D2n00zFy0eJglFQG64Nymun4L54P8BkJ3TCnGAKR+HsO1QJ
         /tpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480301; x=1784085101;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HIZhGnigxQeniz/pqQO7mXj7CCL2nhO/uVgxmBbLKD8=;
        b=cUgVMujq3MjGvVrKfYW+cEHzgBsMYsydFgUxpKMoCFvyo7u+PmQLgl05F7rhTPenv+
         UMGp0Jr2x08RoeSdpyaLFgd8yWie2OH7dOgQ7D3pzKVgVVQn6v8mJro1sW4DQWsadgs0
         fAGAd0shts59/7SYct1TxOieXmgMbWSAF0fISl0Ub3dsjFhf1mzHIAtMnFsTtq11+xHG
         TonmISH5vfYPdo7/QxfDdHbp3cqTdAGezo2IAtFRMMJZxjVFlJkMxgEMquh/TosglF37
         x/vlsvGgSMIaOGHTFaCnaTHGqZrC/j//EMnSncu9LFrQMvlqVQ1y3VyiFjGazuDkohJA
         cvRg==
X-Forwarded-Encrypted: i=1; AHgh+RolQ3u3ZrBjLvCWH58K45yJl78hX51FRKBNHGPCNjYpOAWIS/tTFF/WPc+YpwG1rsI409MVORBjJA==@kvack.org
X-Gm-Message-State: AOJu0YyUtkK6obse9nzSCJBi8SuzNtQh5lIzACY4+ya2+5dIuLgeyoZI
	vRUxbdMDdi+LOn30MrnjPOSIQTJp61cXMq8+KCZBjbk6T0ZCPItKmO5+2glhEzrRq+7bO0tnzF2
	ycRbtn95Rj9jB+yCnmeCZ5w==
X-Received: from pjzt12.prod.google.com ([2002:a17:90b:58c:b0:381:1463:3959])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1d04:b0:37f:fd1f:d30f with SMTP id 98e67ed59e1d1-3893fe5d4a2mr640925a91.12.1783480300469;
 Tue, 07 Jul 2026 20:11:40 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:18 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-9-jthoughton@google.com>
Subject: [PATCH 08/18] arm64: Implement try_update_vmemmap_pte using the AF trick
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C84A31C0003
X-Stat-Signature: 7as39opwywwg6nb5ijq8dw37xsbnpwnd
X-HE-Tag: 1783480301-64603
X-HE-Meta: U2FsdGVkX19OjGMHVFSjIZa3D9YTf8tQohRERaW41yQtG3gDfJ7D2SKjumC8iFpnp3urcbxBKXH9h/+cz/W+0qmbXl6B1KuCs21RY3q+RP1sy2cSQVGvfdlvqsu8UGkjEwod2vEKOcRR2X8EZUSPMsDecD3CNTzP/TESL9iVBQwozpWWUNPcIySrJzI/nzgWa5acSEUBI0/OsZq9iUO5HuV+6MDWcQCAOFDrIT2913okqhXCDGXi2bUdK4nAPE8F5L9gQ4XbA/RLZv04Af60qmLyFJolU1hLBq71wgnjKqKl96CoDcMkUpDKfuYN0h/Ign+EyW4o+oz5T5w7JgU4cUkQ5ScpbdqG9xWTfRzY4+lVMlrfIQ8plqwyyrY77Igy2B8VVQ14cK7lD0fZrsdnuIxK9QfXofG7BwCsy4USkBg4ihV4Z8B2Xc2pzAUMigova3apNElH3ATBUgbdxPVk55DtwOQzISxDhUajvVmAOX4Bqn8WwwNnBrYPIxkl7hE2MIHsgaKPJTE14HvTMKFU4iZZkqqNIad2kfhuCjvBQEDLyOt45kTP9f9O3W7S5Gz84kInTCLT0bbX6xOBqLAdXtzVAGJBckcwmq3mmn83mWCvDm4+cuIgifoUY8H3cn2KfNvbiDi26l0XMtbrGHZGvnedA3s9jMGS7wQZkTnBTr/lwXvOoEXlIh78wBhnoG+a32NHtsHSVlrrdARIlkyp/RyZh5VBDO8CdhgckaPMjeg47Fn6cc1WhV72Owp4HG9HtT8Wxj9+n50KatdfB5qFjsITRXCgnOOKgNxd3yq1QTd2459qHKqO3Spu4oDGedaxTGPgYp4xCel2gUveCXAIiI5VhyvcLcyiQn1FPOu8A09Efydxn9BYtXNEFCF4rKpc+NkXOYRddqFyoW2QeZcSmikPkiPwPo+BQmNryWp/GmlmB5r2lFk+NmPhCdtjUBzBl6xCZN1erNOy6xSeDc2
 lHk8DZW+
 SVoAseQIQsmCn0iQi076cICBc7259YNwGKnpM2vYSDlNHlWcYL0eZbunjwjDQORq2vCrjDhOklCa3uBV5h2D/r0oFcQoBxzI55WumxSboVXk/P0r6955NVFACPMq+gaooqPStlNXOnTFd49JJRsGUMHn97u344nK93gX1UqmGl21NC3j4RFEPerV6DE0eK4oO2cMfdXfyO2DpT6+N2nbrwymXwr50dkZfuSzhdlgr56amdGYpdaHLnuhp0ABBC4lvKZVEIco7dw2aVZO40vm1tLZiUFLkIQ9kPqrLTay/u2c8vswgmk/0PTx2fYk1VxAbTFRfCv/4QfT4RIPYwvXFLiVhZ72d7U29S0mRUTaKWZCIQ8GDQKhrghVf/PCJy++dwJMcKt+zelQVM3TPvOx9C0simQMPadZsSHluOpOr4c7YlJ1ovZzawqJeVaq5E2U0jZh9gvOVCqBsr1hVicEbLoXM4KTeqbzsSrqp6kR0ud2K0Buyz6K3/ncNwMorOV+wr1DeE+09kthrHkmwDJ7RqtCDM5gu9LHR5U7SHFfuuIHW+medYj1mMmaSvpZMTKgzU2VaAwiP+HMxbKimx8ZwJkbE3JgyfIlFT44kooKtP4MBRrWIcSyjkjIbxEm844oY0C+cS2GIQOGxPg1QYeXwQvUUFMm+gdx/I7zq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_update_vmemmap_pte() must modify vmemmap PTEs without introducing a
time window where other CPUs on the system might fault.

Normally a break-before-make sequence is required to avoid conflicts
with cached translations. However, if we can guarantee that the existing
translation cannot be cached, a BBM sequence is not needed.

Translations with the AF unset may not be cached (see Arm ARM Rule
DWZCQ); the implementation of try_update_vmemmap_pte() on arm64 takes
advantage of this fact to replace a PTE without BBM and therefore
without leaving a window open where PE might fault on this translation.

Of course, if some CPUs on the system do not support HW AF management,
clearing the AF will introduce potential faults. system_supports_hvo()
will return false if any CPUs on the system do not support HW AF.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/pgtable.h | 53 ++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 5f21d3a738ee..7b11aa41d0a0 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1302,8 +1302,7 @@ static inline void __pte_clear(struct mm_struct *mm,
 	__set_pte(ptep, __pte(0));
 }
 
-static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
-		unsigned long address, pte_t *ptep)
+static inline pte_t __ptep_clear_young(pte_t *ptep)
 {
 	pte_t old_pte, pte;
 
@@ -1315,7 +1314,13 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 
-	return pte_young(pte);
+	return pte;
+}
+
+static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep)
+{
+	return pte_young(__ptep_clear_young(ptep));
 }
 
 static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
@@ -1793,6 +1798,48 @@ static inline void pte_clear(struct mm_struct *mm,
 	__pte_clear(mm, addr, ptep);
 }
 
+#define __HAVE_ARCH_TRY_UPDATE_VMEMMAP_PTE
+static inline int try_update_vmemmap_pte(unsigned long addr, pte_t *ptep,
+					 const pte_t pte)
+{
+	const int max_attempts = 16;
+	int attempts = 0;
+	pte_t old_pte;
+
+	if (!system_supports_hvo())
+		return -EOPNOTSUPP;
+
+	/* This routine is only to be used for valid-to-valid transitions. */
+	if (WARN_ON_ONCE(!pte_valid(pte)))
+		return -EINVAL;
+
+	old_pte = __ptep_get(ptep);
+
+	do {
+		if (WARN_ON_ONCE(!pte_valid(old_pte)))
+			return -EINVAL;
+
+		/* We should never get a contiguous PTE here. */
+		if (WARN_ON_ONCE(pte_valid_cont(old_pte)))
+			return -EINVAL;
+
+		if (pte_young(old_pte)) {
+			/* __ptep_clear_young() returns the overwritten PTE */
+			old_pte = pte_mkold(__ptep_clear_young(ptep));
+
+			flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+		}
+	/*
+	 * Translations without AF cannot be cached, so we can replace
+	 * them without BBM.
+	 */
+	} while (!try_cmpxchg_relaxed(&pte_val(*ptep), &pte_val(old_pte),
+				      pte_val(pte)) &&
+		 ++attempts < max_attempts);
+
+	return attempts == max_attempts ? -EAGAIN : 0;
+}
+
 #define clear_full_ptes clear_full_ptes
 static inline void clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, unsigned int nr, int full)
-- 
2.55.0.795.g602f6c329a-goog


