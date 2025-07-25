Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A49AC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 14:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BB796B0088; Fri, 25 Jul 2025 10:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 293F76B008A; Fri, 25 Jul 2025 10:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8DB6B008C; Fri, 25 Jul 2025 10:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AD706B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:31:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A69E31315D7
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:31:22 +0000 (UTC)
X-FDA: 83703024804.22.9AD4528
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id DB25B10000F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:31:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=24KabsXb;
	spf=pass (imf05.hostedemail.com: domain of 3N5WDaAYKCLoxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3N5WDaAYKCLoxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753453880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sC0769Xg1heGZH8J90EpA5X6mZA0yrvARhBoCeDTa5Y=;
	b=O/qYmr0gVLemrcQIy/HhOKj7Y9qLpi/F4fxKp+F20OOaBnGnU+JzpYWmDKbZwaHi60ays0
	vbZafXq+u3SehGSUohwDl6nOQRzsANx7AHOp/36+KCy16mzn5O0pMIZEGOeScpn4jb9G1h
	nv/dlBSz72mqlr4BrYQSplc6Y9Aoy8U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=24KabsXb;
	spf=pass (imf05.hostedemail.com: domain of 3N5WDaAYKCLoxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3N5WDaAYKCLoxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753453880; a=rsa-sha256;
	cv=none;
	b=XQQ6gP5EoOuXGijz+DYF7F0VLpjbzEsUYMkaa1/BOyQrGwIOHsx0GmBRA7x1JkK7TLXND1
	Dwb6726+ZnPgtjtIetoUFeEt9d5nKuO97rib0P6JVqN9jgH1V8mlNAicYFQbEqT+ll3QG8
	0S6PpuzVYXPLgqHZo1ui3WIczm7v53Q=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31ff607527so1886811a12.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753453879; x=1754058679; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sC0769Xg1heGZH8J90EpA5X6mZA0yrvARhBoCeDTa5Y=;
        b=24KabsXbJVwxzXRsQ2PlB2cbHJRUg10rVa5nv8K2NhkqEKZrkkY/xrHJ4v8aobC99Z
         IUt4Id4OHJzWTkNU5aGY2xDQSbWpwQwkRaHOmH5U06S0Qk2AmdK8B7gsVR08iTTY/+Pn
         XdRkHWMpywK33jn8LCNWuRqP6nyOHVCd6mxgzvoljJQ6XDgGREbOWvx7jvUbyQ8l6meF
         /H/cGpU0y0AlnJCqJPi2JYO84Re7T1F3XD+X/tudCOMgV1l/g9FWsvJfqKYZ1Chb/JL6
         i/t/srhMkwyt2M56BZY465F1gSGTyiN6gV3dfb1iu2BTUJdrN4Izrg/hS/vaYGfNowJD
         3Uzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753453880; x=1754058680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sC0769Xg1heGZH8J90EpA5X6mZA0yrvARhBoCeDTa5Y=;
        b=l1SXz7+qTFpN20jSTVyK1Z/m8sasH8Ymm5k9oCynSt2Dn2SmwCP6AlHtC5IypnB8Lt
         2AIX/RBH9aSXrv92TdT5iVKqg4BzwSTT07zGNwKqYtnApvFf3ET/yJ9O4NLib1BeOFei
         Srm+fIJpJUrF37sy8MZAS/UVHAWAvkmceC1jllf2EVRXUcgpqCpmJeFBLcSS9A03ww++
         d9Oy2nZw/JOQTL4aFRxF9ipsvklVydgorQJlN2uu5FJCll3Jgrc51u5shwKECTk46qN/
         XQuc3neDUGKna0b32hE2GGDRRBVkd0f7g6QEkgO5cBxQAsyRsQKIFbquAjtYgccZ+4cz
         MZ5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXuTsxFcJcysqEIzBG6GTeCUevGLqd3usDSNAlnChIVNvmwQc3k0sPlEDqWQOxHPJhgciKUXYfgSg==@kvack.org
X-Gm-Message-State: AOJu0Ywpv8JOx4nXHotrpS5JkVIKGL7UrHHgKLcwTcIsxbZhXTiJ/VKa
	m/fEdabh97V1cIDDylEnOwCjCVjoTkgWfGEY/O517BtItjl+us0GAeSCbQkqYQjTwEjHMRanhf9
	Jspx2ng==
X-Google-Smtp-Source: AGHT+IE8bQ5HIcB35TZztW6FFUKXkhZH35KfVngtYR8izSfmiidEbwmwtOeAPOCK2rACB2xK1aj7frwF+1I=
X-Received: from pjbnr22.prod.google.com ([2002:a17:90b:2416:b0:31e:780c:e3d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:554d:b0:31e:3848:c9ee
 with SMTP id 98e67ed59e1d1-31e77a2f69emr3502891a91.9.1753453879518; Fri, 25
 Jul 2025 07:31:19 -0700 (PDT)
Date: Fri, 25 Jul 2025 07:31:17 -0700
In-Reply-To: <diqz7bzxduyv.fsf@ackerleytng-ctop.c.googlers.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-15-tabba@google.com>
 <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com> <aIK0ZcTJC96XNPvj@google.com>
 <diqzcy9pdvkk.fsf@ackerleytng-ctop.c.googlers.com> <diqz7bzxduyv.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIOVNcp7p2hU-YHM@google.com>
Subject: Re: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: an7yqibniqwfnuq99hej6eq47mnpw9cj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DB25B10000F
X-Rspam-User: 
X-HE-Tag: 1753453880-702149
X-HE-Meta: U2FsdGVkX1/Ukcyxi9ByEo19db6QnN8ynxvV3p75FbV2V+Jyf2PmnfIax25n8G1ASRsdY0HBkfFfeJ8n1LgLGq3+HDKLtuYIMcVAn6bYld1xG0Huhq71MCEN9aqpsAcyoWXEe/ufRJsCpxsnumGA8cuZEdzfIog6Xxp/4eBFupvbG54CjrvH1I7EmqZXEcDhP3bt6V2CyLoFfYHGXO/EuSIRCDJrwDBep5qmMAjJsxpWY4ECkw3fMBKYdODV1Pnktn+8i3sL4lt8YKrobsJTdFxxECo+t6vPa45shrBbcHw32qAFINbZYnpOqeDIpyqIwPXglhIwZGQ0VDOXVqbQY3TCmKlkxSQHTx+3E/B3UGUoQp9bPuOaOfJ0Ln0uh51JSA/Xw4ALnsrmLiDlMNdg4ZGYvHUiO5+l1Am8Ijk5JY8KcJLzBW1nuhMyY/HfchwPiKBDRG1kg3UqnyRCOi1DtRgThKN0qq1XGAJNWET91paYwD/bqwZnrt2eQTwiMoYjh0dhVe3RbhQk+PeBT2ICRl4WRaTwenObqLvEaz20kl1t5VE3K7PysSlrEJ676u+UICTOng0bAD/ZQ6MF0+vsMmb/d3PixIqbyW/c5gdG3zy1OKYJvwSyEhmUpgoP1aE5UrPMfcbJOcR4xzdCXr007Wozf2TvXnQSgevrVdz8YtEPiE+dwDHw1mMFJ2jFVYj8O6RXZUlmmPk3YTFpH38Idka8Swg8pn6KrHaS/hNTllq5EPUwjg1+n81XUwAy1VXtEkT6kfPMzCmuRWQEoA0puY78gIKmAT+NCp16mXnyM6yLYsIhdm6DifYEBq8wbmpQ1VTLwYDJP1VB6/E/INE4JQAt7n7vhLKF9rdd4E8KKPlU3JJUIGT+NjsAvpy6DYCL0DvxfZa2pMpSlbAxy0AJms28kVk6IIvZ4wFd84lxAnCDwwzRpExC/3x4iHd2CQQ/ag/zueBs4qm9BFbJCcA
 P6Dz0UJK
 nWAyybBrpSfasPtM8G0AQkTMa/To7NtE4dXuRrn6KSb5Bc6sFurWBKWrKkEYLgz2uoiDff5YIJtLc6jvrZAIzNTiH9G4IHBHQvFo5WjtmgPZ6C6+XocTRhHkAaFp7FbOBx6/WIzSndHICl99aHS0F/uUFfwEdt0BrunATZcLWEZAXzCtTtGQA2enfZJ7lq5j+ncNBht0eNN0V0fDoHKwGr1p0OmZaYCc+/4+97xCZe6LcnphmZWoIfFVrjVxJBuhz522KfsywmsuMqLPNuHTO3Za0yVejbG8B+Ak+gQgRcrz9+Sh/3WnYpKdQmzKTRddUb44Z9AFKIt249mfcieuq/6EXzXLvf0dPxjDhemvIGXa86+jKAUYtOOvqH3P5yO1x9kNdLIK4FS2USBe1gYMHdnd6Oq50wUJqdiXJdbyzaVd8/UpipxYJSAAMDdgODblEIB7Wn2TLOLm3rxGiYSJlMqdeqOkQ5sPXhKxjw4jl19Q1Ws7SoOtnRRvSlxsLRs/jqbSwpjLJ77mEduuSxqelAP4uhtMKgXyd+PIURC9NcEUp+qyFnABPin57HuhUvokIS/pFpWbBd4ltgSHrkeHLAljL0p1OQC8edrE4cF7i1KJjAivIKvHE7OwTKCKCaWqdLhuodg4+XIhBOcFRD08gnix9YslV+sZLWFMDUC+ei5flpVQGHqhRsNRzAhcKqg2t25fd119vI51LsLByMR0G1ht0PQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:
> 
> > Sean Christopherson <seanjc@google.com> writes:
> >> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >> index 20dd9f64156e..c4ff8b4028df 100644
> >> --- a/arch/x86/kvm/mmu/mmu.c
> >> +++ b/arch/x86/kvm/mmu/mmu.c
> >> @@ -3302,31 +3302,63 @@ static u8 kvm_max_level_for_order(int order)
> >>  	return PG_LEVEL_4K;
> >>  }
> >>  
> >> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> >> -					u8 max_level, int gmem_order)
> >> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> >> +					const struct kvm_memory_slot *slot, gfn_t gfn)
> >
> > Would you consider renaming this kvm_max_gmem_mapping_level()? Or
> > something that doesn't limit the use of this function to private memory?

Heh, see the next patch, which does exactly that and is appropriately titled
"KVM: x86/mmu: Extend guest_memfd's max mapping level to shared mappings".

> >> -	u8 req_max_level;
> >> +	u8 max_level, coco_level;
> >> +	struct page *page;
> >> +	kvm_pfn_t pfn;
> >>  
> >> -	if (max_level == PG_LEVEL_4K)
> >> -		return PG_LEVEL_4K;
> >> +	/* For faults, use the gmem information that was resolved earlier. */
> >> +	if (fault) {
> >> +		pfn = fault->pfn;
> >> +		max_level = fault->max_level;
> >> +	} else {
> >> +		/* TODO: Constify the guest_memfd chain. */
> >> +		struct kvm_memory_slot *__slot = (struct kvm_memory_slot *)slot;
> >> +		int max_order, r;
> >> +
> >> +		r = kvm_gmem_get_pfn(kvm, __slot, gfn, &pfn, &page, &max_order);
> >> +		if (r)
> >> +			return PG_LEVEL_4K;
> >> +
> >> +		if (page)
> >> +			put_page(page);
> >
> > When I was working on this, I added a kvm_gmem_mapping_order() [1] where
> > guest_memfd could return the order that this gfn would be allocated at
> > without actually doing the allocation. Is it okay that an
> > allocation may be performed here?

No, it's not.  From a guest_memfd semantics perspective, it'd be ok.  But allocating
can block, and mmu_lock is held here.

I routed this through kvm_gmem_get_pfn(), because for this code to do the right
thing, KVM needs to the PFN.  That could be plumbed in from the existing SPTE, but
I don't love the idea of potentially mixing the gmem order for pfn X with pfn Y
from the SPTE, e.g. if the gmem backing has changed and an invalidation  is pending.

KVM kinda sorta has such races with non-gmem memory, but for non-gmem KVM will never
fully consume a "bad" PFN, whereas for this path, KVM could (at least in theory)
immediately consume the pfn via an RMP lookup.  Which is probably fine?  but I
don't love it.

I assume getting the order will basically get the page/pfn as well, so plumbing
in the pfn from the SPTE, *knowing* that it could be stale, feels all kinds of
wrong.

I also don't want to effectively speculatively add kvm_gmem_mapping_order() or
expand kvm_gmem_get_pfn(), e.g. to say "no create", so what if we just do this?

	/* For faults, use the gmem information that was resolved earlier. */
	if (fault) {
		pfn = fault->pfn;
		max_level = fault->max_level;
	} else {
		/* TODO: Call into guest_memfd once hugepages are supported. */
		pfn = KVM_PFN_ERR_FAULT;
		max_level = PG_LEVEL_4K;
	}

	if (max_level == PG_LEVEL_4K)
		return max_level;

or alternatively:

	/* For faults, use the gmem information that was resolved earlier. */
	if (fault) {
		pfn = fault->pfn;
		max_level = fault->max_level;
	} else {
		/* TODO: Call into guest_memfd once hugepages are supported. */
		return PG_LEVEL_4K;
	}

	if (max_level == PG_LEVEL_4K)
		return max_level;

Functionally, it's 100% safe, even if/when guest_memfd supports hugepages.  E.g.
if we fail/forget to update this code, the worst case scneario is that KVM will
neglect to recover hugepages.

While it's kinda weird/silly, I'm leaning toward the first option of setting
max_level and relying on the common "max_level == PG_LEVEL_4K" check to avoid
doing an RMP looking with KVM_PFN_ERR_FAULT.  I like that it helps visually
captures that KVM needs to get both the max_level *and* the pfn from guest_memfd.

> > [1] https://lore.kernel.org/all/20250717162731.446579-13-tabba@google.com/
> >
> >> +
> >> +		max_level = kvm_max_level_for_order(max_order);
> >> +	}
> >>  
> >> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> >>  	if (max_level == PG_LEVEL_4K)
> >> -		return PG_LEVEL_4K;
> >> +		return max_level;
> >
> > I think the above line is a git-introduced issue, there probably
> > shouldn't be a return here.
> >
> 
> My bad, this is a correct short-circuiting of the rest of the function
> since there's no smaller PG_LEVEL than PG_LEVEL_4K.

Off topic: please trim your replies.

