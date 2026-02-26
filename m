Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39049FD9E14
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F76B6B025F; Thu, 26 Feb 2026 16:45:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC386B0260; Thu, 26 Feb 2026 16:45:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A75D6B0261; Thu, 26 Feb 2026 16:45:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6116B025F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:45:03 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 177B71B704C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:45:03 +0000 (UTC)
X-FDA: 84487938486.13.F320D62
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1D657A000E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:45:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JRiJ9pyM;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772142301; a=rsa-sha256;
	cv=pass;
	b=JZBGntVkufU+x26NKOqBzmKrj01+E8LVAWtzx0TZgHGCJS//qOi10Zxkef2LtDt6rSL72W
	QdgcuX4L82OcSMb5I+NZCPDiU+clKP+1cv8PLrJPWiFbZtFNwNqbpUrNMYeXiJdAHalQKb
	OoQfEWUSxAtWp9gI7gyF/O8YNS7j01Y=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JRiJ9pyM;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772142301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Y9uOSKBgHqz2G18bc8Hl7qpgXohCsZrLcFX0O6OtFs=;
	b=0u/OWe4WiEKyNGGoC6gIpnsqfihnuahvhL/oXox74V5iiU6LYKDlCev7ojSwIYP+1PGCfR
	6/rccxdjn14bcSzl5M0KrDtLZ0UdpneRjp1ppNFMSt5VVhtzfbj5wlCSviKDC50hnoMbgf
	kLltbfA//sUCEYfisj9cZ7LkRsQlYSE=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5069a785ed2so45081cf.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:45:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772142300; cv=none;
        d=google.com; s=arc-20240605;
        b=hIijSkqk+tI4GR8p2+w/93F5aWpMH28h7sK3oYmf7NQJ7jfdf0i/n60BelH55uCags
         8vUEuUan7s5V+xWNrLJOOwBACXKbqnqnE7FQqFZuHfrYDifOK/8feuicL8N9vhM1qW0r
         8GN8tG2qOWrzNa/AXciAy6WQvhsmpNnkZP488yJCKZr9zwER6W3Sf2xExxCVMMLaYpxm
         PSp5fZynefjk2IacCIzV1GUkRZhdzokYmIW1EBOEVxmJfYhYxo0kHKJWmTub5prf8WgM
         mc6P+fkGNn3x/NyQbBCOgKQdQu2e4dQXDI/TKMQVMWFwoT3ShruCLr4GNu6b8LlLDJAq
         M98g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1Y9uOSKBgHqz2G18bc8Hl7qpgXohCsZrLcFX0O6OtFs=;
        fh=LsaQb4OhC18hpyBVqDydJSKeE9DHg51I3bJkcs8/5z4=;
        b=ELj7Lfwt8DNqzz7ROEqaKg/lYYtmIVBUzYFZaIUKnmO7ME/bCVj5XYf8zrKeS0NviB
         hJ1bC8mNvhCz9km6UUAvWqUG7cTw7ynvFYSUEsMT+v0R118kFHL9XWm06GJKMxicbCnh
         b1iPqpQxDXJS/j/3SbpvXVoPmzZceG3FgEEEL0DrXsyqKZvsflugQjnH8laYqzqOKuhM
         FOocjJu6HRYeQTXOTwhUI7Iytm5SVySnj6FWLLjXBtCuWfrwp+J7Fp1TbhVXLpW7+Qlb
         t3XAOo4X+TJY7lIxqwMGod8HtZ+ndO5e1ANgdzICjIEddPle9X5oONnpwXhxMLscSx1U
         kwvA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772142300; x=1772747100; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Y9uOSKBgHqz2G18bc8Hl7qpgXohCsZrLcFX0O6OtFs=;
        b=JRiJ9pyM0raRGcBjAbF5kFcf3r6l7tt+H9uNExYeBZTn49lhFcA+DVxTSVeE4/OXjL
         oY6b6l+BLH9uKokh4fAN3yPCEAHHBerCO+vQQQxfT5C48R1OQ2yyR2b+C3nzJP6zVFCE
         9EvTlL7PHKIZkpZTEZCJhwW5MoMzyGRunEQSmEG9sIxsWUFE//hWY1zrnlsZOjKB6pLN
         MO4QyKgZ4IxGxONdYQUkv0n7rjXiHKbCkUWp+yYL4hdsK3ACAVi+Xq8m48oIu18bFCPD
         sbiUwebeZGqCGfFvE2+v9DherCJ3yNkijh9QFpKAvgRJvI/an/7u2IDsu3meBLJ4tiIB
         tabg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772142300; x=1772747100;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1Y9uOSKBgHqz2G18bc8Hl7qpgXohCsZrLcFX0O6OtFs=;
        b=r/0OCmYu3ZpZKx6MXKV54DhhCLBklGCFWTK7Z+xt3xrK7/jQcbQYCrc8z78ZvMuZKo
         EpAIr5ujML+waSQJbj9FAbfURfvrRGvnnt88U2YRzZZgKzFc9T8KEffGOU2MEVjASUcI
         NwNOuWQTyofvOtEXv4XYOlHiAh/uXRA6XtDpgJctcHceSC7lZ6ddqkjOkKuPMUv25OnO
         rm3lJf2F7/8lIz6qer1deJ1Fx8zUm/73E6jKxdMmN7vuEzxq52UnsJUla+/M91OJW8k8
         FUhlAGkJwreMVye+RiUD+cl5uw5igDrA71pF/M68ZG4u28T5nmnmkGumWID9p3GBTdOt
         lGAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRXGeR8vyLW5b2UTkioUevvfgwpe9TBttEoiBD0uPls1i9le4sS27qYCxEwewvCGUAbwj+eZ5mbw==@kvack.org
