Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3020ECD6E60
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 10:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FFE26B030C; Mon,  1 Jun 2026 06:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8996B030D; Mon,  1 Jun 2026 06:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3153A6B030E; Mon,  1 Jun 2026 06:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21A2A6B030C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:22:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB5A91A05F9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:22:19 +0000 (UTC)
X-FDA: 84830953998.19.4575EE2
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 05AAE80004
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:22:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R7fgqcQV;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780309338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M9bUPwvZD9u+pXGLJ1fAR+BJ7vzqCtQEZJfnSjvNvKg=;
	b=jZP+j+5C3tjaewrFVTk79QnRtqwJzwApvVmoaEKOs5l8w5WqbyG1A5OKFuqqZAwpV2TH4s
	2PTC9WJCeew2V8UVgJhA+0vT5ikMfzZlTzmjvCAiUexXsxZ329ZQlCcaT8+kRQKVWTd6o0
	E4+iDXrAl2nB2XorDrstugma2j8cVzM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780309338; a=rsa-sha256;
	cv=none;
	b=VnTBCBb/Rx5HBgJhj0lyRRfl9THWSQWefX/x94RGxvGw/wF2iQJe85XI4BxwtWfHlRL0fA
	GcLSL7Ho4deXoia0eEHkRxcAylWUBOgeTaNyx0WhECFiYg0qlbIamcfReEVzQ7YA5UeOrf
	7GP3rPM+dJdD9Ovfw7HTtwHdCXOpgbw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R7fgqcQV;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780309335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=M9bUPwvZD9u+pXGLJ1fAR+BJ7vzqCtQEZJfnSjvNvKg=;
	b=R7fgqcQVY5jCgl30o6B3AMBNCnrDFm3oUwmQn/8UW8Noi8QzcZOUODBKPgofez/OUTwzR2
	aQBDsIkuDJJYBI5h743LyGgd5oSw/LMcXItwktw5q+FUUpCn07CYGIX5sfxSuPAUpqI4rM
	K2H1QMzqyvmkISqjU3CFTP434/VtYF8=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	willy@infradead.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org
Cc: pfalcato@suse.de,
	r@hev.cc,
	jack@suse.cz,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	dev.jain@arm.com,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	Liam R. Howlett <liam@infradead.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>,
	ziy@nvidia.com,
	hannes@cmpxchg.org,
	kas@kernel.org,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v7 0/2] mm: improve large folio readahead for exec memory
Date: Mon,  1 Jun 2026 03:21:16 -0700
Message-ID: <20260601102205.3985788-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: u3f6f5tpsgutqjpfdtq6n8kss83za76z
X-Rspamd-Queue-Id: 05AAE80004
X-Rspam-User: 
X-HE-Tag: 1780309337-966171
X-HE-Meta: U2FsdGVkX19nOVEr2nN6DYZ1QoShOk3HQ31JMSHjG404LFoQ9nQC/3wdvustmhjHfFRW89BIdcG9InEQlxaZlMkNrhh7fTxLc8rP5kbvKzya5/OjF/ZtDqaQs23S6nswwf/oNrTVt9S5jffXaSWT0uFlACE38rbDO8p/+6PTQ64hEhdpTr5Yg1ZIjg+QvitoOnw9m+10ObpPSNAkVHlav9QPYl2ejN6Iw94hUbNiZ5UbQYy+WpG52H846sDwN1ymfoOJF6oFytI2oWCblawkghqeMIsCBxeE/WktDiny3LCVBVnkQV1yJKRpsKZGuVSNz2UuTRcdECZK6bLtLo6w2pXX/QDWJyPzNCRLCDuqLXVaLwBgbxBx+tdw2RL1RFO9SJHj9yYlGCSw3uNAAiYn1ftkRku3cKeG8pWaNxb6oplbW5Ql2waUpaBcJyHcAJK1A2ApTpM7BDcePfe3kfYaL5h+ZXXVQVHpD/Zb00XDdrv/VXIhgo2wEh5+CIrqJR+nnipkjDHprvtYvJpQl5dnVkJwDvMV/oEWOk0DYOvasPkg8AXQuePhCAIjndf59m14056OOv6J+Jtd29atwzRNXHDIZKJ8EyxAo3K2gPWnDOUmTcJomrPML6VzSe8034Nt4AV3kVk9L6qDYUwY2s1g58kRLfos0UOB6mV/QWazeP7VrYcea+FwNc5SVuvk1aaameLDPU4F+OcL2V1W3/IIEZvnHT2izfF5XEfEmnXL8W7ogNJIbk6JNZsyGHIO2yPB0QEbukB7IHMmGH9xpoNKfNEOVJHxTDRRs69q+EU3JF0Xh4gqLK3qNRa37vbFbeKvxBxvrsoRskQLMqcQsGZ4fCecHnnjuKJgGp6TWz4XD4sXqbgkNRQXytfht7Kezg91FUdMRF0I712N7lb6SLqLYnKEarCeXdJ0MRzN3W91vcHn9XAUTf6EgUK09liivQOrsLUKB9xY3QwZ5wKdwff
 3vp0FHr3
 uf6h6MnKrskpocAMYJPrpGWXjbYUxOJEw0NNAiOoH5TjdkaT3m7aGd6+WeWGWDaXDpSNz5o2CL5A9qe5c+xWh7PB0AD5odK7786WfMAKfio97StqifwQ7oDA6LSubtBRW1a9sxv6/mvn/GVFap+ethvT1kHMnB5qobU7cCYezj7DeIXHI30QVrxW/etBom138XJmFBCete38UK0fvTeBROi01VYeBsu14vrhclRTT0nPgvOU7R3TYdRJbnjTb5I+hKyG8Oj+t8o2w55q4B2AfyTN9WczZ45sFT0I5ezaLqFAundo0TqieuSuNLAz/Lvmainvo5xHSlZ4YPj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hopefully this is the last revision. The only change from the previous
