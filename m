Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71BF1CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 18:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8FB88E000C; Thu, 11 Sep 2025 14:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67888E0002; Thu, 11 Sep 2025 14:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA42A8E000C; Thu, 11 Sep 2025 14:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A753D8E0002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:22:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D9E3B9E64
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:22:53 +0000 (UTC)
X-FDA: 83877790626.11.43E0E21
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 66C1280016
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:22:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e3Pp2YDY;
	spf=pass (imf30.hostedemail.com: domain of jannh@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757614971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qE61fKYRVAesGrmxKPgFBboNYBgbe0fJ+ENHit7M1cs=;
	b=KIJcUi6Kr9Vh/N3lSmRh1nco62Uf1pX19ziOZ5quM37cBgsuQWEtS+jJwoE2ikLTDeCsrN
	R3Lnazj3RtluFO4B74evlUVHR/Eop03aaaBjG+DuszgrHqDs0WMs8Z8ouIs0aiqxnZMaBA
	ahXK23c0V7TMDFNPrFUwqafdBg30sls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757614971; a=rsa-sha256;
	cv=none;
	b=ETqruEV75FiibmmZjgYzPqKIs6Q/qmM12E/yR2FD5sgnxMXU2xeacsRZ+wrXXfLfvAoUQl
	FGPRZNJq2axMSjL0jlPIlVuK1AOcn4TVTSM4Z0u+VLGAcJK4D9XfN7AmUoVsq6HtrgiZL3
	RdBHKWjQKvxa1VXSxVzhyKFg4akDY6E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e3Pp2YDY;
	spf=pass (imf30.hostedemail.com: domain of jannh@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61d14448c22so1725a12.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757614970; x=1758219770; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qE61fKYRVAesGrmxKPgFBboNYBgbe0fJ+ENHit7M1cs=;
        b=e3Pp2YDYMbhHwiL1ZmoiplXGgx0I53Hkw9cUGOV1iOPGr8dyHbxOhCwceOCrvl+D0i
         BWvua9hgWorMSgNJZqQZGBd33ttxRZkNo9hy2r21dZp7DRIReW8TR83lhEd4xz5LktUt
         ATUaRwmmzE2DEXC3C5roPXWf+Wgf/oZBdIvbigQHagV0Uj8qOck3NV5RGvBW6yb6WyZx
         834zWVpPEXZv8LgQv4q/NSQgpZfcs716wmM0uqZuF/26ZMFKfhVG16lxIgDXF2TV4w7F
         IT0Pmu964oQcImqlirq7x/ERipzy/o/zAqTIAXkt2kLTTCH6AQY3Pjat/X5mb0qoHojo
         cI7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757614970; x=1758219770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qE61fKYRVAesGrmxKPgFBboNYBgbe0fJ+ENHit7M1cs=;
        b=JegfAN1/JsY0CSX51JksMVUSLTWr1hqRyJWWQeEeNwZAsnnB4tUFVJXTuso1WmoDeG
         S/etBVY/LccCg199o3PBWxchuroilWwUtp1ftseVREdDRmWH8YTV3Qo6N2jcL3Q7ciVS
         HFfAFr4Nsi2Yk5qjz6bK+WZXDmspMvlnS2/5ED4AUDS6qsMLkyh5Jan7SzGtq5DePg3R
         tcnNjquxrhtw2v/KQhVr/pW6UYzia282M6SGaQNDoNF1g4qCiFWlpnbKXzY4dFJMjQ2P
         VRnrJLKdx7ioidaOLmkmSmShFQOYa8rl+ofOyr4WgdjokOYg16KASl2itaws7GdB97Al
         Vmng==
X-Forwarded-Encrypted: i=1; AJvYcCWbYoLBV0hO4agfqWNCr1kAA0dlbR1dBnXTzTUPFuWIVBZYa6VH5SR3ZFVI0J3jaSWj21Dii6Gi8Q==@kvack.org
X-Gm-Message-State: AOJu0YxMltlM3bQBSX/gYgZ8ybiRpTLayV0nPEiG872WL/jtP/Tt3+R8
	zQOXGnebUJ/LyXqW5+uEnP2sfblFLGlYVhEtDymiT77ZyEFy7EdZXrpDcM6Wc0Io4ja49C61riQ
	SJUINuWWrdjczeFpOm9Ws40SMqzKfcawxzYAvkS+q
X-Gm-Gg: ASbGncsy4hkWAnKFEQbo3xkM/ebWzGJdhHJ58QG1D9w1CaHPF153gkwJit1fwPyRNBH
	r6CJQdq1YvErlIFKQktFcOxbxI51vZ8qJ6VCbXbsNnlRXCug66aOmm1q6tTksES9lIwyjKqdHjB
	3oIJ6+lH9fuouko6kDOTkGEMiUidDPJNK1xdztnuDFR47RGgHc+UxXifF7NHIkod66vKhYS5zfc
	R3vAGMahe6NkCicSzbTqczngOZQFabZtBDlpgNJH6r6xrd36VUGHQ==
X-Google-Smtp-Source: AGHT+IGGAFNa3RlsEZ3+NsJPUAPkvJ93APIrpnUe4WN61US/IV78Und4s4nz0qAScAK1LbRKUXE4V7lSSOd34RWcAnE=
X-Received: by 2002:a05:6402:21d4:b0:61c:c08d:359d with SMTP id
 4fb4d7f45d1cf-62d27d84e7amr299686a12.4.1757614969630; Thu, 11 Sep 2025
 11:22:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <a67129f8-9ff6-4109-bbbf-4209f6dfa3be@lucifer.local>
In-Reply-To: <a67129f8-9ff6-4109-bbbf-4209f6dfa3be@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Thu, 11 Sep 2025 20:22:13 +0200
X-Gm-Features: AS18NWA-HgezoKxOMqo-4_1AO712FKB9ja-7Kq57_pjRDfGwq3QTE-DlNNWLqcg
Message-ID: <CAG48ez0GVWV024kPe6kSV8c0LO7coACYXf9-85iqw+T+paUi3Q@mail.gmail.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Barry Song <21cnbao@gmail.com>, Nicolas Geoffray <ngeoffray@google.com>, 
	Lokesh Gidra <lokeshgidra@google.com>, David Hildenbrand <david@redhat.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Linux-MM <linux-mm@kvack.org>, 
	Kalesh Singh <kaleshsingh@google.com>, SeongJae Park <sj@kernel.org>, 
	Barry Song <v-songbaohua@oppo.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pg8jmyq3987fjp6ig7yahpf948uzeohx
X-Rspam-User: 
X-Rspamd-Queue-Id: 66C1280016
X-Rspamd-Server: rspam10
X-HE-Tag: 1757614971-380018
X-HE-Meta: U2FsdGVkX18K6GCsNWqI0IRlWLQw0TSGP1RQ9DnXXmP2cOoZ2Sk3c72mdyMrzmDvB5je41Kp9viNVbO7pydim8o2ygj9MQs6tcDIZUzdu2mWLWYGjs6R+sFKE02VGAjuMq9rcjhGW0F7rdntligVz1RzHZZaGwL1zRFCDFKOV3fUWc2TNt6V9AcPMaHwVBcQbfDtw6+lQWbuwKxyUz29iD06+Mx24Ukp69OFW1YAKRlEWwHXS9iTcRaYWgoZ8bEo2il1zD4jKQQgYPSiMuJuMSwexJy/fBw9DKcXlkgcI0k9uFT2N3AUKE5VsrV+Tc+5VJi50sVkxHUD6IKWj+2oJeZOO6Ydph1lhCAvuaemFvo/cvuaRmwnls/07llMgWUZVc0MRLvOFWoJOkYDgXWT+wFUZaP6DWWQvmyWuE1WRYE+b1gHUQmHaLLQIC2T9zTQ2Wq40w+8ddMoanZJgtN5JREXDtDRhdlYdF70gBsGEDtGJCpZ0H2xgSVZl7TpKbRxkRbyxvcnFS8YvzlHsfWEMbmFWfbmKXeHF06XyPO1w0rGplW463XypwXAttWPo4BQW7M51/k+8gDKE1n2KFdTeOUoP7mLMXbLh4BHltvncDZ3/cehAmZNqrmMcMZpqnaSvXFJO3THnEO+f/a/Pc1pDmtyWMQ4LgokkeCt5hNF5s4ykvyu44hqeU3QXZ/caYmK6wp4xzcUnTzcyjXpoKjnSFkFQEKK6yIp2DURLHMpsIqF3c+SAu3Lu6EPE9KdUY8zRm6JzETOYaig2oUJ8ioIEGGeonREKqHvXjqBYbxneE90r27iCkX3CSA9LG8qo25djvUdUrt0Ol/ZzWYiaqTjcGLXpCma0P54ZzCS6nSZ5H+fKNWCZelpONqmxbY+dFmTG8VwfVgJgjJGXzDs2aiGf7jryWJXW2sWE9dmKUcrDIJjzeT70/EGLObMOsfRLLEHbKVQb1ObAupXZigYeLq
 85VCgA0h
 I7PE6bu9CbcyejOwFUhvzt4U6ZfGDCi/JbsiYAGK419Zu+r3ASSo0CsUP9TkbrOLmafES3ZnyLcqdvN3/RFD7o4X7a4EjE26p1yeI6hmqJJYzoHSocG9WQMGgg77igUCPbt7OGF96vnEQyLcvIEfN9jgBE1CD1iPUaj17zrtOI/Rhn9763+eIZ1LAfs8c4vcV5Ex2MFv7MB6emwBXf6L0RSssrvrDFlMe8K5WW0WSXYyCvf2YBSOo9yWaYguFLMijf1Net+eusvlKflI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:29=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Thu, Sep 11, 2025 at 07:17:01PM +1200, Barry Song wrote:
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
>
> Well, when you say lock contention, I mean - we need to have a lock that =
is held
> over the entire fork tree, as we are cloning references to them.
>
> This is at the anon_vma level - so the folio might be exclusive, but othe=
r
> folios there might not be.
>
> Note that I'm working on a radical rework of anon_vma's at the moment (ti=
me
> is not in my favour given other tasks + review workload, but it _is_
> happening).
>
> So I'm interested to gather real world usecase data on how best to
> implement things and this is interesting re: that.
>
> My proposed approach would use something like ranged locks. It's a bit
> fuzzy right now so definitely interested in putting some meat on that.
>
> >
> > On Android, this issue becomes more severe since many processes are
> > descendants of zygote.
> >
> > Memory reclamation path:
> >   folio_lock_anon_vma_read
> >
> > mprotect path:
> >   mprotect
> >     split_vma
> >       anon_vma_clone
> >
> > fork / copy_process path:
> >   copy_process
> >     dup_mmap
> >       anon_vma_fork
> >
> > exit path:
> >   exit_mmap
> >     free_pgtables
> >       unlink_anon_vmas
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
>
> I'm not sure how adding _more_ locks is going to reduce contention :) and
> the anon_vma's are all linked to their parents etc. etc. so it's simply n=
ot
> ok to hold one lock and not the others when making changes.

folio_referenced() only wants to look at mappings of a single folio,
right? And it only uses the anon_vma of that folio? So as long as we
can guarantee that the folio can't concurrently change which anon_vma
it is associated with, folio_referenced() really only cares about the
specific anon_vma that the folio is associated with, and the anon_vmas
of other folios in the VMAs we traverse are irrelevant?

Basically I think paths that come through the rmap would usually be
able to use such a fine-grained lock, while paths that come through
the MM would often have to use more coarse locking.

Of course paths requiring coarse locking (like for splitting VMAs and
such) would then have to take a pile of locks, one lock per anon_vma
associated with a given VMA. That part shouldn't be overly complicated
though, we'd mainly have to make sure that there is a consistent lock
ordering (such as "if you want to lock multiple anon_vmas, you have to
lock the root anon_vma before the others").

