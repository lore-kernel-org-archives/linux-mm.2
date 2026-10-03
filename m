Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF3ECA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B149D6B00A6; Sat,  3 Oct 2026 12:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE756B00A7; Sat,  3 Oct 2026 12:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987156B00A9; Sat,  3 Oct 2026 12:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5B36B00A6
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:36:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F419A809A3
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:36:41 +0000 (UTC)
X-FDA: 85281868602.26.20C6D03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2E3FD100007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:36:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Aj8Ybeh6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10L90PzOXSgbgk2Yp7RVeipj6WjV7mej+Ed4jbhmuXc=;
	b=F6d52ZlMImsusWda1N8VA5YNB6gaBfXx1vPopzATMTeVTnOaXWDK0FbDaiSGr3a33JaYH6
	rHxms//9JCKrMTZ73UWND3nPe68VSRHbXuOmEK8ljZ8brlD1+Vt3VrDOTVFQr/dqgDMasQ
	zEV4RhNTP+2gab1sKyicxiWV3/Bt5iw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Aj8Ybeh6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045400;
	b=1ZY8PZbpn/12iYTG5ytwZvEBwMVO9Uf/Kfrz2LxxP32u46rqQ/y+7esu1LzuJqj96FJVQQ
	tbkIm0RfDvu3CtCzoO48F6oPHgYSUSL9u4qtc136tUfebAaA9wN13wJ6f1KuPMKlWazuty
	TC8kz4SIPpBfdZzYnr7UjRkJnZCp4PE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 47E2542AD7;
	Sat,  3 Oct 2026 16:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3611F0089B;
	Sat,  3 Oct 2026 16:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045399;
	bh=10L90PzOXSgbgk2Yp7RVeipj6WjV7mej+Ed4jbhmuXc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Aj8Ybeh6rI2doXcYjT0T7kY2K6Srii3A5oIvSeihwDj6WcMnt1beE92MYlrPzwVlw
	 HAFop0F2xd/1j+8Rzk6FPMI+K6R/FNckjJBgfdIGjHjBC8ZssUL2DngSQk7IAx+Tof
	 WA+/zdLBIpaaa4vJC3Z1Bi+TmKBKwBTGUWmISNdnrPskDKtvgZU6EHOl2/Av0iwkMn
	 ZDPAtyqRFED/YBdVDzfFa3S6GgeYlLEkRijRoB0W9LhxGG/uFd531adS6scZD0e96m
	 rnbnHH/2YyCXUQZhyrxpqddYkdMs2YwecscSH/J8oBRm0eTmoAeqBh8D62qt6oZDBK
	 0htqBpxpPiA/w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:41 +0100
