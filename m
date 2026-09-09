Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D2A5C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85B0A6B009E; Wed,  9 Sep 2026 12:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81BB26B00AA; Wed,  9 Sep 2026 12:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732AC6B00AB; Wed,  9 Sep 2026 12:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7C56B009E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:04:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC9ACA43D9
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:04:22 +0000 (UTC)
X-FDA: 85194695964.27.C08D355
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id F10B814000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:04:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N5Byjyq7;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969861;
	b=xuIQTsPswSTMduwZez2xWqvb6OG4Gbn4bxBZL51eat3eqKyUFOJRbXFAMhFCSknKVpCRHF
	ffR2G9JBLND+kop0dMlXGgUs7cARfCS5QY7rmIKcxUvtmhfxcOO7kQ9mtkCPJj9EqVjA6l
	7M3fSOJsG2wSeXl+Xx2fsenU+DeSRWY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N5Byjyq7;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dk4sipXK68/lmwCc15T8zbjLDSh1adJ4SNP0vi3NXZ4=;
	b=mjvE1WhTUd7SahgZLz1PwIzSWuZCB4+30ItKKi9SsxavFFy2l21MoM0MCM55+BaRmy9nFh
	QE4NvU5umojYrxJzfEF++2Y/4mLn116pI051jcnJ8UxzAlUOWMjXqRJR8d0UAJ+rnbkIso
	SXr7BJXMsxoGq/qszoaOZs7W/moQYXE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38F8A601F0;
	Wed,  9 Sep 2026 16:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA101F00A3D;
	Wed,  9 Sep 2026 16:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788969859;
	bh=Dk4sipXK68/lmwCc15T8zbjLDSh1adJ4SNP0vi3NXZ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=N5Byjyq7obOB27n73VYuETuGMgxQqZ+4uhJtACmOFqhcEPaUoNKD2aXjdV+ITaH+G
	 UnPbxBOmzkYV55oRKDkAQbky+J+Vpfri7xM6m3QbpgNkWbe5uTJcxn15Nv/D6cNIvS
	 tl/lEN++DrWlUG8ihLFwAdERRhpxECLPBAjwSuL/8bmKXMJ6MgTEJlK6EvNYlYI88T
	 T48dYf95LW8RuQrgH/FByYkSqQVNdGlgkKg5PKSuoYijMxSTnFrRK5RB6zrjjEGw1Z
	 YGU5DL38OYmPx6qPPWdZzz84LGm+oNBNJtnNRAKKkTzfx+1XAdUdVWFeVpgtUxIicK
	 JK65Sc+BlJsQw==
