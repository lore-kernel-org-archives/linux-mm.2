Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1EFCC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845916B009D; Wed,  5 Aug 2026 05:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815F06B009F; Wed,  5 Aug 2026 05:10:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705066B00A3; Wed,  5 Aug 2026 05:10:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50C476B009D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:10:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B95321A040C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:10:04 +0000 (UTC)
X-FDA: 85066643928.13.324864F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 112C618000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:10:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Px0z7sfd;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785921003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=arisYwSnWIrQ0tx47rogqMxiybhAxWfzJtYPr/R4Eb4=;
	b=avipJLCvW718a6CqRrnxUYJhfm1U3dUp++ePWMoE1AKjcMyvH29dYbgRAEH1E1XSyzY/GF
	mfNXv7xsZqxiqST14DfxXp/C6au/oR8WWYg7BAxyspKkqEx1oSIGy+AaoCbsLS05y4WeRq
	FLn5TQKGFJyE0eYo6CIK1MueWm6rTtg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785921003;
	b=ElPHEfMavmi0qlhakwp1utA3R7xnpdxhZaccvRsWeQlryI61kpiWGsYdcX8ApG+A4Faln0
	3FTc0leMCOm65tGn49t3F6JzjvxG+VfzfuwfPdxOHPB7lFwAtx0MfX+2UM3HjGz6oqlX9I
	OezsvEiBjqSVxlz3aTU7Nkbg3vHw9e4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Px0z7sfd;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 91FAE60A6F;
	Wed,  5 Aug 2026 09:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B2C1F000E9;
	Wed,  5 Aug 2026 09:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785921002;
	bh=arisYwSnWIrQ0tx47rogqMxiybhAxWfzJtYPr/R4Eb4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Px0z7sfdQLWiFeeGeuiGfraKia/ALAVkdoC6cZGvsboSC7PDRrVvINt+qrvlE/Y5K
	 07KQWxsxUHJz4wVUtIKbNSC8S31uWkYadOZGecrSulQKq784W6DyBQ+aPGdig/5jXH
	 O8EUkdD1t7FsAsXAnRt57lmSyOgTFi8+0ubHAqX+IkhbQvb6OHbd06JpPopa9w9u+x
	 58qysMsfszh2cvS5Sjm2RMGUOHHlIobXo3t+DHLYEyKhydIoEQxkbXCpxUDhdYaB/D
	 hKtbSon5A7qgK5lvI/vZbUzU8/2MakRf1r/sJn7pP4On+5GbeH8+5X4+H5nyH5Ul/h
	 DtcsL84/b2ccQ==
Message-ID: <352e1f42-2e89-4445-a20e-572ee35c7a0c@kernel.org>
Date: Wed, 5 Aug 2026 11:09:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] Only free healthy pages in high-order
 has_hwpoisoned folio
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
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
 <c5658175-8d1d-4aec-9a66-b07d53f75547@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c5658175-8d1d-4aec-9a66-b07d53f75547@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 112C618000C
X-Stat-Signature: sriwbih5phpjcmm8s8syyeh9fu1d1c9f
X-HE-Tag: 1785921002-332869
X-HE-Meta: U2FsdGVkX18EaCVHSUj5eOjMk7+iLJddJPAKj++FNLSWKXdqTN0DJ6mA7ciM4oT2bv7lZFTERoxTJHBHD8bKamA6svSiCxzreRZ+Txg4xlWnmiCFwvn3IWZmZhUFuKikFeocx2eAnN31Ij+4GUgEEpFi/vNsiJhCH0R7pmWANuqX1rkER8f/iK7jcXPTNBa6DzwYrF84skgH846CYGti5frBlpXEvPn1JaMnSQsFLFxdCcUyJnvgbbhl5jAxkjck8+EcA966LOA73UP+Yo9iiOkm2HcqKO3AzJTkYV6W+ZvqWQZacS4cUap3ug8pLQYHteExcA3ub/++CsU3KteROzXicuGsHVkEVG6ZBgRq7VBI9Aktwpd2y3RzVUxqNZgP9JtGdYRWXDcoqgYMdqN7XyWzdaEK3WEIGp7FZa0X9TVuUjYm05Gk9MRKNHrwYOVZq3bT1nlyKYIPtyNO9voYHeU9RrfdGYQ3zok+jOLvs4Sr6RBZuk+CWMlWerhbw3ob0Fu8QZfyjO7raqFuotFHq5eVny8CJvk+EKqvfjviUqFOiNGs0wDkrXZMWkrmNVRx5wCJeFRH75Lxk/tbATVAB+L1W3892twfFaHNqwvypNFlE49sFTC3t+jrVCUaExCLDQ6cYDTchquqEK0mewwoGl+C8PajFo/E8mj7B6MkTrLpHm0TZK9hZp/CQTfQxuL1mpOY6JM1L0qyQ+vTehq6fokAvzXmltJjZfSzitA6g4KCOWntbyHtyF9CXeMFuG8eswrsvp0kaoEIsKXeCRode5IK7Z08mYrpBk7PYb0lkuRp7rL55RddQtyUp8cI7rP6pz9OGrUV5AgJXes5LyzWRDqqIDOc3qwYTTbgN1vWsL62+WB9qb6HvIvfBRKtNbZAJHlZlfioMeopBIBkB7lelWmFdrpxwsaxoEtcg2TvEDB0J7MCHPskWj/YKSM5g3BTn9SXsVBtCmBA53dvIdZ
 XbItIKU3
 njI6kIYEX2uOaOI+9ZVdfZiGFNtOYckikedistjXVYO8VQ7GB9hF0rTbda0fkmKM+gTeOc8+meTAQ2DkFP9zcN6Hb1Azo2q8eFAczNK95be4lTqlhinabMxa3ubMB9MUUcXqddgYLIWwgY4ZXWO5JRSce3uiEg/tgZNn/dwrMA9mua3QlH5+cRZ3CnAI2SwKK5TcQ0jPgpFH0As1lNNs/Bt40JoNkJ8pDltSdxY7SSBcbJu9zfGlIrWYlx9tvgsFOGQIoDJvHDPNp14ye9U9mTyV+SftICUsW6TYS40AubuQs6fqsdOmjvo0htlnhSORUt5TJNkcFvFlViiATui+l25Jg+bqrIRvHJMjBq8Idd5VnOQH+QT8aZWHc6AXXBC8UzwrFMXEA+n+eM1KVvTalhuwEAuqWfHuLHlYwtp02DAK4VGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 10:58, Vlastimil Babka (SUSE) wrote:
> On 8/4/26 21:51, David Hildenbrand (Arm) wrote:
>> On 7/28/26 19:18, Vlastimil Babka (SUSE) wrote:
>>>
>>> We check all kinds of unexpected state, when that's enable. PageHWPoison
>>> could have been considered unexpected too, when the checks were made more
>>> and more optional (first by Mel and then me).
>>>
>>> But indeed it seems the PageHWPoison check is supposed to be load-bearing
>>> (hi, Lorenzo!). It's intentionally handled before bad_page() (with a taint)
>>> in check_new_page_bad(). Commits 2a7684a23e9c and f4c18e6f7b5b are also a hint.
>>>
>>>
>>> Yes, the PageHWPoison handling was made part of debugging sanity check and
>>> then not recognized properly as load-bearing later.
>>
>> BTW, I'd assume we can check for PageHWPoison at free time fairly efficiently, as we
>> touch all page flags already.
>>
>> Something along the lines of:
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 520ebd2fa40b5..57f89f8684168 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1321,6 +1321,7 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>>         bool init = want_init_on_free();
>>         bool compound = PageCompound(page);
>>         struct folio *folio = page_folio(page);
>> +       unsigned int hwpoisoned = 0;
>>  
>>         if (fpi_flags & FPI_PREPARED)
>>                 return true;
>> @@ -1347,21 +1348,6 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>>                 count_vm_events(UNEVICTABLE_PGCLEARED, nr_pages);
>>         }
>>  
>> -       if (unlikely(PageHWPoison(page)) && !order) {
>> -               /* Do not let hwpoison pages hit pcplists/buddy */
>> -               reset_page_owner(page, order);
>> -               page_table_check_free(page, order);
>> -               pgalloc_tag_sub(page, 1 << order);
>> -
>> -               /*
>> -                * The page is isolated and accounted for.
>> -                * Mark the codetag as empty to avoid accounting error
>> -                * when the page is freed by unpoison_memory().
>> -                */
>> -               clear_page_tag_ref(page);
>> -               return false;
>> -       }
>> -
>>         VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
>>  
>>         /*
>> @@ -1395,8 +1381,26 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>>                                 }
>>                         }
>>                         tail_page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
>> +                       hwpoisoned += PageHWPoison(tail_page);
>>                 }
>>         }
>> +       hwpoisoned += PageHWPoison(page);
>> +
>> +       if (unlikely(hwpoisoned)) {
>> +               /* Do not let hwpoison pages hit pcplists/buddy */
>> +               reset_page_owner(page, order);
>> +               page_table_check_free(page, order);
>> +               pgalloc_tag_sub(page, 1 << order);
>> +
>> +               /*
>> +                * The page is isolated and accounted for.
>> +                * Mark the codetag as empty to avoid accounting error
>> +                * when the page is freed by unpoison_memory().
>> +                */
>> +               clear_page_tag_ref(page);
>> +               return false;
>> +       }
>> +
>>         if (folio_test_anon(folio)) {
>>                 mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>>                 folio->mapping = NULL;
>> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
>>
>>
>> Of course, we could also fallback for order>0 to do some smart splitting.
> 
> I think the freeing part is relatively fine, as tackled by this series.

I think we should really do something like the above to detect hwpoison, to then
fallback to a slow path.

> 
>> Checking on allocation efficiently is indeed a bit more tricky. For compound
>> pages prep_compound_page() will already walk all pages.
> 
> Yeah and non-compound high-order pages should just go away eventually, so I
> wouldn't worry about making them slower now.
> But it's tricky because prep_compound_page() happens later when we don't
> expect anything to fail anymore, so it would take some refactoring.

Agreed.

> 
>> Having hwpoison logic to just sync with the buddy when setting hwpoison flags
>> would be nicer.
> 
> I suggested that (soft-offline does it). There might be some downsides, but
> I can't judge how much they would manifest in practice:
> 
> https://lore.kernel.org/all/CACw3F50nVECJ%2Bk4g%3DQVZ80yzi_awCOcUiCuB0CYcUfxND9-7Tw@mail.gmail.com/

Agreed.

-- 
Cheers,

David

