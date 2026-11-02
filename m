Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E6C606A924
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VovVNp2p
Received: by kanga.kvack.org (Postfix)
	id 4FB5F6B05C4; Mon,  2 Nov 2026 09:49:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4736B05C5; Mon,  2 Nov 2026 09:49:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410306B05C6; Mon,  2 Nov 2026 09:49:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 260AE6B05C4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:49:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3DA4A695C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:49:45 +0000 (UTC)
X-FDA: 85390463130.18.B7D9BA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id F387B140010
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:49:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VovVNp2p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWoSxjQdMw8UivKHOKImqNiHmJUj5F5WenhpQwDvMLg=;
	b=FVx8iS8LU1AFTFB4A+HJkzo9CmXDi/N4tVjBlU8s7hKddx+ZPXrMzoqOHnWulBcw8ILHzQ
	FZMd5lX0ufuN88c1Q7pOHfW9cC2rsbMgw3KwLbxyEsFFzwtaJR85u3wx+6LAORhsFMeVJs
	R66ve0c+tARipkiM6B2qzb7ibAk/FFk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VovVNp2p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630984;
	b=6C3zSom0LHqWhAqmfreAg6OOD603zU2n9yqQejOqbCbzOlvvlVc8aE+ypOdTDuhWEkM2hm
	3nqY+Hw0z9iWHsWmLMZyW9tSiPva8BUQYABSg4rvuYKp6ZHxPWWwPYu2e2pT//U/iAjSBk
	oo/111oi/3ez6IeHp5tI45DIJ12baGE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C9AA43965;
	Mon,  2 Nov 2026 14:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7C81F00A1A;
	Mon,  2 Nov 2026 14:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630983;
	bh=XWoSxjQdMw8UivKHOKImqNiHmJUj5F5WenhpQwDvMLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VovVNp2p/+WUkh+42qpFU37+vJQ1cl+UoTmYTPm1xl7saMJI+Sr6zkDbOCrK4LeN7
	 3tb4Ee551fvubrjMQuUNXkfN8dTq/3+M9DRYdH0ws/q3QUATZQPuXE/731HV4w1Tv2
	 GJZRoccrQPP3c+OzSPa/85YEs8QgAaBoRpK03ACzy4f4XrRIUjTC384+TkVpjZfmHd
	 akciCQCD6Jdhsqj8YYEOseVq5zGkTZVsbwAeNT7gJ3orZStw6qef+FwCbKeiokrUS4
	 IWR1/46X8tRUE5yw2ZhcwAxKviT7O1hbKQJC6To6CIW1Twq9gtmkKXGck9WA6QAheH
	 f+UJyNEqZ48SQ==
