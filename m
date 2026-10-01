Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D781CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 12:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EF846B008C; Thu,  1 Oct 2026 08:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99FF96B0092; Thu,  1 Oct 2026 08:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840C66B0098; Thu,  1 Oct 2026 08:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5558D6B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:04:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D38281603E4
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:04:29 +0000 (UTC)
X-FDA: 85273925058.11.E969750
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1520A4000C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:04:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jzEc16Qp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790856268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16tuaIAAfr4wGiFPpZL2QS3b7vOItbJPvdfgt9EFjWY=;
	b=6p1RqYMl7BLaiRxbda+7j7/vAWTYRRvenAlp2eZpnW987MyVAUBSdQj8vV+kLbl1gF0Ned
	0mZHyjgrGxaWhkeEtqGWu4W57KF1JNbIUy71y0FGBYfsNQvDY5VWmcN86r2t0WNo+1bOQj
	tWU1V07sbEJOCEXBJJrEzJJ3uJjKS98=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jzEc16Qp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790856268;
	b=cFAGFN+7XTEXUlQEkXd2skSfE1J0dsgsZOnDaOiFNZ8uBjw8VYbvQCI6YWTn2PjRuTr15K
	EwMa4TGGVbg8NdD/+WCaQfe+slgD24hWRMvJVmsyUQUa6bdo/+OxLKebGg4f0vn2Qwaogk
	3ZW3GL9tNZ14YVaLkoHW+Mx+9ULokq4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3136E4039D;
	Thu,  1 Oct 2026 12:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39C71F00898;
	Thu,  1 Oct 2026 12:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856267;
	bh=16tuaIAAfr4wGiFPpZL2QS3b7vOItbJPvdfgt9EFjWY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jzEc16QpT6y5z85CoNqayXJTgj/zcV8+4j43vVNREEjYgKaYaARNlkINFh+o2cgFo
	 sN3NMoR6fbvOc+m/lxGiWC6qUmK/W2sqF5PMeqx+QkX9s3sVMnzDWZ/M2mm0MYJz41
	 S3cSgkKzqx/7bn79m4vmUxCXlXwbjLyAsEIqKIlF/mizbYzyQzRqhlcK0ve8U5iSJn
	 jaobTqj+k1b/C4rk1yKhopNUeonw8tSEDLii1LybOClMulCnzymBzlP7Dt9SdjRJKW
	 6NQE2pAYnLiSAfrqMon7C3+Tw8a0f45b0g+nJiXE+3PnL55rzlVV8mocIqh7q0QmOr
	 ffT/Y1YtPvXzw==
