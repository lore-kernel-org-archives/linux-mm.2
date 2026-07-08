Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4BECC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 04:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02FC6B0088; Wed,  8 Jul 2026 00:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8C8B6B008A; Wed,  8 Jul 2026 00:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56BE6B008C; Wed,  8 Jul 2026 00:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2B06B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:22:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00879905A8
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:22:31 +0000 (UTC)
X-FDA: 84964312944.25.59F0B98
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9E162C0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:22:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf10.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783484550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ALjrI56HNUgEJAFOBspvs5hJjHfY3KWfrgl02P4R+yo=;
	b=emGfKGxgibmBK2hlOBp2jTd5BtrfW6ATCzPE4B/Bg0FW1YfzuNW86NAf2liy8RDWoZdqmj
	sntu4YNmW3EClpTGb4cVm8MitR8Tw+Z5vsS8GwFOZPJ96FNlflJA2OGfZS/OjFPL9ITJXN
	+bVIUcY5tRYWP7oOOuWuL35xlqC0Ryo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf10.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783484550;
	b=tIkYtAwi1m4r4PNQKxPagdTWp4Y6GXL3T+rStPsiIRU8DKy7GoFRqy/TAw9R6BrokSjKFf
	+K0SMEn7bfH4PQdH3tZ57QWM+w0LUZllYnmF0OvVHE6qAmxnT4823h7Xhhye53RlmQMXJa
	rzNdOG6ucAcRk4f/S5e1UHh0f2LaNIk=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gw4gl1YfGz5B0yy;
	Wed, 08 Jul 2026 12:22:27 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 6684MGK8078845;
	Wed, 8 Jul 2026 12:22:16 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 8 Jul 2026 12:22:18 +0800 (CST)
X-Zmail-TransId: 2afb6a4dd07a6b6-515a2
X-Mailer: Zmail v1.0
Message-ID: <20260708122218298hWVcT2XtcT3UnK0QdTwuA@zte.com.cn>
In-Reply-To: <20260708113819554pIZuGzMiKKrOwHvNXFBZ2@zte.com.cn>
References: 20260708113819554pIZuGzMiKKrOwHvNXFBZ2@zte.com.cn
Date: Wed, 8 Jul 2026 12:22:18 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIFJFU0VORCAyLzJdIG1tL2tzbTogVXNlIHByZWNpc2UgbGluZWFyX3BhZ2VfaW5kZXggaW5zdGVhZCBvZiB0aGUKIHdob2xlIGFkZHJlc3Mgc3BhY2U=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6684MGK8078845
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 08 Jul 2026 12:22:27 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4DD083.000/4gw4gl1YfGz5B0yy
X-Stat-Signature: n6mux613sjqyspmta8ngsn4n179azes7
X-Rspamd-Queue-Id: 9E162C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783484549-713376
X-HE-Meta: U2FsdGVkX199NcWKrwSzc5GOpC/HxCMaFyj/SvLipEd0sKoHOrDZYRlD3nqqhM6eh+cxj7HrWo7te2iYggKWLdLUBkg7LF+kgP7wLE/e9U0oNPuc1XyJN6F87j/K3fkH8gJzY3TPyJ3bIo5GTHy6b7FuF42aYbFtzFBY1Zs+4MUrdSn28BBgEMwRIyWt7j6Bd/e9M8DUQNrlYbMEvUrAGdY0sXoaHim+XLG6fXLratnXpQxhwJs2T1NyKswoBIVczh0xWZW2/cTxHheGwgUN4HO7ac7vEiTFotEOcb7W2yi7PqLjkYyGkt2CffBnO1PnE22OBdfIdA9x5ucNvNRHeX9izI6pO/T+SH03SBXMNJOOTfvqTgKODuK8AGJRSqlhyol05fm4igZuMGB51pQytp2Os1egrTX7Wx/PH9icwFDbpj2qSlVtY22HacaSXppZyypNYGP2OSVDpc9UW4/1aoy5/H4FiYFteC6h0u5fjkv7RWUWDQfnSHNTk7QjoOdyMSG092nnsd22o3pBIq3tELUJ8g0SokA3nc9i6Xt+PkRPLqtjakdcmdl0fybcSbRILAqxBbfKv/0DC+mydgEn5vZw1z+0pQtSL6SgmukfGuVF+/ECTzU6oxoQJdB94cawjN2623su8MRw3rgNxWscngW+adUcgDWV0MwHNJ5PYE2A+oHl3vbGXS1yl6MrLqXX00Dr/1jd7zznea8W0mhZGG2e6W8Tkehvf2+GiR+nr13pWjgCRw1UMeJmNWv3DaxjnMxKOu4k1peVWJvCMUwH/yyzlRKKPj9WUs9Ozh6Mto+vwJVJVl4MDwkQSWJi3jcYwX4NDYcTBaz2FfhvrPHS7QI7+BJ+tFILDVfg6BLbmKavxLMxOnlO1w9ErAFSqHYKzz8KLaen0QSeb0fo1ai+/GltOkFRbE+kMTwNBsZaAP001vUpQubuVdzzE43FPYPnNWcJz2eHVcjjOD1vHl8
 t3Pdj5Jp
 +/6AEC/0f+auEQtyBWAfA0pWYQZ/ovh+kFLvG6X024ixyhpT/L8Htj37Q8UHOwIuVDk4ekSlO0hNH7Fzh4mNTAmmb/mL563+F7M4bCzSYZ1OO0HdNku227jnvCuBy9f0/sPEiielCNCNb0D3uOv3gngqVGdC+1UW7pJDgPpX9sVign+6Ha9inqHe3NSHjCL7pGtx6I1vjTKa54C4fHo/KzotVXZniWN/uidU5kCz3ymzKVfaopDbNK3k9+42drik+cNYzbCRSoW4r33frCFSbT8FjPLwuDVSOJapJLRGlKZBeywJfhCzk7W5kLKadoyv1CtVuSBZmCIasEN4=
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

