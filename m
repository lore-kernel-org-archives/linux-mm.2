Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA3F606F2CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=YzD0QhId
Received: by kanga.kvack.org (Postfix)
	id 538306B05DA; Fri, 13 Nov 2026 13:57:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508DC6B05DB; Fri, 13 Nov 2026 13:57:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1286B05DC; Fri, 13 Nov 2026 13:57:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 194746B05DA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4FF791201BB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:18 +0000 (UTC)
X-FDA: 85431003756.21.E5AAAB5
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7EF6340007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=YzD0QhId
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596236;
	b=XA7XTYu09LSBTBmqEJprPdKkIE/ldnu0ueULsXYq7YOpY+4vpS1eoITCw/gZDnc8Ui3tRT
	Mz2kFSEXzCZrIt1EHYLwe5So/ZuDs6IjDx0RTkJq+GwYoycXgxUjsNLKfTcF0AwKd4Mi30
	BTTmUGUUUODbG+NJ9r2eDXQtJH8w0E8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=YzD0QhId;
	spf=none (imf27.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.41) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcWwNEHkYlUPLQ8a1nsTOUqqcSFaeduCjApaxkKfvSQ=;
	b=xRUcFnNj73kI0BQskoyofxrU9SdOE3oKs3Cu/1ubqO2xKEqfYEvAFHUdZWYo2hu9vmA2qf
	cimzKH+/8P/eRQOeT+5YD/TzDXSfJeyIf8zMngBcWWI+wEVhlHjinLTTt/l1V1sMomFejf
	gtcWbUyiTa15fREdMNXCttn/6wNaFEE=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-492fcbfaa87so709034f8f.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1794596235; x=1795201035; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fcWwNEHkYlUPLQ8a1nsTOUqqcSFaeduCjApaxkKfvSQ=;
        b=YzD0QhId261LIPtuU4Uz/UnnVDA8q/Rk4J1GjWb2j2pb6HXZm3kHl+5oC5WAbnzk7n
         HI1RQUc7byEVu+ODERb0ULIvGWl+kneNktfWpM9Aj2v5/iPAXrwvJCwZ265/Y01q/BSN
         csg7K0+p4IhSrWZlHupywYXKDv2kANhwRwCpFy48vOs2UtHRuz3EHtbVgFh1VpWsufFg
         kdrDfPNTFbeRxjM4cAqKEzQG5Dly3INLelUTpfEkc0IFv1x2r+6gAD6CC5GVyU0egBpe
         Jm2pc1IzgBUzFesdzfOjO0vKlfWYjmnrHZBkHMua7MM09J6rjr/c66gGBk1ayezu4bZs
         lB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794596235; x=1795201035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fcWwNEHkYlUPLQ8a1nsTOUqqcSFaeduCjApaxkKfvSQ=;
        b=r5JmcA8/ixSHvqTz8WqXSmJtjT1ch/ZO7HtjRd46W/ibokRP9B4t4agVWY7fBh3su+
         ZU7l0A6q3KZ8OTC2YE4UJFftcr8+vyN7Ld9ZOUT+LaXWwZ9Qc++DgjaJwZ+oOe6o3GZ3
         l0j5sX5eXq4JlzAuBGx6tqBM+SwDCdkCqfJxNRekVg8k9bIbbeW0OilAYduVYcbkff/F
         bFZjFuoYa8Voq1YKLKPHNZNEdMGvsdCcvwxfCLwaO8mPGZeqOP9cS0qaw6i4xEUzoKX9
         +r80Ca7y6Sv15h88Y4Gxp5AqsOyaNY5kzUpg+05YXBM2fjsB88NBzwjVooRebWLxzsmh
         IXOg==
