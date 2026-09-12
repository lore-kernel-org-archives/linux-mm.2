Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E37AC88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 19:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0BF66B00AB; Sat, 12 Sep 2026 15:50:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6DFE6B00AC; Sat, 12 Sep 2026 15:50:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5CB16B00AD; Sat, 12 Sep 2026 15:50:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5A76B00AB
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:50:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C3601A058C
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:50:23 +0000 (UTC)
X-FDA: 85206151926.02.A7327D1
Received: from mta0.migadu.com (out-48.mta0.migadu.com [91.218.175.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8734E80003
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:50:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DG1wY6Z4;
	spf=pass (imf02.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.48 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789242622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mtw+c/AOmdiC/qVn4Qu1NmY7n7Mmt4AEmzZqI/VR6G0=;
	b=NOecPg5ehC80d56ilujnZ0tKovGGCUc3Z2ogH3R6shrt1gfelHHCRwAvuMNZcoNcmrtGid
	EkboUWWiJip92Mn4SOdc5edwyUUaayHkDD/S109GCtfV+32UXbw+GaOiGI1rEidbBdwb9y
	aPHoSGcRSd8LGIGVKrhxN3JD1OGMazA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789242622;
	b=JHSATwoowdhXTIBgcz/TLBI1A4tN0UoNL88KrmpGAAe5uCG9A5lHtR2+pxZ8WtyAkJCEIb
	WCdiCxsZRd9hX8bvkAnviYyRz8qeDjeAdQAaBA/NS6JRn7cfh1rUH/T+B7zGUJSVAcGalw
	bZ5Fnhl2AIh7a+ARxAv2Dhl+a75SQfc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DG1wY6Z4;
	spf=pass (imf02.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.48 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xj5HW2/JOE89pE436b8pIPlE/VRt03TZ7+Dwvo04iEI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789242619; v=1; x=1789847419;
 b=DG1wY6Z4iIpHeWxx3Z1iFwNeL5oqcUSCHTnmamUXMwC3L4oBoo109vi3SfhDX8uS3yqrcDmW
 6OY4qbxxu/eKc6DreXPU3B92feDl3W+29xa8oY8+yXzKjPH/rv6qBUqucbDdfTpKHdm8rbOhdCm
 JShBB8WNXCOUjgNG2SkqawGY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id fd67c0cc06b11572;
	Sat, 12 Sep 2026 19:50:17 +0000
X-Mizu-Trace-ID: fd67c0cc06b11572
X-Migadu-Flow: FLOW_OUT
From: Ilya Gladyshev <ilya.gladyshev@linux.dev>
To: ilya.gladyshev@linux.dev
Cc: akpm@linux-foundation.org,
	andrew+netdev@lunn.ch,
	apopple@nvidia.com,
	artem.kuzin@huawei.com,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	Liam.Howlett@oracle.com,
	edumazet@google.com,
	harry.yoo@oracle.com,
	hramamurthy@google.com,
	ivgorbunov@me.com,
	joshwash@google.com,
	kirill@shutemov.name,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	torvalds@linuxfoundation.org,
	vbabka@suse.cz,
	willy@infradead.org,
	yuzhao@google.com,
	ziy@nvidia.com
Subject: [PATCH v6 0/3] mm: improve folio refcount scalability 
Date: Sat, 12 Sep 2026 22:50:07 +0300
Message-ID: <cover.1789239015.git.ilya.gladyshev@linux.dev>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8734E80003
X-Stat-Signature: mjjawj4oiw656iztfuww6jb813oqme45
X-Rspam-User: 
X-HE-Tag: 1789242621-820039
X-HE-Meta: U2FsdGVkX1/VkLntSZ2nLaleS8/LJUKZeFjrUtGGeX93KBdfPV0XzZEaT56vf8wSIq6gN2a9/6offM2rW2ls5c3wqfKKsSktAxvSm/BKRTSQCBplPyBpFnmrQ/sIMc6a66LFNlW3yEKrvcXcHl6kusEyKPo9Sn1ZaFh+R533mpQqzuH2xnweLGGGsItceBbiM/uh1zTkV7lWy2vil35s6VHhIh35h3mxJi/ySR0yzbdpAIw1kmS+CKk7jIh385EPnWSZ6jjNi186r+dnwyB+b2PN0rqDoJjeszyf/9fQEU7XjmVmQ2KKMnJKN2LQ8pC4+kBG/B+JXulN6Yk0Pyj+Vu9GW6YKC+eXUy1qocOZgS3vzxrrKrILl6KyHBhARkTNzSsARebWS6wP++SoH8tHf0db6tHy3C4+yoxtZ7qHbLOZ9AzgPzgjp374iPKoz9jIJHd+YhdZYYcflsX+nDuBeJJ0EkKwKl2v+bwGXmJHh7WrV5sL5A8nbjpn56Pm1JcR9IcHc4T/K+POIAJyLN3ovSphvV6A2pmPbQNSULgrNm8EOZDvYaPazsk/sLQ7YBevJFqHR1QkrpBe4Z3o73xFyuyI46pRZVnX/hfqqszTMKnJw97pLx3SVmgjEBSgq/IjFwP05tqijH9sz55hc68yrVfZohnLRAUBkQBqJBCpe1LU2yYLGwp1O2aYgOduLxNYwaGn2dt7kQehE9pRLgkNKq8fbY19lKRK4wBUcPFejJ14KC6I7sp+EnnaBk89FgkhwozbX3a3xf+T03QNFIRcjPAuB9ppaGdj7MM276dDdqtBHPjydX8UvHbC/M5sa0zr+SdYKmYeq+7Hrr5z76pBsKiUCGuKSrQd/1KM+7rapnMUJNYprMLBFHhTKpWyMVpvd9L4KyS+nNTs/Lvy1LkXwRyAWXZ+z1SjDWJgRdfw7pULRLf+2oFR7nxghPKTsx9dBxBhahza6ShAyy6zeMs
 mlx777XP
 dtg9iKyB9BZgKt0a4ffK7o+LxR5zwZMoK2fMLOFxJ1BcJb4ixl0HNCaiT2Ua0oLsFRWIFTrsZ7qCKneCV03bpD6wGfy+Vq5deu/CUDm62CjjmIZ3/AhXuNCcfSv66JwCHPqIg6zZOWapx4IHuai3Odv6NfHqB1pPf0FkEBvENTGilm4QLoUMvlZwQbOSokPcfTczRPqRxAITcqCBypnrcSoOrwh1KKdGxuyTiMzC3yI/pFA4gZ5PcQDVWO3azne6jLnFyYTib08yIPrFb+eDS1kmDFbtqM1/eo7Pr4hCXLM3bRCSK4yViHxco17U/nZlEtOIN+P/VuqqWiWzX3H+nt+ZqMkY0W53g0axaEsyO2Wp9KPUtXcPk4BnV0WX++SFgp37bwqi9PJv3lbpUV8TsOjrdVLVqwtxChXv2ZcuSWgsofag3eS3OEkjp/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gladyshev Ilya <ilya.gladyshev@linux.dev>

Recap
-----

This patchset addresses a scalability issue of a folio's add_unless() operation,
noticeable during contended IO reads from the same page [folio_try_get()]. The
main idea is to replace CAS loop with optimistic increment (and deal with
failure later). This requires splitting refcount into counter and separate
"dead/frozen" bit.

To allow for such modification, this patchset also slightly refactors page_ref
API, consolidating all implementation logic inside mm headers. For more
information, check individual commit messages. The original performance issue
and previous attempts by other people can be found in [1][2].

Performance
-----------

To my regret, I don't have any access to high-core CPUs that I can
benchmark on, and a 12 vcpu laptop isn't really a scalability test. So,
here I can only paste my previous measurements on Linux 6.15. To be fair,
none of the related code paths really changed, so I don't expect any changes in the
numbers here.

Performance was measured using a simple custom benchmark based on
will-it-scale[3]. This benchmark spawns N pinned threads/processes that
execute the following loop:
``
char buf[]
fd = open(/* same file in tmpfs */);

while (true) {
    pread(fd, buf, /* read size = */ 64, /* offset = 0 */)
}
``
While this is a synthetic load, it does highlight existing issue and
doesn't differ much from the benchmarking in patch [2].

This benchmark measures operations per second in the inner loop and the
results across all workers. Performance was tested on top of v6.15 kernel
on two platforms. Since threads and processes showed similar performance on
both systems, only the thread results are provided below. The performance
improvement scales linearly between the CPU counts shown.

Platform 1: 2 x E5-2690 v3, 12C/12T each [disabled SMT]

#threads | vanilla | patched | boost (%)
       1 | 1343381 | 1344401 |  +0.1
       2 | 2186160 | 2455837 | +12.3
       5 | 5277092 | 6108030 | +15.7
      10 | 5858123 | 7506328 | +28.1
      12 | 6484445 | 8137706 | +25.5
         /* Cross socket NUMA */
      14 | 3145860 | 4247391 | +35.0
      16 | 2350840 | 4262707 | +81.3
      18 | 2378825 | 4121415 | +73.2
      20 | 2438475 | 4683548 | +92.1
      24 | 2325998 | 4529737 | +94.7

Platform 2: 2 x AMD EPYC 9654, 96C/192T each [enabled SMT]

#threads | vanilla | patched | boost (%)
       1 | 1077276 | 1081653 |  +0.4
       5 | 4286838 | 4682513 |  +9.2
      10 | 1698095 | 1902753 | +12.1
      20 | 1662266 | 1921603 | +15.6
      49 | 1486745 | 1828926 | +23.0
      97 | 1617365 | 2052635 | +26.9
         /* Cross socket NUMA */
     105 | 1368319 | 1798862 | +31.5
     136 | 1008071 | 1393055 | +38.2
     168 |  879332 | 1245210 | +41.6
               /* SMT */
     193 |  905432 | 1294833 | +43.0
     289 |  851988 | 1313110 | +54.1
     353 |  771288 | 1347165 | +74.7

Changes since v4 (last significant checkpoint)
---
- Lower Google GVE pagecnt_bias
- VM_BUG_ON -> VM_WARN_ON_ONCE
- Refactor missing API calls in mm/memory-failure.c
- rebase
- Make __page_is_frozen() public and introduce folio_is_frozen()
  counterpart [3].
- Make commit messages more informative

Link to v4: https://lore.kernel.org/linux-mm/df26082871b4c65b2bd38d409026237c08572836@linux.dev/

[1]: https://lore.kernel.org/linux-mm/CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com/
[2]: https://lore.kernel.org/linux-mm/20251017141536.577466-1-kirill@shutemov.name/
[3]: https://lore.kernel.org/all/aqAIFV4nOGPbWiDS@thinkstation/

---

Ilya Gladyshev (3):
  gve: reduce pagecnt_bias to USHRT_MAX
  mm: drop page refcount zero state semantics
  mm: implement page refcount locking via dedicated bit

 .../ethernet/google/gve/gve_buffer_mgmt_dqo.c |  4 +-
 drivers/net/ethernet/google/gve/gve_rx.c      |  8 +--
 drivers/net/ethernet/google/gve/gve_utils.c   |  6 +-
 drivers/net/ethernet/google/gve/gve_utils.h   |  2 +-
 drivers/pci/p2pdma.c                          |  4 +-
 drivers/virtio/virtio_mem.c                   |  2 +-
 include/linux/mm.h                            |  2 +-
 include/linux/page-flags.h                    | 13 ++++
 include/linux/page_ref.h                      | 69 ++++++++++++++++---
 kernel/liveupdate/kexec_handover.c            |  6 +-
 lib/test_hmm.c                                |  4 +-
 mm/hugetlb.c                                  |  2 +-
 mm/internal.h                                 |  2 +-
 mm/memory-failure.c                           |  8 +--
 mm/memremap.c                                 |  4 +-
 mm/mm_init.c                                  |  6 +-
 mm/page_alloc.c                               | 10 +--
 mm/page_frag_cache.c                          |  2 +-
 18 files changed, 108 insertions(+), 46 deletions(-)

-- 
2.55.0


