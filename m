Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA6ECC624DB
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 00:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C013E6B0099; Sat,  5 Sep 2026 20:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDB3D6B00B5; Sat,  5 Sep 2026 20:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B184C6B00B6; Sat,  5 Sep 2026 20:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4E46B0099
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:23:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 067041C215D
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 00:23:46 +0000 (UTC)
X-FDA: 85181439252.01.819731A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4EEA520008
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 00:23:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hu8vYvlm;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788654224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o01Kye+IbaFrqz8jkXWQ4cSeCY/YwDxfGVu5J8CSFMA=;
	b=h7fHpC7i+jWjCmmv3JxfVF94O3+L21CZx3O4szPkT00PCA3yYB+b/s96UCaQDkpdBQkMZS
	OIcLbRQ8fr3tKoqr/KJstZFKrmaACQsmSFms4zGXm1qJL3Om3WWRZKqYPKGll9cpjrSj8V
	fVS8xxf/5QZ9VcNNR6Et6/1xNLxU0Qg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hu8vYvlm;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788654224;
	b=gLDPGrDGCy1o4Xjt9YbMkgDEwkVjH/BFtR8afd7xz+PGoZuro6IFnYEBUvQFq+Crof09qN
	Z0h/i8jHKqPKR3RlGzRCxWTSDH3DzRPeJD/j6y3av/iBlTD8hVwD2omqlW5wm7LcTLxfSV
	8l/GkjjOWaGFMDrvWr4heEB+mpFO5Ws=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57DBB60142;
	Sun,  6 Sep 2026 00:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FCE1F00A3A;
	Sun,  6 Sep 2026 00:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788654223;
	bh=o01Kye+IbaFrqz8jkXWQ4cSeCY/YwDxfGVu5J8CSFMA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hu8vYvlmaeC97R2YdQx9QbtsMFN3k+qnx85wubeA8lCOG2v5oiV5oyNwCQ/KtynNI
	 LMCsEWzrpuhUSTl2eSkb+u/pfSy8oiBqj866l9dJr/nqCSaOlg95sylO0c8NpdHbd+
	 EJZVMBz/6LYgMerXDnF3nahP9hmX/pLhCPYyZoNg=
Date: Sat, 5 Sep 2026 17:23:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, Zi
 Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH 00/12] mm/collapse: separate a collapse from its callers
