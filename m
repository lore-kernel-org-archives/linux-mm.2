Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78FCCF483E6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15376B0095; Mon, 23 Mar 2026 15:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC53D6B0096; Mon, 23 Mar 2026 15:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E286B0098; Mon, 23 Mar 2026 15:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B51216B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:22:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5E40D160AE4
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:22:48 +0000 (UTC)
X-FDA: 84578300016.24.D4BAD15
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id E6D8520010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:22:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="FCGv0rM/";
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774293766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhZMNA+jzIVsri788AmGGvsH/fnjM2gWyUC4SEwJrJ0=;
	b=mKUN8v3MMmCh1xNme3AAXWM99FrtwMW72KH02zqX1llxbyKRRH05Kjbb6g6KtcHCNdZtJM
	LeuiTgBZ8XNGwhXRAMSbaaXYCBNvxVDXeqUG54n2EgnBVHYXCB1s9jhMVePdpX5VpnR2Jk
	hnBkniQ82vMH1fCu2Q+3elvbfspDmJ4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="FCGv0rM/";
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774293766; a=rsa-sha256;
	cv=pass;
	b=6HQTB1oZmgBbmitXkfIGK54CH7y6uuI+op+OCLjhmE7Qs1bcM/k9IWvBCzObdujErs/LtN
	or+DYUTiEVrAwo1wm85ILx3O9a2QASNEllnTO+yXSWvjF5tH78/WIQYHGQ32UDjvtJjZHE
	NjaW27Y5C7h0DCYzVZwh2oSMSTp7tvI=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50b6c45781aso177661cf.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:22:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774293765; cv=none;
        d=google.com; s=arc-20240605;
        b=FAWnPpeQLSKzvdq+TXN8uO2pyscHB/d4Ufr8nyHuCnnb8d6C+QgXgghXyvbmbuIf+V
         /dpk4GGhO2uhFyCnT63ppKNMDpdSE724hgUs0sPYVse92/jGeo0SwBN6azU17dJLp6d4
         nS2paj7wgmLW8iGiAanaLU7iGregWKs3llGXM/ACdOUrfMnOFiwu2Ul908KKM6xowjmE
         ADdcotPEvGPZ82FwcF+iQYMIuJrsFerhMDojYGCB8vjc4zCSDabjot/f7/0kFBOes0hC
         BsR1hDCUBPbhQbubYuuPpwJMyvnEVurfe+tMxm8AkLbzjncF0rKaHa+va4yHQCmrwcm+
         7GZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hhZMNA+jzIVsri788AmGGvsH/fnjM2gWyUC4SEwJrJ0=;
        fh=FNuPLrSN6hKs6YS/skZwqsabXOZCjtDIsbSu+0bMg40=;
        b=V3Mc88RdsAvqtv026abhYaU9Maud0sSD25il33TKSloXGI5WyLxjC03Zzab3B7WbX1
         2GnkAZLRRguKkc+fa/0aiBQ385OWmUbI3yFc47c4RMO0rgLpzrGY/a0Tjaa36mxFCNa7
         bBF5MjrggiYs3U3BXto4mEsnZfLtW16DXJPW+TPhiUcGOu5eW8tjbr1Bp6d9KyC5qg/u
         YfkBf0OguN0ieIPsqp38yzIkZ2eaHa+7Q1vz4PSsBpy1+6SpbwDUZhcM0Xus8XDpkqsI
         1ZmMwlNG69W+u4PIRF5fVhjVBzqqBVrNTYDJVp3vZXwVxA191+4rFYTqUt2Yte6UFlaj
         8wUg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774293765; x=1774898565; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhZMNA+jzIVsri788AmGGvsH/fnjM2gWyUC4SEwJrJ0=;
        b=FCGv0rM/KT1bwYADYE+EnRhMjvl0f5psAjpZW2pKMTPbvP5Zys5QL8g0vZHnTWzBj4
         ML9S3nU54Wy0s4fM4rlLp0W3Uz7QALmfd76uExvHyf4bGy0ON/ZDC4GsHiRbEJb4pX0V
         oDRUw2pjosimDZNtgs7FW2U6OPUmERmvhk8nRj1cxNAk0XsNyfY8y/J/nE+CGD9JUUWH
         Hgxi3WzDG0U1zwBoU214C2Z2UHu/9jTWL2a3FN6q2R/9FEHftRKiJhBMSuVXxdGK1dyM
         RivYdx2uRkvi4XGTx/e8IzwkKgyJQHR3fNlwBfbRzJTf34RCm54ajCNeoDW/sMBMcY8/
         JSKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774293765; x=1774898565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hhZMNA+jzIVsri788AmGGvsH/fnjM2gWyUC4SEwJrJ0=;
        b=fca2un1jkddpQP4GzSynAGiIncWFT+04BcfSZW8x7zqoX8+UEeO2/pkTOUPltbCfCf
         rh3Er9FVOA3U+EzD4BkD1pocQ4+pt5rhBFtinGNcM54QBKirD9S+7xrj5FrG4qVK1EM+
         0I/UbCQcnQ6JFIaCsxGIwc6vCfb7Pm6lTux8O4qrDjx4FYfnMQT/z2htAAHrBqvAwyho
         hdHJMRJHVRDlGyjsP7MEm+hboRFrNzy25ZWndfrWWtMck3pBG11ym8KQhLhLmm7TrfHf
         T5XynUuiejAxSV52tByK968hxvu6o30swLnLl2IQl4LF233q8nKQnyDSAPWi6HSLwCW0
         8ypg==
