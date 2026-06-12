Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5E15CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098EB6B0005; Fri, 12 Jun 2026 12:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070E16B0092; Fri, 12 Jun 2026 12:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEFCD6B0093; Fri, 12 Jun 2026 12:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF44D6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:12:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 811321401A3
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:12:20 +0000 (UTC)
X-FDA: 84871752840.06.8468711
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2D1E61C000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:12:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jZpBlWZy;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781280738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/sPiD+QHAE5SnG3mf+RwozqEbzxycx4/mCbYbChQOc8=;
	b=7nRUuXQH9ksqiZeYOoeQjJ99ULyJ5qsF3S90eqA2fy8M2DyqzR7RjB8ZPMgZFekinK/oLS
	tx+B7v+UobP3YPXqzXrcgRrhKl4byHBg2YBM0cDCw3kR23N6awDiCqoF0Kp9f46uI0u37R
	oJA22NOqBs4R9Fr4lIz6J2ycbiARXtQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jZpBlWZy;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781280738;
	b=75SiiV2uebmEnxq8yQndHHeIkf0kziKOCI1bjIaRR0QDK8hFGD3qoaCo6eDiFdyzeuobkE
	WS2sXICobVf44BytLXJ5SE61hebxXV7PuH6Ibqm91Jw9C/wSCIxCZxmrjFSTAeFhndY1jN
	u8NnzLBl+8d8cMXyGb88t9l5++S+RNU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DE4F41E5B;
	Fri, 12 Jun 2026 16:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805291F000E9;
	Fri, 12 Jun 2026 16:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781280736;
	bh=/sPiD+QHAE5SnG3mf+RwozqEbzxycx4/mCbYbChQOc8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jZpBlWZyiTJBePPX3uSESMJtoiH8kYT9JooRHuu0lO1UDNgPQnnL5p0Zpgv5Zleqv
	 pByhksc/sOnjgM9UVL79PRLmRnBLClOZ/tMZd8tx65Y4bG1rrItOSbtijIBrG5hJuH
	 IkxtwFr7fonxu+of4lJ5DwdfESzjWMSTiHhfjWX0=
Date: Fri, 12 Jun 2026 09:12:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Carlier <devnexen@gmail.com>
Cc: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Lu Baolu <baolu.lu@linux.intel.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: pgtable: protect lockless kernel page table
 walks with RCU
Message-Id: <20260612091215.b06dc7dc9dc894a5bfc75429@linux-foundation.org>
In-Reply-To: <20260612050540.31594-1-devnexen@gmail.com>
References: <aiuQf99mqhQRVzC8@casper.infradead.org>
	<20260612050540.31594-1-devnexen@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2D1E61C000B
