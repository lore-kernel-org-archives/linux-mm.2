Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD9DCA0FF0
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 01:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 895CC6B0313; Tue, 26 Aug 2025 21:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86DD16B0315; Tue, 26 Aug 2025 21:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 783EE6B0316; Tue, 26 Aug 2025 21:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66AAA6B0313
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 21:20:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D32921403CE
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 01:20:48 +0000 (UTC)
X-FDA: 83820782976.07.4C47664
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 04011140003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 01:20:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=S7cwySOP
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756257646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lC8akd5vlKxoqfzdemFJvhImDK1gLqh/1HpWO2E4WlE=;
	b=n3iv4uZbP1W45+IhFuuKelwm3l1tPoc71/YGnufGW63qZ3TsiqcFMHaG7AhFjWn8z7d99Y
	g57OinWCyFdXmZY3LjjeWvmG9dbFkk7qw/FVVos21YWFb9N8MjJesn3f4TKnlVY4vj56dd
	eEOIJr9x0PZ9fdKuOXqUX3XE7YhThxo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=S7cwySOP;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756257646; a=rsa-sha256;
	cv=none;
	b=nQWCqwXNLPWx+eSjhPgk0aKXEt6sVm4rzCIAALoID1ij4t8/UWBb5VpJTR84Vrw58GS3P+
	B5AUiGFeEQsH2SFRo/+WXFWYNxaEh1dqY6QdoA53vmNK/AMRUAQYBd74ekXQ4zzdDDuV1b
	8dDgzkQ66OCQjLPRHOlSnjj/VfNnl7E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lC8akd5vlKxoqfzdemFJvhImDK1gLqh/1HpWO2E4WlE=; b=S7cwySOPsYE2ehTFHmwaynbbZl
	W7Pu8aB5Ooj57EUUAxVq26Bfnjy2FeJ+BYZD4bIYAlEKeKt9gGEHhQxFFohU0x9PN5Tr8aaHrIbEd
	kUrPFYNlEILTw6RaPqgZ7+CjsQ4J4F3fnSKFOzNJSPJC0pz3xAwLehFWdWWWtXPmeu8nkyOnTHuIB
	8FFQDYRoBjXjyCwI4sBSZdItntecxow+OYs46KNP9Kya0ZB2F2ScZjsVu0Lc6M7XYSp+T98vQo0gI
	oU+il1omVdyLO/rbnJOxbL/SVL7xkcDWT9FjvM+PRX4bz+jiWe85/6n+IS0kGvDF+0vLvE3f61wwh
	TDt5N8uA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ur4q9-0000000CfrI-3ajI;
	Wed, 27 Aug 2025 01:20:41 +0000
Date: Wed, 27 Aug 2025 02:20:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Aristeu Rozanski <aris@ruivo.org>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Subject: Re: [PATCH] mm: make folio page count functions return unsigned
Message-ID: <aK5daUurTM8ET2gf@casper.infradead.org>
References: <20250826153721.GA23292@cathedrallabs.org>
 <aK4EOf-EE43pi-xq@casper.infradead.org>
 <a959a7f8-20c0-4c2a-9cef-ffad4f8b805b@redhat.com>
 <20250826220041.GS3581799@cathedrallabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826220041.GS3581799@cathedrallabs.org>
