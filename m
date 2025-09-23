Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31236CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 07:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EB048E000A; Tue, 23 Sep 2025 03:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59B558E0001; Tue, 23 Sep 2025 03:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489DD8E000A; Tue, 23 Sep 2025 03:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 305528E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:29:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D68BC844A2
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:29:17 +0000 (UTC)
X-FDA: 83919689154.29.53C0D7D
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id CC4FC14000E
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:29:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eGiwQtH6;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758612556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UTSeb9/e/gBv+XvfhfPvZMZUWbVMsxKjYigguVRQ4SQ=;
	b=X+eI3GG9VasJ9u9ZJx881YIs1w0wKVR+4KJNK1pjhdHTf/5xeCCLoARACBgaVyDCVVJWCR
	KnYS+5/VDQa1O5L0JjBloEOh2DgHlHBe/oOe7QuHeFH86wS4blRNrn1az9j2LiUvu5BbY8
	zZ0L0vE7S/3T/8Jnb636xo3UoLPuwwA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758612556; a=rsa-sha256;
	cv=none;
	b=zSFnglet/4G1P1aXZG7DhZyeSs6cmrrNy+csBZq/7/xom/JbIq49YfcU8+c4omsdUohMXs
	FAv0Gh65rXnuKAKy1ej2lfzkGcsFw/1jLpUwsnjLGROIFUtgdl8+gIYrDilC0aTkPS6k4z
	yxKyeOzSUZz8Qg9DMXyzG+Z0SI72YmE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eGiwQtH6;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-631df7b2dffso2613692a12.1
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 00:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758612554; x=1759217354; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UTSeb9/e/gBv+XvfhfPvZMZUWbVMsxKjYigguVRQ4SQ=;
        b=eGiwQtH6FhByF6idqP9q7GV3yEd5qav5j/YxA1UAcqdXu2umDwL+rmJAMhSrYCUF3o
         +DMjd3g+h4eNAhkSO64ULbxki6ndFSgqb7F+oS9oYXKDvob3lL+iB0H5+/R3gzEYwp8R
         K/kl/baGwdUy0FqiKMmjk7YiCFM/0ubOWQI1GDlSuNhta05i9PZ70b+FmQxE2BAD4JiD
         +mm4ugHhKsffx638EyJTOfFyuAjZcyqihA62KN+irPiT/VNeu8Vp4o58K7QETAMTD4jS
         IgAYnwuFVl5lk+sPuOAHImWS7SS5u9nMWptbTg2qNjvle53zUv0a/uN/uMniM5NZoLVk
         Dgkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758612554; x=1759217354;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UTSeb9/e/gBv+XvfhfPvZMZUWbVMsxKjYigguVRQ4SQ=;
        b=CjjSCRP4miQrPcU7BL6O3ZGAQ/kUqPbTxBAqDfCVVYsWe326+rofiKK8UX3pZdv2WL
         r1FJbFhxhZS1XiBFnnC8tLQAqtUMGqllDu/g6/0Y/6lnrg39cnd+F/Zhb+Sd4cxR+kUp
         xcx1LFNrqFQ4fZ7Zy1uWPJyvSHIwG8I5iqxEwM/7rbOunOuqzNGMOKDYyJKATyyDQu/B
         KnMopQq8TrihksjM/5U1FBP73hn1E8vloUwb8YJ3KcsuFZ5a/5msnnjGEdBw3zXGMnxo
         zyE1KOZ3zpEihq8RBCb71jidUygKKwGwQOLnTVoRNjhFrS8RWB3lbbziCbZyoC1kikdY
         yVng==
X-Forwarded-Encrypted: i=1; AJvYcCVG7A6rax38NJ18d1N2PDT1nDidph/3gedxMoBKHw5MjYmRIvOs1qJZRbPeWBAMlusU18PcMj4mxg==@kvack.org
X-Gm-Message-State: AOJu0Yyui+R5aQi1gaZwjyjz9vr8OrnIlc0BvwGwxFcKrmZrjkKQCije
	zMIljzI+L99DfrCqhV1blJr2D4wIbJTTCaA5ABf+oEGo5Sjuc7ZiMg/qZxBov870FJQ=
X-Gm-Gg: ASbGncsDTiq1wUgF9YWcBMbgs7yOQuGsO9Vf11Py7UyIBiNXTjO5Qqiy+tr2GBWtx+Q
	SgBSebnQji0yeHqvKanW63oyqSsjDo0kRIKRJ6UUMfSvQlnVeLmREt3bOjJ93JC9nVBUzBCYlP2
	SCNqiU0D4WIXJjqGZ3MNtD2Z49i517u9bP4y+24uXsoylqzEAqWOgMkUDn6z9LT2tlZVHojP/45
	TKHZOXE81vYtvHdKpVXa+K+uHn2M/bbaWaCrWLrb5dXbJwOXsIDPX8vdqr/nPZco7d3OY6d4FGv
	fC95qLSmdMyXTG2XCZXJUDxnaTsaiv+5I1fO9phuVvt0d3RYBKFMkOj/NjTqtOwU4FdvJ6wRiC0
	CwLQR3VkSkrhMJ5kxLdoy8Z5kN4V+T7cFhQ==
X-Google-Smtp-Source: AGHT+IErKXYTIoay7Ej7SNZDCqLJ7m9JLTEB4AI1XMYwNrUrSz0LNSG12cZgvg8Mbc5mynGMGWVuyg==
X-Received: by 2002:a05:6402:5204:b0:632:466d:5d08 with SMTP id 4fb4d7f45d1cf-63467c35438mr1475736a12.10.1758612554131;
        Tue, 23 Sep 2025 00:29:14 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-62fa5f1389fsm10310583a12.27.2025.09.23.00.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 00:29:13 -0700 (PDT)
