Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74DB6CC6B1A
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CC516B00A1; Tue, 13 Oct 2026 11:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4CA6B00A2; Tue, 13 Oct 2026 11:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6936A6B00A3; Tue, 13 Oct 2026 11:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3BEC76B00A1
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:08:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79056A0CA8
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:07:58 +0000 (UTC)
X-FDA: 85317933036.12.9B99E2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9ACC24000D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:07:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NYL9xeY4;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOHuuwnsMbHTA9q3JEw9/BiBEzfrt0DoQ4gWVubuCD0=;
	b=DKeTy2aDwYG3VqUN2kIxXptFBw3WTZZ+m/2PcXa8KXZeySrfdm6SOqUVHKC6Lv6QWjKaTm
	uj4YGzAZ4vh3THgZI+ZRG37tT6WxEdCbVEiWqGuP/bGLMplhYMfUjzVV7U7+z3VBpFJGmM
	STyJlZnT+6IKF/acMboMZtC58svNlIE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904076;
	b=XxHwFEb3Vapvtg91Rwv+zyHfG6ICOv2kkw7mWt9N+AkXTArKrrnl3z8yw76pyM6u/npRyu
	XJlHgA9rpT8ahsv1A5IVB0UA8WeD7QhvPHSsRUBQrZMx1KLwPncyvTxkBCxBf7pjG3PLYq
	Pfa/sof8vO/9CIK0ftDk8Nhjn+ziqyg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NYL9xeY4;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CB66404B3;
	Tue, 13 Oct 2026 15:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456C41F00893;
	Tue, 13 Oct 2026 15:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904075;
	bh=oOHuuwnsMbHTA9q3JEw9/BiBEzfrt0DoQ4gWVubuCD0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NYL9xeY4HpjoMGhl8FrfT51Vt0gCprDyg1Lk+GP2L+dqfVMDacNY5uN1PB2p0NsPA
	 ruDr6IcuWom2gPmUzliD1GqShz07KxyuKHuHRkNZICMM3AlFYSOj8COYrFfoYG/gQN
	 XlF57YNJonwxrhoG/S61Po9sYmCH84Sb3IF/S+B668GE26jPmWYZt8/9qyUbjJxJ7h
	 nahhHCpQyMcjh4yzYr4/XepLvRKyc4bk09MVEgp4tbsTOv3SytkqYUYhkEsoZjc9wP
	 CdfrnbCPEl9PfMExdrLAKeF2Opmf/aNrz6v0j0lsrRMQ+CxOMgYos63TPLXKu/6EIH
	 bTOWC3+ZjSAxQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:43 +0100
Subject: [PATCH v6 03/39] mm: consistently validate VMA state after
 mmap[_prepare] hooks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-3-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=14131; i=ljs@kernel.org;
 h=from:subject:message-id; bh=O4LeOMp0JmloXP6dYxpxjgMqSJkeWfRNP+c31xJtCHY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeRwXS2069K0i+4v1wzX3n3dF/t6foxvjc7xptvEsO
 ZfHtmsfdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAi0+wZ/md1MzOov1nnN33m
 gTvXq2eoL29WKzFxD/eP+bNwavVr9nMM/2wPNK2b/yrX0bjsnnHXgg7lX9PmXpr+javmxvKfq+a
 u3MUBAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9ACC24000D
