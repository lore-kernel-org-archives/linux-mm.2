Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692A3C982DA
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 15:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 379176B008C; Sat, 19 Sep 2026 11:09:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329F86B0092; Sat, 19 Sep 2026 11:09:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21D296B0093; Sat, 19 Sep 2026 11:09:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF2C96B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 11:09:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F1CD802AA
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:09:47 +0000 (UTC)
X-FDA: 85230846414.08.93B4151
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id DA2B480003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:09:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAnlGaZ3;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789830585;
	b=zfJhFoFve2Qw7q/4TWGdjV5wlP5QW6EohRcWUbIJDuN8W9IUFax79Gj+1yPX0SGQhmj3+E
	JjNFXgWMyO3V0dHctL0sd4HmGEVYQtkpLWm/GQefNE+yPThsaCiGzuseKUCpoCyIR8raCC
	HfYYNWH5Li2emE4ovhCdNk6r/y0mnkU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAnlGaZ3;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789830585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ItRljA0QTwt97l+Rzb+oBvHOLkSySW1764bZK9I66Ok=;
	b=499jwb5rUT+tng/X+mMIBqd7kzXYhXJE29aHHEdK1c/6Jo3atrya/qzNlC3NVi1zuH1m1N
	1hpNBt7qwJslXURiQBaGrZWqb3qsuAuaGZoKGaw2AOOSlnVn5zVMUWqB8qHQPxxydQe7MW
	GUYcmu1X7QTnC/OgsZMFgqTS08neN0g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0C5D601E4;
	Sat, 19 Sep 2026 15:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AD71F000FF;
	Sat, 19 Sep 2026 15:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789830584;
	bh=ItRljA0QTwt97l+Rzb+oBvHOLkSySW1764bZK9I66Ok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EAnlGaZ3PvA3eD4EGY8ScsYSSfOA3NuPg0sDbUCPy6ciztb4OpKHPUKVNCsw3yYTK
	 F5dXTbBszFDFMx49SBhL74XFEgpDqePel1QPLlEnRPCZHmhKtc3C3Y8QRt4P8RTfDW
	 /Nifcw76qMRhxrrojdmckuYvA7/eR4f0CHw7r1Z9eFzAmLIrY6jMLOX5tLpcIAlRYI
	 ZnXzDASidh8ez3yCFBhWrxVUS9oGdssza/jSZ3fPN118zuj4eAdMjnma5SzA3PTmn0
	 c3g/zkLkVjWHOMPyaaZFTkyX4384FbCqHcB4Ayw2h8F62iRMWX893EQKdX2S78phRH
	 PhATKi1qYFryA==
Date: Sat, 19 Sep 2026 16:09:13 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH v2 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Message-ID: <aq6lW9FvL69QeA9H@gremlin>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914180811.057cba8fcc48d6e0b53a2683@linux-foundation.org>
 <0b064fe6-ddb3-4f26-a1f2-2e9dd88d590f@kernel.org>
 <CAJuCfpFBichJH4OcmSHTb1rOuQBT6k5pXeua9_KgpWjDBKvsYw@mail.gmail.com>
 <aq6kzpK7wPl3iFGe@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aq6kzpK7wPl3iFGe@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DA2B480003
