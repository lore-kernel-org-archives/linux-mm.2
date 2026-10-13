Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C372BCC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D64266B00DC; Tue, 13 Oct 2026 11:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14976B00DD; Tue, 13 Oct 2026 11:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5316B00DE; Tue, 13 Oct 2026 11:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9126B00DC
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:21:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42ECFC0C64
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:21:34 +0000 (UTC)
X-FDA: 85317967308.28.55C6375
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 682CB1C0005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:21:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZmjX9hWM;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKOaG+rLb+TBC93/wA8h84IU3QchcmQjx8R24EXbMf8=;
	b=YsjqP+H3Y+pWZ3Da5AtnRJMEt/eD4WStkWe+UV7U/ygOwHY8RBct0xCWfHmShniMzQc3bn
	hrsnJ+Fv4VNtdm0CEdBU8vFob16b996nKbD5SgbJctHPx3keKuVH18s+56dM/ERTfq4Mmw
	1BlZ7npdRcew2F8OP/Zlr8olr85QGuM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904892;
	b=F/ENM+Ddz/JQq6P7rKU3H2zNRddnCbwtxwnHcLqBZExDj6UQF2F3eJWHbRpcqCnFqVgcQ9
	vXkBa0He8fsYiI05gIdrygnJIb1/KLcBsKhpdGfhK0j4/iI8oXM2ZePPAL4CkirzSB+Tm1
	HdlbCVflHENnZ8D1F615JvxCGhExfhg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZmjX9hWM;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B140340970;
	Tue, 13 Oct 2026 15:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230311F00898;
	Tue, 13 Oct 2026 15:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904891;
	bh=bKOaG+rLb+TBC93/wA8h84IU3QchcmQjx8R24EXbMf8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZmjX9hWM3mqYoylN5qNqzuLQrs/UMf52gDfj3HLvdUfRZ5JPTG14SKf7yew/ajhqU
	 fh6qU/HYNljRNmXuJpCOZIVaoMPSgd+6+Qsf1HeifgY6eg4irBODX1QcqTC2lUo5Ay
	 PCNd88c5UprWqe5Rp2Iw87eXG+meJ/N4b6oP+GIcUQ30wJrX3XXBXgW+QFSdSnY+lw
	 nmVv/tS9bypdbUbId6+Ccz4h+qvlHHdcLwfQ/eS3DQ1qJQfNMcX8ct+lf3jzM16Ycw
	 s7YODkJzz09QjIdkx81pRDHwn1eEC+QsjBowtRAVl7YPXABnd/j59sy4fS/Iw/C6NS
	 JkitQhSDNQ/aA==
Message-ID: <333e663c-4c4f-4d08-aceb-5a8e15b3f475@kernel.org>
Date: Tue, 13 Oct 2026 17:20:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/39] mm: assert mmap lock held, use new flags API in
 vm_insert_page[s]
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
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
 Bert Karwatzki <spasswolf@web.de>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-7-1aa3c9b139f9@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-7-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 682CB1C0005
