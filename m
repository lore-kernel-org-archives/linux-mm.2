Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8C0EC982D9
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15AA6B00B4; Thu, 17 Sep 2026 12:36:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9EED6B00B5; Thu, 17 Sep 2026 12:36:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967AB6B00B6; Thu, 17 Sep 2026 12:36:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DDCC6B00B4
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:36:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07415C03EB
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:36:17 +0000 (UTC)
X-FDA: 85223806794.17.1A120D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 39CBC40012
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:36:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BKmVmgXT;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662975;
	b=jBkFMVInAvoxskMjazeQrBO2yYZ8Y8HbIg37gLYu3F4nxG4MEqTMvQUXeax6LL68IxEys/
	Vjh/R7r3CUPB2/gr8gQGa9Xl9akipZLExj2p++FbH3UCzt8imZVscRY1D/Jc5WjJBJpRAL
	gohkYjg2zwpOnGLY2E57mux/u5Qd788=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BKmVmgXT;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vUpjFSCSmyvMLIG1AQYKTdJJ8/j63OLmVWWNJsaBsI=;
	b=e0mHCBBCSi0tG3aeFI2FHld1Q00MmDhITR+kIIPHFIZoT+qB/+VSvTGiUGQxmviJe+OX1J
	q7jHpjp2W1k3D27Kq0blvPm3icC0plXg26Ya28qC4aoBkb3t+kmc5UKiH2WOq4hei2M8Vu
	cHAST0KDNXVXTRFfVIRnbDJHnEMWXVM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC6F2601F1;
	Thu, 17 Sep 2026 16:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17581F00893;
	Thu, 17 Sep 2026 16:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662973;
	bh=2vUpjFSCSmyvMLIG1AQYKTdJJ8/j63OLmVWWNJsaBsI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BKmVmgXTSV0XK9j329Mx2rNtj/mOZsQ702ImyF+y7INTlqGVHbqkyjZl/ysBTl5EP
	 gj4PlSgHckU+9Pve8h8w0EFiLo2s1POYm1WQ6ZJIv0t3oyKUNtY69jV0bu64AmEo5O
	 V0fPEBosooqc3oZ0+ihMx3lb2lRUCgQT1d7LpA/vdctXRoKAfgIOW6HQfWNqsX6Zuz
	 HU8kgEhybiwnMKasm2ZGwrIDPO/b6mZtifZAbnghS86qSdsbjW34N95Ae8fFKQrJiR
	 6CfRv/sQNyiaU3DjmC1dGS9agHrzJLjuaKC9h5X83sT4B3tFptwbXa2jMl3AFBn/ZF
	 DBbFm1lN94l3Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:35 +0100
Subject: [PATCH v3 26/40] mm: remove VMA_IO_BIT check in
 vma[_flags]_is_kernel_owned()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-26-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6787; i=ljs@kernel.org;
 h=from:subject:message-id; bh=/qhYfBPmYatz10Dgxqp/JH08Wu0JRVlKPSmSPF2nv0s=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB+atPhJ882XD+fevmR+ytni7IOK95u3HTe9sG/rX
 Z95gpnX7naUsjCIcTHIiimyPP8ivj9IJGxe5wV/N5g5rEwgQxi4OAVgIrMMGBlW876vVtoX2Ljv
 lI3TOWd+hVWp5fELHzNoP7uiY2X8bnYyw/8sCeMZzvFTKux3FlXwVSqqHhAXOX3Vwmit4pFCBYm
 mZGYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 39CBC40012
