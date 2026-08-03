Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A2DAC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813726B009E; Mon,  3 Aug 2026 09:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB766B009F; Mon,  3 Aug 2026 09:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703CC6B00A2; Mon,  3 Aug 2026 09:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 483D86B009E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:04:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7843C0682
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:28:42 +0000 (UTC)
X-FDA: 85059433284.21.B229F2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id EBCC440005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:28:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W+fpwFs/";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785749320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hUNX++3BEUzA26hicxStbuLxQDCbIeizijI0OkQjZck=;
	b=J3v1QhUOQ8I7w0zGHu/S/DaSYIc/fDNf5qnjqX4nr+yJRSItbrQVb16oCdhZeu2PeGY2kj
	kKVv4HyItdLTMNrmEfFulwk/dlf96g3FZMujwXg3cDmG2o7TSuVMJ1HHT6v71xqX/NfMng
	SNuzaf2rn/Qz980IV025xi4L0GcjY8o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785749320;
	b=cfZmse8ecCx1JJ3ujQh1V5FCgTz/3QvtdP6gZm83PLj7Oziqf/ZzvFhHOZkBOi5flkBz5K
	qZv1nLw8Z8WgN7p7uUrfPJ7eG7k9URKwReYEnyAdpgS2kl5xGI/7UkDqeBV3im/Hqekckh
	uRqRc0F3l2oBpeSMYkhZHPBnqsGb9AE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W+fpwFs/";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7BB4160A64;
	Mon,  3 Aug 2026 09:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED211F00A3A;
	Mon,  3 Aug 2026 09:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785749320;
	bh=hUNX++3BEUzA26hicxStbuLxQDCbIeizijI0OkQjZck=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W+fpwFs/JXd5ssh7ZvqoPV4mgc6cns70ZX82HVprWFINNlekvxdEDGQYq0twhE/dB
	 4Nbt/63rh/mObIY9W+yhKvUJOcQjMvj7Vsgyag0DGFxrXWFn46NBCinM+2Rgyd8Bm3
	 nuvqJgmZX+QMcWIx5hoohcLZEG1JC9pBLOxXNrZ8ZthH1exCXltLZLXzz8QZQjko94
	 mba5S+VDexpjZxkcwNS3O2GNS6RbufGYkp+nMb6iJP7wSyoEsg1PGKjivG0uCHtvkq
	 JbodFQKyDMkbGFNRhIhWlbv/RkYeyj86XbV2obzzLiaopEoV22UedVvElH0i3qEDue
	 0F5qBmbU65dJg==
Message-ID: <2ac2746f-18b4-4960-8628-82e87c2140ce@kernel.org>
Date: Mon, 3 Aug 2026 11:28:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/15] mm/vma: introduce VMA anon page offset field and
 add helpers
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-1-e8ecfefea812@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-1-e8ecfefea812@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EBCC440005
X-Stat-Signature: t69843cd5cmuc8u81kkddq8f5fy1idzd
X-Rspam-User: 
X-HE-Tag: 1785749320-223745
X-HE-Meta: U2FsdGVkX1/l4QFGGokcpycP/ITGoOLpgVyZCPFXfee2PmrS6LZTNb+nwKFRyJWaSGsMIc2OL5Z0Tb9MiRsUg/uFpRfBhI9DqhOJM5XjD248/gYJbzXeD+dqCPOMbJHiaOPiQfz+VStM1eyxB6m3dq8SiBch/Eeas/Nm8q0e95toBwKoQwN8nGrmh0zVryKqXDYCMC0Ty9JrImJ1TDSRbo0z3yV5RoWHMO1XhZAVCilLNUIpllsruQPssJYBL23yxiQVl2S6rydBvCdPMOoZhNOrJ0MV9pJeI57prNAXLiOF7QHBgjmxsCa/tY6szIuk6PeQKIidkm7PnHneYDcodRWHqT4M6owCuAQy2LRAdRFGIsNj5zycczBjHb1z/K4Qll8FQ4qexRs7Yp3EozuM7ChX5Upae5r4FocI4CXxc0qqK6n2FW0D2oeabpIjhe29Wmq1KEW4rKaEzXU3uIx5trt/tRf0jjNpH8YZbALfBl2LZD77b38oJtQuut+/HjhGo1PrDkvlnU5VcWI5NVjot5lJKzmWofZdgd1Kxgnn3uYOJEXCkwSrp//DKZeG6WA97gutxUEJ6Nj2aVsabH514+NGTKlIV1ECJfpgCl0rLNPpeJ9yfoQTrhfV6MhDwdDJnICtzm9RdlRnKE3z6JI5VbnNpfQbhN9pN7m31/YRWm3n5mr34LOppi3P87KA3fbQW6C/rx6ThHVujpWTRm6I6489jP93TsNP5AGdDKTNRw6weZ7vvmaxREjItApzCPXsWQTrBsYzLQD6+4KNCGZKbTaCNvJyHfinvLxWY341CtCSa0jjWEbUd+CBhtr4qLos8IP32DgjZq9EMLllg0PlARH/3dCt8gwhDj6FAMeEON+FDEwu2jODWE5KrbQ/4N3yxitFgXocEZEx62Z3UKvKqpNoW63OdD3riGvAMoIPGx8Uq/UJ0OECdUfBfAIGtkFyFPn825i95sBhT9XyvPS
 EaSJp5qo
 TRvPPe1Df2eH4+sQCcaLgwxrvr7lXYHHpd0ejnITyxFa50Q3mkA/MhtcjmNOx5jymsojyIHhHXiYP9WRr5Bdny+DiW3q+tmOaxs2Ui9RnkbOi/WzK6aVWx6y3eadrL9jA5AVZaIPtOsDP9+Zfi1rNL5OsKQ6QwP/4v2g5SoHvmO43nCdcARVOlmv6N4sJU5Mseyeqz/0DDf31iSff16eq/DrNBip/kGo0+Vc2b2EflpbZdFvNyLemLlhux0vAAfG6EEvjTGcSRQgcDNG8i3GHdDKzAVGNS6Ia+TLBzu1WFFwTVb8sdnjkS4XD8X5uvN3cehDtMnpGxoW09ORO9wCbrM6RmuXYKmO48k13xd6K/KxGqzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> This patch establishes fields within the vm_area_struct type to store the
