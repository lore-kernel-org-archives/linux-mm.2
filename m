Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F1E606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dYy1lsbi
Received: by kanga.kvack.org (Postfix)
	id 2F6496B0782; Tue, 27 Oct 2026 10:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CDA36B0783; Tue, 27 Oct 2026 10:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4146B0784; Tue, 27 Oct 2026 10:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F17A26B0782
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:13:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81D68160A55
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:13:51 +0000 (UTC)
X-FDA: 85368599862.17.280F10B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8A2328000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:13:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dYy1lsbi;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793110429;
	b=Sq+IdyKgPgWHx2qFvhPqYSFT9a4OhmQDxHVJ3gkvnBzteWC2WSXg2Mka3wlH4mPlnZur7h
	vDzdOM3KP0ULc3nMbw2fVaJBRqAwBWB8osg5prhw2qp/NXUfatlJoYoCdCKoSn7HQohby1
	yK+CEeOqZjQxaM97Gncl8PpHPgzxM80=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dYy1lsbi;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793110429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Smq8QLRfkjBN1obmOVmOeJFl6fXBs9WJMR4nvP90F6g=;
	b=mvO5Y9nlb3potwsm0QhH9vqjl0IVANnTp5DxnadlxOLhxKmj2nvQdFLgAv8EIVwCeV+mk6
	5Npz5wNfZhFfnT1aDilsUipaUgisI8arQxEcEj5av0Zb+NC/rXAiNLaZpK06QSRnTwl4jK
	6VNy5puScAYDFcMFCk6i6G+rw7sKfv8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE6F443DFB;
	Tue, 27 Oct 2026 14:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E971F031E0;
	Tue, 27 Oct 2026 14:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793110428;
	bh=Smq8QLRfkjBN1obmOVmOeJFl6fXBs9WJMR4nvP90F6g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dYy1lsbiYvg7GAPH7+g3JyCzJUoe2oGUGJRFEtAsjImqhsHKdo4N6djWKbkA9JZMN
	 AH+B5K8qeFwE2L00i8BZxLpcpnlFpfuZoYV0TmIlmdPmpMYDslQ0c1o1r3h10zVEL6
	 bm66SNK7NPVadUBQFq/64vHdKxKSVdp2YfuffXMgAwcrV2o41qYy4G59dxWPwKgIEl
	 gHRWfvJht0JTe2qsHlhmi1sRp38Ec05zEFMYe7ZPDJYXVXsOxJqZEzNhIH8t7ac6ok
	 dmWXjLYdt2M7krxZNWgwn8I3ug5/B+8iLFi8AU89KioGpxPKV7gC5Nf9CXQbznFlZt
	 1mQj0C4Ytpv6A==
Message-ID: <6f5aaf2b-894c-4306-a0b2-e56f815d0a89@kernel.org>
Date: Tue, 27 Oct 2026 15:13:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] mm/page_alloc: don't undo another isolation in
 alloc_contig_range
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org,
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
 linmiaohe@huawei.com, nao.horiguchi@gmail.com, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, osalvador@suse.de,
 muchun.song@linux.dev, iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com,
 stable@vger.kernel.org
