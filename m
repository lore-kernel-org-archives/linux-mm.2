Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 304F8C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DB0E6B008A; Tue,  8 Sep 2026 09:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B27A6B008C; Tue,  8 Sep 2026 09:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1316B0092; Tue,  8 Sep 2026 09:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA2586B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:09:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81C944065F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:09:09 +0000 (UTC)
X-FDA: 85190625618.18.BAB31B4
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7DA1018000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:09:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="h iT/r7z";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=q4gss+Uq;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788872947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ayj4peSiR9Svnk4dcRkrIeubDo3GBkWjAAWp4/esog=;
	b=JyX+19h9KtKrXtN9QiSpNOFORFk3ML6kz3hbw1khdWMm8F/8sjKY7N6pZZGxZ9JjFiYm3l
	zINFLnEs1pJPAHEviXPMNGSK0Iv8BkakHzfMYd5/TA8XvATpvHPwvn8022JZh/TXnBGLq6
	PZGOvH0lXUsB2VtWZod5PPxm7jrglOs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788872947;
	b=UWZwbB8nkIinCYQshoxOTG40jLAQiGoSgNsTyqNB1DLdo8A4qrryBf+LoWWSkOXcjC2bCd
	ZCQRaj5WiP5jf+N9lHZ6mmIyD76O2EDS//X/ZRqEXPcgN05ILH6jwFzSsg3zfUkv9oRZ7y
	ujpec/TJiSK4Q6bVbP4fGp1tF1wjI1M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="h iT/r7z";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=q4gss+Uq;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id E0278EC012C;
	Tue,  8 Sep 2026 09:09:06 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 08 Sep 2026 09:09:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788872946; x=
	1788959346; bh=4ayj4peSiR9Svnk4dcRkrIeubDo3GBkWjAAWp4/esog=; b=h
	iT/r7zQhr70zC5NihfXkAb88NPIyxmpY6AT03lzRqA9MLg9KC7Ek8Ty9MEpXb4Ju
	H1VQLu5+Ad351rw8epWiSuYjv5kkDsEiUOWJ3Uytfdc/MVORwf8d1w7lSzoZ7jFD
	1+7d7JojdOQfcFDOqcuTLsn0jrwSPF9/n/uKomgS+9bUrTtpqBgGFY4jZf5aJiiU
	86AokqbOrJ/P40AsKvuY45+WSM8JXy73+9rxM5tGuhpi8pj/vUKaQW4n1KjnzVr1
	9C02zAUZCtCqFSM2JtlIcUCODURj25p8+WqOSvgaEbzl8hd6Jn99eF/Fa02S4Oqb
	vmuW098rs4Gahnm7+OllA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788872946; x=1788959346; bh=4ayj4peSiR9Svnk4dcRkrIeubDo3GBkWjAA
	Wp4/esog=; b=q4gss+UqTOT1NnlPnnjbIKpJ/g3P+FoqFME2fM/13CR5+SFGjrg
	ADMoyARmQLu+pU1WDi0iZjWHPYd4vBaafhfjyf1HcbuU/CUdceF0z3KKxhzy7hXB
	R2h33gUWr3F1mlXJgyjhPasmJhC0fsNyAohG7HJkNvu4/Lx4gdINrfskvaUtXLlk
	5O8O0JffWP5Zdte1Eu+u96buBwpuMFnluFsv9WD+SujzK5nQHbUR7BSXh7L8jw2x
	SeRo/if9njVQBXxBO20kkJ3F6ZrNymRHZOojZITn+KDISVgianfuvN/8ySWrKq0v
	6gmh/1mo9RTQ5uaFxg3Bx9zLUzTGxa3ouLg==
X-ME-Sender: <xms:8gigatS6yC8ny3IVTtM0JzMpyrHuKXsHOt9Ct7XrqCL-jBEEUE9ZDA>
    <xme:8gigao1HlhM9fZd1lx6ODg7qXColQhWnmiPONuhnoBwgNSF8FftXOAslGsHsTDEJ9
    _6yZSfOcxyOW5rKGezHZG0yG9kEKnGjIJrYLsiB4XPJ0sxB17Tom0KZ>
