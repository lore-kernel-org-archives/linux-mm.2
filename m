Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30556CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 23:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7479B8E0014; Wed, 22 Oct 2025 19:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71EC28E000D; Wed, 22 Oct 2025 19:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C878E0014; Wed, 22 Oct 2025 19:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 56E938E000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:30:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 08E8548D04
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:30:55 +0000 (UTC)
X-FDA: 84027347670.09.F5198DE
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf02.hostedemail.com (Postfix) with ESMTP id B57E48000C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:30:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=o59tJVYl;
	spf=pass (imf02.hostedemail.com: domain of 3K2n5aAYKCDIgSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3K2n5aAYKCDIgSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761175852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jEiO6iBxzy6fxnsgwrsRYGtWZsrwu6A5X9ZJxUc05s=;
	b=1kBfElY3BjfIX7srOL8Rkl1/kHVYoZ3LaUz2k7y8oRjOSCHL3c7m6Z7hY42dOvQPtL++sg
	X60y7AEsIuDB0Wef+ut38FlfVerkq4NQtTJGOkg3DdXeDj0RU6Ut9LWZXaLrAWBXlRxkz5
	BT7rqgnb0rtI2ZkBJoK5oeUmrCCnBUg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=o59tJVYl;
	spf=pass (imf02.hostedemail.com: domain of 3K2n5aAYKCDIgSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3K2n5aAYKCDIgSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761175852; a=rsa-sha256;
	cv=none;
	b=AuST/FabIzmL0otStF4Nrk+qFLqAxK55qKtezcbmNqw4tg88Ao0VCs1GQb+RngUdDzOuQ0
	J6Dryy74V9yb8GIMTbsFZpWuurIaSDsiz0BZCLYskSXVuaCbdJf5qb5lhATR/A+/mP9YIK
	SnYszvGbPt11aPKUVZRx7+V4vJyeHBA=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6097ca315bso292848a12.3
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761175851; x=1761780651; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3jEiO6iBxzy6fxnsgwrsRYGtWZsrwu6A5X9ZJxUc05s=;
        b=o59tJVYlmth2ObleqmffeoSWumTX+HNCFLW3ncdFvXhw5Rxi1JwxuS3TE59KTND+mr
         NwGaefOvaD/RrZg51u0JLzkeHjRUvTseq/WB6P8B/mj+e2RbKa/GCqqmJznQqriKdgUQ
         XZuIVb2mpdWvZzutB4ZaezhAbSLlJyT+E7rdfe1uWt4jXc4O/c29Vc9qQd+dDmF8j8RA
         aGRZuXQz15Aqa4gayMNcGFekKgIIVZD7sMjgWPHH2hpftjjjzON7cnvPq3ZmF6F7Rq5q
         G2LBsrg3pIXjcy5W2gQYG1bqBO+HKJ9unRaD2fOjGMKwWfEMAsRWHfVeViAMhtxju9HQ
         +lfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761175851; x=1761780651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3jEiO6iBxzy6fxnsgwrsRYGtWZsrwu6A5X9ZJxUc05s=;
        b=t3b463rS+aPil5OmSXdqgxVKWEordqfjciG2pNTBgeQmkd1LmVDrFgwG8uHyFR0eyP
         jAc4LHv1TzBbUeLsWkoIwB/Lyo26N8FXIJ5wi2dm+xwG0JTNIigoljyBkzR83Vy4Liqs
         JacC8rLnjT+EqlDVmqDu+LnCDIrHTvnf180Qc2jm8/CGeGwutdkIw+JMcx6yObLDm/3L
         FnWu3RDvj9xjGBSw0pjUsWTXlOpinIaQEdkuDFL8C3tCBf+kT8b9FxEsQMu8Lu2Fyc+c
         X9HNb1WGH3vE5rL4lQ6e0QtMM89lxsrE++V6QiAMI9GSlgZE1D83FaUECIm/yclA5mj9
         sAiA==
X-Forwarded-Encrypted: i=1; AJvYcCVqroxgsH9LaRN4YrxCY0KEDR2vTCkWr5qgPUqflwcg14ZDx1dtnEIgI/JNlgtksrB2OwgClRXATw==@kvack.org
X-Gm-Message-State: AOJu0YxQ2vZSWq2OkCQvSYlsB413aqPI9vp1hReWAdfvKY8lZ7YOcz4t
	iHuf2a5pA59symwTblp/fA9VMaJRTG+u7JqWwCGNA540GvmNMrAmCCukcfwtee64Sb789NyrN3f
	oJPJ+Bg==
X-Google-Smtp-Source: AGHT+IFg265zLGl2bQmWCvkKPU4u2q3qfh913c9juw3tQPbolW7ChzJ4nSIfXk8wuAQ4jQwhmqRekZFnQlI=
X-Received: from pjnj13.prod.google.com ([2002:a17:90a:840d:b0:329:7261:93b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d84:b0:2f9:39b0:fd88
 with SMTP id adf61e73a8af0-334a84da4b1mr29081038637.21.1761175851395; Wed, 22
 Oct 2025 16:30:51 -0700 (PDT)
Date: Wed, 22 Oct 2025 16:30:49 -0700
In-Reply-To: <diqzy0p2eet3.fsf@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
 <2457cb3b-5dde-4ca1-b75d-174b5daee28a@arm.com> <diqz4irqg9qy.fsf@google.com> <diqzy0p2eet3.fsf@google.com>
Message-ID: <aPlpKbHGea90IebS@google.com>
Subject: Re: [RFC PATCH v1 07/37] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
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
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: pkeqmhxbg7h5rga5xwfs4rfwujou4f4k
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B57E48000C
X-HE-Tag: 1761175852-971090
X-HE-Meta: U2FsdGVkX1+GIo/l1S3YYNhd136ZOEWKOAMZ2XB8h/MtSDwkwXAEgYoB/VUpueJG5WLlsx2xj9dTEFNvWVKteLgjh5rYMqBoAQ+Ae0AWOM6CpgCutu9uHUku8QLlrxAn+GID2h+lmii8EO1HitNE+aGH+3aU7T6zD/I2IT7FIlLEp2M+73SG2O8939AccXxFBgFYWZ+6lHzUwWnkUk6MDySnEKEiy3GoOibaHXosFk+lmyoxvBdRbYU31yytCREY66wl0IQ6Sfxg4WFuE3qkPBi8oJeN+NV8QD/7/MTmlB5qKUV1sg5BWRWL3Oqx9pfYhVa5rVNVbvAeD2MC49qQhGqovdfC5D71FW2uKgtqppSQTdnppeoIQDC/yMPpfTyv6jNEPlzr0DmbX0cpX4lNT9FwKKQk16ZYTqqlq478H6sAmMBEu2s354VDNNDevFVjwpZAuFy5BJxZ15ss8192/RRP1MEM6l7K0WhDF+hfSFcrcOGcqcy1Sqqfv2rZLMW0Uo/PWx0iWp7C5UY/z15bHzgkbyT9yKc/GXgIwirOMiJqxNSb5oNxQE3Y18tOLYxgNAWrqNA+RZKVjmrljSBQEHQDHE+E62L1lkbR2GAYuwgcM8KRDWOlVrOqX6hWNWdJ+IzQnjX3idoX2q/WhgJMdYzxXun3F7NAjL1UD8HY4Al8pONZBb1y33jlCxDFA96rh3EFswfPd72g175RvA2Kjt9aokU8TYaCWuHZvGLt4qcrXSjQAxQkAiOjBKhRnoUzkyS5oSpndxYmTJa1isUWN09Rpj+ENivBof6ifNEIPl1fHLExUbJyjtF3bQmdn/GhhPmnYxq7y0Q+0HwYDOzH5Idq+JRxgSSbcgJI+30/ZGTf6yMQjOvNTDFrglPJfpEmszg3m8teaSB2F0rjsGGo3ZGNFUEBEKSJsnX0XfQ9U3jAh6xxqeAi/TiVP+0CRad5hvuurVtr2jrIsSdidlo
 VsyiPt3u
 gHyG0flHKIfmj577qJ2tvLUXCVWoZaNRl1WMN8p7YpkXONrz8QCp60wKlu+luYCiQ0+dx4wFu7qGAUhLmXe0T9yOHoSyBDj+d382xTCbjwdYenrbHpLtNPI5yhAVflzQc9kfaoJMn0ftW1hAYTWVBueB2lBLBFYnt8L/8U2hdJaDScDhQAd8zX4CZT1UnKJPkAjDegxkl5n9q7zcjQ+F1Mn+5s8PDaBsQLimYxv+Ds0meeSvPzEHzQldIo0Qd08n1A3pD/nd+ZCG1b5etVR3zNW3ci41K3vDsM+14h4YCND2x8uoOezdA1tqElBZ8ldyKnqxYNfcoextBCGXonbAf5zflDICYand/C6jhUlYdfvJtmG4gT/f6iQM3TMpeTfC86yO8k9whHYilpXO3dBJGsigMbTvde5rrDG1nPHdFHVT+DGpgSeXBYJDROdgmPP+Mdo9uQYXRYc1pLyw6efFEWBixcavxGjDc8P7fUbN6UYjNz7sJZarZOid/N6iO1QGLCimjE52KCndNKF9MwWhVOf3tC7+c1jtyPmjFpw/tJmLekHdbzuDE5L2ATJVwYx0WfP9JvpKn2our+QyNmza7tmSD1kCEtrr/9+2JfKuh8KCJuiD6Ze5e6FJpVHfG7WcCHse9mwIG+4nLTqNlZ9yMfJlwCLW9MRxEvQ7ldN0tn1SZwDr3FrhXSrFnLfHv8j6rp2YE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:
> 
> Found another issue with KVM_CAP_MEMORY_ATTRIBUTES2.
> 
> KVM_CAP_MEMORY_ATTRIBUTES2 was defined to do the same thing as
> KVM_CAP_MEMORY_ATTRIBUTES, but that's wrong since
> KVM_CAP_MEMORY_ATTRIBUTES2 should indicate the presence of
> KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2.

No?  If no attributes are supported, whether or not KVM_SET_MEMORY_ATTRIBUTES2
exists is largely irrelevant.  We can even provide the same -ENOTTY errno by
checking that _any_ attributes are supported, i.e. so that doing
KVM_SET_MEMORY_ATTRIBUTES2 on KVM without any support whatsoever fails in the
same way that KVM with code support but no attributes fails.

In other words, I don't see why it can't do both.  Even if we can't massage the
right errno, I would much rather KVM_SET_MEMORY_ATTRIBUTES2 enumerate the set of
supported attributes than simply '1'.  E.g. we have no plans to support
KVM_SET_MEMORY_ATTRIBUTES on guest_memfd, and so returning simply '1' creates an
unwanted and unnecessary dependency.

> @@ -1617,4 +1618,15 @@ struct kvm_pre_fault_memory {
>  	__u64 padding[5];
>  };
>  
> +/* Available with KVM_CAP_MEMORY_ATTRIBUTES2 */
> +#define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd6, struct kvm_memory_attributes2)

Please use the same literal number, 0xd2, as

  #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)

The "final" ioctl number that userspace sees incorporates the directionality and
the size of the struct, i.e. KVM_SET_MEMORY_ATTRIBUTES and KVM_SET_MEMORY_ATTRIBUTES2
are guaranteed to be distinct even if they both use 0xd2 as the "minor" number.

> +
> +struct kvm_memory_attributes2 {
> +	__u64 address;
> +	__u64 size;
> +	__u64 attributes;
> +	__u64 flags;
> +	__u64 reserved[4];

Maybe be paranoid and reserve 12 u64s?

