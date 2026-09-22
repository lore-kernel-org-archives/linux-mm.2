Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20713C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 23:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16B96B009B; Tue, 22 Sep 2026 19:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C78A6B009E; Tue, 22 Sep 2026 19:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F796B009F; Tue, 22 Sep 2026 19:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5389C6B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:58:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C62BF14061A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:51 +0000 (UTC)
X-FDA: 85243066062.23.D9AA36A
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf24.hostedemail.com (Postfix) with ESMTP id 10152180004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pH5dYH3j;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790121530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UWLbjJuQ41hy5QZZXmUfMBTlvhCx61z13QEH9bWMQto=;
	b=drrp4LiE2j53Ki16gNCGb7eTM/F1tbRe5zk7jT+H7NjZ4+M6BwwA7hz4gTHsH5sEm+05qb
	ReFy9vlMwKhuaQJX3YYzwxG2DRYkICp7V9YySvGuDOPRUfNSCGpf10UcbwyKNEdp9ygBst
	OUQkAONQ0O9yskVWDm8aZRG9lSIpj70=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pH5dYH3j;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790121530;
	b=XF4hBhQfpIWNax7cld9ynJZqlDygwPjdkULNav214U0B74g2r+o/p8rPEcvko0Mav0EwdG
	C8Ot1o8E+v6weZ/O1AVAInAetbkw3c1iUTbe1LSk9JiQ5yRwi+FaILE5vCoUQNRGiyPTeM
	gOAxwdjSLtN6svBkQf2emVXaj2vgK6Q=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-52fb76ec504so3219231cf.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790121529; x=1790726329; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UWLbjJuQ41hy5QZZXmUfMBTlvhCx61z13QEH9bWMQto=;
        b=pH5dYH3jB08Nn/s5QRvaIt8w6nqcuGtOXnm61XI//OpQY0Q36339ONfYsOOQnczrLi
         8Q4AvjhyMcNINfLcG/3lC6rqK1Q+MCnvasuUWH1wC057nyhy1E4/2jjy/sHdUMzNB2sO
         9Jb+vv/ZcCEGSQB++vUddJst6WUQMddShAb45NBbVmh2fdDOTDKXF0U5j1OUXie4r3lH
         SoSaosDWjoyR6qAVmJZySeH4T3QdsQeC910+Y+ML3wr4YkF9yeHG9SiWrhnZTIWXUxRk
         Eph0a0jy77Ywb3kRLPQS45xaMIcCguTvxpWmunXt90T88AT4qGaHcjpwzTaeG71UO3R3
         mdmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790121529; x=1790726329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UWLbjJuQ41hy5QZZXmUfMBTlvhCx61z13QEH9bWMQto=;
        b=QbMptsVT1+xaBDZmWQ+1HdqLSs8ZIvAklASpJeuWPVLoKYWSYzrdB2lUbdwWoWu7a/
         nz/W2NP/z6okS/jwQbhOn3dg7lXwgxUZTJGxJALdAU2fls4Fibi4Y5BqEalExwNFw3f9
         wwmZWwuuqOLtpC7SVfZz45Ga6n3fgMGDALQI1BBBbdjr4Wo0UD3G7XHvAtX9bCA3wO95
         +MCj1lpApIgPXIX8QB/XB1IKkWi1lRcNTgVQJx8o1U+isJQWO0kYIU3CKxNfMRuTvrmt
         RxMGNiwPTdIhGZ54E4m6J+OSPuhHbg16PzU4uPDDCCPnHdNZKE56YbmgxMwN8JzDvbhP
         34kQ==
X-Gm-Message-State: AFuF++lq9A0GIcJl1lm2G1zH9ggDbvWPhoPRVOX/rTTQEdrE/gftmQ6s
	Wzn41HDmeluHjv4r5sOcB64w48JfuCphcACCbU2bKaR05Hr0vAvZAz8BLhxnnFc4ZPQMesX7R50
	A+/7LO4c=
