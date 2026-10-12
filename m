Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D725CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A2B6B009E; Mon, 12 Oct 2026 14:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A7C6B009F; Mon, 12 Oct 2026 14:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384336B00A0; Mon, 12 Oct 2026 14:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05FAA6B009E
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:16:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59E551C4D3F
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:16:06 +0000 (UTC)
X-FDA: 85314778332.04.193CB3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8392B20008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:16:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jKb1KDAJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791828964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYTLULj50w8cGz2VrDdtiT3+k08nrjopgP7hF7y/knY=;
	b=GBJcplUnXYxcSwAW0ta8G42DPfzkaaET7ASuQyZ0FeuPSWzUDi9rB/ZYBbxotboFbEhbFJ
	pKqSsWkhIuWZqBOPUxqo4UEHML4KZ5UESoX0GrCRECylQTij9CmgvbWeD6vdj58xdMKCGI
	kL+0j+OphzgLyWAC0Z4jPueM0RUr+dw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jKb1KDAJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791828964;
	b=u5DTPcLcITspHg1KDQfBKxUaGkFbK+9u5sFzrp4dobNZ/OkKoXLOCWS4LqbOOispg7dpsy
	KGF1bdRQyCsTBW4BkrWrsF73hBBr5YFjF8jDDPrEK4XSunhxv+Z1hp0aQ1iZu4Bx8iQceB
	i0/PSEPL7eaPLxCkPcb3TB0waquESek=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE6F643BB4;
	Mon, 12 Oct 2026 18:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992E11F0089B;
	Mon, 12 Oct 2026 18:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791828963;
	bh=QYTLULj50w8cGz2VrDdtiT3+k08nrjopgP7hF7y/knY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jKb1KDAJ3AFav06sCyLj8UCjIoWRIlRCFdFfQ5zT9BeRC2sxgPNBxw6BbyYoWnU/f
	 tCdXrUW0n0dwFo32dUZ49pZL8p1NPDoE5mJy50/Yp7zqrshPLFad2VvFvE+Q++XYG1
	 ArL6vPewLSC8itjPCy8DcgYxztVngtqaCpUx4V2PsZ2AoMuvrmyo+WPFGE09ZU7tV5
	 pPtIyF0ur2rrwANNOiExG/1JN/dbg/8GA/bftwSsMYuUlXrXRo4y72l21Mo948fwu8
	 1Eq/rGQf7emejheXqvBWawSe4WtPFf1Myhk48p1iYQVNdqbN7/o7xm1K0t4/5MKb1G
	 PgVkbNUkAJI6A==
