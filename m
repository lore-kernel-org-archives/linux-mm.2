Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 565B3C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F61C6B007B; Wed,  5 Aug 2026 04:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEAD6B0092; Wed,  5 Aug 2026 04:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E72A6B0093; Wed,  5 Aug 2026 04:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 180966B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:42:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A572C03BF
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:42:46 +0000 (UTC)
X-FDA: 85066575132.26.2BF5225
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf14.hostedemail.com (Postfix) with ESMTP id 917B8100002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:42:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gHFZT1OB;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf14.hostedemail.com: domain of dayou5941@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=dayou5941@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785919364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DxsOeJBgLD6jZEVkGeHk085+Bv5tTcnYZ6Dn+cOzVFY=;
	b=vcnlf/rvuPFeQ6penCNk8jRaIvr9ANkMHLUmsTCVH3BSfBEmAvzBgaPWqEJnPPZRanlkFz
	mtAv9UOeLx+62/9878cMg6UYFCv0zorh7WWT03g9aIXgSZBfgME2HE4xXjgTqZnK35HVHY
	Y9TFhZ7uq7bF6rIKl8MqqtfhM7NGYYo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gHFZT1OB;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf14.hostedemail.com: domain of dayou5941@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=dayou5941@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785919364;
	b=SSg8Owrm20+G/GKxP6eQ4Nr8ciDgDoERdoVRDbQN6VPeitUvhTl9YnUcldxzny8Z9JMhQV
	dy5k5mTQWygdUmNW4Z9tcKrdSBROS4kfgwu43AkySFUD1SgRi/5yTz6ZZt4ufI2DWg7yCN
	0GxFSAySGciV1gf9a+5Vr4Xdsqf0ju8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Dx
	sOeJBgLD6jZEVkGeHk085+Bv5tTcnYZ6Dn+cOzVFY=; b=gHFZT1OB7HVXln+L5h
	SWACOdotVQHKoF1PuuQRwTQT82vp2zkWyLcS+j6J4/7s/DZCFZwFKtUjbnkeIss3
	HRy8VU3mz/vv53xDRBSJaYoEVUBDXK7a0MyPGHRprx32kJzS9Zm29rlhxfwVz28o
	15WyFZqUVgBEqut/15kEMIV58=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wCnwmJz93JqARgeOA--.21852S2;
	Wed, 05 Aug 2026 16:42:28 +0800 (CST)
From: dayou5941@163.com
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: ziy@nvidia.com,
	linux-mm@kvack.org,
	Li Youhong <liyouhong@kylinos.cn>,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v3] mm/memory-failure: fix concurrent access issue in min_order_for_split()
Date: Wed,  5 Aug 2026 16:42:24 +0800
Message-Id: <20260805084224.2597547-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCnwmJz93JqARgeOA--.21852S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAr4fKrWfGF1fXF47GrWDtwb_yoW5ZF43pF
	W7Kwn8XrZagwnI9r47Xw4DAF1Fk34kWa15uF93Cw43A3Z8Aw1jkF47Ww4YyF4UKr48AFn7
	tFyDXF1093WDtF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jFfO7UUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3RZSAWpy93YoUgAA37
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 9profrjjmpfiketdm3ybb87bcda8439u
X-Rspamd-Queue-Id: 917B8100002
X-HE-Tag: 1785919363-812381
X-HE-Meta: U2FsdGVkX18+U+5WWuxZRmJkFAIlcIGGsbOoXa5J1+ep7KYN/unKvw2rXUzRpr63BQ7abr+8kgQH7gvQnDTiN6t4TNdki2KyY0Zf1LPTx83O8AJ6m3+LAw9tRjVXHIw8Umrz9cGlYoO2x1BUoCAAI+gWBHXRHEzzhTg1jZMVLvAzPU40KA7GDL6qoAuICF6TLQiRlK48TIgx5A5s7KsmXe3HovYzixmMVliUWlINVzDp22aS39SH3lK3REbfSEORNiPWp/9DN1oRdwONgfTzD39XgWKRZIUxUgnYb0iabRkiy+iy2Tu9LCvoh2XC7Rfg0qs5hKLbaVxIb2JlromkWaclI10m2u3OmQi0MM5dV9UVH6DaKLo98w7w7LE7YJEmhIkjjaqkgxZ4e6NhTM1MJxKXOXAADOsw2Jl5BOemG/gNw0EUfOQx5WdxM3SFTr5Nx9GFdkTgH+zW2X4+pYoL5PJmYJ+QQ8dcrwq6bmyVPrndbRNGPMw5f8IDBVHe3KXnylRsbRD13egeJ28xGH9bRG3T/MnPWY+uw29gXKTFxRF7Pa715FYqM+gdu+4wmYWw89rRuBITDly2tF2ywseEF66tlC9ZVf0PSqZvFgvLiUvHqN1UIjugt0lRc0nsLu/wdosahLWLwVTW8ZEmDA/XY0NrS5a3YPUZQI7QuArkNs5caorflCGq7PW5Mn4twiRVrZo9Df7Ag7513lYnwAxXfAn1C224PEAcRwlRqI1OWCAamijrwTeV+dwxkGQBrNIhYwockwwgbX5YHtNTKn+F8W3p5wU7KwCI5YOQHHeJcN9gYRC1tYLumJqrrD4TWiDGpJ9NkhRYglHX4hYkRfCaZvHkIT8SnQIYlgIQiSRi2VZxukrk10J1rfSk68aArMfgh/qVC1RWnSGH4oJK6XHIFmfOulceBarwjZBekyTD4ZNPKMSWiyAmkGeVXAuDblzLdnT/WVP/KROZIx+eMXJ
 3B4IwH+p
 Wey7mZHSz82ZcOBDCcYtLgxXw1q/XHnR7LLLDcBK2SJsbZfvLhTQVK2ksThkaxtWP3eQ8kksN8FjJDV5KvL7d0Pk2kSP/BsA6dPAc1JBOICewLq1cRioh3bmud7NtEBhHNVrxVI+MLmGSCpNh1BfryUenTm4orkyxB87A88NebYFJYwQpe7GJ3aT6e0wUDKuwGCejx7WeyDFxdrYj8LkDrvcaHp4Pm/eWhguts0HbiAYTYqUV2MaJ//5kG5Vlynpn6fPGABypERxZO/CeFXSlEtg0Q0IBLvr5F4plNdMpJHVOFpfZjkbRp6TIhchbfH0OY8mwRw9imvnF/Y2oTZ2c8H9+k+qN65k5Uf/zR7lfDN4as3EjNcPIJMxjzsf/pH0+cZnysP2xL8lPIQZeL6Wih0BFNNj5lSswBOXAze1vlqu9p6VmPYWEpVO4KvfNX6ATZWrzjZMd38+0/Jpqmitcjyf2g7mazIoldpjCNbGLmuYsWZc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Youhong <liyouhong@kylinos.cn>

