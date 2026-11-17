Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9368D606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iUc+VT+c
Received: by kanga.kvack.org (Postfix)
	id 95E496B05BB; Tue, 17 Nov 2026 04:34:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936176B05BC; Tue, 17 Nov 2026 04:34:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8733C6B05BD; Tue, 17 Nov 2026 04:34:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 619896B05BB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:34:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E251DA038D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:34:19 +0000 (UTC)
X-FDA: 85444100238.01.A0E7338
Received: from mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id DEE61160004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:34:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iUc+VT+c;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794908058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCifWas0BpuNzXE9zytOMZSgJlGt46sndvW+hr71f/g=;
	b=lvABrLw/FWvvPRNa19mrI1vVOGj+c4dCMIprxisxTK5DvlgKTiqD+zX3EbcQRnXFnRlFC8
	jQvrmgJvgbmTX3zMkothwjs1cR5rrEbHUs029bSn0f2CAVRHw5jjuHjorLbfJI00zlbM2J
	VMCD+owOJ/x07Ompd66800oTipFybYU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794908058;
	b=QQJOEYbrKLy6WKYUoV8Aq3NCYj68sriR6EDvIy+Lza/n4InAuKk3oL90aUv97FOqb19iZh
	DnZ/Ly2bhqQaaE6Zx9I9j5D5BELpki2M4KcZB8SSAtcEKRKCfMytYbusIwqh/cu+i8XmY8
	ctV7JdppUAt6cBPzo29ETDqsgecFjiI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iUc+VT+c;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/MVFvmVwbUPNerAUsqUVWH7M0FSKEB7lNQ5SvFhDebM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794908056; v=1; x=1795512856;
 b=iUc+VT+cCad0NcfaA9TgdCftE6ozpTGWEIv7/+YaKHnz210DiuouJyGtzK7TrP3s2OLjeUVC
 iTulrF6R/6pQARfrXwEiRzfWC8U0tfvpnmkoACayS3mM7g1V+Sk8ACPQMOwEga3fwmlJ67KOVHy
 ZfjvWWtSC1sTFq4JH8ogGpZs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7d878d55f5a63e93;
	Tue, 17 Nov 2026 09:34:16 +0000
X-Mizu-Trace-ID: 7d878d55f5a63e93
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	lance.yang@linux.dev,
	fvdl@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v5 1/3] x86: hugetlb: disable default CMA reservations on 32-bit kernel
Date: Tue, 17 Nov 2026 17:33:57 +0800
Message-ID: <6866920502a4eaafd99a9e272df572e3a7d3da4e.1794907279.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1794907279.git.zhengqi.arch@bytedance.com>
References: <cover.1794907279.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DEE61160004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xs1hzwqu393jy8in7tfx9ax85wbnywxa
X-HE-Tag: 1794908057-650461
X-HE-Meta: U2FsdGVkX1+NTi9xIUx1emvWhpbra/vQiq9swIkvG5/O0wxKmaVLt8/kj8F3UFispX2YCE+esiLw/I2su22iWV0U//GSYmUFq2w6Ze077p61F3ncWWip6wTRc+BBZsVPGhHvJvZ1/FPrCuq4fc7wm2OfbGJuEy2TddM+lDJDALieDj1dUZlEkzcMY2JhAEBNlV2AJK3OKE0zMAkvvLaNZWT55auk0Z7IqVXsvPuel7y3Q5g3+ZHIP3FyKnAB/IH9s6h4sNrW3BnkZffMEnM+4fnoGdIxMo1f9jOrcx+byzRfUPkwTTvnF2blin6dZdBJnkeV6LiEmr4/92rPDdx4o1jJfoSuidR1O3HKIiS51XWOmUKjw85MjCRMpzXaGiUMQH7bII1d7cqM+48xsxIP5doh0XqqJuQ0UI2kd/3fLa5xDRcAcp3TzgOZvTlcy8AjFnTrBBsxUA0pCf3WsIk3V0gr5JhLbSK3xvwglBtcCSZAWO35gc8rhGnuL/Fxlh7oAsvyk0Se2jJKaNh3FmhKLq/K0btfnl/Dc06KjflmlBGZ2zrlLFEEgHIPV1tzZCote43qplgH4jJIjCKcmRXdMNWl54sLsKKrIM529TzztkIYq7gx/vNur5vxDTVWY2+wwLEsdFnX0IxPaTXvsSQ/yxxmjHkNEsYhjXqc+juqDQ/1qGbn3lKp88XvPSIJk/1Tmz32YoDTeOL6zAu7RaEEcy5oAWsWzgwnL64Jr93/+LEcTmGd12ePiQgr9coRwogKYVgfiqjtV4rxn3n56MH0DHE10T+o9asIaJsfs5hj+SbWVZ02NnS7rZ9PY2RurDFC3Zk0aHTjdeWHJSRXCfzuOO41SZ6c+ByGWxnbHXkM1irJUk6pPeeO8eKaEJXoysCNn/O/CB2CpolqDHiNVITPZCCGFaZov2MGC5ZLgxO7v+1hsd/Jofa1CSOVxVaK5U44vOhOdWczPo0S6S/9DF9
 uAWrHP7N
 46F+emb8gpMMlusCLADC/BZCPOeJZJqe2XTnYHd8iUP+0jb7VEb73+1/LbigCcPY9w36Mhzr6PzGAEx95d+Ljh87igNFX/+25oWgYxLspBx3n2XWwrgjMpc4tlldB/+JZic25HNsaGio215Gb3Bep6yUvgUmXCRWYZpYsIydX9x3WkmBUs5BYJcCnOmWpjNOdvPN3p3nsgOo8QHEtnS/k3/BzO2xZa/1wBOmO8nTR4LR+ykltE6j0nzXWcaA2DkQpoVqF
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


