Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E008BCD98F8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 08:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43A56B0088; Fri, 19 Jun 2026 04:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDA26B008C; Fri, 19 Jun 2026 04:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6EA46B0092; Fri, 19 Jun 2026 04:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79A946B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:20:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EAEA3A03D2
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:20:09 +0000 (UTC)
X-FDA: 84895964538.13.D194058
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id 15CC41A0008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:20:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rdkbRbgy;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of tabba@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781857208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JBFThqra4oV9uqStWieBti5R0y/ujSHcNSXMNdIU7IE=;
	b=Gmr3EC62t9iwwS2GFQXBuQHP3a1wAMbEx4l8ELlpFv1T5++DVhZPE3AUA1CB7DtriJSyM4
	L8132NE4szxzswZLJmaifJEqACvgHKk9d7T6GdYUf/gZV/Z2eojoXmDUcMQLMemyE/a7XO
	6bjdDzfZ2HcQxX3iZj0uxcCV4VEzjNE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781857208;
	b=uxJVlJX/BG1F4EE/kw3E5sRBoivGKuaEq59xnyBuIxKI7sNR3teVkKDjQ3xudDPsLYObRP
	oIcXmmfhmRNfQqaMxb2BXqSgg61pZ+pikl3QuYqdwK1SQcWKrxQAL1aXsHmNmnxBCu2JzS
	0EzbsnHOrS21PeV29YhV0Qb2CWc02ws=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rdkbRbgy;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of tabba@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51765531803so197161cf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:20:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781857207; cv=none;
        d=google.com; s=arc-20260327;
        b=DqvllxTNfrf0k5lklUtJtMo6kjSoTxTHkdiVlTapUrdYTyMKSSKIN70h1Cwd2EJntk
         uuSoszm0Ds5uVi2PdsNtlhBtP8nKx51u9ymJHNmI6LVC3nRvzoNWX/xPSD+pcrFqhlxJ
         icsBxQsGb8Qe4e74Tcysd60haYmqHUZLkmE/Y3N2gVUA3diyoxgMjZud7S2GcrnpOEvV
         pPYeT1lZHHokJVGKn5c/N1VNNRM/MWJ2gBF6T5tJhtmH0Cb9tU+ZLryawOWbVTaKJsrJ
         VFlMQFHVvX5fCPxHlZtH2uTM0VLc0RC4TMclrWfrg7HfZliu8o/eCukFA2k11IP+8rXp
         J5SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=JBFThqra4oV9uqStWieBti5R0y/ujSHcNSXMNdIU7IE=;
        fh=MSON7zj/av4VUtke6HYzJ3z+4raihj6fnDGfbxiFNsI=;
        b=jHJ97UxN9kSgD2xg2L4SLWlsZHMV4PIhmJrZ0gvpfk5eM8GXEq8Ps3pPu8ol5WFleU
         HRKlMd5lRwosLIunYC4gzrN4Gp7hVxaAPLrrPoGI7YrZdxJ00TTeZj/JEyiKI3L2ZrYJ
         VMVsXtDzFIviQh9Z7ScVjcINKXAz6Tk/MLMKgtjH8t7ft5khsjNYjgixJAUYbzZmkKlQ
         /pBEZ9rBdPxDvyBUPCiMbuaPsHE9eepMhh+yV6WflhhprIr+O9vAw0MhkMikYnElGPB6
         JarJn7EpYLVbdFxyZIkncr9dAazOVsAtdiyRsM9ye+ULgKsSEKwYg3yduCTmeFo5mFWS
         2t6Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781857207; x=1782462007; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JBFThqra4oV9uqStWieBti5R0y/ujSHcNSXMNdIU7IE=;
        b=rdkbRbgyBNTECpYvqjnues6aVH/7tJCGp0eckh39n3SyzDouuca4ZxBU/1BuTd7krh
         jkGkvSgxz1yv2uYllsI3219D28a7ht6Q8CaenRTAmlyvhxn7J99nFIM7jyAbd/77n7V8
         2qBDM96Zejb9dtrqsyz4N/wWimssbnznsyGSoA5mxiVS4mUAfkh+OsboTKedMfDPvtV3
         yHQhY1g46etxMQjTyWQMfQeIk6hArNT5T9ieiy3DVsIaRSmKa2Uuv4H2HcrqIec6UXUY
         nh4wX7c6oqkm9N5MNFm7dPG5jwVWt9HOG3xlRUUnbECPOiOI+rvYStZuCOvP6dFdemHv
         T6Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781857207; x=1782462007;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JBFThqra4oV9uqStWieBti5R0y/ujSHcNSXMNdIU7IE=;
        b=XWgTCxkJSNw7rhVs1AveHHqJUTJGilhqj8QsUprQEwDdG9zOzFSdyg6nCvXY18JQfP
         sZjVWqCG41ubh64dp8kuL+Cyp6eKp5fbpM/uXlFoqOtloO1wcUeDIYeFpW3A6G1ApHVy
         XbfcvsxcewEFUr20zeAB3W5NAdEvX3Y0i2shOwgDUO6W5VEkV1sbAJjqk2BdZetBVX97
         sypH/AZvj43lWnWINblHOWWBW0Ss20hI/8gWdgNDkktFuFkshIFUMnzDE4c4Hqb6NJQI
         Q/JEOjQH53z/hu/0GP6aqFx+8Q5qKD+ASnI54eQDtlUsQWqB1ADDmqIThj9P0ELCvHOr
         +jVQ==
