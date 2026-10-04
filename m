Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54100CA5FF1
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DAB86B0092; Sun,  4 Oct 2026 13:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C366B0093; Sun,  4 Oct 2026 13:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F646B0098; Sun,  4 Oct 2026 13:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA1856B0092
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:54:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44F9D40BA3
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:54:42 +0000 (UTC)
X-FDA: 85285694004.25.ABDC5AC
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 616A940002
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:54:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uoHSRxVs;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791136480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fdcss6XzKw26cI5TyCzpDNu6o5ifWClMegsH9OJNnig=;
	b=iI6HQ9S3Df2dZVXJY8QFhokm+OIAPxXQU7YrlY/+tedGjK9aF9/FgKYoGNdXVxknFDv/nU
	M5wLF2Ku4jO/DzkrloTBBgPfR9wj5AcA+/GdCKHN6POEX6udALRD/MmWHNn5djZ/NVtMYd
	F9xG8xPGxC+Ti79vbnyJe15JmhNbJzw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uoHSRxVs;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791136480;
	b=ip2N5CGjr/UeTZ2vDsKS4O43du4Ih8eC4gBy6WYqe8O7zFW8MrSVqMr/16TvdT5Ukp4/ZM
	Hjm+VeOcZaGbJICdzj+X2htHxzybrlSkwad8xM3tsvU5KivRwKSElZmRx/6g1ipAKzJyTe
	zc8gOPJ7kJBlc8/t8TEZr1tqKEEN3DM=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5351f9dbfe0so98011cf.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:54:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791136479; cv=none;
        d=google.com; s=arc-20260327;
        b=h1fCy4l+2Q+XPhfkmgLRkg6PE1MUjKqRd48TFww+I1Hqzj/1971KBCQvJeeEWmrQj9
         1y/an/Tm15YYr1m9nSlK6fjbyxNIhTxUhL81Ty4HPyLHpGpedQ1Qpl8b0xD6TkWaJHZL
         QnRBUeTIcolOzCYNceUeo50XEllo6TH4f/NVrzRYrThiw3RtLEK4vI6I8wqAvDbTKzjT
         FspOZNAWowVgjpRoWreXRqy22YynzPZ7W4jGWfgLaorsvAZlfZAnviJuLY/owE2PXO74
         z0T+r1qWjC7o8Js8GtF03EY7foj5fakLhdJbhqkrb88IIKYMladmuuqcrMOId9MwRxVL
         8jAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Fdcss6XzKw26cI5TyCzpDNu6o5ifWClMegsH9OJNnig=;
        fh=sxA+f2qg2eR5g2PRrrZLWAiEUqHr/PrcGeEoJzAqasg=;
        b=GQNsZ9bmtwcfSD1Uidw37hu5C6xmMX87v5RRzjCAPT2TiSbsenw/PL0w6D427n0Q2d
         Tc8Qrgekin4RHcotDL4esvV9KGT5Bxs0uzXH5pfmhvsXvKEdwfXCyBIbr2HfPnxqlPH0
         Ujr7LIAFiI9C2cSi/cw9yRGRG6Og77yG3UxNczy3U2nmC2Lw1TC784RlA8MXAg5xnf7d
         mlljDz7cg2S17m7lQoFWjCXSW53ecBXSfyzhAxlzGfzhHeyXDRGwvbnSrONdC7IwjP/N
         tZ9LTuxpZ2t6J55yO0dNkbzyf8/7z98lzV0S5bsweKQTPEABajce1r/0AgEDoex3C6fo
         tF7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791136479; x=1791741279; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Fdcss6XzKw26cI5TyCzpDNu6o5ifWClMegsH9OJNnig=;
        b=uoHSRxVslK2w/S99vHe1DpCanyoWeOVRInkgTlLQREhfmvabpQr0W/VEsE3EvMFMx/
         71GklVnmS5qfSjm7SMea6UPKdoCan5sogQOTJXM7LlmIrXzJa65g6sQrghhNz94dKYMF
         1rU8swaZZezSVKtwxlPrakNXUWy2aVxKPKSR7BPhcN01BVCV0aLL+K9ef90UeL9pvbbc
         1VoQSSf5SCf2DnfTSY1lsg/o9YTrFWzlXW6ZIGfBDfP8sBtrVuiKEZUDreC8VtmbcgC7
         bnXTGMlXrv1hkWg+6bVCL+37DtC9wML+WNR4ybo+zAMxDgkGyeQcpu32qA6z4ibROmU2
         L/pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791136479; x=1791741279;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fdcss6XzKw26cI5TyCzpDNu6o5ifWClMegsH9OJNnig=;
        b=ujcMrmmlKcs8D/s5naE7zkiQRPuEbMzY17HMmzfbT9z5ubU547Ti9544mgfQouFOPc
         oURa4ABKtxogFc4iDcbp4LKXGhMt5HyzT8F+7/wgBfT+i1PCRBYkMwOulouL0vul8PQU
         YWkW/QjWtZEcdRJIdOVxZfh+7UeM8Mqa68ATKInroRPeexSwP5wWBVTl08bBsqysZ+oN
         +kiDQWwYwxFGIUFBI2npwCn2HS8GgygOsWQFF3Whw5tyEFrjshLL8Bp1YDRviH0bQfIp
         11kSMu5z2HKl23wF2DPpEcEmwuaEMZS2woGyzEekm0UON3xtEqoAPSnoikyn7Z43ARKq
         +P/g==