Subject: [PATCH v4 10/38] infiniband: update hfi1 to use
 remap_vmalloc_range()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-10-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=10306; i=ljs@kernel.org;
 h=from:subject:message-id; bh=t2zMqz7GwrO9LwCoKVbfTLpQhoUUcOpzKx1NKvIhX3o=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6qnzX5o6LXz+/dmFgWmm3oksuyab81fe3CGnuYc/f
 c2sNE+LjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEyE05Dhv6ei6LW+K4ZrXS6o
 zJRZ0bCnSOiVtefPxUf/WBTlXRWyCWX4X2v37H9WUUTGfU/7H2dYLestLeq/3dDr9l+18953/g4
 jHgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: bhfki44umqt9q5prqa1dpn4zk7ik5tke
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2E3FD100007
X-HE-Tag: 1791045400-93285
X-HE-Meta: U2FsdGVkX1/E6Xx0xn3IIimKtSb+yd6YkZRbQAqjXFFYtbakMQZvqT00xnL62cqU7sZszuBDQ//vH5/ghuWmQlsqNBGWrBnptIW/nlhLvjmXHER7A20SUrwbEUfTjIet6JiQ88gFGtTqz+NJ3t+JdzAOaHi5AqmBNFeqfN3yxnF3BZ7vrWwRnsfA+QrzNtoJjaHeh89WMPRTy6hzlLVr52qrwJVD46jrkkOu0lmI61jz0Boyoi63wQs2DMlErnumQ8RL3edmCZX3DIA2ICG81EaVrIbgdhb608DMMcnbcD4OPyNKCwh8OUQOZ9+cQyAkgKo9lmslwQrVdifpAcZkUbTTqdJUPosvnMFeqvCMDiWeDYdnAuyOI3ocKWUZpif0CNql509o+8odq6hRV8EL2BR8pi6hF6wANd4zIhEaObVHMIbr/C7Qs/fKQvFyh61npGatOoiR5Qo3qtT603HZEdkKIdy5a6WkEdCXwM0DndXZqvA93/bUarchHOFWs9xS9ZVxdDMJzFfXur5JIA8pIRabRHU4nT9kS31NtsLE09ROveMFq3FBYJ6RHiC4SLk4cfzFK/xjN+K3hmCvL5LaafXE9qokuEcpnAJOjU2FUlhQNdvuQ5srGrw9cx8oud1DIayERDPR0vAcvkH2niLnldebEspsm1fmPYifho2Ve1aAdEkY0zFvpzs6d+lqKmLhiX7kRhuYuT+gqSFxl3OHkB+YsrYleCbco1JUo+0qhmOpBOKdhIdOa+dbW6MuoOTP/Bxr5zqsHvxxnkOpM3iLQwp2Y1Gimu0XenQbql0eQ1m6H002wYIr8FgisfUH0OhgDDsO3qDGI6acaT0Q4CmRGMHOJNoHO5r+iBAkVwew2uyvrohGrr4zjGA341XFWlkV4E8dWyBOU41Q5Ty8m5l6qKP7HD1T/MZu1NrQ6PsN7HotXLngQ29Dca0u8yUvz3VoUyjxUZhdGgTbkvIWwKm
 1si3GCns
 eRo3E5A1vpUX88Onbrb5jhXXxO24FhGqiHGv6T1tFWvk5G5xyMWWvlSgcqXhgvflszNpDgOx2jAQDWURtDh9gH5QP5Arh4EDhFV8TfYLJnSBYdbG/qakLOfUzowvalleynicPT0fAsbGbI2hGbxXN2AVz7CBrRembEX59sFcQNMVKQ/TAzChtslKjuR70O5DyGMXSSFJtVDvlAaXxLlOPQSF/6ga3IdDuOeCAFedmC8UXCGfh8Zsit/cYnmleqN1P16vFRmzUD4Ky/NAePWvj/txOKnu+ZchyJxXxcyVF89yFtkj1RoHXIPQ9l83NQrIIeDz1BKeaFj5qD33amfyQ11lNRQ8spvKBJgdHJjXfs1XpzbNerr50FyDhBOcE4HhPW/nq5WjNV1wi2uoKS3sjVvVx+KNH5jJj8bCRTDmqH4sqHBfNAvxyYkdaPINvpHb2La5q6UtOqwaxZw0MN2TT2OJTR5YGYi1oQlJPon75TJuQTCzfGh1btVe3KIHpma2Oe+/1lcdjf54RdDhml4wKEe6L6gP5NA3TpiZM5zwH/KLV8jwV25xHMbKXUEoW7hU/GqMmuufoW0zBfEixBvCg9PRv7pP7bOPEbBd+Qj2x9IsPHPSADHU4S1YxW455eLB6kcxIIr3zOg32qRPspsf6x5ydvuaAqnG9S+ZoZxaAUKG2Br2Fi38kuyFMq1hvdA9Vd63SSPgB8Q7OHfX0jm+dt7H6DbvDx/zw54gnwdnmtaZKVDRF6+C3hn8hJZlMqAwGZdRaL1u1NwXMpbS24nvIgt0ljPZxmveQK6so3YJYXTpeJChDrVPfnzkEi106KeB4r/wOd0aYPT4OS8sWAqlRRxMj7omq89jZXEGkPZAmew3dZGvJf9b5H40In1cbmGgjsM8SnBzie/VzQ84Kw3pFOnyF6ELZKNMKBJjN0mrnOuI30ZGxRf8dsmheAi5RwC78IpxD8M4Bcjw2/5kRKvF/uZpEPIvJ
 PjrxWO5A
 9ziLf4TRbDBCDUV2gHWJFfnhMgHraRfpY0xXVa7wfe2QnR3ZEB5WurKlzBGQwFSRGR2VVQStY+uDmYSi7AuvFyEpbmsodsWgvehY91eezjiScL6e8sG41LXOEp6T6JgVaCmYBi1zn8UN4xG2hs2SzAZlI4kEf1RpMoJxA8HMIJqCd9BhXD+YelWwdHp3sdc7FwfRfCA+AP7/QSEthnwyQLXdxeWN4RQrQpnujwGNVx26J2WzuzwJ4DQBmMY7ipFaD5L1pulzU2IW91/lGPv/T6kwOBsZUvfNwDA+w42e/0OSZCg63U9ItnfU+YKqkEuDvjttfdyBtiD09MTHZjP2k0JEcX6fUO0tSKjYMJfA6hiLQxkoaM+w5nuxDmYzE1o3I61HNavEN3x+F3ielmHTo/gYvZuaxkGOmMqWQ4xlltowm0x7FBG9WuQGBxsUTNuJScfN39elJuRLLDpMAG51WOAyihUtougUyi0bYKWJpHim4mez576F0G+6oM3JSMcLhbCKBtrffhRfeV5nAaZbSWJHvyJs9mVgC30chTbZmLX7oLRff7xBDyOqHEjPx9ABAYfG99Wvv0IN1mqAzOg101X9b1tJn6Vu9105BP+82VcD4z9pi0wJ+SZdoj54sz+5sNThnM2w0M6spbmlT/BMntw6nNpQrFGjflvq172a2Os4koNJ3RazDZwvi6zaOFlTKZ0AEWmmtM6eIxDyEOis+yHAeub1WgylBrH64KaFwg+tMh54wb0I5azXMna2wEN/+EZ+UwNnXA50Q/LIEMDiF+A9DIoVmRnF0gDHOdaLsPC2lT1Zt1a0H1bHKU5rDcPAAFlvGcpe1FJhHvytUlCfUf/B4A5Gx+E9UoPMtA+/Z6ucvpYPJcQNym6Lt8krTvbJo9YCdXzEylJTOBxdRlxWQy2rMDeXi/c3Fj76MbHpW2KK0Fh5qkn+v+M6P8M3yR5102/UszeUi5Qul8z0lXRPWDI5utCVO
 ATPp4WHW
 JqhDJWgzhMbvlYCRR1TZ3fgvmrgm3ybQlX2ELdhLS7fH1P4vGY1UbzC6EtF6RTjtkoPItpyP/TnkHgqKQ+Dp57KF0x7zr9qsfOh8HN9a7Xktys6MkOzDyqDFzeOd+g5GA8Sz2J6etF5nO0m6OtHkKbE8EqHDOuFiXf897sg3+E2zOLrepXzPgwxjY1GCFnkd/pZ4cim3HZBT+8HcgnIaolWHqV9Ksk53Aa5soyfnBz04zQJ9E2joKZO6AH1voi6qOKEAMQRVTdB2hFGbllyiL7YxMArc3ztsZIX9/5MZGiBiPBcqQPlz9UIUuYeI+6mJa+eoqpv0Oc1L1dvv4qnmWIYkc521iU+V8STHfrgfYx15bw4H5AsV3xEn/qybphDhNh7XEYaOpZ5jYGjhkFWjq30NJZCom+SHu8xPyNDTspXf5MypazHZHHTIJJmaS/R6AksmzibVQq4w0skDoFH/Kf94Aomlm7XCZ13twTdjIv4ICqS/Tghp8GOqyhkeAiWiKO7PReBLC8rxOPURI1Zsoj8izprgu4ZC7jJxa6Mf0Oq32ZboB3tCyOEIKO/9XIuPiZsgJj2br/mUGPMT0roNCvl1m72PgeYk7XptZxoqykT657fP4aJMY6wOKihOUiT4iPiRAuikOs67uF6U/hipJlhGBaz9jFnpbM9ZQJs35wM0TXS2tnu4u/nS71WaOP8hnJ78BAga0i3aiH3ugmYbEHgfeaJDPysdVQii8eb+9Xjgzu4ojtErmKT05OpwrpA8sP1jn/rS9U1t1CSVQKxWAC/Ar251b9fuxnAI3sWn+kdvRSZezISQYVPUO2JyRQ0f2S8tM2XymVVhW+kMp0ZHrrqhhpp99brkcWbn+GElfsaPRjucTK9ffjpixRZZcbAIz3lBVYYFloOBAR69MTHqYPXQfvdOYzfr9V9ogL1dK4wt5QyPlE323BjSCiJaG0fk8tZBFJBi5fyEmPfZZy8jtjpAfNv7L
 tIDiGWgy
 +73Wec29hs+I+lkpeP+l9GTUNg+JBlGOIDpegNXv/J1TWfLYQawYNcLoZeKZ/+8snYKMUpFsgZvF+F01zRIEngOso9xT3NsSxWekkvvBNEguMgUSQqiw5oi2B2jNVX5NuK75WENTi621587WEyS7wx6JdFfiLAraxUSvaK+i1zwYIICm+kmpXD23Pchpuna59L5jKj3k7NLopwml2Nxj+0v3vj/PU0fMk5xPj9iTSFGwq6/GHexIafhUmAiaDfj1vUUsEMzPy0wAl5xsdO+ZcyrSFeo/iHTcJvPwitQ4yj6/s3xH0pUHdd17bkFxnkUJSRMx3bIahLo+xsVSjkh+XG
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
which sets only VM_MIXEDMAP. The RCV_HDRQ, RCV_EGRBUF and RTAIL commands
also map via dma_mmap_coherent() and never set VM_DONTEXPAND, so set it for
them for the same reason.

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
 drivers/infiniband/hw/hfi1/file_ops.c | 83 +++++++++++------------------------
 1 file changed, 25 insertions(+), 58 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index dc548e6802e2..b02d1f1dbb27 100644
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
@@ -401,6 +396,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		memlen = rcvhdrq_size(uctxt);
 		memvirt = uctxt->rcvhdrq;
 		memdma = uctxt->rcvhdrq_dma;
