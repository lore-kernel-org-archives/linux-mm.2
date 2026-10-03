Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92CB2CA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0BD6B00A9; Sat,  3 Oct 2026 12:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72596B00AA; Sat,  3 Oct 2026 12:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9397B6B00AB; Sat,  3 Oct 2026 12:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69C996B00A9
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:37:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F03511A09A2
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:37:02 +0000 (UTC)
X-FDA: 85281869484.28.B641E03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 28E4E140003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:37:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bca19C20;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qivR91Lb5/7S8p3yp1PCCxRNqvAnmMyhYSRWXpH7C6E=;
	b=crotLtzdC2/ryBEisrJYGVwHAbzC8Qsl/RTOzU2OfQpju7SUCaPCAtxZGCPAy9VlpV54L5
	Y5MIxMejUJ69y2no6L6xcbzP3n+w2NUZPQD1O23p+GWlSTxjaGFob6ZRw3hFdgXg33rHhE
	eE3Q7ber+kjlAIfWrKDBDP1ebz6w+nc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bca19C20;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045421;
	b=W/YrH5JcSjddjUMXcUb2q6ct/8PAu88Iw37gIMRU+HSIPnnNb96dZEYV3tnnaepPlAMJOU
	T9f/qxqI0wIixAxm0k02c0YqwZ8Ji6wtCWOjUyXANgZ1KEyxQiu6GcZ4FlPphyBmGXFH5+
	CSgF0/I7ixv8frITGWnRU7GDdRLeOtE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6ADCB417E7;
	Sat,  3 Oct 2026 16:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891FE1F0089C;
	Sat,  3 Oct 2026 16:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045420;
	bh=qivR91Lb5/7S8p3yp1PCCxRNqvAnmMyhYSRWXpH7C6E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Bca19C20hMcQuuGpr7oNxus8s2tM1TWsYQRABbJAGygQDQpr8u2qnkPVbdDlgQIWk
	 CaAfQbGuboW/f76aCpWpfMRGDCw/fGfCFf0v64A8PxopJ+FM3VWuVNann6gp4cpykj
	 /yuDMAasTPSA153fcZRo65wsu4SqFtjE5cBMl2d5WnRtyvfnm7gsHuPtyrpyavkdCo
	 H5ieUQLlZWa876iLq5qQrX2eaH8A2DGehBUJ1pgBTqpDPBSJ+NL4Uve/x8gITv3wvl
	 XiqgDICXX0BCgvrmvTmhHf56TBwkBXcnlcd32nt1+GcZQkXo28JsW9aF07mU5Dk0UP
	 7a1iAOZnhbOgg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:42 +0100
Subject: [PATCH v4 11/38] selinux: reject writable opens of policy file,
 drop mmap shared/write check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-11-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1924; i=ljs@kernel.org;
 h=from:subject:message-id; bh=X46vXp5xg8nLI6IG+V/Ab12M7pEZi9uJqKdEh54QAaM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mk80Dy+k31hpEalsuvR2Mmvo4/sv+5fYaw5g5W/9
 d2+L4/cO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRp+cZ/ifP+/BlJqfM3crl
 k5Ry0pdcPFP+/N5P0V4lxZcelSvtjU4yMix59KFiM8+L8P1uvzzddr3T6HyqFte/K1P1N9txGWX
 NWYwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 4rqu1ncru1rjz9nxj3xkjk6q435jcdps
