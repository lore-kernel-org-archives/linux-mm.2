Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0316C44532
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 00:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5106B00DB; Wed, 22 Jul 2026 20:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65CB6B00DD; Wed, 22 Jul 2026 20:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D0F6B00DE; Wed, 22 Jul 2026 20:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7CFB86B00DB
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:49:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02C9BC039A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:48:59 +0000 (UTC)
X-FDA: 85018206840.17.E6EB936
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5ED4E160004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:48:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=axS+J2fn;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784767738;
	b=nPbw9kX+ncjJ7ZlSU8wqGLXPG2JQGblxg3gDBMWvqxHSaQmQELGqNM2dqA/ihvzx9Vila9
	k0x/ECw+JLMvjLrliGp1GtwNPK16ChQCQchhsI1cJ0JWgHxhFazxsUDvFy/nEUU3FbHgYH
	eQPWp2gMX4C8rYTY/SZQp2DAKCZy5To=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=axS+J2fn;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784767738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9S7H+h7uAEU0vg/ILZ1013Z2srwGSoOGwHV8pM1o8wA=;
	b=UFCQvWLcs9yEM7GJ9wc9H3B+5f7B1ygTk4jcvqbv41BWL0XZsQ1lcIqy0BoR0/OviiCHUM
	wlPcRpz+OZEni4ns6jOwXHerb3ST8ZGTOlyVgSlUKOU14GsvMZf+XOqkPGQUiinHd5QjFk
	nbiq7Gip6hPlIVc2iidyNxOv5XbflIs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9B19600B0;
	Thu, 23 Jul 2026 00:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024D81F000E9;
	Thu, 23 Jul 2026 00:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784767737;
	bh=9S7H+h7uAEU0vg/ILZ1013Z2srwGSoOGwHV8pM1o8wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axS+J2fn0q6OUHYYBUR8QBF/o85AgmGpa3mcDkITAQXHidSXSNWQhJnUJfL3REJHM
	 nP9FIUKhKCtX7ampRb/ViFylqR7+uVybbW/dDVsKIX5JBl4N8w9J2OfWiZauvm9YZA
	 1ckL+pvo60D0eXRjEU8Yj4pSCQUOib3wRgxJ/2tW5JZjFCVP8pgf2O0qMeEPcK30nZ
	 Ntt/9W5NcLijHY9abSf/9p1b4uG4YDdHwuEVUkuLFCY+cONDwzWu1uTzRQ3PKDcWkP
	 llmMOUgfHLcKME2qQprR3V/0qMSu4q1ww2GaARAqoqYv3yQYs0lcraZIQxXVD5qGd5
	 cUfwCLDeJZRNA==
