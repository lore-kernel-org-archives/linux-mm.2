Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA746606A324
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d6CFfneP
Received: by kanga.kvack.org (Postfix)
	id E7EF86B05D8; Sat, 31 Oct 2026 05:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F056B05D9; Sat, 31 Oct 2026 05:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1EB06B05DA; Sat, 31 Oct 2026 05:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 999536B05D8
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:46:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2928F1A04EC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:46:16 +0000 (UTC)
X-FDA: 85382440752.09.8C2FD34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 63EE41C0009
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:46:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6CFfneP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4sgsef0PgIF0cfrADdJuNAAJq268avrj1EIWVyDlN9A=;
	b=sHIRxMuxytevUetL92IcaHYxzcsqiwgdeAKQdD5FcRVQUrCeq7gFJtPb3UcANTLcNlWWlM
	2OrU2Cb+K52Nb+12mcvQDeY3jMA6a2S4BIizasNKaE5PJw7KoHVHG33ZxnkkYCw0I5wAJf
	/XFs11TcM8I3uTwmD0q1x77pW48gybM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6CFfneP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439974;
	b=mHbuyZd/2vPwt7e9JZvqwGmqkB3N9gAGquGAz9XsLVsh8KeNaJyUudXl2VXQ1oRtFeHK+5
	JUoXBF3luK1xortLG7m4NF40mXcbjZbWi6I48oZ/hlEulILa95gtXl/7Rb6fGMIcnWhXjG
	aI5cmHJ+/wVxZqHLbZ1IG6nJkuYvpQc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B17AA41464;
	Sat, 31 Oct 2026 09:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6136E1F000C1;
	Sat, 31 Oct 2026 09:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439973;
	bh=4sgsef0PgIF0cfrADdJuNAAJq268avrj1EIWVyDlN9A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d6CFfnePukIWxq1RflVVt4wxWBc+6vCaK03YtXkPiVGAT1MLhmGttqbCKpZC8CMv0
	 ykZG9YuZhqJBGj8aR09OSLgRuWTYMZWKwLUnOtAFD0NmRWhh/hkNYdyjvdkGrtM/HC
	 NvXMCLg235yYjJ1P9mJHTNNH7LQX4WGY6VQxjXRLERdE7L37vvhfQideQle/aO4CF2
	 rz9IJxRxQ+TD0DOdP47cmawMrJuPX8KczA2npuhKSEktnAwI/DZutaxbl1koK56PVe
	 4Qx6oqX4wL1+I/FemH+A6y6sdwfYTdtWxi7NEEoGuMBtRUXETKv8bzi+XlHEkQntS7
	 4jzXemYA3bcMA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:52 +0100
Subject: [PATCH v3 23/47] mm/userfaultfd: write-lock the VMA before waking
 waiters when unregistering
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-23-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
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
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1507; i=david@kernel.org;
 h=from:subject:message-id; bh=wm0iwUtDDosDLjqj9xBcxV65LFmKykeK8WHMHyZPLHw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs+QOvwkeiXTRJbcv69PJk23spi0JO3lV54Jugxc1
 +3fPj4R2VHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEXhkw/K8Jnfd9x5bTzUxX
 pftZNxgezJ8YN90hhLtU3enYreUr/mQwMlwUz5Tcc+IGq0Txmea3//4c6PzmP2uueYjKLiaP75X
 zrrMAAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 63EE41C0009
X-Rspam-User: 
X-Stat-Signature: gru5j88gmqtxaab8f77qjqhhojgszkc5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793439974-41362
X-HE-Meta: U2FsdGVkX1+XWP/udkuu9BckPZN9H/CaN/V+yKKg0mV9vLQnwoITBW3UdQnZ+Bw/BbNtWgKSfAQ6u1uduiI1+x1ISXFc7XkktUmXsndCnxGA7uCvFwOy9GMS6Wgx7zGjNjw79r/6ytizEqYPKXhPD5YLJRkqt3uJ3bFFEHAD+mTRtlGvfNgLPzc3/Fi/GfKDzWKwf+69GtsyYFdnTPkk+PjfKaS6u1W1wVB09E0OifKQvrXnCakTSEOS3q7Xavqp0Ay9mK/62CkYHNIfdZKPoIDHBoQts9+qYh1EKmtDCHtG7wGtwM/33yByLBN7W5C9ZedS+aZAPEVLAqrAczUjQdwMyb7qgxCA6FaLqeBOfQuLcoS9/tolfYgs8LWrnye0pJtD7PlB/16UrsKyLFAOmTL+PWdgqi31MI1q9wz22PPq6M6m3Oge9gP2kFygsYHKnxBxWa0a+u27Ux00dt2jnAlaZTJSLyZS/WFgPhuPOTPJ+/4CVqe36roGK1ExyTeqlXqwxP8807pVRh2ZGMrPUICP1BfNXosu6XwKWFWmrDloFKDKa/cHmAuy3Nx2xOW7qxkj1hHzhW1FRF1vCuxrX2oV7M8/agfHNbn6iCj9FdcJP+cOx4NJ5iTbn7CAMOKSmgyze9rO1p+6J5hrYJjT1dLMFVqqnr3S4GumECB++rumB7KQx5ukSaIu/qozl4b4FVIQeiS9mlF8ux4fX1gPIfXOPFWbnu7PxW/B9rR7+4Rwk5+qnxu6W8ajBB0Dt7bZxeXLC87szHJcttdxASXBkU+1vDQnFql2M8q4dF5W8z6uw3cYgaJlK4OPkl3FW/DVyYYdVdT/jG/niOuVnNweF/C6VB6IsCTEXSqq9EYyjXSeIcAq0xY8WJSn4qxprjqBngroMbOzHdGfdydKylrronqVqfH32haaSsAXTzDH/bm2dmrgd2JZ5DUujfrSNnm5C32rfbF7KL3VubJVDPY
 ZWQa8sHd
 NDBuoGAE8tYjQVdZpI5+l939aJmE9vcBaemDcbZaabeQll9xBqn8jBYe0aFBVA++bSd5UctHQgZ3ZH+/w2Stssw7Rb+bE6/U3qGXSe8mHNsxhzcouT9nrnNKdGmJarLmDQXmKs0ZdoaS08ao0RaIJUi6gBNnUdtWhoslaBtkBkGDeu8Q7XZG6xl19ihGsU+HgsbmT2d7HlMw9bbkFI3XTz8MQivQHs73I6sxxw7p4gByprwcPonHTV9CNEyya5jc9AnOh7BElz26OnQ1XniLmOIKWrzIDolh+zkpijwp4GG/xr65vjr51wdd2wrAem/+JI/r6DFT1Zc9h/NsIN1g7HI6FfYwfodRDwBmyxYCLnMM/664sX5g0FzIyT8wfuRAJYa4jUJEOK6VOnWAFxd1tELPZqD0uOSRir0luUtq2lohH6Yx7Fo6Fi8L4YqqEIX2EWcWe9sdLpSTpozg=
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
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 928ad95eeb2ba..3ca04b582329f 100644
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


