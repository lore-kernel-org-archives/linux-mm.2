Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC757F30275
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AEAB6B036A; Mon, 16 Mar 2026 17:26:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45C416B0389; Mon, 16 Mar 2026 17:26:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B0C6B038B; Mon, 16 Mar 2026 17:26:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 218706B036A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:26:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6FA8C22AD
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:26:39 +0000 (UTC)
X-FDA: 84553210518.27.503CF7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 06C6F120002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:26:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pgFz+khZ;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773696398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=COioSvoeghfLO0zjc8Ulww2t75ZltS3O+b2TOmvYnRM=;
	b=NtP6oDZB0Wu6i1uuBVVmsu6hE5u1jTOb45sH33pKy7qaLWnv9xVk9QS2ldhAOP5nsHwnWU
	KMQGbsiZjyA8cIwddr+ZSkk3yx24A5fZNGyhOko1+wj3IyV/jp6DzapXVE9XcLH6eA+iOi
	ft23XIoH8oRd7Jk6To1EwoElTDR1xwg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pgFz+khZ;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773696398; a=rsa-sha256;
	cv=none;
	b=Ie3MJnWH8cBZq2rtTDuqhq/TZTlfUlBiA0f6dj9k3xWnK/vpl/UTM1nWeJ20+45cUEzjAx
	LrF73vSK2OTH13Brq4aMtHbYthRzt0DxTjza/RSO5yO3F/SviGXzhRpehYkmc51YM/uXdN
	sHRipjji0mEUul2ho0W36cMhHFI8kXU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 091B64189A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF188C19421
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773696396;
	bh=WFs31cP0FAGPrh0dD5dgulwo7IMdP/3LECK82xdchHY=;
	h=Date:From:To:Subject:From;
	b=pgFz+khZfPY9/zCEwpA9Z5aseb3oagCj+CWBkqRbSAwKKlkIVtWkGyt8ONhbwbWGQ
	 XfP+3iTlLTXa212iOf3Oc4sYcTzgxmb0whOxl9smJRZjz/CRXJx5HC3tGlGF+EqMTw
	 65rHRLUfS+oAB+OXY6woHmgDHd7vHe0f1ZWVvSU4=
