Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86FD0C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 09:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02EC6B009D; Tue, 25 Aug 2026 05:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA236B009E; Tue, 25 Aug 2026 05:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C93A6B009F; Tue, 25 Aug 2026 05:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A33A6B009D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:32:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E84E2A37B8
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:32:42 +0000 (UTC)
X-FDA: 85139276964.22.11A6B03
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id EE01C4000B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:32:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CLy5CVdP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787650361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uGYcelPQ9NcToBmCcA1Af+U2AVoIV7KPe08HWX7sjzg=;
	b=sEEowA+CDCYR/WgejuSv+uSe8EyShE+LwCGMHR+8NMXMUY2iFe4uJ0K1nqNAMoyxR6SUbA
	9+hghX3n6i2mJCYYBMmoyUzt6ZFOGEYA3GNJEJqE1CquQJI3rhNQvltMnUk//eCjF3aVuD
	dY6tTTymrbo9EbiyW2cCLx6Vw4mVQHs=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CLy5CVdP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787650361;
	b=KPwi3gB/x1chJTMmwV2ZFWfGLZdyuQtoxqrU6AoOSxZUHMFP9pD39gi1ALhUaP2UCoN7Tr
	bikYzjosWQ2FsLO6KqVp7zPRjWFPaW53aZKbBvi4Hasob2fi8NFZN+2y0ZQLXz6vyGCL2g
	qtNukG37a1T+rXXMe+OnYwNLHGAGCdQ=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c928bf172so33354001cf.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:32:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787650360; cv=none;
        d=google.com; s=arc-20260327;
        b=pIyd5NgN7dVMYbL0jNn5PlwrHeQr6hBZOJmtIZPT1GB04isD5qG38TCxJ/8tq7BK8o
         aqG6PUE/hMP754j3M7pgNK23JfXNDoOzcn145+zkAD6wS4LG9K9Qn6oplYses43h7imf
         7piLDHgyWRnvUBFYnadp0LRo1nVgNh0tpw6sH9jrQAv8Qn8rlHxkhnlm7Cq7yBaQTjx9
         LAsiHDsTjtqTdbK25nHMEHT2T9lhg+eKASMSvUUc0Y7Qh45YD1mZJpaaBfnBjKM+zSG2
         lztBH+lbKqzGDjkpa3gY901cRNzJtVOl66SWVewk/fMRo2Q6J0uTZS+0gfOWB5rQ3zGN
         4bzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=uGYcelPQ9NcToBmCcA1Af+U2AVoIV7KPe08HWX7sjzg=;
        fh=BkVoO6hoGP57cxgQ7O+/mnnpIEKW4+cPKdkrcmMTpPI=;
        b=T7cWtNA5FcMyFQAI+sbFap9rrmcyjOXFajr7sk7FoXJRs2Qmu2p65D8Hed3Gwi3cmq
         3C2sWxx2CQ+33weVx1GXpc/1f8sQyR+VyhqM05LRYYNebwkft37dN+2KV3FJ05zuHnlu
         4Y1WcQDSK8LnyeGu8wJSxfHKZy4ohhuTfg8MsyZyr3y7UfLJsKJfFUxCz83yq9nE+W5h
         xHG1elhdMiNcH/oLzZIY9Q6CfgUaHCFGU7O17LV6VH4Bw+Fi8YC5KPn9+4VPDQ/rH36R
         fDUGWEMHi+1E/z/fVxyfva05wM4xgp9RIB/995cdWqgMQivNuR5l+HKKQxSN1s/stvMZ
         FMIg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787650360; x=1788255160; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uGYcelPQ9NcToBmCcA1Af+U2AVoIV7KPe08HWX7sjzg=;
        b=CLy5CVdPBW7w6H++Wx3YVB12bi/v/AUSBAXRceATQWMz5e+StuHe+K+0FPcgpqUBZ+
         5e4SgApoYemwlD6Yk4tNAd6dSZztn4rZav4dBznij5T+FTuKq5pOhTAd+zznbDxkf6Ar
         EtgbkVZi7DNoQwMyHUGxx/UZ4JiAs8UzWlsHo7v3fr28G9seRo9Z54mOqpz1Zbn1IMdC
         qdgMQ81HI/wihgrTao4fv9pscNVvazMekVqEmBNnpTDHOE0HFhjiarAx4XhGVi0X7HFh
         xHjOoG+TH062t8o2uDmunSR13zEZgOQyjm8pF7fWsqdAp/dhaZQlEJCVVVbaDuPeIOMl
         tvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787650360; x=1788255160;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uGYcelPQ9NcToBmCcA1Af+U2AVoIV7KPe08HWX7sjzg=;
        b=iM46rwOIKpiyOYUHZD0z9DZ2Tw4ja7O2aOZ9u1oZ1D6ExNqKHP8QGPJp5lLjsvSqk7
         Btd6MfdGAVELI5X7bBaz+KD+0BVkeXDGLoDPyhFJFgXKrXKW+CwORvPGRM1kS7NH82AC
         XS1czXGzLWWo52ce8rgWXIeo+RPGBLlGWZeYC8WqZwBklK2Ea9X/ICmh7fIkkrlj6hP6
         ISicFHNBvVK3bhXXaGz6zCGD7jmhGPsboEmQ2WcdBl7JMGxsNmP4555YNEhg94C/WNwo
         yF6nqgxx3GQnvRVoPRy5ghdDOCvlbbzMYS5JmMnrgXL48/5nluBH7ZA79HoJwRx0LeRA
         kMxQ==
