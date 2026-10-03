Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F118CA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95EF86B00A1; Sat,  3 Oct 2026 12:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9104E6B00A2; Sat,  3 Oct 2026 12:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D7C76B00A3; Sat,  3 Oct 2026 12:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7DE6B00A1
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:35:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C8C5C140966
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:35:37 +0000 (UTC)
X-FDA: 85281865914.30.BC553C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 12D0D40002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:35:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MXw8Q1r0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RtWJ7MLLqPj5SMfThVr/gbBPp+ziYLloZpdj8FNlsJY=;
	b=BHScVngKTUQ+QiJNsOOGdcwxPShPy1OrkH3LuP+ICWDGJVFC1Fb7PWw6hRNGjKTtfey5Xt
	preAZF6zUzv/DUMfiDrH8y0H4jEneLvTMtfvpXkN8hXBcbIUyffGOTyNZPz8+BPqN+cFGd
	v8y2zX5cGT//AbMfi3BfFCML++2MfFY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MXw8Q1r0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045336;
	b=lNvbTKTotylmAwG6aPSTk/KOEUgZBRNdUJ4Xwzg35CSftSH+PuJ/YfFEMcoVpVahgYwS9f
	yRGDsf8g7Htb7EAuq4vQxj2u6x3XgI4r9FcfCBxvbHjqC8z1eeA0mrz2zojctSN0oIce3V
	W6f5gXa57CUL63HXVYyzErzJmT7M4Z8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8885260D9B;
	Sat,  3 Oct 2026 16:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BC91F0089C;
	Sat,  3 Oct 2026 16:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045335;
	bh=RtWJ7MLLqPj5SMfThVr/gbBPp+ziYLloZpdj8FNlsJY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MXw8Q1r0Gc6aRzhsCbwa0DVi/CdOmmpK11fPM7GHG1+Ibrk6H5jmV1uYSSr2HbZRY
	 wMHBz56e8uJeddzNwCvB3RFXtUIVX6Fme2ZGpMs8dxuMqd6eyps5NCu//CaZvVf/A+
	 tmGeyr/8NRU2dK0VJqKqcr8Xt+8XAKX3CqqU4eq3dk0TO9VwfEIVwiZ8zUxMQfe1FF
	 r0DLc0B/vuqXPPPgruJbiYmC5gmMXTJud3b55EYKUnG+ierawq8IwxoueP5VzK2C0I
	 58jotqWzVaeGTETTmcSjJicc2js5BKrauSREyLq03fTnlIoTLTHPQed2A9FsD3gNr/
	 k4tiZr8xnSHug==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:38 +0100