Date: Mon, 16 Mar 2026 14:26:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Subject: mm.git review status at 7.0-rc4
Message-Id: <20260316142636.0c29d431b1c8bf03e01c3630@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 06C6F120002
X-Stat-Signature: uofc83u5wbgmbua5fg86374fbd1i1uc9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773696397-935090
X-HE-Meta: U2FsdGVkX191frdpm6gHuGpdZRVvXKKul06sYDwR+tjWb+zS+y+pszlMPU6ICfE6sBpxyDmpdK4GGZI/ZZQZ+pSAf8qL5O5ZMqmimYQR+BH2ENpZjpVD5poFCc6V6aheAA0UcO2OpJi89ZfWyZMcOZAXoUSwnsfe/YpSpJxPlrCMNchlOXfTJb6RTUsaJEu/MP1+Cq/zJZGIWZnlG2uApWe/HFYg3t5O3D18n2+WZYDH1HXYIFVnnLhsRwc5CY7T/N8cgRbOJT29HM3NmhskqTqWeJVT+p70QXxAABbJFb6GtGDXJBOx2lH9OncXhfiyEQiklnYVOXjcZg5ga0mbSGu1d2QgvfNygjZAApT3ijnWeaNnttc7WYyFMl6RgWCZKnve/qgVGr+Fu++XBb9R9iiIbrSpHDL3bh32EKctcRqLO4GcGW6yvCa2utfDaFS629buM09E6Oaok8kVS7z0115IVaUfFZZvWGbiTL7pmTa/u26Yta6xwtOdyDS+Ss5m91RF5kmNRXnOecxha/pjoq/EoQGYQcfDo316+xBX3GCxcieY/EI39FOPY579h4Jf4otPTTWMis1sAMj4A5hSg01S8PeIgHyYhFNbnkeMCh9qNc9UTTYd+0V1AlUAKTcI3dttVUjRAmCBNO2nZSRv3tLzMTglSOAk5zvwjQae6PU5mxXMMLq18Bggnrua27TmKw6xCPavNSGhMrtOKZntgkhhz7/NNgkVvKQWRYTq7FtBLZM1btJ0ILOgHzl/eoJKegxcqXJS6qCAQXj6ytQe+h1h6Pv4mFBCK6rPLElz4zaEkaCZJG7XO5wQEZgFqOcq8mXjMoTqMqckArwlwjz1EmfRMs++zvFPHDKowAMe36NMmhf70UP0CYAYTLpr2EKYpu0+wq8XBGXQxua1leJNPTWXwhG85xAf4GtEmI4jUgfr1HCwogtrTjrN3SrmpmHtIZDI5fYT2HhDi5vhL69
 LoHVBLfu
 eVEANlu7oBwP65adFnMq8ACdIFm8VUSzgT7lAwW6/JwEEGd2bOXbsGMSurWPkSv9GmVvvYGUxBAt8utbGJ4E8EdyXifW0LhXOaL/CbNm09NA+yKLC5PB/nZghkJrTv6T+zSx+dOzrSVzquhI5dlDg7pIVd96diiQpP5syAkU8Y4z8a6F1g1zOK9wzb8b9j/ey6C9j7PDsQTOsR5VI7eh7g+gMSjsorJ8COOrlQ7WMtoI3XfeWE2bV4O3pWwXOyzifTE4Ldkq3t4gtW8DdJ17std9AWl4qR3hG+1AKEoPkPskqmYTrsTFwuer36Q8Y9nmAw0xpDtxxB2eBgft6y886r/QUJv25PvpO7byF/wn8sjOJfuxTlwq7fjpo/dgEWZg62jpMNhVZYVFFhDyvKp2tB7kVdiDtT6Aw14xM5eIBZNst4kRyBtAJ7V5rcGKrN/ECSBpqSyMWMabl9qz9NPxEMhgrCtSSXbljL4lFyGrBNcmd0ukDJc82Xl+DB+2gFLsseVH2x+IxYlFJtxjJwAFin4s7KpWy5VDGoZbBP8YN80zjd940ThZWNcv6PXKSslepmFXPRixA1vJUnpAmJPeejyjCkXGw7JYM3/nLY8Slg0qOZqWnA0B4WJqHBiq8VkJ2o//oZMwoHrAmRxm+GbBR0Yf30ovxZtMO+zvzYZ03/Hdw9mOfAFrRTd/Bhnblmg0cEyTmiuJJKyaIy2R4E3S9/URwx+hIm2a1TaJe4tiVkJoueTh2+5O4mpJIkDVCcsy8xJs3w8Tlhsek+10BEgvXXfdCkf2Yn0X3RUuKUOIzD+sovZhxzMqgY8CGiFG/o4yXQayWfNFpGEAMlpCMTnDo8WQSfqOyDW5B529HxkyYpglM9CY7C94XvxUxoMkxIftA8YE1i+dcD4m3oCOAwKmlBtPuSrvhnVWlPDsiDSQX0p1AxbzO9szUWIhdfMuUlDtPEgy0x2Z8OpBFCbbglr4ib6XP3rRU
 riiaaPrU
 QFNySMNa36CiacPFmVSaL3xmbQu4Ng7hVvcpxSlV8p2Fob3DDad/qtXp+KrD4OdmjhFctLcm9xo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



~370 patches is a little more than we usually send for the merge
window.  I don't think it's quite time to close the door (-rc4 is
early!) but I do ask that we slow down on the new material and move
attention more towards testing and reviewing the material we already
have.

As is common, we have a number of quite large series from
basically-sole-developer sources (DAMON as always, maple_tree this
time).  That's how it goes.

But the remaining review coverage of 72% is somewhat low, so could
people please eyeball the below list, identify things with which you
can help and leap in there?

Thanks.



mm.git review status for linus..mm-new

Everything:

Total patches:       392
Reviews/patch:       1.44
Reviewed rate:       59%

Excluding DAMON:

Total patches:       346
Reviews/patch:       1.60
Reviewed rate:       65%

Excluding DAMON and zram:

Total patches:       337
Reviews/patch:       1.63
Reviewed rate:       65%

Excluding DAMON, zram and maple_tree:

Total patches:       305
Reviews/patch:       1.80
Reviewed rate:       72%



Unreviewed patches by author:


Andrew Morton <akpm@linux-foundation.org> (4 total)
    "maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes"
    "mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix"
    "mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix"
    "mm-page_reporting-add-page_reporting_order_unspecified-fix"

Arnd Bergmann <arnd@arndb.de> (1 total)
    "mm/vmscan: avoid false-positive -Wuninitialized warning"
        Link: https://lkml.kernel.org/r/20260213123902.3466040-1-arnd@kernel.org

Audra Mitchell <audra@redhat.com> (1 total)
    "selftests/mm: fix soft-dirty kselftest supported check"
        Link: https://lkml.kernel.org/r/20260218184210.206466-1-audra@redhat.com

Andrei Vagin <avagin@google.com> (1 total)
    "userfaultfd: fix lock leak in mfill_get_vma()"
        Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com

Baolin Wang <baolin.wang@linux.alibaba.com> (1 total)
    "mm: add a batched helper to clear the young flag for large folios"
        Link: https://lkml.kernel.org/r/23ec671bfcc06cd24ee0fbff8e329402742274a0.1772778858.git.baolin.wang@linux.alibaba.com

