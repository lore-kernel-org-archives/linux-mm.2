Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B50DACA5FEF
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04006B008C; Sat,  3 Oct 2026 12:33:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB4A36B0095; Sat,  3 Oct 2026 12:33:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7CB16B0096; Sat,  3 Oct 2026 12:33:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE466B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:33:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15DE71C3BF1
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:33:31 +0000 (UTC)
X-FDA: 85281860622.20.AB68216
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 54C6CA0008
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:33:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MHwTj6Fv;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Luiy6EC5G5foCZ68fFSm152TbYSyvv4kUBI03y6fwtQ=;
	b=vx8IahayYZ68sl41di/TwVIUFPDBvcQuaMTzLd6mfRYFZjsftDg4tdzsddEpoUGJkwLuLH
	vQ9Mz4S/tHeDMiLUsJxE8SBUUd2qd6r6fqNZ6IEX3GDgUsqdJ5BWviHWemVlhVuEi1vgho
	XEXmEEGiP/3yQM1XDDVZl+BJjGOuu2s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MHwTj6Fv;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045209;
	b=xVIAUtMjxWmC4uykC87FREvhP2sg0+uXUpoMBcxHA5kbaSDN1PcWF/fn/P6OOULHMKNdxI
	NuwDRcX2OIsvnqjKxRSsx8CA00d3y3Ts05PfrpM4MZG/qI/SPaO8zOuYV4CtGuLeeYFKQV
	ds/70kxlWG9ZjV6w+3Ebg7s2p7F1V1Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CE9860D9B;
	Sat,  3 Oct 2026 16:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FD81F0089D;
	Sat,  3 Oct 2026 16:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045207;
	bh=Luiy6EC5G5foCZ68fFSm152TbYSyvv4kUBI03y6fwtQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MHwTj6Fvfpp10/DtoJ4BTNz4qh+0nYRXvTvo1D4t0zvsIcWJcALWRBR/ENJ+qbJ/X
	 8KbJvaMXO6QscSNWYiUvOcLoQS/wCdy+ejQgxYcYbCnoifCtKGNJLx677ieDHFBfmd
	 7LwS7GKnnDPFubBfuAb9N8b6FLoCXg+WcJCNmWfHq1sbb6Z5c9UEA6LftDSdBeW2XC
	 IyC+2m8OUkQyT9xpiusQdCZl4VjSipmeS4cMTXLwtbGYu1CRM42Grqud1Kbjfk5Ptn
	 XMBSimChF47g2jiRJCLWAkPXx43Uk3300zF16uusNhv2eNYWKABNfsGFSeGmnp5QEL
	 U/ttzGv1Oe/sQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:32 +0100
Subject: [PATCH v4 01/38] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-1-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=11283; i=ljs@kernel.org;
 h=from:subject:message-id; bh=p1e4kSJUryOEIMmHucmPnH1xL8U7oEe7fTQyV3BOt8s=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6qkxmnM/YpOtVdY4/rXv8GvfBKaiGaLlge8vzGyVu
 54otlano5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABNZq8Dw39ff4sytVomalY6H
 849si5fJyOownT37gLWZf6CBpcEjaYb/gboJdaEPXDg2s0hMaPLZbcNSF2J8JKvi2kXmGNlktlx
 uAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 54C6CA0008
