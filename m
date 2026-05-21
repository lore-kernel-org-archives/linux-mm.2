Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97394CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4846B00BB; Thu, 21 May 2026 10:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB936B00BC; Thu, 21 May 2026 10:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8A96B00BD; Thu, 21 May 2026 10:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8F16B00BB
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:56:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35F7B8F36C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:56:28 +0000 (UTC)
X-FDA: 84791728056.06.92AC746
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8D5FF1A000D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:56:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kYi1YN00;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779375386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UITWpdaqbmI+fp8vUpGC9W+rWwdbi7PzAOTS6vN0L7Y=;
	b=JODFPiIOajbDSQBHnwyhcavLAMu1/ApkMtWu/LKDekeOTtOuYIqDol2ah2uGkNxhLqTjJb
	tHH62C9lFud8eVPTgqDBNK+DNc8zAwXu149Fdv6E1z+IzdxHQjms8IdW/SeJLhLTtixapp
	R2/rd+6DyX0uVOBghAZjIqAjj+dF+0c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kYi1YN00;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779375386; a=rsa-sha256;
	cv=none;
	b=GfTekJXDlmmEVQ33iDo1+Kjzw1Ngw0/l+GSdyQwSyey6Npqjn80odST2VHXyricYiRUL7x
	Pxsf0pKzJjWCldU80uoWI/B6+PE88bbxtItuNP9VKR6Nh92C0OYaooIrhhezdYdkYFx1mY
	+qRq8kf+2dksXXbTwj0UrBVI+3v6p+E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A74D240A49;
	Thu, 21 May 2026 14:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9A61F00A3C;
	Thu, 21 May 2026 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779375385;
	bh=UITWpdaqbmI+fp8vUpGC9W+rWwdbi7PzAOTS6vN0L7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kYi1YN00SLOx0SAxRVqjzzEEdS1bDGJ7OZEYKRWL8wpyEU4dETS28epa1mKmZCuBC
	 MCRmZPQQQ6F+PYtAcHIr/LxNXDN/P5rUN/+CsikKdzxMf1+YB66PSTMn2iK+/tq8xH
	 jGvW/qdgtimxel2c4S1+AvVyA4jdD8nRTTPYIf7Qi2q5j1QzG6o3K8aN0zVF9Rm2nB
	 Kok/4Qe3jV6eUTHBd2FlWwQd1oSr85r6Bkh2i8CyYA/wh4GrH54DNM/vGl94pZYpMS
	 2o6KR1pBHDDSgYJKH5MKB/wGc3+ZUK4arPsAlsSQuc3+Mi4qfikI+KI4XA0TE/zMRK
	 U5AO5wduKquFg==
Date: Thu, 21 May 2026 15:56:19 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, 
	Yury Norov <yury.norov@gmail.com>, David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vdso: move offset_in_page() from linux/mm.h to
 vdso/page.h
Message-ID: <ag8cvjwDGCt_14pY@lucifer>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
 <20260521090655.160282-5-thorsten.blum@linux.dev>
 <ag7pFxHpMGU0zLvq@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag7pFxHpMGU0zLvq@lucifer>
