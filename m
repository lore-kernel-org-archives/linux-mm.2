Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D6DC982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A786B00B2; Thu, 17 Sep 2026 12:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA3F6B00B3; Thu, 17 Sep 2026 12:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83066B00B4; Thu, 17 Sep 2026 12:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA0286B00B2
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:34:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41085160402
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:34:45 +0000 (UTC)
X-FDA: 85223802930.13.EA3F53D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5DA39120006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:34:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HrTjhgWc;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZ2BcQjAwuwkC6/1VounDnE32rIC0Hjr2OUSnxyIkA8=;
	b=U68Se8AdOawgFp2uAYZnIDT8Oj+p5piJBfJjrYObvKxeF7CeGne3f9aZxkEiuBJX+fg9it
	sz+m9QcNpIq5CvxXHhsnAUTaEs8DxkCY9HBjUEnET/hYyI6LQeESLvhv8rTkR08y0lGIka
	XneK7LBmt5ZYC7ayQ0uowO7FT/Tuqzg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HrTjhgWc;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662883;
	b=oVix10BeYxF43+uTR8i+2yhFuN+9dRSo41oeKrsBZ3J2GvuRoKaa9gi/IQExxmjyJh+5rO
	YycMVTK1Z2IkaFct1TRhvWgCxqfqI6WNveGvFzbU935gGWt3lr2q0v+zdL2flxel7aTWj8
	yfdcK8uMj+m4Y9H3Og9uSs1TYMiSiV0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97EC5423E3;
	Thu, 17 Sep 2026 16:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B430A1F00898;
	Thu, 17 Sep 2026 16:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662882;
	bh=vZ2BcQjAwuwkC6/1VounDnE32rIC0Hjr2OUSnxyIkA8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HrTjhgWc4//TyGo0MLAC3WMKB3trg0Da9llQBlNoG2CpnsE0E+nakCyji8mxZQpme
	 VxHtk/idNgtQHfSor0Csyd9oGbaEoBYWo5jU9iNQ8ixYYL7YholnWwWdjJ4ajhiULo
	 Rt8HXHFM9s9qJkcNIEd9WiyFvrIxm8Ob2Yziy+8eirXWq3iHf+8bU1EthZuZAvWGTz
	 XibJ9IjZMVpXZBSOt2SVbDtXwXstrt0FCqmIib4HPGqMeXtQTPrE7Dj694QH14hQGs
	 VddhDCAHjtM8xo5QTvEBLv6Je7pdirLDgUavvQkghweAOYclDKp41x5BVF7eVbvUlz
	 2c2X7fiXPR9PQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:32 +0100
Subject: [PATCH v3 23/40] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-23-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2686; i=ljs@kernel.org;
 h=from:subject:message-id; bh=LP2OVTJBUZHnaHZyV54sJNvm4xxGiJDQinrnPbsdCWM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB86ImDlv7d0LV9pyYYSnTXehbNvS6Z4eWg9PxvNf
 6c17ItuRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZSpcPwT/Gqj2rCgy9S2gsd
 lH2dxR687NLN9Zwt0l65W7fT43ykNCNDR/dUtWOr0gLXbTrNuv1CZ2Dqc3WLVGmxJ92z5f9UPAr
 kBQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5DA39120006
