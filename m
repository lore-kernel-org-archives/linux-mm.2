Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08C66C982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CDE6B00BD; Thu, 17 Sep 2026 12:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D456B00BE; Thu, 17 Sep 2026 12:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2A796B00BF; Thu, 17 Sep 2026 12:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B639A6B00BD
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:39:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52DCAA598E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:39:19 +0000 (UTC)
X-FDA: 85223814438.04.C54EE95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9DFDB140008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:39:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JuzlckQR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789663157;
	b=QbVvgKXaA79NSDIpPe3qoAb72EmpUWjgnoDl5i2rYzle13D2uleMXqME+D5+fIldL15r2t
	sPz+xhenTtFi7HKmoc0yaPM8eGmfb1jldzqyqDGtfnKlwYLbQdQwj1tpVNdREkK9OnFdAO
	VAQahS789mwIFOBwc7p2xcOSMDYddc4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JuzlckQR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789663157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WoUWUiccCZ5pmncdG/fVn1uDF622HEjGzqeAT5aHc8=;
	b=q6iDqA34tnmTVkfP2VNBiyyMJW5bH/EWanwWRs/UU+Zxqr/xrQ+uygvyjnKXw1PFYPdKfv
	X4GymZQP8280MeAbQBTV/Y+lJhGZfJyNgtl6r0KXF+StXZ7icH5KIhm4HKk8G4nAl1jVW6
	FLUpdcF4x/w0gBrv2dGJBmgNhU3p0Ac=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1848360231;
	Thu, 17 Sep 2026 16:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FFA1F00898;
	Thu, 17 Sep 2026 16:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663156;
	bh=9WoUWUiccCZ5pmncdG/fVn1uDF622HEjGzqeAT5aHc8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JuzlckQR6v/NzH0mtru1XZ7iqyxCxBjrCwCFsUHW609jPCf8U6sfhyPJkkpToF69f
	 siJ7N2NXwspDpQ5dJIIyLpRq7MwSgE3R3mqg5OrgAtBYXQZyoeaTTM2m6j28o+aBbX
	 I7FSiMwxg1YdjTyYq2YbYkTvH901cTdfYaUc365eMr8X4iPtaA7EQGoTbcu8Y7USWP
	 bzvY4XKh3JpReezKG88DwuCuMK1EFa2lyia7xTBCesd95C4tljlOVn0ygfLWln5b8m
	 HFBw3K+lt5pgVgVgyTxhxlY5CZ9zPDN2L69fXPf9G/mWuVci/9xx+4Tz25j31d67md
	 EUctPDbCJlXcw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:41 +0100
Subject: [PATCH v3 32/40] mm/uffd: use predicates for userfaultfd checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-32-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2289; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RaKyg3GqRiVqHvw/UDaaHvGcpLhQwigi+RNlsL2zffs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB/OPPvVb8aRBlaPSTM6P2dc4rwuwDBzzqZoPX/27
 rSo12wRHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIn1ZGhu/b9ztfWa90el/9
 TetPvC5Nrbrrmvhtz33cqXTRuuHAHX9Ghi+axsy3Htr+lVOdM/mU0QoVzTe+TDpKZk8zz6fZScS
 KswIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9DFDB140008
