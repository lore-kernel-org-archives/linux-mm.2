Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA1BFCC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93446B00AC; Tue, 13 Oct 2026 11:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E44026B00C4; Tue, 13 Oct 2026 11:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C426B00C5; Tue, 13 Oct 2026 11:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0226B00AC
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:16:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 24A9F1A0D79
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:16:37 +0000 (UTC)
X-FDA: 85317954834.30.88E36AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 18DF6C000E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:16:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PV5aBdva;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4y1sz7ZVghomqASsiy9XjZk1iqHWnAgN1nUm45xiCg=;
	b=Axp9NguLYch7cXkA7FUrMLzmOXGn5/GGhZQLFqpJ3RgNOUZVhNbUJriBAmFrhxtez5Fr76
	1B0zFpLMxgg9n5zDMwsZFcAiZN/xSq9Z1a0XgU309Zs433QNKLYYg+ImfdwTpq0u4Mh3Xa
	HRY6J2hBLRoRPjsdpBWpBZ3BN+Ik7K4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PV5aBdva;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904595;
	b=YbhvKDYFVXzmMaUXtRIrQdENDG6GOWiOJBU4IdqW17Ky3eTTZCZXy0OzEtWEUBwxL1oa41
	T+scaV9hXz5znlbISurg47R1SPqUTsugntslZ5knWFc7CVjoKU14ADxft9BwFbUUqTPuoU
	ydQjNJGac6GlxM/wARv7TfDL4KBW5HQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 259B643A5A;
	Tue, 13 Oct 2026 15:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CEB1F000FF;
	Tue, 13 Oct 2026 15:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904594;
	bh=i4y1sz7ZVghomqASsiy9XjZk1iqHWnAgN1nUm45xiCg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PV5aBdvadH0SfHvKhSrJFwpI31/6TLnUPl2tF4inkGRjH2ijS95fbUwXttmLzcpNF
	 5YVTNWNyE258rCi9csqPX0Vj3cl9jaUDTYbMJFqgtmVLV19Z7aozriIyOun6cOX4CA
	 Uqu8rE7sCZr4z3nz4Kzn2wrrCdQCFfiLVbmodNsFAGB1+jJbDNaURDMI061vbNIp7A
	 9SZegYRQAPKdv3I+JM3iXh765idzGneUCjN998P+vvPrKb4ofuLC3QTcRU0UWm0cTM
	 2Aj3jBmQzN+qkgGPCcVlhU/BclKU4af39C0cIrIexLOcaqP3dxowDtNAZxqEI9H8iS
	 yN5UVLyQAcdhA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:00 +0100
Subject: [PATCH v6 20/39] HSI: cmt_speech: convert mmap hook to
 mmap_prepare, refactor
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-20-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2685; i=ljs@kernel.org;
 h=from:subject:message-id; bh=MY9UuAl0nfMrM4GSY6SwItqCUTxM/pJjBHtqUqIj4oQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZy6kXSgTuanGnvKJJENNyOu/UwUsd+bw7y5x6TbY
 u5UgX2fO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR+zUM/zQvH7vAej3kqe3+
 bfVvFVQDI1RbnR7ofOBZnLM9W+V/pB8jw0Nhvv3x24xm9HZqz/rgs192a1lrRdjTt8lfVzDsibP
 dwwAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 18DF6C000E
