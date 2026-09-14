Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2D0CC88E77
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65166B00A2; Mon, 14 Sep 2026 11:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18386B00A5; Mon, 14 Sep 2026 11:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADFFD6B00D4; Mon, 14 Sep 2026 11:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91D936B00A2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:13:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38BE11A012E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:13:19 +0000 (UTC)
X-FDA: 85212711318.15.C2E43FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 781C840013
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:13:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=giTEJWAG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=giTEJWAG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398797;
	b=3ZYEnfueMkKn6OCGKbMcm85E0H/pj89Yi89T7F0D8Kg96lKFfIrz5QRb5b0rKIfBWeuivp
	HpatW9DjJ76j8gjdVX9D98XTkoqM3LQxbxbWOhLgdffrFMq+ic2ipLob6VsNrz5FVqxc5x
	7sXhLK8ee4jnBm+eAxc5LmzzR0zJW6s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpQUY90Yz1fvoWb/n9qt0DfA+MP9PvsomcDJoStRF6M=;
	b=4qoUtPd0B414IG1sm9xxV4OxhCdGY5hKir+yfNX8a3aDLp6JdWMXUuQK0TnDc8okgNzgPk
	hS3NmrBUBEoe91UfLePlzTQZCRKaCZL7JXqAGY47VKH6ftdntRyHLgjf3tqvOGtUCinCMc
	zEEc6HWCkt24IKVMxujUNgwKDw0Yn0o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DCA760258;
	Mon, 14 Sep 2026 15:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64571F00898;
	Mon, 14 Sep 2026 15:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398796;
	bh=rpQUY90Yz1fvoWb/n9qt0DfA+MP9PvsomcDJoStRF6M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=giTEJWAGg3uyn+vJXPvP/uZMz1rn5iOfy0BoKhWd1V/HgLWZdIpfJnUiGeOAXc7CM
	 hRNwcWix2D2axraH/QCbSYKgQBsXB5LrInzHzxqty14LGA38Wy7ax9Hi0WBR2mP44i
	 UzO7s9Ak4hpXxx65cYiC4x5v/lhuAp5/uyh/QpM8DIpxH0qilikUP96EhXWQPvSWvN
	 b1TqqVNHgP1iQd+BNAED4Z3pTgF8pSIZ+gE2QMCjiGlr9OK0Te994emHbtaA0yZ4sZ
	 RKvs0iZwx5cSniV3huEhvRpznV3cZ9pp61bBjhmUbmPXpFGu9mPxhZFqx6LYjD3iuj
	 IYHrlBmNClq2A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:50 +0100
Subject: [PATCH v2 30/40] mm/madvise: update is_valid_guard_vma() to use
 vma_can_merge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-30-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1939; i=ljs@kernel.org;
 h=from:subject:message-id; bh=sRYt0UudvtAxeO0KRMBxTGrVTVnQqrjgMi1gjOlaTgw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG9iyfS4/OKN2+Y5a/9JN/z+xOnZNuXn8o5sWz62v
 48Vri7g6ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEdpcwMkx9Nyd8mkXf1UrG
 JbuPtehP2fR3veLV6j0PSk7wOxfeStBk+Ke6pGiFuMRn85lvb/YEBAt47DmzeSLPZmvexPwuT1O
 RcjYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: 781C840013
