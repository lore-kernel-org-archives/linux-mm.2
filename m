Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4810C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAB586B00A1; Wed,  5 Aug 2026 04:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55AF6B00A3; Wed,  5 Aug 2026 04:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43EC6B00A6; Wed,  5 Aug 2026 04:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D1A66B00A1
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:58:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02FC61603B2
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:58:53 +0000 (UTC)
X-FDA: 85066615788.15.02D7AB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 494D7140002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:58:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KlIpfN7x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785920332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8E02zUyJckQYhE5enS+lGdT4ua0BRylSXq2EHJzB0I=;
	b=XQ4sjcs1xI+50MFLyc4GJkGq9+5QBdopZx2y+mpytzv3NBmJbu6UJjWweJQAgSGr2lz2db
	Tt5CEcatQuh3PJ+kKPVprOKY7lXQhFfW96Ieh6KUAe82QaX1Q0RIxVuP7YeA4E+nnPP47T
	7fVr33WwqDVSCFtcC2MBp3fJQ1f+NaU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KlIpfN7x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785920332;
	b=XjPiMT7Fc9bXlvUidhUtj1GL9UnqgPlKOAEuculAbmDGRYUNRp5ncCh9XzofGIgV5F01j/
	ome0oNnxAhwqpew90ITaZqLEHcz2Cns8nkoz/18D81iUVg9kWdyXnkv3EdVmZnwLo9NO+3
	WURHYJ6nAqkKGag9BNHZRCB/OnIDrhA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 58D11600AE;
	Wed,  5 Aug 2026 08:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FA21F000E9;
	Wed,  5 Aug 2026 08:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785920331;
	bh=j8E02zUyJckQYhE5enS+lGdT4ua0BRylSXq2EHJzB0I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KlIpfN7x0gpYPoR9+bN/kCSh/rh0uUpndP1K5upedsbukXV7kqdxpk3rC/GckJwq9
	 s0z6MQGXfwxzwUE/RP6kRQMiOd3OiJSLSW+MOKGbjH5z24dwkXcSG6vmwQ7cXI/2vw
	 EcqBQTXbacVpnvhLo8TmyCxkRAXOlilLFofG4KaMmyagcKKgL4Nj4lV6EZ2fJTtgSR
	 6Q3AhLG81CP1AhvIaQX0CKG82Oj+sCp/50qj6EoGKuNekmfA/y03Eti2w4V7S6NgkO
	 TcT9KZJ5Z3AhBHIWzvgUQFr6xnNqNRft5FXal6zcIcqEU1dv2I6rWRrHnS6GTPfHm5
	 z7v5HH/Xqo7hA==
Message-ID: <c5658175-8d1d-4aec-9a66-b07d53f75547@kernel.org>
Date: Wed, 5 Aug 2026 10:58:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] Only free healthy pages in high-order
 has_hwpoisoned folio
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 William Roche <william.roche@oracle.com>, Jiaqi Yan <jiaqiyan@google.com>,
 linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org,
 osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
 nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev,
 liam@infradead.org, rientjes@google.com, duenwen@google.com,
 jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, shuah@kernel.org, surenb@google.com, mhocko@suse.com,
 boudewijn@delta-utec.com
References: <20260705180714.3708947-1-jiaqiyan@google.com>
 <85cb7ea8-8116-4092-8310-69b61eb8602c@kernel.org>
 <ee6bcc74-0846-43f2-bcca-b1bedff74351@oracle.com>
 <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org>
 <168ad406-f6b5-4623-adac-9f894e410e48@kernel.org>
 <8f787434-5326-4a8f-92d0-467e817a23b4@kernel.org>
 <8e48c288-2183-4d58-b69d-5f78344b5da5@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <8e48c288-2183-4d58-b69d-5f78344b5da5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 494D7140002
