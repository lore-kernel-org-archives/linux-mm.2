Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC5A6CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D308E00A7; Fri, 24 Oct 2025 10:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E59F8E0042; Fri, 24 Oct 2025 10:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3D908E00A7; Fri, 24 Oct 2025 10:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DBAB48E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:36:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AAD24C0EFE
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:36:56 +0000 (UTC)
X-FDA: 84033259632.29.2DBFA3C
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7D30A0006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:36:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VmpUcztg;
	spf=pass (imf25.hostedemail.com: domain of 3BY_7aAsKCGA8AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3BY_7aAsKCGA8AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761316614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gWpJOPikpazVbpXRSUPMCcvrbTBk5c7sNdJD5ZAL5c=;
	b=6Ft1dx8iB658lXHnydsmPkaDEt2qmB19OACQJWuhyNBHwv2ngXCxvbA8hCWE8NDMN+PZEv
	6uIyNGhazapDfpzKdF3qtQ+UqLUdJsftWLeuX2PV4UrukYmRc0e+RYZD0QKiCiBJmcl1g2
	HIgRg7EKp//cNEL1rWpKKn2p8vygA3Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761316614; a=rsa-sha256;
	cv=none;
	b=vBZJd2wtl3LjTGMtp/R+KOMNXaqDnHiMg3ZE2a9iGoq7/tKt18IDW2Xu5d4guwIYA27kgQ
	lvOdGAS6/9eNYM+zq+BCYSoqIeZOr+0dJbr1PO7SAil1XchLb+OvVvSRnwFFh3SqUc09wP
	rQvrFMw8qdh5I/nLg4a3zHmkzwR1b4U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VmpUcztg;
	spf=pass (imf25.hostedemail.com: domain of 3BY_7aAsKCGA8AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3BY_7aAsKCGA8AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-290cd61855eso19672885ad.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761316614; x=1761921414; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8gWpJOPikpazVbpXRSUPMCcvrbTBk5c7sNdJD5ZAL5c=;
        b=VmpUcztgHiByrCaDhCUjBfvEVIdsghEfVuqicTjliZXUG0Yu8sKpHQlSAaRB+XLP4F
         6wFtxQUBlgeaiO5RLvMTcGODyCrxS16Iu6rZ8QSkmWvsBinllS/K2g08qHbYWOFyEpqN
         fta3lPxJ+vT1NhF/Qmli9ss2ItMUC3ARME+pilmxje9uEbRcKGE2F7aDZYF5saau/Nml
         aPHKd98aleGWWrD45ysOoilKactUBJ1OFTUEIo+53DDZD2e3Fz6jgOMVuSFv9g+DZWIa
         vqfuxF0EroZW8z/Z+FAWg60nl6Et4YfaIShT7gxdVk7pz/q06ELzsBWbX4vVVGyheTSs
         o40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761316614; x=1761921414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8gWpJOPikpazVbpXRSUPMCcvrbTBk5c7sNdJD5ZAL5c=;
        b=jqbsLXZ75Wis+VY/rCJ5CO6k9rULSyhBqUIX3wyJjmWz4sCWzouPlHLLaTSWyOpGPC
         NZraPmHyo52D4HDi6/bvj/1K5imyZ/C/A4M8JzMWrODa0Ju2yC0zKLUWOyKVo/D/ImBU
         pZDFmR/j8eSCXDhcztGF5T2V7bOOmNZCV8vsMnbQjzmJRJae9xNiaW57PzLT5w1KMIBU
         eUHmOkUx0jDuUJ1Tbs/Qqv5/4cwWlYpmz20D6+7RC6vo8FELx3YNRUx4pldLEui/h6Li
         DdPhGABaDIjrlOKP/EHsATA0FAUUZdARb2HgBvUINoYBp/98E5qnPvc78KZsACfFmMOs
         OM2w==
X-Forwarded-Encrypted: i=1; AJvYcCWA78e9a/Vm2lZJFs0ecegX3zBErR4Dn0kr1lnSb4XCL6jRaJaISlwgQcw8NiRud+AqYsl9xVnB6w==@kvack.org
X-Gm-Message-State: AOJu0YxLtGUdGGtb3H7XMALEH02hWjf28O4VGtzPjPeYVtd5XbDgtOQx
	mcR1ttXZGdsbhrphZzrGU07rwp4a0CEF8u/U4mc3gbA23DfbXi7oW08UPyEAmD2W3QeRN32lph/
	/lvl2UtlX/8x1dW4weqiCIlc+wQ==
X-Google-Smtp-Source: AGHT+IHpZZ9f9FI2oIDKJuatT8tIt0u+E9sskkPVtdG8cewdd4WM+aJNDiUGBZhPHxdPQPN/WAuNAtpnF8qjPR3V7w==
X-Received: from plcq12.prod.google.com ([2002:a17:902:e30c:b0:290:28e2:ce4e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f68c:b0:290:91d2:9304 with SMTP id d9443c01a7336-290c9c8a770mr324316695ad.4.1761316613376;
 Fri, 24 Oct 2025 07:36:53 -0700 (PDT)
Date: Fri, 24 Oct 2025 07:36:51 -0700
In-Reply-To: <aPpEPZ4YfrRHIkal@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
 <2457cb3b-5dde-4ca1-b75d-174b5daee28a@arm.com> <diqz4irqg9qy.fsf@google.com>
 <diqzy0p2eet3.fsf@google.com> <aPlpKbHGea90IebS@google.com>
 <diqzv7k5emza.fsf@google.com> <aPpEPZ4YfrRHIkal@google.com>
Message-ID: <diqzqzuse58c.fsf@google.com>
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
X-Stat-Signature: nirx7m6xy71ojpfxyzuhhn4in8fkwnbk
X-Rspam-User: 
X-Rspamd-Queue-Id: D7D30A0006
X-HE-Tag: 1761316614-284657
X-HE-Meta: U2FsdGVkX1/FIiRgCRRL6q+MQYMlA8rPZEpYYeB1CeEOCcG2CiT5+aY5B602kV8q6XJh761Vu1XhBUN8uptGZ+prpzqW3MRQiwehTsUMIUdlCeizDdsf7ABky8FptLn/bmT/NCEOoLdaoC5Tol0EgQYRWublGJY+5Q0vTQKJ9+eeMpK+tqIboUJJD1coKG2JtJPBV1HioK00FHuP6P1ONTC6s4xLP6LK/XnvxsgwKq8rSKXVEvSjlo81/42YqOF3i7jGWcDHiaUCMdHNctmczRoL1qDoqKQSpF4RFG+2xNp9ZMUIQNRzQWAgThZ9DkJj4G1Bp0WMvBe8P6nnZjOJf9ReIX1P/8bkxci5ftxGMqFeXGyaip5S4zBDlGUl4pVdodQo88ygKakQ6c3JspDl+oX1eq9aG86CUZSQFi6r59Y0/yJKOPKJTG5XKTB9/dqH8AS4a+qcOhEWo9At7ebk5O905En95l3+LJjZDg0798SSkLcL7YdgzcpqZIEGp+1AQvIMaBelfEZTPb+iSEqcFmJrRQ3XFEXLT96xM7WqAD5W7HKE9dwZaWR3tHSjpS76snYYokPqTlzOyyv9yPJby65vT6m34LOxtEdlN9RrUp54UXM2dyF80wKZZL3Pn4SWPJrv3SCMpudM1YAMg3Z8BbYzvUnpKPILfNBQPc8AMZlQoYKMCWxwEhyKfmzh7odaQ9VA8pjTeL73EUlRzsQ9iisCtRA8Gd8CiSCKlOH2bySy1N6MFaTEX+WvZ2kAJE0QNjqmqz4nBp1F50H5kLCokPvhf3In4L0g5bnkFYfivShy9jHGJsFPKaJCyqH0jR2GEhjnR5WtzZV4a3fgYNOjrSpSE4R/lASmXYBKqXnpTJATbfZ6MRQC6omt5tvEQTycPP9CxHIkTkSaN1g76ZZl0CztL+ASkErNbtilEvx9sKAjvtht7OxBAOPlstT+q2Vvth/bR7e4yp28ZMoyYxf
 z/IY2hPz
 CH6R4HyJ1nP4QuIAyLtJT5MwVSmnHG05z0M8JWU7axoA+4rvIOjRgZ1+58mygq7HnjL3MPadd6wTkBQgVZHl2ppQS5GTnmOAxbjFj+hyBUIgif/QCSmXj+J1GYbvEdpPRmLtgsvqdqUlX2t83L++x0cKjWGGUjBWe3gnsWlCeoyNV5IqXXZUBIh26lF3UCX5tkINwll0qR3Pyj4ogTeEFGnlE7xgHrVh/Zf1Ew2zLKa/D9N37xbJVIE2ZlWhXJUkTf0eqpjAvt6IeEyyNysJAOoTKSsAgf5CkMO294IhLvhg/H9kpFD9UKwpUoLGICZ7r/USJUJ9Dd3xdDpHXxzKj+7eedpJWVRwmVqOoUC8UBcdyCYee+st29ETTprn4BaKG5phhb4bYDYNXZfElk1LU7r3VGE1f0Q4KfJwYtiNi0+7bffXpxEqSSgz+34f5pWxJLFz4MtXVNY/+i8II9OG135Xk6Fg4bYUfIi17bhzdsiNvsoKpcwRpMhitRJ1bVzre9gDJP/JxlWSOGYjuyV0Y+2n/4fK+bGUxHaq1yYK7HjxbiT8IAiZ4ZPXq2ReAziPBeVjZ7ZKuDDPk92uXgdHa2K1IqclZXSZCQV0FmQkuzBzQkbOdHNeWbF2oNmq+qDhO8nG+6yAod2z/owXdbttQ+ex5+Qm9JpffSgCza7o2q3XdMaC2VJdpaFm5gfKcWZDVeA4a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Oct 23, 2025, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > On Wed, Oct 22, 2025, Ackerley Tng wrote:
>> >> Ackerley Tng <ackerleytng@google.com> writes:
>> >> 
>> >> Found another issue with KVM_CAP_MEMORY_ATTRIBUTES2.
>> >> 
>> >> KVM_CAP_MEMORY_ATTRIBUTES2 was defined to do the same thing as
>> >> KVM_CAP_MEMORY_ATTRIBUTES, but that's wrong since
>> >> KVM_CAP_MEMORY_ATTRIBUTES2 should indicate the presence of
>> >> KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2.
>> >
>> > No?  If no attributes are supported, whether or not KVM_SET_MEMORY_ATTRIBUTES2
>> > exists is largely irrelevant.
>> 
>> That's true.
>> 
>> > We can even provide the same -ENOTTY errno by
>> > checking that _any_ attributes are supported, i.e. so that doing
>> > KVM_SET_MEMORY_ATTRIBUTES2 on KVM without any support whatsoever fails in the
>> > same way that KVM with code support but no attributes fails.
>> 
>> IIUC KVM_SET_MEMORY_ATTRIBUTES doesn't fail with -ENOTTY now when there
>> are no valid attributes.
>> 
>> Even if there's no valid attributes (as in
>> kvm_supported_mem_attributes() returns 0), it's possible to call
>> KVM_SET_MEMORY_ATTRIBUTES with .attributes set to 0, which will be a
>> no-op, but will return 0.
>> 
>> I think this is kind of correct behavior since .attributes = 0 is
>> actually a valid expression for "I want this range to be shared", and
>> for a VM that doesn't support private memory, it's a valid expression.
>> 
>> 
>> The other way that there are "no attributes" would be if there are no
>> /VM/ attributes, in which case KVM_SET_MEMORY_ATTRIBUTES, sent to as a
>> vm ioctl, will return -ENOTTY.
>
> Ya, this is what I was trying to say with "_any_ attributes are supported".  I.e.
> by "any" I meant "any attributes in KVM for VMs vs. gmems", not "any attributes
> for this specific VM/gmem instance".
>
>> 
>> [...snip...]
>> 

I've been thinking more about this:

  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
  	case KVM_CAP_MEMORY_ATTRIBUTES2:
  	case KVM_CAP_MEMORY_ATTRIBUTES:
  		if (!vm_memory_attributes)
  			return 0;
  
  		return kvm_supported_mem_attributes(kvm);
  #endif

And the purpose of adding KVM_CAP_MEMORY_ATTRIBUTES2 is that
KVM_CAP_MEMORY_ATTRIBUTES2 tells userspace that
KVM_SET_MEMORY_ATTRIBUTES2 is available iff there are valid
attributes.

(So there's still a purpose)

Without valid attributes, userspace can't tell if it should use
KVM_SET_MEMORY_ATTRIBUTES or the 2 version.

I also added KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES, which tells
userspace the valid attributes when calling KVM_SET_MEMORY_ATTRIBUTES2
on a guest_memfd:

  #ifdef CONFIG_KVM_GUEST_MEMFD
  	case KVM_CAP_GUEST_MEMFD:
  		return 1;
  	case KVM_CAP_GUEST_MEMFD_FLAGS:
  		return kvm_gmem_get_supported_flags(kvm);
  	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
  		if (vm_memory_attributes)
  			return 0;
  
  		return kvm_supported_mem_attributes(kvm);
  #endif
  
So to set memory attributes, userspace should

  if (kvm_check_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES) > 0)
	use KVM_SET_MEMORY_ATTRIBUTES2 with guest_memfd
  else if (kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES2) > 0)
        use KVM_SET_MEMORY_ATTRIBUTES2 with VM fd
  else if (kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES) > 0)
	use KVM_SET_MEMORY_ATTRIBUTES with VM fd
  else
	can't set memory attributes

Something like that?


In selftests there's this, when KVM_SET_USER_MEMORY_REGION2 was
introduced:

  #define TEST_REQUIRE_SET_USER_MEMORY_REGION2()			\
	__TEST_REQUIRE(kvm_has_cap(KVM_CAP_USER_MEMORY2),	\
		       "KVM selftests now require KVM_SET_USER_MEMORY_REGION2 (introduced in v6.8)")

But looks like there's no direct equivalent for the introduction of
KVM_SET_MEMORY_ATTRIBUTES2?

The closest would be to add a TEST_REQUIRE_VALID_ATTRIBUTES() which
checks KVM_CAP_MEMORY_ATTRIBUTES2 or
KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES before making the vm or
guest_memfd ioctl respsectively.

