Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB1A71125865
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 18:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09D016B0005; Wed, 11 Mar 2026 14:22:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074C66B0089; Wed, 11 Mar 2026 14:22:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD106B008A; Wed, 11 Mar 2026 14:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DCEBA6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:22:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F85A140369
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:22:48 +0000 (UTC)
X-FDA: 84534603216.30.B897D3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 896A81C000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:22:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FmCu2eCm;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773253366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R9Z26hAtPMOOd7zeDFeVkXPBNRIy08j+Q79+RyxCgUY=;
	b=aciGuXel7rIBNOJt+PANIHzXohmNvqIur/3N6IlrD/pvdVdm3iFL980QNOdgvyQPp41XXU
	v9U80WEF9F/ONoM74/gyWzh/oMPJHRO8ZjEKIfhc1LAq1QVSJVjtc11qnZNwEoSIqBrmJP
	5STuAYQ9bgjAqWJyfXQkHmW/YX/Yz80=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FmCu2eCm;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773253366; a=rsa-sha256;
	cv=none;
	b=SlGIPHXR7aAzaNQqT2H88qxeTCR8LmrxXlRku1bThOR3miLH+axe6Mo1VoeZvhMr7lHAAC
	aWbYtzTprcSUL8fd0D/z/TWWrEc2CpBgkx7xis3wyHh+oltv7SOl4k3iT/tE8OPVdX3fsh
	yODBgh3eRw6Zl8o8i2xC4y660EmUQjo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A7307435AC;
	Wed, 11 Mar 2026 18:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736F3C19421;
	Wed, 11 Mar 2026 18:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773253365;
	bh=0JJV5PdU67v1Ylt2HTvrKQMniMwA9sO7ZQpFQJb6PAo=;
	h=From:Date:Subject:To:Cc:From;
	b=FmCu2eCmtf0r0qFr0xEHctcuykykfT/lLM3pc341wa0bEbIDmvHUpkS3KdzhDfqE/
	 VMaS+Lyh55nd/Q1W2kvSvkNQ6ycduW5miiOhty1UgyqJf1Oi82nHel/a+rZ1kolBcG
	 MQdvuaeQ200g4k40Zwo0N7d9FyiBzsfD9RHNR3i+yYI+K7VeJqWcBOCaGPlZ3iSWPq
	 qAYfNxG36ZqXhfoX5cCofjWJ3/xx/ZRcC94oIBRJkD3811MgeUCoLpaADmFMJQwP4F
	 xoQlZ2bH/VJRZoDBfinbqWtBStkoA5BNe1JKgHIavKq491S1k2VQDzsWWyYLnohbKx
	 4Jkn3880W/V6w==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 11 Mar 2026 19:22:33 +0100
Subject: [PATCH] slab: remove alloc_full_sheaf()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-b4-slab-remove-alloc_full_sheaf-v1-1-c4c5bb587ae5@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOiysWkC/x3NQQqEMAxA0atI1hNotSPiVYZBWk01EO3QoAji3
 S2zfJv/L1DKTAp9dUGmg5XTVmBfFYyL32ZCnoqhNnVrGmsxOFTxATOt6SD0Imkc4i4y6EI+Ymi
 ccV1nJ/eOUCq/TJHP/+Hzve8HrSOsqHEAAAA=
X-Change-ID: 20260311-b4-slab-remove-alloc_full_sheaf-b3404881d45f
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Hao Li <hao.li@linux.dev>, Qing Wang <wangqing7171@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3535; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=0JJV5PdU67v1Ylt2HTvrKQMniMwA9sO7ZQpFQJb6PAo=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWRu3PT+7fsfsWfYmM3XLk9RVP3T9MbvkyjztlleVg410
 dskvB26Ohn9WRgYORgsxRRZqnefcBSdqewxzcP3I8wgViaQKdIiDQxAwMLAl5uYV2qkY6Rnqm2o
 Zwhk6BgxcHEKwFSrzeNgWPCiaSL/r40pnnYv9kpbKbE//1xsdGNq4aWG02UBJ35VSO82PR3FI/D
 bt2ul9T6zdTt7NbMmql6dv3TyiWquz1EnDDZO4DlVfP6WeKfoI+WwZJmNW9K2L0nWXXnZN3zW0V
 9rnn71YY1j4GxnfcTLIjPvwo60n29fP3+dfjJ2omJf/umDXhvk68t05T9YXmj9Em2y/ex65W+7n
 0rO3bn6woesD1n3Hi+a22DQWTH1QaXTzLyeZ1syO666zpH04QlkYZhvzGg/b9fuDT1Ky4N22fUz
 TH7Y0rpWOrK+4Kr/5Z7lu8S4Z3ZKlvA6+F7eevKpH4sNZ7Lu7UN2L+pEl2XEmn61V8lY7MMk1fK
 rRmbhQQA=
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Queue-Id: 896A81C000A
X-Rspamd-Server: rspam07
X-Stat-Signature: sckeewqo3nrnzpu63y7jdq9r8wp8apy3
X-Rspam-User: 
X-HE-Tag: 1773253366-329913
X-HE-Meta: U2FsdGVkX1/zdnNwC0o4FspkBCWSIJXSVSp61A/8osi9x85ZMzxotet3EUDSsFB0fJQ17uVPSdEOSkLZQDUvBWxEjqQrQ9K5HkwAZJa1M58vUScd/5rPCYOde9ex33u0yRZ0yVOCHa76ZuNQt3IbE5HZf5lFfCdAoH1U/004DlmdonJ1KgBz0Hw7iDfPXa/jA4ds2RVq6p+N89Txj7jM4g5tEdaQz5TEid4VGq9NKngOY8W705ICWoV6+xIKOZnUjsb8Ci0uNPPuXg6wocsxJcBrujbQAZ3cgpvsNsVYxhaQFlYph5M4P9t3Pqw8oRf82gI5Mi/b8cRDfuvIrx8rCuAyOn+J3MctH94alA0pFpp7NYYx70Tmx9lvN2sf3pOxl7Zt/uBhHNdyakivOWm2Fvq45rB1qOXcviAyP4s1La2yLV2pxg2emgABvpl+0mf56WQ2Itzp2WIPoLK3KmLlOS57H1yiF/7QMGhnDt+W7UFYS0wmTm4QqezNbGhWm56TwKtKa+TwEzY7pCi+YK/UKYDQlwYrZMQsLEBYObQQajhlCtvA06eycIaGi36HoA2KM6/oRkQWTDfVOHLZePCLfuXV1OQUs8d7UlCSkzade8RC5xdNs9IcsZxmP/f/J5/SyAjQ82JTBpxBuil8mE8BF0q/gMFnkFJ9bZNCpVNj+P1mdH1buLwTaECvG/bBFvwU0FfczmKn7de9sUNm2K6s8ecl3vfEsIki2rSyJPCwVpNmKSxW71ia2GAtUt2D3ohtutYgYD4LqFmU3WWovZPHX8BXhte+e+gyQTDH7O4BT7yZOXsYzQoMLKegNzx89wrjliAb25gKL3aEa9Abb1fhHvmibJdpr3YxXok+jjtCAZzy8xrmECffMmPKXFEk+IblAxgdcyjpnO0hjozaFOQJxKa+my7UkyFhOQW2Xul3CwUa3Ns7nDsNYqmK7VjTydtIVz8GZGhQoVSsy1ggnev
 Ka7nUfCy
 a7AAFR0pUh7/USvKpVMhrCq+Pl+lXRvgfTVAZGVayqR53rCph+MPkjkdpruMvSJtrxH+n2jdRc1P43MA+B9OTXoge+EXL92T4NZAtwXcN+UQNU4vwQBRcpb90vtwt3I2uy8DmL6DdoZNrdo9UaVXBIGFt1i0FSFOUbSX36BcWXat0r3fXcFBjFeXgVs2rtJM8QlcprLZ2UUy9QOBX2t52DnjUlQDFz+u+OYDf1nyvs1k1sEuF3JH8qwAAWgbxLqxspRmWW7orMqfs4vtXxVVbGUmGOxac83C2XIfu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function allocates and then refills and empty sheaf. It's only
