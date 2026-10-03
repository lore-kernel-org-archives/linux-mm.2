Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E871CA5FED
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635B86B00C0; Sat,  3 Oct 2026 12:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60D6F6B00C1; Sat,  3 Oct 2026 12:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC456B00C2; Sat,  3 Oct 2026 12:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2489F6B00C0
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:42:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A398A120A0C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:42:00 +0000 (UTC)
X-FDA: 85281882000.18.20D4D4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id F24B71C0002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:41:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bu0qMx4J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCW8kptKJHvp+q2N/tZW0iLTQKnKgdCTxjp4ZUqJf6Y=;
	b=dvJ4qes4lxtSQEUoOQsFJuOWngMM6j8nm/StTit6/UzFRJuooKjADgFtv+Ov/+X+Tvi6p4
	ym9jeJTPeuoOzWW43eLWMIa72b/atzSlubSwnjB6TRu+zfOMGAdsKERGXlcfj8NanCodJ7
	1QwIBz/HGMWIqDbxJ3d3K+JGf8XVt84=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bu0qMx4J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045719;
	b=Ltso4FlfsXpkSKIddsSAusNcYzI6JEUgI+MwIC2eazhH4DwnOi1lvIQnl4ZaQEkHeYdHMU
	84ryz2iQtTljSLJE2AsiiKjADKhM/jUapQ872ErzidCZXcYS84ylh4Gr3xl7hi1V856nDQ
	VTl6297kpqH2LfVQVov2/urjHJcjlm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73E2F60D9F;
	Sat,  3 Oct 2026 16:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E1B1F0089B;
	Sat,  3 Oct 2026 16:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045718;
	bh=mCW8kptKJHvp+q2N/tZW0iLTQKnKgdCTxjp4ZUqJf6Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bu0qMx4JQOhxtpxIynSmOni5bnB06dwjJvCUD8Kmw27uPlE/Vo4Is9g7C29RaKmmn
	 lzmd5aPxssCcKLJbnvykP9DAp3bU6bieT6rP+6UDvOZoo2Dxu0oesZgDomXn2V5jpp
	 3z99eSKkdMr4vlG53Uuacrf3hfNcJ071cu8l1TU1GT+HUWMStD2PvZ4xmZhuewk7de
	 pq498IHwAoDqJ3DgRfTi2b5mgUqYP49tkBNz/Alw10T4/K3ibdQt6R/SCC8mLkpM0o
	 Dds6vAjZ6xrmId/k9GDa+wSBtHRkWS4UnN1moDxWBQ+iqln9uxYKWu73EovtSsTWeO
	 GQ2IfkzegHLbg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:56 +0100
Subject: [PATCH v4 25/38] mm: remove VMA_IO_BIT check in
 vma[_flags]_is_mm_managed()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-25-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6830; i=ljs@kernel.org;
 h=from:subject:message-id; bh=s2r53geS0NaltesL9YJUByd3bw5I+LHl8X62szZtbek=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mmduf762Za4RGvtxscnFPVSW0KWGl9aGMifvGJa1
 Op5z/ZP6ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBElukz/LPuV7mVyfb6RXKw
 X5BpgrfvXf737Mq3DlnxZOnmJbaIMjH80+b8xHWZ41nf8ao1N49Pb7xr+GXVKs9Oy56VHCKvj/S
 e4QUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: txtcyug8k8ftxp7sje6yhhin5i3ke3pu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F24B71C0002
