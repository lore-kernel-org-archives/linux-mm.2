Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7498CC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3AF36B00A7; Tue, 13 Oct 2026 11:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C131F6B00A9; Tue, 13 Oct 2026 11:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B040D6B00AA; Tue, 13 Oct 2026 11:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82C5A6B00A7
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:08:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03729A0CE0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:08:57 +0000 (UTC)
X-FDA: 85317935556.30.954EF4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4188B40010
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:08:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHOPEcU7;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAzG9Wth1XJ2c0bU3DI60XqRT1mNgvn5WEld38uFlsY=;
	b=BwVDAWZHMgjff5gkxxXTzF6EbKIKq4NvuYtyGalLOZCQwMiulSYoPXTQSvfqEXpt9a6JT8
	cbuvnO29xOj77W8pGCJYvNz2JJe6uOu1WXQh9MYKnPnnC5cWYNWJ/O4P55kghXYHA/vPKP
	imqm/l4MNn7P1QjkwbCUQSySQJ/MTFk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904136;
	b=8UMVhqr0jUSPyKAZYJOnze8GD3ZkDn0S//VblXiVs7yF8T6bteKzSUPp32XqseYu3Qo6OH
	wb1/Y+qp8kZEnjRD7rzJvN3TGs0ohNmSbS9LV5eNd0yQO6AQT+eTmjHmFzBdMyBSS52crF
	xB4g7YzwCgPu9ld/j511QJXPaO9pu88=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHOPEcU7;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC46D60A5E;
	Tue, 13 Oct 2026 15:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0219F1F00893;
	Tue, 13 Oct 2026 15:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904135;
	bh=SAzG9Wth1XJ2c0bU3DI60XqRT1mNgvn5WEld38uFlsY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FHOPEcU7MXinlxgbwWxCoeD5kIf5P/lIzM7XJGaKv4AAf09FeVis+fbDl6q2+pPY+
	 spXkLO3MXzogC821f/XTwMp8SAwmiQqxtIPsVfoO9L9d7FbFRHRvf8YuD09fA7bxjE
	 SlSItJH1h0l+ilsQVXHmxvfBluDOi7boaCOmN+9yXJzSYS08qphyqDae7oBnwVLRWM
	 Q4mnxEr5QgHO4tSaRiaIzPzhg4mfAdemvg+5lSiBikE0l3VKSI6JE3qTC+2nWQZDlU
	 8WL81pMWCJrlgZ1vKDANjXQZbh+xFIMGOYgT0zOqRkrmZa0k5cnEINgwkJKg8p3cRD
	 /j9W4+enKtBkg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:45 +0100
Subject: [PATCH v6 05/39] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-5-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2708; i=ljs@kernel.org;
 h=from:subject:message-id; bh=W5EJA/cmsVT7jDTw6eYY8+j+S742rFhYZzwOfLirwec=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeRxfEfJ/U3brQdO/Ntp7ihlnc+maHFNKPJS4a0rdC
 ZH9vE6rOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARe3dGhq+yJTeWZkcfY/rk
 e29+2g0dL8npjWfn31io99DKqea3wGyG/7EH5LU+HM49IFuqE23eHJLcZ7DixoMtVb/Pix2SKel
 i4AMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4188B40010
