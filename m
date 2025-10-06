Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69390CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 13:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64EF8E000D; Mon,  6 Oct 2025 09:13:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3C6B8E0002; Mon,  6 Oct 2025 09:13:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9791E8E000D; Mon,  6 Oct 2025 09:13:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 876128E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 09:13:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2755F87A7A
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:13:20 +0000 (UTC)
X-FDA: 83967730560.15.66E21D5
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7FF3D80015
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:13:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=l3eGI8Us;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf30.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759756398; a=rsa-sha256;
	cv=none;
	b=SWL0uoM8J0ntZz+qzb9hgQ3kXQJHs0N4QRjdL5vzstdXO33lPAtPeOlze9dVrRuYy31qJ+
	YDC+UlUVQgHXEVrJYF76eiay3ve/QrOJJc/q1DEs8Gt5iSbxOJ7FHK5mqbtbItzQP8u4rO
	q1sFCp88meF51PgxdUkPafSPY5V0KwY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=l3eGI8Us;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf30.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759756398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hr1104ycRcsIOhou1aWTfKsVmRoAhTvW0HOxhU8+Ze0=;
	b=w7y2P2aTb5qhZ5uTliFGfV+19MjV40Rv6e7zNd85sjBf/HlTnugAET2ur+fvGxExWwbltS
	OJnOlTU7OqIxw8xeYPorDq7OlhzsESUBJe1mpP8CJ+lfsvJQHUSOpWdwD1xtRc0hmooCDz
	FDHycw0l72xDZi9n7K8N58UDQSDVi0o=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id E921E92EFE;
	Mon, 06 Oct 2025 13:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1759756397;
	bh=hr1104ycRcsIOhou1aWTfKsVmRoAhTvW0HOxhU8+Ze0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l3eGI8UsFrKDophnQmoitZ7Bot8B/Y3z/mfTGaDPGlYmKV4M3WyP2Y6ILAxAzzPfU
	 y4ogsiKwug6iSlcJkWwJwBecKxAN5FMxZ+wvGszHOg6iy9UxLcBvzrmTs9tYHuqs1V
	 o5dxZeOKkey/PoHSciSxIJ+X0jYVCd9ZCtsVEcXI=
Date: Mon, 6 Oct 2025 13:13:15 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: skip folio_activate() for mlocked folios
Message-ID: <aOPAay5im1lJhHFm@shell.ilvokhin.com>
References: <aN_bix3wDpwYPoVp@shell.ilvokhin.com>
 <hnpzad4aehmp6ncgwhlinzx55z3zst5dlkhsjphpazccy5lzpv@hfj2eyewuplz>
 <aOOxAtD9oeiYlo7G@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOOxAtD9oeiYlo7G@shell.ilvokhin.com>
