Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CE42CA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23D356B008A; Mon, 12 Oct 2026 14:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED146B0095; Mon, 12 Oct 2026 14:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091C66B0098; Mon, 12 Oct 2026 14:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CEA596B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:07:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69B9EA1223
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:07:20 +0000 (UTC)
X-FDA: 85314756240.28.7FC0ED3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id AEAF910000C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:07:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wt6owd8B;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791828438;
	b=tZP84VGeTEuvmDGnxMLXuqjD+HKVKL+UHBEBk61fWjXSffk2S2gorX5jd3n336bwAUQyAJ
	IHVW1Bli6Jl0MdB8qAWU1YggzDf4VGSioFLE5iRVRaix785wox6JYPpU45EPUJuAlbDpZK
	9PThi3ZcH2N/0rB11Rmnn6lXEeIqBSQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wt6owd8B;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791828438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDDaNaIXKmjLMpGyOKitw9HvqeETc7OKRNfzQD54qxg=;
	b=0wsdVSv02oYL/6D9KLQ7/vou/g5KQI3Ak//tBqyMrSQsoEyGx0G3odqmFwKxpAgNBO2Lae
	BxEyPSNOYLgLcQzo3gGXifO8t5mTWFm+nR1Jx0moNrwhPQSNIW6prbDV2xWD+nhlNucE2P
	Pc2JbZKJ2fdGT3IGV9rPlKx96vg5rJs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA39260142;
	Mon, 12 Oct 2026 18:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BD51F0089B;
	Mon, 12 Oct 2026 18:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791828437;
	bh=DDDaNaIXKmjLMpGyOKitw9HvqeETc7OKRNfzQD54qxg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Wt6owd8Bq2u9/nEuC+sRUdT8+/OxfpX/2L+rcI0CI58dMdj5RepHEkZ+JK0a2NReh
	 sfWZgwJnlIoxukhvfsVC549Mea8Lzn1FqlVFltYJjt8rHvk+/6/ZpWr6udcYD/Kvhv
	 cYjJbTjIOah993HBTrzgv5z/AR+B5YNtKjygVS0MFHVStaBZhTHGGs3CePzg/YUyKR
	 PxwC1y9KuoLdaWY3WCk7m3+ezYcwA/LnfPWK+S1wgKQ+eOE1YSCAXB3bijg6tQO5JH
	 bHdtiENWAtXTXun/ecBlXYX2L4beb5ScOKLj6+Nr6PliXK0IY5395VSWd+QtTd+iS9
	 TJQjIG75WdKXQ==
