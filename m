Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6650C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 15:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC1296B0183; Wed, 29 Jul 2026 11:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C732E6B0186; Wed, 29 Jul 2026 11:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88296B0187; Wed, 29 Jul 2026 11:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0596B0183
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:05:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90FBC1206EB
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:05:20 +0000 (UTC)
X-FDA: 85042137600.11.D983433
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id E7B36140009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:05:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TsYYT5Ux;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xpVwuT6Hev1WjQlh3dFEN4IM8UxH5igy66lsCYZfjDk=;
	b=Wgh4MTiIEV/GBxwVKSkDw2MGmHL8uH3VKO8AnG0bwmEkhsQC1AVCwFcJwYRNxraKO8bPch
	azLNqMn71O5yElyw+0wM1TAWfnMZSdxrdG0998IPupuwVrcNphQKtQsI7J2OsEGK3Z5EK1
	45Dcp9lb7e1SygipslGFawEdm41pcoA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TsYYT5Ux;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337518;
	b=fx5tVnocLNFpYxjAtIpPkgj8eIf2WmxJ+maDuO5dwVLEDM7m0m3jNMESiFc9rOBHtNzWAd
	CYfJSRWav6Og2Gy7ZY7hklp149L/H7SX5+DSJ4b7I6uvO8Co1rKBdO6rpAqDBPWVqLPiFJ
	397lqcLyoi/SmmMj2XndnVbab7nojJg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xpVwuT6Hev1WjQlh3dFEN4IM8UxH5igy66lsCYZfjDk=; b=TsYYT5UxfFOVD0AK6tj0Em2/CK
	GkXbE5tsFlQLvVWpTPyxYWZ53zOKFGNy/RzWZz+F/FKIElb6H2XKcgDSh7NT1yEpBvTR43bLwKq6M
	7PDf9tEg0QfCW85pUPYAyB7US5FyhQjgOXw/qPHM5bZhT/y65d0St/3CVc66wtWvA479Lht1I7USq
	cZ2S05Q1fD6Zpj5g2hfiyuY2IQozk871nyl7sz3U+To4lgpLm+nRSWtUtlJAPyqdQtcNHXt4ZZDIl
	3XH1IyImsqNkwSZvu1OjCvCUak/A1MoFkH2qDfuMXvZ/QNBn3W5+kRoKBpiBW9jwi4PYbct3g4Y3w
	NThsYNSg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp5qM-00000008KbO-3XwE;
	Wed, 29 Jul 2026 15:05:14 +0000
Date: Wed, 29 Jul 2026 16:05:14 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v7 06/13] hugetlb: Use the has_hwpoisoned flag
Message-ID: <amoWqtYhXm9_Bxhf@casper.infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-7-willy@infradead.org>
 <amlQYkGgLmxmwX9_@gourry-fedora-PF4VCD3F>
 <amlrjtaFSEQLYbEO@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amlrjtaFSEQLYbEO@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E7B36140009
X-Stat-Signature: k7us6wfhe9gwz3q15tprsbpimq6rrg59
X-HE-Tag: 1785337517-562405
X-HE-Meta: U2FsdGVkX19OJnaapVchxXpxYzqt5Mf8rr0tggLeWTByKVj8hGAxHincpx4LsrAPJhJqL0HHM1CHRGxY0yDoJmrnjB1EgBVaPXs5Y/8nl2jIYmCnBOcENanMblmsBvjgQRa6DphU42bBQ9O7/JqGUedWtjEqdac29nyfkG4pFEs+zx06Craiym1ZW5OyBlWjDmwf5+/VVHz9C4tzdJIZVO4JeY1LlStYdgUP6KLaORbCmVJ4jyPGVAG/3lMMv/kLvFZc8CYZGiQ/HjyXnK6rRXlynId9V/4eSw7gK2u899+jF3PiBO+C6lrH5Tu+vokTqOGGFvsiFqmMg9Snt3LFmxvRSdX6HHwSRVzMP7E2FSh0r8v6DdIvFJK+Tq2O46NJ2xABP37S+wUaIl6ucp1hIZPu2Lskkg1VqP4Wta0JOP9QfR6XRa8JBO1G6pqZV6O3yG56bRS3SeFRBQL7VWw6aqvSWC5be13Ky3sWZute5YKqDSgGsa53TJQRc4SFQp/iX+A4auGzgCx5mbkbCjgbm7UCECOnRmdynlN0l8GaXUc2KMAO0IchJpOS3V5OeNOHKJYThvYzJDbXnNNlBfBISSiG+C1Zlv7P1M0+goFlnCcjT8Xew4PQeoSL3q30GVWq73ep+281GQnO+BwFtjyh5tzT+3ZnmefFeeZj8BwlOMCU3YD47/YC4fN7qMa2ff56ECUBcCDytCzHwdaJ3K7HZQrujjoUUOSAblzWCV1fzCRrUjPDs91Ni4NhTBNIX2ONiwSD8+FfYp1wwIo6tllRskavEvU+enr9uQDyJCNHGXhaLvEntRtej9gs/MQQpTUxrEGtXBjLv07b/u37AcAyTga1Po4YwtEbTR8opezy6mpowQeutuY8FLID/Qci6d5QGfyZLtByz3+MMV3Ffv5FHdn+ENJ0lsrLsH5PVt17dCmxWtIVwFOuX5QTrFzr8zb+MhPawpYgzUeijcGlSJ2
 J9+Rb13R
 YmXyZFncqDrjsWV5Go4o+AdeXPcuGV4QJkSio5aXMyze1IR2mNuGglCCWvAojDr3CMxW8yFluyTh6EV1RcfnYFDnZK2dRUJe7g02YHdWjKQyUX7q2Clei4XpxsdfUhXl6g/tLmTH74TuiFuNdIguSPmXCKoACMPdQ7x+3RlZ++ngSVTz6Jk9IWVqU9Aw+8SV/UgRgXf0pZueABxYw8JdjpOzhKeOOTNhxiPmdXZ/K0LJuhoAd54oSJ8LyoYOG33nYt4NVAiCg/zFOx6EIIlao53QKhRvr5tXW+tLJYGDUlfkEEeiPlfF0bxPJviMnhoeOErsgPFIRpCjMSnoGvexrXPgCXsxudMLv2IXhxw7QmJIMWXHYVzRKoNSu2DXv6EOJgND3crHhIVHL+h2L41ihRDw+CLcVwiORNUIQ9RweGep4ldD1MY1ODA8JEmWKBa3T+JNIry5LTqHnTNs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 03:55:10AM +0100, Matthew Wilcox wrote:
