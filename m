Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC458C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E90366B00E2; Tue,  1 Sep 2026 12:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E68796B02A8; Tue,  1 Sep 2026 12:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80466B02AA; Tue,  1 Sep 2026 12:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B513C6B00E2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:14:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47527C048B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:14:56 +0000 (UTC)
X-FDA: 85165692192.30.355B196
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A5C468000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:14:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e8LA0aNf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788279294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpGvZ/6DOWCtk3ukkVrOi+zOXCa7mjUjaVjr1u6xFiE=;
	b=eqhQviMdxt6S9cUF0wlSq6CfwN7Wdm8MHD7y+r2cFv/7qBXuCiJtq3GON5BDXyFzj+qhBG
	ej4bxQ0Y8ph8/qCI7qto/v2eW0DjKCpnrXActUuFG6NHnCrS7FcdIz3IsEuqcHlMLFGDX5
	ngcaTpOfvBfEccOB0Vhe/oR3J2qEAEA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788279294;
	b=T3F+DY0S2hmwm7U4tMNyI6iYvjYmEPAIVJeulE4Rtee68YY4LfcCJ7avK/fxiHM+DGVoCk
	2qOeIb5oU03UBm9u4xP/ofHliSEwAr2rsgY2JdV24FqRJvUN1oyUFDOdb4k8/D8TDQ9hJs
	f+pJvIuFuetDmmGVQwdm+mE3JpN/cwo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e8LA0aNf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26AB260261;
	Tue,  1 Sep 2026 16:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664B31F000E9;
	Tue,  1 Sep 2026 16:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788279293;
	bh=UpGvZ/6DOWCtk3ukkVrOi+zOXCa7mjUjaVjr1u6xFiE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e8LA0aNfZmdy0npvHzO0TZxZ6Cm1N+lY1h71iSuixLrt1AJKuBsrlcgyO0Nlftf+4
	 14UTYdv49yO5un6vvj8+WNiRQRbhyAgUk+YEr8wmhFdwPlVSncQMpsXKqgAzpwdoPz
	 ZiK3Grl49WtZsHmRB3iqwQ7QGfYT6Lg7QyKpCofuhk2fxMfuFQE3d21G9hk/Wrpy+z
	 oo24q37vlkh49VlJ8opNB22U026en1YtjbEkDlstDQaNfsuLBAYDiRNybRW4VtbG+Z
	 0M0X75wL8vw0i93QRblV4qcZrE74t+y15VibNjc/4z16cuIX3Q5lBB5A0AaLhfhId/
	 lXPurPaP5eT3Q==
Date: Tue, 1 Sep 2026 19:14:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: remove unused totalram_pages_inc() and
 totalram_pages_dec()
Message-ID: <apb59oxMWqhtL-LC@kernel.org>
References: <20260901-mm-remove-unused-helpers-v1-0-f092d086f7dc@columbia.edu>
 <20260901-mm-remove-unused-helpers-v1-2-f092d086f7dc@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-mm-remove-unused-helpers-v1-2-f092d086f7dc@columbia.edu>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A5C468000A
X-Stat-Signature: qbxp9ehya4meoih8u1afp8yg674dsz3c
X-Rspam-User: 
X-HE-Tag: 1788279294-740161
X-HE-Meta: U2FsdGVkX1+q0a++zJMIk3sOlPS3YS1bWnTiGNXi2sLTOcE/1J1vwcsUFgdb23cPlsZtlLeMoHOQNJCperHi/SfPw8mBHDKkcIOtW0qcTJ8WnQz6+Ug1/aL9rKAJF0HGA5pP0FyF1b4zfngbJr9x+lYuD4nqTjqIHQyMA0GD3FT8BSqSXmjEskH9q6aIEXCodh2FhU2BLwOqKZutVUgpH1Lyd4UiTjiC1i/vim3pRtSCslTogHXSS/9euo2wSDTCjRH+uaMCsyIDZ43Qc65/p0EmJ11eSF+6GqOWZV6Oz5TgnHiH21518YJNUh2ZatDAfd/SRWwGJ+tWyBG354LX3GPwG3OzfJJ++TWafllQIIMo65eIlSg+D9yORV5Ffj4xfJhwyMvaAApjGBx6RVBnODfDVgRaknvtJ7CN6iCXiMkmcR3KAuMQ8svkEUh8py5fkMz2YLV+94UqtLA2OYXi8qBncwIlA6f1sfkZJKEgSE9KgklXJCO/OCvpHUVUBUFWbBNA7Kewr8/rPDfYNH3Ox/Sc6RVRG2mxwbIqmoLpGATwGrqiYntfO68lkC/3xhxHfZelTbTToGgWSMfHFhqaYGXSaJ1yUF2foQwGtBOU/JhrMc01pnM2JkXvIXe6EY6eYoh9RttbwmN3WBNVXTtl63id/XjN7lvHgvgKJrE/1xrpwidZdqywrRruIzm9I0IfbaWXJolSJS6ZE4pEm8IqfX8VSZvXlpF/j2XyTHszYh3tKH+CcrPyiHSg+y8i91EFzc/A8nGvseu0umTEmNN23L3WYKOrawcLFOQKKtws2pd/n8OIDZahG6bjtW/w0a8X0M6PTS4xj1ywWX7278IGDQJlvCqLdjYsPWrS8YE0u5y58fcISthp6bkusSGhWeYiinKjPvoqciY/SFVzH3fFDuc1Gh+qFozqhtvrs7lCQUCOB9n8GDsyDxF752m38o5vZObd/w1rQqNNzN1Knix
 /LPdj5JD
 4+jReMsiDYK0qr1QtI3lx7yEGTv4lPB72EQAFCxElnWUniUqAdqAld15CgkL2voD46hnuK+PtgfI0C4oZY3Bg9geiQdesEZfpnbJIY9vaG+ECZMrxTd2TavQMrB6FEhYhhhd82X23WYqakzJH4su3tvDU2oqm+xAftk8SNO86WZnaxUL37olJqqJbANfc5SJuZ7tFm5KPAI6rvPayRx3li4DQ29IlxQcMeKikaaPfBb15tiJMbPPjvyxj/dsq5+7rNSNH3zB6DkuM6q5WOwtsJElqtkecw0gLV2cV+WCKu6BMGCznuGJkDvHkN5+Ym4fyddZ8
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

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

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
Sincerely yours,
Mike.

