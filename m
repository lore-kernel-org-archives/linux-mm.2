Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F256CD98F8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 08:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12E096B0088; Fri, 19 Jun 2026 04:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DFED6B008A; Fri, 19 Jun 2026 04:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8FF6B008C; Fri, 19 Jun 2026 04:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C60B66B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:25:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36FE84039F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:25:50 +0000 (UTC)
X-FDA: 84895978860.26.DD9F3C2
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 43FE81C0003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:25:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RyY0X5+Y;
	spf=pass (imf20.hostedemail.com: domain of tabba@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781857548;
	b=eL6La6j5lAH8GeME93XZ05JxyKY5TBqw/nGg8z8PvLyb+f0lomG+JijfCuV4wjeczR6Njb
	OQSRKCSuDZLqyWao3b1F4/5mPm2GsDbx16C4ar8G4XNgGj3li/shny5wQUBy0KkjKx5joy
	uHAaz9cF/bjdWCDN6JGLMxVOZPnYkxk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RyY0X5+Y;
	spf=pass (imf20.hostedemail.com: domain of tabba@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781857548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3cFYWLK/FtmAY6SmJ1SGh+iq0DuUVi9vERhh19AGAVg=;
	b=5oq3kBgAj1IMGcCYDrdVsrtHEO5u24nRnimihaxuMn16Of1QDXYNRQtvWRxvqksyVdWAz9
	3ulVOdUv2h4K+p+kSyyMRrNkLwnwLkGAJGRyadKTW7VE42ZcWwKEM5qhJTBCizgpY2kXK2
	U5LhRp1Pq9P6w8JpeT9y+E8R0b263Kc=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51765331535so122551cf.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:25:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781857547; cv=none;
        d=google.com; s=arc-20260327;
        b=JpSrx/1E7rbD/CIBw4PGikrg35N5m4wJQTanuc1p4faRgCrqEruZ14LjzZOKI0RNJI
         1gdNx5bTs0dGHHVDFanCKVtLA94BjBu63z+acG5vGd39UiDBP4ILh0k+etsEEzuZvDsf
         eUsnZ49uvi3fbYbFGDX8jrr+Ge0+HQ9BJZ9kK4v1Ew1ePcgZ27mIamQcGPJ1gfPsUZPc
         evun78o0fUeY+WOVKC3nzzpfyznkHLPW3dNohhxl6QAjgtL+ktHC9lVi6c5M0G+PB/nX
         osEFWGVeYxDxY981UNMJmG3HgZW4npvPK2oITWnYGRu7fBVfiW3yodc1c9yB7IkRdRAo
         SQ2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3cFYWLK/FtmAY6SmJ1SGh+iq0DuUVi9vERhh19AGAVg=;
        fh=SirgpXDzhT2emAEM3YI7Mv3Ket1J6c16jAovVGMTqu8=;
        b=sMy9jBerPjrea9yK1iH74IKNSWmh2sjihHyHv/fW6I+l6olMPduTHXysWZPf8mZifx
         H/9RzbIG6pVWEs0oKtkGkLLIsebJeWMsgEJNhRREOZLwTsqKhChLs16t4VWt2e9jCN6/
         PSzPhBhNDQPa4A7aMcSWGkZCVUyAWapkPgOe26jPYnV625ie1YD3sybIimUz4gSLDc6r
         XuWMha/5VoxowF2hf/PdMQcIyN8D3bdX5MvzgU0nZc0NfFOK+mXDj3+yjaHdsxDfgvO/
         r2WQHv0EthvC4oQ8/LlhywmVoowWu99RGypCzLnmUHlLrpYrUfN5rxBcvcHvZify2rj2
         tnww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781857547; x=1782462347; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3cFYWLK/FtmAY6SmJ1SGh+iq0DuUVi9vERhh19AGAVg=;
        b=RyY0X5+Y7Wp3AdOEyUSMgSePgJse5V/KkjxvTaWW0tYUKW0ux5j8pR2smigAVF7Ah7
         IdmHHPO8gNa/0/GpyS/hLISutgEHkL6aFiA1ZOxzgRPX6pjieSslG+E8cUfCH9l4lKGf
         Bx8eXuO3c6xNHejXxqPe1YzvoCU2tkEL1IiTEqjXTIXFyqP2YvVFbMgXslkkk7Wibw2X
         MXvkIU1HLLnpxxLoen4Yr/S2GCCLF+KE2Hu/kHQK6iNQPKFp6RYO8PIvPGv9DQVivZy9
         bdkFPe2n8WwNQuFxE1M7XM5/gIcQVNcSp+oa+C24nzomu3ywdy2Zu0efTNUWce6wgXS0
         okTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781857547; x=1782462347;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3cFYWLK/FtmAY6SmJ1SGh+iq0DuUVi9vERhh19AGAVg=;
        b=GIEecR8TewmOet5jwnpbVLc0X/hPd9qWLVnRtuTKcHP47AqkzlJL6aipOxQ+dD6R0k
         mRXM3vvRSu7HTA+MfoY1nPl6c9xQcWxqoWYUW1eumqogS23Zat/4VI1GOoFunBBM3geM
         h5bBlHNDZY2cklPy1QN7SQUus+IOk/Eox01cgmp7W4NJb8Mjoh3oOOFNsqdyD7hBCGuS
         vpvA2hvCt/WeR3sMZM2wv/ONDYDzbvVAoOx1RwqnFsU7dx3oO//YrrwSXyquPbk1NoVq
         bn3tw993iNcHYigDcIifD88FDiDen3eQ1+LxcKBBpykdk62QBdJZNhKLE8lIf2oD2hqd
         loyQ==
X-Forwarded-Encrypted: i=1; AFNElJ+EM5BjCQ/FZAcqHnvggX2EO4Nj1KQsZdpzohwC2ZxDsMirSf5N0AS160LhE7kJQEc3jabHiTWX/w==@kvack.org
X-Gm-Message-State: AOJu0YywWP+Ooysmn6bcfmEmkCqmOmj3g1Y3nMUQEZ2FBqMhQtVv9Jsv
	gB27661kaKZfF9/jmtdih0jlIkDPtZkkVR6hOg/eYi0IRs1UBBf7tzB/kZ8ywZS/1hLgC/n0GaG
	DLWXG3MQ5ZGmBwfeWkueCPa9tjs93//UZRGANCXXR
X-Gm-Gg: AfdE7cms7SOrZ3m+2HPDgpv0WWkkTVnSuD3PzN79ynDOfcg5QsaYqzuJCcglgoW7u90
	RCgLoRL/4yaFT0agSILETZMKLT3gLcr+12tHeHKiD6/hWLi1mG1LWD7ltGnfMAs/Qptl2S49Qz6
	W2tAdGXuDhbMP/Jn/6KHooUfB25qAblyAqNLf7bZ7apx3N9pCqY4hX1vYUUEWZ7pkWqgBYwQpYo
	zoWwgsAhrVqbd19G8+H5zhGP1sxgOWuZyOV5Nnj69YbO39bZNoRnyyp5EKbQ7eUgDmO8om7kA==
X-Received: by 2002:a05:622a:1b88:b0:519:b82d:fe62 with SMTP id
 d75a77b69052e-519e891c801mr4739831cf.7.1781857546581; Fri, 19 Jun 2026
 01:25:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-9-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-9-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 09:25:09 +0100
X-Gm-Features: AVVi8CeyI3PAg86WrGg3AslQ1YuW7acL6Ym-NulDiNjx1M0Fc6iTcS7y2ypGj0E
Message-ID: <CA+EHjTzh+iThoVnLOGbRDgacKFcvbBxx9m_72bhfafE4J7a7jw@mail.gmail.com>
Subject: Re: [PATCH v8 09/46] KVM: guest_memfd: Introduce function to check
 GFN private/shared status
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 43FE81C0003
X-Stat-Signature: mypito8pkyr7gmguxep3mjip5t1z6d3t
X-HE-Tag: 1781857548-254079
X-HE-Meta: U2FsdGVkX18hDhz0XAsDm2kOg+6XquKi0igoIQi19aZy1YIpDmb374UTKXVjfcm2jTgC7ZwNvpZ3+OZISpY0YddZPoWYeENphR+dso/mZtSdxFp3aigoCPh4E1b8SzFmJST50g8zj+UKq9rWDmW5CnCOSGzYXxPiy/SBQqvw+3I13jPLCCPeEHODU5l87nz2AUZTpuk7Kjx6JDOJbWbAE1uUHfk+gNwIzN7YSyRZKyAEBNBWAgDdbifgqEwDMiiiPHXVZ/1SWDgt6AyiibuUC2xu9KX+eFlRXerDNiEHMU1ygsb+JDHr6A5zRE8atcASQeG1wiHfbe7VtwgEs3hWohBwqlZz0tPUhPT/q1ax8LXqX3OHjrLYJJfzVajcKS5T+7zhc+7NyAMlpXZvM3N0TTKIdjdNqr3vhVu9a9/fOjg4GQV4ztDwT9CyDDMHFpalQC/E4a1mXYyep9HOeORpNCZ/lIZqhlgAU0fnSJRftAO0GBBJb4TIWVS/d3ukyzpayi3Zgxofz0ylaWnlaIjD5LdTywC2QiUpZ/wXwX9bICRzXCdUrKKj3+ylVYxLadmnAgG2XKL8cNo4Q8/ky8ZfV7bcywaO9atty008pCMOgkvBjhaUqxsnu4yZpjZD9dkPivxDoisULhF/RL4HZHzINdduE9KF9ysJUSPbSiZXBIwYGb8Bxo5IfP3fuuLEVJnBvgEqSezSaj+YhJkXvmeMOlAD4viNJKPUzyqCcshljPbRjMzYof7RWmcmLAX/PFWmH5dZx3i1FWe24fsVIifrv8FgeMdbxkuicG260iJ0B6ix0oHLilBK+sjuOo66QLh87Q04KdyEfdv0pWHcM/3cylibDFnSJvQhKUOSlS4Bi7zF/mgHE+bz1CK7cJCFj+Bd5TWOVyvSuhrYaaUsg2RuNX/dhAPZG4fFhgRLlBcSHO8WpDoX8lA1VN1F3bRqQ+Rzrxx/OeGphsC7N+8rd7k
 TWlGVEnj
 OkNp+dGK/GZDqPESN0A46QnYsTPm6Lfo2htTUD8s4xIkfRoncQADuFYRpSK5MDTwoMoVAoEtQIjSFKQ3EEWYvmkUAGstMcJlcwyAQzTOpyfBwVkeEWNGKONLZqv6a7ixByWTT70pWcSJd09J0pz+oA62iT3qUcMf7RzXEINdTXgZ+UGcaB4zNddrGSP/Z6NdmJsJg8R71DMr9KtvWz2x0Nplhgu4qQv2gm9TEimUED0ZPAlwON7Su3q9WJayFBdyFs+3ikTqzjVPwyl9aiNJtR2nFqT5G9IGQYyjzp7d7J8VzaU7phnMMTDl9SyYQCJrugTTgfBwNqfPE7nY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Introduce function for KVM to check the private/shared status of guest
> memory at a given GFN.
>
> This will be used in a later patch.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  include/linux/kvm_host.h |  2 ++
>  virt/kvm/guest_memfd.c   | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3915da2a61778..27687fb9d5201 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2575,6 +2575,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>
>  #ifdef CONFIG_KVM_GUEST_MEMFD
> +bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn);
> +
>  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>                      gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
>                      int *max_order);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 8101f64e0366f..bca912db5be6e 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -510,6 +510,37 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>         return 0;
>  }
>
> +bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
> +{
> +       struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> +       struct inode *inode;
> +
> +       /*
> +        * If this gfn has no associated memslot, there's no chance of the gfn
> +        * being backed by private memory, since guest_memfd must be used for
> +        * private memory, and guest_memfd must be associated with some memslot.
> +        */
> +       if (!slot)
> +               return 0;
> +
> +       CLASS(gmem_get_file, file)(slot);
> +       if (!file)
> +               return 0;
> +
> +       inode = file_inode(file);
> +
> +       /*
> +        * Rely on the maple tree's internal RCU lock to ensure a
> +        * stable result. This result can become stale as soon as the
> +        * lock is dropped, so the caller _must_ still protect
> +        * consumption of private vs. shared by checking
> +        * mmu_invalidate_retry_gfn() under mmu_lock to serialize
> +        * against ongoing attribute updates.
> +        */
> +       return kvm_gmem_is_private_mem(inode, kvm_gmem_get_index(slot, gfn));
> +}
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private);
> +
>  static struct file_operations kvm_gmem_fops = {
>         .mmap           = kvm_gmem_mmap,
>         .open           = generic_file_open,
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

