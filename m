Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F425606D810
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 10:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=auqiAvlQ
Received: by kanga.kvack.org (Postfix)
	id B78106B05B1; Sat,  7 Nov 2026 05:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29F46B05B2; Sat,  7 Nov 2026 05:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3EBA6B05B3; Sat,  7 Nov 2026 05:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 885676B05B1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 05:31:15 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 115DA4032A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:31:15 +0000 (UTC)
X-FDA: 85407955710.21.9C262C0
Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	by imf03.hostedemail.com (Postfix) with ESMTP id D3C942000A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:31:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=auqiAvlQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794047473;
	b=X367/XvKu8FEk8Pt89Y7rgjgOw3Xbm4x/9EoJOpY0X746vvvk/Q1DVru/RH5dPvkE9x1cY
	qowFllQUtEqkycbS8Oe9IFrkHkjTtqnhQr9xxND0nnoezwYJR8+SU4rNQ6gFFHz73AG8cG
	AukHp6fbs5dH4vCR2ffwXAzSyUTWTMA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794047473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCifWas0BpuNzXE9zytOMZSgJlGt46sndvW+hr71f/g=;
	b=dSbFxVo+sR/eUKzubt9B/AH7PPBSf8gk5en0z+zF/ipO9f+pkF2oG4+979s4HA9c6ySDLO
	DRC1X8HJUYnREPPpkaIR2hCqTs9+Vo6L44qk9kxZEOOrYLUBrTOHxhOXoc6d209UfVrTzt
	bkmfXxTqgJj+VlF2pPqNFaz9NDTABSI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=auqiAvlQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/MVFvmVwbUPNerAUsqUVWH7M0FSKEB7lNQ5SvFhDebM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794047469; v=1; x=1794652269;
 b=auqiAvlQwa+6XyJFCihWXNeea0nlZna1fNdg7wXuKwV+FljBmPEhFrL3gvwX2VEv3XEJHoOX
 XzvSudGAwDtC5NX1WqCpX13kl4o0Okp21hODeasPZdyU9e4HNAvAbx8Q0MhjIOoja9bFRMaOySN
 Q5zlFzBy+zNX865bW/2ra1yE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 59b71af0a5b0d19c;
	Sat, 07 Nov 2026 10:31:09 +0000
X-Mizu-Trace-ID: 59b71af0a5b0d19c
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	lance.yang@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/3] x86: hugetlb: disable default CMA reservations on 32-bit kernel
Date: Sat,  7 Nov 2026 18:30:45 +0800
Message-ID: <94ec966eb5be064108a5cbdc8b72f92f8dda6724.1794046188.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1794046188.git.zhengqi.arch@bytedance.com>
References: <cover.1794046188.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D3C942000A
X-Rspamd-Server: rspam12
X-Stat-Signature: wcwgm9jmqtig3jab41fjhnueqtiybwnm
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794047472-237522
X-HE-Meta: U2FsdGVkX1+3g4hELOutYHknu9U4IzABjNH2C/+o35bYR5jy23idyQ8mMHJtK0qaq5Jo59FHGCCAnGHEwH+eDXL3E0RNxuRsJb31dMrDYYTBKmHhExrCIJVWnFWG8WaaAdQx3HV34k2yMkdexbwddfeo157jIzDu657E3STD2RttYiApvcvgGJXLPaWUgd/u9a9YQqtdHZCVJQsCjmQXFwphP6DuSqIhUk8BKw22uQ0vB7/voZJHRQB1qgJkclIhwJKbnorh5ylC1yPf3v3E0I+M1MqzMNKGZsCl4Adf4OaJLcJTTzPtWAgNv6Ztw9ZJTkvh+BcuOEVq4gBt7ptxlaxH5rondqaadqRtHK97c4cxbbUbzaZD4hpctUsnKDQh2LIbBxYwPYeTGceSdU7f6HI0b/Bwdw0wjDDYNMync3KLQNcCc4957CNvbkKo+1mrUDttQI/11XABC9MKL/YxVtYzqzYKuon1GNfVUb0uTsTUJLEM3QaGgDGeJhr7t6sdLwe/IAdewIIFQOq/2A/MziMCzJobcXdHrsiVuJATGkqADMAUTE2BVLLiJC5Fhyf1fU9fa5uSEwChf73W0XvQ12Q+mMRB1buelHlHWfcfBMeMLUZMs1WzOAm63J0cUuwVeNHfNRPo11IuCMuLmLnEEQOVl6Qpj+AP+2+FBw9FWIotKUxYAGn1msKe/qGzo7j5Ctq79lZqHQ0g0q6HS+91iNWI4rA+anzgnu0w4hP3+Y0ibFTSeMxGz/rN23FPP5iZqnc0mMGuZtt1kDY5WMlCirCTJVgNUFU0qEN3KetB5ORq5ws6PqIiPH68LDu+f+WHFa6YTQc68yEt486LA8WZWCoSm4wsrdua3Hfwf5oYO6H/xZeGmDMH/vkmYEbA9H5TxWpVuc+161zuDiIAyLw2bAdMOpGyPj659o5mUlVcp4TbjObxkGSBI6Fh8Nm3/gRNtlqj+xCdXoHwTdAVptL
 v+Zy3bLV
 zEhBJaDHq/9JyY1QSlNirAtalB1c+Ff/SD2gg/3xBvWe4vgeh+6+wFuIjLuKISgyUhM/WGVCO4rnVg9Z1r80rOPmOTU7pgmxv3S549H4Ybt3luj8anhNZ6FTdUoRzYh/q61DI/mMhLAbjMlcTNXS1OoofmOJZKi+gC/MU9S+FT33FNS7s24jq7Rf+mUc+26nDSJKO89qHwgfNNOWw4va4X8CpIYlV12q1taM1DReefQbMfRNr/h6TbJvpm513IWnK2YVNLb+a6JQanI/1B5t7axt9TCY7ENacvMtTm7Mbp9/w1JsQMmGr7kDVK3wklTXRA845SAyHoa0ro4Tz+FbFPE2ut7lZmaFc4BFr50If2qJtY1WXXhkm2PzkZaZPxSPJiANksNNXwhBLVPDRcik08zIzfxqaQraC357xbe0xAAZx9dw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

A 32-bit x86 kernel can run on a 64-bit-capable CPU advertising GBPAGES.
arch_hugetlb_cma_order() checks only this feature and returns a nonzero
order, although gigantic HugeTLB support on x86 requires CONFIG_X86_64.
Specifying hugetlb_cma= can therefore reserve a CMA area that cannot
serve the intended gigantic HugeTLB allocations.

On non-PAE kernels, the folded PUD_SHIFT yields a 4 MiB order, which is
equal to MAX_PAGE_ORDER. With CONFIG_DEBUG_VM enabled, this triggers the
VM_WARN_ON(order <= MAX_PAGE_ORDER) check in hugetlb_cma_reserve(),
warning that hugetlb_cma is attempting to reserve a non-gigantic order.

Require CONFIG_X86_64 as well as GBPAGES when selecting the default CMA
order to avoid these ineffective reservations.

Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Cc: stable@vger.kernel.org
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
 arch/x86/mm/hugetlbpage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 3b26621c91286..70726a99ede7b 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -45,7 +45,7 @@ arch_initcall(gigantic_pages_init);
 
 unsigned int __init arch_hugetlb_cma_order(void)
 {
-	if (boot_cpu_has(X86_FEATURE_GBPAGES))
+	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_has(X86_FEATURE_GBPAGES))
 		return PUD_SHIFT - PAGE_SHIFT;
 
 	return 0;
-- 
2.54.0


