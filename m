Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33198CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 11:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 788008E001C; Wed,  8 Oct 2025 07:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730F38E0005; Wed,  8 Oct 2025 07:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620758E001C; Wed,  8 Oct 2025 07:16:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2948E0005
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 07:16:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DEA0F59382
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:16:18 +0000 (UTC)
X-FDA: 83974693236.22.16211DC
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id E3470C000D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:16:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="cM0bR/LG";
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759922177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dc9XtLsPFdI/Wt+LLxGyoNAYDuYLzy8A6Ptn57F6niw=;
	b=v/28qZeoxTA+tS0zrzuxFuvHHp3JVWMpYJp8E5ayVTRoNhquTTZT3TiG6ICcLqjDgIjBcU
	aZnryNdidSAXSCJvEQpNmwU8pRW+Rhu30t4zFg41+zR0RSTkueDW9qKkELpe0c8wMAFhkT
	No7QE2Vow75BuQ/9+qTJ0nal12dw1no=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759922177; a=rsa-sha256;
	cv=none;
	b=PfL4bj2jjyqEOGbMLpzwGiV0ObLUfga6DGhM3SpVMlsoLzhQTmINvy0feqmjiL6w35pXD4
	EfoaXHFGtokST55nD/d8WQz6dbINnIFo8N0y7FB9khRGb02ggaZh3GVph9dBT8iQZ2puBN
	nUVy3WiEi0gYZr+pOPSN0WuWurOP2L8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="cM0bR/LG";
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6399328ff1fso6073244a12.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 04:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759922175; x=1760526975; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dc9XtLsPFdI/Wt+LLxGyoNAYDuYLzy8A6Ptn57F6niw=;
        b=cM0bR/LGlwgXj+JIWoq5wryipKvX/p0jhuyr451sIwEfDInXzSwrWb8GoPHwam5fYp
         twJkemUcu2Z64JLMP3lD0lz2bWgAay1m8oXZkSkeiPu4hcZNByx/9bslt1eD1Yh777D1
         jDmpzpjhnQ9Re0Zj44CfXRqfVZo97owpcDYWgsaclkTyGXiL3mLzWfQQ1miP2anbTqv0
         0QlHbG2PZ1OjM++0BMWZHnJtIMUNEPSxJ33jWe+OfGHzRkBj2oa48jBPljgKwLfUbdml
         cW7anGtHB8zpvac3GfdTpj8GLqoLiaf1pGqP17NM/HPT/n0G3V36aDXVUc/NuCORvaC5
         1H9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759922175; x=1760526975;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dc9XtLsPFdI/Wt+LLxGyoNAYDuYLzy8A6Ptn57F6niw=;
        b=jiZXlFwvvyeXydk4OVfMYwF/IYuBtP+O4W9lj5PzZ2vJy9CWpgmqcbah75+xAYBc6s
         PEwcA8qgjGeQpPnJIfpjXwLlhZR8UcfRQsWu41h8FgCzIsKITGtY+uy98TsPln1enU/a
         Ot03dMdEbNN7HCmwEiXklb6Nn2pM7qskuJsoBK5RRLNwnXNn2PGmoE2IdcxX9ATQ6NN+
         1YkP/i5eRwiICCX+KdMM3pMNT+uZTo5gvZV3DBgSs9Hxy+4xVEbnDhtxG2OBPui3U4nl
         sECThUDjt84f93Vo5Q1qyISk7SW1AStGx0Sgdk0M8U2J6ek/R+dnPFvNmyd1SRuJZyAj
         KjUg==
X-Forwarded-Encrypted: i=1; AJvYcCVtUqdPbyXW9Vp5tByq/DodrFDPMd+LUgww+O2cAt2D6QHD1xAoa923iStM7NNkW6OIj95Yf3Od9w==@kvack.org
X-Gm-Message-State: AOJu0Yz1jl9V2qD29Vf3LI3hB0k7ZjnfKIjiib/FT+jKAhCSTPHXEff1
	wH9g7kMXfGnBhr0i8k5EjQKmt2P9LDAyuCHhIZb3A2MSeJ0RZ2W6mnjcxlDR5FG83W8=