X-HE-Tag: 1791045718-974131
X-HE-Meta: U2FsdGVkX1+F0VkoSZvZzQsYzSY5tyTOTWkbCLPWc7rjowU5M0MLF32hSFRlGPU+VVkZ6D6ksy63apRaS8xKnLPUBlxiEbsxAVq0hlx4XA8wgf7GfRstV2yeqCTKvWg5n92pv5WG/RutAEW40Pq3cRxLRIYWonHNozwaHa4p/jX6qFqSnY138KQnKpv2LL9cb0kTwy68IkHFT4diVu8MlWZQ2B1oz10sDKUbSNWk7khLHq1yi3u4gHuWe9o9qb255hlBdy0eceGqzFbKukRI0T5e1YFqglzdwKb3aLaCGn/4hb6Hi23iLjk7Ex5b0iw47oKQHT4lURKlXxVeeQpA+5D0rf4ZfeCWqWvVoocYXJJPkSePSisdkurERmprXtQNGHLYRqGnzIs6lBt7VPlX0Q3UekgmRqF5N75eUKRHjHZAp22pY3TuukwYFLzi3OtQefX+vY8+/j5FvIf1dpX1Al3PrjrCefmENFWsDm8OW2zgqK9l+XuD/S+YmqlsS3KdihvvhN6ZqBLlMuNzTvlXE3VZ+JrM27+iKfCh31PvH/jNkwabaI8FTETLpEx6c7hn2Y+JqICN4kvjW0yy+VGOpRzUHYUH1zs7M2dEwyE9qd4+A0pitWHBFu+fS8Mx0MkfUIWx/2+xiKiG7qTC2X/rPxJ8Jdz/JRYh0x8o0ABIOJZg3xqpSKJN5UXbw6+GHRw28+hKjPXq3Erz/toDKc9UiU/IcZaXcfCV6MoD9zFgK5/qNvL97M/VBUNA3XBUFhbCYfGaMbqMqpSAkPUOrXM1ZqrxYpAB4zCv6Dg668ZbvlS0aQ804Ro30y+qIfEB+rrZNZAuVwU8+MoQPb3uWEC0SaSnBzhoXG3MyEomByAQCGOMVaa5sSw+JJZ/E1HtlGRL26cFnlu9YrpkzxB0B54NDl83Qj2FJ7q3Jxwsm6zGdSAIyWUcMnW5IfOze2hiZAKt981NCX2WK90eL9LVYYd
 wyq0eyFn
 jGfkoaTpPlphZoDxl9r51itYUYD1N6YZQ6ew4Y75ooiMDT6Fy+2a/aBSbiXM2OT3UdTRox9cflEvEcxnGCVoRcYWoKzA7kQTcZvmIJGxMRmcu0Hu5IU5VRru72Irkzez4A93VmNHyd7aLNt/mtP8mswTt6RUdpuDiqh/2toXRJvxriunZk3hp6myv9H9beMJk3Nuv8vwPqpsDj6dTav5FbNy3uGBsFfZg6TrS6gB4wDh6GM3YUbVOc50FqHmoAH0M8DI5rhiHmzv7QE+EMbRTD+gwnVPcbcNoLcF2SeUcNF6h/lHAu5qp9sFcFWttoWW1aftBNBxXN1tDc4H3G+TnRc5J/iD04OxVJ2PPSQhmWH5dAdZSh4uW/4aaOrba3G6R5UsDr4xmwChbpPont8oRagNRoeKJexJ33fHfAXwBBRB2+LclYW9L9sObgDJdeplpWNlNY4CK/AR4ozvx2gQx+AnuCltsSSZlBQTjCN1VsX1KEQ65IjaQvazIxJcYQOQO6/W2enbjiI0weacEuPHwARmOXfA5m7NzV4GiL7XiJZuzuysuv2JQmfGpwwg6eiwj/G3TkwFOuFnyhVmuhE+F4IBOqsoUcV7xbOABJzyycwex4UPJnCromLqEQzIk4y8Hjo6gAETT+JPi6BPsw0grEdY/yJV2uefTQ/VXcSyBhTMitm+XaBVfZsD0DuATWQS3/gm4xkrOVJ8tEVSrocGZ4DjCh5V+EEpuUIuXNVI0+tx3w27so8dcIEOAz4DfDEHf+Cz1v5kpoPBaJZjDoBMH1OqXWGaAsIBjuzxH4wCFJPmHaP30TTL3gmh47aXMOW2seJwcxqHAit4AedWTmj/48mMm8Fx+yrycrFk7YZT9LD0EF0fruVFe01amhFFdxGeZ1+mI5mOYUr9gt22L3nHybo1X6NnAWCHlah1uYzKmRtD422e45N+qhp58lUp/lyuXTvoz8XDomjYBnAMIbL7AZCx9ZwXk
 caX9Mb2V
 Z7uOHEcu4WYlRYxkmj9i4wVdddyA41+RWNQwEa29nW+w7bykLvClL7H8v2kzzkodto2/2tCf1Yy6DAk4N5wspsZiht62A/OhF9L7yc7cmsDJReWF956+PZCcNYX+MBFXSjef9achtSJhaXa7g1VssQcudUXzQgjlLC5asCvbWNmqliI75ehcbOndoFiLPFl4ekCXbAiuWxSjeEHiz3NCzV0qENy6GoJxlvlK8ZD/STuVY3HzXAijnN7l7rAlfOKdt0gKayYP6sb6BvinqlaqcooAsrNkZji0EryLBjYwF0+DHu2Du3v5ruyoWiP+j+1ZaHhVX5//02JBzh6bZS8wJlUtrPPcz8ROXuNwcwxmTsi9WeA99Ju1FgpHP2TqyiyCxN6T6uBmdq8EPbTJZIwxOD+VVxrfFBW9saepGhjIpGBz63oebLjswBVfUmYdii3qxzOpk3rIKERxFKWl60IN0Kq550nufn5ZMAyiFq6PWcMhII7nxZSjOlFx1HLr0Cvw5tQMRa+DeXHm/EuZAtTfyKZNemLrwVtvKfNx/+WT4HT7kfvzRwMqgJRIaBLZWnzLC35udkfGK5W2wQo6QQvyL0TNJrFMVmCXQFg+5qhmAcBJ1DKwgROW38SXLo0Q38IGCbPA+r9fnqOCjdy/G/8lEYkShuvI8WeAetSSzIzZq3FWrxTMaQrq+S35wGdLazKwrx8naA6CaKq0RETu8ZxjeBvrtBDHptjdqezfR76yEE5jEhvd9xDH+nDPiz8HrTbWofvaQji9YkzO/EwhzivbeAnPsDCJON10DtuB+Yt+4RMxtgPdMpp6fZKAGBQQdwqyB5dLIuPJwPRJmUThw+OyDmN3tbYyFAndpJTmq+z7Ybpd1XDE3xk9lrpp7SwEUIgvazPE2pTU30fmaexk/U0LGOA08gOzPKmiVlJMdJQInrnDp1ohWcF0fY5pSumxGRBmc6XP7cCW8szMjN2R9rEDMjHaaXGAw
 b8/ud1e5
 zK5AXpn1SmR8ZxX5MjsRBdqQukhuzOHDRZ+HzZjle+e1j7OVC7ltnrKC4N3hg8hFd7fFlZDeyp6BUscH/6RVZsdzmtuk5h8PtDnx+bSj01t8bGNAeQWQtnDd1wmGTWIYhOf28g8lG2SLsKRPsxdtaA/BnRhseOetrYSXd7OncKFHo2xVroJdrgZbxtXGT3v4UM7yhM1DCFpSeL8mWw1oCI7CywlSSrOXpSyVFyk5BOcXxLMRKJ16TkzpfnjtJ7/ztVdTj/zDaRQ0OWhUkG+yhzmMq7X0TchakUOwNrYnnU5X+iRtFJLP6dt0nrYvjmFRdfB09Zwj3x4s9R6AlcsxHuXOuyOh7J5GCYwiVGdCH0538gqLeHXA5VC/Jr0MFqRH2dQ8g53JUsbalnFjntluktsV6ZhpbrvyUaop3mV8FA+8yFNTEHV68QVAvGsyxtsvnhFmx7ObO0LD7TMYT9CnXWZUuBuRxqO1DlKVrsn/uWuctHkD6TDeECJmieReML8t4+br4hSJsjP+DBOd0HZw8r3col+toA4umRxWJj8dKhYt2MkqE/DcUoKTcUEM8qsQxQBHp31U3yH4jbt3HB7iHA9qEpOL0tqV8a2ldC4HNNv4Cz/BZb73muSdWHmv2Ea+VvggdtTxXNnYXVEY2m2gCoxLabNCuRfKQkwpJSyFwVQW/WGhH+cKGcCGpbC0Y7HiFfzlnxyomSysYXPO+oM8FYKwP2X2kxXZ4RXdSRvD8+VupGmTXYl3R3m7xxKAYUosQNY+d1g1U/QTr/Qc/c5NjZECkcyfwNMCvWkwl4Puyd6F9UoLTPhCLNA4X6AgYbiEMhL1DdfdLaMixcS+M0dysuaA2tLm8Dq8aJ/HBx6XNpeHUya7+3qvGurD3ku2GwRmcdkAJJlC/m1nhWC3cV1Mh12Zk2Jeiiuw4m2VOZSme4kUdNOHjqir+QPOGC1huiBToOpg7aSXJPFPmCuWUkC/ZWHsK/Syr
 b8NHxsd6
 PnHA35vtgdFMyttLuNG0fcj3NKb+8eKOhoDJF1eS5uFGFXQPfccf0omIVhwJKBmSYzRmozj7yM3Mriw72qT8m0UyFn4/zx1Itb9hdkWGjyWDGB3Cym6MqLjPXAVjwEnFr234QheG68vasq6BzhERtMc8RR4mOjBU5IEwMnbqli2HA8OlYM3ldrn7ruQg5zTEd8n9qDQZQ7UEB1vUlQGN9/aRTTgZ2RnH+/sLPr3diDaUbOL4uN6JxHoXdtaDvVDLttuW7I2e3bAelcOT7eJeVD3KjrdPUEhLsgmqPwDAZxPrCd/3g8lFfBdE07D3E7z9Hv9AlDD4DJJwnD2RsyjE3P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have now made it such that every driver which sets VMA_IO_BIT marks it
