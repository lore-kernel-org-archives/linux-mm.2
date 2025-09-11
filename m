Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B42DCAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F3094000B; Thu, 11 Sep 2025 07:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F90940008; Thu, 11 Sep 2025 07:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A557E94000B; Thu, 11 Sep 2025 07:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 90776940008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:35:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E549160493
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:35:58 +0000 (UTC)
X-FDA: 83876765196.02.535605B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 048B0120006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:35:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kttSlyag
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757590556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3u9JjK+14CdcJem1sOiVtP5Y0gcFspVi2FHJSC+/w9A=;
	b=QmkZEL22w/BVURASTV9I9XM52gK/31rVSEg8+zg6HlnMnHvLkZcnd47PJajI4YpjouZn/3
	wJzUIo1kiKjPXzYNHLLly+RWA9VwY0GMQsudggYRy+whi3PRMsL/NmZlZCRBuvL1PdI7X4
	/uOjILiXDnOd5H7FqdUMBcdsA6L1TsQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kttSlyag;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757590556; a=rsa-sha256;
	cv=none;
	b=U2PAw8q2CeOH8EcofJPtvDDNUwKNfeVwRJkozmucYt4DSziNQ49nMxvehmZdq5t+SQhy+o
	NiWPsiJ4mDOidd4pjOnCRle/traU8zyzuwvsJlJCPneRxQwDdKLc7SQkG8VQYcsD2LlQ5+
	wBhtN/TmpQWmo8SoRtXgtPf0yhwlUyA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3u9JjK+14CdcJem1sOiVtP5Y0gcFspVi2FHJSC+/w9A=; b=kttSlyagIJ0+/qckXQ7+sDBalm
	dltCo3oErjYrnWXFUgA3PaX8BDpQ8SPxnXOLLvkzmWHtlE9ktN6uMARsCDDnnQnBi+ub2LVztAPaL
	zEYSNPTgBeNs0hoMKub+67isumV2hfdqNOfKFTkjyXMf8Mk+YPaYVspPKxfM0a7MLEHah7UU2uHNN
	fS7typM2KWJNAJj9D0iBj04hKLzdLeOm89zKoq/9MdqxFaEIxQpysw7uD4OA8jzI5Ivub0WUgTmdg
	87TLRRm1asuokF8+mk3NMz27w0vFD8M0K3Us7KYbiKzzCkb+le61asHur6Qn2KwyoStp9X59P50Oh
	DHjTiTkg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwfag-0000000A0B5-2wis;
	Thu, 11 Sep 2025 11:35:50 +0000
Date: Thu, 11 Sep 2025 12:35:50 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 06/22] slab: Reimplement page_slab()
Message-ID: <aMK0FuWwVJmC-Nht@casper.infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
 <20250910115507.1991829-7-willy@infradead.org>
 <8eefb8ca-e310-48d4-0c3a-fa80665cab87@gentwo.org>
 <08e7cac0-704e-48c4-ba13-c857dc1d11f0@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08e7cac0-704e-48c4-ba13-c857dc1d11f0@suse.cz>
X-Stat-Signature: bpp49i9zdo9bsg7d5fc8hidojzyqufe3
X-Rspam-User: 
X-Rspamd-Queue-Id: 048B0120006
X-Rspamd-Server: rspam04
X-HE-Tag: 1757590554-316975
X-HE-Meta: U2FsdGVkX1/HuipoTwsQj64tQjlue4Nmg2uxKdXatKY1kooLUqLOF7fzB/oYUPY3J3nOpRm0Yabr5/zBNaWiChH3hFmMY4+lCGBTP6iWDrubUtUNB5OA+4OUSh7j/w5Q3bLNS0fk8WYV+K0xKVnypd4JyC8KoMNQdtHFkdexKkE45zkOLSLEDLMFcIR57vBrZ2omSsERC1VzSKeA2JI5d3Zos6kUK++/w9L6k2+T0vQOKLtjZLpcD1YUjXrQIrlvJ0WJeIsa04OuGFvsE9X/j1VYxVvPKCHeCx9IBjYMlm34QYksTl6Ssvp13A+K/C8kxRzQ7qLNpB43c8LqvsEdUBQGRbZNt1XeZkB9tN1+TNhYlpM0cfh/WsMKwSbXjWhjQopASVlGpPr4aF2t/cnCTngHtjLQslDLN650B0+HAUlmLpVxDaurFAi+FHGQ6/tyyIf2L+Rwdnj7HkwCzxlxjjZYCeat8m3Kyt9KjzTKWJWv0DLF0iHt39TbGhMCVStyko0+sHd1+kvd+POi5AA5sJYK1HdM/mDs6lPIWqZ+08oJjIYLoyLL/ayOU6TqIvhRPrX8O7Cjvg/eQgEm5tkqkyrX4useMCBUTsUcMmIBic34uRyVdYgnVh4A8IguuMG65JBnaOXsiwbtnkIFgfxSbZUuipJoTebE57aPhet6FKjWBJ1gKOUpaIcqoEe3zTOPEbPMt+SHTKzewkKzrOQC0vILT00vVeYPCplKDqsK+PODSX6iaVBz3cJZyIA1eWOr3xT+TyZh6Jg+3GvvgJ/khxF/WuMIis9Lv6tEkhcc9WGuOUryoPwGzMHGDeP1c/LH72P+1Z7JratHmYzOr0PAdGQ0S/QTeTSr62aK17X0i71jWLFROlfSpqQUqRyvGocVDCCRreJU+N9V9xPksM3aQW0xOgGuMiBFzilKu/SvcEK+X7foFJRIQj/8DcnQlGN/5Zy4PIVF6cyKbLGy4OB
 kJeiZN5e
 ZXFx7m88IXXFszXeMg2dSG4oC7iYa1viu8oSxCvF1ammWVJXI83ALauecFIY5UjeXXQDC6IIPXt0QrM2h2Bvx4AjR7amWEEGL2aKSnaOWv/ETVgzHh4W49jm6RYnarO0CqMDcn6fo2DB/L9Cj+3/tzodDHOV4r/jV76Suivc8RSLg5+dUU73p3ZTOzegLT2jnhLjITiitvpKMyVCNPfvT2Lb7VVEMnBjqXgEn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 09:10:48AM +0200, Vlastimil Babka wrote:
> I guess later with memdescs we can have a scheme where all head and tail
> memdescs could contain the struct slab pointer so we don't have go through
> the head one first? Which would replace one indirection with another and not
> add a new one either.

Yes, that's how memdescs work.  All pages contain the same memdesc value
so there's no distinction between a head and tail page.

