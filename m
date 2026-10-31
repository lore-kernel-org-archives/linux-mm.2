Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0810606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WyYl5dm5
Received: by kanga.kvack.org (Postfix)
	id 9A0E96B05DF; Sat, 31 Oct 2026 05:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951246B05E0; Sat, 31 Oct 2026 05:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842CA6B05E1; Sat, 31 Oct 2026 05:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F2476B05DF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:48:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F3B2980899
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:48:05 +0000 (UTC)
X-FDA: 85382445330.27.A0B1C39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2DA11100002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:48:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WyYl5dm5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRdxulna6bx7ZoXAJZWTtTOwXgwkKcXU1p7Oe42EAqo=;
	b=ca/BMR5lhmG0S3I2VE2A8/erL52HAewzF+XDQ7fx3CXiKGbfv3ZxE5rQPE4ieHHH+I3/tq
	mvOeYJFz3inOEN3gcVZYFRgSb5RGSQUa8ZA2vYcq5YGHXIMl1WKG9EZChs6iYMQY3UPn3d
	6SFKe/2ryLV9vRkFU2ueDFKgVgZkOj4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WyYl5dm5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440084;
	b=za5Z7abzuS9cZ3OUPDbgjpJWywd4anE+TasGx4OeXLzpkPveO+G6LFkrHluog34o1QnpoT
	RG61HzBzjLns84u4zsXHXfshJXgnHeIfP6YPSsJv70m4TogXJFR/vP4GANVt69RINF7ndg
	vYHbJVwqcgCk/EJFdSOrqXn5ZYEE89U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F9FF402FA;
	Sat, 31 Oct 2026 09:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC8D1F000C1;
	Sat, 31 Oct 2026 09:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440083;
	bh=oRdxulna6bx7ZoXAJZWTtTOwXgwkKcXU1p7Oe42EAqo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WyYl5dm5PLsvVySkqKWeW4aQqBeXA4uNtbZ0Q7ESvQ9tb1cE7IFM8dVmAypfFv3ew
	 pK6i+F632f1aj9HT4Cz09nw5s0O0bZ5JJgEVYKNecloJyyHAvxJPkOtixdHmgd9HpI
	 ydeZ+vEbxoT2hxdhnYJAvglbZQ+7fd+Nssi6fmiuxZu5XAOtvh4jFDcMbwsyhFvb8n
	 YJpI0mC9y4/JQpQ/d8ePl8NBnMpf+oSAr2oC2r7k6ENsJMAClBoUl5GM/DJi9h5aZw
	 jNNqW+cyjceGWw0WFsiSKjNfEmU5Ecr8h4R26sYJPRy4YQVxh2ZZdfLKPRODE8MDBn
	 YEP3nGt6vG92w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:59 +0100
Subject: [PATCH v3 30/47] mm/mremap: use pudp_huge_get_and_clear() when
 moving huge PUDs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-30-d6437171ecc3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1350; i=david@kernel.org;
 h=from:subject:message-id; bh=J+BkXcl4Qvwywi9WLcoERfpKcUUnTN7lTfE+aJlF+GQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs8s914UfNrOe/qM8PKSOwFhTJaPeWuqqvs6bhy2z
 XAoTOTvKGVhEONgkBVTZAkKvm/w8uW62mo3PmaYOaxMIEMYuDgFYCJdMowMM/5zRgrnX8krOPRu
 eabUTz+9eNN3X64U7kiNWPKmVGDhH4bfrCkLONfNlpM/71PMcqR811mPT4cj1riv3S95hPloRs0
 7dgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 2DA11100002