X-Rspam-User: 
X-Stat-Signature: 9frhyxahhbokkzchkdbgc9xnaq5tx4ws
X-HE-Tag: 1791904076-622468
X-HE-Meta: U2FsdGVkX19ET66kN/ZJndSIVRE0hrwpDpXUUUDH00GeRO3Tu5bdzmZCvqY6HCkCzgFjvo2cdRQLSeriUoWLBFed7Zo0IG0C5ZFufW2MHLeO+hByyjvNx4Jd7WwDAb+WEAwLpU5qPOc208NO1nLNFMW/rxp5csSxOdXNQ4uemC+/fGPW2OoJ4ezISliB4EiCvfIKYfAjxmGIwSiBRTM48HbIPZVxU4p6/MAYfPo/yzU5RYBPhZUd+InLxOL+jrI/QJIMCkBbvqONgIGhS4l1zpB8S4nFDu/ojbj2vBc7d+B6zmgU3FXg4IRWQThlzj1ns/Jvc3sOlQm0u9GSqhu5VNyBqK08gHXqxcCzTrusyW11vJ0mYg2mnalib0cOvyhajtyfnzofp56cI8lBLJA8FSZz7SDH9Dw/QJFHKQT24sJlxNHDwlZwUh20EDeEcBHnOZf4gJX2xNCbxjYa/KFRAdZPWWv+Tee4OR4Po/ir/AxXpVw7uh8GIh2pihBdmelyRbRUDRdclmvS2Lup1CLdQaS8TrbPpaLH234etMvgefKv2iJtecAfNzFC6zHFAvmLbcdC92dOnwSFeig4j/WLhJtyPN+R4d+qO7PDTtNUyWzEPE4EDVRAG4Y6k3AI2Il68Qod9LoZMqxiDaioYoZAw9Co04YB4rxKciH6ldF5gl1eg+0168u3hWsUqjnFLYaTueRAa4Ttv2epktRTNHggAyZHsqfjLz0OrzoOk3wtPnQ7VvO5gut/rD54BpLtN3fWbdQFHWk8ruLE/DOYX+2p3aKS5edODwX1AOqaxRlenkVfVqnUFOyzT2AVDYRiYHPqSNMKYlfqk6cEQh9+E1CD+GLaC8fnC/rSbBnqwC1Udy7UJA+4REQAxRi2K1LIM656zUmC8Oew4yfOwyIZL/ypCRDdezjw1n1C/YDXWTKM/lf8nWdCsJ59T1O5GZZzj7q+B8TN2314WpqKFcbE2WV
 e6T0atwP
 wYdwQAyBPsYa0IkhpnFduAtVQOK2XWhb7yT8SQJzo4Ei+ZoYnY52smcIQGSYySUjG0f/Xx1lYBnECR89BIrUSo0LcgnKjYYagsVh7nc2cRDjgLxWahCVzofld4Vk6bdLHYbfzU4hTW3+nP8ZVySL3FeZcQ/5I/8FNBt5GZsp7P+DSASnx400uwyfzQT7TnqHSeB+aBk6MlG6Idpz4q2I21agxwFjXlbP0PigpXUeyQyLy3n7Y768E1znlkR0MjBhlzz7y4zCzZSfkh/Y0/oVvgoMfZMLTQYUXfmct41eemqBieSs2fyzAYTuoEW0CW5ebncWHjOwU5G+B2u10+dSJTvIbpAQj7WQ+X4gGaEDprqsouoH9U7fycWj2qK/wTvSJLbBqPKxax+A+2unNuyX5hCPTiq3pm9GeDYhxQtaHKoS7KxjRqy9DoSaICV2rInQZ4q2s886cfHkyaRhMJeCvX04fk6BjssH7z+BvltPsTI1ArqG+ee8ep0Ro6c16XZci0O1xBRE+gNZx1NAmC1I9EKKzJYCkGFCAY754Uzxw9APLzqG6ko1SpvEBZNQ8BJeMeTYL/nWm8OECALDgY8KcDQMNB6YUDK+c992oedNj769U+AZJ5VmdyNyjWw7/SWRLRNipY7br3lH25eLDyYIO2IpK5Q9P8VHaKpzFNj5DG3jHbDUcpIPY2g9i3WMpt+mau4I9TQj5VeFnkCIPQOOHlPEUf8bnIqAYWhIsGpvuB9VXNiJyDv59sYIJ9cMq0C6TSCyzcySnIUbUS3oyc7q38NelWExRbff6OBVUAoTXYeSJsDoBf108bS+qyV2PRUNOh3dVyg21iRffZ9+1MruErv2830lYyhgXMIOnqCi3m+DgMZCvArLL0d3wJcHSX/3lZ5yEOE/n3kBby+opBWU5OCOQCLiM9WrICQwea+YVjJmoBNjWbbtFe5AjK6GxZorFQDdfXZNdZt8j1R+eJgpI+G3zxCRR
 dO9msreM
 rshhoozhJaNIm6Ku2sNMROP1rxCY1HzpTiQf7UtokM2BECIjsApoJCEMBjAt7aC04np+A3mupiSmugJ9eGDI8aQNp/ywM4SQdqpYea+Xjdp0FPQcD4599lYSSnW+RX2pgIX6pQZ7h3y/NJ/FqKT8XkwkDi0Ss5XEHwsTyUxlKrI0MhILGARZ7LGNY3UXoQamhMlSdKkFQSX94sI9SoW5pwYHZC4QQbszKKsTe0+yeq5s7Z+yx4+xNTwpBhxvaJfwoyUpxnwMy6YZLGAO7T/ryLRb1pDq7emFqollD4USr4ZR9V9cmDFTxkH9Y9vs4u+at9xOETIgEKzAWKCEIpRT35cV1dNR2KIgyogZHs+FjS4sIO2gv2FU/xRSqt1ZsVCrhDVMl7HIwQ4HZhhKbkqjhyo1GkwYCHZTQsSWnrITUYqUjtEpmwhUq3F69KNgsI3Camc7X8V0bi6VXyDKdsUsd9CrGWXZeJX6QU3XEmwSUp5JmME98KgOsRjcJic6o1/33oWtkU6dV63j5tWHUbvyoWHyH5kfbTvKXCfBBmkj1HMSOA3is5cC0i8x3DRoPIX/4ZqXI9UKVCC6cCOLzpf/w7AMqbHnN5R5aliVeCxvKyiTsP4R7qJBuZNO/D6Vm5n7frKrjyD490YtSPUBLlzswB0FhvmNnCpyEXm3pu7r5pvcbrLXaipjpRqDT1afw4CNWzRemKlZR+xUmm1AFbV9FGz6ZhJHtmm3XMrKmPk4lDYuWs9BI+fFGK0Ue3afQNx4VR+uatkE68+X3n5hACRvy08rUZwGo2Ai12ZzgPTAoQtYrxjWJ2uyD4TjySIw/nX7TrgrK30nePFNB1z5FNJaz3wF7vEe58v8aOfw6Gn0yAjFpfggpaWZHnqaFvtkWplHi185n0j6lRudCOHn5AZ/AaKaZSEMFwdOVLj8fq6AwhBMZQ5WXh1SGDfYdlWe0lyh085Aeul325V+8/qAwfRyY7Ld5qmEO
 8TRblyYs
 a12ZzKyHRTPDPJqzUfcot4TtRXMiZv9o/wWUWXPXso0nnrkbMMuhcMk81VE56RB8uIpNCs78SoQ0Y4+XN/tGBkBOxiiYB9A+cMG+6/7jutr/7AvYtGzwFFrMDdCaSnu98KYXRCj1H+7o0ii//rQ6EERrrXHFdrTq0TSuCyS05iypeyJmUAG9Jc7jVoJGaIGw1yWptsGVI4CmrkYbSYA2Mq6LyXr8WqKLdUGynvx//8DbZ8FTfMkskDNRitK7FqXfLLlG3PBw/ypboDt8jIrbiEXGufYoqYa0/gOCOmlaGEfkI0j8oZm9wUmG6v6NF8ZpryAsGBlZue01FDXhr7hZyQVgmOQGwVlPV9l4SEvSDlP7eG9d1/v+xUBKe//ZQxEmouzq6VkLys7T10CldPMNwXqm7+6HvQkj8rr16rrH9VCQGEpEiA9o4ZmzfhRgkCkph3YnUXW6RR7deearSTvUJrAZogkJR47zAiXoX0Bg2jJ2e9AZoPvivxi0vyAqsrkF8RkBjue92SJByK3FhZHvMigsn9EOhQQgB3Zvq72ZTx4i8qPLcwaHQ+asL6wdZdtXNm5exin3kGDQMNFahM/LI6PGOyLWLu5ReXvZbze/kL9nP2GlQ0YBiSwdzH9oKgnWKATlzX+OC2XJ+A5XRVVD3Y0hEQvk5CkDItp+1Q1rc4U5GLgS15t5V31RapRatd7iOs11ysyTVv+TBX88+E03n8ucKrn03+4Lq/JWinyZ/XI6FIM2g9Dvk0DrLCZ2LkZMbeJfKUyDRT+5OP26cMuDpALcDV64bgdujzyv+rjbLWX/6cgMpJh4RC5OpdX1LMdzQgh+fIplqSAyakYJddBM7CgZuGkMFYTYYUDrui5jZ8PxDEXjtHLlbfoEdvv1vc1EsWbPRmyOY/abZZJh+WFGadSES3i/1jVzsopTGz2k0yLc4nLZx8Z9VyPooKvP5eEeSUxWa+GbiEgxnh16i+xa+NJYWWBgT
 Ok7n6N1C
 RzK+FuANiM5XhTbzTwkBtvdU4iu0p/S91aqx1QvpqNBr+dXolYZqY7EeYtJFtPj+YzkV/6fZ9G66GLVnighF4hCPXuoXyEfdtUn46nUZOsTayCRopLngeLI37cZ9Gn6pz6/lOGkN3ZM37tluGhVCxaSOh36IBZhE0GOJFMusXcFHTfqTENuPS8jwNy0B1kh4+s2XD0JVKiiScgVsMSffw+q5/WHhKy7yvhEfjaVQ14ySbUpGQTAwXeO75Sa9fOyINC7OtFSZZQTKquZxQkpRGtlR7ZRe6cdRcaEOnrApyIb1Wxy5ijQ2eAGsWAVYDHb76nC+bEWLyUzhOG18XjFOBKYshwKZXCnAHfG6uxQU03IeLSC2GkUFWxRXQekuMCOCUxYzB4O0vWXZjr0PmGEMyOOY+0iCeqIJ5WVg5G0nyq6qsUTRXGMOhwRPZw5endSrE/2LfPtY0KxgItTaVGLWHy3RXiPMAA1cWMovfy7fwDX5VaO4OClDhgYbDF++3OSJUpfF9N4h/2BmMazfndv/aXJ4DKKgt2drv2y0sBwsIxmDnJosILkDqUIhQTUjfaOEo2ihvMKRVc47HWOPiqqf/Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked, the
