Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4024DCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0F18E0020; Tue, 21 Oct 2025 08:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8128E0002; Tue, 21 Oct 2025 08:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DDEC8E0020; Tue, 21 Oct 2025 08:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DAF98E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:59:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECB35C04BD
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:05 +0000 (UTC)
X-FDA: 84022126650.22.F139F36
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf19.hostedemail.com (Postfix) with ESMTP id 03BBF1A0014
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="I u0Nbs2";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=tTzz138w;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BQz6WVGS/q7CoPgGFcDnRp4byTd9FtCIByaV/xWRBA=;
	b=fDpRkoDCTx0olgr08jNkF54c7bT/L/dclRVszrrpBrXBgBuCm3z81kkjlImWtLRx3uFYzK
	LdVTeuQON0kZOl4MzDqFAeIKr8jnIx65qILpwY6dJrSGg/BlzYJtZ+xlhvZDcI++Fu0MZs
	P+kwUFN2ulabJE1mc3BgUdQSIPuTroA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051544; a=rsa-sha256;
	cv=none;
	b=avWtolBD0Qvc0cy9U64xwAXSRiccamm9oqvr9X0gr92h7d8Sx9wmWSd5PxsHt7Nnn44AFL
	MD6tjgrJXMbt0ucLo3q1lL8+MK5kL0OR6XBII1A1qZv/WpQdZJr2MCfUCplprQFrx8deyr
	GuQlbuGrW3W8C+I7UbTrKpghOGj0xYU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="I u0Nbs2";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=tTzz138w;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 2FDFE1301A85;
	Tue, 21 Oct 2025 08:59:02 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 21 Oct 2025 08:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761051542; x=
	1761058742; bh=2BQz6WVGS/q7CoPgGFcDnRp4byTd9FtCIByaV/xWRBA=; b=I
	u0Nbs2jQ8scGOdlO5MSp5Iaw6ZkGgzZsk2Ni+x5jNebxkbpdRmP30ov3WZKA/6rK
	a+YVToRNRH0d7287O20I5yJ19rhG96cw3B+GHG0XDhLT5U1CTBkbyKlbzkPkU4E3
	kca9GkhSQtBbHmUfUgg4Nh0rCSZMzpBR/rPWO50BQIvc9kimdGSTEh+b+mnoqw/+
	8elYQQ5VyqEXK/C0rQjk/CUcLKGMDZvQNHs2YyqdgJQpz3YAshnJhsp/nOo/gL0B
	6ChuOJLdCrFCu4ViE/MB9C73fJeKaKC/QicqwanbhVaREZw3lFLeLFjWCFXnqH3j
	TsECokSk8qwRWeEbVjctQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761051542; x=1761058742; bh=2BQz6WVGS/q7CoPgGFcDnRp4byTd9FtCIBy
	aV/xWRBA=; b=tTzz138wLHFqxyRZlbaEaJIDtP3ldZ/m0Q9xHkLxSzS7xnc9oyc
	a12LRJV2/2if/+ATYSL+lEyeMvTgWZRyXB1qHW2RlQiUSM7W1rVBD1Mq4/n7xFMG
	a1FthGqplIWb967o3StanE0Lmo5J5SdYjy0NRBHkGddMHJ84Di8uHOM04q8Arq17
	K+2vTnHQVVsg6dYY3Ui24wNnln4cpZokOh0+cXX7fC33OE7m81HqyJzw2iaAVn+P
	NHAIMI02bdgISpVacCK396O9gSyY9SEYQ0tz/wdpJaN6+2767xkNr8GLqB+pAKOT
	UGsTsjeriBZcnNatsqe0+kejXyJMnL1pyZA==
X-ME-Sender: <xms:lIP3aAV2xwidlRlCX3eb0sVyC_sPV7X97w600lh_0B8xxrcDymAvog>
    <xme:lIP3aHcgHQJXzLkKegj1NF30F8IRwg2dKw14hPhMRBEdjOF_tjWSOCDVT1QSV8nRt
    7oL8sS2JcSnWPAYxcQIZmaYkK26qD2zYIuWDzWt7mc1LYUrKHRstCM>
