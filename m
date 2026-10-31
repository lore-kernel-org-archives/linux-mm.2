Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD562606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Goo08VUO
Received: by kanga.kvack.org (Postfix)
	id 09DC66B05DC; Sat, 31 Oct 2026 05:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04DA76B05DD; Sat, 31 Oct 2026 05:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FA56B05DE; Sat, 31 Oct 2026 05:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5A386B05DC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:47:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D57DA08FF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:47:03 +0000 (UTC)
X-FDA: 85382442726.30.B98DE80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8E8CD140004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:47:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Goo08VUO;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNn7/nSxmNJguW2bsADoqLsPI7cv25lI/JHeobxIgIk=;
	b=mfX4XrbbdRT99s2FZ9sBcmbvjXg85hxZ4u+CEcxDgzxoIw8xF3Bw15nk+L2FRoVm0BkueA
	O2XjCMqvwL4p4zWhlxSK6utAqFV80bRLtbwITwQzn7nD31AY33IpJvfW5EYX/tg0XJEuXG
	lOTij2T1I1NhG+BcRfsa62SupR80Pbc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440021;
	b=hmzevgAC4zZ1mIQzwh7n//mZjzLvrcxQxLL47YoEEFrAXkOS1CvI7FSSRUOXqgGzmXdhz7
	+30RPzyMjmdaiW1VBajuTCylBIi+bzjOfwxqk8Mes3D8JsMDArIHU20FFVTkgjPPV0fJEK
	rjHRLkTDqMdO8ZaO3nxSE96nS38ObVY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Goo08VUO;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B0F2D43664;
	Sat, 31 Oct 2026 09:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A131F0093A;
	Sat, 31 Oct 2026 09:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440020;
	bh=gNn7/nSxmNJguW2bsADoqLsPI7cv25lI/JHeobxIgIk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Goo08VUOyTuxB+9BiU8tT1hGY7xIbPlcSmnFKYKLEns6CjMozp+42PLDwlris0Wgy
	 Epy0qZs9ruATYG7k3H09RtPnyDeTrQWjydx2A76PkzWc/HJEqku1kfq+YGHjvzgiu7
	 PVzQSIFw2G73kn0/TmY4S7YikUWi5ZjSlNlCvW8sTI4Xwv03qxL3EhI9T4GGCOuzOS
	 wqesxAZme6fwCbZotjvP7RH+qDfB95lIIOdkup1BldzJkCVJXYxqy9DC9vPqebcprH
	 uLdmoGd5Ixnvi0Tvgq2KahgXTyv1qFs3LN+TYfkQH8ipONbe0mXOCdtPulAg5ZVhx7
	 dsOwRYfOdSfgQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:55 +0100
Subject: [PATCH v3 26/47] mm/userfaultfd: compare exact registration modes
 before skipping
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-26-d6437171ecc3@kernel.org>
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
 stable@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1520; i=david@kernel.org;
 h=from:subject:message-id; bh=VPLF7ZF60P6QZsc5ogJFtB1G0DgMIn6ux/cdpuH/iTQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs/ojGKyT+C9PCWZu/jAdn/xR/eWdutsjRLU8tn3S
 GhxtmtcRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABNZIMzwV1CyVabwyaF8oQum
 Z0+LdgcvbTw/7Wih/MHrHFWK3NvDDzD8Ffi01Oet/XuBJXyLvH7pvd019+vmjPjl/i3pgnKt0x3
 OsgMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8E8CD140004
