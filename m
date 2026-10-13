Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49140CC6B10
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 10:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225A46B0088; Tue, 13 Oct 2026 06:58:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D77F6B008A; Tue, 13 Oct 2026 06:58:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6CF6B008C; Tue, 13 Oct 2026 06:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9EDF6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:58:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CD7E1609F3
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:58:10 +0000 (UTC)
X-FDA: 85317303540.21.4D06D49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C1107C0009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:58:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aR/hDTCH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791889088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XqYELHn1Fs10YGv478nR1wyW/4N+kLzgnDGLYZUvs88=;
	b=hzDfAnErqOEyRBuoe81dND95MGLlGv8s4aqikfJTUb/XUNbatIpSAU40gCfEbupqySaJZX
	7ayz4e0xqRx5/2ycTvZpHEnBRe4mHQP8X8FuR3fgOKGJ/z9WQcOEd240rQNEQL/xKeSzNb
	6ukinUVvqhbEaDd6iaGlcGtBp76hXGc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aR/hDTCH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791889088;
	b=R2YqexvDlMTa0duF45drDGRlBHFWQaquCJ0KFSVVeMNjqWeuU/WHBJu2U1D/KiHhYTzkG4
	ygP+iNkvaKUtozKGPuWSoDkZCCsY9nFvDi/Y84nxx1iU+N6RjmIIddVzSPrlDQvMPixZTL
	IYdK4LkpSTLnhm8fkT5UJWOibB8V6u0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC31C600D1;
	Tue, 13 Oct 2026 10:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60871F00893;
	Tue, 13 Oct 2026 10:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791889087;
	bh=XqYELHn1Fs10YGv478nR1wyW/4N+kLzgnDGLYZUvs88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aR/hDTCHkpRrD2Q85x6nhy7UfQ/CtL/ivKHNoP/7YmaOf2YtsXzMbVTewABYl+lH2
	 E1ANeprkW0sDIPEXVwMMv8R0Alz/PxPWx9Tls6fHrc59XjGM4kE7oQbFPXbmtT1b26
	 CgYaGJe2w4vRzH4o2iObzguPPcIgDQyWEM+zvsH5mKunbvoiuZazXqSsrrlF7EEQb1
	 hxo4AG70naM9Mdv5S3OChc7VTcBA6PvNoZfqGhd1XdBHFqyWNU172VtIq4TfMG4wVp
	 n2po+hi0bZLT+0+nGnJXrnkRwfPTxiBa+7wNgPjNRVRt5ql/bfPHJ7ItjHN+V6LamS
	 WiV/sW1lCSqeQ==
Date: Tue, 13 Oct 2026 11:57:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Bert Karwatzki <spasswolf@web.de>
Subject: Re: [PATCH v5 30/38] mm/vma: introduce vma[_flags]_is_mm_backed()
Message-ID: <as4NZeHKJJ822E0L@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-30-923b70125b1e@kernel.org>
 <c79d2d40-0f1c-43ec-bc25-b75ce975f27e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c79d2d40-0f1c-43ec-bc25-b75ce975f27e@kernel.org>