Subject: [PATCH v4 07/38] mm: add mmap action for discontiguous kernel page
 mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-7-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=14245; i=ljs@kernel.org;
 h=from:subject:message-id; bh=7LT6HbKZwAFKTYTHhkPflMyUauVOza0ipQouGgRYEaM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6qnPW+iSuKNLWUGs956FUI1ndKtopZvovcOqDtu/B
 s/Qd7HsKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwETmPGX4zcq96S9HhNWKeUmT
 G2fP2rjaNnhT2QnGU4/i5jq//Xv7cgPD/xKdOrdXO+5+nbJJrPtzYOHiA51mXbf9Hs/JjVs/2dJ
 xGwMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: sqn15sbqfbucj76kfxkdin1mck3qugjf
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 12D0D40002
X-HE-Tag: 1791045335-959212
X-HE-Meta: U2FsdGVkX18T7mw3ZsJpHnC/XLr114HKL9LNKbHq6ia3X5od/IG9qwQpTunSQcTqdCpC3+7q4Upii7Ac6YGD1a3hUbkXrhOXBIvGCp3xHNkl535pw66s+GpcGfro2k3Oy0gn744tZBMi9i8wChq//Y20vHkITgJOern9EqZ0/na9w46KCcQUvUPBRxBJEC7FqAOv15/al+HWPFVKKn/ahuAgxnwP4x6+KNd2pi9n8vD9tUog4/CfW4vhhTlFQHAiIHHtGrAcFqbsubaksMRPfyLY+DQM7pdXhXKfFy6qSQ3ck9ffue9LMrnYEN2Jqx/nFGzNWYCoDhMgXHjk8x7FLLpRxODUtfefxACIiQZlW1wSMPbPu6N2BKvAdOV+EB8P2LpiUPW/eU2+NRBZLPsHcu9a5Qae0HpsT7GlsHYSy/7u1mB8+vmSLwvtsstZe6Wk7ZAY79u8GaDk0phrLBt7iU/Ts4rhffpXmsxp5IET5javhOp9pH0FjDm3RBStwfzXOnic9XX63t1hg2v15rQS4xzYCQaLSs+9UGl/0kYkAnbh8+XcqP5wzXv3+ynztQ7+eezE8CvtU6twB8sjU3D0XtDOCllqsRXSLfV0yCsyAkGyMGOzqal8Pm/lieNeTz6oXAOsfIt/lhmK2v6vYn9kGK+VHs0NdtGJps3M8YukS200m2To2NJzSqPpo0HAdy0aLwl1vyaQinr44z2I2xcz6HM9nfF7iVINIjK5j4uMb68AxjHkE2cVi+7pZgIoRpcKU6Ft6jiR+4rEZMx2EqRlEsLs4SYg+TbM5/EDlB4i8nCrErpXZR4eDPfChxo9PlRlJgHlDeRj6ZWGrNejwF3mjm+GSTJZbzkXvAHyppVAwvp3LLvh3/ngvFm8FXxCH8vgtPDlpoh4Z5RqKILNxfb5EINn541HdDDCU9B5V1jdakVAawaZjZhsaTN8XxwSZcEIfrDlCWZdwQU+/DRpaY+
 r7z642PA
 7pWVMBFQZ4S0wofPhE6ItCC1EbNlo1t9upB0pYWkBI+FKdfiuD1P9aUBvKBH/5MNa4D40eFOMgRQT+6H/DCRITH+Bs/63EpRGEKWoOkXO0NQPxfcESByRT64ykLgVozJ/xqFpC8/+soxwJYQku8uujX4mH2kq1LfPTvZbB6kRyQQwHtScNSZnaTK0C9nTRql32ETsHfeu2EDWM1E11yLFd0Yp/QHRKuIf2QBfEov3HGqMs2Nrfz8AkXwYqJk3ACY555RNqUzmkV7hG+HD+uu/u7HFx/1HHirfoumdaXg/dCncwcXGPzqOdEAmguXAjPMO641dOLhvP37S4m4PyIHwPz1ayo35ABepd8C0Ypp1QRwjg2Unna5spXNFkW7vVnURPRCeDsY7AI91esR/q/6cn/m8IRHThtU0ZoV0fpDjMjLdgkIoh4Lluc+9IvPDOBTqF9FmoQuBf7VSzoHfoUY/BLvLtDTp1h+16kFRpJ7BKnS4OtrzzNnj+6dcjs826uGgtpS+IqohQwvIPL6DP3R5sx9IpOiQoKsDjT2m8MsIeMLFFD46jrfr/fOJq8Nsk5juqy1WZ3SKRjQM2kN2D4jK1+WV+QfP+k4OmLrJEBDfCsAKFA0/VsF4PbxQaGRkSHftsjjbQe04rnWK0TUNagmx3RFK6BNCAH7eimm+oyKiy9XMNOmqzKsMzAeM3XVQp8AFYGVD6/aLePyn+Hg822fXJ4MInYMrfg6eqw2a9MvW2G8LKuuHe3eeMDFVkhQXr2e0Yj3SDXVXw5/VtXI9LFU13d1EqU3jqgjmjkqjDXCOdY2h5d8cziACfDvzcMnyc8vQAFx70LEkraZE5F7tzg0ETVgAHqtHSSpBytGCEMAZh1ibWDtp2FBMGI6Bxm+L7yHyqJT7qK8hLtY4JAigo0AZDvz4dL1Q1dX9icqiNuyNal+141b4kscdam+lxS7mieC4GG5BQwtIwjPsSX8HEgJX7CttZPIs
 ZMB60Vxz
 1aoJPnOl1MRLhLqjQ08bcR20tVaGZUcuYHE4Cf3W8yCdclJkJBmX1U1fWgahRMkgspxbsy2e7Dewg/A14Yimrk7XU9BW8PCJpP6OvKwKdmG/X/tFuCLpUBTbi79Ljidxqg2DsNlyBD/AlKv9daGXaAv1iU4HmjK9XNFZlSzV0IZIzMJgPliIbqhpl8hNVHIg+WE15KNZXxgzasSLUOthkFhUmAwQOzCJG4TVAAGi0h9XN1tytk/Qw3Tt7gr8pDyppzxv+LFvcn+/Gm8FpnFmq6IoPNh4jVQCqJrLi55lAYF1Axw3oU0sqDt4F0py9AOTT0A59DRVjdlXIziyYze+uBE66a8RfMUkE5o6wJD3ooGIefl4um3amJZ0tgmXkwWeRyjahtq/uUuWolxCkiw02V304RxYl91KfdTwCkjiFkvfrBzJaFf9SEoV1tj1ToeU4UyEUSU12L1M128qMOH+FxagKOEUC1w9/9jcFvER8N2VbUbhbOINxs3Nl/FwO67eqafWvpAmIqa5VKHFc+G4e87PhI+iHopWSwtK+I+0A/hkpojwO2UqgxOmeZgRQiny0RBGJpPgn0KhxTD8HEddQSibJCCZzW2kjgHv1hCNKB4i17X3tBMI4Wft3r80gz9G0aaaShH5hlz0wBCiDPW1yLb4Xfvs8GZom/39Y91ivPhUp59/vB7OI5BN5NWmDnk1lYeG6UaNaXVx9YE2B1Xv/9b3/C8sJb2x2n8NLLdq+C6jnzGZKlL+cYQkH+QD/OnhSJItZip0AUJU9NOdLipMJG5o0JxF9zS+GyH+Zv7eJ/1mXL/s1nan22jyQaf2tLzHHyOb3GpKYVziLXjm1pMQMfq6TFUJGRKqYEt0lIjfY+zkBrMpWsW4WsPyW1tlyIOPpLbNQtWp//c4o0PfSEKX9wULjRmdSR1Dmfq+o3tc12QZwatQTAlmaHpjYvo0Tc1W0fv+RZDQ2ZOud2TFYAWi1SmUBtbZv
 4FTOO7KI
 M7BEYRF7PogRjI6qCqWOxoD2qObNFXeybEYJ9PzWk0uCrLVy4fs/n67CXwJXbv3h3Sq0BpOmtWDscbKheVrCueYUh+joGSYA75r/tMo0vDq5HEoWPYE0gcHSYkDuBi2mxbOeIMreUdYpqPjr3ZKzeSNTWn7IX5nUJPfwJsb3OpMAJpC8yvxpadkxyxUjImrPCGpvhN5NUpQUbVvBp40MJuI9Uzjq+3vqIkE0H2QHtQRq4ocL8GjtWp180c/72GYelz8Lm0TF+F2MKltV7bPe2c67GEzH9JDZKgiTyLrTejZFE5rX68m8aFYtdnWh6eba4D3W+VQXRu0zI6AMW4pr/5wMlgXtajkOEtn8P4pYW4z9AjhEJP6w/Xp/wdopec9h6jqnJH3mpBKjVG5DXkSF0esZ02nZGEfMW+9/nMYJZKGlcto4NHHsnP6msN4igSZ3XANcvCWs652N1YcVbq4LARDNuCEtUqFV1+BC85lmQsSuOO8KCyUAF1Ih6Wda+0eXnsCDQlAiIR1jPXE6nVzYeSvOOguGFaXDqyweJkzP4poBK7U5IF9IxWCmh9FgWUopMcffWpbmD/v/14iIBsSbVdfJBj/10eFvjyXFvIHeL/tHiWI3zJ740wYPi6X5skY3R7tHbJyvdBLVurDOuzFflLoS+8ND1IqOCz+w/f0Eh7p9L7l47yT/wCDGdk+A9LCb5oPHgqHF+k+mUihHiTL1/fglO3NFLx/uEpfjYxtOxM6lyi4D71M9eqyQqQWbBW/HtKES6AdOZq8PAB4SoNzOoQ20FKjoOX9VlU8TXheu+fyuHCi0/UHRznvP+hn490cISjdhy6YsvNqz30C7h8ENREiIluKK2YN0xpQvnsnRjtBgI4Ee232fEZu9ENfKwPFSaFLXNajRYDl1/sc97zS+dRiyUkEF6Yf9IcdsbXswNAzyHt4z+rqic4kCXBslsbyxEnsmNdjbOom0wrZlR59lcvMB6D23V
 pLxxlUoo
 OljL0UywIMtc64yfzQ8wlE+6aklaH+OZ4e5tiRJNaWScCbsRQXLXWFXh+MNe6CfanC1Loe/pPKoQ0xq38Xj5NWxC/ajCV2yAWh8Q8hTjr8QSnInSEa4k1rK09alPd514uEqk0CEq1VGqQY6di45fWeLYP8NuZrFDV066OAcPgTpsQdfft9QteUXIGyYlOXL7bHq/DixeVaArO9ewb7wU1TSk9BrDMe76aZQ/GxefkNWfuDniVQ2i6GMZ2Rh/KI5ohyYf2eugn9h6Au5qpa5HMBgQghixWPHnqAo+dYCIxrg7rPk9d0Q6G9sbSlsGmpLDE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing kernel page mapping mmap actions allow for partial and full
