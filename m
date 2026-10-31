Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74CD8606A323
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TJMD5efz
Received: by kanga.kvack.org (Postfix)
	id 710096B05F4; Sat, 31 Oct 2026 05:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7726B05F5; Sat, 31 Oct 2026 05:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AFD26B05F6; Sat, 31 Oct 2026 05:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C88A6B05F4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:51:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7711A08FF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:51:44 +0000 (UTC)
X-FDA: 85382454528.24.18402DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id EF2AD180004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:51:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TJMD5efz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/pp7BZen6g6ZjSOvHMxJEmd8Vj24oFI7u7jvugD7NkE=;
	b=8ZZFirRjmDEYW1N9Cw2D/B18xAIjswhr5wegdrhZ6/2ZWHssYOjhpCABtv7PwTFAGychQP
	1hicW7t3s3yH16tF2DrK3EXbHzaHBbTGDRg/BzJ3kAUdI/zdRpklSOJrnBC2EwhQ/xiXmD
	GXjZUKpgi0Jol4QrUm+p3wuOXyuUa8E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TJMD5efz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440303;
	b=WXX+JJdpWYdsfePUdm8ul2SDdIks++wTw1WotXcCdhoAnyB+8XMQBy/uEygmikABDHj0Im
	rqEfJwtkf0sxx3w48rDrxogh3nVA4vq+0Iw8U2UAfHlBOOPkfKyInDT1b7x0hn4kG1Tnq6
	RL2Ea3/cZuZPpJTWUkObIplc4uz2mDQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78703600C8;
	Sat, 31 Oct 2026 09:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6853F1F00919;
	Sat, 31 Oct 2026 09:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440302;
	bh=/pp7BZen6g6ZjSOvHMxJEmd8Vj24oFI7u7jvugD7NkE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TJMD5efzjo4MGr3Uznn4+DxGJ2LTsbfx/ixDORmcgblTHIc68BYMwsNK6C6VWarFo
	 VfGxg4J667C0pUzinEZwWnLhOacuZCEJq2ulYqBUnj90/yzWCfZHwxpSUiv+LhkUiG
	 2g+RQFhd0JaIpZDnVyTCNCRiqXE+WZm+2RQpFaDQFuZ1Dce2O0g8gW1CyyXRvHw9ir
	 /HwHDBTfRFw4DkC+sW/RAKJJEwJNZmhRHjRY+XKqD2hoRW3BP9261rOH7GeSD2JvM8
	 +qDHXnKc4uHO1cLUJhbjLE+cMq8WjoOTsw+9Y0WcbG28rxC/xGwj3mDwdrQ65IPoc+
	 LKTDSrnbIvsuA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:40:13 +0100
Subject: [PATCH v3 44/47] mm/vma: don't leak the charge for stack growth
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-44-d6437171ecc3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1343; i=david@kernel.org;
 h=from:subject:message-id; bh=8bDRWBq3PVps+Kl5GQHMx97Trak1vEreOi5AJf6aDXw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs+e6Fb6o77Y2kyxI9fh098PPTsYn8Ve/y33csXEs
 1FH51kpdJSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRGAVGhj3r1iW0ddxJ5Ax4
 szRZOe4ld4W8pr/US231ved7Wr4ozmdk6PnH0vQldb1U8doXllndroefxJw0c2G/8qFHUoSLde8
 CJgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: EF2AD180004
