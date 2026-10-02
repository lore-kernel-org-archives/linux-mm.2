Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCE7DCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 06:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C69406B0088; Fri,  2 Oct 2026 02:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1ADA6B008A; Fri,  2 Oct 2026 02:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1B96B008C; Fri,  2 Oct 2026 02:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 869AE6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 02:52:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 09321A7565
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:52:54 +0000 (UTC)
X-FDA: 85276768668.20.9F93965
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 341B440002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:52:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c8bDWgyU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790923972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u15YH4Gk1jY734f7Ru9LTF8CNh+n4MtAogEYgBYqpnw=;
	b=4sy7FPBsGg55RJNnS6nmEYdp3u0XCbSPANUTL+F0aerlb2LM7VqOng5azegEhTXrcCnf+5
	PLCoF3cR2CeD0kPmhe45HHUL1zmNJH/U18BZZid9WpC0+NIt28lPoROE15AF706FQN9nSX
	4whs4tWwbVzoQztWPPgB4GPNqh1f5ks=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c8bDWgyU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790923972;
	b=NFc1jVylNFBatRNTIVBFQeV0Bbij4cQqCzcY5FUHqmgm5KDGdL5b1OQXpvOmb16JL5dFKs
	xAjOK9KKDwiJnWPw278L6P/Io1jFxAecfbkXfOKcCALErcY6biXFadg6zUxH+kPF4ZSGCu
	x+tw3AN9a5lrj50exqNcuj1hQC5a9lA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA10E418E1;
	Fri,  2 Oct 2026 06:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78DB1F000FF;
	Fri,  2 Oct 2026 06:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790923970;
	bh=u15YH4Gk1jY734f7Ru9LTF8CNh+n4MtAogEYgBYqpnw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=c8bDWgyU7nbSbFiXaryamWOeLdeQpMchMrG0YjFpHuBOQ1PuqIEtbmxLMXTlp4ewM
	 OL/GoVIH5VS5zURtCMofHqaWCe4cVE9WJ8MPM3FdcVOyMRU1YSbKnFj7c9DjyEVkSw
	 9gCmXRSqnWhhFoMhDJ/lGP59xmGFDa3YmRJMrGx+9mw3LMY8NLYorwZ19bld8oz5rO
	 DgWfbQbiLCLEg2FXnUdwmI6B06bIL+jviB54nuqoHIQ8yrkmiuMD5hPR0jQVPoCSav
	 mIx8HAdy4CslS+i7YzgBC1u1s9bonkEoTcmwC1glIfgxX4mWnJ3lRT0smKX9wzYurc
	 IJYDuX5dbpfvw==