X-Stat-Signature: kdoj8dpq64wpwux8u1zq5tx36g9roonk
X-HE-Tag: 1789663157-483870
X-HE-Meta: U2FsdGVkX19dsVz/Ry9ODwiaRgccdDJThQbIqY180mYF4gMshrS+JQo13yyNYZu7xpGTbM+UyDWCRI+zFVVxc758eadk+niilNd9VHp8Jjs8QJV0fQCK+NOR6zjpFvn9+USftFFTFF4wMhqaYeRE1/b5Z3fXccKQQ+cCiw34uIHRpeAEmpHv1RdQXf0UxGkL/NNvdKEnEZ+E4zcC8zVkoawxuovNT9K97SNE5ubY1hpW5Roh8bXl8jjGMPtqiQCWMa60npQ8398BdEGQRafY2oBmjdghxGxa1GDvgxtYVt93jUFCcDWIoH/oDWbigWbTkwg3vwc2ZHBLqFQCVL+BzQfrpvu/+UMuhkEhMicdCmEypOr7qIUSxEZMSXBDrW0fEYk21i7I06X6Hpdbz6AsWJLF5EJ39VUw34hZ7SmMdt+NnjzaMbYt5Gn/KqFcyfIuwXUgGylxWsJzYEMm6JDi1qeviW5pwQKrLdQ9t9UqBP/3Kv95JGB23iaSyzCZAocw9dRNLXqel9QgORw4M0H311Vz78LO+NLyyw+xl5Fkjo0WaVRe0LSzI3Ua8qHccEYMFY8QTPGtidk6bdZTT181yt40rMEvx9MlsF/WACXzoB+p63LBYUpOE0rTWbYuioyWVa8HLeY+ZLD5XVppBylY9p/YaJU1U2WesqY6HWU+qlzjVbFrSsPfzgWqEtCKzRL/e+CP9ypf1/jLF/y8/LGKj1uTCi3jfnb4VGFNeJhyZNCjS/sGB0T+qgox2q7/xV6UB3qlwo1fel7f24Sel+z+6RiJnGTB2mIyLStoDd3AXlsBxdlqrYrTcRmNf8HzfQ5Y/Pzr0Klzpxk+xA+d9pQDyV1f8F2bhpgVRWV3+Jl7/P9rm1YgCbJ5SmmcqvOouE3K5MiQUtTP1xiXyd8Q3Q01VHDfZtRWnKl/Uke9j+POji11H6qLb2KyTqVpukcBtvecSdJDnBg1JlkS/GFRxBX
 8GdBp1Nq
 H8vEJG3Nc2Cmdo5zwVPsz4Xz35/Y3DaXIf2qqQb9vbGMtQIwhLjiN85x+47fTnDkPaBO9QgJtcdtqNJSDoI6tIiORw2bevqQSb17yIP8eZJfsSCIOJD/rueSAvgkzfDQgSdhlEl968VKIX6dXlii0uo8gS2cndQNZj4e2gm+1LBerWelYAQAn22UYangaTdBuB0dFMZGiW7mfKTx3j5mP9ysFP/wND8rCy+3k1JSZahbAgoDNSvJXnqkiW5R8U/Eb1kCQ8oTwdkqiImZSi+ynGYqexkcfD5jM2CeNPbOVsRJkrOI121KLKoBG3sV7bmvJB+yrlYc823shczTa6XZnkf7KetXVQyDVKPYqzHCz6APEydyQNPDnzNz34xxDBjalG5TfHZxjJQgWANbDhHTnulzW+EYVAt2nf07a3AaOIij51rTuwOKyqwioNG4LphtWFNF1LGwuovy7iAjqYwwX4KMUvpxSIZp/+czUVWhyNa7Js4ZStYxM/gAmFcuF2y4EfFE06sIshdxGxvAGbgGUVuPh5GSv/l8FhnUEjjNTvI0Uk90KaFNbPbtQG4JkN1kXRoMcONRU+HNot/8lDRK/MpcnJpeWlTva70WrwbXH3cNAIk0FHzlLIhM4zmaDTd3s7iCCcW3RmH0Y2TP062ITOciv+a5QNs/O4G4BUanmwqSUYtS9yVTNSee0nOs45+M2UOuLgdSr1C49VIccm4jFMGJJ2az4NWx5O+Xdk6yywAYaXGm2wyHY3ESclD8uad3GSzkK5F4qURGBbsgBa7lJ2ptTiL10UY8Eg3WRF82BybFQadl6umjY2st1Gul4rJyp331rEjHD0592vNHw2wHaZ2BtywZczKY1OzWSqupH80QuENq/qx6sEARRnUcDE3hHE+DSZfmx7FZD6iWIozTdaxSKWkMA0DMWhA703G5yK7+cSseLri/HpIf75NbazLTM2EQuXg9TtKOiWCYsDxVnze7P0azO
 AsjxdZqS
 Xjfox2XQyUSZ8cgJ/06u6l5O6MeNZDSn0gQ3xHknFK7eN0TqVjfgts4Qnjhu8TXW839odboa6ZIGQQPBYRhaEWoIShGqb+OlLagNhzvSP2VjxNi3BCNzW8E6FjTUnCw7Uk+qHa9PARRSse9Eqaql4iO+AguACh+DzgPjKOyaR3mHwUMvStpaerSugEf20hRyTVyg6ZzNa/oLOdhgqGFXf/GDDhilkE/Ulh2lb1ryoXLSjEFc2WqB1Aoju4Q6UAc+aq97HQEDzdg3J2xdegWSbQUYpacPQrjp4ZRJjTLqmr0t4hfoIXsGwPZk/0Ky/KIRvf+skn5SbudQCxhZAh9xa6e1PlN3+anKlPg9Kbcc2KTASYd13S5eWJlmk1e8g1RUR0Jg0MamtoD/HquzY9TGAJ8p7cyAxxUur7I3ddcLnCp9gUYFzxKQT17PP+0wtYxprXokJd/lDY+A/kXTgthlko1XUKgvgYKzp9k9ImDS5iIWB3nj7GoUKtLyZSw5o4b0/+yuGt/sahgWc3wxSn7nmystCV8fmxCU5DKiDkjLhhv626lUwLDkyqBWCUURO62riQ8fdRsn0AZWOI6HljcOVh1drh5iC21GDMNr7+IKz+TlKqDeaAMQ6LP2FcXNX9UdkCWhyLEYE37kYGkAJE0aFYekR/Wpv49Za+P7pgxZe+MbqIH7+JHb56wq9T9nR67y5COKSKZCPkpHwp8awfaaC4bKOMTvvHdd1ldeouCZOFY8oHwpDYZtUPdpW2zPxhqqv9R+RknLCehIhcBUP/aq4j4x62iWMUAk9W7k8otJT3oxz6UIvuZN8z04aRS8Wytxv/GhC/vDvweJcq2Hl/MFHucUOxSh0XYXGQwbql19AL+lqT0hZ5tOT12YccWscwqYSqESwJfCSPNSmQIZGYY6K6sAwWIkF5eehrxKC2qfy0D8LpcgrEaNRtIOYu23XmMWlPWDYz1HJJKlJ8vDh8uhwgDS6AhUD
 7Ezbkl6/
 vTGSSUHpeNJrhORNqsDyQSVyylWgMQ4BR88gb2wHFdtIBG0XSa0WRC5JD+5AkylV/NZ9GwyQr8dJP/FKv++toXt+0BtPkWJkvpdDkdL1vcYplixyt9mVOBJKU0EDg7FgaM2E89vt0aJIOH4CsA+54+AKI3TPjZ6Z6hl5r8wSWiMJsH8ufvnwHsZfRq7NIDkp9zCPSMVvXjy0D3grO2yMJpuilucYYkW0QuLNtsvy/K51JvQPXEh54NEyllR+yryVggeYm9g2Pe2HocK+KMmEC3a5r5z2yXNoCUQcTj07D4cH8um+sVWSEHET+KY4z+gFZjyShShK4OHAC39JraeR9xZCNLY+5jVo6nCn0ebqbrXpOJu+GEUi6dOpQtrnBTOn6FgufwewPn6/3nRYrt6++NnOO4DoPrTskLh9xwyyXbX6sQaCTPpj7BrXdcBMuYaAnnN4QvFvT+8k3/nHkw4C6xgSe1OnuNt/M4XHPBKvLwBKfRbL2Ih8hJSubBappUeY1YAF2+xm51ESP5/gkhhK3JT5XyZXoMgCRyMkdKBvwHymQHCPeuJgS0qEmR+FZbtJ3N+PHPnFWe0W6BKlRHUzWvNMcjnkaoZN05Kt0Cdgcd1PP2EgHSUW+Yn0okdIzVQX3QsfbEC20HG85MB1qfJQX4LT/8IJ5Ys0v3m/j5olhuKQqKCK8qF48hOVUzET+O44K84CWn6YAdgUJZHHq8FPR7LtWe6KTtontZ3GghJDJqTTUmoTubQK+a0vFeWGHl0Ha2TkznCRmm/wKqwajgkdET8AV2vOnf/4ZI6iLq7zGv4lH0xOeQrQ0a4Fec/jyr/HLf6AVaNMhnZDTDgoYXQxtIPhaiJedWYjWZoA7XikUVi/bJSE5IWhtSCCXC2Umw/zmdbIGuexm6/lt/38PBNFicbp3bVnj11JU3TNs7cq+2Mgc2Pm72B1Ts6m3ePRBAvMvCiGHn0FOMDuJtt1vly5gG5n3xIho
 sb6AbyLM
 T4XaCK/cxv3AI4bZJyInssuNI1Fn3rj+AlAbjkHzGXK1KJ3/DkEFz61U4c3mYVrY47XWmCtULMyE0O4To7RnyfPhKQ8d+FD0tT5ds3D/GEQOLGrXOZ/1B2B/1qOdtfzZ243iBzcQNppgXcMmOsO5QuN67SkYj3CeV2eGVXwtmdPZ9JeMeCC7UYPuUOUi+rMekHWfoGtQ8c+7ZBA5i4RuWrpIq7xyX+JLqxKz2vnZ4vq/OpUlJpayG6t6lGhn5eO1XttTI+eAY3zJujGMvQR8bFukIiqcta3kE5o3piS8m3g/wtPSk4PXNmiMsdEyibDBGcBk4pQt2pBDtGIk7ScGNxmOvYiMvSVo2f5IPHEk0kpJ/Dq6/hYi/ZJrKPX5PJ1aU80cimMOhsCwTzuOfRi3Q5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than directly checking VMA flags, use the newly introduced
