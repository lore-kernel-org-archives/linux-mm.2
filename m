Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9809ECAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6E48E001E; Mon, 15 Sep 2025 09:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA74F8E000C; Mon, 15 Sep 2025 09:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96398E001E; Mon, 15 Sep 2025 09:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2B368E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:55:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BD3F1406C2
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:55:14 +0000 (UTC)
X-FDA: 83891631348.27.9E8E896
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0AFFBC0005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:55:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lNWfE7ZL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HFd5SR5T;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lNWfE7ZL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HFd5SR5T;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gr2Y5vpWLhYmkFvvE0c3RnudTXKlGf10pEcNoBQE900=;
	b=GhAOW4wjq9jDL8aLTYWRY6DuMDRBz+qDuGPtcalVZMLldwd874t3Ukjd/hrL0JC/xQ+txO
	u7mU/Ihk808tz/s2q7o97J0y+QO8QlGB8l9dx8Tgtd4JIIE3F0d6livktwMDJk3h7fsGPF
	A6L7Va4sQzZZ/iyqx+GktW9MzEk6D4M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lNWfE7ZL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HFd5SR5T;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lNWfE7ZL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HFd5SR5T;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757944512; a=rsa-sha256;
	cv=none;
	b=J9bo6qzsKywTZ2q9CfA4wk/J2PsrL9SVocRCZ061/llpxATjK3/nH+TiXyx853JlArm0r/
	HNismo9VI1ihMIf8nM79JlPRmbilsW5z8M/DPlSQKBHYBrz0gtu4lYs/yv7Ei8Z6d7TEv1
	HoWpUn+FQs6F84HC2pCRbmZcLu1UWoQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4E2191FB56;
	Mon, 15 Sep 2025 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757944510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gr2Y5vpWLhYmkFvvE0c3RnudTXKlGf10pEcNoBQE900=;
	b=lNWfE7ZLvWo3kC3UhnIq11SZFcaFo9jK8/G/Wzw+hou3aNcyIYMbCcWVj273ML5pKN1w8/
	epN51z1eIUbu8hDM753phtn/vr3I3yluVcw7nsVGAo1ujt6MMVYytjpwmxEEh7+/DTIISZ
	fEIIWZfCtmxlCBrZphAQlFJKRCkkpP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757944510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gr2Y5vpWLhYmkFvvE0c3RnudTXKlGf10pEcNoBQE900=;
	b=HFd5SR5TPuFbGxd1Um+Q7J5LAunMBFUxKrILbNBmmuY+TwgnQq2Aa9BB33jMEqv7BpASQz
	C/ndCSxLIO0erZBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757944510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gr2Y5vpWLhYmkFvvE0c3RnudTXKlGf10pEcNoBQE900=;
	b=lNWfE7ZLvWo3kC3UhnIq11SZFcaFo9jK8/G/Wzw+hou3aNcyIYMbCcWVj273ML5pKN1w8/
	epN51z1eIUbu8hDM753phtn/vr3I3yluVcw7nsVGAo1ujt6MMVYytjpwmxEEh7+/DTIISZ
	fEIIWZfCtmxlCBrZphAQlFJKRCkkpP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757944510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gr2Y5vpWLhYmkFvvE0c3RnudTXKlGf10pEcNoBQE900=;
	b=HFd5SR5TPuFbGxd1Um+Q7J5LAunMBFUxKrILbNBmmuY+TwgnQq2Aa9BB33jMEqv7BpASQz
	C/ndCSxLIO0erZBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38BE21398D;
	Mon, 15 Sep 2025 13:55:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0K+QDb4ayGhnVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Sep 2025 13:55:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 15 Sep 2025 15:55:08 +0200