X-Rspamd-Queue-Id: C1107C0009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: cewjyjzuwpu1wxecxyoye6oc3pdq6eu4
X-HE-Tag: 1791889088-323987
X-HE-Meta: U2FsdGVkX19H253+klg+dnYXvG+8Q6ZGXBJ+kX1KJvm7uBIzl+dAiJWuhWzgjDzUd0gD+LTQ9maV0DLsvEbVbFLL9LhH+ZnBQc8HXqEHN60qcr3Q+8/dj9YeIWRtOcOFgU7Zv6yPHvmmRFaEhi4mQD0dd2+O0ZZ9p9wvekBfVHnVv7rpWDyJtNJKpqTo/4LQUQSaW3hYiQ+g2hNEgbxDJObnpt7O0HU15ORfhweciH9R1I01MRuAkNHz50VXtjBmveKnfwLgGJCtvvEt6xyIWrL/zRJfVrEMr82WPdC7Uq+/mj827JyaMSQ6YPG/vP5ynsXgkxXGCQnz6c3hGrx3Wxz0zx3yTYWJ4knzVmI00mc06IzyicU318U+Mfdd+6bfZeeRTu0/NiwNM2lME3HNDANFwiFNWNeoTfXYk39OV0XDGmJlJtN+ZnUi2rav1YFBR+0Em0RI/eHkumo4s/6Ru12OYmizVkQi2Sdo1WG5jlmJaT4xfYUnLBc4wF5YyfAOnDKBbxz3K6Nz00e+1pal8c1bciEy+l591FExuVjJPXBpey5h62aVYjWkRDwCNuyZiCSYIipMtFDDjKi53DDgh0vVD6BooVNge12u9M6K7pKlOQortq7NEs7hMpNU+hAzaRD9QY+wDQBRahsQtYYH5+qyOKbx2Kx6XCLt2VyqJI90bBeTEPHV0XeNVLFymHz/zsI+BS0pO2gMX71JC0FmzFmKSk0y1PpuUMPTbwtIWD8sOLKUhpGNfOjLmt9Q0xkDymHzMaH2+mZa7m6IE+YE3xWyRFK9w3/LNUccsOOpeRi8MuEGOXK7Nn3FXeLvsxxnWdw99HaQ6Yc+RZDCZHQBjEibKe/KwKrYIzjuwHi1wZnSRawGNl1Z3qgmGgZsRfWmeE6eh1Qq/VyT4eUREpN0w5xcNJwcNG3c3r1NQ73qRJ1WvLOiForvTgx2DNWPHLshEjNfOy9S/w69rAhzzQn
 3IKQEXez
 lxooTOstHpt++aCzH5qA9t14lcO6eOgJ1TsHNwoZWO9Pp/qgJ01n+R13V86Tht1GWHOLTUpxxoI/y2sHWJNd+63esawQb+0Cm+C//qffz+gZBuTwogbJhdSCB8AnqtLLKDZawRK7NollNJ2UqIPJmN5abTK0pX5w8dHINCHaptUY9VfzklSV6B/CY7z4J3W8mVlK5K4IRm8SsOpyo8ZX5Ba+QLT5jV5FziWiGLTnuM5Cs6lyD5iVUbV/hn+Zz3dAO6I0ec6ZsoihGz6BGKnp1yqHLSyK9+Aju0VGmOvo85Fm8+ZFtiULLxM2VCzOh0a+RdTp1IDVZsekE03yMXemmZ1oZn4XN7zKVZGJ3HSzaIcCRtpkSWsD2RODRxsmFW4W0c+/xmDij4cZZ44r4926xWoxKPfFuW4Nw3thzLOxmEuZKeGQQ4ht1ZcpCtMlI5cfirDybmHvQw4HLYGqXt37y8ERt2gaR4XVwv7tWcgI9LxKFfzjPbElp8qjj6jFXPIhiygy2uOXNNyxaYCV7r4DpYYkSFCIPzvHpcFW+JU0LbpMKBWAReVlwoQ0YZZuyJKRIeNwKh3/jPtsZLRY5Dze6UMp9/vFoG2pVS7LEJRmp9iLwvqjm+V18Q1Hb6c29QrAtbPcajrnRAWiB7aIIU71/hL90L0IBmhS9jETQWnRPNrZGJxeh/w39fpKj9NsehpGXiZ81sehMgNoGKFTsf2eVkUTfrKKRJO63tSzjESueF83BZz5Fh+w+oWQ+OTfcqQp+rMVfGQ9fgZGVo5nYYh/pBVEAzIEueU1IFss6nn44Bo/4JdcAqV1GTdrIKJ7jNc5zSFwfdXCPyNBoqaAPCXarDxklpDQPAxKhwV9wGFQxyOQYPcxZi/B1uy4ifSTGUdu/Et2nh/t/rrmno080M4/hSbh31RBETvjqZlQOSDucvAfqXbvQK5SSHkJWrr9igq3fj+p5AVqj3W+TArD5fp9T27YSFtU5
 EYE8VcVt
 gBT4zmUf+OlYFx062964BgNcXoqX8E5xyckicfEjaeYhpEckrebOaQor6Te4Vj1XQDGmALbj4860btoiYD7JgbmpVQ0s2//URHpkJqMB4rqMlONPx8F9ixE/BaNfbLUBaxT+zdYsU3PayhAcyrq+Prg5t7bvYM2ilWd8qPU1mMPTO/H593+xRKk+LYKqCAWNoJSYE/El4Ln33Z/BCzo0CEyzAxcYQ9dDFBC+bIshXeWOBAXRLUSYf3Mb9+t/sb24ns6Yy31jJpo2/GCzkJBHXcaWgKxP+YmiaB8mBlDkJbWDMXSEIgIV7+jjHXfBYnfJPurGoTlLEXuRojzfoyAm9zA9jgSeNunqDj/ev8xUYLLYSdC4UXx2xRod8GGFOTyXachWEX0pBmbVWNpaT8vd54MTWNp0opybT+pbKJ/5rVYwetn8fZBNDIpNkanRwLw/lNBTG7E5CaiKxET7caJBWicTdDTPo6lfg3akzuflEDvvT1s2o59Xp9ISnBH7EgLPInjR306SYQB9QJ1SJBHOUR35JIomynp1YhygnFIQFynTF8TSvGVjMphBaHQfA8l01qvYXb2m2bH5HrXgeXEJfL8bzYoTJCXrp+zvfz4QYHxudy2He6+9WK06LgCBduQDwCCpCtBAtIJvF/C2RadxozOg+hyUHy75QeHWLoWjShpO2RaH6ywobrSr9qvAgqX6ma+fGXoxMHEJMMd0sFLh0fcGCRqVdp6Dhyk6CyU+zAe5lXwt8bKwx65i8toU6zI4HUJPDmS28j98+Uts782CvDVoFBqpVRF4Jby+oWwJuJ4TGlGyZxoTnjnJBXcCxbVCFsSb+0R9u290iinN8N358/8S9kdsf6JbrvpmSdkvJzb3qtVCETVHbV5ZZNzCEx6myJrm5mb1/SgA53sMhxmoD9Rj88EGaFS++3U/4OgursM7anDxOk3Ll0+LmMQU/1PFxpT3FtjDJvA6USckyR0OeJVdIe4IG
 mqM0kMKe
 NxA//VJFe0J7TdLbCgaJBmFpdN2rHTwAU0FlZez7UbVr5xT8XxgBSXZvjYsITebJaMzDf1zEIEShLGLj6SBwK1mG+1YrcEF1wO42DSgP/UTyBjZSgR/RqeY6+Bg4VV971/HJSlQovbeaD6TR5HkMA+q5uqYVyJGVpbmKJYUs0AtC9s/zPo1Jf5o1vdtjMy23yjRLbAYFo8g7vRC1gYm/pzfZyBDin8hzgrG2YhpMorsohzdRM0tmBWLjQdPzRy/bFiNxc2jKom8+xp1EEJPey2e/IaWg8F54eFQ3HGu9wQBbOHhVXL9zNcMWKrXda1DpURWYPGwIMfrebnsxWVxQZzjFB3DreHUgP430cdfIeXdIYI3kAMGXcDecgEaMQdu7KVJq+mhuXnkF6JzRMEBOXqPLFOW9RVNGqWma1SKTkgqH3TXcTQ9fclPKZnP1u5Pf7smaBLMfTvUBvpHzogHT3DXniskkJZBdAhNkf8ICI71xmZt0jkDm4pvBTpmX3SrQNpRyDklaFsHX24UpfinGLnxtSIlfKO3pv8xA/uwZoXeDQDvFRxLnyjl6j+5jA0iAHe/JiAHDm28gV84AIuvDHRgKn7V7IfgwwJaU8XdyxfTrQhAScGBNmRq1BnTGLAcgjYMmk+4c0c4Kby+J43ezy7+4QOqN/z8S5eQyuoSEM45tDIh4VL7etfhQrgnNimqxxNAFrRkZrCCp8bfb/DFRfieDVgfHQgjnLCbVVL7tG//fADFNLKZ1KnpRIQaKVB13iKN2dVEKw1B7NpYt6dplVRrFuO3t4ZmjPg0n7oz8k0+wboNZ0ZwLpLomRliVRtqbom/JxfLVVuk+0BMbtwZhC0k7yuAXNq3bR99RKHbqoR+Dga49AHxznIG48I0NnN92NY3Q/ue+lWQr9rnKEy+5zhPEGu8yxyPlmISUT+AY+fd9Hu5JH/DkXhabADhAqxocfMkOknD1EE7LZWyDnFopAqbnhieUP
 Hc9MZlMi
 +v6z2LfDiyvqVO6rVuDPfQeda73Jn709Aai1Dxx8g0jk0NHtSD5r3Uhb1w0czIKwiqy4c2KtY72Y9Y7VGw0WdZ0gggMxQFiCLAUVt+lzb6HnezaKVKxqtEBNdMUcJcINzewPRpDTTBwQpiHprfme/guWXF4VqMcvPpZcpiIp95iGvyrTrzOJDKyDXKAeTgCddJHbZ9tX92OrxejsBM2FV6tVeGxpnoH5pslonTOyKuX6jpHo4uA1ccIbz1bTqvR4Y/4YZKy9zTF6rmBbCH8e/VkNEQeb2JwAQN/vN6AYqCpkebDNmnNeQh9paqfZAjDTTbAOhYhXLj5+OLs85cIeB0buLXgI6VdFv44sqVE1KJmK59SPwpJVVf/3qiMaG5uBfclZYgDIynMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:45:17PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> > Introduce vma[_flags]_is_mm_backed() for the purposes of identifying
