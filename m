Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F29AECA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 10:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A41E6B008A; Fri,  9 Oct 2026 06:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E0B6B008C; Fri,  9 Oct 2026 06:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5A56B0092; Fri,  9 Oct 2026 06:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2946B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:41:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BDF51402F8
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:41:26 +0000 (UTC)
X-FDA: 85302746172.12.57F96DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 718F6120006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:41:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IV5Cnyl5;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791542484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cwq24PEweYCKQcmw9+hoELtVfG6aGbF+TPjmWZlfZpI=;
	b=AL+1EhBa4/ZaEwCVXGdfgzOxQCYUB7j/9YM+TZGcZZSveZt5mtX4A1yd5q8d78ZzL1hz0X
	4pWEqYHdFllV42icfYVPgY9/V11CXO09eGqPfVrPJ0ArR7C+Neqg7LmTtLzK6OsPl1jvyb
	hD0bmeY/nUYJEqq3mMMXYXGdZjnuTF0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IV5Cnyl5;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791542484;
	b=bISutopcTe2RP0xVeyPgCY9BUc/jTU3Xb9wrPt96Rm0GuFXT8cxE67MeQjUZX+/C89qOKD
	toY+iPSqfobls04u8pUQRctMhq9XAm2jmyLuLk7AG7pQuL3TNnVbotiC7ZnPNfKQ5NVuVQ
	nxMDIf8hG+CKugCG7KAgyF7dldThaMg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62E8B43D48;
	Fri,  9 Oct 2026 10:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3481F000FF;
	Fri,  9 Oct 2026 10:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791542483;
	bh=Cwq24PEweYCKQcmw9+hoELtVfG6aGbF+TPjmWZlfZpI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IV5Cnyl5YFpcOs667zXq5fhHBaTQashWb6uHeGtr2M11Sr7S5Bwj+NP6bYcCRvLoR
	 qjrlQmB4MakZGLjjIQTL5bhfgIAde7TYI71gW7w9fUKqeuBPYrV51P5xGsv/yivrHj
	 QMgLK02INHg4xwKaz0kdwszFeUiajgE3C0c/4xo4Xvu18GzeBnWJNyTtyDXNAVma8c
	 ZAFMnIYpMvF6Qo6UFRk4YuuBnT4v+WHMhPgX5PtC9qE/IOr8uuHfYoXR6BPwAlfYsk
	 8//DF1vpgExx3ANficCPgw2BdWvqcvOEPF6/4G8J+6IY5hG5j251V47G30Ygsy7APi
	 +8mJ4AlF520HQ==
Date: Fri, 9 Oct 2026 12:41:18 +0200
From: Harry Yoo <harry@kernel.org>
To: kernel test robot <yi1.lai@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-mm@kvack.org, 
	Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, 
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [harry:b4/sheaf-size-round-up] [mm/slab]  ddf56dfc79:
 will-it-scale.per_process_ops 54.5% improvement
