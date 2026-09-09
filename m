Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B713C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2659D6B0092; Wed,  9 Sep 2026 06:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DF16B0095; Wed,  9 Sep 2026 06:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153826B00A6; Wed,  9 Sep 2026 06:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5F426B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:03:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10DCB160172
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:03:40 +0000 (UTC)
X-FDA: 85193787000.06.8064206
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5CF191C0008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:03:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h4fk2VSr;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948218;
	b=PQF+nJkkgKYJfnL1vT8gSsCfrXc+/rH14PktDLStPiG5zc+e1QviKNqcjo7M327yealF3Q
	qe+mb/d0ZJpV4oe+qeC75VLb4yDQ9mTvXmmFHT84T/oeHxjb/YV6znDhQ/SRyihsEfYC0G
	XdyoojJAQ2sV3ogyn/IccJPToB3iX/E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h4fk2VSr;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZLYBDT0mJ+F0yYdyxDNynq3EZCGij4ebq9WOsT9s4c=;
	b=iLKeSMYh+MsbhZIYkzDpzyOdlH3/RvuNp1nAjIpzhx5ENBfWsDKgBfqpgg1CNskuVZ9wck
	CXSFClKVwKh//ZKwVhPfCju481mReZrst4Ui3NY5RKoEg7tyJ+XQ+gqKkubcXzcgUnr4NR
	tPZO45FsclCeVYyvNZoek8dM4PIMf5Q=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-66cf1f9965dso4369469d50.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788948217; x=1789553017; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OZLYBDT0mJ+F0yYdyxDNynq3EZCGij4ebq9WOsT9s4c=;
        b=h4fk2VSrEfEgz4nNnEjh2Ana1ZBVP+2IlFnT/HU8DPZty1rQQptIz9TdjTSE24JoVJ
         U4Ou4Cn+qVak+XZzCWH2pg7WZ2V/iHwTfGUNwG8alHQ69SZwgTENucwT1OuAtzMI90y6
         k7oZnFMRGDcgW7csN/RMLQo9GR831T/RoQERetrlrt10hKFDktVdz5Inyn6PU0UgrvRM
         oDlCRGrdaf6XxKTHPUiU+iIIGQ+UlX7kakeadpJSL2XHhA5H2DZjClNgsBt4Gkamnfe4
         eZuLKvW9iWRN9IYpDu41sdHV+v+9ISjwq3ieiPsz8li9D+mShEQU89at46K4bOYcWSo9
         Mfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788948217; x=1789553017;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OZLYBDT0mJ+F0yYdyxDNynq3EZCGij4ebq9WOsT9s4c=;
        b=Yhfn8mUnl6mPyREb/gOWHAQLkA1uUFwJTOm9Vv2AwPO9Nb3lW2Pcad3TlSi9B8taWL
         tSBIrT4NDHnp+3+KHVXpoIaDfag2AHkhJH6o/VCYG/ev/98ef6kiTH9DRdguQ7yFKFY4
         fG+ia0kjJ3n8CDbM+MebvzhqTsHTT5nmuJ4z6NXC4pHnmX/R+gaQhDWU0bec+iiPc8mY
         gCxcsjdGBpu1mceku5F9N2Y8p9vRuEwXaZ3upXyfkEGgiupSJljTcn/f14ZrfdQl2yxd
         HVTs1X/sAh6NM73yWd03vDKCDjq/fohELEvdpttuNQSXQSDwdPm+TPWsrCkB9uFchffy
         1pwg==
X-Forwarded-Encrypted: i=1; AKwUvBysycJELFPZj9P3Iz1cgVAUUxWq6Lpw5Zqi0/jgFERJsZLSQk1Cj3o1LNjOHc9UhlNFWqxE+hka1g==@kvack.org
X-Gm-Message-State: AFuF++mXRHxvjD4Lms8Euf5jhx7ztt2mNlDjDsHYXkLOPIhu0rnC/ZEV
	9BjOT7Oeh7JFOPcW4op89a9f7OXuiBCWO2XwB+bkpADAtQorfgwBtL89FHO4a5SABw==
