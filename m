Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 653DFCA5FE2
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 12:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666436B0088; Fri,  2 Oct 2026 08:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617826B008A; Fri,  2 Oct 2026 08:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DE6A6B008C; Fri,  2 Oct 2026 08:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 245716B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:35:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A4A8D1A06FA
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:35:45 +0000 (UTC)
X-FDA: 85277632650.15.AB80D15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id F28BF180002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:35:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EYCZV7o7;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790944544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0iXaN+HnW5WJtOFxnblbT6Y5Ug6Tdqox+cZXIs6Fkmc=;
	b=DDkdn4U1rkt0B5JTcxNQIp8NQflb3fRtrYqWOhEnVFqFjIJZd9V8sbwckH1bRPovJndpmV
	0vNPUgu+Otgtt1nq/YCVIsx18hBXrRPjSqSmra6SDmh0Q1MYnBdrYY1+WAtYa9P1gZMX48
	TJtuayBqnY2iZ8tQuTwKk6luhI175TI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EYCZV7o7;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790944544;
	b=baHuKh8bcZZfFCjsqYbWYkKz7mzafcHMETKGTaoMDii3+m9B1bhjWTh+V4CRjFU9TNOIWT
	3Kp1YiPVQh4gmdS6j9QdYSfchUq4yNQ1PxlsKdjV4Qpd3gKUpjB+mcXenJoMbpM4ESzUKb
	G3+1M0Yzl9AUcgT/eRcgkC4EYSc+e20=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E436E60A8C;
	Fri,  2 Oct 2026 12:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365B11F000FF;
	Fri,  2 Oct 2026 12:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790944542;
	bh=0iXaN+HnW5WJtOFxnblbT6Y5Ug6Tdqox+cZXIs6Fkmc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EYCZV7o7nZ2EHWJbbgb0R5iyQyoRPWyVamUzrLEUgn3UGMmRcgPRwbvtm3FqlL9nI
	 PtAu9WC3TuipWyvSLOVKQ9Z2b9ifc0Rmrh4+E8tzP7JgzlYyRvMEPMH44dPbGaJ0Cu
	 YG7DYoV6uJzj9ziEGsAlpUgkrkbIQvetREa7FIUF6+l4jqbtu5pSxjKp5eEV1p5QuS
	 4QjOYcLE9QneXF8hOQO4twzQ5zBbruCfgbXA+Gzce8OGNcDtErFNr95a4oqqVg10nc
	 pwEwxBhKGhJ/7WgtKtlJKBg6ltkndikRhcXkn9tzHXMlafKoUkM7mCyP2COLF9XQWK
	 PoE9yFxy7Ring==
Message-ID: <2e5a4e6c-8f9c-4050-8998-454b83f4823b@kernel.org>
Date: Fri, 2 Oct 2026 14:35:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 31/40] mm/vma: introduce vma[_flags]_is_persistent()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
 Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 <81e1e5ae-0aab-4584-81e6-3fc9c2634d07@kernel.org> <ar-b_Ug__TBzIZsb@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ar-b_Ug__TBzIZsb@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 13sn6tnurpi1iuasboz1p73kjmu5gcuf
