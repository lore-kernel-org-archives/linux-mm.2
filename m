Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E764EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AB496B0088; Tue,  7 Jul 2026 23:36:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882526B008A; Tue,  7 Jul 2026 23:36:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7997D6B008C; Tue,  7 Jul 2026 23:36:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CC906B0088
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:36:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 751BDA0649
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:36:28 +0000 (UTC)
X-FDA: 84964196856.13.3401FA3
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2334D140003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:36:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783481786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ALjrI56HNUgEJAFOBspvs5hJjHfY3KWfrgl02P4R+yo=;
	b=SkJemLZ5YXm8Of+iawjHrHviop+tC/zfUHEd3KgX0WHTO85QKTUYw5SsgHal4XDTLTN8Pw
	hFTjdqJSBzrCjAh1FEuII/LQj0lpOpjfZisfagip/9kb5XYT8/2ol+ZaMF8mCfg4UDFZhQ
	RzY+ur+HscQcw8mZmSznGIPn6pZK7pE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783481786;
	b=bUMigIQ7ccGNErWdTrLKOKkxV9vvK2kqw2AKst6dX6mpHeYLjU3TR479oIomMf/77fmXtw
	Ptlvnz6rmit3tO8a5t4VJ+AeJAZQLjmayUrbc8HZsN7FfHxATe/12QIiLhalE2PEH/1VTs
	YFVRWEtCTwcc9+qJ2zShjnzlynLuNGs=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gw3fZ0KY5z57HRy;
	Wed, 08 Jul 2026 11:36:22 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 6683aF0l007197;
	Wed, 8 Jul 2026 11:36:15 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 8 Jul 2026 11:36:16 +0800 (CST)
X-Zmail-TransId: 2afb6a4dc5b0f22-11e4e
X-Mailer: Zmail v1.0
Message-ID: <20260708113616415f3tkwZLqvjZkGqWYbBk4t@zte.com.cn>
In-Reply-To: <20260708112943731Lz7DsMxSAWtV6I69GjZmU@zte.com.cn>
References: 20260708112943731Lz7DsMxSAWtV6I69GjZmU@zte.com.cn
Date: Wed, 8 Jul 2026 11:36:16 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>, <xu.xin16@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?bW0va3NtOiBVc2UgcHJlY2lzZSBsaW5lYXJfcGFnZV9pbmRleCBpbnN0ZWFkIG9mIHRoZQogd2hvbGUgYWRkcmVzcyBzcGFjZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6683aF0l007197
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Wed, 08 Jul 2026 11:36:22 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4DC5B6.000/4gw3fZ0KY5z57HRy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2334D140003
X-Stat-Signature: feciww3h1a5f8bbtn3uph8apqhe9ipbj
X-HE-Tag: 1783481785-446127
X-HE-Meta: U2FsdGVkX19LeFugcHZKneVv5vLAkmia87KzjaAespOnIdEsjDuo4wctr+UC7nFqSYWVf/DjteCANJzZ/gAouWOHm7au4sl6gj86ZPzRPqFjI1tI2O5pCoWnjbqUDVSKjGHzOGlvWaOsfzLXNNd/gfb0sRwZT9rX8pjEcw14EvWgwRUIe5Nl3di49BEJUsAxPpGfDYN5yMHcv1isn05UwKF5nlBRUMN+uU2c609i+3HMB7efREUHw/ees4pyQXpGAlDaBzrkC8nu8XxF9z7Q0szG6eDGlfge/T/E2qDY7p5Tpqp4nSdG1yjqfe53VTgCuH/7mUHFLc452HSMO9i76H3+MpPUitxViMBy/XHS8QPpSg4d1eD+ZgsX5odjI+HQb38prB9hKfykMX4MM2kL/Sn8BUmlb5aq76trDdc+yGOAwR951muDdelml8I6wzwffoSVOACepfUQrb6kC/GJFz4lh3EY6gyVMi6Q+kOeWTLj2CcnZjM1NcloimSaOuP3dcyIH3sgYDJk3Y0P3vObpFjRjV4xVcATsFvoV/MlWzrCVnvWGxqkv/hIKGwkgjPl1tjohs2nxoHS8N81LVmN/L7EZ5DiUEPVXe4KOE+1Jx91QEeVpUyu5qd2rb4Uoq2+NLdAqvYKM+vWVkRxJeyCosJE3Ls/Y8jK65n9etmg33VZ7b/raG57ZyutGdBieG+ZRyF7FZq4h247EnBmNssvMQR+M2ZlokZdW8vMX6JlRnq8WM7//QjQ6mvEmwU23YaVrUMqABu0ijsl6o0oa8WLA9HdYrK75GrlCbx/oOZuH61qxyeLdQg0ogQAApYsT/uZt7P7ihMVILI0NpI3bi0iv//KSxJKPX6j98+l2z1jSyDoGwvpujdlnOjj2NO5ZeZNCq3oez6nbu9y8CXWlXX1tgHlwi8NfpnPKxvfYowGub/KxIIfGYNPsJRxS8F07V7sABwQpi/q4+pi1AtNihp
 91mRHkZX
 5fsWrEgIw8ml7r+uaTrtFaKQCqIJ+8sonkF6voE52F4Zkpw+rolLUBuci5uS0lQai0z4kC5Z4fjsKUOtk7Ewm0FDBikzdlsj+YuSQYj4KHuKdjrRAqKjUxt9hoBWSyjTZe6x5YE4LcHCPsGBMMxtOnVDk9btsYpNyrIkdNwFxMnk4uUhBejIgdI8L/6I8mW2JVFdVNydoIfpziRqdc3kyz9Zjbdkvu0M1IGbHrRvN8XTKKytuD/v7RlB4rYBPeEcR2uG2niDLLkfAfuShbHWSRtJ1nGdHvYNNDRowvwD/VNyI7sNJv5jCAsJVmZ8gTzo4vxmFojF15xyFG5Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Since an earlier commit introduced the linear_page_index to struct
ksm_rmap_item[1], allowing for optimizing the RMAP walk, we can use it
to locate more precisely all processes that hit the KSM page, which will
decrease a lot of unvalid iterations.

Link: https://lore.kernel.org/all/20260703162357853iIa-RP7if9hRlAIuTh5La@zte.com.cn/ [1]

Signed-off-by: Xu Xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 337eb04a9340..2791ce5bd44b 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3290,12 +3290,13 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 		for_each_process(tsk) {
 			struct anon_vma_chain *vmac;
 			const unsigned long addr = rmap_item->address & PAGE_MASK;
+			const unsigned long index = rmap_item->linear_page_index;
 			struct task_struct *t =
 				task_early_kill(tsk, force_early);
 			if (!t)
 				continue;
-			anon_vma_interval_tree_foreach(vmac, &av->rb_root, 0,
-						       ULONG_MAX)
+			anon_vma_interval_tree_foreach(vmac, &av->rb_root, index,
+						       index)
 			{
 				vma = vmac->vma;
 				if (vma->vm_mm == t->mm) {
-- 
2.25.1

