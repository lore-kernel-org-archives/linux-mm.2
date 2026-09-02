Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCCBCC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87C086B0092; Wed,  2 Sep 2026 04:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853656B0099; Wed,  2 Sep 2026 04:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 790AE6B009F; Wed,  2 Sep 2026 04:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 483086B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:10:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B63ACA00B8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:10:26 +0000 (UTC)
X-FDA: 85168100052.11.06F35B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 15A7680002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:10:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TqUVp1h3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788336625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ftR3FpdlIwIFCE7dSgyrcheyGcD9O4EpeQS8wDPSIw=;
	b=B0nPs88rw7Ke8iqFuDtk3Gp4USvYIpMGL04aPJ1MhNIWY7q1T0RCc9FWg/iFeo4nJrYCvA
	vgKiSPBlseLrkPLYE7CwBWCKA+HzWHlqgx+VfWw2KdqVc/j2iptmjax3lHdcMVVEhgiEUN
	AYHonv+pyuOPMlWR1WAMKf1Ksl7Fpyw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TqUVp1h3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788336625;
	b=bFUTVi3WL2iC+JuZj5xoLus5UO2w3cW854JhhzpFLJsieHR1DBV3NFvJ5F3btXcNBL4FUy
	k+pqbNyef9aGYk3vnayLytpymY5w2qLV+NzuE3Uf+G0m/+ZC0sm0YHDXsFiBu4hRG3i14A
	xHDxOnzzFyUy/IzbApEaKhabdf2iDqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5156E43DEE;
	Wed,  2 Sep 2026 08:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D104D1F00A3A;
	Wed,  2 Sep 2026 08:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788336624;
	bh=0ftR3FpdlIwIFCE7dSgyrcheyGcD9O4EpeQS8wDPSIw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TqUVp1h3Jl+ZYjaLmC4RG81QROEerifB85tiYh/wEobkksJ2pi8btGDLfUgyBXIuU
	 loHmu24hu49LpJBqovidkSvrXIOohJ0KVN/T9BP9mtSmw21SSlAZ67ZCvoU+MNwdHj
	 48N0sdSaI3QqRshkPpr6niTzcxOa7q0LkuAMRsRze+Uc58Q4tpgn5zNhg5kE15RxWB
	 nsUc5MMUYcG/j0JxUPBgGYb8bDP8PLOSzxAYcVpJ2gMd6HTtGCE52Y8wian+0+Ghj8
	 aPMQ6Hhw9cRFe8djd1yHORt4WsGScJcD+RBlGnuiAJZMZHCFacqAUf785z9Yr3lErq
	 3/ZqTjF++iVjw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 02 Sep 2026 11:10:11 +0300
Subject: [PATCH v2 1/2] docs/core-api: memory-allocation: add
 k[mz]alloc_obj() and clarify kmalloc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-docs-memalloc-guide-v2-1-218c1a4dcb80@kernel.org>
