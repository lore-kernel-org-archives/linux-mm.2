Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11A29CC6B01
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102206B0088; Mon, 12 Oct 2026 14:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA5B6B0092; Mon, 12 Oct 2026 14:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0BA86B009E; Mon, 12 Oct 2026 14:48:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3E956B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:48:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A051CC13F3
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:48:44 +0000 (UTC)
X-FDA: 85314860568.07.7CC4AB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D63041A0007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:48:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VAsqz4f3;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791830923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ijruh+t9dzYY6Mr1fVs8kL4G0u+bj6+pBN+DbXhWvj4=;
	b=pomeu/vsVnZQCQj03wq4YaqABjGY3zd8E+XNRY4oVrWcRPxAyhqCRs18tg4bdYcJBpjqT/
	+grvu29y6dgS3cFJXRbJ4DvIOTHRoRCyJFtuqLddhTQAj+/mZCyWk9CEi5pkZPPC5bWcgf
	Rc8UBFZw7l7JS8yNvZ50Ioy9qjN+M5s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791830923;
	b=wnm4mQyNK3bE2vc6Wv6X/DqSq0CLiuPirbzpjSyCXoa9oAXCfhSkKzZ8JtKPXTvNF7ZH8M
	1nH2+72L9iKu2QgBo5D8/a6yX0GnBo5+sz5PWsh7C+70Bd6aXF1XrH7MykGNvXXc3SsK08
	wDCKuP/+qtv3hl5yZB0wRihDqMJzCuY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VAsqz4f3;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19DD042A37;
	Mon, 12 Oct 2026 18:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005E71F0089B;
	Mon, 12 Oct 2026 18:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830922;
	bh=ijruh+t9dzYY6Mr1fVs8kL4G0u+bj6+pBN+DbXhWvj4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VAsqz4f3FQayrttLKzdN4ho5Htk2cDvUUzMpalm1X8JKw56c86EO+42U/YkJHXChl
	 Xk8ELZsh/F8GOx9Di8xSJsibbLFl9NfGM4NBg+sagDMH8lJ6Baavuf3Ai80/cqbRP4
	 xxbScNu9ZoyrJ4s++pvjVu6bcwXMKVw0ESPz1NAyQoEujN0FosplAeUhdHDjzWs737
	 6XP3BdPpBTLCtt5wpxYLWXsff1hrIBhUDjXVehMUl90LZh+/AJ00aqHMdwqmHOXHJX
	 ut+dLIWa2z/7tlRotSRzD0ebbzlbIsJv57v6/ntj0AWJfaXTTI+vNkf6yDkIW7RGVW
	 tINF/sb5DiRbQ==
Message-ID: <b8a6a344-ad2c-4355-adbe-be7325e7371d@kernel.org>
Date: Mon, 12 Oct 2026 20:48:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 31/38] mm/uffd: use predicates for userfaultfd checks
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
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-31-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-31-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D63041A0007
X-Stat-Signature: k6nds7qrqqsmsh3yqwyapu8b9t5yykj1
X-HE-Tag: 1791830922-379941
X-HE-Meta: U2FsdGVkX1/yj4VRbYQkNkDx7YaS5fh2lt+Q+20BOks+gs/awtcj2HzdvevUmYmrGNFhSUaGOnv4xEeYA081MB9JbUUhHc+IcRH2X3yPTHBL+OQTzzc91R7Z3hDBUmMF/4I/WcdLWoaxyGChRh2AIN/X9CRnjZoXXfSPgNQruIzkECpaPo9gHZ51I8rMF7hL7Mpj12zq43iJT+/ondb4/8F9sxgL50VALUZDtWUxxONbho/QSn1vj4+t3xWYehUoD4rYy5QSMIIO6F1B67om+BY69qAEzGcaPARZPITSeNWOrKNVTYOn/fFfQhQrk1s4d7CZWTcjGHZTzzzgpQiT2a62KRylmWG7AQ9b64ruuxcHI1rEecRLnGRwxmfPF6dgVv+NEehlIuE2VcH0XXgaHM0HnM5DtkLBqaWLPBeOIskPmdZoR8whpJMHygDxDh3XT0lbAuJk0tAZkQFnCZvg0u0ZBhktTWdFygZtc0FmaJRVLPqtrq9w547wZ8TXm8u/b40EJU3Ym60NkBsV/vSE6pyq+CLvEMgAOZ4v3rgSOmI1SQrV5/ZKYadRbJRZRnLqEWGzpMO9TAG9ZFYyHr6WTO4HwtJMvZASNDa1Gd/888gAV6U01uIsgd6bzb8qVKLDQ5T7XUIikwOFTjdWe8pUlqZEza7AlEAPjGproz2M3e4zussmjgN4bx5s4XRxcQixEYjST1kc7KTeMa7O3SAuWucrgJIAjTfz+oWf5QyeKBOMEIogpSnUOBWO6sRw+kHJIIHmL+HBuZTcuG3S9aD9OLSNwGWP1DV7qoVsDT+P/tRfBmG8ICCKSz5/YFLenIa9SLjd2lfhvd74sJ/FQF5WLERFOlvA8M/atA2jP0zXB97ZXmR+vBEtgkwK014TyJrA0EgSfN+TecrCqfVM3luyqIICyR5/JlKohUxfOJ4/DeFtk3Yff1mAg5qTtaMSmaffAx5iKPDnGOhIGu60mKe
 fPecQj+l
 lcV1s0Bz99JQ4o98QjDlBVHMF/1Ar/zAOZ3tZs1VZ5Y9dEoscZX9yZe1KUzZABlipwgZB/u74O2ta2LoDO/EOpFNuj7bmGZp9DU2zquf5oRkQQq3VpkUpuIsXbT+fMUHerF+CgbaormgICreU+f/rAIi52hbsBsonUz0U9bvLBzVViuqsb5O40AXk6BYI21Ex4IKeoDE2DcArnQT6VGVExti86uGMEgxozHQxDiAz+g5r7JYgYpaRSLDznB6j3YOw4YQiJubZkOGiRyPbX3hPRY+ZQbUrUe7R8n2XFpeise6Bh8KNSa1SQC4u0C+5Ud4UYSM4h2BI9QtEiecZ/b4IEMMwh0VPMo3tewpCdEF9kGp2PsMwSs2PYOBcJE0ABKOswSju3Ejwao52d+ey7v+LlN6l/nWttfNHZ+/4qny2SM45cuDWd/Odk2Hs/KIFIVczB5B32IJ4MZIyLQqasi2pJCSUQfrxPn8/AJgWcgr8mXUkzKsHlUVLwZxWsQdvckr3tn3HWiyOe8YSRAWYzKez5Fgrxjg3IyiTyMLDP/ICPmF2r0L9elxruxBAT0FupDSSwmnlPoLOaejk4uW58+V7MZDuF2dATw/CcYLD+tto9NZ50ZppEpYdBRYxwz5O+6C9cnEJaBoiqToCwnM3klwG6eMmtq7ZYfsKMDl50/DGNyq3+cs33n9rUDSRDVxqtT+/h/bI1UbY9UsC+FNLB4gCXDhiKBafBYBPoHImmyQ8x0pSXVmp+qbhQVAhNG2lGDTizuEQIR+qMKtvrYWIIq+GGuaztRgthj5EyubDdAdqpzasUwWhHpT+AUzcGUjhbbRY1MGfsBhhQBZf14egVjFGARZ1te6nkUeDviA4OZnedpGK1N6GLz9M7yChz0OjzqOc2QsAe1CAKbA+bmeJGSi7Q8kvJOuF8PcGkWATBx0EnT7+Rc9v4C2nl8Y/qgdIpsxz14BlQCVVhR725vQ+3yy0Ln0HLZre
 IrvYVXUU
 tkZRGVPLW08dCpZXqWvcnlQqJprEZgubYM1WmD8CL5wk5jizB0AwQSseJw7IqwP0fOhv1XAlSpA1cnOr0lzr2B/mfzDMA6PeqBu5qAWXoPObki4+bg76RSEYXb29iL4WWqut5oSwJdAvkpFcWLZ6fg7AsplrrPGUruecj58kiNeswZ2rU78uXA+nVzR+GTFr4WDiv+Ay8HYhUYyvK2GXYuWsMYK1E8SH1fWb+wo8/M8CRT1DDvdNf3C+lkGr54eucOL/22fHTKe4CNw3GRj8MI2Wb31lntDud9RPBbBkB/gLoJgUm5s8ta9LDUx1+mWIUzNtM4AMBztVtEHzlAD0pOt+0pLDh8MSwBA+LQOQ/k7nxd3naZUSgr7m0Jtd+d4AosRvfB/KAeTFDmKnZL+8n/PBi/AGC9InvkDZU8qNghl+KAYobj3I5jLi6XCD0ff9OMzH8X8jiGqfUAsRfxwsIQA/v8os+MyGmfDauYvn4ERo2Rk96yHpEKBimqGBowKfUKNOK4/c7xE8+75WYi8NyUOcWJOVUg0k2IgGJoDFxC5ocLBsBE3rM9dYULOTI+biy2URjSOL9tz37Pzj4mDE/UNUpIDllAW8m5bRbBHWJiHmMtpWfLYtSu5+2DpP6MfLlOpjxMwUSVEychMZdQt4GTAWeAeXQfzuoGykNfojJkh7ffGqjxVXbbBkUTUhp2EE4sjJJ4HHkijSzUolauoJJmtq1U3B7jwBCfFTTQGoqzhuNRd+BU/3//l1kRYPjpA7xwUWTpntMa4NTUD4UkDi9LhAQitLDsHdp9OU617PAKeW6xqfs8/bJJb8J1U5xGVFjHsI/RKeqM9oxyS81wV4gaToHkQaKFrMp6QuM0/KKyuKMiOwF7Jb8arhOG3cf7LXnjb4F6XLnGhJzDR7NXT9S0FixXhtnwVNbfw2b0/0VovYQBxzyArguSdUIQPA+TnEt17yOIBd9zJhHzmritZ3AIhQHB4v1
 CG1h48po
 w71He1WgtpQr3RDdU6s+bn5gYD88nddwjXtAmvuR/eG6Oal6obvMI6PmZI2oFFW11yb9cU3p+MGFDTHkiqJUsR+QQ9xcAuLGViUIOl3XvqhAtPL40hWJvFwFVDUz46PEnltN8qlig6PZKxZ8gX4jXCK8LuQXrnzAKUIPRxWj/X7OS/NE5rlhCNzDEUxprCv5oq+rBCH5xNwrRPhS2wGEDYa/xwcpV2/At5SRYKkoSknT8qS4XjNiIhnXj1M4RxkgRY/DuPEYpS27iy8ix4bTUqJZCCPyVayoLMp/3n+brovpg3dwDo2C+cmLTLeW4WwPRQwWU/nuuF9Isb/fF1Kqvq0Fr+KgZ4LnC0Da4xgOAw9YC4ak79PgSD1DugibrZiVBlXhGYqkMArQOPopfv+wsMoS4du5aNB7+jVW0o4yuD4Z+52o+aSPwZOQ8ArWa4MXui7HGdDYSsx3UTilBcpupDTC1Ly0CHsSEq4J6klV/SoIoD983rO5UECXcUL5jfy3ke5vabpGrzZs9Q3ki+z6IUZqNtp5/oOuKJi4725Ap163l056RWjLH5SFzSdv/NzMsgr2vZUoIqbLCGnuBpRcBpOTy8ESjNwjFFj7Weg2XSe+m799D6b4ueiBKXFy7wngruzvKjVvmDbxPDEr8msGpwrN8Dgyf6b4FZ7kAx95oeLGjYdPWE/4k8PeWlGNS6kwAgHbE2Pr2g+VW9Gj2XBkkSB4UfpJkEr3pnQ8WrHqhKUrv7jXzHqi7y0FjHH+VHHro3XERcIpWqMRJ+/Ytn+b+cZZoUuVKrVrj4x/ci+uJYAj3SjWhSnFpDGr8zhqWCsgHUnDGlnOCgzLP4kZGWrNYbMg6YgzybEYWgZljHOWD2y/qax8bozmrsCNYBsERip4ifGtHvjfwIC91pNR2JFiOOUVi+wPQUpYPrzmFy++FjWA6dyx7STV0jUgKOzvdYiSrmlDiZAwo0vC/ZfvTokUZC9xtatvr
 37zfQanK
 GDv/m0AiA6ckcTBT2SrvfSGXzza7BFUd+dFH1xXIi6Xoynt1zK/ESw7h3GJM+QpV90kvbHq150sXYAtT51XecMrG++hCkVNqrO4qfq8Du2KXYDf7QO5DWvPwMKROh2ch1GT0rSMxUr5ROhVK4Bcrb5gFVvAKqJ75I0aSBlagmCeOKSxgfd8RCc6trr/u8IiEv5i5BQVDxbL+QIFVqTqQGXm6Ltt0Ae13dS8DeGiMVYJC1t7E+8tRIJ2XgycRCV/AYNnsqZ/nO5JskzTU7r3pA3Ngam/AbbNlKAkk2orZUQb40mrf5ht9GVas3bujcRPtwUc2Xmrh/Fs7V7OWafgUEpMhjI3tlU9PU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> Rather than directly checking VMA flags, use the newly introduced
> vma_is_mm_managed() and vma_is_mm_backed() helpers in userfaultfd
> when assessing VMA suitability for userfaultfd and UFFDIO_MOVE.
> 
> Update vma_move_compatible() so it's expressed in terms of VMA
> characteristics rather than arbitrary flags.
> 
> Additionally, update the use of the deprecated VMA flag API when checking
> VMA_SHADOW_STACK_BIT.
> 
> A VMA_IO_BIT check is no longer required but that is fine as a hard
> invariant has been established that mm-managed mappings may not set
> VMA_IO_BIT so the check is now redundant.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/userfaultfd.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 949017e60608..f33b04700838 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1754,10 +1754,16 @@ static inline bool move_splits_huge_pmd(unsigned long dst_addr,
>  }
>  #endif
>  
> -static inline bool vma_move_compatible(struct vm_area_struct *vma)
> +static inline bool vma_move_compatible(const struct vm_area_struct *vma)
>  {
> -	return !(vma->vm_flags & (VM_PFNMAP | VM_IO |  VM_HUGETLB |
> -				  VM_MIXEDMAP | VM_SHADOW_STACK));
> +	/* uffd is generally incompatible with mappings not managed by core mm. */
> +	if (!vma_is_mm_managed(vma))
> +		return false;
> +	/* The shadow stack should not be written to by userspace. */
> +	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
> +		return false;
> +	/* hugetlb mappings cannot be safely moved. */
> +	return !vma_is_hugetlb(vma);
>  }
>  
>  static int validate_move_areas(struct userfaultfd_ctx *ctx,
> @@ -2146,10 +2152,11 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
>  {
>  	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
>  
> -	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
> +	/* Only mm-backed memory can have its faults handled by userspace. */
> +	if (!vma_is_mm_backed(vma))
>  		return false;

Again, for both I would prefer keeping the droppable check separate.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

