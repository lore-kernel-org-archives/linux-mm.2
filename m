Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649AACA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 11:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62D896B0098; Tue, 13 Oct 2026 07:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCAD6B0099; Tue, 13 Oct 2026 07:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5806B009B; Tue, 13 Oct 2026 07:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1FBB86B0098
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:46:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BBC8120B75
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:46:56 +0000 (UTC)
X-FDA: 85317426432.19.64DA4C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 126BD40009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:46:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JsNwWiGG;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791892015;
	b=BGXoeVUk5fjlTRMfOhHtVdc7k8REefM4cQgpNw5gdiBP7MUbab0Hqns0OJMY6xNKUQuRNv
	K+pU3dlaf0un6RzUnXY6dxYsUBnqX5Noyf3vB8NR4BrdcKE2ot56L0mQRkoiejapCQVQfk
	6GcwHQw7m7BFg5Jja0GFAn2rfcYaY+4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JsNwWiGG;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791892015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1nnF4ZhcdJUlBWxekcjOronR2NcHp1dKz5EHoMfEfXk=;
	b=2RU5ZMVLq7M/TVUAnhrLvAD45YdA419TClGVgt4VyXtNaLnH1cVtwLOWjNYpO/j9jCTZ3Y
	fdchvqoVgldKYQ7xMIK1F3L/oeEIacSEfXFhCb/u/D0yaezvO5FNjA1sCHpNkHGAfxFbPx
	1Vfs2UUie1cqhpKj8wyTlU85vt1goZU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22B7D602C3;
	Tue, 13 Oct 2026 11:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65921F00898;
	Tue, 13 Oct 2026 11:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791892013;
	bh=1nnF4ZhcdJUlBWxekcjOronR2NcHp1dKz5EHoMfEfXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JsNwWiGGPLpQBTVRJ0pxyv5sreFzDIh4DL9er2BIPqypmeADQ3+kGufnoG9MayGsG
	 Ow2kvpxaWsj31kCiNI6YI1xtxB6jAuvoFeSUehIJRSSr8PvPf39/J2JL8+Q8gZNKpw
	 hpaiLridC4NDmbtWtYCSXMnVcXUvRVpYaXF7fuyaM4cd4pfx2vv7Fp6hIZ2715U51o
	 41ifwXQLKGxBc/H0/rQD53V5RTXy4cc2VVaIpPP3J14KY9KrW96ntrahOMVdTN4KO/
	 TSAFtr+2bjHgQH5lauCoZ5P/rczb+ytBLkrNPZZt6Dfwz5bTKu9NMmntqhvn+1eShm
	 h0kZ4EeW1vuHA==
Date: Tue, 13 Oct 2026 12:46:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Bert Karwatzki <spasswolf@web.de>
Subject: Re: [PATCH v5 35/38] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
Message-ID: <as4Z_ASrMbQ-eMTn@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-35-923b70125b1e@kernel.org>
 <214514be-a935-485b-8925-07d84c1063f9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <214514be-a935-485b-8925-07d84c1063f9@kernel.org>
