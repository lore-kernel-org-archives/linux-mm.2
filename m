Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8B2AC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 21:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0F2F6B02C4; Thu, 13 Aug 2026 17:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC63E6B02CC; Thu, 13 Aug 2026 17:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE356B02CD; Thu, 13 Aug 2026 17:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75B5B6B02C4
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:24:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E6ED7140144
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:24:05 +0000 (UTC)
X-FDA: 85097524050.30.4E5C372
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id E8D4C18000F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:24:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XWA8agqW;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786656243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJck1umI1gERxZKqi/mE4jPaeCUw7jHUSxZxlUOvdoM=;
	b=uRTrGCaOyUA+FBkgUZrhtuV3kkV3lmfMwA0c+tVoPTK4jS+0R/RWZOaT2+rknchfFaelye
	POgtro3DVBNYSR/pxIpd0m7RP35h4MPw83/fm82mGSjikrcZ2F6hk2Got9IwXzd8E4VmAm
	Z4EzJ/k5E3yM4oSf4SxF7e/tP7IbxfE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XWA8agqW;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786656243;
	b=z8zJRF0a2ah+h+ov08Gv4fXKT+jbU65OuFoE7xxQygBYkWwvN3K1B6Mrnyk77rpAFxR6Ps
	goF+WJzv3KMl+VdFK3RdQNao0cnjUhjUhlriuMO5MCrhqf6H2zT76gohz6PAMhVmiH6FII
	QxL8CjvN5uCzEIEHklwRwPMZrLvSsVk=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84830c774a0so235712b3a.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:24:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786656243; cv=none;
        d=google.com; s=arc-20260327;
        b=TkDPK6khxlwvTUE3uQL/9LuIGp5C20m90tUbLDrGISafLRH4DcWzg7jYGBMpNgqWWz
         JkryvthruPHBDzWGzxRNoLkmVESUglbZzbxl+eLReSvLOEMMUVvl8voDvl5DOcmEdsxa
         SiX7q4Oekf+Y5b/qyhImiAIyZeoc8CQIFKJhkD4Ob+6eDW+fC0+XC4hhwL9lbnWQJh3M
         T3RPUv/CqFEcS+hJiviOTyO1DW87jHR4NhcZRvcDP+vzW4aP7x+0kJWWDDt7ND94fmD/
         6HJ65JVyYUCRizOakZBNNeRguECXi/+KzRxrLG2c7ZKIjQgPLQVos24HrrBnHxIJTiyh
         TGwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=FJck1umI1gERxZKqi/mE4jPaeCUw7jHUSxZxlUOvdoM=;
        fh=aVNZ4khhAEHr0aK1IPL6ajKx0lCgmTIsn7PEOwlIPTY=;
        b=LL7/siXcwsXS6MK/5qMQdEDXzDaLyAtrh6BqmAYe6cLz44ripL4cVsP6rtegvzIHlL
         XVlFxhltcCVuMprcgppt3COnzB+PLDTPoIaoxFjMMwd0YtojE1IC4VZjpkwlyJ0S+ZgH
         FUS9BDAl2L6/VyECx96aBi4GPZlpTzlpeOLfc6jw80RAwvfl7pNDHyqsBP3wlzHpk2o9
         wXMsOAWKa1YjRUljow9yl8US6xQZEnm+ZXl+hZ9BY2Cmzoy1cUV7IAFprS1WhQcgQuPl
         0ZDN+zKoVz0mUJuChtJiJWc560KjfQV4mr92JajLqh66iqrpDl6kCx4LdHftvTCVby21
         M3/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786656243; x=1787261043; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FJck1umI1gERxZKqi/mE4jPaeCUw7jHUSxZxlUOvdoM=;
        b=XWA8agqWNER8okFdEH7h5fPmNSQzYXxi5VmX79nSvRplwEKtIDwf5I5Q3NvfxfYR4W
         GC+FylGXSHveqLpXCbMIh4Tgt7+IkERqFjrvDHd+xKWpaTHzekw/55Fkt/FHSlBkFH3v
         SqeYZvVT1Cq0YPuzWXglphNW3wAlL3blv9UBMefZixJLD0i2/6yNlpZ4eU4u8BwjRQx1
         4o+lDgovWteVZRMez/enIZabYlFWT4r9zALEhqQX+8d0DUeOZsZHdSoTrZSTacdCfFvk
         r4LhF8tNrmjwDHuPEdqR1kpq5QR0JjWJ7FO1jA04NFKtFr3yMC3eETLQnfEU9w3ZwByi
         r/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786656243; x=1787261043;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FJck1umI1gERxZKqi/mE4jPaeCUw7jHUSxZxlUOvdoM=;
        b=jWFZ+5YfH5R2ojuQym6mO/bBvH94CTwk8sjeGLQUucuQQPFDvEsdDFHSNpCmDNkkS3
         OQIbiVKJstKpv2BqHQ09Q9TcnnxyFG+9r+6vCrpkapkqdFYuJvVTT1ppCgsqTdUDSIj9
         f+7orcU75vGeU3d6ZG5gi9UrOyteq7n8fKw2OK1ih0WeUILVqx/9xink6FifhVikoFkc
         7Yj+xWmbWdAnP4clIsfogWOV6MbfQ+m52D1HfT0bXScbiQL4HvYjF8D4bqgi1nn7SUls
         8VQv7GSZdV4JYGlPY4HFszawExy4tBXKv2eoeJajh1GN49Ajt7qRSRftCaXnbeOlubvm
         8iUQ==
