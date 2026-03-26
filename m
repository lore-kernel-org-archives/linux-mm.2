Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0D5D10A88FD
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 18:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 138C26B0089; Thu, 26 Mar 2026 14:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 110AA6B008A; Thu, 26 Mar 2026 14:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026776B008C; Thu, 26 Mar 2026 14:24:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E91B66B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:24:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57FF4C3F18
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:50 +0000 (UTC)
X-FDA: 84589040340.01.B3B9245
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id 482A3C0012
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DgE1oDlm;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774549488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQhGn+VUrLV0McNgTLWhQuOTcrsY+On/+03qmLT1CZw=;
	b=qpd2ttQi0Qp6113qx7R/6Gy25TpFo7h4EsJ5AACNmGJi78uQuRdCppw4XV/ZDII9YmAVQq
	pznVGh099/W1Nv8S1iuga/tSC5YQi0QmL/BsfhKZmtUUsReIm9Laae363op0bA7W7i2RhI
	smKXLTDOmjPt4nyJuTa6xRRnwef9X6c=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DgE1oDlm;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774549488; a=rsa-sha256;
	cv=pass;
	b=34nLB5XO2wp7Vt8ISb3u2fRfK31CRtIMw6MgbqAcrI9HiVAq3xTrnsggCdAfOkD3fGM3gh
	LUb1SnjlJF52BKjhb0UseUeZfqUeXo2Tv1LSkWiQ7+5zr4O1JMg/Mbzl/hQhWFVSO9K4Nf
	q3J9uJWizqIyXMuXaaJaTJPJrTbWfDk=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50b6c45781aso88351cf.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:24:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774549487; cv=none;
        d=google.com; s=arc-20240605;
        b=cgAeXFtdZUg+M/4XggnvaTot0hltFaTw7mEnZ0sLMOps7FB3g3LneiXCa2wUY2MPmt
         rL/BVKBwpkKSlAFiK4b9tgE0oWPdoe3TGEzokp0zbxW6kTcIHnOznim0fVLT0FcnAlIk
         aYrJntdfoA/TMFpwotfWxq1OaXlGDH8DwTsZ/DzheOi/NRLw66K0VOwJ9/VrS8XcUSSh
         lof9sPNJSV59ItH8nexEtG8840j5HyXwZo8GHCCP+QIScz0UoWNnJCzCAspFarrz0ghG
         EA4hZgoODH7P6ZcJh53gdKnujT/Uo8RogXBJPjfvhIUFWupP++cp81GUqKxQBo9A6Uox
         DCKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dQhGn+VUrLV0McNgTLWhQuOTcrsY+On/+03qmLT1CZw=;
        fh=MtEFVqBzCkI0Cd4GX7aLBGTHs8JSQVvUoAPQ6MYtUPU=;
        b=ksQS0MyjK4C9n7ds/2bKcrBSOcjXHiLQ5+i4db/kYdfVU/4q7nO8o59Y2h2DHWT44L
         1achfSS2aBEuQi5ozxzwhnEBr6aNOyJ6vozmYPVRkBYaiw36JdyFVomdbygaboNRtQk4
         K0WswQ0QIaooKcZ3Kp2Gqp6PrMJlCCkeMpFfhNDWjVOX4/fOttcI3+L38RGh0tyaxyEw
         nk9MOrzBvGXRUOnVoEDJovxbdYcsyJYLmWHmtlz8XN+nySCRuo7p1zuNZxlMHdeY3IX9
         2SdpYXp5AMgS06BiIxyKw2k30J1TRR3v2L6R+G0rbp1jgA/HN1lIsmxI7AWpxkID4e05
         NmSw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774549487; x=1775154287; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQhGn+VUrLV0McNgTLWhQuOTcrsY+On/+03qmLT1CZw=;
        b=DgE1oDlmYRp+IM/xpY6kPfFStKsLhWVi1lytrG2rIy0IPHwMAxIMFAs4Dyfb26QsY+
         p6NKhh2gNgFq/vQoeIr462lyhxwgqYCjvslCo23XIrtTDCcIhfxDzf4X35pEoKkHtijH
         Y88im3g14D5Oqb/n3jEaCjOPll0HkedaMr3bSrKZ7AfpuyiKc3BKkQ/1VfUflJt2QVhi
         YnVRmdJdPlrdVvgmsZq6C0a2RL7NTjrlLb7ssi6lR+XDqVA6sH9a+ecvRahQX/aLO0w5
         SZ286r8aK0ODLLBCzbROukjYbmUj00IUJD7nzjwN98yP0x4fJJpReNHCcUAUIANpzQ4i
         EU+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774549487; x=1775154287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dQhGn+VUrLV0McNgTLWhQuOTcrsY+On/+03qmLT1CZw=;
        b=f8ogVzyls+XZPyzjURbAqOrBmi9eEdDtkQ9LgWf/ZtTMIY63hlVXiuLU534voVQeXR
         hbX2CrKpcCJj6QP+4LLh69UqDgsyWRfFTDSYmzLTThaha9IniFCQHq8+URNJmOXPqx2E
         Wm7is4Pc9SDZzckR4MO0sKJCtifTg7g5W6rLScvWTMuBwvv7IZoPM5Kw7st+3W2kjsqm
         zF/uvVyclz/rk4mDtwsg3meIbYU+15TAGHG61cnBNT7fY+UOQSz+Mo6vLaDDUm/prD1E
         wQSLgW/h5jHf03rF7ZbPQJxx2soPzIyieFdn8KjP4mg0K0Wv6NB6ojdQgpcnDYQjJhln
         QbWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRHR/XkdfweCa1ldyouh87Nnpi5dWhyh2JHkjvn965E2YSl1FgeepmgKq1sTxsKV/bjI2eYn/8xQ==@kvack.org