Chengkaitao <chengkaitao@kylinos.cn> (2 total)
    "sparc: use vmemmap_populate_hugepages for vmemmap_populate"
        Link: https://lkml.kernel.org/r/20260201063532.44807-2-pilgrimtao@gmail.com
    "mm: convert vmemmap_p?d_populate() to static functions"
        Link: https://lkml.kernel.org/r/20260201063532.44807-3-pilgrimtao@gmail.com

Chris Down <chris@chrisdown.name> (1 total)
    "selftests/mm: add UFFDIO_MOVE huge zeropage PMD regression test"
        Link: https://lkml.kernel.org/r/aaBWG4fajXXbjpVN@chrisdown.name

David Hildenbrand (Arm) <david@kernel.org> (4 total)
    "mm: centralize+fix comments about compound_mapcount() in new sync_with_folio_pmd_zap()"
        Link: https://lkml.kernel.org/r/20260223163920.287720-1-david@kernel.org
    "mm/pagewalk: drop FW_MIGRATION"
        Link: https://lkml.kernel.org/r/20260227212952.190691-1-david@kernel.org
    "fixup: mm/memory: remove zap_details parameter from zap_page_range_single()"
        Link: https://lkml.kernel.org/r/8a27e9ac-2025-4724-a46d-0a7c90894ba7@kernel.org
    "mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix"
        Link: https://lkml.kernel.org/r/f7732d1c-0e85-4a14-948a-912c417018b5@kernel.org

Dmitry Ilvokhin <d@ilvokhin.com> (2 total)
    "mm: fix remaining zone->lock references"
        Link: https://lkml.kernel.org/r/aabvc4Xhc9qBfaG7@shell.ilvokhin.com
    "mm: documentation: standardize on "zone lock" terminology"
        Link: https://lkml.kernel.org/r/aanSnywUXTVPaYUj@shell.ilvokhin.com

Jane Chu <jane.chu@oracle.com> (1 total)
    "Documentation: fix a hugetlbfs reservation statement"
        Link: https://lkml.kernel.org/r/20260302201015.1824798-1-jane.chu@oracle.com

Jianhui Zhou <jianhuizzzzz@gmail.com> (1 total)
    "mm/userfaultfd: fix hugetlb fault mutex hash calculation"
        Link: https://lkml.kernel.org/r/20260310110526.335749-1-jianhuizzzzz@gmail.com

Nikita Kalyazin <kalyazin@amazon.com> (3 total)
    "KVM: guest_memfd: implement userfaultfd operations"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-14-rppt@kernel.org
    "KVM: selftests: test userfaultfd minor for guest_memfd"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-15-rppt@kernel.org
    "KVM: selftests: test userfaultfd missing for guest_memfd"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-16-rppt@kernel.org

Kiryl Shutsemau <kas@kernel.org> (2 total)
    "riscv/mm: align vmemmap to maximal folio size"
        Link: https://lkml.kernel.org/r/20260227194302.274384-6-kas@kernel.org
    "LoongArch/mm: align vmemmap to maximal folio size"
        Link: https://lkml.kernel.org/r/20260227194302.274384-7-kas@kernel.org

Kairui Song <kasong@tencent.com> (1 total)
    "mm, swap: speed up hibernation allocation and writeout"
        Link: https://lkml.kernel.org/r/20260216-hibernate-perf-v4-1-1ba9f0bf1ec9@tencent.com
        Link: https://lore.kernel.org/linux-mm/8b4bdcfa-ce3f-4e23-839f-31367df7c18f@gmx.de/ [1]

