Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3944CA601F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC15D6B00A9; Fri,  9 Oct 2026 14:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72186B00AA; Fri,  9 Oct 2026 14:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9144D6B00AB; Fri,  9 Oct 2026 14:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7B56B00A9
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:08:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C5A61204AD
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:08:09 +0000 (UTC)
X-FDA: 85303871898.03.86FA476
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 422C516000A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:08:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzK3MyNt;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10L90PzOXSgbgk2Yp7RVeipj6WjV7mej+Ed4jbhmuXc=;
	b=HZjBtAzqJTZ94qBvssVPDDn/GB5CxG0skVcC0ZMT6ePnfcml+TgQPgyDv0Yumkma/jU/9H
	yidDDEMLITNy6jb11l/ixASgN6+IuTyBA6UJiVoAdVLFpAddrhikWb1vHrph92xN3ln520
	I75F/OMR/XCiHr3t78Sv+UJp5mTwqYo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzK3MyNt;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569287;
	b=ELaPTbGuQzi+d95YBJvSdoUi8l5zHkY8lZX1vLu9tx6JhTCXHs24fYaXRBvxOwu+uN7vNE
	VX0cOMA1UvQeybZCTdFfrw8q8aaBA9ZRw0ITkrDNbHPq+hvNKIoHwamIClrPtAn6RDua25
	0GXMunhkRHfZNHbQrQyLDltiQi9qrHs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82810405ED;
	Fri,  9 Oct 2026 18:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30431F000FF;
	Fri,  9 Oct 2026 18:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569286;
	bh=10L90PzOXSgbgk2Yp7RVeipj6WjV7mej+Ed4jbhmuXc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OzK3MyNtoR4vX480pcYdgt72nDk9UWXwl80hLaKSc2jB93q51DmjvSpPEbFJVhZ9N
	 /Jz2EH/sn5dZzTi2DJ8DN33sbx+jAy0RJ1xn6U6viMs0AEGCggPydVZgyRpP4o8j4I
	 HGBg+sCFTR5G95A7s6yvCNE5T7jSJVVjI+y8a6yPurjua0Tvk5yLxgm6mRG2p63M52
	 jcZ8ipYVQ8PYOnRWjIn8XTvkYy9jZhliOJDmFctQI6c+dUdS3koRjvRcKb/D1TkUmh
	 3uGMd+XJE2V7V8Z87DyIniMjhD8kkZiWih1TmJAHdIuuExbaAWCnia2EJMYgpgjbCI
	 03SkdhbHXkFMg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:04 +0100
Subject: [PATCH v5 10/38] infiniband: update hfi1 to use
 remap_vmalloc_range()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-10-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10306; i=ljs@kernel.org;
 h=from:subject:message-id; bh=t2zMqz7GwrO9LwCoKVbfTLpQhoUUcOpzKx1NKvIhX3o=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sxas3jTCYYbXiKl/ZP4p3lO+Bk5latTb+fVXfn/n
 svVdF6a2VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJ+Dxj+KcfoRkW9EvGp2Pf
 6pgrGlrXzv9JTFhqEnLinXScjl6IyEZGhoke6XLnG4oPutz0Cj2f9O5v7LP8LR8cDSYdC7rCv9x
 kESsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 422C516000A
