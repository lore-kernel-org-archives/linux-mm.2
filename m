Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC7B3C88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5EA6B009B; Mon, 14 Sep 2026 10:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88406B009D; Mon, 14 Sep 2026 10:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A288E6B009E; Mon, 14 Sep 2026 10:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9F46B009B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:59:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B81CFC0108
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:59:58 +0000 (UTC)
X-FDA: 85212677676.01.ECD941F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E07BC140005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:59:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dy5XhP6y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789397997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c7lvZWHF45BLk2nULsRrXMqDsfJN+uyHFP8jlbR2Auk=;
	b=a5reZ790lIw1fKa7KPaOsANt0vAQ/9xvu5Aukv10/HzQ27KJJtO5Al0CMPiYFiiZ/2K2JF
	i8lpQvTqIfxUGTfP0NZmKPotG9gf7cUFkbR99q2YV8M3BztR7tU3iI1lAS8lJshRMW2psY
	kuZ02BJoX9IjlSS1GxJtR8n98B5byh4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789397997;
	b=Bs6aQ3tnxI1kYP+8wQbf2sdyUZDzms1pLNxlxHLCIBRmXZv1vFWRndMcPI+DGYXDGuD+MI
	cxNKar9M23XX+Ib3sa3x31zbsXw9euumV/Tw8D+OdW+xqllkOQWQZE7Oiz8xI/5zwh0yWn
	6nXPvXYrDDxiW2DR63kTWT/MD+BZAWQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dy5XhP6y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EE76400AF;
	Mon, 14 Sep 2026 14:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0581F008A7;
	Mon, 14 Sep 2026 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397996;
	bh=c7lvZWHF45BLk2nULsRrXMqDsfJN+uyHFP8jlbR2Auk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dy5XhP6y8dXr+8ojo8Ufl96AGLd+w5X33MUvMQ1VIg330J+1vzAlSodls0yVZL6h8
	 9umBQgb3yvjSm1pEmZ8yn0oRA/LpuCfPvl6eYFLDlRid/Cd874jeGc+7u+5fj3Cbxm
	 7f7XnF9tneW7HNNtIgEbhzAn//MPgU14hyENVLl8FQ5Xfk0a6FD8p2plNzHVNOcINA
	 a36DQ3EipM9iXNSUvnkX86+FpWZ41OROfJwIPubaH69f3V9biVWy7fTE6Bu96RqQL4
	 Z528hSCG3Zm20Jel04/18h14CvzIO5VaKJ1Zv0qtOmkyR01DSWBhhJuhfmmq4V1OqX
	 ppCQ2eX8biOfw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:21 +0100
