Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7EE2C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 11:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D49076B00EC; Tue, 30 Jun 2026 07:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF89E6B00ED; Tue, 30 Jun 2026 07:39:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC12E6B00EE; Tue, 30 Jun 2026 07:39:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 904276B00EC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:39:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 283E414046E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:39:40 +0000 (UTC)
X-FDA: 84936384120.23.8BE4006
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6377820003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:39:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ZJtc4DY3;
	spf=pass (imf13.hostedemail.com: domain of guanwentao@uniontech.com designates 54.206.16.166 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782819578;
	b=g5UrfGiDWZHR7cVO43nf6Np8wvLwjD/xxbwZwgabblIgOOmmW4936rexHXPXlxjMc88L/g
	JGNRA93ymN6FpU1hB2nBppcCMN8WMZ+LkcLIjaSYkcPpxNKZhIlPVpKb5vb+qQZqeb/IcK
	aT5hOnB9pWz83X+OLNvS7e4/ETCF+T8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782819578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2DTZxiReDZe/UfzDYH4J6ofd3XwFaAtenmT6j/RacmQ=;
	b=l2m1eOcOqd/nrpOAr9glg4gGyDkKa0DE5qX4/jDqmgJQ+YWU7mR8ah5io3HtjoXh4sISQP
	6y752h5dihBV4JcUrNa5lATJ8acKlJMP1outM8hjm2GoHAAvxCc9TeG9nX+GyrAA4LezDX
	2NIWL9ZpF7ZpVXD1tNqXOr4hUCL3DAA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ZJtc4DY3;
	spf=pass (imf13.hostedemail.com: domain of guanwentao@uniontech.com designates 54.206.16.166 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782819563;
	bh=2DTZxiReDZe/UfzDYH4J6ofd3XwFaAtenmT6j/RacmQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ZJtc4DY3a7wgi2wgFqKfTvjeaxxq1BzRLbeGN+Er6kgz+jjbpKe53uAp0K2pAnowY
	 jBFyX75pEyYe5CQ/Bv3f4ogINxmMRWfpQHTgxwbwPU4LkK8Nx4A33Y+XRAoLy1HAI3
	 jO3fR836Kxbu2mceVZAQeAlvOKc0G/wgL1z42GL4=
X-QQ-mid: zesmtpsz2t1782819544t49749188
X-QQ-Originating-IP: sxEsh/LsGlrcKq7rsdcnntKfWGdMDa9vi9AN+mgPoWc=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 30 Jun 2026 19:39:02 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11253890837269106346
EX-QQ-RecipientCnt: 8
From: Wentao Guan <guanwentao@uniontech.com>
To: mike.kravetz@oracle.com,
	muchun.song@linux.dev
Cc: osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH] mm/hugetlb: avoid unnecessary TLB flush for empty folio list in vmemmap optimize
Date: Tue, 30 Jun 2026 19:38:57 +0800
Message-Id: <20260630113857.3319612-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: McoPngcDBvM5GcdEB5V2fCXSnObxkMXgCYM59VrVax8XvAxYVvLw06wN
	ah2MJ2fEzvJRImKtnt8v4lkiAzoQTNjTBdVAvqSi66uEdJwX1ipZot2VGVLIZPANu38NBJl
	wXjd9ghA+x12BdMXzzL9okS2RIId+ElxS9pQaHKx9gtuto+QO6OhQ4TMnl/LDfLskOCwxvm
	clYPgria/HFn43s3+2xtlSCoxncfHjEuAnkyUR8P+jF57AyZsUgahyjRqhFjA8HATb1CVFX
	5dupi4y1t0BCpDb7jYHYUTN7tG8VEOE5MUq/TwWqgagx0oKRCrKf72AC3JKY7KG29P+vnFt
	WSLpKnSUuQ1Z7ENXSXFuz6YDWEwoZPmx7eiNi7PnaUfFZMRDqQajnVMETn1oIcSRIUqmouk
	GUuGfutonL/4aMazCn5XVBySceGC19iMO2DDYrNEX7WfX6VH/bqJjg5D1p3rM5YLYP/28Dy
	sO7Qyv23W0ihnOlWEXjC54IoUNLecsUdYYCFy2FrP+M9sDy6QuikTEppVjAr/fJ+WzHS9Zh
	QGgtxreXuMCgjhHFb/5IOL0rT0uhyeq+SgjUWJQp6Vrix3aKxlyRyZ8CZTCNu7qDc+5a6sg
	sOt+9PQhz+hjrJdgOsX1J7RV0T3mZMIm7pt3QpsD4VFA8KZu+r3jXiG8NBniNcowYEf1Soi
	rpA2lrrpp3aehO8vwNGsfEbA/glDGMOugHoEdlgLlSPzyV0mbw3CHgmToYzfsmNTdpTupnb
	PE6JRZcadtB1vcggpikuH4VZL7bdFgERdyzyrM7CLY6VV23AJhqFK8MoJtoFPsscwcZc6sR
	9C/QFfxgUEV54rVTumdxEN8ZWoDGEdGHS2tNePRtLKRTFHjqi6uZc1eR3kfWed3KAwuCBsy
	Xi5edwfkJc66iOcENSJPPv+1D+mKncL1zuIynDdqjY4lIn8RzrqL69gb7Jk8YaNTuxScKXf
	GQKKd9YRjTzr2PeAuzUHTs7mVip0Ur+EZ0YSA/cCsqaNP0LWuifTV3SAF27DlPrh5MRlz+U
	52vTkl6aojfsN46LVfrLMygDVGg2UjVBcaMr7f0ifTtlOgxXfhRFp9UrY/OC9f26uWG9r39
	Q==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0
X-Rspamd-Queue-Id: 6377820003
X-Stat-Signature: drc6dfbwckqyh6gmcmgcmanrfsyrh9m9
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782819575-442478
X-HE-Meta: U2FsdGVkX1/Oh1tQVDIHMNSYwZ8Rcl6O52WX5XI2almJJZeSXA811AR1sEISpJ13gx6y4MoIYiL21SpyeMA0NKCcgOgj9f/M+BGrBPAUsuAu5ECVtqWyGY1vFsk4puJqf4FxQipzMzEDYXP3J7AhyNAsEc2d1Wbh/tmDwcptWxeAOK/PB+E7RYj/DivBZHVmI4VWw1t8cWxsKPFpXn62dOe/B88ErG9k3ywPavJ3MeDzE5gHfjLmWlmudtaWYocFCaDSQJ0Lml+tNE4GFbQZEKxfTIoclYidY/KnbPFO02J8iQIfZ+GGWe2OD/NBdKn03oQnS/Abaed5gnDH4z7Yr/IVxZAscLWOdgVlVV85wPV0G4HAbW8h7naDCSn/nfXq9hItlLrproHiVHVzper75XPtjBT2+k+OeVyrBaRI2GR0kmJxbDi4XNrItaNIA1lYQdIBagUSohLYLKSJ9Cv4wIDIfVN+JXfgjE08fBaZUpQfUusZGdpj3gPExT+pVRHcWe1j4HJhi86MiTn0jT/pUUkQrSbWgPILOJVJbQNDCSD5LV6IbvQbSyzXIUy3alpV5dExXs3GaGgKYmvcWcpKJVKAm2makL2UC6/aoweQPKJoNtbLFR+BPQgVxNhiJmpeaXza1/ZPes9zkBv2F0eTXudTDQshT8mxOt6JnPP0y34oQFu3OXBusj/k2xLgnZ/HlQQlxpkEFewJupOf5RHU/jKyyqj0tHpdtLztTBL0WOXPFwY81b4+l6se0biyZHPXU5xXAalrQObhmuRi5YZ7jqn4utcNvBTSGqb17gMAmFel694jKQXc4PrcYQfQX3KHVjfNkITC3k9OXmmYMpfZYeL7vuDM/fd54hgQWBDa0bDnK0HTYgfxJsK6bghDG9NYBKT3+jTNYKL48zptDiYaU1uFYxyfcKiJvHTsUsX8fyMFy93aG7Zokzjz7KeULTFljIkkb2u0MF7Hcn6WJjE
 RMty6SDz
 L4ekSS0s/z7lsYPIBehKzLthKol9RXDB6QNfibojpLnj2hNUcKNjzQa4WKrETOvb7tlujHlUUFBz2S8bRPCyqztOQnE5vvg+qzktpqDDoIKE8OfA+WwlMQMQoJX85MpSvmtoNqAUYtYEtFoUVFOGjSevxshpM9d1l+rpC5nNkDvif+GaVhhHA7ZfIFzjSY/W9+vPay4QnA7SgCordSdBk+1CNQOKdkxe6oK5Wf7Fwl4Pzf+sL+0ZmHMtp5xduAT14gc+Vr0aG/tF0zbJOVp5dGfryW6bLajF0vP1CZCQvslAY/Wd/ud+dUL3v/+Ray2BmwaG3zbeOvCV8GhNwgxmkZOcBCBtxNs4OdZkV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__hugetlb_vmemmap_optimize_folios() unconditionally issues a final
flush_tlb_all() in its out path.  However, a TLB flush must be paired
with an actual page table modification.

When the input folio list is empty, neither PMD splitting nor PTE
remapping takes place, so no page tables are modified and the flush is
pure overhead.  An empty list is reached in common paths such as
gather_bootmem_prealloc_node() on nodes without bootmem gigantic pages,
hugetlb_pages_alloc_boot_node() when no pages were allocated, and
runtime allocation failure paths in set_max_huge_pages().

Add an early return for empty lists.  This restores the basic invariant
that TLB flushes are only issued when page tables have been modified,
and it also makes the NULL hstate passed by gather_bootmem_prealloc_node()
on an empty list harmless.

Assisted-by: kimi-cli:kimi-k2.7 code
Assisted-by: Github Copilot:gpt-5.2 #Reported-by

Fixes: 79359d6d24df ("hugetlb: perform vmemmap optimization on a list of pages")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
---
 mm/hugetlb_vmemmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 133b46dfb09f5..d45d5355d1af1 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -624,6 +624,9 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	LIST_HEAD(vmemmap_pages);
 	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
+	if (list_empty(folio_list))
+		return;
+
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
-- 
2.30.2


