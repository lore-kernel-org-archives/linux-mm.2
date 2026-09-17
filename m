Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C029DC982D9
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A3D6B00AB; Thu, 17 Sep 2026 12:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19D26B00AC; Thu, 17 Sep 2026 12:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B017A6B00AD; Thu, 17 Sep 2026 12:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 856596B00AB
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:26:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C51C5C03D7
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:26:36 +0000 (UTC)
X-FDA: 85223782392.24.37600A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 178BC40006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:26:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D8IdL7ri;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WNH4ajOGiRyME4gV0hKpqyimaBUBR6xvgBKJbfZQV4=;
	b=FBC5cMlVH7K4Tl2MRnItdQFXV/Cm4mnzCUjSCIKWKFrDamedGaB5dzQZzMl3VrYAw6hwTl
	03B3illb4AftSjPz1yAClYIYCeBBOJJMl9ZdlH6EYQ7sK/hk5s2iWfPlfWaOKqnXoAwLUL
	SgFigW3N2EHOtLjfBm3HOaLsaHlV3ms=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D8IdL7ri;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662395;
	b=CUxLO+tUVyB/kT7HdzonL/E7VRu0EB0aAToneW1KLt+OIQ1zNMs1ixYGEQ2eg5CwCUn/gd
	zCDbVwYw+oK5tnMCoLe23qo3Nvmu16Q/TT9RYYqSjZJLxZQSKTtkMNZ9Y/zg+ry/IbUieP
	Jyi8gnHDWF9m5UcBO7nDXMj1/WZvOGo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 873C1601EF;
	Thu, 17 Sep 2026 16:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E521F000FF;
	Thu, 17 Sep 2026 16:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662394;
	bh=6WNH4ajOGiRyME4gV0hKpqyimaBUBR6xvgBKJbfZQV4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=D8IdL7riodczGnX2g7Ly+2X6aSiAwz4EPzGrUsxSBrMPJJobLo7PYqAj1ZR+bimYM
	 1vu7lCSys1fJJVkf85oR6/ZuSbQ/tbBQLdX3ewGiFk8JZUxpd7CwlkH4b8ZMJ8lIi4
	 TwxzSbzqRu847qAEUbxBRSHhV6kJqfvGJw9qd9GZY0XTjJUOU7SZ4ibkGeS4IzEkjz
	 Zs0/arTkyh9T1fDD97IlBz1yW49oyPFEDmAQbrqxOxsVNNLtswpJiNgggDx8CeF5oX
	 2qPEd7di6MpkeozZynKitl3ZSUJEmKidyX66JgD/6HIAgBBZdksmlaPZeRoqMZ7sTn
	 dQbbKZaoA67XQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:16 +0100
Subject: [PATCH v3 07/40] mm/vma: tidy up map kernel pages enum values
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-7-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3944; i=ljs@kernel.org;
 h=from:subject:message-id; bh=HY4Q3Cfycqa6fp8N5aZLFaoVFjw/3MQxTeg608Oh/QQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCO+fvuN7XXp8+tu63Nwv7b77p3Kb7Ji0+qXaO3aZ1
 NVHxSt1OkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAnCRWYwMe55v7PZcHOa1vNd+
 /urH9pPPR+2tED21/JY7N8duARYTZ4Z/2v+2LFJ1l3V/E3DxOeu/LLFy/6cd96u71Jrkvn7+EZH
 MCAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 178BC40006