X-Rspam-User: 
X-Stat-Signature: hjwejq3c7rcjcqxxyogysxbixzgbkgfd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793440084-952878
X-HE-Meta: U2FsdGVkX18EgmLQ1MHBw677C0yxJn+0MFg5PlcNzE0TnPuiszdcjE9pcGQ4G4OUcHU37rKJMffOj4DbrWG59e0eliGk018k9+BEH5ns2FiYtjFSfFNy8ytcW92iTYfe6OACC8EDdMDWOsmCI8ZC1XLlP8OTRibmOyKlh/MnyDoUQkge5LKlA984JaFMkjCsgl7He4KywBww9zZiVTrt5V9jaq/gF+aSYa1ttx5baVC7ZHVhVIHG8TypGMy3FucEbQ+ES22mjQ/5bNwO+7PPxvQbdY1pIe+sia4kTRZOrYfadzs82e9nK5g+mO/WUR2F8T8wNPJ1u3WbSuxECfpIU+a7q6AKWi5W2OnjRK4CQbcefc7+uoAOJHULhPRfOxE0weIsPtthMjN4u97WgAJ/iOBQC+Ol7YyUOi1+aXRCIvPuZ0wNQB/37XKvuKFgL4s/JdndxNEGnZ6PHJ7wW4rVgUYdcIbAcwZnOHfZ5RmnvsltLkfSEz2LpdAaKiMzJU5cnZcPTJvssTPcPyVTt9iJbwCY1suhPIgIJSaxxVlFjMvxh8at3jFM/Sqi0lffP16ShmIIswAmk2ItBnuYrIBQFIiK9J2AIhvZ+KNcWHnNWozAaRPViukV03kh29hxRkWNlOX0zq8dFl+wERdqOIWiX5tpCLr+uisOFQl4SNNrDAk3OH6cCzQaApOLABuoeKAIn1EqWdcFvhzPAUZILaewK9XYGDM26K22o6mxDLX4o/a5OyvM+tper2ZHmLgEAlKxO3mD5QL6mwUrj60KLW4534DqR58TuMcRvESO8Emp24hImvOatB/3ubCVtwNm0TFoCbFTsMdTTHhI9ovS1wEeET2EPUw8nOFYLvNangy66lHb9jwFnxcDKpjKFesAVno5CxmJJGdBxUR6cMGpHcdbMtEJi+ppEcjZrm3D13U5nuoK/8PmKlghTED6CQks4bEHduJSG087Lzs0C7PDwKk
 6sZIxifW
 Ytx0oFSCv2YvjG7efeivDqihgT4FKrlsRNyhL5tUVGLWjrV+aWvgJcpdRXNgUOjo9H3CLhCzhql18biNkkIbiHQXQIKrYoc3B6huewLFFHsgp086gRCXrGFYhpH5PuwfZeg6dVJu5Ks7jy/982FKvS2/RaCce1Pyp8ZBVoO4NYA5ytYRJdDiFXRXs0rmDulKPdBq6yumEjdoTzb3KKJ4iEV2icrOUphkdItFTGGwMRA1DkFKPkUl2nk4ribc97JNBO5pdd9JsJj2KrxKYXeAD1ngLQWBQxDqOII1USqnLhDiSUAcLYzPBTJsQP3LABseoEHJebvmgqPNnoz70orPYz3t7HdEy0tza2fAL5Ux0z4nMKerPyM/hyNBN1WrT6LjYpnxZrFlt5jkkLx8hBrQlluVGhRlPZmCdwwDKvuTSOtsFGmA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_huge_pud() reads the old PUD and clears it in separate operations.
Hardware accessed or dirty updates between those operations can be lost
when the saved entry is installed at the new address.

The raw pud_clear() also bypasses page_table_check_pud_clear(), while
set_pud_at() accounts for the destination mapping. This leaves the
checker counts unbalanced for mappings tracked by page table checking.

To fix it, simply use pudp_huge_get_and_clear().

Fixes: 7d846db7d0e2 ("mm/mremap: convert huge PUD move to separate helper")
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mremap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 0d06d7f37f19a..16e736c72d9cb 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -509,8 +509,7 @@ static bool move_huge_pud(struct pagetable_move_control *pmc,
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
 	/* Clear the pud */
-	pud = *old_pud;
-	pud_clear(old_pud);
+	pud = pudp_huge_get_and_clear(mm, pmc->old_addr, old_pud);
 
 	VM_BUG_ON(!pud_none(*new_pud));
 

-- 
2.43.0


