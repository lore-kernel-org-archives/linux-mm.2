Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA2A0D6AAF7
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EA826B0092; Thu,  2 Apr 2026 14:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1FE6B0093; Thu,  2 Apr 2026 14:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FF6B6B0095; Thu,  2 Apr 2026 14:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F38E96B0092
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:14:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBC6F1A0339
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:14:09 +0000 (UTC)
X-FDA: 84614415018.08.2058DF2
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2DD80180015
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:14:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GCgY7W2u;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775153648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkczfxtSF84VSlTks10/GwIlblAMIDiieRoVjs+yTko=;
	b=uYKgx1MfKQOci8hueIVt+X7T2tz59DVveXlz5dwnM/Wv6ae8bNpfRcYxh5pD7fFl8W7WyQ
	sJeBcp9zehRAAmR9SIXaSsX2Go17vu+mydw9hJixFVr+z7VHAGsfTYmnaRwsxTAsrOEzBq
	2gQxaQ7o43bqlcbPz+7t8I8hbnKDtpw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GCgY7W2u;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775153648; a=rsa-sha256;
	cv=none;
	b=UyCXBN6SeaqI/nnHIAwkjtgNYOr8a3V4E/bdD7QsRMnC0+oA7e5OHsHE0VOYEJjI6ibEPm
	LcuDqhXIh5sFR7312wANfhjnrhPd5VjLcolsR9R/68x80IJ56wNe5BT7kKt9XUUlNOYQkO
	K045INgowMIM4WhxmllqQz+cWYjUs2k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775153646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xkczfxtSF84VSlTks10/GwIlblAMIDiieRoVjs+yTko=;
	b=GCgY7W2uOZ9JOJ9TKL9rwScooWJa3NSfsWsGckrshtUKYLwLenqw8/WjLx0Z4uA+sAWq/i
	MP9pHdN5k++FTE7QpoVImIQJ6P5w7BhPS+mm4Ls/yGqPdljUkJoVqO+6UMRhlpVlz5ICYl
	7egdHS89vNwD+WdCQpSsbvwFDNYj6ok=
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
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	wilts.infradead.org@kvack.org,
	"linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	leitao@debian.org, kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 4/4] mm: align file-backed mmap to exec folio order in thp_get_unmapped_area
Date: Thu,  2 Apr 2026 11:08:25 -0700
Message-ID: <20260402181326.3107102-5-usama.arif@linux.dev>
In-Reply-To: <20260402181326.3107102-1-usama.arif@linux.dev>
References: <20260402181326.3107102-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: rrmsnnu3g86yuw5kgiif56zob1hu4kzw
X-Rspamd-Queue-Id: 2DD80180015
X-Rspamd-Server: rspam09
X-HE-Tag: 1775153647-950491
X-HE-Meta: U2FsdGVkX1/lXNPvyPcpCtQiH4X8txxXfMvXZJSbAai1fV0yiUJDzfsB0TiuFBMEY37Rq9euH7fNkT/r9Gk+BUmiphTP6JRUX5O03a5ioSqn7Mn0f4Pq1X4EfefWwTkQY0KP2q4uYDM7hWJOZBiR4xO9awE/xWRfGUvXwd8/RrP1bE9jjYeprIDMUbeNFDA1fjSDts0n0M+XEddi0b2wtk48NU6Fhv5ahVvtM4w3coga/jOlldNUj+6+u4MvtLsKoOpAxJCc6ChnR62E0XGt36TcISyZji0M3ZA7Or9T3mTCGC1EPf2/IOK4P29BFAVL6a363Y6go350IV5MUTAI6fZK/RjcdjhpB9rctUItGzFWEM89c3pTLAvGuysNH8OPIVUz0G/b/sCNJXpyxJmgEYHnujO4z/RonQkLQJ62uk2oactuBCRYLwNYA74RHuhuGQRJyp+2lbQedWXsrj8AVxf0MiESKVbT5W/k7RHMLO87amb+R8JGYRzQQdU90tTXMSOI+euJ04oQT1UYw8Du5yw++pxfd0TyeE02WSzrpGtHzzsOtdc5/jKTP5vDimkHxiJtguTGXvIrRz6OZTjVAKij05S5SnMArYaD4tR6Ksq7Jt5IgoSz+N7pQPojgEFlevu4kqe/d5dc9Lv/NvLy7+Oj0+mZJhS/QrljBdn9g09XhryDKrz7HsJWf2bvROUuavN5OkHkjkT8C3Wtx5xTPV7s4Wr34WWss2B0dwSmi2MXYBiWCagV/aq/I5ME6T9WOU85g4Bs/YcOrm0pmQRWsfzlk8rfRCTtQa9CX+ZbHA7gEs2S/J1nP/plrrwZAFs0X7wGrtUwVVluRIHlHGcjK2KNH2DnLZ6glk0MIVzE8SQIyVCsK/50BOZWFelFp6Ct5/C+lc27UlQ0wWIG2tFvdueMx+swa0JVbvBsUarP59sfWDXFtrEgj+2MjoD9vzHNJxTs/qkorOg=
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
virtual addresses, preventing contpte mapping even when large folios are
allocated with properly aligned file offsets and physical addresses.

Add a fallback in thp_get_unmapped_area_vmflags() that uses
exec_folio_order() to determine alignment, matching the readahead
allocation strategy. This aligns mappings to the hardware TLB
coalescing size (e.g. 2M for contpte on arm64 64K pages, 64K for
contpte/HPA on arm64 4K/16K pages), capped to the mapping length via
rounddown_pow_of_two(len).

The fallback is naturally a no-op on architectures where
exec_folio_order() returns 0, and skips the retry when the alignment
would equal PMD_SIZE (already attempted above) incase another
architecture changes exec_folio_order() in the future.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b2a6060b3c20..ad97ac8406dc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1218,6 +1218,19 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 	if (ret)
 		return ret;
 
+	if (filp && exec_folio_order()) {
+		unsigned long exec_folio_size = PAGE_SIZE << exec_folio_order();
+		unsigned long size = rounddown_pow_of_two(len);
+
+		size = min(size, exec_folio_size);
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


