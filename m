Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5316BCA9EC3
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 16:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640F06B0096; Fri,  9 Oct 2026 12:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619396B0098; Fri,  9 Oct 2026 12:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5097D6B0099; Fri,  9 Oct 2026 12:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CF6C6B0096
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:56:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27391120481
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:56:35 +0000 (UTC)
X-FDA: 85303691550.05.7F7856C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 713C0180008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:56:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RUsl9XnU;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791564993;
	b=U6RG1+wGEOfytgH2MV1/85aI90CRQbwu5cx7zckoD/dFeS4WNlV2B7yJwhpo808fme4fcA
	51tC8O6xgP6a3rd/9NAmmsYUSI8fvzwNJ/wp0PBJCRkjk7l777MCJIsueql6fpSZEZ4voW
	RWN+A+T0UzVwvSLn5CC4xVIoJhSYbQ4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RUsl9XnU;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791564993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fE0OAfD+VvZZQlsp7SZETT3KsGTWZ99jT3uHHIgYDkQ=;
	b=6syubGUHgsTWzD+P9fd7lPQmhV8xiyf1sUIPKne7oBg0D8r51LW9c8Ov17UuwHDb/INKtP
	zfTe2UJsYyjdPAEdC3OqL1kU8aK4d4THCfnzmBrV/SYOJH9Tt7y+9FqZAlT/9x41qquVO0
	phXGUiWlxvqx2PShDAa2FI3D67s9Pf0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 646B160AB9;
	Fri,  9 Oct 2026 16:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2421F000FF;
	Fri,  9 Oct 2026 16:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791564991;
	bh=fE0OAfD+VvZZQlsp7SZETT3KsGTWZ99jT3uHHIgYDkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RUsl9XnUQdex4hYDI/nvqZumtgOTjlWiX0N56fVGal9ZXTElbzreII28hFeRkApJB
	 NHo6FTkv1s0R1SKHMxFh2yoyGgEj94FI2YTZ5R2m7lwDx9O3N5/dtVzHCZ7rRFHg+b
	 AtSEfYi+n++t5xP6H8VImwwnXKYhoLn2R1W0Koa99MOWI+o8HHqK2kIurxPlAU0Yri
	 ygANXuDjupNkgl+uor72EiN8FZ3fmo02D0/KSu5wQ2x84hwaNSlHgKIyyR/PugD/c9
	 1rQuaM8k2AyO9mDtnEOKbWctVlZ0WY0IhSQdg1dl1SdQIKXtdsg79DgnHAMkLcGLF5
	 UTDY8ujTUNlMg==
Date: Fri, 9 Oct 2026 17:56:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v4 07/38] mm: add mmap action for discontiguous kernel
 page mapping
Message-ID: <askajMD6aWnRZzwK@gremlin>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-7-a1f052500fd7@kernel.org>
 <CAJuCfpGj2Q092+zB=Z-d1iAOD6n1_HXVZQAL+YM6x_CeUEMpcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGj2Q092+zB=Z-d1iAOD6n1_HXVZQAL+YM6x_CeUEMpcw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 713C0180008