X-Rspamd-Queue-Id: F28BF180002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790944543-767057
X-HE-Meta: U2FsdGVkX19v48BERlqKeE7lLsECGDMXGF+UbXi5nGbNQBW9k2EULqwd6OU23SQhVuefPjWJOnS+3FmuCZH1dOnW4i6gd6g3GpIieGtnTqkmwxBR7jNoivYM0i+a0Vu0heOBPdaHQcUzGRCTocKml3YRkzmqj6OsjfsV4sDAiCvwsAXOdB0rcowaC0Ev9o0Bfv4iy36Mw7jAq4gtzazamaq8PDZktRMnGNFf4QtxlciKf9nkIUTuafA9RFqCdNWKH+zNElwBNBrtAaM9Tg1gTxQevozqyui5CB0gU87OSyYwv4p/ZlYYAsgI68Br8VXqsbPV725uw3EtyWqsRWF/m6OnKPGA61fo52AObY4D+YGwpz2NKxAm3vDQS90zj2nd4dCD8OJaqca8pV5VCn0q1hRnOZcCsDUw8rcbZ34VPFabTrU4nHNdf1YWhc7mvvGBLPBHJSrCvdnCSJ/WyxtFU5vaG5OhuWFIU8w+TWcG4w2tnnvjf2D7lskHRV5N3fxKFc7ppONfTWXveL2wAMUKq+qCYjJVmvvKGR7y5d+3eXIrLWez4f7giNX7//hFK9ZjgQed99P76SD27B1Fn5sptBqe6UClDf5+IlDbz1YCei7g5qHK5ZOHUA4R6vjGEKFyWxsICe2a94Vje6jeuhHYLU7SsyaeggAkIng9G/gCBihqDPfo7QeBAjDGO2HcBLJipMo5Xm1uDiMFTj0in3ddV9WUh2Wcb+25dKQmiLVeOQG5ZXIznZ59OeZiN/ljeDM52UyPECCFOonzjymDqV+iQ1AN8MPQwVIAyJN8AWH9mp5F1FR0Q1AlwJ7OimCvaeDzNsX+UK6DBCBhkln0/0JrIzm7RSX7hbvB8Z/gQLlPC6VXUxAMTwduY4l9yrQENrlHVx8ULBM6b10byhCJSkMf0nl87NYIVB23P5Sr+iy957+4znYqPFDe5JOi5sR9g5rKtaGR8/38P8aLaAyMEFk
 d3Um3iM2
 JvhlamYBWQ4DT48C/s1iFtcJfuEJFkbr6pwYMdPP5WWXU7L9+rzK3FikYJIjGHGB8nm+gVeRAb2TAUXcMANs8Lvbxvi4v2NxHAF1UaW/g/Iiyzw5lIZ8NeA6lwAkja9PFdk50n8Mc8NLTfl9Ljzm6ENNIJ0Nr0eJouxKkSmQF2fBIO1fvImheyUafpLaqfISOVfPFebNBOrlz1kwSNnv45GT1mkDaqkkkqxuEECYcyjY6lY4QDclMMk/VmFzgewe1Mt65ZIbZ9vY5F6K2SevMwKxpdBzdHExKHXOnNSPVV7Qhc6GjtSGNzO0BOKct4IE4XP5jWbXB8lsrdwM0x04S92MRypgrwNNzjJYSiKAIGuQZ8X8fT0wwQc9cgnU0WxAU2ho5CZlAn/4tTw7HZzIl89PFYA0cnKsLbIyoK60W7W2+g+UMEYJavJ9YYNCNk5VF3rIw+4EoxDUFwUoyIp99gE4CQXUOLSfISWOCwijbvoTvqtlgONZSrLVUmQRBkVdAHlhnTAW10Hq4ni1ilL32N5fQlCySgeAJc889Uaow2jPRFWLeYQIspbIV/oIoBOMa5uGW/1rkpWphrH/IcpZab4qJnJ8PRH8C6Ah+EzkddymFgijb1cRDo4pFAb7+t2NeyMQ/dV5K3BjUs96ml7eM4ROV2FAe4ERqdkNzG9xlKoMtivNo/4ycpQaeZ09VgPG1LsOo8DSw8uQhnkT8TODG+Y2fbWp4SZoIh95eSU9OciEhyhQxssvQN4ZeA+HWqE1lw5ofOo0AQJwBDNwOuq0JNok/Sy2aTdvxYrfREjFL1OZ7uF7Qx6mFeHsO6ury0xCPq1jtbImFbtKlAx6xOHI8nWQC5NfKHHnjXG17mpOJcmlYTjP0CUOjubuwvv9CG+U4Wf9V0yJkVJEUHn6WhE6WhZ81PA1ybJ4WIi/e/i/wgTUMPQoHMvR4NJdO+K6QlBaHYofqQHRTpDhKGn2bt3izkr2PG7Aj
 Lj6Kkgoe
 kKVW9vecWvYqjPpk+M/+9Nq6w9jk9xhL8yI/rzkJreqMZt/tlRETirdv7tSAsVXmvbCeqKtwZp83YIer27DfjwFgvDRvfwpSZdYcko6LAZTbvisLVCwKvu4SEqfyROpmOyjO1j0neHJEVPfDIh8f+oVQcjUqGmxsdpvA25W3TdXUhIgaqNYJYQ9C2no/o9dAubd5nSEu6Xh0YwPy70hbmLzQrab+vNhztlXU6SstvV7EEnJgH3ig446B/FvS/35LX6+EXlla+Gzt49lgLaBPk+aFZNWf/deoFKX32qn03kke7p5Ncy9JIoauRbTzbQbbS/sn8Cetg6AKHHd0W9+jpdtDaOMX9lTW57T9arUli3JZEdCc756EYn3nFzU9DbfvdlXINDh1ITEqoLrroCqDsytUFQNPbVlPMQs5w5wFWZMOAY39DigSHBMzKJriha9jP2rjcBn0vgikh8JyLuDJtxw0jGP9gvMwD+S4sXibfNU0s556zZoATxBjJtBU8Ln21p80rcPiw+zLvndOFcbxusp2fXvjl4fkzmStKn6mPWBbw609mT5MK+kJWVD/VmkbiqkcOWMx/T3H+gfCnbqqKbBYkycTqHM8UvVpBkaGo+mFgdhC9A+1K2LSgLUpa7t6F/50WfCZu0FE5BIt+Yc02FmFgDJcE/gIkSBla5Hhz1UzUzeZbqy29teRBliGRziMfQtcea5Mk5icEOvPtfyfEGaO01GvK+pPNXWBaeOqE5x6MsA/9LQ6UlikJyt4eJ+59slTLrIec4M4QjjqK6gwF4HxtomHzda62rCfxzvcKTZoOe68PYmfuaM1vpoKc0bsYP15bGzGnz6gzxdZM14cbjiuM/+W5ujNss3CPdOyfGsSWqi4JuXAL8Q8VrGAb6JeXT9Mrix1DKgk1DVoWC+weaj0CY/fC+zpfc//dLXrA2qzZu8H9xayr/KTafaM9k2hnIOzW8wdjqQYYcGvUxrBGpLJTDD3D
 FA9FnAhK
 73g1M5/p5dkc3y7p/5r0rswSFQYRfrTVZJW81XU0PHiXo0gK7yW7uZQDtQaf+tnH0RxHiqBK4/l237v5xiMci08/bXT0w5BLNzAOLg8auM90H0A+ud7tVFWYpRFtESKX5CHIequhP9rXVGYvINl/drawSoPbtJG3cnELfIs2EZekdBL47acStNJyuItI4hBwT/m5xiolMWoLVROVp8g12WaW9gpHuHLRwn6gjuPWA2Ckmcs8wSFe89CvYIJCB/nM5uj4arIeCNvUPH13/0MwgwFriJKYW6GRECdDo9xmcP50cnPWo+oPxm8Acft6J3XjZNTKE3RygigdN4YSk6v+FPhhcC0OXJzv9EBPGXSuzR20hl942ptsYn1OrDPDhjJR19hnHZJPLCaS4WQ5hlgSXYcJ+m9n2Ni7ng8quKd8MoXmq4TF/z20+bsEHoTXtyCRlqmAydKb3IzqH0tL0yydOsp8KnbRFmQ+v3h00/+150YnnfJhVAWc8iQCisBAZGTzaNi8NQ0stirZ+E5js/HxuEPfOU6nQAXFj5MDECqN1N9egl0hgken2MNDN7SacoTjcfhjAa/PBNfa3sMuZkN077AVfeC9Wfe3Q/K9jF35jqYL94K55gVzuQrkwGhXwkjzGIXkZLeW0IbAoXFiDayujELuvkI50paKgwu2m4x19fR2JH0Mz1ejl3iZmVRRrCGDYjXV5D2/t9ZMqIrZPs3H9CGkbq2CnLdmxXCceG+Kkt0FePBmFzW4ccn0igUbBGmDYbcRErxWU6rT6/l5Si0BryL4oVdTQymVOLSdeHg4Horw+4LEuongqalvw/+udF8XtTZ0pEIfer1H7El+M2c1rYy93pNyItjuLTH3D7JIm1plM7BNRoxeq4LUuMvUa9mdm7GWbBrn7VCIjr1SgRry+e4QXQjFI8mg0b5didhzQsWjft7PJADHu/ZaholUMYhABipcbCEpyPWRZHPSlczbOc56/xZjg
 k5HFs8GO
 fyy/5vFnpeDnvaYI6L7wBr6bErVBkFupFcwqyeeDYakERCI6ILFtWOwDKIsDLg620QdMjDFFpPy+cm8FuBnG+uYLHSTq4mpISsLJocgMlcdpfTnRDYCSXoBCfmE49dXZhNF5Hq9TiD3SeXoxHNPquamBYBm1J4MMzkwK7TzZ+/S40bhMylVHne1WbzHYFZ3BZU1kHF+os4cfsfnk/NA3y+r4XiltF6ImruO6rJBU9MHCv2BS6sObj9x4mUNlkb17TUEfCF9Ku1uLkru1oWBoK9DOQ1sABIa/xBRd5pnJ3BPEYUTq2N/uwahHBai2TZYuZLnfeTrIDWUht49CdtMotC5rqzRqucfW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 14:08, Lorenzo Stoakes (ARM) wrote:
> On Fri, Oct 02, 2026 at 09:05:15AM +0200, David Hildenbrand (Arm) wrote:
>> On 10/2/26 09:02, David Hildenbrand (Arm) wrote:
> 
> No, see below.
> 
>>>
>>> It's also about droppable mappings AFAIKs. How many more users will we have for
>>> that function?
> 
> Anything that requires stuff not to be dropped behind the user's back, which is
> at least 4 cases!
> 
> That being open-coded all over the place is a problem I think, and I think stuff
> like the PMD device private are a reminder that open-coding all over can cause
> problems.
> 
>>>
>>> If it's "no others" then please don't add a helper function with misleading
>>> names for it and just keep the special "dumpable" check in the new form in
>>> madvise_vma_behavior().
>>
>> Talking to myself ... the more usage I see of the vma_is_persistent() the more I
>> think this shouldn't be a helper at all. Especially not one with such a
>> confusing name :P
> 
> There are 4 open-coded checks that test four ad-hoc flag combinations checking
> for the same thing - 'can the kernel or a driver change things or discard stuff
> behind my back?'
> 
> So abstracting that to a helper, alongside the other 'let's ask based on
> semantics' helpers, seems sensible.
> 
> Maybe invert the meaning to make it clearer?
> 
> 	vma_kernel_may_change_contents()?
> 

This is all super confusing and I don't think we should try to describe the
semantics that way.

Just imagine having udmabuf use a PFNMAP of folios obtained from shmem. For sure
the kernel could now change the shmem pages that are mapped in some ordinary VMA.


Likely we don't have to squeeze everything into a single helper that is hard to
describe.

Maybe we can pull parts of it into a separate helper with semantics that are
easier to describe?


vma_is_user_memory() && !vma_is_droppable_memory()

Although I am not sure user_memory is exactly precise (pagecache+anon) and what
we want? It's all super confusing (thanks for deciphering it).


> vma_contents_may_change() is shorter but easily confused with something being
> writable by userland etc.
> 
> Or maybe:
> 
> 	vma_is_volatile()
> 
> ?
> 
> Which is analogous to the meaning of the volatile keyword.
This is all confusing because persistent and volatile are established concept
when talking about memory. And see my example above, it's not even clear what it
means that "the kernel can modify something".

-- 
Cheers,

David

