Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A7D4CA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42FA36B00A0; Fri,  9 Oct 2026 14:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DFEB6B00A1; Fri,  9 Oct 2026 14:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A8776B00A2; Fri,  9 Oct 2026 14:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0AEF6B00A0
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:06:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8346C1604C4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:06:24 +0000 (UTC)
X-FDA: 85303867488.05.C4704E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A287018000D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:06:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+b8wTFf;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAzG9Wth1XJ2c0bU3DI60XqRT1mNgvn5WEld38uFlsY=;
	b=A5Wqrj/RmG00kc5VQcpEEEJP2A/7akfcNJDJhyOF2gS4PjJGVcULsjM/qogNMLU4WQ3O9/
	gbUUbUwK63i+Sp5qcQ/KJwC3NXMwYq5AKZIAmqpkKTr3gZEJsmLJdLMSFVXP8Ahn5u1ZUk
	iwjru1EzexkbnSCrg+nt/5cMZvidL98=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569182;
	b=urUb5MyTKMl5yLHzcYW81xueW07MGhxKXkm+5N7uxYf/wwLogPXW6e/ieQ6T3nv7Rh2Ho0
	K/+qExFxbFe1jKmRmfmZ8ODIaPusdTLlMM53mP4Ikx7Thkm0SR1yr+Ln8g1VsbzeZfDsfK
	0Rn4iEDmee3e/HTD1rJnWAAWwUxHwNI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+b8wTFf;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB8EF41A1C;
	Fri,  9 Oct 2026 18:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F351F00893;
	Fri,  9 Oct 2026 18:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569181;
	bh=SAzG9Wth1XJ2c0bU3DI60XqRT1mNgvn5WEld38uFlsY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d+b8wTFfrUQ8jmcrAK3KmrwEgBliaTXeFDj86MnPlTPMIMnYedIfLBUmim+zSePtq
	 UiwBe3e3wudgLqlmR9vuD68Tayt0xK2rYcueEdm1uHrOO5VMNajbaH0+m3IGkEoFDo
	 9P8vYCgL6KUze0m/6htzdTfZiU/D1x2UDZbLNxsrSVR53mxRl9yglP/jRajhOPeoKK
	 r1Dv7XsFbXJBcDoi9Q1sw7SyZiAzX5r9bHoTHt6zfJ7xcqF/GYmPnPtYysW7rCjNsi
	 EKX1TPRIdDWJS/C/1YvtA8/xU6+WziFiHmsi65Gb5ogjUgzQTQE+10EMp+/PgVWPGk
	 iYMN/rphhdJVg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:03:59 +0100
Subject: [PATCH v5 05/38] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-5-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2708; i=ljs@kernel.org;
 h=from:subject:message-id; bh=W5EJA/cmsVT7jDTw6eYY8+j+S742rFhYZzwOfLirwec=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sws8px184BXlMYNnaRekyN5kgvOVk122ur3tlL88
 KH+koPuHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIqT8jw1UnLrF7Ss+Se14I
 HP62U1T88wUR48jznP0vvqTt5Q6qusjwv2jGPLFPwhc9TOK3Za803r3pQPWzqSGn4vfMtAy9d8x
 4Gy8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A287018000D