X-ME-Received: <xmr:8gigag8rFhCC6KseXt4l0witibDd6_eLy-zSPMWPp3Ke2koAqs-Vy5xG8f4>
X-ME-Proxy-Cause: dmFkZTFVW8T6Hhbun1kCRweiWLTW4B0DweckVuex7uj8ZYNR1/gxJR7tKJt3JXNK8Om+03
    K5k1jQTsgq+L9NoWVoR0nWsC411it3NbkREAwr7Mv8YOa6AECeJYV6rN8pUV2U7Ye5QXSE
    Kb3b2KmjmfBJsH3moF1fEWaQxyoGveHt8bJlj4pFtC3Z4MRA/Hqg/zLKteN0LK9CXq6WfR
    dGLbKn2Tk/pNxZQl1bfNTSji2dqJQFlIwfvSHKqM4mmK9RCgWRLrd4AThRYqA7qXrzzDyx
    xixbOrMKoz1Bo03Wm9NGoQ8Fkkosjy30K2SXNi6bkjaY7FiqhmPQQ1L3FM4/uIdQa8/aT8
    iqlnvc6OgLfXBjRiE3WVxkuDHsMC0K8rTFfZjzdhLHmb+CJ8cXUpbu5a7cwUNCsLRcP6HW
    3jNJYgdGJ5JHLKMVcJGeoKBvUoONVrZ7hKZk2+V/wLGSuUZwTaALaoCP0tBSw7Kpc6jKwi
    /oZ4G9nd4k6qvQzwjra1a6k9ZyqA+YL9T6AfwVJy4SYZYm465fdbPyDrEjfzXcT44EW//T
    MXmJ2E+pBcV+rP6dQxzfL1b70ovzluegONoR28y/Bi4HvZuEbBsPlWSOB4KR2+bMiAU1Z7
    5Isf7HdUQ/m8AFJqXDM4FdT1zUVN0XrhiKYpa/ry+BJgqqmNKSVf8RT+mjaw
X-ME-Proxy: <xmx:8gigap9DySO-xz67KhqOoXTqVEM4C6MXgsPe7G_cznS9FXNIgXZxhw>
    <xmx:8gigajECGeOagpaJs3teiMUFAz83cM_XBQNjl9fTWFRyemmhwsRiUA>
    <xmx:8gigajf37X8vwqQdGC3lqQwteJkolOt99f6JCtPcfGZz6MGyPyslog>
    <xmx:8gigaik-YgEmlZ5Q38n3BYnAFUr3v9T8nHIQ3lZE5Zh54HZX_VUqAw>
    <xmx:8gigalH0G0HBl1IznQMXiEdN1oQLwpcUHFEF7mj-0aNkiWN01RKdyvon>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 09:09:05 -0400 (EDT)
Date: Tue, 8 Sep 2026 14:09:04 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	Gladyshev Ilya <ilya.gladyshev@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	hannes@cmpxchg.org, usama.arif@linux.dev, lance.yang@linux.dev, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, kasong@tencent.com, hughd@google.com, 
	balbirs@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] mm/huge_memory: add folio_reset_partially_mapped()
Message-ID: <aqAIFV4nOGPbWiDS@thinkstation>
References: <20260907183340.1446132-1-kirill@shutemov.name>
 <ap_Tjt5vxal-B8DP@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap_Tjt5vxal-B8DP@gremlin>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7DA1018000A
