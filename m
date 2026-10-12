Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41DD1CC6B01
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C3736B008A; Mon, 12 Oct 2026 14:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 474346B008C; Mon, 12 Oct 2026 14:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33C376B0096; Mon, 12 Oct 2026 14:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0D46B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:40:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74C47813C3
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:40:13 +0000 (UTC)
X-FDA: 85314839106.27.D4F8C9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9F56314000E
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:40:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Jz/1EtXx";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791830411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vdQFJSE/NT9Rh54bDzshWf+q/AffDyPSodP3mkqurc=;
	b=vBhV4WnyG59h9EOO5/NufXr368wiA+GSKuirxL+7Z6LX/i0iUZ9u2QEpl+xbXZziR0EPrC
	AjhX4xJzbzcTcVkCaReqQSBdCY32/TTq4/XAzsVO1MIAWiALpBZXMBhWS8vInJFqRFosX/
	p95y6HCNvVqwDAaXb30Yi3B8nJeJqs4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Jz/1EtXx";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791830411;
	b=im6N2dGijzkWKmqMYqtQ02cXtbxL1s4N10Ja1FwlschLUXk2BY/lDIzYr7EPC3PHB+4fCh
	gwAN94ehbQxINOUiLTYyxdgNbyJeEpgnGk9Vrqur//RSxXPCco7dXNkSHZxxYGHeF+6R+D
	1Fq32pNtv9pG7KZUCwHu/DW51LBrA7o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B0CD341ACB;
	Mon, 12 Oct 2026 18:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90401F0089B;
	Mon, 12 Oct 2026 18:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830410;
	bh=0vdQFJSE/NT9Rh54bDzshWf+q/AffDyPSodP3mkqurc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Jz/1EtXxleYZI0WyCuMXfidwpTwMlPkH4Ian2ndLo5ibmSWjqhlFClBUxTGnKp6I5
	 ROm5zrCorjYZeWLmPeuhV7SAbp8T2F/0Zl4JLNyoWN+lNFlr8O/2mLSIWJGeJm/AsK
	 yOhfVuEUllgCNPo5whCDaE8GjHjWz0JcQvnuQtk0DnH/R8oLzpJDPDdEOyjZrCeS+e
	 7b7qfPdmAP0+SByoOI5pu3basxNiMh5ic75Ui0RlNnJrbN0dn6EmbcVY/PArdSiujq
	 gtc0GkWTY1ncRNbCX/87aasO2tmVrN2zWsEYHejb6N0GBwWLsP52ooOFVuqZNu/5i7
	 AUoFZ5uBv10ow==
