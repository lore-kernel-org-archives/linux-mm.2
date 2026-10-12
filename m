Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8491FCA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 12:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666926B0095; Mon, 12 Oct 2026 08:58:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6176C6B0096; Mon, 12 Oct 2026 08:58:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554E56B0098; Mon, 12 Oct 2026 08:58:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3023E6B0095
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:58:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA005120D06
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:58:26 +0000 (UTC)
X-FDA: 85313977812.20.238D057
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 100B7120006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:58:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AtbQWd/R";
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791809905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eCffV+LjU44fVuxwyaH6GZe0H0I+W3HmXDUIbPeaT3I=;
	b=8UzWMRU8wc3D9t9oE9FRZ/zeCKT7lLlJESqJS5xbnIylSs/Es1+nN0RrJbetDFXyQxrrQ+
	2GLYY4fPGkTBZ3Fva9N+mawW/UvTmLHP7xAPVn8iU3NCuYL2uPibqu5hyki+jNReGIKGet
	Ahs3XR379mwwJ7Lp6Z3A27rv19QBQNY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AtbQWd/R";
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791809905;
	b=S9+UF0HxOu0QcXo9GaCycILtmiSExpGpbXXKxSoHuat6bEsY4x2XI5+QwGrRddbQdeu4ln
	57z+pCveE8qkCV71pk0qI+3ieWAXnPhRsTFpcRR9Y6qFkZlkDwq1IK5DMBIbMSSoYtKqbK
	/7OUaE7lvvTv8PDFmGf6woRgD5EIGJ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BAC4B43264;
	Mon, 12 Oct 2026 12:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65521F0089B;
	Mon, 12 Oct 2026 12:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791809903;
	bh=eCffV+LjU44fVuxwyaH6GZe0H0I+W3HmXDUIbPeaT3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AtbQWd/RyZIQcaJSOx4arO+G10/M9zPE282t83jiUPnxcFMILI/MR5c98mRbJf8L1
	 1pXTATvUmoZmucTydvz2d3g18BgZz/thVtXTRpqMuILL7E5tjZTveHb+IawsOIhY9Z
	 ZCZR+vhM8poY6rmI3ZhSS2LZllcI9jEFLl6Fl0Z8A8qQIDUFgsVSBp4YDvdXANnlLH
	 rfqbOeJXUC4hK6qHvY8yh/6vH65kg9ad1AB+kMwWNzkRn89CoShs5r7ux6lkVKuIQg
	 FQ1s1nUBFaZOg2uxuF8v/vZOxIaQY7qPMHVtXbZ0r/JHUMBlP7WDog9T338kfKKYtx
	 uxpjrUIn73aLA==
Date: Mon, 12 Oct 2026 13:58:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: albin_yang@163.com, akpm@linux-foundation.org, liam@infradead.org, 
	david@kernel.org, vbabka@kernel.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, albinwyang@tencent.com
Subject: Re: [PATCH] mm/madvise: add cond_resched() in THP branch of
 madvise_cold_or_pageout_pte_range()
Message-ID: <aszZPq92qX3jpsNE@gremlin>
References: <20261010024042.4070048-1-albin_yang@163.com>
 <aspKmWIrOzNjiP-t@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aspKmWIrOzNjiP-t@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 100B7120006
