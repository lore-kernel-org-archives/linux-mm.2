Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80B43CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 12:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E79A06B0096; Wed, 20 May 2026 08:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51996B0098; Wed, 20 May 2026 08:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67336B0099; Wed, 20 May 2026 08:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6A2F6B0096
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:09:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A7E41202B3
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:09:08 +0000 (UTC)
X-FDA: 84787677576.28.956A836
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8B1BB180006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:09:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D60FgFt8;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of tabba@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779278946; a=rsa-sha256;
	cv=pass;
	b=mKnwXWx/V0UU02Ncrq0bQ1IOIn+EYHgY/1sT5zekBJNv7MLG40jjJoCdB+BfBNJaa1Bb2F
	IEGOjgNXQ/DIMGV4yv5jl5wzobCRGrsYYlIGHPSx1gXa3xYISD1vmmFUElHgETj3MA5f/a
	aBsBQZ2UaaSiUKZZkLJ6OyM/R1g8Jyc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D60FgFt8;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of tabba@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779278946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQto/QC4w3qzIENzIqyf+q0L9QCeoBT0563P64KzKcU=;
	b=3IFhU0Xki+pWVBF71hdQpcYq59G3IDWf3P85qxTUJZdxA9NyGosr9fY5OHi7PRueD6prhM
	ibB8P2OaoeoxeiKH76QcVyyQ0TUD8x6ggWnkwP7vwieMY7kszpbsjYrXUYGZYbH3MWnV6m
	2FUlFBedRnWMGhdjEENm/rd1kYp8P7c=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50d864c23bdso8891cf.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 05:09:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779278946; cv=none;
        d=google.com; s=arc-20240605;
        b=VSaMAIeV4n7LzcJxWVENgzHRr7ZoU1dwp6V029YcUgkYzmGXOsJ6uWKXXp7sts6NrU
         S6CHhbywIzDY1tbx84EUPGq2iAdRbqy7l10OVckv+Lx8G4xmuA3sZZoJr6rnyqjwQBXf
         llq24htp0h98erRpGcZSqNBAYnnncu3EecZVPphyWB2Sa4iUHW8xXCDUnj0IebIYrmhg
         X+yJbEYzr2IADT9nqwNykeonlzMNgCnGE7E6dbpfGv8+xYdIrwrwR5IFQarMLq5Ti451
         +JaReXkk6NDi4gh0mUjSrnVYcZjDdB5rA8EQW4fhWz3gOpot34SGgDhhBGbouz1dgjnV
         w95Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=dQto/QC4w3qzIENzIqyf+q0L9QCeoBT0563P64KzKcU=;
        fh=wCRLaStY4YLI2sxY/ss264zIvtdGu3/hnzQVF55S9zg=;
        b=U5jUvAlNq1G/CxkSkPFVlv3Ajam4HTJuCCeuez692LlliDzKApNENhIPQ0cDNCkW1T
         yBZuAAXoaTgSyavQnQ/mKWON6pdcZr8DYRsUwXnf+ypTv27jYOsqxsIt3k0xhnkEhNlx
         KNsqeDjzR86a0x46/DOiqDyF2U0mMd2lKTl5oLQCVy8rRSOoX7jKGKkGAeeQWpQU9O/Y
         2xrpldotaP1pAw6FJ4+HQvQ5QXYBPGqhW4Pkpk9KBIBmJilZ83ZvvsHkuOpH9jeAn2tK
         oYeGm7HJ2NUff4gSyIf+Biv1vkYLVG0ThUP912s+tGiP0BuaRpX0QFFEa7Hkz1xJsgoW
         Mm2g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779278946; x=1779883746; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dQto/QC4w3qzIENzIqyf+q0L9QCeoBT0563P64KzKcU=;
        b=D60FgFt8bQ8k2IZC+YJdtoVgjqC5AtlhMDfIQsOK0EfwP9wO81toIOuRdUdxralMbT
         FwISmNUWRxJORtSJIu/ehg4jd6sNGaNnKFt8DSkwCykBkLUHAI2id+EXov0fJLvg8860
         roXarIEKlKm2t5zU0t2eBt9eQLSlUZQRAFV53+6dOGaqFl8Nz6Qu+EsWdkSk8O8VW7DJ
         3c/8Pp0JPksoN7jb3Kt5MXszaJnatp02mvtqLJqMlEU+hRX7yUX6rOmz/yMoO3bisynh
         DbkxDfCnm3SMXUkJFQOuTDPsTSuLmhJtfxxQPkDoPXul5cFjNQOBY2OUN8wefw1L/nfC
         L2Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779278946; x=1779883746;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQto/QC4w3qzIENzIqyf+q0L9QCeoBT0563P64KzKcU=;
        b=FvygdtRno2B/0wcFqu7a4JzRuPxdTBibUMxMR4rJiVslrM7Ashk1CAI42+l8TTZEax
         KYKy/85FJTaRIHl6gd2qCvU16ePUnFEEvbIkQrHT0Sw3N5rEJddEwE6ofgnuZppqmSCC
         wXq5/qmmitfY+IAlFJA/4M1ftwe/eMbDYfgUFOhZt1ZoxwQLDyt/qvAdMtWnV8TJauLS
         ZVlPemYwcW/0YOLZxakgQb+56nkT4dktp8iXtqh4OQvvRR3LyyXC03VgZuRfPNAe8P8U
         LIdd/M5tJtSa0HbYSPS3DZsylpn/odazdFgAnYau2Ilp26nHvRcV7Fjuz+0PG7qvO2MO
         E6hQ==
