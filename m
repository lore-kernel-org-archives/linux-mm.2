Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9686BC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B038B6B009E; Mon,  7 Sep 2026 06:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADB9D6B009F; Mon,  7 Sep 2026 06:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F10B6B00A0; Mon,  7 Sep 2026 06:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 749126B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:35:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04E52160108
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:35:16 +0000 (UTC)
X-FDA: 85186609074.07.B86B839
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf04.hostedemail.com (Postfix) with ESMTP id 195F240004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:35:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="b 1uah6a";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=FAi5ogCV;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788777315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ImLko0Vy0Vqaouw2yrFcv4DJIAkzPp3+Ge+yup0WtWg=;
	b=wXCm1VvuvhqxWLFITW5N9nO5jldiGSYgtmvJPGu0n04mza8r35g9BqUKUsAPF5QnxnEZWj
	opk69PyV78N9xHhGS6AlYqovL5NxXy9hfseIQO94KcMix8QvXfWflJB2XtugIHpkYqL20f
	//9xZ2XckAbO2982nrCR08YtH4hBFr0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788777315;
	b=w2I/8xU6f5HmK2RIQJlMcDz7yAWEKQHQ3Ssc+hXbDkZ38xjeFyuwzJ2euN8300aXKMqit5
	xuC+VAnYn26bWGRpgSCUjqQBOcJoeCfD1Z5pR3g3lrZXm0c0yj5z6KNLUbEW8jMeaoxKrV
	bHrG3KTMtYKsYZqwaf0p9gRzVaxBSTU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="b 1uah6a";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=FAi5ogCV;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 9A685EC00C0;
	Mon,  7 Sep 2026 06:35:14 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 07 Sep 2026 06:35:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788777314; x=
	1788863714; bh=ImLko0Vy0Vqaouw2yrFcv4DJIAkzPp3+Ge+yup0WtWg=; b=b
	1uah6aUNicvt+3rBBTJ806TtNgJuWYqZQPO9VxBm3TIa+yJv+714JFutj99d6sHN
	srBTlFpK2mIBR06bCnzG+8dh4WRtK73TyS90lO9Se3yrP6kja7AdzZ09zc3FzbLP
	XjVXow9u6TWSrjlco+zjSs38Dzw3/Bcx7HK1qcpWMLzFsKcOWj8YYyao5sl34Dyc
	bCPDUIDeUen8BMUzkxwu7ckkz3/nAx1JK1d8gmHKRlx3ftFKqUH+KkPKWqU1BrNr
	DVzS8eVXT/vKMnwHWLrbMq0Cz9VZehW46tlrnuPvN0SHzID+OINAVnXdNYRub6c/
	wijuMiLQ4T/0ZTMupzjKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788777314; x=1788863714; bh=ImLko0Vy0Vqaouw2yrFcv4DJIAkzPp3+Ge+
	yup0WtWg=; b=FAi5ogCVP314cbX84SzUSg3F5ZOyhJdX8Bto0z8pxyq1h976ysJ
	pz1EtrMXecqCyQKobwUiO7po9mkjLnJGVVAIAbX58whNg7iRwf41zebF/VGB+kip
	3AF0kkJT3PNSmIg2yGs5c6UkCbvIBXkGx31fQNTt5mmJeXeKu+riQgsJeYSeZNlL
	OSrIO6+ecNnuozXqLqbCot/5xW54a0KtbbPRdeLyfaU8dQHNzynPFYtIdVIG32mY
	M3Jigs+IX5/2QKzwwla2zjZlZyNAakZIwFliODoRfAezXwpB/hNeZydwI/dA1rh1
	GBM77Bx6Kr4ZJze7U83pTZmURlGFomKU+Fg==
X-ME-Sender: <xms:YZOeauEfWUtOlRt5oAnnZXMa3QwsI1kqeeFx06C5cBcAXKJUf2MEXA>
    <xme:YZOeas9zovbf4ih4igYBzd8eA7dm4alW1C3ik8TpS6Amo9h1yzpHv92b5axNPuTlr
    TunrZuB5wuSu-orKQpYkLpijBgoPxaA1V7SnzUukrHF66yaX9zBRpI>
