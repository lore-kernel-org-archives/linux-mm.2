Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77518CA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F69D6B008A; Sun,  4 Oct 2026 13:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480946B008C; Sun,  4 Oct 2026 13:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FC076B0098; Sun,  4 Oct 2026 13:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E91D16B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:52:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AD901A0BA5
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:52:48 +0000 (UTC)
X-FDA: 85285689216.24.CB76AFE
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 85E2E1C0004
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:52:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N1uN7Now;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791136366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGuGLrOvm4LeUyfXJ5B4JaitM98XinzaQN/wjAvVcwQ=;
	b=I3ai0eq0auqjjcqdu8vrqiPMRKo+LXguKwLh8dbj/UyV+YgwF4NmN6+jQONsMXyTFRCn18
	DA3nDtpxlwF5QUzStNuj0xjn9sf4vSSYfx/K/qO45DupCJgEtNDXvrXesTn+ZS9kI43mNV
	QpntuqxLMGm+ZhnT/+nr5rz25SSKD0U=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N1uN7Now;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791136366;
	b=0xhWgLuncO+Un0YIt8uFjt5vnYqqCivpE4CEi3Z/FbZQgLdUw5eg++56Dk8xTxGFais+Ma
	wB0Gn8nZz3uAwUFZ3wc/ocOcVqEWWLxQsAm5w/QCj1mmQeXf9jb/UMf2ayxIewPzdiNpIK
	zI1v5+Rfspp1XwYR0v7m7vjOsMhieUE=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5351f9dbfe0so96821cf.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:52:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791136365; cv=none;
        d=google.com; s=arc-20260327;
        b=GaXSsMG3OLSZLhB8WpukbUVWwhabbLhR3Oown+4k/ha9hEh5nwiqbH/s96Whct2nrw
         9OZ023J4LdntViNYoz/0wxzZORnGTtDdXkZnM3GRPkrAF2UUiGwT1aK+fZQKDxU3J7vA
         YbEk1m5hIQVAPfu/TCDbL7r3ATPRbuWpmINrGIME8gLRoswG53cB7f+rE92QZy8o8wZd
         Hg8Ptg/csuFIIlwA8xY5+DKsqwin7YZuFwQgnI6xupo+1YnuMT4w4cV5CfLkvCLpGBsQ
         OQ6ewVdb+ZMcQNlPNoiVwzTVhXoCj9aW+X5UKTfSPbGgW/CcORSdUF2s/NjK5c0wPzQ6
         +wng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hGuGLrOvm4LeUyfXJ5B4JaitM98XinzaQN/wjAvVcwQ=;
        fh=uzuTzRFw4wGEcHUN2ksc2uF311ET20drgPNSULab4Tw=;
        b=JOSk5N+3R0Ijp0OhZuSMqZWg+yu1Elhb8wtwBjqXAJdOlNEviWtPXeghxTo3/aqZsn
         m9bk/3DzDl2YtLXewe5xHIaivvY6Reb2wPqAlRvjECLEK7SU4BBgMNF8IO9VRGovzR+o
         qgyiSLYRsU7/Z14Sz+/krsg0idK9qjgQRM0aBUCx1xnTTVAphy/hb+RwWW19tpl6Hily
         ke9D1C61WclZ6yM1gidJ4/cZDYZNP18LNCWJivHPgGgVS846dfwe2RSpum9v82krjLtE
         j8Fton7gHvyaBts2kvwK52ofLTvAIpJ2AJRfOVoK9TOSM0mWxN7Vgn1K+PIzPPRSO6sw
         oXqw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791136365; x=1791741165; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hGuGLrOvm4LeUyfXJ5B4JaitM98XinzaQN/wjAvVcwQ=;
        b=N1uN7NowlJpp+BOwE1eJlxknME8XkLGhpqo7Ic3qebGnavel4jSCIeTZ7wZUvqpFYi
         sUnTM3EepIZ8EmIkfmr0eBRTXJWe5x+2TWPbJ542W2bUCq+nQuzKU2oJdXdYt526P5EF
         tnIxJ9A44wvBOi7MlGLgANGtf5qfj5P/UK6q+dV2dXaQsWFWRbXM9ZA2yOf3idW4YvTZ
         TH3it5OurB499cd6yfAT7/0uBFhsp/V4ZmRG2YqMYPhI/52bReTe8E0zXqLr1kHz4gVx
         Rj4yInXxc/PhwLC1JwoMacYKswEocJju0k2lOAj9z3b2C4t6sZFcqYnrc9hbjTDMzdX7
         oaZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791136365; x=1791741165;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hGuGLrOvm4LeUyfXJ5B4JaitM98XinzaQN/wjAvVcwQ=;
        b=c/9pLhdMefn5HJwkG+L6eNwsLCgAX55RW0dUBbSd75rgQ1ktMtJnk7PnzktZqzSbv+
         jSbALE0uhGPFBFD84NNPQfvKVTwdk3XuvEO8GR0VRJeFWZv8epAplGsWAa0cl7l/+5ga
         sxNQQ+8qht5dKmcuENAXeT0iVoSiFRu/lBgCD21P+fecwc4P8Wx+9idpBAJ/wLGKNAa9
         Ir925r9KpIuueesJNjElJymJuancQ2fPFdkwE51SMNHhXJeNSaBgjM6TKGqkeLAPM5nM
         c18cJZGgdlCtQKGMAcetJSTc8x5mDCmSvIuVIHVLV4W1wyAr4qm1X5jEA2yGZopc0/Hs
         h8pQ==
