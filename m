Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16F77C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F263F6B00C9; Mon,  6 Jul 2026 07:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFDA56B00CA; Mon,  6 Jul 2026 07:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A8A6B00CB; Mon,  6 Jul 2026 07:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE1C66B00C9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:43:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 335788D9A1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:43:47 +0000 (UTC)
X-FDA: 84958167294.20.69FE480
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A20C180010
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:43:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V5ynbpCl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783338225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eWxKWelYN6VOFhLaKXxrOAvySHVCOpFgMq2qLns63vI=;
	b=Tq6SHEurWstAi/oUaMxFb9cc2QmKEXgeti04EfagqXVWCfnA4M9vkcK/mtiB0ZRg89WQd/
	anp7pFZKP/NCpkGFzLzRWajKldSpOiAgG6ZTZaFDvaNybg4WBERa4Og8M96lxGfcrziGUr
	ENdjEQ1fCnm0cRcbvMI3eIu+xTPG/bk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V5ynbpCl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783338225;
	b=kWaEHfaB9JJv6Miji2CmLm3PVlwC/bgJOkMS1m6MC/jFMw29I26d+6zq1L8TkcjniqBGN4
	iwmwyjyeUs3Ifdkd4SO7p3Q5Ir/Bcw1Dkn/Qbs3r9pU39M4ot2D8e+7dJt2KAsM0gvpwCD
	xXq6SSVvoSJQai951630Qxg3r047hUw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783338224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eWxKWelYN6VOFhLaKXxrOAvySHVCOpFgMq2qLns63vI=;
	b=V5ynbpCl9moLAkHkJCyhavgIY0uKtbbrNj02UxHEGZfFnPHrwZ75oU/HAsIo3Dx4D3GQvn
	0ih1BY11zBABC4odeg9J6/ULG0dYnF/TcGMhV6fGWqHmYFiPAychHPZikMS2AebmZKW30p
	zWXmG3v1QMhZps2QKfguF86qHB6eYRg=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 3/6] fs/proc: use softleaf_has_pfn() in pagemap PMD walker
Date: Mon,  6 Jul 2026 04:42:05 -0700
Message-ID: <20260706114320.1643046-4-usama.arif@linux.dev>
In-Reply-To: <20260706114320.1643046-1-usama.arif@linux.dev>
References: <20260706114320.1643046-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8A20C180010
X-Stat-Signature: x5ie4rh5swt6srpxidtqi65j6mg7kxbn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783338225-257360
X-HE-Meta: U2FsdGVkX1/P1AlLrb4I7MkDAhqFzRjqqPmG5Qetq4uvJ/H3xbbgM9Onc77Oks/jHGbW46mEp4fbYX+yzlWGOYRs8VM2x3KZUMG7DPHVJ20jxUOW1KU7EAP91Q+ED1rzTnHwC9ex12M9zOMl/P4SboW3KJuH+fh9gsMbXv+2c+LQcbLi6eI87jQ0eR66IPBfuoOtE/2KMA+BZhdi7Ho1DoXbcamtOKxHy87RBg68T/1kIlwORarQRq0JnIGpYMFea4NQLAnqrh7ffpE2YQuOd8+WuNBdTm+C6ivqKbzTpjW/HtbpRI34tZmHWKdxdswS70rLewRm1YiQXWyZirWG1GQyO/AhusAKcyv8sVCSK9tPrC7FapCSOXBUkTSSP8Gt5d1N/mesJ8nLb7uN/rRw8QudvvZWs/eEt9byC7mS4gyYQolO/V5hqaNeQUhy2FBGMsVSH5eo1SJzL+kA+elOgj8ThI245aul7TZ4SHjFIyxlqguTpnXaFJL6t4BPHz2a+hMI3lt4GxbXcQHKBBM+55uxYG+y5aSzX3VMMKFM5Pd4MyjnMfkgBSBhjgj2t7oIsuZgSVpa4Hh69TQpw7zP+sjmWr2LmhB1JuoAhtLWYcYx5sJ4wF0fxmatdWKbJ8DoNfKHl/DzV3Nb5ymEAqHxSnbwxwZfp+xchwWBYYcu4pacJwpzc+/+DNps7qhlQbFFWs7o0WzWCs523APn09imY4nRHkI7eRTv81tcNVY3P18LgG01i9qXlKiC/yNj95+PYxsZ+mGPiIi6YpBgqFgdV+b3+h/xG8j+uShwXDG4HkYm6JewQLUao9Q3eUHrhAC+glW60x3Q5iJVbDSkveDBX6ytr4o4yZGtm4d+uEHDa3/7zkwvNlxdxXLOQcaiWk9AUCt6EX/Ud038oS9RiVe1l3+UZWfpfcAo+byrkcunacLOxUsgrqqYQZ5qpDYEGWKxoO60WLLaUI3NLfQ7HG5
 UOjmp01z
 FSg50qAB68d/16SJ4KYvvu1pMNOCNDrSoSvFLLwOQx2hzqpnTZEqy/cqfPqwkZ+g2IB0cnGXZ/MCPcDTJdwgrxsutITmF+dN5eSXu+cd0YK46nZd0fYapvEcZ6F7tdr044HJjIUyMR8+UzTZyHMKWU1SjA2pfioK0MtDT+toXWlpGUl4D9srRDqOx2mRSFZo3VIr7Ro7MtJwHEKzFKjADOAuRCZ4w3qKp+H/QRlYHIjzkow82PXBG3qgcSsOortrr3VZtdkvhtKuJy70nDUQpfRpgeEwFV1WQejwxp4ZK3IuFe7k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pagemap_pmd_range_thp() assumes that every non-present PMD is a
migration entry and unconditionally calls softleaf_to_page().  This
will crash on any non-present PMD type that does not encode a PFN,
such as the upcoming PMD-level swap entries.

Guard the page lookup with softleaf_has_pfn(), matching how
pte_to_pagemap_entry() already handles non-present PTEs.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/proc/task_mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d32408f7cd5e..1fb5acd88ad0 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2129,7 +2129,8 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
 			flags |= PM_SOFT_DIRTY;
 		if (pmd_swp_uffd_wp(pmd))
 			flags |= PM_UFFD_WP;
-		page = softleaf_to_page(entry);
+		if (softleaf_has_pfn(entry))
+			page = softleaf_to_page(entry);
 	}
 
 	if (page) {
-- 
2.53.0-Meta


