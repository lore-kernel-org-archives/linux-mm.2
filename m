Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC9A010ED647
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155336B009D; Fri, 27 Mar 2026 05:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05EB96B00A2; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB0A6B0099; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 947E26B009E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34D3B5DF41
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:48:43 +0000 (UTC)
X-FDA: 84591368526.06.7F4F805
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4CCD9C0004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:48:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XIvuzlww;
	spf=pass (imf28.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774604921;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEc0lIqvlvaSXYtZNhX2tyLTFj6ozBXcCUpCLJ97YxI=;
	b=ZMVuEZFrpUZKS9S7NmoUrYyP0Pa/KtUhGTXYiYCcmLk8H9KTL0QwkSMmqXIp9GGGDajhrB
	jCdXvIMMAA3JgpEUedy3sqywHeHTxKNvYrRIhz1pBdf/3Iq0wdTTHvEbFI9G2kqExkCB9i
	wCQZ8XnTiBoN55NLH8Uo3txKaleW248=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XIvuzlww;
	spf=pass (imf28.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774604921; a=rsa-sha256;
	cv=none;
	b=GWwnYKQeo/yNqd+ZABf2JyMn8OcbsMUAEmSzjNxd9AmXs2DNlKpgr876ZHw16TDZ8hb4zc
	mAIH2pdyZuE8CbvoSNBDtTLiYUCKk/2yePW+TRpmnN4Jpym9mcMR23Lj1IN+5R2OQrxwbM
	THW24BnK5EtsN6EU34P04PfNy2Ib8Zw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 93AFF61334;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3AE39C2BCB0;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774604920;
	bh=uC3ozkw98B2T0ybqh69BkU+YKKQ53sm/70mGSobtbU4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XIvuzlww9+w0d3N+thAzXfc9znDZ7WUg7i5xCLoyWEtLfOfydFHUiKoCbuqIGScuU
	 cjxd7jNV+G6KVXi/T9h7XCGn9Cy4WaUT+hdsXQbHIGOIPbZCZZlnu2pzbickCKUQAJ
	 0+2zCHStXV8hRljkfStdYvK30SLHZXwhiU78qpjocEo5h2PuEawgoPah6iO5NKCEHX
	 /A1YCb0U3SaVBb7EXT5asMWczhzBE7fA4s+muzosnAxa9fXJsCD9pE4TIL6hSVnUFo
	 e0vgySZfaS/bhqN/otzR3YIpRlsnQxGQz2ZMd5x4nrz+qu9OfRBZib0GRWGXRztSvz
	 ElshThRBCn+9w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3068710ED646;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Fri, 27 Mar 2026 15:18:38 +0530
Subject: [PATCH v8 2/6] mm/vmalloc: fix vrealloc() grow-in-place check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260327-vmalloc-shrink-v8-2-cc6b57059ed7@zohomail.in>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
In-Reply-To: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774604917; l=1675;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=JBxDN0g82pC84smB7v9qq2A4Kq3XUFnm46m5uC3JQmo=;
 b=HSIEpP+gWS/CI0lJnxlmSaw0gfljH77Mtt5owCSfUm1SMlxuTzAAVF4GvU7JLLlRDvUW0TnLR
 4/ZSGhlJUfKDNiY1tyUWDUeY34dA/y/qK0fs599OWmzNHGaO5xsmhJS
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 4CCD9C0004
X-Stat-Signature: fdi5sh5oofj7wgtd6jre91hdrg6hmigx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774604921-920373
X-HE-Meta: U2FsdGVkX1860joWGSgtTKeUcvDQuraKgSZ8K94rYtuckjio71awioenHU8Phz2/+Lsds/MfySBF5cIRwwuFbWV1wNvaTrXLqm2y3f5DRms2MlgnpwM+svhMVyZ4zB9vfXWDdsEuWNtivnIjg0uzFcdlDXIouMsB212MsOyEm8fXikhYmwA5ZsygaXg2vFFqNMGnc9ijOAl68Eyo3u1bfBpTHAkRc56MQtNzpr4UYiJDO3OSzRdtsEqqoXwnJ6/10rbY5/61YUorJzp9LjTmreTpjZPeyr1PzMbNQ9meATTpIhPmGkmiEb4iz+/Bu9kkDEu5rffsXvnDw6q0FfXuD2/nD5i4I3M19cRuIijWCK0JLOG81g8rWO2AkqaIrk69q45KeeeSR8+nar1a73RYDedUpduEVa9gO5vTMstGk7P+9cy03GkHD7pC/hzWlY+FVST+goOZJGUtj9aTdQNEmMarXqWSCpkyy1P9yH6h0G8Z1p0MMXtfgxjmOYcjoBQPA3IOhftvCgxHCGoPriYewXXYu8EOIPcn6TEjO+704/tNuldyjQUJaWNVSokK9h9+vyU4vbEh5WSUbktdaxgGzTU2A8wXIiQCBA9GQJ5mtLxZMgpmVb/ppyrL+xrn98BlG/EgTBd4hlpRRoiod0w+Gq6dfhfE06aEIROYJbz9P4ivs4pQ4vcmaGYUzG5HaM0KR2l2rs2ZNGEo5npVZ1j8OFuH4g2uCzC0jZ7/v7SkINbmolifn/W1FgYxUDaIbG2mj+L/eAj8P/O7fZ6cuWhLcobHJTXLEVjbN5BZgRoeHo7RNIjFdkHCYFhg2HTG/VSGru5JQ++1S0C9oEDhHKUGqT4EZl7ug3I8IRQvFJ+ou6C7KUBS9nUm0sVvl0QZpK2xQ/P43r4m6GUnoe6+FwZwUDWoTM2yX08tXMBbDs70Uov4uewIoyf7uOtB6c37WWPKULmbeCXK38SHEIo6XWT
 u39pKWsF
 cUUC1UuG+1FazhEcB6TRm7LH4fzx5Fab4tE0gir1pSzauWLgLWefKUw4z0C8paNqFabQFg/Uz43Ugy3+9z4aFquu581q+HbhuS6BpuzWyXfZ152wv+C8hnPQRVAecKUbxr0sIClQyoGaW+1t0nUInIqisxdYqbWyJMXY8Ct72TT9JBtDs9BW2FldQrKk8c4ciy694+rCfu1maAJqGnJVBD8mpuF88IxYSoB7CXGZx4Hgf/1CN1wTF33DXin4tuWbqL1NFzCKlC8BECzNy4I4FhxTL8qfYcMaTN8iPVZXn+rpmNEralYqOBUHYGLwEizg76LMcOCRiBRu0jIkFk/j8Pty4DZ5FbossHPUsL91+4ntpPro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Fix the grow-in-place check in vrealloc() to compare the requested size
against the actual physical page count (vm->nr_pages) rather than the
virtual area size (alloced_size, derived from get_vm_area_size()).

The virtual reservation size (get_vm_area_size()) does not decrease when
pages are freed during a shrink operation. Consequently, without this fix,
a subsequent grow-in-place operation after a shrink would incorrectly
succeed and attempt to access freed pages. Correcting this check is a
prerequisite for the upcoming vrealloc() shrink functionality.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 79a57955345d..133c3b0418fe 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4343,6 +4343,12 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
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
@@ -4361,7 +4367,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= alloced_size) {
+	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during

-- 
2.43.0



