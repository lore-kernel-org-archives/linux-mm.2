Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B99ECD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3EB6B008A; Wed, 20 May 2026 04:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BAC36B008C; Wed, 20 May 2026 04:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13566B0092; Wed, 20 May 2026 04:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E01C86B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:41:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81B66C0487
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:41:28 +0000 (UTC)
X-FDA: 84787154256.26.36C57BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id ADCC420004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:41:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kBH6DuUG;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779266486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwkmkiBD9C6AzEumXzl36+9Ya4pNjd8VrP4O4E2jgTk=;
	b=GAp4stIBLyV7t3cZL5qlYkgOrdjNJe4qq2QWB7bJaDM6FXITmhQ/hJakk2fUXyI3G/gLdN
	e1U8Ze2S7pvYfbe/fei52PaDEaseqcMn0cOAX556B09JWrIsGlNyREqV44oJ7xvQ/rCM2N
	AG+edF1gNhmFnxhD8+Iwy/9yKCsOlXE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779266486; a=rsa-sha256;
	cv=none;
	b=7NyJWmREqPqcDy6SZQOLw7+5ZrRhnkg6T+6x+u8P9ciK+0h+vRh02p1I6uzGUxSkeN66pi
	jBLB2is8zmeNTU5oYwlXwdWy1Yd03SAHS9jBX5il/IfJnelqlntNebMMxEm99lhPD9n0DR
	upCaKyCWQEUhRnKl7AIhA8Z4zdZXVnY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kBH6DuUG;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD4AC439DF;
	Wed, 20 May 2026 08:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9B61F000E9;
	Wed, 20 May 2026 08:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779266485;
	bh=mwkmkiBD9C6AzEumXzl36+9Ya4pNjd8VrP4O4E2jgTk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kBH6DuUG4C6QpVo6IiVACT2i/nABs96Pm8EXIE6G5MoFBJNZBOvGKp/Oyu0Amgxpm
	 AQZtxq8C8ev68/W96+ygmw+2NDWB6NV9S6FV1uhN+HTSDW161E+4qVogmxpHzTKSRO
	 HunFITy+sQ4iu+TxSc86dzLqFmxjKGjICt/Pk0DfFWHyOxoHRGtTrKUfu4YEMUbgOa
	 mpUaH5il65pXDbUqBpzkNREI7z5e4dbX9HyRRk/Wt+c8N55wOzfUHiWP0hlERF3ti9
	 m+T/rb5IILdceVqvDTmErOeSitmqtJw+UdpA5GiLt/I7CpujzjBUxY8ADuObrsSRN+
	 pmxZvHMr2boZQ==
Message-ID: <fb889bfc-af0e-491e-a69f-38c2abf88d22@kernel.org>
Date: Wed, 20 May 2026 10:41:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm: Add ptep_try_install() for lockless empty-slot
 installs
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Tejun Heo <tj@kernel.org>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
 Changwoo Min <changwoo@igalia.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
 bpf <bpf@vger.kernel.org>, X86 ML <x86@kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20260517211232.1670594-1-tj@kernel.org>
 <20260517211232.1670594-2-tj@kernel.org>
 <9ba50fd2-077e-4291-9276-9adb18186873@kernel.org>
 <agtuPrgIDNKSu2Oo@slm.duckdns.org>
 <2f02d90d-cdc9-48ef-abe3-99e00f22595f@kernel.org>
 <297658c4ae2d6e7103f5968efc936224@kernel.org>
 <04b03066-86d3-4c0b-b077-307fd0f3bc9c@kernel.org>
 <5590fd3d-dae1-4070-b52f-bc40982ac678@kernel.org>
 <agyZxmHoueGwBAQg@slm.duckdns.org>
 <CAADnVQJt0p7hSn2G074QZRh2LEdthy3RKYJ9j3w5yeJ-e8UQLw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAADnVQJt0p7hSn2G074QZRh2LEdthy3RKYJ9j3w5yeJ-e8UQLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ADCC420004
