Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CACFC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61FF06B00D3; Mon, 14 Sep 2026 11:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1D76B00D4; Mon, 14 Sep 2026 11:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 473076B00D5; Mon, 14 Sep 2026 11:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18E796B00D3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:11:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B20BE1A0163
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:11:28 +0000 (UTC)
X-FDA: 85212706656.21.B9805C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C5F3D8000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:11:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QVjqSRmu;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IY1hkyQnxRgKar673Yy42geoBDUpVDyAEE35Bg2bTi4=;
	b=AoWfpoBMql0SguAgP/OcBa75fYR+0VTWIAOfzuxf2A4rl7Kn8ZgNf7aQ0vh4/7p75LWE3R
	AUvCARyNbV4J5hvJXKAYaopQG1vHWikpGnAMoUVOmmY1keWP0W9PifDSEDR64IOa/QgEL2
	pu3NqSyn6eWCpj2huC8OKCn/wn7M78w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398686;
	b=74ecbYO5UYOQNfwXpsvD4xnRS54nJ29pVg2Ev22PC2E/pPOPiP8yh8mjkadCtNNK8+DmXn
	0KMElG0QM+5ul/aqfl1cRP1yaqV0fLvGrPVCEfzB1u3CbqRf+10ekEjHr5INT2OyaL559A
	pkH6zlAy6AmR7p0gEJFn7cAjaBXyyWE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QVjqSRmu;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B4174381E;
	Mon, 14 Sep 2026 15:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9C91F000FF;
	Mon, 14 Sep 2026 15:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398686;
	bh=IY1hkyQnxRgKar673Yy42geoBDUpVDyAEE35Bg2bTi4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QVjqSRmuwHcku5tS2EBp+UM1l6k3TuMyDGxNdv7tBUq1ayVqyJBEPcMGonBWH2mbt
	 CJnpweMQcewTpOK3PuR+WZE3wzW9lnt7wQYxw9ECZwxNcUbNIyhKOxzzYMxAxWI7UF
	 TU6eotkmnW47CVreMrXOa9l+SsVw0Gd93tLpea6D1gCt/QIIA9lgGvjAQk2AukwKki
	 /jgBz8o/xHWz74tspRVZPQHIEB6inXqC0KgEiWAWVOANJupuL+SdC1MP99MlBWIoWd
	 BvGG/iTE6GW25ier5UvU64queTaQhFyZYgU7No2Wl/K5TwbvzajfuOZB4dizpq/z9p
	 r/pZ2Cm72qBgQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:46 +0100
Subject: [PATCH v2 26/40] mm: remove VMA_IO_BIT check in
 vma[_flags]_is_kernel_owned()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-26-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6787; i=ljs@kernel.org;
 h=from:subject:message-id; bh=uH87TAqeXGzRkFjPPdKsCv8BClVhpn1A0PmRl2JkWNc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG+yqQ/WP98T8D3z0cT8mN5T3zbfl+DqWf/+9ZvbN
 e3Sa0Ked5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiPV8ZGV6z70ioaeDuitiw
 9rv6q32tc9n7pqVYbE7S2/ta4UHUQT+G/1WpJ8VaD1gFb3nzpHLNvVcP7O+dY2dafXP3toMfr9+
 5+I0ZAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5F3D8000B
