Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B58EECD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 12:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA8DE6B0005; Wed, 13 May 2026 08:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5AB66B008A; Wed, 13 May 2026 08:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D48D76B008C; Wed, 13 May 2026 08:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C48FA6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:18:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6AF6D140B0F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:18:16 +0000 (UTC)
X-FDA: 84762298992.18.5D79AD5
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9DAC81C0010
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:18:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778674694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=otznF++7oLAnzTyCS2FS5OAD+g1ido7CdQ3q9eQesp8=;
	b=PrRBvfWuOdCrz3eiDCYtMOfQ94joZYlrQXGJ9a/Y1eVEDzCEO1TxTuQeVD55f4HPAHbeni
	n7cPnz5BogoCqjin1Yqm+mja2h8Q1eKvwjfcsBorSruEaLlMEY0eRXimTIJT+nGfTDm/Z/
	PQWRqnEJodskVmj12Fofk7ypc0bQBTc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778674694; a=rsa-sha256;
	cv=none;
	b=lsSsqCAkWeHlQ8kxEkzgpKKgFyic5zYT/KJd8Dj3NQzRo7bhCa4YipQZeBa/pGdjfUiHv+
	NRVmDoK6KLweuLbDMJ5623ERAM1Rgy+yitzBtgNHyM2Q+sgwt1RaA7XOaEXN6ebA6hIe1O
	bbGWZLN31UdzJBDm4NMRUrhX0Of4N4A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c2dff70000001609-3c-6a046c0274bd
Date: Wed, 13 May 2026 21:18:05 +0900
From: Byungchul Park <byungchul@sk.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com
Subject: Re: [PATCH v4] mm: introduce a new page type for page pool in page
 type
