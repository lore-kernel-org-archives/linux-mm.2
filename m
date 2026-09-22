Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EADCC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78B5B6B00A4; Tue, 22 Sep 2026 05:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73AEB6B00A5; Tue, 22 Sep 2026 05:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62A3A6B00A6; Tue, 22 Sep 2026 05:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB7A6B00A4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:43:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D25901A03F7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:43:06 +0000 (UTC)
X-FDA: 85240909572.19.F621AD4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4A5D31C0006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:43:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HEDT5Pjb;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790070185;
	b=EMnMMQED1KLwxOPst0SQiQuk/C23TY1o41uLEInu7Q0opBWWS8tnhOjymslmuMR/ZIoZ50
	qyknmDQ37esg3p38hzJ77bRRbeNiGuSJ3FFWS+HGwSZ7PlEYMp3m3Gue1/j64pJvNzTvRJ
	omdE/qMf49IoGHGrExklEEf684DmcnM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HEDT5Pjb;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790070185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+eCBMsdRHZZ8+99AV4x2YGu7/eXm49oGH7gIIrlNWI=;
	b=bqQTFHsPGW7j75pFCArPw4QYFpJ/Ol8Mo2R6tPjceQulV+spkXW0cwGQ6l/DS8Dl9IbBa0
	ZGPdloeef6sZg88DiGT1p3Q14syzMAMdmIu9Qv3qABbeTlwV7ls+VkvWN2G4RntHze5JEA
	HuO7/bv3xRc9xeV2lODrFn+Q4XEbOVw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6319860DE1;
	Tue, 22 Sep 2026 09:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9988D1F00893;
	Tue, 22 Sep 2026 09:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790070184;
	bh=V+eCBMsdRHZZ8+99AV4x2YGu7/eXm49oGH7gIIrlNWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HEDT5PjbUbEQaAwBztSRssxASmJHaBqVwPwKnbEQzsJZHM+j+y5CasBQn12wmlSJn
	 CuHqNQhabvHNIE5dxrC6QQ3nX2kIuww0JvVP2OXFnTkjcYV2qnP/mRlpxd612CoRVl
	 MH+PLj+Bg+NihW+ZUZmiXEO9xnC/xz51ZS0tCCAxu/FIyVQJvDIn94lfBrZZ9/h3d4
	 LPbb4NTCgzcZzrmK3Y0xPjiBDCuUMpAv7GbvkYoaxBVrDHqpolf8pst6EaxjvSDPB6
	 m7OzrlzeotaCljEpaYVl448V2ES93RVHyOaaA5G/RAHfF1BBOI+NYgUORG28y/Ik/h
	 13rAqbmckKezQ==
Date: Tue, 22 Sep 2026 12:42:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] docs/mm: describe set_memory() and set_direct_map()
 APIs
Message-ID: <arJNn2QD_pY6e14R@kernel.org>
References: <20260919-set-memory-docs-v2-1-a2a4b3657690@kernel.org>
 <433d32a4-f59a-4d6c-915d-2c1b4c22b840@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <433d32a4-f59a-4d6c-915d-2c1b4c22b840@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A5D31C0006
