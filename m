Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAA5ECCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 14:36:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368FB8E0083; Mon,  3 Nov 2025 09:36:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3191F8E005A; Mon,  3 Nov 2025 09:36:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22F2C8E0083; Mon,  3 Nov 2025 09:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 151458E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:36:13 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EC1B1DF61B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:36:12 +0000 (UTC)
X-FDA: 84069545784.16.FDCB2B7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id D6521C0002
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:36:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hu75PmCK;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762180571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bDJLzxzXeix51zzhX2vSU/9HiMumVsIUdwFwVA82G6A=;
	b=0WBgmXl89dRdANksZRjszcSY0kQ4eBqRLKtZJoeSpKkW1WoEGM0yCySKv/zEQZbTMaUA5f
	9RmC6uT6V4fK2JpfaZIJLnUahes+VqDY4KBQNYyTFvt6UJUhLDmWNt+VrEHm0fobFJPnnS
	EeocEah1hnYtThxIrzrBNLDgpJ/klaQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hu75PmCK;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762180571; a=rsa-sha256;
	cv=none;
	b=8EtFbGiJBeUGdrAXgmWUp/Q9+vfST4yV/uyyL+s3JmPchwvg7sAMhFnbpWKJIIONUKEwoL
	mpjn5fuTxPulouTnvCkfb9bx/8SzzwJC/mdmF8zy4NfbU1zImOnwiNUvpHFjapArTiqLIj
	f+dpPzaMqhZgYkR8V9mr18RKDELlU68=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bDJLzxzXeix51zzhX2vSU/9HiMumVsIUdwFwVA82G6A=; b=hu75PmCKzdeDR7snJfmgqiYskr
	4Y+walnvU1NsJgfJ12yFjqNQQ6z64Kt7zgMxH2HfwjtCBNQwrXHwQWgvMap+GK4otMLw4mg5AfVet
	qwHSUePwD1bMztaS6NBdgCU88ut4785Q4wVifQnfCXPkYVmGyySH/cIadqVIgWN0ePB4ws89Xg6Di
	BpDuY77NKwLBZJWM5L5uda8UtdQ5gy3vlhqkTvyAj3OntGYhMcRLfnvoxFr553Uw8MEWfSumy8GL5
	/7HDjsGlInDkOQeKkZ3JzXQddczmYxPncAru6jv/Jy8t2KDjxb5jc1EPJzu1Zge+u6IsLqIAmuKlp
	V58oCqwQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vFvf3-00000008v4J-1HNK;
	Mon, 03 Nov 2025 14:35:57 +0000
Date: Mon, 3 Nov 2025 14:35:57 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-ID: <aQi9zaPxwLBTneF4@casper.infradead.org>
References: <20251027115636.82382-1-kirill@shutemov.name>
 <20251027115636.82382-2-kirill@shutemov.name>
 <20251027153323.5eb2d97a791112f730e74a21@linux-foundation.org>
 <hw5hjbmt65aefgfz5cqsodpduvlkc6fmlbmwemvoknuehhgml2@orbho2mz52sv>
 <9e2750bf-7945-cc71-b9b3-632f03d89a55@google.com>
 <aQWT_6cXWAcjZYON@casper.infradead.org>
 <xadc6rbs7fkk2mb5b4reobqwue2kveo736r3wpa5zwted4daua@rgasjiwwot3g>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xadc6rbs7fkk2mb5b4reobqwue2kveo736r3wpa5zwted4daua@rgasjiwwot3g>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D6521C0002