X-Gm-Gg: AYBFou101WZaII4SJE5+oWak7Z0E/O8isCpD4YfP0ezT8MfIuNse+67MSVDZ3PXgoIA
	ZgOx3zfSA95H9ibwjJUAR75O2f/+EuqOtZFa7+pnhXiV9J3ObWPRs9Srt2qSOUbeG9zyfCMPVGh
	WL1bGKKoa0Hlt04ffsm41PeSdEiq7YwACGdQH82JKlIRPc+JPyUtlBoKvXALXILob0I90o2DY5k
	MHiiT6ApNDbyHDianFl3FTO2rK7ZW9Y43sEZkUDaX+4yYkuUF6km25YBF8pEvaEwcemV3WxMFLL
	Y/Ml7hbr+0trEbn4/UiO+hGRwR+1Qnjp8OrCo2pz3XcsaqanTaUvMSyYQJkejoaFavAcPSxnKrH
	97pnKuqmYiyL+7hH/k5oPM5Oo6VULqQQIjKHS2OiyVRrMwcHCLFSrLJhftZ3dsGxfnuXCC6pgm8
	jmYT7sFf+YFNWiE5xyrqG13zoKswKQedBEG0GA9CIQuU+PKVt+S0WtKeLydcdTr9JR1YlmvuJ55
	3FO6MULd6XjWWkpI1iMehG46LdwVzkjlwWW0h78LrhauItquxpqvWZnBcjiXQFj1RAk6TQ=
X-Received: by 2002:a05:622a:1345:b0:532:d202:328e with SMTP id d75a77b69052e-532ead6aaffmr19546621cf.55.1790121529209;
        Tue, 22 Sep 2026 16:58:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb3c6715sm8323261cf.30.2026.09.22.16.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 16:58:48 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH 08/10] mm/madvise: separate the PTL-held PTE scan
Date: Tue, 22 Sep 2026 19:58:28 -0400
Message-ID: <20260922235830.2350770-9-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922235830.2350770-1-gourry@gourry.net>
References: <20260922235830.2350770-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 10152180004
X-Stat-Signature: 53sbibc3b3km9ytshwadxunwxssd98us
X-HE-Tag: 1790121529-798411
X-HE-Meta: U2FsdGVkX1+PsVn25gNbVsSkxq8e+/YPz6KbO5RixYuHOgZa4Wf8a5yTgNXKk/7Nkf+Xh3fPFfa6iJwYhU5ge5Nfaxwx9fmbUXVClyx2c+zEOqpA3P/loNc02GkR/EPYm5wXAyjIwRJdz4A24r+OVIcVcCHRHO0+3ohAUART0Umkw+UYnRiiHui74jJsWRV8PxNpqRHaz3nfGZl0xSb2nAYePYNjYLT0i1lq9uAoJPvDUhclLQdXG8LKzYUXFCItTMIFXiaC53vC5Hn/MzoRT5I7BMlRJlM1jyUZ/wZkS+347lRPnXUPA/ztA9VUcgZiV5bW2afiAJx9Zd/Ys5UWJ6uDIEFF0i7Y3kWIsQlafwD5xeb3FmZLUSayMxTkGOyw/QqlJz2xMo3mT9WzrwQnvngvmgPamtzOBvu63PUu8B3hO2zuoIoev2gm4gtP6/0eCwH/HC5wHwTFHR0cyPHhV7JR1p8eZF+Lnj9p4uTIcy1+nfS1rbmSjmrnsz8PhzP6uvq+GkAkgTiYb1UkIfofSCO2/yhVDnknjbiv/pAEI9Dy59U1eVQl0X/kUSaDgVFF9HSSwuSjGmF9bnOvyNn/piF9Wcld73zBciYCQNDTAhd4Y5weze6y81RPWTn8JVPrdAXPEWBebO/kNerGObmBvX4odoveAUkYzuJIYdbjJutp+eRqLRMUvzGjkRwnu0FCMTlfxkCN3ZN7KiTOo9vLTK3q5SB7Zt44rZcn5ea3GPCDQ0NsBLhGQot7vevuMi9ByQ7W+UYj17J1JpH75zfLCe6eDyp9wxGWN8SUlLWALnWqWBEGOEThuo5NdlOC9L2Iw/LwN58GQX59LXluX2AtV45m7Kr/DvZvuvRkmFaipbtSOhYWwPnPK7dA+B3pb8fRIEg05/DszRVByO0GO1c8GOwmObuaRXzdfmFxazIR+okFUq3dnyhxIbd1GV9IG8hOmCHrctyYIUhY5XbbIa0
 7A6hJB/u
 +5qPROoBjtYMd5P4s2aL++pqXAnrvY9Wjoz7k2x2btDb8prG9hxWBTAldFXzE7XiFdJDPs9KeQRaY2CbuLPIcNAyMMRx9DedYZo4m/PO5MUuyPBulhPfrk8Y7glOxw4t8ecJ678z1MTIgf/owTGLb5PuHx/E5kz9APJvdox1zYRbhZkoHOLJv3KvmDi/g1wpoIs818r8t4T0uOSnbKXZ7yFQJjKNm6MV2LPnHrmFEL7NO9IyTOhrSTnhaU60n/FfYNBkuVkwI4OIODuDXeJumtfljJMDVuFLiPzpAxs8EOt8fCT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The PTE loop mixes its PTL-protected scan with the surrounding lock drops
