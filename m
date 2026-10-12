Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 861EBCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11726B009E; Mon, 12 Oct 2026 14:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4F66B009F; Mon, 12 Oct 2026 14:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5E596B00A0; Mon, 12 Oct 2026 14:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5FEC6B009E
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:49:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD1B91613F2
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:49:21 +0000 (UTC)
X-FDA: 85314862122.01.9E4630A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 16D4440002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:49:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S5Kydjjv;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791830960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjF42amL6Dxyn7QE+tOpdln0eb7clnjUQooAdiVZf+0=;
	b=gQ03erYFwWhC38fT0tGMkZoHlD+PlB8hUfjtyWAtK0jq1jneca8G0YrLrBUfEvtqj79v5q
	pf7QIdNGxtfMKiKYeJUXyzIkctSmYqTXKaHDuFd0Q/ywdxEHW6kknG2ZHZUXiAwZSL8DlC
	zVuSy1NJpCfhCLZSMLxxesXZDJMA5BY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S5Kydjjv;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791830960;
	b=N4Ck3AE4J022qCQQTZoT8dhX+dzcYMax7r5tAYWDL57q6DE6c37/s7XkfSPuwPHkvcsrnB
	jZm5xsjXyf1xPrZf32cjVuP24T+cfYJC59Raw/eqI520fYNd2XTZE9O7Hgz/1vlgOJaA3x
	QqzFLjwwwVTyDiAPE6DqVfYC3bEFmsI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6152743C68;
	Mon, 12 Oct 2026 18:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB4E1F008A3;
	Mon, 12 Oct 2026 18:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830959;
	bh=wjF42amL6Dxyn7QE+tOpdln0eb7clnjUQooAdiVZf+0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S5Kydjjv9MS5+ikIdcZLMtuInYdV4t+V4R8UcdwFfxkBeySjLpbFVJq8LB6YxCqkr
	 WeAECYnx1xgOH4BCK5UKPqhA6vX63IsVR+EXTybK7br7NLZ0u33YyIJ0w63zopC1kg
	 GU+kcsTw0LbmCgEp5zsbb6LxKiUHFIKAoePc0l+qoejVs3yioGigw3j4rdpAoRlJ3I
	 /cUbiiAInDyjl1r0HL5sbja+XefiWr/RVW0+MJ3r/tslGXWsYEcvK/wwGhtCVMUb4u
	 wvTis4aZ/ONKs/Wu0zQSkB08hCtETluDlUNZP//epzAHhx9+9SCh4NVSRJMN9uvwGR
	 v4bYjBEhcFCPw==
