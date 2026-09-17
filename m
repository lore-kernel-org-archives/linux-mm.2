Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DB6C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7983A6B00BB; Thu, 17 Sep 2026 12:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748D26B00BC; Thu, 17 Sep 2026 12:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9E36B00BD; Thu, 17 Sep 2026 12:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5036B00BB
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:38:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C29FBA597D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:38:48 +0000 (UTC)
X-FDA: 85223813136.13.C727111
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1C12E140007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:38:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=byPXcWCB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=byPXcWCB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789663127;
	b=3hcHkLVQZlWIe8fsFJDuHgdHQeg7r7Yr5mL4Zz7xbN1vIMIjJRFH2WPyE0Nu4nr7xFmTpI
	JzS48Fwm5DaODi6AMOcSfXLvRfBDf4Y6ltV3D4Dbe+gmlArjk20tuz8Pxt4s8cess6m+Kr
	TZwwQ+73wdPV7lB0CEWXZhRV/19cc70=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789663127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLYk3o3B0/wt5kKG7m+ibDGyo2yi3t47XmKybZiJ1Rs=;
	b=DLUqGWk0NLiBxcHE9gIknujrY0Q1oUkge7EQhgme8v6fOXMuEv+B66ExoRuwKnqU1ltDlr
	xxrNlaBT0JpYJy90eOE27KCsHgXhUUmGB0+zq3S74M3JgBlMgbRPjJw9XDcBtXKjLDLIBW
	XHnpI0TNpPPzPblNLHpjyoRJm62c6t0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9E62601EF;
	Thu, 17 Sep 2026 16:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0441F000FF;
	Thu, 17 Sep 2026 16:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663126;
	bh=lLYk3o3B0/wt5kKG7m+ibDGyo2yi3t47XmKybZiJ1Rs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=byPXcWCBqQ2k/JxAm0NOmPWYbT6DeEbK75BKRpWKfzp7+QTfB6gD6Jwr5+NtnYFbF
	 vANP/UXdPyvEOeRBtYogU/57/nulluJHybMAJOC35jvz4xD2wPVFBI91Aw+YsOC+sP
	 6aNwYISVKfiJjWMFVvcA55zNh95pCsarrRKnXr7KWJWILUFd3HUcYcuPpIxzLPlFhY
	 ycbrt4mv4ZS4RVqRxw1P4RGv/E/7Aff2Vt9c+5Yo5G9KPZl7lvt2riK4lE3Gcrd8f1
	 cHDUqHsQw2H28rT4egz7snB+IabetMBAx5sqYD1rZ08IBRgGxzunW/DzNmOVsFjYOB
	 FaMAt505vgJZA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:40 +0100
Subject: [PATCH v3 31/40] mm/vma: introduce vma[_flags]_is_persistent()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-31-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3843; i=ljs@kernel.org;
 h=from:subject:message-id; bh=g+DP477oZGptEtdcgQ46pNPCZKGp7Qm9RMjCOcTExak=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB8u6fNauyHdvmVJ5W6uovZ+1YSTvTFcx3vNJj9Ue
 7bq3cw3HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIpxAjw8Wj14sVjnlLqEpf
 alzq8/uu46r80HPN9mFnBc0937Q0H2P4H2is/PxS+84+HRY92StXjVg7lJTdbzpWtfbv3MIVqFD
 GBwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C12E140007
