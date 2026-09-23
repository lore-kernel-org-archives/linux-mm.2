Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE95FC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA71E6B0095; Wed, 23 Sep 2026 11:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58A76B0096; Wed, 23 Sep 2026 11:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7FF6B0098; Wed, 23 Sep 2026 11:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90D796B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:59:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36BDB804F3
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:59:32 +0000 (UTC)
X-FDA: 85245486984.20.7D75F2F
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2DEDE1C0004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:59:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="di/Npg32";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790179170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5SJVNSnlSjsq34C95HzHvRHsOZa9DdGTi/lITK1YAw=;
	b=545tvChMs3bNXjpXt+2Q4djtsgq9iVS8KELGqczipKFnUU6ooeX2aRt8QRrwcKRIj0VRw3
	BhyBBsqGj8FOGZy0cXemBZ8yWPUFHBa87WQRYKtaeUep+Eqv1yUwcGKVjRZCxWC5Ypsc0B
	qG4RmRXED7jB8+dmOSz12i/ryn7ZucI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="di/Npg32";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790179170;
	b=3k+PfvdLJEPwjaResFc0XZqHq7J+fg/EL8lUq+c7CqTB0KHrftT861k0u/4+Fx0oBji2vQ
	0e6VxjnavIzOT+oXNauoD4sM+KxmylXLni0InV8tyU7WqxSzsxkVOib+O0fLYEb84XZl5g
	kPvZWZi8Pr85QznUNza2afPudYb3Y+k=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-532e9ad9a1eso235971cf.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:59:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790179169; cv=none;
        d=google.com; s=arc-20260327;
        b=f33P5D9/tz5/LcmUVrAhAnVTXmfD/1/iUQIYGyfI8uOK0z9E+5QtwVdbwY5100cOyM
         MOyB2qrIrvzT/0i2i5qM+iWX3vrN6LhLbRtoPWEHW7BLrQbcv0b09dWRi2geLI4mqxIA
         +nILOfbdWQtMWwSttGuFMSL3PM875Y6HXxXQjEkNYmqhnA4eyVkkZzFnrZ4kSTbxGjo1
         93P4uHMZNtZvk4pBxiRsO7xB9xy/5HzxRu9vfn91ZRikd5WXtKdNXrUUhLucct22lwLe
         Pyv10kaucJ8U8QnYPbuTFmTlZCNoA5IR1gK7A6yeh89BEr0ksd0jjLiMk9BcSOdeaFaE
         lsGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h5SJVNSnlSjsq34C95HzHvRHsOZa9DdGTi/lITK1YAw=;
        fh=cb58s92jklQKzoHxhXtTUBUBGjuB4OLLxKhFiUo2Ly8=;
        b=VoeqdKcm+rxRw0QtrxKWEdJgmMql2OuE1owoKBEfif5kuvT41qXbvwrsO/2SwQSWvU
         k/rFhb33qsiia4y+igr/Qh2Te2LkkTtS3TihLfJPYT2/hHRCUweRtXCIepPZJ3AUZAk2
         +AlOl0io6uMIChzNdpV3cM3J0EuwTlzwM8l1FV1DsB9K2ZtnB8JRZegTo3H0Jf1lthMD
         hQSPVAi9GEsA8BOt8sRKU2bbYmGbdT4bb2TEnToNpDEe7FjE5b4HuJAGSnymj+TxIKkk
         CqxP8Ou13WpkUxPLnRfknANV3i72MtfPzx1wJDOkEe47sQ887ID9mdlvQpzPQHh6Wkmj
         7IyA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790179169; x=1790783969; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h5SJVNSnlSjsq34C95HzHvRHsOZa9DdGTi/lITK1YAw=;
        b=di/Npg32jJCGu9o/ESgc4a343DiuDufoN6D/Mc09uUyzuB6p+0O9KcADkzaoACCeNb
         3WZ0KL5IqsNERcVoWkL9ppRTJKmK9HB0tRXuVLnLmRZLuEuL8Z5ofZUlFtnnlKM6H/d+
         HfXIZlAST/Iylg6WGwL9U9cp1qgxry+v82EliGLBExSvPCON/bXD3lsAPob6Y3s6ILT2
         aYd9EZKLBNWVXlXnLI3TcspYeiY0M0Z0Cl9O8SeLR1zypQxOQIMoo/bS4XH0xkaEguQV
         BISdm9yCY38QAnq8ik3UJoVcD0svJV6C93oZ8W3dZKeWt0U6jq2EBVgUwYsedSUQoOuW
         mNiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790179169; x=1790783969;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h5SJVNSnlSjsq34C95HzHvRHsOZa9DdGTi/lITK1YAw=;
        b=bI8IwhjEReLyqYtmep62GzihhVN/iDbIeKrOaDZle6hZjPpFs74ND7dfuV4U9hQq6G
         ErkqbXOw3n4BUSLNrVrl6BWdkgOlZBJzA2lgvYgJhC9Z2/V8LR/iBEwtyKc8a+kZi83b
         ep7C6i/BV8vyKN8NU42Z8Wu/dUHJ7P+wen4gtaJkkVobTlE2fxsOn2uaLgipKUuoP6DQ
         rbJd2Vj0YN3awOP74RUYwBjHTckNBe6b6H98ykMC3Pty6kI8VL/9JT/oyaBO7+d6sF1p
         Eoq2UPf7f+slGaaDrRzZnc5kSq1xhUKmjBWeoS2+XKQsd2WqJUcj9HICZLp/Fy2ciO7w
         4cSw==
