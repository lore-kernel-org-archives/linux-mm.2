Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C697EE01F6
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 21:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59AA6B0089; Tue, 30 Dec 2025 16:35:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02EF6B008A; Tue, 30 Dec 2025 16:35:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D093E6B008C; Tue, 30 Dec 2025 16:35:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C1AD16B0089
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:35:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 542731A0152
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:35:56 +0000 (UTC)
X-FDA: 84277445112.06.D7C85CB
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5767A180004
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:35:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=S1rWznZb;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767130554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cW+RlpTB3ja6MKCYnsBb535GvdYKPwlw2atYYExVSK4=;
	b=d6Au9TYIzZaEh//+N5lLg4aanou5xeyl4+hC7rW99tAYLkJ+pCwujpw+6wYMMqsFG68NBL
	2AxLPYAxz3d8pSz3R2/xKCbwenXiMr3fEwH7fyBUv9qXNpmBIx/NKwN10U1wCD8qMkBI6D
	cO/UGZldc8Oqp3c1a5iEAVmKuS9sBM0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=S1rWznZb;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767130554; a=rsa-sha256;
	cv=pass;
	b=XrzzA94gsQ6AvTEqDomJllMgLELhPEBMJnahRNuboWq8cPvsMyG7kx/sCpMu1SfSJRtp3I
	47AjxSTseGSq+cbh3IStGMTT8vgd/3UH5L/xGhy2L6P+t6Cj/8VI0uXIONwoNHKUsAgnL7
	moALUbassXGn0hxLeHxTI/+4rLDM/lk=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ee147baf7bso17801cf.1
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:35:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767130553; cv=none;
        d=google.com; s=arc-20240605;
        b=jsVRzKVcsJzdi0k8RslYTSJ7fw/XFxx1sKYt2NfQu57LKmltQd8l0zOyO1LU7Qk7fc
         Lr4MZ9ZqoqbIvru40Z4KHT+YGOcE0xsL1pUelY9N2s3CXC0gPPfFURdXJkSbFpXQcYdg
         s0WcbmVVc1gBXZWurzucIq3JuqaGv13TELt3qNsZ4k+inbk2EFFe1wXc9RqnCv9YfK2N
         +S3vIQAhC8izrTRSzanPLlYDi0PoZP/wX4zF7MN/284XAzgzdgc0EAnuvL/NZyu0xWZY
         JEWk9yAz+lH3vjzcvWeumnIkv9mOaUG0EejtoHwg7M5q4FUYJIICrcU7KPacQ6F5beuW
         +N+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cW+RlpTB3ja6MKCYnsBb535GvdYKPwlw2atYYExVSK4=;
        fh=5XxmXkf9GojrTMM/mpCum/wMMZOf4MDrw+5+O7aNN4c=;
        b=gEV2CVoNJCMqlOBm4GWtN/kQobXXB9b7LphChGnmJoQdUSHW3ryOwTvgcTkcEenipm
         x4NnWF4RCdOoRnpMmW/ifP/Ukqacvbz665/bvxRnDRTwsIXN3zWnbDgBMOF32IVyLl0X
         bhrVmSu/KGOA8BFZ4N7xo+Js98Uj7q/Jmsa9roeJtg2rTm3qR7+yk4kSYmWP3l0HGdCP
         2awnmdGuSHPBUcXsfnY2jJBCzBOECnV7qRVYC3VfAKWc4tP41lhIPi4lSb8bULDL1aRr
         +sO4QnAh0F7DwTzMSY2GzN6cxp9JIPvKfpju9f55TsBU1d9zN2hYXIK+2o+62fS58/Tk
         2eig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767130553; x=1767735353; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cW+RlpTB3ja6MKCYnsBb535GvdYKPwlw2atYYExVSK4=;
        b=S1rWznZbXsgBAefdclA9rY6kp/4IU27ZTrCPflIA+8q7e+bz9QF+R026+OrCIpL3mT
         jjUFyaIPoYtWwAICYiqdm4v7OBS6kII4SbU4AcavOXIxahlti2CeNcK5sNFAi0A17Ofa
         D1lRB2rPQh0ZfzZul505zQCsyocY5o0pruT6G/KcRAueS04VDTn9YsjgUV5QbN/JlB5Y
         +CMscFK6XBJat+Lnn96aBumaMSaVGMMfpXm9+pjVvom8EQ1SI6ubeNok6YwPkMCoEZa8
         UkYzuelBcFDIiKUME5B00SrTYdfq3BY0k2Dx4YCTLrVM6etQBeuMqq6wIBtq9x3bXAJ2
         ty8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767130553; x=1767735353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cW+RlpTB3ja6MKCYnsBb535GvdYKPwlw2atYYExVSK4=;
        b=MGO7/e0cXbsa9xkXpaTiYgdsbj9yGWF0p8H3IJjnBzwAKxDYdGf+nppBvKtAYN0xec
         RsZquA0vPn06DyNU8E38687tOn+/so0/VCg9i6XuUeInCyXsfzyZpzuTTLZNA58Jo2XS
         Qyx1WMUuvax5HgZMFwE5w9BwQHxd0Qq8NLbgS1KQHiO7tvikK52M4CGw99Gc/nIzxzf+
         VBAgMGFqm+VG4PjLUfmpnlH5lF1gjNztC9CIpQCFK4FIg23XVU3IruMCxfz/KlFYTQ+q
         9Z5wCrVv60YZZfeeSRSsbPUMWKrgKWJ7hc+6pXg30+P0ZxvdvpbcE5ZiPJACwe+wfvbM
         dDaA==
