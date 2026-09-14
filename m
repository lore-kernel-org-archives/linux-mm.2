Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 102E5C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7C96B00B7; Mon, 14 Sep 2026 11:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159886B00B9; Mon, 14 Sep 2026 11:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0204E6B00BA; Mon, 14 Sep 2026 11:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3EDA6B00B7
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:04:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 663B84018D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:04:35 +0000 (UTC)
X-FDA: 85212689310.06.A0F3C6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 56C34180012
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:04:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d8UAMgRj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398273;
	b=m5B5i7rQywfUQhGs9YbaO4NicjTUSzoV8ZBS2DGndVBBKF+Tav1FHieju7LXNLC2HaQoXC
	o+n4jTXu/YDKAYuTBe90n0NJlG8N9hdVIuVUrEoXeLFaHtifUdmyCmbyf87xPFsIw+Ttki
	e1XehTCGPJArOphcOm+2M3x+PkfDY14=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d8UAMgRj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10L90PzOXSgbgk2Yp7RVeipj6WjV7mej+Ed4jbhmuXc=;
	b=iVBG0jxve5dR1CARaMMFU9jGmcVE0g6rphQLesBDt85mUENjMaA7kIhIuOR11BZba+krpj
	8xNypQqyAaXwUXYd5WREHihkfVmHC8PJy28Lix55zkbKPqh96NSseDpS3oLHPg+ONc3AbS
	2GFj1JWXd8rR73Q0IbztqcSkeenf25Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60BE943CEF;
	Mon, 14 Sep 2026 15:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3978A1F000FF;
	Mon, 14 Sep 2026 15:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398272;
	bh=10L90PzOXSgbgk2Yp7RVeipj6WjV7mej+Ed4jbhmuXc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d8UAMgRj6PgQ53/smtxw4DHQKRNh+18yk0qKHcSvJNn0G5z0EifIOn0OASdCFbr8X
	 CjXma6sDoRLr7JXSD2DmbuLfmxmbBz0mAVtVwgeLijE/Wq8ZQ2kYl43IFvFf2AwMXy
	 gjKI9yclJGgXaEXCrXQUihVyFfoSmoiN+hB3UeBp8WRBJNYj26yTsvR3g/SOP8zmiB
	 zck3UKhesjAyeUvz0ZwISNpUk6ue3dohMXjfY+05LDAhwGPIjjxIRphX+IRxXWes9p
	 91PtBVbi4/LvVNdYVuwQramdMFWxPLbQO5o2/TMCif3NQ6boGBTs00nJHtXJ9+V3Gb
	 wlElXOk0MM+xg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:31 +0100
Subject: [PATCH v2 11/40] infiniband: update hfi1 to use
 remap_vmalloc_range()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-11-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10306; i=ljs@kernel.org;
 h=from:subject:message-id; bh=t2zMqz7GwrO9LwCoKVbfTLpQhoUUcOpzKx1NKvIhX3o=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK/fe8KnXOfZ5zxzlphrF3bNicr173zyyGubnX5P4
 T/eoqbpHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIlSBGhvvVZwMXmSeUcNem
 P4lR6n2RszChb++GcjXufWaufmH3ORl+MTf3Z8Z3n1hzjqk87pPjG8F1b7a0OS588sU0auZ/iYN
 1HAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 56C34180012
