Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD1C4CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37778E000B; Fri, 26 Sep 2025 11:25:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0F268E0001; Fri, 26 Sep 2025 11:25:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6728E000B; Fri, 26 Sep 2025 11:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C5D238E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:25:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 503AA13BA49
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:25:33 +0000 (UTC)
X-FDA: 83931775746.07.670D25E
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3AC0240005
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:25:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=JdGYshqh;
	spf=pass (imf04.hostedemail.com: domain of deller@gmx.de designates 212.227.17.22 as permitted sender) smtp.mailfrom=deller@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758900331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBEia6yUD1SBa38/HIyR72UJEAIarSpkneHXmPkZOh8=;
	b=vxkLo7ESSrxa+38RhOscQSTbHuA4KN/P9Tgi2uE9VM/NF2ntQHRi7kQcwCY5J5Nrj2lWns
	ufaQnjLPH/mSM6bJ2M+FmBbgjr+9i+/zKqM5wK8P1mj1qy/p/PPsq/QQCREQEVdQsrO4rA
	MhBNoWAiylEvJoz4OBDuNTFxtFklmRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758900331; a=rsa-sha256;
	cv=none;
	b=QaWAZIbqINf1wJ5TsJkTfJXIJugb0vdjy1zWftTVjWBDxS+I2h7zTpLk9gHGiDKByUFZxl
	l/GJh5mqtIGgYRTB6swntZe0ffTIN85dCEstU5N9upbis7p+kmAPyHlmBuhHlD6n5qpDh3
	JG9hOF8YdgyAAq7PqwPYbucVLrtwlGY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=JdGYshqh;
	spf=pass (imf04.hostedemail.com: domain of deller@gmx.de designates 212.227.17.22 as permitted sender) smtp.mailfrom=deller@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1758900315; x=1759505115; i=deller@gmx.de;
	bh=sBEia6yUD1SBa38/HIyR72UJEAIarSpkneHXmPkZOh8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=JdGYshqhbWbVa+O5U4Zmfk+62oYXg6fU7ZeQOW6E8bG/9+nAfQXqV9DEaIxwE+Ex
	 Am5PJG/NaXKWWjavVeiCEOiaI1055wq6TKAMWWXfkaT8OewiWHZ07nbMgHWEhV5AM
	 +Rlo5sp2m1flYMkh2mD1DwTdDXWQcKDmrbPFP0Jq0xf0NHwocAst680snO2QpPGPS
	 jwLx6zq3Ja+WEWKoDs1RIdeS782t4Wpu82cfn9bCbPSMrn0JZk3+E6JJ2Hz/TGSwI
	 MU8uJzTXyrKg0zgczy8oQ9kHM+4iTR8A/d0VhqTqe4vY0+8Wp7XhtUzvtCtPssaMH
	 Fzz2wBBcMSV59kweOg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.55] ([109.250.50.237]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N8XPt-1uFvOE18r3-0155Ql; Fri, 26
 Sep 2025 17:25:15 +0200
Message-ID: <33e8db9a-7749-44ae-a2a6-27f3e6e8a3e0@gmx.de>
Date: Fri, 26 Sep 2025 17:25:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] page_pool: Fix PP_MAGIC_MASK to avoid crashing on
 some 32-bit arches
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Mina Almasry <almasrymina@google.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Helge Deller <deller@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-mm@kvack.org, netdev@vger.kernel.org
References: <20250926113841.376461-1-toke@redhat.com>
Content-Language: en-US
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
In-Reply-To: <20250926113841.376461-1-toke@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qj5PwXC6XTYykXtwY3s7nh1lKXX4MfkE/K94AHVnw1nGWUGEqU/
 2IIhFPZFmKUnn8WUoznbVDblMG3TcXoKEmF8H2uNbg4/Ea/ttgV12hVbdiNCfWgpC97QobH
 NRUPkeNEhkkuhVBYO5XMqKHgpeopwv4wE8CdWVwa7NKQEQ1vai4M8kfaQkj7HhUt6VT/ICN
 xbO7E18A9HhohU16r28kA==
UI-OutboundReport: notjunk:1;M01:P0:1M+uPGdYhNI=;eDtJRfpsA+Wx7RSEg6BcaahBR4I
 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
