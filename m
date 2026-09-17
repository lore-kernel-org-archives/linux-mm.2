Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 344CFC982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1801B6B00C2; Thu, 17 Sep 2026 12:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158856B00C3; Thu, 17 Sep 2026 12:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C486B00C4; Thu, 17 Sep 2026 12:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCF7E6B00C2
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:40:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3582F1C261D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:40:20 +0000 (UTC)
X-FDA: 85223817000.15.7913E84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5F36FC0009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:40:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f8kNHfB7;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789663218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hp87iN4yJBRpbFa4LvlnOFRxzQZ2BOeIpx732OhJfQ8=;
	b=i0AsgovhMzKLTePhX5yeTHy4FYVkV0qExNq2L5zINf5zwkADolt7c57kefnkZb4DIHGiZ3
	k7Sp1kvJDGDoX8hdzXPvA858oJJOYBlxNpoZAi2uszhzpuwkScjL/QCLvKM6z/qhiaA3MI
	bokhqJWhwzYPu/8nXqpy01PDMindJ8c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789663218;
	b=HP21DuEYpMafqi+KVzUvwog/HWlL1yPfsqOKp8iXh2ieDz2SMDImy/7VHX4urTm81v1PvL
	4MCZsU7+A/RB8sRoI612xWWpx1Iz7PYBcBFccSM1bu1BhNsNi3ni/3dV0lIclpWV+GeEOI
	j0h+i8REVw2kmr6WixAR2FTq0C2Dvhg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f8kNHfB7;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2CE1434B1;
	Thu, 17 Sep 2026 16:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C0B1F0089B;
	Thu, 17 Sep 2026 16:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663217;
	bh=Hp87iN4yJBRpbFa4LvlnOFRxzQZ2BOeIpx732OhJfQ8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=f8kNHfB7/+/M+q0XJgm0qd6G2Me9Ea4weq+5GKSRz+Py6tJq9A9pxQ04HxTQ4T0qD
	 dYfvHynIc5oWq4j6pEQdpxDBbFiXPZury1hbeOGK7+waMOgKyaVJlV3r2ujmFpSmxk
	 0+IszqUIS1npntiQCclR0MP6BqoTgXW6qIq3zVOQU0pTIvWpcfE0v2gWCgV3oLPLvy
	 SiU3+zfDjJjURjF7KURJjnu12eHOfBTMwdgJeLUYV5DbDl3NAZfcJnDULTGrTBbV0T
	 Cp0nIzX4u9CEhTqjdYpTgSs/tCh7wULt4Ud/PeGDPXjPafaMApYzatpa0ggtFetAtM
	 8T/yLzQagVSWw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:43 +0100
