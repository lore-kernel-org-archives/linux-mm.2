Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 173DFCA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368466B0095; Sat,  3 Oct 2026 12:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318696B0096; Sat,  3 Oct 2026 12:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9EF6B0098; Sat,  3 Oct 2026 12:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF2376B0095
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:33:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8098814096C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:33:51 +0000 (UTC)
X-FDA: 85281861462.03.C4C8435
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id CDDA320005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:33:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lj/hShN6";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQQXLmuz/mYy2m0DRCE2BDh2jZAsmGDyji4q3SA7eeo=;
	b=FWIwve3ZWSDPCunzGnzDx3KqlYIbX1XbGS4cf1vWKHDOeCfMtfGtRS2CLcRUM2P+rp3pzT
	0X8eNJCgxDBvJlMp2LN51KiKJkaM9qaWLXb4jYLrPA25GipqXFYpBFdT9/VWoDdPXfdpYM
	3Q+gSsuXDKiQ7t/OSJc2KsNp81s5thc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045229;
	b=RE9RWPgQX/f2bm27oshPM8bhM+Y0TqQpTOhRxHDMtyVXq8KfLXJgx45MwMhrGOqjsjpqpC
	2OyFRCIa17tzpIC6bzzv0wN2rPTUudgPxfWEfvKt/fjIk2bbjl1EwCnX4aqs5eyDZo8shq
	9lWusr8Yj1lP9A7LOl/NCpezOeZuY2E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lj/hShN6";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68B9C60D9B;
	Sat,  3 Oct 2026 16:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599321F0089B;
	Sat,  3 Oct 2026 16:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045229;
	bh=XQQXLmuz/mYy2m0DRCE2BDh2jZAsmGDyji4q3SA7eeo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lj/hShN6gWOgXwQvHUbPEZgal2QtUCby7VPIwvt8lsCsiSGg+6Y87bl7qHM4PLWS3
	 CkEtqmEUsf/wuEqs0DXVuf9zQYTCQGLhW2aq9eiBaA/PUwHcFmAiTVMrPjArzj8sej
	 b4F4A9M/J41uV89M1wFOSxQ/EVUowujaDYlaxEF2yC1aAT0fXj0GHwcbrTsGOGfcBt
	 Po2M7eN18pd73K+NaB5b2gOZkRTYAQ7OPpI+f9TJjPU11eAxhFrq6XgRpv+Ju6SpzF
	 dOiscdHTgGNFG+Zs7OyfVPYzTGeY17pTNcQ/vjcnLmCHbFThLGFq2cLvvsjfRhvee8
	 Rjoitwzl+ARyA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:33 +0100
