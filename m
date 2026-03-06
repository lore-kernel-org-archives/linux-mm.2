Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A75F7F01832
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 14:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80316B0089; Fri,  6 Mar 2026 09:17:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2D716B008A; Fri,  6 Mar 2026 09:17:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA586B0093; Fri,  6 Mar 2026 09:17:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A977A6B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:17:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 482D61B8155
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:17:41 +0000 (UTC)
X-FDA: 84515841522.22.C624D22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5CFCD80007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:17:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QyTmHOD4;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772806659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z84vza6vMP8hgfMAqZoUuoVfw6cre78S827cqnEnz+o=;
	b=dYQVecT4+xhxVre26OUW9wVzMSag1wQoZ6qWhvkJ1MNxxS+TV9X95kjczWf/b2s4Ust8b2
	8ZcWWaqiGLWMgJJGMyf524iWH8ekqUObMP/gHV6vFCosF2hpWEbaQYP6qbaaK84+q6fhyU
	REWj5Et06TSCKsF/SL/KZZb6JbqyJpY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QyTmHOD4;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772806659; a=rsa-sha256;
	cv=none;
	b=1uFJ8flEYwy8jRN72RwXtsDnTlvCKRCUYfRwwKu3KKtfoTbO+Kr9PD12yRExmNOIldbVqv
	fg01324kTBEiLm8WLjv1gYY9l28LeZHBoeE3wXFkbXXXe8A47YFUdJSnENP5amfVVTFMoV
	FGxd6eIRyoPO8WSQtnkAbaPM3e4PAm0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1752D41AEC;
	Fri,  6 Mar 2026 14:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC83C4CEF7;
	Fri,  6 Mar 2026 14:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772806657;
	bh=kDJQMMVjroxoqrKJpgts6ufp43e8NaCEQtf/5Qs5cB4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QyTmHOD4CzeDxFBjYfTfC6aL3PiHmprBUm5aDWYj20TxoXCHTJX8pGTIdNei8th5h
	 tvRNSvoY2RpvRn1wE761+UsErbXxvMe0nwGgq4nu2Kwo3msE2iwC9NYuM+gMRydmfa
	 Dy+ac+sBOxKQLGyi72NUoxWG2kAcat6b+aUTOB2pEBeuOstaacg4nHN8PPdxbAft+G
	 eTaUxKsXNioJoJdnZRtzOookjps1JooJOaepfmNUXz08uHBqWqzXFLdzJXzhWRatcv
	 VSEPqivLxU9hODu3+CF/kdtVEHRcgG2my++WMm71t7osmCoBM2JKJjTCv+UoMspcG0
	 zy9nbkCf2BrCg==
Message-ID: <40bd6f9b-d5c0-4844-81bc-d221cd9b058f@kernel.org>
Date: Fri, 6 Mar 2026 15:17:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 02/15] set_memory: add folio_{zap, restore}_direct_map
 helpers
To: kalyazin@amazon.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
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
 "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
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
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
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
 "shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com"
 <riel@surriel.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "jgross@suse.com" <jgross@suse.com>,
 "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>,
 "prsampat@amd.com" <prsampat@amd.com>,
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
 "Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
 <xmarcalx@amazon.co.uk>
