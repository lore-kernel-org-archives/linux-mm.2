Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08884606A334
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bdkq+wWL
Received: by kanga.kvack.org (Postfix)
	id 27AFC6B07AF; Tue, 24 Nov 2026 11:30:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C946B07B1; Tue, 24 Nov 2026 11:30:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119DE6B07B2; Tue, 24 Nov 2026 11:30:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB8D26B07AF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:30:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36F13140B72
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:30:13 +0000 (UTC)
X-FDA: 85470549906.19.784186C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 725F42000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:30:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bdkq+wWL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795537811;
	b=avP3QVeNSYKG68bdCnD9DsK2DXiwFh7rE0ll3GL+/H32b8vgWBt9fO2MiHNnzVh6TyjSl8
	5ilt9fARZ6BLamIX3fcR7PTes4ZDxKErvIf+E6O9MWvT06BCLfTtGetWXNDTV6EcSiA2qL
	djmLE1wYdqUBYYIqZ6u+yEf7DYBT+XM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795537811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6D9+I+ZmlOjtvLz+YOPIuvhffTkLTCvwIKyzYhBrqno=;
	b=w6KcyRwNZFXvLSAU/Fl4LZckX2GhDHM4LxsazmCFNnAyxZY5M3gCxAgKgTXQ+fwDz4tdx6
	uvafkdu/voJEjghE245cItRN7Pyp2Xhdp3kDD2bkkmueFaymP8/Gt8i1WUqO97GJT4ebkm
	DVMZiWcYe1hHF0luf3b6RyLMd2GLPCw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bdkq+wWL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D78F16279B;
	Tue, 24 Nov 2026 16:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C96A1F0093C;
	Tue, 24 Nov 2026 16:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537810;
	bh=6D9+I+ZmlOjtvLz+YOPIuvhffTkLTCvwIKyzYhBrqno=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Bdkq+wWLQce3hhRQ97zJL1Z8+g7iSSFsK3z6EXe4YQKfnV8n4AFfqk3ptRwJbZMig
	 pwPcxkKooNReAyYqtCTUNntA3ocABMBmlLg3s7PmnQ3zND02eexv0W6D578ZGlh38P
	 sknL6PKUHbEcmnM1MVU8CKGzublZI7Tb32zVMXMZlEL7uzhQ6dA7Rxe7QcYFHfN2SA
	 NBRBc73xlRho9Z4uMfT7f19+IgErYWg3jkjPO1B2hYD+zgMSIrQHsmJzpVY/nuF6c6
	 CJ9m3sqf9ZqkSrhVlZm8GkXV8BMZS/tpAuGUiNVXbU7VKYWqnGTi8gBbefgDGlGRfz
	 7o4dvohxO0jaA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 24 Nov 2026 17:30:02 +0100
