Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAAE9CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 805426B009E; Fri,  9 Oct 2026 14:05:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AED76B009F; Fri,  9 Oct 2026 14:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6501C6B00A0; Fri,  9 Oct 2026 14:05:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30ACE6B009E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:05:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4A2B140462
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:05:42 +0000 (UTC)
X-FDA: 85303865724.18.0D16047
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D806E1C000B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:05:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RbyMEc8P;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOHuuwnsMbHTA9q3JEw9/BiBEzfrt0DoQ4gWVubuCD0=;
	b=GQDdLfdJV1cxoN9COQ0UNX8njAiOQNVqIlkr572cPPtbF09xeOmj0Pi7Pr1OhfwsWsTO/S
	Xot90PFHxmKpAqSzY7LFc00yPJP9tk/f0uICW5Oy+qbbIrd6x/CRiUQegx1Q4nZdRGdZ7l
	mtKGCVoZ3TMuj8z7RmDdwUHi2TMyimI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RbyMEc8P;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569141;
	b=Yh437u35Nrbe60Ndbz3s8/2XRaU1e8GhMpFh8OUOCWLZCN7jDsog9lEKXrbQUQcUPrrB2w
	HuMRtXRwysBOQtZLXQJ1xCPRhEa1h/zT9V0WdqY7ovPx7naC53Yie3jccfj65mNFvaWilb
	QRELT5ArRp9FW6GcVI0MrF6oOZuHynw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DC644198E;
	Fri,  9 Oct 2026 18:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413EA1F00893;
	Fri,  9 Oct 2026 18:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569139;
	bh=oOHuuwnsMbHTA9q3JEw9/BiBEzfrt0DoQ4gWVubuCD0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RbyMEc8PLZ5owQ5rDV7Noki16ZvBLbcNK9LSpcJvRg8g/yDJtiCiPNAdnDZyGBNIE
	 4/dre0kKfaGgadbKQAWqy7+oizGJqFE5zikyvgi3Z4lVg5tFNpzKVUrpA0FWjobwrE
	 vXMTWpRhLOeZumcz5A6Xfs5oA0sDVLGjf/M5qhCRHA1RP/K/zR4Q9aKymcSWBogZq4
	 kTNhW8TkoXpPKWqppTXmYlZMUldsiZH0W9MeydwTSnL2UPvGoaIUr3XJ489sYglMrN
	 ut0t8d/Ux4SxpXkkSSjsxny8hOoTOnpjFaEj2Aub7lK1DPvJ5NhUZzSJ/Hwx8lF3JD
	 Af19w/zGd34bQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:03:57 +0100
Subject: [PATCH v5 03/38] mm: consistently validate VMA state after
 mmap[_prepare] hooks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-3-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=14131; i=ljs@kernel.org;
 h=from:subject:message-id; bh=O4LeOMp0JmloXP6dYxpxjgMqSJkeWfRNP+c31xJtCHY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sz0CNWcYfu4xG/GzcwrBx29ArgO5uySVLepdp/8L
 zDnw3r5jlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzk0T+Gf7risetd9J99LVp4
 fZn1TmnmbVMPZsdteZJvcDDUeJ3YtoUM/5TeBb0pMtRcnprS2mSiu3zR0hXtTw8Y37yuPT/TM9Z
 DiAsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D806E1C000B
