Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52733CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 10:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B3496B0088; Fri, 19 Jun 2026 06:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263BA6B008A; Fri, 19 Jun 2026 06:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C9B6B008C; Fri, 19 Jun 2026 06:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1FDA6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 06:10:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A598A03B2
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:10:40 +0000 (UTC)
X-FDA: 84896243040.17.4E74E7F
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf31.hostedemail.com (Postfix) with ESMTP id 640C420004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:10:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T2d2bZOY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781863838;
	b=ET//91WzW8H013yKzzsLT3UuNebYWWBHIuElOLmZ2JCRUQ7KZZJX+IfaQqjuFKj904vDlR
	gebbgDEKK0amMKQsJ7qYAwznhPu/dj21jLKZonpPhqja+Z8Q94SalLe9zMMQJDPJGvfBq2
	8Z/ElkP5/yrjo08g/Boqt4MSJqWIfTM=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T2d2bZOY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781863838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTbB12VLXQ7u+hWMaqy6RpdQwZfV/8Fq+ivaXV4AweU=;
	b=eF7Lew2nhAP4eqNk8Ct+NFPUHk6vdS3lSU2yXJK90ADidVHHuG3yLPb80voyMCU69kCBDY
	8OaTJcwcIMuLNrIaQexTNIFdd0Nz7scLyrfDMNl3w8494Ww7CtAMcbBSjqJe7ZryZg2iKo
	/+pVHTHYUbOt70WlXFxzRACarDk0mI0=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51765531803so224071cf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 03:10:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781863837; cv=none;
        d=google.com; s=arc-20260327;
        b=klWJ012aGTzIr66FWn05kRPS6aTmV8P3wplsNSiShP7gdw8Wl/Yz2CpCcxnTqVGZT9
         8NWILT8OONYbZcc3o3HMTuX2x686L+6YIessZYs3okstBhi0rCY5uKoxIFKGhSZGi4Lm
         s5aybCGZV6qEPtY0u/cyQz8P4DsmiVerUN9Mer1PQCo60d2K3zlHI97MG7Y7Zje8lIy2
         h0EIlovo2Msc9d8NUZmlBhti6rlJwSTa1TLnpheoFRmmVT8+sMwgY3L85IPbU2qJ6Xo5
         iAxqMuxPHzZtzchRGwfzquwGZg9RssYgtxsRrjX1fE9x7AhNj5MC2KIFmbq5ezgGfPlK
         PTjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=RTbB12VLXQ7u+hWMaqy6RpdQwZfV/8Fq+ivaXV4AweU=;
        fh=xYvUKxmL6+tFRbf51StdjFJi/1RakuLRXGrLpypKlNs=;
        b=CM5og9K+FM/BvBPRVoRF+g6glSXCNCXe3Bg8etCckwPYHhSrbGP+tUoWz5s2slNFba
         acyojoNqOCjg3AwL88tnJZIPoIKq8OuZY4uEEEMIzAGmTH+ZcuNBrZFvaDEjmAIrGGZb
         iI95XqyjYKSvIg+1IY13dQD5QTEEqDWGQdH5cvvzih9LXdBmMqU1w6B2chix1cwTvYM7
         iDy54U8JwRgQlnSoEEd/G3QR2d9B9OGZGGgh8lfJkBOvSq8FuxV9a/dxiqyxf35OCcVJ
         6xVptvzKP7tbcVXH6WWTzWVR3SMbQOExqogEqyOqu7JoUiooURljss8HdnNBa4AZMQGw
         05bg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781863837; x=1782468637; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RTbB12VLXQ7u+hWMaqy6RpdQwZfV/8Fq+ivaXV4AweU=;
        b=T2d2bZOYlM1m9Hxgdb1awfOUZWc4KEY+MCjSPULVK14Bms8D6NlDJGCbSttXUD1QCA
         8EAwmTOgKUQ+OGZujsfXQX0KHFXXJiNDR9uKTGBHgiWI++2MDUHEIr9dpPlCw0Wl41xf
         RL/IU0t/+SL2ey42wcyYpFOc+5Tglm3NV7gYCi//yLnULgOQgWIHz+qNWltYt8ZOXGlo
         1IL4IYx+2k5q5Mz3PxA+ZNmw+d1RnJv4JXxEk8PltpPiQd6EdQddFBkUYplGh2uMrtmx
         rpH6BUCz5EGFW1Wvd8DpxfvcQXkre6vXGvbTydWgXECKyU6I+2dJ/6dzQK491Y07Cnxc
         zxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781863837; x=1782468637;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RTbB12VLXQ7u+hWMaqy6RpdQwZfV/8Fq+ivaXV4AweU=;
        b=e4WydtYY7rAjpDOVYhpc/03F3loRVA+hKwCrynJl9aWt9N1h/PrYZ9gsam0gzu3Cn/
         DvUQKkS+sRqYPJk6yef6gEeYszQwGLJ014QHoYAIc2V/cOx/GB4EWB2zfjPPmOj9IK2D
         edW6+ftFnd/KeMgafKpvBiukdxo7B7z9ObpXT0470vx2sGflXDX0vH54V0s+mskoiamo
         7+Mx2iUxJMy+ZG18rahbAtVYPyU0PCDFhTVG5T7F1UZ0a1wCutwed3G/u/LH+I1wRuP+
         PJleTKAIUBxsH7kxJDraMoMyODyq3jh8mmPLOoCY0kDhUCR2aWsSCv211IvdHj+1Sc0B
         ygfw==
