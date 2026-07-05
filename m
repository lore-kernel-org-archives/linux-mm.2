Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B6CDC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1B46B009E; Sun,  5 Jul 2026 16:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351ED6B00A0; Sun,  5 Jul 2026 16:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267F36B00A1; Sun,  5 Jul 2026 16:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1F1F6B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:31:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6BC658C477
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:31:34 +0000 (UTC)
X-FDA: 84955868508.20.A07BD1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 93BD2140007
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:31:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Mn3IM1gO;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783283492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/shfTy2/IJB2wTTprOVJQY6HZudzX/XlXY2dxUeOSc=;
	b=btAa8wHHAM/O1sb9/fE6NUNPJMfp4NXpnwaJa2MI9R/mhro3EvGfrLe6HpbR+x/65+oSHQ
	d0GzJlKyWrY/6uOjTQcOxt7eCx+GMpuni6wreT2E3c9NQDGXDro2JN0dItRg2+JybhPM4h
	6DBOQsQvttQ+8Pvn4jZmuY1WC4J32Eo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Mn3IM1gO;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783283492;
	b=AAdBvIs1ePNyzrnn4ZHxIpNmi/bkL7oM/5v51/UuS7vHJEqpzFf4ls0+cgiK0TA1TQUrWi
	tOVrC3YPjjHVrdN7+3JjNVv9wFQryVMFDAldzvjx+8zD52Rip8qtQAfpxyzbQ04Ric1qGO
	k5Wl1EezDrIslK+pB+cu8sCQtPOw0qM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45A15436C1;
	Sun,  5 Jul 2026 20:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBB61F000E9;
	Sun,  5 Jul 2026 20:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783283490;
	bh=Z/shfTy2/IJB2wTTprOVJQY6HZudzX/XlXY2dxUeOSc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Mn3IM1gOLuSx2CRIiw/WJHtJAo+egenKF8r82+OKr1WK+mLooaPGmNHINMAcwIXy0
	 5RFYgz2anWpmLvlH8Uf1hzQqxuNHCsyenTiSr87fB0mgdUFVglqB3KlQyPK5j6iqPB
	 YpA/2dzxBAqYR1+PIglQSO/nkrdxSjTSYWIleauQ=
Date: Sun, 5 Jul 2026 13:31:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Carlier <devnexen@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Paul
 Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen
 <dave.hansen@linux.intel.com>, Lu Baolu <baolu.lu@linux.intel.com>,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v7] mm: pgtable: free kernel page tables via RCU to fix
 ptdump UAF