X-Rspam-User: 
X-Stat-Signature: h7x5mk8crz89j9h4cwodgg68oj491g3x
X-HE-Tag: 1791569287-613256
X-HE-Meta: U2FsdGVkX1+nPe2XliMcoDPkxFU/7Gw/gbrC/2oZdeJIqzMSZcDS1jjaoXM47nCkIAtXGI8lhWCvN0F/+WGpjSppJzdv9cQZhSkA/Ph6xUiNOQvDXGqqnDAYAA2lal3TyBFmnadptjrb3kNhgi7iGc67mT4K8jplmiIEaCofTeE/dFLZZxwzkySWuZbFYIYUOkXRiDmz2XJ/Sp/80QCwDq2H78MyVv5//OkHFZwG8cDN7rRZsOvRZd69e0o4YSPXNSzUT/7Xi8iW57ekD6jdGUEEco9wTugBt12FBc3+qUvnmXetj4jjpWZIvBIRgoVfjvJoHX3Qrj3oAhMAXZq6aMFZhqSNPa5wyt1M3Abz38xm/3FdhUK7RsP2xFjtDaDCyIkPf7Ha52K1qGnuZhFzaD5jN1fWpUoFUFhnLCtmXahba1crx9KqNqDtR8o/uQWjjEXDocwyWFc56sd8jfxUz3Xg2uQnTqmdTaGoBb41vLdNy5cf1IGVnN3jfb8jDQvl+/VVweA8ZOgpwVFHnsW0oiP5wrMtXtMS8YZZgNkYDPT/XwOa5JTC1dv7S9YRtswu9nbzYq62cYYp25oy61G3UH21Ts5zA6jQfi8RxuJ9Mh9h6zuRaUHaFkGju/IoBMYuB38nd7Kzuu1tZVmdA2WoHcXYMZBb44FcSgQv23a4FxY0a3iibbYPP0ALXXPEjUu5ih0rwth9guDQD5YahT5d5pASm+kJuaJg6jy/Dg5hfqG3S+8+kTXzbLyl+zGKkhAMqISLQ0105FZloVLk55bttf1Z1EckkzrbfN8k73EfG8VkWjcCQ+lxADx//xZDZPiHOffdq38spMwdmhLeoRkgH5Wr97YSefralk1oarkDmuwhfLAycnsLCgDFqsDppdfcpXjsXGv2rYYJaqMXYOmhLSQKlmY1HHp1S8ARzYr+7mdIRfL33eh3Ohbp1JnJKKF+jphp+3wN9gO8czBhoIZ
 l6Uo0YVr
 qrjUaH5RTKjB9q/CmS6uXQEZS3iNsEadBPm49yradZdJjo+KuGl9KwhCreI3/eKR1HtPHZKgmTOzAzL2OyICPIEP6MzwyR9wlAG0ka2Giie5lmT8pTukSkSQBgyjWVYpHe/LENo99pAQdgGgtdx9JMhlrx8FFIAioNrNapovEbF/E/Rp3jTWZzZq2zW/Ilk6joj8ieipvxiyLobrFsV/08M67tEx6fcMVrH7jfCV4rvD3j8tZyfirgJ12GFupF20wpRccb7rOE9DTYXXCih5nU1AGRjYO3LnbAthunmcsJNwtt329gyimPRf3JOJ4XssCSNfnWxElShUvl25C9/l+GskShmy6mL8JkJj3LnVIuINCpZ28GnV14cqYl+9FRwl2dwE/2O+pxutMwA+eRtKz8n3C/zFQYT0mHORQ01a0k3WBOpFDNrs7hl3mrUHr2vN84Z7l6nx2DSmkUeAZYLv/wdmsfRtBHy3iElQN58zMMRE6u9icDhK9LLWiqSX8O0GItLyr44UUim3vDUTSPbld4HLUyXstfq+gJUqN3uIrFsUbEkQoneHEpXUoJ36+yqsMIZn69ybvraw2xTiUvU3qOtOLQ2gFI1ApgrYAmjk7w1moZYcQQRsvCWgFFPuDLzUvbhn6kXSSsKbCf5g8b1GllRPXJufJhMIQ5zmCZVrOw5hYt5pSqJYk/XcH8G8mgAE219AaL0tA3s8lt+9nmBo1MxtCxHpA5Px4ZMLF14l7PBDJ9L3EF/vwMMfAuXkhbQnedQ8ZcIRWQyUCUxyO3FrRxQ0p+6mr1Il+YdBlcPh+E/nwCawRvawjRlKcl0IAafx+sdTly3G5HkUxt5b2TX+QE4LAWgXPqZ8j9axeZhmQID/mdSdcoMQ75Zh91BZHsPfd3uCuBiKHJt8ldN2W1Xp2SbXhUu6ZNiNeZu9ovzxKpC+04QYfmLfq2gdC3gC8sgmw0U+nuZAdBkilpQmb5o2WoFwOseKh
 yCJONR5X
 GjwtvwvNtqIg+7iqTiz27DIb9pzPY+WhBA6hkxOAgmxYwitdCD3my8eyMS6gbYqKJjc6y/4P252EA2+VrZIhafyW2nNKILsyng7kdRK9dSeEkD+plJiidWLf419NVRsyouR7fVwPRvIjPdF1+529g/skBXloF8XVEcN/EO0shn1f9Iwg21sa94fxviffdyVCwnsoSpefYso9WznbwoFwu+bNlGvqr053dXpsP7+c6JfhqqBNE6M6QendHiQgeR/W+gLXQoI77Z5fmpo7wKs5a8tAP2Td737fEFV5RJbbfRQBLlv2hmjTwdMLdJ9oWopYRDXVmVqDO1xxGRFNhCRuSMeN5Z6OpQX+BqWpUy/ULTPWd415r/HEFkJAdreISNwICISPSzGKwETfZETeaUOEP1WIFTQnfqlt7ZAZ64zs9GBKZo3vaof3iLOBDI6awEPlgWU4W1O1Gc/xYl4oMBHrxo+4jbAsltwqQzSsyQMUYuMv0VeIA7BkRxWEUs2OKlMWp7NPWrW75Z7K/1h4Fx9iA1/mFvVXX1LkNWYg7sNd8XBT5/KPCVIk2Z9gR5G+gJwrSqeBarcF+zTEicROwg/Q/bABMiJnn86CR93lg9ImTxTr7xzADvcRnk/j3MmP3RHRSZ1bl1ESq3ShibueZGDdsAcos0/NfATZaVjT8AL1eFRZBO0oYoiCnjPbgjeVAFh8v0TVHRA3uSBPCkONhFy/GmyJyQQsO8k7WuRdzuyHFVwQpQstpIX6+dch9u8xITrGAiI+o+iv2w2eT9L9hN2VU/cXm0p+5Bl2ZalQlRIBVCsK3H9YfFBoUjHXxifk4t9AHp2XzjyaMCptq3NxnGmAr2pU77JUJt1+aSQa/4YVJrj57Acl7ES/MRZBuN3N3ZIKBcKNV20OyhBPONLKEFK1TSgwip/OFwhZkcuFL4VE8B0FnfupG2asje2o49vNmsu7Kfv1nNXwygd550uB0t8qjmDIO9MlH
 KCWOYIlL
 eAn7LKxvg1whd0+A3Qg/+ewEaONkLApa5YH5nkgyrc4yfbpK6f/c0ZyMA4BNtO+uryW/umvy1XpjB/RZos09ermcD5pkc+vQC4E3vKY3NKFc9D13LkwWVLxEi/2g9QZqAXC+AUHvufc2LSiBj3xXyTnI7IIe9EFu6ZNSu3PRgh4slqzuqYDXiTesv9HI/jMPMgLbcJGyn318jfOF7ZFZrQXTq3h4dQJ2j/bU8Knerqn138pUSH8onnO+gsta/1F2jSlaqfex9oVHlXqS2kSIDCrcP7KqWK30YJiIElPUt/0kJ6lVLjkATo+dIf00wOJ+JD9Lds8FJwM5aCn+cO99Cc9zwKzagwbVVFibeecp06e7s3fuHTHh8MeyEWyb/I2XwEHOiY7AOzJePnGv22Xnj/DfNPq2UmtDrG3Jr/qm7TqICmN+V4UQ/hZIjTRsh9q1t32tdwU0nMyYYwV5aJkEadzpXWOsERTcMJZCQz4UGbXIW/g9RjO+1+XYbihgk11PKhQwsTb5z/o51+bRiKDvjW+w8ekiIHLu1UgIX/sRDhmbZEFDfAfpokIDZoWM8CgadqMoUp4Sf+JyyBjlOmIWFkw+NYP/GdNT8SVqYrWGKiBlWP00HHEUYqBnj4qLkW0m33poTxEaOBXYzNEMU36cSOLzPJKwuZDJoavbvR4U2Wr0D6/hSPQ1/10woUwxLdeRGng+CPHISRKZ8o50TQneNFp4XEc+BrhNnPh7rkXqv4QCg94D44zeuZ1yu71lfypTT1yMn1RbtjF/VoBomhodBCxsJKC7ku0du2qBMkIRl/zetfV+OMauzF3zZ9du+9aKqXdjGu6oeAfnTldotJLboX7P9uHaGhe3/DBa0wYUZRtyNU5PuuyfdQhXyaU2ErIIdrSTPDc8592a5Vrg5VHz2DS839AGOmbJY6lXn/RU3LnnkmRBWOoDp+HQlb8QtuQ1w/YrejvXfJ92bAS1h92I+LDXVndE8
 uWeHjQw6
 WNkx2uulmaLhuiyANpfK4YXVFCDO8deWyUao1IHlHwbfCbYfmPhWLn6b1wqjmhHS7FRqZdnVshN2F0e6Uhv+nIgJxyCENC6TJR/jzvXPAqWcCpZWNCTtj03qRb7egzfb2+X7wfLcu2GjRHM8RPU8yknQ6UVytn0jwtfg2JGb6lkep5np73kZQr69m0Tx/991DvoQDf7qDGIan580KvL5qF6VxQDu5Oq3G72CZRasCIDbzEqkm5J+PSe3zQ1i8IHDTbaibvWd2t6EVzEcEWjJzrCKxxyUKNOUSqWM2oNlDt9UKaK26gOhEC83JGQltXbdQyMR0rteuPX5HmA2joaYyF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In cases which map chip memory from vmalloc()'d ranges, the hfi1 infiniband
