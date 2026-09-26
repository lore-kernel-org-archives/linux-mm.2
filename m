Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E1A3C98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52FD86B0088; Sat, 26 Sep 2026 06:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9DB6B008A; Sat, 26 Sep 2026 06:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B736B0092; Sat, 26 Sep 2026 06:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 120AC6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:07:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AF57160895
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:07:10 +0000 (UTC)
X-FDA: 85255485420.28.07F5C1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0772440002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:07:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PP6PZ9bM;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790417229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cx2CIfJJRJI8nlg/LkJLWm6mTZk+oyqA+tLDKMt8K64=;
	b=nLUPYfogO1cTBgj3zongLJw5dTjPjiuvPjBPT2U7papUTHCQElpPZQf01lytdgZ0ruE2M0
	wc1Z1d491P/i0A/33bM+86mPzRFaUTEspkX3cmVu52XsWy++cAf+LQn8Iwb2TihJnjNVAy
	LWQMAPvHkn84GGz7IBwl1zeHAs4V4eA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790417229;
	b=MfTpE3KcFIu9nj+GzwxwAS7n/zWjChh/ogNYyn8UkKcIoTYvo7xgTbR/ub7rLIs1DOYauX
	9AsE0B5efp/JFOq2OrLnzLPDboNFg88WEmY/rv4D2CS1tbI+U2BqY/VuujbY6vbRg0Eq8H
	pyHsXCREB1uZB/zEowsdgHXLw4DX1/w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PP6PZ9bM;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1DBB6021D;
	Sat, 26 Sep 2026 10:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8511F000FF;
	Sat, 26 Sep 2026 10:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790417227;
	bh=cx2CIfJJRJI8nlg/LkJLWm6mTZk+oyqA+tLDKMt8K64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PP6PZ9bMZs7e/duxeo/+vo5CsbMP1Rz2+y31gRT9a+0I5x57hx+X0qV3VH6ZT4U4G
	 yJbOFXBGKOb0K1/wzI/4ZVK66vC39At0uE2uwbtQ83oA2SlyEAWclRJagc3OIbbqHm
	 aGWgANkkLmApMwDJ2U+Pphh/en/LxpO06qIoOaCTuD43Ohhox87eyXx7fdho5yNs5A
	 YUbNxgBjyK8Pa4hT+QXLxoaUyk9M5Ul4my8apPo6NoSv0IFMgCIjYXvQDeUqZfUlWm
	 gpsK8pBYkPTzDaunC56zp3EElzUI0dA/SJCNUEjE1vnEPzCd1n7uEW6cQm5qDqJMYE
	 NMKaLYXBxLBUQ==
Date: Sat, 26 Sep 2026 11:06:35 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 16/40] mm/vma: only allow mmap to clear
 VMA_MAYWRITE_BIT if kernel-owned
Message-ID: <areYqRfd7mss9KQG@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-16-4583d8a23bca@kernel.org>
 <DLOVQMACWLZ5.1WFOTGRG8ZG92@nvidia.com>
 <DLOVXY4VFCXE.1RI7ZSD30VHH5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLOVXY4VFCXE.1RI7ZSD30VHH5@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0772440002