X-Stat-Signature: d6gipw8ia45mf4yshchjmkr5cb644cm9
X-HE-Tag: 1791569182-421793
X-HE-Meta: U2FsdGVkX1/EoTBnaJtmaFGqdASMGuId7SSwlWsyVxKN2qdQ3Qu1IC/bp17r4nm/LmBpWOHzmTDOfdWadEhLlwH0GXzVHXP8PD56CMRdp2SXS22bakbtust22q/icl7M9AEKE2cOu02nk7+Tk6UEsGmVzatnBdjg924DaZSW0FrATZrr3VSUL05wqZWTohtefie1M8SmQQSQeXoJYmchALC4ZkKVhJ9LnUfbCENhL1yGinDb650hNym8r20XzrsOyUa3dQj4RKNW9g5iY7yulaVCi6DMcjngOWKsyrwZTyYi1MFg6Xa/yi+GNcF9DRzJfHtYIajICUhtAFr6/7ngk7azfsyQobjf4lzUtMeGQh7ZYLIq5528m4vebt24oxwdWdoDjNuUDW06Z1GkobkZnHYRiVW2dEbPMUQM6nJsoWIaJ/FxKfvUCsoTu2/fyTPRCmj0wQAr87r9FbYXJSX1vNFScAwRzgr5thmBGV3VPvUl4uAD0TAay1oZSBqnTjg9jNDAxF0fADc2BgXLYdbDdQF1vL5L6dfJr4kIToCLDWjZKlweWjw2Mfd06SUqwtdisTXbmJS0T49K9mm63Rn4GJB27HHnhlMrX3UTXRUkOEfR+pSlSheBC85Y0lz936J2bhaYuuSHGkg/KC9DCUXQvMYXXoh+GdeiLsE0j7eSJ/XobI7wU6NeVDp+4f88n9q5Ywe4NTjWqb4G/kd+rTPcEpm96zbUuyq+LwU8lt+LTXUbvBI2lCzlctO0oVzoup7HYv9qh5vnehc+bWz+b3oIOWb9Pi1kpPt4nDPCj/dHm7qonM1mjrHRA/u2AjbnhclQCXlV58YHr3ZnGlUlKq4gQxFZtPaQLEPfyLkIA+gXfzcjfjAMnkte3URrFYfDQY69Ei6lrSjsJU72JL57HUptgT4BpfZdwmDY0cg+rlX9tXbdBULy4J8k/aPlwn5OEjFKgZHXD6vskA7dA93c5oL
 TyaGLPl+
 +oIlkx4qQWjehvPeH4W0AhsB7LMFRv4Trj1K7kP5FbepwvRtpswwExAjPKjxFIEjQSuvcnQbDXXguyaDernP8bqKaRg9e/i7He3MwlwQJn2jNPElZeHePuNQUFPLwOcmcmggTNhUg0/VsWQkF6/4WQ4/adKmdUzwZ+ZsTPmOkUhehDoulsmBVXBNfwXl15EPVZWHmdjmIEXL+lqE7HCOX2JSRHwUZLm+rXcTCF6ENI6qhHDukKwWmGeukKgLcfDUBBcFxfiZvruJ3DqCrmLIAtI45ltLm7QmMw/JfIa1KwQvPljTZ7A8gn9k9wR2RYD2R67seXTEla3PhunXN3uDYy4l8X0VUY+sS4z7swcpmZExWR8NtJeLR1VcJXKoomUKXZq67YbrAd3t8i7qWR8duCu4HtT8BmrpVgNF9wkxJD3fwUGw/T0mQoJBmkIfpG6NntIaXBazNI5eTUSl1f4ozKZ9mdQuNRI//5s2QUxCMS08PSIOcvR16NihHo5G1bYZcNAqMQq+gJfxAQ8FyRVLNH+JH08B0i/bjarhtiF1HwPSW8vQc/gbF1/PTFHzSZ++1QkCviyjX5VRUlzS1bNpspk6rpCr5GY2xc5FJMNHWJ+gQNTVm2fa8lC/fONASxPLcTBbmLERjRkcklu7/kerxkPeRqEYLBzlFRTh3BxWj8fO6PJbBDtOcnWQJo6sq7Yt505RfjyxQBA1+8uzOpXwxkOaG4pviIw8McM0TPu1/E/3EPJ1U6z1jgt3A8IRcV7sTbR3jwr6gCnFnXS/948wYpT3unHgsb0lb8EGsYlwgZ4bgciGSfr3CaU5uSzp6o3NzNikjoSlSsrJ++rEa33cbvdBTRYBN/qepor48IJTmXXtNkuTH/c2ikP/cgstCJv2Ere43IJ6c7sCDI3WLe4ObpDljct5nfRp4GcirikVxSXOuNFSVsNghFK7BGTv3mZI1IInM9rlhuhX9MjghtXUPNiC5xO96
 MDZkaIuG
 VAI29Mat+GpfWNGDXW5vWb6NNyXS/QakHRfAMfeTcPoJH+EzWN62Ztn+EPuEGXIfaC+nZz7ciHioJA+26pHrwGL151yuBvHNDsiSkRAuIDuhzGdctlwyufOqDoE0s2BhAppMWn6Xz1aUAgc4cMXaDoQs+NKecg5vtMU7GtIrsuQgr0zB8LbaSvvDDjVyObLpds2Krc1QG8DH+kb9lejPFxISqi2FkPSixCy6Il4vfnOcq4xoGoltZUih3WI+nq9edHVn5iV+MPIx9gyX5RRetGxxigMovkqmjZUjHOqnkBQp1XsFpcD4d2f+mS7vR3TcoPZB/K861yiVnta4e1Q/QrMYsYsl3Bc7X7fshBpll7fomjDrlesXo04Fu4U6C7SI5Gwgrw2yButr66Dz2CLtjU7TZ/Epw8xp75kvuOhtMJqMiZunfhMixXe3lurtwDtgPGM4lsWJNRjOwBmKoQbt0IR21G8sdG1+zHfgpBU2AD4baBir7RQ8vbnqfcgAsrY4gYtOyuM/OxfKEKfQnMP3SvecJohyU0BC7cuLF1ySdiwR68GxuJ0iLk3xI73WzTmgjJVP+YnkVnyNEXLG2iKme+5MP81UHk/S6Eb5eDjrHdoqRFgK6nYxxY9lM74om3fH729SDpZhS58/51hD/jXvWXC6aTxYP5v66z+oYvFfZf/M/G6dlZw+rsgUN8R38y3xNnjD4vGyBWgvJhVEMnUOyG+M+uS4SjLx8atiOtMM7VDEVgFpUfSW2oP6IUkYWyscKWKdQbQmoRYElTnflD6d38E7/CX5w3Rvpg/WMxzYqbUFT16/HceTwYnhyp58sAERDhZekfT/cODsoKDocEeK+WzXtzadoTNXNVdqynd1FVo1R6ukCU3yFblXPRPqxSjqY7yaGmyXp5zVQ4MhUxViVyaA4cqFc66hOdHD0RXczAJCYL/sNH10INpZ6pOonYHkZG6rG+/r0ti3MaI5li2+2sxmooaO5
 0oyPLh8L
 nbjv4JK8fc3y7/GWqZV3nOH5QULteXBg1AKbE7GbrvAVEjDXJmp1tTnhCcbJ/OnTPH7+zEwfYvvKTZpPNy9vKKP1GRAxGh6t9UNnk9fzlstSwMpuvjIkX2F+U1ifzAWbkXf70+H7jzJT+yPqGgKNtLP9uPDfAqRI4EVVaVrqrPLhwywmvOe5vR663S4Gp4igey3/0L5IV+L99DOeHbGV1BEn8uB9ZUm6jBHrNwavXvRN4bbo+28nK5aHRE0FrKoczNxcpvUB7bNVuDZgRCvTCRpCpZ2LTSaZXWUoygPcPCQQIv/+ZbAN3I79QmruKZ9FkJNgRWXzhzUqB2K5wxVVINeVZc21xyU/+A5wh94vOH/YsSX2evuCstq1O7EEyGiNX8+AU0lI/5sb/uVU6qzDcUnsG4cV3RPOGavoVhxLxOJ3fBaIbO9X9PTyZim5+G4Swz6bDJi8KTXojM5ZhqOsQthnQGPa2vGmCfwqhK2onXl2X8u0XfMPlr7Ix/Al9FD4vmd2Y622cblsmWDAPb7Fr6xXKE1sbG3RlSVBTh2U1VK98GpKOb3Vg7Qdq6iqhM8Wek7twS5qks9DuETPjkcCO9ZNK5f8WlSaMyrwmJWl1mjZdlPgZS8gZLAdaCHJUol24EMFA00X5eI0dOr7Q4kr5xSDPHVBoO65ad3QPb3pLpFN2YJmm1rtkykPi3d4EuE0gBMVwQo46cU8isWETdoZinG19e8+oZ1N9krYngeqArfYfZZeBchfcr9f4i6vaLKzkWb3oFr3uTGR9LC6Wz7aG8F5uLua3/mTywFBdIGuBRd8qW/jxmiQ2WjgEwcbki48ruEFC6c8GJAlS3OHSmT/w1Ggmd7hJ02VgpNGapZdF8hvLRNZoPDfVD59l8VeU235PWHfDnNkuocXDo/yuAxWRHffD5QqhbRXgctlPTWnc1lekGvG6kVk2Zs+FxoD/qzJpYJ6GxN/cQu6yGQY3UTYcZ+ExC2na
 e1KabFbj
 KKAFb8TyN3mjsfFjHx78lkvsfAQpqpJR9/y4gt39E/vzib1gEevPQponXpPTtQjzRHriEdVEeYTgpgeM8Drp1Ugt6FuzqpstrsYp1efV14x0Gwg4qYhTbGnTyIcM5GuezaLKXraWKj7xDMNKqYjgsvF/NdzWPtgt/YgLjEZxjNoGuUapXx8pyncJIBAS4Iwr/N3t7S6gCk+nYaHk1Y/WUSdka3V6yVevLJQuJRtNQqctlLcQ9n1iYWQgqZ/ptsHf5aFmccouNC3TL+2hG9j6u5QbG3bxisB52KHsC6ucw4EImPvMVbPPw75s46EFX/e1uHPZuu51j7lf3zeNc42s14zXBAxnZci41BnvNIZGTI86mUfOxPJmpGrxe5s6qcQl9uYTs2Hez0AxbRZR5kL7+wuzu4r67kHrjsMbM5kZNSa7/8s7fdj5KlzHhEWpZzYqQSvB9yZNzyUWKC1yI4S3tpz23JHdWMkbP4LhHkUkz0c2z3EzRTSukpG1tHVSQUXF3OMzRj0KtBRiWXmDTmD4rXhFkchF9XnjltgfpMOXCnElqVCxfTDfuW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no reason to export the symbols for these functions which are only
