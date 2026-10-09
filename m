Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E69CA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5816B00B9; Fri,  9 Oct 2026 14:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C759D6B00BA; Fri,  9 Oct 2026 14:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16F46B00BB; Fri,  9 Oct 2026 14:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 899DB6B00B9
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:12:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E5B280446
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:12:20 +0000 (UTC)
X-FDA: 85303882440.19.0C33A3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 60EB1140006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:12:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B36pcNNv;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569538;
	b=lH07wjHSyhzHosn2YmeY/kA+6WM/+cuF6+V5APWxz43p3mWW3Z8t8i+Kpb4cW/QTWxEVCr
	8UQBUuTE7wuaYIO03A9ZExr7yY4LcoB55M4zrPqORnRPJfFarRTkq9fI8z2WBwyS8Q2COj
	jTRLTzwp5qmLNbrLjRxXM4dkTE9MXbY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B36pcNNv;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZ5vcpIzeMnQD61R3Z7f2Q7Zoun1RactPZJC7NXk5O8=;
	b=5kQVgFP7EVgIiQQNmjQ0R3fM3mw9giExEt1ZDz2T4tXD92pcC+qk91d6Dta1i/GnDtG5jd
	90Jdu2L/0Uz+uO3Puriq3V59ly3V6AA/LfEoyin+D2/vXUy9Dhxmezx6VA65wsRV9QpZ1P
	r3Zehd5kRFcNH5JT2270qSHEj1VwLe0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D74976020C;
	Fri,  9 Oct 2026 18:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20971F00898;
	Fri,  9 Oct 2026 18:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569537;
	bh=FZ5vcpIzeMnQD61R3Z7f2Q7Zoun1RactPZJC7NXk5O8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B36pcNNvjsz/zhdFcUlv9KirsSW7/GJs06knxU38HgJ6J0B49mAO7Fe4kaRQlQYDn
	 fbIfq/4ZW43Owg8tsEjgw8JTiXrJ6extsqa6m5mz4irFrXmF7jljftGaOCgzcXA3Ba
	 TdTtURY0IEC0zLjQeLlEJq1cu7nQcPcNWib5YfW35aAru2ThGHARKxwpqoCZ+Lyski
	 OO0pw7pVFQPI4WVrqqrpnzymrmWQAt0zO680NtPa1LIFqzzE9rkKXj8Ih/g36hSr9S
	 HyOEUjIdhzuSQ6zSG43VfYwVw5cSKjiIAATTi39RG0z7NubiemAL6qtEvojkl/u57j
	 aRmCTtCpOGVrA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:16 +0100
Subject: [PATCH v5 22/38] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-22-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2804; i=ljs@kernel.org;
 h=from:subject:message-id; bh=d+EvKVA+pcfu65IMeGqrSLR7pkk/b5ufT4uPydKYcbA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sx5zWj+db1RtX1++g5OEbMfUbW3YzrfNDxRvXbgb
 YCHX+TCjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExEXYrhn+0a7ZjDS7YvnHum
 XuBC6nyHuYpmVdf2tXu+idp3iGX5GW2G/362n5NtgzrquU329EWFcH43Y2Y3ZvK6paT46WbG290
 qnAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 60EB1140006