Liam R. Howlett <Liam.Howlett@oracle.com> (30 total)
    "maple_tree: fix mas_dup_alloc() sparse warning"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-1-Liam.Howlett@oracle.com
        Link: https://lkml.kernel.org/r/20260130205935.2559335-2-Liam.Howlett@oracle.com
    "maple_tree: move mas_spanning_rebalance loop to function"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-3-Liam.Howlett@oracle.com
    "maple_tree: extract use of big node from mas_wr_spanning_store()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-4-Liam.Howlett@oracle.com
    "maple_tree: remove unnecessary assignment of orig_l index"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-5-Liam.Howlett@oracle.com
    "maple_tree: inline mas_spanning_rebalance() into mas_wr_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-6-Liam.Howlett@oracle.com
    "maple_tree: make ma_wr_states reliable for reuse in spanning store"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-7-Liam.Howlett@oracle.com
    "maple_tree: remove l_wr_mas from mas_wr_spanning_rebalance"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-8-Liam.Howlett@oracle.com
    "maple_tree: don't pass through height in mas_wr_spanning_store"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-9-Liam.Howlett@oracle.com
    "maple_tree: move maple_subtree_state from mas_wr_spanning_store to mas_wr_spanning_rebalance"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-10-Liam.Howlett@oracle.com
    "maple_tree: correct right ma_wr_state end pivot in mas_wr_spanning_store()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-11-Liam.Howlett@oracle.com
    "maple_tree: introduce maple_copy node and use it in mas_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-12-Liam.Howlett@oracle.com
    "maple_tree: testing update for spanning store"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-13-Liam.Howlett@oracle.com
    "maple_tree: inline mas_spanning_rebalance_loop() into mas_wr_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-14-Liam.Howlett@oracle.com
    "maple_tree: change initial big node setup in mas_wr_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-15-Liam.Howlett@oracle.com
    "maple_tree: introduce ma_leaf_max_gap()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-16-Liam.Howlett@oracle.com
    "maple_tree: add gap support, slot and pivot sizes for maple copy"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-17-Liam.Howlett@oracle.com
    "maple_tree: start using maple copy node for destination"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-18-Liam.Howlett@oracle.com
    "maple_tree: inline mas_wr_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-19-Liam.Howlett@oracle.com
    "maple_tree: remove unnecessary return statements"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-20-Liam.Howlett@oracle.com
    "maple_tree: separate wr_split_store and wr_rebalance store type code path"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-21-Liam.Howlett@oracle.com
    "maple_tree: add cp_is_new_root() helper"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-22-Liam.Howlett@oracle.com
    "maple_tree: use maple copy node for mas_wr_rebalance() operation"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-23-Liam.Howlett@oracle.com
    "maple_tree: add test for rebalance calculation off-by-one"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-24-Liam.Howlett@oracle.com
    "maple_tree: add copy_tree_location() helper"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-25-Liam.Howlett@oracle.com
    "maple_tree: add cp_converged() helper"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-26-Liam.Howlett@oracle.com
    "maple_tree: use maple copy node for mas_wr_split()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-27-Liam.Howlett@oracle.com
    "maple_tree: remove maple big node and subtree structs"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-28-Liam.Howlett@oracle.com
    "maple_tree: pass maple copy node to mas_wmb_replace()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-29-Liam.Howlett@oracle.com
    "maple_tree: don't pass end to mas_wr_append()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-30-Liam.Howlett@oracle.com
    "maple_tree: clean up mas_wr_node_store()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-31-Liam.Howlett@oracle.com

