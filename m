Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38F0AD374A8
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 21:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25CB86B00AA; Fri,  5 Dec 2025 16:34:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 234B76B00AB; Fri,  5 Dec 2025 16:34:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14A766B00AD; Fri,  5 Dec 2025 16:34:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0208B6B00AA
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:34:55 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A401C13A85F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:34:55 +0000 (UTC)
X-FDA: 84186722550.11.C0398CD
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id AB90A1C0013
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:34:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PYMbnQFD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764970493; a=rsa-sha256;
	cv=none;
	b=SJbqArmeix4d+0AIj6gQfWg7t/l3xVxK1zd4xvr1b2XVn7j+mW5eizCBXMa1O1LH00tZ5X
	tg+9vnGwKBnIJOKorVX+v0K73Nj0+qbOPjbzB9mH00jN0OcNtLPvkdzfYWBupjYGyjxIaD
	TVGivbUgIc8NK0ED82v+d39/qJzPfbU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PYMbnQFD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764970493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MjLjsRbRwmoA+FQ3Zj6LdJhYetQGPRvx5e8W29o2gSg=;
	b=CXL8npRrgPp3l60/42FE0Snxja3NBustYT1gcwvCUtlOmX3bSDjQUeAw/qXqbLG7ZLM/Pb
	Y0z9255oqveM91j/squJdw/WxrtYAU9hoUo5cQsi3QbE85l0KJr8LkaCfGyveIt+XcIXdN
	LohCaNHiP5qux+2z4pSqMcUtQe4kVdw=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso32191095e9.3
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 13:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764970492; x=1765575292; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MjLjsRbRwmoA+FQ3Zj6LdJhYetQGPRvx5e8W29o2gSg=;
        b=PYMbnQFDJArHUhZNQZaoSpg+dhfGrmAX2ysIg/NWvfdTMD7T7LyHPH9sQ8QHjEYeJL
         tGfqM8yz0Y7xY6sbqhuy3bIaXehd9Lz3u3fKsFwRE4PBaiOJ7jLptySxh8Vc9hVdh1j5
         ZyjpxvrzBPTVXQ1ARFxikZhzqONIL84FnBxRM1QcWGvoryYpUIC93cE3qstvRKHoFNSq
         ESt7H1m848VHi+c/tcE7T4IQWcierNnFEDo41OWjm0W5DC5MvTjwn79Rk8lsvlk3/RWj
         gNyghiPFGlFRBzeJ5p2bOMjPaPls/S+xAUc6nTqXQ45M9pX1QKF2aqITgYei0ojRFi8q
         YxZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764970492; x=1765575292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MjLjsRbRwmoA+FQ3Zj6LdJhYetQGPRvx5e8W29o2gSg=;
        b=mabnUtnzSPLARDaoiU3xtDDTnVjqmcwpLcIVQWdl1LEPdfYLfsBsRboEbFEtggjTGq
         UtVwjs8djCNIwZqQ69lKIVo+aBtJ6C3JpqERQl13tztCJ0LZscH6AYa+dtDfiQ4Iae8S
         QIt7k8gOta9zwhuV4fylW4zteLDI/XUO1BumsL1lF1hcgNhHa6gzrJPE8PaGDzf516fO
         NCy5X1ZeR/hEOF1ZUNjNPEI65XHPK1QuoycJ00ehyIHR0vpLSKArUMfiuWbTGF5aiP+S
         QHFFXRQfsC7IXK6Iljtj1EVHTM+utoIDsyQmMZDlvyPXPJGrnkVFU3rTNNHUcJo8jPCe
         MBKw==
X-Forwarded-Encrypted: i=1; AJvYcCX+FF8zOjW1nLHEIDgSUF5C9R5l2HWly/QfRDeB7bZCNrrx1L6LPie/Rqy3GW0xeQKuUPTYjMWeTw==@kvack.org
X-Gm-Message-State: AOJu0YwkBUhsJmh8n9hgXaHgUdgpVxsCbhLTS5DyElI4PhWUzhzDT67h
	cb7Qu/32tJEg8wEtOqr55z7M/SHvNKB9Nb2+3/Q4G946x1kDmh68zKWu
X-Gm-Gg: ASbGncvB1N9EmF8foKFpP5DbXU9mZ9W4Lqv6coPOxrwxPPHQOJF804wAMCoE9gMaCUL
	cur6/jkO/H+L5FapBeIfwNoDUbbUaielnMI9w/LGAfFWMOly+FWivJRw37GyaD5EsaY7Lf/2IKl
	s+Hjjdc6RE5Ak4G/66kxUrvXc9/7aDmHz5grAQehlu1Pw17GbMpVpOXX+dTNPFq0pHV6+6fj0H3
	MnXUPqgl8WFn8P+Ac7AS+DhKR6voedXvLQG9sAOqPSrwhxpCdszgYSYhuXhUeRCP5FKqEzLC/Gy
	NJ0B/f2ZJYRF9w0RESYzzJPi9KuIJ2aSxk+tHIoPc89QG/QjVT57hYvPNMvEvqGiDi0+msQerjL
	4O+5BfUUfJiouPrdavKdxwMQySFliMVF8dyaP08Z4bB/3ZyqXNdI/ODl4PtEylLKBwAkdeU4yVf
	VjAvki62sODZaN++Qux6J6cxEuuJZLPzBJEMjllde4PbJl8h9RvXrswt40SBuKjKo=
X-Google-Smtp-Source: AGHT+IHz5isvd2fROT9WV3DcH6mXEwl1tvt4z/k5O8VzjcHx14gWDTICAbNWJFuVd44ACykMs1s8Tw==
X-Received: by 2002:a05:6000:220f:b0:42b:3d9d:c5f8 with SMTP id ffacd0b85a97d-42f89f17033mr572101f8f.6.1764970491933;
        Fri, 05 Dec 2025 13:34:51 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d222478sm10630707f8f.20.2025.12.05.13.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 13:34:51 -0800 (PST)