X-Stat-Signature: qsb6x6ef9a83jbkft7n6m3negfsp4c87
X-Rspamd-Server: rspam01
X-HE-Tag: 1789663126-284979
X-HE-Meta: U2FsdGVkX19IkwhkLS4cLAUVzOjCElVTkKzcLhPN6JmVVK3y5/5m+/5LhQ4t4N/n73az7dTQVtXomjIoDJ1D0n9Fp5nTrCXjIfQmr7D/r0jPn/eQtz9JK2ixg2dyY6y/1Q7xu0DYy5tCWEYaMtnoSqQPDq3+y1J5ZLnjmFz8X61xZ4vwutMM6S+M0M7NO9szqBau0fQWGXDNcu8111muwQBUpm8Lt276qHGYg1mZWVUuaI3W1Uz7hZR8y7L8VDKA4gny46kHGjkZtOksaaD7AH3rY5LXpdm1U9hYYHa0uwgvJlpCGTXUq8Tmn8ueE/sVTgORlHycdZEi+ZJ21PgZErWIdwml4IltXInQAuSdeaM3Gd9sFbI1BzJb3I99psdAeHC3HyuSFnd8/XGHp2zWJrWk8cA3RzVw1SmLLfk/5QzKLb+BEkngrMNu1AGmDL6G7stjsQOdfmkoZI8syvohPPDi+HYFIBY+5GEcBND9GGT1nP+kXUgKf4JLVDFefBVRrweVG95X1bR1hAa6V0ysq5vL5r6QIoU4mLB9x+OA5/XOd1V/x0FFS4kyHnBj9pH9Jq0p1oAc6dbgLobhEB7l9BZO/YjdYG7t7vMLUV000GdYm5IYRY7u6afSb0m9gxlsqqL0Ur/wKD0LyZCeda1JNDnZf6GxJZW0NbVpeRpNKG9uxcGA5urLdeJnJQKhuuIzPPx91SHGjEvZm73T/poNUYNA81UCl3an6vb/z0YvnZyXDUUjxyMx/Lm9Cizq+IRgZ3227T5FNDjB+s5Q4gAJQ+UFEKWWiYBYrFaUVpYXhIgFo23CWx9wGRdQKDyCUVL2i37Qo0neToShU85LZoF8rliUDigtFhA9sU36fEhvSGYdC7MtM3tf4EtDAvngwsdiAZaOgTPszV/Pg706Y0AqVt08/sdtj5IBlQyQCBWnd3LZLpQVyuDqGivr6oZNAx6a24ddFexqmcR8NVPNXma
 Dd/0sfp5
 N4BUuIrwffsZcQ63h5E8F6qPD0/ZimZqXnZwg/iD9f5DeeeY8XC7oilRoO6BPNa0t7wSv/M/CjkfslnBbhHJPbWs6/UO2MkvBEUu4xHwZzwF8WKYME5nePIyby7uM/XsoLl1kMknyqX4nnU/DQ6I3hFrKvTnwAwWOzzXtGzSJW1xXzaGAHhayPu9juEoef+9a2FbStUCzIJK6uwbwG9hQ8evVyyn1gMgXqJRjfEWRDYmhxTLHJRpesuYWpnEvFUlrplp14XhiWXz/2dk8Zz1w8CTJK/UHBcBu/SqXQ0bYFn2szkd3yXg5i9qEuxJOT5YL9MeN3rcrxgJtCE+Z+l67UgLsoieZvFrxR6Xs3ENy+Bay+ekTp3t7/s6ZCnI5EULikZ7lGhIhDC3Kzz8qHvy4iNfx9WxLLb0uMo5JD1sbUHgZyi6PeBHb1+p7T9c3lB5pupR1GiAlRhaYZlpwsBFawCHjBV9sa0t8QrIL/6mQ3IC2H8aMeGBvw4hyOaqmoL/Wm9Q5hEhbftP6svpDsv7Mg//Vhy5Fbc651R+hKEIx/ni1OrvxDZeeVLaRTnrbr1udZomrd4omRMiOGBGlCUNWpRdpEajZsVg+57XSN5/h0gjBVpWqoM21acdTF/KUNUhv8iSrhQd3GgiidGviiLtPagnfgAqgl8cD/ImWLA1cjTBJ0332aOddIOhW07vVIeo7cOZMZY/j2jhyulvGTYpIyhzAOt7SXygJ7MZQ4Fgvuu03rPN+AgeYmmLN5YnKX6qa9Sd4Zwk/jRTDrUr3nTdecqENwf2i7ta6qIkDJTJGUnh0lTAAj8lvlK+Mg3Q9cJbLNktwsyvxQANeSg/GmQmkAIUfnkT42iXUt8F8L9FYMEBW4JFrm8+DTjBt5JW2BiV/ewSYnCQ4jD/Sj5qJ1t3vMxL7QbHIDduw0eUB1XtTJrgRrDqzKwQgJabpkCRHra9HwOZSzP4jYjluDGrGNV+ntzTnRfAN
 flSAFD5q
 DFZ5K/TGoPcup/jiXjDmxerW5sV0FqNzRbqyBhAf8b1f7PJ+PVjspuXG1e012vllDC6rBBdGKu1axTlOAQh595peePL3ykAISUySz5UCnhO8abjKbrGXiD+Ta4LXKj252CRu1KWPQPyArJ8LsIeSfk9X0qDYHzj2VTZq5Rqgj1K9iy4jqOantuyVrEUbIKeVdcD3IT9bFztKpKimaCHoUlUJ74DGTNzabxwDrvQDTtgYAakBio4yl8ruhbMYtOOUCPdmDHBtNcinP2uNlxGnRYcB0DUsSLQy08qWOq1TxirotXsvhIJcn53SAxRYBYzr8AVTSN5PQOQ6WAdKEaQFLUuH45NyU6emKcmnYWgcltt+5rBD74KqrNSjrkpmguaWgVw2JFDN6qP0DIYMGGRLDje9kFOX6VURkFA8yBAMkrbbbXp5vt5Yg+nBLH7ITLXLMlsFK5YRGcd+LiOLNgzUKEJQgcU9prpzvaTx8naMJ/A02s3cwuAwK7p3chg8fAAD66Kl/Obxg09caH9Hvnm4YJqcAj8FAQSVK/kh2/LJF50TJM5MvJMRoBfY7cHMtWeI08QVtqz1ITSA4RyrzEfLzuARfi2s0jnjJBZO9mMY37sQYXzk9hfKd0YFNH94IxiWVhKUnxUnnZm0HuvZI45tHx6n5mh5E60B40GONHEyYtzwCU5D7B3uOdHZbQmhQ37osQLBWjdhPxcLapGuKJCum79tcldg4WoW78bNyNRi5EDSE501MYNkyBPeh73zBBxt6aEqqpSnMmS7hxt9aw3vCTt8x35z1Ja3nyCtcOndyekZ0KFDZ7rTWcCE4zZPHYHTkkqgJS1Fa4Ax/jwXbKseYZQiWqdYSHD+CR3oEKk+zU5XTpcMkj2c+Av1ZMN6d26YtBgLEcyLfoEN3S9Vdxvzr5TS8O8HgEeY2FRyd8MUcH1d3OhpMBQGfpCv4QcGsVtu2oDWx0/+BXbIpdBBCx+QjylphcS7n
 1kTdtQUF
 Ym+OiFJhrKfE5LZkAcwS0KEUmcCzKbMOan1lxQXwGzXaaWPVwY40xUAEjtbvI6YPkBZbF609G98iQS2o5FfiCVsUncPKreqgqSdN71zlEMD1ZP/aQJeI/3tdHU9eHRUniVnKOSnNMfsQs0qkmo+IjyWiEME2SUnNS+lNmYruuqad32k+e/hYOIYZWL/Azdk2zVVTpg3a1oFds+KrMhRL23blvXL64iNioOCpb3+w6t0xsXlRNUpywO4glMMmdmB8hBdXw+7EBtqlh2dHNSC7SAOMzDC44HAaIhHcnie/seavqbcMc0xYmgHvQyYn6THXuAvSnLZcn/cks63lu9aPQbiw8hKWSgmDIjYDo69PdnPZinUz3cVIg25wn96bL1T0Yi0G6oSji36PFVcL5W/FWyESTi575Tq5C8eegMWv4rpRmqJKvCkPurD9fG7R2FyehrOvJq3JV7VxJZ3B0GkXAyGbrivGQkBveBoJLmCs7o2S/mviDBnxPxZyKnd/4czO6HZw4yLaW4qlGj7S7D9OiDKncH1heMehxjVNd7ohRDk6FYkvqWQGyKWJh258a9DR/5/xCSwNCufaPa/JwWfdiy79KeC5jARPaMlgKVNXGWvPBZj01w8n3KGzrcujfsqFXLrM7ekSwo8OZ1I7n5N/yjvpDrQA7dwbARlfqK8IUhyIaBDk+f9DHsHK/VDGQOqlQcpFRkrgOkTHpb0JjfeNn9zUnhEAkjfNxl4oxmb82xa0y9y6WXZlqqCoYRbc2HT0Yp0ixB6IOaaousCw+TnVjgi4z3NhzQS3owV6XbwaWC4arL4z45tU5S+spfc0rymG1m9pkmv0EMeSbCcTE9SvH3nTK7ftL4rQNvaz9QaJiWgjSOFRFYw6mScY/6xlqa9LQE4adia6YWV4G4sXrGCOgWGDCP6L9WYD5pynzK5Vqc0itkWYhA/lugSIcfs3AXSPNqeMK8lhGCWC5wLOoCd/utFPI4cO6
 Vf2awhql
 Fg3F/FG7eFSadmxde3Xw9QGDEIURkfKwRCb675mFTCi8PWVRCSBNb7on/37WA42n7zF5mYpZ5gUsaFkhhwD3U5Tj8AqTCZVTf+WxccoisUQ2Vvo+aRH8N5Qn+t91pakF5cSJBfoHqwR85f2IXNZtVZhrTw5X+ZzPjo1rNpIK6AUk8j4zMxA9uSfnQ4i2DnUXZZeeB8Q48Gt3UgKnSuUjIAEI6+ARQ6Ykv2DwPLE2CRoBvt+wbFvTqpSQ6pMGeKkaJJu39YSHCcjV5a+8P8B5mjWPxt1T4G0ZQaK3DlfNS83b4+Be2iYdrRxJ3P2blczRzlrDIr1OFoSCIMuluDuWBtV99OX+BstL8On72DiNNZGHz9iLbu59b84OrGYpNHKkEXCg7KHJMHLHZ+ZQo5J/Ln2ZUTvj0sqW0MF0lELteTuNGaB4fCZjspMhvXNrdMUK2niN2fXiyomA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce vma[_flags]_is_persistent() for the purposes of identifying
