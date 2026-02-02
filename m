Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75B1AD172C4
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 04:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7647D6B008A; Sun,  1 Feb 2026 23:00:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711AB6B008C; Sun,  1 Feb 2026 23:00:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61DAA6B0092; Sun,  1 Feb 2026 23:00:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 519816B008A
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 23:00:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C84D85BF57
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:00:17 +0000 (UTC)
X-FDA: 84398164074.27.DA5ED3A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 347FB1C000D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:00:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BLEOsNzJ;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770004816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JeLi+++sNjhzFxRCz6+mszRfMSyeWN8oOxvNTn+LIXo=;
	b=VCITfMGv2Wrk+QR2MRnJ2Ypn6fJ6C9HShrq6CsRNF4CFBxhP4WBgYWBdYFKet6I35eXKWl
	g1hbK7eR/cMfQjRrsXTVY4HvJSEG6LOJwfaqGKC0oDnN84ZbV6OMKhkxYQm5rD0DVgIQ5v
	+3UVfGsg1d5M5tHDStR4mbJRcxV3g34=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BLEOsNzJ;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770004816; a=rsa-sha256;
	cv=none;
	b=HMAfzuyGejZSF5OhN5Be98Rs04Y2/dN9LR6dVIxSXh5LONygW8uOyrJhI2fu1EEEqp+zvV
	/7YD2lMTG3fT1NdwTD7dHZz4WID+yU+Q70CAMljynKYS364ojSIVgd8vXlhEiRHKEDadpj
	/6LQzkVZ2U7T01+0tZW7TZp+NW1qvHw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JeLi+++sNjhzFxRCz6+mszRfMSyeWN8oOxvNTn+LIXo=; b=BLEOsNzJcFx+z+XmosJ7jyuHyA
	g7OH8XGXY5FvmWZIdyIQfqeFPzML95Q4iRmYRHbrjj4JCq/t13U7NunG4oeVgoOqPAOMGe/yTT7Qk
	gmGAkc+swShdpxD5FOpHTXwkDBt3UONFMneslGhkw7ScI7dwVcxvFADQMLPj1rDKGaFQ7Usrj48cD
	zE5NWyNZqpEaGjmBJ8KRQJIUjMS0fp/yl/Ie9wx+61NpxF/G8bUSjzVnbC9dUWSJl0yEDgqvAaNRV
	178WQFBC9GUJsHT1Ul0CBmoGZzdgx/3qr3+5cL3aWQw+7QwqzC58sYLjVII5iuwI/WM5OZUMkhziS
	JFp9fQHw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vml6c-0000000Fvwl-43vx;
	Mon, 02 Feb 2026 04:00:07 +0000
Date: Mon, 2 Feb 2026 04:00:06 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: ziy@nvidia.com, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com,
	shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org,
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
	lance.yang@linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
Message-ID: <aYAhRjI2xNdtdvWY@casper.infradead.org>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: 316pdrdgr976q4cpddbsgigytsur95yg
X-Rspam-User: 
X-Rspamd-Queue-Id: 347FB1C000D
X-HE-Tag: 1770004815-504946
X-HE-Meta: U2FsdGVkX186CHVZxjWAc7y0RjrkEou1+YPHamoJ+7JQzHdb9dCo1u23kRWs2FCUEkyblWiqsRZ+FY1ifqExedhE7iWRJzvSEV/wBMk5+1xwRC3Aq9os4UjOR/85l8lZXk/r8Wn1R2h5uAI8nKTF6Gzj9ILV2okNy11UZZe+Y91HlLUy5UC1NfZ2svWLd+mh86E3F6OLAfEi2pipmmi102xcbOr7PqHb0FxMcuZ4wtlxqk8sdQq3CR4lAS1T5lZ0vRqc2eZlKUw7t2kZmINmON162MBFDqoKetgArR+0vruK5YrPsNivyzjgIkEZLRHq1a9Exrqr8o3QPAFI8MdvYQT4HLbzDe1osoBZ8Qu4balQTbvDSmBD79/jOcLkOccGjXnklPZhOj9Vf6UTSZ74GJ4e73nfRFSVw0d5VisAkwLGPXFx113Eg8468sVLICOHh3hGWf91bGcL8cpMKowa2j/U/+f1XfQZyxZC5Rau5KLcsG0PX5A811gG4uDHnyVttiRIZfgiPsAmJOSRtF1NArKUaA2TYf6Jh4OuwP8FAdxIDq91UcSMhlY5bgbNfVFey7bQZJlLAD2UBpEuI3wgH3IXbV8fJJeRQ6ecboa/1/169PTJyfwLIEekCijxHs5ImdNSEBzVYxBvQrQOsE7DJKGMSEn2mRdGeDXy7yoWP3DFo4eU8Iau9Pff961xV5NfEjy3LeYZYebqMwIm51tVaFJF2zBjodlop/gyxuLgY1Oc5h4YiBzySE3TdJQlOYlJYHPleB2TvsAE1LpK2viMmOtekh95yu8UJU7aocOu3YHoQZaF6ZSd241KEvF6xwyob5DI9rJ44t0mzA9zNK/jdmydDaLdwFHemZFRAa71xIjN/O5JeKJi8FV0zGP6L8mizumaMNBBYmaL734f0SCjYI009vL7/A3oEMIDs7nZyT0u1Pmi603ftCkvljT5O242dRIoeRw9CvusWov7KdW
 DPmjK8A3
 1ioX5ljKsxbNWI6r7eS/tv9PhuAmIN4BxX2IaeR3PWHf7y1iivmjb+a/D9t+At/j4rpzcssrUUlpdfqYKk58o7Tfzb5J7o7PKh2b1xnzQutqem3MWQx+MiT46y+3K8UbDS74qBLGsFQFouEkp+qZRzwf5238q29t2rah15GFngdBhdEU9lXyKUqIIDNlbfZ/iX6XSEArP3hxp5n+dc8SjvGyR6h8c35jeK5tvcRJBoxFACjkeiUCEoddfPVU2U+S5YQUV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 01, 2026 at 04:50:17PM -0800, Usama Arif wrote:
> This is an RFC series to implement 1GB PUD-level THPs, allowing
> applications to benefit from reduced TLB pressure without requiring
> hugetlbfs. The patches are based on top of
> f9b74c13b773b7c7e4920d7bc214ea3d5f37b422 from mm-stable (6.19-rc6).

I suggest this has not had enough testing.  There are dozens of places
in the MM which assume that if a folio is at leaast PMD size then it is
exactly PMD size.  Everywhere that calls folio_test_pmd_mappable() needs
to be audited to make sure that it will work properly if the folio is
larger than PMD size.

zap_pmd_range() for example.  Or finish_fault():

                page = vmf->page;
(can be any page within the folio)
        folio = page_folio(page);
        if (pmd_none(*vmf->pmd)) {
                if (!needs_fallback && folio_test_pmd_mappable(folio)) {
                        ret = do_set_pmd(vmf, folio, page);

then do_set_pmd() does:

        if (folio_order(folio) != HPAGE_PMD_ORDER)
                return ret;
        page = &folio->page;

so that check needs to be changed, and then we need to select the
appropriate page within the folio rather than just the first page
of the folio.  And then after the call:

        entry = folio_mk_pmd(folio, vma->vm_page_prot);

we need to adjust entry to point to the appropriate PMD-sized range
within the folio.

