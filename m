Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EBF8C79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0726B0092; Tue,  8 Sep 2026 16:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8713B6B0093; Tue,  8 Sep 2026 16:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789396B0095; Tue,  8 Sep 2026 16:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DBBA6B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:03:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7207C079F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:02:59 +0000 (UTC)
X-FDA: 85191668478.22.FE0E074
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 09C5F160002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:02:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nH5WJi2u;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788897778;
	b=2b4ukH1fiGokOBfDqyURMtxI6pIv4A3espmJ8owALVCOi7iGZMSZXw+d4FDc5DGG95aurI
	JLxPyqRGECBCYV3vO55WZD2JzKNAYrsjEsm+9fWfKiGtvlFlYqh/QJwuSjzg7b6U0GGWJ7
	nHQU25RMOJaj4o/IYKYe7jPukSUSZ54=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nH5WJi2u;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788897778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAuHiG3VMiz41sfgAPoYgyzk8Zb9pZjO5QbNMONAAQ8=;
	b=UpmJeHGRMNXr5kqzKPk0vqcf0tArRzOf1QbBpc4T7T+Cg0pTubRGwX4MwTAjz9ucGyYDpo
	DOJHK0zYYrpPsj8W/NP/x0xxN0LbWu4da5LYKFIR3zc+tkuPnBDkd9Ze9RrnPZS1y+NRU/
	gBkW86v1T9MGb6kZpdog/kAO/aaR66s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F073A40947;
	Tue,  8 Sep 2026 20:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694551F00A3A;
	Tue,  8 Sep 2026 20:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788897776;
	bh=xAuHiG3VMiz41sfgAPoYgyzk8Zb9pZjO5QbNMONAAQ8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nH5WJi2ugUWEAlQwpJVZAN0YVWc7hEFypbO61f8EjYuAl1M80qXUAZD7uFk7h0zkJ
	 8yjlvVbZ3xrWqvX/TM9nlcB7m+h9xxZTBrsD760l/7wNfRlT0SovNp/2ddOhMkYtrL
	 hvlomkDI1JxVIJQmUjVCnBP1bv1XHQ5PgUD4ZzGsI05M9x05hJzi8vmSRGv+L2C9R6
	 1B5pEiiz0eDsew2lR8qWczJvT5TqYiKBFknmTZTrozYhQylQJQP4XMvHPq94/vSoQQ
	 1i5FcUC29OnFtAONlRCLU5+4r5Wiv6+et0rCVLMNPJ6qTAErKxw+aZ2dvopqhehLb7
	 xfpLNaEIHKvdQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:05 +0100
Subject: [PATCH 01/39] mm/vma: predicate setting mmap_prepare VMA fields on
 new vma alloc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-1-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1712; i=ljs@kernel.org;
 h=from:subject:message-id; bh=cTBSc+RhBb8P2CssJn069Zx2TN5+EwkhNO+s8E1YjR4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG74aWYupM5yl3PeBd4LVxN+h72/tztZ2qeUqSLn+
 sEpnscUOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARzi0M/7OUbgb9m+N1uVtP
 Z46t0bTz9gnaLWxhpTVT1nhc0iqOFGf4xaSpXcErfddQIkJ7A9es5OklgvNiOv/V3xVsu7h2LYc
 /KwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 09C5F160002
