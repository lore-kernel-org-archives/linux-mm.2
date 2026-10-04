Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 906E2CA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2476B0096; Sun,  4 Oct 2026 13:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7730A6B0098; Sun,  4 Oct 2026 13:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6137F6B0099; Sun,  4 Oct 2026 13:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DDBE6B0096
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:18:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DA8C140B67
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:18:30 +0000 (UTC)
X-FDA: 85285602780.20.A2C255A
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 97046C0004
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:18:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lMmNYloF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791134308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QinBTGgc4+2Xq3VgxIpbr+CWC5UMzdARKszuxAv87KA=;
	b=jnvIKFW8i9qzxyir6MTm22cjidubOUS7q1n/QHS/WKrn8oH47GX7+oLtqtVmzUOA3tObK3
	iL4pho89bSv7TDrKzRCDr8Fys+XA3b3dJU06IT0nzIyBbHkQ9JAbFEVZAXETv63QRYnJhH
	0ThgwN1r+oYD25Q8suiUOjzyTpYhh6Q=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lMmNYloF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791134308;
	b=ZC8PGMneS+eLAGzNNavwZLNju+Q9RUPMTPPLtJdpeh/umsp6r/6LgqT3dny/LdVbRTq9IH
	hZJXHB980xrRIr/tzQEQwxWFeWL1AytjcE4t+NIV/JYFLfBNvmzWdzvjvPHr0VrMXhJ3Zg
	4RwW+9qTD4QcPDoJ52raRm0VeaSsZpE=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-533202fe429so246081cf.0
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:18:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791134308; cv=none;
        d=google.com; s=arc-20260327;
        b=QZYxpHO0sUzNWQYHDC54YbWqR1bKUmm0J3TsZ5WkQe3QvqRjdVVz+zgv7vrMPTfcHX
         3Y41H3W3h2f7W2YtEYFGJWDbc/jHMWAxg9T04QaTxyPGFbUiJFxeCkFTUzWZpg2kBWmP
         ozP6lLcl3a2jzvr4B5AW2pWx7gROWygqzP/T0h/dSBc1TSWrzVDwdnYWntQ1st9HleAR
         GWceaLVL9NyXs1o+KJXekaW8wiYw4ejkoxtv1onGZyCyjnNC7x6zUI2COSw9o9LRXQmM
         6ZMtIakyrSmKpGBJfgIoAZt1wiS7UrsGpy0t9uMQfZ3VSdXaIBBw2CTrBZ9uQtkM21IX
         lnkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QinBTGgc4+2Xq3VgxIpbr+CWC5UMzdARKszuxAv87KA=;
        fh=npMZ5F+C6GIgJCKpCcEvBI5+pbqe6HF3RNzVNFpjMj4=;
        b=jp35UeLQhtLy6FnBGiKHHvnpcmcKajnt6XhaAoSc3Sf2qWjwWiRIRdIECrsQ0M1sAq
         YqX1A7r7ISLyoOt/fCdAyxKjDf+pwVaLGD49x2v2f2TUAarplSA26quhA6PLpJi4mxvH
         RrLAlSprtaLirl3OprTldpA4k60N+D8sWR4/Mtcnhi6mG90xMMDEYD3QIE++MODU2EMr
         lH50YOpNI0KO/ben3xmzmCtR67s4BWs09cLvijMh9js0JsQ2j35dSjR+19XpFmpECT/A
         3mIMVrGsikK/8ZdtbT3tU1zqA7zMxZEknns3fKotpfOuT+wJjARr72CZSSDwWSlkAhD3
         rYsw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791134308; x=1791739108; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QinBTGgc4+2Xq3VgxIpbr+CWC5UMzdARKszuxAv87KA=;
        b=lMmNYloFyLL9uHbXeztstMxOk01gxB1kc0f6sdg/TUWKyRicu/k7FmI3kEH/aFS3ob
         +rY5nlrbL/Shf97Ii35MywWQoK2fMp5QWTmfccphrt0i+VYZQDyyCv7NwpoCZEHd0x24
         ChN0izN4LPg73qfFge5eOKGxgHedwFlg81npM1veoS/BvDKjWA9geYxIuICZDWVJ3YGw
         3Wf7l+xKkeUuaW6jcAc2FMzBApo++igT4Hs7/RH+ddq4SeC1eEXEgnCL2U9GewZTQGFo
         Xr8bi1TLgKkhJp14V7FEUpUZgDBOYH/gTiKDZaDy3hk1rzOBl0e9Ln5cwMcSztq62cyx
         Gnvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134308; x=1791739108;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QinBTGgc4+2Xq3VgxIpbr+CWC5UMzdARKszuxAv87KA=;
        b=CcagfNtDvwXoP1Lg8ESYwKVUhvgN5LHgdxclzVuzMiVmDSOu/nRDcLVa3PZMb0IzwV
         XSbRgkbKh5SEcU/zWlok7lP++yOUCgiUHsK7uS+cqItw7VuuwXJRCC9zXUe+JXhlcU3O
         VoOcjeVQIHkzZj40bnwkKTPw+0ztCCSPZ4W9HIzjF8n+5pVNWrvoJZYIS0hw2UKMdTkr
         h9ZzX+EJPzyb+JHoNJbe+HGXK5dsdsA/oMXKnY+08PRs0TgBHRoeX0GQ+g//KzQ4YEcm
         +h8FuXxCFm6Z9rWhj+OG+1W4TIp29R+cMblKib8WcaXoDL9tRVRO1J9aZ4EijuT/Xjgo
         MZNg==