Message-ID: <bd623df8-d5f0-46a3-927f-f0a4b458e651@kernel.org>
Date: Fri, 2 Oct 2026 08:52:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 27/40] mm: remove hugetlb_inline.h
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
 fuse-devel@lists.linux.dev
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-27-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-27-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u451kj5fcnosokmp9mf4474be9ebw6qa
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 341B440002
X-HE-Tag: 1790923972-820802
X-HE-Meta: U2FsdGVkX1862vyFCB1388Av+lSZI1fOnQ3DtidDubcqCRbAoS/KaSzsSNIHL/dpTS3AfCCh42FYbiQEy3mkeup6V1yGX2W1LT/fm9fLNwJWc2kFb25WB4/txl8ps7W8CMtaNuDaPYF7M3+V7Uaa5T3l2NQW9jBwPFg8bnnR956UduV5MNyirIbG9oSiIFhHdzWQgzdzom2fgPt6N5PQXpkQ0ABZHMNjRJOLYWzNSIxwE+DbITFrHvSI+rl3O92mk9yb166yif6RKQ1br17ItoivIAL812hsFRn/ToESWQJ/5b7+GLc97zJrOnRN/0C4E9xhmiRBtYM4oL6Mt6qOdOET+KDSh6lADQkiRA3TuRvUgtesZsBCwcq3MhM/YdgVBsZoq7EjGIB2sGyLPsGongkLKABGnqRJVj6a8US1ff+qVgDDGv8nuyxpr2c1Th15uaRbnfE+H26GLoFrM8dsIqcLM538QlZOZxO4g/7aOdu7PvWNcpK5+dgvq6JSMstgQ7ZoxEmXY9Jya3lP37M8yLV1+gwRGTG9AlaQXpUZ0Kxmu3TayuWaGbsk8jffc1UeXVkqa7eEb4g+DMCV8TgfIj+qBgaC2JzKUusITDw86sFqkiioDbRp9+zKC15IbjPjoADdp8tuJvJGDTFQFlvzHQQUANISxbJ8tH4h6bS2fQaGtaeCWndWgjjFiFhjQul86PNqYKUe35fUDcmlr5/phSSUi+sVmHO2QyTbJkyigREP6sEcSnE281ZhxKLM2wcYe+srG5zi4B0afLeMB3PQpHIgA1ZrCZ3t6/y5MhDi9L9XJZdTLqrY7Fq6bFwt9jN3LoQx31mgVDk6MtzoOJO6P3yqMJYs4QsZ8idMvK0jMyZM9EeOjOJWeqXtmSbVxySuXzjwhTWkecJaZp2ILwWk7rVtXvlnwbnhsWOgfM442Bn7MWx1CtZWQBoZDN/T+VCSqJMpsciFVgDePmsFmuY
 ZPx1ye/P
 KFlOaeFmsGB8aB1QlUv/rpLVRhjuB8llC5lSx4vTU5FiPWODEUdhS5Oj5B+5xhD5Mempx3GjGX4xdSDw8IIXvsrrYI0EQZB5lKyHpybtzMFwXhaXZpM0ItHchO6Ml6swEU+st+TS1OwU7K/H68xVzl5XMj4GxP8tL0/9j51nqh99sttXshh290RO77b40ispmTitoQUCc0jHraIbSZD7IdAVVWNcMVpI7k2sI/rBGAuV+GiG9sOM7+/dwGIBsRLk44aCr4PkniZg2Lg2JwdIcigM3Tx/D21ZXeAjQsPTSYVEatKcq7hV6RddpdbxnM0HCTgb8vuEOH8WqgG0ntcMlgbdPkxLnFQQL1aXfF3y+64S7CdxCYiSnLkidKg7sN4GcHDNj9f3IRwh2SSiu6eXreAgcp87hYA0H5Uv1lwF+TP/2O0JGrOXYhxDnYKwRsvOMNaVH1lmJt4D3sIIPqm45Tf+4VVHKtMrMHS5z2RDeRW3SnZPZAQahcQvj7akZl78wK3OSbb0gLlE6E1aL0Dv5sEyrjWsWROAPUnkI32HxXdALh4GAib+zxqURe4pdXj/jlUqUQwVAhjSF9PZrqkZvHO2AHo0EH792yi0vV9j9i/h1UZA5/QLfwJIi8ZAC+kM5Cfbw/RbDQ1yrGI1j2Qa80vGp5mM5gjbABJWW6zHkLdrMCX3MtrXwKrx5YauDm2qHXSXrHb/svXdXDoMtByCOTS5+3n+U+QsjxbskTol5zaJ5oajlPrJzT6XZoUFP2+cKGgr4zWTRkAxKZTT3e6r2xoCTNyj8GiPmQ8rt5pPr70MtUeQXenp7/EmnBQ2DzyfXFTaeD1QL8oO9HelgLWKODnNYHdtqfwKcldXvU9tA5pqevkMp1N8tIqv1C3QgUqqO/TW7sjnWxrRbA2Vp00P80RwO2IBNi0UlN/YpOj52uET8CrPtL7Bs+Bietz87/GBERdINeHOcef/i4ZJYLXp0+RxWKoSL
 nUBgl2hk
 +r9XE7hx3Y0WMlh/ZW/e5/wkxYLjrkQ1/IeuHS5dOFpY03K0/KGFROs8HHqc9gcYY/6lIqmCQ2cyCa1MJJuyMiWSBFcwQTP8HV+LEqX82oG1VDU7hjEGg1xOWGgIDNNQO0rHvQiHxEhb6wCtTLtoQENeVSR7yh4k28XRYK1B3ZtrXqSnCXZLbuhny0qiN/IcpqII5Q5drYzL3clgmAKvQQnDWeBR6rD4OhBkNVKEStx5EHX8GEPU2k2uIERKgfdN4ojIcA3DDyCgQx29BHjTqm1fTsJl9Ko1DASlfqSz6d3zksHJvhmVGFoI0oY6+8Pbekmar0woS8bv7L6eOdCXpcc4rERDQgYMX3qdEIh6LR2H+/lE93m67+qFzSYVsuKw7F6U+oEZz8bobvM8GnLA/4J3K5KaiFAQy+2kfWMZp30wLMqp1ggJIeGtWBVpEpgxAc55QAma+OlLqyJIVd9XpkqF1nPjp+J3tBRQXEKx2+70OHTolju5N7dvmGwF1qQYgL1HIYhmNSr9RkNsknFrJcre2vh/KpM/XeElhFHcuGYTB9fvBzj0fwmQhrWyXL8Isbp7AmgF1VbJaA3bFp3WecP4xrZtxDjKRAvJlyu0jDlSc7oVMz3XHj4IbZXpaFmgvFGvw33njWvfdlK+jDX3+uoRpoTIIgNRwkzZdyniyQGXb1YyPf9y6KxV7J6PffL1vsLb3jFwCCNWdvVTSStH8qUn+VR4et9gfrpVQUSeH2JXFF/f4jBbA8kiDrw8d+ya8qcw0B66ZuXRONjV1NJoDKtSB3ypyOQMAo0gMX3aNSglG+KMPekkCtlNOsJYJfwdBMtP4cerYxfPSDg8+7mvTZfN84yIXpqDAPtL8X7s+yiIrmUOd1sYm39802poX89am3H6Ym6TKDXsBfMaspDtvTww2Hj8KsUXCPV8tz3JuJucesiwvTGfO98V4xj9z+qXcteQXyXn7TbWn938Xye0Jpz8gu7DB
 akEKxqy2
 5OKFGJvWi2XFy+nZDzShXIT4APgVjtJM5OjN5EcKneMgqhKDH/dw3uUpTcyVrI4LXTv8SF9QH/70QL8bfxS/HSzL6ZZO2mYIZDMte1ETaa5xDB7Y46J6DLBjRLx1yFDWVwXmIdbE+VFn8CKCwXQkEF6iULTs+71tbo8+waPFx2cwDqqdKtfdhp3VUhtHpL3rvN4Gdw8iaw8vzPNSxzT8xsi4OyI2e/HWB1aLfEK4slUDDikKCpGwVh/JJQXTHLbH7PKMeq1TM4xx6WgGbhbP71r53m4Q1gj/fhHDJCSzWeCPG774HkKXbPm+2HnphwJtYaFMuZTqKO65x2wY8mYnya655A8x3lbQ+GrKVCJ1JLfwEVdKifbrHfh0eSG/5WJiSKq7MJYLZMzWSzBbx+RSU6tIbK/oLVfFiFcD2ZxFUJ+1jDQA1TDauPo7EwhaOuShVdaPj+6aODyHi9a+mLrKYcZ1/+BallXFqLHz7nN2uuYysGtB03ITgJNBeS+lLYYzMqKkSBfVLjXxaESeY9vqWpTIvyL58NUZnRxj/q5vsCbaIW05W9EDJGbd5NTc49y94uV/tJB2ZbUW+2iE2980bVaNuOC8H5NoWUFdGVZif2ftqnQeQS1VeTxZs3fbaZXOstcL4S4WknSDu7j74OQCTzqOWaosqKVNpipD1LyrbWyJozqIXPiorT6qivShCSLmWFmkSERa5UiR986iBtCmCFMGTRG9EBRpcOBQGbVsCn9FL57biYKF146OEWfpHrFSVgrobJIIlwD4Szt/TwGz0o5FKL7/MGACfbhz9Ixc91gikO6ayIRRtrFQayb9XqTbFECgt2xK345+izdQz5OuEu1di/EakOr/vzb6/sVhYYLgSl2u1cXOEQpWv+nRoh2qqxjCnO7RKmOjN6p5LSNIiIPC3NiOAsPBHfzwdxCpifRUXGemP668ZZ0+QEI6R7qO1/F3J50JFT7q8hvhDvDFhpJNTcCb3
 wOrg09Q2
 /xfH9WHyGfRnc49HNCbvNTHghySajB35iCc1+xWUllXgkR1um9OgmEo0zLq0WnbwXs26sztYipofpLa2m/CN6ariHVnhJTTJlqw3mP0ch10W60KoPmvNGP8NqWKHFX6DTM0F06A4V2X/uM9Prkkf5awLtKYnf2xzfU6GS4qKU1tKwtMiOo6gdqK/R2M96IN7yg0SzAVyAqJfPHL7L/HSwaueED35w56q6Du6/ESTYC+WRgpenAkrWvBGa8/PSYE0bECdKqxLLoW9nuIGRDJ9s4US68utl+CtdAXGHPaBL9mECvIdCgW0sLiQ4SgnyiAif602+1JqHHI7jkOtJAXjKc4hFptW0COgOuhxyKhTVWckomJqWMqma5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> This header really makes little sense - every place it is included mm.h is
> also included, and the header itself includes mm.h, so it does nothing to
> reduce header size.


It's very small indeed

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

