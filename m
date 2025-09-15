Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12355CAC587
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 00:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF30D8E0005; Sun, 14 Sep 2025 20:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3E38E0001; Sun, 14 Sep 2025 20:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9448E0005; Sun, 14 Sep 2025 20:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C03C18E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 20:44:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6276485ED3
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:44:08 +0000 (UTC)
X-FDA: 83889637776.10.49D3EE3
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9171720004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:44:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I+Bpsr6s;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757897046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V9JaDewgxuozpkxda6xKseXUycmdfaWorgRDXhlzyRo=;
	b=W7t0qky11NoPAWtPOHIq0eAcNCw/kqsCGo7xTudx/2xZchFutOTaQ+cS/oS8Wm93R+LKlM
	6BUp4qNlR+EyZOg6aFo5pLWlqf4/UF1PVzSx2mfLRqxtYldnD9rWapGKPqsZRTuJ0sjqAl
	QN7FjHB3wn/gqZEBVt+9N66tLGAndh0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I+Bpsr6s;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757897046; a=rsa-sha256;
	cv=none;
	b=gep/5IMCgS3WIgZ/Bl2glCjorRMBnz3248PudztE2ucdtTeNf6mplyhxGXrGuoSWdTF/xf
	A8450/TDr6c4lrJp4A72ZfiwfYawYxiYuvOPle+ptHS+KOVVTCF/9+z2k5uTYxRX1qbEZt
	eMBRLwcNz0Aw2kPKeDfoQzfKp7tjqbk=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b796ff6d45so358871cf.1
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 17:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757897045; x=1758501845; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V9JaDewgxuozpkxda6xKseXUycmdfaWorgRDXhlzyRo=;
        b=I+Bpsr6s8NoqHDWLRab8AoNumd/qgbtcTq60XLkJn4VqmUoLgJYVHU6/MX0gOkdToP
         H0L9MrTNjuF1Yrge6UWLc4bHA5izXD0lkCCXI9yDxa/SQOKZ7/diU9OuSAgAPN+Zcsg9
         6CRg7uWSBv13KDZj0i4xcLvhLVZwTXUNc6vp2E5zEpV6tyazAQLhTxy4ZuZwqEq4T1+k
         Yd3AWNjOcj1Fu6VMmBpJTVq1/8dupEsjHPXmw26dZd3WgyIenA5JRaIeNJ5abQHWctjo
         YYOfvCTjW7QTAfsF7y/bXkPTAP3Sei9V//qKQEEEryuBpPfQD432VbcHQaSm/L6TpKPN
         BPAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757897045; x=1758501845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V9JaDewgxuozpkxda6xKseXUycmdfaWorgRDXhlzyRo=;
        b=RuCqQA99jv5HmMVRpNL/9ebYELbtfa8phZuvzyX09A6Qy2oHmrSGjf42ycFGhT4Zht
         t9yC9f/fvvw7zBGdDbPVbgkaPoe/kOQ8HDYbCIyFA75pz1OFdcWFiTcRnQJNoXQzHtWN
         1/4aWzlXGWsU6XWX5pKubQ1cxqDZLpLNBzjuFKf+xG7NdKwWNbQCf9uTNAPSU2hklHuw
         6owQYlnc2dekuaSY7s/5HARiE7qq9Pup6b4fH/thODwbohlNN8reiUi2u9KeGc+RqMvD
         GvpJRDsRQq+tlrGbf0jMl1tXgldjtechDpXPk1avJHgTzpG/rPVBE5ZYqNbD7951/qNR
         JiOA==
X-Forwarded-Encrypted: i=1; AJvYcCVsggaLqYg4TKszLHjMO3CD/UjOM5o+2c2xrlcX7C2jTOLmhJwLDnEpPxk2hZ5PzN00tp1J0tEVwg==@kvack.org
X-Gm-Message-State: AOJu0Yx1v/eciQQHOMbg6dtQ6d/jSycbeivx1kQPLMOWuElTasQSjTST
	NqKJOIWDflX4nffAy/Exm5Ijw0wu+w2zHNUwhRPRIAB8z5oF8ixcDGXHVKkl11qJOAgFBz5KbHP
	dDl4dAqdPJBysMkEa0c2hw1V+AzH/Myw8VQEzVPkD