Date: Fri, 5 Dec 2025 21:34:49 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <20251205213449.12bf4819@pumpkin>
In-Reply-To: <4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
	<20251205184342.2cfcc73e@pumpkin>
	<4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: es971xrerca1x8qgxt5b164dphbt54mh
X-Rspam-User: 
X-Rspamd-Queue-Id: AB90A1C0013
X-Rspamd-Server: rspam01
X-HE-Tag: 1764970493-670288
X-HE-Meta: U2FsdGVkX18gIHlXUwlbCJxDifO34Jnkn7Rz0sWEdD8o792kYMOb7us0JpyhQgRBmXA3djOvp0K6cW8uFU7lpDz4JDDm6CzRn2OGXyK8UIx+KKIZqvGCfJzp01foJZwQdPXXdLpKUqUoEW3/CCKt4vyhzhIgQy1QheaUp9AVFmqMYnlOkQtmcXukZPwPbeigfDK6uyz2nm7DWqnddW9rwhfAaowRq6eoniIgfbUYHEhxaDTOLENXxPIjj6eH2F8rqJE9v5Bb5gfjcmUg1lmLVgpsZoTvUzMqiHlnHbWhWQMcrEeOlopxSuK1HcElaHUqWbkhAdk6liJe48HIr0ULNuEdgUDLafcBJGtAWjaSbuILVPJBLR6kJCg8FfBgirNE898WS4dbGfcCWZx8Z+UBxvk4LD1O2++hVGyg1z1QUh5nDfQlLP0fZBv4wqCoFoG4OeCJfDAvEQgcpuJK4Flng0jfs7llpLQAqW1g3HuMKlbv9OBRJWduciMxd5r2jB/HfNXUFJs8fUfPkA7eTIkLacRxCyGUyDJoF0B1eInjCY4qekJ9wMim1V87O6z0RTs1585MBuqKAn3QRqnbMBlhHZLl+QB/7tshEdwIuBdCDJ75g+sdXgYYls4ebOF4c86fGfpSQvD4PfPk8x/UAHVOgkLXIHiUSYy3WZPWm+e8bcE023rdLSN9zY28ItwnVF7m6+/zyn81bTzYQ2Wb+HAdUnuUhtDukpp+a9bVZx2Oz9fA9F0CbT+P4YRV3TgbUtCxvXbicrB2OPNthjYGqBgoXcMTVnm7+hlGp0K95uu94b1xbAdcRbxRn/7zLJNkA279bxtu1dv3rJ/OinLdCb/GU04vuJwX6JhyEIlSWODv7Fou9GKSvNJ5HgqrhordVcPyvjmv7WUopatzungl8mcLbsYv8j0OyRktn846dKZepZnbjFPtSBqfGh5MAnBvrHK09B2rwAiLOSoWiQ95Z52
 WOsqR/n0
 TKCv8s8gAG0QhpkJ+TM5eIceqzSRP0tptSskkvKtiOLotPVXoziRSK3c3hXjffiLDZQPe9VDbYb+BK4HAgNsJqe2bBhzEBq/tAsxWqmM5jok7/MsS4eQL4SdalOkGQ1Pcg11u4XYQtssWkrpfspYBecsJ1S0C8QY84RzdxEBvfq2Wvqhx/h5WKF6bDqP9eVOkeNIhXpGTHc7wKMzAbSZr9ZxdK6fuHVmMo0Hm3Y71OSGYR7htc4s7o2GjEKvLCeTD4235xIAHLN6C6KkkUM5jYbbmEii1tPkXDhRwGXD/K7DpmblaY2h2/Bsh0aFvhXq3ggFl9NBQaA2j+2HFIe99VpFm7iHfPcleNOkUzOT6y60Ii5oEbBni7c1d2/jEzBa94bxTlsLM8ULjOM2yc1+4Pby72hmhCWNHH9YXWu2sVWKqv7klrFJ1WtJ5zsRkMuozU8jz8mqJtL9hf2o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Dec 2025 19:18:56 +0000
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Fri, Dec 05, 2025 at 06:43:42PM +0000, David Laight wrote:
> > On Fri,  5 Dec 2025 17:50:37 +0000
> > Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> >  
> > > Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
> > > how VMA flags are declared, utilising an enum of VMA bit values and
> > > ifdef-fery VM_xxx flag declarations via macro.
> > >
> > > As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
> > > the newly introduced VMA bit numbers.
> > >
> > > However, use of this macro results in apparently unfortunate macro
> > > expansion and resulted in a performance degradation.This appears to be due
> > > to the (__force int), which is required for the sparse typechecking to
> > > work.  
> >
> > Does sparse complain if you just add 0? As in:
> > #define INIT_VM_FLAG(name) BIT(VMA_ ## name ## _BIT + 0u)
> >
> > That should change the type without affecting what BIT() expands to.  
> 
> Thanks, checked that and unfortunately that doesn't satisfy sparse :)
> 
> I don't think it's too crazy to use 1UL << here, just very frustrating (TM)
> that this is an issue.

I might use some of my copious spare time (ha) to see why BIT() fails.
I bet it is just too complex for its own good.
Personally I'm fine with both explicit (1ul << n) and hex constants.
The latter are definitely most useful if you ever look at hexdumps.

At the moment I'm trying to fix bitfield.h so you don't get compile errors
on lines that are 18KB long.

Found a new version in linux-next - has its own set of new bugs as well
as more of the old ones.

	David

> 
> <insert rant about C macros here>
> 
> Cheers, Lorenzo