X-Stat-Signature: buda87j5wzjmobwxwwka8c9h1m3q8ncm
X-Rspam-User: 
X-HE-Tag: 1788872947-41678
X-HE-Meta: U2FsdGVkX1/fls9+yZh3a2z1q0kIrYTmS5IsgmtZo67t7XAGKxCxfYbqxhlv94BNf7jdMKIhMzsIEP6OGmz2EN08HSChfmelndKWaI0tuHel60Xu3Zex8LHNs1VQ2d9YERMg1XXHecn5NHb0kP503Rp9vTejKdfnzdK8kh+TfMecE7GuW3xIDzclcLEUy9ik0vDpRCzPqZfeNpEuON17oUzm6Cz2XGe+UkeVR6xjromB7hLVc8j0wL87dOpiXiAygZ+J1WVQWqObHopfKxndTUpMWtShOtzQUauIQ+nfzAI+5swzQd8Ivk/amcLRPRXkU2Xfrvi1tG0FGAd3YSJ1MCskyZIxl8DhmF2wHQcNhrJmxTCUauWe3Jzl06S17qpYlZHUEpgOm5TxrFuyL/u/gmXF1zosgVq+lXIWiojMNduPEyPRA48xRv2iasTPErzWQeQqJB1UDO71Dv0eXDyC+DuzLAiWCt8H8B/Od/fTns9qy6hggRmc1WwPxRtGfYpG6Di23IapJY2usq3mlPkpDqQr5lP/7MpW42WCR7r5TlQ5hvdjOvZC6ccDOz5LbiF1C2xWVCcsgkhGaoF9XaBPhavYLWqAakjHYKeT3lheHpUDS1iQEs4gS+5rWVdFmybFV5Ky4FpiU6I7s+ub+Rou3Rf4ALTT3clO/sizsm9SSUmeb54QjgmHq12pvAIIGahtpWsv3TrsJ2fJxJHnkoercv+zCqlscHa9y4caUCO0jfufrb+6IcqXWwrTf2WdiO8Ka76gJf1k4GproiwrtdejIDWjfT/v/RSF1Gfq+CAQrGZ/wqD87l9f0OkJZhjzL06ZB+kgC4PZ/s0R98b5K2J8C1oRLpgcsdXCPoKNy95S23iSbO0V3tZBMXpDzzG+U2IMKFxFA4crZr/Hm5hph5TviFh++U3KBMgmj044vM7ho8zBHGJiM6pRAzjPR6VRyulY3TvUx4sAQKrABKbtIMk
 x55SvK79
 nC/qjzleMH2ZL8+jt8SJiy38eLUJth7NjJo4Mz/gITgSaGyWU5V1G/fy+kIgswq3rJq8OfR11B1sGyRZBz8bW7ZPKmi9wO0zrOVzhnErqINHyq81FlGk6nDHUuA401PsO29iKiFr5jY2LUBCqx3h+wt6GYiiGnHF7LjyuI+UZR/GVrvNLoHyZIjhQORSK+v4RunGNbaWHrYgL/rInsWMYBFDPdMWb3kWX45KUVHkKB2JSXQV8TGlVg1c36bEe70OPoAyPCIhpFRZCmCBLsRuYintzJOOr0nDRmJKBfWW4ceY+I0fWh+M5oLHPPipXFivMgEMpUVBEcZBSGaatSK7f/CWf5dTOKX0RvdPSmOGTWMPSeIqMHgD+3bZZT4NWi1f0IXnyRXStMjSAXmdAQrIIAPRY7jqGhvAHW/2+rX+XFcConL69FP7GHCg+Bp7B2TifNDSM9Q6CElAMyTI8NnmwiiRWkn+XGH/txkO98VbqQeOYFJu94Cca75Ipo9tzjGB1VPTl0XJ3+bQIamc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 10:25:07AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Sep 07, 2026 at 07:33:40PM +0100, Kiryl Shutsemau wrote:
> > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > Assisted-by: Claude-Code:claude-fable-5-1
> 
> Note that policy has changed on Assisted-by tags so this should be:
> 
> Assisted-by: LLM

I was not aware. Thanks.

Will fix in v2.

> > +static void folio_reset_partially_mapped(struct folio *folio)
> > +{
> > +	VM_WARN_ON_FOLIO(folio_ref_count(folio), folio);
> 
> NIT: I wonder if we could have a folio_is_frozen() that'd make this
> self-documenting? As trivial as it'd be :)
> 
> If not, then a comment like:
> 
> 	/* Folio must be frozen. */
> 
> Would be helpful.

There is a series that changes how frozen is encoded and would be the
natural home for such a helper:

https://lore.kernel.org/all/bb1cb750157733f897df2e261cad3d5c42acc172@linux.dev/

The patchset seems to be stuck. Not sure what the plan there. Ilya?

I will go with the comment for v2.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

