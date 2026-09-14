Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9BFC88E77
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6736B009E; Mon, 14 Sep 2026 11:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286546B009F; Mon, 14 Sep 2026 11:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14FBC6B00A0; Mon, 14 Sep 2026 11:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3D126B009E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:00:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F9DE40191
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:00:27 +0000 (UTC)
X-FDA: 85212678894.28.395560C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9CC4510000E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:00:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dg2Fe5DA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398025;
	b=7xY3U+cjnPyHqF08ruDjV+VFUZOLoVkQ/MflbjLsL9m6S+XqjncO88jGQTEEgNQuBaCzmV
	wg+yMohgGySIg1yrKmAbigoVFTlPd8YlalUxtOzPgiLOtxFknhFEIQfWd/Uity7A2s5C5k
	0hvso9JetYRuRsnKdwk2kdhx8LYr33o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dg2Fe5DA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1G+xFXCQNVBF8wxMQxvWMHZYPsF0so/uZjMXa7bsyg=;
	b=CCGlq8d/4QxNOnQVxKjRk7hxa+eQLOaOptlgAOKH6dQwC3ROzhhSwQ0ljTvLHq5M9AO+m8
	HqzRYzpNyvfyQssfLuKxna1e6YQZS5EXIYOtPOHSjx0lAtHfjjWrSINyZmEKURrIBq7/Qy
	yDScA7blC7RV0jWHTAxXHpHao0jMXVI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B305E60252;
	Mon, 14 Sep 2026 15:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751251F00893;
	Mon, 14 Sep 2026 14:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398024;
	bh=r1G+xFXCQNVBF8wxMQxvWMHZYPsF0so/uZjMXa7bsyg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dg2Fe5DAsf6cgSnFAtqKyclWLIYcQDBRezlkLWBcpnByHIDcZeYX1ozgrOmMphJP/
	 VIYfYlEL34LjVlmE0u9d55V0O+Mprf3eoWuZJRt8M1uKntD6yXAmC7zM3P6IqpE3xx
	 2Ov9QmoID5RyN3+5U5MaSJV2Nn867bU50b2moHPwXMaGK1k1CE+ZSHBRrc1xUY6bj0
	 qLwdNI3DP2/EjP/nsa9rxNfzOvxVTH4iaP37WYXwkICznAVOxz1wsvoq3Hk6aRF/Mn
	 N9xg2+rHHkWqvIyhlFPeawYni8ydfuf7wItDpyMV5A3ltZ9Wgnp+NId197Rc10bBAD
	 KH3DZtVDniryQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:22 +0100
Subject: [PATCH v2 02/40] mm/vma: predicate setting mmap_prepare VMA fields
 on new vma alloc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-2-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1712; i=ljs@kernel.org;
 h=from:subject:message-id; bh=UFrVRLvfvmL7sB7G5odMQ/5YgrxZlazK/5+N6FdQKJI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK89H34+9rDukTPlXlUr9mobCb2evH31Oq6GVWeuK
 SfJfrj5u6OUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQAT0TrHyDBDbMXH3D098s27
 zgjc7/XoKWxPfnGaXUNR+5lwt6iF3FNGhie1c54s+xB6nWfStIkPbh83S7ihqrxvBf+zyefq36X
 lrWUCAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9CC4510000E