Date: Tue, 23 Sep 2025 09:29:12 +0200
From: Michal Hocko <mhocko@suse.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, anshuman.khandual@arm.com, linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
Message-ID: <aNJMSNYflPqYMjuE@tiehlicka>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923001943.2479-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CC4FC14000E
X-Stat-Signature: ysxrhdiy9yuigqe41oyeu4fg9ohrmekj
X-Rspam-User: 
X-HE-Tag: 1758612555-457239
X-HE-Meta: U2FsdGVkX184O4SS3FduULwD3n40OzWCis33OrrUSPfKOKDZyy5YI2Wpdnd60EUq6M9zW4mvVBhCkofglYvEednbWh4MUS6OtPOrjen1rNHeeyEP5rDYA4kLFZ+Q6dyGyW1oZ6o+AdgOAUpOKYxUeQWuK1OGwIHLED3gYAoDUjAQvRQgYxZB9VC+ogA7bOFHcf3IQUOVwTCORSOe4T4R23WXCS7GNFe13Re1u3hkY9SN/Kt1kv0AGpGcfetAFtX+XSPyHUw8R/Ieb+y1j5RP4uBweFg9Rn1ce+E9Zm0wWKqIxNUD7R3uPlZVzOEC1opn4a2Z9c1MPF0tY60NccMqAbIeQr9KSYak2k0qpWkVTTzcYii2k1IVhBJf0+vYBOCndxpB7kh2EEn/eGIeMwZDgSMPxVb7zGMhSNB5ifvxsHyCDMEzLH6i9zmghhK1Xy98MXEDriBmz+7o6DXXVqJ/HL1ZbrRsJPo13M7TX0khqnHL2PuDc1Xskef7W7uGee4FyXpiw0gBdW0Asup6NPvecvDtz0VbrLxMzuZaVDVN+9Z4y4mKKQXcNE5/uAq0z96ieGTsO+YV7GmV3Q+CA8UwO9WAdyTljKaWvyPylWjxHJ3/ICDgsFcTkQRLR2CL6cbU8AdkIbtoBv6qHVcjoEWGKYsUbIzRh44yOMqzEmFDXfTictMekHXdO/pwmnWTPug0nLWI8BjR1/QwcJvhrqZvBqLUdmQoQTtQwyRIoE8tZ4Tj/AuCqfV0Nrka5SWVMzXtlOWjx5JGSCjKRgDZX9h0pdPidjvoFs7+RzC+kClu3OzudGqakT0dj1MJ8y/LV+c+sXO3YxC61pXQcw2FqAqJGgP2tGAgGMY1ahqD04KyMeUgVXZGybCH7H9rFcTIa+Gk6Med8YTkFdqv+Axumt3lL2H7bAtB+ZONdrXSr/wnZ+zsK7PypznWs05f95zfNYqydD4WAKI5TJJUzdHRvq6
 O8v++qzo
 CG33wczFKF9JLfCmIRqAHJn5zxbSF9ZnIdpYXJ9HYPH3PnEb+DMdh3gW9AGmphlhPj28tFMABb85GRYh7GPyP8F8hprPQrR2/DyLiaiR1KejuGYRr7qI5P3kjBao50TYwCUMo2ZtUqL/gDMfIjmE20RnC4od/57ve64Z4WJhIaeUQWJp2CAX3K7jNOCbbG5H2e373b6A0LvMpkNgBzy+NmXjmIAAOHnRFYFa9QgcN6phufjrYr2/pralpkLdzn/Q83jILSNvKrD6SWoLCDAdMZpQxE38RZrxu4JJLc/iY4fxC0tC+JwglpqKM8ZTwslvz7fX+ecjRzsyhlpMF3tmm9YykmtCA06UdEoc8naEIq3R8grcmD1Fxwup/NCAGvKpZ30ca/pujgvz0JZNBmo81MiiXmLyA+zzx8EKxNvvV5di/eA+TFkWRXncNDElgHfql9o2ueSWw1/jLgus8KZbC99ki9jKwqSYrmJrFvNgr5D2siaMUcNgnO6r7/uKFkiPuO0DVY4JINiM2sFiO1Lzijw2AHDszua1+3Pbm6NKRvM2ajejLyiRD3lCx4IDC7at0chSZMrqEB+33VDmzH0qhfQeiFiL0cp8nXcvIuC15kyV63XLl+7FckikO/PYd4A40w8GLp4y5Xr1J/kynBL4/IAtdjQsU6CCAPI+SKGftv/qR/Uk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 23-09-25 00:19:43, Wei Yang wrote:
> Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
> introduced generic method for alloc_contig_pages(). But the alignment
> calculation seems wrong.
> 
> Since ALIGN() only accept power of two value, while nr_pages could be
> any positive one, the result is not defined.
> 
> Use roundup() to calculate the correct alignment.

What is the problem you are trying to fix here? The ALIGN is certainly
not well defined for nr_pages that is not power of two but does any
caller of alloc_contig_pages assumes any specific alignment, especially
when nr_pages is not power of two?

> Fixes: 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a1bcc1e003c7..a17a6014e3db 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7095,7 +7095,7 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>  					gfp_zone(gfp_mask), nodemask) {
>  		spin_lock_irqsave(&zone->lock, flags);
>  
> -		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
> +		pfn = roundup(zone->zone_start_pfn, nr_pages);
>  		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
>  			if (pfn_range_valid_contig(pfn, nr_pages)) {
>  				/*
> -- 
> 2.34.1

-- 
Michal Hocko
SUSE Labs

