Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D87860A382F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=UV38pVlE
Received: by kanga.kvack.org (Postfix)
	id ADD826B04A2; Tue, 20 Oct 2026 07:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A404B6B04A4; Tue, 20 Oct 2026 07:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9560D6B04A5; Tue, 20 Oct 2026 07:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BEE66B04A2
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:58:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09275160140
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:51 +0000 (UTC)
X-FDA: 85342858062.09.C34BFE4
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id 41B3BC0002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UV38pVlE;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792497529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHNwkvG7CIHMd+9+4XBKNgiQU2Iv+Eklqp5XAskVI5Q=;
	b=q5DOhG9xxbkZ7495AO9Ea4IucqusDdfrysAseGuoTdyJXyIMvK9xNKw6Bl8EBk/YtPIZG0
	3SLFTMzqa7q2M0eNEU0de99uzktuegfi1SsqyfrFINDVC7wnJ4fDvbnwsdtNhDlAo3ZX+B
	Z9EGGeszAsM9rhNk8QWnuqjkli7yJ1c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UV38pVlE;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792497529;
	b=yCM+Zft92Gqmgkomq+PYkJzC+nxgW/dcYuyVp/tljJMFsESve1Z1jTGoE57EUmk7bnQ1sf
	1WDMbIqMx6zCjMuz2OV3iAv6HLZoTfcoLdpFZWdtRwiabXhR47+AuX0FXBIH1LePIHIBC6
	rplWAJtg+fBP+Q3exNVnHJ3BeMLngxA=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3acdcfa2bd3so2614628a91.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792497528; x=1793102328; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MHNwkvG7CIHMd+9+4XBKNgiQU2Iv+Eklqp5XAskVI5Q=;
        b=UV38pVlECyHRt2a9cpz8qVqGk3bB4+GY1tW0yqBUE2gZjIcYeFA03LMPzs+/cS8sTt
         2ag+ReaGWKoHgULAfS0yHSRjDjZhiW7TcW9PWrBv/E7p6Uq6skFndxCT+cU4OGqypZPQ
         xM9hBSbVRMNtk8s+5CMUergsXEdWfoHJJtxRFOPrxPoR7i47oQLfoT+BkCXSJAlwpbuK
         7du4IJco+Xhw1N0heJ7qPV46oI3DoRFJfQGN6ylzVlb8DrBMinhJvCXnDQMiBG2Oa82B
         /mchu2DshjWIXBF3D+/ZSvIkZC0uGqTt/JRtr3uREIOF7tHWSz/XcH/vF+E/aVkoWnXh
         KVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792497528; x=1793102328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MHNwkvG7CIHMd+9+4XBKNgiQU2Iv+Eklqp5XAskVI5Q=;
        b=2SIICg8rXQaDf0PJNyijW/EM4AWqKJJ/PBUojfjB69vnvpNb8ardmEXyoNzVUbrNNU
         +4ACffl1bcgw0aSYxcp/JPUOFDdFnMvjSEH8GQwPwrMGxSqJ4yc8SzIE9Z3KBuGDRVV1
         oQJ/Wp5AIqbTIhJqohmQoq7+B6ufa7B9q8qSx0J4xyJ03CWAjHxsdJy6rdVTDtnvyWHN
         Fqz+5Ov32IkiQH2P06+QyYGKm3q+Zt/rhwdqbikyJyGgoGCSlxHDj+j0MeecRqehljNS
         5frXzR49fTHC+Dz+WdK4wMDPuxDFTBcFUX4/N4Nsg+VzVNHQ5xJqVum/QxhAwxkqRhEq
         UsxQ==
X-Forwarded-Encrypted: i=1; AKwUvByoR8GcSATZRGyTllw+fEmBZ9Mf2rj7vdU2H7TTII2+Mlb817yEAnrg9ZV2+N5hUG6LlrA9wMEoGA==@kvack.org
X-Gm-Message-State: AFq9FYJ4Zdrc5Y0FmLo6IA4tdq7aEPwv5F9mzj/YBLHC98zArTroXDze
	e2TlvgbyDHfSWvuoVbCyPB2uxaK2xfTMY58XhvwXkMOkbAsvWlkEDV1tTC2r42TdC00=
X-Gm-Gg: AYBFou0TAou/UtC3o41ZWi8rbU1UnxKmaaEeC5pgEqeTBn8NUU8rv9Rhb7OzHCxLlUn
	nWvnIAxJOfXbpPbMzOv9xIpoUNAaI86k1R99tDHXWp/LybVEvqNFtOZWVMlm/bsATS/dZRvGG3z
	B6N7XHUUUKrJ/3jUs1Lrigt2fSHjLTmwoRAnQMe2GGwj9mGQ3bCbyKUk5bchsdtbt5fI4xJoRN+
	pp51nX5BMCmK6mNnUZ64eK8cSPELAKQ1Uuit8dt7aHrQKXl+wbZfx130OnjuzgYwYNCeJT3c1FN
	8lNzaY/2swmoPjBV//XfI+CUaLFThoAyVrtn4aYRybEUIuhan/WvOMhEOLm/vb8UAlS1pLTi4v2
	bz2hPi2unmmoVo1BJeDOvWaki/IcchsFCXYZ3P831pCC6PQbVVxMrAyzpAQDbQDLeFa+zcklEHg
	iZQSR988I25Z910eKtCEAC30wo6W1jkO9QkSufSaIPYTAmvAUQ8xzGzqP5or9FR08kHke/U8pg/
	q6E+WxATW7xNIIi+ze+Bw==
