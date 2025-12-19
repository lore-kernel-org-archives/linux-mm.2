Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D2E6D711CA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D2F86B0092; Fri, 19 Dec 2025 01:03:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D126B0093; Fri, 19 Dec 2025 01:03:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22AF56B0095; Fri, 19 Dec 2025 01:03:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1219E6B0092
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:03:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFD40B980B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:03:14 +0000 (UTC)
X-FDA: 84235177908.29.C19B62D
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id CE3424000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:03:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tx71VIaf;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766124193; a=rsa-sha256;
	cv=none;
	b=RAvcoN6LAsco/T2hzftEahBrQ6XQTKhyfdp/xSboPbazvpCNk58TKw+DmGwd57DnXXOT0A
	8lIm6KwF7Vpgvf6aaGZe5fxNfBKX8M8AsyuZ92TaI50w4bwvvS/g2+QDi000e4LbcFQvz0
	NItaktJfdA3xkJ2//Neg1yTcCbc2oPg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tx71VIaf;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766124193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4MSwdop2NxYytb9NkJpD0u6xgL6N8xbLEBChXF1nyE=;
	b=gRpQbSYhHnp3NSgdXv+M2r6baGuZhBBKqPaOCMIMPwPZ9D2oc/WROQvfIHNEKAIGjCnrSK
	8vHWF2u4PjERJaag6wc1nt9wsgsOexmHBx2F45LPl1JdofoRst/fmCugtJeM8Obn33ZHMQ
	RSQWxDoPJdbIBE7mZPRlN/hrKpXSw90=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766124190; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=U4MSwdop2NxYytb9NkJpD0u6xgL6N8xbLEBChXF1nyE=;
	b=tx71VIafTiUYLT3VUhFAnXFPHGEt3C9v+dskXJNSoP5qwDBX99b6W4045AKShuYrYw7YoJy2nb/+n73wVzdoJP8TSZln9Lk/WmxwLvxGJl8imK/dkjDQeG9da4jpIrwWhmJTaeeDrth6iM0T8DaSqMJb2TiqaUPWPhRP0taHQqk=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvBfipZ_1766124187 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Dec 2025 14:03:08 +0800
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
Subject: [PATCH v3 4/5] arm64: mm: implement the architecture-specific clear_flush_young_ptes()
Date: Fri, 19 Dec 2025 14:02:54 +0800
Message-ID: <511d0f46d5f02f5e1ecc67318bc2ce8997208c85.1766121341.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1766121341.git.baolin.wang@linux.alibaba.com>
References: <cover.1766121341.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CE3424000B
X-Stat-Signature: e58kqgmx6nhdcop8uuwauj5q8i51nqyk
X-HE-Tag: 1766124192-683825
X-HE-Meta: U2FsdGVkX1/isTRXouwz+Am4T0DXF5RAmGIv54fptms0x+kbuggAzg6rFqnz+wVL0e8Rvh5sZwsqh7XT+JzUtSgcNgUOEOF+k57YHM76/aM4MZfo4+kTOv/PpdPwD3jqtUz2sZgFCt/hSgCtobDpbOxWHPnaMz2Oqsd7D6sLbfASd5B/O2HtalqLt82RcKvtkV9nQ3KR0kOUbWLCG8eJpmXF+sWcNoIHb2EzG/kRM0pQ8DI1XkbkdwDTk/weLcc+89afK20Z6XhGMrx5dX3OaWFncGval8BcwAW1ARoaNDIpjRGFBxd44frR34fkf2CDxEZFQe70gDfcITQGp8fg7DP0CPQiVO2C0gNvyY0FU52AyXltlnJMr2X2tQ2TxOik0Mi6CQ2YCRhpLoaVGcvhFGl4YnWPcOXOoosQ54gAgpm4848jF96ggEtfxYDqT0dGV4+P6zfpQxkDIqjS5tLn21CtRyV8iKhgvI79nNhRe0YNxbc2KFyhdKF9mXgjfkvAnXhB4mXlS+7UcpF2TCqw1gEvTHbl5iZH3tY95u3dxMAjWMHCKtk2wwn6yLfdEJen9PESnEEABpoUQiEZpZ1hKrtlmXpghjvK6Q0OdG/YAkCTmdW2kjQptWook58vSko21dh86Uvg8oAPFVsUyMZ+e/VbXp3xweS56AnFfAatwsZ168WhzGUf38ERGJ3BblpkSSzdX9mXGjrWihMH+OWT4hpqyQHmIJUb9kqb695M+HEuYgd3O+ftk3tq1nTLO1MZb8DKNbO++z0YXvFOIUoWt1Fpos/MDx9KgSIpoIZwU7oIb/wLsS35Swz0HZqzqhtKZMxmrscZMAFqGMqSJoaZ8rYiBTj5KWAEkNTtI+psEVnfyB/YNNMYycPTnFhZaVlzB8QDQHrjd+U5lccCZwk7r2L0u+wULXsKYhui5ox8/kUyIk8R2DF10KQFnanMpUlz7BiA4eyt0IN77ageHKS
 iYRu0RGs
 ykkBgGfW0pLVvmNRBGZNwgZ3P1uQ1OuzZ3lEa55O1DrYRCXLFcvMYWd0BLuLSOuQtZo7yinHWy2wk824yi344Q6FeNdlWiWrQYnPQuWHb1wNS7XOeHEhEt0x5SQBtH5vlqUycye0N1PZvwPx/m9wIE0Dey9F4D5DRAMeJhojeI0v8FvNB/vfD9R1cvQskvhl/c5J+XX4+3BrgiLIoMNzMKhApSFnHTWKw1gtXUUh8vRZD6iozzZiPEoYYx73mCZasmIU6m6QsHForQOvdsiQSPcpwL5sU1wQxXurvF3kBsAcaJ0w=
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
index 9086753f68b4..c57eda654d9b 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1869,6 +1869,17 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
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


