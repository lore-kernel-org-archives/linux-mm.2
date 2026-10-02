Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DD3CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 07:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0316B0088; Fri,  2 Oct 2026 03:05:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0DD6B008A; Fri,  2 Oct 2026 03:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4331C6B009B; Fri,  2 Oct 2026 03:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9C06B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:05:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9006640647
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:05:03 +0000 (UTC)
X-FDA: 85276799286.17.42DF7CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3754716000C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:05:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AncKgntz;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790924701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CM7DIVYmYvfmmS/7vVAyLclwsAnjkLK8CuNreBNPhf0=;
	b=4od80Ee+nFDrAMZ+TA9B9EGLP+HY9Armyf43e/omMNLPQstXb2XDgs2xHrsOCIwarRe0LE
	P7dsrORyPQOn9lk1xz38h3QNqC6/o+IElymHm1hL+9ITf2sukubCLuTydvmfAGmHDUYRH6
	ICAP2YyE4y+KpldmNN13SWPQ7ksjbEc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AncKgntz;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790924701;
	b=LYalqVeo4eyL8OB+tWOGUN4KhgYifT9c7DYPde7nQMBZ41xZDCo5iauDxEn6uPR1pRX1Rz
	m9Gvh1lBINpZgNJdGH9gy/0mFmXG1qicQldRB73BwrGLjVMmkXEzz80PjMbWHryvn82kg0
	y9D5CxzxhZl2ItCjspOIqurHG0a07iQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F8F540862;
	Fri,  2 Oct 2026 07:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B211F000FF;
	Fri,  2 Oct 2026 07:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790924700;
	bh=CM7DIVYmYvfmmS/7vVAyLclwsAnjkLK8CuNreBNPhf0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AncKgntzGJ1jRkXT6gBAuCgYPNz6B8sCHe7MozhjNe3I0FZTaD+73mufm2Z37pxeQ
	 UbRxzlwBFRTh8jppEWD1A0TDeWDvDWZM0mq0GeR5sBOdf6O9i0hFnsq7KvwW12XP8Y
	 pwYYFAS8N0WsPG1dNxnxszkWetqDmUJjDOc58JFTqxu+SvhR6GfsDvrKKZBtpqbVp3
	 bC6mnJ4U1zPzjx86ANQB1ymkSV29KIdBBVfTpdnGDyKjJhGaCi4h/ufbwTjdSRHemr
	 t/PuKzZ3ljbwBWybVXDLQNossdlDv1kpwliRgyN6t1m88W4ifKCNb7JNdlZhU2Fv7N
	 S+F/nYo8VZZJg==
