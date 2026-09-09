Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B97D1C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 21:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02BC6B009E; Wed,  9 Sep 2026 17:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4FB6B009F; Wed,  9 Sep 2026 17:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D906B00A0; Wed,  9 Sep 2026 17:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7632A6B009E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:51:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 95B9C402E6
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:51:24 +0000 (UTC)
X-FDA: 85195570488.29.D6D0BBA
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf27.hostedemail.com (Postfix) with ESMTP id A7B6340007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:51:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=O1aM4qix;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788990682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7p9WWZeWPUSCEcOXg2XJofz7nmB+pP1oglnGvljEvQ=;
	b=w54plddwzYJ5LUG46ET2BiltQTz1LVJgDEZG9SMwe3do2bsQesoCpa1+A+QIxEUPsVtjHg
	okrg9HUT/0/5C+vAFnfIkZN1G8aqNPkMu5eCRAOzR+1RdWlFiNr+x8X6Qru3LcnY9o2hpb
	46HxuUdKGtfVF4IzGizRP8rsP72Qkeg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=O1aM4qix;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788990682;
	b=wR3SdfwBOsZgelUT4rjKOrYMDTZ/TUvk52W1/LpsYFEAuAR3tLRtdXAdvthnzezy0cuHA/
	/WuwGOk/CyFn+6QKxfIceJOyqp2uoXtnGk1uSqbczH6+w59VMGiFKIX/MxOX+wQg5/2TrE
	8L8whXBSiHeFVcaP67mOoaUvLYvkK08=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5307425f44bso28451cf.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 14:51:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788990682; cv=none;
        d=google.com; s=arc-20260327;
        b=BPBexX2Wv127LJ2/hl5GzB7QpL3RgBwF0sySF3BtQzCuzvSu/QrX976x3xfF2hr9G0
         AFkbP6QBcHrF5/QGSaTc5PfW82phmECd349T6YjduGpkvo2nA5/3cJ+lKT+J1BGSJjeJ
         9ljTMbNuB9f69AnN488MlGD0e29aESDNnbp41Kj4Lon1kTXo8zxxnk+mHD8M844X8+dP
         GbNGSBohPy0BjS6DWFm2isN/P3H5/mykzUVECw/KS3CC97ZzWEMj86m5XBrnvu+0mywX
         Deo/nDISYx7eP3RZmwNuhJrKqB2/qm3qIG+hMyXUL7g67J2DUq/lWHzwm1Vtz3uw0WdT
         sqTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A7p9WWZeWPUSCEcOXg2XJofz7nmB+pP1oglnGvljEvQ=;
        fh=GKnEQlg3uITWE/dXuvYoEkPzRNdVD6f/WjFZMRTW/fw=;
        b=R0dOZDG59vdqAOCST07cE9qLc0r9XDkT1doTBJqwYa6h6RGelhF+Mh1IjqEXZ0PDUi
         eJvYjrp9zOPLMve4av342XHVdLQ7YSiA55qIuK7Fl2X2a+XqZxmZcRkucfB76EM1txTH
         QQtfg0UXlRSyrdGxAvaaX2pfZ/DJNbKrDOK+gZauKIobJcYAPhAhCVjWUDnX/Y1zfa5K
         zQUTkZfMIQuhhcRn0k1vUZ0Bx2ou4HGKAjamKPhBgeFpi/baImB3yTHMQEkYbSJSL+Xq
         DKduLWWZRXrunV9ta56imnrLVKtRxd6Iz/JOI7y+o94FcEmpg2cS9X7AWdIglT840s+b
         pP2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788990682; x=1789595482; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A7p9WWZeWPUSCEcOXg2XJofz7nmB+pP1oglnGvljEvQ=;
        b=O1aM4qixz0CPl4drUG/7WEe0lL4YdCibtQ5mMAnH+FaXE3iR5ASQqTH8oWW0onz3+y
         cNn5WxVkMK7PrzFvgDLU46VA+6Aohp0dPi3sr/KCWWb7RcLOy2BZGh1gK5ieBxCJsCZt
         +6fn4SQqqt5CyO1pzrDdPBxDNhlQ+ogTyDWu8xQakvmhmyRumv5cXNBKTtFbquCPzYmb
         xEhnmtuEPGhuEUw2WBH25atyGDh2LNGOlugaCNInz3dhPuaJ1bodqTtY7S1lnZzw3xlk
         4MSb9cO547XEdLrfHMtKOW0y06hkQgPZmEVtjHd+l2ygFSQuWk+0TjY/Hzq2g61Hsgdj
         tMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788990682; x=1789595482;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A7p9WWZeWPUSCEcOXg2XJofz7nmB+pP1oglnGvljEvQ=;
        b=ZIlS00N3uBetC3+CghwRxJC4Yolt8IYozgCPMK67QLuIf2mmn8QqzCm1/fKGH1jFXq
         3a+PyzCnTfFV/6tjsoYSSbHJ+pLRSs4UxWg4Q8CLhdoKJn5qVvsy/elEfQ8svBNprp8I
         N1qLmJJa2tEiA58WDlGq8vYbmEjKyGRHgKIF+m9BDLCbvBkgM3z9sDu4VRo/aELYgMDW
         /jyPBkLusml0zStosTQHImNXaBIEe/ITyKRngFzQI7HARirfsB8g2jm+Uenr22DCu2+W
         CaZeA8TWTm6nYBX6C/dRNyil7yK4JQvu5E9oMoBLIm6DMjZgq51cxNDDFLCWwo5OsAlv
         H+Jg==