driver might have done something crazy that is not permitted by the kernel.

Currently we check for three such cases in __mmap_new_file_vma(), but only
if the legacy f_op->mmap hook is used:

* Did sparc ADI result in invalid flags?

* Did the driver alter vma->vm_start?

* Did the driver make a file-backed mapping on a read-only file writable?

Generalise these checks for both mmap_prepare and mmap and apply to all
invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handling
in the core VMA code and the mmap_prepare compatibility layer.

Also extend the vm_start check to vm_end also - drivers must not change the
VMA range at all.

We also WARN_ON_ONCE() on these conditions as they are things that should
simply not occur in the kernel and it's important to call it out when it
does.

We invoke mmap_prepare_validate() after mmap_action_prepare(), as mmap
actions often manipulate state in the descriptor thus providing the final
state the VMA will be derived from.

Also call mmap_validate_vma_flags() in insert_vm_struct() to ensure that
special regions which are inserted (such as a VDSO or VVAR) also satisfy
the sanity checks.

This way every VMA established through an mmap hook, whether via mmap() or
the compatibility layer, or inserted via insert_vm_struct(), has been
validated. brk() VMAs never pass through a driver hook and so need no such
check.

While we're here, also fixup a couple disjoint blocks of #ifdef CONFIG_MMU.