X-Stat-Signature: 1ozq44414en6mr1ut9jyw7gkbeum3byt
X-Rspam-User: 
X-HE-Tag: 1779266486-448075
X-HE-Meta: U2FsdGVkX18LswcXCqB3tsSzvTbGebu7pGwYze3KfrZj/vHy2gTlU+QpuosSEVFaTcT1ajTTF25vd8EwjVlq6N7u2XtF+/DnJNBPuP2nCoAr/xTRgv2QL36ZBFMgxxUj7j/NAlYEf5Ru/jGHyf2y9w0aJSRPCHKopE6fSsNUrmi2gUBC4SXxcJu1RuMeLzA9TJVz8zJm+dVy2fqiJT7Mku6n26Xse4gfY/Purd+zIo5CzpqsXRjOoo9P9BgwPOk6q6Ox1UMZvpCz8purb1DVEhhweQGS9tj3MJCC8Vbfq96XLI0Vp8EZx5+VlXWCf9bWE+armOxVIWdFXSSLoyPClNwR7q/1B0UPnlBhPzg5LKL0y6ES0Litx+/cGAZV1Tt71IcSUjUVs0Uu/oIyMlyOWFZCNH/OGBerC5AMbUR8aNBUhE1y/rx1mnuqdE0e9MugbuVhupsL4IYONPyQBF2IIjZ5u723ikGf7rEeBdj5jur3soXGpny8LP6zXG7J410HXsRtDI7mRdN6tV6J2xzI/v18yJV+lUsqcqD5h4l/4NO92SmfUySlm8SeD2jmBhv196BCZ0PFX0oHygwdKbh+VapfYEmKcGHKCijaYyJQB0F6qpR3iLpMCqmRgl2q5aQ9qfp6VVGlG1tj744+ZGwrhFyfOVozFSwKeJjdZuIuT3ob8Rpu/Z66HHCBSGphO6EXahfmusHXDpjNLWqVInZmM+KO4XeczGEJKZUh21oLg7v6alwt8e/iKc+croqxgIWAmRJANJRfLEbJO0c9sq34TtZsioI4nnE/le3R96s/I1+/jieiUb0d84RDViYkYYsqtlDJJugItbGQPTI8e6GWlGvJEquw2gLOkgHokEipKemATDeKvAXRreczszR1NXQvHavJf88StqPM939iV1KRS2tQXEyV31zJDVwnpwJrwyhIWowHlT14c9Dw08Z0dDDWBJ04jJhaS6dFd/cW8+C
 Ozt8Ip8S
 0KyYVzOzospV5dywQIdB3Mc56ZiowcFPXyesg8+PNyS5zEY3HYThoT2qsZ0rM7S6Ot3nzOQsN3pFPFsZ0IuR//9GUEdIC96QQHHlJ3v2+5sfKJkYIL/qdVNt27hmyxGc8UQA60qca6EUmDuwP2osiIH6mtGirqFIXRwRmc+JLc5phHeOO4CcXHLSH2AIxhxTUPe50FZVwh3xi+GiYYoPh+KiQNrEzbgo78o+60NECPlo+lRibQxSwlLblamgR92zO8d5Ew18lIywd96FNwSqBVoxGVd44UcBY0RvQD9pBAXmiIRnOSHTN/6SN+NnUSNRW6hdVVdW/Tc/mx2LtX379p7ssfR9z3RJh9H8VAURfhxIeTvDj8JreZ6XpT6A0khYZ5SZ5MWppsALNZ8865JX8++ByP1i7VVR5fKsJGf4jEKOeNPc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 21:04, Alexei Starovoitov wrote:
> On Tue, May 19, 2026 at 10:11 AM Tejun Heo <tj@kernel.org> wrote:
>>
>> On Tue, May 19, 2026 at 11:40:48AM +0200, David Hildenbrand (Arm) wrote:
>> ...
>>
>> Wouldn't it still be either or with both cases being okay?
>>
>>>
>>> ... or can we run into similar problems with kprobes? (I am obviously no bpf
>>> expert ...)
>>
>> Yeah, I mean, that was just the first TP I found scanning the code. Any
>> kprobes or other TPs in the path would behave the same.
>>
>> When this fault triggers, the BPF program has already malfunctioned, so it's
>> not going to be a high frequency path and performance isn't a primary
>> consideration. So, anything that can ensure that the kernel doesn't crash or
>> lock up would be fine. Any better ideas?
> 
> As you guys already figured out the trylock is not an option.

And that should be carefully documented.

> The fault handler has to install _some_ page and let kernel continue.
> Scratch page or arena page doesn't matter. Potentially different CPUs
> will see different page. It's not a concern at all.
> bpf prog is buggy, but the kernel will continue to work without a glitch.
> bpf runtime will disable and unload misbehaving prog.

Having one page table walker overwrite a scratch page on race is just rather ...
questionable locking design, that just screams for problems long-term, really.

At least in apply_range_clear_cb() one could similarly switch to
ptep_try_install() to at least have both these paths handle races in a
reasonable way. (having to handle when ptep_try_install() is not really implemented)


Anyhow, the documentation of ptep_try_install() must clearly spell out that this
must be used very carefully, and only in special kernel page tables, never user
page tables. There are likely other scenarios we should document (caller must
prevent concurrent page table teardown somehow, and must be prepared to handle
races if other code is not using atomics).

To highlight that, we should likely consider adding a "kernel" in the name, like
"ptep_try_install_kernel()".

I am also not sure if "install" is the right terminology and whether it should
instead be "ptep_try_set()". (set_pte_at is the non-atomic interface right now)


Further note that last time I talked to Linus about arch helpers, he preferred

#define ptep_try_install ptep_try_install

over __HAVE_ARCH_PTEP_TRY_INSTALL

-- 
Cheers,

David

