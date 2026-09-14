Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB58AC88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE056B0099; Mon, 14 Sep 2026 11:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8EA16B00A3; Mon, 14 Sep 2026 11:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C570B6B00A6; Mon, 14 Sep 2026 11:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5C76B0099
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:05:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E20ABC0199
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:05:29 +0000 (UTC)
X-FDA: 85212691578.30.7C26DE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2840C2000E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:05:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UD5PNoW4;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ht1E3XYrT6zNGxe7BXRz6LPnDrSfYBDlq1F1i7I+270=;
	b=0xR914K/bsqLF1JtK791IMtTygEx0pBX9kr4bgeCVvE0OOtKvSXkMx27CFk2pFeQ6Ft6/I
	Jz9zF4DrujCP+18b14JxohCpoPiLzsgWvh8s2qW1Gv2yjj3rXD6m107BzcbP7S/NjwuMBM
	Oq9Qd+aIbkKHecGxKTeRJe5TjWt0rnI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UD5PNoW4;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398328;
	b=0e9erFcw1ivODhlcu7N3pl6qknyrcaZl3mrwR4EIm6TRPnTMEanScomDeV0AKm6Rd2Ff0S
	XXBItwB1VnipDsXlZOO/AC2CJGElohMPsXP8R80Da6Z07ptHBLJ10r2dzW/ndQORj3hE23
	qHEvzswfZqiFm9Ghk2G0myARfn6uCvU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD51760258;
	Mon, 14 Sep 2026 15:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB141F00898;
	Mon, 14 Sep 2026 15:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398327;
	bh=Ht1E3XYrT6zNGxe7BXRz6LPnDrSfYBDlq1F1i7I+270=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UD5PNoW4R8TJPc+RDDL3nG5Y1YQvYyAiYnzBxh0zYH0b/+Bt5gLTsU+RvcepWwXl9
	 vGmu1XkGwSr/gCqlhbzjULKWUtKhSJS+hFruG4mLMnloiAA6CrcyK4NubUfb7quSnr
	 +pT32wgyKeo9qghsHa0mPlmJ+DdQ8vYcXEeeirDOZzVJ+ANI96vDPfw5Z5i+P3ACOy
	 G+NeTFtPHqQafdV1FNH9Ta2sVqxe12g43axrM9WI2nsu7Wx37vTmyVTj3S1gwIDfRa
	 iqt6wTjJEaikYYmfVMDWTwtWfyRMP4TamLvXWLtw6mN/f+6l8nhmh8/DFWULAokJYP
	 /2/OVRz0eRFSg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:33 +0100
Subject: [PATCH v2 13/40] ALSA: pcm: use vm_insert_page() to map PCM status
 page
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-13-7d9781ed5361@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Takashi Iwai <tiwai@suse.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2769; i=ljs@kernel.org;
 h=from:subject:message-id; bh=BufAYcKoxP4rPy82Onp5UAmN13VcupWKa3H7JCJQDTQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK+vLojmLzf1vhywWW+2TchqpeLCfL9Hf29VfFic7
 +R2i7O1o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABPhf87wV+ydcNxHCf/98y12
 rlP/3Gru9ig8qzvq2nTh51v2lIhrzmP4Z5H1ui/cUeppRvdZIXWXH7ESXP+UXt/fzuhh6JL+ZNE
 qVgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2840C2000E
