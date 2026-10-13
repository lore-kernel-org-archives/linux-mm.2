Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D800CC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A194A6B00AC; Tue, 13 Oct 2026 11:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1226B00AD; Tue, 13 Oct 2026 11:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DFF36B00AE; Tue, 13 Oct 2026 11:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 672856B00AC
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:09:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 698DAC0C59
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:09:28 +0000 (UTC)
X-FDA: 85317936816.16.6F15DD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id A117DA0007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:09:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ktqeL2zX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lV50szqwhlOdZvvntvc8L71JtBIxPo0bLUpU4NKXmU=;
	b=HQzCBtBmAnY6J3DSR8cCIIigt5ATBpxe61/woxV5/Ibn6lSHdzqM3yIQyhCnjpN7oyxHGP
	wvzbMlgH6t+AJRj//TwOfyhOaNvVleE5EEBt3XoUCi9WnFqHQt+kCBgsBUdVEoEdWc3n57
	igE+nKaWgzTjDTstkqYvIvyf0rW0FCQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ktqeL2zX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904166;
	b=wpZ/T8WXe/mA3FUc/7fi0S2Ygu+IjUVl1KxBXABeD6VcxL59Ftd6dPfPjxcrz26QxcRWTK
	nG1ORBby28x2YwxvTLgn2pZfnzyBqHXBUKst8FnjXj+VTKHg9g3FRZ6uxMZLGXUVzv/BqH
	01a6b7sWBjBnAF5blO6xwLZjRT0KBFc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 37F0260A56;
	Tue, 13 Oct 2026 15:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A69E1F000FF;
	Tue, 13 Oct 2026 15:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904165;
	bh=+lV50szqwhlOdZvvntvc8L71JtBIxPo0bLUpU4NKXmU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ktqeL2zXS70o90j0mLV87aoV59vXbCAA5RZbizjqijewnPcZxxXxcgaVuM/cJHeZD
	 +77tfbvmmOOOQzog02DPrCynPFoOSlQGvX65HJWvxXvL3oMYLxXPhSoVSa+3ff8mi8
	 87JKEIDRjPdM3T36BB+eyice44zILgmAzlQTVOqSI3Bo1nj6l5lq4S4VJC93zGxPJs
	 eoBsrTqZ1+SgldZldpqy8abg87G9p6tBnin/ovgydcju28x8wXmBn0l0e8wHty3bI7
	 KxAthEl6r5seQO0FEQzhLLhYkzrc37hYn3auAEejPtkuMirgsi05/hXcCmHwI0gDDI
	 DwHa0lmyqP51w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:46 +0100
Subject: [PATCH v6 06/39] mm/vma: tidy up map kernel pages enum values
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-6-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4144; i=ljs@kernel.org;
 h=from:subject:message-id; bh=nvhkE4iVPWt6ZMbpDqr0VjZaPTTvkSGU9Bdm3A6LGuc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeRz/czLo4Yv3x6sv1ycktzhI6BvPSbA3Vt26R7t6U
 9h3++r3HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjI3B0M/4s/fmjaVPJkAXMV
 SytPWMj7OHntZu7UVjF+U9MT1TKtsgz/4wuqT0tnfZ6X1lgsOuH1seNX+dQSXLKMpls+vxFZtci
 QBQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: A117DA0007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: if9yxajxksuocym3u14ebwm6cac9cx6m