Message-ID: <asi-kgXfHJt6Gjp0@thinkpad>
References: <202610091451.beda4ec3-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202610091451.beda4ec3-lkp@intel.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 718F6120006
X-Rspam-User: 
X-Stat-Signature: 18t9e1uiestoxaqq1ewuzt51am3uyk1p
X-HE-Tag: 1791542484-245680
X-HE-Meta: U2FsdGVkX1+I0rSPI/UlQM5aahwpadQEOGrLQz4Ow8WDcIgfNYy5F4g8lMHmPlMqCytp2zBzz0bZEElxbWVh6yMaPTlHGNmxkc2ri8H2q2kmS1Hi4bbv6LXm40DKRt/w9ZxS5GW2SenGRvHT26nUb39moU/hi6yKVvEWfXQwji2jg2QpQWqJi49U8wEuba5jmt2Yx123RfQeBiCrqg4U5RcpjJFAdB0n0EVx3eKx2xTmkiYasbym7zHzomvs9pDCxJdENvu1v3QV/QEMUPsX+pcrLbHgbw2NKxOy1WOhU2Xi9EPnyUDHjtbkANN9oGpe7gLet4qKkut2ZA4CSQZp4KEXF9jsjljH8JTZt8MhFygabAdylVl9YsIYfqx8j+Ue9n4qts+A1ol9crrhMLliROzzERt8XjDh4zSyFayseVzzGgAAkelrqLK062wPSkpGDoHVQyBJnxRCzvKi7s2l24URUEffn3CrwFwgPEwBYaVrsxCkvOi6rHVLtPYMZZkEd6nrREj/YKYcu4bLXk/FannlPFfNuSWXYGSqdyv112boyxU6xaTMikOGOsOJ06So7lZKpcrzjjbmO7aq5t9SDKLMl7mgT56RNATSamIa/zqJMXAKRFXVNvniX9OQTpihmya6T3xTUXjr5XzaEo5kfq0oxpEcczo7xX1lXGOMcQKrtDDaNgA3CroZQwaYRTPV/7U1ZQISAIIjKnJKqcRETvpsxciUp5jtxwOfc+0ynzg5h/1BaXa72LXQKy7y5nSw7pJ0Os4cixZ7BDvjqe6s6Ef8tu7Yr+43xW7NaxQfodL7hj/4XOX/lokfucnznc6o1h7MDpS92XeNrQ6VIdoXRdzEEJrZ4P9azs4t1zYrgT4v8MCyRfM6sLqDzgNjrDOFFi4VyF+nZ+LxULx3dBVTARzYrx6AOVDfWlP6fS+DPaXERNwg28552oJshuHUtPydpc6pb87QBG/T1gd6aJD
 SyE4+cex
 7x+1mlGYTZ38NwaJwKjz2p0763qbjo/4JEcsf+tq1rXNYUb1cft/lbEXuCm3rCTR7lQOGGOUKSRjDebeq5jnKGtxuQMc1UwYzrtSm0SGdz/+mQtLX8zcMYYw61JI0KCY+y6WaY3PwNzjvAgamxBjwUk2t4LkAD8kykuAGSjYvaG3E43fJ3dz57eflYPLprllbpEte1+Eb+Ad24lLqoRklSgtKr6PSeYnBtn67mMfNKmXFwYgu+9gx7So3X6wVuTB/TyWu10YRE//ADZUTPCd/4GcP+oyM/nfdx+viNwbJyNWVkpc4RTPv6qQ/WbHza+9Ncw8oOFkx1LasQ0naPNfV8eAJBMgiQGwUJTDoU/owArCrEFLbhA2DWFxOS3rogU9IJRNNjmxBZDqVT7rIKwoN23cW5ODE3GZnWcwE6BFU0vfhxF2AKYUpfKno0lV/oikpAgzfiK/lyx0uzOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[ +Cc slab, maple tree folks, ... and Suren :D ]

On Fri, Oct 09, 2026 at 02:39:02PM +0800, kernel test robot wrote:
> 
> 
> Hello,

Hi, thanks for reporting!

> kernel test robot noticed a 54.5% improvement of will-it-scale.per_process_ops on:

May I ask if there's data on slab memory usage for this experiment?

Performance improvement is nice, but only when we know what's
the tradeoff (memory usage).

I think diff on Slab:, SReclaimable:, SUnreclaim: in /proc/meminfo,
and in addition to that, ideally diff on per-cache slab memory usage
(from slabtop or /proc/slabinfo) during the experiment would be nice
to have to make a decision :-)

> commit: ddf56dfc79f5734d7b3aa8ba81f195d52b3e5823 ("mm/slab: round up sheaf size to kmalloc size for explicit sheaf_capacity")
> https://git.kernel.org/cgit/linux/kernel/git/harry/linux.git b4/sheaf-size-round-up

https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/commit/?h=b4/sheaf-size-round-up

Oh, this is a b4 branch that I pushed but did not submit to mailing list
yet because I wasn't didn't measure its implication on memory usage.

The patch removes under-utilized 244 bytes per sheaf on maple_node cache
by not skipping "rounding up to the next kmalloc size" step for explicit
sheaf capacity.