X-Rspam-User: 
X-Stat-Signature: qr8xnexbc695ay7i7wf7jsdkx6g186rd
X-HE-Tag: 1789662975-144969
X-HE-Meta: U2FsdGVkX1/tNpfI/5jB7l9XvkktC4d0s4P4O8jpZpJC/qNV+Jq1BjGFcXkbpz30kq+K79J5xazS6mNWh5UzNrkl0ssxuTC/wrTeE8AgfiQFu5QR+1sqY4vkDa/Cn7Sz1UPFmNl4Rfci7z9H/NtDSrgQle9qOnxwHFFBsmaT5BzLH8Y2AUho0Gfxs9Q4mbYk0moXWiRvCxece40ME3v4mVSn40ej66PxcGXLlaz31RnCwJZQXJEm7TYGCl7Umu6rUDEsUaucubfSM5urNszadhyn9nOKunWdLnkfStIBx+Ku8VVXH5fQR0Vpk50lwENR+ciYUlgykyWJWTR5plmgcb4J8V0M3RzhhMngUUjM2IFbCAcso/4hHVBV4w3+hqYpp9FwtDyNo5Cajpbh76h8+7Na0eNjehVkKw9YgOJ101eRLHKAID7B9J4pK+UoU8vDGJxsNU3W8MjpnLCPI1uyNZxK7LyTL2umQeUZQNMfDrk9O9u/985kfiVtdxXahdsj2sIzLp4LXeevkTAHuiMYG1T/HBkCTdT6UwtCDWAGnkQwwJX3LKjyevSomFJE5zoMXdyJ5vcTPC9PQ/rWS1YqbgKbOO/F9CKluuyxpOjG7hELe+7hIStm6EcBtVq7YDRuTyQKk5S554Y7Xt4qG/rJir0aRtUPVpCKWWQ+ReGxK0jIJdso4/GOauc8e9MbJxvep7EMhuftPf1EaMSys3tGHA2s0Hah3mSevFTZxUvOoIBAT9vknjEllZ/Ejoe1E7+wkpTjuqiyEi5qRWCppOOD6ubRZYezAE4DBkJduDdnxqmdMoH4hajUYfN5QhHyCiPpGa38vt0C3iDCvhad43l7+VFNBGeTrfyV+iQj/EqU0MFKCGBBWK0I+m/kvlpzODhg8D9ZYOHLUfEb/KDcdAspn//TusIzFX2ndzd3W5mnlLKobCkftO4gKNsXS2pMa/1p3gsmSY+gdgLTYkpMgSy
 1Yl8q8A6
 FJ5tXf2lknsGwcTl2ZRWlKk8nOQsUSDd8PZP+iGnQgM/QlLykM/iWYj8Kzc/HNfaKhlpP0AVQTKmSB/Lc69yVkP6u5B+Hy1dpcFIJSKVWrGJ7T5WuhoyODs+YxLb0DgRsuR3Jjbh+4r1PI3K45oNUJVikTxOS8q9AHiOVbmJSV1kQLWNkjRFn6m/BcWp7riu19ueH3qlaTSEP//VHcFCvbxuzzo6UpzgscocLwIqXhLIdMsJJlLc1WvZjErh0m6jjC/cT90nTnBG5KP1WtiJKx4bc94a7t9VTIaJH9H5nHLUbt3kTqXVodxdPg27PcE+rdsInAiQihndLMmeKr0RvAAW1zAdsgbvQsJQtxfazD51jHzlBm9Kbh43OB/bKoIwo+Ed1D6AhSPlSdSBgqZ2aL4Fj6HmHn4z/AH49Lu0LlsdyFPz0E4I3TWWJVwawz50+0cFn5iDT2V+i0q4fxn9ytUnANvCZsSELcz/1jrd26EPp+HFuxp18THcvDpSgUxKy1USyZqH0SHRiAtURsPbdh9CabCfmsQC1ckYJ7m4CxRx5x7g7IZQGheBTWD78DZal7f7o+GRpICzKIgZxM/lDnraks78p0FJTYowTDtSI3rRJf0v2GtKl0VY3/mxzHz64sxay7UU85qsCtWHbhYZiXzUymvcXETS/5G5jHGH772Nnb6BW+qEVV99fd9Vkp+/rI3Yk9u1vFFOlWTr+DSyeoL7J0KBUdrv+AWb6YpitKI6H6iQCajNtQE/h7/KgkrEFFJwqOHmw+sodPpP4TeCpZaEdkxMcio9px0zm8SviocRHg4wZj8S8241/xxlBeE2jv6HvNAMv4rWk2jjviuCdtFMb6bexOHZlpowzlxRH+t65pcIDw7m3INBP9VNmoh+00KnbgsG+ZnFnbYWRJWcAu1Vt2u4Bjjzf6wb3EzUfv1HBERYoA1XNcSCtzczG/mbk8gy3jU1FHrxg7+KGG6YAKKYX7/Xy
 arU6Ghuw
 PaXSlYhZj2wr3wkzBuG3zS+Pv9D4GNw2t6JgzneryXN+diM0IwKBPjZ9glRyzJYmVKksETT+guWKVJ3r35E/f0MCY6UlDMmyQTcongp6IxV6g1XLQVIAojczjjB5ZFnaF0MlbFhpHPho3JCPXWUZo2xp9JE9lXuPzHzEMXMHfjNXot8XKeCUIG2nuXc9JeTUkkkQcLpEKZiX4C7IPRMLM9MqVRbczZRyTgBoypPwZBebI4rDibcYtmPkzgHSyFuKuUA2ZyXxYvH0elwdrUoOTUt9/5/xRwB8meRuosVNMVPhPmBSqWtOXhLz8Askx4IOqaBtFXNKMtsIUk+xkKosPgM0E2iHRK8hQzOCUIBHuZe5KZkFSV5RPBbd5mXDExh/jUdTwJSXHmQ2r/wx/FldJ8OuPZXpvLhOIAK0UwpawzH4AzJXiL1kkcF7DlIi2f8k9MzHvV3O+omOzG29+63eaZF8kyPaXFnX8q+fU9Abe/ViIGiK0YFuse71nyhxeEPYvGFkwhcT5TLln8U8jZunY6odp11pIr1IOsJ4xhqsNE5v+32pUzYorenmNyU9B0+qFHE9lzLFW3L4YDe0ZQlpN3xue8WAlGk0Vv8vHvjwGolaPSkCJlSYRw4kHvnmEF7FBdwDQ4PbJb59dXOloO1WxaqkzlfIhC07IkGFXDC405j6oJfiauwLdDijmbpiJZL6fTR62mDCyXULMwPcx9YaKGv/G5QegVPRwUT06RxlDMnZBPs9E1mDw32n1RZVM58dppQJ0D9UAvhish9jDaNmK9f5x1LkqiYF9Vo9pHZkYVTCwc/XCqtc3na139wjGbGw5XlGHXn5+CO3L6Yo01F23Xh9KdF+NQhMj37ckrNjAo9erowUalAjyRzqVibpz6MqHxgmMJtKw0Z3ok7VDU6NNFlsr1G0lJZ3B7UK2ANjERbcGDa7bkH67KNQlQAVHGuFWJqk+KsNbVhPsmfRPVH4mm+RbPxNC
 zIv91+mc
 7XOwwPTe0yAk5GmJR+YhXuSWrKSgyUVJA1GxPjGQJPdsMWOBURGYrnTZhqWmNgkZ8eJ2FVcrRMMtx/ZznrdZKcc5sm0dDD/FirBt9RV5W95z0sDAemyDCKWXZq/etNabxwVHXdFCygwFaLSOpFUqnMIBe2VfYX6udCQZg6ETPfjrGz6L+zujGkEifeF5RE9/r4GpIAU3YZK1WvtNnKyI46ngrw03Ap3ogg7tXDeeA8eb4Ahwi0jSeOZSOCUnsdc5bNBta1AVyQZSCgptByrOML0mwy1zy6D/XYuioLsgTyJVLADh9GvKsBtaslE4cHXPSAENxGFv2YYcmsjszAKX2HyTHqh7XX/igjdglRkbmJ4z2++DEw4jiZGW+ZT21V3ZguCYEnjftQXe0x5qlDSmy9rq3k2zu0Dt696jM2HMAMBMOKCT8nYpCmRppsW+TBeeKRLNDi5pphO9SAmXy1Z643qLJCQ6Wr6dTCtjuvbtg4irUEAwdU0iImBBcs92TPosRQzmZm5CXlhTAx8S/1DKo2KEdO5ACgFdcOGODKbqM6NS+yXIUuvAoS6q2v/dHnzEpZCQaVdIQaoCqS0LnJcQ39G8HN7N0tr91yIsytfChyT8ci+0HSNzle2XTR92Ibaq9vexnmudxeaRXu5gBNppfISSuNlxlKwdKcvvWJHUZiVY7lw+xA9oRHMQAl8nYd6MCpWe5GpiJ7YxJfH83pSd8Sh9Srcaqzaw1/GttJJGxRxhPtwCpmb2/QBwo8F81Fhy/ekfLiAurqK9QnMpaKBmi46b3WheeZhU7nx6zQVXxvP6y4ZVYkUD0Lv3+ANpGmlUv0z8KDaIVWaSN3ITOPUNXhYyeE6PuOzuTl/oyevzASlG/fjBfim6k364SPprO041s/av4e8YQotgwjZJcympe2dFClu+Bi6izZQtbnmTDwwGZScTN9zXTpsyRjT1l6D0qDgywZ12XK8dgnISZfHeUlHG68zOU
 F2aR2smh
 CTvsVNR2UkXXlRRhPEHF9z1XEcw2anUqtqhvnwfBgWXBIlKGlcx7cMjaggo6pxfRkFEKoJZ+MZlc/A/aiegLXFd+3NH+Gu7bAwuDwMuUIYrM2RTPiA4/YU3hIIS58XVG0Mo4635Wu1JSUmWFFb0t6dbvD+yjIeIDaDar75NLBD5hP//aRYEvy4uxtVR3Nt8MU4BSBX/Bj2bx+rVWyLR9eP0VEh+eHbuWWg2mDvG55ZSgDNmLKIO51XtzVMoKj/qyTN2GJPxFJ4C3reo7w1am6bc/Oz26UaWezmw2yQweDzlPKtybAbNqjBzpcA5Zlmb+Kd1V2TNUk2L9zar1q/1KZASGiTonc8LN8g+dU3SQpwsrVg14VfCjWoGqSh9zO6vraA4D6cJldHO34zyv2rc/uqebojSEf6hdijVySoKuikmvCZ3Y6Q7ihewwx4lg72OR1+Fe9fmD6Caw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have now made it such that every driver which sets VMA_IO_BIT marks it