X-Rspam-User: 
X-Stat-Signature: mh17ye98agakeucfod3eyjyac3f36w9h
X-HE-Tag: 1791904594-833637
X-HE-Meta: U2FsdGVkX1/45eqrY4XhY+HoF+IRZ6y2cnmMTiJZnQKcdSSgmHfPewHjyo6WlB+mDe3vai8pr816CAwnCH/YG1yKh2JxgdMw8nCwn7O7mnkkZsCsZk118FNrceMDThsm5f0IxxZfs1p8U/2PCqWdZlUmEOg6ewcZP6Xh3nB/iuJTf59Xg2pWHpCCRJfIaX2+Uo9zGrXDt7zRuA2bOWexDbZvO6xvDzSvCVk1/c0xzozKTquutPVXBfjGI1JGQPYXL0NxWZOAhUGiqSpXmP9vivG5Yo63ktIhxS2/2E9X3NTMOr7d1F4X2jOfFu6yHpRAWpCO6ymVZ0WShj0INZAYusJNq8XFmj2AxsvsSwPVJqB3lOkAMOsv+r1H1fIXVIxnfj1NInfROeJqHvJbVwbYDaQ99nIV8+l0ykALT3CfdXUZmDcW7GdjDVibhpt+KMIbPM73bkeGKolr1hVeUshyXhLhoiLZabLLPthq0/PiWi3dBDj0en0lt4cdLk1yRpcFuJSmjY8OFv1uvqwaEPURneZpUb2buHGKSIizEbu3B15pp3Q3XuxqLnPV6i6+6niuHD0AxjhZTl9EMN0nS2x9MQ8Nd2t+/jF/KSzp4LP/qFzAiu2qr88C5fuSixswW5pLASwn1iEn00pwF/z2tIDiM2WEEUkf/nsGZFMqVp9ekhXXmpzjN4H6FADZCQ2UK6fRo3nzt+O+yK2tGURBOBRln1C1DvG7O4cCcFOQ2CR75CwYUP97VBz3/cSXeR+CcQVjDxLFM4oms1M0lWqimnIXjYBFcwMsMIH+jxi777p5DA0URZ85C8hHckyirF3DDNUt8bnHHIfwV02mR+dFl4URBsS82TqjR216RPw+qtVRsWh2VZ07geEyG3q1hWc/E41lcZeIxW7M3xefIoIOuIXAiFP3Oe/cf8VgquhdHGal7GBYijvrDFSbZJrc2AyIm4W5q8eSep3NWhUCU715T7o
 4ifCUgsj
 UfYMZBJJpz95tkd7G/09jAEX7rIW0eGRgGtx/IoIg6Skj5GPOgnlcuWEcwm+rfZjeTmWbGW5RD2R1oDZxQb4FyJtfH5tLYExg9FKU6cKezQv0qvVB6zfWY7tdu1XMo1KEtn5OHwq7grVrYMjNsP5uVMGvAUeUt/ZxyxOJEwgo/gn+qJyoKwIeZ/jJrh8QqQdNS0PxaCxGilGli2lXzElLy2cyB7CtEagousgHHMHZ1bXXnEhrFHGo9efR3Bx/NkniquJh6ITwezj2pJtxwpmP44imiQ4J7EnsnO9/rGNRsbpa+lkKKpGtuejt6t4/6UTXYjIOeIzy+knAkmr4bvAxPwBaKqnsYrJHFFvo7gt/AsMdtceMOk2SYsLUoJh2aDdxSxThrfAyv0eSKL7lNa2Ic3tnzbCRiYLgSnloi32UJ1TakaafTvbPuDfPKfKj2neyrQLZr07Oribsj8trUHPDpNFb6U8PASOHpBUkEg/Ahe/BqhnN6oLgNrIV2qQHM87CKkBz8K3ot+B/w9zsD6dpR1QtDlMF5A4OUDcG8RtyZJDaGBvRIWczc+Icbc8qD6mcEYplTugcAh14MiO99cFojpzAliM01ym9ClLlLGqczT+e+S/FGiw39rIundVdDL+AKGqVdmri/Vr0VS/rNuRJWpfuO+UZyDIV7tt/Z8V/+lgEcw1qN4z/HreqBNMkCGzF3bsAJVABJi4evvvtSoDtezshxPkLtjRBmcaDPemkDZ5lG8XW5ltlXTJC9TGED4faqX95MqF48VohOHDrmtD2fcjukUD90v0DpiCQaO5wT/BJjB8HAj4sWbfGKQDJ7FA36BOkuB5isTI0eOe3ohffIlpxkFalgEAfHXKi0iwu81q1ZFOP6RKAPKH87ecFzZbCFdWXLnDwGISPU2QU6XA0BAsSlIszly5U2O7GUdbn4pHX68RDfa5vc6BtCvU+N6Lj4+a2iahWysJ/emq3HIa9M+Ov9szr
 CWLTYTgt
 TwMTjLoqziCL69PzSnv3HhqtlCHr52il9mB/FrthmqhK3XsDDp3ipyCR2AnoYdt/tsNBBFGnzGmU5QSEDwnaP3xsZOSxYEa59Uhfc04Bwx/E/bniEnZhunoTS44oD1fK18X2OEcMSs4F6AGoY8LBd/w7ULPxnLfZRZaTOBeVdVl/DCMMog2J8SxGE7ziBMYL1Q/h6ezHE9igPL4KrucLWfJPK9PFME1Pwm0Gg6edw2SCar3DlbjFW1ExnT1uwDeCyacykxvDFna69ejQsFrtx6gxWN/4wHQ0gYHXNU/LcOW4Gw8QH3p918fwVRFOEFmQRU0C5gdTvVjaJoGdB5crb0kpL1t+PhxO9jMvjvqE8M1rEQ3RKiCUoK0rLKJdFktqXIgkol6JHMF0AFs4h/70ceOg2pE0tkOEZofhBQYSt9A65AuosHXKlLhWP1t7ohJ6vBD7uh48JPVidjfa5bLJB/JrrwaTM+oYYvYqBqv/HJdoZwwXircY4Kbz82CY0LhK+mzKVEZRQPLxBbSS18GTIyCL3gZrVIuzSMaOJ4snH1hFq+wn3PQegbx3MvKj7iXCAWoTfNRENwCDwRpjWol6FY8IoPiRqRrneEadlauaLhmLVNeI7/8QPvxP7nkzFdTJAdD1Kw7MkHr5gmp780FNlVScyJqzD/gFNXkj6zRZC+erHtu03EMwI3Av/ihcjgAG8rAagQbCP8lHRIamPdCnfnWa7TBVHcQhdAHEa/0WG7vr78uSHxOMihwMsVmfKX7z3H+pvUB2SKBK1F/NfpnhAYMb36alPCk5uSQ2xTqx2HdbIMU1nDN7v2A/ArEAkRyxRbWjATPsoE6w6f5VtIbumiiIQ0V18QiwVuFMtV4A407oqMslMH5uICpdcogXEI3atbPrUnYLKF8A52vHiHBcNboD38y3cl8Uw/r/aTLZbDT6AAIBFXOF9tG11vKGE+Uqq/9dL/opVx9Q3jZhTQAFIKBF1JQ1q
 YshF0OBT
 Haj5gJj5s8qhuxtVWhaybqdO0xPkzclTX+TeGW/Y4cLtf7LDk2oyQNdFirpV38LDXInlLY66mODdn99mzp3yUiLn5WPV9h9ZEH6c5ZbVjl7hJmq1ltLwemKGjY4FuN3H/A/wBehf5WPebDCTmQ3p/NmXmSofRCiICERSBEIyH4Xh0SemyQzuOdyJkcle35PWP7aUJF15nP4CifygRXOR+TW2h2ZTG+TMpRisEtEcQtxz2wKY+usuIs5uFlbGWQdHZXZ7lrcTUn5M3e3GFs5SOFJCLsKhZzT4A1v8hjPHBy2v6e3rML43GDfegp2lulUAqbxuZrlaebn814hdhQTCN3ZHIPcWao822Y7uYh1X8NcHRwI9wZ/UHW/dmeAkzp0kh0iRq0OXx6oUfcvBMEcUbiocTeqJxjwgRoH+896UBJruK9Ifduc6iGJa+2k8Cqo9jATfzmUixlfTSliL2gA3Rs0lbDbnJ0V3RJ/emXcVvDh0ec7tUw/LcHy6uiCk/Tg/E/xBidg6YcC4dwDTnaoFemQ9MiQ0nriwumQ2YAygpJaHZMM9pOJVuuEXs5NySyWMFXjsw9sPYj89LkyjmZiEoQK44rWk76d8oE/lLNoj15EKsEJcn1Vqt1SqUDpFe7xD0mKzyjpQrLDAzyWaZsGnGNBqVkjmRi1a3qe8bl2Szn7inQF/5+H5jMz0XSsQW3wrKgtav0QuYC8n1r3TpZBFQlVPfl2INdJs8s9dum9xGn5ElwPa1SsX3I6P6EcwLa7e7N3cWBjvQH5Vw1xAS/PDlos2e/MZZzLBq0efFls4kCYIT1fhJUSRfSKVSgwpOBtcV3kGLlKG9l0E0sp/JFPKPVHhxV0t7W1Guyo5ipTYVCi5o98HJcSkL9EcCThnzZ17j01qYn8CBh5Hcs3oZ+Kb2MOI2XHkGa09DwVgqJ+I6z9h5qXGxHKFPyG+UNKdVUr6sA8OaGL7+eyQQT1faPNxt421WN1JY
 bw/k2lne
 sJsYtJ4wEukz9r3VsMpHcIs+lYtz9+25vrpxTHbNuPDiTOCv6tggLT6PYL9zl42cFNXAHb/FgYhm6ld2DWnH+mTPAh5BPZNEY7kOIom1NCRZh9hCDjEp+8aRWlR+dsxioj1kCk3bmhF9NUQFh7hdiMM3+OnJYKT3dh6ZvQbXYfzQxwFFtqKJg/RVu7rtAm72hEkqFeNVWyeMfyNcf5qAVXJHMFL7aeOr+N/MNOpP1AV4RWi2cpRw+0gYkrkAeWSa0iAmuEVYqW0NFagRjhMVqFcA4pfnj7ZWOMo/ynhMlW2ca3mf68MleFYRDE8ysP2vOnnsfIq9ooYGFjb2m0Ul2egQXwDBKVdHNXHULjuGn1qudKC/2jHY2vD8s677XnHINrhVr2BQ57HFHmiZjZtkzNcTITtXcS8bH5N1JdT2gEBMRWcEPBBM+sQrONI8yq2YfxutidwEEQzMfaqui6cl3GGaaqDqJWg3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the mmap_prepare in favour of the deprecated mmap hook as part of the
