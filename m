Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B34DDC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C09866B00B8; Tue,  8 Sep 2026 16:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA256B00B9; Tue,  8 Sep 2026 16:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34AC6B00BA; Tue,  8 Sep 2026 16:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74C756B00B8
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:13:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1A71A06DF
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:13:33 +0000 (UTC)
X-FDA: 85191695106.09.29885CE
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf16.hostedemail.com (Postfix) with ESMTP id 45106180007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:13:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5K16GlzsQoy0h7+0CkyHUMkjHsarATEzCzpeYhQPaCY=;
	b=cRFr/hp4sp2v0hS+h0xN9hpNQMKO9JqkW+HNeArCkTadrIoAbgiCgmpfEvfAQc2BPe9MDq
	D9A1jv0/074IbmaBNiK+0OsUtWr9IPrk5jEwD+kGD1EcZlrfkvaXQoHXHpIwcmDydboLad
	YRsKfzoHS5+xi3D6G3ZuC6RPnebIxNQ=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788898411;
	b=esTlYT9nXXtCz4wQp30pRBZloCr/ItG6K8DzsoY/CgOTzZHMKmA+4LCjlEiI33sE/dkD7r
	45d9LIoX8ADpZC9oEGxxETiBxrF1fQHgpI1Qj0M5bKTokmUOIa7raAhbBt3GkboEaQsSKX
	O11GNnmBWXG3+lwKVsBPBMbFnZglbdM=
ARC-Authentication-Results: i=3;
	imf16.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BEF21160775
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:13:30 +0000 (UTC)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 896B7140725
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:13:30 +0000 (UTC)
X-FDA: 85191694980.25.76A7136
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6737B1C0009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:13:28 +0000 (UTC)
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788898408;
	b=rP/S5oEXO1Xb4fql1kQbJtU1CngzotoBKOmHIAHl4xwEyojKrClwty4k+D9RkSbKa02oUO
	4m+Ywxo2ML7yIMFXF+8bjJS804nl6u/h2mquyVHKFbjFhXoqKF9PKPceYyL8G+eima8heg
	jouro+IE2pRYC1HrQVcGWFtgQ7u43YI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5K16GlzsQoy0h7+0CkyHUMkjHsarATEzCzpeYhQPaCY=;
	b=TC9SI8o9KAEQ6V2UCWSY2daZjDTdA270GYjO0fqAO4a1TFPO2r36FpEpyRHy7O5pqrfHfd
	OtWBDdisc6FpfIArWLI+FAIK3Ov0RXjikGRpO3IwDV1V456hQR23PqofEA8nJDCk7Smzh3
	YI3yKuXit5nVqqmimnldk2kRSiNYSUs=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 095B0A52EC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:13:28 +0000 (UTC)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28BBF120790
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:13:27 +0000 (UTC)
X-FDA: 85191694854.27.224917E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 55D5140005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:13:25 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5K16GlzsQoy0h7+0CkyHUMkjHsarATEzCzpeYhQPaCY=;
	b=ZS4hHxKFI1YJjzn92dGEecoEhPYoHCantjgcaGzkYIqODz6XPkSVJ3ISX+URhX6qwns00Q
	eKYBVhK+lBffjWrZDbXu6UCDd52TUsP+pZuZ+P5r4Wi58mc4hwsQ7gF3EDxOrz7Dz7C26P
	hHyiA43tdsY6QUxRmQCrpovRWf3aBk4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Fl/YCDPj";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898405;
	b=ralCBqh+j6Piq9AAVr56wncESSNvcLkbq+NyQiyiWnmn11rM0e/Oi4afZuWmiInE1K7TMm
	wbHqIq4WzJacf67yw5oQMqf9NhqbpqoXi2t2wLuFvQqLGoRAEArCwKNnqDUmR4pGM36KPP
	w8IuSAw0+6XJcoPgbF9EuYQJTfGDrD0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D540416D0;
	Tue,  8 Sep 2026 20:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799EB1F00A3A;
	Tue,  8 Sep 2026 20:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898404;
	bh=5K16GlzsQoy0h7+0CkyHUMkjHsarATEzCzpeYhQPaCY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Fl/YCDPjRM8WBFFd2e8aQAOkcjORUNEDvBkYPZ0czOwSoKB9JUkzPuLgU9/uPT+28
	 HH9oU0LFFmBARTFN9q3OvmwkkSEllMdPfkkJ9Y0U4lcd9dKI721He/knHyzy2TvflO
	 /ou7DeEyJdwsk2wtsr6GfTfLEqwo/CfTcJ8EWEmtspNdXFBue7A1s/ztnSI4zxOZgM
	 Nwfu2DysRSUinri8xi4SNPc7I2bJJhyUcL7w8lvFQJemkasfX86nje5c0yC+QmHl2H
	 B9q5ltTeHhkkn7x4cw0Ot5AdEHPEyJ29dkPxUp/lKTqSNFoO8AzSgt/f+h+Kc06hgL
	 bU7IDnReUhc5g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:27 +0100
