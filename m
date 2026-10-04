Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5748DCA5FE6
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 644996B0092; Sun,  4 Oct 2026 13:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F57D6B0093; Sun,  4 Oct 2026 13:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD426B0095; Sun,  4 Oct 2026 13:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FFE36B0092
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:23:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8FB2AA0B40
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:23:05 +0000 (UTC)
X-FDA: 85285614330.24.7F789C3
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id B0611120003
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:23:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YNEeXleW;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791134583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqiCaT+6hB/MlQ3EgaRNQmjR57IQALnN7KoYl50i5vw=;
	b=b0lcPObXGw6WX4CH3vYXk4YL4nXqlgIYb0NEyYipI0nKPBTNMCj2ohd0TSWv3Ro1m+QLEQ
	MMoTh8I6sBCEHO6hIWUItOho/9H2zXoke6q9+1xcziLTwIlU2MxFYgRp2KASC5iC2ouWm3
	wqVPPWKF0Dr5XFCdk+TsHnPYSwyo1Ns=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791134583;
	b=IlAhyOs7Pu9X/+hFPdfiHQOvF8UI+6D56mm1m5B/DWhIM7pZblNohlJEn+SXIZZTv0BjfQ
	/izaWN3Qrk1QpQjjLqeilf2vXjXP1A0F1SjNQulNq3BbbVLyXfB2Grir+y1EtY3Kf/QRRI
	dM+PFITwGH6ciHSwnRP1oXqlhJmpI9w=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YNEeXleW;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5337c7b9937so259701cf.0
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:23:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791134583; cv=none;
        d=google.com; s=arc-20260327;
        b=NnpRol2WSfSPSMevh87GiQMSVJ+WFKG8W1rTG2FfsdzSspwNaWqYPsIidYV8TNWLz0
         biPcE+tjnTSFRWE3lnrwpAx35gq9HWAQu0CBPdZo8kinmqeXeNxgrdxNuqok7JXySojM
         AE6otGN58wllG/mrWAEb+N5eH9c0Ofb/n8PaxZBx8YzqirvEGw0k09yKlAoCqe0Kkfys
         UPlk9X6a/INr/QvVTAsjraP0HpmQroie6ZOQMM2Rv98meC/JSNJdlxsAt1MaRtwmjvtb
         IxA/igvW7VF0GWwYjk1OdRCGCeoE5GRv2xCsz/8betPLgiebJyN3PgsQkDLwoo37B9F7
         bSkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bqiCaT+6hB/MlQ3EgaRNQmjR57IQALnN7KoYl50i5vw=;
        fh=+kdz+XuoXKudocbtc1iUesqoTmHnxKiZbZNhTDgj3Js=;
        b=LIPpLmqppzRcBew4xY30ZaZPvW6WDMsRBy61N+OKZAgYyB6eaq62y9SOe29bbYLYYT
         fH/oz7sHHKEDQtc7fqnpwUECPhjDmbbsQU95N2IHNmJ9oK5sqeHCUJbknyc8kcuHccTV
         cAX2LLqTA8ThltBX3TSH98KwbyflNC9Q5e901hFrUCQOtburPd76bMdg9A+5xUQUmvOX
         tHq1h29wz2Fb+1kv092pCGAmhAOU5waitvl6kJKO2WlNFwfFZxhwvWhy8X3JTn99RBU5
         JkZz85Xu0b+rkBk/XzLVG3Zcy9d4anxRQF669+LuK25hD8QbWd0/X0WgSvmWvlqoICdS
         SBKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791134583; x=1791739383; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bqiCaT+6hB/MlQ3EgaRNQmjR57IQALnN7KoYl50i5vw=;
        b=YNEeXleW+ul+O4OssGg5ektcsAmJZStcvM2pD0PR/l7ZXOnEwrKvocpip/6YGWIiUW
         OKrS262VYUgiAoqnbGJmw4FLlnNI55omM5GejcVOi2olFN+EW40hvoG06KTjq0WcYa3r
         7UGo1r9SM9P+bhzK6mmZAJHr0CFyADArA12Q8Y4CgBe1Tdv1bcEPcWL9e9KeGLxUoqeF
         85hmNBuproE6qCf5YLqdm8U6CRDbtY+TL0R6p1ExQBaM2UaSRKwSL2vEJ+uMjJqreZWK
         eujaFBtZS+GDpwBPOADBDV5JaTqIVqGYS+Kz1oVmVYwORduMReZKj1629XcsV/EgArfs
         4stg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134583; x=1791739383;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bqiCaT+6hB/MlQ3EgaRNQmjR57IQALnN7KoYl50i5vw=;
        b=zlx5o+x8ngYilE/oPzz2eVquhbVlIMQa2ET8hjqskmlsMoOqeT4eD0F+qJUMQCNit9
         SfuxeQiOoNMzn1KsA+pvEeZRffdSIHzXogyDGrmQzYSDQQTTmFOXY1Ca9SelA2yKxbYe
         2rfD0Rsy6zx4EKXeqhbJ6iLi3Q2Bna9JZ7keMip/27fIwehoNCr9l/RJTpaay5sxTh+X
         TkHu2e+EL1Ve27e4WSQJp30Xz4iNNPdkfvGSUSKS/hCth99bVPnbtoPqixlGpw8Ih6gy
         4fnyL3JC3xY4dDLSiMCeNueZ9QgPZ7jKYWbW4ezuhZuMsatL9kIO26z9rycPQhhYCVsa
         X6SQ==
