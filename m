Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74213CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 11:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6FA6B008A; Fri, 19 Jun 2026 07:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67EE26B0092; Fri, 19 Jun 2026 07:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594846B0093; Fri, 19 Jun 2026 07:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25ABF6B008A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 07:03:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8EC361C255D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:03:29 +0000 (UTC)
X-FDA: 84896376138.23.FA1DA69
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 888C54000B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:03:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hiQ7oeHS;
	spf=pass (imf17.hostedemail.com: domain of tabba@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781867007;
	b=LAQznNO9e/9sMiDQU9jqnfUjBa14quIVWTqPT3MZjQJp09Rdr/AfbqOCHttTjwC5U/1gKx
	6mrXCqrVKrMhWOd4+tczN4P3UPkxVskFK+/76FZhQQcK219Zwov/1WIie0saxq6FlwLT6K
	zkSkqPH7+uxHj3VKC0aPb4V3xGmHbjo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hiQ7oeHS;
	spf=pass (imf17.hostedemail.com: domain of tabba@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781867007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjw3cW/Oozrva+KBRQ9a1eMgdLYrVdyOI99ohvpEcUU=;
	b=8oLFaT+gub8Cl3QXE2fkap1o5TF4EonogtB0nrsLIVj0uCfLnuIpKPiZciVfVaBqIfHNix
	a4pHnVONtqV/WhiCXUe4c7L/dkF/z0klIFSf+U4BDDMNhq3ffHSN53Cd5oOhUR7bvrpxzZ
	vnwVo1v86l3fwn3a/dYVp6X5proOhl8=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51765331535so158251cf.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:03:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781867007; cv=none;
        d=google.com; s=arc-20260327;
        b=H9Ev5RHULA0SLjy/if2f2iHC41XAS+u67DD4nK/F1p/LsiUTsrMWlJE50P0g98d2Z1
         NIPctHBtV9S8dfRZ1fx2Zik0Bd8EGCNJ2JgVhCdw5UlTZPYAFvqmkSd++zDe7n9zzaxf
         sPYlIxcxXiM4LLdr4WLzK9zdireRohI4SqgT7/Tos2O57smSwn0PpWVOgVMJtidqMhK7
         i/WhATiGAVNUHrLne08rsDxr07itVNWSq++X737i6/sGX4n8NFOFP++sZww10ieWauhx
         mx3m70oqzgBGGNC4eoYs1jluK4/heTQsPQ6DSTSONwqWT/AeI7QFe3mIy9a6zegFTN8+
         Zgng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=tjw3cW/Oozrva+KBRQ9a1eMgdLYrVdyOI99ohvpEcUU=;
        fh=/DHQ14+YQb5KO+EVTJCYrSVNimOl5zBXmX4MFEBd7AE=;
        b=qZw3iIDm0aaKrcyYGlz0gTKP2IbEDzoom2uC0GBR9Qr+XGRLUCde51h3F/Y7wKZ3aB
         XR0jikrNq1GYPyMXNV7ff6egKJiEl780tB+sm6ORtdE8rGnZ1JLUxM/ofgdb7Vli1a80
         kP5Sgfwh5NKzyb+nMD/wfBznn7MdI1e4n+46dor/QECmPZCPgiaGi8YnHbB5tVGLht9Y
         ftLfiWBVqUqW/YVAdTg60JNYygcU+COi2CEKdmym9rVAAiOdX2Oy3U0jK3yTVwm4Me76
         Oib9n2SuMzvEqXpOQEAI9+AfkoGJ12uf504LvbLJM3m/leCgDk46yrsKV+Pqlnw4yeHj
         fY2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781867006; x=1782471806; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tjw3cW/Oozrva+KBRQ9a1eMgdLYrVdyOI99ohvpEcUU=;
        b=hiQ7oeHShYeL8/2HynN8mRQzFk9eEciUkxyB4vyrskgHfW27BiViQ2R+YiuMmrsAZ8
         xZiQfcTCe4UsXS0vgEhzJy/vwEZmEuGc3WKO9iD6fkwk2MJO2M96YnDhXaX6HqsH+YMW
         1c1DHn9qxoeNwfYF9U5j+b6m+Ofs7F9LsavNm2kOZza4ugJmWQbhX7fKyOhanKevTWvy
         EWiMv7b0sKC1frVoxQ0UzUgudeDH3JVu5VR/9Mj/z1UgIgsb/t206pvNRroLJvhMlT0j
         FhuhTzeEdByogLKo90DaR73Bt3a7pFUgX7njPiU87uh2w3k4EWzsgdw+aIUR544z3hly
         JS7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781867007; x=1782471807;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tjw3cW/Oozrva+KBRQ9a1eMgdLYrVdyOI99ohvpEcUU=;
        b=hxgBO9fKqsmIxVvXGV/s6yPyNU5aDNn2Ths4l9aVoLXj1nwdg829GWx6MOWcT+AXgo
         NFnhXcHGPP89uQVK7y7NQgQLI1gM1HEFSXc/xexGQdz1iu2cL89uwWx2JWC/RsxWowdb
         SqloG+m5M8QC1q+XpYdgZDnJePHGeDrzehZC2iVNMwPlbUSkxoZpXw2okJbSyw/TVldB
         uZj5Qu0jAwLbkEeGK3vI5EEgLuZOsh+SKJGb6rnSBG5OyHgYOqNEZO8oqRM/gXhW7VP7
         FyOQ8/KYWnckcbL30wakYvUpjgF4lLuYq6Fm54znN53vumlB29smY/0Ej8jtzYBDkC/h
         7GCw==
X-Forwarded-Encrypted: i=1; AFNElJ8ki/qrrEI0rB03X9/PCjrvF9Qxav3trBIbGDtmwXWia8VUOkf3qerg2Jelf8N8qHCmk7D5f1/9zQ==@kvack.org
X-Gm-Message-State: AOJu0YxCZvROtWOmRstGojIwQZ7nINmMdyOwfmHcWfXJEw+1Tvd63+jq
	ZTHMXTf+BDxPJxChBbNw6JVUhMvTFRKUQtCmPtR9JqtzAYroKWZyFEbDO6guoqG6sO4uhgNrZcX
	G9FMw5ChFIybrgMyPT3aD4aqJ3IwzbD8AeP3dF6zG
X-Gm-Gg: AfdE7cl95YYW/3m1a8fD7wJw0DNtOuE53L7diEpEBFZNpDX0lHMF9a8fdj2T8X+TNiz
	058twY/1GexKl2MwAY58w5Gq/aEYKVkSL5jYv9bhCdnAlfisn4sTvWTA1P1dZrm6N7LE80rc0z6
	VcUfEaFSp77bOFhMSNg20Wl6gd4vac6Rg0YvtOKaMFZpSM8KGdgGd/6jc8l8emihkoTsLJEhZQ/
	5RmIP8LN2wongpufhYFTtdz5Xb8cpb9bxGt3e3pRUjaoT10kBtgYttH6HiWHme3yIRd1Z9oGw==
X-Received: by 2002:a05:622a:5a12:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-519e878bcd3mr6572861cf.1.1781867005698; Fri, 19 Jun 2026
 04:03:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-11-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-11-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 12:02:47 +0100
X-Gm-Features: AVVi8CdeH8_e_cqUhrAt8PYHFeMtnUwZS7qxotCUws3_NP2cjS-AO0E0Squx-po
Message-ID: <CA+EHjTxd4_x-J8DurWuhPostfZqsxMUV87tWN5GzLCknH5wfQw@mail.gmail.com>
Subject: Re: [PATCH v8 11/46] KVM: Consolidate private memory and guest_memfd
 ifdeffery in kvm_host.h
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
X-Stat-Signature: j9ugbtu49x56j6abzybg1qfd3td1oxsn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 888C54000B
X-HE-Tag: 1781867007-212925
X-HE-Meta: U2FsdGVkX1/fawCcZMSZGqznv4xBAAFSh/8jDsW43vqEIyKCPKAnCvQcZyRph3xwU0m0WFa43qbbO1K9dVowmz8IHHBZ4rmFCN48rgeRxX6XAhRtSRAWpeX7j/GZgNr0e+xV4I/xdTzlWJ/A2lB0CiER7Z/uqgidIOs7oRp2yUGBjCsWxmcxJaBoH42iLyXIx6Ax9pOlzOlse1EcElH2dTebs4pIkAe9jZpm7rhTXHe2I9akDPLNnGNOXRk5lsWF7T2BJD6K/2u9dFe2EVNor/Bvc8OAZnMW74omSl4GJuvGJH2bY/gECU7srfGhT2X7XFNltAMCMYHL6mqoWBGH1f+9mSKT0puTtt17WyW+lwwV0DuvQ/LD2D6XuelPMq7KmaHPbdJvNGirFuUB33vkAAxjI8Xg3/TRZmStOuWMimU0H4F06CAp9B9pxy9hAV1LJnPQ1oe/0IKOQ2zj9C/xs6wzIxHCOnH2PcEh++NUxWpq26fvUmcs+8fsiGRrQhBjeoPpil0HyYghYc8uJX4uiX6FgGfPTk2x6sixEvEOV6QWy2Oxn3fp53r9Wx+dvhM1YKydOwbslmOpE6MaDDpHp7WOOw9XOQQein5t7pqtwfvt849BbrRoM4wmkFOKp3KJ5N8RUU9ZxFdcufaOp9dzhlmfAhTUtNXiOMfU4LjGcq/teJyMkovB/cVLI/mb8NCmL5vmibmkbZvUckWI826CcEF3V/UPy4lO16cnQKBRBGE52cSzAIdaPr8BTuQK0Nu7HSoALJppmYLjAQv1ULWAloWEF2yWMu1kVoaur8hSNvbQ3Fmh6CCuwhr9smx/xaj2OKtLMLI7rh0yisWV/tjyWyUoKEUi/VP+ZdGnzCEgB6HejjqlOjTH4y7zxFJoWHv2GMMEIyHaGD2BtQw7jy84v4EHajvuQ9LWnnbgaE3sWDyvtxOOcwZ5cxIzKozYA0hMJMWrp3vce0/rm41msPE
 kj/BXxTq
 PT8M1wc3BTEZzU0R4D9HUfIV5uV7EmRcOfG+v9h8gGdghAutNn1ZWhsG78mKg7tTaCtBcmrqe33nEH6GxwhKKz7gy65RbwFi74qtxdoCRDRe+YIxnouIRXXCmsvSj5LQnf9e8Yuwmq6ynWEecjTUdfBUHX4IQ1jTgK7u/I12/7i4gkwmvS8Z50q+SDrimnDnLYFUx2KfWXPp7upjCXO1OADnp6W5Mn4wRcGVpqrfiFauKrKSZOfD8pAquYK5EM8WOImeDLYSDvRCx2FLEAbAMTEfveQcNwpXi0Oz57CdmDu/+c1lTiPYysWG/imkonQuxb1TWQSKIqp37Ku4=
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
> Move the kvm_arch_has_private_mem() stub and a few guest_memfd function
> definitions/declarations "down" in kvm_host.h to utilize existing #ifdefs,
> and so that related code is clustered together.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

SoB fix please. With that...

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  include/linux/kvm_host.h | 37 ++++++++++++++++---------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index acb552745b428..9c1cf1a6559e3 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -722,27 +722,6 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>  }
>  #endif
>
> -#ifndef kvm_arch_has_private_mem
> -static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> -{
> -       return false;
> -}
> -#endif
> -
> -#ifdef CONFIG_KVM_GUEST_MEMFD
> -bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
> -
> -static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
> -{
> -       u64 flags = GUEST_MEMFD_FLAG_MMAP;
> -
> -       if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
> -               flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
> -
> -       return flags;
> -}
> -#endif
> -
>  #ifndef kvm_arch_has_readonly_mem
>  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>  {
> @@ -2572,6 +2551,11 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  #else
>  #define gmem_in_place_conversion false
>
> +static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> +{
> +       return false;
> +}
> +
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
>         return false;
> @@ -2580,6 +2564,17 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>
>  #ifdef CONFIG_KVM_GUEST_MEMFD
>  bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn);
> +bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
> +
> +static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
> +{
> +       u64 flags = GUEST_MEMFD_FLAG_MMAP;
> +
> +       if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
> +               flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
> +
> +       return flags;
> +}
>
>  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>                      gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

