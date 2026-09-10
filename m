Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08867C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF16C6B00BC; Thu, 10 Sep 2026 19:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8DD6B00BE; Thu, 10 Sep 2026 19:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4F0F6B00BD; Thu, 10 Sep 2026 19:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D62A6B00BA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B646B1A0624
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:45 +0000 (UTC)
X-FDA: 85199512650.15.4A9304D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A9A6A140007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mAWqa6HN;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084543;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQiH2x6KpBgbFkgYo0cL6qY/qgVtjlCcjPb771rnW4M=;
	b=YXdBkDB2XvL5VV2El2wVAPAe2vYUw27Jd2U8uL8WIGiYmDWSkd0OUwEUwC86jTCDyjhyzi
	AXdPAHuT5YZV+tlcZVAUsoOR+2t0UusyeiOi+iv00/WGSL49veDoVw25r6xyTXShvhsz8x
	BviBpgyWyR0A/QNVsuKP75jEsZu39Mg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mAWqa6HN;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084543;
	b=owUkIM614thD4oQXBV0MPhAmhFuJGbpUh5AyCmSo2sv4CjnKe0pxXofvHhJ4xeDAYlb2VX
	i1b2CLIRnwOoP6cfFrj7cX97xwY4WFpaSx33+uDxcygdV4XyNuzQaEVfU3AZY7ggWxbx+Q
	A9tOaJS6EUwp3p6YPk7nk8bzMUCyX5k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2522144862;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE98AC4AF62;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084538;
	bh=AKnq3mfGG77mv+gq3PNJT06gkFvH6br0vIP3tfVxk8M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mAWqa6HNhQOZLMGnaET8GvLt/RbWXdF5Rp97p5omjedV9D1vBxgLAY2ibAsD5P904
	 /akbgtQxHzHYhOVjluMU+HFYTHNnCVNI51UczcWhIsODyxrmhV8aP3itMsD4B4m/04
	 ZG8nXaBbdMY5XFDDGC8GCiaO7Jb/YJjIscEsDA1z8Qt1TbFoMr/KOfc8ym/tuTWkY3
	 6HiPenLL6XjSSopKfuZNAvcBu7x1rMKj6xxKiR/a40gVOycb4tvs7yVKMkTIpuXvWu
	 2JYGHZjW0fblBFKmfbdNOSiTN6hW+6SVSolbEnQfm37570nK2LHC4CkebJbHzaM6Mt
	 YDJb3QuvrxP0g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53ABC88E46;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:39 -0700