X-Stat-Signature: bcx98mtciybnr5e53e4ht9a636jzddfb
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793440021-845273
X-HE-Meta: U2FsdGVkX1/cCkBxkvi/ZtU6hTEA0t+IyvBfvO/lAYHteCY8i4GcaViIL2YdqKypy61h92OmrXJWmGb7UrtR4zPDP9QNCg47g4tBE1YgjttaZ4vtcGFJjeMRFep5QFJq2HcycC213QgOp6hGou55iXX5seXMnSgVtzfCWOjTdUHoxiUfYD23KD9rQTalB13yBeJCDbdaMDLxrtqH8l/F290JZamMUEqOx2ToDIl/ld9KBbFji5LhzJUioFzCoi7y+CM2sHroSipXcLFILoKknyxPZEXnFyER/TysCbkgGrdybBI7IJVwMpFMmzgBL8qu4pdm43717TQssh60CKua450/aTn2hfc/+3OgDFnP9BE/qe0mIcYbSvZ7dQftlJiQxtuYGuTUCqxYZhUhEgoL88zPKkeZKRofrKh0oq6XY1T2u6poSfY8nRv7AFcmFY1PBRfnEsVQYUnKSsdq9bVv6Q98IWPShYSVOoKX5qixThhZvry97dqjlBiQ3FkU/WtYUX2CV4DZCvCnESapNiOde+IQJJRiRkhE7wQS/SjowFvI0p7x7sioHuH2HnjaTKcKOKb4KnMqatn0nJY0FOVXUV5JcrAUtBN33vr5yOoKBtosD8L4O+ZxLPltP1SsJWmZmghGLEMlW5HOgXts43vg2lqN4lrjkNVdp2ZXyzoYEZ6T/TpCDnU+prDdHq4r22Q7MLAmdIK2YDtVhj2fnbuQFvoX1z9ZxJChxwJV0sL0h7DqfoqpMilHVqagFqe/f77nUTe55NKCnHgTqltv/NN93YPsg5gJVlP24mejd57Ks5x0UHkvRRlhVjmd3ykDyxTWjrarO+IMvg+z49wv0qNEajwgqG7BxGL2Y6JZQavNebX/TeKkfamMBdFSRPBK0EnBD1V+DDzQwjxdgYhjaoP02C6LNOT9hKUps9yAwvOLCjV5iDdt3N8FZUrQWocE1cQ8G9K4hM0vrnl27dWLBIc
 Bv+h7vid
 ZgaRDdfR974NTIkif9wCMSjw+p7TqV7QkXnoednaYBQzAw4UZTu9jTdSfwDt2E0Y92sltEGJq4EgcFDUl3qB9cwFejF1TWsZNHIbY9pnPL0uaYiGTDZPm1KXKXppiYjQoJU3LmO3MTZfdBAAWWpvrFtQrpIh1svvkUi5pwSURkxi0Q+STim+N/M+sJYbpYbypGD0SRtvNgKr3InP6YE+LcZ04JBQ8rRX6L8PSvXahwCdUxvN09ISGjXte0jJuPaf5vYU5PKn2pQ55acR5SXT43HpVsiRDvdkgqqg1vGczndThBq7mQgZTT/xZnOHEas4fIAW8zzSmrmizeiKnNLFV1ovAAa7dP7B5QeKfuus2cAfxE27ekM5D+y8/A/1xD4g7wqHA7mUQ5pvupBEcS05w3lmM7h9qQFOwmvnmEjs7h7ZLuFldSkARob8u3p4uZT3YMHTEIRYbvKB/zwMPLWJloF/AnmVasqdGkGXAe5rl/qCISXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Gregory Price <gourry@gourry.net>

Changing registration from MISSING|WP to WP returns success but leaves
MISSING enabled. The no-op check sees that WP is already set and skips
the update, so later accesses to missing pages still wait for userspace.

Skip the update only when the current and requested UFFD modes match
exactly.

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: apply fixup from Lorenzo ]
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 03f1b15bfe63e..dac696bda19f0 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2291,6 +2291,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 
 	for_each_vma_range(vmi, vma, end) {
 		const bool any_mode_removed = vma->vm_flags & __VM_UFFD_FLAGS & ~vm_flags;
+		const vma_flags_t curr_vma_flags = vma_flags_and_mask(&vma->flags, __VMA_UFFD_FLAGS);
 
 		cond_resched();
 
@@ -2304,7 +2305,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    vma_test_all_mask(vma, vma_flags))
+		    vma_flags_same_pair(&curr_vma_flags, &vma_flags))
 			goto skip;
 
 		/*

-- 
2.43.0


