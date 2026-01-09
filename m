Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00715D26D60
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 15:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2746B0088; Fri,  9 Jan 2026 10:11:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475B36B008C; Fri,  9 Jan 2026 10:11:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34DF16B0092; Fri,  9 Jan 2026 10:11:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 21D566B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:11:34 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C0DCA1AAAA
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:11:33 +0000 (UTC)
X-FDA: 84312764466.02.8C88CE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1400D8000B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:11:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fSZakySj;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767971492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=khwm/bSHN3PX1PjrnS+3+ckVaSBmWQQcHL+HzPjFWbg=;
	b=KjYlmwnWzCYfmJVLfV8XsOHvp/VRfQSz4VAFDFLEPK1dXT528letal+6lRZTx9ia05mwsj
	ka1kHn+G6IfIYNxfegxFJj6F/Md+3WjYgbnY75Bo+YlnYXXUzA9srIAQywG8mFdm+tq+5h
	WW9DkOPb2SJEW26P2LITRqy0u2zV29k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fSZakySj;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767971492; a=rsa-sha256;
	cv=none;
	b=dvm9d8sGGBOlVGwvfPhMOdCRzIYcM53TSsBtYdIqDjzjzo83uLrrPkG/Te6Dd5QobXyaGi
	FsO+My7VzxBEovizma8nMfiJp/WOMRYNW5vyQ3wl6OCtC7msXPkz7LncFVK9nxP+AS3/Vi
	cz2qJkELCdrVWimRuZGCmRMPDR4oBcs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 748E360151;
	Fri,  9 Jan 2026 15:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6881BC4CEF1;
	Fri,  9 Jan 2026 15:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767971491;
	bh=2FBHrNHxevA7xEit3psQVoy33Em494KJnTdG6Fnk1wY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fSZakySjexp8G8Uu0Qz+AYFvOBvbPowqbgQ+u6hdU2jft9SSsnDPMWYRtoerKCThb
	 Tppz6LSNxEvQN4B9A9LDh6y0sc3f2AHa9NEU/RBwVUABwOaxQrIpJoHb8n6XJ7WFEN
	 c/ZU1/QBoUtebaWN/Ju+kycH1+Cly3f4wJTUCBLvHX3BPt/2aqZLfjlYuD/oGHE0GG
	 m6s+4abpx0NmFh77ux70vvjS9d0q4YDTJHvM6PTOQjb0F77l3ZCZEUTqcLuAjB3XZB
	 RLJEluiUmxXo9lCYUf9xDgtCZDZB5UFvabEDn0SngYXQVnYrio2l5wgUDbENPT+rIt
	 W0mlzL2k1ZzRA==
Message-ID: <85033126-c60a-4cac-8f6f-5bd2f6102fec@kernel.org>
Date: Fri, 9 Jan 2026 16:11:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] mm: Add folio_split_unref helper
To: Zi Yan <ziy@nvidia.com>
Cc: Francois Dugast <francois.dugast@intel.com>,
 intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 Matthew Brost <matthew.brost@intel.com>, Balbir Singh <balbirs@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alistair Popple <apopple@nvidia.com>
