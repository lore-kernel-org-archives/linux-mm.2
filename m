Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15E2EC88E78
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19FC26B0096; Mon, 14 Sep 2026 11:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129A26B00A4; Mon, 14 Sep 2026 11:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E1C6B00A6; Mon, 14 Sep 2026 11:01:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C41796B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:01:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 016F2140181
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:01:49 +0000 (UTC)
X-FDA: 85212682380.07.09707AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 07CC140007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:01:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMvtKc2E;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1RlWGqGnqWzw8PbO9zbWrmr/LvMwLtC2FngYjobCv0=;
	b=dkGl7PeU8W2Hb2R4Dus6/Y48G+tjlzV/PbqgHex3PBR+3GXU1x9G2ln87+HgCsXprRROnB
	SrpbJtSl6N/zz+B5YmYvHBGaKN9vGJuxlibnuR4p4cGvryEXBOVnisXG0MqdtlAroww273
	s58bYgYjPSmZpPngZZDT+sShRxIAC/c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398108;
	b=SyFY664FrCgEiKG8QnwbWpwNPd2fLh6loAL14hrriOgKnUaL/OgbnjjnaH1Y7Gyf1scPSo
	bnFu/Q4MY+PF79+2ztxjyy7gHdJ6w96U0go+FsT0SAvJHNXFzJY1eFDfNoLeBobzRsBjX/
	Xea4omstsaVNNgY6dfGMj3zfVF/DjaM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMvtKc2E;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36E4741455;
	Mon, 14 Sep 2026 15:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5651F000FF;
	Mon, 14 Sep 2026 15:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398107;
	bh=u1RlWGqGnqWzw8PbO9zbWrmr/LvMwLtC2FngYjobCv0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RMvtKc2Efv1pbG8Mv02sdIQx9hVQ8bJXtPwMHTd3MYYD4WYoHNaa5fd2EKNkl4LXb
	 dAIBQ6wtgd+YqE6LzncYMxkdsEIAOOv5BBJOPrgsl6UEA2CyOPUlz/zhtzL3+K9n+/
	 kagkxOWzJtVy1alQpmCXVXCDICc1XxeSbucOdqnmZwdbwEmjNaMYuWiK+M3PHTU3tD
	 AESRcc/JnMvD/20iN5iXM7DjY8mImZJGF+9Wx82wOnx+grvK1o+Ua3kR46QNBj6QXG
	 CFH8rin/gxmRPwAwD/P8iy2uVPHdoMrR7FDPBjEwPjzBw5ZhKY639RgmIWFGg3yU6H
	 Xex7+5jTAEb3g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:25 +0100
Subject: [PATCH v2 05/40] mm/vma: ensure mmap_prepare doesn't set actions
 on a mergeable vma
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-5-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, 
 Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
 Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
 Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
 Xu Xin <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org, 
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1311; i=ljs@kernel.org;
 h=from:subject:message-id; bh=1okRmprRB6sg9Mfs+wXkHjRqWyxan5/JZ1tZ/n8xX5k=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK979XCjVm5Vt0rWwokPzqrcefr21bmtTD3mmy1XO
 ymdtnN16ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEWjMZGa48qTrE29h+0iez
 pVMnw/Wbv9kGjcK+Mw49R1UDlC+pxDL897ryeHbcenOG1btqTlsc2qnDq6J5ZpO7jvmDCmO/5fs
 XcgMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hy7a1sgs9hbffrtqx9ts3rarwmrxi9sz