X-Stat-Signature: 45gewof3qg6zsbf6eg9yawrqhu916nor
X-Rspam-User: 
X-HE-Tag: 1789662883-766399
X-HE-Meta: U2FsdGVkX1+z0tRF2+ZjcmP89RY4KOkkYcVhPYzM/IGefKt0Rdi/9ERvv6w+2GoNwEm9ABIng605ubgSn9JrKlPtpN+96zFflrAg94WW7F8fUWZFF+Oz6JGpihvJ4QqHixSmePNvpUky2CVutcmCs8C5kM58lQA73TpTp8CISldy/5B+lmK7zOJHDRJdZSKAZAlH48kSZNRcG2sPf9mqYD5KgwT7yGbOgD6JfyyWcEz9SWTP3OPg3vX9RnYxbFGIyLqSSq1wDrhwAZUZMF2s/KyMYRb/k7luAniahKJAqWyt1p07jS/CucmLd9NpEKDy7/tWYdW9FqOPmdBHiQI3EnBxqVW/3EqnkKLJEK8B2ZqZSXmoCU83eTTNNG0fSIKjyV0eRWP4S+Lt+AzMf5mM01M9LLqBMuTNiR5ufOmx8+xBOGvySGR8vqMIb3pKsPIIskI/YNmKp9ZAKOXsPc0FgFkESoO/8kvHR60FAr4pQ7BUEWm8jCZO/KB7I13tsWIrS922nPnecoaSFrIonm5uPwqGpNk7WFqKQE0zrQBRnb9MoEqmd8P0wqfKxH0VysSV4tOnkpnsyFnQf3vfocRyNGnwUijXB9MKFMM82k2ZvHnRyg3bvfH3Ir/u1Zf6naPYOrpsNfFDUtWBi2LP6dtMRKs4c+jgCOfEplzbvmVehD3XeO4xFPUjKU6UYlN4aPEfoh+uovUcUG+s72y4+xtZELCHSbt14YdBVKVXoX8j5clEGyrvykvIqzEOqipLVaWHsqEgeh8n5JQ8T6mbO9/m0VpHUe44C3Lzice7HgFwhldH1hWod18d4KAEbCNspJvKJZK7ZS/UYbdrSF96NxvbK38If126fqw0gO2nynIMg/ZvkQtd+OTE75+OwRZMm/nWcnCmTvYmVOT0WbH+EpTfHkwysHEb7olYxMfFUNI1btRjmdt/utuFhOiIPXQQgKXB/57XAxT++Bf/abdE7/C
 nQkqqffE
 mZo1L1neR2n+w2pKyXuKOKn1AXGJ4CeFJAVytPrpJ/NUHLZQAXygVnueyUh1dE8/aqJ/pwW8rLYNmG6fQSP3W2Zzv3YYFzcwYeCSopMcHhSDOP9rL9NUwdEftsRB5g4NTgNUqmmRK59TdV2MfTN+HUmVEYgcwfQkARCcxsbmSMGWhZMUo4sNKUlq/BghPEyuVqTR06y8sATUxp09KkcA8RPxeWKQILCf0E9RHYbDDaqt8IKqC3PP+3YZBLTINabfLZyambul8vFylZbdfAV9w+UjurDiARM36/OsbyYXz6tCW4/Srkd+VxTChRMJzeZJA3JUI1gp6Bi+PNguRK0gADipTlvfi5e5tsrR+IDcbQgUvJ3KL6tWpzOYTSSFfL5uj6FTrruCMyFWNsLeuU63gXrFlfJ/hXC4oV/GIrjDwKqwxglGxkiMac+YJR4lAyvIgGLb8JsoZDJP4vVUb3YIe8+gPUOFCGALO9ejCkzFVqXXF8WO5bN4AaJZKvi1xnpWwcFcclvSMfN2ga+KI3xRGnhehL+YnkdfqUwC48ZLpca3oEyvCSYEmZuTvC+LngEFOPpECJKJPcQJ9iz/IRGyqKuEdXds5Ba0WLA+e/K3uleVrXp02G6Ez65z/qP5r1l0NmKzO2TQlOUz7axHLyfn6LBA/2vYhSQiCq7dX2W//X3fdcrlXv1NwrRXy3clPEnxil8TgRQ3pHPe/PzSUjtlnT6a99EAMDkHAb8mcDb48Wj3jeJUg1W8AkxXIs2g+jlfHvg7gvuBqsKfgw/yhSObrCouQaOTZzBubEtRjUPjYL9+T8jOFCcCjQY2qw4UGGbLaMszFBBgozlXmCJ+JlBZ4O1IwEv4Iv7T0eRG9hMxKEtQbqPfjteOM4l/I26I3b7CbflyRuOn0T5yFLYAcUWpWq8J4VEo3ftvTX0V+D6eN7636JI1vWcazqigsdQa7u/gs3OYbBnv5FpRAQ6Qdk5jp4d49TTs3
 ITrotsol
 PZauvKMHmE7Doer5y1VfKo0M9TdFAHpmLNFN2QEsTjb9YRZPwOv+p9hf8J7lejU1bfKnIuBjhM71f/GSqISYftZwXQHU1r5gTaCCowuMCeX/jUnz66vY4uxudWr2rryyJNBRfNdj82QY7nnPcq/LSsMv756uDj9GXrEDfhFb5R3DcgiYCyl/EeQ0ptRjuqFUrhiIxV6yZ0zbHuwnc492W/glhY1Uhh60XbjZ9ibK3GBrvODyT+GsKRjD9+TsCEoMXJ906eDIe9Fn7zVXMZDYT2MMLDDJZmsHvIXVWqTckAZVRFWEqs5fk19+H0dcGMum6K42b2Qdbi3xHKUaE9/Pe2EZOcJLP1jSsSC9YYBt271HvMNF55Zk9YqQdJrLQsXo+v8AcNjDCxqdFpwA3MytIJQdRVCfwQJ3Ng82lSzQzEn8P+EwglIQGXpmhFBq0O6dyiIyFSt616pal3znR6Qb9BzE3T7OZkRv9IIIrvjuIpSRwnCK0yzjmCkD3BwX4zmvqkhS08ieoVo+2rnYh9JHd3e4uJ7DDU7qJTgI4z9wlYKIzvjjUZC/1DVCWv20a1DB0Tv399BDeXR/JY52GsfbAwEU69tj5esPb15uX6vTBAZgElCWrTcVLoK3pQ3Jnxl8tMe7cjNJkeq2/4u1MZpaZgvqkTIRKYQ9JDRUStYBTzJnlLDi1Ccnp3W+Qc9m1AYJejyUxnnsiCSrhEF8SE5Lbm7T90UnwBBXX/dIFoWrYkaa9T16KLvD8Epm1teUr5l0r3WdfSYcXajXAfLktB1qRYev4zyL7kbPKz/vhff3gGEU8oHFEv1NoxFSrfxmnAtn6cW8hcLsyFPEJHvT+rSNvW7mV2wlLjGulWRL7QF6mOCXrMe8aG/c1TFLCjh+ZuSRMs33ZkzR1AgN32O3DwX/eVHwTqwayfcTHk77/IdE+larvaotpTv37ii6J+PYX8/tC135lBWn/jRUCHw0QhR7ovD/ifOil
 LmsgsN1z
 zJTL3qg3WOfVQWVHmcOIavgEATQynNcaK+UfOyal/PPDc6dBRutx3rmN6Ulpl3fLzJeebNRQdr31hshYT5OMemFgzKl2rFNTi95R3TX/LsNi9zDe3/wEjaCzjLQY2kN5XpUq7YNeYrOOiBqLW4jGpWavgeRWiXlM8lh9MKWGv7EAgjzpmxdCGfH+QoMcd20Ao/BvR6FupSjw5D2+IkkhJ3ON8ZsaCQoJmIyJJfq7s9ZqjRj9F09DG9egyfCy41fc5EeXUVkNLQ19B7QA1GvGF+V4RzAUsjDA+T9Su1dkpC4AhmEMjrbj9flQHwhciC1bf3b1qbgsxOW/bO0IT6A2c74b2VzVDEi/QNuX+jd5eS7H8n4N7hz1SxpBjmEyV248ar4rMOF/7cXG7CfIRUEeOmEfL00ZWKcpp3phmU/VsmUv9UKACHaZH513P5/BS9cjgo9QRyh7UqXYkcNFpTGYcDvXrbBEoTTAUN0VnMIXqEgGXRz1ik69K9R6pXr0HVRnhzsZQeyTVg7xui/HJYxL5k7UDFtsyWRslPNknj12lRXIC+rG4pTRjcPai/sVNN5h8hz9skJEjt6IqotxLiDKxWj+MRROq3ToEa3UprmrsEdbK4ntk8MR2idhSAMGn4NAR/7sXEI9Sz3zfhH6Fbvffex933/IlLjqjYn9dmPCYV8WgAtOXZVWQCud5yh8pAyVSDt2JdH2+N4tholofgfGrugAL9e42rBlPGI2dGxjq6m4LgG6qwknN8Za5szaw9mqb0R9t9v69JkXrdEDQSxsTTIQU9NyeKMPFWDmybCn1I6jtW9ttC4yiOG1hV015hFnG1EbvQV+1kINnsTa/3k/6Uu6eDXLvcXzZ/iRlVeQvopAcKsTCcpoLyXytvMs72v1ClUAUYxj9q7qk5VJdte6x6YV/hV4in4gwQ4mvi2CIrQtJdxXkSdUzy7uROHwyvT8CE17pk223D4bSUGKXin+roKyQ2zRl
 CyMdrYIU
 g6aS3isU+/c/EiXl3paCzoEeV1KOYcNS5Bhg5HZ/A5Tu01CMGY9OFF6xT6Be47f5er8uz798UqLgvLZ+HrLgt3S+QtBx5rajod0+49O347YlaGMnuaSNfpCBRxaX/+iVzzz06+Tier14Kkh+uDYZOMoU+XpbOkn2nXqHbrAZF1yB5bgZ2iUtS4+u6BgMqCiq03WpbmuDemWmFzWM3hQ/KG3nrYAY/TLPEihzTpxfXve+GeEH0hIPIvtbjtyriKBIAP/+E9EBmTHp/9azp38IrwOK7FPWYTLYo8EKPxfSmOv/FdHpZkYocKwGwwpbq9g3wnDeTrIDUMar0+ze77ZMLQ8i/jpMN3IvQpCNw+iLk1VvS20KVpsasTKzb21BHqKu/td2C8uSMREydPRHWogxPhj957Y/L+WCh5TDrDsZ7iHM/CEHdfkFOAwhhLlwoVv7e8wnEhL4QA3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently there's a confusing mess around VMA_LOCKED_BIT and
