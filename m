Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF082C88E77
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010C46B00DF; Mon, 14 Sep 2026 11:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C036B00E1; Mon, 14 Sep 2026 11:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC016B00DF; Mon, 14 Sep 2026 11:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9AA46B00DF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:17:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48D4BA3EB2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:17:27 +0000 (UTC)
X-FDA: 85212721734.12.EE544A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7BEF11C0008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:17:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SIR9Irdu;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789399045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Dab/JGj5h11GJwmfZC2qp9KBu5kIrwqs5kjA45qPyk=;
	b=POoccFp7LijjjwxTqWsoupa9FxzwQ7b1QmL+r5Rb+nzzNGtHZ/Qeksh3K7+MFIgNpT7IMo
	x2FC0Owis1ap+Ey0gJi3/sTDLOQHLm7+dW0iyo3K2iKkNozDy/NHH3yDBNQKPe4tPA+T1R
	c/3Kj4P8y8faUY9rIGy7n0uwjtFCbrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789399045;
	b=CS+oCHH6iDSbMxSfdncMBvcE+6VOf7/EyjCks97IrlXKm3AF9eDD1mzPNuydCuG8xNVwVh
	1RTHMThIpC4N9yhGinLtPGOVpGpiV74OzN0F85yCW54WqWBQQdHBhZfO0UyF5j62YdeOce
	AOyTjFhzEgoWjxNb0XnB+L/vBxCRGsk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SIR9Irdu;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 025966022A;
	Mon, 14 Sep 2026 15:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F5E1F000FF;
	Mon, 14 Sep 2026 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789399044;
	bh=6Dab/JGj5h11GJwmfZC2qp9KBu5kIrwqs5kjA45qPyk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SIR9Irdu2tH++m8RUJNAXIfX+y8cmzgqfzuBuGYIWQ0TzWyN+PpkRuaqE0hD09dhF
	 2QNm1/6o41Yn0gT/+OJ/G0G10aIqVWyVhxWFxnESR91OAgPBfJSp6X3jQ7AhyfvZw2
	 aANJyVHI+fLtTSE+zbrvEsmtwtt2vWhQ8mQF7qfVVojm9/PnPA51LirOmYqlA/LXw9
	 gsivzmLLbdBw8fcXEqLaipbQn0NewPXP22oNYV3bA5Uu13IEplEK6undFCh/jMoQEm
	 UPPgZEhMW3qJ5F+UxegK48iw8tKvfiQ7NyqbyOAVu4dinN9eAsavTj74KxsWAMGvAD
	 Frh2zf0qRwyxw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:59 +0100
Subject: [PATCH v2 39/40] mm/huge_memory: remove vma_is_special_huge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-39-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2897; i=ljs@kernel.org;
 h=from:subject:message-id; bh=2A3Cmsn/41H3VCQe0yUXH8gcl1gq+lw+YTsrD11Z3Vo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG8pqA6t57l77nT667708LSrs/7p7JtqH1V+ftP+x
 9u6P0362FHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJxLIyMjzLiwnO2JiibquU
 tXX2vHL94uNckZPv+09nSznze+XCE/MYGc7uO6d5U6LIwjDY0e3SXsmNr7OSo/jCDM8FxlzeoHn
 Pix8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: f3k1ojreid1o6nrqtxtkrkm4pfpwowoh
