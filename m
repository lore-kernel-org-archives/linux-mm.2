Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F497CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 07:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53A0D6B0092; Fri,  2 Oct 2026 03:12:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA036B0093; Fri,  2 Oct 2026 03:12:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38AA46B0095; Fri,  2 Oct 2026 03:12:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8256B0092
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:12:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E8268065F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:12:07 +0000 (UTC)
X-FDA: 85276817094.08.542D96A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B818C140005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:12:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L8MEP/YK";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790925125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cedB2m3RAchjlfQYkaoIE7J7vyn1KCp2q8/Q5Rls3zo=;
	b=IPrBajCXDWRulSvBBR488rbtEQaf9vJbUDNL3tzSQhx0YNIhaqQlujOLpDf+NI9zoYFWa+
	hgyTjbo8lwdnloVkBPmpdIeSex6A8sVS2MkeRsabglv3BN59Jgh6ZgFY4xO1EqsROQxMI1
	6cjcYLt8Mfoa/9wzEG4pyQSz9/xvHco=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L8MEP/YK";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790925125;
	b=hQbgAePpWjraxRVL771wVJ/5VFRTXXQq877Qq1QHpRbs3nOSzcRYSr/g0FJbh9vAUc3ZOy
	9Hkz/NMr+MdIziGX67iHOu17fMU9fuHGJ10zcL5SPAMdg9YzlNv01PxCpF4OSawE9YYDx2
	4nPM+tiL65yp56ur0b+J2LoYUZPir6k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DFD204307E;
	Fri,  2 Oct 2026 07:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950E91F000FF;
	Fri,  2 Oct 2026 07:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790925124;
	bh=cedB2m3RAchjlfQYkaoIE7J7vyn1KCp2q8/Q5Rls3zo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L8MEP/YKI8YHXtEpt1bt3ZVJY+fYQqqHYKcsB+22zDD7/Lcwip51/6ddFK4DhwYbK
	 lvEFm9zfBhouolD0zO+zdPPcTbK/08BQl+89us0SMmB91+bFfvUlccZ+9aa/m1Pwk6
	 Xy9LVd72bQIhr4LEKfimoj1LvYPuWsqMtZGARImX5TI0Hdzl6B7soQhEdXvUmtVBJ+
	 tfI3G5IjeM4zQ8ogf1+2dF1+ALtEBoYAaeu1p6kG08GOAuAtJKCY0LIqVcWZKxmVvc
	 SOZ3zOet+EA+8fNEyHAZ/v1BIRxjrQU3ip4sRMQ/abdOUJmDWOexjMq7gKGLm19G61
	 VzRRqqC5DEtkQ==
