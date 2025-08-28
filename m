Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29D00CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 10:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0B78E0006; Thu, 28 Aug 2025 06:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588608E0001; Thu, 28 Aug 2025 06:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49DF18E0006; Thu, 28 Aug 2025 06:22:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33B568E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:22:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF16485264
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:22:17 +0000 (UTC)
X-FDA: 83825776314.04.54BCC3F
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id D87B280003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:22:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qPF71rUb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of tabba@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756376535; a=rsa-sha256;
	cv=none;
	b=Icq8xav0OJUL+7TE3L4FT+DPb3d8lVxtct6SuslKJaK+D5bSjw4m0cQRW6fkGx4JwIRb2N
	MATbOsLE7o1dk5fjRwB8NR5WV0yfpSRuGVfPecOtCrMsIcy5Ll5kl0zarxFdYxs6QjDkNX
	1gFvDSRG/ZKgbo+0+MK2gEdGlcFr6Us=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qPF71rUb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of tabba@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756376535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAt+br+G9Lon3yOcD2uCT+F1HP2hGvD0BFIJ9EDkS/w=;
	b=N0E59MZ5+9UfrHVGHDXpNt1SFJCQe8d7AJHYZq2xX+A4ZKwPjRhocmJ9kqdLBTTw5dKWdY
	2w69RB6etiqYpixwrOJYaHXy/shzL+mym7lOCAp5Ik3ST01Frq1U3VtHrJ70Jp0CJwmB3T
	Z63n0l/RI5RdKDKpIv0FBtlEzPtQTqY=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b2f497c230so305581cf.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756376535; x=1756981335; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zAt+br+G9Lon3yOcD2uCT+F1HP2hGvD0BFIJ9EDkS/w=;
        b=qPF71rUbNSzwg0h0TMf1YBSB+kpY3XlFFQtwMfiXEIwmIGg+B51GjzDVVT7QMvm0uf
         k0wtL+tZm1Ul6SKiVWEmHfnRJ4umHZqk/1VkyPvoqfdLrQU01Nisi/dCeRy+z4EbqRyF
         llz/V+1YhnLcdGP09Tkk0sOKtOV7G5NU9lItTUhWXlZQ5eE9syinMyO2XHeM/LUu5w8n
         R78vo35RJ6EGEq8lnkeTox7aW+LN7vYsj3NNk/IF2ClS46Wmuff1wiynq78X9K1UCCMY
         hyyMcM9m+eGcdUh3sxa8B/wSM2BBGVvTRjOcwcVwJStkFCqxBxdYtAEpiNWlrrQ2BGAH
         HCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756376535; x=1756981335;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zAt+br+G9Lon3yOcD2uCT+F1HP2hGvD0BFIJ9EDkS/w=;
        b=FXPmwqdDqVSCLoahccSdKeuDkCIzh4BHG2HVsfFMd5fFVytusoPbfPTHD6hMwxWPFv
         z2uJ7IlWVKQX93YFHrDXF/epbxFAi96Rem0YlhCS6WxOzLFFo9xVUQrk8Y90PbR/MkCv
         d9AMR5UyBf1oTsQvXgb0uQT7cmtcpqqihfW79wJoUSVe0VKVctJqEZTVty5DLAwMfixv
         rDesDw+OCarhtjKVu/N5KHrJGuzGvx2Z+bdSiV4mjNXqetJnrvctBkk5Sh0lmKSIrW7N
         i1HdN/1K8BoXTDRQeF2GP/Gmt6ljZliYhUf0nMyiXq/gbTbE2ma9qLDKGXex9KNs9rnv
         bkkA==
X-Forwarded-Encrypted: i=1; AJvYcCUWOe4qOpO8YzhpYp/ifiK77fLpgWO/UFmSroQoaI6q1ZwF7o5YMb/Cs4j51JJS+jMJMMv1UPJzJw==@kvack.org
X-Gm-Message-State: AOJu0YxbljDlf04nEM71bIBf/SqROnTlPHPCrysbgFu9ku0GXNpibRCP
	t8iXQ+YiPPgtjjRWIQ4aXc/17+ecHBqDTp8Uh7hdOGkAaZiOgsooN9W0yeH2JFkOfq766iqLFXs
	UUZwK1zWHPH0+S0yWh34EI1O3sDaYxS2ru/0fOiXW