Message-ID: <14bb5577-ee28-4770-8566-f586f3840a8d@kernel.org>
Date: Thu, 1 Oct 2026 14:03:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/40] mm/vma: introduce and use
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
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: prurbidmdyxea5yd3emfmjkjqjpxx5hf
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1520A4000C
X-HE-Tag: 1790856267-224849
X-HE-Meta: U2FsdGVkX1/XRtBkbrbmZvJ78LQPW+zTza4Tm6pm1ZWl9uu8/otYV62URwTKPOdBij9RAqwA4tti3yDqeuMUZ/LNskxMFe6fYQo73UOdzy9bTyTsc1iQ0M+cKUbKlPrRuptoXaquQ6MR0+Ii+6VXqWDOuvUqVHZQVq86Y5wVV2xvON9DaAW3w+FIlYuxU7nWjIplKJarQDRvwWJpdRnQZSdoOFj6f5650XZeRO5MIg2Tb4iYIEi8l1Vdh4wlAXM3Y0fXxiLvg+OIGsKBvZevwa8XaMrBiMHICzLpsdVSUsrCRwU2m15ThrO8OGbrW3Rbl3PNgscUDfcBpTMFw07ladwGi6l/zotWsG9vVzJrj8A8oEr2TF7w5LYuEkkty6T65+IHBVdUpO4tm56Slu/Os1NkBONCklyFUKtA0RUaeYfgXHvOvz6E2tVcX8XOU3oHWS26k9uwIVkCigoAShefRdhiYjGZN57BBE6RjkdJlq1Q5Mga68MxxJIAcwPNCqxObPyRT7a142bviGbrjJuhdlCi3+fAefTjkOdaH8G0utQD0a3l4jAe02+cp9GwrHynw2qxmh2MFlhCJWluH02MJVWDVpXUBovcrB2FxhAeps5Vjt/AkpZonVMAQW9bK1VRocBwg2gOkk2/EyHAorlxSs1NlscHeHVsM6Lr5HLVe8xs0etNjEvI583FQmCoezgCLidUWgBOMXYqNTi0H2vpLWXlgjZthuCpLh8UrjbjhP09bTICm4ODg5olHwu5z1bQne/GDsKFULIdsWKwrCDzVqxZtDbs7LH+QR0TcGLs1WHl1uPZNV7qFKJvfkX3Rbr/533OuUAtYc0YF4jFbsi+OUXmjIZWBRLdmfJNw/jW+cbKtN3Z6jFoYdL35JdoejnoZAfxNAd+WVm6v3R6MqzGBggBTlwZkYXoIO9ReDs3Ss/0MV6bUIUvQUHHNAdjOqZewRxzCZ1C1b20YjEtfCx
 n67nLJDl
 cOftiPAf/3jaCKpd6g9PceyceHpybNiBw+QJPFaEVT7ufz/nn+vAZPem4+rd/Jbew0j4D2qSwqQmI05+L9kaeJZt00GQXqvvx0BgAy1jUq3HV1aEO4K7YwC1tPMCAX6HNqvPjynNFpW9sF9illuiSMHwV2uFmxncO1mvHtc7r9jRQph1nDiEHIrAPtdfz7QbNlqNGbVPqOQOIfEKAhizWuoFu/wkt8c9/wPa6GvbpWEHKVc050tPq1EgVSH7us4Rxpxi+AHvErUOhU0Kgd61dYo3YEDMphGjKJrJbMqzUPKPnbcWgrrzd1uyuHJAaowXuC4E3Mk3pm9t/JKOIC7h1/hkqWTRKUzAjLQn8wmYa/F9lbabqCJo0HJxHYUKnJUCgstwxeM2KKhMHaJIZiK84Cav8ETCiJp9gznrwPZts9f1lh/lMtFtrRTUt6B2qrdOSH+b887IHdPpmA6OhWZAQk3agbYijTu5ugXatDJ6P7Owu7cWaHRHA4Lee1zzggJapezqI6Y+U3qUj4ulaaVvjA5Ijs12CtRwTVI4kiB4kviosE9cBgRz6mftaLrg6xnw+yHOACGv99weJN62YrHOHP6aK4vse8MKPfb9LwgbZ6IrAUCnEBsQAd+knrzjkx/2cfPnp8Ar5CrF9fMZByZs3cjy5TCWRMlNBpcUkmzyDwI6hrm6xTCfcrvBhU4y+yVoUdNuM9ODIDB4rnk2vLblU/OCKgJWlEz+jEiz2ghFzq5RzaetT9INs403KmeKKo5cHh/e6xAHyA0AggFJ7y2T5EnMl80cc/LdUSrz4kvHsWrN0byjGyPyIRsNC+KiZNiFVFGDLV4OuTy4JIAwYEfsrLKRh4DbAEOVjz5KhLmOM8i8OWNux+e3Iom9f3SudiEtVmLgY+Ld8yjtVyVYpnAK/MR99ACAtToObfaiJDTagq9hgaF6ujVI1x2LJuykE18UK2SaZuk+m8rcKWA/pZi3BqXYnmk+X
 cWt7HQLI
 GNnsnrW5JArMUa9wjl7cFvn8D4Mhfd2xQQ6gxRlIhqZcUglqipWZm5gOuRqiYtlvKnlIcmrOmQEB13KD/lXptUhFb/4exUV10GOsv4wrBSkPnTicVt0oB+Bi3MQHyyJsaAoCWBNLU1R1XJHZ4inbl5WfE7pzuIHufW6DhAXDuCHpgAMX/Ic5ojtQrHHZL3fAvuTKIo6NcOurmIgO43x69DjPrUU67sZRg7IwVV9twQhgWOT69rsU/BYQEXiwvp6r2kJJcJaOXh6Zdf1bdowjpaNdyRZCng83lZv84tMkObV+0hhBTRURH/cnO+VsgogwUVe6RRggKCU0yYyae4EcIDvdTKUvqgFADjfzw5+oTaa7GJzjWJo3ii60Q2+q/Bw93NSW/XnZ8yUAXo84ywSMWQF7RZOaUKRr5DlxYby7nuG3h0lkP74fHPFhrYgnGumWPZwIGZrKBoLuSwKdb1FCfY9eLyv0sF6eS3npUDIqmwbL8r5i9h2jkof/Fyim/Tv/hTUdTU+bQT0PnFU/ycamDbij2LII4CmTFz039Xm58L0Qr9O6kcvKnQXAfB/4WsQE12q3o7/gmn8Uq60AEceS/XKthYekrqEPn1GZDXMlQR5O4CN7ioM/DiGNbbpMMsH+dbLdQnGTQTh/oT3a/IzommwuTN9VaT0/tipvFGXPGjJxbDzQFTpsy6rKxsI8Qze3G1LWk+MIRzVTJzbt7AphXoglLO7HMn4qB6TTwakt9eFb+U+f1Kg5e5gFWD/BsvueD+RyVtc7zElf/gHBsuwiIZngv6bAhVYv+fmIac1LNkHaTrYv5bvILODtsBopBds2xwf+aUzFiOf+Nez+BhMjs6766Y6G0vBuyM0WpiyntPchSo9BjRx7DjCucuaM4yXjp6AEyNVZzXLe+Mhup6YChSxC3SJRCyw0pSAc7o0ZhOs5Miye8WB0BVokyA8lUOrSiU6qKv8PjZc4U3LLNJ7Kc9a+spS2N
 vcjPoxst
 /dGeptId5sifobVhSlqXKp2B+agx9pOVG377Vm1ARgvq2hTtYbDKOZ9MYeDLHnjA5WS0cpoNQ4R0IPW3KSt5jqGK8Msn86CIugvQeoxacdbu/PBtumhq5nyBb/nodTFenjvInkKoxmY1YWPUwiD64/MZOtFqJ4yRv2JSdpZNsHPDokYPNkWrg+Otys1Y9HnMMm49RHb777mJS3qBP1+Ep3T8b7PR9BMcIKmt7PIVnn9bMwE9XdfBFNgPgEB0DsMrFS+SyDIXVnlkpQyAtEY8O+ToPG+9xumUyamizAtZ3h+B3x1ZT3473nZaX0e8yTkBV+Z5rOtNFfsHzkjQdyhIV3uLM/yY29uPat0j4rBWpD/YL5uLR0UTOvyZAsoXESk0+6DjWlMQjx0NMvY0sCqykkV3QxLz796i6//oRszcDZhT7zqrMBLzLkwksv6VIaPdK4TIM7AMHOnLsCKT77jXY9CZrwHqIqULtf5x4iX951N6VWWVDAMVjy7wWtjNXwLgdzBNPIiUow3VoWx9Yz0MQxfyvk30XoopLoVp80WpvZEZKUiNU31k9qfVksQwRNhUq5R8sg9rR8OfHkslgniaXL48ugOaiCTh/Koilis/DAUc7xStSDaiS+tmnCRAKLSCQegI9aK/QygbmFvzkILjBVIMzQAX0dWzq+F+pAaO5Hsl6s92GWWtjWSBCsNKrHFO1BaSytzmOvCyQHGWmYHsakvx4bepHBM/Eq7EWDwZmwzk+QLdorq6e++Snb0//K3XAnPhA9JiWkOgelacKluLxAclbvqizS6MPNfeoQ95D8ppISrjtSTaWpJo0lEKEfDC5KgnVaZf1PSBdCpxwiDA8ua6ybjrHZ4i1t5gUlOpU4un0l9OJi/6MT7/Z1wXgd8yQAaUPA/tsItb94e5wlH5lQhma8hq92TaluvgtSo/u8oDrlK+VXw3D5Sf0vFWdxnUTxcsB0HP3qdD2xve2RR543gFPVP/P
 jX2v63Rn
 MAA2CQN+5mWrmMWN/+VcvZ4BFc6MHz2DLB2Y0SUo+QPc5m88879NjE5rLZJkEn5ggFabY31D6SAj1cTmBv43/BNNo8XEp5q+6uRpb/D4YTP3ZttK527aMYDtUXhMOdd6qYzDHidZfdpEE4Kbve6e7eap6OgkkStHoyUZhDAVUDk4Iqis9pszLhpJcF97r8fOijYany89jHlEXDHcP2dmQKym5yy/C4Q/466PjLczld77zRtFixdiKGN/oKlvNoi5vEANDUaLB9QO7n3FdETz/78Xg6MVoWDnQDDrODpXcvtcjqxJNFvNy1gcb9+EEQ9eESDh7uYic1YT/kF/sgAqdNL6EwAD99OFXqxCqQT0epiLr3Vk5fzCdP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
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
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