X-Rspamd-Queue-Id: 28E4E140003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791045421-448517
X-HE-Meta: U2FsdGVkX1/eslM3MZBnNi0rKoBV5FO0RXnrTTlLUay60RT5uSPly2SJ4DBWT1P1Fd+CV7hsw/Z+J3YLpJBCsvg5epFajHzxAAmwW632mMUEr/ZUne20gEjCPB4/QoZR8ESbk1rpFz9qvWFr5JbAZ4xyfHCWspfVn7z/13DlTDf117UQzLlS4keYhm2902Qbphfbp33PDy6+rCCwRu3KAkxreEa+gqV5r3rln3jMx17dvid9vJPBRLqEYC/IWl8s1rkYN4oITgmhbgJV++Ci2KMA4avkiFb0aGOY1hQP3cP1bwPQHJ2Z+rf5zUXLSPDYPhRqW5oEMLj1NBnKmpUkPkrmceN5pIKjAH+ann5qgCX0XxKvLDeNjx8fNPNw7q8FunF+qzQcMDmpJg63tb8A0Pm0BLHWI4yVVGgYdWe/nCx8U26qXqZVpRQTdV9/dHmnjLBSMfhxXfELF7wd/mzSuv1wfNcxtUII+hflWHaq2wJB8CLGNqLChZWi8DL8yS3fqnonFoZgPzhK4aJLG0jV2x4NPE69MLpzHrcJhEPrZbPVDpBbD4l6R3BJsQ/1fhsvqwGNEOD5Mhb6KqJIBBl54saxdyA5QozB+DnHNrLfQPl9y+K6SJ96deQAC3S8U6kp1GjMu1q7LAKsHfwSutrsjCRb8RAwCzO7PPiLA7KnvOy/vgTLOW4hZjMbdJ8fWlSG6sKTxuo3M2wJDSn7oH09whSS9izmlKC5lBfgFNWpHuTBCxPrdm3hfT8XLYBH1PW9y9utkfFveYWrOccYWwUNefG1M4/10qMGR0MZb+Hx60qq+yEVEJw9jQVPXk5snG80/2wmDfOu5pL4mlzZjEKqZ5XVi30D4a7YBFeUTHK6Ogo8LzZFEysAGL93p7h7YZK3AssbMWuUvcLVPUrKmvfgHHXLNI4j8hpllbQGXtEW0P/Zlw0Z5E6m1Z5i8fwzC9ZyZ1mNRRNM5yGcr5CK2Tq
 ur63NCat
 EWcQraVKwaxXk0zxCvGoHRF9pec5/AVPwBe3RfrWvrsxYNWTW36mZkHoPLHnLaBMMWBu5YzoQtpN8ETFbsXn/EBw28nrjAbAI03ZmmIyfm0SnKeJAlHs8ieePVNuK49nVeluNKUt5v17c2U/yi6hbzOFKN8gFneK/x9c+P/M/TsJYj4M/jxVy+e4u9U2ySEVcWgmIQwtNfp3rHyMey4C46UHX5VUW6qE1kDMMEmudiUkHPavgR4nLIYYSgGUrGOxgv0l/5cTibrfbWaTo8MR/wvhcQVMAQGKtqb+3rgmrNORw1/F0Upy16j7DJdqARZG0eiTq31PfQvCXy7+OjNSGAz+MaldmdaRXIYf/CRIlDchgARKZIac1cEoi6fwRf6Q8x23thL2KXS9iEqeST3JTbQO6ENWtgDjCj1Jf4uXMI5cJVyClJuvdFQoLXfqOJQM/aAP6fgN+U6Zk/iv7HogyDyalaRZfrea7DndoIrZY1devZwvn/MiOIge9NkFPCDXEph9U75ohW8aQ1kZn8bCCH9uGfoeVkMsBCYpS1SSdTQHnM4OoaT+PZLuS/tHn7vE68ko3wKwKnnNuvC7XfYUZe5FZGmYoinFNf+NPpFs3lnQGeGBLlh+EgsMmwipS0nnaQACJgeH8zYenIXB4C3ISKsYO/HW0Pc72EtsLNqECzWAdMBV/zCcIGgzRBAvwQP0v6ly0KvGuEJo8ISDoO52CVxPEnnk9OKAelphO1mbjzCO+8InCtpQ+FqsFkwbabs7TkaZMko0KATfaTd8day9ycmOefBhWGZ05W0LoZuh6pwoI/R5cCQk3tVZDjM15IdgNq33ZFVujpTQLDTNgUVpGlTxx8lLBcHAd5O40PV0LT1gQJoCFKShDIvngFv8bEHHmmiZj48SzbLf8E7ueglKvMfbjTKEBPM8mrq3dNhXmIxXH3treCf5UiKnVXDXfX3R5afTKcyKV1gCrGlRbWMf69Sm4jPXL
 1N185t8q
 FScCC7NXugJi2FT9NuqqAZ5o8ByXSsz0AV4adbB8hJNsfQr3xHeL1JxmOx6pECN9X2eZIRjQBUruGTGVQ9KHtTi4YbzlQVAQPHw6yJPbrOigcIoQuMcCyVidDtBqRKqEAkQytUaHQJ2GjiLrR45tP60PcFdTUByQ0O5l+DnauJa0ZCoWy0uFCKwNdec8iYaXRUsUjkYK5sVi7P3MXPY+aRx4y9lrIUiGJ0HAmRFaW1hp+ja7brYcOTYm+4eEl3pJBzU30/lx1LeguS0ZLLI7qgAh3e7RhAETiErVFr1RxeLhSSCDtQgl0hqvFSuk+AqzHXT2bdF78pB2ER2EBtmYCwdw3Fvyj/GDSQh7loVqBO8YFVZXrFxwmz/f2SWu20FT8f2CJFEkl0nBKX4H9UohRG2S+mvn98HxQ5U5U8+avy9usA04HloYTQZP8K2WyYgc+qXreY3xJUdZ7oXV5WHEPDKXxin+lUAR4wmv88If5uTmASClzgPmP6ONhycZyfr5UYplEibiheVVbXcPpLz/yM8tH6UCdsMJNm3c1YX7qPA1prLxz0WC5kbrkDi9x/cbLPIu9SghF04Eai4SayjjP0guVm7x/CvHgK17SBzbgKeeZLrCpKU9yb9VRGGXqAZxbrx2kMWR4WECW/QZBCUY+/RYn8HxlNTCXczYhc37NaZsuCajujWlADYR3azTGu9CaDm43tgKoS071WHMRWqAf+W4lfk7kEMEhMPpDtZq/Px1l9T363Ib1dHWDL6DmgsPTatBLJURWVUhCJ+f0qdjgFXab8K1ska/Gsh3hoTqeU/pwPV4YUyeM0AYZiBOThCAaoUElSEOH5ethuDWdjVK96y/8jW4sT5iURNATt0nqEeokmRS7UAo8LsJMv3Tnya5ayMxjEeWo7GlQbmPxhxDfsESQYTn4fIetPMWHaS8ycfNgH5Cz5WShpsvtwSk+Q79Ber5k7dBB1dJ96SbQg7wHr/Nzh+X/
 2DPeR7o7
 mraYCpeD004nO5qN0s3l6U29gwC/v3KzVlisMmLB+nRBOOji1qqv+NgTyfwbu7B6Azk9M3/nnAwvc+pAp7FNc7mjWNb8v5Mqsc8aqYE01GxFw5EZWk1kKE5jjNM45gKSqTlHghVc5JYljQLVSa2io/4x3y2enC8o1MnPDCn+Qrt4jfarqFRxl8Kp6eih+mGxoCOHIKQzhEo7wBLr3rROchqEJolGskf7p4lzI9hmkclutYvNAACJ2BD88UHBU9fkotErnTeWTaDVM6ABtIWkL8j36cyx5JFcSEY1Vdhvde8otcRQgi++e82yeUbj6GQ4F5n/yE/nyG4pV3YPBm0pTxtPJhJaGn9oJOd+QfuotZdf+3BwsQDrMc94i8ezholgn1LYTqQapletsRfb0RLxHM/Lx5j0X1ioeix+d3MRipcAGqZAai/UZJsNH7qHCbB8cYVvRpk+9rdINH3L7ue+E9+zNNwNxajVV4/xMbY7JDcVW9IVhSCkNh+0SUdD8W93zFmwB4a5n1U6FqzLQ4kgFZsaczFAuYw0ZulFjd7QX+hkqYpghNHcvHP5qO28mlfCDyI6h90Ux4HwaRqzFDctjKHprBT/OrayRMzURwaF8Ey1JdYHtv6aCosvZ1lJxqS0qjy/WGQVyKOpZAveNiS0+VTMbbFW8FPLMz3GTs9ZyHB2exUSTzxxa+XDYsCVYuYSOmitHNLFFdZkXYU+LriE/94+hiWga9xS6KL8tv1LZvbHQYshN7rX8SIkG7j/CuWWfpDBw5Ty+d+G2LrMvHU3LlqezrnJgf+Ojjw2H1Y0z8VIxXaW4Jyr8tyl08nr0nH/LAqELieyNpj55mDp0AZFSsuhh/yKNfEDhY7GxoIU8wACZy57tr7+5TB9mMhu22keRuZalMRi5CloN9e8m4jBuXR1pFxW6Xf11cGxMX1XDBEO46KX95mV9yS/Ss3kyBagTe97e3eyjtpkJ9duyJECW/BcC3Ie3
 e0cNLfDD
 YuHwaA1uYZdnEF87JAmq35+BCjLGGvTqAXWl2yZkQg9nkIdvJVSIbeoa65irvjbmzDIkgTd+gqKFsirpwuR0Ns5uBe6uIfiKAeVGLH3+nj3XbBbj1DF8mvCqXAxOW9xj3Yj9avB2WSKUrm3PeyxAvNHK7c9TtpqmROCFEBxp7urXcYNqZrtDQlLXl46lDZpwx4PdoDbwbkaSUSv/lZntHj+n8BU2tMMZOQVIr0cc+HXxjnaVvGxi6IWkfhBZePMd9EZqAoaVlp8ZI6T3Zc8aJnac/3fWd7KhJwEa8SqXGbry9X1LE6r4pl/ORhqP0Qq8qFkNqezbKAzvvmUg1wDuTelKKGpUdb8mG5Yfd/NOZ/waeSjnf2W8pko9LZLnxRlXZ+/nBD/dT5kZARtRtHXpG9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The policy file has no write method and is exposed read-only (S_IRUGO in
selinux_files[]), yet sel_open_policy() performs no open mode check, so a
CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
kernfs does.

The file can then never be mapped with FMODE_WRITE, so do_mmap() always
clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
check in sel_mmap_policy() cannot be reached. Remove it.

This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that is
neither a PFN map nor a mixed map, ahead of the core enforcing that only
such mappings may do so.

Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Reviewed-by: Jann Horn <jannh@google.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 security/selinux/selinuxfs.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index c7d91476971c..545a6f89f9e7 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -340,6 +340,9 @@ static int sel_open_policy(struct inode *inode, struct file *filp)
 	struct policy_load_memory *plm = NULL;
 	int rc;
 
+	if (filp->f_mode & FMODE_WRITE)
+		return -EACCES;
+
 	rc = avc_has_perm(current_sid(), SECINITSID_SECURITY,
 			  SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL);
 	if (rc)
@@ -424,14 +427,6 @@ static const struct vm_operations_struct sel_mmap_policy_ops = {
 
 static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_SHARED) {
-		/* do not allow mprotect to make mapping writable */
-		vm_flags_clear(vma, VM_MAYWRITE);
-
-		if (vma->vm_flags & VM_WRITE)
-			return -EACCES;
-	}
-
 	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &sel_mmap_policy_ops;
 

-- 
2.55.0