X-Stat-Signature: gr5na789aaotcn8bmhkkddakzpzmqxjo
X-HE-Tag: 1791904892-763430
X-HE-Meta: U2FsdGVkX1/NZmISeK0BQpLAauqojlnTdFgzyFJZRoVOMPPLDsuE/LWiRrLn28PlyRGsa1Xl1Zu0UMwDiKLssiNaHE9rnrf/H4k7kbJfHt/F4OPTEM73t3oguHOF7BayiW0Mm45ZMuUDBf0buQ60rAm75830HXZkffIfcMe++BQwSNyiXqBTRWc08/oXnFQIAq+3WXAqvwMDN/MJDwn2j5gXZfkLl45x/dnuozcZhAeDeLgGW7rL1ScHrJENYz+cBIxXlE7MDMKFmT9X2jdxsCaYENFxSNnlb8Fzakt39dYyyRNgDgqtYEitCUJ4MnpmFKndO5u2Sah9zYWiC+j8g7+uwm2MnuH+01LXuz1y7dNO/Op6c7NVOHU/i8NoYqRiQ8Kqo8FFXEX86LqLdvSuiJpkxxB17clYpIEjecubE0BeiE4/tz3TVzPQQtaBPM2X72mlsSHIVSSjAQeg2hcLJAwk2qb9SaX85LwbkNokHiFmb2PbVvm5gwyMMLuhttvuN2WsM4p2ec8ofznwJg4iZ/IPUqHJNz2uLe+7EMcvVRymEdM8jaEw7nHZ/UVmyUPnGotIYIsLq3R+gesMqhBUCJOpUVw0LSN95ayI0VR/OkoR2UUWdTfyq2zznntyQ+dp7sCyBKLEzPx4AGL0GLPzySy/V0lnxkZil/Qx88iu+loFC+KOheNvhGZmT8w59pxzLG9rxd3T9CnoagzwJqYWqiUpeN7VKce6t3q5rDrqmYZ9kFdNsrNaSus289B0D7MWHAaarsy27kwiBi8HbfFmgJZRztSulZ90lCSbIY1ac1rUO+OovRJI90Ylw9t7TyB2FfKCCSgToWuj90+0F53sCTjVne2QuFJJl548FzZmjVKjNv6K+HhoQbjwVtlP3nIdWUL6jLwnDbdaKT5rAWHWnt4it4eL4JPElKwlFtmzpIk/9Bg+N8Z6+y17XPGjIc9k4xOUtvv9hcyrUwB2/2p
 KzVwrjTT
 qzNYjwrNr0P+Fq6g22ZIBhokpaLwmhHlFSKOw1A2F83VyjHDQPYoHSNHGz+n0eoPWUCGi9mqv55356Tn7eP54eRyQ77BLwye7E68ugqrN+RsAnQ9Nv4XXfsRzByKbeWvTCT2XlQW8M2Dr4DHH83ah8D2p90bBCfK0MEGX13/3voUmFEt1+XeZBjhIszogSFywL/6hzOLbTATRzjc9FpMNIT8DmfPz4BUcaastRbjYgdCA/P6RdP8p9gSBKwOZJ9ZvNje0YKY0E22AoKvIj9U1Eap9mqRHlmdrqeDK3he9fMjS0k2G/wPAB6HsbqTNqI8Y751xKPCZ57BFxLK0YM4YqbqUnVh378fXo3l9BSrKP6DAHOKvhNUJy0p3tYxMSMWGeLRmJvSj8oUpyFL2LFPrXRCIspZH6COjbAYbdITZ9DyVU8u4OrZqL+HWuyeX2nlDRuRY96aFR7iznjr53MIxJgP8tnFaVj6IarRK8PNKE3qeIHu2RbkFG5GgjOHmWB50Xxo3h1voPFMf6GuoNPBJ7N6gXtcts79ysCY9AePmEiZPaKU7UHTrAjYPw4Nt8ofDisN5L9b9qvibGIi++PR8VvlLlxw18YUnvinfMHH5QQk3miNBNgx0zfUzEAJNppTG+HRYqL7LwGP0gCfXMurQFZhkhkgbBxVg6cElmUxSAGpDCKwGRsJifzapsFTGDqtwoIb1VGhZGyKTHPnaKlpl+TSWAGtVPB0+5D+IPKE2UG5MrG7YNvc7cYCmg3NkH7gL91eKB4IpUSm+VhfxT5oo8C/OKq9TgYO4t4UcVOxnBQbS2Qd3h2JB+h49UB67klSNMe47sbo6G9JYJS37zk/l5WwRobKj3V40F7y83SFb3VKfcOERR97mrLoWd1agLfnEMVz9c9mDnF8NFur0a01A4ZNtoc8jsZ9Wd2hSRbXOZKfNo+gj9k0aYeJRxJLQTEd7N6/tEKzgaCfEWM2vLUdUopnlAxpf
 FRb2Xtl5
 VaOa+LrAG5O6bV83MyLnP1sZOZBXwXRvjoVzoo92N4/y06O4fmsQoWmAj0OB2CXfpAF+dhaVu8XG1fQvHmLn3hMZd58wOi4enVMVYU0vX4nNrwn/GQUZ762PjL0LaVawR1+jBmeifLDjoHa8iMxXnLMUyQBQKXmL45EokTCe6jMsaE7CWhshjcNVxjGu8DzjfbgoA+DAiDCaYgIVSHVX7aaHXp1FSZA5Q9pUI7NCzZo1pD9PsTQQ1CYRR30A9ltekYBBp05d6FtUiPXq3EYQYuCEEjTd/+tOlkm/90Nc244QZRKAL736SqWgTe4A+1CTcMp8sbWpTZEitX/C9nH1x9wPtTRgDg8yskUX1s7EzloDb9aiFqdbBiqFnkEQFPH+Xmhcm4r0dd0OS+pA/1zJnOXgBKLMp/i/C2z5elV3mrGqGhWoNtIsVbZMEnOdHqo+j7Ekce8kea5aiTEYMr0c9FOEcSPgBNYtXJG4bxZcHn1TTL8ejgaH/Hg/NPxsXQdriBJN2CzRi06QMrOGP5M7BiViKeJ9mBi20fpMoqN9L6IR25u3qEwh/L71Tma3cYbfS8dvFEhJ7vCtMfsuG0JSJc6TVq8iUmUgLOpFkyK4ua15BgxSJbc8o6Miq1JX9C19By4mEkKMCfW++CUFkptN8P6g3VrmY5DIYRSg0h9KBikPGbhdCjHt91wGE9zKXavacU4rZmaWqQsDC/q9w8EcBPJ8eyvnFS4VgzzvANEK6t/bUIt3p+T65+jrndpmrACQVkBNbWNNWDf/JX1ukpRjDTCBnC42GBGfbcci8fXeMGVYrUVfm0lwheS7Yi0UfunzVsqTKuPj9YbuIM6v/uFt0pFZYuiS93N+KZeE0Bl3w4SSyEx7jxYaIQ0FXOrsj6nyj6jChI6sQIDBdGat0UBNgTNLnvqib75HwXY3URWWRAeCBeDtRoH6r6x2SMXOzKQ7NOO1zmTJYZXRiQ4ToH++E5St3cRyL
 GbmlQqUt
 5rw6a+USEW85xmWHqQnc9j2oe8jjY8Yqjnfn0N7cxBz1oxiNFC4EFhIf+qwsvtSOehy+LA3nzfU1v24sUEpujInsCDWw34+vtMLWqI12JzBDKntzNA/4l4iarIMKUCEomXLKvGOFueyXJkEbukPVlpATQbS3krrFVYRSJySAGmvnYYbzSdeHA8IU5o60ZikZCp6nuETPA4SCHIPqXW8nwe1QxUce289pn/yeVPjr64RITmyI9SCKdneo3D93bNVK7oM1yIcJH1QmN7vr1n/FroyYIMa5yCfGcRvVK4+q0FGcabsOGFFU9FXlG4Px5UU57NoY7KmfvYyAD9MCWxxj635jrX2KN0BBD/2SXAUiKYog+b9falD30wwyHcItbpUCuFCSP6jDV690+94H2N0bxkd5+RLMsvBN8dcp02WjQ1zmJb79SPKFbtND0I5gJjmWNXDpkhyXqyxeOEUKVfYbkvcayBKA5+u6DX8zjT5teIDoYL6OtshBcP/I+X8Asvn2FQEupYCO7ReVumfk5fdIhBgzalurJ9+L/K5hF7xp+FUahKG/oSyJq3lI8/InYu1fYbq5LYRqfr0PR6aePlvKSrgsLtPIvk4vf0N2z4OLGJRJUl3jGNLOVwHCvwy/u2lVJ9LznFpcJOr8/13vKzwSEna19KqC8n+pyrdEMhyT/OPN58hGNYOTwW10ONimsb0CYVyihAHmu7Kxd0DltlNaTJh9Eszi9mwsLOCucSHULqNS9JYC5I6U3OMhEtll5O8mh8AJ8H1p4rQ1hGmXdQiGGRJz9nxzVgPXWuzRY2qfg/VZVdnPl/Fv7+kQy9m5xUR6vkaq7rBT8eqEFmEtiQG49Xgu+Wgg9odRamOwi1iDMDJkksIKElJ8D8PZXuefqxh2NLB2THzDCmLkawhPsFsDmYDSdk81pSevc6k+kdoNlEgSPcInsMqG0VWui6HR5hjUyMJQjW+MB+wBZOr2ZRhb8LOELKMWe
 IcmHDpKM
 Xh+Zj7KQQmn3kTTINIvGrbO9cdd0HazXfom/qkN23DUPembEUmmfsMEZR50RP4ot84Dv76aYnKlFzZrrz/jt9Oek7MtQe/sfWOgWVvISNlskgbFa7Q0s5pwErQkDLswCWoqJYImWtaDCb30vBIHkpL8n7weW5eSfjJH2Kh4VfKZD63Ya1lsVdfekfbKd+Aueli3yh1kDpLeUxxzoH6VGbqIoqSgRGCXcgnWYObF5c6POLRdRPpTivh1CHVw/Kh1qK3w0MxrvY+/4kw0Roo9KJHeGV1kw88sjY7dYc8aa4eRecaGBAq98glqCqgJWD7zDDtxlp5YiDi/Bf+T6JFC2zLc1oQmn/Bvw+h0JKJnm6z4KSi4UgGgMYk3OUAiHv0PP0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 17:04, Lorenzo Stoakes (ARM) wrote:
> The existing logic asserts that an mmap write lock is held, bizarrely, by
> asserting that an mmap_read_trylock() fails (which is not the same thing).
> 
> Assert the mmap write lock here and switch to using the new VMA flags API
> while here.
> 
> Note that the vma_start_write() is explicitly broken out from
> vm_flags_set() here in order to use vma_set_flags() safely.

Which is a lot clearer.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

