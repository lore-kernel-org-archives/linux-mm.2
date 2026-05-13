Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA92ECD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A34B6B00E8; Wed, 13 May 2026 09:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17A626B00E9; Wed, 13 May 2026 09:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 069F76B00EB; Wed, 13 May 2026 09:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E79AE6B00E8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:26:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B9D5C01C7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:26:51 +0000 (UTC)
X-FDA: 84762471822.14.A906256
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf26.hostedemail.com (Postfix) with ESMTP id 09954140003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:26:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WDfTAo0OIOUfG8b2TDaXhejpQH/RpFV/3+34g91DSug=;
	b=Ow/50HoVGG5E3pmCIHK+HY1FH/KsFKQrn9b1sRmMQUGvS7lTTHO5TidRiVPwrFmRXAzAqd
	yYWb3EaRaRNJDRLTLqzPE+JFCguvbBu2L4cPDnIXK/9cGgg4Cwf/WNNaGg6LRgseoMsWjj
	L6ds7zSJUqxQEOgJhfDc3dAjpAIvh1k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678809; a=rsa-sha256;
	cv=none;
	b=uVW9pkd3gw2/IuvPMCsgnB5SrjBgr/CtH8b5sFA6lLC/3LH2qmK+EhQlBWwbgLyzs8eGZt
	fkporyK3f+4+h8suxlNI5qPp3x4gCFP1kR9Ej8rs5BBcd9vBEiuQ9xyLg1UYdnWl54wqn6
	7mgnjylijOcn8wRPT7ofKGLOMhQh73g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c2dff70000001609-29-6a047c1158fa
Date: Wed, 13 May 2026 22:26:36 +0900
From: Byungchul Park <byungchul@sk.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
	akpm@linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com
Subject: Re: [PATCH v4] mm: introduce a new page type for page pool in page
 type
