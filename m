Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D9BBCA5FAE
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 11:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3747E6B0088; Tue, 29 Sep 2026 07:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 325BF6B008A; Tue, 29 Sep 2026 07:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214AB6B008C; Tue, 29 Sep 2026 07:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E5F8B6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:22:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D4ED1204B9
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:22:00 +0000 (UTC)
X-FDA: 85266560400.08.C6033FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D0F544000F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:21:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R7ZIalgU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790680918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fPL1r0q3ZFaPVm8LMil7KkezedSBA8/3rMeLvpxPeA=;
	b=O9FywPIHI9dN1GNU0R3qAhg1j0OTokGPLZYYwsLqn0nGGtF9iKDtLi5tuDIbRc4U54e4y2
	dnHs1UqtBRzknrfzHYmYywmnI4HxMxvO5e2FSrSTmrHbr5A5b7TW3xdESDt9IiO2iColDL
	ttWazIP1ooufGVFQu1OvC6Av6I8Gz1Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R7ZIalgU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790680918;
	b=3eNRxb52JyrC1ps/8B4gjJrlynPp7pE4vhpUiqCm6QqU5yaeMYQOC/m3NjW06o9BHlIPoV
	DY7zGUJWrJihaamrApeqzHDmRPYU+67NTuDr3NPOeHUREhz3Lyif4rgnWDGk1X1uywCKlQ
	lq3CaLK2mTmX4s0u0tReTz3bbvHBIHU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1439860008;
	Tue, 29 Sep 2026 11:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D1B1F000FF;
	Tue, 29 Sep 2026 11:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790680917;
	bh=2fPL1r0q3ZFaPVm8LMil7KkezedSBA8/3rMeLvpxPeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R7ZIalgU2YxoignykHVl41GbwXVq+ymjE2Si4HRcFErNll2DzNwd43/xyUICNL9Gh
	 ZKbhOo6icKbcmsuOqmHY4vcYGDVk0I9HhEjHuNVoiCF/g/yVcf+z3KLnyerzZ1MiXd
	 W5Z9bZBV7t1tkUZVxlpq6Ci9stfsy0TAMMeCuz+nSAiebkXEgWtguADRz3DWyBpZ+H
	 mIWJYnCrwO2dvpBgpuGcPLGHOAHxCMNlWV4hSF1En76lTAsSQsZ+wBOPbyH1ksC26r
	 xgTJ+Vceyq3XFJSuuzXLjQ/8jCstGixi8blBDf2nxCsI5axooCKVBfsc28vfxzNygJ
	 YWOKPhtuzPNAg==
Date: Tue, 29 Sep 2026 12:21:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 09/40] docs: filesystems: update mmap_prepare docs for
 discontig kernel pgs
Message-ID: <arudePFfTLNBMKzQ@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-9-4583d8a23bca@kernel.org>
 <DLOP8IH392ZU.2X2GPOP2NYK4X@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLOP8IH392ZU.2X2GPOP2NYK4X@nvidia.com>
