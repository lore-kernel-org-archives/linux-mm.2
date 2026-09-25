Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA99FC98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EE186B0088; Fri, 25 Sep 2026 03:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89EE86B008A; Fri, 25 Sep 2026 03:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7669E6B008C; Fri, 25 Sep 2026 03:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4599F6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:35:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0C36A05C1
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:35:50 +0000 (UTC)
X-FDA: 85251475260.25.54F6E37
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id C701340006
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:35:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vpvO0lHS;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790321748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TiarA2FI5/GYv9nr9lV3Ck7oSnVRWS2NuO02/gM+R5Q=;
	b=SclmfY5KpM5pip23DDEV2obBCpAu4VmFvPQo9HnIPGlammiY55k9o4sLkM+WXppahRYd3P
	d1vDDOphm2+qkDMvxekuioeMoKBu469wr/EqMEpAdnWfUwCbIuHmixk/1LjKC3NC1XoTBk
	Ib4ZQHe/AWG7XalMXZKC80vw/j39e18=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vpvO0lHS;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790321748;
	b=yn01SDwjV4u8wmP1YrebUqALWo2sBs8twQVcchDR8c3XcFh9tu5hidW/sQL9hiiqNopryM
	viV+rMABjxhtuo26poVMcIoKSQldjm1JsW/Ud1U1A0b8XnPBULPXoViOcuXngVRl07bc4m
	9ZUiHBdfzf7yEZS2EP5/WcSBY7vcCHc=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6aa13d8d9d0so7222a12.0
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:35:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790321747; cv=none;
        d=google.com; s=arc-20260327;
        b=f81FI+BaggfIRl+vbUt15R4ixmTDGSUL0Z5Pg+yaZ6NIVkYeT8GPIO1lrHftBPieMm
         a3GO3ag7MuJAfrowiekKEVrExAn6ph5RRVhRFxzrvq+61kJS/bFB+nGAvbb1ub5GoGdq
         u/igdKh4gjXhpyIZhGxzPX6Cc1p4jEEAQjm/ZV9ktmCfgeSGuQ9Viq6aWAW6r5btRgwm
         9ut4zDrAsA8wiOGBlouBlNA+xOWN5WusdQHOFi/UvwLlZYqLAiYisfstn9F7TCNk0l8F
         K73idTnED2BgcQ01ql3iQn5c1XLc63lPYwa3NHFiBW+XyDCNI45HBM/MHw2kkIp0iG9X
         6xpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TiarA2FI5/GYv9nr9lV3Ck7oSnVRWS2NuO02/gM+R5Q=;
        fh=dkd6nX9S+tx9nTv7sxr2NFMPbBymxnmXWjqaeEpwXVU=;
        b=SJS3yE+OsiFR6SThmAal7OjZ4vDPUsj08sfKycxfezJ8MXrFWlS7C86sXcZXZwOu9d
         v58/PJEHGxbJdI8dJJnuewHIzls00Qwfb52vNNdvp0+DH6iW2DNfBW4yd2/wqM0xn1L5
         8anD8jU2uubgzmBDoqtsU/2NwlIZcmIpvXr/vtU01ts8tLtnqPWUU5YthzJM8wx/QHGM
         lIVZhxw8Qiij3t1zo2HC18076E4neLsRm6qyS/gDv72FejVwNRoWeOX4+5XeX5rfIipv
         SsNrpeKa0urXI3uIB1Xpz1MUrj0CWX4L4jUUulv/dU9DyY7RoZOFF6ICzEjqQ1rrsuHQ
         GAcA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790321747; x=1790926547; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TiarA2FI5/GYv9nr9lV3Ck7oSnVRWS2NuO02/gM+R5Q=;
        b=vpvO0lHSE39Z3WEJ4BHR/T8vII+hpaYWcxp+etaVfbbG6eL1JifF1CMOwdiA/PHreJ
         PM82gUQfgcEyZ7dmBDqKNT2uGSVXKapwxta9KANUc4P5BrpmBpZk2+UEmR02vC3f7YrB
         iVZu8tUFwe+34HPbniuoUbxFvPAmuyVFhjZ/kQdHTAIs8l4AkawlomynXQLJmWzMEVF6
         4ED05mqvwx7kNfXt7xSxYuffsRJku0DKSXmygOcuiGQVouK0MaJINOTX/XyEO8Te1crE
         WBeChZnbWwcxqd/t8DCKtRnhTq6RdMa6gW1ishS2hyrdTmXou6jnhSH9gOdxgtLFrOIr
         O0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790321747; x=1790926547;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TiarA2FI5/GYv9nr9lV3Ck7oSnVRWS2NuO02/gM+R5Q=;
        b=jjLr4YvD2f4L/EtRwJAYTszVe+/oXDunZnPCJAAYPJr9OtQy6dK9xadfUZEHImgixM
         kMlsjWI4zf6sSsQGL6VmvYlCm9BWJbnqAYBbvf+K+JoQqz+SrWwjQIpTHnuRrH9DMB79
         DFo8+y0oznCD4oyfvrPPSIfdl5hSgriqvto+0d0u89xDE+eJzucjRdy9eG+EPi4FixnX
         oFRqbqp+kYwfBYZwhmIQaq2Ag+c5pyE4wmyicu6Bm493YsPQsB29jALSf1Srrml7uJOJ
         843X4kxtv48sH4CK6RfQmS7EVqJqJbftZ/u1Ae4UfeGZWjKykrcEvCcWOxSReyza5kTO
         2Ikg==
