Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E462EF585D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75ED6B008A; Mon,  2 Mar 2026 04:22:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24436B008C; Mon,  2 Mar 2026 04:22:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05876B0092; Mon,  2 Mar 2026 04:22:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7F896B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:22:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6FD351401E5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:22:27 +0000 (UTC)
X-FDA: 84500582334.13.5EFA529
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D574D40004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:22:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o2gC5hVL;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772443345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=spA0gB4WuN79VSNLmlUAzeNv79Xt2yNPQM9pOy5BVZA=;
	b=eWX743oB+dQxnGfm4dfay8VYTQMbS0SKAyrgejAeWJuoRueGH+0slD8+UwBUYtkurB4PZc
	5bRP8h1D2LnT7DtvIdFEdthndJuQQ/Qr/y8Xnv1SE7zSfXtDL198IevP/pp5e5gClqSaNX
	OlORoiKKuP6BcXYk9DLiKrAAqbIOv/c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o2gC5hVL;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772443345; a=rsa-sha256;
	cv=none;
	b=4vkxAEngF2es5lN2bqPKLExtg/zywW1IwhY3HcT99rvFUxi109QLeMFDHaay4JlNb2tlLb
	+LyQip0tHHBA+fO/GGCtlFzxQWLb+icHaddoRWg8SX0dFVYrmYfcxZwz1wJz6dUB4QNYKu
	Cv3foRsKeqUE5HlyZUDvTEBh8zPK3ew=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 325CF60051;
	Mon,  2 Mar 2026 09:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1618AC19423;
	Mon,  2 Mar 2026 09:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772443344;
	bh=nbC0ylUKiP1HSzmLN0OJl81tXkj5BTod+QU+DGkfcKc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=o2gC5hVLdZmWdItHMW8xful7ap9O+ctt94k9AcA4tYhBGW2ch1K6X/Eu4tQO3nv9Z
	 IhGAC+5rar+6KROCUfRmq6uYFgVcZS8vUaeU/zG/8SxlLvMyBSY4OTjhC+f1h4HIzS
	 VoLJ8hW+Fhk7W67yKqpsE3daPuA1Zz3RUoigVkJpPWqVdT+geU3uIHs+kZifEz2m6b
	 G7zGIpzjmZ2euDbDHZ82kB7nmj1iCZqUVAaCOiWH5uCaMw4lcrdZxcb5lMKPn0gGpE
	 uXB0xpwyHK7w057vOwHp4b9wfW8ADtR+mmtuWwh9Q7QJsftUayhMNU9kymp722eEEX
	 mVmgnpsTcsK5g==
Message-ID: <5182bb7d-f7cf-4b8e-8320-996c52fe24d8@kernel.org>
Date: Mon, 2 Mar 2026 10:22:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/13] mm/migrate_device: Introduce
 migrate_pfn_from_page() helper
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, jgg@ziepe.ca, Felix.Kuehling@amd.com,
 jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
 ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <20260202113642.59295-2-jniethe@nvidia.com>
 <9ee22635-a219-47bb-a397-bc4e141b408d@kernel.org>
 <cf547dbb-af45-49d0-87a0-5267dedf0470@nvidia.com>
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
In-Reply-To: <cf547dbb-af45-49d0-87a0-5267dedf0470@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D574D40004
X-Rspamd-Server: rspam07
X-Stat-Signature: eymtkg8uqx1hibd1pyifei56rsyzd8yn
X-Rspam-User: 
X-HE-Tag: 1772443345-760572
X-HE-Meta: U2FsdGVkX1+uHMBBPW2IAsyh6+PI7AXxI9Btosk1JH0QzIjKaZ1UJLBcmmPQ8yNPaqeDEfMnO44Cvv3omvgdMfFVO5bJG+ksUuHsLEPBnPi4afWnqhZmEHQeDtQECF16LG4P/R6Xl8cTFzEqfregP9njyTE0l+RJ7OMSLNh0f7ICDIuEmttX7sGlhEqK9HSQ3U0H72WTXFF5nAuPwrwNLEsWi4W+m4PchBChgKY3TqWR75TeatLayDetorG/6c8bGN8DzO/bV/Ht1YyVQFD7F5wBsLNYOyfKX1vN3SmW9i2Kxlk/uYTzoXALE+FDqR+uRnbliNRUWa+Nx0MG2Eg4QXiWg3PpCJB7ocRPl9YCGWOJZ7hOcq+hzoE7+EQvcqcFghy+KAjSG5fwKenV9CcNfNBiPKQdsNlYJLpksZeaqCXT4taCxjFBhkalSIC2b4fv1FP+dOurUQIxDz2kfsTQSNecdEbcx9Y1lY9zR75CrZT0OnS2DFwT81861hzn1uwHRavLPiudg8viCGvI/6uRxBkPLQg/4ZoKccuFsyx7sBVBih0Y62iGyeFDPtDPa7LX1w2o3+miWdRS5he4z/JHKAFckOMWMGA6s0rGq0Wttc00FzqlKl1kqYJuoEvPcxlyYHNyfxUfhyJBlXVqT9EWN+KNe1uJ11aUd4+palQ7YPmbOZa6/4n36/TXCZba8jrB5LAL/DtOJ1rjVLplCfKNSWFb3c60oydIEMrX+Oy+Ooks/Vxb2jCzVtFK/0WXn2e9J0UhlpAqbaCWqh65IZIaokEJyjpCMRzPBTjImfSQ7eytXTbRpJJiECfL6a4vx7+Abwh+dIQ9tD2ljjI1egBZ9P+SM0ViFSkxm5Jhe0m1ubc9YkUbVekXCf7yHlGIpS2qWy/YPZKayJSmrJvMHaczarws1WemVTkxi2ROKwDFGHK/RzORgIItwtl9k/rMyAliu0lbAkY6PTdHotmTs73
 MNNu6RUH
 QkfcF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 00:38, Jordan Niethe wrote:
> Hi,
> 
> On 28/2/26 08:11, David Hildenbrand (Arm) wrote:
>> On 2/2/26 12:36, Jordan Niethe wrote:
>>> To create a migrate entry from a given struct page, that page is first
>>> converted to its pfn, before passing the pfn to migrate_pfn().
>>>
>>> A future change will remove device private pages from the physical
>>> address space. This will mean that device private pages no longer have a
>>> pfn and must be handled separately.
>>>
>>> Prepare for this with a new helper:
>>>
>>>      - migrate_pfn_from_page()
>>>
>>> This helper takes a struct page as parameter instead of a pfn. This will
>>> allow more flexibility for handling the mpfn differently for device
>>> private pages.
>>>
>>> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
>>> Acked-by: Felix Kuehling <felix.kuehling@amd.com>
>>> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
>>> ---
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

I'll go through he remainder of the patchset this week.

While skimming over patch #2, I was wondering whether
"page_to_migration_pfn()" would better fit "migration_pfn_to_page".

... and I was wondering why that code deals with pages instead of folios.

E.g.,

	page = folio_page(folio, 0);
	mpfn[i] = migrate_pfn_from_page(page);

Should just be

	mpfn[i] = folio_to_migration_pfn(folio);

Right?

-- 
Cheers,

David

