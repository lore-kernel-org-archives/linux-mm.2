Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2188BCA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158AE6B0092; Sat,  3 Oct 2026 12:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1091B6B0093; Sat,  3 Oct 2026 12:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12E06B00C8; Sat,  3 Oct 2026 12:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D363F6B0092
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:44:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 727EF809A9
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:44:08 +0000 (UTC)
X-FDA: 85281887376.05.C1A6956
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9CDED100003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:44:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ErauwjOA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045846;
	b=VZf/mKuHqkhTIBEUECzoEPT6Lg1Y7C7YVnQkho6SAKyZPQe/k6ndT9Vhv0bXYk/RL4NWHA
	xd7QeH3MPS4D9TbMjiK39e1mUJ3snqWoXVwTUhwkM7hIytdW6tbv7posFHdaLKP4E4Vtnc
	fFoF4Q9gxjQEp5YS7dG7qRBTQYbYX3k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ErauwjOA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XF0JJsfuKvhm2G8uGXZbY0Fvh9Ki1oyQ756jSTtjCVM=;
	b=PogGKSoSDrN22vrAIlmieL6YPHJ1XDax/7oQ6R/eG3HBERnMos5NcYiyMmE5gvVrCVOrBT
	LNfEV0nm4RxxgppcrkG9KbesDJcaNg58+EtB3nYAAFs5eSIPm3dHsQ3amwaGOfpg5rqTIv
	eu3Y194XcwhOBOV3SeznQ4vw23g7QNs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D263244512;
	Sat,  3 Oct 2026 16:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54001F0089B;
	Sat,  3 Oct 2026 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045845;
	bh=XF0JJsfuKvhm2G8uGXZbY0Fvh9Ki1oyQ756jSTtjCVM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ErauwjOAUPolvDPo+KOX91wtYfG50101aKLuZHTzOCeknM34/M0SgY8v2k9Y2zvWR
	 akN7/IOLf1EcEd+/y7akr3b8opr7t6O3MyIDyp/NoxOh9nlPy6nq/NADaWub4TGrL8
	 3OVb4dv+Be8YaL3zubnHfMzXJKM5lo771xj8cqwImZUYFUhzs9Tsh1FZyuiTwHyXFz
	 zb9sB1DalepekMHuCByL7geo1HhQQCG/stNnscqta9lcnby9+uRzgo1yAUT+6MjxYW
	 sQVHRH7CvDaRa5ZAhOtcyX+cvRod0sjdpJQVZRZ8zwq6p2xM2Fu6Fk+13XI5BtSb5W
	 H25O1KTqdbBOw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:33:02 +0100
