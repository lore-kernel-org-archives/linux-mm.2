Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337DFC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498566B00CE; Mon, 14 Sep 2026 11:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448D56B00CF; Mon, 14 Sep 2026 11:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313B66B00D0; Mon, 14 Sep 2026 11:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 020BD6B00CE
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:10:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94C081A0163
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:10:33 +0000 (UTC)
X-FDA: 85212704346.17.268348E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AD5321C0009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:10:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EC3hWABU;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysDxNe9p0/WTN7xWlWhpkS5/GM4BhQBCxlnaA2mG7QA=;
	b=Dfls14SnBSBBG8fyEnU2aWgQT41nfpWLMx/sbrlWc50hN+p9rs7hjVNjPFgOGY+5D+eUOY
	7bWTfwur93egz5OKK5XLbnjR/flg7jGBF9NJxDjSOqM6KHzikpqFqtCyILRzvLWKi/LGql
	Uen6/gtbhDX0qu6zLSMpfSkYJXH8Osw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EC3hWABU;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398631;
	b=DfKA4jqI9blBrCptRRi4p0NQB+DhcD4DpRNUe4Blb+TNuci0C9X0i0YWT75ovFdMkY0sff
	k+7BmTSH6wKmg4/4YkVs5UNdCe2JGs/gqYQiDMtZq8lq7Y032m6b/x3BVaBx7bf9NbZBdB
	Rv+zIiFDkLimrpNuEQMmr27kVXt3Kuw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01239418F6;
	Mon, 14 Sep 2026 15:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE2A1F000FF;
	Mon, 14 Sep 2026 15:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398630;
	bh=ysDxNe9p0/WTN7xWlWhpkS5/GM4BhQBCxlnaA2mG7QA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EC3hWABUfzlAOdNPy8LeNqD4nWhs3ijaF/mRxRs2ZDJT63mExVN9JZVr/EbHw+vyB
	 ZpAzd6VT3VoOw5xvJInfqk71FOF97WLP3d950mZtPjuoV07CpesE0g6rRYqjYNppa/
	 WSYalyz7QeBc+sdcCRgQdPgin1H7vBrAO86B3RYdFvtEMIALKxxTWzFinotrsI7WWZ
	 BfvdZDS4JqWZKrMElvDsjboqQNLlrerceLrkeqpYav9+swU4Ktfoo8EhroY1quIOO8
	 lXa+OSPTY7BtrqNnOGVgvXUlx2HrBu9Mgi4PvEtj16OaihwnyWnnCU2PDrMCVqvaVl
	 NscfwukEXyeHQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:44 +0100
Subject: [PATCH v2 24/40] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-24-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7394; i=ljs@kernel.org;
 h=from:subject:message-id; bh=LWjLvXpzP5ioA18RZMNyCTmiGfPWwU026RHbvaGfA8Y=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG8Mnrrm+Jy+T2u39jfx9LFnFRp3c5i9Yr0/x61Bl
 L3t2cvXHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiI0wlGhhu8Sh8vO6Sc/cye
 bBozJ3SV7bSHn0xXmT9/uv3mVf6j9VmMDBf96i3mckoYn3hx3qJIeyfPdbYjhaqrpYWyzWceTnA
 LYAIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AD5321C0009
