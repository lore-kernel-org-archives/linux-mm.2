Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBFF9CA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 18:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1E226B008A; Sun,  4 Oct 2026 14:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5BD6B008C; Sun,  4 Oct 2026 14:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4646B0095; Sun,  4 Oct 2026 14:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98E2E6B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 14:02:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F1A6B1A0BB2
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:02:17 +0000 (UTC)
X-FDA: 85285713114.12.CA66317
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id D88BDA0010
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:02:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JJVmz4dW;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791136935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxl6gThguTjmryCDwAa1VxSTqh72eFueCyhgsTktke8=;
	b=qIqp1MQVN/qL28yX6QCqv+74gBwsPdZ/sokXYnoziqNfhjn0zjtKWQZ4mtbQKyT+C4sitN
	BYVRD1HqW/K0G2soNmTfbpW1JFu7i/Z8Bn9plSvBelnVUXPyQuDj5E5VabYTRSMefdRjg6
	quWCAxNyDv9FxjORHNQWK+0rgyCgYbA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JJVmz4dW;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791136935;
	b=hNMfgGuRXSBjSh3+RyyXRli3747WjwFZxQVTl+DjHfxVNS0DVK7viHY/vt0ab6bNcIzGP6
	3q0CJUVaavWkKH57n3qJlmh2BnrTwRgVttJ6olLnNdC7AiCmwBUps+zBMEM+AD5pioPPQb
	Se1ZcbnjMx68d9l63x+JkrL8xEpxAEI=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5337c7b9937so262821cf.0
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 11:02:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791136935; cv=none;
        d=google.com; s=arc-20260327;
        b=aW4MDV9iU+z7UBOU5X1+T5XLnb2d/bWfqRwmO37cSKwPbHG5rkb9SkYvAeRpBcGbNI
         SjsenXH23nZ/qa8sbmeFk9UOYDBF3GJNIQ7/4XS1SZeHR746BRcpuo/OyjGrxyEBvk4Y
         wRMjhC01vTP4TRTDjpEBpacZBtqy9SlDNktMYJCXKSb72gH05TCyKv6jfz1UNhEiggxN
         qPYktvWB+7if59Q0e1bfuKrIi+2koQlmy5qndf7OKWxrYbrB9AS6FtbUrzdOVRVTpIvj
         pDmdqaSsxYB8htbxdeBVIoC+aq1e0ma1Iru00VTD+b7mRKkyuFOpNQkRhEbHIAjTjLZp
         0CsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fxl6gThguTjmryCDwAa1VxSTqh72eFueCyhgsTktke8=;
        fh=uC2R5oETiIzcB3fAmyeerxw/GRuTsguf/h0lmncs9D4=;
        b=rEr3fQxO4u4/CZoYJ2rza7cLAfn+vWRAlpTmKHDbAWGyCafJThz2/wCwk1baoFm5WK
         msBBtMsVSqmPY3lAXPRC1i2PZTodIG9VlIXgga+e/Uo8CuQf/PYjdeax6BnNhCpn99q1
         R8ePrunbEWINbtf9MAv+Gxlp9BETeOKwlvGyCSEticutpJXyIaL1KdqVJLKwW1jll9P4
         qI1xLU30CoJDJEQRweE0zPuMOblM6jR65Jy6Q9mXULnH5OU4iNvLUEMMSNKTnYh1OT94
         SOu2bBcADSAoiyxFARtM5Lrx32khgb2zU8qB1UHruzPPHVuFzqi1d2Y7B/yop6LF7wKH
         JRNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791136935; x=1791741735; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fxl6gThguTjmryCDwAa1VxSTqh72eFueCyhgsTktke8=;
        b=JJVmz4dWdTJkb4ArKPnMmceeUGu2a4fDIgDGrm/8FS/ccXy52Qvw+TJSrJa1TOb0D/
         Wn13Cvl+Y4BAdebGkhNJivGc0drBnOh9M9NTSD5meKy1j4t535DKANBVFOS09G4ulQDG
         e8ts4ZEoxzgM54hjFAQ5Usp0QfK8UZoa9gNhOChQeTYP2CdJPFHGQKGYKznuJrkswPRr
         olqpWleWPJmX54Cm622P+Xj4An0E7elf63wY1lTQo6tcU+t35WC0qx5QESMUVHG8CDpd
         oc6ryh1KtSNb53X+INRBwUrWCdeA4mBTYpNB17HP7crx1U8GTjU1hk/uDRZPQBcu6FJu
         Jemw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791136935; x=1791741735;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fxl6gThguTjmryCDwAa1VxSTqh72eFueCyhgsTktke8=;
        b=NMJt3DFZrnRA2PQFplLyQOorLwy9uZNJ9zRH5O2AM7S8ONPz1fwm78dJnOGlFlpaWE
         n/WvppBcc6JUtcw6I2KLJ7+cz64gLrJhBmM/9PaToaXgxakd4rcJyzaKGTC/Ry1Qp3Zo
         K8tpvMkWlc1Ll/r18cVp3QbZyO7ib6uRMzutyK35vLl3DAJzmckNkutw3GlD90lq3A/D
         fV5LCWM6EKKfcZEvYFu/gCv4o8TDfSWlSBK4NCb7YrC5H5845bGvmTYRg542AmGWEb09
         plxR5Nc8r1zaUraCenoMQvtD7+IFvQIUF+4gctw/xW7s7UJHc2KTZE277da4VnKUZMON
         I7rw==
