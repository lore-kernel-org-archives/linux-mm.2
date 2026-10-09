Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C87CA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4D16B00B3; Fri,  9 Oct 2026 14:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854886B00B4; Fri,  9 Oct 2026 14:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5EB6B00B5; Fri,  9 Oct 2026 14:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5896B00B3
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:10:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8BD94A7CF9
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:10:56 +0000 (UTC)
X-FDA: 85303878912.04.D63A16F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id BD84B14000C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:10:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CF9lp+Q5;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vhnZLSAfTMC+QZqCgbvTEDiC6mj4h6xS61LbBpqM50=;
	b=fMrdrV5e0OWoIlLuVgWGaiUVAnsBYCXzVH31OFhCg8aKkkjjP5XlxMXqOHA1uD8+nWI8ZZ
	s5ptzoWo+cSwojNsCIqSAVtUrjqL31pVkWzoLGrP3TLBYqP9I72pq4N00iqIdz31WyZJPP
	5EyCD/iyba9KTmb53tRQ2Fk7V71LVW8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CF9lp+Q5;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569454;
	b=XwCwGZ+ovsedssltSZiO9sB0tJp28gR8IdM87TsJUSJ7FTdiBElO2PPz1PC8kZsi9/lcML
	lsSoE2NrFDXXpIg+IH7wiNm16Metl6hA3jo1cX90+xgVjPD/BUoUk3qLEr+PZ8oBJUVYPH
	UHXQtn+jy0k+QCMxefG3Hx/Dbgn0g2E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E04314362D;
	Fri,  9 Oct 2026 18:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4688D1F00893;
	Fri,  9 Oct 2026 18:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569453;
	bh=+vhnZLSAfTMC+QZqCgbvTEDiC6mj4h6xS61LbBpqM50=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CF9lp+Q5Za7cVZHqQC74rjOFr8yk/De75otGYPR3S1T86ZL6oRSrAGvK28LfrvlH2
	 Se2zsh30qwMLlCqCA7med4URDz81nItQ7Be+kYtyf+1Iw7pD7ujrogPRF4MJJPi5SA
	 ROWlbwv2jQeOtHw7szaaz95Mi0h7nwXWfkJTNF/598PqLd+CYikRpuV0N9CXSKCIVt
	 o3wXmoeccut4nTq4n3hdNX1JIoyTrHyq46T8GSH56DRQbV24tBBhAlNRVg4WoIlVmy
	 84aeZDE9EHN4igen11Ju7/iVYb7qestz9d3AcWi65jWKShAOorIZ2uT+oAgUqIsOlh
	 TnwYuhRcNncGw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:12 +0100
Subject: [PATCH v5 18/38] fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO,
 add VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-18-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2415; i=ljs@kernel.org;
 h=from:subject:message-id; bh=UjDr9VPjw22rvNYi9RjlPonrYjyH/X5y02GEaoE2d0I=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sxWupUx2VNl6dUlgjKlqVYLQ81dE/7Zf/0r++8Nj
 9q0G3l3OkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRrL8M/6uTzvVuvTzriZbp
 Wn794nevaw0lNv46pdrkfVrg+8fLd1UZGd5et1MMWxS9frpYkc6xSvuZWbyPPjvff7JR9mPZvAU
 zPrEDAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BD84B14000C