X-Forwarded-Encrypted: i=1; AFNElJ80Igl2IFYltmj9cdRik3VDwfvaruy125ZmiEn+94TdtCJC45C5wM1j86HwgyXhRuh4nPWE80bSxw==@kvack.org
X-Gm-Message-State: AOJu0Yy79acf7ao5vXbiUjt7aynuWnlMZ8h7z9Yq2k1BFzncUFg4BD+r
	S6/FTl+kzdY0qZDUHZbowQaY4+/QIcnrLnKDLW1OK+hNUXpVOaj4ha3Nj97YjSS5z4hNfZzIJdb
	S/HEUj1aQvWrmSmSvjpLtNX2tivTLCjG8sBT4UqTF
X-Gm-Gg: AfdE7cm2KGQE8/XVcUfbokCnjU1cZ0UkkDbDYAFe4pp15yloL67d0n4lFRPo4BjgIGg
	An2tshZRIrv/OsRAaGJqW+LdJblJUMSOHFwyzXEIwTvakuz/Y6HgdnOYIx4kbHYU/XimLP7vb/d
	10pe+fmWYqMIsVfjoyrQ5WnVXEqAM0K+Onphjt4Onff2RPkiPQWv3wTuJGzYWHHYUbMgOGImSvN
	WpLPQN4ID1Nocr6PnPqX62XpZx8o8vuoUaAeDGGW/NgX+Lr74aduJ46naKtCo2IGh6SpkZPb4Rf
	gXRovGxb
X-Received: by 2002:a05:622a:1489:b0:517:64f6:3365 with SMTP id
 d75a77b69052e-519e4890222mr6131781cf.4.1781857205879; Fri, 19 Jun 2026
 01:20:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-8-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-8-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 09:19:29 +0100
