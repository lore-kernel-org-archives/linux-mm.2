Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEFD8CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 09:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EE658E0015; Mon, 17 Nov 2025 04:36:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09F288E0002; Mon, 17 Nov 2025 04:36:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1DE38E0015; Mon, 17 Nov 2025 04:36:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E17C28E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 04:36:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F49313C297
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:36:34 +0000 (UTC)
X-FDA: 84119593908.12.F879B65
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8459780011
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:36:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FpxaDXUa;
	spf=pass (imf02.hostedemail.com: domain of mambaxin@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=mambaxin@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763372192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=riSKGNhSBuzjqm2tTvzWCi5vuUvvezhD9OfBXJt03xg=;
	b=FbSnYW7I4/EjAyB5StAgVS1pJjFagpfIIfsLqJCIWPdkjcgV6F4kmkyvrbnPSLlt2N0BbL
	iSkNjsRwEQqfWRH3S4QyjBbzMP7sUGlon77n6IF3KeIpvE2CLuhlVPrmjPSxtALD6+Grcf
	fSAvJF0j5xasWvIttCUymaNQFFfTzwM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FpxaDXUa;
	spf=pass (imf02.hostedemail.com: domain of mambaxin@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=mambaxin@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763372192; a=rsa-sha256;
	cv=none;
	b=6/nuVqHmj1WGL4xYtredZx3xP0GiMHGb8juElYfzmi1lgE2jU4epn15bK+gYUT0r+3Xphx
	TnD/V6+YClm23s0RwtSvcgN2rj2LgbMnEEY9aDwZ1t805vK2kDF02mECis7itGIoJbdDXL
	VI0zxo9gxhDKaFthgxfOYPjjEx2BrUU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ri
	SKGNhSBuzjqm2tTvzWCi5vuUvvezhD9OfBXJt03xg=; b=FpxaDXUaRHsb7OzkD9
	ed2j7X/o5tRH4+2o6lqeOOKjLU6iAH3hoG6Nxo3ujs5Si7HYmyN79/W3QB5F7JEF
	/GSkOnDS+jVURvR0Eu5gW5LDJFojHuvIAO4WRgDmToXr9F1aCoLVJy8E4RNVZRBb
	o/D/DqLsmvs/p4eunxjyw45zg=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wB3_I2L7Bpp20_mAg--.41016S3;
	Mon, 17 Nov 2025 17:36:13 +0800 (CST)
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
Subject: [PATCH 6.12.y] mm, percpu: do not consider sleepable allocations atomic
Date: Mon, 17 Nov 2025 17:36:04 +0800
Message-ID: <20251117093604.551707-1-mambaxin@163.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB3_I2L7Bpp20_mAg--.41016S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxGryrXFy3KrW7urW7GFWfXwb_yoW5KFW5pF
	ZYg3W0vFZ5Xr93Ww1qva1Igw4Ygw4rWFW8GwnxWw18Zrs8Jr1jgr92ya4YqFy8WF90vF1Y
	vrZ0qF9aqayjya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j0g4fUUUUU=
X-Originating-IP: [153.3.251.212]
X-CM-SenderInfo: xpdputx0lqqiywtou0bp/xtbCwQ4-SWka7I4nSQAA3G
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8459780011
X-Stat-Signature: droyjpj54cn6kh1wgu4bdj7zsbjmqhxh
X-Rspam-User: 
X-HE-Tag: 1763372191-333665
X-HE-Meta: U2FsdGVkX191bNJsouyWlyBQ73azkGkZeC46V7oZ3XaNe98hAy3jIF7jNi7FOtT/2Ivu+NhrA9QS8Wh53EHdsgFuDkSSmR7T/Q2l2XGq6mJBHgm9vInmhx0OeyhwxaN4G3Hze7VrYTQRRMDzt1QkfErPGhLylcy47089e/tWUzr7F8GP8Dhggp/VfZGrXZyO36qTsWcK6emXCbM2nm2RmM6JXL2Fgf8Nj2YnQx+Qt326NLOs4MpHdJRJgsHBm0+rVca/XBXCpOnnFpLke2B67M96dMSGbfIchTjXznMHlrpprDR86rNK+iW+gy5VZrQNRN4GSzL1n5zvk+6aGbfHEjfw1JOEXvMZog878yOL4BArGIaRsY4qevTgECW5DRc3iBdrc01QjNM4+Q3cOZ82oDyPBemr18BwZ6ep/wnVk3YjFVk2DhiyO0ZtdbpnCFuLGDeBH21KLVp/Bx+0e7oXdCqRHC3q+ZOfwKEJkiB2VKmysdUkP2NFxxEnXkT3WSMyeIqvl+a6HKLCgRZww8xndI2EIoCr2FvGwD4kxu2zSNhJxluq0Dm5PJaAb3kh/Zk5c8dZnaDfqWflkDa0CrVg3xxxq3tkHIqswwQGHdr/vNacfqNY6NRzuvUFPfnVfIT1Z8K8y/FY3PEmaG2NBVu4BTdJ0GEzazufW79QQ5rMKxharpmH41SxQVmx0ghGj8C5TVamdbrT3XtkNsNwFZyPdaWgJtoPeaKP8QTBSjKFj7JvTWR+xMgJMivuG7wHhJE+qsp3Aegloncwv3aVcgz41syfb1bgbgl2g3eMVs+cB7AoTIY/LW9k0QnrvWYOuyoFdxsUbsnaoabeCQZROhBEU5aCFA4IxgElBrygdXUcfJCGKYbv88btKbSUE3feFzBp+oq6rd6MSQvusQBf6SZ+bxm7fqsybt6ws7KX4IVkzPziFXdieGDSB1ubHmoZ056QKRvg9s9x0iwhrAUm9YW
 IhMJ5tmF
 o9DfXNXtEdXnNmtXGdehcCxUBQanEDYbGmo2jL2ulfLwatq0y811r0KHqFu0GSW/RPqaC+Ru5JgQtP9Zc/wOPoIlpKyRsuF13jvbvG/MtLDCPiKSsketwNJzgIeTks6q97QsDWSUWEe8ja3liJZXsI3N04RtdSOUccDSmBKO/GtbLi17HhIun/EsgiQfyS4nvOGEutbwnka5JchcObKwKjCKYLGgBmQE+39QBdMhly6byJH5FiHJxBzGuwtz9OzKogouTD18TCjYbR4qhMOEpIaQNbZFfZ7EuQlFE6Qrd93zsUVfgVFZ1lzoKQ6TAPEsxqpSNjydbjd68Y94ZM4Fac2CB9zdC7ZGmUZCjDpAScNKoUcbAZeSADAbc15HjPE6YqUPb8cdWem8Zsu9unExVQBkl2XHNc7bPzTCArkP73OImaO0bcGB2K6VC/l/7QolcBmMNHz4T26qnmUv6s3UZ2/5Sk/bKBCG9wruZKaZPNXVn1UH5HaAzDmLaxTUIynRc0+HESSiYKMjs5mTKFFTkkA2FKb0HbXQ/CxqtTD62XnAjG0eGf8Lcu5778WslQYo7iT3ieJ7dYr/o/j8=
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
index fb0307723da6..44764720b6d8 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1758,7 +1758,7 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 	gfp = current_gfp_context(gfp);
 	/* whitelisted flags that can be passed to the backing allocators */
 	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
-	is_atomic = (gfp & GFP_KERNEL) != GFP_KERNEL;
+	is_atomic = !gfpflags_allow_blocking(gfp);
 	do_warn = !(gfp & __GFP_NOWARN);
 
 	/*
@@ -2203,7 +2203,12 @@ static void pcpu_balance_workfn(struct work_struct *work)
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
 
@@ -2214,6 +2219,7 @@ static void pcpu_balance_workfn(struct work_struct *work)
 
 	spin_unlock_irq(&pcpu_lock);
 	mutex_unlock(&pcpu_alloc_mutex);
+	memalloc_noio_restore(flags);
 }
 
 /**
-- 
2.50.1