X-Stat-Signature: na7zhgo7dz1hxoj3fbn1pnjdhub8ek37
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AC0240005
X-Rspamd-Server: rspam10
X-HE-Tag: 1758900330-185199
X-HE-Meta: U2FsdGVkX19P4b7mMPmps1c4nezI88dv1aLpaizKSSMXwIlOfFJgcB/kQiJxdc43+EfOnFVuyr3txGD2NBqOPYcvX10xOLSXLCdPHcZiVBgAurGPfqcgiPNGMP44OI+phzhkjHI0GBRRttcuSCqJp9crEXnxZSYHeJH/LG4epNq7a8Pep2abEPNq8dP8233C5aLstn+qXh2qAYyGy3esNe0LxWvlhKRo7j2OuI+iBTd4Wfmx/g9yYrq2utqh7UfcqF8SLuAlKkLTlbvSnjK9FRK5FIrBWnbxsb85fsR57U1JIoLBtqNgvVVgHIv67O8DCSqjNqzRj9V6LU++YLEN36nWwpoS/WMhHdmPuvZu4GrPmnTYFmgbau245UxFFxrJsVjUL5JiQsmwrAm6Byw0X1RWuJVT+VD7tXK+qPJud47LgHPpCOGbY3llBtUZk+EOtFvhYDpiH6UUXyszKljeqyEHIIc4CO54tGsN6YzuexHEhJ5XU4wkcWDExBdgzWNFO1G+7bK8G/Hgrv7LHU0gguvCZlX6Khfqyr2C5T7Z7ZW3q8EENJM/RI3C1d9TuMTkB0TeHM1YkVUEjJNBtqkHnPjw7ZDA6iREo/N+W1PANNcn8MDQx+T1eaQ6pkCShDpRZ0Fcv+nkKRD09iVeuuVfGxmkodg0bFnVpR0BUsvzYXr6C0Q7eM0Qef2DDQKG1A2DKPnP3hYM/F3XFdARd3XQhWoyUAqiBol9SxmyZBxCdI0G2HBRNHsPLHfnQuwj8Q0f+fhcp1z+9Kf4C/BDeuedWxU2RqWKR4UWSwhpahQJd+ySN1uk2MFmvFKeTJws3CwpOo0H4ABp8+wAcaTZxK407t1Sh758wyfS2ttvcLlNzx0AjPPhNhQKWxbvwNQ5505OZ4JLmNpYlV/dv0xNFXQCRiIDH9dxNRidMwFc8l0SlCK6UnvrJQp94fpZl48LbhOA24UCi14CUSC1Io3L7+x
 hKQIRQj/
 xrzV0ZfrxQTW7arSFzPv1arHNIerETRFGTn1LjJASn3WSkfOtmIz7Vfrq1jKc/rIQGJCKH6nl5RCHut3Cj21ipMOKjhkrxn6pyk+iiQR0VqTe1G0IxB2Cp3yk/JeXFYoE0FRyXGwJ3d8MVDko9s25Drs7Dzk5Uq4hitY2wnVy7PX+Wl+WqTGDOA5mOiWSmtjAQophv+/P4arvlu+wiXFzKSd8V24aVmZAJcu5UmR3xAJo9PBdhr8pSTM7TtNBa5VrMjVFxV8jmn5EmNONEA2/iF2G617jeINKjZ/PNdLbe4z0xw5HZpktAdCCul0fRrXyWVWLlRDJ52tmCj0Pg5fTtcF5S2EQrIL9AF7SZwx+p1OnALVy8x3CTCsUvcBxqbZ4H5JvTllJajqaNMknd5mc9IMW7U7vDofBb23d8YU9Xg9yKl7O6cUampKlRB3JiQMxS9ZpKKbIhrcRyY8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/25 13:38, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Helge reported that the introduction of PP_MAGIC_MASK let to crashes on
