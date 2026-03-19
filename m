Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD2F1091904
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A5D6B009E; Thu, 19 Mar 2026 14:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731C56B009F; Thu, 19 Mar 2026 14:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620EB6B00A1; Thu, 19 Mar 2026 14:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53B666B009E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:31:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B6A2C20E0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:31:34 +0000 (UTC)
X-FDA: 84563655708.11.2A1FA4D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 192881C0014
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:31:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773945092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XFzp/7ztFWG9iILrFgd/mytbRMj1bQCPwBeA3ZJ4JxE=;
	b=kdKUDhrjSM+hrasLoJps8PvhwXl/BwyW09a0TCkihJ2h8bWY5eIqAIsy8wwXH9LeqjiU0J
	jTHdp0hnhNZe8BrTNlFeIOvg6jpD5OFtKP7iUZTTKwzhRRnYyAZ8tuBy3y8HHqNqIrqdEy
	qDMYur3AOaH/RaDRzm0iOesWO6gUc6I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773945092; a=rsa-sha256;
	cv=none;
	b=Zsm2nbH7Ik/tuRplK+Cpwj0OMtXjFbKXFDO8S4CuogkWsBoSzGmgcdyqv35mOC1HLkg4Qa
	+X6ME3JReS8COetXySmdCcurwVAmoRKBVBih0EYFdgvuWK5CFlf3MTVoOrDgOgWGKfaTeo
	dWVjr5/EKX/Be0h4tmUxIgX6MYsqPb4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A0B535BD82;
	Thu, 19 Mar 2026 18:31:24 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C63284273B;
	Thu, 19 Mar 2026 18:31:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2PTnLPtAvGmbdgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 19 Mar 2026 18:31:23 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Luke Yang <luyang@redhat.com>,
	jhladky@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] mm/mprotect: un-inline folio_pte_batch_flags()
Date: Thu, 19 Mar 2026 18:31:07 +0000
Message-ID: <20260319183108.1105090-4-pfalcato@suse.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319183108.1105090-1-pfalcato@suse.de>
References: <20260319183108.1105090-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: fdowjjfypwfj75mg4jd8qbdg59y7kkyc
X-Rspamd-Queue-Id: 192881C0014
X-Rspamd-Server: rspam03
X-HE-Tag: 1773945091-270865
X-HE-Meta: U2FsdGVkX1/L7WACZvObhxHHy8ugtiFLqMfREBW9yRgB8YychQEfxNRSI0aXQS1nsCXCE5TZ18JkSAtpeueSBZNClQNMB1e8g+cC5HLB8h8TUV2jLY0KQssmqqku8v/iQ64fsY/poROXx9wZdwO6S+x1mRTSvQJME0jlGqHKd9GFH0JyY8e85HPaUIL0Kn/FACtd2qWEZzhHbNGi6sOa9xG3rhXrG3XxPixV79T++1IP+a70aGtUwhrXVlCnjhdvL2oewkCuXtOj/TV9jhCJxUdvKjZZl6MqOuhrt7wmwoa05LbRRlnzuBmOXeVcIwwo3anQOrvljIUmZgt+7idpvnd4VS4L9Iw9jwFovPscLbQ7mbzyRtSqhghfY0Qz7DE57zUJaA+KP9MXqgm8GI31CT0VUh/mAriocVHpH9tcRuyC7+fmLyoYGJKTvJMk/28jqsTq7JWeu69WPRDOtw8oUsVAvN9I7m14wiFw4Js5pLFDElk0LwsMrmUG9SvmPsMaQiCm+Xp5gZJ72Al6Fr3Bg5eKmr9EOXsX/sNMfgO7VOtT/5eYyQdK1l8pdWQ693B6rwFtDe7oOxXrPIpeLCtvfLulIxbVqNJbMidfMgvBC9gwszk/ueKW42B75FOIxAes7wGw8LF+wQm8PfeIGDD55K3jnCdLkYopCVAzP6H+/PYtRGWVAG8fiqHdlQr8Etqxag5T1Sl3Ygsh5Zng5RC5BgphPuWN3nh+owXfyINxdcnQq49y77zhnMcKpnt86CFGr62sDRs7KIg83eojUIESsc3MoaYPqMJsieVaLNwf04piCOh3vzoHT5FMobyHgtaQQJzreiQvIi0IRZzsvr3eL8d8n0ediPOZgmCMrWldSTh1VDwHZSXdZPdEVlNEaIIOpEsISrg/T3C+UqoQITXW6H9B78as64UmOlpOzcNdOstW/deQ6Lqr0D6WYYLhwW1hjaXeyiCd1DjRIB/uVi5
 z1vA876P
 nTJ2Z1rLBb5dVAYBC2RPf8dOeINu8lZGxpQu7v8evMG9N85E+Wfka2m6F8jhzJrWsXg2FttDnK0qmFdng2CPEJDWcs8L4FtwHYKLv4vTTqJ6GHvkAjmQXkhu72aGNNvrZ1KS7ZFzq4B3lppLtPw6boK0K5c9/XULULHfVINWdx+LmBN8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hoist some previous, important to be inlined checks to the main loop
and noinline the entirety of folio_pte_batch_flags(). The loop itself is
quite large and whether it is inlined or not should not matter, as we
are ideally dealing with larger orders.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/mprotect.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 8d4fa38a8a26..aa845f5bf14d 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -103,16 +103,9 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 	return can_change_shared_pte_writable(vma, pte);
 }
 
-static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
+static noinline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 				    pte_t pte, int max_nr_ptes, fpb_t flags)
 {
-	/* No underlying folio, so cannot batch */
-	if (!folio)
-		return 1;
-
-	if (!folio_test_large(folio))
-		return 1;
-
 	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
 }
 
@@ -333,7 +326,12 @@ static long change_pte_range(struct mmu_gather *tlb,
 				continue;
 			}
 
-			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
+			/* No underlying folio (or not large), so cannot batch */
+			if (likely(!folio || !folio_test_large(folio)))
+				nr_ptes = 1;
+			else
+				nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte,
+					  max_nr_ptes, flags);
 
 			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
 			ptent = pte_modify(oldpte, newprot);
-- 
2.53.0


