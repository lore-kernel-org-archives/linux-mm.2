Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4E6D606A336
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NSUWMCON
Received: by kanga.kvack.org (Postfix)
	id B2DBF6B05BC; Mon, 16 Nov 2026 09:46:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05BB6B05BD; Mon, 16 Nov 2026 09:46:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4B56B05BE; Mon, 16 Nov 2026 09:46:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6676B05BC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:46:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF9E61C006D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:46:15 +0000 (UTC)
X-FDA: 85441257510.22.5A9AB18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 227BDC0009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:46:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NSUWMCON;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794840374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1TKepG6bSQCmMoOOE2pLJEk7bMmD610l+iZ3D8b1os=;
	b=JG4h0ss5jnG/G/roiszZVHoW617YpGL2uso4mEkGYvUyRVOrGEX90HB8X6duqoAGq2jclm
	TdNb7oOjPXVBl7IyVmGPxms0vANMei13zmmkTfLG0ETQOH6Z9lg/7G3IEhZVgLaJ1pX0Oy
	4kTXPRNzn4jd6jlfqB/zSWNrdHaiNPo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NSUWMCON;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794840374;
	b=V+Hp/bIrqPmRfWRhgfNgWggYxuf5BdhqETmBLHuI4L1wlwPyW5cnPhz9dHuk4mcmHeGZiS
	qFpct/Tx4zEjKCkK33QGJ6mApn1cbpt+BxQVAZ5PkZr23gBGD+ZrV3qIqpw38z/oNmH4vy
	/87lwHr+HJ7B4aUY8FpqOXrwnRCH5vo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58E3541A91;
	Mon, 16 Nov 2026 14:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E20D1F000C5;
	Mon, 16 Nov 2026 14:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794840373;
	bh=A1TKepG6bSQCmMoOOE2pLJEk7bMmD610l+iZ3D8b1os=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NSUWMCONHW5TZYpCllA7NK6vndBpf9VhuU9DXiPMvvKEKZDyX90k8J/VWsGhxpo1c
	 K70AexWVc8uj7NQ+SNrbPocqq2lly3wP11icpBnvvFx7TMeAjkA2cLbvy0xYA9c8Zw
	 9PS+KEd1Li/3izSHVgf2JrXIqXGMzeK4A2BoxW6Hi2e550tHx6kJINM8SMygsFgb0Z
	 nUEMfW6TS/2TGexBtvIDgE/1eZaAxjxEsctZyXS4ndAwO6HSGxEWXyKg4cjvZfic2M
	 hHHmAD65quU/1XuCZjeqov1gxvH/ryB3oPHL91tpwuS+KzVBrb7eWRlhynZd7XKqSg
	 fwdCwywl48bkw==
Date: Mon, 16 Nov 2026 14:46:01 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Tal Zussman <tz2294@columbia.edu>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Chris Down <chris@chrisdown.name>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, =?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/12] fs/proc/task_mmu: write-protect device-private
 THPs in PAGEMAP_SCAN