X-Stat-Signature: 5c7raq1h6sa6s84yycq4wuc7a57h9rc7
X-HE-Tag: 1791045209-199647
X-HE-Meta: U2FsdGVkX1/BpkXUIMNsSL6DsDjv4mGb25hddGklE9hX6XPhvXqIgs8t4PMfAOR8gAJrdSkAKrKxK6TQKS01UNyVwQk9awkgOUxfKMTEerZaEHe2eaYsE2g0Y6aUAqzdTe14E7hCQ6eyxYvXKX8XHZFMcP4uFMoo1yoBWScpIgSXjrPDkTnzixkQbwZUuRB36cY+qCESd73bzuavBTnqN4VCntkCEw9CE++LWOvNniXahzQZkCk0gKUN4z3JFpYnkKlYbZiEpPbqHdd5PenUI2bjOFepq0zKUo2aCqZFP3k8FgjoZXVR1oRe6axz74gZVxUWxEF2yTwpg8SfyHKcbcOyfcV2loct58i6BPC84buXGFPds2VKxvt/0xyflFpnllzFySqjQfMhqJWQjK/ypvyDcV0/PbsM/j3cGlE/BVQYwUZTK24A/DBDBZ/ONnxkeam8ZJnHbnzJw5Fjt6X3QbID1H+olwiz69iISEtOMrO2zZFSSDDy0dIMABv1WGoyVaOPha3I3Kl7UiG0cPTpo9rtl4MVK+XzFW8gVm0i1WIUn3SotxhueKd+GNiHEEEe/zvmub1eoCMeoc00lLq9rpllTFhLXXHOB5s7taGAb3aNFdN5HtdjSNn0WEtrJ0d+REmXP8rJ15SszKQDBOATqkj8dQgVuHsNqgS31jX5nq5Q+w3sE1NL9LRHMYCrqNqBhgz2gE3/jNVx2qNs2dwriSrdtSiRZUbBMDhmcbEYKybLBHvuYiv/7EXddfflhUHSN/Jk9BRZ6j3ha94eNmCJk9pusYK7qi3HXsYZIDkfcuomNMXTfMMWvWRXXm4WhBmSvdZ7mtOVBAiqvxGf4pg1+XVcs72nhPlRlvmhXUZrZtP0++QiYixcpX+4QP5/FFwmGWW8NgP9yVcW2YcURfJg0cxo5LtFNhmMMKUMpL+Nwh45s4z44jcVBfal+hxMZWviuVjDj94bsNkDlWlWckg
 9IGn8zpu
 g2OAnjuo6MALVsK3bpJgnEDt+mrAuoOa2sO/k0XWQxAO37UupOXeWJCQTnjuAaZwckvnNogjlM0A1IZdzhrcAai9S6YeQzLzXZtnccJcDr0NZfD9UHzK6uNzsbYv1W7w5Fenxte8841UrCj75y3ScBWMsq0Uu/Q2GXUiZ02Uwd1lpuMTXzE55D+37yiN67I/pdxATbDV8lWB9yUlL1D+DTILGqE/HpUm/dTcj0dUFkPShB98Zn1LNElE5+yR6GwyzNVsBzSKglzZuAnZHzTDh13W8bFeQ//HvCIIqbrytdf2U53/ICQssA6swTyXVP/em3huJszoBppp+AJRqXiAwP/Qpu4bOYi08SOPNhS5i4JKnF4EVu9iSH3XN5d/1+Qjctyp7JXDPnmQ/IYUHUku9Za2kAM5HLWfc4yojRTAQ9fvb6QMWYs49UqaFFQG9IL2lBGKZhZsnYvNNCNivYTcqUGJEoy9HH+LGG3T1CKvWRZYZqNPRnP+4xeNSUixhbnNkVO9ywpp5l3C7EVHdKpNzdsId+uQzZWC9uHszWNWoiM++ise48U+WZGX3s6zCxv/afIoX+oCmiUdE1bDOHVhSge3iyKnk8+Z54vTPS8UiUJQBkN36UhMPEa2QpKMpPUMVwZImut09H0mu4ECgn3z0g0qIoTaNcMuUV36BUhGhqxHFmHQB97E+0YhwSg++XwPDPJz63xTZSgqec9W6XraAbm3mpaThKBu3tMM1RaeR7T8Q2gmNqkfRPcKrdFbACOJjVYFGaTeHeOxYM+4K+A39vmsMqp+CqMtSVhn+RVRddhKqSVlrHiqFU8r5aStY8EWUNPqavohZB6HhrYKlD2l2cLypKSEWNZ+bZk1OYcb8tpcUlkmphfyhDZsEUSsE7EyJDT1/Ho6MKv/sFn7LormrRQqTjTGxV0SAnVAGhLAMfxU0MmGuZKaUkjccgAiaCh2SFIZIm1YwKutoWhNNc/xnxzdhiFfZ
 F1T1cJSo
 oJrlBXr/317NUaXIa0ybILZQNyOMHv8MqZggynvimihbdfMCdP/WpV7ofnqsl+ZRylt98rWRBb0+5qhf5xQRRU5BHzbVEQQJCGRm7/ykC5CZjQE1x6ypY9NvGRFA9/f/B2NLEdr0LMwZg5bQ1mFYq6ZUITbDeGlvIQHN1CAoGvZGpts9SkjoyhoXbGDh1vhlPJCMCljQSDg1IxYpR3WCY1+N86HbYcLc4ltlVEwmLqrhdS09aavH2nBDihQ/pPI0g06CmMxP1CqUz9HNkxKmP8Y1NXSqM+xxQQXSe5oWspXq0ZLFbiqCG+m70xtUc9XBprJ0Kw9iunGjmzEOQqy72bzd8qx4b0ML9bvfKtIn42HYqwu6hbbWwesjPNv2iOsbt/RiGCPpdf4zqpQBwUe15kbdcwLmP8S6NAbniy6kQWT1M/8A+xBgO6sH5heKxLKQ0KZyLgO616NI2/emFNAmcJS45x3Bh/L+WURYdcFfMKB+7VS2jz3Ya7cUdOl7/yhXIKguzfNiI5P5eiubN49e7jwWfLEFoHaMF6eFs51kfGjXBkjtI7MWZRSQMfUVf0hOH7Kw+Zc/BgSiPTJ4d8My4t5IVGeAUMWYprwD+P8YKos4whoQkmmg0PN30Td3CXqa1wrp08yXiDP6AT7y/Z0Gr+UcQ5wKj3p/kjqf9KuTwQUnmZJ0sHvr0klwCNe+2UqgdSlKDv43QmDqC2azltO+7gxJk6IZKcjTIstt0dEB9Mj+oTpV2yGi++VdN4rSFS/BL4fB3YBu9vmaL3QVJrdSAvVaPlk8QeoGFGP3VAtLk5U4OmAPbYKQCcsw/XyrvvMH72Mw+i0Wsn1pPKDWWkjz4dzcXGUAqZ+NCQLi6KKuFH+5seg3ls8g6QCNJUeF8D/OD/yuXviP4hvGGDKfVH3dZrs7aUv3fj41fluZYKpzlDRLPHvekgjxWQa0XljwWJQ3/m6Igp1JS4OMxooDxU5VZRJ0h+4pd
 LTs5M7x6
 L+BpNq8QBjsAagPUxTZ4bBpRW88SSfla2NWVHqB5z/nlg1YZPvzmZlat6+F5J8lr1fKdmrDGzx+51PgCuM/rE8qMRQHduyzhBRdPCqgAwSpwm/WWNPwDnJALmZlHCrRqor60AN6I6jq0dVBe3sxjwVk1vTszgX7ZK6N24NNek01wcg+cdsQ5xC/0LTMENhmxZx8S7OE0Uat8iiCOnxKe16USsqNS0mQuvMgz/fs2PklTCopJtje3kk2iod8bowodC6Azep/F0kmfN0D/Dg6Gqm2hGlc6W/VF9uecvPVL7POrYHASweyZ3byMbYCpg3iKCluZ+poYpPuDIp74KzFHiNyOAZ4u2GRGpjPDYkGmzI7afNZs5cyknAyq9hB8uIAo/KJZNpD6rvexcbfqtZgwfSIeB7YeseoGw7fdtfXELUfgws/+0YpW9mwrgYAkT8P2jLMVSX756kC8pUXtzDcSgYnI689iuPGMpX55xexCuR8oFekKMtM1S/1x0Htrx1H5JkKesK0iHbKQW9X4aoznwnY7EPkjzzEgM6+ogLRRKpCtsWXCheiGHjbooQOVeA+TMbjHHx9QJCR+Z/FWA8qGvZeYCN+BHHfw++N08uWurMFywaIriPeSVZ6KnPuTd47NQylcmGejjznqB/vQHnuvv+bCbThFAgpZL+/QbVuErF+ofEcrWdWi2Ls/BqRNUw17KT8FG52GCSDQT2J+h65CNSVMLQWEHgd2clr2yNKw7sbsf3DMqODMGNMWG13uvinxdZw0t6cMWb8d7P6hNitzqZFfQKBNGCkS47TtXNn150uOY8aNxyu++AcLKEAK2CPiY6Ig50nLODe6xA+m6Y9A89txfjlv4JuOq0ND1lfg4HG2Qfq6fege69xX7paJQ+DbSAh2kSLNrGeu7KeIUsIsEohUKzxsnlOeGzl+59FgMMbNBQ+WbjUhNEW7nO5Bwp9I5qwzlPs5fJewrQBF6c9PSxepPtk9i
 O3IITe7z
 B9QISEIc8F/F7+W+fCYPLRw8+7a48/D7XYFyWTDU6Z8KwUrahxD0NIQgxeICCnX+GPXksi79K4njMbCJaG+7+N7JdqGwKKT/meuOK7hQq+Gl6R+ydKYLfcA2g0hX2RXlJtFTc5DeXMEmHaF8/OPzonXOn2zvTSjIZmsybX1wojMtswhliZQQbtKClOMw8az61nUag4wqgtEqS0JtIFJQkEnl0eUzXvRQEtC3i0FOs+e8WKaK1YwIdf90W8gLuQFEAC11i2uupG1k8X2I4bd4GLA3Z0fgYW4z0fbZem2Gvf5iQI7o0wMN1WraLh4l81zVmJOQg1Y44rYAr2IEOEQN6X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The map->file_doesnt_need_get flag is confusing and the existing
