Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA3FC5CFE7
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35F7F6B007B; Tue, 11 Aug 2026 08:11:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 310366B008A; Tue, 11 Aug 2026 08:11:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7936B008C; Tue, 11 Aug 2026 08:11:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E84E16B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:11:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7AF59C03C3
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:11:52 +0000 (UTC)
X-FDA: 85088874864.21.9FBBA6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A756114000B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:11:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oMzFJcn9;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786450310;
	b=RscVOK9sKRxKUD/3JvWPBlzJG9LqfyxV3uks71+hxrp+RPl6daw6VWQIwY1XYB+juhyaNl
	aUBTcy+uevYcTlKh8JM/0pQykhznHVYkNvOrEGSTvUwoX9dPSHtqKRRuY+t5S0nnX8IRAG
	jc2R6Hi232j364ULDnfC6Q5aDlOcr70=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oMzFJcn9;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786450310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fTG1Cghw/RG7+KE3x88oxH8TI74VawrjBf3qjRRniY=;
	b=R03Cah8mlTmCVZCMIS3I71lx38txWP2cvco/+D1e77R1/zb8BZTO4hTE5YssuqItlN14DC
	sWUglGoCnKcOhz4bbW2ZiYAOP95qxh4IEFT6cLS/rZZ5WSZ7YqguvriwvvBqGq552Oi/2E
	V6O3A7H3UTPU2VnvW2+1+Fl556dWsOw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD2A843649;
	Tue, 11 Aug 2026 12:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88261F000E9;
	Tue, 11 Aug 2026 12:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786450309;
	bh=/fTG1Cghw/RG7+KE3x88oxH8TI74VawrjBf3qjRRniY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oMzFJcn9VOzkFaKMEx9vCYCdx1Pq7igNm3SDyOEjzrOpDudIApIUK8tbQWGyhMTA2
	 t05Mkqhok9RLYIMUol0cpCiu3QthaSWyzaAoYQ2iTd1AckujJZDZf2+JmOHRJ0KvP7
	 mcsYLS8a7sO8YaLXbyWEeOK99DFlaVD5L55J3MTekojG6h3FMWYgpjeoMH//X24lZs
	 5lfWAxjxOdrK+/s8jDuKs0rLQeM8RFflAxNY1JPwZF3i/yhkf94kLkVqbTR4mmJWjo
	 hK2SQwlx7kI/9C/spjKPKM5IkvDG9SLQ6RAQ5o7kkbgcPTchuBQb5gh+4ZPvUgW8mp
	 IkyibBYe3lp/w==
Message-ID: <e9de4158-b829-471b-980c-1999959bbc48@kernel.org>
Date: Tue, 11 Aug 2026 14:11:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] mm: convert PTE table entry to pte
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, ryan.roberts@arm.com,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-7-usama.anjum@arm.com>
 <fab9fc78-1e1d-4d5b-a9ca-92f3ebd04108-agordeev@linux.ibm.com>
 <5c329236-7761-4e42-a549-b822e43b4358@arm.com>
 <2599c5b3-e8ac-4865-993b-d41e6f060d52-agordeev@linux.ibm.com>
 <f0b0dacb-fb83-4402-b0ea-30072727dfd7@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f0b0dacb-fb83-4402-b0ea-30072727dfd7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A756114000B