X-Forwarded-Encrypted: i=1; AKwUvBxB891NvsGtWyfHIc/8Uo7Dg1Dn6VHWvBts1sEt0QNAh3UW/FkB+ryuCV0P3o+2wgxE1eYruliJ+g==@kvack.org
X-Gm-Message-State: AFuF++m9kQ2K2nhZ59niHqRzZr/zMH6+y7sQOhWRCgdvxUd45BRHAXv5
	FvFebK7V9JXQfDU6WKudI2MKZmQpnuFpqj8bYNdGkEDGX+UOLs2TCrxbz2D3zikwlayWw0uOKNM
	F/0xYguMoN9TigATOt9b9SOoGn7H5AQoKUiFtpGhH
X-Gm-Gg: AYBFou0wWszz6rB0tiuCUnYg3y9XZuICBf3dN+nhZoM+0e13khE8CG4+mwKRPGnCwIB
	wPM3+smgnQxwBDt097P1j6dreaYv149J3WmTHnp7/jt2VfHqO4JhpQK8qSdyY9FPe+dMc59J5ob
	9Vtb6l8zS6MXHJq7Y+UvW3ihiuEM7vGmyKIBsJsD1hbseyCeJ83sRKcZfM0ELLZerVu+VN98wta
	c/NppiYk+2e2lIlFpveqTAlgRRvdRgc3o51a5zYOkdk9Y1iARArReAeaLefkhveoG8Kyt6IERWp
	6pnUe/H/zNyg9yodolOU7synRY7AEF2pnFZsRqWx/5tmB142MeZvPY6/
X-Received: by 2002:ac8:7e89:0:b0:534:b7b2:634f with SMTP id
 d75a77b69052e-53514799503mr16690141cf.8.1791136478525; Sun, 04 Oct 2026
 10:54:38 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-17-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-17-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 10:54:27 -0700
