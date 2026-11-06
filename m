Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D72606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cO8m0qaR
Received: by kanga.kvack.org (Postfix)
	id 722026B05B3; Fri,  6 Nov 2026 05:23:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9D96B05B4; Fri,  6 Nov 2026 05:23:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610086B05B5; Fri,  6 Nov 2026 05:23:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC8E6B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:23:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D2C201A0D77
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:23:38 +0000 (UTC)
X-FDA: 85404307716.12.9C33D85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E054320008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:23:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cO8m0qaR;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793960617;
	b=qZy9olDfetLbC8xw1O/rZP8KmTaf9wV7HLC2tVo3iCM2Xxj652H1o+9sWMK+bCT+VG+wdd
	kvQMGQYCje1+ALJmE0CtvXgN5abjNSeDxAvG45baSdjfHfv+1F9B6aUg6BKDDI2j8IoGW0
	j5B42NsFEZU5zdzaOno15DZzJH+xJVs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cO8m0qaR;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793960617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vy/VYMt/UXkWhWK9aY9NDoivw8LVPTQza9JKJFj36SI=;
	b=MMdCcbHveXNV9Cv1qeojJjH3Dn7OZm64eYDx15LwH4jcfzS3SY7FFRAy7DdJAfPS1HQ9o/
	YgLNpi4R6wrru4/nOgAXBBNrCyc+yGie8l8h9vAs/PHgEnH5E7M3/6PdDWdgmE1PEx/K1N
	fLN2YgGB1IEVxTje9DdZO8zTP515/tM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53AE0605F9;
	Fri,  6 Nov 2026 10:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E1A1F0089F;
	Fri,  6 Nov 2026 10:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793960616;
	bh=vy/VYMt/UXkWhWK9aY9NDoivw8LVPTQza9JKJFj36SI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cO8m0qaR8c74YiS1bp0K16yutbZC6ABon6p5mfjEST+g9WBS0loF/pQwR7rh3GttF
	 nsVQ413P/wD7/i1vlcMsT1Vm66pExVhdOw7VxX5nQNySm2aIHrDmyvlBk4wqfEZ7Yt
	 CwAqzcCLkWYMsDAOfZ2Z946zekVZGpGbeaUw9ruqSYRR20dRO5dlWzbntgOb4igmz7
	 5r6eHevEQ2khBsLPl+rc1jRVytiMM8G4p+QzO4BNKzUAHIKVqLJOZQwb49iKy2bAZb
	 /zw9N3nl9nwl7x3MVLZlG2iqP4SXFvtYvnqvn4SLfXzK8vZdpUn3SzBlJ7Drw0DkmU
	 tCQSkVk4s2bbg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 41300198003A;
	Fri,  6 Nov 2026 05:23:24 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 06 Nov 2026 05:23:31 -0500
X-ME-Sender: <xms:m6rtagV6DTxgYgMjJkpJJ3fe2Gk0dD7_17-xk6IjR9tc6lO66SF8FQ>
    <xme:m6rtauaSZvT20eM3fefx2fSCnk4vNOtiTOKmKKCCY9L6qlvOWDsZNbiTI8s9TmOc4
    uctRZ6O79_sK3jU96X1lze5YEMHRYQw7MsCUzUS52MkvsJ0CQ6LnZnf>
