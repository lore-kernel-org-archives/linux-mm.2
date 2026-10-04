Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F1B3CA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0626B0095; Sun,  4 Oct 2026 13:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A096B0096; Sun,  4 Oct 2026 13:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33A46B0098; Sun,  4 Oct 2026 13:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD05E6B0095
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:14:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 51CDF80B9D
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:14:14 +0000 (UTC)
X-FDA: 85285592028.04.80B4BDC
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 60C02180002
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:14:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Yxzjsp1k;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791134052;
	b=R8sOBZoG2oFo5OWPjd5RUzg1QeJDi+VP36wrzrhCiw8xffZBsQiilT+9/6KqbB5NsJW69K
	6SXl+D5R5cq7ZkaLBvuh8z/Dy0fsK2sYMKaBB82cl5/J6Fzgj85on9VVrhDq+s33t68MHX
	u9A6a+ffJPIqpgAKHawU9RudwCLr+p4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Yxzjsp1k;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791134052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oK+gurncHWXSmmPtPu9hgAMG8GgRdX+XUQo4lUX1RzQ=;
	b=bvVWWwQZgPhJvqh5xL5dDstM8lJX8qY+WsPAx5OhTGUSAtr+lf2UabFa8s487h89AgbbBD
	f/DtnV1uzybTNX6ikJMDM1sryqNpBbBAzI8P2KW1AUexx0u1CUF8WkQP7slOzaH2VQtCU/
	HY4xvhfu8+UtI4p3F6/PRT0b0ohNH08=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5337c7b9937so258351cf.0
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:14:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791134051; cv=none;
        d=google.com; s=arc-20260327;
        b=V1hlVs43M4ljqQVrjDrrOL0EezpYQjQWBz8guHeCVG3+D5e7YMkDwGx0Mme59UrblP
         YL5KFOu/47XcShRxdhT69Cp7IWoQc4JLV2/DUR92xc8TJocWnuaKI6ewFbl8YydqK7Ba
         r4NhRmCKCLIc92GnT93H8JCGtDIVyhxn3yKucs3COEDRJKEWB3v/WLWY2V91iMVVgfyv
         +rB42Qzbh4V/4zJypx2F1WMQriH1KZ/uy1rESJtgzwLy5uLHMRexLp5u8I/zSDcqsVNy
         Pvgto8i7Z1gXSAFWJiUQmaNoVDSok+Ct0SS+JodaTXDUv8OOZfYW8tBdrm7goA4SEIyE
         NVjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oK+gurncHWXSmmPtPu9hgAMG8GgRdX+XUQo4lUX1RzQ=;
        fh=v5XTFvjpkhlXlURculIrOS1oWGA8HqKKtMQ8lymkIbI=;
        b=RxKnFshWRojKIeA1S44k/Ehir813hPmqlk3ByYCRhQGX8mSXeiho6a5r2qt6qxJFfC
         IVJ1YECOmiBJoDqE4+AbNikeae8cEymtStYjfc1M4yABwOl7wvUYSWKjXZm/8yj1ARDk
         E58vbv4XzWIToSyWcmwVWqfhj9dejClAqHOlxI8Xc0m7WyvrXCEOC3tocxEpN533I8lJ
         sTawxgOPWwTJDwqw6m1gTMP4zhWDWFj9AtEMQTo5I+F/nOqt6pM+JPkdBkuDOWB3nim3
         ZEpi6lzS6tFzYtFaGLdUZGR8tODuhJaNOkHKhNcTdA7mQGLuL8BRXkXxgKpH7oIJtkCl
         e68A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791134051; x=1791738851; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oK+gurncHWXSmmPtPu9hgAMG8GgRdX+XUQo4lUX1RzQ=;
        b=Yxzjsp1k+J+7egVHhVicYsopdGNenSCitddrWOgrmsV+oO2jynRNSyYpIGp/3wuHrp
         cF5leKyCvOXc1wyfxXrnizsasg3QHfqkqS4AgPsdo7YXLGe0QyD0v8jZ0LAX9js9k4Sj
         6ubED3/Yl5O2zEVj0RChfrb2mJnZJsYjcp988oG/Wx5EnVf4E88dHeMVrbr+NmXYcHv3
         bY3xIB/wFoEYi6fmyB3Pprb6sDt5D7QgHyOoOqiL+EPnHXc9ll/geA53FY76SD6SqUnL
         KjxavEe5FiPHi0MOLgBZECWDqC7/qQ61Pfzqbyqdv/XC3yenh/LsIGhA+jDw71oFH8WK
         8wKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134051; x=1791738851;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oK+gurncHWXSmmPtPu9hgAMG8GgRdX+XUQo4lUX1RzQ=;
        b=Ua1hRpL680JPyfQzqUDR0mOvsaMUbOA/T2r24r0dBT1wk5Ici4cx6NGxBuVUqp5QAY
         8o47le45BvztHmeWUpmdqAJUU7ADFQxHXytLkrPI9Uuxw2Fv3TI8gNUw33rrozmvEgt+
         lfL/h5yz1ERHVEc+RYMhRxkx7cqCJLv7I6LYG0UsI9j4RMmGnzk5D1SahdKz91zfcQvm
         8lpZf/Sx/iX9ZZVPMd4jhJz+tA+mwNqusSNVJISfmki1GcvLa+ufx798Yyygft2TGrJo
         EKSFGEYi7h2W0VkQNNrhw38JcwpVnSQyqoaDQDoRqIUp3PYYBiSmDvSA9KIrC7YGm84S
         HwdQ==