X-Stat-Signature: so8dk3jny8rh798zpnmjkrfipksimyky
X-Rspam-User: 
X-HE-Tag: 1789662394-751345
X-HE-Meta: U2FsdGVkX1/B0lGgvrmmL5lYMj7bLci0DDbB4UbMYDffsGf/3PrFPVteF9AyubOqpSZtZ8+pymtCjQ1m4lrXsZQmSGz5TiQd6WTXKvmrZlEM2Jx3L5sWJ++U0gomaiUiOiK86gzIAerHwjxDQLozYy30Tk+6xf9zJ6AvV/E2WP3xfYUQ4sNkzwuYIkiSKEtYuonSldGg3wBgVXFpYy9ETE7xb1ZI48xXR1E/SfceF/5RKE5Uuak8hi8bu+x/wbkqnyai5s9FC3uTgxvMBYMIaWiLutIUHMoErvJKEetpVf4ZyE0k9wAJxiTkMaAATnXWM+wsyNs2HqqXFckeyKYmdFZ8DDBDecvz+O38JFi8DAgu/j3IGEm5cGL4Iy8QvYzDgkU8mqQucK3XGVThwprIVzFhKvHPybN/QQpeW1t9pBF7CcXREuHrUrRHMjpjZXdQb2YLDmOe1BQ/d//boSihODDrVOD+6XJ+MmVr1ThSG2en4uv7nEZurViKvv/wYkrnf/YocDI1oWNjINGzleLr2aD+gtoHF0KVErb6QUo6wWxIvy1BXti9X09Wtdar5sGahvN3BlbXVpkLbEkDkOrpY3oM5j3ukbfnZLkB9b8tCKFQnFXODQy3CyirGPJtdo5GcpftBvW9lgx5RCaKOnRv7VLEO7Fe3L0jp8YSnXLpvkLNerh7Go2Ln7SCK57H7ciD8mEQ3Nv0iLU9bOEM2FC6++is28X138/wJqGwv5gk2Go8EK8t2RV1VaHge8q1isPhP32mHXehASaKvCcDTU09735gUvj7B8rtLI7gxHhveImSfCPcucczN60esEgBEKvb0h8GymoT4Qu6iml9YMdbR+DDlhgVDqrfHdd6e3NiKKhVV2Eff1tiGFxllWNIgUDQddvWbdwswZ5LSQGWHWlxsSatTKgcKAeWwa5/OeaBNyp0Le3sjQRm5EtUhRZLgm01wugCNQ6fyRfeMfD1TGH
 1X2YteOo
 8lDnbDcL4Gvdztcko+iM8SeB99rGNM1nVQOzQ9E6txT3DMXr41FIlVh3LG95U3rJ748Dl9ui4ERcSqynedpNPm+HC+Ib9UWNMos4JNS/3wbxbN6OsPi4Iwl6iYCzklU5oR0w8KAUO3KHYXK2PmpJFBrXKeH4uFkSaPNb5x8iC7A8G/flb6Paip5Xz5tXPONEeCl153aXxds+S75L6iYbN2SdDnMTnmmsrsbwWAKTNArvliBAjx8CrA3Sd3Xknze62RM2Wxbzo/m/vUevKTvyRjb/HT+Ed210ChlshOHC8AM87V76qV1OhBvQ61pQQBsnK826qSnRAOFrmd72YGo33KBw0i7sO/kcZMjpJKx+IxBetCouzAA9XY8OGSHP8Eg6CvuS72F0HHEIPXORdqb/BiSuc1W3WgnqDwvT0omIE17cXKg0zv7BwShiXY+7wAMY0xU2kDG3wqYMFeyhX0BFLdlPrEj6k9kARlp1ZCgJjAAPhI+TLMj11h/krRb9aFA671AHRu+DfC3bh8gUyQTupu9eSn5mx8zrJOeXsUv9v8gYOQHqlGGwrL9c8kbTVDSfkodbuZOmcV1Y/D69HIpwF7mGv+3eAeTr1CLRLJmh3SORsXyU0AMXYTNUYZ1p+I50TnjphUHTg9NhQHxjwkk6RQG+o8XNfbc+ad6GjOdGBquH5UY6JpJShIW7TwxgkMVEU7dr+M1ZhC8xsqSu+hJuOeYY4Z+TwyTFf55z+/UXo/F8WjmuJYpc5KGumAb5eTeZMkkIksjnQxg+Peke6ATbrBMyFTyiYHBlxHE5nMHu56BBiNtYpeIm4SeTiS5i5Wh5Si0KmHnGYba/UxrvBQ5sArJthWl///h7UVDefOL5n9R141BdiqUdt0YX2vVsOkuiKcsla6nWcZG6sT1gG/uwwbpTol43woUcsgtazbz/S0v8Ynby4oKUolzOFhQURWsQTrwolFqdXH21zDdl26ZBOPGA0lSBO
 YhSTeG1i
 qTxojpcnWPNnHpHNcaZ9j1ngx96EOzkL+taNo9qjBcpnhD4DqV5u0CkFCyx5EmwT5B+k0rU3BoNKQqKeDBaybkGEM7YCJr2ZND7Gaye5y4KuWxp2kPE8tb7uukhWHB0k7buh4WkMQmZYMUw5TW8b4HEdeT9/sapqdGPm/6hE8ekvrlHjKeQTk0LU89welvMUb3jD++JKUWSY7pg/JIWw5u4h9HlSK+ww3YIcS+aIyRaidmNzhMHPjzr5gazY2NLSmJJ/R4YtiOjtfb4lsLeyjmNAQ7k7Y6krg1WGABGxcWMet9YhHyruQnBom8HknX8h0u625iQwa+MJ+YLZu3uVz7fdVknkjyejH+u3bFPIPWLB0IgCj10tYIOMefxe5bIv/uSREbwDp1oyvwOG0MirJ1myxkh4HqMxBtkUCxI5sav+o+F/AdhFsw/sHGgfAVIrkfwAu71gIRAPQgj8XrJQlLiQkpjhY5J9c4pxa4y8oXAKKk03MFYEm5eE2LOocqLlHO3Yh+hWmFUOvGk5/xKR0rB/hmVcJ67qYfWTP0Cow7ILnfVcPwYxovmKVA/Dd0Yz4cV+yGAm8Wvh04wqv/2pAvskb1kRo1iA9Mx78yaIspcFjZJLgM2QZzHskFMPza9L1ewsgBy8BDColRv3IbyZyHSY5jOznzY+9WGqjomcv/VNsDsvCguiR1ekRsOA6YFjZ+fqwTUiRH3bm1mX2wQgj+/Joi9YNljpP5lpDymGmLgEW83AdtXfSOoIRLExWQbGEV8Hn0wyk2YD9xLvzBQyVldF89sPlv/ASXLiBHJ/gDVUfW9fgFAHhQ05hySGtdd/lt8xy0PmucBbZuMGWtE+LUAeAh5kA/XfJDVvuhdaxxK8RcNKpP2+mZ6HUyYJWD2B0a7+IpykSkLicZcpw/THiclyNA/MJA/QRqj1jLfKGqTK07FyfNdVUGtAIAtwm+E7Zs15M1AFvGbR/lc/as8hKLIDME5DD
 Pes84mH3
 BV9yyCODx+8rlp3alPCWTmXwm4CVRLXa+MxB/FcElKSpK3bMnYgkNW/I05dqtiXVS7vGXS3uam8Zms6Jw4g6pA3xTNfLzhKb6HbdYNhYGIYUR6fRoI8AIl9XKUNYL4WX7h6PYpzZST9q8PPMLwRF94T3CFn/1UPzE0DebqS9CShfp/tBsCjU+hNvZ9MEqSxSHl+Qvh20wNWe1JkCZD7a4AYSbs+oDndsy68f+Ry7xvlnwHANY4p+5KKZQWbwTBuU6A2GgNQ6B6jSD27tMRpcrztIDF4nY0UwvJPGe6WBU30dr0M8NlteDWHz+rF0okLeW1DlO/TP8Z8xvMFRe/xsQiU3ntKPIGdFdKLiSpEBu0F0PZqRCd2AVcPJ3E0XKQcNBZS/+ccSzJikzTpO9f7x9GzJ++OILXJaLaqq56zK3DJT5J0Ha35yjs8AIv26PItYn+uKI/R39ffxPW/Ot1XMCNbWOjapZPY6Ivr6l2Xp+9asAZmHnvpnTEnxsZLyYS2Noyz1haki+C6aZz8cMrVqHC+Xkm6l25/YT63MJCvbcTBiL4N3fzmzfCpcCfNIcdj4wBopkBkrOIsDuxOgW27sv9NFYtAD+8U8SyNMaZSfT3ydyY9CGecu7uvRHhteDm0vNDfFh7RqG5E5on6iJTd9kVPtoqVZaTab4OVKQqXuL9acwyBknnLAEenmVxeJpBZr+HBICLv7fiiwKuhXY7qplTVHWFhdcetWpOgMNJqDNPe/caSl9Qme5fPuPXZcs6Km7aZnDV8fiDkvQJa+ju+1VIh1/ftD4EZlPy8bL50LmoKChVOCcl4EggRsiF45nx+gE0F9O1ncLZmSnjP+GSYqRL6tsEcorcbOxDyqzugs+KTWHzkhpKpAcTBJ5XE1yGCi0pEcg0ivZxiV8RifFkLjc7yTPqoLKFvNYCjblFJvR4GnqPjB/otEhE4NLRkjYqR5f4yguuyI+obMrX9KvRtBDNpyfNt2A
 tEfNmP8l
 YH46h3SVsGP5Vxr3lZ0Fj1Ub8dXVwSOIhGT31KQLIRByEf8xsiu3pvRN4t0IqCG8GLvS5UdrcEHUNgWRBgQsQ9a2+95Eu+LKkVhfP2I1XhoqWFrAcJrbxIYBgAkpRLT7pKWPuTYD8xrMzvHH4TN7pbVVzl2OsVvsh52CZhJ8sSJ1n7YFsaAdC1ZN1xeQxYAq+pAo7iuo97ML6DDnW3EnB5EBFIdi24WQ71UcKkjpMVo2x1Ty/5ozHzUy8XPDZzRPhJ4wHfTBck3nf4WInu1V5I6DsRlF7ymGOUObD/YP14M0Thkh7NvCYvKDb7QtKD+N5svrv0+gVQyIVRRaNOaJXg3hq0/Kz7ihkCi0SL1zmWMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