for rescheduling and large-folio splitting.

Move the scan into a helper that runs entirely under the PTE lock. It
returns a locked and referenced split candidate, or stops at the existing
scheduling boundary so the caller can drop the lock before yielding.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 66 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 27 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 350b854ccc197..e3c3acfcd9b66 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -531,6 +531,28 @@ static bool madvise_lru_huge_pmd(pmd_t *pmd, unsigned long addr,
 }
 #endif
 
+static struct folio *
+madvise_lru_pte_range_locked(pte_t *pte, unsigned long *addr,
+		unsigned long end, struct mm_walk *walk,
+		struct list_head *folio_list, bool pageout_anon_only, int *nr,
+		unsigned int *batch_count)
+{
+	struct folio *folio;
+
+	for (; *addr < end; pte += *nr, *addr += *nr * PAGE_SIZE) {
+		if (++(*batch_count) == SWAP_CLUSTER_MAX) {
+			*batch_count = 0;
+			if (need_resched())
+				return NULL;
+		}
+		folio = madvise_lru_pte_batch_locked(pte, *addr, end, walk,
+				folio_list, pageout_anon_only, nr);
+		if (folio)
+			return folio;
+	}
+	return NULL;
+}
+
 static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long end, struct mm_walk *walk)
 {
@@ -562,36 +584,26 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 		goto out;
 	flush_tlb_batched_pending(mm);
 	lazy_mmu_mode_enable();
-	for (; addr < end; pte += nr, addr += nr * PAGE_SIZE) {
-		if (++batch_count == SWAP_CLUSTER_MAX) {
-			batch_count = 0;
-			if (need_resched()) {
-				lazy_mmu_mode_disable();
-				pte_unmap_unlock(start_pte, ptl);
-				cond_resched();
-				goto restart;
-			}
-		}
-
-		folio = madvise_lru_pte_batch_locked(pte, addr, end, walk,
-				&folio_list, pageout_anon_only, &nr);
-		if (!folio)
-			continue;
-
+	folio = madvise_lru_pte_range_locked(pte, &addr, end, walk,
+			&folio_list, pageout_anon_only, &nr, &batch_count);
+	if (!folio && addr < end) {
 		lazy_mmu_mode_disable();
 		pte_unmap_unlock(start_pte, ptl);
-		start_pte = NULL;
-		if (!split_folio(folio))
-			nr = 0;
-		folio_unlock(folio);
-		folio_put(folio);
-		start_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
-		if (!start_pte)
-			break;
-		pte = start_pte;
-		flush_tlb_batched_pending(mm);
-		lazy_mmu_mode_enable();
+		cond_resched();
+		goto restart;
 	}
+	if (!folio)
+		goto out;
+
+	lazy_mmu_mode_disable();
+	pte_unmap_unlock(start_pte, ptl);
+	start_pte = NULL;
+	if (!split_folio(folio))
+		nr = 0;
+	folio_unlock(folio);
+	folio_put(folio);
+	addr += nr * PAGE_SIZE;
+	goto restart;
 
 out:
 	if (start_pte) {
-- 
2.53.0-Meta