References: <20260109085605.443316-1-francois.dugast@intel.com>
 <20260109085605.443316-2-francois.dugast@intel.com>
 <59fb1669-2908-4cab-b3c0-b97479da3fb9@kernel.org>
 <1319a24a-bcfc-47e5-a022-f5d00994acc9@kernel.org>
 <A5512463-283A-4137-B4A8-780783C5DF0E@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
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
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAa2VybmVsLm9yZz7CwY0EEwEIADcWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCaKYhwAIbAwUJJlgIpAILCQQVCgkIAhYCAh4FAheAAAoJEE3eEPcA/4Naa5EP/3a1
 9sgS9m7oiR0uenlj+C6kkIKlpWKRfGH/WvtFaHr/y06TKnWn6cMOZzJQ+8S39GOteyCCGADh
 6ceBx1KPf6/AvMktnGETDTqZ0N9roR4/aEPSMt8kHu/GKR3gtPwzfosX2NgqXNmA7ErU4puf
 zica1DAmTvx44LOYjvBV24JQG99bZ5Bm2gTDjGXV15/X159CpS6Tc2e3KvYfnfRvezD+alhF
 XIym8OvvGMeo97BCHpX88pHVIfBg2g2JogR6f0PAJtHGYz6M/9YMxyUShJfo0Df1SOMAbU1Q
 Op0Ij4PlFCC64rovjH38ly0xfRZH37DZs6kP0jOj4QdExdaXcTILKJFIB3wWXWsqLbtJVgjR
 YhOrPokd6mDA3gAque7481KkpKM4JraOEELg8pF6eRb3KcAwPRekvf/nYVIbOVyT9lXD5mJn
 IZUY0LwZsFN0YhGhQJ8xronZy0A59faGBMuVnVb3oy2S0fO1y/r53IeUDTF1wCYF+fM5zo14
 5L8mE1GsDJ7FNLj5eSDu/qdZIKqzfY0/l0SAUAAt5yYYejKuii4kfTyLDF/j4LyYZD1QzxLC
 MjQl36IEcmDTMznLf0/JvCHlxTYZsF0OjWWj1ATRMk41/Q+PX07XQlRCRcE13a8neEz3F6we
 08oWh2DnC4AXKbP+kuD9ZP6+5+x1H1zEzsFNBFXLn5EBEADn1959INH2cwYJv0tsxf5MUCgh
 Cj/CA/lc/LMthqQ773gauB9mN+F1rE9cyyXb6jyOGn+GUjMbnq1o121Vm0+neKHUCBtHyseB
 fDXHA6m4B3mUTWo13nid0e4AM71r0DS8+KYh6zvweLX/LL5kQS9GQeT+QNroXcC1NzWbitts
 6TZ+IrPOwT1hfB4WNC+X2n4AzDqp3+ILiVST2DT4VBc11Gz6jijpC/KI5Al8ZDhRwG47LUiu
 Qmt3yqrmN63V9wzaPhC+xbwIsNZlLUvuRnmBPkTJwwrFRZvwu5GPHNndBjVpAfaSTOfppyKB
 Tccu2AXJXWAE1Xjh6GOC8mlFjZwLxWFqdPHR1n2aPVgoiTLk34LR/bXO+e0GpzFXT7enwyvF
 FFyAS0Nk1q/7EChPcbRbhJqEBpRNZemxmg55zC3GLvgLKd5A09MOM2BrMea+l0FUR+PuTenh
 2YmnmLRTro6eZ/qYwWkCu8FFIw4pT0OUDMyLgi+GI1aMpVogTZJ70FgV0pUAlpmrzk/bLbRk
 F3TwgucpyPtcpmQtTkWSgDS50QG9DR/1As3LLLcNkwJBZzBG6PWbvcOyrwMQUF1nl4SSPV0L
 LH63+BrrHasfJzxKXzqgrW28CTAE2x8qi7e/6M/+XXhrsMYG+uaViM7n2je3qKe7ofum3s4v
 q7oFCPsOgwARAQABwsF8BBgBCAAmAhsMFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAmic2qsF
 CSZYCKEACgkQTd4Q9wD/g1oq0xAAsAnw/OmsERdtdwRfAMpC74/++2wh9RvVQ0x8xXvoGJwZ
 rk0Jmck1ABIM//5sWDo7eDHk1uEcc95pbP9XGU6ZgeiQeh06+0vRYILwDk8Q/y06TrTb1n4n
 7FRwyskKU1UWnNW86lvWUJuGPABXjrkfL41RJttSJHF3M1C0u2BnM5VnDuPFQKzhRRktBMK4
 GkWBvXlsHFhn8Ev0xvPE/G99RAg9ufNAxyq2lSzbUIwrY918KHlziBKwNyLoPn9kgHD3hRBa
 Yakz87WKUZd17ZnPMZiXriCWZxwPx7zs6cSAqcfcVucmdPiIlyG1K/HIk2LX63T6oO2Libzz
 7/0i4+oIpvpK2X6zZ2cu0k2uNcEYm2xAb+xGmqwnPnHX/ac8lJEyzH3lh+pt2slI4VcPNnz+
 vzYeBAS1S+VJc1pcJr3l7PRSQ4bv5sObZvezRdqEFB4tUIfSbDdEBCCvvEMBgoisDB8ceYxO
 cFAM8nBWrEmNU2vvIGJzjJ/NVYYIY0TgOc5bS9wh6jKHL2+chrfDW5neLJjY2x3snF8q7U9G
 EIbBfNHDlOV8SyhEjtX0DyKxQKioTYPOHcW9gdV5fhSz5tEv+ipqt4kIgWqBgzK8ePtDTqRM
 qZq457g1/SXSoSQi4jN+gsneqvlTJdzaEu1bJP0iv6ViVf15+qHuY5iojCz8fa0=