X-Stat-Signature: en485esjjauj1w6txgcoe5kcnnex5mnr
X-Rspam-User: 
X-HE-Tag: 1789398328-454297
X-HE-Meta: U2FsdGVkX1+rpsarypJh4QuRdy1sHe2VmvWrWsgXckanRQp12RdNZOo4LTVErkfEhgLBfDBqYVWO9igZB1l+m/Vf0a6M97gn3cLgGcuVZWXkEoPqfn0JHBIBogn1XrGD1ASG+YMOmGlczZKwwqQvAbTwjwu5GrkmytZBTkG3TSMnZ8+r4AVvmqR64zWteZsZ8drQ3IhVpNs7vaTUJ8pSR/d4wAKi+kRiAMjrnXo+OOAl6LNksdDRumMsy9Fm89wcmu2SWOQk26sfJgk5J6GmP+bRZnmsWgjcJJYxDW8RxeCPg5Vi+LrQVvqNUWH+yPxmQQjgMR6NZ2nmKP700FOcKeFVD7phQg+/JyFj2adfCjH6SJGwpwY1oXr6EwOdSxogPaO1JGIx7A/O3Wy67b1EIvwPxmMjWNUOnuLNIDZ/XL54PVcc3mVUZc7uqDZL/kwm7XpLHcvukKngfUTjn/a/5tIsTAp5bg8q6nBZ9fhXqIPDl5BJZ+TFYFImupsQzoac03D+1uE09YxEy1SXIbZbNFCDG63qnaA9Bx9hCM4MjNytLxdZ3X+liRxfOiwYSQuZ7vuvycSyWO3JJucMN8UArTq4eLSJFbxT8V5J2NOJyyYSzEarg6DBUIpNtpcApkKLIBmz8zoCWrfHvSu3wj4ESEkbd7hj2txGPM0BHdJEUKN6D0L3sMX8SivQWxG3oaIZXAJrN3IjgKIoISBNMu3exLmMuc9yYIBhNkJyQHlt2NNzyGAQJQS3ssLd+03taYCGUD1dYy/PKhmbgR3HB4mrf8T3k86KF7Tk1OkgtKv8k26B8XUc+QF+Hr3O3m3KKV5IkCrS8Ex2IvzdsrorDHa9fwUE1Cj3+e/DJn1BRktVx8rxZ9UDNd+6/NXdPIh/W/g2qU7SpOkPH54Aa4AdlPwKKYSoLj/kAUKgqAVQSd8cuL2i4RXukJZMohiYafZI7iXQhVChHPxTGM02rrV1Hgf
 dkPtiePv
 62iUWj4xHZaisp118bfrLKTh1ksiYBS6TIBvJHwiP/N+25cuVXm/d3AoC7APCT8ZaNHMFI8kE7CXeQjjDALxla0Ta138r/qMymgQ7Gq20SSowkm/rDKx9do2DJ2ACds9QlnyLYo8KTAaBfa1BdnUMBdnkgkNrC7Ja94eMTw7pvKw9aRUjBRILH0sutO0V6NIb4b1rkb+YRgDws2xogfRdwWQuUoQqAJm49FHXw7rUfgF7PrE0ShIUuVZ930eAE/k8N2ZvuyGg99jQnvBuOArF4v5OZEgxG0gifCwF7V5c7DlR+NcoaUoLqQTyWBrhZ6a1lT+VYfV2RHMxsJErNV78GmPWEDYdHys7N7buRSkzCKbUjVhVB7tCyeLhq2UVaO5szReNr+8LgzC/cKM3JwmXZ+1Z5bfsVgr0cvQAgJv2HuvjJw5howcwX9liiWmH8n4fSbqGQ6RohRXY08TWrIqUfA4tT7gsMItoMChTX4wXFoLwpnkpMpo+QUHqUD4wxis5YBYCPaMgRlK+aP/B9TlDomLSGY/VLS3U9T8nelIDLuaHeELe4zwKdgKNjt4xm0478W9+tMaGJtG0Jkr1vMlTE5FA26W0L9a/11YBFDl6DkaML/k284M5wIrNHkoOXQQeJXwwEH2to7R9qbuX5riLCU3bVm9TOqSQzmJL41oND6H7SRJQFhGO3vCEkiWzu8W/ngyUqMIZfeIggWofZZi9v+wqR3pY7H+xWnKwAsC21K70LH2zTmL/fFPahJMlIq2S3h+PKDOmeDCYu6V8ryoEssAOXx+tsfW4BEgTctsjdEEiRFXdmAfnxf0XqZWeuvyAvA00CQNjaDIzHqVzscL+VbLmIiTKhd/x9yvS0bNCaZL9GOzdN9ztUojOiBD8vz6EPovkEiWWO+q6JAJj9dVCBJUX1wzZuX9bCAEw6Rx4mDT0xFxB2mO81evGKAsMNxzbWKWBj71t1wXO8a09+gKdJ7KmGs3X
 rFpD9WRC
 y/sGeNP2GQGDpQ8860EU1j1ILEHQTr64BHpoGQ2cVkxLewNeu93YC0A98S9+gnjSSBaZiTJGREXdV511BZomFbQn3qahcwgEH4A5E2GFEZ92LQyOu3HydBWAJUUSqylW5iFsczkj8EZmFqn5eDylGIJU5/5LZCsgHnjc4qzK1tR+4fvwzyPlNzPgYTiI6Bi1cRg2b/q9e6u2vJJgk3H5/afHsQ+0wMzt/AwGoHZfF3JJl89IvmmfeD6KiAUCJ8JXrf84XEoVn8tDQcVjeCpbE5Qfhp118AXvH/uqTqW6wNU2SnH3EcR+7HfTgcJMZTSlQoSF2rhTZnIvaUz/QKMmWLW/DHVGEEldiOoX86mmYcdfb2Pd6WEcvP5MNA6MXRF4KtqwlQx0SsmltrA7pLCe4iKGytM7qLseMix3mG7kPIiM9qcxv0avrEvAsXMovmsVMuk5kaxcakCOxFR3eu6jYXhj4NssqgWHBxOGLcw6qM3cuDjc1OcgvkqQDCzro9vGOZUuyrQKGPZEvqk4ym60nw18MhAb1QTnItDrMO5d+GXfZEaMAkFsobfO+0YIIqv55aX7uIKsZMKm7RbuzCHbasCOJSkKGzG0r5H5Rb0ASw23dvyeOhFTdMmrm8ZXj732o46yBlr0czPMBlzMJk9tnbGz1JWLP/wi0YxiRKU1jZi2K1/+hCDpzCGHNPJ5pa7SqR9DhYrtrIpnJy8OG+S6T+QZ1WNWQsN7yvRK55S/w+4KxsgKpVWcvj4xej/6cG4t1vGdggcV9bPWEJEBB4mt+VNx1FEdQAhoGJ4IhHsKf4pu0yOSfbEUiPwhGQ5Q1x6v/2pV9sgNJzNFmbLoGnswtVOdhpCq+Z7rGxGa268une6B2uSNIPf3iXhhmJYkg2P1rWKSQ0U+UQK0YpPhOCTGpfDrGpq2yaEWDMOfFMWPVXx6j6brTBk7j1Ny2cNyI96xSGnkqiDWm3H+Boou0XFZnZUuHD/fa
 G9p1Rfsl
 sphPxBWp2LyY+R5xlrL+8FSblYVpEdsvwxg+/Z8OQBVjo4n4t0pIfCekYSxQKedDaS9/hnRYJu97a+Bas5itOyRt/HvlzSEWGhl0wtouBj3XYDra4TZjdP7bWH3ER4F/EjkkRqsUcdG/j5vxp7vDiypajqr6YzIi5d/xVYZiKWjaV2L0bKf3CPKolR3qXQ8hESURLOeNFifZgs1P1bE6gbVldzPdVXUhcreZVnre82ZGQldGeXZEg1VQseBP5HWpKBjnqBp0JEcpV3K1zJu2BWM9Mw+uuZbO+lsq6DyOHrASfwD9hwDJYj/XftALpIPTT9o6C/m5yIlcSTGhb5ljV1ienX9WgvJDNYujR+43eUd0mpNP+zM8Sc+PrWPkqnfGB7GwsO9cBu8wVg8YvUu9ufpvUDTsdythJnCXLinFbo8TTUgEKGywN1nLdqVkPbrW3j7QnJqbHOzHmDfW4EkroV9CgjKbRzjjFBlK8zdIWeBpA6Kjs8Qwht813/1zRt2t5yKzrUSkzi79uvQ+KHA0ADHUNvDYFNY6WkrlbG0PtMNnTnTnj19QEczYnQFom9ahnoSkbqMwhg8WALJqs3A3bpwR87ymJmz2FTgITurgb97TpnvYCtyRCw2HTzxltIjWSiYLx9oDxnvgK31pkfx+yDkxkNlQrINvVhT0ZbI9nJD+qGXg4L2ZHgFUfH7cuGXjGy1ovktjZJysN6E9/3UviGqdrmOD85xrbrSepVwXUaFk9a1lTJxYBSg3weetuLTjyYDQUFYAcRTalnInoPqyVF5AcMl1lhmbMdO3Q+Yg26PM94WBuLiWSLA1AONIdBZjImKNSBqL7eRpf3bh9tqm08EwtzlVK9ZklgE3OGdBRU+En+QPcGWdyaDimDIZeykuGxdtdgJos/vAZqq4GFclLrtzGnzLYvB0J/0uMU0JAmXO0panhHCU1Y6Ehyxzf4ciBGSUEgf1p+f3Uo+wvX7opiF3NAzzT
 zoSs81j+
 gkmVH3GebE05thot+Lp336RMLcRewOrmHc1adKpSgjMKW+M/MD6mdNpCiTmKc6515c+XUeSyUja/GBDSVd4tmxW/UiAhmX2K2DDC1ISOZNZhm4GGIWgsE0VCtmC6AN1Ob6s6oK+xWzD9Lq4LiS+AlsamZQaXuHdbx+WFLM9ADHCXOr4/pjF2bJItpdDwXR9Hh01TzBfMCfYUTFGDasYZbD0ECMSwrc7prszx2wnE+rQn+i0RRSOV9FjdrIdsGYYsc9LnUpvbXMC45WeHPoa0qMCMW31gwu4SuouT6aLJLpIyPq4PGQIVxilVONq2akQeG80vQiCNOE3YY1tC6tNca5D7UIImKrU/rknj7+q3h2lF/5zgCssYh7x+rKMhCqhGJTjvWqt4r+/7tkhmxo2/iBRoqHPMmWNwFokV1cUSaF4WA1NO77T0h4PfBxG8gX8jWNQs9WQJn27MVKjMZF9knL5wOsIqZyvx0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to keep a fault handler around for this, instead map on