Message-ID: <20260513121805.GA22430@system.software.com>
References: <20260224051347.19621-1-byungchul@sk.com>
 <982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTVxjHc+49PffS2ORYEA6aZVuXRYMKU/nwmKhxH0YOS0y2uU9b4mzk
	xpa1VVtgYGJWhERhUlDnBhe2wIyIiGCqhRbFVEBAljDsoquhCqsKGW86cFVepqMQM7798n+e
	/H/Ph0cW9WHNatlsy1LsNqPFQLRYO7Hil42CBWd+UPR3KlQ1NRC4+DIXzg95NTDTMCJAVX0z
	guczAxK8butCMN3ZTWCsYwrB2ZqICFW/FWL4p2lWBF/rCILR8ksEnnSFJbjo3gWDtcMYrh9r
	ESFc2kOgpHBOhLaZSQmOeusWiq84Jehvdmng+9lzIrQ4hyT4vbWKwMOG1xoYbi/BcFu9gOHZ
	mU4RBl07oas6HiK/jiPobGoRIHLiJwJ3K1oF8LTdleB0oJrAo8JBBIGOMIYz88cJVOa7EMy9
	XKicLHuugcpbD6WdyTw/GCS8Y/ypyK9euC/we+UnMQ/e6BW4T30g8Wp3Nr9Sl8SLgwGRu+uL
	CHdPnZJ46N51wnvK5zD3/bmV+7zTAi8pmCSfrPpCuy1DsZhzFHvKjr1aU/lfHeTgja25/tkX
	ghMVJhejGJnRVBb64Zb4hnsmzi0ypu8zf6RGiDKha1kwOLOYx9F1zOk5jYuRVhbpqMQG7rg1
	0UEs/Yz1qpWLSzoKTL3qXmBZ1lMzG7i0dyleyW5XPMZRFukG5vOESHRFpGvY+VfyUvw2K/As
	tcTQHWygsYJEeRV9j/mbu4WoltGCGBZyzWmWbk5kN+uCuAytVJcp1GUK9X+FukxRjXA90ptt
	OVaj2ZKabMqzmXOT9x2wutHC59Uemf/Si6b6d7cjKiPDCp1/P87Ua4w5jjxrO2KyaIjTlXah
	TL0uw5h3WLEf+MqebVEc7WiNjA0Jus2RbzL0dL8xS/laUQ4q9jdTQY5Z7UTmRu0ftWnp6fMf
	h/L9ifK2U/1nay47sn9uTexdrzTHDqf8q+5JSXu0h5q/85qOpXxa23g44fPNE6+sNtQdG8gd
	zE4rfWu7MevQ0Mai0Y8qp9edHCspe/fak138pnVEzfgx4cM+U9z99L4T9Gl80rfj7xwqGlvL
	XYFwQfyGvu3pWzy7DdhhMm5KEu0O439C5sGzdQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0yMcRzHfZ/nue/zdHP2OOE7+bVrxqL8ynz8mGUtvgwzTFuMjp7p6jrc
	VSsWl5ofN0V+zHVli1Qk2k6/rhXnrjvFH5Kxs4tImCRGRWXSaab/Xnu/33v99RZYZYNsiqDR
	JUp6nVqrwnJOvmlFRjCj5eIWuDsCIb+8DMPNnylQ8rpGBv1lHxjIL61C0NPv5WGo3o3ge8MD
	DJ+c3xAUXuljIf9xJge95QMs2Go/IOg038Lwzt3Ow03rRmgrfs9B3YlqFtrPNGLIyhxkob6/
	m4djNdeHxXeMPDgvN8mguSpbBhcGilioNr7m4WltPoZXZUMyeO/I4qDJcoODrxcbWGjLDgN3
	wSToe9SFoKG8moG+05cxPMutZaCy/hkP51sKMLzNbEPQ4mzn4OKvkxjy0rMRDP4cVnaf7ZFB
	nusVHzafpns8mDq7vrC04sYLhj4353DUc/chQ22WlzwtsCbRO9eDqMnTwlJr6SlMrd/O8bT1
	eR2mjeZBjtreLKO2mu8MzcroxpsnRclXxkhaTbKkn78qWh5r/ujEB+4uS7EP/GCMKDPEhPwE
	IoaSxs9FrI85cRax911hfIzF2cTj6f+b+4tziLHyPGdCcoEVO3nifWKV+YoJ4hby0JL3d6QQ
	gVgqrMMsCEpRQ7y3okfi8aQpt4PzMSvOI7bKVuybsGIAKfktjMQzSEbliMVPXEW8t3OxjyeK
	gcRe9YA5i8ZZRpkso0yW/ybLKFMB4kqRv0aXnKDWaJeEGOJjU3WalJC9+xOsaPhbxWm/cmpQ
	z9O1DiQKSDVWYd/HxSll6mRDaoIDEYFV+SvOuFGcUhGjTj0k6ffv1idpJYMDBQicarJifaQU
	rRT3qROleEk6IOn/tYzgN8WI7Iejkk3HSaHLuWFOW1pSZPXWiLnTdlnnrom49js8sm5WqvJ0
	77bgsuYJuyeve3l/dY7uTZbjcGjH0u24l5k2rtWVXryHmobu32MvGYPT0rfZjlSEH/WrWj8m
	dPGOHVOHdhrNAXpvTKfr5PSZV7vehpVEPg6P2LkoYdMhF7/44PK4xEQVZ4hVLwxi9Qb1H0DS
	Hk1XAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9DAC81C0010
