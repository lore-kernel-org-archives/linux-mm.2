Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA353CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172AE6B0005; Wed, 20 May 2026 16:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123BC6B0088; Wed, 20 May 2026 16:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012246B008A; Wed, 20 May 2026 16:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5EE36B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:39:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8DE2B1A0418
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:39:15 +0000 (UTC)
X-FDA: 84788963070.11.630FE6A
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id D0DB31A000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:39:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Px+LoRgH;
	spf=pass (imf19.hostedemail.com: domain of 37xsOagYKCLYoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37xsOagYKCLYoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779309553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGWVowUBUXf4rcBcRgB2FD5jKsVoidTqoHPe2NfYeqM=;
	b=TIhYt6MUJmFEcK8Te8Y6d4CqXLHLng0EWRTEHyNx6tuiRrvO0nQsCueu+C8sdZUepTccd5
	LnYBLNHt6SgNPwsvRBlFg7BhLKljlTQgMkqq7BhOoDjeCD5uYIv/Vao7m0Fi6CCBwha7x+
	WS96Fw3FQuP2BT88SoZnrX0RENrOMLQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Px+LoRgH;
	spf=pass (imf19.hostedemail.com: domain of 37xsOagYKCLYoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37xsOagYKCLYoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779309553; a=rsa-sha256;
	cv=none;
	b=bC/CyQe4yuorcaVLavo7YcryQ+pfJmLe92pffPTi3o1LBjqQSnzkdeiIqgylmOPLbHimkE
	CUgSprRAUn7FiHbaFjAiBiOq1GYkmg+5Q68Hne2LdD6niTks+C7uR+hwRkYnNU1ptfLEQ0
	5P0f5u9zGJUSD93dUhMAZNTaEWPvMAc=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2bc6899bfb1so52674845ad.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779309552; x=1779914352; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dGWVowUBUXf4rcBcRgB2FD5jKsVoidTqoHPe2NfYeqM=;
        b=Px+LoRgH0VXWNGI+4Meyxp5QGsrqJfWLTw2SueIlbRI91xxZ1feEbE7Y6nEejdnfCo
         PhKXlBqwTLJntMI9Dog9z0gnlwyV1zbabLsygtq7yYK5u2c2Q6xiIMSJpM/mKS3KFmut
         kjYiGu9Fw2CdCpNeQvW8cIOiA/JVt06qjSk3q342zlG/FDGXK/oXTZG2kwz8dtHNECDW
         x9JR+DxZxIoM0WH9fkpAEu9jfy28bOQvvEipqrsi4I2oaUE6i26pcqu5q4JblnL2I8bq
         DV/ea6MU6TFOm2Oiz6BmnBGmyzUl+pNM+TAsAVQ9gnCWNdXoUwY/ShSFtkjLPO8eb3jh
         z0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779309552; x=1779914352;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dGWVowUBUXf4rcBcRgB2FD5jKsVoidTqoHPe2NfYeqM=;
        b=EwRo+ocrTQN5HtOGxuI7VSVKcsHNv+DCC/Dv/7aZjKC7DywJvyjPMu4AShWhG0lm72
         jhEyv1SIFTlB1cxLP5TSiL+qUs/Tch7YpKJ8QUElytW3mu6tzWdOoqDFA1NlYTiVKmG6
         RSKOCcVXFbPNmMRg9ZnLJc/0TI5BfZFps3mLXUmYw6sxvdgxj78FLokRBl6wVf8ThDmr
         7tUkLnFJsYdQw6QZsVM2okXD3W03SPxd8FHe1nai9Q3GhecGzHqMPu1TSTCW6gyWfKUv
         tHR0T0tdnrEisHPPYs+NLzxXlmPxMPCuxELM1H3j99zmyM8Gdaaz8pSebp2PjXvtNSnC
         Mdsw==
X-Forwarded-Encrypted: i=1; AFNElJ9fghlGqGvxXjuiD3Bi4WX0Z+KbQZnnlhfpX5gu0C+Gj28G0SgHCVd9RR36Ph8fdvAlHLKlmDlTpw==@kvack.org
X-Gm-Message-State: AOJu0Yx7Vlwux9WVk4hutXmvEdcHOTJ2TJSNT/bdUZhrzgRm5PF8oBXe
	hhNKX1DouwvUpOYXjClLuR+hVywIFbk1lsha+egFpdR4HtDCpuGYUh05JCVGGnUEOlq3iwiFdq5
	oP2UCOA==
X-Received: from pghz21.prod.google.com ([2002:a63:e115:0:b0:c7f:c4f1:ae17])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7349:b0:3a3:17f8:bedd
 with SMTP id adf61e73a8af0-3b22ea4f434mr28099153637.17.1779309551955; Wed, 20
 May 2026 13:39:11 -0700 (PDT)
Date: Wed, 20 May 2026 13:39:11 -0700
In-Reply-To: <CAEvNRgGHHkvfJ-mn9rfDvS+_1ht08YatFWo-Swt+5wFSPnC9Nw@mail.gmail.com>
Mime-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-6-91ab5a8b19a4@google.com>
 <CA+EHjTxvLU4XDPXDXYXXWJES1OFQgN8VTRLMgCCNMwBE6Hk8tQ@mail.gmail.com>
 <ag3DawWCcrpCkD0e@google.com> <CAEvNRgGHHkvfJ-mn9rfDvS+_1ht08YatFWo-Swt+5wFSPnC9Nw@mail.gmail.com>
Message-ID: <ag4b74HTrFZQ7bra@google.com>
Subject: Re: [PATCH v6 06/43] KVM: x86/mmu: Bug the VM if gmem attributes are
 queried to determine max mapping level
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Fuad Tabba <tabba@google.com>, aik@amd.com, andrew.jones@linux.dev, 
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
X-Stat-Signature: 7djhz6as7ewi49is7dephadp35icxk19
X-Rspamd-Queue-Id: D0DB31A000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779309553-713611
X-HE-Meta: U2FsdGVkX18/qegDe0fc7ihKRw1wo1EBpWUJleE238EC7MEE78m40kTcI1a2qbtn+X3cssyNcRI16rN4fwmDxGgjM/tv90mqyc0gdDp5ni6VDEyAd5SIQMC/RocBWaW86NxDnvR2FpX1pO/hIcbS6V+l/QTXageN4SQSdF1aDBXEGwiyJmpYTB/ztYUcviQlpvgLdclxFUWItUYQf+0TfjOuJM2NMa7zHPbqqD6LiMjBrdqfNsBVuzcF51VNS3zTtsNhXQHACm+3u41KpptafrFJPt1OFbpXBwvgDYGsRNQ0+5Kb1FGe0U0Ztn5nlqj5H889nDcV3fOr2LjyBbVBYVG3C9mJlDRP8DMnH6/A7RUeb90g3zv2uOfUp2GGVtXkVABEZ9WeNih8mYWBSyM6LFd2uGxM8JNDPk9DX0NFoOveAgfgJTlM9s9mYkEPU30cQt1Btf4if7SlnPO53iXriHrn9iZGd2Heiezes5V9DxAUuBbhQfT7K1jnKj0/ckHF8AdDG4ex8gzuKJVdDvDsX9zG75O50pl4X4kcgdD9/BHJj/a8EL3vZPERuUBsqGJyncJLJ5Hoh/XO9bOmWFgCdWWE8bdWbn+zNO2o8cesj4sPwrBwyqmxFuQY23soVmTBK2bcYPuqiUVuCIdiCiitr/4qpmq8zfEiF8b5Xp6BdepGRapJLb6KjRK9NxcZGMobTUVNrkUhjf8qiLoIVmBdipq1gRUxd07d7Fm/+dshrQ/qPd0499e2tIN9ydfzd6K27Qz47cEGcZJ5qdoo842C9Zf+Nl1BHTvXAfIE8my/jhnRvChQlsD/q/1997JV4iHge3aUj/2ECun/lAGRyIX/GFkRUFek3HiNJ9UewneACDmoJpavzMwtkXejBcxWBEyaDzOXTy1QrqITr0asUcPwwP2SJ9byBzYEHLVhT96LkHe71gEKf/w6FaWR2uzf77RJntz7qiwICp8NeKm7g4g
 w5H4FFI6
 FRa/EYpn8DXRQ1O4j9z/F0xN2WLD1RmYGgHbSsTfKN7Hxt/hmQLp9XdWP+IODU0OGAk5BMZefDsmhjWIzs9vpF0zw8A3X4I0z98i0T3ZWLUCUJ1xLW61z4LzCiKlse2NCJfWFikHZ81OGlcpxJ4Cn2hK67RhdPzuD7YyD2F7wunteVUB66Bm1jYC5R1oTitMEJ5QpFwGRK0wtPuAapNoVoLjKz4iZ9iekckv+8TvdoobcYomarVQ1IlVk2CB2EfK/sHzFl/UtKyHNCpPS/U+QxLKfpoxbZzVWynakf9ERHUWIXdHxFQIFyPl/Js+ZI8RnaNuLrg8mv61wXCKHGp+oZWqlntyz5kzaWbF17UiwoMqAVhFzKj/SFwzd/4y5FBVpFw8YTLjN4SxGZJ/xFaJWg1FaJnDRK5EB8AIYuan5GwRyEykVkBMd6PEaXr9E/ZXo/oRbgSaGRrN1qE9jDpUvXPY9OTPiZwOHunmyWGxJL47XHV8K5/m6SXrEHPeKULPy+N1DG4Hsxj7VsXYszX2pfyc1mYXXoXBCrGzkyo5CEzzKoJ55uvMj1t7dC0Hkdn2MUvzu+yDg5c2+wJXdZUjVcJ5Q8t+YUSYawpWa5mBle4j6aA5lWU2yew7ZoXRFZKto2My0vXoVn3MVbIcOEaXTTkdqt4bJTL0KOigJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> >> >         } else {
> >> > +               /*
> >> > +                * Memory attributes cannot be obtained from guest_memfd while
> >> > +                * the MMU lock is held.
> >> > +                */
> >> > +               if (KVM_BUG_ON(static_call_query(__kvm_get_memory_attributes) ==
> >> > +                              kvm_gmem_get_memory_attributes, kvm)) {
> >> > +                       return 0;
> >> > +               }
> >> > +
> >>
> >> This directly takes the address of kvm_gmem_get_memory_attributes,
> >> which is only compiled if CONFIG_KVM_GUEST_MEMFD=y. This breaks
> >> ARCH=i386.
> >
> > And this bleeds guest_memfd implementation details into places they don't belong.
> > The right way to deal with this is to use lockdep_assert_not_held() in whatever
> > code mustn't run with mmu_lock held.  E.g.
> >
> > diff --git virt/kvm/guest_memfd.c virt/kvm/guest_memfd.c
> > index c9f155c2dc5c..3bea9c1137ef 100644
> > --- virt/kvm/guest_memfd.c
> > +++ virt/kvm/guest_memfd.c
> > @@ -547,6 +547,9 @@ unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
> >         struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> >         struct inode *inode;
> >
> > +       /* Comment goes here. */
> > +       lockdep_assert_not_held(&kvm->mmu_lock);
> > +
> >         /*
> >          * If this gfn has no associated memslot, there's no chance of the gfn
> >          * being backed by private memory, since guest_memfd must be used for
> >
> > But I'm confused, because kvm_gmem_get_memory_attributes() doesn't actually take
> > filemap_invalidate_lock(), so what exactly is the problem?
> >
> 
> Ahh I can drop this patch now. kvm_gmem_get_memory_attributes() used to
> take the filemap_invalidate_lock(), but after Liam pointed out that
> the attributes maple tree should be using MT_FLAGS_USE_RCU, I stopped
> taking filemap_invalidate_lock() and forgot to undo this.
> 
> I'll wait a bit for more reviews and then put out another revision
> without this patch.

If this is the only issue with v6, don't send a new version, I'll just drop it
when applying.

