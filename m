Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3868C88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14FAF6B00A1; Mon, 14 Sep 2026 11:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA916B00A2; Mon, 14 Sep 2026 11:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBCB96B00A5; Mon, 14 Sep 2026 11:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC8F26B00A1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:00:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC16D1A016E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:00:54 +0000 (UTC)
X-FDA: 85212680028.03.72F0E77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 217AEC000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:00:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k272WiCM;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jnM1GsA9H7o34yRQ0eF8yQwW9qODITMQHOHlTqLrEwM=;
	b=8L7v+2yVOLzBGj/gkIg1FiF8aJYKZm/AZGyWrSp7+ZRvkmOEZZTDhznzg5H8QvXr01V3Y0
	i+y51YePH175GWhVPXw+ZzG7ZL5+/D+9jAhq7Vr+sr1XCj10vJnl2Y0/0eXpiT/ulKc1TJ
	DsaBntoACUdojr9HjA+zw28dZeb+6xw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k272WiCM;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398053;
	b=ef9VWf+sA3RjdapAnMn6WVEbNm32RhLe2eoSw6lniTBCKAVqJoD5g5QrOCTR1eMmWmD+9d
	YhBZA8+OcpejihrzAFIdCRMsmhEy486+QnbvOk8IfAVWHG60EZfSV9s2QoK5BKrPC2Bq1x
	YWN0HM+d7KBcJJPsxM6Ij5XLhfbZZ7U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4984E60142;
	Mon, 14 Sep 2026 15:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52371F0089A;
	Mon, 14 Sep 2026 15:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398052;
	bh=jnM1GsA9H7o34yRQ0eF8yQwW9qODITMQHOHlTqLrEwM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k272WiCMeVOfTkjgsOqSHrR31bdHuIqZE54YmIPsbFx5Lx/nW//2GH57VtUdD4fve
	 adrIqrmI5y67hBOGluixAZPziSWHUplLSC6UWi115hWJ8HdBDWhAe1+IbDYiylRGVn
	 BGt6aSapXEhEkVSG79TOAJ+exXex/fBQZnhXNNF2qeKqpxQUBv1v7yUKBhqj0pmOG0
	 rsula901YG9tlVDqA0mdJh+Qq8Ywrorkk96/AHMUH7JjBarDHCQ5NiBYTOvmAqKiJK
	 bKg/4M3qVN/mIrycokuPxEdxH4as74ZBgJgc2/+SB6m71zuMTrikybxAGEZqe+i5ry
	 Bt5RSoCnf1LSQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:23 +0100
Subject: [PATCH v2 03/40] mm/vma: introduce and use vma_[flags_]can_merge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-3-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3665; i=ljs@kernel.org;
 h=from:subject:message-id; bh=UeK+5t/ISBUMaOH/QNariNr0UAqFlz1uaZ8lVxwqw7Y=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK8rmnjvysq/xZz/+RgK648+Wnfy3/Mrv2dVH1nRt
 M7xn9jkZx2lLAxiXAyyYoosz7+I7w8SCZvXecHfDWYOKxPIEAYuTgGYSHkWI8ONtK/6N85texQy
 R7EirenuOb/Tsyazvahvbf4/c+uHuuJqhv+VNpv+O7TGcdxJVQntMpa8NPkBx3r15w//TjFZfT8
 5NIARAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 217AEC000A
