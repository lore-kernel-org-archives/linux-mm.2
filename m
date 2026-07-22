Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCEB8C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 12:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8BC6B008A; Wed, 22 Jul 2026 08:50:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0106B008C; Wed, 22 Jul 2026 08:50:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DD916B0092; Wed, 22 Jul 2026 08:50:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5D56B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:50:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A68E61A018A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:50:23 +0000 (UTC)
X-FDA: 85016395926.25.0B445ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1A56418000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:50:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=km4jXblX;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784724622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KeKyLY8p+R3goFIELc8d+Itcavb+BZ5wsH5llzH8q7I=;
	b=zVRBSsltK5t09c67/I+EFXcti6KYlLAprTdVu4q/k9gT2mrOKrhVjtuA+a6F4RkMAUYKyA
	8D4/GQH19z0ZmIBtyZdMdAYyOo1xaQK6pvfxuCcBbcUErYrxlTueWOeDTDIm4/JLspCilt
	qTi+zsQoEUPAaX26eKx+YIxzfjKBKmc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=km4jXblX;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784724622;
	b=pePU1zQ+ipxHjCRisDOC1DgLzwvETss0qIZRxg1+Tb8/UAcoJwNP2ZZeptVT/N7kb2JiYQ
	JVsLZTiHnkPEfkavi0u+ZOWEqmmklR1TSV/6N4+GxmRuf7WyWMkUCyjAuslfXU1kibI53u
	SRQJZWP9lqtEYW9EaYky+pw22+1Ckbo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B08C600DA;
	Wed, 22 Jul 2026 12:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C301F000E9;
	Wed, 22 Jul 2026 12:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784724621;
	bh=KeKyLY8p+R3goFIELc8d+Itcavb+BZ5wsH5llzH8q7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=km4jXblXtMqHV54MzRwH//7c5eqW9dy71GCxJw1dDeoS5/10TgeXzFE8aWx0SG0Lk
	 l6wyHQpZOltPFilCAvzEdJFssBLo4+ge0lCR2xOee7VQKY1qwJpEBGXr5o5AYnv5wJ
	 3+DVeiiDhWoq1jt/0CdSprmeHH2pjcSkvvFyM8OsV+VPdF3hFUjXQcNNukURp7Cf2o
	 +sijjxZWn045XB5E7xXD7leQicASinabMIp4TSetHnSKOHq7515XlkpQnA4JthGdlh
	 PANB2lfl6Q7E7SV3LVwT1VByU1IPFPeb2OKvcH4ng+Gzd+yNr97J4ZQKZFRLJEL1Bm
	 6ZVtIXrHtYCOA==
Date: Wed, 22 Jul 2026 13:50:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: jiale yao <19888972804@163.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_idle: call folio_test_lru() after folio_get()
Message-ID: <amC7kzf4f0lRd_Gu@lucifer>
References: <20260722092642.1123347-1-yaojiale02@163.com>
 <amCSiltZolhgtO3J@lucifer>
 <75a79b54.8930.19f898e1ed6.Coremail.19888972804@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75a79b54.8930.19f898e1ed6.Coremail.19888972804@163.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1A56418000C