X-Stat-Signature: nt1ypm8bky71urr7r73uj3g3s7zozurp
X-Rspamd-Queue-Id: 126BD40009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791892014-77579
X-HE-Meta: U2FsdGVkX1+e0iny0WWzzEhKvzvtQLroR2FcC996K5BOx0hUTaK14P92fu4Ycl459XaVm4BDL2p9VmBKNzD5IX9fdV+EXxdWYd5X+SCKVvtni4nN4f6grx0/uBGDsfbevyvLmfl3kuXX+NjOp6aDRrZFiamEHRWwQFoRHpk/99LcSU4vnzSnlZ3aABft00z7Tvb22BBSqRSinW+vX5NlsBG6i3qROFZ4nKgZlco/61HAQKj4giRjMGl+RjvY4k1jANNKp7EqnrGdWAOtXOLzsOfKx13JQlOFygSNVeO54RfK0hoGz0DdbCw3fl4MLmZ1VoBvIR/av98okRK1qt6l+BYkePigt6MWUaWOuSiPUbhbZYM3VivvomlS0JTCrdaGiWKN/HbDCExMrzq4MMVSTD0TI6BJRxFrAskeGFSOuoM4w+OWI6VbsUII6kIAm6d3MDHpfdQQbXLeObSAA3FeBSX+LxGsR3UDDx/KLJyLwghiUik6eo9EI5NCPs4fBakwzV5ziqmEFj/p5YNHpd96aSZi8+7t7v33cOsaA68FgVCbRW3RkisRQP08Oi/r+KcoNHcXdeIT5MiKL5EkODC0HpqToV1ytUNtd/9UgL1NUQWp5beeZAs7qCC5X5FJlH9l5wogH91W3M1+cSIR/GSKNXGa0JZMhkyvSnMrcm1H/34BBrCwg5sFkvkTRdkNdv+9GPf1ln7y2NfokKgzLQTvYEMIbywv/4dYi3Zm7P5iBAesav7sGPfDVb5UdXO5LN1LyR4fhA9h1/49hlsvbkzDkZT7FXcVwApZKZivHj2wInwJfUu/sEh6i3bRyLmD6PtAaSvc3L8Vm2vatR9wxsgTYpoFTiX9J10VjTudQH+nNy8lNMI6btGB9D6JvC4/1ZbAivjr+Y/X0I8/1ZPKcEWn7NvsEaIY0xKxyyYqQ3YmgQNGn4Eo8uZZtw2yRu/dtQOtn7i//9WSSCdwlKllrZn
 cLdb7+aN
 zDQgBiXDuCkoCA0GdPEMF0L84y5HrAE6KmVyie/oWMW7CjpR9v+R0Xq9nA68kdAMBsKJgvj3IhDrZ7UBaIOCGSQqpffIC2zXK4Q1OuEZISMvLOLfRWj1jRcH2xMU0nyyye0q3qS0+ZTcMb7teo2quT1NngUq365DFA+1/S2jnqo0R/3be3biD97DfWb66e6cuYK/W9Phhsx1uy2SqBUQMv9J6Uykz2bpaFw8YY5q5XmjJEhhkAMgALZNoYB17soawMPcY58PdArQQ3SSWywX0sJLAwd4WsbwO3FPlUFTc8Qls3Oge4joh8G21Aaxo6oYVKBtsrZ07TPiN4U1A6HOrXTK7W9GjEweeVjGv7esayna7geh4Ahz6xifnGovprpg1pLD7HTgjAtLufdWYjKWBeufkqZZLYymiKvD0zhweGGpt9XOqfClO3na69xOJdFsrd0KN9uGgKzQw+BVhT6OqgqYVLeBXZGpyOtsgl4qUQZ8H2/rv8jQ3fFhE9cW80Greo9HD2f6jUdU1Ksc8e8l3fj5ZiQtUpXRUiNhOrQ+2h8zMo5LoAj7WaxNU3bQSt4DwH0Cgr3W6AzCC0C85KBAJuI89Brfs8V0AD0FiPy2JYsLDBmTKJNX0S5ZomleAwkymO1O8nsbLswdCFvGKTld18WemncSVdcQ25u43LuUqLLpWtTCYh1EqJj2MRJOovR0Ptqd0XTwvXOWMxjhFfQ2UK1BfvhAuRXyjXnyi+iyDEbgKUxx68wDxDhOAfD/X88zb4DSl4ub02trU98gj0eZVQ4WhE1ZFoGezLl8cNbmIsnn3qXA6RhgjEwSVFw9/D4zQs153GqG5Vq6KJwUaCCBwluTWvxT0CQkUlHRd+GCU3azaD1Y8Axh7xdvrtIBeOQGmKP7RgQrD9NUI7vl8S/SdyQkb5/TR8RbmWxC9rqMfWazimLl8zRkDbntbGmxXRrX2Qw5FbtiTDh+mp6ujcp5nk3zIR8D/
 kRlEojbX
 604OSJuC/6xecXvNMxeDqGDQHIzuBUGCJCZC0dLhtc8cZo6U630AkibdFvMGepdzK3hLGHMiWr+74+SVDFAt8wOvd8WywPx/RxM4AM3aeitKiurBTPUDNNZQLND2rabXo9iqudfHHKAIhAxQlAFEoZFeDjgaPJVODYxe1P+2SACs86xb4cC65gdiYqFvsUit3Nd82nvTbL1fMD9L6OjwlEP8Hw3KcNOTNRryHECnmhHUBUXobFy5KQzilYtTyeOxr2C/nc8bKdyyJ7cMfXfIJ4+QX5Q31BF7oYIrZzqSc3iaVcoh/h9CJICM31gwY+ZZVv9OAYJoDauRxIl9iC1Rmypvca/OJH0tIPgzNuG6Ix0mpErmB41CYHnW9QWWVkmlOFxzC7ubyZe63ctPIsRrGZOwNqkxsrPPBUriTrTZObzk7WVAz+7D69BmBNhZXCmpx8plUw+6ORO/36OGQH65qJXL7u7Sz4iy3QZX5b8NpIAaCBI9XAFD1q9S6PYdXUG3FdbKit3Ylon18huCzRPEmE2QFq8KBOIdjXaYL2G3Hs12oAR+I2PeKQlYsiwF04oY4w7VT7TG1gb6ANHrKXBPqiBtXTbR1rQEVxB168ORglbWRgAG+DisGIfov93vw29k5R4OSz0aGtQsIBZDkjT+hjqQEaXrflZUUeHQusoMEhY6nBXHJviCXuvmJdxlIyzRAru1QfBpr5cVgIb5N7yomwhfqdfuwKlTBBluD9TusMQDEAveh5JVRIsXxeYuZovP1SPTvro7QEA+O9eOBP34vZCrYZDGrO9gX4GDYymSRGwY30YsA1TydsZua3MORk5FKiZJluUuncFlbkUdGcIoHUYL55EDRfq8e7IXKweXI7gWkrL4XL4RnMauSImKCQDaIHZXs7dbaqwojS+9Vhgge4udCZPCq53aQbUqeA0AMYyTInOJoAKRvta44SghG6/yVoob6RszV62Pdpr9mKFJ4AOV7HXp+
 NFb32eAS
 1rxrdX5aKpkDQqrUTYRuJ77VXdDHPEtx0CP+aEXBFXq4n1D3ilwIigksAxg/1ixazK2ZO51W9H6KwnZkwOiT8jMbng6uueZRz+et2M5twobL9lYofo1IWeU1RYp/0NHEsR289CBlZL9f6lEZ/Cdp+/uH+FqN/HuKl13mqvx+fp43JV5t8l5jPfaWlukNi0PuccNvb0Yn6KuRvJQHMzRyTWySve4L37ExLC1YqJsXitO855pcLzpoiYT86O7lRcQeh2Q2vv2NcR6F/9oZB61KM0Z2Iye+juq/AziLFrTP++L52aaqlsxFBQcYN8oxOTzUmAV1++MHwIcA1ZTDucmK/51ZvUqF9vAwXtxK9OzzuiwYLKIHKAjfvVZ2M5gV8L8ZAku4vXYJbD96GU6ZnMaAkWq3rHmAQOnUuIRPpwNGVhX2tthSVJcQEL2egj92PyCTSulFII9DP5v1Hl841FgncoptJb1ERsDfWnU580r8v6mEzHqnWuEKC0W75UslCdKNgOQmoWgw9Wo3Q9YCPlPyXqbRSU1vknisek+Lsg48VkK9cb6e498y8QQyt6TzwIdt/Sk8AedDxL0zBglITIUEQMcIv3G3KK6dVh6qvqNdE/r9s0+LnWUAAIVUHKLKP+blUDkRcV1A86qlCVIyrYIvniWU8gcQ6y8SuclLuVrCPxuixPd4X00x8x4RYmSQqj55cmlnu7HE/B9/bGb6Rhj/Zb+6IrFd2xl3MbKp57rk334EMMzPpNSfn7V2AeKnkE8dYTbqVGuGA4Y4KKe3tZEgGGcSGHDWYaAMw5bDxI3W5GoYSBpeHbuwWh8BJnW+qfYkZH52dGim7OkA77Iuhc7FDf8E7teoyfMPXhAKxeQtvbddjRgkS6nunDV1oUT6LKcz2vncsKLllT8xCTO5GOO2+X1ui8N0Dmlm15XiWNAzBSSZzhDODeFKGVasNSp+SfgZNPwVO/ibENEuJZ7Oul1Ixb5rkDX+8
 8Qho/ROp
 sfS2XuW3c0jIqo+wp5hIMPCoiXzOIb6n/2e4j+vzZAQVYfxIvIJ9eY1573FX8q45mdVhxq/JGHLhyKqoaRPbMbsNFuINzTQQyq5OTLbIyxuaAS15IgYLdz0FfGsWKPQASAuxeB/HzJFow1ZBX5ysr1DY+IhRa75lJ+jJ8Tz9jB6ySrOMl47jYmScV2TEF1U5y3ateeFDU8KYvuuD8jEK02FI/i2FNdYXjCCt5ChnQOAW7LkOMZwaSGqNj2MPKBdK4MDA4zyD+4tti9pNHay7L7P67cDro/gj8xCsL/I3hwMcyZ6C9PhJ58EEFWGb4bvOMbZ8LU3LFo+CUJHkHmqiAviQ3Uhy1fYpOysNVsDOehE7BsBha0pQjr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:52:07PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:

> > diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> > index b9c453c28795..289d7b08ace4 100644
> > --- a/mm/migrate_device.c
> > +++ b/mm/migrate_device.c

> >  int migrate_vma_setup(struct migrate_vma *args)
> >  {
> > +	const struct vm_area_struct *vma = args->vma;
> >  	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
> >
> >  	args->start &= PAGE_MASK;
> >  	args->end &= PAGE_MASK;
> > -	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
> > -	    vma_is_dax(args->vma))
> > +	if (!vma)
> > +		return -EINVAL;
> > +	if (!vma_is_mm_managed(vma) || vma_is_fixed_mapping(vma) ||
> > +	    vma_is_dax(vma))
>
> Same here, with the droppable thing changed this would be
>
> !vma_is_mm_backed() || vma_is_dax(vma)
>
> I guess.

I think we need a hugetlb carveout too (ugh), will update in v6!

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

--
Cheers, Lorenzo

