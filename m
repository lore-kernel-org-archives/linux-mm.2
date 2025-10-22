Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37EFBCCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 16:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596B78E0006; Wed, 22 Oct 2025 12:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56E9C8E0003; Wed, 22 Oct 2025 12:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 483DA8E0006; Wed, 22 Oct 2025 12:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37B578E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 12:51:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D73A4BB778
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:51:54 +0000 (UTC)
X-FDA: 84026342148.13.A4BA692
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1B94AC0006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:51:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="kU/K+aOZ";
	spf=pass (imf22.hostedemail.com: domain of 3pwv5aAsKCPASUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3pwv5aAsKCPASUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761151913; a=rsa-sha256;
	cv=none;
	b=G4V9KPvqpxUyfOQFmag1QXgTPIyVcul4v/M+gCgM3mZq9NzuUpkDeOZFDyyym0fE21930N
	Vuth6rDPpoDHf3iW+N7rB552NJJylUxxjh6vnQEUux/l9iOc6eXjZY2GfYKQSHPsqyzA+m
	46DMl/YpDYP0cwqi0T9Rc/qah1OxFYk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="kU/K+aOZ";
	spf=pass (imf22.hostedemail.com: domain of 3pwv5aAsKCPASUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3pwv5aAsKCPASUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761151913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lR6q3Jz4wEvNB1U/dBjL6AFCbuh1MpNj7/+QxukudLk=;
	b=6WoBaqjmrfkyPyo075aj7LASjA5qspo+ugvMS81kCy0apJSmAPM2Ru/w8qlUdk07Pr9Z4a
	xGin046GJ/IetAq2J0Zl6Aq1A0J82SshAhFoFbdSoN/OHHLzsRSa1htjbMSBTJpqnsvFH1
	1KVLjI98tR6y4DAYoc1xYFZnHHpzz6E=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3324538ceb0so12109612a91.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761151912; x=1761756712; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lR6q3Jz4wEvNB1U/dBjL6AFCbuh1MpNj7/+QxukudLk=;
        b=kU/K+aOZXZGoNL508v594UXwUmotArQapl7mypStH7DvDkzulOrJ8knydtDm/rX/1u
         +Zaz+y7o9OLsB8g4mzcXlO3E+8tFj4/NgPdiShydH4geo+1UKgD+Je1F0HxwkOOLq+gO
         KFSlMZJ79yrCpflEjWPXnAm1JPBA6VOXyevAucNdlyL84m4OJz6ZhIcjulPI6Lu0As6d
         peaiEmNlkFpy6KoE+6+mhNvVSXKS6zcSwH+Vif1TO9yf/VWF1tokvHiWQt7GJjAEFMMI
         sgTcLihlbTHpJ6p+pJeV0VE2D2CZ+ITCDbGyJ0Zjo0mA3R38RMdNXFMG4qjmmYswPhcq
         q6Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761151912; x=1761756712;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lR6q3Jz4wEvNB1U/dBjL6AFCbuh1MpNj7/+QxukudLk=;
        b=jXXuljLJjqb/3Rt73nj+2JIgn8VEfomlTnxIsNjnWY9VQxLl7BA7JlYQ7ZnywAvd5W
         yDFaavh6sEMFe/z9RSeOG38Iklsaliq1ZsfT+fN9SWokRV0rCvfgmBlvu4gpHFkY3JAz
         EvMIc9h+iumcEOklWBZR7xDQSarlCHEaTuFjCzFHnZVfVzDQVUtlJynicKivy3qihPM9
         kF6Y5L/OTd9LwfTxijOtiHOhSgtrnydEbhMcZi2kLUrRP/olH2dfvwH/Wm3VEEqACC0h
         mpCpc7W5+uACDVQXocdoEAX7hCYs+ewCbSTBUaYGvCNGjXvhdeXEivArU/DqpHZAxOqA
         yjcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLcglJi3vaOcxXcj81aDRSGMggTCfaOUxBXJuMufc9/eds9L9BRYctVV8G0GFK9xQ6vN7mF9eDRQ==@kvack.org
X-Gm-Message-State: AOJu0YyyESAFDldkTqzOJlPQBQPwCqaJyF9SGIy1JZKNknvoOW3ZqeMs
	z2876s1hLHAHtSeYiDE2lQK4tsu7bNeNwOIa6VHJFBwNiQfPzQWgFoX7aXUSPGQ6zThuG0UsRhW
	HXG1CgLvfeMDJfhnj+u0G5kcdjQ==
X-Google-Smtp-Source: AGHT+IGwxAeNTPtzLvu/Zk8STiamMAryG8fKxvXZatC28J4mfBlAiSQlIt+hBpVpayKRInn/obOZc8kpR+KnyIdqIw==
X-Received: from pjbiq12.prod.google.com ([2002:a17:90a:fb4c:b0:32b:ae4c:196c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2d8b:b0:32e:23fe:fa51 with SMTP id 98e67ed59e1d1-33bcf867404mr28930141a91.9.1761151911659;
 Wed, 22 Oct 2025 09:51:51 -0700 (PDT)
Date: Wed, 22 Oct 2025 09:51:49 -0700
In-Reply-To: <2457cb3b-5dde-4ca1-b75d-174b5daee28a@arm.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
 <2457cb3b-5dde-4ca1-b75d-174b5daee28a@arm.com>
Message-ID: <diqz4irqg9qy.fsf@google.com>
Subject: Re: [RFC PATCH v1 07/37] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
From: Ackerley Tng <ackerleytng@google.com>
To: Steven Price <steven.price@arm.com>, cgroups@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com, 
	mail@maciej.szmigiero.name, maobibo@loongson.cn, 
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org, 
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev, 
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	peterx@redhat.com, pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, 
	qperret@google.com, richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, rostedt@goodmis.org, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shakeel.butt@linux.dev, shuah@kernel.org, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: w49fdmsx7y8b9xmhcmrad69d983jfbkd
X-Rspamd-Queue-Id: 1B94AC0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1761151912-433273
X-HE-Meta: U2FsdGVkX19B+YIXlLnP4sDsoCjo+PuUqPVy+PbZRrDbfaHq7WPJJjAqai9LfE67hqcPhXjx6b/HctatKsEfpn2MQ5RW07PraRdND7vYpWxaXLg63ftZAkPWFfwSwkJ46CeEDvXGqTMcD/pOkwvnZDIx84hqYJ5zsZPf3WNyPcU/6B5v/Rcu2I2t8bHJyiz9Sb5wWX+LYmrsfTaBCtsaihP5OL/pkCsiwV68N3BhPPUusCXbaMx6grvOvyUimdOB4GWe7koXWo5lpUOWOaQXocIQcqNMy6oP9qd7eyRgWM4fGeBt+Y1aazxsgc+bihBJNQEW9lROwVfMKv9kSBk8urHVGOep0+uDlDUygqroyABpd7G43hwNWSXA03+ghQvkUCEC539Dg+LfqGzOpuXGo24MKWksC9+0U6T3GzoIVdDYvEFD5+pSChn6hkF1zShyf3+4Djpri0FA3RIJyrDsd03k88kCmHB/zOWrRPG1CVoTRwq+DV5VJlIS/X+1u0YcLOgKMq5j8A3RisIav1IkLuuivWeGm+Fq++skmM1LLbWYvq9MP/jHBRDFMlv1PZ7vARsTbtUecTiIXEmUsgLo9xqv0DEk4xB+ORypRELUBF3eA1shnLCpbXr+Vmos5ZzPvCwTtyJ7vMewOqoEu4kPo5RdRPCXvDaYr4YAEtG/nl5DwpmgyNIjmj7nQUV30Sp75xVC/IA0nQwtkS4j4mbJyo4vQm6cFomgukvrIQRL5mMHoYh2T8L6zDxnPUXVErzbGjOYCQ5W2n+lWwgS/21zeJ6DOs+t/LqXNG4EIdcRIstA7J8wyfg4m2+vTT+ZwbfY/zmx5DrlqvBAlTBGnmXXQNf8WP1nnLtzeQKc1lLNzsBB9Qh/p7DnMEkWqi7eGP3Re/RG99MbUswmmzVG1OzPMbqE+MbR5WdxTg1Ac/rrmCuh/FxYMMi1DB2vIPwUkjVpKKiw1hX7CWIQf6DnUGG
 0g7HHkav
 fiaenemyFFtOBB6hvwmxYjmU6FqlJ8HjraD0kI+FuaMjoAPBtUCa5/8RBzSRtq0Bk5QqtqwSafOO6RUIcFGG4aPx6wWc4+OCSgQpXEf093ivRFyTE3oqYS+Iw0lle9O7rFFuDkHuOWA4P/MHBx2J+RQQWXRr+X5GhM+sxbSq7/nA+D+X8sJeFuVg/qYW7gGPJklwJ/Xl/ycIA6vMdOYCrKM71/Gdq5mmEguLfK0We0pEzR91el6MA0lNSj3B44fpdDkHGzApnEbNSOSd9Orfp3Z4No36w+PMikcl+RSOqWDcB/FK8U8pEpRb/tvK9ZHv349h619FMPINUg6cUEHO6ogY4y2ps5hhPZqtCb9mjWvjb3BK977fTj4vQBAjRRz/VVu9EbnxMZTxhE8iSt1bt5aynZuCOneh/eghoFqPG+95Im5cQy6FhAUL8m4qVLml+ofvS5kvKI+U+dT1dmyF/huWWsmHzrIEACGUjaDcRz+V8nmPmbFONS4lBVrq5R+I3ICwNancJDgVNdVBrTkvQe6oBzGQAkBpbDs66uV3Bk8Bxz9lj/DPc7kbo6C2uGvfrS98MzQrxetEZEukthgqcwoG3b+UtCnejchh97GAvdNIb3oWJvYBD02prEiZjdtk7q5dFt48Vdm0dXmAvJe5jE0u6qcsGASWafXWagA89PmGNG97siwgXMypWBoYulxC+kkO/2jKV9C3lB0AZCWc1e9UD41cqZmW/0wpcHbNw3C3VrIbR8zoNpPp6bdEai9AQ5s/3tg2VA3RLE1BvbWoT+EM+aJPJyDtW1R/M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Steven Price <steven.price@arm.com> writes:

> On 17/10/2025 21:11, Ackerley Tng wrote:
>> 
>> [...snip...]
>> 
>> @@ -5366,15 +5375,35 @@ static long kvm_vm_ioctl(struct file *filp,
>>  	}
>>  #endif /* CONFIG_HAVE_KVM_IRQ_ROUTING */
>>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>> +	case KVM_SET_MEMORY_ATTRIBUTES2:
>>  	case KVM_SET_MEMORY_ATTRIBUTES: {
>> -		struct kvm_memory_attributes attrs;
>> +		struct kvm_memory_attributes2 attrs;
>> +		unsigned long size;
>> +
>> +		if (ioctl == KVM_SET_MEMORY_ATTRIBUTES) {
>> +			/*
>> +			 * Fields beyond struct kvm_userspace_memory_region shouldn't be
>> +			 * accessed, but avoid leaking kernel memory in case of a bug.
>> +			 */
>> +			memset(&mem, 0, sizeof(mem));
>
> s/mem/attrs/g
>
>> +			size = sizeof(struct kvm_set_memory_attributes);
>> +		} else {
>> +			size = sizeof(struct kvm_set_memory_attributes2);
>
> s/kvm_set_memory_attributes/kvm_memory_attributes/ (on both sizeof lines
> above and in the SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD macro).
>
>> +		}
>> +
>> +		/* Ensure the common parts of the two structs are identical. */
>> +		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(slot);
>> +		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(flags);
>> +		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(guest_phys_addr);
>> +		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(memory_size);
>> +		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(userspace_addr);
>
> The fields are:
>   * address
>   * size
>   * attributes
>   * flags
>
> The list you've got appears to match struct kvm_userspace_memory_region
> - copy/paste error?
>

Yes I did copy/paste this from KVM_SET_USER_MEMORY_REGION2.

Thanks for catching this! I missed out build-testing this with
CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

I've done that and here's a replacement patch.

> Thanks,
> Steve
>
>> 
>> [...snip...]
>> 

From 31283972574bde2ffa1960d30c80286f8467c594 Mon Sep 17 00:00:00 2001
From: Ackerley Tng <ackerleytng@google.com>
Date: Thu, 16 Oct 2025 11:48:01 -0700
Subject: [PATCH] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2

Introduce a "version 2" of KVM_SET_MEMORY_ATTRIBUTES to support returning
information back to userspace.

This new ioctl and structure will, in a later patch, be shared as a
guest_memfd ioctl, where the padding in the new kvm_memory_attributes2
structure will be for writing the response from the guest_memfd ioctl to
userspace.

A new ioctl is necessary for these reasons:

1. KVM_SET_MEMORY_ATTRIBUTES is currently a write-only ioctl and does not
   allow userspace to read fields. There's nothing in code (yet?) that
   validates this, but using _IOWR for consistency would be prudent.

2. KVM_SET_MEMORY_ATTRIBUTES, when used as a guest_memfd ioctl, will need
   an additional field to provide userspace with more error details.

Alternatively, a completely new ioctl could be defined, unrelated to
KVM_SET_MEMORY_ATTRIBUTES, but using the same ioctl number and struct for
the vm and guest_memfd ioctls streamlines the interface for userspace. In
addition, any memory attributes, implemented on the vm or guest_memfd
ioctl, can be easily shared with the other.

Suggested-by: Sean Christopherson <seanjc@google.com>
Change-Id: I50cd506d9a28bf68a90e659015603de579569bc1
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst | 32 ++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       | 12 ++++++++++++
 virt/kvm/kvm_main.c            | 34 +++++++++++++++++++++++++++++++---
 3 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 754b662a453c3..a812769d79bf6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6355,6 +6355,8 @@ S390:
 Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
 Returns -EINVAL if called on a protected VM.
 
+.. _KVM_SET_MEMORY_ATTRIBUTES:
+
 4.141 KVM_SET_MEMORY_ATTRIBUTES
 -------------------------------
 
@@ -6512,6 +6514,36 @@ the capability to be present.
 
 `flags` must currently be zero.
 
+4.144 KVM_SET_MEMORY_ATTRIBUTES2
+---------------------------------
+
+:Capability: KVM_CAP_MEMORY_ATTRIBUTES2
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_memory_attributes2 (in/out)
+:Returns: 0 on success, <0 on error
+
+KVM_SET_MEMORY_ATTRIBUTES2 is an extension to
+KVM_SET_MEMORY_ATTRIBUTES that supports returning (writing) values to
+userspace.  The original (pre-extension) fields are shared with
+KVM_SET_MEMORY_ATTRIBUTES identically.
+
+Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
+
+::
+
+  struct kvm_memory_attributes2 {
+	__u64 address;
+	__u64 size;
+	__u64 attributes;
+	__u64 flags;
+	__u64 reserved[4];
+  };
+
+  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
+
+See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
+
 
 .. _kvm_run:
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52f6000ab0208..c300e38c7c9cd 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -963,6 +963,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
+#define KVM_CAP_MEMORY_ATTRIBUTES2 245
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1617,4 +1618,15 @@ struct kvm_pre_fault_memory {
 	__u64 padding[5];
 };
 
+/* Available with KVM_CAP_MEMORY_ATTRIBUTES2 */
+#define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd6, struct kvm_memory_attributes2)
+
+struct kvm_memory_attributes2 {
+	__u64 address;
+	__u64 size;
+	__u64 attributes;
+	__u64 flags;
+	__u64 reserved[4];
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 35166754a22b4..95aa51b334a70 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2621,7 +2621,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	return r;
 }
 static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
-					   struct kvm_memory_attributes *attrs)
+					   struct kvm_memory_attributes2 *attrs)
 {
 	gfn_t start, end;
 
@@ -4959,6 +4959,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_DEVICE_CTRL:
 		return 1;
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+	case KVM_CAP_MEMORY_ATTRIBUTES2:
 	case KVM_CAP_MEMORY_ATTRIBUTES:
 		if (!vm_memory_attributes)
 			return 0;
@@ -5184,6 +5185,14 @@ do {										\
 		     sizeof_field(struct kvm_userspace_memory_region2, field));	\
 } while (0)
 
+#define SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(field)				\
+do {										\
+	BUILD_BUG_ON(offsetof(struct kvm_memory_attributes, field) !=		\
+		     offsetof(struct kvm_memory_attributes2, field));		\
+	BUILD_BUG_ON(sizeof_field(struct kvm_memory_attributes, field) !=	\
+		     sizeof_field(struct kvm_memory_attributes2, field));	\
+} while (0)
+
 static long kvm_vm_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -5366,15 +5375,34 @@ static long kvm_vm_ioctl(struct file *filp,
 	}
 #endif /* CONFIG_HAVE_KVM_IRQ_ROUTING */
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+	case KVM_SET_MEMORY_ATTRIBUTES2:
 	case KVM_SET_MEMORY_ATTRIBUTES: {
-		struct kvm_memory_attributes attrs;
+		struct kvm_memory_attributes2 attrs;
+		unsigned long size;
+
+		if (ioctl == KVM_SET_MEMORY_ATTRIBUTES) {
+			/*
+			 * Fields beyond struct kvm_userspace_memory_region shouldn't be
+			 * accessed, but avoid leaking kernel memory in case of a bug.
+			 */
+			memset(&attrs, 0, sizeof(attrs));
+			size = sizeof(struct kvm_memory_attributes);
+		} else {
+			size = sizeof(struct kvm_memory_attributes2);
+		}
+
+		/* Ensure the common parts of the two structs are identical. */
+		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(address);
+		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(size);
+		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(attributes);
+		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(flags);
 
 		r = -ENOTTY;
 		if (!vm_memory_attributes)
 			goto out;
 
 		r = -EFAULT;
-		if (copy_from_user(&attrs, argp, sizeof(attrs)))
+		if (copy_from_user(&attrs, argp, size))
 			goto out;
 
 		r = kvm_vm_ioctl_set_mem_attributes(kvm, &attrs);
-- 
2.51.0.915.g61a8936c21-goog


