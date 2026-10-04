Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97C55CA5FF5
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4DD6B0092; Sun,  4 Oct 2026 13:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7654E6B0093; Sun,  4 Oct 2026 13:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E0926B0095; Sun,  4 Oct 2026 13:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3398E6B0092
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:11:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3D2CA0B82
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:11:33 +0000 (UTC)
X-FDA: 85285585266.14.4A8D67E
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id B961D140004
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:11:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EGxTfKFx;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791133891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmSj2pbz19jJ0+zzNzWqBxyg3RuudMi16XrC71b61r4=;
	b=SgfTv1ZcODX7iRaTGhDEQqE+BExou5N88LlTq5nRx0DZFQwuaNGTG9nFpdhR3NQgxrr7mf
	R41/eaPR7wKsu1Su0Xn+HBMa5nvNWA3o8vxVRJjNbx58UVx+VF3WMRcWc2AulfbLigRpSZ
	xb+VOPC4AnnhNV2lVfhaSZ+bKQInjlk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EGxTfKFx;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791133891;
	b=XHEpkzSjQi/NjH7kAkL44OibvGtM5TlVOeh5Ta1ZrrkuYZDPBWbYWV7FXwru6DPmDwBaWN
	3jnffNMhjwLZ0C/VimfwwfbNn9uSipUoKuS0dMf6j+juCxWvoE1kRJL0L/efYf8w7dg1XE
	NHPOWwUXwilyA2DeIE5RsBqzlgMZsS4=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5337fa12431so179711cf.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:11:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791133891; cv=none;
        d=google.com; s=arc-20260327;
        b=JxOvpJTcWRwk5jYL0jfiZeYv7ReA2zL5GX8SLrgTDa+cvXroHvoiPpyRQy/YYxM1Az
         S+5NwsKKDWuAe0zqHm5wPbXm9Konl8ppgqJWtqZ5iBESf8v3FUNwewh1B72CfgR32tgZ
         4tT8rJeqhwTZ4uQ6KoicCJZkyUBUpQqjFnuYXGzwJY+ydnlDhmGx5I+eJYpMq1/tsWUo
         GWuTpF1Tzr8j0C4D4g0upjk7zKoJ39McfY3ZiriBe587TFMOggpErP2E4GBGR60i/VGu
         +10g3R5QWYUPc36TpVjvft/5miDW+/waNmHMDT5MrPw546dcef4s8KYm2kTZEuCWWoWP
         QweA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bmSj2pbz19jJ0+zzNzWqBxyg3RuudMi16XrC71b61r4=;
        fh=EwuBI3lgHFzxfPDPhToIMS9wTXA3XTP2W9EaYp3gbN0=;
        b=CSRo6a5E3w99b6CyKkkQ9HZctaDdN0H6PpadNcIKghSCCxKQZQFpsEyy6nBq7sWygR
         TxR5ysV0EEFuB7wA6Y3ye5/zEmOtDa5bJePazoqNzpvPRowiwKJ5ZDtJMqwnprLV5Xhh
         aVbaJVsOw0Ttm2jm0Y9je2L7EQCK8t1UVCHB1EQo8NuRTGep7fWxyLM84acEgnaGXIhX
         t21SUtRtB1cUDCNabExuT3nvrjKs0GcGOcQYhslRmgKTi++cb0t+6eHxe/AgHJZPC3TL
         uC0XHM5HKJJBtkMMjDj+C1EJjPSgubTltZtcMoXyHnPzS9Y6KVhGC2GEz0J0cx4lD1cN
         5jVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791133891; x=1791738691; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bmSj2pbz19jJ0+zzNzWqBxyg3RuudMi16XrC71b61r4=;
        b=EGxTfKFxpwnpEj9F/eeQU2Uizmz0bfB4+K8vAbOk8zbQvFtRepMU4UfhpU/oaj3FKl
         tRWV0X9fggMl4ZrOJwggP3wFX/VRQsDzewtYXwdhx/5sczlt14dORc7KQgPaCD00GgJb
         dFlpjc71QyyMP2MAWs0d2TrEVZe6LpsyQ5o8s7GSyJmliv94snjx7HvjuBFsivzvUsrV
         M8+z4KANnflkJG+8qJ8XHIAcnq6xnnGtJXgMlMOORMgAqaAHWRTGMJ2bwSqqxpV5Ibae
         gcyT3LDQ0FuDoM7y2c1xNF1PteSJebQI31wbOHDUGTTX87fdYcWeVgCQYp2a9nIvkRv6
         r0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791133891; x=1791738691;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bmSj2pbz19jJ0+zzNzWqBxyg3RuudMi16XrC71b61r4=;
        b=lmwFDWo9qum/iuWHWSnHteQhDvolINt7GkuzLx7ikuOy5RMV1UyCV6HgrL288kDfAK
         Bm5XcPcmHpGDqR48HHLqqfmyeHOoEDm8d4IAC29yHrambDR4EAu6fbUUw6GVX/qUQVBa
         WOqmFlGjilxamWfohAfHUPpQPLF1i3bRiAy33s4q9RQeVg6yUw/0XxzjjCPZ2zmrdKs2
         Kl/5ttKIbswXwPjle0NqZfwaLorJ3ApN66zZ2wa+y4Q+3AamXzMwgkgNYGKRkqIF8Hpx
         FUmaTWbL3ujyd9xQxAgOLuUYcwP9grhD2q99eTqjeh+N/F37XBP0kkkXE1V/XLl0tc+G
         n1+A==
