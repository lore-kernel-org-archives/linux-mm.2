Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4F5CC79FAE
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:18:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A826B00AF; Tue,  8 Sep 2026 16:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72526B00B6; Tue,  8 Sep 2026 16:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B036B00BE; Tue,  8 Sep 2026 16:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95D456B00AF
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:18:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 286861A07C5
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:18:42 +0000 (UTC)
X-FDA: 85191708084.11.C016C51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 679A940007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:18:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cyp8Sc1T;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3TWxBMlwlg/BAGS9Nv7Cc0TGFLPZ6nzTJBsPZVVy/8=;
	b=DxGsnWDscOtAiedha2sdZYK553KEKM3xmqqEC5r4qo75qvl8r+vhcSJbap3NtXTZIv9gh8
	iHshWJlvzNzb11WxYYnShkrtwVLoMqqKXR5ZfoyKwfWuoTuLd15ylmS7r9MXzJAc1bonFn
	u+elW2gC4HbQeG4OSkoRqiNvniQIm7k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898720;
	b=zfa81Le40KVg/+UBxZKitMQJVc3Q5WvN7l8mJUmv3lXEcbRfqiybiI09ZVxb83g5tM38Ic
	IbDXAV/pM47ZfEnP3peDSizcv0PHRMaxLgKbShOmT4jt1tm8G1OnOwj3l1QSgiiaLVuZyS
	A3sySpQvkHgvswwHcTyZAcq2AHhIcI4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cyp8Sc1T;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E9041601DE;
	Tue,  8 Sep 2026 20:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3E21F00A3A;
	Tue,  8 Sep 2026 20:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898719;
	bh=d3TWxBMlwlg/BAGS9Nv7Cc0TGFLPZ6nzTJBsPZVVy/8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Cyp8Sc1T+RmXSRizmkCM77apMQ0zY67JT8PF0wNp+pLX/z82E2W5ee+eDvgVXCusm
	 s4L6sxsPR4WIGnduLmy9OYvIhF6a9Yy1aQffhmAP3svFk6A4xtcPfq2fDY2B9MH+Cb
	 G1uQaKSN8TLLwwUevyOv7FxPFFpcDwzpMHXHu4DbI0KiLL7fZWcf5YKraJLNTekDMv
	 oRsgWuiMY39VZBg64m6WyhvgH1c9LP2WwMBxUjsDBNlabsYbJgBFTC5MJEUPnyoE24
	 fRYKpSAQlZc16KBFKiPGQQgx/o0ZXMwBrz89FLdq8WhNlMVZJooriOisB+XjcXfMhw
	 3K0sNcj35wU1Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:38 +0100
Subject: [PATCH 34/39] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-34-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
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
 Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1176; i=ljs@kernel.org;
 h=from:subject:message-id; bh=wg6tA2nn+6f1lbuGoW1F+V8Pi2Wvdfqvh3DOyGzlDxk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG6LffC5V7Do08lrkz51pDevaTzF1aQZfHZqXTffp
 NUblpw931HKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJfGpiZFhRphmg+WLxFNNF
 nQLnFdol3sxcKrh8QcHpT88XiM09bS/B8N//+Yk9jk/Xawtt9V6/6N7/Jw8XutlMlTh0yfnBm92
 Pzq3iBgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 98fbtsoabz7t1oafjfrobjxhru8zz69m
