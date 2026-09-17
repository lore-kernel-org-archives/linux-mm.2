Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7776FC982D3
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FDC26B008A; Thu, 17 Sep 2026 05:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ADDA6B008C; Thu, 17 Sep 2026 05:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250936B0092; Thu, 17 Sep 2026 05:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3ECA6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:34:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3125802A1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:34:25 +0000 (UTC)
X-FDA: 85222743690.27.FA78EC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 05D18160004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:34:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ncq//vPx";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789637664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uo7+xpUESC4/Wh9nmp10T9dtdzzBLaBKi8SgiW52Kk4=;
	b=GlPoQePrKZiRQB6xBC9uGsovm4HmO61nKN9xTB6kIZEcAztvlttUHg6xE8Rzhtbx243dqs
	tfUK0VkPTmOQCjmuJdSNGMADk0/YnMSO6olo9sIDoA/QIN9fsSexeCggRX0d4dZgb31gxf
	uh44KLRJUrPS0uuugqpnkOJ6NWHt4J4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ncq//vPx";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789637664;
	b=6RUbmfXgGSfYMV5eAcqj36v0o7STMNqrPQ5j6ppN96m/F5XCMOEpl76vrBtEEwXue3aMgc
	zXzL5cHcf83f5hVk31MNdIdtWF/r77UxQd7bEkSsI48OAVvyEBN6qQMlnSN8b+KKC4jCmJ
	LHpnwwPJ4rb2YNFLC+KflzKCqO03l+g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A247429E7;
	Thu, 17 Sep 2026 09:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AD61F000FF;
	Thu, 17 Sep 2026 09:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637662;
	bh=uo7+xpUESC4/Wh9nmp10T9dtdzzBLaBKi8SgiW52Kk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ncq//vPxo5KTfgIfY3yk9hhZC6SrgTADMM3nsAWg60z7VM8oH4orbZURS7bGHB9yG
	 n3o0PA8rtbmTxDYIJwetJ0ZC2raoqkCU+tgd2/SgIDmXvp9Ie2lBNN6GYF8JfCysf9
	 hLU5oq4hROQRHaX311aqmU2KpPT5mogMwoUO88T9AvM+vTuNvfR4jN/PmRSooygsUA
	 qXkmlsWkNVH6zMect3N4QOJ0+TkrR8KTxiYv1FS1ewDbHC+qfyIeXbVgY1LIWKfrhu
	 szwOunHgTHKOnDzdZbYLaj26NYWbYm3Y4T/NxXbD2XZf49FMtgTI4GrbodTZvgC7TN
	 ph6gyZaJ8fY3A==
Date: Thu, 17 Sep 2026 12:33:41 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>,
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
	linux-sound@vger.kernel.org, bpf@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v2 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <aquz9Z9JrK_H_E0g@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-1-7d9781ed5361@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-1-7d9781ed5361@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05D18160004
