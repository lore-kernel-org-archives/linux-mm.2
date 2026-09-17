Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D34BBC982D9
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E88CE6B0095; Thu, 17 Sep 2026 12:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61206B00B0; Thu, 17 Sep 2026 12:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79116B00B1; Thu, 17 Sep 2026 12:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2BEF6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:29:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48FBFA0443
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:29:09 +0000 (UTC)
X-FDA: 85223788818.29.AF584EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6B16D140006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:29:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HypnJxB5;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662547;
	b=MuBXqn8+SdbmL7qLuw8CBs3oPQ0IrnEknhs7tucCp/3FMlFGJR9h2xJn5Uu15DSjpE6hmf
	KRoH5QPOTjSlG5oQDtH04OdXirHo9KfG4DXr8pcYYCst0b7Tf1YE4Y50vavku3N7WfC6W5
	VSx2zpj0iwRS11ouGlXO59oZRdXdwwg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HypnJxB5;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qivR91Lb5/7S8p3yp1PCCxRNqvAnmMyhYSRWXpH7C6E=;
	b=sO6x0+6AKSAMzts4Z4cYCuEMjt05BwEr3aUaqoUd68i052DMUXkKKAl5huQwrkX1DbV4+w
	BpRD9MlF91TYzHB0nWCc1j9/+Fr9g1MeYzcCA4jQQ03A2BuhQENjNArBLHa/b1NGk7POKV
	LX/VjkWIHhz4eLPmMBvTUoBGOZjkJH4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2D924184A;
	Thu, 17 Sep 2026 16:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE821F00898;
	Thu, 17 Sep 2026 16:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662546;
	bh=qivR91Lb5/7S8p3yp1PCCxRNqvAnmMyhYSRWXpH7C6E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HypnJxB5nIvhdu/4lyn5V2mzaHKgTstFT3NwAe1e5+ZqghSmo2Hj7mjOK5CoYdPTx
	 PARyOmBlb+YzHiiTbiLYqT+yzZYIAG1LQnY4c8bg49GVruVJRAH7a6NjefXjko9YKe
	 9r3cgnvRiFC1xOnahoCdXU8zbumCPYOfyFGs4CNmNaflrU5KmEGeqQTv6WftryliCv
	 CRL4rfF58Fu402gQsvBPnH8MGc7bjyLyzMq12dc+KlyivUJWTpRdYhUPAbO0MiuYkb
	 PKD1LFiaRtReUNXpDsNBS9Zzu0GWIjj5xX+3hcbxhXXBLaGJKY68gTeOSmcn1LIJG2
	 /RIfIU50StAcQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:21 +0100
Subject: [PATCH v3 12/40] selinux: reject writable opens of policy file,
 drop mmap shared/write check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-12-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1924; i=ljs@kernel.org;
 h=from:subject:message-id; bh=X46vXp5xg8nLI6IG+V/Ab12M7pEZi9uJqKdEh54QAaM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB/4+lNC4kLT9Xfr2cNNWOx/bZBxCA3lc/ddrff0/
 HctqbfsHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIwDKGn4wMy14xmso2pPDv
 D3n68b3oKp3jKyvnaKX67T30WCys7jQjw36LHf1Lmqed1JoeuUrratDu63IFu0+J/2G76s1hYfO
 rihkA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6B16D140006
