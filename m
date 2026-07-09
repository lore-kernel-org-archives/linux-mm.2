Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84F41C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A0B56B008C; Thu,  9 Jul 2026 05:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7511C6B0092; Thu,  9 Jul 2026 05:32:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667326B0093; Thu,  9 Jul 2026 05:32:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44AC76B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:32:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA6D8120451
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:32:25 +0000 (UTC)
X-FDA: 84968722650.28.E289D71
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2A819A0008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:32:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783589543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rVL7j1KDuBzeXo2kj+ns9nI4uN2mCjsAY633pndBQ0A=;
	b=y9mFhOf3YjmZaI81oJmQjTEZAzfAvpq1kk53wx+zg1f3JzPbb+Sgg93HC/XkQuUgm6JzJD
	7HTQ7rx8LhpAbKxsx8IhNcGfLP6nHvHteJNws1To7B0hGyiEU0xYNlC2QaM2p9VoOf9A19
	gxCansOaVndM58jKjHeohzPUgdNWyys=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783589543;
	b=0ZPU3ZRrx3bI+XvjAoPi97wcRrzbgmDgERcCVsTkPmwK0rCO7Q2GONKU+NP5iHChmgtI/j
	NU6JAh+b5E6W8pqejdOaMtagIC4Wiz6lYnrmYC8TrYYrpde1ZlhwHENBsC8YNvo0fHo96a
	fKv0Ns3ODZxqZFmk/iEn9WXRT/osyrU=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gwqVm4ZQ1z5B13Y;
	Thu, 09 Jul 2026 17:32:16 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 6699W958065542;
	Thu, 9 Jul 2026 17:32:09 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 9 Jul 2026 17:32:12 +0800 (CST)
X-Zmail-TransId: 2afb6a4f6a9c0d3-4b6cd
X-Mailer: Zmail v1.0
Message-ID: <20260709173212190rZdwynySRyLr9EtPuXBRU@zte.com.cn>
In-Reply-To: <20260709173100998Kw7ZktK638ED4oZ5ApjHb@zte.com.cn>
References: 20260709173100998Kw7ZktK638ED4oZ5ApjHb@zte.com.cn
Date: Thu, 9 Jul 2026 17:32:12 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyIDEvMl0gbW0va3NtOiBJbml0aWFsaXplIHRoZSBhZGRyIG9ubHkgb25jZSBpbiBjb2xsZWN0X3Byb2NzX2tzbQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6699W958065542
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 09 Jul 2026 17:32:16 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4F6AA0.001/4gwqVm4ZQ1z5B13Y
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A819A0008
X-Stat-Signature: wg41d6yu61rxkw85triqx3hzq7byernt
X-HE-Tag: 1783589543-245309
X-HE-Meta: U2FsdGVkX1/My4R6Qg1QUOxF0ggvNYwmA3Zr+M9JywRiTqOwjf9EQvWxqsOdJeIDP0GQPVhXPVmhBqixnooNACXnzgJLzznof5SEB1gYntUcEsqX5jKxfe4dmiWAyUk4yVxFrVdYXsofOo1I5jhnhGbPgNKO1aUQJXcWVYTB4x6TsRPS6wWxM8cnesz5FH1UBGYU65OON8oG8/Dt4lPrMf1h9XFuL7SMP/5SltXsNUEaOoWeyU8mDqNveTkd0pOSsO9ZqQqnKVcB3q5ff+ubqtfNI6DvedIMiyq/yF6XoeHHBmlf9olHrzwWUUxorr0Txr3y6Rq2A6PWiTMZmp6dbHqBFQAxrhF17Ku0x+yQAcMIQ7Bznh8THIi+5Fd9zJo41ZwM+zefoJ2MUm5P3Yue4dlfBSZcIGsDY3j2YIE6rLC4yYiZ2UVz3IzSO3IiUxJvFZ27YKXFcoFG3NULeDpy4W8K3pc/TIlZiScgC9s7S9sTzI3obIrK7p+aZQ0fF7JyRmxNTQ6zAc/xqng8FkwYg7zJKxo6G3L19SPIFO6WM/RemNqlATzlLJ0ESAKtCNV3TFvD7/dUatzvYQIkSdRAMD0FIiWbAPRxycCf1Lzz7ZiCzuaQrCxLyxDIwO6nfLu2Z0zQlSDZbTjeWsHFYknjdKI9szlKylQrgyfRgGLwpKqeZxsp6CeB3gKDkCh0zyjxtsSikwhDfza8VZSMAMi8Gg44/rw7WmkOLp8e+FHBFMPL7iofX7PqVDCJ31Afiz0W3KvPE7dyZg+v2GgYVCA4jkFMYm+2uJhHXVsYXK4X5boYhB75na8GgmPH0EsINEDqXAhhSP/qLtuXb+JCRmhj13WlnwqfP5CW9EdnZwSFqYr9Zbj8LLxHKnwu9vCDsCg3oMT15hX4V4T0ILX03n7YTHNqrGNZxrNMluOpeMkO/s9zX4uGbWCyY5/uEA5v+tfwea7L52/NFAWsvoRqRsW
 eI6ciRSu
 TdyLrkaGYqf2zD689cf2r5qtISf4j1ouAPheXGy8OF2zEm+CKZRoP10VB+3jg0VD7Il4zCZCfEAURrJIyJFUa5I0iHKlAKUqDXHg2sd2JuFR9uTA8MIqX2E5nPHNVlv5A3YnOndSp357EBwprscZ/bey6hn9LVMYCvtuGrWLWNw9vUS+QhzxwhjIgCSxiuQngNuLvWgkdcD3PJ1eaDtGYBmmf+SKg/R6O1GcOlPqe/z5R8mn9guIOxHLsIxx7Bv85hBhP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Similar as 318d87b8fa7 ("ksm: initialize the addr only once in
rmap_walk_ksm"), only initialize the addr once in rmap_walk_ksm
because the addr variable doesn't change across iterations.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
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