X-Forwarded-Encrypted: i=1; AKwUvBxHwDAGm5gBrnip8vRedxxvzCbtjYOYgLyTCh8NTUrifPY330vikjtSCNf0E+hzY//F2Sp4F+InrQ==@kvack.org
X-Gm-Message-State: AFuF++n7HEDtKhxTb8jfHRIL2c0NvsTZ1icegLs8qx0UKbQEld7Y6v3I
	pmLudDXBdzH5UY30TkSF7vIVS5tDq2HM/GF27DN/4pgkWff0xEKIgN2Y6jbSxya3jp7C45AmifX
	uiBwu8YffIWCDDdg30TgATvo7CW9kBSCWJksiYdgd
X-Gm-Gg: AYBFou3HIthvuBuJHTlhTHdqvyBTsG9ZeDNNG08HW3T62Ik0tgmfimj5LGyCd6+Ey6+
	N1NRxPmRfh8a2RVwPfLMd5I+eVNdd2i4OS8xN4syx9Kg6UFRqvDhOlQisNQ0ZdYLOJGOjEHIwxl
	vjwo4ww3r6mDaTf9s3oR9qxdBbFT4Go00SvjRBsCrEu6T1vZTVFEMaK1Ue8bNPdlu/i/4s9waSH
	fqxMfMNoRMcs9/FbSDtKjj40JEizsxVwjZBkl+OqUsxcWaHFHT3b3/dH8IwCPoO5hF8MJbbhdte
	7SYSe+ooa5xXlVz6vTYOHK3O7Pudl7RcQ8jKX1jwp7ynPfSP/PhtwoCQ6Q==
X-Received: by 2002:ac8:7fd1:0:b0:530:e00f:7768 with SMTP id
 d75a77b69052e-535143a7ee5mr16757211cf.0.1791136364655; Sun, 04 Oct 2026
 10:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-16-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-16-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 10:52:33 -0700
