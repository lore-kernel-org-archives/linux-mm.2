Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F7C3CA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8146E6B00CA; Fri,  9 Oct 2026 14:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB316B00CB; Fri,  9 Oct 2026 14:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D376B00CC; Fri,  9 Oct 2026 14:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A29D6B00CA
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:17:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C21D31C3CA4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:17:34 +0000 (UTC)
X-FDA: 85303895628.01.9FC3EDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 00D3EC0004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:17:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NjpwzYOG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=brSHanJN25qJ54Niea2K3A3DIc/HKTRx7GaGCKmRkSY=;
	b=C35ndpVPn0/znSLVxpnuzMRyJpBzfysI+cjKMWQZpKDUjMvSiFRgBnTvdYSpAxv3Llj8UD
	7GbpLcTgVBO17ewRrzbDGp8DLbIDnK+aEaKJZZgg+6vc9kvwRXB2FCs59KT886DXRVtda1
	UywWkg1KNl7n/+9+ce8gc6Tiyx162Z8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NjpwzYOG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569853;
	b=YXAMjyPPXVvlEr38mHTmH2R8o/3cRvsfo3hjxBaBuqKGzPbK1pqwJ8fbuceFwMclGQ8ccI
	fxM7IfgTDcFNONnoqq4RgTN9WKh6PxJvXX+Pwg6Bl8FIyM+xBNTbgY5Guma/arLQTWJ7FX
	IQvWJ7mSmnr5KMos1/iIF8jfkfdQDjo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C3A041093;
	Fri,  9 Oct 2026 18:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8694F1F00893;
	Fri,  9 Oct 2026 18:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569852;
	bh=brSHanJN25qJ54Niea2K3A3DIc/HKTRx7GaGCKmRkSY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NjpwzYOGiGRkBGv2+kMnevRQrrQWdzxweR1O1SfiEhqVYEsvmU5GTZF+RZZaKz0DC
	 MPEo7gN2KQkpLYXQ/0+3pR103pZyBi4+O3Ar8pm8bJIf57VzElzKQDEeTEVo4jkM8C
	 PiI27T5ZqybWYn4VNylc1Ziq2QqYrRStNlNYFC3EvLPb4kKkEOxRQeJyWC41eYS4Qo
	 U4GwDRSN7R3g2SMt2M09YBUnZPVDQLQ1ydjVWr5jmJ8OYJA4LZYTnFix9vgRlGrun/
	 bUTx5VyyfPSTOGLuZXLGfvrMIJi9YmmyI4h1rI3VE5EPbUSu14IRi9OEVpcGSrchEn
	 LFBmBbiK+HIAQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:31 +0100