+		flags |= VM_DONTEXPAND;
 		break;
 	case RCV_EGRBUF: {
 		unsigned long vm_start_save;
@@ -422,7 +418,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			ret = -EPERM;
 			goto done;
 		}
-		vm_flags_clear(vma, VM_MAYWRITE);
+		vm_flags_mod(vma, VM_DONTEXPAND, VM_MAYWRITE);
 		/*
 		 * Mmap multiple separate allocations into a single vma.  From
 		 * here, dma_mmap_coherent() calls dma_direct_mmap(), which
@@ -438,7 +434,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			memvirt = uctxt->egrbufs.buffers[i].addr;
 			memdma = uctxt->egrbufs.buffers[i].dma;
 			vma->vm_end += memlen;
-			mmap_cdbg(ctxt, subctxt, type, mapio, vmf, memaddr,
+			mmap_cdbg(ctxt, subctxt, type, mapio, is_vmalloc, memaddr,
 				  memvirt, memdma, memlen, vma);
 			ret = dma_mmap_coherent(&dd->pcidev->dev, vma,
 						memvirt, memdma, memlen);
@@ -467,7 +463,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * user registers.
 		 */
 		memlen = PAGE_SIZE;
-		flags |= VM_DONTCOPY | VM_DONTEXPAND;
+		flags |= VM_DONTCOPY;
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 		mapio = 1;
 		break;
@@ -476,15 +472,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
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
@@ -493,7 +484,6 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		}
 		memaddr = kvirt_to_phys((void *)dd->status);
 		memlen = PAGE_SIZE;
-		flags |= VM_IO | VM_DONTEXPAND;
 		break;
 	case RTAIL:
 		if (!HFI1_CAP_IS_USET(DMA_RTAIL)) {
@@ -512,25 +502,23 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		memvirt = (void *)hfi1_rcvhdrtail_kvaddr(uctxt);
 		memdma = uctxt->rcvhdrqtailaddr_dma;
 		flags &= ~VM_MAYWRITE;
+		flags |= VM_DONTEXPAND;
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
@@ -539,10 +527,9 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
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
@@ -559,12 +546,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
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
@@ -588,24 +573,6 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
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