X-Stat-Signature: s5qhcbi5ub1f1zmfpw4o8rcyeaw47sdo
X-Rspam-User: 
X-HE-Tag: 1778674693-224149
X-HE-Meta: U2FsdGVkX19KFPWLpLe1YhlZJkwdVj3SYweWBmwte/x0Hl3U1O3+sxAxpWKozEFAO1Tp+UZs/wq72ycG0s16yq+KtFdbdzT/tXWc+0TQwBNEJCq2PwV5pllIDxcHLmWpzl5Oysnu7IQUj49j6Z+qDgFHuAd92/rY/05Q1Wm8uS140zC16QlYqKvZTzRibznSlX18ujoIt4eGoMqPZ8ItOk5RvFhv0woEqhfR9PfGG+WLv+9uocjpUczNcW0x6AmbpAVnz3pwhZbzuxSOdT40oKlDK6tUmHOyvh3q2IKupf4FUUUyiulBetH1/0iLlXUqMFK2F3/AmjzqG5MWRHqL4EhMzrsrzWQczvyFHVGOi96L4cqPYtBWZlY52tHrujIJ7tPPUJ1ItRFKHAk6TeFGNeyK1rlxX+qP4AmeEh5KpcwhXL2AAmFW0/N7asKJSl3CZGD4IVzcUbPkDNwG7N5SPo5IxKwKzZLJSqrfFdMml7sVcGFtXgh6ijke+GR7bSUgSu1GL5zRzrPus+QffmhXaGh7OaJGSPEV5i56493+ehT9YXOv8UPooOSpxv4aFqfOX3iGqitE+ZefbsNVDXN1tw/WCNnd8XYvRG+WxqyjUrvhbBVOTT/Y8gJai3EQFRBBtH0w/Z+bszmst0+IRFPIJ3Hm6HiwuZnqtAY/3fHC0k3Tl8QePYQ+BFqPsUuSqpHQwp1TsqV5gIdtUw5eBIaBp/mb2ZxWo3ozmao4Ao8Xgu95MQNMGpalNadZgujIy/n/3QhnYtV813II78L4+zByVuhIKRVYAN/MjTMAtIWhAE04LzN4NVEbK+QgQfjNhio+kcWo7jPSeaD9VEyKP+3Pegj0PzG6uBNa/YZffor9lfnmMROKvAMiaI+2oKJFmKLGfVUzM/+se+ZyitpuEvRilf3GNHQqTH1BNiT9UHqaIb5GKfWzvgQDypUGAU6nSkjCvu4uxm/hx9i35PssMYA
 vCRGpbOV
 g0YBdrWYWEfpUfQ0HdfX9/pIKovb03KsEHRPe8LkG4fUBxHNwzoj+R0mJhOCHCNCZUJPVxkVvMsYaIIekq55NQ3a0TH/R6z3rdSCfAqsM4Df1knWTsAKb1fobDY3SHhDsyIs54enWt3YLygIIDcruz3iLCTc4vjtWG+jH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 11:00:51AM +0200, Dragos Tatulea wrote:
> On 24.02.26 06:13, Byungchul Park wrote:
> > Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> > determine if a page belongs to a page pool.  However, with the planned
> > removal of @pp_magic, we should instead leverage the page_type in struct
> > page, such as PGTY_netpp, for this purpose.
> >
> > Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> > and __ClearPageNetpp() instead, and remove the existing APIs accessing
> > @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> > netmem_clear_pp_magic().
> >
> > Plus, add @page_type to struct net_iov at the same offset as struct page
> > so as to use the page_type APIs for struct net_iov as well.  While at it,
> > reorder @type and @owner in struct net_iov to avoid a hole and
> > increasing the struct size.
> >
> > This work was inspired by the following link:
> >
> >   https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> >
> > While at it, move the sanity check for page pool to on the free path.
> >
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Acked-by: Zi Yan <ziy@nvidia.com>
> > Acked-by: Vlastimil Babka <vbabka@suse.cz>
> > Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> > ---
> 
> Seems like this patch broke tcp_mmap because
> validate_page_before_insert() returns -EINVAL due
> to a page having a type. Here's the full flow:
> 
> getsockopt(TCP_ZEROCOPY_RECEIVE) returns -EINVAL because of the
> below flow in the kernel:
> 
> tcp_zerocopy_receive()
> -> tcp_zerocopy_vm_insert_batch()
>   -> vm_insert_pages()
>     -> insert_pages()
>       -> insert_page_in_batch_locked()
>         -> validate_page_before_insert() returns -EINVAL
>            because page_has_type(page) is now true.
> 
> The patch below fixes the issue. But is this a valid fix?

Hi,

The problem comes from the fact that page_type and _mapcount are
union'ed but there is a case where these two information should be kept
at the same time.

Why don't we allow these two information can be kept in the 4 bytes at
the same time until Zi Yan's work on _mapcount and page_type will be
done, instead of taking a step back?