X-ME-Received: <xmr:m6rtaoFmaro46qwZY2gMR-FNRKY0Ex4ja7wtz_e6p0EkVEEkc5sg_DdMnzI>
X-ME-Proxy-Cause: dmFkZTFzY3ecYn7vuV24DC+I/lHsHFuDPtZYKjZHnqxEoYklqFmEQEwJqTWHDS0drFDzQj
    M8i1kXAUkC/HoF9Melp63kjZu+Ye/WAJoA+Or8wJFKINkR4JYLDV0m5AXg5+PhrkLWgu+S
    0Ia/eUbDJelbWzRjOkPu+fh6wn2DK0fsTRoVS9gdaP0AMh+IaU+2CmJfHbzpfg+cj22fko
    phv35FsrHJDkuHHBVG34BlfHnKbnUThOxZI0e8oKunIDBTg1XFqABAErX4TWs0BIwpn0MA
    /2DDZt3b+UiBBXDQ0/C4G30ZlmJcVnZE+o240+X/5QpTzX9Fgc/5O4t4KiKiGfhlCGkLtc
    aZu+DybrUbhcHn8ihVGbolZWbK7OXAn8yj5aIZH6/9QxlqyghZ1cwZt+Q7k+4+3pE3yr/Z
    S9mAUVwg+8xacpnw0hs7EdzIU2gVRr8oswPU2m8ZHnZN1um7NeMxNOcFC6YAq7ghuhSsKO
    x+DdMl4m5lneDLqRg+Zd6cwRMLGKUZLBhR7goF5cmEw/97Zz+fB4w37mUIYpN4Zo/b/wmA
    sIqocmBwlroIcQfSQ9bs2b3HIj0/YFXYnfUw6OBkWsdfFOZBXmNVQVPBbBde7HTGIH/3WV
    mRni2jLVpOd0kpPqs78f6ThEf2qOephUz5wkETJZeK3fYrjWxQdCTol/oCtQ
X-ME-Proxy: <xmx:m6rtaqSW1wAd8Iae0W_HKsh_IjtZNO7TzbRc-KmCZMrdsnX8HOa_Mw>
    <xmx:m6rtamhLWtQAWNYN27jCZjdZ5xH7Ga5m5TRL6darwOw_mdFZa-Ulwg>
    <xmx:m6rtavXk4hDEbdrz_oRsRVvmE99uPgLXSwoTXLwDDtCC2H6yp4lxVQ>
    <xmx:m6rtakM-Dv2ugzOcuHNa45x8DGEMB_W6rWCned3371Q5cVaCW0PIaA>
    <xmx:m6rtasbeFOyX1cAJEAG6_8am3xXvsdbRMks2Tpvkue5Zcs5uI3Y9GCZY>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 05:23:23 -0500 (EST)
Date: Fri, 6 Nov 2026 10:23:22 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, 
	Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Harry Yoo <harry@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Luis Chamberlain <mcgrof@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, kernel-team@meta.com
Subject: Re: [RFC PATCH v2 01/18] mm: free PG_rcu_free folios only after an
 RCU grace period
Message-ID: <au2lsbDkyWt-To0C@thinkstation>
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-2-kas@kernel.org>
 <ecad7b3c-7244-425a-9413-04d49f221057@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecad7b3c-7244-425a-9413-04d49f221057@kernel.org>
