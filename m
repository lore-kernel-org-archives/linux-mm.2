Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D992CD4F47
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 16:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA4A6B0098; Fri, 15 May 2026 12:24:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A3166B0099; Fri, 15 May 2026 12:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E854C6B009B; Fri, 15 May 2026 12:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6B3C6B0098
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:24:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8908DA01AC
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:52 +0000 (UTC)
X-FDA: 84770178024.07.3D52AA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B7E0E40002
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Jdj/KuQR";
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778862290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70+E13q9jG0Hg2LXQM7COK1itXgQ3nvP6O+GnJYck+8=;
	b=6VVnwXwxyJlbsnsJ++Kwp3yj4LOy7GuzuAtIDWJB2qtPJ/HTzTK6xKlfwvmZW0NEqAuB6j
	og3alJUQvbMIpf0mKUeFxx2iOkcm8O/9tMl65mKsZv9WrQsV7v8oiC1gQAxNZoGu9QLdhD
	cMe4lqKktDdIGhORDT6t/BTDkNNyJEU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Jdj/KuQR";
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778862290; a=rsa-sha256;
	cv=none;
	b=4SVAwNtnmIF/wvc/3oDxCCDm7e7Lm9ehAbi6/sFp/iyOZtJyjGCPORSOOk9rBe2pwvTdKg
	Q0rSADn21Mt/c+9ZAExY20Us2ee//zx25mO8fjN8qcANFQGrCgc14mJfkER0SmQJnJGQnO
	Dot/8jdpr8ePzy8DU1i0sLZATjl6qj8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 34CDB60098;
	Fri, 15 May 2026 16:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31E1C2BCB0;
	Fri, 15 May 2026 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778862289;
	bh=p7E51ELkjQ3iEfoGMpm7cOapjWiciEbqUEy1lvQfStY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Jdj/KuQRERrRriQ2EslwPMUFvOg+0uZhQtj1KSxohVCK8GzSivJVkseWGyo5e80cV
	 ZLrOgfCArxxH15U6/ohQWFmKr4zW611h7XtwPEzcy4+yLxLhjFR5d0LXXNfCK85G/6
	 ng/+GdVfghISC2xEnU+pO9vS9rC4+XHFmT6CQlua/YL78ZFlR4FjH9izhhwCjPHfzs
	 GIo4x/TuGKBYrAfS/rGwrrMjbDF3H03Z6cSruHE2PvTQnT5Yequs/F8EAc6EVFi/Yj
	 nW3sk3Jq9AE0dbYOQ+6u2e3LDtxlKt4WD0V9BLOdVmr3YtAGChkf6gfnJeNzWiDqAw
	 9bHNO0t7hCizw==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Sat, 16 May 2026 01:24:28 +0900
Subject: [PATCH RFC 4/8] mm/slab: allow bootstrap_cache_sheaves() to fail
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260516-sheaves-tuning-v1-4-221aa3e1d829@kernel.org>
References: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
In-Reply-To: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: B7E0E40002
X-Rspamd-Server: rspam06
X-Stat-Signature: ko59gomgrtmmcxh7mece6694x93uxoyh
X-HE-Tag: 1778862290-533394
X-HE-Meta: U2FsdGVkX19+nbFrN6I0oak0LOQgFm23KWQv4f9vjwdnN/mKe1xh6df0HlAD5eY62X8SATa/3P/IAtZn0RkpM4ShmS8F1nTYwAigbPxsjWKQP0ZWbrjqem8MdxkJSiRq16M2fLmDsFzMkdAjn4XTxz7TfRE7vWzuLpG5lx34qJoHaUhTXs5SyRQPj5O4GZp/ZR/iu3HrLXWyrhj4bs+abUFdEwuoAoH+fMIgbb2g9c5fIPGKw9dBJM+c9pdzp8Oel4JW/ZUYB/DmaDyI+XIu4wsxtBYc8StBnUf1Fiq/YQ4oiHUReSzFVfSDLzsviRz9ANThj3EgwwD8e4raBz+kXwqt7+IyylXJjHhNiREaLYFAhrE+boK9cdnX6+D67wwYp70o3ZFquPlkG4f5i15Eh5tNqGht8x2i0uNWX80NXAM9SQ170/2Ia3jWBUu+FiWK1RyoQWskhy6vzkBZA8Zo8yldslNhk2dAAlX6+eLSs3x+eTwVrKP8nm5q9lCpJNONBsJ1Lm44lsWf+be1bgJmPFDuERR9mAVYIszOApbkesci5sIAifbU52jVtZn8Bpr1FItIUZg1MijFP0h/tEOiokKz+dizOAZwilr1O/SfGmE521T6lDyQPPTbA1kpUfmpUUK+UbMDGxL24obfhQUyRPTuZk9yd2Ps2PZEpzQCe0sTdumWuTiTGHD24vuRUh8LHIkyBGzr2K4iF2m31dtE4faD9n0ofsT+Hd/pJtfEySGHsdsXaez4IO1aBfYtmpgvCy5Ovf8XEB5JNXJvPNyoaeYJRahN3OG3pyPBRf7jLCB4LI0V3TAiJK6qQ8VgEwuHSdXGsv7FsSH5+h04EGYVZ6XMZ8x4vNkxS8K1fCe4VO2QaixZx0EqKz4hn3OwNL828bMSX5VrWnNtxHKxu3HDdZyxud70F99KJvLXVWfpWhG9tOj4sY/QNIH3tiAh8XG0uq1sHUIoqLuydjIIpR0
 ILTbN0DJ
 KAXjVDNG8EbxtIQySd9h/VyMUz1qar9moi3PVTNm/QOOaCkPhbndEhfjHg9FE4DI7fILBwxpnJmAFmqQz7BshdRLhIgJgHDT/Ocr5en/IiKzehRYaxheC4O44RygqnbPIQl3EHDUC7lQxvN7u7DL+XPznuTR2WiLrS19Sfo13TyClSipmDenQVXbiBliSiKUumODCV/pdHelA3siDaguLTSQm2CdBKBrFGbVJpwiCPOnvGqjXSIRPD+flwcHtyNg8BlEn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Panicking on sheaf allocation failure is acceptable during boot, but
