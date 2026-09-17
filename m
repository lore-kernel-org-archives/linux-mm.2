Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FD97C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0276B00A3; Thu, 17 Sep 2026 12:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1614A6B00A4; Thu, 17 Sep 2026 12:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0288E6B00A5; Thu, 17 Sep 2026 12:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA0D56B00A3
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:24:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FFD380420
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:24:34 +0000 (UTC)
X-FDA: 85223777268.11.3282496
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6ECFB20009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:24:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JoDlkFdJ;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uiI0DfRLdeopnxcWki2BiuU0vqEbo4SKS60DQ1+UvnI=;
	b=pWDMGaezEz8UaI1iFYohOvNVZ+noMZsDCVCuXWz1uvsu2RXiLBnGAeI9H2fXwaZo/OuI9A
	oz6SxRnSYyuwee96jOPPzwsVg8q+nfyYxFrRPDUBL6rb/cPP1SOM3e0Ue6MYAv0mXn/RgZ
	tbcNzdtzeQOhyrR+mu8H4PDD68xr+e0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662272;
	b=GVeOzWOtvyuCRu27W+XIavwyGBUq5MuoH40RitXWjMVN0IIP3PjTjxJdgg57kxaKsfoJNF
	vCC1mslC0DntABlqEohYeEpFAmkSOQH+KCXGFzMdwT33vGhO6oAGXhlijtrYsRgrBABsk1
	eSiUvlxd8DevHXB9JHg5Z91SPpUXLRE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JoDlkFdJ;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3B7F42B05;
	Thu, 17 Sep 2026 16:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5951F00898;
	Thu, 17 Sep 2026 16:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662271;
	bh=uiI0DfRLdeopnxcWki2BiuU0vqEbo4SKS60DQ1+UvnI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JoDlkFdJExhib+79sc3mbfFfTiLq4I84vCOE0BnAQsEViidFeCUIBU6Zm+WK7uvcj
	 h3csAo6DvbditOrQSEUCMBMciY3oOVayc8TDnECzj/lgzATxo4ZOI26+/ORFffaWmx
	 2qsyWRW4WAU1n2K5zxr2LRl+pClqa/u4krK8Zz81OxU/ByR0bHNUWzTyerdoDNipmN
	 Ncm8kcmNyyPXoBM7G2bA7me43O5b5GMmXPb5M2fjlLqdpGDCH92oScWrB/taMJWdgK
	 G3mqQa4OD5nCb2qOAGA4UUM9ssa42pQJFvg8ObELlHIO9hH0dpr8oJB++BvZfbY8Fs
	 ss4o3EktWPFnA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:12 +0100
Subject: [PATCH v3 03/40] mm/vma: introduce and use vma_[flags_]can_merge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3665; i=ljs@kernel.org;
 h=from:subject:message-id; bh=jEmmzTa/nXg8cFJkAn6p6g1Z/ZjRGGA7aJrZ0nX97uA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCO977B/Gyum+YKumwMGjDGsvifHV8Cjf/W97nXHD0
 ddGx461dJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiy7sYGR7qfJ/4a8qOPVJ/
 fzOn+hy8GnGIV3Z6eqTLurnzjubyPX/OyLB1L/PmvNtfO+Ycf2+w9xaT+Mew3gMKHHuL5Wb8kpv
 s94QBAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: oghzacos8yif8t5gdjngjknpe573yis8
