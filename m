Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E746606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fVYEbyez
Received: by kanga.kvack.org (Postfix)
	id A08466B05B5; Fri,  6 Nov 2026 07:29:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B88D6B05B9; Fri,  6 Nov 2026 07:29:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CF806B05BA; Fri,  6 Nov 2026 07:29:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 645CF6B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:29:45 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DEB1C160D59
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:29:44 +0000 (UTC)
X-FDA: 85404625488.07.552CC8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 210091C0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:29:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVYEbyez;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793968183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/qJOYK6EsQ+0HnufRvzr3oyqfusTYvNMauUgRpuc5o=;
	b=BpoVub766zKznZc5STJyw4nEBvHj/Wbd2XzHgLIsdn8bfCw4gVWdpbQkXOOJmujuRIneb6
	OkbO218tHxD1zWOlYOe3vD00PwpfF6+KeiJ/t0X40tRvT8lG/Y97z6q7ND7WhoxXErM1Rl
	wMImWUdaNBNebl4tODIBhph1pZGUgYg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793968183;
	b=xW3mpJpN4aGyA7o5Ejev6ecqrxISsBaIT6u8cCmXxTYr3N/QIyVa8XNAuN/Rm9ipVUuNy6
	jxKy+9buV/kL31cL8X44scr55L9tnbw3LbenJyxEISn5bfCV62e0ibN/qDyvLwTobIMf8V
	lem2iSUxtsN4Ibjc9a9Ml+6TNkPrHA8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVYEbyez;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41B0940942;
	Fri,  6 Nov 2026 12:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF33F1F008A4;
	Fri,  6 Nov 2026 12:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793968182;
	bh=E/qJOYK6EsQ+0HnufRvzr3oyqfusTYvNMauUgRpuc5o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fVYEbyez7MLSFPPF0DqlzMCAspA/1SI3Pq88KEJDaICPyStfMIc+0Yf+tn/E5zntt
	 YLGitZkVB6uUnNDR8g2MzKIINKY6SkvyeT1DAHf16xQiTD09h1/0QzQ+dHGbN1fUwl
	 cBqRLzB34EAXRg38U0mPk39V4X7MqhrTxPH/nXnvtaG699XGwsQ9OdpLzF72xJlpuy
	 ZhTn/5nr9I3YiayzJePVQEHpHqgoJqgwKMO2h1Z3tKn63PEyVaGQgrvoO8N3SFPOps
	 g/BTLuERbEtVrdjpRm+4fwHCWHY9gn4Iu/lZavoSZfmElLbFi7Jvxjwm+njeZuR+cX
	 l+hXTS0nO34lQ==
