Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2127F483D7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2ACE6B0092; Mon, 23 Mar 2026 13:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E024B6B009F; Mon, 23 Mar 2026 13:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF1476B00A0; Mon, 23 Mar 2026 13:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C27DB6B0092
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:55:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D2E01B9349
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:55:54 +0000 (UTC)
X-FDA: 84578081028.22.79FF3FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4BADD180004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:55:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EH+kk9F4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774288552; a=rsa-sha256;
	cv=none;
	b=RlcOby42hZB24HFzGDFg7ACTqPR10gOomduLP/iYwY5Q8p1EoiVu5i1VHxQ9sNSh8WOTfj
	9fQFBNeVQW2kevG82qJsVBwCLjsoehESLN3jDLxH1M/3oxvLkvXG/ptJVnBew0rkTQlHEm
	w44+xUFjzn7tn0kxwYt1F8G9uPwNQEg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EH+kk9F4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774288552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lb+wYNTGRP5L/MYubyvU3LwZJFXKlVuChiIa4Wk4FCI=;
	b=KL1E4QzfrP3CCV9HX63aAJ7kghT8efZorkgD1WNh3f2zsgh3PX9tfFBnephOa50nuMQQvf
	nwdFh9+KA/8DhJdQg+/sJs9piv9Z3aCaV7QM6YYsT9j1WjpocvQfGzZnEUdrGuDcv3q6oF
	nvuQgoLIGqF9jPsXLhLOvuW081qm/w4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 395E740870;
	Mon, 23 Mar 2026 17:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A54FC2BCB0;
	Mon, 23 Mar 2026 17:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774288551;
	bh=VbCHYIuEB3QD6Shd9lNFnvrZhPFSCzFNxS26OEzV4YQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EH+kk9F4cET+6hBw+hfgT1O7mgwe2YVYpi8ON4Hlqv3UBhAP+D7aSImBMsunnA01j
	 yXqborcZqNAgukb+/+AAioUQf9oJZXLqF5hly5DXoOzydpkwkZSqQ85B+tSp1xo7JT
	 HYDKHEL95p8nIWwf6mEuq0/D+KciFk1I8OcDuoXSk4lC7gqvvYxeHgML63sAromxSY
	 f2JqjC5lFuuzOgwPnO6R5Y8bHVGb/8KMbvUuq0JuIhtm6NDya0gZmeuFVD4dYBTF9y
	 NmC57B/yOKTlM/7Rkzld0yyndRA4qk40CIOpFo0H+rpWeYk3SULQMJmL6A9sQ+jZjm
	 bmQVJInFNb7FA==
Message-ID: <0a14c10d-0dab-4b9c-85ec-e0ee25cd0db8@kernel.org>
Date: Mon, 23 Mar 2026 18:55:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 05/16] mm/gup: drop local variable in
 gup_fast_folio_allowed
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "kernel@xen0n.name" <kernel@xen0n.name>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
 "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oupton@kernel.org" <oupton@kernel.org>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "tglx@kernel.org" <tglx@kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org"
 <song@kernel.org>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
 "riel@surriel.com" <riel@surriel.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "jgross@suse.com" <jgross@suse.com>,
 "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "yosry@kernel.org" <yosry@kernel.org>,
 "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>,
 "tabba@google.com" <tabba@google.com>, "prsampat@amd.com"
 <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
 "jmattson@google.com" <jmattson@google.com>,
 "jthoughton@google.com" <jthoughton@google.com>,
 "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
 "alex@ghiti.fr" <alex@ghiti.fr>,
 "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com"
 <gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org"
 <pjw@kernel.org>,
 "shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
 "svens@linux.ibm.com" <svens@linux.ibm.com>,
 "thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com"
 <wyihan@google.com>,
 "yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
 "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "urezki@gmail.com" <urezki@gmail.com>,
 "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
 "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
 "jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>,
 "lenb@kernel.org" <lenb@kernel.org>, "osalvador@suse.de"
 <osalvador@suse.de>, "pavel@kernel.org" <pavel@kernel.org>,
 "rafael@kernel.org" <rafael@kernel.org>,
 "vannapurve@google.com" <vannapurve@google.com>,
 "jackmanb@google.com" <jackmanb@google.com>,
 "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
 "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 "Manwaring, Derek" <derekmn@amazon.com>
