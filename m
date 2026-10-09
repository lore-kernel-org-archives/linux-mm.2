Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED353CA601F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FEC26B00AC; Fri,  9 Oct 2026 14:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0E86B00AD; Fri,  9 Oct 2026 14:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9B56B00AE; Fri,  9 Oct 2026 14:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C962A6B00AC
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:08:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A779120494
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:08:51 +0000 (UTC)
X-FDA: 85303873662.10.0D2A85B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9731820009
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:08:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RG79TTsX;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569329;
	b=ShC1ZTVR6QDIjT7D7QEZ0Oyekv5jiex44dsNFh+zY5UZhrx5Td8nCzGJl4R4womFtPwvsN
	J2SHYPjQ2XX2PEP4XtXDrEArBzGLyW+hYobGwMlDLBImQP2s2JRhLU1hVvCRbypthyJFxI
	oobb94mW78Tn4SIrwfGFendiW4tKXSs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RG79TTsX;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMtIN+4F9Qb+gUfI9aB/QG5XlGE+8TEC3chxVq3fBvM=;
	b=Rqe8ojY5EvzE05KBA3eVQY95xj4VDe4Xr60+ZA4tatCnskCrrnnPbAT7YmHaOk5g43znE8
	Llc2Wp55CRHpw0H4rdve3Y7Nv8GWuE3tL80XJ2deXBEcDWVeQ9a/s6GSqm8jZw18guJu/N
	dXrL/WMrLdRiZb1t+QHREUioXuctwlE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B0406020C;
	Fri,  9 Oct 2026 18:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8321F00904;
	Fri,  9 Oct 2026 18:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569328;
	bh=GMtIN+4F9Qb+gUfI9aB/QG5XlGE+8TEC3chxVq3fBvM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RG79TTsXtdLFNVIBfTJxF8oLuu+5m7NNZ56wCA57RHrAz6MJ75qyRN5mJCOUUkxgy
	 jbQOyUlzFyiMdDEA2YJb3Gql3kIAq7ri83iTnPxD/rXsuPjDaBsoPHcv+Mcg5yy3pp
	 i/dFx9+dZsKRNmJJH08I/jbObL4QYF4o7512qtve4lYqt+/aSzrla2xDuoWgUrcQd6
	 iRMdACfI86yBKKzR8mB0HRM2q53Cqod73gMqGUu1nLR7rtBem1EMO6HDkuF6kKdWQ2
	 22d8wFTLnY9rHOopat/hNlZpNZNWdxLCE3OpqHg9FemWhtsVIFlDrXcsgeljQBpPTU
	 RQ/zjA1a4Aa0Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:06 +0100
Subject: [PATCH v5 12/38] ALSA: pcm: use vm_insert_page() to map PCM status
 page
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-12-923b70125b1e@kernel.org>
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
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Takashi Iwai <tiwai@suse.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2824; i=ljs@kernel.org;
 h=from:subject:message-id; bh=9ugH4FT9/gtznAktS44gGpUEq4pOXZMJ2VeeFOF3Z44=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sySeVmdcf50TK0o57eC76+W2Sh5z/RiXMolLlTIH
 P9ap+N8RykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACYidZiR4fA3i8qOls98hQcu
 H06vOvDwtH/CO9GL7PNKo3hz2qW2ODMyXCuZGnQj6OVy3Yii6daF179XuJrLFc0O9ej9Zvxy2/9
 XPAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9731820009
