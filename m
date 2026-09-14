Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89016C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6D7F6B009B; Mon, 14 Sep 2026 11:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45A86B00B9; Mon, 14 Sep 2026 11:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934996B00D9; Mon, 14 Sep 2026 11:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC3C6B009B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:15:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10CAF16015A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:15:38 +0000 (UTC)
X-FDA: 85212717156.07.7A2F93B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id E1C7580011
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:15:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOvtEAP9;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1QRQ9WYzmW2nABpmD05iYHWtoRPkYuNGcAfZon3VB64=;
	b=W+aoiGfZkAKdgZmhTktVxp+M0TZNGah2ydlvgSEcjdDyJImNMT8ooztRrHl5UdKGrpxCJp
	3lgIOaSi7MBnr7CiYMI5dRgyjDIJLp2tvYeUiqCPYBqX1UJ2S4GbzXzQfe6pbfPrezFbg1
	CgE0lPNAkGvNOVoJhZ7b6zX2qqkNG8Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398936;
	b=BVEIgnuOB+5xv+wbUbIAMwOCxVWUn8g7/BmYey/L5OZWSh1JXJJYA0hgsDk2EHNgd3u/vd
	udwZE5uquvdGlxES38i+dcWiCiDgj3tJ1D1u1f8A8751ui1laABh3woahM87HwBLEae60J
	hqmR65g9uqUNVEfV2LZtYFjfpIwanJY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOvtEAP9;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B987F42B80;
	Mon, 14 Sep 2026 15:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956261F0089A;
	Mon, 14 Sep 2026 15:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398934;
	bh=1QRQ9WYzmW2nABpmD05iYHWtoRPkYuNGcAfZon3VB64=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mOvtEAP9mPvYRv+kMi8JpK6J5piWtC7mopHhpUWS55/I8zHQGuypMZqh4urJyF2Qr
	 apEaaccXcJtnRx0Kp8BqmyvAtzBIGRCrRJWItSQZMB/+f2SCriernKJuwlajnxGHUn
	 Mrul+75M15zjqZey5g3rQVaXpw/zP77Jf3vd+hK46vUU2VwpeiAuIYKAwIXJBjYDsb
	 QJTlEeLAJQm8i77cAF846R7Wx0K8/D1fkvBD3fFPOM2OqSmiO3ZqqztAFS4e7l8/bk
	 DRRKUipCswsOWUEjKa1BGOYBBa3zGI5nSkoUwvFiHCc+NrI4Xsp1pop5TdsKyxOKfe
	 GJ/0vsjlv+u9g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:55 +0100
Subject: [PATCH v2 35/40] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-35-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1176; i=ljs@kernel.org;
 h=from:subject:message-id; bh=DL5e220u7y3LwD4Eiaa74zWyGi+IuXsLh7IOYBtbckQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG9+1Zi3qG4Fa8Bxt/NbAvdeOcAXmx3HJPSFZ2ru6
 7NH2PzOdpSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiC7cxMixhPOYQdkK+Ra39
 tnjr05t+OkePatb8fXX86LfV5aXFLw0ZGRZnh7ROPxGrx58wUYdR+2HSZ76uLc2rauZ9SRY24tj
 wgQUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: dys6re8ojj4p3jsmsei3utuj8i8iqzra