X-Stat-Signature: kydos97ribb196ukieyapktqqhw8e7nf
X-Rspam-User: 
X-HE-Tag: 1789398631-458752
X-HE-Meta: U2FsdGVkX1/9HPhtqS44qm9NpkQ09lJb0mSPdKHltOrZ4rGgwcJqtPh/nC5VTauTBnLKOsSgfk8Cyi+8tvD4awov4AbsErSJUW/u02UGEtK1UmxYqXb4OXLkLht0KpIKE+6s30rarfJcSaUWHk78SSxw2ZVufY3g6g68sQ9Wnka+DnBATzolR0gnHizn7RMWwldZg2fkM/3gTwHl9WkvvKelKPzXtK83JUvjDCCNPMRKhkRnfZyTXqkjzFxg8cqRLRtsyi1f7zvsexoncCRexs7HGAcpW+XKwPBTIOUNVd6j3U2vEJkbdBk8MJqKnCjvD7ffHckrTU4PcCQxnyY+5YLCkMmkHtdMdKRxuemhTWUxgIRdSQoRbuFM6iCBZoJVT2YiR+DjdOuzpze0s4EmNpyauBSLv8cpKimIywrtiy86ut9sS3VVxd6ZMiEcIG70wIs+zvGOZdgKGytkxmkMF84+FJZNVLmOlzRppmrMGbg+oRtVNBvbX+hyV3HwY6GI25uDkrV2EdXq7tfFFzRXjkgVcayqVrqtHU9Xz6yg1LzjuIa33GFUfgbjx4jF2NSvY/PmnrsMh2/8uVu4lpxRWoEoqgfmcInOd8dB03UeC5SQqsQs0aBmqeeSZHZ0QZk7WG+p0JLcboM8261e+4x3HC8T9nj/bl0jMG5MMgyvEDQ7CIwJ9HO+dYm/AltmbCc354dDUW3jJXpZJLb+IJNn1HeIJvoh1IsIFF3p5pGHau0cLXBbySkESW44n3ONSGyze0fL/MDWKX1rlwvH7NfIDuzMe8mKqsLQfKzRAP+tSVhyix53tdK/5j5H08pAtCsyarUs3JoiocEd7Yep0Eu/iB9iwBWwfufm7AnQb3DryLhEIZuwSoVLACXwCQZJZRUWGhDdHLr7mPtKIX3LnLZ15/+3/SRtJ5lzxbHZwRfEq2JYHjFnioGYiWECObMXEJXSa5hVSZSRROaOd1WBAlM
 ZzWpEBNd
 FxS5AfA4aCBms8li9pH9KmiWOl+HeYTzaSttY2Ny8knrupXme7nqeh9/TwXsS5K0Vtz//nCi01xunEwpPN9FKxiuGA2ZKA4dciCLcXc/Xuzr+sfztzO+z+X0ynJ2wJdIGyWJ+p1ZOiEkGYSHEwyZbrviFMHDXeh1PZlCx0kcJkqTReKmasxfFld4UB6JYkW+L+P5WzMmiPLft2gfXC2hJnH6cYpIyhgT2Zf3xgabwXj1z5ZTq9bW1fb3TaHmQtRbSeu9idiGlNmCCUyCqiypuNeO8+jRnAFJGjYMn2agKXF2zHmwiHiBTPl3s7WgvHNEXQtGRS0RoCpLpcDCTPZrm9OUiYXG3j6JWSAPd3l4I/cAI5axKb090O/TV8R2jPwZtDYUoXYJ0turoFjqvV07eX6kHkMv7YHE3STwipkomLo5b45x3UN8am7qPXJAJA0GUd0yxBaN0INiP+EstXn8p1zAjZxeuk0Ksc8aa05u7r7Ub97hbce6sEWXdJs0G/HzB5cFtcpiARgm6+BuY/gOezukai0uxLsTTa8jV8VIp8U/TmgARhof9AMgP4tdJZVxgGzDfm9uwx2uen6W5YXHTKW6RO9Dvq2XlbE7ab5zNBxjGYyqLvsygGqZEwODhNToVa1CgN88esZpJdQyeouGcNXa+oKnjHaML5r+Bp4KwIQNjpEPZevGkmMV0T6W764ZJGVD4YloqbsLsaGrsygnpSk7Gqe9xmJVUZbK+50QEWzGBOGlfz2zRsK9RzzRnhC5OA9/Dvno2Jc7cLX/PdtWAyEM+UmRPAoL42QSYjHTjbfoOQ6jN1FJYPeeQXZBTY0vYt/AXHUQnD8MS1r0nBCSPqCLou0BfQpj+RURfVxJFYQ41Z7edeFAfd5wGaBmoVpc/P8nHuYcJAASefVt/VWL2PPOtf5c4z8NsUhtP83HVMT4/bnpmFRrP5EIlEcsiXKjECp2uRnZK87Zw41WEi0Kd3CqT7ySi
 exQTW71t
 s+5h6aZpqm3Lm39MBDq+dv1CIjC4tqaN1QEhwZYp/a+dn/fTmy783id+Wixh2x6YRQXoyv5UpEluImnzAIV+QRHWpZ9pNlEQkXe7fA9x1IjDo4qVf6VA6gnb28uO4tXwDRIXlksrK6r/b6/9ot0N5pkqXTNhyUGFu7kjCzofWu3wfmfI6hnBM6SZedVDdo+W5TkVPSrUUeLgxLgVGVi85VLTBb4hY2Alq4UcqnbCRPcQ+cEZXoUxusPhBi3hfKomN2RePm9jaFySljRiBrxcImxXiY6PTjMZhqxiZh8DVkBLtwFvK7b3nyB+5ljkt1zELR2nIT9kTy+WYe4FSjuWyCPqj7lSma9MxIuxxLFofiqH8CFhZ9VQc09Fjwf2IJKpbaVhLWaE/peNO1Y/dZ+at3lRqQJ8gGRyg9QGccZq+mHxAOjSL4b8CT1slV5JtnkfFUPk85DkMpP18Y+AurKnapACGLc4mB4XEcWO6/f9gr+s8ZEoRalg0OCi+B3M3K6+0ewFMtLyqgMEOLFDrmbByXn/dudXDqyOeuVSv3GSRbBykSp3BaQcZPzpBNRd/sd7Ysm47CkREamZd/u9CoJFiI8Qin/pp5UtBQOEreeGyptCmkxHOjsZuabHzmXeaB3srh0KYBeTyXc5ZAREJQt16LChoDDwKZ2eJwfcJr9CrBgDjTFgIVNHqPoF3E/qI3TsCOLpZmMM3fShWvIZg74F5oD0CFgJyUveTFulVyUh5lBcU43UH/Zuvov+WYigtkYNHWAUE5M42ZTRZQLTwo7gYG6Qx3wPwzMbiPnUTVpEfhpCuxkjvZrgfFGbM0U7zMv3cd1FHK+mCZzVW90BmtXEQqh6VozC5p8JZq+A8+Nl8jarU84Cl2NbyPiShXb03yZ/uhYfOY7ypzMVh+HtcIGdEW1xS0nHEOBu9TfUpnRgmjvqcUrKFHjE6uCykJq/CfKxEvoVJZIgTf1O+IBULUoRRJTyngHOB
 OpKrku8g
 RzjccoaWBE8SD+wpv98//j4gZjbdFjjCTAumJQT/+D4S0VxEPJY+yVCQtXd15KzsZaMBwErOseaOeAkJdACM9gBtiVJ9VuqKeEmH/n3gruHEEbdzM9LkCJVrPZz/nDNw15cbF+jaEy/1/0aWoeKVyAVgaQsaB+mOQ0heljuChNcS4/qST9PxpHi6daBQRP8lnGAjaplxuBtacADc/yQfEV/wug94NanbY6zoKcNFJ5+1FTxEHGW1W/hNlG2+UP8EVd55OtSYQIUAc3valhFygM2xQlH46ExuWNQSZZH2WGznJmhVLKLO0J2CRLAyZdkfSeo3pIL4+dEp3bDv3l/tv04XB8huznnUoCudn+u6GvHremPS5xtOa2SUeN1d/LbRtXNmcBmCJveal8lrgumk9MQ9kwbFmQeCp+LLr6N1MCJcRVQO0OXYR6wLMZ971xp2/COG5lxio9RWcLCwP/Jfr9GRpXcdj6q+XFG334Kfwff8wcJFjsLEOTNsG9qyVolhvmHPLkPWuCgvZBG6AUz6H8YVV7ADU39dErybZT5fS7G107zVaej1UN3br7hOLT/jPfV15wDwZBW1rVl54aU+W4Z2kfnqWkU9irNkDnYSU5oCyWlmVCY7DtgYMkIyPU/Tvwfydr2/SHKEZfTmGK3EAQt4yFCH28wWEjGMQImMm9eoNF5TKr8iUzhPP/UJLhsPin+q+ycDDzcXcIG7x+lw0boedWiGfvVFoKp7OFyCVdttnflOtLSz04gBOXottpVc1ZvFC+8thNlEI5cyvVgur1jph4ulxntxBIYzOZFshUpoNVxYsDbC+wdCNr7oPnomRhIMepffIG4RQy9xp9bgOllHhGzSwJ4JeCYcJwwv/mHWRG0WCZWQ3twHoX9cz/XP1keciO4KFVs3kYhbllTTaoGrWZLTpJ9TWSz+lyWj1Rpa3pSUnQ5hWWhbQXQiL9NZCePhkwNhvZJYWgRM6758kymg1TUPQ
 qjyma/PV
 Gw8CJhe0rzGV6P0nPDI0kNXVoM5iZpgWELUX0JTZBL7tfEd10eLyCRodSQks/zz6fjSf/Qjuy8iBeBeoX6rOOVK0a9jf8VXg2zi1h9Z2UQbCBZjHvLf8LY9eJaQqMSGS9CmLFV/a4BRb4FDafssg8a3pxEnZCeSvHGMHhbowluq7R6o3LickcnOx5rfRiRcmOYM0+xUuT8BXB2yRVdKYyOqmd5DpIBaETM4rhhgw0nOOY7Z3wSJ40wcsflERZat76QjhaOmY0oGkbq9YJL4QrkBNkXHlRf6zSCiz5SqLzha/vXdJXW6/iFUjJED0Ex26RQZj28a7F7HdEeOOeORXgI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When performing mlock() or munlock() otherwise normal VMAs have VMA_IO_BIT