Message-ID: <254c6f0a-9353-4806-a5ab-a071cd59c64f@kernel.org>
Date: Fri, 6 Nov 2026 13:29:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: don't map folios that are not uptodate in
 MADV_COLLAPSE
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
References: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
 <au3C8lNElGg4LnR1@thinkstation>
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
In-Reply-To: <au3C8lNElGg4LnR1@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4s5ri3sb13c7gj59c6r4rfon5b1p4bck
X-Rspamd-Queue-Id: 210091C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793968182-475021
X-HE-Meta: U2FsdGVkX18M0Fa7+kmJNdH7u1P6Z+InPWQ9keNEBaSdmeHdg5D5oq756yVfKL1yDS8mfr/On3AGkJMdzFf73JPKwp78XmT+qG1ToE241a2Yj6rQ7Ge5nN1ZdIKi/IAc4/ECMo2lIIEghDOEJcTlh2/ZOEcFT0faIzOJaiQrzAVRNiAT3/rvgxymLoQWqDo+QmA4YvmVNRwgifjFNTOXHvhLgMXSCfNVX+Mdz9jg3VLFYEwVnG3xsT0FYe2ygoh1/d2YQ4PlSaWdUcbKtnE+LvAV6ljqfpABKahzUCb5wYcDAB9/8EBe8u2oIabbGBe5trhz9/yvB3qP9ed4Y/5YV97yk/0OX5/O34osRKtpvq3kcxAZ1gYvK3Dhh8zTQp1mcxY3FP2CDwzx1u9YhXFChAsyFV+RGR+HRBDY9jz7aHA5BbkUyhAMzcbyWzMuyBoSxNXTW0gOdVkJC9A1XTVOnGJsSvbQvEzLKdw3L8c1eFIezhkNbRxaDGDPYmLRJ5N7G209H7dt0PftDgJG0vpho8gAOFgGJW8uQFEbxYG1sTBmkP7DQIcPtoSZOqP3imFHexNcpIEhu+PoiLzpvw0vNxKeihxa97RxpUDTOTgmpp5L+A606Xp8XjPbhFNi3pkWMS+n6ld2J6bCwglvAN9ZKDq1teAZpzHmIdx8b1CBjJ+M5RzEvPgtC/1+jec2b0gsnti9v2+v+URPUXyEVe5aS43xbKo92hyoq9AcVbudyOOeP3HLJENT7525ayZbACmdQQa7fqhR0p1foMR3Mqhk+70v/5wT0wquP/zFxZlGrOJKzruYJgIHwE19ZZZZL/AiKPG7zCIs0vsfU6YnE5DAG9+b6yYqB1BGTQz/dMQoyR5vPNKqq/jfNJ3eikVqc1Yn/LzM/53qGoXcmOTeJ9F3h5sYSfZ/3d5WJodEhGRzPplHLUZThDnDjYYXmCMPFtDstfZfAhTzl6NLkHzwvpK
 co95O0MV
 BjTPD4GoNFeGBuopxtd7EfKdIofbDYl74B1+vkmrkOgkL5PQbQEG77iYrQbiyv1vkV1ZpIh9tzjjx5HweIn4p9sPTht0+I3tdqOgRG3/ScNT7o3fXg7ybxQ8SgPzfVAMG78tr9n4EtvE4iHOEykybBcLetQfNPUb4iXb7MrK0wnRpglDUh4tIU1QU5WrtXgBosHVQnlSOUFyGMJZJey8kpW/rIGYAPFYb6PG7NltCbQXNTparXtjl380Ad2hCwt2XPFWnZs+BZYR/smOgAawqJbauXi40oVclP9OFGBAAAsOhXMMS3/+oq0lap6/FeiVbiA9OawAh+Y1ABug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 13:09, Kiryl Shutsemau wrote:
> On Thu, Nov 05, 2026 at 07:16:44PM +0100, David Hildenbrand (Arm) wrote:
>> madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
>> uptodate. For example, shmem fallocate() can put such folios into the
>> page cache.
>>
>> collapse_file() already refuses to proceed with folios that are not
>> uptodate. Let's just do the same in try_collapse_pte_mapped_thp() and skip
>> such folios, leaving handling to the page faults.
>>
>> Note that collapse_file() effectively clears shmem folios through
>> shmem_get_folio(); let's keep this fix simple and simply let the page
>> fault path deal with that.
>>
>> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
>> Reported-by: Chris Mason <mason@kernel.org>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> 
> Separately from this fix: nothing on the mapping side catches this.
> Every caller checks uptodate on its own (next_uptodate_folio(),
> filemap_fault(), shmem_get_folio()), and khugepaged was the one that
> went straight from filemap_lock_folio() to do_set_pmd().
> 
> Should do_set_pmd() and set_pte_range() assert it? Something like
> 
>         VM_WARN_ON_ONCE_FOLIO(folio->mapping && !folio_test_anon(folio) &&
>                               !folio_test_uptodate(folio), folio);

I think so. But looking at these hard-to-trigger but in the end very nasty
problems, should we actually reject the operation and do a pr_warn_once() or
something?

-- 
Cheers,

David