X-Forwarded-Encrypted: i=1; AKwUvBzgQQQKnW7QomQq4VfoGTRcnKuGD/2R8KjdH5rF/zwljuaQ7Gg/LzMndIAzsYAlbrvVf6gRVo6Wgg==@kvack.org
X-Gm-Message-State: AFuF++nK+DVSrhwZeOYeQ2qA8WBejBupPD6hJ99BFXjkHD9dnKyn8Er6
	yoC/vj+QRHeAsGT4Ia/rTO+uDFnAXiw0Qp1MZl/C1CR2yAn8W8HO4aj1nGP/wpoP3pgjpbIe6Gd
	lrNuGihBBbdhJ+GNqnxgEjwuSQPrCGdnVUBm1p8u0
X-Gm-Gg: AYBFou3JQ880XEIvCrb3eY0IqrXZdtLo4p+TlLMQwzr91Vv+kSStaAFNM7ZUoa7dvX9
	0ButIFfauXqCYCbxbkMPbNyJwBmJRT64qJQsFU35WIO70Dlguu2BP9hX6/OiX+77iBPmL4cMEDK
	OPNtmnkSPTKNrtZAaYzk4A3K8aqMJFjqFE7Ao4+DTnk7dMvjcNjBMYmGzqfl4LUAihWTy9BZnHz
	GUzAl2Vb6QA2x6GcsfeB9XSW8FpO78kQzTJ6Gsyu4pReiNaabKpTdndMbFOMwQyQHRD9PGg5zfV
	oqIrLSB5hVBUq3vY5QF+uvNVpQW/xT4/2yNPM+sVrrbpPA+yESp48REX
X-Received: by 2002:a05:622a:1b20:b0:530:e335:4ef with SMTP id
 d75a77b69052e-535113c3cb6mr18023261cf.2.1791136934142; Sun, 04 Oct 2026
 11:02:14 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-18-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-18-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 11:02:02 -0700
