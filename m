Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0BACCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADBA46B0088; Mon, 12 Oct 2026 14:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B636B008A; Mon, 12 Oct 2026 14:17:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92C376B008C; Mon, 12 Oct 2026 14:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6126B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:17:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 051498136B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:17:33 +0000 (UTC)
X-FDA: 85314782028.12.78C6F54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2534214000E
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:17:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFU2oEAL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791829052;
	b=sZ9URXCIQmysvVCGlEQM8OAGw6ZlOAxWOUCqFduxox4Cpz7Gn/1ldpa++x2qvNMf2Any+a
	Pmj2nADWy1PcbOIMw3gMQhSrz/rKSKiz7RX4868dw9C4vYQIluTWalTCewDhhzFv+DS1bO
	z521L3lGt4Ny+3M8QZES79NtKLS6AEE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFU2oEAL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791829052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fIhKjnB303AJDSu1eIXXYJZgJIHaSHsA3CPWC2z5itQ=;
	b=PodNFbOJBE6+w/io6s85sc40LGi569TihAW4TgDYc9h0X/yg3hUFWH1UM2yIDcsHR3tV0p
	6Pf1owFYMbTUVUcqVlwXYNUaOBmhI7B6cl0oE9t4637anX5ffX6guBbCpTl+pgiAy8hkrc
	Nz8Wvyy+j03ZzyIoHvxL7Q4RjywFrX8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2548B41247;
	Mon, 12 Oct 2026 18:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6432F1F0089B;
	Mon, 12 Oct 2026 18:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791829051;
	bh=fIhKjnB303AJDSu1eIXXYJZgJIHaSHsA3CPWC2z5itQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MFU2oEALqe68FF6gv/IQ1ExN06JDurMLB/UDkcBzexCi23KlFERMznGkImuxgser+
	 B3C9Sm9ZtwuolFJUxsZfmbTsJuz4ZJioHuaunxnSBY2uvGQPLe3kae72P+SGHNwU7P
	 ZsNPdbP7A/yxv66dphePeYp7FmJtGOdqhuVSHN/uVwUd8ZRulltoNVHKVdd+biAqvE
	 PS9ihJvgx3ZYNKK8qanxlXfCLGI/cwbV9rdIPx0f6o/UHrjfT0kRU5bjgnlfFZs5CR
	 fmT+Lr9PAze01/3DWcVs4hBlWuWmp0XPyw+vQaWPShS4Sw9m0GmsvZtwllxIZRnUV8
	 5p2H6pPX4mfHQ==