Message-Id: <20260705133129.74b3bf92ed21c9bcddaf6174@linux-foundation.org>
In-Reply-To: <20260702093011.336036-1-devnexen@gmail.com>
References: <20260702093011.336036-1-devnexen@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 93BD2140007
X-Stat-Signature: byp31gph18kbn4gpkuc5wdpfq93fr96g
X-HE-Tag: 1783283492-169820
X-HE-Meta: U2FsdGVkX19u3h9OQNRZ+UxiwZ3NHSqMW6KFw2ctZhJNeXqb+Fz1WcUC0H0w7bTMViF/ecdXVp2QNBl0KWOVolAKxwik+z9L4/fERU3za6XeNcdZ4k0zL0WghGjrGuhXISNB+ibCSpb/be4v+eCLDTovHpJMs4w6PkGAqCqfwuNZ5qtASVm9vnMtmgMhN7J6TPE1H2mcWc+VmvII4ZBnLHKK+4cVzkWhS/mTvh82kI0CAimyUcxDIZqBt3XXOxJGnHnjE3tQ/vhIyOuDb5GoG3o+PQqlDBx6ejliHvekn5q0Z17iIwddjf8VU+XT4+95AZfegm38UvHhH0v4PK23W1kZvBqm1mA6yIsKwG0YkYunANLdV/gv58OScT0ufEihBgUiIwdoR6BPkgfycq+ZwbKt8p/FLLzB2c2xF4cC/hbH2u/b7kaNT+g5XzsYSAI+mY5x4cWmnYMWU+vA0+B/+6BxMV6q8tOrN3JFVn9MthMsZhgyptfOdKFLNGGwtdkVs9JWZXd/m/VNpKrCRoMdbG4YwAbrvApzpdSGNUtqitFEYmRPp6VNHnbs01cn6SLOiZXt3e/HV5kphvoteJnsqLGaTLrR5KEd9IGiEE3j1Bipie6uk/G5KMoU4qJzdB2K80J4TTsgJ+aaZCN1fo9gQSOT7g+VpQz1yHR5dLamSx2NR02Y46MjbQvKvzXdHj5PBiMsO4ukj+XUj30cmVak2yozStMIY4/seOTnyPw24JhRYMjzrhbRq39Z1EFu3tn6CeYhABscWloYT4lcx4VPZF5xJoVEijx9cd6ThQ9yxK1u0wvN3OZhK/tdghRicGhNNK3myLh4m6UOmQ02E7ZWhmLRqULI0nW/bz0XnXuMPBNdIfcCprAFS/iRYRXwbCzRZQxjEam2VEK3bxNagZspxFpXpi8wRpb9UzIk8Gxl4kfYuZ/wbs67snwFAEF/LTW2H3i55B/IVRDEMgyvo+R
 +SuAzn8u
 RZhr48O6Y/pyNVx9G367RW4aLtmBpSBdeRED5cL8Dz9+RCE3FZpHguC6tMUugKvp2xrVKGgYbWXhg4cUe+EY6g/1BBtKxKbHQKL+ayjuJARbzYBWgsVKycRlZKwZisms/kO4kCbPq+ZPeytTpZdFmHHauk400hWIqhrc6MJOhUBqFC6TON/5ZcPX8utjE29qPkd0c5PDi5++lCBZA/Sx8KMzdW1ZguUpssmU2j7qXFBXZexTacjvPOtU/qwXRz/FmCNpq6CU8F3GC2lELaqeoRyG9lVhZLeeQ7IvSJ9y2sFSNE/JhW3HilPffB2QeTUK2l498NsX8zK1lPLp/H7laWr0/wsW6wc1n3PVZZHLOzg4CEScx15KnFN847yIyLmBNWp+GWiJyQub0b28LePVFgHPkicuUZ190PwZ96ZQFy+sU3TWhMm3YCdslMAztMIAavmolk3aEWCMbvBxe/rsFGtzIZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 10:30:11 +0100 David Carlier <devnexen@gmail.com> wrote:

> ptdump_walk_pgd() walks the kernel page tables under get_online_mems().
> That does not stop vmalloc from freeing a kernel PTE page underneath the
> walk.
> 
> When vmap_try_huge_pmd() promotes a range to a huge PMD it collapses the
> existing PTE table and frees it via pmd_free_pte_page(). On x86, riscv and
> powerpc this runs without the init_mm mmap lock; only arm64 takes it, and
> not on the block-split path. So ptdump can dereference a just-freed PTE
> page, which is the use after free syzbot hit in ptdump_pte_entry().
> 
> The race is not new. ptdump walks the whole kernel address space, including
> ranges other code is actively mapping, so it reads page tables it does not
> own. 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
> only widened the window; the Fixes tag points there for that reason.
> 
> Every other walker works on a range it owns and is the only one mutating
> it: set_memory() on arm64/riscv/loongarch, the arm64 block-split path, the
> openrisc DMA path and the hugetlb_vmemmap remap. Nothing frees those ranges
> concurrently, so they cannot race and do not need RCU. ptdump is the only
> walker that traverses ranges it does not own.
> 
> Defer the free by an RCU grace period. pagetable_free_kernel() now frees
> via call_rcu() in both the async and non-async configs. The async path
> still flushes the TLB first, then queues the per-page RCU free. The page
> stays valid until any walk that may have observed it drops its RCU read
> lock.

Thanks.  A use-after-free is something we should attend to!

AI review had some thoughts, but in a strange manner:
	https://sashiko.dev/#/patchset/20260702093011.336036-1-devnexen@gmail.com