Subject: [PATCH v13 13/44] KVM: guest_memfd: Pass mapping type filter to
 invalidation helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-13-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=3075;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=olcJqZe/kIoxozaeU+OrcoTgHksLE0XmCcjni2I7E2I=;
 b=PuzcQplh7gT51UloHv+ksBnamz11cj9OVdlBS5Uv6zl9EQj3TJbbaqQLWZ/soHHP9gmqJhceI
 hjoYykTAE84BkNyY+4TA4mZ6z4mYfa48tiQc0dA3c5wb0giaT/aBERH
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A9A6A140007
X-Stat-Signature: h93c7h5yimo14eizwjk7p6m3z5ffordn
X-Rspam-User: 
X-HE-Tag: 1789084543-193450
X-HE-Meta: U2FsdGVkX1+BFxX23M17Nfbx0PQk+y9iQV64W5jXTLMKhAlHfzvuzU59REMCQA0e1BqlnJ6s+Gm9OXwZmEsph0rC5VS24LAKM0xB6wBXkuLIC4s79ai7LG8O1UcM5NBYYr9Bf0+OiJDeblhwqZ8tTXb+SpHqkqp98U8TpH5pXYliKkkP3TICAITK5AF4vNPD/n5adkxNf1H9ClS33o9euR47XxPVosMuI32s8QqWJvV/6/WVQ8oSPnGRbbd5stkgyTG8Fl6TsZfa2jDfCmC+YR3pbqQogRvNuyeqN40djcsaF0agIkKPLVHXXLKCLedpgJh85+3MFXaVOmbh+OVIunM89OrCEMWpt7XSbae/srKjMyvEhjKOnBjMtTHgH2RTz72avFKsvgVKysX9iprhwpYt+Jjud3hJuwa2QnDafXNor6b8ZiXmG2flblvyOStvtWILIfnDFdoq3SlU+3CHqkohh0A6fHnAkaSw+DAtDQOfWSGkzEzN9d9vd+NolWjtpjodeXr/92+irEoLhNYDI4zhAB/azgivgzpZLGfFAWStIa7XiZc92L500UsK3lq7hgVGVTc3L6S32pvADoNnp1Sl9/4cVG+1AFaIqhYguvjAJ9exlNwkdzG2IXDS6LLHV/J46Da1zgcqzvSaAzuyJ/yD09fM6oIZePoYNpQOWC2QS5OAbWOCkVX0D+eB2Tfnj98wZMQaDrktCfAU3HGvpcIu0ietaoKa+95dpebIdDtHLwQxq+yetIE8wb8dB4nlUByEP4A5SF6ZZoiMGVc24eCRJPHyfaTDjeimqgwAFJabUhFj5gBjmlwkdeuWsOMKTZbAbDy7AWxYZUpZerVfnekBDeU/fdZm5jEOETjPoNIpG6LWlk6cu/Yhzz2vkFm3KJLXI7EZ8wzqfbLgVA/wjGWoGtRK6pqoURwe4dn6A8Uu4LYvPHGhIh60JKG6ImYmH07MXMp594F8rEjocL3
 /NgYOEFs
 bL5Ycwxpb7JfPM8nKXHZRU8BXz0rbi1X9c9FeCSGwtGvOnMlmYHbR9zuGKDSxHYthotapfEjrzv2yzm+WXF3h6fESzJ3Aqe1GEVGhhenFxpNjMYQs3RbN09LT6ng5TStXBr+mykICwqWzlhH0qYz+GqLahaIwX6EIOPbg4r8P+NZJ7SJyTSEpWslv4cFOKgP00jQDKQ61rrplkBHdtSS14ts4q6gWOTMwcOctfhGYeoekgpVO2bCoT6YVQBnNvEwJLcg1wIzCtk9ez8/Jg7h0uEMBAgcPNjKffFeMf++oz8whjaIyUHuufsKa1hyAhGkVC2vCYUXqhKG6kdLnTIneAAiWjrJv+mT9jFKpTA+27dUwDlMJDj5JBdLKEdsc+rGlz9f14bBDie1y78Fq2KDCKY90DiSqyS38yhwdihELWfSL8rQlChWK4UsnFQCeN3SVQ6nGeSF1XLEWBlR0+NPBZfceEWxpX3c4bSGoNhTTbrUAjCoX0/1Bo6bP8Xiobl4Q9Ubo6vVvIWpf44lvMwydRbD+h1EkhswPzQQscloBoA7HPfo92ej9GONPDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Accept the mapping type filter as a parameter in the invalidation start
helper instead of querying it internally. This allows callers to specify
which mappings (shared, private, or both) should be invalidated.

In the next patch, the conversion process will use this new parameter to
invalidate mappings only when they're different from the target state of
the conversion, i.e. invalidate only shared mappings on a shared to private
conversion and not both.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 virt/kvm/guest_memfd.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index e41802944756b..e19de803149c2 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -192,13 +192,13 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
 }
 
 static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
-				      pgoff_t end)
+				      pgoff_t end,
+				      enum kvm_gfn_range_filter filter)
 {
-	enum kvm_gfn_range_filter attr_filter = kvm_gmem_get_all_gfns_filter(inode);
 	struct gmem_file *f;
 
 	kvm_gmem_for_each_file(f, inode)
-		__kvm_gmem_invalidate_start(f, start, end, attr_filter);
+		__kvm_gmem_invalidate_start(f, start, end, filter);
 }
 
 static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
@@ -224,6 +224,7 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
+	enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
 	pgoff_t start = offset >> PAGE_SHIFT;
 	pgoff_t end = (offset + len) >> PAGE_SHIFT;
 
@@ -233,7 +234,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	 */
 	filemap_invalidate_lock(inode->i_mapping);
 
-	kvm_gmem_invalidate_start(inode, start, end);
+	kvm_gmem_invalidate_start(inode, start, end, filter);
 
 	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 
@@ -522,6 +523,8 @@ static int kvm_gmem_migrate_folio(struct address_space *mapping,
 
 static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *folio)
 {
+	struct inode *inode = mapping->host;
+	enum kvm_gfn_range_filter filter;
 	pgoff_t start, end;
 
 	filemap_invalidate_lock_shared(mapping);
@@ -529,7 +532,8 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 	start = folio->index;
 	end = start + folio_nr_pages(folio);
 
-	kvm_gmem_invalidate_start(mapping->host, start, end);
+	filter = kvm_gmem_get_all_gfns_filter(inode);
+	kvm_gmem_invalidate_start(inode, start, end, filter);
 
 	/*
 	 * Do not truncate the range, what action is taken in response to the

-- 
2.55.0.1007.g17ff1f9808-goog