X-Forwarded-Encrypted: i=1; AKwUvBzkGr0/scj0kFq2tUFJF5yHJYnxkxgvwwwbShC5QpVfdR9hfkBAOLHaVeHYlK1IfJUkqQUgUUvigw==@kvack.org
X-Gm-Message-State: AFuF++mGK29q3FCkpQIul3ntyfhGiOJsVPSZPcJgsKZ4QUKf5YPPXLu+
	DgZohk1aFqDKfKk8MrLr2dqx3LfLhYt/mwVIJlerAZ7Rx0ml/WkBqWWMLYy+U6tKUbY4ZAq+IIM
	vcJptH3i1p2h9dAIffi5AVsH+fSU8xTgdmqclVJBw
X-Gm-Gg: AYBFou2WBF2XhVMOpvhIHGNxtxX7BMox2n+ZRKqu3E7/k+YYf+nJ7vfsiqIe/ZWxeC7
	QbMTcZmsxl8RUWI5c2wzaWqz+2k2oZQZFeJu/mSmBJaDUL49IVoQy6m72nn3dkrVRMLwwLaAv2T
	8HsWZ8J9UblBdoLqQXdiIxvc3jCUcZw6ymi/GhTew7mfRDVWv8rqiFAV/qxJIEA3a+39anBf7Jz
	47QdcgDwxIFGmQ3ZGfiH4spQ1kwVAJgOwQ0+YV0Xz7g3wMzyhiamPw1HiKDD9ZKml1Zi/b4s8tI
	CbOj8rolWMmiF6RlAr2vBtunvGxJJewt7dr3R6Q/GE8idETAZq2r6Ise6m49oAyPoZg=
X-Received: by 2002:ac8:574c:0:b0:531:475:4ce6 with SMTP id
 d75a77b69052e-535131b2b85mr16362481cf.9.1791134581910; Sun, 04 Oct 2026
 10:23:01 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-12-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-12-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 10:22:50 -0700
X-Gm-Features: AclHuK9b8f-m7wgF2pmH0VTlVxkwioKHBPR714nLjuu-GaXS_Vt3fJyAlsba0Do
Message-ID: <CAJuCfpH8GeLKqFtfC_a5i08dQ2ZyyROSrYqYP6Btq03xbF_nXA@mail.gmail.com>
Subject: Re: [PATCH v4 12/38] ALSA: pcm: use vm_insert_page() to map PCM
 status page
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
	fuse-devel@lists.linux.dev, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B0611120003