X-Forwarded-Encrypted: i=1; AKwUvBziHZNLOnm2Hl8GtYrTOhn0lbEP0HaiH/Cx3hDg707RLfk8nXIe3i8ci22MLPS299YVUhCs5tlIjg==@kvack.org
X-Gm-Message-State: AFuF++kd0OrPoGAnFNmi3FqO0S8V8Gh+xepNU8T5oiJy55nfZyhsT2et
	9OHPgesYKy+8xrOYLOz01F/rf/s1iUxEwoZwe1SOMHLlXQoggPzKKMAkYgUSE8oUeLcnRl2cPg3
	9lEfTZ9D+9VRBK+lovwVaHrisRx7z1g4M7XTXfylI
X-Gm-Gg: AYBFou0qiALOihCVGlmTdbRYD7hyI/6mGEARCpHidGUjsh2HukIHS3fKrBXV0yBCfe6
	P3WNdedqx24MrtZGhoK4q0lbOZtGqWzavQiskPZ7ylfbYvEJ9url/icaKmQPQEk8dQ5j+3S/iTI
	gO8y7SHFVzTK13br/mH2ilxAe9J6jow3/mGhFnV6+lFl65NdlFZY52WwIRfb1Uvq7GiMB/fl84r
	8wEXVtI+FA9YjLaGM2/ydYzKCneX7fYgRF8iU8B0jy+i7reNYLp2imTRgCf6eBivIs00v3JT2sV
	wUaT9zQn2te3xNh8f3QtaI1hSTiOzzKa6rth1CNAU/XZoMEOaboffS04
X-Received: by 2002:ac8:574c:0:b0:531:475:4ce6 with SMTP id
 d75a77b69052e-535131b2b85mr16314281cf.9.1791134050552; Sun, 04 Oct 2026
 10:14:10 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-8-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-8-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 10:13:59 -0700