References: <20260317141031.514-1-kalyazin@amazon.com>
 <20260317141031.514-6-kalyazin@amazon.com>
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
In-Reply-To: <20260317141031.514-6-kalyazin@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8yqzsej6wkihypr6nhwgi85xz4ri5888
X-Rspamd-Queue-Id: 4BADD180004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774288552-815504
X-HE-Meta: U2FsdGVkX18SooX47quK//zDrJzXmxR3ADa//5kO8jV+BUXxPSBw81CyxvZk3nF2uRb2lykbHNCNQZ06V4Kf87CUla242Vpmh2Fwp37T4RfCByOS4vvKFm8WK8IgIPhE0yzWSM4+hbojUHEmG/4wLoTv0aHM91Cgixh6Ludr/+bqgfvjwL4sV/8oLwBLCf+/+P2U4jYhyVsUYJVHLZoStu+JCfFjXqE4OL/UvKp4DD2nuwpiQ61bkAz5hsceJEqeM1gmg6U5RVdICpf9osn9Uor/89GRtBh/LSvuN8X46Uoh+b0VS+wsJjOsK4iMnFcmXn0ZDrgvhp5lcGeNiL+EvDU21BRcvF9Bi3keSV3wSla3vFenVqF1QGdY+62VDBorvYE5aVz4/+E0QnPpq5wUmt+spZtVaU8IZDphLdCBRb+3kWbQj1Bsg+eyd0j4w0YjZRCfpc4aB+BCkFAkEDMInT9b//Z1l5GOvw0q139iFg2Ls+MHsm4UCrUfUnSA+QJgRGaqP/0p0qo/JnLK55NDZrRG3n9zZoejpjbikI969P8SFDvHSt77GrO/Jk/KEcBX37BJ2F95QfKsDlpTxRDOtpnSN+66nrLXLXuqKm0gq2o8hBLZWJlFmY7ZK2qQ2cZdqSFDU+KGeV8zwMzpNEpbYNxuK3HzXLbv+KbeMjYdYcHeqrS6cbvpZ+5saHp5G20fpD0T17pr/xSF1dQMVtFFBcHQd1LmVsX06Gciy96beSW4FeqShRihrPjVVzlYwOCMsWnlLn3Qj6DTzSDOBsADc/Z80Bmpr68J5Sjh3z7vWEtDYf1v/K1B1/cvHyAXl0nI4XXljkl8gZjpV6CDoGXqruYx7VNGoxPh1BoWA80BjJEhbJgNni3WlnHdbBYGg4GGbbFkA7Ht4ItE8lDsssF8fOULnrRd129lOWj6hV9csU6VhgPf4M4tto7fehx8Nvyw10fbeML+bFCD6HkZDlq
 MJ6EBmOh
 nqzodX9/rohXl3lYhnx/lmKfcCXASYvVmcS6TtSCAqfXmnuOTkcZEbC3ycBwLDLitzp39JCaENreyNLXXrJMFXWRHZkTvCvS8FqjCE0cMSMAOeynVehZ59G8w8FopmFeZG3th69BiWogqeZXFHFwmYuYoYGuqQ/nSvLMXcp9jSKYS2uHw8ILTbQzGVQ5ZsS4SXDAEFLNjvoiugAio9wyqetALkmU2YxhJspo34BZdpSBXabRRtSQZREiy9fD/vdF5+TpGgQrdjiIEc4DPE0l94JRpKJAU3HVXRVk6G9fdfUs3yyhUsrNnNRG3GgSJapKkffQggRJ9Sj3T3H4bPl2jp7Tx4SnkPPj/snFbJuv1x2ltkqr4viRHZRrw7a70wRJTZ2cG+8zBKD5kzn7MwFPiyvr0N5Paq99GPmr+hC0Ys9TPebc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 15:11, Kalyazin, Nikita wrote:
> From: Nikita Kalyazin <kalyazin@amazon.com>
> 
> Move the check for pinning closer to where the result is used.
> No functional changes.
> 
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  mm/gup.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 5856d35be385..869d79c8daa4 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2737,18 +2737,9 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>   */
>  static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  {
> -	bool reject_file_backed = false;
>  	struct address_space *mapping;
>  	unsigned long mapping_flags;
>  
> -	/*
> -	 * If we aren't pinning then no problematic write can occur. A long term
> -	 * pin is the most egregious case so this is the one we disallow.
> -	 */
> -	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) ==
> -	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
> -		reject_file_backed = true;
> -
>  	/* We hold a folio reference, so we can safely access folio fields. */
>  	if (WARN_ON_ONCE(folio_test_slab(folio)))
>  		return false;
> @@ -2793,8 +2784,18 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  	 */
>  	if (secretmem_mapping(mapping))
>  		return false;
> -	/* The only remaining allowed file system is shmem. */
> -	return !reject_file_backed || shmem_mapping(mapping);
> +
> +	/*
> +	 * If we aren't pinning then no problematic write can occur. A writable
> +	 * long term pin is the most egregious case, so this is the one we
> +	 * allow only for ...
> +	 */
> +	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
> +	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
> +		return true;
> +
> +	/* ... hugetlb (which we allowed above already) and shared memory. */
> +	return shmem_mapping(mapping);

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

I'm wondering if it would be a good idea to check for a hugetlb mapping
here instead of having the folio_test_hugetlb() check above.

Something to ponder about :)

-- 
Cheers,

David