It can be more optimized but I suggest the approach I just mentioned:
---
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 64dc44832808..e5ec204866dc 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -185,8 +185,7 @@ static inline int folio_precise_page_mapcount(struct folio *folio,
 {
 	int mapcount = atomic_read(&page->_mapcount) + 1;
 
-	if (page_mapcount_is_type(mapcount))
-		mapcount = 0;
+	mapcount = page_mapcount_clear_type(mapcount);
 	if (folio_test_large(folio))
 		mapcount += folio_entire_mapcount(folio);
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8260e28205e9..f45064796313 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1865,8 +1865,7 @@ static inline int folio_mapcount(const struct folio *folio)
 
 	if (likely(!folio_test_large(folio))) {
 		mapcount = atomic_read(&folio->_mapcount) + 1;
-		if (page_mapcount_is_type(mapcount))
-			mapcount = 0;
+		mapcount = page_mapcount_clear_type(mapcount);
 		return mapcount;
 	}
 	return folio_large_mapcount(folio);
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0e03d816e8b9..f3b0d1fa262d 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -934,9 +934,9 @@ static inline bool page_type_has_type(int page_type)
 }
 
 /* This takes a mapcount which is one more than page->_mapcount */
-static inline bool page_mapcount_is_type(unsigned int mapcount)
+static inline unsigned int page_mapcount_clear_type(unsigned int mapcount)
 {
-	return page_type_has_type(mapcount - 1);
+	return (unsigned int)(((int)(mapcount << 8)) >> 8);
 }
 
 static inline bool page_has_type(const struct page *page)
@@ -953,16 +953,20 @@ static __always_inline void __folio_set_##fname(struct folio *folio)	\
 {									\
 	if (folio_test_##fname(folio))					\
 		return;							\
-	VM_BUG_ON_FOLIO(data_race(folio->page.page_type) != UINT_MAX,	\
+	VM_BUG_ON_FOLIO(page_type_has_type(data_race(folio->page.page_type)), \
 			folio);						\
-	folio->page.page_type = (unsigned int)PGTY_##lname << 24;	\
+	folio->page.page_type &= ~(PGTY_mapcount_underflow << 24);	\
+	folio->page.page_type |= (unsigned int)PGTY_##lname << 24;	\
 }									\
 static __always_inline void __folio_clear_##fname(struct folio *folio)	\
 {									\
-	if (folio->page.page_type == UINT_MAX)				\
+	int mapcount;							\
+									\
+	if (!page_type_has_type(folio->page.page_type))			\
 		return;							\
 	VM_BUG_ON_FOLIO(!folio_test_##fname(folio), folio);		\
-	folio->page.page_type = UINT_MAX;				\
+	mapcount = atomic_read(&folio->page._mapcount);			\
+	folio->page.page_type = page_mapcount_clear_type(mapcount);	\
 }
 
 #define PAGE_TYPE_OPS(uname, lname, fname)				\
@@ -975,15 +979,20 @@ static __always_inline void __SetPage##uname(struct page *page)		\
 {									\
 	if (Page##uname(page))						\
 		return;							\
-	VM_BUG_ON_PAGE(data_race(page->page_type) != UINT_MAX, page);	\
-	page->page_type = (unsigned int)PGTY_##lname << 24;		\
+	VM_BUG_ON_PAGE(page_type_has_type(data_race(page->page_type)),	\
+				page);					\
+	page->page_type &= ~(PGTY_mapcount_underflow << 24);		\
+	page->page_type |= (unsigned int)PGTY_##lname << 24;		\
 }									\
 static __always_inline void __ClearPage##uname(struct page *page)	\
 {									\
-	if (page->page_type == UINT_MAX)				\
+	int mapcount;							\
+									\
+	if (!page_type_has_type(page->page_type))			\
 		return;							\
 	VM_BUG_ON_PAGE(!Page##uname(page), page);			\
-	page->page_type = UINT_MAX;					\
+	mapcount = atomic_read(&page->_mapcount);			\
+	page->page_type = page_mapcount_clear_type(mapcount);		\
 }
 
 /*
diff --git a/mm/debug.c b/mm/debug.c
index 77fa8fe1d641..9a932ded09d4 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -74,8 +74,7 @@ static void __dump_folio(const struct folio *folio, const struct page *page,
 	int mapcount = atomic_read(&page->_mapcount) + 1;
 	char *type = "";
 
-	if (page_mapcount_is_type(mapcount))
-		mapcount = 0;
+	mapcount = page_mapcount_clear_type(mapcount);
 
 	pr_warn("page: refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
 			folio_ref_count(folio), mapcount, mapping,
---

Thoughts?

	Byungchul

> diff --git a/mm/memory.c b/mm/memory.c
> index ea6568571131..4cb12673f450 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2326,7 +2326,7 @@ static int validate_page_before_insert(struct vm_area_struct *vma,
>                         return -EINVAL;
>                 return 0;
>         }
> -       if (folio_test_anon(folio) || page_has_type(page))
> +       if (folio_test_anon(folio) || (page_has_type(page) && !PageNetpp(page)))
>                 return -EINVAL;
>         flush_dcache_folio(folio);
>         return 0;
> 
> Thanks,
> Dragos
> 