drivers currently installs a fault handler, and then smuggles the kernel
virtual address of this range in vma->vm_pgoff.

This is exposing KASLR-sensitive internal kernel state in the VMA, and is
entirely unnecessary.

Instead, use remap_vmalloc_range() to remap the VMA to the span, and
eliminate the fault handler altogether.

remap_vmalloc_range() checks that the VMA does not extend beyond the
vmalloc area, and the driver already requires the VMA to exactly match the
span of the memory being mapped, so this has no impact.

The memory is all preallocated so not having a fault handler has no impact
either, other than pre-mapping the ranges which is beneficial.

We also remove the VM_IO flag as it's not appropriate here, and the
VM_DONTEXPAND flag as remap_vmalloc_range() will set it (and also mark the
range correctly as a mixed map).

We also update the vmalloc paths to place the virtual kernel address in
memvirt, rather than overloading the physical address memaddr. We predicate
the vmalloc handling on the vmalloc flag before we check memvirt for the
virtual address-derived PFN remap path, so this works fine.

remap_vmalloc_range() requires that the vmalloc()'d areas were all
allocated using vmalloc_user() - each of cq->comps,
uctxt->subctxt_rcvegrbuf, uctxt->subctxt_rcvhdr_base,
uctxt->subctxt_uregbase and dd->events were allocated this way, so that
requirement is satisfied.