Message-ID: <307df445-8b53-4de9-8e69-3c586a44be9f@kernel.org>
Date: Wed, 9 Sep 2026 18:03:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 11/45] KVM: guest_memfd: Invalidate both SHARED and
 PRIVATE mappings for in-place conversions
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
 <20260830-gmem-inplace-conversion-v12-11-85e5fd25252a@google.com>
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
In-Reply-To: <20260830-gmem-inplace-conversion-v12-11-85e5fd25252a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F10B814000A
X-Stat-Signature: c6cecinxwd6m3sm3es51s17x6ditqebb
X-HE-Tag: 1788969860-317729
X-HE-Meta: U2FsdGVkX19R5y9JsevpCo7AZU3VDChHoV52SsvKQV6MY2pWvSUEyln4lFwBToixSLoYeDmRYXFHLwisKzwBYN3R5o8TOQc0/TuvV/weIXCVDDQyyPvkMnIJC/4EsxZ1vhMjgS3rEJKQs5xpkRyIhxFrwtM24sZAcXNFsKoRP820KrqZjMcWHZQI/3TRqb7l2DbCbZScx95Op+QyPJsRyWxoWRm+uRrlMKvq+E3k7OGrkzJwiF/lSZ+tP2m/lwa1RUb3ZNrsfRN3EgfE3iyo3EsGfaQxOVk0gstjrhnY5IJMrLeeFHYOFXv8etZ3uqnTJLgFZha07laH8M0T+dZF9dPPd56fXjnLQ6aAGMWXW2MSzK50hGCb0m/+Lk520WqGOOS99r9JobXYPF7h4CiuGCBNdkGUO/445assAqQ0J3AtOj2GPR/0iUku9dRRDCC9rIIxlIyYxsML1Jjq2u7MYagT+/si1mrLtacCimv+FRQUMPqt8k9MaS5YnOsebF5s1FkTwjqPoar0Z8djFpflPTxnJl/0AtsLxVSzx7uz8LjspjM92HwohXSJ0UNow0YMR/JNujJn3UxkzXkRFF9OMrL71JwfaPGyWqDQx1AA83r96btGfzKACSofMr0L99/xDFXIkS7we39gXNOi/b48CJkTkXFIzMvS7guEMGWCj8UFhjhbLkcxajocy4L3jlj+dR1lchLvf118xGCOz4mXKXMgtOVGZyewpR1OjHkUZruvei4UxGkP2VOcqTycnWcfkn2yci/DFIDERTprbtxP0hwJsi7tP/auSVFwO1aCswTl8Iq4Ger8maqBEsWbk5vVZGDmYzaIyvRHYtNT6MjOhCwEUcZkHcUgiAyI4t7YIuPXlQVtoGGF5NqUSl5FkZe/YYyTY5XV+nFDiJU9fdCO5p+Hr0MmHF221xM1ym8agGVjEiUTdt/u5W2VcaLH2+iWSviOnoSqga5S/HMVcZW
 1g6tlkYf
 B8neu8mixIbTWi/ADTtOGWnesFNmD8qaDt3Ma2nRRBfrYRllI8kSpIaOdls4H/0prVmtQYJKUz/MsUZXbW654cBjD7PTqt1RmYGgzqWfb8KI6RPMGNAe0tyZvD/iX16s5OW/9o5DgD8+vvAE/JrLfUBsyXw5vE9/1pejGh7/LfkZhffiZsgL+fpazUzfnNEQ6JrRyBKKrsTSAEUvLtVv0xfGEWAByO65y4iG5XdE6tTtWffr9ZT3soRWRt4kZMi/NJX1bqacXOZr/WorGnmlHetxOIkV0FjBKK0cCHj5BE7nlKvVUGafJhS6nil6NNiFzhqcOo9ka8EWaOONkI9Lgy7LQEgolkUCn2xXC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 02:25, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> When removing one or more folios from a guest_memfd instance, invalidate
> both SHARED and PRIVATE mappings if in-place conversion is enabled, because
> stating the obvious, KVM needs to ensure that all mappings to the folio(s)
> are dropped.
> 
> Opportunistically rename the helper to capture that it returns a filter for
> all gfns in anticipation of zapping only the previous mapping types on
> conversion.  I.e. when doing in-place conversion to PRIVATE, only SHARED
> mappings need to be zapped (ignoring that KVM would ideally not invalidate
> ranges whose attributes aren't changing in the first place).
> 
> Note, precisely zapping only the possible mapping types when in-place
> conversion is disabled is important for functional correctness, not just
> for performance.  Specifically, if KVM zaps both when SHARED vs. PRIVATE is
> tracked per-VM, then a PUNCH_HOLE operation on a PRIVATE guest_memfd will
> incorrectly zap SHARED mappings that have nothing to do with that gmem
> instance (because they're mapped via a VMA, not a gmem fd).
> 
> The incorrect over-zapping of SHARED memory that doesn't belong to the gmem
> fd requesting the zapping will be resolved in a later patch, where, if
> in-place conversion is enabled, KVM will use both shared and private memory
> from the guest_memfd. If both shared and private memory are from the
> guest_memfd, invalidation will only zap memory belonging to the given gmem
> instance.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