X-Stat-Signature: y4oixmugw9qxdm8tigizt36yraiophcs
X-HE-Tag: 1784724621-356552
X-HE-Meta: U2FsdGVkX194W6UutVezkFFPmP8b2Y6zgfwGCToEcP3YuLDesNFleRHh2HgoDC2ax/SzdlF102+8B17/X+k9a+gvKu/NFDNRI3VTsJ2m3KirdhHDorXyapyAvG3KAfs1OiXV4G7qJjPYJsTI9XxHLK1jsjLkc6taEZC2sDbkxcsC9S0fCjwyLSPkl3jD+hwcyWgwK28SYrIMsb0XhEEIYGXtBdp58sk7aHOKlukcY/Aw9VjIbVf0IqTrSAw826j+0R90jJbi8h4OfsqGb0RBT0rz0UJp8qfHLw9xP/+3NjqVD5E2Ya8eYjPRbkLNjSlwqWnvuuS2up9T+un8Dw7NCMALv7g8Lq9tkFaGVdaqr/PHrGccpEKssNdgVXcMiPs8bK+72GSm2HIZv6k5R6AO2GG22ZXog/bI4VY6VLYzujBNavOPkABEEzbzjijFDuc/+I6JOUQdbX/SPeIvYMw6lxkIeAQshFgVQ1JVLtKnloav3bueeS+qs+9Jc8/4zNk2zy8epNGNj/WD/fGqh1bnxVtRcmjxH6FHH2MjF6kFG8ym64Z1+leDNIg5koELq072cZDqO/LsNu0jq54+csqX/uKC1Hx74vz878Hp9ECBtVWrT5O41CCxvCT1WQ5t1KgfnSed/c89hXjemmkYXafsCVP6zld47QndjjzPbHjEdrU/0nuWly14Iqnqh/ZCuc6uJ2YVTDU/s4AHdaBT++oWBaZS2Ef/mos5bZvzBqWWU8z9QikxguFH0h0LdC3aV7Nq9GAjTMn6nqHTkw8jz/Hn8zctbr71fWJV9ljshjzUSXbjY9pBY9cxL8DSDu0byughpd9vtvBk+rMh5ZDHbHXi6Tgo8MZW8xwE8PzigyBdGj/ACNxiRBzypve9mz/SRFg+21tZ0kVGawA2y4mBQIDRGm8lZwQ3QSvFFJSDvReHraJOrYJ8mZ1UEpTtavLHnZCoMiXYJrh9SkekHchc9lx
 jTOac8Fu
 DZ/Hh153Zi2n8Vo7T0IaEglREGjGLK4mtXkrJG9s/pMEwnDnht2+rL+EHP/Tq5TQbKzjpM6v6U92DFOpzVxPI2NCwbjBd58boEMWcooHA0wMIe82z9jhKHM0ULfRV8tIXisXKzHB4icKvB+8JdGcJexOedpwxK2kJdZWkBGWtGhAWgBsTCr7Jg3vLdp1j9FjJoIHvhOHupTksvsoar1Vw6R1cGljqTmYPjXgFsKvZYV1rSgMbSAo8QypBYy6U6yNiRsCZl0O9UR5IoUHVWnqnjSnIOq+A7Mn62DTO63qHcphGgXNYnacaiFr0Ko6JJ9BpfaMNXAtenRI3qZuGHIKLk9t6e4BRQ7SBg5TxTppetmATO3KERBz6KSxPIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nooooo :) this is not how you send patches.

Also you should _reply_ to review comments, not just send another patch with no
reply. Comms is king.

Also - don't respin so quick. Wait a day.

Then send a v2, NOT in reply to anything.

Really best way is to use b4, docs at
https://b4.docs.kernel.org/en/latest/contributor/prep.html and etc.

But you can also do something like:

git format-patch -v2 HEAD~1
scripts/checkpatch.pl <patch filename>
scripts/get_maintainer.pl <patch filename>
git send-email --to="(andrew)" --cc="<list from get maintainers>" <patch filename>


On Wed, Jul 22, 2026 at 07:20:20PM +0800, jiale yao wrote:
> page_idle_get_folio() speculatively calls folio_test_lru() before
> folio_try_get(). The folio can get freed and reallocated to a tail page
> in the meantime. In that case, VM_BUG_ON_PGFLAGS() in
> const_folio_flags() can be triggered. Remove the speculative call.
>
> This is a sibling-path bug: damon_get_folio() was copied from this
> function with the same flawed pattern. Commit d6b8b02a27b3
> ("mm/damon/ops-common: call folio_test_lru() after folio_get()") fixed
> damon_get_folio(), but page_idle_get_folio() was left unfixed. KCSAN
> (strict mode) confirms the data race on the folio flags:
>
>   BUG: KCSAN: data-race in ... / percpu_counter_add_batch
>     page_idle_get_folio+0x7a/0x2d0
>     page_idle_bitmap_read+0xc9/0x220
>
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