Message-ID: <7554094f-d853-482f-ba82-3e2f7b1cf4a0@kernel.org>
Date: Mon, 12 Oct 2026 20:06:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/38] mm/vma: add vma[_flags]_is_mm_managed()
 predicates
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
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-14-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-14-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yqkutmbqua9tstscxb8j6b7591167wce
X-Rspamd-Queue-Id: AEAF910000C
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791828438-116943
X-HE-Meta: U2FsdGVkX1+Gdlrla5RDMeu4QvztQbnNd6c9x3aISQWkEClIOyDKXwj/h+ajTd3q0d4VnaTmEBpnkZhZTPQXeJEU0UaSINXhBEDgi5KfU+DMMj5JmjyETo1W+ty64mI0izmpS404iam9Hmyg0QOWLbHBvBm6elmSzRmUAJl6Ixe1L++v+dSm4P7chckpmGBtefiHgHdK8Qd9tukfj+Z93mZMXXf4b0GilHXmBwd3FO693LUECxBJN9jLvkXH/QCBf4xX11EYtdaW9aKOfLqfB5RBpKhonlGugmcg5mcUP6vYyklUC8xsdORpgtyanKAClrXkmOxeWE+eOJuIzQi693Owtkjq/wWoe6f9iMNM13NYK/+Yhn5OLgaD2AmRuD2EBIulGE/THlaOQoLXdmrljtiIiwj28kho/ij26bk8uq7ELJuw/EzyyvIExsAKDJEeK5ZyrGlOw+9aMbflfE33eB5nB80BkJrUu4MuTieG2ZcxX1L3J7p7Uw7uVwEneDWR5Sj6eRcJGJeie+7f7fTSlwwbaVYw3qeVsL3KvmBf07ym9MkGHFzyL5zxiA8/fbL7WXwADsyDvkgbFmmzU9f18cZzeqYoPqTrjjrQJibVDzIO9AYvfoj8O4u1VTgAuwz7qQXl06lOHTfZ1eeaauw8ed+VlYzBglVqugvEjh/z1OAcZc7rxzQJYXNYzsh8NEtvp0bPbCinbrvoOcBy+dS/hIQm/uB1eGJ7EoE4mEreWG7lhvVTZn4iTnOQLJX98ypR5ft3BJBRuTJ5Ak9dG0t0GJbO1YZmYhELm7VZryATz1Mwl2KGvelJe1MFSVbGwsXAnVdVGVMfnBRufD//FggOVcFynnhmWJx/mFoA6MzWaaTl1ZUYahIIW6EJ0S/s+jhgEVKZ72lHc2e2DCUIZZdIjUSLly1HRICnr87Z6pw2Qm+dh7jT1cSi46ia4zWIqUOYJbtkyX7AproKZrTBrz1
 kOfrJWzC
 TfB2R8nNzHtBCUX6cAIwPdsj0VLtTBqP2LfKZIT5J88ccMDUHWETELELexHxrGyYRUZQsG1LTHSGA7IlYZZgsh5xquK0humo3sqRJHNOHaiSGetx/cCV+StmOwTOtDgt20dqMVgCcg3CcylETGRfDYkvCb8t4DIiqw96SlN2CpyteCCfrzqu3seU5uyHQoNgjyWztZzEDIbgBqIx9Wy3CwJTHBlcfIJz+Rniw1PMtYjyxTvO8IWdHNxs1KqiFq18j4u+vMF4bQSaM53Yg18l7Etr5vSgc4Rz3iFaWI93WWk0wyIwXWJ/JVbLXjEBbOVM45Mu/hd5t+CBRmEt7EJwbUxJTEHJAIXAjVr9X4ATGoY0zeSBjcTnHPDni1jeIiR2a5Z0zVD5AfdRgXc41dYS72dCS+JWgf1EghTFcRRslDpBlM+wxmBjGTK1u+/w8Cdi5cQNOxYylNQlqs9yc4iGGeWXY5B8fdG4u4cBFY1bZdqROodXyXqVMtyBCGMKh8Aka/wEyP+IU3eCw14smc0M1VmBSMnHzoyMhpi9n9tmPxnYgTWIO4cjPIPx6s8ouw9OJYu6HjBJ21vh+Foh9UwWZahooPMnEn+9ZVLQTjyasr6jrPcc8k26i5PPKmzJlB74XfgLhpvqDLCqqJXcvukZI/d6TXxMMqNq47mV+wULyjDwFGfxlPld80ReMWRpj+tckkaSKH9Ioa68XbOPT2eJ5ecGqmsTKq5clkb/tRuEUkWHuMejDl3qWw4xAfuvSp4N1F8bQQlbnK0a7ES4r83X4mBq/YXikNHqKFzBwO/27pU2jiS4mZ9pc4JTomRqcxpVxPYgyS1kd+riAhOIw19JdioLPrNaL7x7Vsh7EcdfP4/diatMK8nOVbTV+M7PJvCKI0/kvFjNzZBjrYrfxsF3WCAV0riTfYVys/zfaZ9PCUReKZpYdLwL9sVtt15INv6Pf0SUPJbdc6+D5xSKW0UTxuABs/cx6
 szrQLQpf
 /gluF63MZUbkly4+vaONWoGttVbWVhYsFEfLvz530UkVhdXXztbC+NolSIPWVrGUUuVO/V3jCD4JsR4EaRL2S15WNke/0UxWDxxinSQCpDDNxHnCF/hZm/wDOT90+xpx52ooHfS68vMHsZFNt2oKb7+v/rVdJ9Q65SG4In1aOdxdZKb96EN2MNYtCrKAQIqL2KM/pY4yZfxn1y+9diAUxCvtkWpo5AGgO2u2Ikc9wGxR2+KsrYcaQVBcI5VJHdvaHH1wvpKbR4ti9vrw3rxvqy7ph5Gir7uyNgFQU32+b3U5bkd1lq1nil2d97m1wyej+NUQSyA050xSlX4OnIiGDq354jwYroHrJk/og5sq+cxjViT4pA/YdF0Dh0mHI3A25Gg06iua2Yv2LIT9KDZpXZaubImsMNV3jw2CUrtmhptZlP9+6gY4ltHPpsM+hHPojeU/eGsV4fI9v5vyRa9tZY8paDfFMu+qhFlRP1JEMqBnOU++QW/7qwjyL/cvXOZNBRNay/+CpT59TSEvhFM6wWj268qhNSKWykRV1sKF9oCuFwr5JFM8JsJsFfjXPk9ilnfJEenveb2P4nm7HYYtUNI0j4UohMvNRknQ3//pBbx2OhBI8nwIFw9swVeq3ZX2jEFuuLOdp5EveK934sGpi8cmeFnipQ7htSX+PbehP/W8sobgC6lBJKkgZe9mngIT5JCgDdrPzrsbk6m5cunulHkKbih8lnSXobZgUqePNdzwxm3ZrbFM+fpsbs4zutkhqjQEKGcFFt339QHPh5IsztWV/QriBDC9pTcK88AuuTeX2IfRzkzEMqJFdO9qNPiKLMcNJY5SeEcqX/OHIL0Cw4ylKkGoQKtT4dp6zyT+u+6OWvZT3HEPoa1a1SdT7U50m0YOmp6AgxLnO/G1VvV9vSM3fSXz8iyM2yZJqc3tv0KUcsRnbejfwB6SwA23xbAFCDWlWWeXhoKGI7PnsIGrd7iKhx3yl
 tEZvsk1B
 xnWkq5t63DOmOrSyh/FadWoz8zKHf9ExEYT8RrNvfzsxU6kNVHzfvBLwQhZioFfB1er2jPYeLwb48IyHNs7Su7JZPQ0CMjF4Z4vEjE7nobO+6aH5wuhOOI3lDXtMu1mTO8Hd2NjrkCB8nZjy5d87Aml6GfNSABogiKSknXYIbCGvaln52625mHX1lPij8gd4RJkqCwK1Dg+royoR88rKf3XZFO0tNCrD+yBHRmVjsQaz7ITgLzO6OtZLazZQ42kgevBqMD9pkKPSWRHbx1DfVLqSDgO43E6y6HIl5GwyKJ+viOPxBzMV+OiykOKst6DE8U/JXK0xSOs9AKuZWdfPudxGMm1KmbQdaXknd6o/VOQOrb3xIDLVaIwb7CMyhwR8nA2lE/SwIH4dA37IyWzq2rlLfcI5oiA2jOaEwllbruSwtUWCpMMEsCYLv8n+n4zOwKrd8xNxPGSMb10MziiBre9ZSHFtLjMkGxy5uQWcqSolz8vKrmgZiPkx3EIRmSEowkY2ojjMowjh1SKvms+TcEysqI3yHxAimQhdPfLyo/QwlnNNvPxj18b0J0C0Zan3rjBeIu3gW1zG1M0iQRyM+KmUT4GF4dlCUNx8DkCSCaH/VrbGHTZPwcCYZcxVFiUJ50cQtvFzWof7P5cRpUYit0IkpLv5vmUClAj6+ntNal0AJKz22XN+LWQ2AzodKq4IcR5yEId87xzRyFvGfRhR4dmMU22VdSoTUxL8hNxtIjP86JzpWviKSqrGqH3ja9c0tLNX8SxDxURwDoqkcBH2i29eknxCArh9eSCPxNmWQw1rJ9jotJgKknv0lwUg6rDr3XBPGneh69HIjDdcUcEzpmc2oypNEqjF7rIRxU33vCkUHd9jvdw9MEgnqfK0TcOJ6hFJ184D+FaMIGVcVxoO+8CORi/EWudnXRAaisJOBFkrpfCl8K4QjYGCNqRMoLOSog2M7tVmVjejqHljC1Ehiv4YCaBDJ
 qKo+bWVg
 wrNcIDNYS8bg8lETvOpQXruE7uPV5Xl5dtG5u2VjeC2wztxDF0hYLDyWxE4xNccSb2RmgNVCov4tUlklpdvrSmpNDdYiKgOh/AokK+40z7e6GYPBQBfV5QsLPjeSonQSKodHiL1z3b7Tpn9o7UGCgWKkz93lGFkYG/dAgH1b/7TbMV0BTieA6emDVKM7epfFhp/vs0U4hCqDshtG9k5azhWrV7Gb73+sfBJDvTaeU/57iS5ZS7nCmVD3qBSUgNRUvM2ia9VzjoASAe/09GTxzkxRXqOmjYDpP42wi3oDlNTacKr7N3/0XDAbSA7IoQ9jBo9gZj4rQy5X5R6VH4XULlGSelYTSlBeRgwhZRxmaFPGDzMFazmqYhDtCb2wqLXAmR6JRszEOFe3RzQVJMLeyuER0WVfnOlh0gtReaD8qj7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> Rather than referring to VMA flags with uncertain meaning, add a new