In-Reply-To: <A5512463-283A-4137-B4A8-780783C5DF0E@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1400D8000B
X-Stat-Signature: cogbd3wiyf4yj7fxu8rpquo5yf5ofsoh
X-HE-Tag: 1767971491-839085
X-HE-Meta: U2FsdGVkX1+Yd4pVPtiq6/mXPMbtQj0ucNwscLi1xbGSgs9AkxirGzsE14NqEpnjUMx4vmOsXAnDcIQTOdIOU4EiZrm0XhIPbcG9QNOOTmofcn0j2qXS5K3FtJnZlAAiZqzyzV/2G1yINNk53dhjMr5fkr2+pqm6G3Y5CS+UJxPiglXtpNZCAgntW9wDOfWxRm1VJfvFq2Jaj0tlpKWxH5C00BWhmC7SM9+kFt+DvlxgytCH21dtPv06kUHUYqioIAo8EwJ3OyxujyfsVMFmWrobCg014piht3c6wKByWrYnQp6edHMEShG7lcj8VMaUhxhLcKpyp87xFstMuV5KvVYwEJfJ937FTjnHyM5o560pgeIJy0Q3RO4UUgxE+8gDqVJkJ/t4EYXh2sGi3yl4Xg9cWCyMtw517SuDyTS8xm5bRhQMnBgGRA4ZwUXNu0EC5COtKgccIbDqt25yLW9Ao6lfRmEnKT9r9JJKYVZbcbXcecMf+9hX/NJyj7Wh2XDjErTJGNG2Jc7lDak7Wd62yiKeyrc3UFgaspGgmoeqF9U2Zb4GOnnAJYF3cQQutLXAEm49uBQeo7Hq32icLt8xQ6CHqdDqsbLYhXSXxmSmsyOr9zLom7//GI/B00Lr2XBNtAR6EppOcF16blgFTsccPogXELSRiiqEfsjg41RTZQgonAYThFlywiTHB4RpeVSanZ2bQD8FblYVQmGYPq60iBa+QA3WpgXZRnkIvVYGXIXB2rkSrr7rqSv/D1ErdY8dh4X2eA7kYqyGl55hx9wdsBmdA80u53Gjf+sL9RS5EDfr7Bjizv7J6bg/fDGJYXvfr2WfHF71ZTArSvm7tXuWGL1WKvRtVU7ZfaX3/HHoNU+FXGRAgIcpxBCb4fTmRjRNG03CEQVDhFQeXOL3UzcN21ARj3/t/KECc+dRdqJPKgu2ZplsxZRr1EzX+D4eAhyHxUDRc4gA5foyb73g15F
 veFKf2t4
 iBT6CsMSvzKX6H2vWW/C6n65Fz2tgDRztIVMRDEV3ZlYT0QQegTVmuw6Ji93pneF2h+mzAWxRY5+aDMYWHvQL93toErZfdwcuQ6fIaitAY57ZFeZBIkyPHuTnpacWvjajh6xrMEWvTufZLwcUksfOoHFIIGYpbktmUVWlxVqfmMga38Dq3cQQHO6A+RfkzyDIoD6ZFrie/+RPy8xH7ZuhBuVXgRg2EhjjIhmKPI3xYL2CPvXTbWte03mPLxnCn2sGfZRgH1GRGu7deXb5AFP8qQDvXi7gQRTnB3FfGKjvPdWuw6f1xSwufa6RBP5T+ertoalCML87qJNg0mA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/26 15:30, Zi Yan wrote:
> On 9 Jan 2026, at 8:26, David Hildenbrand (Red Hat) wrote:
> 
>> On 1/9/26 14:19, David Hildenbrand (Red Hat) wrote:
>>> On 1/9/26 09:54, Francois Dugast wrote:
>>>> From: Matthew Brost <matthew.brost@intel.com>
>>>>
>>>> Add folio_split_unref helper which splits an unreferenced folio
>>>
>>> split_unref reads like "split and unref".
>>>
>>> You probably want to call this something like "folio_split_frozen" ?
>>>
>>> The very definition of "frozen" is "refcount = 0 ", so you can simplify
>>> the documentation.
>>>
>>> Are the folios you want to pass in there completely unused (-> free) or
>>> might they still be in use (e.g., migration entries point at them during
>>> folio split)
>>>
>>> So I am not sure yet if this should be "folio_split_frozen()" or
>>> "folio_split_freed()" or sth like that.
>>>
>>> I'm not CCed on the other patches in the series or the cover letter, so
>>> I don't see the context.
>>>
>>
>> Ah, I was CCed on #3 where we call this function on folios that are getting freed.
>>
>> In that case it would be acceptable to initialize folio->mapping (and folio->index?) of the split folios. Do we also have to initialize folio->flags, folio->private etc?
>>
>> See __split_huge_page_tail().
>>
>> folio_split_freed() would likely be best, because then it is clearer that there is absolutely no state to copy from the large folio.
> 
> Yes, basically, we do not have a reverse function of prep_compound_page() and
> open codes the reverse process in free_pages_prepare(). For zone devices,
> zone_device_page_init() calls prep_compound_page() to form a folio but
> free_zone_device_folio() never does the reverse. FS DAX has its own
> dax_folio_put() to do it. Alistair suggested to come up with a helper
> function for both FS DAX and free_zone_device_folio().
> 
> Maybe free_zone_device_folio_prepare() is better. And put it in mm/memremap.c.

That would be even better, if we can limit this completely to zone_device.
-- 
Cheers

David