Finally, update the VMA userland tests to reflect the change.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h                     |  50 +++++++++++-------
 mm/util.c                         |  19 +++++--
 mm/vma.c                          | 106 ++++++++++++++++++++++++++++++++------
 mm/vma.h                          |  25 +++++++--
 tools/testing/vma/include/dup.h   |  10 ++++
 tools/testing/vma/include/stubs.h |   4 ++
 6 files changed, 172 insertions(+), 42 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index fe576d468af4..061a87f9c3fb 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -213,6 +213,24 @@ static inline void *folio_raw_mapping(const struct folio *folio)
 	return (void *)(mapping & ~FOLIO_MAPPING_FLAGS);
 }
 
+/*
+ * If the VMA has a close hook then close it, and since closing it might leave
+ * it in an inconsistent state which makes the use of any hooks suspect, clear
+ * them down by installing dummy empty hooks.
+ */
+static inline void vma_close(struct vm_area_struct *vma)
+{
+	if (vma->vm_ops && vma->vm_ops->close) {
+		vma->vm_ops->close(vma);
+
+		/*
+		 * The mapping is in an inconsistent state, and no further hooks
+		 * may be invoked upon it.
+		 */
+		vma->vm_ops = &vma_dummy_vm_ops;
+	}
+}
+
 /*
  * This is a file-backed mapping, and is about to be memory mapped - invoke its
  * mmap hook and safely handle error conditions. On error, VMA hooks will be
@@ -225,8 +243,12 @@ static inline void *folio_raw_mapping(const struct folio *folio)
  */
 static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
