Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CCBA606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bEwUJt+0
Received: by kanga.kvack.org (Postfix)
	id BB6016B00EF; Fri, 30 Oct 2026 17:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B67116B05B1; Fri, 30 Oct 2026 17:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55726B05B2; Fri, 30 Oct 2026 17:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 678E36B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:34:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CAE23C064E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:34:54 +0000 (UTC)
X-FDA: 85380597708.21.9339541
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0615220005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:34:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bEwUJt+0;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396093;
	b=H5vJAxe4Rg8N9RKvojM3yS0kqA2AfeL63bvZvoegWD/oO8lARqLAhG9sAMYqcP01EjRjSa
	e+evClLr8HHDR+QH1jYFJXz4G6HuC2eg3UHtqQrTL2aqIkIswzZS9llYYMq/AVnoUhysk1
	Lt36/WyJthhIjod25Oo7Rk1U3f77hvs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bEwUJt+0;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jBWIioVXYy+FHhJhliV8CDro+rz/OXHsrYbyepdx8hc=;
	b=Rrm+erBe8P3D93EZdMZe823oX7D5jcVKTDQtN9sbnlQdCbD4e/sXU9JBK4Tr8Wep+06tbw
	gokSbFh485Xghj377E6/roLv5372Vtss/XUSAr63o+c892J5UtbeW0mnYuH7uY6e2aoXoZ
	B7olpajEmV08YpedJxqiej4N/75PQAY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 809176061A;
	Fri, 30 Oct 2026 21:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CC01F0093A;
	Fri, 30 Oct 2026 21:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793396092;
	bh=jBWIioVXYy+FHhJhliV8CDro+rz/OXHsrYbyepdx8hc=;
	h=From:Subject:Date:To:Cc;
	b=bEwUJt+05fIQN3u9oy4ForP+JKswoKiWrHs+DCYKrxZ6azz8nRw5iTHA26PKapl94
	 Db96Te6y7AcwLkHX5ZdQpUMM+RDNkDHhjTK7DDi/jK5a/wrgRGhGdB9pB7+0Y5qc4t
	 SHIrJCPZaj1njT5/t3nTQGdq0s5+yxHKeGkDnB50kSQfKEGNC5+M8XL8KuhZl0Dz8V
	 V0+GdSZZckkQuD6H/p9u1kVM+R5TbOblxUYdzhukpibTa5jv1fltlMg/y/IyPtxkoq
	 ID+9GayQCqglpzoH7xPGw06Wjz8vpbKx2tTQo/qoCScgasXfEtiOt4+q8Gu+acnUMD
	 s3gt821pkdgYg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/7] MAINTAINERS: MM updates
Date: Fri, 30 Oct 2026 22:34:24 +0100
Message-Id: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGAN5WoC/yXMQQ5AMBCF4avIrDXRSZC6ilgoU0aipINIxN0Vi
 7f4Fu+/QCgwCVTJBYEOFl58hE4T6MbWD6S4jwbMsNAZGjW37Lc4CqIIC2Osc2WOGuJjDeT4/Gp
 181t2O1G3vQm47wdr1FxcbwAAAA==
X-Change-ID: 20261029-maintainers-e2699bff7521
To: Alistair Popple <apopple@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Byungchul Park <byungchul@sk.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>, 
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
 Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, 
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2060; i=david@kernel.org;
 h=from:subject:message-id; bh=10ZJcWjFZEoKFDZGI+EPUsV8IVrcoG1epfheVqxA/xs=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKe8qZGna1kzNlb+lv9ykzOvO9F5sz/izVTE5KuXLM+H
 SRw6jJLRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABO5oMvwvz51pe6Zf++vtxd9
 eFa12/mmc80Ko7wjl3X3/uk5cTr0Xi8jQzODygetNSqBHFoJomefnt2dHOPvMH/amjPaCyYf3hf
 GzgUA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 0615220005
