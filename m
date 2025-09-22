Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 166C8CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 20:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D29E8E000B; Mon, 22 Sep 2025 16:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5822A8E0001; Mon, 22 Sep 2025 16:16:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4713F8E000B; Mon, 22 Sep 2025 16:16:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5BE8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 16:16:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC1CC14021B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 20:16:24 +0000 (UTC)
X-FDA: 83917993488.30.8F0C173
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id C00C712000C
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 20:16:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vHd0iS2j;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758572183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cfbpfmf+u0YSkEaM2WaewkLs4L853hup/SL8tvoIOj0=;
	b=gDYkfEvhHb0xd26Bh4tSI8W1wemOlSCGWG5tx/jdRBB3aTyqDeHfxklnuGw1E1fsYuwp/J
	Uq8dbOIFdIkP5RXrFg1dF2zqV0T68m/g2UkEe2y5XvPp4CwTt470tTEB4Qy+QLGQHn2/Hw
	MA8DEUgNfENFgjivSwE+5my0aMiasDs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vHd0iS2j;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758572183; a=rsa-sha256;
	cv=none;
	b=08yAQchOh7C4kpstRqxE9hVehVon9K2v3NEWFamDaDxhABdZ1bctmDdYwr+mq22IBSrM5G
	Dk6TFuMHzWkB9Fe88b4TZjipUyt6oHDuf+Z9lpyGLhZ3VeX4zpK09ihpUlLY0rI++5RXM/
	1IDYW188z9G0jOJu/at153DwNzWyuCA=
Date: Mon, 22 Sep 2025 13:16:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758572180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cfbpfmf+u0YSkEaM2WaewkLs4L853hup/SL8tvoIOj0=;
	b=vHd0iS2jU6HG03fy54QFIns8EroOG0GUm3MOmM2EfzIXbyIG1QRsCPmCmxD0gLIv7YbQdj
	i9vh9Q2luRZ6bRYF7FQ3p3fhhwn5D7baz9n0IOvs97ZKzgJKYGx6zDNJx9Vf3Tx2z4rw0r
	SDbf0uocHppdWX1klC6XiS5cbzOz38U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/5] mm/rmap: mlock large folios in try_to_unmap_one()
Message-ID: <z3yzhd3c7qw4ig4ekh3mq665zws5aafab7lgqpvytzg5wxv363@ojmp7qdsl5vc>
References: <20250919124036.455709-1-kirill@shutemov.name>
 <20250919124036.455709-4-kirill@shutemov.name>
 <27wxlfhnkxaat57lzyzlpo66vse3jjhp422ziswbl4oyjnamif@2jx25dwgkame>
 <pdorb325r7fatuclbaw4zriieve4tphlrox6w36fo4mlmzgcx7@kdsf4pwqs2wy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pdorb325r7fatuclbaw4zriieve4tphlrox6w36fo4mlmzgcx7@kdsf4pwqs2wy>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8oizewu3bixfpq863fmd95u5b1cy4zpq
