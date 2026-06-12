Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03720CD98D2
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 18:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F9A6B0005; Fri, 12 Jun 2026 14:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008876B0088; Fri, 12 Jun 2026 14:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5FD66B008C; Fri, 12 Jun 2026 14:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D636C6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:29:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90723140163
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:29:35 +0000 (UTC)
X-FDA: 84872098710.25.B2EEB1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D5C6540002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:29:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dNevlnqz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781288973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8z3XFjRJMIM+jZb/OPTpEvUrcBIr7nNl3/wJ6omJUsM=;
	b=f4AEn5h36QFr5DqQ89qPKA4/LsIe8jbk6cV2LygSUAhD2QzfnjZsRWMpdFwJwLH2rYNZtb
	1DR1noNZmHbj9PLULHLxo5hvDZ+/4wmcdrhEodI/uTneDPZWt0HU9rvvE8zZ7rp/CUpFao
	BhT8P20kyFij08eJK1u3/7SV4vC2b2M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dNevlnqz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781288974;
	b=UIM4P11ZVd2/J0tbHoPOaEZXcip+6zm26JHBQUwmPl7cimlxOHsDUsHwTRY/CQsDuxsuh/
	AfcK/d9XnVH3fbqAtB7topuw4MS1Pms5UG+NxaULhTYlbI7eeampwQiEO8ILuQ3alD3mti
	8f5DtkJ6yf69uUxpr+nl04f6EJXKNs8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 109A1401B7;
	Fri, 12 Jun 2026 18:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63C91F000E9;
	Fri, 12 Jun 2026 18:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781288972;
	bh=8z3XFjRJMIM+jZb/OPTpEvUrcBIr7nNl3/wJ6omJUsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dNevlnqzMNmZs/X2e311lqsZN6A8J6V4huiVfUkHXrRbl7WKWluLopHcAnhKA9wKU
	 6bilD/kn7lDqZb5WYdtwrLdKU0/j9qmaIW7nLOGNI/OF/iBSIedkOnv+UITeKZ+vEm
	 v+Di8RwDkHtYjRT5vG9LlKDFe7iNKf2YfT7FRB2PM/pIj0GSmILc4dCmuWkOTnIKnc
	 hfuRczK0jqEoJ6mc0IkTuz0gmKIeYegUlHJ7JtE4zIxSqirPDn0DakMyPjwBvrJ1/l
	 v4kupxgrg20yh0Suc7yURejygd+sdBcamfNMjNxABdteObMcLk7d6r83BfoQPxwQZ0
	 HIclaIlobFR8A==
Date: Fri, 12 Jun 2026 19:29:27 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: David Carlier <devnexen@gmail.com>
Cc: akpm@linux-foundation.org, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Dave Hansen <dave.hansen@linux.intel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: pgtable: protect lockless kernel page table walks
 with RCU
Message-ID: <aixGczWMAWoi0e5U@lucifer>
References: <20260612091215.b06dc7dc9dc894a5bfc75429@linux-foundation.org>
 <20260612172356.356894-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612172356.356894-1-devnexen@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D5C6540002