X-Stat-Signature: b3659ntxt3gjonjub9i7npywbrqrx6tf
X-Rspam-User: 
X-HE-Tag: 1790417228-112462
X-HE-Meta: U2FsdGVkX19S6/KqlL+olVOGVIKR93Lwnqk4Q3WR5PkgWa+2f4PWaWgddRPVic4wnSbBdl7Cbpp3zGBWZ5uUJRNzOWnWb+ZAA5KiVfUZSSKObBYAkogAKa3FO0bjgGBu87V8kDeudqlWEeOgIj8EoVKRrOdLDA+cPOtlxjvGkt3akKOPGrymw0PzCToDuKaiIwXxEx73eEXWdYJQidxNljml48ae/FZDUlL4z6ySDWvQNhCx0o1Rn5q1jEGrfZbbS0/lxeLhtlcsPA0QC8te9iArEAw0ZMkcB3wIoJdggMWypRCV4sE2g/YKAZWqQ12xltwl3cAGuPbtwzG4ZkeYUnsbIca09vM2cT4Ho3MT5LGmdGrUGlsMP4s8OuNrurnoYOm46VTW2d3Zryw8rFbw4wnaYKMGYS7UQz9s2GYzL3jfvPWLaub/sp5JGMyAL+ssVCx8VNu8tjdDOCecr2jCsloc2C2GXbJ9OVLYIvEEmawv0YgLedBZkIBZqkRhuFGmwzzQzDA11zJc/Qt9nu3gcIqPTmxdlObWelHARmHf/bJrCcQ4DOVhZNrAvSGgRWw2z/7o9g0E45tPKc9Jqe1zS2Lv6snHpg/hBUab87hSf0w4XnQ82WFROq1S4hxwEJHC+GJHHutiDQgHTFJifSqiYnyCVngoAQnWZ1YQffbDpP9GiubtyyRUeYL4DUjCX+v+4WimDdfQiEstk1Qk6I7X7YXq2AfzY3waNbEZy65J9I6vL0zuMz88in6b5SvdOQuyOBqZxwjJvKVR7U+lsS1DwZLi9Ywl7ZK86FZAZ7sFhSYTZzL4m9qXhOUApAzh3x7yShXbaAC7Cbqf4Upx+naaSmkf3oA2Lz0QOR7todkZncBPM3yFODF8yIF1RCMvc895thKY7R3PEbl/4gcjhPdZypnYmlIM9bXpW0t7Vu5x0d9ClgxMQtLceG8tzsDvSDVS26Ts9FZ945m3r9pSVfD
 eyOJbhKw
 XfIHaKMJOhjKwmIOL++Gyh/CjjrJL3r/KBhM77cjbttnDpvtH/BVfAdkJcVAXVpLLOEOc9TiDt1rV2frwXupjQ6w1OGU92D1xFsEe6z/zSe0ME5Y6p0Hbo2dGKEv60PLgaaDzkFowGj5ROM5b+/yFbiUlApdBJGRoHnSnRwsezb3SrIFNKt1eBGO5QjJ4FG+HzBjCztUIdAKkpozediEhBwIgXgyrRBNr0EpJmCuGzKlUq3972D7CjgJsVNd4lGN+eDFLenVOsp3E88gkRUbh1wswp77ZiE9eJJAFxwGD2dDbQPE3qJnungBptKiojZm4tNPXUS2xtHKQsd0bNFoczS/de+2dicYC7rTu/xDKspwc2JS6pO3kUR2pyVT6DY1NlbrXYh8ZMkNuYmTYxqnnPyyAkbPAFWEy4Krld5SNYQIyeBgWDwN5PgKsbj672ZysUQcpOtjLvAZANCT++l42anI1/tJeRP3vb+jUamSEvAyF8YMEZnRickVU3SMA/8kuAFlIZIRsn1jw3Bxtph6oriGhMb+0JEQ2T9NTUVQLjvFsvkBArqsshFkmdpguN/1yDv+v0Ib1sDqc27bG0JsUBmj29ON3mPrqZ9apao2qma2iRphyXo7cA2RK+pTSmXPt4zYIRwv31nZZXmctAkFfjGx3YxQYfFWuHf+OB33RH1kX1DLWWhUs/Wiku93jALnLMfo+IusCXqRt81dK+xfN5T94QoiFa4FEFmHkkWGfA7ucPPugBC9UagEyrPV3UKqlycMJJkXV3vlNThhQkZTQjbzr6vxp2/sh0DXlMUtOCEUS+XSae7DiRsybROKB2XlsNagFfJsaGf3RMsb/XExfMzf8cycPgKAjmswzQogxNvpF5zLVeSRrdbVG9zEBW+1uoDco2kDaNCpKA0M0r4a+I6JjBZS6oRgUUcreKnfPYLY/X9Vg3rk4Yed3MV5KXYR9bHmiECaVNYk4wdTEYJRMUVzJTiNL
 GE6pbcjX
 pWKVERYvM4X9Ei2n13eXLsUd0NSndjphc2lhNH6otAIEnJF8asjOe2V0nitvUU8ZIn4P2YeLeT7QCOUT9FJhJnxrS0amtLudiyGFEw8xGhL1wJLOPkkFgx+PY3egrqsDSDwUv2Jd6orqBXAfB7AHOopPpojpgT7NDdvBiITVZYWg/fD0fBc8bUvklkioilfIg6ROO2HJRc84O0BheXH9aAhXZrNYwQoLTn9Ig6Gz4jxcUAJcXMsfPdhq0Td8ZeXM30A2zlxY6g2HCsfkUsTGBoQ8b8ECKZnrWHaHChPTH64GLSok8H43GGtoF1pwLEirGsri7BFLSg/MHD76JeWk7n3HJn+h+PWKxEYbAyX8tZ5onUr7Yr11wq9BgQf3lbONo6VoWcng+ZwFWWu9e8ZbdxCtkNS8e2//RFapq5g4yzIrkYFVHletL40j9RrU8gVxRaA6+PjRqhhewzDUIkRD9pyfXgJgW/dEzpGjfc70cU9Z1ax8xirpvvHrvYmR7lG5/JK7+Fb8NcvQIMvHNSSaTfAOa2RUMceSxgYy3n+0rW7xa5coI+Js59qmSFJczrfiRjOhydT5anU/O+mG7cDebxTkJLzX5M3yhfHOU7Vee2MhU5gMvCnEqk8d8vUNHxnQO6rmR2sCUWAIjD4sgvbZ+B+d3YvnyvA79v/Q6PdnhfLB7AyIoTbHaOL3PjefAjSaCkWykM8tC7cDjO/ogtAv86YqP9jzsAWp6vWxbacvrCB58BOwrE8RsFaW2pLlDkRzhS7kEL4X9mDjV+4+83UvjwqU3cfTXnWhFlDOdQ2OoGXxNM0xMaxexFViGeVYLrwbbq8QfgfkXK2JqCRpXNhLubBFWXSpcsBgI14DdC0FyIq0Ulf1WLepoRVnEyTSapq2X5v2nDhi/1pjYrIfS9ihIrDem2AomHJKIWcbIjtrcRp4cNV42M9YJjLIrq0w2x3wPoyL9DHJzji0OQCscQzWmO5JAM9dU
 RAxXQpF9
 tkvhMMLylYti1otzkCAQhhQIrA0L9Bd1AS6O7TQuxPLp/G5xdWwSWGx9wo08iyI0FIaEnX3nW67QcdWouVvHnG/EvlIyfx03HCx/IAkCTc8Ve8QsVMVK85Yh0eoa07+KhhQZm7DMhyxTXJn9jNoyaWngMgcPWZp9KJcbhrbT0E/HOF2kZquRKBU5GkhEPRtwWZSpJcu6BmImFN5hre+E/QrCfJ/3UV4a6/go8YQARIyRXMjMZZCmDiQNkBHXqXLOr0wkNapsd/oQuP9f0K817HWDQWFu5FqEKljnEGR8CJLFPaLor8cKOkxiw+C8mSFM7Vpxm7nr5UPzpObNTbsmYN3U49whst2+0QlyZMDSKvep3cu7yYlQYr2lvOnPuDNXN1tk563gyi8akCacpOQTr9KTsZ9igu63kQDXHT9iYr3YLt7QDMz6nwQkgIK3VqFiR+hPiGnHH/HjtrqS0THKx1R/0Au9u+3Vl4sCU+xuVsttiTWvxY3KC8s+ocjtt6sN+IOvW/KWegWfLV5x2zdXaadG14bLbH63JCGgHwUNLRxDFzi4eEQz23Xd6vucPmelq1jsTzu+CyLsh5EQUVC10XNiqJ1Y2svSIMDhnvwHgJKB7FPB6kEP07QmlFyRjsSTs+oFgS7iXWOH+ORVAPs5aMlQ7ePlEOh+Lbuzbj2ghg4oKtFf7lCDUNrxo5E/zjyhOVliZyTiz1OutnxYdUwfQT56nQDaOkxTsUsAz/VUC4Y8VozTOh5HAe4oTkIJR0+npYt7jSXSQj5mBsTI84X7t2D9d1VZyX/nD+796j550eDSiqdjJlml/5ymP2txiB4bPDF6B1E+Y0+iUt+7FF77K7tZb76GRsmNHgsnbDF/JU0l0qK31KP5/mG2EGjFK978tYz4xT24QC4rx6noJqfxPgUV4ACZv6oEqUoHoHnO9UvvEBh7CpEt/TAtda3jii4PvY4DhcSpjYukX6p/PkQWG8JQV97av
 5dRTQ5tE
 HVxxp7Zi8jCbq5iICuihi40GBNdhYecOc1yc0bTA2oCUlWdQzb5w511Djo+Rz9sfvgleRfLcsEKr2LN0+Z44Bv8VCU38aZmYV+tssF5kRTfr2riw9U8e0y5XsgBa/ldRgmcKA5Cw9TEyOpEaIzPSZQQVvKCDABoXY3kVyVLesna7Nt9LSCUTZ1pMkbJf1r+rGjy13zF8GBmA6nNU481YEFxAQ8AzD8Dwy15cc9YUGyZniiyglk2pHoBAKmVKLfcj8QCicRHgVlwD60ATgEhOHfoQe8WOIqJsw3wN/tf9D4ylEOlxlE5snPSAqhcrz7jKTi3+aGbWkJXH/uYQKMuJ0Y/byrcNXrUrXAKgGGKYRLc6STSqj02q8HFKEN2W+qLZ2tr2UJ3sgGRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 10:17:10PM -0400, Zi Yan wrote:
> On Fri Sep 25, 2026 at 10:07 PM EDT, Zi Yan wrote:
> > On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> >> For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is if
> >> the underlying file is itself read-only.
> >>
> >> This means that mprotect() cannot mark a shared mapping of a read-only file
> >> as read/write, as doing so would violate the read only attribute, and
> >> permit writes.
> >>
> >> In general, we do not want file systems to be able to do this for
> >> read/write files.
> >>
> >> Doing so would violate fundamental user expectation of file attributes and
> >> likely break userspace.
> >>
> >> However, drivers pose a tricky problem here - the /dev/xxx file may be
> >> read/write but provide access to a resource which is fundamentally
> >> read-only.
> >>
> >> Therefore we must allow drivers to be able to clear VMA_MAYWRITE_BIT.
>
> IIUC, a file's FMODE_* bear both fd and mmap permissions, e.g.,
> FMODE_WRITE means fd is writable and mmap is writable. At least for
> normal files. But a driver fd might not fit the same pattern. Would a
> new FMODE_MAP_READ and a new FMODE_MAP_WRITE help? Not trying to propose
> anything, but just thinking out load.

Hmm I don't think that's necessarily at the right level of abstraction
though, and these drivers need to do the same thing even if the file is R/W
regardless.

So I'm not so sure that's the right path.