X-Rspam-User: 
X-Rspamd-Queue-Id: C00C712000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1758572182-943914
X-HE-Meta: U2FsdGVkX19e0WNkQKv2xgE2C9RvfqcYC1LDAtrqXhNA9YRMRfi7wURtZ0Kcrk4J/RbE6J+tMtlq1sCYdymxMmxCZk7nht2/KkF38QYKm+H0FHXAFHheJeFCFJ/jV4KRbv0Sxg6DYXL1S5jNbQkUquUvhEoGpbyRKDZvy6UF/PE1mX/NrSAGOF2knoTIGQl8ZHGgipDYXZ/IikAxXmkg/P8H9qXNCJJ3ikWF6Zso2kBe/VOMFnaQQa1GNpkGt4TGIQOedsqL/N4VSYadMjn72h37oLjr2lzAl6y5TD6LSCcNaub5Il5QBVzsNcfYmsbqG37g8GPnWp1ouTmbykD1dRGvw8elqAPQXqWfgma3feKO0OvKP87MAnV3baJnpRaKrnRoYHJlUwHGMvPz86DwEx3M08u5RkcaRpa7OoZL5WvTdp1XqySLuPC5pO8AzG5BjXuJFUQ4+JE8UisEgSQdGINLtUyvpxESJiaP3kqDkRRFoNMXhj5lbCxkmjB207yJHEvvJ6NLw98I3bOvYHv7KXGSTNJJ/rSxF7hcgFxUY0v4LfqknmetuAJHHBIdhdNuvHMtt71lDKniVKY/+nO2p9YxiTNOvH1TrOC70sUiiwxFCL2UfUV27CBUHphPrPuYpczlvGBz8nzOizu5LcYDPBrv40CjmAOMsG5pyuFssmN5VOXYX1AYUgv+OzocrQeAkO1aYwouraMkSs1NFWXrR5bzAajl6TbTFexyYHcEXyDTTjOEZbZR9k+F2rclqZ0kAZw79BhokDzNzX3EHXJJthcRpBEY3CHk/nEKh07ABx5+ojaJiY13jdiYXmKE5u4BQhsEFqPJozC1wMSX8ZP4nylAvbmS4XdlGMXSkFuQUDi6m6809/lf2LlA4tamsRTkGYB/NsgUDE+cjiWXoqGYnNHoQ7o+e1HVlxSw1/ME646Hc2z9W5uzmFcB2sWJaJxN2/bKF5QYQ3Qb5uNLV+c
 0Mp1n73s
 8t91SDDHh4fr1sH4rXvcS3aszKjQHaNjVV2chRXg1NHn3Igj7/lTTfwAgR+qRFHDa88EAlKvjbgAP6xINIgXaltfV+1rV/k2fJKM8aJCr/OAx+qJxzV26P/t/jRFMM78G52owX6HPi7Mg7UdP3eFmtJbIEoAdgKVOM2hon/MKEDXJPcX/4o+l8QKP6PfjZe1WjWLZB50uk7a3d6tRVN4gOt3eBrGB578Rf6BWm9WxyFmN9UKkcNT5XGm+Qj+jB+ziXl7RGe712OJPqOrrC1k1c44FJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 10:51:35AM +0100, Kiryl Shutsemau wrote:
> On Fri, Sep 19, 2025 at 02:27:40PM -0700, Shakeel Butt wrote:
> > On Fri, Sep 19, 2025 at 01:40:34PM +0100, Kiryl Shutsemau wrote:
> > > From: Kiryl Shutsemau <kas@kernel.org>
> > > 
> > > Currently, try_to_unmap_once() only tries to mlock small folios.
> > > 
> > > Use logic similar to folio_referenced_one() to mlock large folios:
> > > only do this for fully mapped folios and under page table lock that
> > > protects all page table entries.
> > > 
> > > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > > ---
> > >  mm/rmap.c | 23 ++++++++++++++++++++---
> > >  1 file changed, 20 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > index 3d0235f332de..482e6504fa88 100644
> > > --- a/mm/rmap.c
> > > +++ b/mm/rmap.c
> > > @@ -1870,6 +1870,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> > >  	unsigned long nr_pages = 1, end_addr;
> > >  	unsigned long pfn;
> > >  	unsigned long hsz = 0;
> > > +	int ptes = 0;
> > >  
> > >  	/*
> > >  	 * When racing against e.g. zap_pte_range() on another cpu,
> > > @@ -1910,10 +1911,26 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> > >  		 */
> > >  		if (!(flags & TTU_IGNORE_MLOCK) &&
> > >  		    (vma->vm_flags & VM_LOCKED)) {
> > > +			ptes++;
> > > +			ret = false;
> > > +
> > > +			/* Only mlock fully mapped pages */
> > > +			if (pvmw.pte && ptes != pvmw.nr_pages)
> > > +				continue;
> > > +
> > > +			/*
> > > +			 * All PTEs must be protected by page table lock in
> > > +			 * order to mlock the page.
> > > +			 *
> > > +			 * If page table boundary has been cross, current ptl
> > > +			 * only protect part of ptes.
> > > +			 */
> > > +			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
> > > +				goto walk_done;
> > 
> > Should it be goto walk_abort?
> 
> I already have to set ret to false above to make it work for partially
> mapped large folios. So walk_done is enough here.

Indeed and I missed that. What do you think about adding a comment when
setting ret to false? Everywhere else we are jumping to abort for
scenarios which needs to break the rmap walk loop but here we need to
keep counting the ptes for mlock handling. Anyways it's just a nit.

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