X-Stat-Signature: r4zrks8jhmfshwda7tfu7nkd85tuk4ox
X-Rspam-User: 
X-HE-Tag: 1789637663-523320
X-HE-Meta: U2FsdGVkX18OXYLDAmqO3jZHKqYzdz9y9lBCPjIU/c/rqk8ZKONoKJAxG5mw7Me0pku4k2vZjjOzVDurAlkRN7JMZ6T2fW/oJsNl54BnDt6IpodwVSKT/YFDmeLfp0I73dUYU+zON4lWq6yroS/m+uLLZEqdzFvk3zLarfV7ehK4CBtFILfxvRtPLrdHVmxlkveitdGjw/fPyYxY5YAHIU9lMsoXGHNLNlSk/nEcKjmgvMVkoi/EhCxuBY92uOdUb5DjfBUoAJ+DIH4KTC5+EErR0SfprzvceGwWc2PHrmAQYwKJD/6u01eRRPfWGzZVX55qIcInQ9AFuMF7Ha6rpAfAh92mOn/MDT5NNSBT/MFLMJFiBcInsl6f5Du/BZULSZxzwtX4D4OBpSLZ8KwD10jY00PT+I/5lmCDlzaGnrhEYFGTvmiuw/QyRlQOSDKoNpkcHTu1N9KhP/PAzJMgvOeekZjl762uPF4brwyne5OMX4BYNBBuEzxuE4NZ8rq5PCJgvmtO1Ab7u26qVQKZ4slx86pnLjXrKzEGjU6hDto7UX4L+u9QhWVnLiPhSwhxVcOjdu3TgOfE2KdlvBW7PIATGlX9pw+iI/Ok9kvy5xwY4ycTj+OZUI/3pTitlSfDimEkntCWZj8tfT7A9MyB2tlE4IZJQRj9rhrhfL6RWQbJF/LZCFngyqQJLmjeWoGJXwJXi7hv3lzQdOGSiShN9yADGC04dLvNXqIrLpZ7+6vzeECelCcUNKttWwAtO5NP47zmsb6f00BkxXT05zomrjeNpqLeWjMmOcJ0qULAX1mg8mHJPtuvwa8uJ/mjTL3chWOYDUrGIcKpTlP9MwsLDO3nZZN0cC2creI6owhW8x45fi6meA6Fi2QgRb+Xdn7XPzsj0uoJ2C9PG9lDBMytbSIB6kkm7c3CHnDWXfuZROtKkiR/maTCeDN1wOQZfv2xBeyhPESQpIu04lsxDxw
 dYOmkaUE
 OM9OQ0D1byba9gdv7bsX3djXm/YX/+XBF7HUpLM6pQFDIGZKpDvCQnr/JCXDIBgHrXVfYZ79jOP/zdAz7ykPNK3AhiwxRrxevX7khTfAnZ0xq373ww3oQinoiIz7JeOMHNR2IuoO1iKdHMCKHegkG5vyo7kdZFedEoeU3TYifDImAEmlQAQvl4ThxNBCgACvO8SuTZSBXSWGQBx0MalCwo1lCBHAFl1e/XKdP6j5VDdv595wWkIDZbYt9ev5A4XS7ki+XVXVYB2nXPCvAuo/0n13D+8GeiNOXHskyMxcmI3Y16Vt+NkuwLkABETp9ocThN4ZJGhPmj2cWzh6TGAN7co9n71SZuknETWUTqrhIVijmAkfWbmrl0xFOsA8dWMykFM3Ds15OMdzrhbwijGHOFL0yXG69jqRldfGXx8NwQMiprexOPUK14P5oLbeZMkyNlYCZZU480cz7r23l8n0C1FRh38b823SJk8zjZBIuFbQIIKCldtZRGvymGJC+y3FBkU3FRSLHmAFFxyQDkUBfY8qeLPfFLT4hY6oJ4a/XVYvuHf6rV7WgvRz/j7tEIOFQemv+0FDNei5LW1gyDimUtFaG/SanJHSBXWofTFHks5S+cIW5iF9GrbJm/Vn57ypMsaUhaX9gsC7BwzCF9jc/QHh80wzM0jfCp/k1UJpQ4F8zerIxB/uFSRJTcRno2FLTUTucslMy5ZReMn4/kNuI9ZI6D67bVPcrpVoY0IFGFpoIYVLChu63kgTj01AsXIyfmcjI4X1MpOm6LjSqYiQoNJ9fjAhop1HwLMkCISpXf4jGOpYY6ghLGi2GMQETAgtpL5h5P66fs4UjNSN9LWcsb1BUJJBZlG35F52Be/YRqXJ00iqw+f82CoxDNzwy0CAlOPvwdQSUVS51ZpBVLVJpto1otM4qIw4HAQqdRUXKsdjv0f2AfWSVyfRQranKz/vO43rgXLnhynBanjayeseN5NqPokkV
 ZSGxww/b
 VcVEjmIvoFeXMNm/1Cc8wcE23xReEqj9bcD+dBB/wPmKjqIccp4D6LG600FlEUgcYXiT93c+m1tHsZa5S51Fom7ge14Yc7fejOzDMTnR40tBjpVcaFxfgxcbg8Vma35zhu+G0T4DW3UJGhFsqmMeLjjKWosluluH3bR4iYEC7KyVdHQgVpBNNlo+VDFJHE0xidXb9kFuNAxsTy7/weZ9mDAA3WM7qyzfKcEZ66cC9YygwIf4aqitmtJy+QseRzNm7CfSPJBxEReLOipCkNbS/IuknHVH7v5m4rm8zWQyPn17YpG6woX8chfnpIh04lfzLLPFe+NJ8/cGw185sJRhCu5P5y1sV2/O1mfTnJJsYDfDrAryNtuZzJqZA/+/r8S/eytOoe6wWwM/Qs9oenc23YHnzcGz8Ng0UHV9BXoT87Ljs59axIBM1uRF6GccJ+qMPCNlmeX7LZ+UR4X5nHfQUe8SsALo45E7NpF0nTwwJZ3Ny9rnHdQgsMRFnTUjR4ItIpX/BX+Sj4GS9AqSQ9Nr2jva71tCCKjjeAGOEIrvRv1+PyMDWE31yUhZUlPwbzYFdcoxl68ueDUCDHKKsPq6+ag3H6AJvQE3jdRBSiTwg43z8W6Gmshros8UaN8ZYJwwj60sMdIP/iEr8jzfr/F3MtCKrzMc2+YsK4yX4z59JVzOwp1uNxJPyBk33NttsJ+mvr9s5zuGuk/wmLCKNNJovFTbKpLQh/PCHeaZR2ZjC6J0Fmy2sT2/IekpoEBM8aAOeIQdkOskF88Bn7UZr1yX6J6SO8Qik5UJ6gZ0TEo+LvRzaphQCK72MkfTpkKzkI12+y3HZlQMGyCE3/AFIbDAUX4GsnZ9zUX1gTe+gA8PAQbf3zlrs2TlxOpmovNCrCqrLkx90S57XXxzE6fEXYxvzlCd0kPYehur0ExyW9zZ845Aar5Sna9AEGPQDFESTX275DQ0JzYpypLepoYyFf3ZPRwRhnjIb
 r9D7HTLE
 QPlMSww57IBG0Ucyuo3SLRlcBNXJjNFDjGZtXIYI2tn1X2A8cH7draCoskTAppoV7p6sEPADWeEW0JHnutBvm/tuJv4dToQFKbnOScu30mM5OgONJ9MBMSDe2KZYiRPrwD6sS+UvwzkYvrS3WTTdfLQ0MDC4AQqin6zTIHihZJ1QAgVgC+02wq+YmZBh2Msy5NV06m+L+x+XBhXDoPp4kIrnbc5gAcjAyKiF22pJbd7D1iefjvVyzxGKdjW8FP0AVnGum/VPGkUL5bEV0TO5MpSl9DLrrlHqaRDZeaUNl25H1X75jb9gdGvmOLNsNgGzrHkS9Ew0OIlBXBOGivcOSpPXrj3IbIsodnsJ0NuXcIQ9tE1dZFF5V8JVZgLVEYw8bRvf1pvTi+95HU+NwxigeC66V75CZH7YZPNj/Pf6xNmG47M0b2XU23BanABRlNzdFPsfCyDaEG/jO9AdSX4QVEJkTrr1pl7OgZo852XKPfVJt5BRXXhF5EvGurXoFX7m6xQIqwlqj5nrYCuXZ1Ou22+JvmUXRgzssf7Mm1kRS3boYNk0n8wk5fqoRlLiAiZA7dYfwcKxpphDjpj22Ncg+Qz1TVG9j2RrJVsqZCgtfixRxJ0oFqHTx5OiohoiNqn6qYALsYOtGpQcnjHU9xRXp2rQkIbrGfaAfxI11Tafgj3tQD7S9+TH/6kdx0z4I3KVkc7ZFOYbxnbkL35njXE37nJs34UOR6dXDncA7wC7J6I/vA7d61Vm3zTiqSFiPaJ0dGS8NQlbrBd5Q6T2+iWFHfZhATdYq/C09kktCZnXsXcJJKa31IBbPylWJi9+4Eth+DVe8UaIJK8xKYMOkJJb2hOjJR+Miz9YuuZ+CU67E1ctLrolr8bxK1ZjMNQtxJREp0XSZGoG/ItKIwRDjcj5VDZwZ5Ad9bUUGe4j70svypFK5GUtM7NMYbAqxUB8/zDo9cGOx/DY03MbPeYg3mL2qq+5VIcsY
 6KZ7Xvn3
 LwYRjYhsB2LSMxTXHoglf70WJpoRBWhaQ5RGDceYajxCSLPDol43o1Ba590GJ/DMtCwLqN4nFb18CgLvtLiLBS8Ru5IoG9o/8atJe91ZgXFuoZ9fnkawuti+TS0kJu87+7tJTPVpxe+/gJuwUMz07veapjH3uB6ARUsoZJ6SsmTNk94r5pHENITH/uRkjfTuD98HplqNR9Sod4IsMUnwdroW6afsIRvCnLTwpbfOy7KBW+BAnP7B9rLSGP3eC7lluNXiwCHhTlx8bsVrtWNI/nOhN3YcCN+yddh3y4+X5UEPc42kE1nC7iV+OjpU/fHVwhK3g8u+gPJgKRWD1UFpPoK9Xl42CXvajOAvCQsOno2SDUZdmLpmj7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 03:57:21PM +0100, Lorenzo Stoakes (ARM) wrote:
> The map->file_doesnt_need_get flag is confusing and the existing
> implementation has holes.
> 
> Drivers are permitted to change the owning file of a mapping. If they do
> so, they are required to take a reference on that file.
> 
> The mmap() operation which ultimately invokes __mmap_region() is guaranteed
> to drop the refcount for the original file the mapping was made under, but
> this is not true for the replaced file.
> 
> This has been addressed so far by tracking map->file_doesnt_need_get, which
> is rather poorly named and unfortunately fails to correctly track whether
> or not an additional put were needed in a number of cases.
> 
> Make life easier by removing this flag, and instead drop the reference for
> both mmap_prepare and the deprecated mmap callback in a new function
> put_map().
> 
> Track whether this needs to be done by aligning mmap_state with
> vm_area_desc and store the original file in the map->file field, keeping
> the updated file in map->vm_file.
> 
> In order to have the same behaviour for both types of hooks, only drop the
> reference __mmap_new_file_vma() itself took in its error path, deferring
> the replaced file's reference to put_map().
> 
> To make this work correctly, map->vm_file has to be updated before any
> error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
> set this field first.
> 
> Also when mmap_prepare() changes the file and is then merged, the reference
> count also must be decremented, so update the logic to call put_map() in
> this case too.
> 
> Also update __compat_vma_mmap() to manually perform this step for stacked
> file systems using the compatibility layer, and update
> compat_set_vma_from_desc() to replace vma_set_file() with a correct
> refcount/file update.
> 
> No in-tree driver is impacted by the incorrect implementation of this
> currently (no driver that does this is mergeable for one), so this does not
> need to be a fix.