mmap.

While we're here, rename area to vma to be consistent.

This correctly makes the mapping a mixed map mapping.

This works towards establishing the invariant that only PFN mapped or mixed
map mappings may clear the VM_MAYWRITE flag. The status page mapping clears
VM_MAYWRITE, so it must be kernel-owned; the control page mapping remains
writable and is left fault-based.

The assumption is made that the struct pcm_mmap_status structure is at most
a page in size, which is asserted as a build bug.

This is safe to assume, as the size of the structure is 56 bytes at most.

Acked-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 sound/core/pcm_native.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 62324282fcae..c98fb3df14f3 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3760,39 +3760,27 @@ static __poll_t snd_pcm_poll(struct file *file, poll_table *wait)
 /*
  * mmap status record
  */
-static vm_fault_t snd_pcm_mmap_status_fault(struct vm_fault *vmf)
+static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
+			       struct vm_area_struct *vma)
 {
-	struct snd_pcm_substream *substream = vmf->vma->vm_private_data;
+	const unsigned long size = vma->vm_end - vma->vm_start;
 	struct snd_pcm_runtime *runtime;
-	
-	if (substream == NULL)
-		return VM_FAULT_SIGBUS;
-	runtime = substream->runtime;
-	vmf->page = virt_to_page(runtime->status);
-	get_page(vmf->page);
-	return 0;
-}
+	struct page *page;
 
-static const struct vm_operations_struct snd_pcm_vm_ops_status =
-{
-	.fault =	snd_pcm_mmap_status_fault,
-};
+	BUILD_BUG_ON(sizeof(struct snd_pcm_mmap_status) > PAGE_SIZE);
 
-static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
-			       struct vm_area_struct *area)
-{
-	long size;
-	if (!(area->vm_flags & VM_READ))
+	if (!(vma->vm_flags & VM_READ))
 		return -EINVAL;
-	size = area->vm_end - area->vm_start;
-	if (size != PAGE_ALIGN(sizeof(struct snd_pcm_mmap_status)))
+	if (size != PAGE_SIZE)
 		return -EINVAL;
-	area->vm_ops = &snd_pcm_vm_ops_status;
-	area->vm_private_data = substream;
-	vm_flags_mod(area, VM_DONTEXPAND | VM_DONTDUMP,
+
+	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP,
 		     VM_WRITE | VM_MAYWRITE);
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
-	return 0;
+	runtime = substream->runtime;
+	page = virt_to_page(runtime->status);
+	return vm_insert_page(vma, vma->vm_start, page);
 }
 
 /*

-- 
2.55.0


