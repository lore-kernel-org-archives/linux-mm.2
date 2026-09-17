Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A7BBC982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93126B009E; Thu, 17 Sep 2026 12:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43CB6B00B0; Thu, 17 Sep 2026 12:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90E456B00B1; Thu, 17 Sep 2026 12:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63F406B009E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:29:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE7CC1403FB
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:29:39 +0000 (UTC)
X-FDA: 85223790078.04.A391B52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 01EA840004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:29:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dbRB47of;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dbRB47of;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662578;
	b=N3M6GQUyBqjb2G0WcYZrx0A9zXZBNbHooTpqtj0FpooLDk3PKlJ8r2it3zqnJn1WrbtcSL
	l0IS9sAH4HzbW9uGipH8p22Hz1GG5dhWhsNmQp3QmS2I2zGKSCW13+v18mCkK6zcxHKyMR
	6PUaZwkZsRSvhMivboxoVIFqZGeSfm4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ht1E3XYrT6zNGxe7BXRz6LPnDrSfYBDlq1F1i7I+270=;
	b=pE8jMx2wEnYnyxuU6kRSecINnJPr/dNZ3X3LwD9O6/ZNcuCPqb9ROU7uFWhz9xwG8F93SE
	piYuJZP5+/hnYxO7ChhZ+8uvpPgnYnHlli4mODrzfIpOqTb/UYGuW3S8SwFCeR7GXQYbXu
	5ihFLreQHuba3tsa/QUyDa1SlFztEKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A15141363;
	Thu, 17 Sep 2026 16:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220F71F00893;
	Thu, 17 Sep 2026 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662577;
	bh=Ht1E3XYrT6zNGxe7BXRz6LPnDrSfYBDlq1F1i7I+270=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dbRB47ofHZr0h32dLtHj8gOYSjObkQRAfNeh3WPpPefyZxKOj7REK2DmcOKSOXO4f
	 r9l6XNryKF+hpjo+7ObcmU6U7x0dvAHPHf6EiKNhNWj06W9kIeQAdpcIRhTWo4QMl0
	 RLrIJyu85upL/D9BkeJtRpjYmwYQ+tu0uLxXZqU3delH3fds8ajC/dRzaFuPXut4QI
	 XIefC9t+6YJl/LvCrT+V9rJkGbY/z2ONmNS5BphoYawKorecqpAvg6Dk9QmITZDy0M
	 X8mhMaBvKWEtlGv4TgAQKXieOEDeNXteg9TAK+d+4eMe8FYZ7ggCJ4YCtWPX8ir6Wv
	 ykGgfMLJZ62sg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:22 +0100
Subject: [PATCH v3 13/40] ALSA: pcm: use vm_insert_page() to map PCM status
 page
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-13-4583d8a23bca@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Takashi Iwai <tiwai@suse.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2769; i=ljs@kernel.org;
 h=from:subject:message-id; bh=BufAYcKoxP4rPy82Onp5UAmN13VcupWKa3H7JCJQDTQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB8ocPh1OGSVz5SG6f3iG/++71lddiNl9w1Vz6vib
 vJ97/JCOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRzR4M/8PXr92WnfMhnff8
 Ky3lLw5LZ8cV/t7hJLpj/TOrqe6OwZUM/91rC3Tu9qnN7fy2I/G/RaLPxDL7E0EWF1987fxwr/F
 wJzsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: 01EA840004
