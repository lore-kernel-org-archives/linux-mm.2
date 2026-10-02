Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D72CCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 06:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05EA06B008C; Fri,  2 Oct 2026 02:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 035E86B0092; Fri,  2 Oct 2026 02:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40646B0093; Fri,  2 Oct 2026 02:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B714D6B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 02:54:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 292701605F7
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:54:24 +0000 (UTC)
X-FDA: 85276772448.02.8DAC9E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7056B120003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:54:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOsZhNHn;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790924062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ue1Cx+XYB9aBaUJ/GDXzUU8f4x3LGGlvXoDUIfnsQOI=;
	b=al6+YLeMLCFHnIU37i0yZQMtPkdzW14ZR/BwdKTHj6qD/ahUWNfSKZgOHeSbK9+w2Ac+oM
	GnbYJOqQPqaR7QI23KbfILOut7YWXHGAu9JaDee9Yg5CPul9cqAZpExLJW6EHhYvrDJhiw
	C3whqCAzTc/1nAGtZri8B1vjJ2HRqxg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOsZhNHn;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790924062;
	b=pm6zKGnEQgCzUQ4d11k8M0anLQlfC91ALOU2A7kexincP5OVjaGOpzQnQzqY4zltf9CrBT
	Y0OaHSS+s+4vRm/mjQ+nDwvp1Zavn+4ANr0lyfAIDvA1+klscunXyKURFn/KYgzPD5mcVU
	QYE1zMOjsUb63Bnwu5/NGKnPFBrN+f4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D756A60A5E;
	Fri,  2 Oct 2026 06:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEABF1F00893;
	Fri,  2 Oct 2026 06:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790924061;
	bh=ue1Cx+XYB9aBaUJ/GDXzUU8f4x3LGGlvXoDUIfnsQOI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mOsZhNHnMsuMnuEECJ60UbhrzrPksVkY2FRypuDGKP/z3vY0YEP9KoXCpAHiem8Oq
	 ggD48Bs8Bgah4boo3ohMo9CFylA5ZUCwjYJ4nDzt8mEtmnR/OAlKvfzcfLT6PRL9qt
	 AyUf2YrS0GT0J78RSjA2Zi2PPmB9OHRCefubG+ytUbK2IG1G03DExT+wBAXQlhqSTV
	 jWFtArDl3+ivSm9C9vy1DlUmaToV8yniipTby+JBSUY11cWhoq3dgFFR0b+ETZK8Rz
	 L2hL8id8VPyGredkP86S0uUBTQ4kRxOwtuh3hiAxBTpVQemlBTTghwoq2dYwKLJjmx
	 2U7jrdc3/lxmw==
