Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67DC1CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 13:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376C46B0088; Fri,  2 Oct 2026 09:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303E86B008A; Fri,  2 Oct 2026 09:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1CE6B008C; Fri,  2 Oct 2026 09:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E592B6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:12:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E087C0755
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 13:12:03 +0000 (UTC)
X-FDA: 85277724126.19.E997C27
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BE44D180005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 13:12:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EHWU0mbT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790946721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbhUP9iXRT9busjJARvsVsEKsH2Ps/ZqLFS4bca4bFI=;
	b=tXtUenJhy6a8nVXonZ8givJ0fap+ADxBTE981nz8+OEBdlEd3zbS2tMf1n9SCqtKOhQ6P4
	yn7wn1Urr3F5wIZ0LdUT0gfBpFUk53nxwBpalsWHA39/mECdAbjjAHILriuSoVN0i0jevA
	wZDpLYPbiu9qgYNmjqTrKG9kIpZV3xU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EHWU0mbT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790946721;
	b=TP1M4p4ULPOw8pATvnC1TyrpEqJpma4l7rXkcc56Lf133gYpsIbhi40bB0OjM1tJShN4HI
	ccj15K7SX8gOByZs3w1BvCqgRZ+cDX5jtAEmG+iLePpXMQdHC6h34r5a3vhg6xhN4bUisX
	WdIUbKQUwZ3lCPml563umUpaBu7j+9k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C074C60A8D;
	Fri,  2 Oct 2026 13:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC6B1F000FF;
	Fri,  2 Oct 2026 13:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790946720;
	bh=QbhUP9iXRT9busjJARvsVsEKsH2Ps/ZqLFS4bca4bFI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EHWU0mbTANCXNOi3Zz8vfaluwXiHb6NrEeQE3579lOgrAlHyG4bhLJxtrP5SUxJ53
	 qyuyt7WwDms+J9SU6tj1doNb8ixs5S/dfzu1LKAyzLmCA11j1Lj0zCtK60fbB19ybx
	 3qiK3mWy3UStlhPrmaJU1AZq+hxZAKISulldff17r1WWYubrmXtDF0LmP4+X+Wm6bd
	 BOzsfTZ78ABQCyKcm+yss2YPRtG6Dauzuh8gKGZxzEuKnmayEwg8S4NJjxmkbEjVzs
	 TlQyReq4OVNz5qAdPorvbksNtN11kzuoPIYJM5l9/ocKXRgGPmsMbmcutbMweewTer
	 BEcqQ9TLZwBbw==
Message-ID: <3387642b-c39f-4f19-ba0c-267bbd2fe91d@kernel.org>
Date: Fri, 2 Oct 2026 15:11:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 31/40] mm/vma: introduce vma[_flags]_is_persistent()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
 Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 fuse-devel@lists.linux.dev
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-31-4583d8a23bca@kernel.org>
 <9bbdf4e8-6984-4477-a183-f0b236047381@kernel.org>
 <3557015d-23dd-41ef-9832-78b58587f3f4@kernel.org>
 <81e1e5ae-0aab-4584-81e6-3fc9c2634d07@kernel.org> <ar-b_Ug__TBzIZsb@gremlin>
 <2e5a4e6c-8f9c-4050-8998-454b83f4823b@kernel.org> <ar-luB9QVCRshtIw@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ar-luB9QVCRshtIw@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yky391uyxj5fapuojohys68pnnx3s5nc
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BE44D180005
X-HE-Tag: 1790946721-880851
X-HE-Meta: U2FsdGVkX19sTB+EsLi87Ols4q8dGnKqnIY1kpGK0thlhFySCcDVniNo9zoL7H2xLqMt9nSiw8gw02DwoGexZpQnGhyY7aWbu2/0j6kzZQUBA9a3+VFv1Z3spq2ZfrlfUus9gUZqoo3rYNxZo3XQokx39Ki2KUywgrqh5rVKCWhSPkmIu558HTgBYGjXFnd1541bcnfg7tmCzU30gShnt7b1tPNksVhJAzKhLuUsodHzExB+cssnEHCWEFkGSJwNWhOeBJDY1tRt3e+n8v/IqnM7VGFDAzxcPjET9uPp3bYvVklyYQpFRJBhg+iK29MPCMNvcnZzFBPCDmNpzE3MwHL/kDX9jhmy82BBwjlEM1Q5lQgCyhFBLeG97PsnvmNlIXGzwx2JWjATjlpy4NGjejqkiiawg8L6weai0wofxp43TZ/C7Th4NURYLA4cUuypXD8Cf+iqBdLOD+qb3MSs79b8QQcd4NMNLhg3DZSTQyiUhDf66UD9tx5Izb17YZ+QhlgNw/GJID6Dz1thbHH3VLdcKiQFLggoLQf1qFHP52Bg57eH8mRFI2SknS4KMqkgtCTghO1z7CrmRntDrze9I9PQgGHjDuRhBr9sJyA0kXFIFM3LHOl/AI/6JwIzE4ZKnr4oG1I3W2v09PwuKqY06NDZz7f88XFd/nLVmup324VdgwYFhyNaK4QHgl/AaFi6DokCe4mNUJsoOJ28sHMVbPTvO55EB+xcr06x8QGyrsadsVYHrbPFl8JkMtZTlTlSUPWOyaG4v41N27tOwXecA+TkakFpl8BoT6XtFdpE+T/EgNbwWWzlIV1dSLjsjTT8njYNEz1+R22r8sSkNPCew0a6MdAnzaPzCPjX5+JiFceJlovHGy0YC+Ti2y398Jwn4IOOCj6x3nGLA+SfCRSbkepWH0M4qC1XfQ2u7T2MhHBEcjVQ1f6pzD5ogcwOA8mZUTp4mA0QPCZSbinZ4Xz
 D32WjD4D
 dbBR37yVTB4U8px2mJbx71gREEQZwrwvH8hve9ums4iT4A3Pwq5XA/XV1YNBCjQ+YcZRbciIbfoV9ubJuGz3dPjOBdteuw/fiRM8CNfEVL++qCtM7JP6GV0RyLGBYEva98kFe0cvRqk+jiSPEI9TvLTU0bRZzmNxq5zANTvRAsjJTkJT9lDdRrdxdEYTj2KWD9nS4a+m344JmjFrNRSkjeOekHfUq/BYHT8t4HoQrnH1i8ZETrADbrGPL/wPDOle34DE3o2aqXFclInFdTtCqN42aOjnC7bjc+DibxMEm9xv3ZJA9OklbBQyaPDRAkxV8HuJkWi3fYh+XoLz4KNlsA50dKBLDzdnCRb6Ep5jlOpRFyBTAZYWCAw8L83krIZhFFEJlMp0UpxAUizwTj6WGqZwp6GNwmthanry/+PRsfIFgMxBsBmEFfG9aWHIUKt8RZYfOnPj/iOHnkOeK1eQwuppGT9JR0U2QTPHdDgt84bZBfwI/yBR0gRytjlSh4WSYGdxCDMLvExFefL/jwFSJyP3aiGUHejiBhuyyzk9RU4Ha0Gg5AH4C5EOfKTDaT/+QIovJE22sqmQseS3IJjAqDMOxUVYS/LcDIwwmk2/h3XH53TWWZv00Vdsvi6mNmOdicfWrxdxjB9tKaxDjKLDeNiUqs0ex6MvC7lotrL8k4t2LrxCVzNFsEJNPCIHGe0wAHASHaZRohNiG3L2VL316nFgJq8fNgSK/6mrGoOurtCt5wlDyG64cdorguTwXqqkvJwN+A/XpcNIFRDsAa9rrBYbfDIKu6iVoGH41c4yRGHSzzc4OGq0LKh5RU/cXju3I+FCYZ5PPEiB6Hv8z5+gB/TwmKIf71z6Rwjzhn06e0V5qAFeXYStF+dz91YVbSPV1w8ly+jtXhT/Xp4yEyaCw52iWbe3veiVV8TR8l35WSZLlZE/6m4dj1ekagZDsyWOGr7NgAy/NB/QofMSwKUzmmg7wqGKJ
 4Bg9KNPH
 aPNgxsbIZEb4s0T2GxY7qCY5u3Qhi53cjMNo2ghCdeslzg1nULPh9datVGkBDZPdZ+FtBzM5yuhYPvrtszAzCjtGp0mGO6tC6aBNJEUWr+05u7SgVBSS1GLwNk/+BsFEMbpNx8w/XwwJmJa5oi48kmQt5rj+nbt+V99kJKZcRUbxvyDNgRriR8Q2ltB/B8eY6/nW+4jNnyVMWZ4AZDijq9+lcgTuJK6PobzwYwfs/M5pj88WnEPLPaoKk+JbJwOCuNZgBtCCXC8wT8hKFXBxIKXY/1AvE7NQqjuzTrQ8CokvZjKjUwsi9+XbWvMrQi2vuZo81U7DMbAX39KO/PE5CI+WTSUsyyzpLLWYoZRAbv1p+Ib3C8Xh+95zGrMeHKD4IrRovUWlBhHjQfHa7zrLWo+GysDoKthSi36xIw1MJwam3Y+nhBMkf+rqz2y//akhdQTrhxVjqI16fjuNcQZYxzijjgORGHeoM/bNevsKp9nUQJsh1SpbyJ6VBFtTOGE89lQiR+MMg4/no1rHl2A8U7YwvALPS0cj+sb+WBslWfz7Xnj0Rgwg5w20e+yiHzihKs7ituUYVPYPNOeFnKSh3dhRjbgOw6LFkRc2wNgXwb9tOB+sDlNlDPdoWUh3qJYCuiVC0OC1pkLYlczniUGC70CzrD2P5g/BszA9iFoilWGDUVpprDxjXXQyTBNGDhdpkINZ/9j03JbGi0FmHIVKpBNDaUOJSR80yXdKnFAUknKUspY7JKlL9IrGVigD+S4fF3AgSLRs/OSNlALE/4/a5o6hPSaP0mE/PdxORHyDqucy+yg4euzEl67R8jB3FkbSt3lkiLjWjegZOVs5a08vda8sgPZs0N98gI42WXMSCKx0HJuAoqdt1f6HgrUZyDFBJQORC6mjavZ8InmjIxy0Az9MBroFMoeflvEvGjMHWbvRolSe+xiclttYhV2/urFPNXnjTAmxuAt2gL5Abl8IgI217Q1RL
 F/GqT2PP
 8d+B8sCZNYpmzoNfsVudpvfKAQR9XSIAyM8J59MoKOHQQj7ldX8NXr40kQ9H5pRhbz9WcEGEBy+DpjhtKEHHjrhsAHW5wT5AaZ6oJjJUGDJR3GVECtkmyrYBQRd7BJsPhO24Zs//3amGRXbvoYA+Wdmmub5S/B86Ua4onidPXiRvn51279Qg+dft+EPm/QbSorKD6zOzNoJHLoQ2JmtbuF+Sg8by4Catz2SMg09xqLLI6XNgG4LlLyf1lST43h4yYx+wsswMpvJYj7AmdDXTzSWbrtYjwu2JRpgYKhcFF0LW9otQEd3mTL+fLhPfH/wBvw3ex//3JKrSm7uVqbmd1VoYyV1niUYffe8p59sVRZmuMH0LCX4Zu11Y4hTGDK8dueGcJ75ilo2Ke1VAEsmLcXvQxSU/89Bgm3WcpNDyLK65KHEvw9FUMZ2zagq8UrflLv2IRtVzvqcp9mUoiRdMB9xyUU2g9RfG2fk4RmzSKtahe793OUZ+YbKYGsfcblhuXcGtqJfMehKv+ns7auJU6B+nBsj+feczcbYTsxnDnjk6Ygh1ftthW4j8YYwRF6FIolOxalW/f+8sUW2DT14BsdnQ9L33zUvQKqKcCuMeG0CSe/3w5EVoOLneQtBT+wIstrwGBa8vMTc+l0yIJgJ1N1vJOLNZWgihIXUcx5rYX/HlYx36zjB/Wov+o3guYiAPGU79tqlLqNhFdzO96n3sLH+13Wr97EdGCay6JbkzUUS5L0jzWYb91kcYxpCXWTzfvn+P4XIp84fxiNoTew8LPXHDQPqVIY2xjZEP0bTqpoNthYPpU5Htlh+xlcMzE41aNmJk4ZlYNOzhY9emWrqOcVS6utr3cgoSE2qJF4mfjVWFxmnLU9NhHcfDRFOn5RZ9XFJknTuZsNk67htcnKbPcR0qQJLE1Jg5p2CS5btVNXwwG1LD3fJHyJ76pe7fuOkBOGy0/E2ts9OekEtWWlXrUaZMgZTxd
 VAHt7d9/
 Zxm6iv1i6k0JrZweW5ayFqPGFy7NxuYvshvB6M62nOfa/PP2OxbC0XBBawbb7pD0/TPajRj7R6LgEwVcl/IPNvLf0pqv2u423TyQPNzBQ2pulkbjkd6vuCro8p7qq+w4C2krbds6Jwd1BZMpEaChvmDPsrrrYt8eNrGoB+BPpMMZYZiuR1LyvJ62Hu8bufLx/O3u2M4khDiuWq2TsR9Q8UBgwuwdvkYycCiCZ7k/MhDv6LIBeX+NV1h6W2jedtbXLfMz2QwLkF9uMQqBbsP3zhrcHyx9Sl8uMCvfFUjJOv2PGfmshRae2evO8qNhh4hLHCzxmLtcAelO8WjnwJAGvhzWSMYKyNxSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 14:48, Lorenzo Stoakes (ARM) wrote:
> On Fri, Oct 02, 2026 at 02:35:06PM +0200, David Hildenbrand (Arm) wrote:
>> On 10/2/26 14:08, Lorenzo Stoakes (ARM) wrote:
>>>
>>> No, see below.
>>>
>>>
>>> Anything that requires stuff not to be dropped behind the user's back, which is
>>> at least 4 cases!
>>>
>>> That being open-coded all over the place is a problem I think, and I think stuff
>>> like the PMD device private are a reminder that open-coding all over can cause
>>> problems.
>>>
>>>
>>> There are 4 open-coded checks that test four ad-hoc flag combinations checking
>>> for the same thing - 'can the kernel or a driver change things or discard stuff
>>> behind my back?'
>>>
>>> So abstracting that to a helper, alongside the other 'let's ask based on
>>> semantics' helpers, seems sensible.
>>>
>>> Maybe invert the meaning to make it clearer?
>>>
>>> 	vma_kernel_may_change_contents()?
>>>
>>
>> This is all super confusing and I don't think we should try to describe the
>> semantics that way.
>>
>> Just imagine having udmabuf use a PFNMAP of folios obtained from shmem. For sure
>> the kernel could now change the shmem pages that are mapped in some ordinary VMA.
> 
> There's always edge cases like this.
> > In each of these conditionals that this helper replaces, that's exactly what's
> being checked for.
> 
> A driver could GUP anything and access the page raw and do things like that
> too...
> 
> Without this we lose all that and are back to arbitrary flag checks again. It
> seems unwise.
> 
>>
>>
>> Likely we don't have to squeeze everything into a single helper that is hard to
>> describe.
> 
> I'm not trying to do that :)
> 
> There are plenty of edge cases I left alone.
> 
> This one explicitly is one that can end up very easily broken in the future.
> 
> Already there's been issues as I recall with people forgetting about droppable.
> 
>>
>> Maybe we can pull parts of it into a separate helper with semantics that are
>> easier to describe?
> 
> But then you lose the whole purpose of this, which is to not miss things.

I think it's perfectly fine to instead have helper like

	vma_is_dumpable()

that maybe have a single purpose but are centralized and well documented. If we
can construct them out of other helpers, great.

> 
>>
>>
>> vma_is_user_memory() && !vma_is_droppable_memory()
> 
> I find vma_is_user_memory() _very_ confusing :) I have no idea what that means.

If we can find some way to describe "anon+pagecache" ... maybe something around
folios (future oriented).

> 
> And vma_is_droppable_memory() is a semi-pointless wrapper for checking the
> droppable flag no?

Sure, no strong opinion on that. It's a bit easier on the eye than bit checks.
(and can have a nicer description maybe).


> 
>>
>> Although I am not sure user_memory is exactly precise (pagecache+anon) and what
>> we want? It's all super confusing (thanks for deciphering it).
> 
> That name isn't great, as userland memory is defined as that which can be mapped
> in the userland portion of the virtual memory address map, and all VMAs describe
> that :)
> 
> And then you can go on from there as to pedantic issues, the very same shmem
> stuff you mention above can be put forward as an argument, etc. etc.
>>
>>
>>> vma_contents_may_change() is shorter but easily confused with something being
>>> writable by userland etc.
>>>
>>> Or maybe:
>>>
>>> 	vma_is_volatile()
>>>
>>> ?
>>>
>>> Which is analogous to the meaning of the volatile keyword.
>> This is all confusing because persistent and volatile are established concept
>> when talking about memory. And see my example above, it's not even clear what it
>> means that "the kernel can modify something".
> 
> Yep I guess volatile vs. non-volatile.
> 
> But a VMA describes a mapping not backing and 'volatile' in C is pretty clear -
> something can be touched by something else so don't make assumptions.
> 
> I mean if people are confused they can look at the comment. We argue about
> details meanwhile the code is full of terrible naming that's duplicated 100
> times :)
> 
> And you can come up with edge cases to a lot of things. That doesn't invalidate
> the intent.
> 
> Right now the code is duplicative and I found multiple instances of e.g. drivers
> doing completely the wrong thing.
> 
> In any case, you seem to feel very strongly about this - so maybe best I drop
> this patch from the series to be revisited later?

I'd be very happy if we could find a clear way to describe "this is what we call
user memory: anon+pagecache", if that could come handy in such a context.

In the end, it's mostly all about: this is nothing special (lol), it's just
ordinary user memory (anon+pagecache), and in some cases we want to also ignore
weird droppable mappings, because why e.g., dump them if the context is just
irrelevant.

-- 
Cheers,

David