X-Gm-Gg: AYBFou0r+CHUFj2L/kqgxUAQwIy8zwTko8T0BKjLpHVgdDIsE3tEnpYt2Ei4zA7FuJ2
	omqyxOYThKvJa5P9uLzVFwkRuaO2MVVNr91xqG/Myo1t0IbVjImr5WFP03VzMpF/J9GHWDoU4In
	hxcnyKj6sOFB0L7Je/JKR0Z7szdp32xpEPtuuqStg4vEDn1IFzvosAsKAQ3dkL5jKRvRF//L1tM
	5g6A1wdYTOgrKQIgQcl2Zl4CmmPdcb2FY6CqlCK8iyNn5/eETf0kpAVumLFMBj1/5yyTs2tW/zF
	idomKrB8m41fYUvfJqH6gdLwBxp7I/R39mu+5RT5H/rHnOi4n2iDM078hogGEmiXXzydaNkCTSw
	WDnoCc0UrizfOEqhWijhoQ7URBaZJHGAaHHS1+m5Kkb01rYFsajwT8rqR2FwnB0AI2JzDDNgu7T
	mDUM+qu3HqxqgvNMcLrIuwT1FTAMdTS5fnSdONgU6StQOXzgTd/S5cU+43SyACHPTA9W8SUWE77
	CTt1I3Y91zXmRw/hQbxdeQoJm4qhzXA8I76SN+51MlMAZJ0JJtG8hR0BrWfZq1t/X+tWw==
X-Received: by 2002:a05:690e:4384:b0:66f:8b35:dedd with SMTP id 956f58d0204a3-66fb58f2dd2mr7477525d50.6.1788948216887;
        Wed, 09 Sep 2026 03:03:36 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb48ee9easm11934983d50.8.2026.09.09.03.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:03:35 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:03:30 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 11/26] mm/fbatch: remove migration's PAGE_WAS_MLOCKED
 lru_add_drain()
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <e13a7f3e-0629-5602-603e-af01624a2887@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5CF191C0008
X-Stat-Signature: pbydfcbj8cttadykpf3jkjyyuzrq7kkj
X-HE-Tag: 1788948218-400313
X-HE-Meta: U2FsdGVkX1/aDWLNp0vMnxj5nfKUihA9tU0bKbkIUaB2BSlYMxOqvcNiRqXXOucuYc2Nz573lZ5KdmJSj0O1IE1NwYm3vgWeP15lDi0YYfKZz96sWq/nNczWCJ2msVzUosNoF8R+hS9fV71A5d/KMMy0rYh9n9HHykCA67k4T9W+PEZpauZL0jrnYUEJHMtxCV4ThOHwSLI5xJ7CqhkNbetjIZUpBUfZWTtwnXLsVmyjq6cQJdj+9ohHW9lR5WfD+yHrVyUTPntotNomS5fLIgaax1FVHqjo3H3HUVNHXwGokV4rc60UncZ8n8BNAQSshWg3me/Y/vb5ZjLBZRgNKUYWXyxheAPo7FMDbkPhU/sQfouXPWlF2iiduF4TqEBvYCa/Rz6vJRSxSJ3YySNhe4AXrgmYqQpnuIbaUY5T7eL8VhVmcnMWRB2ni3WHkPHiVb738kO4z1mGakYMHa2K/CEySeaLsI3QkTMmwY4CFQXrav5lqo+c8B6Av10Bm+S1yTTwR1ZkffwZTOHeSh6xWPDBUhFz5NTMgMBa6i5s5hEhT5Y4c571EFDw3lKAd3NUrUjCn7TgUCXWoVLdOynEuCTN/0zo7SFGcD3HQmQsmmSVcmpdeKRz9pz4tJ4UBn8OUmkysTaVdgqNXVPs9D173iF0LqDlggDVk5SnCcy+lTZ+uoKjcalsj/+IbgkTGwPB+ecYyQhYVd9Rv6p/Xree1Srs2i7mR52RxcNadoqjQddPLPR1IcDLnnWgT2RBVXSEKt4gfW+SXLzP8pKPiJQWxn+DzSGsQhDQZAhnd+pYp0+8/v2K5SNXN7wfJcuLKjiR8X1/imOoUwHm4/qyH0lvMZqTNdFs9EMeGYlyyWdTtTjuBfSON2X6ertLjMQrwkszZ+zkI9UEwLQ2eS3w/wIrlyWgvT0PbvbeO2euvKXUuIpDIbtg2rvpta7Aav2E4GLFmawUNq2z7MuBDtuqA/Z
 fqbjNp2O
 AIj16hvHBpK/dZxCe8SWyAoRnHnSUKiAs4fBlnRqwhBMcpAW/luW+HembG5+im914ksQEJ0HoftBkEbKpy7YdNL9bzb/R8qn7vV2Z9mHfYnJaehSakDqVNRmkWPn0V5oNHgGbnnMoNgLz3HrB8eAEUhCP4jrO0IcnjtH3AAnKCirNt0SnNxEWr8+V6rHC+uyac54Hjk6Ywo89KqgC5vHKDTH/T30p86tTJlkhVAm73CH9i8abj0Tw7hr8L5P8mA4eaCRPXjpg7AGPfRpWb8QndtXiKYOhphihkERhBsEDpzojjTagHQIi5VyJTyQBm7Qo4P7TIxzlo2Lvc5JD+anrWwnH4WllxUCvQYwggTL9BlaNM9dOP9zNWWjfn/J8xbC0//CF+zfJe5YY7bYMs8gPT5rVzbvUVCi/6o5fFWU7qs7Y4ChKNxj99q6NJOEugKFrLrzB0kGOgR0Iu9QhUWwaIaMmuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A welcome side-effect of mm/mlock.c's mod_mlock_count() succeeding on