> anonymous page offset of VMAs.

Nit: Avoid "This patch". Just say "Establish ..." (I was surprised to find
that even Documentation/process/submitting-patches.rst document this)

> 
> The anonymous page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT
> if they are unfaulted or were not remapped, otherwise it is equal to this
> value at the point of first fault.
> 
> Currently, anonymous folios belonging to CoW'd MAP_PRIVATE-mapped
> file-backed VMAs are tracked by their file offset. By adding anonymous
> offset as a property of VMAs, we can now track them by their anonymous page
> offset instead.
> 
> By tracking this, we provide the means by which to eliminate this
> inconsistency, and more importantly lay the foundations for future work for
> the scalable CoW anonymous rmap rework.
> 
> This patch simply adds the fields and some simple helpers. Subsequent
> patches will update mm code to make use of these fields correctly.
> 
> The fields chosen are packed in the VMA such that, for 64-bit kernel
> builds, no additional space is taken up.
> 
> The first field is present on cacheline 0 containing key VMA fields, and
> the second on cacheline 3, which contains file-backed reverse mapping
> fields.
> 
> Given the relative time spent accessing reverse mapping fields as well as
> updating them, there shouldn't be any performance impact here from false
> sharing.
> 
> Update the VMA userland tests to account for this change.
> 
> No callsites are updated yet, so no functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

[...]

> +static inline void __vma_set_anon_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
> +{
> +#ifdef CONFIG_64BIT
> +	vma->__vm_anon_pgoff_hi = pgoff >> 32;
> +#endif
> +	vma->__vm_anon_pgoff_lo = pgoff & GENMASK(31, 0);
> +}
> +
> +static inline void vma_set_anon_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
> +{
> +	vma_assert_can_modify(vma);
> +	__vma_set_anon_pgoff(vma, pgoff);
> +}
> +
>  static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
>  {
>  	vma_assert_can_modify(vma);
> diff --git a/mm/vma_init.c b/mm/vma_init.c
> index 715feee283f0..baa7e82f47e3 100644
> --- a/mm/vma_init.c
> +++ b/mm/vma_init.c
> @@ -51,6 +51,7 @@ static void vm_area_init_from(const struct vm_area_struct *src,
>  	dest->vm_end = src->vm_end;
>  	dest->anon_vma = src->anon_vma;
>  	dest->vm_pgoff = vma_start_pgoff(src);
> +	__vma_set_anon_pgoff(dest, vma_start_anon_pgoff(src));

It would be cleaner if both interfaces would either contain "start" or not contain it.

The former would be better

	__vma_set_start_anon_pgoff(dest, vma_start_anon_pgoff(src));

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