Subject: [PATCH 23/39] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-23-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
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
 Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7044; i=ljs@kernel.org;
 h=from:subject:message-id; bh=vEqZNj/orhd3A72a0KyhZ8lk/+VHtX68aC52ZbOqwFo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG7RL7u2o4dd6mTohG0XpLh3TvjX9Gf1FYOdaqsvH
 GXtOFR7paOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATyUlmZOgIPuqrHpV47LaA
 aNfVw+2Lwhi9tDrPpU6+6l1edqHjhRDD/xxpMcYXGXueC8Z/OXa2u74xNjtI2T7XKerKxJOTr6f
 v5AEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-HE-Meta: U2FsdGVkX1/i5IU4yBomS7Zh9sGREsbH+xoQ0pjDElK/X2yec8nKh4UwVY8aan+AIZ60QZmJk4DMFF2NVdjlLnKtE/gW3Be1m+g8bLfXPaQivwkE2CcnLJ49CGxsNWNzCQTMrToTN+LAGsFF27v08NYjCRq5phbqZG6NLK/xl6FYRIpkTzqLPjziNoFiixp6WZQUsFWmtVBPmt8zEKXcdr6PSPOrGOrJzzdhHIB9LAnwmuk9Dzv0un6I/NN2C3xKqQpgbozsbRJcQq5owOk7Rg7zQ9CqiUj1ubs62ShnFYu+rFRF2wZ+99AVyXiEJC7UKrtaihy2r/FuHG6tf4dxxABbcFOH3H+0m9ID69a796FVhOPI1IpM5xfxOTkNsJls2bpZHd1KS1XNZRduCRLOMUBmofplYep3CrFvYBO9f6CZQowNWQWhIZKQ4JWB1oQ2qNs8J1/4N/UfCWJ7jp1D6twH3xx6yOtJNM4LJEE+DuXPR/ao9S/gIDq7yG/pOpHXv2No2VanqiyQEF1gXfeOKW7ivanc04ujrzEqWqX+48tOgRZZpsJoIXpYOXwafJsdOjFzchRwLxi7bv2UqFygzZt+VuekNyiB3UDLydSO2mv7VMQ+QCLjf662yBuRxHHLyqs8vBqDVotrHYBpFIxPV1MeI5zIMiUsR+ClNBcuHYSpiGO2gZoZlw/oJv89jelAOlEbsaUuk0F2LwedrNT4EOzKU3H27+NaunlLn+tdXQprpK8qVne3HAKzBmD9VCmvDP/WTb46KFgubqBFDK+csYn+zhuyf+hhGmqLTwFVhV1S+Rd3yaJuiqKgzZsAKa+qqnZIM8E5EZhg7DT9rbUakcqmOmoQS/bHojHdGZdtLZnkK1HORAZh6UcWZQow7QTwClSBWt2RCCY4MSOP4Zrx6ScYp0X3FKWaXkUr2MRiAbBYFyYUvftjzBXSXphHnQA4TvCkgTvBXuVIbQARd7c
 EjrTMsO2
 8eDwLmCwrWzYnMyP+4HNE9zoIq0Jf5dscVTIWMgFWE9aAQieBgNFcIkHTVcQy4Zfm2CiFsdXj8m1we2qOz+jH85golF5z0LxwUvBZrtosWFUtEr4HRyK5JTaB9SoR72DifECa07by3rhmmhW+ZkdfjvQdaJ8GCvj0N+OKMay+jjV+YH4q7O7t3M+iwoQkoH3B4N7O1n0HIQijAMe/AZAfZkLM/d0XZx1UCg326Eg4POcDI/XT/4p7JnnIUwejPf0NhSJH8kgl/1WHf3czgRPDjIvNbPx+E3FNIaJ0CMcQxDLIgOCcq6PS86FM/RROg3jft2hqvgTqVkmFpZ3nZqZKI9st/OmzjTiPpEJ3/8S1d0IA97RV4HwOfr2u/Msbcb7XLTfuTYp/rBJOas7uU59E2ajI4Sd1CTgQ6BohX09AwGn/Cem98OGjqiW5NEZtJmPXhnIuHZYS6K2MKCVbnuiIg46SDUFkq5SWrdKa281pVCbeDd5mLqg4gM23WTpRKP5ZVsTztzL/Dg5lWJJ07u4lnYDg8oKg7lGpL4Vs+J2uIu32SXlKFbYsCtVxCovceJilUOFXb7iK8ebc6LFhK9lJOpQ59j7HN1Hmipn68mQ5+Gae3YJHr0E6narDqoBMYr25T6IGhnJOfWFpT5/XMo+nbKmpML/c/Hr0q7ApyCiQPkVNjXq2ZIeroelsZr9h6L3dTXSM5ewDdviwt1/3ck4IkfmCpCKzc5znmIb7HO+4Cw+KPg2ayNtj26d6bYHmHP5jcpk85Ye7OF6SW9JGoQOkw5Gw75U086x9nw5OLuOZVOkmfVflxraLD88LRbabOZRu3hMJ9487tEaROW+KIWSkXuOfbTi5+okLeSv3Niu40/vs/Yu6zUQDIdqFywKFU1wePG2uhRS2u3n3auItzvdgJgFgV1mQuyVGkAi9noi5wJQKOBq6ZhGVR7iV3xdlrP6/Mtz6pOS4Q17s1NwdrSTTGwGE7XHA
 VADvAf2G
 /6bv9oTo3M/xDcemE072/PeWpZ3La2FtV7oasRCBxDnb814hAOy/GuXGLcmE+TYNj9ZG4jm0mwg5sArHUOt15tL6LeObE2+ZmQogzvX9U5SjBkNIMPiRQ3u/4LB8EuQ484UeiuRBoQwyZ0SgqNrn+2Yc2CGZaNqBqjGj0N0DFARJW5o+ZWQuPPb1vvePYVvBULQcZuiuqV6SxVqawBOyZKVGS6TTLdvRkyV4dM+FC3IuEB4UCPo9p4YnLjI6X5SBT2YQwEdM43Ch2mIrzrrhHgYxq0PN7/t7+nrd+AXObD96h6+uYUYdpJeHq81+ce4ogitTLYKmEKjeKY1BdlddbxSFQ7ySWEJDpkBK50q/FSJfzLTZa4ahC0KwxAaDme7jgEgXFWm1nhjTMewrtAGfkXFqeWtsRhq1xH5wKQIQb2L3r+hUp/+RMwUNK4IpwmDxzH8WmCTyjWjSH0lPW4gNYMIfuW3A//FG42yYVZF644EWxLMpmnrBrIqQ5MCS9bHGo0n+v5/BEWgfgfLLq8S+x/2TOxc88cdmB6eRr3Ja8EAQnfmY3TqmjutxOmDhEo/hvlIJJsT47UQzTMyiPi//UwwygoiCajt9A0GA4SnIggCN2zqian0jJQa+LX7dKh3GSf4KLBFI/4Xg6wUj+9yTyAbfWg0zHHHt6MawLMXkIirLzgoGcx+J3827C5aG/gTItu8OIJ/EMA5REEhX9kYneWUiNebN7k9nu03RQt6U9dr5M0oee4bvaVfFGt9dLLFb8lGoyOCOo+k3RCN0uTD9KqstQ6HRyohGQqBcGGpXWPgevszaLWKdvmGevRq9Xol1hs6tK3/TobNbCrlpqXraHoS7F6ZHpQcSPTr0IAUjzHvTxyUxsA91ZcT21IoZObfyzxu5Pj7qpsYHGO877XBZ0xUEd/yQ0X0UBzZc8jE352Mqm7U4BnE2zbH3+Z1xHpjezg4KGgz8K7+axyWI9N26Da29Ofm0k
 SI2W+dJ8
 cX05ZovpWLQ9C/xmV963vHhT4HtuYTHs1w2Y6445RAQ04T8JlfMrwp8pCBM/KKWATFGaqhPPiRaxg/jRAoBtSVNbjnJtsP5aLOLxqpdeayddkQ0FFposAEOOdiW5IAAeDFfbw5qIJp91DBqQUHDUN5SHVcM7wcS2XTarBiLysbyL5SSGXIfE09lVSaAHCkSaLIAHZS40p7OkErW9QE0RxLRdpQgTf7Oo3uoR3KCSHrfLCOhj0LzgJw5Z6QPCY/zUcu5CjZO8oT787RqOYDjsMZzcPWlmFDdchyeaYN4i0LZv9LtGLVDx8/2CjS6bxd9byseTkWXKtCAELGV7gNKOEyQVaDGAKox6+FqPsTQ7nSYfZiH+of12qcGPqNIDdayev9RcZs3FacPX1uXWOpXSi6EEOE+ZA4l0nKWMhoWiPWjQQItVT56qoKw/duRLzJo6MbMx8nqPb67Q63OjO0S2GyroKQgtyrxKG/cgzk9HCTdr/nUMRjsNEeI67D/YjC5gZiU5Q+De9jpCPF8AFlDXs9GOEmzuaZK41E/i2yLjuZIyzsqMqGRGCfRi6qpzI4QjgCKH+ydQQl4j0gpYwJxqIZwSwPkcM7Sz8O2iWLDLKFxRURj4qM7Cd95XVyjEjGVMvTwrTOuwgzV28C1YNgDGUiupEPnLBbPdOTnRL2wmiO8qD/BKwBUtgnc5UEA5z8UpSU1rW5O0dvbQDtoBI5bl6Ydf4V3cN0sHjgNNiBzQpShbRd16VpoqkoNiAm/qTwBcOcRd5H4tnAs7f3IsjlKgDU7P+D+VrKC2GqMDNnJo0+gPiz413zkViz3VyatKX+IhRLGvKmwZfho5e0CTG3Arya5cyBNEBFWUSI03uPT29oyWPmc9iME/Xo0sJZt0fXzMpYEtx822JM08ujEal+wTIqoTkgxmUhotten7piJAArxAS2ihx7DbSJLr8fs+dQyIWI31qGiwBnRcrjexlVXbLckp1yH7q
 OKVn3hyT
 G8ANPvdrPg7ANlJPpoNwYDQTvVmS8+AjHRLLwLcV79cY9mRSYyaohzXdVY1fz3UO4XTPTup/POaIWCjBRf1OExMWV/C5T2gXy3ifm3n9txPXcMxQ8dMhw05f3nzrmoZgD+NzFc8Sigh14SAs5iSZL0SMWfqcEBTB3o3jb/bamVZPsaF8nrP1sqOSquCW2JCKjtHOr6SMJ+byt4acgmmRms4KMPT28fMEFRlEi/2PabZri/dVLvIPs4VOS+aEgGlNW+TXramrul466EFKQc/QAp4k0ZPdz8TirVYiWdrF5CIwlEMm69sj2cpT437yxokxOWN+GRR9HtQ2rXgF2z2tIw