-	int err = vfs_mmap(file, vma);
+	const unsigned long orig_start = vma->vm_start;
+	const unsigned long orig_end = vma->vm_end;
+	const vma_flags_t orig_flags = vma->flags;
+	int err;
 
+	err = vfs_mmap(file, vma);
 	/*
 	 * Either we tried to call the file hook for mmap() and an error arose
 	 * or a driver set vma->vm_ops = NULL intending there to be no VMA
@@ -239,26 +261,16 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 	 */
 	if (unlikely(err || !vma->vm_ops))
 		vma->vm_ops = &vma_dummy_vm_ops;
+	if (unlikely(err))
+		return err;
 
-	return err;
-}
-
-/*
- * If the VMA has a close hook then close it, and since closing it might leave
- * it in an inconsistent state which makes the use of any hooks suspect, clear
- * them down by installing dummy empty hooks.
- */
-static inline void vma_close(struct vm_area_struct *vma)
-{
-	if (vma->vm_ops && vma->vm_ops->close) {
-		vma->vm_ops->close(vma);
-
-		/*
-		 * The mapping is in an inconsistent state, and no further hooks
-		 * may be invoked upon it.
-		 */
-		vma->vm_ops = &vma_dummy_vm_ops;
+	err = mmap_hook_validate(orig_start, orig_end, &orig_flags, vma);
+	if (unlikely(err)) {
+		vma->vm_start = orig_start;
+		vma->vm_end = orig_end;
 	}
+
+	return err;
 }
 
 /* unmap_vmas is in mm/memory.c */
diff --git a/mm/util.c b/mm/util.c
index 016932780925..d809e08c7b4d 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1224,19 +1224,28 @@ EXPORT_SYMBOL(compat_set_desc_from_vma);
 int __compat_vma_mmap(struct vm_area_desc *desc,
 		      struct vm_area_struct *vma)
 {
+	struct vm_area_desc orig_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&orig_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
-	if (err) {
-		if (desc->vm_file != vma->vm_file)
-			fput(desc->vm_file);
-		return err;
-	}
+	if (err)
+		goto err_put;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&orig_desc, desc);
+	if (err)
+		goto err_put;
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
 	return mmap_action_complete(vma, &desc->action, /*is_compat=*/true);
+
+err_put:
+	if (desc->vm_file != vma->vm_file)
+		fput(desc->vm_file);
+	return err;
 }
 EXPORT_SYMBOL(__compat_vma_mmap);
 
