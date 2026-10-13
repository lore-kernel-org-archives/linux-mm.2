Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 107A8CC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187C66B00E7; Tue, 13 Oct 2026 11:27:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15ED66B00E8; Tue, 13 Oct 2026 11:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027866B00E9; Tue, 13 Oct 2026 11:27:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE0536B00E7
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:27:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CDB740D76
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:27:07 +0000 (UTC)
X-FDA: 85317981294.18.A94C40E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7447C20007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:27:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C07bGAwT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905225;
	b=liE8Z+Zq6IVBOuuhk6qMjSuK/xlJAXzHx8FN3+jbYNDrKVuVNtX+SGfIDNYqoNCwjdqF94
	S7sPCl9YSpuQjE/iboM82bE4f5N9p1a7ELyU9L+HnCb4xZXYqKYeXiS9j9M4aglUvj+4cb
	IS6pVkFe2UPYO8A25iYTgPsRSXwCqR8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C07bGAwT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFRmswrWQ2n04rYSnKT8D1jfOItHBdqj8eE5N7elmN8=;
	b=5o4zJ8mN3baI9ib3qQzaFiiLPNiJ3epfjZMRT7epB4vcffpu+D+KevjdfSV4wKb+Z4fqPg
	X/BqCfRGE4SVTOAzTGL7YDTXoKrR6eKaqcADtDoMCY0PNCvssU98YaAWIFYiU0xCNcT4TU
	vLnkQ79l9Hlg5spioKcUVHMaAytLElw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B46641B24;
	Tue, 13 Oct 2026 15:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24491F00893;
	Tue, 13 Oct 2026 15:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905224;
	bh=JFRmswrWQ2n04rYSnKT8D1jfOItHBdqj8eE5N7elmN8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C07bGAwThgZOGMqZm00i73ln3bSOOWcywnwLS4jB4SWUfvtudnbQo92JkbSYqpXl3
	 +vQOBwMrVTtSCIfl2ZFeqghmkQVGEsnbujJzairialXRUFRuou0T2HzWkSMX1GWAL/
	 ZwMvFrpzptQlNZOidqs8RDCirQjwS3pKQH19PI6nvZCX/vLrERr7d36qE/4FKIkb5f
	 wnd+AjHe3lTCYybtNyKRVjOoyXfdRDx9MAVWirQcMvfbynVBov0rHtryZph4ryzBTE
	 opdSFbvoEiAqKSvM9eBxqg0oY35BYx1LbjQsgqwdsfxjM0Fyjtwi2gGzkJfWZ1rIzt
	 SGb+3hlZdSHQA==
