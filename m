Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C48ECA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4506B009D; Sat,  3 Oct 2026 12:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564836B009E; Sat,  3 Oct 2026 12:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DDF66B009F; Sat,  3 Oct 2026 12:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13D7E6B009D
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:34:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9EFCC409A2
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:34:55 +0000 (UTC)
X-FDA: 85281864150.04.3B6685E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C88AA180005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:34:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y4CQZxo1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045293;
	b=Yb90zeLJZc/0A7vg/lqujokrQBomm9u6gjKcqQBOHrO7XRfNzwZ+OtqwqF0fLHSie8Cmzg
	YIKjYkUJce0XRconGhmE+kfOBSuFNs0DWD96KT4E2yd+VGfoyqodLj84oTohkACt6gUyor
	pYj89cJnOIOpS3Fr4q7pgPvy6rU4dk8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y4CQZxo1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAzG9Wth1XJ2c0bU3DI60XqRT1mNgvn5WEld38uFlsY=;
	b=RAq4NUGwvvE5ovzKu7MeL/DNnyZsLTaMSQZMk7VCqO/X7ayad+THHRFRXt1/ojSyC7Ygz2
	O6tYuEgDIkiMyVAvCl1U1mXOVA32BjDNVPHqGJ2Pa3oUk3iQYkhOXV1psVItZAW98TfJOD
	7nT78fIZAyS1JnuaZvRL4JIkmh6v/PI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F2201409B7;
	Sat,  3 Oct 2026 16:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60471F008A0;
	Sat,  3 Oct 2026 16:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045292;
	bh=SAzG9Wth1XJ2c0bU3DI60XqRT1mNgvn5WEld38uFlsY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Y4CQZxo1BtJ0+b+5nvGcdGcmA4mnH3w+KvJWcRsFOv5Qb1wcxR7CNb1bTkFS59HOZ
	 7HF0P8fPX9XBVqCA/3u6hoUPjBOYSJHeC7nDDJVAWKlTQQRWGCw9USsEx/zu35OKsR
	 PvvCt7RljPuNCNIC4Qo2mX2PY6J6fBGxt8L728+PUVxvb/hujYkxyUlK/F4mD7dX0S
	 P/AS0RConAL5znw1iR43LSCLAa57KlHUE7Twxzyf0SJSyY65jP2BKwWdxmDgJZbJ3q
	 8mKn8fZ0zJZpr/nvxlIQb3dy/paAsAPfyCwRmBZ7Aqq3eO9G1AhSk65RWyjGC4ZoUz
	 GtOYV9o+9tZKg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:36 +0100
Subject: [PATCH v4 05/38] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-5-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2708; i=ljs@kernel.org;
 h=from:subject:message-id; bh=W5EJA/cmsVT7jDTw6eYY8+j+S742rFhYZzwOfLirwec=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6qkrnTC6l3f3qMKHbUcOZHfes3wbtXo1R09VgSdbm
 /NFFpe7HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhI1R6GvxKLbxU+dbp/frmO
 6/N7PvnKOwI3bLssz/e560cDh2zxwmSG/x6dhz5Nkdfd1jbhavufGYESxrmBvgbpZQHhLSfb2R2
 nMQAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: 4dqtwbsbyxedspn43dwfiwmfwfrt4nk7