X-Stat-Signature: o9edpai8egyaxddai7kkweadayqsi6aa
X-HE-Tag: 1791569140-725419
X-HE-Meta: U2FsdGVkX1+FM85e8NXQTsuOM7Z+7QahDSNgvnsDpeEe53UfKOSa9v37bS/aygSjhL90kY8F8jSbWJFRN10fPQ1s41ZiDlYuSxsG9P07iYjOj6NS87urZCldXZ6gCWWZmvvjmrwUy/yJl/dca4vZi37DZrqMSEVywIoIZibzac+nGmf2kfl6Z4iWdHKKs18PE5GH91aYYwDX3QY3rofpA1dwWbGDBPqhNq78DNTCS4NjLN6GorvEgcdtf3YZ0MsZUuV7rVww/jopb5G8x+wn8NxoyKgUYmjOoZeakFEhyvGV5piLmg9onf43tt61GpgwH2KYHy42v185EeIGYQxLR+3ZKNjEWaSAaO+CuFtqtuq8Of4NywcFppj65M8kta8koJHxcUFIC/ldXps82Xv5upPZPXt57CvenFRLpziXeVHB2iuxEKW8Bvk2P/6f7nOFfgWfBBfbezg0ZFzdVTCYED4RyYfiEax5+QPjU/gX/TwKQA1ucs3l+ejYp+/6XR5e0LF3Ke5piqN5PRG5jvHDM0w82ZKZDrl2znPFRciX9cZqmhBdWPJ44Ssy8Sl2VSP3gQYlnI9Ih+t8F5GC9AQIxIzENelZIThMo2tJzc/iRi24P9513/8HWTECQWEXdQeA7lITBnTvYavnWexzoywUiPilAFT6+hcFy3lvYwVYyW83zEw0NhH34d5l1cD6yUJtyye/xtcNxLPvXu8+BozpXRm/Uy/Yh9IWN+iS4ptBunP0QfGgt9VXjtm0UUcC/YcL+uYL4P+3eAz3lbdShDsCua4BQbbMsGVAFcbjIKzyimL7yLqRGD3B9747BGmnVOaV0qjJE1D/8y+vsy/M0gUKogIvdoaop/eaF7GRRw740SjN3cUb4ulJHH8zsAPcLsm8Z8QxtJuXmAPd6OlGMz330cto+84lZsw8s/Au+Lb8bxjURDP/YARzjapLvE+7B2QTQSLuSLjKMUmua11DGtF
 5bKQuBup
 Y/VttOQz9/vjkNMVT/e1tcbxS3LQOa3nSkdzjnCrsW3eL2sqzL0cmtMMtvSiFYBNvVZY2kNV5Q2lRlyN2NgG+boa+9tWF+KOyC7xQ+mVcmu1JA6G83IDToNNYy5wc47MQ+R8mHF3WyB/gwaog5MbOS0caLrz3yMsJtQk2hczVhrhQuH0E9nRRARUaOVf0Hk3uoryih5ZIEzwh8z6XIn3gmIqmh/tTb1qGv9dmiUFU295uJjzYu9FYDRswjkeEsGakdyvaS+Au3Bd+4dB6kslYRIba9S+XFgyRMPLXUUg900A/HVXnBj0usE3kzmBGkPKhUL949Lz/R6DxjPJ0Bc8DEuot3dDKif6kHwCjm0fNYu0eBfRM+AXQsKcJM1KKJN+PqddQjVfbh30jeV6ZbqBlOe9+WBggT4gTbhJXUif0IsAkEb7QcKD5lCiZrsAl34xDlPZy61p0evhNnZm+7hQlimIieTSXoqcppJ8KFKMilFcj/dnsyW2tNL0X+3XLwd/sGvB1m2VDQ9rNZF4jyJa9GCyWJzneY1rt/k35S88EM6uy2GpZYCJ39AWLMgduAfoTdjtyipWGb979nf/1YVA4jWlo6NJEztwjbS5AnZc4BD8l5QJRy49bucIAbbXnz8xGiVw5hawbTsj0S2KQaNu1neY/rVYDQN4uQkEe9RFmdOi8jXYWvRTxsWcTQkoepdPuzwcJNpeINi3AxegnL0BQiWN4YxHVVPcmCPmoBW8LUlS3NxYwcKmeWLR3RwSc8BTYpGL/GaC7RWkRqt0/OsSTReGdkXtdU5l40yMjbpimTeFIGdSMLfLFBthzW7lnLJFv3dudJDZhyWWJ8ffTYHwgrDeJ4pQFtRQMsqX+adDI34kDNqLoPjPCqU4Utqe+DltsKQ7PUnewF5deGjxtIdgpE/kNVqSrO+qMOpgZibtsppXqoejvzRRlIrjncKn3/c+w9xQRz/f+cYvePtUy1/wn6RJbo3Bj
 Xug4d0uI
 jrRAFuF+8igfJXLR/7j5cUydWpljlCltJx3ytNOZ6aP4NOTJIJzuUUF2QPwaY3ZiqRQCrrcS8Fhgh+JhCsiHtSaIE3tbXBQuY9I5z15FD38j2vo5/chiA9iD1ZC3yBrbndVnVCi4Cc3IaTFvMp8x75oIw0gHX2bRTSzV/L461eiXXXHzzFYn6ZxYDfpBE2nNE1WAf8aeNDjVez0FfTiC6pbFEStp1HnANw7bwoB6MBzFrFdi2K5NoYpl0KK+0LxrO/MgbA4YLZPMZAxhxJe4xxHwGtLM7/iS0ijO8dxERVnaKPi05QOZgByGhXj1mhkGWpTF4i9mF7RBofN00hMCkZp8yWfLHqdYv5pNXoc86DVcEE7HvO4ba2EaH6wTPq0fggCsWUv8LFcyVqF54e62cCAXyT0at5xm6GF6QQCk2gQt8hTd2RyZK8dy0SmM8n8pSCGOX4mp10bTM20RzJeLN2crFMXOdu4tD2XHLMrGN18q0iFMvNkwthrQG6mtBca5UCRHIDkegl6as3cJ2A+fbqZ1N13L0XCmnde16vqAnUWCPfw9B00ITFUYywOYcGwID6d0FlIe2NqkgzJbdwzy4xqDIW/ny92bzbtlQOdfpwAyeorM5icZERRMmaJzHr1fDOSGxdGDrW9Y8tbX1J6WgaUQZRAWzwubjJbi+AxthJRnFVcftErC5xD6RtZ0lH08MxnklDbKzUzGEHbk3FeQHDOF+MQYKIWkT/D8pyTjKWappA85IgzMF8/LtqkZczIR8hZTcfBUQV1HhzBMEi4JZ5u7WbeCGfpRvH4jsWDq/MV5IVw3ynXvORpZVsMXbXYIT2eC0zkR4881Eup7pyzv8Hqn1r/gyr+q8CrnvzAR57qXvKEDAWEGbCPl1Wz47C92RfoDBbYhfye5ZqUbBJA4KOWI5UjJQ/vvgZeWcVXJ23v/RD7LRDlR06NFc4qHUgpuYhUY3YfCKQsGdwJ3KJ6lp8quIn8md
 zA9uHn1U
 ljBOhgbxHm0+suexfvIS9BggG/IDGZMgI6tSWHqZKPXDOuzD6PvUDVuIiQymtweo0yJRrrYHVDQ0PKsvVIaqLmJ0lbseSRDQebNisL7iNOpTnE1Xu+aLPVKB2nnCTBU8jfYOJxyX4veijMbgToN49P+YdWKgFjumD4VFJWuUPwNj1sz8EaQygmyljxz2mYTLXdFIaUrc/B937EQyIonbHq9UNxcFHMbg87QgkI2u7d/n+sEMNIh8PFPZ/iWRhGgflKu2wtkwelkr6/np32wZ4OYGPVE8d9p+YJmi9HJsWMHO+ngIDUHRilCSTf1X316ZayXlcIfVQv817SfnJXUzINwXU+8NVxgqe7RBvrrkUzQcmPKqQ/wgpKi/o+WtUaYy9dCt0USIF/RdFK7cdOkY7sOzxXmBHKoz36sllgP+0wNC0A2xHgpksXnOWkyASnS4PxMiOd3B9e8CcrEA51gopSK1B/fh1gShedzbrC4vTAUEOXQlaV0veqm7OuSOfBMb4flFiluEGIOrlW9YKqNge9TaqRfngxgxgFJoWPv0NXrrfZmuy64jYMwxlt4EpygzRAk8DPfnEOoOVMLRv3rjYXN5GltYNBnpN7fUIsuGggfHe01oBQwVTpLPz9dgbRAZEbWpN5QEzIUctipatDvicMJHmDB2VR5/YbN9zvmZNcTEN2yE+rCS099Yy+XABYFk9hvR9Eu6w92rhDuzS2kDJK4Dl9pdjIQq1vqXia/XT5PmeFJwHIHMGogrBelE+XIIqo7X4ivCKjJiI4b13jGSqa9WFRRL3oTMtDMb3mKQ+1ZzSS9gZwJOTlsto5oZQxpIA+TQzUigu5r1IrECNvnyGCu6jmlaLEZ7RTu1GXAAs2xO8kW84P9m4ZB8C5+cc558qy/Lu7lfvajUiw1jctipetjaSeRqkoi577hS4Z1K7Su9LkISTjNS78vStM2oCdkquPhQux/VkEwfF0eJDSMWU1eN0qcgD
 3IUpGRE8
 iv2mQPq3zAbR2dUO2bhm+ykxGyEWemzQMfQ8rAP+gOKgRYVWktFqwr449psOl/miYPlT5zB+z++gUNOSKdjqP7xZTKy31f2dTUl3CXsbPWYpVIokXJ6mNJonA0VDp7Yqlks+GeWBY+npVfG+8lVxJvHEBmbrlHqxKsAbdY7LNA9b13Hj9T5fAxUSweeoNTW0TY1CZ/Wjm8Yfn6dpZr7U3qarn7s8RyNOQnrCJQeX3sn1Zzu9YtykUUle+QQQjfnhXliBNBGwuWGni1M2CjwHroPHrDSlpXVcGUAZU9kdcCmzaft52s5XYMN77yYRMAGqGKzpzhlg3odGtnnjV3Ok/Kq59hQMp80BcnEP/NuawycVrkDS2nvwAjLKnOAqzbHQWVWEWdkaj8iPXOVNsPnBga9ZYNWIEbHfDyJmP9UMdHnDID7ZFZuqS4+Q3Upysvp211jFeOR7jpY5g0Fj2zIHMV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked, the