X-Forwarded-Encrypted: i=1; AKwUvByB1SCgDga3ZI0jRrMgLAHixrVb9/TxLmAhrj8qL2JiFWi5xICYnjP2kLfbvCNGg7SOl0qG+ustqw==@kvack.org
X-Gm-Message-State: AFuF++naG5p9EQzg8biQJjF+4QK2hO3TN4ClXSDbrVz8CSRMpeCa+hkN
	kKSJ+FszaLPZxdI29RKxlppMKrJwahdR0rqKeWhmJwyMJEa8OV7LDzGmptj5ZaRXJ9QBCDZPsA3
	E99h5WtZfbyupeSCqp6F91OCQp/HhF9s6zaddIWLx
X-Gm-Gg: AYBFou2/n5GZhcQ0GineoYoKugrC63b/b9tO7RzUeHO5y/NJDyyRGQe3HA7ome58vlQ
	jS0o9VFrmwDrOQpplPY3XxBAUv8p174abphOvD5MqsjI+Hn88Fs/8rCic5i3o4pPb6CLH8aQofh
	EQYDexDxMCSJyBtRDIsjz46i8PQY7Islw7TMyl3GxratDb7gH5cAvGnhIk4nsmYoc7z2OHd6pwA
	WSAzEmPg88Wb4VNC2g1lj8GFxdi3jTXiU9qmE3S+619rMG7ITwA9RGCzHZ9Dy2evKDB5m+uCUdg
	G8zz445YzoJWbzCsCR5/BGMN+ghJJxFqIl0WrQoMKD78miuChieOrsm+2A==
X-Received: by 2002:ac8:7f81:0:b0:52e:1e8:21f4 with SMTP id
 d75a77b69052e-530b62adb08mr929301cf.5.1788990680995; Wed, 09 Sep 2026
 14:51:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com> <20260907063918.3432401-4-surenb@google.com>
 <4825a2fe-f064-45d7-a7c9-e98de7efe86c@kernel.org> <CAJuCfpFL_g7tELjT8p8ExM3tX_v2gNDM9rRKwwefPV_KW=fHfA@mail.gmail.com>
 <8e643f51-a47f-428e-9443-678326288fa6@kernel.org>