work to convert one to another.

Since this is simply a refcounted kernel page that has been allocated, it
should not be marked VM_IO and should be inserted using the kernel page
insertion mechanism, so convert it to do this instead.

Use the VMA descriptor's private data field as a scratch buffer to store
the page in - this stays valid throughout the kernel page mapping
operation.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/hsi/clients/cmt_speech.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 7226677ebde7..801697b74d4f 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -1084,22 +1084,6 @@ static void cs_hsi_stop(struct cs_hsi_iface *hi)
 	kfree(hi);
 }
 
-static vm_fault_t cs_char_vma_fault(struct vm_fault *vmf)
-{
-	struct cs_char *csdata = vmf->vma->vm_private_data;
-	struct page *page;
-
-	page = virt_to_page((void *)csdata->mmap_base);
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
-}
-
-static const struct vm_operations_struct cs_char_vm_ops = {
-	.fault	= cs_char_vma_fault,
-};
-
 static int cs_char_fasync(int fd, struct file *file, int on)
 {
 	struct cs_char *csdata = file->private_data;
@@ -1256,18 +1240,19 @@ static long cs_char_ioctl(struct file *file, unsigned int cmd,
 	return r;
 }
 
-static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
+static int cs_char_mmap_prepare(struct vm_area_desc *desc)
 {
-	if (vma->vm_end < vma->vm_start)
-		return -EINVAL;
+	struct file *file = desc->file;
+	struct cs_char *csdata = file->private_data;
+	struct page **pages = (struct page **)&desc->private_data;
 
-	if (vma_pages(vma) != 1)
+	if (vma_desc_pages(desc) != 1)
 		return -EINVAL;
 
-	vm_flags_set(vma, VM_IO | VM_DONTDUMP | VM_DONTEXPAND);
-	vma->vm_ops = &cs_char_vm_ops;
-	vma->vm_private_data = file->private_data;
+	vma_desc_set_flags(desc, VMA_DONTDUMP_BIT, VMA_DONTEXPAND_BIT);
 
+	*pages = virt_to_page((void *)csdata->mmap_base);
+	mmap_action_map_kernel_pages_full(desc, pages);
 	return 0;
 }
 
@@ -1353,7 +1338,7 @@ static const struct file_operations cs_char_fops = {
 	.write		= cs_char_write,
 	.poll		= cs_char_poll,
 	.unlocked_ioctl	= cs_char_ioctl,
-	.mmap		= cs_char_mmap,
+	.mmap_prepare	= cs_char_mmap_prepare,
 	.open		= cs_char_open,
 	.release	= cs_char_release,
 	.fasync		= cs_char_fasync,

-- 
2.55.0