revision is that the logic for deciding THP order was simplified and
the max is now capped to 2M. Thanks Pedro and Jan for the suggestion
and the dicusssion!

The benchmark results on Neoverse V2 (Grace), arm64 with 64K base pages,
512MB executable file on ext4, averaged over 3 runs:

  Phase      | Baseline     | Patched      | Improvement
  -----------|--------------|--------------|------------------
  Cold fault | 83.4 ms      | 41.3 ms      | 50% faster
  Random     | 76.0 ms      | 58.3 ms      | 23% faster

The patches are on top of mm-unstable from 28 May
(8a74e22643189e0ae339afc91110ddb4cab1941b) which include patch [1]
that make mmap_miss accounting symmetric for VM_SEQ_READ which was pointed
out by sashiko in the previous revision.

[1] https://lore.kernel.org/all/20260525145751.2671248-1-usama.arif@linux.dev/ 

v6 -> v7: https://lore.kernel.org/all/20260528165635.2068012-1-usama.arif@linux.dev/
- Simplify logic and just cap the max THP order to 2M (Pedro and Jan)

v5 -> v6: https://lore.kernel.org/all/20260522162422.3856502-1-usama.arif@linux.dev/
- Based on top of patch [1] (sashiko)
- Changes to commit message to make it more accurate for patch 1 and skip
  mmap_miss decrement as well. (sashiko)
- Keep old behaviour if large folio mappings is not enabled (sashiko).
- sashiko pointed to a TOCTOU data race that was pre-existing. My patch
  could make it worse. Dont make it worse by introducing thp_order local
  variable.

v3 -> v5: https://lore.kernel.org/all/20260402181326.3107102-1-usama.arif@linux.dev/
- (Looks like I messed up the versioning here and went directly form
  v3 to v5.)
- Drop patches for elf thp unmapped area alignment and deal with them
  separately. These patches will just bring folios smaller than PMD
  at the same level as PMD. The 2 patches now should be much easier
  to merge.
- Tackle size of THP for exec pages at the same point as PMD instead
  of tackling using exec_folio_order() (Ryan during LSFMM, Thanks!)

v2 -> v3: https://lore.kernel.org/all/20260320140315.979307-1-usama.arif@linux.dev/
- Take into account READ_ONLY_THP_FOR_FS for elf alignment by aligning
  to HPAGE_PMD_SIZE limited to 2M (Rui)
- Reviewed-by tags for patch 1 from Kiryl and Jan
- Remove preferred_exec_order() (Jan)
- Change ra->order to HPAGE_PMD_ORDER if vma_pages(vma) >= HPAGE_PMD_NR
  otherwise use exec_folio_order() with gfp &= ~__GFP_RECLAIM for
  do_sync_mmap_readahead().
- Change exec_folio_order() to return 2M (cont-pte size) for 64K base
  page size for arm64.
- remove bprm->file NULL check (Matthew)
- Change filp to file (Matthew)
- Improve checking of p_vaddr and p_vaddr (Rui and Matthew)

v1 -> v2: https://lore.kernel.org/all/20260310145406.3073394-1-usama.arif@linux.dev/
- disable mmap_miss logic for VM_EXEC (Jan Kara)
- Align in elf only when segment VA and file offset are already aligned (Rui)
- preferred_exec_order() for VM_EXEC sync mmap_readahead which takes into
  account zone high watermarks (as an approximation of memory pressure)
  (David, or atleast my approach to what David suggested in [1] :))
- Extend max alignment to mapping_max_folio_size() instead of
  exec_folio_order()
 
Usama Arif (2):
  mm: bypass mmap_miss heuristic for VM_EXEC readahead
  mm: use mapping_max_folio_order() for force_thp_readahead order

 mm/filemap.c | 44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

-- 
2.52.0


