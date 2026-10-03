Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A502CA5FEF
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8726B00AE; Sat,  3 Oct 2026 12:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 989646B00AF; Sat,  3 Oct 2026 12:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A2F6B00B0; Sat,  3 Oct 2026 12:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 520386B00AE
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:38:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA31D409FD
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:38:06 +0000 (UTC)
X-FDA: 85281872172.10.2828074
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 120FF180008
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:38:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F2iPLloG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3nIVKjzhynEclN8SMOPEIC2Mko8TAeZdToX3iSPz1jI=;
	b=rbVM1YkS5s01osMbaA3N9GMiV/jJfuHQUMM/wy0c5/YXoesJLO8YAt8vYgkiXFEMyBgJar
	JFjncoDpyTWV8L2sz80qZ2qrAlFJvrCg1rWvyBR5219vwvF3BKSCzbzKWUmEmfXTriIT/o
	YyCTF+bh2ygAOd2OQhOnLWlvkidxAhM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F2iPLloG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045485;
	b=jMlu+d6tT/TNFNyn5X1OpDhCXs3Os7sZafIAUgUamqsuZ/6kU502DdXjxGI8sfhnDEVxjN
	+4iY9K1Tdae/w+tz+AH0/4vJasq0rotCD23w7ImbhNXJNlckPCyqLQely/gC8fBQcIRLIP
	bh+H69izQJTOsliHeIvsQILnoOWO7ac=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 47ECA415AD;
	Sat,  3 Oct 2026 16:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601261F0089F;
	Sat,  3 Oct 2026 16:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045484;
	bh=3nIVKjzhynEclN8SMOPEIC2Mko8TAeZdToX3iSPz1jI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F2iPLloGb/hvyWWqpG1HPzcJsYeeE8eL3vHHdxLkgYcJjvAIxwkRRAbLAewGc4cEL
	 4l/3hnJOM7D+kTIlahJbWenKLFNOUD3J6+2U0jdRZOyXDQYEsta8kUoy6CizeDzWYI
	 l8K+MKG5toCehCuRH0wOS/JiHjQjq8dOe6960Q+TZkiQbuNTnHLivCDonNv6CSCsLZ
	 zp17RZMPXr95/XvAsUdwCuPzrHGLHTjBN7vwB38PAOyf9KHV+URfLwXkkjFClkl8N1
	 5SJnr5BPL3tm4yZrJkmpDcZrtAXfcYYjBtc9SIWK69muDO+roTW+d0L1+/h1cslT1v
	 9p2h2uLkTncRg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:45 +0100