We also remove VM_IO and VM_DONTEXPAND from the STATUS command, as these
are both set on remap.

Finally, we remove VM_DONTEXPAND from the PIO_BUFS, PIO_BUFS_SOP and UREGS
commands, as these are also all set on remap. PIO_CRED retains it, as
dma_mmap_coherent() may map via vm_insert_page() on the IOMMU-DMA path,
which sets only VM_MIXEDMAP. The RCV_HDRQ, RCV_EGRBUF and RTAIL commands
also map via dma_mmap_coherent() and never set VM_DONTEXPAND, so set it for
them for the same reason.

Note that we retain expected behaviour throughout - the vmalloc remapped
ranges set VM_MIXEDMAP | VM_DONTDUMP | VM_DONTEXPAND for each range.

VM_IO was never appropriate as the ranges are explicitly not MMIO, and the
reference to the v3.7 VM_RESERVED semantics map on to VM_MIXEDMAP |
VM_DONTDUMP | VM_DONTEXPAND correctly - no core dump, unmergeable, no
normal vm page for purposes of reclaim/migration/etc.

There is a change in behaviour in that pages mapped using
remap_vmalloc_range() will now have normal GUP-able pages, however this
should have no impact as there is no reason not to allow this.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 83 +++++++++++------------------------
 1 file changed, 25 insertions(+), 58 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index dc548e6802e2..b02d1f1dbb27 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -70,7 +70,6 @@ static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, unsigned long arg);
 static int ctxt_reset(struct hfi1_ctxtdata *uctxt);
 static int manage_rcvq(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 		       unsigned long arg);
