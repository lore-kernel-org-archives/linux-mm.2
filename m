Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA629F55438
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 01:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADAAB6B0088; Tue, 24 Feb 2026 20:40:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B266B0089; Tue, 24 Feb 2026 20:40:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B23C6B008A; Tue, 24 Feb 2026 20:40:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 882096B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:40:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 250B41603A1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 01:40:07 +0000 (UTC)
X-FDA: 84481273254.27.B66274C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 58FC2A000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 01:40:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r+Vj8Idc;
	spf=pass (imf25.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771983605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2lrtnCoSoNwjyL4LqElnlh0t+81G2x+kNbA8gOHQzuU=;
	b=yHTMRhPhSywjqqTgWEkK29r2TD+w2FSC0bHCy9yhzhqNM9Dd2WCNo+cX2CCpKMsWp6yQ/e
	eEZy8MzxSUgvmS12kIvs9a4/CrPKNrRu52lLT21uwp5AMYpREuaC03WWuED+F3RItTJ7Lh
	jNQoaQe7HdbIVIl27m749lkh25q06TU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771983605; a=rsa-sha256;
	cv=none;
	b=iNEPzJLIp5XyTP9mmTw7kiUmWn1W1Lj9BpFgGFzrrh6Cg1BKXGYl5gxyjSrA+OGbqpB3Al
	fy1Cjh+PVhA5INJTHNMdeynyKpFwcEFkfXfsNGRt08CblT4pbXJajEhWhrmbiI2CeGhbqi
	l8E7sE1j4JjpX7bZ1ulb54AzAePafJY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r+Vj8Idc;
	spf=pass (imf25.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3743341726;
	Wed, 25 Feb 2026 01:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15146C116D0;
	Wed, 25 Feb 2026 01:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771983604;
	bh=/vhqQFuGoe48JWJKQbmTtsW8NfhyeO+Zgc9RwDLnpHU=;
	h=From:To:Cc:Subject:Date:From;
	b=r+Vj8IdcOLhJtUtOQzh254rqvzA3uB/Iye7mW2zJnKE1QoXEBJZwneCUmDAMQSl63
	 7mHUl0l92fNWBWeeNR/ikW1O6FbCag2yrnh5OAlaQatcoNr3zfCK1v1vsWF0FKqA9e
	 8dW4DoHYKeMyLD6z93jef3FZco/su92gf6Nicx2RFJvCeucfO27dUq1CzyC7hS+iqk
	 EcdGcm2ALXOgaR4cdZ2/e2wMfGzFymM6111pCjwIosZnBu03Db/elcQmwAvLrq13b6
	 mWFkahThS0zCNqtezFIpfYCWQwbEcOoK5zKXviU67EWgtWFgfGtWx5itFIN2XzA6KP
	 VHPAXFFU5J6ww==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] slab: Saturate to SIZE_MAX for allocation size overflows
Date: Tue, 24 Feb 2026 17:40:02 -0800
Message-Id: <20260225013954.work.319-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2209; i=kees@kernel.org; h=from:subject:message-id; bh=/vhqQFuGoe48JWJKQbmTtsW8NfhyeO+Zgc9RwDLnpHU=; b=owGbwMvMwCVmps19z/KJym7G02pJDJnzgj7G3faYZqv3iPHMylti0ey+N15vWpz6ovTHke3+h 5tZrvot6yhlYRDjYpAVU2QJsnOPc/F42x7uPlcRZg4rE8gQBi5OAZjI88+MDCunsujwCF3b7cWt PPPyMd6Dt4vilMQ8YxcqG4Ss/sta2sLwh2+H4YHUnGcW0Q+fx/zYL1XXriwetf+/ZkvAoY4MVi5 jBgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: joac4uq9arf3rqdo1k7ik7txse68pm8b
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 58FC2A000E
X-HE-Tag: 1771983605-928610
X-HE-Meta: U2FsdGVkX1+vHB5EhlDoTUvnI6uaHiagcWD8lWPe8nT1Y5/V4AYoST3wBLoReysYfwfyBPra0Jnm6qlfzv8cnvcXjlauuRk8r6wioEaPxtQbnUd2hooxBhGjW+01PScPL2Zj5haDQaMXeh23uDoIwwPvYYAZWLeglIRC2mO3GoS244TFyI1FJP6UBJNWmZPLhUbY1Rd6Ed0VsjQ6oRUFj1z6mi1mg9GkBSifqf6Pt7ViAT+APn9QIi4GJvMnc+GrsZd4/zEZUiqfoNyTTrWAaruWY/brcOC+Jq8mKMUCz6+zpZP9H73z+yLgN/s9sqnAATOEE20T4eUo26AYsznCalXjbFpaodK3PJzzL9NqydN7isFNOJSuU1UWA+u+xaeTVzIq+oukmZsIMWTR43I4jKWgejLEbR+kKHcd+HJPO6LVD903zzCqi/8cGs5+7glDu4RB39kikxszV1K0bCIZjFtOQB+ym07Sf7vSYwEULsh81nmLl+QFsPKsCp0aMZJNpRCX7tOZb4g6qDqsMRhyX4pY8SC+QVqBx1GbqIrLlkYWfu63O0YgJdTg0ZnkXA7qqZQ7DA0KULbnURMnd74GgseUjWBaIM5nraEeZ6Y+XBK2NtmJgEAgYq+d77cvvdUHeN8UYkXsN+5UcMEJZmykEnyjJ61KJui+v6C3L2wRhBrGKmFRdcnFEyMuN18BRrYuqcT/fE7MSL3tuE78N1Ta3PR/oLSYeOKRZ3LEP/RyjQ4CDgYWy7Q6CcVqab1MBe8Lyym1w+HC+aikpHnhhim44Wj1p+M/WhAR0Bzl3n5TIBgilAKZ7VR7c95EHl1V8So61VHOHKXoZs5gRLFdvgHjb8677OkpdQI3FLAFWmEKUumUC1wHizJISxScDRZCj6bU2kf+VZOXg6wVCTPQPIYh8SO989ayuQAOQ72Ua+jxVRCgmR5kceGlDHjMsTYKVLdmu/aA+a9dKnL9nWyH/k/
 n8Jjm3NL
 6vNG1mhungjR/OILLGwUQTUwqbIP/8eJxswR2qky+5bDFl3Da51TJFSfZKmbc+lIrVI0oh4pYDszxqc6BHK2WFoUHZGETuRaTxAja9UkE56nSRgP5nwpgcLEeSe1Y6XdXU0Zh75y+6kBFrFcchVHM2yS0xgc0MK8mlsBnHj7bvRI6A56jbkB6xZAZgwA2mGcvBb1c/hDvGiWFbZMcFiqysTO6sf+c15cyAxpaWxrT3jpvq5n+L3wknXB8FVpoj+9Qt2lPNyagSMcXBVNDt4e/1UEGKTabB6cbroy+Go++Zp4Ble830TCbtVSsueMM1s2OWGn/AJYRHTCVKLYTfsLGEcYYkbGrGO29f1dfb4R9B3dVIpRUqZEkYjYd/irnj3og0llsnD5neYfOvTb+yCcXwAl56eybTODbVoFtVtLePUojTFNM3TSSpZziynbHqLl4GQNv8Smri8mDnXjiY2FnkneH1Um+LCsU31PR41dciUNbLjXzhqFtLu5vFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of silently returning NULL on size overflows from array
allocations, saturate the request to SIZE_MAX so the error will be
surfaced to the allocator (and still return NULL).

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/lkml/a144cd1e-8bfc-4380-8f1b-071db0af0b2c@suse.cz/
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: <linux-mm@kvack.org>
---
 include/linux/slab.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index a5a5e4108ae5..8453c81c75c3 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1105,7 +1105,7 @@ static inline __alloc_size(1, 2) void *kmalloc_array_noprof(size_t n, size_t siz
 	size_t bytes;
 
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
-		return NULL;
+		bytes = SIZE_MAX;
 	return kmalloc_noprof(bytes, flags);
 }
 #define kmalloc_array(...)			alloc_hooks(kmalloc_array_noprof(__VA_ARGS__))
@@ -1135,7 +1135,7 @@ static inline __realloc_size(2, 3) void * __must_check krealloc_array_noprof(voi
 	size_t bytes;
 
 	if (unlikely(check_mul_overflow(new_n, new_size, &bytes)))
-		return NULL;
+		bytes = SIZE_MAX;
 
 	return krealloc_noprof(p, bytes, flags);
 }
@@ -1175,7 +1175,7 @@ static inline __alloc_size(1, 2) void *kmalloc_array_node_noprof(size_t n, size_
 	size_t bytes;
 
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
-		return NULL;
+		bytes = SIZE_MAX;
 	if (__builtin_constant_p(n) && __builtin_constant_p(size))
 		return kmalloc_node_noprof(bytes, flags, node);
 	return __kmalloc_node_noprof(PASS_BUCKET_PARAMS(bytes, NULL), flags, node);
@@ -1223,7 +1223,7 @@ kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node)
 	size_t bytes;
 
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
-		return NULL;
+		bytes = SIZE_MAX;
 
 	return kvmalloc_node_align_noprof(bytes, 1, flags, node);
 }
-- 
2.34.1


