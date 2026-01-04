Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47FDFC2A062
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 12:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6FFF6B0092; Sun,  4 Jan 2026 07:27:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48FE6B0093; Sun,  4 Jan 2026 07:27:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DE66B0095; Sun,  4 Jan 2026 07:27:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 82FA26B0092
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 07:27:27 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E0C4C30EA
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 12:27:27 +0000 (UTC)
X-FDA: 84294206934.20.85486C3
Received: from out203-205-221-149.mail.qq.com (out203-205-221-149.mail.qq.com [203.205.221.149])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4B70B20003
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 12:27:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=EBLWEzFk;
	spf=pass (imf13.hostedemail.com: domain of realwujing@qq.com designates 203.205.221.149 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767529645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnoiPqIKCGT3TvWDVfAyWO7UyS6E9qFjisMWZRge56g=;
	b=B2XB5sJ6lfdsY7khl4sNUDLfg+zUnAvEu6di+wN0Z5Hnk0ftJ2MVFefCk/gDw+PoP06i+Q
	mfWhemi/XzRCrZ6hkV9pyn+U+UKAxNY+Ha/CvyzdSqvEqeoaG7WZMrA4TJyZXqV2kga14Z
	K786ofMj0qY/YZFQBY5lZLWQ6WY5zZ4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=EBLWEzFk;
	spf=pass (imf13.hostedemail.com: domain of realwujing@qq.com designates 203.205.221.149 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767529645; a=rsa-sha256;
	cv=none;
	b=FjUpgU7L0GwdIRMxJEnbUaeNIanWURXoQCvpUKgUistK561raPrG0L+T4zORj7UR7F1vec
	vGPOPd3oBLJvfV5guAW75x/t74m9rl3RCnoonluKiPjwL0e9fgnOCDfll5EJBFAPJ0EFPw
	0fg+nUlPn4UemKSeDuo1Y+8aEesLBHg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1767529640; bh=XnoiPqIKCGT3TvWDVfAyWO7UyS6E9qFjisMWZRge56g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EBLWEzFkZ3MD/vPXF5AORxa6ouNSaRm4meai4K86YoybaimhIPjK6xcDddz4Sg10V
	 ArJv5C4RcVO89Z7/sfxjX9XiRR1Dig1arrlzMbzkBNCpwQOvZTTtwPJVvU4dYukCRh
	 EsoDXppFIX6TClmeLXBp6C0vVE+x3Z29AzN+WAfQ=
Received: from localhost.localdomain ([61.144.109.141])
	by newxmesmtplogicsvrszc41-0.qq.com (NewEsmtp) with SMTP
	id 6D11CCC8; Sun, 04 Jan 2026 20:27:17 +0800
X-QQ-mid: xmsmtpt1767529637tjn4o49cv
Message-ID: <tencent_9DB6637676D639B4B7AEA09CC6A6F9E49D0A@qq.com>
X-QQ-XMAILINFO: MMwjR1C73eIsZ8C984l31Xid8Z8Nty5k0BEMSfL2KaCwIFJ8BTPvIw92TXjjTn
	 fr7HQPhyVMl3q6H6SAPCg62ck3uEH753h6B/Vu+rWlbg9zul2GjQan6mpmBKApOUMZC/1Px673Wp
	 MGlGxzjRreaOOx60wDJEph76rptxRqBiwX6uJi9mmXsZhEJm4Iap8XF1ve5M46dFj004eu0Z6x96
	 9D/4Xre878I80YDtdf386OWO20vmqUdEMrRts4imm3qqdG8E+qFYf3/XHZonL74Cbrwbq7GWlLFU
	 +4uVQladPMfzpHXhfXrRx/KG+Mzu0kPIKfkmxN1Zj2KjuiJF4tKqkMOdARQfJ8DBBBUzIp1gsp5B
	 i+45bdKZcmuhABC+30Z507FkSpgWMmCH+dalPRqySI6CoCRDFcVcGkJXhTBKLN5YTjh/FoGTDODU
	 WAxF7aOqL+xE78J1ybKtqVQ64O9MRHmiXzBI4Jbn2Kl5vh/c4mjOONZtWe4XbdlqkoNsvlaFfQuL
	 SrVnx9kkJGPfW2IfLzqyCWFzwyfPjpT4kNwqqhqQJYKAiXic0Mz0TJZXSqxQOuN7FDTprVjsoTN7
	 VOX36hltNu5cApwQ/qQqkt+RITuwc/eJxzxD4tRY0Zbl2i9J/CKNqHMAPAQS/qyf4YFfgb6wes/x
	 ESGzg0dJ2DzZnn1b2a/qMGH5W8rxpaKjJqcf3GhSexmlIsAPR0wJz45MSgkSjblxx83LC0EplIKA
	 vgmNOSArsn9d2OTV62im55N2gM4F0yhCGdVNjxD5TtNbfIB0l2E3ghZ3rnC+dsojMtGfQ15nyi75
	 AtLZIg29vIDaQL4V/LJrkyxO+14zIGwVNQVeu0DX4XCayFvtfqpNo69dZgBZz9Sl+KTpI6WblfIZ
	 eY0g+xCYyoqBQ50K1iaSeTnZ24S4hESOBfrEtJQ9rpopdvzAFyt/dLdcXuoTm2A3IVH3YVELpMT9
	 1YrGS2tTfd5ovOPjx6tk6EVip5tjOvHTklSNz8g+h6SqpEm1ujzaNBcjdFJbF/v/10TzkK4tk4+T
	 mkUr9xrGH2F6FHzPhD5GS0pp5/OYd/dHku4FHJqPHhEM1l6d6c
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: wujing <realwujing@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	wujing <realwujing@qq.com>
Subject: [PATCH 1/1] mm/page_alloc: auto-tune min_free_kbytes on atomic allocation failure
Date: Sun,  4 Jan 2026 20:26:52 +0800
X-OQ-MSGID: <20260104122652.1219035-1-realwujing@qq.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <tencent_C5AD9528AAB1853E24A7DC98A19D700E3808@qq.com>
References: <tencent_C5AD9528AAB1853E24A7DC98A19D700E3808@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4B70B20003
X-Stat-Signature: xbncu5xeieyfjhq8dp5x6g8t143qbkew
X-Rspam-User: 
X-HE-Tag: 1767529643-581903
X-HE-Meta: U2FsdGVkX1/nX6SsylKokWLo5CilERWrixqgzLLtcAjjxUkdkrqzuXxovFHLvkytlFD54F3ZIvWQicPad9lXLC6N14fQeFvQPbhE8MkH/Z0PbQ7fLtbvZx9ytdFoEyiyvQ+hGdyx8CfPGX8tc+15JG8agE6qPY2KCrPXEjRFKTQ6ooy1myCY//6NxiiL5Z/243vkcmOkGsR9ci3mCbbNSqiBvxuGSotmOZZDWm1S8sNeOM+q5R6tpnRxMVjd9a2/RdD4RyTNDOxnxD2sEyy2kpSTDjQqPTiM5zsm7ezc9qKt8RAqzNulBOc11FgtGi3Ohzj7op5vJ5KRgp8Isu4l837DHMs36aNSMn22wnBh9Jn4ufVhWCYaNFLgXR7yrjHZKcnklWw8+4M+MpBZB/yuoWFcUEb7pTaHiwvq+ljUbvPbqelCCJkEjaqzFG1Sd23gI+/bdyv/ddqzKWXc5y3aW24n9WnfZK0UNY2KcAQTxM6mRZtVCXuHT9VQtutQ9ypQ7YJ7T/ZZ4zJiB2dPu+H48DEeOIKhJnEbwN+PgN5nMwv4iGe1EjoXNkN8uztmIIBzScua7cfvee72RG9ipSBvmQ716JkF+/ISRMJRWCEJt/Td97Q+JpaVbGcFyKtM2eQ5HYHtapQtemIRxSQebNX8gf2Tlm1NZQg+ihroMU+aRe4MaYj3ICf3nVHlx0xWhIzCdXNPjbOKUdKJzcJaAuOYI6yr/cpKRoWlD9tt2pQzU7pHwdQms/EdamwTFxtRWtsyHpLKGzGwcRSW24a4IHDOdPi8IJdJ9YgL7vpfI0ocfxQWG1OWTuB/Mhha7bVVW1fDsOv2VZvN2XiliF7g/Se5v2A0fkzR5AYdYAc/1o7zl7Thafl9afhl2m2P9i9Mv8hwXNvujirVa/lVF2xvrR9pY+m5Jb6kafeZ0JluZ4t7l2W/MZ0hjHCUlZ2mmrgvVLYpoXqzssLT9l+8MfSYP72
 JF9B0rbE
 PK9tNQBy/C9gXZARtR78LxTIXQnUCUWQGVIYuGlWPZMYoEl78a7CqPPpbv2tmQhnRWGuOugkreBSFB0mqEpaY8bGeVctqhTr7JI1xVzhc2hGnkCGKQW6L9sxkljMylQxGM0+EBgnTh7WNBkLfkD3AqgrPeNJGTTnhsWjQHNv9HEQScwgA5Vh8YdBscljY2IJ70R/VCgE0pauqbWEsvqFiOoF1vxnI0sHX4N6wffLMzyVVYt0J5cL/ZKlR3oSBkXowvEqfr8LIW9XDpKBO4BSbbNynXxTE2T2D82YEJlMZl8Ernafr2s+Aq6Gcfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a mechanism to dynamically increase vm.min_free_kbytes when
critical atomic allocations (GFP_ATOMIC, order-0) fail. This prevents
recurring network packet drops or other atomic failures by proactively
reserving more memory.

The adjustment doubles min_free_kbytes upon upon failure (exponential backoff),
capped at 1% of total RAM.

Observed failure logs:
[38535641.026406] node 0: slabs: 941, objs: 54656, free: 0
[38535641.037711] node 1: slabs: 349, objs: 22096, free: 272
[38535641.049025] node 1: slabs: 349, objs: 22096, free: 272
[38535642.795972] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535642.805017] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535642.816311] node 0: slabs: 854, objs: 42320, free: 0
[38535642.823066] node 1: slabs: 400, objs: 25360, free: 294
[38535643.070199] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535643.078861] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535643.089719] node 0: slabs: 841, objs: 41824, free: 0
[38535643.096513] node 1: slabs: 393, objs: 24480, free: 272
[38535643.484149] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535643.492831] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535643.503666] node 0: slabs: 898, objs: 43120, free: 159
[38535643.510140] node 1: slabs: 404, objs: 25424, free: 319
[38535644.699224] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535644.707911] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
[38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
[38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
[38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
[38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535649.655523] warn_alloc: 59 callbacks suppressed
[38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
[38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1

Signed-off-by: wujing <realwujing@qq.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 mm/page_alloc.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..9a24e2b6cfbf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -30,6 +30,7 @@
 #include <linux/oom.h>
 #include <linux/topology.h>
 #include <linux/sysctl.h>
+#include <linux/workqueue.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/pagevec.h>
@@ -3975,6 +3976,9 @@ static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
 	mem_cgroup_show_protected_memory(NULL);
 }
 
+static void boost_min_free_kbytes_workfn(struct work_struct *work);
+static DECLARE_WORK(boost_min_free_kbytes_work, boost_min_free_kbytes_workfn);
+
 void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
 {
 	struct va_format vaf;
@@ -4947,6 +4951,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto retry;
 	}
 fail:
+	/* Auto-tuning: trigger boost if atomic allocation fails */
+	if ((gfp_mask & GFP_ATOMIC) && order == 0)
+		schedule_work(&boost_min_free_kbytes_work);
+
 	warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation failure: order:%u", order);
 got_pg:
@@ -7682,3 +7690,28 @@ struct page *alloc_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int or
 	return page;
 }
 EXPORT_SYMBOL_GPL(alloc_pages_nolock_noprof);
+
+static void boost_min_free_kbytes_workfn(struct work_struct *work)
+{
+	int new_min;
+
+	/* Cap at 1% of total RAM for safety */
+	unsigned long total_kbytes = totalram_pages() << (PAGE_SHIFT - 10);
+	int max_limit = total_kbytes / 100;
+
+	/* Exponential increase: double the current value */
+	new_min = min_free_kbytes * 2;
+
+	if (new_min > max_limit)
+		new_min = max_limit;
+
+	if (new_min > min_free_kbytes) {
+		min_free_kbytes = new_min;
+		/* Update user_min_free_kbytes so it persists through recalculations */
+		if (new_min > user_min_free_kbytes)
+			user_min_free_kbytes = new_min;
+		
+		setup_per_zone_wmarks();
+		pr_info("Auto-tuning: unexpected atomic failure detected, increasing min_free_kbytes to %d\n", min_free_kbytes);
+	}
+}
-- 
2.39.5


