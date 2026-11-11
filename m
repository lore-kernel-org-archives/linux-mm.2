Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44454606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=y7keX7SP;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=C1TEaLCw;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=y7keX7SP;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=C1TEaLCw
Received: by kanga.kvack.org (Postfix)
	id 6365F6B05BD; Wed, 11 Nov 2026 12:51:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60ED46B05BE; Wed, 11 Nov 2026 12:51:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6096B05BF; Wed, 11 Nov 2026 12:51:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 263656B05BD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:51:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A34E21A039D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:35 +0000 (UTC)
X-FDA: 85423580550.29.0429A98
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id ABBFA180009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=y7keX7SP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C1TEaLCw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=y7keX7SP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C1TEaLCw;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419493;
	b=J4SmehxFrZrD8C3qkeegAwolfWvjz0XvraHpulY4lDJqYZLwFZl6I4J5GFWE2lHpKW63Zi
	s3pPXq09M+YwEadfwbcZcB3SnCGo06wqxKtXVK659pX0Lr6vQVG8bZv41A7FBZ8omZtJMd
	Y7UKG1gtu+reHywu3/lZSvxbOlmorBo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=y7keX7SP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C1TEaLCw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=y7keX7SP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C1TEaLCw;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HkqMEXHssYjLLBNIwiF5Pzm915kgvKjB+ro7dJ5uTRg=;
	b=Rf9FtssQQWU4HQNf5iUIH1HvF2NpGIIjyx5DYYdsbSSwkJbkq2wwu2gWeGWX/Uhlw8YZWa
	QuPbxBA24mxliuPnKUaz6PWt3l7RKcpvgNES9p9U5wMGsuSKGVLAj+W5chIfzxfggvmfpu
	f6qLFhQJn3eiGSPojIPqpenf5e3ueBI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC93A21E49;
	Wed, 11 Nov 2026 17:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794419492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HkqMEXHssYjLLBNIwiF5Pzm915kgvKjB+ro7dJ5uTRg=;
	b=y7keX7SPlHlFUo6cKdBAdcnfjBzt4Iyk+kjp0mmeAecFN9wqqsqrBmj+xIQXekl2Phh1ZO
	klF8NSfcK4x7pQSxmS55Mhqov1yaeReA2Q+cV6GOA7o9ljgWIE03GgRZ65WZDb6uinfklC
	Z/ZSrwSzQtW+hwD/RKRWB8WBOyfcwYc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794419492;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HkqMEXHssYjLLBNIwiF5Pzm915kgvKjB+ro7dJ5uTRg=;
	b=C1TEaLCwrWEsa0rzeNwh6O0ENQyi5rCHq0SjTPGgha6bEzGzNdpQPrtaMSVZc+p7rC6/Pn
	sHP4c3rR0DQ0PPDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794419492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HkqMEXHssYjLLBNIwiF5Pzm915kgvKjB+ro7dJ5uTRg=;
	b=y7keX7SPlHlFUo6cKdBAdcnfjBzt4Iyk+kjp0mmeAecFN9wqqsqrBmj+xIQXekl2Phh1ZO
	klF8NSfcK4x7pQSxmS55Mhqov1yaeReA2Q+cV6GOA7o9ljgWIE03GgRZ65WZDb6uinfklC
	Z/ZSrwSzQtW+hwD/RKRWB8WBOyfcwYc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794419492;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HkqMEXHssYjLLBNIwiF5Pzm915kgvKjB+ro7dJ5uTRg=;
	b=C1TEaLCwrWEsa0rzeNwh6O0ENQyi5rCHq0SjTPGgha6bEzGzNdpQPrtaMSVZc+p7rC6/Pn
	sHP4c3rR0DQ0PPDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B14F1339F;
	Wed, 11 Nov 2026 17:51:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +SJmCxur9GphXQAAD6G6ig:T9
	(envelope-from <pfalcato@suse.de>); Wed, 11 Nov 2026 17:51:31 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/8] mm/khugepaged: flesh out try_to_unmap_flush() comment