X-Stat-Signature: p3xpm4s4a8t8mw6i3fifhkgercg4cpz6
X-HE-Tag: 1789398273-550793
X-HE-Meta: U2FsdGVkX19iOMoObwcjCNXEoMjdX/XA120hDzvGe+WGAy10pX+2ZVbgNewUsoexB/+TqZI95wmLU3I494An+Bl35Hb0OymVgVLhn6ArXb9hKZ12N++7C82HvUXwX2a1W2a/DCHDtpodAt7+bj1RLushLjwx9Zj2BvtnFk6gFg8tGl2oceWG8xBB1/5klGNVwaARR+oP5MPumG7oyPygQ5niYr1dOD4lO5HJ8IyuDEW5RqOd612y66X3RoyfxuSTav5587eg6CWfqYZioZZvI5VSpBodG9kiYvzohttunl4fZLiHop8txLc4EQXUYTsukqxT2RPTVChYW/5g8g5ixOTUM8tiXxcIISFgmfbZRamfU6RnbXc8HehXv/+xhXbU9eMxL3Aph6TJ1wraSE2XMcVWDDUTJsgj+FLlia3HZKvBhGcC1JtLjvTuGQERsYgaEjY3b8nsx1XelpBLwsmd/dzYpd72Ae5lCKektdWFd8C1fP6DH73QX/ZGflYj8ltA+AXgZMuvSYdVDRFGlp5PPcYekeFFYf9cTLd3+2HkIa2zZGWoxQ0ohTQ7GDeOg5yhRw+S+YxgGZoTBPZZL3sSZc5+RkkyWMy3rRc1Tm862WzRcOAWYYuu9p07GrhAdh9mR/SBRWbumBt6DgafRGY7Q+LSnVSPWLECHZLUFiq9GsauJMGwaFxAl/wR91gUOmQMqD5YDVhsnrOZZhiYJeGzppQhD7RIdPIBnsyBwKTX7NJoR4JYFi+bnpxhddPNssgKYG4LxPWZxb7gm5XlVcMNjNvo0Ev7dvbvSZaME00X8SWJ9CXdxpwMfLEIr6OJFEddO/wU2C8t+doHaxPR4S/WvqXXIbqiRtZj6YRQOKqrKrmvafNablErqcn8zV69mJLwv1+smd/2RsmneO2ecv3Lf/ytcQ/fthmBFhYK+KgIKgR2JaeXct840iF6I4uUDkP+AvxuF00XiyzPiJR1pc6
 fbfe9eY1
 hwSLnNSOOdvDBB0zw292rxkI3iET7jaShX3FC5bB5MwtkS/Znhsv83h2bGSmg7Q+B4wf9oC1QuO4IIJcjE/GIR24zhWEXdvxR+5XKC8U4BTVGfkVrA7hrXauV5BJC8Mqb8htMOYLKFZPtZiMnpsQCddV84rfzBKrgnDd1U7TytSXC+uLVa6l5UkzJRdy83sc9AErScStWkCEVFFjemB1HU4weDYQ2yHd0J20TFbrAWfYJKtxdWyunt+cGutPT60ZoJvriGGGa5DVNKK/DgvOaXDLsRIMUkPyMDg+FD52SDmNBxwvTYuzhGMZHj7k3ENqGqId8MCrL0vTqOmzGVYBJPtqfpFnyv0R0+Dqq9kjc9of5HQ8NBsFvNW7FmsK49meyRqvJPuPitgAWl7DdPj6cJnpW/0DfKdmb/idSeXpj+4oygH+sAy6D/QZ+3OsDZwXWmQsqq7z5f1D4+mTUV5CWmjlDFowdQdFbGilWVG1WKSaEBefZIuxWCLZNaSkXSfZ6V+SqIQZA895f9NTX06Bp8vMWuOzEnWWjA2xb5YVGNSUAuwFtj8lcqWaq6A7xibMIXVmyj7mfJoIYcwFupX36GWBBEGIU2sqTHUY/ocVBcy5gX6gDKf0fYI3tTro36hH/ogfsgGT/5WAre8iyX6388RW6nl+BiG53ojEyCQwdK/joQvSDDhTLSuoKRN/J61xsyTLl0EdXX9/Y3f0dLxtMouBc1eSD4pYYY9+MRPyb6GtZ0eABvPykAxSxZfU2nwvKomHleE7O7VtEJCSlLQpekVlefGRl9pVLOIg4z4z36vrtZoKGqFyxL/89rvU9D7vCgEj7V29jewbgDV86bhIKGl3mIq4Cuxr4hxtDGPGCUEGF6uNWZsqpVTDzDM5qsw/Rr1BQGI0Fq4VTIvq+FUOcQBggnmMff0u7lsaT2HTlBDmE6ujMJ88+kRYDYBolc22aihABMUKN/ffzA0FTK6aNo0rfR2WC
 8MMUzOHV
 8tFkWuNWBH2KDN3S+KfcPSGkCTTpcICWs7lFsKtKuufa7seOtVmSVOeO+XERbWgWWcLBGbn5xapHjZjEsjjEMI3nG0h7KdaFsngEOBywipF+mvzwCkc8q0eG4c6kVxVjsr2hugiOX8qE/0fYCTtET+1DoZ9IgU9K2dQP+11aaXBREr6F2sfJnE9tB3pzhskFcRhjo4e/7NsxIsZejPgMCG76Kcl5B+U2MNkHsZZdjP0F5FrTEmbZ+4/ViFVFEaqR2Wf55ZPeUJ8b/J3hO781GaF4n/yDVuZREDPAJJQAjD5z48kVLWqrR5il//EZjzg6JqGXAz74CW1u/eelMbyQzsUtgaR98dVjnW7NdjrA8oMETn3EBiieM7uZriktrstZLQNJJcDGLoX9hXWZDgLK2xthhw6j2wisLVvrzeb2I8/oxaM3WRUSm/kNYTWte9cp0hv1pmQxvRjPKZzZjNaHhQFMfjnsprmCvkJb5ko93xQvDLSM+EsD97RIJUhi/iWZMZTuazjaPyI/y/oiL/5PP7zpVWFw441OlSDrl53d5dxhoPTDvSGpkG4baeIyCb83nmrAT/LgMWf2KhQFV0oUMdQPgb8eZ9UUc0rU3xhSpJTmod6iWsLWXAnbJ7DgWxnYi0nCA7XGbQSIooAZRvGCXnmhASbti20RCqlA7cgbvCFwP9z7Fi7HihUWtyn78trvFIYYaA354zleZdbAzh/aUr2/nbdELJKGrfdyMZGSMGox3pQjZP0AYLqyjk5JsKUfvLzW1Q5KTVA7gNGbG0eBTq67QmmsUvd4BumjRJAOrQ0EMVl9VDC2CHwaTyoS7HjB26Ph2WzajnKrrJdowmqMQ54RO9hkkoycMjXV4pgncmYmhqBSISRpP8U+ZSPbh4y4oBRQJsfii5tigw4iVbU0yh8Qb8WCmPLFrj0sP0n+tQM6S5mke0rDkiEzsRDyQUQtSzzldadk+Fs385LZX+PRoiOWkJ1/A
 NlHbwIRc
 qCj1IWsMrhjd9RO4Y/g+HZh42UJVK5a7KpBNm9rVDCBkX4dLlk1FTCorbDG06eC6DL9ameib6Kf2q9UH2UM8/dVRyWHFfcvhxQttfj9TuUiQtG4hwMBXoZlPxDtTa/HiJdQ6nlRmkvm0XDurpRox9zV4gy6jfEnnnH9SNVcQp0IAW+hZ2zqO2U+4PL1065/c7KjXIfL/hF+nC/OUCAQnf3axPU9UxpdbvFSq12C/OcGJSnvIXRrnTvVlzz1N6hdCrlPnGksATgkSaNiGYWBqENCf8thuMeBUk8N84ggOWBL0IzSYOfNix0JWOILUOIwgHoImFV5o2mcL9v4eF+sGWS0CrSo+8URoH0ytPFrSuDYBwepRhY14usS6HC78Z1S8/rouv6xIw06vNH2STWoODuV1a9mEJQtp66ksoR1sBUvv20BEcABDTks2r7GG774S79NViezHjqWmnftWjaXgPgaJn6IYg7a6lB+flZoRCdaY/Dge2etcrkA9IkmyH7kvYRCqvEgE6MAnJM4Y1paMYW1OIPCr+q2iD8+QDIrzhhe3gRAZqeD4sj4StUSr1e0cHqFdsUHZL6HECKokyikSBGRhswOoeqWsxK1pxQo+4br6dv9yv2f203LBKUEsf8ss4qI6aVVRz/GfvJryohFzZKSLp7Gp21t09ldqGO1YcFeJlZzquy4hKF6Y9hOMsjdW7nk4kh3WKaZh0go7wGrulX3xbeQOuu8R3+uNi4AOi8l79NrVBTvfYlYvsc5i2RNqyw9DrLKXCoXOYYPaEk/12EkIrH6dVVTbTRQ/xGRUl4F2IPn+QVm7UjFLrWkXYmWCHQ0tXtUwLz1tRftX+pzIMtbbyRo+BHxo/gssnfVq5cWussIeqkslhe7siu91v/btvmxT3bc4SObJxXosFk1OeMRG2d+NQlF+bBuPopKusfdNAASRAWzVH5JKYqIAKZD/HGxJPTrvw2v0GzBBkH0+H4aUdnBkO
 NE0yytdN
 iib0l1bt7IPgci04jlk3/GSp1qdxJVVCVZTz5KUoQhd9Cvw6LFgHLJEYqT8p+/grFDhDvWLXvd6+4ot/WQoMKO/FubI21bM2+Tan1o+ITaqBifRSR4wIS5rG0vCTGswDRjK9teOGHaH99NLluW+W7BhsIc9rxdnQBCFbwtB+dQAVfTP28ie5/wgfraCObmd//eOom0IaTocQkbCoNQECY2EKn4kOESc1LidcIEwtNFkb/9mKtpk4h/h9a7F5us0qhEreuALkgOX+nzSrXfjiGN9pi/r2C7pyb13zodCGrQ5sNIfBXROeU9wdgmVUJ6oDd51BhiOCi+ATp67Gw4gd0w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In cases which map chip memory from vmalloc()'d ranges, the hfi1 infiniband