X-Stat-Signature: mxo7k5z5fy6pg3iebehhdgka387kgbak
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793396093-548196
X-HE-Meta: U2FsdGVkX1/rEbZjoWZJJYTL5O80RFgXA09KcJ/TWTiStwM8U4en+95QIRYjGqRcbljsf7Rkck0v4MgDvbXY4QWmixf+RT71mY2zIXeOBoxr//GgxhIssGtfMVBzf3oo9dQkentida2+wMY2wNatge54EBFQOEI4d9naYIQMoG1is3QEfYwJSU7g4eeqwUQxdcU7zlnNHxeeOEqBWhyVgtXJlt6DbpbXvYLRtXLKjClX09ECzE8a3VP3hd3j+ZEOJYGpwh9giTU9sN4tmNu1SdtkeonAobc/yqXcBFe6lzL+M07D8fRnFCpHu6Bh7jdsYEIgusfPEFFubebIlrTJE4Iac+wzOdBB3Q2PVPR2yQShWhUb1cz9Yjm3LEQi6aTTE/cu8pZhcX3ftyJ+6NZYm05JeVqUFEIWFHLZaujNhs/fBqy8nkL0Yr9/a5/8xKVx57ensDeIMKXiYUwBaPvTZX3XyTfsSiSWCjd8O0oZcKhMbDVdBbn5KRvNV3xyCPkztOfiPF3ZZxoI4C05Mrq2lmJ2JWFO7MqXqX2ij2RBfE+ZwppldwLSFpUxSLfUafuX+1qExB0hYHQZD4lmkt7SPT4MR+hypKedfPuGvL0npz32y9EVEdaY6OP9zaEOweSiGYkrFb+mgup+xgxiqolpL24UBTBqit7fXlMc/vfosxRWm+RP9cfem8ZsLKFoGTVWR+lQ9b+/Ky1VB+hh/sBlRFYDATCmo+7ZMkrBjnVotfj3ih9CAQqtxcSnV3fwW63UXoo/zRgotSTeE4Jmi4+L6auJXc4KsWy2yMF5ktGJFeOxcX2oEONF6E5CN0A9oVe5diwhGW0/bNmG7h0EZHKCoe4McIBGYaw80+dV8D/RUP7HVr3iVN98XTTT9XY3MvpkMJA81Yb9spbV+TN3kCkMnyk03lIaS1oalFWqbxMgRsnCivx7lJg2j21njFa2pmY2HZXqMEI1mNG1+tRa6zd
 WJV8uPvG
 W+kAJWRdCMz/N1QiJVAvWCXiOxnfwomxuhmctW540+aJL0IZJ2PkxSIh5sjPq0xVQTdJv8WUsqiT6g19k9LLoRkGgBsH7J6yfpjV84CU9H2O/HPi/krvr6hOivrZbBVtDSgzti71e6BpQ7Cafhj7NxxvxYWv0dtiCebuiLkN3M0VIwikEsId9mjTgz2aYaA26HGsV9n/MQfByiXsFUkt/iiRA01yfdwb6wcSWXhQn1jPuGIryYuQ3IGWZe/GSanBKolXZNqdD56Ot7U83XEUB9MCW8ws5bvMsAEBmG3mJB0b1nI6O9gnWMJarRYoB8kKhVwWM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

several MM updates:

Make Zi Yan a THP maintainer (thanks for all your hard work over
the years and thanks for taking on this responsibility), and perform some
MM MAINTAINERS cleanups.

Then, start the next step of the transition from Andrew's MM tree to
separate component trees that all get integrated into the mm-next
integration tree.

Start routing shmem through mm/core.git, adding me as a maintainer
primarily to pick patches.

Then, target the following components for the mm/core.git tree that I
(co)maintain:

     - MEMORY MANAGEMENT - BALLOON
     - MEMORY MANAGEMENT - CORE
     - MEMORY MANAGEMENT - GUP (GET USER PAGES)
     - MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
     - MEMORY MANAGEMENT - MEMORY HOT(UN)PLUG
     - MEMORY MANAGEMENT - MIGRATION
     - MEMORY MANAGEMENT - NUMA PLACEMENT
     - MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
     - MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)

More details in the last patch.

In the upcoming cycles we'll then route more of the other MM components
through different trees.

Let's see how this goes, in particular with the continuous stream of
fixes. But getting these in in a controlled way has highest priority
right now wither way.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (7):
      MAINTAINERS: mention for-next branch in MEMORY MANAGEMENT - MEMORY MAP
      MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
      MAINTAINERS: add Zi Yan as co-maintainer for MEMORY MANAGEMENT - THP
      MAINTAINERS: sort entries in MM sections
      MAINTAINERS: add missing files to MM component sections
      MAINTAINERS: rename and move MEMORY HOT(UN)PLUG
      MAINTAINERS: route more MM changes through mm/core.git

 MAINTAINERS | 165 ++++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 105 insertions(+), 60 deletions(-)

---

base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3

change-id: 20261029-maintainers-e2699bff7521

--

Cheers,

David


