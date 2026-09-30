Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69F89CA5FBA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 10:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE456B008A; Wed, 30 Sep 2026 06:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471796B0092; Wed, 30 Sep 2026 06:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361A16B0096; Wed, 30 Sep 2026 06:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0347B6B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:17:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5176C140712
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:17:50 +0000 (UTC)
X-FDA: 85270027500.11.604A1CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 946FE180008
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:17:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMeCpVFj;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790763468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3cgkYtIbNvYvCR/75csc07cJMiX3SGtqX5E3pPjB2I=;
	b=FpfntXASScpt5Om4qFYrpn4BtI6pvkwGrVNtVkZm3VdQ60zxZ2MpCwvmVRCnRuvSrg9/gf
	6KmYXRLi248Rb0W4A8xo7mhGqtAGENF5mvOfBdRO6wp332OK4+qysjVqXoJHD5j0hqYxoI
	mEM+oCy2LMdR+U1BWrm5MeNkWwUzrN0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMeCpVFj;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790763468;
	b=oPt0HJTOmFoma8c2HQAtZEyYZLSx7pd6mkhixV842/vnP5Ixpm3U1Y6mBHngknlVpw0SI9
	/qcCviXXx9gVtLudqdQRnehcqLfieaHyFgAv6E7pgWdrkFO2M8kMtatV+uZNmbUPC31TOv
	DjwDIxtoKk1jhz/Gc+jdXznYa6aPhQc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E71F60252;
	Wed, 30 Sep 2026 10:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE54B1F00893;
	Wed, 30 Sep 2026 10:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790763467;
	bh=W3cgkYtIbNvYvCR/75csc07cJMiX3SGtqX5E3pPjB2I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DMeCpVFj6xuNgEpmQg1zia+EB1nBbXPjHKzpR/UVERO+nuN4wz1pK6tE6NrS4O8Ih
	 JfifjGq3V22BCCMwlaKeT5qR8qcjcPTOBwAnG5gJd5pFFTo/PMNfDaAfHYakuPuik4
	 cvBCW8mWhdMYvczzkeV0FwJun2IT4KRtP/XVOmUiFPeyFOljLR9fgpZ3+VQHI2ERGd
	 Cmpfax8Osj15CK1XcutgwE3EyDcv8gYKbDh3g9e9bHJke6UY8A2G9s3yC8oN9r1UW8
	 2X3HGF6OkTpp6cpnM7iCyHu/jn8z1cy/cgOVy8KeZkW+VRrAe9kQyUT/f0K6fszUXE
	 nEYJfpVzXjxww==
Message-ID: <e14a2c04-66c2-49ef-b438-ccd3762686c0@kernel.org>
Date: Wed, 30 Sep 2026 12:17:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] mm: eliminate &folio->page references in mm/
To: Nilay Vaish <nilayvaish@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, Greg Thelen <gthelen@google.com>,
 Roman Gushchin <kfree@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260929215206.516490-1-nilayvaish@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zyjt88f433dmmaj1oz68icgd76eh6mk1