Subject: [PATCH v2 1/6] slab: Remove dead code in free_consistency_checks()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250915-slub-slab-validation-v2-1-314690fc1532@suse.cz>
References: <20250915-slub-slab-validation-v2-0-314690fc1532@suse.cz>
In-Reply-To: <20250915-slub-slab-validation-v2-0-314690fc1532@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Queue-Id: 0AFFBC0005
X-Stat-Signature: s4ow7cu7fgprwnxsw6yttyh46tnnz3jr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757944511-203772
X-HE-Meta: U2FsdGVkX19ljR6nn+O9q/xNxXWcjdPLK+uz+OaQ53PkHYNDdhV+WlBwusDfydJCrisR5eZJOlEoR6sh4v67KsplgX7QlpyAlY0r24i6L9oaz3o1U8aVY52f+jP27IVpeiEmu7g9HGzGCfv11hUFJefBdNhYXr50p38wuhsUHFPzFw9M+k8jLTigfuWICHfvCQaE7WFIjDPrsQOA0VKVrz8HV+7hWDBhz8F+mYytG3qMeDiVuoqaeNzJ7S8k90MIU9W5bZzgyFkQ0Dblk5A6Cl7sy0YLO5vqI9KQC6Rgv9eZ55HdzzMjJnfQ/xiU1cThJbKK8nnQEoNJZw99LBDaBZHZ6YNepEAspPZkH82iVAiXmayLSUz4OZMi5VtJHTCUuijeL/zXcrnpJB3QR0FGI5cIaSkY19LXp6bDJNe/K437GjqmvJTtlDdrylSVUv3t++4w1QcyPkSuyhV0KebHp750XVbI6x1pBOLkvUp1e+/Gep1LkllK3obtq1GLhg81C2WcC/L156yT8YCHND9UrzRnFXgQmwrW2SaQya6zYxtKosAyE8EhCL+Rw9jEFEa71YZaQmtDng1XmHAoGNBw5pVDON/vLU0nN/PZtIeVUafWpoaDGEnmjPU+iOiq1tzfPQlaRpcLT4s+5Fl1FzRRpUvpp/kbnDP9Anz37xUv6AEgIj5dlCqg50r+qE0enzSSn4hoT1ssviImgXz4gVjTEEpclLd025c0q/XsTqAm3ODcSjJ7pKeafNflus7OENRDH1Jn9LgJYhXyC5QXGQKrTC/3Nv46FPdcVigtSeF8SCsguimOk96IoMAAO4wz2UGK3nqYUKLEImuNPl0NSACoWW7vj7E1WJcM1pBS1WmeeKi2nA6JLhi1kL0WhIshvEdjZBLsMfF9chPNavdpmtHDqSxyM9aVdQ1ZUFtg7qBRgwT70hihT0D29lBb9XRBJ0xJm+o1PInlYBzpKX2pzod
 12iDqiIf
 Dojhm31CNaO1tNU8pLnMrb5IYa+XE28/BZZQEy8anXYJKbGvDMIetNCau6c1XXl1MSaSwnWlZV+GL8D9ohPjFgOVpBQZsvcT++MJ9CijpLioRVdeyNHNU+13AkjTTTnRA1LaWUaMjL/yOW68Hcs/LULQbbxwH6yS3NjQgcILCvMdGxrhUdDcXU7poSpXxgo54JN4q9Q0qbtKX2mye1K1AN7TTa+lopBSfgq+JEZ6XTXlrCmSjU1VQ0fX2yd6UCCspp2dSMG1rJP5uErkCTOggRk6QR7IUej2Zxms5k5KH0gbtMgikhYNsrwTXdALiZhKEfPc+GgBygACVMjlVP8MgRS2WU9Vkw0LuyhQE7CVpyuqKpdHfL9PdZLYCGiA58CTLWcicpPw5V8wXXtBwJE/bRWTZSon5UF7nWDzf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

We already know that slab is a valid slab as that's checked by the
caller.  In the future, we won't be able to get to a slab pointer
from a non-slab page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 3062f56bf49882538ba5af407de9f69c451f2e29..56143bfd1ae319d384981c810a5ed84af00f4afa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1684,10 +1684,7 @@ static inline int free_consistency_checks(struct kmem_cache *s,
 		return 0;
 
 	if (unlikely(s != slab->slab_cache)) {
-		if (!folio_test_slab(slab_folio(slab))) {
-			slab_err(s, slab, "Attempt to free object(0x%p) outside of slab",
-				 object);
-		} else if (!slab->slab_cache) {
+		if (!slab->slab_cache) {
 			slab_err(NULL, slab, "No slab cache for object 0x%p",
 				 object);
 		} else {

-- 
2.51.0


