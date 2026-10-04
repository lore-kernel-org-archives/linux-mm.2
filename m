Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA98CA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1173B6B0095; Sun,  4 Oct 2026 13:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EF8D6B009D; Sun,  4 Oct 2026 13:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF95F6B009E; Sun,  4 Oct 2026 13:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C117C6B0095
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:24:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DE711C3F82
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:24:37 +0000 (UTC)
X-FDA: 85285618194.03.40D2B8A
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 60297100002
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:24:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ji9SjoCg;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791134675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+M84/MVcGEHYdv8UiC0womKlZljWSjBnuX6fRyYL/I=;
	b=zZanCFz3Dsdub/LNBse603x3RqfT6SGPcKUSz23ImIbE9hMVz7cZ/Zic/ux08lkOUjy9h/
	PmjukzyvWmmT9gSrwtdoBYjg7v0bV5tYmKu8LPQoRb/ILYi82lcUVfIduEF9tWZj4/cnMW
	dXVVBTn9vEDKkfFesouY+l6l25l/FqA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791134675;
	b=xQPWBnh30rUBTA+2GQ6Zn7lYc5G85QmPq0+dYmt/dUrZkhfW0hzX7RYISLrNluzqCtfuzt
	lNQQSHukE4JrnQPM6kMQqlueoigSamqgIiolJ9CQ0lmerHBgFXZEv51yEj5tgbhDjhQevx
	SYcInoLgV8pvRjdUMbhO4azd+zvaiTU=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ji9SjoCg;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5337c7b9937so260251cf.0
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:24:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791134674; cv=none;
        d=google.com; s=arc-20260327;
        b=D9A4QX9OmHbl3vt8z3FCPMhNr20r2IdFYNtTdbMbdpIKKETe8/yi4ewMNJ1/thaBxZ
         riv2yAyqobSCarT0L/2gJu1sATwrzNqmldl69N39XvYwGpE4pFBXVweQmfmh0ntGnMpF
         xJGM2Lz6QNmANilWwKjeh7X0uAkkmm0cbaP9pxCqRUy46h8flSmOfbXosebouTHHCw7k
         ZvyOp1mgDjwLf24W9YvIHBt3/WAD2z0U3bcb917t1bL4fWH5H0avBXVPWe0vhEIuybRz
         nJnHFRNVbeQdJk6hwY+3eJMSqQINW+Fp4rVkMXzm6az+aVROj9MFgHd1RU9cA/JVhAyD
         Pf8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c+M84/MVcGEHYdv8UiC0womKlZljWSjBnuX6fRyYL/I=;
        fh=DBiB92NTtVUY2GbE2BY1VEoDxAeKBjpaBbYhN9MLIRA=;
        b=in/mkICuSHJcemA1UrJ5Zgz0ZPcjWf9fo8GolP4VNdCd9p7TnRdbhFx6TyxOXUPyKH
         W0ZQAQOlOcfPuEjdue7C9P703lJAlILukvWxv01ICoz4FQWOmYlqX/uigtrta0DAE3xX
         q6bGT5MZ4RRIWPQf6mTowW+04BbAi5QmKdpvDnU4xgIjytDcJmqIaYrApOZOrgFVCH0u
         nQ8LwjWOm/3NbXsoUNEDjAIjk0KhyJlW9/hj9aCMWKZeJc9gqnw6S0U2cGptXUPn+MPR
         H8eeWgc8lA9wKNlSWmAD6YZ+iJLiGBJnOO3Bn2wsFZRYhwQTzRUTKHvF401KjClCa6J+
         IicQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791134674; x=1791739474; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c+M84/MVcGEHYdv8UiC0womKlZljWSjBnuX6fRyYL/I=;
        b=ji9SjoCgdyfVuQWlotGZMIcvl804rsPXDawwnVboi3kaNmOez95TK6oGD0eRkZ/XM0
         HI1OY5KdJBPxeQx0OxTSjqxV2owjZF2SI2YmWArJNnxUaL+NqNn63G7sKt3fQ8VUfu+z
         buXQCqAk5jZ/CbhOX9sdhGNFja5E6vZjMNw6lmbtOBBzk1cp32BfWIH9ZT29k1dzkTGg
         bcGMbHpAYMg6fde7hrCFdEqRdJV2H07FiHjTyEGZSeO7U4khMA31UjkJZIjcUEco8V67
         K8+OhmeiUuHpKT84t10MI3wZd1Ej3V0eN0jaOAhsHKgaCk5AyJUvvXh0zJMKY28R3qlN
         KYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134674; x=1791739474;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c+M84/MVcGEHYdv8UiC0womKlZljWSjBnuX6fRyYL/I=;
        b=yWZj50gSyOJRL7gmM539fBNiC98hF6MUFhRI1AQHMOD3potaHuqgHKC1PVfcNkGL8s
         5Bv1NYJbSl/HUjwe2ZfHyrSruA/L2O+/5W7QGRVULEr17pFy7JTUIfQgG+SVCUJj/yM9
         I6TmXBoH91Kf/RrB8BOBno5m90JhBRAcQxsC2CesnKfma8d6KSPYQrH1G8QblSw7OoQE
         Zat6P8lyuV4Bm4ZTOeEFqmzzLzgNTT0gsxKOlKT7fe9yAnEp5MnPptLNsOwFXddSOuOK
         P+5IyVXH/I/BKdeCyegNxleQc+4SOtqTBU717dK1cc5H2/d0mjE9ytNuEfWhKYXDu0P2
         4CcA==