X-Forwarded-Encrypted: i=1; AFNElJ+YkqwJdNol44AO/8vzmh9k/pEJtqLmuVf3rnb7fadLHAZtg19qLcJMMuSL3RM5L/HHXHA1qttOJA==@kvack.org
X-Gm-Message-State: AOJu0YxVNUj/YFtP7C6YGWgw3Phdg6Js5Q2X6K+H3Af8fWMzlOe3N2vS
	N/F84Cv5kv0ObIyi/ASoM9W7vVon7h40UntbXSKdmi9oKpyPgVS9wmAM7cp+vDo2wQIP3CP92y2
	m6DKYqcoWSR6rcji0rS26xnrV6zfwo/ftXzZjR476
X-Gm-Gg: AfdE7cnTSLmGpi7NIsZhNJ9XSNjpPZ3uwcPkHSgb6/QczWILhTY/6+C2dhHlb6HAumC
	yTAMD0dDKiW4efs7ECuHH1AGd7Q5o4TAoK74XNmyFQiG9TOcCVTO2bfpopuqwiPAgHiBdwfk+Fi
	Mb8yFvbFnnOxzmxjJ3XaZ22qRqLZqAN67EbxJBmnodR0rsmHjLeteaX4SuWS5Vjefx+cAgza2Ks
	qMBF3WIXOry5j3AQmjqdlBtms2OV74fWfEr3atbhrHUjF3F60GbrNg1NHuvZhM3cS38qlikwA==
X-Received: by 2002:a05:622a:353:b0:517:99ea:ab79 with SMTP id
 d75a77b69052e-519e8e7516bmr5933751cf.25.1781863836675; Fri, 19 Jun 2026
 03:10:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-15-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-15-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 11:09:59 +0100
X-Gm-Features: AVVi8Ce16E31U-w4-XubBsflwMOtK_nv4nwaxzfJhxldigbujwW2ZBTzRORImb0
Message-ID: <CA+EHjTx+3U++dnhGEkwh2SO82xMugAvvJ9ee1O__sxZCKL_X5A@mail.gmail.com>
Subject: Re: [PATCH v8 15/46] KVM: guest_memfd: Call arch invalidate hooks on conversion
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
X-Stat-Signature: 8t99fspuj41a8ytbnwnua4fx4kef43xq
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 640C420004
X-Rspam-User: 
X-HE-Tag: 1781863838-469326
X-HE-Meta: U2FsdGVkX194a3cEp9ijoyBmdSUoHj68k2TLYUBjVOLjFR/Rw8s+gbH8PSnK0LDTGdLLKF6hGWv7xzO4RSDPMU+mHO1eZkHz68EEFcs6CaAnNRYXyfsuMA08Qtqo0I8UJEhFsdNzFmwexGCCtw6HAOIDG2jzRnUw5S+pncOGLWb+sH0rL8GPuKFJKQPT+5qU6TwBvASkm56TozKAW7rAQ0bK19Yu7hjkTGWcXezvtY97/0j+qDz8zFOqXs34/aExzNpULmf5VjEdokJPzk55vfyAfhIOHuaAs5ugnaC8oFWJyI5Tn8jg00+sfRuby3O3O9GXZoi+3S/Yrurkbxei0Pec0KXLYTuyAMQjnXRgp7vJH02ZhSkjPUENRnu6MxhgD7zfnRiGuphj+nJXbtmI4UcZFMw49zg4fO8opSARZeeX2vD3LCQ1G5kajuqb8KOwcV4RcUQento4LHXLTvKCL43WU3SUkyPelsrwzW5K/Bt8nGiaPOcnQbnV1KZ7sCs1G7RvcL6nUSBH4+6lxji4zyhHK1LGjuWmjXWj6wDEAQ2PjDsBcXyYReiyTLxmk69fVFSlJtMQpMzqtAShLa9D6ARJnlGhfc0oHLaESsSn/W5TL+/NG9nhywJ8zDuH29aKTyjJf3nMDmOq2qpP1+TL9/t2nHrGN1Zd5DEVyKK6i4M0IXy5IbV6ZAYhNpv+EtJANKkQ17s4WI/H+SfnoOTJpBd0G/KF0xqp+G6SFwGaA6jqq0Y9ENFV63s110QjklhTL4mxQU5NeFFEi9BqIADwiFh2aX0HYqVk1+sex94KePMqzJmL/ZoLSuIAO7pcFap2T/5K+VNcgQJx4r40Zq6Pc1Xf1vP+56Dd7CBL4UpjMv7LEuyxk4CUJhRl5DVyiCigAVHsZq/j2kNBBTwFS9y3x43Lxh+YM3QvDSiiJR2Yyzo8Keza+OJyfwK+zylh1AeVkLakTFIwY6SyxVwXGVG
 7nHWGZP+
 6l2UBWSrrvzpKurJZ3TZNv9nBtcM6T+vM4XNGVJivAYCRSgsyaMkFytbJKvzL4V6ahcMSecK5tpz9t8awYGd1YU+EesOKzRLCFw+Mk/IzsBfepNVMlJi0qfnqqSSpxRIGpElqAbShAZBbLz/8TlOPU2uOqLbbWowCHBH5BTgvLPmxV60dd7zCUh5ajBaHveBllZbuEFKjAfSATJjmI0D7gJ8oELgwmwUT4JL0CxRowbF5DjAli+veK6assDERb8cdZ/0qL18OeDui+xFjPOL+xmipjnYG4FkR+FYPw+MJmh1Lo1/Nz/SSKJeY/xAfeckE/kr1Iv6lcdAXGn0=
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
> When memory in guest_memfd is converted from private to shared, the
> platform-specific state associated with the guest-private pages must be
> invalidated or cleaned up.
>
> Iterate over the folios in the affected range and call the
> kvm_arch_gmem_invalidate() hook for each PFN range. This allows
> architectures to perform necessary teardown, such as updating hardware
> metadata or encryption states, before the pages are transitioned to the
> shared state.
>
> Invoke this helper after indicating to KVM's mmu code that an invalidation
> is in progress to stop in-flight page faults from succeeding.
>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Coming back to this after working through the arm64/pKVM side. My
Reviewed-by here is from the previous round and the patch hasn't
changed, but I missed an implication for arm64.

