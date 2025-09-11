Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AFD7CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 21:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9739D8E0006; Thu, 11 Sep 2025 17:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9241F8E0001; Thu, 11 Sep 2025 17:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839FE8E0006; Thu, 11 Sep 2025 17:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 714428E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:45:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F39DBA3C9
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:45:00 +0000 (UTC)
X-FDA: 83878299960.27.7EA0F19
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 19114100013
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:44:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H3dLQbcD;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757627098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0A29RAJZH8PG2jCbsFMQRYsD8GmFmnNdYOX2gwfe4Lw=;
	b=CIYlAPQx4NAdZ0GGXokEupcVHR5SuOdUf4CleTn3IqFy3DlwxBPYcem+TGpKhy7DM8WjK+
	/A94H8EYTjrvR+RaDvgESaN5BTdV0W2EgSi7wZfGJwAzkgfMDmUO93nzgYFSzPdFOTEhPL
	d8akBnc0jyhoDnJCDcY0aqdnwsGqek4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H3dLQbcD;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757627098; a=rsa-sha256;
	cv=none;
	b=UyZmRz8QhQGOZMbmb796/ZfxIBEQOhj5iIMMGmUlUUX5be5BERFn16YAY5bwHadSyzoBlU
	mdrLmFFdhXpU521fyFCsvPTmx3oH6x+SzjuajWSPpmjjb34XEVa4HB69FV52DFLNvgjLKm
	FaCg9j6W0BEdCuNJpvQsX+BQZLE8jis=
Date: Thu, 11 Sep 2025 14:44:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757627095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0A29RAJZH8PG2jCbsFMQRYsD8GmFmnNdYOX2gwfe4Lw=;
	b=H3dLQbcDZZfN0YTwx8Yx5vRwlMz8fXhAnF+DfEkbdJyg3YoJt9VzaKBAzCtvpUS9yIeFog
	aQMsWa9vB6Mj/4XGLcWaJ0A7p8SyBtbbgPBb4rOkMx9j3HHqfFDreElJsT1kJ94gTj6sAu
	6zIXWg2AXMnSItiuKyIxhJFw3Wq1+PU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	usamaarif642@gmail.com, 00107082@163.com, pasha.tatashin@soleen.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] alloc_tag: avoid warnings when freeing non-compound
 "tail" pages
Message-ID: <yfebg4bs4nck7kvc3d3irbxpfja45pcyjbtip2jtcojiv5pj4f@jp53hiso6vga>
References: <20250909233409.1013367-1-surenb@google.com>
 <20250909233409.1013367-4-surenb@google.com>
 <zxbgiqf4d3nlww2xxoea7rud3q4oj2osk657xnhu6r7du4lf3p@es7mqt7joo7b>
 <CAJuCfpFV0d=JSwA8zDpdrg4C2TpTTZypeX0Qype-EFKHho2bQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFV0d=JSwA8zDpdrg4C2TpTTZypeX0Qype-EFKHho2bQQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 19114100013
