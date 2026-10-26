Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31F7606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=apiQEG5i
Received: by kanga.kvack.org (Postfix)
	id 45D016B05D6; Mon, 26 Oct 2026 19:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E236B05D7; Mon, 26 Oct 2026 19:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343936B05D8; Mon, 26 Oct 2026 19:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 008906B05D6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:24:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 899DDA857B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:24:51 +0000 (UTC)
X-FDA: 85366359582.07.0BAD7F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D76121C0004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:24:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=apiQEG5i;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQBYoODQ+YQypvvJ/bxf+QZV6zHatXlRhHg5nFuEkjY=;
	b=t30NfbQ7c9q9g627RR2/kP9AyKufyy116G0c/mRrtS8zC4y3KqQERfmf5QpznszDS2wQbL
	GNJJ6eGGugTddZSyLGgQLeuhI7KZaBSU4mY5ph/VNmbeqEBEc0coNCqIG3XXxmIGM+919d
	JbdcANVtBgdvxkaqc8o2d5U9bl4iv5g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057089;
	b=0FwfUjVAi6W91wRFnd60o60pa+5K07Lib7NGi9rfXZyzJvmBv/37YjaJ53kjWgST7nSjoM
	OqCbTlclbW2dZBV7bIeVx6Lho3+jYsw0xoTkZ1dGO7lUR/QV4iebNV17LdHqU+8j0j/bbX
	y1G8lz9rcCS5mrT1zkFYuu1P3ge/jGA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=apiQEG5i;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 80986601F9;
	Mon, 26 Oct 2026 23:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13A81F01828;
	Mon, 26 Oct 2026 23:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057089;
	bh=qQBYoODQ+YQypvvJ/bxf+QZV6zHatXlRhHg5nFuEkjY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=apiQEG5ikFEGzk70lvNqgcSuFbxsqv3KoY+cdbi/CXgRNvwDaThsY9M5RovpEEfFo
	 JFu4/56U0E++OV3FBySS+H1tdOulH/Xt6CCEu3CGKpMEe0mUXtqJSJP9tRS6x5AJ31
	 m+ndyvHcLpq9OAW6nIACsnOC6HrvGmJMoMlpGQYK/jThBCwuCcSKNUEAxCW5t7xDNB
	 fMVR4TiZ2J0xQ9Jvws7WPcLF4R7Nvdr7TVW1if1FFkP9Mbip4u6YJm2tr3KsE9sF6z
	 xzpiQJB5NBcKKSuheBGTIIOW8lkxwrcHd257sDU9t8MbpXu6q2KjpsZ0YlL42ux0QL
	 GAcroa840G2Qg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:42 +0100
Subject: [PATCH 22/46] mm/gup: check for overflow when converting nr_pages
 to bytes in GUP-fast
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-22-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
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
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1166; i=david@kernel.org;
 h=from:subject:message-id; bh=xmWshrb3+Xou48CaDcjPkXm82MkuoZo6NmHK5/nuQPc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35+aeTNfcdI97pS5wQm7FPTWmh1Unr01g9eJPX+Bl
 UAIt9SGjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACbCtYDhn2Fw+YTli4MZd/M1
 hdXvvvO+YDZr6cVrBREH3i/9tpjT9AfD/1Q724PTdmWLiq3IYFMDOiS8cHKfUes+/QXfD+c+fba
 OCQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D76121C0004