X-Forwarded-Encrypted: i=1; AKwUvBybPkgFx3JIEGffJgsh5aYVfMd9Lw/4FZdRUOwK15L8ZvT9KbDTQQ+u87jaf1lYouCc5dNyEy5w/A==@kvack.org
X-Gm-Message-State: AFuF++ny/wi9AvBKeuoCsSGKg1X/uOCXJFc+8JvDuk0JUBcXTjzBkRG/
	ehD7aOEp//oZbuWHgI5aEp/dXUd6EdpLJD3S62G7g4IrShcMLGuFsAu/2YoK2g9QHj4x3QrUtU7
	UaVeWOerYdDAASOc4cTMEMDBDXvjHB8QpLauK0Ogd
X-Gm-Gg: AYBFou0rxbkcs58eKOJH0//9XVoILW4aTn2+Gm8rBLps+Xxekj8j35aY/+HjOfxJzHF
	v7J+j6I9jq3tWUFFi4ehd6Lf+nr++L+YfEjrTFWgEXGfhniAIhXy7YxdhIrima2ELU2NGU+NVNY
	3Zlcy8DHI8Yi6jAnC5cybSykeJ4vCpDTrXPgBSGWzBiesnVVuO+XwqyXk6rCFspD8loVqOQeRTf
	UL2PvJ/AnzipizoId+3lvDLheq5CLpr7BsOZJEQqD+Lfc5XIo50ChFobPqWkUktMMiZUIiKxIGm
	sNeUKuuSCj3+IDttXasDP8+cBSj/jKPWcCKLAAMfCo+UT1G6qw9QjTzy
X-Received: by 2002:a05:622a:1b91:b0:531:34b9:2532 with SMTP id
 d75a77b69052e-535146ce3e1mr16649101cf.4.1791134306600; Sun, 04 Oct 2026
 10:18:26 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-9-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-9-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 10:18:15 -0700