X-Stat-Signature: qajhy5gsc633wgk34b4wox1a9opmxs4h
X-HE-Tag: 1789830585-60310
X-HE-Meta: U2FsdGVkX1+ThlLbh8e6oqKxBwTiQC6UmhXfiDO3pZpqEuYtKOFuA7jAqZtupRrn6OxB/yRlUYPbnr6QLVmMEqhzI3Td/J2CRtsbuu7Db+kD+wn/Ope+XtewIKTW5tQu7Xv6MynTcS+2NvoiW2Whf91OhWUgGCvaFfK45D9MGiGf5H+FprZHLhUTQM/mqNSRPEhGz5PuocLJL4PEbE7qmZebcNs9Ju0cVu92cwyBLRw+hSKmQFwIHC4JPYYQsFu8zqf0Yx27NcoH0DPxOCFLfdMOl3f8jarbWEzWIczNM6LBO7FszL+FXhWfDt6x4cJ2GIl3dkrDCHw8ag3+gAFGUd1klBiDpVssafoM18ghb3iB9IDRlCvV2ZVipvXBVLvk+VQwIE4YS87JHV1j/MFPY416xkC9dc9z3Ma8Qtf5TH5CQljHmf6FU4XS2HUDLW4ycyaemgfEjmBY4aDPJsybrmuy8qbskJdc6A6hZVJFqOt8U3bA+Xnr1h6ZBwSrrT/cWEIirgPXKqQx0AeUgViv6Q1kPcujyrtUNjawUg1eyAmV0e/r7YrKxxgduMfhBxjYpcr7B+OuNa0V9uBzoV9C7ULnbC/8EoLckbtAKB8/PPkhK6KppJ/vG2tuwr8w1WMos92j6Xxv1qdDcPw1k0u5uVkUPBqrd+D78Ke9FUTcDSiZz4rD2R+WSlOdpE91+3vOb22jTnvFqyxjlHEwC7G9cJUheNzsA6bRTx+m/XhgcRlREPDZhzOwAmhe43DgbVeE2JM2IpXtAyTx4NHIvhlBpL8q+tKHPzmPJVZUG9nFGuljoZUKKYYnAEVUsQj1y93lTRHuJiOHu6mlefwmmCb1P6PX58/WDYfxtZ+cHmUFhe0Om8Nk7BaWE9+hr0vON5vTQnG/HgsXnhHFdWiqNFQ+IGJipkesIhPFVQrNz8E4Loe0LQCLKbOkjRQrELYQhIgQZJH3UBk+HLgat2WZvoZ
 cEIi3phP
 v7QY1JCdc5OflSqpm9dbyvbe75eFIzhDDGEASu/KuKwWOX0BDR0MGKdzALsarV9/ECU/pNde5wLZv+PdljRLDPQqnTnoX7damqk7omdXPYf6moZfwwKm9rOmn4fE1TBVxovX5PS8FDd6keTh89Q9qLkcrDs7E2/77/1gc/ywgnOJaayNiuIqq8+24oHrcfZIroEJwJ6JRP/jn5RaoIHDEmlxSiFsciQ1PyP6jzHOpWlLjGSWDVbupCb9TiEiXZ0Ujw0EYy59JT7PT42xrPxtV8LajoneAkcoh1tBXb9caMpJ9I/OwrZbwT/aVc9hUHFZUW9cqyqJu87pKXAr/etC5dzBZeQRUnE0GOzx05naH4NDIM7WmVFXlkgEBUPE46y5pSxqOk29VZP33+nWqQhkUSlHMVduA865+Z/DR8z1VBxqXihhCLqypwHJsPgv8DmDbHLYv9oFO1/yaDvb5GKzWaAQTJA/eVnThEWdGyQDsZHdCD3om21UlGEu7KES8YZ5uLn7QzZX3N1z6c/ankzZU0/VKOBZAW9ax8FtuAG9b5Pr1GjIQ70OzQFjGHGcZwRXBu5moVUrQKgNiRZ0Dc3F4wqys8JE9vMCo99EqC93hLmbYJZn4FBbNP2lS1TF7Offt34GHaRZ/jpWSjqfN5kfnWCok9v1jZv8Qc88k2Cv8Fo4RxQ9FlwI0tpaVKmoUMOZCRcQ/naWW0Ngd5IFknYYzNte8KzK0oeGHz8hq0rHLGSu4N66ol9BIKl+zdjffWVwCZDR/EPJztpaItIzH7m5HiVMoyPtK5CiKZnFFOA8sVY+d+Byerlmt5hIlsb7mLaV6+nevHlG+rmHhg3m2JYiq83B+hcxqAeMfDmrd3SKqzZWRBnOeR7O0Lv219cTmmyKgPpazuASMT8Soy3wpeAKVEz1mqXnyiiwf+8s9HHfVFOwVh7i3JHEUsLZ8taaK58bQP+q39u1UxL5fOwKVaB+p9KovJ8iP
 3NALVZCe
 NBm0YRGSX6tJwkMCZsU5uuiLe4kTtzZ4i5caUY1a2ZQjzJTP3nGuYFtwt0v05DMHk9mzXxAmbJk7PmdfpWAYbjt6rta1+yLDlNuoQ6I2rXce99Eo+2Ce37Ct3/fKe1CXp3oB7fSeTKqVyKMTx7D0lWTIyqwiVHZrCY8r1KM1lw6ZEkZT96/+Y9363EfD7Qq1tqSm9BBVHf9EqCw9jrQCUB8O2tLYUe7w1HdCfac7xo19vmVWdw6Gk6V2XoBTpHz139R9JVvAdyXCL+Iez6f86l1l144LTQqejTf91A7hSceTEZj/sPCXGfMSWH78vO7WqrTj0t3K1E00DjZ5T48NUmWUrJ27oQTHS+Mu7XFuoMCbz3QvXCa6voFhzSM6xSAgG7nse/a8jYu9G0rBSIwo+KFAZNmgj5Uo/4gNBIF+Pij4+BqgldvTKeN7xS/J6QwY31RKxFqOXqeof6A3ZNalclSPUUfEWhXNidkGnK5G0CiFTG+bFxzRnUAXabrY9chhqBYRpAK/ejcc9+Oc7LFi4IxS1K8VnZ7dl+JxWNfZRgj3CzFKFvQsWYoJeGclQx+lvzA8fcaA+yMtbab7ty6DUxipa8HF8xyQiOqutrdZbK3WrS7RVB4QAJ3Z+TRXUIJIpdgYprpEvg45SMnc4pHQEjcEq58Smr8EVUdMzBlIwju+IrqVBtQqnl2J7InH1ACmt2EUCDlVLys3Y6RrOkPYcXb6JLVaLgBW8HMo/Ib9Z5xZvNZXfxHs6PY21zeg6xVjyp2AEbl8KyuEDkUXBaVoKal+q9L5h28td5tgc5kmtlCkfRsvgKTQSqQIsudpnR+L0E/Ms1sMQ+8nLogqLgLswF1rOV6YMpaicuYkUcVeht/iFGYh/Gad4KQpevxn0Z943M6p6/S9gZYzIhDmNzR5KV3Iq2hgx9ULuJZe1Z++pjQF2Lgj0T1+K+RoucRxoN/8NVvjPq/5TjhKOHny2x0FvsqotNW7A
 YzBgzT2+
 GJF85JTD5uBZna6hzFNcINpzEU8a03WvITjd/0IB3y/YTmaBhdwYGz9wlJBETmSNTAWraXi8dmIEi68Lqho9PnUo4k1mIRQjOlTIRV4CTdNRizhD5Fv85FA5Ht93EE2yFLKhoMIgEYIYsF/4dbt4lrba5nNyoyfKq36xlOZAjS+1Sci1EqE1l2Boci5CEu8Kscs5M1RLJQTkELsRLFVWrOd/mpzlrb2V7Zgd8tK/9DLeQdrhUf9HUjx69EF/9HlKCCUR1JxRxUKA8SX8dS8UQAt9fYL89+A1iA4HShqBqk/ZlHxywymAjgJeEhfSYW513ipJcAkAY9X9Kr0Juuz1raNKDOBPhQ7WxOsNdmMnSxQOSOWeCZK75GWulD+a9i0Px01n164RdcWfZdEzJhqB5S9D/GHEpg6B5Pf/WoZTgDHUsfRmiNEtun7dyCxt0zsK4Jlrja5DH0POdMWPGkOTWkL3Nlp6O+9gJzoZaN/3/2BiF4odqTHSe11H9kZJmbYwAJzYzhkG9MsgEKAwoBUu0JViLXJQbcma6nPJLPFSAvvHO13jQaCns3HKbNjg0zTM32fZVflRYlK1+BpKwIXrcD3arVLATVhQc96lf98WsIZ2cfioNHszSIqD3SuXF55lWXtP8SBKD529g4Ea5kexpyqWJT/Zrm5zuGCRyW2AcsdVXutFo7QgNB5cQr43s6HbtZmGgbkC0SxEhjDCjsoSmtxWrMwohgl48Hm3FDb7DUIsWAF+eWEYsf5gSeN+lTPUGmbbOxxdzJaFywnw7ED+wXv1pmvef64pvQ4oZgd3Dz4yhtIo52+CR/0ejJtolKlCp1GeJij52lS4bSFu3M6IBZZLdsKH1RYPZISAuLqaMYU1uhjAD5HHtPLKmCjUlHs0i+Nor6OUPWepRsatrG8/0SpMa+ur4Y3e0/XdzAmy7ZkRDkZQe2+eCyMJcG7yyop6xCT6cJX6kHBXiTJek41aItOye73yl
 ug8D91Nh
 NX3+FAcW3wjrPnOeZgkR/L7wor3+XroDEW+TN1u318ZVG+hiKJjcg50+97z3tvhtGTEbIzHhrYMcywWcqlXKLcGxnbCewwpK2eyoEL+DxWjJ5isxya/pCvXc9LiXIAksYFctvisg8uE26GoEQHfBko73kPghSh26rbWjSpSYq9hRqWAZHWznQj7S73fMjyFHEdJlUk4LZgy4su1V7ebKOP3iNw5gwfTSO6qw3xCpTeemYAt1UPw8hwnfrpyOq51q/Z78Br1TUyH0mmKnHxBgs20MMmm6kSp7l0NEfjWtkyaoNN5XiCeH+r0gazMqV2kxlh1W7liGaskesmRuGMsNJLX56HO5ZWj/V3LkSQ7TeJj+EvYDr2iB9DOpgTODhGMUfSaGDzHb503g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 04:05:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Fri, Sep 18, 2026 at 01:31:24PM -0700, Suren Baghdasaryan wrote:
> > On Fri, Sep 18, 2026 at 1:21 PM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 9/15/26 03:08, Andrew Morton wrote:
> > > > On Mon, 14 Sep 2026 15:57:20 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> > > >
> > > >> The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
> > > >> properties:
> > > >>
> > > >> ...
> > > >>
> > > >> It's all rather a mess.
> > > >>
> > > >> This series brings some order to things by both limiting what drivers can
> > > >> do with VMA flags and switching to using predicates that describe
> > > >> behaviour, not arbitrary flags.
> > > >
> > > > That's a lot of patches.
> > > >
> > > > Review is thin and I expect this won't improve a lot.  Lots of "no
> > > > functional changes" changes.
> > >
> > > I'll expect to go through all of them. Might just take a bit ;)
> >
> > ditto
>
> Thanks guys!

Note v3 has been posted to fix a stupid bug in 1/40 + attack some very trivial
sashiko stuff

https://lore.kernel.org/linux-mm/20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org/

>
> >
> > >
> > > --
> > > Cheers,
> > >
> > > David
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo

