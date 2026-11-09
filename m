Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90DA0606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DaRj2WPE
Received: by kanga.kvack.org (Postfix)
	id 39D1E6B05B4; Mon,  9 Nov 2026 12:17:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375C36B05B5; Mon,  9 Nov 2026 12:17:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28C716B05B7; Mon,  9 Nov 2026 12:17:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 01E136B05B4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:17:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98547A0783
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:17:13 +0000 (UTC)
X-FDA: 85416236346.02.EAE2167
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 92986C0003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:17:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DaRj2WPE;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794244631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hikr3NdZOFIV97qGG552H/Op66kxtcpyq5g4qXWJP2g=;
	b=SDdTLm60rQ/6UJmFXfXBijyazh+ObNYqrmqim7VnaX3/WNaFNdJbP//9HYBBO1r0ztEMAl
	JbySn0F88ofqC3GdwG1O0fEmg7GuczCHgyCGLCKRFoolLLJKZR9clgYjLxcmu4D2/2XupW
	84vNFRBIVb3GjumhXTe+CggGLsrJ/Nw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794244631;
	b=gbAgTgy6uIGtngaMXhwPghFjyHwZYJVgovfLjWVSQ8ZqmZFetm4DYMXOqDoUu2HWVrhqUI
	S5WNS7uFMBNAZGnTyeJkTXUyTnxuilVw4GMI0TEqwNS0ulmLNDJVQK+eOOgwbjnIXx70H1
	ejj+xqe3rTrOTOpHU91lgAa8vCWgGwA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DaRj2WPE;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2237863454;
	Mon,  9 Nov 2026 17:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027C01F008A2;
	Mon,  9 Nov 2026 17:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794244630;
	bh=hikr3NdZOFIV97qGG552H/Op66kxtcpyq5g4qXWJP2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DaRj2WPEDX6GjzLecC2leOw1e9m5ocwvoJlDHsfSD2+u84H2UKxC21aUfKVinanoA
	 uQW5NTxN8UEZ90WGSWx9R087nby70dIuoPoBLg9mpNVkkamVbHKXfWe7di37Dm2/C9
	 v9pQqOLa9AUjFcTe5E/zSMnvaHYrwui+3kGUY0iUSKcShswHIo1l7cuTnbRxiGaRJy
	 aDeVeuEQr/N87OFQfEflecufBom5BvK3gw7c+ELFxq+0irHt8gxhFnp3hPLbazC0Zt
	 PbNMLHLIpZMSmTjiY9Nmno8m8B20uPFR9i+1im9j+uYe0vWGiWoD+lA7ezFu7WCi7j
	 s0pRktKCNBpZg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id CBB7E1980050;
	Mon,  9 Nov 2026 12:17:05 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 09 Nov 2026 12:17:08 -0500
X-ME-Sender: <xms:EQDyal_E3i3-JOyrXgAel3XmchxyRy6dJKHmn0RHn09DQU2qOx53hg>
    <xme:EQDyanWxemPQ8pkRZ3YIAgJXgCHOaoZyOyNuPrDU5zA2HaG5sWlsImUkQtTh6Bzdq
    K_oRDDnMt_Uvxe17C4ltpB7ARntMwEY0niGeDEOzmakFyjqhWkQTuCq>
X-ME-Received: <xmr:EQDyaqY-wXPnBLr-hCcdNW8K2xDebDgZ6hWdC4L97R30CLsRRXQaW2WkeWE>
X-ME-Proxy-Cause: dmFkZTElZQIW6SWcaw1iguscu2eY5QRPkCI+Zh7YF9LAIl6Q6UDTQUJwYU5pgh0mTZpmF5
    NxbI9uk32CzRVwmOylzVie+SWfDBrEYcRZ2p1j1AQ/MuQcSePoOec3dfy1ajnlOjYwO1hl
    Xbo5hNTGbMq0y+sDiK+aCg9uHGvxRy7N3Vq+rRj2PhA2LLezz9+bkjEBvK8ETAnlSc5TZR
    akrsVfCK2YDA101kRiLJ8f0MlU4hyylsv1fMuxTwHhQnwjjvVkpGCb5ees+82vtcTP3kO+
    WocAA+bVDijg7kHIjKZXEn2dV9MY1IjQ8Sm1IF6WYExkFItyIcDhe9h9bl4fPV9mWjJUnY
    DzCUMfJsGPdbDNKvpXAWZxzzlawuUdw6tZGAmgVqamoAzzCihQfFMmK/Zx8GOl68saGJIx
    6YlurgnnIRLoX1tHfkwEq8INt3eSuOAdIsI/iT3mhaKEXxVCKwX8NxZFuTwdXRxAaaZWJd
    Zo9dxHry3xUo1MsDZaFCB0yHpzXua+EIBPQ8zzN2OylaHG09yWtEzoLiEsGiz6/xOCNuqV
    5X6xF4+kz8U9F8mw5cDCkCSf+2seoPzNTK2phXDxtLlectgNneWxA6GmVuDi6QtYrci6H0
    UM1nBtG2OIZRUWr6iYNSsJ2OQk9fT/GmSreDs7XCkBonjX9IDZfzAYYaPTSQ
