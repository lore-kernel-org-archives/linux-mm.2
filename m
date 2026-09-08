Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231D2C79FB2
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9BD26B00A5; Tue,  8 Sep 2026 16:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46426B00A6; Tue,  8 Sep 2026 16:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D9B6B00A7; Tue,  8 Sep 2026 16:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A373A6B00A5
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:07:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1377414019D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:07:16 +0000 (UTC)
X-FDA: 85191679272.28.C257F55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4E5B51C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:07:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kN/btgh0";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/OHowaZfNnH6j5YLgvEYzRWeKR373+5I1ONZvwtiOGM=;
	b=KsMK1LfDMvOOu8eFcouHFcY6IaMpDMALBYmb5LSVJRUQj3qcBqZRhDh311K3HUp+tAQGib
	DCKZ7Mk/E/OPzzYbiYH8zUCHewwYXm893I8lDSMp6nZo8ggKfv0LXDBwmcUyM0XF5sID7U
	aeNuc2puxd/OTPOTzEwclTlyFaPvQZQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kN/btgh0";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898034;
	b=K5/9BW8vHt9UntXZoGjDgAh4sX208UeO4vhrUvzvH6DYEi7GUgRBZVawpKhcM6byBYl9s6
	7OPstYBlQ7XdooLybunntzjhdFcYsRkCPVNBd848mm7HuCe+8cvPNqM2GbyGRP3PhUYpBU
	9C5pYmJ8ycGGQfvjkYz5h78Y8BFCVkw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D8DF3601F6;
	Tue,  8 Sep 2026 20:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBD61F00A3D;
	Tue,  8 Sep 2026 20:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898033;
	bh=/OHowaZfNnH6j5YLgvEYzRWeKR373+5I1ONZvwtiOGM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kN/btgh0eap/SzTnfSMyA1+JQMgNNTZgMm76v6K5xBzJeML5mC6bG1ehwUm074Wwt
	 mu4BBs8HNe0Scxfm6+rZRxODax9ptXPYgz7B2VRoWj8rT2IIaLy/Cf4P9VNig+4yyC
	 yOaismpmUijBljgnNHYEJwqhIK9m6OdzBDFFAG6yyCnuLxT6Xo+zf9WHbNsdJBH0Dk
	 VXiJQ1zJjohovh+PxvEB01WbD/6CZKPV5fgwDx+/uK1/qaRGlUUCUss+MZaWX6yRbS
	 RWufKT4bxmMVtAXkBT+1COQY8ZPY7lN1TDNimdMZuPtkgIZ5IZm7N3RznryoHsyHuE
	 3KSVVirl3z1hA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:14 +0100
Subject: [PATCH 10/39] infiniband: update hfi1 to use remap_vmalloc_range()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-10-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9393; i=ljs@kernel.org;
 h=from:subject:message-id; bh=DvnDuvgsaeIMg1k0R/1O6RcBwGnMt/C+7lANJzJCM1I=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG78/93P99pW//+K9zMzmHMuySj6SmXx3BA+HjfzV
 wS7XCpTRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZyVY7hf9XsAj25r/dzk15F
 roqSV7otOy9/9/WU1OyWLzedko5M5GD4X9X9cNIO4e7kGfU2x5Vf3GdOnV/C1Hfk99YTD/evFtv
 xnAUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4E5B51C0003
X-Stat-Signature: menuh987q5s8xah91y58zfug4tcybum6
X-Rspam-User: 
X-HE-Tag: 1788898034-794334
X-HE-Meta: U2FsdGVkX1//LCK7LubGa0RoI1/N1N95fTrL9iFLFJ6A15x4qvIKM+ep6DytAqpWzZX0ZTh6iRq4wTzV7Ou652LjCMtguq3Uo+rF6kfNIzfCrjB0SkL4BxvJoluEBEDi97DmJvVHsmsjnPS2kG8Gi1j7Qv1al8arczJq59Q+IpdSfUfqvukdda5ZrrUFktsigpPGwJjck56uN0ZyCPTiUIslTanP1lX5S39IxXgS9GU3rTfx/WkLUQuF4dAEN8ISFs6/B3ewU8ukoq3rdEiCvLNwZTkXVU+LflHkmYS8mLOGss7cTIRLSkTTL/qYegq3iNTjrXeHd8DzYmQgu/5rUNjMfKVyTeSpyw8BK3BqWmdw+KGMI/3EweSHf/IntyldluYr6xILAF7VYI0YIUYSGkh89CVKZ7t5kVZHikfXDKtqJ8pPT+reCU7hc6Gs0UPUc4tXQmu8fMokLhk7lhGLQYHw115qiFiGujPAOEqaOjWDYq+GuxgjA8A7XUaXeUCK4kew/y0YR7c4XyT5O7RYXpiaVob8TOtc7AV3958E+WuZWXl4C/w2VARydIqxn55/MEaL/9xzSAaiGqPITMeDyD2U41naev28rDR9+XMtXFsr28eUInIJmdDY+yoDlraV6BH5n24A5oRRgj1MCpe8wKlwWW90MgN/+zrawcOLVqa/uUQ0rnGgSI4VZhE6Ita16D63s2TY5pM4vQqSgw2qGNYw8NmOFobGbmXgX70n3+ognrrB2X4lXE0b6jY3IYob/OgD0zwiQzC1QcFThieAsqXXDd+egqQVkPTagVV1m88Ut6zH02Uo4Zuf3rNh+DAlOczeTJ1sp0tqg8n5DeyqIVXOFnKz4rZcBXXC6rE1W08YNimSRIzoniPtLG6i++ckK8UkoRObZWJRL96d9N0Y+3WwTGhDM9jQObt687N+OXU3dOzBDUwqMDuwO2xcl1OQ7nGUIBaWrCJ1fMvrj26
 Iu0sIA7h
 FsS52qYAqqDeqCdc2j/NxZyS/XxTgyFWNf4GpiTKRRQt4g1xeTGKVzdX+ld9u6YsVjCp4aRHk0TjUVYBEc/deKPXojvyCfxuKl8F2881coK2l02oM981hvtJ2nheusfFoJ+3pkOJvgQdE82NK0AKHBDpiAiEV//FTe01iRDbtOfWYNnIDb/kAYfpeYjKVfQQfC56p2EJMcWzYsght2uTU2wWmYw1X1rk/glHlVg6NYz0Q3U4FbIew0+Qq5D3Uo++L9cpbO3wDTcBTB0h3nmED7NDUKMF8jkvpxcJkRRsIsEYPJNGCwRPd41tNRiJDNsQ7RuM2rCUb9Zets0ApnXvERzXEIh5V588C4FR6MEeJ3VVSUlFOy3NJuoPA9hA8MMSsIuTeibCVMKeo/o+8jy7yJdMoFhBP6wxZzhvmyivubIzeUPx8eA+AOy8xUNSB3tcg1wXujW+QJOgXRZixoGLerQh7DLxho8pfhKQukXXKk4Rap5iScdtOpLRhauA3twGZxUA1ex4MKL1wjqhuKu95GUyGglAqS48dp5IldLLjne2wUBAUge8fzGqwIGosAoiJGakXl6T/XpGpXDjpEbqePLHQPnLZKl7wJWwXfWkQaWOYLI4R1UpSEZ7bs9tSUiK1cypLJrwAx65GlrlJBDtZTuY9563ohLs92LuuPeoTp9+FtQ4H0TXqUgNsbGhngqfpXuv4GTtVCgy1s1qyp4+NKZnm6SFRVwTs3tUglP+sOswTitZ84GWzs5dmTSjsTGWiikjAiE/VDQf3YsygUWHLRgOMo7d18OiJQjsiGglpSaHhzE683o4KWWB7tV7x08NfA3Bpx+Gl3bdQOM/AQ1Vuw7kpn4U2+8Wy3oJgUFlWx4yAp5mPiLQM5t/aqGAat090N23pqDZhzzGiAqul8Xdr3zuo7PMkaX2koHugDGqmebQR877xpXp0pJnYcpNMcdUYTJkfE1NLHEeG3F16/R/2q+Wus8GD
 H8dC2to9
 Yf9EkgaVd/PTwxhQu/XDcYOlLovAKpp2E8pV3xjd5hBRM3wBLc6r0ETxwClOlezfa7IzKG8k7jePglYDc/lfRlI/TR/QAaMVK3P7P8zyBoldUPL/+6EPP2MH/BAMkTcr8WTQJG6NjxX0HZ+2snFHQ8ogRVXncknngNgTf3whkHjGBeU2iP0TKSXoF1dgFB8k8AUlqYSQXlE48vM6o0sJLtR92cyAsuZxZMK+T7ftdzl9NUDhl/J5lwdPhFeKLZ8DJgvCZZpSW/q0y0x17t8U+dpF1nmtd8VCzS0CoJKaG3C8qDe8Bw3OpUx43JBx31PFS0swMz6b2QO/Bv903l9uj4x35pc/tYj3hlfoynYI7lmoP5gL+8FpZ5NUrolxp66pk6rqTtokHgKExSCeGGn/igleruCtVNWDJNbrs+QbWCnyI5aKGVT0qOFUVZqmhCUDE4osjNhxiazTPib2evxJBPyG/VW83NzjS+Br0buEnABR5gwseKGkxjQPA+XF63cKOf7uTaI/k/7NvGuNX1heqkketU3lLOW2xRx/th8/cZY5bipvK8TZvWGZuQeet9iTq0Q82CZeWdOg4anFWwgeCFZ4jHSFGag+YkvrcwumFFS4A3OgCPiSyDXxTvm/01hsGPlPNDFZ+gS4FBRoQooDXc+M/0gXVozzWrNJBe7Hoo1J0DiW2Jq6aFC5+F5pGPb0AG0dAHsSOeqIrdByijhXXJ74tFnVfWXU+H+jpEFW8x7Bg3Bh23cEvHDzDOGUshCHQ9Nt8OHe2OKV1V7MiJbWmESzIQN/WIAMeFNE7hP/7CdmeMOZYvSp3XC/yAoZWUV5AT4zHOW3neybWkCVtFC25LulOnKbN7SBJYXda9FZ9czSd+e4SuXbZYxkgmG0s5ms2Im38oDArUZcHbqWtCSYRSOwKxtfdIuTGJbb/1ipanvpIs7ZlpGnWJyUw8SDIVxafIJMCxXYJR2BoMU2Ig4dYKH+3wLWi
 EPYKDXlo
 DA5ofdALI4wsRY26NdYwuvqTtVwB1XyeamLNbOdhowBbaprA2OeROXohxmPSAsWBndeNlP0e0CRjdYJIytQK0a6xPhs7pB+m84wOj5wXXSbnZXSXxMrSuj3xpnfDQ0WN/jeCpSFQVJgB00m9PTdq+9MhvAxkraDMFX+BevkSdtGa+19hfuGur4Ps3br2N0jM5SVkQRgG79fRtSBcfud9IwdfSrZAjRz8PlxIsM4fokoTYb1U+DZODxEMngb/Fp51iBpzxzmJAV5yI7eC8d15fs0xWkVaAOdLEjG9BZURJ5z1bmyjmuIVO9HEqrtXHDDxBSrPwCWzRYMc3EA3uTXYmNDIdZKhPR4vGIuK66UEH5DAegP0ucgJJC7hsRO6SIE8R/tx6eu0JXR0Lt1lD1zyR9+KYS+aCfDMft9TenboUJ5JFlhODhcfGzvQ4rkwPaCiMUdZnNBSrz+3JQMKAZBAVbMp2uHtCnANa+8A+NHO8dvz2GoTTLJYb5c5HnEWZDHU51B8xcr9+Z8tzCk+cn/uu2E5z82S7m+6nDVAC4zfM4lLs062AtzOlUZs55U3qveUnQnxGhhGY2njDfuOaxd7n7v2uoTvbGtwKLz83zLQrKV5SNurwLiU8w3k5lnjMraxFnXnWejbpNoyUHFeF1L72khoGUlRoxfC9fP6+/cuaOd/G7P/2lsNMHlF6933RbR04azpm2blN7iEh8WvaWovhx2OBRdxgKiTq3j8OYf+NLTnyVJ0XUGZgqJXY/U10LFayU1X+jHiVp9Ps33J4ifBj+zwE4rIE+Yn8Tp2up+GRpi85/I0k0A9FQm7QYDfWiI6jvS9FoE3Vg7ClC63Hvs92mbZYUq7ujDIiwU20JoPEqnawR+iyOBR4XJzwDedVxmdYXTtv7XjWQp7epBJ/iZ2L/Uh4xKe0Y7NeDkBn18dfsk1kLc244QYAjxFFRUfnI71m4Wmh2VY3cq33Fx9L7JEEekPpIeCj
 A0RJzyvQ
 Vt4pU5/g9UxlSMUy8IiXueaBuPWJGofyCJfdj16wBAemdRA8+YMjaEcUWLJ2jGvvDj1rKE/Y0QWIM2Zu2iLCPbPEIEfHGCOm8Ae5P0KHFW+tD7N9DQlqQ58sngCQpuQB4mk/MSTj0bVsPEbfCHxX/k2HPWm5J8hj+5nqJrcVaN8Cx3tMgb6CYa0Rp+VpMEDjzvStYItV4lR7xo0bpqfPNN2I3UKEHYhmaKrblrpRf8KvI3+QUKR6LJYk/bP5gQhj4C0wfggXW2s/1GYKF9jK1PTvbUgebbGfWqapYkh7H1aNl9dESODBY0CA5liOjT7BX1KW8tphE7ZykZ4u8lQFbu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In cases which map chip memory from vmalloc()'d ranges, the hfi1 infiniband
drivers currently installs a fault handler, and then smuggles the kernel
virtual address of this range in vma->vm_pgoff.

This is exposing KASLR-sensitive internal kernel state in the VMA, and is
entirely unnecessary.

Instead, use remap_vmalloc_range() to remap the VMA to the span, and
eliminate the fault handler altogether.

remap_vmalloc_range() checks that the VMA does not extend beyond the
vmalloc area, and the driver already requires the VMA to exactly match the
span of the memory being mapped, so this has no impact.

The memory is all preallocated so not having a fault handler has no impact
either, other than pre-mapping the ranges which is beneficial.

We also remove the VM_IO flag as it's not appropriate here, and the
VM_DONTEXPAND flag as remap_vmalloc_range() will set it (and also mark the
range correctly as a mixed map).

We also update the vmalloc paths to place the virtual kernel address in
memvirt, rather than overloading the physical address memaddr. We predicate
the vmalloc handling on the vmalloc flag before we check memvirt for the
virtual address-derived PFN remap path, so this works fine.

remap_vmalloc_range() requires that the vmalloc()'d areas were all
allocated using vmalloc_user() - each of cq->comps,
uctxt->subctxt_rcvegrbuf, uctxt->subctxt_rcvhdr_base,
uctxt->subctxt_uregbase and dd->events were allocated this way, so that
requirement is satisfied.

We also remove VM_IO and VM_DONTEXPAND from the STATUS command, as these
are both set on remap.

Finally, we remove VM_DONTEXPAND from the PIO_BUFS, PIO_BUFS_SOP and UREGS
commands, as these are also all set on remap. PIO_CRED retains it, as
dma_mmap_coherent() may map via vm_insert_page() on the IOMMU-DMA path,
which sets only VM_MIXEDMAP.

Note that we retain expected behaviour throughout - the vmalloc remapped
ranges set VM_MIXEDMAP | VM_DONTDUMP | VM_DONTEXPAND for each range.

VM_IO was never appropriate as the ranges are explicitly not MMIO, and the
reference to the v3.7 VM_RESERVED semantics map on to VM_MIXEDMAP |
VM_DONTDUMP | VM_DONTEXPAND correctly - no core dump, unmergeable, no
normal vm page for purposes of reclaim/migration/etc.

There is a change in behaviour in that pages mapped using
remap_vmalloc_range() will now have normal GUP-able pages, however this
should have no impact as there is no reason not to allow this.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 79 ++++++++++-------------------------
 1 file changed, 22 insertions(+), 57 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index dc548e6802e2..7119d734edc7 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -70,7 +70,6 @@ static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, unsigned long arg);
 static int ctxt_reset(struct hfi1_ctxtdata *uctxt);
 static int manage_rcvq(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 		       unsigned long arg);