drivers currently installs a fault handler, and then smuggles the kernel
virtual address of this range in vma->vm_pgoff.

This is exposing KASLR-sensitive internal kernel state in the VMA, and is
entirely unnecessary.

Instead, use remap_vmalloc_range() to remap the VMA to the span, and
eliminate the fault handler altogether.

remap_vmalloc_range() checks that the VMA does not extend beyond the
vmalloc area, and the driver already requires the VMA to exactly match the
span of the memory being mapped, so this has no impact.

The memory is all preallocated so not having a fault handler has no impact
either, other than pre-mapping the ranges which is beneficial.

We also remove the VM_IO flag as it's not appropriate here, and the
VM_DONTEXPAND flag as remap_vmalloc_range() will set it (and also mark the
range correctly as a mixed map).

We also update the vmalloc paths to place the virtual kernel address in
memvirt, rather than overloading the physical address memaddr. We predicate
the vmalloc handling on the vmalloc flag before we check memvirt for the
virtual address-derived PFN remap path, so this works fine.

remap_vmalloc_range() requires that the vmalloc()'d areas were all
allocated using vmalloc_user() - each of cq->comps,
uctxt->subctxt_rcvegrbuf, uctxt->subctxt_rcvhdr_base,
uctxt->subctxt_uregbase and dd->events were allocated this way, so that
requirement is satisfied.

