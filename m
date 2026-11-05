Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5967606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=crabgneU
Received: by kanga.kvack.org (Postfix)
	id BEDE86B05B2; Thu,  5 Nov 2026 07:26:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9EC46B05B3; Thu,  5 Nov 2026 07:26:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB50A6B05B9; Thu,  5 Nov 2026 07:26:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B17E6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:26:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 185DB409E5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:26:56 +0000 (UTC)
X-FDA: 85400989632.30.3CB7BAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 260D080004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:26:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=crabgneU;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793881614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfOsjlvob9X1Nv4tPZB2NOmpGW7g89IRPqdxDe2tUAs=;
	b=Al0CIjhxCJe9jpnSU8fITSEMroplqhJLKGMlJj9bgQa7rEr0rPPt6nZKIPNJh45oF+vYA1
	SbRmONLmmMUtULgsxSIe5i5Fepx+WFV837xU7J/AX+V/5NjEByd1Wps59+rpSU0Z7VQPmp
	Nwbyg2vgqLek9x2yKA0XG3Se6ax9GBk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=crabgneU;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793881614;
	b=JDxO1+JHE3ftCPB7lbKdF/v7XphJ9CnlddD+MkHEXtkkIuh8l6uK7L1K12T+5XUwGuDayS
	TEqDrHsuN8u08P7M9gdv0Xx2EuHuRQg9mO7UbSo3CWNogbT2sEYniZd4+Fp3+DxAhPn/ko
	9bmZrTkufd7SVnCgz8CQXVRBeVfHaKg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6846560F1C;
	Thu,  5 Nov 2026 12:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355FA1F00919;
	Thu,  5 Nov 2026 12:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793881613;
	bh=HfOsjlvob9X1Nv4tPZB2NOmpGW7g89IRPqdxDe2tUAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=crabgneUopieCmEmFhOmMhI1Tsoe92rd+TI53bqvHoeQyshhp22Yd1zNyYsv5LzGP
	 ikftOr2uvyO8nKJqzCUaKR8WtSafRvsxTUul/IsRn52MufJMQO1DGaLHOyQDl2WEPn
	 l0HiT4yZhjgaJqHegx7kQdfL8tEAd2hwOuVcNrEq7yulZzHCNNlJ/Lbingd5cZQVoP
	 fK+7S2e2P0RoHm5xcVt2ZujjJ95rgnU49+jRO4bic38/9+M7QVJi9XL8DDUj+vDLG4
	 gWP7UV68Xstd1hjJaOne2luV22SMjCAY3qSmzzIKaWqdz8BK411W716DbhYaJoHW9H
	 SE31Yy6un2GBA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7DC811980052;
	Thu,  5 Nov 2026 07:26:46 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 05 Nov 2026 07:26:49 -0500
X-ME-Sender: <xms:BXbsaiBhyTEGhgpqMhXg9Cmentoy2sViY8s_3I9rs-w73gawOcuD7Q>
    <xme:BXbsan_MsjP-uLRK9wj60iOP6pxMpMtObNgg3nTB4g86GJXn-dIAkefrCd-ywgzlr
    LDbbiBYBoU08wEfwPxZIcjuK8ZlEojpoC3efNgGcnX0zgiCcZVlDuPPgw>