as kernel-owned.

However, vma_flags_is_kernel_owned() currently checks for VMA_IO_BIT. This
was a product of drivers previously marking a range as kernel-owned by
setting VMA_IO_BIT alone.

Fix this by removing the VMA_IO_BIT check in vma_flags_is_kernel_owned(),
and update mmap_validate_vma_flags() to use vma_flags_is_kernel_owned()
rather than open-coding the VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT check.

This change means that vma[_flags]_can_merge() doesn't check VMA_IO_BIT any
longer (which is now redundant) as it calls vma_flags_is_kernel_owned().

Now that the predicate means precisely VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT,
also use it at the other sites which open-code that pair, so the intent is
stated rather than the flags, with no functional change:

zap_special_vma_range() only zaps kernel-owned mappings, as drivers use it
to tear down ranges they established themselves.

The mprotect() arch PFN modification check applies to kernel-owned
mappings, which may map PFNs without struct pages.

NUMA balancing skips VM_MIXEDMAP mappings having already excluded VM_IO
and VM_PFNMAP mappings via vma_migratable(), so it skips exactly the
kernel-owned mappings - say so.

Finally, update the VMA userland merge 'special' flag tests to no longer
assert that VMA_IO_BIT prevents merge as VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT
now suffices.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  3 +--
 kernel/sched/fair.c             |  2 +-
 mm/memory.c                     |  6 +++---
 mm/mprotect.c                   |  3 +--
 mm/vma.c                        |  2 +-
 tools/testing/vma/include/dup.h |  3 +--
 tools/testing/vma/tests/merge.c | 10 ++--------
 7 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ca598e5f9715..4b6aa0b47b00 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1630,8 +1630,7 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
  */
 static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
 {
-	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
-				  VMA_IO_BIT);
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
 /**
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8dff37059faf..a71f0ab79bcd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4212,7 +4212,7 @@ static void task_numa_work(struct callback_head *work)
 
 	for (; vma; vma = vma_next(&vmi)) {
 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
-			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
+			is_vm_hugetlb_page(vma) || vma_is_kernel_owned(vma)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
 			continue;
 		}
diff --git a/mm/memory.c b/mm/memory.c
index 45b21bb04a18..1e6cd2e50408 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2343,19 +2343,19 @@ void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
 }
 
 /**
- * zap_special_vma_range - zap all page table entries in a special vma range
+ * zap_special_vma_range - zap all page table entries in a kernel-owned VMA
  * @vma: the vma covering the range to zap
  * @address: starting address of the range to zap
  * @size: number of bytes to zap
  *
  * This function does nothing when the provided address range is not fully
- * contained in @vma, or when the @vma is not VM_PFNMAP or VM_MIXEDMAP.
+ * contained in @vma, or when @vma is not kernel-owned.
  */
 void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
 	if (!range_in_vma(vma, address, address + size) ||
-	   !(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
+	   !vma_is_kernel_owned(vma))
 		return;
 
 	zap_vma_range(vma, address, size);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d87..fe32fd87cf5c 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -783,8 +783,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	 * uncommon case, so doesn't need to be very optimized.
 	 */
 	if (arch_has_pfn_modify_check() &&
-	    vma_flags_test_any(&old_vma_flags, VMA_PFNMAP_BIT,
-			       VMA_MIXEDMAP_BIT) &&
+	    vma_flags_is_kernel_owned(&old_vma_flags) &&
 	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
diff --git a/mm/vma.c b/mm/vma.c
index 56a0cd154419..0bc3651abe13 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2787,7 +2787,7 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
 		return -EINVAL;
 #endif
 
-	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
+	if (!vma_flags_is_kernel_owned(flags)) {
 		/* Only kernel-owned mappings may set VMA_IO_BIT. */
 		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
 			return -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index b8b1462ca710..97d3bf6cd5b7 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1667,8 +1667,7 @@ static inline bool file_is_dev_zero(const struct file *file)
 
 static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
 {
-	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
-				  VMA_IO_BIT);
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
 static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
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