X-ME-Received: <xmr:YZOeavjaQwsLfPP4pawxD2ciI1T-3wNE58MqDovEcGNDex8j0p23SFO24kw>
X-ME-Proxy-Cause: dmFkZTGJUNMrCEZ9rdNsZ6eSnav3TPgdBrPIG14gk5KcPfoZCixrZC7VxjQ3pqAPd3r9yJ
    QdQAhzxAWfnHG6wfV296DnJZZhqxU0gGlS2hFKQ+ps2WoFi2kstAw+HPdHqaYbXqXyVRE6
    KZITkv1ptpZzUXTByv/e0S/97HV2QOTiSsagH+ARdQuZ8mr5J6LGmK2kxQsd4FX4JAM/mv
    V+jJEBYxqYRsaGPSlgIzj1+quAbi1oiOhifDQ+MBeRxPkjgG53U6XiiDZIbiV9UFPoztmA
    sxOFh8uJQ/KUlJq1PEmSmL/F3b/y+ZK62njUVBMO9TcbvmF/V7VeEYwnZcm0T60SBxrJWh
    XhEfkrIqIWnILQYzgGubbi3FEPtCMd/M0nDHwZ7U4d4XlzB6v0D6zT3vDLLwY2DqAFASUb
    wJuH8Zg31WQXPqPqrxvjAqMuI81doSaPYdAhbD5QOHBYFcsVdbFg/4iktoPOMatwh3QMaw
    P9/YXv+JKPvqGCgLfxFWxRx1w/EJpFenPkZ4EtdnCV0TS8gcjJ/d7o1vytPEBC5P1tBrC7
    k3QqwynGoXE7ZyOVhVuFBoUs94Fzvwim23vaC3LD1dsHsrwwnAHmPrUJBrcmfgIg4uiak4
    kSmcdvqCji7RNeLgaLaKbSkUy025eEuoeUftzMU8RgQibxfknCrXStYkRNJg
X-ME-Proxy: <xmx:YZOeagTYZoFmMnXYxKyxTc9WR9Q-p9sBWsgBDO1vLeWP-BBdfR6TmA>
    <xmx:YZOeasBJdSRFIG5fldVmtJS-FyoE3KSf_ofosOSAbNEJgSv_mbSWkQ>
    <xmx:YZOeaq9nwka9V-qH5dzQixLee9JALigwhvP90aYhgtbalpQ8RGRZfQ>
    <xmx:YZOeam2qHyzLK-MiZHbJFNLZwx8ykJzIMrKSA55w2DUb8-q4SawlPA>
    <xmx:YpOeapqcGNIbYPBLwAx-y5_559HsuR6YW8H47ZpP0AEn-Y-uQ9Vg9iGy>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Sep 2026 06:35:12 -0400 (EDT)
Date: Mon, 7 Sep 2026 11:35:11 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 03/12] mm/khugepaged: rename mthp_present_ptes bitmap to
 eligible_ptes
Message-ID: <ap6SjrGDia7AfB7k@thinkstation>
References: <cover.1788533997.git.kas@kernel.org>
 <aeed00c71bab856afb18c12c8e9b904f82185942.1788533997.git.kas@kernel.org>
 <273e167f-32b7-49f0-8589-5883a4ec2d99@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <273e167f-32b7-49f0-8589-5883a4ec2d99@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 195F240004