X-Forwarded-Encrypted: i=1; AKwUvBw3L+264H8hryauV7o2JOtYn/Z4qmbkmy+0GQYyZ7KKmauoLBZgYnEgxL8sUCARAiYaj1NdiuKdAA==@kvack.org
X-Gm-Message-State: AFuF++mV2tjiNzunL8dTsf/jhsH2Hi4cYayrr93mUEV4ZzlaS6VgONsT
	JO1CBHA3L1TSrPxzmb1Ju3yMYU7EhkoweGDzBz/xUKEgg5P6gpleR3rKbB7yIrFUZoQTmgPjaTb
	fYy6SAKr20dy6tqkt4G4/Y2b6CcL1EcTGB3nxKWpe
X-Gm-Gg: AYBFou0Mcq6tQaJEPBr4W/Kx5zyUJZhR3qc6pagNJNCS5TtNDY6V2mcM5mU2b6bX2FN
	dfJVrALQ8yEfEjHX9jpWmCjJgl2lYMZri0wL9RLT6dAlIpeqJiB+L5HQPIOw9smBxrVNJTO/HDa
	+3REjW8yqizo1feUB9Ym3XW8znu6iqR2rQcXkeYK2fHZgLDDpCgcehZAoSKpXLqlWUoNBAz3mMK
	yUSjLgpUlyRx1XqyBklfU4Ko2jXDVJnR9XvlJstxGNDuA/eE/DeW5yBsCrcvyZjRk4WtGlG+Jc8
	ZG8aQvfQqum2dHWfKkOgYhQ8IQSTd+RZyTf/dQWrt/cMrVcJGYQoVm6u0+GaxJ0EgKF87V1qrmv
	tOS/ZXC5Mjb9GSpyYeo9D
X-Received: by 2002:ac8:5989:0:b0:532:ad75:e432 with SMTP id
 d75a77b69052e-532f8ea0340mr1106341cf.8.1790179167963; Wed, 23 Sep 2026
 08:59:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
 <CAJuCfpFe+pLusPy-xWYHp2rTP1becBb2nhX16xXd+hKD5Q+Z3g@mail.gmail.com> <arPw-ivHytA_YZTQ@gremlin>
