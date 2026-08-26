Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CE90C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92E2C6B008C; Wed, 26 Aug 2026 12:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF486B0092; Wed, 26 Aug 2026 12:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5F06B0095; Wed, 26 Aug 2026 12:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 552B56B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:57:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4595680193
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:57:55 +0000 (UTC)
X-FDA: 85144027710.16.3AA4EEF
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5DBA24000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:57:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l AEQPsW";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=FWcJzcvI;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787763473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/RQVU7x/2Ow8BFt80nTwsnGflSL0G5KQoMqCALTqgw=;
	b=z2sbAGcU3/4oMMJERDOznFH0xIv+NBR9S1qFUQf/AXXTaIgoDOMJP2knNj1hLS0N/qYMmx
	xcad0XmLhVC9VXcNHPPVQ/1rjf5XmZ29ZZ5YafP0IENfYtIqvJCDxTyWUE5lWOxov4+xxW
	2PwLx1kesmkEbOm0fTwcjsA9tk6sMMs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l AEQPsW";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=FWcJzcvI;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787763473;
	b=MCRggIxveaegY9qnr/9zyvONJhD/q6ckGSZBqtfpI6nleMiiMK5Hxh2nqlW+6hSS41bUhH
	htc2JkM5uromtVwIAD+Wjxf/gSW6F8ZeDI6ycvmHPxAefF+HffzMblo6FiYBneYd7oKclz
	CKdNVgsJb2QtYakvXE1HeJuSbmOXieo=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id C2A131380030;
	Wed, 26 Aug 2026 12:57:52 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 26 Aug 2026 12:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787763472; x=
	1787770672; bh=b/RQVU7x/2Ow8BFt80nTwsnGflSL0G5KQoMqCALTqgw=; b=l
	AEQPsWPGylc/rDV+icMKHCvV0frQXk7F5fjF/UWtvHS3U9fWb1ezXQP7ShieFlvj
	GRHu4wj3M0M93AcK6Fk+g0gXO/K1ggVsaQoAtUzo/X7P8nFmbU8FYPwrOSRT/f9e
	K8ehYKgucU/hhblvFh6gJVzwtpue21D8RH6qOhIP9VgSLjzBvcNWlYSd2E9GEAE/
	rptw18RRTdRcy16z9qXWzwSBFQIHkye5hOPOBUJthoVYdNZ2mKXOIK8HHDV/+KQ9
	OuS7oD7vv0OwukUNt0sbRCKWM8g3F9lA/URc0OliMRI76XOfoa10xGDMpreFOEZw
	TM0E2lfzsLh7Rj8u+H/IQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787763472; x=1787770672; bh=b/RQVU7x/2Ow8BFt80nTwsnGflSL0G5KQoM
	qCALTqgw=; b=FWcJzcvIbsh6QBt38zORnV7P0eeo8kO9WRVqoXVqib8+79FS694
	XuKDCqcuP8xSUq35/uiGv29rROwTWvnQIfT3oylh06izCKj0M3joTmPZlU47Q4Oe
	3loNfsttBTPANJ3cHFvfNXWdCw0pPQd+2JpG6RTFBc8VMAeOj1lDcOiQaCQaW3H+
	nlZGkNrwXaxWBE6U+6fuS/vhfs6O6JRCigwrHViNUdATu8xEJ0UF5Mtfj+X9E8y0
	7lFkn3SroSWUDnay32P8/uUW1sobt87f/JpREWi7wYr2NjMIEARJ4EyUuk86KUr7
	2aLV0GEJgf39oJ2X/KZqY6UwHX3Lxp+uzIw==
X-ME-Sender: <xms:DxuPak_Ack9LrPRHKaASHS2wMVcpgG-689x44Ryij79y7lQVrFEVtA>
    <xme:DxuPavBx2WNCktSwtgXC0SxfLbBEckvRxdJfhs7E9wmLJzgle1DLPmakYzLyGGnTR
    4WNecrHxs-j4WVhirpK9ouXZhMnQ4889TjbA439uPnzkggzixb8lw1D>
