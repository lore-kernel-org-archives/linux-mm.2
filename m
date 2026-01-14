Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 065A6D3CC83
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 21:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 283DA6B0005; Wed, 14 Jan 2026 16:59:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2319C6B0089; Wed, 14 Jan 2026 16:59:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 131FD6B008A; Wed, 14 Jan 2026 16:59:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 007E26B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:59:14 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9091B140115
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:59:14 +0000 (UTC)
X-FDA: 84331935828.19.6A6EDD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id ED78C140011
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:59:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wET43oyI;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768427953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ls1vMTPNH6C6ZjGDWQDJ5Pv413rPFajVkIc5qmQcOjs=;
	b=qqMK5L8nh9QLN/XO6KVXt+CYgd4NTTk7uce7ebywRnzcjQTBQ4JQx3u6gGpbYv50hsITCf
	4exQ/np1AQq/AxETvamUxecynp+TEdaZN5JStRn8Lu68Qn+CkBrmZKkstKPNOAEpWQQBlS
	bOTyaknhu8yNRzeOvN80NPL80kX9Uo4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wET43oyI;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768427953; a=rsa-sha256;
	cv=none;
	b=0D6zVrLhjNamNfLcOfhQy1myeuFcO6cn+wLPzv/Z0IBZhix18b/tmolznhPo7aZ10//rPc
	x2EUgwgkQ8xXnDdvxIC0ZedFBo1xv1seZFSe46+bQgOnAhEifTQfduSQ+PeC2L21UkVSGr
	RLU6eV0BTsNrIrfYKNwMFxc2VW0RDH0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 60E906000A;
	Wed, 14 Jan 2026 21:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D43EC4CEF7;
	Wed, 14 Jan 2026 21:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768427952;
	bh=SXebcg9o/uP6bArR+TzUpWvUCrf2pKPfYJVQVsTWlpo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wET43oyIVu+GL4MY407GXNoKFFDmkgYfRtDfmG+hwEBny0m51L6i+vz1f5QDkpR+d
	 Zj4oj/w8jmz/wv9D2OoY1xLdK+4truo8UO5DVdb4b51nX8QUw1QLWaJZBJoyoLjvuz
	 KWP5LzVUXoIG0amPxCpBGxvwEqWMAetJLVsG/lFs=
Date: Wed, 14 Jan 2026 13:59:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt
 <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, Rik van
 Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn
 <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko
 <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>, Chris Li
 <chriscli@google.com>, Barry Song <v-songbaohua@oppo.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/8] mm/rmap: improve anon_vma_clone(),
 unlink_anon_vmas() comments, add asserts
Message-Id: <20260114135911.ed54bc17bf1e467ad96f5b4f@linux-foundation.org>
In-Reply-To: <6fb9d6b4-ad39-41de-8db0-aa41a6406378@lucifer.local>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
	<5f55507a877028add5fdf8f207f5e333c7a3fc85.1767711638.git.lorenzo.stoakes@oracle.com>
	<6fb9d6b4-ad39-41de-8db0-aa41a6406378@lucifer.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5ahwej8zkm7n4pckd6h98j33ai9r4or4