X-Forwarded-Encrypted: i=1; AJvYcCXbWwRWudYcFEAe4tcGvBV8VNWwPNN29Dg7j35VT2TLUAY5QqYFeXiXqlBAEzo0sMor6kdRVKcufw==@kvack.org
X-Gm-Message-State: AOJu0Yxz4kge0WjrhejZGOUkv/sXulA1fHPHAFZl2zVQ7Zcp55Wv7FTA
	qv1e1lf+PozVvP9dLZLke46chRlIzHmP4iH6MwBQGXawWZw/aiFOFpgtSseepqtQSjO6NE1nNSl
	lq679VBuAo//cYvuh8vxaand4M4eqSEONYLp362ru
X-Gm-Gg: ATEYQzzIKipAAiJ+ti6WZWIyjsHGIr1SZk57RxQfqqNlC6asZYXdfoW8G9SP1y73+68
	A/ScvjRErPMNXvsxrjdH6OlwIikFx3YYRsctQut8sM/Uy1w1D9K0TugSXkqjCqJxVfNxrpgqbHM
	nHIrl8Y9vbvA83ZkxqvBBakrNFA6QpvY32iv5Lvsy1LFIz7NXvpvzh4JhsTdQUWJ8nhLOvf6oSy
	0VBggrXhOfFjb/3260aoXM6fCTdsAwzXQN4TdUEL9lEg22wvUH6kakfaPQI76NxoDebgZCBcOOd
	wOHinA==
X-Received: by 2002:a05:622a:a6c7:b0:509:1d4b:f86f with SMTP id
 d75a77b69052e-50b6fc209e3mr2195611cf.14.1774293764021; Mon, 23 Mar 2026
 12:22:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260322054309.898214-1-surenb@google.com> <20260322054309.898214-3-surenb@google.com>
 <9845b243-1984-4d74-9feb-d9d28757fba6@lucifer.local>
In-Reply-To: <9845b243-1984-4d74-9feb-d9d28757fba6@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 23 Mar 2026 12:22:32 -0700
X-Gm-Features: AQROBzCVUZnEmrwdmvEWaC2ljiMixbWoKGB4FyKsWWPRJShDJJ_AC9-yE4VaES8
Message-ID: <CAJuCfpGeup5i5T4LTK3M2D3voorgSteSx111twv9nzdDsK5RnQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] mm: replace vma_start_write() with vma_start_write_killable()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E6D8520010
X-Stat-Signature: 3dn8k5pf9xtbndk9sy9rk4fbyciwh38b
X-Rspam-User: 
X-HE-Tag: 1774293765-113835
X-HE-Meta: U2FsdGVkX18Yz5jr8wmwOkXNCbCky5FqsBuPmUT4Fw8PpuXlGjes7OZI3MceijykK/sayuhalmPFcmJfWcHfOKqJq4mNF6t5Ba6EoRDEEhUs8yp2MDkmi8AV4A6/2xv7t+FHb3rNKYDRO7P0LPyaJ1FiB026Nsy7FSSaIbQ4mpcBAylEUXZ8fuAVpUzgzbXEMjL5LhXcBWTWflKa1WS3lPzZ31w8VDt6cyMyuken8OdW6gcgNOf0+9N7HNXkgUK1qkDEGzlXJIYqL9qruJYUbTIgJzj+14NUrTmz8gZTEg95Dfx4DTS843T4MsjFZlnqhAsa0jUtHbKe/3mZ+QzPZTiBb5UOnJyLbzWHyKZ4EqeB0dZt88M7sjAeUCi7badnBUhvIjcbv8oo3YdJlTv/zIB/Uzic1m9MxHfsuYKBsEczJhHUAwrDvywrfEmH+BkWZfQd7VlVa7Kg/m5NbsOELgtRPc6B+jCooCHq8k0qxo6f9yREDyFfuf6JKmToephaFxMFpuH4587I/xn2j5jAq9HtOW+qbaya4NkXrgI2zASGFh+g7j7G9BvlpctESw9Q3YIBXzblX1UxDZ9a8sdp4bwrTwcWRfXzQ/ZBJCVoF2j7cUXK7xxsNmjCsupDRy6nGUS2AqBWMJ4i4dkilz2p62k5SclaGIlvfJz0wMMxS2estP5B3Ih+AuTGMEgxh5KjyXq0yHICWwlzTWQowdqLcdlBchje/P4lcNaNkZ3sO8TrEHzt1dIqQbr0KankVcNiniMN0T/lA+1jqF2H+Nk83igZp6WAbjRfXYq1OJ2Nz3Jw4Jzp6zCbPyc0JmgRAz1Jn9UiwLGKbWijCkJh5aGLtlV70z29SJpWB+duQOj2ry0N0wH8nVqqPXt/Q78puWO5FsnIjyxc8ubO6tytQati3p4mNF/lh0a6lY/gZn3fjbBsjfhNYcbd0h1Vg7NbbUgtpMZlgjN68VrEmEfp3Zo
 K+rtNPIa
 QG/Ube7SfpXsQ0BjFVhHeioLPAinJZEAf9gS9hX2b4p5sB8DpKZe654vaY4NAQKMQWsBq4Fcp1DGSsbx7qbl/Ez8x9LsNcSfHmceKm3uPrtiYdoHug1T85g99GkS4G3ARsHY0PE1XUnoBB1FflbpZhRSAYVdug1BqJo/UFv9xBa8Hm7BxqF1n3OumKRQMquyacQPn3sgm1F7JTYUd4ucXDZj9XM7Et5EvWmIhkZ6XqDFEQnY8XhpmSZX2Nam8TSEhdMGDN8AZwnUeXauGSjwMuWC9Ws9Ft1NT3IqS1TqNUZjkE/drVji2ufvHCuYJa7toTYIJa/pF/Q+CGc0PVjVJCWIKuI1rk662lbLuxApiX+FymBMxNiG5LvjtCKyoq3tGFrjDUo2A45PaVN3PzvfI5SxdswIWHdmLuYxlkjcShhdnHpLTRACakE/9vHVjApyQLwLXHb6lGwliGJerBC4DgBz1YUlnN7Lti1sTBGivUsq1Uow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 10:49=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> On Sat, Mar 21, 2026 at 10:43:06PM -0700, Suren Baghdasaryan wrote:
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
> > 4. mpol_rebind_mm() which is used by cpuset controller for migrations
> > and operates on a remote mm. Incomplete operations here would result
> > in an inconsistent cgroup state.
> >
> > 5. vm_flags_{set|mod|clear} require refactoring that involves moving
> > vma_start_write() out of these functions and replacing it with
> > vma_assert_write_locked(), then callers of these functions should
> > lock the vma themselves using vma_start_write_killable() whenever
> > possible.
> >
> > In a number of places we now lock VMA earlier than before to avoid
> > doing work and undoing it later if a fatal signal is pending. This
> > is safe because the moves are happening within sections where we
> > already hold the mmap_write_lock, so the moves do not change the
> > locking order relative to other kernel locks.
> >
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> # powerpc
>
> This really really needs splitting up into separate patches for the vario=
us
> bits you change, I know it might seem pedantic, but it's much harder to
> review this as one big patch, and hurts bisectability/specificity of fixe=
s
> etc.
>
> Come, embrace the stats :)
>
> You are welcome to apply a 'Reviewed-by: Lorenzo Stoakes (Oracle)
> <ljs@kernel.org>' tag to all of the split-out patches where I have said
> LGTM throughout!