X-Stat-Signature: mqo8mfr1q4jq847nona3qrhqccug6mxd
X-Rspam-User: 
X-HE-Tag: 1789398686-222429
X-HE-Meta: U2FsdGVkX1/VRf9KG9z3vnVkarh5AOnR3wSXTkoYcVU7SKNco7w5eppn2N1f/sfRQ6v3znrD/CR4IcCXSpsz/Azf925f73FnNplrG0M+plN+elwmZaO1AKisOVE0NDS1IF/uXNd/F74Sune2uDM+wtRJTtWUf/rfyII53ZseCnwhs3wyTwdGUKa8o33+VunSBpMtjVTX59a7clDHVVmgNYu/DByOzW13uQ1waq2WgwcZDL/Gb+XNgVyzRU5UCo3htl/eJ+vCphL3AQ78HMsu5msPfzxRIgaD0HP9h7B/EGnPb+h0PxQGiytfAq8gLW9ixeevyd4y7t9MCGkLp3aAkeSv7FhUx58iaBxT61koQUXn8y/qMxYHicFSGsRwzhymOwE+wQWKZBGhAMeBv9EJAUaUgNVWE9TlBtq/dejJpWcHOuKYYclA85mEnZzXLJHcvYj/4/RHKrSrJwmd0eGtx5iBuuQ2s4FS0T2aWF+vhNsrDbjwgSC/Y3WYLwaUTM1NeUJoAnZZYLruFCfdXNO8F0twRnLub9xx1EJs3eYXKIkbCYnss+oYxKttQ3mA9A4LfoTt6ZiQwTNvJGG3TV9LleqXTzhjux+LtQBy6Hmjm0oD4oejPdqpgM4y+bcyFGO5uCAmAQJ91GtZhEAPjbwr0b17lbq91Ng5ZQGdp9LiEIZvGssmdpFPcEWyUG7sYml7GOU5UbXix9DHO0vQ4jLVYJiqpe+usjaPlt79bLLm/H4tIbtFspjZ/jsfyBVCcgnGWV+i39mPiTKeYvcR5Xx0qrufWhoIha0X1zpqgFhgMzduIaKQ1AoMJ9QthZja/MWo5ExnyFSB/v6IrZ+e+9ue6big6ZQY9cbXe3NA+IdI05hM9Vc8FduFaBxXfOzUEzWuTkCF1uG3JZM7URwAGDsFX6DApNlxCvdxOEs5IKsPqwFtMSS1KgDBzYwkHvGrS184C7IDjpIu3pfWb1uGSNv
 giSOeyAS
 RK9id1grtFytbQ3oo9bsinE7Wwrw6GECpoCu0uOZsjO03+nNrKs53PVgmN+smH4p7u8HIJn881TbIEg2cShOwIFQY3xdM2Jxb+dY8EhZ8xu8ihVw1XRF9GJgmvlaXfiQSHXm1u686jFAFR2xv49e6L/5JI4O+x6Mege3eHD6o3N/8IuZg0isjLVIkJCcnE0Pn6jnqousmjehU/HRAujuwjI7Bk7AyateexFCxlDPl4AW3NC6jt86DDLul0YcQf2nA6b+VHHN0MpRWmK5cPVUmVg6JjV9wlPc1ipSzVCZt+ouHsd+fRuOxkj6xB5A2IUiXJUeSg6WzQKUZtIqDOdDFMJ92iFxE0v6l2FZan6UOG8VUjYcWMBIA/rGMIlkhW8eJZUDGi5a+Bx/W0SCnGjQHh4H6pduxcGRNShVOsM6NDVyon4UoD12hG3VtLCd+TkzBt80TyA/UqbKq0HuaulFtB9vtynJtq5DBXr8SqPhtVaBaayF9NHgba+ntv48KQa45HpPVpQAOpqrSghSLhDU0y58QLF3sCdOUeYeq7JlfpcjmPdl2bm7eO2B9lP4useqjwvO8IqpExgObyZgs+/WzTNaNrYfV55c0X+7TFg52dNrpU2DKxM1YHACQHlyUtd0nX87t4oPzCM0CrnGdfoguwhumS+biAyg0h5BlwyVGaqRxPT4jJC5Ga4YLFD/FEbx+AfoAdipkpV2gL7gSA6h6Qg5H53N5+ErJ7XK/D1axJZ5XIy88LMvdymhhXAKYmiTAHYEGrPwzqy46ZHZebfBaVWHtYE+8jwxgGM8jEjjua+wIJDiDDzLrTT72PBfbMGuY44WcgAidI8lHGq4gkPG3FJ/rksJh6nOUMr6mCu/Kgzgn2Md5NyPQrJTdZNM7L74p4SQxmdxaxJXJoJqXByY9MCh8o+h69eSGb26jw6rboSg69D9k0NYjDsr/NmnYZwasQM3xsag/dM1iRW7hcgM5+twu2y5p
 D7UBMwsS
 cAGWaa9UBvm1fMP3TEnA8kWDRhKFgh6nyv5CZhwmhOeJpmmFq5N5TTurvdtDlxI36EiZr9K4dl+5/4Ws0V32yKlnspvLtFK6f0sOBbtX9QhADzL0af5De6m3pqi4WeTF4v4uFEggRYxlEApSi3RS1TK8cu9ewfXCTKxexapl6rptvNmYqQTePYpyX0LcuTaaattwpVOdMzUAFObzbkEoWMhgXYNMUqzBUlF0w6AqODGnTjatQVWJgW43rHrMwKWzMZB8eoRNfMp2vFhwfG8TXt3NgBYQxYQg/nkcujnzRwXnXE+AwBDBs1cEEiYcaACgh0wQAzSyOkL3uHel5l9fAr4uzYABlxVgN2xdq8Fr7cvWifbZxclciPiV0pzLzuyxmnthtL63OzN1Le6QwEvEImEv04g5WlHj6Yds2Jy6Gheo8V2Cu/tRl9GaW0rybaI3jywbbjA6eIEuLOtcf9vkWyMdUBwd6YJIFvOo7qpw0CGjCW0Cu4Oy1O11/rYabLhrUoYTzX6q1GEmHm+7SqFTvR+RQd8na4WJCrGZB1Q8E9eCF2oMp3mTvh7Y8LsOey1l7oMKUxttn+zieWukj5spy55MgVJdtaZ1fiwbVXWSoFAkn6poUsbP3gD+9oUEvXgN5PGJkdwohaLMi+pgLgSrUUt45a0/v1pIVp35LZdZsAkWcjs4DbZ1K70EiTCDn7krBUTDcYYWSqSUIWM4ZrvfzvPNesQjBWkj6alAzWa5ffQaKYSlknLGLYhCOQBmJd7bIaULHTk9Tsn6teGH2wwBLQh2YUKsUvPbVLuEZYLUS7wEib2wnmXpKGl7D/2BM8FIL32z4Fd/2KqKqbjLnYjE+YwoFduSvpQHqX18fNUjL/g7acU1f8ip8jUZT6edccR/qlvmk/3OSD5ziCGuMoC4+HJwykf8HGGyVAVxptjF4l4+91V9oSVvct9vup3NOpqVjRNPvXuit2OZWwliU7EjMJVqkXznH
 uiCBLMT0
 imnDZEgtOUprZoR7rYJrfkMKzfkEQkdq/FNiAw3ZYzsh1uXHmdbb9WCdqZXYO27mcFxu6BRCDgwb3IjqIsid84GUaB5Hgn2XTabGyqdqNi3SvcWkb1PZHT5LcwYeT8DbkMv3p/3tKJkqpDQl+iT0pYo2/wUUKnhwca0R4vSZtKPRHnIUYBLrYPM2sTPWgqWqEdDO76/VSdE7Z8oKblR8Zpdfby3B5+JbOuQnrO1htNAE+SCsxekzZnnN2jzmHGF5I8S8FpwdHiNjptJV5XVytWeubEOywfNLGAFp1GtyWfLKqH0UY6yMd7U66ZgkKYJrykimT09wSUIxL5mNsVC9Zy9NX5lufwjmkhAPYSyvu5Q6RS5o6G42Y9iYyQeqQ5QqhPaa4J/pJRhAcHOBbfvbt8wGtljCVSfWWDjiA+6Bd3X5xZ7nTvopkU+O2qoQrHg2P7L7/6AbymYF/7CnUeL4R/+qGKP4iub72QRTqBNuejPRSyQBrzudCVCpQGDMN4XbjWJD3DWH/piGMyz9Z+EpP41WYRmksAuHJl17DUha7OOGHhHyEQCj46CXjLWxelgeY8Qj8DSIMJ0NEaDN+tL5La8GJ+g6WSZTWnzoc/Xg20FTx75+wpqtg+ekMl/X0LvBdq8zLRr+D9w9d4QPineUxWIgYu0CoMINPU9EQExO3DAQNdrTqowhS9PmDfOPS0qLEwp1TgbkwHKRwlbYXBr3xEfHwNScecqYSpimZzKmahVtx17W3NbzxlW+HYv00LNKJkjvWgdL0dIy0XcOEYUFd4/RUXwyEpIRqo4iuNh7xaNBYdZUFegMwIuI8ZPCM6pqYRp9gjFF96M4An4XDa59yJ0lcMSKeJ4IscJJLBufp8iF2G3mJh4Ysgu2m+bqIKOOzALwr9XvpectPMIcxg7tUdgKlHqRAa+rkqZgtAf7avgadqDzrRja7J4R5qiXkUdr+KRtIERxhAu0DxtV8XdctbnlX9N5I
 Ghzavd5C
 RU0JucCpXtL9r1qv+wCForig3eHeMDqrIh/Xbr8pBfJUrucmNjPelrstGNlsINtUCsK+/jCk6XDwqaVBTTITEtHYRGRQdlghT7HXRtJacorgcoE8GlVcHpiI/PUVITGqVOAkI+9Mfby0RZwYv6P4MnS6gEbNQ5MMS7jpkD8l2KMcCOROV+tU3QGiPCcXU0QDx6d7dy0wvEOhw/wBLjIhrYemKHdO/Jy6dcZIMTxZjkXfdb56DL81ly0kqd9HR8o9BcWASKALc7HHTb//q1JDCSHWnTuYflGdrXKAO7lyHaePhIlG6IKxMFbWVRP2P1hemjxaoN5YqxXid44wRK1svFa3CRCM9oKDRHJhOrTzPWFJywtGR4KSl9HAMbKdc1nPhHcChn/DaMvXaUSL/IGEXSLqGX5TukyLkyTeRSX4NGhaEgq2mGLGXSS69jpa1/LBqj7UiiDfpeNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have now made it such that every driver which sets VMA_IO_BIT marks it
