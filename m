Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77065606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kz2AvSL8
Received: by kanga.kvack.org (Postfix)
	id 8FF036B05D4; Thu, 29 Oct 2026 16:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6D16B05D5; Thu, 29 Oct 2026 16:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6C06B05D6; Thu, 29 Oct 2026 16:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DDCC6B05D4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:39:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8C02802A0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:39:11 +0000 (UTC)
X-FDA: 85376828502.16.84FDB6B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 39E5BC0008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:39:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kz2AvSL8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zVfPl9MgmcK9sfU4MC+6S2mU4/7MWZEGtGJA+Gf+TwM=;
	b=fDEGcD0ICLHRXAOBN4Qt1MGNLPIFjLTqhTM18oBstmbTDln2XD3du0gyqftsQYNlcl8WMt
	qIJk2oNku6H/J6jyKdC+HcvWFcTSeKPoDWTrZG9mpHdgvbMdbygqRV4RN8qa+ePA2KyINi
	w8PHdw+rMqx9CCbsW0NCdTMMEJ94DUc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kz2AvSL8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306350;
	b=sODO1aO/RUGmGTXBmtbjBW3vOKvT5+5ujlNqm0BdwMqr12Qaqy+L0SkYX3ZQPbJ+ZPNfIL
	gSy/wRgqfhCUgHRe4IAo69oaHUqw9XWPhNVh6c6AFwIB298S5neiFrNNVwI+9zNPAqVP22
	KWpGULF1U4NFBHlhmchwjnAr2C2sRlU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A69C6605CA;
	Thu, 29 Oct 2026 20:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2931F01816;
	Thu, 29 Oct 2026 20:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306349;
	bh=zVfPl9MgmcK9sfU4MC+6S2mU4/7MWZEGtGJA+Gf+TwM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kz2AvSL81IHV86Y6xy2E2U1XsKVedZLudNnrvAi3R6LwSOiwulMVFEkdVCzj4b8mv
	 cJ/ZZkh2/Qx6UTpNE9wJoAwwaFh0wJfMLmQ0UiYfsRcVlWXuz1oEdtl2LTA6ma+W5x
	 3G1d5jMl2VufXF/QWz5sAP0Jlxt6/O4yznwAno24YQ7K4D9RBffWJ2vgS8qltPFrTW
	 3YgpmX34se9pgvw5ePx/p+4vJRq/wFoerwCOuFB1DR0jPYIlQXh2pB8yM2wDRftfk3
	 hBeJr9FkYgsni8V/+/N91Qkn21XvQjId4eyK8MYKS0mxlR97xpOYo7FctBaQluZQ+I
	 ZdiJ2oJGbuUng==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:18 +0100
Subject: [PATCH v2 23/47] mm/userfaultfd: write-lock the VMA before waking
 waiters when unregistering
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-23-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1450; i=david@kernel.org;
 h=from:subject:message-id; bh=sxKVqTRFf7nv8Rk2AxGSEpTSCRWGcpA8V6JR+zulqqE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer21/Yxakd+CiyJNQ2zmOll9uxhntdKtc5rXnK8v9R
 bvilHO3dpSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRU5MZGZpnb8kptntYn2z6
 juHxPK+NosJMz3KrSvRVGLyezRR/d5mR4eqGdRYB9WncadsXKvz9e8UqQCpxh9x/Pre6y5vCz0x
 2ZQAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 39E5BC0008
