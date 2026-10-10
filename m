Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA9FACA9ECA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 22:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FF786B0088; Sat, 10 Oct 2026 18:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0F76B008A; Sat, 10 Oct 2026 18:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379556B008C; Sat, 10 Oct 2026 18:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 10B976B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 18:00:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68CC6C02D4
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 22:00:28 +0000 (UTC)
X-FDA: 85308086136.05.9B98B50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 85A58160010
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 22:00:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ffP+TPLt;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791669626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2jYfqmPt2es1xuCkTol8NOahRHgRnTcTOUiwhGzkTU=;
	b=NR418Wx/7JFjMPvk5zSO2DiZc404qy4+t7RmqakBYJiWBGVUReIqcow7ZtOrR8GpfZwiqx
	Pp7kRukSFNoN8v57Fwt3YVt8kZZ6bTYaLql/hVBwW4W4oBRjVHDlGi8AIkCo/B+oIw05kV
	nQ9CTdSJjyXGuJT3XdgSp0MUG7R6NE0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791669626;
	b=KtmV4aXgIegfLVgAYUtqbsQLg2puYV4t7tjk2tLa0bRGoP2HEKxN8CzfV9Q0IvrYniatRq
	j4IEE46NunMEMP7O+JWkn1P4eINxozGI17/94H3ozYUDC1Ty4ekWMLpKpKN+utAP0gPZgQ
	zft76FkBAQxSrFu5D2KExZaU3SnAEqQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ffP+TPLt;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 619E0600AA;
	Sat, 10 Oct 2026 22:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AADC1F000FF;
	Sat, 10 Oct 2026 22:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791669625;
	bh=N2jYfqmPt2es1xuCkTol8NOahRHgRnTcTOUiwhGzkTU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ffP+TPLt1hBG2zdntJGpA4a6eo1Kktyl63gUdmTPWoDV5PB8j6QZDH7O5pu6DND18
	 83jrFOWryJ2h63yrCPBw+Uh9wavAQ633twrY1q8Eu4fcsINr1B1dFygd9ev9/B+B/N
	 PiED0VbjIV4o5yPrrgsINTWJg6/2ZfXlko4ls4sM=
Date: Sat, 10 Oct 2026 15:00:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dennis Dalessandro
 <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela
 <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
 <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya
 Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert
 <dgilbert@interlog.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, Helge Deller
 <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann
 <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan
 Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul
 Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Chris
 Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chengming
 Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, Miklos
 Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org,
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, Bert
 Karwatzki <spasswolf@web.de>, Takashi Iwai <tiwai@suse.de>, Emil Tsalapatis
 <emil@etsalapatis.com>
Subject: Re: [PATCH v5 00/38] mm: make VMA flag semantics explicit,
 eliminate VM_SPECIAL
