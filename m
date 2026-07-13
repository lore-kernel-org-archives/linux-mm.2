Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1048C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2C76B00A9; Mon, 13 Jul 2026 13:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62926B00B0; Mon, 13 Jul 2026 13:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54D86B00BD; Mon, 13 Jul 2026 13:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95EDD6B00A9
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:09:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1FCD21690EA
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:09:25 +0000 (UTC)
X-FDA: 84984389490.04.60ABFC8
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B56CA0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:09:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=NdR9KsWb;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=VoLSalhs;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783962563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z7Hh5ULkxWRmZG6F9VlPZhmTwOlGuPHXwZ63YP2S9JA=;
	b=cj1Qg4p/iogm0uZh3TlbVWnOya4Si83neEYKilqJrBxZK+Xkxzn6JSGXxJIp6gH1egsjNl
	W/DSFfyrePSWlQ+f3aDd3oey6PRJTEB2LiQaaO0WPmIzPQLqQeVM+Bk0dH07iAchTQn1R6
	Z1LPD5fjm5jP4qyNxvh7CJLMNy6SA1w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=NdR9KsWb;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=VoLSalhs;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783962563;
	b=OiTUZxU4dvA481gE814e7dZJztZFPtTxhZSRouRPtP00eRuWFE238eWZhLS/HecyDKxFsQ
	f8+3NuITIp1aSQV8g1pMtFq98DrbtCpBQZPY6thzAiii6nZnnAL+tQIMvszk/ZeAVxf7cd
	1FcqGk3Q10orHq5FV0DGMDkahG4psY8=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id EF2A07A0133;
	Mon, 13 Jul 2026 13:09:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 13 Jul 2026 13:09:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1783962561; x=1784048961; bh=z7Hh5ULkxW
	RmZG6F9VlPZhmTwOlGuPHXwZ63YP2S9JA=; b=NdR9KsWbdOxoyS+GannqayIOip
	XItknKnI/jPa7MbF1AlQsktlJyKKJTMvtzqREyUTZISdahQogE73TEVvSk7xLOfN
	B7vF00hgpunLrrYeaceZ4YwgDD5635UvyiT5oiIVehvv/lmXqa9moVRYQ1tM9DIj
	Ay+ivIaVYjuM+tkuuXNscKhVEiL/trYfdsxIA4GH5vyFuPQARVq9xiNTn+Le5Nur
	/PYRaDubLSvn/pC/CoPc3t+sO9qMySZWmK1RJwQxzvlFj+57ImXeZ+XqH8mTIv6P
	opITmT0+p7nDs+nUtA874cAix+Ss3PUIenqB+H7rRajT9GjD+3PQajzMJLoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783962561; x=1784048961; bh=z7Hh5ULkxWRmZG6F9VlPZhmTwOlGuPHXwZ6
	3YP2S9JA=; b=VoLSalhsFTlUEpI9AIl6mZF1kSbQO7+/PgsRS/RlnANvTKXc8rb
	bm5GKlhE2dW6Sj4Osc5ZwX+YUU7bwWmKPrBLw4ma3Co6gpyMZEzB+tzGo5a/hUpm
	JonN6DiyGUKs264M7kMB+/Nz2KbB0J3r8gA6DtgJBYPKyD4D4lKJ7dsFPZHo1HKr
	47GZl62yz7rqeyyiELqNb5yaKyNgEoBALUEN9Tv0AgNRh8CZsaYTwNJtlWCeYTed
	Ig5OvJQwjUMjqHD4sbbl2Kd0TE4UFUkq8ud4Gdkk/piT/JsfKk0h54y20dZAYu7r
	N/JHV0IpO21OZeea4hZWh7YpymYGePlTbHg==
X-ME-Sender: <xms:vxtVaoNsaV_RXYGHI47bx7A9ytp9iIs_R0wDwsYxTiNkRizRLJ-byA>
    <xme:vxtVav5jXTam7M3e3prOho86FtKJRtk5HnszOFsEsrxA_NLZ8rZvwHgUvXeJPXwDt
    fJZ6WdpRhTllqKCWvml8VFeEX_e-YA80TaCyxAjeW4Ed1_tUbXjzAog>
