Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD1FACC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94856B00BD; Tue, 13 Oct 2026 11:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44266B00BE; Tue, 13 Oct 2026 11:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0D016B00BF; Tue, 13 Oct 2026 11:14:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AFE46B00BD
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:14:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0183F1A0D25
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:14:34 +0000 (UTC)
X-FDA: 85317949710.24.C30691A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 26722100005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:14:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJxoQW45;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0bnu6UG4IVOs8k1+HPoNuLyLEAARmeUBUO1+fNpEoMo=;
	b=IXmiROs6o/GheFE/JftKyWqqKYzFzBRkNb4Ph4JU2NS/+1ec/L6F2ZxVS1gZ7C9lFgD6+H
	rXMKfHyhoYOvMF/QJAvXBO/xtxxeMuNNtit1GRItSifG8IQW4A2v0Qf0RKTgAgUjIrQX6H
	g6rSljvNjnGH8SBsOzzlvTM6LbIUucc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJxoQW45;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904473;
	b=B6myU187FLSh23fu6NBt3ntZVb1dFI3+5l1leern7yUEDpgMg4WPblAUHT7I4bswfvM27m
	etFb5pzfz+XW2R2AqMbrSWc5tZ0iC40NE/g2Z/WIEHYgb8ZqidboAGxyezYDZV6r+Wufu0
	nQo1+M8Ou7++LZiwPpu7Mlplnco/TUs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23CBE41918;
	Tue, 13 Oct 2026 15:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613AA1F000FF;
	Tue, 13 Oct 2026 15:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904472;
	bh=0bnu6UG4IVOs8k1+HPoNuLyLEAARmeUBUO1+fNpEoMo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DJxoQW45L0WEIzWaYdq/0lXV8eINLp+/fpnrparhMe5MG9AzSehV4ukQfCXiulbH4
	 KMBNwPuOg+U4yWCQO1euexl6hY2jhzdR8wi/ukfqvioKd+JNNcKEfWOPf5AOfauu77
	 AgQkxbzNyRjjuPeMIPOa4jHL84oahLD9POgs4m19S4xwVjJ+CpxKJnln0kXlZ3Wzab
	 3dhsXSFqtXLPBsZha2SAd4yLHzLKWurjaNEBAOCkBMLX8L+SZgA9ZYiSLtCv6aoU6p
	 SZRoJL9Mhx4vLrwPIONT7Vq2ClIIE8BmdRRVOAwi7hCFDR9M/KxusscElO8/Z1sHBA
	 OHfc5zd/43WAw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:56 +0100
Subject: [PATCH v6 16/39] mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT
 if not mm-managed
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-16-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
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
 "Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, 
 Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2352; i=ljs@kernel.org;
 h=from:subject:message-id; bh=QlFqjTLTYzRUYg3EKhTpkPQpznpxyXAxuZd3Zxh5TsA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZx0rjt68Vui83tvJ9uLzP4vG0v53iQLzkjZ5X7hh
 mhIpufKjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkSjwjw63a7keHP/7YX8Ho
 +DDwZUn/ZPa/Qg3Xnx68KXc9/0ituj4jw7sLR07XPL7w71iLE+esqZ9OMgVcmJTdc2IV190Pwar
 hUUwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 26722100005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: zn8insm4tswrk76mngbt7rgy4pogwq9o