solely to fix a race with migration which might otherwise double-count
mlock VMAs.

This is unnecessary - at the point of applying folio mlock state, whether
setting or clearing PG_mlocked, we know whether or not we are locking.

Solve this in two ways - thread a boolean through the page table walk
indicating whether a lock or unlock is being performed, and run a locking
walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.

This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always implies
VMA_LOCKED_BIT. These are also always cleared together.

Then, update folio_add_lru_vma() and mlock_folio() to check only for
VMA_LOCKED_BIT, and update try_to_unmap_one() to check for VMA_LOCKED_MASK
instead.

Also remove the useless invocation of allow_mlock_munlock() which simply
returns true if unlocking and instead rename it to allow_mlock() and only
call it when locking.

Finally, with the other mlock abuse of VMA_IO_BIT addressed, update
mlock_vma_folio() and folio_add_lru_vma() to simply test for
VMA_LOCKED_BIT. munlock_vma_folio() tests VMA_LOCKED_MASK instead, as an
unmap racing with the locking walk must still munlock folios the walk has
already counted.

While here, also replace some deprecated VMA flag predicates.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/folio.c    |  2 +-
 mm/internal.h | 10 +++++++---
 mm/mlock.c    | 51 +++++++++++++++++++--------------------------------
 mm/rmap.c     |  4 +++-
 4 files changed, 30 insertions(+), 37 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 47a437e0f7fd..35e242b48870 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -505,7 +505,7 @@ void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma)
 {
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_new_folio(folio);
 	else
 		folio_add_lru(folio);
diff --git a/mm/internal.h b/mm/internal.h
index 9108b2b2cd03..59cfe336e468 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -969,8 +969,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/* The VM_IO check prevents migration from double-counting during mlock. */
-	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_folio(folio);
 }
 