Subject: [PATCH v3 34/40] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-34-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2543; i=ljs@kernel.org;
 h=from:subject:message-id; bh=1OwkRdoitzoVVZDSD0YPk80a3FTuq1Ny90B/+LuQWSI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB/5dYQz2lDzYVH6h4zYraVX05oT89csutLPH8yWk
 OLL0ufVUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIkYszEyXBJz3bX41vo9pa98
 eT52f2b+62Hh8vH5ob8Pyv4khFvKGTAy/DJ6m3dxzp3ibTMnzLlRueX8uVNOltybZuwXrz+fUrO
 dgQEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: carczzsfxsd3hjy1spe4ot78z9gekr6z
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F36FC0009
X-Rspamd-Server: rspam03
X-HE-Tag: 1789663218-276657
X-HE-Meta: U2FsdGVkX18tsgKr48sruNOxt7WH7v8BrAqliIycFwCF47KNwbXoqlVwNKW2rjU6BLjL6uzqFzeIGbIFFHd2a8LjhDCyB2gOsCl8pHFYJP9attyufSgCVMGOLy8cuXPX+Iv0P3wGeNyonKHSFP5IToeAO+R/WdmHkp8f4YxOHQOVVRcqMKTD8z8AxzhUPxrtnEBsKxOTaZ2ny95ix5+EVxL974cByAuM8PmWco9UcN3JcvMgl5rk76rgPNPwNt6qISmofYxXTNtYpoc3FxTLs+Zoq0o9p6ZVgYQoGQlLA9uNQ0Rtzd6km1QXAcpm9VQSoGgZBeuLemst3FV+8VXI11aK3gy1Dv6OQXivKEnjYSTRn/Zc+RS1WNPli3MLbvbP3uJ7lsBb74VpcOh1/ad8xHctAwERfJVoSWy22HV5vek7lNIbJtxyYafeFQdPxwdRv61L3PYXOMEdvQ3XeLlDtoL8Juf1ediVIoPZU8seeM7euoyVIp1yU2B0yCY/mRggS/Wi9FPyhkNMIGPXn99sbObgAHNlwAPVzEpTqtndaqa+SV4mFDfc65VqXtnwnvhV8wHVBDWlKbTzqR1I5VAqGn3l7Bl0/aanRluzXINEoFWUA1LUwMLefdwD75MG7iVg8CdifphBsUsuMs8dDFoMGysxMSr8+GupNPCoyFx1/Xz0ePD4XVA1TNINri77mFiFM+jqw4VguSt/10MbDpFd8oklFMw44mGmxOVEK02Iz0YSE9IkN7Wpt5UGTQ8levdvAvY6+wonA6lzC6nmN7AI03M6IsRT5pTzObyHTsiyrM/xY936MH0Eq5URdDWp2tVGmwCHK9IlAmWlI5UnZL/PvYWoT5etLPbk3ZpaHsh8yhEdhoIPs5DTjOpkCeyauCT6pTydlKDhfde68XQOfkhjxAzkoI0hwR+m9LZ1qdftSXE7PoYONkE+x+iF2Y6/SHH+1/jqPdbNig3EgaUXARP
 kcmW2Dqz
 IUmVmGqrcxhRuQm4YWIDG+b3MrJ9k+OFzVHu25MtEV0Cof6Xd+nizDzKELKRxLV8vjN56aiIhrohsbhuhl1kMmM7M+pKbgvzm/+vkTHHyeIl3YyvFY6m5s8IYKND2u1Kpo/w6ZGtIC5w5xeXUx4buXn69ukvD58t+CGWMEHW2ZX2R4++Vn6q/wFMbQTcrqOpxQe/PUbTV6PpU2R0b5RflV/vUCAsZk49MlJt5puAlc/2Ki+NU8SlPJFhL6eRbwQrb3gToT8MqJunfK+eo2K/a2olLpwDKyaCXloha9lAS3UOLO/tkIVxCbCO9OshHAnimHUFudJRV+aDEryVtFiGHYX6MtMhMKVIE+Ls/lL0yvn4xMpE9ZNIRF11ffKulhohtGFg8kB3dvmExrAINcJP8QNONIlD4MgBbSQAm60+vXHi/ikSeePHS7aQL/uZGrhAyyn2JFQMuhzuFXwCBX+PQRENzs6K8RiejT/XlukIAHpTAUoB3LjhUU2M7xpokNpLsMTjQ8Wae1bpyX9WzCiNCEm2cp3i90PamuCaV6r3hQOJN4tuy6siB9xh/nKudKiQoes0u85QoJpH45m8toLJohRJf2neKAKBFHNbabnE2387WFPL4Q55yQv/wOLfp4+FbG7vTb9syMhkFCf6kHs3+W+AUhF+fQ8ZCxTmTmSqqR9js8JWmx4/+GGTm1TMTKVXSEolFupBqJGadRWpkBUXP0uMwGoMNtsZ0fA1Sti4yq+Pi3o5di+iXV4w+ii37uTmbeT/ngmDr4aWdJjXJ0qvnmU/ZrrfYCQXjFIVed3Zab9BFcGSH3d/VfvLiheP562QyXaSO8Cz+c8BVXdlHCRD7f2k7zRDPhBNB3BEOZ60+FX61CZK+n3/3g0LC/OCTiR1JTiZOjCH9yxWFukVrAD4N2yWSnbjyhE1/YZhMRToZNB5G7ea2AB21ZiVnocoQXmgnfOLbW93BvUz7Hf3XMppwgc1bxAbO
 HB2spjlN
 JJ5zIdalk8sU5HTZo7ttp4LfFZ4wLMrBVowHUIk1BOgXiyaWvsE5SF+83d5cPjbUFRH08oJoZ6GQlcgSm0MfJ3eFIVB+fScoR9Vd1ZfAOdDd/8zBT2O+k1OJJi1pUMxOqc51kFSopsQsi4FtQNg4EvQjrrk93NAbPpmxv6QR+wxwbF9aYTRc7ET+3GbDaaZO/3i6yB57mOHNOLK4CbtQ4CaclXNyC7jcnyKRCGIOfmbSiGMA2UBOVOsFhs/JoxR4U40yPgyEBU9M9HO324hEvnASoKdJMIVEfgTdD6fzrKbfSH7Uy3FkWHOCGBouMUABdhqq4wnHQYgNQyDZQ6rPfge2TNEq3nXpEpuNDcQAcmg+goUY7vGxYvUaKXUz+VsTxG1JZS0/NPBM2Xzuy740OO3wWUhkF54/49fxeyJrUBj4RGfqXOstMGVHW8jws7OcFCUr+iS5ON35VuzoYoQvjYdJNLf5lAU+jJ39HjLNCRxE4hBHmlDiOZKMiW3F5b3OqHTQTpwhYzRffUtLyZIZSIOc1kX6516TlQJRhDCZ390oIBl9c8g4mdh80rWAbk/jj1WbtGHUuudh5ERWIM+bDfPPvZEPpv3sDioY1G/zURGlLEq3tiJk+eX0Z7ISVvf+YDskW6EbXQmos3Th62Yjr1kp7BR8EzSCZX6lECM0NVfaovXfluJd/vuV7RjtkQp26Ha5lkw1dnhHFqUsncrGJ3QMKQO7cFh0V9S55mWJemFZwkKxpoKv6xeOAlBaTChli+FvZXwNiWbjzPSB/h/6t538n0l+tJfcJZxQd0ZzHRXk1l89RNMqoPq86bdntqm2k3/UCG0hGigdHLxoYPqPeFyx3L/eSaEfufhg9Zp+1oU1BlNuFa3Dv189aymKdA+sjDu3u70EkA2PEuNxn4VGHLkRe5A788hQEy+GrmVPVSYi0z+u1nR1vRj1aYlg2ecevMnsEPiEE3s4jJ6g7WWcZK6q/JfbD
 VTrFIMu9
 lyr5AvSlwuQpLs+9xEy+PbclW14StukzOViOUzr+vdmJc0T+8/yzAQRLo9e79WahK6iL06oFGotrYTO6l0N/J150QkrxXNdK1NFan/1cSxkKLqPpjIc2BfciGZbYSF2MCc8/4tg7VOsxnN9N0v9ReoFDvdPGkmXf5SgtBFO9YMZbaqzpgCof4VmaH6mQD04V834fhGU04QC+Bw84dnYjfDdVCdHT6Ezy5SpOi1uY+dws8ZM8NOJnYHrmYCpxkPc+DFLDSyPW4mL4g3GEOvN+11v9A765wHkBuY7904Rn4zpnoppk6S7OMlQsk2ARmyMtAADJW8cMJl3a4zuWbJxfcOxzLWmPJqH0cR0pLyo3ya1daYMvNMAleU2T0rn9dB+POmg9en+y5TvFanp6v9ihWOJHsGhbsRaZexGa+n0QJbdpgBx3H/39+U0yVaHBDufz8oJtGageT+6Z+ECTR4RzozSwxVs0rUsBGQFFBGu64AStU849y46r5UW5woyoBBZBbPBfPDFFHZ1kmeNPoW6/5ZZa+Li6iwVVGvjkHwzqr/2dE44UtZA0rU8oXIBmDcItQwDvLE9NTULSGvTVscvfuQR6a9rjUgvzmHdPWXHkSMBtGLYJiKkFFVp4PR/+aw4bZ6ng39F8BZB5/oD7bGd6Od1TwUJQ3FaF2OMVvkC1J0sc72Yz1Nuy74SIZpoSp7qZh7OgBIAS3AOTqCjLbvoH3mboxUU5fSQF9Ye212xyM8EMkL6Tu2GQPN/lRM1K2JEWs4Ib0uvVMFLarNxGBLy3POIMrVMmdi4tTk4LkQEo9RNIkgo0fg6thpQ2ApZHJPOoPQq+Vpsh0Y1eNht2qrjUhnOOwmo+NOGq3PRJ+litC7ENWnD7SH4AcytOExYrp7lNXMbO7ABZuX5lp8nMfyOmh+n8oS7+OuP6k/hQfUcw4zalKzPqevJGt783v2mKUnPsH1k2NbFRhrLyc09Qjlpggv/6PKG7A
 cy18m4tS
 fGCDYNmxxPdO1Xd0ZxrJ4irrZ0X5puH7BFGdgYAgQZSI0tEvFc9XLh2pcDGiDUfvX2rmTqyzRAMKKXnpxmCqeLR/Q2jm39btC6+UzyiJNmxXTS2OuReyewb5/j7gQes8h4wdQsblKk6KS3bqKXpSgus2aazW/KVCHvqHGu4srx5nu2HLzBw5vTNFsMFYVGKlWUTup1HSXGY43VgBiwYQE1rpplP8L8opT5Qe3KGhpmwpG9iahKOFgnPhDmtREY/TWolBvHXp9IZzDRDfi9IqnpsblH5HLz45RpwBeJ4uavVUjFHI+W6jOotyTcaYum1owt1s8CmIcN6BmTZIGCP7pzP8422iHvXMP74NV6AvMf0Xe+g20W359tzxwUqbUsUCUzNZO8tQyPx9X9oi+6UEnrRB1fJjTN2iispWnz56UPPXqJa5/kEyz0UVTZ8bg5IwMNi71aJeCGPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is now an invariant that VMA_IO_BIT is not set except by kernel-owned