implementation has holes.

Drivers are permitted to change the owning file of a mapping. If they do
so, they are required to take a reference on that file.

The mmap() operation which ultimately invokes __mmap_region() is guaranteed
to drop the refcount for the original file the mapping was made under, but
this is not true for the replaced file.

This has been addressed so far by tracking map->file_doesnt_need_get, which
is rather poorly named and unfortunately fails to correctly track whether
or not an additional put were needed in a number of cases.

Make life easier by removing this flag, and instead drop the reference for
both mmap_prepare and the deprecated mmap callback in a new function
map_put_vm_file().

Track whether this needs to be done by aligning mmap_state with
vm_area_desc and store the original file in the map->file field, keeping
the updated file in map->vm_file.

In order to have the same behaviour for both types of hooks, only drop the
reference __mmap_new_file_vma() itself took in its error path, deferring
the replaced file's reference to map_put_vm_file().

To make this work correctly, map->vm_file has to be updated before any
error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
set this field first.

Also when mmap_prepare() changes the file and is then merged, the reference
count also must be decremented, so update the logic to call
map_put_vm_file() in this case too.

Also update __compat_vma_mmap() to manually perform this step for stacked
file systems using the compatibility layer, and update
compat_set_vma_from_desc() to replace vma_set_file() with a correct
refcount/file update.

