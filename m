Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C4BBEB2700
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 21:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41D346B0005; Tue, 10 Feb 2026 16:19:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB086B0089; Tue, 10 Feb 2026 16:19:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ACAA6B008A; Tue, 10 Feb 2026 16:19:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1721F6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:19:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A467E59FFB
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:19:27 +0000 (UTC)
X-FDA: 84429813174.20.73164D8
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id 98E26A0014
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:19:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AqOBENUK;
	spf=pass (imf25.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770758365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ueb2XLAZgSMqdZ7FzkgHkbOJxEx/nDgdsJxz5kcjsQ=;
	b=jIfpuzF+QzA31cxgSAJJVw5c0l0rOEmv4HBzFZrbvBRHTwjZ1wos3x+sCBUbaLWD4sW0vM
	vEN3Yvcino7EO6h53Zbzstshp8jcaMC7dgKKAkY9FMiBKd56GzQk275S91GT06JyP5+w5H
	OQVi9FCvdcO5z2eGmrz2r0LtbUtfK78=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AqOBENUK;
	spf=pass (imf25.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770758365; a=rsa-sha256;
	cv=pass;
	b=6VyihjPap9IZouGMyTs62fM1hzyj82H25EiBWwDS6hMTCovb+PextxVMhhKx3VPdJnRK7F
	ZNJUIrelyCPF2vGySOA/uvxMTinv0Rgx3iRpEr4mYoxS/8YLCxfvXHYKCPO5JRKq/S9LS5
	u8UZLmX9/6fLjs9M+tOmaBx6IAWhHEI=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65a38c42037so940a12.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:19:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770758364; cv=none;
        d=google.com; s=arc-20240605;
        b=LAxYMwClLkgVQXeIvlpizhVTh+yp0Z0b2ESVfHc65ePzX7GXGxMidJ+5CQOAsEZEZ+
         tKqFgl9BuE9ROO/7LE0/CvgiQ1uF5UnLwJ13o0b2OwyDUbLgu2W+kMDy7zwwOgCooJFI
         wH3OFb82waUDSbxNVBol97wl+t8c4r0mI+bVBUgBIvcFIo0Vx4uHOOeu/fn7OeVYGsyz
         BtuQGI12iqZ0R6c30Jam3EnCPOrp+ZiDez2SrCuEcCv62Az82YuHR7KCWcPcML3AWaxx
         7YD1ilMUSUpJhTeg0iiP9GivnfWDf9hOTLdMjs82v3pnR6vxzprMcJWNfh4oOg/tIezf
         AjXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7ueb2XLAZgSMqdZ7FzkgHkbOJxEx/nDgdsJxz5kcjsQ=;
        fh=xbzmviQE+WWjKiSP0DfQZSUOUw4QICV/hEV3pqH/0ak=;
        b=NRllaMOlv3jJMSd8Mi1eljgi9p+Sk536nf9qIVlwelzA71jkRKQ2GMO7pXiBe+baJT
         Vri3xsvpVmV6iKkUqkT1g6jexUWMToC+DLP9TOW1tfwJXuF/z+7Ipkgrex48PasRlLi5
         zrZ1PzeTuzjD+YDxAwl1wJdtxCgd/ayCWPg9E7Z1cVba1ideJ5LYK8sAHBgyTTUpl9V7
         57FlJ3hZ1hEEn9tawj7etugHW83xPKYUh59DQXk7n4wVACn4r2NR7q8TVy0hcOeF+sxx
         qnlee7rZbsQkCP3pQaz+/w1Mh8bp9M6DDTOtIVf4n6S/POAkTWk1vVajO1eLuXdoU4LP
         szwQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770758364; x=1771363164; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ueb2XLAZgSMqdZ7FzkgHkbOJxEx/nDgdsJxz5kcjsQ=;
        b=AqOBENUK1Xi7FS8gaqsvqh09LXwKDCxSLoGOYbcnNANNoVqtWGLeWFnit8Ueb9MYhT
         FKKmSIgVMvZkjhbg1ZDTEcxlbWYa77jLynHXgxVv0nH828q8/TOHgByEeTGUARK3W6YO
         Mxwy14inmuQ9SU3qUWqTp0G71ZgDCK/rbJXnd7Y0xyOyxwIOfqJI2bx6xY4i89dgo+Yr
         0kWN/ZgHMa11RyhaXDCydYhtxp37OXe0UvlW1BAEYquAFL+J75d4yeK5aU4YEO4PQBM4
         O/JlEoGYqq8C5pgooNRgQEnriXKQzytISRSfetft496tDbnCpgnZWZFrN9dzkWbw73S+
         h5PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770758364; x=1771363164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7ueb2XLAZgSMqdZ7FzkgHkbOJxEx/nDgdsJxz5kcjsQ=;
        b=OhHjmglMj44walNQv6/qmzEYPYCAybuEakNdaibV7hmtbfeHpWV3UU5GfFr8s/3hIs
         7wsrelk9mJQZba+1e6wmWfawLrFuPGh/c48KE5yNdv3WU1LFqc4L2qjV+VwOsT+NsleW
         lzO6hXkhHsjkeFsoDSNOvl+vuFiGivRT6jF6F4qoDqn2VJZwfVSISY4v55kQGr+in3qH
         pWFc+V8lHTw1n+KwDgP/g9J28BgVYpKQx+l1zUAH2M9U3IBma47LTwqyJOwMQldkVt8N
         MGZgYmFPIee4ZCAHynEuI8RWiN0dp6QzNXVD59SZFQ+5QTVyaWEGzKddl7f7/OJXz9pj
         iLPw==
X-Forwarded-Encrypted: i=1; AJvYcCUmf0Ok+BBt9/sS2nw/b9lwdI+540Ver3ZoOouTp4ec8fdwPVFB6QQvCvjFTPOAaHifRg1jBTYmPw==@kvack.org
X-Gm-Message-State: AOJu0Yx8yl8mzR30MIlT03a7TElf6bpcq0qHfvDDXpjCVIwcUCl/Q5qs
	jVRegNSLDuebj2KMre/KqHAYOUBqYJUGHYzlquZwPlu2mNbe8OXCUCsGLU1ovCkKvfd50InSAdN
	hZECBIHm0/CdMtA+ac2afqMdK6ouE+m5WULG5rYsl
X-Gm-Gg: AZuq6aJjFyJt9Y+7m/e8GHLuh0Q+pqzIYEZiI6f8ykXUm+88w+LgJkGO7kHhedqUjhb
	IVbQ1X7axjIc6udNPKdnCKqHi5DyuaeW9gGI8XoxJAnInUPyhvBZIPy4cytP56MI8PFvs0+wbkI
	O/kT9cIJV3vzdHUXudLuoYcbwyA0omyVHnhSGNOx6kSBYek5/Kfn08fpGpyOxYCO141WInyLeFO
	IBBWVpzbJlJu5l6WKfMVj7wWKMtpyYJ+lljUTdCe4Mj7z3aTPLRkmKiymKT1ijUoEeu5PDwrSK6
	hjFLmm6UJ5T0o4g8asfIbEOf1rqLqHaGoAgH
X-Received: by 2002:a05:6402:8cf:b0:659:7696:432c with SMTP id
 4fb4d7f45d1cf-65a390b5a13mr6380a12.16.1770758363456; Tue, 10 Feb 2026
 13:19:23 -0800 (PST)
MIME-Version: 1.0
References: <20260209220849.2126486-1-surenb@google.com>
In-Reply-To: <20260209220849.2126486-1-surenb@google.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 10 Feb 2026 22:18:47 +0100
X-Gm-Features: AZwV_Qj1nCcIQNkC6tpOVx93iwKZtT2dbqwR4XsX_m7M7cfMNKnVzbH_C365zC4
Message-ID: <CAG48ez2zFfCO7RKhHKaATFge7DWzaTfO+Yta0y4_HXGHZAtkqw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: replace vma_start_write() with vma_start_write_killable()
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, mhocko@suse.com, 
	pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, 
	mpe@ellerman.id.au, chleroy@kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98E26A0014
X-Stat-Signature: sjpnai65h7yxt15zopofcetcfpm5dgez
X-Rspam-User: 
X-HE-Tag: 1770758365-575409
X-HE-Meta: U2FsdGVkX192rX0ikVG5V1cH6Hc6Inxune5Wu8zAdjKGWQuGSP/0+Po95Fg6pyJY7LTr0o7gmwMlYrkuXdVMocquu0EmhwmngCTgM0EcummIpkSLKEF81ZdXVNpQ3mQ9AE9G+uw7Nchg6f66k9DFqOxKYxTwAlHUPqJ63ZKIzPgFbstJefXIy7o6Jz817vsD7dq4pY9OB+Dv/Mp7N87MwAf7tfCaSz//Gft9nJG7/GCkIlr7kRGh64wTZKu5zedsiQpe4lxFR1ojMK+JJoaga1sN5YUeSM0f7RwXLEZdVRDLTjmixgvXoVPoXqI+AommV2ow3LaL4eh5bVyREWNuHXTcstvaUCkxpu5YsbNM9DlpnpD8A3h6MAoMUD3W1w8PO9LRuFCPbEYnhNukMVTjZSul/s/SeW5dEClghMHtXyIscOwPNWl2UgaXEh30pLJQoadhMuDpUD92oWvsM8u6BHFOliF3+OYc9rdnYpWG8AcggdphnRGenSuUjt7anhBx8y/85c986kqFb3WatbXHTHM2xJ7UbDI1kUR6bD2G7RFhMpA1JI87VZl/RX7kEP6xrPFV6janxWB2x53l34Ns4pEqjZawvny1XHocm8aVeUbkS4sdJ7PFMBJKOWlp9VCSuRfvmOgGi476A0tZOHCTZmI3qljt8LFUJ7XAWVEzQjKqy/v+HYXjsKrb2s2OHpCTw8qn5FoVZwu3peM9NuVHmK9rAExJkjKn6E6+D2qgOemuxcfxosOjJybobRZNdMHrlCWSXB2sac3jyJ0GvFlSOhxpq2OltfaOuAmepDb67yl9mvUzDouJw6HQOWcyxbTUsmsZ2TNz3OPDrM9wpvY/9TbOufuNYCPWUvhb9xpDdwKzGGLEkNxnO4DpazW/tXbDfqaUjqcDHGZPErWlCoUOnIiKVkrqnVYvC/c/9cYIwogAIlFB5xyL7y1jtzImGgN+lxzP1aUx2v0/2/4WXgf
 J9dzoz6l
 NwozCtFk3i9WCRakQrM9KAW72PS9GY8ZjWNqepZi8zohR1AtEgFRCpGC4IzCHUe1XIlS2bh5qen0g5rqFRav8lMWuB0l0QU2nj2gxAJq/Al11tTOGV7HyjhQbtMFE6f5NlgNl0cKPd6LLb1AogRJ5xMbJsmWKeCsJZpJMb71HE776XdEf5jYK6VS06hMhY8ztbQLpq739qEkiD4+lNrsU4KmEcGnRNarHDhkyuGNPfOBgc9CoDxOnHUngWoragSxDBTbszEidUP34o134HjWqFH9b3ltHBp7IqzefDyQJcOyCMfJiYIkcmTSX2xZtmh3U1F6umfHyx9n3ckPonkS2U80/mVb3rlvkBdBKJ5swCb09FhCGRQ2YeyqSTlRx+zyQxzNx/QF6lQ0JD77k7cxqssKfAl3dElEU/dX9kZWx3a2auBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 11:08=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
> Now that we have vma_start_write_killable() we can replace most of the
> vma_start_write() calls with it, improving reaction time to the kill
> signal.
[...]
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index dbd48502ac24..3de7ab4f4cee 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
[...]
> @@ -1808,7 +1817,11 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned =
long, start, unsigned long, le
>                         break;
>                 }
>
> -               vma_start_write(vma);
> +               if (vma_start_write_killable(vma)) {
> +                       err =3D -EINTR;

Doesn't this need mpol_put(new)? Or less complicated, move the
vma_start_write_killable() up to somewhere above the mpol_dup() call.

> +                       break;
> +               }
> +
>                 new->home_node =3D home_node;
>                 err =3D mbind_range(&vmi, vma, &prev, start, end, new);
>                 mpol_put(new);
[...]
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index a94c401ab2cf..dc9f7a7709c6 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -425,14 +425,13 @@ static inline void process_mm_walk_lock(struct mm_s=
truct *mm,
>                 mmap_assert_write_locked(mm);
>  }
>
> -static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> +static inline int process_vma_walk_lock(struct vm_area_struct *vma,
>                                          enum page_walk_lock walk_lock)
>  {
>  #ifdef CONFIG_PER_VMA_LOCK
>         switch (walk_lock) {
>         case PGWALK_WRLOCK:
> -               vma_start_write(vma);
> -               break;
> +               return vma_start_write_killable(vma);

There are two users of PGWALK_WRLOCK in arch/s390/mm/gmap.c code that
don't check pagewalk return values, have you checked that they are not
negatively affected by this new possible error return?

>         case PGWALK_WRLOCK_VERIFY:
>                 vma_assert_write_locked(vma);
>                 break;
[...]
> diff --git a/mm/vma.c b/mm/vma.c
> index be64f781a3aa..3cfb81b3b7cf 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -540,8 +540,12 @@ __split_vma(struct vma_iterator *vmi, struct vm_area=
_struct *vma,
>         if (new->vm_ops && new->vm_ops->open)
>                 new->vm_ops->open(new);
>
> -       vma_start_write(vma);
> -       vma_start_write(new);
> +       err =3D vma_start_write_killable(vma);
> +       if (err)
> +               goto out_fput;
> +       err =3D vma_start_write_killable(new);
> +       if (err)
> +               goto out_fput;

What about the new->vm_ops->open() call and the anon_vma_clone()
above? I don't think the error path properly undoes either. These
calls should probably be moved further up, so that the point of no
return in this function stays where it was.

>         init_vma_prep(&vp, vma);
>         vp.insert =3D new;
[...]
> @@ -1155,10 +1168,12 @@ int vma_expand(struct vma_merge_struct *vmg)
>         struct vm_area_struct *next =3D vmg->next;
>         bool remove_next =3D false;
>         vm_flags_t sticky_flags;
> -       int ret =3D 0;
> +       int ret;
>
>         mmap_assert_write_locked(vmg->mm);
> -       vma_start_write(target);
> +       ret =3D vma_start_write_killable(target);
> +       if (ret)
> +               return ret;
>
>         if (next && target !=3D next && vmg->end =3D=3D next->vm_end)
>                 remove_next =3D true;
> @@ -1186,17 +1201,19 @@ int vma_expand(struct vma_merge_struct *vmg)
>          * Note that, by convention, callers ignore OOM for this case, so
>          * we don't need to account for vmg->give_up_on_mm here.
>          */
> -       if (remove_next)
> +       if (remove_next) {
> +               ret =3D vma_start_write_killable(next);
> +               if (ret)
> +                       return ret;
>                 ret =3D dup_anon_vma(target, next, &anon_dup);
> +       }
>         if (!ret && vmg->copied_from)
>                 ret =3D dup_anon_vma(target, vmg->copied_from, &anon_dup)=
;
>         if (ret)
>                 return ret;

nit: the control flow here is kinda chaotic, with some "if (ret)
return ret;" mixed with "if (!ret && ...) ret =3D ...;".

>
> -       if (remove_next) {
> -               vma_start_write(next);
> +       if (remove_next)
>                 vmg->__remove_next =3D true;
> -       }
>         if (commit_merge(vmg))
>                 goto nomem;
>
[...]
> @@ -2211,9 +2240,8 @@ int mm_take_all_locks(struct mm_struct *mm)
>          * is reached.
>          */
>         for_each_vma(vmi, vma) {
> -               if (signal_pending(current))
> +               if (vma_start_write_killable(vma))
>                         goto out_unlock;
> -               vma_start_write(vma);

nit: might want to keep the signal_pending() so that this can sort of
be interrupted by non-fatal signals, which seems to be the intention

>         }
>
>         vma_iter_init(&vmi, mm, 0);
> @@ -2549,7 +2577,9 @@ static int __mmap_new_vma(struct mmap_state *map, s=
truct vm_area_struct **vmap)
>  #endif
>
>         /* Lock the VMA since it is modified after insertion into VMA tre=
e */
> -       vma_start_write(vma);
> +       error =3D vma_start_write_killable(vma);
> +       if (error)
> +               goto free_iter_vma;

This seems way past the point of no return, we've already called the
->mmap() handler which I think means removing the VMA again would
require a ->close() call. The VMA should be locked further up if we
want to do it killably.

>         vma_iter_store_new(vmi, vma);
>         map->mm->map_count++;
>         vma_link_file(vma, map->hold_file_rmap_lock);
>

