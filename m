Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB3FBC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E13706B00D5; Mon, 27 Jul 2026 11:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC0F6B00D7; Mon, 27 Jul 2026 11:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04476B00D8; Mon, 27 Jul 2026 11:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94AF86B00D5
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:04:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 058BF120753
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:04:14 +0000 (UTC)
X-FDA: 85034877228.15.DB333D0
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id 00237100006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:04:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LHdhK5Jn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785164652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uM7/8WMpp3vq9aE7mMTtCscL3IeVnHAyJXAFgBOfoFY=;
	b=fwIqRQo50pHf6nBe6LO5VS+yQ0/jn01MTgckJh86EsNbARaNgkTFZRJ8Voe1e4xa1uwV5G
	o0oVYfcYIU/tz8liygV0c+R9jaDG+xNIcCkuaBI/FuGF6lZu+LHJfJ2Y/Ce7olbZuvO9nu
	5yrsTrsSvh26xGvodkhhJkDmGXokCBA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LHdhK5Jn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785164652;
	b=ba7MuG531cPwGownmAReQl4G6ymzzVeMLluHr9h40wtg/v6scGyQjgOIpuWWZIOvzqh3HB
	QwgObwWNJ2+QejIoIWqRnSuKuMwYUoS+vkwuuweyeTAU+uvAjS9hh9EG3g5XwOY3D5hrWz
	gXwhxAEnb0j0yS05Gmx5JIcN5Fjbyl0=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c10ed63c0so430681cf.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:04:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785164651; cv=none;
        d=google.com; s=arc-20260327;
        b=VvmljPboZ0mVLjaxBX2fKbR7teVZ7IQfu8DU3QhTMnHSDWk2ZvYrQSJVZg7PAIUZjS
         y8RZ8YQUZ8mJHwcDI0BdynpPY3yPD5MUUPE++uX4UGpo3jTupvt8sau4eMjfgsMVmMEB
         oZQbpGEJx8wv3Wwm6NWtEa81KsBfItuKVpcYtIjDvpEDFFky+4sa0JwhvsBh4Ha7VPR1
         4wLBzyonbEGS7RZfYE7wr8y9vr73tIe59YwVS+2Bc6N8XycBEEIBs8f3ouTKcacQCgjK
         tECIGmrOAetlzHZWwZGSBry1tGxINoIXMOIVP7KN6ggv63sCOKQT4a8XoLQWLIEpEH36
         IHMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uM7/8WMpp3vq9aE7mMTtCscL3IeVnHAyJXAFgBOfoFY=;
        fh=s6SVUDgnlm1vODAlg1uZZHlO5wi6VweHE6NpJp9YIos=;
        b=MxGcN6QUY0W5j+pQ6ATJWdP3l602Y8QGL5w7o5B7qLzoOgrFwA5gGqLMP/3h7aUbG6
         BA4YMqZ/hAYMug0IOgWl5GM/hKNVmnyoQndzG2ZfInOHQ3p2cBQ6iRulAQ4GUSCL9VJg
         7pKX8QcCB2U7g5/Qh6SqKam3GIubleyGPvFGXMNt28ktugFxD3CA4Vi/fxWs8jwJX6fT
         EN+bJdR3jqAA9p4WzmyU8aUFrzYHRUAlj/8K9mrmNDXfrI523qUsX19WaQHoY/U0JjiP
         13xVCVMbPUFC+ojerZe1ZgCnJdJWafGhdtGc55G5dBAG0g73XiJbqVGAnXNp845O2ekJ
         kjFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785164651; x=1785769451; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uM7/8WMpp3vq9aE7mMTtCscL3IeVnHAyJXAFgBOfoFY=;
        b=LHdhK5JnUXuwGZjdkCRWd5+z/9GjMYVpIrCHYHbeUYoRoUNDHUk/oXaKheiwuTVlul
         nj9QLoKMfBUggku3PVYHCWFjHJsJZWZb2/5sqKs2tyceh4THldnR0u7qMnCWb60Og819
         OCaWYsjF9SX4SVC8JCsIOPqnudqKhWrW1Yl9S7XI8g96Ec/DBhiyo0CDwENKccbBUbhx
         Yc2QYiKTeduZs6qJnClYaRYRi7GF2X0UYBi5+ktwewAxMB8TBONBJ3tRHidl22PhaMDJ
         RH0miMWBbK10cyzEDF3FDiFrTXB3B6poT863YBrBe6j35Lyw+NOX6250LEmCezsgcGxy
         F6Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785164651; x=1785769451;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uM7/8WMpp3vq9aE7mMTtCscL3IeVnHAyJXAFgBOfoFY=;
        b=cLMjYGlHjsUgjX5Zy1fMJkBPaNInLe2gE74uXEeWQgaTBJ28526Zt9uM2GQStZ306I
         qIRaqQ94TvvseQUsKb7Ne4MLPnNSRjJrpsKHb4c4ivbJa8UpzGMCNajz0uzLKSJdjyoC
         Lx4lGTNK8x51o2lKb9xqTDK2OeWV6flbtgKOxMoBc0tTYXfq/Tj/euCad/TdQ+3oyVo1
         RXhPaEkz7BqFQcUs5AmSUrbBLN1Qc9mLxQYBeUfiBGuO6hzUFMjqky5OsMrBzbSBdws4
         m3612DGdsimwWrrzrGH2axaDJVSeOqi+XLCnz2JSAcVUJsnsZHBI1T53ZWdKE04IbPVX
         CqjA==
