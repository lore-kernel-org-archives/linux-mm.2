Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A403EB48EC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 09:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D756B008A; Thu, 12 Feb 2026 04:05:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644D06B008C; Thu, 12 Feb 2026 04:05:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544766B0092; Thu, 12 Feb 2026 04:05:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4454B6B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:05:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED83414050B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:05:58 +0000 (UTC)
X-FDA: 84435222396.22.9680D73
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0FB0140007
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:05:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KaR81Cq9;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770887157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QvC8htwjlKjik6LPXThSan9sFlQa0sJHTxsZTnbz2Eo=;
	b=008Lgzlsngo0SbFYeOGMFeJeMlMYqTvIcqSHXtmbqMxQnXmMYG1AiK66VTQMIhnfn7ihjW
	zWJprkcriUQwqjxoKTKncYrgyxc6FQs0YB3U6TONplGR575x00JiT2gpjyTmbMjd2oSlX7
	gWL3C8AhuFQFqrh7qqa2IIiFrSwUceM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770887157; a=rsa-sha256;
	cv=none;
	b=sc55opWp1TVqi3/+/5NJzXF1dxIWz7jFqaTrtsK8mJ/sNOMJXQUbPaewds6iol/dFmEb0S
	f8hz5AhxDEtNrXU2HwOBl/08PWB+cRzTqUtx+qi8okLNERIsTlr+bta3r/WkLqr29FBSRp
	b3lU2xW1JUS6q92v+DKPnQncShtM45I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KaR81Cq9;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2aad1dc8856so33685265ad.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770887156; x=1771491956; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QvC8htwjlKjik6LPXThSan9sFlQa0sJHTxsZTnbz2Eo=;
        b=KaR81Cq9+R/lEi0J4hyZPp76gTFL9ADZB3QFJCVBPI0q5o/LBCXTswa/0a+CgIjTES
         H3WYXeo3Sm32F1bZQbIEipKFY6ZrJpMRaXVvo+w+6KSt+DmTDAdnjcu7yMXJfgkQZgvJ
         rMkRnf0Mm9e/WFwCeWabxNKrdyaQ+OhyeLPSs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770887156; x=1771491956;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QvC8htwjlKjik6LPXThSan9sFlQa0sJHTxsZTnbz2Eo=;
        b=uIZRzaVAUDKJ9rM1boG71PgiDsHOCix0AOJ+7z2IN+GRq26MIz2ydoExdGy+3T4RyK
         3khaPkD/jEdxHZNF3VI456oS+ul3mauYS1xfrW/IdufJfcwJj4aSqU+HeCLRDjzfXIf0
         LouHx9irwIScIL8draNn1RNxAMVB2fEX8pJAO1swr29FPHvS/29s0Ih17GZ8h1RJEGDV
         sWf7C1I+IFgcD9oT+eU/4UUEe/GkEkvqdrscPuinN3gRWrQRJICKfAMEfJ8xNQOLMdm6
         OK/YlKblUAXuDiFHuIjD06XA9S6GTU12o3gNP7mDnsc2k9u0fvcPsPlUAfUijU4V0hB7
         1ANQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOfPTYcJayMrts6nQ92MABZ6D0I8BgdVsNevG99/jYZd/6ELtPjBH08C2xnpLFEAfpMZFp5cjbyA==@kvack.org
X-Gm-Message-State: AOJu0YytWEPDm8WNHtawLqd7HeAVBzBTrVw52oD5DMiaG94k0qQPzzuM
	Wx423zG0rphUEp2mU/WF8oqSvviKvuPQaY3YjoZatferQxvro7p7nURdvuzcxMbEig==