Message-ID: <6f71b1b0-8988-4e19-9d4a-ce8a2de8fc63@kernel.org>
Date: Mon, 12 Oct 2026 20:16:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 21/38] uprobes: remove VM_IO, set VM_MIXEDMAP for
 mapped kernel pages
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
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-21-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-21-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: czzkxnqxxdqyrj5qbhfxu1kdxpf7pmu1
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2534214000E
X-HE-Tag: 1791829051-360035
X-HE-Meta: U2FsdGVkX1/+KWP1J1iZV739BoVKe4seIjW+FjZtPLrEgXyDJUA78J0CjN3QMchLvBHqFjIKSTaoAejRADVTOWK/ZJa7Si1yR0pHEnMfCd9ww2ZkqGegaCYubYHbAeAgfpd24MwkkurBDanjgCZTrOcw5k5DBtDQXOyt9ql3FUAZaiALcYq0O9/jS3o5vC0Qp282cY2LzCqqHeiyfTOnA8JaIZtMcwElR6Cavs439ngJpkd3VdvMH6W/LzCEDY8GCYnvws2c4bhZ5kw3jHZqSgJwamfzGcFq6K4VjXT7IgxZRUHMPiEq5oRufisV+PCClfS2VXIRa0XUy2wFuXhtLnsBQl7HOB57gnHZ5iJ+8nr+Dash3399lqlRUh3q79u8hILmwFDtbKI28hvjY8LNFjBun36VFH3OjTcpuJUjTUFAmbWfXEv3kHqTF1I5AqIN4WfXgMy1K6cmjjLHCNrGTG3XTzoGL9PVWxr4ahmJpv+OPpAyxE8YKGguqcnWKBF2bYjdRmADreR99v/Iz9Qu6hvi2biMAIUcsQ8+4LKoAak464Up1FkrROY93nKXDJcYaMra2oWgGZseVdCWn3ZUoMlTC3nelwZsGUFEDWY7Ta6HvvMTz7ZtOLDMjVfSKC88xeph2zgP+R+hlJjZvo+jquNvyjVk2NxVnJevEm/F+QlcfkMrYaB1ib1sf0YhuiECETziK0TRLN0MbNobthNoKxQ0jr+06XQz2hceNonFS8E5lwUtijLz+SO+ZWFQlkCgzWtzMnIQDWc8KJvEpP9XaOeZZ9OpRhv40Fk5NlcbJnSNxfmpvkV/cjlqx6hZL8G2oRxXpRA3WsktRon2BQr90lAJRzJTICffPMnL+wt51t+gwZumiUYg9y0FOuFTJqwt/hRZME1o/UEfFlPjIJPMhkcTWd6je8j+zvVuUBDTB/zwQ26Xe/qPxy/QyOP6IE3oArd8SCkpUZwTe7TkX3A
 ZckGuc4H
 R1hcVlSpj/rtXCxgpD0M8yR/LMtPaLjYHX4bxnuPVOzrL1GbWTICxfHi0ZVBh1HfctuF6qvk/k3dL6OgOxs3yqK47OaFwkJ+M8H+f9Hf8WWYC3dCM2mg9MI8nZ+zQnHlXuVYZv56fz7Rd8pzxgViwOD4pBNFM8afuhefH0Lmq+b5vGm3w5d5thrvWHh0W7W+rCMviOYcOBOKcGS+fg+mNCmRNCPHxHJm2N+A41vvdVAfkr5LbJbWSoV0ihi/EK8b3f6QRorKI8FKa3+jdUyhGmAavSl+3YguFQiOrkUml6vaD6BscwEcMX6w3IXYKM0aAxMa7iRGcpOwsckwZcdXADtZO16Voec0Y5BLpq5Bk0jEqf4QX5KXoZIOuAj7smv9Ej27LeQ12xq0+GJ9oTQk0VNEWhDrYuXokaxBRNlURfx0IewktTd6cxm3SMrMJM/huVOn4u7HLtXXAaNNqAUGNPbIamBH4TkIBqcecrTu+CWpT+eNUKvLPpx7v5T8D69xbIYsQQM5QdOA2lvwsqp31gD4jyu6ywAevjjwr11/d33QATMSkI0ADBqnTrBfAdnIQ7J6ENPyzB8eF9+mwmv7vbvrPgzMRbqDv30v2gAgyGRcF1e6qqtbe7cFNzE46tt6MapupohhYWm6XnRQpq4Pa8bIxV4d+AhspayT46oUpm8amt6w2vr8lVzp5MJFDKwGt7pPnc3KT3FK19MwQZVw5+zEN6P3+Bc+dMLXEMu1dPJ+pwlaZhDrt9wogMbBYlSMX2805iU1TbfZK0vf3HRL0FGW58cPNNiwFB+VfQksgf8iqZHqtn7acaLRE7B+2qt2Q+59MEnatTafln9IYQtrjagg0IQGNaA7cPf0Hr5Q0R38+iUfz50F+iSiYiNepsMBDh44nN5aMHNejjMURiwkjsN+Rq1m+HUPw2dleCMmfg7KBKqIho/iOdOknWdRbJEcsGGmw6bWTS9ar1+m7movNwZAMaaF3
 9y/rQ1Wt
 0HXX6lXHyyXz45lM1mMQIfoFGuFMD6STXkq69trOJm/4TibiFaF1jTRHc62aD/LGPmoyGEve4GjKzCJCjcGQ41iT/z0D/k2qW2oOuwfanX1i+ERyMhnM8V7BRNdLoweuEQxt4w6MF5p3GBk0lLuIJBrr+GRY8uziOiQdN3Qg38ZaoLVK2EMowpGuob1/84YfARSTMdtTImh1W55VfZ0zmnqH3PDBerPoVjDVOsntxBphYY3Ouwej0Sd9iHmwY0m4gU6j1lvMa9ETaI+/G9/YQ6jYMvKz5965arZivqHYF7Udyh1B0HxBJeF4fmCSHsD8MH0Xrq8U15Pc155VpZlhsnO7pV5CB6rGWCPKCT0uz/ZsZJ4dQxfOGhFCq7/9faCEY2CNq3YHUKRu4VY09VlEqYQziM/HHFoADKzcMhtMntct51Ib88zVgds9NoTHuy7FmRxIkZzr9G6ONE7fNZCgkajFsFpvNDi551wzDrNapx9besANMhOVTDAhoq1kz74LHQx6denfGxw4tfrekdSiMpr+5IlRX8PFFvX0+wstypC5jbWQmlAZPFVf2oDfopx1X4ta4Cl5XNV6XIy6rkVZpSusC32kRhIJsJR4LtISYxR2XJc9N6pIO2kj6OPKWtSl3fCFzmcgrRMjyupODK4050z6i1uly0hrJ0jOr9T5dLPhjwNCPOp0pTIVGKCFaOgMz4OKgDBHbAJgRcHlUSAb6BXHUowMlXVQ/cOkuhVpseLBbDDVhdl8OvX1Gzj1z/aVlsk6YaHTqestkjjhDXPIEfgSpxdsNOs35JvIp+YU1RqO1Ma2k962lofZM5xWHuCOD3KWFcyRkK+8/SuRXFOob+VYt1ZSCv0SAD86H/d/TL46EJgBj4mQlMJ5c/YEUiLrU3uxVo/SI4E2qIUxbRzbeRDLsvVJ0PrtDCpareWcHj1ejUTfWC0ZPoaOKDs8R0DFZGN8LII9zg3ILE9wed2R/KUia5+Li
 RMBqbNbD
 NEgV/RoBOp3kUfzlBDWyP9DkIWIkNzbpL8kXbKzxbtGP9cjIL1PnA3aTAFMqlUBkDE/km6ZLsGd53cac5TwyDrV8vRc4Dkb0Scv67bI156aLep6nfBYfMw56Jy9O/27LKBwOqLdmKo9Fy6XSvtDo4gunKvJEuvaMjSUbPIhXu/zIFowTE+6EyGxtXS7PB8vk/fMyQx4dFqcXLVZvyBudVQfagB8nlp36+TElR71ajonwmBCv20FQPsn/zA6aHigsmBmhAzv5RxGLBZn5ZPNZQXa9Zzp3iveTn1LS1F9sSVNOD9jAP6YKGDR1ZGIES3P1ZkTGyakqEPB+6itOP7z4q9/T2XssqHg5DCMX55bIWYoBBM6CvtWBwviCI78hCu/aIDo0JTegBazrFPyZEg71SvvvyOIZQ4bXdkqq648V5Hp3mxUWj3WG3aOcBurmMx4pxIjHxgOWw4xuNmG0SWmS4uuURmoXkHlpkcLeUFcjxUj09DSaN48hZu+GK7mhB0O98VROsxeaRzSa5v8AMEAaHclGLREmi2miP/c5cBeu60Mm1yim0TBxslhRsEm9Ir083m/Z9Va06oixAnBgvjw3pmOB8XWNOAEgDRNn65tqW/FEJWTYSAt4YO/dO7zFygC/w6Idwthq/GjPrW4HE1rLJ++GANCO0cZt706T8PqqxYR+tiaoOnyX132q+19nfj4183Nlfjf0D+zTMp+ugWhAkDaymw8HoByyONojKnAaJARyh0htpQuIxL53WNA0yvhpSzgtnrt1jbgOPQHzOzZH1E78hhTWdjK4d6xRawtqRgv1Rb4LcnWjpExqyBt5EYOEAWsjbMB2zAPvccgi4C00yWZmsKNeUZU9xXgYwhGBCQmqiArCvZ3Umm+OdggcA+NUMH6b4Oh9+K0AHiDV2q5jjdsI7c2zIg/B5dczkrjfjHPNcQxlhm9PY5KXhsfjnJ9vPxVzSNNEVMGhVnLdN79ohkNn6zQG/
 V6nqTctv
 TSjkOvPaY05MWURLSoT1hmEc2IIJ0qlPQU8OlYsmRiieWZYrosaXbhsu1RYpBQUGsW3xuKPOnzHLpLJIlFC56eyXEpRCsfQ7OEa1yBmh4In4GhcnSb3w1IehlfwVS+7BPhvkM7rdFf3AAXCmj8b+PRvNIX4suYbt0wJgotwHc6wHGdvK/4bhKAxcY76EUgeWhzG/J1jkCAVuWztbbkbE6VSqE4YepnCbR8uutVd1zoNla+r4q7S6aF5TXi3ZC9PptMJUkcO24PK5A8rGLrqKCrJ4Bb9qz4GrAo41wlgVP4OpBlNw90sVrUXl07HGf2TWh59sfmzlrU+W7VIQrIb0IQ/kOC6P99MYNOKSMBsmXFZ1yyNWuUzsxIHB8fV47m6egvCCj9OjrRWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> These are not MMIO pages so VMA_IO_BIT is an inappropriate flag to set.