Message-Id: <20261010150020.cbd6ce3038e3b6d72e2c92c9@linux-foundation.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 85A58160010
X-Stat-Signature: ogyezd5a7o3oy31r17wiimcd971pe68j
X-HE-Tag: 1791669626-7539
X-HE-Meta: U2FsdGVkX18VpCpiFzSXEtAJHJpdMBnLaX+vMmfteRHdG4u7zP2uLUKJexJswFJejmWsvCQ78f0OKD7k71UBCuqvrTdSfnhxB5okNQHw4C6OuvOqse+RH4cb+pYnl0HIw7bPj6gzYrgrhGztd5j7go9Mwc2iRiMusDX+lMuobLK0nfYYSo++uV/lrabzrS4t4WYpQX3keA9WniVLd+U1arhOhkam5mWnWNcgyxVgshx3acKni9TY/RgvLvypvTaa/EnGVPYHHJaqIkev/R9vDWYEX17ZuqNn2pOUzGaGqKMGBVnlHprcucIZf83x1WbinU/Iw1h9smut9AWcAXU/WJ35M3KPA5iEhQ38umKB6563t341MEsTiLQm6ZLTARjG5+w4C1N1Z4v38ziWiQSz+ygkNmCV6lOsPsiZ9u6iAi1CLKu2F2SKjE9wGTaKp3x/eHu4AkYeMyMiDS6OXLISyAUm+l/ti05RULtmYR2msFL4eOJ6s+AeOt0TaDVbZ3MBkEvk38PT0XdVYHeQnoMoL4cgJUvrQjoUCBUZfQJYKUIwn/Z1iq6UFHWmd8zyfnqZbkg1BY++6L7XaMml0nIx1fElpmQGpyNHGqe3Ts0eO0sGMtwLWswlb0FxsdSGPIKrk3Dug4hzPc0L73o9v47KlAVRfehtk1348hp+X34NZ+RB4F1+QLRLN3ayM2355lrbSnnBg3OOczdjafhZq9p9r2UmDrtnvb7/7LWEiGnIUiGMa3Yq2txJT8oZpov8SOm3CY6iljM+0RMLgwahC7Lac56R+I3Cq6htLUGOdtKpd51l0wvQPWlvCu1N2DXjrTaicqtnCcirTB7Kt2tyKIBo/LXQEBl8TzFz6f6yv1SAYyquM7f7gpcZLMp4TxXo/5I1Y+V9VFpBwldhNc7DgHtE5lyA+cxoTREe1TUeQFn5N+2zA94TuZLhKGTH8ftDDZmdoSLEBJcxYPMHfF8+N8U
 clS674sn
 iA7ngZb8VTBV868KzNo/mdS+ClbJNZ1E0TUvfWV/Me2FDBL8xH9lkhM71NPRnZrRw41GMAA21pM6Kh9gOkB+3AhErLaQydK0FwW8hnTcWuW2gunIhwKwjEACyTjISNdj+5ZHx2CDfPDrJRWfH/sS+8HeEWnaHDo4dcwmBjdWlOynx3WSMDRZAhb2row16smMDfuF/SPn+aQK++MESSUGh7ru2ly8w8XbHQjKGIy2mmXdA51BPmHw2lFdIhVPSESnOCxmOv9Udodz3FdtHaodCytOOyQ4F3FUh7DeNRf7F+4KDpiioBh9lctvOFxugFgC9oAEUv3kWxRXNPBqAzXsbqKYvoMW7GWTdJjxL2cs9AaU2NYbcqJ9G3g+uGQdqBmdQYlgGw5PXQKiAmUaCQmvTaaKVEEL77Y47ZSJdo/KZwtgd/dLBr2uAQ5TYBNHxSxdvqdSPuv7QQxkICYfNY8CSoDVr2tliBp23r9ClGexovwMTP0UTM/GeLj/3ZaWsPwo3Bb/h2uKwmEhKwHHTqRz46/jNzdCI8ak/GypRl9ifRi9WQv8xdN45gZkEdOp9Zivr84aWKAkve+TI7+km83cemMWhgpQ/BiLGVwLyNcWZbrxorrY3V8ccs+s+fkBdpXEHMczooA0MJZ+ZuG6Ua277wQQR6aFMVH4bhErvf1i3JO+KBL6Xa08nnZ2+F6AYrkCZjAqgHZsV8HJkxtcDglBLDkfcDrUYb3B1TivUQ6MWAIbgQylJOfb1pOK0f2yuIugD4PhW2l2ty8CvPM1NJkPYgW8lJX8l4W8tvSn5QKyuW5Wg/w1q+U2J1uGQUhjVaqW/tjTLWvysDksUoOvDaLAnOpJKv20zG/TBjbVp+ZMRIyeoHXLvjDpELQJbU4OH89FtUJIQNJwboaEvpYeh/TSQ/FZI1XUyjot5cIzttZwmCIYIDL/lEDROgua9CnODxGxoSllUNBBbL/cfz84WmXyNIQUmc5kn
 5gkmq7XH
 QJbqWtM4dy59A+owyFd6nw9LkqTaZnwlAY6scvPMfuGAFk0ebkzbURJ9kgefLfBqda2RNznGJO0H6yF2vG/R3K0g6sXdbSS2uaeKl/lSMdC7Lciw3CS7azG91lCrECY3p81vQjPgn5KCs/1KpQyD4lfBIyFoCP7wB2v/+NqbiSktbeBKvDq4G1fdF+mnsS14RoE5R34YMJnyXXmjXrGKvHRLME+MHVRH0sCe7bba6dyEj6W4VxRXdMoMrdkyhlJaQFFC2N9rLhD3AFstf6oEac3drF+Q7GQQesxSOIPny8y0IpDpIhpEHMQtH3O7+jg0JkeQitMOIWZ2dkTZ8zvMNPuQ5n53IdyIBk90yofQtz1+YRRjun94hD6jNlefGgcNWDe97u/jqBFDjt8sUJ9gxS7y2psOlNtAp06/ZanDuPvOz2oMl9tlu01JcMKGrI/+mKoePpEAsvEMCHpq+MNujoRHgIphXDV3ALi54RGKg4DeoSGFyiq2vJAtGkarsBtI64+uXF85UqGkGNQfci/9xxQq9RHptFzhmhYM1C5D813hxi7rjXXtTB/L0F6+81DHI399Ry+TbEhjQENYNtbIKFXGZKw/Qa6zOxOScJ9ff8SHPwb/s9j1Glvo6uNXT8VmgD2G9oGE5AZJdN9UVP97OESbDmy3KTDUQprAXupXIf+fg2QXCWys824NBw7tIHoiD+Iuv1Ul4QjOA+nYHjcNnBL25/svu4OrbQNad952KDBLxHE3v3voMHZI/sll/QUHYM1QfMaCGgVLlQEJHXA2nPyCDmtsFwXPawg9hLsqHm+icO0ODkRrtJ2INSVv/RMwHrCIfu5ipDZb0E9SsKI/1sKmF/PKLjfr2wiZNDmX0R+ibWKlKPWPzxkMW4FqHBhVhKuTOLgdI9R8URbgLrT5CQxWsnhN+OS2Ur+Uy7i9M8L8LmMGtf6XDtZIiL4445IYt5GjO48X0SjeTKqD+USTjREk8Hlxk
 u4zCmOp4
 bKMqiSqEAt8IlMi6S8/bZcTzaFgExCbTtUgQ/sgg/NK+7RktUFfs62U6Pk5ujYUUbRPO1njQZZKKG1PaFQhNXvwBSr17gmSvW2v7WK42BHq0n2L6OSpHgWbBo6suR2msVMRCrz260PHoyb8RjjnFxCkhpXfe3vygIa8bEOTv8H6qtMsbT9HQ1OTrl8RbpTw4Js7k7fu5VgFr5M/dIQaUQGPXucQ/wHoqxdZH7YajYqa9b02AtG6Xm4opVmvoPet7z0Nlx/yVxRxgFyKuYL3Fa80fT9DvgieK1BxQOGMQBOlMWiIJvY9uqdjdB4M22TzPuf6r6fv6pdxKWt/qcOZRmo0Mzq9SDWUB9MENJkHC2Vmk4JP7YcCXZ0j9Q6/IdLInai0FTbu0Q6f4gtC8PDlPSsnxEVOdRYVbyCgh33CPPxypQVH+CJvms/6nnsisMWZmY9UH3XOKOPBHPNImk2KKY6INl6yCZRqgglqDg7aSc7apv6eGkQkjtw5vxX/BphRbtc/kYVvZKNtMypwpX6TMnz0EMSPn2+HALy316r4DrDKeCI45VUPx3kuRuc3lX9dTVuZc4St0YWJ7flZvxzxxV9D0FAOm2cOyGYtngRkNw+pCb1MmUIiD8k0GKdzQxXTPX9LSrBR8B/7Iy3NQ97AL8jZu7D6nmWOgQ04JkHeQGRgcZ4YFJr6jgAFFT9bhC6TOIfdAnJixiYSwPRcvYJUszLTNM9XZE2iqj54DuPxV6IQIdeCoq0QqZvB++E6DGxC7tnizinfvoXaoNlSI+CD9k3uuTEjlv7e598ZXjycVeMKt+pBaeuucEiOu6bezaF3hj8gicNibEw8trOYcjHEbMc9RNg0HSOIpzSgo8R4MYLBRR3Wjhg8iqY3e2Ul6eZ+YxjwDzKx3BNLm0ZrzBQ25b7ez4cAAgTrwOtOd7i+Grebw+UrD7yGRCg2DdG2U8X352vewo70HSXXQk219/Z11nvRukPkdb
 3TgeMyNr
 oBKbf98wsH5gwSvbkcdirMpriRcxsfjYYb2af1MZ/WVj2dp0WHKSPdqHxk37weoAPLCSglHuswYInIUjih1ZmuC7A/i+GtWnm+W1mvtkflHkaOLw6yZ5zqdyXsmOEYARGjg3xnf/fYktq1hX1WH26F8UDhi33XHwGkRQPOETw+Z19oyQNMXSUDJ01Yc+kzTiMs3n26/4ohNefWEjK6ma0PB/craCIsOJRwbVzal2CD/1mZfXLvU5S3IzMk1DdDO0/J0JxxeZ3tL+/jBZwXMS9tdeM4U83bPidr0iAnPn8PEvcKmUD4nA4t9JYirLn9fGsNYBDHIQAAVy+hbnF2pf0YpLUH/Xzcacs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 09 Oct 2026 19:03:54 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