X-Stat-Signature: d19wkne49ak4ii4rj79pjbz7ad766ap9
X-Rspamd-Server: rspam01
X-HE-Tag: 1789662577-58764
X-HE-Meta: U2FsdGVkX1+yhutHhCi6hh0ZnHPkYEjAVXmEf2enVLXQy/dIHclyH/CmnJ2jq8DAeWRhT9L+LKFCkSHTcILri08RdMYv9jJeI25EU0Ec+/Z08wZ+Z/bKE0ZDrIEmssf1yxpk0AKeNcFy1sXP1Je2HUVU1sc9yf7HOFIa1MMFa7fPKlgVEH6Y0qcxL6ER4olXNP6L+BZGO4V/HybpbUAJ15PCSConWsWeABEmIOXdxh60pPJLoyJo8+SPWjoR+y0iiPo8Y/EKlWvcqkkwOPlkkAPUmWhDwL02LhT07lujNVkwuTpYY36o2KHTOUg82GqC3ATEm0yQCoXIhNbCrzD859/dptiSiWVJB7V/hEVH3rLj9L04g0RgOgILoMXmUcfAnUC3vnVRig/WJCxw43QTNB4p0XfZmfQRdKtbk/52S8W/jMGoqBT0+A1seCylOqMyzNtWb+398V0TVDSO431y5G/eUXxlhypwSq3Mv+YPtCuzcJ8z6A1P1MO2TXTtCwn5sg+eqlgtoaWT2D2/XQ9Lg+lzSK3N2N5p8+qHdxP5hQ5uF7u/x+OzS9RIM9dzYJdHFzyUM21Km2QaE9voDBJ6MU6/Ugnn8j9oKDvuZ0jNyzUu8sbv8oS+DGWNYo7Tli/Hn3mHAMXBKelvqDA+Om9FtogcuBDB34Xjrqr7KhsXRzaYLoS0iy5F1lJgrFFkGkRYkAq4cKKdIJJi6KcSI1W8+0CN4s3YS61PPKmSAw7LiJt4seJi/4iTYdqcVXuXFMaqN5eKAnAs4D6DoKqayQa5DGBdAjUY1joitT1OYKe1mUxq84U4EhwgJiPFBQ8Jxs75Pdd5AmdwXdV51y+lGESqmc9JKjtP8E78d2l4wJbsJPbrWG66V/HYhcjBneUT/FdhLSUYz/A7sgV49OyoJMLd5MSEeqK+WhyoJzSGByi8HHnPc6HfUsNsch7X0gyA5YW3rduHa966On6T7GrHy4a
 hOs7Ylyq
 VGjkHbOwZpk4Br+1r54Yw9oCU9lUX5XHtkK0CV6jRViproHPHs4zzrx0rmpSe+U+29e5ARQBx8aFu70H2wX+5+/aOWfMy7xwjFQPuconCDMYuoBHkCkXonCEJNY4wlVdiL2O2O1qOIcUvLXyk7Xpz/5NSdnpIyBXT+t7B1g5NwzlwAJOl0sk/az5sIKGFluWWJP0Q9dbKB9JvfIsHlZlFlaK2a2M72+ktsfh/TZYXyNRFhiYHH4LGzziLtx25NLbyvct3VM4zxe9DX1Z2UUNSbGtOJMlOiy79jWBVYjrJigRcGgHfIBmzxpxbd+U6yGXvwis2XMjWmzo+N0Du8ZpW5mr2W0xJRoVI5q9e28wHxtHo9CushzAfinkJN5ewQVBP/t7Vgk0RFAZRJcO70TeJd3y+3eRUFsreYTzbxk8ssxV4LyyWV8AKNPopsVijL/j3YrONbYIJkAbespVMl9offOgE51WoTtPcnVRVNyk6IkRbzeGawvA9PTLqUb/Z/hHjK8YXgQ5d1ABUWX0yG6L1kWn+W5tE+QH9Z2RBJ4QwF+w+fGqaRqKPpSm7tE0AvpNbt/hOqM7+lVga4lH9EXN2MQvoXaawZ+SvW1OJ+AqzRFT6b+f6D824jhEwGl6WQJP8+yE480R6Hdu7bd+vqd+ZY4Zk0Rr14Ehz/0+bvo3ByeebUyLBLMUOWxY9ucjAS4V5GxQxsmG+IBqtlNdFQXS9e2SvLTNlQWE9IQkyt+92DDfGy5FO4qS4xKBLgArPjIXPJz4Ui1lUQReyFY/N4iGeUAkWsCQq3AGYCaUfxalegMXMO/FlTynhdJD1kJizPryrsjA5G419d7LRmlRtXM4nro6sXNzWLkOwk4A9txRp+Oq2URJr16GDGaIl64I8J3TYDmdJhf2XllpGulCLRNOxTTrzVvYOe1FG2EeyA18fb4uAjw4KXc4nAOKb0Gciwc6vHazpQvFgjMGlC0kOuMrKVwu3gF3g
 SaVottLe
 4zMVvUo72BMXMDMWVNrFROMMNlzFWAhGhdXTGNfyAZ/BiR5hy/Rk0rdOXKCHEkkWqG6vXPnI7OTItksu1vZyJ6ILHBtmOIH4tvztkF1MRBe80O4d26KOALDrDrMVR4+ZdxvQCxdqeFFkneqwfPueYLMMhuCaq7X2ps2U5r5oikfp/wDzJYCCyuTCnEsybG1Et6aGbbYEvNlFwBgM43cfhL2tTwq2BPS/EX4LAAeUEegb4ddzKwcStHXwPp/cjC1IsEyeCke+yL84QIxhW7/e+buyxIB8ET3xf16zTTWUnACSBCbh/JK06zPwrxvSzNyrQzBpgAF8etvoGCULcvyH7R3qOAMgvY06o/ONWUrhE0exVnE0EWLNArWDeAR54Viws+pYb0VcVkilV5a5m6htDsyRSx0lHOL0tfYjbgVR8tyKvBw5JTgWDE19DeDYx9UNMJP/umc0kNfkwCMiU7ez1QGJv/1dQO4ZYZk7YgCxrOVHFXqhTCTdohfWcMI1TC4nN2XMQth+tZCS3uaUrNa8GCMHga5Z6EFNHN2Mxw8oh0X0lHUavEm/6StQUOylDwE4KiIvwBDzPJmrboxiy1QRxsjekpbkPtb8aUVI6MrCE8Q3iU67wZFUEvFK1VaY8ug+pum7fpnJM/lO+eGsjjxe/gIFyQoqhBjHOYEKa+JDrGCPRyoeFVM7zmTbrapZmmCvaUOLrZ4/sPl1bMn0VEfXZGhxPsY2mLVjJQTn1qneK+Ay0adnPaVj8ssurAlXRUAl1DN88wYldIYtrrRlhWd9YnnsH23mbCIz/25cuYnxrg4eKPN6om4UE0s6KwRv9aXYZ+tp39JZ3jdXgEzDmMwggiT9FzPT/ymIz5Kir84HuE1Dh4baprGysgbsatXBpZzzKD6F4pfV96att8+oXHET6WkNd2211fbLTk5RWBRPsfnDImD/uQtBlJ1+gbWfVPEOQxW8l0fbeZtr3tRbdGOdOBAWiBoMN
 +fo8ZpPX
 cw/PrLoh0uCsQ2a49Muek9TGDYkftqT8wJjABORjMgU9jQprGBXf+tSM7toFkrEZhWCapabJQIW/SQA7p7KDr/kEgTKw7jqxc4M48PjbQ9EQYJuYMgdR+WskEzHuxWU4mM6glbjZ+qTvXv/+lDLsvPdWiw2iM+p2XIUSeFoFjffYXX+riU7c24wvNeW4FQrLJO1+kRf8NlorrFRKBhSkYYKxCWE5F0KpE/lfIuu4BAYtkO1zGeYj7i3PA4WwGjHOmgHGCKP4BQO3HGA+EsHTTetFGxwVMjMV5sQMFIcUrt9wz3UCopavkPuM6K0fNuuGfNyU9Ucp0QdX5uy8M0kp19civ81XW+ZXK60vyw0e5rFLgpxtdPuNoyMrfvjopG8LZ+vO8ZlyXoA+CujEIpozMJi+Sso0ZmtmEWCX2M6zHZlI0iOAtFrI3QXFB2s1/Et522M7CGsxLcBe/Bfc7FfOH5PH+IfJcmFCAXQyF08f+oOQDx4hy3u26oJjW5JLVtwd6AvdGVnzUv4cApcsL94w9QyL/uC7sK/PrzaEhFvaGGxuy2H3dXzKygCNSQFHZm3pok7jnzOex9rff2It8F7sd9ZdO+Jac0DOhqF4vj5WnttEtVgn6mztYl6Z9fGesXH8RHxFGiMkTnGMKvR8k5n+LKq09bs90RLYFbrGe63LrX6UxU8uiYAAeTAlbls+IeGBrA+d1JGFQrw1M0MFlVyo2fMV9QzvhxE29w+uxoxlg/lKD4akAEJHDEG7rqBrDBVrHQ/eqNfi+PoWOEZQyrHOA0Nn5OXSK6SNZWO1w/XGOtKV7ptTg3tDlnpA+8hsAJ8yyFMzCFjtGz5rDXjmrBw6nqLrQpQYa2Q4EJP7MnOFpSDj6LFe5j8jW8ULGlxEGRiA8y6uT/c+wxiqwUv/JEiEJbr9kn9fDz7RX+v9EK9Y26oGRaQZYMfQXV524Nvf8QmUYRu/xQJJYQAmF2dCjzutN0oEN7Y7v
 CHsY9LkZ
 Dx1WRu7JNmmLHSrMByvOQr/4soOpVH4bm2lZ4OqzD13lbKIV3079D3IrkwHWO8KZxEETwRotftvoWcEojSygtDfSBMQnY2Zl1BG0WJuItB2wM+p4BVHFbNnljwdbyIsMKqa4+vIUyoFE0HhmHbWt2z+pNVJHzREAKI71xJzpYJ6LhImeFN7FPN0pZ1NPOMtN8vKT0CRvyiiUXHOHMHy13qNFNAzEsfB1YRIAxaEZ5fU3giSfGI4Kv9HBExCXYcYsNSV80mNDNvmEEDii4g6fbrIeoPiV+j+Mx0tLnVrblH+7AaW3DvcA5QEUosWdJOFyU748wC9dW1bNyVmLeurL/39JozgeGzaUH0BAuDaVnion8/kvWAQiQb0s3Z9tb/f74PmIwLmHW4x55/7zFpjoEpbaK98M1J79E2uL9oKLtsjrzOg2VkmNnVEwQFiuJaZgIfr+WbuVfaPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to keep a fault handler around for this, instead map on
