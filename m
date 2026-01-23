Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4960CD7789A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 17:42:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8175A6B051F; Fri, 23 Jan 2026 12:42:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4FF6B0520; Fri, 23 Jan 2026 12:42:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6826B0521; Fri, 23 Jan 2026 12:42:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55DEB6B051F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:42:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F0EDB1A04D5
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 17:42:57 +0000 (UTC)
X-FDA: 84363949194.27.5A1AA61
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0AE7710000A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 17:42:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lCk3Pe16;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769190176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ecysJ6oY4A4ZF/nobL6khlSXSX0Rv2e+xk4Zdl2vm+k=;
	b=YTDyFaBFeFUbHwJFeZH56h3WilOV9SpnMvfnTPa2PiQ3W7rvvJoOSqmRiW4Quge6A749Ly
	OkvGKqAUzck8nJip6MvWdJJvrjCVbrpo0Q6IbfCoZv/Oykz1+8rmj/qM2iDGC0ws1clnWo
	PwqmhcSa1ecQy7SksU+Ily/nrwPCuJY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lCk3Pe16;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769190176; a=rsa-sha256;
	cv=pass;
	b=ATL+SH1ukeVnJrDu0KcWVlBIlPIW8zirpS5OEzOj8ac3lJN0CojoVSQTxhnwBiEkqXeJAu
	nkMUT8NKpNHvY45dVzJgzCdWf22dHZQhuZ8qCzwi3YaifMBiRgJ6/UvZfErB5Cy7fMJKkn
	q67zZ/gM2L850o1mdGxl4eudPWYxJwM=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5014acad6f2so911cf.1
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:42:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769190175; cv=none;
        d=google.com; s=arc-20240605;
        b=BXTQfHloVsQNl06J/F2j3tzGm5/Gm2qxe9IliZsTWpjy6lpyspUlCq06iwLA4wGAmQ
         y4C3wYLEiqr9SBJx1YxMSlFZxvxZZybn/d7jil/XhI8l7KueZkf2CIP99M7jCHEZro+e
         KZ50e+3E8MvyIE6Ug6UI7KS+3rhaviZdbjWKQxRMjZbjkHF79FuPV8+Pypso57GecQko
         ZF7prndJay0INB912C+kcwMEuxifZTCb6WhouC5JzvRfIvg8c944Qz2NLLYV5Wm3iTju
         AZmZInJ2Dh5YzoU8lQHlz8kiDW2+xW9RsEBK1NpTNG6mtIMalWUdicAkrxCRMVvBJZM5
         Rtfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ecysJ6oY4A4ZF/nobL6khlSXSX0Rv2e+xk4Zdl2vm+k=;
        fh=tMZyihH5msYI8hg0NVXDtHHqs5ZW3DNM36SJyzk//60=;
        b=XkhwoGLWh0XGTvMo9ZOX2qSNQGFQgXNS3VnSCWdjOYkHpXksPu1DMjw3tYRD615Tg9
         RWwUVGtGAwkn46aVrH+NSbSxlM/Hx8mTDQPyT9X0Z9Wb9n7LrZxqPYBeqFsXzqh76msg
         /vHKdgXhE/2uN9zQqBnkHOCQPNUOocDlyeg5pDAAQiyPyHEQg2srneSp1FmbJwtFkQiL
         6Xl23uPZskOvLb69nEcLpnWFo1uoatp0gWonWftLMcwWICEf1SFa3FpvAq2RWrLpMZpe
         uG13MpQF0OzkoCYBUH+ABv3NBXpFQrtampyfnh053vmX7zFvp1rXedwxo4PkvZoLcqgQ
         aGsQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769190175; x=1769794975; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ecysJ6oY4A4ZF/nobL6khlSXSX0Rv2e+xk4Zdl2vm+k=;
        b=lCk3Pe16z6KIxTy3xqaGOsH/sb50rUjMSCULTn2f0PzP2cT1hW6p4IQFEk1mWQcIqc
         SAOrOhuCjp+2f89lF/zViHhO7Xa6ifjwnPzlTqIFMBiOdT9sRcEJqZJd+y65TChgTR0f
         hETlEAzj1PJyWJqD7uXsIfwowEGzwPJDdTRQFxNmfI0Tzcq4HWSjG7nihY+MRM7UXgsc
         qJdmqlMDU7BScG5GVX3FRaPmPkEz3Pw8Gt9FHjEafPxPooQPdfiF+vQ5MCNUza1qrsJV
         yaTO2yJC7sIc+MrwBIPLhpwHLfYIdr85rSlxUFhJKP90GpVus4B09NCHEBiPbdfkKdn/
         JfCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769190175; x=1769794975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ecysJ6oY4A4ZF/nobL6khlSXSX0Rv2e+xk4Zdl2vm+k=;
        b=fnIA2OotuV02/fU1NIkYEwR0a5AEgP97VN5mxNgiRAgHMbbdZVrsaYUhTgK3UNo8WR
         O2hhiabtESFzAumfNc3HxTYEUEFqlrkO5Un6OBSSA/Kqa9HkXcEUoA5V9NHQeidOPpmu
         EgUCpQdRadpsv/s/w9MyuuALbzp6HV5Xrq/9MSYvo5ZYPafDvJxtTwUKDna9oHo9ImEU
         VBnjyN5egQj18TN3j7UBuZ0ScALSy7ys1IOungQC8rtEeg8XBpyq138IP4Yh5wnfMFQG
         mT8vcQhTU3jW/tEpR41G+327RJ3Or8LjtKrmyqqzWEm7Wwbmf47Bn2qzsuvaP48rVQRh
         fGwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQrYwUljtYI/I4ve9qVR2LaAVZYEP066Rtnqv7uaCChGCvyD/19fgaQgdkGUbwod7CrtM2KQ1Y6g==@kvack.org
