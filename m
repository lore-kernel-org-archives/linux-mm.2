Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AB01CC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181B86B00A7; Tue, 13 Oct 2026 11:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131B96B00A9; Tue, 13 Oct 2026 11:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14E66B00AA; Tue, 13 Oct 2026 11:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3F7E6B00A7
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:23:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49A5F80C9B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:23:27 +0000 (UTC)
X-FDA: 85317972054.10.58FDD8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5A34E4000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:23:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SI6nKVl2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905005;
	b=zeswvpgLaWyA9k+xQ4k6W0aVoTWC4jWDw32sv6lnYE3E8BOuQyNC3SV+jbOZ3bZRkyZRqr
	/VZPojVfcVXtw/jzWTbdJsAVks2mc0mOiHDGmM+BvFRBPskCCZ+GYNHvgaUdKSVzPmVJFJ
	DhAPR4uGi7/1Rav2OaHOFXejyKTGsMU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SI6nKVl2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7cT+sAoBoDYEP7l2gJz8zJ3nNAI7H4A6WsbIM/2PMHw=;
	b=Myi7Pywo7ywgtPZwo+uF2zciXo79wE8kJY1PLxHAofQ7FqoCBo6l8Ww5KJ2KkuawUSRyur
	CaIC4hizZZi3AIlIkLNT7ONzNOC3bC9TWD+FLQbOHYo5fBq9yRwK5hE9Cn6AEURmyEUe5T
	u6YghzJTGmKsP0qGQEIM+4s2HHy50mQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A58C04357C;
	Tue, 13 Oct 2026 15:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597701F000FF;
	Tue, 13 Oct 2026 15:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905004;
	bh=7cT+sAoBoDYEP7l2gJz8zJ3nNAI7H4A6WsbIM/2PMHw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SI6nKVl2y9xyjOw4xsAdCsG3OU+DC/viH2V7mID8rkM7Ru02HPw2WTFy+T8UY4pRV
	 LlKZ1VKOtRlx7uOgkhUWPl8p19KbialuIR13iV7LWW7aw/dAE/vCeshFlNJ0caySo7
	 khtBZ6WOjnPcwjqZjAFDDcSVbHWpJBwMUSJLP/LtT/JPicCIQOtWPhee8gYAmLB8wC
	 PN/yqx2AaiB27UAuKYlAqUz7dd1mDeM1ou7+sjX/fjDR2I3VqEOxykJoJJz4yN59Vs
	 Q/2JQqmKSOhK/XJHTOtJ6nfuFQxfOPwGNzyVIe14PCmyiXvaqU8zel5ObkXrA3enbv
	 ZA+3bvYIGlyyg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:13 +0100
Subject: [PATCH v6 33/39] mm/madvise: use predicates for madvise(...,
 MADV_DOFORK)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-33-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1489; i=ljs@kernel.org;
 h=from:subject:message-id; bh=gjthDvZqFXHZuZFdwHubOhomh77PBTrGmxDvpVKzPR0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZwJMGoxqvgw18zVxyA33e5ZfXDP3j0edZsuWW1qq
 36tX6TcUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIkwhDAy3ChrLqvbbFLydS/3
 tAv5E35Y8B8OZnzmZJ1j/HNrek/xK0aGX1c2JLHP/Gni/5vnpv3sG8ECfYuWPdDtSbu09EvcdY+
 3zAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: nhgdpnyg33fgyoxer9qp1bd87ig1ccy6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5A34E4000A