-static vm_fault_t vma_fault(struct vm_fault *vmf);
 static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 			    unsigned long arg);
 
@@ -85,10 +84,6 @@ static const struct file_operations hfi1_file_ops = {
 	.llseek = noop_llseek,
 };
 
-static const struct vm_operations_struct vm_ops = {
-	.fault = vma_fault,
-};
-
 /*
  * Types of memories mapped into user processes' space
  */
@@ -304,13 +299,13 @@ static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 	return reqs;
 }
 
-static inline void mmap_cdbg(u16 ctxt, u8 subctxt, u8 type, u8 mapio, u8 vmf,
+static inline void mmap_cdbg(u16 ctxt, u8 subctxt, u8 type, u8 mapio, u8 is_vmalloc,
 			     u64 memaddr, void *memvirt, dma_addr_t memdma,
 			     ssize_t memlen, struct vm_area_struct *vma)
 {
 	hfi1_cdbg(PROC,
-		  "%u:%u type:%u io/vf/dma:%d/%d/%d, addr:0x%llx, len:%lu(%lu), flags:0x%lx",
-		  ctxt, subctxt, type, mapio, vmf, !!memdma,
+		  "%u:%u type:%u io/vmalloc/dma:%d/%d/%d, addr:0x%llx, len:%lu(%lu), flags:0x%lx",
+		  ctxt, subctxt, type, mapio, is_vmalloc, !!memdma,
 		  memaddr ?: (u64)memvirt, memlen,
 		  vma->vm_end - vma->vm_start, vma->vm_flags);
 }
@@ -325,7 +320,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		memaddr = 0;
 	void *memvirt = NULL;
 	dma_addr_t memdma = 0;
-	u8 subctxt, mapio = 0, vmf = 0, type;
+	u8 subctxt, mapio = 0, is_vmalloc = 0, type;
 	ssize_t memlen = 0;
 	int ret = 0;
 	u16 ctxt;
@@ -347,7 +342,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	/*
 	 * vm_pgoff is used as a buffer selector cookie.  Always mmap from
 	 * the beginning.
-	 */ 
+	 */
 	vma->vm_pgoff = 0;
 	flags = vma->vm_flags;
 
@@ -366,7 +361,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 */
 		memlen = PAGE_ALIGN(uctxt->sc->credits * PIO_BLOCK_SIZE);
 		flags &= ~VM_MAYREAD;
-		flags |= VM_DONTCOPY | VM_DONTEXPAND;
+		flags |= VM_DONTCOPY;
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 		mapio = 1;
 		break;
@@ -438,7 +433,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			memvirt = uctxt->egrbufs.buffers[i].addr;
 			memdma = uctxt->egrbufs.buffers[i].dma;
 			vma->vm_end += memlen;
-			mmap_cdbg(ctxt, subctxt, type, mapio, vmf, memaddr,
+			mmap_cdbg(ctxt, subctxt, type, mapio, is_vmalloc, memaddr,
 				  memvirt, memdma, memlen, vma);
 			ret = dma_mmap_coherent(&dd->pcidev->dev, vma,
 						memvirt, memdma, memlen);
@@ -467,7 +462,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * user registers.
 		 */
 		memlen = PAGE_SIZE;
-		flags |= VM_DONTCOPY | VM_DONTEXPAND;
+		flags |= VM_DONTCOPY;
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 		mapio = 1;
 		break;
@@ -476,15 +471,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * Use the page where this context's flags are. User level
 		 * knows where it's own bitmap is within the page.
 		 */
-		memaddr = (unsigned long)
-			(dd->events + uctxt_offset(uctxt)) & PAGE_MASK;
+		memvirt = dd->events + uctxt_offset(uctxt);
+		memvirt = (void *)(((uintptr_t)memvirt) & PAGE_MASK);
 		memlen = PAGE_SIZE;
-		/*
-		 * v3.7 removes VM_RESERVED but the effect is kept by
-		 * using VM_IO.
-		 */
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case STATUS:
 		if (flags & VM_WRITE) {
@@ -493,7 +483,6 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		}
 		memaddr = kvirt_to_phys((void *)dd->status);
 		memlen = PAGE_SIZE;
-		flags |= VM_IO | VM_DONTEXPAND;
 		break;
 	case RTAIL:
 		if (!HFI1_CAP_IS_USET(DMA_RTAIL)) {
@@ -514,23 +503,20 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		flags &= ~VM_MAYWRITE;
 		break;
 	case SUBCTXT_UREGS:
-		memaddr = (u64)uctxt->subctxt_uregbase;
+		memvirt = uctxt->subctxt_uregbase;
 		memlen = PAGE_SIZE;
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SUBCTXT_RCV_HDRQ:
-		memaddr = (u64)uctxt->subctxt_rcvhdr_base;
+		memvirt = uctxt->subctxt_rcvhdr_base;
 		memlen = rcvhdrq_size(uctxt) * uctxt->subctxt_cnt;
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SUBCTXT_EGRBUF:
-		memaddr = (u64)uctxt->subctxt_rcvegrbuf;
+		memvirt = uctxt->subctxt_rcvegrbuf;
 		memlen = uctxt->egrbufs.size * uctxt->subctxt_cnt;
-		flags |= VM_IO | VM_DONTEXPAND;
 		flags &= ~VM_MAYWRITE;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SDMA_COMP: {
 		struct hfi1_user_sdma_comp_q *cq = fd->cq;
@@ -539,10 +525,9 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			ret = -EFAULT;
 			goto done;
 		}
-		memaddr = (u64)cq->comps;
+		memvirt = cq->comps;
 		memlen = PAGE_ALIGN(sizeof(*cq->comps) * cq->nentries);
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	}
 	default:
@@ -559,12 +544,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	}
 
 	vm_flags_reset(vma, flags);
-	mmap_cdbg(ctxt, subctxt, type, mapio, vmf, memaddr, memvirt, memdma, 
+	mmap_cdbg(ctxt, subctxt, type, mapio, is_vmalloc, memaddr, memvirt, memdma,
 		  memlen, vma);
-	if (vmf) {
-		vma->vm_pgoff = PFN_DOWN(memaddr);
-		vma->vm_ops = &vm_ops;
-		ret = 0;
+	if (is_vmalloc) {
+		ret = remap_vmalloc_range(vma, memvirt, 0);
 	} else if (memdma) {
 		ret = dma_mmap_coherent(&dd->pcidev->dev, vma,
 					memvirt, memdma, memlen);
@@ -588,24 +571,6 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	return ret;
 }
 
-/*
- * Local (non-chip) user memory is not mapped right away but as it is
- * accessed by the user-level code.
- */
-static vm_fault_t vma_fault(struct vm_fault *vmf)
-{
-	struct page *page;
-
-	page = vmalloc_to_page((void *)(vmf->pgoff << PAGE_SHIFT));
-	if (!page)
-		return VM_FAULT_SIGBUS;
-
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
-}
-
 static __poll_t hfi1_poll(struct file *fp, struct poll_table_struct *pt)
 {
 	struct hfi1_ctxtdata *uctxt;

-- 
2.55.0