X-Gm-Features: AclHuK97kMRDYoB6lQW3TrcrLHtwyxFXHppfod8Uz1hqyRH7vKfp8a9EoRVxxRQ
Message-ID: <CAJuCfpHQwLZiXqsC2BsC6tUACJOMFfyLp9KC2w22NnzM5Ncrmg@mail.gmail.com>
Subject: Re: [PATCH v4 16/38] mm/vma: add and use vma_[flags]_is_fixed_mapping
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
X-Stat-Signature: fsb3mmrp6wgpy1zhqjtd1rajqeeed13t
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 85E2E1C0004
X-HE-Tag: 1791136366-358833
X-HE-Meta: U2FsdGVkX1/u8N5IZOCra8/xiQS+GfnrT0VwErG4VeB9W5r2O3EI1y96QsvoG1G+vIzbXlvfG7gDCfkSOwIN9VKdoiiEI1Fi5g6iHjFDoAVycGXUqlyhFpN2GHy69AxNf3/dWlSJeKDADFqN2PTJMK9WqbD6EgE+yPPnNHw8qGlWF+qioN0kJ2WQxrGg/ymMT+U/wSk/gLsIoKkN/Fy/HA1JklgXkbzQTTAJwQAYZyET6G1WDW7NFnr8E23If15rJBDvWrp1v+iRW+0WtLv3AsAAtQu8IjBEqtM/FJf/EicN01cF8bWuaLZM+y20XURKkFUtIEZDhrM9eNPuGclfjAx8UspgIy7Rwqkh8GzU8lKhjKCVg0ukQCHM9kd8duNsZ/kD8d5WlAK0+1FkJxCD6DHzV1DMpwwZRZ48gg7jpotgTBZI1ixNtOcdThUN0qPybcMeHtwLRI3bNAMKO9Y7ezdQyDF3uKFQLXzvoYSXfy9IMLy1/Q6aBSsX+IPS7cl42BLUpu1NcLlsDH//X+fSbistc37TKnK9kDbXeolEGJJbsJWFnl5sgqzu1J58ioYG4fQNccqzrjr70ZJS6/mc2lNTQJ3hZs5XTXfx4kP1lMnB/XCE6/g/jA3DaadUZQL6bllzPaboiACVGLTlnhMyRs8W2hsiThebKR71XNdZRETr5ESbNavvDN8S5RTrxnTA6KYJGUNw5N/kSynN0amFaoOo/R/bGwskMxj4RwCkn3fuXytNMX+5QVG/r422dB0Hwyu3pJWrfBVWCAhQ/Bg7VihcQR3dVdDsTd5q2RzNeLDGBvvsmewaR4o7ZWVlRoKuusF57r8VMFbWteqRIl2rirbxEjsJ6xyOaW96yPYGyqzqptWuFHa9r8AzV2XwrLLQdWgUj5tZYxjE+QPQ4qRsO7xZlFr64hwnSF2RmTyPfKmAvlRBZmZP/FsJsfkUtPWgbYAN22+8uC3Lk7oiQZe
 i0JbEHW0
 paWvmLGmenM9N2QQtbWyuv3kDB45dALvWFOfuogzOCdbk2Fv/pNEBGvhW/nMHzaucqkChFiIRobyjLzJe5f2HpPagavDbG4yARb2p2432CrPhE7wbrsbP5I4hn2SVuB1lHybkm5rJS9DEZOsa2DalRj54du3nJUNFlw7f0y7GNuLc8l5UOwAt/WR8Ju+8MenmW33zsVCQzZOMqQZey2CxT2ESvlMwR6G1KAzJbwHV3dwH4owOgXTTrEcC8H44ypodtYLsOz5phzIXZ6KPfQZLbgCRhjmx4uAfdEk6WFTOnX2z1vD4r1ZkQh3bjH60RoBshwLQDh4miGc+lSe5D+tVuMZyrB/P7CHZ0bANsvBpycgUSwUUFVfxZpXeuY5vVVEj/bKkE7uB4YG3OQ7EBuOeBcGtOxXXrnSeeRqman8VwnmAFVSHykBYAuBrfMdERZ9WUMRWqiJgM7EKh9Cb0RyRHlE6aHDbrVAfdzgPO8O50JBxoPpVfphabTLioH3dQTU7GyzJmbX3jRAhkJH8QC8wgKAAPqPKt6IqHVrJgatwoRrFbbnOF6zbcv5SW0g4s5x3kPurX9pbMWKFj4FiJqN3tCf+TV9jYULq3KUpK5xrYPFtS4e3r7CMax7W222Kx/C0tPv7EhCszAKwjdU03MDVW0BzJzibnwVdOkfgm1jBX+ECFs0cXhmuR9FplVNdcqIiezmNaeimDR1U996jgNTQg66A+wnIi+/m5guElhceBM4lgEVc6zOY0vLoiaRWkIeBUC1eDidngeH6hRVJj6UL8XP1U9wiEeOPAVqUqXwrH5lVvFHgsaQIn25R6R13B6wZyPOLNkupbrIV6Ekm0mFXqNuveIFIAeszoW/LdESaV1bG52Iid1ElMIrc/rhhTw74go9CfZRAPZB+c5OjOzp3FGNIN2U9+3h0OWWsY0/VGWxC/3WeeMmz9c6SThbwTV9EpVyvq6nzCrh3OI+4iCINczc0xTho
 KUGEKc7l
 h62NIUfcDkKslNUfZ23W9QFtbMzbM1q71gzEBDA/DyccwyjuRQtMDeMdbKKJtex/YBX+/BCWI+nQ4Nf3RuHNjfdTjGr/EVu3NKnVtVlhroofiSktj1BdEBD1OU1gIeF0bPBo9gvwEaLiM8NRtRVaJXeZ3/lkFXgxrw9iD0T2PAYqgFzNSsk+wlTMsVXwg0uilW65ogwsbqE2awKB3OkqvrTPteRbpQqVCRvSqVCRCj7Ppf70FCPFKjEdRIx+HHRjxkyX4wvWjXRj+xG9NbuIfz0g7SKskO/93IUgkqjbltFa1ANcY3Lglk6jdjdAkykZ84M5iKRZrteY+N36B45AWvCb3kSpIV7K8lfWSZOjhmolSXseRaHeGcicHsfN6Gr2SeFa3htircdfQftbGcJBCxH7/7vTzMk+ANXuYyo8+777bzRuxBsKue6NrWaQAWA7ULOy888zTRsAhHR+pCaE9Z72Duhm4OUxfY7GdV30Z2eccJykiyYhUE0mdBalGDgQF+ivTW3NsgRr9n/hcrk9Zgz8dRo4X2nts/8AYvjMjtvsSteTfqUXwx638H41b5UaxXT3mCJi8WdsAR5EZNRgNRvyIGr6aqTsbxdOw+B9ugIMa7RD/BJ01NOQYnFFPlNVUSZAOuRFpEXh7Q6l863RIWaiBM1TSp8unZkcSZfA39hqpsnFDKYWLRW80gZZSfSrjw7l+LyXrinD+AKLCjC7PFUVG2QeSt8dnCYZhrg6ZOGaVZt6IlTqfeixL9Trq9jxUs6veEX2WJdQg9KllBuuk94VYbI4eXKzZO9bqYQej6fVeOzsdDKi87+uNxHuOHVYgyScZWc89NUoRKatOJ339g5e+AHJMKrD8Qs+TxLvpZs89I01HDHX8+eZLbCnKPNBDhe1iux9g1te+e92SgQ1Gg5EQtj8AjKMjOl0mEu/9nnldPztB5PxpuZsa3JkcIgfWHM84r+RTn0icqEcNighOPW+CGLDN
 w9LlIuu+
 wj9jA6imiDnEwSnHyqeNXLkjfmkmzpIukRK2+YD/nHpgcOTmL2qlNFGu+/x5iFGP4SadYNEVvBZ4On3pzOJQcvM5Dlx3BSCdK1h/fg9X6S2scEe+PznWXeO+RLfsWkpjqDdDhL3/4IvBCr2XST3/PpSraoniT9rb07wYn7ZsfrCqY81GNpCDKGDb84miUP6l6PqTB3E+cQc5aj/A8p8yO5bGoGJIq6EfQnfiJkYEvk9lJeAIso6e7ZU5jLtBpWUIjtcrbaHcw25kS5iSA4L1zGRtZjB2jVJFAb0c6jfEmupGBt9Gq3ONC2xDqteDrF0UhOvhIKAFF0aqgYkbsDMtmM+mYxv6+/HfOa5Mp9cpG3l6U7xNoz92SLgNaXlXZv2td6kbbA8qNdEoZwLt3ZJj7nFL6KWxWS0FaiRn79IicMY6bEpcat9It7/ZNbrZvisLKZ5yhH9/aP+OWFLF0UmB09sNNcby2gEPYsbbxL1dYcax5J/AscHfpqQQmrXq2MTQZ7NS991HjaoRP7DTJb3jRP1Os08KUN6ep8LFeIOSyUfTRghwa/ts9ho1CVYBDdjcXwyTns0ww4O7FBUcVq80+mHVWGQpb2qlPnw6j12duhWMyjEhxMC7c3aHzaWr9YEdmisgcPQ8RTi3yB4xGiDQ/dHezoRKLFgHel/qMFzCAlu2JMhZd6eFMt+tRXtK0gIrMkILmVjhB+ulRMRfjiiXXfoKRchq/2fDC+QSLbQscM12Xo4HWf/cWLZsmZetf4OoYvOf2SxeHCMMX1TRen2K777cdjEuVf9aa8xj0ibo4VdhVQ2v5cI+TrSWPbne2Ay1m72lr3OEd6NzC5aR0wGil8CiQHot2B34AdMoNvCWrVhQ8l1YoH1i/YVdmp4Z2CzI7LYFHyMjofHmsWgD3p7qy+y+H1cEBHypjp4Pv4eHJerSAp8yT6YUGzdNL652nJnuRzctB+ObwO8gV5Kp1prwckM1rys1p
 RnIgug+T
 MQKRTCeZRm1/R4naURXCwq+u+pzbXaWQPdsZU+axIxaKpeZw5IyQF3+rMU0Qi4UgLkCFVRmtLVwiMPPpO54iMwHYaEsutweVNcVfl1GhmkAZzwns4tDsfdpq3JX8ABB0huxzfnfHVCU/ZkOd17dQa7lk2iP9QtNYWs4lG5HdrnFeA19WDiIkJiFjC682rSBi55DethiY31VisuAp9UpkwglXPJtC6SGsaLZuVUKakErB4T6sDcW6KFKzmZbBNVqokzjW6uIRGZxYn0WW2mfh9sslK89mZY3Wxyp811xk6vI7QAiuKX9eyMFPgbkwL7JeLj8OC0Jj6pszH/astfHNJ6tboadYRLZI3elbdz/xr9fn7SplGWoEWDuLmj8fQjHRDY1dLmUmeI4KhfzaWc3v+6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 6:38=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> This determines whether a VMA cannot be expanded or merged because what