Subject: [PATCH 1/3] mm/slab: add ___do_kmalloc_node() to deduplicate code
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-kmalloc-entry-rework-v1-1-37b1631a67b5@kernel.org>
References: <20261124-kmalloc-entry-rework-v1-0-37b1631a67b5@kernel.org>
In-Reply-To: <20261124-kmalloc-entry-rework-v1-0-37b1631a67b5@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Kees Cook <kees@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 725F42000A
X-Stat-Signature: 89ztw7fd9uuykjdzehfkinf7b9ci8ucp
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795537811-590843
X-HE-Meta: U2FsdGVkX18I8oM0VOYaDVj3nv7930EwoW04iOhUTvdeaKW9wskGiiWI+fCS6ebaLUts7yZ1kQYYeSbWmLX35t/oatZreVZwIja1QQHJ/0eFmvS6PSo5PL38aLloBpRn7fV++TymfzDSOazMoPPPvkznofmuSJ8nmxaA0lCzRWvW7iwPAWgQgHZxnR1YAB+E91z9SYSD22zy0pcdGce229WbU/eFjXuBMCuCPYPdLbUnzFfG2MFDUWzHe3TOc6CvtCFe1neQlw7JvhGbf5t3C5frAeVTY/oUXG/swNqH81dh5niRgdPkPrwsr023ydLG6OZ6b87yu07cRZlUq6pLtIfzf6mz+xHWNdzIvlWgeNP99e+iNm8Hr4VolYGfIaYF+HU02d8eBEzlDDzz0q957igYq60GcuqKEwqSDb1tncNu4UGeTkqOJt4KhBI8+qcjtxpDVNkuYLsaVNxazwCtRbh0UdfDq8tDIzeSju7U5kdWfQE4KqfpL2J/Wvx7e9+rL1+rEOw0lWM9KYVSN9jMg9qkzp58jnBAlfRndd+tJgFwWXoMQkJOuaNLeotMKf/GayOMUFTEQ36tCNfzcBgpxK45I3vUKktcC1At8+AmtWGnn6MqVi/mG9jNNQL4uXjtWEES1A75bGKtGUW5eQZbNHllBCGEFtV5dtCOAebdqaEa2m+95bwBO/No6Ywt6hbHV82ykyAV4aKLYOZX56HQGg7/nHxX3K/W73deZrd9h17hCL3JvB4+8HOOrCrnCGS7MdT+zyXbxMdhtT7kOLPVZmBAxuy40u9hKyqliXfNemOKqTx/kXCX5lYfIOhGNNHDTTXCaQFUoEUVS6Ctl4IMDOSVRlVWXvwR7zAaQc06ZflvHgOYy6O5xHOJWD4ST53mv5pZJ1ufmI85V9k59NMqkYyuQbqVP15bWyZrHgEi3zw0ONgvLhA5wy6+ZOrPvgnFvUqJ1Va/Vp49yvpb9Co
 Lx0QFBKo
 Qu673R3gXIZlJsiEazRIYvbDGMMihM/bsblvalaUz6/kpA/yzNc37zcHcwJodRxTbEaz+W//lv44apGIjkTOYA41TXU4+BR2uupd5nUoGdTkXUQZjlRECIt9fJY7BXEXSzgbiYO7m+Du7rOa5MbPPVnjqn+6pVeKHsUwe/QCZEV1U+4s2aSF5t3nfQeYK+Ea7eV+1dNlOu/qq/RYtBCk18KEmZMR40KVHQvbh1+IaTLk2EZqq/IXNdMof11AQ6aydpZFEmVfPPRQrcxtBBxvnIrrB0lB4Whg6UzQ16P4gfE9g6RDthBA/Tzw8se9x+JeSG/v3d5+4LxMXXRBSNzz1bJcllbNUAvLj3c3fa1Fw/JCtSBTEoy0S9aSQYMLuiwtC98Cszorj0Q4j4I5YCCcxCZvaHg1cwoJP8iB/NV/cd+i74Dgx+xAmdJvz8tBufwPjSs8PJSTFfqaFeh8nrQzHvY1M4HgXsbOanZrmdNMETI+iq7vEG7KWsRO5IBDVSSxmwelEEnm5sVeY87Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Most kmalloc family entry points end up performing __do_kmalloc_node().
What it does are roughly two phases. First, selecting the right cache
via kmalloc_slab(). Second, performing slab_alloc_node(),
kasan_kmalloc() and trace_kmalloc().

__kmalloc_cache_noprof() and __kmalloc_cache_node_noprof() already have
the cache pointer, so they both opencode the second phase. Add
___do_kmalloc_node() for the second phase.

It's useful to inline the first phase as some parameters might be
hardcoded NULL, but for the second phase it means duplicating a lot of
code to avoid any calls for the allocation fastpath. So let's try not
forcing ___do_kmalloc_node() to be inlined. It could almost be a tail
call, but isn't, likely due to the on-stack slab_alloc_context.

This is the effect on slub.o. Almost the size of the new function is
removed from all its callers, as expected.