Message-Id: <20260905172342.72be31534af21871f8b13f47@linux-foundation.org>
In-Reply-To: <cover.1788533997.git.kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4EEA520008
X-Stat-Signature: fwekn3ib8in74fmmjpugty91f5ehtf46
X-Rspam-User: 
X-HE-Tag: 1788654224-233206
X-HE-Meta: U2FsdGVkX196TWUx+l6AZcWQxfF9T/cwTAaJ8PtAB/XAHtN4cPhVuSwad9FUi9bfNEl8sXfjeoFenLlIGfxeqOaWiIrSBZbt5OEBYI47V6cakAwYO3E0d8o+kfYxRn0FepMRGwPIPRQwxFuF+OeyrhaokApa6W2MO6Y3xa7qImc3TWUhaHeOzn2xpJif47apJGJoHAjYKpEItGk6F+JLeUVWZh9452yTnYaop1gji7ANBnsrpLWei7XjXPducpzg8uG3TEbOeamMfOZTOxMz3NYdtfO5fn1dEG2fLNCnlw4X7MRD70NugFifaVhY4frPd0pzZIDt8WLEo0IxGWFG+vT1RyGmx9P4TpMQNhPJdQXzPTTnaVScDzqUS/UtnQAEpUwFGGu1hnJ7hHHU6lR7H/T28Ri2tSenZL0yHYVmqglsxmrt+3gNysWS8zKS3lrdtK+eZLpF3mIF7iyu96it9rofBxFvjM9rHSjSCKi61gPRhB5I1Mpx5reApEBi7iBAfb3fzswkgkug5BhW9AYVIMC+/DxbNxNlt7wXeF7RaYz3ABQh38d0ZbWkQ5e3fca8CVl+XWwPcAqZTupB7nnpLl98FzPG3FpFM1UquyYq5nz3isigGzyq4Nt+Yl7stdj4r505llOpx2v8q0XgyTS9IXoB3mJZNOVsKnwK6lvg8MX0RJgYDXdqh4S7M5Rzwtz3vlrNJf36IoFPMrMepCf+Su2f3dyqL1jXr1Rf6MSGTyh+KAQMgCPzlzDqNrxuPsBk4PNqhzx03GsbAcTUzxJffbtpf/XmHQ/sD9j4KhFani06/SmLnjj8TTn8LUNVk45022su4F9RqEttac9293mIVbDWmXRjXE7JC4WTt4koTRiF6Pk4m/7T1Z1gZxLRQldhnWwIfY1n4gjrztniyMgZiEcoSKRcBvjT3ZdgbQTkKxcfMi2/6tsn0AZvbiNrYlNYrbgOEWsT6L+BH92nh1i
 2p6A4K5n
 ceO3KeWgApZYjlT0l8/cx8MmxcqV9dR9z1DkUnN6L/qAK0oSmLuegl04K8eVoD3q4yME71EGw1DQFVp69+vPqeqeENGCwe7nBaJk0WLkMKa1IE3y3qfpJZDKgJmferk/Hu1ZntG6V5LvHZZVJL8AW6JGr5biwOBvjOuC+kCViO4ZvSFTeVlsFWu1deuQsh6Gs9xTwL0Xt7HJPEjTmeKFUp22nAiAoJFiNLS2e10yRnML/V9qZEoHRmIMVqx91FEQh8hlq7S0+YVdyGPH8E9c7JSvqiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 16:10:14 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> [ This is the first of the cleanups I said I would front-load ]
> 
> There is no line between the collapse engine and the callers that ask for
> a collapse.  khugepaged.c holds both, and they reach into each other.
> 
>  - Sixteen tests through the collapse path read cc->is_khugepaged to work
>    out what they are allowed to do, when every one of those decisions was
>    made by the caller before it asked.
> 
>  - collapse_single_pmd() does both halves of a collapse behind one call and
>    drops mmap_lock somewhere in the middle.  Which of its paths dropped it
>    is not something a caller can see, so it hands back a bool and the
>    caller keeps track.
> 
>  - MADV_COLLAPSE's implementation -- the walk over the user's range, the
>    per-PMD loop, the errno translation -- sits in khugepaged.c, which is
>    the daemon's file.
> 
> So: draw the line.  State what a caller allows in a policy, split the call
> in two with the lock as the boundary, and move the syscall to madvise.c.
> What the engine offers is then four calls, with the lock state written
> down against each, and a policy the caller fills for itself:
> 
> ...
> 
> Behaviour
> =========
> 
> Nothing here changes what gets collapsed.  Three things a reader should
> not have to find in the diff:
> 
>  - Patch 5: khugepaged fills its policy once per scan pass, so the
>    max_ptes_* limits and the defrag setting behind the allocation mask are
>    sampled once per pass rather than once per table.  A table scanned early
>    in a pass and one scanned late are then judged alike, where before a
>    knob written mid-pass split them.
> 
>  - Patch 8: mm_khugepaged_scan_pmd fires before mm_collapse_huge_page
>    rather than after it, the scan having returned before the collapse
>    runs.  Its status field already reads SCAN_SUCCEED for an accepted
>    table, so nothing changes there; what the collapse then made of the
>    table is mm_collapse_huge_page's to report, per order.
> 
>  - Patch 10: which orders a table is scanned for is sampled once per VMA
>    rather than once per table.  It cannot widen what a collapse does --
>    the order is tested again under the lock the collapse retakes.

So is *any* functional change expected with this series?

I'm reluctant to merge an unreviewed v1, but this comes close!  I'll
sit on it for a week or less, see what people say.  Please poke me
if/when you think it's good for mm-new.