Message-ID: <2cbf6e94-5916-4140-85d3-2d05eb0dc092@kernel.org>
Date: Fri, 2 Oct 2026 08:53:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 28/40] mm: rename is_vm_hugetlb_page() to
 vma_is_hugetlb()
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
 fuse-devel@lists.linux.dev
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-28-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-28-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 619n95nz8dbh1sgkxfhb4zmbqss1jfn9
X-Rspamd-Queue-Id: 7056B120003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790924062-466606
X-HE-Meta: U2FsdGVkX18yVKpKm/GqqD9JiI1iwmSSuF9FzQf0l7DKhLbr/6eFZIxeB7tKm9eDPZNeEMvayD1M2b5wlXv6PdHa+fMoYrhsjA1LaSHIzlhuL7svIdUKzY8CjXZ0C5QALweB6MJnIhXRPajOBVTQYno+6BUgu4/AKJ/TMfLm4k1IrT0BwrT5/61ksH0+DikD3Go01fVNknlw8KWeBtUaNb+4INnsYUnnmvGoL3L8xb5aolXmDO+OLxsCKarsZZovhYRe2g62QPjxNGfOwM6NUEm/B81FuPidUFrhR3pmPOk8y+NRZmNZGMVExh0ZLNSqHnjG8A7QU+M+I3kITOQRBPR/KJtEsd0xFd0gc4E7TGWpQ97tuHHOUwtYNclY/jy3YStJmZKsXqhNxi0rF+7viGz/lty8UkuMJiCGd6SYh3CAJYGA9Stksjg610nxSc0vuv/DjiQQ/4G0Px4l7cHKLIOodUwGxelTD5vKw/huxMiWMq9UvPxLnxzby/2EVDbATQdpzvtjP83o2aSXm1GLUub4CyE7/UMfXIgApH77JgMYYUxmC4MP8ew+MONfVoeABa2c5DVhdi7I/UuutM02fn+eA6rH2nxKVptpTQiMFKzB3jv7Dp4br8h0yZtoXbIdLIwvzRD8eJIYn809+DOE5B0QDgMHxrVx6sYca5At2vjEUo8DUWRSRb+FZ4sCbRHfw4PaM09LJ2iY5z00m8C0L8jEbGK7MU+BpPs1AUcX3lgP4rLEaeDr4EkNkWTC7Q9ePgomK92JRK64E9Jl14okKWK7HwrTG+7ZlGCGIAFtkOcZ52qC+vLzRYymWlRfizxlnHsD6Rev5bSwwUA7GRlSpbiS1dV2voIBy/0Iy3BEM1axA0m8hXTmWSL3xdZn7QjEmyhAB0P5H2AyuLCkfDrumzEkx3m/vmik4ezYAcuRGrI/FYiIF/J7OSucFO42C/vRRC3Q5IWI0fZF2mY61Ai
 31g1b7Rq
 a4ivfAVs/N+JKKVkRPIiooIAZPRoD0NxNt9ZC8C9TJkDDgmxuUtdx8p4lbBSZV9QwAKuHKPYmq6uH8qT/KGZdos3ylgGvlHhoyMJ2VQwIkZV9LAFQ6Z4qQtWlSjFV63YFzyYQWyHCBacBRdVz74aebWdiGiJnw27SKrvc2n0bfMeMGJJS54UCvRuhJg6sHMFaB3fvTjmep7+qpRNkoOYGyxSVZzRlsii6nt208LM4cAutk2FAZqX7Ive1mdTHlRmbRFwEMiuduahJKhTDlxlxNuzVBjjdZ/t43juT5r+41NRFS0CN6kb+96koTkQx7wZ+hqOace2E90IQow/DiAke8YVvX1ZXHyoAG/o3B5WGJhQf57h/3jbe13ZKGDZmDniVeUbnc9d9XrRtZaWSImYEE3jCxum1y8yffQhTkwUFTr8eMviUig16nKrMuAoB8PoQ3ybkThf5OuIJwBn2zxCJzONif6Lq4eyySEIbBQClaqwpyWcXBdBJjaHH1aANZSBsPfUB1Q6DLq7yuYrA8szkxDjtLlLpl33R1kxB8MSIJC1y1jwVn6vbRwMGUGmd/XLc19XVcU9J5K74+M5wkUWox/LJPq9yfRorShqOHBLFBqbWu5/VhsPQr+15EXucp+M+ZVfEJ/bqTB/perqplvnaR1Vu1y1OpZvs/IR5V9GBhmap2/qu2FJ0NRTn+tyhtSfSjKqDNHqQC5s9/phd0ZSpNKIPcQHPK2Ohfi4C+zbfxECxI9QA2ifCzECXlQ2TKuqpI+oxv2k2NodMqTSD1UD8bkApglUqltwykK/K8QrAO8aejfJAeRRyZRZPJNti/DkOZTUIWlv80hlcY4OJTVCj2JjypX2T0vYuSRhSme+wfE9BnR9HI3nwEwsedLOZ2w3unwuGMdyN73HeNUHbN74wpm7CE8RdnYcIZtTB0s6DCA3jEoYg8A0S4EVzGoWpO+zoQiD9hZ+ZlUXhGzqCbQ4QbqinV8VS
 7S0RyJSw
 sCUZfg/esv93Yp/CnYzYFyrJDxMQ8TXlBIpSUSq/w+W9SGpBc01DvPjT61X9pvPhwP8ctKodNVrQCYskkH20zvEKgQTRn6qpqJ0mBuXrxXrQI0QauKXBJRnZ+vXih+mRfmZshYncnczHXhvLSThyPFZrudrSKAgBm0gRMi+1sLq5RMTczVJZBCsBVSaY9sgt/Q+reFaQMKUfr27zPfOQRewn7lJeg9EPwFa/jw1unKoT6wA35jguHawLYaB6+54+k5xtmr6ZEMgdWwWejx8vtgf5iW1FkUop6zePA5km/sop/jRuH/WSqVoRdA2XqqMcavOGSZ+OHCbknr4ah71RAWWpGfYeITWveOpxtPDSsRuRxbhdwO5ia2r7xxWsnTqzYJ1U9OSuNmm9eeTVeDK/QJ20RIF0h5nr+Zatdalm7yD4uJgt0H1Q28GXSUge70mP1jM26KbWhLqasJPN+69U3oMy85dh/TUKwTRLkwXb7AW1U9Sh5EFLjnLgqeIlakfGKiPpkjpg4qu3sbNjcqLVMF+TW0aj07PAGvaIRgEHknTxb+KpV+2WgF60FDPLByzOxVXxDWAQxWDTRokngfFmZz62Kdd4t8GJ81Foi33Hq3X8ZE00PrdKO4reMLTVdOApL3EAzXnRcVTpuJhAHwTor/U0Z6nO5eMVi8lKoFKe0/GHY0gpz+icMoe+DHxLlqlWMe0hbUrTyzyJIQBuGc+C3wCT78W/xh3bsQ6BZBwqzlfv5OXbrTG1fLqKPUMVq+0JaUdMsyF3neKDXuLPPBe9b7zCFsD5aLUxBcSLrCgIHx7HMBoqI8v6HD2QvadGwKx0PJUSCRtrsRjtcVlMBujJm25ZS0ITQcugDLUGB+8RoOAOE3qQ3Tr9zWcoAEWc4Vy5bfpPdwo6JqTaoYicUeWbVEwGlOxpyu/KVSY2ifIHn1sZK3CEj8bk32RJmMZKdAKgPzV7CQiW9GA8drYFzG78yML6gUqVP
 kO9XaPf/
 DEHFavHmfSi7+XXpcnmUoWC5pzxIdfCrcfZpEnCz2axoAA9jJkZhto3xYtuBu9L7Esm4IwqtjVk6xi/k8GeQBhxvq3XP/S+4dZw1a4g/XmZ1ZVrqdODaglkHYiQvX3I0iMP8SaOSuuTra14BnfhUprPIWhFl8Eb1IH5X7c3RpquHUC3yIndVFvY/4fpy6EXVEgttrM7JwA02l2Si/cTz/Ai9Zj7PLeDVGo0GIfJ/lBpsEh6Nj1ZlhLuWPPZ+4/1DHn1QicQzPwTTspW24qHBAQj4FHyfnd6E53qPOhLGFjx4vf36BNOJaipajdKL/xv9SfTWIGAGxbVS7DvKc2SQEDG7kmSSFVK9ijnMkQv5hmZCvCWSRw9BplheyjvlwzDjjxSp5fR0lpquhIPdjm/pHTO6/ntmQqj1VNdjJ4GbT+JQeHxSFe1QToBtK/4+BeLnSatMMQd1fehzVYI/tzexiamqOqFWQsnVXxy6/QWdzT1YIvzSAP7z8oyznzACBiGOvlC+qbaCIFoZYAOcATfuRCRfO1HCgaNSLKrXHaWPv+iwygmeol+7b6WilAFLeKjjm5j6Vz2bGAq2PC6vf7VO3nbHvkE5E9K02+x79X57+82ZXXir5bfkGCP3z2b9Zy4cO910R+NKVIQYBxI9fO6fPsch2vYX1/hSNoO/dKeD9lXtAh95Dxoy1cfW76CeRclbdc4fYWheizDgJ8p72CHOCIks4yDkwhnPxt9/gGPYmIDu6WyxiZRMjE6fQlNIT7HeQXnJFvqkmUr1CVvW7h60vSTHj1RKs20whgTOUOQR9nsxmfWPgwoJwb+guk5i9kKVnB/XWfrpZbGBV/6FvXNZrtGvU8Cj7bYukowtbioXCwqLvvvbfKtUYdjoXp0NT9+d4giEH23veV7LkK0d00ET/WH7IH+c1Te3zZkMThMxl8gEbrHI12l5pNwsqoGkWyXm2DbmV2OPT9Nq68XokxS6OG/RRhgIV
 puFtdlwE
 uOyXFaGBBsQS6oCL+rgQV4d5Vy9ryLavcIVAi2eR5no3QSDAYDLRnhSW6BaGJWlWwhw4hwetcdJtZ31nCj0ZUDveUt7/4+wLQbk7jdKRRwfKRZ0fiiYTDttHt7EIAxFDb4Bo7ZEur2mIUuMXaucQHIQSPgsBuvRrVmuv6W5uHxPyv4q3Pz8FxIXlqY5exDIcxgwBRZsfkYJt5Lx8KTNUfQtJWNMep8r68AEnqyIrU2+Yf40w5dskvXBM3A1+pGxmeM2hMAnVhY5EmulBSR0f5H1E1fXkJYDsp0NDRET/GtJrwJEtPLZZskD96bFJhXgycBKKG8bfYbYjGGgrPnNiW1HhLRxled/Gkbrjb79Z9QKJQcdPfPdpRNjxqH5G3gn22dhYi6zfwZMMZP2se8lm/orpo6y9lZoyTJMIFwEZfyEVRY2cy5EywFanvQc2BDdqfLiSyWnVonRz0mxNdu2hYE40WCxhNeIoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> The is_vm_hugetlb_page() predicate is badly named - the mapping can span
> more than a page and it is inconsistent with other VMA predicates that
> typically are prefixed by vma_.
> 
> Rename to vma_is_hugetlb() for consistency, and while we're here update
> some VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA() as to avoid unnecessary
> oopses.
> 
> No functional change intended.
> 
> Acked-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---


Acked-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

