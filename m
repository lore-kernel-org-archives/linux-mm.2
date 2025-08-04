Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32622C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2BD98E0002; Mon,  4 Aug 2025 08:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03228E0001; Mon,  4 Aug 2025 08:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3FDC8E0002; Mon,  4 Aug 2025 08:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FAFB8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:39:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4740080567
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:39:47 +0000 (UTC)
X-FDA: 83739031614.01.D4D4D38
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5F265C000B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:39:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of liqiang01@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liqiang01@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=LyKoAUEsBIIMJuLtEmOBnSTN4Ih72cAcSdJgrrV02GY=;
	b=QMken57rP2j5+esA393fRmkE38HUHlbv+wX30v+jSd9s1MHwY7B8pwGsUIw0/GKsHWPzfY
	8Ea1QJCvbpoTWzRqmK/0ms9Gm0sCGQiNNG4mHG88iBltoDnpo/Xqm9gtD00aq3gameb617
	Pn8n99P/A5HGMXIYNZAPmqAHOZsnpbo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of liqiang01@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liqiang01@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311184; a=rsa-sha256;
	cv=none;
	b=PLKyDxyNQ4Dto1uvy6uUrZi8pgRjXtsD1SgkN7giYC4E4y+B0FckXfBXRitSgFxvUdRpRB
	3/Hip2aYo2h3Co6okxpdBEgJHcf1lwybY1AcAGtIMk7aKqJAMhq8pcUf6OePeKJSeC20+8
	QYjNn2X5K23K6Evl99c5gb5Ye1359Ic=
X-UUID: 1313378c713011f0b29709d653e92f7d-20250804
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:cde1d874-73fe-4e09-b3f8-ce7c60d1ae2a,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.1.45,REQID:cde1d874-73fe-4e09-b3f8-ce7c60d1ae2a,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:6493067,CLOUDID:468911c6df3b77ec9f02fa5e36d336c3,BulkI
	D:250804194720VBS1UNX1,BulkQuantity:1,Recheck:0,SF:19|24|38|44|66|72|78|10
	2,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 1313378c713011f0b29709d653e92f7d-20250804