X-Stat-Signature: tzrubg8ouxnhydui4jmy3fqdshzm5h9c
X-Rspam-User: 
X-HE-Tag: 1788897777-864704
X-HE-Meta: U2FsdGVkX1+K5SY0bDDfDi8rhPSMog3BBOPUSFCd7IPZvRySMoR5H7B8eu0T/6iP85hrXtddQPMkLF25AF7AaMSpy2yktJirjxHCjxXTYO6nT886p8Dv0DaNKfaF8vzO9c3JSKS9QSsr//bfSVHEAn1t/7EIaGNOnXG/SCFEUZUJmOwRUsOai8eGByhuHwoi8Q/IHCYJyZGvABDLfiVBVYU8pBJnP13Jseh3M7LPUaTnpJDXrtbhajAC3fZSJNlsMaqh7WlHdCm95w3PjaTaeghvgg7R6ESTP9YomoJZbGBZ86crbBEZ1uzbvfU/lWBs0bD+va41Gl1NeHifdJ4nEfoKdOG+/h61PgTXECuCkOZmJBYHrV20niZZsGAzZTKVjQCL/j45VAyAk5K1Ud4icA2wBOuV3oySC+yf2qdnVpSJql9B1RYjcGzOt1F7ild/avEwmiAkLKEivjgzi5FJ10Vkpfp2dIfBvwB7l5oPqmeII6hbuIXNDfuQRN3xEHz0qyiUYZYfbW2KGN3RsrSkOFH3Gpga5J/ZPyb3fYsUwOFbH4GSyppaFb0opIfc2pW7CLKy0jVgapG2epzLZq8EZ9DdidTivKstJLRs5gxQA1Llvy9D+6USA3Ph5kIDNtT0vE4sVgr65/huIKSDFVUNTVEET4Mk4+SIt3Vmly802s6v22Pi/aRguVjLGsEkK/qdJF6PqzldhzEbWFbWuhGV45cq2RmXZ1YJ4AuNUfgGwgPfFOPgYZ0eBkgMkr15xSjZ3Me+WW0KPLzACvivuQsNrRluA3hb3NEOk/YHF/Uov5hgG/eBjss+a4xwH0hWaP4xCx/hADoO590zXhBR3GLxUkPY/gah08nz+AyNqx8sfVtqSsFExd4YPpICjMCouxfTlzrHweK0HcN9elgcJe13pdOOJ+8YgXgULnvxEeePKumdu+Ts8IOS/ANF3ygOp65BM43k6K/jYedsz7WVmqo
 DsZn0yRS
 9KFg0j8dVCHlTvnsZBKwWHj2SGMFpDCWgojoNH3sXnQe59EkCce6dwHSjSm4IWzvHetbwaMno7khlwCUkWQfZaQzDzTI/0xpGxMJLhHvwAsx11ScGkNKMAf73apikALNJGObq0aSn5gXbv6VaLKgoPI+YkxPxvGlzbBxgRlukWWDu2X4UNwlW45r0/IH/M0BRixyPHs6aD3QtecLb92eLQc888H7+J2OJVtjS3fv/0CpMuUvxH1oUTAu2H+X1UjayT0lDeE7kohoywQslZLFrW7HDPMwAxoD29yjVnvQu65ZVny0+0opbjrQkoRXgZr2sY89r1Xc/RUZjd2MXBQqINsjEoA7/M7BsLDr8vkqYOOgXPzJco/f1aNwEipWriMQV6TzYGZmW8ELNjre5FUMo7Jq6LAY5S4xGQUUgTSfN1+gu7XkvMxj9sG0K9s5Fag7+VIv9oLPPsZEa11SO+yXUpkdqfGO1AwY9vJOd7uoJ1NnH0URFo0fSwNL+0XOEZBKYhsI2W5m6IqO2kGcq/oMVYLl7Y+KDm3uSATS8sfICKppe1iyfZ5QdvaNKWRCtXXfkFsxMXH2dxWVuf+Qwhxu1uHmNlDRKVH9jUcLcYZQXlNdMvTsUtq8dempZCLZsGOONFEb3Avzh51pWBGkWBu4p/1g3mtHR9e8u6KN0yp6tBd4GHGMP1TN+MTHubi15JF2ax2SJiBQSy23+i4dN1iJ9wjwsPw69ofOPC3/Rq2LOz67m76/rXVIAwX3Y+0EM7I3ftRCbikG+dLFgyeA9qvL7PJrIej4Q88siU0vWkHj3jgpZoyAvgIN0Xdt/ldxVShLnJqMFVBi/d/lww/VlX1CtKFB7F2YGn6xn6KoEtgTDo1KkpqBQJOsK1vncdGgeysJXbvxm/HonvFg9gqnfBq5/8HQdO1BPHT5sx8p4I8683erzkDuIB025OZlZYg0eT/etaD//f70MYa4h76J7a74QAweqvEWa
 3Nq8tjg1
 jaKYBUWo4YEfe244t6Uf6O2CH7KS8Jjm9PvN6dh4GWGxl/e9A+G75hteEFQaRsJkQYRokIOgNDazxc5v1PXbdfTST/6g5nXb5JWr7MG1UK/36WvubloyRP///SpWPTI8hyUWU2+ihuTz8K8PIgGvG0xkCMQRrUn4ekKnymjO7AWsqHueEgYo/EpEqNIXZn7Lazh58epGiRTsYo+BKOlE3a2zKc3PdQkStc/SA1LC35pamH6/DEoQ/TOB3utt2EQxp1b1B90Tcv/IMltjB6SeoZYy158FO8Z5uMJJm1B4zZjBmlTmEni71s7yGACjH0zFT9c82GFii0eFWa8YL/05DZRIXK7i4AiXICxG1SJp+GuXLJwdHy8+bfmZg7U9egsez1uOoDeHdWzLlfTc/fMb9BPOA7GALRQApQ8+DTGfK16vWU9936mpWeV1jASc9IlihJDumjEypp43Iv2BrLsVSkEnsnookW7AWoDShuVC9/rEaMrObWYXfBcakjD0/9+rEjSOAd9SU4/hrWyqXbFD69qlm5KL+BjkZB+4XrJ9Sg2QPxjxS1d3bZ3RX2j7YXr1fWFzSZZDVAXLzIyj4tQ4IPc4xvFcx58VvcAdJw5A7LFU03pKp883v6wXmkhBFpyAtg+E1GlRh++W9Ih3dRdW7sJus8khIOnTtQX7WyztnDtiM6y4Hn4SwoshKXqKB4Y6Efq+ADjRPbMOhQkRZVSUXUHb/GiWvZ5boIKZqkYelV+7LskW4f5EbuPKa4kN1uR6YJj3zEajBSb7v5YMiq2wK6nOQH5lPu1u8BX1Un09LShd5T2/928tJRt47RWWytNb80Y7wjY/JVT/8AWN1oy5QNgOeNRDDDrlPwGjOLacKRZMobV9yIhKHdvC9LqfGii2SXECNOJ1zR7wnNlSCo/yun5WyALhTpkLvt+aGYh8Ce62X+wopkkqFkaV6vzlZxt+tTN98+wMcQgacr5pevZ5Vg8eWWKVv
 ZQTSykon
 xPQqL5WuPBVs+t8mfeSRmUmVs41/C7W86oxkCVYZuoi4otplEsjLl8MrTWfUmOgV8LZwVDffSBD6oczBnjSbww9xai8q3869hMYbb/Wi2tdSsIROXDLnOXXMroG4yzl7+3Rtr7zHWZkuYXFH0g5ujF8+kBVCivRSU0jR3HqwL/yYB1D+x3gTxAoMPKhRj5tGbKhZQfp+HV0WMerXMfLtaEQJce6Wjq4e2kB+up0YxFmlxSWNT2RHh6dm53FelszUdcaSTfiJas0e5O4/WhvXKeNjcD/FhkK5u+EGKLHsu7kJ8ixdlmoKmydpqjlFEzONXNACwJ4ndqum4hkw5aEmH9Hsnt+yKMjpWD2offA3mp3pbT+CkHpwhSfYcab4onik5BBF9fFmbwaftwe91jIDDtuD2+2ydpn6ZUWHhbe6vMnA0jS1cfaCZ2gwtbqjOGopjx9Q5H2MzTkbsMTj5Y3jn9W7P6121QGnyPzLBW56Arj9md0DcNCRNEGhdaCQTqw/MCpbllzlyGtmF4GJaAqhTnEyMD4o+oDEnroqEkJRqvLogzzMOPo8cTBQKO2ZU/3+2Xw5X8ZFfYfo1JRKccvcL1+pJ0tY/TNVs7zwT0XFV29qKATrtDO0k2zYC7V6SN6eV4D8kNInEtkye42v+spwt4sSR1bqFcpORRat3uwbIJ7D47CZEMk8ZCZDEg3gV/pmLYGNJ2fuia0I6QZIff4Ujqcf2mul5GKMRibYwPGvSULgNqsh4VsOS/Ia+NAqnEucxe75VenAy09DBYghF8EHZq2tN6B2vvwaFGvvPCCvX6Pjn6uIbpMJ5PufwyjwbDwUCnEU87dK+tptO60UOZ5dsjyLl5Iabgs1eH1rdiIEJaRaRD4NbAhn1lyTYllkcn7aKXSNa45+9R4tFyb8bck6uitfvKDtdHhH2LF2YzDV8HuEfUYf0oB0UY8ZcdZijBLzq2i36L1HXAp1XE2OxJnJMHJ9jtb7w
 sETUje+x
 TMJRPVLxoTpOkZJMqYPMmC//cdL1L5ZhY59hKNpcXxH+OZIXeFEh4G+0kQh/fcWiJ4+lxnIT75rJ4Wy8XlQdLyhtVAvOZkqTXj0bTmgAjTmbi6vcAHPLCz6OAPBWjInI1m9d1SVUrVc0YPaIZJDpXn9y58NQVBrfeTFjy3sD+s9lO+jeuZnsSzshtIag+5YxhIR2PuUWUGdbLRyGaBARp72dMNkS7XiihvWLg+9pIouObWeJrPp+lhm6PAgSuEobFACyEu3tIs/kRm8L5m4GapAOVRhTY4YZ3iHo07Zck0qo2wVtZOALoMK9WI07wWNr+7KSEKgOOHYQh8R5+JwI5Y
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
index 97567fb7ef33..2a90c509bb31 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2866,7 +2866,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;
-	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
+	const bool have_mmap_prepare = file && file->f_op->mmap_prepare;
 	VMA_ITERATOR(vmi, mm, addr);
 	const pgoff_t anon_pgoff = addr >> PAGE_SHIFT;
 	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_flags, file);
@@ -2909,7 +2909,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		allocated_new = true;
 	}
 
-	if (have_mmap_prepare && !map_is_anon(&map))
+	if (have_mmap_prepare && allocated_new && !map_is_anon(&map))
 		set_vma_user_defined_fields(vma, &map);
 
 	__mmap_complete(&map, vma);

-- 
2.55.0


