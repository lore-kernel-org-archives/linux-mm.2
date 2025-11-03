Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16884CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 12:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71EBE8E0068; Mon,  3 Nov 2025 07:24:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF138E002A; Mon,  3 Nov 2025 07:24:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4FB8E0068; Mon,  3 Nov 2025 07:24:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5FD8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:24:50 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF016160110
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:24:49 +0000 (UTC)
X-FDA: 84069214698.03.ADEE729
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 661C420005
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:24:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o14NnLdn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mq4f+xmE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o14NnLdn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mq4f+xmE;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762172687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KeTeEG4nIfVPoLqtZ97rZ2qT6HDW8DCj4q3+dHrn6T4=;
	b=qnRoolIzCbg9EON4j1YtYcxTH3/AtdemVUp0TlokGSCsN2r4NxaI2l2SDJVlwTycLFRTP5
	U/fsrqwptkONq59Mi41+GwOg17bzTneX4p2rs7OeTwjYlDW8TMmRoF7j25yW7klgY5SvXt
	G6nVLoe9h6xr69p0JW04M+i6yb+ywUw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o14NnLdn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mq4f+xmE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o14NnLdn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mq4f+xmE;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762172687; a=rsa-sha256;
	cv=none;
	b=uo1gbOmmAqYfrOSmZg0sooKqnfjtLN4TdbjyXW77SMwXPXgcd8fwdMbH7KotaZu96IG92D
	3ZwZNPFOG1pdmTC9ByMNF5nM8Hufv2VTPc4cpx5/fUNmKxcS71+FF4WW6TXQ+Og/t7PqA1
	1JS+C4PP0WZqwGccv4ImA74mCzOJn2M=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 959DA21AEF;
	Mon,  3 Nov 2025 12:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762172685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KeTeEG4nIfVPoLqtZ97rZ2qT6HDW8DCj4q3+dHrn6T4=;
	b=o14NnLdnAVsjOy91XWmxGYFTuSPv0bs/u1WOMDep7I6oNp8H2jdMPMiKYg14S4OnOnbRck
	oIorCN6CHKv6IE17DLsT23MKW9tkzPzVZVuFLAnfKW2Z6YEUIcWxEHuiYMvQvUFOifGoxv
	Se/tNlAIr4qi7kHuszt+r5ZMOplphI8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762172685;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KeTeEG4nIfVPoLqtZ97rZ2qT6HDW8DCj4q3+dHrn6T4=;
	b=Mq4f+xmEVxf/WJUXohVFol7JKlziud7xcsKC6v4UfMNxcPCN/LGTmFOQ2EAfnO3Cy1/PM0
	l4oxEzyVW2ZGfIBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762172685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KeTeEG4nIfVPoLqtZ97rZ2qT6HDW8DCj4q3+dHrn6T4=;
	b=o14NnLdnAVsjOy91XWmxGYFTuSPv0bs/u1WOMDep7I6oNp8H2jdMPMiKYg14S4OnOnbRck
	oIorCN6CHKv6IE17DLsT23MKW9tkzPzVZVuFLAnfKW2Z6YEUIcWxEHuiYMvQvUFOifGoxv
	Se/tNlAIr4qi7kHuszt+r5ZMOplphI8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762172685;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KeTeEG4nIfVPoLqtZ97rZ2qT6HDW8DCj4q3+dHrn6T4=;
	b=Mq4f+xmEVxf/WJUXohVFol7JKlziud7xcsKC6v4UfMNxcPCN/LGTmFOQ2EAfnO3Cy1/PM0
	l4oxEzyVW2ZGfIBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7CDC81364F;
	Mon,  3 Nov 2025 12:24:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BjdoHQ2fCGmOWQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 03 Nov 2025 12:24:45 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 03 Nov 2025 13:24:15 +0100
Subject: [PATCH] slab: prevent infinite loop in kmalloc_nolock() with
 debugging
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251103-fix-nolock-loop-v1-1-6e2b3e82b9da@suse.cz>
X-B4-Tracking: v=1; b=H4sIAO6eCGkC/x2MSQqAMAwAv1JyNtDUFb8iHqRGDUojLYgg/t3ic
 WBmHkgchRP05oHIlyTRkIEKA36bwsooc2Zw1tVEtsRFbgx6qN/xUD2xqyu2ZKlp3QK5OiNn5T8
 O4/t+xNOKgmEAAAA=
X-Change-ID: 20251103-fix-nolock-loop-854e0101672f
To: Harry Yoo <harry.yoo@oracle.com>, Alexei Starovoitov <ast@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1904; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=wQdnkU9hNx/O4Iwg0uQ2HzLaNraSVxoh2c1MXQVwov4=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWRyzPuadbBx5/ulLL5bhM5remqunmjx3N2uOuDJLw7R9
 N3nir+2djL6szAwcjBYiimyVO8+4Sg6U9ljmofvR5hBrEwgU6RFGhiAgIWBLzcxr9RIx0jPVNtQ
 z9BQB8hk4OIUgKnmF2T/K+dpcSq46m6IiEnI+wwVy06xpIWzpnWZRL6f5ba1TsF1a/HXtMR1F9c
 Wf/LqN0vPPdhmeyDEO7a38d6HaTvaFUpf/ZmWFeX5/qmaA58Y92O/aLXlM5OunbP+7XTu41cvvT
 NhooU5m+3nT7pdO+351nSv2OyLea/bfDjS0ovfr3TX+Lrkd02h8pwwjrkuEnHccxm3Ke5d8uzS2
 7CPNUZ13y68uay9rpTHuG2muvrcS9a3LbPMpJNuzwg1WDPtwMnUJzVhzRck9qq6L7KfI5b/Xcr5
 4rHW0jnrXPb1PWfvflHJ9ExKp+mGVZvMqVtBf+K1q98KXNwfKROwYoleYNmUp1ezvf4aZLBaz1j
 7WTURAA==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 661C420005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: zxdanzornw6cgbmcjho9mxgzbtfe97gz