Message-ID: <da6cda23-da5d-453c-8b19-8fb35e60c4b5@kernel.org>
Date: Mon, 12 Oct 2026 20:15:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 20/38] mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
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
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-20-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-20-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xhdi86rukoxpq63h4zfyodc485nczjmr
X-Rspam-User: 
X-Rspamd-Queue-Id: 8392B20008
X-Rspamd-Server: rspam08
X-HE-Tag: 1791828964-326298
X-HE-Meta: U2FsdGVkX19SlQO8UhLQWlU1/lHeQBJFwjxGNtdPYQ8BP/pPcOhEMIguKkqK3Jh2EIp1p27STvb/zGxW1R/ZgMRED8OuzjF3utDk868cDyTgsPh+Lg2UTq4wX5gHnnpmYS3/VpWP1C5UXDqDmkwfu32mMUkr5j9Xp59SwBYk/R+MIJBjkUGu5HH6PGDAIoSCHZlqigSZ25bl26YfMyxrvDVYhVTaOmytpEDBuCHpu7jRNrWKzYwxTHfv8u+ef/vXfhgOFjieBzbLrYSZrtBdDZ3ATD7nHrnVVABZbDaxRnSQBXP9IXcWu7t2/9QET2YE2m7mrPRXPWBLMRRH/dIwFNwlt40qiOaCjd52fVPOL8BxtQ2f3k4jC2Kl57m/D8PIOTuwY0bbm1QYD7blenQ2Jgp2dIEDYY6jiovc7mbcKO5qKsn9wC/oMCWjZcbZD1Yqj4baJIXLFZJgepTItglKvgr3Za/TGiN+uu7rKx7t5f1LXzi1thZ9ol0QggEutdcUsrbcMbTSLF9H6LZ8h6LNaaVn5J3/gbekYhOZRDJkh0xvounNjzgpnB1LJlAsyjRQjKA1ngsRTOY1sKr1bQpNxwnuL8b4UBAKNIipwoTa8xpaTf0zk+O0KraqTKa8oIQIp3evh/+kFMZ/r3fkD4uwIP0qOUOJ5F/cei2GSavtp9D0XNJ6gMRCShxpvqDpOmu9bkRsPLs6Z5QwuL50CgNiJ9cjzF/4tSLIOKoXxOohONeP9ark2D5YAhsD/9Kpvdyo47srqcJjUVZYDsw0iLIPya2V1kzfwb4brs9nxC9cITMcKNxgKhjMk+lKwySDQ0XggFEoa4aYcMu+nvtYsoymzF4S9QCfA+4NzcTlwMzFcUyeL3fbZ7zqE9iGVKyzrRGegDfGRiFmae8YlfimJ/hH6EGKFxXssCege2ScGLzG3SpmWWmwl00C4GNSxvIkU1OdwzwajfY2djWNt/EmC5X
 pcebSZ4O
 j+ezdB+IpLPuBgk38iOb302H84Rsk0+pPASRlPLqtK1Aw8Su5ZpJrtdgJ38qattLh7jOOgou+yf/y1DQThlxCFlBzfCbYW4YZ38QDnD+fEytTnzD33/AQxUi/FRbvHqFKop37PUubKakxqzl99dI342mX75jqqgrSqOAM3uWLp8GSbTY9DEC/cNws7mOt9CxAfsN8TKkIBFc1+7QBQ956Yh16AbTcOf1A4iD9XwzRuyeASgkpyiQuyJ0sud1XrVEvx5sOmgFJD5vV3qJn5i/X0CAHIiSVsOWKg867KHF7INGOCc/BUpRDBLjWv8Su5wqnJwBFbU/4+PsvquuI2JG42Us33tu9hgwWIbXTzTVqLlpUM1LCF7SGJV6EcjZF4V1jLgegIIq5Wo8n1QDb0+fR+ICQImyN8ZN/NiycYpt4yVrEbUoha+gKgzK+GDb/M8kiTrxAqVUd/Jx1VoPfPbVO19ZDH2G1QkjgkUGgYV7i29riCjhRPflQPGuFjyKUlk79S7mnn0Z5+WS56S2CxVoieg9ARFpB4Ukc/x9YyW6GnhNa2Ojd9HiN3obQaRXiXG7QkABTYCdYhGytq4XF7ryeuRtzDVIipqXrfLDMPVPi1ugZmqOVvVwRVtcLUjhVzjYDWwaEtBb1j88WF02a1ZdXdihE1F9WOgV918ku8x60OmvpGzwwid4LJ6uXxrcKamjUGoC7iAbo+MgGJqLGHWht9BY+N6v/fpTngXPrFgTI2QRRk4AnfL5e68kgevi5pvm3timjEH6h+lP9s3Y3eim6cHqc3UNztO89qh1BCxoM8QAN7bKMkqEMPdcyeCHEHy9HUG3LxDGUssDI/ML8qHPwvdNooqXkXbyktCgl+3JfM+TMsGzOoGNEet0FVuim8j8H16LGNV9RnomFJ5m3qKBt3Q4/mu7XbuYZRlGqanvNcHzECoX64tcKOFQ9A2i8weCevkZNRCPwocwBw90zMJoAZf6EU4pQ
 LZXA00AE
 HzYY+VDxDD21U/Mnjmnw6KlSxEdcCpr9WJbu+g/Htp8XrwOpleEX0ZbEp07VFv24MTihklEOU6RV8NyLU4K/P1YlNVZRqbCPiC+cccnWRFg/wdTdJ1atYSAyWDX1c9LNjmLdcwSL7u5xBUTBA5TSR3R9B+/dAdZ5ZGb9ry2+Bo76zKTXxX62OnWMnf16Uul5H2s6+Nji5vS6h5bm+EFSw/3b+SMQEWACvMSePLGAyIdHWwW7PGkTIkCPvZynNwlOKKUOTdJIIgclOyaknZrYGT6LEfmiJxj9/h/fsn/ISY4DorDnfDGytUtXgojvpdvS3Wkmv5jujeqTLqYRdvEEYcz8ZV176T4k2QK/eTMJlWYCNHJYPZUjfBE1nyB1vnBhO5ZEtewcw4ejQnLcMNnbkCZ1Abw3bJ/8XySJTJn7wFd8hwUQHgAKh4zWesYG6/K/dEN76Ve/6k5dM2KFGY8Yusx7F4uHzov8toZ3m2g+VpT7cy4s4ItJvgn5tpBtdRXh/eojajVCcLVoDuazhKSe1jRlJYnI+7VRCrIHB2eme5obFVX8iBiFyWqcdu2Z4DfdFnhT1SCt9/kBPCizBpk5+0MmvVxHXg1OXlijyKI7Hejylgz81wxBtl0QDr3Ct5YAlAxgC428P6i4ueHi1t8EYjXGyyj0nzQkrzRK3JQbR5cosMWo/V5LDSmgzfwquqdGz+HJIw8P1g3/ZPJQlNbfhhguTxSDMz9n7ZYXByMNryk1LW2NcG1p9IWVIWBLfQKBSy3ph22KCnyijFF4ReBua6NWdijoyGmY7T7EUzvSRsRmz3L3CEH++KivvHa6rEl16Md2zk613mWjpUcZ7fT7TRx7i/Qv5PnQSdQyDFbfVwUFu1RWrSCIS9r7VzW/IuykUznPGj5vW46eFRKCMlHiGuMKw307I9Pmzjr3TOEWsSbIabm/DkZeJqtvnfVzpMCMa2sgaen8PgVxAkt+7mVNyqhyPLC1u
 ri8xRYhi
 AYoRAlEfZfecQ/UGUMuL5g8hkVxeZWNkJQDC2cJeSjz+734Dqw6CbapPj7N2Iu+429feuPeLMgA2/cei46yrMbv8UNPFEH+AO0DIXDSGwevi14mpv/fQAA9ks9QaernnCzeRTglvWtUmI+IWmUgrXhJ6T7wHV3yoZS6VH6qHMEVH5Y/t7hI8j3tlR7LahlwnZ65PUQAyVsp8IBQJ2vfGhYjiSgbu1ZN9bfMkDB7v4PhE/kdFUoTR9b4mwclyxK0bdXZCoWlLu3LJR2/KrGRPgZ9k+BbzU0j3WMOJo38bctDlYad9ngMxqIxwE+l6aMckh2U6f+jGH8vRoGBZUe9tln8Xuc3maKRHZi7XxaLreAU5LfeHcd8+6Shf69hNyXbW8qxR2mJKJuZ/uxjOJV5vs/HcqHy5Uop3wG7aAztrVB1Wb2k9dV/wJJi7//KfiyUOfZZ5Aj+2GJMvzXVfD6FMPaKEXCTEeRioyaEDyirecnrDVzLIOTNILd8BXgH+qwnnORSBQBX2aICNf776x5oYW6pRRuH6OrsG/2Ucq45WrVRUrP41dO4D6z7RoPA0b8bqnVaUeanr2IjPGhziKU7cjyJqdMlWF0cTH5uWnW6O8asXaspzUlT6ySgxvreGxzU9Z0Oj8uCazuPE/UiVSvfSaqCgI1cRvwBMlRlhsgn7o9vPf/cwJf+k1z6nfhQItGepb1jmLgOtnrWoMZPffxf9h0RLbztEXSCZAiJH60bvzeRI8k3VpH9iwQYss0iaQlgKFvqbfQ5aeUw7iImt0Gy3j8O+ADf7dxkCZyppGgeD4XMOg3RSx7DmCOS4mxRiGU5jBA5M3pL5HfTZ2BHwWFz4ChD6+0VAouYijnreOa4iqeX2l/VDaZch6rfOlhrMH4yW3DfeMhxILnUx9BGDseo2QPgHp+pyRDJOZ1s0QPEDBzeEZlsBpamQ4qGb4jjjPU40OVer2kE3bOwrMcLSy+2GQcvWVtMg7
 ueM+9Zo/
 b+VieYXQh9gQbgymrnyA0Xz/5duljfVBHDlDaqOlAZc42Cng83E+iaBSZmVH/qtXkrO4jF2TT1oyUXfBNHPNYL60fKCp6W2WDtU6PIPipuYQ2tOhxkuVcVl+R1OtiKWas1SQEKanW9WWlRAfYfWKu/TV/tE32yaZsI3JkRb/2WFy7f5myAY7U5nQf3Gug0VyANhj6R/oAnTj110ThbilHH+o+hAVKTdmOqybwKCU8opSsd4304wVSV3kHrQnmNPTGfD0zMnE3Sxk49cOu8Tw4qrfrx05jXbKwZNkEE34eOGtPH2odGgBI/hzItolmxSWwoBdm4zZS6IEhOufkYtN7hxaLHutM720zub7lkcpiYjXcouWlZpq+Y9rZUGzyEduaknRyvle3vlGrbginHqBcDIjvDLGIWrbkhUzlEjVCL0KWO/hwgjS3lbkG9siH1Qrk3QxHZBeI7pnKOmsK09kub
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> When populating a VMA range via the aptly named populate_vma_page_range()
> an unreadable VMA will always eventually fail with -EFAULT.
> 
> That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is not.
> 
> All user mappings always have VMA_MAYREAD_BIT set, so this check only
> impacts kernel mappings.
> 
> It is implemented specifically to disallow population of uprobes XOL
> mappings which are exec-only.
> 
> A nasty interaction with these mappings may occur if they are mlocked, so
> actively disallow this early.
> 
> This allows a subsequent commit to remove the VM_IO check in
> __mm_populate() which otherwise requires non-MMIO mappings to be wrongly
> flagged simply as a workaround.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

