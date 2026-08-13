Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B80A6C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A72916B0259; Thu, 13 Aug 2026 05:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48FC6B025A; Thu, 13 Aug 2026 05:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986186B0269; Thu, 13 Aug 2026 05:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE8B6B0259
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:38:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB409140568
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:38:22 +0000 (UTC)
X-FDA: 85095745644.16.116B7B3
Received: from mta1.migadu.com (out-219.mta1.migadu.com [95.215.58.219])
	by imf26.hostedemail.com (Postfix) with ESMTP id 98370140006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:38:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Thhb3rff;
	spf=pass (imf26.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.219 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613901;
	b=hVtvYogvBjP/baGz7oV2ljoc7vpgUOq7jqYIKHGdDR2X6ZcSk1w//frEUmtjqKB8MQpKCN
	3U4jUi8FbNhv4TEvtBWIP8jmJuq0SVgO5PTQr4Nh5kRz6b4wMaadXgUi/0U/4yJ4gKIvLL
	pzYNFp3BkLfRLaUw6ifVjMfNaq0mdWg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Thhb3rff;
	spf=pass (imf26.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.219 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=k7c0TNAEjWTezHjf+1iRBBEwbsaFJMNeZvcdSBlbU6s=;
	b=2edzp0SoyF6uRRziyUDOXCRE7L/b6mihggSTc4t6Wwo4sVeYIMB43rObe/pnNx21HFLds2
	XA/Ig0TCJ9/GsaSlry6TMMx4rILok3vcdaGxaVGJPkGuTXmlJuRYjY2HqZeXNh/Z5lR4B5
	llxozwLdEG4QdEdax+3oX3HPKQDCm+o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BlnwSR8qPlrA8mzIZnfJnVLPc/ljsBLrw0CyFU+bh7M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786613899; v=1; x=1787218699;
 b=Thhb3rffgTKVbEo2m6pz5yNOhsD7Uguk2bJ0FMkBW84/FEVlLqJ/frb0qiIslMLpxRWnnNWk
 LUosxkhN6+hTxWVnuoJkEafIx56xHgh02WwPr/C+Wzr4DEf7Bcx2Lchfzo0zkLB5TdMYdZKbKv9
 zAsMYP2+NzunX+WkxsLrtcDU=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 36abd874b0a54fac;
	Thu, 13 Aug 2026 09:38:19 +0000
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/oom_kill: remove unreachable __GFP_THISNODE check in constrained_alloc()
Date: Thu, 13 Aug 2026 17:38:09 +0800
Message-Id: <20260813093810.573302-1-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 98370140006
X-Stat-Signature: 5jawt1b6bx4baw8dp6sqccnba9x36ar1
X-HE-Tag: 1786613900-415350
X-HE-Meta: U2FsdGVkX19KfHmTcd5CSiBO0bqN/Z8+loZu9zxzxzNnRHGDdOSvNS0NWOmh202rRAtQmiLXXhWyv6kDaIZfpjrWsQ1km113lPaTjWSxdprR9+lcLuPrqH1ckG9YthPdfG9itdVXN5832JQMAHwUNSYzKcQKOGpR0hKMyKWlB1fQjcvEyJ80NhAvCOlu7VyawiLHW97kOofdM1YlSUTZvKjMtclfIvShI2OPNVWkNIT0ixWfO/eWc47G8ATTSXFTlFS2rWlF0fSFizvEf1UCkmE1vcR/fpF2fmXEKw17zRQJN6RNySwK3KgHRQV1NVBkPOiGQ6W+Vni9iFi7RfE52rRqwpJwqFQ+dtxI7SeSfi4A6kizNpsun7F3u2vJrLSWUm9dfXfempg39+la1zy45Hg7cxuAY2iLAE2RhBI5TAotBXbuVvzByZ1B0RAUbDIKjHiLanUxYv6B68BYaNVXZ/g5q45iSgsW1ZdMc8bGKmvj4YaOgPW+x+8HEZOeAbZZ6yZkXuKSpQimY6kL51yRSrLYWQBkyqntnMmfX/2YMf+QtNsm45Getl3m4MCdQJrcO9GRjZjyvXd9C7Sbwa/N0ytKefhuvpjsw0Va8ENAKba4jHZ0HLvITfzEV5oy/z9ROJrQNEsT8GLeKzvSp4y4VFCTvV3y3aC1QUzuc0FtoOrZW5kX35himqapLumd8MHW6x9KwiQxKRFNaJTFC0cqSVP+0Fu8PuSZEAUmRdYjwrPRM22sK5nBIXz3e4OvdmZ76ugZBGHaczg9nI5+2z0B1X0IVjNgjT3aXeBw2tFAizFiwJ87HfTVh8xelB0Fsn1uf4AIpyPccOHYSdV9lQ91Pb1HFoHLKoHC9wQE5Gt6hueGeKHLvyFdPUDeUn/J/D+k9KlD3wJ/ydHl43mNVmA8o4AgfE5viFdlGpkwOLVvNUUOIl13PHermkXOXOwkD1de+YZWQsvN8TOr+xbj3R7
 p8ekqcJO
 SRAi4FyYh8GKXvKDxXHcHvFdkQBLfQC9tVki6ES2B2F4uHiBxfHHUNjzzM+atJPCKUvvlbLhT1PxVJJWoyYnFdfI3D9APiJViJavCrLVaGqdCWHPmDGvIUoH83PlBUnh/cIRpMQ2s2dZY4XXEN4O1h0Mifspv0xDMhjF/kyAKiyxjy8fEbd5Jjkzc2k4Y+jw4DRLCzY2470SspHAJS63K6IALxXCVmm7Xjzw2IcBXiOkE9iBKNlZYjOHQZawlC8shyLAfuKsj/cWVNfWtqYdBxUXief/Mx3ofb3QOjM1iH/UlSSU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The __GFP_THISNODE check in constrained_alloc() is dead code: global
OOM is never triggered with __GFP_THISNODE (blocked in
__alloc_pages_may_oom before out_of_memory() is called), and memcg OOM
returns CONSTRAINT_MEMCG at the top of the function before reaching
this point. Remove the check, its stale comment, and update the
following comment that referenced __GFP_THISNODE.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
v2:
 - Remove the dead code directly.
 - Link: https://lore.kernel.org/all/20260813030654.320269-1-ye.liu@linux.dev/

 mm/oom_kill.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5f372f6e26fa..fd3c476846a3 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -267,18 +267,11 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 
 	if (!oc->zonelist)
 		return CONSTRAINT_NONE;
-	/*
-	 * Reach here only when __GFP_NOFAIL is used. So, we should avoid
-	 * to kill current.We have to random task kill in this case.
-	 * Hopefully, CONSTRAINT_THISNODE...but no way to handle it, now.
-	 */
-	if (oc->gfp_mask & __GFP_THISNODE)
-		return CONSTRAINT_NONE;
 
 	/*
-	 * This is not a __GFP_THISNODE allocation, so a truncated nodemask in
-	 * the page allocator means a mempolicy is in effect.  Cpuset policy
-	 * is enforced in get_page_from_freelist().
+	 * A truncated nodemask in the page allocator means a mempolicy
+	 * is in effect.  Cpuset policy is enforced in
+	 * get_page_from_freelist().
 	 */
 	if (oc->nodemask &&
 	    !nodes_subset(node_states[N_MEMORY], *oc->nodemask)) {
-- 
2.25.1