X-HE-Tag: 1762172687-570157
X-HE-Meta: U2FsdGVkX18lQCDywubbwnAnxtL+4AsC0XZqWkSqpQN5X84+H2hDi2UA+7hIIbyzzY9GVq9aiymuJw9Ek1bUdn+cE05/PvTZRe1ilR1hxhbLTgNG+ILNgCRULPOVFrp9cZZTZulPjKQLRrwMWxD94ZzdjwCmq3QAfYR8M/14OsAJBWPUAsXAdNBUZymDM0QKQ80vtbP8AvVr9IGsegFnjMNZ3xAac2F1PyF3Eapca/cYRH2EXNo+4N9dAbU/GMKksGwPUWfcIsCq4wO41pLiHozBiR1sXwcO6r7okllfFZKC5GLPUzTWVu/cYrNfdgAzHElI+LD/ASWhGipGGIGaB0fbhwkurAaCZmDMqsQM7wNoPEdFEtH3Nk3B2grFuJKxz0LuUvktzMIz9pWbGgRRzBmj8ZLku58LdM6GYFxDREeWuwbi0imS5seB4qNh/Novos9d8bJbSnCvXy+9iRz/WjdLEPjZt+EwmvwQINRfrmRhvp0QSg6uNF2ph7kLg0rwIf1QHzlaf+DC75UXLdtSMRuDM8KRV0Sw5cKJLfQNraDOPPXdEKwwbd9Ri+3gZq9HWlfu3Yww6yviqU3XdC+UVqsoZcMiCJoH6OAIp/x4GJ0cf8GWURMl+b8SDtxQaBeiBWR6JK1Bxh0i/mappmXpNbP3ON96jEZSf0Z8ztmZ5ocj2I2W9LQNugM/XglqXUecKpNtsEAxSNqf7mBbHNWrgwYAjd9X3oHoLPh84/70dAAE/qz/fd5dJZWicI4yU+vav2YFmindEVuw3EjvPmfmn+tqyaGgWmLL0f/Q036QEJ1e+RprckFmdjTaNTqSQkv+iJGrzlka2ywjQRPQLSEvMlPN9tFst7W1VK9yXpX82BJRSTF299bNT2yNRey5NRgL6zxk4Hgq7SREozuqA1j9OgtEkbW+hYHQJn1yAEHXnIKk42NmRzsW8rLfYzNVSYhLmfIJBwvukJrXZrxcOE2
 PPGBODDN
 /zwa7yWkzHF0x6y7xwzgawE5lfCxj9u/u/1UX3/V0uXLdKbq8s3xvQFhf2dyDS01jqcVspQzsmkbRtT0EkVCwrXIKUVjUxvbJtNjBh7ZtT8bscpnCPkSxwv68pkHG4QpBh17qpmlvBRQ0dmLj14WcbL8viPz1q9a9Do3kkz/uhr4mEvMRV93a8QI9q7kJgVblVqsn4XjpLSLVWf4oC5FGY8noY8lr12LTfp0L6z9RRPaiOSjJyOKy3+pACC+zIoxmjCqhyra3BRQfbNkVT1mogjfDZBchj195pB2aoFP5u5LD0Z7QZ5xz9nrRZjLSI12d00I0tM8Xq5iJeO1Gfe65c0luKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In review of a followup work, Harry noticed a potential infinite loop.
Upon closed inspection, it already exists for kmalloc_nolock() on a
cache with debugging enabled, since commit af92793e52c3 ("slab:
Introduce kmalloc_nolock() and kfree_nolock().")

When alloc_single_from_new_slab() fails to trylock node list_lock, we
keep retrying to get partial slab or allocate a new slab. If we indeed
interrupted somebody holding the list_lock, the trylock fill fail
deterministically and we end up allocating and defer-freeing slabs
indefinitely with no progress.

To fix it, fail the allocation if spinning is not allowed. This is
acceptable in the restricted context of kmalloc_nolock(), especially
with debugging enabled.

Reported-by: Harry Yoo <harry.yoo@oracle.com>
Closes: https://lore.kernel.org/all/aQLqZjjq1SPD3Fml@hyeyoo/
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
as we discussed in the linked thread, 6.18 hotfix to be included in
slab/for-next-fixes
---
 mm/slub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index d4367f25b20d..f1a5373eee7b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4666,8 +4666,12 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	if (kmem_cache_debug(s)) {
 		freelist = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
 
-		if (unlikely(!freelist))
+		if (unlikely(!freelist)) {
+			/* This could cause an endless loop. Fail instead. */
+			if (!allow_spin)
+				return NULL;
 			goto new_objects;
+		}
 
 		if (s->flags & SLAB_STORE_USER)
 			set_track(s, freelist, TRACK_ALLOC, addr,

---
base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
change-id: 20251103-fix-nolock-loop-854e0101672f

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


