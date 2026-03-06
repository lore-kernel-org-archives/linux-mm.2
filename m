Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1719FCB61C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B57A6B0095; Fri,  6 Mar 2026 11:28:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6629B6B009D; Fri,  6 Mar 2026 11:28:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58FFA6B009E; Fri,  6 Mar 2026 11:28:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 47CE16B0095
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:28:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06E0CC235A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:28:27 +0000 (UTC)
X-FDA: 84516171054.23.C398E5D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0FB6212000C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:28:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CFJJubN2;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772814505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IcWzAUhUQsNspCv6GqG4MtP9jZ6m38H8CKI6GAuV6PQ=;
	b=G6Ea3YH4YwSsJ+9dz/vI19MQy0bPx5w/aqYHkOBz0hJJP9Frr5Rab/RZVb4Xxhz4j14+L2
	XdC1ujxvxqp84hMQhQjfEL1xiJ5/XlJIT2ufmvg4JpkJpnl3431NQ/WIuryfKGJ+5NEtoP
	yb24vtccZdmKtCvf1ghsDckNfpCgsoo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CFJJubN2;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772814505; a=rsa-sha256;
	cv=none;
	b=oSG+LIr+JvN73yhiBwGDM3HJfuRUzeYkIVlmnYkSeHlU094bYlu0essWFRNgoJzkaIl4zr
	v3amDjqj1mx6iKHftx79dSwycatvLCo+ncbFwcqVdTVEOcQU4s6yk6EJZUER9cjFw90Oxa
	gPfIzHl99PJ36c3HuO2qOC4wpNtZaKI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IcWzAUhUQsNspCv6GqG4MtP9jZ6m38H8CKI6GAuV6PQ=; b=CFJJubN2q+3CnInjWYPhV8zU28
	mPjm1wr/eqieb7/M3uozkIsZRuMXZJ9JNU78GCm5o6ssr/BFYYP1TW9LWNIO4wOiWbxQlEXwZ2n2t
	WA6wGJ7RDsGhz8A36cS8svTVNiWOGMetYU/ZbSSOXMbr6b4AaaPp4phkxxn5PeHG4F61wI2znjgGU
	r+l1fjV3WuBSfKJ/PexXiufIYHLJDXQjvs1j/yl1K3hugCpX5Kx2CZKONDqlUkKlXzwAHqJ4iM8EZ
	H59qpDHTn2g46K5bxD9n/mbH/DvhOvsG7RHpNJhbrVfgRiZuaoqAfqY1S1CxIDvdqcx+LYNizGAlU
	yDjezxzg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vyY2F-0000000GzX5-2dMe;
	Fri, 06 Mar 2026 16:28:19 +0000
Date: Fri, 6 Mar 2026 16:28:19 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Chris J Arges <carges@cloudflare.com>, akpm@linux-foundation.org,
	william.kucharski@oracle.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@cloudflare.com
Subject: Re: [PATCH RFC 1/1] mm/filemap: handle large folio split race in
 page cache lookups
Message-ID: <aasAo8qRCV9XSuax@casper.infradead.org>
References: <20260305183438.1062312-1-carges@cloudflare.com>
 <20260305183438.1062312-2-carges@cloudflare.com>
 <aanYdvdJVG6f5WL2@casper.infradead.org>
 <aarVMrFptdXhHsX1@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aarVMrFptdXhHsX1@thinkstation>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0FB6212000C