X-Rspamd-Queue-Id: D0F544000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 3tnde4b4smt5uprfg3rz4wb7b5umipy8
X-HE-Tag: 1790680918-927616
X-HE-Meta: U2FsdGVkX1/l+jezn4hESLhkbO7y+Nn4zHWgZiOFPfUO/4n+TTJonfn/qZGbkRa/6vZA+yqtnYIN0YDt12WPV2bm/uuPpj/aQN4jR4OfuYmcFnMJb8ZtRSFL1L0fuoa9bkBlQEzXix5616CEBAHgEacQpVldNA02jRmd12gNuX0TzrFmpngVdma15wPN2E3Ogy3LbhdZG9dNItB94GZAea8Q4dOqAhs6daaFADvwJz1y+hkBzBtfbA11qleojJYgmrhpQXABAC8vO+jxgZTdwBgCgSWRm8cdyXg7cjKTb9EbYU9QYW0BFucOZy37PZVQuQ5SXD65Do3+BCzK8/YPzhJm/8NRTHGkEZ5onVmm3KkpPuVRUMx8ygDh6ufoA88TsJp2L4j7Gq+eGh1Z5hC7VeOEsNBpWPVhxVUiCrS/ZlcHOI4pynzwURlE3AudjpaVJChOziUkoLZ0Tv+IQJWdGd0CPw+jPFmNl3/m1L7RmBNkDhp+ql72TMssfC/2U/VSeEp5tQJze7LtB+f6YZJ4sSUN36EUL4X3EhxqpsxwwXhDtKeq2yCP4SuH7/GF2DAt2tsWKkgk0CC/ecJdivzN+C4yyJIQR9EHL/Y/ExyIL87e84T9Wihg8TByNU1VirP56y+DSC7hQyRjYjHzeyL3sPcU4TEKz562WHp03RUFloDl7atJ74ljuymDhSBVXCDbuL5vjwi14PNYusEk6sgC2FDe8rodpenfiUXUBCHgTpbeev/NloUh3ES7oi50W0IcU2dQV9l2I9u8yRqqMhknoSPU9b/UrVNy7g717sAWK8g8WTJcTAXZVkD2DeMg9en3eHj7anJ62YzMu1jEYa7ZEkZcq9Yx3vqA8IxhT/2ITJjVD3IV3vjWUHHA72yIEzbJcod0af6YhZc14xdsLqNqkX9VxK4g8bD0NxQfGxdazBPjRfefCnf0orcYEeC24cv4DgPUpG/0uJ7sXF698c5
 VjH+21Qj
 JOVA8NIjEnXjZN+kcm57/2JbKzt3/ZFd7JHh8Rl+++ZTdARRrtzZSA/Liji6zhjtv511oiDfURYVuevwIhw+2/ZkU+j/0PvDBPUgFmiPbLEPSSjoMLAk1RqR/8wicFZf2OU5XV1xjI/5Atfe/D9pgl8X1MSht17LII9l03LOt8LExBrFxe4FK6/8AfOce+sjZzqf8S1hEAkcXScwHbSPzcmGrhdWEls1acDiJulfLVwP+XkeEad5RaB1YePVExgzWjUJLmdOtOjRmKMF2VuiC9KHbzVILmmlG0heuhcLdeDGGFeFoM8pPpxO1VVzjxkHGixMU2EcuqNi+Wc5NCUO2FZMZtFJI1eelwBrJBfDZVI2QRQCR1bSirNHr2MrNhZ96+jl9RbN09oe7LmxZa30hJ8j6Uq6A4yuvrBqv9DRGIHDt4CPvLjbu2Gq6NZVgPpF9Miw7CHTGk/zJsv7Ru7JLoBLeqtHc/ATSShmhk2ITTALdIWvLJCE0EDZS0Xb9O9P31d9mYmYV4TH9XTAM/G/Yt1nskWJ1sPC3JZayFQSFqK++Lu2mOKeDGjP7JlhO8lN6y10aiw/TXnrzYG6WgW9I2YgFMxYJhB03g+d2BUHhBSlrzBpx7OhIH+WYq/2KmKlWrBa+09GsveAI7pmrN067qADGsF93cLugGKkGKIsHygk86rAp+x6VAUW6GAMKNeSA7/44OxH7Hcnmw9IeDG5+EguNwcJV65DlWblMMkNP3WSgeXIeC2EJZwPnGPoEA8Z8oJJwZg7nmAqbAnRIrb1O3AdmuxLOvPPN9P/+9CUQyrdHnXYmNBpGX7mNOOv1NYH8ZQCLlf9MnjKuFgx50trnZQJ2O+9zXxVAVuuA/VD9B7ji+z5QWPgfAXDD4bd6bcOIWl+8d5hOOrrxKGw04B8kFEG0G71ByuZEFD604ZpbUTq6Kx1KV43eH3BMIb81+qS8YDeLsslHd8zlqApVaAiQ5rKMlcYG
 VoOd9LgA
 xk5JxWNauZUGXWesi+2kEdpglqs75uKTs0igvN0Mkz4vey/LhYwWnV/B0CSilXJKE6cbz8+uLH1g9HGbhPN3NbK6jpWA9gd+RHG/dGmKlX7wcGHAkyiwaONdf0Q2U5B8OPlAxvXbrT+6ZrjUApnAdMgj0RerPCNGf52yj5n4S72FMaIMHsp5ycjMy8uloTcWDuQg3foAoPEx2BigpQCwnWMBVvftc/b7qQ+GdV+MNTnatdbVpK9cBk8oU5md/r67qUUP71Li8TzstrNtK8JQ+olHXOikTLKsJaFOXNPu6GE/pqfNKR0bLkpBymhhWT/mUp4tAIRqfqRaK2Iane8KHiqIOxoHyMpiJzKw4Dq2u+IWkNa9J/xAyEtmAv5sNgm0L1cFT+XapNQQlojKWbd5AZQSJc2MlUtb/iqb+oi0LwOSP6RqDslt6Orhmjae1AvPZkVme96P8Lt8G7+CrkeYlKdH5gW1+3qYPGk1upizFEQDbd+KiS5vYInsVSQfxj4DBB9r6jpjJNgKv/Z4Kh3nLdT/14Es3U83V7DCBkFilv8F+w6pkb/fZOHuMBhjCwGndBbSqBFB3G4An1c9933hwSxddL5bctIbYBaUdxE/6dheJhKWgLUZytxAEYKG0ZTGzzBGxkFFPAt6buSRhyzh0OigSvyUu0a2gTDFXkh9BBv2aAxAPEif9wYiw/tQUV3JyugsLGmEoDjsGvoEmOQ3KAJhMwjm/lZG6k6EKuinz8EPwUkWw4FyyRTGppaLjujUpBssy09Dx7ZS91PIswdKzMhw9UE86xU3CLlljfChi6SQl8EyWbjgimzYG8Aj20g1eet/gueTO+Hs1O/Jwhbj5Rv1BYoFG5rv8A3FIZUfp6JX2VBPdYfyCuXm9f19Vh5k8kcbYqlE4dR9HI9nhmIgsaxjDsjDQTetS0DekNctVrISCCzu1oeUPookDcXluRp9ExsNOonIu3e+8UXKDwAjwcUzkdtT5
 9XNZa027
 y46aqYds8rhe1RIchl0IqYEKe9UpUhQkIRWJQHBfcWqyVm3uGrPCR6ZJW02IBEtIREJ9cKTOj8IIqBI8evzydrNhX+zRefSYM3akXHRBxYtu3UbrQTEILzv24QS5b5Py7BXUHEcAxVn1EZ63pul9SSH/srvUkPg9eZm2yOAMlfxHgA+mJeI34WzMlG+iYv3ZpTC0xPei/RPGr0DK17Kf7P0BYiyDRXhdhWWwT65xhYn2R/MUVLudsnFEwkUB3lJFuWcw5eYtzYw4BR8pytyrkzzmcYPgFsCgCqJNPPGrUJ2AbPJw0MGLIm4PX+bZBrJP0SfoDWwo+2+iwTlmRe1lSmZNR8Sl3wlDKkjO6DR/BfhLNoa+ht97iIbMNLnPV0kkbK0lTXrjwQXG9HzNorWGCRj6B3Ru66pdRfe8Q1A6C4EZLVNojYxWZLYE9cqrfPZJc+ezmYrUBl8gKbELibljZmoMzUU79sXlbzR8X+jTNoRn65L1qFYlgObBQsalv5nwWfp6QEF5GS6H6bU82ux2WbpBrgIbV9jH7S+O7uY8JR3s5L3YmPcpkjQhsxKrZG6Q+16Qlv0x4/XpTXl4ZABcZ1Ddbm5d6OgPuRpVqFMoDPdV3C0jJRpS/Jf4nSC97Mb4ma3jBZgGdL2jtxBERKTCkLqd7ghj96YuUbjIpL6s/7ONzI/eYgnsEJFBOBb+lFttWFlJKKO2q0bRkxhcANIj5VB+3TbVx1Opb0vRIz/DP38y98pdXthnOXs/v4xqoiZavNCjbAMAuGlMJ8QNTirdo6aqI46PswCzO2kR4A189YsObu5tGVyX18wbYmlm9cgpRTOBNxAg75HA816EbB00BO3elY8sZpvbfvzcrQOlOB6Tt1rNlfFZ1e2DO41JcjR4VuUP1g5f/dGNqTRR60LF1EBeHZxdPnEIHqNgcKfwDje00zusuBo7xQoeNQe++o6dUGzu+eKPXrAo749jp0f5FNAFgNo9P
 rlaWW0GE
 OUyjFityG5LzmCrQ8887eJb5VUCM+Th12GPRbggSLRVSiKW2u3CKM2uUG0VfYzw1wAUA7TSbrf4BnF3aY2rjXnaaQRrbw5OIfkXTl3IoX+Xxs0CIGdviTX7mzLbPqWggLHqoc+C/Iq7UIq9c0E94YWvZmRFcb3ScNkGxTNUqPyOneFcYfFplrS+abSSrqSumLEBCt1ElTe1DF1S2/izaUSzETss1cVPQxMpV+gC2VpcbFlrI/z/sPEekhR43ysqgn2Q4B4Zht32D4PhwYAy7FqrTBlQdVULS1mS5J2mLB1hGruxOuMthN1El2J1eRusR8d6Jjg3l+9+99Z3Umb/lR8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 05:01:51PM -0400, Zi Yan wrote:
> On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:

> >  Documentation/filesystems/mmap_prepare.rst | 81 ++++++++++++++++++++++++++++++

> > +* ``discontig_kernel_map_page()`` - Maps a single page, correctly handling
> > +  compound pages (if the compound page is bigger than the remaining pages in the
> > +  VMA, then only those pages that fit will be mapped). For a compound page, the
> > +  head page must be passed.
> > +* ``discontig_kernel_map_page_range()`` - Map an array of pages of a specified
> > +  size. Note that if the number of pages specified exceeds the VMA size then an
> > +  error will arise.
>
> Why do mapping a compound page and a page range have different behaviors
> on the bound? Either both do partial mappings or give errors when a
> given input cannot be mapped as a whole in the VMA.

Ack, yeah similar to Suren's point on patch 8, will clamp for both.

--
Cheers, Lorenzo

