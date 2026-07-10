Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 077A1C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 02:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36156B0005; Thu,  9 Jul 2026 22:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE6D16B0088; Thu,  9 Jul 2026 22:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5E06B008A; Thu,  9 Jul 2026 22:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB2C06B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:09:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31951C1B87
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:09:40 +0000 (UTC)
X-FDA: 84971235720.20.E5CC77D
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf29.hostedemail.com (Postfix) with ESMTP id B4632120005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:09:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tv6GfFIN;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783649377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4sPb2w2Kp8Vex0lFa0KYOZ0Mh/KcMKyi6fG7aRgEeLA=;
	b=d32xPvJpYWGybWxaM3Ma0BkhPqPUKcFP0IXyhl/QCachnwZLoOOSag6YyLyhcWFM/RGxT/
	cFQ82dTTWy6fqA2BIMAo5X+aTpKw+XoKK6iIXg5LGO0y3TO2JmYfNaiLjzHCm6U4rlmqRw
	0x/a0Oij0DOXrSJzeBAQ76BJMBiIIQ0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tv6GfFIN;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783649377;
	b=j1VJzeRekky5JFez8YqvIKzdZ1dO+JZcqMRsqMFiTM/t/9iKadxDrbaG8/b64u0Rvewq6z
	LIR9QwCW3YadqdyVQyAwrvHpN5mP2PcUsp6RjtRq7I7Dv7iZfFnxar4hfiiz0GVP69K55h
	btOuwhCB1A7+5YMZJY+IbgReyQsVdEE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783649374; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=4sPb2w2Kp8Vex0lFa0KYOZ0Mh/KcMKyi6fG7aRgEeLA=;
	b=tv6GfFINs3xV2vbT6iV59nX8cjbtBVv8g/4C05JDVu2JvYpu0H+nnMV4Jng6Mp97jtL8tocUI0La1/Lnm5GDzJRX5kLbpXf0h/yNwRATFruIBS+iABRICqgxAsV5AFZr3jL3S6JWoIA4/L/fCQPLgv/P4XXm4kbUvKdgI3UT5YU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X6mBlmQ_1783649372;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6mBlmQ_1783649372 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 10:09:32 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	stable@vger.kernel.org
Cc: kasong@tencent.com,
	baohua@kernel.org,
	machao26@xiaomi.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.18.y v2] mm: shmem: fix potential livelock issue for shmem direct swapin
Date: Fri, 10 Jul 2026 10:09:22 +0800
Message-ID: <c0b158fe3f25709543b48a9d81b1933120a9e2ba.1783648317.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B4632120005
X-Stat-Signature: 9uaq9ywqq8ei5sj8ncw5a65jgn8dthwh
X-HE-Tag: 1783649376-947909
X-HE-Meta: U2FsdGVkX1+i8v4TCOvKQns4w9xbrMSu6rzKTBwbu1u3O8kk+ytGSYHbX47W1+mS+hGcvMz7K6D721pvXYgbPGYFiWLAbcVRn4OgEFkjcZolEXP1B1Un31TYqJCvbzb+Lk/kHAMVXPdZRMu92tOr9GQyUGjc90M0yv6xrpSMoiwL0BszQQIBCi09SvYEuus1HBmH4XyrHbKscAbziD7btaFHRutquWczswDkhG0r4B6k9Skc50MNP5px6HlwRAdwks2Kp9JpGNEmXl0RGPCIsVEhthvdpkEfj/JVl9vaf2WwUnYBjVzvbZwX8ELqcLEwvTChd3KEeMIjdZqoBiGKYt2B8ompipb+qrEy0B1GVG5injVGG1fJS78WKTTTzNIdzig07OguRg451Sl1yck/94MI3pt1hufwK/6tVpaUUgZKNjhaN0hpvDRn+pKZTLmPK0p+yMLhs3qz6Cgfft++Ypmm+FM+oYSldxXxglCXMiKX1FGWiFY1fOKeZrE5thkyc4iVYAjYo59CSwAT8Jm2+NXoJ2jGQTYTrenjeIPxvdPzdOnFyxYIuGHODfXuNfHyOHofIvLNdq2cQMxwi+vu4NxVaTBV0ItYufmzXR2SRZcr3DRDvVx3gl4bnnSHVau02dgF/UOVYjlS1h0486N5NssRqLIVvrJ5QwNrmSTHfxNGtESHNOEIGWpe+7Lr9umgn4Ik6ZzJMw7UqkLgLc+l8dJPoHKxjoLwGoyg/gHwlUJGQO0mOxgQJ+MNscW3C323I1Y+YFi5GPMX8QVd2ByYezzwU0ZieIH5IlyZ5KlU3scAhy2WrRJmsZ9dnkVKWuZSb+Ejr/QbIbjkp4APL+We8OD1WUw4qfimpf0Enij0ixqPYqkwrNA7yXXCg8kBYOsW1Ei1A2yhTXNCfmAsw/OWtlvHwTwIrmlpmlteVRNPBuNytaispldQyV3AMvfV5cf72ngfoWxjglXgNpqI+lz
 5jqguyZ7
 J57Ne5Tdlkusa6gfFtWIhZaz/zkWVcwGhH4dFznD4DklxfpMbw8QENPGU23xvdwbLmu2ovsn6hpssNr1MBaPIHnudjhe7vbl98Vys43fPRKw3Z7xDMAW0+kgYm3vKW/lWhi/QU1LnV+Hh1VriqJo8rHiigm+Ejo1h4yD5jY4T7X+1dBx0CESevJaOWSuk0Z4zDyzT+WnDhtuasjd+qoTYn9XhiY2AAACm4EFmzHQNiuxJtooXeEVDXHZKQg4dmUmWV1k4sjAYbxJWKdDABhyr4AUv2iRCRd+WYKljJAVwNR6k86aq+qLsM+zw6flXNt68g6Uf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When skipping swapcache for synchronous IO swap devices, swapcache_prepare()