X-Stat-Signature: ic8gbtyiem58zznudtw6jrodqgfj1c7r
X-Rspam-User: 
X-HE-Tag: 1791134583-402132
X-HE-Meta: U2FsdGVkX1/fDtAdI6HyKAag1p79jUqjozR51I458r0jWMMkPV03XquZ06Qvv+CURk6DgBpo6ezQIwYHSXZjQdXBmZudZLfy20R31LaovMWEP+WOQwjLbWdfWiE+mKR19ZRheSjUutFjYJstHYDuDI/k+LnZXl498UNNpi0iS6Z8ctkI8JVtEyBZ68ZxpjvH20J+BhAJZtQ/9wHbXuO6OdEBJJD+mHk6t5sE5MD+5fP+4Oj5Ox8w34QIPD4BKTPvImJuUVRnehjhcEOh+Hj7tFylrklS1kIULuLqBwsa0wTg04NxV+AAptpokrP3N/7ebk+nUA+FLav1uM/wfKWX5Hu9Hz9FG1SMoRMkaCYaDERtVtH8PzkFijM0rJr/dTaApm9VQjQKBbUF9cxZZ+m7p/ApCyxUtC0UP21KjvZy+kdL2UPM+t46Dt3xKmafa9u84/x1DcadeiCVgsKvmR+3vd6OF5ZHJRu4rIXPgnt2rd3xva3cHkqo9e8/C0Qr6VRLCdtsiT7U9wIggUpiO8eI2A/KZFHKaJUdlD+bO4+61t3UNukuTg/K6AEn1j//XJ6qPmUMnypzCgjAhFChNYh4S+AkGDnl7WWxXO/5uRlVO/sWFVYcx+rchMXCJU67fyasJqd+VFLaEFZXSs58nEWLdGOnBZzQ0hVOVAvTCjg+wtNZISC/48xRwmRrbA1weoRRjc7PnvoCRDRnO2fYkualTxalZko/v4iUFrDbK+knmIjKlyNJ2lIYi5v77ZhdGklq0jkWL8s2jM2MwrTkoxLY4MSttSPsU6XQuG+0yy46KAMZbCE6jCh9FjlvtRl/ADcl0HfjunyVngRDg41Xk2occ/saznAVooaVDWJVhhOgm86depPy3gFWSYdt+81srLIBTRush8D6+ZeEHilLr6tXRYMF/zzwnCH+aqno7og8Q4fnJjVGpTYZhWxv1ZgkmS//hft6jRXeEWV2viOa1lJ
 HkXBiZTN
 J1Z1YOsAxBnkeZxF5OteB0jvZLhzpMF0MRHAKJA1SeHWv6FWTky7dXbdryFK5cg84Pw8AziAKtr2F2WlZYhbNghRwz34jI6QzEZ2KD/migytG0Cj2bEx8CxCLtpNZtoLJq7AVsJ6gzpoSclB5u0m5tEoJyIgs0iRQnKqcwR++aJsEX9Ecp3TuW6LnoAZJtzXT+raNpEEC2CosaOSH8ZIjv/17+WEjaPGpVsPQlupaifADniyR2SCdj6f4oUyjQPQNCD/1E+ROjvgJi8WdC4HfFax3cv9H+JHOPQv5oa+hebZLlB6e1flU6zMD3oP7LlPUXHR4AG8+mWzcPMnXzuyn28uY0IkH42Ibcf+s+KxH02sfVFvzjDvhpsRqmpZHuXKKrx/6CgWS/Wwdr9l2HYsoolowD76+hACfVVBl8i/WS4hk2TNfFt1zfcJkLGojBAfmLBxllfSfJFMtN3aawU1nsWiGJyrndyZzQ9sbCKdhpCy9fjTc++w25cblmXfzHzYPz1bVBE4jbxcf8NYuf+tEo1ysTvz72/8vfSeDiNV1QIsjwH2w7qcqgn1qqsNl7OU0wolyU3JA2QnRZFDEw01sThRsLOcQ+FAsPb8uSyKZizYMW9KO5yrrKjMANmndpnTK+Dn/4+KNooMA5Gu3J5klzfw+E9yeBf7pDdMyIweJQ/Q5mg1fM+BO/eg5JiTrlyiYayeTWveC7kliYDYwUEP/U8mOoPVaJNJkxKhaA5hLsacMtfyFAOZ7AGB7gcwPYRV9VagAp5OxBQsho5fFlURlkuhlVgq6jyQkEBgiW8QQ9Dq2ZGWgGYro546EyLYwHOSWiNcQDFqihNoNfZae58/oud25tEbqa535alcgTiePzOMCwSYV5zDx63d2v0jIKd5MlSqZQLfKDl1T9b2DHzB/FS0aNvn1xOnDJnlYmrJGGGvt8FrEmYJElHZ2mgVseP3rw3qNuyzpVsZ3NQjUP+AJvkiSkZ6u
 9jw6iB3a
 WQximL3ONeEV942ML1mztid/8TJ4GwDQNRZAXK4TVO73rpOjtPl2ZlBOHrVn2q3LHtdCkP0vlmsWuJluDfNFul1JAFg039cAyS2H8fMYvCQ9bDdVlaqYRbC9wV4IefQ8zunlheevW8JfoICyTPGESiW9Z7yjvWm3W7ZH867LrcQwQdUiJKrTiKuAn1wqsC4yS2vQpXj4t4C8jc1Vlv/IoaK4OHWlAQdOLOON/tnWOF4b6JEQ/xLLLio8sGCE+ub+Bf1Bo8uCEp0MTc/d0Pj/07ifbtnlxgJeamWQmw2gm+wjyIFXBXXn0NwDJUTGYv30EVJ8uE716Yr0PLuXcBciWlBlz0Fd2cizki2bdvqDHBBOKbpxg+nqpst39r6MTdM7kTbzdDf6jnoTV7ff5Gh7DLelSLZ/cs67nkX4OzKjUe1H478eBiDHP19uNLV7ILjNbC6NdGxzQmjh5ygO6Aq7lp9sgcxjHs2UTpf1HJ6Rsye7MBiU+vJkIkE1t61i7dgARXFoMoGt/ZfzGeXERLjBAwmWUQb3GrEeeLwHj2vTkp5XWha7z8mDjRW2vKpbAz1Ws0Znx+17xXJPEEt0IL1B+gHdMc1odhTRTzYMW28RY9xP/T7SGRh0KbQPjJaU6/yjEJEGnrtrNlhT6ci6uzkmXCpOjWCw+FKcNrEbOTCoFqkGkzglqmvB16+zWTd8ZhdL2BeSbcl/GpoxRyMLn7gk7vcKV312sDint4ENYPcIzFkA3HJPL1W7FvV+gKBAd9YFO3Wr/GZuDcSPHhKbHckUo/eMZPIF3acfY6Mas3s3UZbs7KcIfTHUTshblIrfwIAmkkk4etfdkZJ6J/VvMZrsMuLrJmWHd9dj29+pYD8c1kE0xJJa9v9b434bcaUjGagfP4oZnKJrvMfUtTjrKPzuEgRt2BlXi3bgFaRNmxLaLtzm6lXpuBPJet82tT3d5GpGshZnas+gtaHpgAU+CEVmAhV7PKGt9
 JYsDVgAm
 49oJaZ3LrsxJkALvxinucgjY0yLUz8Nc7fAwyKg3O7UpCDfz4h48PwNtIc1pVw6ujb5w80zzgS4TcvYgLb9GrvIA8s7Gl4qVLPmpAjE+yAeM4kqlIS9vOcjTdUxh6x0KqS7diBP8ZzvDs3dHKcdEyFvjxPYiFmWHoT3iuPGWNJCK1XGTI1S12bf5c1HN5+IKpXQFmx0q50TvMs2ha75h4bB4bSi41UqLD33qklAeoiV/ts6iOEziGEU3K6mOgJ1TQuBsNc+0RQr0E5kNZSj6y89v0zNI1jmeECzSy7RuUY5d0/CGIn3gWMfqBXasCp+8RztpUdhhooqdnF7swuAI5DtKDC6IhnQ/whmCIeat5rxi7TieLHjzOA9nBRV2qZ0S5MPpEkdZaDPBp/tZXQz+zUjUyhkWOdSDDYhjUyu2ppatYnOjhBzSt/9WowNcBiA19p4ZYQFJ3zh+kzOtgEr2N8TlOffFTAofEDgbIHzmiVZTIsUl7YPNTkYX4U/2CtE80Gtj1pjsgBbueTtUSGlCTlFO+8cWoDAQtvZ9ygksR9TqldjlVFo8Xma8P9tGOxCFvNkR/tZNO4iH9ot8aktEuwo8q2uZboESWeI0Ss5j4kBwpbePldxxOjxKMxKaiIdWomzaLuTfEb/qkJ4zfZGkxGqof1eSLrcI4IUxXMC+EM7MOBKZGBvYv/xvYw2b+ZzBAsucpsrRJ8X00S8umfdFcSHZdfv1z19UFHxwKlbUGYzq0D62btAASl4veNUQdLBSA9YlN3S6TbcFdkKv/m3eZQJ4FHpO9xajbMGVvd9XdhBo+Iab+V0HBFHGqUFDnwN1Z0dfbJfnr9r9UEkMMLp+RlFZdiuvox5w3ywyBpfStK3g9FOFlINH9kWYV49+hl7dpyS9qPkty/4ucgaidwPtQNaD71DLTUozb8D3/jsWXxPiIHq3DyCM3WyJLz9qlwrAoF6VGcWqWcjvq7Ut9O2fzpb+tMLaX
 1+OYAkuJ
 7hnKvBL9LJqKa5NpL9XKLlI49UHWnBJIcmnniLm4i5zK7RROEL9fzB1oNtqd/vVeWVWXWpZ+KvrRjDZGXH8s5p7pvTIjrJ4kt7l3vIisFFrIjr6KgI+AwdN74rVEiEBw4b/F25GLCUQXzun7ijSl0hlfGBVikUorw6bQtDvVG5iqpzPe+pwfciJM9sBh+EPXQKAKSxaR6wHdVIEuB60zLYxfpIpddmc8XdRbr++itNQc3RATYQvdY8AZ7IhYJHSDku9EqEhxu3ezvkFLZNnRIY9Q4i8Ozu7cm3Gg6aOLAXf0HEdzUh24Bbbas1Bm7+dG+ZDuxWoeuoCW1SaYI0JJd3hfIsTapizFgYMfGoV2aJV/V+wHXRIRsy3qUyQIj5vTU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 6:37=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> There's no need to keep a fault handler around for this, instead map on
