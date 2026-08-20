Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53A58C5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 11:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1966B0095; Thu, 20 Aug 2026 07:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8E56B009B; Thu, 20 Aug 2026 07:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7F96B009D; Thu, 20 Aug 2026 07:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05ECA6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:03:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75ED41606FE
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:03:24 +0000 (UTC)
X-FDA: 85121361528.04.5B29B3A
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf16.hostedemail.com (Postfix) with ESMTP id 73E62180003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:03:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="h 4v6ksq";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=NyRnjdYU;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787223802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Huxg0qnn8fJu2M90AV87+SuAfu8Ucyiqn+uzaPm0SrQ=;
	b=Oyz1RxTTTK1u91Xyfgcq2wBfaILecUlh8uA5/5nomNc2POr9vKa5M5rDctNd3LyDK5VMHb
	Yd91gSu/pKSXEej44IsJdcKjgTjbvFT3FzvuUXdEAB8w3yhcpsm/R848pyx/CDsQ+HEjcd
	LF5r7xzU5mW5vggSG/Rtm4Qc/g8I+jk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="h 4v6ksq";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=NyRnjdYU;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787223802;
	b=IPcCL3iXrlrDcoLnbSI0S36YlTREGUCkzuZMlYfeu5ywZKas9eUsrDYjyNYIfyHNEDAUEs
	mBzuzHw1CUXimI+dMWRJ3O0KU2FRGV5fsPjqPI3gnY9ouj0iPg60xZUKULAj3UeA6fcQPc
	lMHMlQbOOeYe44qWPgMhrhp9fuc/ZUk=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 475A81300412;
	Thu, 20 Aug 2026 07:03:20 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 20 Aug 2026 07:03:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1787223800; x=
	1787231000; bh=Huxg0qnn8fJu2M90AV87+SuAfu8Ucyiqn+uzaPm0SrQ=; b=h
	4v6ksqINBbc34I4HOLT3AbOu32/sKqYADiwHGzlD98l13WoAINBksGpyeoXXdD5f
	UoqREfMddBIi975ert0Mr0i78QrK/e3xq7ECPR1JJuZBUY6pG1blQSfmtWDXavDV
	1LEeanH6BTFYYsV/MFzYM2d6GD7CL214O4VUCGkEQQRwgh25GeZQPzGCVpJf9BFj
	xRMrug9FwiWMvLy8W1nqPSlHBX2i92C8NQlJX35z6o3QydrSjCtIRT+eCsYyEYmN
	Ip7k5Ri1LtzMcllkgVp6lZ29VyKIwr95MA5RNBuviG/P+AonvEY98qIp+ixk2t1k
	YDYBHhJoKwzfuBSNfKtDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787223800; x=1787231000; bh=Huxg0qnn8fJu2M90AV87+SuAfu8Ucyiqn+u
	zaPm0SrQ=; b=NyRnjdYUysVmvUR4O7aJctJHDmO840NF+AWUeFSZS+sNRLSS5me
	oz0KWOjglgTalpUzbPZzKVK/mMRFZ5JVYsUW5sKc8ZCrrx5Eso8eDGVRLB1jSxSj
	DmAQ0kHFZ/jJzkWTRLsnOODFagmetK2ZKkbLWCtnVQriDq1nB9tOQIIuehYSXM4U
	rCYhTeVACwgvYa5spo+lakIKuRNkaQASaDZygF2TB0ItCbfwdx6v3xiTeK566iPR
	kViOLi1IrVuxkou8bifuQOMm2kf9/dw/RN4SkfhzZSxy7AtJlNyPGxQNyQOxM1Lj
	AH1rOcMYI4fgDfliD2GAB/FSFzL9CvUkA/w==
X-ME-Sender: <xms:9t6GaocOyZ4Kcrw-dfXQvd3qt0Rn7dG1dtEEupg03sdidovPwIUm8A>
    <xme:9t6GaqrxLtRyapyzx8x5aliQL-pUuuqZ_1ZVAYdZ4wEp8R_cnCC4TjLYh8U9s4BjA
    epx9HZVQP4x4-IEQ-3ze9SC9Obm0E-FkbNM2-3aeZDuRbk1CwpAXLY>
X-ME-Received: <xmr:9t6Gaq83NmZfRE5FXFHy56tn6PaN40rXnZyQzOQ_rLJj9QlTSY-GZg6djJc>
X-ME-Proxy-Cause: dmFkZTGi6rYBThRI+gPyGqdk0gFejnshTs0jgIzYkHn1s57eIU7ysIOO/3U0Ycz+WDPRsG
    Xg6Mi4zSwoYf+kByU9Z601ezWYRZ7CD5oBc3a8TT1GxISzvrIVbtQy07pVJjH6pMRKazKM
    T5KmOo0T0kSDTIayR5gbXkxp/HgxutAVUB864oI+T4m9++yknzJUqkDAQxi5ZSDTnoe+PA
    5sTANMdPYnapL/OG2KdEQdahdAUgDEnYurAINXjN7w1+/1He/I8pHReJNLNA+1mrtA7nh9
    nApoJG+kju/satpHLA3UpprOXSmphHqB+XSj2l8+kJeLRXw6jQA2FjYZB1zzWUVtm4xmb4
    kB0FhUDB+xl5IWAscGtOZYxq406x1djv4HpZ/5JsWMUiVQs96OfPkqP7yKWBEUf345lKr4
    LjO4lpPzLKRDR/9Ft6wJYaBzdtr0VHuhPc09+qElWx7UTEi3oipPhURF+SNJpbux/wwdYX
    BsY/QW08vXBu2VejLT6uNZqYpDCgZxqCHkvC4x3OYQMCsJoAEK8g5hihi2mGtNuVCVlc6Q
    fTk0GKDiWw6jxYcFM8RMYeK7FV3KECjBemKaxPwQgfD4o590POwtB4foQvRiQwOXC/dcBR
    Kw91DvwHqEHRZOFpia4ShePdJqP0IN++0iZI64Ou1VEw6j0yRbFXpue5udOw
