Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 112DBC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 16:09:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ED7D6B0088; Wed, 23 Sep 2026 12:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5456B008A; Wed, 23 Sep 2026 12:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 665A26B008C; Wed, 23 Sep 2026 12:09:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 397BF6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:09:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3C591207FB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:09:55 +0000 (UTC)
X-FDA: 85245513150.19.7FF5AC4
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id B3C3D20005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:09:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CL+e4mWN;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790179793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HHWyBmRaGzTNumsbsfRRD90WYZuPVsFs3XssqLSLFrU=;
	b=lT/jHNkvC0iXsDX0muofREO26W7AYe9BmOTZQdYiyqDN7ADhor8XbKP47QT76eJNtgnkJr
	+kVd37gNXQz1ZOrH3kKQwMGHtHLP60VzUJqSC8D2J36G0w4vcANivrvMdIW5WUtsbqweaU
	CAev4BaSC/x+1NfrVsDW61W/0t4/7Nw=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CL+e4mWN;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790179793;
	b=BGFa0OMvmYIgzdrQOi1gKN7H1Wy9SeM6ps3ofbJw5cPDOzlyQTz2g259FX3K912wG7NA8/
	t60cW1kLeiOeJDnS0mlARcoSyRTm3BWSSPWojzwqq+L5dpbV0PRSVnhjapdSSBi2fOCBWJ
	PXmOquikLbiFHGdZoA/Fuw01KQjyzkU=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-52faa58bff5so276671cf.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:09:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790179793; cv=none;
        d=google.com; s=arc-20260327;
        b=Jou3P5NGQ3pQvHSjvpc5sQ3VdSeibkwdjegnATX7WrQg/W8zZhAEITXQmVCRWb1yyW
         aqNHzxl9kZHVTDWOX2hMmeduZOfkhJOMFP4ewvq0/gY5eQJYTHqi8vNeeYjLCpcO8zEo
         hsoOzZgcWvitYChDwKLGQJvOmbY7quZTs2Ef+N41CuSGCldU+OIrdn0xH5mNFDaD2Eoc
         c8xfcfpSDEqXIxfZg8233CcRhSYpSYMnC9C32lLj35X3kGaxsLdXhAe7bGq3D+WAjti2
         YDDH2sL+L0nKIcKj9CwIVcdjBUGWrbJFvpNKiirXsxzHyQTe/Y20BiAJNJd4ouJB519v
         6jRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HHWyBmRaGzTNumsbsfRRD90WYZuPVsFs3XssqLSLFrU=;
        fh=Rxvgwg+R77wEeuBhcJewd9u92drGTVb4QKZ9+as3EZc=;
        b=EPUoBjy9er4sb5VWIJijk3EeRabt3OiNN9W9uN4gJImla101FOrE7DwilinVOw02FB
         siDqFS1CIXWR//HOjQzb5b7QeqnT43bL7EOgXveVAE8ncyI01XCZlnl/zV3mmAlilEyZ
         5YEHC056lVLz+5Bl5smyD+JSZxHHjOF65e2xdW/nrE1qEimr4dgyyrkhVY7lMeUR9IjZ
         OQO607r4qRQYQC5aIjDM6SzKmLMLUHIYLqCvD9YsHL1tiZwF/wQnR+8pzjtoOyjewzgR
         yGztKH7Q6I6GpwA6IogwimmA/ciGvRJL+MfQBAr5iEnaZhriETjgr7pUnx9Hza55FuMK
         j1Iw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790179793; x=1790784593; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HHWyBmRaGzTNumsbsfRRD90WYZuPVsFs3XssqLSLFrU=;
        b=CL+e4mWNxt/qk7SF6upDbkFmCA6qh+3q05LhTJwRAD2hBKquVp8k6jMaqPwqr39c1i
         EXmBvVWGDFr4dkU28TSFygXTwPLybCserSRlOvBS2oUVwmE0Aq3OQ71jZpB3EPYCMleB
         7ljGjYOm0f7WmPYfrQRH8tvKFI2RXRtrHC2VSg7pDASUz9nX+Ug5jVOSa6tFCs4RrMK8
         42fwnm5wNk9r+irf3WM/ex9iNrH9aWluJUy/EDjZGdNPl6Rjy9lzzUNPGpfrcLrKZqTB
         kpvw7IrpdMMaaNZlsj1IXo6zQde/xmMbeOBTrwuzi4SVOLzs5NsEklF9OYpuAl5+8Nu/
         jxjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790179793; x=1790784593;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HHWyBmRaGzTNumsbsfRRD90WYZuPVsFs3XssqLSLFrU=;
        b=If2bPUqdY4wOdi53X5A1o3dnGufUzpuQQJR6Gz3XyTmUqCECnBL+5AuyNsHTiGQKwI
         +oZ4SXlMpTqqt6B/t7M0Xna8hyPmhfTjqf5EoorLuMx2PVu0j/mtrDGt6Qyrte8rYQ75
         gWkOXF50CHHtDkft6zAOcj5vmjPIu/CeGC9aOIrjw59gq782n7sR42xU6dimYH0qtpn+
         ZladspSVV23ClJ+KW/6hLpwSRnFxaVbqq6Z8rjcZSrq9Gs2f819jaojGVqi4RFPxwCXp
         DhhLpfI9WZsauWs7UWtLV3JV3mtkb6G2IUAL846PpUB2cXhv9stPDjpXHHSk+NWd9zo7
         BBKQ==