X-Gm-Features: AclHuK_AcqqolMBhSGAldWSHQHOOTkitmvHnvL2po1Vgiun02DenXRmiOZ3VQUs
Message-ID: <CAJuCfpFkfK4gvBPVoSiSdKs_3LR-0-dw_08BVxs-NqCvQK0-Mg@mail.gmail.com>
Subject: Re: [PATCH v4 09/38] drivers/usb/mon: update to use mmap_prepare +
 map kernel pages
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
X-Rspamd-Queue-Id: 97046C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: b66s198sebdex41xw8miaanmzdtd4us5
X-HE-Tag: 1791134308-626262
X-HE-Meta: U2FsdGVkX1/sJFLt/0OJXOZIT2OsVFkZfPl1xuSCU0kKc0Fy6KmqDnq9zHjfeVg3OI5VNC7wP/5A2/5vpBliugxFNt0gcRv6GhRgpwB/+7AoGxOWgqYb4XI2iFfj/nwZrxCtjQIBqzgHduNLA8FzNu8H7Z3hucA6gy/1exI8CbLFtmen3V6E6JmIvfho3HWjDEM31Mtdtgk17Ptq+mQxgalmjuPVbFfQ3Hjy7VfwmUfPsxW99cJIw/kl/TgWJNdBr7cn1+jwHufN1HkgCm9KT1rwvTfzL/qH79/syehfbsVTXXl5+k5efbe/GCEN6f1jiRa1xk6Q3lSahvSobnMhlOA7uSgaOW5wOwE3rUseHT+SXSTNQDC6qDlqnpIXPwSc8CPHm5Zq+6ena1GQ4Nq83UeFIawQbLlH9JCUnUljXU4lT+tZGEn6/aKTILv+nkM2aPas+3kZzcaVn7lqwQHTjU39GONc4RtHBI+qKasfzhqRVCRFlxtE17gBUyboajtJu7WjjEgOveL+K8G34JByA/eYymVowR47c5EdG2y9ACxjzWa7PEm3LGa0C4x7vHsPI7x7C4Z7OjDsp6eVttUkVa1CS/jr7Xle3uOz9bKHNn/iT5Yeddf0WQpA12QO2SGdr4bFEoP0vsUT2It1XN6jZ2jlRUDVDEyLYGN+KIBmRPCZR++DVgGpJR4yIIipYYYtYtB2x9p6WnxnYx29O77/vIY0JwA4X2X8/evjlKPcM4wmB36xevD2tDAHzl8/CKZS+Rr+ImxJmpY0jIgF1Zv7eJZ6LiVRpP9XQ9Vm8ZvrQshUMalPRDdLsCusiT5uSts7v5ZDV4Fr8icyCzgACEfNdiGEG1zp6dbljttG9k+LQ43zv9v1LBJBAe1PXU4CC5rNOrbJSzl3KEMGr0s9MUIEnrdELR/tE/Xew3l4LUHVZOOoFS872KN8NW2uKBFb07J2VJkpvIe2mQSQLruMF+G
 KVHt7DrP
 0PKKNIFT7mjhseGA7hm+7xJee0zWOOFPoFxlQPSwo0zIEYVX7TwctTLkJoFMU11L+cVgbzCv+voPeV0/hoy9WwVI/d+ENjl/7ur5NPIZNR0gQUKrjOPNwCEh2eHLpMKUB4jyZFYrmc1/ZzcbZG8xaBIIyq0sHRzwnwOz/kJl9E6YYOGcFg6PSNB9jSyeNvSXuHaTqOyUloMaRyu45kPxJN9AGwO/LRbjN2YLSXBNZX+HXrLz+8IXDdQmNPV/xSLG6C+45tvMPsslQqkTxOUHxdjfKvxPYrPlw/H6bOIDwLA6TgRXiFkA53RFuQNVDJxxOkAmyknfWZ23CNXh0IzAqyWrSO9f52tW6AwFf+U0AMtCYSkoXGXACxOz/2wS1UxV6krzT4T4kHH2baki9XeNPl3Fmm38Oo4NcOUsUU1fm4fHCaf6ggHXU9f8sg0AO7TzwuOatWR/pG73fzmxHvqyN9a4A2TcGdSgdLbmqrZxw8zlRvZoot6yjPSEt8quAPbkPNTDvCMCzprk2exWNXB57DNK5rl+MWtP/5zgJfbLDiGoh465fL1+CcyDgBUm1e3zmbRgRXaHpHoPb36StwEdF04ZtQw//+OdAzzQKeKztjEXDbfFJhZ511hToi27igivk+hUTYP2ouwo+/7gnXyYVFOeNzO+753dO7MlumtuamdS32cgTTfOz+zATPUNyCmJb96VMukMy9KkZK6GILtS3iozra9Q9E4QJpC0QEF6FcG7T+SrW8816roELB+oMoqMhvCowdHzpgx/tF9ZucDbB1iGIXyx5qfBuid+cdL6cSVkOP92ul4eVwlhC5lzqRG2woC2L5EfYDgtKFVv0AK8vMvfcW1I6uiONmIi01rngtQLLKofjQa2vHLIDOUR+fFVGgRB/nwH7AZ3zyeC8nWpLBFvOj6EeMeGZ4CJYfWgt+p9CRZ/XTDWkKpcC00i2ibKT03EwsFXAbYaHfGkDE+ITiRpra3YB
 WoISwZzy
 2MRNO0BsBuizrU6Z3EUHkzQTSkJjv94CYLDknMBvWVs25vCi3TxthJhILkuNKsR9aQTqiLqXvWPLyddnxLsyT/zXxQPT6WXnakB0Q6jAeo6oHE1m8fSArvlFoKZlqew0e1IG6PKjZhJfVEeS4NlRaj5FKI8A8VYHT4NdKlC4Pw6emMGTcGcDgtA6QNAaW5ul8LPz8Lmzy3cBlnwT7cY0csAPWPsBQJ263S+j6dHA/cEKf9eY0j9p5c+mvH6kCpyePYaVBurIUPguO+G6P6K1PGSzooPlAqYaNtjenXvoGolm9pFRe/TM3+/7xeMBMjqzTbOLBk+v/UMvmB8biy1NK3dhyA3lT5PGq7SqvLhZPmE4x0X5VZQSi2JdP7WBUXPldqZTIlGb0W4DoJsY6ushctsJAajml6odMEgEjTsoXCA69Rn4i8PVP4HrnoI1LvJL3qhawGctjYr+TqCFCpqhfa+4obZhRqWCuK56TIuIhxcAxW/+iK4WBJ0BxJQ1cCyqf6uQJ0eWqHylTJhR1fQRCDzMaJ32OBJ4AJYc7XiINTZAi/uqD3445tX/Zn4w/lyc0rpQOa5T83LoWwB30/KPBb8d3gV4EPy3icYRZwMqOvoBe7WFMsoZspR57wLaXiaY0Grp0St3I/yrGadfRRknU2iNl3oZzZIhr8C9y01oExMSvIjibQeXwQKEogCUsjwSLyHWi2MFrQc24/htOTdKibhFkfAfZchsn8I+Xfy66HT/XLNG2/4Umb/uTWxd/qCQR6RWnLXEuadscR1+pKzQ0Gh42UO1EatxGcCW5mryBrh61zqowygm0S2B6mLgBSS85gewMPn7ur/frUQTXcdLdZ/uxClHs/YafKBEyAp+h+hRjZhJB2ulPvramfUk8/4hBBji7ARp+lgeCov7PYopEnyOjycnYCZcU9VzPvi1YkMxebqaMx2EcPc48HLYSI+OgBoErXutFbDO2N+8ScAx+roAcWqlK
 +Hri+YQF
 To1ZVOHHfesvDlPwwx5McIWMW+TuVvtkRZqIbUkY91MHa6hqaA9LMaUdLcC4xm7sv9RkzHsd9+iTOBi2SyIdiOjoX6T1eSffp0UcumkbGGe0qgHif803xS/avDv5XchhSUf9CicGHHF4mRD+Lp32wPQX4dJGGODplIMU3hHTgqNta/cst7xwVywmiJaKivU3Sz/7PVqLykAYnE1+A5pWQWCWtUe9yZrsJAoBZarKIMSExfA6x1XHpny55WM2qyWvR8MVKfb4S2XhNQTO/C+lIu43/CGXBU5pIQuqnl5chu7vKQPwe1sCkZdKya35tqY4E8ohBai8Ul48cRacnwlE3XapY9/eRPnl0bkrYV6nFt6v3GCuYXg+hqL1hYT8yJ61WUpwwFrOj2eFJTEbzWXMzJ+Dzm481o0z2J6guYp0LOYZrYVGptiT37SimhEKV+4ndNsxKTJHWjMFhWERY7GeyU8b9ADeFhh96B4/E7Xg0mpSa6mJaZCOdlCy3G1eezfGa9tjdzDRPbbEzU47gC8LNrryOd+DJO614XTgKza60J20ZpcUFUtCJv5xavPK9gqnL6II+7RmMPfexo3J9UMj1bsobI5W9KhEp2gWYk5NyP0Ec1iKLtRPAmyG2Qwd9mH2KaYRWBD6ogR4oOPYmf3tr7Xkaftplz/lxijfxf/f0h99z+nmZtW3mt+3I67vNFL9pGGfS6Chm1rbAq3FbXBpyKZm/6HFLATHETCurK3y3QO1ULHUpM1T2Q7IJ+gjylIgZsVAR3UmZPzYsjT8M1f1OWsFQPexDaHuAX5PqacKet0Y7JnqYbwglAHG/FCE7xyjQM6hHigoKpYXk2vXidvQaYduaI0c5EhLzt+cP77GXFavv4ftCpmzqls5mgtIWSCGz00Tcflj1IqkJEaQyiYu8lDWJUHU7ht/TSI0c3CVMvPUo2mAX0Dh/79Q1xb9Ac45EoAJHme/RvW8XQUly0IVT7NBbozaH
 5d4+tFn9
 kKMscFz0wB6hdy6PN5g1FOe0OmvZ0pJowh4pFyoLaLtGh2JapkZRh0BPSyuvVQO9kjWze3tVXFY36MxaSgqN9chz82Zd0Sng1Vef1Me1ej94+53GXjebl2WeKNoTNFPwnirunhkdSnvsN8PMgF9kHZAzX5GtWUKeLyJgK/BGR6b9SP/20ioGqUW9RAx3l3Ge+Qj+9Zc7E8mm9Iudb52QhDRbjHjNSj1bOIrZhJEaYARMVPnBiDW8m6TtjfKCu5++TWnh0SY8rbrGdpDpJpxEXxNo96FoCN6uPWbwvxxkWKOkLxOE8Zap+VTAX9ZfcmtVaiUGixDND+Hk+BcOIm3pp90HVoC7gT6zQyW40zc5wVp8otDmbIT1BJhQdlbOU4gCAfBYlvg4J52J1BsZRnrZCHvQZYKose4nefKHv8t9EniIpTi1OHooA8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 6:36=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Replace the deprecated .mmap hook with its replacement .mmap_prepare. As