called from __pcs_replace_empty_main(), which can also in some cases
refill an empty sheaf. We can therefore consolidate this code.

Remove alloc_full_sheaf() and refactor __pcs_replace_empty_main() so it
will call alloc_empty_sheaf() when necessary, and then use the
pre-existing refill_sheaf(). The result should be simpler to follow and
less duplicated code.

Also adjust the comment about returning sheaves to barn, the part about
where the empty sheaf we'd be returning comes from is incorrect.

No functional change intended.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Just something I noticed when applying Qing's hotfix, thus a followup.
But since it's a cleanup, it would be for 7.1.
---
 mm/slub.c | 57 ++++++++++++++++++++-------------------------------------
 1 file changed, 20 insertions(+), 37 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2b2d33cc735c..a8347b79e46f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2822,24 +2822,6 @@ static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 	return 0;
 }
 
-static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf);
-
-static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t gfp)
-{
-	struct slab_sheaf *sheaf = alloc_empty_sheaf(s, gfp);
-
-	if (!sheaf)
-		return NULL;
-
-	if (refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
-		sheaf_flush_unused(s, sheaf);
-		free_empty_sheaf(s, sheaf);
-		return NULL;
-	}
-
-	return sheaf;
-}
-
 /*
  * Maximum number of objects freed during a single flush of main pcs sheaf.
  * Translates directly to an on-stack array size.
@@ -4611,34 +4593,35 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	if (!allow_spin)
 		return NULL;
 
-	if (empty) {
-		if (!refill_sheaf(s, empty, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
-			full = empty;
-		} else {
-			/*
-			 * we must be very low on memory so don't bother
-			 * with the barn
-			 */
-			sheaf_flush_unused(s, empty);
-			free_empty_sheaf(s, empty);
-		}
-	} else {
-		full = alloc_full_sheaf(s, gfp);
+	if (!empty) {
+		empty = alloc_empty_sheaf(s, gfp);
+		if (!empty)
+			return NULL;
 	}
 
-	if (!full)
+	if (refill_sheaf(s, empty, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
+		/*
+		 * we must be very low on memory so don't bother
+		 * with the barn
+		 */
+		sheaf_flush_unused(s, empty);
+		free_empty_sheaf(s, empty);
+
 		return NULL;
+	}
+
+	full = empty;
+	empty = NULL;
 
 	if (!local_trylock(&s->cpu_sheaves->lock))
 		goto barn_put;
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	/*
-	 * If we are returning empty sheaf, we either got it from the
-	 * barn or had to allocate one. If we are returning a full
-	 * sheaf, it's due to racing or being migrated to a different
-	 * cpu. Breaching the barn's sheaf limits should be thus rare
-	 * enough so just ignore them to simplify the recovery.
+	 * If we put any empty or full sheaf to the barn below, it's due to
+	 * racing or being migrated to a different cpu. Breaching the barn's
+	 * sheaf limits should be thus rare enough so just ignore them to
+	 * simplify the recovery.
 	 */
 
 	if (pcs->main->size == 0) {

---
base-commit: 464b1c115852fe025635ae2065e00caced184d92
change-id: 20260311-b4-slab-remove-alloc_full_sheaf-b3404881d45f

Best regards,
-- 
Vlastimil Babka (SUSE) <vbabka@kernel.org>


