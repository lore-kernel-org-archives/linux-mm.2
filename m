Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 276C8CC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37F586B00D4; Tue, 13 Oct 2026 11:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328466B00D5; Tue, 13 Oct 2026 11:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EF4B6B00D6; Tue, 13 Oct 2026 11:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBCB86B00D4
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:20:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C26B1C460B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:20:23 +0000 (UTC)
X-FDA: 85317964326.07.3446A74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id AB34A40008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:20:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W+6pKgzj;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bp2H797bR90jkJwAq1C3XYleL8CpghUWk7gBOV5n4l0=;
	b=TlZyVj7+I9uifX0nQcEp3gEKNQfeNvMcYiqzCvCGv515PmlziT3UMTkqks3Yll9TxxaMUA
	ZBOA+kUlIps2JeaiLxPsL3E4fckWtHY+d02xClZcqpnMfvo/lrT7kgO8baBclYnww3Uz+8
	eglv042bMuDx6SrSgM7OYoFuRpPfuzY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W+6pKgzj;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904821;
	b=PutyktenQuW4gxSVEtdNgwf/3V1FUQvnzn334PkT5ZLSOcwqTCdTPyDitkqPtOzMTdvttH
	OJ2yawCd0/5+TtI4J+S7nx1ra8YonqDZxM+l7DROYxnbSqs+W3XVpUsDnbb+Ve4b89KvBV
	6Ob2EtB0bGWNsmrev+cMxim6rr8G99E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEB2F419B0;
	Tue, 13 Oct 2026 15:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09D31F000FF;
	Tue, 13 Oct 2026 15:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904820;
	bh=Bp2H797bR90jkJwAq1C3XYleL8CpghUWk7gBOV5n4l0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=W+6pKgzjr8nSCRT2dgEyqvgkYgT8NTCEYfaFPp17/D5qGypyvw5fQaIEOpNXdBN6+
	 3A4ilQ6EI+RZQj1RUhPmMhehHGrwcI0swvB3prQY/W4grP+/Nn58QGB13ckT95tKQn
	 vXsBIMj5udJtc6fSQgb45AB5lo2gOYTOhNE33bG1zUwDEX+vQQUaaGSkTJl0BQobSA
	 mNsU7YBb/hFgtjpEetR65oCuAnwYRUVzDrNsAQ09mDnlPaJB3nFNQiRmmybaiNGCgm
	 cgm4W/rgcpS6+VNlRkFSqgMckSTzNzaJv9E/YNaAfzDuIVudJyFLrx9ZA1VciVg99I
	 zQOD1Gp0ejMNw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:07 +0100
Subject: [PATCH v6 27/39] mm: remove hugetlb_inline.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-27-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5629; i=ljs@kernel.org;
 h=from:subject:message-id; bh=9Oo5fqV6FNbJ4su4+2CeHmVo6IndjrVx8LcKpn+6Y/4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZzulTR7u/P259lOT7sZPE9MX5uVGhHyKVDCtJvnW
 ERfTsPijlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExEzYaRYVqqyKzT8/u0cx/+
 UHdsEYk12LddtWxD8yaTi771R95atzMyvA134Wb5ut2uQijoWWl0Js+yv/NTe3+FLCiY/ua3+8d
 frAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AB34A40008