X-Forwarded-Encrypted: i=1; AKwUvBzgKtX5e4pytfDF/27B1Yv/j32ZSZ78WCrxHS6FTX1RdaP33bCsbaYj5g8e5uyxOYYhADmrkijaVA==@kvack.org
X-Gm-Message-State: AFuF++lBMZLdF3XGeJ8sdZYveQ7/1I+Fs7qJmQmExYZ87kaa5DdHoPE+
	Tn4WzWtZp7OgOPJO7tS3ev903RdxTZz+nrjC3fAQULuVzOIqfRsrIVYEtYtdOQ5NmOB3Jy3Kt1P
	OA18a7J6K1V/CGasn82Y0fhwy4wFwRigfvQBodOB5
X-Gm-Gg: AYBFou1CgRTm3MhkRaf34FK5qC2p4GjDdZAEaTnO1GTByHI3gI0JqtRLIBokt4Vzsvy
	+/d/ZyyVNRQ72Bzhw3G4xo0vfCYzbAnQip39YipTl6gENEDw2biiTh2R/4D08NqcjfEquQznN7P
	Y1tP5/T0cLEcpODYFUBC6Z7Y1e2qCsTb/7MZR3yEnkMouD6tCXa5I+cHscI1PuiA3AvZ2Ov8SWi
	djctoT+3Ohux55MEO8ww8p2uABr4C+snBKNwKuayHiMhOi/cM/UNHCY32AH+C3ZLEhR3D35xZNQ
	pGVruZ3sLpw/xSXlD/n+HY0PEgftrIPdkN/PQBBU3E0WHNMs0zOPwF13
X-Received: by 2002:a05:622a:606:b0:532:84d3:abb with SMTP id
 d75a77b69052e-535131b5a84mr14345371cf.7.1791134673403; Sun, 04 Oct 2026
 10:24:33 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-13-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-13-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 10:24:22 -0700
X-Gm-Features: AclHuK9jHlOUV2ZRb5fsxUCRxMZ3OpnGbWN3MVyf3rU51TqoB71rd8PxNlF0WhY
Message-ID: <CAJuCfpE7W7uFZfztCHRCouc9z49wPV96usW2QewJNZwprK7bRw@mail.gmail.com>
Subject: Re: [PATCH v4 13/38] bpf: arena: mark arena_map_mmap() mappings VM_MIXEDMAP
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
	fuse-devel@lists.linux.dev, Emil Tsalapatis <emil@etsalapatis.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 60297100002