X-Forwarded-Encrypted: i=1; AHgh+RoTIjXUJjlZbDuwl1dPCBWWeTq/dkejiwppAHolWclSDSAPA6Fjihz0SYbOdUlzxiiMd6u5lQq5qw==@kvack.org
X-Gm-Message-State: AFuF++lLploD7zyKfEQY6h+WhXudJoPT84mjExtNvIaNI0z18xW117Pm
	1BnWeXfFZS7C1kNSvkhj3HDgG89H3cAdswDDsEWP8+LyBwND8/wkutUSwiuvFlU91OA7YICcccm
	Z0Ex/7KIIY67+RFGrNOGqTIH11hLYHbHD5L13DpjB
X-Gm-Gg: AR+sD12gdWJYv0z0gkDerCZYEa0Mt5pMWPpp7v5+IG5V8ZUkKDUpM9jzczET6SyyT3e
	fDwPTJyJzfhkvJimS71yud4fLUVAQm5YD7l6yOBeQ/nSmUEzbeFvSJtvIfeKOMZrjXnEPgYR0I1
	oJ4LbncCUQlaMRLxxE3IQ1/1dGMaMhcj2fTH8a1bW2/zHLWsHDs7z5L9A+cpVBVjnjwE6mV+GU0
	M7bGl5rKduAqG2NXpO8aPqQ3RQ6puC0YUEttTdF6Xpqv1Nx81keqLBczt88Y/59Hxmr2yeS33bT
	0bg7EPxSGvYOKvIzJGbujZBRI1YURqGoSpP9j9kM1OKdZU8/O0bJ2S3nDFxu90tMY/DLitVGO/l
	XkU6JW8kitKd00wJRk/YQXsjHkONm65g=
X-Received: by 2002:ac8:5a8f:0:b0:51c:1eef:4fb6 with SMTP id
 d75a77b69052e-52df572d04fmr316920051cf.10.1787650359267; Tue, 25 Aug 2026
 02:32:39 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 25 Aug 2026 02:32:38 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 25 Aug 2026 02:32:38 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aohEz_1JFVDtlSnE@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-40-2fc18ee6d3ba@google.com>
 <fe1c6359-7371-4ccd-9807-1d81c160d12b@intel.com> <aohEz_1JFVDtlSnE@google.com>
MIME-Version: 1.0
Date: Tue, 25 Aug 2026 02:32:38 -0700
X-Gm-Features: AcwNN1WsNauanv_gwVuUewgYIPtJyz0xA7nijfgKendDL3I7JaxAnreMY2X_gzc
Message-ID: <CAEvNRgF8XE2Xsn-g3qzPxcdfLdvJEc1FZw9LQ+deeXsFpdZsOg@mail.gmail.com>
Subject: Re: [PATCH v10 40/41] KVM: selftests: Update private_mem_conversions_test
 to mmap() guest_memfd
