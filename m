Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCE31CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E3F6B00DE; Tue, 13 Oct 2026 11:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F206B00DF; Tue, 13 Oct 2026 11:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16A16B00E0; Tue, 13 Oct 2026 11:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC15E6B00DE
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:21:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3138D120CF0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:21:55 +0000 (UTC)
X-FDA: 85317968190.12.3E0791B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 569C118000C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:21:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UlakyKZP;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904913;
	b=YXart75rKVN1U230E5ctBEEMzsFlpVjteVM+kLMeKH19BvAdudfhFmUr6dq404WjCOYQzp
	kcNuRuzoDiyBVFcaZvdCX+CAkWclh/K6h4ptIvzEPiIAOypBu3Itu+6dwlNYIQ4rVy+Qzg
	rCUJLMU49W9hlJwZL4LrDFV8FQ92leE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UlakyKZP;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zvi0f/x9fmZYE6ONmTuS2JnO4xSTKNre7RTsDSWIiF8=;
	b=gaNphPiaWPEQX6oJU/PJOwaQR+fY75262omLDrelnWNxOExFkUcHi47tRgGEpUwaBqUfvE
	K710n+N7Cw/dDgnwDRoMMa6g60tpVT+GGR6lRs294d06GJPnfbn3DwIVG9nkukaG/SJI2/
	9m8UvB020qd+V+CXGPOio6wRKBKOzhs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E715402C2;
	Tue, 13 Oct 2026 15:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDC51F00893;
	Tue, 13 Oct 2026 15:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904912;
	bh=zvi0f/x9fmZYE6ONmTuS2JnO4xSTKNre7RTsDSWIiF8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UlakyKZP5ISfZXp7qxWAW6UwPPJY6vMtdls5FLmHPfV1g6cWwL+zoSOA6ZblSTX7b
	 85K2Kx9yx0/gPnHg++Jmxd/1mdXHg6jCGVVPwSwfT4fxKW0NteAiL0cmfP8sII0f5b
	 m1Knxz4XemEkrn3BvrKZyfFSf84Ls9R8fG2W8lCOSpXz41C0CXG5M35XoZALhuu8Lb
	 MZUBMpF2S8IApgYDddYys68Qum/rloYo5tqYJCYBA87W6dgFlpfWzEouFeEvSoPleS
	 hN0pWgvcnVWOqjww0QQe5VEPBQxeUq5GLSM/ykd5YFqm7KiVDzEtsENuvwdqBBcFU1
	 +mYNbwMtoJcZw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:10 +0100
Subject: [PATCH v6 30/39] mm/vma: introduce vma[_flags]_is_mm_backed()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-30-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8850; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ZRR/0F24vpRi5Th6FPXXsoGKuQJZg1XNC+W03wHt7vE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZyZJNlynuuFP+eWv8or3v+bclzNqdzqrPnZt7tOK
 RbozAwO6yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEbMsZGZ6JWis/9T3z8EhJ
 6c4L71e0rNRuk/p0Uf++X1vs/VzeJWKMDLtjTtxxW5W++cSp1w/aXOtDuC9mXu2PvaEwf4742Zi
 QubwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 569C118000C
