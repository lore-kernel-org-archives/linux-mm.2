Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB6DAC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 04:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C5E66B0088; Wed,  8 Jul 2026 00:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8769A6B008A; Wed,  8 Jul 2026 00:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D566B008C; Wed,  8 Jul 2026 00:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5352F6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:19:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C0BB340661
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:19:24 +0000 (UTC)
X-FDA: 84964305048.27.E5F0402
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5FC6540003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:19:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783484362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rdCivmo5QOwW9EeeXS6XqTWHuo649s8NFVMDiBCUXF8=;
	b=Bapa5dF9pVDYrAQkP1DKL2mSXuSDfpJrTugc37qjk8v08NExYcZBGJgxURh40oDnz1xtkn
	xS2mlPdfSdmZLAndfNlGXovey12ArIPDxIazwxN5yymAvglrNpMXO39K9PuWO1ASASLJIL
	ghyeAnXTGLqBigm4Jx5AOsaWO7JxXKE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783484362;
	b=oq7HLpwFx2EGMxF6hj+zdF8HV9XcuiMjHpvo3XOiwuDBjr7bfZt/zM2Vs1SRaZPE8YdoU8
	jg3yIDoZ+gQadpqs3fM40WDxXPwcHsCBkAEOmGMPoDqBmHyFjmDRIuB4AJgS+4VxFIba/w
	F4xb2YcGKAAABt31WwY30sGU9nJmSN4=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gw4c62z8Pz55RJ4;
	Wed, 08 Jul 2026 12:19:18 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 6684J7bE076631;
	Wed, 8 Jul 2026 12:19:08 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 8 Jul 2026 12:19:09 +0800 (CST)
X-Zmail-TransId: 2afb6a4dcfbdc07-4daf7
X-Mailer: Zmail v1.0
Message-ID: <202607081219094603lvrfl0HWd-31cAGrp79l@zte.com.cn>
In-Reply-To: <20260708113819554pIZuGzMiKKrOwHvNXFBZ2@zte.com.cn>
References: 20260708113819554pIZuGzMiKKrOwHvNXFBZ2@zte.com.cn
Date: Wed, 8 Jul 2026 12:19:09 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIDEvMl0gbW0va3NtOiBJbml0aWFsaXplIHRoZSBhZGRyIG9ubHkgb25jZSBpbiBjb2xsZWN0X3Byb2NzX2tzbQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6684J7bE076631
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 08 Jul 2026 12:19:18 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4DCFC6.002/4gw4c62z8Pz55RJ4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5FC6540003
X-Stat-Signature: jfrsswt6q3hx5af7mj6unhue9szfxb65
X-HE-Tag: 1783484361-515825
X-HE-Meta: U2FsdGVkX19sJkZlZNCOIY74dZ/OVs9cLmVNy1Cu9T/XULSeIuNI1w/jtH+YFz7FW09gJtI/Z62MIcMZMVLYeoFtqVM/hKqs/RrkqE+zQvWYkabfGv78q6dmAtjmjr1rJFszogbAIPW2bnRMHBI/Vy1EefChk/1NkQuoXcmlRlrDTv8J8WLdlvg1ENInKxv8KTgW5bON6PXK205i/htkpin4bLee/EVPIpENKXL9x7cVnTPmmWH76/4Up4EXQkvET8a43XSMPHtDp56u3LySgEAqy9DyDM24YcKx+GEhqpNWIiwY0YnvyB38NrHirXzoB2ykoHx8+nWwXja9CEfguG/tDDjNKHNZ9U/+e3bAz59C749jujz/rED9LQyq4f3pprB2fW+crU42gSy0i3JLSe4qWhS8SPm8l3+QTcecKg/DvSht6/aFIUL91yqlQZaUHNTbKTzAEa2fnv6wwvJh1D3qAYfjSuKsv6nHNrj87WeWQB64a9Nsnmnx7TYRgUWUvEcIyo35k1fnAJYEgZuNOaMgNNNFaxfvGJV1vS+jQMprsAQyGsCUyr6ertHJ37yp+unDPZuYq5eEQAsuPa9baSpfbNzQ7s3dP+j+JUOqCrMul1pFUSbbrMYvjhefzQpH5yyRL0YRCbzWfentDZBVKtl/0s6B5G0r5/pRxkAA+TSD2eEgpeQxA+X2L9OnK/O/OPJIRBLkFzawtbglDuyD9Oyqswtd0m3wx0VKXlm8hw4sWad3ULVrGokgTW7phyxSsOUTWx4TivTzOLMtgPWjCs2t90uaqhZVi6kas/U44IYh5xcOxNw/TFDVjUF+dH0Uip+iN8vKR5e4fi6VOSeRGyjj6iDD+WvD/Qo52Q2FUX2rSKuRRaDz3m7vHyAOrzqar1PXX/+SeE+qZZKNQvYPY/lobVjqVsIVVU7QwIHsIwaRq6j9E1dSB99jOXouoMFUsYWH43k9GofGYyxrlBl
 /23vMssF
 IKQX90ywK5qRzJfUfF0hs98EbVO5ie6fYuiw0fNp0CWVKeDzzhsD7ycHlr53KT20O7d1Cy/Ym309MKR30T6pE7Kcy5C1QDjWM0Tp9QeapYI6EM8Q6IIYHzKBQCX3jta2aAVz58ZZf8vGa49z/CIBOmOgZpzYpuo44DxXf6a7IEnGmb6RABf++bm3/YicFTIT9VyeSL9z/E9qfEsZ8iWvaSzUm0JHQWKCCgrWqMdEpOExUCRnD9YlglI1YYQo0C3uKbGKjvBcVEt6PhAI5V1Q6eiL4FgXrUCQkd5EiaHhpKEjNAB1AL07/03QfM0fBNi5Vhx+G7ClUwDqEMO2DntQMR2D4s8+POV2WwR5rg2jTBtuaD2M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Similar with 318d87b8fa7 ("ksm: initialize the addr only once in rmap_walk_ksm"),
Only initialize the addr only once in rmap_walk_ksm because the addr variable
doesn't change across iterations.

Signed-off-by: Xu Xin <xu.xin16@zte.com>
---
 mm/ksm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index c1dcc3cb4831..337eb04a9340 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3289,7 +3289,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 		rcu_read_lock();
 		for_each_process(tsk) {
 			struct anon_vma_chain *vmac;
-			unsigned long addr;
+			const unsigned long addr = rmap_item->address & PAGE_MASK;
 			struct task_struct *t =
 				task_early_kill(tsk, force_early);
 			if (!t)
@@ -3299,7 +3299,6 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 			{
 				vma = vmac->vma;
 				if (vma->vm_mm == t->mm) {
-					addr = rmap_item->address & PAGE_MASK;
 					add_to_kill_ksm(t, page, vma, to_kill,
 							addr);
 				}
-- 
2.25.1

