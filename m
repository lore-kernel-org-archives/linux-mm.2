Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE98CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 09:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7CB8E0013; Mon, 17 Nov 2025 04:30:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78838E0002; Mon, 17 Nov 2025 04:30:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E588E0013; Mon, 17 Nov 2025 04:30:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DEE98E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 04:30:38 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21C1A140CC4
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:30:38 +0000 (UTC)
X-FDA: 84119578956.23.72266EE
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf20.hostedemail.com (Postfix) with ESMTP id B99A41C000C
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:30:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=EEsgL4b3;
	spf=pass (imf20.hostedemail.com: domain of mambaxin@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=mambaxin@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763371836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LZcR7Q4cpqHteOASNgU0SXmxsFcuej1Nddkk9obHzEc=;
	b=2DzLNoef88DJPt4S83ZLzUAeahGkXh6sEUvcHNq4ktv47BmwhKrgpNyT59qmiOJaiGiH+5
	ZsRY2JSLn+N3MK6OLsKTVG6NT243bHsbkO6IS0g6W1mtHEnzumTnu86rbb1M1OQdPmMJ4v
	hn0IVpWsMS/Djk9TcQ+64WLO4WIj33E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=EEsgL4b3;
	spf=pass (imf20.hostedemail.com: domain of mambaxin@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=mambaxin@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763371836; a=rsa-sha256;
	cv=none;
	b=BZpRdhbxJzlskgomIBLz36l4B47EUsHefRuhTTq+ZUKAznCodJcGeFRDOI8+R64RKULIJ+
	Aorh8biofALCwwd9af28D5Gd8Bfi8FC3HMqHexKdgpx+T5e7A4Gph38/bocnUeXHdBf2is
	YeCuOMHqk7SrOF1DLn082Yt0Ca8aPc8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=LZ
	cR7Q4cpqHteOASNgU0SXmxsFcuej1Nddkk9obHzEc=; b=EEsgL4b36rrHCiJCoF
	erxKTB+v6VTsim7kEFVrB4h2DCEAcxCBDOUQHLa2MR0JNuFgIrKmfkD2dqqUZiMc
	N7F8xQZKVTrFRPFpvLOgWkVAPMTnV3DrGYYMrhu98oIqrkkE4MiFkELumI6ZLCPr
	oSSZ6+u3HEP6rNUK8sNSPFxgw=
Received: from localhost (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgC3Geku6xppowwAEA--.2573S3;
	Mon, 17 Nov 2025 17:30:23 +0800 (CST)
From: mambaxin@163.com
To: dennis@kernel.org,
	tj@kernel.org,
	cl@linux.com,
	akpm@linux-foundation.org,
	gregkh@linuxfoundation.org,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>,
	Filipe David Manana <fdmanana@suse.com>,
	chenxin <chenxinxin@xiaomi.com>
Subject: [PATCH 6.6.y] mm, percpu: do not consider sleepable allocations atomic
Date: Mon, 17 Nov 2025 17:30:13 +0800
Message-ID: <20251117093013.545253-1-mambaxin@163.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgC3Geku6xppowwAEA--.2573S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxGryrXFy3KrW7urW7GFWfXwb_yoW5KFW8pF
	ZYg3W0vFZ5Xrn3W34vy3Z2gw4Ygw4rWFW8GwnxWw18Zrs8Jr10gr92ya4YqFy8XF9YvF1Y
	vrZ0qF9aqayUAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jneOJUUUUU=
X-Originating-IP: [153.3.251.212]
X-CM-SenderInfo: xpdputx0lqqiywtou0bp/1tbiJhkJCmka3GjFMQABsO
X-Rspamd-Queue-Id: B99A41C000C
X-Stat-Signature: iu1o1q6je1z7kbmxnsqmtqt7kmwjfug1
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763371835-993227
X-HE-Meta: U2FsdGVkX18d+3AjVMSaQlKZxBYWZUU5v6VbMpowEClN4s+0A0InKGt69gECUkiOvl6o/O8uU/pF9Y047qlrRlNCTU9CLNpUDAusq/cJpmqlAcokVYBZoeRQawxw2KYsn7X28BgCLjHHfjLXRo2dzIkZdc7sIUdpUKdZ5bhIWm1xjTTDt6hNDWz3sWVeRTH/jMEtg0c51W0OK9g7+VZU6/1CoSluLCC5uTs/o3LddOmGqcGi7P/JPIFAvwsw4TWDRiUOJSofPYhYumsvX2VkoV07MOsBdFSAnTXecOXuRrBpGbXp78DB1HMbd1Qu7KNSwJUl93DZ2W237fBZ+CnAAlBbq/3COTpm5HSgIY15EzEyQAmue4oYwucv1Pam1TGZvzLcBASYIsKEKeN9Ya0urWcmDdmzCSfwQ6hCqnI+ziFJP+68/PyPcU5mQ1HwX2QuW12XiWKJ2ueisHJd28LyUgIazQBYIh2I2F0D5Ofts1c/dV+ChHkio5HwzVniRLkv0uEn2/OYT7iyGiirlh+2IDsnrxTpAUyrXSarb1fFY78GuLOSxBlEvF3SgO2K/YkFjwbSg3HbYb9mOzYJpswMLTrfhBZjRmUE0Ph9F0pvW2kU1GkosT0mNKwT6I8fzLZahotNuC8WuHIaFIw40XALYxZ5Pksi7S1HSBJ29dmU+pdMNSW4iKOOlJON7bljqI9EqMwqZb0a0cMzL2/wIcAcXKzZ0BtPr1OmfaSdPs1AoOEe0/+Mx/Sqj1Gqwdf0Eo3P92QTMs/YSGP9fAsyABbyVCpg69SG+XeTiIJuFL4RKgCkTyFGgpxkte9kDd/1fUzf1MAPcm1L+f5PKXw3LgQVM2UD9oGpVVOhepbE9Ar8W30JgDpDJOGwbc8t6LN/vgKQGsWBbVV8vtsBmrH7M74JXI4hrJJ8fZdCxd2gKUvHSLO86S2zX5tFY0DAFYnF7dI6rwlDi0zK1dM/o7LXvSx
 04B9AA2d
 tN9/v+Qb5J61/TUmfEah8iMgBreJClrtjuhKzhr61Yia36m3G0iJs0EVKAOaiLwl5BmBqWbtbRHZm1ylG44+vYdmdmnvBXIfql3I6pp8O+a/7pao=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Michal Hocko <mhocko@suse.com>

[ Upstream commit 9a5b183941b52f84c0f9e5f27ce44e99318c9e0f ]

28307d938fb2 ("percpu: make pcpu_alloc() aware of current gfp context")
has fixed a reclaim recursion for scoped GFP_NOFS context.  It has done
that by avoiding taking pcpu_alloc_mutex.  This is a correct solution as
the worker context with full GFP_KERNEL allocation/reclaim power and which
is using the same lock cannot block the NOFS pcpu_alloc caller.

On the other hand this is a very conservative approach that could lead to
failures because pcpu_alloc lockless implementation is quite limited.

We have a bug report about premature failures when scsi array of 193
devices is scanned.  Sometimes (not consistently) the scanning aborts
because the iscsid daemon fails to create the queue for a random scsi
device during the scan.  iscsid itself is running with PR_SET_IO_FLUSHER
set so all allocations from this process context are GFP_NOIO.  This in
turn makes any pcpu_alloc lockless (without pcpu_alloc_mutex) which leads
to pre-mature failures.

It has turned out that iscsid has worked around this by dropping
PR_SET_IO_FLUSHER (https://github.com/open-iscsi/open-iscsi/pull/382) when
scanning host.  But we can do better in this case on the kernel side and
use pcpu_alloc_mutex for NOIO resp.  NOFS constrained allocation scopes
too.  We just need the WQ worker to never trigger IO/FS reclaim.  Achieve
that by enforcing scoped GFP_NOIO for the whole execution of
pcpu_balance_workfn (this will imply NOFS constrain as well).  This will
remove the dependency chain and preserve the full allocation power of the
pcpu_alloc call.

While at it make is_atomic really test for blockable allocations.

Link: https://lkml.kernel.org/r/20250206122633.167896-1-mhocko@kernel.org
Fixes: 28307d938fb2 ("percpu: make pcpu_alloc() aware of current gfp context")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Filipe David Manana <fdmanana@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: chenxin <chenxinxin@xiaomi.com>
---
 mm/percpu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 38d5121c2b65..54c2988a7496 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1734,7 +1734,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved,
 	gfp = current_gfp_context(gfp);
 	/* whitelisted flags that can be passed to the backing allocators */
 	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
-	is_atomic = (gfp & GFP_KERNEL) != GFP_KERNEL;
+	is_atomic = !gfpflags_allow_blocking(gfp);
 	do_warn = !(gfp & __GFP_NOWARN);
 
 	/*
@@ -2231,7 +2231,12 @@ static void pcpu_balance_workfn(struct work_struct *work)
 	 * to grow other chunks.  This then gives pcpu_reclaim_populated() time
 	 * to move fully free chunks to the active list to be freed if
 	 * appropriate.
+	 *
+	 * Enforce GFP_NOIO allocations because we have pcpu_alloc users
+	 * constrained to GFP_NOIO/NOFS contexts and they could form lock
+	 * dependency through pcpu_alloc_mutex
 	 */
+	unsigned int flags = memalloc_noio_save();
 	mutex_lock(&pcpu_alloc_mutex);
 	spin_lock_irq(&pcpu_lock);
 
@@ -2242,6 +2247,7 @@ static void pcpu_balance_workfn(struct work_struct *work)
 
 	spin_unlock_irq(&pcpu_lock);
 	mutex_unlock(&pcpu_alloc_mutex);
+	memalloc_noio_restore(flags);
 }
 
 /**
-- 
2.50.1