From: SJ Park <sj@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Jiale Yao <yaojiale02@163.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_idle: call folio_test_lru() after folio_get()
Date: Wed, 22 Jul 2026 17:48:47 -0700
Message-ID: <20260723004848.96647-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <amCSiltZolhgtO3J@lucifer>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5ED4E160004
X-Stat-Signature: ya5k93xob53fq8ybidr7r9zgyi8grn1z
X-Rspam-User: 
X-HE-Tag: 1784767738-774972
X-HE-Meta: U2FsdGVkX1+MhKcdlJU+HVR5bAaR3tfzmw0u+YAbUMgj1ckE0bX8JouY9XEBXY55DtoQ/eX/3pnPNvr0TXaniL5Jj/xl8RaP7xG0jWhB7a1NmpcYdbBy23zS2kz8ugsSHQonOPFmDp0O2SjcJ8eSbS6NHuUjGQ4KCcNDIWOFKe1fv5hydWWgRYVAOcmHZ2gu4CygwsMB0hzBpRE1z5jLBnz6sjWlLGGyKR5Ef/PBoDzY1iWz5UjLDgrHcgLJm7E9TDiXTzaT3LUSZ1n0m+ERXHXIoYDUNQDvg8BlbuCT+qoVRyj9N/sgl+DXigFaPothPpSRd7DubtJ081QLLhx9tfk8XeEf9g089BKRrJ04iiu/wKA+fhTUmYnsc9y+lw8CxGE2mQkNdpHrqisqEvXe/5fb6gJ3fYXjgC2PlLbYzUhBFkIPp/yHCnR9rAaFSbjbZGpVpKsF4ajuVFOZtSM+2uo/yYGAy4Iqult7QGowKB6h+hl/dbHmpm5sSLcfVhNKWziygLZ5YSuzlhtc3Ex5FXZwjyrAmXeiRp1rv9pa0e5wOu+KaNHwGwGNIomiwxLtj+EUBw1Cd6wMzrviGobhJI/EIVDcc1BJ0LAToMN4Q/P91MvYtt4oZ3DvJlXX+MaGMBcrMJ9wc+qUpsiseth2XD7t4VByJmXJcvMnV3h0VeyuPOMrKw9D2sMqQXO9TMY4cEvZZOADhBZc2OV1fPjTzU20v6Bu3+Zv8vlAazoatYwkfAgkB67EE3eEsbrTr39hZYzd8zsDaYz9q6u9wyKCzsD6drIOg7qIuT3cYTaf2VMYqixeITSlBk0Iuth8B88F9fF5SlbB1jWwg09S6IjI8g9rSKJxpQOEMr27PrKUE6oGMGqFLhUXxOuiemQ7ZZGgjHTjcbFccO6g4z+9o8YlU/Ezo/+ocQHBlFZ+DVTT1Z5IvgjWx9RSYe4ochiiX4AHnY7au+8JST3+KhjgSJ6
 QfVRlfm5
 RBO4IO3gvpS80CqvpLlm30yc+GEVPOoJdrYXfNyxn0r6EYSiQUXIruSl8wbhNvKBAcvPfIoS0Wdc66DnNVA8cheHmwL9TfZBRQCfOxTdiK6lq0ZmRWPIV2rS8JhMXaH98VkYpNpgMMe8MfCNjFwyOhyBW9ai3CjQWxAQz7gFrFUtO1ZdKJyiOfMZOXxQHfE0ggfWVyT9KMgfK1Bp2//4y0d+LGWwQjBxhY6L8tsQfZ8NU3eeY5yOkOMpubN7haWv7e285CNYlX8q+Sl5jBTx0SpwV6xY2Q0endy3q5MhPzsaRItp0++rboqzZ5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 10:56:13 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> On Wed, Jul 22, 2026 at 05:26:42PM +0800, Jiale Yao wrote:
> > page_idle_get_folio() speculatively calls folio_test_lru() before
> > folio_try_get(). The folio can get freed and reallocated to a tail page
> > in the meantime. In that case, VM_BUG_ON_PGFLAGS() in
> > const_folio_flags() can be triggered. Remove the speculative call.
> >
> > Also mark the folio_test_lru() check right after folio_try_get() success
> > as no more unlikely.
> 
> Slightly strange wording but not sure why you're doing that? It is
> generally unlikely a given folio will be !LRU right?
> 
> >
> > This is a sibling-path bug: damon_get_folio() was copied from this
> > function with the same flawed pattern. Commit d6b8b02a27b3
> > ("mm/damon/ops-common: call folio_test_lru() after folio_get()") fixed
> > damon_get_folio(), but page_idle_get_folio() was left unfixed. KCSAN
> > (strict mode) confirms the data race on the folio flags:
> >
> >   BUG: KCSAN: data-race in ... / percpu_counter_add_batch
> >     page_idle_get_folio+0x7a/0x2d0
> >     page_idle_bitmap_read+0xc9/0x220
> >
> > Signed-off-by: Jiale Yao <yaojiale02@163.com>
> 
> Yeah generally this seems obviously correct (TM), if we can't be sure a
> folio is kept around any other way to the extent we're doing
> folio_try_get() we should gate any actual interactions with the folio on
> succeeding the get first...!
> 
> With the unlikely thing changed, LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> > ---
> >  mm/page_idle.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/page_idle.c b/mm/page_idle.c
> > index 9c67cbac2965..29ee18f0e8ce 100644
> > --- a/mm/page_idle.c
> > +++ b/mm/page_idle.c
> > @@ -40,9 +40,9 @@ static struct folio *page_idle_get_folio(unsigned long pfn)
> >  		return NULL;
> >
> >  	folio = page_folio(page);
> > -	if (!folio_test_lru(folio) || !folio_try_get(folio))
> 
> I guess this was meant as a racey check...
> 
> > +	if (!folio_try_get(folio))
> >  		return NULL;
> > -	if (unlikely(page_folio(page) != folio || !folio_test_lru(folio))) {
> > +	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {
> 
> As above, not sure why you're changing this? Seems unrelated, I'd just keep
> it as it was.

Maybe Jiale followed the pattern in DAMON side fix (commit d6b8b02a27b3).  I
was making a similar change for the below reason.  The second test_lru() was
unlikely because it is the second test.  Now it became the first test, so it is
"less" unlikely than before.  I don't expect this makes some real change,
though.  Keeping this as is looks fine to me.


Thanks,
SJ

[...]