X-Stat-Signature: 698qah7rmau4fz8y5nprcmg1ggqeciw7
X-HE-Tag: 1791904913-870314
X-HE-Meta: U2FsdGVkX181CzvAZI8vT//9bxXtmqR5x6ZbmUpnN+oGJJpinsSmlXL53aNW0BzaehNTFkIf0Thft2TuXV93B6xXQzo8l/BY+z0+iLQWlSFqQP25TE2IuD2N9WTqbscr9G5Pa0HH6fc16lZsKeSCVVCE0heg4r24H/vn+eNZ+ldpYDIXpB+TDiiz9rWlzEVOUOh9m43GYr295kaAiX7hJyTnI2y59pEVNA9Mlu2COEu1G1Mb9F79mc72pc5TRRIEPF775shoUzYAIwbM66IJb1hBUKUn9SIfqWApRqNrlj2EXAObmjYwjES5P6OKKn0O8JJOk02uQjYqbSzXfIludZ/g3GRKkLr7feSmFGyXDaCcQU73+72sdh1eLtKRoj4JBys8yih6HVkqdwcJay3KLKrhrCrFe8HjEsMkcoQsAFKDjshTHp3FAKoVIRd0Mf7OtlJBevqiv6WKofUZbyiCaAie/OQa5p705yvu/ycE1fgifXpjLrLFmXKvnO7stQGhy730rYxbxFWTjIOOcz05ZnWtGsKN37yWciaUPI6EMVCWFN+AmcaiWobaXPeAAUNuE+M0OqvOUH8q2k0s7Lk11bcilpUCOFdbVKJNJ1BTMX8pBPQQZ63lAuYehheGoSiyYgiI7TSX9niJH3YJJKlfwAV9oNyWIfygDRQcHpBas5uKn96C4uNqpglFJs1pWCY91SzOKReiOxRDr53iL72Q+bzMhJ9koBIBV0zkXTI9I0pkDbO0GIbm8DZ/LqOFTZoWAaFdatM31nnox37PeFXv3JNJ35LsBYxMaZCsqi9E4W+odpAACtBzzt8MkHLDNcW+f/SBKEs1uaHEK5/HH8jBJFs3pcBMnDabQLi8cPm/2ZKw+cG2s8hPQmFCz5aUBB6jC03PohsVCQ2yEc6weL7YapVZrdyrLd8w/7UQJy9k/HiQxjPMRAnOLg8EAxRMa9xc9zfw3DFUASeCIvqrrW6
 37lwjNWo
 cXtsskqxL12QehS6NNHO+2xZ2BOajBFgve5zeC4LcojG/M3NFcZQuV1aIFLvbVRIThlVQ9N2A6vrJeAz1/m1ytHvglgbtnmBvbKRVN0yE7WIr5rgPF26MJPSlPEJdfDFIeCmpfze/YXNKPQLbaKkzp2P/+VgY3CFlOkDRdTYw73aSkSAP0cfUKi6HAKpak04iRGng9jZ+dK8/F1VfuzOF0r6rnocm95cFLi/ykOJG6/0+Vqlbf+axibq4KxQUMYuNOMvaajMoRPUW73Sm6L9moT2z1ir5AfaKULWNgUUaitE7GKg5ot9xnwwxpekHDGNC72G/m0m3Vq2cLlD9kBjgM2TXdT1kxrfv1uePT3AcynW3S06kbfuY6g+TnfNs/NCAX22jfynbUE8x9XmrcdN95uxdQB34JSOaUzJaD65+KAJ3SQjbluMane/LbRDlSAnza8oBV8IOaZNUMKS8qh3FU/ZqYZPCXr59kKJOHSwgOMpq3aZJgIn8S2gQY4K2f/qvTf7Fo9cmPpgQTT8YILOzEC8yKIIB/QruvBrHMBiIfnLva2E0YdZlfgISxVfgPgVLuvMMUq6OvJ+H1FSmWo3EmP1Jnm9v6zlIIWPs0HKb0lXugUFCDJlyn1NhV/WrmHw+yuoB3WyR1Pm2ZzrWvqdEPctFrE6Y7k9GqjT0n3KhhIDNbPZF5KnjAd3gIXp+y/jzPi+LXxEl8IeEEMt1LWZHju5CM3aZHxvTYTpjK87FnfXjAqfO6KPBYY9PsLK8g/rDGkLVbhgIKl4R/sfAdwSIPnSlMef8N16Q/vRlAs5djlLNZq1ypu8iOFVtYVvrjY6rOuBzP/Y433VM0eeimgzU2GOr2zvONglWrlaw019phZHr0hrMWYj7FiYIlV25M+ocZdR1ZlVn4h6ZY1Wdn1RgopGr3brQKH6djDcf/l0R9pcmIVylhuZy8axLKJ7PGXlyG+d07LfakMhyZydb8hqE138vyjqf
 na4B5515
 QAlEQ9YsRUOlwt0u6fo+BXqg3v6ebGWqTsX18icD4JBvkUixf6suYo6xV96Yc3OfvbG7B7OrKRNRoBHPDue2WvwvvDqnN1XgumJUziMIvX6LuulBOm6CUBwgQwIuqf1BulFl4uINTor+c/8PGWk3Ah0CIf2y7mmrTU2EnTE3JN6EUdKAE3R8NM7vaYLg3+Jl4XIyMAWk6cHorJ9xs1hqjqWNKoCAjL/3vEOOPhmnhLEm29NjKRFnuCiWZIt6a2hXwnCjgYrAyfD5oFMEmd2Z1ljPrYIKWjybbk2jWDkz8UOCcJcjRHd0NO17HLA9aC98IucJWtb53Og8FLES7lN3RyVyfYoHiMPbmMtuRTia1oMsg8yNHAKdcAJzdKMEhswmX9vRbPhn+pMZ62Gm/OjbWO62KJ3rXPAtIubE8/CjgPftF4FN2F4OG3dmlnlzJEa6NyWukFU/ZUY0QguUEVMYDMN0VFY8197Xnj1YIQA6vb1A7KVz4m8Hm1QcJ/vqwGezYSQdR9DCuqRV8A/Wu/JfkLVAe/Jnk/WauHjkp1LJSwoAfrlngprgK0HrpE9vtZFSkAlLctyj7cq+sorP9nd6hZM970la0C4MTR5OPmm8sbOl/nAsRrXSmoatLYWFCxtFtYPU9qn8rrrgYdhhUI92LX6uAKniXzl6Ju09UHSp4m6Xa+TgYybcY+gXnVswA7fdE0Bmz5Mc5Q+UXkDaYdpgz268U5rKU+qQK8sQGtjNqftFCw+7Z12bAAAVa3uQKKgnjm6SSPXq1ulU7/94jbyN2VzAnXrWmJWfNMYz2uZFK5jsiMRr3ENIQQrPmKjFG04GQDnwEouWAsgKtnxYwuh7PHUN4B8uW9hxV5btjM8jTun6ndipj6maNmKIvqCYUQM9596pMaahsf+tUK3J+FXbX+PaE3AbakDKD1eiJ0fQmkMPmR9VzCHvvrTVW7LR26noHaFUzscluHLLhg/tQcIGXgSISlHdM
 d50Zcx3G
 IOKoPkFBw2dZYizxh6VpUOl6VKss/LYvspvgW986KaHUGfHEFzLJVeeBHFBscZ6Vg46WLwKoFdiPxouQrU4dz6BronWuRQPlR6AkSlCHDoU2xvn0o03BXcYrD1D8GaLBEn7muOpJn/saaBP383eebAPnwep3CBGVNxNg5Mv4/n89dj4VgUx7M9I7XND8QVyMJ2EhaT5SXXkzU/37D1AI3qM+jnXkBSzthl2x13t+PpDZkYbV1fNy65Mtf9HLNgdSUxjFqqYgvPdreFedMGmdexI7YOj1KFLOaJPI9wqPDlTBVeey8LqyoRZbATj/63lA7/J+mUhifT2g3frg5Qib3zNpOhwVheDf54srLbGBb0zoV8mjfFb0hi/HsIVyk0tuIxPRobFYRd0F7G3OjfNlWN9dlTvqnLfwgyv6VvkYoZTfaZ46LB9bHrGF74KY2LOIRki+v8EL8kxyOX8UaLKNY6wcGOynlPjycZ1jzjp+NeuGojTWDiBclXWL13FhWBKGQZeGaAHJf7JpA1scoLtXO6pUPu3jbvMKmfA3hvl1OR4ol8grew834rhtr2RYKbNfWsmRv07mRvFeC0n84ump725EPVb+jVhNBPDWLr0o66K2hRfViaqIET7EYQrPCEUMOg3xggoqJ/+wiylCSoZo1XAMzx6lLGZxx+L9+te+ha+I7Rp5SQym2wrvJc/9Zkusnl91E6lsm0ga69QDn5I7fOyLJKsx1ECuxqq9cov6mT1lM7DZf2tIvUSt7VSWAMFsS8xoXLYJ3Or0ivx9VlgRYM+yQ00gRWWIOf980J8HiwOQpbshHQRXX/kKQYrnV1wChrjq2S3TdPabBgnpCNXQa4tRAFS5OHfaWoQiOelLc+krnJRN5bsLa3Q/FdXode/JNJcNwuYoNCKnj7wwa5nlGPFrUbqZQ8ibX8bbMwK97P9uzh9NSoy1cF80jXDDTpnX+8t06ErQ1RkU8ELpdXSiD1xX5UEuB
 AhL1YdN7
 U9K4IdqV15efxnqxYoQLMXPilTvXuzOObTFFkH+H1HELtGYmQF3C0qS0lD6mnlSpjSCDt1lxBvOtMFb++vUN3lMtgzy6canH2NvvOX2AQbDgbEmZib1nGfRcoI8ghQSEPWqLrLxUKDKl5d7jC6sKPJOL5Lk6RBR10GeSmnjH9v0LfFSLjR7QHtXFywdFoeWGHpgvEu4qC1Lf3hnvyWgvmDts5bPR7jIO/1x8FMzGC4haO9H3n0d/kffvjDdj4Sh59BLql0CiUR+S1RfJABnvtMsdIAMp9+PUJsye/vqcetmE9uSeuS4l3TX3yCNctJ22+yWa+Re0KI9m73GYKKXnHdL917CvaDRJGa7v/CFXM5wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce vma[_flags]_is_mm_backed() for the purposes of identifying
