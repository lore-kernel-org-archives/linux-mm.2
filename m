Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67428CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 19:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D3086B0096; Mon, 12 Oct 2026 15:12:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6839A6B0099; Mon, 12 Oct 2026 15:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C456B009B; Mon, 12 Oct 2026 15:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25AD16B0096
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:12:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB39E40F89
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:12:04 +0000 (UTC)
X-FDA: 85314919368.26.6B1A5D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0186C40011
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:12:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BEu0ArYB;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791832323;
	b=0Y6XfAo+wtnAI9zYeW2lF9fiJEcTjSl4XT/aZF7K8J+QU2Q2iJwNKb1KXXTiJZUsZTZoDO
	apMeolss7mdBZLF1UQhkqgkmBb8rwdBtmOwaxXt1Z4j8EILNgRsBFHg5QXFBnmSPpcRfPA
	h2xiyw+4mcsxEwYz/t/ui8JUNCNg6to=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BEu0ArYB;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791832323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5mO4SpyqVviWjSaaEv8n4NUJ8+LaAHDu09XG7kSbFs=;
	b=TvggT6QZ1QbR4th+RcSdlS1SQTX//tKYWRLfpvxbPbC3vN4/xiH9nnX+3/sPQ09Tqclw24
	gJ9vZNJMii69ufy9valG/CTvuDMQ7qPOISf+wR5uA7ABEw93TR4G/dBlUEDzbOjPp3AVhH
	aaEReP1Dkwll092ryc3aOvI1b+nAbls=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62F2460142;
	Mon, 12 Oct 2026 19:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B361F0089B;
	Mon, 12 Oct 2026 19:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791832322;
	bh=t5mO4SpyqVviWjSaaEv8n4NUJ8+LaAHDu09XG7kSbFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BEu0ArYB5XZKL/22X+idpyNhILy00Ml5Fj2jTZ7Fk/4tKlvNrtbcuHyIbatS1i6+H
	 EgraXbynE/kQHml4oxd8zg6gA+C0hu9dN4/bgco2QE++oQB5bH8DxThhNACrQfpLo5
	 XjczelQ46llI8hh5qdyeZlOGyGOojXJ0MYtBFM6yqvzpX+4jdT2meUTVQWDtflbCXM
	 6iF5pmWBFtkh91Se1FhzLeFVS17tfaVz+ddcjoVeEnKq4qW/b4a4Az4vnWO1vg7GEy
	 PxJnHj6TKtLcX2c2xZZNIY6SbIQi0/ch6peXKK7YGg1Kjv6Q5wlicS2sXtSXi+SohG
	 UEkXkdb5KImtQ==
Date: Mon, 12 Oct 2026 20:11:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Bert Karwatzki <spasswolf@web.de>, 
	Emil Tsalapatis <emil@etsalapatis.com>
Subject: Re: [PATCH v5 13/38] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
Message-ID: <as0uGOcxjg74Xw7_@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-13-923b70125b1e@kernel.org>
 <5b8ef0ce-7429-4d74-b4da-a0561c59b1e2@kernel.org>
 <as0Buhi_-VCC7xLZ@gremlin>
 <4124106e-c51e-4476-bd67-63e4641bf14a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4124106e-c51e-4476-bd67-63e4641bf14a@kernel.org>