X-Rspamd-Queue-Id: 946FE180008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790763468-544763
X-HE-Meta: U2FsdGVkX1/F7D15O2KrQgmqtKDjmz1oIDcce7xk9pXfDQZ03sEQAFvaqHI+fuEHgoaOMMz4qZuec2WLEDcphy2uPy9cCwnhA1dXqTVBv/R96zOhIYQaTlyuCH+qZ9zSbfeQXXylxxYb5VvBRq19tuW/lnI9Iuq1Nw2hr4jW5lSMU2JE2b2SDtBNdZjqtLF1q3d0CoIYSuN62Kx6ZBi4wsGtkNao+0KxfHkIYjK/nXb3naZ3d/ARtprMrej7y33KZwmHdUiyTWv6fz67pq3SLBnu7S3HKasaNwttpaJGlsTjE2DqmQqW04pu/f37J1awIlEzmVEdL6eBh8+P/yLip2E+GoHVET6RRN/ArGRcLgIlyQqb1l33nbSwssbfuQ++w82Vqx/3oW4LUejDQ6R2aCfW2xYO2PnAx9ZGkl32fMkVMTT9ddcGZChIregK0k2ja9s4K6KG6YrpJI5u2vEEyBlRekGTnXY0W8e371HJe2zSKDB6Y8d6XFDR1gyg5mjErFAyWAe1WSmOYwKMzvkn0RJQcjMQxhSGpmvQhlwNPbsx+pR1gZ+v5sY2BRm77qopGf5FZADZbdPp5GAet+oBdM1YlDngqKTM/LzBP7EAuavl03VjEAZFtLlgwCmTs3xPQh4n8q2Qx0CruQ4BsiFhm2zED5UgCm+md9KjIBDGil1fj5jNfBa0f2K06U02mk2XYpTOF/ZsULfyvPUIsQsnVVHjAB4/1XMOZB79BLJTcDG+zE6ZuCS/GsLatrjpcjTD5yD5jsSO5bgKM3/VbKeBcxJQuENc/7LtM2OpUhsbvzHrDmNRoywrSeqr2BvEdBfrk5OF7ctbiLR1L2FHXcZf2EOY1Gi1Ta7+H+gTfpg4GgpoEyDh+0zYRPk1QsUXu3BF3SaTp3d/ymRUEfhy3YR1zMi+2LQjNT5/nkvpNEJAgRG/88RuQVb2sZe/z3Hp31v+bpvEMIvd5R9+xTz8neT
 ln5gw5kU
 4m4aKDtNCcBPZwr3DNGmA0nPLWXcsG2nP8noE+L/PkLJ88Rqhuhv7TxoQbpjgmAbUiAAydNEoSYo4tGxqaTO8UuZt+f0NGJxG15BxnjzpsXz9wxPbQTbUBNSzsHdU1q9MLqqNbh2N5o8viJfp3z81kYzbRSyPnN0WMwhKigTHYalzHEgBALyORjrhC9TpGrXDhKRM45OOo6wAKXMy12n8iSnUOfgU6k4E8m7srIsVAmQxCAfzqy+x+34QzaNAmpZ7bK4e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/26 23:51, Nilay Vaish wrote:
> As part of the memdescs effort to separate struct folio from struct page
> and allocate struct folio dynamically [1], struct folio will no longer
> embed a struct page member (folio->page), and the address of a struct
> folio will no longer equal the address of its head struct page in
> vmemmap.
> 
> This series eliminates all but one of the remaining &folio->page
> references across mm/*.c (25 files) by converting them to:

I recall that Willy mentioned at some point that when changing this we
actually have to think about what the right thing to do is. As &folio->page
can serve as a reminder that something needs a proper solution instead of a
mechanical change.

So while folio_page(folio, 0) is the mechanical change, a much more
often we'll have to ask us what the actual future-proof thing is.


For example:

diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f..b027c938d830 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -266,8 +266,8 @@ void putback_movable_pages(struct list_head *l)
 			continue;
 		}
 		list_del(&folio->lru);
-		if (unlikely(page_has_movable_ops(&folio->page))) {
-			putback_movable_ops_page(&folio->page);
+		if (unlikely(page_has_movable_ops(folio_page(folio, 0)))) {
+			putback_movable_ops_page(folio_page(folio, 0));
 		} else {
 			node_stat_mod_folio(folio, NR_ISOLATED_ANON +
 					folio_is_file_lru(folio), -folio_nr_pages(folio));

Is stupid. These things won't be folios in the future, so we actually *want to keep* using
&folio->page here as a reminder that this really must be reworked entirely differently.

Which makes this rather hard to review and makes me wonder whether core maintainers should
actually drive such a cleanup.

Unless Willy explicitly asked you to do that work, of course.

-- 
Cheers,

David

