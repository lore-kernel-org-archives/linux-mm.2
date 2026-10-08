Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E376CA600C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 14:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7DA6B008A; Thu,  8 Oct 2026 10:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F476B008C; Thu,  8 Oct 2026 10:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98ECF6B0092; Thu,  8 Oct 2026 10:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4A56B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:23:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC49B1C23B9
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:23:38 +0000 (UTC)
X-FDA: 85299677316.17.715C1A1
Received: from mta0.migadu.com (out-133.mta0.migadu.com [91.218.175.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id AA274A000E
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:23:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=st3VYWWY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.133 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791469417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzeckZ5X4eGZ9Ef9SP27DbpSKxHWMfwojQ4zbYA1SuQ=;
	b=A82jpXG+tluU12JXRvG2OUB6BypWoLyoOfJKqhM3O1S2qBnJ2ohMLVAAkNJJn8yqmF75rk
	tqbpbfjGSxioSbu+wgjbUHzqx8MBDFzyaLPKYglxKFzUJDhvamatHVbMMCTWZ7ARyjzFhV
	6EzAgK5Hqn9SKauJUcEeHq1y0P+UdMI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=st3VYWWY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.133 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791469417;
	b=5zrw1hMiAW/2MYMd6oI0ZvICltlmfYHUdwga5sJcWOrHJRylBc6eCmzZ4rTefKVSD+pzeu
	zwrNPQoEH6WStfNjiVfN6vRgyQ4y9ItR6J6aCjMO2TJPhjFjBz5RQFBoxMGLWvY5IMXTEy
	Vr8ukhtaHM14CFGHsyl45U/AUf9J+/E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CkwK7lSN43JMJXrHHY9Mep3RaMJmHfCj7Up6o6iDiTw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791469415; v=1; x=1792074215;
 b=st3VYWWYqkFmcA35F0khfrKTsP3SzeEuB1wnG7nJa6T8xB8lP0J4o2eq00vnqoON0iLbXRUW
 d/QWT0ix8kTVHqh3CPf7Zzvm5Gd+nYl7DVWNmAvuyJMDQJZ6s3KWyZTbvy2yDyp45F9n28pL91p
 YalHwUcej2OAjt1k5Wb8e80M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b03a295ec336a66a;
	Thu, 08 Oct 2026 14:23:34 +0000
X-Mizu-Trace-ID: b03a295ec336a66a
X-Migadu-Flow: FLOW_OUT
Message-ID: <248431ea-4bbf-4a48-a80e-72287ffbae22@linux.dev>
Date: Thu, 8 Oct 2026 22:23:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 16/19] selftests/mm: add khugepaged race harness
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Usama Arif <usama.arif@linux.dev>,
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Hugh Dickins <hughd@google.com>, Lance Yang <lance.yang@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, kernel-team@meta.com,
 Kiryl Shutsemau <kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
 <20260919002451.496763-17-kirill@shutemov.name>
 <85b3725a-6dde-4a57-b303-4ae2b53b60a5@linux.dev>
 <6e3c298f-9b93-43b2-840d-65c5ffa3bc36@arm.com>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <6e3c298f-9b93-43b2-840d-65c5ffa3bc36@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AA274A000E
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 75wia7687shwakh9o5o5zbsofg8wyah1
X-HE-Tag: 1791469416-938884
X-HE-Meta: U2FsdGVkX1+u2GPiHIK5WBmmE/FYwRxCmote+nGIPSTJfWefB/bePlcMwC3tjN1IiGhq+lJfFeLdxxyVkeajRGc/Z7DN1mqYnRaP6KQkSwx8faAN977xTV6dtYjxGfOhYLQJJmENJLfGxyct86J/E8wK+gVFIf7ccwO8hB700w0u/7Z0yLCAlKBlFNbT51INDrX1f/PCO0cqOFANnO+UR8RWeSqIcSDoDEUYHffMyT+i4WS5qXFed0PdVNm1qEpYMObEtQsb/zN3BNEHd+XBk+ReSFKM4euSQuFCFjJFQCEa024DC3P5qLAEC1nqzwwMt8NAr+eX0qMlxHp+KTZQfDR2U/wYlHGq11KV7RKCKDN1hPNrmeRM37rP27Vgb7M9lmWFaKDUg1hvq3IdH0/pTAsG/PDWIsMhmX+PcwCBFaKhcQuBihzFpihLTdR3MhYtTmaUaPgxxNLcVd/DgtcLnYtzfNXwew/XfhiADk+pKyjlob55M+ASmsk9X2YKU8WVjoA90oywXz25bIF5nhj1u58XMZJpTj6U7VuZdCjo+PYr0S4Laubxi8EUmDCsxKhHfTSSzzcaT7/RbN2rojf6EjjtObY302Cf26MMxgUXvYHtg4BXKh5P4GeEkpFQ82LEdVOGsPH/ciY5+fd1417t+YzARgcEzbxqjDElyWp5t2pFy0Ht+3mvOmhpXClT+LDMkI/gZi6DNw4s9GkKClHJ2zdxkhP8ogHAarvJCXpNVl0t4UC7cs8860Inhtar1kEC3hRZ8jTamGMtvdZnY3yyUiFqpAbGdsZlVr50nfjMCye62JGFKfFCdDZSwdLHeocjlrtaMaqgJd8nTx9GMXRB+ARuZj3tSfUBvOs6VXz0fAhqoq0eCA16FmY/NFbRQO49Ja+b3tCT3SL9AXFVtZuGqH2Y21edTBNrJCXfliUzoYGaXDz40HnDXTo6fZagixiS6K+xWiWrBjY9r7MuAQF
 M9h11f9y
 JY6x7kEL7CzSsEqXmucsNRtrD1vvgg3qlcLtqBZgAxsnehu9kPFEM/HDJOhCbJ2AyxKGN7rag68fORgibgCt2o7yzn3CSOm7aW3TBdSbgSddQKGYm00rD3zt3fm2lMcxbeL0ts5K+ekDH8uF2c8IIpUthiZiZORyAgjHVvJdpp3fdFl+EbP7JSntX6LP7ouEg+/J9R/7o969+N4Li4Z2Wbp0ZPqrAaqI9uBFE/8Rm8e/C2eu8YZo+9qroCv6gCen0E6OvrYZrtReHhHYlIk9bLjt0y9FaS76BEJrSVruL4TN+CWqT871M0I276Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/8/26 4:18 PM, Muhammad Usama Anjum wrote:

> On 08/10/2026 8:30 am, Zenghui Yu wrote:
> > On 9/19/26 8:24 AM, Kiryl Shutsemau wrote:
> >
> > > +		} else {	/* madvise */
> > > +			while (now_ms() < end_ms && !corrupted) {
> > > +				for (i = 0; i < nr_shared_areas; i++) {
> > > +					madvise(region + i * hpage_pmd_size,
> > > +						hpage_pmd_size, MADV_COLLAPSE);
> >
> > I got the following error when compiling it:
> >
> > khugepaged_race.c: In function ‘main’:
> > khugepaged_race.c:506:23: error: ‘MADV_COLLAPSE’ undeclared (first use in this function); did you mean ‘MADV_COLD’?
> >   506 |       hpage_pmd_size, MADV_COLLAPSE);
> >       |                       ^~~~~~~~~~~~~
> >       |                       MADV_COLD
> > khugepaged_race.c:506:23: note: each undeclared identifier is reported only once for each function it appears in
> > make: *** [../lib.mk:225: /data/code/mm/tools/testing/selftests/mm/khugepaged_race] Error 1
> 
> I've just tested with and without make headers on linux-next
> which has this patch and I've not received such error.
> 
> If your system headers are old, running make headers can help.

I forgot to mention that this can be fixed like fd5295afae91.

Thanks,
Zenghui

