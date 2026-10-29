Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CAA160A2609
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ISvCpW1n
Received: by kanga.kvack.org (Postfix)
	id 252C46B05D1; Thu, 29 Oct 2026 16:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229F06B05D3; Thu, 29 Oct 2026 16:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140CE6B05F5; Thu, 29 Oct 2026 16:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7EDA6B05D1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:44:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76C8C160313
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:44:22 +0000 (UTC)
X-FDA: 85376841564.12.517555D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id BDFF14000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:44:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ISvCpW1n;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f99FBG9cmwfw/aEnFPXgwYaEgH0mqzP7LaMxLWErvlM=;
	b=cexm4NalM6SCaKDWH7+VKe7shqWFrJtCO4jzs/Y5OpEJ1bpVLXTwGvLGmCuK5lYQ1UeZN/
	R6jFjqHkuH8dgudrHHU0XcKyAK7AfMOYBiTpGO1fvETt2Inf0H4wotdhnP3VOc5oQZFAi7
	tDleAex+JClDplOjNinCekBRcbOIBlk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306660;
	b=xydzeZwaAObN26E79U9SxkT8OmFCSRsYpQ8Y/cgpy2h0M1TMhqSxrZVD9HgjJyCxqjq0hK
	58S4forJP3mLkWZ7MNER80OxCLKf6DY0QVhGA/YQKbK9HtGjoUR2ditmlq8MS8iPgbcA+A
	ZvuZI0dWWx95HxQ1+YfByMCVZ8sFCao=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ISvCpW1n;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FCB7601EE;
	Thu, 29 Oct 2026 20:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EBC1F01816;
	Thu, 29 Oct 2026 20:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306660;
	bh=f99FBG9cmwfw/aEnFPXgwYaEgH0mqzP7LaMxLWErvlM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ISvCpW1noMZ/QA9Jr4U4ciYvPBlggN3Z+6JfPPsgt7+DBM//0I+sSMG7BKDe4mOYJ
	 0LzS18/0vo2MIyIc1gbIO4QitWdoMYUlqgluemT6WVI5mMdz1prqImIRZLHagRYJPl
	 APjbqHJGcwwUeuXSaijEVSo7Ic8ccUPMCoJrbjRImpYt3b1GIpeOsoLwSbcKWxWMBE
	 ImzDkrq/DeJ6vMi5OW4WJWRj+jRdW1Nm5Ct5iDGzqfdhTgeO72u6sQV4AW0hawlICs
	 itcUaU3Clq0Apdq2pQxRfxTHxoFtftXWanHxoliGkrRBX9nEQXTMchpzwz3AWsjlCH
	 Kcs9Gjc6eZC6w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:39 +0100
Subject: [PATCH v2 44/47] mm/vma: don't leak the charge for stack growth
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-44-a64ce7f83abb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1286; i=david@kernel.org;
 h=from:subject:message-id; bh=o0mheINR978z1uD1ZHGsTx1VSvH13fE2UEr82UlnsHQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+36aHqh4IJVheeK896X0nMzPQ/Pi5JZtIppO0NnM
 HNBz/a2jlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACYi68XI8EL/YelpBxn2YMEy
 +RgRwdSk2d/+utfpP5UtN9XV+bL/IMP/sMpy4djuF7d6rH8c1XGs5FY9Uao3xdh947d5D4VsGSb
 xAQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BDFF14000C
X-Stat-Signature: qeow4wqqmfhjhz1zfqjd8cxxpq6jzu4f
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793306660-82141
X-HE-Meta: U2FsdGVkX1/ZR70kYOH8HORpHwj2RlQkAr3nXx1dJOouKxH72YJP/9WML/W07PP1jgsDGQC4Ym+v+6Yl7MBtCEWAlKIuMC1LEkPI8VSv1AQgMENbfXKQXgw2Xq2gZoW56dYDWx2r+PqXJWsl8xS9mAAY3ugjtPC/zT7YQlQw5q+cntHasYXdtHsZm0dmTN3LuupWfO+IsTbdx3AX0BgE3GdjsKqcSBF93gC9RgTLSb0lniq3B/Pbp33rItJFK2x16dNpGQgVCdsI3CPQTYYq4T2SRm3pIYj/Qu/fEdcOEtvd6S6YGYzCwsHwMSjdYmuL+Wyg3q8RwRTuTL5MEWFX2i0Nc3NxWPOR744PK+f4jYnarBjdAmZhgJ7myPX4sMNcWNB4oW79A+GTKcfR8hS0PZoib+3vpb1BMUp5rg/Xlzjyt3uztt+QJIXNgPhNE6eOBQOp1L1vinGL+YgV/IWCEvfNq/114tARVMzc636aLPew979JGeFx5O9Scjqfcv8RW3bYdqGjxalNWUuVBIXrFVcFHlcaIH29O9o8aDSnRpS3n041NFTzKjOqV1LF6ZChJtrvSbBvPXO/QpJUCEAVb55vG6521f3/5Fg9+pp6OvhXBzy+qnJg2rmRINiNcZytiZgVHy6rh63Ld2WOM1K55y+FifrlWE3l1rxR1/408FklxWuK0y6QNVaxJVagSzncS1x+BanXozWiTuqYEFZwQEYuOtZ1+yozu9ptVr7soIZLJos9I8leTU34MbrW0dqJ6ZCd8R14wwYdmQ7OySBC10Bd0LoVDanioBUQiLt37FR2gEaPJanFr9fi59rL/vITM4dD29yW00W29wFKdqBCgh1juMhufFS5ka2QfJFj4ygtcTxw3GeYzVuBecVSY/d6oFQXI8gM9G+RfTKu1yshxB9pSORkB2GEjFBW6SShYjFNgoa2qKS34qCzRLFVtZklAKbNyNiIjjC4JeY/E2W
 dTv2EVMd
 FibZ+A/7hIiGecfMVPoKCo+iZtNcTSOwwFa4ns3P/u2AxVt0P25vtTAzC0GYsiRS8n7l3KzuDlmpaN4NSqjNh26N/mAvEr+quitWeaGbaO94ueROdSePjLYWWJslXlZ4qI4ET6VwlLvIygyw5/m4BcQcG0p7TImGeRqnOxe06yQjq+33TPsAyYlLECuf72vr5rGnUoxzosHhLbaM4cT17+YcxTKlZGdh9eWWSMjRBgWyOxSubAqRp4mnA23WNc5cGpGXvTqNs2QMTFS7tY1XhQBH0MprOlHCDMTkEv2/0VhKvNGP9ZnWYhjUYFsSzDGTX51xQzbP+Erf+Y5NMHIjuIltUXZvqJoJ6HVDS3Czpr/1YBAl/ewtg/IAaP6q8VsPIFCvU
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/vma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vma.c b/mm/vma.c
index acdf00346cda..695d0be85ac8 100644
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