mappings that are persistent in the sense that bytes to the mapping stay
there, and bytes read from the mapping are the same unless changed by
actions taken by userland.

Kernel-owned mappings do not fall into this category, as their owner may
change the contents without the user having initiated it, and nor of course
does memory-mapped I/O.

We exclude fixed mappings as these are singled out as being unmergeable and
so cannot be guaranteed to persist user data.

hugetlb mappings are fixed mappings, but their contents are entirely the
user's, so they are explicitly carved out as persistent, as the MADV_DODUMP
check already does.

It excludes droppable mappings, which by their nature are ephemeral.

Use this functionality to update the madvise MADV_DODUMP check to test for
persistence rather than open-coding this.

This replaces the VM_SPECIAL check which means it no longer checks for
VMA_IO_BIT, however this is safe as we have established the invariant that
only kernel-owned mappings may set VMA_IO_BIT, so we implicitly include
these.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 mm/madvise.c       |  4 ++--
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 154fc25c9efa..0579e6afb19f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1741,6 +1741,50 @@ static inline bool vma_can_merge(const struct vm_area_struct *vma)
 	return vma_flags_can_merge(&vma->flags);
 }
 
+/**
+ * vma_flags_is_persistent() - Do the specified VMA flags imply that the VMA
+ * contains persistent data?
+ * @flags: The VMA flags to test.
+ *
+ * Persistent in the sense that - if you write bytes to the mapping - do they
+ * stay written?
+ *
+ * If the kernel or a device could write to the memory independently of
+ * userland, or the kernel could arbitrarily discard it, then it is not
+ * persistent.
+ *
+ * Returns: true if the flags imply this VMA is persistent, otherwise false.
+ */
+static inline bool vma_flags_is_persistent(const vma_flags_t *flags)
+{
+	/* hugetlb is a fixed mapping, but its contents are the user's own. */
+	if (vma_flags_is_hugetlb(flags))
+		return true;
+	/*
+	 * MMIO mappings may not store what is written and may be changed by the
+	 * device. Kernel-owned and fixed mappings may be changed by their owner
+	 * without the user having initiated it.
+	 */
+	if (vma_flags_is_kernel_owned(flags) ||
+	    vma_flags_is_fixed_mapping(flags))
+		return false;
+	/* Droppable memory is discardable by definition. */
+	return !vma_flags_test_single_mask(flags, VMA_DROPPABLE);
+}
+
+/**
+ * vma_is_persistent() - Does the VMA contain persistent data?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_persistent() for details.
+ *
+ * Returns: true if the VMA is persistent, otherwise false.
+ */
+static inline bool vma_is_persistent(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_persistent(&vma->flags);
+}
+
 /**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/madvise.c b/mm/madvise.c
index 0922d5f07a12..e15973292f94 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1584,8 +1584,8 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		new_flags |= VM_DONTDUMP;
 		break;
 	case MADV_DODUMP:
-		if ((!vma_is_hugetlb(vma) && (new_flags & VM_SPECIAL)) ||
-		    (new_flags & VM_DROPPABLE))
+		/* Non-persistent memory cannot be dumped. */
+		if (!vma_is_persistent(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTDUMP;
 		break;

-- 
2.55.0