X-Gm-Gg: AZuq6aIfpN3TDz/1HtpuvTMZa/vWyWx9G+Ntc/8crHNHS131GQU4MPQszanWG3lxS1H
	/7FPc3iAflO55VKF/O8YJpJDwHK4ezqCN0oYZSqol+1BuddasqXd8tay0kAcJPz1M2tV3khAueV
	t27K6Ya+jrguABznRlJBB9eu1H2Y7Mxokfe8foXMOqJe6dsx4fbePY2kmGAcr4iflVhN5xm1mGn
	pFf+C0wducTC6RfVTNrxJfSJi2dgCalSopD92jEKJ941G1Slls70DR8/u3JPDcMyfQ3r3vmPp98
	e6C1a0mewqsveCfWkn0mgmJygQMNlOX3rliZioPfVZ/rKZWLE3VUA/LUhByiabKxJ59X2VYWAEK
	/S/R4xBMCu5uB6Gdi3oL81JkxQFtbVYVVLRkG+PbiPnoIpdeBQQmWA8bajCW3/a5pkfObpgiCeA
	4qkqHgR0MDcEevXwCduKVyzdhe+SYyc9kbz7K4m/xGzWFx210WGd9cxR78UBeY3w==
X-Received: by 2002:a17:903:22c1:b0:2ab:344e:1400 with SMTP id d9443c01a7336-2ab39c563d8mr17517185ad.37.1770887155850;
        Thu, 12 Feb 2026 01:05:55 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:725d:f34:4b56:7316])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab29998eeasm47659115ad.87.2026.02.12.01.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 01:05:55 -0800 (PST)
Date: Thu, 12 Feb 2026 18:05:51 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
Message-ID: <r6m6vdhbqada6i3gugtnj3lytjrkyiretihwebwci423vwslcr@ysrgdqvvno6b>
References: <20260211031512.261127-1-senozhatsky@chromium.org>
 <104bc764-5a20-4ac2-95a8-b31f41255766@kernel.org>
 <jftqdosilzfkd4ku6pjuevkvuwmhlqtua62jwsmmgdfcseitb4@gopt2xzqhyrk>
 <3571cf8b-9fb3-41b2-a402-a8537ee2c399@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3571cf8b-9fb3-41b2-a402-a8537ee2c399@kernel.org>
X-Rspamd-Queue-Id: 0FB0140007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ceptq6iuetagjgk55wk6kfcqb6oi1pez
X-HE-Tag: 1770887156-52528
X-HE-Meta: U2FsdGVkX1+6LWBDGiZHJVRzdRk5C/lNcYx/5UnhRgj7Y3IAfqvH+UvRY7X2slAU956GzMeBpQCh7aqT2hZjldEb3jr2B4l/LdGGVbY8WGErGjyLYYPUTDQ9Dadv7vM3DvOCFU6bMoWiQJaLUUlSkdOaE+Sztkky8XNxNUSxJdbtaHLhLRtYMwXYDaMsyCiixl9VR09fChf/pB4tuYLGL08/hnBL2AtRN9Y6Fhw4LXDfFH3LCyN+i5qWGl2KJUjtHbtYc2YQkYrQfekJEHqWBWGOxbVbzwWbP0g5KRXirpUWB3gDftTGglPt9EFoViYwo87XyIS8gehAHSpxndz9754YJEZ5p4/0NNudoFtSXuZRPh3ELEL2ZgMM6sOKKMFex3KqCur22NfM6m0LXmdh29yKFKNDNuq0u9llLtqvy4aUtjQCdxqB9jD5s7vPJkRAfLx838phTG+aXkQwSpJ/nqzVz/Xh0GPAHKcOfEPa6s/4HoeDlSeSRBoWqmRmsHq5JN/q27BxQggDtUROUeLmplZCnMF29rCM7OITvnp6KRQw6BAak7FkdST0a/uPDDMtmyeZv6s9UZSzFM8NdNvC10e5hIr1UEOZ8Y5D0BxLyMy0PTTTuKUkjB22E4TLbyQ7soQFCX9czEL8wDtHUEI0lgVaE6Al5WLw7DMqkgzczwiQ/FDGAgdGyl+9GSrzPFaKSr+PKM2HLBHi0zx+L+kADaJJlhVKN6Th6ntSHp0pOQId72S35bKLbIfVu54E5dMdZmTFKjuydov5rmwISTqaHw13aeXuY79FXU2gyiNWYXRstcd9ShayUM/Tx46/eveBemqmmJTy+qMAl+tSWBa/TOlnOmYnHmSBoPmPEAidy4h4g8n5qx02hB0BTqjY+IXTiFMQdmRTyYraie5k36uW0VTLocvlhZoBxtm0GO2kBPZdBNgmz4Td9mDGUuWb5FqjlA2NBGGxBkYiIbafZx3
 VZDCehYq
 IzW6ZsCadeXV9RgJ3e7HC7TrAtMvhGjD3nD+MIsMK/gHGdiciSGW/gPvpUqZxuA295GO7KSxfW/NRacXaYHeehNKUOb0M4wwNnDHWiptFSqzaRj8GyMs9P9OoFqtT3QLjlIu2gxpBYtR+WpZjBCSQm8VtatNB6ILlToJpkPlolt5J4wBKHrYdnllGZK2AY+W72aAc97WPffXu/f4EYqnv0rnO8NTTAH1OCM25b5bEVlh14WM0ogav6zICF2jEFdV288qpbEP+TPzPc4Wz8C83vym4zU0GB1BBFwPGdFrxbs4if7mO7bZ2Bh+2Cu5lxH4T5KG6kBzj+DLXKjZa9YjSu8b+aZom7mZZgm2h7LMv4k8BAdRTQOo0+Kij77wgfknhbfZn5StqM8fEBaG4HqowmVC1Tv+ge8La5gxp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/12 09:44), David Hildenbrand (Arm) wrote:
[..]
> If we're fixing an issue, we usually try to identify which commit introduced the
> issue.
> 
> For example, support for freezing was introduced in
> 
> commit 878aee7d6b5504e01b9caffce080e792b6b8d090
> Author: Andrea Arcangeli <aarcange@redhat.com>
> Date:   Thu Jan 13 15:47:10 2011 -0800
> 
>     thp: freeze khugepaged and ksmd
>     It's unclear why schedule friendly kernel threads can't be taken away by
>     the CPU through the scheduler itself.  It's safer to stop them as they can
>     trigger memory allocation, if kswapd also freezes itself to avoid
>     generating I/O they have too.
> 
> 
> 
> Now that I am looking through the history, I find:
> 
> commit b39ca208403c8f2c17dab1fbfef1f5ecaff25e53
> Author: Kevin Hao <haokexin@gmail.com>
> Date:   Wed Dec 20 07:17:53 2023 +0800
> 
>     mm/khugepaged: remove redundant try_to_freeze()
>     A freezable kernel thread can enter frozen state during freezing by either
>     calling try_to_freeze() or using wait_event_freezable() and its variants.
>     However, there is no need to use both methods simultaneously.  The
>     freezable wait variants have been used in khugepaged_wait_work() and
>     khugepaged_alloc_sleep(), so remove this redundant try_to_freeze().
>     I used the following stress-ng command to generate some memory load on my
>     Intel Alder Lake board (24 CPUs, 32G memory).
> 
> 
> I wonder if that made the issue more likely to appear?
> 
> 
> Interestingly, we also had in the past:
> 
> commit 1dfb059b9438633b0546c5431538a47f6ed99028
> Author: Andrea Arcangeli <aarcange@redhat.com>
> Date:   Thu Dec 8 14:33:57 2011 -0800
> 
>     thp: reduce khugepaged freezing latency
>     khugepaged can sometimes cause suspend to fail, requiring that the user
>     retry the suspend operation.
> 
> 
> So it's a recurring theme.

Interesting, so 1dfb059b9438633 and 878aee7d6b5504e fixed real
problems "khugepaged can sometimes cause suspend to fail", but
I don't see what exactly b39ca208403c8f2 fixed.  Sounds more
like an "optimization"?

> Given that we only scan "khugepaged_pages_to_scan" pages/ptes/etc. before going back to sleep,
> I wonder how that can take in your setup that long.
> 
> Why does it end up taking something around 20 seconds in your setup?

I only have bug reports at hands, I don't have a repro.  Can the fact
that swap reads require S/W decompression (zram) add enough latency?

> How is khugepaged_pages_to_scan set in your environment?

Let me check.

cat /sys/kernel/mm/transparent_hugepage/khugepaged/pages_to_scan
4096

Hmm, doesn't sound too high.  Let me look more.