X-Stat-Signature: 9bgdmqujke6ym9od6ockkard1pm7zxy6
X-Rspamd-Queue-Id: E054320008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793960616-144919
X-HE-Meta: U2FsdGVkX1/jsmXfZNoS6047pFuvOwwtyO8Hapu7XRqP7PIdMAuLsMSphqAt3Ak7NubTPLWWeE3jjJ+BadhmK5vWXLJA1eDm2aSOqGtS8vNHdASUTabpulicfg1TxFNGrPlOrdy24VM+GAoxTsZ/Ey7DFuUeWTDg/Ibzt2C/WyGDuLvgzDu041ow2Pu9UTnhH2a87sXK1U2eHn+D0Uv9i7tgXclbdN69bNX02EanhwnOy+j9ui86HFA8jstnJ2jjlvfHr2mMqfj5EEqF+oAPwaRajkpB43KSHzCD0MqobH3clsVNHokzHHN5qOpqWj2iKdA/PGvKPB0gPkb8P4cfH2Ru5LCYV18pUoDlS4nefp0zFQ6UKvI2kUK3yp4hsb7HcZ0T5DLfef16OrKrxV3PciYqJxl2cN9as3YZ63ry0TOl56RsH7HueCMcF5/lTX2aa1MirWTwWm3z68nAlD1xomJZIBl0NE4l0cNS2TM6+0DT7FRfvB27NpGCTBIiuElWk6yfE4BdLgqLCOEQeTYsShk2G6UtU3jL4IlVo5v3fyjF/h2IIijjIfRgN+I0C6rvYf40LsRiMduvC80VyfkNABZ1vaTIlYQaJhl+bYqW7PaKph9KzG1OEXu9yS47dCGqvejGwhqWahIYd7cxUi8pq6EVaCA75J4L+8Y5alhgmM9HgKtD1dZDgr1By1vqwOeOr2ZmdYXir1CdzqKgDzpYmyA2CifZOF9JjUgtCVRF8ZylNab/7mLEDXCJyVxNQFms9CFzclqevDdpq45D+fSpyky2xL5CmShyJrQQchTr92k6zc7FfzkOsiDKyRixAMRKtQ+XNruS0mTdzXLVOdoRAsqfRA2vvWNMstJEvfAIfDsyzkIPlbgDb8S/zwgJ6kmRnDPxA7Q8pD7Dp/eGOVI9hAr7x7ZnZxsbLsaofF5HBUPmLz7tfpk2M444/CBmwTXnNCWwNFCsrhPhiO4olyH
 vbX11KFs
 bEvNLNSK/OQEWB8jaoqzCaaSSAIOc/Gd6apat8w+obz5NahUDHuN6QHZ3R8S3hkyVRSo16+aCpwtgguBc0ThU3OVYCY+jnv3HYj45OkDGBCcFZuTfulZiVdWS7zgsO9H0GvfirZ4vtWnb1PmsuQS1BP06S9F5xTW0Q3myDhMXpmOGaBuUGV8pxt3KnHufkA6viF4oadWFprCudSclRnFbg5NPeosUZxtBw2cYC7T9vOkk56BZOyf0EDAXhJ79ur+OtEQjD2PadxEkJKUAKl3xB4NVpxYLRdj/45GuqK7MzUoqsvdW4tGhw05/LCISaqfvfp/sxMKdPJqPZ7rqr1cJXgSI43u0apRj6bTuBYXYKdFbXd4dAb8YZmnondvbT9ULcr42nj4DRdMfZa688sp0x7/mpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 09:37:31PM +0100, David Hildenbrand (Arm) wrote:
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 604c58199acb..6e5341b0bf64 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -718,6 +718,21 @@ config PCP_BATCH_SCALE_MAX
> >  	  latency.  This option sets the upper limit of scale factor to limit
> >  	  the maximum latency.
> >  
> > +config PAGE_RCU_FREE
> 
> I think we really want to focus this only on folios (like the current code does).
> 
> FOLIO_RCU_FREE ?

Sure.

> > +	def_bool y
> > +	depends on 64BIT
> > +	depends on !PREEMPT_RT
> > +	help
> > +	  Reads from the page cache can copy from folios that are read
> > +	  again and again without taking a reference on them, so small
> > +	  reads of one file from many CPUs do not contend on the folio's
> > +	  reference count.  The cost is that memory freed from such
> > +	  folios becomes reusable only after an RCU grace period.
> 
> While that description is helpful, that's not really what this patch, or rather
> the basic infrastructure in page_alloc, does.
> 
> I'd suggest to have a dedicated FOLIO_RCU_FREE config and maybe another one
> (that selects/depends on) FOLIO_RCU_FREE that actually enables the pagecache use
> and documents the details.

I will make the help describe what this patch does.  The page cache is
the only user, and both symbols would be def_bool without a prompt, so
I would rather add the second one with a second user.

Does that work for you?

> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 1e5d68acf62a..25082949a4ca 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3743,6 +3743,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
> >  #endif
> >  				 (1L << PG_dirty) |
> >  				 (1L << PG_dropbehind) |
> > +				 __PG_RCU_FREE |
> 
> That looks a bit odd at first, as it's very different to the other once. But no
> easy way around assuming that the flag is not always around.
> 
> Maybe we should just have this be a const mask constructed somewhere using BIT()
> and __PG_RCU_FREE etc, instead of having this growing list in this user here.

Makes sense.  Something like the diff below, on top of this patch.
Introducing split_copy_flags would be a preparatory patch, and this one
would only add __PG_RCU_FREE to it.