References: <20260126164445.11867-1-kalyazin@amazon.com>
 <20260126164445.11867-3-kalyazin@amazon.com>
 <af2d4dcd-60a8-4a5a-b508-d9600b1f2275@kernel.org>
 <e2834fd9-e4ec-473c-90cd-6c3a5049747f@amazon.com>
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
In-Reply-To: <e2834fd9-e4ec-473c-90cd-6c3a5049747f@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ptfzbee55corqhprjggwyq6bewnfx7m
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CFCD80007
X-HE-Tag: 1772806659-552377
X-HE-Meta: U2FsdGVkX19WDUaZQ1bfXuoZLfTG0TqEpjkJJRYB2nICS7uxqemMu02+IO1smOURFENSSTdw69LPEOBEgU6OoyvFlbDtjOfFy4VS6AXBs17lzyS9zSbIQPwYHzmhJXTolcoM+aVGizZn6GSRilBXWcWx8nn1kfea0LUixauj3DZi7VsuvllEoaSuofRTn694sHM2cvSKMNuNDPjI+9leCynLMoBzs0h0v06eReg3o9aRj4DdQFrhObQ5B9fc/tS1quTFbcxfcGUtdYG/jJXJnDnJnvn37Nbdb6+zW/okK3Arsdj5nsmQimBYs9Q2jlucq385I5NdRUgE+r4yZk5f/3NkhrnLb5cD4+K3Sw8S187PSJYOF7qD60q1iIa19juVcurO7/zyMCZ7munjYZUM2uUFz+EAVkOVhnhYfZNKGuNhCjQv7aDGlYawrgjaaVo44MBx/e/w82Mp1pq0pZsj7McQoN76tsxcjFaWNiT9N+pbcUIJs28BDWRsHcZaL/BQI971ic2XVx9US8EQuQZFDcR+tDedo4fbORsVX3j1YXrH3BHiVV3yPL9MRYCNP41SGDXOcFrCIXL1dO7xyxVnNtkpGjHWU1ieIJo7g7OrabcRA+poLBXaHg4r5l5XulvtLLmhfzdeGHtp+O5rlhmlhc8XIlwYwMUosXcz8/GaozROMtQWMuMAc7Mi49m7k+/tixzeOEwtYK78XCA6oHeBanZEmEyYDUVmLp4kvnKp9bO5CQzEGsmM8j51DK1n9Gbw8rzGeiMBk6CmJTMKaTVqprW/fSiD8ncmbJwxzvVdDxOzUMyc0urL9UfQMvVrh8hs3vXOqCHpOCpOJ+IVaeDDXz7hAsGhtzxtmeopyVVz5Ef9OvdR+y91GVQ/ga7Z+3XR23EnciQyxa2WcQs9AWI9ZZexMwhmRkPsEzwVAR9/ZiGS4XI0Ymy+IoYsZKuqAWrwBQPdP6vL5fIEI45Plnv
 ypenfGlq
 +Y3biu6PQzYWBIjiMmzns2TBJuUoZYA4kM4e9ZmQa6j05DJzwLoFf/8ZyZu1qCvrMn/wCof+LqKt+o3U4/iEIQKtjs76SHW6+oTWx5TZLc4UNeCa/TCwimdeL1nD5ZPjsFUr6jsLpczcqsWNblLtMM9zeiSYQ80D0IR+RriQgHLNXuyNr+4a/jpC9P3tO644zd2JA67WRQ0d5R+bDSOwH2RvTndsu8ZE2AXVLWC78a8hKVT17Itw8O77Q8El8XijMR9LMC8nOyIGgwtzW8Q6EfzNiEbtRvWFhTRvSmS2kkb0OARQjL7MtERJYqdUJ/e6AuvRNyEcWqUxoqODg47DRFeh4eC3G05o5msD8uJ0EvxlPbY4t5QLoetEgtr78vnfHhM2Vpfk06YZ0zaBOdYeFH6yqdvFX5aPyD9Gjx8vlxw5rFApiS8aMl3DONhhUpTiOJSXJQwExb5dEju7QwEf7DBgQDhDw4GHoMDgUmEFTkU7fTFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 13:48, Nikita Kalyazin wrote:
> 
> 
> On 05/03/2026 17:34, David Hildenbrand (Arm) wrote:
>> On 1/26/26 17:47, Kalyazin, Nikita wrote:
>>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>>
>>> These allow guest_memfd to remove its memory from the direct map.
>>> Only implement them for architectures that have direct map.
>>> In folio_zap_direct_map(), flush TLB on architectures where
>>> set_direct_map_valid_noflush() does not flush it internally.
>>
>> "Let's provide folio_{zap,restore}_direct_map helpers as preparation for
>> supporting removal of the direct map for guest_memfd folios. ...
> 
> Will update, thanks.
> 
>>
>>>
>>> The new helpers need to be accessible to KVM on architectures that
>>> support guest_memfd (x86 and arm64).  Since arm64 does not support
>>> building KVM as a module, only export them on x86.
>>>
>>> Direct map removal gives guest_memfd the same protection that
>>> memfd_secret does, such as hardening against Spectre-like attacks
>>> through in-kernel gadgets.
>>
>> Would it be possible to convert mm/secretmem.c as well?
>>
>> There, we use
>>
>>          set_direct_map_invalid_noflush(folio_page(folio, 0));
>>
>> and
>>
>>          set_direct_map_default_noflush(folio_page(folio, 0));
>>
>> Which is a bit different to below code. At least looking at the x86
>> variants, I wonder why we don't simply use
>> set_direct_map_valid_noflush().
>>
>>
>> If so, can you add a patch to do the conversion, pleeeeassse ? :)
> 
> Absolutely!
> 
>>
>>>
>>> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>>> ---
>>>   arch/arm64/include/asm/set_memory.h     |  2 ++
>>>   arch/arm64/mm/pageattr.c                | 12 ++++++++++++
>>>   arch/loongarch/include/asm/set_memory.h |  2 ++
>>>   arch/loongarch/mm/pageattr.c            | 12 ++++++++++++
>>>   arch/riscv/include/asm/set_memory.h     |  2 ++
>>>   arch/riscv/mm/pageattr.c                | 12 ++++++++++++
>>>   arch/s390/include/asm/set_memory.h      |  2 ++
>>>   arch/s390/mm/pageattr.c                 | 12 ++++++++++++
>>>   arch/x86/include/asm/set_memory.h       |  2 ++
>>>   arch/x86/mm/pat/set_memory.c            | 20 ++++++++++++++++++++
>>>   include/linux/set_memory.h              | 10 ++++++++++
>>>   11 files changed, 88 insertions(+)
>>>
>>> diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/
>>> include/asm/set_memory.h
>>> index c71a2a6812c4..49fd54f3c265 100644
>>> --- a/arch/arm64/include/asm/set_memory.h
>>> +++ b/arch/arm64/include/asm/set_memory.h
>>> @@ -15,6 +15,8 @@ int set_direct_map_invalid_noflush(const void *addr);
>>>   int set_direct_map_default_noflush(const void *addr);
>>>   int set_direct_map_valid_noflush(const void *addr, unsigned long
>>> numpages,
>>>                                 bool valid);
>>> +int folio_zap_direct_map(struct folio *folio);
>>> +int folio_restore_direct_map(struct folio *folio);
>>>   bool kernel_page_present(struct page *page);
>>>
>>>   int set_memory_encrypted(unsigned long addr, int numpages);
>>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>>> index e2bdc3c1f992..0b88b0344499 100644
>>> --- a/arch/arm64/mm/pageattr.c
>>> +++ b/arch/arm64/mm/pageattr.c
>>> @@ -356,6 +356,18 @@ int set_direct_map_valid_noflush(const void
>>> *addr, unsigned long numpages,
>>>        return set_memory_valid((unsigned long)addr, numpages, valid);
>>>   }
>>>
>>> +int folio_zap_direct_map(struct folio *folio)
>>> +{
>>> +     return set_direct_map_valid_noflush(folio_address(folio),
>>> +                                         folio_nr_pages(folio), false);
>>> +}
>>> +
>>> +int folio_restore_direct_map(struct folio *folio)
>>> +{
>>> +     return set_direct_map_valid_noflush(folio_address(folio),
>>> +                                         folio_nr_pages(folio), true);
>>> +}
>>
>> Is there a good reason why we cannot have two generic inline functions
>> that simply call set_direct_map_valid_noflush() ?
>>
>> Is it because of some flushing behavior? (which we could figure out)
> 
> Yes, on x86 we need an explicit flush.  Other architectures deal with it
> internally.  

So, we call a _noflush function and it performs a ... flush. What.

Take a look at secretmem_fault(), where we do an unconditional
flush_tlb_kernel_range().

Do we end up double-flushing in that case?

> Do you propose a bespoke implementation for x86 and a
> "generic" one for others?

We have to find a way to have a single set of functions for all archs
that support directmap removal.

One option might be to have some indication from the architecture that
no flush_tlb_kernel_range() is required.

Could be a config option or some simple helper function.

-- 
Cheers,

David

