Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C593F513EF
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 14:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC046B0005; Fri,  6 Mar 2026 09:22:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A97E6B0089; Fri,  6 Mar 2026 09:22:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536C96B008A; Fri,  6 Mar 2026 09:22:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 428E16B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:22:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D73DE59690
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:22:51 +0000 (UTC)
X-FDA: 84515854542.02.4B862BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 042EE140006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:22:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mXwWjpOK;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772806970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBC7T8ZTnanJW7cdSWsqP/mKcIvf13O8uAHj/nZeGbA=;
	b=DuKSYakZ1HnZNnNfgIVKjvt6IDGenGn9zAv85mkTgJq6otFiLDBtVdbj+bPNQq0QyS8lAR
	kM6PVywkpXQA5lqwsv+bmpEEeCoNpBG8WQ6q4U7w57MRXfqyhqu3AcW0c4lq3V1oJLI+T3
	kqhIXfz/5ZEauHIHo6bryOkYPIGQLGQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mXwWjpOK;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772806970; a=rsa-sha256;
	cv=none;
	b=HbHBxhCtimmATtGnv3+N2k/q/aCVQhM1oXWM7O/Pt9Oi1hPVAgIxKPBdKbtxBFa8JR1Vdi
	rQEpqJA6hiYybBhjtng5tglcjBlpnzxTKUO+9rZ1GbBfyGIkX2WZz5eq0EZuCf/URKoKS1
	xZEZQ5oBHTZHFhnXTKqhgon1DAKOM8c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 08EE24186A;
	Fri,  6 Mar 2026 14:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E36C2BC9E;
	Fri,  6 Mar 2026 14:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772806968;
	bh=gMNTcQY37ZjSxnVI6IjjmDNxOsyITh3kbGv8+l9VVe0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mXwWjpOKxSAKz1T2nD/QvcSF/IG7b06S+UBwPPRdQJACSatNJTMLGg5HzkdFLHGSX
	 DY1n5D1hIaia3+msWWDcPO3u1EpX5i0VmhzF4/w1jeQ9+TISmBhx+YRDVIF7xF3fSi
	 m/lY8JUvsy49ZASPceDZVQZgFdptQMg/ivlGyj4hyvRLZJnw5iwvAqea4xBrVUgYwN
	 SHnl5nOBdYteL668eMquMzfsSRzPPoDETBYuTmPr9SHSwD33ssw47rA3ZAaMpTK4YG
	 ZeK+kr0Ji8srwKL8IVKdM+FFFytCVbWpBOR1beq/KRuFI/mF4rCVvAqouJDnyITPfp
	 h6L7Pkhd32IDA==