No in-tree driver is impacted by the incorrect implementation of this
currently (no driver that does this is mergeable for one), so this does not
need to be a fix.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h |  1 +
 mm/util.c     |  5 +++-
 mm/vma.c      | 83 +++++++++++++++++++++++++++++++++++------------------------
 mm/vma.h      |  6 +++--
 4 files changed, 59 insertions(+), 36 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 0dca33db068f..fe576d468af4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -7,6 +7,7 @@
 #ifndef __MM_INTERNAL_H
 #define __MM_INTERNAL_H
 
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/khugepaged.h>
 #include <linux/mm.h>
diff --git a/mm/util.c b/mm/util.c
index bf0513d1d3d0..016932780925 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
 
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
-	if (err)
+	if (err) {
+		if (desc->vm_file != vma->vm_file)
+			fput(desc->vm_file);
 		return err;
+	}
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
diff --git a/mm/vma.c b/mm/vma.c
index 55917d097933..c27aea6d58d9 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -24,7 +24,8 @@ struct mmap_state {
 		vm_flags_t vm_flags;
 		vma_flags_t vma_flags;
 	};
-	struct file *file;
+	struct file *file;	/* mmap()-specified file. */
+	struct file *vm_file;	/* May be updated by mmap_prepare. */
 	pgprot_t page_prot;
 
 	/* User-defined fields, perhaps updated by .mmap_prepare(). */