In-Reply-To: <arPw-ivHytA_YZTQ@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Sep 2026 08:59:15 -0700
X-Gm-Features: AclHuK-LB3FJjVej026w9dFvJtSh1nBWJXsZp4uIwz4rkW0AFsOG-iMlndIpr-4
Message-ID: <CAJuCfpF8u=uCkqQ6+2BiOo2ufR3E-JM97ML-_Sbo4cQBfeEHuQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/40] mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
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
X-Stat-Signature: ztabz7yc4twocc97t6tyoz9z7gjta5g9
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2DEDE1C0004
X-HE-Tag: 1790179170-599403
X-HE-Meta: U2FsdGVkX18K3hrjvDmHxKKItQqdASvjwzBjOK6HAI7acRd3bygcQbwrxYLJ5aA9syNLf9xUVksn09pbtnY8nypdaAmOjW49dhQKa/cOKNYrc7iKUOTv88L6D9p6DXtK1dxzDP/Ye+x4+xZTqsQfyhCJ83Z6tnyMLLwXvql4uUhchhMJDame7If4haLTiZQSauUNfrjEAgwEaS8VCCMZTUiNqWuM4an/4Iig7nW74+LJ9jgDBCgSFKYvgHQKkJTf6P4vqTPs6B/9OVUeTZLQ5BdmdRWGKUCSX5SwfG1TcETWHMz90iMhlhX+LMMsp18H2kTMhHAcUgIJ8uMjp5hUKmxYR6/GXxKLakZBg6uBSJodHJZ9c99ut+BRGghd1/DoeJqjTE06h1ZR4+gdGZDZ7sEzWjJJL5tu+IEI19qcCfmW3BgWu18ZC01yMgUp32+cgmS8rgTWB8O1Ufvsl22/A3QsUTtb4Q8f7J95u33MkPLx+xeaxdTDIZBSbOHq0RLH7CkmJ4rnkPjkCHo/NYGrvDuEQfL66oVjHQoT7WBkCnB6t3jY3ojq1QE2Y+4LZhOpC3WSHksYQv2Cg3cRFM3OmM0IheF0rkg0QCInGL5G6JUKYzPph817SwVf5lHC0AX2WQDJYnNWM2wHTxk3jaMzauNpnkiJ0d03amUFPR87esfqrMKir9xj+hLcmFOtFEFIPQkjbrWQu11NaRV+9CDYYsUC+xNjR+oyn7VJyRHEYLaxatZPTaeNgVVSXJARFGsp3SfRRUvUuKbT3fIMCDFV+JtIad9BTzJWUjZS/aei1IhZDEocp+tAi0e+1hAl2Sw0DZ3i6SmuMvaUEojICreh/elR+vAsXSAlZnxEaG+UCuN2MOhmHbj1GsBf8Uyy6G5rnwXCWjAGGJFOsJ47JIVyYE/nCZkxf1TtenFKCo0rXoZ2/Lk5INWGurqbEqKJXPuJWYkmp1ItFNe7x21Rhrc
 NDvf+OpD
 3K+d/w9EWLIS8LlVp0EcQDUn7omtmYYAcqUVlbXwGwDPdBCAq5L0I1nR2tYcMORiEqCL9RvcxY19fd94vWc4l++9984gpauPZjhQVvznWcbl1JOGBIrOv4hNuUFRfEiV7IOBjS5OUxQUR80pt1hlXnTl7TUNZkM9F3W3r4v8gVmZQiKcdPXxJyBtweC6NOoMX2PoFJKLY/+yifi7+lnpunGqEKmn3BVAnU3Rmlc5Y01kdEgny461obJc5XXaw1BlZJsrrH5wHGWFOTWpzWPTlvbuyOhmMVBxFh9kLmldekvuw0H29srOsgcXXm1rYv1r1tQULrz8tcP6kBnYWKvY5OaOWtLlPTde/5nUGxuW9vw2+xCgmpYyndXiFsHdDiya94P6BoevNPH60FK0mRYAIeUbrPsN7QKu8EAtdRV84B1c+XkLoA6dKR5ZgN52Mr2QpvW71UhjIrAHpi0aYWGVuWE836h6h0Zpct2G8eoWIgZjygfI1xU8PStjFSRC4RB9H47vWcfSyNpIFZUWcuGlaEdszbGS39zpkktGoF9eHFTrk0qw8MbUw5WPNAWUssoVQnqW3/QWQQ1qdV2O7ZH7mxBd8vpNtO9/j+ZH2psbsQIeT0fCfhtSfczP2Q1Qk5UzjzvPNqZGwRZqzMSCC298h+zkGfEppDwT65H5ELnhJSze/Ag7a2W4/Jas+5w8J3UttOeQosPs4wxWUImxvou6k28hs4/rjPue4aS7Ym/UZRAKaK/qcyqNjPXRKlWnZlUT+l2VVuT9sbHV5cuQg6HKoFs5vcSOK0vjx5Aqw+q2tFgIAa+0bic1pYxLSu6rejhJSu6Yj6HHQ5YD1xqlkka2lV5eUHWVGeyXZccPl5xS2qPgmZg4X/pjNbfd/jcVqeVixcFbnrwBDUYYkVUdXaxopRrNBctRJrNNHTwFH+panjc6y6d7SvCKyO/4OBnIOfQblzKnVbEdxqxMUJH5i+9CTQZ/y2siq
 LsIY8B2z
 doTreXsAefrbUIPtn/xEIL4I1+c2901TO+11FJmThXUIm4XWfFxdRG+IVDVOSTbEkYWvadmeByL6QsAtxxEM6KFnQKnzplrvzPFbcM1TGxirBkT3PPIfPIWHbkHZBro6lnYHSinjeM/QySJN6npnB0IXixAf45xU3TMjcPMoOoeyjwJGr132Cic+Q1/akkNha5XXShD3Dve6X1zBjjHW8JmckUWxezfFwi6Ntx1aZQu9QzhXeA+zC1B8VUBGMJTj4uZejGjMIjKt9S3tpK00ZqqKclIqXvNlIpXqj9BiMVpDzqu66CHDj1AKZ1JNh5KkqxZFA4h/f7aXKRAWeSXGXz/EQcf75bDclTZSumKAnFEXAmZEGy3umUuWaQZ3rx1bR9CsvT0Osm8JckCQRXtW3HMjF2LsZ2EnoV0QBdPdas1h7PRVZ3m5+nHlLUpjOg9Lq6k3YbQz0mYzsBj1JpybTt5MlSRwQBt5lzGXvh9ugG6GQ/bEQDpGC1nFqkUu87N7ACUJGsvA0F8qcD9MzJHP65Qd2YFITTKPlo7Qcyf7MaFcMDUe1a6JRf/JpNMRqdFAI9IUHnMjGO7Fl42XLGRoETtUY+Xp5IBgx9kf3QeO0VTQsKfCjdlB0/8x8SgR6ushjRsI5ZWsBuHNl9TtrJ3sNps5nab4XM+9zMZqK8vL0qJ2GwPbHPdkkk8A5MjjA3E0QOrKwMQYpTh+5yd92UZQV+5g5tALo6H5KQyNEtw5XQF0pxMIrZeIqFXU4Y5CHRDj+YTV3RlP6+VTsGUy+YRxbwexZaTgp8TPST/hdxbeTdH5UekbyOFdTPnS3vV61iypYBRx3T1eoAj4rfkxhHA84ZSsAOHYkfaYnEqS9v8H2UwlWFCPjSOWxPp2iUKxTbBUH11Rk866BXd99Fxqse/q4bjMrtd1HBGaohDaNwBN3eJV3N9Tf98YAf+iHTGPGjhMmgBeElljgFcwMREnoGh+3NXexjzjC
 oOIdiPEc
 7s10FyTX8hoPHjFJ57tbONEo9fgWQOSejpKy6BToZ4aNJ0EvjtnjVAJHhh1x7+OJL9LhbJObUKjm4KtY2/XlgjF20trx9B8mhJf2fa4DRcHYbxmSE2Elv05UFi87DnUNJOmGDNjGquL9+G3R2G8elM2Ix9HO6GgdJuSKtfRvIdZbSqxzonoUFVamwKCxGaeFoRkiaDpfT4yYlvRxk8g2NyQD5RQjmJU9NYKRclMOE0itSvhaHsnxqp/woGJCadzQaNEKGKINI1KMuD+fKpHI+vdSe/dozYJEI8vmRQ1VQllVS4baiuN4iTzqe+7xJAwsM3Cbrv987wVAYrBT8TdDFneTHK9zqnHlpHGfRjvsVWbMvrTPP1FRfJCHG+98DDG+mH2QhE/IwZgJwB6NtR0DZud6jtdFgI5ssba2QPkVhEUO/n+lfo3sTwaCsNp4M+MDi+LbMi0y3rqZzGVjDkzJOeg/tf52Zo5bp4C6CD/lJrr93p3l386/LdhwpN618SqIok6c5e4tBtUtVugH7inZfUAzzPGacwgEUnZu6JU0dEAkvWS0fQl9qwvO5Ye/cM7lqJTS+vWOEjdeZJaO1YjiMbtZDqCQP29R8IUdj/VdgeELU50ZNIVJWwDrvRHwn4CIlrrBUqIx2woxG7nSG+fFhdo7EZ0Ahdewy58EMYeufAUa+2s5SlchyIDZd5MP3uo62eVpn/Aq7qyaDmD9NdoPPlw5jJ7W0W/M3xXTor4B8dUnaj71A5r1YPA6l1yElObvfjcYCFWX0BSK283ZQLzP1U1lrP5+g0JCvU9bJhhiegbd3hfr1oh42Xj6ZzdN8E41r2J1MeX2ULJXlhKnIZT6CaKBIGpL/PyCK1rfK23lK+3fzv2lvzi+lCHNuiYb6nvqInqub50zvhliz6Mt1d/4MfyEEaTZCL76Ud5c8EbY55ruzNWNN8tv380YOU7KtVRCuz3e7OuCt+cdVCnUVhZ7SAuNY6bX0
 07bn2iiS
 PD/ealEjcjTAgKny7ElAYLE7eFvEtwtfgeYN9Mr6lYWY6Dyhx/rx8fTXR6BitXCbvOh29v7X+BUM9TSdhhGoSHT6oF/dLm9NSfqdASFq1eFEpoFmhnScwiCwfoP/sa0823DIbolqwOeE8a3c4YQme58lkt9cFmoesxWbKOf6ySz4k68YeR7kcDYPT1Gfp9McqcQdAVZ5hhY92vr4yP7hPdHq/gYCD+0oVHcVLdrFFpl+HUu4VWypWYIqFHrXRyjNIZ149DMtRZg48Tl0LVEFTHyh8NSw3pvguf+n5ZDLwDZYqNzQsA2tZ8/ZhmPHGoH7SHD6b9mtM1rQIKZ9E55ie0BWUG5HDvfFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 8:47=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Wed, Sep 23, 2026 at 08:21:58AM -0700, Suren Baghdasaryan wrote:
> > On Thu, Sep 17, 2026 at 9:23=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kern=
el.org> wrote:
> > >
> > > The map->file_doesnt_need_get flag is confusing and the existing
> > > implementation has holes.
> > >
> > > Drivers are permitted to change the owning file of a mapping. If they=
 do
> > > so, they are required to take a reference on that file.
> > >
> > > The mmap() operation which ultimately invokes __mmap_region() is guar=
anteed
> > > to drop the refcount for the original file the mapping was made under=
, but
> > > this is not true for the replaced file.
> > >
> > > This has been addressed so far by tracking map->file_doesnt_need_get,=
 which
> > > is rather poorly named and unfortunately fails to correctly track whe=
ther
> > > or not an additional put were needed in a number of cases.
> > >
> > > Make life easier by removing this flag, and instead drop the referenc=
e for
> > > both mmap_prepare and the deprecated mmap callback in a new function
> > > put_map().
> > >
> > > Track whether this needs to be done by aligning mmap_state with
> > > vm_area_desc and store the original file in the map->file field, keep=
ing
> > > the updated file in map->vm_file.
> > >
> > > In order to have the same behaviour for both types of hooks, only dro=
p the
> > > reference __mmap_new_file_vma() itself took in its error path, deferr=
ing
> > > the replaced file's reference to put_map().
> > >
> > > To make this work correctly, map->vm_file has to be updated before an=
y
> > > error handling, so update __mmap_new_file_vma() and call_mmap_prepare=
() to
> > > set this field first.
> > >
> > > Also when mmap_prepare() changes the file and is then merged, the ref=
erence
> > > count also must be decremented, so update the logic to call put_map()=
 in