diff --git a/mm/vma.c b/mm/vma.c
index 8f8c554d5c07..cedc24dcdf3c 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2613,6 +2613,12 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	if (error) {
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
+
+		if (vma->vm_ops->close) {
+			zap_vma(vma);
+			/* Safe, because VMA zapped. */
+			vma_close(vma);
+		}
 		if (map_same_file(map))
 			fput(map->vm_file);
 
@@ -2623,16 +2629,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		return error;
 	}
 
-	/* Drivers cannot alter the address of the VMA. */
-	WARN_ON_ONCE(map->addr != vma->vm_start);
-	/*
-	 * Drivers should not permit writability when previously it was
-	 * disallowed.
-	 */
-	VM_WARN_ON_ONCE(!vma_flags_same_pair(&map->vma_flags, &vma->flags) &&
-			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
-			vma_test(vma, VMA_MAYWRITE_BIT));
-
 	map->vma_flags = vma->flags;
 
 	return 0;
@@ -2710,11 +2706,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 		vma->flags = map->vma_flags;
 	}
 
-#ifdef CONFIG_SPARC64
-	/* TODO: Fix SPARC ADI! */
-	WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
-#endif
-
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
@@ -2777,6 +2768,80 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
 	vma_set_page_prot(vma);
 }
 
+/* Check to ensure that the VMA flags of a newly mapped VMA are sane. */
+static int mmap_validate_vma_flags(const vma_flags_t *flags)
+{
+#ifdef CONFIG_SPARC64
+	const vm_flags_t legacy_flags = vma_flags_to_legacy(*flags);
+
+	/* TODO: Fix SPARC ADI! */
+	if (WARN_ON_ONCE(!arch_validate_flags(legacy_flags)))
+		return -EINVAL;
+#endif
+
+	return 0;
+}
+
+/* Check to ensure a driver hasn't done something crazy. */
+static int mmap_validate(unsigned long orig_start, unsigned long orig_end,
+			 unsigned long curr_start, unsigned long curr_end,
+			 const vma_flags_t *orig_flags,
+			 const vma_flags_t *curr_flags)
+{
+	bool was_maywrite, is_maywrite;
+
+	/* Drivers cannot alter the range of the VMA. */
+	if (WARN_ON_ONCE(orig_start != curr_start || orig_end != curr_end))
+		return -EINVAL;
+
+	was_maywrite = vma_flags_test(orig_flags, VMA_MAYWRITE_BIT);
+	is_maywrite = vma_flags_test(curr_flags, VMA_MAYWRITE_BIT);
+
+	/* A driver may not make a previously unwritable mapping writable. */
+	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
+		return -EINVAL;
+
+	return mmap_validate_vma_flags(curr_flags);
+}
+
+/**
+ * mmap_prepare_validate() - Ensure the driver hasn't violated invariants in its
+ * f_op->mmap_prepare hook.
+ * @orig_desc: The VMA descriptor prior to the mmap_prepare hook being called.
+ * @desc: The VMA descriptor after the mmap_prepare hook has been called.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+			  const struct vm_area_desc *desc)
+{
+	return mmap_validate(orig_desc->start, orig_desc->end,
+			     desc->start, desc->end,
+			     &orig_desc->vma_flags, &desc->vma_flags);
+}
+
+/**
+ * mmap_hook_validate() - Ensure the driver hasn't violated invariants in
+ * its f_op->mmap hook.
+ * @orig_start: The start of the mapping prior to the mmap hook.
+ * @orig_end: The end of the mapping prior to the mmap hook.
+ * @orig_flags: The VMA flags set for the VMA prior to the mmap hook.
+ * @vma: The VMA after the hook has been applied.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_hook_validate(unsigned long orig_start, unsigned long orig_end,
+		       const vma_flags_t *orig_flags,
+		       const struct vm_area_struct *vma)
+{
+	const unsigned long start = vma->vm_start;
+	const unsigned long end = vma->vm_end;
+	const vma_flags_t *flags = &vma->flags;
+
+	return mmap_validate(orig_start, orig_end, start, end, orig_flags,
+			     flags);
+}
+
 static int call_action_prepare(struct mmap_state *map,
 			       struct vm_area_desc *desc)
 {
@@ -2803,6 +2868,7 @@ static int call_action_prepare(struct mmap_state *map,
 static int call_mmap_prepare(struct mmap_state *map,
 		struct vm_area_desc *desc)
 {
+	const struct vm_area_desc orig_desc = *desc;
 	int err;
 
 	/* Invoke the hook. */