X-Stat-Signature: co7ffxfyhuumep1zs43ocf6n9m3mo6cx
X-Rspam-User: 
X-HE-Tag: 1762180569-342404
X-HE-Meta: U2FsdGVkX199pztx+sGUDu6/oZBglGqdWmtnxcgqSmzOm9Pj33RvZen/moSkCxgZRpoUJwqIC6V6VuL+cldNkeq/MIItRbmm0DVK15eRJe+oSDdjF0bG9UZwg7aGtVtGJQ1qjS5r/FxvwOakaua7dnWHo4fa2uy0u8zEMPnOwg3ELSNAZmTIZrQA7ebtJ1ny+UvC+LMGYSDVjxsGggUM9x0ydktVbK4kqWw7HElK4zFkiIUE51WNE3aotKeCD81ropB6lUdtNWN0HMGa3e5Dw+xnkccKBcRxYnUhPwLc0SLwa5pK5Nta7xZQyi5vCFzd0+nPTolt2IFo8MgfhgM870FxYEp3W/TpwcscSKX6GXL2HLSM0m3RwpgyFXTIYddlKWPcnE3GxwDiNkyVumWHt+QGcjvcnwkPgmnt2cxpMmnBGYLNIn8+3N7S5TbjTMLn8+2IZnHOwyO3+nFKL+wmFfT3YyU85uSKlF+ISmF4C27cmqiFfxo1FndrW2/1VYtzd7w+8p4Hh0qE96yE6PRIN+ftxQWUfhjRYcNFa2YOvOqwHcu2CwSUxH07fk1MWvPz20852Q9Ht+m71sR028gXktNrzqhaaRyLCKkQJcspqf47TIxoaTFx0VuwlQAISzMXl8JMsOsm6r3iUw1YDF8pz4M7u+zUGufSZYilvkqEJui9N14JhKRYGsJ9TnAGb1Tb5Xx+T878WGPvLf1lZ/vrw9KfYlIFwhL6xgt7EmfNC2XFkXMAxiA4AOUckjWIUxXtoKcrGSBwZo3v0Rpei7f/D7ksdRlJVZsYh+UTeis5tgmxBE1NZ9MZFtH2iD+AxwF5Mc6XDYReRgUxsdzvW6w5PUakY82ERzhi7jR1p6P1tRTWr3Mg78OOXd9QaoOaN7PDjdIUXTX0vcSlnGgyTyvXRquUMu4ZvqVJcgOTD/CTIm5LoLnyhKBwvk4y7D4/rJKW8nMybmi40F3wrTg17SQ
 BRiNnEiy
 3mEDHD/K9K0P92o6KaTzGkF8FfodR4Z2F8t7eeoiBW7mMuvum1ULDd+cTmFDZ8mZVMg7JvWcsfO4QrjRz4vDAtIFy//1HMx3IHs4wh4tdL4JCgdnJCswBv9L2z8UUPdCa5sbJu8EVVKBJqaZttOUk2vHvM50yFiJyg1FsqUPkrnBGIHY4KFP60GAebSKhm2yC62coIAcagVkAqTlZWSWL/7z5ybew+2iqCCLUt40bZ0qyVesDCD501iUbLL/JW5le/D8ZSwrX0IRkZMvn5BwvDR/GefIapZ7xJzMP8a0xT5Sy9o3cbFD1GtzBlP/+djQGpkEAbMaYLlw2677+r1aJY11SV2Dr3FBvfDNg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 10:59:00AM +0000, Kiryl Shutsemau wrote:
> On Sat, Nov 01, 2025 at 05:00:47AM +0000, Matthew Wilcox wrote:
> > On Wed, Oct 29, 2025 at 02:45:52AM -0700, Hugh Dickins wrote:
> > > But you're giving yourself too hard a time of backporting with your
> > > 5.10 Fixee 01c70267053d for 1/2: the only filesystem which set the
> > > flag then was tmpfs, which you're now excepting.  The flag got
> > > renamed later (in 5.16) and then in 5.17 at last there was another
> > > filesystem to set it.  So, this 1/2 would be
> > > 
> > > Fixes: 6795801366da ("xfs: Support large folios")
> > 
> > I haven't been able to keep up with this patchset -- sorry.
> > 
> > But this problem didn't exist until bs>PS support was added because we
> > would never add a folio to the page cache which extended beyond i_size
> > before.  We'd shrink the folio order allocated in do_page_cache_ra()
> > (actually, we still do, but page_cache_ra_unbounded() rounds it up
> > again).  So it doesn't fix that commit at all, but something far more
> > recent.
> 
> What about truncate path? We could allocate within i_size at first, then
> truncate, if truncation failed to split the folio the mapping stays
> beyond i_size.

Is it worth backporting all this way to solve this niche case?