X-Rspam-User: 
X-Stat-Signature: itee8busqaauwjj67xqqhssf557mmaf6
X-HE-Tag: 1791904136-257612
X-HE-Meta: U2FsdGVkX1/hFabFeUEtHVbQLSArxA9nPn0XIxBWjbCFBjHyNv4juY5oVaPWWv3ZEfEBDKuWYAAHIHXGhdfMvE/0Ls+ZTdwb3eIiYrQq80mtGy1vT4irJ1uW0CTACYUbR3fuoLbmUKKs9P+T0Kkf/pu39tWtlv7BpAxwRRrb1PPsRH8FYQcSjZqlkqyc2aw27GD2ATQygZU4P8N0SVLNhcnqUjmdGQQad6BM6huG+xWBTvpEy5qXTwf0ip7dL+nQziFCHOLMGAnlhMO+MzyopO4mJJq50rKK6k7YZdwsQD9j88mIcyJpWTAyQy+g0LC//MGWNrMXFK5fpY6/K4BHgacXjNO5chgmPsDYdsKg5N6ZQBJR0QSjkVQ462oNO31V2yqzfmYFi74oi08y3283PqE/fWvoKhmdjOVdqeir7eNkeQDWY0YsgNhAp2mIwlMXhzVIlVbb0xjXV8V0EaAD8BwsVxx1JYFI8a1bNnkXmmOb5AaAYD1T5s5b97v7gRE8fjR60wXY0U9sAXqYmdjKfQDktVqY1nBiAQ3VkQrPBDea/tFxexYiTU5+u8TJpgqkAZwc2cOIwG+84c5wTG+U6ciLUWKMWziilwCG0pvObJPX+CqT1sEOcAIQsmrNzUwofMSzZHX0hD4M7eH04R0oSGjIiKDpp86R5AJFViBHDoLbHnkfQG/tSYjjIH5lnUDMrXqPEmGaxG2zxAoWh0deAUvNW5CdJpfFbnJ15FkvY2dKrb27Qwn0oFbc5rFZjQef4Xn9BHtos0n9N8/dzic/3RHkJE6Gfk3+Mft2yv7Wks0liD/6AYWnr5uUu3jaFnksgV1eGr+0oHoY/8gBBtQwUzkNRuKLSHDWjsiUCQi0kCB67UXrmWfUhcNP2h/grYQk7GaA+me7oEk7bowS3OG+pBBROpc+p+2ZrF3zhDL5SWwyanPN6axb7lDL52xJPsxd3DsmqWqybRkdaEwJRWF
 xdZpYZRn
 hGuZ1cOiWXIjwzPjpjcmMRI8HTZIRtbLxskKAuPxBK17p0pjlzosHUsDM1OodANa2MhHlBQRVJ21TsJ3m5MmdZZCCMspCiVG47Z6F5pPYblaxWq/Or9vkPpBjWaLUxaPYobJXv4SX/KenDJ0YVY/A0sv87JAfDKPtQ2Z51vAe54ZrGBxK2/BrmUaW1dgrfqTHpQy2Hriusey7NfdeewYcjqbFBQWGakU316/Lyy9lz1mjZhNUeOTsS9iC4bO7/5HRl4YdLYgL90A+8zqMcziT/LA9od/mwYEVYJywMgZ8bWbDdyJmu06WR+LlsXA3yX2sPtqZytWAU6UeD5vCSp0PJT1QUlIR69PuQF5gRWYepJmVI2bD7uWJcW++Q6WqAyJWF8r9DiYF2qV2x5MNAmgjQjvVbJDp1deB7TMBiRv+eKsrdMYNIl07V8K3spnaVNVEt3Mm5hAvZtZibFf0f3CVFFXyIp/mAUzF6Dv/Tfxyiq98QpdyBHXyQi4D871Sr4cwLDahi2OQi6KK7v3fNS4WgotcOojFABavD4gCX7Eymim+4USljdZb7slt3lbJgx6cMQBhPaY/SIQz+N/MtmtsMNIvM9Fz722l0kvwN8/KQj685nszUQ3bq4Mw2mGU3SnDnSzbImJEb/UWpRrleDIiCx/6UxaNR4ExVCsHTXK90srWIEdRu0++oTBBMCjCa23UJmMyGunKMbroQQccN5z7GLjx8qPjYFL/U61i+SiUGhaqFVX6uO+qSL088Uk4tuAu6fJ/lBbSIxDTiE1BsD8xDNnxFqe8bdvz+vz0XdLt02vwvjE5M6CK34CQQHTKGVKkOySibZlrJETnPNTchAFFDvUlvkZpbzQ1wg1fEniyndJoJtrbr2lmsonnfOoGFUHMm+bCLXTSNMH5ZK3Vh8mSco1EGsZozO67gpQjxBDxE8yd4J8X9jZ38pqOSXn4IB/OVPO9+7GrGTsWH20RoOTLJs/ak/ZW
 Cb1fDOQY
 vvVlwg5/VGPr/IUrYj7rHMqHoTOByxnxAa5dEXd+xItbpX1A5/ZyM7YxUwrtekfS1AiljnxaHH1gculyJScKRFpvxap9VtCHdjkTpBPvhN0RXJTB3bzc48fCpamQDOUhP67idOdr2Tl5QGZdvZ617RDEZnGkmklgKRFxPBct7EA2GxligFXLmXSfP1pfkArdqErR3ULqGpq3tIypy5Cs3WDqM8LijJ9t6YgoHtIWYB4UxwOEDck5hjQuMgHVK+ZoYaHxkvC42YwjJgWaglFihj/CzPXpsh3f2yNlKAosBJFmnqs6Xo+JInReHdfu7QZtgtwKrFzpXJPLEpxABv6WKbMeDc3FJ8+fFwL87+mty5urEr1TWQbKsDhDb+O9z3OuEEiGxVolugrpHbiWTSeNGrQOoEOxeVsu24kKaB7+TmfVobUrjOicW/t02FHQM7qo094kXC/tv2hxAfIY6H/SUFaILynekR61edE18Eb7ErhDTp2ipuxTEsYg1PAP4Bb1n6ld+KSpXFDBB+BRH9j48igy8uIyO84Hz1kYV7uFTVcj3P6wqRTBQji02vnbg4IPuQ5CYQSUlkfQjBZHWsCxV34tA4wuWEm5DV2X6Y6PWGWmAZ+N5hM/W+sts4c0ntBkyIc6BM55sDu2b5idMwsMRhuM22vc3Arz+NkUI3i81vys4veSm4qVgQaEq00aHhul/kYCqwZ8MtvptpjuhOgCVNNhdIm9/jYI3xnzDfukES9ClrNygMhXufT8m+KdJFBjIeMy5eakcVlpzcKtPwsBQRRFTMoVCG9Vyw5JeDd+hf4uVqH0++rVfcRE4fZZIL4kVU/qRc2V2U58CGrGuk3BxSyZ+jDcUjX7X/KhRARBCsdpXV0MyNb7Ej3JN3pHXigVWP2oQ5To5CGpuMloLwDakwHfXZgF7EHFVLSal3qgF6MoqX9at40pnywr8C+ByioBUy8bMzj4ZxiTEpZqm+fpoSMEHT349
 /jghijTq
 fgBQjyqCOP8QIhx3ag55wGuvCURrSJ6imAMyD5Szg8RQhait6zK1EH04uBSbcitK/AiF0YwervzY05iLFczZyTeqXW1zkHA0DMzLm98JKDvwrWfi6+xYKFDXKmqvlF4lZseZLRPasf/ShQJ80iome7NTBSocmNdlKu/mU+qrDfIsCh45S0H7OoM1kELtonj/2gTS47araEXh9SmoJ8+mswlDa59C+wqNeHbgPLbg4nC0cehzMOVFWo2W+/pUYJ8t09ggdPX24RF+gD1e19+F6lOeJXPMr896P5dnHnZQ6G+Qnu0D54HsuNAswIHapIHEsr0FEGQ/6aKNhpfjzcWyCrAxVJ1rDSDZGPehMHoRG++8fhUigd8PguMUPQilDFKl5LdGDqOVOmeWdqV2ruzEcnCHv3tRF+5cpAM6yJnJ0MBaVM5lH7KgCCPAYE6oQPMRhaqegIR5IY3bnjewvpg8L1l2rAQqAH8JLdLvx7oaxEmzP/FsThz1NCAq2vncWw3hgk5W1bGpY2St3mgwY0gAlWUX5baSqAQCXH8RYO9v1Qh0enEXXobKqXoenAFnsiN1iq0rtM8qkjuomaWmyyex0M2Y35LPXItSkkxb1517Vg+zO/LnYf8yyyVD95gb5XlS1e7eSrm0/7EprBev64c3Zvq8Q4RpUBmJkZyboS7M15RiUP7fZbwfn2qKsvDMYHm5Vvy9rfpMJemNe5siNn+tAwY3fMKRTfhtkZ6MLSyNzJkLxpVZKgXkGbPZmqCxNSmMBQLPHk21CkwcPw+aMO+o24sydC0IycSFTM7S8jtan2R2frg3mN1ckSozkQ9Unm3m4a0/rsxEDGjsDBXXW+QWh7D56IMeYXVOA87sUSKyPNCjMYwFcFNl9zSzl+RKcPyraa4jb/0l7YWmJRV+8PvrqEUzU1Tx/LiWzfB06uAFHVnzmJ6YQRiXfFrCguyWcvtKXPIna09pCHn27U0CWTg6Spf97X5ny
 aqslNxcR
 cUeuMb9sDxao24UkBAPu8Uq+awFRG/NESdAVyxG0WpqhX+NJWORhhQlfD+K4DMSpwXfdF5+9v3xmBtfanOGNC1eLK9Uz3zRHau13XQY/3ff5gtHYOhjIoHoft6D/WSMBhvmNqqyUVGKNoNCz/3yK1LXUdblj8bsnSediS4/SQOvP5eo6w7MIFET3mvtDRVbpLp8wRAtbauZy69s14qH9lDcvRFAgKUi4ygdrjcaCvpsef7bAYRisXJ7ILZ+0UWgUlZDin3LnkOErntqrmf6MEnOdZTpSF1LtniycQncTMU4m9jO/igUI7ZoLt61phjALwdWFTeaRxsyqxC/TpYS6J8BvROie+XwsST2tJHBHITHPIe52MopDE4A9t0sMIkqKr4rSymi5D7+7H2gQ446LZiahPwkCC4QucdY2bRsC+wRK4o9vJJhsGTyKRgL5/omeTBkNNREOvBu358C3gZyb5IBSSift7+QtFzXfTkZdb8f3uv9T9aDMacOMGmQB0AEgmEYbdkxP2VSvnnr2XitfHkTFkkuCwOsm5qde+1wJLJm7yC2vLRqnAS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no reason to export the symbols for these functions which are only