X-Stat-Signature: 5xgrtyxdn5tuikdu6gs8i61gcpg3ungc
X-Rspam-User: 
X-HE-Tag: 1772814504-286137
X-HE-Meta: U2FsdGVkX1/oyBJ/4+sLSFHbsu7v50X1XsvavXJA+Uldb64Tx2VAURUbVr0lyVAyA0Kuqt3YKWziGu90wcwCN4ndS2r5o/dtKuGQro61I9bmPg/fm6zhhDTflX/swcQeKhaucE4/I3BAIWdViWeUqMEqFZm8tQkv46GjdEiCsBRghVyROYPGIiLUkWS10DrDyRMxo3e54Gzuay3isuu5uuJQsFGEw4sU4wrHRTt13WzV2+g9ndWBiX4LCF/Sgt1kMS1gLjVACRcVpZC3q9BnC7T5O2wbr7A8Bz4826Qgk3OCiZDHPEn8EbAFVaUNJniN13kOROfnjgXnC8qQ8s4yqGDemTgOl/U5uhkApOqktKMSE+tYHTfXileChix5ZDGFVO3MhovaPgWiRyIu1VnketZyQijbl2Q9nrWEiOgbM2NYUx5s+MdS5v85CzwYuj7eyP5gTOETcm8BRDx4xTTIpOjO2+ocABkDsiNBQsfpAarSmcMlD6UfLtsBD+/V/oUYwJOqv83GrYrJinJbIfsySEjxtYz840pblw2ANLodZxwKgzxxhLsSfCzTRhV/ZXHBRd/gyk7RkN5v/fknExvpiLQn4eeYjcnLQhyO9FpDS/7enpqY5HIrRT+J/+OP+OI9N6An5EdRS8zlXpqnalpvfI+r4z/u43bwjlyXKiQrPIVwHyENSmy7OnwSeuToaoB0cKMz9BGRlbfTDroVxSF/9s6Zk7o+q/aYc8AgMOrPVTB/ubOeqzPFJBocozaeSQANjtPli+rHYPkY78KVdMA11aLKtryNPqPtq75Q6TJ8befhwwL6yBVZKKbWrykdgOaacNxE8+c9mB6L9fDR8GjmxodZaEeCbGADZQ5anp2+BWjmzXWqP3m5C9qWeKKHXmglYJALPLPuwyP8gJgsAOmr0ZGUZIdbZ7KAPPlQtwbBzFIoy8Javsl9Z5dnwUxw169FCcv2hk/hfwLTZ6wMLRU
 pzYYI1P2
 SKcKRAnvX8lqP8hHim1zdAKKgystHV7E0CR3Bvv9u3pSLyykH8zihtOsusc31zpa0rlAo2SJFPMQd02Ry6Ijfpjgc40TXg0CuulyiFny/bXnfwYVcgT1Hmcpv13267pBArhL82tXt3eNVP8T1mGNTNW3lZPQ3b9ra81JC2sZgUGwZvPz3fWMRHPT+r4AG+rPGIT4sf2I8+i+AylIcKXFW0wlj+1q8X5PCV2XVLPGXR0USwDo5clKxrE5hhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 02:13:26PM +0000, Kiryl Shutsemau wrote:
> On Thu, Mar 05, 2026 at 07:24:38PM +0000, Matthew Wilcox wrote:
> > folio_split() needs to be sure that it's the only one holding a reference
> > to the folio.  To that end, it calculates the expected refcount of the
> > folio, and freezes it (sets the refcount to 0 if the refcount is the
> > expected value).  Once filemap_get_entry() has incremented the refcount,
> > freezing will fail.
> > 
> > But of course, we can race.  filemap_get_entry() can load a folio first,
> > the entire folio_split can happen, then it calls folio_try_get() and
> > succeeds, but it no longer covers the index we were looking for.  That's
> > what the xas_reload() is trying to prevent -- if the index is for a
> > folio which has changed, then the xas_reload() should come back with a
> > different folio and we goto repeat.
> > 
> > So how did we get through this with a reference to the wrong folio?
> 
> What would xas_reload() return if we raced with split and index pointed
> to a tail page before the split?
> 
> Wouldn't it return the folio that was a head and check will pass?

It's not supposed to return the head in this case.  But, check the code:

        if (!node)
                return xa_head(xas->xa);
        if (IS_ENABLED(CONFIG_XARRAY_MULTI)) {
                offset = (xas->xa_index >> node->shift) & XA_CHUNK_MASK;
                entry = xa_entry(xas->xa, node, offset);
                if (!xa_is_sibling(entry))
                        return entry;
                offset = xa_to_sibling(entry);
        }
        return xa_entry(xas->xa, node, offset);

(obviously CONFIG_XARRAY_MULTI is enabled)

!node is almost certainly not true -- that's only the case if there's a
single entry at offset 0, and we're talking about a situation where we
have a large folio.

I think we have two cases to consider; one where we've allocated a new
node because we split an entry from order >=6 to order <6, and one where
we just split an entry that stays at the same level in the tree.

So let's say we're looking up an entry at index 1499 and first we got
a folio that is at index 1024 order 9.  So first, let's look at what
happens if it's split into two order-8 folios.  We get a reference on the
first one, then we calculate offset as ((1499 >> 6) & 63) which is 23.
Unless folio splitting is buggy, the original folio is in slot 16 and
has sibling entries in 17,18,19 and the new folio is in slot 20 and has
sibling entries in 21,22,23.  So we should find a sibling entry in slot
23 that points to 20, then return the new folio in slot 20 which would
mismatch the old folio that we got a refcount on.

Then let's consider what happens if we split the index at 1499 into an
order-0 folio.  folio split allocated a new node and put it at offset 23
(and populated the new node, but we don't need to be concerned with that
here).  This time the lookup finds the new node and actually returns the
node instead of a folio.  But that's OK, because we'ree just checking
for pointer equality, and there's no way this node compares equal to
any folio we found (not least because it has a low bit set to indicate
this is a node and not a pointer).  So again the pointer equality check
fails and we drop the speculative refcount we obtained and retry the loop.

Have I missed something?  Maybe a memory ordering problem?