X-Stat-Signature: pqo5zkm5jecofs3ryjxrnzkn4n17zx4f
X-HE-Tag: 1790070185-88911
X-HE-Meta: U2FsdGVkX19tdBL0WwSorIcToPBy30xKYlWYA/12mRF+hGjhyHl+qqtD9kahFAtuG1z5pNlSDS8EdA/7QxAtLa4K6aVgW6kUH8RLnAFWsa8cwnKH/oiAq4CVtxQclBEur4iocac6QGplb4OlVnnYVq+CW9rc6+l2IaP9BI0fGRdAapnkRTfCVFxH/JMY21iqBYpEzVjpKgpBX66CBshhjj2cCxmD+Gpl7L6vYJTe0Ktv7tjX4zdnvmJm1l4JvZPfZ98WxLAnCR+q0CFTT/6U1+AV+nocWDQEsEJRIcnMZsaneOKFo4vyk3cr3vtE6lvKRGaXywxSLZJ4bZn5x2XIhADalU0mo30QrOvEWeJVxMGWGL0wSghMjrlD4HnprKZERuxEOK6o4N7hlqhLWbhBR9KoKiK5X/Dks1RQfeYZXIopelhIGZxdRAq+KgTQMLgBkEPvZhIyQIxqlDgNjXkMlSrYR3RUzqqCx3OWIS1neQ21brh/9fREUiQqcdErr/VPiRJKpFDN7e65j0FAVKcdKbxbOfigh9wJrJX7rl2xG8UGiDtEYFXJopUMub1Y8WSR00uSHEsc75yH8IfVCyblZgfpypvzGciiGqsCFUQIbgPtvqmSuKanKH0LlYw5HuLPlb4zBRjM+ydwdvug3BkWANHF7nPtQEzuRO50pwnfoO1/B8U+M82AoAb+rnkDj/iXjpPdeyJBBRdUk7hCk9XvpwLRc2fuzA+hRnwrgcpc+hpIAJn9OKrEP0zt/KhOVlcxG+L40mmmC0m91kOlWEkICjQNJulPLTsv3zYPx06qnKmJHcdXuLnhcSRbDRTJbpq7zuJzqroQeQ8fcB2YwrBcUvfnOYeaqCZnD+oPGNh2g0d+wzHzzSptZspV/Bnbml2rB8VfCiNIwvKQ3ZSna6oRxWwMZC7oAizp2OeqGyrjmRYZrfrsrcSB7YKSHRiY+DpoxTQzvGgbWYFUrX3o80Y
 x5opLyEO
 kKz8hC7z3gH0/hoJ5SBRHSC3fyo5gm3Q5HIxaZbshDio/h7fKXQs9qN71eQT4TcKQhpn6Sr3pHn5CuIStFWvRTT8BWkChibDWvxhpBYkoDwBA71Daqy7KM0e9Xx+zNAp4cUM7BVIqGm81/2imAq16bON0Mm5tIjabp5TIApCo/kUQQKKs4DKW2ddxrVUkax9SeSjt820km9IDA0+ilM0c8r63KaJGIampj8A2c6PiqkmnB4zhV2xCi3cOeEMCp5YlnU09F5+8OqQt67/stBcdxiIa/F4e/8FdInJ6+4pctjUFdX2hvF/Bkble3ifrukQOPNatcZfa/hvF9bzROrvKbv4LLc6nCwx7JWEXT8Kujuk2S4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 03:03:32PM +0200, Kevin Brodsky wrote:
> On 19/09/2026 12:43, Mike Rapoport (Microsoft) wrote:
> > [...]
> >
> > +Modifying the kernel page tables
> > +================================
> > +
> > +Except for the vmalloc area, the kernel page tables are mostly static. Still,
> > +there are cases when the permissions of existing kernel mappings have to be
> > +updated, for instance when a module is loaded and its text becomes read-only
> > +and executable, or when a page is temporarily removed from the direct map to
> > +reduce its exposure.
> > +
> > +There are two families of functions for this, both declared in
> > +`include/linux/set_memory.h`:
> > +
> > +* `set_memory_*()` change permissions of an arbitrary kernel mapping. They
> > +  take a kernel virtual address and the number of pages.
> > +
> > +* `set_direct_map_*()` change permissions of the direct mapping of the page
> > +  frame represented by a `struct page`. They take a `struct page` pointer and
> 
> The new phrasing is a mouthful but at least should be accurate :) It
> should probably say "range of page frames" or something like that though.

It gets even more mouthful, but you are right, "range" should be there.

Andrew, can you please fold this in:

diff --git a/Documentation/mm/kernel-page-tables.rst b/Documentation/mm/kernel-page-tables.rst
index b3148df07fc8b..c16de34b4f79d 100644
--- a/Documentation/mm/kernel-page-tables.rst
+++ b/Documentation/mm/kernel-page-tables.rst
@@ -103,9 +103,9 @@ There are two families of functions for this, both declared in
 * `set_memory_*()` change permissions of an arbitrary kernel mapping. They
   take a kernel virtual address and the number of pages.
 
-* `set_direct_map_*()` change permissions of the direct mapping of the page
-  frame represented by a `struct page`. They take a `struct page` pointer and
-  the number of pages.
+* `set_direct_map_*()` change permissions of the direct mapping for the range
+  of page frames starting at the page represented by a `struct page`. They take
+  a `struct page` pointer and the number of pages.
 
 Architectures that implement `set_memory()` select `CONFIG_ARCH_HAS_SET_MEMORY`
 
> Looks good otherwise!
> 
> Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
> 

-- 
Sincerely yours,
Mike.