X-HE-Tag-Orig: 1788898405-564323
X-HE-Meta: U2FsdGVkX18EpBFfKgpSQYt995ChEdeW+Z+7BjMDKKeaeKu5vjiW0bJRY6dHiRhNzd4kJWf44fS0ZErv6NF4cfmdZCk9/vrRsIyXDJrYq3DDFNsMgmyi30zLDvY83LqTtrGcl0/8l47nba7qJb9vExIQhGRcFqFt3TCfpPnlvbxbdAtk7U3RjjtVyMFtlMTWdxM9pmumcTTfrDCovRw5vLmav5RtZTYRLlBtmnP5wXR9DQj/Tuvj1ZlK+5/66DHGjLjR9WxFZTiXZk0W726LkHXFLca0VIe2Ni+r2V8RhREZNyvAalIPxJbRDj0pqoFd8K3F1qooZzB+HppvyaXttd3WfFNjyQOxzVVevcvVEqnnPB5VXG6J2xfhhd2GWcuBZibv3jBJzV2ize6ob8PmHOv+y+/oX94Ul3k8AlmZ3UP0CjFWZ6pV7Er47w4IE+jz+J97GjseiyasxSHqM2zCv135/NeT9fh7wdckWR7Nb1wScT2TnJLcPhfrimLWozm6i5CGBMqo6PRjenUKj6/gNmIoMCVqFDqGxe58KxsQaNt39Zv7IGoBT/c9WSbwBNczNwrtwjqfGi13ic5ROBgtMrnoMiKNnGFYYiI2+BEYQfC82c6rHZJWCJ1xVRgTlubjnwjo1o9y8ahLaI40jSaTV0jcqOg7p5C9lDKBKyv/jRja9Md71DZZsj0Gax4PRPmSi5Pkb00iKR5d7zKgpS4jlwwPbZoqbJso+TPiUG7Mf5o8IDoL3WYneUJt2YO1fDs7FmlMGS+Gw/+YINVqEPJmnmJVvKDo0h+EeLxOdhxquZGuwDkE40z8y1YS/vFdlCKeAHwVjD2mgXWghEAp0ChWBqCYp8Saebd+M6+0CGBwC2uPg0drdSmSmExMTZOBeaG4Xd2G7OLI6kEti3trSOlVnNpHbN4yJRJDodUcesB9xs/x8xqjGOHfJen/MzxPHGs5MqzPQwGNxyqUn2RXwg9
 Wav91MPr
 qNDHvfH88u6lpI9LNdAtM5xfjr9YihSoyRO250BgfE9d80UF4/jTxkF+EUQz0GVQIX9mI4zLlC+0eR9y80XaMrIN9cPERRfoXljZ5ZRXOQKQz+s0t10wswCgVFAG0ReaNdMle4jlprgwqBibyS7RhpuPmfKF/RO6rxbL87JY8w7vUsFUkX9cwPB3rdgyZZlfutJjI8WDpzCv4TT3YWXzNxhdynnZ8VRvLsgcb5MYzrKSNchMn1Xbm8417UvQ03vSQ/W1qJt97rFaFtCf0GGEwg1xOt7pSPDDUoT3RmVSu3XVodJvJUWxq9BJZf6e7m1z39Bd1MBxoTJvN0etiaq8crULnAwzb7p6HSp1Ft+r0U1g6Tf9qIXPFPiBAFsAsbDO/m/FsnP4ZhmrFwyfpaaSf8Yeo70bP+JD5XChQDSEBHalLibnidmmHtK3mGbTHzP2GbA2jjSxpIKM0r2ltt3tPu2sKuVpkE4xhdrNyl9liKC62BbnmPXBH24SriYpmY2SuLqXQYp/A8x8VGK+pnEOJ76jt9pGpmYRo/Ym9LKbiE2sGl97eO/RBpzkJfEQGxo4wou8Bx2C3xx5WZTKtzXbF82v0P+irUUOOD5WeieqGPpScF3hARTkrn0KzJF1Udr8XsvVrqLjVfXzvcbbm8tNLs0im5l4jSCUbGy9r7sXUqvaa4s8u0VKGG1WmVvCCWGIY0sLsOaifmMlxuG/ByLVLseGXlPY16+p6y6HMbexzijAFFMHbpu+wyEQo5Or1loGYxybWqEO4vlm94DrAYL5qCsYRxIHnRPvWFx28zW2epUDOVXIS9RWCvZwtPuACltHKtlZgijUJFxY9EdUqD4LAWoLPTGkd1Akwc3hIb4igPosbqipy1ev9bIzryrO8692u9yaol8M226jDB0/3JJjFegItvNJL/7Es+QVvMuu0tBRW3IT8PVKQUNwF5vxm6k2DfdkP/bRGvKU1b9HTVUqNaGxeE6hl
 F1rvJvg/
 5aj9MFertAJRObYoKWw9xKUs4PbefUut35jES0QB6mRQ4wuuojnX8o20Ol3XvWG6Sh6Ida7EM8JRTlJArrdr4yLOIaMKZtWxwi0aL6NtWMqSh175Q13/tTr40qOKwtOqv3sT5T5h/s0fJ2+H5NBYapXu6zwbZlm8FbTNDazQN4cfU0TPhCIZ9T1Muedv+ioghYL7ZABaVD/Qn8uSeBbqOOG1HK6ITsW6upDh+dRqs+FBNd2mxZ+3HF97blx2Oc18vkbGL2iXRKcV2mfsCHUnm7BlkMlPvJzio3WX99L/fmL+1xQ90tIlycX5IDo4BCaSemRqiB0ln7hTjSoUSp76eNS3tdbVdP98tkke4RTDbR0iR/eRLhOlZ9HGlyQi8yGdKKZPy74JJVPa6VD1huADnfPV/sBbFSmZ8vTHekkeohlVA5Mk7TR3vvOBhBesQ4jA81OPyt1nPzlavCR8agaki6OcYvtLibojKzDOyxEHzCzQTkPvunnNPYwFQ3uejxf7hj9xBstimB7qDVKdGQYW7rGV3YH2aPHuln/pLAj9r0FD4Yor9KSuPpHlPTf47uWdzA5BySeGTHszrpuzmKT/wcfbiqNOwpgWv7f16iY6xs8HRQttva7dcoQ6GHGYlTq3BF/sAAPC7VIKHOoVnIrWrA/FD0ZrLQdVdLZApx5E9HcRHIZ0VYvTKHZ/59Dh1bBg0CNlKcEA1n74kflC0zKkZHIFwmHQnT7LyZev01WL4Te2ZkuV3sqyBhNw4lhy4lt7SA31ekyOYFofEp1L4ysu/fuJAqsUfeO1MtftasoiBzrbGb8ZbGAYG9fze1L/3zXjnNm96NhkoLIr8WImCSSfz/jndq3c2c2v9zGEdlJ5gMWxyz1zkuaVAq/WGFdGNBR37hjNjAP6Acb2JfU8gwHF0NDGm/o14Z4ckPlyGWdc6BMBq4RkR0Od73bM4xJgiPATCOIqQUT9ysAjEDU223w6NMyxqae6O
 2eztAYB1
 SsKDtKiWjyRGZkcJJZjBBo7Uiqf1WF/NxpAg7e9ZhrP0+qknmfZftpXFtaiGMmRBuwf7nR9j2asaKNX0p4czRDo3QIXP8Mq8Ezlgu7wt5vucJK+9nIo3aERBzETWt0ejs4HwxsLC7YmiX0Ux5PAakmr9PXE6rmaZMK1RC+bAGNOLSQa+6iqfORRifdZLx33jTkoly1uxmA2XvkQguowkuj7ANuHig7u3pUii4HMGjwQnBDQyQLVFyfDp2GFrK/wA1iDo7VgczYY/HDQPVZ1zfsxIe4yoGvHMfrjWztL8zIdO5B0RqBL26Klw1YMGBBj0gb1zwGIcOr7afoyKp2ZlKpNtghwX2gFIaIS1uSTdGFUUpOMvuIusVDNLqHiWdA4nx+Sc4IytlPzdeU7yq/CKzQPfO36CXNhn8aPhTTB/UpQoU34KubR5bFxw6y+FJ5F6KtuQ5dmRAl2xZjVzoW7W4jwmdK6/5LZLXXyO6qQb0q6G13VbLiuZ3JTE2uyaHqLpzeih+F8ZzakAv22Mp+0Xt3r4wAZgV+o2ajnV2al2pkFbCS4ghED298teT4ny0v4iAqnVLiYdmNZUPI/jDQIWfUdAzfTDaY9qgTYyqGlJZk5gtKKGwLyKzV9i6JbfuOdbcJ/CSl/tgYMb6hCgkgHaNP6GN3ICdZEsdaxenLQKXMwDevrGMC8yskkjMlT0pDH8p+8XJvIYaoQciP/HzijmMIaILJPkHKvOI2BKnhxCOrYCmHnM0l8jGJREFHZgsTpL6ASoXBYOhQPYF62WmBvfs0nWR9bwXqlzMAxdl31Mipxf8L0OnjW1+QNCXmGFYVqF3XRI7K96tSCahVCF+U9DBVagX5Wpl6ICLG0+pCNwyL+Bn+0meOrjzzO1qPTjppsxVCq/QsrXrPfwqO4QZmcMJD/h+x0/YCIGuDt00dbIyxXR8zmZ6LX6aKx5ZeUDGAezrt9qXukrrgC9E4O7r3LxfqCsSUhQ6
 NLjUWJEr
 hyDLfUm+x6idA0zYE0jpy/ojnVOWLqbS1iRZr6MWyZDvK9UFhMJedCo0RbTvQnQ4GMgAj6nByLMMLfO7f1KpQcgchlt2MY+/yEO7i4HqSR1aKVC7W+j7tBRx1NBjFPIpM2KeYzZyY8jLf4Y/Sdld6bR6BvZV9CWZN8/zRr/L7YvD2hU3j2R4aG2bPNGwtPxXqnClDFq2yf9gd0VuW8cxjI8ZVuHLzDsqEBJLnWW8exYsoE698uoQJsUN2kNaDQSJwyPWYe9Ta0bdpqOrPyrDz0YYHXjB7FUyDcHOB5OiW7nNBoFFsr0x8+4rPmwPcPkSX/g2n+pkzi428QYHcw9Hw+Gh0abEn6Olb8FWIzM4Sh1XvAdYuGONhw
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: p5j5bgt9cd6rzpgmymioaei1e1b8zo79
X-HE-Tag-Orig: 1788898408-812091
X-Rspamd-Queue-Id: 45106180007
X-HE-Tag: 1788898411-958178
X-HE-Meta: U2FsdGVkX18cC+3vzkzlyn+krvAO6ra1aam6bFzy3U//4Y2PtTsuk8706XLe0WNgQDuh1TBQQ4OcM6xzo11s7FS41KO4etJ9+EWU+gqwuBb3lvvBWJOiBcM7mYU7qz3qCtG8jVmj4CGNRe+acrnGKqUvqRNNkt/4/qD21uWeKf8MqR6Z5qgKWRt/m4GLLiXsOKkriA5/tyU6qtnHxIdSAS2tCrcoWJubXShyWQGfu6np4YhkAWr0UYCjhncU75TNJYPkiwBwy5y/TMRkAgBZQlRn85fxDp6YKO6GhiO9sBsnEG+Ycm0aJjR4QxpJGVD9oN8RxIBUeF0u1LGADffEU97RL+MEVYdi6/k+rzOSt2yBLccefxr2NOq6zUajQWL++BgZ/bZ8/YhAnBxsLVW4FmcDOrG4yrBlcM9M+6h5hXkqd23doqYH6ViMo4FQaUeNKVp/WYMCLp4s4Us5oia0vqpb61e/eyKOJd2fB6E27d5ZQk0DqSaS2i8IVCgAeADAIMlhgWdjIQ/dgZpXf6yKQtVYGSkwXPy5ui+X1t5/mbcD448uaiAZ+9cGHvHjzCjY0MGURTwuTGKmTQ/fA5ea+oqyCdtUoc9BWemnhauFD3zOmEdXAJFSKwbkDz8yBO4Pj+sE84AlIUrqAfk4wQmo3wFTPosxVueNBZMVgN2ZMjAGOx6sOhC6XBWYSjl6fGKiqLjDNM0fqokPHUKsoC2Y1Wpq1/EGxw6kKaOtasGLNS4E7VJ2j/SNJ5XFebwLOGCfibc+j5AVdIiI0janRnwSyQFDL62Dr01pcjIWretOauEB4yUP+6iw8m5SMpSgKBOiEZ8PVq6IrODZUcWlQLzEbTRVYzWLPw0c7oQpnfYhV0xz1Pc2ZcqON9j1LBE601XMzHBDZnz82qgJqE5L7SN4hf9Yo6TDxOS6Tm91hpVPH9nEx49hg9hpiBQtsY13TWBk+9XwMtOqePWOx/1ok6V
 Erx5CPbT
 m51bRTt6CRVPZqILSedh7hKaO34+GGsxWVuxVS664B5A8ZogKGdaBRH35QxGiST/BmNy6UPhf+R2zl8iZuWPIkrRHWZ+ogRWBXLTpySBRqrEFQ6/gmPwebd3dBE+L8JT2HzOV1zWPvZ9jy9nQRrXyyipM5+QwzHwLN3h67sTzlnLSu7f88eFUZ7lqqQL34XgRAqwpFADmuWuAaM0zENxNl3twWihSqPqyoOxfzC0l6FMsQ4Fc2fzsujM/omxagTYybOOMXXO/eXNCCLb6baX3LmwnMcc0jDguw5pj9KguBr6G8TSOHA+jsjCUYD/OL85o1H9h7C9dtprKP45LeY0cBWB9ZFxGWrujfFCIwzkQjd9987ccj5DRgcbsl6p10zN3L3f9Pi1PX8j2Bq97YWgpsPB6h//pwBuKj/Z+IgJA7RNQh8fTXoOXuj7RMokFWgpp9Z+/8/mBsOpg7rSqFGXy/HOW/MMu0Wp6tyMrUjE3ase6FCAqrPXA05yX8csPRxoRme4cvTahbzUcLooe2zFK42URfbmyuPdtS14Irx/1UZIuCNavJg4rLQoHeAEtBTw51lXTk/Yv38yEMm/UfQ0vLof4etfvZjfW51VZCLMWnZDk6g7j89FL6WWowefXQNU4kK7ORN2Eld17JMDIVh0Mk42PqEhGFPe9xqnejFT7HcxBcagBvo0sRNvqhj5dgyXGUYxh+t1O14olbBh7btV565T4tUeTl5rAhkwuy0ejE7lomvXJKGqjqZOty+WjX6gvESe11shNMAqVtFTrzgCr90/eEdoFyK7xzvSrpa7wUP6NL0nQY+i3pUJ5OBgdI0+K94EHC24vrHTZJxtTwcLwLJR6LWuTPYRHwo/skUt37NcSXqjZD5W0MdUFugrk5J3iBUr7V3c3N9VbELt1jWciviBC8SfepD1gRXaL644dmhSZrErHqFYCmTCOjlr8unAVY1C091cMUnTQOjIA5EUKsyrxwYag
 2gouixvi
 51lJ30wJMZHTNRkKk3aoYNPq0e1DRNWkXgHs8EsO90j753LCNHNzIP4AyYas1StVmMXzBhhOmPUZBS1lSp/a41uO7ViFWLZ5a9dMoMiaVV0WuNfM7tauxr9LMJEfVFVHtxXvuN70OoF+ZDUNqMEdZnQ8bGLKBYo07fqjNjZnU0Vmrtj/1eGz9pFhLpXUYjRAH9egu1nS53koGQHqGINLQmifx7Za2rl7fBm9S1U824FBZU2Kt0Spn27ceJDOc2R9WZIkgAVy2lzrtmtn5Zs6kq0gwFX1pLTKf//WczBMMMORmZA59hmjwYCxbmSaYYo0+vedQeRAKnZ7UhdbJu3pEN4sNQ9N6dEH6vzPghbBxY/xUl18E8yKX7gZe4ef83WvcaBjlhju4v+uck35EWhN+aZ7QnPJRfRkNCkIfhNquVaB+zhg7MflzPEB9qKyKIqhFJZ6UvP7h3uJkrfdTf1NmsbSbCjisT0gLTQAXci7tXtm40XXnfIy2RX9F/4kDzj8C9Bj0LFbhqTl/3CQ8VvKrElnbCs/gPFiTFRLt6xpbn/76B00qq2sHhEsMDAiTg2CMwNV78qCAPkd4ohPF3GtodwA6H+iE+zF3N3L67T5ClaA0T8zYnXaTcx4ZSST2CyoMOWhCvi+PiaKeaSchNQn8BBWPdRKxoc3kVIsyRGdtgsoZ7xGkiN9tXP/79cjiuJSwrHNDVzL5lHGaPX61NZxGCT7IFGWglV5kVnl/nr5p3NiqCdV1y+cdjor/P/Uq84TaReIMrT4zMyWElnIaTu01+A7jpuNKDh3SEMlmLkDrrNEoH39dG3eg57bDsl7UO/bYUmrxVK0IUcKyFN3SHZL26gdr0d94Wv8KruMGuKtnzwX7CWtfZE9XYAgP0gP82shO9uWjulRI/oAPJ1T+zq71n8zHuC/u9Q/IkA3A2DTXRk1J5/2OVFWvS4wpnh9pDzituwC4jD1l4dPTFJvUX4vjyJwPdOGh
 0S1Wp55d
 yOJBp8UpKmIoxzyjC3QLT2e46sn6qogxQk8ZrEzePafU7YdyMnk6XSrbY3hM+Hyve7CWfpp3jSv9F0AyidDT2aKP4eETxt1u/hLhxu0qYs6BHGBWayVI2hecuWZ7Ou0SQNjdImrf7Em//CPjnPit6iw/o3sahsGbiq/pwp9X/qTwyIrOZJCrSCS1tA+fZ0echDuaSIciwo5oIdtoSuOy5z+56ioUmiJjBarc8gq3hJsRhx0nMZi/iOW8SIy6SbjNNlq5UE7uSXyzSGDEYjSeZeqTbyE94PbzqnvFEdb3w/90/ggxNkn79jGn5eS/IAogTGkOPpYgwXcv7VVCbVv9N8RiHMUelYyMB4EqRAH5ASIzUX6LxdZzDmB9nc7QPHay5iiwlY1QCgFIxqLFFv1kJlv/lwugWMc4wWpr9biJBcpdEaAUvRlO1YvYasi8WVjk0ZwcdMvC6HgvMVN/aYUgaHxKCzdD0czQgQPpDVhCOQS9lWzeloshb1VMnGtOEkzt71lUf+2cjoPJQGdldZnBuY9HmRMDfr6+WsYs6EBZTODzfgCl+rWGyqPm2McGOBxtB0pdR2KwLGVoBWuMPA20bTLUrk28rtW+ZNky14SNnnN840CqhqOAFE2sZz9makfPujUuyJSgECCdHKaR7RWvtnRcx2mlJniRZYhGlv/3/ahhvU/CCv8DXb2l3Y7fcDjvgvcyFIg4IMqFDSWGYsI3WEnxvEDnh+qkc4ibFgIhQk1stBUWRnHTYzjSwcM/Wf1SJk7AE7asMH+koNgkNArCkGKJe18NCLVp7P4U8roZrtJRC7LJ8cFzyjCyk1SqVf8sFdGK7Xi8hZ5AIuEJsHkUswWG7Cy+wXu9Hy+jG6k+Y8fCmIABxQ/p14qpxuT+Of8SI+Zy6JbKHG7cfuwgT6vc8bUTlt7lrSCi8cV/Jy8o/8q3pl74MgCJf3YSkpZB6yYIwdnvn73SOMC7Tnii1QbfFroG0gmef
 +bRKg1rX
 e4vjeMaXfvasAd8LhBWGED+J9y5LWfRxJNxLud1lUqs2KABAtxaB8zdxJ7gDRPnIMfcEYkz7pn6oSGxxuZnla7acWvok8vmWEDM7zCCWWk0JxcYEvdaPSwtcz5e0iwWh43RmTMJwhdkb24cxqGXtpYmDZ1WD+dC6L+5LkO1RxLaZ93k3HfDyMNd3he2MPHEMEtY+8Tu42/vvOiSonxpNj6riMXiVWc1aXcFKO+CDRo6YARNlpbW6zLV7lTsGr6TzUI9i87I8mf4WfQk7jsqHQ4Xg/4b5nUUXhgruqqX6MoDXMth3kA7lFcwA6V1stkADlWhH7RWVm6eJB5rnnHVQDaEpdd5b3qiFeYtvIX6P6OzJeIUmdHM87D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When performing mlock() or munlock() otherwise normal VMAs have VMA_IO_BIT