X-Rspam-User: 
X-Rspamd-Queue-Id: C88AA180005
X-HE-Tag: 1791045293-969795
X-HE-Meta: U2FsdGVkX19OeMzZawsjpm3GvTFInBQhiJezInPlRA+u8VPHwCIgNxOUApjSg1p8CpO0B4zlUBfdUK+5OM+PIHtlnOVguRVQ3mVYV4rsfd+2zaNk0La9G0AT9UIyAOLLM2jEi9eupE86J0Y/L32t955qJ7OHIwt/Qck6W7a7C3GSJ98cvjOOP4pUm6MRtPF854W427A7u2F7/7a1DOBVeiUo1cjE2kmKMkSktQdrbcFM5+ys2p1tFB156hM9Kr2dt8O4Qa5a8+LadaYaWw3jOHO/wZdHmTDUxg+RbjfSzic6whmQIbD7qlQ3E5CHcv6R51/oGeon65PARALGqXnBDnoED0k9pqu9PtNUloUI9d4DqiKOJuYr7iFTqndVEN3fmd0WhGggAFTrelYFQcvz9TQpvnoCU0br69fSGUayn2jSqa6YoqJnndVyIZN8dt6POKIFzPDGOj+nuU6dA+g63Mr18IAJ+zfocGmsvRoogrM6nNsX7HNjtVa0Jkaa/8OxI7yV9HIJ7PzOdms5oxgaFObVLEfcX7e85KaposnKL1WqXlUrHZmqYjxsLwAlqxcsO4F/cHvTBbGvyUJWbzb5N9JWgdH+krBlorVxdIIptJMlCCPqDEthcxz/p+ykVnz/V9TqkBkLV9San2y8Kajk+Q7eOsewyeUKR+Hag+g49QxxhaQ4vgW1RF47iQab2SvHpYFD7f0KMAZcn4ZE/VZIYT+rSrga5ZN569ttIjTALXO46Kb0HoF74499IdXMle8ZDFwWxHjcKFWqXu6g68MFDiuBuQsAy8oznZrhplhhlaJ9RznmXH5xk0X3yopMsAd2PfLAUOpuzr1A4ffob11OSSQLQqW6BI9CQHdMIy1twM93eUt2acIH+d5ugmHROKM3tEzaPm5OlBKLu6Bmd8r3eLaXVwEyAmGBlqnhzTJfgUvbH7L7vyYHF1AXsHNlHxdqgWfDG0LMgcIJx9k63xw
 zjtdQT57
 Gqunhfg3knS7ZXbJFp8JuTc8QVJ7Nvywc/yM8aJWC2goET9bEXAx235ohMy+U+d8Uhr/wC6TQg54PkwAG6UwzKupdTZKwZh8cakjVaDUMeZnRt7LmjnGoCN9L2VoXzm0MQdd8CGWMs72IKlfsbQL+CrdxNqbY6ZNzKCHJEpPNnTnWqOS2j7Ukz039fPRVtcNHUkvQ6a6oJq+eF+oRQ8/thG8ZmbaaOYI6aibYucYam/65I5UpEfbb+c1ghCK0oB74ldKnGscDBKH+LDKGMdiXVj5rRfJTQxJL7I0uCPkfVlkaCNosHGXgopSjBRtVmIsleNDF2YVlUHo1PHOrmkJGOmtyJZhwRzKwHnsXajTpQtUUCwhB/MzTdZ2E2YaCztV++h0UHpSmW1ecJm20qhcvZHUJaGW17dylmK4qdTI7Esv8MWCpXrNJyMBVnXMkqm8Zr9tfTYMGBsf9tCZdSwAOhk+VswIp+tZq11jfS0PiwZyXuSrOv22/F9sWKYPtIoMOCAI5k8Pt0aVuLOgbNSBodq6L+OTfIeLGwdhnjM5E+nd/6jtl1PWgh3LzJAqFWggnkfYMCZoixySsdTi1zADwPBRdj9Bbb7AF+9msep2+IfPxFpn4zbol0iR4zkQcikykfQzLd8C9sXxGXLgMDxR+OlzM27AMGyRu62w8Bhr+MowmvLJQPVyvUsIA9KV984/xqd87FLnNWLWNzx4WoUo2Jx73CnnndyAR45MzQIO+jXBDoaQBYcBHJ4EWNEeseiEjGmHYBKMc+Whz9Eqfu9Gfh4lPiyTb+V3kJbfJAS7N6pzr28rCjP2rnFLUXMbIc+0DfMdgTx7NACe6MysldumXyVy5seRJZKz7/OFOzidYvxkyj9iudtm4uYZ9Nd8hjmgBWxfKniEo6B+GgKTm2xvpmg9Xs//rgVPM3MMVv//P2IciAp9SGcWgoqna06hr7FyJC9ExhmEElcIJcCQW8M465qf8iGyj
 Bw9QHVTi
 EmnJHKXGEic7PdRpmDsyAEEFP+oAoIecY/7YM7MYvVFOirGBtHCzEcSNHa3/a39kXZf0zv2pRxiVqSG8BBfykw4LkQoPJmscX2GfkMephZImjoYoP0kzZ+bfAU5jdLVvqVXbOtaskPGlFseQhFefjEX1BYI9z46LzXu2Ui3E77AddLAad26AZW5x/mtt8J//qCr7gQ0Df4s3z5tQ0dHcy5teq4SVMMqIdIJDsukdKExRegwJsAowCEY2ygwTbK7XE1/hHWGukvKVOmclBeLk4VkWUqD99GRJB/TXY+4x1OFDnIaWRLKPJDC8VLGs9CWi9MrEtUenp2USLdtV71DQyu0pMlfm7W9Ugn7lUa44A+C+OUQw7V5CxUQ5DdpwRrvVqAooZ3S74+tC5Xe+1M0W6Hunc6WBNVEYtMFLFUIiuok+CnDd2AvgolIwNinnixRALUCHdsOc15achrg3UuBpOannjZwGT0dax3nt+FF6sx/7PfFRIxZvBp9acTTAiCgvMvdpDJxhE00tvnUTMmRX0orlQtReNAgTcGpz1flpnvwg7mM2TdwzE+MEVuJFyuzBf2tnybrb01ceMHyV3mmwEsqL/ihrv/8gjyqJlwGu7ILzzSgDCcW4El1PkN7tGz3cvG9UsmDD7iNkgW11289NblgesePJ0TI6zz7pzvNKEPl+bGNoMGBB7VROyzLvsfJhSavvJLGl0GUFtECvyYSz+d5YS+1Sea12bOXRJAzcS0aUjGeZ511p6cvqJVpc/P2dtqHyqCWUUTSsR1CkjMS+zkFEIGXD/ZDGIUuirIYk2lk22PeBOJ7LilGcc3mlAScUq8scTmgU4ey1fAtkBc5V9gO39RSloGzynGkY9xIfR3MvKOktZ+JnKQibOg3t7RrN1Ubg7+/MczVH+1M0hO9dIug4rHrPzHs/+SONju2Z2250DyqGlr3JNEWTF4CGdPgORyAUjC7RtZ/0SmfPQS/F7gX/N9myA
 14cFM/g5
 CS/W0QNDVbeEBzj2WrQMQyWQwQy+gD3SvWYakzLK/drYPYC/lxjwWwux5dQryXkrOH1fxIQWiTK55L6wPvvVbJW4Q8N4PVYlL+R/oXMfMW03XGtFpRUebRciUa4+ECR68Sc7mqmRJU5fQkNqvv9uJnGoD25hf+pM8Wu9NF7xT4THPlffxuFTywvvVzVp1HTYJLptNeuXqCpZYpRGrH09Ize6sa5ZMnhBwMJvH1ITXURpLd7s80FExZf7HMjZsJPc5/0Byry5V9xshEtZRONbxnLOsp2cXoR7aeuqXlyX5//ZBtx/kYbsXhIFQ2XA+tHNQUKf74w5pRtX5HKGrhFup3ZrCI2UoS7o24xWyeMItU4AYaaSmavOdICfpMT/4CPa8n6u+x70CBGQ/wWnTmV9byyOZwpXP+8nh3GERda7RiYDEpLmGx8+yYKjKX3eg5p//0cKkUmR1/njW/6dQkv5DmLAcFCAlTlnD2GKCbhlA/XuSsNktGykf3eInMPgpeQDb2u5euODYLn8asezrvND6T2ckdCjNzdpr+jDwtEfJLdu4mp9gvhYEGShop6HWTAxpH692kiWKrzGKJol3Ax2LbRzEtBIjWnTpBwY8Lqh46eiUyhZN1Qsjdj4GpBt+rh97PoAhx5p7rkqyGs1ae5F+acxV/vHtvKSf81jYwjYtINLXTMvV/wVJ8qyr1NZJfkLAOeHoP2jxjJQtYQgnZkHnzaBXyuWzxx9TtcML4ZY+JPCDQWPlhR9xweyskyyitqXMFScHvk1FfFDaIFvb+CPCQI/mrk2EgC0/U+VtN6DBtW5q7niRrtVYocSSU9wGxonl2OMxFnUPqiJMvPan/nQM/fqL7T6dugXxgyVS8zX7uOQ7c/tx8uP3OF8eJ0F6l7+M5aGeN6DbL786jodsgDp4U2GETnkwYGQ67YTTRFgAEKSkYUUBwwYRWnJSM73HQZ8alPVMzzY2Z0zdaCght8U4Fmg/oaut
 VhVkdh8T
 I3AuISdBTZ5CtVVko3HLlC87Y+BxH9MImrjtbXwlktAwxiQvzoP6hEvnKJvAlAKqqCEfOc8NOpuODFhpdaprFilXmZHwRMBWjrIVW2p583g2XhdbCPRH7YMLvyw7FslKjZrBiUUkCr8cjbG4G4UQYpdcnV6dcKY+Zkk5QYmc6QD1P16AW9VUc47v86X7AKaGky6f7tvuyZ8AL8fxWtDDjUESN0nKGjzcoURKvJV2L8Ay9459zBh8Eo337A0H+qklGp932lnmaBjKbiFAsu0HMVBJUHf8zZfD8+/mJiX7mQ/9IzeaOHXG727gW0HVc9VPRJeYAsiifFr/mAVgHpVkC8vCmd65hc7VmWzbwN/pjF86n0/iEHA6OiPYndR/70a3ruISY7LOyOxIoJb/966c4+vCPsMhsrqejvI8HUO9ceZepSotMOlA4U0IszzCPza2I=
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