Message-ID: <fbd47b50-ce30-42ed-8b05-85ee07c43efe@kernel.org>
Date: Tue, 13 Oct 2026 17:26:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 25/39] mm/vma: enforce that mm-managed mappings may not
 set VMA_IO_BIT
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
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
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
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
 Bert Karwatzki <spasswolf@web.de>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-25-1aa3c9b139f9@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-25-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e8mbhpmpy71xbjqha681zhqoqptmfmbx
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7447C20007
X-HE-Tag: 1791905225-591803
X-HE-Meta: U2FsdGVkX19GY0wopnIUIpmfzMrg8PlSMpHP5AQmdQc5w7tDEL5DjoId06/qU+RJrP5d442xG4v1b9uwSivE91RVONT9Jg5V9uJs8GMXyVtybWA8ZCSkH0OD9nfUY+zgBmFenHw7DWvhvg2tJ0FOCJmfcMlP6vi6LzYyH4xq0SZnw0OSV8lG8vraFkHXv2FkaLike2L9EJHWwZwREclrDG0ICdC+IhZVzIJIuSWzH2kVj56F7UQX5CHJRQQ9GI9qUgtp/So4rEEc8LpTLgejMoE/Vkv38cB5PphnaGDGENvm9g+cQD/rXgv1lmI+h6ZYxswoTY8qcfF6lwt8rU2IeBanmVeK1Y4+N3DBhRmTwm2jcxSCvKYNWx42iREp6qIRwBYBr+CwBIB+//KYSb+QrZ3travJFQegriEtgdPF6EOrbQmE5c1kxGbWTvW+4wucQ7+sMDo9ItpX9wp4LUtKgYdvZPPUU3kWCEi3BctLUhqIot3P/FCFC9Y5UCse3k61DfdlqSs+QOZjnsSkPfvOjLNeK7yLPxWh7fzRM/z++I7to4bmTiXPIuKb1TcMMKJlBcZGMQ424iX/iB6tCDvqrWSB9mL2wsTYIB1gP0HgnD130/69oZ6JuEpG4HKPDTChA7G1n9QRDMTuKBfadA7h0qZgUyW3vzY7ckANK9i1ONsqbIvN5sfCe9lGPNw6/6X1167gI65e3bws26ZifCihzzOkLtTQzJJ/6xwVyJNEF28Ohk01dXRc/hOARkDo+REoTJdLmswS49xaFMlNKxUNI7RsnuOm0vhIZlXaOfmMfGKBe3SKYd6ObzNLaMcUMl3MNH0KsmIklO5puV6Ye+qjIlZwj4w49AhI1mdQXHnt4p/wBRIt4uMMNpA/qgJN/bWeZNDuszDLYmSJ5wiUQnzM9RnLF5xQ13l2QPYhRgV8njWVHR2lkamWR3UWr4c4QHtGpHHRccf5VApjuTXKkUE
 da7EHOU5
 QagT1de8iqGt++HQX4svZoacQuhUJ8SCDX1zBYOGXFNyMlrnnq1cbibw/j3NN6s+41I5UY7zyZr+FCkca7pW4DyQaPHSYQhMPGmKJquOQcFweGuX+9BlI5t5g3Fe7/Lx03SjSjEzXDJ8hlORgfJ0MsD65wW6Lc+zty7wcJI0RStd0NecwsclllKk3CLmfvH/DExc541hdsuA0fXYrS0ZGfx60IXPuqj1lzcwEx6jutzgEEcGzwNMKBBz2wxlT0Bpt9h/PVgL0c5Hjtf0S6uhee3gMNQ9w7IH7a8KCJugol992appilyLljxc9ATeCGXBIf9Oo+xNtHWQYoYljJeMe66LFnzWQ30OXQT2o9cKZuJjWb+2NrR9cr7lvnyzGrURGdqDKEZ1jmH6R74t1p/KLnJTPxGwno1GjLd9N4NjDM2Hqx0xpjEWQxKJ0ozLGSlnZdQEiGV4tCCghK+ndBqvlFPNRXhmrKakj2Blih2s2XpS6hgBoYvmuSD96OaiNZf22W2rJHEAoZQSdS+z3yOpeSEOvp5sqcFppLupkKCIrWHpxKzjWvglr2FJQ85LsZY6DQF7jzXR5cU5rS1s0Oj2dlhCS+xbbDHgLEGLIPH3lMcHAjjPx7zVQ/zBNqYbXhcnwnZGPNzB0ttKKRoNNcMRrfS7VzAFOD3Z9KqcgCwUXjKvfJ6LX3sm1KhdDnXF56KCQvqqKzw3OjxqoMlcrFZH+anBnP2EFq/skAuQMMEqKS5g1VQNeCej77wOafNBrTTMI+1pF9mS7QDjRARNHm6KTNsCPG3wyGI3qGDSnDAZQQvtWwcD6We/8hoXBtsGMQVOIiqCdcqH9joU5RVUheCZLnpLdLN+Q2N4cZkQ8AL17PJeSAWmv0izKl6MOb516j+egHLO9beIhypIIWe4OBvddBzWsn2/NWJPj3ddTJih0DwOkmZye9KfxmmlZZteoq5+aGrZd1L4XxSdNAyCRu+M46ypyI3Lz
 bg3N4OKk
 +wLrEXrfyCitq4khkON+x1appw7epJ+6GNUFdHFhf2GYQfk2iDzxVX5ZvDcmkM98IwHdflZAb66fRxySaVjnpCWVGBcqzQ+wr5DH1pxKJGRbUf5KcEnXu34QEzC58yQJTLGk2Ygl5UEX1Q7tu9EaR13xNAQCadJZkF3OAQftgaZzVU1T3fwRMk9/Rer23mQmH6Yskrrw/WmBNLSsm0PQaHwXUs3k1IsiXWBBhaotJjrRv47SFhWwyp7DGmf9qL5TDF8pNPJtfARy3YGO9hTp66Ikss0XVqRGSr3sD6QPI8V3gQlsnyAX2QFQD/DgtHjX26kK8f1sloXEpoKOD2aI9tr8afN08XftMbjuAcZjK+TtTAcITMXsHOMygDvN1EZhhu+ryLkXr7SicmbBvvoClTku9DsLAGnFunU2Wf9ULwR4PKU1QfHNFUo/2kyvpNDV8G3PbXImUNmEL28RHZWsLTaGOJHmmbss0GZjzwE9xtHvZ3L241sNfiL3ulNx8p7cLMcK0e2TI3hB9IYxvrIO590rmPzXwPwNPcG3zpOMIWBlFjbSjb50QIpfXIpDSuWFZKiP4P9l9dkYlcQYUXgmfxeYjlJq+qo3GxCmhsvNIIfH4XPuaDJozb4Gcf8X6tkt7+hOCT8/RglQZouEAJwpvxRGLrLob7es2qPtIGymM2ouFhwUJU61L9j/G4UsdblnSQiWibhDeiEKVFonVBzCYCXaZThLRKcMCWPkixMplM+Vq6WYK+fQeRZAfU5EdUPFZRamOPprdFvEZG+R4gxWS7dS+aHslF2By8q5ZNeE22SV4zMTc1oGjhibIOaM8pUfDjgPkI+Eazeyj/gzu8MyE7QOyCCky0eRGkcBSdsqBcnsfjqNK9qHobUidgm2gmAeID8SxBNaEB/r6WRaVXyizeG3zdyx6KhCKAsIS0eYqIBBTj2gXJQWQ7BLyHFwgut0chFE7sNNC3cZDA6NSo0Xpw8bE8bzu
 uJnmnrXm
 qu/FGE7tWYVTsVxPF6Y8OGCz02MI4uZrH9I6IJlPtqFjgplAfgXswo0JsyZaKAWeiyzw9CPNhTkcXjRb/90V15/D/DL7aWqK2Q0wA+o0Xr+rjz+jMReCBOobt54JH5II4ZoIqk7MiafWo0FX03ddOl3SKUfYw6/2l97j5y8BiHbDtpwWtIZGBy1D6A20Ry9sleWZQOPvo+ntnpZjeWDgxZmk3w1uE5tNT/BOlB1tdYulAlPEEZstI2xd13zj6vHg7izLcOCsMA5u9YM7OSIJO+St0kEqt+5Gts9XttMvAdjwEJZI6qBi9kdwvkXG7RbV4Sl+aaZ6kCkaqXiMe54D//+Eacv9Y2BNtanBr7z1IwXj1SXAkx0ZJX4FaUzVeEsKix4YnSxK585t2zns0dmci/DuicrE6YQTOJiGwcn7DanCVk48Kinpkv3BXQuK0XKDvf6gRLnOOwCmiliIsV9rinji7nm+5PhA4P6/Db4gXhQako1IkV8hBQb3GHAlyBLzJZOcd8HZdmZfxLIv8Bfk8KomF62y27AFlmmwxXwqaWsWMmwtsnJ2wqLSXUJW2hOWw9W0h+piwoq5UWhYn6H4eLTYoHdd0Nn9W1RKPCZO+ajMhSs8miknCKW298Gvb/WapHpMwk8RzjA2kw4SDbhcGFZ7uZaHf1r7DdUid1jYeRWjaCXGsN1i1PNrI3/iPzO9up3YmHz9rijRjYxClBRGi5j8sAsHPWoTUkgO1UAtpu4tzuo7a7pQ3olLmXE+r+SPTVzXHyeUxLdww7HXVr7dycu/EueehaHDfFZpS2VnVdcImld5sVPbYxLq5FkSIZAm4369HqOT1ArkAT8Zkt5UvJw9qW7/+RLUgBnUwlslukl0KVWf8c/p4HK22c+NOYf+erhqnTq+2UKG8ZVPV5T0/q/j9Az9J4aTSRBhGhF4jE6o67nUm+eqcx0r6Hn0kPTUTqiyfvDoz6/LEpWhvtjYhEKAokzq3
 XflczRHJ
 jW6CRECehb2TFIA6SeMb3ippQ9tBpLbcS9irQFnqxqW8Z5+YR/RYYC2gqkLMhr/04wKRWJNOZzGasZoUp4D9ukVdoGB/4TUrASKh1IgVb9haPuQh0A33LENg8kkf5pankcO28HpFRhFl0v8R9GVPXZ6VzWQkGakAjFs7P3xoLkBvYWoC5t8NddUYtoPdpKnE5yH7C+lEaTEqBbo+jmq8weYNXX3N9dC8Cmi6GcP9V4WgpdDze5NXD8vWSXAZd6AClJkvFcYO+suVfVx7Xy4VNveMlBh8rJXwGaJPHhFhxPN7gTfxdNK4/Mfm9IoPf9Wb+PMy3mXvO4Zh3zSP6IhKI3LhaAUdLCstKYoAzj2L5CoUTL3fbI3Efn4+dDbh2ryGnItCbXSrLYNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 17:05, Lorenzo Stoakes (ARM) wrote:
> It makes no sense for a mapping whose contents the kernel does not own to
> specify that the range is MMIO.
> 
> Prior to this patch, all in-tree drivers which did so have been updated
> such that they are marked as not being mm-managed. The check WARNs and
> fails the mmap for any out-of-tree driver that still sets VMA_IO_BIT
> without a kernel mapping.
> 
> Here VMA_PFNMAP_BIT, VMA_MIXEDMAP are tested individually rather than using
> vma_flags_is_mm_managed().
> 
> This is because vma_flags_is_mm_managed() still checks for VMA_IO_BIT.
> 
> The very next commit in this series removes this, and the check is then
> converted to use vma_flags_is_mm_managed().
> 
> No functional change intended for in-tree code.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

