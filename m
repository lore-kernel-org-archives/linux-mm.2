Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D94E1C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 19:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8C66B008C; Mon, 14 Sep 2026 15:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8331D6B0095; Mon, 14 Sep 2026 15:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AD926B0096; Mon, 14 Sep 2026 15:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9B06B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:57:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE95D16024A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:57:45 +0000 (UTC)
X-FDA: 85213428090.24.D936CED
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id BCCFF180002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:57:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=PHNlzT3s;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf24.hostedemail.com: domain of paul@paul-moore.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789415863;
	b=cvJK6/QyeOEZyHatUEdsKFAnf3CDxsN1DM6ah30ML0j07V6UjyKdSDJq3tCKeglFID56Rk
	BzKFYceHY0YYd6IC0I3GPTber6ylrLNYZCxrVWPxp1FW+I7eFRk1Zpf1ckt/AP5JIODcl/
	5zofDz/4Fsly/CCZHEuLlCtoGLsAE3Y=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=PHNlzT3s;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf24.hostedemail.com: domain of paul@paul-moore.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789415863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEa5EIpxI31VfZhRCWTdUVuFxMmPcLfnD5/j1cH2Le4=;
	b=qI+2aifz2fm6/RAWM/UpItgouro1wHvH2UdAms/IQYjbZCt8P8TgAqNjN7FbdWxCqgcIHS
	NBuuH9lmNU9rAVv97eKAYTMMRBxnq7qVSzYSIaU2/mkI5xMcgBq7ZLxcu5H34gjdqkAzGM
	bISgU6+kl7E4TOeOcBXRtDnv539i8WU=
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-86b90133ae8so1980683b3a.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:57:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789415862; cv=none;
        d=google.com; s=arc-20260327;
        b=Z5Yz3Gr9uGhnXwmkvjQMTrwcHWWOfes+AUewcJfGhrfRiJlCMH2wXGoKvyjn48buWX
         pzBYf+k8aZ+hpwqPfBzNKaIyznMzRU9k0z+p3SkqUhWCRHt4H8zU7CH8de8gjfpWAWpd
         SXOwE7U/cQB0Uv9pEnG5PYg4B/cepelUadxZyEaG9u+7ylUK0kMoEz+B4w8QlIcJMcJ/
         ELPb4cshju5dQD2a1ogjsV+5OiApANG+mTWTJUap02KDpDnVvTlv/lkkG/rp4/F0gksc
         Lwck1Nd6FH8LA3zvNrqiERa8yGplhCF4w6x07/BnGE8Wdizx9BgMJ/hsWR0GAOAQOjGD
         2wBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iEa5EIpxI31VfZhRCWTdUVuFxMmPcLfnD5/j1cH2Le4=;
        fh=cg9gkz8YV/O3ykPNTN6tSWZ+b8WPBgnWfn7kNlSMiY8=;
        b=Uv9DBeJ1E6tEy+PdW1moi46fErwgHyF60QojCyp9QijWjNWiIVUS/wbAMzQKPPsdG0
         qNBjdh84po2kRezquiGenyeAVqOI+y6qva3tRJD6cRWjduh27oI779WBJLeWSofcLFyC
         aXhMgSxv9c6Eec4y6grgEai16li776zw1ZRA6XsnkK4lWrxL0SroyAHm3thuzhcwVv7J
         m2qWnMj3MD5HtmT2hKSorO26ylpNomiadSwpa70nz4EawdqiZALwW5hMkRyaBFrVb8hp
         tkGznKSplRol7dXCJUUmYdlfUEeAIJHe4w6DdvPTRMEZgs/t//8abqIbNnBaYqAJoulx
         VxpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1789415862; x=1790020662; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iEa5EIpxI31VfZhRCWTdUVuFxMmPcLfnD5/j1cH2Le4=;
        b=PHNlzT3sFbYD17dtn2Cc1t0HM62bwsuDV8+5NRh1BsRZlpX9VXOIzla4zk/hPGDrQ0
         FcsMWt0cZLFYztbzojQkgenhhzQ5a4Wnv7B5j2kDP1Nvguk0ZMh0pjDCPvghu6vn/SEa
         O/9p9V2NLZUWZnaLkq8Kwpqjg+Pcq2PGBCU6htvrvV7rFbYzjHaQo8j72ZZ8kuWJbsUc
         zG2Wcfd/QHuifvBSGLDKwaGp4ah/kexv2Z9Jgx8S92PcZOd7BzmiaXWonZ0psxXEdSEZ
         nvixnvkgS7f0KzirNMZ/Z8qGOamLoZ1lAPDWL9BZh7BIKpOPjGQMZS0OKtxtA8SNkwiK
         r/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789415862; x=1790020662;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iEa5EIpxI31VfZhRCWTdUVuFxMmPcLfnD5/j1cH2Le4=;
        b=euw50OegGhYwcaZqY4rVHZZIrFWOJb/DQ7UUNpK7txFyQq00YfbX4KJ1EHFrtUlfbz
         x+f83QrkkD4URqA4kqbXz5fjxTIVk1WP71tgG0WLMoLtemy8qkeDoGW1dpGU1ky0Zxvk
         ZtouIw05E8Cfg1+FYbahKkOADqq91p5Npl+62figCStP3loB0xP0HpWbYNZTvbHmVBSX
         mprreiSDbw1kwPb/995txPtuV0lWIGDGi1vuN/iwppvEyVjBriSbfM/hnyW/ylKR1fGk
         HsVsAXTlb7cgqRYZlvjChDg8Y2ZfJFcUqX/E+fV9gOfRhhlarwO8tzgvCkiCeDoB1vK2
         W2aw==