X-Gm-Gg: ASbGncu6Xw/LSQCGVKgrqbFTVnrof0OJDHzFoCIPsM5hbvCl3DeiFUEOMCzK+JSLYuC
	bDzxRVbMKAk1r5L31abMx8t1rQblXHXk5WPDgQNp0s9+D1gHERvFib2fstcIjwWPcRiOl1QCBP3
	X8RJZ6+n29H60GuchGxspICNySRO342BbZ4Ibx+ppWXA9IRPj9rTaSnpxpegHbVpqG+IsbRYpNO
	z0Vhp01z82/0yuDdjnxFhh9uQ==
X-Google-Smtp-Source: AGHT+IENYaxKywEJVnhRd53PlyB2PEFU36G7mSwHHBh3QnGvBJswRyDjryZtJh3goBAjur1DAoDs201z525n5fnLFR0=
X-Received: by 2002:a05:622a:5143:b0:4b2:9b79:e700 with SMTP id
 d75a77b69052e-4b2ea8688bdmr14440241cf.4.1756376534543; Thu, 28 Aug 2025
 03:22:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250828093902.2719-1-roypat@amazon.co.uk> <20250828093902.2719-4-roypat@amazon.co.uk>
In-Reply-To: <20250828093902.2719-4-roypat@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 28 Aug 2025 11:21:38 +0100
X-Gm-Features: Ac12FXxQhIbmHWE_IVdh_SbAhoCZMe-hp6nPpbqQbsT5jXtNkVhWc6QqYibQkV8
Message-ID: <CA+EHjTxOmDJkwjSvAUr2O4yqEkyqeQ=_p3E5Uj5yQrPW7Qz_HA@mail.gmail.com>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "david@redhat.com" <david@redhat.com>, "seanjc@google.com" <seanjc@google.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D87B280003
X-Stat-Signature: uoa38qtuyotu5e1ffnaade85j6smukj1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756376535-269012
X-HE-Meta: U2FsdGVkX1/PmEOKc6YcXRcoELCRd80bgkQ3UvdZQRnhZiWE/RzbwowcfQFrpvWRq35V3Yr0jnCfr7cyZk3ng3F2JGhFRSiU7Ig9MCWyVYS1525uiKYsCuTYh26KGCqpQZq2ni7wp9+jk2ZJc3AYSBgM3CumtV1YU+/+2WEcKASRqWnawiqdb5W1kY5oLPX4FhxGscCroccJl7yNbQYXhd+aSRE0GVgyg20jY50SDhTL8icGuqbot42yp07fNdn2GLPmAswftZrwd9OgP4FPAWE0aExv0DwkA1kVD9OSSgAWwuLlij1Dk/jX5ASfqZyTyv5JFLpmWgFf6lNXWpqOX8K1X7u2QYphXPWcFUq700uGygK17vH5TdR0V/xE09IQ6MbS5oDluMHkUblG7pU/FPPLkN3ouPgwqgLEFqMIGmkmdIcruA4xjZlqarTfbix5ASByvO2lW08fjz3BXT7fbrBP5yjDoW0Y0JW04RNx2/QeUrDWJfzzfKnZSQIf35bpZkd+8X2PnmeQSA02kbKKfqWR+dXdoOJLCwKndwF1CUTb4X08TZOlU3FO1t7dlTU2mMETKX2/W+Dr46+z8SfkUAzER7eBmF6BM8j1v0QPsIJKf1OYJofTZczZKhlX4lPg3k6O6N2C/PWT1i2bON8W2h8hdFzjdwkL7rXXvV0cBhfAGw7jUnInvfc361cRK8OFVHNgvDf2oADmL3qKZfMZgjQcDQxdx7Qxjyu3hlZiR4t66wbmk4gQMcY5ykp/plHxN+zJpf4NKYhPKOSdDJQZ42nFUraC9PrctVl5MjrNM2Eqv6ZXpeLZsg3hwUFUUua0ulGswSH7OCuX8i3wCByiahL87GLLCUoe4WRgbxTQSgiq4uuPSZfeW3qQASlxm8EmNV/CN9e0ydwc7mfYfrsGVvC1qxFxCWVM1ypyCfLcb1H/UyjTWEkqB6QHpwiJ+vCq4qLED+qEcXNQq2YW5a3
 PTzpFFbz
 mH0iY6y//05HwV0M67vzUFLBGjFSGF6sATLmfPfcx11cAAALdg5viRZRWAfQ8UCInHErlX4Oz3oJfmGHWL3dQDA2I9p3ITn9g/f9cFUpzJ12RgY5MeYFfZgx/q2XXNxNTb+fzu9ksHVDBGbVmHrvj1PkA7ceEobzsId7U0YM0lrQnBkLii/NUhhSVk14JUSVMZ+vgT5R9L0VNYQX5+m7cxa1VLjgTVUaNMvsF8vClVgmC3eGL2lGNEqsnzkwIPN7cC2vLOE0SzDsWmMltqIf0ExuuokxqyIcEktAz3hV1irOu3igzhSJ+40z6r5OirBkHh5XjTDmrtHX2gdXV5SVyc7A3Vg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Patrick,