X-Stat-Signature: px4owq8gj3esnmarp6cmjitteih64xn3
X-Rspam-User: 
X-HE-Tag: 1785920332-82517
X-HE-Meta: U2FsdGVkX1+YuX2QIF2RdHJioOY4yBMuOOhehlYY+NdqjHhIJ7FKZvSq8hayWKEFl2LKdZ/quld7TAeLnKc5gnI/VfN8mKOpHgFk9JsoZNESe07WU34S4xEBxoSLAaNEkhPPTtIFsybXAD3bBqMGwtqwetnzptrIL/jdsOFBIo8AzjJmEX3cLOXNIRjumuHaPd3recbJTAkRPcqVZ69vMGQawXF7oowJ+9dLHEnlTe6k4OhbpKkfFugsjab1Jn/EsM/DitVksIENKRAs7nc6WhPhk/P3LPdh1YMeUCjK4E10PaWx3/X2WKhxUEffioZyJ2qJoSxay7uw/QvczcuMEqXnA66rf26S2x1w/J4X8aePjH3hazGGxZpCFpnfsGTpPGkIUWkiNTqvFptWrxqcqrXTf+eWMYPWSjQfd8VWHNqG8EK5WFAYFYPli93rmByE/5NrIYg00T38wgQ0CyqvZ6vRHfOqcbgtUZpfMXUtUD5y3wN5CpsHYRGvkGUZ5OJ/M3p2gGKQUoMsTfZ2T6xfnAnEpvzB1B47wwJf6/OA4xHSOVpA91A+BNkkSJ0RPMn1rYd23Ik0j4k7iTMnkyzRtkmvkfEL0SXeGsk1vi21dotWacEupiDmfPkRDN8hzfBoL8QksVzkaUym5TjbNjo4OE5pPxIdNJ6oT+VmENeT+qL5C8LZRaxND9BvyDTb+WrDEX+GLHPVmZXJLUjC7IWAIHhqbd3HO2p7KeHXnc+byHWjc/47o/qGP6no48fXObMUyoJHQ+WW/zfediN/ttvGQmO4Qie4iH4RyC1alCiUFYhg6N2rwTYYQzeOtwj+3POREJSOAmjnlu3G28lVBbnlAv9IJhNk+2lslf1Rhl/TXFl80u71/AJ+r9p3eQ2wSiRoXc3IPtXDQheZdZ9CL19rY+S96MZu4LtYA6XPYv/gfcJ7Juixw4pFt8dr1oLlrAwy0c5fqi9hyny5UuJbgSJ
 g+WsEtr6
 Yz60IUlWkbxeXVWBnq6B6kIx8oJMa8pHSZ4E6vp4KO3Q7B81IgvfgDkmua9ekCf7C7G4N2S/KlmWNu1+pmOk4orbzse3bV4SSyKqZ5SPPaAe+5NaeZzIt/o0Fbm6eZ9b6FqryJ9pgXZal2OUdxzyZpn1jGCs1/ypMjrPSN8ySKehmAiwxwG/SRBg1sD33UhNskAIX1Nkxxx4rDh2dnRHbWM5Bjef/ltD9ZaV6N1KyS+shbNSSANqJOz1BJJO4JH4v1gj7bLa7iYSnkVckDIJE5gLx4THqHQzhUrYrQzh3Gdz+YhT419LNwaFpSmBE1KZbk04sOHcIJ1rY36adu6A0Ez9T9xr3B97lhKl/5vbFzBUHwxErPlgTo7oA31k07U9m76sVzrYHFXLDegbaI83udwT9n2HXEVPZpvMkogBmJhP4L8c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 21:51, David Hildenbrand (Arm) wrote:
