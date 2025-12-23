Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF512E6F086
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 17:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2EC6B0005; Tue, 23 Dec 2025 12:50:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A0D46B0089; Tue, 23 Dec 2025 12:50:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2BE6B008A; Tue, 23 Dec 2025 12:50:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 070E26B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:50:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A198D13AAA8
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 17:50:19 +0000 (UTC)
X-FDA: 84251474958.23.68594F2
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id AF5641C0003
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 17:50:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OUqXQX6J;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766512217; a=rsa-sha256;
	cv=none;
	b=5G3KuGmGNMDDAbes6DfzJKXoSNM+jF9l7LXxGwEgBnliYL4yT8cmp2fXw9Uh3oChlCTMii
	ITHlRPzcQtqezhM6yB6MKAeCCqLil0FSKSxGwhUD76xO4+Uj4zxd3R8gxJG94hVYYxZNv9
	S95PJsa2A+IPDJVBnPwwqeiVeP9gJ5A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OUqXQX6J;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766512217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ok3Aj/qyWRE1hCf9QqFvj0/4fcSMjg0OoyQuUL19KWU=;
	b=n0Iw7ToPGvWusBgHPCZa5K/5OPIxUKEDTB3rma/M6If57GvufBlAom222DWnMQPpMI1Gm1
	4wH/y1GG50er7vbbTbVNTbCvaOs7A5gXmUp/c8NKRj4aM9h1avE9f4GkwoNiNahXqyAMg8
	TvtZ4nng3WHeeqGHeXPpDVpkTUgY4W4=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b727f452fffso1008371166b.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766512216; x=1767117016; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ok3Aj/qyWRE1hCf9QqFvj0/4fcSMjg0OoyQuUL19KWU=;
        b=OUqXQX6JzvwQLwc8WioyklDIjffQ6Nda48Ng6WEls4K3cnT3lUIymmfF/hRHwXLQW6
         9DYfGBKZyP/PzWHT1pFmBX289nnfiADkpzqqbhLuUx1AuXHOBpZ9IYNSH2Gl6nZc5/1+
         mYPFzA25EUyux+9clxB+fHN2rEShAiiuMA4WMz3ql3Tm7uTRYwz50lW9N3gYWZBXN+IS
         K4kZyorjdstqA/9KWBeytAs/bQpX6B7s7qDuD91K8HA52lsEUPmcnXiC3tVvGZrGlfto
         /3x7XhPHt4dXHCSDoyeOqibqyeJ+Oj236WyUHoVlNyrp28IVUCQleOdEKY9/SKpwU47c
         NiFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766512216; x=1767117016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ok3Aj/qyWRE1hCf9QqFvj0/4fcSMjg0OoyQuUL19KWU=;
        b=v0p+IqsLZS0/NzvcAB7GYXUDXEda0t/06UwR2yJxvTUR27RSojn7dsLgrHMgwKL94y
         ZU9QJwGG1WXSaeFeNg7Dr6l0H/lkDmfAIzYIIn3ZAw1sk+Ylh3NNoxTjAvQ3LxX7HCba
         ZzORiiKzUnuChsoZ49jDZ+imeeAsd7P2n8dDinUjaSrVR8gbfrfGD2C27t/Uf9sZQrOH
         hpzLR+zWTTY1Kza0ZtO9BAXKw8L+Z3EzoaLK46Jro8fvaxAlW5LSEqhPufqLyNhZ75cx
         C0vb206jYd4cxoC8+U/bSelUzUa80lcxscw7RiIp8qGZsWL67rBKJFCfycNRHVJgW+Z3
         BEcg==
X-Forwarded-Encrypted: i=1; AJvYcCX2qJC+K8kD077gq2MCqpWpRxBllTd/FJDewrCJSJRS0us0LKnW/tg1u9QJzP6LOcx/xnh4mjdoZw==@kvack.org
X-Gm-Message-State: AOJu0Yxg2kTiT66b0/CslD+Thhc5SlfTFZSHcPEhPrcByXEakoyEH4bL
	KvBLhW2VFAuCv4ZEBG7ZukzAOiszk11/l+zBi9P3ezHYaJltqm3NDB++mls6/42fKta/9Q26esi
	NhqdfZP6DPTgti5RJNpBkSdjDGCS+bcn6bd+lWRCSRA==