X-Gm-Gg: ASbGncsJvNwtjgkd1Ch8F8dy8UhYkcqstZeVsfMY5wIuZvqaXJMewNVHLq0sFbpqXZr
	uzl7WfTsvfQpJQocZgkWSNUIP4/v0rTAsCItpCh6gsPOTIJY4Y7MllDZWYITWB9lp3LFGbo4RJR
	wSbcb+MTgwcn/7O4HwFc563KWQm41IwI4W/t+p4qPpUNGLKECKMFY0WYBk135jr2F9AxAQVuSSz
	X2ZO2jMmtUd+32Mx0QWzcs=
X-Google-Smtp-Source: AGHT+IEezB3iSLbeJTHsIwywK29EKKbUJtnk62B10GeCdyT9bGxf+jf23KN9V20U3FFXbSgM6H7iFnxQMLHkzklqJuw=
X-Received: by 2002:a05:622a:900f:b0:4b3:7533:c1dd with SMTP id
 d75a77b69052e-4b78b98e1ecmr8313771cf.1.1757897045275; Sun, 14 Sep 2025
 17:44:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250808152850.2580887-4-surenb@google.com> <20250914114308.3024033-1-clm@meta.com>
In-Reply-To: <20250914114308.3024033-1-clm@meta.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Sep 2025 17:43:54 -0700
X-Gm-Features: AS18NWCmk4aMAnU5waOHNrHwd6qTif_tgIS8NTe99BvH87FvfzNuXoMxBTE1cSY
Message-ID: <CAJuCfpGuvyRj6zxPuJDzCcGz_-x7feycsCkNQT0+Nzn4oUYcSA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] fs/proc/task_mmu: execute PROCMAP_QUERY ioctl
 under per-vma locks
To: Chris Mason <clm@meta.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, david@redhat.com, vbabka@suse.cz, 
	peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com, brauner@kernel.org, 
	josef@toxicpanda.com, yebin10@huawei.com, linux@weissschuh.net, 
	willy@infradead.org, osalvador@suse.de, andrii@kernel.org, 
	ryan.roberts@arm.com, christophe.leroy@csgroup.eu, tjmercier@google.com, 
	kaleshsingh@google.com, aha310510@gmail.com, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9171720004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: mc9imniy8zgg4t4rrsq134s9f6s5bqa1
X-HE-Tag: 1757897046-665063
X-HE-Meta: U2FsdGVkX1/kQP/ZLAi+4GKxua/HpFhMHnmswl1nVQdAy8D7S1Ft3+5+doJhHPgvYgYFi4lkEumz/01LEetz920TDSiqvxMS4wNak8CVNhdzkfD51oeXsmtC+mEPN8urlGjhY0K2dvgzbyxm3T4UxDXJ6XaLvd49JBqGgT5WF5Ux1g06wgWgbjAybZ+KdSgVIGyWWwvYcy8yVVvExBSN7KUMVUXc78FIa2eEirW6S+U6J3tRCc7iBi7KD/V9YaHeOxgxlGP8/wclZH6MQ2m4BYJm6UT0Fvl45q14M2UbzAmaCSRPGATF+GsFSCpPpV150lM6+MR6VlxpBXvE7WAwUFhbwDgOI+sy8KkGa+xni7brZvpwChWioSmxh7bIP177WTu3GJouQvCOLN5uHrIzF/3X2DFf48dH0ZsQzXwhBNIy8uM7g4L8MzcNo7NZzjpDJlJPhDgLa1/9hKc0raHX5GOD1Jx+j0PiScSL4n+zC8JkEngmr9hfnqkxoHsYZY8kidZmxXq/ihx/C8MlBTKcQFy56vV6Vp8mmW2CwNX2taaK+t03lqwQmmuvfa01ETxG/JOY3PcQkmZoPrsCxJVbWQ01l+LGIUqOgHM6vX03bIud6FCgFgRal7hQ9DR7wMfEARt8XuOSC2Ad3Ag3ilFFe8ZqoPx5BGBmyZu3ztHs3HNQP5ka5CAFR3s24HAUmEDSMoIvnTZcQVXWC8iCdJR6YcrB87qmYEaWeCheE96EB0So3/dBZAAB1BrFiGISiojRH/xMRh5MdrAnn6D8UFFaWZGK7rVGyIhUQXLTYa7Fd87bBZj4jSkOv+vJiEzISUIb1Wqxolhoir7qM/OO5FtP2t+ZJSpMWaPomDirL2fUOkGNZdXhjl0wh+AytCF0g19uSABzbJNvLOMeLBzMdNEzU1Z5WzIvl1T1KIeF94Ze3x65O6+ZuKgSYcoIui2lqQFvpzRZAHqfAnU4PwuNPRi
 siQkcx40
 FtprK9fNehGfm/kFjrpoH2US/BAaJCYbxFf0qaOOkI3glkLeBj+sDPlq9/eX4LUk49PdyMVkxt+ztLu2kdQDqJnNLYgOV/l/3cJl2FCBSyNy5pC8ZFV1MPTAxNFatjuTQ8+gmqd7qAAs715BpHjFSVqDfA1UIPeg6uYC+ntzAWVuJGVXpUccWKV0eEOqb4uQvOlERKUhsge7I14JKEosDHR1xQEavMIcNwZrhGfpiYqiNHbIUNwoXeWGcXPcvWDE6H4f2FHnjbZP4vhn9UJjSACCQObDTQ92PtF/bLFkoo+pPDg4u+ulAtJFQKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 14, 2025 at 6:24=E2=80=AFAM Chris Mason <clm@meta.com> wrote:
>
> On Fri,  8 Aug 2025 08:28:49 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > Utilize per-vma locks to stabilize vma after lookup without taking
> > mmap_lock during PROCMAP_QUERY ioctl execution. If vma lock is
> > contended, we fall back to mmap_lock but take it only momentarily
> > to lock the vma and release the mmap_lock. In a very unlikely case
> > of vm_refcnt overflow, this fall back path will fail and ioctl is
> > done under mmap_lock protection.
> >
> > This change is designed to reduce mmap_lock contention and prevent
> > PROCMAP_QUERY ioctl calls from blocking address space updates.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Acked-by: SeongJae Park <sj@kernel.org>
> > ---
> >  fs/proc/task_mmu.c | 103 +++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 85 insertions(+), 18 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index c0968d293b61..e64cf40ce9c4 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -132,6 +132,12 @@ static void release_task_mempolicy(struct proc_map=
s_private *priv)
>
> [ ... ]
>
> > +static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_=
locking_ctx *lock_ctx,
> > +                                                  unsigned long addr)
> > +{
> > +     struct mm_struct *mm =3D lock_ctx->mm;
> > +     struct vm_area_struct *vma;
> > +     struct vma_iterator vmi;
> > +
> > +     if (lock_ctx->mmap_locked)
> > +             return find_vma(mm, addr);
> > +
> > +     /* Unlock previously locked VMA and find the next one under RCU *=
/
> > +     unlock_ctx_vma(lock_ctx);
> > +     rcu_read_lock();
> > +     vma_iter_init(&vmi, mm, addr);
> > +     vma =3D lock_next_vma(mm, &vmi, addr);
> > +     rcu_read_unlock();
> > +
> > +     if (!vma)
> > +             return NULL;
> > +
> > +     if (!IS_ERR(vma)) {
> > +             lock_ctx->locked_vma =3D vma;
> > +             return vma;
> > +     }
> > +
> > +     if (PTR_ERR(vma) =3D=3D -EAGAIN) {
> > +             /* Fallback to mmap_lock on vma->vm_refcnt overflow */
> > +             mmap_read_lock(mm);
>
> I know it's just a (very rare) fallback, but should we be using
> mmap_read_lock_killable() for consistency?  I can see this impacting oom
> kills or other times we really want to be able to get rid of procs.

That's a good idea. From a quick look it seems safe to fail with
-EINTR here, which will propagate all the way to do_procmap_query().
Do you want to post a fixup patch?
Thanks,
Suren.

>
> -chris

