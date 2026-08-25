Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29F98C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4E9E6B009F; Tue, 25 Aug 2026 10:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0F86B00A1; Tue, 25 Aug 2026 10:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52126B00A3; Tue, 25 Aug 2026 10:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78A5B6B009F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:20:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3C50120451
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:20:08 +0000 (UTC)
X-FDA: 85140001296.10.3023A18
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id 00AAD18000E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:20:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OJA8YycQ;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787667607;
	b=B7/G3y8mvsUTPvv1DUgbiyLSsU3YYksuigF8UuAHMn9XSFNZiNe+MlUDwR/gAclc2XXRyX
	Ok3CZvIpkv4sTIhyf2XFo/+bjmvJ3U6NlK8SKhG4Ol2f9ad5PNeLQCORutYh9aRgj5ZFSK
	fj7SdmBMZL5D21TpZxKivD+izseMBCE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OJA8YycQ;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787667607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t88jbvctONs+qHXsNnGi7BlHTFxQ0QLhoZsqurw8Hko=;
	b=zhg4dYgDAHuykgpIsgN8uy4H/lYKp7o11geghFfxcvUp5x4h3ckQDhXs/e3b1xfQIN9ti8
	uxJHkWcjTrteG6zHS6dL3gN4Dx/HOzSbQKfQr+pF6C2fA/mVs4Vpc1WU1cdn+DkFUZPclh
	WZBLAClFBAR02u6tZJ3Bf10JvAgUWI8=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-908a2ca5becso37428966d6.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787667606; cv=none;
        d=google.com; s=arc-20260327;
        b=ST6aIA99HALAeuVw2wLRxlh9LNFDA8TGDc3Ix/EazlihF1aAjsULjIeMCoIX3KTtqF
         EZ7K0urcino4LAwm4BiRpGS7m9J9gt0i91C4bv8RTdq5mKlAJMx8ogV1nUYQ7kQ7EVSu
         Zw6JQKzsx6KI4431O6Uw11brlRhcyHufQi3T1cVHZR7mELX92l2ZkjYrhpu4N4lbSfV/
         R+MuRWxWkQmxQRXAEJlZVuSZFto0IoUmcvWn1rCo0slsPVgmSGLKbltSWfvWMKerE20M
         yKkXQ07ym8X6z3YQoIzkKldLbeC6nEqCNNY3NVUqv5cZa3KdyOHeHWH6XDzXNxWn+Lw/
         sInw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=t88jbvctONs+qHXsNnGi7BlHTFxQ0QLhoZsqurw8Hko=;
        fh=i1mTM0kp7dtSmO4Ri5AIJVR8LqJdr/hmv4d87p4mroU=;
        b=bA0b0kkqqn8Toky3MoxKR1FNbliqtFGYB803x0y27iPFhny0ZZbLSKX7pwFdPIet2i
         14tvSeL+hu4MNHmcYlOAwnUcXzSt9VLcjKgyXhNQ3M24DNA3s0xchMbzhGqH5yRdaFzh
         Fz911vaa5kuYSGIsrld99V9EIRdiopC/xgE13j71TI8bJdnYae3vXcUaiKdHrCbui4Wu
         Rgec5kTLbm4oR30OfOH+JriuJUvxcfz3X5ShIns4fCdl85VGxhfhtBviX4isKSTvxIRE
         FIM7viFiua9UEZ2uB0wo0tfpC5GZbLyBCj2RQ7xAffrvejCTPFD9RXQORGVAfrLWw9KO
         SXUg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787667606; x=1788272406; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t88jbvctONs+qHXsNnGi7BlHTFxQ0QLhoZsqurw8Hko=;
        b=OJA8YycQrWG1mUhmw+Rhrk66kGmjM8tNIWqOplyHa5pT1c3oW8Xj/aQ0W9DW6zjCT7
         TvwKt2uvdZoNlnBDmlaXsAGfi0wIeav6YQYdaY4g1F1kpMGKdnLigbKLr0Wmnjxy/jJU
         2LNZuvcO1bTwvDUhDcOk408K+ArgYbirXM1MyeNde9DeoABQxIYg7RxacAh5UNXILMYC
         spKqd5T2tFIfwDqcK6KFqPizw6VoGCmikWgXxAL20nNY9VK4AR8m1W0D6HsJRInJ12qA
         Pr8NVrbeoHjIZtJuDfXjq6vx5W4b0XAUFB1WQsdGcvQs8ej5JZiwyCsgzXWCv1wvKR/X
         S4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787667606; x=1788272406;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t88jbvctONs+qHXsNnGi7BlHTFxQ0QLhoZsqurw8Hko=;
        b=poDb0/LDetVd3SP1dIMiF7GHMkGAZO3osncK4IWe1LIcheFsZuWdJCSSzE/Klro3KW
         rnODngz+BDQqeGbCDNlYu/ZnW/KUhx3eCFKujfhfSmFZWJJz6hURp7RvxAUmr8Vj03E5
         9peqPxO51ffQhhj5Y5bVD++FXiVhANfYEDH+ru4YvGf9duMVOwSam6skcG3obhFKuM8r
         TJN88ykQbE7WveCe/Rz7E/0y4MitNxpa26SN419UOocgi+v3ZxXTCt864HGf9mOGjazP
         okC6Ti7abqRmF6hfltpkLFQXGGA3idmN97I3Fg5tEDJU2gsyZIGDmh3arGMuwBN98KKB
         YKTQ==
