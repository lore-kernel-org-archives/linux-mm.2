Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39344C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 11:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D6026B008A; Thu, 17 Sep 2026 07:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386E66B0092; Thu, 17 Sep 2026 07:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24F346B0095; Thu, 17 Sep 2026 07:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E771C6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:40:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 762DFA0321
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:40:46 +0000 (UTC)
X-FDA: 85223062092.12.0F17652
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E21244000C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:40:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mDBBHK/I";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789645244;
	b=1AN6LV4H5JVMhkErYcPLialMO9TuqCBa0BUdOBw6IYHTX5nAzH8bCAnvcKtsK1LO7H4BV6
	0z0hGSxyquuWKvV1U8LUboYQyuL+XIm4MlSZXA8wzqdcs/3yJqlP1oVLreONstMEDtGuuM
	j1pijZ6T+IRzXbE11J3YB+fvbnHPhtk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mDBBHK/I";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789645244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BApzGHIqAjiErWcRlmmivBGBfFVBONt4ktRgWMUzDCk=;
	b=Vacp8CXGauteyKOuHmAm1csNSoPeU7Ix4Vz4HMZr3rrRU25tM4MvNM/zND66oeL9eKeABZ
	aZWvIpFnfExbCDFtAIPNWwskygBypsa5rs8bn5ghLFllcC3gG1i04N/682GKPTpBXP13fv
	+JKnod+TbZ9mcfpt7qqIWDBdYdmY+u8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E708D601EF;
	Thu, 17 Sep 2026 11:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09061F000FF;
	Thu, 17 Sep 2026 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789645243;
	bh=BApzGHIqAjiErWcRlmmivBGBfFVBONt4ktRgWMUzDCk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mDBBHK/IhHEPd17SZQYudlv622AFtJid39i0LAeTPe5KX2n4jjfEibNrHMdEGP/lt
	 eUgQ97JZr9jtSS+gOZV9ctH5mVpR5Wezp3sekSSbMJ5cOeo6kdk0KT15/6B49AIGEy
	 W3xTRN8TOmbFo/L3aM1LzCnmwuDCeyPl4is4tqU7CxU3Ioxbh6x+wbfLlNfNi4Nbut
	 a7/lNdUCvCwU4aCE2PFX04HuH+W5hEeEwQfpeBZl00atZiv1MQM4dBxsjASoERsnQh
	 U2zQOve9t2ri7i6jgJuS/I7mx5ZPVMsb+fxhyacjpxeRyQ3wCmjEdg7jvg80HHafvW
	 7dUndTZsEPJPw==
Date: Thu, 17 Sep 2026 12:40:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
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
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v2 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <aqvRKarObW1Zy-QD@gremlin>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-1-7d9781ed5361@kernel.org>
 <aquz9Z9JrK_H_E0g@kernel.org>
 <aqu5jtMV2gyZFrSe@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqu5jtMV2gyZFrSe@gremlin>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E21244000C