X-Rspamd-Queue-Id: ED78C140011
X-Rspamd-Server: rspam04
X-HE-Tag: 1768427952-769340
X-HE-Meta: U2FsdGVkX1+A09oPvMqYdSdFB8s5kbnKiUTbOhdnr84H73mkX/kdw08xXiSDgoyfrHAK2yeju49ALl5hcwdXIODnxmtWwlZ+7b+aCZNOf1H397IDBD/otekENZnHQ5UDWlT34W/12nTz3qJdSO0CmWwZDNRF9zkGMrvZAiCeIaSHYIy/bWLjxbXC9gaOw/KP76Vwm10OeiEO8ewAcIDLG1TWIeDirK44YG6MqoVWLRRG2DaLRFL+b5XBPy7j65cH5kK5YYo6Dz5epK3vmBupVX/gA1B0xExaIKf3D1tegOMuKjfb9deo453IVzVwCmBaBg0SlIRSiuUw/pOwvYljoykmNyHmR5zd1HxLSjbATrQBnsP7v2qpnRZ4lbkRfN4vyDrkZlA7lM05VoBoeJ3QFKcysso6JQI3sLhVYuiidT+D6YeYB15PI4qw7CgI/6Dp2Az5V+Lz5cVW9XdI47DEYNijgVdIZ/0EQ0KVR3FZcQ1SvsxoAFaTcD3jzcb6pqtuSVchMXk/Rh3leSPDITZgm8vYv3zYSkNMz4/QT/+TN21MLozMMs9i3hb9UaLyW0gb+irl7F4+Mi3QZW/0gGEv2BKsfdrpl2MpHZmMkqG7duYRLts2LW9W4t1iGpMhkTnQH+S7qr/0kHeJgrhka4XJU5UVGNwPSYkIsC7HX9KrBVGFjzoWR2kNheRFKDYD3duCII8CPWYjN+fVjDxRqOXiPKEkxT8/uF3cs1bsVGwGzdZj4/4DT2rzPaCzSwSrPtHgcD6CkUGI0ZBmvYiYFSsWkbYydZpfpOD7Ll7fbSNbxLT2d5ZLRwJHef5OA6B7o6azoytB2rdPdGdCVnTl2/uJQdJ7jZy/STwQ/eFlN77IzbvVhUIqYdI/ZUlJIEiyTJpp0giJSDmGB1/7Fuk+ZYOPkkjLdCUbGQ3A3VZ7jrInUV8C7WjnwTGujmu2719wPpNHm6U7+aRz5Tc/OaY2m0a
 P2AK0zGL
 cFJpb/LLD9f0BU64Uu3MaqWViyBybNuqXcyYIa3jPOz1+wKN2rW1JL/HOu3421g8Q87GO/ey2+DwbojNexeKcIOK9GIfElA+0/pj5DhnbUPH4RbVknEacfXe43L3Kz5cr3HN+m5SGLSw22B9hhLy3PYvNnlzNalsl4yAJhV9q4F6Prr832Ck/jp3Aolg/jCenk5pCbRG1QuAOXe+Do480vTuyAL1d1x4pniDxT9NRv5LMIcE9ZAWipED/TyRzX1BoOa4IvbcOUf3Tm62OhPfU+g04nwESTM+KuyEqsfESsfn6HCNzaibT7xQfbvAHKoNvFeex
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 19:02:20 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Can you apply the below fix-patch to this to fix up a rather silly
> failure-to-unlock mistake that Suren picked up on?
> 
> Luckily this partial unmap function is unlikely to ever be triggerable in real
> life, AND more to the point - a later patch completely eliminates the locking -
> but to avoid bisection hazard let's fix this.
> 
> Note that there is a conflict at 'mm/rmap: allocate anon_vma_chain objects
> unlocked when possible', please resolve it by just taking that patch and
> dropping _everything_ from this one _including_ the trailing 'if (root) ...'
> code.

No probs. 
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch is
now

--- a/mm/rmap.c~mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible
+++ a/mm/rmap.c
@@ -147,14 +147,13 @@ static void anon_vma_chain_free(struct a
 	kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
 }
 
