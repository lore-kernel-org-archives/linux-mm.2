Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94997CC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7789A6B0099; Tue, 13 Oct 2026 11:26:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 729A56B009B; Tue, 13 Oct 2026 11:26:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A666B00E2; Tue, 13 Oct 2026 11:26:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C49A6B0099
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:26:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8EAA160D05
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:26:00 +0000 (UTC)
X-FDA: 85317978480.03.152FDB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C2ACE2000C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:25:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YMHlsDIY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905158;
	b=xDrNmZNSRIKETvN9zpn55t3e/uVLoRnDPAXxEYWHFPghLLabzXkTwCR9kLzrO/sd26Iviw
	4uW8aYSDbL2+NdUGtsTcowxvHk7jN+SYLfFbsmoOBwnWGbC1puM+RatOKGhf+hQVgYM9Dg
	1WPPMJ1I8+cMShlybx+KRodO06ARhtI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YMHlsDIY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=brSHanJN25qJ54Niea2K3A3DIc/HKTRx7GaGCKmRkSY=;
	b=IRYyilgxCf8/W4/viSgbEQot930Jn8Gt1U9hCEAnh/vuJaCjU28iXpsoErTBOEEPp8P8hx
	4laLptf9kxzLaQiWv5xZw8d9Gp0NyYjQ2Kg2B1HLtrO5GZETaQU88IKJd/aZSlCbZBqdql
	pTBaM6FYkIxz4zpb1VCiXYunIEHpGX8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CBC6A435C0;
	Tue, 13 Oct 2026 15:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C948B1F00893;
	Tue, 13 Oct 2026 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905157;
	bh=brSHanJN25qJ54Niea2K3A3DIc/HKTRx7GaGCKmRkSY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YMHlsDIYA6c+rskCJjZiIz071UzQ0h5CHw7Oa0sGmgBzY3Sd/UCi9xHgKJsA4Rrmw
	 C9aAZ6VmbE+QMPfKIU+++8LDbRhtx95pfES908caFgmMHtj1a7HQBt07rM1S3509XA
	 8tkNvD9X+sj40UXprK/1HZJ297bIA1tbtS658KoM6TMH9CsAuEa7Fw47+MwXt4y5zR
	 QwUgLqrEZzBrpUFuHd2WHcD4SKbnK8GFQemshFGcwB2X2W3UbM6HtZ0y9p+AVdnRt0
	 fnasxZejhYeM3jJmmT7jJuYNaJwgZ8OjEN9GonJFuJH8K3NmQc7xeBT5DqDaGbLlTV
	 +NpMPo9xhuHUw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:18 +0100