called from internal mm logic, additionally there's no reason for them to
be declared in mm.h.

This patch therefore removes the exports and moves the declarations to
mm/internal.h.

No functional change intended.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h | 3 ---
 mm/internal.h      | 3 +++
 mm/memory.c        | 2 --
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 68250ece4219..0c17f0932b76 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4768,9 +4768,6 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num);
-int map_kernel_pages_prepare(struct vm_area_desc *desc);
-int map_kernel_pages_complete(struct vm_area_struct *vma,
-			      struct mmap_action *action);
 int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 				unsigned long num);
 int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
diff --git a/mm/internal.h b/mm/internal.h
index 061a87f9c3fb..fc4e249e2343 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1512,6 +1512,9 @@ int remap_pfn_range_prepare(struct vm_area_desc *desc);
 int remap_pfn_range_complete(struct vm_area_struct *vma,
 			     struct mmap_action *action);
 int simple_ioremap_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_complete(struct vm_area_struct *vma,
+			      struct mmap_action *action);
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 926276d41920..448342883e9d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2628,7 +2628,6 @@ int map_kernel_pages_prepare(struct vm_area_desc *desc)
 
 	return 0;
 }
-EXPORT_SYMBOL(map_kernel_pages_prepare);
 
 int map_kernel_pages_complete(struct vm_area_struct *vma,
 			      struct mmap_action *action)
@@ -2640,7 +2639,6 @@ int map_kernel_pages_complete(struct vm_area_struct *vma,
 			    action->map_kernel.pages,
 			    &nr_pages, vma->vm_page_prot);
 }
-EXPORT_SYMBOL(map_kernel_pages_complete);
 
 /**
  * vm_insert_page - insert single page into user vma

-- 
2.55.0


