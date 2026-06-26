Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD7DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964876B00B4; Fri, 26 Jun 2026 10:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93AF26B00B6; Fri, 26 Jun 2026 10:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A3E6B00B7; Fri, 26 Jun 2026 10:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0586B00B4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:58:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3AB2A04A3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:58:44 +0000 (UTC)
X-FDA: 84922370568.12.0CAC5CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2852D14000F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:58:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XGx0mk71;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782485923;
	b=a7YlTrZZrVFa9T+t/jpaAOtPxbks/hMcVPhGT6+dkQpYvmZtVlrBkLuhOTg/rAau19gOHZ
	24YK4uFuwYKeeKrDShl0KrP66ziZ79jPks7bZYmFKRrjoroS+zwoOB4XDDIK2Bw/KuHVAA
	H6xRVYUau5DTO6eF/HGEGbCA58Cdk4w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782485923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8cRwKyfFZJ0EQEF/mdND2222DVxVFFu/qyvWvBnTmHA=;
	b=yxunA6H2f9nJEW1MrQ4A9VQ+MGzVaHIJxKRLjX1kVwQgu7d6HujHoZi+Q6/sA6XBgk/5qu
	/OIqWLy8CMYzK6LN1Jd315sqrnPGlGVc3/HmrVXTCDwEIhr+8tVflwUid7WIEJonaWt40M
	ZtLhyl47LTNnipqUf3xMtp4llDlFwDg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XGx0mk71;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A166A600D8;
	Fri, 26 Jun 2026 14:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4C11F000E9;
	Fri, 26 Jun 2026 14:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782485922;
	bh=8cRwKyfFZJ0EQEF/mdND2222DVxVFFu/qyvWvBnTmHA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XGx0mk71MoGFUASSSl3buSS7F0314DQL/VMMD/k7pfr9trKWTQrllQ2sXVdh3aYOY
	 ANPzhJJsj5R2ZhQEM9A6l9eGujarHVCxjQnq8oP5RZvga5BcuuxDrJQKZOd1Mxr/56
	 P5FDaT6+OZ4qMSnP1GIsKRaNbewajq8aLlOXUWkrLAuiMYfd2OYbF24M+AtHrNVDrL
	 BN3hcEPLsHV4FLsQ3p8EnCV6n9+yoofM01oDHVmcU/LrS3CZ47xVKbERnEShMuKdVw
	 cTT2MFiDf71KrPOBRT3r1Lx8wIpztwbzWzVjAIre6N0ydk0o2ZN9DjwUB4IkHiFONw
	 NNDs2qsYd47zg==
Message-ID: <f7a40359-a210-4711-acba-677e9c1d565c@kernel.org>
Date: Fri, 26 Jun 2026 16:58:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 01/16] set_memory: set_direct_map_* to take address
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "kernel@xen0n.name" <kernel@xen0n.name>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
 <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oupton@kernel.org" <oupton@kernel.org>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "will@kernel.org" <will@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
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
 "kpsingh@kernel.org" <kpsingh@kernel.org>,
 "haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
 <jolsa@kernel.org>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "jannh@google.com" <jannh@google.com>, "pfalcato@suse.de"
 <pfalcato@suse.de>, "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
 "riel@surriel.com" <riel@surriel.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "jgross@suse.com" <jgross@suse.com>,
 "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "yosry@kernel.org" <yosry@kernel.org>,
 "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>,
 "prsampat@amd.com" <prsampat@amd.com>,
 "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
 "jthoughton@google.com" <jthoughton@google.com>,
 "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
 "alex@ghiti.fr" <alex@ghiti.fr>,
 "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
 "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com"
 <gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org"
 <pjw@kernel.org>,
 "shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
 "svens@linux.ibm.com" <svens@linux.ibm.com>,
 "thuth@redhat.com" <thuth@redhat.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "urezki@gmail.com" <urezki@gmail.com>,
 "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
 "pavel@kernel.org" <pavel@kernel.org>,
 "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
 "vannapurve@google.com" <vannapurve@google.com>,
 "jackmanb@google.com" <jackmanb@google.com>,
 "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 "Manwaring, Derek" <derekmn@amazon.com>
References: <20260410151746.61150-1-kalyazin@amazon.com>
 <20260410151746.61150-2-kalyazin@amazon.com> <aeeDvpDnGnY5n69n@lucifer>
 <DJJ23EXF55VK.1EGQZS511HFB6@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DJJ23EXF55VK.1EGQZS511HFB6@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2852D14000F