X-ME-Received: <xmr:DxuPaoxK3jWLjl2liKXaRMPDLyn8sdJrUDu7fIXrSdR4UfIMDoQI3XCIRuY>
X-ME-Proxy-Cause: dmFkZTFJ4uM7XbmV139GeFVyMoFnf31HwoxJmPLJ3DOlCGleDxaZYboTq/8g92bw2Tr80S
    wGFNepRmFciZXpZxop62rBrDkHPnv9nXc7KEvSWS/8GpVlaNgXKa6dfYTeFCYhn2wtJOiK
    307oxwUoWuxtmYGFBjteL06s8X6htc+nvVtjVU1989gEb4MnzMjTATDrZasvNpIzgTin/4
    7VGQP/85bb5l9LG5OrzuOshjFlmmTq4AsyZh9HGehMneCAhVUK6bc/pCgfQZDFR3x2TwYp
    uo425DdKwIGf1YipHDcTUXwhFZvn69o/vAlmdQD2hXiHy7vx7Q0z9WPqV/j11J2qlpRNFP
    N0s33neGxgTZZfYnhJK2+RUlWyP4sJ4EnQb1rLd7dDD7onVFIkM3Si6Mqw8hRUnRhJ3FI1
    yd7zVWfgPMI4XKuEiHVCS3DmOtq/A5sbrr3G0llk7qra0Ip8+g/oxdsmWQKj2Zz0hg4kGt
    qz4W6lHUETFMI3z0klSBqecxB0Ht3A+X6YW0W2k0UD3GMOgQgejr6TQFlAOnu6D9X0kjs6
    7RovcdajI+QYh0ZCP+e0ltkW7g35gD/7KAmPd40hfyJR3mBOnA1DxHo/tOjI4SwFyC0eXy
    3fAYexBao+lcCDPzbZXITlpM6JIGVZrdRfMCosWDlctgLcUZVs35a2aMXAMA
X-ME-Proxy: <xmx:DxuPaurxPtHNM4zlRhQUucemYoop_cPCcuSi4QG6ZU93-kiH8PsIkA>
    <xmx:DxuParx3aF35QlDHf8Ot-LSEgCyypoaVBQoro0MUdxDgW10Pjg-V_w>
    <xmx:DxuPaoP12wTEyHve1fnxqo8xoWT0M0b81Y1HMZTWOvA4YSlEo9BfPg>
    <xmx:DxuPatdNAzkwxWAxHwQ7pFsN_taxnKCvmFIevzCVIdFHV2Dv3CPCAg>
    <xmx:EBuPamdFSp7fldrFIU6gA4GT4OKDZYKJ4F5FNQFbvKSXyMShOLEGLOLt>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 12:57:50 -0400 (EDT)
Date: Wed, 26 Aug 2026 17:57:49 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, liam@infradead.org, mhocko@suse.com, 
	rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, 
	usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
	agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jannh@google.com, willy@infradead.org, pfalcato@suse.de, 
	rostedt@goodmis.org, mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 18/57] mm/collapse: install the destinations at PTE
 level
Message-ID: <ao8Yz5tqr2WVlPj5@thinkstation>
References: <20260816224609.308019-19-kirill@shutemov.name>
 <20260825064851.87309-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825064851.87309-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5DBA24000A
