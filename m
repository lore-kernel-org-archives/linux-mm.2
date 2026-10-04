Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9883CCA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89DBF6B008A; Sun,  4 Oct 2026 13:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84F0D6B008C; Sun,  4 Oct 2026 13:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F05D6B0092; Sun,  4 Oct 2026 13:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42F726B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:10:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD23D160B78
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:10:54 +0000 (UTC)
X-FDA: 85285583628.27.4636F05
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id CD6D31C0008
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:10:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HEGjPltl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791133852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXFwGZqE64cDzbgwSCh2JqwiAkclwFSYOp8vtgN8R9U=;
	b=JiGSXoaWpt7CLfaG1b9NzDrqudLSrjV2I47/URb5itROkrF1uCwSc635GcKS4FR+xfGX54
	RT6IyOxXU+3Bw2XeF09Mu37RyuhOn1YAIEGcepmKwmEBaRBoziwGRjqQxZpQzqJ63+cnw9
	1xcoMe1rpsCzp+sZHqwmkwZP6vvZ89A=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HEGjPltl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791133852;
	b=7nYWoCh+Ab6gRRZ1pKXjP6UFuCBn1JtFoAlEwJkt/CfuAUSxgrOBr/m5FcJ9BA7D/HWkh8
	knVLq9R2GWxR0DaGyw+aBsjJKTtPQR2HGFVBcpknnI5HN+oOHUGCLS3Kj81ToaHvBu9Ugm
	rLmcCJTrcz2sDBHjeHjFM9ZKlQE2lEA=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-533202fe429so244611cf.0
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:10:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791133852; cv=none;
        d=google.com; s=arc-20260327;
        b=ZBzKvZHZLLy4k1VoyUz6NK7ffK+UESmmKKk1gTo9yL4uKUncrEsUXr8IejfWkpOa2C
         ScTcN5KnRsH6TmIpW4WGWPjXTlSrnwU1ZfgbzecdQIO/5Ow2136JTHl5bDSSy92C3H3H
         phrJ4AG2mTCCSs5JewwaGiKTafQ44vlXSgeEGSA4P6TlYxH8VZhKGhbxLJ5bV0hS137j
         If4fQxhAifH44b5b8eAkMbBTLanQ8DbAPkvvnuDil5pyQfcIoDsZUyYnuzyU/9qSSN2h
         Oj0JsMfzhGHuMrLCz6KaTsmf4kTunVLcq+zmcL+flffjBsgt+9oqDABZTNVBdOLUR7rl
         oZjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nXFwGZqE64cDzbgwSCh2JqwiAkclwFSYOp8vtgN8R9U=;
        fh=giykR2v2DikbjLFblSvlbpGKZVlvq1wk9ayRSkAGp7c=;
        b=fjm7tv5/OD16Hmykw4qH3VnWsvqqfWTUMjLaKRMj1XAyHrFduDrjWdErm5QKLxV+OP
         BXzBMewmvuGkmLzx1ANVlYnZadkRYEfsYW7sgMD7yAySJ7XY8mMCVzAd9qYh2c5xEoFC
         EBFbyGIHKki1nCe+7DmmNnSWPd9xCs1HXsNyvyh/Syf0Po1UdGpzulkoxnjTv08O11jq
         vEbt1dAJCB/VBYHsX9Edg1UzizabW0aXS4UxuXgZTjn+GxLHqF0Tl/tVvDc+vFSjkiVm
         cg2/yhm/VexC8AhRjt0GJdJ4offrf0xLsThuT9YlneVQotD8SEdM+dg+mha3S1idfzxf
         r42Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791133852; x=1791738652; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nXFwGZqE64cDzbgwSCh2JqwiAkclwFSYOp8vtgN8R9U=;
        b=HEGjPltlzif2KsO3G6tAlFh60Wk9Un8eWPTWX3z9uJMllVjU/8fWFnOXRauNuBiEXQ
         G5NEpdh0juahayD6JNZRKPWaJhJ+4X8VSuCIU7FoX7jtDNLsfKdw0oNQjd572Zy/bYj1
         FSxMtsfN5ELkg+tyrVDqHfz6ZEHjro1iZYKKIILo8+rJC4JZ27U7yco+s6bVQBWEDrX+
         5SNPZbtG8jPHuvAEnj+ObQVDT1W9PTnSRrMdC+YzCu8Yrvpt4jHkVfraFasaJsHpsC+s
         hG+8806t7MHogitkHdIFyLhRGE6hAmWXyvSvTqzjJmcTZIRXWAxn1VfCSJlQcSNBmVmM
         xGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791133852; x=1791738652;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nXFwGZqE64cDzbgwSCh2JqwiAkclwFSYOp8vtgN8R9U=;
        b=HXfp+Qx4BqB7+Dv4o3wLEJ443O1W541baqNq2Jj9CfjJQ+EcgMPZb0cQkgxaaQqDyA
         l5ZNtucJOIUvpWpiA23j3cP/z9SYkvBJN+9uw0yiJKp1Xpcwjx0pMiYIzlxp6vqv+R3R
         /iJVloE92qYPFOKiIo2Y1A1O71W8GFNwivhZGT9QV//LQZQbccBGGrTnCKEX1axDxrT0
         TMgTO2la/o8LJNzAboVyF4+2hYI4EjaGYEIkNIbLdjvJtPWJuJ3878yA8k7CH9W58DMM
         yjw5dMDWo9JrShwXculWie90SdCZKyTvxl8gRSp3oDHIHUy1RvGq4Y3sQ9FdnBeFzXEr
         VhvA==