X-Forwarded-Encrypted: i=1; AHgh+Roer8dw2wXwKcsYFUvZtwkdujs/W6cf3z6+RXgEs6cVnss7Vb8yyGc5AOjRHU4JRZYXxvARSMMQYQ==@kvack.org
X-Gm-Message-State: AFuF++koRPs8w1e5ylNsE3cHfRdfK+KiXUliW6XVVW5zj1F8poso+7iF
	5cOM35fSOAAxSmHJuIyTCg9JcTzFogO2DFHivpg+UjXFJfJQ//5WewELheAGQkF1HGqoM2HiaWb
	BJsAnHcciuBBUCGtP1bPAlyX92CXewCIZrsXU/ewm
X-Gm-Gg: AR+sD13+cRBmNdnIJjoBLVIEObnMBe8ZrfzevYvDH4UHQMLAsGiZPzcIhPPDEODuGMC
	q5JK24NKWLtzqVWUyELgOGBN/VTMF5mzkeVG7tdiPlaDUpfdJodAz7ZzaKT90CLEpc5dk21EQ9U
	w0Narn9tauw78mr0i8H3EhPHVtGcWqgw9L+XjB8G94uoiT3FmnSDEENBbPO4a9me+71+3+Y3EyI
	fVi2dvV0VUXNaTWmiJa/bDmXlymmlXX3CrX2l5T4v4DpF3vQ7qcS/5NrNOlmWF6Z5xZuTvlktNK
	lhx3oQACxtdzAF0PR77PUcwDbG88w57yhSM1PB24WME0zi6JqCdy8edqnjtfrsBXCufwOvnkN9n
	3mFE=
X-Received: by 2002:a05:6214:5089:b0:8f3:e0ce:611e with SMTP id
 6a1803df08f44-90cb7907bb1mr71992716d6.19.1787667604682; Tue, 25 Aug 2026
 07:20:04 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 25 Aug 2026 07:20:03 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 25 Aug 2026 07:20:03 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <9feadfea-c41c-4105-963a-a3d98421e1c3@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-40-2fc18ee6d3ba@google.com>
 <fe1c6359-7371-4ccd-9807-1d81c160d12b@intel.com> <aohEz_1JFVDtlSnE@google.com>
 <CAEvNRgF8XE2Xsn-g3qzPxcdfLdvJEc1FZw9LQ+deeXsFpdZsOg@mail.gmail.com> <9feadfea-c41c-4105-963a-a3d98421e1c3@intel.com>
MIME-Version: 1.0
Date: Tue, 25 Aug 2026 07:20:03 -0700
X-Gm-Features: AcwNN1UOU0Yq3Ra3mNR1CZsf74y81KeNAw_IC0Ss9JrlNXktfVmaAyZWIEWXWx4
Message-ID: <CAEvNRgGz4OD8J1OeVzAK9kmgEyQsBSMn1ncuEaTbGHesUc-Gsw@mail.gmail.com>
Subject: Re: [PATCH v10 40/41] KVM: selftests: Update private_mem_conversions_test
 to mmap() guest_memfd
