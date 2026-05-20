Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 007D6CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 134FB6B0005; Wed, 20 May 2026 10:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E5E96B0088; Wed, 20 May 2026 10:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F169C6B008A; Wed, 20 May 2026 10:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E07516B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:21:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68E914033A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:21:36 +0000 (UTC)
X-FDA: 84788011392.02.FE7B9B6
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9971A100003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:21:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iaRazFqo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3a8MNagYKCIAwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3a8MNagYKCIAwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779286894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGduY4ljPx9wbBVEnZWZe0lo89Kip5G/xMJZhZdI+Us=;
	b=3fC0kyi8aESCMbeASCHuvZqOrInETO448pDQTv8KvX+pVJf1kGvoAs9ACOpPku+n9CJMM1
	/JG9C3DTm7WIyZzhvD3Jku20vVVJiaSd7Mi7NnKFhOygtjwst1lzeWwkyPdmz9NbR088XW
	Q8O7xl2JMZpUOE6pQoY4EdssYxPZydg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779286894; a=rsa-sha256;
	cv=none;
	b=1fDvI95OKsq9srpS4rymY/iPKxsP+n0N99IqeNfb0oOB1Ze0L26vLYOBDgeDBt56bQxfoU
	6xN2hka+nvqlKwQt4xFx2JXzOKtc5uS9IHVrMW7C351qzgmjnJ/azqswki+ZaznxL9AFjK
	YLKLKITlumhOPOXkbjhVMD/KZYoQV2g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iaRazFqo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3a8MNagYKCIAwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3a8MNagYKCIAwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c828acf7c1dso8050399a12.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 07:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779286893; x=1779891693; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FGduY4ljPx9wbBVEnZWZe0lo89Kip5G/xMJZhZdI+Us=;
        b=iaRazFqoSAE61Wh4pHq/Q3pTBK2m8/tMkRtI73JSzPAVWvsIkxluSANF5tN5eaKpF9
         n7NOscdfC3DXa0jE84W88/8GEX/4QRoC6ekHCk8PlD+QULVnTOMERKOC0MgLS6oAx112
         2QEWqu5hUgcqPLnXyRx7lUa4SHejXV0m6NpHZS1FFVb9AmefWHi+6haAuuGSRQZfYU+y
         ZcMmOHd1jxZkmpvWX8vmfmm8o0st1JpNzJjzVErqheTxBIVOiYUJeL9jPfSNLW4IwhSC
         ncoFOVLroOY+hM+UoRaJvafWxZktb+NNIGqMGxoVX3r6CSlfgx+evHtEu8iPk2u78yTK
         nOgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779286893; x=1779891693;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FGduY4ljPx9wbBVEnZWZe0lo89Kip5G/xMJZhZdI+Us=;
        b=gSUY7kvGjNRR0YqldEnFKo97kR1pA4rvjq+g2uv/zdzao5eyIVptOR1uGdnhyM/+JF
         Z7ulYPburpm9SP6g0LDrgaA42ocqmgAfc1R/lrnF3Qim7I6UCrlApr4QxG1uQvNGwsrw
         WN5gWrM/wWqrZCfnjinTHHx7ROIrCSIA99O2ozokBoDzn2M/q2VRyvdl1Lgj0tgYDxiU
         6v0hiB1lYut7k3a6KK/jvCoYevXbub6cgTWyjwb1SHlinYWYyyXrN9+U1ujkhkubqiWQ
         VgxjgEg9ohhSIMTeuGJQubIvr8nZb1gvuuDmFat4JUniEWTrMOmkbgoXqAM4EvqImPxf
         980A==
X-Forwarded-Encrypted: i=1; AFNElJ9e5gWMNdTed8AOssW7vzxoYSsMxFMHniS+b5HVtFscQLQrnHcfJZ9Eu3qIRC1fo3iwm8fAEfHTpQ==@kvack.org
X-Gm-Message-State: AOJu0Yzauz+ojHICkTiflJM/dxkg1BySmEpiiT6H1yRt5xwEQL35DvLf
	VTHOEQw/iZ+yZjEwF/zKFhxycSsZgcL0+ZWdo0urZhT8SYDJLzdBnCeeK00bWAoraFlcNh6lgJF
	KJGqnJQ==
