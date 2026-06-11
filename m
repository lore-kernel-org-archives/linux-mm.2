Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8826CD98D5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C0A16B00A9; Thu, 11 Jun 2026 13:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EB986B00A6; Thu, 11 Jun 2026 13:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89276B00A0; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FFD46B00A4
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 354C8C2576
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:29 +0000 (UTC)
X-FDA: 84868280658.06.071F8EB
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 97F9780004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WxiXoVHj;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781198067;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZHJrCjRIjmtPr++aWYgFPkpaIkTjbAk/NLmMP37eM0=;
	b=N+gegeOSNsJN6fJdmpWicrV5ePxVfrfrnFfPeo6bWfgmH3BPjBQ5wRUD05g6+393+w4cJ+
	UruxVer00a/eiaIE5J6AX1XbJdjxU+Zes8ynglaCwdTuL0azzLwNLRAD301KV93vaXqbZD
	0fA1hyjUMp2MKkLlgLEMb6ZZVZkFzo0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WxiXoVHj;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781198067;
	b=MG47wjo12wi1B2T9sG14a7pCnZsUielVi2uCXWo9j0lSoM3syprHjaxxR9gZzeU58EcD0u
	47HDsELNN7peC2952PI4hLT0IKkQEa4JssFQ1COfUQKWUcTo+Urs2urXwldONSb9iViY0V
	Ik824UiYspOPHtQu+KMRA7yZ2GPSnjs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MZHJrCjRIjmtPr++aWYgFPkpaIkTjbAk/NLmMP37eM0=; b=WxiXoVHjysrq3RItCug93soCxb
	2VjyRH4Qp49fsKcViwGccmZl34fpTnir+NHJy9DjCFsnLZalH4lLKkioEAgMHTvdcECnGwfAbnFsg
	H/L6bHS1c3IDjOoJ5tW6Q6vyamZR9OZXIEO614M6TubVj021ELooqaTYQpaTBld3JQCt79djRJmAt
	FMiSOCmyRVPc9l/7z9ZqmwHptUBmpTHNmbSoiaR8Q6N5VXn1pjxXGWhbhCgS8BxWq4Tbm/bCH4tim
	gW/wyvcfq2TVjKVwDkvSpIWaB2VP+P2PYyjMKG2eWbuRdwHsBCJIBgnh0UDveEbmiyswSc3EDZShC
	xve+CO+Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wXiz4-000000070nA-2Lf1;
	Thu, 11 Jun 2026 17:14:26 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/9] make seq_file_cache statically allocated
Date: Thu, 11 Jun 2026 18:14:22 +0100
Message-ID: <20260611171425.1671254-8-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
References: <20260611171309.GN2636677@ZenIV>
 <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wkgm4n71qz9zxnbz79r6tfmtbpbhu1qq
X-Rspamd-Queue-Id: 97F9780004
X-HE-Tag: 1781198067-909710
X-HE-Meta: U2FsdGVkX19Y3QSTbNHg1ZgekygLUo7nv6XVxFQF2Xm5pUT2Iso8YpuhJqjtkL2VS2hR/C+9E0WyeQAuGWOQ+xrm0HHPrK2/wgiQQxXVH5MY+WyU2XsSEltX5PZBuGKtURRtx1n4bGZhrjg9u/sZQTCXIGwEXVzjZuG9UEFfawhgorUSsvPj3wo9u/G93cC4Jg+8tt/EPck4Goau6j2Nv37l0KW8BsyQ31oFRmvGXoKdXIy7vHfZwrRqp0uoiHS54n6db7AgnN7vUTvlTBeVGiZIqPWxMP7OtRUzC51eaAt9z5i+u442j1rSq478SsXzytH8NBCTo1VOw7yEdJiKaNPb1M/1wutTcM6p0Qu7smu3l8gSr1zLO0YDyfgN8hNZblcbRFxQhOMXfaSSRRUm2A/2kSpNT9eKuR4Y5uU9GlE26pgQLwUkKgR0L93cLJ60DstR2Mbc7RkjD0kkQgRBIC7wgEUk4YU0S7ns+tcxEOMFZbDVukz4C/2+mf8/XZj7Q+/INkqeCiA6mTIcgs0oDYwZ89TpZUOTjgAb4el15ZwQZIoIwyxRiz/yMGyd6R8hTuNL/UtM8bZJ9tW5DuwJZE9m03ki/OlsFdcTu1TC/GZug1H55GNHzCb2Ph9Y8x0P6SaiWjje8BjmbNMe6ilMWvT0T52UUFiRzVjXZGLcAUKiEuaWTqcYfMw0Bi/rf2Ound+GcYijHz8kr322/9gIZNhvWvcyCZnYxqJ23vpwTlMqjwoBKbKHW3EJj7CnpdH6A1nFF4XBaB3h7khcJriBzP2dONO3txb/5wzMN1V65WvDaWPb4yF35PCwf1m9FAuUUtxafhH3vSi7MzS1n/9b8uk3kG2eYciXtvYCc82czzUQVSKf7pV3USc+wO6wrTBIPbktpZKJv49tzb1Y19dBIzrdQ6RUyyl79C0X9yaHI6MLo6qGlWAVi/RG8bOD5pOXTK0zMapgtoTYu/LK/Rv
 7hWYMYKO
 wxbtlNhHO9UDVLt+w9Zi7hTcSxu+Pnl9UVZErlBqtqDx0/yEmrRCDOIoZf/ddAOnbT5jC3qCUH6W8emQ20nQOyyZA7sGAnqdTcDQexKkxenO4J3QHjnjSQTNuN05+ZCHh/euUzZD21ooeoh+J5q5gFLWLqG4wCTzhwDJfl64OP6nDGG4j5TPkAN2AETFVw3YIU5WRnFRmoG7+9tiYJeiSb0nzULlAzM5hCVL7iD9gtQJF657/5Jub8imXRnsYXy+OklIdK3jeWmd2lv720K48XB0DsPm5I9Lsb97fexfipxeuoimu4ValaMvRuPJSiJ6FzKme5EDmjA30UhR4Ydcy8OA6DjejeUj2Gfa9+TV5DQc+ZnHYI7NKGOWA/ACel6N0YiPBnKXxTKxcce0FBE14kWCLnjKXupwrtIVahlYQIlWybuMBIW22H1XE5Iax5V+FjEm2ScC6mnS0IvLIR/81Wfdan+ITs8fQIJOU8ZIqoqyToY0reBKoEhiuDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/seq_file.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 4745db2a34d1..7cb40ae83f9b 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -20,11 +20,13 @@
 #include <linux/printk.h>
 #include <linux/string_helpers.h>
 #include <linux/uio.h>
+#include <linux/slab-static.h>
 
 #include <linux/uaccess.h>
 #include <asm/page.h>
 
-static struct kmem_cache *seq_file_cache __ro_after_init;
+static struct kmem_cache_opaque __seq_file_cache;
+#define seq_file_cache to_kmem_cache(&__seq_file_cache)
 
 static void seq_set_overflow(struct seq_file *m)
 {
@@ -1140,5 +1142,5 @@ EXPORT_SYMBOL(seq_hlist_next_percpu);
 
 void __init seq_file_init(void)
 {
-	seq_file_cache = KMEM_CACHE(seq_file, SLAB_ACCOUNT|SLAB_PANIC);
+	KMEM_CACHE_SETUP(seq_file_cache, seq_file, SLAB_ACCOUNT|SLAB_PANIC);
 }
-- 
2.47.3