mapping of an array of struct page pointers.

However some drivers require the mapping of discontiguous ranges. Permit
this by providing discontig_kernel_page_ops which allows a driver to
specify how the operation should begin and how batches of pages should be
retrieved.

It uses the minimum exposed interface to do so, providing address, page
offset and both vm_private_data state and a local private state object.

ops->init can establish state for the operation, and ops->get outputs the
pages to map and their count. Should an error arise the core unmaps the
VMA, invoking vm_ops->close, which is therefore where any state established
by ops->init is released.

Also update the compatibility layer to do this too via
compat_mmap_action_abort().

Batches may not exceed the VMA, but may map less than its full range in
case the driver wishes to allow the user to map an area larger than the
available data.

To use it, users invoke mmap_action_map_discontig_kernel_pages() with
initial local private state and a set of operations.

Users can then use one of the provided helper functions to perform an
action:

* discontig_kernel_map_abort() - Abort and leave the mapping as it has
  been accumulated so far.
* discontig_kernel_map_page() - Map a single page, or a compound page given
  its head page.
* discontig_kernel_map_page_range() - Maps a struct page ** array of a
  specified count, mapping only those pages which fit in the VMA.

The userland VMA tests are updated accordingly.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  45 +++++++++++++++++
 include/linux/mm_types.h        |  44 +++++++++++++++-
 mm/internal.h                   |   3 ++
 mm/memory.c                     | 108 ++++++++++++++++++++++++++++++++++++++--
 mm/util.c                       |  27 ++++++++--
 tools/testing/vma/include/dup.h |  11 +++-
 6 files changed, 224 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a1f2d375cf7d..97e1eb4fe3a4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4647,10 +4647,55 @@ static inline void mmap_action_map_kernel_pages_full(struct vm_area_desc *desc,
 				     vma_desc_pages(desc));
 }
 