In-Reply-To: <8e643f51-a47f-428e-9443-678326288fa6@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 9 Sep 2026 14:51:09 -0700
X-Gm-Features: AcwNN1WhVGNfB-pxrRcwKFTO2y3J4tLY_kHnkGoYanjTzogNBsN7pKUja62KieY
Message-ID: <CAJuCfpEYdj=u0wczKRrsB8uDkbSzPy+hrsCo9TW9-3J3r3p0xQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A7B6340007
X-Stat-Signature: gke7yd4pgcufjnsgn7ektjnyeynh67n1
X-Rspam-User: 
X-HE-Tag: 1788990682-832103
X-HE-Meta: U2FsdGVkX1/cmtzJnE19wtKcNq+e88reaQq2a9u5hS3/hTbwkGWWexp4OEHO44lpTtu0ImJ3YWOn8oSh2bYPTvqMBfypZlsK1F7q3enNGS2uaUH7xPUg5uEpbx+lyW77voCJ5z92KGaAJSmTYyXl8+My6QDyA5g0+r4URvY70WmdiRqJkZVWsKdpLRHBz/M9jCPyqNUrHYgmfaCLtTtyNjm6OdJJ6BOY5/807QT6AMzuc2v2aeU9uMVNNdNc3l/eisvjdRoQoZhZiCCmkVbfICRYWs37rOcpnGev7wLtrq2Ka4XT0RGNtbFDHSnFI13YFSv/f9r1uakbqeMHlukftG2tyvYUDjhQTxZFomcmGY5QFs0ACaMJh860hlxnf0zAcTOrJCZlMvM4USnPq658geTe7ffBxkE/pgDZavxicOAw9mXQfqH9/ryvEF/M1rjP0vJvlcpFvFbk6NHVdbpf4nDL+s3UATNq2ELe12ddev0/lreNxT6Dvt9Er4ArWTbcwuKZjTFbcMDL8XIsPGSN75YcMoqUb7+Nztmo1TCqb37xmw+qJMZjE6QxcSg1VfXaDOCFdaH0G48bp0GqCk6mwD9Ym91CYG3ZEYsloy+eDY4t5BzAxNLfakbG595VeUuJqSspvxJItCVaQqkNzfjczhNjhyCqopOhb9u+8bgfdxga7WVZera0tBYSNdNsVGcUjW88h02Xyfrk13bZCa89lGq6S5fw80lWQyyVr7Q5eUTmLJx2h6MO5BDE0OEJyMdFy/KEisuAPoscmrrkrPtNij06guHHMXuAMcGQtAi7oHRbW5WwApnvItMAoOvVvX5Ccte1QsxxgTR1bKGHDpKo3x+XYxLkr4L+Hwfdt/1jPC5kNBaTO21CHS5QFhailv/HA9V3iIJYkwD1/OAWJDqM+Sos/SDbi700b1WICxlCKpANwWrKndXmR3BH+w9pTdS9TQN8Onh2dP16daDc3DM
 pDpz7f/i
 JqtIB5pw+gFDFJ+ajw9ADUPv7hMns3m556TbYWc70JFYxWCM08nYlvIf9/0PT6p85JZ5gJbaSpxm0hnocGMSmF2QwrnmzzNREgkXydKzznQQyq/vnFBug18WKKPuHkbhvHjD8yFtjmQS8e04ggZdtuP5+Je2mGRhvE/8klG4TriaHn/hF1tBP8xM6L+CdUmBRuDIwiH2OvxTIHpxJ5MH3wkMqCMdHzt+0yfn57Zr10QbadVdm3y0GN12WbVRu77cSFnK2H5DUsL3D/TFA0oGjzJWmFHzqEXi9EqUKHWsZB7tfXgty1GT92Pg2G7e20ncO6oYgdxL0ubERJco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 12:16=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/9/26 20:28, Suren Baghdasaryan wrote:
> > On Wed, Sep 9, 2026 at 10:16=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 9/7/26 08:39, Suren Baghdasaryan wrote:
> >>> smap_gather_stats() interprets its start parameter to mean vma->vm_st=
art
> >>> when it's set to 0. Eliminate this special interpretation and pass
> >>> vma->vm_start explicitly when needed.
> >>>
> >>> Since smap_gather_stats() operates within a single VMA, we can replac=
e
> >>> walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
> >>> which is simpler and also can be called while holding per-VMA lock.
> >>>
> >>> No functional change intended.
> >>>
> >>> Suggested by: Lorenzo Stoakes <ljs@kernel.org>
> >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >>> ---
> >>>  fs/proc/task_mmu.c | 40 ++++++++++++++++++++++------------------
> >>>  1 file changed, 22 insertions(+), 18 deletions(-)
> >>>
> >>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> >>> index 9908ba32f180..3351decd1172 100644
> >>> --- a/fs/proc/task_mmu.c
> >>> +++ b/fs/proc/task_mmu.c
> >>> @@ -1246,20 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_pri=
vate *priv)
> >>>       return &smaps_shmem_walk_vma_lock_ops;
> >>>  }
> >>>
> >>> -/*
> >>> - * Gather mem stats from @vma with the indicated beginning
> >>> - * address @start, and keep them in @mss.
> >>> +/**
> >>> + * smap_gather_stats() - Gather mem stats from @vma.
> >>> + * @priv: proc maps private state.
> >>> + * @vma: The VMA to gather stats for.
> >>> + * @mss: The accumulated stats.
> >>> + * @start: The address from which to start.
> >>>   *
> >>> - * Use vm_start of @vma as the beginning address if @start is 0.
> >>> + * This gathers stats for the whole of the VMA unless the lock was d=
ropped
> >>> + * and VMA grew or got merged and we found it again, in which case w=
e only
> >>> + * gather stats for the remainder of the VMA range.
> >>>   */
> >>>  static void smap_gather_stats(struct proc_maps_private *priv,
> >>>                             struct vm_area_struct *vma,
> >>> -                           struct mem_size_stats *mss, unsigned long=
 start)