Subject: [PATCH v4 31/38] mm/uffd: use predicates for userfaultfd checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-31-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2291; i=ljs@kernel.org;
 h=from:subject:message-id; bh=hWvFAcFtWeMeGKyFkbOpdZHf6iGKkjlhr26+pQ1dsRw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mnLxP9M/tPQtTV1v2BF0KTQ8Four80WWm8Ovzrof
 Pwo+5u/HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhIUyXDX6na67/zei0NT092
 dVzYa16QdFlh5rRHK5e2N6ZLFrxwO8PIcPqkR9ayxUranSsjo2VfXD3NZnnA/toWWV09qfMmx33
 XsAMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: bd5dxwwyqtsu7xizowpatnyzkepsy4sn
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CDED100003
X-HE-Tag: 1791045846-904551
X-HE-Meta: U2FsdGVkX1+7/6M9drnL+O78IDGQIy/5hHiCSD5D/pWWmII+mlnftwajut9n1oCBKt7qNj5r9qwOWhELqEN2ZDb++N0pxSwXc/iARpKchB54ta9nI3YK7W0Ow1gvEG3bnHmvVRqT/wHEoekTfe14QL5jASE0txmLq9tj9Hq2GT4YjLtsDvJFHCyZQCBJSdBkKs2ugbIDTwfA/Wsk90FK1M19xSCbHKh2qKHwam+4egL7/WD/PT7b/uLTQNzgSdJcOy8X5uOA0v7TC8fnEvnwIhMhM3ZAgYD24plmkg/hvicxygQ7PfUbEl6X+I86Rxhro0THoMY/ZAGCwAKjLBXkg0MGPEZFir7a+yjP42GYSmfPSxAGC7ZVZRca02iYx9JVK1KAC6CgjFII4uYGDSb5G4jDJLY8YKt0zG7HIdSzsEBAHgPzcISBuxUTQhylqyvmVXNX0c5EZ/Vh4Js68So4H9CRWFDdcNR+szE1gd05jf0dL+GR7klk4jpMbsL/sTMJkxhoV4VfgGY52oTBdW4XioUaybz+pKcqONTEygbCk4Fsvmka2r0wIA4PpY+WHD5SOBd7ukGzLBtTfSiyMebmyeDBeVkBAJxB2fJIYJPCO4sWbGyWAeTvwf2U4CYkA+r9w7z1YjcCGI5zjjWxnLBErkoTkooIJqL5K2HQVjv6clPAg+vH3tTOzCDNVqnT/jHG3lcpdz6vsy8wNxbejIvQXn2Xn+8bwLl+i95v+ajNjOCXok8PZX0AQLaFCkMAoWhG5Vdd1wzgrkjj3pmwujCUajM0Qzdxod6ZBbW0Lpi1kPGEONFsolMqlfSW8wpBvVUKWGc/BAc44yGeO5DS12FkILjyK+ZACYogkxfahizI1mZnazlhsuFSAKkFmBXfyi8oBwshmDbGPPwVxrrQIHE3I/6yzB1hooxxTMzyA663FOiNq/+qTaSl/lPpvPgRNNwSkvWUcybzuWXCpVyGNSA
 viK7e6Gq
 NSkuvQj3XNWIo24aiMN+HiPTL2LbQVHvkL4iPKTYv0AUr3biv5zVEWU85SLJ1mTiNrJqDfetbZigLjg/e8KMgFq8EiQzmCF1yGdDM2iaCCidZGCJNDfzcKQFH4kwrKZhrROKknfW31/xzcA9uxMLGRQZcRPU43TsTuwbqf51p6TanyAtOFYSqwIn4Sa603kpAYGfiAzB61zRtLW6UXXpK+PWk8ByMCq/q5npdbuZyQIrb0uFrPVeoX8KAdf4Zrg3BJqRtKSyXkddKQn3NPcMcTWWMPIjHxhj+k0kjkaQysOCNEbjDgNnsHPTsR87fUZeZESEsATLXrHl07e9xomkwj3lz5+LcEWlkPSbwz20wdO2CQFiGPWZz6S83u1riA2F/jKTAbTcFdwvhzAK6xcHBSpWT1tEn2EyYldLwoEVOXX7fCe1LPz8nvfwndsavgN5iweTcBTkdyKn18XVoT1kXZMdkM7eJs+FTxHQvVHRx7kfjpaH+BoiY9Arl24f2DMeVxbIV+Fpq9I8MYaBpUyGkeWZf2QHlTEDXy40fA/laZsnkkwX4V0gN/S5sUh0+nN7h++s7WWvwR3/7HfkosTQu0otrC7Y1OnU1nJANlx0xAh/fV4tsNfCPtDUqDkwFogMuqnqy4ucCL61Ess8JGVGwoNtmBi5nwuzC+Jr3vjB01z4HASshe//8R2p8bupGW2K8GKqZ7nA6ofhgB7uHa/pgfsIzl1Wg/E9cstXMPOu3KQEwpHdos/bwdrQWLOf0VTCqEb7vzvEcjBhwUPEKBL6/xu3Fz3kzTqMXSwPpmnvFX/rTzRsyP6rYJvFwEKk/1OAJvRqZlW4p5gphSV+lh5v0mRgkOSzTRo8EN+LLXpeTKPmt04jTosa2ECs9Gm/k3914T+GySa8sOBwvkpN5ulft5UsdWSP+0hggAxA5B/ZvjX6la5zIVuI7ERi+1CxwasDR+17xsbmdHQkCO2EW9TRFwS6b92bm
 GkUvsl9C
 O+HQj/lHNMpYVbO0PK1V7FMYsQI4fH+IrELj4c0HG8f2DGyQLNM1GgsXHTEnxbxHBky52ILaeX5ZFh8wJVrprEJ0DdQ5ZyNiqGydG68nKgAvA8Lvz8IZ42RsQdpafGDRQBQ3VtvRmSXOgLFTZ+nJsF4iOfJQIg7pEvGGO3urbez6VXhjMSCdLJ/Lyz1ahwuZNd7C6wE+YWSRdEwjoVEbF1yUrQcTq2xXBWUBuYxLgUsLIMkKmkRlzh9ZSrH22KO+6LrguasQ/qtyKro4ddo/oLALMabW0LbBkcrdhkVIsbvHeKrW2wOsfS28CfGvmw4Fy0g6iUyrIvWSf1rmQjRoUqJdWVue7m08dlwsuu1dEU+6MsHY7zKLqUMaK8BSbv6OZ2+HDOZS4FqXzIbNKExnyosp6AlPgc7jNruudoECT7Ybfn77fGKPqdAZqMRirafhC1eHvV6PFsWVDfcOFchYTcGTWpq8tnA4az3dM5Y47ag0wI36oqp7iCwdIKNQD55wd95deaVkx50cbJMcphUd7TnfgpVD/7mng46pn4WCQGX/FMMun34kyMs51cxVsSSMGP0rc1nBtG3bUZjwG2wjA8S8K5YsktQTsNGclexNzJQC+UGm3p1zwMuX1H6AWU68KuWc1klNMumI45C25SMblLcRWaPkznGQ78+QONrWptj5TsGRH3Lr1M04G07PJrqPRzToGd3KGG4QNfwT5ZwjW0S680HUaAGeQ6xFcEGE0vuvN6CbxQYpVdvAMHkgmEZCQlitWcoKg6ZAj9fg/xJymuoNuI9zNw87xwSM5Iwbt6CkjGM46bvt07EWhaaEcJ46ue9W78RQWwUiQyrfxuTSHkvJuX+tfgI00c1PEHJE0Ga1YbNXHYpjKhHsMWE99tCcwX3DVOqRT8mktjahyXc3DGus+HtzHRJQhZ2XEtxLSxUdfvCzLzgYFRVM35tdjqZjB9DDoyN6JH6/roD7oqLi/OtV7zpog
 Mpmu6w8N
 t/ES+tWEhG3FVSIxRwCJ05k6v8tQDwoFKIyaCSJIymoGSUwx589W7UxYm80lNXyvNHPN1F/dqe0+xOICv8XX4iua/ibONWLgWf++s+6SN4ybLH6s+i4t8aFIPij5jHWPs+zqK73QrwhxYEwMe0CG8j4WynsG/OxnxkhTfgN9mZmcxUf/jygZIN9pGWHuawOKTAoLpFime/z8RpqU4wH4/UTp3PcPIanrH36zKU2ZOtJskQ2ujsD0W1kMprMUbCLabXxH5bwC6k1xHpnqo2q6dUVx3EtMpot8gt0JSJjBgFvs85pB/vAYF67zuN0A/Nz8DxnkB3Qe/19nl9rQIlbUxLh1VDzGAzwu9yoqgGBhkiOO518hJDJDIwlKydvwgu2lRUL0mhAgNeWxM2nkionlmc4Xge8cxqzdYOAQBKYL/IRhgCT9I4r7K0BBwBFVGStmUIcaNkIQSAgps6f7qjNk6WHDHpMSpML0E7S7isKLTnA/vXEl33xRw+ACnJWMvXF1nJf/jlNCQk3rhk3MWQCHF9XAI9qLtLcP/CKY72BEnQdjzTZYw4t2zupikDldVYSDcH6lRcjUlb5ZkrU+oy0wfesG6JFlYKqJzgp/uTe0WrScy5YLjiwX992QQE1zSY2H3ayP7Wqsux9FOr5oke5vqU5201vk95GKmmhELEvp8r2wxzGsH2ldYCHgp4w07/cLwN5nlvGh3W3XdHv0vaUmSXyknY5E8fnkX09+9r0Yk4RMJV7BcmeI5PFvqLCnQlqio24BAFGVKausHoJQjmlU2413ThIUmWC82+mBSpe70CR9qmDOVa2r0yOh9CZbxIVygaUWdAiGSY9l0lQKosz1K+u1PHKy/WI2HtVfuy1fvXwFAP6P57E7wzIoaZxYYyCOi4k0pKpiy0af5eQn+ywCB8yHF95zq+LzAOmDfx5FSxU9m+mkGxsUbVvdjAnMQCM6ukHm0ASo8EunJfqkwanI/k0OnrjuD
 x8tAVFX2
 1g1UNAyjSYowhwK7+c2ZraNuypvUBY9vWwnZghIFtaeFfIREotzrKm3ijnkrs3F9fGw8pBADmw/hXQ54nUH/Jth70KFCWyP05vkjeVeYV1zSqFdjtA0LeO2x89I2jm6odchmOW+ZCJto8XcImKtZMqcfjsdmI4C59cYhB9sueODSDMP4gHxhn3i5laAWIm6AgyL02AMViZj5mQYvKKy82XGHc3BYkJqZ7H4BudrvO2yOX6fxGBPVS0OoOQgEyB9hZm2KeuRKbu8wmoFGyk4HH65EAZhMTara9OEFjzNmBErAMPEgILochI99kUlL4+dBU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than directly checking VMA flags, use the newly introduced