Subject: [PATCH v5 37/38] fuse: dax: do not set VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-37-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1534; i=ljs@kernel.org;
 h=from:subject:message-id; bh=tfz3ccYwKEyTRVC6abtstchqWCa1ts0/TLS9J4UHnV4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sxv1swqFJoZ719bfann5Z1Zl6xuCD87X32mv2HLt
 Fsq35UXdpSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiXV8YGZbWH7yp13z5Lvf1
 B9m8L7R2q63PXrrWZ2e3UO+TxYtjtM0Z/sdPWiiwTNQkc0OrYbC5ZOLVL6pTnt2+vv2IftziYzH
 bGbkB
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 00D3EC0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: b5ded99upnib47mz8iwatr3g5ncxk8di
X-HE-Tag: 1791569852-108634
X-HE-Meta: U2FsdGVkX1+aFqAUq+mI1pk5o9fCSbfQrax7XOmQL4hcYR7z59LSkKileI6PwXFpZGGLFWccSvCTMDoHjrZbP6oBY7GFjrAm9b+nAWTZ8I+felqch6LiJf23JVP104tUJ6WXLmvLwvITK+waL2DlA3x9cxgDCv7FN9NiQCOInzzV4+13VBNm7OKcCKSE+Vsn+OSFGYrtBGTfoOJ+lthfus9VIfCfsAvZy5CjzIILsjwnmRXIgAF+Hnnufg3g8+5e1ye8sBZC7wAeQLhpLR5/rTVqUHWexw09eh45bLIDkc7j/CnUBJlE1EtIr7hFeNBRZ4tUPzkpv26Xbm1cDc54E484XobLlzus90qCNa9ITtHkHtuL29xWlP2VCe6hEfFRtojJaPkX/tjS/zIula/UqR/4kbnkBjyM5/4WUOVXol9Ym54g0NS0Gkgn8aBoItQ91uvz5/mUHM54MyG27+tAP6pViE1G16SUkaLMzfE1zN/CMLFchwVnLNN74Zm+pkkaTShrvcvpJyTQpPxK0cdQg34VQ6rZrMcjoOz/1VxkENEHoqkTtkWYqZTY8a/j9l0dUeazJGNIR2Lx5eFMUd2L/spHZi8XdbOhNtDGgqE5AU+uvmIjDB2bhczKMMdEAYLCnyRXq8kkMPaq+JlIXXTk/ahSxrLKwEc7QTOpSS5MuO27V8sbE4TzbDNYalzU8ppKAGJgxvqjen2WnNgMzhXv2+uxEHGDBNWC9AEg5bUo3HoXyeGiw3QXu6Ogs6jg9EEKsckMxwYaSm8/psw28MBu4r3sbTlpOGwMzlJhbNIXa2S67py4lLpJ0XpRmzRKRrrGEH+caPhU/7377VBeRA6zrjG0jID/kcCCkpiJ4vb6f/ez42Ron6INhW5NULOpEkbkEYDrmxOu0s8TQfmyINJtnxrnJ7685QfW1EjDdpcpPiRGrsDaVo6gP6ywisdhdrpUZDZLQA9wwwUf7+482CQ
 Kxf9aMIE
 ISW0N7eD3HxizF3u+6pOEYp2K4wm8215DMGR+5WIhsyAZHr9BpNeXZlXV0iSV83WYzq8R++8V5te3NCONrU92TUIghHj7pvtRfvpTLcFpDWwC1eRMrpV91kKnqLDfwcqh4cRJBV/Vi72Z6Mk/7JbZs8H0FNXl/gCycSJe26LAM1lid7jXvBagAe8IUkZvTuTVf+CvKVayAfWvyv4LSE/ODLdTekAlOLLFBSUtWlQGTVmWwXVyZLEsy0hBwHTv2CVe01q3BXBBfH8QJVEpn4Z6uW0WNbvLjud8tKdPsu/tujmnwc3vxTPUpq5V8ijizv1KFnp+mKaJhmTtU2cJoOS3ijP2Ffzzq2VJGoV6oKyq0wp8nP98ehw54C4qnQWO2aa9taBVrb3AB3wxOUE7BM+RayXMBQtl/aktHPr0D/vlRZMf+E2VciQxiivFoDwqgDf9ioqbGnMGwU6CtBsPpWQIGqQIEBD/n/Q81lHve4aafC3ibLbN5WU4LtMg4ud6xgqGHKia3xrkeOyet4IBQF28B8NB7DEUD4y+jcQJZFLgnnASnHQIlnmo8UzbE2uh1U5b/P8I8gXlI57o/sbyS60P4DWuDgW+a9j09gdbrBEihCrB4W+/8GquEb/JKCw2irHUcRyRVB27i8p8qv15FQvKztHzkSNs2OlEwgav75AcoI/5OwwSWDCxiX7y8ZeYIL4Hr9+GomhofUN1yI96Kht0IOHkQUEqLdSJ5NkIfxjPBUiOrtGi6imfPb9nSXaIpEdxOkmU0ad9ET6vAxa6TMuzl3iB3t4kaWfGFldM03uZNvMVAGuQCMjq4G0NQeyVP4q+OTzAsXaEzLiFOIB+Sjit3dy1M7OJkidBYXPuFoYz0w2m+fmYQhk7z0691RiOqf1x7UxuHQbhTFtTyBxryJ+lAtQ9ggNe+h6p3GTp0NrZiquqiTzXk66wF+P0T3q6FnhSa0sOOfD2Cv9rBPMThssIFXzzKRY/
 6xyUxNBZ
 JyY2BKx3MaWXLUHukgZpI6Lc9mQzO/Kf5co8vSOuHrPQZp/AaJkTUPaJmn6pXM4EVqY0gv0hRP7DeC5zaUapZZuSLXjfw1jGEsXkKIzwSMPcN3Av/bs+6uGj3YRrzIqfSEm1ZyJgq9uEGvnn+KIMAs5auL69hNQcAgofJ8xE9cFSBVS3pwLEHfMFgA92ZutVzFXAhP3U4+Nv9PNZYPsppn4ubwKgqQOE8HnjaNolOAz9YPiMsl3XBs3x7gFwlaZqosd+j8rOdwTdGXejlF5MRa2snoZiXMaalg7vYh+kE4ga+qvQYcvYmv++C/8/xEon4D71m/b0PR+M4SJslxw/F2QX++F3RNGY221XrZklKnTUvoaj0/sKhXbmOH09mMhNM0jp78WwX6w82gBBAFJCsgKs6AUBp8Ayg7lP6oWDRZfe+g/qLB4O+o2Ns+4nmJlXhwcccvu3WlB4kOOiOz9iN20BLl075L4KX0rQpSsQlsR08vrMQdy6DUQAKsblgPdZG709v6L+EMqtFey4FMTz73c+E+gdfc5s3ZAldM0aLC1wS+f0LagGi004oeauM9ixb6fXKunO8THinHTsqchKmA3dmGcWIAyDispJnrbTYULKH4+50bHdqzIwcw3Oow4X6ywLkGdiwcOeNMDFQrly1JXAoIpfC6tkuKjqO/YeZiBuDc+92DzgAKUf70M6pHTa/g4PFXeKmApaDL6OExSsGwZ7AQzWe8mIL905fnoOQiUEAqzztJPFakFTsnD0aZRqSqN7v7ZLJVcrQR62KEKuyjinSGNGH4R1L7As/SoREJX3x7mcb7ZIbVhI6kAtICduvj9KGjCo1BPy5oke6nGMtGy4Hjj0IBqN5ZU9gi0VNAPTntSHhH9YrvwDr45yBSoM28IEUZdbApsfO4dj2XuyRbodwFXDe8CARDcfqgCyesNsT5/h9u4+18nAwl8XV+6GTVqVfsOqw6+WSNkHfG0UCrL2p6a/6
 xAIYPtNU
 OjTZQFReaziPNe0AdlmLcUm41+SH+3lT1MdRg8H+y66V6wW2H8p7a3ChPun3+786YwCtPJVQsDvvQ89UzcH0tEx+ciLHMrx4M3xWHd4QQRYWIGA+DLMXgn1cldWzLlz9L95UOKnvIUX6UUk7MVheonEuZLNGoAENHkj1eJkoypzvSmx8R7tbgLF1lq07x1r/eYJK3mR01ROCrHpsYRGUg/xOfFwv29ka9Eue7/lnUNG2wCSr+Ao1wammP3A1vSPpfUUgNvf0YhXMuYn7wDbrV4RzIPK4WYW/W0kQJPUsJg5jGFblgCwPC8rNonpw4OEmiNUfLi0IXC9DsmPdBCj9pCdG99sYJ/G/J5Wt2R+0M2vGwB8asFafVTSVAWlTFQ3aoo9yTr+tJZF7c50hlqeyuRpswIvRz02nL1ihzeSxH0J886GJVYEE4JOU2PDeO6lOvMjjXBapEHLiWRrOhy3JOrq/EcR8CcM/mirmFzeIR+a7XbZ3qvsg7Hrd0MfSjaNcSYxSrbiamwi8TtqJB+BlQ7vD/vUi3sJrWTDgEIFWN6FQs7k8VOPO0IEEa4R80x89OdaqG/VgGIWF705I0Z7GdarXpNUApyavfqAKSxE+f5ukBumXh3jdvKl+0phKAao/cLjGg+ytsLbjP3U/l0IyrFfOhu88oTDsnRIz1S73h5F305/sbuD02fsB4uaZSoSsfXZqsaYadhCKp7uiU8u9BY1S1OSkbDy635nLibVhz4ioSy0rgEc9umGkTOlOpZK7vkmX7LmI//+Zv5kAxnuhf7iTSRZQcQHzOiI2kcIFr6ozR4XGYLajhsSy4NQssgBdihi8TEdqYx4JK5BpzqvKcXk0+H0RxPhtOwB5r+oVCLoUvRdjAPRyr4icod6Bwqa4dFKGuTGm4vx1kMsasnGI+dyiY4SNdYHElYIxoSWb5x6bU3PjaOk1/XNspm3jHA58IOFb9zloTs5iyhYk1XAKcEKpB7T86
 PkrC44MP
 27BtiDYTHwBiG/Cj7riRW5MiJTWxByL0vfEmL2cdglKZzTxGCpnwcLKV7D9KTsjUzmvPFUBQNvpRMO0T9G+qJ5avIsGPL4+EPQoVLV/S+clqNDo7URPDy8tX2Qh6XzKg3MvnY4PBkgDYxG6Z8vAmIA6R8DVeVZghL34iBxImpApIwTE0o31TVdiIbD8u6RzRLy4Ghd1dWD3xwOfQOEOItmnceFoUOuGasSVAdWrN7kJKNEwEwycxa69ryAFL0z4dgZjliXU6NOQ3p/FKoR/8Cm5Jsc+4uwpnLPiTDV701346P2XGlJzfC+ojcFOG2WFN8sYQYw8l6sLIyOC5mhNpiI+ECneN5qgQVNkV+ExNqDAqKDjukzkKd1piOEyASKcCyCqsz8Xd/JSfI2u1pEPU9vViKYedW1qNDZ2Q+atjPDgXVipbT0nqztWhpdP7YtsGKohWc/YSqpRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit e1fb4a086495 ("dax: remove VM_MIXEDMAP for fsdax and device dax")
