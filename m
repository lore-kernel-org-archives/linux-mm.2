Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A84BB606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jldaq/Z5
Received: by kanga.kvack.org (Postfix)
	id BF3986B05BB; Tue, 17 Nov 2026 16:26:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4636B05C3; Tue, 17 Nov 2026 16:26:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA036B05C5; Tue, 17 Nov 2026 16:26:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E90F6B05BB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:26:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CBAB140580
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:26:29 +0000 (UTC)
X-FDA: 85445894898.14.7EDB817
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 685F040005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:26:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Jldaq/Z5";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794950787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kd0LLiG6swluPh5oeg1alEcYx94n/CBaZA4CpIHZHI=;
	b=NnbEczCsvWHnXcD+sfHO9Mb2ztBk6JP+koiuNJq2cPgkZCfcRXjwYpJ2oYHP7hsXqvztgA
	Y4wANUYmUZ2hWYN8oTZ1ZeXDHWMi47xS2N72nhNAv28n2aHeFN5v3j9MaEmBma0A7GbP7s
	5oSQFT3uBLlS/xneSVGzbAUaFt6LtvY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Jldaq/Z5";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794950787;
	b=4yI2JP5i3+d6FFfy3jxRzbd1JLvYyNPwsSvqDmWsO7dZDlHlQKbms4VUdlvurz0L77YNt6
	/IcAoNpdak/c4pvo/qT+UCdJqNboqb+4DoIofGQ+ttFactF4ZVzSClqef+HGgAk4vc+fEP
	4jxNxbNg+I2PU1lpqV1jlfsGqu3xcuY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75E8B44D8F;
	Tue, 17 Nov 2026 21:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1651F000C4;
	Tue, 17 Nov 2026 21:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794950786;
	bh=2kd0LLiG6swluPh5oeg1alEcYx94n/CBaZA4CpIHZHI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Jldaq/Z5m9V9ybYeXBep3YabaYxDK+3gWf3iK4QZMiDvqEnHdaqqvbRduWVYkq0eR
	 klJP/4lgkJP2exk52D8dK7G/y8/SnSFJuoTG4ArYUg5/RrSUZH2o4tvx+h/GdqxmcV
	 QSWFJ8NQToG0M3OEfJhKP+Y0Z6WC6YxDwTporIDL6dYgqfOdbmELQffNaj2KeyKKyi
	 n09p9p9r7qeFMf/c8hbjiXWxGQ/KLZzf3rNqfi38HvlZAToaVvgYSQaJ+cgRNxiR1O
	 RjzYAEGYTyQ9nnrk+oDS5IJYIEB73dpgEbFdAOAzq47crihheAeUy0PUCCNp5xgsc0
	 hohVP+DtIzM1w==
Message-ID: <ababeb0f-f8c6-488c-ad97-f13245139eb6@kernel.org>
Date: Tue, 17 Nov 2026 22:26:14 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: update walk_to_pmd() to explicitly return an
 error
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
 <20261117-huge-pfnmap-fault-races-v2-1-276007e73bcb@kernel.org>
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
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-1-276007e73bcb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 685F040005
X-Stat-Signature: 51sgwero1ftqb75sor5mdmiobs9djafp
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794950787-499227
X-HE-Meta: U2FsdGVkX186joK0IJzFu2kXQKvDQSUqQV/JteQ558J8PDsJaNSyHY/uofGV33t+YNWGre8lFWijMesoXJOVJfDSF/xODaU/Ec6PT2KgB49OXiO3alv7V9YdjJf5Ic/w/8jQBy3AOjC0TeWJCpW4qoOwaco+SnLmohB3JNHS7vpjMVNQnqeaF1VBpcM4oMigg92dPTacJ86aHuCYgiVKLarhuYWNrPSsLCwE5mIm2mAcZ2F9iAFwUxiaXM40qfZtq2jfy5dU+kcLkLLDAC+PxZjVFvgzjvt3n+0S25HHly5nW5QDoxap2TC815mXVgI2DEIZ9YDLD3rjYg2uqjrubHwwOY9XY7Ij5hzBzRtNRi6K1M7Z0ytJOPPxq71mviSNe1jbuYt6ObvrJsbPOpxa/lnY9q7WZz3E8pSl4czYGkD6FFawxjsYqdmHBRHEci3RY5GCimEXanj3YmzO9j/uqLjCd/tJuoFh/jjclEfqSzqPcEBwkCGK0u2crtVHusNjk1/+DRcpbY6ZoMDBkSM19n64PITDe3oNxMp3FdpFWOQW+akf9FE3V4yJb8gedB6QvhXCvXpzUyd409WsdFpfwbm+3JWjOOHj8kJo9/TPikZLKPA2CeuPz8ra3zW7mktuO4cHA4NUemYGCWfFFwFDk8oTjqP4daAmbUX09aF6Fu5HYMAyVZJLJFScr8FOdArmPA8W61/l8/SJBY93HiY7/h+wz10UE0zBD1zFbz6pJDClCNwzXKSL5nnl08CZQEbm4atTOUMmqH4agNs0+bKdJU6WOxlm/JBcQZgskCBjttry7fHSeGYfc9gsw8yKiZnerruyz1gNYUUdfNEY0bVEqA7DPKLhhyAD1GI1fk8L54eLPCTWl3ykNeCbqC4y4i2lXIEa96HGyYBaZeENNBwM2603m9o+lNr+r/OY9Ly8oBmQnGsDw4yj5VuSPxDIsgYpex/lw8jR/9JjG6AlMtQ
 WIhv+IKf
 ME/eltZPAjMI0I7qvg0tKa6t6PKyn5jBE7vOLRw72SOWA4cCKul2Q/qnjSSVg9JIV0g2nOjKlFhvickIF3v+1N+dEYmxWW8rulyVNXs4BgYh5E/im0aCvTmNONGc0opJZHEc2+G1kgqye5l0vC5l5AMtKwXrPMz9+qxsJiqTgAmQCATmXP//j83WSd6nKqgirB478SAUczvGVfhwF15A04WE9xAenPR97EGkoVIaWyDeRtITWyc4xmko5EPiLiNp1iOKuPciRpc087pWMd67AQybimuXQQm9c3pTvHEMdL0+q66gB6ObuB+xV+y97sj5lxTRzCAO6wwNW/dc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 19:31, Lorenzo Stoakes (ARM) wrote:
> Rather than callers inferring an error from a NULL pmd return, explicitly
> return error codes.
> 
> This allows different error codes to be returned for different failure
> conditions.
> 
> No functional change intended.
> 
> This is a prerequisite for the fix to insert_pfn() which follows, as that
> needs to be able to tell a failure to allocate a page table apart from a
> race with a huge fault, so mark it for stable alongside that fix.
> 
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