X-Forwarded-Encrypted: i=1; AL+hErFY8ahxoMMnBE3EHo3GNgzUEOYsAmDYxeCQ4/PNE21sp1NQLpNT0qaW8Ua7zTl2dLmYj4GC4AKG8Q==@kvack.org
X-Gm-Message-State: APuU4Z/ujr3iivsrc7KwZ6yt87O2u9MdZMr/qAUgMHI0+vnXHqCXkXw5
	Kj8r9Iwc/MS1sVqmSp826OsA5pJKfo5xz1UYEXGuT5mj2HDEoWLwHkIhBEGnmPQfO1U=
X-Gm-Gg: AYBFou0TxAoZn9t2YZf+AhyUYdJ+v8Q3TIBflk3ftBAlKC0otEd1m5eiHmISZl8Ilvz
	JuG8OJ+s5h3gS9X4rCxgl51yBrCIbD5d3W+V0+G6XHh1ptnZ3iTuPO1CQiacNHdw/5RErk13e+r
	HO6sPwwYJs83w3ibmOK0eyQN2zXBOH20P4iTIAQvW24Pt1V2mEKA1nYO8IiBoq39MOJ8WtgtY7Y
	f8vordWQ14iRjgf1Cp5z6LnWSATN0jiuvd6DNOJozFCGcPaiE3gtwjYvCbGVOSDCwz5UrfiDKrC
	UaZn3TukNh/rssjDfLoIiH8KnR2xvTnAlQGKigrgFwtjFlNogt5bVCvQngO0rR8IGN1PJmWosFR
	6CkQY+zBjppd1BpDb7TMKNAaiP6nGuv6jjCZokJAgPNbBQuKJ+f+n80bbt5dUA3TdCLkoEbmUwd
	+ehBMliZtSOMFpFSPjs+05d8ikgDJKVh6JjCZHSdvY7CVPrsi0wPI9KHUKaBsdw8TW7qt59ljuC
	f598rbNn00yVfk1x9EkH6puLJl91hEwDtKQWYncvNZiFR/+xdV7PD9F6hYyfVI2kBoIfqNV+Yl2
	NyFA1EULwEPcwUhOsY/y49Fqoz1YBg==
X-Received: by 2002:a05:6000:41c6:b0:48d:f95e:6e8 with SMTP id ffacd0b85a97d-49c6fc9e5cbmr7640880f8f.1.1794596235203;
        Fri, 13 Nov 2026 10:57:15 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:ec8::179:1b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f5972a7sm6417589f8f.21.2026.11.13.10.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 10:57:14 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <ckan@cloudflare.com>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v3 06/10] mm/page_owner: Read stack traces with stack_depot_fetch_into()