X-Stat-Signature: 5rfpricx8rzhgpfzmjw31a3e6gwk4of8
X-Rspam-User: 
X-HE-Tag: 1787763473-18396
X-HE-Meta: U2FsdGVkX1/veEXjb2Eoph0u8chSI5KXBZOZYh3HZweS/bCKAnu7VWF5sYpVkwb+WvAbo7gzX4GYSZu5PvUVDjrXW3z8Rc+oTuMMrDQb1COtQr7heR+IHQ8VG/5McCKnGLlQpUWnuVKRYMIDu4hqnJ3si2BetzXWZdWbrKTF/hYGkWMrqdiYoHAZGyskl9RY1RYFwd3xHaeQZClVsojz8LeJXlcdvUImAz0+zR58H37kYu9MajcqsiFQJTpHnWr8U6MaU0K9Pth9lOs221YLsSwKi1XFx7InQPIx0ehIDBjJJIpEk3rv/d39funYctqZxnJX3c1SGwuYNw6i6cBI7akt/rf8ebzUNbYGSGLLl9kC8Q/ARJDCSp32JOeTeLMG0es9Ti8xWe9nIuVe8NXdV+K7NuRfXMTdcQc9zEzve6Nmr5mHCrEthEZG4gkHjznmSG/4fkGEIgX1ysrjm0zIvK3GgqojOwBYQGqaZXiqfshUDY5JAR3f4kiK8i0XycxeK8EKBGy8TpI2ZiEEkb/TzmKDk3Rger5yDghVA55bQoJ0rG5LbbQWSrvXYu0gx4eMZiuWIotHvCamATvT3OA1W20mB7xGj14dtkFdL08S21XckYbXqTu2bsSiFqOR08BXulkObNsYkF2+dRM0p1w95Hm7/esR2EHXUo5Xqy8XNuHQaQ3/9FYy24ZbC1vpRa8TUFSS6Pqe+SmidA342giV9LHGBGiZiO+xMIXwbHDpxQhmWVGhJgvnXpKjbRG9CDyQXFrLOb8tk4fiCqz+qeWcx/G1XjuaRXmm+4TCOA4SdVCbjQFqdQxyu8xpsCXbG7WF19MSGphJysN9VXmcQFUmLUJw/EOeT7H4Ve6WmJH5DCntAr4JXLqw5MbomP4oACWjq984H6UdAAWxho1XCgezVqhUTYaMEYw5cxLySFvs961kp4mB6f41u2Osmvfdl6Z6RiSVOAwCvRn0WI/ob21
 /wiSia/b
 ML3YnYWNGgsXzduwkDtOrCfCAUO9cscGhJVO6AUrnQVV04vUGmZ/97EdWH/SVSR448bZTPSR/ajXCdL/FjQUm1l3OdohSO8pgiEfcmP6rplFu0Pim/kXWvFqt5LVluEfJn73a4Qoc+XVfdvFcl2tpAhAx7xx+6DtEtp6Azp9l0DaOvxptHyBhKyfu4zd5gcyTc8K4ki4868tEsXOyqxzETuujmMi4HF6Gc1xwos/lfe0WnmzS0d2aveHdCbnzoUWCjOnTaYWtVAdTBn+Yv9AXOkVndZ9m87JArWKSpPPhJPG2qyM9Fa1TyBn/ekWknm/ExpNyry8zo26L2gK5oj07FkjnDz+31K8+di3Q8YYP8gQV2OmkUVSbOBd7oGcWTpe22eaaXsUiz+GYvozSsQaOaDw7h+zFY+hDtuBuwCkxySzwZqIeD5RviNHJMxXlIb5pGNkV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 02:48:51PM +0800, Lance Yang wrote:
> 
> On Sun, Aug 16, 2026 at 11:45:30PM +0100, Kiryl Shutsemau wrote:
> >+		/* Slots with no source gain anon memory that no zap accounted */
> >+		if (nr_populated)
> >+			add_mm_counter(mm, MM_ANONPAGES, nr_populated);
> 
> Well ... KSM zero-page accounting gets out of sync here.

True. Thanks for catching this!

> I was thinking of something like this:

Your code looks correct to me. I will take the collapse_abort_candidate()
hunk as is.

The install side I will organize slightly differently: a
collapse_account_install() that does the MM_ANONPAGES accounting in
addition to the KSM stuff, called from both install paths.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

