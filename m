Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518D6CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 09:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1A38E000F; Mon, 22 Sep 2025 05:51:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5AEF8E0001; Mon, 22 Sep 2025 05:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9493F8E000F; Mon, 22 Sep 2025 05:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E1B98E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:51:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 395311DFA31
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:51:43 +0000 (UTC)
X-FDA: 83916419286.03.58882E2
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3F731180004
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:51:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="O KwHWU7";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=hy6krAsS;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758534701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdMGCj84qIt/JChf77XrYGp40awzcdDLugRw8vVBx3I=;
	b=eCZmNDFPm5WXF2Uj/e0clDrQHywPKwBTu+sPrHvvtnHjaO3jx2QfPLtEtEPu2hlpt4agqo
	IGqpazVECUL6Orjfye4bNl1V+bbpN4reiOgMebpVFsNBT+IbqzSDoCPMxDiSXMJInX6GXr
	ejZygA1beee0w/vkjfiVO00CBdYHr+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758534701; a=rsa-sha256;
	cv=none;
	b=Z++PNctoiZJYIGUfw2Rv6Dqp6SX1njHeE6G+IToWrXy+UsXNoMJ8H2nUjeifwvrcYIvPKO
	pBhuqrx5+lDnIWN6gVBuxM+dfe6TPQlYl7kUg2eDXT0wIWh2N3WNPQdts9Am5D+eu7A386
	eUq9MglDSr1PF+Cm/exq7mIXbVZ2lsU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="O KwHWU7";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=hy6krAsS;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.stl.internal (Postfix) with ESMTP id 7BA5E1300084;
	Mon, 22 Sep 2025 05:51:39 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 22 Sep 2025 05:51:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758534699; x=
	1758541899; bh=SdMGCj84qIt/JChf77XrYGp40awzcdDLugRw8vVBx3I=; b=O
	KwHWU7Yv3q4NhrBceIs+ljHL9m9t5pYdT8oJ2owXs4HM3Rcn8PoyU8w0Bw+1OlLn
	mcKEC/nWCmE1OJf8YUAxwuPMc2zIGuUHY3TNLoIogSPxfb9bSwvb8+b6mhQD8epi
	xB2fncLIOGHmlUh+bQj2zC+4dAys7ij8N4Dz0hHgPcqxaInr4MzqLAaQf3kRZKHm
	BDSE9h1yKsOZU8c9Sn+hOSZ7OF3tcUtnLkVxwJ4qzRCCWA1OvxNhgKWvJHCK7HwM
	UEho5roG7S7Hjb177+mVZq5jw1X2Hc6QdwvtLXdm90GnmlpE0si/4ck5Xc7zL6Ny
	daeE3zuolTXIgQvsqVXiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758534699; x=1758541899; bh=SdMGCj84qIt/JChf77XrYGp40awzcdDLugR
	w8vVBx3I=; b=hy6krAsSQz+QbWjUjh2u+fBZKCCKZXJoufUwakmN1qHpqr7HnsL
	URGGBNRCis7Blg/VOM4Ik6npB7lTxPL9/vpbjMZ8ueDhGjzNyAjRQbuDPqWm9SWn
	wjUYs0KjUfA1ZBBSzZMzTHeLbahlkZneqHxYu9WvIPWydyVEqPvSfS6KJdFxHTXE
	QqlYcOcksyVwH5/16qtvQ1m4BJLRT7QdIG3vD8KTK4vVrEtqw0BkCR2KSp0etb8j
	++q+AfsBG85dcEjj8W0Qyf+d8qabUbcnnOfQkS+TL2LT2e/5SWCckU6S5S8JzKL4
	5O7XSPOeTkJ0th+nxAeIESgtO23/V5wMD8Q==
X-ME-Sender: <xms:KRzRaEm5MjBNqrH-4I75aOOGk1lVDVVoIVnNI8itTy9dLSl7cY3ARg>
    <xme:KRzRaOoLlQQGIuHDj3r9qUcOyUDuto1tcGm9yMpGEt4mdn-nHnjYod9F3wSZyfo1e
    eS1tt5SF9ZlMGRZoVI>
X-ME-Received: <xmr:KRzRaA4bCpaabTvh5_m4ipP88LgOxGW6uMb-5DINMQIuebdHXZzYf4_vdC8DDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdehjeehgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehshhgrkhgvvghlrdgsuhhttheslh
    hinhhugidruggvvhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhi
    ohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpth
    htohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhn
    fhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghsse
    horhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggt
    lhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:KRzRaALRaxUp4xgtzHmSZaoU8wLIl3No_gCku-i-PryXC2p8phYJSw>
    <xmx:KRzRaMlKF0rngRFI45tr-db7KlFX6tamt2928VGI67stg2z26a9erg>
    <xmx:KRzRaH-4RcPROMMtruqVE_MyiZLdfmZ1qEe3b5xvVHI_cErHNQQaLA>
    <xmx:KRzRaD7E2rxEce7e0tXPKoNwnyz_gdiwgFeKM1iHkFDiTbV0pKAkNw>
    <xmx:KxzRaAuGGx0mjKDpCyfLpwsUIqAAUgs-iGY2dLFxjxH3XijEEf565K8F>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Sep 2025 05:51:37 -0400 (EDT)
Date: Mon, 22 Sep 2025 10:51:35 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/5] mm/rmap: mlock large folios in try_to_unmap_one()
Message-ID: <pdorb325r7fatuclbaw4zriieve4tphlrox6w36fo4mlmzgcx7@kdsf4pwqs2wy>
References: <20250919124036.455709-1-kirill@shutemov.name>
 <20250919124036.455709-4-kirill@shutemov.name>
 <27wxlfhnkxaat57lzyzlpo66vse3jjhp422ziswbl4oyjnamif@2jx25dwgkame>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27wxlfhnkxaat57lzyzlpo66vse3jjhp422ziswbl4oyjnamif@2jx25dwgkame>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3F731180004