kvm_arch_gmem_invalidate() is now called from two paths with the same
(start, end) signature: folio teardown (kvm_gmem_free_folio) and
private->shared conversion (here). For SNP/TDX that's fine, conversion is
destructive anyway. For pKVM the two need opposite content semantics:
conversion must preserve the page in place (same physical page, the point
of in-place conversion without encryption), while teardown must scrub it
before returning it to the host.

The hook gets only a pfn range with no indication of which caller it's
serving, so arm64 can't give the two paths the behaviour they need. It
would help to signal intent on the conversion path: a reason/flag, a
separate hook, or not routing non-destructive conversion through the
teardown hook.

arm64 isn't here yet, so this isn't urgent, but the hook is gaining a
second caller now, and it's cheaper to leave room for the distinction
than to change a generic contract other arches depend on later.

Cheers,
/fuad


> ---
>  virt/kvm/guest_memfd.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 433f79047b9d1..3c94442bc8131 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -607,6 +607,42 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>         return safe;
>  }
>
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
> +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
> +{
> +       struct folio_batch fbatch;
> +       pgoff_t next = start;
> +       int i;
> +
> +       folio_batch_init(&fbatch);
> +       while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
> +               for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +                       struct folio *folio = fbatch.folios[i];
> +                       pgoff_t start_index, end_index;
> +                       kvm_pfn_t start_pfn, end_pfn;
> +
> +                       start_index = max(start, folio->index);
> +                       end_index = min(end, folio_next_index(folio));
> +                       /*
> +                        * end_index is either in folio or points to
> +                        * the first page of the next folio. Hence,
> +                        * all pages in range [start_index, end_index)
> +                        * are contiguous.
> +                        */
> +                       start_pfn = folio_file_pfn(folio, start_index);
> +                       end_pfn = start_pfn + end_index - start_index;
> +
> +                       kvm_arch_gmem_invalidate(start_pfn, end_pfn);
> +               }
> +
> +               folio_batch_release(&fbatch);
> +               cond_resched();
> +       }
> +}
> +#else
> +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
> +#endif
> +
>  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>                                      size_t nr_pages, uint64_t attrs,
>                                      pgoff_t *err_index)
> @@ -647,7 +683,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>          */
>
>         kvm_gmem_invalidate_start(inode, start, end);
> +
> +       if (!to_private)
> +               kvm_gmem_invalidate(inode, start, end);
> +
>         mas_store_prealloc(&mas, xa_mk_value(attrs));
> +
>         kvm_gmem_invalidate_end(inode, start, end);
>  out:
>         filemap_invalidate_unlock(mapping);
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

