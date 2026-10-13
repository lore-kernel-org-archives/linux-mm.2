Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A592CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7096B00D5; Tue, 13 Oct 2026 11:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 857216B00D7; Tue, 13 Oct 2026 11:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9066B00D8; Tue, 13 Oct 2026 11:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 496236B00D5
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:20:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2203A0CD4
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:20:29 +0000 (UTC)
X-FDA: 85317964578.29.8A32EB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0DF4EC0009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:20:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bcRoxfym;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BUfFtYhAyallhL1ThGppaszMttiBxUZ9I5UKUNAaRs=;
	b=jktrna97SQycN3m7mRxoUW4apqXADLerR7vSSoJ6Ogw+qIPQKo1+u/YMrvl79E4tzgH9Mg
	2Crq+KT2NkX1OHZw/BI66rxWvh1jJAVt96TJKjAyVMJbg2yHzRX1+OjZd/ab36fh2WJPz4
	QkcMzsb85/fMnQlHhYQPGtGEhajwu+c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bcRoxfym;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904828;
	b=tpFqVQ0TICl6UbcH7YIi8DmSNBYKcj2KerVl4GRhygNIQQ4YuJVUA9u4D5j6jlOvTRTFud
	TnMZmQ2JmkTX4Mj/aBb1y11LKTFCmEBwMt5mk7hYOu/Km1pCxIrF5c9xEegUnMoj5gzPzz
	ChG5ixQfu3Q7pJmtLYNjP3wrR33V3jk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7CE38602C3;
	Tue, 13 Oct 2026 15:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683C91F0089A;
	Tue, 13 Oct 2026 15:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904827;
	bh=2BUfFtYhAyallhL1ThGppaszMttiBxUZ9I5UKUNAaRs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bcRoxfymrmBNpdgT8qjjHuAWaInfVu8oPj9XnAGCoqKS6N5OS4EDQAeF68mT872V3
	 BOjDyYFJjGwyuafSx6ZKaN37sQbT2o27R9MYK8WPMx/DhYXdoQ3nkeiEPa6HEm8o05
	 R3CwbJjfjy1I4L1eZGRPCTsVjEtjyHO9ZCbFZOKpd9mvPeR6q6pu/z/FxWR3pJOaO5
	 1NgqooDa6HNyPdwqc34xRYhhBtJHcid8SqU726MmK/QuSHYOAYaedMHPm122BpC9/0
	 Q2DsRlYpFhNMrsRyBXWT3z/e9MAFZo6eh5AuCUytVTAbkYjm7RqpkofQqq6w6HOXs+
	 K6Ipq7x6dkPJg==
