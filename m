Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24C7BCA5FF1
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 18:09:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FD4A6B008A; Sun,  4 Oct 2026 14:09:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AE2B6B0092; Sun,  4 Oct 2026 14:09:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E746B0093; Sun,  4 Oct 2026 14:09:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA6D6B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 14:09:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBEABA0B27
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:09:50 +0000 (UTC)
X-FDA: 85285732140.02.3F4AD27
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id C6C2140004
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:09:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jMTr6KwY;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791137388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLyJnDD7le8j0fwG4PV8CX7G4WYRHL5RcOgxsV2u/6k=;
	b=jvFvCBuximlDwcZ43BglGx3tb0uBI/TToZHLWXgfz1+ECHSGBey375VD9y5Ci6QpyuhMQx
	ASrZQ+XyTFJu0HEythWvL5agfAJYFn+Pq6usimkeBly9GBl9vt0J+9Bi4T6ceaY5WqStvI
	+zHrCyOwaqWf4Cdh1c0yPXbUwH8SEDo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jMTr6KwY;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791137388;
	b=41EccpmXFd8XyHHB9tYsJeO6fErk34eYrq4OurnLx4ydsVGIYV8/f5/jlbyiON129zeL9k
	9ufimLrNTUjMceoMtcjxmCtSMSXVvKKrBI2o7YIF30R0YffUrWq71VOWzStvDaNNbHLdgP
	qzbNE22CIrNS+lRzPBJQpSd24ybNg70=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5337fa12431so185431cf.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 11:09:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791137388; cv=none;
        d=google.com; s=arc-20260327;
        b=k2AXK0YoZrvRkivRkvoym1HS9nh01XF2JZbOSoEnRaLY7kwSHfXybeUtsTM/1XxDvT
         KCWHChbIj61i1D1AhX3IT/4b7PAiYWJPnqCF89mVar/7HA29qURyT9Xwd8GbdFU3cyum
         0I7xcXT0D4z0qx3+91t5DhHpFpg0auZVbSeZ5DeQ+luu5Gzw45wsE/CJEZ1U5zQP9rvT
         azv35C79gwDgD/yDXIYFg40Nmffw28C9trOG7GsEfD2WRohuvIKVtHF457KU5gHBTFrJ
         C0Bp/GqmBzxyIE9gPQ0OFItg+9kr21bIS6KZCOfTgSZBUbaMCg4Ll+c18D332vHmuqAB
         jkWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XLyJnDD7le8j0fwG4PV8CX7G4WYRHL5RcOgxsV2u/6k=;
        fh=C6SPrsbf6V7G/bOlD5l1ThNJMxdByogPEuVEg6YIUOk=;
        b=dGpVUnf9HrirnMIXpBJfGsLPxJpqQZxLF9k2rAfQxkMTWYWnV90jLXwXdRLf1gh9wY
         mS6jfqsj/3zH6TN67puAUxnym/jP8OaokP4E70KObeUB+oAluR9aG7al4ztZOSQ5FDwG
         khz+sUKgal9+VFxCQmpY80iCjCLxTI2gDm9lvfDumYx0RpPgRJMxVodj3zjMzvEanIiN
         k0gb2XJpkw83jpvrVK9x2eMXp/ogLnzLTSerpAifj3AL6/OnnKNYFgtghzsVG3ENK1/j
         BSJ0Aazobo6GgoUTNFsJXKc5J08FJwzX8zhPMpLS7OVp1HsCYHp2Heb816z61Qo+xmS/
         Waew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791137388; x=1791742188; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XLyJnDD7le8j0fwG4PV8CX7G4WYRHL5RcOgxsV2u/6k=;
        b=jMTr6KwY84eo7IrfqOTIRaG1u8fW0dzal/30CzwQ0CW7JWdLJlJM0bvOrFwkyruQxP
         7HkBQDRCYb4TcDl3R8JbI4U2oFi+heQOSx77hQErSPf9UoopWTGU0UPW/7I9L3cdpSWj
         gAuB4vu1Ggu/ge+I9fxF/p5RUC42xwbvMuNp+bMlAfVr5voxBpf3YVxaYrE08DLE5doU
         jmGg1g1WcdXF3Qwr6d+I/oW54nEqk+7l1pqy1LQom45o3lIW5nahQn9CxHCmFzzzXn+M
         HaSyaDf+u+PpH7ddlnxNZfS8WXir4ZZ1kmrJqV830rPvMIdCkvHyF6wJ91sYLvZlUu9d
         3PxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791137388; x=1791742188;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XLyJnDD7le8j0fwG4PV8CX7G4WYRHL5RcOgxsV2u/6k=;
        b=p7xqd69JiUJCY+FCwoV9bU+1kyiu8RSg5IDSHlcKzfNjXPaVlhHfuk5zCUU1kN5sTS
         rv+OGgDySPPFkGuL7bQc7D0ZPLANS0eE60ki1amLgVfD7hbmNGUHZZ3d3H2lSgzrpb9f
         MgfrAtU2e0rk631s+W6lnMQWkRE32c46q8UaaCPOIWzVj7fhOGTkpVHLpFCgoxAcX0ZE
         /oqpeTH+tyL4dJyiAX/O/5fCj9IRCRGMWqlVhLO1cBfXDnd+Qe+6UeMUGLhVJV0Ai6RA
         aEK1NfsHqexEfKNdaPDP4Bbxrr3UhyzH5jeMXNrYvb53X6KjcPUpcMXUL/NNHB+YsY+0
         UXVA==