> predicate that explicitly describes what absence of the VMA_PFNMAP_BIT and
> VMA_MIXEDMAP_BIT flags means, and then refer to that function for
> determining VMA mergeability.
> 
> If neither of these flags are set, that means the contents of the mapping
> are managed by core mm.
> 
> Otherwise they are instead owned by some other kernel component, usually a
> driver: the memory may be MMIO, kernel-allocated pages or even ordinary
> pages the driver maps itself, but core mm must not populate, reclaim,
> migrate, copy-on-write or merge the range itself.
> 
> We initially also treat VMA_IO_BIT as implying a mapping is not mm-managed,
> as by implication it cannot be. (mlock() also sets VMA_IO_BIT transiently
> on ordinary VMAs while locking them, which is addressed later in this
> series.)
> 
> However the intent is to in future remove this, as no mapping should be
> marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.
> 
> This forms the basis of further work intended to improve how we express VMA
> properties such as this.
> 
> Also update the VMA userland tests to reflect the change.
> 
> No functional change intended.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              | 53 ++++++++++++++++++++++++++++++++++++++++-
>  tools/testing/vma/include/dup.h | 29 +++++++++++++++++++++-
>  2 files changed, 80 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 97e1eb4fe3a4..83953757735a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1612,6 +1612,41 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
>  	return is_shared_maywrite(&vma->flags);
>  }
>  
> +/**
> + * vma_flags_is_mm_managed() - Do the specified VMA flags indicate that the
> + * contents of the VMA are managed by core mm?
> + * @flags: The VMA flags to test.
> + *
> + * Such a mapping is one established by a simple mmap() or brk() with no driver
> + * or other kernel component involved.
> + *
> + * They are rmappable, and core mm services rmap operations including reclaim,
> + * as well as population, CoW and merge/split (if eligible).

I assume ->fault returning some kernel allocations (VM_DONTEXPAND set but none
of the others) will currently contradict to that. But hopefully we'll clean that
up in the future (or improve the documentation to cover them as well).

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