-static void anon_vma_chain_link(struct vm_area_struct *vma,
-				struct anon_vma_chain *avc,
-				struct anon_vma *anon_vma)
+static void anon_vma_chain_assign(struct vm_area_struct *vma,
+				  struct anon_vma_chain *avc,
+				  struct anon_vma *anon_vma)
 {
 	avc->vma = vma;
 	avc->anon_vma = anon_vma;
 	list_add(&avc->same_vma, &vma->anon_vma_chain);
-	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 }
 
 /**
@@ -211,7 +210,8 @@ int __anon_vma_prepare(struct vm_area_st
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
-		anon_vma_chain_link(vma, avc, anon_vma);
+		anon_vma_chain_assign(vma, avc, anon_vma);
+		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
@@ -292,21 +292,31 @@ int anon_vma_clone(struct vm_area_struct
 
 	check_anon_vma_clone(dst, src);
 
-	/* All anon_vma's share the same root. */
+	/*
+	 * Allocate AVCs. We don't need an anon_vma lock for this as we
+	 * are not updating the anon_vma rbtree nor are we changing
+	 * anon_vma statistics.
+	 *
+	 * We hold the exclusive mmap write lock so there's no possibliity of
+	 * the unlinked AVC's being observed yet.
+	 */
+	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
+		avc = anon_vma_chain_alloc(GFP_KERNEL);
+		if (!avc)
+			goto enomem_failure;
+
+		anon_vma_chain_assign(dst, avc, pavc->anon_vma);
+	}
+
+	/*
+	 * Now link the anon_vma's back to the newly inserted AVCs.
+	 * Note that all anon_vma's share the same root.
+	 */
 	anon_vma_lock_write(src->anon_vma);
-	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
-		struct anon_vma *anon_vma;
+	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
+		struct anon_vma *anon_vma = avc->anon_vma;
 
-		avc = anon_vma_chain_alloc(GFP_NOWAIT);
-		if (unlikely(!avc)) {
-			anon_vma_unlock_write(src->anon_vma);
-			avc = anon_vma_chain_alloc(GFP_KERNEL);
-			if (!avc)
-				goto enomem_failure;
-			anon_vma_lock_write(src->anon_vma);
-		}
-		anon_vma = pavc->anon_vma;
-		anon_vma_chain_link(dst, avc, anon_vma);
+		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 
 		/*
 		 * Reuse existing anon_vma if it has no vma and only one
@@ -322,7 +332,6 @@ int anon_vma_clone(struct vm_area_struct
 	}
 	if (dst->anon_vma)
 		dst->anon_vma->num_active_vmas++;
-
 	anon_vma_unlock_write(src->anon_vma);
 	return 0;
 
@@ -384,8 +393,10 @@ int anon_vma_fork(struct vm_area_struct
 	get_anon_vma(anon_vma->root);
 	/* Mark this anon_vma as the one where our new (COWed) pages go. */
 	vma->anon_vma = anon_vma;
+	anon_vma_chain_assign(vma, avc, anon_vma);
+	/* Now let rmap see it. */
 	anon_vma_lock_write(anon_vma);
-	anon_vma_chain_link(vma, avc, anon_vma);
+	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
@@ -402,40 +413,18 @@ int anon_vma_fork(struct vm_area_struct
  * In the unfortunate case of anon_vma_clone() failing to allocate memory we
  * have to clean things up.
  *
- * On clone we hold the exclusive mmap write lock, so we can't race
- * unlink_anon_vmas(). Since we're cloning, we know we can't have empty
- * anon_vma's, since existing anon_vma's are what we're cloning from.
- *
- * So this function needs only traverse the anon_vma_chain and free each
- * allocated anon_vma_chain.
+ * Since we allocate anon_vma_chain's before we insert them into the interval
+ * trees, we simply have to free up the AVC's and remove the entries from the
+ * VMA's anon_vma_chain.
  */
 static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
-	struct anon_vma *root = NULL;
-
-	/*
-	 * We exclude everybody else from being able to modify anon_vma's
-	 * underneath us.
-	 */
-	mmap_assert_locked(vma->vm_mm);
 
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
-		struct anon_vma *anon_vma = avc->anon_vma;
-
-		/* All anon_vma's share the same root. */
-		if (!root) {
-			root = anon_vma->root;
-			anon_vma_lock_write(root);
-		}
-
-		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
-
-	if (root)
-		anon_vma_unlock_write(root);
 }
 
 /**
_


