Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E073FCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D21E6B000C; Mon,  8 Sep 2025 10:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9888E0007; Mon,  8 Sep 2025 10:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198066B0011; Mon,  8 Sep 2025 10:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04C676B000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:56:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1B21C018E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:56:01 +0000 (UTC)
X-FDA: 83866382922.11.FA399D7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 64FF2C000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:55:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eqGCpEI6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s3BmCaxJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eqGCpEI6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s3BmCaxJ;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757343359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jRygZKc47ktPlJUoYPJf4VhF+n2fdylD3FWdVDZ3xrc=;
	b=pfFIGrdwox4dHy6sI7OwrYcKd4le0AEc/ydrvxTE4nBsW68v4VFDncML8YQjtV19uR5GN0
	xFGJA+S0S/IH4aW3UiF0NTKfUQuxA9b3GYorr4+bw1PIas1QXK16FI2g2SINwtyq2BNbR1
	PMIBbkQCHykmoCPMKb4edIyIFUcE+VI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eqGCpEI6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s3BmCaxJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eqGCpEI6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s3BmCaxJ;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757343359; a=rsa-sha256;
	cv=none;
	b=ZKHNpbvzKzGunyne2K1fK35xp3TotFDH8mpjFPTNOrSFYvSZDPvn35d9HCf/Z3OVZrSeI6
	kul5ddl70QoNP2GCD01dX5l/zrNwaUpAHASy1421fqGQnAic0ipCCVefZNbiJbIwxrP8pJ
	UrjAYncY7389mZlvooXCdE+OsxQDgyI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9BE2B276A0;
	Mon,  8 Sep 2025 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757343357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jRygZKc47ktPlJUoYPJf4VhF+n2fdylD3FWdVDZ3xrc=;
	b=eqGCpEI6zjbELPOULgTfUeGlY2iq4UXhKORyJFOFl9gLXPsmN7f0P7WjlCLuvL2dqjg0yf
	d6qxvMSEpj1dOSYiYOgMaQ1/PkoQqusiicsfnSqCUOTFy9M2LOJescTPDno5X+QOnHk1WA
	NATEin4c9ax+6lh97m/hZiMoYhx0MGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757343357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jRygZKc47ktPlJUoYPJf4VhF+n2fdylD3FWdVDZ3xrc=;
	b=s3BmCaxJEtpSs9KwcJdLD9xaBNai6Nq6/ikgYrqBhL2kkHgiJBsdLE6+CV4zVQ7oF7vRJh
	dlkeM5Rd8fJJPTAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757343357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jRygZKc47ktPlJUoYPJf4VhF+n2fdylD3FWdVDZ3xrc=;
	b=eqGCpEI6zjbELPOULgTfUeGlY2iq4UXhKORyJFOFl9gLXPsmN7f0P7WjlCLuvL2dqjg0yf
	d6qxvMSEpj1dOSYiYOgMaQ1/PkoQqusiicsfnSqCUOTFy9M2LOJescTPDno5X+QOnHk1WA
	NATEin4c9ax+6lh97m/hZiMoYhx0MGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757343357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jRygZKc47ktPlJUoYPJf4VhF+n2fdylD3FWdVDZ3xrc=;
	b=s3BmCaxJEtpSs9KwcJdLD9xaBNai6Nq6/ikgYrqBhL2kkHgiJBsdLE6+CV4zVQ7oF7vRJh
	dlkeM5Rd8fJJPTAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90C1913ABA;
	Mon,  8 Sep 2025 14:55:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JjtSI33uvmg+VQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 08 Sep 2025 14:55:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4AECBA0A2D; Mon,  8 Sep 2025 16:55:57 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH] readahead: Add trace points