X-Gm-Gg: AY/fxX4nE7GWB+Ob3MaEEVsLC4pHHbfs2U+lkRO1NbAXvKP5WKlDTWCCMJZ7HYIdjZU
	RB9Yxqoat4eUMU28sekgAQEUvdT3jzHbcLI1xwqkRDOSkyEAWILsvDZAI9YgbGi/1C7EsDY87dr
	qqKaMKed1Oleo/V56aVpd+WU0GYHUVbvpclqZYilxk9Rw+ebx7EIoTSZjtiwu/wrz6lnpDGepIR
	BhL+o53SOPjG64O0kxwPPbCQ1AcHs9mbL/4MuxVBabFB0loZpc21L/0r9PFy5VrUhZM1O4yOYFy
	ZpEMsnHr4ciMiCs+TesjTOWsmA==
X-Google-Smtp-Source: AGHT+IHpM1t2D8hom0JAjvCmVAh1r2zpdM9beyI1kYn99D4aa5g9AkslkSjbRb3fRBVIViB0dpMOcMDXtwKoyXUcSf0=
X-Received: by 2002:a17:907:61a2:b0:b80:3fb7:8e68 with SMTP id
 a640c23a62f3a-b803fb78ef2mr933875966b.21.1766512215920; Tue, 23 Dec 2025
 09:50:15 -0800 (PST)
MIME-Version: 1.0
References: <20251223104448.195589-1-pratyush@kernel.org>
In-Reply-To: <20251223104448.195589-1-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 23 Dec 2025 12:49:39 -0500
X-Gm-Features: AQt7F2pf8XmLmwqluLaF5vHB_10yuSQHlsbc1JXgZTMDrcOQxJTZMuXQmSFqybE
Message-ID: <CA+CK2bBv2wpduYQF_fwzciH4HxZ6eFjwZMSpZwW0AC6KXL4msg@mail.gmail.com>
Subject: Re: [PATCH] kho: simplify page initialization in kho_restore_page()
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AF5641C0003
X-Stat-Signature: 1at9sa1e59fhg83xhs6heqdakx794swn
X-Rspam-User: 
X-HE-Tag: 1766512217-819807
X-HE-Meta: U2FsdGVkX18G2KWsAbwgBw2oJpPcSgzzvI2icEbGfcUSo1XGLpzpGqvUu51eosY2/7t+jWcwLu4bpPgEIihIBpARBzJrAHLi0cxD/dLR/msBdPxA9xop8y7htme2hVI+a9eQlJCbkglsLimVGoESO3ybY4AAhom+QsNWMhkyB0qvaz9t9ZcSGgkms7QRIclOhDoZZSx4EIfqEM1gh/pYaP5Czf2/YBK1011CyQsYPF/8Uhz3t1s4kA7rUq/qP1iEbOjZl5OsR3F4QLI/8ZQfNH8x+2nZxxrbl0cTpqiLIfrD/QHT3JjSakD3AujsAREP4MSp1vXAbrs5vQJP/rxQLyEjuDRYg1FkQvdJc0Yc7Be1vV9IZ2F0Bn/WJQicXIiSp9T8xOTQ/SZTMpj5Hl+KrrYu6T/v88hrxGQQqPUluI0H2cW5XBt7OwqaKAdn3BkcJZhoTKDOqRFztMWhNQSQYpnP1ThpuFv0ceeuZuC8mU43UzFbim1qEtbZIhpEtw62p4h3mlFJpC1V8b9Ev6zPgRGxaFVgHJ3WTSLKnPAz9AwL8MN4rGvtOWoEuM3wJaE0DrUOZb+dM5LCXsVRazdXXgxqFjBBD4v4rRhyg5Eims2N48TODZwu4cthkWd6BFRg4zH9qUxq30lJR5ktPt/ICY9P+zHN0dFniN/yAc28MyLAhH+d6HswmqBZM4glygLzHoFON7FEzgfIR38gwObio+4hsUO8zXqUKuTDIm1wo0hmD0oqUZQzyu0PLB60UKYBSW6K91Pee3PykpVIl+E2mDXBCK6i7isjNNpfosZcIRNsjoxCHLPHtEloLBOrE3zyM+SyxhkvHEDKY6JRIZXRUUPRpFt90BUU36SpAilDMZOmTuiNeqQX8as63eOUvLyF5HMaS0uYHBLqv5/vTzNqgPMWya042rqbMFCZIuqpNQcgbaj4fBSpbuakWmmj0L1OIf7MetespE5LVotMppQ
 QLYdHmkE
 VnaueHpZ/BjRoG8M7OAIaLTCs+nKpWEA9zXVeBcLmc5cKRhCW+l2gNjybW5uO/JDc2CkB/eWzvQfD0u6C/AKa3krRLBcseDgV24wd7Z17WYKR1SEfJgmRae2e8c2CKxA1TkFwCHRMSfA4ZrpfPPu3ExwidI98IVeHshHbkITOTD8SRR4sPKEwzINYx4WkXmgQkT3PQO7MI33FV+UPRdmDjhijEr9Eqmk2C+asNVfHBqqYGfk7VTcihSYhaLtNzZpNOoUG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 5:45=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> When restoring a page (from kho_restore_pages()) or folio (from
> kho_restore_folio()), KHO must initialize the struct page. The
> initialization differs slightly depending on if a folio is requested or
> a set of 0-order pages is requested.
>
> Conceptually, it is quite simple to understand. When restoring 0-order
> pages, each page gets a refcount of 1 and that's it. When restoring a
> folio, head page gets a refcount of 1 and tail pages get 0.
>
> kho_restore_page() tries to combine the two separate initialization flow
> into one piece of code. While it works fine, it is more complicated to
> read than it needs to be. Make the code simpler by splitting the two
> initalization paths into two separate functions. This improves
> readability by clearly showing how each type must be initialized.
>
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
> ---
>
> Notes:
>     This patch is a follow up from
>     https://lore.kernel.org/linux-mm/86ms42mj44.fsf@kernel.org/
>
>  kernel/liveupdate/kexec_handover.c | 41 ++++++++++++++++++++----------
>  1 file changed, 27 insertions(+), 14 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 2d9ce33c63dc..304c26fd5ee6 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -219,11 +219,33 @@ static int __kho_preserve_order(struct kho_mem_trac=
k *track, unsigned long pfn,
>         return 0;
>  }
>
> +/* For physically contiguous 0-order pages. */
> +static void kho_init_pages(struct page *page, unsigned int nr_pages)