X-Gm-Features: AclHuK_nOqMX3djeZOdNLjNPymjaWdesvnL51eoG4SJjNhtYox1cB5x1yziRAMs
Message-ID: <CAJuCfpHiaV6uDCfOMmHJ4tPosUBPRMUF9zjrB0fkCWZG1umG5w@mail.gmail.com>
Subject: Re: [PATCH v4 18/38] fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO,
 add VM_MIXEDMAP
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D88BDA0010
X-Stat-Signature: za95agqa8w85cs7yempymwo35yzbjcwz
X-HE-Tag: 1791136935-934736
X-HE-Meta: U2FsdGVkX18Njsfd0FJGz5wpFsvc9MI5J8CBX6wUoS5X7OeIW0oIBCodrr7Ag8X6dcifG8ta1sTRRkFE8/4eM21A/wDuX6qAMQn10wdn5+iVP6UeFs1QHXUsWDVYyYYzGlWIeD1IWS4FTGh5TlMAyjOVbpRwtlTDIkGgoDCBvQcCUq7RFkVBv8IyMRGZj0k+8lBTfXsJ7vHOOFAjvWamDV+g/p+E5VGfGgHufAcOF4QPS4YLq7HwcANkITK1F4iTmLLIbek3Qfl7ca8ImJ3g6rt0+TdgTqljUpLp1wbHgBPubT94gxDKEFph6tvxrecQz+uASO4l9jAwBWf9iaknCWpbY5KqYKRfF9XDBH4ze+N57AhPs5vBS4SZk/67C1LdHBI2eW9Qp6XKxup1pdSl1iEhS++ayFaBZj6nDTaQn2c56HomjDdqUSxHOKI6f5DVI1MkPeQvrz7mn4l8JjINXDCEC+ynjmJ1XFSFKU07N4OmdGvr60UPEQFm5h3/5sKb+gsj4Fdg/76331l/xcv6UjYwyanC+8Ljlrw1VBpNfEGbAs1tKe1XVHdcWk6o+eNE5h4+O9WKWboTkXPeFhIFrETw6+kLpZlktXZrbQ4+EP0o4kP1wbOd1BNqmO7tkX6qr6NgCZa+Egk9eFsSUrT86egE8kFWbnET2Iy7lOTgbCqp+yUyLq2coU3eMFv/1/e0V2VBpx3r3rQcjnGWJm90oz0C588Z0j2Be+6QLO1mNik6CW37e3iMpug1NSzdXosdvGXsjYLyR/n/Wdueey1E22B6dmrqwcf0RM4/3CSc4uk8Vr2iAwjxM0nBX3uVl3MpvQVA8vXmbIeSW6qLoeTCgkI7vPTNgwsedmzhMRmGU+hTu0sy6AemEl/CCnTPn2hKVfPHU8gMndVItDyX7NyG2sRytEnFM2PdKIL15wlxuT2bod7D38ow2AufLQkS2cr9VYSWCmaSqA7CK+3MBLX
 KNMIv6+g
 /Eq4amGwzfhtHD3kV5CxIyNJSZx7gMCdvBqIv+oGLX1F1AoKSpFEE4eT6VeVC7sJPW5Zllg/mWOAVkTxIxEAK+EcJ6aZqqJEMUaw7cxk2xllVHy8w1krqKfR3IC/K958k5noOTTtn5fqXihSIIsHFQO9cVD9OKA1FC24tUNt6L9pBMAHudnNc6skZ6EUoMqcJjJ2dFfYeNxk5qJx0hxdTBYIx0aXN5o7BxLeGi08MUO4jcLXpeopTULsyx2fjgwcGyccJ//dr+6965vUfgaDsdPpi5mg+RdzFILuu6Tn6LxBRPdOxDW2wNO4jAwvMPalJyzKwnbvVX8kk3ZiA1PbkFaKsgUhGkXMCSMGpHWsrikH7cMnzb0zMbrfUF5FYZ2ldIBsAYbAaPtJFj/x0Ss7Ol0p5Wc7A1FBqZHBdfKR8NJ6srWbabjigE/0Q1hjm/KPVtGqhkQaBfrDfSycSpLEC9tMHAFuO/900tIOP8ILPNsBs9hsf1wyzUMNYH3DZTFN7OFjQ0TkdB4fTljXxhu9O2FyJB5EAfGXFR3jgULWFSNzmCaOc/oThNoCYZK/N9QsYFHqsNtE2TVcAP3tEdbH4grBNLJtp+rkf+vQyFBdmnOzDMt5ulFDRc13Wyx/gUPzPqqBb+g1lDNJ90NaAwtT4w1+rD60o1+8wlkohKK9gL77gYwhi//9Mrm5gsePyEYEDmxSaRpKNVdpCmw9nC/GI7aREDA/g5bPJMHJhpYKcfBLqGrimGqpM68APQLU9Ozu25JLUiSC6i/mH37zCHmfrwmgx5HY9E6jSiFSX4uR0OUyJ8AGbBM4Ob9KVLG7R/HkF8jqgSnsRR9om9hHfLDJOPnRxTmTWbLK9iM2S4j2aOMRFQWFlATERWsOtARVvow5D6/28vf0JZBKhnEMuEjvRDytBF41czvnOT5tTuzm2fO/qRcuBrKQHpFNoztW8G1eSEo875eMztvAOl69Xy/Zi6gzcpM/h
 Y6o1owcB
 jCjWPjiijjfzffok7ADMswDRFNgvWX6Lo7R+VmEvZEvv20XFBSg//b77Z9FfCKzS6sN1qr3lKHC8mmUjQnHHK/ON0+8+2NA8z8Gx6j/RFbekvfR7esy0GxMv0aDTvtA0mjx2lw1P0CmwJtpzdML4GRp98oT8vboXYWIdqjOPZBACBXwMqXZ9jSRpk+FetHyO5nwKP3T//uh2fk4B5nT9hMn3lMhB+QZqm+6T61w4SHVYilvdkOSTAJLs6shd3sKihJObu0kzJAQswQ526YgO23EHgcYpF8AnNJen9p6L6EwmpsZmocwvpLGegM0OrSLLJNdVHokIVhpJ0IPYIaBgB0PunY10DimvU5eOnAX9EZyPy88Aol9ig5jwvdNlMuOuuka90qfYTI63Z5sUvYu/3oxdAmNiWDWG2/GwkCUjtf9eCdkf02AE5BOxVXzthWysvNrSpHV6eObtUB+egFggyhyxaMBmlA/SOoIY81/sAJmWewXyGLN5sjl+BXFA899wbz6Tli45EBaorghCrGvyLaX313IknmT9Im+DDwC8Zo5eaCKJoMJhfQOmdObbAnvymjlFbs5+Jv37GKdlOx5MfVaar0zMlAbUPiTpvuYObJtuKs2OUHEVfzT581/srhIB3VzO5Kw/CxwPWdlOhIUvW+M2eHNDPXk4Dz8hVauL1bqfh/XASLG7PAilWoWrs+YF+3/dV3W+xofHdU6Rs4DtY5VViSYiU4blkehlV7LIUTjJuFJII4sfko89E0pIVUZCO3YNS1f0kamuJvgusgGlPqduQjiO0wYX/wpp5XvXav0a6vsTzEVZhRmSONNEKI/QCNiU9vj+91JBMJs61pO/RsKSQabYJNS0YRRtmXdAVTLSsHc9uWZnrc1LlQpFXb646b+RJlFBOqV5A4d53+F8h6/udkob9xWZpq05tCiUpeEcHVwB35D4tjvhdL3VGZU7BK9ZcXob4avSaCTJ12XxCp08HVj2+
 sqKbcaJU
 N/0yNbOCzJiVJEujJ6+2/3itLpLPO5G11r9v+a3hTEf0nt4DgdiyjLV+HA2ANA0b7P54e5yhxLWMxdUH8o5nXqY5FzP/v7GZLPRvH12aUAimacP8lem2GN2dgb5YhtwTYGkOnmXlQ/36TwWdB1I29Qbt5mrl7QwBd99UE47CZ/aTBTYyUAcsebjJiwZYZnLWLzxsAcjUqzcSk7b6MqOJFNgRyr2T3r6RCK5ZCVzBETP0aP1qKBTDczmC5Os/mQPdubTbuZn7Vq3ti3Sv9hzwQSgPOMlINwXC7PWt5CL1iBmNJRMZSi6uDMM+qUD6+0kbFhgR+prdPRBt7NT/H7tiR8HqdGZ4Q5WoyjUYa63Ccpn6njb/pq4R4wS3LB6R6lFc0Ry+4OF8a6pYn8kXj5Jmvh4H0PraLEiDq9C7yvbTF8RZs80jW4YqSjpqL/5/N4D9UCDgpuOBMnlAuAxQ0qLWuygmHafdhQlSkfV9Tv3jWZy8NaQQ/G/w3gsih520P6Nl/iKfFb4y5N9Zcc+SM/ucQUPXaKVfuSS0idstsz3I2IeIiIUiiDLtexVyf+OEsqmHjqZ3dVfn7njTPHSFcI8pc6YgxuY3BF1hI3uFEdu181/iAiv8A29LwqaiionkAaCswIrqMwVyvla5hs/JXHLslOegQg7I/jtf7NMmkXmcqT13qZ49cTYgenbf5TXPFUrdrqlaDIB5bYmk/Oa85XHQZNuxXT2rS9nMuooJd0gIvWNgiTinw/01wZrS68NGfrPHMpV8mQ7JDkLfdj4wTQ5q7s1S5iU8yUBlN5yySxIzSyfqzg+f5vpWn9jZ5YhPwkA92yGzN+GMC9QOif8hMxyGGjeEtxfNWTY1XPojyYYtpyQCN7dEN+q3pzNi+f/baYP+1CfpmdgjPBZXEJxrNtwHBLnpi+EvHiV1sAUz7CrE1VdMgR1wpG4uRthgRb0fkj3Yz7+3jY0grNy1FqoPesxfIU0Qoq9bD
 mXTIyfw6
 I0pGB98jpXqQZWuy9V8BCcct1KonqCKX5BMo7sgKDfRxSusSEbdbyg5+eQvxZi5T9pt8jgq/+hrKkXWO7mmvvjvpL0Jzp41ngmlrMGR0RQjNZ5fSz1TNAyMab16RRY5wjupMr+fgRTk2sjZTd6aOfB/wAZEaGwNckhysWGdbo3dRD09rK2fwhFfvF0JTObrLPNmeuHeGDH4M18cdw+JbEYxwDzpCwJ7/bu55mhRMSYswFi+JCiAYx0pVb1vI2D4FEMCWPLXomi8ybHfYO04DTwPtiSCZ1jseb2fA9PAWR3jZqp2C+mMrUMZ3azh2BCmk+Q0pSP/4u4snujZ2kykyCnWevzVR/c+pwVo4DzilpPHDlwYsJ97wS2LiCDX+gxB04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 6:39=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Currently all drivers which use defio allocate system memory. All of them