X-Forwarded-Encrypted: i=1; AKwUvBzoYQUUYCFV+MoXGejPtB4Z4ZWNUPONMIhUULGdl4Cv6keaVTZ5LZ7ihqi2Yxa4sP1P1bENDnbknQ==@kvack.org
X-Gm-Message-State: AFuF++k+zkSudKauqlVaknwKEf61cz0scwxWsKsOeXqu6tg7qa7CLNb2
	UidjBt4Hcg3RGPrOuvSez3C3FuKkGCw4c+Mj8jVvQaAEO3dbc3eqeFs9Z3p6jkSk8AuJ+wUwwMM
	hCLyTNPWcLkUj1ajkeDUgISEjcSeYgtKB7jFwLlC3
X-Gm-Gg: AYBFou0ex0pDpgIb0kZXA+7MFliOSa1VrBGeLo+x7+rPQOBdkrAl/hFFJvzaaWpBWYW
	ksrDEZBq9yBjRStRVD6nh4Bffalo3+WyfyU1f0se12mP5jUAJws5B9J6ILcbZ/pNVFyYA0Twkg0
	1NIQM9BoTL9KUafveUP+HgtvLV3m/g1QcdhQXhbj2RCjHn0d8bEjyhqoR8r9bVDJn4ZTKu+I8qe
	BuNrjffM7Wcrpy58+rljoeSWRQmwwkWi6enTjii7pl8pa++BubUMHUmjFKWijzJN4gG27BNy5Qb
	z8qU+ISJQQn3wSF+ibHX+ftgnpSTAmYW9d5Hjj4mBjjVyOCRY4ufTpzJ
X-Received: by 2002:ac8:574c:0:b0:531:475:4ce6 with SMTP id
 d75a77b69052e-535131b2b85mr16300781cf.9.1791133889758; Sun, 04 Oct 2026
 10:11:29 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-7-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-7-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 10:11:18 -0700
