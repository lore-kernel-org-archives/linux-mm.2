Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6E02C79FAE
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D269C6B008A; Tue,  8 Sep 2026 16:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6AA6B008C; Tue,  8 Sep 2026 16:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F5B6B0092; Tue,  8 Sep 2026 16:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 925EA6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:19:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2CF981C27AB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:19:11 +0000 (UTC)
X-FDA: 85191709302.09.EEC25A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5CCBD180006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:19:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDQVool7;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbEvWuDC6KaxDOww6JLm5X1oq7s2JCzdjzk0eBTVi0U=;
	b=TV8wp7yZl3yqYm+eqq/1jypB128WfQiMDwe4m3ajHnH6EXosrBMQCXbG/KEeamRuJDi5e6
	uiN7UwibUbfbHbWHFndi6XWrdK1q5mhEU+CPc/HDDX+hkq1sHcB2Zj97oaTkrLu10GkR5k
	gcbvZbMWWX2b2brLZG/1tIXqfJsj8tI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDQVool7;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898749;
	b=LmMKSVk99gLuNZe3xj8EI4tA+V61Hp91jcPKG0dZd74LRYkmoNKHZvCpJuDJKSrXXNN2kg
	6qSZ2IBBxzoaRvkKDVQx7r7C61rKAh7zI0yKZP8f7F9j5FYQWpZ54wbYBlYoWAIRB2SYvl
	N+pd2jNpViEGG2Wi9FAo8ReKjo/i7Ak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9148E41AF1;
	Tue,  8 Sep 2026 20:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A591F00A3D;
	Tue,  8 Sep 2026 20:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898748;
	bh=FbEvWuDC6KaxDOww6JLm5X1oq7s2JCzdjzk0eBTVi0U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eDQVool74u3R99HSJksfg4E6VCtzriXHrEyCkfjQ1niwYx+UC8+Dsfy5lwYjKsIPb
	 Vr16xsKoNO5jH7kh6huZwni1KTmC/ghoWdEBKx6uk4pQq3nPgEity85rzzv9qcwlAj
	 dpJV5HKFsHyBN0Mg2e+wo3xEXW/+IiStJuJk6Nmx0Ed0I7GfguW6fZEnYknPoUcxyf
	 I9lftfdTtyj/99phmNKxq8hBgGe+bpOsgpplhSPrbLkBoYE10PcW4m/GGtF1Fii82U
	 4Twq2k27k8iXsJwfAe9fJhVKtsGGdlhriaq28zCfSbuNfgWehlGXzEmTiSvqoQgvCb
	 UoLw3xy21fkAA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:39 +0100
Subject: [PATCH 35/39] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-35-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1631; i=ljs@kernel.org;
 h=from:subject:message-id; bh=12r+57hlfcUqhp52wOQ04zakYjCIf/s1O/YwMYeI4F0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG7jCeze+rfw/4PHHTccRG7fL22KjHd1CnPmn5pWu
 fDZD1/ujlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzEjoPhv+vf5xN38/9hWm2t
 mHX0lEm47FnZn9LTj6R7X/fRu7O4bicjw8vq3cy3Ntzf+HKn2T3291cOxxwQtdUSWfWD6VvhzvN
 t/kwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: gkbzmb593zbqbmi7pn8gcbwtaeqqccxi
