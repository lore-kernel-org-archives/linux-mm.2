Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE9BEF8FE4
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 17:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6AA6B00A3; Thu,  5 Mar 2026 12:23:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964A06B00A5; Thu,  5 Mar 2026 12:23:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1C36B00A6; Thu,  5 Mar 2026 12:23:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3516B00A3
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:23:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 080CC8992B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:23:55 +0000 (UTC)
X-FDA: 84512682030.10.D38EEC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 439B440013
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:23:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=liGHR+qS;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772731433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mgMQogjRLFjbQKfJMk1DM34RaE5HBdgOViHtvRBUxWk=;
	b=gE1w3ga2Nfo6zdXbjG4XyMBU932k2xyrX+tDfVvzNi77OTbHt5JQFSUyzWt4MFlH7cRukX
	ICTZD9tlf0r9K387DR/UiaOGoiGO4yAVRAHVIzP9NwHu1GyvIi32fNqJDic9Ie9psxujzU
	wPd190+phwjpQFHw4JwMN50zV8KIdX4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=liGHR+qS;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772731433; a=rsa-sha256;
	cv=none;
	b=UODe995q8qOifqTq5o66r/QtKiWQqFitDCaIwX/1EUjmxcauvX9dwfsmgrWj8c8Bsx6Rcy
	0GnaBUlN0rDNjrwT8Tl+RTAt7NL23e6JYXOsrnA9151UmgDMWUr8nfuQa94va4lrz4eU3W
	w6B5BisbC8jUzRzQ0POLW0PvBKZS5a0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 34FFA600AE;
	Thu,  5 Mar 2026 17:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666F9C116C6;
	Thu,  5 Mar 2026 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772731432;
	bh=nWVIE+EcOlng0HrFjPyZg3oytXG4qO8Zesx2+80/tV4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=liGHR+qS+rFsKhFEQN3jyTl6XqDh5yQD/UWppvFiK/lQIT5Qb6Q0aBhzH71MPQcAv
	 LrSPhZmx7K86W/kFvmue9PeQWAExuvDdObhyXSts6NPTlvWFjcgxKfygwmork60M+g
	 dBIy7Yy576mBRn2IuAN9ySZ2RQcePi/Ke5pUfyvnm/XAG++/Tq7VvtFZmshaVtEVc3
	 FR9aDcCnN/h4gaeAs+uGaX1Xu4WhdCdbdAqPgUIJq/uvJAOWN8AsM0hWbC57YGzYZi
	 sKOjUhNJrCLiR9L/LwRrMishVebJnDW2/j2UczveIPT34F40cZjxym7eUdJiU9GBfa
	 tD3oPKelTfPcg==
Message-ID: <90058ff2-9dea-4090-b2e6-da4c3cdba81b@kernel.org>
Date: Thu, 5 Mar 2026 18:23:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 01/15] set_memory: set_direct_map_* to take address
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
 <20260126164445.11867-2-kalyazin@amazon.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260126164445.11867-2-kalyazin@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 439B440013
X-Stat-Signature: ms3c1tr6jasx5hupkzqpcrxtf8r5x3d5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772731433-311299
X-HE-Meta: U2FsdGVkX19U6GzRQzfJ516sGBNsJTiqxODUtEtXk4JGEPbiGDa7irF++ocJRogXmKClljfo8tSeZ9vTsd3ncgjkmiYFlM2y4HKhD+RdZ+umGzrVlKCDyEKZ2XBKWsMRsircEvXX3D3NnNTzgW2MbT4u2wm/ECJ2BClpjwT/Mn3YFlqe3hFELb8F+RKHIizlyawQgvlglAE5RbiWixHoubKNrL1p56+LlOsL1UkToSnAYMY5fte3id+2GH5T3DdYq3aQHrLDUcBS9J7aje59UfRG3clXTLJlfvnbt9SGrbiZz6MapXep20BHRtbeE6dbefwjW31Gv98W4OThQ9/HAOWBDo+wH7TUIuIqmP0lmwRsAgbw8zp+lr1g5GVI92HxFU6XHQ4lN5UPDPJwo5EdCmuJzCyZSMXEYEPiqtgTSHBf9cXzrmZJIQHRRWZNb9ggvHEILxnqwMdsnl6H974hc5VV9bFYG5uaMQq6pWDplDMkQS+BiAVm5Qw6qtsRwuxUzchdeHcGz+QGdr7NfVDJbdYb/PABZAhsmZVjwyKbvomVNik6eJ2EJIqTLXU1TU4MtVPWJ2ShPrVwAST8G7soQFD0zTvXDztpWqw0tPFnEuOqIJh/CW0QVpNU2vE71lO3dBDE5QCRPRyb5O7IKRUj97TAgmNdgDBTReoBPKq4d2yQJSQ6LQvSMbqvemMeqoeF9+tv0zNOSoUo0iXea8uF+2jAVdPKy++/c7O8hpxp1207VTAzgL4IcXf5xKnOV/XK2DqfQe6po8Syc1p+fH4H6/Sn52xIn77sBAj9GZiScVxg/1vwDXrVoOFpYq3bTMDopqqopNtBZF9xf87spxuPt02pJM00VFsuUlzUh93XUqGuMuFTAwuUvAPgoS+9iGv1q7CGMInyyUjiyXm5EkuVnTKf4++GmpAkdX/B6pPalaGWkrJ0EJim/GibVGHm+p4VKbwrzQRfbSKv/Vfel1D
 /iuVsBqE
 0fhIbdiHEKTpNnKMTG7x6Rgu+aqKHmWnatkZnDn4/Zhp1yMFmNlZIPWkI9qPkdaEFCr0Wi8EbDaDNmdfo6zNdBEd6i4KvxLgMW0xYnJNnhISb4g3MuSGXGRskAB1as0JZjc473AYUrkaBUra4tmt/AmH2wFK+hfWtXkR4nNhfztEafMKYqGZXCGNKMP2GTCU4mioEmirkDMTVICfOBiIMDyWuML3d8qzpOas4d8tqrW+7NIaCmMWDgWPLMu3OWBu06YjtSC6ykmLP5N+Ub9rJt12KyaDM1JD3vaWsXzIKErZO2iEOcxuimHct1Jix+UjnFdZvueRDo9pKFtcIThXQT8VQquNTn1UPZq9t0HFpbRjcbvYr+Je2RSw0lhIaEjNr6URtsDV2qxpDV8/6z0RA+p5GIBDQGexX/2nnhT5KXkhRkA80fV7w3mGt0OYOZF+7KI8ydmFz94p2kogfqq/KtD21Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/26/26 17:46, Kalyazin, Nikita wrote:
> From: Nikita Kalyazin <kalyazin@amazon.com>
> 
> This is to avoid excessive conversions folio->page->address when adding
> helpers on top of set_direct_map_valid_noflush() in the next patch.
> 
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  arch/arm64/include/asm/set_memory.h     |  7 ++++---
>  arch/arm64/mm/pageattr.c                | 19 +++++++++----------
>  arch/loongarch/include/asm/set_memory.h |  7 ++++---
>  arch/loongarch/mm/pageattr.c            | 25 ++++++++++++-------------
>  arch/riscv/include/asm/set_memory.h     |  7 ++++---
>  arch/riscv/mm/pageattr.c                | 17 +++++++++--------
>  arch/s390/include/asm/set_memory.h      |  7 ++++---
>  arch/s390/mm/pageattr.c                 | 13 +++++++------
>  arch/x86/include/asm/set_memory.h       |  7 ++++---
>  arch/x86/mm/pat/set_memory.c            | 23 ++++++++++++-----------
>  include/linux/set_memory.h              |  9 +++++----
>  kernel/power/snapshot.c                 |  4 ++--
>  mm/execmem.c                            |  6 ++++--
>  mm/secretmem.c                          |  6 +++---
>  mm/vmalloc.c                            | 11 +++++++----
>  15 files changed, 90 insertions(+), 78 deletions(-)

[...]

> --- a/arch/loongarch/mm/pageattr.c
> +++ b/arch/loongarch/mm/pageattr.c
> @@ -198,32 +198,31 @@ bool kernel_page_present(struct page *page)
>  	return pte_present(ptep_get(pte));
>  }
>  
> -int set_direct_map_default_noflush(struct page *page)
> +int set_direct_map_default_noflush(const void *addr)
>  {
> -	unsigned long addr = (unsigned long)page_address(page);
> -
> -	if (addr < vm_map_base)
> +	if ((unsigned long)addr < vm_map_base)
>  		return 0;
>  
> -	return __set_memory(addr, 1, PAGE_KERNEL, __pgprot(0));
> +	return __set_memory((unsigned long)addr, 1, PAGE_KERNEL, __pgprot(0));
>  }
>  
> -int set_direct_map_invalid_noflush(struct page *page)
> +int set_direct_map_invalid_noflush(const void *addr)
>  {
> -	unsigned long addr = (unsigned long)page_address(page);
> +	unsigned long addr = (unsigned long)addr;

Are you sure you want a local variable with the exact same name

...

>  
> -	if (addr < vm_map_base)
> +	if ((unsigned long)addr < vm_map_base)
>  		return 0;
>  
> -	return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
> +	return __set_memory((unsigned long)addr, 1, __pgprot(0),
> +			    __pgprot(_PAGE_PRESENT | _PAGE_VALID));

And cast it to (unsigned long) even though not required two times? :)

I assume you wanted to get rid of the local varable.

>  }
>  
> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
> +int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
> +				 bool valid)



Nothing else jumped at me.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

It would be good to get some ACK from some arch people that are CCed :)

-- 
Cheers,

David