Date: Mon, 2 Nov 2026 14:49:40 +0000
From: Harry Yoo <harry@kernel.org>
To: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	loongarch@lists.linux.dev, bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/slub: Genericize x86-specific cmpxchg16b comment
Message-ID: <auihvtpGJPDbb4Hz@thinkstation>
References: <20261102082730.12430-1-yangtiezhu@loongson.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102082730.12430-1-yangtiezhu@loongson.cn>
X-Rspamd-Queue-Id: F387B140010
X-Stat-Signature: nqao1assow5fsfq4bdjyca81juoys9rd
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793630983-501091
X-HE-Meta: U2FsdGVkX1/RuLtZ6jFsWpU2PYO8hJxefFW46OoQmITr2UDkOphNvKJlZwLxylILHUhlLshbb9eZHLvOmmMO0vM1+gEAL8WpJ5X7MaUbc1GjBBe3Lc+OBBax1P4+WgQconYIeHt0DiQtEuEl4nnPrkWTP8JJSfhvN6wG2T2MbfoR/0Y0NomDadn4gkP6fj4oeP/b+cpR0HPLtlxUO7C0wMzzX7u3OppKs6qNk/Q/Yli8HSQQZoa2/HnB7bB2CtA+NxeOzi9coSTPztgSMRP0mWeWjvhgJduEDI8dNBETq3s2fUQipvjiDCiFXt8NmsM4+FHa8nyKqgbXopc6jqahZJ5IRDb4Csj8O82cyV+1B+4VVTbXZABGaBcQQRM+JT6snL1xfjvG94ln9X/5wJEMrv92owKWQ/8MY73rcyMGzKdirp/p8/XFI1Xp6Q+gQlK5Q3iyhFvZhfS/0kM5hcncbadvA0u6U/fBLyyvkXXAkQPeFsWfUY1VFmdzH7hMKhAuqanAFdEC4WWKxFKWNz/Oqb4miNMmFHoQdItvobaCtoWNUqwDNWU0MW0BLFPQfZD+6VEhycCQ/jJExEXayGjKfpfSnUd8XyUW+P5Plj380WgwPVXqzhx6nbhDp757gp9AIZehU8KTuy9CSbilwGL0zBnJmeGXtqHo5A84zbcAIjR4CxOq5rXVIQYeKqMFvZAIt6cqpFD0uurdSmfgkB3LfC9nSyNgp96LjFwaJNgfWRU6AbR4hUW1wBgNS5Wl1z87yNRKnEqYr2NW8IXuJoPTBryJSqPbH9hC6UmSwyAX/i1ApQkNrDsQiXCa3/zE8v10lmENTYYv+zI49jLsR5W4wSY2IAwSBnpDItOVCy/wf6/TEb5A1rQTQhFVCbua/9Bb6wgCLEHt0GDi7rQ0RsCc5QImRnbb3wpSmETPAPA9Iz0Xu7WkTuf0WOzHJ5t7dwQpOvlJ54s1ZrQK3DbRbqF
 sM13lucc
 hs3It2tAsl0fbUrRHTP6Ik1QPEZRfjMJZlqYVAdTXa9X5KZxj2wIaH7fFBQmowFqKAvGD4700Z34oQhjZCyMzpKmalZBrKBl/ICfkjcZT51GBVcCc5njRCj5QoKzH0rA6TlUNTZBoJuClLWUOdhbi90oGQdXSUG3m8fEvY9yVZEnCP+2uxf7c+3bJdJSCnCsYSq/4J/JXRgdXj1KbOYb/aHor0/T1XoO/CPlzlgICAx2lpD2PxfLDphybPdL+jfCS97V1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 04:27:30PM +0800, Tiezhu Yang wrote:
> The kmalloc_nolock() infrastructure relies on slab caches with double-word
> atomic cmpxchg capabilities (__CMPXCHG_DOUBLE). The current inline comment
> in __kmalloc_nolock_noprof() uses 'cmpxchg16b' as the prerequisite hardware
> capability.
> 
> However, "cmpxchg16b" is an x86-specific instruction mnemonic (CX16). On
> modern architectures supported by the Linux kernel, this 128-bit atomic
> primitive is satisfied by different hardware implementations:
>   - arm64: satisfies it via LSE atomics ('casp' instruction)
>   - s390: satisfies it via native 'cdsg' instruction
>   - riscv: satisfies it via ZACAS extension ('amocas.q' instruction)
>   - loongarch: satisfies it via SCQ extension (using an 'll.d'/'sc.q' loop)
> 
> Update the comment to refer to "128-bit atomic cmpxchg" to accurately
> describe the cross-platform hardware invariant needed by the lockless
> allocator, and to avoid misleading developers of non-x86 archs.
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>  mm/slub.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 45e077c7526c..216bc6b5d776 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5589,8 +5589,8 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
>  	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
>  		/*
>  		 * kmalloc_nolock() is not supported on architectures that
> -		 * don't implement cmpxchg16b and thus need slab_lock()
> -		 * which could be preempted by a nmi.
> +		 * don't implement 128-bit atomic cmpxchg and thus need
> +		 * slab_lock() which could be preempted by a nmi.

maybe "double-width atomic cmpxchg" is more accurate considering
e.g.) x86-32 implements cmpxchg8b?

>  		 * But debug caches don't use that and only rely on
>  		 * kmem_cache_node->list_lock, so kmalloc_nolock() can attempt
>  		 * to allocate from debug caches by
> -- 
> 2.42.0
> 

-- 
Cheers,
Harry / Hyeonggon