mappings which are mm-managed and whose contents were placed there by core
mm's own fault path - rather than a custom ->fault handler.

Mappings not managed by core mm do not fall into this category, as they are
populated by their owner, and nor of course does memory-mapped I/O.

We exclude fixed mappings as these have a layout core mm cannot assume
ordinary fault semantics over.

hugetlb mappings are fixed mappings, but core mm owns them entirely, so
they are explicitly carved out as mm-backed, as the MADV_DODUMP check
already does.

Use this functionality to update the madvise MADV_DODUMP check to test for
this rather than open-coding it.

Also update vma_flags_can_merge() so it is written in terms of
vma_flags_is_mm_backed() - all mm-backed mappings can be merged except
hugetlb mappings, whose flags and fields do not completely describe them.

Also update __thp_vma_allowable_orders() to use vma_is_mm_backed() rather
than testing for mergeability, which is irrelevant to this function.

This replaces the VM_SPECIAL check which means it no longer checks for
VMA_IO_BIT, however this is safe as we have established the invariant that
mm-managed mappings may not set VMA_IO_BIT, so we implicitly include
these.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 66 +++++++++++++++++++++++++++++++++++------
 mm/huge_memory.c                |  7 ++---
 mm/madvise.c                    |  7 +++--
 tools/testing/vma/include/dup.h | 44 +++++++++++++++++++++------
 4 files changed, 100 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 70fcb7e18b50..e8d2b0e847b3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1701,6 +1701,54 @@ static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
 	return vma_flags_is_fixed_mapping(&vma->flags);
 }
 