+static inline
+void mmap_action_map_discontig_kernel_pages(struct vm_area_desc *desc,
+		void *init_private, const struct discontig_kernel_page_ops *ops)
+{
+	struct mmap_action *action = &desc->action;
+
+	action->type = MMAP_DISCONTIG_KERNEL_PAGES;
+	action->map_kernel_discontig.init_private = init_private;
+	action->map_kernel_discontig.ops = ops;
+}
+
 int mmap_action_prepare(struct vm_area_desc *desc);
 int mmap_action_complete(struct vm_area_struct *vma,
 			 struct mmap_action *action, bool is_compat);
 
+static inline void
+discontig_kernel_map_abort(struct discontig_kernel_page_state *state)
+{
+	state->action = DISCONTIG_KERNEL_PAGE_ABORT;
+}
+
+static inline void
+discontig_kernel_map_page(struct discontig_kernel_page_state *state,
+			  struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	if (folio_test_large(folio)) {
+		VM_WARN_ON_ONCE(page != folio_page(folio, 0));
+		state->action = DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE;
+		state->__folio = folio;
+		state->__nr_pages = min(state->nr_pages_remain,
+					folio_nr_pages(folio));
+	} else {
+		state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE;
+		state->__page = page;
+		state->__nr_pages = 1;
+	}
+}
+
+static inline void
+discontig_kernel_map_page_range(struct discontig_kernel_page_state *state,
+				struct page **page_arr, unsigned long nr_pages)
+{
+	state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE;
+	state->__page_arr = page_arr;
+	state->__nr_pages = min(nr_pages, state->nr_pages_remain);
+}
+
 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
 static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
 				unsigned long vm_start, unsigned long vm_end)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 9ca2ea3664bc..0cb4f9603956 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -818,8 +818,44 @@ enum mmap_action_type {
 	MMAP_NOTHING,
 	MMAP_REMAP_PFN,
 	MMAP_IO_REMAP_PFN,
-	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
+	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
+	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
+};
+
+enum discontig_kernel_page_action {
+	DISCONTIG_KERNEL_PAGE_ABORT,
+	DISCONTIG_KERNEL_PAGE_MAP_PAGE,
+	DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE,
+	DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE,
+};
+
+struct discontig_kernel_page_state {
+	/* Map state. */
+	const unsigned long start;	/* Start address of VMA. */
+	const unsigned long end;	/* End address of VMA. */
+	unsigned long addr;		/* The current address to be mapped. */
+	pgoff_t pgoff;			/* The current pgoff to be mapped. */
+	unsigned long nr_pages_mapped;	/* The number of pages mapped. */
+	unsigned long nr_pages_remain;	/* The number of pages remaining. */
+
+	/* User-defined state. */
+	void *vm_private_data;		/* VMA private data. */
+	void *private;			/* Mapping private data. */
+
+	/* Users should not touch these, use discontig_kernel_map_*() helpers. */
+	enum discontig_kernel_page_action action;
+	union {
+		struct page *__page;
+		struct folio *__folio;
+		struct page **__page_arr;
+	};
+	unsigned long __nr_pages;
+};
+
+struct discontig_kernel_page_ops {
+	int (*init)(void *vm_private_data, void **private);
+	int (*get)(struct discontig_kernel_page_state *state);
 };
 
 /*
@@ -844,6 +880,10 @@ struct mmap_action {
 			unsigned long nr_pages;
 			pgoff_t pgoff;
 		} map_kernel;
+		struct {
+			void *init_private;
+			const struct discontig_kernel_page_ops *ops;
+		} map_kernel_discontig;
 	};
 	enum mmap_action_type type;
 
diff --git a/mm/internal.h b/mm/internal.h
index fc4e249e2343..557e629db8c5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1515,6 +1515,9 @@ int simple_ioremap_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_complete(struct vm_area_struct *vma,
 			      struct mmap_action *action);
+int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
+					struct mmap_action *action);
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 448342883e9d..45b21bb04a18 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2609,17 +2609,23 @@ int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_pages);
 
+static void __map_kernel_pages_prepare(struct vm_area_desc *desc)
+{
+	if (vma_desc_test(desc, VMA_MIXEDMAP_BIT))
+		return;
+
+	VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
+	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
+	vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
+}
+
 int map_kernel_pages_prepare(struct vm_area_desc *desc)
 {
 	const struct mmap_action *action = &desc->action;
 	const unsigned long addr = action->map_kernel.start;
 	unsigned long nr_pages, end;
 
-	if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
-		VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
-		VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
-		vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
-	}
+	__map_kernel_pages_prepare(desc);
 
 	nr_pages = action->map_kernel.nr_pages;
 	end = addr + PAGE_SIZE * nr_pages;
@@ -2640,6 +2646,98 @@ int map_kernel_pages_complete(struct vm_area_struct *vma,
 			    &nr_pages, vma->vm_page_prot);
 }
 
+int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc)
+{
+	const struct mmap_action *action = &desc->action;
+	const struct discontig_kernel_page_ops *ops =
+		action->map_kernel_discontig.ops;
+
+	/* At minimum need to be able to get pages. */
+	if (WARN_ON_ONCE(!ops || !ops->get))
+		return -EINVAL;
+
+	__map_kernel_pages_prepare(desc);
+	return 0;
+}
+
+static int apply_discontig_action(struct vm_area_struct *vma,
+				  struct discontig_kernel_page_state *state)
+{
+	unsigned long nr_pages = state->__nr_pages;
+	unsigned long addr = state->addr;
+	unsigned long i;
+
+	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE)
+		return insert_page(vma, addr, state->__page,
+				   vma->vm_page_prot, /*mkwrite=*/false);
+	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE)
+		return insert_pages(vma, addr, state->__page_arr,
+				    &nr_pages, vma->vm_page_prot);
+
+	/* Compound folio - have to iterate through each page. */
+	for (i = 0; i < nr_pages; i++, addr += PAGE_SIZE) {
+		struct page *page = folio_page(state->__folio, i);
+		int err;
+
+		err = insert_page(vma, addr, page, vma->vm_page_prot,
+				  /*mkwrite=*/false);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
+					struct mmap_action *action)
+{
+	const struct discontig_kernel_page_ops *ops =
+		action->map_kernel_discontig.ops;
+	struct discontig_kernel_page_state state = {
+		.start = vma->vm_start,
+		.end = vma->vm_end,
+		.addr = vma->vm_start,
+		.pgoff = vma->vm_pgoff,
+		.nr_pages_mapped = 0,
+		.nr_pages_remain = vma_pages(vma),
+		.vm_private_data = vma->vm_private_data,
+		.private = action->map_kernel_discontig.init_private,
+	};
+	int err = 0;
+
+	if (ops->init)
+		err = ops->init(vma->vm_private_data, &state.private);
+	if (err)
+		return err;
+
+	do {
+		unsigned long end, pgoff_end;
+		unsigned long nr_pages;
+
+		/* Default to abort. */
+		state.action = DISCONTIG_KERNEL_PAGE_ABORT;
+		err = ops->get(&state);
+		if (err || state.action == DISCONTIG_KERNEL_PAGE_ABORT)
+			return err;
+		nr_pages = state.__nr_pages;
+
+		if (!nr_pages || nr_pages > state.nr_pages_remain)
+			return -EINVAL;
+		end = state.addr + PAGE_SIZE * nr_pages;
+		pgoff_end = state.pgoff + nr_pages;
+
+		err = apply_discontig_action(vma, &state);
+		if (err)
+			return err;
+
+		state.addr = end;
+		state.pgoff = pgoff_end;
+		state.nr_pages_mapped += nr_pages;
+		state.nr_pages_remain -= nr_pages;
+	} while (state.addr < vma->vm_end);
+
+	return 0;
+}
+
 /**
  * vm_insert_page - insert single page into user vma
  * @vma: user vma to map to
diff --git a/mm/util.c b/mm/util.c
index 1660910e2a22..5b2e1ab4aeba 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1401,6 +1401,15 @@ static int call_vma_mapped(struct vm_area_struct *vma)
 	return 0;
 }
 
+/* An mmap action failed under the compatibility layer - unmap and close. */
+static void compat_mmap_action_abort(struct vm_area_struct *vma)
+{
+#ifdef CONFIG_MMU
+	zap_vma_range(vma, vma->vm_start, vma_pages(vma) << PAGE_SHIFT);
+#endif
+	vma_close(vma);
+}
+
 static int mmap_action_finish(struct vm_area_struct *vma,
 			      struct mmap_action *action, int err,
 			      bool is_compat)