X-Rspamd-Server: rspam05
X-Stat-Signature: nrcfypr4iddjhjoameqji6nfebqmrzyu
X-Rspam-User: 
X-HE-Tag: 1757627097-396930
X-HE-Meta: U2FsdGVkX1/ApYi3U3Jtj++BclyxOTxLmYAN5sGBjHy5easgxXpfd71y2k7kp81NiMi62vMHpcD5BZnK8Z1p6W/nuvQ9siY3K1WJC7e/q/HvxVXp2XChszT5zDaB5kBJDz3j2SysInysQsVHS7KZyeIWL/p9zU9kBdFG76OIBWZ3IoM20cag78+G+bEivD+0xFsrXWTO9UjlV7+/pWM9TCVcW570dnogTUzmGvZ4h6RCya/L3Xes6GACXOfWZJ/QIq/QvZi5OoPa53CKrMyBNqTgUUJCJRj0LGMf1V0aZaY86/y4IuaKF2PQJXxVadnDOyu9dftvZ5gvwqDASkr71prNoijW4VeLz0Cn5vsVy9xq1+NccEIg7q1b8Qm7203gWBEAN13oD0rZ9azwxurUw/8mUIaOprpBLCwmCHVY06fUW92nIkVkkW2dCi656VOMQle01sQkR2eTdV2z10l0eKWQFr0TbianFC4plxDcwxbOg3H6VFOBi2IRz16Pjq+jmfp3pE+hbkv55YGbxeHZQY5iDG41MDwlfPh++ZMQNl49TZCEuGpBbpploTnJn3whH4F9WxZKbPW+6ZQ0+NyABnspfvnZ3OgJfpmM+Kf0IsR4ghYH/zsZKiXz6cEccgpVbjZMN3ZDUe5xnAF+sXcgOCWwjrVSjJo8msRaizU+vK3+hKSiol7vpho3PPLGsBND4pGcXQXr+SJlrr7B09DbSHFjKxn49vtOFJjKXPZH9quA8lj/InnCDh9CjMHCLinAOAdMmikfFyeHZbLW5UkW+Vge81tf0gV7i0xeIeAwZqk0Xr7RVtMGIUYkZP3ff+LJdF/sXnERUGyBZ1xTTnZibsOFVBg42/cIX3l4y8JB9keTrAjq5YVowyhs6BU59AFXMWxZdTxhUSm/fhVNeqOqRlEaj2wZVwwjBcseDgcEDs6ibCUCg03ChvoNSuX51Q/Hgp0bLYnT593ML5BCCn0
 w3UGHoWA
 kOxt5zEsTiD63H3m3BVidKSk17VWPXJiJzojqISimUk5l/aLzzu8ZyXW4cUFiKDXlTtCznytyNHIjLmnNCvXHAk3/GGVytFOMMzx0SCVQ+xTdaPkd2e8HwcDn9dx2n1+jFuRwDaadqLruKEBr+3tFzXvB50jFi1lYEb7I20inUlzznM8Gh2VBhKg78BpPMNnyXYXKFrJLnlgYrVoXLRUvIIV7ajIxjXbO1CJ6a4MrjO4PaZvgw7q1iQffLdmmWU0sovt8fkXX0cMq7p86ZmhPbP+HtRe4N39J/sl3zEncbz3nw33+9dAQC7+6vB0YSAbkaRANZoPB/ao/NKNOXbduad1b0tpZ+dvoP9nI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 01:12:11PM -0700, Suren Baghdasaryan wrote:
> On Thu, Sep 11, 2025 at 1:01 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Tue, Sep 09, 2025 at 04:34:09PM -0700, Suren Baghdasaryan wrote:
> > > When freeing "tail" pages of a non-compount high-order page, we properly
> > > subtract the allocation tag counters, however later when these pages are
> > > released, alloc_tag_sub() will issue warnings because tags for these pages
> > > are NULL.
> > > This issue was originally anticipated by Vlastimil in his review [1] and
> > > then recently reported by David.
> > > Prevent warnings by marking the tags empty.
> > >
> > > [1] https://lore.kernel.org/all/6db0f0c8-81cb-4d04-9560-ba73d63db4b8@suse.cz/
> > >
> > > Suggested-by: David Wang <00107082@163.com>
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > ---
> > >  mm/page_alloc.c | 9 ++++++++-
> > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index 1760346bbd24..d21a411e807e 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -5240,9 +5240,16 @@ static void ___free_pages(struct page *page, unsigned int order,
> > >               __free_frozen_pages(page, order, fpi_flags);
> > >       else if (!head) {
> > >               pgalloc_tag_sub_pages(tag, (1 << order) - 1);
> > > -             while (order-- > 0)
> > > +             while (order-- > 0) {
> > > +                     /*
> > > +                      * The "tail" pages of this non-compound high-order
> > > +                      * page will have no code tags, so to avoid warnings
> > > +                      * mark them as empty.
> > > +                      */
> > > +                     clear_page_tag_ref(page + (1 << order));
> >
> > Do we need something similar for the release_pages() code path or is it
> > happening already?
> 
> Pages released with release_pages() should have valid tags, so I
> expect no warnings.
> 

Oh so this is orthogonal to your first patch which is replacing
__free_page with release_pages(). This non-compound high-order page is
not an issue in the codepath vm_module_tags_populate(), correct?

