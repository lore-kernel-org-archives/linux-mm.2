Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37A0DCA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D8D6B009D; Mon, 12 Oct 2026 11:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE726B009E; Mon, 12 Oct 2026 11:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED04D6B009F; Mon, 12 Oct 2026 11:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF73C6B009D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:06:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E2DAC0F8C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:06:41 +0000 (UTC)
X-FDA: 85314301002.24.C68038D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7B078C0006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:06:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e5RGRP0n;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791817599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+fwk8Fzg9As63QxslE7FFTAR8w3HhELt7wLLL/Vq43E=;
	b=BqhF+eEXQklCas9sP7RD9p14xO8dvjtpjmUUAuVw7k4fZiquWfZd7HQcMLvHnYHzMYwkUb
	UaMz4nh/QLnz6mArlxb4AutqeIovEz0Sj2AEwPMsgkAnjAVTi77w7prl7HGhjzx0O9Z6pY
	pL3wXwcRVL+US7lwQ6qZigxrKSNOsEE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e5RGRP0n;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791817599;
	b=IHzNFcJ1x6I3EmV1FLmnLMljKx73/4plg3bGBeMsbKoj8OTwyHma+4m1hCUmtQI4b9BmHQ
	DAIQmF1jpiuFw+2vXDP4+qXUCl7Vyn1a8JPSbZbIwFpv2LV+QHNKpRtpce9R2BzMM+cPKD
	SouqsqP9Vj7O5lvLlfaofJLSc7LuHuQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DF4C41E48;
	Mon, 12 Oct 2026 15:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D391F0089D;
	Mon, 12 Oct 2026 15:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791817598;
	bh=+fwk8Fzg9As63QxslE7FFTAR8w3HhELt7wLLL/Vq43E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e5RGRP0nwBgCPjhy9NB/ds3xyGnyicrGAHf+JIIXqPvb8xcIe3yPzo0f/SDZ0nQck
	 5LadVxqyRrVSJewB7Y13xf8imY+HiKWl35Li2dG5MeEodaw0ZhX2awp/szISHE0yZh
	 zwD8hS8dQu1UPTS1zTh7//vnMz26H5e8L9DZLUZegDZ0PQfA1TNwG4sE53llBGlgEh
	 uvVblq3VsJRFftCZRllEyQdaQYht0l4PW98viZbump8TDubyttPFim9TR1Bz5DZ9tt
	 ouWdJgcGMrdwgnAwv/j+WQpa6hdpTB7VoUiUqAmKtkL111nem7AxiJmpcCoq3hUMCm
	 7WED4cTbH+GdA==
Message-ID: <6eb2b306-b386-4955-9469-5cd5bf05a315@kernel.org>
Date: Mon, 12 Oct 2026 17:06:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/38] selinux: reject writable opens of policy file,
 drop mmap shared/write check
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
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-11-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-11-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7B078C0006
X-Rspam-User: 
X-Stat-Signature: atj8r8rsfmezutsqxwb31bdqm91juo5w
X-HE-Tag: 1791817599-443966
X-HE-Meta: U2FsdGVkX18L1fMp/NuwwExers1qm+WHknjfV+0FkJODLRXz8O5DSOXnFhNgOEgffqP8dTBvDAOxJeMX2YheMzeTuq7yfHSZ0roE8sXodBdCphf6XdFGonz9IWm85gw9mCei8MtT9BQU89uJxka1arlZcn6EPy3UTvFaikrIDCC9blZAD/eh7xJnV48+DZ20JTE9dloHD6ILFlzyPkWptrxsHgM97ElzWv0hs8UNW3iuqbtsIxvbRHdaou5OBOsF0kUbj5aKiqzWrHf6+tMwgEkg9SfMQGhL2rnu4gem93c9ipuNS8wRb1yBISBQRJZvg9kjy1UxK4/DM3l0iPs13R+ZhBn45B6Zq3PsnRYO262FOPcEuj6OFRPrhatXdKCFc4aRzPRmSwkgKQBo5GgAA8TJeCbu3/ADzDz5r/fAYIR4C6Pj+fY0W5r5OIxHMrcDKFdqO8ELDxkSt3RXoojnuE/2NcsKyOhMscN4hCQh6oyMCICto8ymf41ISZTjJeQWDKdzH8ifRiPcrlP5Qk3+ogD4OWS8CKLl4/DK1J2MhDVt5xKKipQQIP9S0sMMS/zjzQoTVf++HQMQwEDvVFho+hZOu9uFu4OTO8G8LwOrbmRnQGlqaAlLgZV4j83BqLYZzzt/dbRkFPLfOqO9zfrc2dFKGC3J1j7opJWi+EyIxjduUvUgSkafMJHtZcEGyeGVd17keIKByTJ52sEvCMzc8uTTyfqNTTZs82K0ct+1oLe+87wDnUr4qUgrCPwsqNQybFdYtQHZgrWcRBsH/NGCC2oOmIsaKN3V9hF3WdH5cArkr5MtCxw4Q3gPPJvxLGlpmS7Xw+u5p/ebjHIDz1nVIUYg0vJFqasAtzGuMOfppG5OufEd1DlOyc4mg/9EiPIBjZOC7KrnQ3L2+yGRldIqxW+gfiEfmVeMyVNSDjAZd1YPvg7Dk5vJ0C1mVzx9PX2W9MY0NGSpL74OQqFjAiL
 MoNrFSw1
 XfWoi2VIOZRp+2dnGiYCuEYX0fxEVy8Q0O+zQXfo7HjberIi9MioOOdzMcE1jL3seicSGTgUmCeu+2NsEXMksNb7/BkfVwlpsTqq/Eg/t6rP6X2yqhYoevZCZatNlmUd/JclHaNpTvxpdenJ/OlZyCnIv/1ob0Y5P3Aq7Vw+H4k2DjF4pCk9uhiiggOG1KR2O6+XcKN5Dst/yoxcswECd+orbniZNNKk9WiBZLJDAe1INtRIHDI4LVjRTk3mFelcMjYdW88VCKR/Jb8QlSW0B75donAicnRFo2nrpF/7d+BBw1rgsEsZs6AU2IpRhIfGfojwWzdPSNnz3klp6fq+ee00R9cyeJf6Ge0p39TJG9eR+pTHU7QPO4jQItPVMi/tKS9ymw0MTCdkG10D5Wdmrg+JVwO/Jtykgo6UiRVO3Vwi9Bi3y0lzHo3miC0pcjaZ1N/incfGVwN2R/CuLR6RkQEWVEXZRamc1fl+Lf0pbrw3ZdndL+vm9GsUMnYH8ob/ec103iX8zpHjFHUJ2ZR14XgOG+wZ9qpj774hXSDkrnSTsh1nr8q8ovjInYyHpZWXwVxcTO1K8C29Whh+OK5ouWZghWc6YR79lii5MrZo23DtiYhpyeqDoQIPonlfj6/UM8b+XZ3oN6vvABp6JCovZY62D+HcXZFHqSBG8WbTR5lN1jdmWEkyA6c2kBr/4Xl4XXEHCZPLpEdOGeZTAgH3yBfAKFSrARq2ZDhS7F+tlwEnEKme9hBkJwr0LlMmsCz5oR5h1zFuileyMIWH/zqfsppAglrD8iV/ID098DHtIr6ZM8kKjy4QxFSWm/w5zv0rpEHc3wXUm4ErvMvgDo/ofqQW/IebT2uwhKNXcpSKhWxldqjM/g3bZ+p+I6ppBTWQEImuN+5H7bf5zuIN0CHbxaM7V6KncGQtqs3ujUrSgTs/l/j7r3BTRSxBxn6qcQto2rREiK4vvfX0Afj231Dd2xPd89F9J
 JJWVpFlL
 XU4263vYdG2z/C0Jmc+6Wqc61h0BXdI+HCGiWPFYwdSMi9tzvDLgIn4ijlaDvA5C2aWJZBtWj4tyNDHr36cmlK+kyeok1EUJZvrSWi/L1sGlVn8m20Fkd6sKq34jXLyXOXGKLXY/xdOqUGAoyqOiR8DMdZ5Hd258m2EqVBf5l1e/voQ58csH9Diwyavi8p3bIkITVgqhXalLAYxswIJwAy9zI+mpCSzik5+pphtpkLBBg0U+TnMmlPGDtvcg7mXXf+o+0AJ/3CmcLHRa1ifpqeLzN/1r9JAmkHx79I1Gvyzjs5GAUPS/FLkIuHaXS4UdZIzZFKhuV7zvNknRjfavsJSXGJ7deL/QWHP5eZ7OznLojptZ1W9vY/rceGWDmuMEO2yd8z7qjQXQtVq0x0SzTdai7OO2Wqz4Srr3OVbFxr9nbIlJBm4DYxHe2aYHvZCJ7AkD/YTXKacefKLqfft1NZm0/CYmdTMHrZyYdgRb2VT7pjgp/LkMdZ/Foy1qpoJeUyltwCDQs5XajLlwLmwn7VLTA2Jo8RZjxep7mg5PjeDcx/Sh5wd9zsbHalvV2iG92u9MgAv3YfmKFVS/sNKzTJdVCjsOhcJ9BawYIlTxXlWdIH7Or22/VigQf9NPP+9CeKylJgWjWjl3bvhJkoJxd8gteNyaHe15sDrVE0me0xqsP+Qd9lG5CGbgNgmiC18VwvDh1NtPyNhGwq02DqDngwRUxJvr0GtQy16K3ngZvi+r0cB29pgiM+Iv/TW6SigMDvUd3RRnmd/zO+BDTRw/VFf8Kp/l+w0dvlU3BCB1bc2Ga8sJrruOK/dtBNpyKkaqdllqa24Q5uHVgEjY/C+LiUfxVOzRcxEAxNmyQ6Vz4HsnS+dEEJr5JN7AV8EUPpKgPaDoW2w7gFv9Cm2TkhWbDeEmA8Y3EKsSKhDhvejnx42xMwzHUx/IET70W5vYd/NVyW0dvnBCMa9vYlAYVhoZnhWq+y/fH
 apwrmsh4
 k1VQfZgzMZyI6tIBSz73mp7B5DHvExkAdiXZ9jXvDTTb6FPXNPBgRSMEja/Xg1g4hNFrxdY+kHDtz/yOIHsxKDBmNME4jB0dNhSXVEDQL+sO5Ua7yR39Ba4zE78hYU4kLOoSAiJfN98qyxhOCKpbw+Scz+ncqA5S4U3p1YV041JazGKk58uXp5n60VP1/3t+PZYjBv4DfRuoWzMhkNGBva42IdW6VWG+RUtS9JVd0yL7A+7CHkLkONYUjy1NtlggvFFmET0OU74huou4xCI3KIymRb8EOE3kr9EblpbqvgOGzBvKjYAL5pLpynsxshuzh9BWJ2WH8nPF3KMO0iM+z5XGT7FYRpkL85ECUvh5fuGj7x9n5jUrM4in/TkQml05xvgHRvG9kbeD8LymM5ZGhns5W3MJbQ1NFUY9f7QbLXt9T2SCcEAey+lnnivIhLooUKbY1bXWJhKpZtUYQk6uWXBaLKrWAEZB0DKlK93AUlNhh5Y/qemjuOp9iTy7b02FUCJXtTvA5MPhZbbKSGj0yQ4YSPLm7qsEdvC1JOaAGB8BX/ScobmKG3WbnQHViCuHvqfvxMsUpUt7HngQEWZzwxFkF1WCEW8l0gS2vY7L8u7cOpTQRq43u+1sAicI4inSsjeVsKjmn8F+Qds6R6tSNQyaoDzMglQi0rihRqwMh/plmt2uLVs1C8O/f+XcZuGMKSf0HQ3oJE5tu6MV7/MtFHtH3NCfaLVp2gvUXR/1XjMHsAECZQpjZZVS3Sl1Jgorqx4do7RcB1KTUJl8vGUqB4lhiEtJa7zsJEW0GRvAtpGRN8+u0VKqNYfZTZ1GO190YOAhK9An93BzuTxDLLAMcsO0xlgBLD3UJPjwtlYAMlPfV3LdjpLM5G61luXeGFEkdtL6RmeJ7KJ8c0bl7XFzPJYgp2y5lu0LrXfXemQZ6q1EOe3vTzR6l5/a6qNBuRYoZ2wRh6Dwah/TyVJMiIclb6PC1DGkw
 wSkJjfCN
 UFQiGckAClGECv+WozVtRGylHQaOEi1mxDLkl6mJNnTSThlZIC08wHrG1KcO0xENRvgrXvgLDGNV0b665ZCGDdS4+Stv/Cmz951n2+NuvyIAUYJtRcSX/p2W2+iC+xp/KzwzaLqhX5tPfaeThXfa0ghkeuBYzxkUstZpYC9flfJcKb1VNoRojbwsLq7IJGg21uK4yDvQtvuVz6l8DIV+LSJNsgtXPtHajCuIo/9/fWtorc+3LgcCFAytsYoDgLpiUrH/+72EzaaH9sIMl8FDmkMjyTNJC9ixRlwzfTJNU9iHgXngMb3tMQ+kePEos7HIRBU9MwcAoXUCiubO/WNLzPfGe0Q3yxsmNL3kpLIOPzMna8ZtGB5Gs3IBJBylvzVsG4uWXMFXaqmalbWXNkBWkiT4YEoH72FoYlqjRUGmasOiQgCwwo4M4j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> The policy file has no write method and is exposed read-only (S_IRUGO in
> selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
> kernfs does.
> 
> The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
> check in sel_mmap_policy() cannot be reached. Remove it.
> 
> This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that is
> neither a PFN map nor a mixed map, ahead of the core enforcing that only
> such mappings may do so.
> 
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Acked-by: Paul Moore <paul@paul-moore.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