Received: from mail.kylinos.cn [(39.156.73.10)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1288974341; Mon, 04 Aug 2025 20:39:34 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id A82B5E008FB3;
	Mon,  4 Aug 2025 20:39:28 +0800 (CST)
X-ns-mid: postfix-6890AA00-5248871
Received: from localhost.localdomain (unknown [10.42.12.14])
	by mail.kylinos.cn (NSMail) with ESMTPA id A6631E008FAC;
	Mon,  4 Aug 2025 20:39:26 +0800 (CST)
From: Li Qiang <liqiang01@kylinos.cn>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	Li Qiang <liqiang01@kylinos.cn>
Subject: [PATCH] mm: memory: Force-inline PTE/PMD zapping functions for performance
Date: Mon,  4 Aug 2025 20:39:23 +0800
Message-Id: <20250804123923.296230-1-liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F265C000B
X-Rspamd-Server: rspam06
X-Stat-Signature: qefbgmxjjeiqrsma1nmma8oqb381moyd
X-HE-Tag: 1754311183-946254
X-HE-Meta: U2FsdGVkX1/RlpelR33YqaiijVXQMnVIpB676T1ni0Y4zbbFw3wm5c5VJ8SYruvKeiP+pJX63+KcNHr8GXw6MftoCHzwgG1D4kgQN4RithTLX0V5tQldQz1SVCeclZW33BWNqjn6fpcud3jEmqOzwmHMZb6AacC/JA95M6UJZeI0KkkI5J6kp029ylbk26q8twFTC4C5IGF+9Zx9sNEQSKsGkTosnkx8sFRSncltgJatebkU96WrbTjW3+vKrBSe8raXwyZzBmxGHRVmzafW/mIwJyU5o9x+7AcXKHNMugHt9viHLKwj/xb6TtGLMciAhCopZLXkdiOaBicNgzZ9ZU9AtCsdhxkFkttvnZOhkFFkI7IxxlxI7Zf6B7RtbuDePpLD7JajwC2QktPjqxXK39pYxfelTfS8If5PyvUUx53kVM90bDV+CVMCWd5TQ5vverOGs7d/SHf8ZXRT+MQXbolmz26IfDSMPMDLez3IhR4SDDi1vH0u2Aj4uwiR6od1fcDxB27hnA7Sow7D0+zblVm2sJtJms4hPfHDKX8YZXii/nMFXSdQKA7iot91nW46Q06h/rVMoRFmpUh+OdNi/ZzOtBFy4qj8EtPhLKaPbKGoCcokbGmSk2RPSL7Nmam0iYh91gdUDRYLJ+mLJbiKsa6ie6iqY3ejrVxwETrzmQVycY4fQMOOZZLMnq0gGqkXSdX+96/cl1TZ3BJlh1IuLCPnrdSeRJzrhmbs3US2RC5HgIpBw0JuBnT8yUkeAk6u7jRuhVYuKwM4n6Fkh1x/MR9TOXF6FjWRfKN5iAz1zb/bf6UtRRTrtpsFhvwdu5keKx7mHgzEtnTxPDJ7e80GL9y1bdB/jpqEMtsxaNXWSRBsS9QTGn6Z3KIsmRG/c5OR2gnTaB7ic/f9IrDiRXBJp/lB447NhUf9HjqrzxIjFR1PLhC0UmgTWnS9FvNyVCRLGLrkPW8Zqf1WFuyAsei
 8l/o5eTn
 5zC5gTE+v2npZH2wgOR2gen/M5LPKdDXhZaf27Gebvm26EEk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change converts several critical page table zapping functions from
`inline` to `__always_inline`, resulting in measurable performance
improvements in process spawning workloads.

Performance Impact (Intel Xeon Gold 6430 2.1GHz):
- UnixBench 'context1' test shows ~6% improvement (single-core)
- UnixBench  shows ~0.6% improvement (single-core)
- mm/memory.o size reduced by 2.49% (70190 -> 68445 bytes)
- Net code reduction of 1745 bytes (add/remove: 211/166)

The modified functions form a hot path during process teardown:
1. zap_present_ptes()
2. do_zap_pte_range()
3. zap_pte_range()
4. zap_pmd_range()

Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
---
 mm/memory.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index b0cda5aab398..281a353fae7b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1543,7 +1543,7 @@ static __always_inline void zap_present_folio_ptes(=
struct mmu_gather *tlb,
  *
  * Returns the number of processed (skipped or zapped) PTEs (at least 1)=
.
  */
-static inline int zap_present_ptes(struct mmu_gather *tlb,
+static __always_inline int zap_present_ptes(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pte_t *pte, pte_t ptent,
 		unsigned int max_nr, unsigned long addr,
 		struct zap_details *details, int *rss, bool *force_flush,
@@ -1662,7 +1662,7 @@ static inline int zap_nonpresent_ptes(struct mmu_ga=
ther *tlb,
 	return nr;
 }
=20
-static inline int do_zap_pte_range(struct mmu_gather *tlb,
+static __always_inline int do_zap_pte_range(struct mmu_gather *tlb,
 				   struct vm_area_struct *vma, pte_t *pte,
 				   unsigned long addr, unsigned long end,
 				   struct zap_details *details, int *rss,
@@ -1698,7 +1698,7 @@ static inline int do_zap_pte_range(struct mmu_gathe=
r *tlb,
 	return nr;
 }
=20
-static unsigned long zap_pte_range(struct mmu_gather *tlb,
+static __always_inline unsigned long zap_pte_range(struct mmu_gather *tl=
b,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct zap_details *details)
@@ -1790,7 +1790,7 @@ static unsigned long zap_pte_range(struct mmu_gathe=
r *tlb,
 	return addr;
 }
=20
-static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
+static __always_inline unsigned long zap_pmd_range(struct mmu_gather *tl=
b,
 				struct vm_area_struct *vma, pud_t *pud,
 				unsigned long addr, unsigned long end,
 				struct zap_details *details)
@@ -1832,7 +1832,7 @@ static inline unsigned long zap_pmd_range(struct mm=
u_gather *tlb,
 	return addr;
 }
=20
-static inline unsigned long zap_pud_range(struct mmu_gather *tlb,
+static __always_inline unsigned long zap_pud_range(struct mmu_gather *tl=
b,
 				struct vm_area_struct *vma, p4d_t *p4d,
 				unsigned long addr, unsigned long end,
 				struct zap_details *details)
@@ -1861,7 +1861,7 @@ static inline unsigned long zap_pud_range(struct mm=
u_gather *tlb,
 	return addr;
 }
=20
-static inline unsigned long zap_p4d_range(struct mmu_gather *tlb,
+static __always_inline unsigned long zap_p4d_range(struct mmu_gather *tl=
b,
 				struct vm_area_struct *vma, pgd_t *pgd,
 				unsigned long addr, unsigned long end,
 				struct zap_details *details)
--=20
2.25.1


