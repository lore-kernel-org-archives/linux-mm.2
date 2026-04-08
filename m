Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14DF01073C98
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 11:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79A756B0088; Wed,  8 Apr 2026 07:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771FC6B0089; Wed,  8 Apr 2026 07:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661C66B0093; Wed,  8 Apr 2026 07:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5543A6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:02:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DCFA85C0C2
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:02:15 +0000 (UTC)
X-FDA: 84635099430.21.49A69ED
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id C14651C0019
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:02:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="j0m/Wl5D";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of steven.price@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=steven.price@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775646134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0ZXcPKyMB2Uz4ebX1V3uX96cejqIV9Zdqzp3mJz0Sc=;
	b=1BkQTnlgdnWmuM4CXuSNB5zGikwRMbdYWj0ECLsaiK7FyXyutLuELtFHw+TuBadwJfwpl+
	yFuWGTvrduA2wgGrVEHsw+sFdWwLc2EvvnLfWA5iFxGKbpaPAPA4A68N3/q/r5JsPPo3+W
	I6dVyWw/M4MjQB0fNfNVB5lhnBYHsNw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775646134; a=rsa-sha256;
	cv=none;
	b=JjygxubnBJ8lc0riQIBYysvF8QVO6jg/X5RlBsM2NQAfLv75drQ0cZP+6HgtBAvCzwiX0C
	3nga5FtSyt5kkwru6Hf+NZxbjyDDKjJHnpzOA8yk2W1kEBlfWi/Y1vGpW41Y5e977aoJru
	EcRx4LFBRixCy6fHpKpf9S+BvENmiBk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="j0m/Wl5D";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of steven.price@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=steven.price@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 078473161;
	Wed,  8 Apr 2026 04:02:07 -0700 (PDT)