Message-ID: <4a900aaa-da64-4f8c-9177-a3b126f06c5d@kernel.org>
Date: Tue, 13 Oct 2026 17:19:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/39] mm/vma: introduce and use
 vma_[flags_]can_merge()
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
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-2-1aa3c9b139f9@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-2-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0DF4EC0009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: pqdqsbtcx3ndhk7a3x8jex43pyymjhuc
X-HE-Tag: 1791904827-82804
X-HE-Meta: U2FsdGVkX1/KtPPcM+v/zAV5xUDgwdH0iQW6+lE8r7L0gbV+uva0iUEA0R3O4Vvz+bC0lDde3U3sRtU6A3sWe61IacDtlrsj3CxPpVFWRqxzYmUKCb2HXlfl5X8ICMzDARgGiHT8YtCO1OAjHsphMIHOk9Z/5xHJl9Jaa3kS2maWRo7VIXIc7jYqk4pFRCaA4T9D62w7Xsa4dztun27mz1kGNqK8PVzrqls2MOCOhrcTAdM2VT5FiFV0ar/40v2C5Zi18a67jNGZyhC8ysqhtebBeL3MtbbIwFrnvKP1NSBM9TozFGbktuuG73BBmWvB69lCABW4TH2ge5X/9zyMsyZx3NzrlkIuu7qKonBzWnwXDb9+JvQ5HbmyGGackNAgKOmvq8qfYwXxjlF/XodZk8UbidXiLaqJUZmg0f1QdMA7eLrT+qn6yeH1ba45h4PCnuHY+bzR6RihCVgi48iEB+l9uCvt0qQ1DFa2gGCDg9CuH8ZqJH7PtZZssLacbZQ++3u7oWo+atilXIbz6SyQc8o2PM2diIPRNaCQ7LIvG9UG0wnVtUbQGyvdM/2t21/BQWNm24pY5b5XEzLGT3EYAX3/VGGCOqfLGuODl4R3LjbjHNo593oZtC08yVKdqHT6FxCkecnO66Z0GDQy9WYrkzgFG9dfpvSx/7VZ5j9OS7HqdlMvlkswQ5bbELlxaOAy1NpZU2P/N8BT+cSjKh2WlqST7m7uFBhohQ1UBBl/HdGeDggO/MsftAr3KdduECQ5/EE5IwL2503KdxR45eazEB2useyhy8f024bH/x1GfxCX5Xl/VaYoeEpHjD99mxf4glX4galU0M9iPly6rNWeana/tU44Jj3l4KPShSIBMl7UlWKfGmRHjyGRto6XP9SgjQqrV4+i7o6Zh9hfOkUCpHx3Aen2R7opdrNOqtCjp7y69p8VFmwC30kx0WldNDXuZ/7wWnCXntJQNlyZQkC
 bfm1GUeV
 LkPJrMRiVWY0WFcE0DBMPnVM2E5FjePkCTvTTNjkLx0o8iFuf4+h6jsAeXdmvf/430ErffqhTcciovQc6Dc2r65NJXrmErpCMm5uWpBYPltPvgK4GaXhrZL1NnbcLdrW0FFqIM/qIcDO4LZiNRCVU8Tf68rlEjoX8+nmthr85ri4WzHl7i5KI0UBIeSYPZftdn/wy9R9Wv0utZWz0VtpxWyaYXatbkDJp8pFpTLm2Hm+OOM7XTRJVxNUkBxA1UCpqZUxIxkGHIjDXZfpasXqafFUPITinQxxlT/g/PsUKhZqSWpBwXi8/m3U26DhXV+5VrMftvv0l82H/5DFIIale3a0n5PnW1EeLKhuyey8M0L0SwZtxHumPCSV2Y8ymT2njE4mbBdC5L4B2wKYz016swwXHD5uAX0hlnP/x4xyYQm5ET9Sv91qqV0MwotIZck+/Bvzgdu+4HG78Gj+LhX2zkWk4uD1Yhh/9r7LfgAerPdjNkEdgLrQbcKPL5QiS1xZox0OZjlGrRyPt2udic5VBHTwulZdiJuYERxZy4ZN9iEjmgQMtMVWRwjNa8pZJapv0g4edfv+WyJGX41cc3kmwOuOIPfOR0bV6KaCeFBQ3K0EtXjtFr7VECpqQuy6BPk97/ZD5fPzMYPdQr4rOJExsnST8ML478qz3ec6s8xOXdm87g5C73mdxEMF+ITfRwdjbIPD5KJjOsGi7Nds1XZLj8TpYLCh4LozSLXzDL8u70gfuv9B1KeP1F7UjbcbvlNiIH5dlIlFWAKPHXchivJDy8hma1q7IUlsGeBHFnS2xCfggmrqyVRF8EFE8A34tdh7wngWdn92v8xsnkuWO6484/q5qTBKXB1qEJADHPso8HuYNVM3WgRKB5mxByEY0GtuqyPtHSE3MOR1lIXs36SK9ouqLcs896mnE4vyObFJoLeuYLYYp4EQmPtebg9uhRUoeLLIu5xOJlAsOdXDB+whdYFJtQqFO
 Cma4lFNz
 CIzVEQaoOPH8uPeCjyfsO2iAK/q+FVThfEWTMxgj8QnC24KkkGorJU+5ypDfWKTzfXjggC0OQbdu1u1h/0kosB0vwegQNwuKtCLkpBT/ONHiIGGmtjl/AKlXndQvXrqz66zVU6e3Z48KXcsmXfYgMgiaV0k6GWe7jK5BrF3+iWogKzgxovsQda29auruJO79ixOLDGQyTzAc/+fm69/d/RDZGBgCFXmigTxvYb/tZNbzkL2fcSEx9PgmJ5n1SetP2k2DcE/3W8x9vDm6jQeFoiQvUgaTPdk+l//VNBJXe18SAvBGlTfmomCGTs9EWV1hxulZr20ZqppTuU7oyxh6gCrYLxWZk0J9/LjXpuGQgyaLDnndAZNJcOhShoj+nDiREYKEPQ+ZCjug56utZREd3uso3a5UbWFbr2eZmHlVgZqaLFy/n0yjt7O3fpSGGdGXEkyD1/7J7/BD5pyQkdZg/8uf1kbalAwvoW8JTX7863S6IzNIM8k6oWMBMeKuKZlBvx3WkqlpJ8S+IIf8ImEjoLPYOK4AHpdp4AJNAr+P6vUlKsGQRbkuHzhzIjqVkNzIxO3UI4feqPe+0sAYSpyqpPPXvs5ydhL8CYcwFQSj8dChdu2ykqRRUMnIPaCHfdMfLoAGWJz8zL/WOJDZJsmaNVxfZI2Q9fmSgzXKJFiXIn2QTHaioa4z/3EkApGVB7HBlaOXSxzzFQWjhKpXErJlnM6A4g9WNlpsUghdyPHbmmEyoUsoC01A4skx8qV1HOck8uv9uBzy1K+AGSWxNyFGnk9rFyu3jG+tswN4NBGmgVtCjz9iBOKW4j55mWlDZt0NcDtvPetHtU3Bwo10EJvCqRRi9/K+ldO/ednPR9kcTsg5pJajVPinifa+zHe0mrTBLcTyxF8xEGu4aTAfotEUKPv79aL/dFl2y5w1e3Tb+fUkqtFTFm3DZCqtAHo5oG+vlLSAG5ZhW9pV+Yzg1wkfpswSo+ByG
 7NCJ3xGt
 YcZDSyKQF9pzVA0QzHDuQs9CniJ4rplw/MIijwM7Cg7ksi4Q8lF8TCSGa+0MeeEPHCxjFBVblX/j/7HX9bz1pn4XATTCbSQEztHpFToj8ctXdirbDo0cuBRkZuFLs1fj8PxDVrdhBeZqrKPkDriHI8HJFlcZCWm1ACMeWZ3E/lWYWQfXd5xeUHPB40ZhlKOfYk+XT44h2jX/A5hYv1yv+HPzbRuoENSBuZ3X9B+WpNviktCCP73DlaCcfrVa+Qjm1c4P4PQgHcgle5BOIPloU7MpcnXZxTq8JNz+m6wct0K/q/QF07Q2iFIrzNIpq5wh7nHeNTdEQDqIkyLffmx+n1qdI6MYQOcEXVnLXXuOc5xxSnVU0YPX1sLGM2yUttdPcvuaZ9GgH5bB8URwin5nrHs/0w+cHJBBTrYVMnx53z5R+2hzwBdE/X9xPBsxJGMgqN8eFJ2sFUmZ36T6OaEplmcx+dirt0S5BQIG0MeS/UtAuQf58Lih5DZzc+tolwf8Cwj+EZZaQVdVIdtxlb9VSBQSlo7dOpP8Zgi8CnqJ3ttx0Isvx/qzGinnmu442mWfBghSgFUoi0HVGC1xwnV8Tx3EU1JgA0z73xO+QCKavFRNF6V4kEBOsxK/hdGFwhTTxUBjW++dom2qIco5l/EuSPXgBw0qXvREkqQAAtfcxY7gX0OLZz/nbU/kIw4XWGSLBrBSf6DqmUJN/gxadaGpEiNW2jV6exvMdYRPCDSI0zijdptmrHqmt19yWOIn4mCC/nBaMU4+nrszd34iQkHOpin3UIqyZr3LdPqAJvGBZGNFTPhKqFYOAT4RoyXQvKk06y5qKWz8LjC8X1XKtpBpjcYoJUQi49ZWZFsHXaikjwkg98Kw5/WNDyazF/bzrTRK6jnGOfHUeynbxYdXi2/axOu8LCe7dH5sb3S1yP22Ptwrh4miLD3OcAbbyUP/v2OoUlrBlkwWr7XsXK/5ihKZ0Mxgw3CEV
 5sz93C4h
 ffAGg932Sf7cJMeRYFFDY6o6B4JaKyMydEgeHFJ69X8gUNy46f7lzRpfKgm/ADFzmvwePmzsZ6FVPpSW+Z9P3zVNI0unCp3/hkCBpU1FzOnSzLOLPRO+0h4xTJK2oMZxwmduQwsPYinFgPHm9gdvs540CCIQnR4UDTemd2ak5UuLNXJbBt2tczwLpvzgFdwDx0stCT+HO/moo57qUiJ/23hYhytKans5tYTZK/EDlz7Rjr3Qpmo9B0U8ME+SDtZSTvjruclxFNWct5RrKGY5Eja0zaNM4/IPIREh3BbbqchWorp54sHI/svvTh9cQ4SaG59Ij7Ws5YdsKeAmoCzKUdkWc9TaGeUrF3FDIjyivybj4XmRJ8VYunEccTesAoBWn9rusKIy6D6adC3NiaI6UG1dccCZLRTZc//wcrN9W/ivl7WgqbqgkseoJ2d255YhOEzIObeh/+6ee7u1+TTfaQ1Gd8fPKODb8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 17:04, Lorenzo Stoakes (ARM) wrote:
> Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
> two new functions vma_flags_can_merge() and vma_can_merge() and update the
> merge logic to use the former.
> 
> This abstracts the check and expresses it in terms of the desired behaviour
> rather than an arbitrary and confusing VMA flag.
> 
> This also lays the groundwork for making further improvements in VMA flag
> usage.
> 
> Also update the userland VMA tests to reflect the change.
> 
> No functional change intended.
> 
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

I'd have called it "vma_mergable" etc, because "can_merge" makes me imply a
"with what".

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

