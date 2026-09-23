Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA515C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 16:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528996B0093; Wed, 23 Sep 2026 12:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9686B0095; Wed, 23 Sep 2026 12:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A646B0096; Wed, 23 Sep 2026 12:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 185606B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:47:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA11F1607CF
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:47:35 +0000 (UTC)
X-FDA: 85245608070.22.BFA549D
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id A9B7EA0006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:47:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZSeruv1Y;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790182053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmfZqOIcZMi+n6JYS11k53fRFKi7v2MDj9yxHBvJbZg=;
	b=3YzXK69QgjrWdaHD5A35oD5cIByV3xMWTem1f7DpGdF0rTcqvZ8eeQsCFtPOWE0gdjJjZZ
	0IG/NxpKhki6h/9C9OiMMr1kvKC0+nRCbZMY1mx/R4/BFMM/RugbWEccGMBHMJlGWYED1V
	rfbVQDq9JPYlIsZU889ZcemwUmIOBZk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZSeruv1Y;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790182053;
	b=M6q+nxA3YoQgj+6kQGO4fnz4UwRHfxiCyZCUlnino0ENO0EQMH2esyl/pcZwDc4milffLT
	8pSlop7VB3d9PutwG3pNL771hnD10mialaddEiIOK112qv8ARnDvRx2FoAo93Y2VOvhAmZ
	/+9gu2v2JkgUjccVribBOqVeTYn7YRY=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-52faa58bff5so261cf.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:47:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790182053; cv=none;
        d=google.com; s=arc-20260327;
        b=roGRQQqTD1GopSEW1bH06vu96afc7AF9ZdGCXihQBNRd0JrinV8bwK7vRXfVu7yZYC
         Si1L/M1LpJySvfk7TYnwEbr8oSx8sbPEI7e5QooOUKoCrYtZSeReNxs8yrqByT0G92rn
         e4iQ7QZZhwcG6FIjtDsi7prsUNCvGuD7kFuHJ5vY9tH7Q2OEWmnvDBVCcoxJLmCvdgkU
         /vAIGtQ/n+XC8a0fNJnICa54NPDObzbUKUtrncYotIRYzxvhK2nCXK2uEhjMDjvxKO3E
         iSwwRDuwAAvBLNE+3bHGWgiohnzqZSRuDZzFl1GjFfSYYAYMTxYxe0cfMiIXRwGkzikZ
         tRTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CmfZqOIcZMi+n6JYS11k53fRFKi7v2MDj9yxHBvJbZg=;
        fh=ELrH8JA5UzNfTam7FGQzKAD863nKP6JP99KcocJ5aZc=;
        b=UhfUFQCvGqvgQeHe7V7X/pwu8zv+MheZRgFrQ3DyitdFddnNKqwuIC5qXmq8tiCPvN
         iDC5HDzXZgmyb86aDW5uLQPC1/slofdBemRmgAa9Ovj4/7xbcfSt8g75Xm1qGNlk+O/J
         MYn4dqaLOZlw9eioGW3/SZ3aNfsX2qhrnBBgUTNniQR0PRpaoP8vIER7igOXW1jSwOQU
         I8rK9ue1vltZwh8BjyVfTlAmoLJ6DUSjGJKOeeL4s9o3H4fY33vJFD+dYg4iCJQpH/Cn
         InJtfZxxlnMHfSepvPHVkplHuq3Xa56TsiU9rEgeMw0j2z4KP2prjoTWWPunLFAKzO4c
         EZQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790182053; x=1790786853; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CmfZqOIcZMi+n6JYS11k53fRFKi7v2MDj9yxHBvJbZg=;
        b=ZSeruv1YvmasJ9/8khTx0xHGmvaILOM/OOGDQL7xuQPsEQ/aLRiokGnvRo1vH1MEiD
         ZMil8+Qd8kxM6A+1liX+bz1kjGg9Jn9TNUIXv105BGNa20Wo7k5OiHL7Kvq/uBImnRP7
         bDzflz+y7UVJB+LaG+2885TwGdFh8VoGtHiWx1j+cbd73/qw9dWZADff3CAMHQzuS7f9
         TGvkqGzGoE2kZKLsZWxzby062FFn4LcHJCZPAD8/M0a9rFkBQbbndSUy6W1vayWQwQJm
         oS2f5naTqvJeowMuF4LW2FoS2ygqdWcWeucz/fejRlzPmFN32qxlQTpfKlxiw4tzPLX+
         fXHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790182053; x=1790786853;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CmfZqOIcZMi+n6JYS11k53fRFKi7v2MDj9yxHBvJbZg=;
        b=KdUCRq9in2tatpo6SAITmbeLO/WaOBtKrCWcTKB7DhKnW7V9nj+1R/vw5AKEozjP5A
         sl0Mv3ULnS01brEEnBq/GbBjTDBc9oi3GVp3xs0OnS4UC2PVpO93au90RABBg95LuTN2
         /Kxhi40hJxSB/KAj2o8QJi+9bIxvDn9nraJrMO8lXsy9Dt/nYZOaTIetWPZU4VmpsCDa
         vPj9bjdcVQWnle7lroQQ/m0/rt3Q0/N6O3Yht6fH+1byyemz/VBpZc/PKRvzceWIuRuy
         mf3lFv/m1LYSzBWfT8VrsBvTXcxICAFW54H+YnOramR49POgyTNZtG/wFpaBh1leBH6x
         8Ilg==
