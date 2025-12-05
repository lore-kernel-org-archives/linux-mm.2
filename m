Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B01AD339B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015BB6B02B0; Fri,  5 Dec 2025 13:43:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0A3D6B02B1; Fri,  5 Dec 2025 13:43:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF89F6B02B2; Fri,  5 Dec 2025 13:43:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAB8E6B02B0
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:43:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8551687FBA
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:43:47 +0000 (UTC)
X-FDA: 84186291294.05.39710DB
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id 92A328000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:43:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HTuSvBOB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960225; a=rsa-sha256;
	cv=none;
	b=W6qPC5e8mOf1JNfTeSyvAJd16Y9xou8KR0c9EmHuwWptrIVDvwodvujrdNszYrJ9XScnvg
	Oa3Y/zGpHfSYFGVpq1jXQZcpNa4P0qwWjA3DdPbr2p32cIrPEQBbWp3u9ZrnQLpwlUWZJf
	cKZgKCRxfwy6ItY4XpE7Q3hLnsSA9zw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HTuSvBOB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7/1aFNzttjrEmgH/GMBCatif7QSIzkL0ePxeJlf7xU=;
	b=duc4YSm6Tz3fZPuQFsMFI2xJk6NXHJPsALYQo8vGmdWTYtSrd3tMZF8sclXNuWkRwfOAW+
	vS278QVdr7fCQwKYn1ltxtQux9sp8s2p2nflmTLmUWdkFI2AEnE9gyrCpNGpGiIZgZ8Aha
	QQp9Vfmpt5mcvZ0c+drN/Qxl5cAz+i8=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47775fb6cb4so20244555e9.0
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764960224; x=1765565024; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e7/1aFNzttjrEmgH/GMBCatif7QSIzkL0ePxeJlf7xU=;
        b=HTuSvBOBriRh5MHiuasnbES8Fps4N7rOMta/Ybuc1fU7zZV5VEV6q9bMcW2Gf8n7BV
         Ud2VN7c17fq8OeCTIMkEE4dY9mhg1NdtkvjUk/PjPVZuKLFI2tv/mJvJxO12mlZRLpb8
         GnTPqnnFw1mqaLhgoblRsB4+H4vlf14rBQRoWfawevNGHts6GSpfbECGGFTQK05lEL5e
         NMGRPOZM9Ju+GLXpc0aDa3xM7wdZRJ5CINGA6flExeY33+GxjGC6xe/3HcUmByEKzCfc
         1TjHLH4DXzHeaFhG1HIu6PzlLZwucFTJikQ2S4P1y9+g6QT4sujBn8Hz+tN31JTXVlML
         oV3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764960224; x=1765565024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e7/1aFNzttjrEmgH/GMBCatif7QSIzkL0ePxeJlf7xU=;
        b=SIuZgcX7vZbbj0Q/bdyxI7g7nKO6oNaec4PAVZ6KZRGGb/Ut4+Z1wiCHFf+dGtbVcM
         NvoBC1yohExXQKCg+u/M1zfNegJu7Okmzqxfno7uqHlH1DESy5P7yjj7HGgSB3beYNZs
         6qfpEi6E0A8b4O60euiifN748hnyh/StbTl4B1rxERFk+EbK8FKrUJgUb02XPxYOJfgP
         67VDF2rh+1MccPx30Qyakj5sJNn/R2k5ZYz0QHKZXOi5tlvvs0GcDHoK57Jpf3nVwr6K
         l8N678rBnslAvmx0/rLE69HSoV9qFhnE/QG/kn3eo2xqHCN/lDh/UG+CgiEzUNFyPYHg
         Sd9A==