+/**
+ * vma_flags_is_mm_backed() - Do the specified VMA flags imply the mapping is
+ * backed by core mm?
+ * @flags: The VMA flags to test.
+ *
+ * An mm-backed mapping is one managed by core mm (see
+ * vma_flags_is_mm_managed()) whose contents are established by core mm's own
+ * fault path rather than a custom ->fault handler.
+ *
+ * Mappings not managed by core mm are populated by their owner, and fixed
+ * mappings may be mm-managed but have their contents established by a custom
+ * ->fault handler, so neither are mm-backed. hugetlb mappings are fixed, but
+ * core mm owns them entirely, so they are.
+ *
+ * These are the only mappings which can sensibly be merged, locked, dumped or
+ * be subject to uffd faulting, as all of these assume core mm and core mm
+ * alone manages their contents.
+ *
+ * Returns: true if the flags imply an mm-backed mapping, otherwise false.
+ */
+static inline bool vma_flags_is_mm_backed(const vma_flags_t *flags)
+{
+	/* hugetlb is a fixed mapping, but core mm owns it entirely. */
+	if (vma_flags_is_hugetlb(flags))
+		return true;
+	/*
+	 * Mappings not managed by core mm are populated by their owner.
+	 *
+	 * Fixed mappings may be mm-managed, but their contents are established
+	 * by a custom ->fault handler, so core mm cannot assume ordinary fault
+	 * semantics over them.
+	 */
+	return vma_flags_is_mm_managed(flags) && !vma_flags_is_fixed_mapping(flags);
+}
+
+/**
+ * vma_is_mm_backed() - Is @vma backed by core mm?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_mm_backed() for details.
+ *
+ * Returns: true if the VMA is mm-backed, otherwise false.
+ */
+static inline bool vma_is_mm_backed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_backed(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1711,21 +1759,21 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
 	/*
 	 * VMA merging assumes that a VMA's flags and fields completely describe
-	 * its state.
+	 * its state, which is only the case for mm-backed mappings.
 	 *
-	 * However, mappings which are not mm-managed may have established state
-	 * upon mapping not embodied in any attribute of the VMA.
+	 * Mappings which are not mm-managed may have established state upon
+	 * mapping not embodied in any attribute of the VMA.
 	 *
 	 * Additionally, private (CoW) PFN maps encode the source PFN of the
 	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
 	 */
-	if (!vma_flags_is_mm_managed(flags))
-		return false;
-	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_is_fixed_mapping(flags))
+	if (!vma_flags_is_mm_backed(flags))
 		return false;