X-Forwarded-Encrypted: i=1; AJvYcCXw+AZwhMS0hnP20K0Ba6MgUcbdUEZfHqot3ldN+duqi0GlQrNLDC35HGz7WZdsmgsArnsS2YObHw==@kvack.org
X-Gm-Message-State: AOJu0YzHonCqgubhcHcHWoLJVKpKHRu4OZUnfE10HZdBB2nkSnJ0o07N
	u59UuDPd0Il0OjLLil3yFrPNzA4WhwFwfHtmNtbl+54RU5X4X1Gi4vO2Bfklsxy/huXWDEyzSwe
	lP2Ufa3D59ImR438y+54YHEqnDXuXynVDdaM4OM/q
X-Gm-Gg: AY/fxX7Akk4OEFjuNVK6s+C5z1U/AShfa+SNIjvX7RgTNmyQ+SUhkDHyOD/3X4oosDA
	lixP8Z+WMDURJEqzPICywgnPsa9wHDfykiylDhRZVQJuvasRceqQmrwbKYr/S4GQluGFQNwkEvA
	FZtupPLK2CYWeoiKplQiH9mgVKsBVf7eWfZiXAMbRaB4h+fPxw7Q6z0yMxAl/hYW8vQOZKAAki3
	NawAeiUrhv11LSPErBHSvbmf3Ow0Un0aU2FzvPmucukH2oKf71pvsBxmfMfat6Sg4arvb2z1QL0
	hCi9B68qFXE8Es89oO6K2ePrcA==
X-Google-Smtp-Source: AGHT+IFjaOOQiCorXa9LSEwTuCfY/aC54d6aLYQKXweEMegLJ0eUC+RqWxIy0S3r0RzIVY854IpWTCWnPHEZyPEYsfY=
X-Received: by 2002:a05:622a:514:b0:4fa:ddcd:672d with SMTP id
 d75a77b69052e-4fbb091df28mr2513521cf.2.1767130553100; Tue, 30 Dec 2025
 13:35:53 -0800 (PST)