X-Forwarded-Encrypted: i=1; AKwUvBxCtThDzsbmQKWWu4oLDiuHrdviaZXRtrDLYp44CJg+/d9WrBWm/TdXQGGG1Sik8duh/Uf4VSA6dA==@kvack.org
X-Gm-Message-State: AFuF++lE1wHB/kKjUxQVBsUt3gr/5BDJuoQ60q3qBdRdKiXWQfr252aG
	P8DhMQwrijQa/McwM+fUItW1cxdpgnZXAceTBFy7UUvkxGSXzfnQwGMl6fI0z3Ko6iypmkjjvrM
	QsPyF27whvNZbYHZW4oPSbOVGFJK1z/fTSA0mm1kP
X-Gm-Gg: AYBFou0t0s6chy/Jggefu8W/nrytMHCAmwLSil5u4N9lYxyl2Hz3qRJjQE1/aMnyUqS
	iQr6g4uirFqjqK93DungxzGje5lCiULXxj/iitcXy8lHJ75+34TlttPlk5F8n/umDGY+k3E178R
	yXmuwc+cN8w+J88TIQY83U5MOUEgs65W/5a4fC6JVxLF1EQpI+egeWbMMKeXZOFFdEYLX8F2YVL
	ldkJTdUY0nn7Pv7298edviLv/NFYUy4megeVjS9Rruz9elczGV/xw1OTcXriDk/1P429kjL1A7q
	a7qon5HFUKw8w6fsNqTWHUbl8aPJELeJEN8IM49otxsBse0e/0HjRXyCugMdvjB07/0LYAhdJSl
	pDURE80qBaV8=
X-Received: by 2002:ac8:7c43:0:b0:531:475:4ce6 with SMTP id
 d75a77b69052e-532f9c8446amr855061cf.9.1790182051765; Wed, 23 Sep 2026
 09:47:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-4-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-4-4583d8a23bca@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Sep 2026 09:47:20 -0700