> properties:
> 
> * Is this managed by core mm, or by a driver mapping MMIO, kernel-allocated
>   pages, or even ordinary pages itself?
> * Can it be expanded or merged?
> * Is this a 'weird' case like mlock where migration might race and we
>   'have' to set invalid flags to notify?
> * Is it another 'weird' case where we just want to stop GUP from touching
>   it?
> 
> Driver writers have often been confused about this, and who can blame them?
> 
> It also interacts badly with the eternal edgecase known as hugetlb - which
> sets VMA_DONTEXPAND_BIT but doesn't also want to be treated like a
> 'special' flag.
> 
> Another issue is that we cannot make sensible assumptions about flag
> use. It's not possible to assume VMA_IO_BIT means iommu because drivers
> abuse it and mlock abuses it.
> 
> Special is also an overloaded term in mm. VDSO and VVAR mappings are also
> called 'special' but they're special in a... special way.
> 
> Sometimes things are called special that are a subset of
> VMA_SPECIAL_FLAGS (VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT for instance when it
> comes to zapping or vm_normal_folio()).
> 
> There's a specific kind of special for THP too, which considers
> PFN map, mixed map 'special' but DAX not.
> 
> It's all rather a mess.
> 
> This series brings some order to things by both limiting what drivers can
> do with VMA flags and switching to using predicates that describe
> behaviour, not arbitrary flags.