X-Gm-Features: AclHuK-Rg0T0ymL6HRAgNQPZX5D4YqOng-e9RJRoGVP6zixq0eakV-RXfXJpvBY
Message-ID: <CAJuCfpHM9-VY97TD8yXCEcWirLHik7UPf2_gv5CzqEexD2hbHg@mail.gmail.com>
Subject: Re: [PATCH v4 17/38] scsi: sg: convert mmap hook to mmap_prepare and rework
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
X-Rspam-User: 
X-Stat-Signature: yoe5kgucs1pscmef1pea4oyiyf5sc6n4
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 616A940002
X-HE-Tag: 1791136480-394949
X-HE-Meta: U2FsdGVkX18w0TPUl4NllG8iLglheXVt5CUSRnubR0Omszsf0zkVzOW9/zlIEzgeffmKqKKZUd5igWT+YHMXYd0JwETxBxQseOGyIK88tbBnYdaPOkoSUFav8I4bOm+wduk2ZiSVz8RBc3oNkSn68uJDe9/sKMyH5o5sLmaL6M3zrfSpRNVeij74yV3W6/zCt8CNJR1FxH9+cLQhipq6VVEuIsbbb3FDMMgWhoSmPR63LU/Z6QK0nX9zHzl/m5KEC8LH2pFtW1I/4qAXrl4o8xFNffK2BAkluANO+PYb53bvqYucRDeeLCPkv2Pry2AMaNEWsq+v2SwliDbsN4QtVZOTuAo/ZkIxXNOjTVIo+I7lQzpiSBx6o9Nfv758r2QfkeLBDuUivCuQtgxE0210AA87+8ey4ZZViVCkNDHJ7MUSx3nKlt8mhTaCWItj5sl71WVBiIKI9Kbs/uWu2PEUcCJl1B5q2N77/2fKbILw4GXjm+ZHCrRKMSc5NiXmRNGTrVm+p4HFB7IwLlSHbJpR82gjm3aTD3KzsAbbgEO3zRJs6tBMzRwtXwRFTHM2sjXPcZUC5XbhrhhEdMA8j7JH3xFMn+vxR/TyVtw64IZN5CE3fTYexe/nrfRTN7x00NtrFfJMA+m54ldY9EOy771+LBo8xm1tRK2p2b1fWV9NytcMC7MmhvdiaRALeNB/6AoWKTPiUAGP2ms2F1T0MYwdAWZH9wsd4XEG5/Ubl8glMiVBwhTc/gBZplrOhOW+K2kWYmaHl2ch/G9NUB83PgjqmBqkZjoFRZmW7NIC+JqwS1GPDURo7o6OoCs+Vmvr7RO69suG8h3tJ8ORN8x133XlA9woWr7h9r9yOayiQPxxrzSI4Rm7JrTMa7yOR3q8Y9aC910NYG7g8r9Rl9TxZV16+AL96XrHubxpOeesxsN4Gg/6Yv/qRnrR3fjudiKXEtMiAiM3B0ZtZlfCyYMCpAp
 jzMZpZ/S
 38W3K+45mJx9wwZ9bsdEq5Pme2aNs5nfr+CinQj2+RMXMyuJ1PjwEuNCaKzCbI+hu19h+vUW90GEjcOZFav+8yqGXr3j91xvS3iFLSlUyqlakLmKxIIMSiaR9MT9n7Q6H2xT55KoG2VTzZvXJxgcmXqTTt/m41TAPCjZ5pe9ZwmfLe3z5R79fhFE5QtS4b8pA4pIQJ6xyvDq6MY+kioxqszWFB6wYdjImtQLeEiK/ShI/xhUiQjrmtCuzYtzENFOH0kiREB1UK2BdJiVrXgtt3Etmqg0JaCmBdam1A5G8hQXnjWMwfyr6ikiTQuHtfmov8cTPhaGXWXs0mSEkH06aY+rvtgvywzMuwiQYjrJPs8BgDozLQaSP3fbDTqwF3rmN7lMSMkh2JaSgKxExUCo/VwHAG3iTpqk05FjJBQrHpy9vIRvcqb4WtgjHSLsdAteRnjM81ADDEcmnQI81gZVCb5j6GrHo9Vfc23hqRBgXAkBVJdodxAqZ2pwK4y5sB/xlFEtzD1e84B+Q3j4p3oZxn4Ig+Sy7xHg14jTHRQad6p0VRts1o6l+e9SgjkBBUlr59CK+FHhFxxvzevAdMMgEIz81pfeLLZ08iHtP0ZPHdakqyCllcUCLTkhCIn/QA1LoS6UEWc0R+DEtNIS59mB1A7UkfzwxkDXrb8w1Z+R5sPX7+UhslITL9WnAponfUwe+WdObeSoNBYUjT89bNUs6mKYY/ZiCNd2epbLWF6BNjgyVqDonwHbUaalsLY4XdunkNEMRrFko19wNwhxipt/VyrbCe3ioenRZ2tA+OlXbrb5scb30riR5fsho+Ug6db+XuV86/IecrD3UGO/eDMF8omE1slQAL/msJs+nOO3lUWNzhPKzoPltamGb5f3GjaovQ4TQKNfYbCVzsMFMusCHCsHAjm4RrUSfaMVGhM0PGETAM5nkaPagILhpomjKKK7rQeC7rkORxcSVLfGriCKZUOAKIDuL
 Vr/kn97C
 xMZzx6pee/mRCcbu3ghut0yxQxpBhsi3n05LENnGYqkZcgICsGLAwY9ey6bBa57/hAxG+YLlbmfHmrf3WjcIB41m+TDoZJpN2cVbrHfa2bYrqC7XGEb2IWQh39EInViUEr3iaga1R6lHZdWf1NPzzxjU+h6J7VYQp7c+2KyIKiodOjbdV6uXPhveCxswgrHlQ2Rwgn0RrD8w+V+bx2K6hIt8KuLwy4GA4Mn+9Js8ubwg7cU5ckuyS5Ko0rCsb27c/4W6yfNTaTu4xwbxZ1ZrlOzdEiOZO5AcraHilQbXsvZbrZ8pj1xs45b0tyH1W+/5RFYShdQFcTpJFNrNEbUvH3OCMgxXy4ujWK+JlL+NKiq21Qbw6Dh+ia4jCuO9/oTIJ6hwpI387rpBsmL/TXy6q51GLnVYx+MFr/BaytWTBZYEeondeCfLrUNwPCywcVUrbIcCVkVXomlOrJSO8xhlTuJaGPD9aZQH7/zVo+ZaQD8SgsXErXsaV7125fct6WnuS3YqOuCzTllSvlv5wNlb/9xljCRf563lbukv6ucNfMyAjy9zp1XEyJnxsvs8Abn8FkQsSxkkMEuHbCCDeaEWz1wKuLzXUvrBxQo0joL1Md59hZsOBapLFJX9dRkHBzg+uGMBaBgTyTWUpmp4z8i3ziVTQ/VWnTWx4kZOTo6e9QO+A3nOwSbLE/2QXp/+MCHyqN5DqiVCUIlt4uOfnPqM9N0qPuHuOTDn7sMYifEGIfK4K/VN32ChkuAKyPiG9SKbNJecwI0z4qU7WoAtnygsz2HkYk084CSZBFXVNfdbAw3ffQ3O8mHTttLa6mt/sdOW0IaIfKe0JQ/KzNAoq7apcY/3dahhCK9Sop76YMhET3pGPzC25gk7yHZPzYcUafYmjz9xptTMF4y5FYXxIJl9qr9vHKxVjWAr49aUsbHaQXWDKtjb76OeJ0AXMrqx0/TqRbzxqQ6S3hpTtIVtQHvoBlWppwIV1
 uQDgECQt
 4tWzp3UFybFzCGj2740gVP+mb0jvU0+2qQbpbSUc2sTcRjsTnO9tGius1nrmYXrlSAP3RRhhFNMo9LjmcgxfOuu0G/3GgKa2i5DgvwdSK10hVV+JDJV9F3AbIrpRR0QPewtrUNsyDeZsLUQ22lFPrC8EyJ3a24mQvaxWsb3qz3DryjUEX7fkQDBIzhv44dKxJ0947xZmDA1QGhUflQ0sOEtbfW5gtkRMlZAwiXlK6A2vARogWkZtNO6RgBAfue3XNrtzn8ALhGECoZQsktI6CoKPHx6V33vXiISJDoUDqEQkEI4dBdjMLQZvr/RGdTakENl32lwlHXAY/WiiI1zOR2fpLvz63RIu3UpOjQCBjLdKSVfc5/2+XQmWO2mJBpMq6FVG1l4XPF92Bzbhn6xUS0W7jts3D4t3jmwd0nFuXs0ueX9pzTSPQpsFaOUF9wO2aShDRpQ/6OQ2l3zv827EyNN2VRDwCpG3ZetVHJbqczyQ825e121blAapxlSD2zUqpfobLhPv67cI6FuK8FY0/dYIvZ1C+GipiOTfQk0vVmvMYbsfMFTVD4ZU2Jw/P81Bc1L8pHz6oWybeaagA8a+bn0J2k+ERGr1+yHjzLjPN8jSYMtx6lrWDAi3Ej4bGbTLOJ7M7GOjPxy36cS9Je9xJ7YnoyNEOPZEEvF0gA+NYi+VZuJWjJPkf9gnWC0ZQ7Im9iHXdjs53ns3Jxjfgm2NzvAkchRxy46AXgQcTxp7l1T5cxTkV02rGjSIH621wCoh/gZ94nkYrV5OkqJxTAbztsCSjrSa6xUdMjgTE4zCgzGa+5YMV9Q/FJLjORb7UdbSEhIMMERKqfnRwGcS2QV0F7RIiA7KvoJhcSnPBxZ98cTizc1vZ04GGQV1ZdXX2hasIDBT+L1tIxhFm29+nYwJMe47Dbo4rIDfKVYbMu69PusAdAsrauvnI9mUIGLV/ISeEawS7QyfYWsaIS5RtlxoigBVyhjLw
 sJcrGLY5
 xI20iANbhCGMT2YzHGQZbxS71L5MwSnpNBdBiYXiEb+edKqAdfoC8GS3JjazLQOtkXEdnHBr1n3pugQNd05PGiBu+1GMcZsimCqN632OqWFIu4AOcycxdoclyr5fWUYyWjgDzKD+g2oPrkRF7vuukKrtUenixla/RcMk5o4ktgUrBnDWfNazHKPh5YRRTtSRnwLNqWEthp3+mc/0TNXWJEgp1IgKGM01TH5ixZitguVdRN+iJhUUyLVZdiftxErISSNLN/tb302VSGUz4quJoah83tXJ+rj4vZY5mnEnkPIgD4JEr8u6ngEQMfxaZ/uoM72aT9CYyQ9MwhT/ji6hXuzzCtZgJFEe2XEqQ1dr/mDJG93vw7CDCKe0vQcZ4W8Yc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 6:39=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Move from the deprecated mmap hook to the new mmap_prepare hook.
