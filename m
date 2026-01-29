Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E5B2D73E83
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 18:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8FA46B0088; Thu, 29 Jan 2026 13:55:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D9C6B0089; Thu, 29 Jan 2026 13:55:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49436B008A; Thu, 29 Jan 2026 13:55:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FF326B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:55:24 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4807556FFA
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 18:55:24 +0000 (UTC)
X-FDA: 84385904568.14.765C34F
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6DE4C160004
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 18:55:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ep3PjCt6;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769712922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9dbFuRTaIYbJLep7CcjvLi/9Eze7IQbnKopNMEF6Mkc=;
	b=LZyvLSlzrj/6+VaxA+LfVTZYaTlc8f/m7Ne+t3uSC1+yHOz/XAE/f2uiDKH1I/JOd0ti6q
	m29fyGjd1LQS5eWYEK9QjvBrfUAliCgR1OmDhmlOCUjnAItIoK6C16CN9k/3sZgUu8A4TD
	0X3abJh2B5DHoqMZekgB3unhnEXPUtQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ep3PjCt6;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769712922; a=rsa-sha256;
	cv=none;
	b=ZrM5lmNDhdrkHl5gI7SiFdYKPO6rmD9gLVwhzEN2swyvm73InE81Y30y+a6s34pelDxjSx
	Ov1Cp1u25U5uQ9eBN0T3YYN5Twlzy8ZiBraxIfQptR9c4iFDBHWPdpDmu1dHorNRioklpQ
	DjVQdHNBM+GxWZf9bgEmXcXO7UD6jCw=
Date: Thu, 29 Jan 2026 10:55:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769712920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9dbFuRTaIYbJLep7CcjvLi/9Eze7IQbnKopNMEF6Mkc=;
	b=ep3PjCt6tHF0G2BvZiSi9+KqefVTxDYuLYGFClkmmcCPMAWX1fwDB2xgdE/CsCIM/QeSaF
	i0c5+0vxFYFdcETp13cZbicrbzpGENLnoEXgrA3ePMfvb2LNwWpNiqAxRZFSmUonPFLO+o
	mCa2ELM+utaM7jdEwRZVzquQIOhbbx4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>, 
	Song Liu <songliubraving@fb.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Usama Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: khugepaged: fix NR_FILE_PAGES accounting in
 collapse_file()
Message-ID: <aXusxKTW5Y6-0qKO@linux.dev>
References: <20260129184054.910897-1-shakeel.butt@linux.dev>
 <20260129105015.0ed043764a4ad220334b7ae1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129105015.0ed043764a4ad220334b7ae1@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6DE4C160004
X-Stat-Signature: dmegiq48dixfh3ceyru87qkbxm8zip8y
X-Rspam-User: 
X-HE-Tag: 1769712922-318914
X-HE-Meta: U2FsdGVkX1/NRfLz4eTb4WOILcqOBvsZqk2Cr+sAVB9eeJPGX2J4IeukvLIXThL9wwEOnEwcz8tI+EWRvZevd0c+piyKaAIO62WI/Y+dZnA0hCSO/4V7NOUbXT9hIL/pNYE1CTWJdJW85CSWmKGWDYXY+HKdkDAgkULOncxjwtIBCr/ygoNs6CWGk6edcmDBQJXEUSPxW5n/qCSlWe0YJ0hTY4XASOhVG9r3m/N8gLzGwhxNzB7AZ3MSoXqimcdM/ercUCwR9GnndqlilrVVodVY99rwkaziqM0Q6WGKjOty/sCe/h8kLZtyw3ISWfRey835KrjWVYeg7oNQzSnS+qlLnthpZy6wAERKpqRtLvUQE7qD2+nfOS1M0YrWHm0APCEOTH5PZQ64Uqbo2KHcUUW6GaB53wPEK2TEWCsyj/sZxWOcvQ7SDMo7dZOol9/lEs1z0B2c5pwrj2DgR5QcrPCtbc+tmRPSYD3o4cqyiAVPB+ikK5crZ6UdmNlAni6CnFavD0gnQlOVnwr5BAiY0dDU67e8Yepc9Ag4GZjaY7D1M29TQUJjIPqnGtnyvhnZdA6qWRBts0FBE7Hrh5XZaHliIoNor/gTtAFK2GWcRUowBPNY+zx7fCiyQQJ6n8PHKsNSs09iEHJeUtdtzzH9LYkOvPKqrGbzAWqn7vtTg1XPSMrSUZC7a/AYNi5z4FRwJMT5tmivVweG0Y+Q//KV9dZ71VVxRGRAOXWto5R3AGoPq8YCxWniJhBv43XQvvpE7YnTYzoNT1VvQNV6nMlZCNCca0Su2v/wMFu5LmTd5nZjaJy9Z6lsdYwfcIDCxbPPgIAuliJUlGfMJD1vBAnFXfoSpzd9ZxBHShSmVkGLGSKE2Fr5R5WFoOFN8I6MfIVeM7EUBoofAj7cfUw7UcdaYEvZ10wkDcAPAcfxnoufy+ikkUJTmhP3RqpVOj78KcuVVuc+VM3XAhWT5vC5OSa
 EHkMOSAT
 Nd/LUskjZ+GSf4FGdKhhZdyCsRKThPpR7zMM/2tst1uhDqmi9nXc6S80uefyTzogLdcDsXvgfTQ2ATj0YUWFVCOcvthSRKAcW2CY/v/M5W6l9baWwWWh+sVh28b8S1bgqGkG6AIXMOXYuo95AadAtgCRRCpqX6yQZqyZVlikhkJ+tbNzmMgfP0lV7GyINFT0FbSM9nYVeBa3fji+3/C/X/MFoFLxSLN5AHcIkYES5ZNlqYi/ley0kOaDbqwC4V0EutaiT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 10:50:15AM -0800, Andrew Morton wrote:
> On Thu, 29 Jan 2026 10:40:54 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > In META's fleet, we are seeing high level cgroups with zero file memcg
> > stat but their descendants have non-zero file stat. This should not be
> > possible. On further inspection by looking at kernel data structures
> > though drgn, it was revealed that the high level cgroups have negative
> > file stat which was aggregated from their children.
> > 
> > Another interesting point was that this specific issue start happening
> > more often as we started deploying thp-always more widely which
> > indicates some correlation between file memory and THPs and indeed it
> > was found that file memcg stat accounting is buggy in the collapse code
> > path from the start.
> 
> So this has no known runtime effect apart from incorrect accounting?

Yes just an accounting bug.

> 
> > Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> 
> Should we cc:stable?

I think so.