X-Forwarded-Encrypted: i=1; AHgh+RosfLXU4CnXCqeaqG5ETVtja3jdhdUcG2T+4k5RmgtVMjrAXWMp8cJw1z2c325BHt0a+uzOLiaoOQ==@kvack.org
X-Gm-Message-State: AOJu0YwGqMGXFVD4Tl2qw+Enjj5QFBRcPHrmtP/b28w40bKzqox4ymPZ
	DRC6zoZ6I3+qjCQtiy+9LM3aBHkRk6MobulavDRaZRxR6uvflbbF3XoIt4M3oZLrccQslbINw49
	pwLpnsM/q1OULhcw5a8rcsy+FbB/arscWYWvakDUs
X-Gm-Gg: AR+sD10ZAkKz4WZfz4xOsLmi17jEVr7+aud03l3rDz7Eem8+6cLPcROsdQHDLihQCHE
	8p82gXABoNRumvx7ATr8Lxmz0q8qcd73hlzNuNHUCBwbJeWJ3gatpvadwrWynQbPqlcsKYfrKs+
	Quvey3pSvQMaN1JH8u2f/X2m/DVKM4qN7xAJRrEr7brunAlSNrV9OjTM6xSbc9AvF1j0vVhW5t6
	HIpvr5zVDODAbFqeaVzczRAx2UlfqglLBhvd+SW4edcn4Sh6sh1fnOyxiLU
X-Received: by 2002:a05:622a:9c4:20b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-529a5e726b4mr34452731cf.10.1785164650202; Mon, 27 Jul 2026
 08:04:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260724222934.1463812-1-riel@surriel.com> <20260724222934.1463812-5-riel@surriel.com>
In-Reply-To: <20260724222934.1463812-5-riel@surriel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Jul 2026 08:03:58 -0700
X-Gm-Features: AUfX_mwMF-6uLQOOPUOS7nkt35Pjuz7SLGFr-vV34ZycrmVhn0U8hg7FE2Cc9uw
Message-ID: <CAJuCfpHM0hq4AjKAfAMdbV2CJ1aE_uooqDytMJ0dw03=tV3eYg@mail.gmail.com>
Subject: Re: [PATCH RFC v4 04/12] mm/gup: let check_vma_flags() ignore
 selected VMA flags
