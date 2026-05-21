Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA9ACD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911A16B008C; Thu, 21 May 2026 03:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC156B0092; Thu, 21 May 2026 03:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FF916B0093; Thu, 21 May 2026 03:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF726B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:57:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3746D120514
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:57:44 +0000 (UTC)
X-FDA: 84790672848.10.5673D15
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4F84F4000E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:57:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BMRhgBWo;
	spf=pass (imf07.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779350262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSn2g3kUTBO9UyvrMevDMplllFpiZxqy7FxTUXL/Xlw=;
	b=v8IB+5qkhCJlf4paTKcfbE6T0x0mpzoNs2Cx+dXCf2zuj0Zm+6iZR0i/blyBHQ+FbVtutx
	fifXPs9G/43cSQ8qV9S3L34JlWastuKfMMJrc9/ahJ5oVSV/Onbg91eHAd+pXTHxWuEJty
	WhB4vs4oQ/OTs6verSW5cI0wPT7gzzE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BMRhgBWo;
	spf=pass (imf07.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779350262; a=rsa-sha256;
	cv=pass;
	b=QVQ5jD2BeIpZRBXwRmy7bjyQ16FBdfocPE+zpsMQwRxhdNpx8pJugmI8m19ijKme6O/M4t
	sLCR0MYm9No1G4nUL1UyKGH9PmWeoplZf6wnRbmbx90Sz1sZnnsjucfnwvv7NVqw91Zk9R
	dC+593Cn2FMn5bcdkOtSeFkm/6+BLcQ=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50d864c23bdso5441cf.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 00:57:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779350261; cv=none;
        d=google.com; s=arc-20240605;
        b=ekmUVh9LZ9WJeuF9Ix7Ucd6/4V5eLpfjzqnjWnoI8bxaygv4cEyZrOgr0bPWhZoA33
         QahBUyMDR2lQmb7qSQXcggTG7AblYVKR0jOmTZa6RfuZBD+j12ql8hBNA0sqw1KTzxbX
         Nf6UyjyjoY6b/IuGqUw1hvwvtX33rWbFDeoGdaWHgZLnVgGaqhFu3Fa8filHR5VeQoP2
         zGlps0UwpDhCosLd4n+MKNGGQbhM8/T/9lmfd2QGxm7iKrrd2MIcxsp1oXVyQ/b6NxkC
         E6RL8WLClFhnqS8+CPlymcCL3swesdUr/sjvPcGOTdhU5AyJypZcxJX/bnAUTL9AHeEJ
         UdGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=tSn2g3kUTBO9UyvrMevDMplllFpiZxqy7FxTUXL/Xlw=;
        fh=PTfGJ5WfIGTleNBKsXIbeWth49G0lV92krWXTnXXcEk=;
        b=k7vbSxqVixuHipL5FJPhKWINIfRgtknd/iARpyOHb+MHfWZvLOjTo2RPlKEk6GaLHf
         kbhmZG1QwZ5z8I7Xl7pc5KErTSJZarbCpfYP52mri6OKbsZYlJHyhqYGN3GwiPLqAqQH
         a52tWwocXJrjJ2pC1mDMM54iWeeRNYKZcQMXq/VNip+zIGMkT6ThDh3nrhuXpivl96Ou
         LirVnjfyXpsm142QLzW2Z09oYeAu6avdxakghNDoddIaHB6pD26orsMYJw/khzZjmS1j
         kS/cmRTS/l+eVftMcnMbbIgjQvMXFZd6yKpjZMskYkwX87Nyws8wcNxyDSXvHPrL/vW4
         Rhzw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779350261; x=1779955061; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tSn2g3kUTBO9UyvrMevDMplllFpiZxqy7FxTUXL/Xlw=;
        b=BMRhgBWojXPAXeAoSFXPKmggzWSShu6rIlF0+Obzv0HDZrkNKC62h/thytqTjhv3si
         Y6ithidQadUXv/r+8f1SXx0/D7bpSpkYToVWVLLDNKSuxrezg1PuXWSTVg/nQ7AknJaI
         Tt+YXqrkHOOUEp//THKWPk6rO9gD538Cs9JFUWANLzMI2oAByc/AoC7oaJgpsAIkE6M5
         d9qnYeuaTPc6D7MFI2LrT2EgRWyuCpTLdP+CM+8rslL+mSCIbFGjcGQm+C0nEhaZ06zJ
         GmyBsSGq+cb7Wv9wxBVT/J314HiWZ+uwU7NiKJhrBKzlvHX/IhtgqJg+JlwF8xXRVr2r
         Lz5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779350261; x=1779955061;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tSn2g3kUTBO9UyvrMevDMplllFpiZxqy7FxTUXL/Xlw=;
        b=UZN0Z9QaGza/ghcv2QLw8CVFT+t6Qk5+RyY29VmwdUZZdwXVvO7iwzwdnwQYW7luWD
         XULwwW+sv00sD4EAjwAe/s/aHzf/DFyAiJv74EW+iPve21epAT9+vPX3AOFPSdfaW0w1
         Pmh2qJc9RSZnYfFOOdyftZQQJrsRUhoxsCcijKzyBs4qTQyMLUtvSMEPT5HhqfXH5Lr/
         saNwnmVhXoDopcKvOmSWCVlFzbF537OGk9g9lp/i60yZ8xJHwWh4P59aN+LqI8bB/JPc
         DYynlxNKpLUJzXfqnLuwtlP7JF8vN0GuD5/ze/ODb//nvoakCOkU55ijPyQW/xjvRk3K
         QTAQ==
X-Forwarded-Encrypted: i=1; AFNElJ9OD/7bjJvSUqTvF3wpyyPnxlLsDKkNjamgHFAhGNTjnZJ5xWQtNUs/bFXynx5SwZhcrTM7l04NLQ==@kvack.org
X-Gm-Message-State: AOJu0YxlQ0AnvIgOrJJ/Njrpx1lasyfN3on/P2Iw30UFgEexuPMkk+oi
	q5N/rvCBu6L2OoQhZwkNNJjGEe1YW9mcytFErIksGPQ/Tchrb4RoTszjE5ibvjdlVe4P0T17//S
	qU9hy8hlr+xJaVNjz16qcXayhrMvYGyo60GUsU503
X-Gm-Gg: Acq92OG3KNxn/4lxOCQ1dvYluPydVR936oDbylcSSzvgjMvdBDzYW4JIyiT8kFOutMM
	V8pxlCjqS3VWjktYhRCYxz4h206YuZuFa41gc8nWxHAe0XcGoEeZwQi/1oMepPcKo95sGxD7Esz
	SywnTH4V7AhplFfBaB3zOGrmN5b3ywMiz3WpOEJSYuDKpQ6Idm8XJ50mpF60mrezZkWGcMBTbBw
	565lcr0f6vGVZ66T5Gx67ub5x9eSWTJcldhXOqDzURGhN9bQUr4CQyixe77WBdDpRstsTj20Y/u
	wpKTVYc1aXwmY7a52HVHwfRMPl8Qtw==
X-Received: by 2002:a05:622a:9005:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-516c53118ecmr5321871cf.1.1779350260836; Thu, 21 May 2026
 00:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-17-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-17-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 08:56:00 +0100
X-Gm-Features: AVHnY4ISxUZam6iBDjV_4hOaNzbNB8xZ_iFXhRAdE4nHy2L3vqI7KoUo1cTBaB4
Message-ID: <CA+EHjTyArkNd7cWC+OAkvkcPyM9=XUxzjg1fxFFV4GSP4wLALQ@mail.gmail.com>
Subject: Re: [PATCH v6 17/43] KVM: guest_memfd: Determine invalidation filter
 from memory attributes
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4F84F4000E
X-Stat-Signature: f19hdw1ham7mnuehy7fpirtf9w3op4rt
X-HE-Tag: 1779350262-94546
X-HE-Meta: U2FsdGVkX1/TuZ+2zWO5T0812HBppS66PDrtS1KUtU95AuNcyd3+IFPlz2qGPvB9yjscvpXkPbDHpODb3HlV5CNntuh6ifcqz6wp/FNbIzU+Mqxpl/AdJUx5NGecSUUGfILxaOqO1Dti4+yX6faNgVKbPIhjv8fG8RlfUs08u6KzsVRFqvW4+9c5v+wo/c/7f5s/m4NohwcaNlv7Qhm4WdnwEwHknY5VDnjZ4bloqeba4VKvNWWTGbKR+feVr57DefwpjXWuy6gEaWzbCCQ/YylQk7jriEAeNeaTO9bUjhcir/Z0e9ZTWKxYxxE3jLxT+RLJtruU4Oge1ktBYELfB++buGqnyaOtRi64tYsSuirWvZQw+NQdeJ3AkaIrtrellvRyqrHX+KY3GEPdJ4yPvBE1ONDqRp+Qz3hwfzloCevUFei5V2BmGBll/q4ghJcJW731jiW5zDCba8Swk38GfXMBXoYxtQ2nsxbiy1cSPx+ITAc2vzBRQl5+3Ias6l22T4H5AkPLoeKbymSkBz9JEeHuVzgYpwyKW1IwswZzxjGTSZVWpNhG1JVGr9a95jybsMSKcklxJJnzxQd9fRComC0LGeM7TG2u7Ds2ovmW3hF8jTuZOQw/5gYxSI+cASuCCnAsfGDHnhCILXs9aSmTAqsUFiKIwJP7GpSTjU7bVuTBs9n65jgvQH4xgb/ipo7zdOzxD1w+MWFNr5XuYVCXc/uhSwJoGDG0AOFDFKeXPGpap2Jf52KkhGUx9aPiF9cH23YpPlRzY/eYq3f9F6asgeWB62JKUiaw3vpp51qcikOfY+zgvitJEHF9o7yDgkh2nO3HBy4xPdP/Yxbb2znXVd6riV21KpAcimFlldi1NwjL7DQ1ycXfIPANUqhz29WDMwJ7mKg24Gcc7mqg81Xch4u+p/NUwpzKL6+08DAJ3X7AXSEECG72LSIPkGbfnx/Q21/1N7xDczurDqP2GPV
 3p15x7P+
 w/JPjexH0UYs6eu0pfIinNUOdAhDs+wCLjdklzQ5MiZz8hTiAFTzULzRpbuEme7S4PchOQRqbZAZ698npH7g4NHayvtI+Jt01eRepsIvOTtCmA3r4uTquvbvCUZcQ9xGEsRnxJEzp6ch0PljTfs3ckIrCr0gN2DKWQRoUc45rSZzLgDfztFzVrj71tF4H7V9svw5+d3yWIp7gYcfNh28gfrndyPhN7DeeohILnjbnkxWTexLHytUBLn+hOPQ9U/eDbmsyJhFm04EHRmozA9y9LcHMKdTRaVczlQdtkPjETe4Oo1ERPISP4uJH773XNOMjp5PkTTszJkzE7Lw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Before conversion, the range filter doesn't really matter:
>
> + For non-CoCo VMs that use guest_memfd, they have no mirrored tdp, so
>   KVM_DIRECT_ROOTS would have been invalidated anyway.
> + CoCo VMs could not use INIT_SHARED, and there's no conversion support, so
>   always using KVM_FILTER_PRIVATE would have worked.
>
> Now with conversion support, update kvm_gmem_get_invalidate_filter to
> inspect the memory attributes maple tree for a given range.
>
> Instead of determining the invalidation filter based on static inode
> flags, iterate through the attributes maple tree for the specific range
> being invalidated. This allows KVM to identify if the range contains
> private pages, shared pages, or both, and set the filter bits
> accordingly.
>
> Update kvm_gmem_invalidate_begin and kvm_gmem_release to pass the range
> parameters to the filter helper to ensure invalidation accurately
> targets the memory types present in the affected range.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  virt/kvm/guest_memfd.c | 27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 9f6eebfb68f6b..c9f155c2dc5c5 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -193,12 +193,24 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>         return folio;
>  }
>
> -static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
> +static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(
> +               struct inode *inode, pgoff_t start, pgoff_t end)
>  {
> -       if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
> -               return KVM_FILTER_SHARED;
> +       struct gmem_inode *gi = GMEM_I(inode);
> +       enum kvm_gfn_range_filter filter = 0;
> +       void *entry;
> +
> +       lockdep_assert(mt_lock_is_held(&gi->attributes));
> +
> +       mt_for_each(&gi->attributes, entry, start, end - 1) {
> +               filter |= (xa_to_value(entry) & KVM_MEMORY_ATTRIBUTE_PRIVATE) ?
> +                         KVM_FILTER_PRIVATE : KVM_FILTER_SHARED;
> +
> +               if (filter == (KVM_FILTER_PRIVATE | KVM_FILTER_SHARED))
> +                       break;
> +       }
>
> -       return KVM_FILTER_PRIVATE;
> +       return filter;
>  }
>
>  static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
> @@ -244,7 +256,7 @@ static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
>         enum kvm_gfn_range_filter attr_filter;
>         struct gmem_file *f;
>
> -       attr_filter = kvm_gmem_get_invalidate_filter(inode);
> +       attr_filter = kvm_gmem_get_invalidate_filter(inode, start, end);
>
>         kvm_gmem_for_each_file(f, inode)
>                 __kvm_gmem_invalidate_begin(f, start, end, attr_filter);
> @@ -367,6 +379,7 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>  static int kvm_gmem_release(struct inode *inode, struct file *file)
>  {
>         struct gmem_file *f = file->private_data;
> +       enum kvm_gfn_range_filter filter;
>         struct kvm_memory_slot *slot;
>         struct kvm *kvm = f->kvm;
>         unsigned long index;
> @@ -398,8 +411,8 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>          * memory, as its lifetime is associated with the inode, not the file.
>          */
>         end = i_size_read(inode) >> PAGE_SHIFT;
> -       __kvm_gmem_invalidate_begin(f, 0, end,
> -                                   kvm_gmem_get_invalidate_filter(inode));
> +       filter = kvm_gmem_get_invalidate_filter(inode, 0, end);
> +       __kvm_gmem_invalidate_begin(f, 0, end, filter);
>         __kvm_gmem_invalidate_end(f, 0, end);
>
>         list_del(&f->entry);
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