X-Rspam-User: 
X-Stat-Signature: ftfar6tx59h9zatwsz6h5zzbqdji7ahy
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793440302-442064
X-HE-Meta: U2FsdGVkX1/6Jh/YWso/QzbUjC7Hf6bPSNp1iJ4XAGU7kuZ0p9iyJkXZNrNgUAdHlAu/eIa+pDi1eEivw3JOZF6mPFXFstrYZxxwz5+XPxOPMMeM5lgpeuCHSUcJ6jB0RNf5o6IVE3GLmJLzwyXDItARPH6KNqasDST2SNZcFiPaqgcDAvSavDchNXbSCQsUjNPXeQ9EAaGCW59Y3GTLfDCDFnc+nAbFhCvk/uew8+oI4bQH2JRgg3jnOobgCSN2ihXA2xfjbDGk1RhucbXyOreapLQ7wcqj6RyiDXAtIYhs+WfHGDrHgkoNjWpoMh0QIJejV7iJX5fY3hMiz/OZLYyP+EVrWH1k76Ywqb7/Dwtv1p5gbW/Aalpgh3iZw3wiZ1GrcdcjJPvMeQ0yBwWaGVV1qWYRTe1vswSZgUaiM0mcQNjiiBoDdMABQQcDuAdS1xNtRI8WP0oaExLxANj3uA3apNXSS7kKgnLFWvWspZRVVaU3WR9F891b2hTZp4h6gQ8S504dckRrNai/buCf9/M+teGZE/ztgzNJQ02NUyZnLctH6Hpv6Ed0MH9xcMiuv6OXCSHfncMF/Yzdi+09IcGMLeaoANYOURyepxVxig/sRKBINhxrdd7NiZtKQodaYUZxVyv778CBn6cqr1ypCZydg9mKPPHLo1+oglvwbGsbb7ycMgiOwU1EwU4evy+qzy/yB/NL6IPoLThpTK7DRoJ7hmC54XM/Ia+va+cnXVwuTx4HKCdqeaf8xBF4gOCgxOEz3CmjIi4u7NGlKQsm9p3ZTlFcnHd7nspvmLdtSQuZqVQkfKB1ClNtX5UoZTp2woG3NWObFMW3d9W5kEiFo2GT9+lm3tNTXQWm7cnNuwhxCUkC4L8fmTsr1EbZ4ls18XT+OjzxRww9wj6bEMKnKRxWNLPf5bHUFcv5PDqONyu3YOV4m29zXdMpH8XZeI9VsZULaPHGdHeeIY9UBXp
 1F137t5X
 r4NJ7R5huLjnGbrSgEHWPQQZ/SswIIsKUbcb0XtY1VMDjPY6ejqAnH17TYnfGZZn+A68O9xqkfBTs+R0iqErDkWZ19eHWOHKsPMdwvsN73LwC7V6N0f45bi1Vxx54hWUfZraRnKW53PvdPOVs2q1u5tQHE+Uh5Oe2GVZGwHAJDWXaEwzWZOg5Z8wEA9Tc+fgIzu+YosuwJKwfBlzy4pHOdXQuC2etDoJqLnw22/ArkZy2Jd4fk5Z3nTSG744b3HdVjfNHP4hYRue0iqwweDyHEeHPsMLGFTIK19dIsm4fXFb5cO2hn1ePUzHnKiCTHxVOUm0DOXRcoqzsiDDZM/73HhyVf2JydMZHaTdBhNyezqaxrDk2ZW/u+s/7iz6rxcXHEBZrB3QsYLsmULBzUz6aTwIyFB8jIzrf+ROV42mPvvDvRTycbfz+Ybsgpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

acct_stack_growth() charges stack expansion even without VM_ACCOUNT.
This can happen for read-only or MAP_NORESERVE mappings created with
MAP_GROWSDOWN. Unmapping these VMAs does not release the charge, leaking
Committed_AS.

Only check and charge growth for VM_ACCOUNT VMAs, matching mremap().
Unaccounted growth skips the overcommit check while remaining subject
to the other stack-growth limits.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/vma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vma.c b/mm/vma.c
index acdf00346cda5..695d0be85ac86 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3391,7 +3391,8 @@ static int acct_stack_growth(struct vm_area_struct *vma,
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory_mm(mm, grow))
+	if (vma_test(vma, VMA_ACCOUNT_BIT) &&
+	    security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	return 0;

-- 
2.43.0