X-Rspam-User: 
X-Stat-Signature: nbi37hh6jyr9bpjk4ddyu8rdiy4s83oo
X-HE-Tag: 1791569329-715534
X-HE-Meta: U2FsdGVkX1/k9jCHpKo8LnMT2mg7DOKSrTTh3WSt77rGIgJjhfiesGs/bwZZJ3D9/QPWfNDiy+Xu28ovo8wVAZ9rgfru07ENGNjRXEvAQpSYJxim26b65856er8aqoqi5V6IdSKtE65MClfs0hE3SYriiCAUodSYHcXkA5PBS+U5c3sOgKhYvWSCBvbOQnTMMgQinrZQyaGZv5yDQyvZJ5FonlR9pRfS30BYPd8LCo5pRrWq3vXDG3dlStnA2eWqNQxDLK8rX5aSPBha2mUUVhs2FTpt8lkw1BeqoaL+3ufcSgARw+G3UofYPsHpBTnQu0PktdGwsakuf8pvld+x5Fr62+LwcY6rg70jyU+GdyLyWFi+PzQbIrndnb+w5iik59V/gvc3fPxN29y0cPu+hLemfriF9mDF8rpXHBAYjCNPdTO+XG6czVGX7YmUeKrRMnwGAHBm/KwZY0hMdtO52rxomT8vxm9eV6kADaLvZknDOJuG3g5TPCyrCtqSIxDnbyFY97H7fp5P9Sr7stixe+TixqgbOuU+J9kg+PepZs1acE1QQ8mII9O2x10I7tRdsrq+Af9TfE5uELc4tRawIqqCN9Zk1Rm5Jp3IfaOEki3VgRmZA9C5E15m8p34DbVfxQdIsYkW2q871Dr0KFiewvdGrTQ1OUtLkkZgKdMcWCXFIYkcKG7cQR+O/RxuVdRR0vO/cmEUNzUNvyCRpwy5ll+6GJDvMIU1ivdj2T1gLtntLuPnQXfFQB3pAr/aNNUM1Y/IeCPTO8kq0nONXZh+ZBRftnUJXVXOM8tAWkBUzCCD/jQweGhEeMTYl6IHxPaFolVCKqX/S2b2IuGRIsb9WMVmDAceOoqz+WPWm0jIBKMBI9xJpxquqav5ylbvSJb6djWCfvYs1NuXwrjWiJBqHDhjRL6giGtWA/Z/wscSuqjTeyMQNKKOU5/iu6YlUxjScIgz9oMsgkhKzBpS7u6
 vZkIbKhD
 Ywo4J6wXpu1FT+NEG3Ym1c+wRn8MqP/2N1aebsrfw9sFmkGNd+6Kt739bvLci2kUUe4aw7F/+WGUl7BjqIqMzI1aOzpRUp56TyXXs/G5Zj8Z2Z3hA+clflYeue013JE1MuTsbNwzHWqBiCqlfT90VpbPmAqbPmXG2G9P07mvRn+FR9kv4mugtmT1RJ5v7/NL9zy3kbT+U1vDUxuJjzVIop2yAZdx3b/jiN9NgHe6HRw1KYkI06y4J6fggiio4PQ3wqMMHkGSAo2fuU5tjfBZHOiyeGB91vDnKRZZ2F71fVpTe0zbfdPYiVRGP0XG75l6qpGdBqYDIIRapgJrFW7AjPR6ataQXDcLugAVJFHgoX3E//+eF1V+7/zeYA9mTOYn7jjeX0KSdM874kaZq3vz124y1K7k3QOUQcUg1qgUl2WYX8Ncg15m71QKRgMstZR8glPzuHKaLeIzfNry6Dnzv/27UCpRnwKLYrmJFaKfe8nF0K5eLwyLBVt9xiHKfapxAUKJLpfaz+HYBn+085i6KkcaedQGtNqVft2PJmR2wqDz4AALXAQFx/UiEeO7rMteCj+11N7WM2X1YWX0ngV+2DPY4mzKho80dhXPR0A234Rn27NDMrzHgA/9k14D1ltYz6BIyfe+UNxO1g9AY4NLJTAWp1WpM2n7QGIXpW6XDep8x7nzXbvTQlAvVbXHsBTOdx4sHn3+4PefaouleZEki4EP/q3DuI0pt74Ne1709/bh0HMv9nHs6kwEfLQMpsNXmYxlhXogd2u0V4TTGA7fbzZJi/DjfINLF3MB3AQsc6Gs9DbAevrp4J/w8s/vVy94k2ua3Xn1lAo7StrTsQhPfcWBYVaM+2PQ8docea25tU2tLoCClD449B7BZJ86DDid8c3cjD1ii/TSdRkBgdjsms34xRdK5POyUfR/3aUV81+O7JHb/hpWkIew8arcl0CWS1FA28zrZQHvbkTbR8peduBJRavZ5
 b3rZH/+I
 7oitniYSvCZigWdQFmYmXtM76YMdV5W2ZJs/1yxt480qa7Ext0abFDVCiq0ZQkP3CWki+aYurJHfanmdnBIfTsmC/Rkd38UhSwLw9cyve8TEX8T+8TXIHmNJSXsUZAlwXSv+r9Er4DtmE1+q8P904B7fnbRH1OTMf4FUX9LPzeF7KINMC7uEan4nuqaeewgUKqrJPcWcax38RSOQNdjVqG9SmIU9nvZF30xpQDycMCvvuo+TCinvpCtay76DDJUwvLGaXHBzPPto8FRcV93A0iHIh9d9Rgd+r1d4YPJ6RKBL05JSBaEzgq7MqClY1JKDu9iNcUWSrYOqwV2mrKNBWqdP5XQ5CG1scNA5gMvKc6Evf218oYBdCe8OQP/2uikDrpMSPLnEbcpLDT8ffhw6vu26VOxll9QMJre3Gp0M19mwcwexPVzdAqvL6RUoKvtxiptAtlQyahcFydKJUeo1bexqXrNCrSMBNqzlS4CdMoHrxmK5MHTi0p38O/iLmcYPNte5dTgVth8uhOHKESamCWAHZOliJ1bpc1ROzMPnE88qnPf7Rmyr15pqC72kFFA8lcckLpqlmG+LIp1A64LbKrSCR+9In8qGsEkVg4sFpljLkrnJrwcvsQ+JfmqPuEOC9vSfajXgHn4TMys1XpYXuOIIEE+b1cVA2OrtJLGcn49gpm0jFnNtA8MqIxwkIpWmDOAE9hb1kYHA43byQY1AaydvBmwp+oMJ09QZYw2vtymQpIb+bFHx+eGEa8VIjrTR33fwCMbTuCBD9rh9QOsZ6c5mPGnX9P4hUsVVcFmeQ2Igo0l3Oo7QKXHXvViyjn0TxPi+T45rNVdrN82b6fdhunvEN4gXYuHl8TnuaJHN3tCJSPjrAGbB9GXj23lglRS1AUb8uMc5UdITKM5X7AE0+b94sbTM47r8Gs5Hk5wre25FouIpw95/FnIE/vhO+vmftgZyd2xEgVNUgFOw/Gw83iRSv6UyW
 0fdSszqI
 SZJCKDUQNbFoYBqn/XtmD7QGY2Q+wNB4Pu8vqVxHSRQsO4SalsX558YFfr31fx/Dscgn2MUg254Hr5bpivf9ohOwBtJfq8NcydbuayuJJU8bCaZQ1pTUvXJF16fR5Cjv0N0vGjJwIcFeDQLbulrAi0cVMNOTIpwcsnUV1zIPfLfqadi6O3Gmgtqhe0LkyMIj0rA3fSUgGEiwIlyUJm0wHKcpttiOpUHD3d1LS9rEdddFoSjMv5fciJuGiuGoZMU1BwOuUVUJO9fKeWwe+RQDMP4F1ZDi6P8Xwjlb34jUazzv4tS9gQa/WTJDd5NMed/UwIKiX5z67pkIlaaiGddtE9BIjVOIcqys47ZTjJy0sYYvE15WhZzLL3amXf8ll580UmzvZ8kQWgkEyMGelrqojPQRExvpayOwUX0f57DaAcMvZYmz4PPfwcuHt+Ll6uKqveIYqKICJvJhEYWLwSVe4CuNWTkekF284ScsgxVW4sMpbOaM7/6ioCWJtLZEwCMdYygGJRKcCXXH/KxXcTej0UEms2sSqhgAIxw5yX8t1mkT8Gy+nU0UBGU5XeBwS95kUjnJ253ZINUnu+O7NAaTxJb40AYp2O6z385pQzjFqk+OJnA7o1qbPxsPp6RPXP8GHp6A7k0TLAFXFRtjX6XHRORuaLRAA/IFWPJXSlTPwybMi2bGs/U/TgSNtqOrW8STvt+FrDTd0+d0dGWFZTSx+sxkZkUp2n5mVtbWeSOyM/cM1l7defsE+wgVnO5q480iMgmKAUpXh9VQ65CPJqsAo/NIEmMwQi3bSl1C9Z5iuCDwRX+jOM15CSx5heH46gmwtcjNTMrb1KzBGiuSxm5mQe/B8b4D9NpzDrPIKRwYCU9tSH2BvQ8PGfH6+A415hYj5yiiSsNnMYaDii4Lz3m90w+CKA+UFkrjG6TwSrb8d6ZHJef/YYWIPouAwt3CpGo/+2G/cnEQPgP0zOJBhrwFWT//GwDXI
 IQ/uXBtE
 9mc4/pnvrDVpLEeGxW0ClGF2t5lliq7V2sXzVXuhoxuYmrRADMMteBuy4X1irhTE2/s23aasp0r8o+aFyYOYbjnOOMfGYjwDxW0Z0vKGsfBOjiXdjnBnyUO/cq77e/JDBEVbQ/UTbGjegRfBp1SlgGJEV6V1TBzt/+ZYFFtrTpfwKXEBzXyoT9FFcxqaAYJKZ8agmefZGdzkfuoq5GocDfrxSMO944go/CPddY3ANyco3oMWe6D5VdV91hcz6jZ0YKLkPlmztUb1jVGE6hbA0PqOpOwD/4cWpMMYHw9rDDUoKcRk+6V3J0Kh33z7kVpAPEERXfC43w0CwgrpfjwF/iBnUJaC21jV+xg41SQB+IBg==
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
VM_MAYWRITE, so it must not be mm-managed; the control page mapping remains
writable and is left fault-based.

The assumption is made that the struct pcm_mmap_status structure is at most
a page in size, which is asserted as a build bug.

This is safe to assume, as the size of the structure is 56 bytes at most.

Acked-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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