X-Received: by 2002:a17:90b:1d4f:b0:3a0:ca1d:b40d with SMTP id 98e67ed59e1d1-3acef3ce33fmr9815015a91.55.1792497528082;
        Tue, 20 Oct 2026 04:58:48 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60274fc1sm3448095a91.0.2026.10.20.04.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:58:47 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 06/12] mm: hugetlb_vmemmap: rename vmemmap_remap_pte() to vmemmap_optimize_pte()
Date: Tue, 20 Oct 2026 19:58:18 +0800
Message-ID: <20261020115824.823278-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261020115824.823278-1-songmuchun@bytedance.com>
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 41B3BC0002
X-Stat-Signature: y5z9b9wcdbf8oetaa6xpy39rc1aa8znp
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792497529-559295
X-HE-Meta: U2FsdGVkX1/3LZnpwUorLRrrglIhBZnET7WLH/6Ow353iR3JDM0B4UpklXWZLjoCyt4uLf4oJRC9TYYKC3K2BN6cNWwRFcDh90QD1uUlg4wF0oPNlbMc6kXaiLYqqXlsDjl313u6OuKhNpOHNLumB7xy3UHEc7ZJviwzYvpEDumBolElB2thDkTEITkW0AvlGl3HytUFnAquqGEfba8wj2Wi+EWQtOPfKWMiPWZ6L54RJb/VIG+e6A4veC38EpM+T0poabrixJFBz2FkqybKYZJvxm6zfC3NSiHS6oKVhvRIzZrrutHA5r7KQam4iCgHSgjbiSMTZhi2af+zdg2qddvq3Xe4/6+g11fEcU93+0S51g/ueHPaP2UmJwnNFiDYNhiGQQPCP9jF8ildIe3nBRuyq+cSTEM0IXXmSsFRaB6zXRTp4EvoYdl/wsrDgCHgAa4qyesLUMVL70Rg7e+fNvL3zfpcWMLGSf078WVv/6m4xeyZAmAcb/wd2n++04LFAOfAN9pscX8YYXjxISEpE6mdbRx6uNHaWYt4O4cvgU09vgEi31nWI+3dQmU4/G5cGc6+Ve7ijEE8didLjt6V9BRXCfnmkQtYgz8+a84oYp8s6FKsaMWeTpK3243pCwFEmJHtP86HYcPT3BPCIPoACKtbjKBUxPjHo+CE6pfAEekCGo/0JgZF5Gq2uHN9Kt01Zdu2Pz2XtlV/iS9axOJDGKHdu2EFyszlfj7dB0lauhDNixg5s6fKODumb3WtisrCfEZr5ASDSoongJiEg0KRhx8mcepQDyST8IvnSh7khIEpTW5EZylXEJOHCGC4kjvH63cfsfJCmYqwQ7AF4VzSx6oKYV9pv9FaFv0bXH2o1nAu8jS5/fN/4WZVm0+ERHTjhomTGNPDwHTcNL4IOXJ2GUiMNMsSani5H2LdH8N9nDtRglLM31R3CpQlHJbAAy5VYrpMHI/oHThq6NTEGlf
 isCoyNSj
 7N/10pZP5ug2MdOykAb2fg0cnTZ4suicjWpCbBu+wkpKvEeCay0pAiz58kaSPpp/Zs7UWI/unj1lADC2qsYe4rU38usUbiafaOxQRAcQ+1ldFq0wbP9ZUkrwj6qbwa5YkAPv8zOqTXKQJpHRqU3IXNBNlRWsMzaoagagsbo8eg7+cfowqTRpisphZ5t+FeidcAphk+Ff09rJ3Pwz8qurg9tvbdeMk0UIfqRes4eIpn9Qpu2Y5p5ZNbcDVsy1F1ks7Z58l0v/dYO1JwvnPSj9vyi+5Zs2sWtcaNh1ltiyV1CMebz4JmeoSDlcjHCbx4HzWlI/frwexaYLacAdvoJLSa3EqBD23C0F1zR2PLCBIlxmkaAc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Both optimization and restoration update vmemmap PTEs by remapping them,
so "remap" does not identify the callback's role.  Use "optimize" for the
optimization callback to match "restore" and make the two directions
explicit and consistent.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 9ea961291b3a..18b72d553955 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -213,8 +213,8 @@ static struct page *vmemmap_dup_page_from_list(const struct page *src,
 	return dst;
 }
 
-static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
-			      struct vmemmap_remap_walk *walk)
+static void vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
+				 struct vmemmap_remap_walk *walk)
 {
 	struct page *page = pte_page(ptep_get(pte));
 	pte_t entry;
@@ -301,7 +301,7 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
-		.remap_pte	= vmemmap_remap_pte,
+		.remap_pte	= vmemmap_optimize_pte,
 		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
-- 
2.54.0