X-Forwarded-Encrypted: i=1; AKwUvBzN4kGe5yeq6CBVzBUih1IHBh9NUzrx0cW4Vt7cE1A0iE5RRpRayPB9h1n/jvo/H3eQDd+w2HFBew==@kvack.org
X-Gm-Message-State: AFuF++mIgmloBTBgym0lzlHr0Lp4F9IkzEC98G+BbdAfLP4vdXI2rvPL
	KkKsZ9fwJEhKDLB+BSvsimb6ghl4JCOszoSHKpuS8aIevzYwU9BpeezdeTruumSwU6+evh28aEb
	bHPJfUbWZ2dG+V7qe2mGG9/RkSvjaxMXsWzgrXQVq
X-Gm-Gg: AYBFou0bNLEiaUkQbX4oXGVCjNDQ7HnzqRr9yS4kkbOPKm0Xv5ROXxePodOS94nQxPZ
	piYkSGpMYDZZP9a8gdIu6RLD/dil0jTFLYV8RgosAOGGH87NgILjBVR8OHh9eYx1rg0bfXXpGNJ
	YBc4Je4Hmd0dUghMCG9OZUIiG3QjyLdJvfquBW+zu5o5vGyslGNAAbEzldwYqAHGCQjfcRMQ+QW
	jpmNOYK+NEy/FkpkbGcwEqlTk27fn9Dwu0iO7+/iZGq6WCuHsRNyLf108Dk3cNLqpxRaBZgCjCP
	GTDgPCgzuPW+u1/ink2lT8saT8YIE+ViGgiM5ad0KCUFdgB61DhZt5QnrjCmYcpnsTToLM5Ri8w
	lwkug691aIho=
X-Received: by 2002:a05:622a:591b:b0:52f:8389:29e0 with SMTP id
 d75a77b69052e-532f8b3b7d0mr1642301cf.0.1790179791981; Wed, 23 Sep 2026
 09:09:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
 <CAJuCfpEa8tUmYJBjx-cRdAE8y-jcKY0C81kAOa1QZS7F6tKdfQ@mail.gmail.com> <arP0oJgrgZlgtrb6@gremlin>
