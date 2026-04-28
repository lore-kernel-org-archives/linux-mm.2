Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39430FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 11:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A590F6B008C; Tue, 28 Apr 2026 07:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A31486B0092; Tue, 28 Apr 2026 07:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D5C6B0093; Tue, 28 Apr 2026 07:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 877D76B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:31:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 428A314059A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:31:17 +0000 (UTC)
X-FDA: 84707748594.23.CB9783E
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id C9658C0015
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:31:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HPftHpxL;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777375875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qH/WqjqHdF4QWd0fPGDq25R88RjqC3sslC7AHulH6HA=;
	b=zdAHDerfGB8eDRlMnlcttXPSX60y1y6UCCjwaZdTTnpXHf3UmOeBdEPaJkkEVv9sZaxilc
	Owbk+/5AwkdPdrpWq0wLISA7zP/VLPOUmTK1pcjYaDEHoqo85vPPIrlQFYzyGZZaxqCxMM
	fbgBlR6KIX3GZnvNljJ5I8V+Be6z/gY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HPftHpxL;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777375875; a=rsa-sha256;
	cv=none;
	b=hdHgP9l4Rfom7UlCWk4ioZYEDEXQHNH/OCobopwoQPN2HcVhYsDQuQ/0wQXl7axV+eKXnn
	e8CtX9sqytDjiQnIlp9YmhVqS0eX/yhU/LdIyorjrg9vwgv6abSmm9kr8aS17AhZvET5AS
	VGdh8V+3o3hisE5YcpnzKZeUYHc2CLM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777375871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qH/WqjqHdF4QWd0fPGDq25R88RjqC3sslC7AHulH6HA=;
	b=HPftHpxL/Y4gPHOWy5kMQ4IpbMPDXMqd+GI3aFkKwB24OtY60ar681/C8KdGxJ4j94IWYS
	UXOyYXEhefeSNQICXx1BOxbtQ9dUOiaYS8vitO6IQeQkLdjNutC3u7ISewK9AfZsqCFgCq
	7kvsY31A8Yo21kgcUEUbShKFr/5KQQ4=
From: Lance Yang <lance.yang@linux.dev>
To: osalvador@suse.de,
	enderaoelyther@gmail.com
Cc: akpm@linux-foundation.org,
	muchun.song@linux.dev,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2] mm/hugetlb: fix subpool accounting after cgroup charge failure
Date: Tue, 28 Apr 2026 19:30:59 +0800
Message-Id: <20260428113059.79001-1-lance.yang@linux.dev>
In-Reply-To: <afB49BIqmLL2RKHM@localhost.localdomain>
References: <afB49BIqmLL2RKHM@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C9658C0015
X-Stat-Signature: 44jeuihwxjiu61m5pr91kw5gtkijnt1u
X-HE-Tag: 1777375873-827357
X-HE-Meta: U2FsdGVkX1+BSnTWhSkKIzX71/2L78QihXlECYGrdZpaWeEswpB8TDTrPW873jTtg444o2Z4F7vzOAQTutUlhlLlO92viyxDBugaRqVj7iCm5T0lvKmOeVUPEMZ5jjY3g8TqKM62Gg/EtuaFhikq9SoV4Ir/fOr0d8vij+RwpZ4fGRoJ32J0iU6eNvW5p9JmLlnxhxgXOjD7GD4qD2pH1Yf3B7dFZ+TXejvzL1KZlVWUL728XhnNzcYxXF+mkcrfVGIizXEJUl9HYDs/HzQBPCLGV/33IPqHrn/pFcsex6M2dlGCsn0Qg8ybbmi3pTynWpsOqgVDceHovkjkcHhVvkI5guPH4bRLaiJvWCM5eQEj2vvzmtdJt5xTsUaedEpngYvHxoTZkBpnqtQN9ITtibVjGbhU7IaNdDVL0EfdRXaz92yLCX28iC9O3M6UNnSYvqplPiuhETNw1eSgieKk1bq3Hidh9tNIxeayhVHenZlFRr6bF2A9sk5Bptslt1NdsLwMHLIQmqG2krwQ3jd5fu/gRUqeUb/PhDnVaEfMRtQP1Qfs1hZUkysfXk/yUqbZiupGnfSvP3cHg3iYO+wfLJwFttoUHl7n1W+cKv84qAUjPsGTS3x5mn8dCcm97pvltbVLJWz1nBT+kHb4iDn1LqbN2VJKfg8Di64jmuuBWwazTvDZkGbW/EmUUE3EWxBfs8rVGs8gPEtm4OPUaMtfy4zq/6Rqc5uU1EPOyyZ7dOyW07z+MFHQp/amDKRCgM7TvBia3vZyQUTDNfKco/EamVN6hWGc2QBpP2K0uhvJlfdKaXfn/UEsxJE8pXeueHC1Mr0rXwcwYzAAHGjdcK4Xd0Yaxu/Hy3I6RgcpMdk+cS08Wa6PeEBZBdZUK9dv62mUjwd17ZNcjmcHwb8yMQMmz07g5vmG8auxzKfAW47/E3ES+s4GvIyc7AS1BfTFS6qK/L/v6U3pQwh6BsROX2N
 Y/YjARq2
 rp6Woz0IqiDuwlDK+A4mo39lyKGYvS8POsFRfzeXByBzv0g6B2g8vPORvKhpaDgq2WEyjuKIlA36pvDU5LHFJlaTVikVtfKzq4Zys984LQmVl6xJ1xiTvEZWWHUY+cPDrUSMDKGq0BaY8lPcN8bsfWqKqqOp/pYJatAtYipC0wC8euQQtYE9ddhQgZPLSgeDAPCqNtNPB1ytbV/2TCM/N+qLqGDLCYrLKXyxfctZFpaR7TeQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Apr 28, 2026 at 11:08:04AM +0200, Oscar Salvador wrote:
>On Tue, Apr 28, 2026 at 11:07:13AM +0800, Zhao Li wrote:
>> alloc_hugetlb_folio() calls hugepage_subpool_get_pages() when map_chg
>> is set.  For subpools with max_hpages, that increments used_hpages.
>> If the later hugetlb cgroup charge fails, the unwind must undo that
>> charge even when gbl_chg > 0.
>
>I found that last sentence misleading, because we do not really care
>about hugetlb cgroup charge/uncharge (besides that being of the reasons
>we end up on error path) but rather the fact that we fiddle with
>subpool->used_hpages and we need to undo that when we rollback.
>
>> hugepage_subpool_put_pages() can also restore rsv_hpages if concurrent
>> frees move used_hpages below min_hpages between the get and put.  When
>> that happens on the gbl_chg > 0 path, restore the matching global
>> reservation as well.
>
>Well, that does not quite explain the problem I think, at least not clear enough?
>So the problem at hand (IIUC) is that
>
>1) if we took a global reservation
>2) and concurrent hugepage_subpool_put_pages operations made
>   used_hpages be below min_hpages, and so subpool's reservation
>   was incremented, but we need to increment the global one as well
>   otherwise the next time we pull a page from the spool,
>   global resv_huge_pages will be inbalanced
>
>
>> Skip the gbl_chg > 0 put when max_hpages is unset.  For a min_size-only
>> subpool, get_pages() did not change subpool state and put_pages() would
>> create a false reservation.
>> 
>> Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
>> ---
>> Changes in v2:
>> - Handle rsv_hpages restoration when racing frees cross min_hpages.
>> - Skip gbl_chg > 0 put_pages() when max_hpages is unset.
>> 
>>  mm/hugetlb.c | 21 ++++++++++++++++-----
>>  1 file changed, 16 insertions(+), 5 deletions(-)
>> 
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index f24bf49be047e..4065d66fdcb5c 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -3026,12 +3026,23 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>>  						    h_cg);
>>  out_subpool_put:
>>  	/*
>> -	 * put page to subpool iff the quota of subpool's rsv_hpages is used
>> -	 * during hugepage_subpool_get_pages.
>> +	 * map_chg means hugepage_subpool_get_pages() succeeded above.
>> +	 * If max_hpages accounting was touched, undo it.  If racing frees
>> +	 * moved the subpool below min_hpages, the put path may restore a
>> +	 * subpool reservation.  Restore the matching global reservation too.
>
>I would split the comment in two parts and place them within the block
>they belong, otherwise it sounds confusing.
>And maybe elaborate a little bit more.
>
>Subpools, reservations and hugetlb make a very head-spinning situation, so let
>us make our life easier.

Yep, the comment is confusing to me as well ...

+	if (map_chg) {
+		if (!gbl_chg) {
+			gbl_reserve = hugepage_subpool_put_pages(spool, 1);
+			hugetlb_acct_memory(h, -gbl_reserve);
+		} else if (spool && spool->max_hpages != -1) {
+			gbl_reserve = hugepage_subpool_put_pages(spool, 1);
+			if (!gbl_reserve) {
+				spin_lock_irq(&hugetlb_lock);
+				h->resv_huge_pages++;
+				spin_unlock_irq(&hugetlb_lock);
+			}
+		}
 	}

IIUC, there are three cases:

1) !gbl_chg

hugepage_subpool_get_pages() consumed one reservation from
spool->rsv_hpages.  So the error path needs to call
hugepage_subpool_put_pages() and then drop the matching global
reservation with hugetlb_acct_memory().

2) gbl_chg > 0 && spool->max_hpages != -1

hugepage_subpool_get_pages() did not consume spool->rsv_hpages, but it
did increment spool->used_hpages after the max_hpages check passed.  So
the error path still needs to call hugepage_subpool_put_pages() to undo
that.

If hugepage_subpool_put_pages() returns 0 here, it restored one
reservation in spool->rsv_hpages, so we also need to increment
h->resv_huge_pages.

3) gbl_chg > 0 && spool->max_hpages == -1

hugepage_subpool_get_pages() did not change spool->rsv_hpages or
spool->used_hpages, so the error path should not call
hugepage_subpool_put_pages(), otherwise it could create a false
reservation in spool->rsv_hpages.

Hopefully I didn't miss anything :)
Lance