X-Rspam-User: 
X-Rspamd-Queue-Id: E1C7580011
X-Rspamd-Server: rspam03
X-HE-Tag: 1789398935-964929
X-HE-Meta: U2FsdGVkX1+Cnp1cB9ygXmbklrBIQpwCe66WKNquA+0jC47iYesdzT5skY/MDeuEZmZniLzXUSNOMprGBV+hcKK2cPyGGT32I1uliXl7anqTloA5LI9fp6wKa4bfsCLOVr+QTwA2GRUn74bj/KColPb24ohthsfbeuaetHuNAKSIuSAWI28TDxs9O0950pks5LsalplXyOJLxBNXfpaFJVmMibqjkYdPVffOllWqv0L4UKg7sZ8NefqEB2e8h5QiRQniIM4TUxy1DXcHgceFJv//qPlRhOxDRZw9hlsr9/gUgLj1tIECVnQXDdSkASpfKBg/MYIznuJ+ic2LR1hewIVjg3xEfKWwI9WrIU9a5ZPm0e8d6ZLj6vDRcmM9ACPzAF9t6efCdbDSU9wxs6o/J7K0nkFzDOUKyTSJ+rsOUhMrqBKRl50Lo02V0tjTeEsuDzt7LULpP2Y6LXqfw4jPfAXcb0hl3dk9mDfdniidT9T7HvtMCVOUq2PrBijl1nuuoDwDpIF3bm3GLNVPMR/YBBtSVF5IsdTxhrBLiRg1IuaGZAS2xDSN3AhjcruTiTHuEUrgq9JOMjxUEXeuT5jDWrn/00dUniYKFHvGWrS6PvyVg7P1p1XkgPeDgiV0ZxYrcNcDqgNGLne/QuUWK2CUmRQ/Mn9au52kchk5jDuzeSi6/uxpxLTRszf+yUBe2oEBDHIGvGODY5fb8PS5bAXVQknnl2y3pdSvZ3++ly4QlPaS7ZQFXtVXQMC3W3Yuqf/g72wVKOZQsaRwerA6Pkb6kiCJ/MxAi8nNBJPINvbBomrfNcYQIc7i8UUySKYtkvWJ/J3oAbGgSh6Bggm9PJdrF36aY08X0EyBhWyJR3cZKtX25Rvq6KfKB8QiL5uPlvzFLDkaH8oPvpwEvXXg+D/kwyvwFu/x1imo737lc27IlCv1e8T2baCEtkbjf296NefOfzdd7RQP7HtAKm9iTzB
 wt1ntvZA
 dIYaFUVttql6XfGla+3gWyyBTcxvldyjZkzXgZJ20ZORwzFucUUPaJC7E+RZYDTHM5/FtlTFn7d57AeBeEXDZD2tu/uGko0Fcbc7f8FixtQOTJ4EqEtv0s2t/ajGA1Sf9Q5n3F8tjzIAGdMZKb82/O9mCY3AVtyXzQQxTsakK6uD7Tu3F6/ntL6wr61OP9wWb7Z/zxk7B5wMap+E3SDkwyDbelx2psQ/cqH5TWJLou0MrHSbWja7i3Y8Ep1WX/sbf1GLsPWoeDcitIuCHMRmXAT2umrn94VnNGxh/DTTBF/wKOTxyoSajMd+4SNRhHYJg47mAxpEgsFdK0ctYfIK0zFuxWeKw+xubf+3h1xO+lEG2aSwx+Wsnua7awulm+QaO1TzfGp3cxqHLrKdvbE5lxfBIwGOA8HhMmKMZ6r4JWXIlaZ0YWenG38e+MuPjH2OhfXcpvouz6gr6IiQgQ6sHcqzgTi+sTnwnMunF8/2RhQOaa5E3GJwFoqoQE7bYuQvqdg3hZl6F10IBNXDxREISPmb/RZ+AuRxkUOBkf8tmieUJgX4GZ1bY0jWBCy1BR3Nvuj/StD4cYQIjuPcoznF4a7kOYYMc/qMFGm8e9pyq1ujgKf8UL9bgMPCMMVS6lAUzyH4bE6YkIbDwyOMmA1v3bltkXzt29l8SyUPr79Fj00wqvbVSFtmQ3R/HlbQNyCr+ZZp7f+yMsDLQNXZ/i3XzkJdfhHEM9fVkDjNhKYYs4hNI6ZyVGs4/NI+Wg94EZnTTLetDo0ECqXih7vg1BvevKTEr0WwbH+4iKOZw0rxhwz/inHdogtzZfYI0PLxWGglRXNgJbyTGP+luEurqMjXpDFVbL2lHcP/7Tvo4JwxBJw4g93G/bqUf1IC3TTVN55CBjAMghbNXh+525H2Ok/v/RBNWHGmRV00RdO9iQPiauJBNdAJzimaGLN6pXnsc/kd7iGJy2lobNplewcmCbbK8TBgkOR4t
 zqsLZo7V
 G4lMQlUOd9uvAF0bduS57MPtTEt+/djGtq+LkMQt0TV2b2hE2fOsLYpVM5tR8pUb4m82pRxumRgDdWP2vyqykUbsK+1ndioV0LqubxbLIrRFwrtVREFDq36+JZgGSaTgHfOj+ww+pScsmk/3/VFCyUoJEDdU5pTPB/mqtV3W/riMyuFPBpEBvsuRmp3jhkhx9DSceIbMahJDalOISmSGURoo0FOJEqaGV1E511j3OpkwT1hh0tLaqAKDMAG71nbzSZSnx2y4V7DJsAPFHEvPYzJ9ID6onFy2okRDfPDUKr9EoTF7KdtS6ewmyWCoGha99nN1HqIc1xQ3N3dDpx9Ju5mqcTBLLXsqvPRpUCctYjc98uJyH3ir7UN9Pq2wkJ5gPLE5wd3VCFF1XTpN4cd7/lrs8LTK860GknRO0uENjPB9BYQg0K09wLqGAJPM+h1iDBq1kP+6OagyReDZP1yDn01pDXSmguKMBpKParxOn5zo/k+rVI4MDEETBmB8g0CaVm9tktaA/2bO2PDDLDqWN40WliW6qVIcThSMlJKiMzItMhkitn6XWkKcZMOtlOy4BFnnFEyMN+w7Iq904NVcpnyAIFA8heJ5+nPGCryxEsmdQkfCAHOjfwSU/TUnU/jZ/PkQjZZQ6yXcQyc0V7aaOXoQj4w+6XkDQIIId9Kzk4RI/LLjnEdh1lTaRu7jLy/9feSNGTGrNW+rE4JLS4HPAz1KhzIDkVwaBO6Opeer+PhJyH2Yeh+0gBr0Ir4IJ4Zqa3okkvMIn6tnDJMqOyc4ftWN/qxBIVKvAv+GUvsvbVxfvyxBWzR8n1ndX1GBzqpVSQiQIzoAyUJLxjOfCIX7tjGdncWO7T319+z9JnkDzJFtYf/OFRsYTbD3ojP8pEEroz+bPd52n2gaH33Kz2eLrqhLoS8JaRYMczdeBYUeTtikPLKgjFypPPYiaFP5tD8GbmkH+fFYuX1495ZRaGS8esVW9UYq7
 vxS0uoak
 B1+5H+fWrYhSUSaO1Ww56mrMPjej/bV2IUmZ4WzXX1L7GGxU0ESBViM6a7smLp9ruW8k8FkCo5IC79nHWQawJr86HzHTsZXNaodCtGYTkNzigodb1bLfBLmT0cicDRjIJLmMvUPr0q5wM9CgwKPJsmZ84dxiZdFlNb3dOCyiw1YKarzT1A0V+/wbH9/c5mrGrUYP3bD0nLGsuYYt//07mX1h+/slPFXwzyfbayQPqr3Iji/w2bll4jWqPlDzXePlgyIpa7ihyO45f9Jz+kcGUPzrWhjOrBU2QoeUKuYEs62K+FGiYviee+lZ0WAOQC/+toKluy4Mi76oAy16Bx4brIbcmHHonsqZtd9X1FnGX+xlbbwxBFi1vZ2J6/uYvC/LhzHvmNozb8xONzW6/DjbhPcfDhBkcojO+ozyuB66As1dhvje0oW7Me4eNlxbpCh3jVhVrX2HE5l0boyHELGS6FyvSw2xU04XnsCTl6vO+3OKeoXUCcUAWfpdSpqXS5GMy14bgmIvURe3wCheNxk3rideHPDjMoBYMg3MuwDKf27mkbP5/WERIT+zuUjezc4oNe8HvOyuZQnzy+qcuv2R8hQsuQ28KtpV26XxO6pgedvky3KFBGV4qCRjK/8JNDEDWhae2qTcIRnkkFcn+zkvGs5oHsiaNuS7YR8Tamzyoyv0fAnDMAsG+F+jsR64DOv1X/8XRx4IYRD1ABxIbnFmWk7O0PvLOaVNlnhTLkRaSTnknRsW2OwIflQJ5Oc09KDPF81n1oVrwNf1MqoCkIhIPNYN+X0+BaNzWIM43SwBgI10lZcPaXvVzEnPuRX/Y3Cs381cGnt3bKOAjkrwQepViDIXaS7zya2vfK75P13OzCwSsV41W6rxEyJ7wpzRCbP3L1c08n7kideVeSCvgLAo3RuS9Dv7Qoubl9kR/KGMsshKWGFKCK1y/GUcRJrScehd6NQCbCQmnHRCQVZoOWS5fyAJMigu5
 X93zjusi
 m+lTzJU+3T0UOBc5gKeALEMNaE/ZQ8XOf1iqw8tbTLNe0bZB957dofH+kFOFP4I7DEE2sc66SVKxSBiUfKgUzhGF19Tp4luUpcz3WjcnH3JLIF4UFsXa41ilL+RNVz1ybHyD8UV3JsWcdLl6nep1IFn8RaKnoYXJxFeMaBY/uQW/8QkHcLUa3ehGvTPBcQEdrdATBFRogiSTb5RuZ2jCWiyUeVDWCxX7CHg56tkb33ApCU5Q1HpbkMrp+v+bMk4Q7jFyYzYYvLi7FAMQh3zx7hu2awqBDC3sojcxxnagR3xkhjPERKJC6SXwfrNtDZP5IQfuoea9OPTWjGfFTRMKY8ByIj0d6r6oOFfmPbbpkkwbox/w4GaKloQNQEjZChVR5T8bVA3l7SMOrMmww/6y0YGIzs4tMsAEG0cl/A7EzlhMBliMFa41dc4hyDSMmFsQaJ8xEScFrfkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A kernel-owned or fixed mapping is one which sets VMA_PFNMAP_BIT,
VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop as
only kernel-owned mappings may set it.

Using these predicates rather than VMA_SPECIAL_FLAGS makes the check
self-documenting and helps eliminate the confusion around 'special' flags.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 09ff20c3df5b..001f8b760266 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4418,8 +4418,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	if (spin_is_contended(pvmw->ptl))
 		return true;
 
-	/* exclude special VMAs containing anon pages from COW */
-	if (vma->vm_flags & VM_SPECIAL)
+	/* exclude kernel-owned and fixed VMAs containing anon pages from COW */
+	if (vma_is_kernel_owned(vma) || vma_is_fixed_mapping(vma))
 		return true;
 
 	/* avoid taking the LRU lock under the PTL when possible */

-- 
2.55.0