> On 7/28/26 19:18, Vlastimil Babka (SUSE) wrote:
>> On 7/27/26 16:20, David Hildenbrand (Arm) wrote:
>>> On 7/22/26 10:27, Vlastimil Babka (SUSE) wrote:
>>>>
>>>> Would it truly fix the issue, or rather there would still be a race window
>>>> left where we check that there's no hwpoison flag in the re-enabled check,
>>>> and only then someone sets it?
>>>
>>> Why are we checking PageHWPoison at all then in check_new_page()?
>> 
>> We check all kinds of unexpected state, when that's enable. PageHWPoison
>> could have been considered unexpected too, when the checks were made more
>> and more optional (first by Mel and then me).
>> 
>> But indeed it seems the PageHWPoison check is supposed to be load-bearing
>> (hi, Lorenzo!). It's intentionally handled before bad_page() (with a taint)
>> in check_new_page_bad(). Commits 2a7684a23e9c and f4c18e6f7b5b are also a hint.
>> 
>>> I think we created a mess.
>> 
>> Yes, the PageHWPoison handling was made part of debugging sanity check and
>> then not recognized properly as load-bearing later.
> 
> BTW, I'd assume we can check for PageHWPoison at free time fairly efficiently, as we
> touch all page flags already.
> 
> Something along the lines of:
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 520ebd2fa40b5..57f89f8684168 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1321,6 +1321,7 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>         bool init = want_init_on_free();
>         bool compound = PageCompound(page);
>         struct folio *folio = page_folio(page);
> +       unsigned int hwpoisoned = 0;
>  
>         if (fpi_flags & FPI_PREPARED)
>                 return true;
> @@ -1347,21 +1348,6 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>                 count_vm_events(UNEVICTABLE_PGCLEARED, nr_pages);
>         }
>  
> -       if (unlikely(PageHWPoison(page)) && !order) {
> -               /* Do not let hwpoison pages hit pcplists/buddy */
> -               reset_page_owner(page, order);
> -               page_table_check_free(page, order);
> -               pgalloc_tag_sub(page, 1 << order);
> -
> -               /*
> -                * The page is isolated and accounted for.
> -                * Mark the codetag as empty to avoid accounting error
> -                * when the page is freed by unpoison_memory().
> -                */
> -               clear_page_tag_ref(page);
> -               return false;
> -       }
> -
>         VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
>  
>         /*
> @@ -1395,8 +1381,26 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>                                 }
>                         }
>                         tail_page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +                       hwpoisoned += PageHWPoison(tail_page);
>                 }
>         }
> +       hwpoisoned += PageHWPoison(page);
> +
> +       if (unlikely(hwpoisoned)) {
> +               /* Do not let hwpoison pages hit pcplists/buddy */
> +               reset_page_owner(page, order);
> +               page_table_check_free(page, order);
> +               pgalloc_tag_sub(page, 1 << order);
> +
> +               /*
> +                * The page is isolated and accounted for.
> +                * Mark the codetag as empty to avoid accounting error
> +                * when the page is freed by unpoison_memory().
> +                */
> +               clear_page_tag_ref(page);
> +               return false;
> +       }
> +
>         if (folio_test_anon(folio)) {
>                 mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>                 folio->mapping = NULL;
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> 
> 
> Of course, we could also fallback for order>0 to do some smart splitting.

I think the freeing part is relatively fine, as tackled by this series.

> Checking on allocation efficiently is indeed a bit more tricky. For compound
> pages prep_compound_page() will already walk all pages.

Yeah and non-compound high-order pages should just go away eventually, so I
wouldn't worry about making them slower now.
But it's tricky because prep_compound_page() happens later when we don't
expect anything to fail anymore, so it would take some refactoring.

> Having hwpoison logic to just sync with the buddy when setting hwpoison flags
> would be nicer.

I suggested that (soft-offline does it). There might be some downsides, but
I can't judge how much they would manifest in practice:

https://lore.kernel.org/all/CACw3F50nVECJ%2Bk4g%3DQVZ80yzi_awCOcUiCuB0CYcUfxND9-7Tw@mail.gmail.com/

> Then we could (maybe) have the rule that no hwpoisoned page can enter the buddy, and no
> page can become hwpoisoned while in the buddy. Consequently, no hwpoisoned page can
> leave the buddy (except weird races while allocating, but then it's just an allocated
> page).

I'd love if that approach was feasible, yeah.

> Maybe.
> 