X-Stat-Signature: 5kdncjyew3yqinysfzi5wgjmxhmwcii1
X-HE-Tag: 1791569538-573097
X-HE-Meta: U2FsdGVkX19+Kfne7tS5NKPhmhYHk1vX54S/NzmcuV+nhWa/Z9vJASHMqiz9Dc0cz4EEx2dxZwZF3nVaeID4DP14OeV806rluD40xKr4Pw/hIDVlvLzXOH2Fp9dbJaUiQpD8W/7MM4XLwNDA5+ahoTLfHc+TCDhvqwj/NmYeIo3IqkqytTlE4mGYEc6wf3a65m9TSx7BYeIEGZj3ERKrwfBKpmjxbZZ3QyltQ10IiTSr3Jot1DTypa1AnsBsiu9TZvne/PTkE+LeqQMgEX167CZVOwMCklds0ovazuRSpG5SDOTjb52lPGa4gdNWtSJry8bC9zi1IOetuBf++Z+3rDU2rTjmVhN9UoX98gJ87t5+90Yht8D6v+qLdwOFgopuxi7vBzo14veFpYdE56GzgqVI8QfCCrU9xO4FRS0STrJRARnv95i17s5t8YcXdg40NX0SHXKVZgl9qYvzhL9C8D+X21kIxzUjIuchXt4PYYkc+GeGMaOZST+PCS/OuXjdJTCv1XBgXx2j8/bq83q+whqgEvOU9Ilfh4x7Uvn9yC41am0M6FkHXNt7bJ0mR78b+PLdwwOH8/KZhcWWl+bIcYwF8x4FEwOebL9UOtkyVGMz0yHZ0qWeNyBriV5TIrqSnDGz5O48wL97V2IuFqTB9pU3j2wm9asZXwnd2XGcmQrpt/j9uWV0vAayHYMgxzLFksDl3sUkf2ezRjLP9GnVMrhRiygwnCl95FPnUxySXqz7zqAw3R1qd+KBGZTjA4ubodPR8pgZf0NCSxfdFnC7FfsZ3y/bptYdtpfCy0gUkSJ/5UiVHbOIM+qS84wYLJfk3+r8bu84uSBXqEB54w3FJfgsUXUHZGWZwAvho01g+c2i+oCOAtX+zLEr8u/JVyFBS8QT4UsGF+LqD499Uh6ynAieQWHA1Y+7vCFjgSjB9djxY3pl3IJNuFVLLIayf3HJh413iGpoPtLGPfE0T7P
 gB2beb+G
 gh+xECR8n+JNro6XtERdDZRp0Lg7ADeXNeIekQOpMaD7MO+7C2gFFIa/ViGyYTLnL6XecBjba2IB1I2oT8wWui54y/Ybd2W8y8nXlCrjW04V7YdVpBmVG+lxmyrd3RrKvYvEZkIDQu7DDx/IrLpD3O74Jn7/gNrlCo7oEI16b97I0PnzbSA41w0AK9SLlO4FYzSY4l5Z6qJ9DZgKEEqg48afuZ9RwS7G8RSzDb0+Vu7HlbEP4bDMpg7fpFvPT9CMRumkMqYX3iqYjsedJ00G5t4PG7Xizvtvu0+ft1UkGlL4QrXQ16na37imwdfvwkLlmDMA0IwJuE6K7iyCTgyRGs4d00AXbt3mp9AP6Rgbp/TPZjWVq0XKXfDXbtajqreTOC79CMbA2IMsQWOztZfjTWxkxQKcWadADVjWeSRDOctjZ5T87xL9ou/TXvWs/NJwQpKWwHPYe1nfCpNMg0RaBjG4/lWwPjU9PhraahjhwGlWzGR/WtiHuJV/CeQn2f+3rptXL8sdw1IpbSfhfrx4aIpZRh2XCWoj2Rk9O7vbQYFttrL/kjBKmOwfRM7nU1J3NN74fsne/D4jGbkjeZTOHuG93xa+OSUmEDX3Or5FSU57El0eDuqo7mH12wYJ+ZT0R4em1IpgvfPV0ICYCgymC8xXkY4sTYHR+mMN7RX55WHGzdVtUufthGOQrx9lbtzWkt6fJponc1nLltWJqayZJEOJIwQdG++TZh7ld6erGQXxIZJHJjpF/llUycUtP33Xf1QIdrSbTf66L4YS1EvtWwHt6cio2igUhQ5ukD98XZ/RRa+aaoPLDIUuEsb6FgL/HnpKKgH9EqwMy32jDggAkhBywBSwg31ho9poWCH00i0wupYl6R6fYfkRQEaqxHa8oh9v3ui27KJ01jb2wOGDewoyM7nmSmtF1L3FkEeokg0L+CZiozWMjmT8q8p8tVj7ec+PoWoC9t/ksjbWF6CQbMZCjzrP3
 6+ClUZyQ
 v9TSsbOs4qdc5MUQmAV1eQOaMVdl8X1IrcPGiV9AUJx6X6pFb3W9scADRtUDMwpUO8rjWzo0FWFQZfaZPTW+X1nLeImUQgpANJ7qtsAPKeMQmqxJ5TbsGXsyhC/u1SfWyBO3BZOM+fG/BVxnLFdyWM70dA4VKVrNAHlWrSZumVcwy25QQfHfdc9VF0k+8GQtO50aLQ2bJ1MVOWkzfmr+bUjikwnWfhSM1PkuqJD9toe9NVbo4bDR6q1b+vdb8yAbkhIUpIP3BWHghjZwPRxaHkGQ3lyzd3slxyV3w7fBCpgpCLGCvjVdg4orYVHrZlJ/3Wntixmj0aK7wVavqwuc9jQBVXfKXs1gbkGGiGRgZtHgVM0uCbpm6qmLvc0gEdSRNH95CJ36JuLciQG0aCCs53XvZxPGpi4T1oQrosL7k1qwj0GsFq+gTyiklxJbIK0uMfBJgj6eipxRdTeCeAWzJ810iKAN8AHjMm7u9w5cu1sRrkDJY3e8SNsd4HKmfUkExxRDgjsuv9NAH62PlDEHDAJ0o0rYNEU54mbp8TnMfX0KN+ZtCGRr80EQwxOG5irv3JLjWeaAPon/OW0qKmnPtyH1B/zYy4mFWaL73tR3+BNQExSml4FFE2newMeQyKHEA2jrHT/BomQ1/pb3A/CIvNXdVozEXCZd9c4gO9bO7knxzO5hHZGjZIDptZW7+ggyCcgviDhwPI0v7XCDayOlM+FFtAffy0wgcAMGmXrCyJfBOycfch4+3+bBOoR1eNXHU8/VLbnAA0wi18oFzd6NIv2ccTrd7xWUh3F+DSgsR3UQgDr8sbmS1nBCjfTyiRsj2FmeggINYBHmADn6bInsf7ZH3O9DpCLmSQWqFyGnumiam2nG/arJbjFzpYW5Xu8NKE/ITMeCIlfS1eLuekuCO495ZANNT+mUSbJbAZen8CFDXaGJjsepb8FR46tT8i+WosVjSmcxYz3p/cgY2HG8G94reh2VT
 lCbJksEv
 95iIt99Wg0ObeKnVezdu05RZ6whmhdowci7btFuedHZradh+jTh03+4tnDPTwzgSsTCVMFfCXbqBYyEZdKeDnPdprhUwSdMWqqeo0ek2GiHcwqva240KUzRL1sc9V1MRGZaTiBqP5l5Ll6qVO5mHDKvMzq5ga6dW+rGm/mQdRYtx3BKAuZejANeD96PYapa2QMxcvtPyHI5M/I9R7C4OkFNuREddAdbRBKqDTH9VFRH/B7RT2L6f9M6b4u1vEZMnlGXz/FJERoLGpgc9ZXlgfzLGyxPeqohsG9rIS+HUrGEODC9Y+uctK8uksqG2fCyN6gLxJ1dX+p7UIBtMaPG4UOzn1dDEB6Bl/TwVAuKdHayRislSBQAn6Y3lCgKs/QPmQqD3WWJaIhzZriGbG9C6LiA/KbTyNTBcAxMLFm4Kd02CmDuCMxsjL6gnoe9RBW7BJ8JyPW521jQfU6O4oWnCueLAMghd5pWGYHkbsgoOKX95QWJ3dUzBx8+lfVdchJ6dChny83DE8fDrzpYatCwwUCjjq2Fjvbpz8TXeyCPnjCmv0Mg2MOvVmMCo6/XunU44jBOqNIiNflzTBV1apovbt1fcmhUyRZJvHms1c6Ci/1rC+L0cqHyWBj/wcsm6OEaw+UY1lH5Ogp4x8oSKfVEn+40KrSDK4nzb8dGmZvCuMWA0L6dq+Wj7KOTtaTSujY3BcMihSGYkFZKqKe1uJwJhkQb1xUnDswG8OfnKA3E3rMDLgiAODvIIJcoaQatRkgnZYmGH5gvn6bwwlMnsO5LRoQ/CDC1Z5mFkUU8ag+QWzfO6M9qTfj9Suoz9TtomTpWVmdivddQCyCb9AaDt2pO016SxFgbXB9yFGnWHSDLnV2GD4r2mhWIIqfUtTdX5PY5jHANh6xWVpxq2/gU05r0Fs+4jezdv3o9k6m5FpGS1d1KMxy32cKGeBu7f4UsC4DLd4/8QUBlYtSOwBPsdXdffXTf6gsHFd
 JLQk+Tie
 ljPUwein5qPEgT+mQxKxOplVEYHSuuoscMHAC6iFaDQVnTwy9tuYNelvVtD/mMm9g6Dtd+dYu2SxecyOK6Bu5pR9OA0MCcDf1EGUpuVo/RNx4C1LlCBsrRFDyQG5s6Twk3PNPlEUUe89wXSJ0YuN066j+/z8+3nVMW7OtNB0xZKAeNfynFJ82egki3dmp9M6ytuYQgOXQ2R8i3jWkCCqcRX7j8uyCaiwMHeYQFqRAAiQ8VsR6zJCOPIT2xG3MjHT++DKNIgMJgbjAxMs8iLfvblHVEq0KPlMD5bM+37mWd32uDSqHkY8cZMdCaaYp3v5dOk1yJDOs0SAPg8KOfVHf2R/FgQx9a6bRy3Y343CyktQTx5F2N80ELcyol9CYRtybyrEg3NDmGTR/ss+UVW+DeEIn7h+9ftlbVT6MSusw4darpB6qlDcOxmp4L8mGg5NQyNc4WsVPpIHH1zBrsXHEPHokynPDp4HM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently there's a confusing mess around VMA_LOCKED_BIT and
VMA_LOCKONFAULT_BIT.

It is permitted for drivers to set any flags they like, with the VMA
already possessing lock flags.

This results in the absurd situation of a VMA possessing both
VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.

This has resulted in mlock_vma_folio() having a very silly check for this
scenario to work around it.

There is no need for this - just clear the flags before invoking the hook
and reinstate them afterwards if they are required.

Nothing relies upon this being set during the mmap operation.

mmap_prepare is unaffected by this so requires no fix.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h |  9 +--------
 mm/vma.c      | 17 +++++++++++++++++
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 557e629db8c5..4ae08fedffff 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -970,14 +970,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/*
-	 * The VM_SPECIAL check here serves two purposes.
-	 * 1) VM_IO check prevents migration from double-counting during mlock.
-	 * 2) Although mmap_region() and mlock_fixup() take care that VM_LOCKED
-	 *    is never left set on a VM_SPECIAL vma, there is an interval while
-	 *    file->f_op->mmap() is using vm_insert_page(s), when VM_LOCKED may
-	 *    still be set while VM_SPECIAL bits are added: so ignore it then.
-	 */
+	/* The VM_IO check prevents migration from double-counting during mlock. */
 	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
 		mlock_folio(folio);
 }
diff --git a/mm/vma.c b/mm/vma.c
index 39ceb03023e2..4f09fb98a2fd 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2607,6 +2607,11 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	if (!map->vm_file->f_op->mmap)
 		return 0;
 
+	/*
+	 * Driver-specified flags may make the lock flags invalid, so clear
+	 * VMA_LOCKED_MASK and reinstate it afterwards if appropriate.
+	 */
+	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 	error = mmap_file(vma->vm_file, vma);
 	map->vm_file = vma->vm_file;
 
@@ -2629,6 +2634,18 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		return error;
 	}
 
+	/*
+	 * If the VMA is still eligible for mlock(), reinstate any original
+	 * VMA_LOCKED_BIT and/or VMA_LOCKONFAULT_BIT flags.
+	 */
+	if (vma_supports_mlock(vma)) {
+		const vma_flags_t mask =
+			vma_flags_and_mask(&map->vma_flags,
+					   VMA_LOCKED_MASK);
+
+		vma_set_flags_mask(vma, mask);
+	}
+
 	map->vma_flags = vma->flags;
 
 	return 0;

-- 
2.55.0