X-Gm-Message-State: AOJu0YySQ930wVrfy7lv4hz7SzwFa89VAv8OoNob+LA76K+2zfA53Fau
	FX81WEAbxCrAjXFrqoxu/1yj7tkKei5baeYooMcJxqCz32lC+Tw/D1jTfN5l26oIsZSEjXsrEVc
	/W5uP27y4N6J+mELuI/by2aVbePVslplFWV7+T2mF
X-Gm-Gg: ATEYQzwve6nYIc+5yw3KXfGJhvQnl1znm+niP7iCLCq++pQ4j/yfE3m4OFKuofp5tHS
	Mo8OUm8Sj3hZPipmSwHGzCkM2KTpy3MFKnEEAT6cdSz1jq/5zAwCABjiDvc3i1P8JuRr0dVhm6k
	bvKpWiRZf4Q/P0qbccFoXnx48vnsAHKxvqRvGQie0o9ltXSBAxOItDHncuHB2vuA6ktCnSr0OmV
	DjNUJZOCTAGyDWAxIv/UlE++/UtOUs32x25OLYwYeRWkbyLJmzx181x7RSR9GaEgYh0WB9gaXJZ
	ESMinoBREZZ5MaJlqOvqOuQpz4U6rSyYomb2gA==
X-Received: by 2002:a05:622a:1a9e:b0:503:2e98:7842 with SMTP id
 d75a77b69052e-50744154bb3mr5754741cf.4.1772142299044; Thu, 26 Feb 2026
 13:44:59 -0800 (PST)
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-3-surenb@google.com>
 <vb6lgskvpmk6qcdo7tthmc3hpo7jppbx4ke75vepx2nqos65je@wxv7muptiiq5>