X-Stat-Signature: 65pc94791y5jeko1nfaof69g4suebni7
X-HE-Tag: 1788777314-9124
X-HE-Meta: U2FsdGVkX1/6QykcpeEF0qF5RYb/CqiERPwcbA+cYc7wNl2MYxNQ4jCKOMF91vATcmFE00M362+EBIlDxUQCA0yObi+hpdcZCQwTocUpEADMm2v3nsjcLN4dvmLsOQgUmDqGOm/xHs+5QXwmGd2zTX4UVavaclGRacD4514xgfhCr6W1nyeDffimjGvGSicWPmkaztsqGIKOJ7j5jdXYmQkgBbMCOA7UzhjRnEcDkiHMOJZ5XG1FrsbreZGpIVzyKDdD+/oIdfzA1FBjvjU9L8rjmMKDZI2f6oDs9tjMwDYAFGrnDPrdyWi5B4IH/0Fy8pWpCMEMrfnE7y4c2Uot3ZcXwayjPHAtZUy/Oipm+xFdRp+CYnaN4RSiRfvzdawdxAsNdZm14aozclAq2KrcNExvtGPWQ5r1XE08h+hzvx8v392+Yjhz05yew8YxJFQYUQsBG4p4T8i6qlenwEOUXkuzQSKoVefVzsME4thMrJJ2vkVEkLmm2HVozjQ6vTcvfsnfvCCBqAm7Bah9gTQUsx4qMCwJ0FypaR2xq5r0CdnIPmpVZZYGHINp0PHRE9JOWo5BB4mSVKWq6O3bfayRhsbY4dVo7d6MioPX5aFajhPOiKa/TRvRrZKlpYmJcvAN2ijhPABCh3D2fdI7BxSLh5Ax5x10KTDCKxwveks5ZRWjfJ0Nd38ZG7mwI+UP+EBDH8gsSr4ttWhj8o9oRNwp7usvRIDykpoPjxf817ij3zRbC74W5ynFHJwWL2cK0h5kMX3mmox3ekxMXF1mSG37iz2BUy0OcOYdbkhK3qpr8XxvI0mVK3+PA/H25Uw3mceAmf19+y2MUWqsAVIyNKnqcvnx6PERhDrzNlZPDIEzz4kjsYAV+7WcvtIW2z5efVk0IU7O02YogGkqd5t3+UXT93fABvO5X6PYftAPvf+vsb7zdkrIC5Izg1MYNIGj5qckJ7yO8hZnwJPyMW0gyLh
 /Uz1E+Xy
 narKz6/ibfzJnoqSHCNSkayqUBJKIpEMTwuqH2mKeNC5TZKw/6sdpRa2fxUberHddw2upD7iiwUWKytmq6G7QxDx9GqJqNn4LCkIrU+PAjQ8+aqwrBGZznscoeZaDhGpsTsD5cME4guiTZT1MoFnTo8oDd9PbK3dgjyG24JQd9kgwkEfVCJjuIxU2CwHcDnd86wXMvPmyVaRZdMzRMw6v2S84kdRTHBqUFqkgETh5pTYhZmBGnLeIi4GnPrV6cTeltLs7OUQYmEB0H7imFgTV0hfBvFBXUcjKzipQVDmJi6niJ25XUhJ8uFSRqLYjRKBLgH62yIie5sMHiHsUBkCiIWbUYVOo3leo4cpSvJeybrHEe2YCXICFmFRbTk6ypgpnwUbEM5sZB6CY3CfUtOh9SZj6/rPpG0BVScywY/g2/5Us/phUwJBQIufy4MKx/2VIxMxwVsgppLCVc4yNox8erWT9i58mNDgHihJ7OxNOcIE+BwIKT7EDZ2VjEcQQ/Bf3YY6aSdNCDQTCqEk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 03:54:19PM +0800, Baolin Wang wrote:
> Should also update the following comments: s/occupied/accepted as a collapse
> source ?

Yes.  v2 renames nr_occupied_ptes to nr_eligible_ptes as Zi asked and
rewrites that paragraph in the same terms, so the comment, the bitmap
and the count all say eligible.

> "
>  * For each of these, we determine how many PTE entries are occupied in the
>  * range of PTE entries we propose to collapse, then we compare this to a
>  * threshold number of PTE entries which would need to be occupied for a
>  * collapse to be permitted at that order (accounting for max_ptes_none).
> "
> 
> With that and Zi's comments addressed,
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Thanks you, both.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

