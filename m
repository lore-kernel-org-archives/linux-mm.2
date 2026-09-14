Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40CCFC88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5610B6B00A0; Mon, 14 Sep 2026 11:12:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537EF6B00A2; Mon, 14 Sep 2026 11:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401356B00A5; Mon, 14 Sep 2026 11:12:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 183376B00A0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:12:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F0CC1A0186
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:12:51 +0000 (UTC)
X-FDA: 85212710142.10.AD6F103
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id EFF8B20009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:12:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jFlaAQin;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tN13W6jwJWnvYLjX7TO8ZRd5JDwmaJZiUPNzCgrQU0E=;
	b=SNR+Od7oNtjmOX+Kp/vb0RJS2GGB0JOItigCZ2MKf8EAGPejzZUIIxEXsd0ZffBq0/dnw7
	uOlIGR1wHCQ2g0mvO96dIgB4INveduoMrFr23Apvhp2QvM4UVq8/XvVatdGkkb7ONnxRl+
	/isideTFKIUOPUefBWNx2wT0ZpOCSUE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398769;
	b=qQFkU2ys9daO9nH8e9cepAaeXFTZmySM5FFfd/jcdgKQizeKixVKQVCw4lOouuk2Kwn+g5
	0Ouq1HVym10/jbAzaZsmSn1Volj/mhhhsL2381GDk9qgH/RdilfKz2YO+GVP0fVFO/eajQ
	8VwV6/uqv29UfSDwhwhYAp+ARoNeu2Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jFlaAQin;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A9D4601FB;
	Mon, 14 Sep 2026 15:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048671F00893;
	Mon, 14 Sep 2026 15:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398769;
	bh=tN13W6jwJWnvYLjX7TO8ZRd5JDwmaJZiUPNzCgrQU0E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jFlaAQin+oAtoOa1M4DSIw9dAIP1iSZp2pLTn+auqN0GfEe/JXNztKg+WFdsuRXfI
	 OUTf1CRcPeeG0tlNXiyIn+ZRVBA3x7SlMgG8LtvwO5vUMvTfQI4bBiWBDGu07spVOD
	 e7GAN02gmQHUG23bXpH6nR0nzNnP0g/RoYb84GuB3Jk5EPN4xZtGjiUrTZfUrFDUqJ
	 kkuAbhmPIfk9VWrrttWwXpUM5QybzXe5cyFv2kPQ2BVvWg772oGhx4ttklCTr0HF87
	 27T/S546CBgS/61ZqCKpm/cYHyWDlc8cN/7UD4xGKx1IrSSIaGX5F/ymgfh5m8Vujg
	 l+3f9hpvKA0dw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:49 +0100
Subject: [PATCH v2 29/40] mm: drop some redundant checks around hugetlb
 VMAs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-29-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2730; i=ljs@kernel.org;
 h=from:subject:message-id; bh=2GAQjO/s/Bk0fyt5AOQ4Ez3Tt7coS55V2FI+CqksX6E=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG8y9Upv+BalpReh8y7L8R+HfP1fb9OdlmuZmH81p
 en+ufO0o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABNZWcTI8ML48+2lyXeydx9e
 6+7IyxZnVHwvST++88aidzfFfmhPX8nI0CY7MX4J7wnG2+f2mn++Ze5/7dKk/PiaX+uq/rOVF1h
 OYgQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EFF8B20009