Message-ID: <72bbb616-e84e-4635-9d0a-336916db47e4@kernel.org>
Date: Fri, 2 Oct 2026 09:04:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 32/40] mm/uffd: use predicates for userfaultfd checks
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
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-32-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-32-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3754716000C
X-Rspam-User: 
X-Stat-Signature: a1j6kjbasnmazztjarfjjerihn4e54db
X-HE-Tag: 1790924701-646563
X-HE-Meta: U2FsdGVkX1/UNFiLhSaUl/4qic1LTHppN3hPljx50SJSHjrOoMfjMK7uB5z+Uvj4Ofo0sHBWcTUl5sNju4t6Qz1as94hC7Pp4Qi4PxwFYfiLFqzlPpInIF4Nu6sRAFi1jglX/PxX6D6jzsY5yTYcFJoZE6JA6nM7xJ4J9uSnTX3yy9jNv9WuYMasYqcyhATQk9BhJ6serLYgJgz9GRflgvLcog6xzSDyxuMahUKIWKxWBAe1xgojZl7aIgoH9cL7UTJIhE1I9bGgQ+GaGWxi2xYmr7oJLee76A2P6Qlyh5mGiIXfRJNvsL4dvolb4JVeP5OOU6cNDrMJlzAv0A2SFkpuflmxtoCMG49c1spAhu3yDKcS6J2FItXHjhonwgn0Sa8HMqahE3h5uicLCtOosVjAD8hPtChAw1bepNuKTP9JyrU9WKY6Zn8AB2YUSpHJvDLdtyKWdWKn7d98aE+KLGdQiONoLBE6ylDXEVk4UrN5ZjYzCoB+Sd7LmD7cDZwEnSI2UX74iXC2OpPv81A/gdPjzIY8+JFaFIEIsMXZY5qIvg6qjwhXpkJGAvAKzKHuw3JYlCB8buIdJVB9AzDAEkJqEyr1PZSZ/W1qY+EwxYwnvyDfxSYO6S3VfofwXb114OR0a1rsMcEAukVY43yJVwT8tiPcS9awwHsU1ZRcf8zbaNobYDkU0iTPdrSC9BzEubcIej3VW1/TV/CWTWadWlQNXsbmy6WUDLyj/5xPLaGCKaEF8EW6T6LWQ2Jhv0eFUU/766YVclLtH5Cd1e9vMnoR6htDe8QsRa8CdtGMSoQFqlqmakyWqKT4NBqOWkLJ3enosg7yMIHsjBW6kgEJBLLSSh7skMBk1caFutyNz5xl6CIuNRBjHE2DbQIG7Ur5TDDtDT+nfxhXANqUHIm1Pls91s29AxgQY1jMbRPtHQ9cH0D6uI9AytilFdXIkcoGcoiuQ7VBYnirsEV2EUl
 EQu+e37U
 aZFUaZ9Hju6tIcOYuwj2iSY5ZLe8xtwsfng3cReG8xfXTE182c6dtq/25tN4nJEYAtWPajVzXueNtvbzssOIpTdjUbifQtOCm8HjwNUbjxZRzvt1qNZRmZpDndAjjHwerrbrRCZNgKOm+Zt41wBbvd25eZaQdBbTfu7IqCpbS25KlnsXV/qvCu0grVbq8ePPknNkU0T5Whv/U4philCIH77AeWyTG4N+i9q9k5PQCIT7Oekja+6B1+ysV6UEVl6krJ+mdXsrpX/T2WjlfqpJISyuq/uJrWrCuHRLkK0jjKe7IdgDjvzawhYyVwPquJvF5nIXCYCAmJUo0IdvYHWo8O8SRW+adKYfjNkinOadDmgZiSmQedURNvxt9n0dpI2FszU6N1YtMtOISGAG26r8KGqJ/CZV9HG7ybRDR1EFoXlONpUPn18QUGuSviVLMX2x5o7e4TNAr682VnH1eCKT7UIgREXLM0VTHnQixPE/rE1upzQZI41vDPguHjOGnPDA3IujObmZdDtpez5TZGIa5Gg6aSdtRtk08vc66teVR2/4UK+CYMcKZoAQ4f45B0a+TfTwseFGOiAzsRC0vgGx4s1QGniuHzcOymW2wx4KfEhWh5DW0jTkH+NDMiXlDOTMc9/KB1Xun5MIe4OQFviuP2ddkWOojQKss/jBcO6BeZyEHzGDSWVrxd7GEnXzCK6DmXq1RVFEvalSsvtWTJGVyTa2zBbVZ2mtdI46PlL6r7Cyo5oq+LKGAYsud/MXJm4Y3k2Yrtf6gZFLOiPi88NtSt47YopPyul5ON/lREHpBf345rdDoU/uyhbJJT+G58mV5A02p9McGLzqob9VFF9c2iYd9OqdOzFnDtwmQZYroUi9pHPuRYxHu6HkMeC7fp/VMTPpAOo1KI9RdEKOJ9hwu7vUxWH5M+pGNhIEr3pgTeU2sqmHtOcAfqCTIrZ1XRTM33sNLfTlUKa9LCKR32DRB2+5+CFSB
 NyTHoyXf
 fHlyeiEmggpuxIWiWY+JtwNlPqL635qIs+XIkeKv1P4XdcakgIHtO2vtIgeHwyFKvdVI1IrKVljUko6hJEwolUb6gfI5Vr+PNKFxnifyqSOEIKGwOxxiAU0sH1zIeit5iGiptb6E6DiifbnwUAkFpHEk9+6HO8tlwoOg5U8CC8kRAXdf5ENR0LnIgHKTJlMjFrlgpKPc4dRNLIzUIywGZR3CjbC2Q7QRJTPdE9+7LYIvpSDeasbygeowTI6B648gHJNiTL1kO7+NWDkDa7dKI6SenkPP2eySkibhnhBfdIJ59/U/DSB/rVjnngP3pb1QuUxM3n4XnG+S5EuG9WA3IBbjZQmamoHWYyWGjyt3G0igv/GM4CReMFdxr2ktUgUSMtgjL7fJDLD3XN+R/9R1XcXSEelQ8g5/DosUwM3gml3DkjKmpTpAWBNv7EeJ4Sy8wLnLgrulMZ0LvJhx443tWw8rX9yoeAPKb1psKFdvN37biFijPEAYSpQF9pgzWmjKaEPSYQcRK4C+WMhF23P/wDtOhKAuPB8e9T5VBqTRh4blfHZy6CptfuveappRCdpzrNt7pPJVq2gvow6ItpMciagGhBUbi55n4L9BF/OU0/i7ipam3ROiZSPcwtLAKlHCSqvwebbUq5wpZXqexHgqwNwcGKjKRFsATrYr2brpbw2WIbzERQ79FY+rc9G2ftB4iTAkdOdjDUZ4I8cAEJgvHosaw9SYUQZ80VVUMQknZszrLAi9PYZikATGfW1Y2Fwvg32CiLFf6ds8cXE5ctu/PHgiOcl+Sx228x28xxqgoZVDjQFk4pOVttEQ2S9DfX5J6CpYKYBQqtY7dW1mVviKqAYEJB+XavhrwttJ1/QA5GOoWfhjzcBuPDuAcuW1hgraWTMyRcPGXSI+zsQv1Nk+LXVxiuPOPMAyzbDF7jFs16Z8MlQFLBajBdgFr1qLtax3WqTzsLPvsv0dYWi4QLiBfwqQYjdEW
 eAg3gw10
 U3yE2Oj5rCNOWIBsu9M1pQPOvoGK4EHA6iD2hHrwePka2pPuotkn5yEjJaXuiEZyedbJxIYV+/Wecrv4eGv7fQLrlWKdKxYqxkIw1YgOw4nMMoqlAu55+fOcqimsm9pWsYvn5NIQOau+3P02KCVFWqUR8CCyRBDEOGqiPHLKqJPnzyRaq9E6XvZEOAhXjqybX/eYr5aXqDTXZfgz5HI+eHfp8kRKYotcUDxv0p6Gl7fGOr7k0wLOuW3SyduYmjrs3Tzgu4cHu22X/rn1TL7ilvGchsGD6cJ/MMikS7i3YwiBq1FwF8fub5prp5dw8nhHT9VaNLZa1lz1N951EeeBjm+6K12Nd6zATNa6ETSghA4dWkxDrXgXfiNM5OPyFj8BpB9tr27YQhXl75U8yI37m2QqSzYGIwypTPs0cOhUYeYL986S9O5Lv1cYpd7yRU0SDp1Gkf2zPE3i8x2slfmonBwuy+4sVaNxWkcYoTJHsc91fDDPDyWWf741jj/9NyaXi8Kpi1BBLcZWuJ7wlci1ogzwLfG86mD1xZYeKVm80M7BVfuTuj3vtjxJAHMTItT9VxHw5L9cH9//OVK3YPFGT04q3wCVMtH/18ljqB1NDxJr1IbMy9gKiH5H0dAcYC8Ap+InYb/STyCSUTTI2BHnIIyILAqJXE4Q4zixbhhNkkfP/9EFRhkHhwsFrJFlzIwWDqDKn0uxXnuvQskBvvOlQpq+lYtfe8S0dF9go861GyBRWp4T0XGBdF3u7wOTyhRUchFgb9A6KN2lBjVYhS2UsoH3cMlw6RU/tJ9/53KljwCkBcZkaI0y98kmdU3pQzj6f5VlNu/r1NYo0lT/Zz2tthBD+Pe3QbGoej2yLdjwVhzXMrj4xYh4W55etdb63jeLuLFhMNAyKZJ2TKL7sNoTCYB4Vy1Kehcll/3oGTYUIQzSNOMaoKVJvVlMn5QYvsAvEj4JJetg/Uy74jcztwAULAy1i1KH1
 4qRkwJzF
 y9uP+GqBN5LYQiB2aSNnQHC5r3bEOHSzs3t3smBUspngRqQzR3coQ0K5jcXQ1oTDTwRvvAIGwbwZdJdIGpFM7A+6w+CA8obthHf+SDKsXhWX8lcjwhAD2jBQ5hmv7x8MykPEl4tkvrszT0Oqr78lU7s10Usi5IlAPUJy0e1zVFgh51kycQJ1lh9qh7fLIYebkcK7L5vmQtccyuy3kuFWt5mZhIXLee2bPeRElYVJyFc5DrmyRXyX04i0H1HO1yo/Gsq5MBKffeypiqI2zSynl5CopWQurGGkRx7T0UdDMs1p5sfsYSLYQc4c9PGtoBXFMgXxtzgJICGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> Rather than directly checking VMA flags, use the newly introduced