X-Forwarded-Encrypted: i=1; AKwUvBwlhpvKjroM87ABXgLNs248grXFSZ1/NbOudWv7xX60XnUW8aSJcrf5OD+s+FXg5s2qk/Xb6ArBFg==@kvack.org
X-Gm-Message-State: AFuF++kbMxYa5+mcMbv66acC4MkBO9HHLaQQHfXCIlr+iRjPcSdGpVAq
	o4nDYUn/97mDFL2dI/ovaG2Wa9cVIKXFR5Y3uZNfQU4uE2lwzfpGGj/zhnJBXHT4JO8b1fYIoEj
	3+npOyUmq8BbgceTaI4LYYI8zgyB+PCt52maYQQsf
X-Gm-Gg: AYBFou0Q/0NbsFZshDd5GuXLAwkjTsLh6nJ7mAEeb8id6835EqVntQZfHqiuZzXejFs
	O/QUNm0g8/mejYtoqwxIga7mhosbG5r+HrczDcOjeUTNIGKbwpDyZ/EZ/R/V0qYGwEKt+31RIUS
	a1invTBzwggHM5lioG8ma2+ooSxI3mUauwg8qo30kUTg3cbNWu5Q66z1Bg0999zz59uEt54ccPS
	3WylUbQTBQFhm/Gy+229in1NEjgurWXHnqXKmjtqqEw39AU/rRlTClao84zaJzreOWgoe+i+Ynw
	EBbtj/hem2QIhI7MAessfkR+uMtquvFLK5MmKOkx72Z+bXtaTxV3xYgd
X-Received: by 2002:a05:622a:2506:b0:52f:9ed4:8d75 with SMTP id
 d75a77b69052e-5351497fbecmr18649011cf.15.1791133850875; Sun, 04 Oct 2026
 10:10:50 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-1-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-1-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 10:10:39 -0700
X-Gm-Features: AclHuK-xwRjaaPrwB80Vzu7EPALPdSfCYFBDDTpR92M3U_nW5dShbdAXxId4uf4
Message-ID: <CAJuCfpH04aBbW+mnQY3cX5gfEvOHP7nUMAJNaGWtQ5NoE1JKyA@mail.gmail.com>
Subject: Re: [PATCH v4 01/38] mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, 
	selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kpayas6f3af3w54xuhpa8bjw7q6zb4h5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CD6D31C0008
X-HE-Tag: 1791133852-182094
X-HE-Meta: U2FsdGVkX1+fGKDDDOoWjeID0cfmxmNVtYW6K+2ChzBEPVAIagU34h5N8Iilv8sc35uTJM+MN/am5hVGx5tzmImxIRzc5MTdMr2lxMOEZfdUw8hpFVUgrfnUQHAwyXdnc2ExLdR9+U0HE57JmQssD1dGlYdvShDZO0LROEupU2vJZyihnOVqFyHkfmkHYekfwiZVuPom6gY7O6sCdszt12BnEZZjAkCw/od+sDRhCLiv/i/uwRZAQpN8xIIYWoggvfqZdVO5K/LsBhCO15GQRvAnOWTt/mkydshI7/cdSZwkYKUSUTWWIeJTr7qefPk6zfhPdZGz/K7rjr8/uije5auNWNi1Ta6iKadZHxwSLB0psZFeFmPBoyBMpz0AnpEce/TzAk67DX9Vf8sKRSjQQ6UAtdeL570k+kctdXCIimmKLs4Sl1ujPEcJ+nqcagS5bNXY6CJ/vD6byBBglGET5gHCRpJ+CB8ODNHoeBzQAlKrfycZ8NQhmA2xFAR1J2zsqpBjA1OkIL3Wd2CxNmpPqjqfWTdFfL+/oAUWIryNyO2iEihmsATzhRjMzCLyzP297kCjS+xEAwxEQMb6BTi5AGrnaHdUe5q6++bR4MEwM6azpfov1Y9cDt2eZe/R8k5cGcIKpovmaYu8jWU5nESRmzFPpBRE0SiUHVZWWHqtJvdMKpMM4OVggGa09CoT4dmBjSNUwip2GnW4OIDSHf6Di9zqx94pLAwWQpJ05ugPMrOhkT4faKyIFO4kKdSOCwhWl48JT6BIp1Sq9IoZTU/7USNjv2ONL+ZLmijz1kyEB5grs9uqngdyfs6uadgnFPhHJ2TDMennr33SWRZsg/nE1IbkrbsmsnAeqv5K2R02kUTEezZNa8scrsGkAWbXei0SCxJEIz1Izsu0HFGDkrt0zqOFX6+t7zzsoivNvfanhnKZs4NoGFYWS01Jpc5sbFjtE+06Ueh9aUy3p5qPm9h
 WQkdpTHO
 +oD6FLcckdbo9OljoElup1wB3r23AV/ygmkqJSxhA0PYmIJngUkINkvt2uaWwvqnhxaMbvuQ/K5+7/+IHosm2QxlPQAWbWD+XC7xw4P65zdP4qBRYkVOxjSxMggfpvX+36fUEmKvyl8O9/B60RBLO+JbM5FGABvMF7dEepjgBfG7G+PTjVvLXGbX7JwmffTRr/TwUEUI6JlVANa1YcN/gkpKT71syIjUbnXNVIbPWSB71UGgvZgIJelLuAXeVA8iw4gtb7gLlIv77bAJTkvMnc9gddE8MD/VxL1ezYKDRJ2OCkxkxhym3E3WRBAjE7brDiX+i92AC7wfo1c2jbN/698KULaWiVa/KejURIgCWonmiC3t9PhLGeiRgspT74MfSfGeFyde489d0qIrmZ/nG9ZPXKMVAYqEI++SsOpZaK1dQdYxfiKuDyrPgmzmqtF5Zzvt3Q/zuuUXF+BGgE2wonpska/IX4lBvkhp1UB6LEtYvHxlNWeebw6OYh1KoGB1q3yXD29udpA188XkQ0b92/gn8cjmR25b3JY2WlvRLzupxs00IGnuF5qJVKIly+a9GPnoEq5nOlgs7PVLZtYX+w8omSuOYofJO782tt01uA7NugB+tthaP6bdqQMpHc6Y+A3Qxj2iU6f16ggmPxAIqs81SxtMM/JpMm1rjeW8z8ta43x+iup8S0svvdkBd7XXa2TokDRLuyI/IwcbYNW+rrdkvMiW6frrCw4chOwa6h5cr7OBpnOPF0mT6OjHDIs9g5K6q1ti+JB4xLrFgXXMkyF7SftjLQa+OIZS2CNgQ3Kq23KMbVYAj/JANQFz8occ7JS1bidyQuzK7WZ2bZtFk/WMl+apSePKQNeXojmQWuk6fYKDv89CaWU9mLqsExHairtYvALQ+XKt7Mh52KoECMildOVdxmc07LDo1aWKxdOSAbFviXs/Z3n5mtQ8N3exDYlsCIXWFTgpKgFEWtufZ/T1XwSZs
 G/W9qxx7
 ORwZ4FSdFUFuSR7cAP7EzG5BFkdNDaDKjPtGsd/Ym15RZQwnCjadAGKxoJc+h+B2equkFBTEx4L8OGqv+9wpzGXnnSzfzb1xJ7vPkzExncGaMIJnX0BsHOIz/3uPIr8ZGUBzwSh6BFDDS+XoGQxzH9iIuav5PmN5nz4ncRdQ/9uF/QY4n7FjLcSdcE9JXZHfZY1OlEkbQSHou7Rz4Q2yN/iESFkza9hCzX/wtzuSvgDurJnTJXbXgQ2wJne/AHGU996SinFBlVEXJJgaMtitp+rhWOW8OfbXd2ehphi+fdEraZ1JaMxhK7BbU9lGIfKFEoarqoNfZ6Hsz4hlkwTIyRIBq6rwsLNrOxmNDt0ZDbWgOYHL15iCaHr4ge35C28WQ6zyY0kWsc0qrw9J2o0kR5LPNv3SnN9XiEqNO6n++m1phbghu1XBnzcW8VTi4Yp62nYUtUSq4r+nEVxBCFp65OySb4fCe76cIKAAuVunU9HJm77/BmPfVAhg4uF74c6nyPA17MYya+y0HlWUQuBrnMCSYpEYIHl8PbOpjMpCWankWCB1smmAq1G54TV64v+Aimcp8ahSYKA/97U2uol4dmg3GYCV4Jgoqx0BjE3ayxLY222ay5469+CNrAjwZ8F1Y7iUPRyCRfmipXHP1z1DKg82kGPJEnSVoVFTTvwYUinli0AXD5T/q8WViZ4mLrp6cdXqtteajyxKzNj0N4aLGf9KJgc0ZXBp4B1I8bXvjTImni/wT4txDJ14wLznTOk2a4Tfo+fg1gSigiFbatLYrZ1hU+n3ME9Fr/HElCD3XUHBambyeJ2QGakyz9zrmnmRagiAPGrvHfnXQmShUtKpLZ8qwZITejfiZrF3BKAbPt9GMh3H82hBFSBPB3tqm8rZN8lGyL9syMoVfE7oz++U8n8oRDlnO/khGrj1e5VT5gBpZcNYe8rXt4Rq/KwzE+bkUbffR4cuo+4IZoZ+9m2L8QEMl+lMA
 WHqcfM0c
 EKJpfuqLRCi7IDfAEzifkVEkLODtXvkhOue9uvX+1Yj7l0E84AD6a3smrFJJpd77riRoRCTj8aLU0ahWhsBhEzJBASCL9aFXP/2jiAO/KuY4dLBudhuGl/onu2Sl1k6eGhpp4yl6TbfoVQ3pzti+yZX/9BdBF+MhnFfmtxOrgeLbpzrKQlb3gC090b56m5Shv2EbhUE94+WErNzDOK68df5WzEwnacCQfEnQ9///KvGhcTjq8kLi6VpmkborNhIvwHkQvFDlpyvOpoVHzbawfm4NhGDhKvg0e6zHLLxzgJ/2EcVlmtUqFHNIJRXaJwaPTjy23cQ9P3UTSOB3GThGjGQ2OibKuTGwNN7NEb5fY1ACmA6a2rysnjdWdRS1dgV9C8qKAGJH+jaRrLAjfdZrE7gYurAO+rdT6Q5iDWI4MG/8wOB4g7jxAcGtZRTl1vWqvuWMoV/D5c3FaqCDkm+8mjcAnAStEzGFU7Gl7cy82U7QpYARvbb8n7RA3WNUbRoDoTMhW95V5f0SRkNMyoyHiZv+GIRZ7RHg9hwsXIF2TXlxpbwTt8nYm5sFR+gC0OElhW3PVvrtVWvBmwaZWgjMANIyyorpuWIGc3RxD6uYcQZPlhHTXxJr0QLlVZ29fLNXuxOWtlQE57r5+pt7KcezcL6lKmmOCQuKaLoqmwKYJz1FJT9IptwtCwSH1brswt9JOgxFUoLkEIMzm56r/cnodlPZqMmDb5dtncj2JZaJErhk7E+bIgBIem7V2p2ywCt5u0WkgIPxXm4rOpgmv3ewhF6lPZiduvopDLAxJmCIGltiNiXYeq2Q7WKrd9OCQecqi0LWInunCQf+9VIITea2VPNNkcxA2yHPdSjGd0clp3WmgBkzTbaspWFM21d7ORO+sQiJzJiLMwq0g4iRAuHiA9JmsaA6BEAyDJC8fKLVx0GtCuFqQU0eYZeGU4GmtQTOHBUmG46zSk8fOVnu/QjxOkhwy2fkH
 /7caEb5p
 meH2N/m+1NsMJRL2CnH2SjU1vyKR8744IEBl5mjJqKwVlk2LGvTn9C7j3z/KwufTw/HaT1BGcZTcHyPGfV5hUiAoYIe9Xrr+hNeMiERcvjSQQmA9JGCwD5bpW5Rk0IJL0ngnTg9Pz+Ip2NQSehTlzVC55XvN2gq2wONlYiwvKGXXpw14h4JJ3PgpuA/6+rDVp+ifhgQ3IL0W7IJ3RUv0p+lPUYYPniCFJmRRHrQ0eiGMgYisI3CdsLJAnmZDty42C5m4RMYaneuxw6Y1lUGjUmjNxJ5uinJf412JNaRBVTpyEYwaJgj4cnFPLdxYVswSR3NHngLdejH+0zWKBw1kFqgbY1UuIPHJELmzGMPnVsvRuTCfR2Xk2qU7wfF5WM02Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 6:33=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> The map->file_doesnt_need_get flag is confusing and the existing