> > > this case too.
> > >
> > > Also update __compat_vma_mmap() to manually perform this step for sta=
cked
> > > file systems using the compatibility layer, and update
> > > compat_set_vma_from_desc() to replace vma_set_file() with a correct
> > > refcount/file update.
> > >
> > > No in-tree driver is impacted by the incorrect implementation of this
> > > currently (no driver that does this is mergeable for one), so this do=
es not
> > > need to be a fix.
> > >
> > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > ---
> > >  mm/internal.h |  1 +
> > >  mm/util.c     |  5 +++-
> > >  mm/vma.c      | 83 +++++++++++++++++++++++++++++++++++--------------=
----------
> > >  mm/vma.h      |  6 +++--
> > >  4 files changed, 59 insertions(+), 36 deletions(-)
> > >
> > > diff --git a/mm/internal.h b/mm/internal.h
> > > index 0dca33db068f..fe576d468af4 100644
> > > --- a/mm/internal.h
> > > +++ b/mm/internal.h
> > > @@ -7,6 +7,7 @@
> > >  #ifndef __MM_INTERNAL_H
> > >  #define __MM_INTERNAL_H
> > >
> > > +#include <linux/file.h>
> > >  #include <linux/fs.h>
> > >  #include <linux/khugepaged.h>
> > >  #include <linux/mm.h>
> > > diff --git a/mm/util.c b/mm/util.c
> > > index bf0513d1d3d0..016932780925 100644
> > > --- a/mm/util.c
> > > +++ b/mm/util.c
> > > @@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *des=
c,
> > >
> > >         /* Perform any preparatory tasks for mmap action. */
> > >         err =3D mmap_action_prepare(desc);
> > > -       if (err)
> > > +       if (err) {
> > > +               if (desc->vm_file !=3D vma->vm_file)
> > > +                       fput(desc->vm_file);
> > >                 return err;
> > > +       }
> > >         /* Update the VMA from the descriptor. */
> > >         compat_set_vma_from_desc(vma, desc);
> > >         /* Complete any specified mmap actions. */
> > > diff --git a/mm/vma.c b/mm/vma.c
> > > index 55917d097933..fa784f069da4 100644
> > > --- a/mm/vma.c
> > > +++ b/mm/vma.c
> > > @@ -24,7 +24,8 @@ struct mmap_state {
> > >                 vm_flags_t vm_flags;
> > >                 vma_flags_t vma_flags;
> > >         };
> > > -       struct file *file;
> > > +       struct file *file;      /* mmap()-specified file. */
> > > +       struct file *vm_file;   /* May be updated by mmap_prepare. */
> >
> > Overall I like the change but I think you could avoid extra churn by
> > keeping the name of `file` as is and add `struct file *orig_file`
> > instead as:
> >
> > +       struct file *orig_file;   /* mmap()-specified original file. */
> > -       struct file *file;
> > +       struct file *file;      /* May be updated by mmap_prepare. */
> >
> > Then many uses of map->file would stay unchanged.
>
> I didn't actually want to do the churny version of this but the problem
> with doing something else is that would then contradicts what's in
> vm_area_desc:
>
> struct vm_area_desc {
>         /* Immutable state. */
>         ...
>         struct file *file; /* May vary from vm_file in stacked callers. *=
/
>         ...
>         /* Mutable fields. Populated with initial state. */
>         ...
>         struct file *vm_file;
>         ...
> };
>
> And suddenly what is 'file' there (inherited file) is the modifiable one
> here and it's more confusing.
>
> As per the commit msg:
>
>         Track whether this needs to be done by aligning mmap_state with
>         vm_area_desc and store the original file in the map->file field, =
keeping
>         the updated file in map->vm_file.
>
> But maybe I need to make that decision clearer there?