To: Rik van Riel <riel@surriel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kernel-team@meta.com, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 00237100006
X-Stat-Signature: qba964jr6xsabg3bcokbfb5g5jr9yd6x
X-HE-Tag: 1785164651-336384
X-HE-Meta: U2FsdGVkX1/AapQqoWWyF04BKemwiMGXdukKJRY5ghswD8jdd08uZ/GwRJ9an56JJx8zyts7OB8mht1xzI8YLPc2+BOJiMHmXHrJcVazTgNaIRKKoYFX+UExVzzjMLF1ZnxfsyhayeqHPo7bEUetwQJxaNkykQxlgO40X1aXn0BYNRFDNuVjbf6wLKPpJBFkb+SUzxsfkZg1AnWzGAsiic4G6PI2sY/dnzhaSoLGpmZUzsOJJp8pj6j151snf5INuxKkpGKUaJxqJBEu1ES3Z2vvLq/Px2cl7jtmvqf5QHkw8nYD+DeM4k5ZyIdqFcORqs1NNeqzuZlI11UbkeMLvtK8rJpAYR35Puz9azJ9kstDVAPzGtajYbFXpod3R0ntkyDkBb1oOfsebgAe8HQPnSTPSphvz96Rp4I9b7OdomGERVlXOPQoUhEy/oAp6fJKWCDRBOLDIo5bHeM96N55KANxQxmbdnI30L1L7BG5tRocy/TTtuIwxsX2C4zMH8++FCxJStScNkxD3ufivG5vxQMelYji1aVY5E/a83ebQWpKqhjXhNiXzwWk9aUiOpPGLX52bNil0rLO1sGKwxQAzCGlJ7rpJmwOxJaRalYiQJFVZteRYd9gwURRF/p09Muc6PVlo7QyXP1mn6+2/dEL+5jJ6w6aEHzvrxJNpddzOgEcBIhRWxkiSxvH5ArpiMPSFMH7xel1DqH6SK23DXNRc3e32lpLoXBS3yZpgNu/y39nnrbXufTZgPVvs5E1eKPtrAFvhSHq4qHi5ffdDrSByeAqha5+lx6QsrzR8DFkNYKtJ9j0cnK22D2hxge7ZGd0ieDFxiw3K1fx5O5gos6x5xjHFI33cXDTEuJQ1LAh7wbVnCmv7AfRrNC8uDiBQ/CCiTLF/D++jnHUS2S0otf/PpxXz/x4B16mgDe7UkR2MqzkICnL+2KxOxInamD4nGqOcd0XKCUS5+jEhCfLiwH
 hK1y2PzK
 NgteFzM1QIOZHm8rIaIIN8yYkmnF3+foqV4cdrzPx+g7I1fJfYhciBT88hbNxNVlpPWyAOJapXHT+XYJAEJmy5/rQ7c/+PD266yIHGJE5tlrZ9RrW2v5ioJTWkPe6e57mcxqOSj/9BPFogJFmq6KjDJB4gQHPCTRrG6I9dQu3ks8+YtmB1CUMdiJWhkbOnqhf9TYycYhLDo8fM2gURzFFVQO3CSxcAnLvfQ+L+CWbKxK88r2S7uD6CttnN6S4FG+kT29MnH2nraB3gigqEJs+Zv4WPrWdVM2YLg8JCrDPlvcmlVUDJ3kIntuf15/cpNhmgBZDYZi4gDINbgaTOtpwOsjunwYc+z1iLV9k7iwpzM193WehJDQesBqEBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 3:30=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> check_vma_flags() rejects a VMA whose flags gup cannot handle. A caller
> that wants to reach a COWed page in a VM_IO or VM_PFNMAP VMA, where that
> page does have a struct page, cannot express the exception and has to
> repeat the flag test itself.
>
> Add an ignore_flags argument that check_vma_flags() clears from its local
> copy of vma->vm_flags before the flag checks. A caller can drop a single
> rejection this way while keeping every other check. All current callers
> pass 0.
>
> This prepares for get_user_page_vma(), which passes VM_IO | VM_PFNMAP to
> reach those COWed pages.
>
> No functional change intended.
>
> Assisted-by: Claude:claude-opus-4.8
> Signed-off-by: Rik van Riel <riel@surriel.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/gup.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 0692119b7904..dcece7b5253c 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1197,13 +1197,21 @@ static bool writable_file_mapping_allowed(struct =
vm_area_struct *vma,
>         return !vma_needs_dirty_tracking(vma);
>  }
>
> -static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup=
_flags)
> +static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup=
_flags,
> +                          vm_flags_t ignore_flags)
>  {
>         vm_flags_t vm_flags =3D vma->vm_flags;
>         int write =3D (gup_flags & FOLL_WRITE);
>         int foreign =3D (gup_flags & FOLL_REMOTE);
>         bool vma_anon =3D vma_is_anonymous(vma);
>
> +       /*
> +        * Opt out of the flag checks that read this local copy (the
> +        * VM_IO/VM_PFNMAP gate and the write/read/cow bits); checks that
> +        * re-read vma->vm_flags through helpers are unaffected.
> +        */
> +       vm_flags &=3D ~ignore_flags;
> +
>         if (vm_flags & (VM_IO | VM_PFNMAP))
>                 return -EFAULT;
>
> @@ -1387,7 +1395,7 @@ static long __get_user_pages(struct mm_struct *mm,
>                                         ret =3D -ENOMEM;
>                                         goto out;
>                                 }
> -                               if (check_vma_flags(vma, gup_flags)) {
> +                               if (check_vma_flags(vma, gup_flags, 0)) {
>                                         ret =3D -EINVAL;
>                                         goto out;
>                                 }
> @@ -1408,7 +1416,7 @@ static long __get_user_pages(struct mm_struct *mm,
>                                 ret =3D -EFAULT;
>                                 goto out;
>                         }
> -                       ret =3D check_vma_flags(vma, gup_flags);
> +                       ret =3D check_vma_flags(vma, gup_flags, 0);
>                         if (ret)
>                                 goto out;
>                 }
> --
> 2.53.0-Meta
>
>