Message-ID: <0c0b911c-cda2-44a4-897e-361e02be7da5@kernel.org>
Date: Fri, 6 Mar 2026 15:22:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 09/15] KVM: guest_memfd: Add flag to remove from
 direct map
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
 <20260126164445.11867-10-kalyazin@amazon.com>
 <13ed00e1-f0db-4326-a800-2ba306833921@kernel.org>
 <690c22f9-b71a-4f14-9857-008c7c858373@amazon.com>
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
In-Reply-To: <690c22f9-b71a-4f14-9857-008c7c858373@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 042EE140006
X-Rspamd-Server: rspam07
X-Stat-Signature: ooz7zaqkcrjq6rbi3j11j6pr51nokdfa
X-Rspam-User: 
X-HE-Tag: 1772806969-228453
X-HE-Meta: U2FsdGVkX18kwgQ03d1UdCJT1R3mcmEdJJaDWyV0xwiWvEKpNK/RcGWd/Qa9J8Hy7V0KMl/g6o5XX8llJ0Oo5w+r+83EXPLNWnZYdSDlgFnwX0f7I282aSiBXipO3BnAZfIPmF7e0bLZMn4wd/xTJWkwc5odPAY9qPx5kJSMI0UZ3Rla1fzVDI9OTHV0YTlgRqua+oEPrekQ0G5ZdUotSGhARbs4eBykPMl+oUpgNL7sNDBKlykEyNIs9KwGyfOzJcRTWfJA0/vlCEyWV7p4q5LOHZX+W5BIDP4de/fq3nD5eOHlmzTV1syovugiQBQu5LlfiBEJsKMbWB2DzJGHFJiEPk527J1ENVah7sKU9a8beLFFB3jczmvUuS/zWgoLBHZF99xUy/YZ8dAVoPzeB5SPZ0h2QAQF0a+AN6GuX5cd88JMMNZqt3kuO7aZsXJeAYuTwg0aYqetEZcfNGVBV7pMEDYteH26vxxLDY4axx7s2PuT5P0iWYasAbE+7YM1PLH7Ov84tBOldcwAWT9jmbkCEkBEI2k0w4GHEwJpAsTEd2cV29nKwBkbok24G10q4oFziDMkhtGf0xwZ41gx5jPOx4CekLR3wei4qQC/MuPWj/9bNlVuMSp46Lp/VrCQJx414ITXOktFj1OKo65LVy9u9RssXHJWJ7SmTZDdjPgE+uTH31O3b//NbsfpsmRbAYqPGBF+yjUl2DvLV6qMf1cqefdYLw3rAkohdDTHLIXbrc4qTh7jUPNrdoofk0nEQ77WjJ7iAlrWc5zWm+I1crjKpjt82khSPywk3VufVJ1nmXKRvVJba9DzXNuR6IsKk53EAZTu4Y6HAcZfpcAT9/lHE1J6PrQ6aR9yky8tbUmQlb0QJAlt08YpSS7b9LVwjwsxY5qo5KcShRxCwdFNfQyS4kWz7wW+1kj6eL7jNIWoNc+qvVguj8irTd5I8w4h9DweOyXBgAgvSlGe/+d
 J97dvJfW
 PROV/dC6EvfLMb7jagTS6ZjtQG31VrBpuz0YEzjqT9qnSBJOW10ebhaTn8+2oolyFk2yRBYdUbqV8Xdud+ylFTMhhFErCNqa40sHFbGvMY0axHUjXIA/aZnWaKFgZ/Z60gn5KtEaphE4O9g+qxlHa70v9ywiS6eIARWTkh+C/W3G1r02nrLReJn4JFhLdJJCzZMjjSTfVkdIlgHZzzbcF21iREFxFE8TRFYuHXky34CtTc84yu5V96gOlfLHkXyf6MBr6mqhP8BSpifwIwiIMBTlG9hH06OzF6aeJT/CdWe8rBD5Xe3xvVuxDNceDmfa/zh9huGC5ceXse7EgAqat18TFMgIBgyQ8SvqBz1CDeRtPDe6MPZKr0ZM4nUzV3/QL9Rxs8T9NIjs9GrFajoJuXOJc82oVCuv2+27w8CIdhn7v6+kMNt+h4L4m26YstaJW35V/BNGVmiRlJEMzXYDUkwsLOQpOZeRKexgdNjY1zMtM57U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

>>> +     /*
>>> +      * Direct map restoration cannot fail, as the only error condition
>>> +      * for direct map manipulation is failure to allocate page tables
>>> +      * when splitting huge pages, but this split would have already
>>> +      * happened in folio_zap_direct_map() in
>>> kvm_gmem_folio_zap_direct_map().
>>> +      * Note that the splitting occurs always because guest_memfd
>>> +      * currently supports only base pages.
>>> +      * Thus folio_restore_direct_map() here only updates prot bits.
>>> +      */
>>> +     WARN_ON_ONCE(folio_restore_direct_map(folio));
>>
>> Which raised the question: why should this function then even return an
>> error?
> 
> Dave pointed earlier that the failures were possible [1].  Do you think
> we can document it better?

I'm fine with checking that somewhere (to catch any future problems).

Why not do the WARN_ON_ONCE() in folio_restore_direct_map()?

Then, carefully document (in the new kerneldoc for
folio_restore_direct_map() etc) that folio_restore_direct_map() is only
allowed after a prior successful folio_zap_direct_map(), and add a
helpful comment above the WARN_ON_ONCE() in folio_restore_direct_map()
that we don't expect errors etc.

[...]

>>> -     if (!is_prepared)
>>> +     if (!is_prepared) {
>>>                r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>>> +             if (r)
>>> +                     goto out_unlock;
>>> +     }
>>> +
>>> +     if (kvm_gmem_no_direct_map(folio_inode(folio))) {
>>> +             r = kvm_gmem_folio_zap_direct_map(folio);
>>> +             if (r)
>>> +                     goto out_unlock;
>>> +     }
>>
>>
>> It's a bit nasty that we have two different places where we have to call
>> this. Smells error prone.
> 
> We will actually have 2 more: for the write() syscall and UFFDIO_COPY,
> and 0 once we have [2]
> 
> [2] https://lore.kernel.org/linux-mm/20260225-page_alloc-unmapped-v1-0-
> e8808a03cd66@google.com/
> 
>>
>> I was wondering why kvm_gmem_get_folio() cannot handle that?
> 
> Most of the call sites follow the pattern alloc -> write -> zap so
> they'll need direct map for some time after the allocation.
> 

Okay. Nasty. :)

-- 
Cheers,

David