X-Gm-Features: AVVi8CetDOqUGm8KE1EqJ4bopoK5ozlhUV0GoXpBkC9yvjqeaAph6uDxe3jzIzs
Message-ID: <CA+EHjTw6x-mxDnJjnhE-6SV73tMrb0paKDTtOC2j6zJ1fXZDLA@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 15CC41A0008
X-Stat-Signature: udwiwj4hsc7uipfey83sohpnjue9r7sh
X-HE-Tag: 1781857207-736389
X-HE-Meta: U2FsdGVkX1990KSbHSSvS6gEc7PN7uhzkOnKPZLFyApISCj3jiL56GyHwTSASRXThYOI9B50mJRBbkK1uCieU10RvuJntLFAS+R0g4cm2PIHp2f0M8bIPLkc5EipPm+87lvBogWlwuNDhm4W03OC86BWgvyZnyK1Mc/ZlKiZ87GLGIEsgZZ7v8RmOhxHUUqKlNGOoSlPcvAfyipitO1GM/XUoaLOHGKwsT53Ww3E3T3c5zi8s71Gl7CXOzfvV4fUEOKE/PPva/BDb4wmfvzEDkwy+J72m8EoA9Ig5zh16FviJU0xQb46fxq8FkcV8CGqX42CHLOnchGWgt6bscMyoFfFiBUZuvngtD6iH85INlmeAq3gX/QdbMgQJFYk/4Yr60YR+ShJ3lvsWaJMOJlMI0cX9eRI5Cx5qiJKI+UsGQ6F26bCbl4du26IgtuVaUgPK7nQmzmeq1zSuVPhKHrBZhSmnCBiP8WK0vZTv5Ws3uEj6FpOSapJ78tQ7rTcZsFGMDJYwinK1pvf9NrAtFXAinLY4X2PQaKfFIy8YC+GHXR1Imp2d6dHMnWH34GTFzmKgQyrEJuKFDNmSgug/vzIwbVDc8sdFLUy1RMZzHwk1lyfZwgjGSvPgX8nUzr3hMNS7Oy4W/RCdaLurCEDglXHENJdM9fgYO/R462Zcx24Mxmb4CZYVi0SMc5ASElKWeQc8azKmpBC/Ioaz5q5vh7t+NzRSOVnXW2J9sI5wFokGGWROjijM2C6SJqDdgDETI4pm18SKcwmYKUGsOPEIrgBKzfRERwxsp3UWZyv3iRrta5pO/fbEF6qetJKGHddAXLS4u6ybVkWEz916dXM6+Z8XbGdept9TkSKLqRlKw0O4ekf7yzXw776FxbAXOX2qdJu8H8d7uzKJwavyevNnibqg3ybty0ZhO9/9GZCwg2pI/A5bdw5dMVzZplj+RtjZj3elklkv7BDen0elj0C1lc
 J5i1ely+
 ANrrQ5GRS83OKCP8jN157PA8iaF1Im6lEzYvq1QKcDAW9CYASsyNK3khWuRt+wUNeKbIhKg4zCUpzL2H4BE43M5gcqpGN65h8QtrtIsT9RdLPutXQWHh02wBy1aBQ/YebsLsPFG0WqgGt20dyLby0QjYRvA/dSBQL4JZJjcmaWWxTBhajkKwUsYG+St3RoH8hnaj7oDCOEce50ERXmhOEMP6HCORrHciS8sIm1nnxUQvdlHWuwAOA0cxrEteeSX1zaeNw9D9ZKD8axyZvvL1pXmZTwSVFqCFx2hf/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Introduce a generic kvm_mem_is_private() interface using a static call to
> determine if a GFN is private. This allows the implementation for checking
> a GFN's private/shared status to be set at runtime.
>
> In preparation for choosing implementations between a guest_memfd lookup
> and the existing VM attribute lookup, rename the existing
> VM-attribute-based check to kvm_vm_mem_is_private to emphasize that it
> looks up VM attributes.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

(SoB fix plz)

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  include/linux/kvm_host.h | 12 +++++++++++-
>  virt/kvm/kvm_main.c      | 15 +++++++++++++++
>  2 files changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index eb26d4ea8945a..3915da2a61778 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2546,7 +2546,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>  bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>                                          struct kvm_gfn_range *range);
>
> -static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> +static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
>         return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>  }
> @@ -2557,6 +2557,16 @@ static inline bool kvm_mem_range_is_private(struct kvm *kvm, gfn_t start,
>                                                   KVM_MEMORY_ATTRIBUTE_PRIVATE,
>                                                   KVM_MEMORY_ATTRIBUTE_PRIVATE);
>  }
> +#endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
> +
> +#ifdef kvm_arch_has_private_mem
> +typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
> +DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
> +
> +static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> +{
> +       return static_call(__kvm_mem_is_private)(kvm, gfn);
> +}
>  #else
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6669f1477013c..8b238e461b854 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2627,6 +2627,20 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>  }
>  #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>
> +#ifdef kvm_arch_has_private_mem
> +DEFINE_STATIC_CALL_RET0(__kvm_mem_is_private, kvm_mem_is_private_t);
> +EXPORT_STATIC_CALL_GPL(__kvm_mem_is_private);
> +
> +static void kvm_init_memory_attributes(void)
> +{
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +       static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
> +#endif
> +}
> +#else
> +static void kvm_init_memory_attributes(void) { }
> +#endif
> +
>  struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
>  {
>         return __gfn_to_memslot(kvm_memslots(kvm), gfn);
> @@ -6528,6 +6542,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
>         kvm_preempt_ops.sched_in = kvm_sched_in;
>         kvm_preempt_ops.sched_out = kvm_sched_out;
>
> +       kvm_init_memory_attributes();
>         kvm_init_debug();
>
>         r = kvm_vfio_ops_init();
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

