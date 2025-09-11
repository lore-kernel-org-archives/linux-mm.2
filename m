Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2B92CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 09:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E5A38E0009; Thu, 11 Sep 2025 05:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F068E0001; Thu, 11 Sep 2025 05:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437478E0009; Thu, 11 Sep 2025 05:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 297D48E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:18:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CAD66863EA
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:18:32 +0000 (UTC)
X-FDA: 83876418864.29.D2E13D6
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id E6ED880005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:18:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="NUf/13HW";
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757582310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxGtXCRPNZKi+0bqLzOvRec6geBrjak9hppGOOcRoKo=;
	b=cQI+VdGHhIweVTZFiU22ZxZD8x4+uY79XAGxY+xw7t0/ZTUQqCBfRhBCl3AduewCuKkGx5
	erRMgZU+dflkg4rVCmXMqmwPVYdv9ml0pxbfNLte+IOflTDDwvHSSqUORBHcSSF+XU3U/b
	LNzGATUxj67d6DE15VxG+XvGs4qakX0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757582310; a=rsa-sha256;
	cv=none;
	b=60YA4hya8tTIjVdL0CPjtiZlSIa3WJdKJ5jI3arajj4W2b7Dc+fMykbE/Dr3uw5zPHJj8p
	Ld9mhbcxmmpYFuO8KjeFtalPTMZHOVyPW5Fto8M7vDQIB2NBRLvuz1e2hlQo0UDUBqjTbm
	7WTRorUql52/NebtLtWUmYBeYu75nYI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="NUf/13HW";
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-817f23fea68so24343685a.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757582310; x=1758187110; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XxGtXCRPNZKi+0bqLzOvRec6geBrjak9hppGOOcRoKo=;
        b=NUf/13HWfl9kUQA+fKkGG/kbXH2KtJkLRG5swbFXcpFVwfRItEG9tUQX32DZ6K96td
         YnBIvleyuW0z4MCM3qmuAN46wY6U5z4LxgiaMVajcxvbDCS3H0noEKB//lBwuCqevuwe
         3x1YDHU78jP3n39RIF6PD1inLW+92zmQMq9uuk49IHhK0DPxD9te8PtZhB9OWo656Ff6
         lxMhUmV7lMtk0ZHNnht29GNSAhOZ7GIWfjp3Brxno2d5D6bVj+JX3eHP89VDPTrrP/EA
         iS1HfTVgyPhShUBfuro06N4+j7vHTj+hFVeSxe+k4zfGPkS3a+oQveevqcH/UUEb6C/N
         mvhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757582310; x=1758187110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XxGtXCRPNZKi+0bqLzOvRec6geBrjak9hppGOOcRoKo=;
        b=O9xodR9HN+VBSXGsjib9/6bZ3KU4oz/1duHtwSQvbHD+SWdxIsqxt6/KF1kwjIdln3
         wzYY8U4aQ0abIk1K3PSJw0gHT52XifSgq5nBcUOEta3HYynEuaWMQPWqyZVSt+d2tC+g
         2hXYwXRoI8vaBPg2Ynco5umGbkxqx5aFUI7kP18Ry8JYBX1f6i6wmLXYoKEXGPFEt4gF
         d+vvZRmS+YtWlRqZRxLK+vsxCPqFoodMSI2rtZizNV3A7EJunCz9uq/1LPhtFQI5E7cp
         NiW8fbCrbwgKMEDViKSHUwWVzuAgzNsEncN/LND5niq2YvsewEkUwKAx2WSSsNB1zLKB
         iRrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYDJtX4bNIYBiUt9ngDLZ3Rja5Jd26MovuMVa56VQyFhoM+S6zy+m5dt2OW/2HeGdhuni0RZ4u9w==@kvack.org
X-Gm-Message-State: AOJu0YwsGhw0oBDd3UJT5I3jTQ0HRVRuUdB6v9O5a1e94UM1e2fQ+ghS
	BVRgpFX0mN2M/8edbLBsX6cAecyQNT72nDg8u4qJYEpmwx/XJd2Ihte28yQgdUuUH2HKOWh+NK9
	0rh+Wdq6bVli//cFq6t7B5LiC0ncWNT0=
X-Gm-Gg: ASbGnctcAupWq/LE3pGvktwx+QwkWXOfFF9AgPyAnm7ZCLw/A3YQlAT8BpXdoKSNtE3
	F0A4imwsJYSHGh5STf5/KijX29Y7I8VliVF4Not+YeX3kTdGgy3IZq7sOfnYPv+TKSrjadCdPbG
	d7tegGnd08JjGFHDWNnRdbeo81a1hNKMkPMijT1c91FMlZ8rCzv/SDrtAvZHLNnNko9O9dqksnw
	KDjeqxP1uVu/X+c4bxsPk4J4n3rCYNwXUZDGXvo1LdPlhX1a5jQTNoSkmvy
