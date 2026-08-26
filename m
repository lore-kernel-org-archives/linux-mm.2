Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 483F6C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071416B008C; Wed, 26 Aug 2026 08:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022956B0092; Wed, 26 Aug 2026 08:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79F76B0095; Wed, 26 Aug 2026 08:04:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4D186B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:04:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B6B5A036A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:04:38 +0000 (UTC)
X-FDA: 85143288636.10.037CA8E
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3FE9D40010
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:04:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="N Ic52T8";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AHOiTX7k;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787745876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzGx8XU/Zb9y0rwHGsJjP5RQ/DyXPYcvJQsbfsNfH1M=;
	b=rp/UBb/Lb9YpTBuhETCc8EJTVhKet3z+rsHbd0U0Sn78lgmeV4mey1Ov+soNx0gOApyIjN
	wn1XtqsS31DI2TW4n4UloN7s2TSLTiBoM/nCMDkiL9UNEqO7t88WpACjcYuRWcL5lVtkZc
	DTYAAgD0iIsvqv/RZGTV7LRi99/az8k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787745876;
	b=AaI2M9PC9w7GV4QcUp+yA5hK4DQY6r/8RkAOptprbrJ4cFhl8m7w20M+lrxFDsjG0Vay5q
	fW+6nFqAHeHRLwajcVpzlqBBcmO3G0WE4J3JBd1QRIk0l/rzEbky0UVmCq1otZzK6qHVxJ
	m2GehC/G5ROTcw4NyGbrYbr+p+k0aYg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="N Ic52T8";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AHOiTX7k;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 955C41400098;
	Wed, 26 Aug 2026 08:04:35 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 26 Aug 2026 08:04:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787745875; x=
	1787832275; bh=mzGx8XU/Zb9y0rwHGsJjP5RQ/DyXPYcvJQsbfsNfH1M=; b=N
	Ic52T8rogd3+LQVpiihprD6MenoQoiweO8cqR3/VnhyZWn7r0SK2oWcdICwtykYF
	DAdDPlM69S0G8HtFhuDX1HB8Mkna/TOzhWjPMd6HOgPEUzlyw2D55fiTxYCmFVLU
	Fk5tWW3zmPUs2bDedm7t379cNttcDdbzHOhJ/m6l837YTr86D6iGxIDR+G5iL04W
	FPGoUsdpksGXRvPpHEOwenlzpwYf5UAOXJF4muigKxIjXWZxLCJ6C53NUhrW/Xyf
	TiZwinL+IhuqOWBkBkrbpzZIfdEFy/hUCevkmE/8rglb6OYoLmdXfRpPbxw5FATe
	COdZWpA1yGsssjjA+xr5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787745875; x=1787832275; bh=mzGx8XU/Zb9y0rwHGsJjP5RQ/DyXPYcvJQs
	bfsNfH1M=; b=AHOiTX7kMU/wFMBDUqaI8KP2GM94iHw+g04gwlVJOe3+jeoORIu
	wGrGRnlrgRynS3PmC8hXkcCr/rmvbVDSCx9fDOdKO7ExjwBY5nQzArcZnANuoEJM
	rVQOK1vdfNMkDkZExkGYdP5A9vUmJgqXuxtDiJ4UCSy8Dj0LXKFo+t1j/dTQqpM9
	zNe40Jkp905syGPOa6ksBSOiYaz/1r44OVpB4tN31T7z30IpCrwo5fgxqw+tA0Pt
	1EaeME0Q1Y3OHnXqfJwmMba4XJEPZoUsxQcseicTg5gt/WZTkSwsm3Z28WLTt6ew
	E+3Ae4ylyuArxRDa/yOXOH5cvNjY+3CSCQg==
X-ME-Sender: <xms:UtaOanwP03jS72WpEvYdhU2M3sKm-sSCnxFqcjpaeSUxWkY3q0aUww>
    <xme:UtaOamxXDpg_UumB4fBNI_LwNtr-cVh87fET9eREpABl8Ucl4TCXCaDGwaWRjrlmD
    voUQ4Lkz_syCh-WvJOLkPa-h-iPJBVoDlucPI8pd0Kl6K7HIzdfgw>
X-ME-Received: <xmr:UtaOanZX2mm_WoofYNscAlXdghVaph84EE-bk-bWiB5Y2KVccoayDUOaeDo>
X-ME-Proxy-Cause: dmFkZTGaDSKkUm0bE0bL6Wmom+eIuygXvU7ds0QHNuYpR+VGQom2lcF81zbRwOMA441d+a
    bPc+WnC0WBrnJXdQuimTvciOyud0siMW76OxtZX+qXX9JO3xt6/5f6fGvGgViO4DxyfX2u
    fpEA97amC3rjxqu/OIxVog+CMQCrVVKr87A1vtcsckuxeMgX5ZqqTGnJjAWJ2oX78mXQS8
    xjhtBR+/Ugka/oGNIOOHQS7xSTwzT5cqlFZ7v3L8sc+wkxvAoRx+hIwny73kKuUJRQJYHX
    Y1dBtAV6m6y5My1C/MM1YOPMIIky1gj/kvxDosbOnxH3DeahI3ul7TfEWxkA2Ar+zvL7Mm
    YOkrkka6KnkJ/w1LEHBczaAsba8N0dgoJgAMJFIROSoE2wwRE9zvqKgtW4evRu+IrWOQ8z
    e8Z5C0ISGUfrBqpcAg9uV7HbDVbzg75AlFuT9jt181LYLGJW6AP887CfXFM41+VYFSP+Qc
    6e4wPgkuuJOFRB2eHbLsV186ZxMeBR5ZZERxrl4rzIjxrrEIba1mhI5Z1FXhPjkr282Ow7
    IH+qlgQFXTif+WMUTPEK9mLf6W4XaZ1Mq6d/V2U7VpIuemhz5UFfzFyUwvCJTBgH8jSPgA
    h2rzdr5vVAjzkSCHa5tc5ZpLYdozYI+Tw8mtV3ITQqi3VyeT4fSh17VLguLQ