MMAP.

Also while we're here delete useless comments for mmap actions whose names
clearly indicate what they are for.

Also update the userland VMA tests to reflect this change.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 2 +-
 include/linux/mm_types.h        | 8 ++++----
 mm/util.c                       | 8 ++++----
 tools/testing/vma/include/dup.h | 8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0c17f0932b76..a1f2d375cf7d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4623,7 +4623,7 @@ static inline void mmap_action_map_kernel_pages(struct vm_area_desc *desc,
 {
 	struct mmap_action *action = &desc->action;
 
-	action->type = MMAP_MAP_KERNEL_PAGES;
+	action->type = MMAP_KERNEL_PAGES;
 	action->map_kernel.start = start;
 	action->map_kernel.pages = pages;
 	action->map_kernel.nr_pages = nr_pages;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5413bd10fff2..9ca2ea3664bc 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -815,11 +815,11 @@ struct pfnmap_track_ctx {
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*
diff --git a/mm/util.c b/mm/util.c
index bdd5923eebc7..438170490e7f 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1467,7 +1467,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return io_remap_pfn_range_prepare(desc);
 	case MMAP_SIMPLE_IO_REMAP:
 		return simple_ioremap_prepare(desc);
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		return map_kernel_pages_prepare(desc);
 	}
 
@@ -1498,7 +1498,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 		err = remap_pfn_range_complete(vma, action);
 		break;
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
 	case MMAP_IO_REMAP_PFN:
@@ -1521,7 +1521,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1542,7 +1542,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 2986ae6ca1e5..1098655a5f4a 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -454,11 +454,11 @@ static __always_inline bool vma_flags_empty(const vma_flags_t *flags)
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from an array. */
+	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*

-- 
2.55.0