X-Stat-Signature: nrcdkamurwd4zxi8j9p1q4bi7mcbtrmg
X-Rspam-User: 
X-HE-Tag: 1789398052-925000
X-HE-Meta: U2FsdGVkX1/nZJRaIKEt6faq9I7CzaV2+h+uHQ9XPctSsw0OCUn/q5rAwU5lMLEQqQEV2DbxEZ4bLVZW81daNL2+Eg75gBbx8E2SOLmvtmHAL1CyP4636WJ26ji5p7qjBIF8qXB8I43iNcES0sgl2i0adzRqLKFWjl8CSwoas5u8HjGvw5bLD3sdJdgA2KHyfdZQnKLk/Ku5rS3C9UdwzyzKPYCelIDwWXpaadKuVQOKPlk5C1G2NTozLObmf6iTDRqsA/GEZjhdvoSpyZgdJxUzNpAEEhoEQ9KZ0F/gmuVT6i1ADdMb0IkgHHTPSvl9YUmgLN8hTxrF3kx0xfwtKLHYT9MuIBZcJKOn/0pDpMDL3DCbSEgBVEk0TtHt3cO340ahGC3sKIVcJ1iZCDR5lZvopw/TTACh069dK/ENVoovxrP4rhuw39vPgzyUKCwPvjiidXAp7EfEDIEdAs2fkMaLDiz3OiXX0ihhTSIbe3dmLiDCsCGwBIk8Ck05Vh2eBTX4agWY2Djki9Pmlkw+Wq0JzkqZlELfdDydT7xelCDub8rs9nZyDbLPcG9YKpRkz3Qbm7Ps3Sw6WDVSunGx9UWpOsB6o/zlD7sSnIMLyqTlsZTlWNNX0rF/MzZEfyxQByEIW+0ebVrEEc8dhvNxDRLvEMXBEjdUSTECm1P6mXGpN3u8pqR5zfJE4fp2kAnPg5Rw2vTb/MzqetJ9Dfrkc/sv4hXuvI8OLANlIYVAwpO9F0a/bomDr4ZrUwB3MUow6sJx9sIaNV5wPZdRmhYJl0anVP3ziVyRHUpftuwn1wwUE3PLA9BeCS3/iSGBxhTgEKVsppfmbBkr9xDz1p6+IeNIp2aGwcpGRLSFEYSGyMvBOLbXtxfYUwOl9dunDsPvuundaWL1h+2sk3db5XBCWyTjsUl8DECwQgt8gyL9DiMZYLFsaWhdFobpvIqGSHi5vgrson1bDaYkUjtZv3Y
 dw6eoLOp
 Nsrwfo7GaUGUog1ZVw7GmeElxf4X+OaADv6OQ+dFGpKcrM5fBPVMqv7WHMOJVcyTHlykRWrjsi7JE4PR06dC1lY/UbAort66rkUvusK4XiVNzr/r6BfD+CvOo98sPk2+/txoz/XWJE0yg5x1O7YQqvdsdxXhzbobbe0OD9pL84iha1DdjYah6/s4+245P1MzY9QtcR+49RIBZlkUC1tqgKknsW2ro110xvfLs61x9bGawI4XCkqJd/ffj9vfX/lcoa5XNh17ulMZ/AvTp3e/0rEAttMD8AKL502hAhggSiRmCyqsw+dO1SHiADJJda58AGfRuz/kl+Zhv4vcIoVfTRIkXRl8N8lnbH+rU21Vv1x16CePIaZCSnX/sIwQe6zBprHZjUGdYjHFoUzvaGjYyY+wmdwS5CIj68/f4aTCkU2X8j73WtAKsbR9ZfSFnJCiEgHAcOy/gOZGQZhrfQfkmI5CrPL4TCouLkbVGBu/UTnewmuk74+5f0p/jPVSETNRuAnoUBKQnFPy4d8gwJvW2BDYu9ABlDjhqz0Vp9tDa6OOg8f40uIj2lcFZ1WqFW3SI1g5MVgZIiTKTfaGMVuCePQw/y9NVdUvd6ba9UQnf3ZNUhg9jmywkDBeMpQwC+fNEOHp1m9Q7UfYyLNHLvmGDguXvLTT0TL0ZN5yRaKyIX615JjikkGwsjlgIIyeauTu47922pTculp0DIgbJ3TCt8c/a/dNm4xSZQL+hmvVCaW1Rtobm2zsBW/3puq9hur1LHCol7TnsPq5r1LVwQJYgIZqY8/aGwpk6SdEvVhp1YyuCwX75bbpptmtF6cyPwfz1hgcs175QX8X5T1Mq914cBgwKd8cs5NO2hfHnSDkUHUiNabqxHVkNB9/EBJiksqJkIaxAF5h65UYmDp0C4KGdZIgfJeA/dvQmZaIbpacKrY2wLTEzj91DekbgRHxQVxVUWOqmeW2PUzpZKk9wV9oTpVyOSOze
 kUGzAkLr
 zP5t7moMzcRy0gXZm2/FQK4H02e61qfoILpRiQw51hjcebFosoBlS1WGiEtjJy480xxaURzJvWssFyyzolL7C52lQGfg9zef1daqLHaE2bLiZqw+7uz0BsKB7GJ5zMpsJBXzFZC5mCyWimP/lhe5iSGb7j5YaVY3Qcu5bS7RfSA/Qpw93Vh7lmzv5SlKTEAO+SSBzPrMdOADqS/QPTklqJ6IqX2DgTDZOe65H3N9Ij5PRC6UESKPbbDCb+C8goW+Og9nz5SlyucIeeAkJFjMcXRHxBlMssVjf4TeRtQ8V3KFBX73Hz1b01sB1K/EL5742Ulr6iXZPggSwHVwBq91XyzG74R4cj7/pFznNIE/7xslpluPVlbX6czF1WaOwHGvhwocfD47eVfLH7mkrHG6vo5LfWdhJF6+vL4ZQiD+UrvXcps+0tLZ7a8+0IMiv5Ova/W0E/eiao4MiWMa8NofkI8Dn77Axd/Ft/gI8Ruv5LjPMYNjjhASKUkBAfkPFsMwaV6Lg16AK2buarQN3htiJUebTPj2LF45g3Zy0+zQwm/qhqsDaENgQW4NRAnnQQCxw1ZYe/7YzVUiPJ5ijjbH5DgEvPaHlNiVDud6i2qx+4EHif6wpFPAcpZar8K/LP2xNNLAAHT2lFmQ9HVCtbeeD6SC4uWeVqLn1iHFmrDU+waxKcetJd/7dVTjor/vAb7gqXJNGWNsBCaKNS9uPNTDTiL7aRVqKXyZkmTte76Bll6EEHm7yM42o6W59LLEHxofHhJM23RnJ5gLunRdgPxGKUD+Ysa3BcXuEf204Sou9QoJwvB0jpi3jY/wCvv+IdOxwvbotxNc386BGbpcvEgxbwwdhxKeSL1L96/OJkvTHQvsa/ZUDLydTzxr8ykBIPlqFYVMEcMEfvTmcniEXe6SmQnuPAXHFnfQyJ737aHvi8PgNHMNFhc1K1p5HohMWO6ugMf1dNJKDHN4b0MY+0Qo0ijHFfetO
 lcdewhkj
 LbdE4b+Cec49I7kq92T7cGnUROAtwEU3xqC7AI2c6o3ld7XnwQzxYJJr3vb1bHR5n0OkfY/aggk4ovpZcEUEF5utuZuRcUR/T/P6yU7oAlgoD1GLfo9e0hP0vLKa8eOuJDvVb0jNhyM71lcfBzKjqxqW2jDqcDBjm0jHfKF+FCIEskCDhfMpc3YOBxd4d18Y/1xoI4U38ggB4O4C/PUO07Ewc/aI0zbyoZst8SuvZ++sg3PSJluH+akooCbwgKNIM9TGO5MS24U1Vcmp3FrZxDTj9jaC5qxRxnTKZ40Uh5/3eIifDPUnqNv9BzR3B+LRUIdhdyRyk+vRgRa3/I2SERLvddoxumuLFEcHOAIUXaX6+s6lBb6Q3LrZlRAoStGntOGRU2Z7+ulQDdgnsnyPnK4YVGRf+soxkDvyg/7IF+nmk3RV/8I7s3CfnNFfeXeVbkNOUbI9LS6iqViUPRnCSPKNkosDKYXZqGen6sECnJWyIIuVQ0fZrUhNgyKt3YpM8zCQNGuJh6d64kqS/NoEtGNtCLidVfy4z+RJtGujXk/D+5hKpjJUNnUW95RUBaFmtHImlVwzhp97on+XuynkwX5PRg2NEt93iB3/UCAm4+yE4mDZgcpbgLyLnaG1KfDN7t91bsLG8QiG6gw41av5X3MqhlSvVpIEzYiKTwFf5ps01E07sII+NG8PfJ/jcrU2lJxjEPs2dgBuUo5vC0Yc3HUSsjIhu8B1kaQIUIoB/ZUrRDxW4odrb/D2pNxfmWVSgZb7+NufnV0n3SkbO044uhO/4ovtplwzyF01DPpsmafLXWpfVKeXM1JXS2x5u9xrObnrJA7m8fO29uY0B1PqUabnjoIMJ5/aH2OnVrVwKFcNgk1WUGvZpeugJDo+CvoGcCbROdgxiqYmk6tQjJ2+ASz0m1L6g5LyVQdRUKHfce6teP/mvZpJyv0Ov9Ny9DH7ryKUAOrMXRUdPmkGRksSRDqgm/VQZ
 5IBEGxyV
 z9phx4djzjbqkpAmUlRbGiKyMKyL7jwFaqA81Yy8YzDjGTB28xRjtyZbJPoKEoHZ+zIXVdDNx6Tb+37tm2mnjKGMeQpJvWeqLcYimqNojEkrtE5trZlprQKr++dVm3FuYihtNA4rn3G4sqW2stqaoF64dZbjUHkvkVUkys6xjow9erUTY0OIct5NnADqB8pyKbPn6BCBt7q4FnhditM6B5HUlsCDNRppqR0T3wETzNA2Rhk2NdIzKs5e28BPZfwMtBnqfUKKW+iGH1FhWQL7h+GPrHuVoktHt4T3xjL3pJT9Olp4AnH9YRa+D5InYZDvrfCIMUoT5SPBNdk8Z++17hLsf8Ikm3JIBE3k18/4ZexIdeIuJ8mNARNIzIyxo20mW2DA8Jbshyw+htymORTTEMPQ9pher1utz8i6M4jba6Jv3leWicR9fQJDWIpzsUSacaXLRdLqCbnw==
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
index cd9e2113f66e..dc74b3d721cc 100644
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


