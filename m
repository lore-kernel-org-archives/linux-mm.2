Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19072606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=epfnCIBm
Received: by kanga.kvack.org (Postfix)
	id 05C0C6B05B3; Wed,  4 Nov 2026 23:08:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0339A6B05B4; Wed,  4 Nov 2026 23:08:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65556B05B5; Wed,  4 Nov 2026 23:08:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C174C6B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:08:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46E6D80843
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:08:16 +0000 (UTC)
X-FDA: 85399732992.21.164F0AB
Received: from mta1.migadu.com (out-213.mta1.migadu.com [95.215.58.213])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5C486100005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:08:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=epfnCIBm;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.213 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793851694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GrZJSLMSTaY7SkaFZ0uijDSfH3F6ZTWMMqOxToPn0s=;
	b=vvXx4BMeSyLfqhVBq2b3qibwSsI8O6lK4PsdTmsxqOPCIBnpbwo/XW5mNhwwij+yJZ7mt3
	g79vJel6A8VN7X7afS4GcWvgtkjTuBPUHCFSgoyBedjVp2LSUOhtpZlFZveu5nMP6t766z
	JBUlX5SA6h2eomqE10/Nfx88EBtVh40=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793851694;
	b=Ji4ojFXDHsYv8KQuYcxs/KvMaowAvZUm613n9Juaqebju4sF+pQvZA2iBzTlLv9dBIgnVc
	6imrDgtgw5GwFDXtIDT9cIVch1lq9c10sfpyN+42i2ttnKYdGTIFQMnY4LnTgo1VKLuaL/
	zOQyeE/r1KRocNiIzeIYRdMd628SHmc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=epfnCIBm;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.213 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Alk5PnLb93phS/NG/b1nkAJfppoj1kE8R+vJuoaKDh0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793851691; v=1; x=1794456491;
 b=epfnCIBmVysud4BWPuiYphnUHipz+x+hK5PFhSK0kbOjAhVRnBUISTQhTNnjqHTu90uAoC3z
 2I8LmQPXIfv825QP4NQrjTmuMnduc1ghTn9nyJ8IZZXUiTpq2xdxvImJh1jarrsFsKo3kTTmjAH
 6uz59nKYiczWuoihtWQ+CcZI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ed0532ae4a2af54b;
	Thu, 05 Nov 2026 04:08:10 +0000
X-Mizu-Trace-ID: ed0532ae4a2af54b
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
Subject: [PATCH v2 1/4] x86: hugetlb: disable default CMA reservations on 32-bit kernel
Date: Thu,  5 Nov 2026 12:07:43 +0800
Message-ID: <ece5aebe95f6565046d17ffb738670feb3202943.1793850539.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1793850539.git.zhengqi.arch@bytedance.com>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5C486100005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7pr3hyxrbkofqoqxk8j75dmj581wujit
X-Rspam-User: 
X-HE-Tag: 1793851694-29007
X-HE-Meta: U2FsdGVkX18To5/7rln7WYv9ZsLhqyh3rkOrZYvvZ12Ymla6w/yAHoeu0F8lIjix7VTQpkD2W3hOckgOYQgIdRmQiiXA7bX6SvgRIU6jVhu+oKeZFUkDIuEGFPZP7CEFO0hSnWRJ7mBKdWotQXbGKOobDbl587Y/jQlDKpkpzDU/PZUseB3ghQzEgyWs+bCZ0yW60JPH7WLTDEEjvuAI+UTjMME/WHuFKnGoZkpAE4GptbBtEUaDBTS4pPTfWHRc8+VTyG1X8yy9KIQHqGAT9b88ZXZQWTdB0X31MQIuIyLmN3lj7xSWsv/dS2cMi4o45eOVV9h9uTR0ayGZmhLTS7hweqOoNkdwdB+0Q1QT/u3095ZBDvtKzc5WRqjpVqcXRRq5ixHZbnFW+b7FcD/fEL2tH3obnGRsTg9fgebMUFHahj17e9SwguafWLCiRkLQtjhURYmQ75N86kTT1ljokRT5Mn7WWLwKUJipogJICkst8JnoeFGjn3KdA9QByU+tYxa6AXomFEZji4a6jvRfMIP4MoifIYgndVLBr72clNJUcsT2EF1Hz+L67b/ZO+ILZNIJ42jJD/kkvdt8WuFu+OmROxDQWjeMjdgfH9MMm6+/+bKLgey7CfHTisB9vJMJUn9ji1y/vkrXVr7bZ78zf94FGrWEkWqB88kMH+hiNg0NY1QLrI+nAcyufi8BVdPFc1/pj6OvoQ137iEXfwicZ0s80daafCnI2tJ2IYIVZ3NVQ2gZcEfWqN0PrygpvAI5r+z9F4m8SNEaI0PK0V0r1H8h7zCZQWpGk1sLIfs/z4eTOF9vcjF75LlZ1DqPfB2I/tOmd0iKE31bF/A1+b37WoKNZelg5hhCF+qKn95ty8PaC/TJSElrx7tniT6CNr7zDg4Iy58QNJcupe3YlwoGrw/L7ck1r/I/nOuG9LCEDSbQXFdJk++Ic4UG9KC3tkAWW0YhSKYvyzdW9lPFHP/
 mCfIdH9A
 VtJVx3gz8kFEQQnKA6dtqNG9b95ervGXDE6rM93h5JOmz87njilx4+s1anUWvtUgJzQBlbPJXgmzB13oQmff4uig7qGyFOHthUJMCdDJD6BrTdVyUdzg+7XL6uSrKPSzRQUv8SeqUQLREZgZnWem19II26tm/F/v42WqtkrRuZ+DNLeJ1LwcECqY0PLL6ptSNgv13+NyqcULByhMhBbxfWDLoFPNDvp1/ufUaXCjJQyRlg/y9M/GvpAcSGrHzBLgpCBHZ
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


