Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC93CD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 18:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216636B0099; Wed, 20 May 2026 14:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19FA96B009B; Wed, 20 May 2026 14:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 069CB6B009D; Wed, 20 May 2026 14:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4BAE6B0099
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:59:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93BFF8AA4B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:59:08 +0000 (UTC)
X-FDA: 84788710776.23.3CBE1F6
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf01.hostedemail.com (Postfix) with ESMTP id C0CA040014
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:59:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wkfrb+fc;
	spf=pass (imf01.hostedemail.com: domain of 3eQQOagYKCBIAws51uy66y3w.u64305CF-442Dsu2.69y@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3eQQOagYKCBIAws51uy66y3w.u64305CF-442Dsu2.69y@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779303546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xc+eqLu2deOuDSSfxTvMnxL/tYv4gr65bHOPW09jR0U=;
	b=U+1dV6RQEOgntpR6sLxV6xn3s64FHgpEK1pBvpwTli5C/EhXOgA1C+RsRxnmr/TFRhNGvR
	RsL+lQFLgJ4nF2V8gge4GmBpJD1Q/4e+gS6vOyReQDulXc8aMwHTvPvWNaNvO9ihfZt/0b
	KGQxyKRfqws3QzHTeHuFmZ3LVq8NZmw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wkfrb+fc;
	spf=pass (imf01.hostedemail.com: domain of 3eQQOagYKCBIAws51uy66y3w.u64305CF-442Dsu2.69y@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3eQQOagYKCBIAws51uy66y3w.u64305CF-442Dsu2.69y@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779303546; a=rsa-sha256;
	cv=none;
	b=w82vEK3x0RdnF6LO1dNUWBLV0QVn+ANbh5szi2dG/ZbIDlAbM18rwoaMBufINfe7UaSPZl
	L4SYv7N5CvwwAkRGeYbf4StbZOLWRmC/OwJGOmEFafabVoyfQwu5J3YO9vQEu7sGnMWXfB
	a3UFzsdvjASNQdWWul708ysSHAjgFjU=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c82ba4715b6so5643093a12.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 11:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779303546; x=1779908346; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xc+eqLu2deOuDSSfxTvMnxL/tYv4gr65bHOPW09jR0U=;
        b=wkfrb+fcXEdVfPEQXD95RDrKrCRAYypv7EgMu64Cst0q2g15k1rH/DzxyPSqRA2x9j
         bqKyhDxzG6K3xV5p3zLV+7+a4diqeiq3EhSSLKlnVc0pKp9F1eHrnUoMY8pb9xxFKpML
         6R+21DsI0S1dGCh5JEXBoec6vUpT/9Guf52VdQ1l0VmgE/WndanlUWoRsM2EpmxZ7r8p
         m+dlBLq9jMx+pL7U35/P2A0DgqCA9aBAwRearax0UELXVwT2+Qsmv3b8Dqp0pK+KyVtu
         MD4eOeZi3kTAbH9yTjAYWuI+npqaayY5mIBcf6UVRUuhmSqPWltzZlOic0dVAMZLyL/s
         cO7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779303546; x=1779908346;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xc+eqLu2deOuDSSfxTvMnxL/tYv4gr65bHOPW09jR0U=;
        b=g47E4pb4f09khC+KCzjDJuN2qRm8VKTOmewF53yK+qzpyGDUfXs16F3XWXJihyWpG4
         vzny6y/o3OwMSdDSkNjJzQIeeIWZbIU/nwfy8VJj7TuT0VqcOCzrWqPMdhvHLK1qCI2M
         ye+SZbIir4P2hD6y23ZuAhYJ3FOMzapfjSd7ibZDGcIyoACOfidz4savu+qvd7qs22nn
         +LXheo0T3FzBjDnxpi/DmOouvQjbzE5kX9vhSLdDKYJbd1Vu1bFti2/lt0qeYvotRG+0
         wHI3SfR68SSHrX12PeZ2QQiMM2m4Ae9T+IAxKmzo7YYBmTB0S/o74nYQZWZOhelXKb8D
         iCow==
X-Forwarded-Encrypted: i=1; AFNElJ/SrgW2NAXaWsh4hP7bMHZRA4i+rKZ+tSDsyDIUvl2kehkyDUmVZC5xJvn+xZ6X+Zck08qrbiJLjw==@kvack.org
X-Gm-Message-State: AOJu0YwPy85cu0lKBor1Ls41Yd1StZBisElHPu6SBFSXLBQB9X1ob7b6
	l9AIqv5n+cVxvluPC4ZgUoLa42peDYbqVvq3XGtg5xvNUZ6qhFhipwqVct2XKdPENq/+iogzQy8
	QqJhxGA==
X-Received: from pgbcz6.prod.google.com ([2002:a05:6a02:2306:b0:c79:8756:1a98])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:734a:b0:3aa:f9cb:d43a
 with SMTP id adf61e73a8af0-3b22e67fe5emr29278600637.5.1779303545036; Wed, 20
 May 2026 11:59:05 -0700 (PDT)
Date: Wed, 20 May 2026 11:59:04 -0700
In-Reply-To: <CA+EHjTw-cUM=FrJevtSDtR7K6MwUfGfOx21LMFDn7DAy5bFzYw@mail.gmail.com>
Mime-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-5-91ab5a8b19a4@google.com> <CA+EHjTw-cUM=FrJevtSDtR7K6MwUfGfOx21LMFDn7DAy5bFzYw@mail.gmail.com>
Message-ID: <ag4EeByDV-OtGhlk@google.com>
Subject: Re: [PATCH v6 05/43] KVM: guest_memfd: Wire up kvm_get_memory_attributes()
 to per-gmem attributes
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: C0CA040014
X-Stat-Signature: 5ebtqr4m3nrfpjr5d5os3oqgpno5b5ga
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779303546-742358
X-HE-Meta: U2FsdGVkX1+b/I7CGyKyRia97hyNODq9S1szazdoPQG+UAxXl9OlTBTzE1Z5CggToc18qbUd5sXZ26oB7+/5gLHEcTJBxImAcqmW1RjnfZ2HYoQqjY4I4hUq/dO09+VJZnBonpR7aVGPHra8AQXfIg4XC5yzhDTUT3O8TjihP4Eu1sPZ6ctRfPfc6VEAZnUY9FjwdKawGTHsui5RH7OycLc8ro3Vu67daJ6xtCl7lpqR1jCf0w1bPacsH92dU/Cbf0bvee9MUcv+V8I/tQevb06Oajy7M9Iu9g2qk1ro8VvZPplhj6SIF0MJkFV0xi+dS8t1FIX24E1nlB0Ptf8qp+kWF9qR7dQPhbe792uzMNEznMLUxYZOdPtH6nSvZsKLNsse5cAYHQ8vGzgTaMaw5pCkf2aTT3/g9LneHIkhwFe+MUEwGFDZsOy4szEcixXa7f1LPzZcAm1gA51Dkmz0AF17nDqC5e1IEQtfOxruRjwc/nqQMEjiS3LqBwk5Yz8uMC2SBjr0Pxvw6/B89LjW6/dhN0waE5obVPukwOc+ISR/OJjocqEPjY6i2VRqwPzn2bi/ThTiTDXd70wQv9dXfXgd5+TTS4Ze2nG3krkO6FHVZ7Fkg3JFfaq9ckBaAq8lQWIn5c8KoqBkp3E7VR/oC+9J91G/NFe3ScSvqp38bGBuhBx0NMbgdUKBiqmBSeDTViT4BeArM8ybS0gL4bnnaRhUx6pZ3gBTcTirZHNQuGhXjr3rmT9nsl0SX5st/cHbKKhXCVAAzERghUqU6tEQFEYi2l5VWhIYwBB6LNEJndAn0STe/r2Vn1n/Zh0eg7UXgE1tmVpOVrB+f7Q4/I3JWkrYgLMHwZBVxMXKVsD1Puqy3ICvHIbAQc//YN3rLnBfk41oxA9H+/1ouZhYmf1SL/RZ/chzTXAe0q/NMvXW7LFfhd/MlZJlMvTt6B7O8OBP430IS/f99AGTXYjPgsW
 nwftdhN4
 4bZmi65CIVOAJTQCeAP0kdZh6S2sXQuq+ArPYHE8rVzF/Zzcb62ZS7YnIb7j9uuuOaf0ZJyqjOxgNYZzRR3Jbc26XHzu4c99pBbg8+xkQMGM4LNC+PIcFrYtH46X9PyajTeI2T5+WF24C4lcPC2LqEnW9uk+x7l9QlW77QwCHDhQvJ8XoDRsxxBjJG5m2rU8TrfPsgBagThcXVlNnYL84fQtnOQRPevm4h3Dl32QtXDNhNGr0QtJpPplHpMTJQyPb6yankIh1gKK18cqWLyt3JT/Yd1UgTPTdJeCetx+/yhauNW6c2aLiZHZxqOKQ2s3Br7zaOfLES/O8HmB80UhpMRpS4Zq6J5bWLoH39a3jCTt+EhtRJFENQ7rxUma5YzpvexhOxWmL5kVzS2Y1TGk0zqUisXIEzBuk8udkVUqJBmPVeeMoY27X7jM8+LhyhMnBR6KTbx0mMz8+zpzR1qhiQPHtfZoNRJ/qfr4jzpJ0slPFDfnZRVLcY7sMg/fnEmKpbEUvLfimgZJvSICZxKg5ye7IqkDflmRt/+7iJ6d91X9VYLzK1kI0+OT87Mku2gPKJHjlWdCub3Cydo6ISFFRsILpCisiiHBMK7u/RzAyxGvbmc/SMu7O1MSVMYYTeXwz92IRNwMqh6tLmJFa7pjG/+zZ+mS/gbHzIkgXO1v7BmW3OLqUQIwTxSV5HNkU2gEZ7FQs7wWWTEuz75pVsbJpk+oxUDUbc+P4PJZ+Nbuk1/c3oXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026, Fuad Tabba wrote:
> On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
> <devnull+ackerleytng.google.com@kernel.org> wrote:
> >
> > From: Sean Christopherson <seanjc@google.com>
> >
> > Implement kvm_gmem_get_memory_attributes() for guest_memfd to allow the KVM
> > core and architecture code to query per-GFN memory attributes.
> >
> > kvm_gmem_get_memory_attributes() finds the memory slot for a given GFN and
> > queries the guest_memfd file's to determine if the page is marked as
> > private.
> >
> > If vm_memory_attributes is not enabled, there is no shared/private tracking
> > at the VM level. Install the guest_memfd implementation as long as
> > guest_memfd is enabled to give guest_memfd a chance to respond on
> > attributes.
> >
> > guest_memfd should look up attributes regardless of whether this memslot is
> > gmem-only since attributes are now tracked by gmem regardless of whether
> > mmap() is enabled.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > ---
> >  include/linux/kvm_host.h |  2 ++
> >  virt/kvm/guest_memfd.c   | 31 +++++++++++++++++++++++++++++++
> >  virt/kvm/kvm_main.c      |  3 +++
> >  3 files changed, 36 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index c5ba2cb34e45c..28a54298d27db 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2557,6 +2557,8 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> >                                          struct kvm_gfn_range *range);
> >  #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
> >
> > +unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn);
> > +
> >  #ifdef CONFIG_KVM_GUEST_MEMFD
> >  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >                      gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 5011d38820d0d..f055e058a3f28 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -509,6 +509,37 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> >         return 0;
> >  }
> >
> > +unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
> > +{
> > +       struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> > +       struct inode *inode;
> > +
> > +       /*
> > +        * If this gfn has no associated memslot, there's no chance of the gfn
> > +        * being backed by private memory, since guest_memfd must be used for
> > +        * private memory, and guest_memfd must be associated with some memslot.
> > +        */
> > +       if (!slot)
> > +               return 0;
> > +
> > +       CLASS(gmem_get_file, file)(slot);
> > +       if (!file)
> > +               return 0;
> > +
> > +       inode = file_inode(file);
> > +
> > +       /*
> > +        * Rely on the maple tree's internal RCU lock to ensure a
> > +        * stable result. This result can become stale as soon as the
> > +        * lock is dropped, so the caller _must_ still protect
> > +        * consumption of private vs. shared by checking
> > +        * mmu_invalidate_retry_gfn() under mmu_lock to serialize
> > +        * against ongoing attribute updates.
> > +        */
> > +       return kvm_gmem_get_attributes(inode, kvm_gmem_get_index(slot, gfn));
> > +}
> 
> Doesn't this imply that all consumers of kvm_mem_is_private() should
> validate the result using mmu_lock and the invalidation sequence?
> sev_handle_rmp_fault() calls kvm_mem_is_private() without holding
> mmu_lock and without any retry mechanism. Is that a problem?

Yes, but my understanding is that sev_handle_rmp_fault() can tolerate false
positives and false negatives.  It's not optimal, but it's "fine", and already
KVM's existing behavior, e.g. KVM gets the PFN and then smashes the RMP, without
ensuring the PFN is fresh.

Mike, is that all correct?