Then again, if the driver could somehow specify these modes at inode
creation or some means of doing that it could help avoid the driver ever
doing this, I'd really prefer us to disallow such changes in the hook in
general.

But I think definitely one for a follow up :)

>
> >>
> >> To achieve both of these things, restrict this ability to kernel-owned
> >> mappings as identified by vma_flags_is_kernel_owned().
> >>
> >> This constrains this ability to drivers which own the mapping's contents,
> >> whether memory-mapped I/O, kernel-allocated pages, or ordinary pages they
> >> map themselves, and so define its semantics.
> >>
> >> Every in-tree mmap hook which clears VMA_MAYWRITE_BIT, some twenty sites
> >> across drivers, filesystems and bpf, establishes a kernel-owned mapping,
> >> with usbmon and the ALSA PCM status page converted earlier in this series
> >> to do so.
> >>
> >> Note that drivers may, if they do not gate on VMA_SHARED_BIT, be able to
> >> disable MAP_PRIVATE-file-backed mapping CoW semantics.
> >>
> >> This is perhaps not always intended, but we retain this capacity to
> >> maintain existing behaviour.
> >>
> >> As all drivers which clear VMA_MAYWRITE_BIT establish kernel-owned
> >> mappings, no functional change is intended.
> >>
> >> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >> ---
> >>  mm/vma.c | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >
> > Makes sense.
> >
> > Acked-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
>
>
>
> --
> Best Regards,
> Yan, Zi
>

--
Cheers, Lorenzo