X-Stat-Signature: yt7bq6y8jhbd453drogp8msd5zwz53hq
X-Rspamd-Queue-Id: 7FF3D80015
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759756398-902311
X-HE-Meta: U2FsdGVkX1/WrWb5/xgUJ+bmENHvIrgkOttTvC9rarF7T4eKSLZe26uSWp5uqrY8/vJHEEBtw60TiJUtN88o6sFRnWJTCznq+NI7dbvHtJxdzHRNd905IZtNtMs/EMFvct7NtC8F1F074X+TUjnPKnBbcm8ZlYs8TsppRL6a/iDqCuo5V1HfDBorM+cm50mGrr9oicIOdgsQ1bYS3peR8kMHHgWC4RWST0nh1CWhqLReLXOpGribeuzooHDBmTMSKC3sMzr2VOgboYNy8GSYA8NuxqZwZZNyiZb+dMhdtAhdzn25FGAguUqsgEi7R+YbYjkTc7gma2bFYvAXCY1GDto1O3hfM+PCU92HkfsMAE4e3VTYMf/lDQ10w+8iSQ7AIf7DpdDXMV7+XhKVxY4tc/9Lzggu3qhXbKDb3QPvjOaqyEHtvURBaUQbSFLyNp0o0NM3npQh8EipUU74n5/ckhuGD33UCWbKXlHbcKnLLBSiaCfyV6K9PMgq9QNOIf3GUeOolXLUcSAarJsxQb2cgJWFH8uVeC4Q/4TQnwvX5sjaupfHQ+suo0wVDhpBbSE1qJrbxdhVcJvpQksegzKzhZNyPTT7yFF5IkKfvGtJZ1rgDYmNY1IQfPJIZv36X73eHtnbMiATBHXfaklRs+o4tLbk7Mvo5OSEPLokl/HVVp6g8WrV84woG7II+okxpCoa3R3VWgzmja7MP6xGiA1pMjc/+dYCPjlZLeRmjmGu5P8K9TxC0nZJSbjaCnlT4PrkP4Keh/lCKNHOH3krIaUifYT+anl+0XuAiBCSJULuzRAHPq0LMF104NcMiR4k+ab5HjVXyYpmF5+8wJXAxI4VJ+dHlucq0m+4OKVZg+uHqSr550VfWlfP+TRlysrmc7L0++O0ty6srtESYdxEIBpTT/s2vJmIzw2jW8cFt5xujOWmlwdRtYtVxffIqMCFADZAgom2PI42Xd0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 12:07:48PM +0000, Dmitry Ilvokhin wrote:
> On Fri, Oct 03, 2025 at 03:41:05PM +0100, Kiryl Shutsemau wrote:
> > On Fri, Oct 03, 2025 at 02:19:55PM +0000, Dmitry Ilvokhin wrote:
> > > __mlock_folio() should update stats, when lruvec_add_folio() is called,
> > 
> > The update of stats is incidental to moving to unevicable LRU. But okay.
> > 
> 
> Good point. I'll rephrase commit message in terms of unevicable
> LRU instead of stat updates in v2.
> 
> > > but if folio_test_clear_lru() check failed, then __mlock_folio() gives
> > > up early. From the other hand, folio_mark_accessed() calls
> > > folio_activate() which also calls folio_test_clear_lru() down the line.
> > > When folio_activate() successfully removed folio from LRU,
> > > __mlock_folio() will not update any stats, which will lead to inaccurate
> > > values in /proc/meminfo as well as cgroup memory.stat.
> > > 
> > > To prevent this case from happening also check for folio_test_mlocked()
> > > in folio_mark_accessed(). If folio is not yet marked as unevictable, but
> > > already marked as mlocked, then skip folio_activate() call to allow
> > > __mlock_folio() to make all necessary updates.
> > > 
> > > To observe the problem mmap() and mlock() big file and check Unevictable
> > > and Mlocked values from /proc/meminfo. On freshly booted system without
> > > any other mlocked memory we expect them to match or be quite close.
> > > 
> > > See below for more detailed reproduction steps. Source code of stat.c
> > > is available at [1].
> > > 
> > >   $ head -c 8G < /dev/urandom > /tmp/random.bin
> > > 
> > >   $ cc -pedantic -Wall -std=c99 stat.c -O3 -o /tmp/stat
> > >   $ /tmp/stat
> > >   Unevictable:     8389668 kB
> > >   Mlocked:         8389700 kB
> > > 
> > >   Need to run binary twice. Problem does not reproduce on the first run,
> > >   but always reproduces on the second run.
> > > 
> > >   $ /tmp/stat
> > >   Unevictable:     5374676 kB
> > >   Mlocked:         8389332 kB
> > 
> > I think it is worth starting with the problem statement.
> > 
> > I like to follow this pattern of commit messages:
> > 
> > <Background, if needed>
> > 
> > <Issue statement>
> > 
> > <Proposed solution>
> >
> 
> Thanks for suggestion, v2 commit message will much this pattern.
> 
> > > 
> > > [1]: https://gist.github.com/ilvokhin/e50c3d2ff5d9f70dcbb378c6695386dd
> > > 
> > > Co-developed-by: Kiryl Shutsemau <kas@kernel.org>
> > > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > 
> > Your Co-developed-by is missing. See submitting-patches.rst.
> > 
> 
> I followed an example of a patch submitted by the From: author from
> submitting-patches.rst. This example doesn't have Co-developed-by tag
> from the From Author. That's being said, I found both cases usage in the
> mm commit log, so I'll add mine Co-developed-by tag in the v2.

Turns out scripts/checkpatch.pl is able to catch that with the following
message: "Co-developed-by: should not be used to attribute nominal patch
author", so I'll obey automation suggestion here and will not add mine
Co-developed-by tag here.

> 
> > > ---
> > >  mm/swap.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/mm/swap.c b/mm/swap.c
> > > index 2260dcd2775e..f682f070160b 100644
> > > --- a/mm/swap.c
> > > +++ b/mm/swap.c
> > > @@ -469,6 +469,16 @@ void folio_mark_accessed(struct folio *folio)
> > >  		 * this list is never rotated or maintained, so marking an
> > >  		 * unevictable page accessed has no effect.
> > >  		 */
> > > +	} else if (folio_test_mlocked(folio)) {
> > > +		/*
> > > +		 * Pages that are mlocked, but not yet on unevictable LRU.
> > > +		 * They might be still in mlock_fbatch waiting to be processed
> > > +		 * and activating it here might interfere with
> > > +		 * mlock_folio_batch(). __mlock_folio() will fail
> > > +		 * folio_test_clear_lru() check and give up. It happens because
> > > +		 * __folio_batch_add_and_move() clears LRU flag, when adding
> > > +		 * folio to activate batch.
> > > +		 */
> > >  	} else if (!folio_test_active(folio)) {
> > >  		/*
> > >  		 * If the folio is on the LRU, queue it for activation via
> > > -- 
> > > 2.47.3
> > > 
> > 
> > -- 
> >   Kiryl Shutsemau / Kirill A. Shutemov

