Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5D9FCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 12:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AD3E6B0005; Wed, 10 Jun 2026 08:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E066B0088; Wed, 10 Jun 2026 08:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04C556B008A; Wed, 10 Jun 2026 08:06:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1DF46B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:06:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E9ED92D24
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:06:40 +0000 (UTC)
X-FDA: 84863876160.22.9DEF429
Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
	by imf25.hostedemail.com (Postfix) with ESMTP id 88D83A0015
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:06:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b="O2tky/i9";
	spf=pass (imf25.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781093198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kPqWRYyWVwdy7Z3isYgREa2Luu0j96af+q6XyLcr4Fg=;
	b=EDcqwI/LBh4DDYrfZxtwots5S4/xpyjXMpTltipFyTisP2f3Fal4RlXUJ1xEfHV1YCPLh6
	U9INrHqZfOKrH3MK8k3jqqqdxXxFTZ8XvK0Cb2cBGlka46TgWd/b39cnJBYS0ifHpnCYpO
	2VI/f291m+U5F93KFXlH6F+/qCg43/Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b="O2tky/i9";
	spf=pass (imf25.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781093198;
	b=CQcLU1mCjdgZ22MNeg9frTV016Xbi3XYbp+tDWGeh91wbHVaxduT+0GiND+tQCvv57sgx/
	6K4qsPwTYVQTn3c4k81Kk7TXq/GumfZ/3mEuzCueROLf1rsnlGABb0V8F/c2OUkU4ATR8h
	yckr2c+8o/SdmK0LHFLah17ONglVT1w=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTPS id 65AC5jJu085162
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 10 Jun 2026 20:05:45 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4gb4BC4wdfz2MZp3f;
	Wed, 10 Jun 2026 20:01:23 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Wed, 10 Jun 2026 20:05:42 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>,
        Barry Song <baohua@kernel.org>,
        Baolin Wang
	<baolin.wang@linux.alibaba.com>,
        Lance Yang <lance.yang@linux.dev>,
        "Liam R .
 Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang
	<huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios to LRU
Date: Wed, 10 Jun 2026 20:05:35 +0800
Message-ID: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 65AC5jJu085162
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1781093158;
	bh=kPqWRYyWVwdy7Z3isYgREa2Luu0j96af+q6XyLcr4Fg=;
	h=From:To:Subject:Date;
	b=O2tky/i9N7nXAfRbpfLOTm3yOS6wPxpuLvYRJbxzsxhefTldS9tFpkqFrkfbYEulf
	 Xo/Q9q/DFtML4Nv3Pm+8tMVkGsv87ZjUkIUVHLEttnBESMxsXCNcRmNYonWGiuiMxD
	 cE42ZlDYldtExFGnBbVS4hRcAYqxW1wvXV7zZiNanIdWHxc2CzMmB7E8aUoSDNP2UV
	 6//BRMy757NfVgaVGTwvLh36lz2SvrdG8CJbGZpcj1hKX6WOEWac/Ul2V1vk9+etLy
	 q+zIXquAEj9OiGVpq8lnUc8Z26AUcc42ZFHsXwmNgjtOCubHynZx1kfRyN4SzclIXY
	 kT1F9OKvgAktQ==
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 88D83A0015
X-Stat-Signature: 9kmtwb3hh3qj3nr8sryxwxa6g6mr6ot3
X-Rspam-User: 
X-HE-Tag: 1781093193-488542
X-HE-Meta: U2FsdGVkX1+ZKpDlP3au1d9p59gPDslJdaFGWJu1E1DvkGbDedH20dNsS/hAUtUbqzweMOytVMVnusS/JKxkQprKK3VKHoeEIBlzCVoWVCIepUKRs3HkmQgTY0hds1LSvV6HEu4OV67Ae9deVSlF3ylx5PayXVwXyXSpJ7wj0/lR7ThuYtctTgA1fw08eTDy/9QOprej1aM0vZ51frTpYlcWIMkRkfenuS1eGud9qKJbYl5u2r/mYlW42gr/WzDtUkiAvgPq3Zf+HgW0sjLZXrO05VszwTG0PezLSPvZu1c65eZPOUnin+yx+ejR8+ccb3QDm5vmwEAHuDCM96uIXWMrOx4VLlCQrsGuFBNjEiN4/mVZsrn4LBfChfX1yzUNW8NemMnF4+L7CccPUYoJjw2DA1cGanJv1Dth0KJtSyQNJPo0wcWLByj8O00/xYgjMgau7lm+tece/r6Igvuk/ngtJRNwujH6YwYPc0I1m09u7hZY5tWitCi9/61lNwDp4vO0WlRdUuJEOYevn8gQlA1oIVUPcmsTRqqXj3AsCkGaMdQZ/mG+KB/Q+4u0/PUjK2zQhDBSngqiwx3ONMIw0uhh1pr7Hm9wI5SwpculyHJgHLOviJjQPqJQb6JDSaJHRxKl72v1V1D8uBzQoK3+GuHpBZACvqoUTq3WDgbG0BWZLgPfl9yIF6VOCoRpZzZLJf06HyMsKEwuqxygcvZv3pLEMjRWhVoIzKoS2R6rs4QbPzx8dHf614s8LAz0GLK3UZhKOBKBu+s4wIpTGk+UdVmwWofqDzGKqG1yQ7lc2yo0IRtpWBFd9TBQx69Q9KnhcCS1CRQLSpFZ3X7tTWxBkofOCDFlK45XKmqiETKsRhro9cUeQVVOfMkHbnutMhG1v3wMe1ddbiFWWb2cOQ9hUCCjys6HjkITlROr5YRdERBmB86Q/RDj/8q6oDB+CCZJKcT1YjyDcggMQhJa4TC
 AtbmUM0A
 YaXLwhs9kAbFmWBG7kYRtDt8CDL8fuzXPwYSwh3qTBpNUQK4dS5K4y/jwhh0E5RC+AZO4tddVW557P5Q91YTQYLyRG4BnZO53wSnCffhi+Zh3uapFI0vd8If1NL9yxY1J5gA8ZOGPPK5ATrqBsudmGazKwYEXCPZ+nUv0Wbya8pRWiGiczawod945Qw8qs6wTA/7jIvuRVMRoeY4zgwoOCR+Ebs3ZeMERVQVoW1MdEMQcwB0bvk1wMWW2hfDf1OxzIJ7HIK8r7ngFip6rawL75CxSiTp7PNJtCb+qLpq2q6IBYTIpFriCgHLstFl5XuZBzXNBTY8WjgA8PyEKgDGRrVyQJqsqdMWT9EtoawCmjYMxltjEgXmS1TssPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

The kernel panics are keeping to be reported especially when the f2fs
partition get almost full. By investigation, we find that the reason is
one f2fs page got freed to buddy without being deleted from LRU and the
root cause is the race happened in [2] which is enrolled by this commit.
We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: remove
non-uptodate folio from the page cache in move_data_block").

There are 3 race processes in this scenario, please find below for their
main activities. However, by further investigation over the code, I
think there is a common race window for the truncated folios between
split_folio_to_order and folio_isolate_lru, where the folios lost the
refcount on page cache and remains the transient one of the split
caller, under which the folio could enter free path and compete with the
isolation process. This commit would like to suggest to have the folios
beyond EOF stay out of LRU.

Truncate:
The changed code in move_data_block() lets the GC path evict the tail-end
folio from the page cache through folio_end_dropbehind().  Once
folio_unmap_invalidate() removes the folio from mapping->i_pages, the
page-cache references for all pages in the folio are dropped.  The folio
is then kept alive only by temporary external references, which allows a
later split to operate on a folio whose subpages are no longer protected
by page-cache references.

Split:
After the page-cache references are gone, split_folio_to_order() can
split the big folio into individual pages and put the resulting subpages
back on the LRU.  For tail pages beyond EOF, split removes them from the
page cache and drops their page-cache references.  A tail page can then
remain on the LRU with PG_lru set while holding only the split caller's
temporary reference.  When free_folio_and_swap_cache() drops that final
reference, the page enters the final folio_put() release path.

Isolate:
In parallel, folio_isolate_lru() can observe the same tail page with a
non-zero refcount and PG_lru set.  It clears PG_lru before taking its own
reference.  If this races with the final folio_put() from the split path,
__folio_put() sees PG_lru already cleared and skips lruvec_del_folio().
The page is then freed back to the allocator while its lru links are
still present in the LRU list.  A later LRU operation on a neighboring
page detects the stale link and reports list corruption.

[1]
[   22.486082] list_del corruption. next->prev should be fffffffec10e0ac8, but was dead000000000122. (next=fffffffec10e0a88)
[   22.486130] ------------[ cut here ]------------
[   22.486134] kernel BUG at lib/list_debug.c:67!
[   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
[   22.488502] Tainted: [W]=WARN, [O]=OOT_MODULE
[   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
[   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
[   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
[   22.488539] sp : ffffffc08006b830
[   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000000000000000
[   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: fffffffec10e0ac0
[   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead000000000122
[   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffffffc080061060
[   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000000000000058
[   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000000000000003
[   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe85721f0e25f00
[   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65645f7473696c
[   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000000000000010
[   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 000000000000006d
[   22.488647] Call trace:
[   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
[   22.488661]  __folio_put+0x2bc/0x434
[   22.488670]  folio_put+0x28/0x58
[   22.488678]  do_garbage_collect+0x1a34/0x2584
[   22.488689]  f2fs_gc+0x230/0x9b4
[   22.488697]  f2fs_fallocate+0xb90/0xdf4
[   22.488706]  vfs_fallocate+0x1b4/0x2bc
[   22.488716]  __arm64_sys_fallocate+0x44/0x78
[   22.488725]  invoke_syscall+0x58/0xe4
[   22.488732]  do_el0_svc+0x48/0xdc
[   22.488739]  el0_svc+0x3c/0x98
[   22.488747]  el0t_64_sync_handler+0x20/0x130
[   22.488754]  el0t_64_sync+0x1c4/0x1c8

[2]
CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 (folio_isolate_lru)

F: pagecache refs = n
F: extra refs = GC + split
F: PG_lru set
move_data_block()
folio = f2fs_grab_cache_folio(F)
...
__folio_set_dropbehind(F)
folio_unlock(F)
folio_end_dropbehind(F)
  folio_unmap_invalidate(F)
    __filemap_remove_folio(F)
    folio_put_refs(F, n)
folio_put(F)
                            split_folio_to_order(F)
                              folio_ref_freeze(F, 1)
                              ...
                              lru_add_split_folio(T)
                                list_add_tail(&T->lru, &F->lru)
                                folio_set_lru(T)
                              __filemap_remove_folio(T)
                              folio_put_refs(T, 1)
                              /* T refcount == 1, PageLRU set */
                            free_folio_and_swap_cache(T)
                              folio_put(T)
                                /* refcount: 1 -> 0 */
                                                                  folio_isolate_lru(T)
                                                                    folio_test_clear_lru(T)
                                __folio_put(T)
                                  __page_cache_release(T)
                                    folio_test_lru(T) == false
                                    /* skip lruvec_del_folio(T) */
                                  free_frozen_pages(T)
                                                                  folio_get(T)
                                                                  lruvec_del_folio(T)
later:
  list_del(adjacent->lru)
    next == &T->lru
    next->prev == LIST_POISON / PCP freelist
    BUG

Assisted-by: Cursor:claude-opus-4-8
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..7465525a94a8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3966,7 +3966,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			folio_ref_unfreeze(new_folio,
 					   folio_cache_ref_count(new_folio) + 1);
 
-			if (do_lru)
+			if (do_lru && !(mapping && new_folio->index >= end))
 				lru_add_split_folio(folio, new_folio, lruvec, list);
 
 			/*
-- 
2.25.1