X-Gm-Features: AclHuK9_GrY2ggXkofswaxZKaaBMuFyw-E-IUlNaS-y9tUhYDwF4p-ziZRKm4Dc
Message-ID: <CAJuCfpGj2Q092+zB=Z-d1iAOD6n1_HXVZQAL+YM6x_CeUEMpcw@mail.gmail.com>
Subject: Re: [PATCH v4 07/38] mm: add mmap action for discontiguous kernel
 page mapping
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
X-Rspamd-Queue-Id: B961D140004
X-Rspam-User: 
X-Stat-Signature: sie4k8tr4ahayppwkegzaaxfy7b9tuax
X-HE-Tag: 1791133891-432133
X-HE-Meta: U2FsdGVkX1+lYyOFkS3uM3ru73IJp8RoLXl9MTVWydVAb0fLHASX7TdjyZ2J/Vdvh3RzcgtSA9uwaMRJmYb750EIyW9DQJwikfX+4t8DJf9mBUlKvTeZ7b+FagDDe3O20Remf9ECDrfV2IR3p1OyI77xg5zvW3dSA0lNqnnZcnKsyaCjcW5KTj7uiINsNsZ5MjFc+bRReRLRq1bFvzLiqNH4KTvNd/3PFKCCna4u+G5XOuqvsjWc/PESDah8iExsZa1tZvsKfDyg3/AMPi9WI8dsOagIfgOCcGN20gvsxPsyIpY3U+eqiDShb44FylJ37stK7RWYZwGL2h4CkppvpK/nGV4FaIs1y83KJXTZcl2rcR4lAiS4l4SLZiqf4BmcOrsoXK8OpkxwGuwZDJPU3V2Ad15cHbHjBJF1xouyTXn4Uzh4XtSQPWjkRxx1lKkGMVPvohc2TK6QU7W1Kmmx/m2zNHkwzY7uMVfr2viRRJgxKkbcv6IaZwNDuAt1qWLwPdE6M2CMF748CIQ0S+wPdl4GAo7CC3Z8maWimBF9iSeL2+3cbMMfyJro46/p4OX7tk4nPxheSopuHCmXcObc25UHwzA7SewoFLJLOaAtFLPYlnD/4RWblm28wZVoUGwFkLWerrY1UnWeO8n2hfb4Ul+0A8QkL7gc14v4wp/8vXyVUhlV1E822IERzq1b7Gk2zpyotXenzVcTnNdQ315fUjvhSJrou7CaD0hu9aFJC1cZn7uX9/GXVvL3M6zsdy2rT67Avny2A1KqUXpQOAklMNg+CVn7jIb+CBAWLpsbaKN3KqwN7KpM8dWjwMwFQSAbhaOuqIk084YVM2hQItkQuz/2RGpFu4DSnY3PbN/O5j27+/PFo55+H4URXhADY2uj96SRDLWKxN5NNbmtr8Cy6GLDIZXUUOmIyF9LxaIEm4qYWlARDWJwbb2tdGlUUnTPNwMyiI1AMBNW6WrQ9K4
 ics1/4jp
 rln6ayKPLrdf8UvUsw+6EiwN31Y6ukM9cCC0T7zKCYEC+IxkVtc1hUE12H9Mt5/q9ctTSk/jZ9npMAP5MSfF+uOuEK0PxJYVtUthz4ijW8vQVCuovZD01vBU/bO5bptN9S78mNHCiTN6sXaQdhOgzTKfkdVhzxIE2q0NtUDxBIHRsClpRq2sxJySHKBTfvo7AuAhFWkA/35aOHdZRq7vEYDU1h22yTF8TDevmAtdQ414SBxwICZyCoiOrC4gv4x3L4WdNcg58O2N0fcgLziUW1KjV+UKHq7GXGayymlrZIn4OqpaV6Lk4KdaE/nr3+QksSwc92gqvya78oCviNKMGufHDPBaRhqVH6XVZvlkDBzkXjyagX4gShetg+DnLdX7pF52qtPsTzbJaZ4eu6RCj3j9CJQi7ehTvxBQE2W8XYuzzKRpSNjLDrIqrB/2lLicKCBP5ZT0dXJu7z/LM25PpQTSSuv7efjN7C8xRYyL8KKq8IcdsnnaYYnyHxnO0XeyBiVhYMc7wc5NDPPYvGOnud2PfJJZDlcFSJZYbh87XsTiX1+2ZVLUtMBl5xOxb0/MC46s55ALyq9u4vEfTw3pyc8rxkqLq6lYxPqiol15261Vd5C8txttR3h8gQowDj2bP9dl3KlkwbNZ+4TOWwRDf7BuFNr/IYQDAGIY/3kJssZC/fTddJ8iP7hgyM/kJNU43LGh+RB37j4En1O5Qegs9uFRY2hiAVGqeL4Er0glN5pzpiAMNiKbf4qbbKuiUai2GbBrg+hiVxah4Ed1l/V8HIACx0eWZJOMn2o1G5UKUGfsCxA9KnEUAcfnAC7bsa7SQ/vcDVoF6Y8gP5smsVc+lxcPU2TRdD5xrJ9qxTCZQWEjZpvfAsDfpO0EUGvO3P8sDbr4B6VR/ew6k7BgXHFJdmFcpUoZiBBRumW7IbfPgpHwNvAWc0bSMVAI58u+kJIQrcn3KW9LofclMpylBht+9TF45hi66
 62zU8sN6
 6tdddkvctepYNfTxoMk4jDp0eOzHtLV9YQPWdepUQMenlmCg6paBpnrQC+UAspEWwIDPbBfl6v54rLt1XYWl2Pl/Hk/nG9wF6fJgfpHt0whVviNnYitoPclSXvBjlDYnGpE9wHsO8kQU/qGTqB3QH25/gml45h67dOBR7GSeHqDyqiWb1ubv6GdeFD0nUbbJBDQKevTYh5/emfUCUydPTfe2EMLjvgXMwbXRPN0aycBNEmP1ULWXRv5y7QJiIHIIiDfuqWNgUiRbjiGjBvG7aKQFi0mcHxjUK2z58ZHaIuh/xk8UYIefDNFCpZ5QyK1LmU/g0nEXj9ummp/vlvQMJL3ONLC/OU+hknfECfn7nL9l6RGBOJPJ8NiNJEVOzAIiW1nUv8LNVJdTzjwPPyMaP0Qy5wtCovWx349voAG42rPguFCKOaoCeMC8UAFgRBZ71N/FbcUI2ahQS+Qoe8mnjvW72xIS8PB6XCCOOzuslsvlcX/HnVGNwRcHiFfqACL52ZKTPRwTPSJw4ObcKky9DlD2bxFII+pz6xXEfNGGK1NlpVKXmN29plqAnze9V+tLS9gmo/wO+Z1Q/ao1r/rOClphiTRF4UJJaThPdIFJNxb34WSChM5LK4e65pGCcEqLpg0Z7qmhlVc71bm/RH+E0BQrlAZbIOkXsklyZ4bulKDfjkWa51/s8WtVhWNvDqkwMgoXpgH5vOK6e7ET8tA4d2wC5LALO2IMBIwNu054an0aBnefG8vJmBjHhLyc+0FpGJ2ab5K/tS9vpFVey3Y8TIxV9YGJtu+jH3ydJipwr1wx/fvCVQsJ2H9wIpBxC/UcJiwNZ4xWqCAzf7yjVKiSgLg4mAUQTAzNmUO1t82XohA5DjjYumWV8SfIVCSOIq9cRI0VS7tI4mD9pF+IULACZEsWmnmCUmJAtJOk2hYtCN2eY1FFIjSPOrnyUPdIMYN9L0GW6ZqniUmfsJgLCw60Mt5vP0C3I
 6yvwi+vV
 zdUObnZyO75nOg5YoYrurlrOMU4HE0caAdL1Pdq96nlpe1kOb5OcqAiArFlF90y9RXEeI1d5dbhn6Di4feQwz5TOip6ewuBKK5db0zPVTvvoMgCB5RnuWdhLtAvSgUZu6S3Ws0DhCyegqWig1N0ZApSyRDdnehjVjPHdxFwKluTaSeFeY1POcoudNoDBICm2jAVDyNftVixyaYBzocDcqOHDcFfs1SZ5PmWYxMNWDRsdgabFsrjSjff2agzC3es2PCYCz+XOubYv86lS48IDKkDfZ+xAS9P/2aImUaTNm4Th93Jh9kDbAHOq7MTR95rTUqHJNj7h8Go1PA+mawRM1j3z0fP0K4r7V//Ki2HtlrAGvKr1ql6HkC+tHbX2e3xjfAHtUARyglkWRP+h+jSsqrVrhVwvGp3kCL1V7s2VMxVSAlgGHLvpM3AV9MbtDMpKTRvytppyDwoeXIEUBOUmxVpKEyoaa8f/rh5WJYqfJpMR6uCeasWjZopU3DThUIwEX1o3ZE+EUaqyzpXhpOS0G4A9QXAf3lRlVFtMrc+WPO5pbbMeJI4sH7/CpLH2dvfR0ggXz1dw/5rTaiQN23oy2wESlWc8qMyY/7hzHi9WXU9C0Weg4gFMulQTr8yjuAjENbcFULFBOjnWS/yp2hleah+Kz3TYVG+Wrj08ojUWsk02R6XPvjQ/FnziDolKN6rdu1mq9mZXu1Xy72s+KgxrlY4PdtNi8xQD1sWgO8glS2IW17iUK65DiU7UP6Un8zBxgjuMkAzTaSSeFGO376Kh8xR+dXd+4wvrMUT9rALU3luiXlkrTUb3ejuWT+E0tEZ3w21wP1Ldi5jsdvGjS8hKMrwt/TgUyv2Szx7NwNF7LWHamL0hVDvyUGSG8wCJSEBTnPkfhdWIYIqA/8x3+6xndCYzekV3Pf0CXSQD2qX4+MdXcO5cjkm1Lc5CXTy2n5C7ol8H2mBQjSe3pyhvvxR1CiC/UEgqd
 UzLg0Qo3
 Bq9IX2KaXrZSJyKN22CkITxBqThP0KEPaicWanfUjuNx/fYcdA8jqpr8dWJxlICgNzZgRFsAy0UB0QHB31qj05zbhe9y8hNg2tFjn4AxXa65PABJp1MkcrrMMYxF4avg2f+msu3AW04exI/6vHzzr8fSWpz3naUTzfz5cUtY8ob1xWWPsJwR7iM94068mVILf6R5xknK3U0pJ1HdvbwZkZuy3+HhkJQeRhsd88C8+WBhNram+bWqzfH3gay24uBy/Sd+ENnNM8gIAXsXzAhbvQTnF5ZroClPD7SHZoiIsioJtSwW4h7uUO6F5FGQrDZLCMF4gHLK1xWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 6:35=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> The existing kernel page mapping mmap actions allow for partial and full