X-Gm-Gg: ASbGnctlh55wN5XH25mGHTfg7tfr3dnQaTIa35T3WT/jiKAi6hPFALij2o/UUkWCWaC
	cq3yQmHQRNO1tfxhaUhcFJUvqmd9Y/220Nx0fQ0swXt5ODgAJEQvCNA1Kzw+oAOfOFQTdocOo19
	AanhsnG3cWZDvLIeMXE7mBnWgQoNU2G7f9i3W/iOS2hQ7P4FwNaXn/VBf94ozxF7tIxDkB7rgVe
	Rgnqt3hHjj4AtnDDwcpxbL8TfiyoadtLHt9BM5RNSzPtORlsG+UaZkyjnYN2+jPyXzJSfJ+PHBv
	IxaP0vheFR7gzbDR3vuDicmnrYRpvzQBCeAtuRIExjSwwSInYHRRwBSAinLvcboAYrF39qKGZhM
	VD9ZSoUpoMUGjkwkQrZaUvtKdDWXsfcUcsQzuSzEuRfqTGeZCo3quXEofycxP
X-Google-Smtp-Source: AGHT+IFIPR1SNBYekGJNs/b5U7QCxzJYC1CT/ny9i0EHiqAb9h+Fvp2hJlupPLxIAbxIC2OP6nYaiw==
X-Received: by 2002:a05:6402:a149:b0:631:6713:3ac2 with SMTP id 4fb4d7f45d1cf-639d5c70af5mr2021769a12.38.1759922175200;
        Wed, 08 Oct 2025 04:16:15 -0700 (PDT)
Received: from localhost (109-81-95-234.rct.o2.cz. [109.81.95.234])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-6378811f14bsm14561504a12.45.2025.10.08.04.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 04:16:14 -0700 (PDT)
Date: Wed, 8 Oct 2025 13:16:14 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, iamjoonsoo.kim@lge.com,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/compaction: fix the range to
 pageblock_pfn_to_page()
Message-ID: <aOZH_geGfMd0KNxR@tiehlicka>
References: <20251002033140.24462-1-richard.weiyang@gmail.com>
 <20251002033140.24462-3-richard.weiyang@gmail.com>
 <3ec7d5c9-27c4-4395-b859-8931eed72272@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ec7d5c9-27c4-4395-b859-8931eed72272@redhat.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: dwhphgfwayr8zpbn15f39iq913wc4u68