X-ME-Received: <xmr:vxtVavnMbl5kHKTi17Y8ZkXE5rA27llO47_vJJ92_633ZGhggsHJ4EeMhXUklQ>
X-ME-Proxy-Cause: dmFkZTFf7TfKAfTdyv4ZQVxAdLSDk4bKZDHKJh36DOcwq8FaEm2iYMKaYNpHwq7Pc8Vjtm
    ujI66e7G41tPihARJm8rbsi0d0fDBjSATo08b4lHQtuiLLD3buXa38IZZvOnRGQwA1urax
    /84Hrnqq8xMr34H8rAQG1HG15WXAnLwD/aH2eeXITIf7EYdjS0FNCN1DVR70RHaBjrSkIv
    wI7q4gFj0YJsSXpnAob/qbSQg1fMRKfQuTHbuhBMr/bLBxSlWcI1aCw4ooXf1r3DgATwYx
    lORKVn3MzDuzv4/5t+D01Qo/TTkXVKjYDMXP2oPSJk2gq8kUIDB1Uc5STIJs5/koy72LHa
    cVmrfZGDR+oNHnWk54Lp9VMkSBhYAIO8z6g24x8UW4y9+Tvo6CT3q1TBELEhVd1UldL6Qx
    ol2kvfoFQHnlhBACDqYp1W+eDro6SYVbAFcSvFAydtAGyDhRAIfPcnfXZdJ1kBWzFi970E
    Q0L7NqDMR9q9q36qJJREb5wteQiohd4cn5hzlE9WkPtRtBdzt4c4brHpSjHwGKUYNyx0RG
    QyE9H3aqx+uY/uYtCOzepU8MuqgTnP/SGVoWvC/lrNOISxf7+LB+mspBllXvbtNOl1Xk+i
    ZD/XfAbVKmicFUouQZsDInO5NtGRAAsTu84a3JMG5dZFc/zLFbibTB5n/oEw
X-ME-Proxy: <xmx:vxtVavLFYlIOvYUCyEdojvQdJJcU7My1YR1kzB8UGReA_glst33eFg>
    <xmx:vxtVanRW8-I3lkVWqvtEBzXGMnc1iqwGvGYvQCFRcY2IFtfFrK-71A>
    <xmx:vxtVakvGfNXPh2XX1QAqMwId-yCwkk1z-f73Nc0Kg7UNuA6d6PktHg>
    <xmx:vxtVai9sTZosA1Qvv_LfQKO2rypjB8sIV8slHfImK26mdG5Ws6LyLw>
    <xmx:wRtVauvwy4TZbW-lqipR1-qhOJE4HXU3d3-5L0GXV67lMOXDif2FUzhj>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Jul 2026 13:09:19 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>
Cc: Hao Zhang <hao_zhang_kdev@163.com>,
	Hao Zhang <zhanghao1@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kirill@shutemov.name>,
	stable@vger.kernel.org
Subject: [PATCH] mm: thp: pin the inode across a file folio split
Date: Mon, 13 Jul 2026 18:09:15 +0100
Message-ID: <20260713170915.239819-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r7mdobbbee96oun88zy3g4px44nnf1h1
X-Rspamd-Queue-Id: 1B56CA0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783962562-270665
X-HE-Meta: U2FsdGVkX1/V6GtXDkutA+tJin7r1NjKUiUDXrntaKoV5ZS3gzgDCNK7+pgZ8mt3thkBUChbXQtFgs2yXriR/z5mREDOCDtd56MDDVtxUQiT+rUoWOOX8p2K1P1qV3eB9rENuh1fu4CmUf0qpSSIwqHhhrx0CTCy8durorBsjLMiI3+WOWUnPZC05R7PqE5ArNpZkvqdNfrT1xkIpVQq6jX+5Bzu05ws8tZHSCSS4n8pZ2Ae97/sOanCSGaXpTt3LpCqLI72OII2rpVZ/FRJ5niRQc46BfaHEdC+2QF/jm4hKLIlu7AYYK8/cGbhQ9xwf5Ut8Wcfea1d1oN+KIG5DSDrqqYsmCo5KU8q1VcNABjjS7WE0IZb4+NX9bv3HkWEOUYDkGAKe3ovDLIESDAMMplIVdBujeE3f6Uq7Kh1x/dO8YZMJFPH6KQP8Yj32XSQwRs5xAfW/lvcY2LbIVIO0u1iOPJ5rqCV3V+etIP0qrdpg6IUcSrSK9vW/P/s4yqCwUECO7rolIlkXc4nudq1SZcGz2YRIXhQ7msJX+8gURR/N4um9RqE9nG7DAJPvUxY/zryAThjrQkAy/UfoT33z0FezRnrFnCyDkAte2ndCGubKtLtF9iV6u+77oQAvQ6+OQB5eaCBnSpU+fZpOBO+ZEfAmeDMi7AB3PqlR1VnKZLE1Nl2L8rL0zzZ3ee9LkXECnYfEYw25nnla7hozA6ZKVygvtNJgMNXXc3Ll+DZ2ba6KiAT2kLcybs4/ARDxSmSU70N+Stf13DTakBo7bQteytHf98t5PwtV1/qwk1zN5O+rM0SU60+U0IrGbwMzLak6taSzDvAshKPuhcLcjkuaoDgm7jnGonT1y7a0/Zyhs+4dvQrh5NJgt+2xtQDZpPjCAZqcdkuIUGt87rSLnpkfNEWa6o2+I2+qy/VO+0IgXeLHgf1WX/MwSOZi5+cKbwUt7y4l2pJeuH0Ksz+U4Z
 Q/VY/Thf
 CzW1WSK8oxCthSRq7zLF2IZxow1Wr5Ahz3Rkcg52u7wQLaNfzMD0k5dAVjj+D326q1xmpHHAyli4oeOOoaNLLmZ7Q6FgAEDaCa54rit4+aHwPVhFesCLGgmRWBhIwx7I/W+2/9d+lkcz7nsANDbnpyKv3s/O2HLdG9UJFYHYup+noPaJYXvw8+vLu0G8HUjjj49hJejXO42WoQVa8zMc0iIB9e8NpvhKrJf8C/exSgf1aO24+zmpf0kedKIfyYiUhrM71CVUbVRhLrkWh1Gl4RZlZvYQsOSwrv+LnN6cKJnIp7IOuwMRqLCwP05JksaZ53MyJnz6Vu+t5nj8amLJ5OSMHzYiUgImNZH/SjUx5DDonKg02aALYCJl1p0MbIHCTn6S4yLAJBBBQpkf0lEMsVBxVZtDWAJe2R12M2ctuW7cg33sfQM9o3V84zuRlYle0m6vMiSLcg4j49/5sqQ4XwhHn/ECDN1cNy1+z2v7xQB9+WK8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kirill@shutemov.name>