folios on the per-cpu lru_add fbatch, is that migrate_folio_move() no
longer has to lru_add_drain() before remove_migration_ptes() restores
a PAGE_WAS_MLOCKED mlock_count: so remove PAGE_WAS_MLOCKED altogether.

(Re the "We would like to do something similar for the old page, when
unsuccessful" comment above it: that may be easier now, but involve
some rearrangement: not researched, so just leave the comment as is.)

However: it was uncommon before, for isolate_migratepages_block() to
meet a folio on LRU, with suitable refcount, marked mlocked but not yet
unevictable: so that got missed when sysctl_compact_unevictable_allowed
should not allow it. But now it's a more common case, so check if the
folio will become unevictable, by using !folio_evictable() instead.

That is more expensive than testing mlocked and unevictable bits: but
it is consistent with the decision made once the fbatch gets drained,
and is_inaccessible further down depends on the right is_unevictable.
Optimize those checks better if they show a regression in practice.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/compaction.c | 2 +-
 mm/migrate.c    | 8 +-------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 9e045a90ba21..1290b9170cb2 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1113,7 +1113,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (!folio_test_lru(folio))
 			goto isolate_fail_put;
 
-		is_unevictable = folio_test_unevictable(folio);
+		is_unevictable = !folio_evictable(folio);
 
 		/* Compaction might skip unevictable pages but CMA takes them */
 		if (!(mode & ISOLATE_UNEVICTABLE) && is_unevictable)
diff --git a/mm/migrate.c b/mm/migrate.c
index 1939d6ed19c9..364015cbef33 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1147,8 +1147,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
  */
 enum {
 	FOLIO_WAS_MAPPED = BIT(0),
-	FOLIO_WAS_MLOCKED = BIT(1),
-	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
+	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED,
 };
 
 static void __migrate_folio_record(struct folio *dst,
@@ -1258,8 +1257,6 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		folio_lock(src);
 	}
 	locked = true;
-	if (folio_test_mlocked(src))
-		old_folio_state |= FOLIO_WAS_MLOCKED;
 
 	if (folio_test_writeback(src)) {
 		/*
@@ -1410,9 +1407,6 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 * isolated from the unevictable LRU: but this case is the easiest.
 	 */
 	folio_add_lru(dst);
-	if (old_folio_state & FOLIO_WAS_MLOCKED)
-		lru_add_drain();
-
 	if (old_folio_state & FOLIO_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
-- 
2.51.0