X-Gm-Features: AclHuK_YbQsPp6UkU1wteVM53NVi6nuDg9G6v9WzIHWTTGIprDqvC1DHCMGs6A8
Message-ID: <CAJuCfpHPcgvpR+=CtNVJeFkTn4EkF=hSPH3ZvvpkZQqHS5kzug@mail.gmail.com>
Subject: Re: [PATCH v4 08/38] docs: filesystems: update mmap_prepare docs for
 discontig kernel pgs
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
X-Rspamd-Server: rspam06
X-Stat-Signature: t7fej9oaspzmqm3z31smuqu4ayt4uw4d
X-Rspam-User: 
X-Rspamd-Queue-Id: 60C02180002
X-HE-Tag: 1791134052-244308
X-HE-Meta: U2FsdGVkX1+a7QGHnyFyx0+AlgumRYGTSZ8+J5PTgVqb5iniskUpEde8yO0CSgWUp0KHWOdcfhDizFSbKjCxY/GE5H0f9KA/7t2eF/oy0n2wBqoJ6TXb9Zn0ej8kAG+/ABqGiRN3V62PoRphaJRW8OyziCR3PCyfqgx12c0ND8qjnJakP6iCTWhS6tYm0QXHNyyq+Axw6aorbr2DYsMTcF0c4iFigaKortwRkHpAX3SLHm2pmNBDMSLFodfkJksRThlHlcPt/lf/gynfPw1+Odddew0ygIRSLimYATHYTiue35TephPGgRRCH2z+YoA/hoUSjdP6AmJ9ai03STU+GQNpuhtrYHsH76r0ZjEEF5lSFgPgoYS9GPWkqyC+v/KXb9EZsMH5xeoWKWm+8kASR9LhQL6b5iE8JnCHfltIEmwUuRpAhvZpeI5QzXGRhZf/8Tg/vxHsSUSPXKcVTShYJN2H+lgLr0CmKIiTz4NuQ2BRzsaXk4xeag2YxbawcGYEWLaWeqwWZdvhrxO8O6dI+JYZ9BBA635CKaCm4uMhkrSu4Paf8hMt+wUdh6zcnLLM9xUyINBJhm1+QBQpE7XTU+Dk5b4Izq9ZJNdv/2UMC7+kyJirljX1/MHgXuFNw6lBVYZYc7BwSeAEnTer0tJnqe//qrRDZzpmG/AZP8be73MdfDq3C3HbT+NF3hCjTw7eOmB831ya42ewGqlk04h76eUe4u6rMuq2+484R3uLxWwVZuXjCxk+q4LMCnkviSAwq+5FLWn09gKQoNd1zXNSAAg1o2OEX0bTouFDAEO8o1quWUVcKSBCgKo9NT92miuVD+/5zqE0ERfc9LrUOlf/J4ISjIXZVSfMUfX/7IvVJG8gkcVeKKnpnmzrCo9FCvqJ6BlvuRHqUd/J7yEhpPJMVhIA3df2hc0IXpCnOOD0bJp/I/xI6BWnBLBUnbEyaH12uS73tLF0VJ7tnIbJAyw
 N30A1p6z
 Q63LoDHI8ogoBfcTTlSgD1vwKyh85mLX9URX4DYf76/oI16xiaO4DLzG1Z/jfTS+rCI4bx34LDUL8CiF+55DYUDGWHg6IsPtNgt3YQ1D49yCQADv4Xcb/pW6Zfb+L2HOBqFuw4DdOACt5lJeXx4kZGmrJ0gIzdwE589Xl7WpUuboWg66/VFc2YlncTdphtIxWvBoUmu/HV01a9u+Ql+MjJEULqbUbzARfhoG67CsmVpBWVLGNXG+FrYsHdGEncaseL3gaZaHl9yUW6VnVa8dgx7lNrO6WgMgXH+4t7eVCwZHD+9bVNoO/y/FLXjClgvXRvpsUGGsXsvNgLcMMiRMyLX+6Ap87H/hH8z5XBRMzoeA6GZlSftSeypW3kZaBokJGsGvEoR9GxOUpOXBGY5C0OPOc0wHraRfqtqBh6LhRk72M5RNsjsrdDQNjePjCv5/Tu1cmtzkCmUKTZSZZ5+2IqKa5Kcsce6rHdSaFrAnVKJfIv0TpaQEnd65tD3v0JJCPqNOkeFXnutalzzCUcqFJoyciA4TiRThxPqOwAF3/8qPVVeSXl2xXY39cPn4ftB2DPyCJfEGdGA8MK5wZZ3PJ13OC7Q2JjKNMKFlBoKaKdwPM6KAL71iK4ifli3s90JvEqav9gsbO6/1XGAtkFcgHYqE4IUtKAipzeDXqYT/3fsZV8OSeo89bOUoqapne3iWU1lNnQlFj9is4tZ9Kmc8uAtr7VC62t9sGgdCBTa98DvLGL5wJoghxDDONK6YKofebnetj1xy3HzjeR1YHMI+3z7uB9bq/rS1bxWm3fV9OjNHUwQHvNTY2TKeyPwGO4UY3IySGHpL1IhMkyBBzp0nVJ7nNsg7WHqusJyFRzWYxBBDSiGUGNNBDRDQ+GTyTdODEL+N5WRW39YmgQEyFSjuyyTQmzh4sQwZoQ2fOkVeWjWaeCLN2Abu/Y+A5Y+qBWyhdmQFCH7Q6UkzlEIIkkQO9MaSGhiau
 4g0iIaB2
 JC7og2VlQa29Un2CZoHqKhPHWrikQwdkCWCFQAQPS/DvjKe/MD2OUjqCwqDEIsJQv9bMiW1/Rqx+llvKLrw0h2aCjTrDjWz5GP+LC+FJj6dGLAQDPNBxk0HIdbKvObRV5YSbCKtYPgSAMOzafK/4SI3e80Kvz+zOxKKnMpFQ2OrxM0uJ+AHBCFdQ/LQhCd4cGWeQNVMjU2zPWTHpsOFsxYJf24IJTAeh4Kbw4Wv50SRb0xHhFTCaO1mh6IfG7F04RS3Vem4EZFoXWjkEif/71phHCOp9LZHfipD+y6vA4xUC/PqKe0w1+nP9ZmNT23eRtjCQSvwETQMePVvnaMI89p/6ypIS8kjI4VJ+7rOHA3HF0/xaMdVw8W7NrpezGRo+sepAnMI5zUW0Mrd1ivJGq5w/bhQjrzK6SFuLvXAplPLYLlBSZQBjuQSfbtQvO9DR8JC6RIsLOAEdwde/qzVeodJO94vuAEDlHwx9x+rZf+QJI6gWDAEsWKc6oW46VjaCjHkyBD1QODcCFOB+3XA49NFqIH+OxWQC4cE0BwZzXzyYUxAU+Px+7tcxWZORD7In7m4fvfYuStebJ6XdUzqzuY+HBKvLsm0jadmNww9LXpu8JnIpNJsK0uJ7lWv2hCs/9tVyDD7iX6HAI6KSJO7qQHwewWLKnYJk6aphzc8eWDdIyRt0SEZup0vfaamdewVs8Kd/2KJS6H2TCgG0UPXSCAqc9QRac/+1L1fF9WnmnuVc6ATJPWJ5nKdKLg+GqZrHb6SeaZmvvLWLS8n/VjvLQ5FHdqdcNDSTwZvgISQwO8d8P+x0VLk0juizUksRMV32onxd6ZNKbEWZc/K8vNml9G3sLKLXPIBimHhQbYSABLhm36A+gVLKFYIPozROOTW2P+BWfZYYq4BPs8qRnuJEqv1+0mpoub5t6ZMh0Z+RtgO9sTxXu19i/d7w8qQQO656fwXtx/FrIN2UO+AsNqOpYFWn3C3PT
 AZAOx9i0
 QoQUbRQNEh4hC3SpHAIuNL8hB2eMzRHvHf7i++jrvy1pPswcZuusTQsekeA7DjRAfJl0snfg7T9m1gKYhH6zmH/AcVgGBVQQFS1C5McviD6V+w/RvygP7EEfP4Ys1k9RVjmLnoG4/TL4NL09gTWwtB76nUsR44IhftPavs9Dr5/4ZOD+upwolrZcAGJCwXtuwj3KrPA7ZBkXiZyHL6BcWIIGGyb4Vz/xWu5Ja9ThXU4M6hVxrjnS0d9lAgO+wQf0lViqS4LY2YlLKFOpPyNIh9ilN+A9ljTuHMWUU3Yw2TDq4SmDsd06uQgeaxNjiQY5Fvkeo3aSc6wUFcOjA69VO/WDl9oWYCPoXUPLT2PyoKQF4GmFdYFLGAKD22LFi2+FUpyHaD/GqdCTJNM6JEw47R/6J8v8AwJSNEtAUKPRs4NltmGz1Omt1ZwxejPLMj3NhpO0zcVok8uNWuMdAiAOHFcgRqhMVb9HATmgMa8Rt1ILpdxP+UB6cra/AKY2LHQsYdKKOsy0hkhxYNnmvqSaCXvfbSQ782fkKRqF5E9sndlfQUVYHsS1notaUmFp0kVX/kw+sDdJ63AGYaStI0M3DypBlEPVsE8CbAuMpojWHuXOithmTedtBIv1OxX7oG4pIgzJ+LR/Y3zarbElCtbeMRYZMEMbi60sTgoW31tyTPxTmTP5vTlBuequFWxqEOizkaxJriqceo6MSYVV0cz13b8ajkfNTBOUzAAFBF6SkoYfGMHrJuoAaRw5b4/8165nL6l2fuBqAk9XRIEIuTAcv3/zylvy7pU+6KVpH0VSzuvcWPhldAE5K5lhPOT92x0C7JDg6IguzT2eDzjvrdmS2lW/+B/VUdaTJlroTxd2yjgcN/dlH0I4njbnuosNnkZoUF1weBlZkwuBgJ5eicQ46/vz3spo9WlUbEJN1Ry1ddhSQvIJ/vdIyxpa8GO+HkjJ0b7dKI83y+WPE29be1PZfAjWdoixt
 c4va1klq
 CO0eREjXR75+nFAO3kAvsKcPJOyis+1bznSX87c956EvEdSo2eScUD6PAOVWkfkh3y1echtdNUFHTnsID7UQpMuDcWea8+sWijtpBRLj7CmtSdD/A9ADwCaE/NhDSzhaEC3UjQymX6nHp2wEm7VTfdMEepEm6TdOHzVNWHFsBxwHKeeIEfQZfl2YRFxpL8g1ZguASsnPhwnfBC+vc3YE8Yl7ColKAv+JeQsV4UySmCPp2EQhELRbAfDa3Pl0qC8ISFR9MJkDMRXg1TzV4LbcgDy/Zusad4ZnYAk0dbOYHMO2Y2s+lfGoV7mD8iFrKiEdkODEe/E7YyTTsHau3m5UG3Am4/rye6vIbpelHF0wZtJLC/q+9ObnTHPu8oVfAEjhM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 6:35=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Describe the newly introduced discontiguous kernel page mapping mechanism=
