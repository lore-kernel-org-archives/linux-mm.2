Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BEA8606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 06:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nOLT5lV/
Received: by kanga.kvack.org (Postfix)
	id 553246B05B1; Mon, 26 Oct 2026 02:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503886B05B2; Mon, 26 Oct 2026 02:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 440E06B05B3; Mon, 26 Oct 2026 02:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 219846B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:09:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 917B88067F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:09:36 +0000 (UTC)
X-FDA: 85363750752.15.64D8772
Received: from mta1.migadu.com (out-201.mta1.migadu.com [95.215.58.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8BB5AA0005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:09:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nOLT5lV/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.201 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792994974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRO5qjnwALlrQa/AL5APisjMR4z2O+zqds9mzHpxSAU=;
	b=54WLhpgim597DTp/NllZTmX4tTFmzMzW8Xp+cHgnp/Rd/HYsuP981qQQTtVsiGknnFrTbQ
	fpH6GA+fHQHHoLvAeSUG/uyAS+5HanACb03f3JEpypj4ZGCAdSfb/4WX6fRP2NHjW4BTlD
	86vxo7FHjd1bfyB9AKvp5T7T7mBzcIo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nOLT5lV/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.201 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792994974;
	b=G7rFNRz/kl61LGUkoswzoOf9V+12+iRTK+s9K9c8FrsoQwO1eWlpBb3epZ8fXqX/5P8jh/
	WE4+dFBDsUiq7Ta7jj5D5slBoNPkPxd7kfqZiZOlrPLWUTUBfpe8f+2sQFum/dmMuIyNwZ
	vglMUzUc3EP1oI9hub6RBrszG+l95Bs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uaY+B1fHFP1ahLgB0T3Rk+kqqo7Xd5Z1Iz1h35K6LdY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792994973; v=1; x=1793599773;
 b=nOLT5lV/D9H6z5XSR8y/VBJHt9xb7rxn1Z396Z4ctj1Qx+3WlSkuu7qB7kprGEaCjpVxG5O0
 g63D+Y6IXTEQ0m6kpw/R4QsWnvFKeGTU1ZKVac/bkMOpFYTxgfPtfVEFNtAjMfxHkBSF8+hJDIN
 tXteDGLbnNHuSJNOb7pJxah0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 530052733c7de91c;
	Mon, 26 Oct 2026 06:09:33 +0000
X-Mizu-Trace-ID: 530052733c7de91c
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Mon, 26 Oct 2026 14:09:23 +0800
Subject: [PATCH 1/2] mm/vmalloc: drop VM_DMA_COHERENT from
 remap_vmalloc_range_partial
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-vmalloc_remap-v1-1-b7a907814e90@linux.dev>
References: <20261026-vmalloc_remap-v1-0-b7a907814e90@linux.dev>
In-Reply-To: <20261026-vmalloc_remap-v1-0-b7a907814e90@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.17-dev-39d60
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8BB5AA0005
X-Stat-Signature: ahisaide6usu9b9ptmjr4akc4zixqod4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792994974-74256
X-HE-Meta: U2FsdGVkX1+kPVFCNLIKqSlKfN2txYTUnCN/1CtWbcQ9AsiIL6O/0xnYGs5h1Ik5TqPwPnAWwaZyrfCuK1DGBifWIBF03MeMT+Z2cFCj4Nb5b6znrXPlsejsme6oxXMABSFGeVpf8kALE2SMZrfa01xnLMRIWa9UHWIT2rs38ULuh317KgyY+kAofgwYIG0POEZVtb4IB51PfAysuvClQwUEl+MWRKPEu9Ghy9BpiD+y79buNd1JydHaG4NHkgAxs0KRcRNi8Q77zDdp0DQFWf16NuD74oaU3cK4/phHZVKVKszDQIgnrwT7+OONdaVxT4yInJR9i79Bf6eupm9fr56MgeWOXdpT9FlMEzE5Jdv0GHmTVfKba8ke3aBQEQ7ieZ2R+scThveImNCLJWsRm3aSQEoM0uF318TxjBt6xnsPBfHVJs7P9goNzFAz5077GNES5DoY7YHsiAlaeHSJOa4Fy3TeOJw6iEPJKuFTPh541l7O5CTAUq58uN/JwIIhmE4nHSGpnrBhOF24U6w2W9nH5VVcTytT77P7Q6CGQpng1zb1KoWZOCQxIvHA4BuheYqzgC/CZyapJbfVA/1v+yHqWZwyjsT5su7TzlA1uyQwzMTOfiQyV1iXqMFJcKeBxwAzwrCDmKeUjrk8dhcjDS/xWzoKwM/I/3tTzzwLQa81g8/Mquny3u10cGulFhf79KRctiXfaaXClZLzKAA0kOVBhQcM5Iw3fw/E2RI59WgLNW+1U5SIr3RD9uWeZ4Gf0Oe688EUn2QtNd5oSDoCT6ljH9DN5iVH5CG8kPfPKzloEHH2R8MFykjdpuhvpeO/czv2Osirgg1Xk2V914PSf9jhOz8C9BXSRhOSQ752OsjuHgrpB7qnOQf3u+vXB40i1estke9eJN2Erae4MVP8FpjGtpvTUX5k6xPnJTjLSB43UlED30oJOL5tViyIOI9cGc+fRvtAv6Acss5bkme
 U+3hA11I
 MI5f/XEKBIhfwRkcBz/kp04qGv/z32oRKKME68UTIcbXuAMkiZy4Fx6PrT2EglJtPL7M9Mp3mMG274uCTwAP3MA/KS/9XsdY8VfTwDpqnkJGE7c6OM/HLEYzVAexVFOktbDlYhKy3q4Vl86ZwTg8GF5RzH8ZEtM8JXjn7c5DEXlF4+K8RkoklG6mNorexvaA2X/Seecza/WCZR/ikiItfzS/dznu/yQfOT9YbwV9fZ4lGUNTSsmSq8UJSSNvfqljJMfL1ujUR8Nt8gpW+RQM1YjYX75Ybm1JpknlL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ye Liu <liuye@kylinos.cn>

No caller maps a VM_DMA_COHERENT area through this path: such areas
come from dma_alloc_coherent() internals and are freed via vunmap(),
never through remap_vmalloc_range[_partial](); all 13 callers pass
vmalloc_user()/vmalloc()-backed addresses.

The flag was added in commit fe9041c245196 ("vmalloc: lift the arm
flag for coherent mappings to common code") as a mechanical
translation of ARM's VM_ARM_DMA_CONSISTENT. It is also unsafe to keep
since commit 5ea8ec74c57c0 ("mm/vmalloc: free unused pages on
vrealloc() shrink"), which frees tail pages of non-VM_USERMAP areas
(VM_DMA_COHERENT is not in that skip-list): a shrunk-then-mapped area
would hit vmalloc_to_page()==NULL and vm_insert_page() would
dereference it unchecked.

Drop it so DMA-coherent areas can never enter the path.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index db669103dc66..a888eca016a8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4894,7 +4894,7 @@ int remap_vmalloc_range_partial(struct vm_area_struct *vma, unsigned long uaddr,
 	if (!area)
 		return -EINVAL;
 
-	if (!(area->flags & (VM_USERMAP | VM_DMA_COHERENT)))
+	if (!(area->flags & VM_USERMAP))
 		return -EINVAL;
 
 	if (check_add_overflow(size, off, &end_index) ||

-- 
2.43.0