X-Stat-Signature: gjwmhuexkn97xjx835qyygkksyqzeb1a
X-HE-Tag: 1789398769-766323
X-HE-Meta: U2FsdGVkX18bD2pY31KvQrOGBnylPWqFO6y9UopsbPIEkfLWwAEm6BLRJL2WezWkKUEeqtCKSemqF9jDn/TsSW2b43ROioAfAXL5tG/VOoDQ2X1R6/sBr1oe6ckp2XNJ6Zx7ssHuK2x1w6vGkbfH8alkXnLHmYTldkTwlWl/BSo3XaQcYVHVPgU08cIm/pMgy24QNKbzQHWhh8Xu2SCRlcYvvD1U3H88+BEKrbVex+XgVFNKQkyd+KajvogqG4z9v9T4Qy60P5ycTqJNHE2q6aOhztkofOyssEigMMgY353edhv280te/6IvCDuQsARgzhU+4rYa4Lu6l7b6ERTEN1WhChHsvlKpEpk81TVtwT6saYrHL6tk7Z2t5f3SpzDvRm6FdGXsopX8jGs5Uo9dv6unME1Tp6cWfYa9OiRaL/7ZOqWISh5uvPN7hLQ922KELWqX43HO5J22dJJANhSB9PNB0W7nQipTwgUV6C3UpaO/A+iOD34KYeJdzxLcs8+lW6/SiGLviTOhK7SEQelZWF7stPGqOmm76fRKfvD5WJj9GxLNdL1M7Izr0zkPmXJmMbxPVl2wIjo1V1E8Hh+hmIOKhrPnDdfFkClCEPOnND2Mw5zsib6T19dzyDXDN5YxGx4X761YJJfjrYf734Md8snUpv97vZ0OKKGZWdq34X+RP5eJc0JhOs41LjL86+7vcB7KM4Mwb+Av5ksrqApeY5uRmMw8JB3Ap1GxQZXkHP4Q8SX7QrMayb+AAkQGn67OSIYxgFNz2j08zv916I/2CGQQiG8SrXw3jgtX7Z6bGZypx6gFp6r3lifDgIVXXxe9mhTGY87awXHyvNEjY9U60dK+N5haG5S7FoIJDHlaAaXMkQFZKwdlEvC19OhRNGcW2BS6RBh9eTcJxqclbG7qjxEOMgYvmQ1OgIhpR8ZhONr+Bg2Sq0/sZJafRIowLe13l4o5vycF+L64GQ4QDQq
 L6NUmGaM
 rnqGROkLUWTxWT1ThqT8FRZPY4IimpX2F9zAIThXCqpP+Fqv3/2Pv2Crb8xBo+n0yQLaAMfJDROnAHuVIGsHnkRybgyWV4CegWnHC+nPvHWEKWE8sQ3ijy8up+RnrNXRp2jLAz7o4+z1tomH3T5NqYXaWKCAuSLpbzVVJfWsthLf+6g0Y4q+/3yKJoxf9fUkvnU8+jVvjtd+pnEFJbSIGy48wsYiNvUDI6DoPg4LcizrJvGv3pEh7eQWDbID7CltUPbyVlHYN986iasD12MpZmtq7BA+F9W/9ue5dslRg5XZvM5zk4SVDWQCRDFzajC07fDI5Vmc2CD83qr+HULlimxfqkjE7enJ8QVzo/4aaz5IEin1+ZlM7LadHeArbklQCcYwBp08iG5/KNmJIt3iQAhKLo0OKSF/5hLQXCq5gw32zX10jiLElHNSgjMzrI6P3tMGROq+4uE0nz67AXaLwi7W+9oyFmWXZmcITWBRLxjK2fLUbhx57E7ylT9dGhHmoezNcDAlk5x/dxHQ7hnjTrjldnobn0ZSmTVXZpXNsmdmWsW6lkZI9npaQzAFTYiqK3JqfLoq/kx/kSczmVI0cdblnQOtR9rx9VPSGZH0J+QfzUHVxHUTC0X1nFAXaR89VuEDNciV1YC7QuRuRq3DfaMUBX2mD+m3R8mitwOKYe+2p11GhhdrK+dUxirYzNEP7V74MjId9vcE/jG9388/qamGC51EoIl5a7uY7tqByfDXiKZn6+2s13dAvsGpWwT5IbVPZx2HfYEHWb6XQ30dYvwDvi2MN9aKzH2sqLROCfXoErKYJvmowjRs6fNPDToTVTc3lCIXP3gnFSNZTFOHlrljedlowNlN+FuzxPD245OgJACaNd+vWlZ4bQ/jaoHp2CzDHJzHyeeYgktlxIL48sSe20h9l8xoMRiUG3DeRL9pLkrNsThmYqLsTZ7qAdXf3bcCe3KQISuXDPUYRNYbaau3Q+EMd
 ZDRcqmVU
 Ke0PdgEM/YcqmpTBg+BW39YU6sU+rWVNmouD0ESHv9F8TL782I/2uSSAUkpYPp1r/ngM5GnFnSfHs5wpatw1IwFek4dC6GtWccYdo5HcT8eDvPcz2zXxMVR1hAq+y26S5xfn/hN+2Lv+CwEUtZVixeOKT2Dl+uLD8bfEzU8tvqSvcTdE9DTy4vUCu8uUoBxrNmF6Gjx/H9k+yU8qD9H0ao6z6hIEwcTGMz57+qwklmfouHt48xp5YoDukEV8IGl4c+H4BADxYrHgwlMzKywI6dGsuzGLCwgKL7rLUqRAh2P0LiSB4ykM2SEeC3IOOmKbDAKXPdq/464EMVBTjGVXQPMldwTfqLv+ZjH6JBd6jNO/9UX+W8/NjVTzqAcTRICffcVEahJ716kJA54I9SdwZ/QJGnRR2zC56SCWls5FAFjQWZjvBOohEW8g1DQRxc/PZlwokdbFDrjjqcOF6oN0wkrK0C3elIfOgsvA/vTFBbG+6ZXsn3uT1hiuhq4ebsicPANX8ShHi1G6/sx8ji8t/O0/D6wH3C9i+n27VwnTLn+tEgml4ENkR1PumMYh6DouDJPqUBzBwJq0iGLDx0cR6O9Tt/vqC2yxTYftdOGvozCUWOnbz2fYh5IrVrWH88jMKtlLWNWl4BGMyoh1dOYfTINolmgRMm9d5PGhHBFK/Z9UDpYLqTphnHJ/tJ0AqWNdjzNiJB3WGIONTGng16b6vhWh8MFd2l3q1kWXAKAB5oU6A167yq4PnjHBXOprW0IMJiTxlNtABm8FPolL98Xa6EkTCw0gxBM2icpXYDypMvDYMjGk5cXjkLcsMa2lyMsQw7VovHCqaXlouLNs1lxychE26khnAd131O+W141yrm2YcT0Cn+jXLchVkIJKX8gxUFQNIKta9/slsp6/gq6AAZ64MXGJyBBPgsZQ6jWxHsUzV4RffRE+jvYALxH92ENKL55lxj7gmWeMqer1zeJUo1HUto3cy
 0weMfQiB
 mVczeNnj6M9uLsNIPxC33/f2TiQ3OAI5W6bIu9Q5ocIZCHgpPAeana9Zx2QrSTrkyd+vtBqpraAoIlVqJ4b1dnH1rzy9Tcv4Shzko4noHJ50JL8SqkElVcAgWVceSFov/mz//MpghJW30vRWlOQktlO5fLyS4h3BZDqd5oIw2pRzzkYNBp6B4phGG3ZiCqVfhVgmxWgKDCn/7UIii6OyLi1OGod3vAIVZUyvWOqtbDIHfZacubYIGp10bNaB6vrc6xVIHF9EC7XzmSY/XCSeYp4eKw2/8I83XyLs3QYh9g4xtJA/paB+LkFr4gWXEfn1cfKdKXMH8szIesBPZ5L89T2LsEGT/hAa5RDXT6J3szD9gUNbum1voWmVwR9bR1ktFPzIR/L/TNIuM4hfT4o7GcODS9d8/ky6SpIc4vjzVtwhVx33AzXUuKrUKqZNwsNgajDd+JJh+ES7pCmWO/q9juc6IBdCW84AKjDr3SukD4di0+VP/GwLTbYlfrLqjElox9lAhx+AGTSsdfpHaFDAxl8XuF4qNBaWNi3KG0Be3DkJ1vRx1XYKbc7AF3zN42KrFJVBkuP1TkLzoU4mwu+hYiHfMIlFdcpHWKopfCgixHjtiulO6xIinBqCumrsZx4Nv7nq+I5dSBQpZoFdD/J9nrWynhECCE/f3ZSG+lUSlM6ybFxPoQ5JjFMatqNth/omla8hEPgn48esePm5q1Qpm9ku5xJEVxrquu0gVSUqo9aqJWPNFm3iLCXili9KcYc6HMC4C0Aj8Z7jlqQ9nfrqfvMjWbciAY7KojbbUCs2Yp3aPFc20BuZKucKgEWI2Lqdh9veuZ+eUM4eIjX7HQ3PXs5QvPDYQdGC2FgQdUtIFotBu1UptloqEurHTobdANXgcl8DzQbVs3aLL9ZKZ0LXgdCthABAFzWfb1JisXmZ9CWb9T46XJYrRL769JLrmfwaQrorUo5JJaI0toVze3rnh3NFHblLW
 7aSzbGjf
 GFbcUWZzdwtraeEgF6lufHEit8enbrQashI50YfJqkcCDlbB8Lrd5xssd05OZgFw/dOcaYZ0KkIYTATsI/yMnHxL4lwdOIGM25bJsVLeDMCs67DzxZlK8w+DFNfJ4Pr0yyuJBnFqhDvFBTwqqhXvqCyKUJiosAErghGb2FEW3BXiuCcV5aUnLvL0gl7ewBpYIrZAeTNSFmwm+++McImDnLJYiqGoDdsWiqzZrnha+0BR4+B7PQ/aLu9I0KPlbM637EA5hEby6xOVFN4+Mt1U2hgzSJTt3YpWClx1yC2AfQOzYhKD8huq/+VWbGoRNIpJt/WJ81/tctobQA7z+Ug0AS+XbF/5vKFhYiz7kOJy4/uZ94fMO4059uRWLfK31waPq3ksMsnAYMoAGNo0Dv/CSO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adjust code which inadvertently perform redundant checks on hugetlb VMAs
