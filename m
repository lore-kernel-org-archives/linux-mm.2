Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34E81CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 09:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508A48E0009; Mon, 17 Nov 2025 03:59:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8708E0002; Mon, 17 Nov 2025 03:59:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8488E0009; Mon, 17 Nov 2025 03:59:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24DED8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:59:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC5E61A0C6F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:59:58 +0000 (UTC)
X-FDA: 84119501676.19.82E8B4F
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf11.hostedemail.com (Postfix) with ESMTP id 004C34000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:59:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=AnK1WtKl;
	spf=pass (imf11.hostedemail.com: domain of mambaxin@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=mambaxin@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763369997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UCoyTfr8gCn8mJ1uiwDuIzSa07pY7bQVEfFH0JQUb/o=;
	b=SUYmbiUpV/wCike05rnDs6Ms2QYV9rr5p4YsHAo3xNxTaU6PIjMNc5d7b0qIGkhdNgJOOv
	0KwuVc9LaNRNO4G5aITPiCGOHQePNrnm8agVoqdQvvN6nWbk0RU25axybUPdZPiyfVBeD9
	Rtqj4hfTGDc3W57XPP3UBW/CzZIIjmU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763369997; a=rsa-sha256;
	cv=none;
	b=RNeoqwzVLdo/4yfDnSIZToZjZq5SEgpxJIF8tCmaAWQVRVN47OFU5umgEbkBVByyoQ0zAu
	abzH5f1jlqZEMlIHsaSyqc2CYv22U5Y2H8+G8g3ihtXYpvIh0WlBmvcfuwncoQON1IvOXV
	p7zKVvUgVYrImwrQmTMtrHNS9nr9fe8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=AnK1WtKl;
	spf=pass (imf11.hostedemail.com: domain of mambaxin@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=mambaxin@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=UC
	oyTfr8gCn8mJ1uiwDuIzSa07pY7bQVEfFH0JQUb/o=; b=AnK1WtKlwnBLWPojsY
	QV7/mG8PIQ4VkMAhh42b0phurQvL0PxVAvKH3QQKe4v62yfbY58F8bQMIG7AUbtZ
	SvnUP5YJCVSVmWDJ9pj3Gah8d/bgj9GOKdu5Cx4/ceW5fJdQg2R4xhw7WLCkn3Qs
	O+LjLCjdyjAeDM9pSZ5NWg8n4=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wAXSpP94xppVWuYAw--.64332S3;
	Mon, 17 Nov 2025 16:59:42 +0800 (CST)
From: mambaxin@163.com
To: dennis@kernel.org,
	tj@kernel.org,
	cl@linux.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	mhocko@suse.com,
	Vlastimil Babka <vbabka@suse.cz>,
	Filipe David Manana <fdmanana@suse.com>,
	chenxin <chenxinxin@xiaomi.com>
Subject: [PATCH 6.1.y] mm, percpu: do not consider sleepable allocations atomic
Date: Mon, 17 Nov 2025 16:59:22 +0800
Message-ID: <20251117085922.508060-1-mambaxin@163.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXSpP94xppVWuYAw--.64332S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxGryrXFy3KrW7urW7GFWfXwb_yoW5Kw4DpF
	ZYg3W0vFZ5Xrn3Ww1vv3WIgw4Ygw4rWFW5G3ZxWw18Zrs8Jr1jgr92ya4YqFy8XF9Y9F1Y
	vrZ0qF9aqayjya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jneOJUUUUU=
X-Originating-IP: [153.3.251.212]
X-CM-SenderInfo: xpdputx0lqqiywtou0bp/1tbiJhkJCmka3GjFMQAAsP
X-Stat-Signature: nzhaxd3rkt34aqgk4q63xn8woffjgckk
X-Rspam-User: 
X-Rspamd-Queue-Id: 004C34000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1763369995-154746
X-HE-Meta: U2FsdGVkX19aBS1rfqK21aAW0CXKygMZqumB8JtdivKxt0ps0fsLbC+7OyMDLd1lxZ2Mg1Jn/fcn9tc1yuoAGidCdg+rrYkkihGCMUeR5kkIideCxhNwN4gdiN1MotHSi8PjRoof8WMMAcjF9Aw4YpqJrA7af5QOfB7SYbVANz7y6pbB5jHWga4joy/kNiQT/peTlMlHHj6C6WTFnWEtQiBDIZfCtDJQrCaEoaFvoFX6uEMcP6zFjPyyTVlUP6qRCOoVEG4l4m/+eBOP6KKbCHk7dmYewMPxJXdQRyd7B3yil0/EZWX56tqjbK+D+8kBBrbLBfXWH0sWrgoouynPyBQPp3VDxJ8qKtGF0hYsd8fyC3BkbzllY4gGwND1zWuJa4NmFnNp+hhI1jAlKxDUvjMb5kXGmTrCI8aH+dfG1sIU0SsUsQzmsEH9puRisFxT+2fY0lWHpNZTcYcDnXZjGwTl7VCKTvE+CwX0p3iJSyks5qV6UQy1EdgGFsTLZ1kyz2Ahpw8dqHfRMuwkyXPacKM855gx/+JW4M6WSkxkxZ/WKKpsHL1cO5aB6tGr1KL0eIiW0aRgmbnuYWLtujvQcwpWNl2Jb5Qpbs9aFnw9Lg7kTJJWRbuUCjPVT5fUqY2bBPAzBs+QaSppQpW8J2VVtJOUyZKxV0ONLyZiV31cnU48BVvDCTIVs4X7VHSdrwAbyax9D7u2yyf9k+lX40QzQgu0YxnKWiF9HvFGmpc6sf7VTpva7fpTZNk8gqEdlFV3Rk2/8APWXi+h9JrxrYswnLlcN4toz7grDgUa2Zku0r1opEFgTO/Rh4ZQERCEHjLOhmWmmt30g9/oU+vD1iABnzi7qnzsvmKA3ggii5pnbKy9+4vYLHKYwv8L1SSTJ6ZymYVHKNMGMjPjBc8Wso0BMslpZgLDSEXPadawehEAs4rCqch6e3dUk4Y6AEh/1HBx098tLGQgubrTpmHrvRG
 ePxZIbR3
 sLST4sggmcSZCf/UC7p2lNmPqXZp1mFreieZqSCmBOgG8e9dcUfYFCZ14bAentOKVfjLw5ygZ2vm6d6qwZ8k+hBNq1O9pKIyqIecBToTkWFrKgXjmEH21758pt8csZIvBSiLrNsibudVNkI2dmFTS9qeGleBdxW5Bzwb8S7gCrr92SCk8qGapwWQopRDM4p5FROcJc5SknejaQeC0qhl4sx1SsJiH6WktBwD/029SF4uxrMjh1NRWS9clz9c6UylMNenHF5mnwzjdJ1UCdC0rU4ogF8KiY6fFVeDT9H8pLozfE5fdkXGwDULmYYNYMLBXO3TnmwXywXgfsHw7MPEKdHZpxGw/eMYIiEavUv/R0Ce2QIiSbL4W6llxeRa7IpBTUed5GfRRuKczbARxPMGX/Y4vfRXu25RdCT1jhym+pKDhejQl6iDaHT9SmwTjAKgghl9HKV8tP21rrGdgp7JSbXrJDYXHWbHiP96g45OHbRO3IJPOpWkk9xtHarSd2ji1bXyYlDI2ijoNf2zkmrTX2xntPQDW3pyVlnFEx6aa4jIzxpUbJviFOWpdcFLVhCNLIo2C
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: chenxin <chenxinxin@xiaomi.com>
---
 mm/percpu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 39e645dfd46c..651101c895ed 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1737,7 +1737,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved,
 	gfp = current_gfp_context(gfp);
 	/* whitelisted flags that can be passed to the backing allocators */
 	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
-	is_atomic = (gfp & GFP_KERNEL) != GFP_KERNEL;
+	is_atomic = !gfpflags_allow_blocking(gfp);
 	do_warn = !(gfp & __GFP_NOWARN);
 
 	/*
@@ -2237,7 +2237,12 @@ static void pcpu_balance_workfn(struct work_struct *work)
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
 
@@ -2248,6 +2253,7 @@ static void pcpu_balance_workfn(struct work_struct *work)
 
 	spin_unlock_irq(&pcpu_lock);
 	mutex_unlock(&pcpu_alloc_mutex);
+	memalloc_noio_restore(flags);
 }
 
 /**
-- 
2.50.1


