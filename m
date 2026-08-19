Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0595C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 15:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8927C6B008A; Wed, 19 Aug 2026 11:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A226B008C; Wed, 19 Aug 2026 11:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A6C16B0092; Wed, 19 Aug 2026 11:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 590C96B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:10:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D653AA0141
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:10:47 +0000 (UTC)
X-FDA: 85118356134.12.80F6A95
Received: from mta0.migadu.com (out-92.mta0.migadu.com [91.218.175.92])
	by imf10.hostedemail.com (Postfix) with ESMTP id 96EFBC0006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:10:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XUXl1z2X;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.92 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787152246;
	b=A89i8VYTdq/b1mJIZEHg+2J1GcxoMcNR2rKmC+MvQxOBdWwl5ool6Anc9sMj9WzVzVCwXN
	FC+XfoYG/YDnPwf/eiKRrxQyprpoYYBAQjcFraYte5Ri2xvvNaPP0niDOge4f7epL0Va4s
	UJ2R9qNCgRLGnZGh5/JoJMMA2+UR3/w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XUXl1z2X;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.92 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787152246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pfJXArWGZ0VilI71+i2usfYJnCRvWz5zNQuFRympzo4=;
	b=HZwO3QLh74v7pKSiGEBSTPJaY7qjAjZJUwCy90g8i1C+bIhnbLpVU5qvzBBQlfSvoZjPbF
	XGq50Kaop22KqSVkAUEWwyinoZ+1PRp0T0qUcWGb4c8L8kXMgze4ceOn8v4YHyJVsyK//Z
	fbxHMtpfz/azuZZfuqdNNUi0gTVKn70=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=woV3sD+KTiQrdkyYXaaM7Lt9p8FafyPCmggpFU9FmrM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787152243; v=1; x=1787757043;
 b=XUXl1z2X3qnYUgt8Hia9hE60DrN3NbxwBrtZtoEIN2L7HMWn3yXvKW2i7D0twIQIXfNAa2I8
 lJeA3tcU8Ugez2bw3I4Hy4X83C57VDBLWOKXZcRRGTWgQnLw96F/klIm15b1Lvtq+o9nHRh3kUG
 0vxOo6PhkwHv7ephmjak3IwU=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id e4f920fde1b953f9;
	Wed, 19 Aug 2026 15:10:43 +0000
X-Mizu-Trace-ID: e4f920fde1b953f9
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: usama.arif@linux.dev
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	kas@kernel.org,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio on zap
Date: Wed, 19 Aug 2026 23:10:34 +0800
Message-Id: <20260819151034.62640-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260819101222.3732660-1-usama.arif@linux.dev>
References: <20260819101222.3732660-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 96EFBC0006
X-Rspam-User: 
X-Stat-Signature: fj1y8imuru8139yhmpm1nssquugmtz7h
X-Rspamd-Server: rspam06
X-HE-Tag: 1787152245-244426
X-HE-Meta: U2FsdGVkX19P8S99dbbCzPbCrselSw01w38Qphbdr9WuSqUNV1MBNUllfQIXosFJyK8uUVTfoorT2gZNKijzAsOB8miaW1YAabROGzKtjMIA9jPYvC2ni8WdxJ0vqHGEJyceFP80VLyiLKtJkv9XTVxTKDCuJuuOm6+kuK5fk66LJl3OB5XCCP//0Cs6M6/9X6GT6zrWc/6OzKlhJeDt9bnr/SdvESLnItJgm4ngE+O9FHLphlMaCOu5DMFsiyU9e73nO9M50CX2E6TUazQH3YxrBanpj+xbXagcC5mcwHmDuUjIAXb6+TNObcxFamRCVP5XEqpR5weLkpkgdkgI6Bvps7ropTjeEEQcoP98hhdQoBp9wf/Rnk1ObiXNYrZci6U1oNPpt1g8oHb0mp6iJxozRlbRR8VI/xWvIENfFm/s5yCEM5z13XTC4/S2gKG5Jg5xSh+TPwRUdXpYkOCtrC8pNg4flBAsQHJFV0SlzOLUdSbtqbBqy0BIxl5fnJqMJx+2d1eL9NOvhIMzHueJ5zOAAtTlor+EwmzBJDrYubH16S2uOqnepkZe5vyCHKpdRQL36XZCwEqyoX02PX2G2k7XtJaUliyUK5B1keCRecamBm3SoBaMafaPEBjQLaoyUNvJIuajmnTXUDwHa6E1rHVuGdxZXKUbhoMF3kYJe5F3RB/R+yVMZm3dB2LH60CTH/9Kq7/5wc4HY/dyrUSlftcZHeLpEYDPz/vbrBvj/XAmQNJNDOl+U54k6R2arEJSqVh8We3N2m0a6SfH8lmqKxLkiX2ZCvWFFGR0bvCFLwBI4BEIdN+CWHu4EoDPiJ3c9Gk4adN0RJgih1laxdkINkoBXObKtoE70EcplXTOQ3FH2QmjEGLNR0kWRwA3xNtRntifU8qn+KaMdSphkG8F2LZqZqmVfVMvMDnUBUk9kymzDq82zRgQzxSkaMUASCaQa3Q05BvOQOBHpw3aUZx
 hrGf359+
 bjl/cYDwB5zVnZ7aRcyIP1BQqwk2mkHpNgCmxe16N0CI+X3tyJpCSS6FD30uRdou+DYzxMjCkbXENCfHYIQ5drU43iQtYFiF5JP9rv9QynAFrLNqEfYkVeelNvUuAC+n7UB2y2F5CxWZRrRSddnRoyHEgtyuvluGjPoKwNsTUy3ICcy0nUjFiN1upNpmUjDRnxe05uWXfB7eRN/tTO3PtoDRql+ekB6DMt4dTIxm76r/bl1Aa1i+091MHjwrmWn9AtXQMkETFfUgKmupmkzBoJdySuFJ3+fROMCmqwlPi7ZSn5yuWPlWJYTNEHFIJvTl4bOnvHRM1Vm1lS3jEbnU+zI9u7Vwg1Oyks+/Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Aug 19, 2026 at 03:12:22AM -0700, Usama Arif wrote:
>zap_huge_pmd_folio() propagates the pmd young bit to the folio for the
>file case, but not the dirty bit.  The pte path does propagate it, in
>zap_present_folio_ptes() and so does the pmd split path, in
>__split_huge_pmd_locked().
>
>For most file mappings the omission is harmless, because writing to a
>shared file mapping goes through page_mkwrite(), which dirties the
>folio.  tmpfs is different: it has no page_mkwrite(), and
>vma_wants_writenotify() is false for it, so a *read* fault on a
>MAP_SHARED tmpfs mapping installs a writable pmd via do_read_fault().
>do_read_fault() does not call fault_dirty_shared_page(), so subsequent
>stores through that mapping set only the hardware dirty bit in the pmd
>and never call folio_mark_dirty().  A shmem folio allocated by a fault
>is marked uptodate but not dirty (see the clear: block in
>shmem_get_folio_gfp()), so PG_dirty is never set at all.
>
>Unmapping such a folio - munmap(), or exit_mmap() when the process dies
>- then loses the only record that it was written, because zap_huge_pmd()
>drops the pmd without transferring the dirty bit.  Reclaim afterwards
>sees a clean shmem folio: the whole swap-out block in
>shrink_folio_list() is inside "if (folio_test_dirty(folio))", so
>pageout() is skipped and the folio falls into __remove_mapping().
>There, folio_is_file_lru() is false for a swapbacked folio, so no shadow
>entry is created and __filemap_remove_folio(folio, NULL) simply empties
>the i_pages slot.  The data is freed without ever being written to swap,
>and the next fault on that index returns a freshly zeroed folio.
>
>This is silent data loss for any process that keeps state in a
>MAP_SHARED tmpfs segment across an unmap - for example a cache handed
>from one process generation to the next through /dev/shm.  It requires
>the folio to be PMD-mapped, so it only shows up once shmem THP is
>enabled (which is what we did in Meta fleet and started noticing crashes);
>with THP off the pte path transfers the dirty bit correctly.
>It also only becomes visible when swap is enabled, because with no swap
>device shmem folios (which are on the anon LRU) are not scanned by
>reclaim at all, so the clean folio is never dropped.
>
>Reproduced on x86_64 with a tmpfs mounted huge=within_size: read-fault a
>2MB-backed region, write a known pattern through the resulting mapping,
>munmap, force reclaim of the cgroup, then re-map and read back.  Without
>this patch the region reads back as zeros and vmstat shows zswpout 0 -
>the data was discarded rather than swapped.  With this patch the region
>reads back correctly and the pages are swapped out as expected.  With
>huge=never, or when the first touch is a write, the test passes either
>way.
>
>Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Usama Arif <usama.arif@linux.dev>
>---

Good catch!

Tested-by: Lance Yang <lance.yang@linux.dev>