./scripts/bloat-o-meter slub.o.base slub.o.1
add/remove: 2/1 grow/shrink: 7/9 up/down: 1005/-5353 (-4348)
Function                                     old     new   delta
___do_kmalloc_node                             -     768    +768
sysfs_slab_alias                             166     221     +55
sysfs_slab_add                               469     511     +42
do_kmem_cache_create                        1677    1714     +37
slab_memory_callback                         677     713     +36
slub_cpu_setup                               415     446     +31
show_slab_objects                            707     723     +16
calculate_sizes                             1328    1344     +16
process_slab                                1209    1193     -16
check_bytes_and_report                       226     210     -16
__kmalloc_node_track_caller_noprof          1087     382    -705
__kmalloc_node_noprof                       1092     387    -705
__kmalloc_noprof                            1100     375    -725
__kmalloc_cache_noprof                       790      62    -728
__kmalloc_cache_node_noprof                  827      57    -770
__kvmalloc_node_noprof                      1442     637    -805
__kmalloc_flags_noprof                      1307     428    -879
Total: Before=82451, After=78103, chg -5.27%

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index c35a50538d00..70df0a2e3876 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5512,6 +5512,23 @@ void *__kmalloc_large_node_noprof(size_t size, gfp_t flags, int node)
 }
 EXPORT_SYMBOL(__kmalloc_large_node_noprof);
 
+/*
+ * Deliberately not inline to have all the callers share the code, using a
+ * single call.
+ */
+static
+void *___do_kmalloc_node(struct kmem_cache *s, gfp_t flags, int node,
+			 const struct slab_alloc_context *ac)
+{
+	void *ret;
+
+	ret = slab_alloc_node(s, flags, node, ac);
+	ret = kasan_kmalloc(s, ret, ac->orig_size, flags);
+	trace_kmalloc(ac->caller_addr, ret, ac->orig_size, s->size, flags, node);
+
+	return ret;
+}
+
 static __always_inline
 void *__do_kmalloc_node(kmem_buckets *b, gfp_t flags, int node,
 			kmalloc_token_t token, const struct slab_alloc_context *ac)
@@ -5532,11 +5549,9 @@ void *__do_kmalloc_node(kmem_buckets *b, gfp_t flags, int node,
 
 	s = kmalloc_slab(size, b, flags, token, ac->alloc_flags);
 
-	ret = slab_alloc_node(s, flags, node, ac);
-	ret = kasan_kmalloc(s, ret, size, flags);
-	trace_kmalloc(ac->caller_addr, ret, size, s->size, flags, node);
-	return ret;
+	return ___do_kmalloc_node(s, flags, node, ac);
 }
+
 void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, int node)
 {
 	const struct slab_alloc_context ac = {
@@ -5671,38 +5686,26 @@ EXPORT_SYMBOL(__kmalloc_node_track_caller_noprof);
 
 void *__kmalloc_cache_noprof(struct kmem_cache *s, gfp_t gfpflags, size_t size)
 {
-	void *ret;
 	const struct slab_alloc_context ac = {
 		.caller_addr = _RET_IP_,
 		.orig_size = size,
 		.alloc_flags = SLAB_ALLOC_DEFAULT,
 	};
 
-	ret = slab_alloc_node(s, gfpflags, NUMA_NO_NODE, &ac);
-
-	trace_kmalloc(_RET_IP_, ret, size, s->size, gfpflags, NUMA_NO_NODE);
-
-	ret = kasan_kmalloc(s, ret, size, gfpflags);
-	return ret;
+	return ___do_kmalloc_node(s, gfpflags, NUMA_NO_NODE, &ac);
 }
 EXPORT_SYMBOL(__kmalloc_cache_noprof);
 
 void *__kmalloc_cache_node_noprof(struct kmem_cache *s, gfp_t gfpflags,
 				  int node, size_t size)
 {
-	void *ret;
 	const struct slab_alloc_context ac = {
 		.caller_addr = _RET_IP_,
 		.orig_size = size,
 		.alloc_flags = SLAB_ALLOC_DEFAULT,
 	};
 
-	ret = slab_alloc_node(s, gfpflags, node, &ac);
-
-	trace_kmalloc(_RET_IP_, ret, size, s->size, gfpflags, node);
-
-	ret = kasan_kmalloc(s, ret, size, gfpflags);
-	return ret;
+	return ___do_kmalloc_node(s, gfpflags, node, &ac);
 }
 EXPORT_SYMBOL(__kmalloc_cache_node_noprof);
 

-- 
2.56.1


