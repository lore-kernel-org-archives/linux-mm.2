Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD07EC1128
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 20:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A82306B0005; Mon, 23 Feb 2026 15:07:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F9F6B0089; Mon, 23 Feb 2026 15:07:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93B966B008A; Mon, 23 Feb 2026 15:07:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1C46B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:07:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 456B81C25F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:07:55 +0000 (UTC)
X-FDA: 84476807310.16.25FAC00
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3FEFB1A000D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:07:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cGWeE8PX;
	spf=pass (imf19.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771877273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5i5wZQPBMzNDRUemsp8FkV4MRz9ExTj3IRN14tL/eKg=;
	b=e/qTB2a3oaOn4JK5+812lDK/BTOwe31KXZ7gRzyfmEBoJV23kdV9GlVDNKwKvRpTCSumAK
	+WolRNKSVx+X/rdAEP/1bpiHRcRzVjQk6zUNQlTDAp0/+J+WjUPSJd3sCUJWLAYiNFwHBn
	1VbUzdx124ZAcLeyCGckBKqGx315tsA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cGWeE8PX;
	spf=pass (imf19.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771877273; a=rsa-sha256;
	cv=none;
	b=3xL/yykOKaGWmEXl0eEr0ei3OS1flyJMdfZxKNwsAvoFNoejcCs/rpJrSnvq1YV9zWHs1A
	nlFvPjY+mkwhc9IB5PH/z1P3m/Q7YfM/X7VwOdVY4TRzfhnTppc5iYgO4UAHflu23qy69Z
	8SkJijT2UNG5IW9AvuG3qVD7RclqD24=
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-38706f96202so29832431fa.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771877271; x=1772482071; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5i5wZQPBMzNDRUemsp8FkV4MRz9ExTj3IRN14tL/eKg=;
        b=cGWeE8PXKG1sYN6LhkPv0nQ1lAPGhcZbnz75DBw8TdLcQ97S2DB2/ACi6EfbabciX3
         uzYH7opk6spohvBVTqZW+EEpURNSY2tIfv+qbl6iQUWyjRX7S+d8SgBSmYTso1Gs2fFs
         EuFRquoRu7a3Lw+VUgE1jIZw0sxH7ZWFiVPlvHBnFDGbqtetGda44ZITWlRXiHwNQVjv
         2rSOWDHv9lO8yDVwL7RFUKCOyTVU4uvBmnZIXKJ9U1wb4BpRjtPx8Z4DNgh84MK+kpVH
         xqsBRYH19X2zzNQvtgXKkJWsYoy61NZgQdCNAuL6cLWmBha4SBclGWhxpv6sMjGzSthU
         ngTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771877271; x=1772482071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5i5wZQPBMzNDRUemsp8FkV4MRz9ExTj3IRN14tL/eKg=;
        b=svFI5c7QT/tI4P96VEQosGgC8h+Lkw624pb51ecH/hSQGB88wcibfX6ifwI5S1pAWB
         VrmiA5oRHIenGrcvIzzf+UYCp88BfXZKrhI2lxIxRX3sONMPLc4a+jht4M5H+UVVBMoX
         V3rti45EXGh4iyx3TAGofdll7/Vb05KUY+M5vkQrD6PnPIj6iySV7OzDG4PDeqe6odlr
         xYcO8rYbrrt214/Vvp3qA0ToXkGStKn1egb0Y8t6cPqM5rGj+S/vw5E39dSmzl1GDojk
         e7lMBvkj7iE2MIAsnpoUl0kMRdv5qjRKszvzAw1RpFzcJkhAsHnYLZdDaEBqS3FESqVh
         mmpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXtgbI7g5HQxIysCIHtQDSwiRCLdKlKmilbY3kBTfGvrC53iyrJE8hcIafv50SB4RS+0DwX5rFpg==@kvack.org
X-Gm-Message-State: AOJu0Ywt7IeCU4iaTbZluQBGGnPeQ81z0foiGsFXGlxEMQe3SncAoF6A
	oY92SYSCp9G/dDezM4RcNEmIhEr56FhhqHlEUvOkAr/92UBB7fDL1ugx
X-Gm-Gg: ATEYQzzdiXAw3fa35+WvN+U1HUiSZoXkMEhrF5Sp6aLGUe/erU0XIarD72M8fVJP6hL
	SdeAxQoMXJCAOK/UkPl6Xyktx3bf0BbGg5C+Yw9Tesdk9WpGk51Lq9cnAoDhjdziWtG0HZRyLyi
	cO2ivicnG+CahI966LsUX4SZ+cyvUj7Jw0xdJW11Lw2VDZVWFPMQOK+m3abdsV2Y/d3R8QRajA1
	PhLiqq3ae99mF8sAb7K/Wzy4iDAlQ/ZhlGKpxgmRlJKeDeIVSLlwryOk6PmV3p1i6/w6SqPnWOW
	quOMFexuWH0pYkE8Pj7ejxV4RVjQ2htf2C4QQjq9Q9B59frgiCGgDj6DOh4A/fcEzHAgtDfanNs
	6LXZl1pDMWDHFADHYokmEZay8tx3o0kpv7H6rLDtxWYcT2vLQzIzXJiD4um7DV3U=
X-Received: by 2002:a05:651c:220a:b0:386:fd3e:bfe8 with SMTP id 38308e7fff4ca-389a5c9298emr25983911fa.7.1771877270631;
        Mon, 23 Feb 2026 12:07:50 -0800 (PST)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-389a7a201fbsm17562561fa.22.2026.02.23.12.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 12:07:50 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 23 Feb 2026 21:07:48 +0100
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZyzlNb8ayd9bgsA@pc636>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3FEFB1A000D
X-Stat-Signature: ox41e9s1x5xg86ros5td8he9ar83quba
X-HE-Tag: 1771877273-355998
X-HE-Meta: U2FsdGVkX18X/kcQylCWMHi6ntMmxa9mnrFCy6v7y8iRB036B/sne/2EiheLoi9dnUQJQcNUxh69hlqXXoiy+aAecPD/fbkZdZVD5SPbxyT6qR5RjEz2E4NGpylyGASrJm0zygOHCaryl46TFOmtA4la18nw6osqc7nUfmNQOWJMfWy9KvhyUPINDVa1ZuZYeKkhNywl/JW8OmgnU6d8WK1mH35gQh57kZMvVx9shLQIkQq6ilk/yE9i6GQvXG0buTY+/29UIYCy1IdK8CITmBdeeIUYkzQJ66fkTz324GKGTP7wQFu4MpjVl9ipjmxDl18gkk8fJ5bRPjsQ5Ej4n8JR9cehLlef6gZNaooCDLd41cBx5B3H+ROQ2imDgV1+LiS7k6UtoJRM7g5SVlAVrGEKyS27DV2TDRxnUpWH6cBntcyxbpaHYj1E4JTSKjPOC8xhA7C5+fy7iqraTE3YpPuJSGoMIDr3XNAgm8fFZcTMWc3tL5LT6jAk2/hUcJ5tpBoWr5Es5OxPOT+bRG7mKCaZffW5aYlRx4Nahm51sGfxu7rtVEA9km7n1IfUkWjrWMoQs86rgSC+ujWbt8U72dg3u5eo3BgnMkiT5MMSAeWluvGQ6rq9a3+2N3ndCQ5XktOoFmyI26W8zx5FOvZXveCf/s3AgoHg/Lj1dkyj0IVBjGvDg1xs98dwlT8Wb/pZmfmbZV+/Kvci1foEFmLxdvuQfBJHdp2lyrwfmYj2HQGIY946XsBwjuLVUELFHmy84saIFRXt3w0ul4/QuiKpIiHDJWPllpU9qAdjzP8zAQ7cPBXQito5hUiL2WS7IJCTEx5epSHHGkiV7yLIsbpV2/kugxyXEBEIJ0cIAQpymnszYIpPA0WzaoN0l8u2klZqFZdCKn/T2FKQQFwrIxVUVhHCba/Ir/133NgL9iqzA1HvI3oUE/kjAi3ODy87Us+27qF0vuJn6aynOnbvCrz
 U/wPbLbx
 wCZhVZX6DExMXnb0wgQSukLj3TGh2rqwnxVbXTBe9SBSYYaVO2eyZxdOc/8uiA9ijmWwFfU86FrjVn0hLidKr+4bthSH0YyEqSrOGHZ9gwg+cjRcH5E6CLa8YRwjahzbmqundd+jUtvMoeX8NNHuO0Vu9KnsQvm6O9w/mdxYl4U6E+ni2YwDd1bIlb9T9c0efaPuHQPcKV6sDg/UT4xChzIr+qtf3Si6U40qkj8wdka2b6oZc/7il0OzjHAOmAzCztwsktMGbRhS6jKTsWD3MmURWCUwRh+MSvo5kMIqR6mD3ppWWwRYsvbN4Lp5Ugpg/e7ruY31a8NpWbWFOu5XZPGBR9+KfQVz5uO+1+Dab5U+m/K+G+dRfEgkrVJGcpxyimrXziB3FYf0So6GeOvXqquU0KFom8aRGv0YqTHoqAR6VFDi2HIVaLGu+aG8n1Vg96Mqftl2sdGh5wuV8aEjhYt+19KRiieGWmCXXefpNVHTRNk70aQNLB1k/o9T0lulBlIbsEJsybfk0HEnZgG3RTXZGmIdaFS/qk1N4+iDz7IVyGIB9xeUR1pM30ayciAWahqo5KmYg//sqn2zOb4TWhdsJ5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 08:25:38PM +0100, Mikulas Patocka wrote:
> 
> 
> On Mon, 23 Feb 2026, Vishal Moola (Oracle) wrote:
> 
> > On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> > > The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> > > flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> > > with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> > > flags.
> > > 
> > > There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> > > let's add this flag to GFP_VMALLOC_SUPPORTED.
> > 
> > My only skepticism about this comes from the line in the
> > vmalloc_node_range() doc: 
> > "and %__GFP_RETRY_MAYFAIL are not supported."
> > 
> > I myself don't know why that may be. Could you elaborate on if/why the
> > doc is wrong please?
> 
> This statement was added by Michal Hocko in the commit 
> b7d90e7a5ea8d64e668d5685925900d33d3884d5. Michal, could you explain why do 
> you think that __GFP_RETRY_MAYFAIL is not supported?
> 
> The VDO module needs to allocate large amounts of memory and it doesn't 
> want to trigger the OOM killer (which would kill some innocent task and 
> wouldn't solve the out of memory condition at all), so I think that 
> __GFP_RETRY_MAYFAIL is appropriate.
> 
I do not see any problems using this with vmalloc from the first glance.
KASAN path was hard-coded when it comes to GFP but it is not anymore.
 
--
Uladzislau Rezki