X-Forwarded-Encrypted: i=1; AHgh+RpjdZ5VK52LCbhXLkrMulS24gs3oGnrNFpPjpKA/dybMRTqeY5n07uqS84RKCU3Dihs60ZNVo1S4w==@kvack.org
X-Gm-Message-State: AOJu0Yxf9bsAgBA4l5EZNi4gmz4KqQyAiTLz4irpXMUg1CNLdGaKJWip
	HYeLOX4iLVKswRnd7BSnoe9G08CFvbPHbo4Fc3Amab0CrTyzQzkxmuAhfbDbughR6fGstIVgwFn
	semmTWhAvLFlBMLt1wzKozygn64MGs9nG8HxdvHh4
X-Gm-Gg: AR+sD11exBrMpk4NYprps0P4Ua8c9Fk8F3tq3PPuLI7WBSNWHTHYvYQ8tQ6r1wRpknT
	SizxClsbRhC5c1pP57chONKGcVHYh7PP4ighW0nEBAqg0Zf/kihuEaUoFvBrSxIT/93BDydkNzE
	kKwgbuzKkfVZiLmNtCvYGKL0yfhwYnwvlnuBo+F7pbICTm6imuvHPSFbeWgHX3iksNE3eWER1Uh
	D+X+SXCK7FOdLDsDiIRh/Xbb743VvL+nXtUVLPitT5ggIXcVwv7UWsQYXvCWAu/aHUK6AmnlWl2
	HGAFiFfQdo5eI5Z5uB/cfHy0DZ/9PGbqIdkb81SsuL4H82bJMIZSKY4obtAYJaM0J8xwxoCi+Ke
	urqwbZyo17mpA5eLsYwiuHkXg0qRQqQ==
X-Received: by 2002:a05:6a21:a4a:b0:3cb:d156:d362 with SMTP id
 adf61e73a8af0-3cc7196e785mr831997637.3.1786656241969; Thu, 13 Aug 2026
 14:24:01 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 14:23:59 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 14:23:59 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <82ded1ea-e0f6-48d9-8bcb-38a6bc5e9176@kernel.org>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-20-2fc18ee6d3ba@google.com> <82ded1ea-e0f6-48d9-8bcb-38a6bc5e9176@kernel.org>