X-Stat-Signature: k4mdtbhq98gqccdeb6doho5rixex4xsh
X-HE-Tag: 1791134675-935862
X-HE-Meta: U2FsdGVkX19iQpRpd3Gl3h6XGsDvCWNL1zv2tYUAR1zt+S/HBgqdk4zlz9WRvOXocMYxbfm64yJ2GM4JS8jmUUW8talNA+X7gcDaxDR05VPt7zCrXsQuElvWk/rH1BBWTUX0O+x7Ggv563D3Zj0Iql0gmajXr3Sjt9iT4lVjDymwiHNtWRgUKuB2iPKNymq6IzWH2AxXRvhjdHjnxXbW8OpWvXc6RtKsiL299lAGP50Gl4t95tyKXx6KYQ4cy6ZMCDkj3/5e3uyq/fVfmvbhCpxd9oLnxLPcgy+rKFXtSuw8iYm/RP8QTMtkDyAepHiXt4t1rRQQdQskJq0tg02VyY4sK2LOftmnAGXBF0CP5bZ2toBmyXoD/y+4WDIw7YkPBmbk9irYUfyoa055QnRk6S/DeIZZwpNSOk3uTRr+IPaUmtQtH3DGgQnt4gufnhoMdUGbJE1TFbZUxwRhQE1TNlNdJY18WumydgYNlUphLTXfkeaMX+iIBK8QI4+/dQzTiHxKAxrQUyLsyv5+aH37K+r5Wzm/4DlnUsF3RuBp1s6B1yfvlzHTgUChGn5+l01PvqO2nJ0O/t1gmE+5OTLHUL0mdZRcUgRWyOB50xSIymbkwSGCrdBGEIrnj22185OD8MaVUVhR+QO3jBI3dVrvn+VSBzPDi5z0fpBY7cUciyCcK8rwmdDsb/cqGG6BEqVivT8VBfrJ0ctkUW9FgKAR9PE7vOt1vJNlmTVW1RQRiqOH2Z2ihcTcSa31pzBjvfx42KCiLL1iK1VE1UbGxeL8G0Lel/9C8C+KzQxO4pqoSZ0le9R5awziwxz8mqNHY1anqUUQgoLGPUgl0xkAkJuksgIrlRoQJ9gkX0UHeGpR+n1hzeq+EnUBDy+rDJqsHRtvKec+2Aixf5cPjojegumeH3T7/3UyzyJRQ0jbMkSR5tHQuE7cmBjkNErR4FU9pgRS/dLmFA1IBznuu08ZSfc
 L1gRpBHr
 GTXIhU2N0AdWXerzzTv/M23lc3dP8DFH4GqTA+VUuOkFp5f2A0bSRN9ntD4bpAQncZojiDtS3ZZktmsp++19cpeaKC5zSgzt77O2nNrWwjqCeim4Z0HV8KERnyMyxhuMpb/XFL2X/6OBz1tm54v50jVEx9D33gDEeC+fb15V5dTT7D0JgQYV8hhdQXcKpWFwA0LoW/rl0AvNqyxuneZLqjvL5RHx7d6WOMFmZmKxyV43ZkbkX4cKs4h4Ko8ib9IxkNTtJMb8LY6ANii7s93N8b1VD38MFSVBdOo+p+wV0+2qbu0RoFfUFBlReTjFtb+spr6X/lSEhFdssXdldvCJOCHlvqo/2KCEWdRhBkD2bW5RKeL4zKOqnCq2oiZMJf6BtzI28KcPgEN+sqZdiwYLJC8ZWfGS4ierFrAvvgXGX7UhbN473Kr9BJB2XiP2xBrMOK4M1HcFfuT1RDBdXwP+vYYotiMZ3+Z1NJLvL+A/r0XWQGTWo1Nr8hBiNA5fBOSZZh7IWWfU3ckA2Lt4U8+NvB4PZNd/o3FIUQGVXd0F/nTgRmZV0ssU42WDdKGa+jXrRMoPpW5vSUgUGoB/VyvI8jF/zxyW+PYa7w1mlTICuvLt35RenBteB4o3nZpwO7sdbhg6YYjE2GF+EU+wjIn+GfY9RGPifWzrHR6c+/Lv2lEFvvgaomjsc3yc0xQTA7bCuKtKniTLI3A9ShKgYQts5EBSlUuI1vi09ZQUPQDrh/iubd6Iw9hMlHFuj6yANBZRhwIS3cpMMFjSScDPrIeQz3u9yGxTSe+AlmEmzcKYSrI7lwKfRfksqbE7Erf2DXhNI3Zo7fnQ6J65FTVBcj6Ze+1gxoyCdubQo0ptNYUN/kc7Xn3xn3RsSi0QROrBTTCAg/o1ld1EDvjfU6bW1OOOA3x+I9eiURzyZw4h55rqIUkbvs5kvS5UfUIYuPA/dpnZgFX+Oh+usqN8kvIgx9YMSZd59HSOw
 Fk92iCM4
 roN2NbCP3e8V5omHgsK5QwxW5xaI0A8MXfaFmSjNmh5v+93YPJpQClhTlv+UcFOErfyq+JuxOxyVZ/CTf0lBYJYNFLZ5WZaGCzvPrXbzYNyVAc00x6JZ0ZsoElI4TbbpPdOnzTfVK25OmVHsUa/YbNl/s7upL2FAoWiGBbmZHy6DYX6utej/0o4vCWv9yLM7iEfNwRJtsWz7h2mbCfL+b/J3Jgx9WFw28209ZWx27HPPiwBGPl8hA9e1zU5zA1/Z5Fj5BgW10KXycY3aB7FtnovymBxgYdJeIVX8eOQTXwTs3FZOHG/Dj8RGVVF0Ksb/h8S3Fkrlhk/83/+JG1quGZmAF+AoGfuUF7Cmda8ezgmIjkohPzlNjFWAipMrk6MYDkjbdv+FmVjv2/atkUV9lPq1oZXsbAWJ09SLVqLGswKTNrv2eoHssD2y6l6gTmdicjNF1O6EIbFoMTF4TNCas4gtL0HlqGfBKmCGcRJtikUVCn7B6OS8NjCFxfl3RFwyfq2UmJw5TKJNxRNoaU+IOhoHeVUK+fRma1cZ5cmq3XcrX6XlYkfaE2KfnNTmpFjowPC4y2cAlwGNw5pJUm1ErNE8YFZQQPPCk/bBvOPhu+Gnc44/iM4l7gKlKNynbInLJnk+1JO4DR5ntcTMQqKrddDftNAhrXEDO2NTIQ9YoGPsOUSzaFIgdt1Frjbho1sdkQmQxhBGpf0zIzm6f9ZNC577g6Tgksc+Tii3z4E60Wah7j/HSqnZ5b0VoGQkleBPv/MQUvATGQ0nCamyHfqycU9joeU5zUm7uKn3ZRa38EZmIl+MNAiECBpayMPhm/0LLakGBWJYu+6sqk3hP50yRX3/gMGQT1RokVLo5CMqIl3PNuRsmkIxYBJUQidzy0QTqdGH/M8qxMA1EwNahe+Uah4GRBi8vPhLwvVXLRqwWin9p0z3yXzDWtjWMonQ0osIHKXuhQGRBeMnku8R1YBiFTcv0C9fN
 d0tKPF1P
 5k+yzE3PCcSfcjQmHiSDwkm6BaQ0exs31AKWSaajeLIXCV/aBVyOtN7oRM5NdruQbHklU/c8GeV72NcD36vCtCUnpNeyJPouHvd99ZpfR4I0yzv5htJaS7HiATbyHufSo/pqGAsS4ofMWPfBizKcSkAdGhijacanATRcfhamJcHYZbiG0RHGdJtktuUgakV2sBPhCswGDijfXM5Yjkrp86EbzB6B32tAiMvSdM64VcFMpgIV/KYl+eRS0B4AkIurxjrrTEe0k+yqUIM7LtQ5mv0wOmedPK++JZhaoQCKB6zcfGIM1xVSoUp+iGyZu5ej5vl3TylbYFnHEPJmITBfPquJrWXyekZLTB0rPS+z/mBF+YySejlr9lFdINi5nU75EHYrfpxTfYgiuRWOUZLK0vDQtZTaNjPIwBxeS51/ZCr0YF6Ojph8y71Cg5d5aiMNbDYX37j/mdtTI0yF6Lc8DJQqsfS35A+3x2n0fGQgrlVV4Cfs9yToCXm5n3qOvtWdJCKQF880/tKUE9xg2RHr5mmSHGHqL8ZaBQaNIdRA9P39vO2WAFvQ2epu7oXFpJum/AhnMIu6KEjBsWmoJair/FXhOJgLqrHxzpl1lEQb+KbvwNPY07YFlsq0pXJtKaxBU8S808oZhIaemcqZRj1pO2DD6gCwhdCa1RlVA4sMcaDzvrh/6Kw23eVl2bcAlTlIheQE1zgt+nrO6qJ3hpPmR0pZlel9t+Yce3HLnIUfXqeNZXSl6pimpYuxr34zyCF1/DczKtFsvK/V/IJwbnqnZFHzxg0x7IhP61gcoubAxWXVeZW1IpTKgSMVGdfljtsNUX7ByPVVjQN1BKUz++JaxCNNFhHyvTWyjQ5UWkUE8w13EipnaaUQXHOAeb1SJjgRBzABX1Lw36rQhocrFhGSvtzFeSXWVVjb9d5TVLSDRrOCQ7Uxux8w94W1AH67mrJvbnRo4QLnizfUwhV5Sxvf5j4DZvdVZ
 oK+/i8BA
 UY05iK7TX9VOfxaL2oFfB8Gx0t/qSDDsx1ueimWITjURA/8kdFdiUfmhTvBnGjgss67uUcct1MF0ArE+CUldJP04/kCBSQ5/CS2iIGjhm6tMs1HBtLsdNjNd1swQv/wKXXeV5Y6USIyEcHwnOKBcmcm+mgHd+wF+R+0HjbaZtZZRuowXXmRsNyaPgC12Zv347uKxqxJWBJMX7dpAn1R+reEkfgJ0nUKXU8b/xK+uC3nnF1zMTWrHv2QTsMvEw42Vj7Z7MfhEtHcSeTTwtBPRfOFTqSFCCYvqlVDW3CtA/+kMWrXLw84G+BVwoIEQOO0Oukebn4HgnGELqnICnRpA4uuYQV2hZDrmdgLFn1AOxH7kDUsFDOd52js4/hHGEIX6Bw+sTvW++oYGNzsvmG/9vaJAfPk/M36rVqlJT9cV7t2HcQIDN6lKo5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 6:37=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set =