Lorenzo Stoakes (Oracle) <ljs@kernel.org> (29 total)
    "mm: rename VMA flag helpers to be more readable"
        Link: https://lkml.kernel.org/r/cover.1772704455.git.ljs@kernel.org
        Link: https://lkml.kernel.org/r/0f9cb3c511c478344fac0b3b3b0300bb95be95e9.1772704455.git.ljs@kernel.org
    "mm: add vma_desc_test_all() and use it"
        Link: https://lkml.kernel.org/r/568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org
    "tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix"
        Link: https://lkml.kernel.org/r/f6f396d2-1ba2-426f-b756-d8cc5985cc7c@lucifer.local
    "mm/mremap: correct invalid map count check"
        Link: https://lkml.kernel.org/r/cover.1773249037.git.ljs@kernel.org
        Link: https://lkml.kernel.org/r/73e218c67dcd197c5331840fb011e2c17155bfb0.1773249037.git.ljs@kernel.org
    "mm: abstract reading sysctl_max_map_count, and READ_ONCE()"
        Link: https://lkml.kernel.org/r/0715259eb37cbdfde4f9e5db92a20ec7110a1ce5.1773249037.git.ljs@kernel.org
    "mm/mremap: check map count under mmap write lock and abstract"
        Link: https://lkml.kernel.org/r/18be0b48eaa8e8804eb745974ee729c3ade0c687.1773249037.git.ljs@kernel.org
    "mm/vma: add vma_flags_empty(), vma_flags_and(), vma_flags_diff_pair()"
        Link: https://lkml.kernel.org/r/cover.1773665966.git.ljs@kernel.org
        Link: https://lkml.kernel.org/r/ede9b0f8a2e2dc72e7fbc1a0ddbeb513364c28a2.1773665966.git.ljs@kernel.org
    "tools/testing/vma: add unit tests flag empty, diff_pair, and[_mask]"
        Link: https://lkml.kernel.org/r/1d789fcc7dba9f93ec844aa87a48b13451dba211.1773665966.git.ljs@kernel.org
    "mm/vma: add further vma_flags_t unions"
        Link: https://lkml.kernel.org/r/a37030f2eefc90147e84f9273e325cc289cb9e1d.1773665966.git.ljs@kernel.org
    "tools/testing/vma: convert bulk of test code to vma_flags_t"
        Link: https://lkml.kernel.org/r/54d2f092b55e29e53916862faa191854b441d8e9.1773665966.git.ljs@kernel.org
    "mm/vma: use new VMA flags for sticky flags logic"
        Link: https://lkml.kernel.org/r/005cac3e37830a33f473edc780a5dae5e00a3845.1773665966.git.ljs@kernel.org
    "tools/testing/vma: fix VMA flag tests"
        Link: https://lkml.kernel.org/r/42b963d3229ed39a758f1bea218fd274a7cd3811.1773665966.git.ljs@kernel.org
    "mm/vma: add append_vma_flags() helper"
        Link: https://lkml.kernel.org/r/756b9c46ee23e00c2fe64d453ff61dd3b98aa3fc.1773665966.git.ljs@kernel.org
    "tools/testing/vma: add simple test for append_vma_flags()"
        Link: https://lkml.kernel.org/r/8253a553f354e6ef9b1ddea4831c0033e64eb796.1773665966.git.ljs@kernel.org
    "mm: unexport vm_brk_flags() and eliminate vm_flags parameter"
        Link: https://lkml.kernel.org/r/ba7d1eae0208551c05f4a2015133b926d6650484.1773665966.git.ljs@kernel.org
    "mm/vma: introduce vma_flags_same[_mask/_pair]()"
        Link: https://lkml.kernel.org/r/393378bdcbb49141304d5eff7b8dad2966b73c30.1773665966.git.ljs@kernel.org
    "mm/vma: introduce [vma_flags,legacy]_to_[legacy,vma_flags]() helpers"
        Link: https://lkml.kernel.org/r/19cfb4297cb691dc16c75e9e6a24f6564743407e.1773665966.git.ljs@kernel.org
    "tools/testing/vma: test that legacy flag helpers work correctly"
        Link: https://lkml.kernel.org/r/4f1956b7e1e15293f75bffb5eda3d967a1da6f5d.1773665966.git.ljs@kernel.org
    "mm/vma: introduce vma_test[_any[_mask]](), and make inlining consistent"
        Link: https://lkml.kernel.org/r/8aeaf08d153c3c3196855fdc9ddbacccf673ef82.1773665966.git.ljs@kernel.org
    "tools/testing/vma: update VMA flag tests to test vma_test[_any_mask]()"
        Link: https://lkml.kernel.org/r/ecd6e0134c4495310d6914b8177e99886e17d22f.1773665966.git.ljs@kernel.org
    "mm: introduce vma_flags_count() and vma[_flags]_test_single_mask()"
        Link: https://lkml.kernel.org/r/96e7481026067766bfd7f2d4e395dd89ce845ab2.1773665966.git.ljs@kernel.org
    "tools/testing/vma: test vma_flags_count,vma[_flags]_test_single_mask"
        Link: https://lkml.kernel.org/r/140b9b77da1ef463f969cbeb2b5fb25627301cd6.1773665966.git.ljs@kernel.org
    "mm: convert do_brk_flags() to use vma_flags_t"
        Link: https://lkml.kernel.org/r/063af0422d99bee0195589aa63f8f44edaf409fa.1773665966.git.ljs@kernel.org
    "mm: update vma_supports_mlock() to use new VMA flags"
        Link: https://lkml.kernel.org/r/2f82b5b93599e89b391ee4672928cefdfd2fb2f8.1773665966.git.ljs@kernel.org
    "mm/vma: introduce vma_clear_flags[_mask]()"
        Link: https://lkml.kernel.org/r/397c67b154a4868e19db9be1012e976148901de2.1773665966.git.ljs@kernel.org
    "tools/testing/vma: update VMA tests to test vma_clear_flags[_mask]()"
        Link: https://lkml.kernel.org/r/65bc0bbd98698f4dc68c046e6f867274b1497d8a.1773665966.git.ljs@kernel.org
    "mm/vma: convert as much as we can in mm/vma.c to vma_flags_t"
        Link: https://lkml.kernel.org/r/4d938877d17158a74858af98a6e5bf5d93292fc1.1773665966.git.ljs@kernel.org
    "mm/vma: convert vma_modify_flags[_uffd]() to use vma_flags_t"
        Link: https://lkml.kernel.org/r/0737c1b5e3b3688ec3839058b95203c9e7622de9.1773665966.git.ljs@kernel.org
    "mm/vma: convert __mmap_region() to use vma_flags_t"
        Link: https://lkml.kernel.org/r/0dfdae451f825437e042db9b434a7d509dce6841.1773665966.git.ljs@kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> (3 total)
    "lib: introduce hierarchical per-cpu counters"
        Link: https://lkml.kernel.org/r/20260227153730.1556542-1-mathieu.desnoyers@efficios.com
        Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
        Link: https://lkml.kernel.org/r/20260227153730.1556542-2-mathieu.desnoyers@efficios.com
    "lib: test hierarchical per-cpu counters"
        Link: https://lkml.kernel.org/r/20260227153730.1556542-3-mathieu.desnoyers@efficios.com
    "mm: improve RSS counter approximation accuracy for proc interfaces"
        Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
        Link: https://lkml.kernel.org/r/20260227153730.1556542-4-mathieu.desnoyers@efficios.com