In-Reply-To: <vb6lgskvpmk6qcdo7tthmc3hpo7jppbx4ke75vepx2nqos65je@wxv7muptiiq5>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 26 Feb 2026 13:44:47 -0800
X-Gm-Features: AaiRm52-yhPjcJA4soN2rj5ypaM3v6Q5403GLGvYx9bEFNQre_RUQhPEFl7VO2s
Message-ID: <CAJuCfpExatqPmdzSzRupURQ84Cme3JBT2gPvAS3WmK0G24xnPA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: replace vma_start_write() with vma_start_write_killable()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1D657A000E
X-Stat-Signature: tnjoc7gb6kqxm41qs8mwu4qpn9atznw1
X-Rspam-User: 
X-HE-Tag: 1772142300-508448
X-HE-Meta: U2FsdGVkX1/0D/2ZG9guS3mvH2YyaRNEjIJqykzijKR32U36/qlF+O8vSdNTgh8d+1T8jOd/5ouEdhzUb/q76UF/2NGliwFLQ222dVAzeu7CJBJBRGDzEsalZdTzbWAUWbFyQwlsKX1oHo7T+L943zWuA4aLU0UgkedjXz+GdVTPZT2r/5ZL9fCPano2MnkrnwQMF/LNCCe069gB3jdj46rgg1V2sxKSKO6pdnYeM7KRF62OV4M+t6cBa8idkUBaqYm7vG8YWtMePp3AEopfN+++oVo/ww6PujkYWJMxVJC874JaJBtGBVfQvYtpTI2HonqSMuBdXHlHlNELgsqKdajSES++ly3Y9CmPhp1GlSKebFWpW5UgD+ey8nUAk3SGPh0zGaXEgT89HU0SD7qvrSyAdfZKnIrGotmrlIFPn25parZUwlXVyzUMKt3yhGtj2s46xZC4jTEoGKuD7/84uPLbhqWUSKIJu+Y/7cgZX6OH+U0iss4B5iBaOSWp6/ZVfZi6zoFdVmkS9h/eRSyEn7pT83/FIgOXTO1dnOjvkdykoscfZiFUc/1qEDu04leUmg+PGvXDvHpIDBTfrTaLaG78URl+H3i1a9tF1jkKWwf/q8+Di+Vc9uL3p9Yi3Hc0wX94ZjHalqyTi/t6cyZcBeo7dT12JfEPo7AFzWOpnJCJXfWhljpHaeUvcfyvu79plGzJYb5qvs1//zEMR6WTgv7Nps+VPINn3jgHMQx2vIlwhCNWNk1ylRLw6P5IEDs//T9q5ag/Zujdm4nOHBQiXJecSp2oGikPTAXA8pBAOv0v/VRfGhk4cTNbE7VKwWjeahLIWMmZ3vAw0LA7C9TEIScNdTr7FRyzrbsmcdWLp3zQYv1mXXZQANJz96qVq4X2EY3op/pSwq/b88rK835NKyMoaa71t80W4PeVyKyqRGo22obABdBmiQ5zCim4zq0AsFVXaTdJQUoCWLrT2gX
 TkN1Azrt
 Lc6sklaDbDlnESxBbTW8/hIZxSD8WaaiJVtP/7qx9TNwA0oPFfmmvH5aJLmpDwJk6sGAQioVKvQ82il2OLSX+88Mr0buhmWR7fTv/MVOPLEkowwqgKcTkmD++1rzxhNwPz8xB95QyDxv+l1PmarMyuS1DXYCY6hLiiMYKHlmDgiKwFr+dTSofWB9oLNFFyslAG1pURyA+9J6DjzkXY1iPLbjFg5StMh4TrnBQmCkbDvGo3vOEZmvUFEKCqI+i1rpPZKVO+kQQ9seHgBAeqDkHzTX3UPWOykTMQZLlnfIbIC0SaP0XcvlDrLhwnZENIs7hklaaCDWn33YkPXHFotquhbgeokavnOCZyvsonmdFRCc3OWy2vCm2sqvSfbnbLGrvZjNXGi7enZKh9bDiHdoW05DeDBLCsmR0/WRzFKil8Nf4lDYIVv+iSaeWBKkyz+4tcayG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 9:43=E2=80=AFAM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Suren Baghdasaryan <surenb@google.com> [260226 02:06]:
> > Now that we have vma_start_write_killable() we can replace most of the
> > vma_start_write() calls with it, improving reaction time to the kill
> > signal.
> >
> > There are several places which are left untouched by this patch:
> >
> > 1. free_pgtables() because function should free page tables even if a
> > fatal signal is pending.
> >
> > 2. process_vma_walk_lock(), which requires changes in its callers and
> > will be handled in the next patch.
> >
> > 3. userfaultd code, where some paths calling vma_start_write() can
> > handle EINTR and some can't without a deeper code refactoring.
> >
> > 4. mpol_rebind_mm() which is used by cpusset controller for migrations
> > and operates on a remote mm. Incomplete operations here would result
> > in an inconsistent cgroup state.
> >
> > 5. vm_flags_{set|mod|clear} require refactoring that involves moving
> > vma_start_write() out of these functions and replacing it with
> > vma_assert_write_locked(), then callers of these functions should
> > lock the vma themselves using vma_start_write_killable() whenever
> > possible.
> >
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> # powerpc
>
> Some nits below, but lgtm.
>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Thanks!