X-Stat-Signature: 6ui54jeag6w5c3uz8541cxd53hqrwjs9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786450310-913891
X-HE-Meta: U2FsdGVkX1/hdhE1LS50ejaOGypuFgNAdN58MpmIR9A82iwbQIw6f1Pz9DoTTLgLDNFCYDKYu6NxIup5FuLSbCbP3FCT+SzBFrvlQg7ks8aMZu2Z0gFUHLBrdZGsVwTqXv+ZN8QxwK5iFxVXsGf+zcqUoyPDHlfCvKJ2Mrs61UfiXOJmAX0S32aaqEH9HhfQGVA4nzipKprSaSiC7j0MEW0PtfVvo64lWrxTp3+JchcVF+mmamEN5J8AtnBRGm+oBv3qSektQ28vZC2/rnOQ7ck1bPKhHO7PB3nn56ipe24f7gzefAzvzit3XvoeJAkFqAv0NqAp4nihhesqVs4XqvshCC0CsCuVgjQs6jFxGUvxkld3qzu5h0+Clm6AHHh2/d13x3BaNMoRTOUWhMVLLwkcXIxU91mptWgzbBZYPaEHZ1NUKsYJTOzp+UvT/HMfrgZ7kyf/nISJqAcM/ylUIeaCWpGFtffP1YEL08PWuNI8rJJ2HEcinLxX1GpGBRZJQ8fBBCahdilVRN8Pe8qEXKVVJ+Cr/BTK4/zeO3UYdaB5oh2m/DYCjmWvXmcFPefIi3bQDgjeBA1Agwujm9vbOmf3Y/TfSZFleT3LI5tLSUOZeVmpL4z+OOouw/t3qsdUSDjZhEN9+y+HIyqhzpSUFcJd4gX2Np1hAr+UipRQ53xvVmTw5fszA7JG6RZzUGkNN0RLVJSsiCK7324ou0/XZZ+Xn7WwsoKB6s5AI+wsPI0MfzmGmIoDVWvYzhrW/MMW/NDKEBzu371/5pQAtJA3i4qirV1i3sVnIY7nR3t2o6V+ekeqV7B8+n2AsLFjIVKIq/KF19vLFOQM8X0ksX6ciu0ACMoEPbpuoMzojEY41kNc8FR+kU5hbFKi+e7M7yoauAfg8Os1U0Y8zujsngYuB+7el5m0kmEkanFJClj52IhAjg0MOonfybB64FUbT2QwvK1fm0mDwppDRFQO0C0
 xjFwHEBK
 Biuyz2L3oDN4QzR9MJXeHdY/fx+2DT+2MeaeCHZU1rvc/UBCKaFCkLicdOQFT+7xYRsFLhhPmURRpRh7DUYc+qWUoBPqUf+Vpt9mC76KouZ2sy3otbvZyGu2TWAMzUV3fFaFewpeGiDnRt4G3kULwhmPmzlhrQQRRxc38fSIl9XHb9IEFih+johFUD1f12/VnAa/wtFiro6AcG7wQnzdmUtxIT6w89X+zqA5rD+somsbYfXvn6a57Zg1B2+6k3U/Ot7Ps0l4vAlXgj/IHhhlCUwfB8DhmrdU0Gu9k52l6zsA5ZdWm1aacOPy2gysJftAEkIXr073WyKNA2MU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 13:06, Muhammad Usama Anjum wrote:
> On 10/08/2026 7:44 am, Alexander Gordeev wrote:
>> On Fri, Aug 07, 2026 at 05:26:04PM +0100, Muhammad Usama Anjum wrote:
>>> Yes, this is particular line is for non MMU. In this case, CONIFG_ARCH_HAS_HW_PTE
>>> would never be defined. Hence hw_pte_t is just pte_t and direct dereference is
>>> allowed. I'd thought a lot about it; is better to leave direct dereference here
>>> or use some helper. Then used __pte_from_hw() was already being used in generic
>>> ptep_get().
>>
>> But in case CONIFG_ARCH_HAS_HW_PTE=n __pte_from_hw() is still gets called.
>> That looks inconsistent to me. Why not just call ptep_deref() (see below)?
> 
> Agreed. Calling __pte_from_hw() directly exposes the representation
> conversion at the call site. I will introduce ptep_deref() and use it
> here.
> 
>>
>>> There are only two users of __pte_from_hw() at this time. 
>>>
>>> ptep_get_sw() or ptep_get_deref() is better name here?
>>
>> ptep_deref() would be it.
>>
>> Do you agree to the suggested API requirements?
> 
> Yes. hw_pte_t * identifies storage containing hardware-formatted PTEs,
> regardless of whether it is attached. ptep_get() is used for attached
> entries and may provide additional architecture-specific handling.
> ptep_deref() is used for unattached entries and performs only the raw
> storage-to-value conversion.
> 
> For review, this patch would become:
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index bc0b9c65aa1d0..ce900d2652d91 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -1283,7 +1283,7 @@ static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>  #ifdef CONFIG_MMU
>  	return ptep_get(ptep);
>  #else
> -	return *ptep;
> +	return ptep_deref(ptep);
>  #endif
>  }
>  
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 1768421755a9c..08613593f3320 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -490,6 +490,13 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  #endif
>  
> +#ifndef ptep_deref
> +static inline pte_t ptep_deref(hw_pte_t *ptep)
> +{
> +	return __pte_from_hw(*ptep);
> +}
> +#endif
> +
>  #ifndef ptep_get
>  static inline pte_t ptep_get(hw_pte_t *ptep)
>  {
> 

I mean, how many such users do we expect? 1? :)

Why have a helper for that then, that seems to encourage it's use, when really
people should be using ptep_get() ?

-- 
Cheers,

David