> > > @@ -2725,13 +2748,19 @@ int unpoison_memory(unsigned long pfn)
> > >  
> > >  	ghp = get_hwpoison_page(p, MF_UNPOISON);
> > >  	if (!ghp) {
> > > +		spin_lock_irq(&hugetlb_lock);
> > >  		if (folio_test_hugetlb(folio)) {
> > >  			huge = true;
> > >  			count = folio_free_raw_hwp(folio, false);
> > > -			if (count == 0)
> > > +			if (count == 0) {
> > > +				spin_unlock_irq(&hugetlb_lock);
> > >  				goto unlock_mutex;
> > > +			}
> > > +			ret = hugetlb_clear_poison(folio);
> > > +		} else {
> > > +			ret = TestClearPageHWPoison(p) ? 0 : -EBUSY;
> > >  		}
> > > -		ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
> > > +		spin_unlock_irq(&hugetlb_lock);
> > 
> > Adding new synchronization here without noting why - it's not
> > immediately clear what this synchronizes.
> > 
> > Is this just fixing an unrelated bug / should it be a separate patch?
> 
> This prevents a hugetlb folio (which in this arm we don't have a
> reference on) from being freed.  I think it ended up in this patch
> because Sashiko pointed out the race during review of this patch.
> It could probably go in its own patch 

OK, split out into its own patch.  The 0day bot chewed on it a bit and
came up with a config that enabled MEMORY_FAILURE and disabled HUGETLB
which showed a missing hugetlb_lock symbol.  Here's the new patch:

commit 9df49152f5de
Author: Matthew Wilcox (Oracle) <willy@infradead.org>
Date:   Wed Jul 29 08:41:50 2026 -0400

    memory-failure: Prevent hugetlb freeing during unpoisoning
    
    If we fail to get a reference on the hugetlb folio, then it might be
    freed as we operate on it.  Prevent the freeing and the attendant races
    around manipulation of the raw_hwp list by holding the hugetlb_lock,
    which is also held by the hugetlb code when freeing hugetlb folios.
    
    Fixes: ac5fcde0a96a ("mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage")
    Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2abaf99321e9..50eab2c23299 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -110,6 +110,17 @@ extern struct resv_map *resv_map_alloc(void);
 void resv_map_release(struct kref *ref);
 
 extern spinlock_t hugetlb_lock;
+
+static inline void hugetlb_lock_irq(void)
+{
+	spin_lock_irq(&hugetlb_lock);
+}
+
+static inline void hugetlb_unlock_irq(void)
+{
+	spin_unlock_irq(&hugetlb_lock);
+}
+
 extern int hugetlb_max_hstate __read_mostly;
 #define for_each_hstate(h) \
 	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
@@ -279,6 +290,14 @@ unsigned int arch_hugetlb_cma_order(void);
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
+static inline void hugetlb_lock_irq(void)
+{
+}
+
+static inline void hugetlb_unlock_irq(void)
+{
+}
+
 static inline void hugetlb_dup_vma_private(struct vm_area_struct *vma)
 {
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 944e6e1d4971..1dd0e7b99bb1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2725,13 +2725,17 @@ int unpoison_memory(unsigned long pfn)
 
 	ghp = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ghp) {
+		hugetlb_lock_irq();
 		if (folio_test_hugetlb(folio)) {
 			huge = true;
 			count = folio_free_raw_hwp(folio, false);
-			if (count == 0)
+			if (count == 0) {
+				hugetlb_unlock_irq();
 				goto unlock_mutex;
+			}
 		}
 		ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
+		hugetlb_unlock_irq();
 	} else if (ghp < 0) {
 		if (ghp == -EHWPOISON) {
 			ret = put_page_back_buddy(p) ? 0 : -EBUSY;