solely to fix a race with migration which might otherwise double-count
mlock VMAs.

This is unnecessary - at the point of applying folio mlock state, whether
setting or clearing PG_mlocked, we know whether or not we are locking.

Solve this in two ways - thread a boolean through the page table walk
indicating whether a lock or unlock is being performed, and run a locking
walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.

This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always implies
VMA_LOCKED_BIT. These are also always cleared together.

Then, update folio_add_lru_vma() and mlock_folio() to check only for
VMA_LOCKED_BIT, and update try_to_unmap_one() to check for VMA_LOCKED_MASK
instead.

Also remove the useless invocation of allow_mlock_munlock() which simply
returns true if unlocking and instead rename it to allow_mlock() and only
call it when locking.

Finally, with the other mlock abuse of VMA_IO_BIT addressed, update
mlock_vma_folio(), munlock_vma_folio() and folio_add_lru_vma() to simply
test for VMA_LOCKED_BIT.

While here, also replace some deprecated VMA flag predicates.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/folio.c    |  2 +-
 mm/internal.h |  5 ++---
 mm/mlock.c    | 51 +++++++++++++++++++--------------------------------
 mm/rmap.c     |  4 +++-
 4 files changed, 25 insertions(+), 37 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 50a6dbe55998..a3f5c463f665 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -502,7 +502,7 @@ void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma)
 {
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_new_folio(folio);
 	else
 		folio_add_lru(folio);
diff --git a/mm/internal.h b/mm/internal.h
index 6e27d3b10c01..04b1f1d3d960 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -975,8 +975,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/* The VM_IO check prevents migration from double-counting during mlock. */
-	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_folio(folio);
 }
 