X-Stat-Signature: r8dooa8jkg4m9d1spxckf5hw8o4dmt7c
X-Rspamd-Server: rspam01
X-HE-Tag: 1789398797-795555
X-HE-Meta: U2FsdGVkX1897jOaBV1XVERXMXLkX9Kx6rC4d7W8QPvwWH4JotSyf3+mTAq9N7M6fut/gB9xZUzmogT9bVYOH7aRYs5brdKNvjo/OSdvhgqBnUM9G0KcTZ8s5HADZnBVEtnNC+PeB1F+WSvPeOf6mJPzyrtqES2V1BN0pvJF8kUw/Jn5sPoO7w8Y3JFAajBx/K2W/7CfmJ2TtVG6s1n5x2spGcNcxtyC5DVqvwrb5fP+ABX6FH/1cPrJZDsqzm7vXjJqKKMqXhVi91rzTkJqkWUSm+S2lc0uG9zG6moLUwRpxK1kg8Cgm0DGb2EFxzXZR3UNEE2ibZoeEdzbPa6gFWSM8ksq0ZPmAX05Th10111A5VwFLfWSMUqYQ9IVdKddNZcl/FfSxSAYl2DaR1NgXEiqvstVc5Plyhj0cEI8ps9HTlTNgjnV0NQ8MSM5lZAQIes1IwWQsOVRTnkz2gGeND+ni09NT1d1+cbQZpcNy3y4+gMFUBGCtP5+qqiZZN60jv1RVQjN/FyDbT8KYCgiuPyhhJe4ja4GvyBDXdCQv5ei+qMbisGh7o78sK38nX9oiVmIiedc64OFAHzkHwbjttG4X9cqvZKq1dxL+7+X4psbfZc2GVKJaOAASkkiVVJJykZYS9+WyIYn908pv3h5Km8nMwD14HMqztWkuv/yc7UZIVk0d+As/qAt5HKG0F5YTPR7bUeEocMwTrvIRKU5BcV9mbOpmRmNG2S4T1PCdGAKSRlil09I8Uk7Thj0X34XH93IN+jGeJ+R0mRZmMJNvdY4gm3R1Zf90HtkUfsx7LNEZlcxHuuRitZMCdA2bgI4lX8ZShOWSJx1AG2YMaMIbSJG7uK0JdmB5j3AmfqPhoAQfWz7aNNHebpPhH+8flrIyaxPVvdWdeETOplDaQDkN7Bpal2Ij+2s8JmoXhhYkJg9pEiGi3yVggzMjvy2sDtv44kSehu+CvJJLdlMjx3
 kgfri8vO
 vUBxAhCWAahcewyPO0maEuV48pc77n8rfZAYJ4Fa6IWaQsSXvYsrOY/Y45ahmAWXlrH4ICBu/cJESLxcEUoqlQ0SoDmYRyMBL4q064KG4uwmjx26GDqhsU5cFpQ9Nb62LtNBdv/EljPkC8dOWRYMtDLg+lw1FQ7QenXhvg4yW82blUvriusfGJzFrzHNPCUD+1jPUTXw/irhO4VBc10lLOVg4Y3AgO6lZyBh3k5pTMOeqqa+auVj2U7WF4nIH62J7D4oSHSsl54uAL9t6oBRy9FMIAxPQg26hlJKAJoqdsVyvICj0YEI3AkjVzn2ln0FMewmNcnyGpzC+/dQ0uCX7F5n/cKo33moEESb8UvfG/JUsIPNd/dlp1dU7ijNe02gsaHXQUF6VX6bjpycz5Ca4kZOEueyRUyaORJuYiaLpgg0jUkS9R1Avl+JQIVVXqoQzBPg6g5w7hRLGwrGpKpn6/GlxO06ck0j6wQQRsaiybKo8aiTt+tkj5iLWj2Hp2h7dN2npptMJbtkkELWbHyz4zBmUvK+NhxQlfA4P5zZ4C/6tmLIxnG6e9YO9NC0PkDZ0qCpJ/GDDFS5DH0AZWg7QB0LWAVnvUKkZTLjYgP9g5/I7xj0x9qXsluRsL/dR0m1vQeRnHH86M9VLPgCF9cAy9FQu+gUUFO3bD3K1K8mnQvnvyBVBO262PIHEoEPzKMIcMTkarSu7ToLzauXj2hCehXvTbRAI3HeRxQ6uluPEnTCvb1jwhTtBSqb3qkDTdxEVf9PMdm4GoxBaw+bb1fZ0SIPFaezVuCwXB0a7Uqzg100AzwlxB5Qnf9EhMnv84o2bELYeAiXbwPL2F/dfOJ7UoWJfzgTVfKuhCKLX0ou8/+hMG+MsJ1pwgpm9kx+xk+GO/YdIGxbHb4SLhe5DrEm5sK31q/B37/43ey9MQT0qq42p9vruLk9NUGaXB7OqihJNEyHVHyGRx749+GbW1XiaKUK8TYuF
 A7GG+5/b
 7mFWFW/gg0KL5LPx8U3amxHMS9vSckI8tesCm8XKHw/jtWN+YpQLDBqQQXregfixZfWkbttHdrZmOkD/5hM/IrYvHNgOUEFr0tf1QaFOGTQZhfe5pDZiJ48133YBoZ86EPK1yEKkdpXh4RabRn2pqfsshzfIfHhI6/+SwOdxr+jErFfIsY9B8JRTKUKSmRDkmd1Zrv0YEuQ9uvmv7vBOmJBwJaF58LrONKbfKykPxkjVV0ohWehfHUSaPfecwBOO1+OUDocM7N9v3E3Yxy+Z3IGREvqWO3C7I1nRASP0zIke1GMyvwpySVN1xzHmmTQEXefBg7jTVck9Xoox2tc585x5NRb6t1wIIt7CtFE6oL8C8V2UgxEZ1s9BSAnAkfniFU04N1lo8pYNHd1hi2dR7vQ7DMzTf4/n/q7VSsS6py6UtG++nD3Ov+nXesAKfJSUokRJ5PL0/LFGe+FvcsKbLtT2QUUCxNLUFE9SB9jP97u3hlhoWZu6mvZPO0/B6bb+FYtcGGII6qvO3tgMvPFTZ83U4Kww0a/GczRwc8Z4R8LDl1/E1rzpmEqk9/BSJWBSNsXK2SRm+oIBz61Xo1PAP3NrS2BlT49HXcBlRJtWusp8wyvm6dq8epCdJqbaxekkSkozn2/liflPPEIOErQN7Ef+1MRrXPWARwKgMyW/gqBXCZdp4yyGJyb/FF5WwMuUg9271W779YIcJOuy0GJGvn8XVppDz1NEsJRRT8DMoaLO9gpOvoHGbQogHfyXeopbgYY9TwhOO2RwY22AyRWCWv16r8y5+q7sMKjbZk0Wm4xCUZC+O9gDnNBTAQUqNQib/W94SO6Ugbin5orNZryRw5cfCEzWg9Qd6m0kN+3/GfPxRBqg/x9j1m83QjYndc01NaNNBe4yTVTBa9LIVkD4TbbRml68tDC4mGq47st91Te6Gpncd7v9WpOK9N1B7oZg37t5+/qXfSqCe5MdgN7xiC05brpTz
 gGwEstFP
 MBvr0hps1nSJjOxx/+GBVgCC+oxV5hgYoO2K4M64iB+41JGaqegEFFfreVodPSD9Xf/9crwvCkS+fyaP22kQMfdIY+mMkIov2C0CTezdSxB3YPVXKgxLLkWavxK0TV/3Tq9evF4i6TxaaNoj9NoAqT3iwD49U/beO8bKfWcPFSc+VKnIO/KbuCArvWRDepewWexFSFFqODXtfooKgJRk2U5j8kgkypctSZ/Oro/QlSCq9SdU48IIfuhpaIXVd79z49LZErvzA60as2X5Zh2nqZmmeabhLMM5RmcNIptFFhOQ2GgsyhMm8UJ56udPTkI1cwkdIhUO+C68FHOu9PPadqXpZQA7AXoYhtWWopzUEWB3gsTlEl4bchtVA9BfbsVdF3MzEIVWYFV36umjoejQMB6Hyy6Kh95ti7UNqdpj+xVQ9WYQ1+DPJVifB3CgVSXiiSnp+dQPYg+AWCaKaLgIRMbyjvitDZqCSwpqyX/4Hx25WgMS1nftpP/PdYM1YQO8A/vJJksfXKivJNYGf4p4pTjDwp92qsGplfQBojQhcGfudwCun/jEeiTVZKAS8+GEOGcJiKR4OR8+uom35in45QEQ7iF7bU++SV9UQ91mPhOKeypGtcAfS+bhXsF5irr0R694mZMv+c9ChbBMdF88TmD1zDVygiesu8idAU4TlnrMuCORJw8JI7mUzngJLyzGu3/1RAcj6tSSNs82J0LO09/fQnNjBSx+3KyFhP8l8LLPob5cjmaxaEx8LHKGNaeJvW9cwpKK/N+lEspPwgRlEoIQuJYLRjxAPsHMFu6fPQI8l8M8bScZEo4i+vwGqJati4h6nInmcMWNRXH7d2jV9+hjmUznq8Avin7FyypLBqq/aVrvt4i9iuA59U/otIYzAngYQgE0eSX3l4jSIkXdw42Uv9hDnELWzI9ixqC4dmQsGgU3WWfMN3FZ0Q09ebfZnt0bsyAfYfHflat0UqVjcd4jKmqaY
 qEd0+5LO
 XPbqR40lXLFsJapP+9Ryau+LRpaqgYIvf1dDs+z7tBOx1jLpEVrU0olX1VrIYZWKJdUXiiC8PGfNEKx+XY0G23d0A+9L/qg7CdISZshw33mL11GF8wSD+oZ85zfVckaQ/1iXBXDH5ksPoAvmlV6USbXX3e3pGez2XLiOaIpbnFeWcLG3F6x7Gd3lLXii+D/qddy3LaBx4UGdOEUW0w60YXJ5GpBmpAG2oxu1Olezpre/vqFJrF54ccqjmIGjzmhno0D5nBcnkc/r1YrRimy7o0gd+RiPfEePwrgPO193YYMyVibEDMiDKCWOW6WF9G31u6jecmE6klleb+UfTuHyTz3LWZu97QBjchf8xQtUJXKp4xB8jallwlQdmooEvqpb0kECtHMKulGL7knXaK1aeMHw6U6pnx40OSByKeMjolyoozzzKlh+cGYE8IICB1/h2tf/nYiJWejA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We currently disallow the installation of lightweight guard regions in VMAs
