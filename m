Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA6B8CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 07:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136906B009B; Fri,  2 Oct 2026 03:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8D66B009D; Fri,  2 Oct 2026 03:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3956B009E; Fri,  2 Oct 2026 03:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C60EA6B009B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:06:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B83F1A0627
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:06:00 +0000 (UTC)
X-FDA: 85276801680.05.82C7AC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 93D194000C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:05:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JBPHev7d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790924758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+RvJ5qQrWBaQpl+ZByeC1Yxk5dq3iA4mzzIbyaM97Q=;
	b=MSc//9f1S/Rkg7HlfZ6KjlLKso+czTqY8nbjPAXPRu0+Hefn5wBt8P2kg/92rDFo+gkt/w
	/WZDv39F5n74+ju/FJdS5LKLyn7J5AjFQKVc9ZffDU5MisoOZg051qRzp51SHTF33F7E3p
	Kf3OJHBzasGKr8CWBPtuil5HMM6HU6o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JBPHev7d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790924758;
	b=z+/v84BKPhpcTq7/rpqnGSGHfTq2U6HIcvBAut4zFJwVyYTAcLQzS8O/povllfkcP1rEKH
	2lS11tX4WpI0/d2Y+XlitcreN5XpU1p1NYAb0a3w5dB8lZdoZCsauxHEBUHZ44NgR+Dbp2
	GO9nm6+xK5RTZjtqh1MUBwoEmIVet7s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1671460A5F;
	Fri,  2 Oct 2026 07:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDDD1F000FF;
	Fri,  2 Oct 2026 07:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790924757;
	bh=q+RvJ5qQrWBaQpl+ZByeC1Yxk5dq3iA4mzzIbyaM97Q=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=JBPHev7dzw5KD3Do2o8jF2ClqL/VcD0yCkArauPDfrzaWNjSv0XIlRwHjQBeniken
	 NuNKmbo1MBwL69yqS5Sd8ywgt1EEYGe/6Wj7zcDEOhAnrr1K3MC70BRFm7u9B4iM1N
	 4I03aUKcH1MBgVKhfTFIKagNUEA0JPLd9zbULjK3Db7lYftI6JNGvu1ciQ80IVvVG5
	 EgGTQrKbozWbbm+kwXtj74BDBhrPgfQoXRujJt4scdrIStbreYpXI2f1hrMueTIlQF
	 rEwp9zrdvfowaI03UERnsKaFeZl0IaxTOFnnbweIZS/4kslHiNxS3xEO94PnbKiKho
	 TgLz7N0kwYc9Q==