To: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson <seanjc@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 00AAD18000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3py9caffbc7jkjoup74ndxnszpsac8yq
X-HE-Tag: 1787667606-336044
X-HE-Meta: U2FsdGVkX18JZWCi6qcGYZr4KgM31G4AwLCTXeD6f4l5ls8mJNKqbYhhZKigMUFHtnD38Mp2T/ZNB9FSHNiiwvpRf284PS778hqdJY8VtDgY7k99mPa29X++T4rCITnY0GDQBhpH+dV00Vc6dP0zkD6JrjosZsAMHbE73nj7AMA4z5Q0unZY1xKhtcF8Z6YtrnwaRNyWK56F0dtXbsyzSU1HAwIn25rStVe7ZRu5/E2cZbVq4qO3Sb7gB5bsDPSN2YowxwEaY1ITZDePjtUEYMIQbK4/jvJS4ZA+vzVtHA14bO2UfGBAa2KOr3aIf2H9TwHhjnxQy7l5cwSpZqM3FnzOworYCjZtT5b4MAW203sHCAfR1pbfK/pYlIUSB0QYGqJlqpxWsON8pbBkafRZdfxLyysQ1C88OBSQpr9W9+tiVRfnGfOg0YmfE06GEXNr2QQZ2gGBcC94jwx0xHWPTjIbjQIVTk1MxS/OLMlcajYMpPncBWNYaGlKqX2nPZRsjBJQ/uvojHCNBQU4j/v0jfTnxmpIHK/GXxkMTxhJloH5j4QBCFzQ6/bnTUy5zN8JEPzl6PsOsYwWwp716LVME963tDMq/myazgwvE1h1pSevJ0r7WpgtwpoMxikNAaWpNhvE8Omsz//a54gqHEW+8YYdAY3d9zUeNTNLCC2XHg2IbiTOcoN3bw9Mu4QVMacbDl6cfSs2m76Dku59XwVtLwh0RannPMNkMOYteWaI04OypfHxQvxtvYoCIEC/dcCfogzsNZf3oWxgXOs7A9nn1om4wIQOTEOPHiYqS+YgBfLPDF1mYiv9v7gDeSzmTBMJEk709ZKfUB21yyS3sjBQkXgSogjfX5ENoJpmr1XAX6WNz49wt8wqYV6R5s6NvmjufLoIytNuNa9g+sPQJmzIPpCRJE9cwovrBVmEHtUmHelSRt7DiZCDP6B7mv+kk0NRJn8wsAQ6AHirzLt/BKS
 PTqkbYQI
 Ze4fmJ+RxgofE787W8PSxID/9zBoInCH/F0IwpJSPgwrbqvK2uaRFmxkmKQ8OHESxdt5HFyStey9M79cMIdQnIIEJLyOCZcn0OR7rtLNpdxWOlYlQRvqk+tgMvRI2L3mnuzpopUJu68rMHWhIJRYOF3OgKA0RueYNc6QBpQs+R3nFohk9fGK7z8Mf9k2/Zn/XVwscq3tPFLn8vulqz5E7cGdjCrG4r9XaFz/0SaZ6QHrh29aFSulaqhjxaV62uVDxNKuHGOG6LZNLtUV0zMqaVFHdcPBiHwOVUlMpa3JN+1Z0eDjDIprf1Meu1+AUNEDvB3E8MHIreYAKjt+maspLoHDqk7ydueIjWlw3JbIM0SFM7U8T1RgXHSiGqpu1l22lWEq0zjOX+NM3f+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 8/25/2026 5:32 PM, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>