X-Rspam-User: 
X-Stat-Signature: a7nazfd7u8ddk3g3uc4ueoy8zs5hm73q
X-HE-Tag: 1782485922-473456
X-HE-Meta: U2FsdGVkX1/W2XkqakqQ5QKpsi8vlXchVwIGnJqVdHC4VmFkRvOskxRhro7ofY4R8W1dr17cF3ykPv0h9XVF2HcxTDerYZKzL9C8WzyawP1F730xGtg2rDUILSYWENyNRgfbPFKcHNID9g1/haDB22VQTDVQDKjKPR27G5p0SH4RJtFiMhJ0CKslUstO6A+N4Xuk2C4xiGu6geQwK8nKKLe2JABQbZrkEoz7QosecW/fxeisKYoDO9Noon3/UD/CQDoU5ad9bhkWnEdAltEg8Xy7h5Jbe5C1wcbYOeGayOAYAZ2JE9Awuas34Mexw5y+AmCARlLyicKVWZmY1hKew1t+asCkgChpCvE3NE2ffIy6jb24lAFFvimfd+sOunFqZ4O/n+vEesB3wvx0otgcv3vXIihYxnPNAihjzJ7PFgbcmd3JD6I8rzPKnkaDPy0IyDpToRZBR5dTKnQCAV6PrI/pYnLhAIH4NtW4/GX2dev26TvpYMynhu+IT5KgxWoJ+GK0CN9V/ieWtms1UOj8o8/F0ovqNgpKDUwuF/mPOx1NU3I4fx14Hiw4aWqr9GJaeLS8AFGXRdvO2N1I3gENzK3pWtys/K/+rc5sfWlDpftBeLAO1DzDYPHZh9nym7bxMxSkpaixTIWBe2jWzXDZ8MCw+psG5s3UfziPFv80mn0nJou2dZpSF74URdn1g8Sym5yFjk/POl0Yk2RDgb8VB/nT7Mt5uPTNcMIQl/mDbeYpPAv0oGnskE9t9uaq/451GXLaKRf27taM8szYnUOvZ9oMfMv7PcFaJI/p37FB7f3DFAEAc/4vV3aa3K3jgZdqGQPx0ELObxRf+miR934hgytDzq+0SXWc6yBsfbLAKa37O/SZv7iipsxbjhVgc0amp6iV2kBuim3F8A2ugiTgNX3/5rXovoYZ1bhN0aILOvGpaQz3ojLrS+Lk5yZC9KZB1A6nEou9XSmIPNf04K8
 KeK2A7pC
 RQnR2Vw0rnrrXC3HxMYEhQI4r7SBwZBXxpnhwrBFHIDsj8/IfBr0ufVvUXvabpbgjZYNQpUDfcTtiU/CPSRmWXMOUTwdg0znda6oDoQvzfjLcRdm8Ox3f+0oZmEi1wgmbG6QiT2ETiCbT7UPrgoZWJjXh/wAqgrXxSDsIFJvfVjU5XoT9f7xmJm5TqG3CRytIV2CRr7ZWYnA5ucA7EiOXEZr+jOS+wiTNz9hMyFe7RnOZ29VIprPclE79kjueHtJ6NOibrvOF//uHcCbc4+8TAI2ZICP7XgnjNganLvmDaL3nm4YqUUjuxmAtikg9FGV329nOSTcEFnD2pXJVvr1uQL9Ponq0LoCRTpYx8GCgORHevlUv+BYpNpRtH0k+OehCtmkGnxqb9hJsAuACD3JytExb2/za7oYyRkssbqqiY8vTxXUD8LP1nXpTNY99CGda/OWr7dYZpwqkr63MtiLInyjCe0fSDaVJhBeu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 16:38, Brendan Jackman wrote:
> On Tue Apr 21, 2026 at 2:43 PM UTC, Lorenzo Stoakes wrote:
>> On Fri, Apr 10, 2026 at 03:17:58PM +0000, Kalyazin, Nikita wrote:
>>> From: Nikita Kalyazin <nikita.kalyazin@linux.dev>
>>>
>>> Let's convert set_direct_map_*() to take an address instead of a page to
>>> prepare for adding helpers that operate on folios; it will be more
>>> efficient to convert from a folio directly to an address without going
>>> through a page first.
> 
> Why is this more efficient? Isn't it a purely compile-time conversion?
> 
> Indeed in the current implementation folio_address() is
> page_address(&folio->page) so it still goes through a page anyway, no?
> 
> I might be missing context here about how this will look in the
> memdesc future.

Good question. page_address() is really only complicated for highmem. For
non-highmem stuff it's simply derived from the page pfn.

I suspect going page -> pfn will remain as efficient as it currently is (with
vmemmap). For odd cases (SPARSEMEM without VMEMMAP) going through folio->pfn [1]
might be slighty faster.

[1] https://kernelnewbies.org/MatthewWilcox/Memdescs/Path
-- 
Cheers,

David