Subject: [PATCH v4 02/38] mm/vma: introduce and use vma_[flags_]can_merge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-2-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3865; i=ljs@kernel.org;
 h=from:subject:message-id; bh=EYqw+AtDKpEde3pCckMQkm9HGGlkplYL0cvv0S5EwV8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6qnt2PymfU7KPoPUxFu1eSfCNNjFXu/pvKD68nt+0
 +a6nW0KHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjInQmMDDNLfpn/ftzAfVjS
 KKJW7tXOLY0/ix9U62meqtx4tL76/BSGP5yzD0b2Fy78P3tpRsfZ93mnvvlahNzojrbasVf7Ytd
 CSVYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: 5y9uoy7z8s6c8wxo4mw6u6sqpco7bwja
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CDDA320005
X-HE-Tag: 1791045229-137575
X-HE-Meta: U2FsdGVkX194PJkCFT6/WPEENVP00hPuSggcRiflP6KW+yukEAKBhNIukGF37+lwlztjEtyp73O6BSu1LQbEAFRLookaBJCmbuvgP7yEbuElI+86SHK8CY1WqcWY8kDu3/vrbpMT6UZoz403T59dyZ4T0VG8dQi1bGPMPBV+L+bt9KRVkrzMlzs9UwF9TzrPiR6y1ZKt597I0tbQzF2vITFuhWNCucu6Dv6Q6x2Dtvn7NBA8T46k9Qh9Agt6lRQcUZ6tc8vzhgW2VHFK04a0/M/N+X2lv5HxO37jjelcGDG35joB282m6x5O2qW4K2d6LAFjiLyi471pG9bQ+wNmcnUTRKV/Rxk5ucc3jK0/Lt1ZfpFF75Rwyuu+6h0NOh7NbolYO3tyuStONxOytbnJ0e17pTFkYPDjJYwGlFwXHxV4tQ2DW2w4GUeII3i09A+mJ0swpkGmjvcVQDCHKn9va/YVwf70I45BIEGII4GX5aplAHoL89ztunOv/LcmkGHzHue60G/2ees/cvf+rvJSorRXtAums7dDiO2TiiXZrnVY5gdMOJFQYaTO4TW50lpx1UkxtR6b17X0hiVkczeeD/Qg1uyPQ0degKc9ssyG3MZg9tntB0wZdF6pMBT3aSSQBiMK9JIuVcoatfHLVf6rXf4Fmz/++Ru5myB98tY9Xa5qgH0k2lpbUltVOZZKaG6pU0BJvnG+w7D4jGlJnkQw3p7QOIIvS8Hj6bCtib9DVcY1zzDidu4/MTtUMW5I/lr7oxlBjtM3Q8vqzIQfjJaxPRWMW/yGjMEbotQ5UcL4LEMTZ66vuT90KfXqwVC6ldoPo1tYLqEQn6u3QigH7HZqGzqPt1upewfgpIM+ACEPMMQ3GCvH/hgN4Zub7yRkXw9yZbY7qWrziEBGnRcXHXb22OdRjMxc336cbz2yl4qBBFOTKOrPeZAaxAf/qWk3P8mXRKCFYCfLC/1CCAuR0aP
 0na2Dr5S
 Xp3Mi0mKNP3Epx2YHq1sqJSaVYAiFkI4aBm87wWUUWCBmra8eABIzogo8Tyzu9WyfC7aZL1V272PQKkt90tDFvs1yOk3k4vu0tD8w2IQHggbbVV1tSArilZKKDj+1gY0ng7HJ11YnuK4/ig4mXQwWXiwoYeRUKYpiN65yeDocJxxkxUAsCju+28XvLgoE+GRI3ZhQW2C84ssDWMsFBTlmsh0rvZvFMluEf0qMJN0o51iCBHBJegTvUvthBFYWIel680kzexvGFu4PrSMNb98BBw8MbTrI/N6yqWYMernidDK9lc4U6fig3vlM+88A7ribf6z6B2v+IB+jSo1QdYDEwdT14jXx2aXsfvzLtu+TKRmzQ2G0meEnm95aCkppfRtzk31B0wWSyIug9IgQr1nZPOSgVZlR3BQhyzE2i1nSCfnn+/CaauqFTAuC9fqvhUSKq9Dn7X/Os/xcStfvVnRUwbCHLUrdSnrYKJY7SCkmLJNVMk4IVtYiCkOk788QullYO9lQ2Hn3NkRr6Uhppqai5+qaQ14uGijIn/I25ZY1S3jxISIU3XHyHNdChrT1TVkJsrfOMhPb5C36RKdiSCFR3Q9rY++tGOGR3ESnUfkU0IgBSfYoxcZqFQM5lG3Ay07H42cHecTkN/a1VNlG5nMczXYNMXv3DSHuG0bodYvppoK9tNzRlAECuP0/N+1Y+SOwSSsUwkHbj1BY5SG1sxWik6Guj2xUcedk54TNnan3qp97RR9ei71++JsCK6XTeyC5siS88g3AeqNr89M56lDnB2xredleT7DZ5zGVkm5TZYHp2R/2zdFD4HJ7Ir7SSypekXFw1yLeEzOLgl+4hWC1PDIcs2mczu2DXu6pFQ+7wDQ2BQfxyB2qUdoeCj0vthDM7ChZOLSN4smz5SnwaZZiQhAIK3z25+9iq8kjxISvMAdhIEsCrsFv+6T/AIMMq9/FNYTYRyiW9YmFkeV4QzG6BGR+dlmM
 Uh3ODGuG
 6sVwbhtI2BRGOMEIoV96ejvPk/zu5BmA64N6nQk32Kx7E+QzOntG+l/nGPYYzi5ccw587pt+Mvn2JBbpKb0hI4OQjm513LWeOezIHwxUQc9Gb9wOtZwG/ZzASTzBq4niQbGKp0lnjAwwnarD6e7Nx4+lxTkI/U2mu/TeFQyebLG3Ghv4va0IafypuGguOpz8DSBjxB7gyR6oSOhBd2m7S+Ggrc9Cj1MlCG5zWuyWM5obKtSL+funLVFC+YlsV8BJmX8qNexEXW2F0J9nR6P0bixU+e04Wy6dijYL9k1x9ZbBKaOBGnV+iBwl9OhHX+Ccyx7b/0C/woRHAnxJQcs2N4ubkYvSbP4XnN3XWs3mK+yGtJYgFo7YCqryAGNrTYeJzEz3uJLOusamAXL4njqrgAM5B57VBMeuabUxBgV0cnHRne/Af7gKxZQcl70tZvrIZ7/Zymof9ydhNSRHKt15LnDE0LOBHimPJAZmhH2XbLdkbWwNDq7phqfYxs2pgLl8uLCpKQOuDTltGCfEiy5OPtSK829+if5xs8kU5iuCy0RAgkYsXjLq2rlzDbHV/atEZZysT7GrHDJLoRPVafjFpjgQopCSZxdCHZtQ7lwQ2n4793GDMb+9ieo7XAGJRWyABRD4e1RcUK9ICfvNW1KoDHfK9vxkFbUrIAzJPoydbANL7kaTv7klWiXLRErVEU6canRFThEI2phsUXMQPfdfX2/rUvEq25SQj9B4gOsldHu1uVDsiz5ndH4ssg91WZbUI+XyIY0zqhZ/VVxtsH1vTC0P89JOo9vi95AO+ZICsVeKi0Q45udTL4ppiMqi4/RF5sWSaHR0tqWQtUCmWTVmDMIdV2twMO/rf1rKeMtt684ZU4pZsVSuJFFsIntqxdKXWK/pARHR+758eJkctximbLHu0BWHzVpykU+CkaeiXnvgDhj1CHr+7tYAkPxd5a1pWZ1vuGRduKFBOWt7s1M2TfjB7x+Tf
 O5rAvyHn
 WmV04lrsEMzDgpbcjfMWBf6N8UjC8s71lfsn5jI5sSK8HOOScDqKlkL1aHo/kCi7hdluN42dlJUzrUWWR0p+9KMGbvBGWNRA2+K3vbst6HjNrdcystqJL3AmLZUUciQBV4/SB/eZErkdpx7//nc+j8ZCRFK0eSHUcHEB6iGaW3XgVBucByqrAX+ZlnblY/TlMXhH+qURpD1lBwTwSA/8vvyyoVj30dqWe3PZsonEGFj9OaP7ZFhYsbJFm8Xw/a6MOzV0s6nx6rjeegY3TvSD1giyuCpqGdgCVVP1AlyfkFM1WRjMrbz34TzWSFlYUHOpXWlGphGEb+TwWlYqe7KNtIW8Lg0PRGusceFKDMuTE+Gd+K/QcsXHf+8LYkUKcXzLl3Io5jVo9c+06jx7PkPeT69rspEt95wgeQYZZoMI4Ox7NCAQr9r2opa9XUG69KWVH4pSeIG8o7NKhehrtwqA51DPvnWS8PhjTqGZJ7sM3h+4UpBa0fK6/6orcFelXuYuWMxnxH6RsFrzH94QLi1o4KkUTU6oDZZu3xUB728bWfPUxetBYvyOUaVimsoDWP/nuHUdZkugGRsYiXuZcbW1raCIc+F3O5GuGl0ij+VsTtgLRGLvI1g0xl6GkqmduBnfVEpA7CusX6V4wAYIaf7tlXwsMIpVYhnBh1cnCxFx6ZLQoTSw7+HWSG21/omuK/vN9z8luMNdY9/3zg41uKVIJ0VaAqFr6OitB6cetXxFoJNLNF59uLGuBjBJ10wX0IcfSw4FLCtjtLLFLuAYyRfuMECFaUC1C7A8u48m9F8Uf2k3kaP4tyMV68GIN0dM5Ycryrno+qxtcI3EFm25ypxQ9yoRpurCseUC1ZJ35UrVrIvbu5RAzdaJ4OUVvTkRSBP6AbwFUXEqAN4pe7X9Syzm8VkdT5lVpayhQ2301rM5YoPZzjO8zWr8xPsKTLURJ5db6kgOGr7KCibvXgo95VUmsTYsvnbsw
 N7bMiXnD
 FSOhzu09A3Rap+ZKRQ1W5uSKkD3DXj27uAeZrRn5Y/hjm27tjihxW6r6sj73HvRBvOwPZNGnEVIT+BMnJXHrytzvDF1/SAmHztXZAnVV+bITbGbSoknSFq4OkGsqt1hax4W1vo5mK2/O6go6lXe2KPGjCU+s5AHTecGVC4Ubawmd+czI34GWUpIpvauXLW9ako+Hqndqx5teptDP0r6Ib2Nz36GZjEd49yIOvYhc/W2mDM3xoYYPf8GEsQsRSAy0MJ5XxY5cxlecOAm2CETA209bmYbblTj5puQmd2XaJncsZPEXxg4ORiOZTitUfWWiSwxHRbAds9oZIXIdLh2SC5FgnPmtom1RQQ41jPD+A/cyUHqXPKn99d1xyk/YqVzvvB8y5EQIUNEQMpWotMgIillNw1t8d5WEQ4r2mRr9a6fsJ0AI1twf1eXcS8uhOP6js=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