X-Gm-Message-State: AOJu0YxW81G6SMKb4HJEZFFuTnsZxOgQ9102Cny7VK9BY2sdwWPwbCOC
	GhxVJc5p6R4PJvlE9JRUIXlp/s1gR8L5BFvy7+xC0iQ1EhNgSHDjN5Rt05kGvhyehk7KLOj2ZYa
	J8C6bhBHASCkGLAvuqs5LmIwSYu99GaA6B4E3AoIU
X-Gm-Gg: ATEYQzyqOSm4JCFuFuVsb5w3ckm6fPY/JJYFCA+584Uk+QgXjU7dL+sW6oZVUUbrSgd
	G2wBBniMKt6wlA0wTtbh5IHF9Md3qTVkwYzrR6sfpGvVu80nBP5SFJqFZE9ZG5K2BpSgN8S08vJ
	J8wUQnuDUP5UthFmbtda+eLqBxkI0wTShN9/pgSoTIbWPQoUv1T+T75pxK6Ym3Q9mYtDSwM8vd4
	QPpovGB47wh5je7LuxjlRev9VDSat5QgvRcx3ykOAvbyiXnSUz4s45Tomm7hacA4/2uiq1pTixr
	95AHeOYPxujhLdTLqZlCKXzJlZ28uhO8mg==
X-Received: by 2002:a05:622a:93:b0:50b:71e4:878c with SMTP id
 d75a77b69052e-50ba1e41c39mr1037271cf.15.1774549486349; Thu, 26 Mar 2026
 11:24:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260326080836.695207-1-surenb@google.com> <44216135-ce6e-4c06-acf9-af09e224ddd8@lucifer.local>