mmap.

While we're here, rename area to vma to be consistent.

This correctly makes the mapping a mixed map mapping.

This works towards establishing the invariant that only PFN mapped or mixed
map mappings may clear the VM_MAYWRITE flag. The status page mapping clears
VM_MAYWRITE, so it must be kernel-owned; the control page mapping remains
writable and is left fault-based.

The assumption is made that the struct pcm_mmap_status structure is at most
a page in size, which is asserted as a build bug.

This is safe to assume, as the size of the structure is 56 bytes at most.

Acked-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 sound/core/pcm_native.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 62324282fcae..c98fb3df14f3 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3760,39 +3760,27 @@ static __poll_t snd_pcm_poll(struct file *file, poll_table *wait)
 /*
  * mmap status record
  */
-static vm_fault_t snd_pcm_mmap_status_fault(struct vm_fault *vmf)
+static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
+			       struct vm_area_struct *vma)
 {
-	struct snd_pcm_substream *substream = vmf->vma->vm_private_data;
+	const unsigned long size = vma->vm_end - vma->vm_start;
 	struct snd_pcm_runtime *runtime;
-	
-	if (substream == NULL)
-		return VM_FAULT_SIGBUS;
-	runtime = substream->runtime;
-	vmf->page = virt_to_page(runtime->status);
-	get_page(vmf->page);
-	return 0;
-}
+	struct page *page;
 
-static const struct vm_operations_struct snd_pcm_vm_ops_status =
-{
-	.fault =	snd_pcm_mmap_status_fault,
-};
+	BUILD_BUG_ON(sizeof(struct snd_pcm_mmap_status) > PAGE_SIZE);
 
-static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
-			       struct vm_area_struct *area)
-{
-	long size;
-	if (!(area->vm_flags & VM_READ))
+	if (!(vma->vm_flags & VM_READ))
 		return -EINVAL;
-	size = area->vm_end - area->vm_start;
-	if (size != PAGE_ALIGN(sizeof(struct snd_pcm_mmap_status)))
+	if (size != PAGE_SIZE)
 		return -EINVAL;
-	area->vm_ops = &snd_pcm_vm_ops_status;
-	area->vm_private_data = substream;
-	vm_flags_mod(area, VM_DONTEXPAND | VM_DONTDUMP,
+
+	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP,
 		     VM_WRITE | VM_MAYWRITE);
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
-	return 0;
+	runtime = substream->runtime;
+	page = virt_to_page(runtime->status);
+	return vm_insert_page(vma, vma->vm_start, page);
 }
 
 /*

-- 
2.55.0