driver might have done something crazy that is not permitted by the kernel.

Currently we check for three such cases in __mmap_new_file_vma(), but only
if the legacy f_op->mmap hook is used:

* Did sparc ADI result in invalid flags?

* Did the driver alter vma->vm_start?

* Did the driver make a file-backed mapping on a read-only file writable?

Generalise these checks for both mmap_prepare and mmap and apply to all
invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handling
in the core VMA code and the mmap_prepare compatibility layer.

Also extend the vm_start check to vm_end also - drivers must not change the
VMA range at all.

We also WARN_ON_ONCE() on these conditions as they are things that should
simply not occur in the kernel and it's important to call it out when it
does.

We invoke mmap_prepare_validate() after mmap_action_prepare(), as mmap
actions often manipulate state in the descriptor thus providing the final
state the VMA will be derived from.

Also call mmap_validate_vma_flags() in insert_vm_struct() to ensure that
special regions which are inserted (such as a VDSO or VVAR) also satisfy
the sanity checks.

This way every VMA established through an mmap hook, whether via mmap() or
the compatibility layer, or inserted via insert_vm_struct(), has been
validated. brk() VMAs never pass through a driver hook and so need no such
check.

While we're here, also fixup a couple disjoint blocks of #ifdef CONFIG_MMU.