>
> We are mapping kernel pages here, so use the discontiguous kernel mapping
> mmap action to do so.
>
> Unwind the rather confusing loop and instead map as many pages as we can =
at
> one time.
>
> Note that we do not need to pay attention to rsv_schp->k_use_sg here, as
> the pages are populated for the length of the buffer at
> rsv_schp->page_order granularity as compound pages.
>
> The discontiguous kernel page mapping logic handles the compound pages fo=
r
> us.
>
> sfp->mmap_called keeps the buffer stable for us. As before it is never
> cleared, so a failed mmap also leaves it set.
>
> We also remove some useless vma, vma->vm_file NULL checks - these will
> always be non-NULL if you reached the mmap hook logic.
>
> We retain log output for consistency, but change what's output on page
> mapping to indicate that sg_discontig_get() does the work now.
>
> Note that we drop the VMA_IO_BIT flag for the VMA here. It was never
> necessary as we invoke alloc_pages() which gives us refcounted folios tha=
t
> are fine for GUP to access (VMA_IO_BIT would prevent that).
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

The code looks correct but I must disclaim that I have no experience
with this driver.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  drivers/scsi/sg.c | 115 ++++++++++++++++++++++++------------------------=
------
>  1 file changed, 51 insertions(+), 64 deletions(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 5408f002e6c0..3f9e08725602 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1212,85 +1212,72 @@ sg_fasync(int fd, struct file *filp, int mode)
>         return fasync_helper(fd, filp, mode, &sfp->async_qp);
>  }
>
> -static vm_fault_t
> -sg_vma_fault(struct vm_fault *vmf)
> +static int sg_discontig_init(void *vm_private_data, void **private)
>  {
> -       struct vm_area_struct *vma =3D vmf->vma;
> -       Sg_fd *sfp;
> -       unsigned long offset, len, sa;
> -       Sg_scatter_hold *rsv_schp;
> -       int k, length;
> -
> -       if ((NULL =3D=3D vma) || (!(sfp =3D (Sg_fd *) vma->vm_private_dat=
a)))
> -               return VM_FAULT_SIGBUS;
> -       rsv_schp =3D &sfp->reserve;
> -       offset =3D vmf->pgoff << PAGE_SHIFT;
> -       if (offset >=3D rsv_schp->bufflen)
> -               return VM_FAULT_SIGBUS;
> -       SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
> -                                     "sg_vma_fault: offset=3D%lu, scatg=
=3D%d\n",
> -                                     offset, rsv_schp->k_use_sg));
> -       sa =3D vma->vm_start;
> -       length =3D 1 << (PAGE_SHIFT + rsv_schp->page_order);
> -       for (k =3D 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
> -               len =3D vma->vm_end - sa;
> -               len =3D (len < length) ? len : length;
> -               if (offset < len) {
> -                       struct page *page =3D rsv_schp->pages[k] + (offse=
t >> PAGE_SHIFT);
> -                       get_page(page); /* increment page count */
> -                       vmf->page =3D page;
> -                       return 0; /* success */
> -               }
> -               sa +=3D len;
> -               offset -=3D len;
> +       const unsigned long req_sz =3D (unsigned long)*private;
> +       Sg_fd *sfp =3D vm_private_data;
> +       Sg_scatter_hold *rsv_schp =3D &sfp->reserve;
> +       int err =3D 0;
> +
> +       mutex_lock(&sfp->f_mutex);
> +       if (req_sz > rsv_schp->bufflen) {
> +               err =3D -ENOMEM;  /* cannot map more than reserved buffer=
 */
> +               goto out;
> +       }
> +       sfp->mmap_called =3D 1; /* Prevents changes to buffer size. */
> +out:
> +       mutex_unlock(&sfp->f_mutex);
> +       return err;
> +}
> +
> +static int
> +sg_discontig_get(struct discontig_kernel_page_state *state)
> +{
> +       Sg_fd *sfp =3D state->vm_private_data;
> +       Sg_scatter_hold *rsv_schp =3D &sfp->reserve;
> +       const unsigned int order =3D rsv_schp->page_order;
> +       const pgoff_t nr_pages =3D state->nr_pages_mapped;
> +
> +       if (nr_pages >=3D (rsv_schp->bufflen >> PAGE_SHIFT)) {
> +               discontig_kernel_map_abort(state);
> +               return 0;
>         }
>
> -       return VM_FAULT_SIGBUS;
> +       SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
> +                                     "%s: offset=3D%lu, scatg=3D%d\n", _=
_func__,
> +                                     nr_pages << PAGE_SHIFT, rsv_schp->k=
_use_sg));
> +
> +       discontig_kernel_map_page(state, rsv_schp->pages[nr_pages >> orde=
r]);
> +       return 0;
>  }
>
> -static const struct vm_operations_struct sg_mmap_vm_ops =3D {
> -       .fault =3D sg_vma_fault,
> +static const struct discontig_kernel_page_ops sg_discontig_ops =3D {
> +       .init =3D sg_discontig_init,
> +       .get =3D sg_discontig_get,
>  };
>
>  static int
> -sg_mmap(struct file *filp, struct vm_area_struct *vma)
> +sg_mmap_prepare(struct vm_area_desc *desc)
>  {
> -       Sg_fd *sfp;
> -       unsigned long req_sz, len, sa;
> -       Sg_scatter_hold *rsv_schp;
> -       int k, length;
> -       int ret =3D 0;
> +       Sg_fd *sfp =3D desc->file->private_data;
> +       const unsigned long req_sz =3D vma_desc_size(desc);
>
> -       if ((!filp) || (!vma) || (!(sfp =3D (Sg_fd *) filp->private_data)=
))
> +       if (!sfp)
>                 return -ENXIO;
> -       req_sz =3D vma->vm_end - vma->vm_start;
> +
>         SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
>                                       "sg_mmap starting, vm_start=3D%p, l=
en=3D%d\n",
> -                                     (void *) vma->vm_start, (int) req_s=
z));
> -       if (vma->vm_pgoff)
> +                                     (void *) desc->start, (int) req_sz)=
);
> +
> +       if (desc->pgoff)
>                 return -EINVAL; /* want no offset */
> -       rsv_schp =3D &sfp->reserve;
> -       mutex_lock(&sfp->f_mutex);
> -       if (req_sz > rsv_schp->bufflen) {
> -               ret =3D -ENOMEM;  /* cannot map more than reserved buffer=
 */
> -               goto out;
> -       }
>
> -       sa =3D vma->vm_start;
> -       length =3D 1 << (PAGE_SHIFT + rsv_schp->page_order);
> -       for (k =3D 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
> -               len =3D vma->vm_end - sa;
> -               len =3D (len < length) ? len : length;
> -               sa +=3D len;
> -       }
> +       vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
> +       desc->private_data =3D sfp;
>
> -       sfp->mmap_called =3D 1;
> -       vm_flags_set(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
> -       vma->vm_private_data =3D sfp;
> -       vma->vm_ops =3D &sg_mmap_vm_ops;
> -out:
> -       mutex_unlock(&sfp->f_mutex);
> -       return ret;
> +       mmap_action_map_discontig_kernel_pages(desc, (void *)req_sz,
> +                                              &sg_discontig_ops);
> +       return 0;
>  }
>
>  static void
> @@ -1415,7 +1402,7 @@ static const struct file_operations sg_fops =3D {
>         .unlocked_ioctl =3D sg_ioctl,
>         .compat_ioctl =3D compat_ptr_ioctl,
>         .open =3D sg_open,
> -       .mmap =3D sg_mmap,
> +       .mmap_prepare =3D sg_mmap_prepare,
>         .release =3D sg_release,
>         .fasync =3D sg_fasync,
>  };
>
> --
> 2.55.0
>