X-Forwarded-Encrypted: i=1; AJvYcCWDHPrJWrWG+b2n8QLTcVdeI2kRiuarP9EndTyd5BXUgELZAy4cMi9ZhtT1X+zXHAtcnBWy250Pmg==@kvack.org
X-Gm-Message-State: AOJu0YwL3dnyLaXpHZFlAd9Ax/QRTtlqk06OmruNM7qX7xhaZlPDjqP0
	X2thpUfMF7seM3Jmyq7xmu/24UTryoq3ofHcbGMmGq7KQ9Sj2xj1VuXl
X-Gm-Gg: ASbGncuCvsxUAPot49LY3ZrihIsQC89jnMB2HCMW1SrrVtR4UkBjh2EFNy4lii9y4ui
	1fF7KCVtsCTLLt6MsYs2Y/0AsBStW3naSJjwAQl5QGy52nXk6wB8Z2Nad5cZ/90TnJ8fADp6tRF
	MPmT0X5lUhKEaCepSxqyW6S6gGsAIqu2rIZVlzSw1W28ICe0YuPACKDyZ2QkWpJuwirkzXB0Wnt
	yVY6uDYv9RkWx2bmi8Kv0NS9ZBCUbZJnzXlE6NQpvgUdkIvZSC4zigFPbrOnp1Gw9IDnsRjE601
	PDZ30XXi1bcqs+rKZSyZhe0RTuyxpnwymUWAlmvY3uzTd2C6iQcg8rVrdaNmJGKOdKUXxi7HuVT
	1GHvpiZXHyOdwcg21KrClUKd7TbFabEsfYZJIsvhKTAkBpLgbqL5Ev+KScAI2p9E3stbRSz4shJ
	pS98W6GRWGofTTjcdoVVaHytuA+q2Z3IS8/UlF9BcGltj89WHb3zvrOvVUnDYpgNw=
X-Google-Smtp-Source: AGHT+IH8oQxJQ9sHJHXNwvtBMYhabUCo0pJF3Bl/B5exsqnwQClYz+RaZdZVl5XMm6m3+ze+0+ysCA==
X-Received: by 2002:a05:600c:6097:b0:477:632a:fd67 with SMTP id 5b1f17b1804b1-47939df44c9mr3268515e9.12.1764960223836;
        Fri, 05 Dec 2025 10:43:43 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47930c76edcsm96140615e9.11.2025.12.05.10.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:43:43 -0800 (PST)
