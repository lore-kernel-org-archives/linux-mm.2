Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE18C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90B16B008A; Mon, 21 Sep 2026 16:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40E36B008C; Mon, 21 Sep 2026 16:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E646B0093; Mon, 21 Sep 2026 16:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A656D6B008A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:08:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F4781C2063
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:08:53 +0000 (UTC)
X-FDA: 85238857746.21.4E75313
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2C30680008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:08:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sQBUGlf1;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790021331;
	b=SfuakTp9xxuSEwwvNvsoWgdcad5E0G5SsA0EghrdHLHmHJArckejGRFIwM8vVIZcXO4F5N
	mOFdgiuk4J4qtRWPdKWFUbCleGoacB1x+Gw0wZPDZ4X2hf4xFIf6lcAuddjNQ4PNhs2o46
	uoBLGeG02fMpHamWcMPr1uUqgCt/vJQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sQBUGlf1;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790021331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpz1np6I94fifnMxNnYzzaYhhtfOM5zzK657a0adnvs=;
	b=Fevd4NUhNUK9pPppmHl+RjiuH5ma4XCSjbWsbpPoLxeByXbmwtBwl4oE1v78k88gw7pUmC
	08mZ7foc9trmED2YFhuYXcK4sNLNBWCpv3MNm7zkdBGd+GlBYWztTNOJOPEcRuBgNmqUkA
	lnLW5/MRa5XFY4wPh8BTjF5ESR3JlkE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kpz1np6I94fifnMxNnYzzaYhhtfOM5zzK657a0adnvs=; b=sQBUGlf1YuwmcgH77+BVsC0fJq
	e4+F8LMr9HvpRk/GSeWJjWU2bcwy6PvypQT2+UkvY4V5gdDxC6UaP02gjLZc/9B3FpjtT1J4eYq1w
	6RY6uL+2t4YikBGmjKBbsxrj9pOIrIpiBUlD+NFRECei/llXpaYntuVHInyS0aG1zHLRSEnwHKzpL
	/EfYBX8uq5iP8wyWPjUyaLRlKx6ZDHUb9UdA2WqinD5qoi9Svbk65/4JxWKfH/9pMaQ968XdArnFQ
	9faWhcBGnzAUK4RaiGb8Vyc4w42HUUhYzZ+tAvjqSBVEYsMqfSaa40bnAuzof/kSYvsHYUS/0kLDG
	HQbq6p/Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8kJh-00000005DB6-2jl4;
	Mon, 21 Sep 2026 20:08:45 +0000
Date: Mon, 21 Sep 2026 21:08:45 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v9 11/15] filemap: Add hwpoison handling to filemap_read()
Message-ID: <arGOzZkXQUdSpIc2@casper.infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-12-willy@infradead.org>
 <an2e1j3C_4DA5KXK@pedro-suse.lan>
 <an3xv6Hae6g3aHCh@casper.infradead.org>
 <813a2644-fa9f-4ee7-8655-ca69ef0e8a98@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <813a2644-fa9f-4ee7-8655-ca69ef0e8a98@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2C30680008
