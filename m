Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87397CC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E91F6B00E0; Tue, 13 Oct 2026 11:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0996B00E2; Tue, 13 Oct 2026 11:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F876B00E0; Tue, 13 Oct 2026 11:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5706D6B00E0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:25:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7A7C1A0D3C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:25:29 +0000 (UTC)
X-FDA: 85317977178.24.F33286A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 26A914000D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:25:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FMjrKZOH;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCv0NaTZZaDvMzzXCkdDmndUvsNKy9Jyo+RkANOtqUI=;
	b=bGRGz7SlkSt0mv0lqcPQOEVH/40tBYo3/YNVvS65MnSuQUfrvv92zTyfJWUkZY4C2MccrH
	BEBUW7DuX0b7gNRvjs6JYL3mghR8+G1oZ5mE0mU/Ki8EwojDdOUriZXvBFGHq+MUwefSE3
	o/eG52f750n60rQvczIGCBUOS9XnL3s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905128;
	b=ETf9AfjTpGjBoatmLSzeJNtxSALpebE8ngZ7QDw6ZwFwr6NuMBYJhylHRIqs9ExeXvYtlb
	zEGJ4r3ihD2mVS4t0TCN8eCiJaYz8YL3qJX8eRM0faDp69aRLB6opm5ir6No8myHC8XRxf
	1I9xUYqsNG7z1y1D1XxPb+Yf6PBGvLY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FMjrKZOH;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 971D960A56;
	Tue, 13 Oct 2026 15:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA471F000FF;
	Tue, 13 Oct 2026 15:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905127;
	bh=TCv0NaTZZaDvMzzXCkdDmndUvsNKy9Jyo+RkANOtqUI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FMjrKZOHHFEaQpLCqG5p+VtL+jzPjtxpocjVZL7e1kbYfn30WJaFXDqj8oLAPFlFz
	 aQL92iAsTlCl6HwqjdLfXKp0thGkdbuUN4kyz5fclwOtHmcoSVYBDLEgyd3A9OAtJ8
	 Ofi4FlTlzxEEND/1dQrl4/jVI/AuNtr3ncZjqLlzwl/bf/dKyIOVdKtBUS1ay0bx2D
	 zrbtjqW9qUoBdh5UMCi3zRuCTWCIdWXohvrNyYX9ynVK1DR1XfeDGGWeP5T3/OgN5R
	 FHOY5jRArmcQAixkdgaU6140ZO8REqrXysEHI4teZQn8q1idJENF5EOEknwZdNXwdD
	 U3YWwVupwpg2g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:17 +0100
Subject: [PATCH v6 37/39] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-37-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2224; i=ljs@kernel.org;
 h=from:subject:message-id; bh=yq2Lr6CjFbLqL0YH729nWyHorxh6CDbq/l7L5vUid8w=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZxd9m3NNKYZi87rPPdlMe15fMP7zOSpldH7tq94c
 m2uhNu5ko5SFgYxLgZZMUWW51/E9weJhM3rvODvBjOHlQlkCAMXpwBMJLGIkWEn49IVRksSqvhd
 bdqcZqyePcVJ+R2zu9zKSMPalB6/68YM/4MmVC1UXLRqkmhe14WAhyqJLRekWJ3YXFYtyAk9tFl
 DnhsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 26A914000D