@@ -1412,12 +1421,13 @@ static int mmap_action_finish(struct vm_area_struct *vma,
 
 	/* do_munmap() might take rmap lock, so release if held. */
 	maybe_rmap_unlock_action(vma, action);
-	/*
-	 * If this is invoked from the compatibility layer, post-mmap() hook
-	 * logic will handle cleanup for us.
-	 */
-	if (!err || is_compat)
+	if (!err)
+		return 0;
+
+	if (is_compat) {
+		compat_mmap_action_abort(vma);
 		return err;
+	}
 
 	/*
 	 * If an error occurs, unmap the VMA altogether and return an error. We
@@ -1469,6 +1479,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return simple_ioremap_prepare(desc);
 	case MMAP_KERNEL_PAGES:
 		return map_kernel_pages_prepare(desc);
+	case MMAP_DISCONTIG_KERNEL_PAGES:
+		return map_discontig_kernel_pages_prepare(desc);
 	}
 
 	WARN_ON_ONCE(1);
@@ -1501,6 +1513,9 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
+	case MMAP_DISCONTIG_KERNEL_PAGES:
+		err = map_discontig_kernel_pages_complete(vma, action);
+		break;
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 		/* Should have been delegated. */
@@ -1522,6 +1537,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
+	case MMAP_DISCONTIG_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1543,6 +1559,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
+	case MMAP_DISCONTIG_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 023ad6092e9c..a6a8e53c4b38 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -457,14 +457,17 @@ enum mmap_action_type {
 	MMAP_NOTHING,
 	MMAP_REMAP_PFN,
 	MMAP_IO_REMAP_PFN,
-	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
+	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
+	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
 };
 
 /*
  * Describes an action an mmap_prepare hook can instruct to be taken to complete
  * the mapping of a VMA. Specified in vm_area_desc.
  */
+struct discontig_kernel_page_ops;
+
 struct mmap_action {
 	union {
 		struct {
@@ -483,6 +486,10 @@ struct mmap_action {
 			unsigned long nr_pages;
 			pgoff_t pgoff;
 		} map_kernel;
+		struct {
+			void *init_private;
+			const struct discontig_kernel_page_ops *ops;
+		} map_kernel_discontig;
 	};
 	enum mmap_action_type type;
 

-- 
2.55.0