X-Rspam-User: 
X-Stat-Signature: tc4ys1rocsfuwz9dcky9mphzpbqy759p
X-HE-Tag: 1791569454-707155
X-HE-Meta: U2FsdGVkX1/4cdbRNoWYPb5TAW7Lk+5/3NKdH8I4vLpXEXvjsBAVyzGkFmiRRiHZtYnkSW1vfKgOAhX+cxIv44C/GSzuzc3B0PwujMRH8YU4pDLMIf5j4f0kRMlH6l3rQEVsEP5X0MkcLS6/iXZvFPLgYZpmT0dFTLSeGLY+JuMFg7Zjli179AY96ZbUWtODiCvAzCPPOl+gkrrv16IaLyeCrTqm0fCtIaq+K5/bbleLYtKPzA50Rid64VHQLCeBcOXQNpcZ+zDBX5+XTUM8EGRtf5HHBsKtZsf9u3j81bJIbjdgXXb6WtqjU0ObcLKW5W+xEWArS2A6UqJFoRSf5Z0eT0gM2JTnEYsp5ksgXDrmXVAaa8WsnctunANcIz8n/jY6+DtiUWARTbQui9xrimPm61WX6DDhCSCN/mAC37PJ64fsYq4NA4HBOxP6PQsCZpvX7ZQ5WJGfvoMJ8/A7UOMAOYgL35QaqhESjRhcjOg7UCLgu778mxovVx6rZUxT8tILU0b9c631vnjVduat2Isw2uDdl8Jhd6qmVN2wk+jJsCg1fCeXCdCZesV44eV6dsviMjphNGKo4aVOncC7SUwZnEQVQIwBVAQSzgzf+sCpussv0Rb2K8Tb3jnP/USah2OGVetV1PnbTqjEuJ0prHHkEtIaa/4+JyaEeBuF91ACB62AHKBR1/M2Vr8TxxmqBW6iDcJEn/jAxtoxgxDNFuQD+g9XOmMk6C4oD75LUvjnjW070jk07PlsFQpCnbfZ1grk9lNb9SGk0r7LOOLSCbpcCPvszCljzObxHSGMCcxonxMTuk7KOzUVIjz9oz0QRQ85EpX2lt0/GYfg0hu+GaRuOzysRadqQ6zqyQ6TbWg5P8kZYM2Vpel5HYesRB9oc6T3DRkGCWRbNCeWWH2A+rzlqDAFq+DrmdVyOa7oroGh1xFy9OvgMiMT3nh5ZOIH4xADYcovp8p0xvSo3AL
 Rg2ugtDv
 AnczIYOqwRuwROeuVF+B6FOe3meMLSG1ZS1mtWT/EXX9rz/zekcESxNP6guXsCw2gu7j2nyNkFzDKkyu0rgAoN65A+gy2Gr+A9AJU08U6MDcjjcUufEavw30bbTITRu7wD3H1+nxQ6dKXh0+o8HJL/PCaGYobmWUY/E/chm+qszfvwZ5In8ESiThpudVSQzd/SPqE22tgPjrDT4sfiM36bnOcSuK2v6tC/hYTuHBfUQzEWDEtjR6ToOiC4yP//u4O5JT0TPLx6ZnVFLjZLvB3x4ns9n330FUpYiiwCG/3mX53GB/NRXNTtt+ef2YZSZtpFzwGTK9nQbR0LUNxu0T5qBi01YLxbFwy/zTxkMqSm6qugQTfJ8Yg2cJct7D3+itrV++h6JN6w2H0eLg/Kbz5VdYDw3W8kyi25H5pyf5IFw7xsFpbaQ4WpondqoAYzpFrlu7dhSJIOCavdf02I3SOywbNE+xdX5aw20bV7Xk0IZkoEdrmnw/syUwxUObBhiCqe1nx5RPiGshqBG7QO4X+fGdoVMhNTvE2JEmLMZuPj2AuHyoPtl6ctv/2IPlzwXlC/eCL1BNUQGcwWOG2sWDAv98H+/09dY5/K6tb+mmPnYlEZkxjxIAz5jQrxdpSUk8eC93xahjHfEAaImuanTobTORita540mtUyylyBwJEWfI8p1mQ3DbiBbUpjcOVYeVdF0MS8KC/3+fP/jlgHv/ACmSNA/CYQ4aPcDQZRENE5IkZmfd8jWj8XKmn55Sx0IOv7SmjJnULjBVGs69z5QgLD5UAq4+7K4umNi6JuSMvBw/Tk0mHJecezTlMQPLMAs36LsF6xE2JrgOCiKtYLINzOBWeHn6TJvyRhscThJzPNSqbPR6nHENiz3XaFQRxe7lChC2HX+XNh0GVNsyPn4WIEBZ6EG0H55NRUGA+oU3ZQ632hHs8bGU4zdE1zwcdFFLYE0J7F8bUX3A7yT1l4AOx5CauKJzu
 q0Y6j57G
 8SgBC0UIF0qr7YBe94hw4Y5mJR3TEhHK4LQITEHevqD6E2FIREa40XxQuRqTzhWMeB6zvuIyI5dew4Gh+lz7YgIRHUJNo4HGjdcXA7zN0Zvd9/sDGxIAO4HbreGRleAcDDnSh+ZB3aqPgivAVoSEAc0x88KigBYLb6RVyMsBXNpF2JbGGkLWqWdSZ2M5igXbuASSd2YOHxqh+LMraMMqzyZtxGH9yMj+XLcDW2elkZiGASOg1CR4YArhB28crj+DtxLXF3JOynHMmiEzt0W+0ZXfW2VCxHR1Qz4TNUZkKPouKg3zABe0u+PARedLVhck1vCWz8Ie8olzqHMwHLYVPq5U5NhQaFQ5vXCls9mXYTrffdapLA515U2Le+2Zy2Txwh22RC2ADp3SHtyiuUQpBmu8h0jg7DsVmZKgv8daPa9lesk/2xPj/ntvGIllH6/nxWUfdDagBx4dzxfxHmUlcopjaQks6TA/MbO0KE5cYdits2Y4BUpnEGEwA7JZ1egiqogjq2LmeEdZDqLJDuR6cjmlExNfzrff3Xz2tHX5/Ws+cPZQ35SOpHd4NaQnG99nwo6NhnIHwtIwn3YqHJs60AvCZpYMoHcaXJ5QuZ6EkXQDEZEBw0gcyZ7wv4O8hVk6lSNvIXgJJWs1gmE/CgzbT5VvTHz4Grfz/yiUZ3I6R2tWSH7wQpIE3LSjrL4FO93x1WluVBXN7E5Wwg9i8y3g7GpYCGmngIBtQe5rP7jSOfrtO5PZkibHop5zmf92VT8x6bJhW6MFFCuCPAetLK6kdQqfJKBOWSK80loFEDJhDN3q8Vv7lxYxjfiRTEurjdB/OONo5H2evCpHdwKq7ggm2UOHhoI9AXtV+J3jsyrVJJM6chC9GpHc0CTXSQYlErBwI/IxxkjPVTQa+d8zZQ4kItkVunSeXr+kz/J13ts/6PLauYv+uRRvXe9Vpb0CT1X5j8VZdY5E/pM2pa3Vvf45bPlZ/tBpA
 Kzmy/AmO
 D7wSWPsH2EwK+k2FwKk8/f1gwtvbeEUeVC3yDGGFoobiAy6Jd0RGX11DN1hnEAzDXpWQ4YGUZ/H6Sq86IdrsJugUVvPUpyW/hpOLV6fgnsIQ5v5UrrrvgLCtD8nSpY10ijizWX6PhUcBVTvOxrcHi70B3VaLZmZtTwdiSgNfXxzD2MVhE74VNGzX52Nq69Qz0ViukFZY1U4KWaxbBssR9C6LhLj/LlA3kSjgBijENSZVHYma1SN7/laJ/AO/Osyh85jUl2KNZzeYbpdvWCAl77QiZTTGYdEJFFGUFxVCeMZInmPjQtbApAS1XXcbXurxGUu+nC/WnP7gBigxUOJrVFycx3eYKZSDM4B8EAwjxXNrwRn8mXesb2UpRQ5K/6lXgXOBKArquA3L/guUnPqmj2/Sj1YAhkF1DoP0nSaKlYEa0cJpYGAJVOwMDKEC3jjCFLAuCFU2rLtrRalVPp/Lpu/dexp1yfUEjmWq0LPpmj8PUXQVXCBqjYFGaLOlb/7RyO7y2Lnn2V0KUj8maNu4nfmmqsxA0oBsp+wKsf8OqQ9isLEp3YsuH9Bf7eHlFjp3+tSA2MIzvhiuDCm13SfRWQ/WVFLegu81k7J1S5zlBwywOysDbxfGCI2Od5OaU+noCZHZozKP4AM8J3VnBCOuMQV5jHDRPTwI13/6IFDLZCDXTY9egmzwAK2CGin8ZnIqoNpFtBCSdSDp+jKthNJ7beRBMDVbz0fkIJnHkjSxEpeyxOcSDMgZHJl9nV2QSu5p+8xAvigzndNPgecxE86zipOLEtFDKDrRS6eFxeGdcdzICWZ2TvNsOdKsYdLQyzvFKFSdqnNj3XqFsLHG679udT7DMC+tj04/txjzJHuXdT9u3wrMVriVu3dwe8FWURiv6QlzHC1Y7d7OPPT4zInBU3r4iFVAbTgkvzwKiyexYFl6ThoN4v0yxv4NX9OkDDFzBlwNf2N3r2n9rapue0NpcL2pg2ob9
 dXeCZ9CQ
 njE37sxaOqiDzlVliyvkt2R7LSqik5pvrqB1T3hMLuogLJvUoPYukb50W3RB84qSXUKEuL9BYS/mBmJ5vzu3u0aP//FIac5AftsEu31o6ogfHG9wOYVuQS2NW4w/6Z0kDwNw3k0HcM+NohqVYx/7dKXuRtTiNX37MRK9KetmZfdtltpikCcjTOAK9IyGOgnFGYQ4k3WfvkFJxt/g/layul5/c1M5qDRby5jg3Ks+JbVC1PbgOX+cmIAEuajQKRg3XfHO+Xk6U/kQhRb74ZtbeJGorQZUyk8cwuxUhHEiX2eYdECeveQi/l+ZfidcNXl8Iju8GRJTZR+1JZmToKIvImi3198luuwpC0vGdP5dwn7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently all drivers which use defio allocate system memory. All of them