X-Stat-Signature: g5cy1tgra6ahr7cihpnoj4q19k4q61e7
X-HE-Tag: 1789662547-217193
X-HE-Meta: U2FsdGVkX18UrdtxqCk4sX00JNHot3XlBIDiOxcdGco321quvyIj8RSIIe4+zw9BU0LPrFzvc2K6hJz38Z3KlZGfzLb5aEN6eXoSSog3hOv+qEl0ishOtUYOc3CveXhgZ5ZyEhY9hrB0dPoLY5jsnGudnMNrPKhrd26LLfQOKPsh2BkA/yhbj0tySdJntqktYf4djeEAXyJstQCjJxPbhYrFn5de7wJy44hF8QlCGd9Vtryr/p+LwWHcEWm6OfiQX5Fyd6Wd04sbyB4rUR9XCQkcQ6MKzTYtlIoE62AqksDxjgx2iT7N8jQm0XDSWFjFS8VbOjtogA1Uh4NUTQ1bchTl0MLdOIYv+U9/VlkEC1PmgiO7buxVyDfP9dDbkLncwvenXzvDwoWj3PG0KIuS60sHcn2NJXnAK2S4EBux6cpoSrJeOZm4kxKssdYRJGZgTug5Zzm06/kAiWSRNOy3G1KwxGZ+T182XgMehRq18dtZ4NnJbdjlK7wVw/QsPgipcX9VS9CX+0k9CPdbol1YsqeMbaS0ZG6QtFrcL0x+QRK2TN+YBlPGFC/kM2Bm8n09+2ZNIg9u427J2vU8VwTf968KS2IE7xogFyMCUmVLEh7oO6yQjpea9Q1p+yG3HX2Nhy4pdS2jCdCTzjexa7IeRXWG+yJyZtMFlm2mn6K2gWOARMA4qQRgzDvbOBtJXxBlw2KQwYNGttVJp5DCgFxAFxZuYpmuahUeoQIjTwrekR/9k1FRzHZylWKZkblmIS72uNP7GGSfvCQVoTJADNXYydGLkr4z9bj2o/91q8NZc/mqfWEma+aB5REmsKUJBRRLrmIfBANhHD5IP5jja3yMu2F/tdIhtzdLfxSCBOt7LpjR5gPyKUNtnChNdi4bv5fcynFNSVoJTlPNJk+1VGZucemrq3vSCBxyOhPvca0MGy8v+KHnhkzbPKJD2+KAPzXS3wW/F4PHrFoOUta2fJ3
 y25hdAuR
 /ZT3looazThofJkUJ33B+W0dnbicjHE5bgWQhpCpBLbnttzMLPiLSdCbuZOS1dPM59gZGvHASJguuzmqtqdCU2Ion9YK2F8PYUmadfeWjz0ddpS7h8NeschYSNDmBexCyqzyCEC2wu9thHllk+9nbgA8qgoGbL2EZaZGI4wggOYdzBRzE2+lDf10IP0gfhRcmR2bDtaSsE3PiHrAbOI4Pc1SZZWMZS6VzXrAa5z+27W/gL6hPIcbovTaXzKId7w9sEHlIKt1TDK4HpTbEDRjMSCiHgzlyFvlszqGUe0ut0uEeRL7NZEMkPv7tUzGgBJh6QZr+8cqbAXMs1O80z4sqAMBrmUS6kr6JvmIFnoUdIT14VS2WY/HjwfNQ2wDj+/8+e+pdIl1r5eOj5KpSNN+dhO/42HFwXocyVUXAuS6VyAGo7jMPRsgHMzFeL4II6E9PuZHZc0IKTHORV3iEd3JpSveuLozREJ3C1RoEH9j2JrebWJUaZzpQeifjuEqnYzAqImfGPcA1DR0IW2eC8lV6fHnIzva5oONCgQSkuoOKQYzba3T79BrkiKsMnb8XfePNBXmHBuvM1DA5qVMKG+vFH7J5/hB1wTl67sGezf9FjyT6wa/pcy1CLwFVTzPeKAH4ORcrjmZ0Hu8BK4AR7r7UEl2OyTCi1o5RBGxDVxCrbve0GlJGyH915C8Ze7/QbyvusY+HbdXi0s4zMtCAOx/iIXjZA4hkIsaJQBQVp+HsS/7N9na37O7DRe+p7FfJj3C4cQy4n8SYyWbeipELSvQmho+XjwuVkcK6rh+CxVJjV55QDvb5Dqh11eA2V+eBcj06FMtrz+aQ2YDbM/S9sZyxrYVs6HLD0NIqiF6VNOYAwKorsCPohIpd0BPEu4tiLeEFx4cf3iy0b4apTIqSxAGxh4OKMMaG2h8arDkgvRZFb9w5I9x6Tlwlu7wFdhZwsyOQtwKVVZDrEWXiDAxv9zAdTuyURxRX
 EQ+7UU25
 d4YYquA1LyRJYFSC8gW1h3gOxucnOw60Jgyry92/wVv7qVw5yGPaNqhS5rO/zshmw2BDnxwUmnCte1Z1UyJgxKHlGgjPPjWHD5bn2oQT1qiF1PU4vm2HHSkQAmDw226HgHvsz6F4yEx8LLeWCb4C152LVAcAkMx77VZ6SCmsZGWCazw5cPLcP6JjLN+Z5ftUS8oaKKPdcpneULImkQmnkcGIQGoEvW1c/5F4lgEEN2uskSgA6n/kzfbBpZyxRkqCgY3uO7WNZdI056jDMWK0t6dmHlWajIoMe5gs0iwaB83UvBPAW5qYgJau21yCrdcBiTqGaQVSihCV8bUQ/V17ljcGgJUjFMQbYlmVgT/DBX+wd5J5W7A2sQ5zY4V97NdfTU3lXR8DoaKGql/H4KdmQ6Ogr/3vRDzrG+TlOlNVvI7tFp93r7oi7tjYTjIb5kWj2Hczyqv10vhGDY+cDU70flOiz0xasjd0p1evWrqM4fn46zvMV1Kd2jbcyDRPg/760MUZokkguQF3sodI0xJUsYiqA1dY0TwhiMNnmhqr8e4YcLiv3DnpErI/e85qPjRKx50FKhjeFbTuvi0Ueq0u6oe3o1XIBpLpiYfw8eFGT3h6FnqwKbLYs0leh+ZCwBzPNbQcQARSNPqrdnPCItWefV3NeQuAg9tKjOMqMwqqD2Tj6g0Zw43Tpc9R5BdxTZ6eJ/VuPTfnu1gnME/4sUtLrBMyrDMfEe4MwhliNsMQdtVY4hpMwGPH/Jqmv3CjYMB04elJzHUMyu9zxP72acYZIHISUmIB2e/ONJfUFv855ys0yNTtiXL1oaVfup4KA7YL5OxkOdnJO/hk4HVWhGAbioEgY9z3BWip1FLGkTvD54HKTtP3hluay8w/EFtJp/xaPT8HlUNJfMZ/tuc64+sl4z0WRR63pZRNbrcMCia/7iIQawq8ByG3JJTCr2TQS+e5g93gp+Y0xR3MMHECbQloaRt3d5IhZ
 I8nzGmkC
 AJ4ckDuZrE14WXnQ2t+qOL7ouOoEJddT0BxxUEApY9M/RpK+j0koa2GqRYOBENH+4P+ldQG1j6AK9miPpABQgorqVzKqTEPB6n2vhM4E9vKyI2n0UekJDpr6EliFdF26ewDT+W3ir6s15BIO5WTyk4mAdWxUR4nbwZcPSgcE8KkBuRdakmeVUR7jYuHDVLUfJ2fNq5NLoLt7R7afc9Pb5Cune/SZ+C6DV5U4xRmvmPykbJTHI9gcy/lmz36ydu6bCH/zMgwCEzF15X3lL5RLNdZYUuSztiPM6YC2VlbLPtlQSF4ar5/b4F16Ji18VwftgnNYFR8j2z/t0zK0Svtqto6WBqTb9ez9Y3BP0lMwFJ1YzgQuCPAJ7m0gpvdaRL4Q0LIwk4sjqmwh24PbMU0NU9/aYu1i/h18KZ0e+RaOSbDanpi9gZkBfagOk30yZWvyoCnIk+ucmUEBY1Bno2WDuS3B18dgVydZ9VS2wBcfdH4ZovWvoTfTjA2+C/TdWECXnEoa9KXE4RTFAt2iggynsIIXvons5Md5tR+YmAsmudd2nK99Q33J42wDbGENv+xUyg/Xm+sjrDPBYsFrMLxZQCmo5YzeX/1JmI1SprlwhSw67aLqRRvDQpvVS6u98rxafJvWe2o3ZjXGtQU8DSlJMBbat7Gvmc7bHCVT2CTxBvmftT1rcv6BY+R4QIt7nLIuEVzoZb0dQxPYQwPwXwVB3L/Bwik0oUI2rHfK3BaZ1cuU3wJ5ULw3wce1bV0ETE+dVAmDjnHRB6CeHPRnaxvZTtdbA0kVXzVFl5iEaZ06N4HgJREvlBXjCq7x+Q23Wda7KBAYQaICRuvo3lBXGxdN5egeYIXCBBbN5joQ/rrXm9idxWVd3Nxgi4E9RYDJv7i6OOU+ScaERjhUNl1OgSk93JxX5GNm7c/MDo8V4NXolvxk29YmPA/MpMT7qrWFQxBRILyiIiCm/B37Rg+MYMbBRBza99GYZ
 TXthEcA9
 YbJVFfl99jCkC+rMM2FcpXf8tpS/QbNslo4imnVCIBt8hqtRAxrF2462Y2M5mi3A4edN4J3NtEnLfyiy5QMLRdIcnPAMuBlM23g0KgGKWpaxmK4z79zpOCjcxtjqiepSgD2RX1nlaIvxgt4VOeAfvLGuVY3ayUKZGnPPERjYy+++d6BUynP147BTGp+DE7jjpenoEYNkCY6VshI3iCDaTu1o+Ffww+iiKQYIlv/HwjkehJ0DhQ7z+B2rck4Al0MEZqT8umFO5nQIJoP99fheVslOkmOUEHRLH0hc+eR5HEJhKRrknjrgB/kSAvTgFxy9agficd/psdkAiPmtNlQjGVoKeslTQmhAF4zJvwnbqcYWvGmrsduDxWgAGfn1GgmYuFzdH/tcwKow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The policy file has no write method and is exposed read-only (S_IRUGO in
selinux_files[]), yet sel_open_policy() performs no open mode check, so a
CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
kernfs does.

The file can then never be mapped with FMODE_WRITE, so do_mmap() always
clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
check in sel_mmap_policy() cannot be reached. Remove it.

This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that is
neither a PFN map nor a mixed map, ahead of the core enforcing that only
such mappings may do so.

Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Reviewed-by: Jann Horn <jannh@google.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 security/selinux/selinuxfs.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index c7d91476971c..545a6f89f9e7 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -340,6 +340,9 @@ static int sel_open_policy(struct inode *inode, struct file *filp)
 	struct policy_load_memory *plm = NULL;
 	int rc;
 
+	if (filp->f_mode & FMODE_WRITE)
+		return -EACCES;
+
 	rc = avc_has_perm(current_sid(), SECINITSID_SECURITY,
 			  SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL);
 	if (rc)
@@ -424,14 +427,6 @@ static const struct vm_operations_struct sel_mmap_policy_ops = {
 
 static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_SHARED) {
-		/* do not allow mprotect to make mapping writable */
-		vm_flags_clear(vma, VM_MAYWRITE);
-
-		if (vma->vm_flags & VM_WRITE)
-			return -EACCES;
-	}
-
 	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &sel_mmap_policy_ops;
 

-- 
2.55.0