to allow changing the sheaf capacity at runtime, the bootstrap path
must be able to propagate errors instead. Return an error code from
bootstrap_cache_sheaves() so callers can decide how to react.

Change it to return an int (0 on success, negative errno on failure),
accept capacity as a parameter, and drop __init. Callers without a
user-specified capacity pass zero to use the default capacity
calculated by the slab allocator. Failures are now handled by the
caller.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slub.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 44f36ae32570..fb98d0da5c78 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8462,18 +8462,18 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
  * init_kmem_cache_nodes(). For normal kmalloc caches we have to bootstrap it
  * since sheaves and barns are allocated by kmalloc.
  */
-static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
+static int bootstrap_cache_sheaves(struct kmem_cache *s,
+				   unsigned short capacity)
 {
 	struct kmem_cache_args empty_args = {};
-	unsigned short capacity;
-	bool failed = false;
-	int node, cpu;
+	int node, cpu, err = 0;
 
-	capacity = calculate_sheaf_capacity(s, &empty_args);
+	if (!capacity)
+		capacity = calculate_sheaf_capacity(s, &empty_args);
 
 	/* capacity can be 0 due to debugging or SLUB_TINY */
 	if (!capacity)
-		return;
+		return 0;
 
 	for_each_node_mask(node, slab_barn_nodes) {
 		struct node_barn *barn;
@@ -8481,7 +8481,7 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 		barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
 
 		if (!barn) {
-			failed = true;
+			err = -ENOMEM;
 			goto out;
 		}
 
@@ -8497,31 +8497,37 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 		pcs->main = __alloc_empty_sheaf(s, GFP_KERNEL, capacity);
 
 		if (!pcs->main) {
-			failed = true;
+			err = -ENOMEM;
 			break;
 		}
 	}
 
 out:
-	/*
-	 * It's still early in boot so treat this like same as a failure to
-	 * create the kmalloc cache in the first place
-	 */
-	if (failed)
-		panic("Out of memory when creating kmem_cache %s\n", s->name);
+	if (!err)
+		s->sheaf_capacity = capacity;
 
-	s->sheaf_capacity = capacity;
+	return err;
 }
 
+#define for_each_normal_kmalloc_cache(s, type, idx) \
+	for (type = KMALLOC_NORMAL; type <= KMALLOC_RANDOM_END; type++)	\
+		for (idx = 0; idx < KMALLOC_SHIFT_HIGH + 1; idx++)	\
+			if ((s = kmalloc_caches[type][idx]))
+
 static void __init bootstrap_kmalloc_sheaves(void)
 {
 	enum kmalloc_cache_type type;
+	struct kmem_cache *s;
+	int idx;
 
-	for (type = KMALLOC_NORMAL; type <= KMALLOC_RANDOM_END; type++) {
-		for (int idx = 0; idx < KMALLOC_SHIFT_HIGH + 1; idx++) {
-			if (kmalloc_caches[type][idx])
-				bootstrap_cache_sheaves(kmalloc_caches[type][idx]);
-		}
+	for_each_normal_kmalloc_cache(s, type, idx) {
+		/*
+		 * It's still early in boot so treat this as a failure to
+		 * create the kmalloc cache in the first place.
+		 */
+		if (bootstrap_cache_sheaves(s, 0))
+			panic("Out of memory when creating kmem_cache %s\n",
+			      s->name);
 	}
 }
 

-- 
2.43.0