as not mm-managed.

However, vma_flags_is_mm_managed() currently treats VMA_IO_BIT as
disqualifying. This was a product of drivers previously marking a range as
not mm-managed by
setting VMA_IO_BIT alone.

Fix this by removing the VMA_IO_BIT check in vma_flags_is_mm_managed(),
and update mmap_validate_vma_flags() to use vma_flags_is_mm_managed()
rather than open-coding the VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT check.

This change means that vma[_flags]_can_merge() doesn't check VMA_IO_BIT any
longer (which is now redundant) as it calls vma_flags_is_mm_managed().

Now that the predicate means precisely VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT,
also use it at the other sites which open-code that pair, so the intent is
stated rather than the flags, with no functional change:

zap_special_vma_range() only zaps mappings which are not mm-managed, as
drivers use it
to tear down ranges they established themselves.

The mprotect() arch PFN modification check applies to mappings not managed
by core mm, which may map PFNs without struct pages.

NUMA balancing skips VM_MIXEDMAP mappings having already excluded VM_IO
and VM_PFNMAP mappings via vma_migratable(), so it skips exactly the
mappings not managed by core mm - say so.

Finally, update the VMA userland merge 'special' flag tests to no longer
assert that VMA_IO_BIT prevents merge as VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT
now suffices.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  3 +--
 kernel/sched/fair.c             |  2 +-
 mm/memory.c                     |  7 ++++---
 mm/mprotect.c                   |  3 +--
 mm/vma.c                        |  2 +-
 tools/testing/vma/include/dup.h |  3 +--
 tools/testing/vma/tests/merge.c | 10 ++--------
 7 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6b5f06cd174a..3ddb463db895 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1627,8 +1627,7 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
  */
 static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