References: <20260902-docs-memalloc-guide-v2-0-218c1a4dcb80@kernel.org>
In-Reply-To: <20260902-docs-memalloc-guide-v2-0-218c1a4dcb80@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 SJ Park <sj@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 48uj9xzs38u4m45gjnraqatw4gmssa6m
X-Rspamd-Queue-Id: 15A7680002
X-HE-Tag: 1788336624-148709
X-HE-Meta: U2FsdGVkX18seg7uMlC8vof/9z9Ux+T4UkcX3wFp8HIHuVfd/42bQLlmnfFdZsGbqy+8PNU4x3Iuq1RJEOMZmo5rMo9KsTs84NPFmg7bI+caurzmYxLyNF6TdNIZR8zUUhVLP2DzE1WmZtFAq+mZtFSxW6NinpvZFYScYDczKnDSep51U3SMagIikTwm/uxto8Ex0VlTYXYmzWdnD1h4gYtOh0UaMCLBOIeXT2l/VCymeZlI7HJRLBYySy5xQHv2SGyJaNFEAKaRx+iaQh16Aq4Ko19XPlifojsKEEO5dXzUqOTjQ6NalLF0zffkqcYNaN6f0Zr4LLWrKLXjOB9uFWC1X82k4MEAH69d7JEhS+1sBM/I4yy5RtC5J7K1qDePeaZFzrYRygtIu++L01tUY61IWZMpo6lxVDjDiV4SyrQh63/WCf0CnFq29shTN6wpWJsuMRpqxoabFbcECGh1hNpXDBiJBk4gM3FxV5HGn3axjLrGy0KLe0jnQ6Nolq2R1cADIJcC5RUU4MSQt3y5pQE9pH3toxnsRlSBVPCnxVcdM+1MnWf66t9x40HqbXFmWdhbcx0pbhQFbTpuAwTp04wdHeciAxH9RsxI8nJw9oQhAsPPochQCNcVBvVkUp269xu1aMwW7Mn39ry12lUQhgtrBINQ3kMkjkuVKXFsOkq9ZiYeA8FkIHq+OIJKbGkAIwnjlNlbxMHI5ERj5OUSkljIDykdJCNLQ1B6ZENowgHofNd2qwA5kwy00Obt5HkPJK4jRMKppLtB9iq7slHCUFTpX7R+yl45ss3ct9DkMPCJ1GBg9r3wt8bGw0L0EQ37e23YD3jsGljUGVTWSnNJsXOXD9Nk5/2sbxonk+UeUjb3PmmJ6oZuNuIjUsOYxgSxaFgmn5FjhjWkxEZPQHBDv2zttngnZL2p+AsaKT3+eT26CXoMV0mUZpcNgVqW1qcgRGUNF6zBGyBoQLyrVXt
 PfEieswd
 Uzvo6BTYzasvoRUneA+ZlHAChqtp3AZN0w349P5QP+PQ1iczsqfrLzLz8mypQs9+RM8NmegPqd7UCS2tmmwpj1/dkT4q7bFvfMF5p8hHOuS5PWYg5YvEsXzRc2Y1iK3MaKSkC29QzXEqclG1MrMSExNJqKtcWILwyvypnWub4VxiJZXNsHs14D5mkBhO9AqVRtT4vJWw1xFFX4RpE/FIdrAl+1wpi2iKw6hlu56hAHGfjATP6SrEA+jbfI5wgAwiHVTopCyXxf9V4d/NbSdwka0gzeMy7VnObZXZOe/E2gKpxkihdl9qON3ckCaW4NTwWTuiY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since v7.0 the most used memory allocation function is kzalloc_obj().

Update the memory-allocation guide to describe k[mz]alloc_obj() family
and make kzalloc_obj() the first answer to "How should I allocate
memory?" question.

While on it, clarify description of kmalloc() size limitations.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 Documentation/core-api/memory-allocation.rst | 30 +++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
index 0f19dd5243239..823f7fa57429b 100644
--- a/Documentation/core-api/memory-allocation.rst
+++ b/Documentation/core-api/memory-allocation.rst
@@ -19,6 +19,12 @@ Diversity of the allocation APIs combined with the numerous GFP flags
 makes the question "How should I allocate memory?" not that easy to
 answer, although very likely you should use
 
+::
+
+  kzalloc_obj(<VAR_OR_TYPE>);
+
+or
+
 ::
 
   kzalloc(<size>, GFP_KERNEL);
@@ -139,10 +145,13 @@ allocate memory for an array, there are kmalloc_array() and kcalloc()
 helpers. The helpers struct_size(), array_size() and array3_size() can
 be used to safely calculate object sizes without overflowing.
 
-The maximal size of a chunk that can be allocated with `kmalloc` is
-limited. The actual limit depends on the hardware and the kernel
-configuration, but it is a good practice to use `kmalloc` for objects
-smaller than page size.
+Since 7.0 there are type aware kmalloc-family helpers that let you safely and
+conveniently allocate a single object or arrays of objects with kzalloc_obj()
+and kmalloc_obj() and their array versions kzalloc_objs() and
+kmalloc_objs(). These helpers only need the type of the object that should be
+allocated and the count of elements in the array for the array versions.
+
+As of v7.2, vast majority of the memory allocations use kzalloc_obj().
 
 The address of a chunk allocated with `kmalloc` is aligned to at least
 ARCH_KMALLOC_MINALIGN bytes. For sizes which are a power of two, the
@@ -154,9 +163,16 @@ Chunks allocated with kmalloc() can be resized with krealloc(). Similarly
 to kmalloc_array(): a helper for resizing arrays is provided in the form of
 krealloc_array().
 
-For large allocations you can use vmalloc() and vzalloc(), or directly
-request pages from the page allocator. The memory allocated by `vmalloc`
-and related functions is not physically contiguous.
+`kmalloc` always allocates physically contiguous memory and the maximal size of
+a chunk that can be allocated with `kmalloc` is limited by `KMALLOC_MAX_SIZE`,
+which matches the page allocator's MAX_PAGE_ORDER limit.
+
+Internally, the slab allocator differentiates allocations of different orders
+and delegates larger allocations to the page allocator, but for the users of
+`kmalloc` family it is entirely transparent.
+
+For large allocations that do not require physically contiguous memory you can
+use vmalloc() and vzalloc() family.
 
 If you are not sure whether the allocation size is too large for
 `kmalloc`, it is possible to use kvmalloc() and its derivatives. It will

-- 
2.53.0