Here and in other places below, it is better for nr_pages to be
unsigned long. This is consistent with other places in mm, where we
have gradually moved on from int/unsigned int to unsigned long for
npages (see gup.c for example). Otherwise, LGTM.

> +{
> +       for (unsigned int i =3D 0; i < nr_pages; i++)
> +               set_page_count(page + i, 1);
> +}
> +
> +static void kho_init_folio(struct page *page, unsigned int order)
> +{
> +       unsigned int nr_pages =3D (1 << order);
> +
> +       /* Head page gets refcount of 1. */
> +       set_page_count(page, 1);
> +
> +       /* For higher order folios, tail pages get a page count of zero. =
*/
> +       for (unsigned int i =3D 1; i < nr_pages; i++)
> +               set_page_count(page + i, 0);
> +
> +       if (order > 0)
> +               prep_compound_page(page, order);
> +}
> +
>  static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>  {
>         struct page *page =3D pfn_to_online_page(PHYS_PFN(phys));
> -       unsigned int nr_pages, ref_cnt;
>         union kho_page_info info;
> +       unsigned int nr_pages;
>
>         if (!page)
>                 return NULL;
> @@ -240,20 +262,11 @@ static struct page *kho_restore_page(phys_addr_t ph=
ys, bool is_folio)
>
>         /* Clear private to make sure later restores on this page error o=
ut. */
>         page->private =3D 0;
> -       /* Head page gets refcount of 1. */
> -       set_page_count(page, 1);
>
> -       /*
> -        * For higher order folios, tail pages get a page count of zero.
> -        * For physically contiguous order-0 pages every pages gets a pag=
e
> -        * count of 1
> -        */
> -       ref_cnt =3D is_folio ? 0 : 1;
> -       for (unsigned int i =3D 1; i < nr_pages; i++)
> -               set_page_count(page + i, ref_cnt);
> -
> -       if (is_folio && info.order)
> -               prep_compound_page(page, info.order);
> +       if (is_folio)
> +               kho_init_folio(page, info.order);
> +       else
> +               kho_init_pages(page, nr_pages);

Thanks,
Pasha