-static vm_fault_t vma_fault(struct vm_fault *vmf);
 static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 			    unsigned long arg);
 
@@ -85,10 +84,6 @@ static const struct file_operations hfi1_file_ops = {
 	.llseek = noop_llseek,
 };
 
-static const struct vm_operations_struct vm_ops = {
-	.fault = vma_fault,
-};
-
 /*
  * Types of memories mapped into user processes' space
  */
@@ -304,13 +299,13 @@ static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 	return reqs;
 }
 
-static inline void mmap_cdbg(u16 ctxt, u8 subctxt, u8 type, u8 mapio, u8 vmf,
+static inline void mmap_cdbg(u16 ctxt, u8 subctxt, u8 type, u8 mapio, u8 is_vmalloc,
 			     u64 memaddr, void *memvirt, dma_addr_t memdma,
 			     ssize_t memlen, struct vm_area_struct *vma)
 {
 	hfi1_cdbg(PROC,
-		  "%u:%u type:%u io/vf/dma:%d/%d/%d, addr:0x%llx, len:%lu(%lu), flags:0x%lx",
-		  ctxt, subctxt, type, mapio, vmf, !!memdma,
+		  "%u:%u type:%u io/vmalloc/dma:%d/%d/%d, addr:0x%llx, len:%lu(%lu), flags:0x%lx",
+		  ctxt, subctxt, type, mapio, is_vmalloc, !!memdma,
 		  memaddr ?: (u64)memvirt, memlen,
 		  vma->vm_end - vma->vm_start, vma->vm_flags);
 }
@@ -325,7 +320,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		memaddr = 0;
 	void *memvirt = NULL;
 	dma_addr_t memdma = 0;
-	u8 subctxt, mapio = 0, vmf = 0, type;
+	u8 subctxt, mapio = 0, is_vmalloc = 0, type;
 	ssize_t memlen = 0;
 	int ret = 0;
 	u16 ctxt;
@@ -347,7 +342,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	/*
 	 * vm_pgoff is used as a buffer selector cookie.  Always mmap from
 	 * the beginning.
-	 */ 
+	 */
 	vma->vm_pgoff = 0;
 	flags = vma->vm_flags;
 
@@ -366,7 +361,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 */
 		memlen = PAGE_ALIGN(uctxt->sc->credits * PIO_BLOCK_SIZE);
 		flags &= ~VM_MAYREAD;
-		flags |= VM_DONTCOPY | VM_DONTEXPAND;
+		flags |= VM_DONTCOPY;
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 		mapio = 1;
 		break;
@@ -401,6 +396,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		memlen = rcvhdrq_size(uctxt);
 		memvirt = uctxt->rcvhdrq;
 		memdma = uctxt->rcvhdrq_dma;
+		flags |= VM_DONTEXPAND;
 		break;
 	case RCV_EGRBUF: {
 		unsigned long vm_start_save;
@@ -422,7 +418,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			ret = -EPERM;
 			goto done;
 		}
-		vm_flags_clear(vma, VM_MAYWRITE);
+		vm_flags_mod(vma, VM_DONTEXPAND, VM_MAYWRITE);
 		/*
 		 * Mmap multiple separate allocations into a single vma.  From
 		 * here, dma_mmap_coherent() calls dma_direct_mmap(), which
@@ -438,7 +434,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			memvirt = uctxt->egrbufs.buffers[i].addr;
 			memdma = uctxt->egrbufs.buffers[i].dma;
 			vma->vm_end += memlen;
-			mmap_cdbg(ctxt, subctxt, type, mapio, vmf, memaddr,
+			mmap_cdbg(ctxt, subctxt, type, mapio, is_vmalloc, memaddr,
 				  memvirt, memdma, memlen, vma);
 			ret = dma_mmap_coherent(&dd->pcidev->dev, vma,
 						memvirt, memdma, memlen);
@@ -467,7 +463,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * user registers.
 		 */
 		memlen = PAGE_SIZE;
-		flags |= VM_DONTCOPY | VM_DONTEXPAND;
+		flags |= VM_DONTCOPY;
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 		mapio = 1;
 		break;
@@ -476,15 +472,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * Use the page where this context's flags are. User level
 		 * knows where it's own bitmap is within the page.
 		 */
-		memaddr = (unsigned long)
-			(dd->events + uctxt_offset(uctxt)) & PAGE_MASK;
+		memvirt = dd->events + uctxt_offset(uctxt);
+		memvirt = (void *)(((uintptr_t)memvirt) & PAGE_MASK);
 		memlen = PAGE_SIZE;
-		/*
-		 * v3.7 removes VM_RESERVED but the effect is kept by
-		 * using VM_IO.
-		 */
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case STATUS:
 		if (flags & VM_WRITE) {
@@ -493,7 +484,6 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		}
 		memaddr = kvirt_to_phys((void *)dd->status);
 		memlen = PAGE_SIZE;
-		flags |= VM_IO | VM_DONTEXPAND;
 		break;
 	case RTAIL:
 		if (!HFI1_CAP_IS_USET(DMA_RTAIL)) {
@@ -512,25 +502,23 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		memvirt = (void *)hfi1_rcvhdrtail_kvaddr(uctxt);
 		memdma = uctxt->rcvhdrqtailaddr_dma;
 		flags &= ~VM_MAYWRITE;
+		flags |= VM_DONTEXPAND;
 		break;
 	case SUBCTXT_UREGS:
-		memaddr = (u64)uctxt->subctxt_uregbase;
+		memvirt = uctxt->subctxt_uregbase;
 		memlen = PAGE_SIZE;
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SUBCTXT_RCV_HDRQ:
-		memaddr = (u64)uctxt->subctxt_rcvhdr_base;
+		memvirt = uctxt->subctxt_rcvhdr_base;
 		memlen = rcvhdrq_size(uctxt) * uctxt->subctxt_cnt;
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SUBCTXT_EGRBUF:
-		memaddr = (u64)uctxt->subctxt_rcvegrbuf;
+		memvirt = uctxt->subctxt_rcvegrbuf;
 		memlen = uctxt->egrbufs.size * uctxt->subctxt_cnt;
-		flags |= VM_IO | VM_DONTEXPAND;
 		flags &= ~VM_MAYWRITE;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SDMA_COMP: {
 		struct hfi1_user_sdma_comp_q *cq = fd->cq;
@@ -539,10 +527,9 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			ret = -EFAULT;
 			goto done;
 		}
-		memaddr = (u64)cq->comps;
+		memvirt = cq->comps;
 		memlen = PAGE_ALIGN(sizeof(*cq->comps) * cq->nentries);
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	}
 	default:
@@ -559,12 +546,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	}
 
 	vm_flags_reset(vma, flags);