,
> detailing how to use it sensibly and how the API looks.
>
> Explicitly detail the various discontiguous actions available and how to
> use them.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  Documentation/filesystems/mmap_prepare.rst | 81 ++++++++++++++++++++++++=
++++++
>  1 file changed, 81 insertions(+)
>
> diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/f=
ilesystems/mmap_prepare.rst
> index 82c99c95ad85..ddb4434d919a 100644
> --- a/Documentation/filesystems/mmap_prepare.rst
> +++ b/Documentation/filesystems/mmap_prepare.rst
> @@ -164,5 +164,86 @@ pointer. These are:
>    sufficient entries in the page array to cover the entire range of the
>    described VMA.
>
> +* mmap_action_map_discontig_kernel_pages() - Maps a discontiguous range =
of
> +  `struct page` pointers over the VMA. They must span from the start of =
the VMA,
> +  but may terminate prior to the end (leaving the remainder unmapped).
> +
>  **NOTE:** The ``action`` field should never normally be manipulated dire=
ctly,
>  rather you ought to use one of these helpers.
> +
> +Discontiguous Actions
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Some actions can be performed across discontiguous ranges.
> +
> +Map kernel pages
> +----------------
> +
> +To map kernel pages discontiguously, you must provide hooks using ``stru=
ct
> +discontig_kernel_page_ops``:
> +
> +.. code-block:: C
> +
> +    struct discontig_kernel_page_ops {
> +        int (*init)(void *vm_private_data, void **private);
> +        int (*get)(struct discontig_kernel_page_state *state);
> +    };
> +
> +The ``init`` hook is optional and allows state to be established before =
the
> +operation starts, for instance taking a reference count. Nothing is invo=
ked
> +after the operation, so ``init`` must not leave locks held, and state th=
at must
> +be released once the mapping goes away should be released in
> +``vm_ops->close``.
> +
> +The ``init`` hook, if provided, is invoked prior to the operation starti=
ng. It
> +may update what is pointed to by ``vm_private_data`` and/or ``private``.=
 If an
