Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D10DCCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 22:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ABFE8E0002; Fri, 10 Oct 2025 18:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85CD98E004D; Fri, 10 Oct 2025 18:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778AD8E0002; Fri, 10 Oct 2025 18:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6562E8E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:09:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 060731404CA
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 22:09:33 +0000 (UTC)
X-FDA: 83983597026.03.4B0E745
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2F398180006
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 22:09:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cFAWM9mU;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.166.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760134171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWDl81NsDb6bdxq6lZZ3Oo5fI0gR9e+s7CI7q6rmrnY=;
	b=OeX0nGH6pec1C50Dymuwl2OjQpPCmA1TulC8lXqAj0wdt+ZTWsGx4mWRE6zJAamKK58rQH
	uolg2nlyeBbTNyjtitCc72BkQZ1rkmrP2DgMteeEClJkQVqAtxm+YbuQaSekWVrFRUPMIa
	7wgND8YBS9kJIHiBCe9sWWRAql37EbI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cFAWM9mU;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.166.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760134171; a=rsa-sha256;
	cv=none;
	b=hb/XTmlWlKOjMxFhDApiCJw3dIzZcAPnroEQRWoAQ7Ds2i/ZzUStwklTEM/3SQWtiaXfCe
	RiOo3s/apMHvWgyW4slmm/Nz6yHcByGt142hln50WTCDo5jSrV2CXMXbd7u/OcJsZc1851
	g/kHcC89xayTkl4VJPO2aVz+wt9WwCg=
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-42d7d0c58f9so33145ab.1
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760134170; x=1760738970; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWDl81NsDb6bdxq6lZZ3Oo5fI0gR9e+s7CI7q6rmrnY=;
        b=cFAWM9mU7n6qS9yEJFrPIM7G7SzjzpDs53t25wqKnVO+hiF2RG3AyCUKSqLPM6CoRz
         9Rb+n7vZvCpEexAAKxEfd5OYG/WDK7lSejuvXVFUjp0rr4FsXwMQnz86Iyinn2B6FBkC
         rC0QHT0MQo1ZaRqEy1Mt5M2eI/ym3YCVzT/7q0KS5TXgKOUqQgHB4K+SRke64Q/vI66s
         kAVebwF40i9xu/SN0hQI+Pmdapue5QFaAZ0p0dooa0Meg/EHmvYOJ9JFglK9FZRz6c9+
         CvjMlsakBqZc148xkMjt26vGIZabNt3nz32Ci26ZxhJgS6EwdlXGzPW5ocSXGCVkhh7u
         2bFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760134170; x=1760738970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LWDl81NsDb6bdxq6lZZ3Oo5fI0gR9e+s7CI7q6rmrnY=;
        b=FxGeJ6WF/GpTecgbu44LM4cN6lMS2ndqWIU/58000T4daHOgLyLIsXdVTrEUUukKiu
         JL2AbUt37z2uug0AO5ZakjGWbr2PzQaz33h/4OUF6QaBBxJtva/Fux1OC8XFyAJrt9GZ
         2hc+YSwzkZ0c7Hdx0zdJtMX3r68346hVrhgM1an5zdvkxiK/vZCi+dLOda58zS+8dkI5
         k6OJCmLkLCJpHBtWS6Oe9yeyuNPn1/uCS/vS/8oNawaeJK3tadiQtrh3Z0SvtyPvpEtc
         F0tZWHmwZimv8gY2S4FdJv/ddX9gaKzWDU4kMcJwDnWfgzKScf5bFM0Duf5VJ7XNDxQh
         3wpw==
X-Forwarded-Encrypted: i=1; AJvYcCUuT9DMb4reBmDsjWAlb5SpJwM9jn/RUphWvrSd3TGo+Qco1deDcQd+46ASHL0k77gbGV85rEzGaA==@kvack.org
X-Gm-Message-State: AOJu0YwHpcqGLGCmozW0K4v/Q0ueRcbLZEzIeGzZuNUi/q7zvAPaec44
	98zWIewudyJDT6FRDEfgl5oN7D0pJytSHuVq6mwmfq+tuWGJIL/jklR2WMj7FGWxeYodSVm/OA8
	4Hg+tqBvKIK9RddOsPjlv8sUYOFCa6O2RMn7jeQG7