mappings, so each existing VMA_SPECIAL_FLAGS test need only test for
VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.

This is precisely a test for a kernel-owned or fixed mapping.

Update a number of callsites which already explicitly handle hugetlb
mappings.

vma_supports_mlock() and ksm_compatible() also explicitly bail on droppable
mappings - detecting kernel-owned, fixed or droppable mappings is handled
by vma_is_persistent(), so in these cases use this predicate.

should_skip_vma() tests for locked, kernel-owned or fixed memory (having
already excluded hugetlb mappings) so simply test for those there.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h | 4 +---
 mm/ksm.c      | 4 +---
 mm/vmscan.c   | 3 ++-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 69a6e9850960..a673fa73df03 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1113,9 +1113,7 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
 
 static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
 {
-	if (vma_test_any_mask(vma, VMA_SPECIAL_FLAGS))
-		return false;
-	if (vma_test_single_mask(vma, VMA_DROPPABLE))
+	if (!vma_is_persistent(vma))
 		return false;
 	if (vma_is_dax(vma) || vma_is_hugetlb(vma))
 		return false;
diff --git a/mm/ksm.c b/mm/ksm.c
index 624f37975e12..f80372bfd4b2 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -747,9 +747,7 @@ static bool ksm_compatible(const struct file *file, vma_flags_t vma_flags)
 	if (vma_flags_test_any(&vma_flags, VMA_SHARED_BIT, VMA_MAYSHARE_BIT,
 			       VMA_HUGETLB_BIT))
 		return false;
-	if (vma_flags_test_single_mask(&vma_flags, VMA_DROPPABLE))
-		return false;
-	if (vma_flags_test_any_mask(&vma_flags, VMA_SPECIAL_FLAGS))
+	if (!vma_flags_is_persistent(&vma_flags))
 		return false;
 	if (file_is_dax(file))
 		return false;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 12ed3388ee41..09ff20c3df5b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3477,7 +3477,8 @@ static int should_skip_vma(unsigned long start, unsigned long end, struct mm_wal
 	if (!vma_has_recency(vma))
 		return true;
 
-	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL))
+	if (vma_test(vma, VMA_LOCKED_BIT) || vma_is_kernel_owned(vma) ||
+	    vma_is_fixed_mapping(vma))
 		return true;
 
 	if (vma == get_gate_vma(vma->vm_mm))

-- 
2.55.0