X-Forwarded-Encrypted: i=1; AKwUvBwxq1Ne7NEE+0QJYfHFuJdKY6qc88+T5a8rCR93Y2sEEO2R5jfDiYT3pCbgAS4atpOgEwYGH/TrKA==@kvack.org
X-Gm-Message-State: AFuF++lqeCtHfm1/5yQ2+xhNBt/1yDS2s2Pz3hDRDrcNLIEHbvZCnV0T
	nXYp5jdLWqCaAnDj1QMQ6gW8/RPmXQxls2x+kE1DFEjse/f1jPSlpVOFTcpquR813DtlDl7wjKW
	UW6Digh1k8zjQkFZN566H1E467IWqIZPsur+uo32s
X-Gm-Gg: AYBFou1Qntx2HpYW8UXbf7DRUXS/LcI78SkYe81P/5Psl7DaIYh3Q717+Cv/zv8dVTS
	LZdLWqbqxi0KS+MwoaE0cQYcdQPscZf+zcWI/1TCERRHuxYIWkuHkKirJJsc3XrigbvEWHc116h
	NUk1BgS4a3B5YY3WmKPWu1yA2H81EKRmc5v6t6gRG3Sh3JuVE1m/0nShvRQCs6Ddku7/5aD+l5d
	g+9C/TP4wMdiXc9xlB+2azfTk3oLiolIlzJoWa21DIOzioomg8fUcbSVCbsBVoqYihZJGLisP7A
	YJIz/TtckFnIuCsDkhewKxDvazoi040OHNkXcx5n5p0Mo/NGXJAd/4eT
X-Received: by 2002:a05:622a:e159:10b0:52f:9ed4:8d76 with SMTP id
 d75a77b69052e-535146449camr14146121cf.14.1791137386702; Sun, 04 Oct 2026
 11:09:46 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-19-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-19-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 11:09:35 -0700