X-Gm-Gg: ASbGncuJ2N0zo8I8p4Hf5abB+tgpPgcMNYX+bJp+YoZMOBSbUbR+ZAeBM00OpfRPBzX
	zHFzD2qtjqTbfkwLjnLtxWXAKN6W3CiUMuLkKykiNILyOLLku5GllibxQ37gIsxJLeXDIaUcpt2
	XsXLZiyp9IEsbx2anemIzhuJ/HIn3pRDfEV32ZK21d+3mhCrnlRPa7fVpnSwU0+/xp7L0aC4XrU
	Br/bnJ9OUznVbBbWKr4U+ql15NtPy8=
X-Google-Smtp-Source: AGHT+IEheEysfffoa2UToJd25UhCG01OYZFDrESO0ecdrZ/jfSjqLqSlKoaOdjO8BC9OyiGuvNfvS8dJfmUrxJvS6qg=
X-Received: by 2002:a05:622a:1111:b0:4b3:1617:e617 with SMTP id
 d75a77b69052e-4e6eabcef17mr26585351cf.11.1760134169530; Fri, 10 Oct 2025
 15:09:29 -0700 (PDT)
MIME-Version: 1.0
References: <20251010011951.2136980-7-surenb@google.com> <20251010202034.58002-1-sj@kernel.org>
In-Reply-To: <20251010202034.58002-1-sj@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 10 Oct 2025 15:09:18 -0700
X-Gm-Features: AS18NWAqrvtXxssXuPoUdtLG3YkWXccAtAeaTjudhXcSXDHpPbRX_NTpHoxKXI4
Message-ID: <CAJuCfpHmLpE-7U2_efn9XqK=3SM+zRw-jUkDgJRBW=2tWZTepg@mail.gmail.com>
Subject: Re: [PATCH 6/8] add cleancache documentation
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, alexandru.elisei@arm.com, 
	peterx@redhat.com, rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, 
	axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	hch@infradead.org, jack@suse.cz, willy@infradead.org, 
	m.szyprowski@samsung.com, robin.murphy@arm.com, hannes@cmpxchg.org, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, minchan@kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2F398180006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: jm5it6es79dc1qy9s69ky99i9cahdu7k
X-HE-Tag: 1760134171-931688
X-HE-Meta: U2FsdGVkX1+SBwig/j6tVEtRpbFF0O1odJk8OQaT2gJyIYP7gAmJBMdp+eaVEZ7R0sicVgHwW3cGzGfTK16aU+fEMhJqx0RFm5pqlPaRYqHPaQRAaUsjiwPhmjhd++oYHDftHMv/vnUgQR3bGKmjhQtny/XlDRFIyW9aM+I/qCLLcQhtSJDdNKKPB4Nu3NYBzofeeS3ou2BO3qf/+jW5naPWbHjEU1rw0hnJx5pV86Q/oBDFw0KuDsvH8AChebNQQnS4KqhU4ja1a9R9SmXlLNAXg7f1wlaOCc/6+ym6jRlig5YZDGNey/HnwgvokUa+ClG8jzr9LTxNZs+NZCo/UTqe+QiIjm6q/hBvTjvtsIjRjSPgbRXdRUqd7pAYpNKKU5hHMqJJqbgpleFw30K0qB0VUJDsjI0gOBicD12oPAx9q+OU5oXBnQdCgfkWHe+gf3ZBd0il4mrW36JFkkATG8PhqPb8HGDAtlgfzueCiRWHKm8akVlHOAr8krSZ5aRzqYJfwrAtrAfsVgWT7RZoSWUMeu2oKF17GLyuHLeeE6hUZ0maBgBrBMBPFflZ/7bYiUDAKUIgR3J9zZtt8eNGhNIY8rra7OOg9TryPaY8q3jJALQpF1H9BQweinPoEt5XTv4KC/PSe8y5VeuK/zg0JoLVAvYMeeKUH+3bx4xMmrGCYYl03itUtB+tVTu2NsUd/wjX482p1FG3odE/JdAFnH/iZoBIUTDCO37B8Z8L563Ee+Xq6a/4Pex8KA8dL5SIBTJMj+WJ55FUyM0HkuL6H7s9qbQoEzWebM5xut+6zeFYHMKGfl3xNO6+brxe9yuI7HsD3NlWSY9LEmMWwCJ103zGvr/vR1CyRNbVxwvt88gLSnf5rTes206SNmkeIc21Zf+w5ceha9ogn2iY5b1rwuxSxS8db+WYFAkXIVUGk6MzSyLLLzJ407nd+yUl2D6E8DHZxz7v/9kzo6Vw7Re
 kmD97qHz
 vuIzHN4GweYy9tdKC91T38/qCy4vzi8+FSY1qgnC7lcmCWCcrJ2hwkzadhiGgB3vXPidjiDEK41OKOzTXe7B7aEovXfsiwLVFvhf/DT/T87V843XwsDLIlEVcgiID0q3yzl0V4nCNNQVUMIKRBljnc1RKCGOxwtirNcM74LcBQY7wwub2l/5OXgM93VwdYnOTLdK5vPuP+XEbqP3UU5qTgn5UYnsBIE1RVPsGLL0EXCGpD84tzf2t0iAUlw6JOjnMYJcAGHmvSh1x9vFI7sjpaVkiyov4KEgIUlXauz3dl6kMOgw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 1:20=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> Hello Suren,

