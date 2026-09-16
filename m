Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DDDBC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 07:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB006B0088; Wed, 16 Sep 2026 03:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7C7B6B008C; Wed, 16 Sep 2026 03:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91FD6B0092; Wed, 16 Sep 2026 03:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 852576B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:55:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D7ACA5C7C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:55:29 +0000 (UTC)
X-FDA: 85218865578.16.23A18B2
Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8436B40007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:55:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QVSEMd6P;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789545327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uQ1ZlYE/9aLK+cH0N9jjFnsIgthn1N+eJsPr4JcqgnM=;
	b=PZeyQHKAJpSetTx95wlME1C6kGe7yjXITgTBxKxuKgD623jjBsLktl5nvtkbJH8myATLKP
	47q36rffh9EAfKlOOVZWZlCTKyuMgfrRjYqeViKdLQj+JMKkE6Mc6j8l06uEl7wB8C2pes
	65sWfbdNXiopGuBb28QCg7+yirY6I18=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QVSEMd6P;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789545327;
	b=W+S+dxicGYU66Ye3FdRgJ0s51+fnyOJ5Jc1jks0E16BtDXUQoL5TP5nFqK/liOrExHTLoW
	V3EfOAj/Ze88Wu9QgnNxfIVRTx7TCPitKjkdWX3YPZSNViKNq2UdUnkvIIZowjYlHtmzVu
	XElSzD8NiLLeRYAil4q22hkberwQu3M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Gy2Ww2TXVYXoXh9qTH28gt960gctPg4lRt01C40cxiA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789545322; v=1; x=1790150122;
 b=QVSEMd6PqpzHY7q0hnGKXXCWWQUVkCWYEmcmyGW3nrQcS0N39+QTMs0MNNqyFMDK0jRh6hjX
 1OPIxq1Iq8r2s6KkKRgQmIGlIYTXH6LypKtnQ9mATen4uDneYuP2veRRWgHfBJ1QievtkEimite
 YtWFdubl0wdASnkqyGAAQ6n0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5bc0a2ec64a68065;
	Wed, 16 Sep 2026 07:55:11 +0000
X-Mizu-Trace-ID: 5bc0a2ec64a68065
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] mm/alloc_tag: account for reserved tag ids in the kernel tag check
Date: Wed, 16 Sep 2026 15:55:57 +0800
Message-Id: <20260916075557.121316-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8436B40007
X-Stat-Signature: 4kkzjp4mwjzec4p6ajqgzu6qkdahyngx
X-Rspam-User: 
X-HE-Tag: 1789545325-79579
X-HE-Meta: U2FsdGVkX18kUOBsfyWgbXoCSCqqkl5RB0sd3mXnd5WAUiP9XaPeVC/B2xXGJZk4RvDjWz8o8Uh1b15CMvx6Im1RoUMZsWHmPaowEfo+Ds+NPTxshfWVfArqnD2cstuJqlhml99u+u/tysy6fKmB9x8hSoR8D1TQVca6uHZkAhzIy1NeZOLou50EOSEu9C9eZfpYC/0ip1O//Ka7oq76bbwsvINi5M71mbdKpM1Cgn/yL/hl0MH1ZAJsOn59SMJ0KuZ+HyLfZuOdQ4KZnzlXxBKOl08HEtUkBrKQwKCGnvDts/TnKY9oiJ3uHX0LU5PCIPhUwhfhrT+3r+afbVeHWJpUr3ikS0SMNmqkLMkGZURFL19UmgjMKkaBjCYEu9b1BIhl5DUfvy+ZpexIn4CKoheMAEFws0fWRqibD3aJ6EzMeCRnIKmJ+6cLsWxtL642seoRLf1inbpS/GaBuuzdayxZVZ9GB8k5LuF1ZGZI3gm2usOSFlSwSLZEOlclwsUModzizUBgy+y3obLKbIElq6FzLp+0jFf/to+WVPh0NTKOV7mD4JxR66+4DbZoftbYHbvVUN6gYLLrsyTNpHOT0lPHugWplyGYloeJqgE4EiZMi4p62zLSiYT4sa5SFsvfrn9Y3b3w3EC3WMfhrC8dCEFabyHrQNWq90ZyY82hg+kXphSWR2+DY0zfcHbwZiREycsdgaozXjI2nI+aracp+s4sG58lQlEUCWBAc11jx/ZOgkv+LViRXOC2PasqvRr4jDeP4Qy0Kzv1bHBhmKeTvjl+XOB7dr1Qmc8gNC8soSYhGWi0bZuYDPkU+aq/ncQNDpQNIuU4cgCkguEgHidWajJlVKilWXhpMaWKo2KwMWA5YsgtjDRSvMomDTJ2TAGsh1DxGMa87SOkECuj34SnzbEWEVYZh4ceCtlBhcuvsKIJGRpCOyw+VNNXDIUOF2Tc9hfh3oxk60GKfbpsKyM
 1TJoHS4q
 cArx5XMrgFpUJELc6+QcpAs1W0Xr1vd1+u9AglkrzJRbFg7gjQC2v8cHi7/7FG8Ayy73nlnSaIP+IGnEFQ5/QZ9B9SjexvOEJKf5SktOWXQsrzsYrtGwStl82OMi5OC+a7n2U7OjewNnNMs7ynElGR2s3EKgNL3p/ncJaKy4MjKcTBvFF0WPVkuqQ8jlqubmm/BcZtEJvd35JIgkss7NqbNRO8a7UYsRs03uS3fwuGBJFVPJdufH3YehhEWIjUrQ+vOP/hvUMG6qdNC42pPvVH1phsngZc5aTxXNCITJGwfKk7xI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The tag ids stored in the page flags include two reserved markers.
Id 0 means the page has no tag and id 1 means the tag was cleared,
so real tags start at CODETAG_ID_FIRST. The kernel-side check in
alloc_tag_sec_init() compared kernel_tags.count alone against the
addressable limit, so with the count at or just under the limit
the last tag ids wrapped into those markers. Pages allocated
through them then look the same as untagged pages on free, nothing
is ever subtracted from the real tag and /proc/allocinfo shows
that memory as still allocated.

Add the missing CODETAG_ID_FIRST, same as tags_addressable().

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/alloc_tag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index cfa0fc84b68f..cf100e7a852f 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -629,7 +629,7 @@ void __init alloc_tag_sec_init(void)
 	kernel_tags.count = last_codetag - kernel_tags.first_tag;
 
 	/* Check if kernel tags fit into page flags */
-	if (kernel_tags.count > (1UL << NR_UNUSED_PAGEFLAG_BITS)) {
+	if (CODETAG_ID_FIRST + kernel_tags.count > (1UL << NR_UNUSED_PAGEFLAG_BITS)) {
 		shutdown_mem_profiling(false); /* allocinfo file does not exist yet */
 		pr_err("%lu allocation tags cannot be references using %d available page flag bits. Memory allocation profiling is disabled!\n",
 			kernel_tags.count, NR_UNUSED_PAGEFLAG_BITS);
-- 
2.25.1