X-HE-Tag: 1791905005-705354
X-HE-Meta: U2FsdGVkX1+94MkWV81av3QN4nEy0QwmjXxjExhoa0A89Maincdz3rBxkMTlooJv8wXF+9ewuVuGqAH2Kh/0Z2GBHxRfphM/TxMiutDv+wAUJouIL7vJpjhrBFiQj49JX5kgH3EOEXY3SFrq6pgF2wAZAfOJzpLr4Bm80gG1n3ASRCo7l5TQhkuOkfFfdMKMKh0HurvbPsdmTW2DeDxz961lSeY0uQWDU6wdZ0Cvt0dlq2OlB0CZO0takwxRYA7qoE+fvsb1eTe4BcyCTCeLiYm4ybU12fXnGBIH/1cOhF1eijO95Y/QvJdR7PYD9q5WSy9dM6m5DyL8sn+1xQYdzzzIFWqHjFDDTlTRkNENKYFLM72Peb/gLzrjfTccJaW0cv315DeTMNYbB1VQvy/5kvz0Il6WE4tJbtJT2sStn/fE6UcA56nSzki7lNfBcGh1zWg9sDNsDWoJzYAI1alulTwions1koKijrA0Z2cXo3+EQRmAohwkFWourJ7gQKe85hyT9G5xLM+4fpHskqOes/JyYlVrdTHhIBSI+woSK1SVVl1oFquMmwnpAfn5nbAhMmbIdWu7IAZtm2gY0uBnCxYHowfOG+tUM37dXh6hX7fEj8YdEQYk9bbTF0T4Jp0KfOkweydyuYPnCZdYPkbxq/os6ZdBbXMxBkHDh498i7PdDZvDhgRGgyTXG27/7dt3HY4b0Fq1wEtsGQr8+eYa20DPddOV82H9iur9l9wVkKoKAogUqrtOqEXTxm0U5dj9koBFYfyPRVUgm3e3pw44u7QfFRPSZGvlf9jJMGzjHi+sQH/HZ6ZsgRjl5/3Q28feg70161Lws5J29VY7f74hGXAFtj8v0HZC69zwmBlM4s4wtGsCZQXtqb/dYESFqV8Fwqy9jjWU7y+fDj+ZeuRfQH/AsOBVDWUHf5A69G+M7JuVmQSMhB76g1g3e/cZLbtfrdVUXsRySplnDG+ujet
 GEqP8ao6
 5X6GLm3DFBrZbqoKAO+mEIGxyKH+KlByFWpcwDUQ/p3KWmdZa5yGjzm+AF7mvpKROLJcqyae1o3SAKGjYXxf5lZB/eBfKZlmQqmAbB/d0KMD0fRCEpLX5MHbX6nBvBVX+ZPQMOOjArK1lhotURj9VTnkgkAjvjQqxLDByuDzs8c9vD2P/qyNcK4U69KzXnnuwZqwxnaaoCh0uVVNz04wjT5adGgM4eyDHNCwKMVfG8i8nx4IURT9kC+ElRBiWPwW7G/5J09kAIoXJxdaXt41A1S5JQFPKvbkArx2jGFUFSCGNryr3ljvF0h3tMeuiCB0FXg+fdwxVB6/Gx6TnydsYmKlS0Gscw5Ng+KeHH7I4xiusoxdBkLVOud7MgDwDfwioufDFjET+tqpIrpm+PfnrFcRqHkqwjV28121K2fZl8rHQZtdj/FlokGoXq0oP1qIY0wnFvtLSG73JR5hV51mY3db6MbY6YcUQO9wI4K/TxdXyxYMYV0p1vT1y4ZPXT0VmehApldVfDJ2bAx85qno7gxweZfhfnR+MBDVyfijtNuvX3B/q74Xqn5qW4PfoErwdVX2AHpUBfySYdGJKFHnCn1kci9ILWczVTbCl1VebEw0WV1pP8kMr6I1IHEqxeb81VQ2jyaG+dQ21aUyd5vETmjl2a/dqMikorsZeqKjrn5KnymIEPYKegEnnyQO2rUU8w+F9Hri3c298ZZeQ1ca/B1jE7h+Bo25VBujm80hxhUzRW7eL3X57/6zxWHdKqoWsB8RdLMwlu0NolQLLb7KxwIfkZZRqFjR9KUbOibMiMmOBJyWov2Zh4RWNdTiGxUbKb/+1MyaTT+OltM7NnW5rQLdeqRwPU3cjCtTgKicKiNdv7LLjud96fjF+v3EQCCh8VB4dHguG2rDPMGJiXsVYZZ8dI5ayVLrX2EMNO08K6Ne4L5KcuC5uUCrTmKRPS40hlqKJUTyzQr0vztPVq2LjTg5WqCHO
 laMHHEo/
 virPG/zMLCp2mnwfa8qOILHCpJsyEmrPnUTQELyYJmXAqAezmdqs9/Uih2G3OtcdYLVJ6LpMqSuuoO+L+JdDrjVP3+mUsl40d37odW7EhJ3/2nW7lmXWnGRdua/VT1QXZUkavYKnapvX+KrHkIe4YEmMMMhijifV6DZewzmLQJn3B0bhp2+nTnXwGqG06qHZogCnQg195FxBMj1kIym66DVAq7UZJ7QJ/icqdxM5zOaDVPv4wJiKVX0KZokKT9xknMQmttJME78dovqSRZzw81KQqbgglX3cG3/7YwNcvV9o/cXUo8e4vQPLdanrkMJji8cc+YuJGqAIW49HBBSvVmmlTmBjPuPcFLrFuqwvb5Ax7M+Tj03QsF6VWEzc7bcrUVbIaIQU6JJtw5yNVidNRQQkt4JZSMyIaCObhN0Evi+k92/jqoldO6nILtZd+srSzbPJnr6zRMOaQCzEo3KQgippTKzT4SRr9VuKkoTD6j3JS6hlHOmAvmc6U3ecS/pLWwM3aLyDKFSS87/Yt+Fy4671Cczbw8ACa2JSMrpJvABz15/QRy1ncOa8fz8AZTvcZFkERG+DwsfX09A5CYSapoyckF8p6s3XxWr6sYOTQQ2oRSRMwsCsD2Pj8xmo5iJBFf4B7lMfLdfjdnnfFZY90dZLxuoqf1JFtqFCKlruAFf5rVfi1YEzWpoPB6pJ2nF8BU/W/ygZrOpe6zSYwGl2Q9EDGU7AL6Sb1EwlDOTArJ/HmukW3lvVkG5T3flXeRz/uFZDfGL2kw90lIEVVQuNkdYTVgpxQ8IqLBwkRR9ogO3R5RATuDqkkfNqWVN5VNBnZv87ReUZEmoo41vlnBlroiM6HnBwLE5xThGWzy8+vGAyhp/yR12JmrUiXLx+sQc3GAJvmm48gWJ+/8zH95M6KJ4m0C9EZLNl2sMSGens30LeFgm4kdYXch+zyTesfhtRkuT4o+LanrGB/I1ToV50BCmCXHuTO
 Ds2oaUhA
 XCQPyQ5i4CwXUYCo6sWydJANG6cdmPkJOoImyrmfZJDlcXQ0i9uogqs3A5SHHtkj/0jO5o9LCLqIbZmpgokiy4d3lTA+dkLejcjbWKoPY8W8xJanChTh8U1i5FlZIkXOXjAsiO64z54/PllBdFg73pdo2f3ONwYhOTf8v1/Aaor+P8wUNNeoijLFqWQs7XnMnbdrcy7R7lpR5Fa8bSjgGpet44BrV7+gINbHMsv8M1lzr6oPpjZPrV2LnIyEIZFm6xFZaMkOq8JtgH07N4pRhOH+y3/8ngNB5EDYuE/uD+NKuC05iULMaPry7MpN3fqvFzp4OVBg3ulbBEnZaQ4z1j0Y0sS4aaja99dzkHYo9w1YDjW2jjrbP8QTKRnqxoV2IHBb9JU0wZ5NzC7dIns5a2jA3QuGumsnbiKo2yT8aaigfQ4u13TTQwCf8Vaq1S/jxaIx0p/iKJbaqdmoq4cQUPWiZocvzNnWXwklLamQ3/GhBZvrM4aWN8zs/Du0eYzOqVGGxnQG4FAaiVAGBH6moRHRxk6koTuoBE2bpJOnXXGh8OjFuA2OR/6nVVGIVgVN2YnUydc6hsPlLUcnaDmLty9yUPeWGDVJzIxgv/dtP0WDecjSAoeYEYv1Wam5dq/Tb32DU5uwUlL74oQgMFmqyk50lGz0aGBBQc/yC08wUdyVd/UVW23/ieZMnVHXyCcz38TP03RyUiFtlBC4eRmNBTKbpelI9ZeijX1SzOFpUkWaROvGKm8/e9k9o2b9HqAT7eEyZl/QUKRPzjsQWRCA/bXqCLraGYwQL/9yZVvaAEtglqbA/njSg4loeIf+OhroUO6z/m8wIRQpHAKHmIGLyroZxs2zdS8fSLi7FK2q53oKJRFAIvcFu6s86DtT8e5NwoPJGuuHkG/4AAMsEcinFcataKYNspMkzruqe0JhcN6/RBLaCveNdRTEputsYGZRmYc5x2WDMch3kSLj/GWqGd9qMYjSp
 W/ObIY43
 lnrALsK9knuTUnDrndqfEh5hwcTERoyeFGdFFs0zdJAVtjWF7UzfzV1pJOS5E6j3CZUbRUbCDDSt4BvmEyrBPMSB4jAbVFMq5kDXcBcw75xX2JGEneOvd0eqA+P0JbcfPClhHW9jNA8C8APLOFRZXTNWC27g9/8Xt8HyATz2XQ/pigXk++BPtFLvdVWth6oDttOkqmiXrJWL6hCOwQRKDlYMYfX2mNpbpEzHK/cuegrhsgHrbiOlIEcIg97wtzlzeXwV7UOpeQWU0Vhslv77tWeh+M2oWVycVsxF4aK55lDcTBk/NiEy8RMhZcIOyzC2r0CPtHjYmuSyiXgaYet02/0HfigFoK3lUWRjKoSF8hVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make it clear what we're blocking in MADV_DOFORK. Previously we simply
disallowed VM_SPECIAL i.e. mappings not managed by core mm, fixed mappings
and VMA_IO_BIT.

Now the invariant is established that mm-managed mappings may not set
VMA_IO_BIT, the VMA_IO_BIT check is redundant.

The rest is equivalent to testing for a fixed or non-mm-managed mapping,
i.e. a mapping which is not mm-backed, or hugetlb, which is specifically
excluded.

This was established by commit 0b2758f48f22 ("Require (reasonably) normal
mappings for MADV_DOFORK") containing my hands-down favourite call out of
all time.

Express the same thing using the predicates - only mm-backed mappings may
have their copy-on-fork behaviour changed, retaining the eternal exception
to all rules, hugetlb.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 7e14b3fd92f6..e050a21e4db1 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1565,7 +1565,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		new_flags |= VM_DONTCOPY;
 		break;
 	case MADV_DOFORK:
-		if (new_flags & VM_SPECIAL)
+		if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTCOPY;
 		break;

-- 
2.55.0


