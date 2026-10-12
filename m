Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 867B6CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 08:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BAEB6B0099; Mon, 12 Oct 2026 04:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36F16B00A0; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5FE36B00A2; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 90F716B009D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0AC81C09A3
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:24:17 +0000 (UTC)
X-FDA: 85313286954.22.D23C8E1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id A15E2C0005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:24:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h6gjn1W+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5SkmMt+b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nEffw800;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="lzZ7p/zC";
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791793454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vi+bzvsD8E4CJNzOzEeUuEWE3GljGIIRGGXMdCc2Rjw=;
	b=rt8TEde7qcOy71gBu1ddj+ogd++Iy3LNEnck6KOkBlBRC0YA/2w/kwAuo7h60kI4m4ARnB
	isSqKa8rNr/vswu/mfOxfGWpmSd3hV4Gc8+sl1++iXMAYqSLhusEZuNHpRFjvnLWkj3oga
	d9PYsvnUtLVszAlk5HLTDGkLc+KBtjw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791793454;
	b=pRNldY/9pbTUyc3R/8xTNuWogdiu/SpNiCJ5KmzwowesCYmqnr9RSE82H0vJRzDIiPJRtA
	cpIIuLkPYZonpYLh4P3Ui7XDWAB6knAJbNq9t8Rx/0sO5BF/S7cYt7lIQrlxXyvNvHvV8u
	DYnUzvZ6tKgKXg+Sqa48keL4qV1Dn+Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h6gjn1W+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5SkmMt+b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nEffw800;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="lzZ7p/zC";
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8A5D41F45A;
	Mon, 12 Oct 2026 08:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791793453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vi+bzvsD8E4CJNzOzEeUuEWE3GljGIIRGGXMdCc2Rjw=;
	b=h6gjn1W+tzK6MQnnGa2c/NKUA+tn0Nol4a/1+1ALRaG/ocg4Q+zbQSlu++EIqeCEQR0SVf
	iHgrES4j9xrH2tozw2GKB/Ld3i/9phH8QrQkheyNI9z61Xlg8clzI0TYVCDg0/0fAx9p4X
	04Oq2rKHJSZhG3jObrYVyFgUxki1PKA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791793453;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vi+bzvsD8E4CJNzOzEeUuEWE3GljGIIRGGXMdCc2Rjw=;
	b=5SkmMt+bgAYS7QknQJNX0vhiLXUIHmhRVMEpzXyhcAZcRsbyYFa5gRGte20vs6/tsgjbWt
	kzLQSLoBLdSViBAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791793452; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vi+bzvsD8E4CJNzOzEeUuEWE3GljGIIRGGXMdCc2Rjw=;
	b=nEffw800uNSgigZqhvwVWqtqkwmsKqXlU31fGKOp5muBF1W53CEIpD3c1TG4Fz5NN9eS1K
	k+vg2c0mfrBnS8yxYJsWqDgWIeaykVTjqV6ZFQHldMeyalZpqu+XzyHeC52b5fBsxsxTKB
	z9AohqBo5Iu0360HaW0VdP2wzg8N13I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791793452;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vi+bzvsD8E4CJNzOzEeUuEWE3GljGIIRGGXMdCc2Rjw=;
	b=lzZ7p/zCddCJlhXvIBy1bfa5kLdDLZhYy96xX5qdwEDK3OLbowD/9ok0vNUDMryyeli+sr
	SfPH3WvjXTqEwrCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D8F91139B1;
	Mon, 12 Oct 2026 08:24:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dyj/LSuZzGocHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 08:24:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B04A1A140F; Mon, 12 Oct 2026 10:24:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 7/7] ext4: Defer inode reclaim if it has preallocations