In-Reply-To: <arP0oJgrgZlgtrb6@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Sep 2026 09:09:38 -0700
X-Gm-Features: AclHuK-pjLwt7GcAJrmXZc-kWYiEiXZ02rewi0rtPA2ju4vBD2OPEsiN1JlMpG0
Message-ID: <CAJuCfpFPPGaK-grNx9qiQOhzAXbxU+SO+95Fht1571TGREx2oQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/40] mm/vma: predicate setting mmap_prepare VMA
 fields on new vma alloc
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
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, 
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B3C3D20005
X-Stat-Signature: d37xbrqmie4zjk5qxbf3zcyd6stznzte
X-Rspam-User: 
X-HE-Tag: 1790179793-964896
X-HE-Meta: U2FsdGVkX1+jzYQ5Yof4VZEq/MiCUAwt7w0xjctD63xBEEe5/VWRguWnIAhnrvYlqp2ihyh4nMd0M2S/axLtQp0XP4glYHkdy6cECh7/FV0EbBm1osMsLFTyyKmdgNL1Ba5Eoh0sU/PSM4tm5l78tsAAGF3V9tHEbOdYlIE0XLLyGtWYipyUcTkMqRuG8czhVaa0BVJkBrGYctbRkpL8blzYoKuSzUHnn3do0HdbJrcclsi0ndHS5JCzEyetmMbd6/QcUXwhmh50P/OLquOX96NpP1q99gsrYKdT4wkg0RBT+9e+Fh45ULMsc/empRCRhjf/Llqeg/9weh5HkI5iQeAJUIOudkaNzAmt38BOd6Q36c5UJeanasLSHY3sxluZrHOov904TQoPfydb0ZiXQ9iNy4QB1I2C2TxGglHq5qa2qRCRXOt+ug9YPAafmv5qmtsCAupl7TTY1wlQFCHrAr2v1RQnAS34ENHD9KDIvdaCMrdFbyR7U81JjT+Ufg9Rj4VLDfl2oVlJ1hv0wEJOsUUY3dEt1r9MmA23jnLenhclSsh0tMUFhUaNVvPsoaMyK+TyG1tJgy0bhCLxRJ7AZeUyBmfhFfb7ZODVdbOYdH1W0nBa3LcMd84iuUxRzT/ktt3UIoLkOpkPGuvcbIhA1vEQTye7HSWVhE9jZwOGWg6tNiqGlrm0RgbUi4uXefTsgyHFn+5XJ5LZhdGPjiey5tLhoTUmOy0frTODA8vWf3mVAU7Xjq6zFrDE/muH0WMcFqq7841b0wDnEVhDnF9oRQiLRBLvUHth51vHj6oZf3Nskp/S3CE0XgxbfJIBPSpSCEzFyL/Tc0pl86bjnfmufX+uoHAa/wTubuaqMkPpJdtuhPiTFNROqKgIMVXmXuewA6Id6+z3e6QEYocvnpsAV5wio71qt8pl2cGKYYo09MEwFQQDrm9ype9acOieKEMLOzYcuNZw40madmMXwsx
 RNxgt643
 Pw9SYoAr3X+QooR5IRtipQhBKcmmhuPq5HIOnmT1EVvFD7jTvGUHa6mIwmGYx6it2DA6MWCQ/H8edBGmGyGNjQnKgAaW7JIsYAPH+DSYCfEq3t7NQR8sFOvXt5PC7l4a7qultF87jEyJirZyAp5i2JXgZGK7kvpoRysZFAE3eW7oAQWNdw9WXSVa3Ua8I1EzR0eaEu4Hh90nrdGoDzwRqgxuzqv0x+07xOxuOWdrQeM1wq1iKcLdtndmtjqaZzIJ6Ebp1D2Gtm1YU0SyrycW+/nro0Us3fp/sdwNR0CbO2JyEg+5iNlE4PRhOk74sAOLS5ONiK6UFp1eKANjTURMF7Gk54Rvvx4sI4PHt0omEDZfd1lYFQ32gmL5+Co62myebi++TYShykZ4r5ADmg4NS3Ofsoh+hH1dfU1dEKtuqG7bkJXO5omQJ8B0PuzFmcSJvzSiApbmZx1AaiVP+zEuiBZUTriL3BRssXdn5sSDuLN/jAY8ovPTNgSXhNVxcyFoMwuQ4OIP1FYdPHuGepvrHLWizO7OTgLKcyrc1Jh6ufGTK4g1NcQ0YrTHXoPATSUrYFG5JKVBLk8RQPPWNbPAjPwZ+mpTVDUX1xSkpiWK2fbHcExWuXQXnlkITMZyk89vJndzseXHklBlrhQFxDdmcOrLkzAPaN7dtdDHarux/LeDsvaxDY7OMr2UBdrVP9q27lZ3TvsqVauHWZm+MftDBayb9sbz0OVj8UDJcBTZ7AxQKUEZg6IP7JN4DGDJfPv3LZ5PQKaqh/rFz1bR9F2LmAnwUe/IrPZkb6WvIOlAWVqzJMcB9B4E5bn2kLidUXetEdjcyR8mFltehO3syCiCK71KBSVmw2IuwlYkSvSgo18PXwLiTgqfD5Cw5Oj0FJ4kHKPmaumaMk6hAXgHXEdymJi816GmlDWwiq/2njFaTex83CGxF+iZorGkqvF91jozfsQDEy1EZ51iyEJzwVCmWACRLmPc8
 y6KtiPtw
 aU8tCu1+2Pcf9V47QRrUIroYV8ZEuoFZ0jCn8MWjZhyRzt59MuFgQCsZEWy2CdAZ2gsvTBlAnc45+yiYKFCm8qOJWyDXwXD8Tr8va2ePr4pX7OQFeV1lQcw3/AFViFfdHuB0ZcdPQcdn0bVN8CCJeyYYOb73MPHITvNbxpju92dB5rOSnI6OVAV/7KxFyrXpbfF8FBJPG1jloWtBW2ekbbmylXsvvZhQZNSKJSQfvirfGZ7UEel+sNxRknfjK8Ngw4RRF0IpRnTVn7EkdwuoocQSTHSXzXLM+nN/PEU6VPP/51Q+ETvxxYxup03Xo5qTOC8L9bL9/HtU9xH8CCbYomR29hqyIUgyv4ZXtv5cR9OygW0t3BSGyI4qK0dkAkfzaKxgo8at8TnIM3XxQRRVqHk/3SX0ZLcqumevKG9c0uJC5KPSFeC6579U9PKPpr8kYL5vFi3f85reV6ptnleCZ2dnmdJ+NETvlaJK6RWFAYqApP+KrSRM/X3CvVSmz+vj9yto0hIG0uH0Sbkuru9XICvR90+zVn+Hwnr58Exc36TkVVTnEOX/3HPr37ZJut7ApNDfs+gshs1tGERiFJgENzdJJvZbeddle6HgdFKoGZICSBrhuZKpveEkFsPo3pPl3NzjGn7z0rPWDiA1e6XK7b9HXUDIR+ekaWwgDzt0mOnazZAr/GuijdpmYqfBKdv2YXJZog8+RbjCWfoqENUnBcvGYAriBu27C2ShYUFu2ghkX+3lZdbO1/menDAGdRsbQNdY9TGSr8Zey16xwwu9DfSoGFryVzoYo0MU9tLhd0+PUy+FqWpKjURYtelGi3zNmK7WKO9j+qm1cxhWaICnKiKfguQ6pJY1ouR4ErZwN52aye7OKi4EW1ldSAWWpBCq6yBL5pFzT1+ykPeqY8T4SiYnfjQmak4q7CjWs9zPO8GUQumQV4pzjK5BDtl7uqyCwUgQTDdsgteB8tT0JHgPREK8lyNH1
 UaykMePB
 OPLxiNE7Ci7SiROOuUEzifafOlKGv7OGuHZHIUBzI+8/Xh9rpfBad7piNT6z1zR6YU61GbgbpgXoW1jF0I4l6kuFvqI68td9b7ZSaU//ohOYYHk+fZoaGuuHC9jHYjxyQpwPzJUuMlskTgBQbvBjEsKv2pMn5oOsXD2p2Fsq6SZdm41j9fo7WTa2zmYSEFqNbst+Kd6qKxq87kdWiI72DpAhIxrk29uvd8RQT9diEZ8gYG+rrtZHYy9VwtQGSxd9CxRFjiH2nTPNU3g0CI6dQ6jWytH7SDr5oCpPTCgbg+0i5uyf41m++2ZmUolmc4VPfBxPCzQpdtjTrVzFGSs5LBTTmXwYVw/onCeKYOOP3GiLgP+BwI8lTVhi9JuVlReQopB6qcQ8SyNwHshzALr50duPXBuq3ickvH1L1OHR6Cv7BmUMCbUH2nGd6a0GJbb+CBFbWUMcXBek8Pfc7E+NGQGaS/H/WYboewjLZDRtjL7sPdm3TglI9Qd64d8pYu66W3pcQJuE/0gNQc9og6zmtLH90npJB+CwIEvjXFQmvjNDF1V60k5y85hOJYkESQ4+Mr+jjbyw/DGJiXFIFUht5HBdzxWfp8PYOS/vfvOWw9kdtblT3w3ClcjExuvJWrzvRaOGjFCwfvWhLT0wQlHXX8TW0szsfuIchaR2wXPvTWCsL8kTAkCZ/SB6NM8n20hWKUXzjAWCXZYzSZ0PA6g/jxLI8cOTr5Qh3nMQcwbj3a5BW40xAbicTT4dhBl8v5sv7mMfOuVXhVqRc/ei1kEyT2dy/oOB7LEz+F0B7GzZxM/qUVSQaLTEs5/i6TKuGk7ZhrOGnrDux05IRdBQ+abg6VH+mrmRziPEd2l4Tnq4i/iPj3ZHlR6m2oRkPcMogS4adfszpBygEAn+QeJd4Mek3JLUALCf3wU6T0pwiaU9bl3EL06XJitWofM2fGHxba6iHWosarL75iuKlgLMXChmRPrFx30Ad
 aFWrGg22
 RSm4ABjgSDQmsX4opKltiIP6EYMehnCwxR0bjlfOS2XI6+ljw3BCCWojcPw5fOiwrWiiw7tRGcnBWYOKOZ0icuLGY42uUgppC6eFFYDWGeiZXm0KTTz2J9oG42VcQWe7fkj83adxfMYRgjO4EKo45K50GZcl2Scfn6ud6TEaP0CsOcrjGm6FqaJfT+EBeP76X5Rp040qkQEa8assbqisI0nC7KeK4z9cQ+s/PrvR9J/SMCEMRkPFMKfwhkA2AJV0f76EYVXzRnZxF9DpaYTWwxEmu228KpXkVufOua655JCI+qLACIv6TgAOi9LytPi/X1tCsMVBzQF26cm1/LKEI/I1fB3VrMRY0TSoDYbYkaNsTGN/uTz5Nc7dHLfEhXH64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 8:54=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Wed, Sep 23, 2026 at 08:32:43AM -0700, Suren Baghdasaryan wrote:
> > On Thu, Sep 17, 2026 at 9:24=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kern=
el.org> wrote:
> > >
> > > It only makes sense to manipulate VMA fields if we allocated a new VM=
A,
> > > rather than merged it.
> > >
> > > VMA merging does not compare vm_ops or vm_private_data, so a merged V=
MA
> > > keeps its own, which is also what the legacy f_op->mmap path does sin=
ce it
> > > never touches an existing VMA. Previously set_vma_user_defined_fields=
()
> > > overwrote the merged VMA's fields with those set for the new mapping.=
 In
> > > practice these are the same values, with rare exceptions such as shme=
m
> > > selecting vm_ops based on whether the file has been unlinked, so no
> > > user-visible change is expected.
> > >
> > > Make this dependency explicit, and additionally constify have_mmap_pr=
epare
> > > while we're here.
> >
> > The fact that we might be overriding attributes of an existing VMA
> > that we merged with is technically a bug even if we never hit it,
> > right? If so, should we have:
> >
> > Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")
>
> It's not a bug, it is an in-built assumption that the state used to asses=
s
> mergeability implies the same properties.

Hmm. What prevents two VMAs with different vm_private_data members to
be merged? IIUC is_mergeable_vma() does not check vm_private_data. In
such a case set_vma_user_defined_fields() would override
vm_private_data of an existing VMA, no?