>>> On Fri, Aug 21, 2026, Xiaoyao Li wrote:
>>>> On 8/8/2026 5:53 AM, Ackerley Tng via B4 Relay wrote:
>>>>> From: Ackerley Tng<ackerleytng@google.com>
>>>>>
>>>>> Update the private memory conversions selftest to also test conversions
>>>>> that are done "in-place" via per-guest_memfd memory attributes. In-place
>>>>> conversions require the host to be able to mmap() the guest_memfd so that
>>>>> the host and guest can share the same backing physical memory.
>>>>>
>>>>> This includes several updates, that are conditioned on the system
>>>>> supporting per-guest_memfd attributes (kvm_has_gmem_attributes):
>>>>>
>>>>> 1. Set up guest_memfd requesting MMAP and INIT_SHARED.
>>>>
>>>> If I understand correctly, even with in-place gmem, the model that shared
>>>> memory comes from the userspace_addr and private memory comes from gmem can
>>>> still work without passing GUEST_MEMFD_FLAG_MMAP flag.
>>>>
>>>> Since this model is not prohibited by KVM. I think we should keep the
>>>> testcase for this model to ensure test coverage?
>>>
>>> +1.  Deprecated doesn't mean unsupported.
>>
>> The original test case was for non-in-place conversion, which wasn't
>> removed, it still passes.
>
> It only passes when
>
>    /sys/module/kvm/parameters/gmem_in_place_conversion=n
>
> It fails as below when gmem_in_place_conversion=y
>
> ./tools/testing/selftests/kvm/x86/private_mem_conversions_test
> Random seed: 0x7eace343
>
> ==== Test Assertion Failure ====
>    x86/private_mem_conversions_test.c:46: mem[i] == pattern
>    pid=288745 tid=288747 errno=4 - Interrupted system call
>       1	0x000000000040426a: memcmp_h at private_mem_conversions_test.c:46
>       2	 (inlined by) __test_mem_conversions at
> private_mem_conversions_test.c:356
>       3	0x00007f2ea2c89c01: ?? ??:0
>       4	0x00007f2ea2d0ec3f: ?? ??:0
>    Host expected 0xaa at gpa 0x100000000, got 0x0
>
>> Is the ask to also test, under kvm_has_gmem_attributes aka
>> gmem_in_place_conversion, to have guest_memfd used as purely for private
>> memory and have shared memory taken from somewhere else completely?
>>
>> I can rephrase the changelog and change the code to clarify that this
>> patch is meant to specifically test in-place conversion with MMAP, the
>> intended usage of in-place conversions.
>>
>> The ask to test gmem for private and something else for shared seems
>> like a different test that can be added separately, perhaps in a
>> follow-up series?
>
> I see it as the fix for existing testcase, not another new test. And the
> fix is simple:
> 1. change to use vm_mem_set_memory_attributes() to set memory attribute.
> 2. pass GUEST_MEMFD_FLAG_INIT_SHARED to create the gmem because this
> test expects the initial state of the gfn is shared.
>

I understand now. I worked it out, I should be able to post v11
tomorrow, just need a little bit more testing.

> ---8<----
> diff --git
> a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> index cf50e9a332c5..fbd6c63d21cf 100644
> --- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> @@ -307,7 +307,7 @@ static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
>                  vm_guest_mem_fallocate(vm, gpa, size, map_shared);
>
>          if (set_attributes)
> -               vm_set_memory_attributes(vm, gpa, size,
> +               vm_mem_set_memory_attributes(vm, gpa, size,
>                                           map_shared ? 0 :
> KVM_MEMORY_ATTRIBUTE_PRIVATE);
>          run->hypercall.ret = 0;
>   }
> @@ -382,6 +382,7 @@ static void test_mem_conversions(enum
> vm_mem_backing_src_type src_type, u32 nr_v
>          const size_t slot_size = memfd_size / nr_memslots;
>          struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>          pthread_t threads[KVM_MAX_VCPUS];
> +       u64 gmem_flags = 0;
>          struct kvm_vm *vm;
>          int memfd, i;
>
> @@ -397,7 +398,10 @@ static void test_mem_conversions(enum
> vm_mem_backing_src_type src_type, u32 nr_v
>
>          vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 <<
> KVM_HC_MAP_GPA_RANGE));
>
> -       memfd = vm_create_guest_memfd(vm, memfd_size, 0);
> +       if (kvm_has_gmem_attributes)
> +               gmem_flags = GUEST_MEMFD_FLAG_INIT_SHARED;
> +
> +       memfd = vm_create_guest_memfd(vm, memfd_size, gmem_flags);
>
>          for (i = 0; i < nr_memslots; i++)
>                  vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,