We also remove VM_IO and VM_DONTEXPAND from the STATUS command, as these
are both set on remap.

Finally, we remove VM_DONTEXPAND from the PIO_BUFS, PIO_BUFS_SOP and UREGS
commands, as these are also all set on remap. PIO_CRED retains it, as
dma_mmap_coherent() may map via vm_insert_page() on the IOMMU-DMA path,
which sets only VM_MIXEDMAP. The RCV_HDRQ, RCV_EGRBUF and RTAIL commands
also map via dma_mmap_coherent() and never set VM_DONTEXPAND, so set it for
them for the same reason.

Note that we retain expected behaviour throughout - the vmalloc remapped
ranges set VM_MIXEDMAP | VM_DONTDUMP | VM_DONTEXPAND for each range.

VM_IO was never appropriate as the ranges are explicitly not MMIO, and the
reference to the v3.7 VM_RESERVED semantics map on to VM_MIXEDMAP |
VM_DONTDUMP | VM_DONTEXPAND correctly - no core dump, unmergeable, no
normal vm page for purposes of reclaim/migration/etc.

There is a change in behaviour in that pages mapped using
remap_vmalloc_range() will now have normal GUP-able pages, however this
should have no impact as there is no reason not to allow this.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 83 +++++++++++------------------------
 1 file changed, 25 insertions(+), 58 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index dc548e6802e2..b02d1f1dbb27 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -70,7 +70,6 @@ static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, unsigned long arg);
 static int ctxt_reset(struct hfi1_ctxtdata *uctxt);
 static int manage_rcvq(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 		       unsigned long arg);
