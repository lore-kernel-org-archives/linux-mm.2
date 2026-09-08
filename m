Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D187C79FAE
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786BF6B008A; Tue,  8 Sep 2026 16:02:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737FE6B008C; Tue,  8 Sep 2026 16:02:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FEE56B0092; Tue,  8 Sep 2026 16:02:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 351A66B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:02:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C16F9A50E7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:02:31 +0000 (UTC)
X-FDA: 85191667302.26.D7F4590
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E93D61C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:02:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YU+Xck8C;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788897750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uIndAhwL3wqvdcSni3GXyOpISzBISCVdYFz9JNsvqeQ=;
	b=NXXPPpb82+MkrSzC1/t6wbtwC54cDuTdcm/DjxQELtDXvRsVIG0+vjwbhrCzFzSLnuGu17
	ys5wOOy0qZhUPZoVPxcFmWT8nozbXtVsM1Pzf5pDHK891qJhcfO4wQmh8YjQ5fO8nuieiy
	PEP+5Zy1+tjGCZBAaqqcQW6zHkKZVKo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788897750;
	b=jULnQ0uXL+nG7AK2RG2j4u0VXPph3o4szJBwjvUlnEgfWbadMvg9wcB4YdZeHpMhMOVZsb
	cd6f+1RRcGKJOENUCAgJo6nUnyYNlLotT16C4GiQKBcT1IVuRIoOu2Srbd1lkHTtYLn4pp
	j2ETAUqAoZYzT+Fla7L0IkoRXYNKqEY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YU+Xck8C;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A0EE601F9;
	Tue,  8 Sep 2026 20:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BE11F00A3D;
	Tue,  8 Sep 2026 20:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788897747;
	bh=uIndAhwL3wqvdcSni3GXyOpISzBISCVdYFz9JNsvqeQ=;
	h=From:Subject:Date:To:Cc;
	b=YU+Xck8C+XjnsENVDQG6USbnOUb+aYEb+z3QjWcnFUpRoboWzDSJm/ve55xNBXnPz
	 VgRvExc5Kva/9BnOHdurKjRPDm3Ft1OrcC3qMwbvTUAozMre+hC/kspsJ1SR2kOznE
	 2P5inHtPA2s1ewMeO1/CgjKzGee8eAkXi9bnCLISEPEdn7EifxSjL1/CRvt/8Kabid
	 /D6G0BjYPYuszsaBnSin5vkycvI7daTPfopP1YmxREAxMj5DAp4A6TEyCzXVgJmAY+
	 wG7DfK1fw/6V47qtZWrjBKL/Mjo6hmM0E31ATaPUyDdYzTBKabLRqWnDJArfZK5EH5
	 i+cxeDdU6Vgaw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 00/39] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Date: Tue, 08 Sep 2026 21:01:04 +0100
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXN0QrCMAyF4VcZuTbQhk3BVxEvsi2dEVtLo2Nj7
 N2tevnB4T8bmBQVg3OzQZFZTZ+pwh8aGG6cJkEdq4EcHd2JPPYtxsgZc5HMRXCOjOHBExonDSu
 Sd66lbgwdM9RK3QVdfg+X69/27u8yvL5Z2PcPxx1VW4MAAAA=
X-Change-ID: 20260721-b4-mmap-prepare-vma-flag-sanify-2100425df5aa
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9577; i=ljs@kernel.org;
 h=from:subject:message-id; bh=bmDihYBTPF4s+vtesyigFctx5fwOO/lCZ7Euwx9606c=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG5gXXD/6AsmSxPurl1NWQeuatoyue3v8zrcIerNb
 Z7iceJhRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACai/IThF/Py3YWvW1dcT9wh
 H5qbnp6/PNRhjYKI6OYvUvUbbHZMbGVk2Lrs/nedQ1eiioIs/nuuf/H/Xkd/77w/O3b++q6ToOE
 8nw8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: mdnf86rccaijmt6w887w1xisdhk7t4r9
