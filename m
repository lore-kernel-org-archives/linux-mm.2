Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA55C88E77
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508D66B00C4; Mon, 14 Sep 2026 11:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB776B00C5; Mon, 14 Sep 2026 11:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381E96B00C6; Mon, 14 Sep 2026 11:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3D96B00C4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:08:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 434DD1C0060
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:08:15 +0000 (UTC)
X-FDA: 85212698550.01.07846D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7968C2000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:08:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D3SID+QT;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1TTFxJqK2JOmLB4wxg0hlSgvzQnwmSO7NGWVXFT9S4=;
	b=nBHGqoX+ar5n8Ykuj8yyjM5JJwc5YCazZVfc9W9F1VFLyc2XJHVA+y50Z9ptKjrFud9gZj
	ixZ4NQA5NryiDU/XlFVaLAoC6ef87xA4XDfrM0lW9+2o9oj00A8by74Vr1tZb8LdbYdvWk
	3QAZJD7KCf4YU8deGA3GmiuGhawV3vk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D3SID+QT;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398493;
	b=KWiMlv9h1Ih/7hXgtRgdRjYLmoim4a/zEr7jOfEYgaqFD3r7np+g958bXlIjpcpefuq3dy
	Nuwv1Oq9LnMdtS3XcAayxD4/6IcVVpVfBWytBAbpc9ZRV6WvRR3kLzSPxUf5viOs45cbsp
	B/+NEm+/ifnAed2/mQY8AK366FKB/LA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10C2960252;
	Mon, 14 Sep 2026 15:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD821F00898;
	Mon, 14 Sep 2026 15:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398492;
	bh=R1TTFxJqK2JOmLB4wxg0hlSgvzQnwmSO7NGWVXFT9S4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=D3SID+QTMVIxAwuC7b4lzRGl//RePyvZ5Z0Rt9/ReqA80gAvfgu18KAR33H/vFkd1
	 mjxGVZ/vQPjudqzTTrxeNOlOY1QHYbIUaBqTlc4gzJE3VJOpLm4XmsSxCCVRTE1Glb
	 I3TJHXz6oKhlHqNFPgUp0l1qm/B1Bdi0QqVGl2voszPJbbKmst1KoMaR2I0+CWcg20
	 isVInCLJyvSnbZVLP2gLNZowX6+eDdmaGbjObtinB4B5s1NkCHLOBIamdYQq5DpkKG
	 kaPq5qVO3GsOIWnlQkv+fwdh86NoMmI+DeZ06iECEVTOEMw6tcxhPY10Et8D/bBCOy
	 wo0WN06hrd6iQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:39 +0100
Subject: [PATCH v2 19/40] fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO,
 add VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-19-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2362; i=ljs@kernel.org;
 h=from:subject:message-id; bh=In9WHX8b1sLbbe6jUcP+2i7LCzJ4p//dj4w0OtHuz9I=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG9Y8Vrll203D8+/BF/9P/8mz3GwefDPftETA7mq8
 tclH2V/d5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiJ1cwMrTttmnq3PxEKefq
 nbnZqRm/RGfM3XgqSla1PIGxja9mtzvD/9S4pbrnRGSf/XWIYdk8aZeZV9bcL6tuJbxRYl+vrtC
 TyA8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: kbgcmweip8nd9nbpb595tfar51fsiqmt