to
> one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
> or arena_map_mmap().
>
> It is convention in mm to mark mappings whose pages the kernel manages
> itself with VM_MIXEDMAP, so core mm knows not to treat them as ordinary
> page cache or anonymous memory.
>
> The map_mmap callbacks ringbuf_map_mmap_kern() and ringbuf_map_mmap_user(=
)
> use remap_vmalloc_range(), which ultimately invokes vm_insert_page() and =
so
> marks the ranges VM_MIXEDMAP, and array_map_mmap() sets VM_MIXEDMAP
> explicitly.
>
> However, the exception to this is arena_map_mmap(), which doesn't set the
> flag.
>
> This patch corrects this and updates the comment to reflect it.
>
> The pages are refcounted and vm_normal_page() finds them regardless of th=
e
> flag, and VM_DONTEXPAND remains set (marking the memory as VM_SPECIAL and
> thus unmergeable). The one effect is that NUMA balancing now skips these
> VMAs, as it already does for the other bpf map mappings, which is the
> reason array_map_mmap() gives for setting the flag.
>
> The intent of this patch is to be able to establish the invariant that on=
ly
> PFN-mapped or mixed map ranges may clear the VM_MAYWRITE flag, as is done
> in bpf_map_mmap().
>
> Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  kernel/bpf/arena.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 7b6847200b43..b69fe5e34339 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map *map, struct=
 vm_area_struct *vma)
>          * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
>          * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
>          * being copied into the child process on fork.
> +        * This is a kernel page so set VM_MIXEDMAP.
>          */
> -       vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
> +       vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
>         vma->vm_ops =3D &arena_vm_ops;
>         return 0;
>  }
>
> --
> 2.55.0
>