X-Stat-Signature: df3yrsjmhabcx7wpk4s9qodxr8qp3s6z
X-Rspam-User: 
X-HE-Tag: 1758534701-692052
X-HE-Meta: U2FsdGVkX183N/9mD5GuIk94RFZl9XhEHBdI8VorFg7nVfhFryRu3zivMhxlxGn4NqF5zX9IHz7z//zVudmJVKvt/fnZLIgRmqkQuI/CQgGAkes/4Id0fwYxGnwO1txV2qZsL8SD9Rml3SVtB3qdm+9zf4KiRiidqjygJKexUfTcnZSMHc9XfFe0hKh66KMSNPCCNycJl0UojCCGZi2e9a3H2RzF4/eyzZRS644zmzxlhekSKKDM8IMdtBuKDX4IEY2vS124hwM+ZbeWjKNLbEgfX4i0KXwMSt27Q+L6XGslBGKPn2DsYegqBc+80vbRppo5JWm/0U8o6Kj7NIhlQ87s9uvHaAH3A6DNBk4Hw+tCQfx8C9fYIqNAUjrOQ9IdP3Er9wDcAP9DmL3Hyszui3TzddTaISNb8opw9lsuXmxlYdOq2KoHeDDm4EfruL24l7ZK4ugUY2tNtzBJguUbH1RVt35fOTbKIzCAd5B9usQAScB5/YdRkVlN/qAM+VOXlrYcvIgbKLKPSDhB8LDjBYTLD7GcJhGAdz4YS0LFhG86s5l5VRoUrS/gJwmzpBxRUKDgURo6GWZ6NQpoCM7U4tFEFqBcdQMMXFPxSh67AXqONozVqS9j11TDc8mJM8Cf3yETQ/6FrDCJslCcd5KJUrlIyZpzDf8yKQXKM1eKc4eERnqn91iriOq3pBSnGwEQ38lFApCYpOOqHpoY+R3hjRyUu5Md1Cc+r2N8U/o//yZgvbc+V/qAnb6JDdzRd1seEhaGrlvlR2K64gdyLeoUnE4QkQs8iw9Fecgt/Ps5b9BztlslblWX8LJg5l59Wg/Xe8W7Yz1fmEVIYeMvVwU9nNTuoX3SwOeERQPIFKK2CmDtjuz39IbRK0iOdDDsAr1N8UxgdGcOSZVplxiTvJhpXlTVEddv8JDbxMmngFAqMb2YAIyljuJddt6JMTAS5ILA8kcp/SvZm9kj0WF8WbK
 ggKcR3Gi
 Ae0xn8tRF9V+jECEQlmkcPaii6rieIVCL0kp5oJTA0y+nOGKvuFCC21fqO2cSfQANaGN4vHw7AKGRpQPtbNF8hDwfm2e+Hu8SxdxPmNufoly0rv6V+w0CJz1UhzURNOmzOKOGxkRZNDYPR3ryZLjfgdLhevD4Iw4HiFUextWPhDHSnMmmQv7SSOdSE9pBPaza+zzWfnUbhS4M82v5GhAz7gWeoZ2DgC/PtXTzj2hs955IqZxrqGMcKaiCwP4Iw5ww0m9QXYoHUE0e16+ngfxtcCi2kn1MjV5Qy6W8riHAqFXhgo+tMjIeALK0lkPENWQwnXc4qEjZf4I125yMozS7t4R25ZfMG2la+msdGA89lQ8pgBRobCEbApvcQw7K3XhJJvvEuuCYWn3kaNrLaGcRVptlUkZ9r1Gh0c0Cp3+43qhNjWfFM8V1tuR4JexhA2I1lCV0peWU89pedDjHh6HkMjTNApkx/P5GOhJy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 02:27:40PM -0700, Shakeel Butt wrote:
> On Fri, Sep 19, 2025 at 01:40:34PM +0100, Kiryl Shutsemau wrote:
> > From: Kiryl Shutsemau <kas@kernel.org>
> > 
> > Currently, try_to_unmap_once() only tries to mlock small folios.
> > 
> > Use logic similar to folio_referenced_one() to mlock large folios:
> > only do this for fully mapped folios and under page table lock that
> > protects all page table entries.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> >  mm/rmap.c | 23 ++++++++++++++++++++---
> >  1 file changed, 20 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 3d0235f332de..482e6504fa88 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -1870,6 +1870,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> >  	unsigned long nr_pages = 1, end_addr;
> >  	unsigned long pfn;
> >  	unsigned long hsz = 0;
> > +	int ptes = 0;
> >  
> >  	/*
> >  	 * When racing against e.g. zap_pte_range() on another cpu,
> > @@ -1910,10 +1911,26 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> >  		 */
> >  		if (!(flags & TTU_IGNORE_MLOCK) &&
> >  		    (vma->vm_flags & VM_LOCKED)) {
> > +			ptes++;
> > +			ret = false;
> > +
> > +			/* Only mlock fully mapped pages */
> > +			if (pvmw.pte && ptes != pvmw.nr_pages)
> > +				continue;
> > +
> > +			/*
> > +			 * All PTEs must be protected by page table lock in
> > +			 * order to mlock the page.
> > +			 *
> > +			 * If page table boundary has been cross, current ptl
> > +			 * only protect part of ptes.
> > +			 */
> > +			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
> > +				goto walk_done;
> 
> Should it be goto walk_abort?

I already have to set ret to false above to make it work for partially
mapped large folios. So walk_done is enough here.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

