Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69ADBC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735F86B0093; Tue,  8 Sep 2026 16:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70C8C6B00B3; Tue,  8 Sep 2026 16:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FC236B00B4; Tue,  8 Sep 2026 16:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33F4F6B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:20:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC05B16077A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:20:07 +0000 (UTC)
X-FDA: 85191711654.20.14D5747
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3ED1B4000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:20:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ib6OrkQa;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898806;
	b=HQVoaQspCSh07YcoxYbFTdO4oxPmJYDDLCXKsdTkzlDsf6TnmRfxZWWL97VIdDKRE+HKuL
	2buRl/3PXh29y7QSu17MXKlQ0D2Cn2f3L/ifjovjagQJOM2J92Mo89OZ3gRsjSihQighDM
	HwP5zeBope+LFykszw+yQ59PHvaTDAY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ib6OrkQa;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwIdZujBqtKUK3euRg5palCjbTo4zKXqAqucXZZYP/8=;
	b=xivFafM3q6sOh73/I6194DmIyW2bziOB+w4+6a/z0ESqdcZxfHZ198Lsw7mf0A3CnsS2sa
	blQiwsMKPzBGkyuVcSj9dhojD20IR5rsBqc3mqXYGvPZZhF0kgRnBylFQs6uzbqZCF4Yj2
	uDLBlTE421TPzNtTQkuj7AVD7NKgDd4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C26AD601DE;
	Tue,  8 Sep 2026 20:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CF81F00A3D;
	Tue,  8 Sep 2026 20:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898805;
	bh=XwIdZujBqtKUK3euRg5palCjbTo4zKXqAqucXZZYP/8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ib6OrkQaVOGNdEgkkwJSPE1x+xuwct1sSpK4L9Lpw0VYWdv5gdKeBCi3IhHDfyT7C
	 q79PcScmoJFWwrISRw4qy4r32PwNLqpO1wJ10HZyrHY8L53E8acw/6mAN/nocnE+b3
	 GefZzaAwiQYNrn2WOfgpmMkvW5CjyhDgyEeSEo/gX9HTDcyfa35SeaVblxbwlMpwhF
	 A4Nr70HQLI9bHRBSKvB/bVpUJDntQ1mUJdhqJhWxoPHHGSHcwacRIMoT0ABUUYZtw3
	 R4SX2ee+lc5YlPzBVw9I29ExT5XGfdjbxacQfaXN8tESywXHEZ10tMcW4bLdxoMbR7
	 PpUkIZPHsOLNg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:41 +0100
Subject: [PATCH 37/39] fuse: dax: do not set VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-37-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1455; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RCEYQjEW6MHyrFoJLHJtSFluFNRdmgFFgjkTdNXkXXM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG47eHamOnP2bFu95NK1gnEyAc8/3xbQ/H6y8+Txd
 X2bvy482lHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJtPAw/DO9sOT1drErN7dr
 tEQt6Kybumvtk5Z64Sm2E4/2eG3R1hFi+Ge0gkMzbs6ZqTuLhI12ClQ9u3GgqeXk+559ckI73MO
 vn2YBAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3ED1B4000A