X-ME-Received: <xmr:BXbsapLBhx6NU2vIMe8SlDeu8ZyPQJoG6enGS4rTRBSpgnq0xYR0wakPZG4>
X-ME-Proxy-Cause: dmFkZTGVfuvqVkxki9la42m479/fuAu38sqk3h0/RigiFu9otpD+tJDC7VpSSzL3xzhHJ4
    i+ve1m8wGeY65rOatgOHPXcpXjsv37rr7dyddgk/yAh0bDgP3MmmcTyP5UuxCqL85qvYUE
    o3u5pQ01TYYDV7f5IxieW8w1IOzD+rgpiA1H6Vh6obTbbIORbX53uFr2uTwYAKHk3fGKhc
    nUjO0rZPzPOpSVWtVYAS2TWWUq4Jccmsti9YwbSGeZjAh0LJk1kOnkCSKQRopjQ71bxgjS
    TSGO6CCKXZhNHP3vWoiLOPNjZ60UCE0GBZ8z69OTYOiPSQLPEiIPzed3LiNolFhPbCszj9
    dx+mWHK9Bq8glRRSDfH2/xodnfECGhOuRS/ziSmURNlVCzMsArNgspcErWxzThPiIuypIv
    U9YmllCpRON1RhL3gmOgK1kULmcKfG1o+zhQahaNIVOMQLNeEvK0idHVVk/h4+zOH18dbV
    w5cUlf8XRhhsm2ouG6+wse2UwlDYq4eFvQqzQ8ScGng8LI5M044s0vJt1dBF4kZwaAi9HT
    N+aE3j4t0M14Cbo1MGz7xzR62AMe+bhHLAVMcllihiIFccnOa2trfkMnY2yukRBIQoIHQk
    CapwDMY/2GAql7av8jtjMmksJYg359ne+Lxg60x2pbaX4MulOfa1fAd9XkcA
X-ME-Proxy: <xmx:BXbsapy2VdmRLLgIHFqq4frpNnUVoD49RXPYX1l0Z42U4VbiSyf2dQ>
    <xmx:BnbsakZR0m8DCQMNn2LRrxv4HwauuYwCz2nN95ub3ekeiBzeHapvfQ>
    <xmx:Bnbsapslx8Q3SaIfLeI2jAcU09mhLw8zeW4hZwAwdTsdUbhXAJn1PQ>
    <xmx:Bnbsamc1Cwx7UiloWub2S9R1QlB8V_D5ehguwDnIKLPwXRl72qrTEw>
    <xmx:BnbsatZ7ZJMlGQ4d_CjItDLjagMg-6JiuytMaa_OHbOtzbxgj_eiDM5d>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 07:26:45 -0500 (EST)
Date: Thu, 5 Nov 2026 12:26:44 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, baohua@kernel.org, hannes@cmpxchg.org, 
	alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 3/4] mm/huge_memory: add a per-order counter for
 underused splits
Message-ID: <aux1p4WFx8SPTYOf@thinkstation>
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-4-joannelkoong@gmail.com>
 <a16f1f8e-d3b6-4145-890b-51ce3c0a7f03@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a16f1f8e-d3b6-4145-890b-51ce3c0a7f03@linux.dev>