X-Rspam-User: 
X-Stat-Signature: pt4e6jmsgmy8kmyd83zbysganeareczo
X-HE-Tag: 1789645244-245639
X-HE-Meta: U2FsdGVkX1/Pb61wgUS07Jky5bLQsjFWka5i4fvJING8oEekbjre2mVj3l57KGFiiqucTMWTDuuMqsZ6conX2rkfGC+IaTwaZqdslGRXjc7YQDXwUmXdE7lFlLpbPLLyxVbN9OPck8SSSCnftQ1sI1wd6pW+JgbU98Z++vb3QX6RjUrpEayE/2l2hgGie5znt1CMBCApfw/HaVYPdWpxK0ZBYnLKrzMtLH+swMKi5ToV451jP1D1RQNraE70gPyDSZlPuWOIlAbkk7qdOu3o2jsS3WGJygclM2Rse47hD7jdbwLrQ9osYRboxs1/zlY8USI8wXevUk+uFbBIJuVyND/eNAiHlkjZDW31Mf+/nD9vm2dES5lKZZNVxJpaIn9SSbrX13M0aOTJmHpRzXM+LUfr6CvQq1eNd5fzFChT5nCrlyChy94lkiMZR6+mPTnhMYqa3k55NaT3anDF6oXiZ17+DSW8FEqJ6fsLVxLe2MGcu4IUyoxrgw8CFFYrbBnO1Y4JrOQKqHqwwmwxnkTE4FzKUH7OuQAJ3AFW+JNdtkoDy0hyHQSEO6jXDRLb7qfusxGuTFJ2YlCvulff7dxupNtVNmKH1CNPuMqPL5BtO4e5dJXwDJx/8D3K9rCYL6EFSXmQ8cq2qFBd1D1qn+fZV82fzqJiQk6JD2OnPnQawuxhwhCiqh0wYs+lBd63nqQausbs5vP7DD9i4p1goka/d9HShAwej/+vEQDxDZtU6nN7W4kCOb+u2eRs9mV4ONEV9q5aPgBReP8eBSaXIAHKoLuDeexChE8pyTsBKXKVosIJb/vOjMxzdRzBQOgv0LEE9mIZNDUP5brEEIEMMrDZ0k5+DAO3Ye39I53k8TaLkEYrLODqONGm/SERRfB8FgIcOf8tZTjLuYQAxFaAcEShlDHP463+R25NwITAq3eJiXfZ49wU29BdMl1d3HnXj9M0d7BADDhfrfHt4J1iH7w
 Iv9FoUSX
 QfJrbwIGKU025hQnam9U8BRdYwRYQrOrFqD6LJJpjPrKFLjqzb1yi+w+reaYmX2IyPnV0T+SHKwhstIWk5cM5KbjTHLiczJ0SFn+ts9ph4gl4jN3VOkHiR94ML+GvDRt+KpOZh7DeQcYLmgeazthPhDrodH7FAb1EsHaGDIdY6hQIQRNRj5v+iwLI7kuo/z3uY50ViIfDnzNzsfh0XjrfOg1pVaTn/BZ7cQspzEJ206dexiINiSzLKydqIOs2eQ4BXc+5PiVh5sFu/h6hS6EqNfA7d35O2ToEAyzOwq2JOZKD+DbnWv8juu9LGpkNHPrUD6TM5uGeyx1dcLr6BsicfO8cGeqvyBE287qPp8zCERbZL/odw3t4YqMhcCZpsiveL19diixsYITlUVH13h8KpC3FSmhHOKOBQHT+JAC4oOJtpgJf/x8LPOWUWaGG8szKQP/7m41Hla48qMhUsipCn2xUAf857o+sD6UYmTbctuU7J1TgROplyNIMyGkuO5lp6/h7YhZ/fTkqdywAtqUev3oWf+zbo99/oWbE/GOeMLmHvtlNPN4QkW7hGrzxwNe8rYOPAJ2WTIgolfPcDX+2tbp0wRJseyFwrBCK70SNa6EeXEv6lxV9PIHl3qmM3A9CGty+ARm4ir92YUqxoEPwfFGycRPVgSB8IKcL2BYZtDfoDXd5ZCkrEAm95rZrqHAteovOlcrdy4KGJkoah3zHz0voz70jdMNOE4tEKqCVZnS9tMhrJFOq0XL6tPfFnXaGzMqMHbLES7Y47HEwQWvw+lVR2fXQKx/RcCAxDqhoTwft2EBpIWjwM8mwIAUHA7gv30iQ97WiIn9BBZyM3Sjl/Z4kkDfSyJ6y6wk9H0taArTpKO5WTaAAZN5Fu/fXp0jIcmfCZd9bfwd2l8FQYC/WwJ/jxomQTdqmUCxBqqO7TunzeAVELlpKODroP6Tbt2IHaZbSf4uj22mf4MeAiGqiBHF4wJ7k
 +aEFmkEQ
 HKi0Na4hfD1NaXNOw2hZxIOudYJ+E/wU/xfgZ7h3+5U0gXvXxUvesSp/2I+jpsfxmR03UOLFwnArakcqF3PvO/JfTAv/xr3L5p0KYouVRe8nqGDd2XGvhqw0/zZlVA+fGYVscynnZX4TcHIo7w4v5Nl4gtfH8iDQCpUx694j6wQw39w8YI9ivMGmLa8K63oni8mfjvMCY7gLNd23wKY1b62EjxtzGBJT4pTKcEZBoqlph+KdAouXvo6mnMMlcqgXMqrHY1J7BhMVeCswIxpI/oC6LEIywTAzPJJc+qOeD6zyMgZGKcv2ue+SbaBgyo6CevGByTB61kjrd2DsjhrJZoHJSgG+kIO7GX8tJvEG++1c2CP4VKpRqhgV9FhGlJDAyk5YD5SQV4hXHnKI0xUMBf5N7yNdVMlusvwiQLmAYQ28Uaod1NMIlgMWJbFm+1VyfHz0QvaKdhMrOxh6QbI5l8N89w3cL45VfaRlARrKJpb7ps4Nsb6r2SvHdWpub8rgg5nJCacWPr5cT+wKJk4eFvgN3OiRdVPEx3hfpNr0QwBhXW/pKXyMv2qO7IWSQysS/mcN+WQ3tIxFKAIoCtL9irdmjG3Mw5GEj9/GhB12pTRT8WsSRcTgZ8S/u+47jjIL5q+xePxB1Lj5vGpvuOz1U4wYs6sK73j89XHzVysr6lhxMzGftz7EPlBc9YjrsXrejEwpyFGUI0LdcAm78lWci2DxwAT30n5tpPib9sgH9zPe43/Ib/O8q1MSfNeBXhrgwWI71pmLSzypxs2KewFX/FmyYxQZJUpenWMuftBuzws6RjqpVlV5/avlUQndtnNIwz5owbooH0xz39uTVeqd3epqka0f4X2jyjO8ebgbQ7ZpLcmeUKzV8fpBiC5WExelN7n4PNw9fGoR7xsuAK7l1x9oFSXYbj+uqxUljxq+mkekaoMYbwU7O1+mhDxtYlHEfqy8rWRFimG8sUmvFPNTH82hBJbka
 RjM09qli
 cm4aS1AUEfs7+gt/ZXhN9JXchPRABNp797th6FurfVvRADPtciR/wml5kct6rhB3EOE3t4HNiFcCX6G7Z2icY3wHDpiYf0od+qqpqk2Z7Y6lcEKH5LjuENkbx1gU8vzCf5uWNmKXbkhADoYiXmfAqgQxfeuWfa1IiIPKMaW7/gq5DRa+3fXyG89jhAhfKnPBF1+MWnYfxfKYS+Z5bhX8iNWZjsk78p8lBv3nCBatGQJCYuRRiRfJ2027E+MaJHT3dTIFxgDAbDeN6w7vGGhATsX6E6AvAE6SwT6o3cSS/VCJGpGgjSViPVpiPWQ0djtnTOem9SYMwB3kWn21W1OEOGuG8+ab7lcVnFb+ogc6lY1vCaYvK063ohWtdr3+L0NlYnezvUH14x+F8Jd/OxwjypYg07mm7b7P83zy+lrdWOoDiPjVuKNahSiGKuD820xexrwwbTrO9ZGssp67GwPmjq0bljVCJJdV7Gd1iZRO4nql5xB/Lq0WO2Amr1rj4/WAfy/oYn91TnVkJ6a4aykPQWp5HFQHKYgqq44YVk9my6/SoJp8YvpIVdCckKRx6b4+2A/ebUmh8hbxEEEwQxXhASA1a1Jf49ySyT5BUehD8wjLFosVlFDsYJmsUIGnWqhYoTKepKhI1p3/NnTswiahwgD/2wg4ARFIMT9PB3jfoGVTMTPBWkzsvsI14rdgkDYt7wzJqdztqgdMYBIyFDHWYrZRLjTI8twIegwYMrJ+z3ctC951ZL2JNOQ8X+NlGmWPmR7237qbsAGZhtZp9AdAC/4whwjwPgJhuNLYWSlXgpcgPcztzc0iiJq6X2HW4D8dRGmR99Rea7GCW1hI1kdvSUcespcPOcW0Zh7oEE6/pcNEMhz8o4OEy4cyXlCzaQM9E0wQK5/WJlTD4L2gGlHLqKZIdxS6G5xlhwW4Yvqn2TxhpTHa7dbg5nYXCsAh9ahhR+DSgAf5BOewblA7qJPxDq96PBq1Z
 PO7DfK/W
 5ZAksfuwej0DGK3wWb8c5YlQADVf5EU+PEtRX6LwJapgoH9qk1ztZ2KtaFqwspZILaOklEBLyDOVfe2GGJtQvQJO7TpDC6eQmUuFKOQPXD+7WGFSSg/gvUgoZmRuiCu0r4J5k8Eo+qx6dj+TukePzIdGObiu1moAUcm41TuWMr2KOI0vpUoWUrU/rau2fAPLACkLJCjLkzZNQmXZoCtgn0L8hGRBFjVeJV0CIqIxwIDC/IWI6qFcVNKWMWWLcWtgBsXzBXIM1YC6yI1DZ1F72Z6Vsgmlu8XLHBELirWrGk1hBs3f+JM7BHtmp6nJ6bEX21p0ig2Xm68JY4tg0amprP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 10:57:57AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 17, 2026 at 12:33:41PM +0300, Mike Rapoport wrote:
> > But the patch iteslf needs to be fixed :)
> >
> > It seems to be the change that broke the CI.
> >
> > The rest is from LLM, take it with a grain of salt :)
>
> Ack will assess + respin

Apologies to everybody's inbox but this will need a respin to resolve a conflict
in a subsequent commit.

This was to fix a sashiko report (not a bug anywhere in production, but could
lead to bugs in future by accident), and got sashiko + [another AI]-reviewed
before sending all of which missed it :)) the robot overloads are not quite in
charge yet ;)

Fix is simple - update flags at the right time. The error was pre-empting
setting everything rather than just map->vm_file.

Will look through other sashiko stuff then respin a bit later.

--
Cheers, Lorenzo