X-Stat-Signature: cups8eenut3quhasj76hf1y194z8n5kz
X-HE-Tag: 1791905128-118497
X-HE-Meta: U2FsdGVkX19fxOf36vXlHvABXw99lXmpSXA8ir6EQexeq07lxQWAANYvQ9HE1HmcuoQazWGRriZbEEzQum1zOZnpOjYyDTurxm7k2Ur3do30Ypz5ApTPnu053qgKh2+Xs2e7VHbmRw1qeECq4iLPhaVofj/Ws/TIrupNifvIqmjlsr0SVTy/RCInnzCBcWGOetSOosR85w/ORMdCdrYr1cAJ2p/pU2Iszzk6shbw2+QKShfDDR0avhm8KJneaB5U3b6fa1VRMHcMUUH2dvlKeKhL1q8KuBtU+W0jV/GDhECLK4uzDeaUHBOKEYZg5im8Cg0LBYAXasJJW8UmQSwVp1NnV2jq3j+8Il8fRrUh6HXptH3dx0UY0gqGDvvXRrs+XWTbQvct6mkCG16XGh5+Ocxv2rgL9UxQXnXwX+O03pqeV1K1GQvI9lhXZH85yF9eSfbZ810+j+HKtGKS69AFGodCW/nnjLujL7J53LcdIM85XgVScEho4PXLc9rWpVwqzVWBml30OZbXiG62dLCOmABCCSq+v9WCBzi7GV2iWg8fWu1GXJH4BIRBYgMo28cJO+hzyUk2tKaWfA+b5esGX/0FWInHpVWb5D6saZVfnqV9SBSGtXK4QIBoOGGOoBhGtmI/ejarFSAHPw69sOvy8XDC8WXDhpl4/RNw6zf5mn3Rav6amuNg/xMgrscKAOWgBf7/tI4LNYBQg83JN2KQBWng3N25U3UBI4WGtUgWPi9stb+p+LrV4w3YBmehTWUBE4uhJWVvbaiJRZE6Y9oBm8unQ9wcZQqTdGfdQflRcNO0/UqhZ8mgEOh/CHHMNE5ykthQmR7PyDa6yaEowsLDtHYUVe1L6jSRZhoRduaqikeUn0wvC48xVB1MlaRrNWUJLcWYxulKcEE9XQ/+wr9/3BjByzphe30BipGiG7/br+kTll1GmWFmLstESLvbnKYWdGXgENIvJTZDDTmP3sH
 UWaQyQsd
 UqAaRvPfZXvmg3ZI2fLXUgA+Xybx/WsksAHXhLYrPB7ucSoogWzHMktJb1cBqAqFMYk89YowusUZ9+tE+ECOpkdeeSm2hWNT25yeUISaGT40WqxT7nTxYV2OYtCpYsGq66lPgYWQwKUzVDN4DW3shcvNmyOfbhlgb7r169Bnoe6xAufN57p6BrEugkc4kk09BjRyHDSp+6fz+qnYIhFKN+yoWtsFDXY8zzT6DBXZuTD06wW9YGt98Eup8BYn1kJvaB+EkIwUS1uqcegnFq9nqnkCLAaULDjOMfvL5+yHMZu6/IkNOp33DLyOahZYVFMSep8V7eRbhgpSx/fIEfsq1YwvvIvzcf2CQKlSPj2wY7PS9Zm8i9Txrir0//84ZrMLVgWgHgvVzQXuj9k1XF0FtWkUQcZlBce+/j/G+NepONVk5rk9SrOQmCQBAld8dTBiczGLg5wrMCPsD3ikiqFmOKHumCqb58IgEJvs0z1vXHGomcUho8sK0v4zeH/nfNAUpiZeVQszys7h1O8JSLTgorDtFpnESh2L4QcSyYns0p+bdMkhkvM0dSrA++JggEk6pghj9QRJyauExek9oHEaIHffzuI22M0IbkJUWRndyD55r+eb3edQlQPl3vlosLxKjQl+jxWQ/NMMscEuJMfFSLALAzE/+F3cbkzNZC+HGLYZNzf9dimFzM8GdnT1dK6sTViEKxMQnxAUkFu3NhJSFS0uAWJn98vCk/z2lNaV2i4QJVXM34c2vYGULmvAWNPnGHK4Db+G6dTM1vghgsXmgeOUpiceb+H+DdSUEzenigqEebiq0qGlh6+Ko7KOe7G9kVDxlp2mNaqtHaZA8oaL9PnJs0EMmzs9B09N49pMemLeL2u1aXVU90sIHev7iL/9ef9sYAsh+fpY1s24mw8qfOyImihNTzEJthHUaJt0f0rb7VL84b2qaRAgI43YDeg+QQ6+T56HP4jYnUdx6jnsneSFFU3Nk
 8/g/St3H
 zrjL5Fc5P3kwURQYhQ4tCrBEVzxnBnuX7SPdUL4ajDzbJ++tIj4fI1nxwZ2RhGrPlnTPpSby7Rsyviey4ERZrpAeS5JbtqXSyJrNuY/y72DqRm5Hk8CvefPi55o2nysqJ0YkEAyF1D3n99oIeR99v2BQbBMJ7I6nJRsBlANbp78VRIk6q3FQuH+mypSsbDCFrBJElTVL9hMmOufhZ7DXpueLHhcOJRmF308QxJuHmDPxqgfLIlJmTWabICKLETZX+lavqRXcWp9PT+U3RK45+S5BnCsbAFFFZhgxv1F0KpdCgMAsnusv1uTfnPGqsqUkIqIBe+B3S+dcMynqhQmmpvbrvsRE8CpsmzPMa472AA3+nthqR1n7GJg3g5+dUunzzrbDS7s/QytG6pu2d8JuBBB5oyPR1m+C5/YMj/upBWoj80w6YYZb7mPZ6KtD5KDQEZjwwsUG1abVkQI2D3RXatPThbrigw8dg8zH8GSTcq6tVCzCoDtLdbIyVulWV8P826ZJXaiWlljENfdewduuYPT3fpmw+bnEInCkjvzn8D/4NtOsm67QhRJshtaBml8jd6CiTLCunqZh1AmhmcHlvU3xK9ZhAuw0fY3BT5MSO/fmDfA+bJxBCX2hVB6NFoFTx8kMdrUellV4ugKeak3lleTIoCXQCbpxl2DCJS1uWtM7kufCiFRKFhUCDWG3GM/JONxjmKulVUN2XCLXP2aa4guurw4RZw9Kd17Zs7KlQ4hX4lYgWYiRSW3pGV5VOMbcPsxNf1mfcsuVLbpHIEhsvQIXG0xk+Mas/ULVRKmNkj6XB4sYHNQqUsNftSLVIX9Tj5VxpuVqmfOiZOApIPrnl4QMVcNWwaefyyKI/AvVbD7gDcsxVymhe7qJcNezy3l7gOz1kUkkUK25YEbYu2Ge9n+y6oRvfC+fPC1TJ/ZicB1eYU1zQczZa364DSDKUL3UrEF3ODPlkk2RnG7E/p6AH5bsb88wZ
 My010GoJ
 7VXAatXM4KePZyl4WAeFNgAfSkeZB0ss14w3ncnlE8bxWjmnkb5I3cH+iQWij3nKKcFRiCcGPOwPOOpDXLn6JeE9c0tekLzazf02VrWeEyZjyEhoKsAcZ839nNVaWOn3ClZq1VY0IGX4zKFUx0NhN1YE+gFUq3Zflq/Xz3WQKuCB671M1uGs8dVWH4hbNKRHALi5mKNk9NtwAz3u21BL5p/HqPv1fTAk2tPpAxg4iaQZmTfCLh1inDo5nxPmsvGdGO9mq6jnNpVr60mSuaesu+TSBJhMH1qFHIntaWzE8jCvdTqrwAHE/aeuZyKhr7bH37e5Hh4oZLO/TUfwbz9RnS6VeaZp02me4dDzV3gU1bZC2s0vsity21ZN6Hwu8GbozG8q661AfCBLmGEGsfN/FFozq6JKNauH6Wr/j9ID8LVAHr8olvPtGP9wnyPxniZ757LST7aW5He75cyKn7lIbzNYGU4PilXt644YQ1RG4xhhnWN5wVt2tNnqMvQponqvvC2rSH/LLhIok4ekCPmndsgc9jAowP6em2AO1HejCXiqnOUktaBN/wz02P8iclby64lzZLB/PaxjFTUzYY+/MtNRyu6/K+xwNfofL3D1ZNoWP/p2UKZaPiP8GG1Q3kQXQaIoOpZnJIjY+wcJEPtL53W+59NdwVQ2sbwK+Ie4Xl5nTX6vUrcMO6b0yo99FdzUsnqo2M2x/dRBcBQScQJ7/RsHx4H3Lhxi1hVMXIO97W1AvrWgjaBrpMgVH5XDu1sqc4Y4zZi1obs9GhONybu3Iu3qYs0ne6yGScOPO9cEj4Jn6x1rqL4ilVGW4xlIoqSaJMVy8hMfw/0ZyTCAgksPwJNYwqNOLI7d2DVfuvUWFllmiB1Tw/8LU3wOu19omPxhM41FXFCd7TLxMoKLHxyaoBl9yVBK1PIOTGUj9P7258aXPND8MMRR0Gm4cAUAXBgb9IcIAvp00bDr1WWHgIphsOk4rlR9J
 UgQOE7jW
 R7zGxJSMYcOaNRJ1PLwzeTiS8XwQmlrc/dISujJvTeXZ8HQ74Up2oH82OrNnYAkW7Hy/r9jcvmnTh4Y99zywUmqVEk1T7+CeknuwrX9zMPjiFda8Jratjr9d0hYYWaFCafd0gqBtD4LS8pSoV8mcbGLxuttVUoQrj5sxqY3UAa5zp+0mcgPN2B1Sn6e86IGwguZT6JNQG5bBGV6whODEptFX/Ud/fF5LbHRdQb79qGdn1JJ5ej+rgHRRu6M7anAUd3E3A+yzxSRHDNJ0S1BePOBdNYYv1Y0ItYcBqborFPMLbM1xJ1XI/QEfW5DvzZiaIvMWqZ814Ynx179mrel/amkV3h+Wst70lgaCfIcyEG+XobtSSTCw+FyHTS75+NUOehbnbIrED7kGnAot92AEeQOulWDPcEOCUug6iK1P+/As9CN3ieLYcakYCnRmSdCvmrmLuxv2l3TlfrS2cwkTbDKzDMgnPz+ZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted to
predicates which explicitly express what is actually being checked for
rather than the nebulous concept of possessing 'special' VMA flags.

In any case 'special' is not so special a term of art in mm - it includes
VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
other cases too.

Therefore make things less special by eliminating these now unused flags.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 8 --------
 tools/testing/vma/include/dup.h | 8 --------
 2 files changed, 16 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e8d2b0e847b3..c5644732ff0f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -576,14 +576,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-#define VM_SPECIAL vma_flags_to_legacy(VMA_SPECIAL_FLAGS)
-
 /*
  * Physically remapped pages are special. Tell the
  * rest of the world about it:
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 19ce10faa9f3..953895832901 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -352,14 +352,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 

-- 
2.55.0