> >>> +                           struct mem_size_stats *mss,
> >>> +                           unsigned long start)
> >>>  {
> >>>       const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv);
> >>> +     const bool is_partial =3D start > vma->vm_start;
> >>>
> >>>       /* Invalid start */
> >>> -     if (start >=3D vma->vm_end)
> >>> +     if (start < vma->vm_start || start >=3D vma->vm_end)
> >>>               return;
> >>>
> >>>       if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> >>> @@ -1279,20 +1286,17 @@ static void smap_gather_stats(struct proc_map=
s_private *priv,
> >>>                * Unless we know that the shmem object (or the part ma=
pped by
> >>>                * our VMA) has no swapped out pages at all.
> >>>                */
> >>> -             unsigned long shmem_swapped =3D shmem_swap_usage(vma);
> >>> +             const unsigned long shmem_swapped =3D shmem_swap_usage(=
vma);
> >>> +             const bool shared_or_ro =3D vma_test(vma, VMA_SHARED_BI=
T) ||
> >>> +                                       !vma_test(vma, VMA_WRITE_BIT)=
;
> >>>
> >>> -             if (!start && (!shmem_swapped || (vma->vm_flags & VM_SH=
ARED) ||
> >>> -                                     !(vma->vm_flags & VM_WRITE))) {
> >>> +             if (!is_partial && (!shmem_swapped || shared_or_ro))
> >>>                       mss->swap +=3D shmem_swapped;
> >>> -             } else {
> >>> +             else
> >>>                       ops =3D get_smaps_shmem_walk_ops(priv);
> >>> -             }
> >>
> >> Horrible, horrible code, really. But not your fault :)
> >>
> >> I think we can just make the shared_or_ro less odd by just checking fo=
r cow
> >> mappings (as described in the comment).
> >>
> >>         const bool is_cow =3D vma_is_cow_mapping(vma);
> >>
> >> ...
> >>
> >>         if (is_partial || (shmem_swapped && is_cow))
> >>                 ops =3D get_smaps_shmem_walk_ops(priv);
> >>         else
> >>                 mss->swap +=3D shmem_swapped;
> >>
> >> That's almost in a form that I could understand what's happening.
> >
> > Hmm. So, are you saying that !is_cow always implies shared_or_ro? Or
> > maybe you are stating that vma_is_cow_mapping() was the actual intent
> > here?
>
> So the comment says:
>
> "For private writable mappings, we might have COW pages that  .."
>
> Which translates to:
>
>         private writable =3D=3D vma_is_cow_mapping()

Ok, just want to make sure I'm not missing something subtle.

>
> >
> > shared_or_ro =3D VMA_SHARED_BIT || !VMA_WRITE_BIT
> >
> > is_cow =3D !VMA_SHARED_BIT && VMA_MAYWRITE_BIT
> > !is_cow =3D VMA_SHARED_BIT || !VMA_MAYWRITE_BIT
> >
> > so, !is_cow would impy shared_or_ro only if !VMA_MAYWRITE_BIT always
> > implies !VMA_WRITE_BIT. But I think it's possible to have a VMA that
> > has VMA_WRITE_BIT but not VMA_MAYWRITE_BIT, right?
>
> VMA_WRITE should imply VMA_MAYWRITE

Ah, good to know.

>
> (in sanitize_fault_flags() we even disallow write faults entirely if VM_M=
AYWRITE
> is missing)

I see.

>
> For example, a
> > driver can create such a VMA to allow writing to the VMA but to lock
> > its content once mprotect(PROT_READ) gets called.
>
> I don't think that would be valid for a driver to do. But it wouldn't mat=
ter
> here because
>
>         shmem_mapping(vma->vm_file->f_mapping)

I was obviously overthinking this :)

>
>
> I think we could simplify the comment as well to:
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e671b4fd8dedd..4b7e7089cafa7 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1303,12 +1303,10 @@ static void smap_gather_stats(struct proc_maps_pr=
ivate
> *priv,if (is_partial || (shmem_swapped && is_cow))
>
>         if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
>                 /*
> -                * For shared or readonly shmem mappings we know that all
> -                * swapped out pages belong to the shmem object, and we c=
an
> -                * obtain the swap value much more efficiently. For priva=
te
> -                * writable mappings, we might have COW pages that are
> -                * not affected by the parent swapped out pages of the sh=
mem
> -                * object, so we have to distinguish them during the page=
 walk.
> +                * In CoW mappings, we might have anon folios that are
> +                * independent of the shmem object. So fallback to the le=
ss
> +                * efficient mechanism in such mappings.
> +                *

Sounds good. Will update.

>                  * Unless we know that the shmem object (or the part mapp=
ed by
>                  * our VMA) has no swapped out pages at all.
>                  */
>
> --
> Cheers,
>
> David

