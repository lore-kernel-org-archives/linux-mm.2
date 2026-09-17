Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3C62C982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B57B6B00AD; Thu, 17 Sep 2026 12:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18D406B00AE; Thu, 17 Sep 2026 12:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A3F96B00AF; Thu, 17 Sep 2026 12:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D822E6B00AD
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:27:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7457012040C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:27:37 +0000 (UTC)
X-FDA: 85223784954.06.51C417A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id ADB4A1C000C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:27:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IcORuJ3n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662455;
	b=H+BV7+ujuFTJdL4BN7qFYnnW+lOFdVWQDvEzbAzCrM6RflHOlbhvtTCLDEzUv0Q9zbZctU
	maah+2obOq04UNS/Sz4+X2OfoLy72JLyeeZbfI/mEhJn/PtS6F7R0WWFDmAwuaF4cmo+wW
	jr60Yj5DTS1qjI/69OiTZGvYD4SUAu8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IcORuJ3n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxJPdlL4ukdxMfUTmFq0FMtswRM14QRAmb+14GeHlio=;
	b=ZpgOuDd+echwGN6mWRUqT11vCmumM15VFD3UZAVi6LymXWBOxxe5DPBeohJYYp6ao/rw34
	2gDPLARSIUcuwRU05Rkpixx2+KOweP/QerbvYz6zr46oFZcqixyeAmSSpLDe9dIVqctsMB
	r3CgrpAqjLxAU5cHgLtqvuHf1iYa7xA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57A0F601F1;
	Thu, 17 Sep 2026 16:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FEC1F00893;
	Thu, 17 Sep 2026 16:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662455;
	bh=CxJPdlL4ukdxMfUTmFq0FMtswRM14QRAmb+14GeHlio=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IcORuJ3nMChpo6WU1uYF0OWevbealV2BPcixTtf3CtI3dNgsKKnp/D9A4ivvGpGFn
	 C7wgPTeh92c8FDFeVvp4dhmfd9rUGrhrnjMqeqUh8Ze2yYdUxGUXUdo2TwPG/h7i6H
	 H24iTxqyQkl4K0YudfAb4Z7aYdAjA9VNW8gJdri0ngtUbo3tMPRG58gS0n6YIG6PUO
	 iDtiW14oRQszjZQYD1A+6RXPu66NieVaI8hm1FRPe4DIa6TfN3XCzMNnil9CCRoAPX
	 oOAM0OWsG3cxddEO85vcTLA/NXPpdSq3P9iOkLKfBGG735m87sEDFRIz7eg6UQn0JD
	 h9pJautmI4lPw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:18 +0100
Subject: [PATCH v3 09/40] docs: filesystems: update mmap_prepare docs for
 discontig kernel pgs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-9-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4561; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ku45FxaXB5jDrWF7xzKWcksoG8pHB6sirZFvJa9Q21A=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCO9/I77qciHTtLypd/9UFVzY1s3Zzzdfvn83B3cMd
 7H70oblHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIXAIjw/sMni1XVcoePFZ6
 8OLDvt+vW+8ovv1SfeUEN2ez4533nvoM/8xkZ6fej8t9/n6z2yqDhOuVsZM/Hy7q5X1rwZa7MY7
 9Ih8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ADB4A1C000C