X-Rspamd-Queue-Id: 6ECFB20009
X-HE-Tag: 1789662272-251295
X-HE-Meta: U2FsdGVkX1/ZdY7hbTpmeLHkkmPSpDKsPYC+5zThfWdnK9XHtr7mf8oLrhLtQnEQFDJPMUJCiucv9ECmqW3i8fd2Zk7nIUagDggbRh8yyB93b0RbaeI3+UUpXsyTcobO4XCxkQatsKhPVnpCqCXFIwH1SZ66sg4dajpmDP7wFWXqMj8azlEGbKQEfULY4WocsXXRobIkyPMtHB8llANnrmh8CfhSWczobH00sZCa4SGBp72zWmEyj8l2BMq33b+2YE8IhNTaGGJ6ul8Qci5dYjumYyG98zEz600xDBUOuZ3h3CpmftcHUJtYyIBRPnpXVUZUKCzwLNwrShErql7wTHAh+/bUumdydmHFLXkPsYliRaC8YsvD5nyD1j4DPRNTcLcHyKgsyj/8q9f4xQDiOHRvkgUdtUrVpJAGib8fVGn+r2nqlnlZKbiFKjJ0tw9u7klqcXb32JEoYdEAC1nIp0n0TSkIaovbkkah9qc57CTKqPFVT9bIy5PFfMk4A97+THvHrqe5CqfTyKD11VjkrAju0GILuRii+S6UXzTeZ18gXtQJDAlw3ALBX66LvtaPeq9NVSEofwgl3mqvkZCgciLLjkSeKxFfArW5c9lxIuYnioxx96R9efd9rl05zF3JWwfTN/j3Cp5yT7st2wPneXv6zFclKTPzB5db0nd8+HtIz1Z9l7/47bLW014XYUhUeSyrrZOZYF9lcwT1Yz6Bl28dQpEzCTa3kBdkRqGg6WhISNZb0wt/aSb3TuUg8DGFVvdFvN/5UfrTZ81mmSwDHLl0DFAV+K+WBr8n0ha0MaJ6Gdg6CN5GEdHA4iRQfpAUTmtquOvzIsY4oCzswgVIIzoE2CYGbIgzdpi1vt9uY35okXoGh6b2NvFvFTNzzRJFQmLnLuv+HzjOE6eE3zTczneAIUhHbml2frScZ3IuVxcNh75gcyOxuy/NOyvYQXlFKF1YR1FikXm/7JKMdjh
 17/1tb9q
 5OuVvy7NiTBCeMjIfM0E2PdDf3EVJ7Y4jioootMaYH46ARWo3NOA1v6Kp1j1VIuVYMz8yfZQTyJ69hYu23/rPRO9h7SQ5O12gsoJMChGpCDVG2aLCai34XMIAHJqK3jGQ7nVk2cL6bcOavnjLGNKF0EGoFF3+kZSWRMKGMBtxC2GSjabCNjmXDKkUaCdDYjqdfDFZFa11fcf4scZ1uQdDZhU5v4DBu9SMkiOjCC4OLPAAUVfEAO5jCD5uVPpHIelnR+CKCJciJyNUy4RoMv1meTznWCTHys8sR0YKLCDbgpU1Y/L5yTkVb8Q8s9zQot2NbHfMzHi3UAv4FfGksHljmjbeeQD8f3Q3/lmK228HDCLpMhxiHpCiaBAUcjNLsMdnbIbkL49YyK3eYENcJg6tPMsXqCJPbytkFIyo2VlsTreU7j/3UbR7W696VyajQpH1OwiFtwcISwpOmDH4CCOo/CvK8yYdWBXV/oiqVG53yV1hDz+9jttrR2Nin0pCI/TYqmjVeQUdVzfVALcwacVhsiGyJR5whQTSqUFg3fXBCesuWdZTh5mGCA5QQLEXvD7c0oYWb8vdwpCHY2H9wosVzj5Y0Tr1yUR7ru33zTTVrfJ8p6eRH2khjeXPHVCt8dhFWvDritFp0nF5ejvjA7iQ7L6UzzEiL9aYJRVtDe+GoiHu5T+FBp/Ohj2V3fz6PK5RTS5oVetY/sWN3aWmOciHyK7so0fVJxWA0VMwlkJV/xlmNAF1rlR1b1waX8kYRRKmKv9SGiZePpM7tL38tTWLr60n054mLcnM42tOg5UGCRt6gdESoyxYw9YjizLGAXJ8CQqk+Ybf7+bOxKJmzWAyHfHC+VjjE6LKjTjC2JaOAg+R8VLYDVUtJv44Xq8ZO5zeU3HcoJKtM0rx+FMg8DfXGjI5EyH5RW00X5j+N2lw+eFbcEH/9PGuHClQ0BibMYZYJFY4MJnd2qMaIMP6rZ3yi3gmOMDa
 fC4+9/iM
 g7LdVOv7qj4GKqwbaAlZ4eEH+7an8fTJt/txCAZyms84RhxB6gu7zjmRe4WsW4ImQVpJWDKsOzjOh7inXuOqIZgoacYTDVqqrgNNopNeE5VkTSmR8+ijaaYEuzfG2lyctTBbQcqDOmVcXKTmg6HEYY1HgeVyScSB1CeYGAgn7umvOBTgAehRZjCVr4zlu1hGajnlF9n+efG0seqkQ+rIFtlbANqoLYiGXVcn9+5DF9vw6Zxprxl3dhVaOqhKjpEQqTqcZYtifgkrLpXc+TQR4L+sTKHzAQrou2v7eyjfX69G4wz4gSBquFHYUJv0mgb/5KSyMKWIGfO0tf6rAeRAzrXY89dLIScW6g3Fgk4fvOwYRHZP6eRUGA5SMW27+hyGKzU9VDJKadqeD+BQSGfJamKThJq2Yprk4kQEutZZ0wjZkSmzzEeUGwvKAI/mE4OarlphoHs+RIN/DxoMnafozLSg5bryaFZ+Ybffc2N69Fz2hZVI5E4lxgCnPyOJyc755INVK/zIex3JvbZwjXnGmDhsp3gB2TpedDqX5z04bm/SFR1P7I9x6H58DNyuXDLT9f59HfssI5Gf7ExQsHXk+gYzBVS/Sxb2wANvWmGka34QaMitEG6hund9UFRrIVi13N8PKA/Dde76lDT2FRyiFbXzTBpgVzEHmo1m/3rcTOkJ4dH/10LBrcsDmFYWDgvv/hy2gY8u0aFBpIKIeZYEIInR/17wuDtlf71GYGvKWoOhspIme6lptwImYPiiIHqjgLj6flmU1leGLXZUvCo1Y4nFyWIcc38dpTjNNkrdtEIqE1NUTtmgbrAfSeUkMTSnv8TlzXZhKSJSpoHtmUam0mrI7MNgFZXuMOiQAnJuQi1kIIU4bAzh3b5OwEuMZAKP5RAgBBq7ff4E4wvYArKy5zT7pK9dXIkgs1zMOgAttYopK4BT4hykLgVtPLTh8z7UV5vQqGWimTAwFVic0RXpgsjyNJ9zU
 H8JQ78Ah
 2YbyQEZzNl0YIAiTvr7BzWwHV7vmaUh87rCil4PPgpSkHLRKpygzX4d3PkSeqnC4GtHi0P6VIQ5wtQ9U8OaZaxD8rdSHaODvGX9ossrojrOhh5CyS1raCVkCam9AZyjmIKHE1ydgeqIAbbU1l6ZHmuPc/cewgDbJbRLYqE1UHfc5JB2RECLvYpSec7WK84bJJS3FBT6ii4hx8DIQPsKn8+AGDUAavD1B/DjBYB6FPetIHPz7bQLjxQxhQmJNKDsF6Mpmip3lrIlk/TaTMB+Ufu03MoBqTPL9qn76fUrvF3IZnlsGvXWSiLs9IPCIuFJzx1mLlbgfcjyEBnm3hB6SKgVUlRfM8HoGcIhx4sJCtoDQxGwbR4tE0vUvVQ6XyAqJnSW+FYz6WEzUBpTWCWYe3gTgNz58et6oIVaK9e+F4yiuN5kr9tUNr4yG0Q6wupYf2UGP8FaO5SEvPqFkUkRwHzzbBStvd+cNmliDFDqpMS8qCeM+ZdeAu+kHDrknC59A8+v5J7cvFJm0TlKlD6jk22rNtWU6EvhLKhbqpSGy3FMX5wUyz/xIv0gwaXvJoK1X2VcVV1KhoAHLA/tp3BsFe/6IGoxHy+XqntVDNbpHN2SqjMk5VRaWmDIREystHEfwke0nZuNzf+9zA2oY4wpEgmfTy+Nbp+3joniWw2H5Xp8NjHcxb5eUWtDJ218AGXbpgO6b05V3QwGX8NYf8GtOoEXf5EQNiSOTBuU4lO5LZX9oUegX37tKo2rMk2NmyA7pjTV3WZqB9/J4ClOwBYNrF1ahI/wD3azgkwysQVZhtxjrMXk+RWc7+HEq7rYPmc9cUkHlLAFy/1LjmXIjmxLugyVYE0LojWXeXWhTZSwZqqzFPmAi34dnl/5NML6JVI3j+9piwPeo7aQFdNlf+q2oG8zEDUCJPZzROrwtLXZBdC82rfZbRejzzNRVMPFux/bdHrGVYDrqQQMXTtnAmvKoCHYbm7fpn
 kG39GoAc
 /eJKYU7/NzCaiFyvcXEOE/8cRxWXVnW3CurwMkZeZbeIe5MXM8MKltDtP0DC/N+SOryGyFLsPezGJ6K/dmCxUrHC8LYcGu74a/dxhuG9NbfLHsqzXgiH9HoSIFOba1vQ7ZPxnaySzwRtKGAKp9gUEXMXV8hQe5DXrYzdvfJz9Y188PXvAv5l3Mqn+IzjHe4CJJ/0FzevzT94k1kBrIyVAoyYEbLwle/AKIcA67FWABKlu9Q221QDcESwRSdFgzbpHfSYjanLWhqfeSSzCXhZEQ8SOyfjI8cySL9Ks92JoafewuZOKozJk+LCCkVDKcIYBQuofn0W28g99r0y1pZ3MlBEiYPRHChnNE0DVMRWBN5y0OkPf7f+6RQROW3vttdugMIa20ZwsnxMco0dIXS/vasX3BXony1o+cPvjgncFlZXUU721WUIFvIeE3cRQDheTEfro1MX9ehw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
