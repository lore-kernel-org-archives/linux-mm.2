Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1B91C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5783F6B00BE; Mon, 20 Jul 2026 10:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529246B00BF; Mon, 20 Jul 2026 10:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43FFA6B00C0; Mon, 20 Jul 2026 10:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18EE36B00BE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:29:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92E0B1C012B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:45 +0000 (UTC)
X-FDA: 85009388730.03.5202C36
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 948C320007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="F4/kNHtf";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="IVH/Cz9M";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="F4/kNHtf";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="IVH/Cz9M";
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJE+9lZzjBh6Jglu9uhAVEd2RMCplNuIFAAggzteniA=;
	b=Sa+JJ95dVXq6uu4R/Tz88qluqbHBTEvFdPBWZ2YcyPhPp/HX9IgeYGfvgpRF+MBGYGo78K
	wNBLK7P1cD+YJD18O5JTmIcLbBw3o/svBjnucbA7y4jTvzWSIXjivlhfs/LAsas5qXA4me
	mRpKLH6T5jGsO7Gz3h3jMheT+/Lc7XI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557783;
	b=V8n1eEX5hRX8vxMfeg5Rs4uKnI1AD3McK7+aTs7W6BNmpYPDDlXz9NSCaGOoQLiVqYT1Q6
	1fAQgi4C4lsGe9JhL7J+LJVzMlYrrbYDe6mi78SFyxMdCQW+6ksFvjKwPJkFYQQfQNg4Cg
	gou2PKLfPi4q7/g8nVjjrxFzEzaOBps=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="F4/kNHtf";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="IVH/Cz9M";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="F4/kNHtf";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="IVH/Cz9M";
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0046279FCB;
	Mon, 20 Jul 2026 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784557766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OJE+9lZzjBh6Jglu9uhAVEd2RMCplNuIFAAggzteniA=;
	b=F4/kNHtfryO0CG7lEx/YsClXVlnOiVsDbFjQ/58/kXndEa6KCtm+IFQCf+5y2AREyh6VQS
	wPTwa9HJdaXtCLUA2wsz9hCjDhjyVxapNzXoBrI69AgD8mwQ2mEhtajas2wd4cJ3TgV1TQ
	vPjeA9riOZENzmXrgQrrD6NSBM2uvdg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784557766;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OJE+9lZzjBh6Jglu9uhAVEd2RMCplNuIFAAggzteniA=;
	b=IVH/Cz9McsHkxDnzOacIPsRLqvfjMtn8k/LvzEI9ixGJjN2BtmnL9OevStXAjFEWQGl0aP
	2yxEgaresH93GYCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784557766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OJE+9lZzjBh6Jglu9uhAVEd2RMCplNuIFAAggzteniA=;
	b=F4/kNHtfryO0CG7lEx/YsClXVlnOiVsDbFjQ/58/kXndEa6KCtm+IFQCf+5y2AREyh6VQS
	wPTwa9HJdaXtCLUA2wsz9hCjDhjyVxapNzXoBrI69AgD8mwQ2mEhtajas2wd4cJ3TgV1TQ
	vPjeA9riOZENzmXrgQrrD6NSBM2uvdg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784557766;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OJE+9lZzjBh6Jglu9uhAVEd2RMCplNuIFAAggzteniA=;
	b=IVH/Cz9McsHkxDnzOacIPsRLqvfjMtn8k/LvzEI9ixGJjN2BtmnL9OevStXAjFEWQGl0aP
	2yxEgaresH93GYCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3576779AA;
	Mon, 20 Jul 2026 14:29:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kOipN8QwXmrKTQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 20 Jul 2026 14:29:24 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] mm/khugepaged: fix and flesh out try_to_unmap_flush() comment
