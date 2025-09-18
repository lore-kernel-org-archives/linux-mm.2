Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E523CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58FD8E0148; Thu, 18 Sep 2025 10:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30B88E013A; Thu, 18 Sep 2025 10:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1FB88E0148; Thu, 18 Sep 2025 10:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF6C88E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:38:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90F1F1DC277
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:38:39 +0000 (UTC)
X-FDA: 83902627158.22.C19972F
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 433FE160002
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:38:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=gTYraMVv;
	spf=pass (imf08.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758206317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXo7Z6a2sgLXno3+k/FlpZhS1UzmF3Oswcd7rfRRafg=;
	b=q35DFhK11QGwG0+7t3fwl/44nP613sVpBu2B1X6XrvD4RNWTqlcFLl0HyBSWtDJOoTqDIn
	3oeJ48wThMywOK+JYi45B+Dl1DXTmQVpQzRTKWSnpQRk28rse/oI/f7v8Nlj4RrlrG/phE
	XGFJFXlC7n5ecfn515l78AA/Nbla4W8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=gTYraMVv;
	spf=pass (imf08.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758206317; a=rsa-sha256;
	cv=none;
	b=k7zaZAPDO9j0uNCL4U7X28ASXjLVHLsiLbB1lOU810tc1gqLyA83nmD9subTxlErw5DeKO
	NllAqgf51yfVBXShdyHJPQ4ibKxckIqEwy2pJyK/zyucka809pKOdxdwFczl5TwcgB9g/u
	jbCpdFtdNV0rjm0zexhofTHSAs97VMM=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-78ed682e9d3so9226186d6.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1758206316; x=1758811116; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OXo7Z6a2sgLXno3+k/FlpZhS1UzmF3Oswcd7rfRRafg=;
        b=gTYraMVv7zHKNXXzxjfskI04WzL8UwcYncinN5rYlMld0WUMwvJm9EtNWTl0JzE/59
         SIwWK57I69AiUtec1fXsvNHplf3vSfgMF25Ch/rBbzGFEy9kDaWitw0NHFm3ISBcifkf
         +0a48EVBZFRfysaftBx0j3Pt1r52sUby/nPrBRPnItV81Y+zRi5oRRh5b2tnXWaVwRUF
         uU9wsBDE/R0rxu7QFkGAlZgK1lcX6orJBJdI2+tnEEBFaFsdaAA1MaQgOYvPlYJ37b1n
         WD49GsKO1Ff65yIj6RSkBPqNHcnsn4muR0YAULWGgNoQhqHL6tbuGgtcMeWPcHKKyRHM
         3JYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758206316; x=1758811116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OXo7Z6a2sgLXno3+k/FlpZhS1UzmF3Oswcd7rfRRafg=;
        b=QGGbYGlJ1Cd5wMRP3cYp/zpTcMh/skgCgc0iuopDHyy9y6+TdoXoK+E9L4W02B0dov
         YZw0fyXc/HIYw3qD80ayA0gi8Kcee9SwJdt0UTNtZgV2fv4+eKCp7Euy44hYK93hZASl
         Y5eJzWWgizcmaWMqWQkARiKaUGHWjUjHk0/CZyl1wEMgvT/H9JTloZXKpigdLATi3YWr
         NI81tIofL/5URtYMqCd35opx47sCrFScwoHLgoro+z4kw0be0WhdimFoKo2y+vsgbnNI
         4AnzM7CZKXsU9sJfoU4SM5mgpAtMfkjQWimJOig42bhnDMmYUNPt6iViJHuPgj9YDOxN
         eEyw==
X-Forwarded-Encrypted: i=1; AJvYcCX0q/FQFP0n56qMkkD41Qem43/o9W0JalrUX1qtevw+gFx3uLQS77/yhewj8kDezf8vWazuzCkFNA==@kvack.org
X-Gm-Message-State: AOJu0YyrrfcWtYnlowkAB9h9cMRDxzc9mI+A9R+rIvZK/wESH5I28kaZ
	QcFcS1bUIcYROT3hI1LWVw8UyHHEQl0LEAOaO/M1jgnZwAo0VLmBzfUV4B7wD7Ia9lc=
X-Gm-Gg: ASbGncv4JrrUKXYumfzPzLeFTxNUl3BRSJEd5+PJyC08Vz5my5snQR9n44O/l+5tlUD
	KL1oP7oQTnA/A/DROBvC2c5rO2QrQlaDh9DWMtSvmaxckiiWV98L3qUdu5C6Ri+6+aS3Calr/Hp
	LZGb2utkTORSsPUShAwTYRJzxXI2jrjhuLVYBLam/4eJkOKIwbWM1+lsTlLJHCOLCHv7QEnEzRp
	jmKeV1wmrsyXzwODjTTMmHa6gyHN+cdqaxIueEc9/bqDJBrs/SEYpqqQA5Lp8rryW1z1Wpe/PSb
	zAv4YIkHxTBdYoL0QnvHY31Pqf1EpEOyCh1Rg/JH6rbKhTUDjB7PohV9fWwgJfBscj3MTWrtVCn
	Mkgcf1BZnvTaV2Kw8XjuEhV/LYNHTVAOBFKBao7+Y
X-Google-Smtp-Source: AGHT+IGfoackJcqv2FUQjy7cqufVkoDvxBHVcVbjZdSQNUMCoEqd8Yh5cnnk7r3+CbXlF520+mJIdQ==
X-Received: by 2002:ad4:5e8a:0:b0:78e:49a0:2ba4 with SMTP id 6a1803df08f44-78ecf111245mr63140536d6.58.1758206316038;
        Thu, 18 Sep 2025 07:38:36 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-793548c6e02sm13732616d6.60.2025.09.18.07.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 07:38:35 -0700 (PDT)
Date: Thu, 18 Sep 2025 10:38:33 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: kirill@shutemov.name
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH 2/2] mm/rmap: Improve mlock tracking for large folios
Message-ID: <20250918143833.GD828739@cmpxchg.org>
References: <20250918112157.410172-1-kirill@shutemov.name>
 <20250918112157.410172-3-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918112157.410172-3-kirill@shutemov.name>
X-Rspamd-Queue-Id: 433FE160002
X-Stat-Signature: da9saofco4nt7pz7ipqxmjcbk539kwzp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758206317-126144
X-HE-Meta: U2FsdGVkX1+z+nCLCKKkzeRZkMGkGRrVO570UI1DO/fQnePGWuNsFCbvr0zoBozpWKr08vNI5MZGlJgtGxvxhByHYdmPp6FNddH0Vah6AMVH8v8PupEvbmTh4lPaIJAeRmuIilBVSU6zaNzJrY+ktnu9Vna6Y6/ygGFupQ8qcT3cquaQsvyfLxR4erYpkPQOOnoWiaJKb2W3w7XcEveJ7qsaaymtMrtuWCsKDsKLaK+odS3dbbq++CTFd+kIC4jX3owyYcwNUmtMPmfcwc5JL952U6wFbwnlPADKL7yryXkdVOBon9CrLb2KOS+yLlVZoTFrrz0A8oasnE+QsBDeR3U60qZKWYJvX32kbd+nBufem56rsoi07XnEId5FV6HpGhOS7FTsEOBS9kpTQxh1cKv65Bp0i0H4vMy2TLyuWI1gRUz83N8fxxFqFBekAtY2NnpUXNtmFzqPE///FgSAYawBs3ZzFhrg9iVH6alxCIZxzUBgEhxbBDKPGlN4+4MldFDs42DZp5BoPN+33iskgbn7gc1ZxrY4NRekEvZ7t/kTz8GNy5295sRKCuAHPvhw/iUtcHC8oQPWQjDUS5SdkrwbCH3WHYbxEHoiYktJZy4fN+rFciP+m7Yea6++qRHqXgS+qeUaadlppX2J0H9JPlXyRHJpKAPwGUxNQi7yPdFz8EoCbytrEOUo9Lrhyk2Jd1xgNVp8C/XAqWwfEFCmNqVVgzq39gFj181VwIgu4cvz3PtfgujcI5n3e68+slzKS+4kQX9v+aeUjwoRIeqT8F1h9Q9HATKwAjIRLXcGe5G0bEqlypG5aaTzThaC8LPPgiQUT2P6aq3OkX146sNr9+A9r8Qd9x1uApMeZG/rVzEy2JD29RFQznHwiHjDRhquFg2nPqdnTqXqfTvpsBou7pxA1iEC387dcMkCAq1hzgLWYHHCy3C3YfzI/g+eK6Td2KhX7kQfWtlroK6nfzt
 Urokk+e1
 AgAE56kx/B8cYv/K2UnD3W1vFKf0SzXrn5VP8FS19KVcND4uL8hvfSUFIiZktIc+zo88XYgEvV881tuRfEXQG+P5Nyohu2rsjBJ0D8qNQBOrcydSxZm/SYs2pFc0L1LCD2lugMc5dvF0qBVC1CWzuIA2peHb9tiB0jI+j9zkW3+8vAT2rEGANLCKuVum4Kzfaa7IEadiigp3PZ/RwfvihfKexqsNUuqQ9Za9jA/cDSBkHrsH7h77fE4OVC9rzMcUM15jsq2JuQ/DmwMS+oNvaU3JTMod0YgU8FcsZ6gScu/oCkLcJ3HVBdx0gsPxFKL9MeAUfQjMBJBBdPX/PZgh1zY2abLbolYpv8fav/y7so0XlH5kq0dAQcLAUu9pNZSQNK6XMsfn8YZGrpfBbEXBHnRj4LzGYLwh4G0in8lnL/+w48fLFVx01+8kawPLkGud7pUiOtQoZWNr0+W2VBxJ9sVtb7wVSzmnBqcxHHKLocXquB0dnamsxxLrnvPuZ8bPEeoA6TfVimP4A4dxdQcJBBiFGvV9hvQF70UGDWAej3orlluc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 12:21:57PM +0100, kirill@shutemov.name wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The kernel currently does not mlock large folios when adding them to
> rmap, stating that it is difficult to confirm that the folio is fully
> mapped and safe to mlock it. However, nowadays the caller passes a
> number of pages of the folio that are getting mapped, making it easy to
> check if the entire folio is mapped to the VMA.
> 
> mlock the folio on rmap if it is fully mapped to the VMA.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

> ---
>  mm/rmap.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 568198e9efc2..ca8d4ef42c2d 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1478,13 +1478,8 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
>  				 PageAnonExclusive(cur_page), folio);
>  	}
>  
> -	/*
> -	 * For large folio, only mlock it if it's fully mapped to VMA. It's
> -	 * not easy to check whether the large folio is fully mapped to VMA
> -	 * here. Only mlock normal 4K folio and leave page reclaim to handle
> -	 * large folio.
> -	 */
> -	if (!folio_test_large(folio))
> +	/* Only mlock it if the folio is fully mapped to the VMA */
> +	if (folio_nr_pages(folio) == nr_pages)
>  		mlock_vma_folio(folio, vma);

Minor nit, but it might be useful to still mention in the comment that
partially mapped folios are punted to reclaim.

