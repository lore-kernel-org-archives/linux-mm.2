Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C7BDE6B25F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 05:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66E796B0093; Tue, 23 Dec 2025 00:48:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617866B0095; Tue, 23 Dec 2025 00:48:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B556B0096; Tue, 23 Dec 2025 00:48:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 256736B0093
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:48:58 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E50C0137C12
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:48:57 +0000 (UTC)
X-FDA: 84249657114.19.269FDCB
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9ACD0C0003
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:48:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fs9aGpkC;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766468936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PtUq0ncq36I/75r0SFbFKqq7ZzUUx0G3Kvd2RjStNxc=;
	b=aovNR6FgmFWnVB7JmOh8RA89qpQe6glJAim8gR6PFgcO/qLAAL6RuAbeeheSvNRoQLjEz3
	3EhQ+5GFJ2z4LnVR3TplrvWYBjD4zaqs19rg7T/wW+ki/m0OQ1l7F1yymZs1oH6UjxzsMJ
	IgaJaIost01a0ErVMX/nbC95dU7AT6o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fs9aGpkC;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766468936; a=rsa-sha256;
	cv=none;
	b=Qscr/nIX/H68iPC1hu/wNS4RQxb+f+8O2oyR6KfODvHAaqoCVTsQfX+vwDt/Lt/H2z6lVF
	nohhyUdN00Dn/DgqWJr3AaI3LGQ0dkiiaouCbHCCKI//r7uoG0CG/UQ6jjms8Kwu896or9
	BcDKxySYWObFHkOXTR/i2YgVdl7L/jc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766468932; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=PtUq0ncq36I/75r0SFbFKqq7ZzUUx0G3Kvd2RjStNxc=;
	b=fs9aGpkCNiPUE/ARJ2RUEyvJpl4LC+hgxSZ7OMFxVLYU9mgcQN3DSImnaRwK+18jqNRofMcxyybIpNekJSpK8P55Bc3pN8DvWV0fyyfFheb/aIxZSZ5heIqnY2/dwnXchFiLUWV0pLs6WWT4paDzxdFjEeEAC9YRXIoqbZ9KAW4=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvWaJjs_1766468930 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Dec 2025 13:48:50 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/5] arm64: mm: implement the architecture-specific clear_flush_young_ptes()
Date: Tue, 23 Dec 2025 13:48:38 +0800
Message-ID: <e1e57d89fed939e3f7ff877e4f406d807a7eebd4.1766455378.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
References: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: ayw3mhhb6zk6z5rxr6ajjfxauwhy3o9p
X-Rspam-User: 
X-Rspamd-Queue-Id: 9ACD0C0003
X-HE-Tag: 1766468935-42810
X-HE-Meta: U2FsdGVkX18YkMcbT5KkeYjJlbzXdZduB4+FrCUF/w1oZ3vP4ssiRK0WvOino2XIkwdx5tngcnOPsqmYjbrFbZ8c7qNQBBpqQTZl2S9kIt0D6La6Dg+G1KK69IQFi7QUMy5btO+T8nxvGmFYecByXbg1NdJFfIio7mGcNkZd3+57PkrXjNCoJN8lp0ENsVyLhCI6BC93zVf7aRA9otYa1jgqNWuvRAduRqygsDpFGZb7TFQi8HX8ebT/DAHl9kaXx5gBGuEuKcLoy1jTF/+pYwLLasvxqn+coaaBsgRU57FLL1pVjiCd+XDq1mABHRB398KyouWJ0qaZ6RHFhDaFpZUSSpo4qyHDvGKyt9T5G9Gi+kK9BtkRI9BvjOack4IpDdrQP1MYmP8q7uCd4Y2/DqA8awsMZeXRu0EVXDLKImUOfA8ekTerPk3byQYca8ooWQHYvLfUraY2Zh5zAEqFDrl/87noF7jMa8e0qtfZ2DD2Cz08D9v6sSK7cHrAfD0Iap/s7rdLyK9GgGVYFsGgAkaK8htgw+cbtXvZeKFD7Vf/gHBOyVZvDgGQwJAHV4EfiEl3Cp6spQf8x4xdkPlDUcAog4GUSRH1C8iuCAwh30SBt3yPBUMe/cYJI9TrGB4TvuenIqLj6/dBrES9c+7BOshCVxPFchSL0InUvgweUzupVLzy/aufuRwOqc6nuxqWh289UMX+rbLZdZnCP9SNIAlKAZQzA1nlo8WPmFnjqc971eRcziOZs/rsHvF7rgm0KPufrZHQZ0MPsaY2YPbiDmSJP42+s6BWeu438N/p57hJKVt3C/bdh32/o9qGDnCZvoYtlMZWhNYVCDKb9YNTUmyWrxRNLudL5Ws8sZbLhmgcOVFwr34Gt8kCj4T0oD86E8iiCvierrYpnZC0ClcvDtY+MKKQPYuFx37EKXaDJprU8bbrqi5ssN1ASk4VaK3U7yizWiWKaI3JQrvUx86
 mPmvo7Vm
 3tAlvQiRVisEAY3P/Vodfaa/RynUDvXG9eWLMbmMXiAmkV/l7JdtZEbATYjPgL48YoakSb3gdvelfCi0gOyB79KcAE95eKPWJ2ImOFRXcQeN2I2gANLIiMFsXVKAiyW/IsrzA2r/Y3c/Pc91QnYRJTv3q0YNdVM7SgwAvnsaiZeyhOnbaZZCFKl++8Cx2Ya86lynQdq0EKmzX9LxNlLPt3W1aPDYsVxxVm4HnEtE1nyS5A4zPDYn78SYrB6DLwF7d0gobLXM1O00+wq3AfoB2WRKCz2I9ZCRRPJJ7unNY7q7wjw8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the Arm64 architecture-specific clear_flush_young_ptes() to enable
batched checking of young flags and TLB flushing, improving performance during
large folio reclamation.

Performance testing:
Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
33% performance improvement on my Arm64 32-core server (and 10%+ improvement
on my X86 machine). Meanwhile, the hotspot folio_check_references() dropped
from approximately 35% to around 5%.

W/o patchset:
real	0m1.518s
user	0m0.000s
sys	0m1.518s

W/ patchset:
real	0m1.018s
user	0m0.000s
sys	0m1.018s

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/include/asm/pgtable.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index d5fbe72e820a..84a6bdabb1f9 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1838,6 +1838,17 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
 }
 
+#define clear_flush_young_ptes clear_flush_young_ptes
+static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
+					unsigned long addr, pte_t *ptep,
+					unsigned int nr)
+{
+	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
+		return __ptep_clear_flush_young(vma, addr, ptep);
+
+	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
+}
+
 #define wrprotect_ptes wrprotect_ptes
 static __always_inline void wrprotect_ptes(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep, unsigned int nr)
-- 
2.47.3


