Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D676FC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 19:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D76D6B007B; Tue, 21 Jul 2026 15:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888A46B008A; Tue, 21 Jul 2026 15:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7782F6B008C; Tue, 21 Jul 2026 15:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 475806B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:39:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1E3080295
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:39:29 +0000 (UTC)
X-FDA: 85013798058.14.F65EF5A
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id C0B7D1C0003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:39:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i9qtPfpE;
	spf=pass (imf21.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784662767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCbW+hyT0YYJ59cHhMMtVWtYX3c54CsBcbRYDK3kPr0=;
	b=c8TbfehF6IOkvUQhnodVRlodK5D5J67LAD6MccE87oukB7XWmHVwv8eRJMAZgQH3ujc90A
	3vtD4eEyQP2348KCBdz3ywBd6q7fY/wBQNjxXl5OcblobKnFmDjKPWnxUedYoIKKhmv0Rl
	h8lKKWsD2D7nhj+hYLC8E8g7ElnNgyg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784662767;
	b=Uvs/rpR6DRmhu+uEcSTOjnZ3KwPSX1ERM5VJbamLffnkXQ3j9jgfXKas/MKY8NSv4pmruV
	BO55nl2JtSqyy4ubbTszEg0ZF3/VogNm/1YtaTBV/92gbFuEqMrMWnrC9N0/RG2n+uwW4M
	AsbJpvDpl3TgT/Q1T8GL+P7pRkHPGnM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i9qtPfpE;
	spf=pass (imf21.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cede6375caso495595ad.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:39:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784662767; cv=none;
        d=google.com; s=arc-20260327;
        b=OjekKUejdPahZt4Omjp1/1DeTqBg54i/Fp1J5dvoJore4cntwb+0299NQ/hnp81XEq
         dkRcrwmdFhy63XUPOnkQzzT0Ab+PsNuc0h9dJXgcQexkZ2eFd7Dfz9nNxz6q13RadHJt
         AxMFbfh+92QBAVn1+Ojzw1+gmIT6vFPyLFYN9/1C/nc0IzEVoBz5ij0+pslLHn6leRs4
         KUAJFkO4HkWbvDrEWr35uVgJe1+kt8bN6NlGsI4teO3CSGeolo8IkZwSKPjXOlk6j7SK
         ptDUvgM3TIhA5atnBFES3SE6om+lNSBb4RDjfyiLivQL1UEaIca9/u7goKU1to24JXkr
         YPGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yCbW+hyT0YYJ59cHhMMtVWtYX3c54CsBcbRYDK3kPr0=;
        fh=1rgaKnFjrYjpl64vLBok2o0fyewBIrgrT1+xX7DvP1w=;
        b=bCKn5umyGagb7mHdF9ZFikgUVcuPQwVE4X+agyS7yhyIyFzOIaz9qOUQcq2vP6FseQ
         RYxNmOzVDLDEFO18nxSA0oIqomZf0vOTJ9rrEpoj4VXXlFOWOopVCEmlDYw2AtD5C2XS
         7OsDJo/xXPcOB/rz6st+bdrTWLDpDeYWR6cNAibvMp16bh9FCnqcMGCGZdbBPBitpGin
         i+Llax5f0PTuWTK4J/RRfRnyHji2UUGA4/vSw1vqcoEjybc1vr336u+1TTn6VT6tRDBe
         MGh1P73Nx7ukZI8t8pNYVKtgjxpmuGuer8/c+uWG5xGV/LOCeJN8Er+O/fY6/DnF+3tj
         UPxQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784662767; x=1785267567; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yCbW+hyT0YYJ59cHhMMtVWtYX3c54CsBcbRYDK3kPr0=;
        b=i9qtPfpEDgmyCiB0l4Xy4cq/hNguT/mtAktZUPsLM+JrFi2JG4uAtjJ9rURv99DoWD
         BCCM/XsE5YcdfITlVNKW6s0X3+MTUu4Cn3I/SDziGkzEfMRoY47FWw5nQKFt8KndZvZq
         JDooR2E58B9MBgnaPAj0pht8L9HkBHCxY31bqOu6ajsigzKcMmhHDcac82QPtlp51u+7
         Lx+hZkI6WyAuLnZSM33kiF6fdopSejGcKgjRL21D6vKXow3nq8lCt95QdRE9agPz0Cum
         aGfQay8C4MyMCnyWJK9e/zynigkwkJu7iexGHyaqkGQym8BEUb+xAWPor3n0EtI+zqhY
         iAqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784662767; x=1785267567;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yCbW+hyT0YYJ59cHhMMtVWtYX3c54CsBcbRYDK3kPr0=;
        b=bk9D50NN0x9+oPO/DbM/y/Z0lxi+BPm9Fo15Z8cjah0UGITOSjAuqp+2LfNHEWLJRR
         DiA0ksq+eOYv7IS4i2mrZ8UeoMJRgwcarijCiLSNi57NIjoDTU3uR4Q4db3zqtLKD4M9
         tEH8CpTtNVlnMzl3Ii6arVA5FF/akfrRKYEut0IOMLEiybsSf4DnmX/kBARgjfioQyIN
         GReTso1vEr/zUcXyLE+utd1DywX8cwqm68wJd2+LxeRe5pSgdvr17qUszWsKe24ukTdp
         FpHZ8LAE3HIIr5qBBf3SPY27jg3WHPt+ONcam9nqD6D2GIbiuaFN7oRb+FxaC3Rwsr2h
         AwRQ==
X-Forwarded-Encrypted: i=1; AHgh+RrxY3jbF488yhjWTA2+Un2rCqA1KXzu3p7PJZOQoQO58bUXHNjK2TTvQ8hZ1h4kjzSyuXyIdo0IZA==@kvack.org
X-Gm-Message-State: AOJu0Yxoib1PAVswLDeYYcWCmANQEgHuMAhoOwq/XGdNzLmr3kGt3R0A
	JVE5GfgpzuH2J3dF8ZrEBFstMCdS5eiQkebUN1vVhDrtjuF9tCy5Z71SCxGFLbiVak3/3mctNUl
	fMZe6g+0NWEzeoPvJPQRvT0Q+TeSeU/Z8Otf8XMJ6
X-Gm-Gg: AR+sD10spnW3WffBELBq5hmHjTqaJ0tyZZqJW5MjqSQORHkdpysFL9EMndYfGl9hbY5
	aep0nvOk78vKm935rELTkCWccn34EwK3s1nTupG/H7OVDa7r1j50Neolz92dZVBXKoOt8pw0xks
	TeJecNHiw1rZQL5T83gCuEXwD/qU/ppu7gMUEANiJjOwg8vFIriymG0AFfMWsk0q0ImIUEMnMdu
	sCAGSD1mKhMAt6ODpDJ9xaLXcQOw2wYGTpY7UnyUvBNKLE+XOvAGW1SJrnAz5AYd3JB/7pphfM=
X-Received: by 2002:a17:902:e353:b0:2c6:a078:bfb7 with SMTP id
 d9443c01a7336-2cf8f6acce5mr513685ad.7.1784662766027; Tue, 21 Jul 2026
 12:39:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260721051903.691848-1-kaleshsingh@google.com> <CABdmKX24EKOaUoQZS-yR21v_yd=h1RVUQgq0wj+On-WcfE5dGw@mail.gmail.com>
In-Reply-To: <CABdmKX24EKOaUoQZS-yR21v_yd=h1RVUQgq0wj+On-WcfE5dGw@mail.gmail.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 22 Jul 2026 04:39:12 +0900
X-Gm-Features: AUfX_mxY0poHAk-PpFaYBY8tiHZF8SXBr75d24KNRlY6OEQf1s0rkwVXmy8WYNc
Message-ID: <CAC_TJvdmxhCJ3h=JaJw2gT-oQRHVQP0gLN414DUsH5OZzm4qGw@mail.gmail.com>
Subject: Re: [PATCH] mm: proc/task_mmu: Use walk_page_range_vma() for smaps
To: "T.J. Mercier" <tjmercier@google.com>
Cc: surenb@google.com, akpm@linux-foundation.org, kernel-team@android.com, 
	android-mm@google.com, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C0B7D1C0003
X-Stat-Signature: f5j46nwqycphua5pfhynj7jrj7fip577
X-HE-Tag: 1784662767-164947
X-HE-Meta: U2FsdGVkX1/VZ00Rlo4ve4T6hqTA6leoeBfUUEqKQCw1lpTRjfkaapWabxcILYIlUioJKFK9vwXxsKcdGRu4RPU4cE1hfnvCvlVHFY7YXqs5iNL805dyBzmq/oXtIgOniIC/byal3katIKGlCg++OyPMP8k7nZLSU/TqputX1OCCweVxUpHpG/H9fb73EUThTsPAVoBeMD2K62FU/77S2dzhKRhISxjr9KwjQVzgxPHPzdCw/KMng8S/dfENFuR2qtQ8mk73XRh+PbNr+I03l7li19HB/cdvPQ1rVXRIJgGv7K8MywYsONlKe/xNUK1TKm4OvGx0uJHLbe8eYuWbD/9ydlMxnt11QhRL1U58woMDbHxUBJuHwvG3qb0ArYoIN6hjEG1HNA2miY7VBjCUumYEEHLT9MxA7aBbFNh4d/bfeWw35Yxezl4sVyfDOq5slw13AR2e5F+V1b90tmkNb6XsqjomT96pX2bZ6fLS21JooCSqVn4nFP3ZK1S0DfalqtwRNM1yhJ1lPw00Er/FNEpiTijgpIwPgPCJLWlDtyout6iXxSdGVqK1ISVj9BmfO/7EAxB50zz1Z/N3e9PaIl7sV8QP2JDnfp5qCzD6JUhNTrv1clqCCUXUZP+2wGNzBWUDTKSJF7g93bEc1QkydDmdkU9PIxEiYhCBtgpfwaUWGYcbhLrPMGSc+xrliXZ60npEairLe65kWgwKW1mJv5ce0KuTY39oZCgJ/h9U3QzDFa9IuN2e2f2cbCnpM1gI7UlzahawYBp5mo/YSmRrRh4AKbvCAdhStKW4WB9l67tpdn0do3Prb1vu2DwrwMyii0bCpID6P1nCSOYMnTnkgaADYddSIAaLoMD27WeKHEiMq/I4tyJrSG1arxrLCKdV8e4Wc3wVLd2MYNTUy6rXDffPGJ1w+dHlLeL39MPyFFS1mommuxB4FqFEDbty5GKSYfw046NhUQrgSYQ7clY
 zKoyaZ3Y
 5lOBIYH4+c/+5/kZIEsMRm1VXZWWDZd3WFaVnsRb/b3eEUDPr9Osye7UpjXnMB6E3RRB8u0J+1OXZ6pEUewXY96s0jp5DBQuJrpi8wgivvbz+JxJlVjMxkRX9JVWSb56q/duj2UGF2CaolcEGP5KnacvW6eCg1baXjGtPHx5fwmGQN6MnWbrdb7Ydr32JIFJ+snMbO0o+B9VSJaI7l+qNbr3n5AK+fy/qXkaVD9dZAgHtiJo7N66bWAdLa/QxlCfolfFz1uYgdZlhUdAWiPe7W45hPt+e7Fx0KQYRXng9gMjJ35VRCl/jME2EC+VYuycA8x6RkdPUhP3HsC6KiP9FucXeB8o4w3KcrlMAp288OoSNLTyumLixZCUOFlQFxoq/IVxzTNPXyg4rwF9KvRNvoMD1IHJuEj5Hpqdb3GFV+ZUZFwn73+xbW+UJ5iZAed2dGTWD840+5HpZyu2dDIAvOqHgFV5wlVGpHdow
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 1:30=E2=80=AFAM T.J. Mercier <tjmercier@google.com>=
 wrote:
>
> On Mon, Jul 20, 2026 at 10:19=E2=80=AFPM kaleshsingh via kernel-team
> <kernel-team@android.com> wrote:
> >
> > From: Kalesh Singh <kaleshsingh@google.com>
> >
> > Modify smap_gather_stats() to use walk_page_range_vma() instead of
> > walk_page_range() when walking page tables.
> >
> > walk_page_range() internally calls find_vma(), which asserts that
> > mmap_lock is held. This assertion fails when reading /proc/pid/smaps
> > under per-VMA locks (where mmap_lock is not held).
> >
> > walk_page_range_vma() walks a range within a single VMA and does not
> > use find_vma(). It relies on the VMA lock instead (when configured
> > with PGWALK_VMA_RDLOCK_VERIFY), making it compatible with per-VMA
> > locks.
> >
> > Fixes: ea3085dd7a4e ("fs/proc/task_mmu: read proc/pid/{smaps|numa_maps}=
 under per-vma lock")
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Liam R. Howlett <liam@infradead.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  fs/proc/task_mmu.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index d32408f7cd5e..5d301bdd05fc 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -1369,9 +1369,12 @@ static void smap_gather_stats(struct proc_maps_p=
rivate *priv,
> >                               struct mem_size_stats *mss, unsigned long=
 start)
> >  {
> >         const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv);
> > +       unsigned long end =3D vma->vm_end;
> > +
> > +       start =3D start ?: vma->vm_start;
>
> Doesn't overwriting start here break the !start && (!shmem_swapped ||
> ... check below when smap_gather_stats is called with start =3D 0 as in
> show_smaps_rollup?

Hi Tj,

You are right, I should have updated it to start =3D=3D vm_start. I will
fix this in v2.

Thanks,
Kalesh


>
> >
> >         /* Invalid start */
> > -       if (start >=3D vma->vm_end)
> > +       if (start >=3D end)
> >                 return;
> >
> >         if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> > @@ -1401,10 +1404,7 @@ static void smap_gather_stats(struct proc_maps_p=
rivate *priv,
> >                 }
> >         }
> >
> > -       if (!start)
> > -               walk_page_vma(vma, ops, mss);
> > -       else
> > -               walk_page_range(vma->vm_mm, start, vma->vm_end, ops, ms=
s);
> > +       walk_page_range_vma(vma, start, end, ops, mss);
> >
> >         reacquire_rcu(priv);
> >  }
> >
> > base-commit: b95f03f04d475aa6719d15a636ddf32222d55657
> > --
> > 2.55.0.229.g6434b31f56-goog
> >
> > To unsubscribe from this group and stop receiving emails from it, send =
an email to kernel-team+unsubscribe@android.com.
> >