X-Stat-Signature: j18j3yypktuqqhwzdtcj7unpnmw9dhaj
X-HE-Tag: 1789662455-225226
X-HE-Meta: U2FsdGVkX19TRQ1HGrVf5KusavJEG5OVK70CYm1La7KxFzsiG+XqvDDwcqppXqrfuvj7/1j7NOYp2l3zUPBsaUubjti6IkT4b2YhKcd5uxo73BnonSZCQhjZ+8/76SBXXO+K/V+80TQ3Tf5jKbYmkbVh8U2irmkdOs7DcArwQU0kxVGVLmu7Mh4cT3IfLQSSDq7UdgXkMa0sgudl+SBDQu+6VXsQnhYadwL73+3t/seUu0Z6t8t+rf4D5b+gpCPcNzCIB+LxveulNkQarEkqP+UqAU1mCo25/oLYMszOYSnm79kNUYeL1AAH3PbCNRGJHEVHTIXfFZhVyFDky970t4XiaQyI9+GY7hmfFOecvMmh6tD3UFynWSdYnQqnVcUxBPalUXsiM1tvQipnAwnRIjv+r3VqQuNs5xFSTj/uXny2PsEZ5HXdakbNRdjk9CcqIone1pdDFCAC+G1qu81kJw0Rgg9N4Oczne8/XmR/AaiZuLXusCCwQX9G8vvrVUbbMNvQ0nlbEn7JgTBbBeSXNEplaiQzxPwg9kZHnxDcEPH3ro/PQ212DPXIXCHo9z2HuwxtqjHI80UpLpgl2xGSPd/7NMTJzWaqrsMf02ETBOCJebnKdqOczEz4PaXMV/lRDZl94NecjTuw0zSXaYTzJu8SrprmPhdljI646ITk4FP+0SI6pi/ts5KMBm9xb/x3HULO/8ftRwA7tGfbLsieYdDe6J3dP0uYSyyubnFvBIUtsBwqG0jImDD/2Qm4eQ8C6i3HyISa5i7DZ0MlZvq6bKh/c7R5hcfQPYLR1peMTykIbnhC8Ua46Cnew+hilPu5Cg8b3fLJqw1Ol3Q0FRwZXCxTnwTzSCiKNdSy15k49kKs1n9ySy6f08OfBR4cXHK4z+2FojwVdGuTTrZOn5f71jdmynIEUZVCv/n3ufXxMBHrljtU/ns2cW5+XTAwm1A81hnjBsdvDQ/GRzHi8h2
 kx+9+acP
 Whi/clNFsmRdMUm9O1/fS8yT541s/Z5OW7frjLzVAFFhESnLKMEQoudyHmu3OD7kntZEqOMPEo8PGHzv9WSk9xYDIESi/3PMrxbPTiCK6iAXThJ3r4pySbiD4O4tmOMswQbjDygFmaytPfakDXdzrl+9N0t0UqzCy3MSE4jbXxhkTs4pLB75sTyyKlWwb8I5l1qEaGCVAsnXm1/4JNslpHBHkiI3/H+IXyPam7T1VuBnWnFq9g+hkzZA5ZiCjBMS9xr8lspAdOxe4bQXgkKIQjhpfGSfOH6/bcLGXQiGCuwqeyUkYcP5WsYeCy9aqAYbCMQoAwaQi1mDoLfw2qc8KdzLGv8L0K/VX1s9oQ2FCP9nM6E79gNdXYFtPsK65qh3hIUiXximu/c1v1NNxKhS5ECiBRdRHnXbIqPnNkGAvFaPkdDdDqKr9gzrgU05aDVCzYv1mpDP+ZTrI93uF9YcwBZ8dHqOzqA3fIGpRaaHOJBbgNK2Orwzhwk0SWkG37d/lAFxSsvPsz3AstbJcNpm/Gnv8TD49tTQplDYeslR/a8j/0Bcip1qtE4rJ2mTG7Zvy6kCGy58hKclki9vQLAIreVAU8hTQRNPU959exDaxvQRc9xy5veAYU1/QM0e/KGZjwllQL95frdUqJHBq+8CicAqV/cBBC01eNAcaVWjQJqjHhy9E40rff3VQOxdXGiQSGWrqliFuA3t2KfWF23I1puXxcStEynt/V0WDyDvvwuHQX5hQWW8zVeLU1EfFVL1ZiKjWenWCgyLmGC1UL89oW3dspAGUkNEvZAYtYfEjcrt4w7BDF7qeIpfk87zc3hiU6GibQFdwUKglNAFVg9fi9JUMmIT1oHWWqK24nzo2SW759xXJrUkcjeE+7odLqok/j6VUrqg2rC3HdXP5X3oRJmfMieMwMAuVw3MvOCUTngsqBY82CWiO5ggztp8IAq+xx6wIRBC92T/dfaskE+kH4AIqh6Y9
 f553GwX1
 lLv/E/aMGyoIRbFHE6j9eV3CZeWElvXDXxGwYdUt0ICbDiwspTHGtQ/Fcnh5dY62VYE8wC1OiHJ2+lfUtUAWZ68XGXCmYtsoyzA7p5NWvTQVVVvJMrXNR2L16KGiPKIV7WkESmtFRxPKZ5guQRwMlP9RyJm843hp9IP/AvkV4cA6fvrvPNts/2QpO3xmdeevrtOVj5q94QcSwpTvH+HOzJMz3KLMv8yyL7POx1TPz8/UJ6ksZS0I7sQEJMlTRoIeXTL5jrVWWZcgc/fg5g2YAhr+KrD6JAo6ywABw08sERPqYYdG1pT8GwMdWf7CTC/wsxxaU3pDib8td0V4CdsMpY2K1ptgHyCY9Pji+0KqEZcwtrdybDCIt+1ehH+wxmPw/D/ufeldGJzTfz6R+2veCChCIeWYHVskpGULisTWqRZL8UiMUOY9MZ8f8J3BRuxJnCS1dHx1QBbTym54TDD+JELKmksfdJfADeJdnNKUJtdiMXq4fH7/I5nacWU4pWMNGZCyUoJ18wYu4lEZD4EgNHpVaMAtoBYxRZqHGY4TxuV/mPNWdb1T4PsUF3jawDbKWe1ludnQYlIG6eWI+FoDoDQH8Cc8D/WuT0gsvq7SKQ/00aSoxT/qPnDRLHUO+VkrVla4fePibgdxGEXkyZtDgOfI7bGGgcWIfWJOQ0GzWy5TvdtfpVIPGih/zrsiweaEUIHndXUmn3uE7qzYngAaSNvEo5+rmEnhGYT/WTIDSYR0tosI57ORCGQGjFGvnm3vPGDl5+Q8e/Qr6ON83LR51shvA64gQMBnzXMalNCZwE0WmMrWrwaMdQeM/LFTQXuo4NTZ4e0rnWIPaTFofAx1RdGOLByDdx34/uF15joEy7ucu51+1YGV7Pqvxw3w2qs/5ddrZ7x8bEPIqpSzHBSRhiYGZRs5l5DqbGhFn8vidd9oEf2PlaHocukhTpyOKxQb39w4uMoMFJrHbmGLH85LqhsvS+BlX
 b2oV0c/m
 xqWV+HsZbZqskeEdhXorAmAFFdX7t4Xmcd/1pRlmWUptBxLGnOI8sH4J35lkzrhfXg8jntRZuQ11wKxz57UChh0iBcM1yxusk395SFq5IltCVxz1SUjkhso5QGEgSf3BNfpghbj4P+cGEjA+nIRHhvmFQWpapBH3hXZfsiQsFrO2qL7KAFqlLsqR3nR/Ht6jbcOn4NFH7Ui+mLOSu0r2N2cg9uJx4SmAAE+JVFDB8lbixzYp5AkGH1gmou/SAtqhTzUjdfsLjU7rkJvPzP6cMMsMRnBJTrUX8decCJx25Z7+LKH/B03mgzchAqvJWmsYL5hTFgHPjoPG+rjM0K8G3ERGWE1sbFuGfzrlzO+osqqzZr4uYDUNzBEXsNiP8cQ8SmFB73ietAz8bijMJtr/rlOwuZXWdag74QZFVQLd3ERaoDLtrAFBEVo9MQNsaoabcWk8HYD5fwemK+FtlJnETAYVBCZ7rrNZLSjvBMUz26GGFVVcS+G4bYSA6e6/JW6azigk1Zeza2/sMvZPCxoNBxgHD7/n27JGxCG9oHjrT7ojR0Jpo03LAX2ZbVfFft1Ooq6M2Ju/Brp7eBJQoK3cagCqVgF5l5aD2cwEeAr6aFut0Ny0VUftqvmulTDLREe55MVvRYm4M3X+1QpMgckS3P/Mqmi7V0sYZ37lyl8uJTbXjfMSnDd3RFq8kE3JQGeVW4LTHU9AMff5T45v+0tbLwzGiHvNZxO+mzuoTLsanIV0kHDLpSSrWdVJkQqvCuVGioRjTwCbDM/nEGqj8s+866At52DvJ6CmcY13MgDOL854czCKPJK/Hlx7OY3JxfmdY6+9oriLspdRxr6w8r1Q2PAUertYuTYTQ3hcAItzYx/GQBNFIHxOCuH5K4q/26fndJk5iHJjzlndOxkK0JUTWDQ9US0buGY0Ab0vnCCgPXOFhlY9MOXWXef7a/jXupG5rZlnWEgLyOfnANSZ77gMaavEVBhYE
 t5WbzcNL
 ZZYmmhutFl5xs0E0wYeA9ZInaaqrJyDQglX/JfJRtRj5hV4GLk93XRvx8qWiXZi+kSEMOlmKz82Ab4V67R86qUhMSAjpD97ZSinY3ECoQbFrGDc9txMjvH6aP35G5Yek7YIQzOUEJ0I1Hrj7J7T4OObF2sKx4n1nhQlnx+KCl2i/X/o+RIO8JKm47x4VsAwjndnSIMWqoMmfbjawwuckGUquSgoS0H6AgnsYRMaeool1T6e5doGTepLOav/Tw+KH/FXdtbPgK/VJL34lxZqmLpg53NmkvPeGzkguyZJKKxW7723s9Fiojq3+38gq0DnoodExdz0N1HHZV3xI/WQMF0RitxcxA0FE6jrbJgtWqrLhWzbwCrf1IfqRjtV+KgAcnHTd0KbUd4el5PSMDR42UFndeNcoPUrK+dEfxw/AUtQxc8vFV7h4DqMZUVVpxiYGwMdCS6CA5Wlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe the newly introduced discontiguous kernel page mapping mechanism,