prevented fsdax and device-dax from setting VM_MIXEDMAP, as DAX no longer
relies on it to direct core mm paths.

The fuse DAX implementation, added later, copied the old pattern and still
sets it.

Fuse DAX maps pages the same way fsdax does, via dax_iomap_fault() and
ultimately vmf_insert_page_mkwrite() and vmf_insert_folio_pmd(), which
insert ordinary refcounted pages and so do not require VM_MIXEDMAP.

Setting it only serves to mark the mapping as not mm-managed, making fuse
DAX the sole DAX implementation whose mappings are unmergeable, cannot be
mlock()'d, eagerly copy page tables on fork and reject MADV_DOFORK and
MADV_DODUMP.

It also requires vma_is_special_huge() in mm/huge_memory.c to carve DAX out
of its check for mappings not managed by core mm explicitly.

There is no reason for fuse DAX to keep on using this flag so drop it.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/fuse/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 85cdf0199bc0..a5994f1c637d 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -826,7 +826,7 @@ int fuse_dax_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	file_accessed(file);
 	vma->vm_ops = &fuse_dax_vm_ops;
-	vm_flags_set(vma, VM_MIXEDMAP | VM_HUGEPAGE);
+	vma_set_flags(vma, VMA_HUGEPAGE_BIT);
 	return 0;
 }
 

-- 
2.55.0