MIME-Version: 1.0
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com> <4ce4ec09b92664091e8935982d83dde3a4c7f898.1765970117.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <4ce4ec09b92664091e8935982d83dde3a4c7f898.1765970117.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 30 Dec 2025 13:35:41 -0800
X-Gm-Features: AQt7F2oH4VGAPwNOgKhUrkj2wX6lims5tTRMEpq94K8Ln09bvojp4JyNXUx5dT0
Message-ID: <CAJuCfpHWUj6npkpMsgHmLHMk4NHRzaDyDG2oQk1SuQ53swcMSA@mail.gmail.com>
Subject: Re: [PATCH 7/8] mm/rmap: allocate anon_vma_chain objects unlocked
 when possible
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: axkeydfirjfcinookw6joeb7sgeykfgd
X-Rspam-User: 
X-Rspamd-Queue-Id: 5767A180004
X-HE-Tag: 1767130554-457592
X-HE-Meta: U2FsdGVkX1/uQ51Mbx2Yn8qjQR4euM452NyA/FtGTPgRokJaPZTU3Bpp4TIqj9u8MyHM6tIFNE2bZhUgpfFC5f2Urs1mjVp2R34i7d0Fljl/7pM3JjQ8QhUkMuYjj7qAfRzcckQU8ZRzXMRdqqdZ1EhtGa2bSf+sM50Pb/zICoKIr3FZuHzS1VIj8zkd28YZSO8sczuodiRcWNW+2m5g4rd6FEai0x6GQ+IEmhQeuYxn8/VJUuReOd262nRxxOvzyXb2KyK1XgaCA2XbdtBlFt7ZdRL7sXnwojgGH5e84ZaMDS28ULI2MeV95+MN6Nmn/q24CrgtNKqKZnniKDgQtQ8LJ1zEcd/vKFt5DGarASml909WQAnm63c1RU2kBii22/ybm2/cT3gu6wR+yBw75AS/eixxsWEkno9rNElH3ZHHTNzwdb2HkruTp7753EbafnX/WVjl6iGPUfMZ37eqnA8Tg0rVH8RHtMBwgyrqBNqvOC2fudt5ymwKq50pdZCCSMcPG3W9lODCTqDpqkspN1aNCNLmuQT3tIg+t66bi/TOfXwl24XTxPlAZ9gVNHwKqrNPiwLsBelbmD742S+wwDULxnvS/kAiE1HSVKkMF+ATiGWXRo+JZ7A1A2Ff8+PXPSAVab/a7oR4pAW/gTCLfM+81DUW9whEBDQe9kBK1sUOk6EpH8bMl2/NDF5KPonGdlHL/WW+M0FMPtJE4WLqmGBjOLED5gA9jKFH4iHPXYEUf1vCXuFdBv8PqOrfA58qZ455SF/QcEo3l0QxxJCwguabdlN//siJQnygiLIw1jd0y9FiJHM0kz7r/t2J+PRAVMKuKuskW2Q1gNTA1I1Jen6aW3kzx0MEsRRDOGQ4hCRgz1kkY9HgF47bYbCcFpLAxeGMUoBYsMZUTwKtwGHieGpekg6dZ3G1IW9o/y4z2j0YJNvdWMmIzeb65Bziw2gM4OeBnicadoFlKe0ERyi
 /0un4uhr
 5v3IQTHJYiBIz+vpqwQw0p7ecPC5GBlVAqkM1kmANvcroOCIyhUqDQval65GwJULKN7Ukge5G7qB/kpVPuTfkfD9qcz2t6dZuew7zL11ZzxTOskTthmetBs0zybKhaPY/x9hDui3TcHoGu93UtSriY0Cb4QFG4S1zqKybMkEkr5ssE7FL8ZWkLUL2vo3if1Rrw3TceETGadUc6CZqOUB++2ZyBBzCDnKWzIwp9gs4hAVPk7o5Z7AraaQQQmFqD4oR17Hxi8A4T7wcryYzWUnYiWclRRmYsYlrbo/UKSmDZnUUbIDNMTSkdcB5SHNRhMDaCorMLhnlZYLFbp8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 4:27=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> There is no reason to allocate the anon_vma_chain under the anon_vma writ=