X-ME-Proxy: <xmx:UtaOavlKBIF1WV7dv1vFn85dYew-SgsuiQoO37-JOWyCYerkvTTa6g>
    <xmx:UtaOakGDadNpDplLRDbygMzuwTC9pxr4hj0v857G17F9iLLY_7OXsg>
    <xmx:UtaOauib6GqVPwntMrTG06J5XVelPgvu2N14XkwckbyZ1vVmg8IYWg>
    <xmx:UtaOaum7t0-x2fRceqmuFFT1iHa8zItESPcGc4mR-7UpFFzo1FkyyA>
    <xmx:U9aOaudvRDi7kkRgvUEIOweAKYfwydJNeWkNxYq98GLp8rGTXdYsH14I>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 08:04:33 -0400 (EDT)
Date: Wed, 26 Aug 2026 13:04:32 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
Message-ID: <ao7S-wjzcMIgM3s-@thinkstation>
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
X-Stat-Signature: yfsnry8a7bxycdi9rtw1pszrqqr7shyw
X-Rspamd-Queue-Id: 3FE9D40010
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787745876-273195
X-HE-Meta: U2FsdGVkX1//2e9OIrDEldQwI/oueWpsszGPM9SsstTtir28hvRNBdXb7DgdDMFtsGecMQho4wUxkGhwNCjHWVKSA1wERaPqBf7l/RJs9l3AGP5+RsBk7R5wP3L9y1wfy/dWrFnxWfrWOmc4WP+qT/s8jW2IjpiwZEV0jKbw3cQz0kx9QTA35YSWxIAdPjttw+Y0pJdNUJjUPFqhMdhZL808L9Hn/tBHaC8Yhx6WFuXTmzRVht19NNl2neYRloYhCnmPiMIkehiEXIYKGMuox1689lF1+m6YaIDB3gzpnLxUi2HHy/utB6PdnyOXU8OAM4zo7zlG7ro/GOSHEdppLvAuRpYZAoJZd1MArU6lgGXVqYRUJsQvUNAxg7Ekn5msNon4PctiST35kcdNJEJAY7EirUDNqn+z1gQtKNUQkSVFiTYQwafTW/mLVaTDPVqf6B9Jm0yV7zHTKbNETVNx8sKYtbNgPmfXzzpwKXAuBsd8v4L+D57vN6SZQoR6zItVJ82xYJkZ9cjfnLVroRuh3ps9SZNb4audzZAsE9K2pzzKONuYANcepEzDiN1k+rl+bj1Zw7U/kazGzmtK5d8H+fZFA7NCO8ZkMvVq5Nl95Q9kwIxZpCzXdj6QxLP+FgjsGsFUsEjgpFsIIYRLis8/RVz7/IUf4DPpqrjAcD/kA2Hf1zCtnRfF+naZS/HZ3QM2rXGz50AuKdrcoQd3Lhk0bClp/+mmDcwAcBUZGxJgzGRt9/H0hz2KGWvTK1RTW9bW4HoYW5LR0pOMCIzmHVq+pX2XPSfZF35CJRJPZMGGzkrbMmREu4ktS2habYUrQU244+Kt1xARW3+2TLAr+4YLjal6e6WyKO47IVMghIYQLG5tSMRCzjdMJJiiP23UJNkO5jE4DPeDg0ajTDr1IqBDKXetAgIvrGjfdEmmty6Mthff2R3TquvSPdxzXwlB7eV6KaLEd4tSuTBwhOX6pk8
 7dFeo8Np
 CDGNh7smkgzt9hZow3gCXvi+K8EHgrW/eRfFiHf/QJDMT+EZYnprTLBpUNz6ZL9MtRX+rvwACdWHB8lP0ZaU1ZWBU4TI9rD3Y/sP2kZAXQRjw9R9H0a6NPUDTj7PyaR+q+M6x7JSLMa4u/iz7SmmIkOp5UIVOFO59JHmVi5U0zJo9CBsqz+V1cAGi1LPFi6Fa6wJK5wfld/3V3SPZK4DvmCvSZpLR2AyjQEh+WlOHLYUgYtHYL3Xr8N+tJmp2LGaZu4go9fgDBQXr1RSIiwxmcHkVmB6SEJc6LdhH75tqO1K1H5XzRtewJImPNxR+qJcGwZMKHWDsv5wisbmwlxEdEd/TbEhYjkByi0JBdD81O/VQa1lhbP1S9YX7cTGWUuXkLR7LqOsuq8FXy+i8D+nOO3m1Zv1V8s2FHfvfce2qh+h2PFzrPnG/IOiecpUURCg3Tgur
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 10:56:39AM +0100, Lorenzo Stoakes (ARM) wrote:
> Unfortunately my workload is such that I simply no longer have the time to
> give THP the focus that it deserves.

Ouch.

I guess my 57-patch series did help the situation :/ Sorry about that.

It would be only fair if I share review load for THP. I will try to be
more active on review.

David, I can send patch if you are interested in my R:. I know thing or
two about THP and can be useful there.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