X-Rspamd-Queue-Id: E93D61C0003
X-HE-Tag: 1788897749-455489
X-HE-Meta: U2FsdGVkX1/dUw0/UegNOM/qtV8yH0zWP0c4vPWsdtKBSL8R9wYzeslFXecPg61cCWGMDp9VSEHoIVGxqaN6VbpW9yxXfdQINS6T235U2BV/ZG7h9RGHHh0y4RWiWedbhL0woGC4/CLIwTu7nPJE2sEwA77ArziLsTyRQ3DJISFa+q0zIyf1yvUJL5gGmv6WYb1fpa5+KOg5WI5YHfeU6JCPAijx/mV5ZrEA1eC6dpuR5p6rixkO2W1njlieZBaa72g2Y5ZtCH3C+lPDuzuzxjeSD/LxgcVE0CprZdEjZBFeMJIk4gzW0SB2ytyJ8XFIaGquNECALpIlRAN1AbnWcDHnQWI7DiTMTulFsOW11hDwLx1TWhbYG9JI/SesPScAeB0B2T09nx9EgdxehBoKHcP+fWxi0V+PETFgg6pem8CzYeBH7nQC6YLOd3z/OCvYTTQzIsaxifOHKfwO++JEB5yXRAsj3kVoYsDIagGa0omnbrbEYz+RfqNnvHAd/owZIzJ57mlX/X9dAq3p+ABRTNQegCGVAw/QvYYP1xc6DDGUHazQiTpDnxlFr/uBUzO2LalaUOC9U4+Ox6NnlMa8rc5N8TsslDbyB+zjYvhsmNI/hSzclZzthcVYuuwZveN5+WAJvIyN3mbORpw0iYiwg6ks+9T3mBVWe7j4B3waymxRjv5snTh1ob5QlnfZDB9ukHQlzlTffRHe4ayEFj3IABHK6V5ztpS6Fq5pBopxYkKSNL4FxFyRi5MgMWK8UfkW0S+/LPS4QxWAH2PNe9vcvhqMx2p+3YWBlu1NG4fTb3tASLQtzTXrrrUvMapfOXwEkDaN/PWL5J1Q3B93hbTAEXIcREtpc9k7r3XGT2u1dHQWPUKQ5hyAfkrbwJZ2u1eDW/3YkibPglNyT1maAjAnGyPKOEmP3H7ZRibD3193YRmugV4TKe/VHw2ht+j87gQSk+e6OAuz+J3/Sq71enz
 3oE1y+Hj
 0/9ehPRCZMj5xa5048EGOScinKcoAOxSrKNn5DPCrifyk+uuvY1/G3EYzOX7c15wi31WKvicoUZ71b1qYuz0QFFiMCkD+ZCLqnVGc5ACPH/bdhA9vCc8Iij7yxheQygKX99PiFgqtRdHWQ/+lfBNSCaFI+AYxiGVWvEZX6+o8D57ET2xjlyCJgDuCrY4X34xbo+bwaK+U5GaAJOcnXA/a92kNuei6tv+swPrt3NFmXZE7GAM0/wmp+J/8RnwbcHdJxVet+ijr7+DN7RYvOj3XY70gTXeK6nTtjBrSEWi6RKEVJHJcUV/S3jO+N96HcQrWJp3wZv4xKlZ0BSiWLcb5uuXKE2suprQOq5Mq6/A/c+xtBxDbG0krLSLttRbVPqyIaQxUlh3i15eYpts7rpJ+vTXLUwN5o/10Ck79VeawIvX+4TkpMtH6Ajb7c+BmFWj6f0XDG9Ciye932WVHN5qw/ubwUGivNqR1ZQ009VPJ9dMJC+h2oopfgj5EnVELbagZxq/hWJ5QjhF+n75o8r1QmisO+HQnafH+Xk3G+d4sl0Pq20ENuLSPRgoWTlM5I5zf+Er8nHHGETkSvKyLkW1ijys3G4VRdEcnOPLfAFNYYAuXVbJjBewWCdi1UKiThAqxtl3PDN8ptDobJV8zwp2EO8jPFZ73kzVen9ycLDy0ol3iZk3O0KV3JtfAPA4x7XNDgcO+KzuLeWRkvCDPUHPl/Pu7o6YWQUB91rs/GKujckK3I1IuBr1LxU8G/0yChjGZQfExpODhK7eObbYHUbIyOFh523NTt55WFADX7OBqhQlvX0zaOsCwr0mQICiwJ+wxMSSjFHVluWXYhFFuPMCX3sQx77CLP6uC9+I041Tl6VZnnY0DUPkjU/DDTRqe9+3T4kCDF/GPP9X6B0Uo1zEJGohZU8oKlbpFA1SPDv1qSh05a+Dz23NnOa5nkHBzv7SkngucCQlr0qxNhb55lOev/QDvyhDB
 QCa2L5YM
 dD275UgEreHV2KPnFfqFR3ISuT4S35dmUChKGCSUTF/BJMVEfGiKbPUGxZDGSb+hJmW5QOrghI44UPCePEWEWs/Sk+LlVfmcR1N72yCszwa6/FC1R+mm5LudAkk+pcfTlCDMxWokIs99YbOlelzebXV/IiaXVHAhkzs9zFfBC43zFFaHL6eBE1c6CP9PPuDo7D4bqqVzKPLEV3oyioURdakYzugz/oubF4vMy6nZYH8sOkmGs/eT2sxbuftWwcq5Fi/MGPES2w2v0eVyGxNlWxjaLug1V3Hp+k4ryL8rfVUVuo0Asq91piwxH9ClpVzOO9zEpUA5HoqTaYPCrkxsC3QnjkW2V/I1ta8PCysF3DqZiTEnrKhALcPN2Z0K7e8LEDznB+3xYhjuQgafvpuwYqAsniu8dc4troJlXJXgNbozmDBiSGb6qnEJPdS8kkHnVAUyqdXhDlquIlin828k34bap8AEdXMr9RW/6IGzNT22dsBTVDJxVsMqVD8K8s08WoZY8gnTVz/O/joss+e6mUhkrvDVwuRhzodPRaiMV83JMopaHyYcrvJCgggoCnbwHeao3htuSGowVF0ier7BRLNzxiXjjsRYxfUpwiwnCT60CNgEbiyo1QqebnqljiD3xhl2WzIRddG+WxBflJwIi1f9lczYFZL2ZD+1NFywc0N9euyLvT8HU7K/1DpHwv2CZqNgzX1x+6HBz55VJFgsv8o/1I2JC+ZrFQPpTGydcVu7QNrmXpfA6sybMP+fUMtIEFRzUAL6IkWxCR2/6YO9xrs490I7X+CGVy7Kd2ubxtxoc9z++0aVBg0X1nKmKKnrgrFaf1p7FVcy28ohyKDBHGLZhITdwZ/R1/6AHwusLeBjt+MohIiDgHvu+sAaIf7QHcwApQlm6RvatLkJnAmdwwEV/i1lMlgA9nyU4ZFWL2AmuwOxv3STnqe4Ck3F+IGh4O390IEF/agcJUmtTQpZ7tL4LSuUX
 YnJF9/Qo
 8V6+JpQpr/bWiJYjWeNNWX0Oxve3bxQqqnJ8yJ2PaRSofAhlcuLcLh2YwyYMa1bYRIUjY9of36+TFbfQTOLovKoKEzOn6QNpC955GeTXozTsJo67eP5a53R8UMUSFSTSnVSSh6HecrtpnA7vxGWCVLH+UoSuy7+nQmGJLeXl2YUiGhthqe2OLNvLeNrUkivbHr8sag1X1PhdMl6mP8swgkbj6LqtfKg1VSLac8cN8xwbNn3uI2SBPRnmq1MsWaMiFbU5wxB7n2BYL1fxwM/0WzlbXr/dwzJvNaCodZMwwUjGw+CfrKtWYnXouEssWDi0z17Av/T7jrkQjJWLxK6XdJnEIgMkZ/ziCkfiaPo0H2LFkR6QZw6T6XDxYhJJWnfgPhQBNS2swA7Dt3GLn8GTC4/ULvWPFZ+jnB9GhFoFbgpUErlvIS6nQaL1Y1PBSQeJ54L8i1eVcqT3PKPmvQ5GfjWxufBR/fOhsP89ba/aJrIqfO/nu169pKutrf+DOHfjqBxbRaQ5RQrgJ8UN6apy6cG0sq+0IP04yg0MP4FKGCE69q9gacwzjJsab3GaIQbp42GNZJKvvGu/wklfucSo+rfVxyfESlMQv/ritOp/Zqc4d67Bcat3nQk4lQFiCi8mwI12IPK2F84gvf//VJFgIRlMt8qOaOn50xJMTeW0pawM7iI2vD8zB03CC0MbFby4qW5kAlNOEN8kyq7CBuYKwlB7QdH1R6QgymSuIQG81Uwm286TmiZXjLhuwkjEYMSu/gApy9pNxf18tL8vht41PI6MS264qOfC9yT/tk+t5CqOPRSLs9g1kL9rVNksHR86/fDPNcSYbLJgUpoRSJ7foDHHt8prTnXG5eDZq1/umDn5DFCDoJ9Kfm+V6XJwz4UDvR6zry/y4P+m7SNlLm40HbF938qWw6SVQ5LC6bNkbI1sZnfxlVLVar1Y+c+exiRg93SfiFZHJ6gUEKLc5BOHQoqeRcCVO
 q6gv66ma
 nql9NQQEBeHARpPRb21fZUI9r1o+XjumSQLHl8Gs/II4BO7ATO+aELsOOQV91Om5NQrSuKK7q6kByn+daR7Pemgw4bJQOpXNQF8qo2V4NGgfR/EJ4vUPD7Uno61g2B9YhD8VMssUVhS74/tCg87la08g1TfQatwm221QY2VtOewlSsRw09NQON8pkDXQ9DGsovQ+JzcyIKFpe0CQ90G81GcPXNeA0GEzPDQcHB2Gtephynuc3abHZGTf0QARuDj9ilSfGvsahQB1vDzB564CFuUd0OSY2MhT1CwqVTmhK0aH2buhSgKhxQZygyGa9l9Qa50qilktOS4N5l4ASTK9Tj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
