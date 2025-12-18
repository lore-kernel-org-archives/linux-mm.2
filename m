Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54453D6E2DC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 19:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A702C6B0088; Thu, 18 Dec 2025 14:35:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FCA96B0089; Thu, 18 Dec 2025 14:35:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954726B008A; Thu, 18 Dec 2025 14:35:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81ED06B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:35:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1DDD95837D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:35:28 +0000 (UTC)
X-FDA: 84233595936.12.AF22DDF
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id D55981A001D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:35:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=AJRjlQA3;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766086526; a=rsa-sha256;
	cv=none;
	b=FpwP4u1SzE51h/Kv0tfuRlC0NDv9tAz7KXtyUvKRgp8sK/B1OJhthV1RfH9vHHfrqqc16m
	OqLtHXHts6UotEhIovnSYg8pfD6+g+qoNOjiar9yhUjiUq5vYm9+cFCB1oNRqqu4DExWMq
	WZEoleYTHKGexSzT5UkXHBb4aKVZ+eE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=AJRjlQA3;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766086526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPnsmUEwE96LPEw+aBOKcLpOvJxYDMMIS4oPaZPwqVM=;
	b=FhGC5yVkiBypBr8U+wZlficilEXMHz/cWk7XJBb8Xc5cgaZF9aV/Dzmmy1p1Q0Hlw12t30
	xrBrOg+R4SXYLISpDfQipIhU/AK/bpqOAm1g0O0U0qF1CITFV0QAKLSpddvzoMOeCh9QOk
	fx64YfxdA029MKx7MN/4M9X+lvGnlk0=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8b2d56eaaceso124792285a.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766086524; x=1766691324; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tPnsmUEwE96LPEw+aBOKcLpOvJxYDMMIS4oPaZPwqVM=;
        b=AJRjlQA3fLsVj7tVSbMGW8KMlxMF1Gp5rihJQPL4dt4fZLy4BqyaCFEvTY4kDGQqJq
         wytTOIkcQo7WIyh9yAg4ttXPYwQyxYCYiBN03RzoMVTaoFcZzmYAycnp0kNPHAty5ppq
         jqYhu1yT5FzXfj4LYR5NEwI8ZspAROMip+cJWo9tfK2sz3DLqWIMgNj8E1YPY+ppFMlP
         jkuq77DFqviEakS3K51uH6yge9KvsUw8ybU5eGiulOZqkVS28ctFc2iENX6fz8ZVCYao
         R5tRcIwFWnfvuI6z9GZfnsdVenYC6N+z06uP4prLV7ontSb/CwBlNgpMxVzIrRFSoTWy
         2OFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766086524; x=1766691324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tPnsmUEwE96LPEw+aBOKcLpOvJxYDMMIS4oPaZPwqVM=;
        b=CYdqbjg8ESZsL1ur539M0nOZL5ci2Jf/DTn+gXpmI01hR91nOFxek6a/B06/GTHYtn
         Y2Lm1Hiz8qFDvGySIUAz2FTH1R6jhxgbQjIULd+XP3tTzpqGJLLDaMmS7zBDtuuvEbuI
         sWNy/XigqYgJtQQUB3YHFPljSYY0y2hpq/ENMqGWRqUztNS8mm31m1mbZEqQhsTgCIet
         Cnlr0aTM7cd7aVEraqZP640FdQjQMJlzT1LmNAkl8IEIQS+CvYyyhKfc40441itOdNVp
         eNoBPDxCVN+rQJjIL9a7Yrb32O7CmkL5+5GgpVDoxVShXTcjclRCuHwPBOaQQQwhlqFk
         xbuQ==
X-Gm-Message-State: AOJu0Yw304EMmu7SA3UBD9N3vzKh6N9y4elUTf8BTgpshiQm7HjcbW5F
	9pQxrQegLRR2o+NFRvWpw0tk8UszzyAnJZSjHempmedqyto5VbD0MTc69MkNqygK5ZI=
X-Gm-Gg: AY/fxX4uqGeDfX5c512bRDUm+ue0ijs7bnMT1XY3dy8N0/cprquZ6qa0QSj2QBSDscI
	ytHXnw0ASLJmp+ghivBuICE9/CHB47DNIACL/PIz0fCYuCFD5MXGSfNx2ZqOHVQ7LZSepXk669R
	zZO/dNdVhJ/4in8fTXgvzzRnowB9S0cJJuVnDUwZWpOSYsFZSajAvHimt3W1arwBC2BeWAGkvcm
	pou7rbZ3hzJEg0blkhVrMHhjN76VRQJyUq5yC81DLBa3URTG4bw7nXpE3QKSsT0Ru63BGKnwpjT
	Z1aRoSYhETm9T82r3+WQEVFwlHlJEyTY9v3VIdcQbu8L9nFuy8SQ9EQDinc6+z2eyxz3danDO+n
	ltFH+KC6hMZRfjRGepWVV/7iiJEbQJ0jjrCIiGwGhAhUTbDkkZp5dEX0j3Xo8ctrsmvk0xBHcWW
	sXAkH5883TwiC7uqJnn98m
X-Google-Smtp-Source: AGHT+IGrs4VbkhCQleHuOleoIRCMYVO7M0a0Znkj6dsun+tRNVpTnsDf9xzduXpABdyrpmhuuHhdgg==
X-Received: by 2002:a05:620a:4689:b0:8b2:eb79:d380 with SMTP id af79cd13be357-8c08f650f54mr136659785a.5.1766086524574;
        Thu, 18 Dec 2025 11:35:24 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0971ed974sm12132785a.30.2025.12.18.11.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 11:35:23 -0800 (PST)