X-ME-Proxy: <xmx:EQDyahqdwG4SwoeTcbhVCpgeaBptrobVJSl3lwLMRXXr7y3al7i06A>
    <xmx:EQDyah74B5-hdy-JkxViNftHu2_nEgrX-ElvPBIxzsPbXPhDCq3aJA>
    <xmx:EQDyarUZh4JrJRfeBxK_Z2rVLGPtiG7EZ0I-MBGqFaJZ79tOt2Cu5g>
    <xmx:EQDyavvaWKiEUsAYuDF_q8xdT0s-OFkyeTI9FYlZDwxqsvbSi05JsQ>
    <xmx:EQDyagrbS8mKwXtaEumhHAY747RpoQ1KmHErQTqj7u4kdzLNTLdfiGFe>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Nov 2026 12:17:04 -0500 (EST)
Date: Mon, 9 Nov 2026 17:17:03 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 1/2] mm/memory: recheck PG_uptodate after
 ->page_mkwrite()
Message-ID: <avH3L4ZbQC6fIt5s@thinkstation>
References: <20261109120403.82361-1-kas@kernel.org>
 <20261109120403.82361-2-kas@kernel.org>
 <avHWhZzXE-ge6nU6@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avHWhZzXE-ge6nU6@gremlin>
X-Stat-Signature: rxssci8ktiuuy15xxyf5xh918p7stghr
X-Rspamd-Queue-Id: 92986C0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794244631-387841
X-HE-Meta: U2FsdGVkX19sY82bG022dkOLqY7nSaYn6akf7DmeY+y+NICsLnIpomyobj0wvNN9ps0//Vnq2P+zgzM2MXSY5FQUzuCG282suukUZvWJmoFBNNIRXEJuGMvWnYknPR66dwuexfpds2IZsrFnC+mcRGfhkPBCP3BtU7O4MLCGlHimJIMBV1dNS95H3xz007NiBfkGEAHtLZwrr1c1QPZ3Gf52jw+7x30dHHmC7Hc6dBwg7TZf2dXo74MslB+3wtJG3oTH5k59CDDLshTLe2/3qFOa9Gkwq64cgFY2exIzy479pg2TCysk4AMBES4RgeHEgU2TxgDSNnz8hmgxBCvQtmEzIBmru5+N8euTVYRT29JApUWJIwA41nWfZr1m3tMuOBG+59xDYM25YlFHCZ5dI18JFMTExbe7c5Km7IS9VSQ8DpZqTclX19Z2WB2iCzRm9HOWpvubhKX1N2CjPBN+OUmM7PxSj01nOuaUC4Faj5L+l4ulDp+hKt5uXpk+2aGZsRCcR8psXH1Fl4NMe6gzKsKzPiamwA3d02OpYUe3sl8ohuCpmj1u9xHOloQbnBWpYg24sacBQwPnsjQyDvG3Trj9i06pUQTNCMUMBtdGf5ZxopBe8khKGOXRSwNPE3/4727ZPpwzCNls8zDTXxqdyR3NdktWMGt5b1Hldz9RXv9Mjv2XkM0Fy3Ga9XrtdaBH3Lau5B9jeIYgRZgZ1UCHcBMKg2eKDI42hG+w2RoEN4qleKBsyC2lt1FVSgutA9TZW0Y9ZNG7QYCk3wbIoQXCjlhrxKqFLIzmo65X/rbH6/u2eFvKlBKNRZsAqsp2UUVipEhCBQsfU6N7ZV6g7LHOPXl6Av9p6kQoZx7vZxrxjgv23evQhBzdtwn2CUGYzG/7tzGgAH5vRTOjKkbjBc9gVhd4+e5tcsZfQJ2TmYUrOM3mX4FKBKCyMxY20GI5VcuwY5GkGeA+9iGMk9EaQ9C
 v0+0Sn4d
 z1gHs21ei9RMRZD6gaRhHmlyL7HfJ5zxLM2kI+DykqCyzC5+26csnXDYbVJcQfuwDhiJG5FXkzpIyn3udEigz6JrxFvgXRnxSsx5HA29DhegbU4/tie1QBdy8GsdFCMxxn9h/UsesQWRzurmdhLkcou0J6G/kNUZFLJVWFaYebZ0mLsYQoV6YsPKuDOJnlmf1gLTPt6oMKKc61wvYnZLcJpsUxX9SdwKAs4GWB6iOfsah85SsyqRi5mPaWnr3kBWpr6wIMl44RkugjWTgQLZJsXB1EeqgWYUcVQi/aiSuE2TH59hcSSJ+0Mjj6EvJHAWOfWH0EahnGq5a59JmFwO5ys4rHDH5TOfGc7vV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 04:11:40PM +0000, Lorenzo Stoakes (ARM) wrote:
> On Mon, Nov 09, 2026 at 12:04:01PM +0000, Kiryl Shutsemau (Meta) wrote:
> > do_shared_fault() unlocks the folio around ->page_mkwrite(). Writeback
> > can lock it in that window, fail, and clear PG_uptodate with the folio
> > left in the page cache. ecryptfs_writepages() does this when encryption
> > fails. filemap_page_mkwrite() relocks the folio and checks only
> > ->mapping, so the fault maps a folio that is not uptodate:
> >
> >     CPU0                            CPU1
> >     do_shared_fault()
> >       folio_unlock()
> >                                     ecryptfs_writepages()
> >                                       folio_clear_uptodate()
> >       filemap_page_mkwrite()
> >         folio_lock()
> >       finish_fault()
> >
> > The next read(2) or fault on the folio reads it in again from the file,
> > over anything stored through the mapping in the meantime. Those stores
> > are lost.
> >
> > Recheck PG_uptodate once ->page_mkwrite() returns with the folio locked,
> > and retry the fault if it is clear, the same way filemap_fault() retries
> > on a cached folio that lost PG_uptodate. Skip folios outside the page
> > cache: driver pages from ->fault() never get PG_uptodate and would
> > retry forever.
> >
> > The check stays out of do_page_mkwrite(): wp_page_shared() calls it on
> > a folio that is still mapped, and a retry there would fault on the same
> > PTE forever.
> >
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Closes: https://lore.kernel.org/sashiko-outbox-202966@kernel.org/
> 
> No Fixes? Sorry I may have missed context from v1 here :)

The window is from 2007, when __do_fault() started to drop the folio
lock around ->page_mkwrite():

Fixes: 6967614761fd ("ocfs2: release page lock before calling ->page_mkwrite")

Not sure how useful such Fixes is. It predates any possible stable tree.

> > ---
> >  mm/memory.c | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index fe72e66c9c2e..cc1d0b7d15c7 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5613,6 +5613,18 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
> >  	return VM_FAULT_OOM;
> >  }
> >
> > +/*
> > + * A page cache folio that is not uptodate holds data that was never read in
> > + * or cleared, and mapping it leaks stale memory to userspace.
> > + */
> > +static bool file_folio_not_uptodate(struct folio *folio)
> > +{
> > +	if (likely(folio_test_uptodate(folio)))
> > +		return false;
> > +	/* Driver pages from ->fault() never get PG_uptodate */
> 
> I guess you mean drivers that return non-page cache folios from ->fault()?

Yes. How about:

        /*
         * ->fault() can also return driver memory that is not in the page
         * cache. It never gets PG_uptodate.
         */

I would rather avoid "rmappable". These folios do get
folio_add_file_rmap_ptes() in set_pte_range(), and the word reads like
PG_large_rmappable. As you said, DAX never reaches the check, so "page
cache" is accurate.

> > +	return !folio_test_anon(folio) && folio->mapping;
> 
> Technically folio_test_anon() can never return true based on where this is
> called from right? Could this just be a:
> 
> 	VM_WARN_ON_ONCE(folio_test_anon(folio));
> 	/* ... comment */
> 	return folio->mapping;
> 
> Instead?

Right, all callers pass a file folio.

I will make it an assert, but at the top of the helper, so it checks
every call and not only the rare !uptodate one.

> > @@ -6163,6 +6175,16 @@ static vm_fault_t do_shared_fault(struct vm_fault *vmf)
> >  			folio_put(folio);
> >  			return tmp;
> >  		}
> > +
> > +		/*
> > +		 * The folio was unlocked for ->page_mkwrite(). If it lost
> > +		 * PG_uptodate meanwhile, retry the fault to read it in again.
> > +		 */
> > +		if (unlikely(file_folio_not_uptodate(folio))) {
> 
> As Pedro said, I think this unlikely() is probably unnecessary given the true
> return case is implicitly unlikely.

As I told Pedro, I prefer it at the call site. That is where the reader
needs to see that the retry is the rare path. But if you insist...

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