Date: Mon, 12 Oct 2026 10:23:45 +0200
Message-ID: <20261012082356.3121725-14-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261009133253.20102-1-jack@suse.cz>
References: <20261009133253.20102-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1087; i=jack@suse.cz; h=from:subject; bh=doSl7XwBgbwlZmLOj7HhzP4E5NF4QH+660GbTlfCOcI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqzJkiIqTi8A+6iwev57YKHpZUBj+QsAzBktcnM fhmESSEi3yJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCasyZIgAKCRCcnaoHP2RA 2UbvCACmwzIBozO5WKYTaTXpO6JD5I3fOaNymfLjuJyLLcn+ebh4Z5Kz7UMrfCe5D6z626IhBKQ ov9yEysLY/Oi0rQiNJxjRO4kmzS+YtSlCQhRGccNgD7h4jya0ATD+efjtQFctvuIYNVbdF7PyPW tBYzXFKRA1yQ5U323We31ZH68mMegT1lzDF8CPtdVQ9U5KqLmlFh2eXQYU82WmyjSqXApa4Lpvq vjIhUXiwtE3I4JfnI8dZiXJlEYN8n4PZN5gE8dKxmKENXAkyn2zEEC4mIv8RJ+SsX536qXXe11A RVDPrMbJh2WrsbTYdu76WTpRaVumBM+RdG13pJBdlqosE3Q2
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A15E2C0005
X-Stat-Signature: 3cmew94dmfc59rrech98tinzp1gbofcu
X-HE-Tag: 1791793454-743715
X-HE-Meta: U2FsdGVkX19hxydCU8f8hCo17JZpg8zEPTSYd5IltaWAwgwi6g5MPFM9q2gc8/538BgxyIHsjWQEJKX/BXn5T3jHIT4AA8WUxc1nyZJPn1je8WIlURuBTBi0gKYUlMN40QC5dcaBVc6jeg6O5g83+I5tBE3/VyAEEvgeFYAvBNMYaM+E3tEDeiDeylylvB9vW0KU3t++ow0YD4SpOR6wxK047jTA29Bri0FhTjBJYaL5NXsImV6Fn/NpEWj5PMR4g223OAwZwecwmT9SOTt3LI+4x9Ln/KZd8BpG4Eny9xnFLfz7xD4mlGkawT45DIIcBrLw8LaMLqOHOYfnEvC3lT9K3FTvOcWHzsjBXuadmEjHPo/c0q78o2F++rKuj4/MSyBEAfs+Q7KogglG3lLEoTtyOfO9CDRhqor/NAXE4mn9HVV/+RSwoecuP0Bj86sqPpfU0AcKvlchuzsy88G1iLwGcq9udq8mkNUPOendPlA72PB6sKq2fDvk+qPy3UJFNQwv80FGnEorvjTafx+NpbWWFFKrj1uHukNq5/MxCxjqb/eOyhBSYIIDs9/Jtlr5LjLkZKy0EgWGtcUua3+rPfGSoRGrtfUQilW0+rdXCtakyDaaloncHb2E+9pytIuEnQqbU2c0Tfrb9jEpI6UeY/lz5tLD9bvQuknF3tLs0GZhvKnnz9kLdxieUNdALMEdTSmRU57Cc4IiUX20lhFgrX1XcMcz0g1IFEArvNvORbXX/+ZGl3UCXElJvw6YPKG6nJybikmU2jasdYB+FY3WllVnWxZYiJ0sVW3qAqjW5MVyEQgOZFkQxHPJ0N5XKbT7uhT1z0OOMU/f22lU9TlVDETldUYSuXKx9Sj6yOWTNqyoojZdYjaBlzNJNMaon+tpVexwjRVEMzmdu5ZvVCxTyezF/7tgLAoJrBQC8wPhjI33OLRr9zyZ64WOjE+bE3+dpeNFVh1YLnU0CkolvLV
 l3tsjmc9
 WUgerg7AezvHRxHnbF1VmDc0fcnogSZw9GtajN9vjWbLXhUq0FQhUMPXd6YoKX6V/C0Sn+XDqZlHskUxb7xURWn7kq/BEq6wZC5rhNX75pv5+3fd1/EbActwl9RWFEFFrE+7SECKh+uHYaRAXrT3+qAJaTer9CeXTfHpcA6vOBJjbAr8+XrQq/Ngu9JMH2G5xjNNgzDld4MXKFDrTKH/nqm9fxGsoe6Z8m7HdlmONtwI/OZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we have to free preallocations during inode eviction, we need to
load block bitmaps and run transaction to modify them. This takes time
and also requires GFP_NOFAIL allocations. Mark inodes with preallocated
blocks as needing offloading of inode reclaim to a workqueue so that we
don't block reclaim for long and potentially deadlock MM subsystem.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 06171a11db12..4891f252105e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3115,6 +3115,13 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	if (ac->ac_prefetch_nr)
 		ext4_mb_prefetch_fini(sb, ac->ac_prefetch_grp, ac->ac_prefetch_nr);
 
+	/*
+	 * Freeing preallocations requires loading bitmaps and running
+	 * transactions. Defer inode reclaim to a workqueue.
+	 */
+	if (!RB_EMPTY_ROOT(&EXT4_I(ac->ac_inode)->i_prealloc_node))
+		mark_inode_reclaim_deferred(ac->ac_inode);
+
 	return err;
 }
 
-- 
2.51.0