X-Rspamd-Queue-Id: 7BEF11C0008
X-HE-Tag: 1789399045-675891
X-HE-Meta: U2FsdGVkX1/YOm7xY9raHe+ds9u4FgCy0W8Hyydfvll2l9Ii9N60c/Mi/9oEW9kzJYUZ9fHehciWMV8zXZco2bKcy9XG2Ci/B1ugr7wWC0zNk3UY7dn0EpZ8HJ5lD630b2cS2/pOU+ulw8DaAiMgT0Y4VQ7a7rY0oklttz9QUxVxFIlFBY2wcC5qfYaFS/IA+lvdmjEZ/Nf6HznjrqNFgjApG92NQshav2085/UkUurD8cWIonUFVSfzADxqvDiFrZDY3fRs9JbFzpEnRlQJaWjxCP5YGWSL2QIuKyrBolV+HCVUSl77zLYeKK2WIIRLmoakAKUOUeyJXOKVlHomj2vgsgCF0kcNxAInLZsxsqbFBbCLI6jlt+PP8ic0XCXWZBGi4CQheG3tXSeRaoYFPRA458rHOeZHQIGQMzzxGoVDQbMWfBLgmX2Kt5Ei3QEDntZLBsgf806JV5kks9WmQyQJ3tvbRmGC2mOS6E/ZLruKaa8BeOso3Jlpwxk5lOsqIXj95eaf7A26TcXVlFqkHUFHRao1jXQZ3fjgUSuLZTNGqdBQMwelLW6VAVWITjNqdkRD1uSzp1drvUVO0W4JbOQiwAcLHJmRCQ07MuoNxpjTkN05G1JVyQfh6dQrD6Ze2x9MReZ+hzU83MqleqFThMGbLgHZDlMT+VHhc0vkl417ud1sbm9qrg8h0Y6cJRI1VTFCOM4qRkkVudS7JBj73IhzbLnYQqhSQGvG98u6L4PYXJNulRAUlQwjxbOq/XhRD4PzuqoCHhuMDv8DGKKPHpTPY2cWuXt76LXwU+xQxFfD+bNz6O9L10jqLaOLtfcrm1Vdjnd3KHUYolDNKojwGhCDkWK2saoAyBM0TzylObfG1LhCRfnz5qb5a/W7/OHsYAu1OcqeCxie6NUOm29SZodfL/VA+SLiny55+5jnOj0D4HuyAHN9eU0gylqK7qvA2wyHgAndPMD++CZ6J9Y
 kiTWtEk2
 bpO4B97RNRlwZT7YaorLHig5zEAr+V83ygpA2hKu7/07e5C8jbJSDQgKw1tFsUAfgm/yiI5H+qiiMz2yLcNk0FmHhq6zdsLArFiwPT98arWw3F34XClyKlup39t/H8ECWsuiMyZVtb9bIOMVlEi0KXisPeUbmwsmmDx40O3Uu+CNhtJu2EOBbDoiNuW5JQ2583xODt/NzuY6J40f+Ew/b7FpdP6CAK9RMzwtuHKATxoMkllr8KLALuH25sDKFDILW95dZfQ5UtXp4XvTMxw/JRfvF11DLolu6MoCvCpnzoKRgpkELnrYzmWCNvZ1c3O7cyK1mT9CB15ujdFCXt3vqz6UKzDwKRxc3Lu9zqiwr5VH6jbqyFLiYsWqm/gMaByMne/K1Y442g8bpKWgzaFu6MeAIx3jDL0hbKnFztDpvB8LSUDQGyqrqP/qhSsvzrtp6/GsD3JtUxFGae0N9AnSn5BzqG0ImZHvWl1PksnTHmidWzwa06WBG4aj8sP7w95PjO8y21w2nUdipE/dz7S4xNV1KmtOekaNQxq1Sgwtx1t4wiBvADgZEwFeCg7YzxjPu8Ti6eQOJWeKuq0Zs/R5roxQJHho5YD1ozeEcnEUVi4bdVGFafs/rLFwh6xPYBQDI47dTiAyZ1AFtJM01Ui7XJOfjXSumAPovW0imcIeBeK0Ft0N9jSmAGaaohBiA38zM2k8V/rd/eDn3ayXqby9lX72Mgu2a65Wod4WtFm6yedNADlcfK4Wy7mtDrd1cgI2VV0d+czI/pxDP/Up1Si3JA+xmCznP5AT3k+Uej/thoggjQU/30Nu7qvLySzHmulWaZdNsQFkDqAbU44DZNcuJrv8jODursCc3bPuByWdbrCJ0PBvVuPY3TF2FqgTsfJB4elIo8GoxMXqPi5dsTMtKoaHWyT7ZTdF0qkxQMOWq1jz3pGPrVO2DGvgMRjI8sWwkaBKQUoWmlrdPTt/WFw/WhJUANNfj
 S4mj1a3F
 3UW/+jh0yfBwfam5YJRiSxRA7cfqjr7bUWopjg1o9VPrBSd28xeUVNOQbLO0th8T0Lrwe4s4+S+pnuBxNVMGF5p2NE7uHdsWJ26XI3CfASLvHc/i7XPVO7LN6SI30OYFeB9pnk17eD1Xh8jNj0ff2Gti287a0/ek5HV02iDGJ5AnemKc0yf9WS2umLSEgqdQgU6MO8iPrKLoLUTBihp9dt0yLwBgUJEnQavrHJSpXk0qBD0kTGp/rNU/ZdWu1kWNU/xEnBetqsLfsiCgITfrMjRi9znYFfPRtIUpMtAA60oc33UUHXeZQdsXMmpDakZXimDJwsdmCuBwAtFboH4PRhgiu3pFe2YGjVx6f/iE0Awr7S1VTIzCBhLIoNr0bTJd/YRdBymE1EVk8bKG6CCcyUCFd0qe7a7HlKGxPyklXk0j1060OzaWvLb2dekTiImgjtKfzgOGhJ/KWzptZn/vJkEC3fOWn8V0QEomXnJOL3x9/c4lndSxKQoLgpHICep8JDyuXZg7I3g3CmNoxlH2Mxgi7cbx8FjCMi0J1e3eNw7cw3Q5mHoQ/mL1cRJUNCwwVv1awtZMNSYP9xmCjE6KNATOZ9KvIJi2dFW9F4nnAa6MPFHONhNw5VRyK+MnrjLrGejKDG4ywwYOsqQBF8m0SBcxiefneU0yrS0p72Vrkzh3JtfyU4kaP+sP/ofdhz36GyfiuFADj8cGbTe+/rLhjW2yAF8FPnBSWgG/5OCwGRm3dWibDYa+5hZRHvRnFscF3n1pxyNbV+5R3JOd1PAgT4+dZG7KiYD5NwBb1XyKXqk7LCUidmCCQtlXc+4tZO9JaDC4JVsmMwZoDMXLYaQKUPIMackLxOwQWmdrt3IZdqZTkd7xPv76bnLDinwn5eJRxLrE2FIrSMsl30GGZBBI8CN0SRhQjd5flxkjPv3qXKXXC+cd0Nwmaf93M3mgnvcpcacJ8KqevRu1MPzyz3Pt5YRAS6eOn
 UfAEmbqO
 55jde1jL3Mvdw5QqxyZ+2SJ4AN4+0dE5d3zp1rLGmzK9feo90qv+Zpm5xySlP39ZWZBEkrKLMUxbfAjh97whvQk16JEG3Uk7f6Ygp+IlePInzeIHtj3CCFKeXeTdY538HlvvIGZ1fW/o7tqkK0kgDyef3yUNfqCKmbXaVqz1KSG5Yvg8o6nDjHJJ8dY+puv5aAvyQHid7qNfFK9i1njfPeuMsMUwX3oN38ReSp/OhhEGtfRTyN8O7fhkfqDH2qmtlHKQQHWjjTc6AoJnAoA/b0VKWahmxFxSkNlqYuTr2lRfyykPcz6J8QjLa/sSUHl+E3HEJMHFz9ks3sHNx4dXkqR8OUmDdmMqb4VsWj7aDLQ13tfNhG4KlU8tqnea5sCfKlHC1YKwxIRFYzJyFz09qM1DZjSz6vFVJFB9vkgUoXYovGfY2VC5r0f0o0caXeT0Zly7tjpkRMg99/IXO9J7noaU3QVYSC6gxxihjtU98lPpjkTfsVU+zF6muOMGOASpghcsiZkoy899YSNpR4ow3IxieBEYsLRD227Xd/9AgC4KGMElDlhCe+p5bour0FY+4kOPdtM01ej73rBLAwObLtmjMnyf9x2gdVAQBiaTWXGAq6qdgqs2usQnvzgHn4Cg+Ba0kjGemwBI3vTN4OrQ6WNgBrBgYWl3v478xmxwKHL6i6gTcQscKb6ip/ffoAl+ni1OzjVZRx5Kvb71rK+zhH67kmzVeo6uHpea8Ee5Ud1l0Xn9fpBTGhFr6qi3RRUoVsfuxXDgpfX12cqmVQ9LtovRADnbo7zRfz5GqKUPFDQDJk14bHNVGY/nLsqjwHpXYx09q2bNfuakvnFfOPjNBhyB/d9VdmSV/X6f1o4s3qzZnGMpVGuceJ3cfE5+lT00aO+hsp5XAviCm3qZeETS/fKr/bzYS26NK7tqX3r798N/OjAbisgBV+xzkaRLKqPgGC4ySsii0Ylm3StaKK10CloqzB/53
 LQWPJGcP
 VeDNRRIwKxECMgcgX/UjzUkENLJ3vsUakHs4xRpaP+Y95WzuXuc8TF8HPLBKpnMCnjS2LzT826XUGdq7IsZOHZPw3P9IOYj3mLRSjnzRpLPyf9WffWF4+JCgSGLJHlMj2IV8UP4DnfhlaSCAUVvCPVfQOdmvmnp7IigePdubPdoc18qMSD24/VCIcNEJ6eJSVpPs7Wv2RXJme3FT6vJAagczB1sn9q7xqyepyzBIscTcdVK59u6nuEa7wHtP9FGssu4uHJ5XwSSwOwSLSGEdtDIG833+p3tULiOJA1/2xgS5eqGo0KAcwp8fmncpXKpVMXHdpLgoSdvastXKwZ9BpWPhnb0G4lE0z+Qb7Zajl/w8FHOUbCLknIWahb9k91vjHvBMcIBLHWpFXoZz7xvyV828wz+feOIbde1FbGND9CuuKBeza52SJNb6hZEKym53jQoOkKdEfqTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is a kernel-owned mapping),