X-Stat-Signature: dp679z9d5f757xdyua5ymu3cz66ajows
X-HE-Tag: 1791564993-145831
X-HE-Meta: U2FsdGVkX1+F3uiYbm/TczfxI89RXk7M16sDzRHDwlmACnkJeVNcMH6Ku/A0hws7OMjFpMZeY3GpN6j6IfShzJAC7QcD961wpUsXEs32S7jTZ1Ze/UVmtfzFFPn5nXzZXmfpkMM11yqqfCJSbmaY56iewZGtPOMaRUJ+QbpcnuCMreCa37uj9zFUe8DgVm8kof5B2bH+u+p4sEpCHknsspaeed4iEcIZn45WYsecZ1+ci+bO3lRsqJCBnkLknpdJfzFCmWVLftZL10DgpvGJ+K8b2Z/MZUkxykaS05e3DdLIrENTcq2Z5CT7UAIQ5T/xWtmcCBRqZS1Cv83OW6ur6GJsHM9rz+/+4DJXTrWj91d6BroH9qrg9JnNnq5vMfbfCUeIXCGpb8YiXXj0NTH0Q9vie/BhbszVU+vp4KreJAmzRThPBZDVqTAEuhnZFzLb55uBAUaabjYLB6eHCKXIntdTEpXiK+lbnTOT/Xg9Ra8HRS7DpnRmPdMATiKT+xkILfujNvvaUE8TI27FJkMdD4iQR2l5jdHrGcmUIv62557Xsp2ubHynk7NsT7uNmR/RejQtDSVtDs2W5Qq6CtpbqCxxTkzBLBFOOBSw40GITRN6yxC4jQGOEd8Ry1HltAtw7DOuz8a6gZJHQpmrP41zUyJ1hpiTtSYtto7gXL4bndHHZnGlhv+dpMEWDnOVCT7YuI+EnMeB7RTtKqSnsP3FdZ/NSwhDqOi9nxkwBGx0PgBQ1gItmJtiWsElDhHsdpBvPgc4TCS6OTzGQj/WfHbSFjdg9fhdObaE1MjLgFIC5wMc/4SpbfR2a0nERqVHCU0oeHpM/Qd1CCTZHcsw4coL8Wo8WG+lIH4+MyH7a8iw+9aUXhPrj9KXtrJbllDqjJgcwyvrfmQJdPP5KN1IRyMPlRWn/UGKSyzjzDrtyB+suxV9S4jH1V1vkpA3CDwHJL8MZth5OZbcit2Da3r9xxF
 61QAJcCl
 3ADuLi/fZUKx9yoKE/QVegTK20h3CGNfQUrvuOvx0NLdX5sdlsCB3ZwI9Lfv7XoOU7HzzqXkwI0sDA1GIeQw0F2W0+OdTadxgq197X08fCjmXqkXX3Ak1XuFNhzywWF0PFa2HRkx/hQMEJZMVv9s14DiahwvgKscpAGL4Cp53VFKaAQhZmzuLlV7PVJ/4ApMPDSzM4NTvLLvvNABW9toQXKMdEl7UFDmJ6wohkk8BwjeeAYXHxng/mmnG93ckA9BCtLi0nKX3JjP1kuUm0d/6q8u3jmqcK3Cyj3XlDGmTOEuzI4H0yK6ny0oCku8H4Sx2oZkpAOXlZCYvouuiMGVlQB8a+tdLWs1JbWTz3Oc6pQvyO+0R7iGm7k+84oSdGUdWdA67Qw0Xyn3i3TFJQ4woZ1geDfg5tATpVM/3e/aonjt9hCSSUhtds4b0cWIsqvbxJxa438dVbVmwI66OVIj+xJOpvTaD4Yk5KlVZ8rKFmech3DXCUgYLJJSqOcVQEI9WjHuxV8svwEGWjfhfMtMH27uA4yjUuMyaKCKmRlg8ecynzA/K1lckGjfP4lfJILIYmQ023sZOjstBT2A29fEN2HUZ6atFT4iK7LGA93XOSoPU2sDyltkERHpKdYTXWc3cJkWxAM1Lmr8+B8nv3u3VuRVOnNvCOLzlTvGmViOIoihKB4iHc7K4ip6ac12ZznDfWDWNXk+3raJgFqX1jOGDqkWWphLX66NoOi/zzphSS3hFEjoWkPr0wAPCwL0OlwQEdS/Ond14O8Z+tRPUgGDwsyOW0rBjk1IQb1Br4qM7gtRHwZ+Lrf0RN5cnENPON06+/Ptrk+wBkf6DEU0Oraqn8VokRXp0ysPvRMAa6Q1+aW9qt0QuV9eCe4jjI7ubzVLWegQ05xF1A2GZpZe/soYRWkVSzxiHjkMC8x87kCew/UFSjxwcMfHqy9T6N+7gnXrtJTrVpkSJfygFO8KO6c5p1iVBSGw6
 0b+jr+6X
 8qNl65OiApz9hP/PmZsci/t8o5ZfBZLAllUfB2rj1KLXkjtlfKrFllBUmaW3qyExpE71pEcV8BeA22ypEJYS1Oa+lRgh2g3NWN2H6gXIN5hyi5r9PgdWMiQhQgWUOhnY7j3A4uXQNbCamuw4E9ZsebikujqET9s3OiKxM3l9WLQlNKreRQTw1ZlJdtnlaZRgB9ud8h26zT+vhu6wSxGlhjwEOL9qydxO78S/3M1mWMMj14F1EI0uQFJ0GmTcBFzupLCxFwKBleOtAzLQP9ZO9Iu3XNa3ABY7VV3I2Ml+vHOBZxlSWJto6LLb/6PuRKVfLE3sO6yUC6K77BiBH/bfR7CEmRhGtikXLQRF56tbp5XhxzEmakMDGB8tUkry+0EcfhPbLllswl1dfvYEMky8+57aTt4PRUCm0GMr4SzQkh1jyw6eFyuPZcog3X+ok7Psl2eVTyMqKrzKdzmRMSTpfZQotkbI4q4XzNsjop9qrbaExyG8vq7OHZ2cDVaQ/wok5jEa4sRIgi51u5nuCUZggfm00WBg51Z+f7UDWDr/DScAPi78xskV7CT/wHUcRwW+vAjT87clbuAiZVgLPpw4pAHbRAjtrU4Dq2wKgbVp1beuwOw0KI/+h6Ocnk3SJ5Kfky6ksU0e/zVJmWiywgcnbCDQRE7IaAgRsWvmGakw0hqhozQCU3I9W2cqBsaZFQKtKIJICvNTlEYEShnMoFiH5M/stqr1QS8A8qeq3chq8G5ymrg3Rrv7j/BUn83MGUGU/buKSb5lchCVc3UUOuADEGiqCAmIafB6VO35cjxlti+l6O7lu6m+nJWL8RTqKjGLrrDg3iOgK2oojGp+n6qMYFxYNuAX0GYuM6jEkVr/zRFBmr1vS3509SQU8nNRKJuFvUV9WXE0bMp8i6r6KVY5tPzYcSr6s6QY7709UY3ktPGFJKsoIcYGgjJxxumOWzykmuCHbIeGYLR6+p93u7ufXjdA7CXXU
 mz+xuAvo
 UbVhJ+HVnRhIlb8bZHituKMIg6uvIH9SXD4u/twb/PRnK+dnbj/nISLbjKRcBcN6WIqJJ8qQhsvu6uR+qyho+Dpz1lZral/waJFJ1AAVxMnWwhFpglYeyfD1dHyn/dVK+krdQOtdF3ElYr4O2WipWqxnNBKkhc1tQ7Ew0N55VL10nYm4tluJotR9txrf923UfowTxIicTBRlqsKsbJjE7qD1J8F4tKr+Rgk+cLA4c/oNgEzqd919x6ijlyi+nbwBOPFcu+O9xdquCkNkdndSQ7J3OLDz+h+Xiygwp4TvN2bl5iH/KdaqlXP6emb6TZI2O1ncA9y/+848GzbKPV4pkznq3ZEIg8bDOvK5k2YarTkLmvUXZCqA1/pJMVg1a2WE+/q+5o8IVqFlw6X3G8i1nQxsLFLqGS9ZGYNpnNKg+WYV5vqOsglKrMNfnTEqHPEIEi+AgvvEDU3WhvPnPWkDoFFKonO3oR1DsIvUIdo11eNqFKphWlSGSBAiD/6hVwnouH0fRe1Drd15x9WwJle3+5ks7ocYYEdLu/Vuv2Gu4X5lWdF5K0LtR2vdRAyJIMHtilFemhRjH/jCpG+CA/DryaW/Hb5r8JjPjPCJ9L5VX+MwcoYbGCnetBOxrzFkAptNUxlxfyfH81Xi7JV5/Psv6xPIFpcFV40WoS1jjEf5xXQNQ6sKFzfaPcgCYqPnDg1mD/aEUJo7dqUwQo7XdMxFgBXmiesq1JphcUASLFf05M5ukJhYV+MEEmBFBY0UkjDlIgIhVp6gZbNw0h1BOxbpb42M/L3lH+NBfJ7w7npEe1+0r2KMLgkOQkzwaXmFqQvP72k3ii7yqnqjJPnflZfxZBqF2MAdA4+CGWUPQo6kGL36PD6SBFrpwiYWLAZCulrTFtHNN1LBdTvNXlNRpOHe4wTMNRWeCK6McYeM6+NGP/XPzYg7LwE3g6s8rJAD85Y39H8q4pqJCHttW6yofhMNzsI4ilCyd
 yaMMTHdI
 GQ/VGYU++6a1g+r1NmJo2fqrNndSVeclnQWKjo/7PbS5ulzLzWSg5YISyX++HZeytX4fyu9UdHRdhvSmI+cHMSrq6oiQjFzLVIaqTh+/rVxKX+xSQvP/lfjtvbTUKBRdBxAOfzZ7vH4W5ZU8WYD2e6KqdgYMobcK7VCwiwL8T9ZrPStt9sMNH4yGnBO9GCqCl+Psl/GZNnQ/xnjpt1rFGjvjyNPMuuBy+XQYjSzESwIuVgs4bUSmI1YmMAHo2UB4GdX8CG5wRvUyTKa8uDpijfQ8FwSQ9k7zWjnXLVfkHAD4bMoeg1h4Kcj5h/8m765vU/tFHz7118Ufjs3mc4WtMEAu9Dm0nzd4sVhJaTVf/yIIrFUHQBUYxD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 04, 2026 at 10:11:18AM -0700, Suren Baghdasaryan wrote:
> On Sat, Oct 3, 2026 at 6:35 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:

> > diff --git a/mm/memory.c b/mm/memory.c
> > index 448342883e9d..45b21bb04a18 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c

> > +static void __map_kernel_pages_prepare(struct vm_area_desc *desc)
> > +{
> > +       if (vma_desc_test(desc, VMA_MIXEDMAP_BIT))
> > +               return;
> > +
> > +       VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
>
> Sorry I missed this before and it is pre-existing code but is this a
> weird way of asserting that mmap_lock is write-locked? If so, why not
> just use mmap_assert_write_locked()?

Ah yeah, this weirdness is duplicated from the existing code. Will fix up on
resin!

--
Cheers, Lorenzo