-				   VMA_IO_BIT);
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
 /**
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8dff37059faf..a07a658cd99f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4212,7 +4212,7 @@ static void task_numa_work(struct callback_head *work)
 
 	for (; vma; vma = vma_next(&vmi)) {
 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
-			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
+			is_vm_hugetlb_page(vma) || !vma_is_mm_managed(vma)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
 			continue;
 		}
diff --git a/mm/memory.c b/mm/memory.c
index 45b21bb04a18..6b91805ef88f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2343,19 +2343,20 @@ void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
 }
 
 /**
- * zap_special_vma_range - zap all page table entries in a special vma range
+ * zap_special_vma_range - zap all page table entries in a VMA which is not
+ * mm-managed
  * @vma: the vma covering the range to zap
  * @address: starting address of the range to zap
  * @size: number of bytes to zap
  *
  * This function does nothing when the provided address range is not fully
- * contained in @vma, or when the @vma is not VM_PFNMAP or VM_MIXEDMAP.
+ * contained in @vma, or when @vma is mm-managed.
  */
 void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
 	if (!range_in_vma(vma, address, address + size) ||
-	   !(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
+	   vma_is_mm_managed(vma))
 		return;
 
 	zap_vma_range(vma, address, size);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d87..706c679d4281 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -783,8 +783,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	 * uncommon case, so doesn't need to be very optimized.
 	 */
 	if (arch_has_pfn_modify_check() &&
-	    vma_flags_test_any(&old_vma_flags, VMA_PFNMAP_BIT,
-			       VMA_MIXEDMAP_BIT) &&
+	    !vma_flags_is_mm_managed(&old_vma_flags) &&
 	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
diff --git a/mm/vma.c b/mm/vma.c
index 43d32c3b8f6b..6008e3ce01ee 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2793,7 +2793,7 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
 		return -EINVAL;
 #endif
 
-	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
+	if (vma_flags_is_mm_managed(flags)) {
 		/* mm-managed mappings may not set VMA_IO_BIT. */
 		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
 			return -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 442ea9eb098d..94bf818ad0e1 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1667,8 +1667,7 @@ static inline bool file_is_dev_zero(const struct file *file)
 
 static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
-				   VMA_IO_BIT);
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
 static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index acaab282939c..b26f1a66a170 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -496,17 +496,11 @@ static bool test_vma_merge_special_flags(void)
 		.mm = &mm,
 		.vmi = &vmi,
 	};
-	vma_flag_t special_flags[] = { VMA_IO_BIT, VMA_DONTEXPAND_BIT,
+	vma_flag_t special_flags[] = { VMA_DONTEXPAND_BIT,
 		VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT };
-	vma_flags_t all_special_flags = EMPTY_VMA_FLAGS;
 	int i;
 	struct vm_area_struct *vma_left, *vma;
 
-	/* Make sure there aren't new VM_SPECIAL flags. */
-	for (i = 0; i < ARRAY_SIZE(special_flags); i++)
-		vma_flags_set(&all_special_flags, special_flags[i]);
-	ASSERT_FLAGS_SAME_MASK(&all_special_flags, VMA_SPECIAL_FLAGS);
-
 	/*
 	 * 01234
 	 * AAA
@@ -520,7 +514,7 @@ static bool test_vma_merge_special_flags(void)
 	 * 01234
 	 * AAA*
 	 *
-	 * This should merge if not for the VM_SPECIAL flag.
+	 * This should merge if not for the 'special' flag.
 	 */
 	vmg_set_range(&vmg, 0x3000, 0x4000, 3, vma_flags);
 	for (i = 0; i < ARRAY_SIZE(special_flags); i++) {

-- 
2.55.0