detailing how to use it sensibly and how the API looks.

Explicitly detail the various discontiguous actions available and how to
use them.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 Documentation/filesystems/mmap_prepare.rst | 81 ++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
index 82c99c95ad85..a476e1006bf1 100644
--- a/Documentation/filesystems/mmap_prepare.rst
+++ b/Documentation/filesystems/mmap_prepare.rst
@@ -164,5 +164,86 @@ pointer. These are:
   sufficient entries in the page array to cover the entire range of the
   described VMA.
 
+* mmap_action_map_discontig_kernel_pages() - Maps a discontiguous range of
+  `struct page` pointers over the VMA. They must span from the start of the VMA,
+  but may terminate prior to the end (leaving the remainder unmapped).
+
 **NOTE:** The ``action`` field should never normally be manipulated directly,
 rather you ought to use one of these helpers.
+
+Discontiguous Actions
+=====================
+
+Some actions can be performed across discontiguous ranges.
+
+Map kernel pages
+----------------
+
+To map kernel pages discontiguously, you must provide hooks using ``struct
+discontig_kernel_page_ops``:
+
+.. code-block:: C
+
+    struct discontig_kernel_page_ops {
+        int (*init)(void *vm_private_data, void **private);
+        int (*get)(struct discontig_kernel_page_state *state);
+    };
+
+The ``init`` hook is optional and allows state to be established before the
+operation starts, for instance taking a reference count. Nothing is invoked
+after the operation, so ``init`` must not leave locks held, and state that must
+be released once the mapping goes away should be released in
+``vm_ops->close``.
+
+The ``init`` hook, if provided, is invoked prior to the operation starting. It
+may update what is pointed to by ``vm_private_data`` and/or ``private``. If an
+error is returned, then the operation is aborted. The ``private`` field can be
+reassigned.
+
+**NOTE:** The operation may sleep between invocations of ``get``, so locks
+needed to stabilise state must be taken and released within each hook.
+
+The ``get`` handler is the key means through which the operation is
+executed. The current state of the operation is provided through ``struct
+discontig_kernel_page_state``:
+
+.. code-block:: C
+
+    struct discontig_kernel_page_state {
+        /* Map state. */
+        unsigned long start;            /* Start address of VMA. */
+        unsigned long end;              /* End address of VMA. */
+        unsigned long addr;             /* The current address to be mapped. */
+        pgoff_t pgoff;                  /* The current pgoff to be mapped. */
+        unsigned long nr_pages_mapped;  /* The number of pages mapped. */
+        unsigned long nr_pages_remain;  /* The number of pages remaining. */
+
+        /* User-defined state. */
+        void *vm_private_data;          /* VMA private data. */
+        void *private;                  /* Mapping private data. */
+
+        /* Users should not touch these, use discontig_kernel_map_*() helpers. */
+        ... internal fields ...
+    };
+
+With ``private`` being an additional user-controllable state variable,
+initialised via ``mmap_action_map_discontig_kernel_pages()``, and
+``vm_private_data`` being equal to the ``desc->private_data`` field set in
+the ``mmap_prepare()`` hook.
+
+In the ``get`` hook, the user must choose how to map kernel pages:
+
+* ``discontig_kernel_map_abort()`` - Call this to abort the operation, whatever
+  has been mapped so far will be retained, the rest of the mapping will SIGBUS
+  if accessed.
+* ``discontig_kernel_map_page()`` - Maps a single page, correctly handling
+  compound pages (if the compound page is bigger than the remaining pages in the
+  VMA, then only those pages that fit will be mapped). For a compound page, the
+  head page must be passed.
+* ``discontig_kernel_map_page_range()`` - Map an array of pages of a specified
+  size. Note that if the number of pages specified exceeds the VMA size then an
+  error will arise.
+
+If an error arises after ``init`` succeeded, the core unmaps the VMA, invoking
+``vm_ops->close`` if set, which is therefore the place to release any state
+that ``init`` established.

-- 
2.55.0