X-Gm-Features: AclHuK-kwJ_Uo7kW-aV-ulJRzQPF_vjK2tdCaS-4gRgk6ACv9UztvH0OKE8MWEw
Message-ID: <CAJuCfpFKJ+31TZOWhwoTQTseOEy0AgAjz5eK9fdXmL40D0OY6Q@mail.gmail.com>
Subject: Re: [PATCH v4 19/38] HSI: cmt_speech: convert mmap hook to
 mmap_prepare, refactor
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C6C2140004
X-Rspam-User: 
X-Stat-Signature: s1nfb6qqkynb73ifjibhcokqzhynw6mi
X-HE-Tag: 1791137388-522530
X-HE-Meta: U2FsdGVkX19Fm0421UBnbUNpkBsmehLP+i83WbfC6PPfILEEbocbzeH+2JI12yXQ6lLd6yTHdUw+hyLFUvSbBKCtkFlEm2iXp14/xCiYEbU1p/IvQD5psRVt3Q5Y6zc55+IlscAv+6+6Ao52j7kLSH95y+AFhUeokv7RmuP2R86r7Yne4gO2iWGo67rSto984bYPW8HJUw+rg1qyivzQ+v2gZsGgqigJ2GzQlR6CyyP/4P1Qp2rNAIs8rR0fdAfrxiNWMFjs19iWtlm75BRDF1nxYK/SIPDwe8ZX2jTN7u+33jJ2eVPP7PI+zyiH7Jvl+QvWK7LX3uUp3uw5sz0m1wxTO5++1XNgDaFryDlJMpbvvLcRZEIbFSIoCOMiBEwxXEJWt9Px8PXCJTa6sr6uKaPK8hNqF70fInMFmHkzphtNroeGhNQ8UiR/MpJfMrymOECAJqyQwaWIiSH5G2lDAGSE9fFMjTbcdQ4MdPcpHTfiX6sYW0biOymrKOmo8MXel2RTqeV4NCE+OdfwgjShNhs1zfdk6yquZNL75lcDBY7yrCWhOOy1xMmwKLfze5RGW0cTW9/AqE1r0U80yMCScUcGna6Pkrhx55dp+X3xMZZkWiBAOb7dy4p2KGx9lIAYZrh1VXTETmxFtZzxjSRbp5dLFf194sm8QGGuv9GSj5YVb/KbsWyUWOfN10CZ6Ztkx0nhnAqCvBAr0eUodH80z4A4hdhCwiEH5clW6D48wsSqO+Qzmew35kPKiLzAsUYKXM44KJtiTGRZOM3xtMs1smaHnAeo0RIK0sDjiaaXvh6hIuzrD+Fav1V9m3iHJfK2o5S5Aaz/xH3qkzd6vN3AXaGu43LLyfu9xX8NhumE/oSOx9C8RnEruddrD03Rwujj+MWsmdqbYJD/dPb94JzR7fdd9NLfLwFJ/Xl/6+P90Vx0CDPaYnzpBHV2I0IzQ3a5mtiAm66DPxTtA07byjP
 7+CKdrjE
 Q0lDhcu0LpkHIiViLUGgzNBpgHXQuGhkBrvoIdGn9+a/ej0CYNzxqKzeUQcjERCmc6KO74FvK0TU7hH1k36bsrYSh3SCMlTmhJqm86HG2/rvOH1ZJyVHosXgIV8k8NS/ZisTcqCRj3JRhUjyJzpLHKYx85GKmqIJHaaA24kvCUs8IJ6d9SetskBSXdKepgtE1J3qfF0ffSgTs+ILqlH3Q1E28u5Yk6gfB3rirmo3CQqtYBfb4sJyhUidep/tsPz7PrKhCFOPGKWeywpssQmUIV07aY4Pg/wh1L6uSDcVW/meDqxRmIbRpnWU4kXRgZZXPlt9opcbhdkvJBrJ1FVLuovk/QDeMTEQOh2cW3axVJOmrM3dIPlmyHvoUQ1+INN4aaj44tdDdBZZspCsBcOAiqy7vkfyzsoM0zKrTxNhTLrxQIyFttJk4fLKeXPplEmBHZxP7chRHI3OYFTOlOzOtTDB+qumZJDbLDz6KPXOnUk+B52tc+HBELV+9S5DmkkMvXxsZKEvMTDM3gUToMes+dGqW8RY3hrvwI6KBtQ7eHPfA0qcdgZsVA+Zi4yWhYEFizNeCtzLlOYYygjadwh8Hi6Mm8RVywNq8Lhzb3xjmjyUSQdZpLA8AcS7NdZzJuMkEOYq6K/YIVek7iEiJZOzUWDy/MN/9l6vrTF6GDQ50dOQN7yMWES6eHdm+L2lahKFKxjl7+ZmOnE+5+CNkKHuMpvQRYq/5R4JALlCFLZLIKyvSBduFrmdQKnB7J7hVl9HbEBZ0i8h4+OLZ/PZHo36j2OaTrA7uRbXfakONXEuPz8mUig21hE8Jf7MWpP2J0M6SekQ8SJbDtauAgH59SLVXXVD4tvX75G3CKC2zIf3KXcrclXw7v3LgEq8Hu/lS/OXn3DVpK6wQ96L1sfgubpLAs5rnkeNCTXt2httTKpONFdU+FNv9ptgb8c/n4H8/3FTM2pWkBZGuWj5L+smLhHsrsn1eJ9ur
 OFvc7A14
 r4X9soDEOt9i+FRNxpCgu9VkHvDfrR9NV/IZBQGXHeLps+o62IwLK+CYoCZ7w/NUy/pXIreILkU3ZjO9/YrhThvBHjMVHrbI67AaN3rRnirqUEbTE3kc5NIWv4rnryk4DeMnMYQamhjHHfN8XN76Rz/nZJkCO3WcDefIk9Z+izognqG00pU038L2C+2EXdcsPynycT9jpyzsXtz2bAIz8ssOemXw4Ap5fYVwkynK+Cym/RZTVtAMImoXrvGW4oTKnw+2ac/YO/Ic7gy386+YJjB9BtXC9q2bdtXc/IicdvaqYQTDMspaokeSA8FTxY0NJbR8XanxrUGYUHBCZw8ID03XxUYpMBtR17B2nNZoVwPRl8hHLpAaPlXWW/nLeilQF95nhxBM+5dLG5/2u7EGfJNSI0KCpkpzOqoGilpf+stOb6jCKHKjY1PJ/Op8dpER91eZ+/ukVjT5vmSpB7sNIwIxrtYr/6kOEeKHKvJtnDKT5jICxYVT1+dq8KitLvaqJt2Drqe3VnXABgAMdBB8DezPH8uycu9Q86/nVmumxD3JvXE0stp+oygPtnyvWUYGq8zQRNW7pqSv2FNy3+lKVd/wLjyRHlnIwuHnQIuzn8jrK3dCK2RmjOURDwaa2Tr6qPNvyNwhCYKLBFA6Ml0F9AbDdisizpR0ntE8V0hApldx0CZihIK1OG2lb8zPed9sNPvyBrHCDFsTV5oxvfYiIhlp/r/OJV4KYLX6yoweOl9R+YRdNA7uhIc7qwWUaEi3rrlSD+QF69sqJn6TjHD3T5NYMZT5rULJkVFqjufqSiYHrlvo7hyaIqTFvfksqlHMTkrmH4esXY4jEOQeJfTJbs6xgz3y88RAxt6cRfDcXvdBiMIR+zF6cI0B6w2JP3FJF5irVQTOKA2PQcA75BPa69XyzovdLVdsjb4KVqgkz1RgckeA2/wzUh6jBjsXX/9tZMcCNyg7y317R9leLcRDIneB7D2rn
 nzo06YT7
 zYnuF2XrgzegL9vLYBRY3KmLXCNjGAXrNv0knAX6CIYbWYMJJqSduCF10ExClidSo9FhcEQURT/33XDHYavhRNI2IQU1vVx9+0zZdxrDFeaPR8DNh1uVjSQVretcMY4fLGY1R/MmzjHYhJ9EVoB87AGDVG99Ngl0c0eLxpiaqM3Zu5fhbHTCSv7f2LCKEgbPhmPthkZUfZxgSwzkxSJgnU+Vxejzsd2UjwU014tYYSlnnLunxlzVDX2NGqKXYaEAhpd4PKuPOMak8C0kCLlUkPtnGI6FmEuYhfblbPShloGkyub7kFnsHpn+G+qDji8ylMbBJild2dvfIG9JU8LwiL8s0rwPtVU9hwIawSy1z4x1SWB+YDuBA07OHY75chhCcrfx4l3HaetIOaGxWtW8lgLk7Ewrz5D7ihW/blR3S9iL8j1Qq8NXmpTSYz8ilZZEWlgDYbLfZtS6AOBy1acUZVhQ0gDIbWq96jh4O4sFUEOG3/vTEGDWkJXJuQ44Ms3Zf2zH6lSYEbIzfXJUgHOJ6WoYquPef2bMK7RscyR4+ExeBU5wNMJAe8jZyN0iPOkGiBxJkXg+u7EzR44cyVJUt8RRO/RQypXj0iWYYS1brGBBtTcA09ZokjG/GH0ySexschoCNyQgwULSiEM94T2E+2KKOMG6+Wcq6bfMRKmnzne7PQZIuzijNtXw7VL7dEF373shVkWAcHfyLegU/NlBi5K8g1e23jtEYcfDMFMPkQeeuPTOb+qrX3a8ar4WNXJCRvQvgj2uI3KquhVAFtMe0kyUqNiedqvvGCEg8Ox4fsJIWzwZK250t2SdAghTeXZJxso6oxpzbrMLIjIr1ap01MMBwG45ylFWG/Gpj2tqhX8XoORGvCooojnGGxpfyh0pH2rSDBrQon+NGt6SIm/KPIuHTjXNJKbYr1T0KcAsnGRZCcUKz6uhy9N8xhkTcsliz/sMt0b4Mjv3ZHWZbDKTeXr0emwv+
 Iu3i9ld8
 1PqZJPI6kYuTUJb7zk5tkzd5JqkP1iBWfcL7ZJ0IdXZfoj1qIYGhYDHCeLH+3Ib6zgs3BfMVS5EDQU4opWZSu91x5m1WaQLB3LSBcVBROSdAeWufVWlQKEQzCncovN4lXJ2cjMEwbVeFLC4kbJig4eZqQ8rbkcLuJXocjnCemz2j3KB2/3yyfOHDzGh2dw1GEpt1wgdgKc4e1JA4adb0Lq288jaJx0R5SJQ0azgk6FzMOEBrn4HgZR8Ama/9C8wlwYQbZ43MWEygEJbMhn9DqF2bUPIYlXlPBn7EvQ5iI6uoSa37K18ckfCugtXTBp6nc4bAjq0vvhfQayUjToi5n22jayc8qEBM4oWtIiCFk3HDY8YyOZl0PNjcHtz5ZZOeM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 6:39=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Use the mmap_prepare in favour of the deprecated mmap hook as part of the
