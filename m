Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41523CA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D2606B00B3; Sat,  3 Oct 2026 12:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482546B00B4; Sat,  3 Oct 2026 12:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34ACF6B00B5; Sat,  3 Oct 2026 12:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E56C6B00B3
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:39:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 97F94809A3
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:39:31 +0000 (UTC)
X-FDA: 85281875742.30.B5C17FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D8F1D4000B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:39:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CnFaDqTN;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1TTFxJqK2JOmLB4wxg0hlSgvzQnwmSO7NGWVXFT9S4=;
	b=3Y36/KYWLLHE9Qftb9JjbkJBJEur8dCk/3Ac4tIjrCvSd5jQv/0n6665C84xPyG2WlaBqS
	JeVfOIlpSQVuRGZgjMRlkaO2fIekrSBXhnB8Zfoz0KPH07aCWSCWyuK7vodRsPGo+gTX6L
	BPA27ANvJtkkAKJta92oTs9ArDKRJio=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045569;
	b=YWBHa+7RfvsS3xhd8DZrRXxsK9IwDbIZ01sNKNdri8e83SqcdjDUsRGzxbINTljZT/QCdb
	RAWPb8zpF755Lf+C8S/cAt5e5UC3RnMA9j/vi+J1vH/8hZmYekHVtlpZ1ZjZ9PKj652qhZ
	ZtUtVuR9RXwazu3gDpwkxF3v7+rqDiY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CnFaDqTN;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7137960D82;
	Sat,  3 Oct 2026 16:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A00F1F0089C;
	Sat,  3 Oct 2026 16:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045569;
	bh=R1TTFxJqK2JOmLB4wxg0hlSgvzQnwmSO7NGWVXFT9S4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CnFaDqTNs28+YrjDWIpiskEJ6rTpmDO6CuCJA/tcAMkT0oG8NPdeSljHbbSjuMz0d
	 eDy0eUOh54+NmxC7w/6XHmbLZJ6rRNWLOZv/2gKoGCbYsjPGBRzCA7PPD5hah2AO1f
	 nzzNgS2uMfIqjYC83YeQKD/s6gO3DueDDYId4Tx3OylhgBJAsz5pU2BC/nc5VTny+U
	 QYOWGb2o0AakJQoZ48lp1b9TeKOhOELsHB8aR+StwV+Eu0XiPHcuqWpBmvwLB3j0XH
	 Z8aVVy6FHM2lHUCYtabJMYxKKRYif/GwXxXU7WvbfNuUM7dyeKEe3z5XECJ9Kq1cOb
	 lfSVezkeoGM6w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:49 +0100