In-Reply-To: <44216135-ce6e-4c06-acf9-af09e224ddd8@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 26 Mar 2026 11:24:35 -0700
X-Gm-Features: AQROBzDeN__PRe-Y7mIO9LZxPL3s1KNrdWWWOsbo7He0DKFlde5Dab9lnrvUpiU
Message-ID: <CAJuCfpG_xa5nxSRrvu4TnwhCrmocPkHpWEQbE_yeyN3L69Y6tQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] Use killable vma write locking in most places
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: aopq4f3jjd1yrq18nbtpanrkjwxk37km
X-Rspamd-Queue-Id: 482A3C0012
X-Rspamd-Server: rspam09
X-HE-Tag: 1774549488-410177
X-HE-Meta: U2FsdGVkX1/iRi47+VsGCzJE3NZP8+gxsy2avBWt6gNVvCDhC5MwT3jkO3D2E2HNEsaUW7yLP/++t1/tQzkaY80HhOQzFR86V8aKF/Kz6+LRVkJr5K+rMo22eIdiB3ouPdHFT20MLvEDiK0owZyfNrxOq0hIHBM3T2q13Dsr82IeeRvS3D8KYTcRA7mrd7WktMWJHjgcwNzc2i5xKT7VnIITJsPLVRIAl+e0DoibFJLyG1eEKtKZToD2N+IWhALexf7F+Y2Q9fl/3S0k67YBkJKcOH0FsOLRIl6mjzzUKKjVjAp7S/FYxhMFisgWRwl8oRl+X7U/65YltVhscfUlauL5mgwaGcWpGFF0Usbu8Lg2ddl+H2i5n6uRwe9lLLlR4NQL58x6rTuc/SNrCJrrT/+9lIbi3EQ3iR7qMEA1jxWmCHIoytknKx7PDUQRWPynh4fmrJd6jiwn6mwHNHN5i++OJt4oh2M4Je8GkJpHTZDQqtRAcILxxlc9fwX45Sgri5JmGQa6Ol7Wex2GGcwQDaeFG3jjL5KFITtN8IMvuSunLjGnf2hRGWc3vqYk5tFf9mReXbkShKQf1HMAFoszXiwmFayX/ems4MKwz4xWvm6MQdEtO/8/x8rh1zwRZKvQDxxbB3q0vQbxtw3k2jWoF+RC/oaMHbLn9r56glv8I7EP1l7XoGvyQRKHwrnkQURMFjYTVxRxze3Lz7WfbxFDCZnwSCoBJxAxrc+jkp7QHoXJh31mNnpyQ+vlonA8TMUT7aAVY8pgkeghvPKeS0InfpN6A4JwjBct2Ih6KGlqKo5D62X2a6yPvJP36MyrveTQL3Y49KcYL4rgBf/oQ7Bcmh7kQjhzqtsWJrHW2YDgFHMUwtUj18yFvO8adOQUrSWbsp2Ral24Bjtt+v/IvKAKPeTnmWDcDBA3Cn57b7nS/PgbdipgwXpa+BBNpuwmVosaGOlXnIca+mfalK3y1IW
 E08pHvhc
 iWoszgVx6BhHVS8apXYhV3kRiKNIkPc0KRtpWp2bNxlzK5M3TVQ3NXRY7Qo2hKGtsKHdH0Ih29drqMcJO03T2Nkz0gxjTmcV66vin7WR/daCXQZsXNw1FFM4Bns160IUpsfiO0YScAcv8HXRnapmG1E9qGpVhFe0R9gEiuHv2XyEx/bkvh3xSTkX0/OY2AD6D5jeWuwZTZGvuRWtIo1D7TLvaYBf2PUhbMc5S78pbAd7vWARXLZeiKUaD2lkVT4hgR0Gw64qtIcDc96f2UM5GbOc3RGDp6hEI04++ekhccuaQ4HX5Ft1LniLo4lJyX4zXIM0kdoikVtvDfpkYcdaayu42yr2q4vZ1UqkC6vir6uJxcuY2l4cru6U6zkdA50TBP6/PKDxEGRlq7jmSCrOam2i0pwBhYfCmhW0R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 2:18=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> -cc old email
>
> (Gentle reminder to please send all new stuff to ljs@kernel.org - at some
> point I'm going to set a rule to ignore kernel mail sent to the old addre=
ss
> so, if you need a response you should send to the new :)

Ack, sorry about that and thanks for all the reviews, Lorenzo!