Date: Mon,  8 Sep 2025 16:55:34 +0200
Message-ID: <20250908145533.31528-2-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6269; i=jack@suse.cz; h=from:subject; bh=AqpZrtZ/C6kg7z6v65Gg8uFkvtpcZsMaQwBJ8xfkrtU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBovu5lqr1Fk1zYi3asDhW28hVAYB7ly6I64JbpK oEgE/DXACSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaL7uZQAKCRCcnaoHP2RA 2YSqB/9aesdkvRh9eBBWPOphDGmT71G1V032qSrFezPfC1ebg6pIQSc/C3YlXabbAxWfvXQX9m3 WMOfHhOjcI+MW4MG06ovA1epUSfwZiaHGB8i0xq03Dgh/AsHqoPfSl+Qvyh/FXeSh9d+bYZMc+x 9fw2RJxexIwUG4Y/msFXhKI7jtbdWNPxpZVl/TPFTg9w/Nhz/PDJN37oGVwU27+oBd1JMrhWQ5x +r3UfM0KV4QTTHPeKbg2gegCUSSJhLTeh8z035vQ1HqcfmUzEnUgMuj7M1oIzWM1y4bxl3nI/f7 Mn9e0flPQYuhMyRKAc75RKdA57VMd+PKb+S37kodQV1uBZC+
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64FF2C000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: i74zgqyjzxyenjqyxhn39gnx3rd7oqf1
X-HE-Tag: 1757343359-235420
X-HE-Meta: U2FsdGVkX18+h3Y/gh+v7ZHc4LeiB/GgYJVeOW6eJ93+O/CaV72mVGEVzKCMO/9+p4QnMyK1xRdrONkyZVma8Xx9SHQXi8ObI4BZMYHh20FGfUYtQbH3O/F9rajyuTt8G8uZRV9piT14Jp/hPkW4KluirN62e/OkWTaYMUI8ZPkBWo7jhbZQnXzotYq4Dl/3mRhdzWXaOrzekX0lWlIw4fwsmXyegHSwbI207ebdJdbOh4wRoaGl6robv0AQOVqhq2N3XfsahJLstewaxPRK6K8ZjcMrrQnLe4AhqHqFugbCJh8zXXbPCUz51XE0EwXz0mxp0crXxsLF5EUzrsXKnAcmbW8kUqzzq34DR6F88lYVgINU7ofN4Kk+GRgMwK+agcqV1++BCPX/pIUe4VcYKlmKn/yMJ/9PPReGipNPxcRUZQwk8nDfWRepKrt18F+afsD2hK8qPoIWhxANmL6WNGMoEBomr6VgVbYG72Vrh2uU8DVh3OoObFpj/Lt35ghothNJnxqmAIpFUUO8uxd5m6sJGqec9T0P7CY9LzfJ0rh1CNPk6kol2Q52M6CGX4ta9tmIHB1TJOHVxs3oUyKXoQ4CfVekmBo9eYGfpRBmLQwLGUP1T0V5D+vYFml1G4lcZkdV7LDHKealxDc40EQjng+7JokYbgrPW6gQ5iLzvR/DoB7/m9Sl08oreNHDS3sN+06/YS5IoGWtkmdz3NvQG6LVQe5EGVJrINuFQwBni2+fOQzgbhUfHWkYHXergMHpmL85y7PqfKx2MoGfB7bdGJK7fFSehPP0sEWti/6J4oyxLUcm0ia0ltJUFC8x4Lo3f6MxMYslwyOYXUTFUrgr9AOaGqNe8AxUKLjeQxFt13qGbESRaRBedGwSVJGOHo+Am/zczIA1LOUyTQVvlFEdWm8Fxjkw6RRYjHkf6asZbmxJMnzK9cT6GRoQOtufXsnNey1vZJqKEqQ2iLaYrQM
 HpLWM6zi
 57PYTqpWvzkYqWGhUp8XAryym9L1gNmcuBebZh1oF0T+FbDIVznTcwNqck5O+qg1G11Z1EMmc8t5A+Y1Vk3VAazdv8mJSSBQml82iKda7pdPdn1Yzq5vgpDEJBeZAp2YyLkOggljADa6I9ve2Ws701OJqU2+KqMFlYOEIEGGUal6lCOD4IrANzvt9JP2D3udnZxCKTGfvsvw1YKU4rq+gAzRW3+gTdMORy6gs/cF5KZa6kE6IIG00cBK6tXTp31VstpCKhol3uFx7kD+/xpIfJLFoDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a couple of trace points to make debugging readahead logic easier.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/readahead.h | 132 +++++++++++++++++++++++++++++++
 mm/readahead.c                   |   7 ++
 2 files changed, 139 insertions(+)
 create mode 100644 include/trace/events/readahead.h

I've added these when looking into how bs > page size interacts with readahead
code (and got bored with placing kprobes to dump info). I think they are useful
enough to warrant staying in the code...