Subject: [PATCH v4 18/38] fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO,
 add VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-18-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2362; i=ljs@kernel.org;
 h=from:subject:message-id; bh=In9WHX8b1sLbbe6jUcP+2i7LCzJ4p//dj4w0OtHuz9I=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mkG6V+tVPmYbjbvQ7ZzpYfAdeb6I5eq/hbs3sqkv
 sBzp/vSjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkcQnDP8vZ7uHiht2JnMr6
 YhZZfS8+tjKem/fqadb2m8pNvcVBTgz/jE68/pR6USiI0/C/30PFovMZEesECssElgVl38r68aS
 eHQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: uriczg9zw9jcbqnpir6kqm4n59i4zidr
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D8F1D4000B
X-HE-Tag: 1791045569-785114
X-HE-Meta: U2FsdGVkX1+X38agWLJ4E2YQoQq5nrWbGnMYTQEAWZbZt66sLl/8AO71KaMDpoKj45TBiOW2hpBs1ucEhUGxDVjSKZqMd5TSTXFQD4k/ira6UQjqBGismKh94QnAldbYNGNPvhuUie4W7tP37G/p7w0Y5266PM3AORBbJ7BKIJF6KmUBkWa034L3Yz59XxwqVa6ksOLqdUiokwbTp23ms5jZR4bpgo/gJBmj/rhH4XGcjf4dobomHNF9td0/WWPc3Yr0ij0HnMUFjcv/jNu0ACRTZtuHyjuFhqUBx2G3qglNQR+kP2nrkO0phgqbjgTQGzR4ztc/dt3dMH8/h9fw/le9WMDATJhsYcGOskWO/uSG5LyN2MEj9vO/STBOLaH0LrS0XheN7xya/R+n02RjQ0iGjR7vgKY+Nea+dqooyuPp50mw0j3Mo3AH5nvtj8Wrh6TmlD+aMlt6u3NwB7iVYYWA+owdw98A1nrfo8N2NX72dYFYwT93VmMLGoQ9xsrhTfWFQ/RaOvOtymw3O7qPwN+3jdwAtKUHkaZDld1XkGlfIVL8IXZ6g5BrJxNUojnQzJiboXOUW4NFB5MplURv+RTbxa94Klv8E56kgALBIz17lQ7mVBOo9Dcv/hA9ekA4cEzNfqnkaR6a/AKmkmFKbsxSpf/psz5XUXMXoYpiJL5MWFrxkDnfvcGlpJ4Cr/o2E4uq9gl9h5dLofTxKYrCk+fexJzkVGr/sJfefaDteFGIdEW5PT6cnS70EznEYk7DamzsNawCAxNpT0EgulGAljSQwWhmouWPDol/jYpySjSyH2Uh26/V/uCTqlryPJaRc1wZyC+mX9wNtnMea7rhY+SStgqIag2AkvYuv0CEsYvzpY5popiH1ELnUicWdQig5o/9wELR4BJqFhogPeHKL9jaiy4MRKjqtBHYMZY4FKm/4SKRk1pER2YJukv4ISPBzCxyAp/Zx7Fw34NFCa/
 lVebeYoo
 W0lO8Avlym4nbVi0d6cfbbxl36KfTrTPXlll3KCeIt7C6sdBVX4EP0ikdq3RnEAIvOCJ/htGW5Ie7+W7M3zZ9Y1AKZlpNfNYPntRFR4duKEHJ4qQksN6Gn97Iu1EYf0upC2EJ4eGHMgQnOOxafoyM+16nlqMh2sfVs7xTV6WQjThck+I7z5araKZe7NXKWE6pSkxl2iW+EBcL/ZgzIDG5TBDyunlAwPkSqEsWYD33Ei0pzYpnWhSzejJY7TZoQJcd5VB+7PT+bg7G95qxhPOkgO/vzjxKbFffJh+eQRD9pMpwc2RBHKHoGkx1qRYHO5mWCvJkl4ow+MgSKka/OPmTdJgpaI9uXJM1ufzJM+284Rkymh1HkiOM73t7/9ThQyhyVVt1ltjgIOdHkc4irpYZLrqHiMz3oHdiPF6MtG6f0lbtP/uyomMczyOq3ioBraMSm3BvnMYcIrtT1Niif7ifc+P+pyUYJlMSNrtBXJAuTrAx1uoeAwWyxkLI6mEjM83idWpYSng0xQaoLQ+ZBo7NArE9EgYvGVoVc3RwwvpcW6CtHaHGySsbpewr+QN48gDj5yyteP64e+wefkOB8c8wBqy8tytrZ5L5B6iMnAuUFJSscFU43U2lnb+hNaDYtoJwm5Acz9kwIC+nkbLVHEV8OhJQdQG28vx4T3+fPF7vuERCE8anryAI3GREwC7aSIQidlElROA2cbN6Bg0LJRR1QHeDX6QlwUz+Mayc4zpJNN2XRg8bLQpDlhW3MYgyMXoCwI3cfPVz5FkWfcFw9NNDD++y3RRsKG+yI+nppyDznT+d7Gts/E4TpBW73MyWVX6/rzLW+ZJE/tAz2tC3ZaPOe+II5cOsGGm9Jh7SwiGW0u+DhTQQJrk9Q4HRW9/FO8frhTT3hix8vaPVJwGOkcsBAU8bYIM4tYdElWOs98zHerZfLBGy7fmw3UpPGacVuhxOUatNzxjIS6agVnRudISUq0cNSE+l
 znjem5Xj
 7oEi167CwWfAujBVeN8xdYlFJs/9gpjZxEpahnmaUDwzmxXAaJXbCFSsP/5UkY5DK7gfKjtlPXi997UiL5PrP8x1NIzKM5BhZzLpTlYtLsEn0vff3M89OckI9pSRnCFAv9w/wown5sFvlzqmivrmX4Ya441lsUkOUl7QSZjUW1pP0msKtxH87Za78hA7a+O3er1rOPOL5P3ESs4Xpem0G2F+Ilij5JfWLfSm/15tF+wIzwguCwoRQSDZ7Jb2FzHOnjnbepN5iE1BCqyg3f73tzBz/NicNq4eAB8lOgy4gniZo6aFBkUIZ2nVR6Q3Y9ynhAy/cRrOsPY3aT+YXEUDn06fhFEj2hApevY/Mg8kBwUwsvNxTMNDtvcCwTj4NC0DfqEmJFcMu0RwzGr266dcVv2D8+OIvF7yDn3+qQB2CGfwW4tIfDQfw46saVFVhiGS1CLtgAFuZP6rDp/GZ3RZgNDVzlzWWTQ6DZZA13Mi3zFhnnGpCU5Ig5wy0s6IX0wLKDLa7I71HCRl6d0UJYWm/X/VfLtZ7rgAC9637mS2iUIemGzZOt2uG2FsDbFE4liYSGcjJh8fYdldlgKa9PGRYRAym6qari3+7zhxdbbtKhSIrNb2YmRIpu3BpgJFQoioRKsoRUhQ80YY9If7L7S49u0OcaigceXfDcKiwYpGbstC0ZNHkDNtMIcbB9JojhINBBq01SPVfN7O7IP9n9f3+g+u55O6IV2APLhKKZBGveZ6A85+CsiRJSJLaYZQeYuXuIsX+C6Po8/k3+bLyQgfIKTISfaRiso4Q/tJL+MqHE/kMokzkhJ/t1lBfGpapAkYTb3b8Oz0kKfpXWVx1LzTMI2AWWJyE+dWQQvUP4DC+xEh8g34ySPingjfWsVYOa41jZlziwN/hyTej6MGKtS0ufB/PjAxNm0mIRpaGlCqsV+ryJO/7N3sc5d2DBrFOxU0GJyQkv0/TkB5qM7ZqgMg9ZWgtrvBx
 2CMU6uQf
 E4N96DivRZTrsA/wMKumwRV2mMmKuCyzI1qPpv5A0oHZMxoJ+F9ieU6i2+ccZ5MGpav5WlAzZPzEayt7kKUikoWAC6C1uBOYdeetk0nGIYsKrLkKkEneqOx1xRzM5V8IZhgoMsPDOAnvN6vLBnlYI+comlFMCSBGmIAuDLZTcv7s3BhQ923w0j8LHSrlE4LlCHgs5Vd0xCMQa6mYUvSLuKoMlCGY21MJANRWO7GFw8RneLm8zyu+MOp54G5zqJy+gWhDenW4CggaXj0HaNTJs7bSVN36p2+weXd08VoQuOweMwEqwKiZmmT50HDTd+fo39VlDrdoGirqejCRepjAp5rdRnG34u2wBUZD8AeY/o10K+UDiSHTiViHNJvGycWbTDjeiNP87a+QRjinq8yMTxplUNl3j/J7PXPOFSY5TmPEKNp3IigSoiWTntMFPiJHkjjpk1LbTWcGd+00v3jhdyNOBQ3mnjsZjqAbjq6A2fo9zK/ziCdb4WuRNFtI6+MAOWxxWtoTLgrOkK4mSZLDSPd1ZpWazDCnxIYog4XpDFsEA/7yIS5wM7C7KFGCu2ox101SNPX++5UfRzTZLNLsQz1KjpVJuNY47gSZBThyM6ejE4pypSnWijl5KsZdefuUdmgUoTASZrisA8l7xeefpROnACsP01XZTwo9CcpGg25FhTTTewVi1QqoJkKydSSrheaBz9jebV8Tf7qEjHaPCeYciw3meQL/UWl3Rp2zGrlXoN8K1a6E0vT4YW3UbW69PDgU2I5PQu8k7CyqqTce7LcMaIrFmY2NGSg0SLigBj9JNrj0sLy0U8JeUxtmjGvlAOPlm9AHpScyeNHOU8wRTTjZ0EXYFrlM1F2fgnF4e9ZPfYP0klC9r5ogmcrBCuNMSOTsvi/W8jVJTJjgoUz0wqQDUUH2KmVlJiwYf9+HFXXnUpInF/5p/TWAYkOH5exF6IvThsYtz5Dm9P5HvyuKrLIUsVAbR
 t8gdby4e
 63xCfJegVwNzdt9XWCOqUq5FUKa1cS8gkMIUEcZwuxg+YnkupGiBaMEHO3iM2oYo1LfaM2XaSlI/Xi2H5dCfJMUTtK2WFDt9B8U79kptGk8EWsv4x7p6cKDOIbZE7Qnzqpr+r4ZyJ4jtNMmOKKySi5MpmtAGinUzATgdO4Hef+A701wa344S4tC6UQ60bss7B57uwL86Q/5lR0FwQZyhbV5J7vW6Oqiug8oqzNHUL+XZvycoXBSmAxtAam1rM4mMk6PlRQXY/O7fUS6MJmz9Dw4RscriOgb8PoReQn4bse2irG9PUtY/XrZ2Xlwbdp/06tEoKjL9feSe7wNogGBjQa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently all drivers which use defio allocate system memory. All of them
