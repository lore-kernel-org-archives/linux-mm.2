Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72226C5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 11:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CD886B009B; Thu, 20 Aug 2026 07:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A40E6B009D; Thu, 20 Aug 2026 07:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594596B009F; Thu, 20 Aug 2026 07:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 376C16B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:06:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D100EC0720
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:06:14 +0000 (UTC)
X-FDA: 85121368668.03.58570D1
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf29.hostedemail.com (Postfix) with ESMTP id D624B120011
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:06:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="f 2u5j0G";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DaaRtG3b;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787223973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IlbJQP555HoJqRVdUgR7T/1zsnq9NkrwHb6N1Usk5Mc=;
	b=kC1tJF6RIueGGAde/aTQ0QEPRO7bPrjSUOSbOkaIFn52jYXi1fx72i10EVs+RJer7o5sgm
	stm5hzGMDzMjXZrcknVhFu0m/mrj0iuGchhylw4XYUTvv4ccYdVfE1U2mLMSw19Xkk5Hv8
	F6/GVId0KTPCwwuJzRRCpnchuta79Bk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="f 2u5j0G";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DaaRtG3b;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787223973;
	b=aryaSQ31AMlOi6wP62vu2rtPZeQvONNzhd4jsorCTCmiMv6VVjbxka9x0B5vnCvwG4x/Tq
	jOez7UcQlLdGcqWcMZXwOMr5U3VkF3OZfpOziklI334XxAs6Jk2QQVJ+0NBL0AWvN25vPz
	1eGnnvY2J3y7Dq6yIjLTSuvTAWuePAY=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id C66E713004F4;
	Thu, 20 Aug 2026 07:06:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 20 Aug 2026 07:06:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1787223970; x=
	1787231170; bh=IlbJQP555HoJqRVdUgR7T/1zsnq9NkrwHb6N1Usk5Mc=; b=f
	2u5j0GKuzTHJISQTE+d6CfSsMGywRKqWI9TiZT68HXf3EvaG55r3KOqtEMPOh969
	Q8cwy93iv8gO3UQ5w9zzdhJZc4X9peEQ7h+aeG21HzKdV5IWoh6UzvfWi7MD+ehU
	7apM7qB3OMuyYTcpUxvnSJ6fDuo77xO8M6V9Slf6EgE+BEJfzH3sCTBEjYtzPfl/
	l73vuNt5algZ0UUT2YyaSKF4F8TRQz3N+aC4rdbnVlCM6iuFLqJIcRSu7FwqH+zB
	oh7CZgmlSbp+n3w55FIhs5Mw5+9Mv1NxpxdMpYGf5BfoAAxeBELW6WLAiWjt0YVG
	+3WhKExU+MClBGoPDNldQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787223970; x=1787231170; bh=IlbJQP555HoJqRVdUgR7T/1zsnq9NkrwHb6
	N1Usk5Mc=; b=DaaRtG3bmortWYnq1FalinBqLj0ElacZAfHgKU/lTzX36jtOMCd
	V9UWJk1jJg7KIy4ynTcWAv75MHCudW7VAMIzSL12enoIFW0yHGgNZfA9Re+55sfD
	qSwxR4Si3VJkWwf4Yg3/VsiER6RNmOpvtpZbcr/BiJUW8EqOOKJMi1G/k1qNVmtt
	kkGSWGLs2+KKgWlfc/2QFMyKeXvp8DBO5OMRHopN2EUplQtspldu4sAAB/Nl+c++
	M29n+yUhWDIXLWA1sijD+RQc4pyM89pIcQ0otmnBpIxQmTfHusajUUAMnN5Er8Xz
	NkEHumKqQvIx1wpdPg18e7htKt8cQFz9vxw==
X-ME-Sender: <xms:ot-GasYe022TbT-F4MYvO-4wnSH3LHiCxseF9p4Mv_4lt1Fv4pIL8Q>
    <xme:ot-GapuUdC_C04fOp9OlGSkt0rZaJ9-y2RFM19_zVGitdfk4bofVyhb1cDG3UTW3-
    oMzF0S1YwUD4SyEvenKZTuweDH_3TcRRLlIXQynx_pQgt5NdEvjvn2o>
X-ME-Received: <xmr:ot-GaluvtYf9JywIxbtKZ5hcvp-gkjDYUda0OWvjjRJoIUWnXvQDRoSqTxA>
X-ME-Proxy-Cause: dmFkZTGRDXCIHniUcoVMUnNwDLHfq418rjl5TVbty+TXWcaa6tAYts2Y88Shduu/9w8j4t
    lPFGoY+OtiV6YKtC01nyfGKWAAZyEvhd5YxugVsaCWY64LBgqnkWX3IUmygySMtpYfXgyz
    Ouj7muvo/0NThRgZWRwmQ5vFyfhrr1DBAq/W4iDGTyed9JUBb/oP4T1T4qi8kwZgJ6091X
    2SmfsnYIgmVl2EXnpcVJ7LzHkhc4+ckuhvpCop3EssknVkM1P6dKF5wQWH4MltvujePLbx
    Fb2PlnY4i4uu7+IjHpqRW61rtT6e5vF5oFXEroprm1JDdRUd3us22+z1w6/6t78qQjZIqx
    3LEDAbZR47zYr1jd98PUqkIsynHnGWiaAdqKz+KtIPWT3HaW7ZFzWJfs5EfypEiJGncf0H
    aCppRFPFPCPw+SO00MQpS+W+5PtSZjut+Q3EFoVE7Cc7/beLoQUBzIWa/I47Xgsbn/X6To
    wK6sHYYTK3Z0kZ0YdjWzJE04oZbokx/i5aX/tCea2o8oU/whMSNy5YWYVGJKnxjy7ZwfMH
    tTvGjfURot5zs5JFDHaCgdnS17BHbGAN898MRMCIl6bNUBgQ1gcveTyEsmlvay2ofeUmyX
    CO8BMGGZ/tz8KvGSpMH1YsEbFqWs7D6tJDJjEY8Ir9h/SSOosiRvcVqqRChA