X-Gm-Features: AclHuK83Kla3imZgJxwcVqaZrjkW9LZwYBjsyBrh5q6aKIVAyiuE6uaku1WwNaI
Message-ID: <CAJuCfpELP9Ups5XeS3PNbF=VtrfkYbkwRj-LuEHd7bLsTw4LUw@mail.gmail.com>
Subject: Re: [PATCH v3 04/40] mm: consistently validate VMA state after
 mmap[_prepare] hooks
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
X-Stat-Signature: poershonwbzm57ak85s5t57brig1446t
X-Rspamd-Queue-Id: A9B7EA0006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790182053-994104
X-HE-Meta: U2FsdGVkX1+GplJaxUsN0v1ams6HhiVwH5OCowb0BymdGy6wjPs+r2n1/OCbAbGE5eoWU4bj82Z91H+0A8UVzBwmQh7nSywW7k0e8UALYwG3y1RvVPvKHJx7q64hiFz4+O64AQeN5UhGzCtBRbsG6Q8vlUoGMomnfjJFSJg8cjh5d+sQis4iCv+EWKxckatBwZashKqnu9HKuKQFZD8Jc9zRvSXrjAEupM94aNJfU7QdcFyI5zcjbbh9JfzzD9d34nbESVLVjxVoMnu0NNvS2NiGRqO3ihOwRs64LMEO7VL8tRoOzWwl4IVhN6AHiKMI5kNxy9TiS7l+IOb2EtftkZsahKj55JOnMBrA/adtcYEeh+lYZhWBiHsQkhWwDtgY1mjhSHCeMEszuNO9wtjAtVzl4rYF5qLlS8BBTZbIeV/JDPmYzLXivuw5yAQDRgeGwHSaHKwcxT6ndiF0AYBy1OUYtEecgTjCDFIemsQgbZsMnwEA6Lqye7b7Cg1vE87sZ4D/xxIo6nEe+ML9gX/wa1IGeDGSxj2EvqvwKYTrgkTfIFjjWsFH0FMi7rnXxBjnR7r21GkKCnmGMdrJKuXwusUUa1gn7rgmP4K51oVmmfY+L4h6tK4tHzU6fpUNg4UQ16o6EndV5VBlYv11KJCWYz+Ax6Gc+AKJA4TGagUAUSXEKS+4zsljnPGSXGP0kp5gLMTuvM452Nifno3h3XjH8qEQ6da83LK0S/WEQ1Svg1rpNSvQmlk0opsTbiojejxzgpFY1URgmQvEBOplI4F72HcSeocaVLZVsEtCCrX+Z42xkEHfhQux8AhiYzvzV8xPj1G39zlR+a0uYC6uxWVVq0202auEnVIQf2njPnzoQronbaM7Wwg6DT3MRqABLSN4BKCZYYPjer7Ghps9CoKSx+KixUOPmr6gl69eiACIcmuLdzVWYdK0Nh4RHbgs0cvu6kK5FWz5NAI4XKxI033
 lG7rYYll
 ULGOjST/NMke1NqCLfqGHKIr6bh95DnD1bAcxEM3NiqAhVpZKr1WC+ii62JJ2WC8CExq+D0zitMDkWtcYH/DXM8N8QSno1f/kZ4yrHdmgcEs05Fukikwzw6wYiru2gOTb7rd+uX10N+NB5fzlPVVhC1WT4EZYT/NAsn8BmgywXj73cLEuULX0wUzfVks2WxkiGgdRAo2XO2MBTVUHKnz13PpmWgTmyAGrA2/uYWJgkBB+OnucGesm6RsgjzNB3jSQJSsmntJnoJ9nnJ/pbbxcKXJdQepiVzylLx1tj861WiEdFh6HJvC+YVG0u8KPSl5fGT6FlRnSVq8U3ekejBw/+TjxoArPuuh71fTYT2K+cwG/067U/wLMG6yUxXj59VaMg/58QQOcUpg2jvrenYar55Hz+/7ctCyDtpeZffRNlM27XVD+cAk8IOE7FziFvpzsBUtrmjFdOrKFI1fI+9Xxszcn95AOKB45+uzPiRgAHaXp9MHhIacNXNm6cuW+JHgmdpff8R0xgSaasJCIBBql0SWQRU32Zj42wqKqJWfnAjfdEn8gMYYliulV6/fVJxek6zCDFVBIhhmxiVyAlmtZynKDvbo554sIMvo4y8E+GNPepPshuKI8S71Rs0WJmv9SKGDKVaHbSqRujt0cgLXpm/cwGE2OyH6HsjfQL8n9BeTL/VZ/UvNyMeaQDLUnHXz+RxLGQ7lbRw65In7ffMS4ieEKDvaWa7bg43N2wEdVtvRyz5lOad4eMgMq1yYmFzACzJg60inBlRScQeLXz/vpJvOZ28zXHCD9++uGGrrSbMjBe3saXaXLje1EOLXvXy1gzTebQ5QEriQESn1Z4v1W8DpGZE+nlJWXw9LTzs/JQLQleJj1a8OFv8Bnnu/GYcEl2wEaDOG29kCZVN5KHnjFgNlZTDqdfUHSb49pLuUcK77u8w7GqdC2ugmgadRsNi5rMFvZQy982YEYp4c/tJXReYOVzu4m
 14Z6yZRS
 WJGNNRO4B2705XlutMhnhyW1GSTLYgwjaNPfJLgU6KRTepbWpBJaWYiKtWCn3o/p6NrTHo7HTbLlEkDZfZrDGT7zRL3yTbfNoGeWc3MAZ6+roeBZvJxMwonO60Nw0gxYMEHLREeKIb9KybHMU8qMVFvcbvI7PC8nEDrn+F6UPgiZ9+10v1A2FVh0CcArLHg8c6ILQ8buniTP/uQZ0dsSzSxinGWF/AmL6OkoZ79YQQ5jwBxZjUN/FEQMQColsy0+UPEzeNISBGLigFPlbHa1aBS2zL+whM+uWXvaNRa3CsTpHtCrLTz2RSGyTF4L2wvEawAqls8R4GEH4t2KC/jcJRzVBoF/IxJcLW6baytAg3GbQIVdoof4wrUONukNWpaTD8X6+OlHjsVFakStOpyayenZqqhFIaHcWjmZHmcYL7MPVAYEmobcgDqUfBemxIpbS87met3elsLokZVioqgub4RPHScOPq71wDARF9uV2xlxZHwBvJG5TMnRnM+i9TLQ/6GIRqlfQgqsmEizFlZOB8HISQaUE8dtxCIW7M/HcVKW1lRgCS6fp/URkjrY5BX59Sgpv/XfCm41pd6gtwUkZL4qfQbj6hkfMXgdmwQ8TXoolS4aDszbrnLdPyCvIxW9p5XMqJ0r0ELX2KXcfK6ws74/6KJ/5x8K/q6g3/Rvs35sgY0LJfdJxOMPcKmhJs95sPzjEcE7FE1NKvDnA7J1Mg3J4pxgDbTe2Wkjk7QnIouWfM4YVJIDwTwZeJOMaEllzXZrBFLNMZKhhx7NNsiqI/kcLOFwW+AICySOeohn+DkX4J+v4X2YHH779SdlrFDJcyIx0oH5GzCBqUOirXlpIa8XwIP9jxw/iDdgSzGRgMyl8oyXjiC97NV3N9+w3qkRtUN8XmxTeVITW9Mv1xoZBCAyySW6elmnGsdLu+jSpny2g/AHT2ghcS9znjbrRxUlk4TLzuEUQsYhnPl2ZtfUvKUsLS+3w
 IHMgZH6D
 q3Zdjtiyo7WPFWPgJ2NSIioBoAkpc4MdPLvjeLkMItj+MKRNadXvvinWhXFAv6XpUlwv0BkmVTH3MusU/uw+aO/SIs+W2JkEF4XBqsU9sNSN8yTiET/6H23adbF8Y24IqY0XCNioIF3VPthw9PcmbKzvm8K4EEoLksXW9AFLrfUoq5ujZX0L+UX5l0/fykzqOIKOcK6Z5vljTbiLXS/AMfKYQxBEf6jLY/xC1DpJZqdH+4yLBtiMp5j76jMXsX15lBA8zeIL9xYLecVEpURtwomb9VvFQx/nusHKeiJ9NoI0usgTnJOZ0G9Z+WFzqoFFaZq3M71FKEsDG21Prn+e3PijuHnjA3AHg80U+g0UDUYXJ12agHaeKL5TGxthePNUYtniGbo486a5Ip6YTVIXbJy9lOSxlHHiUqqleqKq5JfeseVr8IczH16UJtNgdVbaLltdnzclen5PfEctywh42lp3M+uZs0CO+6/Cycj6L5+reVlORtnNe3hmmH6NGgJmKe7dw4w1FMRR2Ksn1SuJdwTpO8ujm+rcsgIvnzcMosvs8WZO7Al9KjNn7ER3iluk1eidPnxIFBI9wVBFDqJ/lXikA9H//fcc8WGIB3E9SzvKP0/3okQdeFaktHIGYuOzYA7o+BofU/W3OWKu7FpdIAlmKsryr1+vZyVe/NqunJ/+2seiZQ86Nwmtaaw+FM0JgvNB13SVLRwHNmwdGXFf/XqqNTN8hsguoIpOh+8xrv3VAtld4CBsG/HX0AL2Sg6dZc86Pvwppzi6nJ1KMUhIBqq0rAyeyK1oXc8M21XZEeDySgHqTeqePKC2T3Qcqxd2A565mzmxBnt7LQlQWFMA21Bi9UgVCpOFUMW1Sly8jhjwBTvf4SvmfqRyJOvcFYgNsyG6cHd+jOgOn4zk/BfEFMIQxetuKMDX6I4bRRlBhWHpowPLcYhW+1ROKqKOmTJcWhMevOjPIMcgolyaPh5Dc7Ta1XIu1
 h414uoUZ
 eaPPXtZ5xDt5gk1mDPHrB49Ls6k0e26NgIIGWbX/Ao6uubM7+NM1boxn1xT/e4OyJikK8510wp3eHtUwI1fJDVi0SA7EccQ+gwIgO+bn2nbVTWThGwxbSrdbY0ltoW1H0dP9188SZTxwDp7cpK0WVBTyA7GLdl5GYz7EuLW/+ow6B1mNTMnKUN5biDa7fe8fjCvy8FWgMfMIPEQwh25/+g9OFfkJ/SnWtFVXGLEvngSgJ17KmbpEqstlWhY8RC1AJcqHjkOBH4lWmeTG3uwdadzB3hGf5Ik6b2FmU2kqxy0FKbKzFEN4pBv0//x8kY1yrsrkojxpdVC+dfI4IjXMA/NycU4JB7i+9KM7Ryc1yrUw/Nv+1p5YA/uK4WMh97+49ETIleQiiTYlocUfdMPQQD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 9:25=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked, t=