two new functions vma_flags_can_merge() and vma_can_merge() and update the
merge logic to use the former.

This abstracts the check and expresses it in terms of the desired behaviour
rather than an arbitrary and confusing VMA flag.

This also lays the groundwork for making further improvements in VMA flag
usage.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 21 +++++++++++++++++++++
 mm/vma.c                        | 19 +++++++++++--------
 tools/testing/vma/include/dup.h |  5 +++++
 3 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 969594074fd2..68250ece4219 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1612,6 +1612,27 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
+ * merged with another?
+ * @flags: The VMA flags to test.
+ * Returns: true if the flags permit merging, false otherwise.
+ */
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+}
+
+/**
+ * vma_can_merge() - Do @vma's flags permit it to be merged with another VMA?
+ * @vma: The VMA to test.
+ * Returns: true if the flags permit merging, otherwise false.
+ */
+static inline bool vma_can_merge(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_merge(&vma->flags);
+}
+
 /**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/vma.c b/mm/vma.c
index c27aea6d58d9..8f8c554d5c07 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -924,13 +924,14 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
 	/*
-	 * If a special mapping or if the range being modified is neither at the
-	 * furthermost left or right side of the VMA, then we have no chance of
-	 * merging and should abort.
+	 * If the range being modified is neither at the furthermost left or
+	 * right side of the VMA, then we have no chance of merging and should
+	 * abort.
 	 */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!left_side && !right_side))
+	if (!left_side && !right_side)
 		return NULL;
 
 	if (left_side)
@@ -1152,9 +1153,11 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
-	/* Special VMAs are unmergeable, also if no prev/next. */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!prev && !next))
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
+
+	/* VMAs with no prev/next are unmergeable. */
+	if (!prev && !next)
 		return NULL;
 
 	can_merge_left = can_vma_merge_left(vmg);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 16c09dac59d9..2fd422789717 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1647,3 +1647,8 @@ static inline bool file_is_dev_zero(const struct file *file)
 {
 	return file && file->f_op == &zero_fops;
 }
+
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+}

-- 
2.55.0