References: <20261027042204.3741307-1-gourry@gourry.net>
 <20261027042204.3741307-5-gourry@gourry.net>
 <a4fc92b5-7d99-49f4-94ac-89fdee699042@kernel.org>
 <179310997463.2232644.3260379218896917308.b4-reply@b4>
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
In-Reply-To: <179310997463.2232644.3260379218896917308.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A2328000E
X-Stat-Signature: cm1o8ogqfwe4axhpo1icyzbfkqmqfune
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793110429-18488
X-HE-Meta: U2FsdGVkX19gigmQPuKqqME98mP4sgHgrudmNuWPCz0Shzmd6U452YGyp8Dw18ppLoO+qwI3sXi1HfDjpt74qDqsfcTYCRq8rp9m6y6VDaeVaTkfTYmIyASVauqtM2UoPMZ66n+LrgSlsz3VV8ax9ohJwXyw7vXrEo9TdKKVxSoUwTi0YqLRAzdhFU0QZrTkYJqHFEdILTVrtvcsiedXun4S2VukjUjfrWn2E9euu0SoRTUhk8969TWOIYQrDdfZV6bohq+BCY8dPrRVKDI5np4tK3DgGRb6o18XNaglbZQ/YPmfqYNQBlEiX99j4uzIJevlU4Qki/ZPtvPQ4JX36F8nB1nHLRbgUNV2doOR78bq2qJXH9jDqOSCmuM1SLWCKDwuTQhywcUK0FmosuY+eZZU9RxTqHlTYWSJXemVUmeymFC3TgnriyWJID52sSCQYCfa/WasH37RhzbnOzyup93n5rksXLL1IGbemqYjzRq5w3uR7Mcks70c3GZNc9U/zgl4tTjUWNdZmRC2H7Gz1J0L3TJy/JBFDDZzgb7AXnEpq3WnTFayUWNHKoX7d+4d1tu5cIqrZsMANHysqDgp4hPWhK/QqnLlyDNn1fOU6DzMfsxBnOw7ce5VHMXMMNY+jYFe3QRxLRgVATRUaTaR9fHndlZ7MEPWVi+s6H18UqqWx1arS3BLIV9VVX1gmve1dyrS+RhpPNbr1+wgIXnWfeFqsN/zhniqeHuwUbBjowGgGOJqc2xF11VkCqhbzhSAsLPPYAZHLGVuUNcjTSZBUw0NFdNn+L7n94bWU1W0xez7XGNKmx2O9mnRFn/ltPjwrZAYnjekfr54ZUYlFSaNgSt3VA4XIRfrYXpJgncsNgYVw4Abz2JXxoUOdlI7i+tZ99uUVS9QoVXbseAtqOyczqbW1FoR98bl7lWj7+Jfkg1+Ls9M/5OK88yPaACIp3xWlhwKi7jHi1do+jWrqeg
 KzfKM9gC
 esuOTFmh9yuTpW1qnWnyUJ1TSxRkrDlYhHFImvoELgnPGOi11Y0oeo/GdmGhKr1v62vrw6aOXmpQlTTYzau1qI4cMmL43Uawtncikc1rD1SgiGUle9m/K/ScG36pf2n/23vgovBoFLQ3CWWtYr3hMy1SWCp452yDG2wA2/Y+1pru5Up5zsljcFPBuUzW62HdD5X8pyMGESIvuXJ91ho/XrBXdETlvtQu+BAKhJ2odDbD2riJU1rPcSScY8TxmOZbCJVPHkZX2GU9TJWJYjK5gh1Zfxq5MJ2s5ro2ZIWJ9UXFBfVcL8vtdzhwFApzQreKjfarcgBO4dAO4CzBaxMf/5c7+PKY88u8GTzHKgsbheBlIGoYj8wIEOWIvSJez0AxaHrng
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 15:06, Gregory Price (Meta) wrote:
> On 2026-10-27 14:37 +0100, David Hildenbrand (Arm) wrote:
>> On 10/27/26 05:22, Gregory Price (Meta) wrote:
>>
>> We have an existing AI fix for that as well already handled by Vlasta.
>>
>> I think we'll have to establish some model of "ask David first before posting"
>> because otherwise we just create duplicate work for everyone.
>>
> 
> Yeah, this is going to happen more.
> 
> I've been sitting in these patches for over a month while they soaked on
> hardware getting performance tests.  

I mean this fix here is really just independent and shouldn't wait that long :)

> 
> Maybe worth a private tree we can rebase on regularly for these kinds of
> un-vetted/posted fixes to see what's coming?

Maybe. But if it's just us core people we can just talk on IRC etc (like Zi did
two days ago when he was about to post something that I already had on my queue).

-- 
Cheers,

David