min_order_for_split() accesses folio->mapping without proper
synchronization. While the compiler typically caches the value
in a register making a NULL deref unlikely in practice, the
real issue is that the callers in memory-failure.c do not hold
the folio lock at the time of the call:

- memory_failure() explicitly drops the folio lock before calling
  min_order_for_split().
- soft_offline_in_use_page() has not yet acquired the folio lock
  when calling min_order_for_split().

This means the value of folio->mapping may be modified by a
truncate or invalidate operation while min_order_for_split() is
executing, leading to a torn read or use of a stale mapping value.

Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260803060001.800638-1-dayou5941@163.com
Cc: stable@vger.kernel.org
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
---
v2:
- Dropped the approach of caching folio->mapping inside min_order_for_split() in favor of adding the folio lock at the callers.
- Added VM_WARN_ON_ONCE_FOLIO() in min_order_for_split().
- Updated the commit message to clarify that the real issue is the callers not holding the folio lock, rather than a TOCTOU race.
  v1: https://lore.kernel.org/all/20260804035828.2684059-1-dayou5941@163.com/

v3:
- Fix author name and Signed-off-by format as requested by Greg.
  v2: https://lore.kernel.org/all/20260805072625.2437636-1-dayou5941@163.com/
---
 mm/huge_memory.c    |  2 ++
 mm/memory-failure.c | 12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 58cabe6af33d..e3f16dadc1d4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4300,6 +4300,8 @@ int folio_split(struct folio *folio, unsigned int new_order,
  */
 unsigned int min_order_for_split(struct folio *folio)
 {
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
 	if (folio_test_anon(folio))
 		return 0;
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3b1e6946821b..7391524b5046 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2437,12 +2437,17 @@ int memory_failure(unsigned long pfn, int flags)
 		res = -EOPNOTSUPP;
 		goto unlock_mutex;
 	}
+
 	folio_unlock(folio);
 
 	if (folio_test_large(folio)) {
-		const int new_order = min_order_for_split(folio);
+		const int new_order;
 		int err;
 
+		folio_lock(folio);
+		new_order = min_order_for_split(folio);
+		folio_unlock(folio);
+
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
@@ -2796,8 +2801,11 @@ static int soft_offline_in_use_page(struct page *page)
 	};
 
 	if (!huge && folio_test_large(folio)) {
-		const int new_order = min_order_for_split(folio);
+		const int new_order;
 
+		folio_lock(folio);
+		new_order = min_order_for_split(folio);
+		folio_unlock(folio);
 		/*
 		 * If new_order (target split order) is not 0, do not split the
 		 * folio at all to retain the still accessible large folio.
-- 
2.25.1