also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocates
system RAM, so simply failed to set this flag when it ought to.

This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_IO
in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
erroring out with a kernel warning if not.

The logic requires a page from the driver and since commit 1ecbc7dd2902
("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
always required it to be refcounted, so this was implicitly already the
case.

Finally this patch sets VM_MIXEDMAP, as the logic is mapping
kernel-allocated memory so this is appropriate.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/video/fbdev/core/fb_defio.c | 6 +++---
 drivers/video/fbdev/ssd1307fb.c     | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index fd00b86e1ae6..fb359ecc3966 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -366,13 +366,13 @@ int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
+	if (WARN_ON_ONCE(!(info->flags & FBINFO_VIRTFB)))
+		return -EINVAL;
 	if (!try_module_get(THIS_MODULE))
 		return -EINVAL;
 
 	vma->vm_ops = &fb_deferred_io_vm_ops;
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
-	if (!(info->flags & FBINFO_VIRTFB))
-		vm_flags_set(vma, VM_IO);
+	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_private_data = info->fbdefio_state;
 
 	fb_deferred_io_state_get(info->fbdefio_state); /* released in vma->vm_ops->close() */
diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index c4fdecafd856..958514a35433 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -763,6 +763,8 @@ static int ssd1307fb_probe(struct i2c_client *client)
 	info->fix.smem_start = __pa(vmem);
 	info->fix.smem_len = vmem_size;
 
+	info->flags = FBINFO_VIRTFB;
+
 	fb_deferred_io_init(info);
 
 	i2c_set_clientdata(client, info);

-- 
2.55.0