properties:

* Is this kernel-owned, whether MMIO, kernel-allocated pages, or ordinary
  pages a driver maps itself?
* Can it be expanded or merged?
* Is this a 'weird' case like mlock where migration might race and we
  'have' to set invalid flags to notify?
* Is it another 'weird' case where we just want to stop GUP from touching
  it?

Driver writers have often been confused about this, and who can blame them?

It also interacts badly with the eternal edgecase known as hugetlb - which
sets VMA_DONTEXPAND_BIT but doesn't also want to be treated like a
'special' flag.

Another issue is that we cannot make sensible assumptions about flag
use. It's not possible to assume VMA_IO_BIT means iommu because drivers
abuse it and mlock abuses it.

Special is also an overloaded term in mm. VDSO and VVAR mappings are also
called 'special' but they're special in a... special way.

Sometimes things are called special that are a subset of
VMA_SPECIAL_FLAGS (VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT for instance when it
comes to zapping or vm_normal_folio()).

There's a specific kind of special for THP too, which considers
PFN map, mixed map 'special' but DAX not.

It's all rather a mess.

This series brings some order to things by both limiting what drivers can
do with VMA flags and switching to using predicates that describe
behaviour, not arbitrary flags.

It establishes the invariant that only kernel-owned mappings may set
VMA_IO_BIT or clear VMA_MAYWRITE_BIT in an mmap hook, enforcing this by
validating VMA state after every mmap and mmap_prepare hook.