e
> lock when cloning - we can in fact assign these to the destination VMA
> safely as we hold the exclusive mmap lock and therefore preclude anybody
> else accessing these fields.
>
> We only need take the anon_vma write lock when we link rbtree edges from
> the anon_vma to the newly established AVCs.
>
> This also allows us to eliminate the weird GFP_NOWAIT, GFP_KERNEL dance
> introduced in commit dd34739c03f2 ("mm: avoid anon_vma_chain allocation
> under anon_vma lock"), further simplifying this logic.
>
> This should reduce lock anon_vma contention, and clarifies exactly where
> the anon_vma lock is required.
>
> We cannot adjust __anon_vma_prepare() in the same way as this is only
> protected by VMA read lock, so we have to perform the allocation here und=
er
> the anon_vma write lock and page_table_lock (to protect against racing
> threads), and we wish to retain the lock ordering.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

One nit but otherwise nice cleanup.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/rmap.c | 49 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 29 insertions(+), 20 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 60134a566073..de9de6d71c23 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -146,14 +146,13 @@ static void anon_vma_chain_free(struct anon_vma_cha=
in *anon_vma_chain)
>         kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
>  }
>
> -static void anon_vma_chain_link(struct vm_area_struct *vma,
> -                               struct anon_vma_chain *avc,
> -                               struct anon_vma *anon_vma)
> +static void anon_vma_chain_assign(struct vm_area_struct *vma,
> +                                 struct anon_vma_chain *avc,
> +                                 struct anon_vma *anon_vma)
>  {
>         avc->vma =3D vma;
>         avc->anon_vma =3D anon_vma;
>         list_add(&avc->same_vma, &vma->anon_vma_chain);
> -       anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>  }
>
>  /**
> @@ -210,7 +209,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>         spin_lock(&mm->page_table_lock);
>         if (likely(!vma->anon_vma)) {
>                 vma->anon_vma =3D anon_vma;
> -               anon_vma_chain_link(vma, avc, anon_vma);
> +               anon_vma_chain_assign(vma, avc, anon_vma);
> +               anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>                 anon_vma->num_active_vmas++;
>                 allocated =3D NULL;
>                 avc =3D NULL;
> @@ -287,20 +287,28 @@ int anon_vma_clone(struct vm_area_struct *dst, stru=
ct vm_area_struct *src)
>
>         check_anon_vma_clone(dst, src);
>
> +       /*
> +        * Allocate AVCs. We don't need an anon_vma lock for this as we
> +        * are not updating the anon_vma rbtree nor are we changing
> +        * anon_vma statistics.
> +        *
> +        * We hold the mmap write lock so there's no possibliity of

To be more specific, we are holding src's mmap write lock. I think
clarifying that will avoid any confusion.

> +        * the unlinked AVC's being observed yet.
> +        */
> +       list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
> +               avc =3D anon_vma_chain_alloc(GFP_KERNEL);
> +               if (!avc)
> +                       goto enomem_failure;
> +
> +               anon_vma_chain_assign(dst, avc, pavc->anon_vma);
> +       }
> +
> +       /* Now link the anon_vma's back to the newly inserted AVCs. */
>         anon_vma_lock_write(src->anon_vma);
> -       list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma)=
 {
> -               struct anon_vma *anon_vma;
> -
> -               avc =3D anon_vma_chain_alloc(GFP_NOWAIT);
> -               if (unlikely(!avc)) {
> -                       anon_vma_unlock_write(src->anon_vma);
> -                       avc =3D anon_vma_chain_alloc(GFP_KERNEL);
> -                       if (!avc)
> -                               goto enomem_failure;
> -                       anon_vma_lock_write(src->anon_vma);
> -               }
> -               anon_vma =3D pavc->anon_vma;
> -               anon_vma_chain_link(dst, avc, anon_vma);
> +       list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) =
{
> +               struct anon_vma *anon_vma =3D avc->anon_vma;
> +
> +               anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>
>                 /*
>                  * Reuse existing anon_vma if it has no vma and only one
> @@ -316,7 +324,6 @@ int anon_vma_clone(struct vm_area_struct *dst, struct=
 vm_area_struct *src)
>         }
>         if (dst->anon_vma)
>                 dst->anon_vma->num_active_vmas++;
> -
>         anon_vma_unlock_write(src->anon_vma);
>         return 0;
>
> @@ -385,8 +392,10 @@ int anon_vma_fork(struct vm_area_struct *vma, struct=
 vm_area_struct *pvma)
>         get_anon_vma(anon_vma->root);
>         /* Mark this anon_vma as the one where our new (COWed) pages go. =
*/
>         vma->anon_vma =3D anon_vma;
> +       anon_vma_chain_assign(vma, avc, anon_vma);
> +       /* Now let rmap see it. */
>         anon_vma_lock_write(anon_vma);
> -       anon_vma_chain_link(vma, avc, anon_vma);
> +       anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>         anon_vma->parent->num_children++;
>         anon_vma_unlock_write(anon_vma);
>
> --
> 2.52.0
>

