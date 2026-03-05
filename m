Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 912FEF30930
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BAA86B0092; Thu,  5 Mar 2026 05:50:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030606B0093; Thu,  5 Mar 2026 05:50:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20AE6B0095; Thu,  5 Mar 2026 05:50:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE5016B0092
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:50:42 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C2D4160928
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:50:42 +0000 (UTC)
X-FDA: 84511691124.19.A20FDF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id BFEE7100013
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:50:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qzRe592d;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772707840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+05H/PICBvxhE8fZbU0wd74IdRVKUUETjgpVxIwFBJI=;
	b=F1SL7ITZn1tlHvv3QD5QF6AuRiah1XbJWtScK1y2jCiNP7PqesLtBKm/tpJVDlC7vqf1aX
	ereSpWx/+RWsciOViWePIrOoxWk2BEOePdIFVyeA9IjxqYrzYEIMgSPj2N28jZjsWEsbEl
	WkkSqRdMSFq+M4cOoWFH8cbSLCy3LMM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qzRe592d;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772707840; a=rsa-sha256;
	cv=none;
	b=cfVRYX4lfUGR4u3jyptHFHygPkE24Raw1KRPqn/myIem6gAJY9/DQh8p1SDuwvqKm8U0yl
	kFZwl1IHfaGoNJmktBuWsxjUby2zoqsJVUqD9b4WqO/5b8aJoZclgealE+ch0RfQkO2nLc
	4wbr3FOOs6tU4aiXc3SWZCXS2MWOtG8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C3AD6183E;
	Thu,  5 Mar 2026 10:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B328C2BCB2;
	Thu,  5 Mar 2026 10:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772707839;
	bh=DYhXxlFibg/ph+ULNrBqyx61MpJC3w0/qL0oDFFaj48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzRe592dIXMITxgi3/PMgCbLgnQE+I+PwMx0WtLY14sm0eiu04iJcrc8TQhUREmTw
	 pMUJVal4HNAiq1fs/UAY0/7GXh6sQzdNTGwpgGUnbBmhLhbeTp7nW342JH2E3TZsK2
	 QL52Vs6CB2ZADgGsvLkubcObTuz+czHasN1nAmuooUDg3xLhM4mkM6awtLec9H2q0o
	 R2nKhYT/awx8tr7NJjxrObPoyneblu4xJB0rwFgvYAXDpDaz1T2DOCgRZrzDZ0ZyCc
	 XcXhwWR/vWuMnRpspwy0ytUtb6G2tLgQ4NJhINCnUElVjKMQQHfwTfahU2F9VbnbQQ
	 PbvCFCm3KZCJQ==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-mm@kvack.org,
	ntfs3@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked functions
Date: Thu,  5 Mar 2026 10:50:16 +0000
Message-ID: <241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772704455.git.ljs@kernel.org>
References: <cover.1772704455.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fso9nx1b3jiprrb4uuzixqg7f67dsfoa
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: BFEE7100013
X-HE-Tag: 1772707840-707433
X-HE-Meta: U2FsdGVkX1/GljArBS3RBtgJ9Qw4RL/kiuqueO+9Gz8s0qcdIhEub/BUjEZQDRPdd3hnREYZwoYPf3YEbMlfZV4uhQxmd6d/Va+nHvWSzpxhWL8xbnRKNK2N3mR5tddReGKXvckyc947AwLvTzQG2di71bFDiB/lk2eGjEUAkwB/UeYaIiwOynfpC9RMGE+/juNyazW8N2Acf/L0++Crp5Mckv79Q4FM1mTM7Eetv/QJ9QVRoVXp+Izr/oV/LfoOvcmTnawxGVm4ecYDrPPufbdfUMir5P2lVvHBHqIWeMjeRx8jqcgKCsPIYqoXr6rFe+1qvywXifWOYbneRnRtwjcoeujV9Ipr0A4SNLRI/qATLLp2cVmgjj55FC9udx/puOZS1jOvgWM3nZrqhUWuYHwWtdMJi0dDyv62Q5SmgCh5S6l0xiN9d5rdGexgsuWDBefUGBY8DU/InOmO3wo4vxDV0wVzkoDoLwlnAGbsgHyZbTVjvOwI/srlV8/qnmKwISaww7ka+pQcEfb2ifF0eddUPzG5OIRPhRKZa+/bNMtvd15eta4bU6J+Z5dhh04vOMbE1NseLkVE/5SVUOiWURCvOdy0U6zTZwU9XJ0U6RA0qryZgOlJ7NjNlUIt+PuRDq6yd9TpJIMOpvTs0L5JxuoFrp61MSOPker2KyhcZMSQrYouaOaf+ozGUbrYsNc9bfxMBX4smrl2aXkw4Di7whIRRFTvAM12y0WXPSoeKaTsVIedOPTmorgFp03yKQu9ZThkv9x7lvE1kCZOVJuMsbiUtdn6u5S3lPAL61oqEiQhLSW4uE+7gxgyfsQ3l6TJuZMb8RWd5nw50losF9Wz8oFIMyKlf85l8PK3aNQLZrQgHMKlDk2BxXqmthv0716MYaroTuG0VaOQrHkZPTjupThKvmRjkRsfieMGVBX6poxo3Igs3deeh9H+8M7JMBlKwPnpqxNmVij6GPN2F0d
 Wf+RW7le
 hIU867Eeuz39C6nqTbZRRdo0V18g2cK7KKqyoy5SKg1aWTzVbM5nIQBV6UYIIM92V02rNHY3vNWAeOCoKJfJSCyR+5HUAJ+6kaV3++3ShovtpRe0xSso6Q/HuNr5cotjMbGsq4S6h/+PK4Cxk2SaytURdBXnDm2rpM8zhJ1w5APQHSrUzZtRlOvwvd3kmnZIX+cWfAZANX5lccFPdUSxhg/5wk7HSE0gbIr5uKLjRsCDNsDM9q90X9cvQ6b3JzVcjP5oXY3ce6lEJQsig6VNCWR9n9JYRJab13ve+pLGCJYswIzU0/mTmshNxB/9QCtW2HFpj8XXfOYDiAcSbSwdT0cZAJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