X-Stat-Signature: dheoh9a8k1psgktpj9xf9awkkzaq9uab
X-Rspam-User: 
X-HE-Tag: 1781280737-908544
X-HE-Meta: U2FsdGVkX1+N9Oxl/26/4QLEFgtvQ+h6M7GNKXL/SYoTSuekBIRmKSrevkfN2v6D1cZbfIIRLRQDdBMekXYH3yPgqakoTJnABGu9RUNtXRJQsZoMmJt9iy+sdKelL8qkZl/vWjQA31eFTGkyhoqN+ofH3PxB97JsPYpmn42gljzsMmWE91X8m8fHTm/8XSMapwcfXmeMSKnbr8sfdSAiSy47Oo1FYWL4T3xA8jx7e+tx7rjscavJ84sphJN6H/fsyfGC6CJ9en+iaV7dDKBgzpvxdm+imP+7ql95tjms+N7ovZX0rP0yh/8CoNegrg3ZShcokX+c9F6ztM2Z/AuTBZKgFS7S7qjv48NVvR5tw8IFcHbzeUqPEE6qSimxMhNq0tL858KxbcLU+f7CNtlCdbP6+hbmeuOn0rEQtWhfe3OoYem9dgMmt+PxnV0klQY4H+QzrSJgIjQlFByvrS0+LoW6Fto0xTUsliwcaW0m6MqT8spzSBpwZlIVZBU17QGzvihEYureR7GmgTqzrK2P/eVYj83vB085WKhy9yuWS53+rv1cqLG6vDBuDK2Lr18ooYvH/O1/SPj1vcloyu78DJW8UqChyOb20r2yQz5I2wGJXKgR94WsGzLKTXp67yWBOJlKxej68xwlGYhWjgVSi4spJn5CfWFi4B7hul4lWILkC2FxlacZAkJqG/gxW9EM2DLCGgwKtf+XNPiRMwx+1kmeXq7peq4hpF6pPOj5Yrul1Ay8whAU8UzuysAJggRqg1+Ud9YUi09xTwj7HZii1z2Arb+RGbYvVQeqkntH4Uc2CiljhZVt5pcKZ4DHBmh9hIlNqN+oMlap+k0YL2pDDYDVXLGVeYX6Lo1FQc0p0JaH+e/06kmXfOj3ILG+qss5J/pT+n7XT77Q41MY3/cyHJo+U/cGhZv45qGnjS6NcGZmK7tRz3+RNsMUbyeEwhyH71J/O7piwmOLqdayaL7
 NPPAgoRh
 lM+jUI/3CoxTxc0f6OQJp0jpj98VoaqgdezAe/uCoRqxSD7fD5jhWmLhJmEU4BffU9RvTpA3e/DmUQkmFgO4dyC5dXU4hagJaEbK7G0LI3H+CrDnCg4DNbexWmyb2jPYfZrPNgYMZpSLma0fG2EFX3IohpDEp0UjEjB+RUnV5Y9CX3R45QkzprtGRZGa6iTfkPWGS1faLYS7vgqA1611itGbOSAINSYm0ZWfwMKP94lcDnTA4h3+AENFr9U1Rl8KqkqWubzr+1ZY81x+mW3Huq6JtXAgU3q2XTDXiRGHhSalaZPw2fKuRe7ODoFEstXwMnkMgId6/+Qi1qzRAkekeLElo+jEK55JE5O2y1HNi7a+w3ot8rpb96gbPyFo6mnyDsjRscx8zUqECRcr95txOJZxLNWItCVLwsCh6OruJkd1okreIeg7RM97LhudLx1evPLb9pgAqgjdFDoVoLFmY0QfmCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 06:05:40 +0100 David Carlier <devnexen@gmail.com> wrote:

> ptdump walks the kernel page tables locklessly through
> walk_kernel_page_table_range_lockless().  It only holds the init_mm
> mmap lock and the memory hotplug lock, and neither excludes
> vmalloc/ioremap teardown from freeing kernel PTE pages via
> pmd_free_pte_page() -> pagetable_free_kernel().  syzbot hit a
> use-after-free in ptdump_pte_entry() reading a PTE page that was freed
> underneath the walk.
> 
> Deferring the kernel page table free only batches the TLB flush; it does
> not wait for lockless walkers.  Mirror the user page table walk, where
> pte_offset_map() already takes the RCU read lock: hold rcu_read_lock()
> across the lockless kernel walk and rcu-free the page tables in the
> kernel page table free worker, after the batched TLB flush.  A walker
> then either observes the cleared PMD and skips the page, or keeps it
> alive until it drops the RCU read lock.
> 
> ...
>
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -655,13 +655,26 @@ int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end
>  		.private	= private,
>  		.no_vma		= true
>  	};
> +	int err;
>  
>  	if (start >= end)
>  		return -EINVAL;
>  	if (!check_ops_safe(ops))
>  		return -EINVAL;
>  
> -	return walk_pgd_range(start, end, &walk);
> +	/*
> +	 * Kernel intermediate page tables can be freed concurrently by
> +	 * vmalloc/ioremap teardown (e.g. pmd_free_pte_page()), which routes
> +	 * the freed pages through pagetable_free_kernel(). That path defers
> +	 * the free past an RCU grace period, so hold the RCU read lock across
> +	 * the lockless walk to prevent a page table from being freed while we
> +	 * are still dereferencing it.
> +	 */
> +	rcu_read_lock();
> +	err = walk_pgd_range(start, end, &walk);
> +	rcu_read_unlock();
> +
> +	return err;
>  }

Adding a lock to a function which is advertised to "walk the kernel
page tables locklessly" is a bit of a head-spinner.

Sashiko claims that some callback functions can perform sleeping
allocations:

	https://sashiko.dev/#/patchset/20260612050540.31594-1-devnexen@gmail.com