X-Rspam-User: 
X-Rspamd-Queue-Id: 679A940007
X-Rspamd-Server: rspam03
X-HE-Tag: 1788898720-699586
X-HE-Meta: U2FsdGVkX18xc/44lfvU78ItMZCVrtoJG07xsO2AmKJIThpEVi0j165dC6dTrOjz7qiokPgVRS40dCrhnXAeRb8uS242ZiEjZbD2ti3NwE9kfC0zl/R9YnvY9mT5Hv/cZzU/e6EYzo0l2PqZqrPQDSBjj/6YfghzSYQGGKP/qNxXfe0B8bxnAbdW9vD0tB7HtAebjd9wxgivy77Fmrrjx5cyxtq8hPuNFUV756j2hpDl93c6SS7zfv/L04MytubLyB4puan9IJooN17KWsxPKRAayn6w1um3RKGu85CrLBHA9WOYTmm6N/IadncR4OZFQEPFxOyCwZZA0KuaOlyZxcnxT+eKfUX14WQt88pjDru1F/VmJCpMCfETq8pRI93e/bgl2PLtDBCC92usv5+kTKzOIUKcfl1th70DOYHLy+ZoNBR96uP3IscYkwoihoV5Xp7JMcam0x6tSf24++fz4qvjIeS8oYnNJ6E1a4MnbbIELpRM0eXEGhTOAOMXEPLNNOvLw6+BTd40+OOB4+CrsU72JzAUon+ezCWbSfHEudpToLgYVkmEafK8dP8mD/QbLiQV0vb9YiXqQIwshHFaDqOJiIjm1zIpgUJt9jRSgudOBN61WyfmrxY/vDRAB8YxGVFKpUPxBA/LDmzceB3jxw6wSYlkJhxwXicXPLaazfZjc/LxaQ9sxIjm9758TDa/7uij2d0Ev7bIUsp82kcMYcSaiycQ4t3yIbBOzkXbAi5q52KHeCHNBs90PiOJscjb9wkV4swpj3D7P5o8gNBjD5ujlunEQYbRPqxR6zkfrDGMAyoWzd127Uajv9+6IyMkT+wTwPKn59dxBuVxmg7GytYFuufQExcn/Cpmvu/aHWaYi1pt7hqz2MlOkE83rvkmtABgGtgI62STpQblyi3R0D/vyr0wLd84Sq2uEsjeCoSzqU5wg0PogKJfOHTd59hIuD4LgVMuhsPc+aj5aJt
 UuS5u0h9
 8/BSXb8fe6cYaSQ6MWoWxkEYngI2MZ7E1ZatNxuzaC22NvUglhAcWZ0Y3QVnIgM/mF5ZCBXjU2Xo3W+vZi3amMA4PuEAwLlaOzGkqhRX1FqjH39uTXJZOz7F7cixweMbGmtH9M+a3hSGf0IAg+FCpJLLYCQINjQOQW+9x+LJ4sczK4pXn4/M+JEsNR7IPcFIAustaqyVJwC8OAQwmycKHFAUoWNRl1t3Lz9w4g6qruQmvJAIZbVqbjwwyytlMGls5cXFDocmFiB4iUCx9fsmlI3ZutgfyqovTa/aYtszZT2u0LqW8JH/bPXedvC3P1DgaXEbXg2U9tJP2sj/PreF84tOWkiOZ5RRS8/Pod4Iqpky/7EGk8CWvdntMC1kBCMBOXrruUjcMms4wZcnGbRjeruhucKwuNg8zVNZUNzFBpDnKdp7bytfPhqbomeGqdskUOG6kv30DE26FBh9LhlE+X785C7Eksp9gGPPNNb2uov35GHhwtKfsaYYqu8Nukg/FTw5jn3+rnNvorMW6KO5SZ8p0IA7fYpHLOiguyBYUvhL7QwwcLYbMPPjA3+muwNDl8phZRJNAUcE2yXIUKcVQ4cysgflImMyN+E3TYs7FTtx0uD2yEqTGL86bOxBHae5I5qrlcFOFAtHyK+0zwvthUCA5PAbTQNaeb7VHkMZmiD77H9ABrfdU4DLIhGuv7LmC4Sgk9YERHtCsIYfwkzO1ayuyY9WvEqtU9t7AfFUIzdjhJfMl36PUE2SEu0hD1a5TBHaQu7knrXpmqrj6hEJqzX3LkoLyk5pQrvhWJBQxBj++Yj+j680ShLJte8THWDYxU8kL0Yc1vXGRf2ZyINJMDAtPNpnxlBma9MDcOGgziEjbmhe6Kzs7W56uhDckuWCUtmVv8ErFaQ1gIJvcrk4ZrC2PjI5gZQT99MdJJST3ixtU4kdKwVhc1osBbLCWM1uwinesEtAqL5KmHkIvlIbLm1xdt05+
 5GI2k07D
 /MWuFxquqETt5JD1yKBZMjGt6eN0o7ouGtG7A03pabeVOb5/WrrQ8qZ1Kma+Zzh0UeQbPzhtC+/XYBNIHDYR5ZPLRDZCSwry1lXnz8xgbcro3NSf6OV165DB1PTLD+KwXi5TVl3KluYC6np3WWFDY+Ff6vXJwpArJs1M5O3iMfXa/p2eBU3fVugJfVDoSgyGsdSXWpzuqvQwxlolDLS1IPAm9PJZ2YlmLZKaZUtS4zpPY7i5xVug+J/7iKIsHypxS5Msy57SlxJ9hQeeopSnEPDqWiEWVAAjGs3U2bqe65x+XXKNK9PWo7ATpbkBYep+zxfZhFUna8d83eDxqJERzh/SGiO8h+ViuOJCdfyOZ7fKsM4N3dSpEh9x9SeGYohrlbafrtCytkUs6f1RtVUSryHviONKQIXBTHqoPlZ8yqRLNtzj1rgxIujOitql9cQh6R9GQVGJHjpSy3TmgjcTPPzcdQqyIRkGEYfHdDZEm6O2mZ58LTG2Md5B9N9l00vmJCpKh1sdYFTEbZkUxv8w1Jvs8xQxWYSAJgTwR28R7gWQfXj/7oFbgX/3tzi3s0EGaHp9Ps1JAB/Ola7xL2D/8sTZO/63XtbTOD8AoJ4n97DQ3wDYOcDs14f59LrLpp/nTqCihBnhJs1Lt+Ck31zWLsBkUcuCl344hQEy7xqutxbBiuJ/O0Be8Ud+hwB7wzf3mQD6VDF/d+yS5N9S2Yi4gNmQ7vmc2kmC6+tsRQTqZNG6WEj830RqQRyz3TCGyHTFltSAC7WnSSH+UoZzMYANwabuB/G0FHotrKEEcNo7iXXoRpbOe7Y/ON1NhKsXIa8AwZo99XJMR2/ijkV3mQ0fQ+IYgfqZycbREPqqp+Nf0sTfNUQLSLEZmRDuZ7B3mMhJl8TrB4Sg6K8cDzD7GaymForUtvs0srMjXFz483e4c4bMVr36Xr9bCAtH8i5OugM5cKgyES5zEOvlK30oewzQd53nk9rK0
 2urWP0jY
 FTwCa7yADuieOiFedfYBDtGacUYCABz3N8WR6AEKuQPN0i+1weKkb1rWSxeYGdnfrVa3rGUp56WrSCMNuxp5n4sGp3CxBlPV6KEggxEZTfDAjekVW73DRj9JZsvIUehHYDybkcjmV+j9q2ONMoRsnnHb1c6UlFg6Tf7tXK1bKTJv5inUfhyuZizXtnAkQ1qd/TZXmt4nYYmtE+3EwWjYM9TJY7qsCb1zfnKNut0Qx+pYTEcz8SRja6rwOibm17b5tSeii694FcEwM5w5tG4mRtDd9fckItCWBmDvBiRxOzCmuVROFyypjc8M8eRSJ28CGHL9nuSRjVz/EPDJ71PeIEDfkZuTrEDoUG3NH8Y72ltfsHHv/M/T9IJzwHoImJH4oeFPcsavBJWVFKGUeHkEjHtOI6EO9PQipzxqU9LIiLpy9nzDv8F/C16sj2z6B8iHdBwAOXlQ9LqbF95yBt+Fz5geAmX7dBp3ity2vXRpPmhVhGIpg9a6JxvwmR0/zJmC4/V9mN+l1ey9bG4qiA5oQdvi0L3wb7LaBoZCdSLfTiR/zZvNT81/13toBU/Zv/BfecY89c9pI/uQGx7tEGz7CptIxs/t9uJioT7C1+kr5sQy5/3C41LxQeF12JJ1/4ct6Zpnr6zJm7zO2pd8TM/ZEqFyzcrWFnZbyWJp6pTq3dBCNNSl3RKhFoH/R7yzW9iVmo0EJqwOeuLOWzswKpsvQFOuTc963rHkZnHN41husRJfOx5wnEU0hhu+RT86GvEEbcL1pnBnsOkWJC2EMnKDp+hPTW101zk3ckkY8XnYDyoclrvqPq56EKsG676aBcDWkHBSc6Ld+Lj7JJE9p93+7qKku+9SQFqM8WV5pI6gbgbX3aEeL7+zBd4XUF6zt8uOcOeYHLrVeeeB4KNEhp4BuMRbvVpWtCMotisa1klHfR15QbiunawmE1dQSpBMfCE+bHYTFxZ7/WfchTB6ZacLsNRwODe2D
 /M7gN/t1
 8pt5YCN6aopReubHgU0oAJP+8ng2PySTcpMIxCtLCUEpVQASNKk8gcUXx1SloPGceXGfg8eOVtpf2EXBbm6BIIOJR8mKvjCLu/M4SvDhUTawTefpjpN1DisuaWEzdE9lYhjGo6BrYkcbYVIvmOM+fHfpfWNcpf/f2LiKH4NbZ2SNI3gkWsgLKbR3uGGfVCvclxcjtVJ0Gwk+JsI4bl8wuuPBsf+3WDQ/SYn+CmXkdQaCN4qBtOTwh4V8DVPQcJquFDgz6YcP0Z91OkhfOTcjQws7oTFJZod/K+NywB3frc6B5trKmlseQ9G6JbpGg4OHeXoIQU9sfL0sjEQVTOLAUK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A kernel-owned or fixed mapping is one which sets VMA_PFNMAP_BIT,
VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop as
only kernel-owned mappings may set it.

Using these predicates rather than VMA_SPECIAL_FLAGS makes the check
self-documenting and helps eliminate the confusion around 'special' flags.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 803754caf4fa..0082afbdbbdd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4364,8 +4364,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	if (spin_is_contended(pvmw->ptl))
 		return true;
 
-	/* exclude special VMAs containing anon pages from COW */
-	if (vma->vm_flags & VM_SPECIAL)
+	/* exclude kernel-owned and fixed VMAs containing anon pages from COW */
+	if (vma_is_kernel_owned(vma) || vma_is_fixed_mapping(vma))
 		return true;
 
 	/* avoid taking the LRU lock under the PTL when possible */

-- 
2.55.0