macro) always being inline, as we rely on the compiler converting this
function into meaningful.

Also update all of the functions __mk_vma_flags() ultimately invokes to be
always inline too.

Note that test_bitmap_const_eval() asserts that the relevant bitmap
functions result in build time constant values.

Additionally, vma_flag_set() operates on a vma_flags_t type, so it is
inconsistently named versus other VMA flags functions.

We only use vma_flag_set() in __mk_vma_flags() so we don't need to worry
about its new name being rather cumbersome, so rename it to
vma_flags_set_flag() to disambiguate it from vma_flags_set().

Also update the VMA test headers to reflect the changes.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h                 | 8 +++++---
 include/linux/mm_types.h           | 2 +-
 tools/testing/vma/include/custom.h | 5 +++--
 tools/testing/vma/include/dup.h    | 5 +++--
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9a052eedcdf4..66b90de30bf6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1031,21 +1031,23 @@ static inline bool vma_test_atomic_flag(struct vm_area_struct *vma, vma_flag_t b
 }
 
 /* Set an individual VMA flag in flags, non-atomically. */
-static inline void vma_flag_set(vma_flags_t *flags, vma_flag_t bit)
+static __always_inline void vma_flags_set_flag(vma_flags_t *flags,
+		vma_flag_t bit)
 {
 	unsigned long *bitmap = flags->__vma_flags;
 
 	__set_bit((__force int)bit, bitmap);
 }
 
-static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits)
+static __always_inline vma_flags_t __mk_vma_flags(size_t count,
+		const vma_flag_t *bits)
 {
 	vma_flags_t flags;
 	int i;
 
 	vma_flags_clear_all(&flags);
 	for (i = 0; i < count; i++)
-		vma_flag_set(&flags, bits[i]);
+		vma_flags_set_flag(&flags, bits[i]);
 	return flags;
 }
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1a808d78245d..294efc22b2a4 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1056,7 +1056,7 @@ struct vm_area_struct {
 } __randomize_layout;
 
 /* Clears all bits in the VMA flags bitmap, non-atomically. */
-static inline void vma_flags_clear_all(vma_flags_t *flags)
+static __always_inline void vma_flags_clear_all(vma_flags_t *flags)
 {
 	bitmap_zero(flags->__vma_flags, NUM_VMA_FLAG_BITS);
 }
diff --git a/tools/testing/vma/include/custom.h b/tools/testing/vma/include/custom.h
index 802a76317245..833ff4d7f799 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -102,7 +102,8 @@ static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
 		refcount_set(&vma->vm_refcnt, 0);
 }
 
-static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits)
+static __always_inline vma_flags_t __mk_vma_flags(size_t count,
+		const vma_flag_t *bits)
 {
 	vma_flags_t flags;
 	int i;
@@ -114,6 +115,6 @@ static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits)
 	vma_flags_clear_all(&flags);
 	for (i = 0; i < count; i++)
 		if (bits[i] < NUM_VMA_FLAG_BITS)
-			vma_flag_set(&flags, bits[i]);
+			vma_flags_set_flag(&flags, bits[i]);
 	return flags;
 }
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 59788bc14d75..ef6b9d963acc 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -780,12 +780,13 @@ static inline void vma_flags_clear_word(vma_flags_t *flags, unsigned long value)
 	*bitmap &= ~value;
 }
 
-static inline void vma_flags_clear_all(vma_flags_t *flags)
+static __always_inline void vma_flags_clear_all(vma_flags_t *flags)
 {
 	bitmap_zero(ACCESS_PRIVATE(flags, __vma_flags), NUM_VMA_FLAG_BITS);
 }
 
-static inline void vma_flag_set(vma_flags_t *flags, vma_flag_t bit)
+static __always_inline void vma_flags_set_flag(vma_flags_t *flags,
+		vma_flag_t bit)
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
 
-- 
2.53.0