@@ -993,7 +992,7 @@ static inline void munlock_vma_folio(struct folio *folio,
 	 * always munlock the folio and page reclaim will correct it
 	 * if it's wrong.
 	 */
-	if (unlikely(vma->vm_flags & VM_LOCKED))
+	if (unlikely(vma_test(vma, VMA_LOCKED_BIT)))
 		munlock_folio(folio);
 }
 
diff --git a/mm/mlock.c b/mm/mlock.c
index 39215a3eab1f..4235a1518fc9 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -316,22 +316,10 @@ static inline unsigned int folio_mlock_step(struct folio *folio,
 	return folio_pte_batch(folio, pte, ptent, count);
 }
 
-static inline bool allow_mlock_munlock(struct folio *folio,
+static inline bool allow_mlock(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, unsigned int step)
 {
-	/*
-	 * For unlock, allow munlock large folio which is partially
-	 * mapped to VMA. As it's possible that large folio is
-	 * mlocked and VMA is split later.
-	 *
-	 * During memory pressure, such kind of large folio can
-	 * be split. And the pages are not in VM_LOCKed VMA
-	 * can be reclaimed.
-	 */
-	if (!vma_test(vma, VMA_LOCKED_BIT))
-		return true;
-
 	/* folio_within_range() cannot take KSM, but any small folio is OK */
 	if (!folio_test_large(folio))
 		return true;
@@ -352,6 +340,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 
 {
 	struct vm_area_struct *vma = walk->vma;
+	const bool lock = walk->private;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte;
 	pte_t ptent;
@@ -368,7 +357,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 		folio = pmd_folio(*pmd);
 		if (folio_is_zone_device(folio))
 			goto out;
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -390,10 +379,10 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 			continue;
 
 		step = folio_mlock_step(folio, pte, addr, end);
-		if (!allow_mlock_munlock(folio, vma, start, end, step))
+		if (lock && !allow_mlock(folio, vma, start, end, step))
 			goto next_entry;
 
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -428,31 +417,29 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 		.pmd_entry = mlock_pte_range,
 		.walk_lock = PGWALK_WRLOCK_VERIFY,
 	};
+	const bool lock = vma_flags_test(new_vma_flags, VMA_LOCKED_BIT);
+	vma_flags_t walk_flags = *new_vma_flags;
 
 	/*
-	 * There is a slight chance that concurrent page migration,
-	 * or page reclaim finding a page of this now-VMA_LOCKED_BIT vma,
-	 * will call mlock_vma_folio() and raise page's mlock_count:
-	 * double counting, leaving the page unevictable indefinitely.
-	 * Communicate this danger to mlock_vma_folio() with VMA_IO_BIT,
-	 * which is a VMA_SPECIAL_FLAGS flag not allowed on VMA_LOCKED_BIT vmas.
-	 * mmap_lock is held in write mode here, so this weird
-	 * combination should not be visible to other mmap_lock users;
-	 * but WRITE_ONCE so rmap walkers must see VMA_IO_BIT if VMA_LOCKED_BIT.
+	 * LOCKONFAULT without LOCKED never otherwise occurs: it marks a walk in
+	 * progress so that rmap-side callers, which test VMA_LOCKED_BIT, do not
+	 * count folios, while try_to_unmap_one(), which tests VMA_LOCKED_MASK,
+	 * still refuses to unmap them.
 	 */
-	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
-		vma_flags_set(new_vma_flags, VMA_IO_BIT);
+	if (lock) {
+		vma_flags_clear(&walk_flags, VMA_LOCKED_BIT);
+		vma_flags_set(&walk_flags, VMA_LOCKONFAULT_BIT);
+	}
+
 	vma_start_write(vma);
-	vma_flags_reset_once(vma, new_vma_flags);
+	vma_flags_reset_once(vma, &walk_flags);
 
 	lru_add_drain();
-	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
+	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);
 	lru_add_drain();
 
-	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
-		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
+	if (lock)
 		vma_flags_reset_once(vma, new_vma_flags);
-	}
 }
 
 /*
diff --git a/mm/rmap.c b/mm/rmap.c
index 5fefe5b060b1..120c894d2dde 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2239,9 +2239,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
+		 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+		 * mlock_vma_pages_range().
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
-		    (vma->vm_flags & VM_LOCKED)) {
+		    vma_test_any_mask(vma, VMA_LOCKED_MASK)) {
 			ptes++;
 
 			/*

-- 
2.55.0