> they mapped was determined to be a set size at mmap time.
>
> This typically refers to mappings not managed by core mm, however
> VMA_DONTEXPAND_BIT
> is not reliably set alongside VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT, so we
> must explicitly test for this for now.
>
> We also explicitly test for VMA_PFNMAP_BIT as VMA_DONTEXPAND_BIT may not =
be
> set for VMA_PFNMAP_BIT's despite the one implying the other.
>
> Use this predicate in vma_flags_can_merge() and in check_prep_vma() in th=
e
> mremap logic testing to see if mremap() can expand the VMA. The criteria
> for khugepaged and MADV_COLLAPSE eligibility in
> __thp_vma_allowable_orders() are precisely those for mergeability, so use
> vma_can_merge() there (with an expanded comment).
>
> This obviates the need for the VM_NO_KHUGEPAGED mask, so remove it.
>
> Hugetlb VMAs remain excluded from khugepaged as hugetlbfs always sets
> VMA_DONTEXPAND_BIT.
>
> Also update the userland VMA tests to reflect the change.
>
> No functional change intended.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  include/linux/mm.h              | 39 +++++++++++++++++++++++++++++++++++=
----
>  mm/huge_memory.c                | 11 +++++++----
>  mm/mremap.c                     |  5 ++---
>  tools/testing/vma/include/dup.h | 16 +++++++++++++++-
>  4 files changed, 59 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 83953757735a..6b5f06cd174a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -600,9 +600,6 @@ enum {
>  #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,       \
>                                      VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT=
)
>
> -/* This mask prevents VMA from being scanned with khugepaged */
> -#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
> -
>  /* This mask defines which mm->def_flags a process can inherit its paren=
t */
>  #define VM_INIT_DEF_MASK       VM_NOHUGEPAGE
>
> @@ -1647,6 +1644,40 @@ static inline bool vma_is_mm_managed(const struct =
vm_area_struct *vma)
>         return vma_flags_is_mm_managed(&vma->flags);
>  }
>
> +/**
> + * vma_flags_is_fixed_mapping() - Do the specified VMA flags indicate th=
at this
> + * is a fixed mapping that cannot be expanded or merged?
> + * @flags: The VMA flags to test.
> + *
> + * Fixed mappings are those whose size is set at the point of mmap (for
> + * instance, a mapping of a fixed range of memory established by a drive=
r),
> + * and thus cannot be expanded or merged.
> + *
> + * Returns: true if the flags indicate a fixed mapping.
> + */
> +static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
> +{
> +       /*
> +        * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some calle=
rs set
> +        * only the former.
> +        */
> +       return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_B=
IT);
> +}
> +
> +/**
> + * vma_is_fixed_mapping() - Is this VMA a fixed mapping that cannot be
> + * expanded or merged?
> + * @vma: The VMA to test.
> + *
> + * See vma_flags_is_fixed_mapping() for a description of this property.
> + *
> + * Returns: true if the VMA maps a fixed mapping.
> + */
> +static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma=
)
> +{
> +       return vma_flags_is_fixed_mapping(&vma->flags);
> +}
> +
>  /**
>   * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to =
be
>   * merged with another?
> @@ -1668,7 +1699,7 @@ static inline bool vma_flags_can_merge(const vma_fl=
ags_t *flags)
>         if (!vma_flags_is_mm_managed(flags))
>                 return false;
>         /* VMA explicitly marked as being unmergeable. */
> -       if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
> +       if (vma_flags_is_fixed_mapping(flags))
>                 return false;
>
>         return true;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 4cd917f77f3f..87e8bf8029ab 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -212,11 +212,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_=
area_struct *vma,
>                 return in_pf ? orders : 0;
>
>         /*
> -        * khugepaged special VMA and hugetlb VMA.
> -        * Must be checked after dax since some dax mappings may have
> -        * VM_MIXEDMAP set.
> +        * khugepaged moves data from VMAs once collapsed, after they hav=
e been
> +        * faulted in, relying on refaulting for file-backed memory.
> +        *
> +        * Mappings not managed by core mm cannot be reliably reconstruct=
ed from
> +        * page faults, and fixed mappings (including hugetlb) may well b=
e
> +        * mm-managed - precisely the mappings which cannot be merged.
>          */
> -       if (!in_pf && !smaps && (vm_flags & VM_NO_KHUGEPAGED))
> +       if (!in_pf && !smaps && !vma_can_merge(vma))
>                 return 0;
>
>         /*
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 7c368440fafe..ed19b47c2caf 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1788,8 +1788,7 @@ static int check_prep_vma(struct vma_remap_struct *=
vrm)
>                 return -EINVAL;
>         }
>
> -       if ((vrm->flags & MREMAP_DONTUNMAP) &&
> -           vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
> +       if ((vrm->flags & MREMAP_DONTUNMAP) && vma_is_fixed_mapping(vma))
>                 return -EINVAL;
>
>         /*
> @@ -1827,7 +1826,7 @@ static int check_prep_vma(struct vma_remap_struct *=
vrm)
>         if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
>                 return -EINVAL;
>
> -       if (vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
> +       if (vma_is_fixed_mapping(vma))
>                 return -EFAULT;
>
>         if (!mlock_future_ok(mm, vma_test(vma, VMA_LOCKED_BIT), vrm->delt=
a))
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 89c645a6ad60..442ea9eb098d 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1676,6 +1676,20 @@ static inline bool vma_is_mm_managed(const struct =
vm_area_struct *vma)
>         return vma_flags_is_mm_managed(&vma->flags);
>  }
>
> +static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
> +{
> +       /*
> +        * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some calle=
rs set
> +        * only the former.
> +        */
> +       return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_B=
IT);
> +}
> +
> +static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma=
)
> +{
> +       return vma_flags_is_fixed_mapping(&vma->flags);
> +}
> +
>  static inline bool vma_flags_can_merge(const vma_flags_t *flags)
>  {
>         /*
> @@ -1691,7 +1705,7 @@ static inline bool vma_flags_can_merge(const vma_fl=
ags_t *flags)
>         if (!vma_flags_is_mm_managed(flags))
>                 return false;
>         /* VMA explicitly marked as being unmergeable. */
> -       if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
> +       if (vma_flags_is_fixed_mapping(flags))
>                 return false;
>
>         return true;
>
> --
> 2.55.0
>