X-Rspam-User: 
X-Stat-Signature: tdxqoyxpuctieg9eyod9ricwy4tksqs1
X-HE-Tag: 1791904821-452511
X-HE-Meta: U2FsdGVkX19p93jCwKlqFx83TmhVMr2tWp+nYtHsgy57yfX87A11pUeRe069PGyRI4fJpFadujLaY2suEkRbAjW3LRtkWRzYHpcwMCCbUCxrYaUx758pu/bUoBQuA4JlOTNluZoUMyorMZWGlVeZNgx2W/U8px2IZ4omQnr9JYgtX1cwb2Zy2PBKguMHnm4lbe/Fk6Lpx7RDz3uUSpyZ9bZpfOg0+KoQLr5QVfskgI1MhCtENp72CrKSi0xpmGWRQ4BKFQZUtITKyUmNLeS5IHtVLacoi4v4PQZRvJp0b9nv8AjXOgyQddDrXU0R5v/RRPjNOjW3XowcaB1pmsIccTY2WHVWVA7nsjIxRM372tjSxX1WU1I1FbfPLA9DNurSY5B7BdIXoI4kCZg55qCLw+Pa4XBq9Y0oTjbfVSu6JcsE+arrc5NZMwLhLVGQKuSiEeSNQJqUR5Dz54JE2N29oLCgnuQWJBVO/2Tr5VqjBCMEURB9eMQhnDEZ5CiOmW0Amew0RYiIofSxINH0Iro/z/1kdahrC07IRcgKInjuAp1TghcL53G1sejnWbpof7G4/WR4zUuPU2bnOIa2R67Muo6SIuMJxGX+kTAjslbZJ9n48LRJUaTAx8o3nU7UQy0YYBNsY/ltcUYgkTvFquMZM5g4hUAuOZ5s0giU3xRVh0na3V/AwFTg47JOL7ONBcAd9tcADNKBUtvU0oeZz/w6GkqRiut4MzWUIehl/yR3ZsAvfcN/0ySPjDdc0K6e8Yqv6Ihv75GnZ0jYa5VEt+Sff9jr3GrFE9u29upxY8qeLKCllacerxqBPSl1hqHjXUNErhhmxpDA8VlcJRw7LLdMxvfVwEZIXooHlLLVmRf6bG9/lKddnaQiRmIuJRFEfx5IDyII0RzOBpC+dcHLf4w0qeX1ILDTPXjYZ4tXOWpIShaVdaLY+UkCnQLzV4NfHSTZS9mx10Tgg/kJd4Yy/r9
 +SqY1PyK
 QYq0feKnW+TtQNRe+n5+9AQrcGlyqidyCAzs4Jskxs7EkZdVRR8llAr7HMtchMxbaRoTAkx+4s5LauNvUvGtQ3yzwX31TQVWr+1u8yfycR4PLxc17XZ0qScM0XmMUv+/SJXVVbUbHYs1/qY8Y2Esi+b/vkegqd//kpyeIWydnHV/70D53Quljl/f2C/w6/zg2ajmP05zCLrBR78ziI7L2qBlV/geI0MTlPj9jZCJQrZ08Y1HtDkz9R2RKGtj4/t1vobVWeoTfs3BurxhjouCEPe/RcQdd+QQtAdvzjCWwFbgtkQb0cVy0emexQZlL4+MBtaH+6PnmxI7K5Wa574MZPUc05SP3gKnOFbnAt8ci+9TIFyM7tTenq1mnUOXUIb+4AVxL2VNUgVW5MyUETb+WcJB9a3RaB6/7U8RkuylYa1NcLq2zNghup7JjWH+f1G+dTsEDkYYMTYxq4WtotaVEyQRBT/t8ovP+o3fB7m0eajWdbdGs2lYXHr2rerKNt85rc8zv2h650M5iXN+16SyFC/nTvxPLdGok7Ef7vMY0dc01Tr8GWLo0hToIUoxfT/8Xi/0SFMpXYhk/5HbTSHP8f/eoXwr6WAArqk0QSKjoBA991KaRnK1iybPkwYXCD7XXskGmzf7IieUhXCfqScqmsDDH9y3l05d1TP9Z1DCC2W1w29+JHEdQ6c0t8uqaTh36v4OPbOtfBX3tGCZ3WyM+XjkQvJHcJIoR8M/kxQyorDa1i5RQel8wE2SzleV5zcradkc/24vtrZxr42VNaVrZTOImHWHtQ0ih+5fCU3rJhbB18ETUs+VS/mG7OdRV5MCvn6jpBLdcJ7mgc3BQn5Qe4yVW2PRuH9wdgbNLOhNsJgTOekfe365zux0sCy+chu5FiHgVCkGrNYMQbF1Q3IvXUaZVsoZOeVuPf3CyqoE4XN3KPwdqCdHy2FWgkmPI5cyZupllA7Z/gUjM/apeJ2A8m0+2GWON
 4B9/6yOp
 g7ZUvPCqMG66enB35poGLPw2U6Q499QMw3FcQywRMnKESptWVwD2PaTeK5VKqDsOMRB4WRvK2SEjzWg2E16ZNhESbudszuxEVnXQ9ikzfaY3ekKt9x4nCJ/gwspINrVYsplpe9t60iiDHVyrQDFsYi2QAXIjpQ3u+zDf3xjXIF/K5Y9tHvMVrTcpLJxfKentMlCp6NHF/cvYTyPIk33P5RTi6r+Cs1Xrqw5uphdHMlH9Oa3GTK/B6HwX5CCA19xWLp/3MryYDkncHiY0MWDEDJjLM6vm+9jAfoWThVmafXBXC7q3aFzYl5LCAjWFJsvezdOTUt2b7uhqC07Ya7fd2X2VEriWoFXvCoOyINPcDeCgyGogwjwMquWAOFySPbok34Sn6CUUaqHPJt7clecnDiHVtf/ZzjElGs1LssvtQgz6+oKHa1/1LQfbDrA5UEpbkfv6SVe/ieigirj5+ZLuVFjtW2mecQy/EaOvlBpLnxLBH09wc05Xv45qbijWS9ck+a5MfkAZor9i7teZ+Z2RjaKKVwOhZD8xiPafxS4kLspNX+J4ElIC3SQIOR4usAtXxzIQL9fZRarYRTtkYKvqi3IWwgqteeWzUHHRRnNVo+kRUtBwE6ng5KeLOKwEzg8y2ewYN59E92Ea6i/DEjrGl0roGElrNhriwi8JaB1+lhQHkqqsqRb+ncor9gmt/+sFaSNno3jjY0qwkWp0CyXBxPfbuvXm2xLI8YyT7hge7uCB0JzBuL/3xpzyhdrBmdUYp8526L4bdrL86XNSBIyMa+lHaicQ93Vw9i4U3IveEOVGGqxYJ+e0+8IN8sL2FXiP6FHqbmvnClIk5rVmKkXkWH6vWVE1M1cNqR1onk+uk8xisTbpruuKATLWzm/sSUICO+O1/xwTt1Dnif311P2UxFsIG0FWn4EB/FgB4CuYS63KQIXwql7MhAa4AFIuy7HLgj/SxpKYEVs8VTOmTvEhsi5QT/aKu
 xXjI7Egd
 3eANfMjvhmiwSyL+RMK7bhpv3j01V4lwBlPoiqYYeglGnHlDiH12x3T9TzCmYArzlxRzcVzsZmtjZIb8BjMpBAgXmfIjy7oX74l26WHN5k5nI32HUGbpo/IUl57fyKfXIWcQmpaYlJw+2diMpHNx2rl6GeUUMIUB42lLxyEPq73f4zz2VbSHm2HVdIhS6uKpS8/TLhbjBHTGjWWZK8XKmDF26K3DeTmH04KHZhs9jyAJygxC60zGKF1473YWw3hHgvW19gwGRUBzfrpkHx16GSY57jmZwNLiu4QvQWZCi2B3H6h8UuJFo1LLCty5Fl03oj+3fNaIZvFF7bxGYHJMjWf9LhpWM8fzX7+hqwrKyi7BCxD4lQTUkvCYBtQsBbW4tnHWoIkKVsWh6sAC2NPPNZ4ppmpouVwBBdz1fdzbnuDfi8+RCvFC3DpdSnnopNoSPW0nwCaqFcneSKIKZi3HYk4+ga16GEcBwXx6bSey5F2lD8ra9tEnvrEjkk/8quppQXIE4VBitY+Vlww/5xAL/ZKbjYU74CnVj01+/Pq4Ias88G4z6YHaCB1BBmiuh1fWnYczAQUPwcnJKc7zhZgY5R4DOaGeHgpIb3DxGHCq1hbdEohoK8icpPCWUaTgAlDiIuyJnvAFMN/QYm8Wvh8KRn+lT2YCkv5GU3fsawdZM2UtydE1bChalaNiaVMUpT8/vju3QMjV6redRkWjVp8Gi8m0fNu8jUNzecrK8Ta1fPMCkyCfhvW8sLjP3VzTV6Jv36fIh3YMSvM12w61i3i8civWjMPCi3rR6f98TqUnYv/P+NFNTaJyXcgx98Rxsm2Y1/vVaMrjjNTeNBjTwiTSBU4FNiy93TeHol1H5Ht/MYC/YR0XZNKFkp1VS/vJOYkELRKT1LiH7ocBApeQzgFmSs7vXnexkgbecg1gky3d3KobmpnZupLyWCyab+LgdH6C8PfI3CQu3B2H30KZb2h/3Kz69yZbb
 7Rf03kXD
 vic6FD4NwPisSZKn/eLiCHF9D2UTgtXCRr/9AgRcpHrvWsnFy6n/71u1U0cOr8tXekCFT7ECD//aypp3HYfcxknUGUS6xSW522FDi/HrGohKwqQk9zsPFluype3hjYWgR14AwrlqbjO1lOlI82lurEtt5XjQFWA3wS/gZoJVLwMzDCoUtHzRcpDWQEPZJRVfy79p/sjHReyKTYSpbZmF5/u8Ez93NVsBbuhhVDCCnZfxTVrCzRMj/yJhWTyQqRuOTrDGtc2leuNEgzzHxpKJGou9/uTbtPUo1dRm5KJzSTB4P7SGpTXTgHGcDHj5GF6kz8Cnjy8MNaouVNM8yGHGJiEAETsccIeNbOG7oMuaFJZofDlY47rdqrgEORMBOPCYHV2vhExH6YhJCDh1blp51bf5ndDreib9DEPSJ+30Vci8R126a2zVHvvPaHnO86mTpj02Jx6zBVsCYnHfSnQwoDKoTAaA59tMezMCRA/Vd7fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This header really makes little sense - every place it is included mm.h is