X-Stat-Signature: 6xjs34by7rmcq9go1metmqmzizm8zag9
X-HE-Tag: 1790021331-833395
X-HE-Meta: U2FsdGVkX1+nlhfez3ri65k3uf8S2bKKhMP/dik8Imx6O1VgG2eXIDgLhLK0IYaNi+D2z4qoTddxrbHjqcxpN9jMIUQQdkUpXA38q3mgF7zQjFyKRPCDis0dDLror/NAvkIrCZ2i9Z4s+0msNi7Rt62sZLzEdMixQE0vyNI+08mehDogiZzomY0GYKVY/cWoK9W1EiKoZBEi7AYuN0EsuY8YUo6yEUofgbXwo3bUBe5IATk6dnjY30fCzW/yaRfVZOP3uIjwrs7XoVlZ1RUH9yGkMWbuFVyaO8kBZog3kJ0ZSiutqEQvYMHNSaMIRTNFfcUkTy9dAyxaV8G25iK4Lh+P10FiQ+JA2R3gBg53Lu6KclKOGTPEVG+TmCM5kGkRIixPJNVzpdH7Tot8AgZEoV6MoDEMvq/b3LCHbFljQb85iayJp08L5PgGrjhh1PWfqCk7TazdBtvWjnYS4tT/wjSa/7h8lhKphiuSfoNbj+Tv0A4a9mqI1p6hryX6/mgVyN7/Tk4bGc6y/GWoJHMKnfzqef54hjDEiPyJBueWSZb7jTRAh7i7protufNNPEZmB33gNSFwVRqSGzQ2ZySjNOkZMIzsH3Np5ccnXbMQG+C7hVkVPBrT9U+EZlSNL/SIzS5s2w6lZ9NzKLiGYRPsqrHvXGQjJVkGO7nbvpWJasgzPT1kh9nuOVs6B2srCJ4nKYkhBaWc//Xz+S5k+vJaYrPZBvNWk7Gi1uSiHTtuoTBgrGhp+v2FUjhm0lV+jq2qvTPaP7XgirLC3FRLybxV92Xi8iQjL35Cbhm9GKGMnCbca8m700fyzzuFJs68y3gbLT295JYm8U2ig3n1pEtx+sXGf70BrwQ3NTrP+0q0xqYaSRXXmt+ryjiMj2+jQd+I2nMhqTuxPYKxFoBbIAVX0BfpeFZRLHTUx80dYEw4RW5rO0Vd6U74TvAYaDskQICith614yRUNhg16U4B0SF
 5V75KY5p
 7KRTrm30nnSTSVOjF1sRXeqLT+d4pv5DXJR7itEqiHZgTKjThKi0JHwaJ0tZ3GmN0Q7bkDcY8cLDqF5IFz68cMZlkvXZVuu/bIvSQg6eefG1E7SYNTY+6EOuD8BSIDMHsfs8psOOJEqzD5JihMgtmKJUhjLsk2UyGPs81bNVZo0d2NqwvLxPATCQNd2PA7ENLwZfJhvlunzVnHsrwzuIHXcUE7LPvCXPQMzKb2DD+q0wcjbGhlao6RmeEehD1LOCN2H4PXtzgSmHORiLKiMgVToitnf95f10+CBpa1rbwSms33Tai5rAi6agfYYatnl3qrEYv0rHubgcgBtcPLzVg5qZ8XmMj2vGPNC7EyRHGHtIlOoxRYQ1R4muEgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 03:47:18PM +0200, David Hildenbrand (Arm) wrote:
> On 8/13/26 18:33, Matthew Wilcox wrote:
> > On Thu, Aug 13, 2026 at 11:55:44AM +0100, Pedro Falcato wrote:
> >>> +static size_t adjust_range_hwpoison(const struct folio *folio, size_t offset,
> >>> +		size_t bytes)
> >>> +{
> >>> +	const struct page *page = folio_page(folio, offset / PAGE_SIZE);
> >>> +	size_t safe_bytes;
> >> 						    offset >> PAGE_SHIFT would probably be more idiomatic
> > 
> > $ git grep '/ PAGE_SIZE' mm fs |wc -l
> > 116
> > $ git grep '>> PAGE_SHIFT' mm fs |wc -l
> > 656
> > 
> > it seems relatively common.  Personally I find / easier to understand
> > because I sometimes get confused between left and right shifts.  I
> > don't think I've ever been confused between multiply and divide ;-)
> 
> Linus once explained why ">> PAGE_SHIFT" is preferable when the type of the
> function might be signed, as the shift generates better code.
> 
> I personally find "offset / PAGE_SIZE" more intuitive, but I also have sympathy
> for PHYS_PFN() to abstract the operation.

Oof.  I appreciate PHYS_PFN() is literally 'shift by PAGE_SHIFT' but
it implies that the parameter is a physical address, which this isn't
(it's a byte offset within a folio).

> (SIZE_TO_PAGES would be a bit mouthful so I wouldn't ever dare suggesting to
> introduce a new helper)

I wouldn't mind a new helper, but it'd have to be a pithy name, and
I don't have one in mind.

