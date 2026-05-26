Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1812CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F110A6B00CA; Tue, 26 May 2026 07:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2466B00CB; Tue, 26 May 2026 07:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7A26B00CE; Tue, 26 May 2026 07:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C874C6B00CA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:51:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CA1D161582
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:51:26 +0000 (UTC)
X-FDA: 84809405772.02.0E42BC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A90944000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:51:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LOI6QCiK;
	spf=pass (imf27.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779796284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zf3nA9b/f6KJ6opNUnUvkbE1AyejuVsXjSNIH4NC8L4=;
	b=zzELM4l8NgW6tYjxRQVlj9VE8muFgvXAff95e8KtSc8BmOUnNi3cBiiKJwVILle9tfQ/Qw
	sD1KogZJTnWVCCGYvSE04WCEVLSnPIv4tncULAZPS0JOYZTnpqv2PfpFSalDLy4jEGFEN/
	rMRQpwEq8UjbY89FqZttvQX2nQuO7Hk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LOI6QCiK;
	spf=pass (imf27.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779796284; a=rsa-sha256;
	cv=none;
	b=JUMhN8YQ08LaOBa9+umoqCGp0zPV1tsXMUDY4fmv4zJGeqCnAG+333C4Q4ln3vLjIB68Zw
	71kg+fNxb8WoqX2B6GEw4HJm2HdLcY7NyO2hMAM9KtXmunFksr3VkeeCP86N7Ky7G71sSW
	uyTA92VlZfhLzYika0Xa4WvrO0i3VwQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C1866008A;
	Tue, 26 May 2026 11:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CA31F00A3A;
	Tue, 26 May 2026 11:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779796283;
	bh=Zf3nA9b/f6KJ6opNUnUvkbE1AyejuVsXjSNIH4NC8L4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LOI6QCiKOPAi5/pvTmUe+J2ivE0RgADm3Y0EtHjTPaGbjdyK3F39dM8lmTJ0+htsT
	 bjs4R63fzZ/knOCYKNHUWjgzWUqO6vafbf8ADs2CxSybZph9TzGY8xjlpGTtI3dnwZ
	 1clkTKh04k7vKFdUCBnQbPNZ9RJRgO7RDo238EAsh+dVC2PgJvL2gSgr9GmbdV2Foo
	 ssdlGwIWt0kbNAWZAWhorUkkTo8t9AxFG1DSvTxr++RAFU3bGXc82Koykb6BBS8567
	 OVcH25v3KUnOT1RXQpbZi5cG8leYuqpDy3LcRsuiQve6wCa+3r1zsbxAFKUI/j9jgc
	 TWWRH2RJoLUZA==
Date: Tue, 26 May 2026 13:51:15 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Frank van der Linden <fvdl@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH] mm/cma: fix reserved page leak on activation failure
Message-ID: <ahWJMwG8xoQli_Q0@localhost.localdomain>
References: <20260522062658.4095405-1-songmuchun@bytedance.com>
 <20260526113005.3610737-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526113005.3610737-1-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A90944000D
X-Stat-Signature: q6tbztg5f68yzyzo7f5nmoynd5sr4dm5
X-HE-Tag: 1779796284-23831
X-HE-Meta: U2FsdGVkX18slvjwPFzfMJSEJdQGUcpnIFXTlnDZlonLzKqx3hQFSl+D+6+pBFXd0gX5CLH68C8a1Py1i/Q5u5ossuGjpjG03yiGfaBJxqVDXpn4WXsERCF7/ep/04YI7qQAw/4DHDzXwD89PA5Ht4hPn3mlnt51wpS9Ul9NgLqVh27n/yloCaXZHIF3OLPNdYRYSUORz10tPLh0DT3RYIdbG0OGonbkdpeUjZREY2Jl9GzWSjTO+ccJ98B2tlUvHg95VeGyNRDc7XsidRr7ly/eTahTeiQzu9d1W1FAWfLH2kwhyUvzdSckKyycTST7oMJKocj+J1pWD2L0+kAUWHmQNzceAJYQmw5C7iQMk/WdwQSgGOEzLREDwV7nSwa7PiCX8tZ3F0njG13FZJ/ni7BzypSxT5H7CBIC42TuYAFee9utHH64qPNg4rUGf1eG9Tj4hGWfE3zq5obgV1VY1SCcO9azeZw095BuawgLNwvniYuQ3Sjw2+iqkCCJZ34vEykYa+UwlvasZJQmsOHy7jhiVsK8xZrivk++ho+jiI+wAdQRGUq+EW7honPxrcaVIaZt2CClXEF7u6lLbNef/n53unqzBEDvcZ9w18wNDyRQh3Cae/B2ygsS01JR2l8pHDYKADk9QjMkrIazwuANobrZFVIidVXbAmTFXKyOLki+OWdq7DEFm6EwTmHjJkGE3kzWeL/ajqeeJySbjwWb6I6hc7CGAGBixO1x8o3/ac/YHkiWdUU/aKM1LI8BCTpnFiwYXpPZVwXPTITE966JFns8K5pKJd/MPp1N/QoZvCsxcTV1UyhfXlXIa8SitsMgkhmgj/a4xNMVruwzjOG6fNfP61JFvYK96R6waHYKu70OtESWconJ7b1KOK9UmxVV0AwmJwilnEjpMXGij7B7zHUTkPgHtubutrPSLLVCpFNZsKDnEZhrcbgnZcDRf5Em9u4Lh6UjgDDH3X/rUHP
 mlTrW1cw
 DiuCkIXwY7K4NVZkWUtCJ9u/d94sp9skpuPUBC0DrrfvrqHppUcWSpY5AiPB1MqEwGxKajEIHuwpscTu0Qz02ecaVRzUbObLqIw8LiwEMPRoayKwCRTLvXJg0VrJLR2xgW0yyM2WleP3cS5Y2sS8VdcSSL4jhUYOARvPmafrRtN2E4A7SuyIW3KfrNdSUkkiMYADh8NFCtC4wWDFwstIdyAWi2IYlwx/SVYxYWcvSSkksx4wt51+Uegum61tHyC0X0mD90t6oudqsJlk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 04:30:03AM -0700, Usama Arif wrote:
> On Fri, 22 May 2026 14:26:58 +0800 Muchun Song <songmuchun@bytedance.com> wrote:
...
> > diff --git a/mm/cma.c b/mm/cma.c
> > index c7ca567f4c5c..a30075507d41 100644
> > --- a/mm/cma.c
> > +++ b/mm/cma.c
> > @@ -188,10 +188,13 @@ static void __init cma_activate_area(struct cma *cma)
> >  
> >  	/* Expose all pages to the buddy, they are useless for CMA. */
> >  	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
> > -		for (r = 0; r < allocrange; r++) {
> > +		for (r = 0; r < cma->nranges; r++) {
> > +			unsigned long start_pfn;
> > +
> >  			cmr = &cma->ranges[r];
> > +			start_pfn = r < allocrange ? early_pfn[r] : cmr->early_pfn;
> 
> Should this be r <= allocrange?

Yes, I think you are right. I missed that.

early_pfn[alloc_range] holds the last assignment, so we should start
from the next one reading cmr->early_pfn.

 

-- 
Oscar Salvador
SUSE Labs