Michal Clapinski <mclapinski@google.com> (1 total)
    "kho: fix deferred init of kho scratch"
        Link: https://lkml.kernel.org/r/20260311125539.4123672-1-mclapinski@google.com
        Link: https://lkml.kernel.org/r/20260311125539.4123672-2-mclapinski@google.com

Michal Hocko <mhocko@suse.com> (1 total)
    "vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY"
        Link: https://lkml.kernel.org/r/20260302114740.2668450-2-urezki@gmail.com

Josh Law <objecting@objecting.org> (1 total)
    "lib/maple_tree: fix swapped arguments in mas_safe_pivot() call"
        Link: https://lkml.kernel.org/r/20260306225849.2824409-1-objecting@objecting.org
        Link: https://lkml.kernel.org/r/20260306223219.2824040-1-objecting@objecting.org
        Link: https://lkml.kernel.org/r/20260306200820.2819999-1-objecting@objecting.org

Peter Xu <peterx@redhat.com> (1 total)
    "mm: generalize handling of userfaults in __do_fault()"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-13-rppt@kernel.org

Pratyush Yadav (Google) <pratyush@kernel.org> (2 total)
    "mm: memfd_luo: preserve file seals"
        Link: https://lkml.kernel.org/r/20260216185946.1215770-3-pratyush@kernel.org
    "kho: move alloc tag init to kho_init_{folio,pages}()"
        Link: https://lkml.kernel.org/r/20260213085914.2778107-1-pratyush@kernel.org

Xie Yuanbin <qq570070308@gmail.com> (2 total)
    "mm/debug: optimize once judgment with clang"
        Link: https://lkml.kernel.org/r/20260309153405.20130-1-qq570070308@gmail.com
    "mm: optimize the implementation of WARN_ON_ONCE_GFP()"
        Link: https://lkml.kernel.org/r/20260309153811.40958-1-qq570070308@gmail.com

Mike Rapoport (Microsoft) <rppt@kernel.org> (10 total)
    "userfaultfd: introduce struct mfill_state"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-3-rppt@kernel.org
    "userfaultfd: introduce mfill_get_pmd() helper"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-4-rppt@kernel.org
    "userfaultfd: introduce mfill_get_vma() and mfill_put_vma()"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-5-rppt@kernel.org
    "userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-6-rppt@kernel.org
    "userfaultfd: introduce vm_uffd_ops"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-8-rppt@kernel.org
    "userfaultfd: allow registration of WP_ASYNC for any VMA"
        Link: https://lkml.kernel.org/r/abG5HFV8yoEHOFkh@kernel.org
    "shmem, userfaultfd: use a VMA callback to handle UFFDIO_CONTINUE"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-9-rppt@kernel.org
    "userfaultfd: introduce vm_uffd_ops->alloc_folio()"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-10-rppt@kernel.org
    "shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-11-rppt@kernel.org
    "userfaultfd: mfill_atomic(): remove retry logic"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-12-rppt@kernel.org

Andrey Ryabinin <ryabinin.a.a@gmail.com> (1 total)
    "kasan: fix bug type classification for SW_TAGS mode"
        Link: https://lkml.kernel.org/r/20260305185659.20807-1-ryabinin.a.a@gmail.com

Sayali Patil <sayalip@linux.ibm.com> (3 total)
    "selftest/mm: fix cgroup task placement and tolerance in hugetlb_reparenting_test.sh"
        Link: https://lkml.kernel.org/r/3b5b4275fed509e13567bba7471a9130bbfa6841.1773305677.git.sayalip@linux.ibm.com
    "selftest/mm: register existing mapping with userfaultfd in hugepage-mremap"
        Link: https://lkml.kernel.org/r/da7ec96ee85ccfdb9bec704c6dd534b419212f94.1773305677.git.sayalip@linux.ibm.com
    "selftests/cgroup: extend test_hugetlb_memcg.c to support all huge page sizes"
        Link: https://lkml.kernel.org/r/e4e655c7d7c4e24b90d51530157d024854bff1cb.1773305678.git.sayalip@linux.ibm.com

