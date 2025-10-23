Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 856F1CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 14:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77058E0040; Thu, 23 Oct 2025 10:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4E6E8E0002; Thu, 23 Oct 2025 10:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63D28E0040; Thu, 23 Oct 2025 10:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C41568E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:01:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 580955CAB6
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 14:01:19 +0000 (UTC)
X-FDA: 84029541078.21.5CAA74F
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5A69120015
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 14:01:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m09EZqzB;
	spf=pass (imf13.hostedemail.com: domain of 3KjX6aAsKCMsrt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3KjX6aAsKCMsrt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761228077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=inXfddpf6Feyogc8n8Jl5cqVWZOSr51ivnMHY9v0Ey4=;
	b=o0JsQC6uw+kCcX97SZ2tneWq0mfxTWH0NqJlxWvpu+5qGdVYH8/LdI1Odvt3nayx+O8Gqn
	+dGiGxD26rVJwWz+q5c1Jpv6nCoXL+L5tiACOFKZG4baH/iRsZz4p1zQkNCzaH2z8FuOcF
	o/YIoaS2ubtu1rApgfveJndlcyWiFxg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761228077; a=rsa-sha256;
	cv=none;
	b=PPvoagwbOUZEgCMUuuHeenQoi5sPNyct/5rguofvpcdo59kYnmt19bcIDSVQIt5GgDVWsA
	60H/8WTkGb11h5XgtC/6MWAceq0zaD7hheh5XTo4aX9XAerSS4HcTUyv1c36D0KL/8cwMP
	OlNeeKmQC2Nhz+AQQSHbA0y/VI3QPcM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m09EZqzB;
	spf=pass (imf13.hostedemail.com: domain of 3KjX6aAsKCMsrt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3KjX6aAsKCMsrt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b471737e673so1307588a12.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761228075; x=1761832875; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=inXfddpf6Feyogc8n8Jl5cqVWZOSr51ivnMHY9v0Ey4=;
        b=m09EZqzBTo1cCVozQgROlsORfU+bHUw4zDllXc3DcFgfLXzhxxzNIjojnJau+RoAEv
         tw/ZWj0PdkDO7GsYEZlxH0dqUCUxkpcZQrqOhp2uuHoCWWCrydtdQrV6LYecov6MLp7T
         dH8ViRUKYlNixkALCE2lG8fFF9qvhwvvCpmc1q6Jpl6KdfiRPkjMMJKkrVvIM+Su7ZjL
         7l06jyqwPILhobfxIdNpaBuRyK14JJWXvpM5HZ+MxkC6i1GlkFQ9jW90fP9QNjgQNr2g
         I/OmuNFRGl+6ucWjEMpBiRyiJgxs7ZWD/yd468VXxjlZV4GZ0ds6oY/aQuz9vkhF2ulX
         7TMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761228075; x=1761832875;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=inXfddpf6Feyogc8n8Jl5cqVWZOSr51ivnMHY9v0Ey4=;
        b=jpiSPLB/5kGbi9zrQLV4YUPYn/XtrQwEzWJij+G5ohZv3T/W/S7LX461HwpmEQzcJ7
         ik76Vfo9MVL3NGm8u5lWTncVuoxNvmnCtp/neWejM/xrKodAfYayGsZQRBgGV9oEwoK/
         FTi2DyBN6gsjNOdl6HjBPxyouCthUQfRt+rnUZhmDLa9WivQYp7gwIQXn8BWVdzbTY8Z
         X04U/f1eCPRmoBFhc7bwOA80BUhW9N0owh5tJ8GnIQjOE0P+t1SsSwY9pcgwF15MekBI
         zcQil5q6Rs75OW48idQ7xLZZQWEE8dKkG6P3rk0ORr5pTd+kWC2DB9JxJ5yqyLdoidMF
         6pxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUM1qVcE8Me25PpTFT/ghNnsxa4fiCDveQCxue+xTEpgI6Ei4GDU+W168OJpBg5j6WN0+gevHQTBA==@kvack.org
X-Gm-Message-State: AOJu0YyhC9lHB0txyzQtoNJqSFGgCwJZkbq5OdsOXm1pNsWN2+ptfa4l
	Ig0JqY/MJILnt09Ub/BObQOT0pJK5Lsp5OXQ23E7ECKX7xqmuMVkwg7h6QrQv+IFPFatVDdwsbg
	Bx9QQv3HKSfcMpFFRGuq2+jCvkg==
X-Google-Smtp-Source: AGHT+IFIN8uFRC6EtqcEGeMEkYd8inzutN6W/XJij2WhQjtYZx5ArSxhlm3XOqfP/3yjcqmWzVtyJ1fSE/ev6eLgRw==
X-Received: from pjnu4.prod.google.com ([2002:a17:90a:8904:b0:339:dc19:ae5d])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3956:b0:334:91ab:f182 with SMTP id adf61e73a8af0-334a85286f8mr35842433637.10.1761228074886;
 Thu, 23 Oct 2025 07:01:14 -0700 (PDT)
Date: Thu, 23 Oct 2025 07:01:13 -0700
In-Reply-To: <aPlpKbHGea90IebS@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
 <2457cb3b-5dde-4ca1-b75d-174b5daee28a@arm.com> <diqz4irqg9qy.fsf@google.com>
 <diqzy0p2eet3.fsf@google.com> <aPlpKbHGea90IebS@google.com>
Message-ID: <diqzv7k5emza.fsf@google.com>
Subject: Re: [RFC PATCH v1 07/37] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Steven Price <steven.price@arm.com>, cgroups@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org, 
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com, 
	keirf@google.com, kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, 
	shakeel.butt@linux.dev, shuah@kernel.org, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: fk9exn5rco53op9mqnuu4ctyw31dc1yz
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A69120015
X-HE-Tag: 1761228076-263065
X-HE-Meta: U2FsdGVkX19fcxVyp9Y6TdO3Uy13Byuzlghdeu/66S6C0Cpji/e3quJDvYN4c5+lyn6DnG4l2EoEouP0y6L6YX33ROwF1POZPF5dEFPe4dNYe4A6/JVgwHFp6VaNrOXnvMBp+UbwU8zAirC8TijxsU20VQjvVTG5NqHHLkTBXmvW2EgBvTj13bNhpS0dio5MLYxyEspn8mkAGxWudnOl6kkkejzbfy6pli6N6dLwfRqoDnHGlxa3BbQ24w4VcO+jP17hUOZQsTC01maL819ZlYqIS02Wyi5F9VfxRD8Ve0ES+6g7R3lWNEo4S8kl5/WnSWjakEfJSx97VYOi3Q1BAFd/M/sYomQp9fI4G5D4YquYzh7A8Hlk0PNSHLVolBMu00M8sPBQsIidEx415zo+dgnKoAMTuId+HoK7Evn6jmsif/v2AQEEtdxPW+mR7AuOpU2iawWXd2RBIZjqr78S5wH4kRuTaxLpgazpUZYLCD1N2z88BCwfYnOkzi5IN2OL657ZpajCU/be/Q9FsZTDZhq1YRLpThkGx1LCUuQReHWqroqE9u+5Oyg429a9uVS2tQHSm11uaPdQlj8umYFH70CAXFQaoc8kNf14l4k6MMTqwddPupZXx7jJM59NCe07iywrcUyCo/1jsn55stv5q5crUsjq8+sdRXXNZjM4swaid24bq97ck3RbTyFhaxhcKT2NpQH2OS5x1JGCt2u3fjanDhUUrrZu9eUFrq26d7gEHCpucZcr3KDxKv1zsB9fLVwVlNjS2dKvfMfLtIOQBNAi7Z9lpZZRnb1k0eWx+jAprF91F8/AqUh+dKFkdT929qTEZFV1Hb6omT7gzTurRg/d4pXBZPyoLDUcQioBVQWQcjBAmRMx9G2WCRSvd80hHqZ3RGRIQP+KdKJB8oKH2yDig5cLrAuTvwCbAviR5EHSCEJlGufU5t5aGMp57SBYl07dWzH13g70Xd3Yrl6
 CdzfiW1y
 I2K4Tg/DwhyFStB5GVk69xSkaQzR7kg7ENjUylByyps+x2HatigptfPtQZEOcDUkyYHMWs6ED8Oz8yJQJ1E2Po9C5Tzi9HEKCNqndiz5DoOVHlmf67XwwbKPH/EGFlIbPSu4ql5R1foNFi6wBKnV60gZCqmblw+gW5/ZTTEv6Tal3XqO0zstYsNK8S3xuwLcSi5iPMX7CxjBMAGb8vyfvJd9A2sXjLp7u1/1FQdPEjH0tDnNfVnHRWgRp15Qip+Tnx0jQS8LOu14/SJsDX4Cr8SqJRQz2cz/tZIMKPSNv3d9VPwe3wa3I3SXlr2s+y/Vop1UVqhMoRYOfODd21ZdjCB5FEg6Zfh+HrH5V7RURw3lxn1AEq4AVtf3i2rChvnK5dNiiRldbbaM3MzvjpJ8yZx4eh5VK9M+CJ/e+DmAxZvUsLXZRdHohn310ocAcp8A0IKqDwZ4IU2UA82smK23Tp+ZFwkTJhHM9gAU/DNlZjfYJqaLqHO482cd7xLfNwUbHH2SinIEYrmFPYAyXxVMXLm2Suyfkt22h4xZV/Q/F8otx5fGd6Agm73yP/cb79xrnwYV4Va5v/H2ZSs14qWbcP0BpJAnVtpD92wk16I1d4y03Li4GHJ9128bjXANhX5Zsyb4bQMQvxM0utcQka6AQezjpjYDL1f27s3w+Qp1CZYYgemLyRU1NnYCe5xtp74/uQXrVK3q+0ALScXVZIaGu71weRFXb1jR+nP6K+CXqOsAatwo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Oct 22, 2025, Ackerley Tng wrote:
>> Ackerley Tng <ackerleytng@google.com> writes:
>> 
>> Found another issue with KVM_CAP_MEMORY_ATTRIBUTES2.
>> 
>> KVM_CAP_MEMORY_ATTRIBUTES2 was defined to do the same thing as
>> KVM_CAP_MEMORY_ATTRIBUTES, but that's wrong since
>> KVM_CAP_MEMORY_ATTRIBUTES2 should indicate the presence of
>> KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2.
>
> No?  If no attributes are supported, whether or not KVM_SET_MEMORY_ATTRIBUTES2
> exists is largely irrelevant.

That's true.

> We can even provide the same -ENOTTY errno by
> checking that _any_ attributes are supported, i.e. so that doing
> KVM_SET_MEMORY_ATTRIBUTES2 on KVM without any support whatsoever fails in the
> same way that KVM with code support but no attributes fails.
>

IIUC KVM_SET_MEMORY_ATTRIBUTES doesn't fail with -ENOTTY now when there
are no valid attributes.

Even if there's no valid attributes (as in
kvm_supported_mem_attributes() returns 0), it's possible to call
KVM_SET_MEMORY_ATTRIBUTES with .attributes set to 0, which will be a
no-op, but will return 0.

I think this is kind of correct behavior since .attributes = 0 is
actually a valid expression for "I want this range to be shared", and
for a VM that doesn't support private memory, it's a valid expression.


The other way that there are "no attributes" would be if there are no
/VM/ attributes, in which case KVM_SET_MEMORY_ATTRIBUTES, sent to as a
vm ioctl, will return -ENOTTY.

> In other words, I don't see why it can't do both.  Even if we can't massage the
> right errno, I would much rather KVM_SET_MEMORY_ATTRIBUTES2 enumerate the set of

Did you mean KVM_CAP_MEMORY_ATTRIBUTES2 in the line above?

> supported attributes than simply '1'.  E.g. we have no plans to support
> KVM_SET_MEMORY_ATTRIBUTES on guest_memfd, and so returning simply '1' creates an
> unwanted and unnecessary dependency.
>

Okay I'll switch this back to what it was.

>> @@ -1617,4 +1618,15 @@ struct kvm_pre_fault_memory {
>>  	__u64 padding[5];
>>  };
>>  
>> +/* Available with KVM_CAP_MEMORY_ATTRIBUTES2 */
>> +#define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd6, struct kvm_memory_attributes2)
>
> Please use the same literal number, 0xd2, as
>
>   #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
>
> The "final" ioctl number that userspace sees incorporates the directionality and
> the size of the struct, i.e. KVM_SET_MEMORY_ATTRIBUTES and KVM_SET_MEMORY_ATTRIBUTES2
> are guaranteed to be distinct even if they both use 0xd2 as the "minor" number.
>

Will do.

>> +
>> +struct kvm_memory_attributes2 {
>> +	__u64 address;
>> +	__u64 size;
>> +	__u64 attributes;
>> +	__u64 flags;
>> +	__u64 reserved[4];
>
> Maybe be paranoid and reserve 12 u64s?

Will do.