> > @@ -1327,6 +1417,19 @@ static __always_inline bool __free_pages_prepare(struct page *page,
> >  
> >  	VM_BUG_ON_PAGE(PageTail(page), page);
> >  
> > +	/*
> > +	 * Not for a hwpoisoned order-0 page: it never reaches the allocator,
> > +	 * and page_handle_poison() takes a reference right after this free.
> > +	 */
> > +	if (unlikely(folio_test_rcu_free(folio)) &&
> > +	    !(PageHWPoison(page) && !order)) {
> > +		VM_WARN_ON_ONCE(fpi_flags & FPI_NOLOCK);
> > +		__folio_clear_rcu_free(folio);
> > +		count_vm_events(PGFREE_RCU, 1 << order);
> > +		rcu_free_defer(folio);
> > +		return false;
> > +	}
> I'm wondering whether we want to intercept on the folio freeing path instead?
> That would be __folio_put(), before we go into free_frozen_pages() used by other
> machinery that does not apply (slab etc).

Not all page cache folios are freed through __folio_put().  Reclaim
frees them with free_unref_folios() directly (shrink_folio_list(),
move_folios_to_lru()), and so do folios_put_refs() and the LRU batches.
__free_pages_prepare() is the one place they all pass.

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index a1e52a1f8a52..6d4e534c9ccc 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1185,6 +1185,18 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
 #define __PG_MLOCKED		0
 #endif
 
+#ifdef CONFIG_ARCH_USES_PG_ARCH_2
+#define __PG_ARCH_2		BIT(PG_arch_2)
+#else
+#define __PG_ARCH_2		0
+#endif
+
+#ifdef CONFIG_ARCH_USES_PG_ARCH_3
+#define __PG_ARCH_3		BIT(PG_arch_3)
+#else
+#define __PG_ARCH_3		0
+#endif
+
 /*
  * Flags checked when a page is freed.  Pages being freed should not have
  * these flags set.  If they are, there is a problem.
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 25082949a4ca..44a1aaa3f834 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3689,6 +3689,23 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 	const bool handle_hwpoison = folio_test_has_hwpoisoned(folio) && new_order;
 	long new_nr_pages = 1 << new_order;
 	long nr_pages = 1 << old_order;
+	const unsigned long split_copy_flags =
+		BIT(PG_referenced) |
+		BIT(PG_swapbacked) |
+		BIT(PG_swapcache) |
+		__PG_MLOCKED |
+		BIT(PG_uptodate) |
+		BIT(PG_active) |
+		BIT(PG_workingset) |
+		BIT(PG_locked) |
+		BIT(PG_unevictable) |
+		__PG_ARCH_2 |
+		__PG_ARCH_3 |
+		BIT(PG_dirty) |
+		BIT(PG_dropbehind) |
+		__PG_RCU_FREE |
+		LRU_GEN_MASK |
+		LRU_REFS_MASK;
 	long i;
 
 	folio_clear_has_hwpoisoned(folio);
@@ -3725,26 +3742,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
 		 */
 		new_folio->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
-		new_folio->flags.f |= (folio->flags.f &
-				((1L << PG_referenced) |
-				 (1L << PG_swapbacked) |
-				 (1L << PG_swapcache) |
-				 (1L << PG_mlocked) |
-				 (1L << PG_uptodate) |
-				 (1L << PG_active) |
-				 (1L << PG_workingset) |
-				 (1L << PG_locked) |
-				 (1L << PG_unevictable) |
-#ifdef CONFIG_ARCH_USES_PG_ARCH_2
-				 (1L << PG_arch_2) |
-#endif
-#ifdef CONFIG_ARCH_USES_PG_ARCH_3
-				 (1L << PG_arch_3) |
-#endif
-				 (1L << PG_dirty) |
-				 (1L << PG_dropbehind) |
-				 __PG_RCU_FREE |
-				 LRU_GEN_MASK | LRU_REFS_MASK));
+		new_folio->flags.f |= folio->flags.f & split_copy_flags;
 
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