X-Rspamd-Queue-Id: 04011140003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3jdcum6r6j8tjhuxummsd5bhyocenmyg
X-HE-Tag: 1756257645-636797
X-HE-Meta: U2FsdGVkX1+fbZQ6UCc0/+qMJk/OjJ8CFeHMZLmYDdrwKa2exmbxokzznY3AX+asdjzg+k6WHR1p2FPPyk7kKIzWEuIriYfSK1JlqslIblFblVWXad+ds+KUVVr/n9GBgbI38Nr+2NW1hZt7KaZ+xEH44JvKr+FUX5r1aTHnqM4jS57yxeszSvoFjyjLAyEtALShpAx98oGuPlnnWPmdAtheakw2NvSSyvuspF4R08IYJgX+Qg4stVBhvghPCW2ibYfSd9ldUw23g9DahnOc7xwbKstG0KSFaBuSDYwqPdxlcnoKKn1CaSYac/H8M9DrRl2K+WX17KSMfbzXKyuDi5LBjiNcIEa//OQCKh5KXte/greaU5u33b1kVy2hAjw+YpNhBcj9p3SlKjMYPzs8oYmc4sJkBAg/xW+U9xJvvNPIjw12vTkbHquzB9jVXUtqnRB8qcjY93eWlEHXHmXDKTsrcZ+WXP6O5E7N3rXuD9xzFqfqi+s7H4ETiW1h65CryWSOZtinbQHW17PyhjfOYJzL5oPhREiViB+2j4UpM2Loq4x8HhPuxQQpi8oEJ+G/KL+3CsO6vy6/whc53kagc6NOK+kz9bS0fxVUVMA3zLQwprTvId+tig+jK9N6nBQXoCwT0yU6qWG7pC2nzzkBLVSwvZRBDaS4sCrxgvwvKUYEKAwDX6ym2I0Q5JqFZFSX9UzanPfgqefMqMiQoBCso7KDAdmwIPQ7liy3j+03xp+zZ2/g3U1vqUQQHmI+Gmd9No4+ywxG0bjnct+pUmbaLlvGYC3E8WYYPSbHgp6sbHEe93Sbi5gj7AKaYYDMj0fOqRNX1aOez5PWHtW/cF6RcxiMNEzvV8pgjk2Pds6Khr8yN43NePWPSg7Mgvckc/kkdDclDKZQv8Hc+2GTu95N2empu3oRsegsHyCoMgvjRNKNhy2W52cz9J3vA0rSQeIlefS1RtlmwiI2fdfdLBJ
 GQZ/KKwS
 izwJo2x6Bf77WAvqKmp7gIhMgaOvwHEHFJwhVrA4fB/2VJ8A8idZbGDK3mISX24AjS8Op77lrktZqS/Vc+yS+EeT+voWZ1L6BZ9cFb3wA0Af4vXdarW50HcITBOs2Dv9InzgxvbyQuzjiqo+MtXQpA8ViRVmkAR8/QcwnQjjEZhdzLIY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 06:00:41PM -0400, Aristeu Rozanski wrote:
> some actually expect an int (e.g. memcg1_charge_statistics()), it'd be a good
> idea to get those fixed.

Yes.

> > Then, e.g., -1 will be (unsigned int)0xffffffff, and casting that to 
> > "long" means trouble, because we wouldn't sign-extend properly and get 
> > (long)0x00000000ffffffff.
> > 
> > Using "unsigned long" instead work perfectly fine.
> > 
> > e.g., -1 will be (unsigned long)0xffffffffffffffff. Passing that to a 
> > function that expects "long" or "unsigned long" works as expected.
> 
> We could run into problems if folio_nr_pages() ever returns an unsigned long
> larger than LONG_MAX :^)

I feel comfortable saying that we'll never support a folio size larger
than 2^31 bytes on 32-bit or 2^63 bytes on 64-bit because folio_size()
returns a size_t so that constrains us.  That means folio_nr_pages()
must lie in the range [1..2^19] or [1..2^51] respectively.  We're never
going to support PAGE_SIZE smaller than 4KiB; nobody's interested in
designing hardware to support smaller page sizes.

We are likely to see folio_nr_pages() be larger than 2^31 at some point.
arm64 supports 2^13 pages per level, so a PMD is 2^13, a PUD is 2^26
and a P4D is 2^39 pages.  That's an utterly impractical page size for
most uses, but just wait until the AI people decide that it saaves them
a fraction of a joule per calculation.  I'm not putting any work into
supporting that at this point, but I'm also trying not to do anything
that makes adding that support harder.