Message-ID: <20260513132636.GA75142@system.software.com>
References: <20260224051347.19621-1-byungchul@sk.com>
 <982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com>
 <20260513121805.GA22430@system.software.com>
 <8348d867-f8a1-432c-be2d-699ad96b2e93@kernel.org>
 <20260513123920.GA51788@system.software.com>
 <627bb280-be44-4648-8771-5a479cda988f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <627bb280-be44-4648-8771-5a479cda988f@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec95d85xtTiurDeFgkkYQnYTeoIYEn04EYOyIiiiVh50piu2
	Mg0jLSmN1O7ptshWzttKWDndaqFO5zIiXSTrqi5TulleGJphzUXUtx//5//8nvfDy9HyJ5Jo
	TqM9LOq06gwFI8XSr7PNyyJzcfqK5zUKMNVbGaibyIaqviYJTFqHKDDV2hGMT75m4ZfLg2Cs
	rYOBz+5RBLduBmkwPSvAMNTwA4HDOYTgU9kdBj54AizU2VTQaxnE8PBMIw2BUi8DxQVTNLgm
	h1k42VQdEt/LY6HLXiKByz8qaWjM62PhudPEwDvrLwkMthZjeGyowfD9ShsNvSVJ4KmYD8En
	XxC01TdSEDx3nYEX5U4KGlwvWLjkq2DgfUEvAp87gOHKz0IGjPklCKYmQsrh8+MSMLa/Y5MS
	hHy/nxHcX77Rwv2al5TQU3YBC/5HnZTgMLxlhQrbEeFedbxw1u+jBVttESPYRi+ywpueh4zg
	LZvCgqN/reBoGqOE4lPDzOaondJ1KWKGJkvULVfulaY9spipQ6eV2Z1j/TgPOeLOogiO8InE
	lO+h/vJA9216hjG/hAyYRtAMM3wc8fsnw/k8fgUZ8p4M9aUczU+zZOKpC88M5vLJpNNgDJdk
	PJBmY3mY5Xw9RT63pP/JI8nj8oFwn+bjiX/6Y0jEhTiGVE1zM3EErySvem6EV6P4WNJs7wjf
	Ivw4R8zfnfSfhy4kLdV+fB7xhv+0hv+0hn/aCkTXIrlGm5Wp1mQkJqTlaDXZCfsPZtpQ6ItZ
	jv/c1YRGu7a2Ip5Ditmy5lScLpeos/Q5ma2IcLRinqzUg9LlshR1zjFRd3CP7kiGqG9FMRxW
	LJCtCh5NkfOp6sPiAVE8JOr+TikuIjoPqRbMyV2cdHXu9bvKRetTa1T9kRarPaXScsEYm9hd
	vTE57pq5aveG1VtKC7/Fd5ZudTQUubHdXvRhh3m971Zgls5mmfi6r8/aMeKM9SW7tyuXKlWD
	+faNceXnoscUvpZK8YHXe7pbtS1XG6N/8PFE9qLAplftnwbaXUHvGplmpFCB9WnqlfG0Tq/+
	Df11sd1eAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG/Z9zds7ZanBcy/4k9GEVoqFWFLxRSJcPHboRfREqyJWHtuVM
	NhXtQqvZTdIyE+ZctG7zkiLMvExUbJqpFZqlLSunZo20zJqZU7HmIvLbj+d9fs+nlyVlZaKl
	rDoxWdAlKhMUtISS7NlojAw+RWlWu/sWgKW8lIYHk2lQ2F8jAl+phwBLSRWCcd9bBn7XtyDw
	Nj+hYaTpB4K7tydIsHRkUOCpnELgqPUgGDaV0fCxZZCBB/bd4LZ9oqDuYjUJg1dbacjKmCah
	3jfKwLmaIv9whYGBppttIuisyhbBjan7JFQb+hl4WWuhoa/0twg+ObMoaDMXUzCW10yCO3sz
	tFhDYOLpFwTN5dUETFy5SUN3fi0BlfXdDOR2WWn4kOFG0NU0SEHezCUaCs5mI5ie9E+OXhsX
	QcHjPmZzNH/W5aL5pi/fSP5h8RuC7zHlULyroZ3gHeb3DG+1p/AVRRF8pquL5O0ll2ne/uM6
	w7/rqaP5VtM0xTsGNvCOGi/BZxlH6b0h+yWb4oUEdaqgi46Jk6gabHeIpAsxae3eAcqAHGGZ
	SMxibh0eenGPnGOKW4mHLN/RHNNcGHa5fIFczq3GntZzRCaSsCQ3y+DJ5/XU3GERtw+3mwsC
	JSkHuLEgP8AyrpzAI480f/Ng3JY/FOiTXAR2zX72D7F+DsWFs+xcLOZicG/PrYC6mFuOG6ue
	ENeQ1DzPNs+zzf9tKyJLkFydmKpVqhPWR+mPqdIT1WlRR45r7cj/RLbTMzk1aPzldifiWKRY
	KG08SmlkImWqPl3rRJglFXLp1RakkUnjleknBN3xQ7qUBEHvRKEspVgi3RErxMm4o8pk4Zgg
	JAm6f1eCFS81oFxPbMOSrae7c26HqLS/Lgyd12wz9B5hFcs25q0yacUnx8TiEz+He1/VbY/s
	2GIJGvC+XuuNNh6IQp2thGMqzqd6ujOoy/r1W/zHr1u4FWd2Te++aCf3vM81H37mxG/aHqYf
	9GUbP9tCO2ZMt+RSOXdl3Yr1eWkhxvD89vAi90msoPQq5ZoIUqdX/gGv6fkZQAMAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 09954140003
X-Rspam-User: 
X-Stat-Signature: xmh9kxgscj45ypio5u85p9rw6wo8ey6i
X-HE-Tag: 1778678804-16848
X-HE-Meta: U2FsdGVkX19MM8v3tAwrtf/X6BhVxMjgN7L4m2N/Ra1D1BJJwjSAKUrKG6XVbu1EEFLheNauga5rcUAUlZAHln3oRRvFp4M+mUDvv9UAGiOru/pDsmKEPDUOzzsT3KxW2OB1oKJAd8AYeSBdeHLGyAifxQBKHyWsWKb7TeXNacfSzKE+BrD+yJ7GUev3NaQsxGEirMVFiDpX1YDgwp4tDI9qoileANKWteQ+nwoWCPLaGefDum1jRtRRc4BHoLDjUZsJjHEK8Ecdzcc2zgvkWTHa+6LvjJrwJiwsGvkmpHzdweMDvr6bUbNrIAfwWBj9b8Ze6i584xIdyNghiUn91pSMJra89HHePRFj89pnPjmcH79nMszJv65gnWgGqK5Rq2BNo3ndC+jhmfA/Nt/m7j7oI7p54YGrtInmcm7Nvyyjs/VZ2LyY4uPzJoUAk+9BQVw51z138Rh5+HhXgb0uOzioOyXuJoH6vIToI21/odUxC8g9ptl+RYrBViblSucYcYOQdvMn7NLXTFCOg1eUMxe5kHKGF1Pmlf0b9MarTPfD9ECoGSjRaM5/k+X//6tRv02JtnfTBkpkwH3u9x+mBjExgjjq3ujJtOnp6aM7IEUa7oBw9GODJL44VgXqTvitPliWQoJZwLSPspgB7oSjPuJZlyXEHyXPuwOUBLXoNLGZE0zWDva2wMeQfQpn4Z8PtcxJmTNQntRzX5V5xcdsieb9gSZ99fyPhqZ7+bEsfcIDTEyMKHHHEI3/1B7Mea1gxu+iviqrVZQVKEgSPv1ZifHTkuJbuM5MyTa3liEg3Fx/t/PKq9jiQWLOcqWnIkDlquexRMgZB7d4SAcpXFDGRkHilwAMXqXqq7OROU7FWIr+UsCmX1o2fvfyqNSjzECeDSG+FsQL14A/IIP6hUgP9TPx/f4Qmt6eTaeewNpE1QuzmTDTreB/zT6VQr0wH6VTX0poFtCs5MbUyB4tcMB
 D5EMj37s
 Nc2hPfvd14HHcB/9A3zMGno7nHnHwYDP/CJDXPbyrzy6GQTRRjBBKrmz2hpY3IQcPQd+rkcOhcsmpfLtzxLspGFpcx+V1k2r+kKfNszsLmJyGrrz3RnuBUNOod2849fO685R+E5/D4dFIMYexRwW1Vm1Uu6Wb9j8ACpYkedkUz91EYLZZisJh2duQLi9+Rq0n6Bqp1X3gaabUm90=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 03:02:43PM +0200, David Hildenbrand (Arm) wrote:
> On 5/13/26 14:39, Byungchul Park wrote:
> > On Wed, May 13, 2026 at 02:29:46PM +0200, David Hildenbrand (Arm) wrote:
> >  On 5/13/26 14:18, Byungchul Park wrote:
> >>>
> >>> Hi,
> >>>
> >>> The problem comes from the fact that page_type and _mapcount are
> >>> union'ed but there is a case where these two information should be kept
> >>> at the same time.
> >>>
> >>> Why don't we allow these two information can be kept in the 4 bytes at
> >>> the same time until Zi Yan's work on _mapcount and page_type will be
> >>> done, instead of taking a step back?
> >>>
> >>> It can be more optimized but I suggest the approach I just mentioned:
> >>> ---
> >>> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> >>> index 64dc44832808..e5ec204866dc 100644
> >>> --- a/fs/proc/internal.h
> >>> +++ b/fs/proc/internal.h
> >>> @@ -185,8 +185,7 @@ static inline int folio_precise_page_mapcount(struct folio *folio,
> >>>  {
> >>>       int mapcount = atomic_read(&page->_mapcount) + 1;
> >>>
> >>> -     if (page_mapcount_is_type(mapcount))
> >>> -             mapcount = 0;
> >>> +     mapcount = page_mapcount_clear_type(mapcount);
> >>>       if (folio_test_large(folio))
> >>>               mapcount += folio_entire_mapcount(folio);
> >>>
> >>> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >>> index 8260e28205e9..f45064796313 100644
> >>> --- a/include/linux/mm.h
> >>> +++ b/include/linux/mm.h
> >>> @@ -1865,8 +1865,7 @@ static inline int folio_mapcount(const struct folio *folio)
> >>>
> >>>       if (likely(!folio_test_large(folio))) {
> >>>               mapcount = atomic_read(&folio->_mapcount) + 1;
> >>> -             if (page_mapcount_is_type(mapcount))
> >>> -                     mapcount = 0;
> >>> +             mapcount = page_mapcount_clear_type(mapcount);
> >>>               return mapcount;
> >>>       }
> >>>       return folio_large_mapcount(folio);
> >>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> >>> index 0e03d816e8b9..f3b0d1fa262d 100644
> >>> --- a/include/linux/page-flags.h
> >>> +++ b/include/linux/page-flags.h
> >>> @@ -934,9 +934,9 @@ static inline bool page_type_has_type(int page_type)
> >>>  }
> >>>
> >>>  /* This takes a mapcount which is one more than page->_mapcount */
> >>> -static inline bool page_mapcount_is_type(unsigned int mapcount)
> >>> +static inline unsigned int page_mapcount_clear_type(unsigned int mapcount)
> >>>  {
> >>> -     return page_type_has_type(mapcount - 1);
> >>> +     return (unsigned int)(((int)(mapcount << 8)) >> 8);
> >>>  }
> >>>
> >>>  static inline bool page_has_type(const struct page *page)
> >>> @@ -953,16 +953,20 @@ static __always_inline void __folio_set_##fname(struct folio *folio)    \
> >>>  {                                                                    \
> >>>       if (folio_test_##fname(folio))                                  \
> >>>               return;                                                 \
> >>> -     VM_BUG_ON_FOLIO(data_race(folio->page.page_type) != UINT_MAX,   \
> >>> +     VM_BUG_ON_FOLIO(page_type_has_type(data_race(folio->page.page_type)), \
> >>>                       folio);                                         \
> >>> -     folio->page.page_type = (unsigned int)PGTY_##lname << 24;       \
> >>> +     folio->page.page_type &= ~(PGTY_mapcount_underflow << 24);      \
> >>> +     folio->page.page_type |= (unsigned int)PGTY_##lname << 24;      \
> >>>  }                                                                    \
> >>>  static __always_inline void __folio_clear_##fname(struct folio *folio)       \
> >>>  {                                                                    \
> >>> -     if (folio->page.page_type == UINT_MAX)                          \
> >>> +     int mapcount;                                                   \
> >>> +                                                                     \
> >>> +     if (!page_type_has_type(folio->page.page_type))                 \
> >>>               return;                                                 \
> >>>       VM_BUG_ON_FOLIO(!folio_test_##fname(folio), folio);             \
> >>> -     folio->page.page_type = UINT_MAX;                               \
> >>> +     mapcount = atomic_read(&folio->page._mapcount);                 \
> >>> +     folio->page.page_type = page_mapcount_clear_type(mapcount);     \
> >>>  }
> >>>
> >>>  #define PAGE_TYPE_OPS(uname, lname, fname)                           \
> >>> @@ -975,15 +979,20 @@ static __always_inline void __SetPage##uname(struct page *page)         \
> >>>  {                                                                    \
> >>>       if (Page##uname(page))                                          \
> >>>               return;                                                 \
> >>> -     VM_BUG_ON_PAGE(data_race(page->page_type) != UINT_MAX, page);   \
> >>> -     page->page_type = (unsigned int)PGTY_##lname << 24;             \
> >>> +     VM_BUG_ON_PAGE(page_type_has_type(data_race(page->page_type)),  \
> >>> +                             page);                                  \
> >>> +     page->page_type &= ~(PGTY_mapcount_underflow << 24);            \
> >>> +     page->page_type |= (unsigned int)PGTY_##lname << 24;            \
> >>>  }                                                                    \
> >>>  static __always_inline void __ClearPage##uname(struct page *page)    \
> >>>  {                                                                    \
> >>> -     if (page->page_type == UINT_MAX)                                \
> >>> +     int mapcount;                                                   \
> >>> +                                                                     \
> >>> +     if (!page_type_has_type(page->page_type))                       \
> >>>               return;                                                 \
> >>>       VM_BUG_ON_PAGE(!Page##uname(page), page);                       \
> >>> -     page->page_type = UINT_MAX;                                     \
> >>> +     mapcount = atomic_read(&page->_mapcount);                       \
> >>> +     page->page_type = page_mapcount_clear_type(mapcount);           \
> >>>  }
> >>>
> >>>  /*
> >>> diff --git a/mm/debug.c b/mm/debug.c
> >>> index 77fa8fe1d641..9a932ded09d4 100644
> >>> --- a/mm/debug.c
> >>> +++ b/mm/debug.c
> >>> @@ -74,8 +74,7 @@ static void __dump_folio(const struct folio *folio, const struct page *page,
> >>>       int mapcount = atomic_read(&page->_mapcount) + 1;
> >>>       char *type = "";
> >>>
> >>> -     if (page_mapcount_is_type(mapcount))
> >>> -             mapcount = 0;
> >>> +     mapcount = page_mapcount_clear_type(mapcount);
> >>>
> >>>       pr_warn("page: refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
> >>>                       folio_ref_count(folio), mapcount, mapping,
> >>> ---
> >>>
> >>> Thoughts?
> >>
> >> God no.
> >
> > This is not final patch, but for sharing the rough idea *with code* -
> > maybe there are more points in code that should be adjusted by the
> > change.  I just typed the draft patch quick just for sharing idea.
> >
> > If we should allow pp type pages to be used in mapping as well, then
> > we should allow a page to keep both its type and mapcount at the same
> > time.  Am I missing something?
> 
> We don't want code to accidentally overflow mapcounts into these bits and have
> them wrongly be detected as page types.
> 
> This is just very fragile.

Okay.  Thanks for the explanation.  Plus, the adjustment I mentioned
might not be as simple as I thought it'd be.

So sorry about the noise.  I'm a zombie now.  I'll think about it after
some rest.

	Byungchul

> --
> Cheers,
> 
> David

