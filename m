Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0042BC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 23:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE2A6B05E0; Thu, 13 Aug 2026 19:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B773D6B05E1; Thu, 13 Aug 2026 19:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5C596B05E2; Thu, 13 Aug 2026 19:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 787C26B05E0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:20:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C06CA0257
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 23:20:09 +0000 (UTC)
X-FDA: 85097816538.06.64DEB0E
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf18.hostedemail.com (Postfix) with ESMTP id 513C21C0009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 23:20:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UV0VNRPd;
	spf=pass (imf18.hostedemail.com: domain of 3JVF-agYKCBwK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3JVF-agYKCBwK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786663207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7W2EF/B1upW3gWk47NaF5dFLDVwJn/JvniCK/05iC4=;
	b=CQjXWk7bI0fYazET4wvzrCKxqUxikxt+IiMdKxh6k6oamEcCBegW9RRIe1JtQuTv4G8Ogw
	oWR4o3aBIdg4tsvecofxf0KSzTCIvEQPd4CEv1BSIzh5/rHBjOQW4hMm1nM5m5lI0N4lWq
	kj45lEfdApxRz8MXaDOKzOytiNvtGZQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786663207;
	b=UwozuWF750wjXaLjnyZmxhgUIm+5imP/MsBaupSzl3qtZd4KNWdNX217fyW4EPG4iS3zP3
	UxzMzWHEn7RJrhnS0+iRs0iOB7njmvuBokV7ThHDPdpcJgMmB6/fifPIOVYn+ke1g3Ae9q
	ukEGX+3s/HwTGOuItWVwJvpiOPWsqwY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UV0VNRPd;
	spf=pass (imf18.hostedemail.com: domain of 3JVF-agYKCBwK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3JVF-agYKCBwK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38dde0df80bso515319a91.3
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786663206; x=1787268006; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s7W2EF/B1upW3gWk47NaF5dFLDVwJn/JvniCK/05iC4=;
        b=UV0VNRPdOR76ZVl/TXwmhuZhMvDI3z00sb+dgt1LJ1zUgqcnlnnDgkWA14HfKOXiUA
         X832gXx7WfLTGTfnlZay5qCUvKBj00epyl0OlI7vlus2AGlqQ/V2otHjIT/UVPUVJRul
         gUmvLyoQzVnR5pgUhVUBwJmLTMbZxswpFLWZ0OSRcEtDgD6cYZ2UHsuN++/jWGXfVTAT
         GnSfHzft8ES1dnkcCgSiMmrdORQfo9+i8EnpsAWbKHkyypOEuHkq17Iqgc4NSk6a0WjB
         fac0rzsEoQ4E9m5CSYEGZSGMx6LecfZDhRWr0bNKfjqrcs0PzN/en2G5X9cYz7HflgPE
         Ggnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786663206; x=1787268006;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s7W2EF/B1upW3gWk47NaF5dFLDVwJn/JvniCK/05iC4=;
        b=rCHCCAFAXWKNqTFMR+VI6W+HnyGJC6gO6L1wizTBMAZuc9V86UQAz0mlsnjE8o5BBL
         jZOSwxmDuX1DY6EOa+WZGGq9KSE+KbWVDzVLO/RTdKFbHjnh7KQJMQA17V14ZPj+d9uo
         FkiPPnfSnZ4Lkczt1b/4pUPxu5uhdM5fqi/2K/eidIyAJQj28ZGjk/RpOqo7eDQ6ye5P
         wWJPuy0ZettRqku7tNZNiKAFn1Zv1uQkhOg0NPSsWsTZnWHQWa6cwyOWPJBn3y/ZAwIl
         s0W+sFF6Sa2XnGwrAu/GMlc5RXTHwP46OHmOththkPmBdbYG++6fuFRT0vxuTi+9J0NF
         nmUw==
X-Forwarded-Encrypted: i=1; AHgh+RpXd01l+eddvxFw/mUnToP9oDQdHbSdELVKYKvjTRcyRaMn4XzW5vksCjApC1HsXW1WKJ9Vt3AzfQ==@kvack.org
X-Gm-Message-State: AOJu0YzqZf+M2i8sltBMHfITaHWIsUh1qmU4UXclUtZZtND0ft6+A+nl
	HNSvZPztNtVLDzIdStf33OqJ0D2GPudsCsAuf6sdzyhj25oh+JwJUaEQ6IAmlP+9ObAUYBK+VDy
	ifTErGQ==
X-Received: from pjuf1.prod.google.com ([2002:a17:90a:ce01:b0:38e:aa86:7cac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfcd:b0:38e:c7b0:84ad
 with SMTP id 98e67ed59e1d1-3933b503abcmr1679606a91.0.1786663205745; Thu, 13
 Aug 2026 16:20:05 -0700 (PDT)
Date: Thu, 13 Aug 2026 16:20:05 -0700
In-Reply-To: <0c80b9b0e13e3ab2cbe4f9eaf4a02ebba25a7001.camel@intel.com>
Mime-Version: 1.0
References: <anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.com> <anj2bPrGqzZgZWMF@yzhao56-desk.sh.intel.com>
 <CAEvNRgFzRj_=GVy8T4P8ehhQjYomYxkngzwtKBF0iEL0Cv6fuQ@mail.gmail.com>
 <anp1I64K0KeyQuyo@yzhao56-desk.sh.intel.com> <CAEvNRgFWcndQKJE_q+ZATFZEMYd=6uRLygozLvg7L77bPX0cEQ@mail.gmail.com>
 <anqqKH6kuwpvuwp9@yzhao56-desk.sh.intel.com> <CAEvNRgGWDY_fxbyBM-5sMdYMevMe0HzVP9kbC1cCGLE_dV=_Gw@mail.gmail.com>
 <a71d4fccdffd1f6a12332ddd18fa812542ea2118.camel@intel.com>
 <CAEvNRgHxda6XK_XqWaqqVnA7oW=Fhp_C5gF4vNcL+-HfwfXMqQ@mail.gmail.com> <0c80b9b0e13e3ab2cbe4f9eaf4a02ebba25a7001.camel@intel.com>
Message-ID: <an5RJYTwlYeym--O@google.com>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"david@kernel.org" <david@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"steven.price@arm.com" <steven.price@arm.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"forkloop@google.com" <forkloop@google.com>, "tabba@google.com" <tabba@google.com>, 
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, "willy@infradead.org" <willy@infradead.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "wyihan@google.com" <wyihan@google.com>, 
	"pratyush@kernel.org" <pratyush@kernel.org>, "aik@amd.com" <aik@amd.com>, 
	"jmattson@google.com" <jmattson@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "rientjes@google.com" <rientjes@google.com>, 
	"andrew.jones@linux.dev" <andrew.jones@linux.dev>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "chrisl@kernel.org" <chrisl@kernel.org>, 
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "oupton@kernel.org" <oupton@kernel.org>, 
	"mhiramat@kernel.org" <mhiramat@kernel.org>, "baohua@kernel.org" <baohua@kernel.org>, 
	"tarunsahu@google.com" <tarunsahu@google.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jthoughton@google.com" <jthoughton@google.com>, 
	"yuanchu@google.com" <yuanchu@google.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "shivankg@amd.com" <shivankg@amd.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, "youngjun.park@lge.com" <youngjun.park@lge.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "weixugc@google.com" <weixugc@google.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "qperret@google.com" <qperret@google.com>, 
	"brauner@kernel.org" <brauner@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>, "corbet@lwn.net" <corbet@lwn.net>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "liam@infradead.org" <liam@infradead.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "kas@kernel.org" <kas@kernel.org>, 
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Stat-Signature: upbr5hwspjm1ob9exjgc6ww4p8nohjg9
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 513C21C0009
X-HE-Tag: 1786663207-769936
X-HE-Meta: U2FsdGVkX19ClgSQXRdSwrgglotEC10v40G/jb9pUAq5KwzPdECR8J/fK5rW8B17cM/scmeCTtW4HlEOHPWBzRvw9vKtZRDH+jQ03OEyWhytWf2ZBhwfKNq2DbEdZPGl89J4OEwjoyvsatDHyoZqhApIOVL2sFUwlfXoino4X4Qb8VzIf5dAKqW+c9CIYDhhKJ74c+8gdnsCCQnoQdX0LrROChX5vMhrikt6QDXQKgyNL8M+SExKgc7rr4jEn+1DiHnoVOMzDGWcyGt2MI3WaFlv4ZxaQQYATjuIwLkqWVNLAkhJ0sNjLHfaqsrhNr79bPC++TnSWZw4ltjj87pZVOT4ShzaEb9HMcsLld0uJfEHw7AG90A6ryd8J7jpBwyYei8IvpQjothWigEtCmScVViuajt7sOLqFAMSKI+/OiSA/zYStg+DxTCmpWjsXwzFD60n0efBmK3hFdV+iNjLkeMd/M6fd6ZYN97MTNDqJvb++cSIVJ/I38/sVqgtLBAZnZs/k+JW5KeCVZZWLtTUM+4Aglhn9EoJ2WB5K6Nrs5Ry70/ynUfBkzF6WwNqZWDGd4Rl+CSHVCTdbknSOs5hNUCizsRzaLV6NpXY+AuUvN1TD/Fs7PISR2njaMlWMFo5if83QzDKLgJdwyFiucVPO3RRUeUFVy2ZYEoXrztByv8AfJG1Xm4YxyjdgtN5O3byBQzmYRRwL8C64Hw6OaFjsq5Nv+K77tpz2r7wApLbvegXm7tLgMNSm+GhyevaV/hWhKzrRGfzL4rpho6cCeDyNgww6lFVL79053pKFNnN2AIpW7lY7dWtv7W3X+CQmVl27bdk4DfjH6li9hGOPfXVdstcgYFP9Au/h4t/myZ76sO6RbmQdt0O79ip2zFmyi5kKiROTSvUlkU4mlBrFACMgd9RidbfBpJtCVTYnTDH7NNz8CIz1wzsBS4i1ZfCd0d9z6kNX1GwQOlUqgdVS74
 a8xRFkW+
 NwAFL9G4Efbh52ZN+JCeIjOAS4YQM8+xpmvYYkgiSViRwZtJDRUl8DUVQ8cte8gzB2Mz/OnZFBivCX18/rAu9vzGk3ImcpFtn1tP2raJNA3JAKrrIZDB9XT6RY3Oyx1cucVS98Tc9lp9PcUpxo2QXsAkwB9zoeAQBGo29tIsHmQmSQvGeHOVxULS0Rn/CKKQSy/Ub9WtpHomO1dN2eFfuyBY87+hsmUtft7Ix6w9SIWaw7thO2rD/UBWWjkdfuXHAGbMH1r9ZsWWR9U+r/yCqpa6Azs0OkenuPovp27dDni11cl0XJ26mTSCLafhotRTpGHpiT5fLXUipG74iHLUTvm/zS92mVGmbKFsYUwwF+Nfi5wV+l5Sx2JfrANu1LE1ndzT6K0DCj0pIrqlYG8PmT7+89zqppd6VhW9PuWFFXdxwhWtRdr7p9m/kd3daz+SYfhvS0CmrKnwyM/5do2iEExxzTYqpsbwmQZIEenKJEDqchiXg8e7LtAFeYJ1U2BeuzPlmkBuYkcVz0nFyjg4v+AL727H2slMim4QrTRS47VWLVXz4Gxt4CBTYMGff7ruraisJCT85z9xlFHbHQA4X/eB60WIU4eODd5nzz0qJZiZuK/d+tELCdO3sLOUM8aXBZs31xXG4DfGZU9uysg/mdoMTfpi4H0Se08YxCe1moTPTY7FqHUPw+F3fA+fPCZwO0Iv9GDYv3HeCgeBD9mlZeS3RU7RkLKyS2FKdczJXlY3YcoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026, Rick P Edgecombe wrote:
> On Thu, 2026-08-13 at 11:51 -0700, Ackerley Tng wrote:
> > "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:
> > 
> > > On Tue, 2026-08-11 at 10:35 -0700, Ackerley Tng wrote:
> > > > > > Would like to see what Sean thinks of this. Either way, is it okay to
> > > > > > follow up after conversions lands?
> > > > > Let's see what Sean thinks of this :)
> > > > > I raised this because the issue was encountered by one TDX's stress
> > > > > selftest.
> > > > 
> > > > Which stress selftest is this? I can try running this on my side too.
> > > 
> > > We have some selftests that are built on the basic TDX selftests. One just
> > > hammers the MMU stuff with a bunch of zaps and also weird stuff from the guest.
> > > It was eventually too much work to try to keep the internal enhancements rebased
> > 
> > Would like all the comments we can get on TDX selftests v14 [1]!
> 
> I think we had a few. Let me try to round up some more folks.
> 
> > 
> > > nicely so we actually just run an old branch's TDX selftests against newer
> > > kernels. So the branch is a bit of a pile, and not really suitable for sharing.
> > > We plan to clean it and upstream it when the path clears. So it would really
> > > help to get those basic ones upstream. We remain happy to help, so please let us
> > > know.
> > 
> > I guess at this point I'm hoping y'all and Sean are okay that this
> > conversions series merges, and we let this stress test failure be
> > handled later. I'll be around to fix things :)
> > 
> > I'd say the line of sight to fixing this would be when the KVM MMU only
> > gets PFNs (and no pages at all) from guest_memfd.
> 
> Hmm, I think we shouldn't upstream a uABI that we don't have line of sight to
> making robust. So it would be good to settle this thread at least.

This isn't uABI.  You're talking about hitting a race condition between one task
converting a page and another faulting in the same page.  An NMI, SMI, or IRQ at
just the right/wrong time, especially on a preemptible kernel, could lead to the
same test failures, even if KVM drops the refcount "immediately".

That said, I am 100% in favor of not handing the caller a struct page.  Now that
the TDX APIs no longer require one, it's more than feasible.  But, we absolutely
shouldn't just nullify the pointer, we should drop the param entirely.  Not just
because it's cleaner, but because it also forces an audit of the callers to see
if they subtly require a refcount (spoiler alert).

The lone holdout at this point is sev_handle_rmp_fault(), which could end up
PSMASH-ing a PFN that has since been freed by KVM.  Assuming holding mmu_lock
while doing RMP operations is ok, something like the below?  Completely untested.

As for in-place conversion, this is not a blocker.

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6c941aaa10c6..8ef16ccf26ce 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1641,7 +1641,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
 	smp_rmb();
 
-	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
+	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, NULL);
 	if (ret) {
 		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
 					      write_fault, exec_fault, false);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index fb54f6dad995..c982a6454fc9 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1411,7 +1411,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 		if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
 			return -EFAULT;
 	} else {
-		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
+		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, NULL);
 		if (ret) {
 			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
 					      write_fault, false, false);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c519e8e8d646..f0da212ab108 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4603,8 +4603,7 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 		return -EFAULT;
 	}
 
-	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
-			     &fault->refcounted_page, &max_order);
+	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn, &max_order);
 	if (r) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return r;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index fcb41dfde4c0..3b1c42e03deb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4060,7 +4060,7 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	 * The new VMSA will be private memory guest memory, so retrieve the
 	 * PFN from the gmem backend.
 	 */