X-Received: from pgdn22.prod.google.com ([2002:a63:8f16:0:b0:c82:2d14:39c8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:430b:b0:3a3:3d95:508e
 with SMTP id adf61e73a8af0-3b22ec9a748mr25179838637.32.1779286891879; Wed, 20
 May 2026 07:21:31 -0700 (PDT)
Date: Wed, 20 May 2026 07:21:31 -0700
In-Reply-To: <CA+EHjTxvLU4XDPXDXYXXWJES1OFQgN8VTRLMgCCNMwBE6Hk8tQ@mail.gmail.com>
Mime-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-6-91ab5a8b19a4@google.com> <CA+EHjTxvLU4XDPXDXYXXWJES1OFQgN8VTRLMgCCNMwBE6Hk8tQ@mail.gmail.com>
Message-ID: <ag3DawWCcrpCkD0e@google.com>
Subject: Re: [PATCH v6 06/43] KVM: x86/mmu: Bug the VM if gmem attributes are
 queried to determine max mapping level
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9971A100003
X-Stat-Signature: d18cqgkdbp6wpsy8dme4s1q73psky935
X-Rspam-User: 
X-HE-Tag: 1779286894-349810
X-HE-Meta: U2FsdGVkX18+zfuIVRv9TjUfpzDbZPi83rQhspApooCavQaWViEKAl53trXz4YZS4y4/FPwtJpuw1tISaMheyACdUb5LkmHHNXJ+VzWciHq/I1zLT7TCXkkFONAEapaVjONyG6xkyCasfW/SjNxDp0nRnKmXRkrGoS6f2QwxWBGM+BUJnV5dOf/tVbgUxVT+cobqqY15sAeHuFtNr97SiBoukEHNEdYhZvGjlHWIJh1O14LQlvqf/aZ+fs/spupNNfOVJXSofs3QCwuY5+jyNpo//NbssR31JC6DGdIqIdinZxT/sGwT6sk5giFhIjQq+JqR6zBVXDhkqfblIwgcQjQVV7BhlKCyiacEIjQheHnfwwLz3UpUUigHjwyexpbfl7pg9Ik8VlGhUYwjGwkhmAH99DSa4EhhiNKMK8Sp+EbOEFAEc1u2NZNxjUkNHAd8coy7QznEZfJoccl21+hBCNtc1txO5ziI9Yua+YF0JvLMeDGKUtPdIwKglYth7u0ojwBFxFyLim+GVx4Gu93ghBIdt73ujRseCUGEOwKKB4iKxQ4ZmtbaFTND0M2/npGubhAfEzDADnkB1dPjIFgpY9NgaUe7+hE7HRxtjIAw8QsQIxvtG34pD6suTB4Kvz527W/xRuKnNmUZmLd1n6jC+t/GXWO44NXs6BUz8PkuxZau12FcolXXd1DtXgBAaAdrtlkw6OyDSGgYkHdTywrkJ1rbN4jHgwXRj7ezEKPqchbt7lvUBB2IfoxaQDoF4FaR9Tlma/zyjUY9Y9GkKmF90cdomI0bbC76qS7XpIfkOZig6JNlTNSHwoTUnjG+0yOWM58xpX10mS434JG8vWmJHgTg1Gom4RT8wDf6v2QPK4rjAY3XDB7nwqDE+9TCJUxdi/gQWev1MkYegOqjOw3cWywwUV+1x3+d6vTASDpyFxgow/nS8TBj06n+EmCgu6prXo4mjI/TbbS5PNxq8jl
 t9KtmDaB
 cp64iY4sAFzYK6m/QW8+FiTj4GCyh0TFVk40BgovFpljlZ5YjuSSbJ5Swbvq/vLuNR3iHfuq9Yvc1QoBZyaMea2tUMjRgORLP7aU0vJzapV7oElh8OTQrGV0BMm1ogiMO0rb3l6rxVFwKPvVCYRuphl23cv52TSFianVImSvIylJAtViqQy4YpO5SqFhw7AJNuxS+lML+OM1OeA/m2eiEVLpiC43g1kKY34GLWKF5jsXLum/OdtOLebjNnuuh1ZS1bxgzQUijF3via+g0EdX62H8uzKFJoVHwbPUWFWhvYzGjkFGavtK2llRSfdUZOdnOimRmNQfwv7gWw3m9Y18LXWxK/SawIrqbBILhKXqg4fqPZRnhTfMGvtRBDFMvtds3s2QyPU1UInsuWQSv1NrisOF02zK9R3G+3QpUDB3X22+f1bpc4uWDFV2l+DU6Kf0hvQhNUkBBA8MuOwyL3ElfsF9U2x0jKSnN5HeqnqYuQgWGecbqiuRAalO/Oxu9swDyijKggLjKhPBj5jR+5JSpO1vYcLaKtnzwjZI6RHW1hVoys93J4D0WsSO5k+8jW1g7xqu6FU7reBjK4NH1Aw1qEmTDAexV/zJSV/DXoZaM1hK8YjcAHBhW0awTFQT9mSDegkKvYBw/uhc7JHGI1LfVfHeaaIesvaG96NmuFCOJew8yYjyIx16ly1Klww==
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
> > From: Ackerley Tng <ackerleytng@google.com>
> >
> > When the maximum mapping level is queried, KVM's MMU lock is held, and
> > while the MMU lock is held, guest_memfd cannot take the
> > filemap_invalidate_lock() to look up the current shared/private state of
> > the gfn, for these reasons:
> >
> > + The MMU lock is a spinlock or rwlock and cannot be held while taking a
> >   lock that can sleep.
> > + In guest_memfd's code paths (such as truncate), the
> >   filemap_invalidate_lock() is held while taking the MMU lock, and taking
> >   the locks in reverse order would introduce a AB-BA deadlock.
> >
> > Currently, the maximum mapping level is only queried from guest_memfd in
> > the process of recovering huge pages, if dirty logging is disabled on a
> > memslot. Dirty logging is not currently supported for guest_memfd, and
> > guest_memfd memslots also cannot be updated.
> >
> > For now, bug the VM if guest_memfd needs to be queried to determine the
> > maximum mapping level. This guard can be removed if/when support is added.
> >
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index a80a876ab4ad6..153bcc5369985 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3357,6 +3357,15 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> >                 max_level = fault->max_level;
> >                 is_private = fault->is_private;
> >         } else {
> > +               /*
> > +                * Memory attributes cannot be obtained from guest_memfd while
> > +                * the MMU lock is held.
> > +                */
> > +               if (KVM_BUG_ON(static_call_query(__kvm_get_memory_attributes) ==
> > +                              kvm_gmem_get_memory_attributes, kvm)) {
> > +                       return 0;
> > +               }
> > +
> 
> This directly takes the address of kvm_gmem_get_memory_attributes,
> which is only compiled if CONFIG_KVM_GUEST_MEMFD=y. This breaks
> ARCH=i386.

And this bleeds guest_memfd implementation details into places they don't belong.
The right way to deal with this is to use lockdep_assert_not_held() in whatever
code mustn't run with mmu_lock held.  E.g.

diff --git virt/kvm/guest_memfd.c virt/kvm/guest_memfd.c
index c9f155c2dc5c..3bea9c1137ef 100644
--- virt/kvm/guest_memfd.c
+++ virt/kvm/guest_memfd.c
@@ -547,6 +547,9 @@ unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
        struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
        struct inode *inode;
 
+       /* Comment goes here. */
+       lockdep_assert_not_held(&kvm->mmu_lock);
+
        /*
         * If this gfn has no associated memslot, there's no chance of the gfn
         * being backed by private memory, since guest_memfd must be used for

But I'm confused, because kvm_gmem_get_memory_attributes() doesn't actually take
filemap_invalidate_lock(), so what exactly is the problem?

> >                 max_level = PG_LEVEL_NUM;
> >                 is_private = kvm_mem_is_private(kvm, gfn);
> >         }
> >
> > --
> > 2.54.0.563.g4f69b47b94-goog
> >
> >

