Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1157FCDB46B
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 02:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3D616B0088; Mon, 22 Jun 2026 22:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF226B008A; Mon, 22 Jun 2026 22:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB61B6B008C; Mon, 22 Jun 2026 22:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 805BC6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:15:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E7EDD1A0392
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:15:17 +0000 (UTC)
X-FDA: 84909560274.11.1BB9C54
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf24.hostedemail.com (Postfix) with ESMTP id D911818000D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:15:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="KKtU/piF";
	spf=pass (imf24.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782180915;
	b=uIbjxx+VF4r8fC0ERVbINuNNzs/V2czTbhQPVNMgs/4fVhqY2uk/ZV/yLUYulLJClW7SXH
	B5by7xZO1MSB7GFNZ1FrweRg8dCMYaaQ6a0XW0n+JBndw5AWpzRPki2I9NgqgswaJDyuKr
	GsKtoagY82Dbw2Plpy2iW4lggoyimkg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782180915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cj4f9gMpklQdXLuSCT4Zp45J83xP673/kzsesCTgNUo=;
	b=Uc1F3/KmTXzGMnCDfGkgVNva1314lF8sPo9zMr14X2pufN28ZQ+HdA6r88RUgg0imLB5UN
	Ex/7sDUR1US6tLDL8P7x9bK7BxgSuJxibjl9FJ0DNgc2BXeSJdC7H1oG2I6OZKYw9Bt59s
	hC8GeLx87Y5cFD8PmJWsCxbbG7kFlvs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="KKtU/piF";
	spf=pass (imf24.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782180915; x=1813716915;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=d5AgO5tMzxYFDBtDlIOi/5Ij485uiyqm1kvbZMmKbDQ=;
  b=KKtU/piFvlSDY++3wXxUxifIW7klPxFG6kivnxP8Y8dbuxJ9nniqSvw/
   g1QGmSA6s5zfKt/XH/ZLS9nbXWyqoDJwyWBEjiteYYAwQvInRA2ioqmF8
   ycImOfbKMFJLAMTGaMHYMxILsxA0dMIB6gji2CGU2X28mpTSPA4Y7c8c4
   MmBt8BEyCn2S6cY+k9CYjF2SDZSsSE0Al3cQTAXAZut5IyOxdu7r/aDhb
   GK19+QCFJVZ1tMoVz9TF6P8w6BxHFHeKQ2U9ocQMVh8opUvsFhoes2FmX
   398lIao9xxj7mGMKVLk6V23EwflUNFRX8Ul4t52J55xtQ789P20ra6cl0
   A==;
X-CSE-ConnectionGUID: KqxPz9ppSBytW9t8w5tr5Q==
X-CSE-MsgGUID: f3U667OaTaq+o4ZCHUljVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="100467944"
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="100467944"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 19:15:13 -0700
X-CSE-ConnectionGUID: tGc2qhuAQciVN83fjDT2Dg==
X-CSE-MsgGUID: 2ZnM0rp0RyKyL7OQapoTMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="247044499"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 19:15:00 -0700
Message-ID: <cc2fbb22-e70c-4f97-9c91-ac1f4dfbe48a@linux.intel.com>
Date: Tue, 23 Jun 2026 10:14:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 01/46] KVM: guest_memfd: Introduce per-gmem attributes,
 use to guard user mappings
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-1-9d2959357853@google.com>
 <aceb07e1-77bc-49b6-a932-5fd9b5a21727@linux.intel.com>
 <ajnjTJdQKD1Kz3tf@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ajnjTJdQKD1Kz3tf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D911818000D
X-Stat-Signature: w4csjayupych5wbn4mo7k8gp6rfah8wj
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782180914-41567
X-HE-Meta: U2FsdGVkX1/SErtqjlRnnn9rhfQH5BdRpFBXrYmpH9b73UISqOk05XUA3Q7rceJi4MwZkMugsnUB8hlPZXRc2YwHod9Cx6l7YmQp22HX6TWYOy3N6ovtL67Z7jVWzYlSTzXLqxPeRBPFE8QOT3K2vowYK2YJmIkV4ma1PgtyJw1G0tzM6X8feuufSf0IvASha8WyoVWkbRqPrcXl2X+o+EY45UrzjTkXfb+83OtgSOfHQt6oxDIhuckWvFvLV8Bj+jEkFWpRjX6Vynm1h52kHwqXyfRXcsAHgIE4STeuP1yQl2UuunOCuKwezlzp4Siq/ExduHaaJftTZW1W+egnTlyT3f8h67VUfjkPOHFQ8/FapYMzIPYfMLSJQOKlqc3wtevmTgxRm9CUEpsQUqmzeY46GNRrTyIK/sN4ExauL2D86HpMuAL1hh80xXW+nTWlSgaEvNUM9cdKjkUHb0jBz8GBj0B12U/qe97+jBsQoBFseyS+zwaLc7ar7zlFZjAAjmdzGjK5g5Smri963kXHtdUZJPCMSqZTe3YV+imlRWnmY8+b7AdOmjkfdvV6uuGde/rbCLs42Rhl4jYS18pcIAUV7NTzmsYzg/3pO65FHyKZu3KqTfQbUD8VcbMEcMUHThEPFrgMeVN2FXMN9Gsj8ShdwudFTIFLe2sdbIoKBuSpDM/cVC6FDJ/F7IMaPrqYd/Y3Bq1gJgTlwu3vMCK7vHjvdQ33pPcaACFCtyssBg/URLF1aT73NUiBoHaZpZTncAYF3ubKN5gQGnwLL70ZakQ1Q3PKbTRbveLsURdHOyIX3UkTvtSRGNVni+gpiFkhiAlLEOI2CRsyyaJvsi6ptvYXzd2nZ5fYrg/r8I07odb0anpklsz2IRFBHOr+HHkrHseksBulVRS/d4U0sWDzcQEYW+5B+yeUexohqMp3Ntf8XimngFWbri7G6FOV1TZZBBF0GuTzgqNpJufCglI
 nmz7d2Tt
 e3ZfFVcn4ilr4eoifLpnb+gIpoQfFj80HbhKrrbtjjzx0VSyzHWVH74B9+BcBuMFdbQm32Jfaq0eKXNLfpTUsKoij9E+O0qK6n4/dwXnXlyMdYObzAvCd2MpDynqFTEtoMK7r/U2wNmaFfYEaXz91plo9FtD+jA7E06jjB2g6OJNU/SPE61uvmUcmd3V8ehMtCgt7IEf+ITI4xV8SLZTuIvqPjEHNdMIABj44yGhJ8cO7yITFiOPwQH7uuK5xIS8kMlclXoFG7WonWVpXxaNdLkJwDc2JJpkVScao7JtpuezfQm4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/23/2026 9:37 AM, Sean Christopherson wrote:
> On Mon, Jun 22, 2026, Binbin Wu wrote:
>> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
>>
>> [...]
>>
>>>  
>>> +static u64 kvm_gmem_get_attributes(struct inode *inode, pgoff_t index)
>>> +{
>>> +	struct maple_tree *mt = &GMEM_I(inode)->attributes;
>>> +	void *entry = mtree_load(mt, index);
>>> +
>>> +	return WARN_ON_ONCE(!entry) ? 0 : xa_to_value(entry);
>>
>> If the entry is unexpectedly missing, returning 0 means the attribute would
>> be treated as shared.  And then in kvm_gmem_fault_user_mapping(), it would
>> allow the userspace to fault in the folio.
>>
>> Should gmem deny such edge case?
> 
> After several bugs this year where a WARN_ON_ONCE() fired, but was entirely
> insufficient to prevent true badness, I'm definitely senstive to making the "bad"
> behavior as harmless as possible.
> 
> However, in this case I think we're just hosed.  If KVM treats the memory as
> private, KVM will incorrectly do prepare(), incorrectly allow populate(), and
> will caused missed invalidations (though I suppose __kvm_gmem_set_attributes()
> "only" lies to userspace in that case).
> 
> That said, assuming SHARED is definitely odd for cases where guest_memfd *can't*
> hold shared memory.  Ditto for assuming PRIVATE.  

Indeed.

> What if we instead fall back to
> the "init" state, e.g.?
LGTM.

> 
> static u64 kvm_gmem_get_attributes(struct inode *inode, pgoff_t index)
> {
> 	struct maple_tree *mt = &GMEM_I(inode)->attributes;
> 	void *entry = mtree_load(mt, index);
> 
> 	if (WARN_ON_ONCE(!entry)) {
> 		bool shared = GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED;
> 
> 		return shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
> 	}
> 
> 	return xa_to_value(entry);
> }
> 