Hi SJ!

>
> On Thu,  9 Oct 2025 18:19:49 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > Document cleancache, it's APIs and sysfs interface.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  Documentation/mm/cleancache.rst | 112 ++++++++++++++++++++++++++++++++
> >  MAINTAINERS                     |   1 +
>
> I think this great document is better to be linked on mm/index.rst.

Ack.

>
> Also, would it make sense to split the sysfs interface part and put under
> Documentation/admin-guide/mm/ ?

Hmm. I guess that makes sense.

>
> >  2 files changed, 113 insertions(+)
> >  create mode 100644 Documentation/mm/cleancache.rst
> >
> > diff --git a/Documentation/mm/cleancache.rst b/Documentation/mm/cleanca=
che.rst
> > new file mode 100644
> > index 000000000000..deaf7de51829
> > --- /dev/null
> > +++ b/Documentation/mm/cleancache.rst
> > @@ -0,0 +1,112 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +Cleancache
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Motivation
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Cleancache is a feature to utilize unused reserved memory for extendin=
g
> > +page cache.
> > +
> > +Cleancache can be thought of as a folio-granularity victim cache for c=
lean
> > +file-backed pages that the kernel's pageframe replacement algorithm (P=
FRA)
> > +would like to keep around, but can't since there isn't enough memory. =
So
> > +when the PFRA "evicts" a folio, it stores the data contained in the fo=
lio
> > +into cleancache memory which is not directly accessible or addressable=
 by
> > +the kernel (transcendent memory) and is of unknown and possibly
> > +time-varying size.
>
> IMHO, "(transcendent memory)" better to be dropped, as it has removed by =
commit
> 814bbf49dcd0 ("xen: remove tmem driver").

Ah, good point. Will remove.

>
> > +
> > +Later, when a filesystem wishes to access a folio in a file on disk, i=
t
> > +first checks cleancache to see if it already contains required data; i=
f it
> > +does, the folio data is copied into the kernel and a disk access is
> > +avoided.
> > +
> > +The memory cleancache uses is donated by other system components, whic=
h
> > +reserve memory not directly addressable by the kernel. By donating thi=
s
> > +memory to cleancache, the memory owner enables its utilization while i=
t
> > +is not used. Memory donation is done using cleancache backend API and =
any
> > +donated memory can be taken back at any time by its donor without no d=
elay
>
> "without delay" or "with no delay" ?

Ack. Will change to "without delay"

>
> > +and with guarantees success. Since cleancache uses this memory only to
> > +store clean file-backed data, it can be dropped at any time and theref=
ore
> > +the donor's request to take back the memory can be always satisfied.
> > +
> > +Implementation Overview
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Cleancache "backend" (donor that provides transcendent memory), regist=
ers
>
> Again, "transcendent memory" part seems better to be dropped.