Message-ID: <81e1e5ae-0aab-4584-81e6-3fc9c2634d07@kernel.org>
Date: Fri, 2 Oct 2026 09:05:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 31/40] mm/vma: introduce vma[_flags]_is_persistent()
From: "David Hildenbrand (Arm)" <david@kernel.org>
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
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-31-4583d8a23bca@kernel.org>
 <9bbdf4e8-6984-4477-a183-f0b236047381@kernel.org>
 <3557015d-23dd-41ef-9832-78b58587f3f4@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3557015d-23dd-41ef-9832-78b58587f3f4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tenw6p3mpu7e53jmbququnf5egmei4ek
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 93D194000C
X-HE-Tag: 1790924758-966308
X-HE-Meta: U2FsdGVkX1+fXXGDfH5LY05nntxQ5SxwmXZQXSRU0HbM0NBHq09flBz3JLQK7GGo24fJfAyJvsLSfZWOHkZ2+t6qJfKCDc6j6luqnLl2fTx2N1UhqXBS8Gs0UzLMx3FGXXVw+WRbDIJQ0ZS9v16RUeyqyj51GDm4HMj1W8rBBV72Z4Q0zJJb6BxRbpvpmvN4sbyofbcRS392zMSq/mdMNC/88BngJ5+VKiz4jxK/n1lQHFxWJbSfUPTGzFCdb6pviW70K8QMaBc2+mITuAvvsMcv4hNeK6N5LmbuJWE1Omagh19vsvGqwGCXBLTf+NqjPs/EsgSBm0SpnVCHD/nj/Ss63Q6QsMoWAqXcfZY/s7FrB3abwQSwYO/THgjeu4jFB+cyibFpIOqj69L5kxO8LgtsumaHuu1YweKLlRNPAhc25TJ1xRrRt6hg+VkMzGpBysdsJ1+1abzOEX37Lwm49FDhQwqUU3gCnb+JJnDLmC/+0MbVXY910DtgJUkYzrvUKgLhpZI2/7rCoZkcZCAHxn5AgSJnNNIg/Gdjkh0W7a0g/cR4eXObtHYI8eH7rgaDQCGs/W4/BycBIQwRC9m4j8yQago92zvDsH+n5XcvNczfRBHW6buA2zJfmv3XOzG53293xdrgwJmETMxMnObQPc7BIH4v6TIqt88t8nGyjl3/AN8PmlD9W83KmP3nVl8WK71HzFdbq/A+10InHxvl9Pugfel/VLuE20Dl4yZzYRJBZBxG6mU/Dt3e36jZ8e0pdCdffFN4Z25CcbGse9WwMDti+rm0kFTus4+1pTQAvh7N/EGBJgB1axyGtZPfoHOofPjJ/S3e1y0J0sHp4IwZfhqq3b46jD06ThO4rILfEF/+bU9vUthhfwKgn2st+9DlYovF3KI43tM22FdvEv+etGGtQqldxydbtcoOYgHNMctpp81nHwOXwNoWo0Uky4VmQM1mXLgGe7I+gRIRO8d
 8X+wAizM
 iiYUWIbr0g5fcKcf4+8iOx6wcsu0xfKuYgJONvZr8TouE1QjVPWY3OkH1oweccjBzNEG8aH0y2ZgMkW1lHnGmfX2yh3uPGfrJV0IBdoseoiaZWUZzP1Gd/WICP20DLq4AAWBGIIDbc28TGomxXDNcWdRf10aBSBu8s0qz2hPnzF6ilh942IVBAlOtosL54boC0qtz2X5Jj+Yy5lY3LxXV2nB88vr8Cjgc8u7njJUQfjvc+x5qETZhPvzLObK0Bs8FnUi4RWeXnKAKZMOCifcgSZWgBUMCLquXQnPMaiTTujnWCQgpwW/s8NyTOt2FRGzR2B4F59nA6nyVfi+FioILut1nEdgLaIfEF6ZujI400s9jWAC9aqUyr9JOSklR1mNUqXgY1iL49Dq1jVYQlz0TrJWdKZP8QYFd0KE8JGEtFKqEusUc7iQGo4TmsnVYhUM+TJf4VAZ7lZoXZQi68gSDwDo37UKatdhB/oaAX2aKtFmgvy+ftVjcfIfwZ2YvnNh/FyRDRqP3kQWgCVXhLj3eVCsxFBokrIeLrhbklX++8nvoKp4BeLcX3CVifMN58PUmkAHBbUGMkOM+DnHUx+dOEI8Mt1352zu+M337zPk3XTPckL3w7wydzxNQH6uuxS5ZqPFW12r+2GLSyTVCwf+yAaOsm7Fh7yVi6oit5SAntt2M+2j+E7uM27WFcKzA9u1AfLMPgf2fVFbaW7zZenpBxpj/eqbmsH+b8mJEqC/oGP6+6hRtIbXpbNHV8SGDoZzGLSfNrq+qdip2bbdDyYTWHNxMf49zEFjNYrP4ojs36BqT82d09rE68XnukJpEiMPOx15xw6t4xD/Lrl5VZnSRDer1MON0kyIxmTbawkzlSwdP7x/slO47DhDC7Ds3wqyH0iE+Qww/1lKA2QZ0E8faT3f8F5hhLfXDSWQJxjElYWvR0JzSQwPT/wnViI0pm6iZ43OnMNKYZsmc8nsMFIeviupRVBC4
 wIBBd3U+
 ad8R3osfEAat3OpOWuwMITXNSkB1/k/N97n1l4IBUeoJQz7M/6K5ARpnYXTIYN4Rd8I3dAq8A9wz6RCANAsFwiw0qDgRuXEgrPn6cMX/+DJn+DjGmuCOZLKGYUHMuE2e8BnTjNArcd93qDx1EiyYOMT3dTH/kDUPChm9k6TCR7Vk6geDomHs5rmEZPP80iw5/YzMjLz0XCDYaApnrd54578co8SQPo5hfSGXd0g7jaxNpmtIO6i85vDUOoBAgoq6442ip9XKPNtUC0c6Y+q7CK4sjPe7MPSHSMjXIs4aVN3OG2ROT3T+kDW3EhiC7G1P3tfYx7pGk7Raw399sSvFX530cwJ7Y7s7ED1FARmljdcvFpw/uQ+Y6A8TqZbWVZMz8VKTfyBtiDw/hyK76ZKh7eIvjIkdb8yHJV7uqPAAVczVsrM17w8RYiN5I1uAo6vOx5O4Kb/uQT7PIl1r/Vw/Y3PeK777gkGuU+mFREyeVMLD3y5/oOzga9MDNv3wumRy0APICqgsSNzBDQuLhALkoqvfZhau9/PxqymR5qrYZW8fg+2uV+YhzyZyv6N+gXv7aiedDq8sFsCjbt4V7erR8ZRd6o4cbNY4O9/jFa0ceif/K8Efsmao1JfGTrqJzji/KHm3mA7b9w0aHBZD0YeIxFULo1FRCSn5NTB7rBxKZm26LDtazRQERX1OkerddYHjA2mdJdV2bkgiPZZF4eRMIkDJeJW1hpllE3cwjgyqDAB3s/yJINsO2q0+TkHrQM/9VUz+svudcKXSJuGU15sUr7Xfu0bN2nAokaKFxRhEpHXnj0VEuPE+TpLezRhjj04JjMReCpMUxiRg1KJQnfY0b6BcgM9GlHfAlz4XvPH3fE7Rjb/wvqonA/y40rx38wBOelWpuzcIv/ZB6udOSgMTiYeL06q6lIBTn8mqwDP0/ANHV1lx6OiPr+BJw0MXmJYaKEWs9jysxEOQARSX7t746jva/WNpo
 s1xFxXhR
 68karh1gsLLbPkxFWzSY9YKcBIS2V0FTNAqIpRwPiR3Sz6RrGO1CueTsByNhXrFEMXf8BnZ/RwqISArbKaZLUt1hwwOXw3ECGm8Ie04HH6gVO+gmlVVO136e4IBsQLgtQrmAlNnH/2nf696sZLHUfSE0MBlFhPwLpPhCB/nxaO+ghti1Nxp4fMcUn0n48/w+AM/82WE/aLg573IfS7PkHYsXtQUvttOnGZrmEdrmR/m394Rnp0EGP8sy8btO+3eje8OZHsnPZItWP2txxWOVX4M4Jdv5unSZUXrCh8i4SkVypA28YtNFiUv+C0AzIxhpzeBzKIPDjDJGEs6HuTpKXYDI+XPYYFwOOGr1O2wZn5csuiZmN0ln2W1LUXKeHkLRyvGVL0AMwbUp7WtAj7CzzEywXlBlCiTaixTNK29/rUKsIffVde15B4ur2ByudYw5g4MncqARAaUzHX4gDsL4mTIf9GDyNQEp1C/a9HYHhuIcHuXz0eGzMxtUky0z0oNfC3fEd46kMRNpnliWA6TBGp538e5Mx8M8aLxJflb8Oj9xrpwoBp2OFClL3rBpc+28LVFsru8wJ+hWNc2VM5nXvVAagPS3uBuI9Aicy9S98N1t9ZDwAqv+VcXGlBUkV0HLMnzMU7yzKYXV3daXufvzsRT/RIk0pzVLFik/0Xy2+WBUZjdMZKkJzp91YIttInh67rOBdRq2KvB2aMALwsAcRn7cnYnElACY4ho+UzYQTEAJWLTSrOpZIxdulroWrEzSmzJvzGoF4Aqg4w35UdxeyH0akYFFPaS1dCvCz4H/hGYI1Cn/ix99BG3dej9rnjRjbROA0/g3rzt3XoSSkgDVBo6kretKIK42y8ZUj6/bLUESwktuMSdA+lZzG+1duSyxz4h6mZx4A6tG/c4JqKPlrUbw6PyyLeDsMy/Ncj3PnlIuYpRz62QGHcDmYw2mU6ZCnFuknRnqdZ4qMwMtm6GK9vDoh36He
 zFfeVuVa
 f2xZiS/tseyrQYXG+Krtq2aCB5nDhysjrRa0U9LapEEAFsBnWidRFVHl7jeHY1LlQ8luB44hLQk/wgsc4a2LDbkk8YkXfn0mQB5gHqtdRLA1HFt/a44dApsiNz8eKG6VDQogLU5h2IwK3iTf0Fl5eA7vxL5n9sQh2nJcz3uXsN0TB9t/9rNaZYeRE2MQGo65kVhQmNzbfrx1XPYPpMqdisYI8DtOPqzJqhGg5qtD0bZgFpu8Dh/Dz487q5In48p9zuW4KmsFULbUbrsC5tYvjkngqfvk/gmNMAOlA1PVt7MnYdHJEkzSWeGJYedwhi+iiD+r9kDbawCwCC4hqDAfFLb4TW1PgOtVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 09:02, David Hildenbrand (Arm) wrote:
> On 10/2/26 08:59, David Hildenbrand (Arm) wrote:
>> On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
>>> Introduce vma[_flags]_is_persistent() for the purposes of identifying
>>> mappings that are persistent in the sense that bytes to the mapping stay
>>> there, and bytes read from the mapping are the same unless changed by
>>> actions taken by userland.
>>
>> That's extremely confusing, sorry. We have to find a better name for that.
>>
>> Is this really all about user pages (pagecache, anon) that we would find through
>> the rmap?
>>
> 
> It's also about droppable mappings AFAIKs. How many more users will we have for
> that function?
> 
> If it's "no others" then please don't add a helper function with misleading
> names for it and just keep the special "dumpable" check in the new form in
> madvise_vma_behavior().

Talking to myself ... the more usage I see of the vma_is_persistent() the more I
think this shouldn't be a helper at all. Especially not one with such a
confusing name :P

-- 
Cheers,

David