__folio_split() looks up mapping = folio->mapping for a file-backed
folio and keeps dereferencing it after the split completes:
shmem_uncharge(mapping->host) for folios dropped beyond EOF and
i_mmap_unlock_read(mapping) on the way out.

Nothing holds an inode reference for that duration. The split relies on
the folio the caller keeps locked (@lock_at) to pin the inode through
the page cache: while it is locked and present,
truncate_inode_pages_final() in evict() cannot make progress. But the
split drops @lock_at from the page cache when it falls beyond EOF (the
@end handling in __folio_freeze_and_split_unmapped()), while keeping it
locked for the caller. That removes the last pin, and a concurrent final
iput() can then evict and RCU-free the inode before __folio_split() is
done touching mapping.

This is reachable from memory_failure(): poisoning a tail page of a
shmem THP that straddles EOF makes try_to_split_thp_page() split at that
page, so the dropped @lock_at is the folio returned locked. The result
is a use-after-free, e.g.:

  BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790
   i_mmap_unlock_read include/linux/fs.h:537 [inline]
   __folio_split+0x732/0x1640 mm/huge_memory.c:4100
   try_to_split_thp_page+0xab/0x390 mm/memory-failure.c:1675
   memory_failure+0x1394/0x26e0 mm/memory-failure.c:2470

  Freed by task 4601:
   shmem_free_in_core_inode+0x54/0xb0 mm/shmem.c:5177
   i_callback+0x4c/0xa0 fs/inode.c:326
   destroy_inode+0x144/0x1e0 fs/inode.c:402
   evict+0x57f/0xac0 fs/inode.c:870

Pin the inode with igrab() before the split and drop the reference with
iput() after the last mapping dereference. igrab() returns NULL only if
the inode is already being evicted (i_count 0 and I_FREEING set), which
a split racing eviction can observe; there is nothing safe to split
then, so return -EBUSY, which callers already handle.

Reported-by: Hao Zhang <zhanghao1@kylinos.cn>
Closes: https://lore.kernel.org/linux-mm/20260710071344.GA106129@zh-pc
Fixes: baa355fd3314 ("thp: file pages support for split_huge_page()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Kiryl Shutsemau (Meta) <kirill@shutemov.name>
---
 mm/huge_memory.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..9bfa3a879453 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3982,6 +3982,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	bool is_anon = folio_test_anon(folio);
 	struct address_space *mapping = NULL;
 	struct anon_vma *anon_vma = NULL;
+	struct inode *inode = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
@@ -4053,6 +4054,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		}
 
 		anon_vma = NULL;
+
+		/*
+		 * The locked @lock_at folio keeps the inode alive: eviction
+		 * cannot remove it from the page cache while it is locked. But
+		 * the split drops it if it lies beyond EOF, after which we
+		 * still touch @mapping (shmem_uncharge(), i_mmap_unlock_read()).
+		 * Hold an inode reference across the split to be safe.
+		 */
+		inode = igrab(mapping->host);
+		if (!inode) {
+			/* Inode is being evicted; nothing to split. */
+			ret = -EBUSY;
+			goto out;
+		}
 		i_mmap_lock_read(mapping);
 
 		/*
@@ -4135,6 +4150,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	}
 	if (mapping)
 		i_mmap_unlock_read(mapping);
+	if (inode)
+		iput(inode);
 out:
 	xas_destroy(&xas);
 	if (is_pmd_order(old_order))

base-commit: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
-- 
2.54.0


