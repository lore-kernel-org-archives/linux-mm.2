Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12C59CD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 01:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D296B02D7; Fri,  8 May 2026 20:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE276B02D9; Fri,  8 May 2026 20:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612F36B02DA; Fri,  8 May 2026 20:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5349A6B02D7
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:59:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D662416043C
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:59:58 +0000 (UTC)
X-FDA: 84746074476.25.38F36FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 395E2180007
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:59:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N2gUWm2L;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778288397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6A0+xv98jzaDdoEYdnQSOQqvp/m1veV9oIwFI52aZOQ=;
	b=FwLldcz/A/PKPQEMk48vNUc0at+mN6sL2PtbHiK9kfaVuF5PUEmqI+Yo74qSPxVLzXXmdK
	qBL0rra7Qte/aJfxVyaGzCvmxLaucty72CphgtK5qVTILukpDOyPgmCAiACk1sGZshk7mq
	mF03hF1Z2eq1htFTJXxMeh9KxrR16Xw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N2gUWm2L;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778288397; a=rsa-sha256;
	cv=none;
	b=6gW/0fWXX4JQ8lNFohfn1Utvyel8PNmpDsdJQFeamwO7hQZc8FMIgjyNldA64Wqrf+gQJH
	fs2kviVjJARCl1HYxLeQTlgMYKg8KukqwLXVVLZRdd6I/5hX8mXvUUyOlrGeV2YGnQGHL1
	htGo5sd+mGx9HWoHG6vxUQhw4I2X4iY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 978056024D;
	Sat,  9 May 2026 00:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4ABCC2BCB0;
	Sat,  9 May 2026 00:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778288396;
	bh=yjiFUK+n//LLFgj6TBHhXK7CdomWPvW+obF90AU1dhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2gUWm2L9CLQRjAIk645TDmEFUXJRgZgVjTW7tZGi3+hadFP0TC+L20XOIhf17WoA
	 l6myHQhkHNW4fbmZBZh8WdDLUOJdaslYfXQkVFrrZg8b4ug2SHr2KVNdRvpzKRplCt
	 8TKT8o1NlM6d4bAtqCjWG0cTHTFCbHILs+NWgaCY5Ma+dzlGoWOaIsRo+DXBjWALKe
	 YRH4F6ozZlbYDffMBPkk3cr+H6gGOJDsTc7VBynl1eEjN6/JZhaSkAUpmjEFptDUym
	 f3wVQIMVU7TLtyiHDFQDd5OVeJJdW38HXBQwoXGvtwj37X5F4PtFQYB9zMZcKvUVb0
	 1a4CwcdGUBWEg==
From: SeongJae Park <sj@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: SeongJae Park <sj@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org,
	Andrew Ballance <andrewjballance@gmail.com>,
	maple-tree@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] maple_tree: document that "last" in mtree_insert_range() is inclusive