is used to prevent parallel swapin from proceeding with the swap cache flag.
However, on PREEMPT kernels this can lead to a livelock, as reported by Chao[1]:

Thread A starts direct swapin of a shmem folio and calls swapcache_prepare()
to set SWAP_HAS_CACHE. It may then be preempted inside workingset_refault().
Meanwhile, a higher priority thread B also attempts direct swapin of the same
shmem swap entry. Since swapcache_prepare() already marks the entry, thread B
repeatedly gets -EEXIST and busy-loops waiting for thread A to finish. But as
thread B runs at higher priority, thread A cannot preempt it, resulting in
starvation and a livelock.

Fix it by yielding the CPU with schedule_timeout_uninterruptible(1) when
swapcache_prepare() fails, following the same approach used in commit
029c4628b2eb ("mm: swap: get rid of livelock in swapin readahead") and
commit 13ddaf26be32 ("mm/swap: fix race when skipping swapcache").

However, commit 01626a1823 ("mm: avoid unconditional one-tick sleep when
swapcache_prepare fails") found that the unconditional one-tick sleep can
cause UI stuttering on latency-sensitive Android devices. So we can follow
the same approach by adding a waitqueue to wake up tasks when needed,
instead of always sleeping for a full tick.

Note that mainline does not have this potential issue, which has already been
resolved by Kairui's swap refactoring work[2].

[1] https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.com/
[2] https://lore.kernel.org/all/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com/
Fixes: 1dd44c0af4fa ("mm: shmem: skip swapcache for swapin of synchronous swap device")
Reported-by: Ma Chao <machao26@xiaomi.com>
Closes: https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.com/
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changes from v1:
 - Add a waitqueue to wake up tasks when needed.

Hi Chao, could you try this patch to check if fix your issue? Thanks.
---
 mm/shmem.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 94c5b0d78ac3..3c329b794ae4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2005,11 +2005,14 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
 	return ERR_PTR(error);
 }
 
+static DECLARE_WAIT_QUEUE_HEAD(shmem_swapcache_wq);
+
 static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		struct vm_area_struct *vma, pgoff_t index,
 		swp_entry_t entry, int order, gfp_t gfp)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	DECLARE_WAITQUEUE(wait, current);
 	int nr_pages = 1 << order;
 	struct folio *new;
 	gfp_t alloc_gfp;
@@ -2066,6 +2069,10 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 	if (swapcache_prepare(entry, nr_pages)) {
 		folio_put(new);
 		new = ERR_PTR(-EEXIST);
+		/* Relax a bit to prevent rapid repeated page faults */
+		add_wait_queue(&shmem_swapcache_wq, &wait);
+		schedule_timeout_uninterruptible(1);
+		remove_wait_queue(&shmem_swapcache_wq, &wait);
 		/* Try smaller folio to avoid cache conflict */
 		goto fallback;
 	}
@@ -2423,6 +2430,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (skip_swapcache) {
 		folio->swap.val = 0;
 		swapcache_clear(si, swap, nr_pages);
+		if (waitqueue_active(&shmem_swapcache_wq))
+			wake_up(&shmem_swapcache_wq);
 	} else {
 		swap_cache_del_folio(folio);
 	}
@@ -2442,8 +2451,11 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (folio)
 		folio_unlock(folio);
 failed_nolock:
-	if (skip_swapcache)
+	if (skip_swapcache) {
 		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
+		if (waitqueue_active(&shmem_swapcache_wq))
+			wake_up(&shmem_swapcache_wq);
+	}
 	if (folio)
 		folio_put(folio);
 	put_swap_device(si);
-- 
2.47.3