X-Rspam-User: 
X-Stat-Signature: 6zfr5otgoq1387xfopnqnijxcttpfd8w
X-HE-Tag: 1788898806-516909
X-HE-Meta: U2FsdGVkX18Cs+FeWlay7EaAfBvu6S1uui7AAxGgni+n6jRmPI5as0yVo0TD5mwhQMC1DF9CWBHv8IHEg/GXgVnrASxzHVusiFg10VJ4HzuCq9kfNJj0snuUYTLngpUTVUYg3WwAVzsW+Qr6HHsrFqUV+Pf18lnC2C/zGaW1W/cvIA1sjD/RscDokQdQwj4OLMJWGlJpKmuC2J4Q8KX2h9iwdLFTfqKDEUvKFsk4Sbl4KRFoqWwsxtwDqgnVfj+EKR3OjuT2zDOTi6JOCbUDXt6E2vWkVKmq8gtSgZLycc8WbWmzEHtOoK5t99QyKVP5d95ffQbgsn4lynSxliK5D/SkcXueJOflFuatZMMWTFIh7wnqy0KC/O7YezhiZUQXQNcxE8xOWE/Ipz+sArymffXhilaO8XtZ14yzcMg7maJin/Lg/ea/TdguYIRkGssApKVFb3ra5tVC2Xwzbd7bU5nppW71MOmk4gUkTcxs1uhMF+fUFBV5iN0rX8xDUpFlVEMpcqYBDvv1EKAhNDxGxaKYqOl1gYf678ANh0QHCJO/sUYO9dCje89xEnSJ+PXZSGjniNdECpCPccrcTjRYADjogm6JaNBhzH34r46V4BdoGEBY7xGJFKxcA/nSly4GSvPouv9tzW68AkndW0qxa+HxTLYMFXJ6HHNjtX5AfpoldEOlkjpE7hw2Jpa5X0mLMspq0wvqYprLZJj+fpBSmjdoomSOIHgqNG9OVx9f0JR0rO/Nko1rtZVJ9ddo3Muf+iHVC1Yw6irtFZI96EnOcI39GoeuTduAgCgu1G8zLBjZ2z+uYwUlIHJb25vjy3PuPHjqV3PG091/evaXs7zp8LDbspYWbHuMFswr4DumbcoDBwlezLKlLwiLxvq4rEyuGLEnjjz+6BNcI4CglRJNLvECUelEY6pCZGLQnd0MzSoqKNOs2joLxvgH9Goc3XXqjblIKT52m+lrPThHQw7
 9yxd0ReH
 IsNebSyi6+ZDI92zp8wVt+dZOY80Wl+Mt9sAh6vlJQVeN8/iWrkBBfN6wSh6g1gICSDI6LMvmiT1LCcAgG/YzJxdYJ9sInIu5AZAXSTpSrcLIRijqs3bkTDugu5W+n0iu71+fFiQTII/Z0gEhc9omItj7DM4amPT3APfU7ttUELVxWt5tnwI22skanQVDKUEaITW8+HFnNsdtrXAjOeDXr83jnc723kMAYyZ6I8rZ0HqttnFM4lrjHGMR6G0OckRK586glpW7BczKIf5swX1bprknRT9ryjd12C7jL63al1LHEZIH+0V4tNmmnaqWegfM7R9V2EoR25SvIQ/CaBgBV4Gwgg8IYl0cJKkxElynuwVP+tluopHKiWpii6771zYNDjjKzyt3AnI3VwR+0hPImr0krbYfsroHzBc2eTvbOxX+j+aSYiKfMe4S0/eq2cEFpY7HkMBeM44gKsJaXLY8oDK2ejfS3jVvTtImfrHtStR7oRIkAvajaq9ydK7uWU51ChLDkYR0iHI7QnsyhJmPFZ+dAUeeaTTaA9ka4bFDKeRlAinF3jT00FcwQ+hEVySv4qVcO7aRLoEzGpy8/QHq2kg9UdnUKAqhgthSTMD40X/3XiPFWmsjatFjhI59at2Xc3rQYEFFDnWTPtWluwmnb17pyl4///YAn43ivgarpRzsdS7cFAPzRrGs3XEMa1DCwcxJ6DjqiT1AUwX72ksPS4V9H25c8s/QXWTcC5Iwy15UioHrdXrccxIC/OXWDH7V0sMta04sRXvE/CB9lbR7cfXnuNVNlw2L10sMDzD2hmjZ1ntmMyUiCvhKzalqLSG1BrScDblxPswDTCHZsQ3SX4kzD79WynAIozLE2rJ2e/6GlMo4n/E/k5cQFBaa3zlfW0Wh3cFBDVhsOOmxrV2qTFpkBK/2Ca7GhNJeqR+8EH23SP3IrREe0D2yGxFY/P/MgKno8jKdmlMjrketTBePgZ5cSWEP
 vjLvjyF2
 fZKBYfHCs702sKaGlzHM0lKfdrLCkUw8MfjwtB0ihdVxt7LoeOYaWfriVlf+DX8KXQQqtLIv4o0t/+R2wJlOqQjvnnL7KArQxDndg34APHFC/it3pCRK1wqYe1LjMJSXsh54DecnvNJxybzB7YOYXnthKcwjecmB3ZF9S/qDrYMl1ioyvjawD6ay5KKKNG6RPHt0cGm3VS8UaXdjE1tHqr5/rpxbOU+yYJ/2odjjJZbL9MoIouA3AGTQ/mfot5yvKDOGanfaxau+G2K8Y5mR1h7q+DOQbfNeo85o/z/qZuYvvnI73AhxD4XLiSNqJOJdhmHjJpvMg6dJ7oXRx78KGOJchHrC+esIuu6bVk0waD3Bl16CcHtKBpSST1AeMvYyt10C+NIGOigsSBRyCGaCgSxyJKYomymrCAlQyCDfCYWMjbJ/01sLajhJj423Hw58Vezc70WpcfuKf2OCrtKnF0ahvyHgSRrAf4xQ8WpDdqRTTa7R+bszKvo9FsciCJNVLh+PyqxhgDj9LA9iaESCHwLX4truzKLa1o6gIEsLe41GCkVjXEbzAzAUqJ9Y9uJ3SkjGxn8hP12QLI9KPW2PZYYRHW9sftWnSU/YTCFFQGYO3YH01oLkXnjWHRKtDRIxAK3MiLdNQh7P4mSHj0dqRpUxkJ0LYm4rIjGwvy/yDlyN065L9DoxdsJgz1oNOJNH57Rh++X5xLNyfVbcOMOJV1KzOl8qEPbaqrCFlXhd/0iMkfDgviuc9LbLPn6BT0lRhJUNuvP50Dk1KX+MSDQpRdmrfiLQL7tQQB7hHJ0TNVc+jPgrobBUUoTXYwyseDO5BvdvWcXwSkSB9JVrgG4aNVA7xcI0bqwHZ+lnjLG9tZKxbs9H1Ekr+Yqzsxsy67onG41jnTD6NxTKYD6ZxcwFpQnyZ7Bh6tQwFKyKI/IDUlirlLguwVpV6NaDqYTYyw3xS2Bx5u6X8/5n8ed6K2BK5mJXfNMiv
 D7dbuAPw
 GDJjoSK63GupjDIYFHdvXO9dANhVTBf7AShtbvM6ZZuzV/mqMJRuHNrx8ZJcGoVv4pL46u1pCYV2WRGfZ5arWBSTPFHz0VwPqiaJpYK4961cJi45VIfV4osOEpjnVG6CI4kvmwVtatjYpS5/j7//KEs77hpXq5kxBED4Ux3r14OtSzQ3t/XBrWoi85VhfIgHdcB04GuSGyxUN9Ko5Inh7TFtqFJYbIN8Zl+okxx22mE3/SKvlnGn5uLXR55eLL7skxnAPrAte+Ub7mqJw7ElJP0iADDsJltGDEBPgTyYA0qW2fsZmx2kLsViM1G65iRXoHYjdUvqyF+Ek3FQnxjKJhhwz5tyMy+Ig4Yq3FjorU9VbJ/PydkeP90m9qDds0es4d3Pr/jx6cCgwi2HX9dtvuWU+M4e0MHk79B9wDAs6TTMJN0lmpeV7vIIaidApi+alt2bdD363t99Hfij2s0rntvrs/MIP50MDrSvpo2C9N1AXKeq6KXL+6YPNQQNUN0SHPeBOFE0pgMqP8NotDdY4BWnT1oJtTzmxqtlLt+NgL8OrCBJC8Fl3tnqcvU4TjFBLSDeYPOcFBkG1uyuUUEqpFmfm5inxocnUl6wJQCdYRk1jEFDkQ7wdTE8LnRdxGqt8zAKiRb/+2Luk5om6gJ4l2F0K0npLhiQJGffEib6Yzj90pOQvYpRSVjMQoEXkPgEb9YwVlxnQrmowXw0i34eK3GGXO2U2tK0GTw3SCiOSPhT3PJIZxIGJneCRh5N1ZGA8adXdpdnAV9a7Kj0/2Dls6p9VuFKVv3S3tXjlQd4UbOCvIvFSEtMGgCjpHdKZVVHDsEc9yuOP77bUFV5ssRHPyLUJNqYU4dYuBC1vu+7cb9ZRCaSNsi4EOqJPnzOK/9c9HtDf81o7igTpkyki0hxh30BV/kW90d/IwG+7EdbeTZVLV70rxXciucYG39I5a8mswlEbaeaVPARiBNR5oQbF/xHg8FqH
 5tB3Ksra
 4FYzPMy+dyEE70A9ziIKnBTyk4V+5xaLPhSz41KPTvQXUoC3Nx3IlD/oGb+TJe/YcoWlpeWzhAztpTLEnqwvtQFmBwvn7Wm10YLKdFv8cGWsuYSBkWCWBXBfgVj/G0KrL8So9MahvIH1CFk+zZFKbxUpY3te9w3w2AnrAs76fve82525M8V6lYzoT9SHmSafGliFGtga6MjnUN+qOrvwDCRXU5tqCB9l3glb/vTC4vH8V4vq+PLcV1PGvyZ0cXqOVSsK+ITdrH94T9Z8Tczga5hbUcaXJzDXapjymQJEXUnESVTkUXY3+5f5Acrk6Mx8uGzpuZT6FBvHleWUFRWxBZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit e1fb4a086495 ("dax: remove VM_MIXEDMAP for fsdax and device dax")