X-Stat-Signature: fokc3d1r3msujhx4ki57kzroje6oeiid
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 260D080004
X-HE-Tag: 1793881614-722452
X-HE-Meta: U2FsdGVkX19hURTU/rTb3/29/+cscsg6+bEeDF07YizWYNE5W98XWQ/mN0nTTHDaL/XMKj/qwIstMuNBd5fAnDg6WOZa8QJXU5iGzezFhomNGY5kDcPZYFpBTkKQ1XFDsubnjIi7rDDx8vPUAggatcNwn3NQkXKYlLx5HqnsD0hVtc43trqi9Kooj42jxfeoNUApOSII8KCnMSvKjRLgNRAC4bx+klGoudgUVCsuCEg6G06SB5Qpsbf1uRQ/TRjsK33ea9sOJTx1KjwFVzFUF8ymW94w1F0l3IdiwKHIkrmvAWZvkG6TLbmxXUfKSl/X8VmSM6CVohocj9foT0/OV5xyvs8wqYzHo6OmukNLbXz6GmJ+GQHdx0YW5okfJE56Gq/b36cnCd0/ts+BjqXq3/DD+qUNpobeuMNcOJjEyEmN9H9ok8gMYp1rWUbnFJLAd3QnuEUFks1rx1qb+VdV4beGD3q8D/KkAwRZizbxveYgXuIdKiebOALU37T+B9vZlgKo4kSh/mcI0VbuscKZr9Hkub/WwowNHPWVp8onVGp6Bo8R7Gd8PUXZoPGRTsupnAZdFAFTr0FQVKkOeYZcyiG8m2AIJcIl6X/4bKyTLkju6WAZgBDV1tgk8DjzXSWKNHxSIe7240xrWQVcQZ8YYJZKoTCRygjB0outaM/5llB3GWKgNXfuYJxnPXlKDudquTxi/ctuiqgyTkxG2owhVCGEHvp+AyR1pZUjbQr12V7qIHwgdeOjZtHZNyxlDOftapvKSZrO5IvSTFsPDv9+X/XF8TR8Hlr6mLbGfj01EHPckOlUu79InIBBI7PbHMrFEeqpMJ6Qos0ANIAn5mb1SLRfZlhnLocSK37xiNjlUeHRttNvOIw10/iA8uggcvvZCS3pPJxsMlDAHV5D+BP9vXQrdLRxK6vQtjXtOmAJRnpaqUYP/sDd/m2pXy0rcB1QOeVuK2Jk2ZcTIAf/xfo
 K8f1yO04
 DwswbuSEEgH8tIcE49ZSbiyxKC0JrN58DRZkCoGeSLWDS8YqhSp9R6I4aiSBsJZcnmWRi8YmcSM6BuCBiI0i4WMwgXNC2wWW3q+51jirad6UB9JSGhC4e1edd3wbp7fcTlH1kDMs7Yvme5satdtshBNY1wDIqxfpXwbT7EOiWjrBo0NL60wl/o+d5Ej8kt25wwgYUT77lySThCnt9iTYnnYQgysKviTHS3CCfjwmaQfieZjMUFLugfD+Nxs0bEhQkyKB14yXv9i0984kRgWAhwcH0/+Ya7t6VA7QNvzBun44hB9BU6EOQIe8vp+iMwjBANZ2GtWKfUV7BOL+ettmbN2ta2Wq3CXv3jBHyFJ73Kafu+Bc7UYl8vOT30A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 10:20:43PM +0000, Usama Arif wrote:
> 
> 
> On 03/11/2026 21:20, Joanne Koong wrote:
> > thp_underused_split_page counts every folio that the deferred split
> > shrinker splits for being underused. Today that is only ever a
> > PMD-sized folio, but a later patch queues anonymous mTHP folios for
> > underused splitting too, at which point this counter would start
> > counting mTHP splits as well.
> > 
> > thp_underused_split_page could then end up larger than thp_split_page,
> > and there would be no per-order count of underused splits. That doesn't
> > match how the other THP split stats work. In /proc/vmstat,
> > thp_split_page and thp_deferred_split_page only count PMD-sized folios.
> > Splits of every size, PMD included, are counted per order in the split
> > and split_deferred stats under hugepages-<size>/stats/.
> > 
> > Do the same for underused splits. Only count PMD-sized folios in
> > thp_underused_split_page, and add a per-order split_underused stat that
> > counts underused splits of every size. The folio's order has to be read
> > before splitting it, since the folio is no longer large once the split
> > succeeds.
> > 
> > There is no functional change to thp_underused_split_page yet, as only
> > PMD-sized folios are split for being underused today.
> > 
> > Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  Documentation/admin-guide/mm/transhuge.rst |  6 ++++++
> >  include/linux/huge_mm.h                    |  1 +
> >  mm/huge_memory.c                           | 10 ++++++++--
> >  3 files changed, 15 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> > index b187d618452f..6f2d92a2a556 100644
> > --- a/Documentation/admin-guide/mm/transhuge.rst
> > +++ b/Documentation/admin-guide/mm/transhuge.rst
> > @@ -719,6 +719,12 @@ split_deferred
> >          it would free up some memory. Pages on split queue are going to
> >          be split under memory pressure, if splitting is possible.
> >  
> 
> In this same commit, would you mind also doing s/THP/PMD mapped THP/ in
> thp_underused_split_page section in /proc/vmstat section?

PMD-size, not PMD-mapped. But yes, it would be nice to update.

With that updated, feel free to use my

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