X-Rspamd-Queue-Id: 7968C2000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789398493-457960
X-HE-Meta: U2FsdGVkX1/w5D1z6rP13UcaOgHc8aMn+cNi11D/RbH9zrxzvam6AhA5GaL1tx0hWdFSBdLcwKz4HsCy09IStP/TtyZnJqMKnZGC0mEb07aTmUJ1BVmmleKHu+PYixUmTd0Kl1Aas0PzWAZtx6/M54aiQ5AMM4yjS0dv+qxQX6F0glFI/51u6Xbz+6JtDAXj1STgdOI6fc4sFGQOSAJvYqKJIagcAmSnyucDuB40WLeWC3l+Aqk94Wb+TYG9sYLF64S2P5ljQayhozirj/yutSlblPm7TqsA0awvs2eRKWXz6D0zyfsHb+Yoq06KU7RTl8c8TYM9I8+T0i79jDq1NoGpIMJNLB78dlOc1wjuekCV/C7P7HGMGHgh/fghg0130gG1zm+j8Z/6nP5b8vwLkBYRFlxoJsejM4ov29yY1ePMdinmG+iyUlw+6Vu8igUTUx85M0UVJgykjlSq1VkzBEI+1Orp9Nxk3ndNckDAJgRRd/bL0YDvKfZjgmfeZ1F2FUTuKTmawoBQ73w9/iUuoyAkB1DES0BBFtynk/NzMrxBjG83J5Xo1D9OLY5RWZUYYt9wqBlTxDUAojf2yWd/z5sQBZRRRh4KYp0BKJJYlYMHfNc6gDtZ7WAS72sYLl1OxerJ+KxYIhY3K5eWZkABSjuQanKwT1KngtIcgN6YwqpSM2Qv+BnJcKQJnzY075WjbQo4MBftfvGI0dxu2mclb3KwIzfBnik1oj9hIlG9yI+qQ7si6BImUykO55st35QjUcBNMPij/xpq3TlybqUT3TjJmzL3mZ2vvyt9K4oYN7p0R9F+2jlJxGO16jWLRNJYrHJae+ydKbsPlidatasnQ8ax+Ko/B+GWgxEp5dvLuYcYZ43wC3i3J0LzYM7U3zKREpHhyUKCxgCc+epyOR9Aoj7omH//rlJBKY7WUD3y9bawFAYVL3WfuasHWs5EU907B7/ehzai11j0MgNa8bM
 5jvKQp+S
 0vw1O3n1H2LFg5VeUNroUQ54H0LNCgT/ubNPTy6jxhGdfQ3/0pNcCzR1LcEl9zUWI09JqN+mYed/Z2F/Lubjvg8RmuPtCtdR8R6ph9EWlU0rbz1+ojqNIMWR5/6G7BLHSDMTia79aH+Y2h4c6mWhrMkLyZxcsnOSm+q66XwdjYRdmkvpedtHJoTCJy3sI/q9GTvdgv/Hipr/Pajvmo6xQ8C65YTfBRhRYJSkQhAe0r1TYH6PAnyK3pOdHnYHtpSu/PsM3iHSiWls3atsPOYm6JFZozKHZoeNbMUkpUZqt7AS+6+54onr9l5o8EhE+Nr4TJcl3hXbXxrhUMsxFow5mJS257q7/0GVxMJ33U8fL3d+kYqtp5RuAziKEli7huALK4N1HxtfcuGyBPPFhxAj5duYutDZkdBL1AIRQgw4td+IGyV736JcuGf3X9kXlIjNoyo3qiz+0MKRCIaF8C1yve/FGzwjqDDqWgb6yinol8hWttIuPtlixBWvJZrfBk8DfYt3JQxR4bDYyLK/84awwzoUkjEKZpqlX3BjRv7PTh0rU2160spEXYr2esnVXkDAJlZwJftLrNtCbXMyQR9dHjkTDufNbdfnOl9pRtDFfxC/KJX+QCZDPzEFPSN6gNYov+u6zsU1jUAjMCtL7+k554cMYQWRbhwv1rcP53esF6P0eTF7FHclPqCoFxAxmRMF8nmQfNfL0kcCeXO6aQtFURr8vYWbXIpJgpWjK5rOuCxWve4htfx5FQQsltjmkSsldwmqbZ5cgkDbZr3ANRiN6XgHUjNO8uyJkbVHA7ZFEMS5VBkz/khsrniZ78upJLdGoOUrnExrQ1MDnwNqfX/Xoq6RNe7wBZxhFjVbQh1SBJwmdAnhNu0H8HWA10fNBHa4/c+NVY/JULxmXmoyQWmjYZDcoSNa9fFA6G6DnYUGu0ufd9AnT7Wl9G8eH06JEn0VFqpupCkEkluDEW8wC3oH7alBmqDJL
 /qcFjUtQ
 yKZhGH5+K4xmEpFVoDm3Ztp03YHHPlvgKduNgHJK0QNCB8WnOfL++zAM3Ple0Opt0e7sHtIkcZoah726wGHcQF1Bu7Z5THdfI9r0lDGyvZdVtp4tzHTldX/X8EoFCWd8S7I8iE1h1+PZNoprKIZgJHr4PX9das+Ti+76/26jYotq/UGK7YPAXdYt6q9zsToA8o1OiHt6N4IIYaV2QOHfAx7kBLloixTzmch36B52vSbVQZZ+J0orp31mlp11eKowK5APGYWurEAdm/w9WgCowIbsqk6b6FRCC5640CpWa62wvMVEfl6nRApvHgWixGsEnpRQM7zjydIPl6Ad5fo9+vBSVV1WOwBIOF9bStrDVbJBF2bolNc3D/5E68KbUtwf541CUz24AeEr2Of28J3Os4+a/ruv9FS0+EYR3pE8+Zf1/geIi1oQlhZdhoNCgv3ySTKkQaPE9z8ugAB7ngHfhvlbQ6+8MVjaB6Ap7pF9FxEojPcYDy0noMo/+ZJgVBVq8Fw9BMH9nTT/KoWfnDJX7jfN1YLmrU4eu6C3S1t4940YLX1NnDfC8HHO9sEZY0kKRWMrRrfuddy7xEKlQizChHp78uNYI/ln6UakkN637CvOxCgvi9B7zEJTgIa/g7PWIq6JxHMBDTDcePnko/6Q7DyvxEd6mqsBTZ2y0h4z2TLzGCjSbSCSwraPJhAo1THN5tNej4WVxwCSYp2FEHO3rhf35WwhSBsN78aPXs2sQwtmQVMR5sLZ1MAWRA9Qk9yeo8dtGF1j8eWxaWNFYnoVT+lpWy0CWHHvk9FWPBQiHVOntjbTkQ604o8XBF8m0AamUWQ9ZxmexW6ZTdgRit7tLcxYvb0g3L9G/LRG0c3tFcm7/xQrjac6Njhr3phDXOJXp6bPiJiuGUeb2x/kaG2B9GRXFDCO5grZNhSon6mQr8OsuBXCLksCye1hkU2llJAn9/uaH7BTB+HJwKMgtj982Djh/oLjD
 DQJarqSU
 KgHecYPHT+eutGZ9NzdpsE5bkF1KLZ9sopNVRphGcT/rS2gWA6aEQsvu+QFdRlH03DzbR/3itvnZY35ZMt41UoKj3IRnlVjfTSRoCUI4ITiCK9grtQ6ZBrt3pjdINqoHV2CqMs6MiLkM/hm+oWmnosfU4TIOWsOV7W0n0ogzk4USDW+7iQ32qxuyoZ7QrE3NdWm4dcmHDRmDkz9ORN/tDPYmEk0qpdIcjRuUUwcNnlMFiChaiG08PP37P7xG0DLryeakQcTVz/Z5wPMCXs6V9e0x9NxJTTErlkcVbsK0aQjPdkOVXsV43vh1bOU9kV44R0ogk7HykWsMUUjhYLkxw5SuQ0n/Ot7PY58NRd7WX48wleGtLaKFVcPWimMSnrKsGCJ/8/vvIQ+UMZkEtgrhg1ZMcv8Gglk2J2Fg9x7LLhGfSW1gzhFjVcbGFIHZaJi/PumQdIEKAbRyyVSkJFW+2xqbNVm0/+fWdwr0wy3qgV9mVA+ARRgJXNahdaMHGq4blgVHwnTJimsDiXAiw9LtdTCUW+4KloS6634de+SaUGTeEJ0l9wbl+PfwHwd1jb2n3T3o6A4diO5HMW3sO8UykuJNlLLqy9W9O76OWiuGrUJm+1wEDAMFOnVyxlSDOzQ7jkRwX8g7azMNhb+88yZIYnkjBsrUzejVoEiwevXGekEC4nvhYtretM8YIDuOjNR7QAePEQFGYbooVjRrsyW7bpQG7p7yVnwiPWW7rFfRuMK1uA4MOlpKpnmRs7NSQGAbUdpamVs37WuKTrnqi1SLIjBRja1Cbc/dtWVz8KcDvXxBQE4nS64kVO3UhxJS1WIQqXKRcaqCtvJSaMYaFGMKFllT7SW9f9mji7C0VTHFuMU05zsoLkx6Db1utgxcv5L7hdvDaSWtMcZ/okYIrN1gFVnSWpGLZ3QGZxE87MOBBa9hbdPgNuf3HMFzcadzpl9enQkIAvM0lV0RLTRV0M3CfFPC15CHW
 Roo8tIqb
 3kfbtyWFBYHxia3NbqkMM1hjgTDBnykyHldt5Q4vRYifI1qvaebC9F8snho+G1BJop9pIMpF7OwNb34Xj73Lq1KN2gWZ/Myj1ohaiP2hFHB++fAcZFMRzEb3hGqFJ8/NuIMYG9UPUx8eUpkOASNPoipAGMGvWBjPlt1i5Z/c1NeD47OBFd/Yh5DXsVJ61vC5tRvUgzCc1E0gN5XA1Rc7/UiBEGnvYXl63JToPd8HmSNplTCodrV7NDmT8bNnaw1C92CFx2MHFwAGjl1Vnakn3sqVyUwZcyTt4lY0I4Q1zQ+KfpJmbhzQQqqnLuU6JZMyYaw/0quh4BQO7i4EWeZzHBqrl6h9wSBuriaHScAh7bdI0Ox2t+JaPGIBUB4Ym0Pq9/HvrAKx3VWDGTIhi0trxyzGsFhM9U0TW3ltLNdYE+cl98JVhoXntCwsNpbX4qQCdAWfZdzKAj8A==
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


