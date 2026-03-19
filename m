Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7103D109024E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81ED6B054C; Thu, 19 Mar 2026 12:29:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59346B054E; Thu, 19 Mar 2026 12:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C969E6B054F; Thu, 19 Mar 2026 12:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7F256B054C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:29:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5742EC21EB
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:29:24 +0000 (UTC)
X-FDA: 84563347848.25.554D2E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id BAD764000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:29:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aF5DbFFA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773937762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Ku+TdKpBZURjVYJYXwssaAgRT3caBmSnlPF0+O9uHs=;
	b=CC6RSz2sobOCZa3XROuR55QNd71Wi0lCyBs1Q43rk30e7v6p9LTePXdNUGFD4qrU7JUh+y
	X7U+LqzOC/0v6rHv9fNvaJ/PSPCKnPyFkRjZ8wUWoHMqY+CSRxlZuogSV8vpDFggtrbsW3
	K63pYKzy3aOoA6C5JWOsMtOU/m6oON0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aF5DbFFA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773937762; a=rsa-sha256;
	cv=none;
	b=4sVxYKRW0Gp2OBfzvljSFk8GM14YMylwTjs2+U+we1Xi7owI9hpnL9F5VGSKWJatyVCVZb
	Xo1w8ZTmDmgaES0uLQ4rB2N965YVPopFnH0jutKFz1pqr/+lgeeKZ5y/KLxy4pXmNkocai
	1yo57qqBvKC3qrupG8NpubR/FBC01rQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0ABB0600AD;
	Thu, 19 Mar 2026 16:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248A3C19424;
	Thu, 19 Mar 2026 16:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773937761;
	bh=i5FY2xFUG82H2mxUurUo54YyYFYdXZArEFQEN+SDOy0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aF5DbFFAnHCvzhvJhT5dGtrQoRtJ9QNrqQlmJnbfZGodcTPOczAfqoQkVJIF/LXmE
	 NRUWZ3gYSMcre4wgwUNw09xxVKFI5Sgemkg2LAotinZjLLwX4iM1PGYkctTph/RumK
	 vZbtY4tdz04aVkTwegcY+ogZdGqZvTefi0axkcs96JyYYbbFlBfs82HELbk8bZzpWu
	 r3XKupXWro4jRmoWCi9Q8Sv10Og+jz9lMJHhwiLehTvhEzP5QW3ShgVjN49nGeFKrY
	 HHr/eCyrr+oVH6Ygchgg5RWipe/5nmkCpI4UsgYg0JGgzQb2ofwBsZCXqUHlfYYlJr
	 B/ySfzNIrgg5Q==
Date: Thu, 19 Mar 2026 16:29:19 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, 
	linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v2 06/16] mm: add mmap_action_simple_ioremap()
Message-ID: <939645bf-50c3-47bd-8132-89acf95056c5@lucifer.local>
References: <cover.1773695307.git.ljs@kernel.org>
 <1e58aaf3cdb61cc317d890c12c9a558dfc206913.1773695307.git.ljs@kernel.org>
 <CAJuCfpGocCSRT0yDxPOLg2NZ+W_ZSTjHGPZRKBd3U90=sQtHCw@mail.gmail.com>
 <330f3614-7dc1-4e80-96c4-8472b25108bb@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <330f3614-7dc1-4e80-96c4-8472b25108bb@lucifer.local>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BAD764000C