> boot on his 32-bit parisc machine. The cause of this is the mask is set
> too wide, so the page_pool_page_is_pp() incurs false positives which
> crashes the machine.
>=20
> Just disabling the check in page_pool_is_pp() will lead to the page_pool
> code itself malfunctioning; so instead of doing this, this patch changes
> the define for PP_DMA_INDEX_BITS to avoid mistaking arbitrary kernel
> pointers for page_pool-tagged pages.
>=20
> The fix relies on the kernel pointers that alias with the pp_magic field
> always being above PAGE_OFFSET. With this assumption, we can use the
> lowest bit of the value of PAGE_OFFSET as the upper bound of the
> PP_DMA_INDEX_MASK, which should avoid the false positives.
>=20
> Because we cannot rely on PAGE_OFFSET always being a compile-time
> constant, nor on it always being >0, we fall back to disabling the
> dma_index storage when there are no bits available. This leaves us in
> the situation we were in before the patch in the Fixes tag, but only on
> a subset of architecture configurations. This seems to be the best we
> can do until the transition to page types in complete for page_pool
> pages.
>=20
> Link: https://lore.kernel.org/all/aMNJMFa5fDalFmtn@p100/
> Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them w=
hen destroying the pool")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
> Sorry for the delay on getting this out. I have only compile-tested it,
> since I don't have any hardware that triggers the original bug. Helge, I=
'm
> hoping you can take it for a spin?

I can't comment if the patch is otherwise ok, but it does
indeed fixes the boot problem for me, so:

Tested-by: Helge Deller <deller@gmx.de>

Btw, this can easily be tested with qemu:
./qemu-system-hppa -kernel vmlinux -nographic -serial mon:stdio

If the patch is accepted, can you add the CC-stable tag, so that
it gets pushed down to kernel 6.15+ too?

Thank you, Toke!
Helge

>=20
>   include/linux/mm.h   | 18 +++++------
>   net/core/page_pool.c | 76 ++++++++++++++++++++++++++++++--------------
>   2 files changed, 62 insertions(+), 32 deletions(-)
>=20
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..28541cb40f69 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4159,14 +4159,13 @@ int arch_lock_shadow_stack_status(struct task_st=
ruct *t, unsigned long status);
>    * since this value becomes part of PP_SIGNATURE; meaning we can just =
use the
>    * space between the PP_SIGNATURE value (without POISON_POINTER_DELTA)=
, and the
>    * lowest bits of POISON_POINTER_DELTA. On arches where POISON_POINTER=
_DELTA is
> - * 0, we make sure that we leave the two topmost bits empty, as that gu=
arantees
> - * we won't mistake a valid kernel pointer for a value we set, regardle=
ss of the
> - * VMSPLIT setting.
> + * 0, we use the lowest bit of PAGE_OFFSET as the boundary if that valu=
e is
> + * known at compile-time.
>    *
> - * Altogether, this means that the number of bits available is constrai=
ned by
> - * the size of an unsigned long (at the upper end, subtracting two bits=
 per the
> - * above), and the definition of PP_SIGNATURE (with or without
> - * POISON_POINTER_DELTA).
> + * If the value of PAGE_OFFSET is not known at compile time, or if it i=
s too
> + * small to leave some bits available above PP_SIGNATURE, we define the=
 number