> mapping of an array of struct page pointers.
>
> However some drivers require the mapping of discontiguous ranges. Permit
> this by providing discontig_kernel_page_ops which allows a driver to
> specify how the operation should begin and how batches of pages should be
> retrieved.
>
> It uses the minimum exposed interface to do so, providing address, page
> offset and both vm_private_data state and a local private state object.
>
> ops->init can establish state for the operation, and ops->get outputs the
> pages to map and their count. Should an error arise the core unmaps the
> VMA, invoking vm_ops->close, which is therefore where any state establish=
ed
> by ops->init is released.
>
> Also update the compatibility layer to do this too via
> compat_mmap_action_abort().
>
> Batches may not exceed the VMA, but may map less than its full range in
> case the driver wishes to allow the user to map an area larger than the
> available data.
>
> To use it, users invoke mmap_action_map_discontig_kernel_pages() with
> initial local private state and a set of operations.
>
> Users can then use one of the provided helper functions to perform an
> action:
>
> * discontig_kernel_map_abort() - Abort and leave the mapping as it has
>   been accumulated so far.
> * discontig_kernel_map_page() - Map a single page, or a compound page giv=
en
>   its head page.
> * discontig_kernel_map_page_range() - Maps a struct page ** array of a
>   specified count, mapping only those pages which fit in the VMA.
>
> The userland VMA tests are updated accordingly.
>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              |  45 +++++++++++++++++
>  include/linux/mm_types.h        |  44 +++++++++++++++-
>  mm/internal.h                   |   3 ++
>  mm/memory.c                     | 108 ++++++++++++++++++++++++++++++++++=
++++--
>  mm/util.c                       |  27 ++++++++--
>  tools/testing/vma/include/dup.h |  11 +++-
>  6 files changed, 224 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a1f2d375cf7d..97e1eb4fe3a4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4647,10 +4647,55 @@ static inline void mmap_action_map_kernel_pages_f=
ull(struct vm_area_desc *desc,
>                                      vma_desc_pages(desc));
>  }
>
> +static inline
> +void mmap_action_map_discontig_kernel_pages(struct vm_area_desc *desc,
> +               void *init_private, const struct discontig_kernel_page_op=
s *ops)
> +{
> +       struct mmap_action *action =3D &desc->action;
> +
> +       action->type =3D MMAP_DISCONTIG_KERNEL_PAGES;
> +       action->map_kernel_discontig.init_private =3D init_private;
> +       action->map_kernel_discontig.ops =3D ops;
> +}
> +
>  int mmap_action_prepare(struct vm_area_desc *desc);
>  int mmap_action_complete(struct vm_area_struct *vma,
>                          struct mmap_action *action, bool is_compat);
>
> +static inline void
> +discontig_kernel_map_abort(struct discontig_kernel_page_state *state)
> +{
> +       state->action =3D DISCONTIG_KERNEL_PAGE_ABORT;
> +}
> +
> +static inline void
> +discontig_kernel_map_page(struct discontig_kernel_page_state *state,
> +                         struct page *page)
> +{
> +       struct folio *folio =3D page_folio(page);
> +
> +       if (folio_test_large(folio)) {
> +               VM_WARN_ON_ONCE(page !=3D folio_page(folio, 0));
> +               state->action =3D DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE=
;
> +               state->__folio =3D folio;
> +               state->__nr_pages =3D min(state->nr_pages_remain,
> +                                       folio_nr_pages(folio));
> +       } else {
> +               state->action =3D DISCONTIG_KERNEL_PAGE_MAP_PAGE;
> +               state->__page =3D page;
> +               state->__nr_pages =3D 1;
> +       }
> +}
> +
> +static inline void
> +discontig_kernel_map_page_range(struct discontig_kernel_page_state *stat=
e,
> +                               struct page **page_arr, unsigned long nr_=
pages)
> +{
> +       state->action =3D DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE;
> +       state->__page_arr =3D page_arr;
> +       state->__nr_pages =3D min(nr_pages, state->nr_pages_remain);
> +}
> +
>  /* Look up the first VMA which exactly match the interval vm_start ... v=
m_end */
>  static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm=
,
>                                 unsigned long vm_start, unsigned long vm_=
end)
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 9ca2ea3664bc..0cb4f9603956 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -818,8 +818,44 @@ enum mmap_action_type {
>         MMAP_NOTHING,
>         MMAP_REMAP_PFN,
>         MMAP_IO_REMAP_PFN,
> -       MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> -       MMAP_KERNEL_PAGES,      /* Map kernel page range from array. */
> +       MMAP_SIMPLE_IO_REMAP,           /* I/O remap with guardrails. */
> +       MMAP_KERNEL_PAGES,              /* Map kernel page range from arr=
ay. */
> +       MMAP_DISCONTIG_KERNEL_PAGES,    /* Map kernel discontig page rang=
e. */
> +};
> +
> +enum discontig_kernel_page_action {
> +       DISCONTIG_KERNEL_PAGE_ABORT,
> +       DISCONTIG_KERNEL_PAGE_MAP_PAGE,
> +       DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE,
> +       DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE,
> +};
> +
> +struct discontig_kernel_page_state {
> +       /* Map state. */
> +       const unsigned long start;      /* Start address of VMA. */
> +       const unsigned long end;        /* End address of VMA. */
> +       unsigned long addr;             /* The current address to be mapp=
ed. */
> +       pgoff_t pgoff;                  /* The current pgoff to be mapped=
. */
> +       unsigned long nr_pages_mapped;  /* The number of pages mapped. */
> +       unsigned long nr_pages_remain;  /* The number of pages remaining.=
 */
> +
> +       /* User-defined state. */
> +       void *vm_private_data;          /* VMA private data. */
> +       void *private;                  /* Mapping private data. */
> +
> +       /* Users should not touch these, use discontig_kernel_map_*() hel=
pers. */
> +       enum discontig_kernel_page_action action;
> +       union {
> +               struct page *__page;
> +               struct folio *__folio;
> +               struct page **__page_arr;
> +       };
> +       unsigned long __nr_pages;
> +};
> +
> +struct discontig_kernel_page_ops {
> +       int (*init)(void *vm_private_data, void **private);
> +       int (*get)(struct discontig_kernel_page_state *state);
>  };
>
>  /*
> @@ -844,6 +880,10 @@ struct mmap_action {
>                         unsigned long nr_pages;
>                         pgoff_t pgoff;
>                 } map_kernel;
> +               struct {
> +                       void *init_private;
> +                       const struct discontig_kernel_page_ops *ops;
> +               } map_kernel_discontig;
>         };
>         enum mmap_action_type type;
>
> diff --git a/mm/internal.h b/mm/internal.h
> index fc4e249e2343..557e629db8c5 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1515,6 +1515,9 @@ int simple_ioremap_prepare(struct vm_area_desc *des=
c);
>  int map_kernel_pages_prepare(struct vm_area_desc *desc);
>  int map_kernel_pages_complete(struct vm_area_struct *vma,
>                               struct mmap_action *action);
> +int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc);
> +int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
> +                                       struct mmap_action *action);
>
>  static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
>  {
> diff --git a/mm/memory.c b/mm/memory.c
> index 448342883e9d..45b21bb04a18 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2609,17 +2609,23 @@ int vm_insert_pages(struct vm_area_struct *vma, u=
nsigned long addr,
>  }
>  EXPORT_SYMBOL(vm_insert_pages);
>
> +static void __map_kernel_pages_prepare(struct vm_area_desc *desc)
> +{
> +       if (vma_desc_test(desc, VMA_MIXEDMAP_BIT))
> +               return;
> +
> +       VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));

Sorry I missed this before and it is pre-existing code but is this a
weird way of asserting that mmap_lock is write-locked? If so, why not
just use mmap_assert_write_locked()?



> +       VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> +       vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> +}
> +
>  int map_kernel_pages_prepare(struct vm_area_desc *desc)
>  {
>         const struct mmap_action *action =3D &desc->action;
>         const unsigned long addr =3D action->map_kernel.start;
>         unsigned long nr_pages, end;
>
> -       if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
> -               VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
> -               VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> -               vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> -       }
> +       __map_kernel_pages_prepare(desc);
>
>         nr_pages =3D action->map_kernel.nr_pages;
>         end =3D addr + PAGE_SIZE * nr_pages;
> @@ -2640,6 +2646,98 @@ int map_kernel_pages_complete(struct vm_area_struc=
t *vma,
>                             &nr_pages, vma->vm_page_prot);
>  }
>
> +int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc)
> +{
> +       const struct mmap_action *action =3D &desc->action;
> +       const struct discontig_kernel_page_ops *ops =3D
> +               action->map_kernel_discontig.ops;
> +
> +       /* At minimum need to be able to get pages. */
> +       if (WARN_ON_ONCE(!ops || !ops->get))
> +               return -EINVAL;
> +
> +       __map_kernel_pages_prepare(desc);
> +       return 0;
> +}
> +
> +static int apply_discontig_action(struct vm_area_struct *vma,
> +                                 struct discontig_kernel_page_state *sta=
te)
> +{
> +       unsigned long nr_pages =3D state->__nr_pages;
> +       unsigned long addr =3D state->addr;
> +       unsigned long i;
> +
> +       if (state->action =3D=3D DISCONTIG_KERNEL_PAGE_MAP_PAGE)
> +               return insert_page(vma, addr, state->__page,
> +                                  vma->vm_page_prot, /*mkwrite=3D*/false=
);
> +       if (state->action =3D=3D DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE)
> +               return insert_pages(vma, addr, state->__page_arr,
> +                                   &nr_pages, vma->vm_page_prot);
> +
> +       /* Compound folio - have to iterate through each page. */
> +       for (i =3D 0; i < nr_pages; i++, addr +=3D PAGE_SIZE) {
> +               struct page *page =3D folio_page(state->__folio, i);
> +               int err;
> +
> +               err =3D insert_page(vma, addr, page, vma->vm_page_prot,
> +                                 /*mkwrite=3D*/false);
> +               if (err)
> +                       return err;
> +       }
> +       return 0;
> +}
> +
> +int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
> +                                       struct mmap_action *action)
> +{
> +       const struct discontig_kernel_page_ops *ops =3D
> +               action->map_kernel_discontig.ops;
> +       struct discontig_kernel_page_state state =3D {
> +               .start =3D vma->vm_start,
> +               .end =3D vma->vm_end,
> +               .addr =3D vma->vm_start,
> +               .pgoff =3D vma->vm_pgoff,
> +               .nr_pages_mapped =3D 0,
> +               .nr_pages_remain =3D vma_pages(vma),
> +               .vm_private_data =3D vma->vm_private_data,
> +               .private =3D action->map_kernel_discontig.init_private,
> +       };
> +       int err =3D 0;
> +
> +       if (ops->init)
> +               err =3D ops->init(vma->vm_private_data, &state.private);
> +       if (err)
> +               return err;
> +
> +       do {
> +               unsigned long end, pgoff_end;
> +               unsigned long nr_pages;
> +
> +               /* Default to abort. */
> +               state.action =3D DISCONTIG_KERNEL_PAGE_ABORT;
> +               err =3D ops->get(&state);
> +               if (err || state.action =3D=3D DISCONTIG_KERNEL_PAGE_ABOR=
T)
> +                       return err;
> +               nr_pages =3D state.__nr_pages;
> +
> +               if (!nr_pages || nr_pages > state.nr_pages_remain)
> +                       return -EINVAL;
> +               end =3D state.addr + PAGE_SIZE * nr_pages;
> +               pgoff_end =3D state.pgoff + nr_pages;
> +
> +               err =3D apply_discontig_action(vma, &state);
> +               if (err)
> +                       return err;
> +
> +               state.addr =3D end;
> +               state.pgoff =3D pgoff_end;
> +               state.nr_pages_mapped +=3D nr_pages;
> +               state.nr_pages_remain -=3D nr_pages;
> +       } while (state.addr < vma->vm_end);
> +
> +       return 0;
> +}
> +
>  /**
>   * vm_insert_page - insert single page into user vma
>   * @vma: user vma to map to
> diff --git a/mm/util.c b/mm/util.c
> index 1660910e2a22..5b2e1ab4aeba 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1401,6 +1401,15 @@ static int call_vma_mapped(struct vm_area_struct *=
vma)
>         return 0;
>  }
>
> +/* An mmap action failed under the compatibility layer - unmap and close=
. */
> +static void compat_mmap_action_abort(struct vm_area_struct *vma)
> +{
> +#ifdef CONFIG_MMU
> +       zap_vma_range(vma, vma->vm_start, vma_pages(vma) << PAGE_SHIFT);
> +#endif
> +       vma_close(vma);
> +}
> +
>  static int mmap_action_finish(struct vm_area_struct *vma,
>                               struct mmap_action *action, int err,
>                               bool is_compat)
> @@ -1412,12 +1421,13 @@ static int mmap_action_finish(struct vm_area_stru=
ct *vma,
>
>         /* do_munmap() might take rmap lock, so release if held. */
>         maybe_rmap_unlock_action(vma, action);
> -       /*
> -        * If this is invoked from the compatibility layer, post-mmap() h=
ook
> -        * logic will handle cleanup for us.
> -        */
> -       if (!err || is_compat)
> +       if (!err)
> +               return 0;
> +
> +       if (is_compat) {
> +               compat_mmap_action_abort(vma);
>                 return err;
> +       }
>
>         /*
>          * If an error occurs, unmap the VMA altogether and return an err=
or. We
> @@ -1469,6 +1479,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>                 return simple_ioremap_prepare(desc);
>         case MMAP_KERNEL_PAGES:
>                 return map_kernel_pages_prepare(desc);
> +       case MMAP_DISCONTIG_KERNEL_PAGES:
> +               return map_discontig_kernel_pages_prepare(desc);
>         }
>
>         WARN_ON_ONCE(1);
> @@ -1501,6 +1513,9 @@ int mmap_action_complete(struct vm_area_struct *vma=
,
>         case MMAP_KERNEL_PAGES:
>                 err =3D map_kernel_pages_complete(vma, action);
>                 break;
> +       case MMAP_DISCONTIG_KERNEL_PAGES:
> +               err =3D map_discontig_kernel_pages_complete(vma, action);
> +               break;
>         case MMAP_IO_REMAP_PFN:
>         case MMAP_SIMPLE_IO_REMAP:
>                 /* Should have been delegated. */
> @@ -1522,6 +1537,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>         case MMAP_IO_REMAP_PFN:
>         case MMAP_SIMPLE_IO_REMAP:
>         case MMAP_KERNEL_PAGES:
> +       case MMAP_DISCONTIG_KERNEL_PAGES:
>                 WARN_ON_ONCE(1); /* nommu cannot handle these. */
>                 break;
>         }
> @@ -1543,6 +1559,7 @@ int mmap_action_complete(struct vm_area_struct *vma=
,
>         case MMAP_IO_REMAP_PFN:
>         case MMAP_SIMPLE_IO_REMAP:
>         case MMAP_KERNEL_PAGES:
> +       case MMAP_DISCONTIG_KERNEL_PAGES:
>                 WARN_ON_ONCE(1); /* nommu cannot handle this. */
>
>                 err =3D -EINVAL;
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 023ad6092e9c..a6a8e53c4b38 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -457,14 +457,17 @@ enum mmap_action_type {
>         MMAP_NOTHING,
>         MMAP_REMAP_PFN,
>         MMAP_IO_REMAP_PFN,
> -       MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> -       MMAP_KERNEL_PAGES,      /* Map kernel page range from array. */
> +       MMAP_SIMPLE_IO_REMAP,           /* I/O remap with guardrails. */
> +       MMAP_KERNEL_PAGES,              /* Map kernel page range from arr=
ay. */
> +       MMAP_DISCONTIG_KERNEL_PAGES,    /* Map kernel discontig page rang=
e. */
>  };
>
>  /*
>   * Describes an action an mmap_prepare hook can instruct to be taken to =
complete
>   * the mapping of a VMA. Specified in vm_area_desc.
>   */
> +struct discontig_kernel_page_ops;
> +
>  struct mmap_action {
>         union {
>                 struct {
> @@ -483,6 +486,10 @@ struct mmap_action {
>                         unsigned long nr_pages;
>                         pgoff_t pgoff;
>                 } map_kernel;
> +               struct {
> +                       void *init_private;
> +                       const struct discontig_kernel_page_ops *ops;
> +               } map_kernel_discontig;
>         };
>         enum mmap_action_type type;
>
>
> --
> 2.55.0
>