Message-ID: <avsWjwI6Vp3-J8F_@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-5-00713d368976@columbia.edu>
 <avYQteUm963AKJQ7@gremlin>
 <179454650651.482102.17667443707760097412.b4-reply@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179454650651.482102.17667443707760097412.b4-reply@b4>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 227BDC0009
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1pc5dawmud8nef6bdx577u91robogdrk
X-Rspam-User: 
X-HE-Tag: 1794840373-844205
X-HE-Meta: U2FsdGVkX18CwWMwmpCxZWZgX7MGYUlyQbEqqTa0Tyi8YdVskySzR6j0qS+t0LH9WtfCPnVeO7ggqwIuyB3qAwdOkGPoyKpncSTY63SsK6D8K9wzwfBll0FTsrnEraAsESYIEjpoHLVrKM+PcVDDVs2VY43h0S2pjulO1IsOeOd8VfYs+630xtrf00O8QWcZjN52h/k+GmHOKDUppQqM/S+Scn+BrocirNS86+btGitO23XpCohEmMrww0Lp47Y1uNr5NU9GIEcrN2a3vTDTZx2Hg6dAN+oxXZnS49vsUY3oBRRiSW5toTtrroQTBiawIdq0RG4cieYIEKCZpVdIV0kUZK7N6VOFZhjyYyd4RqxX66Ih6NH6tPGjqQekFz+53iAwVjIqe/x4J60V/u7SzfFP0hSYjC8tq+TFWrLVMYSuhie6O/6H9tbXUlHy6kO6yhoCyNoj1v7VAS1ghnygTfN14j59ixSWGBTWeApcYgNTR+SiqC2gw1Zf486UwjHLTyL1gAQJPXjOz6hEHl3wXDdpchOIrvGWd5OUVTutd/lz5RXJXNp7IIPALay4DX7Mh8f6PF5vGAELSWsDl6c/C+Sr7tncKkf++AsE801LdxH9kx3jYOQRu3I5t+Ohn/11d22xJC0HYc69K0uquuO7gMYbqbfI0w+hi4U2LKbq/8a7IDAIAaMH7n676o2GJKfODchbkoc7W6UOC64WFRk/KtImgdaz6oP3Iz49Y4mAS4LVRrzbXgDGE2OFDW71+U0rrMkDTECYa3qgUgyrm2tUVodUY4CB6hpn1koEpp8ZKrsiZjlSBpyl6G6iYmEpffqgyDz5Gd+ppPIFwQV5RbpwLTuBKxQalBaEKCvNieWJCWcIMUcOmCbcGZRaDhPfDMGnnRzlgiZdi8LOgA4NH+U1tygTcW7Soc39B1GoBJ+oYW+lWh1jAowWPeG9Q3ooI8hy1dYipuFHd0u51ozgq12
 mvVHQIn5
 nS0BWCXKZ6FP94WBPGjmsKL87fZf34P+Rbad2RR/AoUH0hQHmPp2pHDApenFj51SpVRUJ2IlkGcIPgnkhqK2BQH/C8UuhMtUgeqZUIF//5LziRGKAf2T12FkPOunMuh97wt7XzDs9o/s3vJdHhEtsqAXb7tbNSKMN5r04S3oHjhVqLJ3WpC0KJ6zggWYOwAzaIO33ZpPVam1Xcw3Ay94GGDpFwigenRyZ/b+SOJt1YIAreiy+lEsBQO65TL0WT5aUC5WEZmEeL2RyTKkz0/fXWy46NMZH3qnh1ijsH1bUwNtevAe3lfJBc6dRim671rdWX9aIVIrvE5/BQ43lznqN/jTDSaUOeEuEohcr2yIa31DPIR8cg98BCZVQGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 12:08:26AM -0500, Gregory Price (Meta) wrote:
> On 2026-11-12 19:34 +0000, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Nov 11, 2026 at 12:55:13PM -0500, Tal Zussman wrote:
> > > but does nothing for a device-private THP. The PMD never gets the uffd
> > > bit.
> >
> > Sigh yeah. Device-private feels like another 'just have to happen to know to
> > update X million open-coded parts of the code'.
> >
> > We really need to find a way to abstract this stuff.
> >
>
> I've poked at it a bit, but zone device creates this issue in many
> places. The core issue is really that softleaf can mean 20 things,
> and the number of things has been piled on heavily.
>
> I don't know how we solve this, it's just a rats nest of complexity
> at this point.

And you are our Jack Russell? ;)

TBH we need some generic handlers for softleaf cases. The fact it's
abstracted in a form that we can describe clearly it might be possible to
pull useful things out of that.

Like:

	softleaf_can_xxx()
	softleaf_should_yyy()

etc.

Ideally we'd have entirely shared page table code but that seems like a far
off goal esp. in the face of the schloppgeddon.

But in the meantime maybe we can use semantic helpers to at least
generalise the glue between softleaf X requires handling Y?

>
> --
> ~Gregory
>

--
Cheers, Lorenzo