> 
> Instead, set them VMA_MIXEDMAP_BIT as they are kernel mappings and this is
> the appropriate flag to set for those.
> 
> This provides the semantics required - no VMA merging is permitted, but
> does not prevent GUP.
> 
> However this has no meaningful impact as these are refcounted and thus can
> be GUPed.
> 
> A previous commit already prevented __mm_populate() from being invoked on
> XOL areas, which VMA_IO_BIT was previously relied upon to do, so that is no
> longer required.
> 
> Both VMAs set a VMA name, so always_dump_vma() returns true before
> vma_dump_size() reaches its VMA_IO_BIT check, and thus there is no change
> in core dump behaviour.
> 
> Change this for both the core xol_add_vma() function and the x86-specific
> get_uprobe_trampoline() function.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  arch/x86/kernel/uprobes.c | 2 +-
>  kernel/events/uprobes.c   | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 65a2de82ecd2..0f60c0d076b6 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -715,7 +715,7 @@ static struct vm_area_struct *get_uprobe_trampoline(struct mm_struct *mm, unsign
>  
>  	*new_mapping = true;
>  	return _install_special_mapping(mm, vaddr, PAGE_SIZE,
> -				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_IO,
> +				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_MIXEDMAP,
>  				&tramp_mapping);

So these can now be GUP'ed. Let's hope that's fine ;)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