X-Stat-Signature: kfajs6mzd5z1qjqkimmi6hxwtke69qzq
X-HE-Tag: 1789398025-440039
X-HE-Meta: U2FsdGVkX185vmqIW4T2tVOQ8fosfqmVccS1+DbzgLSvca/It/uhU4N2o2eRSC1kiPY0CX453wh3y9QTxOIkcn6qjZa5xFZjobb3/2gk4qikUyHFNsyb2KLp6YEuy2P2E7OFvm+Wt1EfnzzmKcKFo+3uFp9VjXKVrAISJYLbo53uRX5J9BX2OsG9fDOvDRt8odt1NBezufJsd5DlpmjmQinSf+2i8fdfsDi07aelJj1QTgAahSK17SL8nk8rZ6CxrhPaXg1Y80lQjXm2Arr8YK6QeNJrClPfJU6yhQOp1RevRrekl0aMQ578R0fFOph4H9rdLvJXfqzfp8vGtL8vueV9LUPTXWMm4rjHAVq5BUftW5eeA/ki/+5YTPWDRXLPg6PqIFDm1yLeXXzDSA6BZzDcc+xqJSBXjU36kQ4pzP0QTHQ3haXvv+KpDKlIXlcEkZybjPprQfP+wuRzP+9dgorvPCqRU9hap7i8JYNJFNFCkwKRJE4XnV3F2jVkQJCZbDUXqTjHNI1srOvS8uCA/fIidZsM6iMroeVba/EZ2HIyWzaq7UMv6spbZA/+nFGjmggOV9Bd3WAFFH1zqo5n2n4owgTnRukUHbVrQySucsnpAfiKIaJ4srr2XzUda+YzaK3Yjh4Jln3Af/x1Wy4JWNUc2fb8lNkofwjgYvxESVDNBLTrCK2thbVQ6uwvN0JXFQmg0EqIU02PhKzSu4V8xecC3vL5MYSCx2GnQEh9/7McyS0iPAQy42SvI/GNlQ7QaCs5uJohFm2K+95qXf8CpkwvDTFVGO7Rjjlbgb3vHXWEgsjFnLyN6DOmDNaQ3UZLD22qz4y1N/0LFjRZADB7ScQyk/RAQn4NHdVPrbXmJSedpmMpH4ilX6tBcoeWBEIWIq5eN8fa4JKvK47DQMk4a0Jj8miYR/jpq/MEyUG6pqMuEsU0ciMhMSTXP/rVI5Y0H5yM+ldAvKC6+6WfltB
 Ib1EhcTP
 rNrQjLp2DFdwpYnio2RyjUB0jWJVcwdqYmhbyWloBgqcPXibqIagdD8o3Jwj+h7OtsxxSFBcQYAkEoSRR0vD6k3IkN6BP8+MCORww9b9JsGxHqbtpoyFQZKGwC0GMNEulXZXprlWMIzoW/XDnjq+V9LnAca7Qu7T5eK5HL2Ew3LpEKWz0cc1SVu5x+ubNGYnDEFldrkzZ7eCLEEk3aohn+DL49kd3nSAsUAUn5ygriHCduYGdQcUb10p6VQJKyKeLEW0szR4xx+yJuNJq81NTlBfnp471bYhdLrCKhTH8Rr55QFkojzjrUqJ1XgUeHiI12nuMPiRzcwpkbw00Mo1t2mQ64UnFshTPraY+HJj3p9pzH7IaBfyUu5fQeqkOEsOqVVTih+ideTK12SCF20PQ/xDupoHzF2HiBIcSmNPQf8QDP1W2MhJQcSZkwY/tmBdLNCTwxlbrY/1zPNboVhfYEN3eGVIa8OXpRUgIAf869juFI+k1s7hmtmX53dlsIa3mAhHBzuLK3bh1hqzyMnaEplQsdzp+bJBHFXMFmBTwYogQO/h0a2YW9koFsARfUl1IctmkPjOqMM6x6Wfap3KZ8/dXqRkKWYW02hfAuH1/CiFRBV2MyVpBG9tZrxMTn7qB3HIpj3TJSgARPJJLyujVHRF27V49AVHnF7DdJJ9ex46m4Upo5M4XVAvm3f/eIeROEQRWl+EjMfX1Vrd4X+orkz4YmwCbOkKp/y06C5yO1zurnIucfXXm2fj0zd0HUwo3tgAa+mzGdvIdD1RUUkq1ZUeR4CwtR/Rd0+6tPk7VPgPQ13twQXX3fCkfE4IBowV/GyQH+RAdUW/kGt0P6WKsT+GzsZYABdrxfSregSSV6hn8Opte8UVGhK6R7K3Wq84EuYB/CIii9WM5C2weuF11U4LKOE7KJWBjYwHGyfzXJr+UGGxqXXUOKcTeJQ+VMG8M9E9zj706MY3Gm+pWprIY2GXsjFRN
 5jFDt2lm
 IDJSoQSAbCbP8jWvaJ1sL2QZeR9ptgDRcXKDgZKq2U39ZCa8ovvodIZvIvyEWUF2nP5JglqTtIyeOUG5d/5cT/dfP7N4Mb7s9mHyGQzcizD4P7aPSALBUOyKw+nDMw4cMOZ2Ad01oSePw7sJxo6dakfiJwZ93djkWG3C065q8lLy3PJwQkhFyRVcay0nUEBm47HEMVwElFmsxFb5kAWDhxfDc0bJZYr/jQozw6b+qkhvmByuczVEn9wSjZmvS/jveykbzNDHJijo5NWmLG9zrhUsgP3zQbyBXRqNGKo3geby212OTXGdctGB0B9V9ldDou4SPT5gaB2Rhqzh6qcaea1SItUK3GXB5JKYLkptmLLw0osE2ELff45lZMsMxCGGYzWNXLADU2u5k7VLLejudondEUmJ8stqxjtKpM36aYbrV89wwvzH6VGDgJCw+CxNlIvg7cAUtf7m4lpVyE/SgW1UtOESgxf3Q2XUf2P86VTOihW89JK83FsM0IWGX7CDGyvISxCrZAI/m/QUbWipMAbOHPT8vNjGupNYPfXKMbkhoaK9eULwcLxifZlHWfe7fOee0NIYGZ1PqLcWQP2IrbAq4OtLoSpV7B13E2u9RR+xN37aHIlkJ34Wun3gJ3EVZv2rGnLgJ7YSarw8nnmzsJJq+QBWz/JZK0nPIESJMHTZ3EJSal2AZnmuZPY62Jq2uTM8DaCzwbLX72kPqyJKMhsYvwLmI6GolF8nde/sWRe+GsDrEuIfuUF79aerfJY+UDLlTjEBSyIS5AxJMfc3Ia1TejGNWFUo7OURLEJw2mWUjodXAneMU3Z/pgcBxowZ9lj5zy1zHBFnwsYCDBQY6NAuzgJ82Z9QY56curg2in3q4GH9SlwFSbUGO5UGhX8hlBwdID57ixAo8M/p7gDuh5OdvhxPBKKsrw5vzSkPaxubTtAk2KvL7fkWwtP5NJZJ3fqWVcSDcevjk7V63Jfp8sBUXHK4x
 w7kHGTuO
 gvR7cPMnTofKbB4BqpHa9kQrxku0ktM1vf1PZwB0funezH/oOwCq9Vfkkgq0J2EsEtAkWmmFKaimVPU2iioCR1CWrNWmdPCuOqtlZR6h2g11KtyS3fifAztOLRkHGP2qKEfOVnqcAdvNGtESE8rDCxh90GKkdL9NQC2MHAIe6mcfMt732iQAI64UDMhkLBYQ/k2vpwIDdCBO61tt/POgR194TgZDz0RA/RU59k8K1ySVCpbEM4LMGNTz6HMUfxlqe30bRwsZ1ic/Y9NvsbldsNfPi2RefMr1+nsQg2iEccbGakd6s6OvgfevtD1Pa9QNyILNoCWt3e8lJ4TCpxo3MOx899IOqf05kttw1qkxE35jtDsuDgEJFiE+n4j/rUWvIaveMJiKgusudeWUvkHu2yEDVNgB67ueuC7SrZ+hhYCk//FsZKKdS6cUXc9TIwFfIN0T9fZFIL4LT6XN+BTvL7J0AyJKIo7nhqpmFaIUeopkowMIiSL+wDPfcp3WpPSPsXpmjQYnaNvAt1YG+hKeP82TUUwuzx45qJaeun8XirlCZIFDaKoSIG65YpZSn6M6sriQUGePeqQiwSbH4omoHruvJC4fY8s5XYPOpveo/y4+6yz6l8K7Jo15IWUwy237t6ziiAU9EN6+I5qA79Oqh5i+ukSHlDprLJtAzH4v/TvEd8x+kK/jMepx2vYrtp8B4Qq7hoW3fRA3wDww3GegtcDpC8BtHDt98wb3H5cSX2YOR5eUyZQAW1wCojKC3jCWmk0+9Tqi1OKS7lAZv2K2RYBYOXKyol7mCKDqW3lE4ta4uGfIR/DZBnWrYFhqfKK43wVRbQeTj6rlgPTuTKDm0P3lbSH64mELx0tqpZpv67Y386kUTLT9uNBQaVYV6o14xJvjKM+XngbWPNg+kl+g4LPJlnaaD933fPM20FVJK6thybEZi7292UTmS16sCrCOJIsP2PerMwgmgVROp1Wx/l1NdTWfY
 5XbZVAqp
 nP8PTDQPFs0GnpyivejaTF5VOMT9fEZbjTPANYWMqXctWBKB/yLXEwgkMggiIw/3tBGEPpMXlWeLRajBxKzPkZpQXtD2lcf7YtouteJSD3pGCQP2PiAkGfKVHQoZbzMB/ZkP8tyyZ0Xd62c4OtS5OfSc9r/M5N6bDPnuUK/QoD+WwsOQF637Kc4dc5xZfEiSK7a057mu6/Bww1zdeaMSXkjvIby4M0Uxgp8r+/BC4oICW0KUbTjoCUApfXj82uHeL0zpC0crxbAj8D/QYPCrv7LYdUp2daJ0CSvuFf/AKa2eVlcn4b6zXKm1wZGWAmDBpB1VqCODv4gzbbSwWkOCYJqMaSlL2PAgoA0QjhPVEamyFsiRzlqvrsKsrWTouBBBD0ur2/F6FadWfPNj19ydAYCV/2Thlno6jOXs/AahRS2Xww6uX/akxImqgQXl+uB1WW9ThbcrnfYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It only makes sense to manipulate VMA fields if we allocated a new VMA,
rather than merged it.

VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
keeps its own, which is also what the legacy f_op->mmap path does since it
never touches an existing VMA. Previously set_vma_user_defined_fields()
overwrote the merged VMA's fields with those set for the new mapping. In
practice these are the same values, with rare exceptions such as shmem
selecting vm_ops based on whether the file has been unlinked, so no
user-visible change is expected.

Make this dependency explicit, and additionally constify have_mmap_prepare
while we're here.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index a319a9fc2f29..cd9e2113f66e 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2892,7 +2892,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;
-	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
+	const bool have_mmap_prepare = file && file->f_op->mmap_prepare;
 	VMA_ITERATOR(vmi, mm, addr);
 	const pgoff_t anon_pgoff = addr >> PAGE_SHIFT;
 	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_flags, file);
@@ -2935,7 +2935,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		allocated_new = true;
 	}
 
-	if (have_mmap_prepare && !map_is_anon(&map))
+	if (have_mmap_prepare && allocated_new && !map_is_anon(&map))
 		set_vma_user_defined_fields(vma, &map);
 
 	__mmap_complete(&map, vma);

-- 
2.55.0