Ack.

>
> > +itself with cleancache "frontend" and received a unique pool_id which =
it
> > +can use in all later API calls to identify the pool of folios it donat=
es.
> > +Once registered, backend can call cleancache_backend_put_folio() or
> > +cleancache_backend_put_folios() to donate memory to cleancache. Note t=
hat
> > +cleancache currently supports only 0-order folios and will not accept
> > +larger-order ones. Once the backend needs that memory back, it can get=
 it
> > +by calling cleancache_backend_get_folio(). Only the original backend c=
an
> > +take the folio it donated from the cleancache.
> > +
> > +Kernel uses cleancache by first calling cleancache_add_fs() to registe=
r
> > +each file system and then using a combination of cleancache_store_foli=
o(),
> > +cleancache_restore_folio(), cleancache_invalidate_{folio|inode} to sto=
re,
> > +restore and invalidate folio content.
> > +cleancache_{start|end}_inode_walk() are used to walk over folios insid=
e
> > +an inode and cleancache_restore_from_inode() is used to restore folios
> > +during such walks.
> > +
> > +From kernel's point of view folios which are copied into cleancache ha=
ve
> > +an indefinite lifetime which is completely unknowable by the kernel an=
d so
> > +may or may not still be in cleancache at any later time. Thus, as its =
name
> > +implies, cleancache is not suitable for dirty folios. Cleancache has
> > +complete discretion over what folios to preserve and what folios to di=
scard
> > +and when.
> > +
> > +Cleancache Performance Metrics
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > +
> > +If CONFIG_CLEANCACHE_SYSFS is enabled, monitoring of cleancache perfor=
mance
> > +can be done via sysfs in the `/sys/kernel/mm/cleancache` directory.
> > +The effectiveness of cleancache can be measured (across all filesystem=
s)
> > +with provided stats.
> > +Global stats are published directly under `/sys/kernel/mm/cleancache` =
and
> > +include:
>
> ``/sys/kernel/mm/cleancache`` ?

Ack.

>
> > +
> > +``stored``
> > +     number of successful cleancache folio stores.
> > +
> > +``skipped``
> > +     number of folios skipped during cleancache store operation.
> > +
> > +``restored``
> > +     number of successful cleancache folio restore operations.
> > +
> > +``missed``
> > +     number of failed cleancache folio restore operations.
> > +
> > +``reclaimed``
> > +     number of folios reclaimed from the cleancache due to insufficien=
t
> > +     memory.
> > +
> > +``recalled``
> > +     number of times cleancache folio content was discarded as a resul=
t
> > +     of the cleancache backend taking the folio back.
> > +
> > +``invalidated``
> > +     number of times cleancache folio content was discarded as a resul=
t
> > +     of invalidation.
> > +
> > +``cached``
> > +     number of folios currently cached in the cleancache.
> > +
> > +Per-pool stats are published under `/sys/kernel/mm/cleancache/<pool na=
me>`
>
> ``/sys/kernel/mm/cleancache/<pool name>`` ?

Ack.

>
> > +where "pool name" is the name pool was registered under. These stats
> > +include:
> > +
> > +``size``
> > +     number of folios donated to this pool.
> > +
> > +``cached``
> > +     number of folios currently cached in the pool.
> > +
> > +``recalled``
> > +     number of times cleancache folio content was discarded as a resul=
t
> > +     of the cleancache backend taking the folio back from the pool.
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 1c97227e7ffa..441e68c94177 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -6053,6 +6053,7 @@ CLEANCACHE
> >  M:   Suren Baghdasaryan <surenb@google.com>
> >  L:   linux-mm@kvack.org
> >  S:   Maintained
> > +F:   Documentation/mm/cleancache.rst
> >  F:   include/linux/cleancache.h
> >  F:   mm/cleancache.c
> >  F:   mm/cleancache_sysfs.c
> > --
> > 2.51.0.740.g6adb054d12-goog
>
>
> Thanks,
> SJ

Thanks for the review!