Subject: [PATCH v6 38/39] fuse: dax: do not set VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-38-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1534; i=ljs@kernel.org;
 h=from:subject:message-id; bh=tfz3ccYwKEyTRVC6abtstchqWCa1ts0/TLS9J4UHnV4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZydtu2sxIVFl3ffj4h7f3LSy6/Nc2uWt62vzll1t
 tY3a5/SnI5SFgYxLgZZMUWW51/E9weJhM3rvODvBjOHlQlkCAMXpwBMhCOHkeH9Y+ZdmgmzPs72
 KFNtPdjOn+kt90Cqdoahmdem+LLIyh5GhnX5HCp7vC5UL3q4Vv/8ze1nHydNs876IsGmNn0yn/S
 bA+wA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 6a3953kcea87nwjb5dn6bnmciiys3rib
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C2ACE2000C
X-HE-Tag: 1791905158-391436
X-HE-Meta: U2FsdGVkX19wddu04mQV9zjXAblfdMP4+DLIi776bx5dShL6Cn1klDi90Vs/xsjKFYAYUomWTxuc8TMfDmwpUHGm50in1L3goip168DTOq7pCgW510KjPiSiNsPaU7Syi5FlkVIIWKZvCMQS9Ne+ZglHIO+EvUkOvzniPfrODrPdcylxsQIQXMdh7bXeBnx4tuF8lEPKhXJPY/4pghkqMir6whoP/Vqaj0tStAwbASR8IJZKrE0+fHfng15pzDoWi+ofCpkhgwzh9ngnYct0hU7yV3jn+LdEutYtDPZU6Lsga6qwoTqnL1pMrw+vALwzH9NG5exlAmB3bOODQ5yQxDWm5S57ZAwKBaKkbstDS3970b0IyypTbbppybJeYDtseEPryDn9wAqp/t0VyaA44cV5I7+o3p0nyJ4sWth/ImGWdRXxZu6LroBdZz0aIgidfh3hMZFjINFquCAjiYlFfUVIIW6MKLaUyI03ELI4kk8Zw4lciasuWxK1iiijw0yQuZ74jPuYriH/1p+9E3+5vT1t26QoED4Ey3YHuPE2+yXoDZ1wbNkaU4VVUunbihTRp0j4PGGU5wS2HSikXGjFAR9ICQeqo2frRB5owy9BirwWCW7hvL+k8pLBIMy2L/fqzaa1+dQBatQfB5xtmzG+1i2vBE9Gjh1aZoetIo7QocqntDOCQv6DoO6zBVS9ohsO7mda+c7E2G9lWtfh6CnyppotxekJzVGwbMLA7nIwkUVM0phczT3Z1f9i/kzyLcNtE0SLWvw1rw+l6DvVPFWH7K/uuuF4+4HkjCv2dcWSlX1PSgwtQTXgtQ15Aw6RGJa18plGkCnRmG02kry91D84lkMGDYg1iM7JSs7+iUN6Q1f/k2k2aPCNMwCVciwQOFqcx6JxyBsGqNe/5pT+0UQ5brVZKXheGg74/5ztpriIbPju7ulo99jBIYcSAPbMBsGPx+a40e+BBjF+N7E1FWG
 EEuJz3jW
 Ehlig5xXQsTha+u88DeUKLH5NsWdRJ/X7lXpg2IngynWGLxwimdpuKLLTQB/yVciB0vh6f0e/eyE7Fs1/7BwMiJi1p0sGYDcGlLETCE56NqBAWSHI53Ti/xQNl2reHZ5prWvbMOTBn0FJmfPRLcgkQ7RPBDCSMyd7WdMtqWsMCQYKKbE+usjPQIIc3SW8mhALDS1ZM7H1jTzBMu5C1UMxFgUibrdO/mDN59v8ZrmnzjSUegJd+S586CK4hAYn3jPMoMJj/pW7P37wagVAiDFOLM/rcI2aPV9eDEZtSbsA8fdVf26ievur78TikfwwppHdTCyo1uQJjOxQg4kqWTT6TxuNa6WGwt8RqlK+wqPW4u8tdiEw95c1+RV+zEtPNrY6HGFLRFCl3TYArwkMWfMDYNuUC/vJZJwMkJo3BsdklOhFZ5dhr+CgD3dsDy6LZh2L2C5Ur/2iTnVkzGsb//mwKsbz5fHfWvA8b9BtmVZAKCu22VkzdttHdnd5Bd03i8EaLwXHo2qyzwD/hRiJSvOGPQLOYShDX1+z+r4A0EI8KQNxN1kijXV1kwzN4q/ADsYnySaxrutiQXHBYwAyFpufokOQeTOr/6eoeFpBMHQX/GOKKKWefFL3vNqCKI9rTrLE+VnXQO4/kSfKfBoUId/Hq8HVOAhYaVmd9H+HNpdiZovyZc8iySJ0IwzswoLSP50qVVmSgGQDWvC0dOmqb5qBH/9QIzCk32dhZtPrs6KmrgC+bvXZvS+913muPuE7WFoInBwhht8wJf0DcBp8FMFfi+NgWYImv9J+ILxwKABxFMJTlgEHEfl2CyPFLlGsQkNMs1c68ULdnu3pwaJwJOXvQovqoEE7UqLQhmhNFyqvWCELbTwGH5ybh2Jfz40VwIuMbMVnIjWJDwTI2/eJDkmRlGffbgHLtoBmuA3APGDXNo9Nvm422AZdE1HFRd3FK9cDmmqAYfZ0KgpqEzCaXwKAfU3gStNr
 Weea6vlP
 XuzZxvJIarijm+Sc0OxRrL+2MlmXxiYN9+WYqoVEkUbck4DoGfVn2VjlFeKFO5lcS+sZUHFgJdX8Rif05oFfIo0UXAUD9gvT90zir7j6YglhauWq4/IR4ie1B1eJIZ8hDpby8yb6PJz3hQjjHfVirlrAh2q2f3dt2RDRJzlFNtL304u2sd0pH7+nULvl58YDc9JJKX62s6Rp7bHAZhcFPOPfFOiseH28ah/9HBxQlDLm+YKKpVMuzvV5+niJW130bIVWpZmSGdE63OYCqr0/+u6Bi/8LtfSaX7umhRNiz6DAWtZp9SFLqmfqFhkKpwsvNMYcOT0u5+ErThKwKpBYs8we2J5s1aNWGXo9pFSM23tQJbUZkJ7ueH4hz93tw9n3p4VCc4l40X9n7nlQrjhMxkktAFgvU/rJWMa/Y0RbhqAfOS2OYPYmUo6Zy4fA1C7UB5+rRS8ETk8wrEhklsiFhwKvfAvXMqZ/efCUaw9J2JqJoTvmraHA+oQEjVANRyzuPSJlUx/u9CInjok5Kr/3pyoTzBF/eESvm1msx1T6iTJHUNRJN/jx/WOgMALsXMuFabyI4SPIJEX/2EOEnZhqDEdhNyjjXGQb/p9UmxDeIu47qu4HSNvueo2LJ4aVNdgoKAs6idJzwqnEmDHR1/EHhJjxxHU12MEN+ZYa5FvapTlTzjsnFyRu3oBudxZQaN/QdfewcAHKWhOmPxSAANIIKnOJ2mdecwU7wFCFGUV3ptPrhEFWI/ti88IM67tWVw7jOVXBxDK3hcCIZkxCUyhokPm9H4gagPJxUDK1krFm07eYsH7Awae7pd/1qOtTA8Cz5Wo/mPcJdsomtKsFfE+nnm0J4665rGW6ul+TMYTH80jIHQ0oDBfPwLk7e26ugNq2c4gd3b5iFm6wh9H4kLpBnkfP4orKVanNfTVjmmhnAd8pFjH3lsVFyhAjxfuTxHzzECyXvas6MCYM5yFx0s9bnDTGOezyP
 +Ud9mtEy
 YWGPI3Snwl/mYm/XZqLK06Q8xl9jXhY1B3RaK9lniA05JfS1cIeH3nAlGJGLSIqNJdEMOjAEZulUJjDaPKNjKy0PwaVjBSzBU38arBj+UQ2w1NjhGs0+QgeAs67I8WcJ0jevAtEhSgMLnQSdLzX2fnamENRzNPKGkC/q7pvlEpthKQoF02FyceWmCiq4uZg9Zzn2BeVtW899kFM7qSW3clsQJDnI9h1FqRIGGFF6AmEfyWEc7LYWakFPCAyw2i2+z3X+F1GuDqxhbeDd15PvrXI2dCLB/adb9T/Ys5mjqLB2Y42P80adfcDz0Qj0+Nssq1hqrv5FMLG2tLW5zJb7Sl5Mc3e4cpkp/cVESo3UBqvMEi1XFP9pD79lYuXuqrr7wLplu1bNA2pmGMuGPEbIuK1n3MK90Hl3XZYxmwiC/aSoysNhCcOsLS44Bjl04chAxzbIblVaCn6ZWkCXId03HyhE+VjS1rD5O9VgT3SOr7mhnqKE0bbU3fhNlXNZ93dLy1ngFrPY1cMKbQuID0qc0tZAHSgT7mAF6bBa3vOp1clr/bygs4s7N/vUEEpujRqCVK3EYP9+fPtoZBYhfgW7qb8ZCAt+KaqreAEoxf24wOI5uRyaj0g5RE0Cz3OwgMQtnn1sgybb7zuSAag8rS+cQJS27l8J6JbevwhAXbrp6HzSxVC3TXMfd01qW0QPAHyx/6jSgiJAKNbIrMn1UpwchwijiIxAEcIMNGfHHBL9rSUxQbcDb+bWn/ZX3PwQghqIMbsfoObQM4820ZQl1y54E9lL8m8wZHRDPZrusnhOC37YEI6TC8g4cMm7njYMycRsPyNEXN71D0BHViU/k89DN/sWR0Po1DtwlmFTT0KIr/75jYL19Qnr2eWY/T8BXNoQ6aREPnMonZpVizbS9yUHqtBxzLvZLUN7zGEIIRxWpnYNWXjZKOI2SrznxEt17AJHzbBqOmv8CBTmTIi0EVBGcRlwyMdJl
 H7lZCvpB
 UhSwIDzJLffDUboU8tyJBThTwkRZSj3pO++ywW5MIg5tGaX2cqMPYutbWqT17vMApAGNnssuHmG/9Hp2IXplo1Vbaux/DOEBSMP28/6umaDCXZJlbpo4VpnqPWHBYiSr1l3fVxldmpEE0kq90INyjjaykdQEJRVUglVREIRdPiZVv3UgqFS4ZlvbBRfl4Wb5sa2enFy9cda6EC78ddHzzJR3uxhkczC1o7Ho5d+oodXrIZzUaKnuS5wYtxbNTwHqWDXZQbB5ya+ChFZwVT/pamPmKBWvVHAvCDj3o2paBTVxJ75hRNxNrRLlovjSZCTBQgibl5DWL+4xCwT5qtQRE/UtMNV4GPbK56+MuMJW4EdYrGE35FfXi6Kpsa91sW8g4azwvxdrtl3eJYoA0D8GOp7I4D1GYgYtz9bhSTkRAvMwB/BbRlL0P58jMQuk1crHYznkgY5a1RIg==
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