X-Forwarded-Encrypted: i=1; AKwUvByxnTuYcR/3PHtC9V67vWq8WmyJWpwU57TrM5lvCfqZ6p8knYfYjhOzoxrtm9zJW+t8B03D/odIIw==@kvack.org
X-Gm-Message-State: AFuF++lOkvwM1aSpTYzD7ghWkbVpWBDZC1UbtEHCu/VZD2CFGbo3OPGj
	Wkdu8TV2Gwcbvt9wt2XVaUN1djeEa9bJXrKtg4Y7I0yGkhFwDMleniRiS07oD/giq73PFXnL4Cl
	WBCp6XTkqHW+WzIzKgNrC7PQCvNQJnefy/Z46Jtpp
X-Gm-Gg: AYBFou3BAuW4RdHDtS0exbNpG4zbM/RrRsbKeDXDoBfCCOBLvCQrwpK3Ot1qclS+BRj
	a++woX7BYtWBysr+jxgOLmwmhRBNkzKpWsEVHeZcvOTpa5HxRtAmxbyAQvS75JmcChnGVKaZ4JR
	yrubRRuHf//qQlH7EXZtdlh28eXx0Lh+IE8tZHyjxcYD5/l5HNV87rYNFpQ25gutdOR8NGemd6m
	GDubyIVyN5FpFKRm2Arp2xWrBdruN4rzpbKpM/EJJkHtf6Z+4BPVkLkV8pEV7EpDxuBjS3BC3Vm
	c5sKwlzaqeMUEVA8t99dg4u3FC2d7BrW9kHWMxZRaytDCQV8WKEXZu1ywQoKPN7t0GaUoYNEdee
	0h1iMTEsNJlA=
X-Received: by 2002:a05:6a00:18a9:b0:858:b809:6ec0 with SMTP id
 d2e1a72fcca58-86f869a920dmr8896742b3a.23.1789415862342; Mon, 14 Sep 2026
 12:57:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-12-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-12-7d9781ed5361@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 14 Sep 2026 15:57:29 -0400
X-Gm-Features: AcwNN1XaLRK0KaZAmfcRvdaBSkZOdh14LF1fb-xWULoFVhBfqyRklsdKoWBmLag
Message-ID: <CAHC9VhQ3TwdGGH6YtVyMqJX4avJwsadcRvRhAoUhCvJEHk=i=g@mail.gmail.com>
Subject: Re: [PATCH v2 12/40] selinux: reject writable opens of policy file,
 drop mmap shared/write check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BCCFF180002