X-Google-Smtp-Source: AGHT+IHr0N2c9rpkUD+j96nPJboavaEVvbPlab1UDSv2Npm0903BsJX6fJADk+MWL+Xob2pbB0iwVGgwn464ObRlNfA=
X-Received: by 2002:a05:620a:2909:b0:7fa:aea2:24f8 with SMTP id
 af79cd13be357-813bf6c1877mr2115024485a.23.1757582309901; Thu, 11 Sep 2025
 02:18:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <fc37efe2-53a2-483b-8c59-bccafae81d97@redhat.com>
In-Reply-To: <fc37efe2-53a2-483b-8c59-bccafae81d97@redhat.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 11 Sep 2025 21:18:17 +1200
X-Gm-Features: Ac12FXyP1xyQ_RoyxPc1P9Mzf30DhbDFb160kQ2sCsUBiaNPu2_Hbdxvx7e4TzU
Message-ID: <CAGsJ_4yxN7TXO58c3Ls9LByYAG91RM3oi10C91mrgxwd-heKjA@mail.gmail.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
To: David Hildenbrand <david@redhat.com>
Cc: Nicolas Geoffray <ngeoffray@google.com>, Lokesh Gidra <lokeshgidra@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Rik van Riel <riel@surriel.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Linux-MM <linux-mm@kvack.org>, 
	Kalesh Singh <kaleshsingh@google.com>, SeongJae Park <sj@kernel.org>, 
	Barry Song <v-songbaohua@oppo.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E6ED880005
X-Stat-Signature: rajtypeagzwrsz1y1kmzjzsc1nus6hkr
X-Rspam-User: 
X-HE-Tag: 1757582310-748986
X-HE-Meta: U2FsdGVkX1/cvmYnSVwdzkIQDewqwFj0lnG7j7SQ8lL8l2cNYgmTXKDccWvahvxiUL38RnM43/OQDjmm0Fivg8zAP1RI6vJ6Lrq9SH2TqsvLV+A90+9R74mlKavkw7A5sbAOPDkiYkVIQHpYo6mE1NCwML6gcOadlZS6988mNbbilbhUS8pzbbURovxO0xi3toCc+4YAFNxIOpZyIFRSZvip/2jLS78W9SFlr5I8w9REqyeYGmGXDsiOGEuu/x6F8Ma1PPmedz+zVaXIEKgwoktz0yLKfCB9xUdYm50I1df5mgsnm4kE/Vx5PcO25QEMQdwj3gqqqMesBSupsNNH5O5Ou39woDgYvMtkdAOE+k8JoCfF9LSUEt9kD+E5BvYrCccxnvdRmttXSmfqXmOh/0i+Wnxv+venHC2PggJ5DD1RPdvGyz0HcUca/E63z2XQOAh8nFTQTjBb2izTvQo/OnHAqcJ/UdhnGRETqIT8eKYyPaevPaQq1TyMQWYsp2Sjs7rzVgPxZ6KmxPR11o0lAYY+kG7cj7qU8kbyt07m6L8VJyukWxgLWqnjhDpek9gctlmSFC+pLrU8sDZUI5Kj91Fc2WyWysi4sxj+u1qpsBXCq5T1ZhhgnIlmdeONNWWShgkiOvezaLvdsolqQ6chY9hSDjNf2J8MAAuCAQF5mIDv3TqAx0hatFKNxeEGxBDG9M0Q4/e7U7ZP+3nSxbpzaIEl//8Q/Rvul7GxjAc0mLTucC7XhBHiGlNkWPAkkUYqBkBRDJRPt1fqsDcpaHqVwVWqAemtv8/uB17ZkY+vR2aNREE3mNwxCV5TgUNm5dYHEL8P+aQmH+O7ibsovC/iZmY/I/zRX+WaNjt47WbIfIUdFmXwp9hw4tf1bHW2J+kRJRayvaClOlZ0uDz3XfJ8x07QkM8fIfezy0b1IiZJtDCZ/2siR1nKvS0xdWUeeFAdP+F62LWCBDg2stRBeUL
 qfhffAHk
 ZsQfanTHiauYNoH3LESs6gP5MUC13h9izn3oiOdpkhhSh63VjWy1XK64CK9yTnTsdTW6rHFFluDSeVDLvD537hav7dEATZQ79JBMRZYvNcvCkI/L0n6yrjQRKlP6WvPj+rG2ObQ7a1Jc+arrHkhAx2/O+I+XKhZvC25CURp1/U3koCdh/R11RQeP/DO5mLAIngio5G5UOwMHutAuZ08Vkn6oPliQ6j9dbl3dMiMUc2Ajt47DO0Am6CQploNT4e7l5PDnQkikBG1zbjwjescxFctj8B4UHjWaNlCsKSwzMMDZnjI3jfJO+lWhtYm6pwXlQatCsUt4lItzHTt1+AjOjuHNXkD5LL8T9V8CpvCGL1UjQgX6yO0oRAXpmUZCUaGCxBXlx2HtaxMfyCiNsBVPlJCdlHbq2deA4fwZ+GoyCkt4IaX0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 8:14=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 11.09.25 09:17, Barry Song wrote:
> > Hi All,
> >
> > I=E2=80=99m aware that Lokesh started a discussion on the concurrency i=
ssue
> > between usefaultfd_move and memory reclamation [1]. However, my
> > concern is different, so I=E2=80=99m starting a separate discussion.
> >
> > In the process tree, many processes may share anon_vma->root, even if
> > they don=E2=80=99t share the anon_vma itself. This causes serious lock =
contention
> > between memory reclamation (which calls folio_referenced and try_to_unm=
ap)
> > and other processes calling fork(), exit(), mprotect(), etc.
> >
> > On Android, this issue becomes more severe since many processes are
> > descendants of zygote.
> >
> > Memory reclamation path:
> >    folio_lock_anon_vma_read
> >
> > mprotect path:
> >    mprotect
> >      split_vma
> >        anon_vma_clone
> >
> > fork / copy_process path:
> >    copy_process
> >      dup_mmap
> >        anon_vma_fork
> >
> > exit path:
> >    exit_mmap
> >      free_pgtables
> >        unlink_anon_vmas
> >
> > To be honest, memory reclamation=E2=80=94especially folio_referenced()=
=E2=80=94is a
> > problem. It is called very frequently and can block other important
> > user threads waiting for the anon_vma root lock, causing UI lag.
> >
> > I have a rough idea: since the vast majority of anon folios are actuall=
y
> > exclusive (I observed almost 98% of Android anon folios fall into this
> > category), they don=E2=80=99t need to iterate the anon_vma tree. They b=
elong to
> > a single process, and even for rmap, it is per-process.
> >
> > I propose introducing a per-anon_vma lock. For exclusive folios whose
> > anon_vma is not shared, we could use this per-anon_vma lock.
> > folio_referenced declares that it will begin reading, and Lokesh=E2=80=
=99s
> > folio_lock may also help maintain folios as exclusive, so I am
> > somewhat in favor of his RFC. Any thread writing to such an anon_vma
> > would take the per-vma write lock, and possibly also the anon_vma
> > root write lock. If folio_referenced fails to declare the per-vma lock,
> > it can fall back to the global anon_vma->root read mutex, similar to
> > mmap_lock.
>
> To summarize, are you proposing a similar locking scheme like we have
> for mm vs. vma here for anon-vma root vs. anon-vma?

Quite similar, but with the optimization limited only to exclusive anon
folios.

The main issue is in folio_referenced(), which frequently takes the
anon_vma root read lock. Complaints are likely due to memory
reclamation holding this read lock=E2=80=94if the process is preempted, it
becomes runnable but not running, while fork(), mprotect(), and
exit() may be forced to wait. I haven=E2=80=99t seen complaints about
writer=E2=80=93writer contention, so I don=E2=80=99t plan to optimize write=
-side
conflicts at this stage. In short: the problem is frequent rwsem read
locks that get preempted, blocking fork(), mprotect(), and exit().

If a folio is exclusive and we already hold folio_lock, it should
remain exclusive to a single process and a single vma. In that case,
such folios may not need an rmap tree at all for folio_referenced().

I=E2=80=99m mainly concerned about cases where a read lock is held but neve=
r a
write lock. As long as a folio is exclusive, stays exclusive during rmap,
and its rmap node remains present, there=E2=80=99s no need to modify the rm=
ap
tree.

When changes are made, both the target being modified and the
anon_vma->root should be locked. We are not altering writer
behavior by requiring the anon_vma->root lock.

In short, I=E2=80=99m seeking a simple way to avoid taking anon_vma->root
during memory reclamation for folios mapped exclusively by a single
process.

Thanks
Barry