Thanks!
How would you suggest splitting the patch? I'm outlining one possible
division below. Let me know if you want to slice it differently:

>
> > ---
> >  arch/powerpc/kvm/book3s_hv_uvmem.c |   5 +-

The above one can obviously be split as it's powerpc specific.

> >  mm/khugepaged.c                    |   5 +-
> >  mm/madvise.c                       |   4 +-
> >  mm/memory.c                        |   2 +

The changes in the above files are almost one-liners with the last one
being just a comment change. Should each one go into a separate patch?

> >  mm/mempolicy.c                     |  12 ++-

I guess mempolicy one can be a separate patch.

> >  mm/mlock.c                         |  28 +++++--
> >  mm/mprotect.c                      |   5 +-
> >  mm/mremap.c                        |   4 +-

Maybe the above 3 can go together?

> >  mm/vma.c                           | 117 +++++++++++++++++++++--------
> >  mm/vma_exec.c                      |   6 +-

The above two files I think can go together and this is the most sizable on=
e.


> >  10 files changed, 142 insertions(+), 46 deletions(-)
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
>
> LGTM
>
> >               /* Copy vm_flags to avoid partial modifications in ksm_ma=
dvise */
> >               vm_flags =3D vma->vm_flags;
> >               ret =3D ksm_madvise(vma, vma->vm_start, vma->vm_end,
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 4b0e59c7c0e6..e2f263076084 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1159,7 +1159,10 @@ static enum scan_result collapse_huge_page(struc=
t mm_struct *mm, unsigned long a
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_up_write;
> >       /* check if the pmd is still valid */
> > -     vma_start_write(vma);
> > +     if (vma_start_write_killable(vma)) {
> > +             result =3D SCAN_FAIL;
> > +             goto out_up_write;
> > +     }
>
> LGTM
>
> >       result =3D check_pmd_still_valid(mm, address, pmd);
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_up_write;
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 69708e953cf5..feaa16b0e1dc 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -175,7 +175,9 @@ static int madvise_update_vma(vm_flags_t new_flags,
> >       madv_behavior->vma =3D vma;
> >
> >       /* vm_flags is protected by the mmap_lock held in write mode. */
> > -     vma_start_write(vma);
> > +     if (vma_start_write_killable(vma))
> > +             return -EINTR;
> > +
>
> LGTM
>
> >       vma->flags =3D new_vma_flags;
> >       if (set_new_anon_name)
> >               return replace_anon_vma_name(vma, anon_name);
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 68cc592ff0ba..b930459e32ec 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -366,6 +366,8 @@ void free_pgd_range(struct mmu_gather *tlb,
> >   * page tables that should be removed.  This can differ from the vma m=
appings on
> >   * some archs that may have mappings that need to be removed outside t=
he vmas.
> >   * Note that the prev->vm_end and next->vm_start are often used.
> > + * We don't use vma_start_write_killable() because page tables should =
be freed
> > + * even if the task is being killed.
>
> Nice.
>
> >   *
> >   * The vma_end differs from the pg_end when a dup_mmap() failed and th=
e tree has
> >   * unrelated data to the mm_struct being torn down.
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index e5528c35bbb8..929e843543cf 100644
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
> > @@ -1801,13 +1802,20 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsign=
ed long, start, unsigned long, le
> >                       err =3D -EOPNOTSUPP;
> >                       break;
> >               }
> > +             /*
> > +              * Lock the VMA early to avoid extra work if fatal signal
> > +              * is pending.
> > +              */
> > +             if (vma_start_write_killable(vma)) {
> > +                     err =3D -EINTR;
> > +                     break;
> > +             }
>
> LGTM, one nitty thing - wonder if we shouldn't pass through the error fro=
m
> vma_start_write_killable()? OTOH, it's not really a big deal. I don't
> foresee us ever returning anything but -EINTR or 0 :)

Ack. I'll change err to record vma_start_write_killable() return value inst=
ead.

>
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
> > index 8c227fefa2df..efbb9c783f25 100644
> > --- a/mm/mlock.c
> > +++ b/mm/mlock.c
> > @@ -419,8 +419,10 @@ static int mlock_pte_range(pmd_t *pmd, unsigned lo=
ng addr,
> >   *
> >   * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
> >   * called for munlock() and munlockall(), to clear VM_LOCKED from @vma=
.
> > + *
> > + * Return: 0 on success, -EINTR if fatal signal is pending.
> >   */
> > -static void mlock_vma_pages_range(struct vm_area_struct *vma,
> > +static int mlock_vma_pages_range(struct vm_area_struct *vma,
> >       unsigned long start, unsigned long end,
> >       vma_flags_t *new_vma_flags)
> >  {
> > @@ -442,7 +444,9 @@ static void mlock_vma_pages_range(struct vm_area_st=
ruct *vma,
> >        */
> >       if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
> >               vma_flags_set(new_vma_flags, VMA_IO_BIT);
> > -     vma_start_write(vma);
> > +     if (vma_start_write_killable(vma))
> > +             return -EINTR;
> > +
>
> LGTM
>
> >       vma_flags_reset_once(vma, new_vma_flags);
> >
> >       lru_add_drain();
> > @@ -453,6 +457,7 @@ static void mlock_vma_pages_range(struct vm_area_st=
ruct *vma,
> >               vma_flags_clear(new_vma_flags, VMA_IO_BIT);
> >               vma_flags_reset_once(vma, new_vma_flags);
> >       }
> > +     return 0;
> >  }
> >
> >  /*
> > @@ -506,11 +511,13 @@ static int mlock_fixup(struct vma_iterator *vmi, =
struct vm_area_struct *vma,
> >        */
> >       if (vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT) &&
> >           vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT)) {
> > +             ret =3D vma_start_write_killable(vma);
> > +             if (ret)
> > +                     goto out;
>
> LGTM
>
> >               /* No work to do, and mlocking twice would be wrong */
> > -             vma_start_write(vma);
> >               vma->flags =3D new_vma_flags;
> >       } else {
> > -             mlock_vma_pages_range(vma, start, end, &new_vma_flags);
> > +             ret =3D mlock_vma_pages_range(vma, start, end, &new_vma_f=
lags);
>
> LGTM
>
> >       }
> >  out:
> >       *prev =3D vma;
> > @@ -739,9 +746,18 @@ static int apply_mlockall_flags(int flags)
> >
> >               error =3D mlock_fixup(&vmi, vma, &prev, vma->vm_start, vm=
a->vm_end,
> >                                   newflags);
> > -             /* Ignore errors, but prev needs fixing up. */
> > -             if (error)
> > +             if (error) {
> > +                     /*
> > +                      * If we failed due to a pending fatal signal, re=
turn
> > +                      * now. If we locked the vma before signal arrive=
d, it
> > +                      * will be unlocked when we drop mmap_write_lock.
> > +                      */
> > +                     if (fatal_signal_pending(current))
> > +                             return -EINTR;
>
> LGTM, and thanks for careful explanation, hopefully addresses Matthew's
> concerns ([0]).

That was my goal :)

>
> [0]:https://lore.kernel.org/all/aaiBX5Mm36Kg0wq1@casper.infradead.org/
>
> > +
> > +                     /* Ignore errors, but prev needs fixing up. */
> >                       prev =3D vma;
> > +             }
> >               cond_resched();
> >       }
> >  out:
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index 110d47a36d4b..ae6ed882b600 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -768,7 +768,10 @@ mprotect_fixup(struct vma_iterator *vmi, struct mm=
u_gather *tlb,
> >        * vm_flags and vm_page_prot are protected by the mmap_lock
> >        * held in write mode.
> >        */
> > -     vma_start_write(vma);
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto fail;
> > +
>
> LGTM
>
> >       vma_flags_reset_once(vma, &new_vma_flags);
> >       if (vma_wants_manual_pte_write_upgrade(vma))
> >               mm_cp_flags |=3D MM_CP_TRY_CHANGE_WRITABLE;
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index e9c8b1d05832..dec39ec314f9 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -1356,7 +1356,9 @@ static unsigned long move_vma(struct vma_remap_st=
ruct *vrm)
> >               return -ENOMEM;
> >
> >       /* We don't want racing faults. */
> > -     vma_start_write(vrm->vma);
> > +     err =3D vma_start_write_killable(vrm->vma);
> > +     if (err)
> > +             return err;
>
> Yeah this is subtle, I saw sashiko flagged it, so I checked and this isn'=
t
> being accounted properly.
>
> vrm_calc_charge() charges via
> security_vm_enough_memory_mm()->__vm_enough_memory()->vm_acct_memory()
>
> And we only uncharge via vrm_uncharge()->vm_unacct_memory()
>
> The other error function there is:
>
>         err =3D copy_vma_and_data(vrm, &new_vma);
>         ...
>         if (err && !new_vma)
>                 return err;
>
> And in copy_vma_and_data():
>
>         if (!new_vma) {
>                 vrm_uncharge(vrm);
>                 *new_vma_ptr =3D NULL;
>                 return -ENOMEM;
>         }
>
> So that's already taken care of for us.
>
> It's stuff like this that is why it's important to separate this patch in=
to
> separate patches :)
>
> We also do some weird and wonderful stuff with error handling where we tr=
y
> to back out the remapped page tables, having swapped the new and old VMAs
> around so the unmapping of the source VMA is done on the destination (yea=
h
> it's horrible).
>
> So this is all very subtle really.
>
> Honestly you might just be better off moving the vma_start_write_killable=
()
> above vrm_calc_charge()?

Yes I'll try that...

>
> If not, you'd just need to replace this with:
>
>         err =3D vma_start_write_killable(vrm->vma);
>         if (err) {
>                 vrm_uncharge(vrm);
>                 return err;
>         }

and if it doesn't work will do the above.

>
> >
> >       /* Perform copy step. */
> >       err =3D copy_vma_and_data(vrm, &new_vma);
> > diff --git a/mm/vma.c b/mm/vma.c
> > index ba78ab1f397a..7930a4270eb9 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -524,6 +524,17 @@ __split_vma(struct vma_iterator *vmi, struct vm_ar=
ea_struct *vma,
> >               new->vm_pgoff +=3D ((addr - vma->vm_start) >> PAGE_SHIFT)=
;
> >       }
> >
> > +     /*
> > +      * Lock VMAs before cloning to avoid extra work if fatal signal
> > +      * is pending.
> > +      */
> > +     err =3D vma_start_write_killable(vma);
> > +     if (err)
> > +             goto out_free_vma;
> > +     err =3D vma_start_write_killable(new);
> > +     if (err)
> > +             goto out_free_vma;
> > +
>
> LGTM
>
> >       err =3D -ENOMEM;
> >       vma_iter_config(vmi, new->vm_start, new->vm_end);
> >       if (vma_iter_prealloc(vmi, new))
> > @@ -543,9 +554,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_are=
a_struct *vma,
> >       if (new->vm_ops && new->vm_ops->open)
> >               new->vm_ops->open(new);
> >
> > -     vma_start_write(vma);
> > -     vma_start_write(new);
> > -
>
> LGTM
>
> >       init_vma_prep(&vp, vma);
> >       vp.insert =3D new;
> >       vma_prepare(&vp);
> > @@ -900,12 +908,16 @@ static __must_check struct vm_area_struct *vma_me=
rge_existing_range(
> >       }
> >
> >       /* No matter what happens, we will be adjusting middle. */
> > -     vma_start_write(middle);
> > +     err =3D vma_start_write_killable(middle);
> > +     if (err)
> > +             goto abort;
>
> I mean looking at this again the vmg_oom() etc. stuff is horrible and I
> definitely need to rework it. Sorry about that!
>
> I think we need to update vma_modify():
>
>         /* First, try to merge. */
>         merged =3D vma_merge_existing_range(vmg);
>         if (merged)
>                 return merged;
>         if (vmg_nomem(vmg))
>                 return ERR_PTR(-ENOMEM);
> +       if (fatal_signal_pending(current))

We need to be careful here. I think there are cases when vma is
modified from a context of a different process, for example in
process_madvise(). fatal_signal_pending(current) would yield incorrect
result because vma->vm_mm is not the same as current->mm.

> +               return -EINTR;
>
> So we can just get out early in this case. I _think_ that should be safe?
> :)
>
> If not, we could hack things here by doing:
>
>         if (err) {
>                 /* Ensure error propagated. */
>                 vmg->give_up_on_oom =3D false;
>                 goto abort;
>         }

I think that would be safer.

>
> And I can just go fix this all up afterwards.
>
> I still don't want a vmg_intr() or anything though, I will rework this in=
to
> something saner!
>
> Anyway apologies, it's entirely my fault that this is a bit of a mess :)

No worries. We all make mistakes that become obvious only later.
Hindsight is always 20/20.

>
> >
> >       if (merge_right) {
> >               vma_flags_t next_sticky;
> >
> > -             vma_start_write(next);
> > +             err =3D vma_start_write_killable(next);
> > +             if (err)
> > +                     goto abort;
>
> Obv not withstanding above LGTM
>
> >               vmg->target =3D next;
> >               next_sticky =3D vma_flags_and_mask(&next->flags, VMA_STIC=
KY_FLAGS);
> >               vma_flags_set_mask(&sticky_flags, next_sticky);
> > @@ -914,7 +926,9 @@ static __must_check struct vm_area_struct *vma_merg=
e_existing_range(
> >       if (merge_left) {
> >               vma_flags_t prev_sticky;
> >
> > -             vma_start_write(prev);
> > +             err =3D vma_start_write_killable(prev);
> > +             if (err)
> > +                     goto abort;
>
> Ditto
>
> >               vmg->target =3D prev;
> >
> >               prev_sticky =3D vma_flags_and_mask(&prev->flags, VMA_STIC=
KY_FLAGS);
> > @@ -1170,10 +1184,12 @@ int vma_expand(struct vma_merge_struct *vmg)
> >       vma_flags_t sticky_flags =3D
> >               vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
> >       vma_flags_t target_sticky;
> > -     int err =3D 0;
> > +     int err;
> >
> >       mmap_assert_write_locked(vmg->mm);
> > -     vma_start_write(target);
> > +     err =3D vma_start_write_killable(target);
> > +     if (err)
> > +             return err;
>
> Yeah dup_anon stuff will not be done yet so this LGTM
>
> >
> >       target_sticky =3D vma_flags_and_mask(&target->flags, VMA_STICKY_F=
LAGS);
> >
> > @@ -1201,6 +1217,13 @@ int vma_expand(struct vma_merge_struct *vmg)
> >        * we don't need to account for vmg->give_up_on_mm here.
> >        */
> >       if (remove_next) {
> > +             /*
> > +              * Lock the VMA early to avoid extra work if fatal signal
> > +              * is pending.
> > +              */
> > +             err =3D vma_start_write_killable(next);
> > +             if (err)
> > +                     return err;
>
> Same here, so LGTM
>
> >               err =3D dup_anon_vma(target, next, &anon_dup);
> >               if (err)
> >                       return err;
> > @@ -1214,7 +1237,6 @@ int vma_expand(struct vma_merge_struct *vmg)
> >       if (remove_next) {
> >               vma_flags_t next_sticky;
> >
> > -             vma_start_write(next);
>
> LGTM
>
> >               vmg->__remove_next =3D true;
> >
> >               next_sticky =3D vma_flags_and_mask(&next->flags, VMA_STIC=
KY_FLAGS);
> > @@ -1252,9 +1274,14 @@ int vma_shrink(struct vma_iterator *vmi, struct =
vm_area_struct *vma,
> >              unsigned long start, unsigned long end, pgoff_t pgoff)
> >  {
> >       struct vma_prepare vp;
> > +     int err;
> >
> >       WARN_ON((vma->vm_start !=3D start) && (vma->vm_end !=3D end));
> >
> > +     err =3D vma_start_write_killable(vma);
> > +     if (err)
> > +             return err;
> > +
> >       if (vma->vm_start < start)
> >               vma_iter_config(vmi, vma->vm_start, start);
> >       else
> > @@ -1263,8 +1290,6 @@ int vma_shrink(struct vma_iterator *vmi, struct v=
m_area_struct *vma,
> >       if (vma_iter_prealloc(vmi, NULL))
> >               return -ENOMEM;
> >
> > -     vma_start_write(vma);
> > -
>
> We will hold the VMA write lock even though we return -ENOMEM, but I gues=
s
> not a big deal as we will drop the mmap write lock on error at the earlie=
st
> opportunity anyway.
>
> So LGTM
>
> >       init_vma_prep(&vp, vma);
> >       vma_prepare(&vp);
> >       vma_adjust_trans_huge(vma, start, end, NULL);
> > @@ -1453,7 +1478,9 @@ static int vms_gather_munmap_vmas(struct vma_munm=
ap_struct *vms,
> >                       if (error)
> >                               goto end_split_failed;
> >               }
> > -             vma_start_write(next);
> > +             error =3D vma_start_write_killable(next);
> > +             if (error)
> > +                     goto munmap_gather_failed;
>
> LGTM
>
> >               mas_set(mas_detach, vms->vma_count++);
> >               error =3D mas_store_gfp(mas_detach, next, GFP_KERNEL);
> >               if (error)
> > @@ -1848,12 +1875,16 @@ static void vma_link_file(struct vm_area_struct=
 *vma, bool hold_rmap_lock)
> >  static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
> >  {
> >       VMA_ITERATOR(vmi, mm, 0);
> > +     int err;
> > +
> > +     err =3D vma_start_write_killable(vma);
> > +     if (err)
> > +             return err;
>
> LGTM
>
> >
> >       vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
> >       if (vma_iter_prealloc(&vmi, vma))
> >               return -ENOMEM;
> >
> > -     vma_start_write(vma);
>
> LGTM
>
> >       vma_iter_store_new(&vmi, vma);
> >       vma_link_file(vma, /* hold_rmap_lock=3D */false);
> >       mm->map_count++;
> > @@ -2239,9 +2270,8 @@ int mm_take_all_locks(struct mm_struct *mm)
> >        * is reached.
> >        */
> >       for_each_vma(vmi, vma) {
> > -             if (signal_pending(current))
> > +             if (signal_pending(current) || vma_start_write_killable(v=
ma))
>
> Hmm, surely signal_pending() should catch it :) but I suppose there could
> be a (very very tight) timing issue here, but case to be made for not
> converting this?

I want to convert all possible vma_start_write() cases in the hopes
that over time I might be able to deprecate vma_start_write()
completely. It's not possible right now (see the changelog) but with
some effort we might get there eventually.

>
> OTOH it doesn't really make much difference I guess.
>
> >                       goto out_unlock;
> > -             vma_start_write(vma);
> >       }
> >
> >       vma_iter_init(&vmi, mm, 0);
> > @@ -2540,8 +2570,8 @@ static int __mmap_new_vma(struct mmap_state *map,=
 struct vm_area_struct **vmap,
> >       struct mmap_action *action)
> >  {
> >       struct vma_iterator *vmi =3D map->vmi;
> > -     int error =3D 0;
> >       struct vm_area_struct *vma;
> > +     int error;
> >
> >       /*
> >        * Determine the object being mapped and call the appropriate
> > @@ -2552,6 +2582,14 @@ static int __mmap_new_vma(struct mmap_state *map=
, struct vm_area_struct **vmap,
> >       if (!vma)
> >               return -ENOMEM;
> >
> > +     /*
> > +      * Lock the VMA early to avoid extra work if fatal signal
> > +      * is pending.
> > +      */
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto free_vma;
> > +
>
> LGTM
>
> >       vma_iter_config(vmi, map->addr, map->end);
> >       vma_set_range(vma, map->addr, map->end, map->pgoff);
> >       vma->flags =3D map->vma_flags;
> > @@ -2582,8 +2620,6 @@ static int __mmap_new_vma(struct mmap_state *map,=
 struct vm_area_struct **vmap,
> >       WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
> >  #endif
> >
> > -     /* Lock the VMA since it is modified after insertion into VMA tre=
e */
> > -     vma_start_write(vma);
>
> LGTM
>
> >       vma_iter_store_new(vmi, vma);
> >       map->mm->map_count++;
> >       vma_link_file(vma, action->hide_from_rmap_until_complete);
> > @@ -2878,6 +2914,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct=
 vm_area_struct *vma,
> >                unsigned long addr, unsigned long len, vma_flags_t vma_f=
lags)
> >  {
> >       struct mm_struct *mm =3D current->mm;
> > +     int err;
>
> LGTM
>
> >
> >       /*
> >        * Check against address space limits by the changed size
> > @@ -2910,24 +2947,33 @@ int do_brk_flags(struct vma_iterator *vmi, stru=
ct vm_area_struct *vma,
> >
> >               if (vma_merge_new_range(&vmg))
> >                       goto out;
> > -             else if (vmg_nomem(&vmg))
> > +             if (vmg_nomem(&vmg)) {
> > +                     err =3D -ENOMEM;
> >                       goto unacct_fail;
> > +             }
>
> LGTM
>
> >       }
> >
> >       if (vma)
> >               vma_iter_next_range(vmi);
> >       /* create a vma struct for an anonymous mapping */
> >       vma =3D vm_area_alloc(mm);
> > -     if (!vma)
> > +     if (!vma) {
> > +             err =3D -ENOMEM;
> >               goto unacct_fail;
> > +     }
>
> LGTM
>
> >
> >       vma_set_anonymous(vma);
> >       vma_set_range(vma, addr, addr + len, addr >> PAGE_SHIFT);
> >       vma->flags =3D vma_flags;
> >       vma->vm_page_prot =3D vm_get_page_prot(vma_flags_to_legacy(vma_fl=
ags));
> > -     vma_start_write(vma);
> > -     if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
> > +     if (vma_start_write_killable(vma)) {
> > +             err =3D -EINTR;
> > +             goto vma_lock_fail;
> > +     }
>
> LGTM
>
> > +     if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL)) {
> > +             err =3D -ENOMEM;
> >               goto mas_store_fail;
> > +     }
>
> LGTM
>
> >
> >       mm->map_count++;
> >       validate_mm(mm);
> > @@ -2942,10 +2988,11 @@ int do_brk_flags(struct vma_iterator *vmi, stru=
ct vm_area_struct *vma,
> >       return 0;
> >
> >  mas_store_fail:
> > +vma_lock_fail:
> >       vm_area_free(vma);
> >  unacct_fail:
> >       vm_unacct_memory(len >> PAGE_SHIFT);
> > -     return -ENOMEM;
> > +     return err;
>
> LGTM
>
> >  }
> >
> >  /**
> > @@ -3112,8 +3159,8 @@ int expand_upwards(struct vm_area_struct *vma, un=
signed long address)
> >       struct mm_struct *mm =3D vma->vm_mm;
> >       struct vm_area_struct *next;
> >       unsigned long gap_addr;
> > -     int error =3D 0;
> >       VMA_ITERATOR(vmi, mm, vma->vm_start);
> > +     int error;
>
> LGTM
>
> >
> >       if (!vma_test(vma, VMA_GROWSUP_BIT))
> >               return -EFAULT;
> > @@ -3149,12 +3196,14 @@ int expand_upwards(struct vm_area_struct *vma, =
unsigned long address)
> >
> >       /* We must make sure the anon_vma is allocated. */
> >       if (unlikely(anon_vma_prepare(vma))) {
> > -             vma_iter_free(&vmi);
> > -             return -ENOMEM;
> > +             error =3D -ENOMEM;
> > +             goto vma_prep_fail;
>
> Hm, but before we weren't calling validate_mm() here, and now we will be,=
 I
> suspect we probably don't want to do that on error. Will comment on it
> below in that bit of the code.
>
> Otherwise, LGTM.
>
> >       }
> >
> >       /* Lock the VMA before expanding to prevent concurrent page fault=
s */
> > -     vma_start_write(vma);
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto vma_lock_fail;
>
> LGTM
>
> >       /* We update the anon VMA tree. */
> >       anon_vma_lock_write(vma->anon_vma);
> >
> > @@ -3183,6 +3232,8 @@ int expand_upwards(struct vm_area_struct *vma, un=
signed long address)
> >               }
> >       }
> >       anon_vma_unlock_write(vma->anon_vma);
> > +vma_lock_fail:
> > +vma_prep_fail:
>
> LGTM
>
> >       vma_iter_free(&vmi);
> >       validate_mm(mm);
>
> Maybe this should be put before the labels?
>
> Then again, I guess there's no harm in it. But I'm not sure taking a long
> time to check the entire maple tree when CONFIG_DEBUG_VM_MAPLE_TREE is
> enabled is a good idea with a fatal signal pending?

That makes sense. Validating a tree when we know something went wrong
is probably meaningless. I'll move it before the jump labels.

>
> >       return error;
> > @@ -3197,8 +3248,8 @@ int expand_downwards(struct vm_area_struct *vma, =
unsigned long address)
> >  {
> >       struct mm_struct *mm =3D vma->vm_mm;
> >       struct vm_area_struct *prev;
> > -     int error =3D 0;
> >       VMA_ITERATOR(vmi, mm, vma->vm_start);
> > +     int error;
>
> LGTM
>
> >
> >       if (!vma_test(vma, VMA_GROWSDOWN_BIT))
> >               return -EFAULT;
> > @@ -3228,12 +3279,14 @@ int expand_downwards(struct vm_area_struct *vma=
, unsigned long address)
> >
> >       /* We must make sure the anon_vma is allocated. */
> >       if (unlikely(anon_vma_prepare(vma))) {
> > -             vma_iter_free(&vmi);
> > -             return -ENOMEM;
> > +             error =3D -ENOMEM;
> > +             goto vma_prep_fail;
> >       }
> >
> >       /* Lock the VMA before expanding to prevent concurrent page fault=
s */
> > -     vma_start_write(vma);
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto vma_lock_fail;
> >       /* We update the anon VMA tree. */
> >       anon_vma_lock_write(vma->anon_vma);
> >
> > @@ -3263,6 +3316,8 @@ int expand_downwards(struct vm_area_struct *vma, =
unsigned long address)
> >               }
> >       }
> >       anon_vma_unlock_write(vma->anon_vma);
> > +vma_lock_fail:
> > +vma_prep_fail:
>
> Obv same comments for expand_upwards() apply here also.
>
> >       vma_iter_free(&vmi);
> >       validate_mm(mm);
> >       return error;
> > diff --git a/mm/vma_exec.c b/mm/vma_exec.c
> > index 5cee8b7efa0f..8ddcc791d828 100644
> > --- a/mm/vma_exec.c
> > +++ b/mm/vma_exec.c
> > @@ -41,6 +41,7 @@ int relocate_vma_down(struct vm_area_struct *vma, uns=
igned long shift)
> >       struct vm_area_struct *next;
> >       struct mmu_gather tlb;
> >       PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
> > +     int err;
> >
> >       BUG_ON(new_start > new_end);
> >
> > @@ -56,8 +57,9 @@ int relocate_vma_down(struct vm_area_struct *vma, uns=
igned long shift)
> >        * cover the whole range: [new_start, old_end)
> >        */
> >       vmg.target =3D vma;
> > -     if (vma_expand(&vmg))
> > -             return -ENOMEM;
> > +     err =3D vma_expand(&vmg);
> > +     if (err)
> > +             return err;
>
> LGTM

Thanks for the detailed review!

>
> >
> >       /*
> >        * move the page tables downwards, on failure we rely on
> > --
> > 2.53.0.1018.g2bb0e51243-goog
> >
>
> Thanks, Lorenzo