he
> driver might have done something crazy that is not permitted by the kerne=
l.
>
> Currently we check for three such cases in __mmap_new_file_vma(), but onl=
y
> if the legacy f_op->mmap hook is used:
>
> * Did sparc ADI result in invalid flags?
>
> * Did the driver alter vma->vm_start?
>
> * Did the driver make a file-backed mapping on a read-only file writable?
>
> Generalise these checks for both mmap_prepare and mmap and apply to all
> invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handlin=
g
> in the core VMA code and the mmap_prepare compatibility layer.
>
> Also extend the vm_start check to vm_end also - drivers must not change t=
he
> VMA range at all.
>
> We also WARN_ON_ONCE() on these conditions as they are things that should
> simply not occur in the kernel and it's important to call it out when it
> does.
>
> We invoke mmap_prepare_validate() after mmap_action_prepare(), as mmap
> actions often manipulate state in the descriptor thus providing the final
> state the VMA will be derived from.
>
> Also call mmap_validate_vma_flags() in insert_vm_struct() to ensure that
> special regions which are inserted (such as a VDSO or VVAR) also satisfy
> the sanity checks.
>
> This way every VMA established through an mmap hook, whether via mmap() o=
r
> the compatibility layer, or inserted via insert_vm_struct(), has been
> validated. brk() VMAs never pass through a driver hook and so need no suc=
h
> check.
>
> While we're here, also fixup a couple disjoint blocks of #ifdef CONFIG_MM=
U.
>
> Finally, update the VMA userland tests to reflect the change.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/internal.h                   |  51 ++++++++++++--------
>  mm/util.c                       |  19 ++++++--
>  mm/vma.c                        | 100 ++++++++++++++++++++++++++++++++++=
------
>  mm/vma.h                        |  25 ++++++++--
>  tools/testing/vma/include/dup.h |  10 ++++
>  5 files changed, 163 insertions(+), 42 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index fe576d468af4..970fb34898b2 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -213,6 +213,24 @@ static inline void *folio_raw_mapping(const struct f=
olio *folio)
>         return (void *)(mapping & ~FOLIO_MAPPING_FLAGS);
>  }
>
> +/*
> + * If the VMA has a close hook then close it, and since closing it might=
 leave
> + * it in an inconsistent state which makes the use of any hooks suspect,=
 clear
> + * them down by installing dummy empty hooks.
> + */
> +static inline void vma_close(struct vm_area_struct *vma)
> +{
> +       if (vma->vm_ops && vma->vm_ops->close) {
> +               vma->vm_ops->close(vma);
> +
> +               /*
> +                * The mapping is in an inconsistent state, and no furthe=
r hooks
> +                * may be invoked upon it.
> +                */
> +               vma->vm_ops =3D &vma_dummy_vm_ops;
> +       }
> +}
> +
>  /*
>   * This is a file-backed mapping, and is about to be memory mapped - inv=
oke its
>   * mmap hook and safely handle error conditions. On error, VMA hooks wil=
l be
> @@ -225,8 +243,12 @@ static inline void *folio_raw_mapping(const struct f=
olio *folio)
>   */
>  static inline int mmap_file(struct file *file, struct vm_area_struct *vm=
a)
>  {
> -       int err =3D vfs_mmap(file, vma);
> +       const unsigned long prev_start =3D vma->vm_start;
> +       const unsigned long prev_end =3D vma->vm_end;
> +       const vma_flags_t prev_flags =3D vma->flags;

nit: Might be just me but when I see prev_XXX in VMA-related code I
picture previous VMA in the address space. Maybe call these orig_XXX?

> +       int err;
>
> +       err =3D vfs_mmap(file, vma);
>         /*
>          * Either we tried to call the file hook for mmap() and an error =
arose
>          * or a driver set vma->vm_ops =3D NULL intending there to be no =
VMA
> @@ -239,26 +261,17 @@ static inline int mmap_file(struct file *file, stru=
ct vm_area_struct *vma)
>          */
>         if (unlikely(err || !vma->vm_ops))
>                 vma->vm_ops =3D &vma_dummy_vm_ops;
> +       if (unlikely(err))
> +               return err;
>
> -       return err;
> -}
> -
> -/*
> - * If the VMA has a close hook then close it, and since closing it might=
 leave
> - * it in an inconsistent state which makes the use of any hooks suspect,=
 clear
> - * them down by installing dummy empty hooks.
> - */
> -static inline void vma_close(struct vm_area_struct *vma)
> -{
> -       if (vma->vm_ops && vma->vm_ops->close) {
> -               vma->vm_ops->close(vma);
> -
> -               /*
> -                * The mapping is in an inconsistent state, and no furthe=
r hooks
> -                * may be invoked upon it.
> -                */
> -               vma->vm_ops =3D &vma_dummy_vm_ops;
> +       err =3D mmap_hook_validate(prev_start, prev_end, &prev_flags, vma=
);
> +       if (unlikely(err)) {
> +               vma->vm_start =3D prev_start;
> +               vma->vm_end =3D prev_end;
> +               vma_close(vma);
>         }
> +
> +       return err;
>  }
>
>  /* unmap_vmas is in mm/memory.c */
> diff --git a/mm/util.c b/mm/util.c
> index 016932780925..bdd5923eebc7 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1224,19 +1224,28 @@ EXPORT_SYMBOL(compat_set_desc_from_vma);
>  int __compat_vma_mmap(struct vm_area_desc *desc,
>                       struct vm_area_struct *vma)
>  {
> +       struct vm_area_desc prev_desc;
>         int err;
>
> +       /* Derive state prior to mmap_prepare hook. */
> +       compat_set_desc_from_vma(&prev_desc, desc->file, vma);
>         /* Perform any preparatory tasks for mmap action. */
>         err =3D mmap_action_prepare(desc);
> -       if (err) {
> -               if (desc->vm_file !=3D vma->vm_file)
> -                       fput(desc->vm_file);
> -               return err;
> -       }
> +       if (err)
> +               goto err_put;
> +       /* Check the caller did nothing crazy. */
> +       err =3D mmap_prepare_validate(&prev_desc, desc);
> +       if (err)
> +               goto err_put;
>         /* Update the VMA from the descriptor. */
>         compat_set_vma_from_desc(vma, desc);
>         /* Complete any specified mmap actions. */
>         return mmap_action_complete(vma, &desc->action, /*is_compat=3D*/t=
rue);
> +
> +err_put:
> +       if (desc->vm_file !=3D vma->vm_file)
> +               fput(desc->vm_file);
> +       return err;
>  }
>  EXPORT_SYMBOL(__compat_vma_mmap);
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 05d2c676672e..d6ed10cefc8f 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2623,16 +2623,6 @@ static int __mmap_new_file_vma(struct mmap_state *=
map,
>                 return error;
>         }
>
> -       /* Drivers cannot alter the address of the VMA. */
> -       WARN_ON_ONCE(map->addr !=3D vma->vm_start);
> -       /*
> -        * Drivers should not permit writability when previously it was
> -        * disallowed.
> -        */
> -       VM_WARN_ON_ONCE(!vma_flags_same_pair(&map->vma_flags, &vma->flags=
) &&
> -                       !vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT=
) &&
> -                       vma_test(vma, VMA_MAYWRITE_BIT));
> -
>         map->vma_flags =3D vma->flags;
>
>         return 0;
> @@ -2710,11 +2700,6 @@ static int __mmap_new_vma(struct mmap_state *map, =
struct vm_area_struct **vmap,
>                 vma->flags =3D map->vma_flags;
>         }
>
> -#ifdef CONFIG_SPARC64
> -       /* TODO: Fix SPARC ADI! */
> -       WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
> -#endif
> -
>         /* Lock the VMA since it is modified after insertion into VMA tre=
e */
>         vma_start_write(vma);
>         vma_iter_store_new(vmi, vma);
> @@ -2777,6 +2762,80 @@ static void __mmap_complete(struct mmap_state *map=
, struct vm_area_struct *vma)
>         vma_set_page_prot(vma);
>  }
>
> +/* Check to ensure that the VMA flags of a newly mapped VMA are sane. */
> +static int mmap_validate_vma_flags(const vma_flags_t *flags)
> +{
> +#ifdef CONFIG_SPARC64
> +       const vm_flags_t legacy_flags =3D vma_flags_to_legacy(*flags);
> +
> +       /* TODO: Fix SPARC ADI! */
> +       if (WARN_ON_ONCE(!arch_validate_flags(legacy_flags)))
> +               return -EINVAL;
> +#endif
> +
> +       return 0;
> +}
> +
> +/* Check to ensure a driver hasn't done something crazy. */
> +static int mmap_validate(unsigned long prev_start, unsigned long prev_en=
d,
> +                        unsigned long curr_start, unsigned long curr_end=
,
> +                        const vma_flags_t *prev_flags,
> +                        const vma_flags_t *curr_flags)
> +{
> +       bool was_maywrite, is_maywrite;
> +
> +       /* Drivers cannot alter the range of the VMA. */
> +       if (WARN_ON_ONCE(prev_start !=3D curr_start || prev_end !=3D curr=
_end))
> +               return -EINVAL;
> +
> +       was_maywrite =3D vma_flags_test(prev_flags, VMA_MAYWRITE_BIT);
> +       is_maywrite =3D vma_flags_test(curr_flags, VMA_MAYWRITE_BIT);
> +
> +       /* A driver may not make a previously unwritable mapping writable=
. */
> +       if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
> +               return -EINVAL;
> +
> +       return mmap_validate_vma_flags(curr_flags);
> +}
> +
> +/**
> + * mmap_prepare_validate() - Ensure the driver hasn't violated invariant=
s in its
> + * f_op->mmap_prepare hook.
> + * @prev_desc: The VMA descriptor prior to the mmap_prepare hook being c=
alled.
> + * @desc: The VMA descriptor after the mmap_prepare hook has been called=
.
> + *
> + * Returns: 0 on success, otherwise an error.
> + */
> +int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
> +                         const struct vm_area_desc *desc)
> +{
> +       return mmap_validate(prev_desc->start, prev_desc->end,
> +                            desc->start, desc->end,
> +                            &prev_desc->vma_flags, &desc->vma_flags);
> +}
> +
> +/**
> + * mmap_hook_validate() - Ensure the driver hasn't violated invariants i=
n
> + * its f_op->mmap hook.
> + * @prev_start: The start of the mapping prior to the mmap hook.
> + * @prev_end: The end of the mapping prior to the mmap hook.
> + * @prev_flags: The VMA flags set for the VMA prior to the mmap hook.
> + * @vma: The VMA after the hook has been applied.
> + *
> + * Returns: 0 on success, otherwise an error.
> + */
> +int mmap_hook_validate(unsigned long prev_start, unsigned long prev_end,
> +                      const vma_flags_t *prev_flags,
> +                      const struct vm_area_struct *vma)
> +{
> +       const unsigned long start =3D vma->vm_start;
> +       const unsigned long end =3D vma->vm_end;
> +       const vma_flags_t *flags =3D &vma->flags;
> +
> +       return mmap_validate(prev_start, prev_end, start, end, prev_flags=
,
> +                            flags);
> +}
> +
>  static int call_action_prepare(struct mmap_state *map,
>                                struct vm_area_desc *desc)
>  {
> @@ -2803,6 +2862,7 @@ static int call_action_prepare(struct mmap_state *m=
ap,
>  static int call_mmap_prepare(struct mmap_state *map,
>                 struct vm_area_desc *desc)
>  {
> +       const struct vm_area_desc prev_desc =3D *desc;
>         int err;
>
>         /* Invoke the hook. */
> @@ -2822,6 +2882,11 @@ static int call_mmap_prepare(struct mmap_state *ma=
p,
>         if (err)
>                 return err;
>
> +       /* Check the caller did nothing crazy. */
> +       err =3D mmap_prepare_validate(&prev_desc, desc);
> +       if (err)
> +               return err;
> +
>         /* Update fields permitted to be changed. */
>         map->pgoff =3D desc->pgoff;
>         map->vma_flags =3D desc->vma_flags;
> @@ -3457,10 +3522,15 @@ int __vm_munmap(unsigned long start, size_t len, =
bool unlock)
>  int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
>  {
>         unsigned long charged =3D vma_pages(vma);
> +       int err;
>
>         if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
>                 return -ENOMEM;
>
> +       err =3D mmap_validate_vma_flags(&vma->flags);
> +       if (err)
> +               return err;
> +
>         if (vma_test(vma, VMA_ACCOUNT_BIT) &&
>              security_vm_enough_memory_mm(mm, charged))
>                 return -ENOMEM;
> diff --git a/mm/vma.h b/mm/vma.h
> index f15faa83f3d6..b2c3bc832a48 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -782,14 +782,19 @@ struct vm_area_struct *vm_area_alloc(struct mm_stru=
ct *mm);
>  struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig);
>  void vm_area_free(struct vm_area_struct *vma);
>
> -/* vma_exec.c */
>  #ifdef CONFIG_MMU
> +int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
> +                         const struct vm_area_desc *desc);
> +
> +int mmap_hook_validate(unsigned long prev_start, unsigned long prev_end,
> +                      const vma_flags_t *prev_flags,
> +                      const struct vm_area_struct *vma);
> +
> +/* vma_exec.c */
>  int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **=
vmap,
>                           unsigned long *top_mem_p);
>  int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
> -#endif
>
> -#ifdef CONFIG_MMU
>  /*
>   * Denies creating a writable executable mapping or gaining executable p=
ermissions.
>   *
> @@ -838,6 +843,20 @@ static inline bool map_deny_write_exec(const vma_fla=
gs_t *old,
>
>         return false;
>  }
> +#else
> +static inline int mmap_prepare_validate(const struct vm_area_desc *prev_=
desc,
> +                                       const struct vm_area_desc *desc)
> +{
> +       return 0;
> +}
> +
> +static inline int mmap_hook_validate(unsigned long prev_start,
> +                                    unsigned long prev_end,
> +                                    const vma_flags_t *prev_flags,
> +                                    const struct vm_area_struct *vma)
> +{
> +       return 0;
> +}
>  #endif
>
>  struct vm_area_struct *__install_special_mapping(struct mm_struct *mm,
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 2fd422789717..2986ae6ca1e5 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1359,13 +1359,23 @@ static inline int vfs_mmap_prepare(struct file *f=
ile, struct vm_area_desc *desc)
>         return file->f_op->mmap_prepare(desc);
>  }
>
> +int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
> +                         const struct vm_area_desc *desc);
> +
>  static inline int __compat_vma_mmap(struct vm_area_desc *desc,
>                 struct vm_area_struct *vma)
>  {
> +       struct vm_area_desc prev_desc;
>         int err;
>
> +       /* Derive state prior to mmap_prepare hook. */
> +       compat_set_desc_from_vma(&prev_desc, desc->file, vma);
>         /* Perform any preparatory tasks for mmap action. */
>         err =3D mmap_action_prepare(desc);
> +       if (err)
> +               return err;
> +       /* Check the caller did nothing crazy. */
> +       err =3D mmap_prepare_validate(&prev_desc, desc);
>         if (err)
>                 return err;
>         /* Update the VMA from the descriptor. */
>
> --
> 2.55.0
>