-
-	return true;
+	/*
+	 * hugetlb mappings contain per-VMA state, so their flags and fields do
+	 * not completely describe them.
+	 */
+	return !vma_flags_is_hugetlb(flags);
 }
 
 /**
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 83dd63b04568..5b295a7979cd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -215,11 +215,10 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	 * khugepaged moves data from VMAs once collapsed, after they have been
 	 * faulted in, relying on refaulting for file-backed memory.
 	 *
-	 * Mappings not managed by core mm cannot be reliably reconstructed from
-	 * page faults, and fixed mappings (including hugetlb) may well be
-	 * mm-managed - precisely the mappings which cannot be merged.
+	 * Only mm-backed mappings can be reliably reconstructed from page
+	 * faults, and hugetlb mappings cannot be collapsed.
 	 */
-	if (!in_pf && !smaps && !vma_can_merge(vma))
+	if (!in_pf && !smaps && (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma)))
 		return 0;
 
 	/*
diff --git a/mm/madvise.c b/mm/madvise.c
index 467601a8525b..3d25202db5cc 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1578,8 +1578,11 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		new_flags |= VM_DONTDUMP;
 		break;
 	case MADV_DODUMP:
-		if ((!vma_is_hugetlb(vma) && (new_flags & VM_SPECIAL)) ||
-		    (new_flags & VM_DROPPABLE))
+		/* Only mm-backed memory can be meaningfully dumped. */
+		if (!vma_is_mm_backed(vma))
+			return -EINVAL;
+		/* Core mm may discard droppable memory at any time. */
+		if (new_flags & VM_DROPPABLE)
 			return -EINVAL;
 		new_flags &= ~VM_DONTDUMP;
 		break;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 94bf818ad0e1..19ce10faa9f3 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1689,23 +1689,49 @@ static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
 	return vma_flags_is_fixed_mapping(&vma->flags);
 }
 
+static inline bool vma_flags_is_hugetlb(const vma_flags_t *flags)
+{
+	return IS_ENABLED(CONFIG_HUGETLB_PAGE) &&
+	       vma_flags_test(flags, VMA_HUGETLB_BIT);
+}
+
+static inline bool vma_flags_is_mm_backed(const vma_flags_t *flags)
+{
+	/* hugetlb is a fixed mapping, but core mm owns it entirely. */
+	if (vma_flags_is_hugetlb(flags))
+		return true;
+	/*
+	 * Mappings not managed by core mm are populated by their owner.
+	 *
+	 * Fixed mappings may be mm-managed, but their contents are established
+	 * by a custom ->fault handler, so core mm cannot assume ordinary fault
+	 * semantics over them.
+	 */
+	return vma_flags_is_mm_managed(flags) && !vma_flags_is_fixed_mapping(flags);
+}
+
+static inline bool vma_is_mm_backed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_backed(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
 	/*
 	 * VMA merging assumes that a VMA's flags and fields completely describe
-	 * its state.
+	 * its state, which is only the case for mm-backed mappings.
 	 *
-	 * However, mappings which are not mm-managed may have established state
-	 * upon mapping not embodied in any attribute of the VMA.
+	 * Mappings which are not mm-managed may have established state upon
+	 * mapping not embodied in any attribute of the VMA.
 	 *
 	 * Additionally, private (CoW) PFN maps encode the source PFN of the
 	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
 	 */
-	if (!vma_flags_is_mm_managed(flags))
-		return false;
-	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_is_fixed_mapping(flags))
+	if (!vma_flags_is_mm_backed(flags))
 		return false;
-
-	return true;
+	/*
+	 * hugetlb mappings contain per-VMA state, so their flags and fields do
+	 * not completely describe them.
+	 */
+	return !vma_flags_is_hugetlb(flags);
 }

-- 
2.55.0