X-Rspamd-Queue-Id: 07CC140007
X-HE-Tag: 1789398107-739121
X-HE-Meta: U2FsdGVkX19ibkhSLbALg4bPCAigq7Mki3bICp0Njz1a6vOh4n9osDSEYwDS6w0JhHj11gqUZ27oHy+zVix8T7GDVxWK7Nf/MmUZByqsDcj46ropaXBTf9rVIoO+wvh2iTKBpM4g+MRL/zKbbq+PgUdPWBvCkUa6XxTtyXZCDsOaLqN05AmUoBQBD17knkNNXIo2yQc1QitTaJApsLI3ohUKALqZFB7wWv3m4aeWa537JJPvyrRjkv5Os5Qrs7g64nhhhCSoFErMQT8T0cAh3tLgM7lxtpA0LXBChgXdM23HyQWXCGQ6rD3RfgJ7ibA+6pUuUXfeIl8/etxCLDSWd6+k1HEk869W7DgHHulurbG/cn+b6I7+CDkvVhK/eBAXtUK5k9GA0/nczJ14pPLodxD+9Wsr/aRKsshmHfQpXUYBGMkWcPIQmTgYN9FWdg3Zg4ZuThgWo86w51MJE7+a0Znbw9rvKep1dyb07G2HUMJkrZ9PNSu/2xmdLqPsinU/pV9a8Wl7FqYkzMRVrWY5CRA3Kexa38facgQ92HeSZZpT95375DnXNJq2mWoppyRCr5soTAzOa3uNRbQIX6ZyGzT192r32OhKKnQ02BaSOmQcRJ2DHq1+yVnT0ELmAiQogK9ooiluEgaRvuflquvAeatqxASfe/Z4AgsR2Gw53xOjRw0gRbYxDhhiyYAUtVJs/7ZzW5sbO0bd80FzUKGfDreC2ZLV7v8S4Cu+fCTIsF3oUv5IBZdTKpwsnp8QrlkIf/VvZOLOG4I4fGOIMl6UgtdEFdqdts7YwbnL6hhiIvVZjhH8rVRALfHLcN+KF5qtA7tw4nIWh7LFC+ZxgI4xMzqHSRWGq7M+phiJiKODY6Qu79H1U+XGJdJPhwgGNSXfN2m3jX4AxnwTkZnE0BrpEBIuix597iwSkAigcO1YbWJUSdtGpsUTOeQai94Xa+HGAkupJ8Ha8W1sghm5+Ow
 5YT46jEB
 RfsP0Nc5STX0bvRBFT01BalCEYWQFEzqSlaxTgZSaBxe6Y6zIBeJuE3MGxiDjUdDS8xodTB4VriMKCN135dffZdLMlMyt0A8i6k1nAvyqbPbHBX7wmVbDjNZXrQisPwCenDyX7R4tQyPbGNno6me0qQfCcxip7oK2FJ9nDteBQEicJTQdJJqa5JJSOZv/t8edXdCxBrPdEOHC+Cf93Q/UF6SDq7pAzcxKOubdv3Rk4YBhkCgkiPxEAjvNvpWE/feZRHMvYwrt05uagGTRXGl/Q5b4tJ4zzzLAe308WMh5uLDbkizL7d8xKBBKXTAyNH/nJZL5Y4aSSVi0sBvLGzShX9yFBkCoPvJsxYs2ogBFh3RRzmV9KP2liRH/PYtIFsWsJRLQkixUTPgtel8ZlGtkaYg6grPXmaetpGNn2ZW9sH8d7fllj8F4RVObOfIu88V5bqSk7TWvEbXmMnyiTHtqYvS/B3RhD3mk9dUsgrEb2WQTOkadm1fzDXzEex9PljuocRyJJbzcnPuafnIH9MGdG2Ll+0Gek0G0O8ceqr2T6XyGmA/Uci2LXTCk+r/3+XAU7lXuA/cS2ax22A1VAgNyEtDUlX0Gtj13CDe1Un+j6y0dhTNfCe/OwZZoDJaawTbE14jt/1WkLKbP2qm1AnDI0CyPgjqaGsDb5tIctVwtQNQO54PiivOD8PTB9d/efClsxrnep1vyqQDjFeOCaqgmqKRZVkC36YzWxqMzGMNBzX6ol8DXSoS74mk7JjPTm9R/aHsTt/VWp1pn6HRVSI+TPWY1QmjsIWwi3yGzDbDy2KWpQnBvOzBbAX4zYzYJoZDDvg4dumxSnnrrNvQVhMf9dxWJh7WDFsSvo3QVNF6cPbfyewd7sR1XB47s6RfNr9yWDS+V2e0U8yUJ4nSj2rDpWuurouhYNQf13h7LDm+OZX0O/Ty6FlX5PGPAzdao4M3bHCDvVeQaCyjwMAQuUbXQ38Ynq0U2
 K0s9bnF5
 tRRL4WdrCHsgYLC8M9l7kcxwZhPbxSnxv2/fgbrrL8oBPcyvpFgNtAPTkEzhyp3TQ9BqIE0kfmyasdkL8p7+7qInK/Ef73r6DcSZupGg9wY3d5RhW863CoszcF4C60VHaNTcEi+2u41r5QtMCnPxi2HZ2jiUC44boQ7o/aYpkI5OctGXJaVOEUd+VW0VKVAy7/slvtjRdicky2lkeNdUoLLKB4mnPE+Nb3P6U1+78MqSRQkyaIAhH+neGgooQPRLzPDBKBM2TBf/NhAW/KukfowpViHy8Xa7XnhCBQHr+mZoIpVwmb3BIhJASvU97+JGmCJ2zrLVe61ybu7nROE8f5ZsjR+48FK5tEhQUJnWTjfZXnERjgaGuVCHcKtFaEuC9ytKDfZYIC4V2Pf/0Ing2d/ZGGaIOTwxz59c1GD0uKbsLKP1eyCo2oiWeScUlqG/yHZXAzX2yoZCHmUjrcdaaF+natIiq5NnShj/Cv2UXxv0+rfaVwTSf8YOb1kumlBDgORBSGMjNH2x6l1ZwMcaUCkTBn00NhxXao7HiW/vx/Z051eLIhxG87YAkK7YFejWRJIY9b24S6LKXUaGm9cfPXXZfNkYshU0kKHgFY4E+75Lm7RcrahSnTIlr1y/B2vKLUNIskIbuaNxsaqEys14hhTbfhG9aV7g+9qlKhjt/FOFhyGAYVWdr3iiOh3u87FvzY8dHzXRfrPO7ZHcrLgwkCKcbx7W3KB1AbQ8MGo3S8SHAX4CxR47Z4Sf2Pd3OdPoHw+Mg42AfeCUi5UUeF0NYLPZGvBMq6T+3cwu9pe9qXEn5keoIADAqEOW4oFnlPauP9dPOXq78fr80mSaIOaOm/keligktSDyi4WpAnrixGiLudwqLZxSRmsEArLpGqbrKYClnkltfN0GuYL4a6dEFRmhZmjSjANlTKHKN5abIZZxSQqJ0dbBJ5MuR/ZSKtaJ4/zKij7Jf51uldEDywv9DzwESZcNE
 1eN9Hvw7
 6SqxDri8luWuKp09rzTIr7lTndgpHpZE4nT/8NQg64bVsAPrFn3LfGlmql8xGSN6M5ZJ+W7+/SjkDcGTWzKIspxgEf2MFJ8CvCOj0xXLgjAd4Ew10+ORR4JLqZPH0i0XzQyxVd1b++NjIiWbxJXIpPtnu9bB0CVU3C8akKS+GtkC4ghPN7Hs7ruWToLaGAYY7h0N10/H+83Rh4kFZyntz175BHtar8+0/JbnSFCJ7sw5brrPnlRwWGRuBmaDhBWlGnXpQVIzW9xGxZlWnPkeHL6hFgYwRwY23djkCZZXUR7tpNEYKBU/RMSqNMn7g+75QOm97RGFaCmAREVJG+UlxSGJDoSIyeUZhfPa4l8L5HfP6V3fYFpDCmmELeXF3lcZfpq1pWgquZKeFvy3dDak72bPH/Nbyq++BFnmSS6uKvaQhsYlx8zVq6LU9IWEFw69mawP4CRiL9tSA89t/FRQF7AIFSn2rH5EAajea4uDR2A00ilvZYUq0bZHCAVcCQB+lmQ0ZQCztTZOOO4aqoko1aT+6AeRsPKQCXOKX3xb/kyCdiRAd47MFAt9SmDojzdwgYIIb0V4FA/3KliiKja7UgpQpSUzSPykaUoj150nMd6Q8rv3YAJG/8KWNCzh/bZCKi7l4gyyN2Qi9QE+BkwrfthpmgaZeNCEYDEj8Z0r6qjdQXT1xszF+OieBFjX01GblFb0e7r2zVM3YmEMTAw33zMhu2k9dg/P640jaYdT59Uc0GdVqjo7hog6NKZflwKJmQKwvBQiUjOcafK8gecre/wmVVMSgTq+rOTAAGNkVGvZwKLF46K+YYyMY8JfvYd7lmUlseUeruMUJAKarwjTPNmZggfVJrnhNTyhZeq+4gxG2N4H9+btot2viBlNp4NHST2e4hi91QW6aVknhGXsMHIuFa9dnrN6JdnNuvTr0QB28f8ETPaYoF6REPnzUIzRbl9zIeqmmNmFol8KQvtKO4a7AnWd9
 HPOvegMY
 TFaSwJerhs60Fhqf3QwNoF6eD/WdNumOt4WwzKJIbpGPqmAoJ++QYJW5hqrUcv4u9FeF5ee1/sqfqyTj79gteSHG2UBiPkG4UBjBhNyTC+1aV5r1DcClC1ArWjCr/FjiJQGfu+7fZkEnuenn30fVtX0FAgrYbTTZFu/Yil7Re+SSJWbTFrgO0ErqL3xttgB6Ojtv+Jv+cn+NbdrRxB/JJQYjeavzxpsPXmhtkkyStvkeqyMH73AC+52G2wAdhJ7KaNGS/JFzeqzXgU8ocLo6qtnmmAcj48m13IcoPDtroTn4TiFwS2bSVdmEpN7Ojl3VoGyhDbsR5VnXs0PIQEQr2Jp6B26hKNzkUulb1gwpLYDLSYTRbPBEPFDLKMCRTSrcaviuh+ojxOxSy8Y5z7T5cojJUT/E2h+TzlHfCzic5mowvRAAbieCNUYUgY8tTIQgT9DclpkkzE4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a user requests an mmap_action be performed in mmap_prepare, this
involves populating the VMA range with data.

However, if the VMA is mergeable, it might then mistakenly be merged with
another VMA without having populated the range.

Every mmap action currently available sets VMA flags such that the VMA
cannot be merged.

However, to ensure that no future mmap action falls foul of this, assert
that this is the case upon mmap_prepare validation.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index 626a18c08a26..2648fb0e1995 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2809,6 +2809,15 @@ static int mmap_validate(unsigned long prev_start,
 int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
 			  const struct vm_area_desc *desc)
 {
+	/*
+	 * It is not valid to execute mmap actions for VMAs which can be merged,
+	 * as any such merge would leave portions of the mapping incorrectly
+	 * unmapped.
+	 */
+	if (vma_flags_can_merge(&desc->vma_flags) &&
+	    WARN_ON_ONCE(desc->action.type != MMAP_NOTHING))
+		return -EINVAL;
+
 	return mmap_validate(prev_desc->start, desc->start,
 			     &prev_desc->vma_flags, &desc->vma_flags);
 }

-- 
2.55.0