To: Sean Christopherson <seanjc@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>
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
X-Rspam-User: 
X-Stat-Signature: fgaukf84ntwywe9ga9wb5jsnp7y1d8o9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EE01C4000B
X-HE-Tag: 1787650360-307375
X-HE-Meta: U2FsdGVkX18ilg+XHEjvSEj9Oh16VfyDBnerLph02BHLYcj0RG0t9gAqrz7JSnYqr6ShSMEwY3oQrTmO/B3VmbQOwzP2XxK6yzyV1Xw/cWvR16aoQIVlh0YogDaBFcmIqZScJbLitfsazo5tdyvKHEWApFPj03RK9sNZ00PuP90cmOKfJTMhTyZE3JLnMZR1ADWU0DLlmIKcWrJtDekiZCC07CK9vKbaBELR6sTSNZnLD1YCae7qXkpuH/1RIjs0k5ayUxodMaXzE711f12fj7ZFmPvBitB9JZ9QzMhUSEu6xRT3KW7ACX2IF9xNtdi9cqCrtW9PifKAdklaKD4UgmfwksIvbaXGVG8OOs3cdYSz1S9uFmAcwnobgtpzXDI1k64DE0bpee6b9FtT3U15H+/D/uWphW35muXqF6NTuohmJhgO0LyqWG+YBVW0Hs8MuOmtOWZReGRHfeifKn3LA99fAvEI5eFljjCZztx9HZtTO9+uMLQAR0hvFmjMRsiEzb0YZS4JYXvmHuiP78hZMgVYTXQjdlfmg5y8zcwnEeYmNIwJemUwL23kQfrWEwHN+eLGdQuH8ds/O5V8QedIQom/eg4pQAI5o0mkpmhirIhRHWMgsK7IWfO8C0AMk6g/ujrOCuSErx2gzyjmz6UC66EaxJugMQ5bg82DuLIrpVnG7MV90lspe23yi0sVpMVKYlA58u1Ll3mvu5hGvbvcbNBjK7YH4Qm5vnX0iXXeX3Mp0mE6XarGmQZrQe+3DEmTBdcBUEZm4ayn7ZXNndCq4ssqVkSDxZdxoVjeFFDxeLCWzqJPKWnMlNWRW+RUrg6Qd4Z7QoQmkl+DG5QxG51JZAScIfpg0lNk4rtdlN3WoxmRH3Dm2eABVdz2KvfoA/iehikNSCV1dAgO5dv4WgF02vJjZwoIeFCq8aXYk3OltOlTm4PRya1c1kJlYXdAQ6SKogYzep2AEPISPyu9m5j
 8/xmmZkG
 K0rF+JTFUQww2xKkT+4ct0wBPch970x6zcTXZkdT83VELco1rdJMVYZN1XewKHFi0DQH2wmJ1N4ivR2UPvVGXMLcb9IkUQ4NnmYtQJWVoofaCnnCT+P2Pt05Aoo1+2VYLr0XCihKWBeQ43LNSoHn8vkv0qhd+kR5yXm7YE9s9Ul93Q4q9t+PiyrriOd31PT6zEO1YqW1UoJ1vI2AtKc+/hvC7DCojr0CWmb/4d73MYONLjbjlezDX4P+9U8IKQDafCu6oJEgAA8KY4IJ/0eWNEM5IpAYVUbdcHutGkO8vPCVx2XwfKaQ4lJfmdRji1WIhrpOlnT1DlQx+eH/B3E4tOdX9gcQAV/mGWTfqnWKZjRVCIFh9+Wp7eopkLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Aug 21, 2026, Xiaoyao Li wrote:
>> On 8/8/2026 5:53 AM, Ackerley Tng via B4 Relay wrote:
>> > From: Ackerley Tng<ackerleytng@google.com>
>> >
>> > Update the private memory conversions selftest to also test conversions
>> > that are done "in-place" via per-guest_memfd memory attributes. In-place
>> > conversions require the host to be able to mmap() the guest_memfd so that
>> > the host and guest can share the same backing physical memory.
>> >
>> > This includes several updates, that are conditioned on the system
>> > supporting per-guest_memfd attributes (kvm_has_gmem_attributes):
>> >
>> > 1. Set up guest_memfd requesting MMAP and INIT_SHARED.
>>
>> If I understand correctly, even with in-place gmem, the model that shared
>> memory comes from the userspace_addr and private memory comes from gmem can
>> still work without passing GUEST_MEMFD_FLAG_MMAP flag.
>>
>> Since this model is not prohibited by KVM. I think we should keep the
>> testcase for this model to ensure test coverage?
>
> +1.  Deprecated doesn't mean unsupported.

The original test case was for non-in-place conversion, which wasn't
removed, it still passes.

Is the ask to also test, under kvm_has_gmem_attributes aka
gmem_in_place_conversion, to have guest_memfd used as purely for private
memory and have shared memory taken from somewhere else completely?

I can rephrase the changelog and change the code to clarify that this
patch is meant to specifically test in-place conversion with MMAP, the
intended usage of in-place conversions.

The ask to test gmem for private and something else for shared seems
like a different test that can be added separately, perhaps in a
follow-up series?