X-HE-Tag: 1791904472-73656
X-HE-Meta: U2FsdGVkX1/XV9pPhGSzlVCWRrurQDcx/OSjS2UZSNw0hES8rKYhGC+fVpbFwt4lmDf0QQgY+/4h8EPyR8vTfwTFb3vcK8X6hhW3BOSxjW19Nbs668FIELUSme83cH30ukUqXwdCBXzZ717Mk29/3QmkQbFTpH7OCTjm1c8GDcJZ90leUsKrFeTMXcSqxk+E/AqgYpjsw2jTTQZktJedoZIXN0Ja70vuT+NQDYPxMrorp/sxMR9KrVNdoYgbxNj2EC8whxWzEw+xgRrV7yfMmNVa0Zfs2pZwDcIjPhJEg/IMrrjticshONm5BXRAFzRQpivweQJ6LFPx+W2Aq3yuyKX4TBZMgLQvvoVtWN/fKexQwJUXWAIfPTgpjRJB7M2yNiERbdvyx2+Zniu+nWqfDYKYlRtZWo/806o1IgZRZuzUrY2/X7baEoQ5uWaD7lAz4FOrN36la+CmM8pTLWagd3oz1guct7VBrgOOcFkQ5BkjmitzNzm/ZF/vGaYm6hJd96+No0CRECkrinZZ+WfjPAHtQUG7DpEHg5ER7KaPBBSCc8l9FqLXEtDbMrpllAcLpeY2TIoywl+Xut8yHG3vBMcwHpy3v+5vPGRYzLIMR4ok2wnfcI5tQKFvXiwdjFZJZsBeZ0znzkrjPrHdLY6OSPo/Ydgga/peVpWfl6O/UPWHwlK7Z0uVhxWCIw47J3vRhMhZ4gVq2Wa+f3JkwyxLJ0zI92hcogC5+jw3vtSdadHvU+rLZkXFw2d++zb4Z6wgvPJWqBC6N/TeNr3QoAG6W131qJxmW8h5wKszKeol4jcxEbTvSvXPPwHA+uIBLY2rZ/tBTdGInA0W2924/uo+R+XuzDx0Xh2rm/IzCRczcO/21IkZVaIUh6Id+oIZ2K0vNGuG2/sxhp7PF+Far2CwY/C/UsHy0hQ5NrS9tPxHLNhP1ymgkBRekYQrVJ82vL+FypdQitGEoJypaVF0Gm+
 sBXYO0sP
 4Ex12sBWFR05DcT+QqZEjXicjxLwefWvKHg17Wrq9aa1cyLn0Pggz6FE33TO6fT0ylkn+QJCEy4SeFMsMzLrrrwBD7MsA8EKPE93kJevUAsIWwu2IllkFWFnCSQdcPrEL4IGzeTtiObWFGuNdGSXPIOrUXpPkQCGBXOrP61wYV3ydHo31i/aIa54ilN1oZFcUit0P3XLIzSOpKBprBR78KLvelVUmmvOavyExh6si0Ve6JyytKZXdvmZ3A2HlxPqoPhNfwkkeRrJroa2hkb2xmgx8bkI+C7vFy4EO9sCd1Hgv/5KDsUR2YFf1Ib82iupionROp4RN9L2m7TAJ5D1T+TL0/8YQq940NfVaCGya+XrdQ+1mHuRG/ED7i8KsMJ5fHDjw2ZRZIHiC9LfVIxaiwn7zk+OUuAlCbf/3XtHoDzDVi+c4hNOtwy+vKh+Q0yuN+U4fLi+aiO6l/TN51fSUCHOlSR5L74QFTU5rXXL7OAj+jAFXLWrR5Zt+aw3ev07sxQQNcswxZw7I9AzYaBhJS1vVYQzNLiwN+EPjgLFCVRA7NpXQFi4wkbHkOlDGGkPptHswIgLUHClDzIDz4VzzLc/msufLQy6WNcDxF5xISwsPx5iRAtSwgRdnqFKf9oOMGMsIEsWgdfcJNc/ozF76RPsXQjNYlCrFk8O7j0ibrm38XMyOtL7n6LfX8AHM8zDoYt/h1RRYlTQ8MFGOAYVtjcx0935y9Dy26nyYsp8HOtcMymssUWma63AEJ4Cse4aSSvsvLUFlS0fenx7yghfNC8UT7KuzqfMLgC+fWgi1DqdygcAFNv2cEJPgTOFGhiWf82yAvxQmIkAjxm1DEvTc/CELLFuOqMZt6zLqxW1c8wrofLF4veB+FO5hzd++M4jt+H51/TjodooCWKM2tlNMCgEOHvpWElY4EHMpmWJ2LmTUCHtMd7eKmvSyGPMlHq8+Dbfoo1JgcaNzdEMhfKDqwfNOcD5V
 YZ6TC1bx
 cJN43EvS1uPYIuYVNEmRn6lybNkESZqpoeKhv3qqicDYyvdDq6dRGtNvlq4plyIaoh9bN89lF7yblIeyzrE9+TvFbzlg7kmZ+FNJgN4Qs3h/ktnDGVRHMIQYT1CX80RlJmhVb/Beya/m2NSqTgxU6VMZKkla/U1ohpXjP7INmP7jGHtD7msoU5DXw8lJ3CWEvmc+VaN5NZKRTQyRiq8ckCxUET5ZtD41UByx/CB6Yg1MHNcBlUH1ogopvNsAa+Ze2dJdb5GyK96URaJ5Upy2co0vRsJlPIqtRnHJLNJhPi1BTjml/akA/wy7iTcKvN5kJP6hI9Ik3cojDA5rNHqG7Qk5yyNrnW1y8WDAf+sDcSiT2wz78ryQhrveMSQ9g21grSCpvBca8xz/AiVAnXQIjbHoq5M6f1WqYWiG3mHb0rUvrv7v+HcrGOQXOGXMTZO7Ukpa91MXNMF9Sr43Cc88nNrctKFCgsrLENCxUttW9KcQZdn7vA++mzV0r/cWmydK8+nPNw+C0HWSU7ij049owwa6iAwC+wd9Adv7y3MBPsln3p1/cjFduQRoGwCZFFRhpZ98oRSLHHn0c8pxhfHCKAHj+jJCAb0Tp5wvlS89zDxMrfbZeYfuvmuosccAsEzyJ77ShfyO7Mz9Z5DGSc4XG6OxGk1eBOKC4wlbR1f+l69X8wWlQlSc7f0TluqDDMjuRujzspdJLmoEe0XF/tcFgrJ/953jM2mRlYf8UzsbxTRde9mOCxL4W34sVDs9S5sJz9DRGw01vhjSe3NSpXESoS4Y+3lms9Cn9rxHW/rAgdJRS/EJbXBT40b05kdE+qyiqHPPNHJ+XAhfrpF76FKPfBNG1GsyX4XY7GjTPanI82UO9l6fx5gFNG5WhhFozCoxAtYMDUnKj7i6sWwqnYV8imDOJhuoe/u/HAlqPGV+oJXAF5cMQuCS/N5egyiP7lJcL1zaJY6zyIq6AApTyC434cKLMyNdr
 OVNHLPAy
 abiGgnEyFbOl01wjI5XiT67ZIrNmXhzAlopucscx3qgmuyllvc1nPGR6wdVXmsKBQmjXffiKhkynTJRFbmQEicSH+FP3o3DjmUQcmTgyjIRWKCqumHFSacCPUS/S8t+GvQbx8roXT2DpAu3IzqpAiO3YD/tEYrfWIXhmg4GjZX+fL9QeFR6aZbNrvrD00usMBMvc0z3rpz//NW0sM899Kf/JfpGC0U8+p6NlidJQkLdrf7Oa0OqGY3RUIw1gQy1fA/3745dlRtqlbV53wlNgd6+kpn8Gv+5iNh0OcrlyFiUgN8k9CW2Sxe1uI0l8tiqa5/BlctSESTLXqReTrUKaNuJeQzeNlf2KpnxMfJJf9pWEaKDC1tn+QQRHRZS8ydHpRSWob6n9Ndg9sFkkxrLQERFxkRfOXLJSE6V8FKi8pXUGfdsxOHb0nd+yJmK+Cl11FOf/1aKl5WbOiNZZXiPhAfzD4pYu4SVXTSdYHd2i5hW7nU+LWCLVYLU7TI3+wlTH15FaXeD5Vd4KE/UyLHsYAAvtnxJs/nEOXo6Z10c/9G73ByzKOydz0OBXXHQZkTXgU6RIWVyBmXf63JmrmhuvBLkJhlNV3e746EHbb0YJn8c1ejRs3nc8EZ7ZNHNoo/Z+I9reBobQ1SgTvmok6g3YOBNkctxyah3NzdcDTplzhefD2LejttuVy0WxJiZ7wam+AG3q76YG7a4IuLYLS9d/U/xIFK0QQm9pGjkNw9UO5qO2VtS4j59pAMi8zzj1Rr8LHferixx/I+C8BsdLDyI1k7rwjo4bySXlMyrFeZCig0Rrg9w6HpmrEsEf/uZrA2kYKkQWWwncLTiJFXILsKmJ+VsHtddeI+exdFQ+ICaYQtseoX2/8kznAb8SFwygg/XciAvXTM5d+F6FRdhAUwnaN0pdsx3qz/hzLj7ZTuQ0dsuQY2JJbzfcIO2QRoIRcvqmlQX+e7b5CgoKvMz5sKnY0vO8lWfjN
 ICLtfiJs
 3grR16JHh1uK45BOlutcm5Eja81dCvqtc+CmsJkl/Eb/tgx0QXc7UMAM8XD9UdbN4avUtOw2ZYKgF9WXXmk6R/sHp8JdTOV8nTvt+d4bbfGyNqIFp6HYdyaX+cwPV5Yl+fY5olrzIjKLUgz5oJhqD/rkdhwtohBMFLkvMO//XBNHBbLeqxGoDjI1JmVyJY1Oyc2+da73A6T/0BqCXjDxQzyykg/SJ6Pi9deXtMU61leEqpIlU5u64Ecw/oaaqKxY5qZI4VIzraKTZGQIuERHi6OnrWcBXoljMODfHkga1mmd1FJ7afu5pFlD5DESVGPYcq4r/1iJb0jBlw3Y6IFUO0u0T9ESyJXyTVvUlF7wIjDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is if