@@ -987,7 +986,12 @@ static inline void munlock_vma_folio(struct folio *folio,
 	 * always munlock the folio and page reclaim will correct it
 	 * if it's wrong.
 	 */
-	if (unlikely(vma->vm_flags & VM_LOCKED))
+	/*
+	 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+	 * mlock_vma_pages_range(). An unmap racing with the walk must still
+	 * munlock folios the walk has already counted.
+	 */
+	if (unlikely(vma_test_any_mask(vma, VMA_LOCKED_MASK)))
 		munlock_folio(folio);
 }
 
diff --git a/mm/mlock.c b/mm/mlock.c
index 39215a3eab1f..4235a1518fc9 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -316,22 +316,10 @@ static inline unsigned int folio_mlock_step(struct folio *folio,
 	return folio_pte_batch(folio, pte, ptent, count);
 }
 
-static inline bool allow_mlock_munlock(struct folio *folio,
+static inline bool allow_mlock(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, unsigned int step)
 {
-	/*
-	 * For unlock, allow munlock large folio which is partially
-	 * mapped to VMA. As it's possible that large folio is
-	 * mlocked and VMA is split later.
-	 *
-	 * During memory pressure, such kind of large folio can
-	 * be split. And the pages are not in VM_LOCKed VMA
-	 * can be reclaimed.
-	 */
-	if (!vma_test(vma, VMA_LOCKED_BIT))
-		return true;
-
 	/* folio_within_range() cannot take KSM, but any small folio is OK */
 	if (!folio_test_large(folio))
 		return true;
@@ -352,6 +340,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 
 {
 	struct vm_area_struct *vma = walk->vma;
+	const bool lock = walk->private;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte;
 	pte_t ptent;
@@ -368,7 +357,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 		folio = pmd_folio(*pmd);
 		if (folio_is_zone_device(folio))
 			goto out;
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -390,10 +379,10 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 			continue;
 
 		step = folio_mlock_step(folio, pte, addr, end);
-		if (!allow_mlock_munlock(folio, vma, start, end, step))
+		if (lock && !allow_mlock(folio, vma, start, end, step))
 			goto next_entry;
 
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -428,31 +417,29 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 		.pmd_entry = mlock_pte_range,
 		.walk_lock = PGWALK_WRLOCK_VERIFY,
 	};
+	const bool lock = vma_flags_test(new_vma_flags, VMA_LOCKED_BIT);
+	vma_flags_t walk_flags = *new_vma_flags;
 
 	/*
-	 * There is a slight chance that concurrent page migration,
-	 * or page reclaim finding a page of this now-VMA_LOCKED_BIT vma,
-	 * will call mlock_vma_folio() and raise page's mlock_count:
-	 * double counting, leaving the page unevictable indefinitely.
-	 * Communicate this danger to mlock_vma_folio() with VMA_IO_BIT,
-	 * which is a VMA_SPECIAL_FLAGS flag not allowed on VMA_LOCKED_BIT vmas.
-	 * mmap_lock is held in write mode here, so this weird
-	 * combination should not be visible to other mmap_lock users;
-	 * but WRITE_ONCE so rmap walkers must see VMA_IO_BIT if VMA_LOCKED_BIT.
+	 * LOCKONFAULT without LOCKED never otherwise occurs: it marks a walk in
+	 * progress so that rmap-side callers, which test VMA_LOCKED_BIT, do not
+	 * count folios, while try_to_unmap_one(), which tests VMA_LOCKED_MASK,
+	 * still refuses to unmap them.
 	 */
-	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
-		vma_flags_set(new_vma_flags, VMA_IO_BIT);
+	if (lock) {
+		vma_flags_clear(&walk_flags, VMA_LOCKED_BIT);
+		vma_flags_set(&walk_flags, VMA_LOCKONFAULT_BIT);
+	}
+
 	vma_start_write(vma);
-	vma_flags_reset_once(vma, new_vma_flags);
+	vma_flags_reset_once(vma, &walk_flags);
 
 	lru_add_drain();
-	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
+	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);
 	lru_add_drain();
 
-	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
-		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
+	if (lock)
 		vma_flags_reset_once(vma, new_vma_flags);
-	}
 }
 
 /*
diff --git a/mm/rmap.c b/mm/rmap.c
index 5332c52909be..6661bc11ce65 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2239,9 +2239,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
+		 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+		 * mlock_vma_pages_range().
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
-		    (vma->vm_flags & VM_LOCKED)) {
+		    vma_test_any_mask(vma, VMA_LOCKED_MASK)) {
 			ptes++;
 
 			/*

-- 
2.55.0