Sergey Senozhatsky <senozhatsky@chromium.org> (5 total)
    "zram: do not autocorrect bad recompression parameters"
        Link: https://lkml.kernel.org/r/20260311084312.1766036-3-senozhatsky@chromium.org
    "zram: drop ->num_active_comps"
        Link: https://lkml.kernel.org/r/20260311084312.1766036-4-senozhatsky@chromium.org
    "zram: update recompression documentation"
        Link: https://lkml.kernel.org/r/20260311084312.1766036-5-senozhatsky@chromium.org
    "zram: remove chained recompression"
        Link: https://lkml.kernel.org/r/20260311084312.1766036-6-senozhatsky@chromium.org
    "zram: unify and harden algo/priority params handling"
        Link: https://lkml.kernel.org/r/20260311084312.1766036-7-senozhatsky@chromium.org

Seongsu Park <sgsu.park@samsung.com> (1 total)
    "mm/pkeys: remove unused tsk parameter from arch_set_user_pkey_access()"
        Link: https://lkml.kernel.org/r/20260219063506.545148-1-sgsu.park@samsung.com

SeongJae Park <sj@kernel.org> (37 total)
    "mm/damon/core: set quota-score histogram with core filters"
        Link: https://lkml.kernel.org/r/20260227170623.95384-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260227170623.95384-2-sj@kernel.org
    "mm/damon/core: do non-safe region walk on kdamond_apply_schemes()"
        Link: https://lkml.kernel.org/r/20260227170623.95384-3-sj@kernel.org
    "mm/damon/core: split regions for min_nr_regions"
        Link: https://lkml.kernel.org/r/20260228222831.7232-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260228222831.7232-2-sj@kernel.org
        Link: https://lore.kernel.org/CAC5umyjmJE9SBqjbetZZecpY54bHpn2AvCGNv3aF6J=1cfoPXQ@mail.gmail.com [1]
    "mm/damon/vaddr: do not split regions for min_nr_regions"
        Link: https://lkml.kernel.org/r/20260228222831.7232-3-sj@kernel.org
    "mm/damon/test/core-kunit: add damon_apply_min_nr_regions() test"
        Link: https://lkml.kernel.org/r/20260228222831.7232-4-sj@kernel.org
    "mm/damon: add CONFIG_DAMON_DEBUG_SANITY"
        Link: https://lkml.kernel.org/r/20260306152914.86303-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260306152914.86303-2-sj@kernel.org
        Link: https://lore.kernel.org/20251231070029.79682-1-sj@kernel.org [1]
        Link: https://github.com/damonitor/damon-tests/commit/a80fbee55e272f151b4e5809ee85898aea33e6ff [2]
    "mm/damon/core: add damon_new_region() debug_sanity check"
        Link: https://lkml.kernel.org/r/20260306152914.86303-3-sj@kernel.org
    "mm/damon/core: add damon_del_region() debug_sanity check"
        Link: https://lkml.kernel.org/r/20260306152914.86303-4-sj@kernel.org
    "mm/damon/core: add damon_nr_regions() debug_sanity check"
        Link: https://lkml.kernel.org/r/20260306152914.86303-5-sj@kernel.org
    "mm/damon/core: add damon_merge_two_regions() debug_sanity check"
        Link: https://lkml.kernel.org/r/20260306152914.86303-6-sj@kernel.org
    "mm/damon/core: add damon_merge_regions_of() debug_sanity check"
        Link: https://lkml.kernel.org/r/20260306152914.86303-7-sj@kernel.org
    "mm/damon/core: add damon_split_region_at() debug_sanity check"
        Link: https://lkml.kernel.org/r/20260306152914.86303-8-sj@kernel.org
    "mm/damon/core: add damon_reset_aggregated() debug_sanity check"
        Link: https://lkml.kernel.org/r/20260306152914.86303-9-sj@kernel.org
    "mm/damon/tests/.kunitconifg: enable DAMON_DEBUG_SANITY"
        Link: https://lkml.kernel.org/r/20260306152914.86303-10-sj@kernel.org
    "selftests/damon/config: enable DAMON_DEBUG_SANITY"
        Link: https://lkml.kernel.org/r/20260306152914.86303-11-sj@kernel.org
    "mm/damon/tests/core-kunit: add a test for damon_commit_ctx()"
        Link: https://lkml.kernel.org/r/20260307194222.202075-2-sj@kernel.org
    "Docs/mm/damon/design: document the power-of-two limitation for addr_unit"
        Link: https://lkml.kernel.org/r/20260307194222.202075-3-sj@kernel.org
    "mm/damon/core: remove damos_set_next_apply_sis() duplicates"
        Link: https://lkml.kernel.org/r/20260307194915.203169-2-sj@kernel.org
    "mm/damon/core: use time_before() for next_apply_sis"
        Link: https://lkml.kernel.org/r/20260307194915.203169-3-sj@kernel.org
    "mm/damon/core: use time_after_eq() in kdamond_fn()"
        Link: https://lkml.kernel.org/r/20260307194915.203169-4-sj@kernel.org
    "mm/damon/core: introduce damos_quota_goal_tuner"
        Link: https://lkml.kernel.org/r/20260310010529.91162-2-sj@kernel.org
        Link: https://lore.kernel.org/CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com [1]
        Link: https://lore.kernel.org/20260204022537.814-1-yunjeong.mun@sk.com [2]
    "mm/damon/core: allow quota goals set zero effective size quota"
        Link: https://lkml.kernel.org/r/20260310010529.91162-3-sj@kernel.org
    "mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL"
        Link: https://lkml.kernel.org/r/20260310010529.91162-4-sj@kernel.org
    "mm/damon/sysfs-schemes: implement quotas->goal_tuner file"
        Link: https://lkml.kernel.org/r/20260310010529.91162-5-sj@kernel.org
    "Docs/mm/damon/design: document the goal-based quota tuner selections"
        Link: https://lkml.kernel.org/r/20260310010529.91162-6-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: document goal_tuner sysfs file"
        Link: https://lkml.kernel.org/r/20260310010529.91162-7-sj@kernel.org
    "Docs/ABI/damon: update for goal_tuner"
        Link: https://lkml.kernel.org/r/20260310010529.91162-8-sj@kernel.org
    "mm/damon/tests/core-kunit: test goal_tuner commit"
        Link: https://lkml.kernel.org/r/20260310010529.91162-9-sj@kernel.org
    "selftests/damon/_damon_sysfs: support goal_tuner setup"
        Link: https://lkml.kernel.org/r/20260310010529.91162-10-sj@kernel.org
    "selftests/damon/drgn_dump_damon_status: support quota goal_tuner dumping"
        Link: https://lkml.kernel.org/r/20260310010529.91162-11-sj@kernel.org
    "selftests/damon/sysfs.py: test goal_tuner commit"
        Link: https://lkml.kernel.org/r/20260310010529.91162-12-sj@kernel.org
    "mm/damon/core: fix wrong end address assignment on walk_system_ram()"
        Link: https://lkml.kernel.org/r/20260311052927.93921-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260311052927.93921-2-sj@kernel.org
        Link: https://lore.kernel.org/20260131015643.79158-1-sj@kernel.org [1]
    "mm/damon/core: support addr_unit on damon_find_biggest_system_ram()"
        Link: https://lkml.kernel.org/r/20260311052927.93921-3-sj@kernel.org
    "mm/damon/core: receive addr_unit on damon_set_region_biggest_system_ram_default()"
        Link: https://lkml.kernel.org/r/20260311052927.93921-4-sj@kernel.org
    "mm/damon/core: fix wrong damon_set_regions() argument"
        Link: https://lkml.kernel.org/r/20260314001854.79623-1-sj@kernel.org
    "mm/damon/reclaim: respect addr_unit on default monitoring region setup"
        Link: https://lkml.kernel.org/r/20260311052927.93921-5-sj@kernel.org
    "mm/damon/lru_sort: respect addr_unit on default monitoring region setup"
        Link: https://lkml.kernel.org/r/20260311052927.93921-6-sj@kernel.org