@@ -2822,6 +2888,11 @@ static int call_mmap_prepare(struct mmap_state *map,
 	if (err)
 		return err;
 
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&orig_desc, desc);
+	if (err)
+		return err;
+
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
 	map->vma_flags = desc->vma_flags;
@@ -3457,10 +3528,15 @@ int __vm_munmap(unsigned long start, size_t len, bool unlock)
 int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	unsigned long charged = vma_pages(vma);
+	int err;
 
 	if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
 		return -ENOMEM;
 
+	err = mmap_validate_vma_flags(&vma->flags);
+	if (err)
+		return err;
+
 	if (vma_test(vma, VMA_ACCOUNT_BIT) &&
 	     security_vm_enough_memory_mm(mm, charged))
 		return -ENOMEM;
diff --git a/mm/vma.h b/mm/vma.h
index f15faa83f3d6..89f831080bd7 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -782,14 +782,19 @@ struct vm_area_struct *vm_area_alloc(struct mm_struct *mm);
 struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig);
 void vm_area_free(struct vm_area_struct *vma);
 
-/* vma_exec.c */
 #ifdef CONFIG_MMU
+int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+			  const struct vm_area_desc *desc);
+
+int mmap_hook_validate(unsigned long orig_start, unsigned long orig_end,
+		       const vma_flags_t *orig_flags,
+		       const struct vm_area_struct *vma);
+
+/* vma_exec.c */
 int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 			  unsigned long *top_mem_p);
 int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
-#endif
 
-#ifdef CONFIG_MMU
 /*
  * Denies creating a writable executable mapping or gaining executable permissions.
  *
@@ -838,6 +843,20 @@ static inline bool map_deny_write_exec(const vma_flags_t *old,
 
 	return false;
 }
+#else
+static inline int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+					const struct vm_area_desc *desc)
+{
+	return 0;
+}
+
+static inline int mmap_hook_validate(unsigned long orig_start,
+				     unsigned long orig_end,
+				     const vma_flags_t *orig_flags,
+				     const struct vm_area_struct *vma)
+{
+	return 0;
+}
 #endif
 
 struct vm_area_struct *__install_special_mapping(struct mm_struct *mm,
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 2fd422789717..077df510a311 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1359,13 +1359,23 @@ static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 	return file->f_op->mmap_prepare(desc);
 }
 
+int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+			  const struct vm_area_desc *desc);
+
 static inline int __compat_vma_mmap(struct vm_area_desc *desc,
 		struct vm_area_struct *vma)
 {
+	struct vm_area_desc orig_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&orig_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
+	if (err)
+		return err;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&orig_desc, desc);
 	if (err)
 		return err;
 	/* Update the VMA from the descriptor. */
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index d6136e19a8af..b35279a0ec78 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -329,6 +329,10 @@ static inline void vma_close(struct vm_area_struct *vma)
 {
 }
 
+static inline void zap_vma(struct vm_area_struct *vma)
+{
+}
+
 static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
 	return 0;

-- 
2.55.0