But the patch iteslf needs to be fixed :)

It seems to be the change that broke the CI.

The rest is from LLM, take it with a grain of salt :)

mm-ci mm-unstable red build - bisect analysis
==============================================

Bad commit: 2a937a04babf1 "mm/vma: fix mmap_prepare file handling, remove
file_doesnt_need_get" - first patch of Lorenzo Stoakes' 40-patch series
"mm: make VMA flag semantics explicit, eliminate VM_SPECIAL" (v2).
https://lore.kernel.org/all/20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org

Symptom: tools/testing/selftests/mm/pfnmap.c triggers
"BUG: Bad page map in process pfnmap" during __zap_vma_range()/vm_normal_page(),
seen on process exit/munmap. CI's run-mm-selftests.sh greps guest dmesg for
BUG|WARNING and fails the job regardless of the test's own exit code.

Root cause:
In call_mmap_prepare() (mm/vma.c), the commit reordered:

    map->vma_flags = desc->vma_flags;

to run BEFORE call_action_prepare(). For PFN-remap mmap_prepare drivers
(e.g. /dev/mem), VMA_PFNMAP_BIT/VMA_IO_BIT are only added to
desc->vma_flags inside remap_pfn_range_prepare(), which runs as part of
call_action_prepare(). Snapshotting vma_flags too early means VM_PFNMAP/
VM_IO get silently dropped from the resulting VMA, while the PTEs are
still installed as pte_special (real PFN remap).

