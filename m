Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF5CBC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 755456B0088; Thu,  9 Jul 2026 05:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705976B008A; Thu,  9 Jul 2026 05:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61CE26B008C; Thu,  9 Jul 2026 05:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 405896B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:34:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C735A1C7B94
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:34:01 +0000 (UTC)
X-FDA: 84968726682.23.8AC80BA
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 937C21C0007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:33:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783589639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G3INP6Tku8yDPIe6dq/LyBhb0DAWjzG4ouwEcPWi2Z8=;
	b=1dryM3ui3laDfdnIFcuXoIqAkw7rNx9AFl6bcr/PAmDkFh+MgBAbGpWZbnepnZ4rTxHo84
	ANbHnHc/OJfBFHVXYcK3GI4/q3QEVTqDKbJqOMYYba/jKCXqQz8ezHJIFo4UNVYeJmvKNi
	dZnjl2uu+FJ/4gbL2cpm4vC/zSJYIjU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783589639;
	b=z5md2fAyxjRCcA3rhvhhFydYbekHFDRAMSXOfQ28hzO6QNkuygbUVOWeQXxJeU/34Al0yl
	Y018nj5B4Gy/BNCu7PDGd2dN3NGhD3TLvBKrTdMZOGm7hxSCxRJS1pG7v8w/6oEF3U2CuT
	LBguDB1Xa6s1Nmioz8RSn9f28v6V898=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gwqXj265Jz4yjRN;
	Thu, 09 Jul 2026 17:33:57 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 6699XAkw067710;
	Thu, 9 Jul 2026 17:33:10 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 9 Jul 2026 17:33:12 +0800 (CST)
X-Zmail-TransId: 2afc6a4f6ad8b47-5213b
X-Mailer: Zmail v1.0
Message-ID: <20260709173312403qgj1Af6pRkFMDSsmc19sM@zte.com.cn>
In-Reply-To: <20260709173100998Kw7ZktK638ED4oZ5ApjHb@zte.com.cn>
References: 20260709173100998Kw7ZktK638ED4oZ5ApjHb@zte.com.cn
Date: Thu, 9 Jul 2026 17:33:12 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyIDIvMl0ga3NtOiBVc2UgcHJlY2lzZSBsaW5lYXJfcGFnZV9pbmRleCBpbnN0ZWFkIG9mIHRoZSB3aG9sZSBhZGRyZXNzIHNwYWNl?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6699XAkw067710
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 09 Jul 2026 17:33:57 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4F6B05.000/4gwqXj265Jz4yjRN
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 937C21C0007
X-Stat-Signature: mbuwb9du4jq6shtiu9x6b1cgqppgknze
X-HE-Tag: 1783589639-558733
X-HE-Meta: U2FsdGVkX18cqxL4oN8OpMAGVl3XB7NfPzXuyAQbkchcMWgHCWnlbvLw5QvqTrF/Fm/lm4enpoEwGOsY4FMH9YZ/FM1bPad3EtYFBqrIqq9djngrIcVCOzVlrqhDoDtbcrfpfU5PQshYmf0HeGjpYaWxYHfO/v875p3Ix105d0BTqMEYLqVg3t1qK98SA7P/P6zIIHJhiKiLakXhHD7EOkIP7iND+6dlmvicCZha1Y9+gpS6K4Xy3FmaX1Jr75iydfcSOiBsr6NapYPnxMXubluDgNthkf4MK98rQA1qJ2xH0cYJHjTOvLHkCysd4ILay2nl9wqRM3zV2iNoZrErfyFv5WZg0DcYgVZ8k6pIwSnhfCa3PBvXBkAsc6MH2ekmsxnOT8RJamg88mMDou8QdiqvsduizgPAl/YZemh77Unq43QMmmHRxhh/CXqtbi57N4uZ36iRG3mbyvUtnxzVCZWjuBCTqSgNFGBPVdJBGNofuYeboAyS4pmitvOF1OeWGllZakLAfvf7sD6ii5vdhqjOla1ICjJHYSg93PoqGKsZWcw3WUB6xQ1jUt69Z6CfbpZ+MxUOT1T8cRo0NsHPkC1BkfVuYyT/DQayOd/PBZrLlM6kCCrzkaV7MFVUUcMu6CcNfFn8rI31G6610n6m/SgZeq4D7kWt0cpxA3HcJ6uh0eBYIM4MtHz8O2kVaUe5AVwF3agh162QOoZo4EDHaO4YkCcZAHlbbjo9iLg7xU7FRDcwCTJ9KCHZ/f0qxvEE+aTqZ78a4A5zaj3W73od+OflqAJAi6xGSYkgnZ+pGz8xzK6Ngq9PmpDiAORIVe9yXy+XOYk3OZ9UpG7BY2PS+FnQprHl2JtBc1aiAnC29lTTlGtJVAPUUW6A2FBFL1fCSc3mUa6A0z4Tf2lSDT2kDLXoXKbsQCgeOYqn2/+Qc6n1BqXSduSr+4/RJNHfpns3XXORK3L0ifDuSGf2dma
 uUrAx7t1
 4Y8lb0Yry8RnLWdIA5Ntlx0HeuvtjQAs+2x9aEpVUkwK2UDovXcPDcL9dcTjCGW1kEizczSZQsnVkFhs/QYcEkn6zPwr80vH8QqSDFu8G9Yy1OT5s6v4XCwbeOiSWhUgd12YCWLmhGEnyyIhkQnYGT1eMvyu5Jn5VnhRu+0+6ykrEbDLYDdg3StWmshgOkY2eEMKgRVVGqVcMkiyyw5tFLnEfbu38zhkW5Unae0JeBqJAuK++a5lgV5GhHds8h/YgrO1v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Since we now have linear_page_index available that we can use here,
allowing for optimizing the RMAP walk, we can also use it to locate
more precisely all related-processes when error hits the KSM page,
which will decrease a lot of invalid iterations.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
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

