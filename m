Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9807CC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 14:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A8B6B008C; Fri, 28 Aug 2026 10:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BAEC6B0095; Fri, 28 Aug 2026 10:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7696B0096; Fri, 28 Aug 2026 10:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 605656B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:41:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2756403F5
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:41:16 +0000 (UTC)
X-FDA: 85150940952.18.45FAA4F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id D53B3A0004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:41:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=panAWlyH;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787928074;
	b=8LOky3XF5mgovsi/eljoX4J9aPItqacB1WHzpZ9Dr1c9+GnnavTAPH6nikzq8j18mdd01h
	jEboxoc6PUEjtacLCcZFXdMjdr/r0ojNd77JVbCuJbuIq9eXUlRv5qnyH1aV63YfRcWr2W
	d7hxC3t5pmU585og3EW0aT6OP8hF9ak=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=panAWlyH;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787928074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMVNde2wkTvg21HA6gMMmOc6O33QVmC43CxfG7wt05E=;
	b=kxH90T+AxlgfjdleDOxkOXflVQCPw77q2EglCghhxmqwh3a1y61tPHRe5NVuk6xcO1g5bO
	mgIj9GVaxMm6/kfjhEWCRUWrVbyaxdrTQ6Lep6WqJx6Gvim65DF6JQAh/BSVtZh3enehFR
	WJkr9U2XtrVY1BJIMRtQO1Z6uxsSqhI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dMVNde2wkTvg21HA6gMMmOc6O33QVmC43CxfG7wt05E=; b=panAWlyHZ294r8CVUs1Mm0l75I
	Fqt6DYaJvW4Q2ZEsuTzJV+rrIZ/kMojDsSLozPad5UdoK1OegnDlPFX6SavtvreoybTU4bYeYvAzH
	DYJJ5pzY3rY3zoX9Q6zxpJI8tj6rB+OlMdAKOTts4anffWRGrqrjTCaUF+R6Kg52sZBl9qSKoALPR
	8t6sTZhlF8WOnLwzCXUmtqKz3ZtvfwgtYOQJx9aKgPMZ/50LvwONfzYIvWzmxC2ohjzZSCDfPkw8w
	ipxGVHtu3VTsMJV0czrZ188J1wwRIMXKLGIDYQQIxhkZ927L1IaULYL+JNI1M2QOnK6aU7/E3I2zL
	NwjsEWmw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzxl4-0000000Eq6F-0ksv;
	Fri, 28 Aug 2026 14:40:42 +0000
Date: Fri, 28 Aug 2026 15:40:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Kiryl Shutsemau <kas@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Christoph Lameter <cl@gentwo.org>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	JP Kobryn <jp.kobryn@linux.dev>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <ryncsn@gmail.com>, Lance Yang <lance.yang@linux.dev>,
	Leonardo Bras <leobras.c@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>,
	Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 04/25] mm/fbatch: lru bit set, no extra ref, while folio
 on per-cpu fbatch
Message-ID: <apGd6T84Zs1RgTVg@casper.infradead.org>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
 <e0887417-85a7-453e-e733-561dc11db08f@google.com>
 <apAaWsWPV9QEeVwn@thinkstation>
 <3b8d9cc4-d6f9-6bd6-f774-34cfca9c48c9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b8d9cc4-d6f9-6bd6-f774-34cfca9c48c9@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D53B3A0004