Message-ID: <5ba7305f-0ad1-44ee-be0b-36752684cdb9@kernel.org>
Date: Mon, 12 Oct 2026 20:39:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 24/38] mm/vma: enforce that mm-managed mappings may not
 set VMA_IO_BIT
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>,
 Bert Karwatzki <spasswolf@web.de>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-24-923b70125b1e@kernel.org>
 <5d51b6b3-ad58-4827-bedf-f1a79ebd5c86@kernel.org> <as0nF53W7dug-Fem@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <as0nF53W7dug-Fem@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tr3q7jjo6hf5h9mdhrmqrb7ug9ss6t9y
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F56314000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1791830411-667536
X-HE-Meta: U2FsdGVkX1966fZXph+/zwhK2lyxW43tdP8JI+KVJccSqVXxx+JafdvFyZDeLhIjBb0zYHeb0OIeH5eSCmv2pQfbzrCyMvCs8oOvu8yirVJsS5rMrVbsPPOgzzGrWEwALdRfdNJ4yjPQ6VUhWd7XlVst9jEqO2vUeLDSwtfBisPZirkAlA+YOZwg91jwJsZsf29vLgpjpthH/EBHBZT8lK3p8AszD0/JhBwHZZ9xpY3zH4YuDLxRkKU5ZVIBXeS0AjSLMERl8XUXvstPXhNEYreVUoL5QtMHZgPDqa02WacQhBPEso5Ok2sUgiNFrT2fTIO5YxZjwjJ/NtPnbSY+M6GDEum2MIgWK4VWYzjScJbCZsObIips803v5HvtRLuq8JhHsPrxi2njdJmFyKC2ek1is1NKFLV6yn2+2mP83az61jCTbkLHQbJsqNGB/aRyWY3NzEj39WdJICMlS2euxCJxfIeXM8aJpiBPZpXFBnce6NpjETR/lgPAhpxDbvM4lLQ8mC9Fo/Yu4skP3D1xQMoXwdnYii4tJFRqOqU5JecfR7n8/t/OP1CzOA9saPyrhT9Pd3Fv0cJd3/n/Da52ybP2TNA9OfvoKxx4r4xfSUD3NKkrXkizir3u8rj1bPWfN7qSCAdGZfk8n9jw9FiCESCzibprjAvuhzqlAeD6BVW2OsU21GlgVSflhMXyNxYTjwB+D7vlGFYzT3TEHrvzNsvYKg2uXVftlxQ6gL8x5KxkmRsEppIRQuTUK3wPEzC0lINEZCwc0dLE/LPz+7dIwx7MlEl8jkEAqfdiLIAPCNN7Y5WgtQlmoyo8rllZf9h/dCOW6IPIO+stkKp5ASxFY7CBKblOr7ohnzUG0T+RBuvTzYLmg2bIFWWfk5miS9dETYvyQQJzP9PTRP6iQNDYuo5RhItjM33LUOmbBpnlAJGh0pd8w/C4h5PqD6l6aWS3vZ5z2EETT+DWTP6zwaH
 30K8d+s7
 NEirxVqw80/YNqavZ3VuCyrXcmvP73TgN/URsqOL0GWm0ZzeMOAwvYyirhDeN2AhqM4uS2G1fVLoq8OQiocPidjqeZRsRNTsx7OPQVGD0b14GKZPAZeSpxE2Od2eIfGzzqR3Kz4D2E2v8bQRw17NDVtMRj2cVlmeuzDfzRR3mky7KGWWScJ1MNe7GWbujs+tS/aUKXXOwD2GPr6Revk1Egm+JhNxbwmYYzyNcNM8pEWYsE8eOQGdihWAjDTM+Fj9GPFUWM7oRt2txIppeb0/G1iJ4ltCc/r7MwcJs0+jgQa5lBbdbDGbKhSFLp2Zlp/kWV79MAGPJq27yvY1iB61bJPaxWAFLPeHrPclzpEhCbcr1JnK1hidITwBdMSbsznZ1w0gwsR7nTahlCWofZoMcS+FtkiEyQnXSHCVOpMCBLOJ18KkASVTiv3z3dqSRXDO1dKPHi8LzI0vlmiqeCtpZe+cFSR3y08X6EYX3NXXsagDZF70H6Z/2cBErdckV6W0tsr1Zg/A7nRn5y77g5pXT5LYuJ+OdtqfxAfs4/w39/ShHn22gUihX/pnMhe8feqUy5SyHK0o+7bv1hjpoygPSPi96Hzx7wn5TedEtclmc5ORJE4JFW35Y1cKvL1AJ0Qq/q2nsPRlTTb2XB96be2gL4L1cGFGsM/XRhV6XcD2G9nlcsMgw9rOXJa2Vv6BkHS3q5YAt+8akA/34cWgGzNidn91N0KnPf0Lsh1azLOpEUcJ6p887144KA4rQPrpMju+5Q5kMq5/fwcHrJje6AKrtap5aJoJkovZgKEIFUpdlsiuaBtsIWngFuTRRWP3QkOqp0VQeE3o9PfHVQB1FfDSzt3f2dSedSI7yud8JjuH8wobhizXQVVOTTaGWkGcBsiX+QWEHxidS+3SBjR9xNksjpQWEirfEhKaBzrG4RwzAIzc5IvtHr+VbeF76Ok714nyhuhARJv4CvtDmJO0PnlCVpYc3IBFs
 EfBmuHIZ
 O3Bs+Gg1Xie0RI80QKYUUSyG+er+rXH6rL3CWdBMYPAf2GNq3oeAVx57AySJL/zar8DnLtos2K8XO66+V1IWHCamSEFxFsAR/Y/ejMyV8YWDSOXjOHly19CoP1j/t7ZbgB6zmjyAnLkdaFhz+Pag8/LX9ATPRa30Xf+SdepBSN5s/udCiTjxKSssIu5FO45/8OhTFPVbeDIExbayR3hqynDf+0jphdSittqgDeELPyJqVCrUcyQ7pHiYr79Md1c7i2RlKYzocrcTikBhYB3E70bVKw4QQFbMQM2Z+rthrGa0CiY1V5zGdA0KiwiCmXy7ZNNkrdK00jfDpu3HI7Pk9VW5qD6HVDGD9pLU1wqst1+vj7abneS05I0kJbIK6/RvkbHMMqgI9dXkyTdFgXcH4o51KUkI6nYrroaCmO/8c0oPXmYxNBqlKj8kabhfswsnGlvll59YkiKd5LZdHesqxx41Chu34BN9BkIVhdk9njVx2J/a//bcUpxCynaMragAxv/FnAuYGg7Sdhv/UpE4f2MQ9uEPK13W/FQHNOYtKY0HvNC3NciBvi39OgYBsshDUAI2kb+QkQeNZkS7Ox14fkFgnegIpK7Py/B4I8+hW3PxzbdIkp08ODYnnE24Fcen7omIjpSg/Qjgf8rdKrBUeiqr/2rdtRZXjtNNN/PlGf091aORWpAp8b7x2DVzdg3W9l1e2Zw8q7QAYIvba7UcfdraRJaxA37AQE3DDFADKcOfs3iGVD7epkUSBw8HIJWFwlPVH738cB0ygSlGlZgoJ9deR0skfQg7NIVj2m69jWXdPOPYEO0gO2symj4YFvJNLs6ugrJnjjGp1v+NSa0BlNCanSIl1vlzbRvO49oVTFcPIgbx7o6K9IY6iNUs3usWQ4InGoNa9i5u6QNw0bXiix797itRWU4M+WKgMPas1pcrVCcQ/YnPVm//kX4/20oDt09JKbI5JDKCsxqiAQybrAc1YKJ5/
 M2VOZdt4
 IMw+n22ljvHH1NOL3u18ukiF44kIQtEIaa0NVwUrJK6JNltZG0MmDVmDjtedQXSg19CflMK8C3mdKCx6okWMq22xfGkCdDLxyrstHhW/la01aPjUWFUVydriNlQwNd6AbbE1vQvCWv6QPzcATveRK8IBOdiEY1wmdBLHPh93AZPafokPqBR2fiM8DSeiZQWd3t8Ef1gbE9n72rmHkEZWO+a+VR7FxkvDToYZhl+VTGVeYnGdpADVDguisdMaSYF64zDE2vh6pQh52T3quu1u+SMJ6yrpw5l8p8nbx6U/oiwBVCoeyAUzudSHYqacq5X4K+9fA3l5qZgvCOmptO1ZJ1wm1Ny6KtU5x1Jaftp9o77QfeAfuHzXP0L2j+E0DuPo1iYiAu+cfSM0fRnlUJDr8WVE9xOZaZClmHgcV6eJWsbU3dOqo8FnQaOKHLGYNg5na2f29N6CS3owXwBHG/QN/IqRT46AhL00VioFUCUXBcH7jL2C+cdU7b0QSm3CtB6cRjJfKG5h+7uSd5HWw535QmxuowhrC7gdK85LTH8aqUS0k3EgbVb9ANrH36LHLW5UkLkB0Rx2eG5/VSa9nGpyNAw1CbxvH+1M5DpvIR3QRbVdbcKV5/o3wikBKvQpdGJSQrxhoVdxl/2jD03byY4CaJ3RbmtPUar6ToxRX1ThGm13/w8JE3viyEz/JGMPs/+1qQ0QYLNgXHv0wc/N3mCfOT4aVURsp5DKRBFTlBozFDJ2qmFEQf+AtXUzNi8/pH0zbOmTfvw7D/Tsfc5NfTzGn8n21RWuLZQqKsQYXRU37H7NhaTwCPDMBYQUNdvwInEDKuAthXKE2utf1zh6LO9HMEMKFUiZDtKG4x3ApaWab+8oO9Iw7ktqfkegmWICrUeZMLTRIlBUiQsCiqTdAMNny00yhk10mTf9x+tAzeM5ijd2DVxzwGMlV54wGXwo2A/KiXs9jIZhvZuU5BuHBF9BzvVlGsaOA
 I01tBTac
 XWEVE7iuwhod7fp0jRFFEbrbOocmai+nNSYPIBX51NyHh0ya2tPp/H2hYF1TN7rB9rPlx+M7sA5T3SlNNz/wmGLRszjUIK+f6CnA/EsQhI8HDTiy+nmalqdAyxT4zMTq9nVGhyyB8iCJH8eMJ+uIdmMaRBP44/W2vRbyOXB1Wk5j708lhSt8748WMSJbuX+IaD1aMPpXb0asXpOJyyBdkYhVzdjaWtGKs9eoDQhYaomS/57xcEo4nQZ6r1hFCmBEySMJM+vYsosI9pwCtalYOnRsRA4NfHLrM83BkAE4To8X1NQ+KPICQfUZokwG36oDlk/txSNcpBI3nWn05saRu0IIWz00RBXAGmNUX35a4tkHcHq3OZnKXzCdGK5FsX0r8lU9vqxjfxHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/12/26 20:35, Lorenzo Stoakes (ARM) wrote:
> On Mon, Oct 12, 2026 at 08:25:54PM +0200, David Hildenbrand (Arm) wrote:
>> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
>>> It makes no sense for a mapping whose contents the kernel does not own to
>>> specify that the range is MMIO.
>>>
>>> Prior to this patch, all in-tree drivers which did so have been updated
>>> such that they are marked as not being mm-managed. The check WARNs and
>>> fails the mmap for any out-of-tree driver that still sets VMA_IO_BIT
>>> without a kernel mapping.
>>>
>>> No functional change intended for in-tree code.
>>>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> ---
>>>  mm/vma.c | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/mm/vma.c b/mm/vma.c
>>> index 4f09fb98a2fd..51bdbe08bb02 100644
>>> --- a/mm/vma.c
>>> +++ b/mm/vma.c
>>> @@ -2796,6 +2796,12 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
>>>  		return -EINVAL;
>>>  #endif
>>>
>>> +	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
>>> +		/* mm-managed mappings may not set VMA_IO_BIT. */
>>> +		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
>>> +			return -EINVAL;
>>
>> We do have a helper (vma_flags_is_mm_managed()) but we're not using it because
>> of the VM_IO situation ...
> 
> That gets removed.
> 
>>
>> That's confusing ...
>>
>> Could we do something like testing vma_flags_is_mm_managed(), but removing the
>> VM_IO flag from the checked flags?
> 
> I mean we do that in a subsequent commit, I think even the next one?
> 
> 
>>
>> Then we can add a comment about VM_IO in the future getting remove from
>> vma_flags_is_mm_managed() ...
> 
> Yeah, but to do that the code would now be something like:
> 
> 	vma_flags_t masked = flags;
> 
> 	/*
> 	  * vma_flags_is_mm_managed() tests VMA_IO_BIT, which will be removed
> 	 * in the next commit.
> 	 */
> 	vma_flags_clear(&flags, VMA_IO_BIT);
> 	if (!vma_flags_is_mm_managed(masked)) {
> 		...
> 	}
> 
> Is that really worth it?
> 
> I don't think there's really too much confusion intra-patch about that is there?

I would do it as above (- the comment, as that is the next patch indeed) and
only remove the vma_flags_clear() in the next patch.

But in any case, you should spell out that this is only temporary in the patch
description :)

-- 
Cheers,

David

