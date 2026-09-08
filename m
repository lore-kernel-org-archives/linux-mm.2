Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E54DDC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077656B00A7; Tue,  8 Sep 2026 16:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0282B6B00A9; Tue,  8 Sep 2026 16:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E59916B00BE; Tue,  8 Sep 2026 16:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6CB36B00A7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:16:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 648181A023C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:16:48 +0000 (UTC)
X-FDA: 85191703296.19.B7EFE8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1FAFAA000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:16:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WUvpBjcJ;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898606;
	b=pgymPVexsSDN4hR6nq7P6LMvLbEX46u1Ex2ksuiPr+YzcEnamhktpQGiHIdDkSGTBXf3fE
	YPd51DkXUbuNrA3WnPN0kTrDj3T3OevUltqs1V5UanCnQ4daLdV2hZV8ZWbfcLSErX3Mrm
	UzKxCv7I8CxJhRIDIR8ZhrWA+ipTEuQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WUvpBjcJ;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=00Ytz0fGJRHe4Ncuh0cIgBWI8kQ1fPndDbpD79dfnG8=;
	b=5EnaFHqo2vNXovLyScR6QByhx6PQ9ejf6oejCWUFhW+vymk4GIsBwLU5ZRzy+aL+S16MoZ
	StijkYIYu9hsYc3W4ZCy92XTnqUudxVVTmaQaIkXUZ9tArXCX4sNHSYgJ8D1sV4A7kxXKd
	1sriYj8p6Kx0StICf06xtY9XMwQwXP4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DB3242EAA;
	Tue,  8 Sep 2026 20:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B171F00A3D;
	Tue,  8 Sep 2026 20:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898605;
	bh=00Ytz0fGJRHe4Ncuh0cIgBWI8kQ1fPndDbpD79dfnG8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WUvpBjcJK9lkzTNgIphelUj7gR86mDfMTCrOwhcFWV7g9p3pkJ5JhkmROJL5ByxoX
	 9Nki+EY0vDqqzBpPdR18j9HlKTmxYLMJJruC3U8CEzXLNOUbs6LIRhoMLhjQCpSCqN
	 Wf1s3OkrIjuYuUJuPfOKprUFhl9DF7x33b6Pasm361AA0CZR+1G2TbyfZ80ECy3N7W
	 ZinGditQa0WlJZ2zIjqxeO/H7xGHW8LZ6YtDotQbIkvTmpD/hKHGaLw9qEFWf22ucU
	 PsZ5SrQdViLWdi2omxqJS0HS6iJIP8ppo/0YWIVXJi+m+G7hAOWXEoIPKzyC2G0qXA
	 j93Z0/FzwiV1w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:34 +0100
Subject: [PATCH 30/39] mm/vma: introduce vma[_flags]_is_persistent()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-30-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, 
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
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
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
 Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3843; i=ljs@kernel.org;
 h=from:subject:message-id; bh=OGo5/9n5J+oAqKddihiTXuavq5GzTxtl2VUhPHcEqY0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG5lCnKMU3Q12TQzKnBGa53ytyTXH5z37x7z8xGx0
 xEt/RjYUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgInYmzEyzC0J3nr3h/bjeXZd
 XS4/2fNf5cx35/r96fBGHsaE8EyBvQz/y6zqu7Sq56n+6/yTem/yPnPBhrXLLhXMkPzn8n/uUoV
 KTgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1FAFAA000B
X-Stat-Signature: 6eyaofh5ouo7nsq7bfgsxpiicmj7swtf
X-HE-Tag: 1788898605-123371
X-HE-Meta: U2FsdGVkX189zbbTQKb5Y4iAfQIDxjfvpY2McDvBtRd8K0fvHIUTKhyVg1eRqIqW8yaOKEhMuBHNSppklEP1prh02EqMubH4/NsEzDVltwBiC5lG26RBnQNj9bolrpDqiy/2e72ZtIWRaPnTVV/cewEtZQeoX5TQmsShisVoKLSU9sWfu1P2LpUgP+n408oSO3eZYewAjVBxf0Qa+a3ZUMQxK0xUpHEH/czN17daUft2OUVF46ObL+UV47JoF+NQvLKfAfP3ncKDM3fa3aEONLqz4vUKh10cLbcayO8kQYy0CoGP7L3thUN99Q+qQ0ENe/JAg0WKvyAD62hTKMJ+d8j6H7L+GVQgsQvCjkwy/DX04chyG8qPxP8fWxTzbZFKnekF0GFalnapV5zniL32XNIxXb6d9KqyDXMGLiqfkpvXkTJb8wOHxWwEUOEVxU/hy8lINQTcstSX13yv9/fZD60+VNRL6hh+p6+lfzAYNkeDmMWGypwS4XQGnJ8q3fA5VoGdnfglw9dGFxaafDBLym6YsSf1BUHbKihZOYMJQEp8GXiixQKxECf6wGJmswiOsiB45f9Wo4b0kxVFTCsc8ScoNc2wuqTh+oFQLgaQaxWCovSDdepvNqAtD6JIvGhrvG3/vjFow7gu1VkVeEhNc1oy3QGTTBcDepIaf1oCyM1FUbifr72UIfSUntU1ZjXwbgG79ShMc4VFtSPMJ+Qi+PWCpNOXikWhlETrCWBxRndWJteiurYkMtwY14si1gKp3/yw24z78+TGbZzuLD3Cmo6YmJsILDT+SVNkqPBcxfX/7oBs2/KRRT7qvld0jiMPZH55p+Sxl045iTEZ4jAVO0cMjrirlU9fey1QUKq8pbKDt8Kp8mWpnzsZuEc/T2Mou09cwooVbgPFYtR4liup1dvryBU+EYDC78RssclxWfF7TKQxsQsVkWGUxo/NIzSKyRdOX/bYt9ZhtoZbsKg
 1kX8Djlo
 OXOmjlgkPdDhtvBIFIvjkAUk1I0emh6mL3BFodBJiZ+9SimwELHmrdD1LQ49vltiNw9EA+13C3IFTex3G0vGnAIRN9Ok34UK6EQjxiw4KgW8sxC5UTe+Spiz9ooDm+zICQ47FAKRO2M0oBN23emcewyHW+XbMV03U+uHSpeJOjAG8f1mri8/un0WhfstvV9MHNjecHTTfQIWwsshmrD10agn7euyzLb8QQZxduMQ/pKmvVtdeoinqFYMdF7fKXo40HZYlVR7vxN/6gajG1jDeAMDOTqPsyS8MmacohaQszQl8Tb4WXZJ9RgaLdSI+K+d8UKIXERyd7YE1B0Knm/xErxCTkQ9/kCQF4PI4LXngpnFhN/gKaKH8K6c8vcVMIl/I9GSDiGnOHzjKuM1O6yfr2WUkveQ7bFIiGubGAbWUPjAKY2bKpmWuK37t6qQrqjV7/7HDqFvKdNRrDYzLfLexsNyqcMZRoqoFWRzChEs4sOMpSBn1SZC+Ewsg6Hk0ta6m3AtCiBizMiyxDMZVeQ+Lt8J2NZCpr0s79m5Y/J36CLdE1SPjddjtF/rldeJBUn/kRpmIOrrQGGvNmsdnownTgm61kqyP0unasKHccKHsHq454iZInnGf1eCqbZ5J9w+hnI4be9V1Z/gQJ+MgaFnyGKUW33BfckVyxTngGlvLOHNljdYZyxXLfkr+hg/2kSpjjapd0DhGbWqkCLtgeHn+TNLeJuflaKW2ijq5nXJqDi7MpXAnCxe+arYH1nYxpFtDnfnhOHOxsteGEX1rnCqv2iifhIii5cYCf6V3UsAGMSUXeUQryTCic25YXo5n9V5xGJiSNS+cpgDDmQ/25QJXArGM1dDqi66EqKWpAQznZ8ZBW55TK2gtuniEzhuvUvL4bUPXGwGwS6cet05mVOORrFZwAtKw/L6mxQUWhikZRU1vuRE5fpXasqo2NDOZ2Lzo6Vw98nxe3F8WZzg31xBC7VekAiiZ
 pYSfUBPb
 nguArmiJyfW+lWONQ/41tE5hlQSQecnivgvtAcUhuGza4jHcezE++180Cuu5w50NJV6ks67OrACsCpsC+ZeGTOE2637DwRpW6oVFKqzCL7mhV5CaPiELeRsHP5XqWwrQYGowgjOraWH/kZGHGr+Ez3lj3WuinSSjox3pcFnR18Cr4LuWzp/r1demArmSw7bZh/yrBZNlzv41EUlfFf33mLgTmFYttCIU2lywiIXON5Hnfif80dHaGOvAeTH0DSKXyNdGrTbztXtGqkOXdC02kS+6WpjSboZLLgz8zZ8w9bkxtSNtwiK+EWhSmCfrjNJulj2fnrIsnm8W4TA05cKz+RcC7+oi/JElSUZTH6+2KhEzq6hdKeQn/JKDBSM9TXVavcklumbvP9i9SE67DHXvHmduhzQtlaurftJjCrw6m88Wesk/zWX0SwGYhEPmV9cf6YHiiOo7zPIVuTo0Y0mjJUjLRZ2oJr+04WxTbQhiIwa2FrhlEXrStmI0OuVwSZ8YRRRxOBt48wkNBRn7k9fBc4H26P2cTT6cpGKaEZeb6JZZt1lhq5iQRZ3W4peAAu79uv6fqrFEoSDOcIIAD0A9JeziIjzakdQNPY7hOFolZnz/nc5avRvUe8Ytyg0doI/kuxgRy7xzkNB4ImeYJbS/uMhVr+8PVI3s+SEZKUkQ3oBp5SnKFszUrjMYdpRvb4KJJR+0kgMZIBEmBjrTdjfUJJnqL+MbDCDt2VsCkj2uT5ApvM6vnzjBgBKA+QKxEECZicOp8fkPT8JAGqTl1iULCKi42OykLi0jV1eUbNpIzTKmRmgO54vt9o8x5efMU8B0gbXh5w5FN5a4Usl8zKSdJ3A4ytdj+GMH1rv73C6iKJezCWAnCQBKCwRw2TYSm8I+3svmE/4lZjR0mVc3aOUuWk8NCai3xqDfIvaPa72e/RNgf7SMopHSFQAhE7qBoSWhzCCNa/yEn2yx8R08byrVT6ccCwUbv
 BnLpQXie
 JPIJ0yFvU8gAlaY4soF9Xj7OF56me3jdq5gJnATfmuvYfzTkw/llVBcZbS30WdcLM/Ly8uY7MN20tuyRUYwIXVcmwsnv+NI3v/IsqUu1DI2RWexES7H0+d9wUb+R+5X692auYArLscwk2JtJhS1wSIfIs5BmqDm5LvPU/ojD6GDWQmRRsZRD/XIAaAQkYjuD5lunvj1ivuSR9g4vFhrYTFwAxFx6UUJhiglvkkX6+S9al1qJ/DjZ2wpCdb/Prum3wAthfSEzTYhfl3FW5En95711jXvXbpZ+OBJaQ7LSMDjsNQj6OV54RZ89SG8BUjG9kY6/RPlsxWaZFYVf3THWNWRsVwwOU9QVnrGGhJc12ehoSO47u6waVinX6ZwYAJn65ZQcGLM+OOBe4T/LCtdDslI1sbVPPs5r/aHZN54BJonCHst5nywgb71u5GgVabI+3vAmJk65QnzT4PmOMbir4HI5n8JQ24ETo6XTsYfbBtNl7drOJR4JnJFU1tlV9DnBwK9NyBbyYpFRKw7wLGwjx4bKo3uxQa238vhcMLWnKoLRbIExzlZyjSsY5GKbuF7MirX0/b1coBjSIOHdg1MzWByGNvJxRoFHp9qcNwtg0FQ/fuM5AopL9pa69iXXbmG5bURekCNX1CVrjNGttMmJTMACwl95q9ShhJs+lr0nQ6cRIEjNjOifje3ftE/rIV71ckpdybDDBs3ibJep/UQF1JVne0Y6hkRGipHtUZYfcMwiR7AzpMTrDSn5XLUZZxw8A6glRnzCRs0M0RM01kverQ11EGYRozmN0aIBcUuawS98tNFURq5vpP1G25pksIp8UHkAgeIKV9d8pPpw7zVNq0ftl17YavHz8hSnl0N/NRckLRa5yQK/3cqOxobnX5Pyq+XUD3/0pcetv4OOR0n7mZasbx/T7gm0OA1jy/X7NWBzfyl+tyJgsZw6vaugbWIkIYMcfZWHYmKr3FsNGlf7JQn3JsJro
 /Mqs6Lk6
 4txMwUCGWc6Bi1wem5C5iqPpcXAUsKdA60qzKKPpCaSExFkZuI95SdL6BnH29VZ+PuBKYm6h5CCkH0iHrXcKN1nl2A0era2c770VuKQg1xYD9XeDcUTd4tJHyKNHlPzrKBZ3JbMLPPrQlFoSwMMgmX0mC2bQhpJQLcOJI38fxTbHeSV6bjPwQdPvQZCD8xePDgmQoCf6/rBZLz8IL92PBHnSKo/jQ8ZRaU66dq5GoERJyAT9O7JDOFoqRM2ZLo4dna5F+dUKaXogzmEs8Fx3hGC9wmluV339w+yxFU4epxOn5WkwtbGmi8tboZst1qU6XDnqLA3DeQiap441909zkA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce vma[_flags]_is_persistent() for the purposes of identifying
mappings that are persistent in the sense that bytes to the mapping stay
there, and bytes read from the mapping are the same unless changed by
actions taken by userland.

Kernel-owned mappings do not fall into this category, as their owner may
change the contents without the user having initiated it, and nor of course
does memory-mapped I/O.

We exclude fixed mappings as these are singled out as being unmergeable and
so cannot be guaranteed to persist user data.

hugetlb mappings are fixed mappings, but their contents are entirely the
user's, so they are explicitly carved out as persistent, as the MADV_DODUMP
check already does.

It excludes droppable mappings, which by their nature are ephemeral.

Use this functionality to update the madvise MADV_DODUMP check to test for
persistence rather than open-coding this.

This replaces the VM_SPECIAL check which means it no longer checks for
VMA_IO_BIT, however this is safe as we have established the invariant that
only kernel-owned mappings may set VMA_IO_BIT, so we implicitly include
these.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 mm/madvise.c       |  4 ++--
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d8ee0ca63ccf..e6c3ebb09c8d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1741,6 +1741,50 @@ static inline bool vma_can_merge(const struct vm_area_struct *vma)
 	return vma_flags_can_merge(&vma->flags);
 }
 
+/**
+ * vma_flags_is_persistent() - Do the specified VMA flags imply that the VMA
+ * contains persistent data?
+ * @flags: The VMA flags to test.
+ *
+ * Persistent in the sense that - if you write bytes to the mapping - do they
+ * stay written?
+ *
+ * If the kernel or a device could write to the memory independently of
+ * userland, or the kernel could arbitrarily discard it, then it is not
+ * persistent.
+ *
+ * Returns: true if the flags imply this VMA is persistent, otherwise false.
+ */
+static inline bool vma_flags_is_persistent(const vma_flags_t *flags)
+{
+	/* hugetlb is a fixed mapping, but its contents are the user's own. */
+	if (vma_flags_is_hugetlb(flags))
+		return true;
+	/*
+	 * MMIO mappings may not store what is written and may be changed by the
+	 * device. Kernel-owned and fixed mappings may be changed by their owner
+	 * without the user having initiated it.
+	 */
+	if (vma_flags_is_kernel_owned(flags) ||
+	    vma_flags_is_fixed_mapping(flags))
+		return false;
+	/* Droppable memory is discardable by definition. */
+	return !vma_flags_test_single_mask(flags, VMA_DROPPABLE);
+}
+
+/**
+ * vma_is_persistent() - Does the VMA contain persistent data?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_persistent() for details.
+ *
+ * Returns: true if the VMA is persistent, otherwise false.
+ */
+static inline bool vma_is_persistent(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_persistent(&vma->flags);
+}
+
 /**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/madvise.c b/mm/madvise.c
index d0b14cfe38a1..0fc31835fee1 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1419,8 +1419,8 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		new_flags |= VM_DONTDUMP;
 		break;
 	case MADV_DODUMP:
-		if ((!vma_is_hugetlb(vma) && (new_flags & VM_SPECIAL)) ||
-		    (new_flags & VM_DROPPABLE))
+		/* Non-persistent memory cannot be dumped. */
+		if (!vma_is_persistent(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTDUMP;
 		break;

-- 
2.55.0