Message-ID: <a8ec0313-544f-4c8f-a161-5200d1cffe13@kernel.org>
Date: Mon, 12 Oct 2026 20:48:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 32/38] mm/madvise: use predicates for madvise(...,
 MADV_DOFORK)
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
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-32-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-32-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 16D4440002
X-Rspam-User: 
X-Stat-Signature: 4c1reqgi6px4cra4qsc5b4jmsjy7d31j
X-HE-Tag: 1791830959-461618
X-HE-Meta: U2FsdGVkX19JPN4OfHEuS8KdvMjzU3M0O9u9rX3aM2JPoRW+o+XrYrPKz+7kXjXcqzVh85IjaQa1c/kIMMJzGWwHtiSbDeIz+CepqdvVbQoSx7fZDdT3i6oyD14/Mj1j7wAU090YgfSLCeHLjRWUjeqXRuCtVZtgKWoaIpvPSBFp/bTRYeeNJGh6ajUlYNy6N8D35E/IhBlfvUoEbDvnP40SRNVvyKwJaLSnd10kCjaOBYFGlnDRZ+j6+fp9gBL70AfbFwRbXg+8FZfHPgiX7/+OEcNR+eTY9jkT8XCfGWa0U5iW+DU3E0aW0OytRLZWIH829NVjR2NzEWibEzz5NR1A6tQ3buhT1nPSRdW3sU3BZZKmgkGlGFyEW7fKiar7CLcHSKhQS5OOHNVEcA84pn0OHRZnHYoCG8gNIRNifhV0n7taWZPlFrHkmoabpQihtPaURW8EU8l1J0QDY7PtcuCr4mhCCIxiN5Xognv3WRrDyXrZl7DluUKs3ukQaQu6kdKV4Q0tdB4mxNnZIdvPnZh/uIu7TE6XUiGGzvTTLtEj3Asfp3fAoO6Ffb3qGqaV2a/8m1ynN0+HK52svLq3/ECcwF+r3a+aPoU8UrP7S/VfFoZ1rvT3iYLxNZERCWxaQKiD4xd7B/jqpe8AFV/SoBdXa5hBCQ/tpHpZksR4E1HOH9UTOSyV/JrBSISs+LTyQ5+t+1KXOdk4Tt9Sp6Oj9D2VhRNci98H+bUrIp6aQ/VRQHgrRAURszsLiiidCWIPElE98DSXbQZx5ly3bjJ9SxhCIM/Hox5m4wMbKRTdvBH/qjA8VaYCqwigjATBvsgn3WrDu17oBuF8UOIz3+qrN+3EsbUiybr2/fynBAtAVVoXaF8WiWs+qxq/4IGXuWyQHEvAYGvqNwxg+RKjNY/UJH+2imGiiMo7+D01Lwp6iSr/wflgM88vcP7xzfONOPlDDVeQYEr4oQdgbxNwD3e
 acllNPHC
 SKc2C2pgKDjildyMFofyUw3yq1Kd/1ens0+eQTbxPZ4pe+Pt3eKd2ly2SdA3h5Rq8fX3bwfnl3As2XVdY8QJ7AlUunI8VPAETxa86JaoR7VwtHgo6JuxnRgdDyBN9PY7OGNRSipPU4eAafHHR0j5FWyJlLYc6lYIhj9fDsTvxtiKPgpjDktgnHvpPuMe46MjaTa1/Yh1mwmhPh2g7X670qM485fAV5/xKmNM9SlQu6a1y3a1HNhKbTNEyuNsNFZ6dzrq6Di7Rv41T6ww2WzWgNDhMk3iGQXfJqTOJCdxgfKMtEJghSQ0dA/aA8oJ0MIEVGIly6tQHk10/f8ucPDOKY3QyeaVxmbM2+MWf4Ac0GFINLgAh1ZEmYK5n87u/+yFY3n5SK6Pbqxv97gtL7+eLT2oEMCSfvUcqCHGJkGXmehL2qrV7/cYKNSPmOaZ0oMGzJmS0CWIwr0j+fS5NYgKsjVEIse9TRonyRvnlsvbe/tfcjsl1jVJr88BkCq2fHG9WQ3TKzTvhovknolDSKL0O6GpI1p4XgxRDCRBmFPnV8ERF+zua2rFlbqZXKJxGQsVX5gvUdkEG5fcGpSo1yhK7DAEDwuFYxOS8E9AXDnTGvXFj2ClYLjvgAsIVaEeHlmEK7K1G24N6GkMqNv36fNmSjMYvdA1kjrT0wZuYPlEMQx4zIHeY91dZM7ZiyxiiABH312OIq2MPaYKmdEFt2VLPmezspNGTN6qheb18OXRnzZETXuXNPIUB5UOsNnGdt4Bf6v6xBGEmso1i+IR07oWqZ/dNpykfqvQhONx5cs2kFe42kMPxwSnwEAbnRqLZxL9TCt8EnTyCrrmKsNgjHf2OViX2iFT8Pj0fp6wzLRF2waxp/CMBxX+tSfSIL6wVo5Fv2nnuCaDepkX3RxnbiJtf22FqNCSlfqOzUk0+PUZGqz1ZZH5bofM69d11OTqxR5peIGUtrIwB595Dl5sjnwSXZy7cTeXl
 VyGRgl1k
 kvU9g6DBCDNV8UR4RHdJg/ygAb/ZSDfCEnW+K20XVJywnsOgtgpdf3aL/qh7igwPCPfZf1zfqJBdUWj1LBe+XDgQBGDYFEQ/U6PMw6NmKXBycEdJjzm9op96vgmCVQfXIyBPHROuA5Xr1oxLHP0oWyX2qQSBM2/EdLdo/zqHVu2ELcL4wymcEsrOmSZNpFhUInP9aiQOViASeqJbmdlnABT8AkwJb7AitZ6MLAmP138qUHximYZY0uaLOiMevaYlZRXCKRLDksuRL2dMiLrALx9HhZ0yknemLgZs/cC67MTiBOU6jeX0+QRjYXQoYx6JAzCgp5OPzhAMyLXeBMIft02p2QUYqPqIVZRhY7C4cQJDOjCY5kodfDtHkQUFYyPKn4oGlmDwMQGuxKjMmE5ZTNtw+SjXWq1tasURR54MZebnMjMQkQEST8iy6chkBle7PMRLj+0ozc3RQHwcd2+PhjDGCp8TG7cmosS18G3Bh9zGBHjzgzGzJN3HGdW+JZuh/w3i3FzqE0IujSAR3+fpXAGla3VDB0D/9ZXz9ZdI1Hie8wMy3Jb7UgloTgffj2wYaxei1ERfAjil/hD3FpbG1WLJi9jm8tKDFVWMA5nVu0FFJRfnYR4gwNrTxi36Ri4fIKSV18K2L97IxKDlxlEzsq3yDp7ar8ltwgXFyvH9ivutqfWWqHZGqWpfmelQqIcU6Q/i0uE+TQcIBoLVS0nCxqxz357p0eWHjXMMfl2Falu02vJmNs29xD9Sxji1YtlCYS+bmkoRc2JynZCSvPGGSnTmpaw916E2m4Z+ApOz3IewJeKo4nY8VIDucrCEumYgveX2Flrd8wnBA9ZgQSvrM/DsfMfhMTa3TTJX5erpKdNBrwSTH/BoYqUzrqtB643YBXbj39u+Fe/p/WzksoO1TdnmRXj9B5AbxcqrkysnUkPD2BSTMn6pN43eyiBwLwPUc5oN4QbsFVGQ9Bp+i3P4R/ZtegvX/
 t9h96wEB
 io9TZkcI1XUy55b3PD43JM7pkZiKdjNgjozWkSY7GajGaEVNp7Pb56ukbOXWrnJywdvFMg2i1GPOxFDIaDvdOCdT3YxrLFhQyI1QNhVkWwQT8ZNOW6kcOpl8Raa8Css6zKAqvdIFasZohY2/KptzJTF6L4H8QJctAHu7iyLC0jX5ay3HV9mE4eRsSAOsJn4tooiz0VNbMewJl7xoz08IecP0LP7xioKt5BJLyyXsjaPIlOX2fj7i/ljCbdJp6/cnn/dPMDQ3/49x6iVQGZ38EencYFjNdMuzaCrL+Y8aql+d9McgTXYkszXOcUSiM2h8lBGxrqY/o1r8xKpSd9O3jfhAiwbDj3uv+U5wXdXr5cKq/EE19ECFftn8QhjQMeFDBMYpJMMQBSb5uEJEDz3GUmJpbcOof0OzH7V+5PgM1MpyiOybjfhdcFBG4k2Pv7TFXmLn9FdufwpWjLgY6fGtWR5ubhICEboDiaCYvaqGZ90rNlFbevtMUsP89OkpJ5BuGFSBDVSF1wYyaK6g8YtlvQaQEyH70sI1v9ak0GyE3MiCVUQgqrdbzb85LmwZkBmm42k0tq9ZOkqIWoakx1y7/hJZ+jf9yxcuQhg1pseHxNkHVfb6zeXV/bhRMTfH7PUPDV7fUjkNwUfIcfatpeukBt0tmsZ3U3PDIfI+8kJA8Bl1K+sHADapi1wyzpEtf/7VQa4M57WONHP8DmDtiXLsaBL6iiidfMQ278PQdC37fEEcvsml/1ml6SXe3wgB5aJSkDqt+niHvQQkouMCHu7m5mHRbTmMnYxs+kihEwKCxJtxNLnmnSWCahUTQLpML7YupyxXgVyBMZgKmwQ/ReI3EgbnJrcOQDwX7RcAQGH/8qeTjU2PMSmwY6XRdvFGx5pcvR5kKJitQ7FIHaAqmzAPyshJnWGMbQ75Jkj3haR49OAZDh2XKGePTq6/A2wN2TyHw4QojlKV+m05BlvyfzxLl6eVR2yat
 dPo0ONyF
 pABhW9cSBALiGqD4tK/2ur6AaZHbRcHqTQqL+YSwTpRsx1rV5gLGezLXai+PjkgdMNLP4aosUtBO0mzoU+cbMH22qHrlaUJN8bMZVrgEerwR/5cZZuZWm/EMF3DsntDYnYjRcZs6gBeP/ja+uttNZkjjVLLIa0WMo/wmA+mDDXhn+zpCkD5ukFUSKg1kol7prkOeX6IHnhC/RynHZHhYd0Boodnq8vrOTLT5E/7fItKTekDYJ435n0XsPpOs2ABbU7La1yd8P5rSV4ETJwSgjfPHPNp2XoWUm31Fn3lLUE0jyXGis7MJr++StVLUkQLXgPf58ATFDVLHmnHwV+uktZM4KhBjW2mgHK645jfAuMe2Wg2aSe/gAwmLeAUlyMFkRj8JGTgd3nyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> Make it clear what we're blocking in MADV_DOFORK. Previously we simply
> disallowed VM_SPECIAL i.e. mappings not managed by core mm, fixed mappings
> and
> VMA_IO_BIT.
> 
> Now the invariant is established that mm-managed mappings may not set
> VMA_IO_BIT, the VMA_IO_BIT check is redundant.
> 
> The rest is equivalent to testing for a fixed or non-mm-managed mapping,
> i.e. exactly the same check as whether the VMA is permitted to be merged.
> 
> This was established by commit 0b2758f48f22 ("Require (reasonably) normal
> mappings for MADV_DOFORK") containing my hands-down favourite call out of
> all time.
> 
> Express the same thing differently - if we wouldn't be allowed to merge it,
> then we aren't allowed to manipulate CoW behaviour on fork.
> 
> No functional change intended.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