Date: Wed, 11 Nov 2026 17:51:21 +0000
Message-ID: <20261111175121.1328383-9-pfalcato@suse.de>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261111175121.1328383-1-pfalcato@suse.de>
References: <20261111175121.1328383-1-pfalcato@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -15.80
X-Spam-Level: 
X-Stat-Signature: 3kbo5b3jrdmij6mr54d5tiuwtmxyiabh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ABBFA180009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794419493-998871
X-HE-Meta: U2FsdGVkX19+ry4w1I9xbjBSONmlq2qvsDJOWMPzx/bTzMzsrKnUFvkVJ0aIPXqcgFxg5q1Rd86Xx+cZlhkEGuYiB+XdBS3XWdU7v1sI0igq7UXiTp1Z/k5/zFPt3D8Km2XzXn1/MGjB4eZheWl3ESA6ASkhvRj/jB4Q75uFZd4Aqq6bkil/dFHbOeiU3nweS5IIrZJiWyXTbOlkp8HE3c/UQFJ6WMWEgXh5XAmshbJU6A4gtMac+dHSFXyUwrTNLx0ohNmueZ8+5HqA9/pUDA/aG0R4Y9qbvIfFwLtL55bYpPbKWd7HMalRCFGwDyl4rp5wm55EA29GkdywAT80x0lnWEx/lcX9yHS2FfRvLtMHUx/1Ahxszh5dWmWYuYmb1JwZT88eZa3AIZ3pniBERXmDjG2GUhM83G6s4mTqoev+KezBUhwlWInRwH75mG9ihRPM3SUnDHOMD5UOqA9TdCcf5DwpOeNqILOOxkZlG/OnSrEy1SmzDCMQiEXMbUTNt2sh5qkc+LGz5QELNv9SYBb3vpxFNMkph5Hq13FxzL8xAeFFz2b2xjjbWKb4zwMFbCPj2mEdCP4vQPE+o0G7DqCcjZYrOcHPHe96oyqDn9bAa0Jn1QhLllW5wxt1nb5WxFWM5WvM+GhBlhRy6mFK62DRVyPYtcw2+5By6HL2J7VZcQXkRTnzrzYamLjlDmzvuV5jgI/40YVyNP6geJnBZtqOD8R0Yj6KZXfe4KUKSfemdCtWB9ptm43p1dCLKaP/0V9Uf20Oxqtlwx+N3lF9CQi896hKDou5kviV8VYXtns9DdZhefW3Z1qSNsTtqZ9AnqjkdetsnsJxK0KDNYwyEpR8sYaHIqFUhR6dQYTXxO8y8kJCQ2XEIiNoSRQDnvB3sAhM244sYCHJ/jZpx1t3eiyhaajF5yMFiZxcu5XqVuk//G7MOZkhWHw93CGaZcE3ddnWIPQ5+GWcG0pQUa/
 rgVyZY4v
 Hes0nkkQYbZ25RMpv1td+NFV6zH8P00I0d7Ztvhqg+Csy7NB3R9mc+OBIf1leDC3k+Kti/Z5daABAEP/VzuVafC/WewnRif6Tv3NSphDoL9OFDOmlivmK4VeJciWXyQbTOKyQWiaX2J628Uk/1EvvMEC4He0dT2Yu7+2lMDQwApJaEzswkbAs5kQLePQ3IU5jetoKUBvf+L2lOWPF/TzINr682yYgHFCBHG8RfqOqYnC3iCKFstSTz2KGBvuWwrIOxkqjy+WCdtdnVfcUpWxZyyQDuFWz4AvN/ho3rWw9nQz6MPhlvdR3DFNOVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Flesh out any correctness concerns with try_to_unmap batching, flushing
and its interaction with the rest of collapse_file().

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index accd8b4895d3..fd947e698ed0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2597,8 +2597,12 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 xa_unlocked:
 
 	/*
-	 * Flush before copying the folios, or releasing them in rollback.
-	 * This is a no-op if out_unlock already flushed the batch.
+	 * try_to_unmap() flush must be done now before copying, regardless
+	 * of success or not. In case of success, folios are about to be
+	 * copied and collapsed onto a single large folio. In that case,
+	 * stale TLB entries need to be flushed out, so no racing write may
+	 * get lost. In case of failure, stale TLB entries need to be flushed
+	 * out before putting the folio (which can possibly free it).
 	 */
 	try_to_unmap_flush();
 
-- 
2.56.0