X-HE-Tag: 1791904166-458059
X-HE-Meta: U2FsdGVkX196aPjOqN765ppINDaCc9D6d4LM04rKauUgGQDib3cSqSCNYGRF5JxcgJVdlEgado4LZlObAg9ul3UHulC7KpEAqQinmixYBehj//tNzvrweyhX++ZPciZISwlhlVcJOl+K2Xlv4pBS4MAm9Ib/oT76x3T+szDnLC3+yc0wqT6DP1p5jls/Xf48LDnPYO+wN2TMZk1Ld/lwy4/MneCwywhpXCmvi3FEmjOq0YUuTdR9REJYjOtXWP+lFRH5IMqIXAQPao/psOFwS0qBTfSyNysZPoynXHyz9zC7asRwkvnO6kWNe4Vv+ZpYVFRQ5lCKzI/3itnDmg/Bhm9q4+9kNYVzRzt4CT+s29Q+/bjc6SIP6pxTTlexjWjyE819/6EnOSdyQHDtnzNktzdMqYUtxd0CFaVh4Zq56TueTcgweJhuwcOzSRVEAeI7qkI5V9OtPPCR9AnCtFA8PkxHIJVYSx19ZtS0YA6JGZAg5PjKfvvdUjRG/zO/M9cG4cAAz5L8G1jiKFna4CMPPOpvAeNqCA99ZMVHlVKXoCW/MibcOECjveSUmGd8LZa5BBex6n1wD18W9znhCTlqq+gZJijbt12sIrGsuSSaHX892R1BAOM6uqZr3EgldrODy4K+QQrt0qGd2EJIBqF7JsHk0pZ1uTQSSbJBdDUjT8gCQsNzxITkcQvnBRNbCqsSTZ8obPvpQ65I8qIzEJvFglJnKg2OYmYnz015vosA0caRA16hd7sHx9odj+0cK90ldd9ctk1Qyk5iEmf0GmWJAt6lWSg7j11imQKcvXBsNkjCIZ2MYdSYGDR9eusa3dI8nndX8i2IKBTx4mgXRNoeSKydRbT/uvIRQ19wxXq8RdHqzLtK/s2yPLpLhoPMf+/eKBhaA1VJCPTJHh0M+kLDBKvef9CJTyI+eubTzXkT8tlrQK5yfQpMHsEKNHt0xq5Omuf8EnmwUMA2eoRMa9R
 bJ2X9jRq
 FOA+yIbZJ/z0tdhYVFSi+/s3bFLXtYF/9D4EXjF6vPR+XNPflmCyv8PuZUfCHme3Lzi7WHXcK15EcSqMUkyQFYySMoSQ5Z2aTMAhmg0dY6k37EeOnMWp7fQtwB7WQJW5jPyfg58NLhiTKH35UmTEPjVCLDzI2qE4lCcNTqz1rSses1GXDkPkVRUzarsybvCY5deBJuVt7W+YFUy2brKr/uXegl0K1p+/e3KCLv+Np2KxDZQ6fhkhLfCbDLbos/DmE6gGbAUyY867qnQJFyeZT2llimuk0hTzL96arRUbezBHhBivHqaQDKRB4QYmaYw/QUWUi8yO8kSHa+gzgnDgwlld3Tu56qDe77vSaXXeyUXCmxYqt89e5hpe32jJ/g3jL9M51Mity/Yn7zPDlotFxrQMSr8xWSKdn/vAXNHJmwz738hDw+yoLQqzJvYIx7PoW+s318uffTP/zUYQA23ovyWEJocmkk3xY7DTxKiAxoWiTjqH3wV7xBf1I1zyC0cNbyGyM/QFjzArINEzvY6/6v20NkAXMw7rVEAJVjAi4Ttgn4YQFbW370kjnGvTiHnen4ZkhamF7NFhyFQQH/+KrcWQTZmgFmgm0uXNZ+ZNvQkgMZiQbI13h+Vy/SFgB2cBMJq8D8Nnm9W1vSNt3EAyHICrHf6SdJc0p9inL0q3lJh6OMltWfg+eoe/NH+jdk9zMW/DQlT1OhjkKKuXo07MkeZ0tjyOQaoXSFIuQ4N1Hhjf6/RTggZCIR66KCLZeuSd5oGIH6rm4LwqioRx4xos3oPhSqvbNho+W3aJ9ouh0hD/VLmoWICH5v4uH6IFHF7uJf3yFz/8Mb5UKrk/ieSDvBEbQOvlfdqMF8ng1w+cI5gmHn3t5bg1HIvpLZNsIgNkJygCySztablR0YuMpXfjOLeETVg8BD5ICN9q+p/UiTG4uM44U++mMhUXq9eRXn0LSgZuUjhuLp5efenJ2lzRADs9EVcSV
 8oGADUOs
 4vnHmZ1StnMdLC0NepRImAdlkb+Mp1MKDBQbkwymzv5KLvfBkmZuVqh/Kd8NDVSyMtyFaS14LvXKvVazOUXgB1OUW3i4Irru+hzZCfcJk7FlsPRHrU5tG0N8msy+F7iKuY/8TN6hmAfT/pX4+flH2qkR9J8Z70XcmXh5fQHy4KXJbWECUxbQMb3afBMF1YYoGgdyroDVic06YjTMNGi/nwjZs8vN8cgYVr21d9JWSy1Y8hndkaleWFKkXdHu8i7uGH3gxuYA+tjK9tspM+eB6lg5Afx00JvxxVcfG0IZzx7COF+1Bl1AzckznLhUEu7A+khhZ0KjGl2PLJ5vXZ93dUfypEx1NaANPJNsTTWcGCLYAipbt8siwHEJN+h1IdFOwZPj3Tp1OxlvlzbSpfZKgmykgpdoEeKnzJdC+CClQtd3J9hMKeUzJkfhTQURihw6JtA8GPFSzf7/k094H+d7k0Y57xcq6O2cu0klC+WPeGqDFZ4UJYULzHk0JGLEnpL6uOUgpuOORcV6B8Gxz07G+DvWPGy8/MYbEHDIM+Ht4y9avSeTFbGSpaaIrXVgIHWOdQNRSN5lZARs229La2Gyv9W9s+GdY1a7LCNkNOQMI18t6lGkxcs7pM3LrVwxrij6B8P/EVfCR/+IDwUswbC00awu4MBdAuy4EFSO7Xm4DyZYhaXxDO6DslRL8CM2FEjPm7jd1GsUc0p5w5XRGdgAOTVAqXBDYsLwy3/bYrRtdhMtsoX9WbR7iTV9ZMcJpMhmClBDyWFed0MeBB72jaIGm6QPY5filWvlupkeDsmtaO6V4Pso2ILOx4zHIMV7pcvQADz1iBerB+TzKBftYTkbyc2G1I1hZVkqFLEqwujlYOJ7z5YabdUbL9Vsu8WdsXfIQKwcZZnvdsIAIxfdJDXwxHeKopjp4pMtqGST9QzlwM3RYUHEO2ZJLIkgzrLWR5IAcQACVkekUhHO9R2NkBTChKDoWPqzq
 eEI44kue
 3iphoN5ZPfd1uvTOcEOSGOonX/4zYmXmCfMyXLH8iQdDm3761OMsLclwReLDnN8Wgb6sXKJ1XTARgFsxwLaKemcpat/ZC6uMaStLdK9Xcb1z4CR3nPT3Ezi8hTGeH/iusYh2d3D/Z4jfY2lFeYCqizSg9J36cGl8AfWhAFp0fOHRk95EFOYlkw27KxpIfuaClvwyKxMceibdiWyBL0469Syx9qxTRmT6k3S5OiLMikjMk5YHgmPfn1q/9zaL6prVFI6q60SYHn/Usn4G/3mkPTJXNL+L4XPOGxlMwRUJC9gFbiG5qXZ+JhRITcfUcDaNuxnqPiQnDb1d+FZXGpGIKuqsJ/JCs/WKxwW2d3wiLpnc08SD5mizBscnJiPySbgVEFyF6elscRnoiyP87UWduJa7bhXo7CSzWbhD0MA+wUg4D0lGzKSijXJvFgCyi+xlPEZ2NCl27E8xkLlaCu/9m9XyRItDYkqq4j82Y9CR2YnWas7Q+FIXmeoBKqbFFpBn00VptsKnUuevJ5K+AW8kJnZelJ0HFY+NBnXZ24paDUPAZwPTNBsm07V+LSOxLDuabiSxKVk27i8CWp+oqaHlNj43xFHtzypBrGuw1fQ6RpSNXHYhl5BEUtkCtQ8JbHzhvF6+joQ/EFHnIfSbrr/6gigh+/L50ldaiMUBsPRhvwLo9DYCEuy4bQT1yrT1gRooldyoGLswZrz10lj9Rg107cJtzKnfrDmbx68KKzTt2HpbhWAZR3i07SIA56ECe8M6TSuqAA5ZVohwlkaMhXz1kCiCEoSENZg92nhDyDWtlNF5atABwjvvSkE8dASsoGDSmdV+N0ohRW5QM6ftnnyGRFKF1Bq9a3iTw7jxUM5TJKUjjuNJnTehJFYvqOdmzpkFSInhihHBZy6F+BcN5UrfaQPdNUOC9U7x0gsJbceGvx1dPHgf74lgNU78P2PWAuM2N0D5ECR5GkPFbCwbl500C2mwb1O4a
 6QfRiU0F
 dgakbX24DGNYivjKRZaRn/6ofVHDKSJ0UbsYC8JoxPE9GjG5s0Rm+epU8xHnGgsner0UD/L/wgwSy0X2K69rtok6oL0V5xwfdzp5JwO9stmEH2O+ivvtUYsYU54OnGIAlXaOtejZTeHCWTxXVAFgqr0+S9BeFs20QOQ4f0lpdIsORnvM+M/ncPkVxRmYcZnzAXAWUdJZHf8eXJe4hBm6lxQwhqBUJFz4aDaEE3lyAyLHwep7H+F06AftX8EtjWKphmankoeSa3Mf4MaJ+hAL9wbHIQAL45Zeo5JfMScyKTpgGvkLO5EZ3f1kpTeHlNwh//yx9oofV9t/7443jaYPhP0QUu368RAuqB+dhiCaDOBvlqVH5Gw0hIxjZ1tWFAJq2ynKjpEoAA0MDVH5svHLTLvBiJGi4tFwl+HkYNq2RlqaFDPspAd7hAE9JYI57hJw0QbGtHHp7iqYfTlAzha7OL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