Subject: [PATCH v2 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-1-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=11359; i=ljs@kernel.org;
 h=from:subject:message-id; bh=4yp7BsZu3CgBi+wzXgbyuSQeObOnQL+E7WfwicYJ0TI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK/131rk/Zsr6+iCmwahbGrHJpVE2lmszj3xcILbV
 M2zpuwvO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRe1EM/3OOR08t3Tjpu/VV
 6+5KBwa3xLyr+RU32ma4X/5zUW7a4ckM/9Qfx1esL9nY+yOa/XHvsvU39LaLpr+47jZ5/7eGIJE
 tNxkA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E07BC140005
X-Stat-Signature: sqfbi8mkm8xqrehi1gzrm1unirfg6arc
X-HE-Tag: 1789397996-453060
X-HE-Meta: U2FsdGVkX19rNaykAulZ54VHHhdSy9qvqEbeksBNp2T5kcB7oXw0MvGnbNFK4SgN3jKXkf8TfphJnC44OsTend0VOFwoYp5BSqtMAKqwXWOW1yv27D+JbwkoXxmG7slJ9qX0exdQSXL1IHYScUhvQ2EkSTF94sM8LvskVU5nST5VA+rZr255YiBbjil2obAj0IEVZvY/lvQT26y3g39BDz25ehDDfuBwsh1pWK4VdmN9kFT7uXWIPH9Nvre48ZYbfh9fsPWFkF2CdOn+aPcOFlrhMfhyVVQUM4h6X2S3PymHWjyglte/axHdz1dwft6WGTcjwyscSR834hySRMQRPDVFTCXqpBATOwEB71Xlk1hiaWNkoFbKAUChyhWpymxBqzRXsdQK5dMtgrAVkzW/L1QO8xmKqW/4UpfWGmtGQDRLEfV6HgKW/BGeUK9Vbl9GPMxOI9w0G2ETWh+xh4zMXByBP9bVFmPySYsVJcx7QJo1L3g6AdOVCciuMOwFKOZ/LdDVI1/5HPtl6wzMHBuva01k91iTU0jcHEXzseJ49vx2rKDHl1QjcnmbBiIIcpbxzXgI4IKGq3AQWYd6nicyHXiw777CNCE6ea19Skhmwt4PDUFs8g5SM1m4eIVAEepJ1uxin66beTAl3/gKVh0NpGyXWAYIvYtsx8T+jQCfZnfKjmUDNw7V0vlYI1t4LlfnlNE+QMaTtOgNq0M5RiTX0zGtD0ZJMvQ3NJvqxrPG3b8G45kYEHY67bMCWbQIUIltdzQujSEjYG2LZvwZekmsVnBPO0zUbM1xOyrFwgtdGF0FiUMqy972ll2e0GuC69Eaxu2CI479ZCfogmPa49GGO+8j2N/cnK6qqLndOjRJ8iqVFHCHiP+ajhgBt+tvWDcsg+k6QQ/bsSGNOyg91pnHJhW9bwX1Xmgmfg8lpD9YRWIDxOk8E0GH9HFpVVBbXNz0cLfVzCV+22SiL19OUGC
 RrdinA0f
 hxLpbCYeMz+7/5shdBOxcTz9xjggwDX3r26sQCYxoLQosYZ7IU5tBd1Xf9FbQXpLx9h6iHGe0SwjNq1s1ddexu/raIRiAkE6vjE/cC1R9ueoDUiW/pK+DEB+2eDrW2KOErb2qHzrui+1pjvvoXB3KPHAnML0UGHtqNlqtwoKbMzYAdwKZdbjzPvO+4uNbxbIpDbI1Z7widt0rCaJK6nJnCKmd6GXmHAR55XqS+4BL5vqIv+JyLBPKCKY5tltxmMTo36LK0mtqPyAACqM5vrqgYbRlvaAxAN8EgHyhompUVP9l/u4qqx391P/uMSTM+BXLmOmrNQLqzJZwPEfL72a8MYmekM63V36SN7gK/Ezs2C+JxR43AefPcfAG5EX/wTbo7tdwclcqvDbyyt/252KNlcFqoYjKHSRzHY60LeZ07qxmxO2cs1NwFWfhOqrL9UYNv/wjVDp73Ny5/4m4aHxak80mk2h/CgFeA/5rjMLdCIaYJ5pUxrhJp6K0FJDI2gsS45SPBCsnV0VkHStD+iTCzoYYXFwptbn8/lXmOf1uzYPzbdsy+38WtPKGz8nxlZ+sPLrzMnMNmHkUUZjrHmqhU4qxcUMmFOe81pnUJhLmhJ4gNrsZiI+81X7N1jXuC95JqoOwb+OQg4ziQWgijb1x9DT3SGVty8X8OrzcF6j+KMM9AmzTiLrXJQ8JIthWAvNYpJcODq4sieXoLQnaQmMzDWSO9rUtC5ZWvWX61ugDb5RYVD0D5GkVXslt9Gg+LkaZokhytoP9KZFBOMr5PK+pBysu6z7ok4qEwKLX7gcCgWDbby0dEDDf/UVN+LGDCHisSnrgjdZMwbqmhDYeDRwp2fUb0YagUwbPylgYhD9ZJC9H9PbGhAvcRVhD6T8DwlKzzNndH1Bf3ptAIkyh/oR3ZvRG9Ctd+NQ8cly49VIAginD6B+1rhurwWB/sMkrYk+x45oaaRmqIuwTW4Bp+/nTRMWE/8FT
 PDwUsopa
 fmooLi2KusOZWYqQkOJ6wpFHpOOvwjxpRallFac3wLNTCAqj3ii7iXRxs+FQ3thIMfBLlLm2cpuQ2DpyjAl/F8gZHVE/Sdb965pOitYkhPZViHKUTXt6mjoI7LyQvivt6djjLai37hDqIQ3S0TtPMm33LilBM12xsMKoPaL4Va2v+loSdZDZXqSCLmW8UzIXgfzqNGjA2XLKgNHgoXaYTn535xOYy8Qmb8hF8MnH4D6N06hprrT6yDm/SJrFTLiEKP0avnWNoCaeew3kTEqOlbxwuq+F5Lyp5nlhRW/BeX0846pmERQZRs9EG0gcBZE3r7RoC7SNvhkhm4jughXMv2SkwvBbjQFp3tYP01mh5nv02uli1T5SOrEHpDKAQMf51Oe4yo07h0rYGO8ajcpdWgYIxLiffc9mm/cdvkQagP3nOeyacvvgMDOu21k5Iq5YQJT/0vncDkLp8awcuAklUY9L5LHFB4/lme6UuxdUttHvOh3m2NCuwNWgsB/OJCXNf/REnlKoZF1n783JTnrh54KadSznjwWrOj9OEJcRGu/WMVmTj9Aj5TLXFPbEPwDIDGQI9Q9CLfxIFmEdVco10MmBj8xNjMSvQWHg1CJOnGLBN86xpMbOAGc5TC4svxjGsLzc84Afi0txq1I1qwee0VELtt1WLqpSWRbzpg7//rrKmOLmx/VIB5uKOQu1dpct88pIDubKH0SyLkiQxJs5gfDKFUWjJwIZTSwpB1EjmiZYjX5cJhOmhCMW7eQ7QLTCmwEUTACpbO9D/3sAF8+vXtsaEhrpVd2dqrES1Eco261Zd6tCnAkaU8Pm/Wbp3v3XO4P/HD6Y4IuCoDLTd/lv9EKLkIHMQwgxtAbstO9QWuRA8xfiaEfDT39FDNdXkd5SWJa7eVjC6XGGeVuQDkDj7615oezgZ0QtV/1gVcJ5+Ty/j0H6/2lAIP75gBAMLHw5prdWHB526NDtgAjv47lfAGJZ6gYnt
 rCdTSMo2
 I49Y0r+dOmPwLBejLoi5TPa7vp56hBVEXmpR8tgrCK6+gXvKik62CjFDfKRh/Kgvfztg2fDfS9CRNgvOVJ1PCcIduXWElJ5GhmeToKLgZ1tXBFejx+yjeDrxzLcn7oGLZ6bsFooYZm8VsmaQeoDLx4t9NNSmDXpQvcXCPS4qZa9H2Byf03oGg16Rz/ygah6wM3jaOqe1vBDt+cVlhvfYP7SpN8mXiybxu/ATaEtmmi2RTeG5kyytZOmkRy/Y/3D21aVDgmLP6HNoJa4T+32bmFU94PSl7tgqzqCPJtd2A1I04rcGrohsLztyeYZz8RUD8BDFztzRtlCU/A88cQNd6Qil12t6yDGcVbw0yX9UF6bYuBbmZzMM1RZCvsaRR7kA/AjgLrI2QMmuPLhesWTuO7kMVonlzkCeuQ+rJx53WbKVqqKmnpaT5fWr+i38bdu2oq4InIG5Ntm2cA2E9BfZDcqgVMs5Ugq7rbttyUdOCuVeCw2CtRjkXbNqJmijffUkqsPI37ylYK5o6mMP7c+1AIewXBIlk/82amzvQSiqlmXTR7hezbwEH/sJ+6k+I8BvSydKqgku9iflu3Sn0OA9GTDbGHXLfTES3yM9LtHLN4nDl0THNZ8KjaE6rijiX27G4VhDm1rFDFsQeoCntbwvb1i4ZSGgyPwBGMepj9bswdPeVZmhORLeA4JOp/fgBla50udoKU9gEOyk+YtFGeLH/vw7WbmPe5W0iLUI0rPZnHbA3sL1DCmd5NDaLwt/BA6JzLONJM7+rjAzzzSVlfCfueioPzPEBu3xGMhYiQQF3vvfQsoPXKAgkwtXbIO4Qi13Yw8I+aQjNqI9G3Ehk3va+NrKUbSrwYQ0rBs+/cnpNbjgorGJlkgePG4UAkirIVPZaBy6fY+PbSGpJpUJHv91/bzOJ6Y4ZmVa1EDvd4HWyN8t4aDEbJ55tTQb7tUrSwxhxdBAZH9R+juo110YVXFyZA7PgR9Uf
 m+S/WP3/
 ID7GPTvWLTmYp1oAOC6xfKxYHzaKdujZj7wKQYE9csiWWW+tNxKGYG0RTBkSMuPBJiCxL0R6NqatqUQPjEhrks+jo5h41Xeb1k5k9q8lCu+avLXqp9/EJZaNQSocQ0+iCwuJM+vK+e5wh6U0sV3xV5bN2mgH5N2Wt+wge74bXhU8C+qtlXaQi0zc/vnq65vNFLVTy3JkWSpozFxV98KRJdLDFkhaTG0m8f3sMs3a9CPsXoMLm4SIAGDBTKnXXgdUoBcQk9QnpkXQ8bfL31szRfeqgoMnQzLEdyydsFlo/E6wqisqx+TEMZf5QQoov25IdqbcsaStPOBH36KUaxwZ8T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The map->file_doesnt_need_get flag is confusing and the existing
implementation has holes.

Drivers are permitted to change the owning file of a mapping. If they do
so, they are required to take a reference on that file.

The mmap() operation which ultimately invokes __mmap_region() is guaranteed
to drop the refcount for the original file the mapping was made under, but
this is not true for the replaced file.

This has been addressed so far by tracking map->file_doesnt_need_get, which
is rather poorly named and unfortunately fails to correctly track whether
or not an additional put were needed in a number of cases.

Make life easier by removing this flag, and instead drop the reference for
both mmap_prepare and the deprecated mmap callback in a new function
put_map().

Track whether this needs to be done by aligning mmap_state with
vm_area_desc and store the original file in the map->file field, keeping
the updated file in map->vm_file.

In order to have the same behaviour for both types of hooks, only drop the
reference __mmap_new_file_vma() itself took in its error path, deferring
the replaced file's reference to put_map().

To make this work correctly, map->vm_file has to be updated before any
error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
set this field first.

Also when mmap_prepare() changes the file and is then merged, the reference
count also must be decremented, so update the logic to call put_map() in
this case too.

Also update __compat_vma_mmap() to manually perform this step for stacked
file systems using the compatibility layer, and update
compat_set_vma_from_desc() to replace vma_set_file() with a correct
refcount/file update.

No in-tree driver is impacted by the incorrect implementation of this
currently (no driver that does this is mergeable for one), so this does not
need to be a fix.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h |  1 +
 mm/util.c     |  5 +++-
 mm/vma.c      | 95 ++++++++++++++++++++++++++++++++++-------------------------
 mm/vma.h      |  6 ++--
 4 files changed, 64 insertions(+), 43 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 0dca33db068f..fe576d468af4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -7,6 +7,7 @@
 #ifndef __MM_INTERNAL_H
 #define __MM_INTERNAL_H
 
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/khugepaged.h>
 #include <linux/mm.h>
diff --git a/mm/util.c b/mm/util.c
index bf0513d1d3d0..016932780925 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
 
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
-	if (err)
+	if (err) {
+		if (desc->vm_file != vma->vm_file)
+			fput(desc->vm_file);
 		return err;
+	}
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
diff --git a/mm/vma.c b/mm/vma.c
index 55917d097933..a319a9fc2f29 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -24,7 +24,8 @@ struct mmap_state {
 		vm_flags_t vm_flags;
 		vma_flags_t vma_flags;
 	};
-	struct file *file;
+	struct file *file;	/* mmap()-specified file. */
+	struct file *vm_file;	/* May be updated by mmap_prepare. */
 	pgprot_t page_prot;
 
 	/* User-defined fields, perhaps updated by .mmap_prepare(). */
@@ -43,8 +44,6 @@ struct mmap_state {
 
 	/* Determine if we can check KSM flags early in mmap() logic. */
 	bool check_ksm_early :1;
-	/* If .mmap_prepare changed the file, we don't need to pin. */
-	bool file_doesnt_need_get :1;
 };
 
 #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vma_flags_, file_) \
@@ -58,6 +57,7 @@ struct mmap_state {
 		.pglen = PHYS_PFN(len_),				\
 		.vma_flags = vma_flags_,				\
 		.file = file_,						\
+		.vm_file = file_,					\
 		.page_prot = vma_flags_to_page_prot(vma_flags_),	\
 	}
 
@@ -70,7 +70,7 @@ struct mmap_state {
 		.vma_flags = (map_)->vma_flags,				\
 		.pgoff = (map_)->pgoff,					\
 		.anon_pgoff = (map_)->anon_pgoff,			\
-		.file = (map_)->file,					\
+		.file = (map_)->vm_file,				\
 		.prev = (map_)->prev,					\
 		.middle = vma_,						\
 		.next = (vma_) ? NULL : (map_)->next,			\
@@ -2447,7 +2447,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
  */
 static bool accountable_mapping(struct mmap_state *map)
 {
-	const struct file *file = map->file;
+	const struct file *file = map->vm_file;
 
 	/*
 	 * hugetlb has its own accounting separate from the core VM
@@ -2496,7 +2496,7 @@ static void vms_abort_munmap_vmas(struct vma_munmap_struct *vms,
 
 static void update_ksm_flags(struct mmap_state *map)
 {
-	map->vma_flags = ksm_vma_flags(map->mm, map->file, map->vma_flags);
+	map->vma_flags = ksm_vma_flags(map->mm, map->vm_file, map->vma_flags);
 }
 
 static void set_desc_from_map(struct vm_area_desc *desc,
@@ -2506,7 +2506,7 @@ static void set_desc_from_map(struct vm_area_desc *desc,
 	desc->end = map->end;
 
 	desc->pgoff = map->pgoff;
-	desc->vm_file = map->file;
+	desc->vm_file = map->vm_file;
 	desc->vma_flags = map->vma_flags;
 	desc->page_prot = map->page_prot;
 }
@@ -2586,6 +2586,10 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
 	return 0;
 }
 
+static bool map_same_file(struct mmap_state *map)
+{
+	return map->vm_file == map->file;
+}
 
 static int __mmap_new_file_vma(struct mmap_state *map,
 			       struct vm_area_struct *vma)
@@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	struct vma_iterator *vmi = map->vmi;
 	int error;
 
-	vma->vm_file = map->file;
-	if (!map->file_doesnt_need_get)
-		get_file(map->file);
+	vma->vm_file = map->vm_file;
+	if (map_same_file(map))
+		get_file(map->vm_file);
 
-	if (!map->file->f_op->mmap)
+	if (!map->vm_file->f_op->mmap)
 		return 0;
 
 	error = mmap_file(vma->vm_file, vma);
+	map->vm_file = vma->vm_file;
+
 	if (error) {
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
-		fput(vma->vm_file);
-		vma->vm_file = NULL;
+		if (map_same_file(map))
+			fput(map->vm_file);
 
+		vma->vm_file = NULL;
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&unmap);
@@ -2623,7 +2630,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
 			vma_test(vma, VMA_MAYWRITE_BIT));
 
-	map->file = vma->vm_file;
 	map->vma_flags = vma->flags;
 
 	return 0;
@@ -2631,7 +2637,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 
 static void map_set_anon(struct mmap_state *map)
 {
-	map->file = NULL;
+	map->vm_file = NULL;
 	map->vm_ops = NULL;
 	map->pgoff = map->addr >> PAGE_SHIFT;
 }
@@ -2643,7 +2649,7 @@ static bool map_is_private(const struct mmap_state *map)
 
 static bool map_is_anon(const struct mmap_state *map)
 {
-	return map_is_private(map) && !map->file;
+	return map_is_private(map) && !map->vm_file;
 }
 
 /*
@@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	}
 
 	/* Invoke callbacks. */
-	if (map->file)
+	if (map->vm_file)
 		error = __mmap_new_file_vma(map, vma);
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
@@ -2797,36 +2803,34 @@ static int call_mmap_prepare(struct mmap_state *map,
 	int err;
 
 	/* Invoke the hook. */
-	err = vfs_mmap_prepare(map->file, desc);
-	if (err)
-		return err;
-
-	/* It's invalid for mmap_preprare hooks to clear vm_ops. */
-	if (!desc->vm_ops)
-		return -EINVAL;
-
-	err = call_action_prepare(map, desc);
+	err = vfs_mmap_prepare(map->vm_file, desc);
 	if (err)
 		return err;
 
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
-	if (desc->vm_file != map->file) {
-		map->file_doesnt_need_get = true;
-		map->file = desc->vm_file;
-	}
+	if (desc->vm_file != map->vm_file)
+		map->vm_file = desc->vm_file;
 	map->vma_flags = desc->vma_flags;
 	map->page_prot = desc->page_prot;
 	/* User-defined fields. */
 	map->vm_ops = desc->vm_ops;
 	map->vm_private_data = desc->private_data;
 
+	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
+	if (!desc->vm_ops)
+		return -EINVAL;
+
+	err = call_action_prepare(map, desc);
+	if (err)
+		return err;
+
 	/*
 	 * MAP_PRIVATE-/dev/zero mappings are an ancient way of getting
 	 * anonymous mappings. Rather than allowing these mappings to be odd
 	 * outliers, simply make them truly anonymous.
 	 */
-	if (map_is_private(map) && file_is_dev_zero(map->file))
+	if (map_is_private(map) && file_is_dev_zero(map->vm_file))
 		map_set_anon(map);
 
 	return 0;
@@ -2845,7 +2849,7 @@ static void set_vma_user_defined_fields(struct vm_area_struct *vma,
  */
 static bool can_set_ksm_flags_early(struct mmap_state *map)
 {
-	struct file *file = map->file;
+	struct file *file = map->vm_file;
 
 	/* Anonymous mappings have no driver which can change them. */
 	if (!file)
@@ -2868,6 +2872,20 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
 	return false;
 }
 
+static void put_map(struct mmap_state *map)
+{
+	/*
+	 * An error occurred or the VMA was merged.
+	 *
+	 * If the file was changed by the driver (which is required to increment
+	 * the replacement file's reference count), drop its reference count.
+	 *
+	 * On error, the caller always drops the original file regardless.
+	 */
+	if (map->vm_file && !map_same_file(map))
+		fput(map->vm_file);
+}
+
 static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		unsigned long len, vma_flags_t vma_flags,
 		unsigned long pgoff, struct list_head *uf)
@@ -2922,7 +2940,10 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 
 	__mmap_complete(&map, vma);
 
-	if (have_mmap_prepare && allocated_new) {
+	if (!allocated_new) {
+		/* Merged, so need to drop refcount. */
+		put_map(&map);
+	} else if (have_mmap_prepare) {
 		error = mmap_action_complete(vma, &desc.action,
 					     /*is_compat=*/false);
 		if (error)
@@ -2936,13 +2957,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	if (map.charged)
 		vm_unacct_memory(map.charged);
 abort_munmap:
-	/*
-	 * This indicates that .mmap_prepare has set a new file, differing from
-	 * desc->vm_file. But since we're aborting the operation, only the
-	 * original file will be cleaned up. Ensure we clean up both.
-	 */
-	if (map.file_doesnt_need_get)
-		fput(map.file);
+	put_map(&map);
 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
 	return error;
 }
diff --git a/mm/vma.h b/mm/vma.h
index e97bd2dfa786..f15faa83f3d6 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
 
 	/* Mutable fields. Populated with initial state. */
 	vma_set_pgoff(vma, desc->pgoff);
-	if (desc->vm_file != vma->vm_file)
-		vma_set_file(vma, desc->vm_file);
+	if (desc->vm_file != vma->vm_file) {
+		fput(vma->vm_file);
+		vma->vm_file = desc->vm_file;
+	}
 	vma->flags = desc->vma_flags;
 	vma->vm_page_prot = desc->page_prot;
 

-- 
2.55.0


