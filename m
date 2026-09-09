Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F637C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2B56B0096; Wed,  9 Sep 2026 11:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A4E6B0098; Wed,  9 Sep 2026 11:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C529A6B0099; Wed,  9 Sep 2026 11:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE9A6B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:35:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9ECEA42E2
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:35:14 +0000 (UTC)
X-FDA: 85194622548.17.B1F7EC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id F10788000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:35:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ckd3bN3Z;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788968113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xj5P1Cjd9irB4BUOsfOHGIxVo3gJHi6q3o3BRLAUlrM=;
	b=LPUM6a+6TxcNFoixPm/i2/uFCppf/zvkkPm6npix73pMvwVs5znlxQkKT/3u0Wv1iyJuq1
	4dIJo1MlE2z5P71PW8xlOgBhI/VL0T2vByuJOaq3bbwQJL1f8GWssLc89Th4hZDxYXhK9D
	16sT946rCbTvR/dJhIQDj69R51FOlvs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ckd3bN3Z;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788968113;
	b=EABr3459ZHsDMyuqV1yS7p+BvLJ2QWZfJQZfKJuVg/h3W1bkvP4Aou959K2pkB4Ph2o3eE
	nNE+16GiTJ4tY9GEQh3Xz5MyH8xDPiLbj8ubD8dAxzHKcpmZJ3yht/qJf8Kbnm12vLNjtz
	TYKgrWoR4hV4Bpmf0O2NYD/oTmGT93o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BB4341954;
	Wed,  9 Sep 2026 15:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191301F00A3D;
	Wed,  9 Sep 2026 15:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788968111;
	bh=xj5P1Cjd9irB4BUOsfOHGIxVo3gJHi6q3o3BRLAUlrM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ckd3bN3ZBsVSMEnnFHviWt7dllTHTgykVYrIZMkd7W2vUKKUCgePCf65XS2sM98lX
	 Qre8UzhEfTBMyw5wJ5X+7M/4kE5evGsK7cd1QkWeCxNvzqPpxbWg4ehHniu+1/ykw0
	 asx5+MVfKRElxSINUvPSkNJDcreFgZEOBrSHVP0Kc6H2/aVk5HftReDcq4lNZUgjhV
	 lpLgubOZFtll6VhDJCF4y+SOJuXrn9nSKAxyFQ/jogDZ1vVjkiAhpxZgKYZjEpPZKg
	 K8EqCmZYf+jj2635P6MAVMgB9x/Gk/vRISsyVa4GSF4qweNESa7itJUAurLqwjkmdZ
	 tqivnhL9dbvhA==
Message-ID: <cb436d84-6787-4745-8f5d-5d0617ec0643@kernel.org>
Date: Wed, 9 Sep 2026 17:34:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 01/45] KVM: guest_memfd: Optimize away conversion
 overheads via dead-code elimination
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
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
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-1-85e5fd25252a@google.com>
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
In-Reply-To: <20260830-gmem-inplace-conversion-v12-1-85e5fd25252a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 4o38k645ht34sa4cktnsxbcuj5y7exek
X-Rspamd-Queue-Id: F10788000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1788968112-176829
X-HE-Meta: U2FsdGVkX18LGQhedksgTFazwldA3fA5XrLPOPgUYtV5OiJ4cUnKKr4Gcx5h39LaGjxxrX/apbaTx5jHJFbKB8zjD1u7zJsjKvhejKZqLHl+sFkxmNkPCAxV9C7wKFj7T3NAvoKJ9XYRN7RKrzPlgKK+01PCrOw+W1SSHknasbMuVCypnUUMPRTVhEVnOn0XTDp6X9+ny9k6KmV9cMvdL21UZeOYDzDKBDkHE8zUJoAr8vNVdA08mw0vCfxZj9f3BtctSwLbM/Z+h1cU5nODhmeAodnthebClGxpkLUKN/b3R1Ti3Ii7A2D11Vrfa4lAMjYSDV6lIPWjyOViO2e3sSA6STB8NxD1sG7LAfWgpxzo0zFup6CRxHPfVnQNHhGQFhzGTDzVBuPzPW74Iz6BKHlyhmnGAnfy+nP5dmPTfAwC6s/naT7nhTn9+sljUv4QoGokJzR+6vgbhl7sQTj0RoZdE7FqsMsWMACSKIuY5b+STbPFblMgck+wf/9INFimUycfvrAJnSouIkFkSP4wN5q7m/LX+ZFY1envkqQiyH62NIDlAImjC/cpYW7yFlAVIauwb5UY7eQAQ6KlbvHDwZd4bptTio0QilqDDNWWtp8l1gtbcdco2gbek3ZihbYmfSE1G+vf3yEK3+/Z6KWl6Df1pyiFj9W2qaCqBhESLG7XrXUmz0sp6M8HpfKEmGuq4iRINJK4W3wLyhdpGNUP+DzQLALtJ6ZwsGir+Zc6vpLbo3HxjrY6iBsZ3cW8ZaNW6qtukm6jmcHt34AfoJpdLD4GPZ5AXeCU5kjoBQds65NcTmVkr4/PKJkqL25oXRDkIvWm2NaPUROeaxiQntlPU+/NZjqbdKLLORWF/Xzo/tVJpba5pKpMO9WyHP21MdKYStLgFQiipJAwHce9/Ifl/8jBnDcMaIEE4x0WXCCvPdljnB/T6P58j3FBBf47VKQuSWsAH4Rgx0UdcK58CbY
 03kw9pTS
 KAj2GeArRC28N2waGR1Fk9vayfYfFXw/zpB04EtufBPFG2DIIavEv+6C3HGDq41C4keuz/0OD64PHyLsK2zsY9kBbQHV+D5f5iio3BDakf9V8l3V51yZJ0ZkhyyhpXbzCtMyoxA4Q4RvNRX+SkFNqg7deCNkddWx4BA7ZL3RgltAEeCwBbSKkBRg3lhfoq7Zr2RqIhctHTa9aTAE5HUen+5Laiy/kfYaWUQ05QOT+ccUkos3L9OoV4Cg6aoP5RC3ZM5AXDTZcmBDNYmENsPlmeKyIygtmxGIrdwZsz8+RIM/HFHEsqZFEQUdLYZoaGjuhZy5YnhnCFFV1KDtmRboqBOxwJw6UbXpMhH7/fO+ylJzxbghzTaenPUWbU6sOh6nod06X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 02:25, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Add and use kvm_arch_has_gmem_convert() to guard guest_memfd's invocation
> of arch hooks related to converting memory between private and shared, as
> only one half of the x86 CoCo duo needs the runtime hooks (any pre-work is
> pure overhead for TDX).  At this exact moment, the overhead is negligible,
> but that will change when in-place conversion comes along, at which point
> to-shared conversions will "need" to find all affected folios prior to
> calling into arch code.  In quotes because very technically that work could
> be pushed to arch code, but that would bleed guest_memfd details into arch
> code and would be far worse than adding yet another kvm_arch_has... hook.
> 
> Opportunistically provide the kvm_arch_gmem_make_private() declaration, and
> rely on dead-code elimination to eliminate the call to non-existent code
> when CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT=n.
> 
> Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
> Closes: https://lore.kernel.org/all/1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com
> Suggested-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