-static vm_fault_t vma_fault(struct vm_fault *vmf);
 static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 			    unsigned long arg);
 
@@ -85,10 +84,6 @@ static const struct file_operations hfi1_file_ops = {
 	.llseek = noop_llseek,
 };
 
-static const struct vm_operations_struct vm_ops = {
-	.fault = vma_fault,
-};
-
 /*
  * Types of memories mapped into user processes' space
  */
@@ -304,13 +299,13 @@ static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 	return reqs;
 }
 
-static inline void mmap_cdbg(u16 ctxt, u8 subctxt, u8 type, u8 mapio, u8 vmf,
+static inline void mmap_cdbg(u16 ctxt, u8 subctxt, u8 type, u8 mapio, u8 is_vmalloc,
 			     u64 memaddr, void *memvirt, dma_addr_t memdma,
 			     ssize_t memlen, struct vm_area_struct *vma)
 {
 	hfi1_cdbg(PROC,
-		  "%u:%u type:%u io/vf/dma:%d/%d/%d, addr:0x%llx, len:%lu(%lu), flags:0x%lx",
-		  ctxt, subctxt, type, mapio, vmf, !!memdma,
+		  "%u:%u type:%u io/vmalloc/dma:%d/%d/%d, addr:0x%llx, len:%lu(%lu), flags:0x%lx",
+		  ctxt, subctxt, type, mapio, is_vmalloc, !!memdma,
 		  memaddr ?: (u64)memvirt, memlen,
 		  vma->vm_end - vma->vm_start, vma->vm_flags);
 }
@@ -325,7 +320,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		memaddr = 0;
 	void *memvirt = NULL;
 	dma_addr_t memdma = 0;
-	u8 subctxt, mapio = 0, vmf = 0, type;
+	u8 subctxt, mapio = 0, is_vmalloc = 0, type;
 	ssize_t memlen = 0;
 	int ret = 0;
 	u16 ctxt;
@@ -347,7 +342,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	/*
 	 * vm_pgoff is used as a buffer selector cookie.  Always mmap from
 	 * the beginning.
-	 */ 
+	 */
 	vma->vm_pgoff = 0;
 	flags = vma->vm_flags;
 
@@ -366,7 +361,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 */
 		memlen = PAGE_ALIGN(uctxt->sc->credits * PIO_BLOCK_SIZE);
 		flags &= ~VM_MAYREAD;
-		flags |= VM_DONTCOPY | VM_DONTEXPAND;
+		flags |= VM_DONTCOPY;
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 		mapio = 1;
 		break;
@@ -401,6 +396,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		memlen = rcvhdrq_size(uctxt);
 		memvirt = uctxt->rcvhdrq;
 		memdma = uctxt->rcvhdrq_dma;
+		flags |= VM_DONTEXPAND;
 		break;
 	case RCV_EGRBUF: {
 		unsigned long vm_start_save;
@@ -422,7 +418,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			ret = -EPERM;
 			goto done;
 		}
-		vm_flags_clear(vma, VM_MAYWRITE);
+		vm_flags_mod(vma, VM_DONTEXPAND, VM_MAYWRITE);
 		/*
 		 * Mmap multiple separate allocations into a single vma.  From
 		 * here, dma_mmap_coherent() calls dma_direct_mmap(), which
@@ -438,7 +434,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			memvirt = uctxt->egrbufs.buffers[i].addr;
 			memdma = uctxt->egrbufs.buffers[i].dma;
 			vma->vm_end += memlen;
-			mmap_cdbg(ctxt, subctxt, type, mapio, vmf, memaddr,
+			mmap_cdbg(ctxt, subctxt, type, mapio, is_vmalloc, memaddr,
 				  memvirt, memdma, memlen, vma);
 			ret = dma_mmap_coherent(&dd->pcidev->dev, vma,
 						memvirt, memdma, memlen);
@@ -467,7 +463,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * user registers.
 		 */
 		memlen = PAGE_SIZE;
-		flags |= VM_DONTCOPY | VM_DONTEXPAND;
+		flags |= VM_DONTCOPY;
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 		mapio = 1;
 		break;
@@ -476,15 +472,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * Use the page where this context's flags are. User level
 		 * knows where it's own bitmap is within the page.
 		 */
-		memaddr = (unsigned long)
-			(dd->events + uctxt_offset(uctxt)) & PAGE_MASK;
+		memvirt = dd->events + uctxt_offset(uctxt);
+		memvirt = (void *)(((uintptr_t)memvirt) & PAGE_MASK);
 		memlen = PAGE_SIZE;
-		/*
-		 * v3.7 removes VM_RESERVED but the effect is kept by
-		 * using VM_IO.
-		 */
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case STATUS:
 		if (flags & VM_WRITE) {
@@ -493,7 +484,6 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		}
 		memaddr = kvirt_to_phys((void *)dd->status);
 		memlen = PAGE_SIZE;
-		flags |= VM_IO | VM_DONTEXPAND;
 		break;
 	case RTAIL:
 		if (!HFI1_CAP_IS_USET(DMA_RTAIL)) {
@@ -512,25 +502,23 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		memvirt = (void *)hfi1_rcvhdrtail_kvaddr(uctxt);
 		memdma = uctxt->rcvhdrqtailaddr_dma;
 		flags &= ~VM_MAYWRITE;
+		flags |= VM_DONTEXPAND;
 		break;
 	case SUBCTXT_UREGS:
-		memaddr = (u64)uctxt->subctxt_uregbase;
+		memvirt = uctxt->subctxt_uregbase;
 		memlen = PAGE_SIZE;
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SUBCTXT_RCV_HDRQ:
-		memaddr = (u64)uctxt->subctxt_rcvhdr_base;
+		memvirt = uctxt->subctxt_rcvhdr_base;
 		memlen = rcvhdrq_size(uctxt) * uctxt->subctxt_cnt;
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SUBCTXT_EGRBUF:
-		memaddr = (u64)uctxt->subctxt_rcvegrbuf;
+		memvirt = uctxt->subctxt_rcvegrbuf;
 		memlen = uctxt->egrbufs.size * uctxt->subctxt_cnt;
-		flags |= VM_IO | VM_DONTEXPAND;
 		flags &= ~VM_MAYWRITE;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SDMA_COMP: {
 		struct hfi1_user_sdma_comp_q *cq = fd->cq;
@@ -539,10 +527,9 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			ret = -EFAULT;
 			goto done;
 		}
-		memaddr = (u64)cq->comps;
+		memvirt = cq->comps;
 		memlen = PAGE_ALIGN(sizeof(*cq->comps) * cq->nentries);
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	}
 	default:
@@ -559,12 +546,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	}
 
 	vm_flags_reset(vma, flags);