Date: Fri, 13 Nov 2026 18:56:58 +0000
Message-ID: <20261113185702.1332171-7-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113185702.1332171-1-matt@readmodwrite.com>
References: <20261113185702.1332171-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zuyejchbpoj6enebidfxdropmjhxrhdi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7EF6340007
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794596236-314834
X-HE-Meta: U2FsdGVkX1+GMvwjJKyolpdBKfswLcv+STaM8PoWoYj7MSR518zhgLLjdE6tQ9RfaMrCkgC8DITPwEnWf/Zir4SqPh8vAAiukWuTd2PcOLxqOyGm6TAfezMrOyNRsy/W1/2fqJV+rRsT8wvIcaVrx114iPQtIx7pH4TAgU6/HiZaDvnoTFfcCTRnNFxgHP58KOVaL9af0KI3/S7TXRPIyhP6RRcIYkRaFuHeU4usE6qWY0v9xycK9BhuMiKMqC96xNrV2dbVsgZsY0Wwq9ToGG0Fy+/bMFBNl11sJqSL+EX77NMy5wVMXK9Q2LZVbqTa7fyPOZPI0UdvbXezduSCKEu2aXxAx5YxlKI+pImnQWitYIJg62MqHcKfyvNgXE6VEsibkCM2C7ts8i0V2JfsY2BU7h5stu36XeFaDZ+PgF57nH1cop6H96bFa0ZmVtQkDz+vmuwvQRdWTGdGn0PjrUvBB2Qdz8bQert/ixKtbFMwMgTueJBJR0L5VhclebA6kqUm3iNkT1EQgVCUJLwgUhbJZkd6MpukAMLv/M4czdSG6+JP4NIzby5xS4vqpyMjvsvj/seMUhyOoA6qzxJYP1+8/ZXwNNV+2QC3Fsfj2Y45X50C5uXHQtQ5Wzh7XSVXPP1CrLL2acVZY+eUSqBdFD8/m+zAC2lmPyb2MuCbWcv2ClhUPyI9KwGLGDWstnVcSDQ9zg1ce61qFn109F12bd68R5IE2NNQuWieMuyHGi1EHiP5CvLuBzldShqnO+iipOBHCcf1NqcEb0iEdIrO8+9o0oFYhpEwXnSmCnB2BUCPlxjBJyjigaltOipr8Ms4vC71NAZx/xfV00QMM2pJ8V4Jf5QnmvCjJa93VNc+dMMNZi1vargM1+tELXwX/QYmP9RoN53HlRY3i/xNqlBUDLOzc+BouU5MeaGkQhMZ32G32aIJcFBq+Y+qlnnipG8REttJONuqHGsTOM+3G+L
 /2VQB/rq
 uRaf1Ru1RQUCcjDqNL2Q19r1/m26Eh0b6Sg7CvwR875cdm54POx3euzUKtblKUZ2mnWs3me/KAeaSSTwT3AkvXbSZu54gkTN9R9H0dJFqowYu2C7B8ByUYYXpt0HaGpW5pufBVVFK8CNaKkDU3qA6ZDx0U9cWEaccuXcgbsgbvTflDzsfkS742ZY6/CVggBGGyuXrNUt5lZQbSoqhZZbq40YY5XCy0RkL1Js6C1ne2sb6IrDvUKRknWR8/q1mpAO3GV1qN/XLHhKMMF5p5MsWdddQE+kqFuhIdeIb7HdkRwnRMCClG+JSba9lQx/8qG3ZBrGlGW8WxUzgWHlWWrdqpv9fxvP56dbR1ZgLlvf8Re9HCvHRy9w6J4NJL0PBEDuKzLWz7S0Ki5RfDl1Ita1o/oEAhfzGMGRV/6q8KsoIuptXDb8JoBm9+loYJW8PrIFPgoS1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Matt Fleming <mfleming@cloudflare.com>

stack_print() reads stack_record->entries directly. A later patch
stores compressed frames inside struct stack_record, so rather than
decompressing those frames let's use stack_depot_fetch_into().

Copy the trace with stack_depot_fetch_into() into a stack-local buffer
with PAGE_OWNER_STACK_DEPTH elements, which is the maximum number of
frames page_owner saves.

Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 mm/page_owner.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index cfc31c92d765..16429e70e00d 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -1068,8 +1068,8 @@ static int stack_print(struct seq_file *m, void *v)
 {
 	int i, nr_base_pages;
 	struct stack *stack = v;
-	unsigned long *entries;
-	unsigned long nr_entries;
+	unsigned long entries[PAGE_OWNER_STACK_DEPTH];
+	unsigned int nr_entries;
 	struct stack_record *stack_record = stack->stack_record;
 	struct stack_print_ctx *ctx = m->private;
 
@@ -1083,8 +1083,8 @@ static int stack_print(struct seq_file *m, void *v)
 		return 0;
 
 	if (ctx->flags & STACK_PRINT_FLAG_STACK) {
-		nr_entries = stack_record->size;
-		entries = stack_record->entries;
+		nr_entries = stack_depot_fetch_into(stack_record->handle.handle,
+						    entries, ARRAY_SIZE(entries));
 		for (i = 0; i < nr_entries; i++)
 			seq_printf(m, " %pS\n", (void *)entries[i]);
 	}
-- 
2.43.0