Copying and pasting the patch here:
> mm/slab: round up sheaf size to kmalloc size for explicit sheaf_capacity
>
> calculate_sheaf_capacity() calculates the size of struct slab_sheaf from
> the capacity, rounds it up to the next kmalloc bucket size, and then
> recalculates the capacity from the rounded-up size so that no memory
> is wasted within the bucket.
> 
> However, when the user explicitly specifies args->sheaf_capacity and it
> is larger than the capacity calculated by the heuristic, this round up
> step is skipped.
> 
> This wastes memory for maple_node cache. Its object_size is 256 bytes,
> so the capacity calculated from the heuristic is 26. Rounding up
> increases the sheaf size from 2 + 26 * 8 = 240 bytes to 256 bytes
> (kmalloc-256), yielding a capacity of 28.
> 
> But since the maple tree cache explicitly specifies a capacity of 32,
> the final capacity becomes 32 without any round up, and the sheaf size
> becomes 32 + 32 * 8 = 288 bytes, which is allocated from kmalloc-512.
> In other words, 512 - 288 = 224 bytes are wasted per sheaf.
>
> Move the round up step after max(capacity, args->sheaf_capacity) so
> that it is also applied to explicitly specified capacities. With this
> change, the round up behavior becomes consistent and the sheaf capacity
> of maple_node becomes 60 and does not waste memory anymore.

It does it increase memory usage for sheaves because it's reusing wasted
memory, but it could end up more memory being used as each sheaf
now caches more objects.

> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> ---
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f9b56cb439e709..4fa551bf02cd64 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7895,17 +7895,19 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
>  	else
>  		capacity = 60;
>  
> -	/* Increment capacity to make sheaf exactly a kmalloc size bucket */
> -	size = struct_size_t(struct slab_sheaf, objects, capacity);
> -	size = kmalloc_size_roundup(size);
> -	capacity = (size - struct_size_t(struct slab_sheaf, objects, 0)) / sizeof(void *);
> -
>  	/*
>  	 * Respect an explicit request for capacity that's typically motivated by
>  	 * expected maximum size of kmem_cache_prefill_sheaf() to not end up
>  	 * using low-performance oversize sheaves
>  	 */
> -	return max(capacity, args->sheaf_capacity);
> +	capacity = max(capacity, args->sheaf_capacity);
> +
> +	/* Increment capacity to make sheaf exactly a kmalloc size bucket */
> +	size = struct_size_t(struct slab_sheaf, objects, capacity);
> +	size = kmalloc_size_roundup(size);
> +	capacity = (size - struct_size_t(struct slab_sheaf, objects, 0)) / sizeof(void *);
> +
> +	return capacity;
>  }
>  
>  /*

[-------<8 end of the patch-------]

> testcase: will-it-scale
> config: x86_64-rhel-9.4
> compiler: gcc-14
> test machine: 256 threads 2 sockets GENUINE INTEL(R) XEON(R) (Sierra Forest) with 128G memory
> parameters:
> 
> 	nr_task: 100%
> 	mode: process
> 	test: brk2
> 	cpufreq_governor: performance
> 
> 
> Details are as below:
> -------------------------------------------------------------------------------------------------->
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20261009/202610091451.beda4ec3-lkp@intel.com
> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
>   gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp1/brk2/will-it-scale
> 
> commit: 
>   675a745c61 ("EDITME: cover title for sheaf-size-round-up")
>   ddf56dfc79 ("mm/slab: round up sheaf size to kmalloc size for explicit sheaf_capacity")
> 
> 675a745c6113e420 ddf56dfc79f5734d7b3aa8ba81f 
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>   70440501           +54.5%  1.089e+08        will-it-scale.256.processes
>       0.30 ±  3%     +35.9%       0.41 ±  8%  will-it-scale.256.processes_idle
>     275157           +54.5%     425248        will-it-scale.per_process_ops
>   70440501           +54.5%  1.089e+08        will-it-scale.workload
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