>
> > ---
> >  arch/powerpc/kvm/book3s_hv_uvmem.c |  5 +-
> >  mm/khugepaged.c                    |  5 +-
> >  mm/madvise.c                       |  4 +-
> >  mm/memory.c                        |  2 +
> >  mm/mempolicy.c                     |  8 ++-
> >  mm/mlock.c                         | 21 +++++--
> >  mm/mprotect.c                      |  4 +-
> >  mm/mremap.c                        |  4 +-
> >  mm/vma.c                           | 93 +++++++++++++++++++++---------
> >  mm/vma_exec.c                      |  6 +-
> >  10 files changed, 109 insertions(+), 43 deletions(-)
> >
> > diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book=
3s_hv_uvmem.c
> > index 5fbb95d90e99..0a28b48a46b8 100644
> > --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> > +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> > @@ -410,7 +410,10 @@ static int kvmppc_memslot_page_merge(struct kvm *k=
vm,
> >                       ret =3D H_STATE;
> >                       break;
> >               }
> > -             vma_start_write(vma);
> > +             if (vma_start_write_killable(vma)) {
> > +                     ret =3D H_STATE;
> > +                     break;
> > +             }
> >               /* Copy vm_flags to avoid partial modifications in ksm_ma=
dvise */
> >               vm_flags =3D vma->vm_flags;
> >               ret =3D ksm_madvise(vma, vma->vm_start, vma->vm_end,
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 1dd3cfca610d..6c92e31ee5fb 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1141,7 +1141,10 @@ static enum scan_result collapse_huge_page(struc=
t mm_struct *mm, unsigned long a
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_up_write;
> >       /* check if the pmd is still valid */
> > -     vma_start_write(vma);
> > +     if (vma_start_write_killable(vma)) {
> > +             result =3D SCAN_FAIL;
> > +             goto out_up_write;
> > +     }
> >       result =3D check_pmd_still_valid(mm, address, pmd);
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_up_write;
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index c0370d9b4e23..ccdaea6b3b15 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -173,7 +173,9 @@ static int madvise_update_vma(vm_flags_t new_flags,
> >       madv_behavior->vma =3D vma;
> >
> >       /* vm_flags is protected by the mmap_lock held in write mode. */
> > -     vma_start_write(vma);
> > +     if (vma_start_write_killable(vma))
> > +             return -EINTR;
> > +
> >       vm_flags_reset(vma, new_flags);
> >       if (set_new_anon_name)
> >               return replace_anon_vma_name(vma, anon_name);
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 07778814b4a8..691062154cf5 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -379,6 +379,8 @@ void free_pgd_range(struct mmu_gather *tlb,
> >   * page tables that should be removed.  This can differ from the vma m=
appings on
> >   * some archs that may have mappings that need to be removed outside t=
he vmas.
> >   * Note that the prev->vm_end and next->vm_start are often used.
> > + * We don't use vma_start_write_killable() because page tables should =
be freed
> > + * even if the task is being killed.
> >   *
> >   * The vma_end differs from the pg_end when a dup_mmap() failed and th=
e tree has
> >   * unrelated data to the mm_struct being torn down.
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 0e5175f1c767..90939f5bde02 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1784,7 +1784,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned=
 long, start, unsigned long, le
> >               return -EINVAL;
> >       if (end =3D=3D start)
> >               return 0;
> > -     mmap_write_lock(mm);
> > +     if (mmap_write_lock_killable(mm))
> > +             return -EINTR;
> >       prev =3D vma_prev(&vmi);
> >       for_each_vma_range(vmi, vma, end) {
> >               /*
> > @@ -1801,13 +1802,16 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsign=
ed long, start, unsigned long, le
> >                       err =3D -EOPNOTSUPP;
> >                       break;
> >               }
> > +             if (vma_start_write_killable(vma)) {
> > +                     err =3D -EINTR;
> > +                     break;
> > +             }
> >               new =3D mpol_dup(old);
> >               if (IS_ERR(new)) {
> >                       err =3D PTR_ERR(new);
> >                       break;
> >               }
> >
> > -             vma_start_write(vma);
> >               new->home_node =3D home_node;
> >               err =3D mbind_range(&vmi, vma, &prev, start, end, new);
> >               mpol_put(new);
> > diff --git a/mm/mlock.c b/mm/mlock.c
> > index 2f699c3497a5..c562c77c3ee0 100644
> > --- a/mm/mlock.c
> > +++ b/mm/mlock.c
> > @@ -420,7 +420,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned lon=
g addr,
> >   * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
> >   * called for munlock() and munlockall(), to clear VM_LOCKED from @vma=
.
> >   */
> > -static void mlock_vma_pages_range(struct vm_area_struct *vma,
> > +static int mlock_vma_pages_range(struct vm_area_struct *vma,
> >       unsigned long start, unsigned long end, vm_flags_t newflags)
> >  {
> >       static const struct mm_walk_ops mlock_walk_ops =3D {
> > @@ -441,7 +441,9 @@ static void mlock_vma_pages_range(struct vm_area_st=
ruct *vma,
> >        */
> >       if (newflags & VM_LOCKED)
> >               newflags |=3D VM_IO;
> > -     vma_start_write(vma);
> > +     if (vma_start_write_killable(vma))
> > +             return -EINTR;
> > +
> >       vm_flags_reset_once(vma, newflags);
> >
> >       lru_add_drain();
> > @@ -452,6 +454,7 @@ static void mlock_vma_pages_range(struct vm_area_st=
ruct *vma,
> >               newflags &=3D ~VM_IO;
> >               vm_flags_reset_once(vma, newflags);
> >       }
> > +     return 0;
> >  }
> >
> >  /*
> > @@ -501,10 +504,12 @@ static int mlock_fixup(struct vma_iterator *vmi, =
struct vm_area_struct *vma,
> >        */
> >       if ((newflags & VM_LOCKED) && (oldflags & VM_LOCKED)) {
> >               /* No work to do, and mlocking twice would be wrong */
> > -             vma_start_write(vma);
> > +             ret =3D vma_start_write_killable(vma);
> > +             if (ret)
> > +                     goto out;
> >               vm_flags_reset(vma, newflags);
> >       } else {
> > -             mlock_vma_pages_range(vma, start, end, newflags);
> > +             ret =3D mlock_vma_pages_range(vma, start, end, newflags);
> >       }
> >  out:
> >       *prev =3D vma;
> > @@ -733,9 +738,13 @@ static int apply_mlockall_flags(int flags)
> >
> >               error =3D mlock_fixup(&vmi, vma, &prev, vma->vm_start, vm=
a->vm_end,
> >                                   newflags);
> > -             /* Ignore errors, but prev needs fixing up. */
> > -             if (error)
> > +             /* Ignore errors except EINTR, but prev needs fixing up. =
*/
> > +             if (error) {
> > +                     if (error =3D=3D -EINTR)
> > +                             return error;
> > +
> >                       prev =3D vma;
> > +             }
> >               cond_resched();
> >       }
> >  out:
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index c0571445bef7..49dbb7156936 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -765,7 +765,9 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu=
_gather *tlb,
> >        * vm_flags and vm_page_prot are protected by the mmap_lock
> >        * held in write mode.
> >        */
> > -     vma_start_write(vma);
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error < 0)
> > +             goto fail;
> >       vm_flags_reset_once(vma, newflags);
> >       if (vma_wants_manual_pte_write_upgrade(vma))
> >               mm_cp_flags |=3D MM_CP_TRY_CHANGE_WRITABLE;
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index 2be876a70cc0..aef1e5f373c7 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -1286,7 +1286,9 @@ static unsigned long move_vma(struct vma_remap_st=
ruct *vrm)
> >               return -ENOMEM;
> >
> >       /* We don't want racing faults. */
> > -     vma_start_write(vrm->vma);
> > +     err =3D vma_start_write_killable(vrm->vma);
> > +     if (err)
> > +             return err;
> >
> >       /* Perform copy step. */
> >       err =3D copy_vma_and_data(vrm, &new_vma);
> > diff --git a/mm/vma.c b/mm/vma.c
> > index bb4d0326fecb..9f2664f1d078 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -530,6 +530,13 @@ __split_vma(struct vma_iterator *vmi, struct vm_ar=
ea_struct *vma,
> >       if (err)
> >               goto out_free_vmi;
> >
> > +     err =3D vma_start_write_killable(vma);
> > +     if (err)
> > +             goto out_free_mpol;
> > +     err =3D vma_start_write_killable(new);
> > +     if (err)
> > +             goto out_free_mpol;
> > +
> >       err =3D anon_vma_clone(new, vma, VMA_OP_SPLIT);
> >       if (err)
> >               goto out_free_mpol;
> > @@ -540,9 +547,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_are=
a_struct *vma,
> >       if (new->vm_ops && new->vm_ops->open)
> >               new->vm_ops->open(new);
> >
> > -     vma_start_write(vma);
> > -     vma_start_write(new);
> > -
> >       init_vma_prep(&vp, vma);
> >       vp.insert =3D new;
> >       vma_prepare(&vp);
> > @@ -895,16 +899,22 @@ static __must_check struct vm_area_struct *vma_me=
rge_existing_range(
> >       }
> >
> >       /* No matter what happens, we will be adjusting middle. */
> > -     vma_start_write(middle);
> > +     err =3D vma_start_write_killable(middle);
> > +     if (err)
> > +             goto abort;
> >
> >       if (merge_right) {
> > -             vma_start_write(next);
> > +             err =3D vma_start_write_killable(next);
> > +             if (err)
> > +                     goto abort;
> >               vmg->target =3D next;
> >               sticky_flags |=3D (next->vm_flags & VM_STICKY);
> >       }
> >
> >       if (merge_left) {
> > -             vma_start_write(prev);
> > +             err =3D vma_start_write_killable(prev);
> > +             if (err)
> > +                     goto abort;
> >               vmg->target =3D prev;
> >               sticky_flags |=3D (prev->vm_flags & VM_STICKY);
> >       }
> > @@ -1155,10 +1165,12 @@ int vma_expand(struct vma_merge_struct *vmg)
> >       struct vm_area_struct *next =3D vmg->next;
> >       bool remove_next =3D false;
> >       vm_flags_t sticky_flags;
> > -     int ret =3D 0;
> > +     int ret;
> >
> >       mmap_assert_write_locked(vmg->mm);
> > -     vma_start_write(target);
> > +     ret =3D vma_start_write_killable(target);
> > +     if (ret)
> > +             return ret;
> >
> >       if (next && target !=3D next && vmg->end =3D=3D next->vm_end)
> >               remove_next =3D true;
> > @@ -1187,6 +1199,9 @@ int vma_expand(struct vma_merge_struct *vmg)
> >        * we don't need to account for vmg->give_up_on_mm here.
> >        */
> >       if (remove_next) {
> > +             ret =3D vma_start_write_killable(next);
> > +             if (ret)
> > +                     return ret;
> >               ret =3D dup_anon_vma(target, next, &anon_dup);
> >               if (ret)
> >                       return ret;
> > @@ -1197,10 +1212,8 @@ int vma_expand(struct vma_merge_struct *vmg)
> >                       return ret;
> >       }
> >
> > -     if (remove_next) {
> > -             vma_start_write(next);
> > +     if (remove_next)
> >               vmg->__remove_next =3D true;
> > -     }
> >       if (commit_merge(vmg))
> >               goto nomem;
> >
> > @@ -1233,6 +1246,7 @@ int vma_shrink(struct vma_iterator *vmi, struct v=
m_area_struct *vma,
> >              unsigned long start, unsigned long end, pgoff_t pgoff)
> >  {
> >       struct vma_prepare vp;
> > +     int err;
> >
> >       WARN_ON((vma->vm_start !=3D start) && (vma->vm_end !=3D end));
> >
> > @@ -1244,7 +1258,11 @@ int vma_shrink(struct vma_iterator *vmi, struct =
vm_area_struct *vma,
> >       if (vma_iter_prealloc(vmi, NULL))
> >               return -ENOMEM;
> >
> > -     vma_start_write(vma);
> > +     err =3D vma_start_write_killable(vma);
> > +     if (err) {
> > +             vma_iter_free(vmi);
> > +             return err;
> > +     }
>
> Could avoid allocating here by reordering the lock, but this is fine.

Ack. I'll move it before vma_iter_prealloc().

>
> >
> >       init_vma_prep(&vp, vma);
> >       vma_prepare(&vp);
> > @@ -1434,7 +1452,9 @@ static int vms_gather_munmap_vmas(struct vma_munm=
ap_struct *vms,
> >                       if (error)
> >                               goto end_split_failed;
> >               }
> > -             vma_start_write(next);
> > +             error =3D vma_start_write_killable(next);
> > +             if (error)
> > +                     goto munmap_gather_failed;
> >               mas_set(mas_detach, vms->vma_count++);
> >               error =3D mas_store_gfp(mas_detach, next, GFP_KERNEL);
> >               if (error)
> > @@ -1828,12 +1848,17 @@ static void vma_link_file(struct vm_area_struct=
 *vma, bool hold_rmap_lock)
> >  static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
> >  {
> >       VMA_ITERATOR(vmi, mm, 0);
> > +     int err;
> >
> >       vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
> >       if (vma_iter_prealloc(&vmi, vma))
> >               return -ENOMEM;
> >
> > -     vma_start_write(vma);
> > +     err =3D vma_start_write_killable(vma);
> > +     if (err) {
> > +             vma_iter_free(&vmi);
> > +             return err;
> > +     }
>
> Ditto here, ordering would mean no freeing.

Ack. Will move.

>
> >       vma_iter_store_new(&vmi, vma);
> >       vma_link_file(vma, /* hold_rmap_lock=3D */false);
> >       mm->map_count++;
> > @@ -2215,9 +2240,8 @@ int mm_take_all_locks(struct mm_struct *mm)
> >        * is reached.
> >        */
> >       for_each_vma(vmi, vma) {
> > -             if (signal_pending(current))
> > +             if (signal_pending(current) || vma_start_write_killable(v=
ma))
> >                       goto out_unlock;
> > -             vma_start_write(vma);
> >       }
> >
> >       vma_iter_init(&vmi, mm, 0);
> > @@ -2522,6 +2546,11 @@ static int __mmap_new_vma(struct mmap_state *map=
, struct vm_area_struct **vmap)
> >       if (!vma)
> >               return -ENOMEM;
> >
> > +     /* Lock the VMA since it is modified after insertion into VMA tre=
e */
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto free_vma;
> > +
>
> There's no way this is going to fail, right?

You are technically correct but this is only true because of how
vma_start_write_killable() is implemented, so it's a technical detail
of the implementation, which might change in the future...
To clarify, __vma_start_exclude_readers() always succeeds if the vma
is detached (which is the case here) because in that case it bails out
before calling rcuwait_wait_event().

>
> >       vma_iter_config(vmi, map->addr, map->end);
> >       vma_set_range(vma, map->addr, map->end, map->pgoff);
> >       vm_flags_init(vma, map->vm_flags);
> > @@ -2552,8 +2581,6 @@ static int __mmap_new_vma(struct mmap_state *map,=
 struct vm_area_struct **vmap)
> >       WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
> >  #endif
> >
> > -     /* Lock the VMA since it is modified after insertion into VMA tre=
e */
> > -     vma_start_write(vma);
> >       vma_iter_store_new(vmi, vma);
> >       map->mm->map_count++;
> >       vma_link_file(vma, map->hold_file_rmap_lock);
> > @@ -2864,6 +2891,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct=
 vm_area_struct *vma,
> >                unsigned long addr, unsigned long len, vm_flags_t vm_fla=
gs)
> >  {
> >       struct mm_struct *mm =3D current->mm;
> > +     int err =3D -ENOMEM;
> >
> >       /*
> >        * Check against address space limits by the changed size
> > @@ -2908,7 +2936,10 @@ int do_brk_flags(struct vma_iterator *vmi, struc=
t vm_area_struct *vma,
> >       vma_set_range(vma, addr, addr + len, addr >> PAGE_SHIFT);
> >       vm_flags_init(vma, vm_flags);
> >       vma->vm_page_prot =3D vm_get_page_prot(vm_flags);
> > -     vma_start_write(vma);
> > +     if (vma_start_write_killable(vma)) {
> > +             err =3D -EINTR;
> > +             goto mas_store_fail;
> > +     }
>
> I'd rather have another label saying write lock failed.  Really, this
> will never fail though (besides syzbot..)

Sure, I'll add another label.

>
> >       if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
> >               goto mas_store_fail;
> >
> > @@ -2928,7 +2959,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct=
 vm_area_struct *vma,
> >       vm_area_free(vma);
> >  unacct_fail:
> >       vm_unacct_memory(len >> PAGE_SHIFT);
> > -     return -ENOMEM;
> > +     return err;
> >  }
> >
> >  /**
> > @@ -3089,7 +3120,7 @@ int expand_upwards(struct vm_area_struct *vma, un=
signed long address)
> >       struct mm_struct *mm =3D vma->vm_mm;
> >       struct vm_area_struct *next;
> >       unsigned long gap_addr;
> > -     int error =3D 0;
> > +     int error;
> >       VMA_ITERATOR(vmi, mm, vma->vm_start);
> >
> >       if (!(vma->vm_flags & VM_GROWSUP))
> > @@ -3126,12 +3157,14 @@ int expand_upwards(struct vm_area_struct *vma, =
unsigned long address)
> >
> >       /* We must make sure the anon_vma is allocated. */
> >       if (unlikely(anon_vma_prepare(vma))) {
> > -             vma_iter_free(&vmi);
> > -             return -ENOMEM;
> > +             error =3D -ENOMEM;
> > +             goto free;
> >       }
> >
> >       /* Lock the VMA before expanding to prevent concurrent page fault=
s */
> > -     vma_start_write(vma);
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto free;
> >       /* We update the anon VMA tree. */
> >       anon_vma_lock_write(vma->anon_vma);
> >
> > @@ -3160,6 +3193,7 @@ int expand_upwards(struct vm_area_struct *vma, un=
signed long address)
> >               }
> >       }
> >       anon_vma_unlock_write(vma->anon_vma);
> > +free:
> >       vma_iter_free(&vmi);
> >       validate_mm(mm);
> >       return error;
> > @@ -3174,7 +3208,7 @@ int expand_downwards(struct vm_area_struct *vma, =
unsigned long address)
> >  {
> >       struct mm_struct *mm =3D vma->vm_mm;
> >       struct vm_area_struct *prev;
> > -     int error =3D 0;
> > +     int error;
> >       VMA_ITERATOR(vmi, mm, vma->vm_start);
> >
> >       if (!(vma->vm_flags & VM_GROWSDOWN))
> > @@ -3205,12 +3239,14 @@ int expand_downwards(struct vm_area_struct *vma=
, unsigned long address)
> >
> >       /* We must make sure the anon_vma is allocated. */
> >       if (unlikely(anon_vma_prepare(vma))) {
> > -             vma_iter_free(&vmi);
> > -             return -ENOMEM;
> > +             error =3D -ENOMEM;
> > +             goto free;
> >       }
> >
> >       /* Lock the VMA before expanding to prevent concurrent page fault=
s */
> > -     vma_start_write(vma);
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto free;
> >       /* We update the anon VMA tree. */
> >       anon_vma_lock_write(vma->anon_vma);
> >
> > @@ -3240,6 +3276,7 @@ int expand_downwards(struct vm_area_struct *vma, =
unsigned long address)
> >               }
> >       }
> >       anon_vma_unlock_write(vma->anon_vma);
> > +free:
> >       vma_iter_free(&vmi);
> >       validate_mm(mm);
> >       return error;
> > diff --git a/mm/vma_exec.c b/mm/vma_exec.c
> > index 8134e1afca68..a4addc2a8480 100644
> > --- a/mm/vma_exec.c
> > +++ b/mm/vma_exec.c
> > @@ -40,6 +40,7 @@ int relocate_vma_down(struct vm_area_struct *vma, uns=
igned long shift)
> >       struct vm_area_struct *next;
> >       struct mmu_gather tlb;
> >       PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
> > +     int err;
> >
> >       BUG_ON(new_start > new_end);
> >
> > @@ -55,8 +56,9 @@ int relocate_vma_down(struct vm_area_struct *vma, uns=
igned long shift)
> >        * cover the whole range: [new_start, old_end)
> >        */
> >       vmg.target =3D vma;
> > -     if (vma_expand(&vmg))
> > -             return -ENOMEM;
> > +     err =3D vma_expand(&vmg);
> > +     if (err)
> > +             return err;
> >
> >       /*
> >        * move the page tables downwards, on failure we rely on
> > --
> > 2.53.0.414.gf7e9f6c205-goog
> >
> >
>