X-Forwarded-Encrypted: i=1; AKwUvBwq7irtCM4UopJb6wLKJwWY6Xk8Kultwzhu+yTIJBZxVJcaCvgRyMZVJ14NbWhSdqzo6awlMTeVbQ==@kvack.org
X-Gm-Message-State: AFuF++nba8iktKjkhCBG65DxlMZOwYti1UwmOHE2CogCP1+hD4PTbHec
	VBKjMuFlE696wDqUzo7Uun7YLrUUBIfu8G60Jjg1Q9QZnzyTp3Raw5gZrgMpn+4G2P9LirOvXsN
	qpT6LGAYIqg+kTuPQTEi5PsupSPJFFXL9kJsDS85j
X-Gm-Gg: AYBFou1onOcyjc9M90B/0UqL72L8ONbLogCoWBLwj2y7Gvy1MUULLnyPb/EkhWAEMZa
	S4hK6BnRv2AmkvmmUW3UM31rkqNmpSi4xabYcqCUoV0utSMSr+Sdw/pocBdj6Q2jxejyjpxYqAd
	DnQ5ODbTTHM5BMWQ68y4yE6JoMo9YCKsjREsS87H5YbTvAHeMsiyx/8TehiuWhX4fYn3pL3hJoh
	Lad6luVPf9ricudx+wtm4JAgOfdz+V/4zClWz1pShkGPBPHU6uvly8c7IYX5xSvGpb9G5eeCQk6
	aRnPfr2IcssJuSYmNcTsaXCXsY3clV1gkGn1BUrCxShvJ/PcgUVx2DBzckxixyXc
X-Received: by 2002:aa7:c64c:0:b0:6aa:e332:b762 with SMTP id
 4fb4d7f45d1cf-6aae49c58f0mr23500a12.8.1790321746110; Fri, 25 Sep 2026
 00:35:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-6-4583d8a23bca@kernel.org> <DLNSNQP7L4FM.1JZQ0GS9300H9@nvidia.com>