> work to convert one to another.
>
> Since this is simply a refcounted kernel page that has been allocated, it
> should not be marked VM_IO and should be inserted using the kernel page
> insertion mechanism, so convert it to do this instead.
>
> Use the VMA descriptor's private data field as a scratch buffer to store
> the page in - this stays valid throughout the kernel page mapping
> operation.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  drivers/hsi/clients/cmt_speech.c | 33 +++++++++------------------------
>  1 file changed, 9 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_s=
peech.c
> index 7226677ebde7..801697b74d4f 100644
> --- a/drivers/hsi/clients/cmt_speech.c
> +++ b/drivers/hsi/clients/cmt_speech.c
> @@ -1084,22 +1084,6 @@ static void cs_hsi_stop(struct cs_hsi_iface *hi)
>         kfree(hi);
>  }
>
> -static vm_fault_t cs_char_vma_fault(struct vm_fault *vmf)
> -{
> -       struct cs_char *csdata =3D vmf->vma->vm_private_data;
> -       struct page *page;
> -
> -       page =3D virt_to_page((void *)csdata->mmap_base);
> -       get_page(page);
> -       vmf->page =3D page;
> -
> -       return 0;
> -}
> -
> -static const struct vm_operations_struct cs_char_vm_ops =3D {
> -       .fault  =3D cs_char_vma_fault,
> -};
> -
>  static int cs_char_fasync(int fd, struct file *file, int on)
>  {
>         struct cs_char *csdata =3D file->private_data;
> @@ -1256,18 +1240,19 @@ static long cs_char_ioctl(struct file *file, unsi=
gned int cmd,
>         return r;
>  }
>
> -static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
> +static int cs_char_mmap_prepare(struct vm_area_desc *desc)
>  {
> -       if (vma->vm_end < vma->vm_start)
> -               return -EINVAL;
> +       struct file *file =3D desc->file;
> +       struct cs_char *csdata =3D file->private_data;
> +       struct page **pages =3D (struct page **)&desc->private_data;
>
> -       if (vma_pages(vma) !=3D 1)
> +       if (vma_desc_pages(desc) !=3D 1)
>                 return -EINVAL;
>
> -       vm_flags_set(vma, VM_IO | VM_DONTDUMP | VM_DONTEXPAND);
> -       vma->vm_ops =3D &cs_char_vm_ops;
> -       vma->vm_private_data =3D file->private_data;
> +       vma_desc_set_flags(desc, VMA_DONTDUMP_BIT, VMA_DONTEXPAND_BIT);
>
> +       *pages =3D virt_to_page((void *)csdata->mmap_base);
> +       mmap_action_map_kernel_pages_full(desc, pages);
>         return 0;
>  }
>
> @@ -1353,7 +1338,7 @@ static const struct file_operations cs_char_fops =
=3D {
>         .write          =3D cs_char_write,
>         .poll           =3D cs_char_poll,
>         .unlocked_ioctl =3D cs_char_ioctl,
> -       .mmap           =3D cs_char_mmap,
> +       .mmap_prepare   =3D cs_char_mmap_prepare,
>         .open           =3D cs_char_open,
>         .release        =3D cs_char_release,
>         .fasync         =3D cs_char_fasync,
>
> --
> 2.55.0
>