>
> And if it was, it'd need fixing a different way (check the field for inst=
ance)
> and would apply to the legacy mmap hook also.
>
> This change is needed for the series though.
>
> >
> > >
> > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>
> Thanks!
>
> >
> > > ---
> > >  mm/vma.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/vma.c b/mm/vma.c
> > > index fa784f069da4..4b74b48c29b7 100644
> > > --- a/mm/vma.c
> > > +++ b/mm/vma.c
> > > @@ -2894,7 +2894,7 @@ static unsigned long __mmap_region(struct file =
*file, unsigned long addr,
> > >  {
> > >         struct mm_struct *mm =3D current->mm;
> > >         struct vm_area_struct *vma =3D NULL;
> > > -       bool have_mmap_prepare =3D file && file->f_op->mmap_prepare;
> > > +       const bool have_mmap_prepare =3D file && file->f_op->mmap_pre=
pare;
> > >         VMA_ITERATOR(vmi, mm, addr);
> > >         const pgoff_t anon_pgoff =3D addr >> PAGE_SHIFT;
> > >         MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_f=
lags, file);
> > > @@ -2937,7 +2937,7 @@ static unsigned long __mmap_region(struct file =
*file, unsigned long addr,
> > >                 allocated_new =3D true;
> > >         }
> > >
> > > -       if (have_mmap_prepare && !map_is_anon(&map))
> > > +       if (have_mmap_prepare && allocated_new && !map_is_anon(&map))
> > >                 set_vma_user_defined_fields(vma, &map);
> > >
> > >         __mmap_complete(&map, vma);
> > >
> > > --
> > > 2.55.0
> > >
>
> --
> Cheers, Lorenzo

