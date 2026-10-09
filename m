Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4612CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC47F6B0088; Fri,  9 Oct 2026 14:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75216B00AF; Fri,  9 Oct 2026 14:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917756B00B0; Fri,  9 Oct 2026 14:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FB0A6B0088
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:09:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EACD3140468
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:09:53 +0000 (UTC)
X-FDA: 85303876266.23.D2C78E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2903A40002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:09:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eMJIih1Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJvW4vwNwue9hYXHoVVoy2mw1y7LjTNGlUYGA8Z9YPI=;
	b=WUMBkL3Lh5lqU5ZPgDZab60XrEdfQTC3ZC4rPgmdWr5YcAmLrfOv/f5RUUX9QQGxpVxeuI
	c8uPXIXbEw0HVIH3E7eGlnIaer1zJGQ7iEaeiNkqG56IM+xVM5l2slSYs7fQdpeKtJQ3f1
	suXJo8n1JbSl4r9HJitBeJKOcLqmIh0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eMJIih1Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569392;
	b=k4X+PUl2JgJS/YIo7yiun2aBqaKxPfzOoqcPlI71aG81At6/7Nd7woOcP8iXmFBWUz8FSD
	Y7WlwNK7zq2OPuyCGy6fZ5QNA3WC5Ecr/Qmx8r1kE6eKNXxv7M0bBHkvfClypxUY9LfIvq
	adkJT4CyACdr53jNzuQ69VYDfD4wfuo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D2D3423C7;
	Fri,  9 Oct 2026 18:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0351F00893;
	Fri,  9 Oct 2026 18:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569391;
	bh=dJvW4vwNwue9hYXHoVVoy2mw1y7LjTNGlUYGA8Z9YPI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eMJIih1YEN8CYVlMRY/ORVHZGGxLbjE063LoOLQLQinW2xtLSHaQ+vhVFZxWG0hw/
	 3N3GLT2mXl9hM7Jy3IdpWPYrstwohZ+wWAWehVqWRcwl5Hg7uSOb2DEGhsTMNL8oid
	 ESX/xx1VXRVhaYHQu8G/8VJASAOTybkXofYde316mj7Qr2m2O2dT7fIW71XyEg+9+Y
	 s5LkmVtQjaPn3506bBx2LTl7J2gcBmreElyALmWou/T50jsqaOkd/M7GNlHAzMzsvy
	 e7gUtPmOJRB03xHkGNzOjdEO9pNR9Aa7TIfAipvo6k4Q2A0KOC1q1C2/Skh4BQ/Mbe
	 9557MZhvD9G2A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:09 +0100
Subject: [PATCH v5 15/38] mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT
 if not mm-managed
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-15-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2298; i=ljs@kernel.org;
 h=from:subject:message-id; bh=yyTb6qa70UHuQDT2/p92dj6MAkJAoB6SoUmZKZd8e30=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sz+kXTw3r5Wr9bHK6N631gZ39/xaLW9/Tc3rmlq5
 1bzxb/37yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEPvQxMsxccyqoIbdbnt3K
 UGo390wbxhViC94l/vh/t9S3wah35gFGhnYzKw8v2Ysb3EWOPbkk/uHE3W4tq6PJkSxF6n0zJ0n
 ncgIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 2903A40002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 1qozyi77414755bx1pyzkqmrpkesgzzq
X-HE-Tag: 1791569392-501507
X-HE-Meta: U2FsdGVkX19e0pEg/qgCawP4DGQm2AOcHLh2MRKyDX682zyquJyvF08+3guhj0ivlYmgqssZknn8Vl7yKihb+/tzK0m5hgo2H5LTnWnryyVTVPSq6T2fHlgIf1l+Rd9vaMbDVp1sg5/Y81Gzoj8HyqxT1W7zNz24B7H2zKY0i2FIcA9GkvZ4CURdy4xK5mTvXJ9Z7cSbNUfmAFj4/4vIucJxDP8nZHDR3N61qBFwBwiG8AMuWI+xkTwTSPj8pi8DZJPMGS+pVyNMPyDp1LeqOyn7Rb3SxbNdp6PYtfusSb0uHFfwzflnZdiibvTb827CCygKYiQ+3QIPziL5xFp8Qa17hCSnjLaj904dCRoFVE0kZaoqptQyc+by4RRcod0e8AbVzPc+5L1MVPPycp3t5x8pua2WcPtz7Afz//XTUcwq6DpqafeC2Jfk9fnN8Xk3o2zUB0kexrsInM4+7Y1VGEmm6ZulfQtl8XiRdtbZj9pKf9wskJ2Ijm0HSRKLxTmBOa97BeyCEzS6braniTrMYO8tmh0tZ4TZJUZs8pmgwyq3Z62wqf2yhzuGxnYxWBbdzYOXdG4Y2B6piU57sNmhTF0Z3/jNjwAnarwqhg+hkso0DoW+2cAT9tZYkkuTlnk9s+T9JM3vCJRNH2/ET8SqonEseBWyjv9q93p+q/Xfostm6Ol+PT5gggomlgfMPcpr2j5w08ev06mTENn2ezSqqL16zUUp/7SZ37I9YM4wPYNDJ9FRx5QEOOR85nGA2Pb59IhedBt5wIGF3oTfEh0oG9/GWKYJnFEuNWs8WET/3f7X4s/Gc2SrwurSiiKFLOJE+HcRFgEx/evwyQRiEsUdR65+ZeNGTEaAHPOfo0/edKjjvAymGc7stJdDjJODlWXYQfz0zwjek5sl3JEOIlx6btXnNTjonEUNRc+K4wKLDUbZr6VGhj6ufOvltJZhkAtsTfeamZDVeQs5rnCKMDq
 tjNRkmxf
 aXOTClfuZKkZ8qOE6VHzaFX6PBaUgOFoE84CiRweeS5rJ2mI71RzSiNRo4V5/WkRh08ES7P52Rg5I4/6VIlzttUjvn8QDluTGR36lEV+5qlau/wzN7fmnaIVRRG5vrAePuogmrvkl8S4PpkI4vFicmbRICHDgAyGkj43CHO4m9hHrL7Uqq5rcoScj1awwYDxp18hP3K9W3jkiUnVveZWIesgeUlcTRH7NDMbkXVTlx53WdPbxznWwh1ae8IdwducGDrUeqgKDvtby5rdOFfqHZMFtm8THj3WkhjiyywLtVJKUXnY6SQm4/X0IL8u4sYh0zYfnSd35KJfi6bQFKOBiDEkX4kdI5ImkhgmyHEVxBoTrQXUrm04ZkrZGbGAwMx1xKWCzzg3trT73lXSOHyksvtnUBcjmYJsP07EfhMTfFC6lTJAmYii4G1E+Vej2XFQgqXwzoGgqQLX0zfg3vKhezvO5HebXLPF2B00pjbURUcGL7Cimw/DdnOtD2cvuL4R4vCk01gWI/NMRBvfkqyfFINmHqZrAAG5EIlCRMsOo79ML+MyEof25X0iPgc+Jyi65xIXNAJVW99LX0r5wfgnARtKCIfZEX34EKu0uy2WL2UAdN10yAhqMvDX86CsUglv6mYTqgahzCi6tjKZkKQwHXouk9VRj080Jfv87xeeYfXjXty52b7tMK2/fJJL6NzczoFZvreIWv6T7twmZjHFTFZvLJHDXAZEejfZHH0egbB1oNETrFi0bCwuRwRYlud5SVOopV3gL5SKVoRU5pZMjGax3B7tidKv0WPm8hGIXShtuNKFZju6K/22Y8/3KzaT3ZWbZ2t/TqzTw+hUfARaaqvDXJlrGsJrQaaFEWtNlTc3VHyfXyiId03pnIsFbJe4U5cKLrrKDzt4ybZA6C2DC9NWixOyX47A9+LOLYxjbzvsQl1EnTr/HgtyqmzWiLH1xiSOUX1yG95YsKUbtLaRTwWW+VYPS
 4Rp4wWXp
 1+x/JgpSpgYb5sbJrySOe18tWuocDrqyQGyJor1RdoMdwCuFOJmIkU5PuCtADWlIkHaowNqPvKNPZBIkzjtG/B4jWTeADE2IBJcSrjFU2U/Odg18G2fq1+b/C+K/65cfz2lGygJ82sD4IY1TxABY6YD6Bd53zKbwiJ+uFn/1zO/BNTORMOEOR8/rWq01IqICMHa/9oMwJpJ6sNqjpF34HK68wjWEMecj9K5a9PCHsP5J6YYg2P/RH4Eot1FScxn9bRuzsN7HOsmn4fqN75+2Rw5h0GpGdKec5US/zFKSESdNVGghE159jCelpcVW+J9dFrBSR0ybprNl3I+H+80If+OFYN0/M9/heTxBRB8gWvDY0WMSdILi6a+yGKXptrK9dYou9RHSUL2vn1yWnTxyS6euuHsa7jDx1BrJupHEDu9OjsHNgJXwdT2o0jPrPlji3vayz80Y5FSi37u6skn1LaWtTNqWIe+PxHtuuabFtsIodkVjclcRK7NJ7DIkur9cMkWhMYI7mJOv1CjXO7CaDXVm3yjSbSmSIhh4/ESYDqYe03rzNPaSiMOWx9sUWPfMsEHwKLofwQHsAMje78DMyJacZNtDzK77t4lwkrEBHRy99WRBgORRABtmaADDbd0pIiZtMQQVZFvA/9gPH3zhhKoQaiV+JxSIN1Yi0R49Q387TZpQsqtGYqHE5dMe10CLlXHB6xHNFSQE1XrGiENufpn68K6EiPJ5avfKx2H+iPyQMrCznjz6riGHFmbaUBF7PnWAzjH/IRXia2N8pPb1hhUeYPc95Cw+djGViPxsmVC22uPcg755j+HBmyPy33xgBAFxYE2oQv3+SHuQ8o3TvIS0tXmSk98DRjKt+hoGNQKJPHzbAPpOlntIlmgBrobQXcnLliRNbvGtD6ucmjCFptYrmMhiwVc4dHIT1Tn/M1uE6JgC0ILRq/KuTIuynDlfAoDX7+zoscJlZZdUB4/YXGjdBMH8y
 v/b/cgEB
 TJth1CpnimcoiZ4eDCI5GQbMyT1Syq5+GaxqofXS3eYbQ6CVyP86xVCOrJBD+MmS3aMA1NRhcNv2AN04m4/RjugGYSuDr2r94efpw3MaNfogD2CNIRmO5DIYBjhGrrAt5mcpJ37oeOASolfxoRZoCt5/mBvWR09K0YuLTzi3w5Yn61JX1jRhaKTIZBHkh8zbY2t+GetbYaSVejySprfQxTOrKDz7WzhunuAncLnEO9133y2D+fGAwzvAOLaJZEszEOFgaDKgkGgRkF1+Cwf88AcmL9vmnYcJ+7oGakYrkjM7+tMd5hZKfOvTKGs1kIsFjihAgF8KXHbHihjDocVp5zCwb7/sHyW/4BDw5Xx1dWLySp67yJ72FjVblIOIgjfzlalcUONFKsbFqiHLm1lI+wCsWVeY8uRj7WDwgpK78r0VUnMMxYAD1s6FXraKk8E98l1fg5kIxHScWQWaCiCrQuk2UlJveIOYU95vgFseOj22nE3rGNaCeyLw7wtT5Vg9BG01uEsLTBHjcqAroyVZSvMqsGRN0/fZyCZ98+wc2MY+xorV5d3oxaTdhxok7ntjyny/GoYOUALMzH1gvQZBq/VBwj9bdjrQhYuZRMarH6VcnbFR6Pf0M6dYxEof9NhTGcpd+DhMzv0lDx+liVhJPSOnm3iQVIs1kDS9wD465b7s7d40B7HqNqWjfjzs37jqQKj+Ai6y2EYlb7BjYWUoLsCgFhme11IRid/J5mWJxolWTj7KKXmidyZEbux8EUNKozVRhc+vFAsNCExY6Zy4IVBvQ+brfWEqpehH65oyUcRuUmh8ch9Rb+ilsRLhFBpGMIdChnAcw2/yaqVOsyIHLc1NBiSTb8zTiMl+DJ087zT66RZgOnG/s+rzd2/+4KGvFZXHLVnDbwdUBq1TZ0FI40LM0v3hfY4gzVexlV93EGrh0LK8f5PsRDZ52gaV6w/QOu4Q7RMlyZZxDBZ8X3kPUfHlwQX3C
 h+CmpJwG
 sBN92cTBqwrwKY1U/GYmdF14TbwP0TFUstSlpX3COZwDdZJ9kBjrmS17iqxs59TjIrt9KutDmDBwZzLOp3Qo5NpmQ2QuAaGVEQWjGcKMXzBY3ePWyl00G9Sld9kD5w5dGilTSc+n02ziSGHDPhSEoXw09PxLGrdw/Jxfds9vgD6rZfHToZ22Fx9m+jsW3WFygsFbSRbxmdXFCTRvFULMjGf6uDhVWl9JprcUmE46c5S9bfGT1sfQYFxQtUdrEpkLgqSCnGQj5YMaIIv9dcFDnzvUAMYc8uijkcCu7N6h9Zslk1fjEtZi5MsI1XAkjXyfpux+qJRRVV3/ZQpJ+HLtFcjq4VmI7nsLfnI+eHcRxvVqTxsTuB+CN/Kt3+6OmTJA+4n51pqnTk0nbC+ZxCZMBEHQaZo640FSxbp4Q7C7wjkP9v1xDJhPQeXnOMxVsqM37z8Jb6v+DklZmPBwLWS7WjxkFaIGhhaZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is if