> vma_is_kernel_owned() and vma_is_persistent() helpers in userfaultfd when
> assessing VMA suitability for userfaultfd and UFFDIO_MOVE.
> 
> Update vma_move_compatible() so it's expressed in terms of VMA
> characteristics rather than arbitrary flags.
> 
> Additionally, update the use of the deprecated VMA flag API when checking
> VMA_SHADOW_STACK_BIT.
> 
> A VMA_IO_BIT check is no longer required but that is fine as a hard
> invariant has been established that only kernel-owned mappings may set
> VMA_IO_BIT so the check is now redundant.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/userfaultfd.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 949017e60608..ddf0a4a3d399 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1754,10 +1754,18 @@ static inline bool move_splits_huge_pmd(unsigned long dst_addr,
>  }
>  #endif
>  
> -static inline bool vma_move_compatible(struct vm_area_struct *vma)
> +static inline bool vma_move_compatible(const struct vm_area_struct *vma)
>  {
> -	return !(vma->vm_flags & (VM_PFNMAP | VM_IO |  VM_HUGETLB |
> -				  VM_MIXEDMAP | VM_SHADOW_STACK));
> +	/* uffd is generally incompatible with kernel-owned mappings. */
> +	if (vma_is_kernel_owned(vma))
> +		return false;
> +	/* The shadow stack should not be written to by userspace. */
> +	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
> +		return false;
> +	/* hugetlb mappings cannot be safely moved. */
> +	if (vma_is_hugetlb(vma))
> +		return false;
> +	return true;

return !vma_is_hugetlb(vma);

>  }
>  
>  static int validate_move_areas(struct userfaultfd_ctx *ctx,
> @@ -2146,10 +2154,11 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
>  {
>  	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
>  
> -	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
> +	/* Non-persistent memory is inherently not controllable by userspace. */
> +	if (!vma_is_persistent(vma))
>  		return false;

Completely confusing. Just avoid the helper and open-code this here.

> -
> -	if (!vma_is_hugetlb(vma) && (vma->vm_flags & VM_SPECIAL))
> +	/* The shadow stack should not be written to by userspace. */
> +	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
>  		return false;
>  
>  	vm_flags &= __VM_UFFD_FLAGS;
> 

Other stuff looks much better to me.


-- 
Cheers,

David