@@ -43,8 +44,6 @@ struct mmap_state {
 
 	/* Determine if we can check KSM flags early in mmap() logic. */
 	bool check_ksm_early :1;
-	/* If .mmap_prepare changed the file, we don't need to pin. */
-	bool file_doesnt_need_get :1;
 };
 
 #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vma_flags_, file_) \
@@ -58,6 +57,7 @@ struct mmap_state {
 		.pglen = PHYS_PFN(len_),				\
 		.vma_flags = vma_flags_,				\
 		.file = file_,						\
+		.vm_file = file_,					\
 		.page_prot = vma_flags_to_page_prot(vma_flags_),	\
 	}
 
@@ -70,7 +70,7 @@ struct mmap_state {
 		.vma_flags = (map_)->vma_flags,				\
 		.pgoff = (map_)->pgoff,					\
 		.anon_pgoff = (map_)->anon_pgoff,			\
-		.file = (map_)->file,					\
+		.file = (map_)->vm_file,				\
 		.prev = (map_)->prev,					\
 		.middle = vma_,						\
 		.next = (vma_) ? NULL : (map_)->next,			\
@@ -2447,7 +2447,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
  */
 static bool accountable_mapping(struct mmap_state *map)
 {
-	const struct file *file = map->file;
+	const struct file *file = map->vm_file;
 
 	/*
 	 * hugetlb has its own accounting separate from the core VM
@@ -2496,7 +2496,7 @@ static void vms_abort_munmap_vmas(struct vma_munmap_struct *vms,
 
 static void update_ksm_flags(struct mmap_state *map)
 {
-	map->vma_flags = ksm_vma_flags(map->mm, map->file, map->vma_flags);
+	map->vma_flags = ksm_vma_flags(map->mm, map->vm_file, map->vma_flags);
 }
 
 static void set_desc_from_map(struct vm_area_desc *desc,
@@ -2506,7 +2506,7 @@ static void set_desc_from_map(struct vm_area_desc *desc,
 	desc->end = map->end;
 
 	desc->pgoff = map->pgoff;
-	desc->vm_file = map->file;
+	desc->vm_file = map->vm_file;
 	desc->vma_flags = map->vma_flags;
 	desc->page_prot = map->page_prot;
 }
@@ -2586,6 +2586,10 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
 	return 0;
 }
 
+static bool map_same_file(struct mmap_state *map)
+{
+	return map->vm_file == map->file;
+}
 
 static int __mmap_new_file_vma(struct mmap_state *map,
 			       struct vm_area_struct *vma)
@@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	struct vma_iterator *vmi = map->vmi;
 	int error;
 
-	vma->vm_file = map->file;
-	if (!map->file_doesnt_need_get)
-		get_file(map->file);
+	vma->vm_file = map->vm_file;
+	if (map_same_file(map))
+		get_file(map->vm_file);
 
-	if (!map->file->f_op->mmap)
+	if (!map->vm_file->f_op->mmap)
 		return 0;
 
 	error = mmap_file(vma->vm_file, vma);
+	map->vm_file = vma->vm_file;
+
 	if (error) {
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
-		fput(vma->vm_file);
-		vma->vm_file = NULL;
+		if (map_same_file(map))
+			fput(map->vm_file);
 
+		vma->vm_file = NULL;
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&unmap);
@@ -2623,7 +2630,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
 			vma_test(vma, VMA_MAYWRITE_BIT));
 
-	map->file = vma->vm_file;
 	map->vma_flags = vma->flags;
 
 	return 0;
@@ -2631,7 +2637,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 
 static void map_set_anon(struct mmap_state *map)
 {
-	map->file = NULL;
+	map->vm_file = NULL;
 	map->vm_ops = NULL;
 	map->pgoff = map->addr >> PAGE_SHIFT;
 }
@@ -2643,7 +2649,7 @@ static bool map_is_private(const struct mmap_state *map)
 
 static bool map_is_anon(const struct mmap_state *map)
 {
-	return map_is_private(map) && !map->file;
+	return map_is_private(map) && !map->vm_file;
 }
 
 /*
@@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	}
 
 	/* Invoke callbacks. */
-	if (map->file)
+	if (map->vm_file)
 		error = __mmap_new_file_vma(map, vma);
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
@@ -2797,11 +2803,15 @@ static int call_mmap_prepare(struct mmap_state *map,
 	int err;
 
 	/* Invoke the hook. */
-	err = vfs_mmap_prepare(map->file, desc);
+	err = vfs_mmap_prepare(map->vm_file, desc);
 	if (err)
 		return err;
 
-	/* It's invalid for mmap_preprare hooks to clear vm_ops. */
+	/* Update first so file refcount tracked correctly. */
+	if (desc->vm_file != map->vm_file)
+		map->vm_file = desc->vm_file;
+
+	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
 	if (!desc->vm_ops)
 		return -EINVAL;
 
@@ -2811,10 +2821,6 @@ static int call_mmap_prepare(struct mmap_state *map,
 
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
-	if (desc->vm_file != map->file) {
-		map->file_doesnt_need_get = true;
-		map->file = desc->vm_file;
-	}
 	map->vma_flags = desc->vma_flags;
 	map->page_prot = desc->page_prot;
 	/* User-defined fields. */
@@ -2826,7 +2832,7 @@ static int call_mmap_prepare(struct mmap_state *map,
 	 * anonymous mappings. Rather than allowing these mappings to be odd
 	 * outliers, simply make them truly anonymous.
 	 */
-	if (map_is_private(map) && file_is_dev_zero(map->file))
+	if (map_is_private(map) && file_is_dev_zero(map->vm_file))
 		map_set_anon(map);
 
 	return 0;
@@ -2845,7 +2851,7 @@ static void set_vma_user_defined_fields(struct vm_area_struct *vma,
  */
 static bool can_set_ksm_flags_early(struct mmap_state *map)
 {
-	struct file *file = map->file;
+	struct file *file = map->vm_file;
 
 	/* Anonymous mappings have no driver which can change them. */
 	if (!file)
@@ -2868,6 +2874,20 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
 	return false;
 }
 
+static void map_put_vm_file(struct mmap_state *map)
+{
+	/*
+	 * An error occurred or the VMA was merged.
+	 *
+	 * If the file was changed by the driver (which is required to increment
+	 * the replacement file's reference count), drop its reference count.
+	 *
+	 * On error, the caller always drops the original file regardless.
+	 */
+	if (map->vm_file && !map_same_file(map))
+		fput(map->vm_file);
+}
+
 static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		unsigned long len, vma_flags_t vma_flags,
 		unsigned long pgoff, struct list_head *uf)
@@ -2922,7 +2942,10 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 
 	__mmap_complete(&map, vma);
 
-	if (have_mmap_prepare && allocated_new) {
+	if (!allocated_new) {
+		/* Merged, so need to drop refcount. */
+		map_put_vm_file(&map);
+	} else if (have_mmap_prepare) {
 		error = mmap_action_complete(vma, &desc.action,
 					     /*is_compat=*/false);
 		if (error)
@@ -2936,13 +2959,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	if (map.charged)
 		vm_unacct_memory(map.charged);
 abort_munmap:
-	/*
-	 * This indicates that .mmap_prepare has set a new file, differing from
-	 * desc->vm_file. But since we're aborting the operation, only the
-	 * original file will be cleaned up. Ensure we clean up both.
-	 */
-	if (map.file_doesnt_need_get)
-		fput(map.file);
+	map_put_vm_file(&map);
 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
 	return error;
 }
diff --git a/mm/vma.h b/mm/vma.h
index e97bd2dfa786..f15faa83f3d6 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
 
 	/* Mutable fields. Populated with initial state. */
 	vma_set_pgoff(vma, desc->pgoff);
-	if (desc->vm_file != vma->vm_file)
-		vma_set_file(vma, desc->vm_file);
+	if (desc->vm_file != vma->vm_file) {
+		fput(vma->vm_file);
+		vma->vm_file = desc->vm_file;
+	}
 	vma->flags = desc->vma_flags;
 	vma->vm_page_prot = desc->page_prot;
 

-- 
2.55.0