-	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
+	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL))
 		return;
 
 	read_lock(&kvm->mmu_lock);
@@ -5003,7 +5003,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = vcpu->kvm;
 	int order, rmp_level, ret;
-	struct page *page;
+	unsigned long mmu_seq;
 	bool assigned;
 	kvm_pfn_t pfn;
 	gfn_t gfn;
@@ -5030,7 +5030,10 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 		return;
 	}
 
-	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
+	mmu_seq = kvm->mmu_invalidate_seq;
+	smp_rmb();
+
+	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order);
 	if (ret) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
 				    gpa);
@@ -5041,7 +5044,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	if (ret || !assigned) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
 				    gpa, pfn, ret);
-		goto out_no_trace;
+		return;
 	}
 
 	/*
@@ -5069,26 +5072,29 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	if (rmp_level == PG_LEVEL_4K)
 		goto out;
 
-	ret = snp_rmptable_psmash(pfn);
-	if (ret) {
-		/*
-		 * Look it up again. If it's 4K now then the PSMASH may have
-		 * raced with another process and the issue has already resolved
-		 * itself.
-		 */
-		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
-		    assigned && rmp_level == PG_LEVEL_4K)
+	scoped_guard(read_lock)(&kvm->mmu_lock) {
+		if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
 			goto out;
 
-		pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
-				    gpa, pfn, ret);
+		ret = snp_rmptable_psmash(pfn);
+		if (ret) {
+			/*
+			 * Look it up again. If it's 4K now then the PSMASH may have
+			 * raced with another process and the issue has already
+			 * resolved itself.
+			 */
+			if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
+		    	    assigned && rmp_level == PG_LEVEL_4K)
+				goto out;
+
+			pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
+					    gpa, pfn, ret);
+		}
 	}
 
 	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
 out:
 	trace_kvm_rmp_fault(vcpu, gpa, pfn, error_code, rmp_level, ret);
-out_no_trace:
-	kvm_release_page_unused(page);
 }
 
 static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 03bfc92864b6..502465119ca0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2586,13 +2586,11 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
-		     int *max_order);
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
-				   kvm_pfn_t *pfn, struct page **page,
-				   int *max_order)
+				   kvm_pfn_t *pfn, int *max_order)
 {
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b596486d184c..ba7b46c1aa15 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -751,8 +751,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 }
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
-		     int *max_order)
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct folio *folio;
@@ -780,12 +779,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 #endif
 
 	folio_unlock(folio);
-
-	if (!r)
-		*page = folio_file_page(folio, index);
-	else
-		folio_put(folio);
-
+	folio_put(folio);
 	return r;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);