> +error is returned, then the operation is aborted. The ``private`` field =
can be
> +reassigned.
> +
> +**NOTE:** The operation may sleep between invocations of ``get``, so loc=
ks
> +needed to stabilise state must be taken and released within each hook.
> +
> +The ``get`` handler is the key means through which the operation is
> +executed. The current state of the operation is provided through ``struc=
t
> +discontig_kernel_page_state``:
> +
> +.. code-block:: C
> +
> +    struct discontig_kernel_page_state {
> +        /* Map state. */
> +        unsigned long start;            /* Start address of VMA. */
> +        unsigned long end;              /* End address of VMA. */
> +        unsigned long addr;             /* The current address to be map=
ped. */
> +        pgoff_t pgoff;                  /* The current pgoff to be mappe=
d. */
> +        unsigned long nr_pages_mapped;  /* The number of pages mapped. *=
/
> +        unsigned long nr_pages_remain;  /* The number of pages remaining=
. */
> +
> +        /* User-defined state. */
> +        void *vm_private_data;          /* VMA private data. */
> +        void *private;                  /* Mapping private data. */
> +
> +        /* Users should not touch these, use discontig_kernel_map_*() he=
lpers. */
> +        ... internal fields ...
> +    };
> +
> +With ``private`` being an additional user-controllable state variable,
> +initialised via ``mmap_action_map_discontig_kernel_pages()``, and
> +``vm_private_data`` being equal to the ``desc->private_data`` field set =
in
> +the ``mmap_prepare()`` hook.
> +
> +In the ``get`` hook, the user must choose how to map kernel pages:
> +
> +* ``discontig_kernel_map_abort()`` - Call this to abort the operation, w=
hatever
> +  has been mapped so far will be retained, the rest of the mapping will =
SIGBUS
> +  if accessed.
> +* ``discontig_kernel_map_page()`` - Maps a single page, correctly handli=
ng
> +  compound pages (if the compound page is bigger than the remaining page=
s in the
> +  VMA, then only those pages that fit will be mapped). For a compound pa=
ge, the
> +  head page must be passed.
> +* ``discontig_kernel_map_page_range()`` - Map an array of pages of a spe=
cified
> +  size. As with a compound page, if more pages are specified than remain=
 in
> +  the VMA then only those that fit will be mapped.
> +
> +If an error arises after ``init`` succeeded, the core unmaps the VMA, in=
voking
> +``vm_ops->close`` if set, which is therefore the place to release any st=
ate
> +that ``init`` established.
>
> --
> 2.55.0
>