the underlying file is itself read-only.

This means that mprotect() cannot mark a shared mapping of a read-only file
as read/write, as doing so would violate the read only attribute, and
permit writes.

In general, we do not want file systems to be able to do this for
read/write files.

Doing so would violate fundamental user expectation of file attributes and
likely break userspace.

However, drivers pose a tricky problem here - the /dev/xxx file may be
read/write but provide access to a resource which is fundamentally
read-only.

Therefore we must allow drivers to be able to clear VMA_MAYWRITE_BIT.

To achieve both of these things, forbid this for mm-managed mappings as
identified by vma_flags_is_mm_managed().

This constrains this ability to drivers which own the mapping's contents,
whether memory-mapped I/O, kernel-allocated pages, or ordinary pages they
map themselves, and so define its semantics.

Every in-tree mmap hook which clears VMA_MAYWRITE_BIT, some twenty sites
across drivers, filesystems and bpf, establishes a mapping which is not
mm-managed,
with usbmon and the ALSA PCM status page converted earlier in this series
to do so.

Note that drivers may, if they do not gate on VMA_SHARED_BIT, be able to
disable MAP_PRIVATE-file-backed mapping CoW semantics.

This is perhaps not always intended, but we retain this capacity to
maintain existing behaviour.

As no driver which clears VMA_MAYWRITE_BIT establishes an mm-managed
mapping, no functional change is intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index c067d6a4c826..39ceb03023e2 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2801,6 +2801,11 @@ static int mmap_validate(unsigned long orig_start, unsigned long orig_end,
 	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
 		return -EINVAL;
 
+	/* mm-managed mappings may not clear VMA_MAYWRITE_BIT. */
+	if (vma_flags_is_mm_managed(curr_flags) &&
+	    WARN_ON_ONCE(was_maywrite && !is_maywrite))
+		return -EINVAL;
+
 	return mmap_validate_vma_flags(curr_flags);
 }
 

-- 
2.55.0