On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
>
> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
> set to not present . Currently, mappings that match this description are
> secretmem mappings (memfd_secret()). Later, some guest_memfd
> configurations will also fall into this category.
>
> Reject this new type of mappings in all locations that currently reject
> secretmem mappings, on the assumption that if secretmem mappings are
> rejected somewhere, it is precisely because of an inability to deal with
> folios without direct map entries, and then make memfd_secret() use
> AS_NO_DIRECT_MAP on its address_space to drop its special
> vma_is_secretmem()/secretmem_mapping() checks.
>
> This drops a optimization in gup_fast_folio_allowed() where
> secretmem_mapping() was only called if CONFIG_SECRETMEM=y. secretmem is
> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on
> by default"), so the secretmem check did not actually end up elided in
> most cases anymore anyway.
>
> Use a new flag instead of overloading AS_INACCESSIBLE (which is already
> set by guest_memfd) because not all guest_memfd mappings will end up
> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
> can be mapped to userspace should also be GUP-able, and generally not
> have restrictions on who can access it).
>
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>  include/linux/pagemap.h   | 16 ++++++++++++++++
>  include/linux/secretmem.h | 18 ------------------
>  lib/buildid.c             |  4 ++--
>  mm/gup.c                  | 14 +++-----------
>  mm/mlock.c                |  2 +-
>  mm/secretmem.c            |  6 +-----
>  6 files changed, 23 insertions(+), 37 deletions(-)
>
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 12a12dae727d..b52b28ae4636 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -211,6 +211,7 @@ enum mapping_flags {
>                                    folio contents */
>         AS_INACCESSIBLE = 8,    /* Do not attempt direct R/W access to the mapping */
>         AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
> +       AS_NO_DIRECT_MAP = 10,  /* Folios in the mapping are not in the direct map */
>         /* Bits 16-25 are used for FOLIO_ORDER */
>         AS_FOLIO_ORDER_BITS = 5,
>         AS_FOLIO_ORDER_MIN = 16,
> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
>         return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>  }
>
> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
> +{
> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> +}
> +
> +static inline bool mapping_no_direct_map(struct address_space *mapping)
> +{
> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> +}
> +
> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
> +{
> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> +}
> +

Any reason vma is const whereas mapping in the function that it calls
(defined above it) isn't?

Cheers,
/fuad