prevented fsdax and device-dax from setting VM_MIXEDMAP, as DAX no longer
relies on it to direct core mm paths.

The fuse DAX implementation, added later, copied the old pattern and still
sets it.

Fuse DAX maps pages the same way fsdax does, via dax_iomap_fault() and
ultimately vmf_insert_page_mkwrite() and vmf_insert_folio_pmd(), which
insert ordinary refcounted pages and so do not require VM_MIXEDMAP.

Setting it only serves to mark the mapping as kernel-owned, making fuse DAX
the sole DAX implementation whose mappings are unmergeable, cannot be
mlock()'d, eagerly copy page tables on fork and reject MADV_DOFORK and
MADV_DODUMP.

It also requires vma_is_special_huge() in mm/huge_memory.c to carve DAX out
of its kernel-owned check explicitly.

There is no reason for fuse DAX to keep on using this flag so drop it.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/fuse/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 85cdf0199bc0..a5994f1c637d 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -826,7 +826,7 @@ int fuse_dax_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	file_accessed(file);
 	vma->vm_ops = &fuse_dax_vm_ops;
-	vm_flags_set(vma, VM_MIXEDMAP | VM_HUGEPAGE);
+	vma_set_flags(vma, VMA_HUGEPAGE_BIT);
 	return 0;
 }
 

-- 
2.55.0