X-Rspam-User: 
X-Rspamd-Queue-Id: E3470C000D
X-HE-Tag: 1759922176-289458
X-HE-Meta: U2FsdGVkX19x86m+/eZ47nM21Ew9bblzWNUDFivlt99Qp6YL8y7fDsKzC5FLBY+WIIfqGJI8z/vtWPL3FHLMvEgSBjCPY1z4rPwXBe2ZWoN8CglviM1pM/LLyJUaehZapRcHNx3gGjTkqNf5D8+zd5F9DDxHSB6Xs8vICXmEC8Gjy8e4jQVjBrCPzFRbSkDpLmhsNx2EHVGYVy1Wue2GvVIQstaYbfOPbXKCJQnyRibIZtWQBYJv0ojdVxuuzOMYwnDN0X4sOEFE1G3n1CflON9EbQQ8oMH0yAMvcHB9T5IhOnn5UocfIREsgHi5QkuqhzYRmfe9jidzlDTnRLVUKDcoU9ol/1H2meA5icSMLRtp3hgEk0kACx97UYMuL8+bokosaS1SjOMX2SVH7VAFMbGp/Jyswp/XyBIgm9G+L0d5sLEA2e2gp/9fZE0xbK/9vC2pH4mKPtx/7uXX0I1xwU05p91OeQnUkQO7EC8SHIuqXGVZXOBbjYcG7iU/CR9R28zH4gDwH/f/rM2NLBLe87wlJsuhv+nhU9ET+71TUo6v+RGSOBUVKBN6D16lQm7u4tBOy8J9CcAGM2uqBoLm0J5GsokLRp36RQerbe5shYQVL9KOpv9Pm7TVJ5krdERgxr5lXWt6xeT4KuQMHlMhP/g2UK0s0pvdRuv4WGAV0p/CdGi+HtZICvzPbgnHkvYSTj93YcRgYFUuvEEO4L6HzrwVLx5sukqUHm/bzOCFB8t6giIiQH9nB9Kmq6MWKy++LYUU0C6Utw1U7CRNDMyA6Or3VOdHfmzqF+wZa8RG2Tg3FF4JnG/tD23HV1ennp85i/tHvPYDE1SRiUOVl/fBMn1fzuTZL76GddnIEMbZYkx3jD3ELFWzSsagKk4iJBEQ+4FoyzP8ExHcDS1fBwr8S4ZBWhuax34WbGVL6cwiSgOHtvkg1qod+pCZClk676Lx1vyvpzE+eWb+ElJj6f7
 rm6WhWaZ
 P6F5DmV/XpuwyttmVj2PevztmX94a6Nd0sql1G6Jw4IWWNLmIcWRIRaKtCjHi7fGoncCK8NrVLxGKefRNAclJpRPvxC6P4Is5XvF61dIWQMmZ0VMrgM280CBazpRdNsv7K0+PSzwwSN9jK175FsyJjPL1w4YCcsvBLhuDdC6sHUrGyoUFjpVKoS17sa9zXw2s7FAopBASM2h+/ju/y+FtJ5ixNQFFy9Bu1Ip1nSp6jGNf2Jtv31CoUDqcoYZ+DVeVlvjWf4bB883pMPsHqimIO11s2iwciYAy4zB3xpsAg8ZMZW/hUwR75qnWPVIbzVstVSlkQmTMEpSNWkEYBgYE4UKoYEty1ABVcoTIiei4ePUhKFJ1oy9riMF1fs0iMJmXZ0NYJq/UfbF498B9ffO213diJTrGapZPlupzMPLcqf2y7otyB7sRHxS2MA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 08-10-25 12:17:29, David Hildenbrand wrote:
> On 02.10.25 05:31, Wei Yang wrote:
> > Current code may skip some part of the range to
> > pageblock_pfn_to_page() to check whether the range is in the same zone.
> > 
> > Function pageblock_pfn_to_page() is first introduced by commit 7d49d8868336
> > ("mm, compaction: reduce zone checking frequency in the migration scanner"),
> > in which it checks and isolates on the same range [pfn, block_end_pfn].
> > 
> > While after commit e1409c325fdc ("mm/compaction: pass only pageblock
> > aligned range to pageblock_pfn_to_page"), we operate on two different
> > ranges for check and isolation.
> > 
> >    * [block_start_pfn, block_end_pfn] to check it is in the same zone
> >    * [pfn, block_end_pfn] to do isolation
> > 
> > It miss some range to check when start_pfn and zone->zone_start_pfn is
> > in the same pageblock but (start_pfn < zone->zone_start_pfn). The range
> > before zone_start_pfn is missed.
> > 
> >           start_pfn     zone_start_pfn
> >      +----+-------------+-------------------+
> >      block_start_pfn                        block_end_pfn
> > 
> > This leads to the range check is passed, but it will isolate a range in
> > two different zones.
> 
> Can that actually happen? I recall that a zone always spans full pageblocks.

My recollection as well and we should rather focus on enforcing that to
be true than complicating already quite a complicated code.
-- 
Michal Hocko
SUSE Labs

