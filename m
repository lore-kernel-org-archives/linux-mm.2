Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A3071098787
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A693F6B00AE; Fri, 20 Mar 2026 10:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40856B00C2; Fri, 20 Mar 2026 10:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DE26B00C6; Fri, 20 Mar 2026 10:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 85F1B6B00AE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:04:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2DA061BFC1
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:04:36 +0000 (UTC)
X-FDA: 84566611752.06.9173AE1
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7B01F120016
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:04:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wS9n9+fY;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774015474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmRxXvLU2NeOq/5VK9R2/fqL97zGqJrwy25018suKSw=;
	b=PFN1VrvZnHu6QJbfDJSr/OUPPS1HcWZ/rNg+WoaYYkf67SUdrB9MH+CyfGH+wFAVnP6FKE
	lCrnW0eX27kK5UyHD3cKKynx157zhfP4br1MDiV12esId7Og/skh/4QBl8LOpszisfXh80
	+3uC+FaiZ7wVKm70yhadP/n+ZWnNJQI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wS9n9+fY;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774015474; a=rsa-sha256;
	cv=none;
	b=CVUvPKSpOWaB2QwJWKFat6+nO9uLOqxV6/wPs4CUDLCw3v/qbJGlE/J1gj4+rJEqmJT/+A
	V02fmralTHbwBGzEIKdOej9Ws7VigbSqEPPnlQ4wOC5wnISl2zCAtnwMvfAFOdWhNSN7k7
	t6Jtfz3ErPzrMQVN3SVXoppoBhnUHv4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774015472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gmRxXvLU2NeOq/5VK9R2/fqL97zGqJrwy25018suKSw=;
	b=wS9n9+fYt23GFUct+LfGUjkJm/ZIwaGL6fzpdAvRLF26yPQFBZkuayNfpKCsRPYw7iImAQ
	abZc2PDiq+w02KVbtGI2L3QKF6Utof/q4A1U+08yA0+RdbXAXuvOhpJhn/znvXZcET7rtY
	rTe+wuWgnlNaW+s3aXCk+3jQmfCSrwM=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	willy@infradead.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org
Cc: r@hev.cc, jack@suse.cz, ajd@linux.ibm.com, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	wilts.infradead.org@kvack.org,
	"linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	kernel-team@meta.com, Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 4/4] mm: align file-backed mmap to max folio order in thp_get_unmapped_area
Date: Fri, 20 Mar 2026 06:58:54 -0700
Message-ID: <20260320140315.979307-5-usama.arif@linux.dev>
In-Reply-To: <20260320140315.979307-1-usama.arif@linux.dev>
References: <20260320140315.979307-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7B01F120016
X-Stat-Signature: e57648u18n3sp9ms63hmgrchferxddja
X-Rspam-User: 
X-HE-Tag: 1774015474-247699
X-HE-Meta: U2FsdGVkX1/2iYo7jL+YusGfUm9a9wv7TCWR7qa4nTZcJtUw89hK5qJlk1R5Wl9q7Bl4hOuP4CQ0h9oGE3DiuKWZ40OL3GbKuoCzc65rSMhfsCaLTTuEYfg9VZdwQdkM1VjEwYlOm9r0rnKpgAKGgH0wdO3AmaqkrYjGDHmlZFJt8YW9YdLUzlAtK+xt5Ly8an5onv/PXTKGCD/F3rs5K7rWdlJ/XtOdxG6kyKl/AcZAUbl9mzWuHo5nBz/eV8Wa5L/YKLhr/zrlJ+j4zLFOUM+Hr6W8UBw5Lz0cZKDZbv8y8O3go2SL2Lz6PaB9rIfhvkE25IgCHZ1EbPi2/JM5xDXMWpFDCzouFlFymTHH44DdYlZclPOQkZP4qA4dDSpansYhFMynYKG7bMrAQxBsZVVWmEtGcJKr3+Outr42p3giuo7qbT95WHUXH47+FZOH9+wM2vh3E2jJSQS8rM2lyS6tkoTWGRBjlTUI77UwNu14IhL7XKWKrjyOFNQllLOx8l1t5YUuVRm4CWTziH8ofWiPR+I38QFsb5ser1XbSAT+fpym3k9ZHAdbG6pJLnF+45OV8U2g3TV4rY4AV2VXPvsPAcwMI5rpVspM0OvnmoCYEdGbDDUdxWyPeG7bBenw7KZljgrcNuFqTJXr8b10Kqq5HgHC6wsdC/g0Y1fy2dRtEUsmYnLkdmSYvOxy+PU2VmIQXqb9FGivShBZ/3aHBomt5NI2SsUApfC/d2S7kolvA+YdZljeufStDxxZ9ghLaeXxiiEuDbyaDQBGNS0vPsdfxzTOrZi32EZILNDQ4ujhk7b1rKCutKE4ryeGj+M9AvSnoxWeWw1IWg2U8dP3BKmfUw0lHk0GsF2aM0Zg2VLLn6oaeWN9HNJMFNcO3EwQmoABaiAzKVWKBMKS8H3AjC9faHflfm1dvuwGLMJlwopzDShYXxpdHYRqTqsHwsup55kux//Adt/Y/FMIg5u
 9uTKFW1g
 GWsrnSvWslLWErkX8lL/GWAB+Jr2WIntZYf+fI/ZGWMP8B+ThB6jYTfSa0wIo2r4/CJw4yvVPx5BJV8658lQtcFQ6zNEaLVzesaGr4i3KrxzOR6bxSIB2hn02vuEMyhNgU9CwA7RmIS5Fj7C5svLtPRuaULGLSQ/fbZVY8og5jw2ghs1QeEOQknBOesd3fdPKbg1phKvZ2npiCEjXL5W81iIMgDiOxeGwEdaBI6SW4gKfBQkf52VqSU5d7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

thp_get_unmapped_area() is the get_unmapped_area callback for
filesystems like ext4, xfs, and btrfs. It attempts to align the virtual
address for PMD_SIZE THP mappings, but on arm64 with 64K base pages
PMD_SIZE is 512M, which is too large for typical shared library mappings,
so the alignment always fails and falls back to PAGE_SIZE.

This means shared libraries loaded by ld.so via mmap() get 64K-aligned
virtual addresses, preventing contpte mapping even when 2M folios are
allocated with properly aligned file offsets and physical addresses.

Add a fallback in thp_get_unmapped_area_vmflags() that uses the
filesystem's mapping_max_folio_size() to determine alignment, capped to
the mapping length via rounddown_pow_of_two(len). This aligns mappings
to the largest folio the page cache will actually allocate, without
over-aligning small mappings.

The fallback is naturally a no-op for filesystems that don't support
large folios and skips the retry when the alignment would equal PMD_SIZE
(already attempted above).

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74adf..4005084c9c65b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1242,6 +1242,20 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 	if (ret)
 		return ret;
 
+	if (filp && filp->f_mapping) {
+		unsigned long max_folio_size =
+			mapping_max_folio_size(filp->f_mapping);
+		unsigned long size = rounddown_pow_of_two(len);
+
+		size = min(size, max_folio_size);
+		if (size > PAGE_SIZE && size != PMD_SIZE) {
+			ret = __thp_get_unmapped_area(filp, addr, len, off,
+						      flags, size, vm_flags);
+			if (ret)
+				return ret;
+		}
+	}
+
 	return mm_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags,
 					    vm_flags);
 }
-- 
2.52.0


