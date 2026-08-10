Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C5A4C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 08:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352986B008C; Mon, 10 Aug 2026 04:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329486B0092; Mon, 10 Aug 2026 04:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2183F6B0093; Mon, 10 Aug 2026 04:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE9956B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:08:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96172A04D8
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:08:02 +0000 (UTC)
X-FDA: 85084631604.17.7401449
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D49F1A0006
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:08:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jtk/UaeU";
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786349280;
	b=OSjigwBVL/jQ7i5m6lmVecBWqFmWU/cP/VWSfgLqkN2yk1NuLPiuy1+8JDD6dKdWrasloD
	x0JcYhEaLBb4r5QFekvBzVvZ8g4ZDJfe8EepoKaV+MOQ6NUAXL9ua8iJZ67tApHNGPmwL8
	dFxGfVXRSqAy0KNZDevtqXwiVHK9eX4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jtk/UaeU";
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786349280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFhGsVAUsNp9P12Sw9NmmlITztpvk1ZNsJoMsuJuh6s=;
	b=Yzp9eSUZMk2Wj/TaI4FCCcZasTY4OdVjxCUrIOvOWMlJpCe4oeSDQK1A0HI9QNV+j3Rehr
	QJVIcAld0/selSWEG/+6Bui+MfK2OFmcjBOABj0T9TwEPqxtX5Ql4MSdUxcKJRvzWk+zbL
	DIiLYwoLNwZU+6JhYzMTcBalEsIwWsc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63AC060052;
	Mon, 10 Aug 2026 08:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7921F000E9;
	Mon, 10 Aug 2026 08:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786349280;
	bh=nFhGsVAUsNp9P12Sw9NmmlITztpvk1ZNsJoMsuJuh6s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jtk/UaeUSktXAID9PZ7kQSq4FoJyluNekVHL7zUaCAnej7UqdoKGd0qRbOxQuOdMU
	 LDHZvvb5IQ6CeMkrAIDqo1E61MPAveZYT/E0T11m0988lbcpWc9jl2BoR3pEZr3OfW
	 VvMvqEnxYDu7bqN4Mk4zjSsf2ftH2tt0yv9Ws15YLnduraT9Ps2hNHmJaaYZp2SlqS
	 QJP7GD9fj9RLV3FE0GdyQNpiIw2Llr9Ci0rAEa072aIwfmw02174dpDDOsJlqHofua
	 eBP3Ao+EJ4mdNPCgHNNJjsB/YaDtaxKTXSTQR6OYmmqm0hDlKBI35/O3bgC5vzYkFz
	 +G0MwMj4735pw==
Message-ID: <7be3503a-2ed7-40ea-9ba3-68a4f2f3b348@kernel.org>
Date: Mon, 10 Aug 2026 10:07:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/41] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
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
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-3-35f9aec2aed2@google.com>
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
In-Reply-To: <20260728-gmem-inplace-conversion-v9-3-35f9aec2aed2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D49F1A0006
X-Stat-Signature: xeyes7id3axg3bkgqmhoagxpgxatzgsy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786349280-169703
X-HE-Meta: U2FsdGVkX18TXRP2FYB9pWT5biOZ1OavOE5cJtOdFDKQ/+hDP5WMeTNXuuPHGhscH553Eg8UBdlj/s/X9XfOj28It7cm14pPE0VMsvs6Bj7rKB8x50qUKQmSNC/qOvHUS1z83piTmNYvtwLjbsldbi3GSKGdILwRFJqx9QI/X51QFKV4XE+Mbh76hgXnr50vs3r7ZErwbu+K9wcjaWshgziQ5aIoJzOovPKTutzCupoxAMN0lZ/k6BEqkb4ChtkCf33c4xMxw+QCj3Z6wq1FuJ6dLF0bLRIkgcHBABIw1XgXCXprrf4MmpNyVLFzcwzBx0Doiy87OZnsmac7/WvFzzLD0SgPNlgpE/K7Vcufy1Yq84UTyZnW1JZuvuTEWiioChErujXlWxMldG2GkFqf1DC3YtRH4Ax2pqd4cWsbIkFSDjBUHXdRbc9e8mGvOW4jPELqoSGJFhrwLfaAmEwI+HdSf+wjLv+GvYDnHb1X/dL2tigX80vyXQNGUVMPtKfWRcKKpHn9mPF5qcrOaZvwASc4H8jgRVv7wLu2mLoWcKIsNqZkv4TaHIJpAbh4VOGM6sxuqEu8gGgG/4FY+c2TBVPy95/76ShpySDR2SucTiBQ4PS5ZIkvYIViXUBycELcq60fJx758HmHl+N1diiZ7w2EQJacA0B9alutNo7tzTzPGieFBRF5LnW3816m9vDCIVwi53sR641vzXIqptgPAvQavFNBmg7YZJijGyWU71mpHKJ7xqeuNaTtSHR0H2Qk52jQ1weQKZ3SAEUkaGo7TNa8A5yDaoME2K5aUhdvZPnZ+A0S6J+C+9IO2qhY92NE/DRRI1mXm7a01CnBtl/Tp0+3BkqtZXwXJH0RustMYJBdoAgiEgDE15KQ2P64mcE9NIGDi1XZrKHL/MThUidzI7eyrDwQpOLVP+XR0O0cAYMw4MNQP0quy8HsPSSRhASpHfujhAWrO9S1a1G/oHZ
 y9ligMyS
 MZ6xo/F7egZN05k8GIUzC2AKM4VPnomKYSsqLxU2i33k7ReXh0amqktFbnFAmoXNVNYrhAHqxCqJ2BOEA2LO+eyPA0ABGEVvkYXoduj+hbXRHGZYabClmPSVnBbLmqha/GXHs9mUr2CLGgaGD6cc6q0IokGmKz8M+MGudvESzuNU/5UGdZoJ3lVGpAAlStv3zOxR5voe5epB+eX9hSkfbr8CfU0tFT1f3K91n43y0dxByZyQXrgrPBU2qA7VBwksQC6s72uKrinH3oCQOCrRAxJ4r1xWOOZS/XgP4VOtz86ff31vvr1XW9X+WY6F45378kp4OguBf/1ftQGbz5mm7v5jSfUfG34zFSFdCxDdqBfjJFDYfsrO5MKjXEOItRsjjczqERcqcnIyZUbMRSBmS9mCWNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 02:35, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
> on kvm_arch_has_private_mem being #defined in anticipation of decoupling
> kvm_supported_mem_attributes() from CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> guest_memfd support for memory attributes will be unconditional to avoid
> yet more macros (all architectures that support guest_memfd are expected to
> use per-gmem attributes at some point), at which point enumerating support
> KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory attributes being
> supported _somewhere_ would result in KVM over-reporting support on arm64.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