I noticed Sashiko's concerns at [1] and a number of them are false
positives but I see at least one new claim which might be legit. I'll
check if it holds water.

[1] https://sashiko.dev/#/patchset/20260326080836.695207-1-surenb%40google.=
com

>
>
> On Thu, Mar 26, 2026 at 01:08:30AM -0700, Suren Baghdasaryan wrote:
> > Now that we have vma_start_write_killable() we can replace most of the
> > vma_start_write() calls with it, improving reaction time to the kill
> > signal.
> >
> > There are several places which are left untouched by this patchset:
> >
> > 1. free_pgtables() because function should free page tables even if a
> > fatal signal is pending.
> >
> > 2. userfaultd code, where some paths calling vma_start_write() can
> > handle EINTR and some can't without a deeper code refactoring.
> >
> > 3. mpol_rebind_mm() which is used by cpusset controller for migrations
> > and operates on a remote mm. Incomplete operations here would result
> > in an inconsistent cgroup state.
> >
> > 4. vm_flags_{set|mod|clear} require refactoring that involves moving
> > vma_start_write() out of these functions and replacing it with
> > vma_assert_write_locked(), then callers of these functions should
> > lock the vma themselves using vma_start_write_killable() whenever
> > possible.
> >
> > Changes since v4 [1]:
> > - added Reviewed-by, per Barry Song and Lorenzo Stoakes (wherever the c=
ode
> > stayed the same)
> > - split patch 2 into 3 parts, per Lorenzo Stoakes
> > - converted vma_start_write() in mseal_apply(), per Sashiko
> > - changed vma_start_write_killable() error handling in
> > set_mempolicy_home_node(), per Lorenzo Stoakes
> > - added comment why mm->locked_vm is fine even when we exit early,
> > per Sashiko
> > - moved vma locking before vrm_calc_charge() in move_vma(), per Sashiko
> > and Lorenzo Stoakes
> > - set give_up_on_oom on error in vma_merge_existing_range() to propagat=
e
> > the error, per Lorenzo Stoakes
> > - moved validate_mm() out of the error path in expand_upwards(),
> > per Lorenzo Stoakes
> > - dropped the patch changing S390 error handling, per Sashiko and
> > Lorenzo Stoakes
> > - reworked error handling in clear_refs_write(), per Lorenzo Stoakes
> > - uninlined process_vma_walk_lock() while changing its return type,
> > per Lorenzo Stoakes
> >
> > [1] https://lore.kernel.org/all/20260322054309.898214-1-surenb@google.c=
om/
> >
> > Suren Baghdasaryan (6):
> >   mm/vma: cleanup error handling path in vma_expand()
> >   mm: use vma_start_write_killable() in mm syscalls
> >   mm/khugepaged: use vma_start_write_killable() in collapse_huge_page()
> >   mm/vma: use vma_start_write_killable() in vma operations
> >   mm: use vma_start_write_killable() in process_vma_walk_lock()
> >   KVM: PPC: use vma_start_write_killable() in
> >     kvmppc_memslot_page_merge()
> >
> >  arch/powerpc/kvm/book3s_hv_uvmem.c |   5 +-
> >  fs/proc/task_mmu.c                 |  12 +--
> >  mm/khugepaged.c                    |   5 +-
> >  mm/madvise.c                       |   4 +-
> >  mm/memory.c                        |   2 +
> >  mm/mempolicy.c                     |  12 ++-
> >  mm/mlock.c                         |  28 ++++--
> >  mm/mprotect.c                      |   5 +-
> >  mm/mremap.c                        |   8 +-
> >  mm/mseal.c                         |   5 +-
> >  mm/pagewalk.c                      |  22 +++--
> >  mm/vma.c                           | 146 +++++++++++++++++++++--------
> >  mm/vma_exec.c                      |   6 +-
> >  13 files changed, 190 insertions(+), 70 deletions(-)
> >
> >
> > base-commit: e53c9040ab1b738dd2c83b57558f141902caaf4f
> > --
> > 2.53.0.1018.g2bb0e51243-goog
> >