MIME-Version: 1.0
Date: Thu, 13 Aug 2026 14:23:59 -0700
X-Gm-Features: AUfX_mzbri1ixV_zlf2Jna8d8Me5Qvc_rxP8xrcIgsSaQjjAlnxnniHAuo3sYt0
Message-ID: <CAEvNRgHpy52iynKfXeEkyCixhhu0_Hnu5jSNT8i+BNxvEoG7Cg@mail.gmail.com>
Subject: Re: [PATCH v10 20/41] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
To: "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E8D4C18000F
X-Stat-Signature: bp8pnbw9ubuemj45jbrommz9uzcui6kj
X-Rspam-User: 
X-HE-Tag: 1786656243-496471
X-HE-Meta: U2FsdGVkX18U/1wz3SP7e8lyVQYHhemlsHg3H1mw+0PAjevrPNHpjGL2jX6CXkttbZJQjW0EeSRndlJd4WX+0cKWDDJVXkbfjodAyFrV3YWGuU3mG0Qrs3cJ0bHjDdBG8dP2cZXV1r6pdcJpqXEtgfLnH8FOuTop+PtslAock3puyM8honzXDkScuhqw4imhidZBO1kt04yNbkbPf0llIKVUG8bJI4bpEGigpgE9KjlekSi1EO0JAwa4IAaRP3vJWV7t1Uk415Ia6Cvom3u9JZJisUMEhUQRih0zI+AsbfbG2lOO1FLVRTxmcWljGMEYtH6kRxHW1zXHtz3cgLG55jcXyuIYF+Wd4g0RksbxQtvBozF+xngj3rMzGG7L0kJGBDtCfGnife164oLFYiRTRObak0lVtH2BfyUPAg8M0XjvDyveeYwldUGgbA+4IP6lnZymmcmrrWSa75oy73VMXUglZluKyakMNOqwW7T3Ptagmru+AA6MBYkZkDhVeXD2rjniRCClYpmJP07gzS5utans0hqYBeyUOV0m9Q4nrYywy8Upy4gh1mJrbMihbple4PXJe6XHN1GGbbQkixGHzXJ7qegwlEf2w1F1BnYTTYoWHDM4TOqpqp3GS5UeRGRsqzInExcXiZA4BTya2p5EjnBfERazQeXz77c7wNplc7ZnWhIuSpmCsdLN/3+SAIzhiOtCChwJNegY1OddQJBMWEDtY7MI5dx8T0KA/axjXGe8VjgxY7i9r5NCseWfKWBnMte8g1nQjEUn4hgRExK+B2UQ6DvcyVDRqu/lkl9oiasYz9ePXqJjpTLpqck/EliZvgOh6tg0L6XZ+J+wQKYgC9cDhEZSmSW22coljIC7LwvZAq0Hs8bX7cxl/vcLTsXU6u4X/f4PkJolwPDvTQaiQlj3WfPAOAg2hW8VDXI/KPimz+KHGj1Q6ePC+jD9ridmRRYs9wh+KHn7hkHMA9S
 iWXalOLJ
 lPqW46xWfp0/VhmEwjtU+GZSTfCx3WwymrmGYOaF0HXMKpZgiyTbUIMPbZ2Wp2yl3pqCCSXNOO6oL/FmQeM+t0jsNiAa9NnFWwPcyTdP3yBF9XkUlIzHWmuLgyF5Tm3DNt8ouzM3ZmmjPgmYXQpttE2F34NZVCi5WEEGNT22F4cNp4Hvl6wTDA0W6oMBP5CsMPRBD61PTR7hhrqyAz2Za0XfsRoMryeVRHAMrXEhvZWU66KDBB91DIu7/OFc/f5CQ14VkvF6gbgqGR+A/4j9xA299oujbaDnLcKqEU8Ov/OpTPurxWSh6/cOjEAq8yaCecUBOgCInPG4MnN+9lUGjzcOKMRb2+G706PXJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>>
>> [...snip...]
>>
>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
>> index abb108886733a..2c3c22aeafa54 100644
>> --- a/arch/x86/kvm/Kconfig
>> +++ b/arch/x86/kvm/Kconfig
>> @@ -81,13 +81,21 @@ config KVM_WERROR
>>  	  If in doubt, say "N".
>>
>>  config KVM_VM_MEMORY_ATTRIBUTES
>> -	bool
>> +	bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
>> +	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
>> +	help
>> +	  Enable support for tracking PRIVATE vs. SHARED memory using per-VM
>> +	  memory attributes.  Using per-VM attributes is deprecated in favor of
>> +	  tracking PRIVATE state in guest_memfd.  Select this if you need to run
>> +	  CoCo VMs using a VMM that doesn't support guest_memfd memory
>> +	  attributes.
>> +
>> +	  If unsure, say N.
>
> Hm, does that imply that a distribution that must support both, cannot ship a
> single kernel?
>

Did you mean this as a documentation comment? Should the above read:

	help
	  Enable support for tracking PRIVATE vs. SHARED memory using per-VM
	  memory attributes.  Using per-VM attributes is deprecated in favor of
	  tracking PRIVATE state in guest_memfd.  Select this if you need to run
	  CoCo VMs using a VMM that doesn't support guest_memfd memory
-	  attributes.
+	  attributes. Select this to defer selection of where PRIVATE vs. SHARED
+	  attributes are tracked to KVM module load time, where
+	  gmem_in_place_conversion can be specified as a module parameter.

	  If unsure, say N.

I think we should do _without_ the above clarification since using VM
memory attributes for shared/private status is intended to be
deprecated.

Is it fair to say distributions should not support both, and if they
_must_ support both, they need to read code to figure this out?

> --
> Cheers,
>
> David