Finally, update the VMA userland tests to reflect the change.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h                     |  50 +++++++++++-------
 mm/util.c                         |  19 +++++--
 mm/vma.c                          | 106 ++++++++++++++++++++++++++++++++------
 mm/vma.h                          |  25 +++++++--
 tools/testing/vma/include/dup.h   |  10 ++++
 tools/testing/vma/include/stubs.h |   4 ++
 6 files changed, 172 insertions(+), 42 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index fe576d468af4..061a87f9c3fb 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -213,6 +213,24 @@ static inline void *folio_raw_mapping(const struct folio *folio)
 	return (void *)(mapping & ~FOLIO_MAPPING_FLAGS);
 }
 
+/*
+ * If the VMA has a close hook then close it, and since closing it might leave
+ * it in an inconsistent state which makes the use of any hooks suspect, clear
+ * them down by installing dummy empty hooks.
+ */
+static inline void vma_close(struct vm_area_struct *vma)
+{
+	if (vma->vm_ops && vma->vm_ops->close) {
+		vma->vm_ops->close(vma);
+
+		/*
+		 * The mapping is in an inconsistent state, and no further hooks
+		 * may be invoked upon it.
+		 */
+		vma->vm_ops = &vma_dummy_vm_ops;
+	}
+}
+
 /*
  * This is a file-backed mapping, and is about to be memory mapped - invoke its
  * mmap hook and safely handle error conditions. On error, VMA hooks will be
@@ -225,8 +243,12 @@ static inline void *folio_raw_mapping(const struct folio *folio)
  */
 static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
-	int err = vfs_mmap(file, vma);
+	const unsigned long orig_start = vma->vm_start;
+	const unsigned long orig_end = vma->vm_end;
+	const vma_flags_t orig_flags = vma->flags;
+	int err;
 
+	err = vfs_mmap(file, vma);
 	/*
 	 * Either we tried to call the file hook for mmap() and an error arose
 	 * or a driver set vma->vm_ops = NULL intending there to be no VMA
@@ -239,26 +261,16 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 	 */
 	if (unlikely(err || !vma->vm_ops))
 		vma->vm_ops = &vma_dummy_vm_ops;
+	if (unlikely(err))
+		return err;
 