X-Stat-Signature: eynz7texqq7bu56adbwysmufqi57obf1
X-Rspamd-Queue-Id: 0186C40011
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791832322-103425
X-HE-Meta: U2FsdGVkX1+H+qeRlrGmNeGtICEb6mJn/zsWpaofImcFtijdVs7vUeuUwqX2RtNVaDmko5nMsf6sB9MRuEl3INifpL46YRsZjZA8UUeswsRE2mIOvahSbpywuE7VtFU0jtjLCCabkCHPSiM5C+2cebkGseZpIqANIBk3nS0uNkK46M1Orh9+aJyUJxiEFaxwAWQZru+C6N984O52/fv2azQi3SBkYPR1p4WBxFiib9ac3E7QR2KsHU1kn60HjSZUikloD07nJPUSGZnoHH8AnglC7cp7O3GHIM6HnCsIKH4RUUqK7xOqPmTBb3rl/yMJN4KZJaxfFx95YWPU0vvs68/0Fme6tVE8VU7Q3fh3MxWubv9jVe43oxxOzxm2jRMR+dkHH1IRYQwjDuA5hsdZzrMbCtHxOvH11vPAScO8DhSIO5+cD5/XF0OICF4yvWfJ1lcQKFf/U3f2BjVaxSeLBOe15KEaOGl4vPV8eeaIonTG6FFkh3igEVuO5xJNpQpj3OTbjUaClQ7GmgbGdoRNOKUNJ5kMCvF8Aaqqx9qmkVwpt2U3TXkwcA6ebLhKvPcYfMSwJ4vvVw4mPyD2pILQV1tKdlHFPj5y7hX6NSF3crFhVrLXUiL68uIB8drthpgT80n75gg2AScl+4dZGTiBDPpMTaYQgkG82ktfUs0scuDVLRMHo6tNcL3dbAEMgTXS8Bc20UOhZnCY4T5CzP7L6MaLLu3vkRCeqIVkI08aFtwVMsc5yQ+U4vglFITviHOlPSAqdfD4ea9eBxEcXYLlAE6edb5R5N0xOW1NJYAUWJyM32BGsUJA2ai5RENeoZY5MJ08yeLqtDgH7m9I7/eFnHDQ4o9bjJaCGg7mpK4TMoZ6fgRDuKtvu9tShMmhsIEzheW0e6Ab3G7lvRskfDbQPjLT3eAEIqR8INwpO4136egrJKvZR4MCRy989JFNbnDstTQj/QlM/uOYcX79scC
 BmpwiHeC
 dpdWSo9l+UYN2viSP1O7ZN1JYex3A0fwthHatgZP/puZej8VnYoZ0oRKJb6EnLENt6Ge7xf5Auj0y55TF5wOSzVS7y9lexCeeUkUiUDcFPy9yExkp+NnQ6FO8IrCAIN1edfmBab/SQ+YFtvS1DYaU+ixmQ4gab9q13MzIHdtbZuxd95XbvKFcfnG8tV73yS1NRn78nAl1Xg0yZg/exCd0fjqlZtO8xNAA4zXp7Jc2M8Pax+nNOr13M/VN8rqBP9kZHd0QPQEaa6F9SMxu9Eo0TeaVqQUyIexDFLcc1+Gz01grLWp/bOkjZovuJJlu5YV6c2Hdv+/PMeOFADh+nrxi0nAQBXXv2HMknXb2gVSvT8tT0YhjIaoQVHMmC1cVdjxXufOJa26YJj88pw55gvdnu3uCYKyyxOtW6rQ8jW2ea9/nKl+XjslKx+jEhzjhxrlkmoImMPSrh2KD3nEBcLSVk28j385E49zNaSIMuLZGiEV+gvFa0R/VjMWXoWJXclsdLdBu14GRCYhTCZnoPYfjAHgNqYWXF8XY2dsP6/YlThhqrCzot5+3Brh3vL5yBfd7+tXMHLwg6JutnG2KdRdRzkvnRT8Sv7RjwC5WGnthVAJo5bEp7bhh9DVUAVHfHcDlmUvB/iDxR/6ikgnkL61c+9PHmOTz/h0nFQqyaMIX/hhU8qUGQllbe0Q2oSW1caJgWYd/0ek8BZHeV/yb7qUlDPyv7BZWYU0MzDwQgGi9GrOmFwmXH72n63qs4Rm3c4WupiLPiU0v7d0Ksd16/6/32HnscAyRZzFe0/HjCPkvCvwZ65ZDSLHyIr8YODFMGUf7f08DyrshaSWTsN6Tx3CHTqQS+MvceP+u6Fsc36veATUCDWc+AbE6yqS84XL/VgPqcCxmYH903PNIu7+07rN+V/4w3KcVMoQGFGQDQWITrnCyNz3Rdag8fvPVz+/WqBSsYumYWtLnpzY0Pl7Ko6/XyCeVEhpp
 P1rz9Yvb
 SSS5TOv/PNTOAHvuJuk7kE5ORjzAMVbESM5wr2OR6DKkqn/Lv0ZOE0cknVBwFwFdkt2lxixN1r68ho+OhvC6SD2W00R07W1oMXH7IjD86UX2yG0nBu8iA6LMh1bPiWRitW546919KVtMi/oDP61X5aoXTR4spHB57j9wFlPJDW3xYcvDe568tSq3Y/DlbOJc3h3V3hWzptFlO7MIWRM0nZ7/BaKapSAGBWN2TvizwI+mgHUFW0HxswSXV6N/mkNLN5iEe7V30wW/pgoSrqqpDzlHgQ+RzSTwHGoqTvrVMPhmly6bsy7yZHuC3EmB8BegapCjDUkpFzl/DSjvntC9qYJ67J8WOyX/8qS87/bIDOi43hMw2cR/QLsCZoMnCMEKS17qBGQWwTd/nbhG7jWU5VrKvT5Y0+FMu3/mh9CzUfIGDFeTv/S8EM4plhfT3XEfXjMcJ6jwZGlyGsXJrMq9CrlNYW8D1cBBvzyOYqKkMWP+ZLCTUkQUra39PnRSjxI6F8v1VA+AEtt0hJUAr5vcuoTsNoy2V/306zZFzP76GHicA8n5F1mw/klIJps7rBDa9SQxiXWD4m8ePh0M9XfdcBFttTIfHR5sWoqPV3jIsTilYPcz5cgm2Kf4eaiHBoV0215MdTtqptAGKaiMNjO/4tHVimfEHmNGX41RxqVTWK1rluVBlJ6QFtLYH/XljnxjjByXwcgSh0D/NrzQnwmfJ6By5SKPtqUkfizXWZK2cD90bqictZPhWjq9xa1JUv4ZDlWwMdvMQTr/AFDigw0O0EH5ZiYEo8X5sF6tJzW9E4BeJ0BrRVcyjKGfarY9b7ZPdu8FC9mCEO0yd1ivflfl6o0QZh3yYNp/rkRnbmlBhsYz4F1lApIpURZlfXwIAaOZxhVSXtnzL5Zlm5nZ8bdHkPgpfpCju5RqvnAPJcTqhFlsaXlq5cr/T0tAs0fyGYPrclfl4ev/JqBuEy/C7uv8YJ/YQfjio
 bKBkSGra
 z/56fgbgR7nmtn4xa6D78H59oA8hATYhKvtKBlwZg+ROypxShdw6Qff/e9p5ScqWdzLJfrR1JJQm1x29hqTMxuUuY8maFGCw1KPHNb7GdzayqRs76HV7pTc6wdT3WkqTG93mOOu6ElsEhBPYiYjics4ikiZlQu8Cyi4rNZntTZezNMgSh0DWTUM7nzgkIkPTONJ2JavaXmn2FCtKhnk6fGCTUg8p5ZMzX1RP0q8za/4eoZNIy7Iu6a0to/FfKBjrVKBkpjYr8wn4WgTiX9tYrfAt1x61kiSIctu9SY3oXlmGjgNf++1X6bRGbarTfDYUfY4CgysEmdWO1tyiZohirpHVlm61E95XaQ3hN52v6ZXDtdPpGF98dOIg6rp0ROiaV4ggOe09uKteXfv+vFzrlhTcbkOu8ycUxgkKQFU/it/n/Zw41J7Qb35O/h4AS9BDzRXsAcQi6sRkrj+GDg7l2XybRET/nvhj5QbmV7ZSRO9cLdIvV7n0Uvqc2z02xGu8g0b3flww6jbzyo7rcn/p5iDxzzx6cjJXJPPkELr/HYJTWJrUMvEHyNCUF3KUxb2pMUxPO1oUnc5vTmENU0tHjjlXP2QG3R5V6swKwpb1H1tiO2JikqwxVQO5aMY9JTgXXvPhTzjByyQKkadx894MHUL0VaN06hXZDQ4gaMSDgOxqIFjrPSJoVbSk6JtmTZ/NnHMFdVpU1dnlvyM7o7DGoKhgNIDSCLjZCDw3V3ZBKMZ3Y+nArVzHe88FYrUoMV/xwxJappq6kd/AAMY3KLvDiQLkPf7VtLt2tNCTYF7TJNUyiTwT58bIKr6tq5HKZSlk0gGV1GmMVEEsprgYPSKP+/loJnFvIXs9lyIeQjwjdCIv+FzXbR7wvUzY6A1PdUy+RJRM0043r6RvixczQZU+cTRn86L1OHFJ41fCtfdUu1RsuyNxmfZRVSgFgL7lsmnB5eVeqy9pwdh/NLSpwzd69peCxtQUK
 pptq/cqw
 M/mHidO8Mip1t7pSXQEn5HCkVVXMmgqVzLi+1Hydw/4dQNwPQJrIh6KaTPDX81lWRxeDY+l1Eb7dm+SEbdC6qjiRRex/TZWjyHklc55P5/zAEIcn1rTalAF8J/b0ODoViUOskF5lbVOrD7lkWgljniHpYSuSgcuK7/h/tdRMUG5DCp9WVPaGlDmXsrHpvw5oRzo70+GJ7ZekJvfRNUdlKX2LzH4obDmrHOhqYHiCimCgrcntalIAj2vwYKQRNv5dbX8KKUgTIKfYJkyz54VZ+IfYfZKmG0o4bIRgkE9CTOeBlyVX9rbZbhhWT2eZoPn3B12C6Y6bYoZQkjJmtf9P/tZgikZpwFW50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:56:23PM +0200, David Hildenbrand (Arm) wrote:
> On 10/12/26 17:55, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Oct 12, 2026 at 05:08:09PM +0200, David Hildenbrand (Arm) wrote:
> >> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> >
> >>> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> >>> index 7b6847200b43..b69fe5e34339 100644
> >>> --- a/kernel/bpf/arena.c
> >>> +++ b/kernel/bpf/arena.c
> >>> @@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
> >>>  	 * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
> >>>  	 * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
> >>>  	 * being copied into the child process on fork.
> >>> +	 * This is a kernel page so set VM_MIXEDMAP.
> >>>  	 */
> >>> -	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
> >>> +	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
> >>>  	vma->vm_ops = &arena_vm_ops;
> >>>  	return 0;
> >>>  }
> >>>
> >>
> >> Historically, VM_MIXEDMAP really just means: can contain refcounted and
> >> non-refcounted things. Everything with a struct page is refcounted.
> >>
> >> I think we are now changing the semantics to mean "maps kernel pages". I think
> >
> > Yes.
> >
> > It was sort of implicit before given insert_page() etc. but still really meaning
> > that it _might_ be both.
>
> Yeah, it's in the name. Mixed: pfn and/or ordinary.

Well the name is confusing as a great many users never mix anything, and it's
far from obvious you need to set one.

Anyway, one for later. Maybe a mask like VMA_NON_MM_MANAGED_MASK or something
better than that...

>
> >
> >> this is fine, but we really have to update the documentation (and possibly
> >> rename this thing to something more expressive?)
> >
> > Yeah I completely agree.
> >
> > I will rename it, but I think that's best for 7.5 obviously! :)
>
> Yes.
>
> VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
> 			  reasonably reconstructed on page fault.
>
> the description is already pretty clear. just not that kernel-mapped pages
> *must* use one of these.

I think mixed map could do with a rename because it implies it _is_ mixed rather
than could be.

But again one for the future!

>
> (again, the ->fault thing returning allcoated kernel memory is nasty)

Yeah added to my todo to fix that. Hateful.

--
Cheers, Lorenzo

