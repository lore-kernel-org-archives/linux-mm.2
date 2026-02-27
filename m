Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B09B7FD9E3A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19FB86B00DB; Fri, 27 Feb 2026 15:10:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 157716B00DF; Fri, 27 Feb 2026 15:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021EE6B00E0; Fri, 27 Feb 2026 15:10:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0ADD6B00DB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:10:17 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A30621A0961
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:10:17 +0000 (UTC)
X-FDA: 84491328474.29.8FC4404
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0F6FD18000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:10:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VgnVpkaH;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNXJ3lchDes2Cf/t7ldca5KjaC3s+A85b9AScdfhZoQ=;
	b=tNj2QtAxqfJPvSNBE60qdyPxKUfIFZEcI4JHifDKhIUd6qojPg52E21cRz+OzlFfuwoglA
	cE6rRxE4iIUQ6YRQLXtS4dpGkrfN8nIhlWUjg2wITSmP5Wa6kes7Bn8HqYLoI3X/5v7dgr
	4v/0JDi+pDieetohkbI1yRMynIMBb3A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VgnVpkaH;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772223016; a=rsa-sha256;
	cv=none;
	b=U2eNDeP9NPqniGSJeLVw+TLa3HoiLe+DWGJBU3/v+4Ybuw+8ss6uk7ioYMSordiEHBrVOL
	tlZnZrwWlel+nPUrQtMPwdcEpCRSkJGM12mwulQKJK3Jrl6NzOLM+ZK3K6PNsJUqA023UV
	bkUX7U4LqaBCyANrC9NLt3fQbKvJ9Z4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4085E60130;
	Fri, 27 Feb 2026 20:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E261C116C6;
	Fri, 27 Feb 2026 20:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772223014;
	bh=hLgJdGT31V5wnxVFe1vHLMNm/KVuWNy5vLAGWsJg21c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgnVpkaHaAkciLTAeL0+EHoy6ULSwuu9fj3VyFkgJooaJcw9CuTij8hQME2UbVNWD
	 Yvc/lVRhwFa8DPT/JmgPCmNWacY7labSQ2afT1BQfoxShbwEJk2Jn8z7NxsGfCsqtz
	 PFpbCDhsNtcpqdguKU2gvD4AUwof1y66dauCjiXbAiMN6CyWf4CltYotNxCjssrHCp
	 /q9YFMkt4jNd7FScndseUUa/D3NnepYZOmjVGGfCd+L3Hgug9STuzNp9OaPEgAhBvJ
	 WiDRQIsjsWJIIKTyzXG8Pn+MIUoCY9cTsDjzXp52+rtBZSOfNAH+NerJi1RRj2Hxlh
	 G0ODowk2+zwXQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "linux-mm @ kvack . org" <linux-mm@kvack.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v1 04/16] mm/memory: simplify calculation in unmap_mapping_range_tree()