called from internal mm logic, additionally there's no reason for them to
be declared in mm.h.

This patch therefore removes the exports and moves the declarations to
mm/internal.h.

No functional change intended.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h | 3 ---
 mm/internal.h      | 3 +++
 mm/memory.c        | 2 --
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 68250ece4219..0c17f0932b76 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4768,9 +4768,6 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num);
-int map_kernel_pages_prepare(struct vm_area_desc *desc);
-int map_kernel_pages_complete(struct vm_area_struct *vma,
-			      struct mmap_action *action);
 int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 				unsigned long num);
 int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
diff --git a/mm/internal.h b/mm/internal.h
index 061a87f9c3fb..fc4e249e2343 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1512,6 +1512,9 @@ int remap_pfn_range_prepare(struct vm_area_desc *desc);
 int remap_pfn_range_complete(struct vm_area_struct *vma,
 			     struct mmap_action *action);
 int simple_ioremap_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_complete(struct vm_area_struct *vma,
+			      struct mmap_action *action);
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 926276d41920..448342883e9d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2628,7 +2628,6 @@ int map_kernel_pages_prepare(struct vm_area_desc *desc)
 
 	return 0;
 }
-EXPORT_SYMBOL(map_kernel_pages_prepare);
 
 int map_kernel_pages_complete(struct vm_area_struct *vma,
 			      struct mmap_action *action)
@@ -2640,7 +2639,6 @@ int map_kernel_pages_complete(struct vm_area_struct *vma,
 			    action->map_kernel.pages,
 			    &nr_pages, vma->vm_page_prot);
 }
-EXPORT_SYMBOL(map_kernel_pages_complete);
 
 /**
  * vm_insert_page - insert single page into user vma

-- 
2.55.0