Thanks, I've updated mm-unstable to this version.

For some reason, new versions of this series aren't applying when I
drop the new series in place of the old.  I made the same old bunch of
reject-fixups, so the below interdiff will show if I messed any of them up.

> v5:
> * Applied tags (thanks everybody!)
> * Updated 3/38 to fix a bug in __mmap_new_file_vma() by zapping + closing
>   the VMA before setting vma->vm_file NULL to avoid an i_mmap_writable
>   imbalance. A repro was tested before/after and confirmed fixed.
> * Updated 7/38 to make __map_kernel_pages_prepare() use
>   mmap_assert_write_locked() rather than the weird
>   assert-on-mmap_read_trylock() pattern, as per Suren.
> * Also update vm_insert_page(), vm_insert_pages() to fix the same pattern
>   and to use the new VMA API, and converted a BUG_ON to a
>   VM_WARN_ON_ONCE().

Here's how v5 altered mm.git:

 mm/memory.c                       |   20 +++++++++++---------
 mm/vma.c                          |   16 ++++++++--------
 tools/testing/vma/include/stubs.h |    4 ++++
 3 files changed, 23 insertions(+), 17 deletions(-)

--- a/mm/memory.c~b
+++ a/mm/memory.c
@@ -2611,10 +2611,11 @@ int vm_insert_pages(struct vm_area_struc
 
 	if (!range_in_vma(vma, addr, end))
 		return -EFAULT;
-	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		VM_WARN_ON_ONCE(mmap_read_trylock(vma->vm_mm));
-		VM_WARN_ON_ONCE(vma->vm_flags & VM_PFNMAP);
-		vm_flags_set(vma, VM_MIXEDMAP);
+	if (!vma_test(vma, VMA_MIXEDMAP_BIT)) {
+		mmap_assert_write_locked(vma->vm_mm);
+		VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT));
+		vma_start_write(vma);
+		vma_set_flags(vma, VMA_MIXEDMAP_BIT);
 	}
 	/* Defer page refcount checking till we're about to map that page. */
 	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
@@ -2626,7 +2627,7 @@ static void __map_kernel_pages_prepare(s
 	if (vma_desc_test(desc, VMA_MIXEDMAP_BIT))
 		return;
 
-	VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
+	mmap_assert_write_locked(desc->mm);
 	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
 	vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
 }
@@ -2785,10 +2786,11 @@ int vm_insert_page(struct vm_area_struct
 {
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		BUG_ON(mmap_read_trylock(vma->vm_mm));
-		BUG_ON(vma->vm_flags & VM_PFNMAP);
-		vm_flags_set(vma, VM_MIXEDMAP);
+	if (!vma_test(vma, VMA_MIXEDMAP_BIT)) {
+		mmap_assert_write_locked(vma->vm_mm);
+		VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT));
+		vma_start_write(vma);
+		vma_set_flags(vma, VMA_MIXEDMAP_BIT);
 	}
 	return insert_page(vma, addr, page, vma->vm_page_prot, false);
 }
--- a/mm/vma.c~b
+++ a/mm/vma.c
@@ -2631,21 +2631,21 @@ static int __mmap_new_file_vma(struct mm
 	map->vm_file = vma->vm_file;
 
 	if (error) {
-		struct file *file = vma->vm_file;
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
 
+		if (vma->vm_ops->close) {
+			zap_vma(vma);
+			/* Safe, because VMA zapped. */
+			vma_close(vma);
+		}
+		if (map_same_file(map))
+			fput(map->vm_file);
+
 		vma->vm_file = NULL;
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&unmap);
-		vma->vm_file = file;
-		/* Only safe once unmapped. */
-		vma_close(vma);
-
-		if (map_same_file(map))
-			fput(map->vm_file);
-		vma->vm_file = NULL;
 		return error;
 	}
 
--- a/tools/testing/vma/include/stubs.h~b
+++ a/tools/testing/vma/include/stubs.h
@@ -329,6 +329,10 @@ static inline void vma_close(struct vm_a
 {
 }
 
+static inline void zap_vma(struct vm_area_struct *vma)
+{
+}
+
 static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
 	return 0;
_