> mmap.
>
> While we're here, rename area to vma to be consistent.
>
> This correctly makes the mapping a mixed map mapping.
>
> This works towards establishing the invariant that only PFN mapped or mix=
ed
> map mappings may clear the VM_MAYWRITE flag. The status page mapping clea=
rs
> VM_MAYWRITE, so it must not be mm-managed; the control page mapping remai=
ns
> writable and is left fault-based.
>
> The assumption is made that the struct pcm_mmap_status structure is at mo=
st
> a page in size, which is asserted as a build bug.
>
> This is safe to assume, as the size of the structure is 56 bytes at most.
>
> Acked-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  sound/core/pcm_native.c | 38 +++++++++++++-------------------------
>  1 file changed, 13 insertions(+), 25 deletions(-)
>
> diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
> index 62324282fcae..c98fb3df14f3 100644
> --- a/sound/core/pcm_native.c
> +++ b/sound/core/pcm_native.c
> @@ -3760,39 +3760,27 @@ static __poll_t snd_pcm_poll(struct file *file, p=
oll_table *wait)
>  /*
>   * mmap status record
>   */
> -static vm_fault_t snd_pcm_mmap_status_fault(struct vm_fault *vmf)
> +static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, stru=
ct file *file,
> +                              struct vm_area_struct *vma)
>  {
> -       struct snd_pcm_substream *substream =3D vmf->vma->vm_private_data=
;
> +       const unsigned long size =3D vma->vm_end - vma->vm_start;
>         struct snd_pcm_runtime *runtime;
> -
> -       if (substream =3D=3D NULL)
> -               return VM_FAULT_SIGBUS;
> -       runtime =3D substream->runtime;
> -       vmf->page =3D virt_to_page(runtime->status);
> -       get_page(vmf->page);
> -       return 0;
> -}
> +       struct page *page;
>
> -static const struct vm_operations_struct snd_pcm_vm_ops_status =3D
> -{
> -       .fault =3D        snd_pcm_mmap_status_fault,
> -};
> +       BUILD_BUG_ON(sizeof(struct snd_pcm_mmap_status) > PAGE_SIZE);
>
> -static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, stru=
ct file *file,
> -                              struct vm_area_struct *area)
> -{
> -       long size;
> -       if (!(area->vm_flags & VM_READ))
> +       if (!(vma->vm_flags & VM_READ))
>                 return -EINVAL;
> -       size =3D area->vm_end - area->vm_start;
> -       if (size !=3D PAGE_ALIGN(sizeof(struct snd_pcm_mmap_status)))
> +       if (size !=3D PAGE_SIZE)
>                 return -EINVAL;
> -       area->vm_ops =3D &snd_pcm_vm_ops_status;
> -       area->vm_private_data =3D substream;
> -       vm_flags_mod(area, VM_DONTEXPAND | VM_DONTDUMP,
> +
> +       vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP,
>                      VM_WRITE | VM_MAYWRITE);
> +       vma->vm_page_prot =3D vm_get_page_prot(vma->vm_flags);
>
> -       return 0;
> +       runtime =3D substream->runtime;
> +       page =3D virt_to_page(runtime->status);
> +       return vm_insert_page(vma, vma->vm_start, page);
>  }
>
>  /*
>
> --
> 2.55.0
>

