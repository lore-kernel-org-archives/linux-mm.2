Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D420C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CFB16B0200; Tue,  1 Sep 2026 10:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27FDC6B0202; Tue,  1 Sep 2026 10:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F5D6B0203; Tue,  1 Sep 2026 10:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E87F36B0200
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:07:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CAEA8044A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:07:04 +0000 (UTC)
X-FDA: 85165369968.21.294A7CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 77A00100019
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:07:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KZz21cI9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788271622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U694HL5ojZa8uw66A72yukjcRjflrodlQXMrYuMj1do=;
	b=DdWr6P5+sMgwyUYmPF8/OkaPbisuLiHw5+vbcRHpuUQdq+sAwIK4ZS8OHyohjQMNTjpUxS
	lAH2ExfRSM/NiorC8MRJNGOXC9owCQxLGfhcAAn2DQ8V0z3jAjmq5QBPgchXd6w35Ny3iC
	QKO130OU0zJu6WcYScnnJ93rF0BqydU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KZz21cI9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788271622;
	b=g8WwlChU92K4GFix/Nc78TyPydR7wTfWup+/eI73IQRLGDZWjQ2SnUghSQVb6bUvc3O+t7
	xPetILONToPcq1+g/pYVw+H8aXDqqR8l0vdIE1nVkKOK0wyLb9Y0apLWQn9W8gL4T6VbDn
	Gk8kCgpz2kEwcCDGo02I21WS3a077yM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91E5240368;
	Tue,  1 Sep 2026 14:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882191F00A3D;
	Tue,  1 Sep 2026 14:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788271621;
	bh=U694HL5ojZa8uw66A72yukjcRjflrodlQXMrYuMj1do=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KZz21cI9D+NN9OF0A//H6XEzlV3SxcJjEPiGFrlS77mbI0Lb3NK/tlxmleC6UUeQE
	 1zZ6YhL3ZXCjB4MrJnjHG69Wg7bJ2JwK8ImtTUSewyoftUaH2CQv8GoCxW5l59/8tf
	 /DyjSchVeYoqHbDubAU+9jERc5CXMGW8KW/1aDhTUQaIXaybJUdq+2Y3xcoTVDJkxk
	 2nZuk5COkxFaiq9u+1n/dFr6nDsUAe4axVdacY8VR/9x2FJNow7zbaLxOwIyt9UpfZ
	 MRD1Dyl38DezY2IZCNZyv0ZI6ieHleMwsPP4sXM1g0ofh2+iaG5WI8CQztjzISz9g2
	 CWxFb6xprc9PQ==
Date: Tue, 1 Sep 2026 15:06:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: remove unused totalram_pages_inc() and
 totalram_pages_dec()
Message-ID: <apbbw0A0f98nlVol@gremlin>
References: <20260901-mm-remove-unused-helpers-v1-0-f092d086f7dc@columbia.edu>
 <20260901-mm-remove-unused-helpers-v1-2-f092d086f7dc@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-mm-remove-unused-helpers-v1-2-f092d086f7dc@columbia.edu>
X-Stat-Signature: qmhq17epwdtxn1mhujqmi6cyig77x5a9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 77A00100019
X-Rspam-User: 
X-HE-Tag: 1788271622-903010
X-HE-Meta: U2FsdGVkX18Q6O4A60TojZ8AoXLOgBl0AnYHPUjGxF8U27XTL3fi0pLtV8CZ1D7xrvK7u3Hy2KdCBlZcVmp2UTsNbEBPMh/n0FEVuM0Bci4GCAIfFCo2jMXguESIj75wcPn6wnpy+geqlj94b7BdK3np4FlDUqDyQhixD07u69H7i6aDyvhIcPTo6T34kQKJQ2X/L4MwCSXXl3B3OKQA87X7QfgEJWLJ06VKVe2BM9nzhqJtPr5Tc8XpF67iZwguJSXs5QcOPIjCngnUNx2HI07HGCsp+7Y/5mjRDZgk8ORBqCdCz/LgXPrDwLPS9kXfW3aY+tJzttHjD5FywEjl9NggY2o6OPjMxtwGPBKAgFurASIsjtg4Pt02Nbhy8KYNJeEsIJmH9vA/zzSATu2FGahrPkkKf9SkLhSlKsuA9JJ9Q/SA6uHbeUADZtFG4MIvZ7hVX5AQ1JVTN7pIx4CSocnvR91g68VPb31nBqiS8GkbqX6C1zeJ3M+25tRQwICFMIDrrQ7g9JNm0eUPLj1fqoH+sKvGyXk5Zh6tD80StRzQs6ktWzRn25k4wJjEg9qHllub87bR/QpY2yBJTFrOgXPA2Ky0SPu4eWnmdPZ2rhW+FloDQH/eSR5k6lMf3j9c8exd4s/XFR8+J/T9CE/eiD2XMOZ0ZVVgfZ7rAhBZLtugL+qOnx2L7inm216c8igO+i+7xBXBC7ztUgUk9D2b5RK0+kSL7OORG1hxOVzbY076P27/Xt5h0nUrTEV/OfiTQaeYMBeKuNp5wUdWJglwwu+xMeCON2yIvev3yhV6p8wkC2GX26pa/v6Tj300oK69Cc5ZUHAXorhorM/6UKfheneYaKMpHNa6fSKLSOWdShjQHYsikUmYqjAN/gwMgJK8YoyH6BjbMxZRuzCUnDXVwjocnBSZy2ynxU0pQ95JnuxLXKkEuDM3oqBwe4Nk/HbJ1p1X/bgv0UropSpA1yw
 AZ7HST/O
 UXZ039NzOI3hxbmyGxqnIqVp0NmX/hNaNJdwQNS2/g7OpYsreXDUKzqYYvP5ucOeWnHdqLC+q7rge/PiAaRnsQKsexe4YKEErKOqLjbiAKTqeH96Et/ownq1KOPK9MOwprwgHKI/72TBIDYLj79Tv9P3TZ5DdrTXU+IKvQdsfSfRfTpU+qOGuLWKspsLCUq9MU4vRFJJ7zBO4eFzVe1OHzRvnJKik3o+FT0FFiUHCCqbwMre3fM6WY7DmWzw/pYqVFtzbOTImY1DlFtyW8ToMuT3k4XIsaIYb7KfsIezv0OaUafV3atzrCbVaZybHU7uCGC80
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 08:59:20AM -0400, Tal Zussman wrote:
> totalram_pages_inc() and totalram_pages_dec() have had no callers since
> commit 7fbc5e26123e ("memblock: extract page freeing from
> free_reserved_area() into a helper") and commit 287b89773d81
> ("powerpc/pseries/cmm: Use adjust_managed_page_count() insted of
> totalram_pages_*"), respectively. Remove them.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

With additional change requested below addressed, LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/mm.h | 10 ----------
>  1 file changed, 10 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e3736c42c4db..c105a3758915 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -57,16 +57,6 @@ static inline unsigned long totalram_pages(void)
>  	return (unsigned long)atomic_long_read(&_totalram_pages);
>  }
>
> -static inline void totalram_pages_inc(void)
> -{
> -	atomic_long_inc(&_totalram_pages);
> -}

I also see totalram_pages_inc() in tools/include/linux/mm.h - could you remove
it too to keep things consistent? Thanks!

> -
> -static inline void totalram_pages_dec(void)
> -{
> -	atomic_long_dec(&_totalram_pages);
> -}
> -
>  static inline void totalram_pages_add(long count)
>  {
>  	atomic_long_add(count, &_totalram_pages);
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

