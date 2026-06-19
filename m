Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ECB9CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 08:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AF546B008C; Fri, 19 Jun 2026 04:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A176B0092; Fri, 19 Jun 2026 04:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1E926B0093; Fri, 19 Jun 2026 04:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A99B86B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:22:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA00E1203BA
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:22:35 +0000 (UTC)
X-FDA: 84895970670.15.92EA0C3
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id F170840002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:22:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZecZm81i;
	spf=pass (imf01.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781857354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WecHCv13rG5Qr395P8gqLpoRjr3ajKQ15qH0wjMFBvs=;
	b=T3P8b2xsEj2mIXHKUZ5nkHuCKcFr09RELrOKZ9HEJhspha3IOSohireg+nftLrNbWOYrPE
	OIgwJJ6x/lc2nHzogAL+DGgFckgMRD4/u2N0kxApnL0bmf0nn2sF9iWjdt91TETcPJGXs4
	BZmvCDgPGArPV1fwxfTwMPkUuy465ac=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781857354;
	b=IJMPi4AAaUYDjyXm+8ddNY/+2gtXj/V6h7WT9ZOeK3jNlay8qbetrVTnEwxGHEI4UVq7SS
	cV18HSCt3cpYcXD+gD/6cxkYlHMEXOGBx3ZLEshAoKn/THafI4OYGy/ZF6bGSQNW6lnl6m
	2e4fK82yl+v+X1CxI2IUvBjHBA6qiOc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZecZm81i;
	spf=pass (imf01.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51765531803so197771cf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:22:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781857353; cv=none;
        d=google.com; s=arc-20260327;
        b=qHhYP5BY1580CmmUaIvLjaxavxRpp+tbUyFSlOPKCy/n7nRZ6T0ZAnr3+JYOMXv/nn
         qK3WSejqWq8bVo0eCaDxt0TXEUWAzbgbKr7S4WenrC1YUKeqtKPu3A4MocJWfrZzVX3e
         CClLdHyDq0ElkZqtPCcThr1Q8qJtznkc/O5meb7vWzIxZwy1W2yBOKi/PwqslBiIyFUj
         mkPJ5xKDtxQbzDZB3m2dCKVhGwZtZvsS2V+9KoqWMPq7UP3fw73AyaugyFPqWvCBbsWS
         hexMkUN2sEjSyPT3qPMAGMsLZQWF0jEofb3n99QLcEMWRCOnaQNXm7TMu0KM8seQvaWS
         XuRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WecHCv13rG5Qr395P8gqLpoRjr3ajKQ15qH0wjMFBvs=;
        fh=wDhTTjRa2kX17GXVjTzrktfYgiCiwJBwIlzBCdK50mk=;
        b=C70SVakVm4nU+jAc3OrT5xUrEr5xkoPmtTkzrHhGn/UbDXZR4qLhAFC8qL2U2d8w3/
         nPfYNWNaPaTI4WY1nbTqHrX31xJXnhp9FmMh4UHIgmoNNxpt+Ef8atK3Cfu7S5SXUCn9
         RSVGaf/gEZUYkVuxwG1hL4p9mdu9RjuT6qboGfi3S6jVxVOOgLf/OeRg/LtcYnnT/+MJ
         D4nCSa6x5CXc8dLzlWvocJqxpLk114H/LwaoBREu7diPAC64R8IDKna6O9XfXRsQljBB
         MQdkdPQRGGHylCAk6Sz4cJltYfUmvimd6XwGWxw7vy/IxoEa0bkTr0Cbb2kx8FnFdWri
         vp+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781857353; x=1782462153; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WecHCv13rG5Qr395P8gqLpoRjr3ajKQ15qH0wjMFBvs=;
        b=ZecZm81iMFFsk+Io2KOOhzKFO/a2CnlXEqUdEvtin03iQYcNS6pVnBKyXhC4zVisj4
         bqYAczCXDfUNobPLHs9ZJ5kTQ3WjqdH7UBD3ov+xmoMZuuoQ787YdzivNCh3UFJvJTqQ
         1cyJL8LrBhe3yKWsubxWnddsEPTtuj1INXc1Y+kRSkeWBGEHLWjejpPIbsQkojBvCSLR
         a/JiwqXJoJUZytCsdwXqC/MZslIwOXLPMXhJm82h42MdkK+shMeDLqjoHVMD4BDXZpJk
         oYFfy4oiHb7MxwlH+omjrVUsRksYXgn869zydYPPB8NnTiIfiz3n5jVBTgk2LZvafDJA
         mxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781857353; x=1782462153;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WecHCv13rG5Qr395P8gqLpoRjr3ajKQ15qH0wjMFBvs=;
        b=aC834Ca5AyJr0w7vxWGVJCrA3o8k9culPmNgrV0RgKYadi+i5LNp2845jfIoMVOEAx
         zGh38yh3UPH6kW6RpAv6jhDSprvMN36mOLoX5OIpPbXe2g0Fcnq0esy7c+tVgoi+G2mY
         kBG48G+wUSfajuFejdgSHEY1t/GOYT6mQRqbMmnjnNXdJqKRvsCtSoXCGvTukldUptqo
         iIrayvvWJgXae0WO7geZEX4kRc170wXWtO0tZHnlFwOM9FHwKA+BjFaPEAbv2JKGDz+I
         E08geIJUx5fLhAbMauvi8SAYMKoiJEBa90hdabMh+8v65PIX62NLNVys3RMwCIV7cleL
         +eBw==
X-Forwarded-Encrypted: i=1; AFNElJ9330U3/4C5D9qusxzdMw+ZsstJ2cBLjEVMUPU8o2o2KL6FbQcOMNMekSeklJV4HWHOP5IBLx6NRA==@kvack.org
X-Gm-Message-State: AOJu0Yxwlnw0suH4HO8VMVGsrOiQ6yB8GnlSCLmbKeYjz2/EpEdqx5lx
	zBqGrS31poy+0/v/5O2tTI5oHMPiivOXTA21167B7Kr36tV4MXwjWvwqzDFLZFhHisK3h13op+d
	r2M8EYcYG47OBqEJov/FCCP4zzuTmYyvv8YZewa6r
X-Gm-Gg: AfdE7cnZXHM8VL/EGXLJV7bY/QDSwKcMF1YdqeocEsM6yLaf7+w73+OrGsKlQPnjQtP
	nSS5FrnGAv7r6Xl5IYuc3M8uL+LQYvJqxJ7KS7P0yJDdrwyQWEofj6JZ2wme9Hlt87yI8v3BFBj
	qSA24zX78+43RmNYLMOmvuP8rVKiLfQfUm0MZnwinJ/8ODU54TMukgd+eAg0ilb7XgbmMXnaFZ4
	LSBCq3IXQe5zv2DCJH7CINFQwLGj6AT1SE6ZuXmMJxdUgtO5hqtwxqR9Y4vhCUfccIR9u6tjKX4
	BGRbhVul
X-Received: by 2002:a05:622a:1b1d:b0:516:3def:1cf4 with SMTP id
 d75a77b69052e-519e877e8c5mr4724561cf.1.1781857352209; Fri, 19 Jun 2026
 01:22:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-8-9d2959357853@google.com> <CA+EHjTw6x-mxDnJjnhE-6SV73tMrb0paKDTtOC2j6zJ1fXZDLA@mail.gmail.com>
In-Reply-To: <CA+EHjTw6x-mxDnJjnhE-6SV73tMrb0paKDTtOC2j6zJ1fXZDLA@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 09:21:55 +0100
X-Gm-Features: AVVi8CebV0NVi3MbMdc8DhRrav01L0h7Tt3z2YxRqWoRJXqhOu4WExRErk69dGE
Message-ID: <CA+EHjTxu32nQ+vPV7Zmcw76_-V4g2_g=P_UzRnnO2dP1PFO2ww@mail.gmail.com>
Subject: Re: [PATCH v8 08/46] KVM: Provide generic interface for checking
 memory private/shared status
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: F170840002
X-Stat-Signature: nmon3uojbob4jugmhuw41ky38q7gc1sy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781857353-915389
X-HE-Meta: U2FsdGVkX1+I2Ssqb/J9pdVKn2TaUSxZSVHlYS+uHb1Hy12Nxt6jgx15sN6rknST4NGJaRFp4wNhbNyQrxUKeEYWLbRQIgeblCzVLvXe3gbSDz8Sska4DraQlRZ68ge2BKFboZJ1GNZR7Yms4XEMvGGQcJm2Oi83JIejt91vKl5WuqwaRN/n9LLB4YOWal66DVtTrr5P0WsQqv+8aPfeQyj1DV3evOGgRvwbWW88o8+HcfgnOROhj9TiXPgAMpdwavEKt+bYZ1P+rNobLMTKnC0/CWS3qT/HQbbrb+7AXI7ceRFXyshSq242/b8Yo4gcz2N7kqzhmTdLIDIC/QBBW5KI7JMseruh+5HAqttJML228cjWqlI5y12xRX0LdKWK1EGmQ4kIpUHCNWYpLhERGJeFmZBCMFoLx/VbygG1BBfSdFvgZtsvekuC2fyBuambsxaW2j+0eflcQFd6yAJVntLdK1lG4AYuEvWa82UO5iF3X2iRlaVVBsLet0lg2I9xC2pCc6CAQpj2UPaXUXtUfYKBcCFlQiMEDX0Z0c7axay6Dj6nQNrN/JI4B2zZgWHRU6E7I7SZU2evtpesfd305wW0y4GoPu6S4FSktcQnWygGx6Dfhlu24+YFTGXwq0usGcmbRO16OHss2s5PeNylfbaerL0C7PQgwsV541F2a6jEBNiie+YQ9o+OXGprqiDsUWyUFpHYOXrvZ+s86VCBkQfsVBYKtAhNDxD0GtH7z+fhTHLRhrlxpydpi06LyYxh1nsdKuHlZbRzTeo7pk6rCAWbC3K5hoB0eVAyiXLcjQQUZo0l47t0hU2FivKR2KE8NQ06M4+uJhBj99m0Eo1N9YYxlgSwF8mcbXyFWiqOgfqJFuq0zN45DC9kmcPxhXk19CiA5VScOMURL1GqY2FmxyMUye0a0l1wJpe0P5pRDiBa7LhMMYkDjDbF+hLa+au4JMt50x3UBJ4tjJ08BdN
 VaiwQcTH
 MmZHGPoJmcXDG7O7H7atkGsmxEq+NffEWwLyuKOt9GfXkPrkG8hKjqIwZAd3hlaPOfb4Soo0CZHlKARdkWDvqHLM3SFTgpMqB1jIDoyyd+SJQzeT2jl7X/JOBjjmjkPeZjO91YZ/8X15w6G8qqN5Jwxvgm1nW2Ez2vKEY6XHvxl2Jw9reedCBhmho/5098ncxSQeWQBLTUOv/NwRdgH/FjsoWKEitnTqd468sbSVD3dUXamYwp+AhXbNeuoL8oo2fIDnXHC6p2MRwTVj7iq8R2+YFOA4pdu40kEUH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 09:19, Fuad Tabba <tabba@google.com> wrote:
>
> On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
> <devnull+ackerleytng.google.com@kernel.org> wrote:
> >
> > From: Sean Christopherson <seanjc@google.com>
> >
> > Introduce a generic kvm_mem_is_private() interface using a static call to
> > determine if a GFN is private. This allows the implementation for checking
> > a GFN's private/shared status to be set at runtime.
> >
> > In preparation for choosing implementations between a guest_memfd lookup
> > and the existing VM attribute lookup, rename the existing
> > VM-attribute-based check to kvm_vm_mem_is_private to emphasize that it
> > looks up VM attributes.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>
> (SoB fix plz)
>
> Reviewed-by: Fuad Tabba <tabba@google.com>
>
> Cheers,
> /fuad
> > ---
> >  include/linux/kvm_host.h | 12 +++++++++++-
> >  virt/kvm/kvm_main.c      | 15 +++++++++++++++
> >  2 files changed, 26 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index eb26d4ea8945a..3915da2a61778 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2546,7 +2546,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
> >  bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> >                                          struct kvm_gfn_range *range);
> >
> > -static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> > +static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)