X-Gm-Message-State: AOJu0Yyd7ibQMsqypu6Fab7Z+AtL2EIZnUrGlFXESMBkTVNpg9njIKP4
	yicFoMBcbEi0lkLq6jDC2By9vm66Di4OHPG7QLJG9074Kj/dsNTuZZ6cnjBfjD96uwcSa7zKLU1
	DKZn6SqPYTLROuRNkcz0pw0pROuE87GdEBKFoeMdg8BhqO+qTllSseD+6
X-Gm-Gg: AZuq6aJePrEJROyz1LrBJTKSWsirnSBpBo7M8hMYyXi32hHOHgjm2WtOcBgGgMW6F0E
	dfzwUUGdf/Ebt5etuwgz3+77UcjM0mTWfNbFtTiZjoLNKFYNqPQhPBzuGqZNEXilaN/DlUkoXVD
	gQBGJ8/RMOzrgCvJDaVdgbCLXW7E3nZ7rqCDJKfTnJFDBqYL9a+FGa1ZfvDPEo2G4ZVu7WWJHvI
	6NJeUqK6RTr64Nt4nFLpmjYp/PRXT1YxYJh+CCTTXvZzp9AWiy1nHKTCvwq/w29pMq3Lw==
X-Received: by 2002:a05:622a:15c6:b0:502:f1e0:dd3b with SMTP id
 d75a77b69052e-502f8dba323mr11741431cf.7.1769190174705; Fri, 23 Jan 2026
 09:42:54 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <70dcf80f79ecd00a750ea17101061b0949119429.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpF1LthyP2FR4T8iDd+zOi1WAjqma2KBkHcCJsOjm+s32A@mail.gmail.com> <b267b699-f312-4387-8dc0-a14efe72561a@suse.cz>
In-Reply-To: <b267b699-f312-4387-8dc0-a14efe72561a@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 23 Jan 2026 09:42:43 -0800
X-Gm-Features: AZwV_Qg0XqJp6LB6ClHaUtMVJzUsaWRJQOHROvVx-k5EXeTYGcGYUgT45CfCEsU
Message-ID: <CAJuCfpEo9XFFzGL3c-Udy+0GDM12xOtDeFxu2J4L7F-kQ7xohg@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 08/10] mm/vma: improve and document __is_vma_write_locked()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Waiman Long <longman@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0AE7710000A
X-Stat-Signature: ja64iupt888zcsxh4qh3gnta1zbqn11t
X-Rspam-User: 
X-HE-Tag: 1769190175-287432
X-HE-Meta: U2FsdGVkX1/tPMsWCPMergtwEeYgEcuzcx+0tnLebWmA19tCsMyOWyAGVwTcNeDjWcIDFXUlFQnMBmlNdAplkKzYQX0e5dweSO0Xcz0AxAWVqcslMV3oXOLk7fgm2yysbH+zVsKZfBues04/Tbn+SV0vOY3p+gk7kclgRYHYT8DOFSPUehL0/WH0LXV+lZBrsOAQQY+h6a0t//n7v1ihjC5Up62tmPAqr+VUxSc6C2MR4FdaqBshttzZg1mzpKjRZa4O+vey6Bh9QGeaZAUR9kbjRI81KsW5WZGznXyisiNokcbG8L0A3Xwp1XfjeXZNG9cS6pP7ekaIDz3kKuQ4YCufGJGXGOQVdXnoWfIrMfsh3GHjFgYsMo5ib//hkkb0zqbNTQo/qMrkhn7TE4M1v1Gt6kDjKSqYzbU6tS5ux4YoYYWZcRBvNvzq+/55415bUDqXxqzBC15y7iK/l895/hqi8+4D2JecPiiG6zrxk2xK22EQ7CgZ5IMaEn6yti4aeF7mJu7Z8jw9pgVrpMcn/ywlk122Q2Hm6p5tkbrrbLegAXFISUBU7ET4MZDcqIY8T5CnDfyqWOyMOEMIbQwfKbf587JYrvZOyG6nRjZ12CW9jKGTB4+FmUTulpAuBVkS7eBy0Wxrd+AceStpJH9qIeyen1TtHzsvyC9LrmhqB6Yq/8w+rJ1m6riIFiYZFWeTEgg0OKgU/xswsqXwunYv1d/j+SXJGxyVrTbqHP3JwYgxp2DLh33zMULXXdcI8beLDLkPndBWG9jBHgkLvFwP/E3QKzmdGhtJ3KrkhkLTfDXLfJFuF4XA3UYjHFOf8prPSc7WqD9G4hIR8/vpz7rn6xGZLHZFbGaSJnZJa4r3/QohLBq3HcUsMQlQ05FHJfGx0bYlCDC0WTiGn6hQ7cUBpk19/S1KzlQatmiUDSb5UPAlNx6ICE57UmEsHx6JeRb0LA/03yQgTMM0elK2694
 6ZGX5+/j
 EuPl0k7gvit67ylKwlQMdOff9Gutks0Cd0sE0mk1VLGSspyutgOgLz0F1AcgiRA9csL0sJPfKbjCOeMZPmbYbQzrkpUMEqh8fTb1vwJzclgNj4a/SNa72Vp73OPuwRApOlY4bIaXC7go00FO/8FaYjXg098yi1LCS+bk8fIGOuve7dws3C8j3XSng95pHZNUzCakAR3uNKdm743NhG2q5RjeIW+JJNWictoV+gCU2+ANAaK2s0pT93Wk4o1jcW4TAncpXMbpYYx1hAYbRJuzNgc5ZJ48gE7FBRIvNb1JF1hnDGBeu6rzL5WFvFHqReN4mhUaN4oJ3PaXclrROS7wdLPlAMM+NrF2/+wVc0yAnZxrPaiy9gBNgBiH2G0PRciinXfUK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 8:21=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 1/22/26 22:55, Suren Baghdasaryan wrote:
> > On Thu, Jan 22, 2026 at 5:02=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> >>
> >> The function is a little confusing, clean it up a little then add a
> >> descriptive comment.
> >
> > I appreciate the descriptive comment but what exactly was confusing in
> > this function?
> >
> >>
> >> No functional change intended.
> >>
> >> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >> ---
> >>  include/linux/mmap_lock.h | 23 ++++++++++++++++++-----
> >>  1 file changed, 18 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> >> index 873bc5f3c97c..b00d34b5ad10 100644
> >> --- a/include/linux/mmap_lock.h
> >> +++ b/include/linux/mmap_lock.h
> >> @@ -252,17 +252,30 @@ static inline void vma_end_read(struct vm_area_s=
truct *vma)
> >>         vma_refcount_put(vma);
> >>  }
> >>
> >> -/* WARNING! Can only be used if mmap_lock is expected to be write-loc=
ked */
> >> -static inline bool __is_vma_write_locked(struct vm_area_struct *vma, =
unsigned int *mm_lock_seq)
> >> +/*
> >> + * Determine whether a VMA is write-locked. Must be invoked ONLY if t=
he mmap
> >> + * write lock is held.
> >> + *
> >> + * Returns true if write-locked, otherwise false.
> >> + *
> >> + * Note that mm_lock_seq is updated only if the VMA is NOT write-lock=
ed.
>
> Could it also say to what it's updated to? Or is it too obvious?
>
> >
> > True, this does not result in a functional change because we do not
> > use mm_lock_seq if __is_vma_write_locked() succeeds. However this
> > seems to add additional gotcha that you need to remember. Any reason
> > why?
>
> Actually I wonder if it's really worth returning the mm_lock_seq and pass=
ing
> it to __vma_start_write(), which could just determine it on its own. It
> would simplify things.

That looks fine to me and indeed would simplify things... Yes, please!

>
> >> + */
> >> +static inline bool __is_vma_write_locked(struct vm_area_struct *vma,
> >> +                                        unsigned int *mm_lock_seq)
> >>  {
> >> -       mmap_assert_write_locked(vma->vm_mm);
> >> +       struct mm_struct *mm =3D vma->vm_mm;
> >> +       const unsigned int seq =3D mm->mm_lock_seq.sequence;
> >> +
> >> +       mmap_assert_write_locked(mm);
> >>
> >>         /*
> >>          * current task is holding mmap_write_lock, both vma->vm_lock_=
seq and
> >>          * mm->mm_lock_seq can't be concurrently modified.
> >>          */
> >> -       *mm_lock_seq =3D vma->vm_mm->mm_lock_seq.sequence;
> >> -       return (vma->vm_lock_seq =3D=3D *mm_lock_seq);
> >> +       if (vma->vm_lock_seq =3D=3D seq)
> >> +               return true;
> >> +       *mm_lock_seq =3D seq;
> >> +       return false;
> >>  }
> >>
> >>  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_loc=
k_seq,
> >> --
> >> 2.52.0
>

