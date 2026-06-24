Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D77A3CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 17:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B54056B008C; Wed, 24 Jun 2026 13:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2BEF6B0092; Wed, 24 Jun 2026 13:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43216B0093; Wed, 24 Jun 2026 13:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 851A46B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:01:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0AF478DD1D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:01:28 +0000 (UTC)
X-FDA: 84915422256.20.5CE049E
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf02.hostedemail.com (Postfix) with ESMTP id D76E18000F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:01:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t6mjMLEa;
	spf=pass (imf02.hostedemail.com: domain of 3Yw08agYKCMY4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3Yw08agYKCMY4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782320486;
	b=Zi5HYWzTQ7uCLu5U4R/kzFDZQp2j6NE6CEtCToZSGSInXNlb5S5QwLVgq32N1vIieJZ0yw
	BRJVKtgkcuDZs5BkFlaM0OODuOd8HY4oHjtOtNm4p6w1661/NQMhh8nhoOi28T6D5scY+r
	QFRqZRZ1a4mQJm+watNgCRyi2540mKk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782320486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISY2wbCcsFGmwP11+MNFOlIY+gG7N5avT6t+DVDnEh8=;
	b=hiQY4WYgluqaBP0RDYg5SjSXA7UfxazImmVSWEMVuZRybIimzjmGxKGl3l3xnleB3uHavw
	MH97uKq7N/4VD6+nAq8DeGzVyouXDfepTdBpjwlYv98QakXKK7WoEPvR3RDxW5QI0xalBc
	D2PcisiUDvOKj+MHZtqyL6y6ZSX85K8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t6mjMLEa;
	spf=pass (imf02.hostedemail.com: domain of 3Yw08agYKCMY4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3Yw08agYKCMY4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-84531eaf8a8so1872671b3a.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782320485; x=1782925285; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ISY2wbCcsFGmwP11+MNFOlIY+gG7N5avT6t+DVDnEh8=;
        b=t6mjMLEaKv+mFAQ5YzUqLlAcdP7wyG1K38t2Y/ZeozHFsb77YbnbyxR87GonRvDrE9
         6uvsdJn1jvmyOcxWraCcvMIAU+HE7UyjSPhn2CAKyHOD5+zVJMOqoXVcLr06boASnThI
         ikcFaBygCqXHNe9vIKtJIX43dJHrfVpWZdgJatyt+hXqKWpEXP6bTndxhF6rH50CGmh6
         wJ7jUEFfjobdQ0RySHXoIrgPy/azSynnE/iSKQNh+Py2RKN2EqS+0Nz0vSQBF3co7MtF
         XVVmAtCY0wrwVAVavPkomOnQI9XW4RH2iI/aNw1g3wysTxKEa1CbFqUZKtxselrnk9HF
         KVpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782320485; x=1782925285;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ISY2wbCcsFGmwP11+MNFOlIY+gG7N5avT6t+DVDnEh8=;
        b=JK8ITAUVP3UPS0NVvjjvsQDtShTvmZWvMMHv14QLazB5LxHBocZez1rN139ndaKDG1
         te7WW8n8C26X6oNlbDKEDFkr+rLYe0jiN7sDddVCG6kfN0IaD9xn5lvtRUrnd0kQUh77
         ePba1cAPEH+KcA3PkeeSPcW07KcErzWkxlePCJPz6vu3bKG0x3oYc1wzCswBGiKcGGH4
         PaFh3cMU72xwQV+kVKXKsLyA7jCDgEv6D3DyfCgkkD29KXSyGI9YD33nhU4ggjpJrWkC
         AzQe3g9+5k2Z5YUeJ9Fr9ZZO/tskcYfHWm0ft1+mMdyAuW+teFaqAlGJvODqMvd/LNBJ
         s1tQ==
X-Forwarded-Encrypted: i=1; AFNElJ92KThnSXg7F+coA8PTgVDWebfKOEqYKSGf1Y2wAE5w+w52EbidgkPWmqCDICAjTI8ONz8vriHJ+A==@kvack.org
X-Gm-Message-State: AOJu0YyKXWzRI30HuLHNV5tA0K/vzIi5qjcghaFoYp+fvJ32vYioB2/r
	4QoeXj1Mg5mdJ20LunvyFjAu+QbPyUo05H5K4B/Jj1ddE7mp99Bqozd67pF1URSyaPyV2Z3q2UJ
	LlBX3sA==
X-Received: from pfnp26.prod.google.com ([2002:aa7:861a:0:b0:83a:68c:e1c6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:88ca:0:b0:827:2a07:231d
 with SMTP id d2e1a72fcca58-845a26d1fe1mr5396846b3a.17.1782320483693; Wed, 24
 Jun 2026 10:01:23 -0700 (PDT)
Date: Wed, 24 Jun 2026 10:01:23 -0700
In-Reply-To: <6fc7f450-6d0a-494d-b295-297e4703148d@linux.intel.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-18-9d2959357853@google.com> <6fc7f450-6d0a-494d-b295-297e4703148d@linux.intel.com>
Message-ID: <ajwNYwsDc2_Vx_kp@google.com>
Subject: Re: [PATCH v8 18/46] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: jpk3ikuigjjitga8gqzhy6b95ey6sz4f
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D76E18000F
X-HE-Tag: 1782320485-577000
X-HE-Meta: U2FsdGVkX1+rcE8T/AJGPy1vmv6rr+f4k6stZUtzB/2kH5spVScRph3SVVzZ8NYwoCc5APoYYkXhe3PHWlwTrWtKE5jJE0yALbtkoBV0IDl9HY6DqH0QkIOxzH63fw4oFQooXUEVTj+0VsO5XJPwS5jXTM6S529Zn8LMh5MmdlCYy8nX3q9LpPs2JcPxp4mtZqEhW2aLeOyK6fguJ5+Nxzq4fbuUObjfukkzmuB6uK2A+0wrsZX8kH9Qjuwap1v+WlHVzlWsgJnz5ZN907SjDJx7M8mLPZdCv9uZqZRG4lm08UPbe5hPQErGb4wUtviNVs2UMbO5fUsntWynerysxUMLRGmzN4uhyQ+s5bfycQdSH2pZH7uJY4I7SgTFu52epfWpEEhcH+RPDMHgEYKzj96uEGPkkQv4JFENy6a3KPpPcde6Oegk3dgfQqsi+Ua9zwp2iNg0gonlz+lvxvEPaxeJfMbnmkSAqFK6FjM2mdUgNSewnqURtelVjUsM0KKETU/uOOWKmXolbLT/5vkjY4rtNY4mDTEmdIwSY8x9zP8eacR7H4+wslk7ZSUE6CFi2mMGLIZnvyGIn784luUdJewt2UBT6IhJGChK6rBu+1bauHILaYRo41N5PhkCXUnMBZ+vRysDbI1I3GrGN46RNhjLJXBDs/iawZwouhGzr21q3g53xkirMV5HnD0T4so7mmsxtA9WsSdqKOvm0XUZQFk7FG6HPxNLeCMoQ+mig8ywJMJZ4NmNW+DL4K/iilPDv9GfYNYaXGSazV5qVCo1UcaVdd6eDRq7yBPz/0eLpfbe9V2H/t4vdcXKMe4B93G92W8pDp+BMvB2I5vGe1OvTjVZMsaLmkaGs+ARBYLdZoRPK+a7p14xNIWIXm+0xV/45PxPiJ89WzLZvajbEVoZh1y+XothUjUHZMCAlIbocrO4QF+g5dJAJf55DI6zhgJRXP20+yyOFFOZqeW4Ujo
 Mk6wZdvV
 8nP/RKObrwYvIotC8I8INMYEsnMc1yKqo3UsFgmhGEoRJtTm4W5wDCc9IEiXZUHOqCxKVOwZC9x55uRc2d1/e1hM/IJTvCEUAtP0qr5kE0grVXA4guNPvh5xzB6dQ1TZvdQGlWQNZNUBB+Y6Xuln755o2yCRFMVg7nlRT5ko1d6g4cmjgRaqD1NtFZMHNwmLS5+7SKQShaYEKii/IW9EvtqXpi6Zk6DfnySsqpvCYat+mjcqvxzR9OD9RZxhRK13iomFkRAA12L0wTFM/091GvxoD0n/WyuIPghHJdTYyiPSnp/Wx9Sxb7vJKen4pwtYJq4+RtW+qf0rKQsWQhcBRIKXnltvmTDN2pYC4fRaxsqo3bToK6W9C0RfIyh8uhkIi6wrL/P6yFZAT+yeQODrf3jIHiIHTF1Ehmfz5JGL6DOMNh6N7rl3tj15OstqePKiqy2zedn2XhEqTH1wMdOv65KiVBvyub2g175cm0jYlzWupCVXa6Az2Eo91FZz+cErTRVw6QhlqF7JNDOMsm08JmGaQMwtVBCQeHqFc2e2cpdnP2FHBZpCfJjwL6/ZzkNE1/KGoAU2qjc9FoeYjqGK99kHjbHHzFQ3aXHVBCRXl9SS6aH0PdSuDCEEKtdRw+saeGJ46
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026, Binbin Wu wrote:
> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> > @@ -606,12 +608,20 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
> >  	next = start;
> >  	while (safe && filemap_get_folios(mapping, &next, last, &fbatch)) {
> >  
> > -		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> > +		for (i = 0; i < folio_batch_count(&fbatch);) {
> >  			struct folio *folio = fbatch.folios[i];
> >  
> > -			if (folio_ref_count(folio) !=
> > -			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
> > -				safe = false;
> > +			safe = (folio_ref_count(folio) ==
> > +				folio_nr_pages(folio) +
> > +				filemap_get_folios_refcount);
> > +
> > +			if (safe) {
> > +				++i;
> > +			} else if (folio_may_be_lru_cached(folio) &&
> > +				   !lru_drained) {
> > +				lru_add_drain_all();
> 
> It seems unprivileged userspace is able to trigger lru_add_drain_all() repeatedly
> by invoking KVM_SET_MEMORY_ATTRIBUTES2 in a loop, which could lead to DoS risk?

FIW, if there's a risk, then AFAICT fadvise() and memfd's F_ADD_SEALS already
have the same risk.