MMAP.

Also while we're here delete useless comments for mmap actions whose names
clearly indicate what they are for.

Also update the userland VMA tests to reflect this change.

No functional change intended.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 2 +-
 include/linux/mm_types.h        | 8 ++++----
 mm/util.c                       | 8 ++++----
 tools/testing/vma/include/dup.h | 8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0c17f0932b76..a1f2d375cf7d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4623,7 +4623,7 @@ static inline void mmap_action_map_kernel_pages(struct vm_area_desc *desc,
 {
 	struct mmap_action *action = &desc->action;
 
-	action->type = MMAP_MAP_KERNEL_PAGES;
+	action->type = MMAP_KERNEL_PAGES;
 	action->map_kernel.start = start;
 	action->map_kernel.pages = pages;
 	action->map_kernel.nr_pages = nr_pages;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5413bd10fff2..9ca2ea3664bc 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -815,11 +815,11 @@ struct pfnmap_track_ctx {
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*
diff --git a/mm/util.c b/mm/util.c
index d809e08c7b4d..1660910e2a22 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1467,7 +1467,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return io_remap_pfn_range_prepare(desc);
 	case MMAP_SIMPLE_IO_REMAP:
 		return simple_ioremap_prepare(desc);
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		return map_kernel_pages_prepare(desc);
 	}
 
@@ -1498,7 +1498,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 		err = remap_pfn_range_complete(vma, action);
 		break;
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
 	case MMAP_IO_REMAP_PFN:
@@ -1521,7 +1521,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1542,7 +1542,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 077df510a311..023ad6092e9c 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -454,11 +454,11 @@ static __always_inline bool vma_flags_empty(const vma_flags_t *flags)
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from an array. */
+	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*

-- 
2.55.0