Date: Mon, 20 Jul 2026 15:29:13 +0100
Message-ID: <20260720142913.846902-9-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720142913.846902-1-pfalcato@suse.de>
References: <20260720142913.846902-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 948C320007
X-Stat-Signature: 4ictmfoqe1x6ig351g4oi8u8b4g9ssy6
X-Rspam-User: 
X-HE-Tag: 1784557783-217657
X-HE-Meta: U2FsdGVkX1+bflb09fzz3KQAfKdp80eKqTKLVAQQHoFvdEsDy/vYGfWBNbdD9lAuJyp3ZiKcnF89gz3j7rHdBI5TYnnmlFnXuTXprA81TlAodWavNfMe+Z+rRkP5siZ1E5n9hLMPGY+NNNb/LGZpavpVrBPdVH9p3pGvvzIsHSApiqKQpN13rtYrlhZuwQ/iBRCL3g5kzBsNgWUsbxpKHvXD9LWX45WL6FJ2IDKp0P3hklihtoBvcvSRAdc8ACip1pofJZaQloAdYVxKgg4U6b9IXpth7ulgnjQSWhW6WEOrXeO3idCk2ZgvvDjdtgnwOLvPjViHVsXYqhp8XeiXeDL58GdbrinXC0SdcjtTwkz8xBJQl6rdmFQyXyLHs6UgxWFSFIgPsPST5418QXCjn2cwfUP4TYuIuapWDWsYD0z1k0JhmX8O4M/bO2apZgyMHYl9j/qFIkmBd5vGokRfMRqzy00PCBvq+wfdxWst2LgGQ/5KEESzg9wP6hy4B6w+nwr87CAqVSxXPZPu8GkT8YR4lmGa1qpi/60olRDjuZs3NPximSbsPLF9cCbeozVMO8gK32QdA1som6Su9HkX7bnXwg4SaK0a+nQqlAHccErOYIoHG92RcyjWJVU2p+Rp23j1nEAn82g4FdjIwiEZQjwAmvaFEH5B/hjXQzuEh56Sww2s0BB/UCDJ2j7T2bOVdlYvu4Mgv/tLabk/9ESeYAzvxn2ufHStwwmykH6SGR+/J5/vdie7WlzSef++zMUbvmlfi2z6sS/3Ba1qojmZcuxNJ/yjYBJvmxnGdYrPBvtBGaHTTz8QgDbXoY8oF9Zw3IzaWoQuVwIRFCzH7aA10aZ8knpPrdtPggX4GtBGT84DvCEYRJ0HU7JhcpxzOpClX04dtFyYNZfuZWCV+yqURLsyYSPMoccZd0nWeWndvA4JVkwpRwLupOXY29F3EsyT9e4tV5mz4vJz9LHVmp1
 mUi2IpuG
 ZokxywfPRyaFwkTiqiB25KiHlCkzRFhYCDqsr/qf8FIqZ/n/1HLiOA7E/j7TDEN1oFhQdaUIY4yWet3yWEcz1xSpEkKQMfi+huWHODN+orIGbAyF7Y9QOOvhJxeI+P7AjuVBDXeHH0OI/n5XGPYYtYgwF1JHWLY/6SeonBCm8OeV2ygp0WcRmFiO+dn/CxrYrpeeHWQDWmMoWWNtm4YrRZDavS5G/wCHzbxmb4f+hdGFhDrVVvU7DHLLJve9lUF8Ija85kbICEgw5fARXQHNWIhn0dsanAoOwNAOxJ2GSLNBwm1+gUj0erq+5tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of vaguely handwaving that it should probably be done, flesh out
any correctness concerns with try_to_unmap batching, flushing and its
interaction with the rest of collapse_file().

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a09e4e4e1943..1999e094df20 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2560,15 +2560,19 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 xa_unlocked:
 
 	/*
-	 * If collapse is successful, flush must be done now before copying.
-	 * If collapse is unsuccessful, does flush actually need to be done?
-	 * Do it anyway, to clear the state.
+	 * try_to_unmap() flush must be done now before copying, regardless
+	 * of success or not. In case of success, folios are about to be
+	 * copied and collapsed onto a single large folio. In that case,
+	 * stale TLB entries need to be flushed out, so no racing write may
+	 * get lost. In case of failure, stale TLB entries need to be flushed
+	 * out before putting the folio (which can possibly free it).
 	 */
 	try_to_unmap_flush();
 
 	if (result == SCAN_SUCCEED && nr_none &&
 	    !shmem_charge(mapping->host, nr_none))
 		result = SCAN_FAIL;
+
 	if (result != SCAN_SUCCEED) {
 		nr_none = 0;
 		goto rollback;
-- 
2.55.0


