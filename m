Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70B48FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1A526B008A; Mon, 27 Apr 2026 11:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA536B008C; Mon, 27 Apr 2026 11:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4706B0092; Mon, 27 Apr 2026 11:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DAD76B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:02:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 612441A0D79
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:59:34 +0000 (UTC)
X-FDA: 84704644668.21.73D6E38
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id AE9F0100013
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:59:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DOppvcSt;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777301972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LnSYo4u0L2Q6YEjx0+dHXcL7aARLporXLzc/o3YTey4=;
	b=qP2HfnXdtMP0zQb+M1xwy9GcSDD135jz2zBvsidpSvAjLNHO6w9JKw1K2EBTMbBSXRVZsP
	fxdUxsaUdhQ24Q7qAnGYf/wy/sBdXnisSc51S8RDcE2cEdCvPel7/jBiRZ9tBcyfkQQNso
	Z1NBGoVcifPHDYFy8e4sLuFlzV6mQ1k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777301972; a=rsa-sha256;
	cv=none;
	b=H7a/0dkPk4D0WO2rDjgy0fM4gCCS38tg9xr3UGPumgwWsHvS5z7sYx+0iK+2mRJZBfF4+f
	AxnJkh0Vore00Y2FAtCLFgCKr0wo6ejypAu673TehHsyK/YJWoNzwe9v1jR3WEPZjdCIEr
	4mr80VkgLgl50zeSfsa+tqXlwd7Ypu8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DOppvcSt;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LnSYo4u0L2Q6YEjx0+dHXcL7aARLporXLzc/o3YTey4=; b=DOppvcStsIhCJdrfUDmQHbkpCJ
	vxt0xZj3PArO+3swzACOj4C6ddv3xiAtzOO4ch4r7SyyXSWN1W7zY5CUtupWFw0m2E2SbGXzE+kZ3
	yL2OlsnQgQi15x+WC/xPVcoEDOgM08hL1VxXOyuf84KNTxkTz3HU8LvfQEvD9/Axy6xc1UA4i1h+j
	EzXXiz/ixQIzlFf4xixGXeiavCpXi+uXv6CgT2bV/+hduPx/4EH6OEt8iWXDy9eC6arzbycDw5yLw
	pgudYhnMvaduKk82qPgPyzSo6SxXaG+M5YErrZcBE84J2+4uQ2ZXnY7v91KeC2VFFzgoqPLv8OTRh
	wChocelQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wHNQa-00000002Eyk-3fVi;
	Mon, 27 Apr 2026 14:59:16 +0000
Date: Mon, 27 Apr 2026 15:59:16 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Breno Leitao <leitao@debian.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm: remove page_mapped()
Message-ID: <ae95xHobKZ1MpmVG@casper.infradead.org>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
 <20260427-page_mapped-v1-3-e89c3592c74c@kernel.org>
 <20260427062137.48739e6fa6e550f1f0e8ff48@linux-foundation.org>
 <06218a87-8346-40b4-adf4-dc494b5f1293@kernel.org>
 <ae91ogo90bSDFNPC@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae91ogo90bSDFNPC@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: AE9F0100013
X-Rspamd-Server: rspam04
X-Stat-Signature: efexz6n53spkasfq6tmyz3jzu3zd1ijr
X-HE-Tag: 1777301971-747835
X-HE-Meta: U2FsdGVkX1+clHYORUj8oV6pIort1Kmgh9ZwNccRcU7cMFN1omIImFzTqUffGtfL7c3FCVHPo90zJlcwhmkflOpaBaNDZpSCYfYJdMBE32OTN35CvtfXgrCEjnxmacGhtwJHq796NIYIljomEqCJv2ojnqm8ukC/6f7ZVzXFvsKKO41Qz1B7CDbU7tEPuERPWOnA/w846F4SlE8+05YbjLdG8/jCDSDOxt9sSn2hA9fHcg+5FgIF1lZWq1eO8kpRuJXaBqZPRNtpiF2qIrGom0Ckwqdx7EYC7GCOTRo9VW/mafWtpNluu7qGoOHe04alrPM4BivS+a/239AUlHiZ36guBlWbfipn7Rp4fYlnHWn9i2XMKvNct3snpGxNkFiLt8M9xmSQv3GfYDW/+l26bdaavZb5nWWWvzuGAchMEf7SL9Ln9ImEL+EqswpdjhZeJBFLALL7sVGStO770sTVs5ZEt69Hhm7dz+6eYRiAmU4xFfJiCnPDFYKXyrLlj/Q9rgp/bdlLy3z+p897QDHNR4EngR42yjYxd8a7CUIelgFFtCqmStsMMMJVZyjDopOMLbMwG1lB22W8KLpTRHFg5f9ILEekGg0d4A722Qb9DKaN8YzVmtTtrZ+Q9PtYJmSletndu8Q0kNzUGh/aHpb4EcrJ0kTRylBijqbgc6bSnmrIP8GzrvBHJ5H5js15/MlnM7QX4gjJP9y5h4xV1iii39F9p0e4hsB2bfRuHejvKUp7Jp98H+1bhINEW0qwLTTvMwQ1EX+3RR2g3pZhkitCTCBI/qo1dsT3Ik8sJGzR4Ip1psF8PJ/86nuoNSl8gDQRPAKZBnTbrKnaJBfUNLTq8m2UW5VVfg/DsRF90ahTVB9fZlAyiHHf+dPsHwWRCjO6S25dzkNuupdmxDywXfcvGoq+QvKLWAZgdG+ci2tjSuRNxAH7NLMsMDhyet0yv89no4asSv9owkqSkIpN1Do
 Z2wYGf+G
 /Xz6/F34DXBrKhVGVcyeehlRr38zx/QDN8WAR+aIHEULedHwpF2ds/4quUSmM1BSRmvl+1BxOr5h0WYoXflLW4QGnGudG+vIKpsMak7RQW7t6itFLrQraJu9D67lVStnsG8TaOmKUjeezZAzcp4kk2f8cX7kzjByWfdMh9sBE7m9VQWGBraiazNJLTmXgi9fNt25XWzBv+1o9M2PCTdBDpliPysacMB9fWfDQ+bsSayde3VNRUsSG21iKIMcCtJm22qxSQkY8T8x//VSSqPdplXkpp4WuMapkgeLZtOhYlzmcNpE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 07:42:46AM -0700, Breno Leitao wrote:
> > > @@ -1353,7 +1353,7 @@ static bool panic_on_unrecoverable_mf(un
> > >  		cpu_relax();
> > >  		return page_count(p) == 0 &&
> > >  		       !PageLRU(p) &&
> > > -		       !page_mapped(p) &&
> > > +		       !folio_mapped(page_folio(p)) &&
> > >  		       !page_folio(p)->mapping &&
> > 
> > If we have a folio, we should really lookup the folio once. Not 4 times.
> 
> Why 4 times?

Because there are page_folio() calls hidden in PageLRU, page_mapped()
and page_count().

> > Breno's patch likely needs some love. :)
> 
> Would something like the following give it all the love in the world?
> 
>  folio = page_folio(p);
>  return page_count(p) == 0 &&
>         !PageLRU(p) &&
>         !folio_mapped(folio) &&
>         !folio->mapping &&
>         !is_free_buddy_page(p);

No.  You need to immerse yourself more deeply in the folio transition
;-)

