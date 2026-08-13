Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E644C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 16:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5573B6B029A; Thu, 13 Aug 2026 12:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506F76B029D; Thu, 13 Aug 2026 12:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5A66B029E; Thu, 13 Aug 2026 12:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA646B029A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:08:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3E0CC0207
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:08:39 +0000 (UTC)
X-FDA: 85096729158.13.E837B33
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf21.hostedemail.com (Postfix) with ESMTP id 615381C0013
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:08:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786637318;
	b=V2khqyf51DsL5ROoG2GkAZ/ffsBXOfS/y63TTl8aLWChsBTwZSDhOy+4VhaPLhvXIzVffi
	IAUFvs+PSQpwFZQ9ne8buYR2p3k3pcx5TEG4BDPVrNRzPgl9aGBABfhWGbb2Tj363ZXnaO
	cpLP4AI0V0fI2KPE3UgmGOgsNm2igDM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786637318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=3c2kz4WIkZWvTjDnzQ6Bn8T9F8nRnAgYMFN74KEytuY=;
	b=CJBjeL+6jD/VznpNxTChbDd/vLWAp86yeYpn38BT9wtOmI69AakbmUAjq6XEIrFZclmMcP
	sgxnp/FlqgEvunPiRDetHu+DbDp2P7B7/e7CHW0DKHjN0PP7Vdp6MggVvfnf0kSBrLoALG
	fd1AbTSN/903Rw/eJsqwh3+nNHvzp9c=
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-01 (Coremail) with SMTP id qwCowAB3Se36631qXnJ7BQ--.9477S2;
	Fri, 14 Aug 2026 00:08:27 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH v2 0/4] mm/slub: preserve previous object lifetime
Date: Fri, 14 Aug 2026 00:08:25 +0800
Message-ID: <20260813160825.73031-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAB3Se36631qXnJ7BQ--.9477S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CrWfZr4xJw18ZFy7WFyDZFb_yoW8tr47pr
	WfKr1ftr1kXr4Ik3s3Cw109F95uayrGr4UWF4aqF4xur45t3WUAFZ2ka4YqryUCrZ7GasF
	qr1qv3ZxCFyUAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26r1j6r4UM28EF7xvwVC2z280aVCY1x0267AKxVW8JV
	W8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr
	1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7sRiKsUtUUUUU==
X-Originating-IP: [111.196.241.250]
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/
X-Rspamd-Queue-Id: 615381C0013
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ic3z3sja3uyjcxd3t64z391gsi6g938t
X-HE-Tag: 1786637315-463605
X-HE-Meta: U2FsdGVkX19z0tDhlKXnwcmwH8MFikkOo6XDpwttoKuI1+yyslVF07f6sN9+GQmV/DFZ/TsGRujMLU5Tzlr+jnTYlMQ0+ocvqlIyO7q+XllrKo8LBdcItr61Hc1aRGaEPAIZ4WmJAjs61Sd4KVZgJ37SNs0SBs8VmMN6PLEqvGlU5849+yeEYYFWhqRHbwHYdC3Spu795o2qtdJHDj8Zn9yJteWsH1P5XySlyamzeXbfQw3BVS8krEq62BVArh4qkRQBefyKSHFd9UoHXEAer0Li95LREmZo/q5jfE5ox41Hw1KKuRM7nXDgO1hfYeIs5H6nzS0OKVkps5H5CteBVmmKIyATp50+JCAw84lVAyBpstBnXbkZrbFZ1HV6e59aZqmGhcVngu/nh0x1Bp9pJTMXc135Ce5VuqqBGqhT9gxBGdJH7l7GpJojE66TXd5LbbrZakdeDty8JTtIpi2lxHyuMp0rkX2jnk3NtoSGsTPPRKiAcJdyDPr7EKvvilhIlxJ4nipNlzAz+409pF0cLhuWksnrCNep9hbQw8WNcpjBjCIcqMiJPdCAt3/M2oiFuoOYIXqP8dgXdFbiZJYE9ckYhuRjmrfIqXKWoilN7bpQLXhMs+1R4fOfnonNg0IkPuGLzII675hAec3cyAzQBO/q+bK6s3OJ0GYSL7I/8coakZjPQ+4FwtmWdvJLF5xoPQfSHapKHzzsDwyZqFCmfjDfgc4j5CX75xQpBcqPFQkhABUnPyIdZnnke7v3m44oghgcGV4gy4lEvTjvkIayHlCSCXvY5FmLY8FcWyK94IbMg8DdzCMzQMQMs8XOSAmGQ1aGSlDbQA5U8/YW1Uk7S3V42voqHJg+BgFLqEYTpj7NhlMQ1wa2wM0dlqTbf32FarxgWN8A3NpXDAJDklxu9rui3nj3zsSnpCAlcXSbeN1iTZzYDG7stXRMG0UZ9vs2HLLYSUfK+X8caSvQRNP
 YbexBKUt
 jEqKItgKbKUXufgoe8LGlFamaDR2AT/Jw2tTCl3ofuRAuBcaMs3Hs2RlfwxPyvgtp3EGk5236Jlu2zXyQrzxPD7NeO7Tu5q2eNVirOLGwzMX5vFEPygfMRBQ/K0CiIKRDYbiX12YjkhbFNbEZcnL9/MhlJ7QZyr/AbBnMk16sAgUjUNEqdLpilE/jbDywKGMPvjCz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SLAB_STORE_USER records one allocation and one free track per object.  A
new allocation overwrites the allocation track, and a later stale free can
overwrite the free track, so the completed lifetime that produced the
stale reference is no longer available in the report.

Extend the existing U option directly, as discussed on the RFC, to retain
one previous completed allocation/free pair.  The records remain address
history only; they do not infer semantic ownership.  The series also adds
KUnit coverage and documents the additional report section.

Changes since v1:
https://lore.kernel.org/all/20260616141410.52117-1-pengpeng@iscas.ac.cn/
- extend U directly instead of adding a separate H option
- use TRACK_NR in every user-metadata layout calculation
- copy the completed pair with explicit track assignments
- keep the current free track until a later free replaces it
- pin the KUnit task across immediate free and reuse

Testing used Linux 3d6d817622b0, GCC 13.3 and QEMU 8.2.2 for x86_64.
The focused SLUB KUnit test passed, including immediate free/reuse and
verification that the completed allocation/free pair moved to the
previous-lifetime slots.

A temporary KUnit probe, not part of this series, recorded the internal
cache slot size and objects per order-0 slab before and after the series:

  object bytes    U slot/objects    patched slot/objects
       32              96/42              160/25
       64             128/32              192/21
      128             192/21              256/16
      256             320/12              384/10

All four caches retained slab order 0.  The table quantifies the expected
per-object metadata cost only for caches using SLAB_STORE_USER; caches
without U do not allocate these track records.

Pengpeng Hou (4):
  mm/slub: use a track count for user metadata sizing
  mm/slub: preserve one previous object lifetime
  mm/slub: test previous lifetime tracking
  Documentation/mm: describe SLUB previous lifetime tracking

 Documentation/admin-guide/mm/slab.rst | 13 ++++-
 lib/tests/slub_kunit.c                | 35 ++++++++++++++
 mm/slab.h                             |  4 ++
 mm/slub.c                             | 69 ++++++++++++++++++++-------
 4 files changed, 104 insertions(+), 17 deletions(-)


base-commit: 3d6d817622b0a9721e3cc404df3469171582be13
-- 
2.50.1 (Apple Git-155)