vma_is_mm_managed() and vma_is_mm_backed() helpers in userfaultfd
when assessing VMA suitability for userfaultfd and UFFDIO_MOVE.

Update vma_move_compatible() so it's expressed in terms of VMA
characteristics rather than arbitrary flags.

Additionally, update the use of the deprecated VMA flag API when checking
VMA_SHADOW_STACK_BIT.

A VMA_IO_BIT check is no longer required but that is fine as a hard
invariant has been established that mm-managed mappings may not set
VMA_IO_BIT so the check is now redundant.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/userfaultfd.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 949017e60608..f33b04700838 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1754,10 +1754,16 @@ static inline bool move_splits_huge_pmd(unsigned long dst_addr,
 }
 #endif
 
-static inline bool vma_move_compatible(struct vm_area_struct *vma)
+static inline bool vma_move_compatible(const struct vm_area_struct *vma)
 {
-	return !(vma->vm_flags & (VM_PFNMAP | VM_IO |  VM_HUGETLB |
-				  VM_MIXEDMAP | VM_SHADOW_STACK));
+	/* uffd is generally incompatible with mappings not managed by core mm. */
+	if (!vma_is_mm_managed(vma))
+		return false;
+	/* The shadow stack should not be written to by userspace. */
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
+		return false;
+	/* hugetlb mappings cannot be safely moved. */
+	return !vma_is_hugetlb(vma);
 }
 
 static int validate_move_areas(struct userfaultfd_ctx *ctx,
@@ -2146,10 +2152,11 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
+	/* Only mm-backed memory can have its faults handled by userspace. */
+	if (!vma_is_mm_backed(vma))
 		return false;
-
-	if (!vma_is_hugetlb(vma) && (vma->vm_flags & VM_SPECIAL))
+	/* The shadow stack should not be written to by userspace. */
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
 		return false;
 
 	vm_flags &= __VM_UFFD_FLAGS;

-- 
2.55.0