X-Forwarded-Encrypted: i=1; AFNElJ/1y8d3Wj3KMHX5umKKlXym7Yn32eMB3sou5Dw9ryL4LdCbavw/Pftv8ir6z+LfuyljmkXcom1ifA==@kvack.org
X-Gm-Message-State: AOJu0Yyt4jDtGU75YK4rBejCfIV2Nw4QSTSJoPilk2LZv8v2+f1ByHdR
	O0gZVG4kDPPqqNa/mW5Oof4OQLzCXxDW1P9SdFnaKsfu4erkbCM+MrotmWVeIDKnJOGJoNuTQo6
	8QQr78LkVinilPxyNUqbkbPJCNJqkSkfsqE8TlJFm
X-Gm-Gg: Acq92OFgmUHsSI0k4fm4LxVAo4ev3C9o1t5TP/JEDx6gD5P8P5xn+y+wXthOKaQmaDa
	BGg0SbsSDv28i2oRvF3erZFry4tSgkOCTP+T2/VQ9xLTg79GQYW5XIH0aYl8/TrxTCa/JtG1MPp
	Jr/g/RjqE5eylmMNx7xxaVRlsmvZ5cznXioJpNBb3ixSIFXDwaSYsOSS4qpFIwMNt1Rqfs8vKzS
	eBKKj/ttQL0/VwvBDe/Hl1CNRY7LIj0afT9jEDWShJT5rdDaxwM/Ru9JBjwG2UccBCb4Vx03RC+
	gYSKl992+YNko/gDUQQ=
X-Received: by 2002:a05:622a:8c5:b0:50f:ce97:3b84 with SMTP id
 d75a77b69052e-5167937f1fcmr45990921cf.6.1779278944775; Wed, 20 May 2026
 05:09:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-5-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-5-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 20 May 2026 13:08:26 +0100
