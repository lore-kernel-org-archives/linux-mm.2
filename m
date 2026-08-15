Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36815C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 03:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4B86B0332; Fri, 14 Aug 2026 23:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C576B0333; Fri, 14 Aug 2026 23:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9046B0334; Fri, 14 Aug 2026 23:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BEE06B0332
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:54:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4B771602DC
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 03:54:50 +0000 (UTC)
X-FDA: 85102137540.23.D327E7F
Received: from mta1.migadu.com (out-159.mta1.migadu.com [95.215.58.159])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3FD14A0003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 03:54:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n6vNuCnq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786766088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLrBt+uq+d03qzd5+hG+xXWr+Otm8On+JAXxs5+cV98=;
	b=RiLRbD3xBhm6cJL60fIdTuOuV681aBxvH2ReyF65EY/c8+LyR4QZRUJ3eqAdSuGTcu993I
	0omgx8fSokqePvGL36EtIyauI8xlIPbtdEeioqAGI34Jh7gSS+wDj1bM67fjG1iRksCokq
	G8PGPYAjcJFPMfU4ECbAyPbk0PLRN+0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n6vNuCnq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786766088;
	b=ljShVH754q0Ezn7hEKjv/DU1or1jqJuqdqnZLIS2gx6pDvFtxnNa6Yo3OAzg/PcnT8FkAL
	qU1rozI/XqY+hnYYEplYN30gGDg9hEcvpRINSsypncZzsWDDcmGfYJT4Td7T01yrRItxY7
	KxI90xxGvhTeEEeHwFMgpm5NW4v/24o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8l7ix46u22DBJHyDAdgQxSxR4YiD9zuO4qj39ojr/7w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786766083; v=1; x=1787370883;
 b=n6vNuCnqlI+pUIgmT+1QhowfklOkFkZVaBsLd0sqdwQ73kTDDww8x9/IGcVEghlUSSfL4KNP
 CXPuhZucti2Llk3SjptI3lYKb/84QB2F9sEuTtD06+KgD8Kxu5rI4rCumuY4lXEYdoZ/Cs5i3QF
 3OCP5YVG8aYRdGJTF1BQciwI=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (2409:8a00:1832:cf0:a88a:e36b:332d:205d)
	by mta12.migadu.com with ESMTPS id 0ecf74c5aca00b18;
	Sat, 15 Aug 2026 03:54:43 +0000
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 1/1] mm/hugetlb: keep max_huge_pages when dissolving
 surplus folios
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260814083027.1419487-1-xialonglong2025@163.com>
Date: Sat, 15 Aug 2026 11:54:29 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jinjiang Tu <tujinjiang@huawei.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Longlong Xia <xialonglong@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A277EA38-31EF-4252-BA17-6B8A18DB6174@linux.dev>
References: <20260814083027.1419487-1-xialonglong2025@163.com>
To: Longlong Xia <xialonglong2025@163.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FD14A0003
X-Rspamd-Server: rspam07
X-Stat-Signature: ea7qgfwcpj5j7yndkrctgu9g4x3m6mkx
X-HE-Tag: 1786766087-740539
X-HE-Meta: U2FsdGVkX1+8+uyZ4so/TIdYBKi/hcci6ieYw1wlfrJaKgQdmnu5kiwZYWY8CYxDKHH7/gQen0Caod1dch6BR4vNhL7No/nI3EJ9xnh7SQfjF83Gup86iFLU+fS25yjEMYiYr9o9C9bvaF2uf12JrTCjZEXqBofaSJofEbNDMcGrOVynEM8dcioxK8cjbN2H4d4sstZv1HkpNCO+ouWLGRjO0S2Q2hbhaLezmdp6JuAerTJEOs9Ka8jqjWuyWhKe8mrRbAskg0AXBJAUxO+sF/XMZ/CbHtBwwSLAI1/d1ijtnL21FS+gFmB2Bpo8K8U/HnQvlWdmCVk23mYdPJ42GkiaVcf6rL2R5nxFKezAgPa5dodM8yD9NCeQA/8vLcAvwwMPsv118YtKGqDQNsbkSgkZKdFVeVC6RysM8VkyP0r5Sc1IYldvtFmvCmUswdNfeJ5iPoi+hWhP7jJsW++q8ncoPTYr7ceBDAUjDLs1QpugeCZRJiSUznM57MAxhM3AHS7vYSkPeNzHLVBizdmT2GGf46czwla1RJf7mnXZaToSNuqsqg6LgFSO0g0NNvPK8BrjQVNqfrgSyYl3dkN2duTCBOiQLe3YVpScPm7uozuze8IIwCgTFhS+Oa9nJBqyaRnlLbkrDALyPae4bhjZpJ6spDAJvFyCcI9pa4EBB4OoHaRjy9cCs3lMwIzwdPI3slCttEVJCA1d6S/RpwLOFMUbMLQMnfLLeXwfL77sj8gWHxme7MBkmAyq3Bs3w6+K63+eRApxDRzZ2PcgmMm0TIZzSHEpEBKf65dsRdQ03qLdA884uwV1Dmcu1pACNhfHSXSsyrZ75UF/QW426SoDOVSd4kaNwTGxzN+SxCQew5CaqsoInW5R/Ml9P74vXl7vYxysWxn8I++BbJDLBNUsgebvgcoXzxHoS76WfIlLdF99WVB90jAvJ63/FB35/T8NRlv8w7iiutWU6gNXUoM
 ApTk9TCi
 L2Vnfwd5zYrk+9kwiFvSezsRccIPM0yQnq/HtGnkTC/CurWujQw4T7kooNvbDRn7yCknmymt12rt/U1KnMUxQdS4QqjsJxcCmdZJoFLzWr3BPzQSPDMw9PbV+ScZ08lsc3WAuSnRUrdPk41aGDpgkXwFfu5b2iNzdG2a8EsHRNpu3v16+loYFFNrm90Sh8oYvM/htMIqj6ZN0hnvl2cONXljvsb9B6FXmxxlzy/dm2nRexQgchxDh+Azi8E75GDIju63T7Q7hbc1rqCKeTHjPeHlVtsyea55ZPRhc/gL7i6WI6psbaU1LevU5N8v63j085oBNsKohwes+mkh+QDn8x8gToSY7GvQZfZAucMbT5PF6QG5IGNGRFsdQiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 14, 2026, at 16:30, Longlong Xia <xialonglong2025@163.com> =
wrote:
>=20
> From: Longlong Xia <xialonglong@kylinos.cn>
>=20
> dissolve_free_hugetlb_folio() can remove a free folio as surplus when
> its node has surplus pages.  In that case remove_hugetlb_folio()
> decrements both nr_huge_pages and surplus_huge_pages, leaving the
> persistent pool size unchanged.
>=20
> Updating max_huge_pages as if a persistent folio had been removed can
> therefore corrupt the persistent pool target and underflow it when
> max_huge_pages is zero.  Keep max_huge_pages unchanged for surplus
> folios, including the vmemmap restoration rollback path.
>=20
> Fixes: cb402bbdabca ("mm/hugetlb: fix surplus pages in =
dissolve_free_huge_page()")
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