Date: Fri,  8 May 2026 17:59:46 -0700
Message-ID: <20260509005947.84550-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <d5qyczrzz7yzxpveshdbm2u3fl7p3db73iczjydbm5aghkjkno@t5jf4hgkzpqk>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 395E2180007
X-Rspamd-Server: rspam06
X-Stat-Signature: 57zq4mwoinqxmd6d3wzcb8chmjhik5oj
X-HE-Tag: 1778288397-248224
X-HE-Meta: U2FsdGVkX1+OwX/Em52toeiUhQWnuI4sa3b369nYJWg+4Tl1xvGYHXViW5pNK4rGeNTgE0qvwVJHDxUXNf1zg6Lcc4JujzZitEnwpCLRGzhJkrI90t3YfycU3ZfAP94z/7mVrXlddkw6RPk3YvRFHRtTVL7KuFJvZ0EujMeaVKMDEbCfyvVP2bY5NKHAFFzKRCdC3yP8HtdfNLQM+gTY6kdsN/2/qsRqnukJEqydMwjdj9+oVMVFAvdgWwXfeuTLw474wk546UNJtHc1x/EaMRxa1daop4MEWbwRgLZTi3qB5i62aWTZwyc/Utric0ubQG++Z4Wq0DMHXi5WKFBdSIN4KUzUkhgDXLzgFz6YzI2XBzDh6ATFk0IkQxR7zkunCpEzm9j6I4ixMk6x7TyVozvK4Fq+4Srd4kLZKQXImGYVn6a5QWVKAJQsoT7pUiJPSqwtQiwDuoH3cDsfHCVLbyPPh0Nf+tWSFvNpoGhSxIbCL+oplA00NqMyu+W/GcAqk2y69pDUKS2BXLGN3uGaL5NdUgZH0ZYilgI/pZ1xVqB5GdG7QhUqjza0rM21OmGh/G4LWUSZd5sTuuNb7xPhsSyYlxdyTg9RVa33kE4shjnKHwZOn+7CQ7SFD/BezpAPYv/cxrPOjM4eMG1q8ec9K2BJJSjUKb1PY2Y/FrDe7HqUmDpEO21TVPGUsSZ9kGGdtbGQMJum3tH9VXjrzU+60G2KDiwZcIFGcnFtTR6eYWq9ohwD4VGRGJrOqR6oQTWPf4aWDpafgYsvJz/+j75y+/CxeD3tKPD6vGolC6QNuxXJttwrUGA7ndpfroPJCV+pOzdqniDJ/ID1dFll+NpqA42/u0osSsZATBL3a/SXh+F40X5gXg+RXx4JfNvw6vV/qZ9VsK/8ej6qdlLwK+QzIMbCaEsgT/ww7tH/nI8SP6eP6xsxU6rm1yiefPtvxhGFkN+QVXUncDVS2GH1KOq
 R/zmoTkh
 VwUrZkcttUMyj2DOH+oGuc2P9C2nDRgbQLYJ7FTdP4a27yqzDPKIXgCTpkGo5AvWCp+NjCd74tHYLSbNAivRVJyVtkonS6upwBoYPqUGKD4Hf0nY0Pdsc2VVZxbFnbpzHF+0QxWMgbtD68oIrVV1ahqA3GrLgNqsAqaOl8Jq44BtfpzFM5R1K3FgrInIzwZKK4WK6Dt0cnZ5UvV76QrLmSAIF7zZw0ozTrIdgFFXt+5KxIt3qZjorwoPO/lUXy/T62pk6889yBfRDn5dQfhbbpRpVdq/aueerMGivs5iaC5I1C9OtuMl3OGukfyQqD/DwlLeLvHfOom2mssz9iMbSXiH3t8ZFDmv3YNBOoQ7h1X6Uf/iiC72I/+QWvFqYL0c4IHlrpENZQ1dLI64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 8 May 2026 22:51:51 +0200 "Liam R. Howlett" <liam@infradead.org> wrote:

> On 26/05/07 06:44AM, Alice Ryhl wrote:
> > On Wed, May 06, 2026 at 10:52:18AM -0400, Steven Rostedt wrote:
> > > From: Steven Rostedt <rostedt@goodmis.org>
> > > 
> > > The kernel doc of mtree_insert_range() does not state if the address
> > > represented by the "last" parameter is inclusive or exclusive. This can
> > > lead to bugs by code that assumes it is exclusive. Explicitly state that
> > > the parameter is inclusive, and add '[' and ']' around the word "end" to
> > > also stress this point.
> > > 
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> > 
> > >  lib/maple_tree.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> > > index 60ae5e6fc1ee..dc9591218446 100644
> > > --- a/lib/maple_tree.c
> > > +++ b/lib/maple_tree.c
> > > @@ -5730,10 +5730,12 @@ EXPORT_SYMBOL(mtree_store);
> > >   * mtree_insert_range() - Insert an entry at a given range if there is no value.
> > >   * @mt: The maple tree
> > >   * @first: The start of the range
> > > - * @last: The end of the range
> > > + * @last: The [end] of the range
> > >   * @entry: The entry to store
> > >   * @gfp: The GFP_FLAGS to use for allocations.
> > >   *
> > > + * Note that @last is inclusive. That is, @last = @first + length - 1;
> > 
> > How about writing it like this?
> > 
> > * @first: The start of the range
> > * @last: The end of the range (inclusive)
> 
> 
> I like this.

+1.  I'm also wondering if it make sense to add '(inclusive)' for 'first', too.

> 
> I think the range should be identified in the initial statement.
> Something like this:
> 
> mtree_insert_range() - Insert an entry from [first, last] if there isn't
> an entry within that range.

+1.


Thanks,
SJ

[...]