X-ME-Proxy: <xmx:ot-Gag3YWp-O_C0X74W5IR1CY787CmhDsf6BABALPyr50-EjuuNVQQ>
    <xmx:ot-GaqPmULJo9CqQ7nkuGRnoJcDjz8lpYOUv1ODuYt-nD6FC0eF6-g>
    <xmx:ot-Gat63ao7t9oZdhcK1k0UlSiDpXkwFovwQZSlnXHlGmNU3AaWLjg>
    <xmx:ot-GapbQTSMkKFXLHiDuBGbn2qVMpNkDBehjz-WOWBJGmDpBHBEBhg>
    <xmx:ot-Gal1hVmEH9KQ8U9rPr4NQ0HLH_J3VEO4h-2Ot25pYqrL92QWV-4px>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Aug 2026 07:06:09 -0400 (EDT)
Date: Thu, 20 Aug 2026 12:06:08 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jannh@google.com, willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, 
	mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 03/57] mm/collapse: add collapse.h for the shared
 collapse state
Message-ID: <aobfkZLCjzkDMzfa@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-4-kirill@shutemov.name>
 <aoQ47NMwUddi8h1M@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoQ47NMwUddi8h1M@lucifer>
X-Rspam-User: 
X-Stat-Signature: znjezodq1ezjysmbq8ek1rpb8emakhms
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D624B120011
X-HE-Tag: 1787223972-644286
X-HE-Meta: U2FsdGVkX19Bt0F145zzXFDg2PqH+zEx1ZmN50F+N7K1mNGv5O8IEA/w8A/VM8Am/qgDzOYljjvi5MNVD77BQaaDT+4aS2WWQ14c14qa28Wf889GnrHDghaX7hemUMKNYHnHA5+HJrr7yhlvw+S1VSxVf0In8klJ8O/TZhjOo9hui305BJvFQT0w0Ram1Amw0cukfPDpOvwqQPbh0s5kUWWVor4+n6YChbaBXXarDu4gP0cnMCCJUupsiOsR5sKcw/s+idTCrQHd2iaEy0gcD2FEnBS91kJQcriFs3VNvRkQWup40wrT70k8uOhMnEOA/iDGwGU9x/NWzmGPsoAT6CX3d9PE7wDYM1naa/E1q0NK8kIyQyCteloDEnxRTtgCeXn7r3WVQ3nLCkrlNmf3oL9EuV5Uv4TQNArdajhs+jG3cLc//uyQFg6h6AXr84AL7XniwYTcg0nirC+ciIiwuDB6OciyTkX1mvdcEKgZ65q4heeyZjN+cBuFu/7/QtxXG8DAqnZtlR9R+eCWjUni+c6BK+nh1502A7hOdr2e6EkD+CsfqIn+7cLL+hNC9XVZQeaQEKWGLHL1HiL8RTxp80WkNy8YzXuZrh14jGJCoPeWe1/wqykdrQUqBB+qh7MzSiYownovc5X+aO6Z33lpqj5YY0twhBs2VmlSO5h3qLoaw7s1uIi4tc19TAdJ0WJXHcgxxn5Gq+g3Czxff0FVNgPEbAEqIjDAuRmgyEazngJB687C+5vIZkMkz5O1ROiNOxjMoAm8gZwi9hFt4QL+lIa6WT2P4ALYJ1Gh2Wlt5h3Q9ZXuThrbY8d4Brm9TN4Ef3K5CW9P4cA5Em+7CQamr/Shgxzvmz7PT4mLOLyiK65QrUrpVIif/yvMR/SNqUbOucOEHm5ZLz37dcPolYTXDWzdivrQka/536/ULrhMPX0XkTfnWj7bXCsZocXAXtml+yIwdTWw/FDHe3WL7Li
 ioX1Nz01
 +0iPxs8EmJO0isf/wbOabasmsN/kvEdUtowbXSHIAHWRcKr4d1AQ86e99X4h3ux8E2/TA9wPeGMcJblKYmIwsNHXRKBNgB9Db9P+NrycsHJV2O0xh3IOrOwbxRqU3dj6JnRslQ0xqs2vKALr0gp8SNlq7tcMnZn5jr6JPhbhecdwG1YnPwlXFjWO1l2mwprFe4dOys7CHVYB/U5XjSorpfELL8q2Pkcpqzm/W4Ac69mneeVmhnwgOwdJC70E52CRtsifpA4QWJHWY+Ed/DcSoSg0RHU4DcB1/5bUHZ1LNTv+OcA4LRcgSpTJJDXvFimXZNwVn6SJbbgUsM8JQiC8wOvRv8gZ8/LAptpoua0aAplNOQOXQkd6j86q/qDAILmNqKAt1q68D7vZBmKkJ4RuclFh6YNYckCPjpb7QuSnwRy0xrIS/dGDjGCnWWXMn5KGeh42iNDM5y3Xm84DeBw312MUu6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 11:50:55AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Sun, Aug 16, 2026 at 11:45:15PM +0100, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >
> > Preparation for building the new collapse engine in its own file.  The
> > engine and khugepaged.c need to agree on what a collapse result is and
> > what state a scan carries.
> >
> > Move enum scan_result and struct collapse_control into a new
> > mm/collapse.h.
> >
> > No functional change intended.
> >
> > Assisted-by: Claude-Code:claude-opus-5
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> 
> Any change that introduces a new file should in the same change update
> MAINTAINERS (in the THP section to which this belongs :)

Will do.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