two new functions vma_flags_can_merge() and vma_can_merge() and update the
merge logic to use the former.

This abstracts the check and expresses it in terms of the desired behaviour
rather than an arbitrary and confusing VMA flag.

This also lays the groundwork for making further improvements in VMA flag
usage.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 21 +++++++++++++++++++++
 mm/vma.c                        | 19 +++++++++++--------
 tools/testing/vma/include/dup.h |  5 +++++
 3 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 969594074fd2..68250ece4219 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1612,6 +1612,27 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
+ * merged with another?
+ * @flags: The VMA flags to test.
+ * Returns: true if the flags permit merging, false otherwise.
+ */
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+}
+
+/**
+ * vma_can_merge() - Do @vma's flags permit it to be merged with another VMA?
+ * @vma: The VMA to test.
+ * Returns: true if the flags permit merging, otherwise false.
+ */
+static inline bool vma_can_merge(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_merge(&vma->flags);
+}
+
 /**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/vma.c b/mm/vma.c
index 4b74b48c29b7..05d2c676672e 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -924,13 +924,14 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
 	/*
-	 * If a special mapping or if the range being modified is neither at the
-	 * furthermost left or right side of the VMA, then we have no chance of
-	 * merging and should abort.
+	 * If the range being modified is neither at the furthermost left or
+	 * right side of the VMA, then we have no chance of merging and should
+	 * abort.
 	 */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!left_side && !right_side))
+	if (!left_side && !right_side)
 		return NULL;
 
 	if (left_side)
@@ -1152,9 +1153,11 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
-	/* Special VMAs are unmergeable, also if no prev/next. */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!prev && !next))
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
+
+	/* VMAs with no prev/next are unmergeable. */
+	if (!prev && !next)
 		return NULL;
 
 	can_merge_left = can_vma_merge_left(vmg);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 16c09dac59d9..2fd422789717 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1647,3 +1647,8 @@ static inline bool file_is_dev_zero(const struct file *file)
 {
 	return file && file->f_op == &zero_fops;
 }
+
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+}

-- 
2.55.0


