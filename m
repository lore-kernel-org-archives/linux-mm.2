Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1197AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08ECA6B008A; Tue,  7 Jul 2026 23:33:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065A06B0092; Tue,  7 Jul 2026 23:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5326B0093; Tue,  7 Jul 2026 23:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C16906B008A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:33:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 449FAC3723
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:33:47 +0000 (UTC)
X-FDA: 84964190094.15.4C183CC
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf10.hostedemail.com (Postfix) with ESMTP id 99EC7C0009
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:33:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783481625;
	b=BGMcJG17+ARuCNHDwU6jWxSjml1c+qEsaHK220bDjQBh6HnNFRbsPJ+PYGVWdY0m2kvYNj
	DjB/J6F3FB6Oym4QS5NQwMpBUJqildRw6tSB2fjaAvqAKLQdeQJoUP1IWQ3W1mATZTbzid
	VRo0me4wKt0PrUgqC6+YulAz7kNysIE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783481625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B7UjeFvVQ1cyG9Dmv2op9ATH5Przt39ajs9NWlvVhi8=;
	b=tcDGJq9JhDdgaBX2qByf4zOoe27n/a36oZKYOPHfRxlqrMsOjdA9PiBjr7IsK3Fu7dPHRZ
	3QfpmN4wfnQu54DV28Q9DtqdjMFJQZcu4fqkjzKHsxhYpQ9E9MO0EgXaRQLjmWCnoLhiIg
	dNzk3Lr82lti+3ZVCzxDIPR08JqzGcY=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gw3bN6m9Mz55RGf;
	Wed, 08 Jul 2026 11:33:36 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 6683XRYx002211;
	Wed, 8 Jul 2026 11:33:27 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 8 Jul 2026 11:33:28 +0800 (CST)
X-Zmail-TransId: 2afc6a4dc508e0d-10d3a
X-Mailer: Zmail v1.0
Message-ID: <20260708113328247fa7w-FySFzbRoMCeMvC20@zte.com.cn>
In-Reply-To: <20260708112943731Lz7DsMxSAWtV6I69GjZmU@zte.com.cn>
References: 20260708112943731Lz7DsMxSAWtV6I69GjZmU@zte.com.cn
Date: Wed, 8 Jul 2026 11:33:28 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <xialonglong1@huawei.com>
Cc: <chengming.zhou@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIDEvMl0gbW0va3NtOiBJbml0aWFsaXplIHRoZSBhZGRyIG9ubHkgb25jZSBpbsKgY29sbGVjdF9wcm9jc19rc20=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6683XRYx002211
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Wed, 08 Jul 2026 11:33:36 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4DC510.002/4gw3bN6m9Mz55RGf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 99EC7C0009
X-Stat-Signature: 397ibfdy9g8et3jso8495ucaxxoab8z4
X-HE-Tag: 1783481624-248953
X-HE-Meta: U2FsdGVkX18Hhh8xpJyQagl6moM7ZtbBUrqzo8yAxGbNkodfY3i717q16JO2G3XwSwUboKx9kJOFWj6hYWAtVDOCTH/nVum9+HhbiLNMQU4rAMshQwEr7q7edf7KVWyu+AJ4qkbE8mJWnKYZ0GrAnswsZjYK0B2nV11VoXMSzdE03hFvB0aS8JtezlWepgBNiCOCd9Ex8CcWPoBeQed197YD+uw7ZFbAU3N9OK4vYnDN3TPs873aTJsjF8Bf+Dk6QNiGJ0mBG9QK++Ylz+XUt7W9I34l0dRO6u3s8QJdfByhV9wekl0Lfbfpzc6maOYJrHTSiz1BXMz2+VnsA3vkAD5j0ZVGgZEn2BA7516Mxg3PeNkgScTLkEl4Yw/Dbh3HcwkTysYA6zcBS6w+1jFYucte6KIHk1PdLN916KoUEtyKMvarRdaM2vsvUBuogWDh9elf3UnbkJaLBuT44+1Ctq5gV/iZCmGX7oFhieBp6DCgwu16V6AqMyH/VI+wc72C6RC5dNp2SmP4LjFCh0HHszE4OJzyBapOioq3QEKogEoGF9e6ca906ZZc1s3f7sqG6T1cVbp1Igjn9Kt/veHizWINeuWwi4u1vxQMb0av0FfKg85vj4BhwAFAnvRG4PXXASqgDpYM0581iykCrS/LOjgrXI2xNeKHeulBjwbaoKAeND/8F7LSsBZ+jSC0h89Ja3oiUue6aomlNTMimQ++0sgAB+XL4hd+T1Lr9sOUvTbw9lx49PlzqqI0qv36MUn+/LIJQAIaTq9CksFv+IOT/vlxPk/TY8jNOYF0NFtx0dxNIpqbwqRYxih8nuUEVLGu7+KPn4Ef6LC7rxy7jID/eTCtmdfCnS8Pf0M23uXDnEKUraTjIwjXmrFmUc/aVaQ2DnBGE2y8orhZSEa1gqt/EdliyfCn0sdnY3iKQ+SRRzI1AyvffO4JU8qCy/huGISTt4GM7Pl/moCgVNGPUoI
 x21kgsJp
 +r+Y0wsqc+hT+JNb+4tgAPXCDKOt7QdABJg7OETQj2E/KJaP3g7uG5gkYKOH/Dvb4UH1llqcjKswUvn8M4/eh3Ts8+AmQ2O7dkC+q9rLUMt1ePh7KCWGOuQRZYom6Y/Z7k93quXD9ngMw39banUOHD4G9oFdZa0H8dy5MUeNHNpuys365QpVt7mGH9vCdX3KY32+Vvc/12lGhpP3kvz5shg3Ob+OmI5/jfHG02pId99Q+xVYoIfrKgi0ClcVLlNsFa4o1Fh7r5MrnjLSTGFV2k4/zyQ==
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