-	return err;
-}
-
-/*
- * If the VMA has a close hook then close it, and since closing it might leave
- * it in an inconsistent state which makes the use of any hooks suspect, clear
- * them down by installing dummy empty hooks.
- */
-static inline void vma_close(struct vm_area_struct *vma)
-{
-	if (vma->vm_ops && vma->vm_ops->close) {
-		vma->vm_ops->close(vma);
-
-		/*
-		 * The mapping is in an inconsistent state, and no further hooks
-		 * may be invoked upon it.
-		 */
-		vma->vm_ops = &vma_dummy_vm_ops;
+	err = mmap_hook_validate(orig_start, orig_end, &orig_flags, vma);
+	if (unlikely(err)) {
+		vma->vm_start = orig_start;
+		vma->vm_end = orig_end;
 	}
+
+	return err;
 }
 
 /* unmap_vmas is in mm/memory.c */
diff --git a/mm/util.c b/mm/util.c
index 016932780925..d809e08c7b4d 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1224,19 +1224,28 @@ EXPORT_SYMBOL(compat_set_desc_from_vma);
 int __compat_vma_mmap(struct vm_area_desc *desc,
 		      struct vm_area_struct *vma)
 {
+	struct vm_area_desc orig_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&orig_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
-	if (err) {
-		if (desc->vm_file != vma->vm_file)
-			fput(desc->vm_file);
-		return err;
-	}
+	if (err)
+		goto err_put;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&orig_desc, desc);
+	if (err)
+		goto err_put;
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
 	return mmap_action_complete(vma, &desc->action, /*is_compat=*/true);
+
+err_put:
+	if (desc->vm_file != vma->vm_file)
+		fput(desc->vm_file);
+	return err;
 }
 EXPORT_SYMBOL(__compat_vma_mmap);
 
diff --git a/mm/vma.c b/mm/vma.c
index 8f8c554d5c07..cedc24dcdf3c 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2613,6 +2613,12 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	if (error) {
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
+
+		if (vma->vm_ops->close) {
+			zap_vma(vma);
+			/* Safe, because VMA zapped. */
+			vma_close(vma);
+		}
 		if (map_same_file(map))
 			fput(map->vm_file);
 
@@ -2623,16 +2629,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		return error;
 	}
 
-	/* Drivers cannot alter the address of the VMA. */
-	WARN_ON_ONCE(map->addr != vma->vm_start);
-	/*
-	 * Drivers should not permit writability when previously it was
-	 * disallowed.
-	 */
-	VM_WARN_ON_ONCE(!vma_flags_same_pair(&map->vma_flags, &vma->flags) &&
-			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
-			vma_test(vma, VMA_MAYWRITE_BIT));
-
 	map->vma_flags = vma->flags;
 
 	return 0;
@@ -2710,11 +2706,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 		vma->flags = map->vma_flags;
 	}
 
-#ifdef CONFIG_SPARC64
-	/* TODO: Fix SPARC ADI! */
-	WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
-#endif
-
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
@@ -2777,6 +2768,80 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
 	vma_set_page_prot(vma);
 }
 
+/* Check to ensure that the VMA flags of a newly mapped VMA are sane. */
+static int mmap_validate_vma_flags(const vma_flags_t *flags)
+{
+#ifdef CONFIG_SPARC64
+	const vm_flags_t legacy_flags = vma_flags_to_legacy(*flags);
+
+	/* TODO: Fix SPARC ADI! */
+	if (WARN_ON_ONCE(!arch_validate_flags(legacy_flags)))
+		return -EINVAL;
+#endif
+
+	return 0;
+}
+
+/* Check to ensure a driver hasn't done something crazy. */
+static int mmap_validate(unsigned long orig_start, unsigned long orig_end,
+			 unsigned long curr_start, unsigned long curr_end,
+			 const vma_flags_t *orig_flags,
+			 const vma_flags_t *curr_flags)
+{
+	bool was_maywrite, is_maywrite;
+
+	/* Drivers cannot alter the range of the VMA. */
+	if (WARN_ON_ONCE(orig_start != curr_start || orig_end != curr_end))
+		return -EINVAL;
+
+	was_maywrite = vma_flags_test(orig_flags, VMA_MAYWRITE_BIT);
+	is_maywrite = vma_flags_test(curr_flags, VMA_MAYWRITE_BIT);
+
+	/* A driver may not make a previously unwritable mapping writable. */
+	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
+		return -EINVAL;
+
+	return mmap_validate_vma_flags(curr_flags);
+}
+
+/**
+ * mmap_prepare_validate() - Ensure the driver hasn't violated invariants in its
+ * f_op->mmap_prepare hook.
+ * @orig_desc: The VMA descriptor prior to the mmap_prepare hook being called.
+ * @desc: The VMA descriptor after the mmap_prepare hook has been called.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+			  const struct vm_area_desc *desc)
+{
+	return mmap_validate(orig_desc->start, orig_desc->end,
+			     desc->start, desc->end,
+			     &orig_desc->vma_flags, &desc->vma_flags);
+}
+
+/**
+ * mmap_hook_validate() - Ensure the driver hasn't violated invariants in
+ * its f_op->mmap hook.
+ * @orig_start: The start of the mapping prior to the mmap hook.
+ * @orig_end: The end of the mapping prior to the mmap hook.
+ * @orig_flags: The VMA flags set for the VMA prior to the mmap hook.
+ * @vma: The VMA after the hook has been applied.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_hook_validate(unsigned long orig_start, unsigned long orig_end,
+		       const vma_flags_t *orig_flags,
+		       const struct vm_area_struct *vma)
+{
+	const unsigned long start = vma->vm_start;
+	const unsigned long end = vma->vm_end;
+	const vma_flags_t *flags = &vma->flags;
+
+	return mmap_validate(orig_start, orig_end, start, end, orig_flags,
+			     flags);
+}
+
 static int call_action_prepare(struct mmap_state *map,
 			       struct vm_area_desc *desc)
 {
@@ -2803,6 +2868,7 @@ static int call_action_prepare(struct mmap_state *map,
 static int call_mmap_prepare(struct mmap_state *map,
 		struct vm_area_desc *desc)
 {
+	const struct vm_area_desc orig_desc = *desc;
 	int err;
 
 	/* Invoke the hook. */
