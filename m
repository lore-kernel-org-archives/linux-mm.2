Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DCC4CD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65FB26B0098; Thu, 21 May 2026 03:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636446B009B; Thu, 21 May 2026 03:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D916B00A0; Thu, 21 May 2026 03:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 450546B0098
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:14:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1856120565
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:14:08 +0000 (UTC)
X-FDA: 84790562976.02.636E5B2
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 072594000D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:14:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vqXqCD8X;
	spf=pass (imf11.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779347647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNOn4o9NVeTi7pLeKizYhzgihd3OKpoLohhH00DuQC4=;
	b=yBRtMQjuY3e9v7tVHiLLTdml8+4UwPXD76fLdB/L6E3et5Z4Ge/dxOGXGr14fV9o7e53u+
	vwd+rLbPHP8V/yoaVOwV/1pgHVMsnM7rdg5k1cRdVUAPgI6r/QJa/FE2Uf4tVwgaaUctis
	Nh0m7akcV9XbQyRz/mDjkHQyAu1b39g=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vqXqCD8X;
	spf=pass (imf11.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779347647; a=rsa-sha256;
	cv=pass;
	b=X7QJzYfAjgyiMUosLbfkAEuUAUdcPeKjXv+atKmCs/fZRXrHm/OGmAeM0TQoq3Z43DxLSx
	dWZwZVc3mM7caMEI8mzirMCqMb77DHGabc5vXAxuobNCIaJFDFgIsN+McuQLuPwPWrjqIg
	unF1e09XdTNI0NHBAvdqwuvk8yV4y0M=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50d6b393d60so5271cf.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 00:14:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779347646; cv=none;
        d=google.com; s=arc-20240605;
        b=EofG9oEYfm3gktQwmbT/8DiXpQ5PTPpoSW23pVagAS62g34zEBwHujG11R8CQcedPm
         2ql/JBx9kbgdtaqbVXhPsXsNUennQaLSAWIkcgXCa8SXqo94aDR8lZIR+Czwo2zV1/vt
         50bxC/da77YoLJ9zVVBE5iuT7bSUFCe5bwHNAwQ3kT1oWpx1XqG4ErOtB/4qpRWolp4r
         wP5UR6OD4K6hVZDM/UoF0sNLAKilrZna7fKNZ+HQEg0PHR4JOgiggRTRExNjryjJD6zZ
         lmFdCmuR7sc+VQNsNBVeWgSF3gTCyCFTevKPC3yB36aiuFxbSTUjoOtP9FOWKWpuULZa
         /2/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uNOn4o9NVeTi7pLeKizYhzgihd3OKpoLohhH00DuQC4=;
        fh=kxYRTdJBWFYQ/JPmOjykVZtTQy1RFQeS8BxD1SJb2jo=;
        b=kIa/l8bTIIQqiKo9DDyHx0gY8vTxBgpswMDKn2GjJZKv+nq3h9y7GTnKzHKnqRQYl9
         avrdGD9dU9Fex5CV+G+NsJ2KLO1ZehIVp0zAk4VVwQAaH2TALvW8wkBlfz93fJfr74Kg
         2j6kZ9aZey6R06xvud5eUFHKW4VVEEH5xOKPQDXbu0AodK+F6FW7MGRz4ITrEvR8fcQb
         is0sQ7l2KgwyLuJZ/0+ZGmx3sMQQRNoxOlJuWGR+InBN1lbIFO6o+wKnUar0KVeWUzbW
         UXVqcfUlmK4HzohDYLLC9nK+iOwwWLgXwwCUq5fOjAg56v2dS9+mLtceTDcJMXyHTpgP
         7EmA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779347646; x=1779952446; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uNOn4o9NVeTi7pLeKizYhzgihd3OKpoLohhH00DuQC4=;
        b=vqXqCD8XRQ6LBG6aJe9ylgq310oZcvUcJjkcToKIJJi+V77pUtAfebruSQalV1w0r2
         3xH9RcB9ORk6j7gjQ159f7x8I541KiOS0xSTaay2Ez1nvXao4GQ+eVjZ3AraGKXWH/iC
         ETkMB5pv2YXawPL2X5q9jnLbkhXMXtlzCBC2ScLw7bF1Kr+IifKm++U7aAeUpuHHQc9S
         Bsx10dTwLMT5/XN6VzmPziZVFXQoCffpgxpU9hKViM/NiHhGBqoGOYbxDxOCeOosFNUM
         EP6iYnmsJTMn4acTj4xVBM4Pc7yoZpeekVER3ZKSHP+JmFLMx10AQr8LUFJ+AtqsmqtS
         mZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779347646; x=1779952446;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uNOn4o9NVeTi7pLeKizYhzgihd3OKpoLohhH00DuQC4=;
        b=JKUCozwyxGmuYtDQeTthiCp0wG7FOvmTLHMcnyrWlfNScNLn1Vxg6MHiODgjuEAZwX
         p9GEPuWHMwwBcu0t6uS7WP6xU6cXSTVmBV2eB/Kx+1cannNCR+tYkH5ba1sBGlUIhpAp
         +qKSvlKj48L+s725VXe4dwq/fQopSDBZfB3F+WXpIXZ85Py9DphgeBLquEgYisyQconD
         YJ/u4pC288wbJYdmcOHb13vGNdaUs4ZVHHF6jqAnGsSxHsvKaCcIC0jVBE8pAGE0kcr5
         8iqOmOf/sdU+cdRBYSGOgK04mLSr+NWYB0mEktoSJt5aYSxSonguqrAifa5EC+14csfp
         5R+w==
X-Forwarded-Encrypted: i=1; AFNElJ8Lfq4wINZ9NbhyYG43o821d28S/DAgmHkEh5v3yKQisbHOrQcdLOYbT+Ny1wYXjJ5xaXn08xjB9g==@kvack.org
X-Gm-Message-State: AOJu0Yz6d/zRkY26N6cT41jg7x65mVrdhZc0xwlgpHWVIBWTMqWf9nHJ
	7kmWdYIxr5pkBAP384sGxnRyAirUotVKPIk7PSiINA+EdiHING6se8/TaTFDCmy2yGX3YPRTpUn
	28ixorYZGP+wFPOflxVObT8GtAqMcr0tVM9ehGzDR
X-Gm-Gg: Acq92OHAJDutozgb1aMN5CNxSKZrrKpHiGOw8SP2GavSqrfYq4Ut5LiyWGB9Zv2nO12
	TdJMqvKZyj7A/Mxo6X758/dk0p3iEi1mqQAYUIXLZtlUS9aJtKX8SBqlPCGrgPLtT/eZQ5uQ/qS
	J9CbnUpy+nxBYJh+PE8jJbkza041h5QsZ6Zc0gL4cuVKWopUXAYov7s3BkZVL1khd8wOj6oJiXi
	VWoJXVaUyInPbwqw8gZBaj5yn6v+0XGw/k4W3cYm5G/tyBrkZmpmSArNdwpHkHp3tPJOf/cD5RI
	WT4T/7/m9al23SUpcfhqI+qeeKwchw==
X-Received: by 2002:a05:622a:9d8:20b0:516:4f62:85ea with SMTP id
 d75a77b69052e-516c553b726mr5238111cf.21.1779347645271; Thu, 21 May 2026
 00:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-15-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-15-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 08:13:28 +0100
X-Gm-Features: AVHnY4I5mlImmNgj6VU9Np6tF4MeIY8QXPe0q5_43DkzSppchE88oaKE6aKRKpA
Message-ID: <CA+EHjTyZx88qAjKc=W1GOTMLdDFpTjuJkAPJ3W6Snnyn3ta8tg@mail.gmail.com>
Subject: Re: [PATCH v6 15/43] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 072594000D
X-Rspam-User: 
X-Stat-Signature: 6dcn5i5i3yyhgpbpiyfkmp6rt997nsj5
X-HE-Tag: 1779347646-106749
X-HE-Meta: U2FsdGVkX18DLKITRFbz+FBOMwIXFW5VXE5lg/ZKuwO0sKrGZ+ix7Df25EqGnyiIgrTOJ1pC39Mc0L/M9BnfTMH4O3z6o/oKn/9gZMo1wu5p68/OUGYS2S0/2u4h5cbrZ/8Q3Pp6WW7U0wlXlViDHrXlb+JqDgi6HRQcls872ZmUPtF3kkF5Kc+Tpm+FgP4cO6yrVyhBcwuwYZYDJbm4q4iK3wPXt1lB43446cv+nS33BMekuMymSAYniHFpm/1aEoon6n2ZWcZZkzsovNwwAgmuchyVvRZcQDmhZyPU560P0PyYdVXWrtwBTgnFzDtG1/U0sIROAloD48LoX5UCoWdxApuJX+cPUPp1+Q6iq9mVI00gOwfjdwSdwTDE9ES4mSNpwx6glnixL06QvFQj5ijxyssUdhM+vsRS4M24+xZMtFPCiOHEBqE4c3iEP1uWmrO6trD7vNDlOUMqVJP63+xOgQRpP291wQ+h3ukF2/ZA6qihu94Zi9V9cY/wJQtXxCWj3lXmeL1e/phzMeZ2kzlL/+0ih38UyUdZFiDTVpLTDMjTdLjb/mLb20OBvC73maJ11gFxJdQnE5ZKtTEp6Bjg/fREJpkXsNBo0nXhXqq9qXVIqQG0x5VnToz/XJavE8HtMJeuOFBozFrKlTtQGWc4dOAz/VhMbsRP0sjfG84AVUDkCuajalVPG9VoUbvnPS8pa8M14pUwUDliSXjI6AobWphx88rXSQ0Yxv72DwZ7OZQvSn1lWXamq5UHSclnWeLMAgcTXzF4jz42GCy43kKZcILS+MhLxPMPAtATsrB4b+zFE0J/JexyxJHAeLW19oeqvnwcVb2fbNiSDhUO+9JVHUQI0lkD1KZw/IZpiT+Sozec583U6zP5MqeU829Tztar4Bp+qYrGOSnNQzy34S49YSwxHURLBMLOAXFWdo75h9rID3+Hm4V9ThcQUD3B9QaJlCSlj4z+8IvxA+2
 EidqhQt5
 qoMlJNj3tghtCljWLWN8G0QGYAX18uMQx2Rb4uR4EVJgYy9UdLsSg7fe9eGQ90kEagEDVLmm9ijg/4vU7wU/CqKOW/JOdLH19ls8jTRCXVha0nHmiIok0pU4omy1800PnwNrimH2P0Y8Fi+KEom36fIhrCjB8L9sSt5QMCKFrjn5YYfOAQ8DzMHL1H/VP0sXpFANJ0OkK/9aBdPM9aDOG/91wepRqqj3Q9+0Lx/5cXaKaskBNNjQy0IqcpcgDgxZHfX30DpB/IKuA9QX/uzIX984g7Qpmswtc5Fi2FcTUiXddNIRDU3LkfUXkB5o20Ovbcfy0ZNLQ5nr69SQVU//ZE2ZOxfuw1DD2WPK++U/7ks4msUk=
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
> When checking if a guest_memfd folio is safe for conversion, its refcount
> is examined. A folio may be present in a per-CPU lru_add fbatch, which
> temporarily increases its refcount. This can lead to a false positive,
> incorrectly indicating that the folio is in use and preventing the
> conversion, even if it is otherwise safe. The conversion process might not
> be on the same CPU that holds the folio in its fbatch, making a simple
> per-CPU check insufficient.
>
> To address this, drain all CPUs' lru_add fbatches if an unexpectedly high
> refcount is encountered during the safety check. This is performed at most
> once per conversion request. Draining only if the folio in question may be
> lru cached.
>
> guest_memfd folios are unevictable, so they can only reside in the lru_add
> fbatch. If the folio's refcount is still unsafe after draining, then the
> conversion is truly deemed unsafe.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Not an area I've worked with that much, but it seems right to me:

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  mm/swap.c              |  2 ++
>  virt/kvm/guest_memfd.c | 18 ++++++++++++++----
>  2 files changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/mm/swap.c b/mm/swap.c
> index 5cc44f0de9877..3134d9d3d7c30 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -37,6 +37,7 @@
>  #include <linux/page_idle.h>
>  #include <linux/local_lock.h>
>  #include <linux/buffer_head.h>
> +#include <linux/kvm_types.h>
>
>  #include "internal.h"
>
> @@ -904,6 +905,7 @@ void lru_add_drain_all(void)
>         lru_add_drain();
>  }
>  #endif /* CONFIG_SMP */
> +EXPORT_SYMBOL_FOR_KVM(lru_add_drain_all);
>
>  atomic_t lru_disable_count = ATOMIC_INIT(0);
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 034b72b4947fb..050a8c092b1a3 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -8,6 +8,7 @@
>  #include <linux/mempolicy.h>
>  #include <linux/pseudo_fs.h>
>  #include <linux/pagemap.h>
> +#include <linux/swap.h>
>
>  #include "kvm_mm.h"
>
> @@ -596,18 +597,27 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>         const int filemap_get_folios_refcount = 1;
>         pgoff_t last = start + nr_pages - 1;
>         struct folio_batch fbatch;
> +       bool lru_drained = false;
>         bool safe = true;
>         int i;
>
>         folio_batch_init(&fbatch);
>         while (safe && filemap_get_folios(mapping, &start, last, &fbatch)) {
>
> -               for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +               for (i = 0; i < folio_batch_count(&fbatch);) {
>                         struct folio *folio = fbatch.folios[i];
>
> -                       if (folio_ref_count(folio) !=
> -                           folio_nr_pages(folio) + filemap_get_folios_refcount) {
> -                               safe = false;
> +                       safe = (folio_ref_count(folio) ==
> +                               folio_nr_pages(folio) +
> +                               filemap_get_folios_refcount);
> +
> +                       if (safe) {
> +                               ++i;
> +                       } else if (folio_may_be_lru_cached(folio) &&
> +                                  !lru_drained) {
> +                               lru_add_drain_all();
> +                               lru_drained = true;
> +                       } else {
>                                 *err_index = folio->index;
>                                 break;
>                         }
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

