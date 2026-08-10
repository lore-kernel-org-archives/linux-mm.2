Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C248C5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 08:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E694C6B007B; Mon, 10 Aug 2026 04:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E18FD6B0096; Mon, 10 Aug 2026 04:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2F1D6B0098; Mon, 10 Aug 2026 04:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CFC06B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:43:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31931C06AE
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:43:44 +0000 (UTC)
X-FDA: 85084721568.03.8142C85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5D6AC40003
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:43:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FImHoxXg;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786351422;
	b=YRrNHlojMRZCIkCN9uLxFHGWVb9sSJaSHaMjQjRN5RlvggYX29R1UzU7u3jDvdEidK3/nI
	Ne3lVEU6WqHoKKqd8xH+hGIgW5yQj6PwkmsbWSiwj3VIk4Z6TQIiOiUPCI/CqTBgRaJnW8
	OiQTmzzvXlvXLYFugUPUvLNCxGgaMiM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FImHoxXg;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786351422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smOt6mZG+PevRoowKw0zUZxXoHsvJYbHF/KUnR1DfrA=;
	b=aaaGg4Nb3U1eRyTwwihWk9aB64OHeSRlUt3+KW16E/tp7nPNL5RkuP89S4bjs7xPjQ7nvY
	GU1HO1S8+/t6uvwFb6JZxdq5veqSQDBErYGVLnW/9mqKAWY6mdkI2S8Ir5tNlviUTwlaJr
	BYueG5tOaVGa+qoaK6zPSFS/Y61DBu0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81C6F41427;
	Mon, 10 Aug 2026 08:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE561F000E9;
	Mon, 10 Aug 2026 08:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786351421;
	bh=smOt6mZG+PevRoowKw0zUZxXoHsvJYbHF/KUnR1DfrA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FImHoxXgIxwzbVyPu7nfHaTw3qR2eukHNsnftNgcvcDDrlqlqcA4HteQC0p9YmIbC
	 IYa0UrJmyfRXHxGd+ID4Zr168Qs7C/7IeoKv1E8TcvW5irCGeMMzd9AnedtK/sPrrd
	 PUpDnXWclVQccNpIUwMrDVvLXtpWakjkH34kIGE32ljzuvrax91OIsyWQJoM5cySLl
	 8Pg0xMWTSW+nDib6pwUdPqbIOkqLRxasEsrzI1V/P6lBj8+hlRpRpd4tGzb5Tm6hwg
	 pq+3j65ZLwYWz83rp9pEC9AROYEdQoTJwKJvxQSf2LBKrDEkNS6aI79YDjibbettmQ
	 g5FdPN5a0AwHg==
Message-ID: <7b93b756-1c48-407c-a12d-864f0a5bea01@kernel.org>
Date: Mon, 10 Aug 2026 10:43:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/41] guest_memfd: In-place conversion support
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>,
 Fuad Tabba <fuad.tabba@linux.dev>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5D6AC40003
X-Stat-Signature: z3y95a7q7p7wbbwmkk3m3h696a9cf4mk
X-Rspam-User: 
X-HE-Tag: 1786351422-618241
X-HE-Meta: U2FsdGVkX18tLOdX9liSxdMqBRyeMhI2KC+dGxdDgaD7bW0VKWEbWce5yDBTfeYCm2qtz+SSwa3QVSqYwOQ5gTqBE3yd6iDonGOheILUWh8OOKlhHlY61BeLlCLVaKC55pitipL+CjSOxPOucYPBxNjb5iV2hhg9KwVioNJTSFgoRrtYBrC0hQZhiAFVUsOzN2pIR7kgwD3z6wx4ggjWYAgCZdZ9Hyao7QoK1RyjK5yEaTeI4TtKcxk9RJksVoon20nijVfbHQe4xepsHCjJhRjw5tJR5kpVHOYuSsWNQvhGvjFKfsnRLWqlyWKtRR2E4dg4YGTWvLOcyf6yV11j2npkS3jHj2TInpaKddwVLdAMzUNxklKWgrefmL3yOnylt/aEe66wjxpwupDU/lRVW3bBybMe5WUGUELivjjs3+5pEoelwVTaIe4tBHub4U5isqM98Dk/Kidx+3ECw/hrMF32oaRyLixh/4Az9V7F4UXdbvICiMbqrYlxL0OTaC7KfgTktGI8ltyk192/b5TLzLrZRPwAnY+br2ad+T5xzXrG19jiTDwQzaLRBi3UvqnxZNf9Myoz/V0l4+l/85qCERNkpBa6zdbgh0Wac8ERBWS1/8wuaw9gmiIHPpH22GWbd7WF5qFE7UXJX9eaiSrELfiXBDHHu1K1wBPKZG03lKNwYJGgA7WXJbbms7R0nrJ068QpdxECdSjqAgTfK+vAITG3K1hcxfCnWCrJuNP95klaZmLsSVg3Qa29Tidr4IYaz8fd/ewpQOk/Y/dwjwy2r2Q9oeeGVhFXoJlJfWLv9SuequvNEFAODJ6qLCPW7dOuvDtVNKtMn6hYoBa41uFhPgs7L4fj1Bn8CW+F/D/G3sWsLtD08qmM0N+r14MmK57AOIF8Vb1bLVjcWFGgC6JTxnJuaMFls6Yrb+xP0MLc7wSXSwkWpRVwdFcz+g2skAQEhOM3UtcSt8CeEufgTG2
 c5q/GGez
 HzkusXmL/rR5HsJMMiDF24KHo/FHnAqWL/PnrJ5VKoX22O0L2inG2qGjHwkQwQS8IYylRfRgargHM9CnBNcwyNhbzP/G8msQ8U1aEfDzEh4uB3ofr8NIs1E/V9Zio2u9QSKJSnaNry+s+QLCdxpTKNAWbZh/t/dep1R0o+ZkctfBdrRrFzDEVomTkA/64B4275Qix3eFMP17GQDRRWOYsOUvch5sjdh1IaqV7WuCRtrlCqzQg4ut+cTeLVYrJxXNyTyrWseut6Ef/g4j8oxSMD7eGh3s1mBZkGE6f619EVjJfuGIZFwlGdsGAtB6mocImHtxhdqfjerfmsNmRqRC0l/pSWn1p6Gr+dp/PgTKDdZXxdBN/LHsGOzYSNFWC7Zy9ge6j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Previous versions of this feature, part of other series, are available at:
> 
> + https://lore.kernel.org/all/bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com/
> + https://lore.kernel.org/all/20250117163001.2326672-6-tabba@google.com/
> + https://lore.kernel.org/all/b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com/

Sorry, I saw v10 too late and left some tags+comments on v9.

-- 
Cheers,

David

