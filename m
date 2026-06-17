Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04823CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 18:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A855D6B0005; Wed, 17 Jun 2026 14:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D7A6B0088; Wed, 17 Jun 2026 14:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975AB6B008C; Wed, 17 Jun 2026 14:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EFD66B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:06:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDB47140558
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:06:08 +0000 (UTC)
X-FDA: 84890183616.17.8EA86A2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3F9DA1C0003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:06:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oseQyoO5;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781719567;
	b=B4T9J4ueMo/2GsHVOvKlFsZ3MPqTBYem26uxHnO/GIXNX8upnCfaAC7uOvkj7cCwe62iAI
	9JOi0KUWxXYw8UfW4vnutJcz5H28LRnjz1cOQwKsNGze3TWW4KcUswzfObbB5ErCulnj1k
	kq39E+yWjUmX0wBrNNuTRs9TQZTyJgk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oseQyoO5;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781719567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8HmsYzoZQB23PlhcgNC/p2emSesBqDNqnHdSEmq4pXc=;
	b=AJqNCVoTfyMTvzg/QGrkdJEa2gbu1B30aEO6brIZ1n4/ewHoQch8+4cj1jGcgZIW/kTFyZ
	kFbY0dU77WrZUUPyAsAXD4GPW6o5t+XPaNL/J0as1DGpkDj8Omb6joiaa33BIp31LD3oVM
	KHNQgeZLVu16IRlaCqoPlkeTYWU2u2k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=8HmsYzoZQB23PlhcgNC/p2emSesBqDNqnHdSEmq4pXc=; b=oseQyoO5dOEA2aW5Hcuigc0nkG
	4Ebjp8OW3jnS0aaihRNqURT6spTs13E+KA7T8clX1gs52d5h5ewuXwdNkrFI2D5uNO4wuO2/J3f/x
	jWn/8ZboZZNIqnx/HAIVFWA72bjbOPVlEDYc5Krs1prDX6MuuuZGMBVk1uI9SBl/HyXf/DkM41WSP
	hhici8YaoU4K8VozscOKjoZ0yXoGpGdvqkAtxAYYJTkhhEOw/DajQX/Mfy8itFVOvfdjn7JaCR02y
	HTm39PPoYosOU9AhhvsjJkmm7ZacRE8bQye2POS4m3Om7VP61xYtm2CLeM7GCvlazmOLzdnayXDEu
	sIhufVbQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZue6-0000000D4EQ-2jof;
	Wed, 17 Jun 2026 18:05:50 +0000
Date: Wed, 17 Jun 2026 19:05:50 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Rik van Riel <riel@meta.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, Rik van Riel <riel@surriel.com>,
	ziy@nvidia.com, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Hugh Dickins <hughd@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: khugepaged: free xarray nodes left behind by failed
 collapse_file()
Message-ID: <ajLh_pdGl5xea5dM@casper.infradead.org>
References: <20260616145413.1491961-1-riel@surriel.com>
 <ajFrxhGf7loEHUeX@casper.infradead.org>
 <8a4caadc-f414-4874-97d4-2fbaebe2af39@huawei.com>
 <ajID7ZpnBYOucAVz@casper.infradead.org>
 <CAPkx9x3BV3vMh8d8P36wCEOYRshRobT1G0Q9v4h1OABj1ffS=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPkx9x3BV3vMh8d8P36wCEOYRshRobT1G0Q9v4h1OABj1ffS=A@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3F9DA1C0003