X-Rspam-User: 
X-Stat-Signature: qyx1mjqbjia761bw6ekjgff9kii845ub
X-HE-Tag: 1791809904-474111
X-HE-Meta: U2FsdGVkX193dotSZk75PaXD5uLvU6yLZIgTjLYIRtGTBjglXKZdEAvkRid7TfX7JkAQYUNRbVyEoylLFPAVwIpypEab5v3ZmIa9ELuLtU8ZyglEEyZ0SyrdyUvcaQeSRHBIXXnKIg1giPoudMnT8ujSCZPvqHf76s43jvbtAgEIiz5jIWTBmw8vnUC0lhBKRYJDIiGId3uqLyllPhbh8R6FOZzW3ET8Cqrt5FWgzhm5htlVdVzEcPp5IYCGUClP+4fEkbvuBCMY1nNSxbgwKRPevjqQARYT8XlS6RDyWQJEcb/O8epDaHV3hMinL2KxIaSn/Au94eC5XUXX6T0pcnWZF7pNVd9JMoKdWkrWMhqG9OATujANt6A4F21A/JgOycKSR57f89c+M3v7d5cc2zY4+bhrGH/2+yx7XjbGVHKFamEfXwDZ7AbT+x0fCdhoZ5egEaS1xj5YVwNlnPZgxvr01Nc06xtb9FJwkxxRtU4JhJZeJhzFV9afO42K1tkEjHT0PD2o67sewhnBw2LN9VfWrj592VWNqOdIlLY3eHt65sayVMlXRaO7yQJ91UUzIqIiZdWw5Bfuq/wug+LJQ0P+Qzu/xtCAzW8qHJddMw5/poRZgQxgDOdxUJnkl0+iqykgQLrlm6K6IlQMactXxuTS0+SK/PXEpGOZvmgKG1h4IGy8sWC26I3HQlmUxphcLHdLcm4rKN0a3pYjhOKhcZwyPs0r9Bu15ItPy7sTNbSoBSkA6wdk8qvxufHufWJrXcsk5KJmN1dXXrh3chHKhYtZO0K8mMJRygwkxnfRZfle1LMpCNExYmULZsHAJ7CmLfhGNOH7UwAwJO3O6On1PSEX+6BETsafYy62kKfYRfvZnfCfqBDvRoifePfOnIrcNLmRd1sTn2WG7LjcgE6FofCvAqOXfXiv/8WhKi1ETUU2kWlXFNybZorv7rSwTeUm9/dV44scCJ+RNl9FacN
 XtnRftEL
 maQdRq2BDYhQlgnXEdQ/zTrgoVw1Tv+SApCev4SzXf4SnezWpWuilQ6lTGB905JGwawWHziCCufqM9NQgT/h3bar+TqFAOjFjSy6j96h1C0MnAasXwEYj+MxbS4YPJ4j/jszM/zUZhtQ1MsmbbtW2qfVDbHPEV0ny7JUM8nlXYoN6iJJfWr7KvUw2RjIyTLw0Fn0hZAKYBW9Vn1JKjS/Na0arnCsULgf3ScB6hckYeO5Q4FTCs8h22JMhk+CgKlt9d+zBOo9Zl8K56YVv/7OAn6JWkhurUcllO5ymfvqeSW3QTd1ROKOs9qBson/pBJC0xmUs4w4csasti/vKyIqXHoRplF5eiQ7DK6z8Dy30FvViGoEyqEpgvpiMrC8jchOvXaJRAr0T/wboBdSw1rNxQSW7RN7GH/tdcKr3JcJrTj68sCglCSgHUlt4Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 10:26:33AM -0400, Gregory Price wrote:
> On Sat, Oct 10, 2026 at 10:40:42AM +0800, albin_yang@163.com wrote:
> > From: Wei Yang <albinwyang@tencent.com>
> >
> > Crash log:
> >   watchdog: BUG: soft lockup - CPU#63 stuck for 23s! [stress-ng-vm:1665914]
> >   ...
> >   Call trace:
> >   pmdp_invalidate+0x48/0x68
> >   madvise_cold_or_pageout_pte_range+0x84c/0xb00
> >   walk_pmd_range.isra.0+0x1ac/0x3b0
> >   walk_pud_range+0x120/0x190
> >   walk_pgd_range+0x170/0x1b8
> >   __walk_page_range+0x184/0x198
> >   walk_page_range_vma+0x94/0x128
> >   madvise_cold+0xd8/0x198
> >   madvise_vma_behavior+0x234/0x638
> >   madvise_walk_vmas.constprop.0+0xdc/0x210
> >   madvise_do_behavior+0xa8/0x328
> >   do_madvise+0xd8/0x140
> >   __arm64_sys_madvise+0x2c/0xe0
> >
> > Signed-off-by: Wei Yang <albinwyang@tencent.com>
> > ---
> >  mm/madvise.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index eeee82cf2b3f..0755e6d99757 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -450,6 +450,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
> >  		spin_unlock(ptl);
> >  		if (pageout)
> >  			reclaim_pages(&folio_list);
> > +		cond_resched();
> >  		return 0;
> >  	}
> >
>
> This same improvement came naturally from refactoring the entire
> function into a proper pagewalk structure:
>
> https://lore.kernel.org/linux-mm/20260922235830.2350770-10-gourry@gourry.net/
>
> this function is really nasty.

Nice!

And thank you for looking at this horror show of a function.

But yeah as Andrew said, need something for the backport, then your work can
help eliminate the source of such things! :)

>
> ~Gregory

--
Cheers, Lorenzo