X-ME-Proxy: <xmx:9t6Gat8WHH_2XHJPtGOHMMmwD0oiKJVsMGaGWdtthGC2QIinKr7vSQ>
    <xmx:9t6GakGDpdxRrNHyerT3FWlJFNQAE0hyiGtm-WfW0Csdx1O19cZVvA>
    <xmx:9t6GaseD3MznHKp_gnNGiUzq72B66nmj32qekJgWwE_o1gyLK3bexg>
    <xmx:9t6GajL4OmDCNkH7xMCXtvIO-G8bi9hyuMwdHoESCM5nhjci_uKgtg>
    <xmx:-N6Gapksungxu3LqO7qD0bxG2JX_M0hlsf96JbCsppTXk_gujFucI2EO>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Aug 2026 07:03:17 -0400 (EDT)
Date: Thu, 20 Aug 2026 12:03:16 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jannh@google.com, willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, 
	mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 02/57] mm: add pte_none_or_zero()
Message-ID: <aobe4JwweJ0DZV0X@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-3-kirill@shutemov.name>
 <4e8e208c-3aa4-4060-b0a2-499bc76d19fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e8e208c-3aa4-4060-b0a2-499bc76d19fa@kernel.org>
X-Stat-Signature: 3nkm87pqbyyc4i9bub8kyarz3bmdba3c
X-Rspamd-Queue-Id: 73E62180003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787223802-904056
X-HE-Meta: U2FsdGVkX1/7tg4h+eTWeQTrdiEF8CVPK6buIVsVWO+36Cs3li7RKFBZYxnJyxcbmR3rsNcpofLh/STm4r3SImYfSbLipTeVxd6Qj8225RABipBVQ6ASBeBrL0oNY4pvgpKwI8vua8LhNYda2atTDhRyvA2ySlbKHB/4FM7TgDYV9XiwT6VhQ7e7aRfTDGgHGJiqGYE4YIkT4hJ9h8H8+x5U8yAsRlHu1Z/x2eDsALGyi62Mj32mhY4gSLBA/Co45SUybmkm4TSxYzQCZoLoAMb4YHpt/XMylhshHrf1KIrEXm8uLLkoywbZfkANpSNPj1jTW4E8j54118YauPOV1XVdWlAAMpT8m3Y92/ieIznQLpp+MIw2yiEpUaY2uTzGjArNTq6BQpfaIK9WhtP3Lal9kYRAbI38svNk1iTExzF0W1FU+5DmZxNfbUW+yiI2UwxgwYLgBeEoZfEVJ1tSpfG5CryOaa5cgk9VgmpWlVQjzMJGZybWq4jwY/sCvFlEqP0pJAWzW1Ct9jAaceW8LROgQwMhrL7ISwYgI4oOObgyBHENGJ3Jy18uE2zVfjlwQSnywJ2ZEs/Mmfzx49KMfFrPCc4tmcdSh4Ga1mBHnv9Azbeb1JQ3Vd2xAHZbL4usWGersW+HkwQODw8UM0iW+UTwDm2i1FkRF7aweGxtdDC2L4V2BzEaK1ZBi0ANxCnp/MxHntWHUK5aSZhlOo5AcO0QVUUVIDaJ06zwLHCWtzqfuVZzA+PyWm3963LM5s7WWvnKplNNcf6gk0O/9XjAw6ukUSnHC4Ffr/dO2vazIMyRFsmsbkYESlOTccaSWrcfS8WM0eBF8VGV0k6GN/XBKJCNg/RkYWmyYHyySamIoKn8GcsqIZ7ORSZFHrcynIe7aGM78/DWRyjn2av6cdAsLQNfumtLvNLe1lGrWPO3IL/pwmnyMivUL06ZqKA8v4d8v13IBhMIqd/+kkCQXS6
 AzYyK8c2
 sipuETW56kQDwdkDTd0PU3mr0j1daoGaT8AMBC5fRts0AYqhkvY2MamDOtppNdO44uj+u9mkDDvd3jGXdTFDvwmkj/BKxFsc2m0Br8wnUWeY9aaqvreVMP/EQojQltJhWDP9aQQ0rflzD2xp5pN+FKtdt+FHyZAs6cMRv+YitLlQTyPLiOiS9ajcq0lWoFc/XAIZcE3JXkrykwZG5Z6HDi0l6wpiJohWhtaFw+gwqTKsUh568tNi5Ulk0ND8X0/c1kKTkXlgup/tOuIl/xJPxQWi4cqaqseeYR2taivph1j9w8IcXwQwPQzUkhGl36sJ1VPA0lztWNFUzqzdkIciXpr7KZrLLiFe/0msvgqFtWmbwT5Z2FaX2zZ3B6ZxXvPzvfOtEcsEpdXgJB8PDWVt5Ct10LuqUoVNAg753gcpnQ/Orm6khQXjjV0m9OT+f4YQM+MReMZLxD1Puo7KmLbYTEUC9zt/QELR+yabXQe5mW9LmX4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 07:57:29PM +0200, David Hildenbrand (Arm) wrote:
> And let the callers still spell both cases out.
> 
> if (pte_none(pte) || pte_is_zero_page(pte))
> 	/* Do something amazing */

Works for me.  I will drop pte_none_or_zero() and add pte_is_zero_page(),
which lines up with is_zero_page() in mm.h.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

