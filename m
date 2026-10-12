Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FDA2CA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17EA86B0096; Mon, 12 Oct 2026 14:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12FBF6B0098; Mon, 12 Oct 2026 14:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12AD6B00A1; Mon, 12 Oct 2026 14:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C70DC6B0096
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:52:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 604F5A94E5
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:52:47 +0000 (UTC)
X-FDA: 85314870774.16.68CD040
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7E26BC0002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:52:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m0WRXH/l";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791831165;
	b=BSh3K15sMi7Xj7y3yAT6LkA5HT2E8X7RDeQWuwGs//UJSwXOoldo03sVxDmwgonfnPqXjF
	S1YIe8zUhLrBd/5Cja2bBERZ/9eXEqOcryzZ+KprqhGxuPTWAJPnprS9aCjzeqlRvxnADP
	RGpNFU8hZzSQ5BNA5t/gkNKLldeFlKg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m0WRXH/l";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791831165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JS5rAlbNo22qwtsGvE+A/Ou5uLAn4LHEBxkEtLv9fm4=;
	b=4GA0MLN2X7F40N3r+qD1dqtYFoaJaXDykiPSBHyYOHB+UcipYPL6hJg27fl+N1mQEdfMwh
	Slag7sE8HKHdGMHTbWu2SS6PffrqZtNIO6kMeTDT5R+09AyHoBbu5G2sXU6uqiE2092Lt1
	MsJ7cDxy4LRU6nL0LZpnlNLK0AqCbfU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C400B404EB;
	Mon, 12 Oct 2026 18:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741911F0089B;
	Mon, 12 Oct 2026 18:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791831164;
	bh=JS5rAlbNo22qwtsGvE+A/Ou5uLAn4LHEBxkEtLv9fm4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m0WRXH/lGiOPjKVxGePwu9PM4DBxUfPf8mpW/r+t73nEB4ofC+jExqVxZuSSyCuxU
	 PD3XbbzWWtvD7+lTvQ6xsNEcjU9fooei2o1PVRT0U5yaGF3LE4miOE2lcxGpGnS+f3
	 dTiNe4ZHjWjMKBQ/83QDlAZaU1CiGGcPnwTZqi2Z1/GXnkE3taxcckXkF7h0u220Fr
	 NScxBsv/ieFyXlvqOLGLpBLzqpR4+YkZ9hncI4napESKOdnb5dEDI4RfDa2EZt3h7I
	 ySovDqvGx82lYI5mP1iagKu+WVxk0qJBOPBG7o0UK7QoI0vOVrh2fHUYlAdE7Ma9Kz
	 TLgk090yWcxhA==
Message-ID: <214514be-a935-485b-8925-07d84c1063f9@kernel.org>
Date: Mon, 12 Oct 2026 20:52:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 35/38] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
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
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
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
 Bert Karwatzki <spasswolf@web.de>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-35-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-35-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7E26BC0002
