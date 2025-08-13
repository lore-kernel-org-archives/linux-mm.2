Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B891ECA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3213E900093; Wed, 13 Aug 2025 10:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1BA900088; Wed, 13 Aug 2025 10:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A4F900093; Wed, 13 Aug 2025 10:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06264900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:12:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB67682B6E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:12:16 +0000 (UTC)
X-FDA: 83771923872.03.1D0A33E
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id B8DEF120016
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:12:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ogrphBiE;
	spf=pass (imf29.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755094334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkjlqmLiRBxptQz45vn5dg0H17v0dA1AGcg91Qnwr4k=;
	b=WKmV6RDcDIqaVy59OI/sEnNxUm4zPfzELAM83rGHyWDpvJdhjLv0tuQehoBYxJxhLsOO+n
	BIWMENmaq0CUvSaq7SPZ6aFqfNPZ/nxX/x6eGht2qglcFiVbeLcJaYhVhBiZbs0w3tPdn4
	uhP4Pl6UvUX7Oa29gAEpCq3fzWcZIi0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ogrphBiE;
	spf=pass (imf29.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755094334; a=rsa-sha256;
	cv=none;
	b=KIX0vzmtjbN16UIQHTlREIy6Kp+8DIutpHE0drtRIg503q6J+oVZ0D5E4ZlexPh/P1+sDq
	7QcRbkA4uPaCZI4bCutLkLUB8Xu1CwIxcByPgsbzEMWM3wtFrVUvkFR+svINmoy7FGwRh/
	KqXzByumWFXv1/9XKQgtmhBdh+CPfe8=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-618076fd48bso8922a12.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755094333; x=1755699133; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fkjlqmLiRBxptQz45vn5dg0H17v0dA1AGcg91Qnwr4k=;
        b=ogrphBiEtJJP/3S0XuDBnWAJ1dsddpQ63iBtL/E+0FBg5oUFUixbIJgSGsUn+xsjKl
         ZI/I2vONrX24z5XGizc63Oq86WGQYtoq01MC9H43on8obzZsu372yu6rHyxUeHadGk5f
         Ye9UDtBNynJgjXUjDDN10yTShfIVqs/dWqvTfM1V0haTndcFDX1rRHVv8DOPG+J1L+SV
         z5zhY58AMUUE73xL8lwu2PBP6zizAHLuGx+kHE3JYRmrF33LXxhMqSwu4dHWBbC3DQYA
         /SAy05yAoZs+VKiSf9hWCTeXVON7yqFkmzpfFx4NzBlSh6up5afe23MdQNHAU3CwYZH4
         FToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755094333; x=1755699133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fkjlqmLiRBxptQz45vn5dg0H17v0dA1AGcg91Qnwr4k=;
        b=RkSwwujts/G48jI96Y9ganXgzqTZEe0WqTV/mzVm5YzS4BF4jNxgAAi6KPAY9r1AxI
         cPVs67W79vsAroW3uF3SWIW7mnxVkQMxSWLHhdkNFrjTy6oqRgjnTTsqgy0KJDH+nykK
         f8YSdOC1msKwBlv5VSB8I1Gth4TbrpVf4IsFdbzgWb5knV308MNJA+14WflRCuAiLhp4
         7xds3xdL/E5cr8DGDgLOQwowpChiZePyS1hYnanHdf8XdbysxDRs7gbf6GP3npIsrQs2
         Fw65zDqnKI+rbQ+A/so4W+2KDPeN5ZmbOoyMT+LXQOuLtVLp0OgZy7V1BWNiMeZf10eg
         jfRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdXnooj4ya+3HKdxO2Rxa+G819cstqp/9gUWt4ZQvZtAmF8NxJJ+1tw14VvDL/qg30jtNAICPzBw==@kvack.org
X-Gm-Message-State: AOJu0Yz2+tP403dxx4yBcKqs0bl7fwV0r14bTzBSCRpEBhYOT2jfq/uw
	P6NN2+GbGzgHG5Z3LpRiNcA+1y/Q3xLCVYwE4PNfIYoqIA0CJIWeorqdbm8wQON94UK6GhxHRJ/
	zxoZXjxPx28ucJjoVFMPogIajtEBBFghn8yjC5QYt
X-Gm-Gg: ASbGnctsdUGljipXCc8FsmKxZt0Djlp9c5V0E4xUjxc2WkdKeGgg2hEluNmEcUfwe+R
	zcZYc3COGRzH0Q/JDOdvZl4AUHoZzsKCwd0Lnk5GvX7ZatAjPbom/EDBfcuwna4LcPyXXpuYQtP
	HN6ld+5e4NknVBcIIQnx4oiyd9O/MuNnW6g9p/cdEbeSbxlETH5oJGE6QxmEzBWPk5e7LatKcZA
	zGEUGi3UqFhdDPdWayCKxVkDtnyCu4CyKCU/d8bLnpeyOF4naM=
X-Google-Smtp-Source: AGHT+IHpsS1eTrEGvR3363fwaPPMu7U8npszqW0lvxFFfHbG1gOFWCGxufRpUJ4UlBdSmonQQ+VW78cKaBNDy1C+O7c=
X-Received: by 2002:a05:6402:24d4:b0:615:5ae7:a3ae with SMTP id
 4fb4d7f45d1cf-6186d539fd8mr72219a12.1.1755094332952; Wed, 13 Aug 2025
 07:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250810062912.1096815-1-lokeshgidra@google.com>
 <CAGsJ_4wbXkfaAn+79g20SfE-0Ak4QACVP+Mw2vAvMnxBCcLAsQ@mail.gmail.com>
 <aJtTPkenKeFuFFNQ@x1.local> <CA+EESO763JtY3jjmgGGbJjSQcnJJFNpDs2iPaUwjP44VpyyzdQ@mail.gmail.com>
 <CAGsJ_4y98H-8aK9r_5YrSPV=SCU=-rZf7YPMz32K0C8oFnUCNA@mail.gmail.com>
In-Reply-To: <CAGsJ_4y98H-8aK9r_5YrSPV=SCU=-rZf7YPMz32K0C8oFnUCNA@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Wed, 13 Aug 2025 07:12:00 -0700
X-Gm-Features: Ac12FXy7s_4dlzUn7ZVKxVS4OWNMJRiZRK02IquoT5AygK6YYxLLICI9IgH2TEg
Message-ID: <CA+EESO7ddhP-7tkkPUgusNjtyekx7HhJijKuJid1pLh0Z31kJQ@mail.gmail.com>
Subject: Re: [PATCH v4] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Barry Song <21cnbao@gmail.com>
Cc: Peter Xu <peterx@redhat.com>, akpm@linux-foundation.org, aarcange@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B8DEF120016
X-Rspam-User: 
X-Stat-Signature: r1dgpsajsim9fh5qomdatr9c34dszurp
X-Rspamd-Server: rspam09
X-HE-Tag: 1755094334-400565
X-HE-Meta: U2FsdGVkX1/Dhe+fvhzPGnTqlkGUbtEyMKlp+AdRa2qWJ09DCzjqY9pFFbCkBHnCFI8nhrHb/0xriM909wAClqZRmrPDvMDSUnD3EYsKq2g4eeY7xHOtfQO65NCijm5BOMMwKUoCvXD3FT0YeJ17g8y3tU6EGvflSRmtxOmQ819+6su/D/D4wf3EAUjeoAyHNdNxMhn3saTOh6rPDG4j5j74Q9raewwoOnDbY1cjo1fSHAzoHDmwvHCe/P40VQBxoxCXFa6+BB6ki6lHKvYQ3LByF1+JmgEhKtC34X+4mpPkJzau47DmpGQQcsnPAfOF/xVysCipslWzF+jYUb0CfcHD5OlU5WDnKwgqH/6oUanqc41PEcov3WDMfL0k4xmHyaVulG2hud4Q6U4vyjr5APQNTvxbpgqVI5/F5SuiZ9AtVhwPJh/aLzBqRjVhFZnsU/+5cStxaqQ6EI1IYTbIYsppeG+zaCKH++b4eOnac3AatpKGRYq9+4aT83WYnqj6APt2dDehMPMslxI8Ern5GVRJzbRWL8hyZJmn57gbt8cLCJlAG963T5YNq3rUIHutVLckUlr1P75gHKT432Iey5XEDdDeYuFUtRalUYP+C1ufBzN43QXMq2D8wey88NfSoyXL7mNWPYV1pDyBgp3FCBN82MRYPOi17uhgPSXZi7vFofoxD3dhOFj7opsoArPl1Kl85BV9eOm760Gy43JnrEnACE2RX/mZveYqd/zjiu4NRljhKpGVy99HEcgnD0zCpMu/ZMk3Oe8trIvzuJKNJJiSjlQ+fPzWWCQ3YzNdm+VrDE7/u02xcPlMOUVJGTftI1n0ETp56mchF6dgWq0qhoIjtWtWi52sd7KjFbfJAdTrSfSOp2VdbO4YgydQY78zZ+Zzd9XSomQ9BvtOQ1Di4pBnjeI8+IT8B/LElp2eHj6CKNJ7xtwbvKZwG1VuYTfiTIaFtd8drX6ZxzleerR
 h6Pyfju7
 Fh6qMcV997imLzU/3X5VeDQ6AngkL90XMuH5DN2Q7pRcYF3GKUR5dXXb1Vg331d1h64URSlXbF0M/SBW4r0AjxIgXwm95wyDNOTWkVJRElh7rCL2jGB8pEk9eJDsuJ5UivP0mTlzQk9DNi2DfHMf/IARAdrJvY/fFcN9a0bKpRqzosBc2JlGCxVc3IE8P3t0VmrTxosDbiCd616Xd/5BrOG8v9htKlvqi2HYmSZY6qqRMz2NePFViq3XHorpUCj7D6Yi54mKjjo4UCeI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 2:03=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Tue, Aug 12, 2025 at 11:44=E2=80=AFPM Lokesh Gidra <lokeshgidra@google=
.com> wrote:
> >
> > On Tue, Aug 12, 2025 at 7:44=E2=80=AFAM Peter Xu <peterx@redhat.com> wr=
ote:
> > >
> > > On Mon, Aug 11, 2025 at 11:55:36AM +0800, Barry Song wrote:
> > > > Hi Lokesh,
> [...]
> > > > >
> > > > >  mm/userfaultfd.c | 178 +++++++++++++++++++++++++++++++++--------=
------
> > > > >  1 file changed, 127 insertions(+), 51 deletions(-)
> > > > >
> > > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > > > index cbed91b09640..39d81d2972db 100644
> > > > > --- a/mm/userfaultfd.c
> > > > > +++ b/mm/userfaultfd.c
> > > > > @@ -1026,18 +1026,64 @@ static inline bool is_pte_pages_stable(pt=
e_t *dst_pte, pte_t *src_pte,
> > > > >                pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
> > > > >  }
> > > > >
> > > > > -static int move_present_pte(struct mm_struct *mm,
> > > > > -                           struct vm_area_struct *dst_vma,
> > > > > -                           struct vm_area_struct *src_vma,
> > > > > -                           unsigned long dst_addr, unsigned long=
 src_addr,
> > > > > -                           pte_t *dst_pte, pte_t *src_pte,
> > > > > -                           pte_t orig_dst_pte, pte_t orig_src_pt=
e,
> > > > > -                           pmd_t *dst_pmd, pmd_t dst_pmdval,
> > > > > -                           spinlock_t *dst_ptl, spinlock_t *src_=
ptl,
> > > > > -                           struct folio *src_folio)
> > > > > +/*
> > > > > + * Checks if the two ptes and the corresponding folio are eligib=
le for batched
> > > > > + * move. If so, then returns pointer to the locked folio. Otherw=
ise, returns NULL.
> > > > > + *
> > > > > + * NOTE: folio's reference is not required as the whole operatio=
n is within
> > > > > + * PTL's critical section.
> > > > > + */
> > > > > +static struct folio *check_ptes_for_batched_move(struct vm_area_=
struct *src_vma,
> > > > > +                                                unsigned long sr=
c_addr,
> > > > > +                                                pte_t *src_pte, =
pte_t *dst_pte,
> > > > > +                                                struct anon_vma =
*src_anon_vma)
> > > > > +{
> > > > > +       pte_t orig_dst_pte, orig_src_pte;
> > > > > +       struct folio *folio;
> > > > > +
> > > > > +       orig_dst_pte =3D ptep_get(dst_pte);
> > > > > +       if (!pte_none(orig_dst_pte))
> > > > > +               return NULL;
> > > > > +
> > > > > +       orig_src_pte =3D ptep_get(src_pte);
> > > > > +       if (!pte_present(orig_src_pte) || is_zero_pfn(pte_pfn(ori=
g_src_pte)))
> > > > > +               return NULL;
> > > > > +
> > > > > +       folio =3D vm_normal_folio(src_vma, src_addr, orig_src_pte=
);
> > > > > +       if (!folio || !folio_trylock(folio))
> > > > > +               return NULL;
> > > > > +       if (!PageAnonExclusive(&folio->page) || folio_test_large(=
folio) ||
> > > > > +           folio_anon_vma(folio) !=3D src_anon_vma) {
> > > > > +               folio_unlock(folio);
> > > > > +               return NULL;
> > > > > +       }
> > > > > +       return folio;
> > > > > +}
> > > > > +
> > > >
> > > > I=E2=80=99m still quite confused by the code. Before move_present_p=
tes(), we=E2=80=99ve
> > > > already performed all the checks=E2=80=94pte_same(), vm_normal_foli=
o(),
> > > > folio_trylock(), folio_test_large(), folio_get_anon_vma(),
> > > > and anon_vma_lock_write()=E2=80=94at least for the first PTE. Now w=
e=E2=80=99re
> > > > duplicating them again for all PTEs. Does this mean we=E2=80=99re d=
oing those
> > > > operations for the first PTE twice? It feels like the old non-batch=
 check
> > > > code should be removed?
> > >
> > > This function should only start to work on the 2nd (or more) continuo=
us
> > > ptes to move within the same pgtable lock held.  We'll still need the
> > > original path because that was sleepable, this one isn't, and it's on=
ly
> > > best-effort fast path only. E.g. if trylock() fails above, it would
> > > fallback to the slow path.
> > >
> > Thanks Peter. I was about to give exactly the same reasoning :)
>
> Apologies, I overlooked this part:
>                 src_addr +=3D PAGE_SIZE;
>                 if (src_addr =3D=3D addr_end)
>                         break;
>                 dst_addr +=3D PAGE_SIZE;
>                 dst_pte++;
>                 src_pte++;
>                 folio_unlock(src_folio);
>                 src_folio =3D check_ptes_for_batched_move(src_vma,
> src_addr, src_pte,
>                                                         dst_pte, src_anon=
_vma);
>
> I still find this a little tricky to follow =E2=80=94 couldn=E2=80=99t we=
 just handle it
> like the other batched cases:
>
> static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>                         struct page_vma_mapped_walk *pvmw,
>                         enum ttu_flags flags, pte_t pte)
>
> We pass the first PTE and use a function to determine how many PTEs we
> can batch together. That way, we don=E2=80=99t need a special path for th=
e first
> PTE.
>
> I guess the challenge is that the first PTE needs to handle
> split_folio(), folio_trylock() with -EAGAIN, and
> anon_vma_trylock_write(), while the other PTEs don=E2=80=99t?

That's right. We need to keep the complicated dance in
move_pages_pte(). That's why, unfortunately, we can't unify the way
you are hoping.
>
> If so, could we add a clear comment explaining that move_present_ptes()
> moves PTEs that share the same anon_vma as the first PTE, are not large
> folios, and can successfully take folio_trylock()?
> If this condition isn=E2=80=99t met, the batch stops.

Certainly. I'll add a description comment for move_present_ptes() to
explain this.
>
> Thanks
> Barry

