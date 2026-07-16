Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E3FC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 19:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86CB6B00CF; Thu, 16 Jul 2026 15:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10586B00D0; Thu, 16 Jul 2026 15:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FFCC6B00D1; Thu, 16 Jul 2026 15:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 666B66B00CF
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:38:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F100DA025F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 19:38:08 +0000 (UTC)
X-FDA: 84995650656.27.99B8921
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id BE25280002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 19:38:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LTnTyNuJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784230687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2ZOq4dcOvepgVVTva9wQ6lBd75ccF2O3Asl/sIYvfo=;
	b=ILWUlQ7g26jD++Ymf1rcZG2M7FUBACTMTEZ/QiUFg2Alsimw/+DupwZtrD0/S6iwUXlmBi
	zlgjoyR6C0Q1jKwzqaSZsCiSrkWFzRS5twLDbXXofeSGfjgRamXzTaq8m0AIQeVLvvy28l
	OCHCF7c4BAOJUncCPYbQ4YCGh7QiEmo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LTnTyNuJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784230687;
	b=eKl7NqjYCUmk54VhQH38s52wIIMj5IMWLb11D+YxnqKtIYVqcOWZ3xl7auzg2xLhQHDcEX
	0/2ucTpHffFxg3DAAc8dc3kD9oe1nZeSMNVJgIaXYcrP6HXBSsY6P4keElK5SS5Fyxq8Eo
	wwaFtfyIopzNoJIaFSY56widR9wurD8=
Date: Thu, 16 Jul 2026 12:37:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784230684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T2ZOq4dcOvepgVVTva9wQ6lBd75ccF2O3Asl/sIYvfo=;
	b=LTnTyNuJ23iroHykIM9DWrv5Mc+O853WCxFpELImlcaiqni67nE3vSlsN4B3i58rHJJmfg
	eqCChLNCNxO/mnMiL+QNF30S3vqP4JnMignVWSspJmANeC6YfH+aHds/LiPbhhc7jY2oL9
	S8tFD2tjlBv5OY1k2a2QtG+zyOED6X0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Suren Baghdasaryan <surenb@google.com>, 
	Hao Ge <hao.ge@linux.dev>, Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH slab/for-next-fixes v3 0/4] mm/slab: fix unbounded
 recursion in free path with memalloc profiling
Message-ID: <alkypcRUZa_r6uGV@linux.dev>
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BE25280002
X-Stat-Signature: odhdcr7h6joemsucyw3wsj4fma7gewy8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784230686-887046
X-HE-Meta: U2FsdGVkX1/zd794blwZLBLHmiptQX5pW3jEsjBc/wfkECkOmrl95QBF5rjqJueXzT8GAISF3AapYi2gt6vh5RJXeZzLnp8q90DjouSOkEAS7PyYMo2APSdhKTaNaxIeaSnCmyY9GGkWaHlZkH24VrvZDItcY9gX7SQ60gIY58DDteCqJdWBb4yYDvuBf+rNuVYnHcv1ebHjZ8uBMPN5MVIRIVO+9PFSDo+29x69SR8fIMqFx5KLey5926xrZa4ztARLkKV8QSGXapgjmgnJ+uvC5ux2ELoO5dCD6tGtH2gfIkwQ3oPkgPF6P+82+83mY9M8khnDggJ3dtiFQz5Ni3z/bh68RmWrNL/3sqVovVmTRA2P32qDOckrTwzvyG2KBv4UNpraYkXSjP/dlLGewuswsR6pZ9bczJCe31Yblfzo3ACL3GHLLHCsm5m5vNVCUjeQi6EhlLdzMd0t7FG6FsExsaXusVlJVDY91GQTwBtps6ML2V5WbGz1K47lz8zlU6DkTqJzm3I6iB1hYsgoW6x2uPhIklU5ng3IkQXoYHK3Wbfg4w0pAjw7ap4oWQ/OyhXzoQABr9FXDWmpr1OrNRVQ8pVcgfsNWfBO0+pyKsedS/qdbeY9twgWOdUwE4Vb2SwgMTiMeX7X7XU6HLwbsZGAE0sxO96+Qu8aDnuWekJ9tR3zVwa8PaY41lrObA0H4mq56xJhXMQrH6kR6SGQyIanJKAazPxnaz6yxJlXaHk/FHrSa1Xyf/fKvGCb4X4xF9qYHszZECtBWQlETQ3stJ7bvH2igBKKHSSpS+m0GvCdq4c+cbaQlvQ47iLShji+nJbebKV8Vvd2PMqK2kqeT6WAtUmMIRU8w6Ho5Gwl79Qy7Z44pLbdHs+fKlaOBXHiTMf0QXFNRbjA923T2/mGMAK68n/e7c26KlGQlGwACKR8yiCzaj/OfOwBzq2D9LeGg5gSHFIHw9NxYUB3tF5
 H12jLsSC
 7SwvSlvDhJUhbVWy3a2I+kOqDFo7+S5GcYKVi0eRgCOyxSE5Vf4lhaC2cdjz3eFn/dz1/T2bZngBxAPECeaaJmcQYKAJu6dn5jI6w9MYBN88h8QQidRyfRzjtUbCiCuKw7UMOOkgK3GzdXJHgh1yrVzCusMJa1LQe069HUZCCFF7hrl+8cXRbgdsOHCI7d0LlD5A7/m3hy/41dhdVO7w7e82aPU521JYV8g1YQCg2nADoRbiw6EVQXanxjGEMomJKeH8EQ6Tw9sjyh2hFyrBFz7c3hOnWFJOPWFQpM8NkCTQ7i9FfsTLDeSZSGMVbBAz/K/rJA4Toc3gfE7XyvHmwiGVL+DouHAtsrwPeea3ySShflOrFvAHYDxp19NedmvljrkISR0xtOznD//b1ucCd7UBKNbHQljTi2V32ymues/yMy26RsStNKCeur6jkvZc+OagL6svdVZVdcPsEQ58R8NCBzmHuVR/hJ0iCJBcAIquwPDP9IHh5U44YQusXX7DZz27rbPQ/iGZ0UJzD5rM1inUIktmNlv+FL12RTOiO5JrT0ss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 11:28:48PM +0900, Harry Yoo (Oracle) wrote:
> This is a follow-up fix after the recent discussion [1].
> See patch 4 for the detailed description on the bug.
> 
> Based on slab/for-next-fixes (af9ea231c0b45) and is available at
> git.kernel.org [2].
> 
> Instead preventing cycles by bumping up the allocation size of obj_exts
> arrays, it introduces a new kmalloc type called KMALLOC_NO_OBJ_EXT and
> disallow formation of cycles between kmalloc types when allocating
> obj_exts arrays. obj_exts arrays of normal kmalloc caches are served
> from KMALLOC_NO_OBJ_EXT caches (that don't have obj_exts), and all other
> obj_exts arrays are served from normal kmalloc caches.
> 
> I tried to reuse SLAB_ALLOC_NO_RECURSE to make kmalloc_slab() select
> KMALLOC_NO_OBJ_EXT, but it was not great because it does not allow
> sheaves for those caches. So I introduced a new slab alloc flag
> SLAB_ALLOC_NO_OBJ_EXT.
> 
> To avoid huge confusion, I had to decouple "disallowing sheaves"
> semantics from SLAB_NO_OBJ_EXT and introduced SLAB_NO_SHEAVES.
> 
> While this cannot be directly backported to v6.18 and v6.12 due to lack
> of SLAB_ALLOC_* flags and kmalloc_flags(), I don't this will be
> particularily challenging to backport it. Instead of a new slab alloc
> flag, we can use __GFP_NO_OBJ_EXT to select KMALLOC_NO_OBJ_EXT as
> kmalloc caches don't have sheaves in v6.18 anyway.
> 
> [1] https://lore.kernel.org/linux-mm/9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org
> 
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=kmalloc-no-objext-v3r1
> 
> To: Vlastimil Babka <vbabka@kernel.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Hao Li <hao.li@linux.dev>
> To: Christoph Lameter <cl@gentwo.org>
> To: David Rientjes <rientjes@google.com>
> To: Roman Gushchin <roman.gushchin@linux.dev>
> To: Suren Baghdasaryan <surenb@google.com>
> To: Hao Ge <hao.ge@linux.dev>
> To: Kees Cook <kees@kernel.org>
> To: Pedro Falcato <pfalcato@suse.de>
> To: Shakeel Butt <shakeel.butt@linux.dev>
> To: Danielle Constantino <dcostantino@meta.com>
> To: Liam R. Howlett <liam@infradead.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

I tested next-20260716 which has this series against next-20260707 which does
not have the fix. The reproducer were able to trigger the leak/recursion on
next-20260707 but not on next-20260716. So, you can add:

Tested-by: Shakeel Butt <shakeel.butt@linux.dev>