X-Stat-Signature: ryn1xcdq9gqufjoq4a8jhfg5kq416utx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306350-161082
X-HE-Meta: U2FsdGVkX1+Vaa+Qt3ZC7rBTy0GI+t4X/1ddsDjtncsa5oa57r+J2RT7ZJf/ueaTFl/c1rEcgRVFtrZOJ1HOoZcQryjEJnoPpN0q01ezQxOLJfa1BWAdNX8mdV6a825GaqS/Qv/HXHJ6rU9YBCyUBCDl0imakp3UjL2xZQBVpZ/LRWxGMX5NHgyVFQhbLXVJvnTf3mTFlts8z+SDStl2ReQ6afAitmFJhlczNq/D/mIBsBHPHcUKq2xPNwwinWYssoPToEpxjBzUQR/juoLnz6ZWlThtQFuIdaflhczIwkBHqrcmcKcrMR+/Iw82GYoGQyvvunSVWzmIkxKgskmY8YLZVZAD8aTfyUfGd5Yw2umvFxBQGjreQ+0LGZxxs2k16KM9/Q7HZN8DkWIsVzRd9y9S5PqfMLb0lp4pgzRcg194LOYWytoZmV6US5aRIfBb4ufIaSBr85XWBwVruedeHUw+bWJUbP6/ifheg1gUM9TsXOfjjBBpvqbahYAUOWtyeLWaCT1Lv9m5cLL+6sVmVeW5B8ZvmVGQgNkJigH8jKPPjC2znOeW8EhfgIgK4S4CSRoPe5oqQVQHWJqnEvvDbtOwI6c1+vPkwK9n3OxIskr86fgQw1kjFNPTfMmKY99ADHY98zV8WYX4f1+peulqgvu2UEX94LEZ8WYJ0KYXpiZvBXcqg+8li5GG8lZrCpSWf+wlxZPdGDX/sWszH7ro5Agfk7oNP6L9jb7O1KreYySijmnp8yve3KTDUeRxPbRTsd+NyWm22xfMjTiHw3BV6mwEDALKES963pGpXdn1Xh2glaPeWKyQPJisE+dGl5hbr2wQT/r1FbB95T6UXo7ZsSGk/yELBblfhLjm91L5MWdreyDSL7OSdvzUq5BBlgZ6ZbwRbudrKsnho7x2M4Xv7UDupmexU192ENKiEaxwbZ60jDFv5xYQD+/WNhHwSNCwqA9Tbj7MqBxN+tUBRD0
 v1YOq+mX
 lNFkcew/FDEsBmBniyNRDUElUhzi8PfcibyPu5BsuqL+0nSUKaJ0YgG8jV2cIP2zb/MuonH01ZS/dZCOR02TfIC2T5qREJTl7YP3wZoVrUrX2yn0Pc4LoKKREr4rd/LNiMWHfeN5wdYiyiARpWvCtWmjHsCov0sV1CKhW9CF9wZGN3e8bfD4AI1h7IFAURd5+8PvFpNDMuyMj6Gm0j0CV7LKT2f57yW6Tna4Dv7U6cf9c5ljw8RZWqn2rYcsTCuRJ92hUAtmyB+B3W+NMHlWIJ7GIrxXEdYca8AUemZkJZ/w0TYbJ6MgJBVca6gWd3FqGc08Z1Qzg4Gw7zPQvw74p/z29tDns0eeJjAGNUdrb1dkt2rlNXsOsKcWoe6OY54Zqrv8dBRZmvpcEvU+iPQMDYTkQlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

userfaultfd_unregister() wakes pending missing faults before clearing the
VMA's userfaultfd registration. With per-VMA fault locking, holding
mmap_lock for write does not prevent another fault from queuing after
the wakeup but before userfaultfd_clear_vma() write-locks the VMA. That
waiter can then remain asleep indefinitely.

Call vma_start_write() before waking waiters. Existing fault handlers
queue themselves before dropping the VMA read lock, and new readers are
excluded until mmap_write_unlock().

Fixes: 29a22b9e08d7 ("mm: handle userfaults under VMA lock")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 928ad95eeb2b..3ca04b582329 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -3991,6 +3991,9 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 			start = vma->vm_start;
 		vma_end = min(end, vma->vm_end);
 
+		/* Prevent new userfaults from being queued after the wakeup. */
+		vma_start_write(vma);
+
 		if (userfaultfd_missing(vma)) {
 			/*
 			 * Wake any concurrent pending userfault while

-- 
2.43.0


