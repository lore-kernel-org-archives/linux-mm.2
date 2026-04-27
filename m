Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BEBDFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E307F6B0093; Mon, 27 Apr 2026 16:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E047B6B0095; Mon, 27 Apr 2026 16:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA75E6B0095; Mon, 27 Apr 2026 16:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA4976B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:24:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1205512032C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:24:29 +0000 (UTC)
X-FDA: 84705463458.11.0C92DB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 07F251C000F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:24:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZoTFI2cn;
	spf=pass (imf21.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777321467;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XMtXo0DZ34WrfbG3W0hYPSzxjT9t2tXs28m6lnQ6Qk=;
	b=Bt3T4HUHEewhtwxCMfaRMVu2/zvV+Gy1uzgJ95fNF4b1jEPVutdA2+xRQKk7LdnQ+YxGsb
	OgRiSI7LYnuxQVZcdatfk5jxPjnZ6qao1As0yY2AvI5E05/UO/e1Djstlmex40CJQxPz3F
	Sivdce0Xxhy1QCaS8HtrRrTabCp0gP0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777321467; a=rsa-sha256;
	cv=none;
	b=SnHHwlFuRxbgyqIQFSvnCQcmSYlV8NvQBQygwpnCV5jjB7mQQ+3W7AZox0I4Jj5w1pCcSu
	ueWHXdmpBkRXMtP/GrnO0t2C5KOjdMjYjcezMvcVXISrwzoRy9bn3R8ZRtl6UyTOihPGiZ
	+9Ayjnx7KHACFImuUjcfzoLlI+PjOgo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZoTFI2cn;
	spf=pass (imf21.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1805243766;
	Mon, 27 Apr 2026 20:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ECE58C2BCB8;
	Mon, 27 Apr 2026 20:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777321466;
	bh=MxKAswVy5gspAeS/niaj4sA5dDUAOJ+IREaEamGnxyM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZoTFI2cnoxpqcTJfUrUa6i07Ikr0rK913P/ArjT77PDU33uMqzaG46/Eu96ZD5OnI
	 jfBMitByDLL752leJOmxSohF+mew2H8KEeIUWRIvzm9gB2zuDwiN+vE2Zc3DCMM4hG
	 5fIKv2SpZrtn4+7BC5wIr28vqXaXge4U6ykql1sP1/BA2w66CS/YdBWs90IVI+fUqA
	 AeYdbJGpd8yNO39qWQo80X0zfraEBCbhxT8DpVS8MVPdQkDFS2JGBCXTSYpppbcYfw
	 iAr+9jgM2bAecfHTBxyF0dXRDql6wK+k/+UtG1iHU5Q7wy+UNgfUxm/pYf3Q6WptL/
	 Z4CuWSKfOnXeQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD89DFF886D;
	Mon, 27 Apr 2026 20:24:25 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 28 Apr 2026 01:54:17 +0530
Subject: [PATCH v12 2/5] mm/vmalloc: use physical page count for vrealloc()
 grow-in-place check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-vmalloc-shrink-v12-2-3c18c9172eb1@zohomail.in>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
In-Reply-To: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777321463; l=1711;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=3zaMDF3eqVJSjOkW52oDkHrDPus2VHUR0DHtrB4u00o=;
 b=9xDmV4QtPHHxQIrLU6FWBWFk5O11upRJ6kVq6BdfEg+o3OqmT9PIwsBDRRVjoqRHmvya8jdBG
 SRE0nLYjyARBGXOwMeVysPpN0kqJGi+kck6apHCR7qUZjDCWkzTwGDv
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 07F251C000F
X-Stat-Signature: wxa7usgrcejyfmunfaj77a8m8tzdm76b
X-Rspam-User: 
X-HE-Tag: 1777321466-844212
X-HE-Meta: U2FsdGVkX19rkvTPglTd0ERhrT7E2BcMJzzj1jI7Dm2e7YHYWbFjPdiOfRLUMTBbf7338cMUcSmOI3/t+BYW2WMbWqu6BHI5nD9088LaG0v+v6tn/Ctxu+h+NOx9Zq1vO/ZDDUVqeIXcGDo5FL9cArjfIMxfyc/VGSLN7Vxe6I6fEip3hZK/Bp4lZMv4l2XKFrwdol+iynS/CXsvJsaiQHtw2lFQwFSh8yVgFVb8aTWsXlz20fKvhpD04HMnIROXTBd7Bg4TEGT3zXA+phzO2Qq0nnH6uAq/j/EY/7S/xHaKuTBLSVOwg1wBOK9q+gKZjhsIHbMS3EwSiUFKypB6TY7CG407IIuJDDtGuxhheyfktK6GXM249NS5I8yXSHSoVvhDlLi2s5Fxb0Mq1ghBizLosfEl/yE8vXu1qnXI+OGmGtkYIvmFInpG0hvcXFAyIVdrFWOmtXScb5C8gPDG7ZxpvWuBmugl9aNc9/EctL3sOeUl0/dQZznyrDWUr6V4A7U3bV2GiMUnhA53DhpDaGfMhfbyGr3Xyex70KhBPhDfoh0f4F1NCM+9E6W7lSvNOJG3IBoK+5/YvFp7R0bNpnV110fx3RR1BSVxRZu55LKHj+PQgo4Q9HR/p9kiVLfTW/3yk5J57wCL2Zw8BfxbskLdYmX26h6UBzU43teId2yAHJwEI0ASsqiawqy00sCcaLHwHI3wRb1TVn4jNXP19LRf4a/8AprsbUOCIpao1INXYvtF0ZS2QZw2KEnzIrK1QapC7MgLyFfi3dXhvEN2Svc/CTJ9No9L8iWaWlXEU0uD4QKjMTXr1Y5KEH32r1xo1Zb7BOjA/FmwAXCSDAC8Be/0bgbMbvxzoR2KaelkaKN4FbZIsHYJMvPOa6Iz7UHNqqSARAeRzSscMujLl1RwrIGnzT+SGgDtQaTADdIOANZNmGcFEOufWHfaXCMC1VIJc6ZdHrAugMwX6pn/xkF
 Yn2735j7
 4IPSF0nlcBrbZqI9N4c/cxVsqfgpGc1+HbFFO5VYjDddc2VSjJT5DcwLvkGHf8BLErrQ83lvrqLzZlDVHO+D5/MccfJ9jp9ZKo6gu4bQJ9kv/Ylsm5lWvtwpfQt6XIdGTcqH//rLl+m3iW3blmmjGzNkYZGq30ecgxchXJ/YurtCfOv6F8IFpWBsRJulOAhle88aTSBRnO4UeLxl5kwG5xJ8XtoTkK5TJySiWDRuyCTtgExCmjLAWSMdcxCG+O1uWzaWCXxu6dpIANvvKlPErGtfnr+HkKMgwzbDDRu5mJyvKTazzNMmaqZa65+LSOHDk8p8vp2Ppi5ZOEhA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Update the grow-in-place check in vrealloc() to compare the requested size
against the actual physical page count (vm->nr_pages) rather than the
virtual area size (alloced_size, derived from get_vm_area_size()).

Currently both values are equivalent, but the upcoming vrealloc() shrink
functionality will free pages without reducing the virtual reservation
size. After such a shrink, the old alloced_size-based comparison would
incorrectly allow a grow-in-place operation to succeed and attempt to
access freed pages. Switch to vm->nr_pages now so the check remains
correct once shrink support is added.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1073abb6094e..9cb3e287a1e8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4338,6 +4338,12 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
 			     nid != page_to_nid(vmalloc_to_page(p)))
 			goto need_realloc;
+	} else {
+		/*
+		 * If p is NULL, vrealloc behaves exactly like vmalloc.
+		 * Skip the shrink and in-place grow paths.
+		 */
+		goto need_realloc;
 	}
 
 	/*
@@ -4356,7 +4362,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= alloced_size) {
+	if (size <= vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during

-- 
2.43.0