In-Reply-To: <DLNSNQP7L4FM.1JZQ0GS9300H9@nvidia.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 25 Sep 2026 00:35:33 -0700
X-Gm-Features: AclHuK_NuiQlFRW78Nf23QbG4E3oej6nx-ZjiAb0IRRSHloLT2xGmv-6NXWsN8E
Message-ID: <CAJuCfpHpo58c6eOPY_CvP+ts2zwXQEDNX2bohXd0CBANYWrBWQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/40] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
To: Zi Yan <ziy@nvidia.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Doug Gilbert <dgilbert@interlog.com>, 
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
X-Stat-Signature: wsdr5eqatnrcwbuxiouzbxr5ky5f87bw
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C701340006
X-HE-Tag: 1790321748-741499
X-HE-Meta: U2FsdGVkX1/eD+VIVN8johXZAVP95BAhSXM5HxavFhBKuoXOlyFJ66moWTH1Q0R5ycSFUnfeYiDtzejMVI/hmxA7wlZFOMpynqLfxI04qyK5sVQwW9ES8AKvodGLRgne2xCg1JPiJdCXsrAYTgIESIWKFEruOvN6GubCxKjfaaU6YOS6yhZdzeG9BjSIZSn9EW/bfmz0M5uN3ocL1wNAfAeM4drecSkgfnkHDD08TW4RQMjCuuWv9e1a7yVk1rujyAeYJe+7oGsiJtOIOIHd3DIivbm+Kx0j6ci1ouX8pfzgvrpjOrhmeTJuJC8mbHhBTvACzNPTEbUi3nMFIxY2E9+F6Qz4L+qakip1c9NmKA8AD3BWrSEZ81u1CTN6RE4x5BeRVPNR895CKOHEJIO2B1mdQ61GCiPy8TXtDkClFNSMOPv3PkowPZp1c4J6XGOuPmRJF/afSodS7W2Ck7EOwEcCofQ8IIuT3zwiTqn7t4RdA7fS8/wHWVZnowexCs1adVXcLG00+aMEGdnFFfHC6IVYa5hZDRfbdK8sJzV9qrlgnsIw/EbFoyay7rD3ApPBxaF0CI8OnBQghNom0dCJkQm7QYQCOz0J7FeUCMfYxoMOCcno3bVioHZadIQyLHn+7+oqJBYtkw827uZ09fegekE7U1HXw9W6tN8ERtZe5MZ/HjM/gibMWIox1nXuGwX4DgCFIgbmRpuOZmkRn3vxo7lyEhQ4ZHkYZhqROZfpPtgUr/oTdUXRr/2ZOD2iA9KkFS8XB1hlbfZIeO+9D3jVxJNuToNJ55arFWkglvUAFKeJtUtoSrEGlpCVR1vGvv0noGcQXds/dYPyk+ymH5DogVfciItox0GshUTE+VB+ThJ4eRReEfbj5XyjSDgFO/DZ2YY49s9DjpPMVGGYF7IajbyF80KzYFtfC0ghPhmHwdOQWkKylsFlYl8oZVvVBceYpJzkMi21+zCvtf0zMwc
 YFL8X69e
 tr3tHso27c0yJX1MuwFmaDdPFjwEst9lbddwPZSfwBp5qCWZCJ/0dYckbSMtbt9zj7+SIClR9Q7CwMIeV/yy6Mlw32OwPb5UJWGJAkK5xyspF6DFnaM/26fmwYhuvjtSjBs+PYHCpVSBKTJ4cL7J9OIy8u72pKyk0U4cWksiqb9RxWps37DqMtwnEFoiev6D6WU83+Ova5AwMe1noufgZ1ZO4apR5I+edwcD/q3PzbQ3CgRenKarRVXcxSLqgUOxYTzC6zDnzY312cvbp5jhFL90Z7jFHd5zRFxr4/4ChcEN3YA3po6wauMrCIC5QMreohgeLKk53y+MloKxwIZY9SgwWJvj0i+gcli5wGt5nb5P/qkINI3Yjv4fOTUdaZ7X1SY7IuG92PGXwSuQs32vG4UsD0N8IJNLtrTkUHgNLW47n0P+tN6MLiCDrl0Qp+IZR8hyD8HCaBqPLl4QkZ4uR5IHIakZxnRSrycNabCcPv4b4XCmLosZ+QZLWOcfRdTnLq6BUPbAi11WuY8fRcslx7MWRrPhxzOC7vlUSkhtQZEwiHwBo4aVvvovRAN//J3KfpwcHn+REQI64SPYTRPURyosyxaj0fWFQqF2nok9YfVTaYLu04szLmCF7aSS+770dPp/oRMLje6Xvv6Ku+2dIv+Ujm3Jt1c0t0fkXsnPj50oxnEU+05NkA+z+HIUxMB+ckwxxLyM/BlQQvVY2fgKe4WVbNVWauavTwTcoCdfEBrrvfvwdLxa6VxrocU942Yo/2a9dFV6dk+JfqO17v27Y9FU9zGEtVvPEfvOmNRK8F62c9YWvgtFAa4+3cLzRyxq7WpqbHKvIiXnjJk+NzR7MBHccfQArqGldjuimhfrw3TKzAoTOmnA5qi19Bbx3EvemZGhC4p/I2+DrwRY2CYdVY0TpDJJ7cG1W0Vil3NtdIEMNtHsroaHvcmHcTYkJPfuCPIUV9LbSuu+4viAif7wMG5qqpbqt
 UwN7pcdt
 qB9o9bIccgXrdEYB9sd442WwjV7WTBvZOoLqgmvLyQ7JiZiP3apHWWQ8tgNUbCeqxDZnaQbmUn8rzWl23WYJT1HPNqGOKZxraL/zUwDW8Qq8r8rd3UZQQxVtKZJ8mULXuFPpVLNwLWYjpIAeUT0RGKvWztMET2hKkZp8Kb9YFuJBAmd39UGMyOObm0MGh/s38qO1+TYNxjRCYQt98/aHKn5nw5A6+BTD586Pp1sM/axkaNm4DzeIegIv1SpaICkcUxGp9oYQWXxA4j2RHAsJQJSiGun9qkoFiFrV3J6vAdemKqGYi2y1+BkAhKl+rH3hxmdFBIcXVdDII9zQ1V1khvBkP+EcwCp5zuA4kgI/Z15LuaN25RClfENTAobv5qcymvxEqV9TN1VZwUSnvojb+6njAcB5VbpN/XXOt4eh2v7N7TK4BEqwc7ytGYPyJIU2Do8FMUFEa4OK35mUH/CPD8eIfGHbD3H1/n/5m1kpk9zmXgZnGkyyYv6uqDtjahmwoLLT+D7Ercc7eGuwKQfnHYJm8nw3B+kpcmWJ+Zybq+OgIo1gAFj67vdRFxtH6b2Csf38MTkpLxaD9+DiDo94pD0uEyqw54B5KikGfdQ11qjGbDFvbepa1D01EMZkeCXkgMnmg+DqJ+fdCXsJWXUF7DBJNYohebOF6TDRNHW6uza97atd0lgTHiddBKI+r5ZF8WVLKl8Z4/PGNQfyO4nEWfQckkg55+o4dDbo7cblHkn9EWVlmAoUywTNY8KLrkggo1LNaQoadnPbL6WL5E5SSbNqYx1qfg/QrACfXN2zGa2Vgqkyo2XUtpb7VAePcG0C32R3DqnVJJ1zGNnhg22F5QL9piqQtzT9Z8pJimeAIs0JYcvaO+BUVCye1Cp/CThJ8RneBrviP520/H7Y7vOnF1PQfROQCtXrMGeCmIUWlfsiRkVsJXBdrEEyDJiU93c7amwgI0Jr8bZIRSq7aKMG6wciOGoQT
 8bgpuNMV
 SW433k0UCl9dnWFnWjIOVXUbGXIxfkJUaw2xCJtoAe/bZ6kcp3quM3NdLsxpabuRIsWJfpniZzIsMnz4D13QtPxDocKUW4LjfyMo9iXxzyh7SZ4I0fPYTqzstmWbUyou4x63+Rfhm2jH8fDfFXJ7vqGavOmr/SasysKujgbojwdO8ZYg6H7bx6dBapdFztOg5oKaroEFCU2CemkyLgtA9kOoxG/e8hRa+Byjwcu9bwcXmEilB2J0kE+AFuxXSGiN2xJFUdgjMLpWYPJ6+5IQUVxjnQ7TMnWZ2ToNexaT0lYVwMxzDNrfZxXht9dpw7gml9/5O/avkyLIb0H2MmuVD/nj+i6rptWQxIXiowUnTeeLjOdJKK3H2gaZZ/b1i/vrJeka8/BrJGBsn63eFVt36a2y5aCyuq04jY6HDsYG6rDMlOIiA+LhOWj/AxiY6KDfOHAcVA8+Gqg4bxlWK+4JP8eKAQhdBVRvc3rNFj6cOPst7dvn1NbhApRkY0POtmMKVGrzAChOAojEK3fUb/T7iDwHFYHPswS5ZHfUeprCd/a69thVltfLTBfSE0l+hob5YbkDgUdach0ohEjks5tiOWGtmUo/20bwHGWvZ2Oq3/vRCIcGFNjRjOJqKtAHuk/3gSVYwG7DKui6eaTwMZGAM7YfZk5bwO0IV4Od4TMD0kxufzq02/Hnyh3WXH8ZxEVZKV6/fJ2lW+Z9kvUQ6M7cIfBlcPoD9F/wVkoOsq8PUQsoJGE5JyU/ChjVcp8b1UNLh+T/+Iqcw1EGiwTq9Jq3gzeFLn7yQPrAG4byttYK6pV2gW6uQzsO5OkJozetj8Op5Zyw5nls3wXGy4ncAJvK3rlkPprXiJjik3W5LEbpd6eacTegC22pnYISg7EgImoXyPsvKMiGB2ef0fOGFHe+A/t5erCvad6v0gDD4ZT3nGVYdx4kpHcZwfMTlH+A74LEEeOQrKyfqBPrxM7QepVuele/a8Q2h
 9zScoRJC
 8VsbPV8wictTVtbx6+LlETeC4STSPqVTy9iPYSMJMO/erNhcNOhe6kZwbfCzIHorRTF+hbtXXti0CXG0cugkOvXAsH0cl592jI0wqADPF9LBAjCLdotaN6BUmK18V8wwubCg/+7v5d75eHCuX3l/FaLv9Jhyf/xpFEZIv1VLZv58QqczFSQxofT2BhWt+RpV7dH63fjfCPKv0MYYLgqw81zBZsKRfRkKqzO5DnZQCWF0+qfwDFe2Bb0hsFWDMLHEbgVEsnpVYyVfOmr+jgcJnPabQeLbCz94ppMCjPR82WOuA7sgrOVb2Itxb4POjwHkMQocp5WG7t1Hh1fVESMcbCU3yNs7exVVTTWriU4uX+n4fq1C5o4CwNBCt33GLwPU1py6ge96e7MA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 12:30=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> > There's no reason to export the symbols for these functions which are o=
nly
> > called from internal mm logic, additionally there's no reason for them =
to
> > be declared in mm.h.
> >
> > This patch therefore removes the exports and moves the declarations to
> > mm/internal.h.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  include/linux/mm.h | 3 ---
> >  mm/internal.h      | 3 +++
> >  mm/memory.c        | 2 --
> >  3 files changed, 3 insertions(+), 5 deletions(-)
> >
>
> Makse sense.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Best Regards,
> Yan, Zi
>