vma_is_kernel_owned() and vma_is_persistent() helpers in userfaultfd when
assessing VMA suitability for userfaultfd and UFFDIO_MOVE.

Update vma_move_compatible() so it's expressed in terms of VMA
characteristics rather than arbitrary flags.

Additionally, update the use of the deprecated VMA flag API when checking
VMA_SHADOW_STACK_BIT.

A VMA_IO_BIT check is no longer required but that is fine as a hard
invariant has been established that only kernel-owned mappings may set
VMA_IO_BIT so the check is now redundant.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/userfaultfd.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 949017e60608..ddf0a4a3d399 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1754,10 +1754,18 @@ static inline bool move_splits_huge_pmd(unsigned long dst_addr,
 }
 #endif
 
-static inline bool vma_move_compatible(struct vm_area_struct *vma)
+static inline bool vma_move_compatible(const struct vm_area_struct *vma)
 {
-	return !(vma->vm_flags & (VM_PFNMAP | VM_IO |  VM_HUGETLB |
-				  VM_MIXEDMAP | VM_SHADOW_STACK));
+	/* uffd is generally incompatible with kernel-owned mappings. */
+	if (vma_is_kernel_owned(vma))
+		return false;
+	/* The shadow stack should not be written to by userspace. */
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
+		return false;
+	/* hugetlb mappings cannot be safely moved. */
+	if (vma_is_hugetlb(vma))
+		return false;
+	return true;
 }
 
 static int validate_move_areas(struct userfaultfd_ctx *ctx,
@@ -2146,10 +2154,11 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
+	/* Non-persistent memory is inherently not controllable by userspace. */
+	if (!vma_is_persistent(vma))
 		return false;
-
-	if (!vma_is_hugetlb(vma) && (vma->vm_flags & VM_SPECIAL))
+	/* The shadow stack should not be written to by userspace. */
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
 		return false;
 
 	vm_flags &= __VM_UFFD_FLAGS;

-- 
2.55.0


