Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40F11C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 18:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2435C6B0098; Tue, 25 Aug 2026 14:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4BE6B0099; Tue, 25 Aug 2026 14:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E36E6B009B; Tue, 25 Aug 2026 14:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF3406B0098
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:41:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B8F61201A1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:41:48 +0000 (UTC)
X-FDA: 85140660696.10.71DD01F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 01E9A1C0003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:41:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SACRvU2i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787683306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Um2k/rJZLaKctBC+KuTYnxljcdBue3L/awQhVOIlKBw=;
	b=nmbEzggT+IcSSJ5wQFk6FRnf9QKCNsiCVlud4/QP6D3F1/GVYnW68BZMg/CLy0/ypBtifx
	VTke+ziG9R4bfW4XooruKbcnot4fn2qDqQy+aEyEI2gzFAxt9QqcMoZGmKkVvIXmeAzvUU
	qQ6iKKGMcS0AJbipJy88IP7ePcOql0g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SACRvU2i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787683306;
	b=Z1w6ihCGEgMAOAW4cimsekqCKqo9Koy4QSmmdf1LHTUAsTzxgxrjb6NW7OZsD8IKKmKpKC
	y3mNrQCCKED5YROnc1708uqR7KhRfEQmxzdogmbvKnd2pTPOIrEv8LaBzysafxBNUlLnM/
	bI8RsxDnwYZGAgjxFgwmWBnCU7MsVSU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FA0C6011F;
	Tue, 25 Aug 2026 18:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52D91F000E9;
	Tue, 25 Aug 2026 18:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787683304;
	bh=Um2k/rJZLaKctBC+KuTYnxljcdBue3L/awQhVOIlKBw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SACRvU2iZwAeBWEhmET+qgKae5pZ6XvIaq422QioR6Y5Y7/qLM1i/sl+lqpd46Za0
	 7LokzhUdWJ+wmSHCibNb00he8OLKOavBOvhKkS1Dcr87ZLIsTmPV9FXn/M3t9voQmz
	 y6TygHZLaAb6eYRTj3f8EuULRCEKtH8qH3rDLekGQbwubzpxFngIwE03Xe+6s1ehDe
	 uO2QGfMkSayjyzi3/zLYg4dilOtu6inuuvPvW1jsj0hV1TPWRTDUTkOdxxnCJ4LIpW
	 W1X1NTr8lCcmDyn2CAKkGR5Qmip3fhDBVJGwBXCMu55WvSA95QbMrXIsw8VHikxMZO
	 1l4jnPdmbLFlA==
Message-ID: <2e22677c-82a3-4894-9b05-2748cd617047@kernel.org>
Date: Tue, 25 Aug 2026 20:41:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/15] guest_memfd: Use folio_has_hwpoisoned_page()
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jane Chu
 <jane.chu@oracle.com>, linux-mm@kvack.org,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Christian Brauner <christian@brauner.io>,
 Jiaqi Yan <jiaqiyan@google.com>, Sean Christopherson <seanjc@google.com>,
 Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-6-willy@infradead.org>
 <32873b50-c900-4fe5-9dc1-cb086bba77e7@kernel.org>
 <an2vhg4Uvdo52WPX@casper.infradead.org>
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
In-Reply-To: <an2vhg4Uvdo52WPX@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7mzp6rzfbodq8r677oau99syd6tgkut7
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 01E9A1C0003
X-Rspam-User: 
X-HE-Tag: 1787683305-848117
X-HE-Meta: U2FsdGVkX1+uLk1PO/IaZiA7osddvf9dZ/RNVKyiHeybEcTezbL1rT71wYPbuqauVxl8dWwaFZcoeedbRljs1xz+zexd2hLxXU0gS/pAWSAlJgqXezl9wKDfE3D6o79fHkP1WRKtpwEPX4qmCnf+g1sw3044Yq7ZPaM1MSY/PFgV3HaslBUJuGZbcMn9BvHUhIV+Za48dU3xDanPnanrEhOkUEmC/6rpFjf2JJxFFGD+8Kzja9efibyqP/aFJH5kj/uthocFk+LWGTTSDtFHDJgmkaAm/nn5gYIzwy7TbBOj+BU/O8/1oKBJU4bqbMsgjsr0+Zoj7aTcc1oYkNrqdQ85EsOalydkO8x7JLbrBnrz5ODeVPKqsrPbFTuZ/407qOUJw+q1qY8IuZv/0npAHSR5OdMWEl3Xm4YmGwFDyfsvDwxbcCJLwAHNAp7nTCKuJ2s2sa5mKyG5TIgcSUkNj18lVAQpGbU0RL2m5GWcnwKUUXBVkEvVlXNeYsQ8FdZOYKPVIFKAjY1cVUYdblAuFX2Q9AdGruFGiPq3F7DZJPMAOcEWp/vr7mrqwo5cOSIZBQKAbzekOAzjC+VeOcH1QrEw1iKf3TvgHRNcJ0b/LDcaww75Ai+D5CHDSgTMLuKUfZg9W/lZmzL4sH0VKrBdWwlJihfRC48KyjNMHrASQ65o5p8gX28/dXj0Ua6l1rADJ/sAnWJxbzFkjqoZpVgFFkZ9KUpRLj2T3S510JVpW4g8TBjA0J0anHQVrt/nB9GcLIZqxcn9XJBRdjrOlqxE5vA+6+JkuOhflIVy0+qEgrZ8iwqKOJoA4qRhEWqf/59zC4F9SwQgY7oVqnBksRtPQA1LRNEuUiNZmeJFEWD58dYMmvk2Z4LbswRp1D73PfLrVM85pW+Q8kgAnS4a+CKYTk66xjjvLDrnf90Dol8EwVS/XVzNWNloxHvflfZrfUvKiAapqYkEzx24ga7FD26
 Qw0JHz4P
 vYGC5x2KUVvEg70S30s5GjzaKNgvnStdDfg6OqTyYEASfs2DBf76LSTs5ZvgNf9jhqIH/OK+GwAtn9oZLa6j2CaeoaBbVnj7/D29OUAlE0olCGkQhmMVE+JZ73y9MqZHANVwv4HmguHFxxBCcIifRnmOueTFB8bfATSBdM0bsn1QrgQvqjVGyAjEwDK7le7muNGPbHrIaqh15nHlZxy8BaEv2Qkv4ApqTyvcOmv7Pr1VYMN9XbzDzJ0fA2W0nMkoHLMn46nKttY/uS8wxyzQTo+Avf+Fc6GzT2WB3q9e7BzxtNmDCi4bdW6ADE5Yq9jM0Rn354B5daLGA1Xy3usPbRAGqojj+IyPMaQQeEzE0onb0APiS9tusUWas5uT0P+gnNqmI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 13:50, Matthew Wilcox wrote:
> On Thu, Aug 13, 2026 at 09:20:54AM +0200, David Hildenbrand (Arm) wrote:
>> On 8/5/26 23:05, Matthew Wilcox (Oracle) wrote:
>>> folio_test_hwpoison() only works on hugetlb folios today and will give
>>> the wrong answer for other large folios.  folio_has_hwpoisoned_page()
>>> works on both.
>>
>> guest_memfd only uses small folios, so it doesn't really matter.
> 
> Well ...
> 
> virt/kvm/guest_memfd.c: /* TODO: Support huge pages. */

Yeah, that was wishful thinking :)

-- 
Cheers,

David