X-Stat-Signature: q8grifhp74zfwybjok9898t7n7egctso
X-HE-Tag: 1789415863-120060
X-HE-Meta: U2FsdGVkX18bZ5T9k4rOcc1VMu/O31FxnNEBoj9Kx/w260w5loVPqnBzNrlMytrHNUu4bPrjnd4WYeknJSIHdDet+3/8SPCG7Bf1Beu5OY/72uZoN5Pn3KdOQ/nQ4XCoMuxsdi4HcVVo4sr4P6UAdaFM8RYMpuJ8I19cQJUMrRLRl85k1CLAIxYM2B2lgBlkHekdAd4uwKlj2sWgwzn9mfyY5/5VFOut6moJmJLDhJ/9DZjcGgVlwWf18fQ4vWfFZFQTybaxhLQsz36iM71Indd+3HDvsb1kMMG/FJN3Q5Ye/mqbLb06ANFKwY+VtZSctMekxBKtVn7DBvGOxjGy+s3Faq1yihzAXc5E16m4SEMt9m1DztUxrfYnTSx5gDLxvvlBWWrUhRDKTBUmZoTtzy9gjR/itOVOJx4TJBuFEhCmNvjdK6RQgyPCxCud1iz9OOp6g2p3WGlLAHBmRl3mVkTSoF0/dryOtEiOtooJVG7JseR+ySibgcqehIha4MlcpaFDYiyShBRgtxi1Ssts1LON9rpl/HD2GTJIHhHCDC01TMbQwuZ6RUmgtue6iAztb2e2DSxPVxy4cDvyrKNLQyGLCQv1IjIu2Aj0MTM8U27Gi9PYkOUHJsZ/N9aBOTXpZ7SGS/HgZM3Fo8JG8klgSSHSpJCDVmDBiOJtQB88DjKExyeHQn4NMLBtlN2CbO2v2QKAlf7lVmFJdoQOB0bplmBRkbpo9cuchjI9gVNODopzwCB6nD5ztkh2oy5XAZ2p2pVaOK7wrV8gy9q5Z6J3en8N6AgkjZor7QzVKCGhjpNa3PLWRCqnEPBWNv6OsGuapaYwaWdvquARYXOlsfdFDEB4OCE+FoqfPYfsV1SfOh4QNtJiFvXTNrhSupCu5u72fZArjAMjC+F2vWJacSQrqrWm3Hiv/fXiVsX+O6ORP0rd8/mBW2Ra240h6mx33NULjPrtByStX34XCnt6MXu
 i4xVTivi
 Fee5zVgQoNl1mD1x8rjf4koqLKW+nSwKwwqIdsPP16Mw5eouEy3wKoI6d3KfxlQzAQQ+TpbxU5Iw+dnMtI1BxtaEaMEwlpdgMpGepZMhCaO5PTkuacqRQcKTozMgvkFe70DbNLK0PUiCdXm/HySs41b8hcb/1k8oeOXJgQmE1KeZUh3U7TN5CVVRxRd9WQAMy3WMFeFdPukxHpAqBCQOdASVyw/379xzLw9CUCPhG0vrYKeeaQzhS7Q+Mt7u3aGj3VFUPhEZ6TOT4xtRUseNtyvhjiLSdcRh2uaWjCLJ6A/I99GXi+xt0POsmlqLjfbnnAoEawAYg+GV5CBPdCFK+g28fkmM9l/bvCFM+bEPgUM42Wbk8G5YGDiUEzXe+M83ZsQiY8l0Dl51dmHRMJGgN3Mge5iSwnn+CYllz01EnnV1/M1WYFtyMvwJdz6UdMAIGuRWmuCFlAkYBDRB/giktVqTBuk89up7WeFQ9sOXpGGllxjvqSO7CPyWwy604Z+ZXgPOTVr07NQ56Zvw6HHa8frqNMxVUsmxrfb1/PLMgK/0HD9o7Q0dWq7WdJPvtRgvAGqHP2B0Oo3MnacUdtisz6aGYLgelfTgDucqwGY7hhk7j86swix6V31aCUwbKcHOyRS02jq8/oRzcfPElslf+Cx9gtz/Jv0SnEWnJ2IQYXq7sgtPE3cItSgroi6692xBRMl3aiMMu4D1uK2DSnmrSc5gU5T9j2MnMYCqCg+lIQzaIzQWFGgkNJQUhkKRS5PolC3afRHBnPsLohsunJ4EYG4NDka9Ae9veNh5mkZj1QQTs2sM5n0Xu0J0cXrPGx2yM8gXEWaVOVr7GGGjIucdyVEzZKFT7NzU7UhAYOQXae/yrFo3JuQPtwoxalTg4zWmNfRFyEvC+9cjXzK776eLr6wN93iZTOiyOU8b7EUHrPyAKiVFvdu67z7jUgeQMZD1zQ0vaqBPce99NqOntR4wBlAnX6W22
 AetG+zuJ
 hiFMbQZYwWy1P2wCsCm2qrY4YpQWglCNypZUeDvS40Qt3LKAcE4H/3UiGKQWLKxhzpryLiug7AX3so8NJCu2BOVufOh0cJPNhk7xU7+xz3gZuBKJvAefAnseKlDj0zpbWPDxC+dRFzwXOtc/4qxNuWoDTlx2obm8+K7nEfsxAtEE2j48YYDfIpnIuZoOsTHck3ICj2I2NA2KDTtDduc2WdRDrKnP2eEs71pzRtWddvp1jhGBSnLGBPhfY6ri+K7BFSs/IfPQlYxKXC8EFTA8dptzVNyFUzgmNO2u5stsS6uZLZ38N3sse20SB/y1HOzju0nalfS2YxTOBpgqFyGprW05cxjptpb4zxF1lHETkxHtI6b/96iCVWGImcOpd9X/l5zMOY5T8mNJnbFp2B+EuqK9UJJoK9NenrxmpKgLb2RyD27aXexEysiPycpSw3Z5qtQkNyp/LCGxw27j+isCaakJnCNRVOpZHPydwcg9QMIJED+i1lG4+xKSwRAsIx1cFxT8ebB9m5eB5r3TRIqsAdC3ssDnKrLudN+L5NdOQjazlW0eq8T0wmm7VPVSEakJu0vMfE+urSHSgCSQv+qX8ty54SDEroGozT/J1XWB0Lfaq0ZEIz4OVUHPyPwHHylupf49wYkeN4QSQ0eCxoVaAcHGMZB0A+OaqmFjbRgnQkVIYMO3hl5IsW2xSI3BrQzry12OvpFzqYrwTCF6WQ6aKrs2C+UMylo2Pv81oTsz9dWV97ZZCMmgEiW0GLegHOKwodEvhwUndNEcwNmmlpRC8wpLeGUmzXLLmE7xME6/TgxIqVafHQwipuaIL8X6AEtDq7ytIEGPK0H02r/ZZe0C9eEb2JqvjNESAcg/Lcj9JyroYkLJOi8qNFc+Jx5ulEt8i6+gxUp+XEvoaIjKt4L8uYjOdL3kHJ9X5u1D6oPxrf913hN+Tq+7q4UdULsUo+ioX4gW5gcLExGGtPahcj/TQ/QnIEw8u
 VpJtz3zR
 l8qP+LE56GzgBuXqD8Q26EAvOE55uD7LKE72+1tgSVQUl71Z6CTOVK0N5X0NkTr28JhVT5oAYtcXJ8jPI2PHCQBDc46/OwSFbrcbod8XadAhyaeIv4mMPg6JIdPRjNydN19djreAHxzlkH9X4lyunc0fmPVHXyJki/rAdjayJZVGPQBWi6DqZGddoPRudRmVxEzPcflGzeN71wibedHJHPxqlYZhNFgKAe7rNtNb22UZ4kYBaRhjI04X7j+UHKr35b+qxg4xU6UO1XWAKTZQ1DNdUx+FUPb7+OmWDmSKsPzHBATvkOnpBMlEtN6EK6/BHTXaNRBYTrYw15fZPfoklUTnjtg9vQR3OBHqOUAfUeSd/S14nU6Bi093Qi9+a//6o5R+J4blb6kXP4Xcn9gsMgFtXOfjut6/EocHYUdbdfl4yKAu/hUT6gIDwZGeJfaVe28EoSRHYLl/NblYvIaZnTl7ehl3l6R3larHdy+JQOw1w6AKAb3t5YkgH2GviggULp5o488oC8ZDkdyvw0brJ8dT7l/8G7pfH276jogeFRLbUE+USq5TCJvOW82gX3sD3EX62oQC+ICicyU/UUPZnEuwCA10hlE8GkQDz3MNqGX4hPjWkmhFCVw6wXe0Uo0RCP6iSGsstwWEs27irQcaMiA0hmsXfYeOodF/Rg9uIGQFLLl6dzvxowbU6zKYRGPUGafMB/jsmP5cX89z/NnnfcxshvykvDT2wEb7ViuRRKIm91ZyFKN45NK34U4c5VNIFRtHQjSZXgNyBPtUxPdDIjha6cApxMzxAYWHQjcWPXYPPggxDNUa0fXQ6IEu/vicr9w+KbELr76dGzm9DjDAelOy+vAKGxKg2D6hVZ3LSMQVr9PkkStijh18eHL3/1/r4S8yRTJvPfwEZMQu1NCeFoiqm19OrTtKVSbt/FcmLJn64ER6IvCXjL7BhgUgbZj06QsYewr0osPMGPKbpB/fK536YFaTL
 4xOeo9rw
 F1iItBOVCy+T8al/7l+chw615ERI4AQovXQ3Y/4uaemo76e/CVWZ4BlFGOagkSqy6dPkvoqwuoB/f+qW2NiF95sa2MOYNZ9vSmnZVhdRln4y00hhPLx7IqUu2wz22Z4a1sJFL9jqTn7ZYrGTnmiLK7PiN/+Zpj5tK8XKB40CSYky9Iq4dvT3+6FNZa1eqO9pLMnlsvSOAE20aF7d/Uq4VFAA7dcqBBX094+sHRN6oe8lmXazn9ObVozEuVQxXW9pN3dWLJ0VVLWYgkkVzcvOIAbDE088G836FUwmVxe86oHZ9UwoZuksClpyqL2nn2n4LibwzOgPXG7CCxO9aZKTWA9jrVL9c/bOHTTU8xsK/ZuH4hSb0lCXO/Dwo1G6kn49n567LtODPdpZS4R9DsyzLfA4F6fNXUfnE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:05=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> The policy file has no write method and is exposed read-only (S_IRUGO in
> selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, a=
s
> kernfs does.
>
> The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARE=
D
> check in sel_mmap_policy() cannot be reached. Remove it.
>
> This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that =
is
> neither a PFN map nor a mixed map, ahead of the core enforcing that only
> such mappings may do so.
>
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  security/selinux/selinuxfs.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