and clean them up:

* hugetlb VMAs have VMA_DONTEXPAND_BIT set so a VMA_SPECIAL_FLAGS check
  suffices. (migrate_vma_setup() regains an explicit hugetlb test later in
  the series, once VMA_SPECIAL_FLAGS is removed.)

* hugetlb VMAs unconditionally set vma->vm_ops, so they are never
  anonymous.

* hugetlb VMAs do not set VMA_PFNMAP_BIT so checking for this is redundant.

While we're here also drop a VM_BUG_ON() which the simplified check above
makes unreachable, and use the new VMA flag API.

No functional change intended.

Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/kvm/mmu.c         | 4 +---
 drivers/gpu/drm/drm_gpusvm.c | 3 +--
 mm/migrate_device.c          | 4 ++--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a7968f8d24bf..3c1240ffc38d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1463,14 +1463,12 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
 {
 	unsigned long pa;
 
-	if (vma_is_hugetlb(vma) && !(vma->vm_flags & VM_PFNMAP))
+	if (vma_is_hugetlb(vma))
 		return huge_page_shift(hstate_vma(vma));
 
 	if (!(vma->vm_flags & VM_PFNMAP))
 		return PAGE_SHIFT;
 
-	VM_BUG_ON(vma_is_hugetlb(vma));
-
 	pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
 
 #ifndef __PAGETABLE_PMD_FOLDED
diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index a1d4989b0b61..fab34fea99c2 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -1141,8 +1141,7 @@ drm_gpusvm_range_find_or_insert(struct drm_gpusvm *gpusvm,
 	 * limitations. If/when migrate_vma_* add more support, this logic will
 	 * have to change.
 	 */
-	migrate_devmem = ctx->devmem_possible &&
-		vma_is_anonymous(vas) && !vma_is_hugetlb(vas);
+	migrate_devmem = ctx->devmem_possible && vma_is_anonymous(vas);
 
 	chunk_size = drm_gpusvm_range_chunk_size(gpusvm, notifier, vas,
 						 fault_addr, gpuva_start,
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index c38cbaaef5a4..b9c453c28795 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -743,8 +743,8 @@ int migrate_vma_setup(struct migrate_vma *args)
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || vma_is_hugetlb(args->vma) ||
-	    (args->vma->vm_flags & VM_SPECIAL) || vma_is_dax(args->vma))
+	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
+	    vma_is_dax(args->vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;

-- 
2.55.0