the underlying file is itself read-only.

This means that mprotect() cannot mark a shared mapping of a read-only file
as read/write, as doing so would violate the read only attribute, and
permit writes.

In general, we do not want file systems to be able to do this for
read/write files.

Doing so would violate fundamental user expectation of file attributes and
likely break userspace.

However, drivers pose a tricky problem here - the /dev/xxx file may be
read/write but provide access to a resource which is fundamentally
read-only.

Therefore we must allow drivers to be able to clear VMA_MAYWRITE_BIT.

To achieve both of these things, forbid this for mm-managed mappings as
identified by vma_flags_is_mm_managed().

This constrains this ability to drivers which own the mapping's contents,
whether memory-mapped I/O, kernel-allocated pages, or ordinary pages they
map themselves, and so define its semantics.

Every in-tree mmap hook which clears VMA_MAYWRITE_BIT, some twenty sites
across drivers, filesystems and bpf, establishes a mapping which is not
mm-managed,
with usbmon and the ALSA PCM status page converted earlier in this series
to do so.

Note that drivers may, if they do not gate on VMA_SHARED_BIT, be able to
disable MAP_PRIVATE-file-backed mapping CoW semantics.

This is perhaps not always intended, but we retain this capacity to
maintain existing behaviour.

As no driver which clears VMA_MAYWRITE_BIT establishes an mm-managed
mapping, no functional change is intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index c067d6a4c826..39ceb03023e2 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2801,6 +2801,11 @@ static int mmap_validate(unsigned long orig_start, unsigned long orig_end,
 	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
 		return -EINVAL;
 
+	/* mm-managed mappings may not clear VMA_MAYWRITE_BIT. */
+	if (vma_flags_is_mm_managed(curr_flags) &&
+	    WARN_ON_ONCE(was_maywrite && !is_maywrite))
+		return -EINVAL;
+
 	return mmap_validate_vma_flags(curr_flags);
 }
 

-- 
2.55.0