> implementation has holes.
>
> Drivers are permitted to change the owning file of a mapping. If they do
> so, they are required to take a reference on that file.
>
> The mmap() operation which ultimately invokes __mmap_region() is guarante=
ed
> to drop the refcount for the original file the mapping was made under, bu=
t
> this is not true for the replaced file.
>
> This has been addressed so far by tracking map->file_doesnt_need_get, whi=
ch
> is rather poorly named and unfortunately fails to correctly track whether
> or not an additional put were needed in a number of cases.
>
> Make life easier by removing this flag, and instead drop the reference fo=
r
> both mmap_prepare and the deprecated mmap callback in a new function
> map_put_vm_file().
>
> Track whether this needs to be done by aligning mmap_state with
> vm_area_desc and store the original file in the map->file field, keeping
> the updated file in map->vm_file.
>
> In order to have the same behaviour for both types of hooks, only drop th=
e
> reference __mmap_new_file_vma() itself took in its error path, deferring
> the replaced file's reference to map_put_vm_file().
>
> To make this work correctly, map->vm_file has to be updated before any
> error handling, so update __mmap_new_file_vma() and call_mmap_prepare() t=
o
> set this field first.
>
> Also when mmap_prepare() changes the file and is then merged, the referen=
ce
> count also must be decremented, so update the logic to call
> map_put_vm_file() in this case too.
>
> Also update __compat_vma_mmap() to manually perform this step for stacked
> file systems using the compatibility layer, and update
> compat_set_vma_from_desc() to replace vma_set_file() with a correct
> refcount/file update.
>
> No in-tree driver is impacted by the incorrect implementation of this
> currently (no driver that does this is mergeable for one), so this does n=
ot
> need to be a fix.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  mm/internal.h |  1 +
>  mm/util.c     |  5 +++-
>  mm/vma.c      | 83 +++++++++++++++++++++++++++++++++++------------------=
------
>  mm/vma.h      |  6 +++--
>  4 files changed, 59 insertions(+), 36 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 0dca33db068f..fe576d468af4 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -7,6 +7,7 @@
>  #ifndef __MM_INTERNAL_H
>  #define __MM_INTERNAL_H
>
> +#include <linux/file.h>
>  #include <linux/fs.h>
>  #include <linux/khugepaged.h>
>  #include <linux/mm.h>
> diff --git a/mm/util.c b/mm/util.c
> index bf0513d1d3d0..016932780925 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
>
>         /* Perform any preparatory tasks for mmap action. */
>         err =3D mmap_action_prepare(desc);
> -       if (err)
> +       if (err) {
> +               if (desc->vm_file !=3D vma->vm_file)
> +                       fput(desc->vm_file);
>                 return err;
> +       }
>         /* Update the VMA from the descriptor. */
>         compat_set_vma_from_desc(vma, desc);
>         /* Complete any specified mmap actions. */
> diff --git a/mm/vma.c b/mm/vma.c
> index 55917d097933..c27aea6d58d9 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -24,7 +24,8 @@ struct mmap_state {
>                 vm_flags_t vm_flags;
>                 vma_flags_t vma_flags;
>         };
> -       struct file *file;
> +       struct file *file;      /* mmap()-specified file. */
> +       struct file *vm_file;   /* May be updated by mmap_prepare. */
>         pgprot_t page_prot;
>
>         /* User-defined fields, perhaps updated by .mmap_prepare(). */
> @@ -43,8 +44,6 @@ struct mmap_state {
>
>         /* Determine if we can check KSM flags early in mmap() logic. */
>         bool check_ksm_early :1;
> -       /* If .mmap_prepare changed the file, we don't need to pin. */
> -       bool file_doesnt_need_get :1;
>  };
>
>  #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vm=
a_flags_, file_) \
> @@ -58,6 +57,7 @@ struct mmap_state {
>                 .pglen =3D PHYS_PFN(len_),                               =
 \
>                 .vma_flags =3D vma_flags_,                               =
 \
>                 .file =3D file_,                                         =
 \
> +               .vm_file =3D file_,                                      =
 \
>                 .page_prot =3D vma_flags_to_page_prot(vma_flags_),       =
 \
>         }
>
> @@ -70,7 +70,7 @@ struct mmap_state {
>                 .vma_flags =3D (map_)->vma_flags,                        =
 \
>                 .pgoff =3D (map_)->pgoff,                                =
 \
>                 .anon_pgoff =3D (map_)->anon_pgoff,                      =
 \
> -               .file =3D (map_)->file,                                  =
 \
> +               .file =3D (map_)->vm_file,                               =
 \
>                 .prev =3D (map_)->prev,                                  =
 \
>                 .middle =3D vma_,                                        =
 \
>                 .next =3D (vma_) ? NULL : (map_)->next,                  =
 \
> @@ -2447,7 +2447,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
>   */
>  static bool accountable_mapping(struct mmap_state *map)
>  {
> -       const struct file *file =3D map->file;
> +       const struct file *file =3D map->vm_file;
>
>         /*
>          * hugetlb has its own accounting separate from the core VM
> @@ -2496,7 +2496,7 @@ static void vms_abort_munmap_vmas(struct vma_munmap=
_struct *vms,
>
>  static void update_ksm_flags(struct mmap_state *map)
>  {
> -       map->vma_flags =3D ksm_vma_flags(map->mm, map->file, map->vma_fla=
gs);
> +       map->vma_flags =3D ksm_vma_flags(map->mm, map->vm_file, map->vma_=
flags);
>  }
>
>  static void set_desc_from_map(struct vm_area_desc *desc,
> @@ -2506,7 +2506,7 @@ static void set_desc_from_map(struct vm_area_desc *=
desc,
>         desc->end =3D map->end;
>
>         desc->pgoff =3D map->pgoff;
> -       desc->vm_file =3D map->file;
> +       desc->vm_file =3D map->vm_file;
>         desc->vma_flags =3D map->vma_flags;
>         desc->page_prot =3D map->page_prot;
>  }
> @@ -2586,6 +2586,10 @@ static int __mmap_setup(struct mmap_state *map, st=
ruct vm_area_desc *desc,
>         return 0;
>  }
>
> +static bool map_same_file(struct mmap_state *map)
> +{
> +       return map->vm_file =3D=3D map->file;
> +}
>
>  static int __mmap_new_file_vma(struct mmap_state *map,
>                                struct vm_area_struct *vma)
> @@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mmap_state =
*map,
>         struct vma_iterator *vmi =3D map->vmi;
>         int error;
>
> -       vma->vm_file =3D map->file;
> -       if (!map->file_doesnt_need_get)
> -               get_file(map->file);
> +       vma->vm_file =3D map->vm_file;
> +       if (map_same_file(map))
> +               get_file(map->vm_file);
>
> -       if (!map->file->f_op->mmap)
> +       if (!map->vm_file->f_op->mmap)
>                 return 0;
>
>         error =3D mmap_file(vma->vm_file, vma);
> +       map->vm_file =3D vma->vm_file;
> +
>         if (error) {
>                 UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
>                             map->prev, map->next);
> -               fput(vma->vm_file);
> -               vma->vm_file =3D NULL;
> +               if (map_same_file(map))
> +                       fput(map->vm_file);
>
> +               vma->vm_file =3D NULL;
>                 vma_iter_set(vmi, vma->vm_end);
>                 /* Undo any partial mapping done by a device driver. */
>                 unmap_region(&unmap);
> @@ -2623,7 +2630,6 @@ static int __mmap_new_file_vma(struct mmap_state *m=
ap,
>                         !vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT=
) &&
>                         vma_test(vma, VMA_MAYWRITE_BIT));
>
> -       map->file =3D vma->vm_file;
>         map->vma_flags =3D vma->flags;
>
>         return 0;
> @@ -2631,7 +2637,7 @@ static int __mmap_new_file_vma(struct mmap_state *m=
ap,
>
>  static void map_set_anon(struct mmap_state *map)
>  {
> -       map->file =3D NULL;
> +       map->vm_file =3D NULL;
>         map->vm_ops =3D NULL;
>         map->pgoff =3D map->addr >> PAGE_SHIFT;
>  }
> @@ -2643,7 +2649,7 @@ static bool map_is_private(const struct mmap_state =
*map)
>
>  static bool map_is_anon(const struct mmap_state *map)
>  {
> -       return map_is_private(map) && !map->file;
> +       return map_is_private(map) && !map->vm_file;
>  }
>
>  /*
> @@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *map, s=
truct vm_area_struct **vmap,
>         }
>
>         /* Invoke callbacks. */
> -       if (map->file)
> +       if (map->vm_file)
>                 error =3D __mmap_new_file_vma(map, vma);
>         else if (!is_anon)
>                 error =3D shmem_zero_setup(vma);
> @@ -2797,11 +2803,15 @@ static int call_mmap_prepare(struct mmap_state *m=
ap,
>         int err;
>
>         /* Invoke the hook. */
> -       err =3D vfs_mmap_prepare(map->file, desc);
> +       err =3D vfs_mmap_prepare(map->vm_file, desc);
>         if (err)
>                 return err;
>
> -       /* It's invalid for mmap_preprare hooks to clear vm_ops. */
> +       /* Update first so file refcount tracked correctly. */
> +       if (desc->vm_file !=3D map->vm_file)
> +               map->vm_file =3D desc->vm_file;
> +
> +       /* It's invalid for mmap_prepare hooks to clear vm_ops. */
>         if (!desc->vm_ops)
>                 return -EINVAL;
>
> @@ -2811,10 +2821,6 @@ static int call_mmap_prepare(struct mmap_state *ma=
p,
>
>         /* Update fields permitted to be changed. */
>         map->pgoff =3D desc->pgoff;
> -       if (desc->vm_file !=3D map->file) {
> -               map->file_doesnt_need_get =3D true;
> -               map->file =3D desc->vm_file;
> -       }
>         map->vma_flags =3D desc->vma_flags;
>         map->page_prot =3D desc->page_prot;
>         /* User-defined fields. */
> @@ -2826,7 +2832,7 @@ static int call_mmap_prepare(struct mmap_state *map=
,
>          * anonymous mappings. Rather than allowing these mappings to be =
odd
>          * outliers, simply make them truly anonymous.
>          */
> -       if (map_is_private(map) && file_is_dev_zero(map->file))
> +       if (map_is_private(map) && file_is_dev_zero(map->vm_file))
>                 map_set_anon(map);
>
>         return 0;
> @@ -2845,7 +2851,7 @@ static void set_vma_user_defined_fields(struct vm_a=
rea_struct *vma,
>   */
>  static bool can_set_ksm_flags_early(struct mmap_state *map)
>  {
> -       struct file *file =3D map->file;
> +       struct file *file =3D map->vm_file;
>
>         /* Anonymous mappings have no driver which can change them. */
>         if (!file)
> @@ -2868,6 +2874,20 @@ static bool can_set_ksm_flags_early(struct mmap_st=
ate *map)
>         return false;
>  }
>
> +static void map_put_vm_file(struct mmap_state *map)
> +{
> +       /*
> +        * An error occurred or the VMA was merged.
> +        *
> +        * If the file was changed by the driver (which is required to in=
crement
> +        * the replacement file's reference count), drop its reference co=
unt.
> +        *
> +        * On error, the caller always drops the original file regardless=
.
> +        */
> +       if (map->vm_file && !map_same_file(map))
> +               fput(map->vm_file);
> +}
> +
>  static unsigned long __mmap_region(struct file *file, unsigned long addr=
,
>                 unsigned long len, vma_flags_t vma_flags,
>                 unsigned long pgoff, struct list_head *uf)
> @@ -2922,7 +2942,10 @@ static unsigned long __mmap_region(struct file *fi=
le, unsigned long addr,
>
>         __mmap_complete(&map, vma);
>
> -       if (have_mmap_prepare && allocated_new) {
> +       if (!allocated_new) {
> +               /* Merged, so need to drop refcount. */
> +               map_put_vm_file(&map);
> +       } else if (have_mmap_prepare) {
>                 error =3D mmap_action_complete(vma, &desc.action,
>                                              /*is_compat=3D*/false);
>                 if (error)
> @@ -2936,13 +2959,7 @@ static unsigned long __mmap_region(struct file *fi=
le, unsigned long addr,
>         if (map.charged)
>                 vm_unacct_memory(map.charged);
>  abort_munmap:
> -       /*
> -        * This indicates that .mmap_prepare has set a new file, differin=
g from
> -        * desc->vm_file. But since we're aborting the operation, only th=
e
> -        * original file will be cleaned up. Ensure we clean up both.
> -        */
> -       if (map.file_doesnt_need_get)
> -               fput(map.file);
> +       map_put_vm_file(&map);
>         vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
>         return error;
>  }
> diff --git a/mm/vma.h b/mm/vma.h
> index e97bd2dfa786..f15faa83f3d6 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct v=
m_area_struct *vma,
>
>         /* Mutable fields. Populated with initial state. */
>         vma_set_pgoff(vma, desc->pgoff);
> -       if (desc->vm_file !=3D vma->vm_file)
> -               vma_set_file(vma, desc->vm_file);
> +       if (desc->vm_file !=3D vma->vm_file) {
> +               fput(vma->vm_file);
> +               vma->vm_file =3D desc->vm_file;
> +       }
>         vma->flags =3D desc->vma_flags;
>         vma->vm_page_prot =3D desc->page_prot;
>
>
> --
> 2.55.0
>