Date: Thu, 18 Dec 2025 14:35:19 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	richard.weiyang@gmail.com, osalvador@suse.de, rientjes@google.com,
	david@redhat.com, joshua.hahnjy@gmail.com, fvdl@google.com
Subject: Re: [PATCH v5] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aURXd7d1on5vxnnT@cmpxchg.org>
References: <20251218190832.1319797-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218190832.1319797-1-gourry@gourry.net>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D55981A001D
X-Stat-Signature: jeuzcr9e8acb6ba6roycpuaurhur4dyu
X-HE-Tag: 1766086525-860602
X-HE-Meta: U2FsdGVkX18XB2xU66sJlwYvPgi3tXSqt0aL2rKPxwjm8mWjbqv7CldcUpCA0V8GDkkMixFpo8F4mtAtOwjWpU4UwYGa7Vl8T5n/K4CtOrRCYXXSzUWAne4c/MBhc2c3nu8Jb9/R0uf9RQ8NALt2R7zChdjQ2q/sAEayoNEfLUg+FhR+hV9//8PiDFDTQoiQm0HT6iqfRahhCXRZ3WCC4cTDgAHuNkqOhMva1EuWZ1g4+SZ3WGwv8geUz9OOtZpLZfGQKFZiMospgcVN76uQw4UO/RYKwZaM2HFKPqaU/KSrbL5iGNLSJOCi2HvM/OM5kO6rbPSh3OCiCOF62nh7JCEqnR8ZHXS13Hd4ALQ50SMHIqu9jgo2D3goKVWquHhUPaW/2vt1c6XUpa6wl8Y/c3GAmFFM9IR98J+2Zjq92YBrb7tCv7B7cAv3GHo0PujX4HRMyjJwoWXBBOTIv1A85akGZWN7D/nrMaqJ4VHfekJgTfvMoK5f1gSiHqIjZAWNbqLt+rJ1vqBEfJHG2O7eoaw1ny/W5XsR/Akr1PR/02RPkJkLwS5jTzWMpvrFOmJEdZH/X2CObNVyXtKNwYLxoyul8uuxY169SP3ReebuU6yHOHiwYurBglVNwo7uQbGKoRJGx2h8aOqsdFLmh/+JKeuEtmQDp+x1x5K5DeztVPrvw+Re11wxLc7kH9iTnr6vvcILqRJUDnQr2H1Nx0XMkZGZTDhuU7qfRjGPUh8RLihjCAJliiqCXmxyUMNTSzcbrRIUguQ0IFWEZTEmI3xVYYxjNqwzJQBImhdc+1jjoS25Io6VhJJpRJjuUZliJFI6vI+L+Ary9dP68QdmMKoou7eAAyZmJkEGxM1vCuTHiMb+0wE3WKWAzP367fELLGwEBlAO5BezM7yypmSiRXAtPD8JO+XlRV9AsK4zE6v+H5X8qmN2yN+d4IOuDn5I3RVxWuo/r/9wtKjsn82DQDL
 oXPl2gj/
 VpxcMryCJ1egt42+4S6TMi/yoOOP3GdBMKB56VhkwNIQM0D5wYUUtupoN6w+0telUoiJKJyZTU6L+gWnQzQNeY5yVSBSH5mIxeuCaWBG816cnidf7XSyHNpgQetKAs4FoPPCk6WLOuXjviPx/y8IVPpoImLjwncqNxn71GDT9Uje7W4TKRSIo5c5C9kUzwmpXfwzWmb63XosJJn9gttKdpU6RAcG4rCQ0k8gc3Jz+K1aK0XpqM6cddGUDcn2Q5at+iG5rcvSLYVmcJJfcEECH9ffBuqBdBUnCTBnHJxB4se0mQm/uMMDux87AYRyPBTTIvZDZqiliz0T27vrLx/LpjwQIRSbE1QhUzz1wCts3vI6/aqYqOFTH0s5curc10nDYF5vHZ4wEb+8henYU+7SvbfI0FQQms3D9SSm52XlU5XKOGv5r6teJhfg7kHf3WsOGwJGIJlKjj8DNqnad9eaRCeVrjAZUviPBBQ16S/SfFae3xpPB9zgM/JHUaScJoKRzqHmvqE1VmNW+X5E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 02:08:31PM -0500, Gregory Price wrote:
> @@ -7099,8 +7099,30 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>  		if (PageReserved(page))
>  			return false;
>  
> -		if (PageHuge(page))
> -			return false;
> +		/*
> +		 * Only consider ranges containing hugepages if those pages are
> +		 * smaller than the requested contiguous region.  e.g.:
> +		 *     Move 2MB pages to free up a 1GB range.
> +		 *     Don't move 1GB pages to free up a 2MB range.
> +		 *
> +		 * This makes contiguous allocation more reliable if multiple
> +		 * hugepage sizes are used without causing needless movement.
> +		 */
> +		if (PageHuge(page)) {
> +			unsigned int order;
> +
> +			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
> +				return false;
> +
> +			if (!search_hugetlb)
> +				return false;
> +
> +			page = compound_head(page);
> +			order = compound_order(page);
> +			if ((order >= MAX_FOLIO_ORDER) ||
> +			    (nr_pages <= (1 << order)))
> +				return false;

If you keep searching past it, you can step over the whole page to
speed things up a bit:

			i += (1 << order) - 1;