X-Stat-Signature: jke3nqejxu3hu1psxicskumfjz58j3ow
X-HE-Tag: 1781288973-531954
X-HE-Meta: U2FsdGVkX18KALGyOxt5tqRKtEfcb7cCfneM+ofCZh6ckyx450FshyNN2QQgQnOjZmptJ2bodZbHtJvzNgsjol4+zYjcZdmjcFeaLZHe4MtI/LlLjh3vshqPIymZd/qbnAr1tpCy4HLTxHtfLmN0Y1Ru0hLB16xHiYK6YMeO+UZioDTHuI3q25r+XrMgY3Sb9WIuoWAoK42w7j5hGbK1GUTFHz/hpMJMLmdiVcawU+f+VqcS8zDMIhRx0o0dDyVKxWUoE/vsp5QDh2aGG3GLO6P1P8VyZpX2AU8mDuay+dchw/H5j4ZNcv5xFRmb/5XxltjSsYMEJqafYizXCK5IE2228GnOcO8oTU0k26Wlu+EjeDUm3cuurdlE0Ff3HTZh/AMuv0PHLpKNKpHWbeNLC4759kW9Gd5UXGfO2uzcofrwgye7SmrtLsL9F25me5v0/+4st4+Ymazo+kFhcNe+LkfmUqFnlAnwQkf8dv9wjbSZGQRPuSuaJXt60amqxGc1i0k8dYzKjTQeBOwQW1Jctsi2HfKNr+s+w+SHtr077tJ4T3pclYhnFRka1tB53TwbgOn8aT6iewfAo8EZujE5eq7GZ89VtLlvZmyQzUE6FWiUQLgSanyWD6yR/N7B/da+Q9J95oBOsBvWfLmpYHXcVPBilXqUiTE3pGsxNIl87PmjC7Phupb7+m4GSEoytvUB9fAGUNCDclKQN+z0sUn86E1SvMX4ERVIevdXt0eHJgBMM6iWX/uZ+FibO//8T87OSjji9Ek2TZWsZx9p0r1y2cXZkDKneabS5IOzKbYEFdWk97zedOg9ML9DJ9N20igI8sGTZOB2n7uyur0sHWS881pHfeIKKrYwjEcLQYLFRVOBMdSaZOrYCDR2kTlG6KderfeDUSzlRJTV6VisdUBbWpj7q0jgYx386Jh7qTc6pvOEEh1jtYnBpL1Zz9k1HeKPxQdCzVITtacLmsHoGsX
 qRTanKkF
 oJAdkL88teakjFFb3brTymcwA5mwvD4jeje0xPfnpVU6EFiUoqgtgh+K7c6AVksAiBChyDyadhtmOTF462j1xhSD+E0IDsYcDI9RO9LxrDJPInepHdGdVUBtOB38zNytiej8iqA7lsvpa1FfbT2igakjZECmw4uLjJ/78QJKPTdb3Ck+TsCWJ2ak4pq8i+aYNZvKuyTfLy38fvMBrR01+TjcVdlgZwAEhXMiMKDYGkQJuP4wOu1nwyWu44kwDXRgn3FOL3ZM3+IlRLsF9HUA4XjOyHYSXY7VlFqPM51PwSykzQ8aan3NvURRrDGIGVHW8p9VrN7ER7tM2hbeBvBIPrBFZ5bSX3L+7A0UFl/v59UepsxIJSGISq9ah/C6Rm0bjqPOerBcIfSq3KsdVv7LtLm3ezsGQh47WQS3vkD4fNqw+W0An0jJ0df6vLROI9v8sd48JjIe5SjisjUV9yXzfRgg8EcI7gIqTmZhhQrtYgwNh+Uo/pVpWhG930OFFHNaSF9AAxt4HtTVqmg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please stop sending new versions of this patch in reply to random
emails...!  Just send respins to the mailing list, not in-reply-to
anything.

Also stop sending respins this quickly. Generally leave a day between
especially as a new contributor.

On Fri, Jun 12, 2026 at 06:23:55PM +0100, David Carlier wrote:
> ptdump walks the kernel page tables locklessly through
> walk_kernel_page_table_range_lockless().  It only holds the init_mm

No, through walk_page_range_debug(). ptdump doesn't call
walk_kernel_page_table_range_lockless() directly. There's no need to point
out the specifically function it calls in turn.

> mmap lock and the memory hotplug lock, and neither excludes
> vmalloc/ioremap teardown from freeing kernel PTE pages via
> pmd_free_pte_page() -> pagetable_free_kernel().  syzbot hit a

It's not teardown is it? The only caller is vmap_try_huge_pmd(). So it's
actually trying to install a leaf PMD and freeing the PTE there.

> use-after-free in ptdump_pte_entry() reading a PTE page that was freed
> underneath the walk.

Yep that's a problem.

>
> Deferring the kernel page table free only batches the TLB flush; it does
> not wait for lockless walkers.  Mirror the user page table walk, where

This feels like useless information re: TLB? I'm not sure why you're
talking about it.

Succinctness matters too.

> pte_offset_map() already takes the RCU read lock: hold rcu_read_lock()

Referencing pte_offset_map() seems bizarrely irrelevant here?

> across the kernel walk in the init_mm branch of walk_page_range_debug()
> and rcu-free the page tables in the kernel page table free worker, after
> the batched TLB flush.  ptdump is the only walker that races with these

But you're having to actually make the page table freeing wait for a grace
period to do this so what has it got to do with mirorring pte_offset_map()?

And I'm not sure we really need to talk about the ordering of freeing
pagetables and TLB flush here at all.

What's happening is you're actually _changing_ the kernel code to wait for
a grace period and then relying on that for the sake of ptdump.

> frees and its callbacks do not sleep, so the lockless walker itself stays
> lockless for its other, exclusive-access callers (e.g. the arm64 page
> table split paths, which allocate with GFP_PGTABLE_KERNEL and may sleep).
> A walker then either observes the cleared PMD and skips the page, or
> keeps it alive until it drops the RCU read lock.

I don't really understand from this why the arm64 page table split path is
safe from the apge table being freed?

In any case, this is an utterly unreadable wall of text. Please separate
things into paragraphs so a human being can read them... Don't let the LLM
do this for you.

Make sure you understand what you're doing and write the commit message _in
your own words_.

As I note below you also need to explain why other callers to
walk_kernel_page_table_range_lockless() and walk_kernel_page_table_range()
are safe but ptdump is not?

And why exactly this is the page walker's problem?

>
> Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
> Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
> Assisted-by: Claude:claude-opus-4-8

The commit message + comments all feel generated, please edit them before
sending them, LLMs are _terrible_ at this.

> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
> v3: take rcu_read_lock() only in the init_mm branch of
>     walk_page_range_debug() instead of inside
>     walk_kernel_page_table_range_lockless().  The lockless helper is also
>     reached by the arm64 split paths, which allocate page tables with
>     GFP_PGTABLE_KERNEL and can sleep, so it must stay lockless (Andrew,
>     Sashiko).
> v2: rcu-free the page tables with call_rcu() instead of synchronize_rcu()
>     (Matthew Wilcox).
> ---
>  mm/pagewalk.c        | 21 ++++++++++++++++++---
>  mm/pgtable-generic.c | 16 +++++++++++++++-
>  2 files changed, 33 insertions(+), 4 deletions(-)
>
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 3ae2586ff45b..dbb443c72353 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -692,9 +692,24 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
>  	};
>
>  	/* For convenience, we allow traversal of kernel mappings. */
> -	if (mm == &init_mm)
> -		return walk_kernel_page_table_range(start, end, ops,
> -						    pgd, private);
> +	if (mm == &init_mm) {
> +		int err;
> +
> +		/*
> +		 * Kernel intermediate page tables can be freed concurrently by
> +		 * vmalloc/ioremap teardown (e.g. pmd_free_pte_page()), which
> +		 * routes the freed pages through pagetable_free_kernel(). That
> +		 * path defers the free past an RCU grace period, so hold the RCU
> +		 * read lock across the walk to prevent a page table from being
> +		 * freed while we are still dereferencing it. ptdump is the only
> +		 * caller here and its callbacks do not sleep, so this is safe.
> +		 */

This is unreadable garbage. Again, please don't let LLMs write comments,
they're awful at it.

And I don't love that you're explicitly saying 'X is the only thing that calls
this and it's safe!'

I mean, other things might call this right? And then this comment just bitrots?

If you go and read the comment in walk_kernel_page_table_range(), you'll see:

"
to prevent the intermediate kernel pages tables belonging to the
specified address range from being freed. The caller should take
other actions to prevent this race.
"

Your patch should explain why other callers don't need to do this and why
ptdump can't itself do something to avoid this?

Why are we doing this just for ptdump?


> +		rcu_read_lock();
> +		err = walk_kernel_page_table_range(start, end, ops, pgd, private);

> +		rcu_read_unlock();
> +		return err;
> +	}

If we do keep this approach we're essentially adding a whole new function
open coded in another function...

I'd rather you add walk_kernel_page_table_range_rcu() or something in that case.

> +
>  	if (start >= end || !walk.mm)
>  		return -EINVAL;
>  	if (!check_ops_safe(ops))
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index b91b1a98029c..5b53e9a5b7f8 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -424,6 +424,13 @@ static struct {
>  	.work = __WORK_INITIALIZER(kernel_pgtable_work.work, kernel_pgtable_work_func),
>  };
>
> +static void kernel_pgtable_free_rcu(struct rcu_head *head)
> +{
> +	struct ptdesc *pt = container_of(head, struct ptdesc, pt_rcu_head);
> +
> +	__pagetable_free(pt);
> +}
> +
>  static void kernel_pgtable_work_func(struct work_struct *work)
>  {
>  	struct ptdesc *pt, *next;
> @@ -434,8 +441,15 @@ static void kernel_pgtable_work_func(struct work_struct *work)
>  	spin_unlock(&kernel_pgtable_work.lock);
>
>  	iommu_sva_invalidate_kva_range(PAGE_OFFSET, TLB_FLUSH_ALL);
> +
> +	/*
> +	 * Lockless kernel page table walkers (ptdump, and any other user of
> +	 * walk_kernel_page_table_range_lockless()) dereference these pages

Err wait what? Which other users? And why are you referencing the function
you didn't change?

Note again that the comment for walk_kernel_page_table_range_lockless()
mentions that you need to guarantee 'exclusive access' over the range...

> +	 * under rcu_read_lock(). Free them after a grace period so a walker
> +	 * cannot still be reading a page we release.
> +	 */

In any case this comment is really useless and begging for bit rot.

>  	list_for_each_entry_safe(pt, next, &page_list, pt_list)
> -		__pagetable_free(pt);
> +		call_rcu(&pt->pt_rcu_head, kernel_pgtable_free_rcu);

Hm now we're unconditionally waiting a grace period for page table freeing
here just to account for ptdump, this seems... silly?

But this is only used when CONFIG_ASYNC_KERNEL_PGTABLE_FREE is defined, and
nothing in your patch references that?

And if !CONFIG_ASYNC_KERNEL_PGTABLE_FREE then pagetable_free_kernel() is
declared in mm.h as:

static inline void pagetable_free_kernel(struct ptdesc *pt)
{
	__pagetable_free(pt);
}

And everything's broken again isn't it?

>  }
>
>  void pagetable_free_kernel(struct ptdesc *pt)
> --
> 2.53.0
>

Overall it seems like a ptdump bug that ought to be fixed there? If it's a
broader 'use RCU' change the patch should more broadly alter things to
reflect that.

So far this seems like a hack?

Thanks, Lorenzo

