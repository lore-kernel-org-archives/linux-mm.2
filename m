Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C93FFCD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 07:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CBEF6B0093; Fri, 22 May 2026 03:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CAF6B0095; Fri, 22 May 2026 03:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4D16B0096; Fri, 22 May 2026 03:41:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC08E6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:41:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82E291C1E3C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:41:44 +0000 (UTC)
X-FDA: 84794261328.28.6FD0634
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id BED6C180004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:41:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DTfyLhow;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779435702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s04p8sRBilefrJ3qNkPkFCTZXc1+vdhBxglscTg+Mgk=;
	b=vH74lAmxTDx20dqRZo2vLUKrRW1STFIgakzIET1YFKES62Goqy2xQK6R6/SksBtLO3ryIs
	2DaIcAoN91gz5l8tuxmgWH/5N2mdMjuKnV+Wi41M5E1g2dUTQIIweOHvuTtNi8or51sISU
	Q6dAsgLpYK8HstyuR6Nj/lmsgkmmCYw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DTfyLhow;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779435702; a=rsa-sha256;
	cv=none;
	b=4xZs2zEqiEHBrMS7T0f3/KxmFItAqXK/gewOYZ0lW0XFUrM38UXXGqhkdstgJv0zjKaUmz
	oIkITCv156ocGEp61pN5MKjzKnnsrkweuQycdn1PgKXV67p8NnPAVTk3AstIg2/Cx3JjPq
	1/Lx2wifBwUBOdaCnlKuPyIdnJxwwYI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BED0744394;
	Fri, 22 May 2026 07:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193681F000E9;
	Fri, 22 May 2026 07:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779435701;
	bh=s04p8sRBilefrJ3qNkPkFCTZXc1+vdhBxglscTg+Mgk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DTfyLhowZTtw1Uw3MclA7IUOAQagmqpcPHoNLlPbgqMsOZcyqaLVhHfgNBDozH5rj
	 bQDiaY1wh1iLy6ltDF1ctnz0JZsjMsCZr1zQngQFYzIBPufrl8sSraGWtwHWroj3E7
	 Xt1PtpDayttJYbN+r6mfxQLCAsj5cLsC/gWTWLFqIy7+r3xRVIV7iK4cMWFm3NXer0
	 2qfFCBZCUS3AEzIkeX7P45yNCkWk912xadlOxYIHiwgbZ2+k7BFQ6CI5Jy5UyMW1DF
	 kOF1bYJ6GM9P3kfEpha1F9IzsuYJ0oGBsDx+EbfCTrJX0yaejTUoU40InRAwebD74f
	 FTp+Ptgh/ZlYg==
Message-ID: <89333b92-103a-4c0b-822c-1b4f2f8185cd@kernel.org>
Date: Fri, 22 May 2026 09:41:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: drop a misleading __always_inline
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260517-b4-drop-always-inline-v1-1-97b90930e8b8@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260517-b4-drop-always-inline-v1-1-97b90930e8b8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BED6C180004
X-Rspam-User: 
X-Stat-Signature: yiokmarrsah6mxqyso7hzjomg6iheets
X-HE-Tag: 1779435702-512398
X-HE-Meta: U2FsdGVkX19AiSZSBpgRYyo/YBg8m7nMhW1aXk04jXwtQvPZSZgkiSEWaLfDQR3aCvY1BXq4ULxKkvsMgIc8loKrpnuhKfi73MRWoVoVhOMlZD6huY79hFUDboko+ZGtDGmiKH//jXi8XbmL+b9vVPevrQBUGr6EyZ4OWk+6yFJepFr2LNE+tppH4byrFj9IO++d9XWn5+DqyRJNMF3qJwtZ95x3d6zGHd7/WkMhKDvtXxsIYTPQZV2wKnYmf1HKXUoB0dxEGwW6RUQCGAdDfvLemxDII/XSaSTzgMhLB/6UQMYiGxPXuu/S+2IXZGzopyQ+OIpZUg6exk0LXh+i8b0cUwrN7uLLTzHgQF8r5RlaImJAIS/WyDcTAexW4CPnvcb7mKEsOPyX3+psUJAtPu+YAYi2qP57P6oz4ky3wccXjhjDbdn7xcZhYU29raSHp6RS4j8H8fXc7ybq15RY9/3xVhih5lTwUW9uJ+N7obFlXiiVfZU3t/V8XHyNPXuqEGUGFzTSdd67an7tNmuE3Nu6AsVfHZ9v67bB1PNCz4LjCyqyDpa9SPfxaCetmMEM5UPY5hhpmr/RTCAAmQ/vCAj2eGZl7Ry188XWVlP1F3S6azjsGT/R1UT+MRDsZY2HXD7PFF9YZj12NMmBJGCLXDFC1pLbk6iya67yC+OLUVwcReKBpkDBuEGZMma76dzXTrVcSjuXR7+HSE8u6rL0sXJanLYzbt0iLdcnK2YI6TWZNJ6ep2f9tGh/N6YmJIjMlH3Ld0gynY28F9+UoAZxnULx2t+c+1Q/xjaXuG16OaLLAFI5SisFhUsA87zGs2zdB5lPtQ+CRVqRUNc7lWdu8sYz9DPiiIzpeZQqJFJ08ZwExNAkZ0F9GmxcC7euXtUzCXs7Ff8Gbvs9W4dZdlAGjopriOeTQhWifiU1fkRdmx0oKr9diGYEb+oKcdoZceJLxNjBE+2AtfhgBDSuaNm
 74NllH7i
 m0iZdJEwNc4rGlbvVINWNhIrOvgwtfBFDo7kgFtRRdk8T2zlQoB/X4ICskdb6fPFiTBtZcbYPzpaBtBvojoZ14isNZdbMrBGY12JuJOiWH5B0ESmzMAXl16emZNcqISWJFZxJ453qzH225VMMqN+NtaBnIum9kWl1KZXODaYaCF8ur5rdREmCiPf7JYX4RpkwxDuQXY9sXZiEmmgAKOoBlTm7mk1OEBNZDYZcFzDLxTQHFih0rnFgiFq4OQzvOA1wTZszUc/jQ+V+xEmWI6S3SbkM5iMFg4Y4EzEPb0/N7QO6u3xExCJiILp/hCkfgwHaKDZXc/XzrKUZRy8BrS02Riz+Zgk4mrkpu8OV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/18/26 01:37, Brendan Jackman wrote:
> get_pfnblock_migratetype() is called from outside page_alloc.c, so it
> cannot always be inlined. Remove the annotation to avoid misleading
> readers.
> 
> At least in my minimal config, with GCC, this doesn't change
> mm/page_alloc.o at all.
> 
> Suggested-by: Vlastimil Babka <vbabka@kernel.org>
> Link: https://lore.kernel.org/all/016c8bef-57ef-44ef-bf60-86dbfd368dcd@kernel.org/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e262d1316259d..be7f5671d421c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -434,7 +434,7 @@ bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
>   * Use get_pfnblock_migratetype() if caller already has both @page and @pfn
>   * to save a call to page_to_pfn().
>   */
> -__always_inline enum migratetype
> +enum migratetype
>  get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
>  {
>  	unsigned long mask = MIGRATETYPE_AND_ISO_MASK;
> 
> ---
> base-commit: 0cec77cfd5314c0b3b03530abe1a4b32e991f639
> change-id: 20260517-b4-drop-always-inline-17702081c2aa
> 
> Best regards,