Received: from [10.57.32.88] (unknown [10.57.32.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DE403F632;
	Wed,  8 Apr 2026 04:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775646132; bh=BcjAsJfFFdxOuFJG+yx8h9dEcchCwv67qshCeNpQzVY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j0m/Wl5DLNS3bb0LPJygmxr64zm8k47jOHhnUdaH8o4hEg7UUONrE66mssRlJ7NT2
	 6bzBCKlVrr+w2+XGl2eztRQqDLePKhvx7aHRms/5lUbXVIvqBABzatYJU+Jw6NrJnn
	 B0h8Vu2G1rPcddUOVHZq+00sZ9LGtr5cxfhIEmOY=
Message-ID: <9c8ddc37-a236-446b-a85a-261f370d644e@arm.com>
Date: Wed, 8 Apr 2026 12:01:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for
 KVM_SET_MEMORY_ATTRIBUTES2
To: Vishal Annapurve <vannapurve@google.com>,
 Michael Roth <michael.roth@amd.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, ira.weiny@intel.com,
 jmattson@google.com, jthoughton@google.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
 <CAEvNRgGm9icDK8sK5ZfqHEOEqSbvjwtihE4p9d3vpBq-NfVjmw@mail.gmail.com>
 <CAEvNRgEtigp7+PVDkyu_DH947CUqDt312d+P+hWjjd2fHONiag@mail.gmail.com>
 <yvfwexsub7nrogh67hzcsupbrkzer6a7kbeao5tlq4elrzc2iz@xrwdjd7p32pp>
 <CAGtprH-kgRByFvvCYeWMXtsvpb6qpaWAo8k-3PEnioyPg-LEvA@mail.gmail.com>
Content-Language: en-GB
From: Steven Price <steven.price@arm.com>
In-Reply-To: <CAGtprH-kgRByFvvCYeWMXtsvpb6qpaWAo8k-3PEnioyPg-LEvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C14651C0019
X-Stat-Signature: z9irf1cn75ooz7ohrkynywhy5k65in58
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775646133-229289
X-HE-Meta: U2FsdGVkX19geHwLhbbiGrHC1wA8hfQWrJ9rX4F6pGZy6WoA4gsepJspf1JPZuWR52WtRQY19CfJ3bopA9etlnw0xT1e0GYDy96TVkqSpLgYu7mReJHEUaFrcRRokcmyWzTGvEKdOBBbnyRdKj5TMP5pJEK34MK6fT7uV4qB/Q/QCnLDgbrdeoSkO+dfjeoWI6UtSOwgpypFvrSwatTiJ41VyleGtobM+TlLIfR1GRtqcxsqlgSnj6CgCF0b8P+gOvuy3hk8VixTC2bNYL7hudBid1RFp8CJIqg4+NAqLdsYLURYZ1N2+k1GWKfSKNPtkNieQ7pNsMFPvjz7RYsqD8Ua/fAkgqbFxqm6F5wEoBWHbLNg9XewS1I2XQICO1Oy7/qyodwrNBOnsQAKKyRRnNu0AkLPg7PHCnDGxdcUkf0363GNJGdffmD6PSDGtp/QROZIi044Oxw33TiZ0xMe0yAjagB9bk+Z228Ott6doxpLbH+7m+vVcrTMwcoXuBu2NSXOR4kxTHKu6e20uf+5ySNvVxtvvgRpEA7HJImIZPD4rrHmGxr4gYH5Dw+kWgExaPwE1pD6WGyLh75uhmwHYCuUEqnpaN2yjdfDHXdkTbS9IwwZwJ/V0AZiXchiqcdWySnUoSparCjsttsPKxNNv14ECTaHi4kvWhDzniNllJN9xj0zEF34yYXM2lkUnY1Lr/uRCv7bCwi+O3Q1oMBUWXm0apOGLtGKc/xPBBfAhgWnWhKDxE6nEe5NKakhcQ2v+2T8OQV4YjvLgiH21S/GqjH7OJvF8hgLi+Jleyi8O0gdGdNA8YU1rTqOvOaB22BeNoyQwPhcSJUWqqaygvkHjgf3zV4nPK13I9yVKLnvva3dvK9XeXBbsaKTtdX7iavQr2tHnORxgcR4RitDmEN/dxkU7K+t/8+G2Y+ngwb+at3oCZy39QNKi9ti7HHBOmItIvqhMsLDJN6y7kxz/ad
 FEH9aNnN
 YP/QtWkZfGDgTEC2GpkGVAlZPkWiXBQ/6Ly1sSViYRc2hQNAQD2d2feGCBHlf1Q+uSeK3cRY+e42MHw/0vamFLgwdzXQJBnRk73L/SeJg29jcqbVqRGj6uVibn3HO/P91W4eWrhQ+S+DSTbMdbhnm/PxGnxx/ZsuxoFfqOEs1noHx5FaZwaw3H7gNsaENC8IifHKzV+JINNyajQmZfLsUi46aY6skN502u/yYXs4Q8R2WqG+J2kYidrwVWa8cEkZwKfflepyNUb7TxmCWoRYfK5+0TF60hjq1ywKxJIDVtcO1h3I62VnFym1KIIkfjRrRcf2M3Ecz22ot8bxNHM/ZH8vobAOOUaSXKOYNWks37vAUj/V6Lol+JBF7/n7kPlhELrVp/UUxaYPUUPbxXsvjx0eBKraKjQBf9wWa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/04/2026 22:50, Vishal Annapurve wrote:
> On Tue, Apr 7, 2026 at 2:09 PM Michael Roth <michael.roth@amd.com> wrote:
>>
>>> TLDR:
>>>
>>> + Think of populate ioctls not as KVM touching memory, but platform
>>>   handling population.
>>> + KVM code (kvm_gmem_populate) still doesn't touch memory contents
>>> + post_populate is platform-specific code that handles loading into
>>>   private destination memory just to support legacy non-in-place
>>>   conversion.
>>> + Don't complicate populate ioctls by doing conversion just to support
>>>   legacy use-cases where platform-specific code has to do copying on
>>>   the host.
>>
>> That's a good point: these are only considerations in the context of
>> actually copying from src->dst, but with in-place conversion the
>> primary/more-performant approach will be for userspace to initial
>> directly. I.e. if we enforced that, then gmem could right ascertain that
>> it isn't even writing to private pages via these hooks and any
>> manipulation of that memory is purely on the part of the trusted entity
>> handling initial encryption/etc.
>>
>> I understand that we decided to keep the option of allowing separate
>> src/dst even with in-place conversion, but it doesn't seem worthwhile if
>> that necessarily means we need to glue population+conversion together in
>> 1 clumsy interface that needs to handle partial return/error responses to
>> userspace (or potentially get stuck forever in the conversion path).
> 
> I think ARM needs userspace to specify separate source and destination
> memory ranges for initial population as ARM doesn't support in-place
> memory encryption. [1]

Indeed - CCA requires KVM to first "delegate" the page (effectively the
shared->private conversion) which will destroy the contents. Then we can
populate the data (but that obviously has to come from elsewhere).

The closest CCA can do to an in-place conversion is for the kernel to
copy the data to another temporary buffer and then the firmware can copy
it back after the delegation. An early version of the CCA Linux patches
did this (long before guest_memfd). However this is slower than it needs
to be (two copies) and difficult to size the temporary buffer. Too small
and you round-trip to the firmware more than you need to, too large and
you waste memory. And, with increasing support for huge pages in
guest_memfd and the CCA firmware (aka RMM), it's also challenging to
preserve huge pages while doing this dance so I want to avoid it if
possible.

> [1] https://lore.kernel.org/kvm/20260318155413.793430-25-steven.price@arm.com/
> 
>>
>> So I agree with Ackerley's proposal (which I guess is the same as what's
>> in this series).
>>
>> However, 1 other alternative would be to do what was suggested on the
>> call, but require userspace to subsequently handle the shared->private
>> conversion. I think that would be workable too.
> 
> IIUC, Converting memory ranges to private after it essentially is
> treated as private by the KVM CC backend will expose the
> implementation to the same risk of userspace being able to access
> private memory and compromise host safety which guest_memfd was
> invented to address.

At least in the Arm CCA case the "exposure" of the private memory is
only in terms of allowing population - and only before the guest has
run. The host isn't able to access the memory in any direct way after
the memory has been delegated. But the RMM provides this populate method
to copy data into memory (in a measured/controlled manner).

From a CCA perspective the logical flow is to mark the memory as private
and then call the platform-specific function to populate the memory. But
obviously we can fit in a KVM API which is different.

Note that CCA has a specific VM property called 'RIPAS' (Realm IPA
State). This is the guest's view of whether memory exists at a
particular physical address. My current series takes the view that all
guest_memfd memory is private RAM and the guest will have to
specifically request that it is converted to shared. I'm hoping this
series might provide a way for the VMM to configure this (before the
guest starts executing).

Thanks,
Steve

>>
>> One other benefit to Ackerley's/current approach however is that it allows
>> us to potentially keep hugepages intact in the populate path, since
>> prep'ing/encrypting everything while it's in a shared state means gmem will
>> split the hugepage and all the firmware/RMP/etc. data structures will only
>> be able to handle individual 4K pages. I still suspect doing things like
>> encoding the initial 2MB OVMF image as a single hugepage might yield
>> enough benefit to explore this (at some point). So there's some niceness
>> in knowing that Ackerley's approach would allow for that eventually and
>> not require a complete rethink on these same topics.
>>
>> Thanks,
>>
>> Mike
>>
>>>
>>>>>>
>>>>>> [...snip...]
>>>>>>