> > mappings which are mm-managed and whose contents were placed there by core
> > mm's own fault path - rather than a custom ->fault handler - and which core
> > mm has not reserved the right to discard.
> >
> > Mappings not managed by core mm do not fall into this category, as they are
> > populated by their owner, and nor of course does memory-mapped I/O.
> >
> > We exclude fixed mappings as these have a layout core mm cannot assume
> > ordinary fault semantics over.
> >
> > hugetlb mappings are fixed mappings, but core mm owns them entirely, so
> > they are explicitly carved out as mm-backed, as the MADV_DODUMP check
> > already does.
> >
> > Droppable mappings are excluded as core mm has promised it may discard them
> > at any time.
> >
> > Use this functionality to update the madvise MADV_DODUMP check to test for
> > this rather than open-coding it.
> >
> > This replaces the VM_SPECIAL check which means it no longer checks for
> > VMA_IO_BIT, however this is safe as we have established the invariant that
> > mm-managed mappings may not set VMA_IO_BIT, so we implicitly include
> > these.
> >
> > No functional change intended.
> >
> > Acked-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  include/linux/mm.h | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  mm/madvise.c       |  4 ++--
> >  2 files changed, 52 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 2ce68713e4c3..55320cf2c525 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1738,6 +1738,56 @@ static inline bool vma_can_merge(const struct vm_area_struct *vma)
> >  	return vma_flags_can_merge(&vma->flags);
> >  }
> >
> > +/**
> > + * vma_flags_is_mm_backed() - Do the specified VMA flags imply the mapping is
> > + * backed by core mm?
> > + * @flags: The VMA flags to test.
> > + *
> > + * An mm-backed mapping is one managed by core mm (see
> > + * vma_flags_is_mm_managed()) for which two further things are true:
> > + *
> > + * 1. Everything mapped was placed there by core mm's fault path (no custom
> > + *    ->fault).
> > + * 2. What is mapped stays there until it is zapped or unmapped by the user.
>
> I still dislike squeezing the VMA_DROPPABLE check in here.
>
> It's just weird semantics to squeeze pages that are *managed* by core MM (#1)
> but are simply always lazyfree into this check.
>
> In fact, core-mm manages (zaps) these pages, they are really just just
> permanently lazyfree.
>
> Open-coding "this (DUMP, UFFD, MLOCK) does not make sense for droppable
> mappings" is IMHO the right decision, because there you could say
>
> "dumping something that can get zapped every second does not make any sense"
>
> "placing pages through uffd does not make any sense if it can get zapped any second"
>
> "mlock'ing (and thereby allocating!) droppable mapping does not make any sense
> and could actually break droppable semantics"

Yeah, I am starting to come over to your point of view on this.

It sucks that we have to manually do the droppable check, and I still worry
callers will miss this as a result, but at least the flag has a specific,
non-vague purpose.

Rather than keep on trying to fit droppable into the definition, which should be
as clear as possible, it does seem better to just drop the droppable check.

It's nearly equivalent to the mergeable check, except that it allows hugetlb
(the eternal exception), but that means we can now define mergeability in terms
of mm-backing which is really nice.

It also lets me avoid a case where I check mergeability in a non-merge situation
(can just drop anything like that). As well as the cases you mention.

>
> Not a hill I will die on, but I much rather have the droppable mapping be
> outside or  have it called something nasty like
>
> vma[_flags]_is_mm_backed_or_droppable()

Yeah I think best not, the flag is clearly defined, so we can live with
checking it manually.

My concern was people forgetting to account for it, but I guess we just
have to live with that in general (ugh).

Maybe later we can think of a bright idea as to how to define some
semantics that include it, but that's one for the future anyway.

--
Cheers, Lorenzo