Ah, I see. The description is clear, I was just too focused on the
churn, I guess.
The reasoning to rename makes sense to me.

>
> >
> > >         pgprot_t page_prot;
> > >
> > >         /* User-defined fields, perhaps updated by .mmap_prepare(). *=
/
> > > @@ -43,8 +44,6 @@ struct mmap_state {
> > >
> > >         /* Determine if we can check KSM flags early in mmap() logic.=
 */
> > >         bool check_ksm_early :1;
> > > -       /* If .mmap_prepare changed the file, we don't need to pin. *=
/
> > > -       bool file_doesnt_need_get :1;
> > >  };
> > >
> > >  #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_=
, vma_flags_, file_) \
> > > @@ -58,6 +57,7 @@ struct mmap_state {
> > >                 .pglen =3D PHYS_PFN(len_),                           =
     \
> > >                 .vma_flags =3D vma_flags_,                           =
     \
> > >                 .file =3D file_,                                     =
     \
> > > +               .vm_file =3D file_,                                  =
     \
> > >                 .page_prot =3D vma_flags_to_page_prot(vma_flags_),   =
     \
> > >         }
> > >
> > > @@ -70,7 +70,7 @@ struct mmap_state {
> > >                 .vma_flags =3D (map_)->vma_flags,                    =
     \
> > >                 .pgoff =3D (map_)->pgoff,                            =
     \
> > >                 .anon_pgoff =3D (map_)->anon_pgoff,                  =
     \
> > > -               .file =3D (map_)->file,                              =
     \
> > > +               .file =3D (map_)->vm_file,                           =
     \
> > >                 .prev =3D (map_)->prev,                              =
     \
> > >                 .middle =3D vma_,                                    =
     \
> > >                 .next =3D (vma_) ? NULL : (map_)->next,              =
     \
> > > @@ -2447,7 +2447,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
> > >   */
> > >  static bool accountable_mapping(struct mmap_state *map)
> > >  {
> > > -       const struct file *file =3D map->file;
> > > +       const struct file *file =3D map->vm_file;
> > >
> > >         /*
> > >          * hugetlb has its own accounting separate from the core VM
> > > @@ -2496,7 +2496,7 @@ static void vms_abort_munmap_vmas(struct vma_mu=
nmap_struct *vms,
> > >
> > >  static void update_ksm_flags(struct mmap_state *map)
> > >  {
> > > -       map->vma_flags =3D ksm_vma_flags(map->mm, map->file, map->vma=
_flags);
> > > +       map->vma_flags =3D ksm_vma_flags(map->mm, map->vm_file, map->=
vma_flags);
> > >  }
> > >
> > >  static void set_desc_from_map(struct vm_area_desc *desc,
> > > @@ -2506,7 +2506,7 @@ static void set_desc_from_map(struct vm_area_de=
sc *desc,
> > >         desc->end =3D map->end;
> > >
> > >         desc->pgoff =3D map->pgoff;
> > > -       desc->vm_file =3D map->file;
> > > +       desc->vm_file =3D map->vm_file;
> > >         desc->vma_flags =3D map->vma_flags;
> > >         desc->page_prot =3D map->page_prot;
> > >  }
> > > @@ -2586,6 +2586,10 @@ static int __mmap_setup(struct mmap_state *map=
, struct vm_area_desc *desc,
> > >         return 0;
> > >  }
> > >
> > > +static bool map_same_file(struct mmap_state *map)
> > > +{
> > > +       return map->vm_file =3D=3D map->file;
> > > +}
> > >
> > >  static int __mmap_new_file_vma(struct mmap_state *map,
> > >                                struct vm_area_struct *vma)
> > > @@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mmap_st=
ate *map,
> > >         struct vma_iterator *vmi =3D map->vmi;
> > >         int error;
> > >
> > > -       vma->vm_file =3D map->file;
> > > -       if (!map->file_doesnt_need_get)
> > > -               get_file(map->file);
> > > +       vma->vm_file =3D map->vm_file;
> > > +       if (map_same_file(map))
> > > +               get_file(map->vm_file);
> > >
> > > -       if (!map->file->f_op->mmap)
> > > +       if (!map->vm_file->f_op->mmap)
> > >                 return 0;
> > >
> > >         error =3D mmap_file(vma->vm_file, vma);
> > > +       map->vm_file =3D vma->vm_file;
> > > +
> > >         if (error) {
> > >                 UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_e=
nd,
> > >                             map->prev, map->next);
> > > -               fput(vma->vm_file);
> > > -               vma->vm_file =3D NULL;
> > > +               if (map_same_file(map))
> > > +                       fput(map->vm_file);
> > >
> > > +               vma->vm_file =3D NULL;
> > >                 vma_iter_set(vmi, vma->vm_end);
> > >                 /* Undo any partial mapping done by a device driver. =
*/
> > >                 unmap_region(&unmap);
> > > @@ -2623,7 +2630,6 @@ static int __mmap_new_file_vma(struct mmap_stat=
e *map,
> > >                         !vma_flags_test(&map->vma_flags, VMA_MAYWRITE=
_BIT) &&
> > >                         vma_test(vma, VMA_MAYWRITE_BIT));
> > >
> > > -       map->file =3D vma->vm_file;
> > >         map->vma_flags =3D vma->flags;
> > >
> > >         return 0;
> > > @@ -2631,7 +2637,7 @@ static int __mmap_new_file_vma(struct mmap_stat=
e *map,
> > >
> > >  static void map_set_anon(struct mmap_state *map)
> > >  {
> > > -       map->file =3D NULL;
> > > +       map->vm_file =3D NULL;
> > >         map->vm_ops =3D NULL;
> > >         map->pgoff =3D map->addr >> PAGE_SHIFT;
> > >  }
> > > @@ -2643,7 +2649,7 @@ static bool map_is_private(const struct mmap_st=
ate *map)
> > >
> > >  static bool map_is_anon(const struct mmap_state *map)
> > >  {
> > > -       return map_is_private(map) && !map->file;
> > > +       return map_is_private(map) && !map->vm_file;
> > >  }
> > >
> > >  /*
> > > @@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *ma=
p, struct vm_area_struct **vmap,
> > >         }
> > >
> > >         /* Invoke callbacks. */
> > > -       if (map->file)
> > > +       if (map->vm_file)
> > >                 error =3D __mmap_new_file_vma(map, vma);
> > >         else if (!is_anon)
> > >                 error =3D shmem_zero_setup(vma);
> > > @@ -2797,11 +2803,15 @@ static int call_mmap_prepare(struct mmap_stat=
e *map,
> > >         int err;
> > >
> > >         /* Invoke the hook. */
> > > -       err =3D vfs_mmap_prepare(map->file, desc);
> > > +       err =3D vfs_mmap_prepare(map->vm_file, desc);
> > >         if (err)
> > >                 return err;
> > >
> > > -       /* It's invalid for mmap_preprare hooks to clear vm_ops. */
> > > +       /* Update first so file refcount tracked correctly. */
> > > +       if (desc->vm_file !=3D map->vm_file)
> > > +               map->vm_file =3D desc->vm_file;
> > > +
> > > +       /* It's invalid for mmap_prepare hooks to clear vm_ops. */
> > >         if (!desc->vm_ops)
> > >                 return -EINVAL;
> > >
> > > @@ -2811,10 +2821,6 @@ static int call_mmap_prepare(struct mmap_state=
 *map,
> > >
> > >         /* Update fields permitted to be changed. */
> > >         map->pgoff =3D desc->pgoff;
> > > -       if (desc->vm_file !=3D map->file) {
> > > -               map->file_doesnt_need_get =3D true;
> > > -               map->file =3D desc->vm_file;
> > > -       }
> > >         map->vma_flags =3D desc->vma_flags;
> > >         map->page_prot =3D desc->page_prot;
> > >         /* User-defined fields. */
> > > @@ -2826,7 +2832,7 @@ static int call_mmap_prepare(struct mmap_state =
*map,
> > >          * anonymous mappings. Rather than allowing these mappings to=
 be odd
> > >          * outliers, simply make them truly anonymous.
> > >          */
> > > -       if (map_is_private(map) && file_is_dev_zero(map->file))
> > > +       if (map_is_private(map) && file_is_dev_zero(map->vm_file))
> > >                 map_set_anon(map);
> > >
> > >         return 0;
> > > @@ -2845,7 +2851,7 @@ static void set_vma_user_defined_fields(struct =
vm_area_struct *vma,
> > >   */
> > >  static bool can_set_ksm_flags_early(struct mmap_state *map)
> > >  {
> > > -       struct file *file =3D map->file;
> > > +       struct file *file =3D map->vm_file;
> > >
> > >         /* Anonymous mappings have no driver which can change them. *=
/
> > >         if (!file)
> > > @@ -2868,6 +2874,20 @@ static bool can_set_ksm_flags_early(struct mma=
p_state *map)
> > >         return false;
> > >  }
> > >
> > > +static void put_map(struct mmap_state *map)
> >
> > nit: maybe put_map_file() to be more specific?
>
> Sure will change.
>
> >
> > > +{
> > > +       /*
> > > +        * An error occurred or the VMA was merged.
> >
> > It's a bit weird that the function explains when it is being used.
> > Having an appropriate comment at the call site seems better to me.
>
> Ack will change.
>
> >
> > > +        *
> > > +        * If the file was changed by the driver (which is required t=
o increment
> > > +        * the replacement file's reference count), drop its referenc=
e count.
> > > +        *
> > > +        * On error, the caller always drops the original file regard=
less.
> > > +        */
> > > +       if (map->vm_file && !map_same_file(map))
> > > +               fput(map->vm_file);
> > > +}
> > > +
> > >  static unsigned long __mmap_region(struct file *file, unsigned long =
addr,
> > >                 unsigned long len, vma_flags_t vma_flags,
> > >                 unsigned long pgoff, struct list_head *uf)
> > > @@ -2922,7 +2942,10 @@ static unsigned long __mmap_region(struct file=
 *file, unsigned long addr,
> > >
> > >         __mmap_complete(&map, vma);
> > >
> > > -       if (have_mmap_prepare && allocated_new) {
> > > +       if (!allocated_new) {
> > > +               /* Merged, so need to drop refcount. */
> > > +               put_map(&map);
> > > +       } else if (have_mmap_prepare) {
> > >                 error =3D mmap_action_complete(vma, &desc.action,
> > >                                              /*is_compat=3D*/false);
> > >                 if (error)
> > > @@ -2936,13 +2959,7 @@ static unsigned long __mmap_region(struct file=
 *file, unsigned long addr,
> > >         if (map.charged)
> > >                 vm_unacct_memory(map.charged);
> > >  abort_munmap:
> > > -       /*
> > > -        * This indicates that .mmap_prepare has set a new file, diff=
ering from
> > > -        * desc->vm_file. But since we're aborting the operation, onl=
y the
> > > -        * original file will be cleaned up. Ensure we clean up both.
> > > -        */
> > > -       if (map.file_doesnt_need_get)
> > > -               fput(map.file);
> > > +       put_map(&map);
> > >         vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
> > >         return error;
> > >  }
> > > diff --git a/mm/vma.h b/mm/vma.h
> > > index e97bd2dfa786..f15faa83f3d6 100644
> > > --- a/mm/vma.h
> > > +++ b/mm/vma.h
> > > @@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(stru=
ct vm_area_struct *vma,
> > >
> > >         /* Mutable fields. Populated with initial state. */
> > >         vma_set_pgoff(vma, desc->pgoff);
> > > -       if (desc->vm_file !=3D vma->vm_file)
> > > -               vma_set_file(vma, desc->vm_file);
> > > +       if (desc->vm_file !=3D vma->vm_file) {
> > > +               fput(vma->vm_file);
> > > +               vma->vm_file =3D desc->vm_file;
> > > +       }
> > >         vma->flags =3D desc->vma_flags;
> > >         vma->vm_page_prot =3D desc->page_prot;
> > >
> > >
> > > --
> > > 2.55.0
> > >
>
> --
> Cheers, Lorenzo