> + * of bits to be 0, which turns off the DMA index tracking altogether (=
see
> + * page_pool_register_dma_index()).
>    */
>   #define PP_DMA_INDEX_SHIFT (1 + __fls(PP_SIGNATURE - POISON_POINTER_DE=
LTA))
>   #if POISON_POINTER_DELTA > 0
> @@ -4175,8 +4174,9 @@ int arch_lock_shadow_stack_status(struct task_stru=
ct *t, unsigned long status);
>    */
>   #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA=
_INDEX_SHIFT)
>   #else
> -/* Always leave out the topmost two; see above. */
> -#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - =
2)
> +/* Constrain to the lowest bit of PAGE_OFFSET if known; see above. */
> +#define PP_DMA_INDEX_BITS ((__builtin_constant_p(PAGE_OFFSET) && PAGE_O=
FFSET > PP_SIGNATURE) ? \
> +			      MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_SHIFT) : 0)
>   #endif
>  =20
>   #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHI=
FT - 1, \
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 36a98f2bcac3..e224d2145eed 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -472,11 +472,60 @@ page_pool_dma_sync_for_device(const struct page_po=
ol *pool,
>   	}
>   }
>  =20
> +static int page_pool_register_dma_index(struct page_pool *pool,
> +					netmem_ref netmem, gfp_t gfp)
> +{
> +	int err =3D 0;
> +	u32 id;
> +
> +	if (unlikely(!PP_DMA_INDEX_BITS))
> +		goto out;
> +
> +	if (in_softirq())
> +		err =3D xa_alloc(&pool->dma_mapped, &id, netmem_to_page(netmem),
> +			       PP_DMA_INDEX_LIMIT, gfp);
> +	else
> +		err =3D xa_alloc_bh(&pool->dma_mapped, &id, netmem_to_page(netmem),
> +				  PP_DMA_INDEX_LIMIT, gfp);
> +	if (err) {
> +		WARN_ONCE(err !=3D -ENOMEM, "couldn't track DMA mapping, please repor=
t to netdev@");
> +		goto out;
> +	}
> +
> +	netmem_set_dma_index(netmem, id);
> +out:
> +	return err;
> +}
> +
> +static int page_pool_release_dma_index(struct page_pool *pool,
> +				       netmem_ref netmem)
> +{
> +	struct page *old, *page =3D netmem_to_page(netmem);
> +	unsigned long id;
> +
> +	if (unlikely(!PP_DMA_INDEX_BITS))
> +		return 0;
> +
> +	id =3D netmem_get_dma_index(netmem);
> +	if (!id)
> +		return -1;
> +
> +	if (in_softirq())
> +		old =3D xa_cmpxchg(&pool->dma_mapped, id, page, NULL, 0);
> +	else
> +		old =3D xa_cmpxchg_bh(&pool->dma_mapped, id, page, NULL, 0);
> +	if (old !=3D page)
> +		return -1;
> +
> +	netmem_set_dma_index(netmem, 0);
> +
> +	return 0;
> +}
> +
>   static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netme=
m, gfp_t gfp)
>   {
>   	dma_addr_t dma;
>   	int err;
> -	u32 id;
>  =20
>   	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
>   	 * since dma_addr_t can be either 32 or 64 bits and does not always f=
it
> @@ -495,18 +544,10 @@ static bool page_pool_dma_map(struct page_pool *po=
ol, netmem_ref netmem, gfp_t g
>   		goto unmap_failed;
>   	}
>  =20
> -	if (in_softirq())
> -		err =3D xa_alloc(&pool->dma_mapped, &id, netmem_to_page(netmem),
> -			       PP_DMA_INDEX_LIMIT, gfp);
> -	else
> -		err =3D xa_alloc_bh(&pool->dma_mapped, &id, netmem_to_page(netmem),
> -				  PP_DMA_INDEX_LIMIT, gfp);
> -	if (err) {
> -		WARN_ONCE(err !=3D -ENOMEM, "couldn't track DMA mapping, please repor=
t to netdev@");
> +	err =3D page_pool_register_dma_index(pool, netmem, gfp);
> +	if (err)
>   		goto unset_failed;
> -	}
>  =20
> -	netmem_set_dma_index(netmem, id);
>   	page_pool_dma_sync_for_device(pool, netmem, pool->p.max_len);
>  =20
>   	return true;
> @@ -684,8 +725,6 @@ void page_pool_clear_pp_info(netmem_ref netmem)
>   static __always_inline void __page_pool_release_netmem_dma(struct page=
_pool *pool,
>   							   netmem_ref netmem)
>   {
> -	struct page *old, *page =3D netmem_to_page(netmem);
> -	unsigned long id;
>   	dma_addr_t dma;
>  =20
>   	if (!pool->dma_map)
> @@ -694,15 +733,7 @@ static __always_inline void __page_pool_release_net=
mem_dma(struct page_pool *poo
>   		 */
>   		return;
>  =20
> -	id =3D netmem_get_dma_index(netmem);
> -	if (!id)
> -		return;
> -
> -	if (in_softirq())
> -		old =3D xa_cmpxchg(&pool->dma_mapped, id, page, NULL, 0);
> -	else
> -		old =3D xa_cmpxchg_bh(&pool->dma_mapped, id, page, NULL, 0);
> -	if (old !=3D page)
> +	if (page_pool_release_dma_index(pool, netmem))
>   		return;
>  =20
>   	dma =3D page_pool_get_dma_addr_netmem(netmem);
> @@ -712,7 +743,6 @@ static __always_inline void __page_pool_release_netm=
em_dma(struct page_pool *poo
>   			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
>   			     DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
>   	page_pool_set_dma_addr_netmem(netmem, 0);
> -	netmem_set_dma_index(netmem, 0);
>   }
>  =20
>   /* Disconnects a page (from a page_pool).  API users can have a need