whose flags intersect VMA_SPECIAL_FLAGS or VMA_HUGETLB_BIT, or
VMA_LOCKED_BIT unless allow_locked is set.

hugetlb VMAs set VMA_DONTEXPAND_BIT so this was already redundant,
VMA_SPECIAL_FLAGS already sufficed.

However, now that VMA_IO_BIT is only set if VMA_PFNMAP or VMA_MIXEDMAP_BIT
is set, this check collapses to being the equivalent of
!vma_can_merge().

Update is_valid_guard_vma() to reflect this.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 467601a8525b..0922d5f07a12 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1221,19 +1221,25 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 	return error;
 }
 
-static bool is_valid_guard_vma(struct vm_area_struct *vma, bool allow_locked)
+static bool is_valid_guard_vma(const struct vm_area_struct *vma,
+			       bool allow_locked)
 {
-	vm_flags_t disallowed = VM_SPECIAL | VM_HUGETLB;
-
 	/*
-	 * A user could lock after setting a guard range but that's fine, as
+	 * A user could lock after setting a guard range but that's fine as
 	 * they'd not be able to fault in. The issue arises when we try to zap
 	 * existing locked VMAs. We don't want to do that.
 	 */
-	if (!allow_locked)
-		disallowed |= VM_LOCKED;
+	if (!allow_locked && vma_test(vma, VMA_LOCKED_BIT))
+		return false;
+	/*
+	 * Guard regions require a VMA whose page tables are managed solely by
+	 * the core, which is also what merging requires, so disallow any flags
+	 * that would prevent a merge.
+	 */
+	if (!vma_can_merge(vma))
+		return false;
 
-	return !(vma->vm_flags & disallowed);
+	return true;
 }
 
 static bool is_guard_pte_marker(pte_t ptent)

-- 
2.55.0


