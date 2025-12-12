Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98907D4921F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 12:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECD8E6B0005; Fri, 12 Dec 2025 07:18:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5366B0006; Fri, 12 Dec 2025 07:18:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1C46B0007; Fri, 12 Dec 2025 07:18:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDCC96B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:18:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E57712F6CD
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 12:18:22 +0000 (UTC)
X-FDA: 84210721644.16.6CE1A4E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 74D9440012
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 12:18:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cfKnlzfV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765541901; a=rsa-sha256;
	cv=none;
	b=W6mZbi5Fa+vDHGA46BQqgJbbtVOtPjcz8ZrWf7tr5j3jHd/R0bYrsfmtUfnSb03Xck0RUT
	Adv6fGxj/Hv+7KfTbXKKvBJlxymtora5u5HHwygdnjAOsMFAqMC0IVv+nDae6ZvJVb42Jh
	CwWm57Xmh3n7NMiKv+QU6LNXN1gvSqk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cfKnlzfV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765541901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4e7B+E8LkBy1p188ZJwv5Wln/swonn5oRIyMMDWppE=;
	b=3Er60qtnC7gobxCC9S/0lhK7JR7vP0aj45ZLaXYyu/lFgVPgRHiR5tWBKzRs6ZKwyG8peL
	/hbhCRL6sCQ81eAjCEhinJAIFXOTQho0/0cGwGCvwLOYmr7js0FGAw4WnYAQ5JCKwIDCMS
	Zqaf2H6UZt0DDcRg/qSCGGKcECeUmX4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w4e7B+E8LkBy1p188ZJwv5Wln/swonn5oRIyMMDWppE=; b=cfKnlzfV9QrsH5hMOhmPUAJhXy
	XjEPNpRNJpEyUWUD58b2u3CldeYoF3Yxr90xzhUkPWmFS1Icv8hUVhfORCvWwE7UHE+RlwbWt7xVO
	vUeggPll8nmxfPGQsbuyfrPGqVqU41vL0lNYf7j8jUjLggJ8BRxZWITJ3vVe51BDVUW0hqkQupPc+
	f7WZx7HJjp4C3PcTjQnbWyuhUOFOYenRuQWMtitcijzVGhxR915iboxfs7Ee1vZy32cOADi1nX5gw
	D3x1yPOOSDbg/a0QcNlh5HrUrMb5n1ze3FR3M6LvMSEFYshjNaC35qw1f9xyIoqiBFvyMG1c8MC0u
	uyKZfm9A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vU267-0000000FfEK-2ukU;
	Fri, 12 Dec 2025 12:18:11 +0000
Date: Fri, 12 Dec 2025 12:18:11 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Deepakkumar Karn <dkarn@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Liam.Howlett@oracle.com, Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pagemap: Add alert to mapping_set_release_always() for
 mapping with no release_folio
Message-ID: <aTwIAwjeSrALbVww@casper.infradead.org>
References: <20251210200104.262523-1-dkarn@redhat.com>
 <aTnn68vLGxFxO8kv@casper.infradead.org>
 <5edukhcwwr6foo67isfum3az6ds6tcmgrifgthwtivho6ffjmw@qrxmadbaib3l>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5edukhcwwr6foo67isfum3az6ds6tcmgrifgthwtivho6ffjmw@qrxmadbaib3l>
X-Rspam-User: 
X-Rspamd-Queue-Id: 74D9440012
X-Rspamd-Server: rspam10
X-Stat-Signature: 8u45z9bo48zb8nqx533967s7czq5zxwy
X-HE-Tag: 1765541900-804373
X-HE-Meta: U2FsdGVkX19XQ62HlYVGCYI422eFNRenQO/xMNPuyBatmeUol+Uxgw0VNBQzET3xDfKvu2y4gk0aKF1LPCbiJmz4EBq8yOwTRSaCFVRHAPB3AxjPaHGw47sdtk854Ewb5k/AQb26Lh+VQdTWDmEnIUp82T/T1xTVAlSXKb6juFkWGmmknnfosM2qxTHHDqWQ9Er2ASJ637Y8QyRkYFJBfMjikx0LO8Vw6z8zRbI3YU4H450eMvobzYzvd9+Uk9T4wP2hmW6J99SGD/w8dMH2JDtlrJyNxRVz16l2zEtsyc7vkMoIOermmj10UbXmZIx0cFcLr7bXFH23pEsRXEr1tk8A/PGXTDoWvluWgXFEheU/nhWBT4shk+RufytQFpQtdBKWZMTdSjYw/dbJRutB+omc+oVvRfiG00+FaSeuTX7rZMXiy+IGy4AYAPWAcjlj4laVm20wZEAi36t32hJUOcHhhPD6v6DBXSMwqoWc57OplRhr0ofS+DUMPLMwktWUHBupkzYZ4fay1du8am0RO2/lOV5gfC27Q62mR4xJ+I6i7Aez2Brw1Zq1buJJsSLxAEG0Hx3IpDWFl8Jx+LLzA5zUijmmubVHtVBjkk5XRjKWI/dJBnqs7/jN6EmVODhZoB5YuDA0FxA3PHzwn3LSsnSX6UZ3MDqbdOMFHMzZLjPgUGDSNNTms3TwtRiSJBuOrLYEir8TZRwFV/igtI2BmCGnss91w6nkJOWDBElU2WiQCr7gR+1DP/AvxLZ1QsVaSz0pMPFEcOwkh/wWk2E8/fTpqZbWMRbspA4woEgIFI4OIhuR8ijfqhRNyjVge1BbNbMYzP3/fHLOgqzOnz6G1p9n6lOXaPhdIQQ7Me5FZ+xZr/9Zwq5PZjaJ53SHF/xZ53I1giCQh7YtJa8oMUFf253E3XgEyp9WomCle1SYrqfdqZzFwzuZajIRNB2CQfp9mb4c66S10G0MHkXDzH3
 NZ90WA7n
 7xn+C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 10:23:13AM +0100, Jan Kara wrote:
> On Wed 10-12-25 21:36:43, Matthew Wilcox wrote:
> > On Thu, Dec 11, 2025 at 01:31:04AM +0530, Deepakkumar Karn wrote:
> > >  static inline void mapping_set_release_always(struct address_space *mapping)
> > >  {
> > > +	/* Alert while setting the flag with no release_folio callback */
> > 
> > The comment is superfluous.
> 
> Agreed.
> 
> > > +	VM_WARN_ONCE(!mapping->a_ops->release_folio,
> > > +		     "Setting AS_RELEASE_ALWAYS with no release_folio");
> > 
> > But you haven't said why we need to do this.  Surely the NULL pointer
> > splat is enough to tell you that you did something stupid?
> 
> Well, but this will tell it much earlier and it will directly point to the
> place were you've done the mistake (instead of having to figure out why
> drop_buffers() is crashing on you). So I think this assert makes sense to
> ease debugging and as kind of self-reminding documentation :).

Oh.  So the real problem here is this:

        if (mapping && mapping->a_ops->release_folio)
                return mapping->a_ops->release_folio(folio, gfp);
        return try_to_free_buffers(folio);

We should have a block_release_folio(), change all the BH-based
filesystems to add it to their aops, and then change
filemap_release_folio() to do:

	if (mapping)
		return mapping->a_ops->release_folio(folio, gfp);
	return true;

(actually, can the !mapping case be hit?  surely this can't be called
for folios which have already been truncated?)

Then you get a nice NULL pointer dereference instead of calling into
try_to_free_buffers() which is as confusing as hell.