as kernel-owned.

However, vma_flags_is_kernel_owned() currently checks for VMA_IO_BIT. This
was a product of drivers previously marking a range as kernel-owned by
setting VMA_IO_BIT alone.

Fix this by removing the VMA_IO_BIT check in vma_flags_is_kernel_owned(),
and update mmap_validate_vma_flags() to use vma_flags_is_kernel_owned()
rather than open-coding the VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT check.

This change means that vma[_flags]_can_merge() doesn't check VMA_IO_BIT any
longer (which is now redundant) as it calls vma_flags_is_kernel_owned().

Now that the predicate means precisely VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT,
also use it at the other sites which open-code that pair, so the intent is
stated rather than the flags, with no functional change:

zap_special_vma_range() only zaps kernel-owned mappings, as drivers use it
to tear down ranges they established themselves.

The mprotect() arch PFN modification check applies to kernel-owned
mappings, which may map PFNs without struct pages.

NUMA balancing skips VM_MIXEDMAP mappings having already excluded VM_IO
and VM_PFNMAP mappings via vma_migratable(), so it skips exactly the
kernel-owned mappings - say so.

Finally, update the VMA userland merge 'special' flag tests to no longer
assert that VMA_IO_BIT prevents merge as VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT
now suffices.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  3 +--
 kernel/sched/fair.c             |  2 +-
 mm/memory.c                     |  6 +++---
 mm/mprotect.c                   |  3 +--
 mm/vma.c                        |  2 +-
 tools/testing/vma/include/dup.h |  3 +--
 tools/testing/vma/tests/merge.c | 10 ++--------
 7 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ca598e5f9715..4b6aa0b47b00 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1630,8 +1630,7 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
  */
 static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
 {
-	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
-				  VMA_IO_BIT);
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
 /**
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8dff37059faf..a71f0ab79bcd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4212,7 +4212,7 @@ static void task_numa_work(struct callback_head *work)
 
 	for (; vma; vma = vma_next(&vmi)) {
 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
-			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
+			is_vm_hugetlb_page(vma) || vma_is_kernel_owned(vma)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
 			continue;
 		}
diff --git a/mm/memory.c b/mm/memory.c
index 42f084517247..38fe455dc70c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2343,19 +2343,19 @@ void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
 }
 
 /**
- * zap_special_vma_range - zap all page table entries in a special vma range
+ * zap_special_vma_range - zap all page table entries in a kernel-owned VMA
  * @vma: the vma covering the range to zap
  * @address: starting address of the range to zap
  * @size: number of bytes to zap
  *
  * This function does nothing when the provided address range is not fully
- * contained in @vma, or when the @vma is not VM_PFNMAP or VM_MIXEDMAP.
+ * contained in @vma, or when @vma is not kernel-owned.
  */
 void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
 	if (!range_in_vma(vma, address, address + size) ||
-	   !(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
+	   !vma_is_kernel_owned(vma))
 		return;
 
 	zap_vma_range(vma, address, size);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d87..fe32fd87cf5c 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -783,8 +783,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	 * uncommon case, so doesn't need to be very optimized.
 	 */
 	if (arch_has_pfn_modify_check() &&
-	    vma_flags_test_any(&old_vma_flags, VMA_PFNMAP_BIT,
-			       VMA_MIXEDMAP_BIT) &&
+	    vma_flags_is_kernel_owned(&old_vma_flags) &&
 	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
diff --git a/mm/vma.c b/mm/vma.c
index fa429771bea8..54e5f4bbd8af 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2787,7 +2787,7 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
 		return -EINVAL;
 #endif
 
-	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
+	if (!vma_flags_is_kernel_owned(flags)) {
 		/* Only kernel-owned mappings may set VMA_IO_BIT. */
 		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
 			return -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 9205ebf31ce7..de429ed4d60c 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1667,8 +1667,7 @@ static inline bool file_is_dev_zero(const struct file *file)
 
 static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
 {
-	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
-				  VMA_IO_BIT);
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
 static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index acaab282939c..b26f1a66a170 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -496,17 +496,11 @@ static bool test_vma_merge_special_flags(void)
 		.mm = &mm,
 		.vmi = &vmi,
 	};
-	vma_flag_t special_flags[] = { VMA_IO_BIT, VMA_DONTEXPAND_BIT,
+	vma_flag_t special_flags[] = { VMA_DONTEXPAND_BIT,
 		VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT };
-	vma_flags_t all_special_flags = EMPTY_VMA_FLAGS;
 	int i;
 	struct vm_area_struct *vma_left, *vma;
 
-	/* Make sure there aren't new VM_SPECIAL flags. */
-	for (i = 0; i < ARRAY_SIZE(special_flags); i++)
-		vma_flags_set(&all_special_flags, special_flags[i]);
-	ASSERT_FLAGS_SAME_MASK(&all_special_flags, VMA_SPECIAL_FLAGS);
-
 	/*
 	 * 01234
 	 * AAA
@@ -520,7 +514,7 @@ static bool test_vma_merge_special_flags(void)
 	 * 01234
 	 * AAA*
 	 *
-	 * This should merge if not for the VM_SPECIAL flag.
+	 * This should merge if not for the 'special' flag.
 	 */
 	vmg_set_range(&vmg, 0x3000, 0x4000, 3, vma_flags);
 	for (i = 0; i < ARRAY_SIZE(special_flags); i++) {

-- 
2.55.0