Thomas Ballasi <tballasi@linux.microsoft.com> (1 total)
    "mm: vmscan: add PIDs to vmscan tracepoints"
        Link: https://lkml.kernel.org/r/20260316160908.42727-4-tballasi@linux.microsoft.com

Thorsten Blum <thorsten.blum@linux.dev> (1 total)
    "crash_dump: don't log dm-crypt key bytes in read_key_from_user_keying"
        Link: https://lkml.kernel.org/r/20260227230008.858641-2-thorsten.blum@linux.dev

Muhammad Usama Anjum <usama.anjum@arm.com> (1 total)
    "mailmap: update email address for Muhammad Usama Anjum"
        Link: https://lkml.kernel.org/r/20260310171757.3970390-1-usama.anjum@arm.com

zenghongling <zenghongling@kylinos.cn> (1 total)
    "mm/percpu-internal.h: optimise pcpu_chunk_struct to save memory"
        Link: https://lkml.kernel.org/r/20260305073043.571691-1-zenghongling@kylinos.cn

Qi Zheng <zhengqi.arch@bytedance.com> (2 total)
    "mm: memcontrol: refactor mod_memcg_state() and mod_memcg_lruvec_state()"
        Link: https://lkml.kernel.org/r/7f8bd3aacec2270b9453428fc8585cca9f10751e.1772711148.git.zhengqi.arch@bytedance.com
    "mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix"
        Link: https://lkml.kernel.org/r/20260309112939.31937-1-qi.zheng@linux.dev