-	mmap_cdbg(ctxt, subctxt, type, mapio, vmf, memaddr, memvirt, memdma, 
+	mmap_cdbg(ctxt, subctxt, type, mapio, is_vmalloc, memaddr, memvirt, memdma,
 		  memlen, vma);
-	if (vmf) {
-		vma->vm_pgoff = PFN_DOWN(memaddr);
-		vma->vm_ops = &vm_ops;
-		ret = 0;
+	if (is_vmalloc) {
+		ret = remap_vmalloc_range(vma, memvirt, 0);
 	} else if (memdma) {
 		ret = dma_mmap_coherent(&dd->pcidev->dev, vma,
 					memvirt, memdma, memlen);
@@ -588,24 +573,6 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	return ret;
 }
 
-/*
- * Local (non-chip) user memory is not mapped right away but as it is
- * accessed by the user-level code.
- */
-static vm_fault_t vma_fault(struct vm_fault *vmf)
-{
-	struct page *page;
-
-	page = vmalloc_to_page((void *)(vmf->pgoff << PAGE_SHIFT));
-	if (!page)
-		return VM_FAULT_SIGBUS;
-
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
-}
-
 static __poll_t hfi1_poll(struct file *fp, struct poll_table_struct *pt)
 {
 	struct hfi1_ctxtdata *uctxt;

-- 
2.55.0