but with a DAX carve-out.

DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no longer
required.

Therefore test for vma_is_kernel_owned() instead and also drop the
VMA_IO_BIT check, as it is now redundant since it is enforced that only
kernel-owned mappings can set this flag.

This also eliminates another overloaded use of 'special' within mm.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c3c98ea672c3..3cb8e2d4d65c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -110,14 +110,6 @@ static inline bool file_thp_enabled(const struct vm_area_struct *vma)
 	return S_ISREG(inode->i_mode);
 }
 
-/* If returns true, we are unable to access the VMA's folios. */
-static bool vma_is_special_huge(const struct vm_area_struct *vma)
-{
-	if (vma_is_dax(vma))
-		return false;
-	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
-}
-
 static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
 		enum tva_type type)
 {
@@ -192,7 +184,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	/* Check the intersection of requested and supported orders. */
 	if (vma_is_anonymous(vma))
 		supported_orders = THP_ORDERS_ALL_ANON;
-	else if (vma_is_dax(vma) || vma_is_special_huge(vma))
+	else if (vma_is_dax(vma) || vma_is_kernel_owned(vma))
 		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
@@ -3066,7 +3058,7 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
-	if (vma_is_special_huge(vma)) {
+	if (vma_is_kernel_owned(vma)) {
 		spin_unlock(ptl);
 		/* No zero page support yet */
 	} else {
@@ -3222,7 +3214,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
-		if (vma_is_special_huge(vma))
+		if (vma_is_kernel_owned(vma))
 			return;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
@@ -4765,9 +4757,7 @@ static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct *vma)
 {
 	if (vma_is_dax(vma))
 		return true;
-	if (vma_is_special_huge(vma))
-		return true;
-	if (vma_test(vma, VMA_IO_BIT))
+	if (vma_is_kernel_owned(vma))
 		return true;
 	if (vma_is_hugetlb(vma))
 		return true;

-- 
2.55.0