Date: Fri, 27 Feb 2026 21:08:35 +0100
Message-ID: <20260227200848.114019-5-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F6FD18000B
X-Rspamd-Server: rspam07
X-Stat-Signature: staqfgddac7nfmefkd9y8z1rasqkzw65
X-Rspam-User: 
X-HE-Tag: 1772223015-312137
X-HE-Meta: U2FsdGVkX195lbot7eufRUauvDCXnDo1W61XE8K8EYFJ0gLqP+JYjj3otwEkEVKTloowWw9zAcCoQHtrZyIYJPmg8vQyR6BhaXS1BRv8pGrqpJ9NJ2U3L7PyyKzJsK9nsG9iIS3bOHQNcznyqYx/lN09ZMIwp/xjDpfy/8IuI5az3x0/SOQIBvrI5dVMlZLuJQFU0clVm0O1GbkVQae3XAmavQgmzKAKenl+qlQneKKgpsMXuIcQJWeFr6Y0v4hvnqB6+/dQ6Gtr4koHuw1NTgoZwTFqSyKYwCHi1pkIsjb5mX3JWN8ozNPjVUfz1QU1j0kqo83OBe1483u/OCdu0cxQn7AoR5+Sbx3qXcfowMUxbaQqsWJlfVvNykdecDAaV35hwLfeqx3034O9AVipU0XGUeKak7V4wpkYjWG+U2uuoiSIBPh4mXWYW7RrXh5kw5ei0TalaVIntu2IncNm93pL1+Lx2N9hmNQwhA6x5MSRq286QNMlVYNY+OKPD+ZQq4Ylyy+EGVno4d2b6qvGHl2Jn0qo6YKboJuZpll3pt1F/gQPlNozSJL1fHHzFXLCyRxw7ywpzf3TYk88TigzlrYnguHGPDzXN3NRMUz9aY2QIkInec6HZyyoMgDV9tL2ATvXBybYhMjHRLOZnhMiKUuaFwjsFohbszKayrPVioib4f60p4Z2usRe2/wnX9p8KwCfDYsUrMT08tRNxT6KQ1IIQv8zeDiH2ivPUHsATKEp7QuVdNbjEQD3ruQvAwtwXcIfBj6EYoY6dVvSeTMODSNE8labhjLz5mHdMYLfu58jKbIjXKwfwkSRgoAUR6M822BlutQURG5v3D1pCjx38jJyusty2izO9iX0j7vNHJMVNbwZcN9ooVqSw6UnQ1Z4bd9AQxcLWqNkxdu4ZDXblML5U1bzhOUzJYJB2L+LeADEbuVKtXXEuHQdYBMhw0C8tJyM0fWIP3LYqBlNQQE
 Ye3gNz2J
 XIVPjPRtTOr0Dltzxs9Dfys6AO71PsgU5M9hLM3AvsZJn9OZTVc5dLfkSjcjlFIU3Kv9gdPVmNkXtL6qPnOmxzZoQ/5Tio0ZMs/r1rBQgrpyKHY+au9U6Ttv7c8JF5IHZNXORKJqHktJEtKRwtwLRva0aolvjkU4U8dR7pk01vIBv/BTpZwwIju4L26TiupWFC8G3k12Xh4E4eVu7EQxiwkFOwvzREoCXFtjh+MUmcy4rl91+Tj3sxErp3sdxlGNDU7Hhl05isJTVeCavt1zkRdqitpwqFvK85GXeOxfB2EFNQECcydDQjmk+BSyrlIHdP3DK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's simplify the calculation a bit further to make it easier to get,
reusing vma_last_pgoff() which we move from interval_tree.c to mm.h.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h |  5 +++++
 mm/interval_tree.c |  5 -----
 mm/memory.c        | 12 +++++-------
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a8138ff7d1fa..d3ef586ee1c0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4000,6 +4000,11 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
+static inline unsigned long vma_last_pgoff(struct vm_area_struct *vma)
+{
+	return vma->vm_pgoff + vma_pages(vma) - 1;
+}
+
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
 {
 	return desc->end - desc->start;
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 32e390c42c53..32bcfbfcf15f 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -15,11 +15,6 @@ static inline unsigned long vma_start_pgoff(struct vm_area_struct *v)
 	return v->vm_pgoff;
 }
 
-static inline unsigned long vma_last_pgoff(struct vm_area_struct *v)
-{
-	return v->vm_pgoff + vma_pages(v) - 1;
-}
-
 INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
 		     unsigned long, shared.rb_subtree_last,
 		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
diff --git a/mm/memory.c b/mm/memory.c
index 5c47309331f5..e4154f03feac 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4227,17 +4227,15 @@ static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
 					    struct zap_details *details)
 {
 	struct vm_area_struct *vma;
-	pgoff_t vba, vea, zba, zea;
 	unsigned long start, size;
 	struct mmu_gather tlb;
 
 	vma_interval_tree_foreach(vma, root, first_index, last_index) {
-		vba = vma->vm_pgoff;
-		vea = vba + vma_pages(vma) - 1;
-		zba = max(first_index, vba);
-		zea = min(last_index, vea);
-		start = ((zba - vba) << PAGE_SHIFT) + vma->vm_start;
-		size = (zea - zba + 1) << PAGE_SHIFT;
+		const pgoff_t start_idx = max(first_index, vma->vm_pgoff);
+		const pgoff_t end_idx = min(last_index, vma_last_pgoff(vma)) + 1;
+
+		start = vma->vm_start + ((start_idx - vma->vm_pgoff) << PAGE_SHIFT);
+		size = (end_idx - start_idx) << PAGE_SHIFT;
 
 		tlb_gather_mmu(&tlb, vma->vm_mm);
 		zap_page_range_single_batched(&tlb, vma, start, size, details);
-- 
2.43.0