Message-ID: <fda08732-f500-4bbd-bb1a-af096e33002f@kernel.org>
Date: Fri, 2 Oct 2026 09:11:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 39/40] mm/huge_memory: remove vma_is_special_huge()
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
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-39-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-39-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xixmhxrbn9cochdsbhdcwxgkygmio1yd
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B818C140005
X-HE-Tag: 1790925125-56039
X-HE-Meta: U2FsdGVkX19jDeM9v7YmYjyx8HHiiXFrF+fxIlACczlAtzev8oz++I4WKmnJFsy2DLmB0S8wdDKUEmDEo8EKpaeqQ58PRHVgTQxu57EBpMlke6b9mObJOdYaG8i2fNXeXs79JvkwdGBDDK1A41S3JKlfXJxpdfb6Y+gFXo8a60W8k9StD1Wuv1im4GEDpcsUADF156Zc1LcLUCjnrSsEJkqvwTVP5x1j1Lr6+7UGUMbHWzNexx4iwXVivXgvVF0rv+czZpWaF76YbXi0vlx1GVTD2RLlHFjgxrMqkGlDbqzirfqOzF7vk8g2Eqrzk5BWykNn0rI1Hm9KxV33/ZyCEEzky2HWDwZXO99DbjCQkHLpi8V8WiTjgq6EwyeuQW0nB5pbN9gjKmlP1rQPxJqXEp4EmRV+GpLC7sKY9/o3L1qVuMNkMckaPM5+HikCtl2WnOAvfl0tWI42Qybos2DTNuhhe5nDxcue/6grSmCRRDCImG61DnrDRE9eEMDptHrVNcW4BweHG5NI+eua38OueD31gDS3nbptMQT4xjzOAPJzxYpueJMt8NY32NlVKDv5dTQcbfdJKZO/a1wzHwl9snkS3fkj8LmHVm15TCihT0fQhw7iO5RlYiT9kh++IIHVt4sMaoTOfTjU4cg3rCmK1J3NmfcGdDeL0uqkR0jfGdPUsAXHTW3lAUk4r/4xttLlZMVv85HcH7CvGln/FbZ2SAAwJkBRePkRG3ikZR0I4JzwGS0rUcCyrDMnmzKhnepPvOxWnP/Gek7gvDprteMayPhbAw2g/Fci+HQTQ5iwrcira+eaDNZWakjdiJ6OUJr10rvlc0dsv/QUjmzn/NF7nUhyI/pIu46ketYMBjLbccKFgGW4+HR3vn5iTh6xi/AVWQmYwaA27bEze4Ty9HBdi2PUS6icUx8HA9yAl284krqrsEtqcto7BN+8wYA1Z1XcDxDX93IZ0l2sWHtjR04
 ufewx2H9
 IHo2FNH+EG62nml1l0W+0SstG0RO2Y7m+kk4x1BIQp/smeLsi+I+l8P3cWpL1IkIKG8+Z+tCQVB2y8gVP0VG03bD6akpJICjiQx0j/iu9yDhFUV/jHVZHSUrl4LznyEFjrskrowLX9DaNwfDz1i2KeEulQpvpyo2BKOQ8xuBEqD2azTIwW+fl6UQos0I5W2OsdIlRtFIxpRNQ9kLFLIMud8JX8UQkbMeotrGnAzJYCVT2XVmHEwwVbEip6wkRFuPo8lC21eChNhVqzSmx/lWwjxmb7mt5QSWfj4NH5QFx/taFJ11CBfnCS55NPiMYicJkaBZrIsn8fF1uywXxhVaVpokokgCF7r0hDD/RitEifh8lFDZZHTiCTsXL+8u1hP2gN0clrsBtPrHOyeoaq/r076sMYGbI4Tyavaqbgkkbb+c/sMVUJANvw8MKpH7FWbMeA1vyydwOSnjOrJrZppOVTsle/3gU7Um/IwEKpS0rXeVDki+ynn8U+K9JSaiZ1X/oUF1UWGGzhvH5Xs/SOLTMe3YzW0oXwIGNvTHvSXBUoKpWEwmG69rX8wFb4dTxH47Z3KLYSUiRh4rB4c3yS0UXCFTfzr1x3sWeQDnMLIFDHhFbL8aMuMET3Dq/uIgDa+OyWUEa2TRj4m3qe/KXTMJm62ikdHsUhqLbcWLIU4bNR4r5x8wZNPpnxkGoT4kYwKn/lX1v02kh5J7nQ6Akw9sxTLxNxiusXH1j8/aquQ725PrPcvVeqGcX3qrffBi7k2h5dO+tNTI4fmQER8OLFBwrD1OA5d8rtLDgq6F0nfUY0QqE0VbAllF/UMzVF+hRhewjboUpEOvas0NAwI1egmnNZL91TR3157sM75zlS/XLROWecHaV9QzeV/0gKogiRXf16oRf5bi2mh3vmoqElTh0iSQ92uzoB7clhBqRaNwBk9YJSmOWcE82WyjJQYLoJFZSKiXAwmPcI2yMl7s9nC94g7mWKf+U
 pk8fo9Ep
 f6MNOfGTf7YlpkmI8c5r6XSHWjob1+RichIRoZ+XAbLDTC7/dQUx+jme2qx1wk32tXdiwAwQVcKL8LHhj5xizPNQpi/JFAHxk1Lh21hX4bDzlaELWyXCiQ4+LhaCq+fh4+OCKQgL5c3bPUDgyU/Zkd2hdxOMxTxpfol3BHEq20DqJwP9M1EGNg0+k/CC079ty1wbPMIo7cABLw3Q5SxcVr5QW2ZxETtMgIcPUXeJ09ND9Dhvg2pvFxTRy4/JirOfuAIq4mVyhNAM2QvHk5IK7f8QdtcpB+mLWGZzCCIIyJmFD79h3Qa7LU8GXu6rE3c/bXVae2aERa+4ZbpIiwWdZ7YsShwuM/N20imoGI+U6Ikur1my9pd8VrpeYnPnGSqq8u/Ul4JPQ7WcLW9p7bB/9xF8w+v0vg9odbhHPsVhR0J9f24BFth03iMzdKrQEqs7DFahTV5BMWh9jWjkTI6ytbey7MlQ0HOYHTLZi0taEQzHtG83GEpnOhFZNVwq+/RYAQFbo5PDmHo6Znxbj1qstK0Ap3MLGarQCGGayZz7+1DtN9rTu+1fNElhNmXqp8EuRKxZ/O1ZQqsWXJ7HfU6pyAdAOktt3fPlxMmuoU5/NabgtC+yGc1Qn+y6Jl6Sl0YOlutzTIg1mgRNGqLK0wAB62GAszLjo9kT5eP4qLOUO3DVunGmgeNhD0K00bBmezml/fdFAmxvSMvroE9PoimXJ8hjs6Jfxafduov8fcGagW7jwEkNXtsIWoFtTBgQ/Itp88OVtvZ/sCzN7FvMgMdroqUuCR7cQjmTgK11K1sDlorYDwMpscQHyUqqJePnH7IEc7ziVoBQAbSux0tBUowP7rKJZEMG+rt7OiEKVCzE49sh52xF5WIGg5cJ2kCv8dwk0c1z1eRXD9ko6mrg+DD1OEqR6YJHITp/XFBjGTtrC53uAn2ea1fjoc7d175UwCXjs9oouCwe6uLDzMaQt7366P9aEIzaT
 2Z0neap+
 SNlKBhFc40NEma1/sR8r2CmV95/QulHvMilceML9iQgksKTpOA5j4Kvv06UC/1zZD6tHsD4faeAtj8x8XcrSjQttxRndm0IZtBgXyO74f4WY97hFJg9qvzFmU3YudIE3yEtWZW1o/66UH+lLkrx6VTC8CpG56CP8dKjPkmEzvsvgcrq+FvBq+bLE3111dNIFiSXr4mA3qbk+n+Fky1JWMlynf05UHobNqobcYRUm7yRXzTRzD+2D7QTFoYAI9+mFhrDKCiMIzJmXcLmMd0cMEAfGPY+Ig2Bv+CZ7vhk4I4FstpF3AS8yg0uAhV91KprLuT3huZDouMMB3L+GkEE90xmIq0b3dHv9Ti2zVF7CS5mxOfEUa0a75ESUnARml0JFgezDQhQvSqTBUZ37BOInuHR5JB9hvhfMAwiHdIROmMdpO6GXL2tphBIHurUgORNAj74Mmkohf7s6S1sZaRJv9AbrMDNCi8HWa4p6eUfj1u34D9/vZCPsezudBH/yLpF+I13BJ8ClSsx5Qt2aytz4AfFLNM2y6zsMu5qOqLDfwqVVRuqle7v863ZUUFZW9ARxA07VnyseEba5sT9qzwMAdCYICXTo0UM05e4MDboBwk7jTXMYF2CyhJdg/bn+t2hRrWfm4PDkFh5APOnTbhHLoJ8r83N0lH7ZrSXtd7Y1N9GsN7/vfdbrEHtDAhWJTVISAKwIUwi0wwDj6MXz1vrbmKc7ae0En6oOYxVyYj0CjIXpj8L2ItYc3LwugSJ7MzBrFGWbBiR2SgyEs32HBaxx/IGvxFHuGEkLNax2PN+ZOdOPGKTzUHT34bZ681cQrY7ZPVgWNWtjG91CwIK5cRRSm2ShMm4SQMIvOcEm0+DBLUZ5mAYCg0O4/JgY585g9gHg5iBMhdy4cBptzJLW9XSqFcbUjawcc34hDEu5NOJBDKa5Zjyms+9rJvRAlpcZgs9xrYovc5U4S3gX5y+D8quwbdiwig4mc
 d9f5XwG/
 nOv2HrQF/fFl3yNDf+1qRTkvWU6PEWPT5nVzxoOFkScE3K7t5wuER8+JhNvnyIeygRa/B+Ma5YXC7iTIUYp7IO2aFg5RkdEZ9JvLLa3TNqXDMWq2TS8nsLt7dGAdeIe7eQmP9QMqNGRZUUytDtr3jFkCGlEVDAHd8L4mkxb1LqUmJD/jPCUZ8FbAYtVO1MYMH4Y3ppc5Q1Tp5skTHhAsWCzl/zaVkBldocu8WFkpVHZrwXhsGCwzRVAnjOArv8qXJvU0Xhb4TkBhB//v1EFtXti9AulHxypX8ERhxfS+9GtzKtLZdWSYVEnU35v3ETvEBwZzeRQEhsyoyCV6sM9rmo0pD71g9vbeEivCSGuW+C162wiSz/gdmn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
> VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is a kernel-owned mapping),
> but with a DAX carve-out.
> 
> DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no longer
> required.
> 
> Therefore test for vma_is_kernel_owned() instead and also drop the
> VMA_IO_BIT check, as it is now redundant since it is enforced that only
> kernel-owned mappings can set this flag.
> 
> This also eliminates another overloaded use of 'special' within mm.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c3c98ea672c3..3cb8e2d4d65c 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -110,14 +110,6 @@ static inline bool file_thp_enabled(const struct vm_area_struct *vma)
>  	return S_ISREG(inode->i_mode);
>  }
>  
> -/* If returns true, we are unable to access the VMA's folios. */
> -static bool vma_is_special_huge(const struct vm_area_struct *vma)
> -{
> -	if (vma_is_dax(vma))
> -		return false;
> -	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
> -}
> -
>  static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
>  		enum tva_type type)
>  {
> @@ -192,7 +184,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  	/* Check the intersection of requested and supported orders. */
>  	if (vma_is_anonymous(vma))
>  		supported_orders = THP_ORDERS_ALL_ANON;
> -	else if (vma_is_dax(vma) || vma_is_special_huge(vma))
> +	else if (vma_is_dax(vma) || vma_is_kernel_owned(vma))
>  		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
>  	else
>  		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
> @@ -3066,7 +3058,7 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
>  	arch_check_zapped_pud(vma, orig_pud);
>  	tlb_remove_pud_tlb_entry(tlb, pud, addr);
> -	if (vma_is_special_huge(vma)) {
> +	if (vma_is_kernel_owned(vma)) {
>  		spin_unlock(ptl);
>  		/* No zero page support yet */
>  	} else {
> @@ -3222,7 +3214,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  		 */
>  		if (arch_needs_pgtable_deposit())
>  			zap_deposited_table(mm, pmd);
> -		if (vma_is_special_huge(vma))
> +		if (vma_is_kernel_owned(vma))
>  			return;
>  		if (unlikely(pmd_is_migration_entry(old_pmd))) {
>  			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
> @@ -4765,9 +4757,7 @@ static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct *vma)
>  {
>  	if (vma_is_dax(vma))
>  		return true;
> -	if (vma_is_special_huge(vma))
> -		return true;
> -	if (vma_test(vma, VMA_IO_BIT))
> +	if (vma_is_kernel_owned(vma))
>  		return true;
>  	if (vma_is_hugetlb(vma))
>  		return true;
> 

So good to see that horrible shit (sorry :) ) go away.

It was too hugely special.

-- 
Cheers,

David