this should really be backported, so good to find the right commit to use as a Fixes: here.

Also then add Cc: <stable@vger.kernel.org> so it gets send for backporting.

But _please_ wait a day before sending the v2 :)

> ---

Also in the v2 put a list of changes here (will not be included in commit msg)
with links to previous versions on lore.

>  mm/page_idle.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_idle.c b/mm/page_idle.c
> index 9c67cbac2965..b6c26a0ba3d5 100644
> --- a/mm/page_idle.c
> +++ b/mm/page_idle.c
> @@ -40,7 +40,7 @@ static struct folio *page_idle_get_folio(unsigned long pfn)
>  		return NULL;
>
>  	folio = page_folio(page);
> -	if (!folio_test_lru(folio) || !folio_try_get(folio))
> +	if (!folio_try_get(folio))
>  		return NULL;
>  	if (unlikely(page_folio(page) != folio || !folio_test_lru(folio))) {
>  		folio_put(folio);
> --
> 2.34.1
>
>
>
>
>
> At 2026-07-22 17:56:13, "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> >On Wed, Jul 22, 2026 at 05:26:42PM +0800, Jiale Yao wrote:
> >> page_idle_get_folio() speculatively calls folio_test_lru() before
> >> folio_try_get(). The folio can get freed and reallocated to a tail page
> >> in the meantime. In that case, VM_BUG_ON_PGFLAGS() in
> >> const_folio_flags() can be triggered. Remove the speculative call.
> >>
> >> Also mark the folio_test_lru() check right after folio_try_get() success
> >> as no more unlikely.
> >
> >Slightly strange wording but not sure why you're doing that? It is
> >generally unlikely a given folio will be !LRU right?
> >
> >>
> >> This is a sibling-path bug: damon_get_folio() was copied from this
> >> function with the same flawed pattern. Commit d6b8b02a27b3
> >> ("mm/damon/ops-common: call folio_test_lru() after folio_get()") fixed
> >> damon_get_folio(), but page_idle_get_folio() was left unfixed. KCSAN
> >> (strict mode) confirms the data race on the folio flags:
> >>
> >>   BUG: KCSAN: data-race in ... / percpu_counter_add_batch
> >>     page_idle_get_folio+0x7a/0x2d0
> >>     page_idle_bitmap_read+0xc9/0x220
> >>
> >> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> >
> >Yeah generally this seems obviously correct (TM), if we can't be sure a
> >folio is kept around any other way to the extent we're doing
> >folio_try_get() we should gate any actual interactions with the folio on
> >succeeding the get first...!
> >
> >With the unlikely thing changed, LGTM so:
> >
> >Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> >> ---
> >>  mm/page_idle.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/mm/page_idle.c b/mm/page_idle.c
> >> index 9c67cbac2965..29ee18f0e8ce 100644
> >> --- a/mm/page_idle.c
> >> +++ b/mm/page_idle.c
> >> @@ -40,9 +40,9 @@ static struct folio *page_idle_get_folio(unsigned long pfn)
> >>  		return NULL;
> >>
> >>  	folio = page_folio(page);
> >> -	if (!folio_test_lru(folio) || !folio_try_get(folio))
> >
> >I guess this was meant as a racey check...
> >
> >> +	if (!folio_try_get(folio))
> >>  		return NULL;
> >> -	if (unlikely(page_folio(page) != folio || !folio_test_lru(folio))) {
> >> +	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {
> >
> >As above, not sure why you're changing this? Seems unrelated, I'd just keep
> >it as it was.
> >
> >>  		folio_put(folio);
> >>  		folio = NULL;
> >>  	}
> >> --
> >> 2.34.1
> >>
> >
> >Cheers, Lorenzo

Thanks, Lorenzo