Should have read the Sashiko review first, but where is this used?
It's not used at all in this series...

/fuad

> >  {
> >         return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> >  }
> > @@ -2557,6 +2557,16 @@ static inline bool kvm_mem_range_is_private(struct kvm *kvm, gfn_t start,
> >                                                   KVM_MEMORY_ATTRIBUTE_PRIVATE,
> >                                                   KVM_MEMORY_ATTRIBUTE_PRIVATE);
> >  }
> > +#endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
> > +
> > +#ifdef kvm_arch_has_private_mem
> > +typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
> > +DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
> > +
> > +static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> > +{
> > +       return static_call(__kvm_mem_is_private)(kvm, gfn);
> > +}
> >  #else
> >  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >  {
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 6669f1477013c..8b238e461b854 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2627,6 +2627,20 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> >  }
> >  #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
> >
> > +#ifdef kvm_arch_has_private_mem
> > +DEFINE_STATIC_CALL_RET0(__kvm_mem_is_private, kvm_mem_is_private_t);
> > +EXPORT_STATIC_CALL_GPL(__kvm_mem_is_private);
> > +
> > +static void kvm_init_memory_attributes(void)
> > +{
> > +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> > +       static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
> > +#endif
> > +}
> > +#else
> > +static void kvm_init_memory_attributes(void) { }
> > +#endif
> > +
> >  struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
> >  {
> >         return __gfn_to_memslot(kvm_memslots(kvm), gfn);
> > @@ -6528,6 +6542,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
> >         kvm_preempt_ops.sched_in = kvm_sched_in;
> >         kvm_preempt_ops.sched_out = kvm_sched_out;
> >
> > +       kvm_init_memory_attributes();
> >         kvm_init_debug();
> >
> >         r = kvm_vfio_ops_init();
> >
> > --
> > 2.55.0.rc0.738.g0c8ab3ebcc-goog
> >
> >