-	mmap_cdbg(ctxt, subctxt, type, mapio, vmf, memaddr, memvirt, memdma, 
+	mmap_cdbg(ctxt, subctxt, type, mapio, is_vmalloc, memaddr, memvirt, memdma,
 		  memlen, vma);
-	if (vmf) {
-		vma->vm_pgoff = PFN_DOWN(memaddr);
-		vma->vm_ops = &vm_ops;
-		ret = 0;
+	if (is_vmalloc) {
+		ret = remap_vmalloc_range(vma, memvirt, 0);
 	} else if (memdma) {
 		ret = dma_mmap_coherent(&dd->pcidev->dev, vma,
 					memvirt, memdma, memlen);
@@ -588,24 +573,6 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	return ret;
 }
 
-/*
- * Local (non-chip) user memory is not mapped right away but as it is
- * accessed by the user-level code.
- */
-static vm_fault_t vma_fault(struct vm_fault *vmf)
-{
-	struct page *page;
-
-	page = vmalloc_to_page((void *)(vmf->pgoff << PAGE_SHIFT));
-	if (!page)
-		return VM_FAULT_SIGBUS;
-
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
-}
-
 static __poll_t hfi1_poll(struct file *fp, struct poll_table_struct *pt)
 {
 	struct hfi1_ctxtdata *uctxt;

-- 
2.55.0