also included, and the header itself includes mm.h, so it does nothing to
reduce header size.

It also oddly does an #ifdef around checking VMA_HUGETLB_BIT, however
VMA_HUGETLB_BIT is unconditionally available, and will never be set if
hugetlb is not enabled.

Simply remove the header, eliminate the odd ifdeffery and place the
predicates in mm.h.

The naming of these predicates is odd, but to keep changes separate, we
will address this in a separate patch.

The file was never put into MAINTAINERS so there's no change required
there.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/gpu/drm/drm_gpusvm.c   |  2 +-
 include/asm-generic/tlb.h      |  2 +-
 include/linux/hugetlb.h        |  1 -
 include/linux/hugetlb_inline.h | 28 ----------------------------
 include/linux/mm.h             | 11 +++++++++++
 include/linux/pagemap.h        |  1 -
 include/linux/userfaultfd_k.h  |  1 -
 kernel/sched/fair.c            |  1 -
 mm/vma_internal.h              |  1 -
 9 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index a93eee7ddb9e..793dacec2100 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -9,9 +9,9 @@
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
 #include <linux/hmm.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/memremap.h>
 #include <linux/mm_types.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 
 #include <drm/drm_device.h>
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 044dabc1fe9c..8b8123e5b7d7 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -11,9 +11,9 @@
 #ifndef _ASM_GENERIC__TLB_H
 #define _ASM_GENERIC__TLB_H
 