X-Stat-Signature: c4a9he7hwihw8rthfhs7jm9jgg8stkgk
X-HE-Tag: 1787928074-813528
X-HE-Meta: U2FsdGVkX19xl7bBpRr1egkdrvdnTbdZVI5ZmOdW/BOscZC7U5aTccsHjqFIoao3oiKr0kj/vv72MIyJcV53SfSxH5MKRavWO66dVFZ1Dw3DZ7a3w53XJIOVHKOLM04oB/mAfJF4LLiXIGBxTY+XDqDRt9eSvGBOFWs/S1e++TfBLVa5CiRXorcpvpwkXFxIw3q7gNcIn3vrD1xzzMdH6F0ZU0TvEl4fjTqkM2aIV0l+025DW4dLTcL+iXTOFtwmC4stOTMbdapaj7KOhH9ISABFvx4D1PnmX2X93bqqBR1/1a/pB6p9KqNjXRqJJBL0Vuh/1rlvYr+jcxrEA479eriy/BgikD/YDIEMubwgTXPg+u+8AMwIV3F7okb+CAD/KloPITqs5N+PnkY3gd78WjRdm69QEYJOKFtPe8YsCet5MJYy7CErEC28yR9VyiID8y4agryMD8+JTVrBcGZHhat6QmPAOi7rBPmacFYZVe5SzPHGfAHOoIf3K4M8grHPBfAgnlzrguQLecMUW9Oric0WVmiPWrSr5sPpHrexFSpQ2ZzP3UsxuPaOEaaaXogb/yKhWjvFotSdurBCj5s8php8hkTnbC14lGNWRHOUfbLvatNkXCtXCyeFXkbbC312rj9SFXG1jSm5QPr+InMo/+9ZYAwRLtR5MbHqtrR0SalzZHiuE3zJH1CD4IWcZxTHe5JkMbiQqlEp20g76BtZrMaR2cBpfHVgr6SmcuftYlzsBtv8xaobpK7K5OyqIiZmfsu7L3MKuvCY1ri1L66kKSM1mFDS1hS6IPFA84IyFZcsq2dyJmKJHSXG9i2anHoLIDtvHvtYY7wkZG/AagYdWRM9eApZkRtZFoYI5fCBAKE9RAYX0UUH+YEozfMvaYrwSr9wmmzagQTcTmCN1GdbLpSI+BgrClnv2itqEmn73lxiuL8plOgd6lHih2be+1xFRvYgz7tJug5K9/7lRQz
 bjK+lOxH
 2qzUE0S88cjLPLobQvBDaWRQyv/Vx7W5bZTeFVfKG6fmuWkH+nYyS2LwIvtNOUiQ3s7leIplFgkOOmMlOb6DmPVJzhv4dyJgMxdvICxfUEYpjCgRTLFmh1FaA2Fv9Q5Tb2FGvlrVOLmgwudF/UPNrR5N093k0MIUBUGJ6k+aaW39oYBT8XFdXQAan13TEqdqTc66A5DbzSovK68nJs2KWpM9IdEBt7lSFa/k47L/hka49yddkdvpYY5LkXVA7uoEmEsSrF6TlDTb4BIaM/cOaLMDfy+CFxnXSwc2Xi8iZ9WXkSDsuv8RRnyjaKY9w44sxP4TW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 01:04:34AM -0700, Hugh Dickins wrote:
> On Thu, 27 Aug 2026, Kiryl Shutsemau wrote:
> > On Mon, Aug 24, 2026 at 07:01:20AM -0700, Hugh Dickins wrote:
> > > Treat folios on a per-cpu fbatch as if they were already on the lruvec:
> > > with PG_lru set, without holding an extra reference. This will enable
> > > the removal of most lru_add_drain() and lru_add_drain_all() calls soon.
> > > 
> > > Recognize such a folio by 0x02 set in the folio->lru.next pointer by
> > > folio_add_lru().
> > 
> > Hm. pfmemalloc (__GFP_MEMALLOC) thingy already claims the bit. Is it
> > safe because such memory is never on LRU?
> > 
> > Are pfmemalloc and PG_lru mutually exclusive?
> > 
> > Do we want to be explicit about this? Like, folio/page_is_pfmemalloc()
> > shouldn't return true for PG_lru folios/pages or something.
> 
> Gosh, thanks so much for pointing that out: I was completely ignorant
> of the the pfmemalloc use, and a bit (bit 1!) shocked to learn of it
> (why wouldn't they just reuse a pageflag, I wonder? but doesn't matter).

The idea is that it is used temporarily to communicate from the
page allocator to the caller "This only succeeded because of
PF_MEMALLOC".  Making it a page flag would require all callers be
aware of it -- most simply do not care.  PF_MEMALLOC was set on
their behalf and there is nothing they can usefully do with this
information.