X-Stat-Signature: ughus1gi5pxxc7up4hd8m5pxgs33ny9z
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793057089-681345
X-HE-Meta: U2FsdGVkX1/Z5vdwhJqbFa8LWFYGE71p1OpV4RGUUwc7cbcemi7Q+wQje/yvf0nlDECDiiK7k5o5EeWitCMxHhUQSQhgG9dgmNRvT6vmAHtrInVQ8HXMn2WDfXIumSBduOQbSSFa7ex9xm9FWuSVoqpqGvn5GdAJHJuJhmn6Co35KMrSc4pEgk9BcmObIm+JOLYBeQ1NkUqc1qVXefAFZ8CWoqN25VQBE9DcMF5eiUusnoxsCXEv3YmpS/q/IkBuQ6Ahzb0/dDCw4pXI9wmkJXDWADlwNYJMPEIlz59Wg/Tdz8V61dig0cmGnNruASCxp5Iodzjcm+i3gV4HJpay/AzCzMoQQV/hPKeoOkw6RVu+zVkVwAFTVs47TTG8RxV9sxmgnkQLeTSNWXc1Dhje+R/2BC5a/+F0NisNLSvPqWyvPniMTe+k2HrrORqJCX1KZAD0l2+H7cJmzLI37iWDVr7/dQjjuEWHS+026AN1EbNUVC1yA45Tnd/wVwvUbI1BtG5BHZ9vMBTyqx6ZDF9HZCJVUxZGbqY6rckelHDMH/mpxtlPx5NQOWk4BlcNGuQZ8lZdM1t9oY7Y0JmnEQ3Kg1UwXk8ja1+z1F8QOpK6vEvqmyQyKwEE0M2ASejVGihSMXxDUjScyxzuFlAF51xDrCO9xcBpbxFBqFbwx6vMkURyAZx5UM9EvUYjyJGVpzuf1XtiatFCq2UDlZfeAY3xIDiBlFNUjqh6Ym/le0dcNVjyngDYtP0Ku8ld9gdK+bqPLjZyuOGhZbLFyCEh3k66k7SDtNe4sHdHoKLxrA4r+HpIj94EkBhXiJtz4s2hNrZIp3PMtHWGA+lVv8qTgxpOuqiFJ0rCeIzeGJvwUQhFTMHYYVdw9PF5JhI00Ghlx9wRr9Qo3vCocxk+DGxfOirdTA9KPEintf422V5RlptzIVsY07A89nEeeK6Dl3cBkbl8XC9UGS6pPRE0AaSFxgA
 pQjTBaGM
 eQ/H7W5vQ2ae99AubuBkVs24+aqYOslESciqEJs/duWzwIhhlP5YQhtXNjvebSL+Ek1weJiMme3JSTXTDE60wO6bMLpQDKRjyE0BJnKNbvxyHIwKNOk/wkSi7ZrCOijDIhXiS80QBgV//5tehMh+Kdfvg7LmAog1Ea2dafD5j2v9FM/Kz8G80IWYo6jA3+QG/HS9AOhgXiiKMuprwLUAD/Rm0hiQuQMH0TR2rJgoDWxQaUc8EyqGdrc2najpDcEWZ9Jx0S9hiu4qQw/c5pMcN8GjoTy/WWAXDpmf2Ebtdwpdz97hWHWN0uCO5reOjtYbu3Vm86YBaWkpEYvxcVp6IfqeyA5CM39MWNp0IQW5KLStx7rQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The overflow check in gup_fast_fallback() only covers the addition to
start. The preceding nr_pages << PAGE_SHIFT can already have truncated
the length on 32bit.

Users such as RapidIO's rio_dma_transfer() can derive such page counts
from a 64-bit userspace length.

Let's just check_shl_overflow() to reject any such overflow with
-EOVERFLOW early.

Fixes: c28b1fc70390 ("mm/gup: reorganize internal_get_user_pages_fast()")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/gup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 9906965893431..48e1bfe5ab9a9 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3214,8 +3214,8 @@ static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
 		might_lock_read(&current->mm->mmap_lock);
 
 	start = untagged_addr(start) & PAGE_MASK;
-	len = nr_pages << PAGE_SHIFT;
-	if (check_add_overflow(start, len, &end))
+	if (check_shl_overflow(nr_pages, PAGE_SHIFT, &len) ||
+	    check_add_overflow(start, len, &end))
 		return -EOVERFLOW;
 	if (end > TASK_SIZE_MAX)
 		return -EFAULT;

-- 
2.43.0