X-Stat-Signature: ahdnhx7a9ym5j48pfh7h7adwwjxuohj5
X-Rspam-User: 
X-HE-Tag: 1773937762-282292
X-HE-Meta: U2FsdGVkX1/6HGfBF0qPuGbKEonAkFR9FScqCVhWoAHtaff5pb7UJdC8Tb0NpNoHJe92t+Q0rkNkq+ofPEsWg6P+MVIeN4rmuyQtklJC4uYM7o6je6yZE0SuRMCN/ipXoRPQe2V0Y7XGNyF1jKZLZzV4P7fVSYBA/pbi4sWmlyHWkZKfCOc7+IPp+nTjWL9NDydCJrrd0vb1VEqvepxYhVPBSquASv2dgbtYCCs8XthH6sssLXn7a0w3wjEOGNCxmTJSfzpckxio1n2kx5B2LDWX2Uoi97cTw8n09vLs6eQC9/D+U+HT3+kp5e6dIxl2Bu3iqCqQAWgPiCPjMJux0QWLgFqDGO40nPnBfCYtBKqNAQODVZAm2BuTGdsfCmU81NqTvxt0YwYWlh/yaZB1SamMGrQGY2sjI6foe4XEfMGYO3geXixMmP4WGvdZ7BWWa/6cyXzv7cSMa0iiDLNKs9TVAEpbSxisWDjyOqkozc++wON0vC9ICVx/oruiaPMhyu2uyhA2Kqr4cDL6SBsgw1wSJAQOjtoOTD7qVdt27yRp+EqWjfBoS+plvkuJ+s2XXtgxY3EPCFv27+eMVsxbirB0EI9luata5yNkpQtoApCsIGcx4EBF5yKOYQtYfXUuQX3h/jvICMa3hhZJ0fw9Qegce8/t+HV4l9mW7Zc4pTPP/QWsapb3lq2tOLzzfCQndjIAjiq+ol7zFnEdmIggOFoavfN2s04q4R42fdD+Zi2CDLRGonKzBF9xVLsTk6PWPb/iWQz0slNGxS/nj+UUmjhbUcZEs6piZ3LQot0y+hCU81c4Kdei0CJkwkca7ac0ILMdMLm+0e1bSv5/mIM86hbWSsmWK59WZVk28DAaRKHtewt2+d9HW0pKJXFBHKTC8kG++HqoUC1+gomPVVhd4XU2GNmoLK9VZEchdmvgIiIGpzBMjMfXfEY+ODluX2wFGC2RCtL4wVf5+/rhlbH
 Pe4b4tKK
 PpQPwx9RYskxPNDHoyLfrbFM7Du817vxQsa7x0m+kJIKHquBa0lI87rodCJRk7EGxpXobqoHvHM3JsanZBimWb/grOejujGq1B2AYn+rHpY9X410s6zKXcRZZqpc4lJjoA/QAzNLVRYHLI0u1nVTWW+4LCp+lKm2OJnglhNJFHBF9fp0oE0KtJHnKv3MGLOMkSh6HGN/j0O5YiRpl/Jj9zxFwF1S8yu5eLtpVqBcJ7OUfSOdlfNiz3S6HcsKB9qoikNy4YSJa81Yh48DfB3JnglC3vc8vtSVCRZ5SvvAoBuhPB8WOoBpe3dRDqx1MvAziAcOhwVZx1XBCDNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 08:39:25PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Mon, Mar 16, 2026 at 09:14:28PM -0700, Suren Baghdasaryan wrote:
> > > +int simple_ioremap_prepare(struct vm_area_desc *desc)
> > > +{
> > > +       struct mmap_action *action = &desc->action;
> > > +       const phys_addr_t start = action->simple_ioremap.start_phys_addr;
> > > +       const unsigned long size = action->simple_ioremap.size;
> > > +       unsigned long pfn;
> > > +       int err;
> > > +
> > > +       err = __simple_ioremap_prep(desc->start, desc->end, desc->pgoff,
> > > +                                   start, size, &pfn);
> > > +       if (err)
> > > +               return err;
> > > +
> > > +       /* The I/O remap logic does the heavy lifting. */
> > > +       mmap_action_ioremap(desc, desc->start, pfn, vma_desc_size(desc));
> >
> > nit: Looks like a perfect opportunity to use mmap_action_ioremap_full() here.
>
> Yeah can do!
>
> >
> > > +       return mmap_action_prepare(desc);
> >
> > Ok, so IIUC this uses recursion:
> > mmap_action_prepare(MMAP_SIMPLE_IO_REMAP) -> simple_ioremap_prepare()
> > -> mmap_action_prepare(MMAP_IO_REMAP_PFN).
>
> Yep, it's one level, I think that should be ok? :)

On second thoughts, it's silly not just to call io_remap_pfn_range_prepare()
direct so will change it to do that!

Cheers, Lorenzo