X-ME-Received: <xmr:lIP3aFNcuRIysS19vtnzVN6wLnwjUfz6BB66ssoQ_y_erg0WidrD7qfxHr0yrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugedtjeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrd
    gtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:lIP3aBK3H8pJWAfW3LP7jxo-p1wDVSoWUnhDwmxUKzZ94ZtLRDK_Qw>
    <xmx:lIP3aIhRgIuEHHV34Q9Xol83t-JuXj4jxa_KgsDvS7X1Hz3JGlovIA>
    <xmx:lIP3aHfpqtd9apDpVpafNN0MSaljOxEVwWDlcmsvMwHA3PgaAwSPrQ>
    <xmx:lIP3aI6IaZtHA95MdfMHNCGdQmCbj5gfAKpBBlPk0alqG1nhs6JG9Q>
    <xmx:loP3aCEqqnEHMFF7p32xvhRuxRxEn60rpIXeqa2xBzSxIMGJgjm3j82M>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Oct 2025 08:58:59 -0400 (EDT)
Date: Tue, 21 Oct 2025 13:58:57 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/truncate: Unmap large folio on split failure
Message-ID: <imqowmshevu7egxfbc6kglh7o7sedy5s7xl4qw24gc5iyrbrat@67wxpi36t4i7>
References: <20251021063509.1101728-1-kirill@shutemov.name>
 <20251021063509.1101728-2-kirill@shutemov.name>
 <fb51f195-b4d1-4bf4-84cf-87d433f8ac86@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb51f195-b4d1-4bf4-84cf-87d433f8ac86@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 03BBF1A0014
X-Rspamd-Server: rspam02
X-Stat-Signature: aenktazhpbqa69tp6yrgsm6m46exsqk9
X-HE-Tag: 1761051543-358804
X-HE-Meta: U2FsdGVkX19p6mzEdNy3P7zEJhmsqebFcnJpt7Jp9CC96aHrzSHjWYjYIhaiYYB4hdQDSzwrdvSAAPlrsUgsQbt2aozOMmBmI4lqT1rm+yrD4rCDfwwGXDOCvKnWqB2uJ3QfOKeoUqKt10EzJZsE7R6R4D24H2TxlahQd3DaLJBGbh/6jWcKaiziyWNiJdWyi91wwwueLG/UKvPHJtzVA5Fuzzt0P1dnZ6HYydbge8NkVQt6T7BhAX1LgO7JkoAimkuolfGs+Wwy+sVonXSGs6g9VtSZ6vYKzV47GfRsT3n2YIyXxYz1PhCk5fJ1jAgm3yQf5J1UaxS1Px/VDJPN92t2LFwbdAtMKwJYybO0IAtfb85NMxqTvxYuUk3e8M3ZehY24zI5kapeMQATtRb8iJaH8TfK8Wp0UBu2QKdKr6oM5W2brzRPAFtN3LGrvcL/y2DeVwuWGNAyxhqFlxJUCGoeFc2VeafBOhssIo1gJRaYaiIBpDzRP+3AsWGpWC/plbN1RXgIMGW3KayEPBfhuVruFYger0Kq6oeAlOtnp099I0nEZ6FzzXiG85NVO79JG4LFVQlRa8vpr6lyeUxQhTpL9qmVc8Ybuzn8TQzAD5O+zvBYFYTEJqrIOWe8lIvzooVg+OzmbgEhftx7N0OHOMIxdJko46dT750f/nKXjtf9VWbcuUwSQjLhfhbMpKjNw7+LfpzR0Gv8tDFkL9QTcL0xVNz82GVxq9Z0a4B3+xohIUBMJDwUqy2yUpPPlOevGbTZW3oAo6V//IramTrvPMX2LST+YV4kHGD9dIQK5tL6weuzHUthhZvIBoVxy7lC2cEO+fDtd5CM7mFI00XmMBMrIV0SW8IUsag+w3BWIytGi6zb1atxt5c75DlY6gUOOfvAGlOPJXAZgqdc/h0eTqh7xnCP0rXw+ZEh8fflt5ljhLPTFrZi/7uGLpBoXL34IJsijVXXdRMk0xTOg8b
 1zJ6eejK
 S3r9jWPdZBxKjfjqNtv9bBNWXshHA8Hq2LtqlOxg8Zp0V89TUDnVGHbaznCfgpi3JfzX8AdeIy1+5Rom/At+5MoznGZhDAq4cY3tRQkuWvG7fQE4xQvYCYD0B7L1azWLQYDiNEZu5yvhIwLs0aZfbqHvgcGzymwiiu4Xqt1rsB+RGQK7/s7X3hB5qDm3PwAxdzIL5NZzCCKmBZEp4pNYMIgWxczJ7Ty4G6w3JRsBQOzhwFH3lJFf+7kbrr/hJ3Ym8oQlXV2QA5tNAvJX/t0DOUkhq3E5Mww6KmG/VaXWlfM9GJ15jaulyWghXqxMp/dW47nBU5ZhDCzw2VcyOHUj3Eyp4ylJXypmimyfDVZGC+nz+B9NJwe0ve0cCqYpQQlmTjJZ7qMz6n/7v/0z/glG3qX3m87fr+KN+SzPnnuE+AZGCoykSGD5dEw+AZtbeRgfkMibeVYYHBRhixvLVBcbMANin5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 02:33:39PM +0200, David Hildenbrand wrote:
> On 21.10.25 08:35, Kiryl Shutsemau wrote:
> > From: Kiryl Shutsemau <kas@kernel.org>
> > 
> > Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> > supposed to generate SIGBUS.
> > 
> > This behavior might not be respected on truncation.
> > 
> > During truncation, the kernel splits a large folio in order to reclaim
> > memory. As a side effect, it unmaps the folio and destroys PMD mappings
> > of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
> > are preserved.
> > 
> > However, if the split fails, PMD mappings are preserved and the user
> > will not receive SIGBUS on any accesses within the PMD.
> > 
> > Unmap the folio on split failure. It will lead to refault as PTEs and
> > preserve SIGBUS semantics.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> >   mm/truncate.c | 29 ++++++++++++++++++++++++++---
> >   1 file changed, 26 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/truncate.c b/mm/truncate.c
> > index 91eb92a5ce4f..cdb698b5f7fa 100644
> > --- a/mm/truncate.c
> > +++ b/mm/truncate.c
> > @@ -177,6 +177,28 @@ int truncate_inode_folio(struct address_space *mapping, struct folio *folio)
> >   	return 0;
> >   }
> > +static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at)
> > +{
> > +	enum ttu_flags ttu_flags =
> > +		TTU_RMAP_LOCKED |
> > +		TTU_SYNC |
> > +		TTU_BATCH_FLUSH |
> 
> I recall that this flag interacts with try_to_unmap_flush() /
> try_to_unmap_flush_dirty().
> 
> See unmap_folio() as one example.
> 
> If so, aren't we missing such a call or is the flush implied already
> somehow?

My bad. TTU_RMAP_LOCKED also should not be there.

Will fix.

> > +		TTU_SPLIT_HUGE_PMD |
> > +		TTU_IGNORE_MLOCK;
> > +	int ret;
> > +
> > +	ret = try_folio_split(folio, split_at, NULL);
> > +
> > +	/*
> > +	 * If the split fails, unmap the folio, so it will be refaulted
> > +	 * with PTEs to respect SIGBUS semantics.
> > +	 */
> > +	if (ret)
> > +		try_to_unmap(folio, ttu_flags);
> 
> Just wondering: do we want to check whether the folio is now actually
> completely unmapped through !folio_mapped() and try to handle if it isn't
> (maybe just warn? Don't know)
> 
> We usually check after try_to_unmap() whether we actually found all mappings
> (see unmap_poisoned_folio()). I recall some corner cases where unmapping
> could fail, but I don't remember whether that's specific to anonymous pages
> only.

I will add WARN_ON(folio_mapped(folio)).

> 
> > +
> > +	return ret;
> > +}
> > +
> >   /*
> >    * Handle partial folios.  The folio may be entirely within the
> >    * range if a split has raced with us.  If not, we zero the part of the
> > @@ -224,7 +246,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
> >   		return true;
> >   	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
> > -	if (!try_folio_split(folio, split_at, NULL)) {
> > +	if (!try_folio_split_or_unmap(folio, split_at)) {
> >   		/*
> >   		 * try to split at offset + length to make sure folios within
> >   		 * the range can be dropped, especially to avoid memory waste
> > @@ -249,12 +271,13 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
> >   			goto out;
> >   		/*
> > +		 * Split the folio.
> 
> I'd drop that. It's not particularly helpful given that we call
> try_folio_split_or_unmap() and mention further above "try to split at
> offset".

Okay.

> Nothing else jumped at me!

Thanks for the review!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