diff --git a/include/trace/events/readahead.h b/include/trace/events/readahead.h
new file mode 100644
index 000000000000..992a6ce5c154
--- /dev/null
+++ b/include/trace/events/readahead.h
@@ -0,0 +1,132 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM readahead
+
+#if !defined(_TRACE_FILEMAP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_READAHEAD_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+
+TRACE_EVENT(do_page_cache_ra,
+	TP_PROTO(struct inode *inode, pgoff_t index, unsigned long nr_to_read,
+		 unsigned long lookahead_size),
+
+	TP_ARGS(inode, index, nr_to_read, lookahead_size),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, i_ino)
+		__field(dev_t, s_dev)
+		__field(pgoff_t, index)
+		__field(unsigned long, nr_to_read)
+		__field(unsigned long, lookahead_size)
+	),
+
+	TP_fast_assign(
+		__entry->i_ino = inode->i_ino;
+		__entry->s_dev = inode->i_sb->s_dev;
+		__entry->index = index;
+		__entry->nr_to_read = nr_to_read;
+		__entry->lookahead_size = lookahead_size;
+	),
+
+	TP_printk(
+		"dev=%d:%d ino=%lx index=%lu nr_to_read=%lu lookahead_size=%lu",
+		MAJOR(__entry->s_dev), MINOR(__entry->s_dev), __entry->i_ino,
+		__entry->index, __entry->nr_to_read, __entry->lookahead_size
+	)
+);
+
+TRACE_EVENT(page_cache_ra_order,
+	TP_PROTO(struct inode *inode, pgoff_t index, struct file_ra_state *ra),
+
+	TP_ARGS(inode, index, ra),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, i_ino)
+		__field(dev_t, s_dev)
+		__field(pgoff_t, index)
+		__field(unsigned int, order)
+		__field(unsigned int, size)
+		__field(unsigned int, async_size)
+		__field(unsigned int, ra_pages)
+	),
+
+	TP_fast_assign(
+		__entry->i_ino = inode->i_ino;
+		__entry->s_dev = inode->i_sb->s_dev;
+		__entry->index = index;
+		__entry->order = ra->order;
+		__entry->size = ra->size;
+		__entry->async_size = ra->async_size;
+		__entry->ra_pages = ra->ra_pages;
+	),
+
+	TP_printk(
+		"dev=%d:%d ino=%lx index=%lu order=%u size=%u async_size=%u ra_pages=%u",
+		MAJOR(__entry->s_dev), MINOR(__entry->s_dev), __entry->i_ino,
+		__entry->index, __entry->order, __entry->size,
+		__entry->async_size, __entry->ra_pages
+	)
+);
+
+DECLARE_EVENT_CLASS(page_cache_ra_op,
+	TP_PROTO(struct inode *inode, pgoff_t index, struct file_ra_state *ra,
+		 unsigned long req_count),
+
+	TP_ARGS(inode, index, ra, req_count),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, i_ino)
+		__field(dev_t, s_dev)
+		__field(pgoff_t, index)
+		__field(unsigned int, order)
+		__field(unsigned int, size)
+		__field(unsigned int, async_size)
+		__field(unsigned int, ra_pages)
+		__field(unsigned int, mmap_miss)
+		__field(loff_t, prev_pos)
+		__field(unsigned long, req_count)
+	),
+
+	TP_fast_assign(
+		__entry->i_ino = inode->i_ino;
+		__entry->s_dev = inode->i_sb->s_dev;
+		__entry->index = index;
+		__entry->order = ra->order;
+		__entry->size = ra->size;
+		__entry->async_size = ra->async_size;
+		__entry->ra_pages = ra->ra_pages;
+		__entry->mmap_miss = ra->mmap_miss;
+		__entry->prev_pos = ra->prev_pos;
+		__entry->req_count = req_count;
+	),
+
+	TP_printk(
+		"dev=%d:%d ino=%lx index=%lu req_count=%lu order=%u size=%u async_size=%u ra_pages=%u mmap_miss=%u prev_pos=%lld",
+		MAJOR(__entry->s_dev), MINOR(__entry->s_dev), __entry->i_ino,
+		__entry->index, __entry->req_count, __entry->order,
+		__entry->size, __entry->async_size, __entry->ra_pages,
+		__entry->mmap_miss, __entry->prev_pos
+	)
+);
+
+DEFINE_EVENT(page_cache_ra_op, page_cache_sync_ra,
+	TP_PROTO(struct inode *inode, pgoff_t index, struct file_ra_state *ra,
+		 unsigned long req_count),
+	TP_ARGS(inode, index, ra, req_count)
+);
+
+DEFINE_EVENT(page_cache_ra_op, page_cache_async_ra,
+	TP_PROTO(struct inode *inode, pgoff_t index, struct file_ra_state *ra,
+		 unsigned long req_count),
+	TP_ARGS(inode, index, ra, req_count)
+);
+
+#endif /* _TRACE_FILEMAP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/readahead.c b/mm/readahead.c
index 406756d34309..210395fe1044 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -129,6 +129,9 @@
 #include <linux/fadvise.h>
 #include <linux/sched/mm.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/readahead.h>
+
 #include "internal.h"
 
 /*
@@ -314,6 +317,7 @@ static void do_page_cache_ra(struct readahead_control *ractl,
 	loff_t isize = i_size_read(inode);
 	pgoff_t end_index;	/* The last page we want to read */
 
+	trace_do_page_cache_ra(inode, index, nr_to_read, lookahead_size);
 	if (isize == 0)
 		return;
 
@@ -470,6 +474,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	gfp_t gfp = readahead_gfp_mask(mapping);
 	unsigned int new_order = ra->order;
 
+	trace_page_cache_ra_order(mapping->host, start, ra);
 	if (!mapping_large_folio_support(mapping)) {
 		ra->order = 0;
 		goto fallback;
@@ -554,6 +559,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
 	unsigned long max_pages, contig_count;
 	pgoff_t prev_index, miss;
 
+	trace_page_cache_sync_ra(ractl->mapping->host, index, ra, req_count);
 	/*
 	 * Even if readahead is disabled, issue this request as readahead
 	 * as we'll need it to satisfy the requested range. The forced
@@ -638,6 +644,7 @@ void page_cache_async_ra(struct readahead_control *ractl,
 	if (folio_test_writeback(folio))
 		return;
 
+	trace_page_cache_async_ra(ractl->mapping->host, index, ra, req_count);
 	folio_clear_readahead(folio);
 
 	if (blk_cgroup_congested())
-- 
2.51.0