also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocates
system RAM, so simply failed to set this flag when it ought to.

This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_IO
in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
erroring out with a kernel warning if not.

The logic requires a page from the driver and since commit 1ecbc7dd2902
("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
always required it to be refcounted, so this was implicitly already the
case.

Finally this patch sets VM_MIXEDMAP, as the logic is mapping
kernel-allocated memory so this is appropriate.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/video/fbdev/core/fb_defio.c | 6 +++---
 drivers/video/fbdev/ssd1307fb.c     | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index fd00b86e1ae6..fb359ecc3966 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -366,13 +366,13 @@ int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
+	if (WARN_ON_ONCE(!(info->flags & FBINFO_VIRTFB)))
+		return -EINVAL;
 	if (!try_module_get(THIS_MODULE))
 		return -EINVAL;
 
 	vma->vm_ops = &fb_deferred_io_vm_ops;
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
-	if (!(info->flags & FBINFO_VIRTFB))
-		vm_flags_set(vma, VM_IO);
+	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_private_data = info->fbdefio_state;
 
 	fb_deferred_io_state_get(info->fbdefio_state); /* released in vma->vm_ops->close() */
diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index c4fdecafd856..958514a35433 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -763,6 +763,8 @@ static int ssd1307fb_probe(struct i2c_client *client)
 	info->fix.smem_start = __pa(vmem);
 	info->fix.smem_len = vmem_size;
 
+	info->flags = FBINFO_VIRTFB;
+
 	fb_deferred_io_init(info);
 
 	i2c_set_clientdata(client, info);

-- 
2.55.0