X-Gm-Features: AVHnY4Kn_wj-UY2TQuxJGnGGFJjYyy0y_byFgvzUVgqLd3Jhr51sOjcVOWq6VeM
Message-ID: <CA+EHjTw-cUM=FrJevtSDtR7K6MwUfGfOx21LMFDn7DAy5bFzYw@mail.gmail.com>
Subject: Re: [PATCH v6 05/43] KVM: guest_memfd: Wire up kvm_get_memory_attributes()
 to per-gmem attributes
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
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
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ia5owdyrq9kr14k5c1xsqyuhjm1i9wku
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B1BB180006
X-Rspamd-Server: rspam07
X-HE-Tag: 1779278946-389623
X-HE-Meta: U2FsdGVkX1/B5ZfutL3yyICm/1H8sJTnCuZ6ac/Jm/qGlRJQoKESuj8daGF8Mo8TRBuGn7aB3Gas0366cHJzusSfI/neldCB1lA9cQAVnR6hdvyyva2pxMS9wHWt79nckYVQygl3C6ILmeiwKOIxmcwyQwzEp6OZvFq3fRhIrYqHpB1d0LIlm07Xhg3NqtKIH8RvGS3aEHPCOa9DFPNKSYalLvOPL9jthgyHRrIiSF+Y0eHHQpMnZyn2o5pB06DpoYrb1EMBJpTMjsyDmhTK7ie1UouOgxTW6e/OYko7PpqqdqG9xZSRvKVkJkF7S0JITFmEvd8tcXopJkzKWdiOb/1O+bRkBYgmMRoh/fvqlaL9kQYUvWi3953AylYdfrgJjOm9nL5UT2X+SlDKCT2Iy9jZPOIQ9cT4pxbF7evyjgrXrY7HPDmokcWIbCinVYmcP2bUyoOxGiUJqm5Sqcf5YOPCAqJkFFUKQF8WtdLuoH/UMGb0rNNgB8SnMxwskZ0Gob7pBK82MBazN6thG/mPGX0OUa+UqtqdNb4R444ntJamDZsDNWXclNSi1MbhCp4hcknSdvvPMESySAuqKeE2efm20j5vwbJ6ThDYUCMExp4F0boOGKCkCoEinYgNqh/gLKtTJXXc1D94qKVEV/SHkGnpKelZQyPKvgkI+0NfjEhZkXuzfxQKL50qfQMS4fzlIbf94GwqGjat9ZlobEBlpqFbDtL3GI16gF57rJSkFyoFiRBAsIa9G3hlCX7peO8Dl+61HYVwrZNgVyfgnd1JU6r/ydsR5VdGRoAKxezePzqErExlBZvUd4a1cepTtO0nO+qNficVwCEEkE0kpw1NxBjfdxAu4tYQC6B3sD6orVJaRQ4cAMmsFJUk1aJdA59K9UMUgC/g1/kubCW5YUXgOKzYByFZq8fgvhuszBcChsj/Xsg6yX+tMDlelmLdfWKkwxNYcI/eMIqhV3U0MG4
 tRRXQkka
 g5IPAdsqFQx/xyPWfKXFHybDO3AHY1C0qFTniyNMz6Io1nx9+cQ7LKl4KKvINJTfZA9Qm2KJaGFOOF3AFiHF0uRWVfnUfTgh5UK7KPHhp27gm7taUy+cQhS8/Bu3wN2FqykV/7Z2blLmgeG+wyWahvaPiTgUN8Fotm8AmNc6eLmLns4v14vkSuR8ITrxziEHca4xYzujLfHMYK9JNoFRhOaFN/ejR3789mp+eAGlSFvEuCHPr5UQEnONC2cMbkVFY+eGIdz2D90xkCNi3NDakj0zPG5ABtexs0EYHZ8+oCxeNshq9XU5yqOHtGVB4xT7wya+R+QLmeB7qKC0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Implement kvm_gmem_get_memory_attributes() for guest_memfd to allow the KVM
> core and architecture code to query per-GFN memory attributes.
>
> kvm_gmem_get_memory_attributes() finds the memory slot for a given GFN and
> queries the guest_memfd file's to determine if the page is marked as
> private.
>
> If vm_memory_attributes is not enabled, there is no shared/private tracking
> at the VM level. Install the guest_memfd implementation as long as
> guest_memfd is enabled to give guest_memfd a chance to respond on
> attributes.
>
> guest_memfd should look up attributes regardless of whether this memslot is
> gmem-only since attributes are now tracked by gmem regardless of whether
> mmap() is enabled.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  include/linux/kvm_host.h |  2 ++
>  virt/kvm/guest_memfd.c   | 31 +++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      |  3 +++
>  3 files changed, 36 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c5ba2cb34e45c..28a54298d27db 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2557,6 +2557,8 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>                                          struct kvm_gfn_range *range);
>  #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>
> +unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn);
> +
>  #ifdef CONFIG_KVM_GUEST_MEMFD
>  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>                      gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 5011d38820d0d..f055e058a3f28 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -509,6 +509,37 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>         return 0;
>  }
>
> +unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
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
> +       return kvm_gmem_get_attributes(inode, kvm_gmem_get_index(slot, gfn));
> +}

Doesn't this imply that all consumers of kvm_mem_is_private() should
validate the result using mmu_lock and the invalidation sequence?
sev_handle_rmp_fault() calls kvm_mem_is_private() without holding
mmu_lock and without any retry mechanism. Is that a problem?

Cheers,
/fuad


> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_memory_attributes);
> +
>  static struct file_operations kvm_gmem_fops = {
>         .mmap           = kvm_gmem_mmap,
>         .open           = generic_file_open,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ee26f1d9b5fda..4139e903f756a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2653,6 +2653,9 @@ static void kvm_init_memory_attributes(void)
>         if (vm_memory_attributes)
>                 static_call_update(__kvm_get_memory_attributes,
>                                    kvm_get_vm_memory_attributes);
> +       else if (IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
> +               static_call_update(__kvm_get_memory_attributes,
> +                                  kvm_gmem_get_memory_attributes);
>         else
>                 static_call_update(__kvm_get_memory_attributes,
>                                    (void *)__static_call_return0);
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