So we want to communicate it in a way that allows the unaware caller to
discard the information, and I chose bit 1 of page->lru.next.  We
used to use page->index == -1UL (which was also naturally overwritten by
the unaware caller), but we needed to have it be part of PP_SIGNATURE
and that needed to be not part of page->index ...

Commit dc8cf7550a70 if you want to read more about it.

We do use a page flag in slab; we check the pfmalloc bit and move it
into a page flag (SL_pfmemalloc).  But we don't use it for folios.

While there is a folio_is_pfmemalloc(), I think that was a mistake
and it should now be deleted.  It hasn't been used since slab was
converted away from folios last November.

> Anyway, as you've rightly guessed, it's not a problem at all: these
> mm/folio.c and mm/mlock.c per-cpu fbatches are entirely for folios;
> and if any pfmemalloced page ever get used for a folio (dunno) and
> put on an fbatch for LRU, then of course its use of lru.next is
> immediately overwritten (first by what this patch writes in lru_next,
> then later by the lru.next pointer for whatever LRU it goes on to -
> just as before this patch).
> 
> If you were to tell me that some subsystem uses PG_lru for some
> other purpose, then I would have to get more worried; but we can
> be fairly sure that's not so, since mm/compaction.c for one relies
> on konwing it's free to  play with PG_lru folios.
> 
> Whether a folio is ever allocated with __GFP_MEMALLOC, I'm not
> certain (haven't looked), but there is no need to exclude that:
> it simply would not retain that page_is_pfmemalloc() info across
> folio_add_lru().

That's the correct thinking.

How about this patch?


diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23..fcefffb52d3e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3122,36 +3122,25 @@ static inline void *folio_address(const struct folio *folio)
 	return page_address(&folio->page);
 }
 
-/*
- * Return true only if the page has been allocated with
- * ALLOC_NO_WATERMARKS and the low watermark was not
- * met implying that the system is under some pressure.
+/**
+ * page_is_pfmemalloc - Page allocation should have failed
+ * @page: The just-allocated page
+ *
+ * Usually the page allocator keeps some memory in reserve.  If
+ * __GFP_MEMALLOC is used, the page allocator can dip into those
+ * reserves.  The caller can find out if the allocation came from
+ * the reservers by calling this function.
+ *
+ * If the caller does not care, it can simply use the page as
+ * normal.  The field that the information is stored in is usually
+ * overwritten by most uses of a page.  Nobody should call this for
+ * a page they did not allocate as it can easily have false positives.
  */
 static inline bool page_is_pfmemalloc(const struct page *page)
 {
-	/*
-	 * lru.next has bit 1 set if the page is allocated from the
-	 * pfmemalloc reserves.  Callers may simply overwrite it if
-	 * they do not need to preserve that information.
-	 */
 	return (uintptr_t)page->lru.next & BIT(1);
 }
 
-/*
- * Return true only if the folio has been allocated with
- * ALLOC_NO_WATERMARKS and the low watermark was not
- * met implying that the system is under some pressure.
- */
-static inline bool folio_is_pfmemalloc(const struct folio *folio)
-{
-	/*
-	 * lru.next has bit 1 set if the page is allocated from the
-	 * pfmemalloc reserves.  Callers may simply overwrite it if
-	 * they do not need to preserve that information.
-	 */
-	return (uintptr_t)folio->lru.next & BIT(1);
-}
-
 /*
  * Only to be called by the page allocator on a freshly allocated
  * page.
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 09cb1e18bc16..9bcfc4213b91 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -85,6 +85,7 @@ struct page {
 	 * WARNING: bit 0 of the first word is used for PageTail(). That
 	 * means the other users of this union MUST NOT use the bit to
 	 * avoid collision and false-positive PageTail().
+	 * Bit 1 of the first word is used by page_is_pfmemalloc()
 	 */
 	union {
 		struct {	/* Page cache and anonymous pages */



