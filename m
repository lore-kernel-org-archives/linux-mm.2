Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B648CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1B66B0093; Tue, 19 May 2026 08:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9FF6B0095; Tue, 19 May 2026 08:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0146B0093; Tue, 19 May 2026 08:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9501C6B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:12:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 485748C91D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:12:34 +0000 (UTC)
X-FDA: 84784057428.23.E1B97F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 57CDEA000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:12:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H9/vs7xV";
	spf=pass (imf15.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779192752;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7vzNmz9eSh4Qbmz7X6gqxTMqvKR7GP2yV80kQ+aLLM=;
	b=kNNQZeeNG3wFpNbBLBHsNZCm+LW2LcII1Ob3BBRbOJ9pJN4AzGnyx06GXiebcx0kdU2va3
	y9Fm2secOfHOdR6IEsOT3nh9/bcrL5eYxmkBbstY/B+E50DbYHY25uRip8vHZydodQpM5E
	JXatfN+MA+nhxp07Wk2C2nrRl8pDtcw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779192752; a=rsa-sha256;
	cv=none;
	b=EX1bhfBIZQU9mE8N7czxt/3lCRctItO6hotcU9bWn7bBTp/R9Dl/CWBSYaD1eb07NOcLrF
	y96bBJ8hcKQUPwhgGrjfWriDpT3ojgfLp98CX8bTZZ5HSNCqU5mHiNMIcvvD0MFMDChxrs
	tATambEL184WM2DCXXtrO52ZmWgJG7o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H9/vs7xV";
	spf=pass (imf15.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D9954450F;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4611EC2BCF5;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779192751;
	bh=DoyPRnUD10ZYPnUyihoSOX0F7D142OjSjSI8+OzltR4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=H9/vs7xVUDwl/4cYlaH9pVVBv6paPsmJTXoNK3frswbc7a9zAh1x2iOAVw8DgJ59I
	 LrCGvARR/hJpQd6miBDrlgNcKtOosFidJqra+mMoZRzQFDhu0PuzYRcljg0qYsVn2f
	 t0Jo8qskQLXLUQC1g5dJubhoHarjKDWFe0b30wRsLiTQujvoarpLHBbO2RmnWH0XBd
	 bUYU8twVVZTmGZ/GaQALXajBIg9zOrczH1bW9r332cFvw64XNWL299pzE6Z4WX9388
	 WSRuA2NuhMuq/XH+P6YAeJk/unOpOKNlRuJ9lHLaRalT2RjrSU3FJzHollYN70cBdO
	 RexQrfPrJ/13Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7DDCD4851;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 19 May 2026 17:42:16 +0530
Subject: [PATCH v14 3/5] mm/vmalloc: use physical page count in
 vread_iter() for VM_ALLOC areas
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260519-vmalloc-shrink-v14-3-70b96ee3e9c9@zohomail.in>
References: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
In-Reply-To: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779192749; l=1455;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=17YglxgG2ppUqTmOumv09d5uhEbrPDSaz3Teo6shawQ=;
 b=15zXYsWKqHJrAve7nV5Lj3j6NhR1QbpkCVzs/TxDWjJT14PEhptP1gVhj2ucTu11Cb1lwn2Qx
 5SiREPfwJ02C/Z3uoyWrH9NoY6YBtHeGjLyWDQJn182X/2d4P8Kfa3G
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 57CDEA000A
X-Rspam-User: 
X-Stat-Signature: zztpnh6cgq18yeha3fz4hgeeewseq3pa
X-HE-Tag: 1779192752-259808
X-HE-Meta: U2FsdGVkX1+jU8WQDkBwdOCymDjDCX7NTb8wTUfa3vXq4Yh1gRmXo2dfu0EnWr7qAoCReJrhm//z7nQVuR1PjQPrd3EeaFBeIcGjAxcXwXWnAuyMLYy77sC0Wz0tA+H1usH0JFLeq/+xg/JPpy9YJuIQQKwJs/Aqq4/utGFc1AcIAgwdXbQ41tg66YsCYCISclmPUrkmfg04+nez1GcQWys2RvkhkcpQD9yyl8EpyoxFux9fMPdA/tW5Mzobuassij2LNDh81jMoOxHeoZ7DbQLnwgnJwiwaaKfuQxjLGLNzeCLbRD2uNDCL47H4eF5cWH7LZXkrpozUtoQbBzNl74LkB08LimQRByyZXYceNYCrVH17HyAHQeQIqKbqORcKTjdL6T+y4R5YJAVJfbfBy5ddB55y5h+uIF69zIlbN6bf/hNvcTnu6gYXRH5C/lu4XGzqAnIzCB5yo0L4rKtDjaIDGTcYR2ttdKVsItuyc+Vj/AWHtTOn8V+N942QaJE03PdTF34VNXvC0p4IUsupHHDbhVUeLA6PmhAMG52iee8/gir3CLNjQWiN7y9fZxyUK4/wg1Ian5xB90pJA2MqMWTdtlbEaqHz0HpDUS8CocOXdZFkBIhc8ETNo2H93aGVtlY7r3pA5UZ/MQbkcwMrMSIILwQurortwwJxn1ao540MeZltlezWV1tR9ZlDoK+p2rcZpOIDFqTgMue97mzsOolFdk4tyCf4KAaUxU48EP97stsRhQqEglBZb8ZKNVPLMfxYcG9+nnfrGo9crDylJ7BH1PP5uw+YsY7myCwgvVGJA3521X8VuoHuuUUCD6rAvAZZS1PIwL4qcUQME2Kb4rYbiReYOVRhM5AP6ocAGMg4Po5VPSF6ZOwpW7KCIVkrxiFj2hTMGnXbsYP1NvOq0KG6/UHtEgy30njlWle7HIEddFCdFz71P13JImEzVUr0B85swUWQPFAJRUNyg+g
 GIz8JW1C
 RyvVC/XOvjVNspORTDcDR5Mb1kStpw3jXp7rQlHWSYc7iT9epv1fQNNfOL+Okww5teU3LpkOeGkGb1rXsaQQ2EqFt2NJMcfv1ZU7fj0mKTL1vwLtzvXEKg2CVcNTozT7gsnHkGLmx3v9UoU3Ga6nVurfZ4/h2lsfz+rRpd5p9Jg//bpJESCX+dr3utkUrADogLhCTxwVrJD12R48KDrHjEZj/hboVqJeMjoOenBlZlFa5YGo+8DxIULnzDcVQL13nthtHh2cOkynuP6PrS+bhZqtZqExhH844DIlW3pGDsfe4uLadZcT3BJvPaivUib1Umfnbj8MDNAtmVf1v9a+Hpk7K1miAHR0KWUrwONsuwsmA9VfLAkQomuyesirXLZgT1AJehnrQ6yqx6wWmyWLTU7zQ8mNzWNcd2ZNBJ2W6Wz+WwdBwffcFDm4f4BwHNVzbYL8qdRGxUklopP9xQRSI1tptrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

For VM_ALLOC areas in vread_iter(), derive the vm area size from
vm->nr_pages rather than get_vm_area_size().

Only VM_ALLOC areas are subject to vrealloc() shrinking, which frees
pages without reducing the virtual reservation size. Switch to using
vm->nr_pages for VM_ALLOC areas so the reader remains correct once
shrink support is added. Other mapping types (vmap, ioremap) do not
initialize nr_pages and will continue using get_vm_area_size().

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 3e159b74cfab..2f606cfade9b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4666,7 +4666,18 @@ long vread_iter(struct iov_iter *iter, const char *addr, size_t count)
 		smp_rmb();
 
 		vaddr = (char *) va->va_start;
-		size = vm ? get_vm_area_size(vm) : va_size(va);
+		if (vm)
+			/*
+			 * For VM_ALLOC areas, use nr_pages rather than
+			 * get_vm_area_size() because vrealloc() may shrink
+			 * the mapping without updating area->size. Other
+			 * mapping types (vmap, ioremap) don't set nr_pages.
+			 */
+			size = (vm->flags & VM_ALLOC) ?
+				       (vm->nr_pages << PAGE_SHIFT) :
+				       get_vm_area_size(vm);
+		else
+			size = va_size(va);
 
 		if (addr >= vaddr + size)
 			goto next_va;

-- 
2.43.0