X-Rspamd-Queue-Id: 5CCBD180006
X-Rspamd-Server: rspam07
X-HE-Tag: 1788898749-269156
X-HE-Meta: U2FsdGVkX1//6SG65BtyeQf2fJsZu/7g7dRd7u/EngtY74ekFQe6Ki3EssA2HEMpVbbGt+shMQdkhax0wTR9GqBWLqubhVJ9jNP8LyLuifyjIlK1nykCpQDLv0I8PLrOM4K+EgrSyrgnzr42sFD1TWjrfkobxm4FKdvZA2OR57/aSwzNASpHaFD9/iOAxPcPa8t/B6LM+5OCAdBx+/A56X3rgEDkIpOUieVqqo9hXyV/g7jRxTT+iuHVGwX/sJt51mNyyIQEpKEsCUCNEZYxvxgj8MZwVdRkn41y1KWJG8awbRUeCtsyLQ35kTwt08/apKzZmb6oET5tUWvFDhDwnUUI4ckp5iXAYeUz4R3JkjityO57xqLb5NiQk1Oie81/8IyFdaEyKllfyiNU6GE2g86AHk4nDBeOXHbgztuHcnBXwvMwPTt76CeLU8200HYnwgpgOca5nKdmeOho0hwEMNADDO+mzT6hW6mPPGAaVpc47SdgMuNZuu+ekEtIxhjGGhvEg6POQ8WSkwJcCvH2AVmyjU6nN5pY6fdJqAulmcgWrP6K7aKRsL6fsGuS3WrGp4S94CGiUgvRXIovkFtX+fiyRPFq017gWQ5mDK5KuqzmfRFUbDF5H6tbGW4Mtpy6Xrn/LvwfoVTU11AcJPB+2BANepizzyI7y/TZNrt4ggOSIQW1P+8+0wlz12iNsem4dR9HJocxpGIsNet4Rq0tF5UE87PNlMnmSlcP2SWRZRGTm5y4R35tX2z9NiWnfVWaRRH7SN6RastQMIZ/AgU6PP1IvVWwaP2X0jFzA31Xes4+cNNtla97VehJVsRoNuuRdGOXIDX8uHPBUWZ0fK4YGuoIZ2OYf73aEGPZ78+akc9rDoKxO57z+yidDvFBfBEVWb0+OSYFjuE4GG0zbL/4EFceIaBp3PZlsk9gCpZErP1viUL7zbvpNSHq1JjWcThFXE31Zg4/b9AMRNC29kK
 VeTycATe
 LO/UoLkiv8ZSyet5Y5xt9sqS7tjcxOPSy6x1y7UoKDMD2k1vf09SwvIltLgPYMIxpXnt/C5vHLzO1zIZkM9yW1EueV68iE4bmr4y+zphR8YJI//LB1q0UldloTuQcmu6DMSKksRBFe+Pxnb3sh1phvT4euAUXQF/wG29EtUrhcF8qBIdYzUOMk6d7QJmgLfuIjgH57FKL9g/4aymTs5Bt5L3gmCI3zZ3MX5H8e1ENS33O/EHCapMaTuQvmu8eyPSOgrC5pC8ZPAoynGEL4gg0h6ExPaNnJTda6S0aNpn2+JA6wMYvRYK1AJoalir74nva07mwTmgr6SUmZolNRKlzEG0zhoanibXoP2KDi41Isic96YqGbeXAqnZCpqUJx6aIFMKW93Ik8YUjL7WN/Bq8ZGaKM6VXosB1Fi1Z7IQinU8YVi89vSUZ0ieUVFX5IBjQfAv8AUADxwy5L0O6vAG663FHj/+khu7YMCa+93Ykn9dK09ZtSgqzIjFD0jYEHscn22SVy2Izvp5oOA0BZ0exBVANIAIVnOB8Mb5mhLs0ovwaSuRd7yqb+imfm6YXKOfS3+L6+LZkqAq4qbJdleUGAxCq1vd37w2eTdZCol83+4wPKgYKP1TYaCX+xJyKm/rZTq2lNVoICBQP5avsisx3SHwlPmdJ1ZXbNTTehS6B3IODB87dQGj5xsO7PEwrVcWraM8WgBRh9OW01x7xd63jJeBKqCs3etbmzhJGhcTBCzyiSci9CtT91Ogow7QzGKHV7FRJDSqxQvhDgXzei5XbENILRw7oS1WLH5s+lYo22ASkvMeV9Bjr13kbJ5vxdWrri7BLeJRd4yRiYIFd512Esh0ZcnruDbA/jCtVEe9IsJL/4GgooslOPd1HR9w2/JlMh/VZqWEmcjLuR8lV8neeTqSPlaZhWQziauOX6a0kZq6T6lFCwPTEZOPvRCY5TWFfs9An1b0/1LN4H8RfSIvFgG2Pchys
 VKq+7XVr
 fllpZuoXge6Z1CBv8rCXX55SD/HTYkXXM8dVQYzJCp1dLJ5HgCSl9T88KlYlfV/NSHowTR4WKGMCByHVUqgVt3Sh/BBCJ7in3tIQHTgZ2HFAqOy+pV/VRgsOYBtXSA9w6J/L91GHrjqNZFBHZ/7G0iHR7hEhnPK90USBX/dmh/T1TG/Puo532oNHsNtsTee+JNTRQe+R5rSKRH3MS1JQSZE7w7v9QsESVOGGgtAOh/nEwMcY7JXsmRpINrNLvgU/cj9Xf3Ojtcp+mfyMofRb53+i8VO6xkJrW6cbhfySZEDxS/y5SF2KnmNA/aP7QwKe4DvGdmOfQ9w9RAB79ekP6p7nBvRdkcjZVZh7lMkD/zNISxPXGV1EqS62n3PDcdnsdGYQ9ZDjntJYceorw3Pdtkwv74lkW0HJMP2KyIoPZTETgaOlUIbMIq7/tZKCjWsgfVOWcrrAe5Zdn6bfQFUVGNpLQAAbr7oiD+xRTDDRBkjRGnisJrhC/M3aYF+ZbB5zwoQlRBc8xKV8G2aMEIYyvKz/nDZSWwWfxOd7Y/5gxSiQNlic8G9P+tbRai+m1tpzR2ocjwUpvubBeRtqzGcTogimUuV7mqcEo7ckC/ouyuCl3/jBi5rT96tKFqOSCSiHyA1DlWAj6aub53zvpk+0h9j3gL/SThlFnzSEwADp/LA9Fi3b0Vmz49oAgcioXm4smZiXL7UUNjvhY2L7eSqf+ha1LrtIsTAQhMKoVfljqqdNoqEDhvlBKE2GRTfTfXa3hsFmED86zytNCfSfOHnusV2maDsdJLCKY5XfvaQiX4EPPAJTSmJtFysb8WVBYto4sI3WX/U9290fck5ezkIrstvQ+vHP6/6rIszN61f/mvcoyTaH5MagpupExsDlIR7ZjVoJxosXqAyP0/z/oXNhSEDrFHpJ49uxUQDzQgvPwG1greKkjg0efF46YuMaxC0MB7mQLIQA0C0gzqnIgzAvwJvThR1Rp
 gX1K87MT
 zpr1MHJbobgr3yoRMI7LFe8kTg8H5KtBK4dAEwmPmEiwNNb1Z95OKu2wtIBAxy+e/nw2h4peNSGTiTZAOjUH2vkbfQHfCjD1T34qS6pr5w355SsEK4g2WO7ypnBoQSONq7NVuuQG8u/1d84jPsjwsOzv/LS4DOgAfJfpBHKsO6R7yUkprQA6EaB75pkhpppJgOqAiHtsPtPszR2QNaYxfXo52HhoAmF9CM4ftDLjFwHfHqEUIDWxYrqxqUPFbwELhLfBWaQY4RmgT9JRiBGNP4e7DL8jLRlDxl6TmhTCJNxWqTvVjtSzIydgcdXQ/CjyTXobUYM3vblbpWEfmNXxxrEh8Zh/ELWa5j0GC7P2uesl0x08/AEXATCdRWPSNlsvMRnMoCcF2eoC/SmOtEVh5v09P1nK+a9Kyi7cLdQrVdNG8NfXz4T1P0EkQ9Pv3lMap7rUytb6eCPIfNYqZH72UPS9XBb6sATQDZzarDvoHXKfykBwKOrWkTYLm8+YVpbQ6HJjrBlV/RAfk8AnuoNiaLdPwWZxfNNa+zZ42V97hd17ogZ1+c86ee3+dVJCacSCOxpIlcxEHNj+MyOZgi67UVxKgFsf5w+uj1BsAmnNH9igf10+r/qfuzHDsa25lGUICFOzIVwpajvzoaLOrhIc2EAxOj/FrV8v7DHp1YzPZDMRm/aG9FCMz+Zv0vlxOlVZ3K8uDXMnqonEbHTzM4moTB5O12R5D5r60dFCGjdlCu2SojFFsSVHHUbKCDa0nfbPPk4kmUAnNsudTTdjYkaGNTgPAhGjQ4qeDJth1oN3zUth7PHun1VgW6S9sU1UNLlK+2a0CqDELLfiyMhVhx/hT2SVGwFQJenZFMnPbNSkADyset2LLp/naEZTNKllGhk6abdJQrXnA/78+H93K2/C/t+wAW0j8K9Leog4GuDkaja7E96CNilCP9wm6G9yEBpZ/+EE4cAVFGwcobc3LB579qTQ//qL3
 W47Bl950
 f+kSivYeJ6AHLgw0U+IccBGkeQoXiEhjNY6aE0Gyy74fgl2brFGRwwOCDeJsZi5J6RYWXqfVwL8mjXIM29cxJs4eRV4bTBbQikQKmscg2LNQc9okl7+fSEEzA918OTDzF1IfS4ErtrSclWSJ7nJRztqRHgL+r9Y2okNK2gBWpFhJ8QalYtEfMTuN8o4mbxvvrzUhF6JOt9AJFcRab0Ff2NXtnEl8irBTIUz0HUQ0EexQCvuy9Fo8IzMpswFZnkVZhfn5CXAqSSeawBRqGEmUesIk4L4Xz41by0fvT01oRirTf4Ghm8HdQORLsLkHNVaWh6aEOyh01wzIFqOihUiz0k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have the expressive vma_is_kernel_owned() and vma_is_fixed_mapping()
predicates, use them to determine whether to proceed with migration. This
drops the VMA_IO_BIT test, which is safe as only kernel-owned mappings may
set it.

hugetlb mappings remain excluded, as they are fixed mappings.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index b9c453c28795..b74c0ae42768 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -739,19 +739,21 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  */
 int migrate_vma_setup(struct migrate_vma *args)
 {
+	const struct vm_area_struct *vma = args->vma;
 	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
-	    vma_is_dax(args->vma))
+	if (!vma)
+		return -EINVAL;
+	if (vma_is_kernel_owned(vma) || vma_is_fixed_mapping(vma) ||
+	    vma_is_dax(vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;
-	if (args->start < args->vma->vm_start ||
-	    args->start >= args->vma->vm_end)
+	if (args->start < vma->vm_start || args->start >= vma->vm_end)
 		return -EINVAL;
-	if (args->end <= args->vma->vm_start || args->end > args->vma->vm_end)
+	if (args->end <= vma->vm_start || args->end > vma->vm_end)
 		return -EINVAL;
 	if (!args->src || !args->dst)
 		return -EINVAL;

-- 
2.55.0