+#include <linux/mm.h>
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
-#include <linux/hugetlb_inline.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 80a5a03e9cee..d7e6563cef75 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -7,7 +7,6 @@
 #include <linux/mm_types.h>
 #include <linux/mmdebug.h>
 #include <linux/fs.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
 #include <linux/page_ref.h>
 #include <linux/list.h>
diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
deleted file mode 100644
index 5c29cd3223a1..000000000000
--- a/include/linux/hugetlb_inline.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_HUGETLB_INLINE_H
-#define _LINUX_HUGETLB_INLINE_H
-
-#include <linux/mm.h>
-
-#ifdef CONFIG_HUGETLB_PAGE
-
-static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
-{
-	return vma_flags_test(flags, VMA_HUGETLB_BIT);
-}
-
-#else
-
-static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
-{
-	return false;
-}
-
-#endif
-
-static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
-{
-	return is_vma_hugetlb_flags(&vma->flags);
-}
-
-#endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1006d8567e06..2c41974704a9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1609,6 +1609,17 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
+{
+	return IS_ENABLED(CONFIG_HUGETLB_PAGE) &&
+	       vma_flags_test(flags, VMA_HUGETLB_BIT);
+}
+
+static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
+{
+	return is_vma_hugetlb_flags(&vma->flags);
+}
+
 /**
  * vma_flags_is_mm_managed() - Do the specified VMA flags indicate that the
  * contents of the VMA are managed by core mm?
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 939f3a5e973f..d7d8b312466c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -14,7 +14,6 @@
 #include <linux/gfp.h>
 #include <linux/bitops.h>
 #include <linux/hardirq.h> /* for in_interrupt() */
-#include <linux/hugetlb_inline.h>
 
 struct folio_batch;
 
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index a4351cffc60c..a14b8a9ffb7b 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -18,7 +18,6 @@
 #include <linux/swap.h>
 #include <linux/leafops.h>
 #include <asm-generic/pgtable_uffd.h>
-#include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
 #define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a07a658cd99f..9eb12d0b6f1b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -22,7 +22,6 @@
  */
 #include <linux/energy_model.h>
 #include <linux/mmap_lock.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/jiffies.h>
 #include <linux/mm_api.h>
 #include <linux/highmem.h>
diff --git a/mm/vma_internal.h b/mm/vma_internal.h
index 4d300e7bbaf4..4f73f0a4db79 100644
--- a/mm/vma_internal.h
+++ b/mm/vma_internal.h
@@ -18,7 +18,6 @@
 #include <linux/fs.h>
 #include <linux/huge_mm.h>
 #include <linux/hugetlb.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/kernel.h>
 #include <linux/ksm.h>
 #include <linux/khugepaged.h>

-- 
2.55.0