X-Stat-Signature: spdtkmuw5d9okimn3pswno5ua79dm7fq
X-HE-Tag: 1791831165-604652
X-HE-Meta: U2FsdGVkX1+/MIlqboceBHNOnVLWhnab75jFXqNS5whZ5VgRPduQN7H59xWAxQXMkNNIbdX9S3j34n9+Fz/ibp0cz3XpWU0Ijbt8kamSKWaN7YE0AsLUyQI/ZNTOQy6HYikkS1B/YAQBxeavlfZeiL4+Xn9tasU/fWQWyMYlkm4DCJMF1VASK9EQZivWYExHX9Dp23MU/irazRzmLPj1ntIYKEpKsmO/1RycPfW8hcpMqkynmIFAcS5sGjm8yIo085+51uZt6+0VFOW05cRYYCFUpIyQNcT9mPDjSd/0dhd7mmlQqpm0yxh3fK/ghR5Yq4hdnNCcDiStcwHaBUpgaGudeYXyWM++jg7AOcQwGLFVsi1sEJj8fIjAOfnlVeEs/RVZY25T8VIp5O+XdlGi5zM3GAwZmIVRImGRB1GRHrC94lsk/PXClZzBjM8bQ23/hIgnwj8WcSc0MGqJwUMAjUf7clLU6XgZTt4SJ/6cZe8RNAFlCWd40l/DmXVPQZoq6XrN/Bgj4dlHP+TCo4uHDxpunzNRBHiG+2SH+51TpXj+W5Zwcr8Wm19GPsnyjiU82eljAtPuoaMJ/+rE0c+bnPvwyYJ0XdZcimTUAfatuU9SZaFCIh9tiKVjY8KuxvZMx8G3zTDE63Q/Y/FGsXPbGqvDj+a2Sxtn8JNkLBif3WIdngGl4YFu/UNE2x/EMzCM4ntbGpj1UNOQqbd0Ma9VQDIxw0zm2B4qAWpewWfwJ7aCxKbQBiXBONHFfJzmQvZaF5UFTva1X8OlTsNHajgbisMpqik0OiLgpY5m7XbcQ7a4uz0N/kFUqoV7ngD5zU/YOVKQPkRGGeTvqBgmzRL93XZ49O08+DoYO9AeO6+Jxtzqnvqv7g0CWjEqP467NkvpJfXk0Z1TXfMfPRrDm35Jf/z4DFoSpZucbIID0zEO3NM2BQZT6Pw6adCxsAOEjarqxv9KFDddaCgsjc+8Vsk
 dLZG7dMJ
 f+l0tN85U4cyu/c+OjdsXCwJ6K3kDgIVmSB2Wb40OoMIkW2PwXZDiuNq3/UzZgF681hHv6FwCMi9i7lMX5HAVCh2I6zcjy6S0sLpClFaKjzgr8KWhogTNBKJd5fR87yqYk51Bl/zf3B61UIYRmvRzJFqizVySwUNiqCimO2TtcdR0KTkiavKmhWGOGL+pBrFG6FPlLNW58qfHWPy4LwrzpbIFmjGfubPk0xERpg76Bor/v4XT6xCCb1j9wCklKC4VUCVpjZKun2x4v1UPgecFylnF82zZxep8Rg2eeITte7X4ZX3lcVgt5c91EcHz1CJfyPYoKvdIGGXmGxg1m57TYpsx9aCXKhNk646xKSur/fVLIetiwPLPVX1ToLmnoi4VLfJL4Zj4I5hSohnl0Y607q9fh5i6zvEYyda3A2PNceX4ZsmEo+h5uqPIKyZiOHeaAVI25bFNwj1fYbWBTlsJpaujBu7zkTNEotVgZ21u2LwkcpdW49h4lSWH5yZyj8u7TFnYLNioLXtdMMJRiqty/l7vDHEFMaMX6g1NsL1opd8k+Zw8oXM5kY82SxP/4eyITkk7E4haVFEQprMJMUf47WXNnHLu8w4Q3kW1ppHKD5IjkuVK9AK+zd3ZYhKIB7/4FC+Rb8zrqxF7VKEhYKVpqZRhVCf66dFrDTkGK7lbXMPHKr8V+O85fonX4g/ZKquccYpRlaBhDUax27VNVevNDXcdBqFxuNZQeKJv4ucd9f75RQ7Q39QsAf0F3i4WC6P63BV26vgu9vNVFMEmxJsQwOf8qJyhWGV10WyOCCEu6dlL6A/GZzXNCT+prMLD6AJvVZgO8hZaJRU90ooX++OK3duGWxnaFWxRt2Xi8NcIXTP51gDLEXcx5skt+LM1jWqiD0zkCnRTgO5NiT5uY1vaWXjtAqm07zXwSGdzPsEOmPPdeLXfU0cUXwGNzaCErSH9vEIOis3j91UU9PYXQ0IPCQLmRH1I
 tVMmMndU
 JVpqvZEQC4g0BtpfcOwNMS1R1ZOcAujzCG+vWtqE7m2J+YW9LAaifjxHOi+SOBf0x+Ru8ZOubcIcmFYVFmbJaGIii9tFC33vhO97ZjgBUyKDsucGLe/VHQWXIB+aOzuF3N0OsuQJUKL/yucE1Bdk6cRBHcg3NLqDgLCZA/VarnDNz3HzeoHy64VdHInsVSYF4gOxqvdfFebGO213pOFmA7nIRnLoDh28XxuD7y1Bzuf18oZ0cvtVZUxXA8DHbvMoUOsxUbmD6TVWobU0ehszOC2DKM4K01VYtBxS/qXTGzMooYxoWyOWKGjd1WTkJNy3oioLa9MIbR4jzzTmktJmDBj3TYNd9+oONyMFcSqXl9mZIgpLVgGZFrOUD3OgHa6zXfmpq6ACUjVwqYjGop9Rh11E/cFqU8FcDIFO3kjooW5cnNSLcoKy8c3GJM+Fx4B6xRqXVmyrkYHD0XC3/LhESNGilVp5PmOVPBFnhztWkIdZdbvvmgIyyGHx23o6Iv6QaDs7hcZalyfe76yteXj5hLZiQkBh87MFYIF8OpXA0D8g2lBOwiOIjYfjqyutOwOX2qNoipaVdoJhbU9egNzc+Nx3LVnLUUwDcWIBuRPzchtejTyMDfTI7UuBmMYcBBmUa1RznYtLaHd99d4u65jTU0xqu0UL02y7K6GIxtSI3xZch3FU0/0yyghq2oVuxfDlOAEkSJm3GY0TjBbmw8/ku/jVNpymV2VOCq9imhBYRJViEYwYoSmd8khKetbK+rJqWoztyIL5frdRIA9XjvvCSqbmeDviFCSr5/mzA1GoL+SzSLefAAn4EQvoquy+G8PeKeRvdBG8gYp592UjFI4fSV0BRgmTknJqJvTa2axA80Lw9+h33AxMLIehakmAdr7/Vk+ep91fx4sx5U4UwvwmTRobnT/OBvpL2BHVOPetWjgbyAaVbaJMLMPmmQmHGKd50P59JBFYDTzZz1u+3NuIdhBWgueih
 VCKU84Wc
 9fdzZh+1xcOUPCNSyuT7VHvyU91hEbOEsCSVrKetcErT6s1rlyq1NvLkcAvfIGJYbVYeaW8m4XUYyNnFa/G51sEQdU8kNOSOQvFs+GSnkPCZ+1YL7SbGoEhkA+eBdi07pfN77V1g3tlk8akzmH2HtGiy77zuFENtjy9heqM0rGNdIsu74vrhTwPSyrDFBUH41Ah02RIxto2MM6aAyBdMTyRRQ7h+KhwEcLEhjPGdshiJzyFjuQidhOPyVJXx749aOgdfHZaUqCQStZ2A2Tztf0osLvo7rryRQbj67nNfPFjwZBW0kGFro7Pt7j+M+yu6uaevPjZ+qQEfgzqUb1SZNMk3dxdMGQ3V65tC48wUYTKT6V7w5RVFjEjO6trmfoK5zdwWN/gb0gDFor3rDTcgNPJQEz5O05yuO/1qvYY2C2NSIaiphaFhq8msVjDzh2J7sDS1IYnfrda/h1Kv58IJCtb2KWSZ0xKMUTcDmFa4T5ELOkRDYliv0sJRgK4N58SFvZi+39L0G8y90qWEYKEaGdDlbXau0YyAnnJcMpLiZVyJsTe4tVppJJD7EfT7A0Qw46i1MYNW0MFJLhqYQt1RSLLHDdWtmieOhN+7yoRARhOTDxzP/6UetEh7uSGO6zDADj2DfHv/rMpCtjoA7X01z625beYfP+fNfmp55M9GPc3x6mxy3PcUIeNY/pExXsDv8uFl1cYPEnDfn1XBa+Id2QzFiAR5snOOwtJnJoDNTGqePnzufiT+5I8Ap4+rK6ggnU33plO09MTNCyfueDdyxTbbqOc5UFUs/7yXsVFB8fada0AurJQO8rRELbb2XSPJl5uDzZR/ytOMakSHI9Z0elX2z4Nod5eXSb0pchC81pzDlbUYwjgHaGLHjOfiWxjeh9rMDqNNB63z3b9UOLCY3lD01j67iTjFELKWyewmrN3CzhiWlv7k5Ir2v3xt+5IKayZfdGOneOIt9OLJXp/oIFuMtAjnh
 X/xXJBk5
 fc7EQsvyLv0QkIruq2qJbvw3+FUDtEcaT5B6QPrlndSrTUs1KKe3FZyDZKC70AqEecEFtBs1kpsIYJXx7m19evRQ1x+8RFgQtDysvwO3B9q26DcAZhGlbutsaIL7Dr23iSlariKCweB7d40mRZTXNs6pvs+OehKTv+dYL7bJMytj2PA4huupfrzNiRY1zrDLnOGmITfBb5APbGPKI5/k2n1dbjhLEjz6YH0hjkGihMu3lXWOqpp/4Jmtbj0wVjE4s6bkJI/gsFPpXmhEk8p/TSuACqOQB0nZqBIWos5Qam9zBSxoWpkoG/wbQ/a4C9YL0MmDVAxjYnqw3bAr1ioBI3cdLPFGNXi3cy+fYCHUJ/kdR+BbBOcTIL5USQOueMkAdtdzqx9Zjyhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> Now we have the expressive vma_is_mm_managed() and vma_is_fixed_mapping()
> predicates, use them to determine whether to proceed with migration. This
> drops the VMA_IO_BIT test, which is safe as mm-managed mappings may not set
> it.
> 
> hugetlb mappings remain excluded, as they are fixed mappings.
> 
> No functional change intended.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/migrate_device.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index b9c453c28795..289d7b08ace4 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -739,19 +739,21 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
>   */
>  int migrate_vma_setup(struct migrate_vma *args)
>  {
> +	const struct vm_area_struct *vma = args->vma;
>  	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
>  
>  	args->start &= PAGE_MASK;
>  	args->end &= PAGE_MASK;
> -	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
> -	    vma_is_dax(args->vma))
> +	if (!vma)
> +		return -EINVAL;
> +	if (!vma_is_mm_managed(vma) || vma_is_fixed_mapping(vma) ||
> +	    vma_is_dax(vma))

Same here, with the droppable thing changed this would be

!vma_is_mm_backed() || vma_is_dax(vma)

I guess.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