Subject: [PATCH v4 14/38] mm/vma: add vma[_flags]_is_mm_managed()
 predicates
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-14-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5363; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ocUM4d/0xmGSQusiH2+i39KWTy4O5lTof9GYTbIlynI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mlMvnlf6/ydOfu9ivY4L9WU+hh57uxcO69zoplFE
 qV7lDYzdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiy58w/I94cpvrKce05EmB
 FqtezS05ePax01y7p5u3srQVpyy8yTCF4SdjWa+/q/9P3+M3D22fcHL+Q2bxMxxvbp/kbH3bfEg
 moY0DAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 3epfreewkhiio7qbby4fgb3wu1mq7sha
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 120FF180008
X-HE-Tag: 1791045484-400707
X-HE-Meta: U2FsdGVkX1/IY0gdBvDIhuniVdIUhSnTvcMhWtVy0N/Wyh94VEZ1vDLXxjblalnF9QBNXiSOQjWq9nySo+0vOEMs/6t7WZuqSvDYcz+8SKL2fUVK8oW924/JtJRlz8bRXlEEZkyp/yqu03mwPcewhMHnoCmhBMEKi+wLKvyyN4Smx1wWxwKALDzIOoxMPoO03xtd0xj8XttWtzSM2C07UWvWfh6/MPhOsna93tNSutht4I3y6ccr3zE8Y8lLqeaRtv7hhlvOrCo/mUgnYyNs/l5o/Hz+QwbwSxqp8yl8u/69KwXduSLSd3L6zVzVzgnCHrWHOM/ruYx2GCeHFrm6G4vbOL57PP/a5xGUOnOYAepO0CCss1uGI5s+U29evI1EUoKLRELVvCjTxKvsxCVJdeVExOoIDPDNbFQY9GQO9O8k3z9xxyO8YAC0I9XOQXMiMM6srAuPM2AlxHAou6dFZ5VaVDQ26PTpgzFimLzWTy85gNEPYalMItN46AqLib4xnJhJNy98bFuLltit0LDBRy2B9pgD01uGzpJFaX3fqwTbi6LQx5jvOCHQroZKMkU6DQQ4bpKDceEJiPKMZp7zki6J5j+buk3uaAEfX5oJGxQdTme1sqO403/McBmcizAVJ3SQ6+sc/SKjcprFKdJWg2GEIiZ/Gu6CRhWdlhbMez1a3RLus1FNeO5iV6bfLIYa6OVupc/qMkmK/Hvs2eYsakpaKcJwxxcLyIr8iZh71pVWuWdlBMCoUEKoyg/ZEeWa9V4Wo9EEVERQia8S61sPkwHrBjiXSmDeOOuB/qpNoIBuqMXcEu/nL2sDwEpbBwpxIlZY9UZR9HL8kGvPAg1UN6RqxRgChOFvHY5kjFtgco3jHVHs+PK5xKVyVD2CsBgW7mDt9zILX3HyaBs+68GUY85ZBwyNJD4Odau1G/SF2ZedGI5ooSXA3DMe8tAz1swlB664LSwh2PwxXRwBuiG
 MALwnZRE
 YyPlOMFj+USDHaCjZL5vjPJkJLHozWepvD2J9nbyYrr9ak4nIvxxIi1RXXi61CIZ36NNEfq/wEakgzqKafMq86vdDf7UdRHp7bwV5o02r0wXILEqaowiz3r2BR1kB+hNLKqplIJ47k8vimPtjZ2RLjMToEk4x3VwIVVbHJLMKl4UUFiiB2OFFs9zu034WiN1fFtLGUeSC/hOCKvZGqTiOZHi9THxY+rHSluyGIQ8lcTOqfF5wYkv67dGdR+ooLUrCiM/9Cij3ji2bEl86HzNCmu/tuWVGDD7uaT3OvnkDRnjCZQ6LwaSZwBz+tUKQpqlK7rBAsENAJAKMpWnmUkZxQLtP91sl+czl3xSp8dp7IiC1P1lueDmAZKKxubihxDE4kliboXDwQxbj7zS1BJ5esJ48lyZ5WDdwuf3l3d/k3XQfjqJca1COl5EBmW7QQJb7dywHXZGS1ZaRMyqukyEC+ithF6N/gKPP3ao0fT8TYnVLppRPzWsf45o381H+Wno6NsjgPXUzs0bp7tepBqJS1zO0tLphtO41dnSZTR1PBFLsvdpVeFa9ldnCImnP1syLemCZfn855lpCNT5inXOlF0el6nzDaZXlXTcIGt/U7IZXmiVWC+fczG0wfl+EdPmcqpW61Z4vz2Pf4fzWWWzKl2DKj5oxuayyANVLVJRAhbJkvSUON8li9/mbWqbSXXsbjdEFPJs7yMCfBJm2qa7pxRDMbx21PMSjWL/nZjP4iO19eswprsVaR87h1TXgwLtWgkMmIyY8kl8j06oAhWLm1pxOnaVaJWQi7rOARdCRb7Gd8gd9dqbTnFFuhU5IF7cArLaIqUXK0UChWqFHpnHHCZa7SfJCIMU2gM87CN1EEJRBfKogyIZuvq+a7vir3fqGiqL07hge13xM3ggcCNmEVMcQjsimw7paJ5B1fAfBuWN7fA4whi70AmdAkoDCOmI2brDJDYgrT1ruNANRHnVdcD3PWzMO
 eD7FynsT
 DpQi4+2RdjNKrwHWimuhF4wcMi1Tkrn6+M9bK8a2y/m9f7JMl3U7pfK1jL3ePe8X43Cv2WvCTDO4o1lvFDk5hgbg08htR/vDdABMTd5eOyy/8aRNWGorrPgjwC/ZteqVBSpm25+bMDg8Tj1qrXbuu+leV9PnPE65XxMdt8MhLqksHxZ8xRx6EVfqt67dclUlwlp5IiRLs85oOgvizfEYfanasbtvRpiqh+uL+CG2RRk9QS0Wm3Qsf2JIsMF1TDVheIvw/hJz4FQDR5CsIeGOQddb6kEokjcigzmGCeL5AK+yXYiqYCrsvm27OaxZlybQmTpsllypy0iqWJylnvHJ9dOSSDx0ECFsf10aYy8f5Heb0yD0QQv0WGglawS63mro46ri35GvLYTFuJZ/rDc5SIDQK78hfB/RXpObaXk0UJ3ooApavzguiINoquYsk7WSbnbX43jX6Fj1ziFg3IwAlG+o3kttONuegk+0qo6rCG6Md/rGMBQqpOJniAsuPQh6TWO80yCls2EtaWeout8pirks3/IW9eqriCbLwb1yyFtn07U/w/FOOuzFABYBqaWvVI1iWsMB07Wp/oxsJO8BYZbnSwKm4es2grG0wJiSWZuMLq8lVJ7anwQEB37xxgNmclA7mKocLSEejzHcWayf3cc3f+ntMrAtgZLEDIZS39FFHO/BPcVXakvCNFarY59Hu5aaQXpehmfb2979hC14CNWrfdg8K6t6fauyBzup77vPPyIFkzab0g5hZGXMUmVwhYSuVVMbqFt73hFcsOeXVeUNtXn+RnBBnOx+25FthjkYfu0dbwFdQclrDohSH2yGYJdMoejulyBfzqdtDFAyRjqZmi6w6oy08TTmaSz+yyQ7w8ghNkTyZjmqvMYsOveAvu0ek1golgz5+7Vc8ML9pBNQ067xfmzwnM5yTkSKoAME8bQ6LzuGow0Mo39dMHnyApmS4orNqFwv2hEHNASTv/PvCEvOF
 41+/j9O7
 bANlh3JE1TqEKEk7vTq84+ohjXyRkGKzjzDRt4TM70ezbUjl9tr+0S5al1CL9ozqZmyVG5O0aEU9uFtD3YlEXz/j1hfdrBxeb6QMvG1CpNd/INw7r2bxN6O5mmYnZto0xKFyRYqZKkktehtm4muRcy4EL3tsUfhFM09BzJaCRNC5aTHVquDyCXKmyrMMdIxLxhLQ4+9bgCM8i8JVwaIF8yHUXAIA5c1J4C+PdfK6vwJJGfCGG8Xpfvvl37x8krkBxAsGEs+6dl44d2vfy9mgAEbZUCP+QZsKr3M1JkO3QSM2qn8VLOs3UFke20xzMNunyjCFsSs21i6XvbYfb5q+FTJdVL3iXuAUI8avinSgJxuDEzCuMAD0BkHlopshhl8w0dO5fkj4iW7s1GrFjYYjn23MQDz/DhLBrP2pf27hhz2y+/nDHDwk9OaAiKWM2pBQtFZHeBoLdQwuyF6Au3M4g7U12ZgkGfXIzE4D9VxGRZCrTE060f7aKon3pbFEbHi7pO1kRbdXV/2QYoxKr3rk636714VrXv4JlPDEkbZzJ8FsnyKh610MrOYcj2LpbH221+AeXSmkhHM5sv4QZd3UIeMV3Iu5lxgfNsekGci0W+Tf0OTigqFUFF1w37BmXH6URYEcXW+LtkDOBmEHYK1HWjpS0a6vACjcxnMKleWgWxsiDChQ5qXJNIaC+yB9dekvlPl63hKwgwINJWaoR9I2jO7ADkrXMX92KU1IGAyEo4+uXVwtWqd22Nt8WpjpkQby/nS0DXlRBMc4dY6OaAVcmry4ZcvwD+MTY/ZrzB1ceaqccRYPQiQHldced80S3paFIkJI1LJ4KcJfEE+kLtrvJEQvCrpXg1uSfZ8OCjC5eb7QjjWIJFfxhyFvlUPPaiw101WRxSDyjASRUURPOO2Y0a1dhbpitsX/wM1jsuwMno+bDzUkDI5Ml50yDtXtUOAYFfz4zEyX13rvSvwyMJiGQFqEDHJaZ
 adcbIshQ
 Hoz8OzDJy04PAGaQIgBxc+gEFCI74hslVuALrhvjuEwJIEtOo7t2kcHnxMga9KtOPXQM4sp071iMpXCIfkmVAJTBIal28PhVWcC8lWgaEFpt/z9c/CUDK4IFy2A78XeZiYVD9gJdrUAwk8IjM2oWUPx7B+86lJIpf3oYBYRZEMGeLwQlIzciPZcKdlbXwZnlxe06Q3Kl9gcn9zGgu28YI8bPuTtGRahWmzCbmySj/RuvUo3TqDwL+fNnLXKtIOeTAyqbYXQMQWfhYeXsWl/LW3RiSP0ui3GUcq/t5Y7XL5V3/vKk/hbw8bLJpxf4HJHYHMwM7ZzeCKLeLSVY3Bxd0iwvWOrtLga/j3IxLgV1x8Zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than referring to VMA flags with uncertain meaning, add a new
predicate that explicitly describes what absence of the VMA_PFNMAP_BIT and
VMA_MIXEDMAP_BIT flags means, and then refer to that function for
determining VMA mergeability.

If neither of these flags are set, that means the contents of the mapping
are managed by core mm.

Otherwise they are instead owned by some other kernel component, usually a
driver: the memory may be MMIO, kernel-allocated pages or even ordinary
pages the driver maps itself, but core mm must not populate, reclaim,
migrate, copy-on-write or merge the range itself.

We initially also treat VMA_IO_BIT as implying a mapping is not mm-managed,
as by implication it cannot be. (mlock() also sets VMA_IO_BIT transiently
on ordinary VMAs while locking them, which is addressed later in this
series.)

However the intent is to in future remove this, as no mapping should be
marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.

This forms the basis of further work intended to improve how we express VMA
properties such as this.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 53 ++++++++++++++++++++++++++++++++++++++++-
 tools/testing/vma/include/dup.h | 29 +++++++++++++++++++++-
 2 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 97e1eb4fe3a4..83953757735a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1612,6 +1612,41 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_flags_is_mm_managed() - Do the specified VMA flags indicate that the
+ * contents of the VMA are managed by core mm?
+ * @flags: The VMA flags to test.
+ *
+ * Such a mapping is one established by a simple mmap() or brk() with no driver
+ * or other kernel component involved.
+ *
+ * They are rmappable, and core mm services rmap operations including reclaim,
+ * as well as population, CoW and merge/split (if eligible).
+ *
+ * Mappings which fail this test are those where this is not the case -
+ * e.g. MMIO, user-mapped kernel pages, udmabuf (pfnmap shmem), etc.
+ *
+ * Returns: true if the flags indicate an mm-managed mapping.
+ */
+static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				   VMA_IO_BIT);
+}
+
+/**
+ * vma_is_mm_managed() - Are the contents of @vma managed by core mm?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_mm_managed() for a description of this property.
+ *
+ * Returns: true if the VMA is mm-managed.
+ */
+static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_managed(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1620,7 +1655,23 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
  */
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, mappings which are not mm-managed may have established state
+	 * upon mapping not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (!vma_flags_is_mm_managed(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }
 
 /**
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index a6a8e53c4b38..89c645a6ad60 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1665,7 +1665,34 @@ static inline bool file_is_dev_zero(const struct file *file)
 	return file && file->f_op == &zero_fops;
 }
 
+static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				   VMA_IO_BIT);
+}
+
+static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_managed(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, mappings which are not mm-managed may have established state
+	 * upon mapping not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (!vma_flags_is_mm_managed(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }

-- 
2.55.0