X-Rspam-User: 
X-Stat-Signature: 5cfc7z9ogr5zrqs7toiyohc4cxefum5o
X-HE-Tag: 1781719566-751606
X-HE-Meta: U2FsdGVkX19P9IoK57ioxNiqgtnlor++PsyL3DweT72SIqkLBbVs+jjoDK3mM7o4DYDgaKPh/wzmF0TnacGtVawgjCiyg49IWdjfSD9mOT55IPM8ZTysjdIs5TtRtnRbVzinayt7+TkR0/MPulECHpZqJc0okr4XEtU0LHeeAgZ9v6WYh9BZnKzBZqLbVRqqSfyF7L6R0WPbFttqx6pTswJ+oABS/3muVGyCi4yjzXd6Aio96b2UsZtlGXUdoyx6AF6LmQKx1TLjbxvB05+VYMFowUZYnLRwSEECQTVGW9vlFuB/XnY58N2csltxF5qjt/INQmA+qAWLcTM26c1yigo3t/I+xvQqbpvOLiyXitPXlaBVvOO3QSkiPgbXZOGPw6th9Hs6jnFdIvy92ZtDVPCy9bE3/eUul1hcaFBJzQst/aUAMsyxRUIkXjBKs1rc87QhzUjtvuGSCEgQJpR05bATUGJ2gAYQwE7fhMNNiQtCWPx1phtBJG72t9AXnVueJo4CNlQ8MdFPGBrIyui6Vgd/MV3e9sWNU3sprvRDLT+I01lZlqnCRlWvtYS283CLqbEuyrb4B4VH2TgH/OqdGCR/3bEgMBpirCvXRsuvRHb6IJZyGgXdTkfwP9n+gHdQpLtEt34VqUAW2gWelpyNI1N2F/8JorbxrK3KBNxn6aU4QIHAWcoRclr5fu1U4whtdg5jCwEl8bbh/98sSs+JmyVRZPe8iLql+7OA7+m0oBSz1jVZukKhOqER3Qe9i+k6c+uie7c7cgBJ26r7XIurPHvF4ZUEUzpKBdQwyOvRDetfO45ZTz2hVsY41drYzBEgu/TfNy2VHbdfBULDWR1Dp6voMp0JRybOmRlPdgjCjulNgp9zOliPhmrGOq6NktdQrmGJVCR2lfGZyI+68+d0OCcOuhxt4vPQ1Et8IEN6j0IMAm3sTxakUVwhUR6XY536+RrTGYzBQl6bzdGsG2V
 c2bNROYe
 uOXXQ+LRUL3yTOSHNoLC+SbhAJltHR0CxEmooil9ZFsz14Vn5X3UcgInXK4Spv3cV5s41jKm8CEuAEzODZj5iXTrz5NOsnLr1pBlodYAhZA3zFS/bg7w7yVxPzbGWORMDgSprKIXoUUpCJ12+CDiZ+f0Gh9cDhxkbO5sP1wRdltgJ4tjcsus5GAo9P9d9J0HeYFTOcNrH8Y9C8iJogykVlHjncb190NqQwYFVNDPP3WBPE9J+28vKnBuPLimwWBUwgrpJrF4sQVAjuKc3OXybAP04IzQ2oo5LF4I1+tz2Ge/vHiI4zI1jFjzp6PSWOgWVwnIEFV4GZuokxVdMP3m+ssvg3L6+O8SkRKXAclewiZqXfqpCmYPt8GXkRPpHkSSw+aJja0na3q1uph8bHyK3X9J/BQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 11:40:28AM -0400, Rik van Riel wrote:
> On Tue, Jun 16, 2026 at 10:18 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Wed, Jun 17, 2026 at 10:00:59AM +0800, Jinjiang Tu wrote:
> 
> > > I can reproduce it easily with following steps. [1]
> > > 1) create file /tmp/test_madvise_collapse and ftruncate to 4MB size, and
> > > then mmap the file
> > > 2) memset for the first 2MB
> > > 3) madvise(MADV_COLLAPSE) for the second 2MB
> > > 4) unlink the file
> >
> > Yes, but is there a problem?  That is, do we need to clear this up
> > before we get to clear_inode()?
> 
> If there is no harm in leaving this xarray node hang around until
> clear_inode() time, I agree we do not need this patch.
> 
> Are there no issues with large folios getting inserted into the
> xarray at a later time, after zapping little ones, and leaving
> the empty xarray node dangling?

That's not an issue.  The code which handles this is in
__filemap_add_folio().  You can see that we handle value (ie shadow)
entries here:

                xas_for_each_conflict(&xas, entry) {
                        old = entry;
                        if (!xa_is_value(entry)) {
                                xas_set_err(&xas, -EEXIST);
                                goto unlock;
                        }

(this loop will iterate 0 times if there are only empty nodes in the
"conflict" area)

Then we just do xas_store() which will overwrite the nodes.  That calls
xas_free_nodes() on any nodes which are overwritten.