>  static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
>  {
>         return mapping->gfp_mask;
> diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h
> index e918f96881f5..0ae1fb057b3d 100644
> --- a/include/linux/secretmem.h
> +++ b/include/linux/secretmem.h
> @@ -4,28 +4,10 @@
>
>  #ifdef CONFIG_SECRETMEM
>
> -extern const struct address_space_operations secretmem_aops;
> -
> -static inline bool secretmem_mapping(struct address_space *mapping)
> -{
> -       return mapping->a_ops == &secretmem_aops;
> -}
> -
> -bool vma_is_secretmem(struct vm_area_struct *vma);
>  bool secretmem_active(void);
>
>  #else
>
> -static inline bool vma_is_secretmem(struct vm_area_struct *vma)
> -{
> -       return false;
> -}
> -
> -static inline bool secretmem_mapping(struct address_space *mapping)
> -{
> -       return false;
> -}
> -
>  static inline bool secretmem_active(void)
>  {
>         return false;
> diff --git a/lib/buildid.c b/lib/buildid.c
> index c4b0f376fb34..33f173a607ad 100644
> --- a/lib/buildid.c
> +++ b/lib/buildid.c
> @@ -65,8 +65,8 @@ static int freader_get_folio(struct freader *r, loff_t file_off)
>
>         freader_put_folio(r);
>
> -       /* reject secretmem folios created with memfd_secret() */
> -       if (secretmem_mapping(r->file->f_mapping))
> +       /* reject secretmem folios created with memfd_secret() or guest_memfd() */
> +       if (mapping_no_direct_map(r->file->f_mapping))
>                 return -EFAULT;
>
>         r->folio = filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT);
> diff --git a/mm/gup.c b/mm/gup.c
> index adffe663594d..8c988e076e5d 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1234,7 +1234,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>         if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
>                 return -EOPNOTSUPP;
>
> -       if (vma_is_secretmem(vma))
> +       if (vma_is_no_direct_map(vma))
>                 return -EFAULT;
>
>         if (write) {
> @@ -2751,7 +2751,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  {
>         bool reject_file_backed = false;
>         struct address_space *mapping;
> -       bool check_secretmem = false;
>         unsigned long mapping_flags;
>
>         /*
> @@ -2763,14 +2762,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>                 reject_file_backed = true;
>
>         /* We hold a folio reference, so we can safely access folio fields. */
> -
> -       /* secretmem folios are always order-0 folios. */
> -       if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))
> -               check_secretmem = true;
> -
> -       if (!reject_file_backed && !check_secretmem)
> -               return true;
> -
>         if (WARN_ON_ONCE(folio_test_slab(folio)))
>                 return false;
>
> @@ -2812,8 +2803,9 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>          * At this point, we know the mapping is non-null and points to an
>          * address_space object.
>          */
> -       if (check_secretmem && secretmem_mapping(mapping))
> +       if (mapping_no_direct_map(mapping))
>                 return false;
> +
>         /* The only remaining allowed file system is shmem. */
>         return !reject_file_backed || shmem_mapping(mapping);
>  }
> diff --git a/mm/mlock.c b/mm/mlock.c
> index a1d93ad33c6d..0def453fe881 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>
>         if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
>             is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
> -           vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
> +           vma_is_dax(vma) || vma_is_no_direct_map(vma) || (oldflags & VM_DROPPABLE))
>                 /* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
>                 goto out;
>
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 422dcaa32506..a2daee0e63a5 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -134,11 +134,6 @@ static int secretmem_mmap_prepare(struct vm_area_desc *desc)
>         return 0;
>  }
>
> -bool vma_is_secretmem(struct vm_area_struct *vma)
> -{
> -       return vma->vm_ops == &secretmem_vm_ops;
> -}
> -
>  static const struct file_operations secretmem_fops = {
>         .release        = secretmem_release,
>         .mmap_prepare   = secretmem_mmap_prepare,
> @@ -206,6 +201,7 @@ static struct file *secretmem_file_create(unsigned long flags)
>
>         mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>         mapping_set_unevictable(inode->i_mapping);
> +       mapping_set_no_direct_map(inode->i_mapping);
>
>         inode->i_op = &secretmem_iops;
>         inode->i_mapping->a_ops = &secretmem_aops;
> --
> 2.50.1
>