@@ -2822,6 +2888,11 @@ static int call_mmap_prepare(struct mmap_state *map,
 	if (err)
 		return err;
 
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&orig_desc, desc);
+	if (err)
+		return err;
+
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
 	map->vma_flags = desc->vma_flags;
@@ -3457,10 +3528,15 @@ int __vm_munmap(unsigned long start, size_t len, bool unlock)
 int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	unsigned long charged = vma_pages(vma);
+	int err;
 
 	if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
 		return -ENOMEM;
 
+	err = mmap_validate_vma_flags(&vma->flags);
+	if (err)
+		return err;
+
 	if (vma_test(vma, VMA_ACCOUNT_BIT) &&
 	     security_vm_enough_memory_mm(mm, charged))
 		return -ENOMEM;
diff --git a/mm/vma.h b/mm/vma.h
index f15faa83f3d6..89f831080bd7 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -782,14 +782,19 @@ struct vm_area_struct *vm_area_alloc(struct mm_struct *mm);
 struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig);
 void vm_area_free(struct vm_area_struct *vma);
 
-/* vma_exec.c */
 #ifdef CONFIG_MMU
+int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+			  const struct vm_area_desc *desc);
+
+int mmap_hook_validate(unsigned long orig_start, unsigned long orig_end,
+		       const vma_flags_t *orig_flags,
+		       const struct vm_area_struct *vma);
+
+/* vma_exec.c */
 int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 			  unsigned long *top_mem_p);
 int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
-#endif
 
-#ifdef CONFIG_MMU
 /*
  * Denies creating a writable executable mapping or gaining executable permissions.
  *
@@ -838,6 +843,20 @@ static inline bool map_deny_write_exec(const vma_flags_t *old,
 
 	return false;
 }
+#else
+static inline int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+					const struct vm_area_desc *desc)
+{
+	return 0;
+}
+
+static inline int mmap_hook_validate(unsigned long orig_start,
+				     unsigned long orig_end,
+				     const vma_flags_t *orig_flags,
+				     const struct vm_area_struct *vma)
+{
+	return 0;
+}
 #endif
 
 struct vm_area_struct *__install_special_mapping(struct mm_struct *mm,
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 2fd422789717..077df510a311 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1359,13 +1359,23 @@ static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 	return file->f_op->mmap_prepare(desc);
 }
 
+int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+			  const struct vm_area_desc *desc);
+
 static inline int __compat_vma_mmap(struct vm_area_desc *desc,
 		struct vm_area_struct *vma)
 {
+	struct vm_area_desc orig_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&orig_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
+	if (err)
+		return err;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&orig_desc, desc);
 	if (err)
 		return err;
 	/* Update the VMA from the descriptor. */
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index d6136e19a8af..b35279a0ec78 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -329,6 +329,10 @@ static inline void vma_close(struct vm_area_struct *vma)
 {
 }
 
+static inline void zap_vma(struct vm_area_struct *vma)
+{
+}
+
 static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
 	return 0;

-- 
2.55.0