vm_normal_page() then sees a pte_special PTE in a VMA lacking
VM_PFNMAP/VM_MIXEDMAP and calls print_bad_page_map(), producing the
splat. Confirmed: crash log shows vm_flags:080000d1, missing VM_PFNMAP
(0x400).

This is a plain ordering bug in this one commit - not a driver-conversion
or vma_can_gup()/predicate-logic issue.

Bisect method: built/booted via virtme-ng, ran pfnmap selftest directly,
restricted to range 2a937a04babf1~1..0a80aa0fb08f1 (the 40-commit series;
tip = mm-unstable-2026-09-17). Pre-series commit: clean. First commit of
series: already reproduces the bug. All scratch worktrees/branches and
bisect state removed after; mm-unstable-2026-09-17/mm-new-2026-09-17 and
mmotm remote untouched.

Diagnosis only - no fix proposed/applied.
 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/internal.h |  1 +
>  mm/util.c     |  5 +++-
>  mm/vma.c      | 95 ++++++++++++++++++++++++++++++++++-------------------------
>  mm/vma.h      |  6 ++--
>  4 files changed, 64 insertions(+), 43 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 0dca33db068f..fe576d468af4 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -7,6 +7,7 @@
>  #ifndef __MM_INTERNAL_H
>  #define __MM_INTERNAL_H
>  
> +#include <linux/file.h>
>  #include <linux/fs.h>
>  #include <linux/khugepaged.h>
>  #include <linux/mm.h>
> diff --git a/mm/util.c b/mm/util.c
> index bf0513d1d3d0..016932780925 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
>  
>  	/* Perform any preparatory tasks for mmap action. */
>  	err = mmap_action_prepare(desc);
> -	if (err)
> +	if (err) {
> +		if (desc->vm_file != vma->vm_file)
> +			fput(desc->vm_file);
>  		return err;
> +	}
>  	/* Update the VMA from the descriptor. */
>  	compat_set_vma_from_desc(vma, desc);
>  	/* Complete any specified mmap actions. */
> diff --git a/mm/vma.c b/mm/vma.c
> index 55917d097933..a319a9fc2f29 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -24,7 +24,8 @@ struct mmap_state {
>  		vm_flags_t vm_flags;
>  		vma_flags_t vma_flags;
>  	};
> -	struct file *file;
> +	struct file *file;	/* mmap()-specified file. */
> +	struct file *vm_file;	/* May be updated by mmap_prepare. */
>  	pgprot_t page_prot;
>  
>  	/* User-defined fields, perhaps updated by .mmap_prepare(). */
> @@ -43,8 +44,6 @@ struct mmap_state {
>  
>  	/* Determine if we can check KSM flags early in mmap() logic. */
>  	bool check_ksm_early :1;
> -	/* If .mmap_prepare changed the file, we don't need to pin. */
> -	bool file_doesnt_need_get :1;
>  };
>  
>  #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vma_flags_, file_) \
> @@ -58,6 +57,7 @@ struct mmap_state {
>  		.pglen = PHYS_PFN(len_),				\
>  		.vma_flags = vma_flags_,				\
>  		.file = file_,						\
> +		.vm_file = file_,					\
>  		.page_prot = vma_flags_to_page_prot(vma_flags_),	\
>  	}
>  
> @@ -70,7 +70,7 @@ struct mmap_state {
>  		.vma_flags = (map_)->vma_flags,				\
>  		.pgoff = (map_)->pgoff,					\
>  		.anon_pgoff = (map_)->anon_pgoff,			\
> -		.file = (map_)->file,					\
> +		.file = (map_)->vm_file,				\
>  		.prev = (map_)->prev,					\
>  		.middle = vma_,						\
>  		.next = (vma_) ? NULL : (map_)->next,			\
> @@ -2447,7 +2447,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
>   */
>  static bool accountable_mapping(struct mmap_state *map)
>  {
> -	const struct file *file = map->file;
> +	const struct file *file = map->vm_file;
>  
>  	/*
>  	 * hugetlb has its own accounting separate from the core VM
> @@ -2496,7 +2496,7 @@ static void vms_abort_munmap_vmas(struct vma_munmap_struct *vms,
>  
>  static void update_ksm_flags(struct mmap_state *map)
>  {
> -	map->vma_flags = ksm_vma_flags(map->mm, map->file, map->vma_flags);
> +	map->vma_flags = ksm_vma_flags(map->mm, map->vm_file, map->vma_flags);
>  }
>  
>  static void set_desc_from_map(struct vm_area_desc *desc,
> @@ -2506,7 +2506,7 @@ static void set_desc_from_map(struct vm_area_desc *desc,
>  	desc->end = map->end;
>  
>  	desc->pgoff = map->pgoff;
> -	desc->vm_file = map->file;
> +	desc->vm_file = map->vm_file;
>  	desc->vma_flags = map->vma_flags;
>  	desc->page_prot = map->page_prot;
>  }
> @@ -2586,6 +2586,10 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
>  	return 0;
>  }
>  
> +static bool map_same_file(struct mmap_state *map)
> +{
> +	return map->vm_file == map->file;
> +}
>  
>  static int __mmap_new_file_vma(struct mmap_state *map,
>  			       struct vm_area_struct *vma)
> @@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mmap_state *map,
>  	struct vma_iterator *vmi = map->vmi;
>  	int error;
>  
> -	vma->vm_file = map->file;
> -	if (!map->file_doesnt_need_get)
> -		get_file(map->file);
> +	vma->vm_file = map->vm_file;
> +	if (map_same_file(map))
> +		get_file(map->vm_file);
>  
> -	if (!map->file->f_op->mmap)
> +	if (!map->vm_file->f_op->mmap)
>  		return 0;
>  
>  	error = mmap_file(vma->vm_file, vma);
> +	map->vm_file = vma->vm_file;
> +
>  	if (error) {
>  		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
>  			    map->prev, map->next);
> -		fput(vma->vm_file);
> -		vma->vm_file = NULL;
> +		if (map_same_file(map))
> +			fput(map->vm_file);
>  
> +		vma->vm_file = NULL;
>  		vma_iter_set(vmi, vma->vm_end);
>  		/* Undo any partial mapping done by a device driver. */
>  		unmap_region(&unmap);
> @@ -2623,7 +2630,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
>  			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
>  			vma_test(vma, VMA_MAYWRITE_BIT));
>  
> -	map->file = vma->vm_file;
>  	map->vma_flags = vma->flags;
>  
>  	return 0;
> @@ -2631,7 +2637,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
>  
>  static void map_set_anon(struct mmap_state *map)
>  {
> -	map->file = NULL;
> +	map->vm_file = NULL;
>  	map->vm_ops = NULL;
>  	map->pgoff = map->addr >> PAGE_SHIFT;
>  }
> @@ -2643,7 +2649,7 @@ static bool map_is_private(const struct mmap_state *map)
>  
>  static bool map_is_anon(const struct mmap_state *map)
>  {
> -	return map_is_private(map) && !map->file;
> +	return map_is_private(map) && !map->vm_file;
>  }
>  
>  /*
> @@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
>  	}
>  
>  	/* Invoke callbacks. */
> -	if (map->file)
> +	if (map->vm_file)
>  		error = __mmap_new_file_vma(map, vma);
>  	else if (!is_anon)
>  		error = shmem_zero_setup(vma);
> @@ -2797,36 +2803,34 @@ static int call_mmap_prepare(struct mmap_state *map,
>  	int err;
>  
>  	/* Invoke the hook. */
> -	err = vfs_mmap_prepare(map->file, desc);
> -	if (err)
> -		return err;
> -
> -	/* It's invalid for mmap_preprare hooks to clear vm_ops. */
> -	if (!desc->vm_ops)
> -		return -EINVAL;
> -
> -	err = call_action_prepare(map, desc);
> +	err = vfs_mmap_prepare(map->vm_file, desc);
>  	if (err)
>  		return err;
>  
>  	/* Update fields permitted to be changed. */
>  	map->pgoff = desc->pgoff;
> -	if (desc->vm_file != map->file) {
> -		map->file_doesnt_need_get = true;
> -		map->file = desc->vm_file;
> -	}
> +	if (desc->vm_file != map->vm_file)
> +		map->vm_file = desc->vm_file;
>  	map->vma_flags = desc->vma_flags;
>  	map->page_prot = desc->page_prot;
>  	/* User-defined fields. */
>  	map->vm_ops = desc->vm_ops;
>  	map->vm_private_data = desc->private_data;
>  
> +	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
> +	if (!desc->vm_ops)
> +		return -EINVAL;
> +
> +	err = call_action_prepare(map, desc);
> +	if (err)
> +		return err;
> +
>  	/*
>  	 * MAP_PRIVATE-/dev/zero mappings are an ancient way of getting
>  	 * anonymous mappings. Rather than allowing these mappings to be odd
>  	 * outliers, simply make them truly anonymous.
>  	 */
> -	if (map_is_private(map) && file_is_dev_zero(map->file))
> +	if (map_is_private(map) && file_is_dev_zero(map->vm_file))
>  		map_set_anon(map);
>  
>  	return 0;
> @@ -2845,7 +2849,7 @@ static void set_vma_user_defined_fields(struct vm_area_struct *vma,
>   */
>  static bool can_set_ksm_flags_early(struct mmap_state *map)
>  {
> -	struct file *file = map->file;
> +	struct file *file = map->vm_file;
>  
>  	/* Anonymous mappings have no driver which can change them. */
>  	if (!file)
> @@ -2868,6 +2872,20 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
>  	return false;
>  }
>  
> +static void put_map(struct mmap_state *map)
> +{
> +	/*
> +	 * An error occurred or the VMA was merged.
> +	 *
> +	 * If the file was changed by the driver (which is required to increment
> +	 * the replacement file's reference count), drop its reference count.
> +	 *
> +	 * On error, the caller always drops the original file regardless.
> +	 */
> +	if (map->vm_file && !map_same_file(map))
> +		fput(map->vm_file);
> +}
> +
>  static unsigned long __mmap_region(struct file *file, unsigned long addr,
>  		unsigned long len, vma_flags_t vma_flags,
>  		unsigned long pgoff, struct list_head *uf)
> @@ -2922,7 +2940,10 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
>  
>  	__mmap_complete(&map, vma);
>  
> -	if (have_mmap_prepare && allocated_new) {
> +	if (!allocated_new) {
> +		/* Merged, so need to drop refcount. */
> +		put_map(&map);
> +	} else if (have_mmap_prepare) {
>  		error = mmap_action_complete(vma, &desc.action,
>  					     /*is_compat=*/false);
>  		if (error)
> @@ -2936,13 +2957,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
>  	if (map.charged)
>  		vm_unacct_memory(map.charged);
>  abort_munmap:
> -	/*
> -	 * This indicates that .mmap_prepare has set a new file, differing from
> -	 * desc->vm_file. But since we're aborting the operation, only the
> -	 * original file will be cleaned up. Ensure we clean up both.
> -	 */
> -	if (map.file_doesnt_need_get)
> -		fput(map.file);
> +	put_map(&map);
>  	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
>  	return error;
>  }
> diff --git a/mm/vma.h b/mm/vma.h
> index e97bd2dfa786..f15faa83f3d6 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
>  
>  	/* Mutable fields. Populated with initial state. */
>  	vma_set_pgoff(vma, desc->pgoff);
> -	if (desc->vm_file != vma->vm_file)
> -		vma_set_file(vma, desc->vm_file);
> +	if (desc->vm_file != vma->vm_file) {
> +		fput(vma->vm_file);
> +		vma->vm_file = desc->vm_file;
> +	}
>  	vma->flags = desc->vma_flags;
>  	vma->vm_page_prot = desc->page_prot;
>  
> 
> -- 
> 2.55.0
> 

-- 
Sincerely yours,
Mike.