VMA_LOCKONFAULT_BIT.

It is permitted for drivers to set any flags they like, with the VMA
already possessing lock flags.

This results in the absurd situation of a VMA possessing both
VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.

This has resulted in mlock_vma_folio() having a very silly check for this
scenario to work around it.

There is no need for this - just clear the flags before invoking the hook
and reinstate them afterwards if they are required.

Nothing relies upon this being set during the mmap operation.

mmap_prepare is unaffected by this so requires no fix.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h |  9 +--------
 mm/vma.c      | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index b81fce5fe510..b2c6c9435021 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -971,14 +971,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/*
-	 * The VM_SPECIAL check here serves two purposes.
-	 * 1) VM_IO check prevents migration from double-counting during mlock.
-	 * 2) Although mmap_region() and mlock_fixup() take care that VM_LOCKED
-	 *    is never left set on a VM_SPECIAL vma, there is an interval while
-	 *    file->f_op->mmap() is using vm_insert_page(s), when VM_LOCKED may
-	 *    still be set while VM_SPECIAL bits are added: so ignore it then.
-	 */
+	/* The VM_IO check prevents migration from double-counting during mlock. */
 	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
 		mlock_folio(folio);
 }
diff --git a/mm/vma.c b/mm/vma.c
index 1dec10946918..1db8b218fe64 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2607,6 +2607,11 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	if (!map->vm_file->f_op->mmap)
 		return 0;
 
+	/*
+	 * Driver-specified flags may make the lock flags invalid, so clear
+	 * VMA_LOCKED_MASK and reinstate it afterwards if appropriate.
+	 */
+	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 	error = mmap_file(vma->vm_file, vma);
 	map->vm_file = vma->vm_file;
 
@@ -2623,6 +2628,15 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		return error;
 	}
 
+	/* If VMA flags still valid for locked mask, reinstate. */
+	if (vma_supports_mlock(vma)) {
+		const vma_flags_t mask =
+			vma_flags_and_mask(&map->vma_flags,
+					   VMA_LOCKED_MASK);
+
+		vma_set_flags_mask(vma, mask);
+	}
+
 	map->vma_flags = vma->flags;
 
 	return 0;

-- 
2.55.0