> part of this change, additionally take the approach of mapping pages upon
> mmap rather than providing a fault handler.
>
> The page span cannot be mutated when an mmap mapping is in place, so this
> is safe to do in advance (the MON_IOCT_RING_SIZE ioctl operation exits
> -EBUSY if it's attempted, gated by the rp->mmap_active reference count).
>
> Utilise the newly introduced mmap_action_map_discontig_kernel_pages() to =
do
> this, which allows for iteration over pages in mon_bin_discontig_get().
>
> mon_bin_discontig_init() increments the rp->mmap_active reference count t=
o
> stabilise page spans. Should an error arise the core unmaps the VMA and
> mon_bin_vma_close() drops the reference again.
>
> The vm_ops->close hook implemented in mon_bin_vma_close() will ensure
> correct reference count arithmetic upon unmap (with mon_bin_vma_open()
> accounting for splitting).
>
> The existing semantics are all retained, including not mapping past the
> range of available pages, with a SIGBUS being raised in a userland proces=
s
> that attempts to access past this point.
>
> Ultimately insert_page() is invoked to insert each page, which increments
> the reference count on each mapped page. This mimics what was being done
> previously, only we pre-map the entire range rather than doing so on
> demand.
>
> The existing fault handler did nothing that required demand paging, and w=
as
> presumably implemented this way for historical reasons.
>
> One behavioural difference: pages are no longer faulted in on demand, so =
a
> page discarded with MADV_DONTNEED is not repopulated and a subsequent
> access raises SIGBUS, as with other pre-populated kernel mappings.
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  drivers/usb/mon/mon_bin.c | 82 ++++++++++++++++++++++++++++++-----------=
------
>  1 file changed, 53 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
> index 687f6a8981f3..9d00b21a8153 100644
> --- a/drivers/usb/mon/mon_bin.c
> +++ b/drivers/usb/mon/mon_bin.c
> @@ -1219,6 +1219,15 @@ mon_bin_poll(struct file *file, struct poll_table_=
struct *wait)
>         return mask;
>  }
>
> +static void __mon_bin_vma_open(struct mon_reader_bin *rp)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&rp->b_lock, flags);
> +       rp->mmap_active++;
> +       spin_unlock_irqrestore(&rp->b_lock, flags);
> +}
> +
>  /*
>   * open and close: just keep track of how many times the device is
>   * mapped, to use the proper memory allocation function.
> @@ -1226,64 +1235,79 @@ mon_bin_poll(struct file *file, struct poll_table=
_struct *wait)
>  static void mon_bin_vma_open(struct vm_area_struct *vma)
>  {
>         struct mon_reader_bin *rp =3D vma->vm_private_data;
> -       unsigned long flags;
>
> -       spin_lock_irqsave(&rp->b_lock, flags);
> -       rp->mmap_active++;
> -       spin_unlock_irqrestore(&rp->b_lock, flags);
> +       __mon_bin_vma_open(rp);
>  }
>
> -static void mon_bin_vma_close(struct vm_area_struct *vma)
> +static void __mon_bin_vma_close(struct mon_reader_bin *rp)
>  {
>         unsigned long flags;
>
> -       struct mon_reader_bin *rp =3D vma->vm_private_data;
>         spin_lock_irqsave(&rp->b_lock, flags);
>         rp->mmap_active--;
>         spin_unlock_irqrestore(&rp->b_lock, flags);
>  }
>
> -/*
> - * Map ring pages to user space.
> - */
> -static vm_fault_t mon_bin_vma_fault(struct vm_fault *vmf)
> +static void mon_bin_vma_close(struct vm_area_struct *vma)
>  {
> -       struct mon_reader_bin *rp =3D vmf->vma->vm_private_data;
> +       struct mon_reader_bin *rp =3D vma->vm_private_data;
> +
> +       __mon_bin_vma_close(rp);
> +}
> +
> +static const struct vm_operations_struct mon_bin_vm_ops =3D {
> +       .open =3D     mon_bin_vma_open,
> +       .close =3D    mon_bin_vma_close,
> +};
> +
> +static int mon_bin_discontig_init(void *vm_private_data, void **private)
> +{
> +       struct mon_reader_bin *rp =3D vm_private_data;
> +
> +       /* Dropped by mon_bin_vma_close() on unmap, including on error. *=
/
> +       __mon_bin_vma_open(rp);
> +       return 0;
> +}
> +
> +static int mon_bin_discontig_get(struct discontig_kernel_page_state *sta=
te)
> +{
> +       struct mon_reader_bin *rp =3D state->vm_private_data;
>         unsigned long offset, chunk_idx;
> -       struct page *pageptr;
>         unsigned long flags;
>
>         spin_lock_irqsave(&rp->b_lock, flags);
> -       offset =3D vmf->pgoff << PAGE_SHIFT;
> +
> +       offset =3D state->pgoff << PAGE_SHIFT;
>         if (offset >=3D rp->b_size) {
>                 spin_unlock_irqrestore(&rp->b_lock, flags);
> -               return VM_FAULT_SIGBUS;
> +               discontig_kernel_map_abort(state);
> +               return 0;
>         }
>         chunk_idx =3D offset / CHUNK_SIZE;
> -       pageptr =3D rp->b_vec[chunk_idx].pg;
> -       get_page(pageptr);
> -       vmf->page =3D pageptr;
> +       discontig_kernel_map_page(state, rp->b_vec[chunk_idx].pg);
> +
>         spin_unlock_irqrestore(&rp->b_lock, flags);
>         return 0;
>  }
>
> -static const struct vm_operations_struct mon_bin_vm_ops =3D {
> -       .open =3D     mon_bin_vma_open,
> -       .close =3D    mon_bin_vma_close,
> -       .fault =3D    mon_bin_vma_fault,
> +static const struct discontig_kernel_page_ops mon_discontig_ops =3D {
> +       .init =3D mon_bin_discontig_init,
> +       .get =3D mon_bin_discontig_get,
>  };
>
> -static int mon_bin_mmap(struct file *filp, struct vm_area_struct *vma)
> +static int mon_bin_mmap_prepare(struct vm_area_desc *desc)
>  {
> -       /* don't do anything here: "fault" will set up page table entries=
 */
> -       vma->vm_ops =3D &mon_bin_vm_ops;
> +       const struct file *filp =3D desc->file;
>
> -       if (vma->vm_flags & VM_WRITE)
> +       if (vma_desc_test(desc, VMA_WRITE_BIT))
>                 return -EPERM;
>
> -       vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_MAYWRITE);
> -       vma->vm_private_data =3D filp->private_data;
> -       mon_bin_vma_open(vma);
> +       desc->vm_ops =3D &mon_bin_vm_ops;
> +       vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
> +       vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
> +       desc->private_data =3D filp->private_data;
> +
> +       mmap_action_map_discontig_kernel_pages(desc, NULL, &mon_discontig=
_ops);
>         return 0;
>  }
>
> @@ -1298,7 +1322,7 @@ static const struct file_operations mon_fops_binary=
 =3D {
>         .compat_ioctl =3D mon_bin_compat_ioctl,
>  #endif
>         .release =3D      mon_bin_release,
> -       .mmap =3D         mon_bin_mmap,
> +       .mmap_prepare =3D mon_bin_mmap_prepare,
>  };
>
>  static int mon_bin_wait_event(struct file *file, struct mon_reader_bin *=
rp)
>
> --
> 2.55.0
>