Date: Fri, 5 Dec 2025 18:43:42 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <20251205184342.2cfcc73e@pumpkin>
In-Reply-To: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 92A328000A
X-Rspamd-Server: rspam10
X-Stat-Signature: g8xfy6e5icks7rknwjms73z9i3uztau3
X-HE-Tag: 1764960225-914273
X-HE-Meta: U2FsdGVkX19mH2A8jgr1J9+YUZpIKFGCPAYlbVRzslTSUqkWkRYKvrGndQZOoJWJFu37azj1QT1Fx4rf05yoWMRaQnOTtPHs7RoQ4G1kbpxWPkKthrTpEu8BEzjs/frQvHw+q/WoLEkcNOtidEwnp8dc0FR53h4MzHtDj+xhM+iplxWZKzJK7Lz/FcMFrjeUJ4voouPgsjpeZ9uRLACGe4scIlgoPy1lgdU/zqToY/YwGncx+SRPbkXZaBcx1g60bGMmE2QMiJjVrr7IQ5mrHIbRCj3k1N2zTVZ3ipEpue7gWv67BP3FrqloCpGnVyef+VSL+zzaHiTld3dQnw9rQbZBMDPodO2IJg0gJAB/vZYvKmmMCTyVRSzFZyFJHFd8oxHMyT+AhycXEdn7b+Me5Ujgku1LIXJAJeJUz/BmiFSkFHwgKwtlyNM+Z/j2FK/9DnEzToCJUs75689pbi/mKSiamHCT/+XLRtXAZFF5Bv4tP0NqZ9gtQ0vNsfVRcJslevaroChtVaA94n9zYHPtjSveKzpyC4RtQf8/Hy//U/iuHR8cKEE8uASlh+8E6Wg7uQEw32HrKDiwM7B9ddUQtVfqBkXJR9FXKfi7vOgP6cZ7AXG4y19milf5Ks4NnHkdHcHbbXoz3ho77ZkaMFq37h4rzmK+I3kpikaXJ2hR/Y/kX8Z16TSOY3ZvNxLm3O/RyUFUE9g+N3bqSvi6iLHHGDCTwW1VMMsJgvPXE4b5SrFTz1lEGn0WaLzQ7XAJHlXMsIRfTOCAOfeTt0fzd0kSeoTuXUJpEGJgaqkm2z9iwjWXo0LG1bC1cSknwZxVELzjkk0ylJUjwoVrrAzogNAjv55XpqHAMQ/Eq4DSSsjG6ZVUQDQA50Cq+nbPYkjTp6SZrQ+JUPb/yLzW1gYty5aJYopEfhRfblylqew/QT77xk5ExzTtBKeX1G40lKLVK7TFv6er1PUe+rzS44TBwb7
 I5JDY1Qr
 +FDVzpteXI7OAFDGvuPF0azTILSUsW9ppD9H9ae/zsEjQyZcP0v+RF8Kb0KM7dxodezSsANc/Y9gyQqp/eMGKcg93mi82qRTMcxVBSk4trEUIsoTFPJ3jWcFnank7vpKnzPIG9NFQ9prGGne28EOBVCPc/wyeSp58S4nQ7AKHXKJLwxJ+2WEsvea5nsdFexHhESbFbgltanSrX6f7wH0EdlQ4neM7OYE5Fh0iZ+hNEgiFcjd/1aSKusxXyzxC4mhidCl49hZ5HSgevUYruSW7EpdSi78vCs//SkaxttX1AIJl8ckFO2l/kXHblLShCWLODvJzt4GTxlxlrVlkD35wcQBazKu7xN51o4HOh8I54fvdqus+sApYpp3uB3TyhxKcM4/Ftno9Gw1a5a/A5MJ0/1qTMUlgWqrwGJO2/5cGybm/z2H+frF0xE/Kdhd3oKeqQKx0odhmSx7olYvPR+0GunJXCn29Yb70/5iRBgItRrxzQr3NwTjUGVPPJP2R/khmXdZc9Dl4RGbqC5UjDF7DDSmYiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  5 Dec 2025 17:50:37 +0000
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
> how VMA flags are declared, utilising an enum of VMA bit values and
> ifdef-fery VM_xxx flag declarations via macro.
> 
> As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
> the newly introduced VMA bit numbers.
> 
> However, use of this macro results in apparently unfortunate macro
> expansion and resulted in a performance degradation.This appears to be due
> to the (__force int), which is required for the sparse typechecking to
> work.

Does sparse complain if you just add 0? As in:
#define INIT_VM_FLAG(name) BIT(VMA_ ## name ## _BIT + 0u)

That should change the type without affecting what BIT() expands to.

	David

> 
> Avoid macro expansion issues by simply using 1UL << bitnum.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202512041634.150c7e4f-lkp@intel.com
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
> 
> Andrew - note I've referenced the linux-next commit number above, could you
> replace with the upstream commit hash once your PR is taken? Thanks!
> 
>  include/linux/mm.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a2f38fb68840..c4438b30c140 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -395,7 +395,8 @@ enum {
>  #undef DECLARE_VMA_BIT
>  #undef DECLARE_VMA_BIT_ALIAS
> 
> -#define INIT_VM_FLAG(name) BIT((__force int) VMA_ ## name ## _BIT)
> +#define INIT_VM_FLAG(name) (1UL << (__force int)(VMA_ ## name ## _BIT))
> +
>  #define VM_READ		INIT_VM_FLAG(READ)
>  #define VM_WRITE	INIT_VM_FLAG(WRITE)
>  #define VM_EXEC		INIT_VM_FLAG(EXEC)
> --
> 2.52.0
> 