> also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocat=
es
> system RAM, so simply failed to set this flag when it ought to.
>
> This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_I=
O
> in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
> erroring out with a kernel warning if not.
>
> The logic requires a page from the driver and since commit 1ecbc7dd2902
> ("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
> always required it to be refcounted, so this was implicitly already the
> case.
>
> Finally this patch sets VM_MIXEDMAP, as the logic is mapping
> kernel-allocated memory so this is appropriate.
>
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

With the same disclaimer as in previous patch,

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  drivers/video/fbdev/core/fb_defio.c | 6 +++---
>  drivers/video/fbdev/ssd1307fb.c     | 2 ++
>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/co=
re/fb_defio.c
> index fd00b86e1ae6..fb359ecc3966 100644
> --- a/drivers/video/fbdev/core/fb_defio.c
> +++ b/drivers/video/fbdev/core/fb_defio.c
> @@ -366,13 +366,13 @@ int fb_deferred_io_mmap(struct fb_info *info, struc=
t vm_area_struct *vma)
>  {
>         vma->vm_page_prot =3D pgprot_decrypted(vma->vm_page_prot);
>
> +       if (WARN_ON_ONCE(!(info->flags & FBINFO_VIRTFB)))
> +               return -EINVAL;
>         if (!try_module_get(THIS_MODULE))
>                 return -EINVAL;
>
>         vma->vm_ops =3D &fb_deferred_io_vm_ops;
> -       vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
> -       if (!(info->flags & FBINFO_VIRTFB))
> -               vm_flags_set(vma, VM_IO);
> +       vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTDUMP);
>         vma->vm_private_data =3D info->fbdefio_state;
>
>         fb_deferred_io_state_get(info->fbdefio_state); /* released in vma=
->vm_ops->close() */
> diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd130=
7fb.c
> index c4fdecafd856..958514a35433 100644
> --- a/drivers/video/fbdev/ssd1307fb.c
> +++ b/drivers/video/fbdev/ssd1307fb.c
> @@ -763,6 +763,8 @@ static int ssd1307fb_probe(struct i2c_client *client)
>         info->fix.smem_start =3D __pa(vmem);
>         info->fix.smem_len =3D vmem_size;
>
> +       info->flags =3D FBINFO_VIRTFB;
> +
>         fb_deferred_io_init(info);
>
>         i2c_set_clientdata(client, info);
>
> --
> 2.55.0
>