It updates usbmon and sg to mmap_prepare in order to do so, adding a new
mmap action for mapping discontiguous kernel pages, and has hfi1 and the
ALSA PCM status page map their pages eagerly instead.

It also establishes the invariant that VMA_MIXEDMAP_BIT be set when mapping
kernel memory, something that is usually the case but happens not to be for
some users - specifically defio, cmt_speech, uprobes and the bpf arena, all
of which are updated to do the right thing.

It replaces VM_SPECIAL and arbitrary flag tests with predicates that say
what is actually being tested:

   vma_is_kernel_owned()   Does a driver or kernel code manage a VMA's
                           life cycle?

  vma_is_fixed_mapping()   Is the VMA not permitted to be expanded or
                           merged?

     vma_is_persistent()   Do bytes written to the VMA stay written, and
                           bytes read stay the same unless userland changes
                           them?

         vma_can_merge()   Can the VMA be merged with a compatible
                           neighbour?

           vma_can_gup()   Can GUP obtain pages from the VMA, i.e. is it
                           neither a PFN map nor memory-mapped I/O?

Remaining raw VMA_IO_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT tests
scattered across mm are also converted to predicates where it makes sense
to do so.

And also the opportunity is taken to eliminate THP's vma_is_special_huge()
which was an existing source of confusion.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Lorenzo Stoakes (ARM) (39):
      mm/vma: predicate setting mmap_prepare VMA fields on new vma alloc
      mm/vma: introduce and use vma_[flags_]can_merge()
      mm: consistently validate VMA state after mmap[_prepare] hooks
      mm/vma: ensure mmap_prepare doesn't set actions on a mergeable vma
      mm: make map_kernel_pages_[prepare,complete] internal and unexported
      mm/vma: tidy up map kernel pages enum values
      mm: add mmap action for discontiguous kernel page mapping
      docs: filesystems: update mmap_prepare docs for discontig kernel pgs
      drivers/usb/mon: update to use mmap_prepare + map kernel pages
      infiniband: update hfi1 to use remap_vmalloc_range()
      selinux: reject writable opens of policy file, drop mmap shared/write check
      ALSA: pcm: use vm_insert_page() to map PCM status page
      bpf: arena: mark arena_map_mmap() mappings VM_MIXEDMAP
      mm/vma: add vma[_flags]_is_kernel_owned() predicates
      mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT if kernel-owned
      mm/vma: add and use vma_[flags]_is_fixed_mapping
      scsi: sg: convert mmap hook to mmap_prepare and rework
      fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO, add VM_MIXEDMAP
      HSI: cmt_speech: convert mmap hook to mmap_prepare, refactor
      mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
      uprobes: remove VM_IO, set VM_MIXEDMAP for mapped kernel pages
      mm/mlock: clear VMA_LOCKED_MASK over mmap callback
      mm/mlock: eliminate weird VMA_IO_BIT abuse and simplify
      mm/vma: enforce that only kernel-owned mappings may set VMA_IO_BIT
      mm: remove VMA_IO_BIT check in vma[_flags]_is_kernel_owned()
      mm: remove hugetlb_inline.h
      mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
      mm: drop some redundant checks around hugetlb VMAs
      mm/madvise: update is_valid_guard_vma() to use vma_can_merge()
      mm/vma: introduce vma[_flags]_is_persistent()
      mm/uffd: use predicates for userfaultfd checks
      mm/madvise: use predicates for madvise(..., MADV_DOFORK)
      mm: eliminate VMA_SPECIAL_FLAGS usage when hugetlb explicitly tested
      mm: eliminate VMA_SPECIAL_FLAGS check in lru_gen_look_around()
      mm: avoid use of VMA_SPECIAL_FLAGS in migrate_vma_setup()
      mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
      fuse: dax: do not set VM_MIXEDMAP
      mm/huge_memory: remove vma_is_special_huge()
      mm/vma: introduce and use vma[_flags]_can_gup()

 Documentation/filesystems/mmap_prepare.rst |  81 +++++++++
 arch/arm64/kvm/mmu.c                       |   4 +-
 arch/powerpc/mm/book3s64/radix_tlb.c       |   6 +-
 arch/powerpc/mm/nohash/e500_hugetlbpage.c  |   2 +-
 arch/powerpc/mm/nohash/tlb.c               |   2 +-
 arch/riscv/kvm/mmu.c                       |   2 +-
 arch/riscv/mm/tlbflush.c                   |   2 +-
 arch/s390/mm/gmap_helpers.c                |   6 +-
 arch/sparc/mm/init_64.c                    |   2 +-
 arch/x86/kernel/uprobes.c                  |   2 +-
 drivers/gpu/drm/drm_gpusvm.c               |   5 +-
 drivers/hsi/clients/cmt_speech.c           |  33 +---
 drivers/infiniband/hw/hfi1/file_ops.c      |  79 +++------
 drivers/scsi/sg.c                          | 115 ++++++-------
 drivers/usb/mon/mon_bin.c                  |  82 +++++----
 drivers/video/fbdev/core/fb_defio.c        |   6 +-
 drivers/video/fbdev/ssd1307fb.c            |   2 +
 fs/coredump.c                              |   6 +-
 fs/fuse/dax.c                              |   2 +-
 fs/hugetlbfs/inode.c                       |   2 +-
 fs/proc/task_mmu.c                         |   8 +-
 include/asm-generic/tlb.h                  |   4 +-
 include/linux/hugetlb.h                    |   5 +-
 include/linux/hugetlb_inline.h             |  28 ---
 include/linux/mm.h                         | 266 +++++++++++++++++++++++++++--
 include/linux/mm_types.h                   |  50 +++++-
 include/linux/pagemap.h                    |   1 -
 include/linux/rmap.h                       |   2 +-
 include/linux/userfaultfd_k.h              |   1 -
 kernel/bpf/arena.c                         |   3 +-
 kernel/events/core.c                       |   2 +-
 kernel/events/uprobes.c                    |   4 +-
 kernel/sched/fair.c                        |   3 +-
 mm/folio.c                                 |   2 +-
 mm/gup.c                                   |  15 +-
 mm/hmm.c                                   |   3 +-
 mm/huge_memory.c                           |  31 ++--
 mm/hugetlb.c                               |  14 +-
 mm/internal.h                              |  71 ++++----
 mm/ksm.c                                   |   4 +-
 mm/madvise.c                               |  28 +--
 mm/memory.c                                | 142 ++++++++++++---
 mm/mempolicy.c                             |   5 +-
 mm/migrate_device.c                        |  12 +-
 mm/mlock.c                                 |  51 +++---
 mm/mmap.c                                  |   2 +-
 mm/mmu_gather.c                            |   2 +-
 mm/mprotect.c                              |   5 +-
 mm/mremap.c                                |  11 +-
 mm/page_vma_mapped.c                       |   4 +-
 mm/pagewalk.c                              |   2 +-
 mm/rmap.c                                  |   4 +-
 mm/swapfile.c                              |   2 +-
 mm/userfaultfd.c                           |  45 +++--
 mm/util.c                                  |  22 ++-
 mm/vma.c                                   | 161 +++++++++++++----
 mm/vma.h                                   |  24 ++-
 mm/vma_internal.h                          |   1 -
 mm/vmscan.c                                |   9 +-
 security/selinux/selinuxfs.c               |  11 +-
 sound/core/pcm_native.c                    |  37 ++--
 tools/testing/vma/include/dup.h            |  60 +++++--
 tools/testing/vma/include/stubs.h          |   2 +-
 tools/testing/vma/tests/merge.c            |  10 +-
 64 files changed, 1071 insertions(+), 539 deletions(-)
---
base-commit: d118502628f8b673be9023db8bdf878f64a7ed45
change-id: 20260721-b4-mmap-prepare-vma-flag-sanify-2100425df5aa

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