X-Stat-Signature: h7b5a59p6ji59xxmjiup653sz6bpyiih
X-Rspamd-Queue-Id: 8D5FF1A000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779375386-200508
X-HE-Meta: U2FsdGVkX1/t3ZAgo9368e8ua22qXL27BgZaft+pXqmlLiBKYTIcX9SoXFi6NzCue4lNu8YXRafa0uG6zOoRQVosgeEe0f/EPh2Uyg9BLSn4nopnO44GcU3UFCgPoYONf3CjFNZNRsd/zva37SVetPO+dMpbZkr+g+SW/EV8IRw2uEolawIJFwzP8HDS/ENx8ihBLjRPad6g5OVzh/JIHYzGq+ZKEvpQJSpZGAilQ7nNOaGC7gOP9kPMYBajtv1fTZE9ODRB3RvP83372gwJ1DWHY4amDmNUsSQrPPFiNZwZ1RcgVHVOE8rTQl/MUyaD3/w8MdIYyUUS1lR0RZaL8lmp57g1pZGVABX8U+3e+j+YDAljFO1LNV5Oppr5BrbS+BI0fI+szjg1dEHVlRzL+s84EmLiJxrcc8IczUOPvleaG9mZWkGJdRFPCGstU6qDpcdMjuTZFq00eGcciZHYBxD4GCzBCZ0+n1+1TdnWVmOJGaHXxXNt+tnPbiO70WMTkHsRl+FKAJUG1xsfgP7bs1AlO1Jm/RW3A8Srgu0E7i3d5wlNmzOHEL8EHOGj8MunuRhhgthHS0cpAlfQJqEVBCz8pNhoAcMXQrgnw0C/+uQsv61C68zUjS/0rGdSeeFwx4k8fDfygTfI8wUN/dcoZY+V3JxLoJE122fYoQ/1Mz0Unza/evUM5fbVzwus133VKgDvIMJ7cKKpWO3lfEzTaVmVoKXXkHUY1rY/BWJ0i0i6ZKBLTbRkKupTBEZO7yw7EWYE+ZhxnY0ksjFo4zpKYzOH8YRTI4NzzjQPnhTmVKY37GuxaVHUik5qc5jHTyWHI7ACI3cddq657EU0LPe/KJM7q5zJanD7G1QvBbhxu0u8i75OLEgZ6qBG+o4A9yAk2y4PGp6QZGD/2OTUZqp72+WplTs0FL2TKgbdDQg1iw6FvtSbHInTvYRZAQsD96ngVZBN/uWCJpvv4GtEYaZ
 e6R1cwvg
 2YUz/IRvBa32zAFMYOiJo+2IhIViyu5faIBd4SnSN6+trXMk2HoQh+QMHu9e0f7IndlXoJ21Qhapvedp1OGzy9AMVaWcxXVWey46NGEAQcKzq7cKEAm1kpBK2G2d/h92oiED4jKokglq2m1tS/OIT44ZnNrLXmpVw2apLp4bIYWjiSGDRa17A4pizpld9InZCj8mdizj35HGcIdn1PTWnf3FxrESm/xAAayRKVEy9FWZjJ/mXp/hwV0PFSJVKL/86STdRYN7yBVTQ+MWbJtpOrKosLhu2/rX5YNAS/yd68XoFNGyB7ifpqL7dfBGIQ83jXjgMcPnQE2PRZKb+UrnloceeZe9pcLftaPNnblEylp5StEJSe0EGRXTag2qscj9Jc6NhqC+OoUSs5zjK0899RYYZTCZTA5M9X2GHZga3UsXCy0V3mO0N/RwMk4r1pzu9YJ1XxLrGONngVyzp5TgtIT23ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 12:16:00PM +0100, Lorenzo Stoakes wrote:
> On Thu, May 21, 2026 at 11:06:57AM +0200, Thorsten Blum wrote:
> > Move offset_in_page() out of linux/mm.h so users that only need page
> > offset calculations can include the lightweight vdso/page.h header
> > instead of pulling in the large linux/mm.h.
> >
> > Include vdso/page.h from linux/mm.h so existing users of
> > offset_in_page() continue to build.
> >
> > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>
> LGTM other than dropping the include below (maybe Andrew can do it for
> us?), so:
>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

TBH I'd like to withdraw this at this point.

Unless a series can be put forwards that sensibly justifies this, not some
random change somewhere, I'd rather we not take it.

Also vdso/page.h is a VDSO-specific header by MAINTAINERS, offset_in_page() is
really an mm thing so that's another reason not to move it.

(A justifying change would show actually build time/binary bloat/etc. numbers +
involve actual substantive changes).

Thanks, Lorenzo

>
> > ---
> >  include/linux/mm.h  | 2 +-
> >  include/vdso/page.h | 2 ++
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 9cedc5e75aa9..d5c7f1ca80ef 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -37,6 +37,7 @@
> >  #include <linux/bitmap.h>
> >  #include <linux/bitops.h>
> >  #include <linux/iommu-debug-pagealloc.h>
> > +#include <vdso/page.h>
>
> Yeah as per David Laight, we don't need this.
>
> >
> >  struct mempolicy;
> >  struct anon_vma;
> > @@ -3023,7 +3024,6 @@ static inline void clear_page_pfmemalloc(struct page *page)
> >   */
> >  extern void pagefault_out_of_memory(void);
> >
> > -#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
> >  #define offset_in_folio(folio, p) ((unsigned long)(p) & (folio_size(folio) - 1))
> >
> >  /*
> > diff --git a/include/vdso/page.h b/include/vdso/page.h
> > index bc47186c07fc..948b13091084 100644
> > --- a/include/vdso/page.h
> > +++ b/include/vdso/page.h
> > @@ -28,4 +28,6 @@
> >  #define PAGE_MASK	(~(PAGE_SIZE - 1))
> >  #endif
> >
> > +#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
> > +
> >  #endif	/* __VDSO_PAGE_H */

