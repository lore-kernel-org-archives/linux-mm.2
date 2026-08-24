Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF2C5C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23C86B00A0; Mon, 24 Aug 2026 11:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3006B00A1; Mon, 24 Aug 2026 11:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE8AD6B00A2; Mon, 24 Aug 2026 11:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 96D5E6B00A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:18:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AFB91A019F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:18:14 +0000 (UTC)
X-FDA: 85136518908.28.DABF822
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf16.hostedemail.com (Postfix) with ESMTP id ACDFB18000D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:18:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="e x6lSv0";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=eXIwBBcO;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787584692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4R6k+VGQFBFgbdVkejhQOb6Te72Cxsv0t9TgFx0RFGw=;
	b=T74OA6n9Z696vZdGRtp7/R64QZM3SFEkPdxuTBGbFfSKQWWWqsNkzjqsWD7+IPUV2POF0d
	0E8+VEbFZo/4wtL3YZEUggy4sFLCY12OeC/sbObkWvj/N9TJBzIJRQMdSE2oqr4eSVPDSq
	D5iBb9pSK5EmTslsYxzhuN1/GdVbNI4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="e x6lSv0";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=eXIwBBcO;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787584692;
	b=tdBihsnjggqx5iMSwYW6aIpA+enZ1BOoYf/oCqKJvUV8G214ckJmqsyfIfneAQPRK4YNSL
	3OP51FMOIfC9f8Z/kZAEGsqpCJukW2QIrw6CgyqV6V+OrwE+0wQlanrrlXlOrkl+OZZ6gO
	xK13UBDiDOnjVEHEttP6JTAxsJIoQ20=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 1151B13800A8;
	Mon, 24 Aug 2026 11:18:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 24 Aug 2026 11:18:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787584692; x=
	1787591892; bh=4R6k+VGQFBFgbdVkejhQOb6Te72Cxsv0t9TgFx0RFGw=; b=e
	x6lSv0RmxW1dIXXOIctP4xvxwCD/6zarto4OIWdVBnvkArMCeecOEbu+y8PLQhIB
	6ponAN7LqihLnVf0N/yjdVVmCjxdCTVSLhTrkbDYsT7P6JWC7avYuFHpHrz/hSHn
	6PYGhD6sdte4V+OTTQQYjWrlhazuiOFmaROb1A0JW5KxSIqgcZnZ+1X46XFvIWSf
	qeG2kV9wWcDlMQ3Mk5EplVME2tmHumhVv5qXKeqFg+q9B8SWqNnC5mx6VHnXvDwr
	a3sNyH1Q4u6GWdyVhdr0TrTItngXZaO+NI/dPdMrhxrzV2uDhKRSRn/U8KyMjQLk
	DlACT+3bmup67zuX9IeYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787584692; x=1787591892; bh=4R6k+VGQFBFgbdVkejhQOb6Te72Cxsv0t9T
	gFx0RFGw=; b=eXIwBBcOMgrId0MhT7xGuonZzAYLQ9SBGCEPcbmcKyg9l1PzkUk
	Yhw7LwfYOeNQ6elISa2zIXf/jB/bH0y3Rj6zn413xCVqLf3peDLiSUaxPQ5KJXWD
	r2vqo4dA5UU65m7gG9hbdQ4Y3SOKm9upPbFANQ5GyZOQbVyCunTLhcLJki6/Ad8q
	o57O3cJ+hd8bSsJrVIrPWGAzFK1xn6GfzIJ8EdywOShTpsaSSxOXKvmnilp1INfo
	kWYfVXoO0vpHltlzokeyc6cIgR0L5pP2eyX/+17Xc2lhRnz7LZD7ZuLqQCox/31x
	9CFMvGSpZVwQlMdQb/lfoxB5gAzssyd++Ug==
X-ME-Sender: <xms:s2CMairB-nwOo8v6DJvtdmGxKRiGemGGci4o5LBN6GF_VGU1JHpt9g>
    <xme:s2CMahFzGh4bQvKRDKEQi9iGC0EU6fs26lowijrj2FmWk7m88PkpcmquTngXjM6cw
    z31aSdkCVQccQ0wo7UnTGeOWv8MU9Y1lXpV5fzp5d8yt9WJI8Q7Wg4C>
X-ME-Received: <xmr:s2CMaorashIvIbYmsjjdIYE91lHBLQGRHdYktoCSh_A3xNxTqkd2yopz3YM>
X-ME-Proxy-Cause: dmFkZTGrBq7uozOw7CWLzs3aCJpzeKWRqct+d+RCVU9svwkeowOaexP/k82TDyvrYpcQk3
    Q7jqJWPlENomBJKwj/jR2LArhCRXHgiq40dgP7t7yWSOXj11RJ6R1h7viiEzDizAYccCw/
    ZZmhfTuPIBJXVDZpD+V7oB8L2RMW4gJrEbS5FSpC1xcMeiyqq1Lm1GIn+t+Rk11YKQRa37
    VTVNYdzwafpHraSiE5HEeCM+qyaMII50+cfSXno6a41Sf+rt+vTA7/WfiycI5sIAkvme1A
    oAEOSQdFJZaPv7bp+4GSqCfjwHeGbUC2JmWAg1LPa+qv7hN7JdpdZaOlE2yR99CWq0Azkg
    Knn6habbA0x6s63gF1opIJmbmyiW/LoR0hd/CKbJM2F/hH1HBP5Nvn3iReUEKBDROVKZkv
    YhvYR6nNedejhLKFH7OXblMi0XMiyKZIecPj7KRo8Pwqc2NKhwFC0FyRIn3RCe/9JOy2Qg
    CNLQuqKyntEFDhuUlUDVH5syxGie4whYjGqUI8GnO4zYCfktmPd1GsTjMveEA1f3/oXabY
    8CYVaEo0wFrLj0XhrTrORL5xDUQ8lw61cgQsRcjswWbiisdbWsRo8XgzjFXfXeZQ5l5iF1
    fJPYCmAz3qD2mRZGL555Yz9+JwFG5ZZWvIdxyYUKAnYnARbiB5bRvHKmTsNg
X-ME-Proxy: <xmx:s2CMah4wYvZbj6R7EJ9YPrG4Gp-gGKzx-uIf6swKk5TBraFQoPuyuQ>
    <xmx:s2CMahTdQIhtSGFldSDJqf7wpi646AJCYPwHvTPJS5j2d1oiYsoKvw>
    <xmx:s2CMap5UOTk7_UI21zazLuvUr0qDgnzTCN-fRMCGx8G4kWtB0CcSYw>
    <xmx:s2CMar0Nld_nG-oHqzposRto5TvAcbGhUiHU1V9Bl8TnKuufIyhKyQ>
    <xmx:tGCMatihjfbFNlvOfqG59HofWvaw06MKJ8-znghXGqljSc1SlI8xCh4c>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 11:18:10 -0400 (EDT)
Date: Mon, 24 Aug 2026 16:18:09 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, nico.pache@linux.dev, baolin.wang@linux.alibaba.com, 
	baohua@kernel.org, dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
	liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, 
	ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 03/57] mm/collapse: add collapse.h for the shared
 collapse state
Message-ID: <aoxe92BxF-5xaScD@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-4-kirill@shutemov.name>
 <3113ac8b-c1ce-4577-9e93-449b70818918@kernel.org>
 <aobglSY5L1KoIqxF@thinkstation>
 <65433d1e-95ca-4434-828e-8f381d3384b1@kernel.org>
 <aow0Z6mrG2esKpRZ@thinkstation>
 <e1c8c6f5-1b5a-4cad-a52a-f7eff00997c3@kernel.org>
 <aow6J1i2G7U0spjH@thinkstation>
 <aoxPzKTVRmZgmBKg@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoxPzKTVRmZgmBKg@gremlin>
X-Stat-Signature: imwuost5x7mr4o5y8re1cnwca6x6gc6a
X-Rspamd-Queue-Id: ACDFB18000D
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787584692-875044
X-HE-Meta: U2FsdGVkX1+KrbbbTv/kwxcGjMhgaGpBVjrVp4U7NWS+DRmf/yoU3JTbZV2rQsXqreVrUiVfMi8y5+YUXxBsGjJASMtVe1jVTuXr4Rve4T7lYU4rF7cdsQDg28PZyUCNZxtAHFPfhj4HbIK08n3WNRawb+dr89jAX/+rgU1m1k6IYO1d2yABV6tWp4Gmr6gCtpyf11fzgSmPMwjjYouwTGeiFKwPy1wTCxrjHiTtkOZ+S3v5ZPweNkD/Q+5Jvvewc6kgL6WLicSMUSi/o+Gbh3g1S2R9j+gFXyk/SZOylN5jJTfPQJ0S3y7X7Vwk/nkQPyojlvzXrszjV4ymsvq+/1bh+sfrMY3ncmdAmzCFbrIaBh+XEjcOVm/lClWPZZO8bxwCpw95HggwyYM5TDp1bYVVQeVEzqTKfmlCsAHPsLjqfexgVBNIN2WzEu0QN+eGa2iQGHqKeuqgYclLKt/bkerg8OkKuyfbqkZ+qANYdqyJDmg3NgWgEO+0RW8OSRyyLSzSMWtGqx4aIENAgNuA+prFcaX345gDL8tHk01IOYer5Lq9TUdhHcBII71AU+q4ul3I+xm/7EBPap1q04+T8eAZkIJX+Z0Ut/Ex4PjDtTznohAwHpXOxBjMFMqR3AOWkFoc8V3/G5itoePbk1EG6JlVTuT07Ks+tqheovZzkyCCPPKIweNfCfbCH6iD6c8oGpOHR0ANLaPrndju6o0PvVVLt0P4cgIt9ZZy8s+BNhdMZROQ/0aGvXWNE49+4BdNjDs6qYnefSg5McwuBV6DQANAVY7YQZYCoTh6vMGvrOFLIA4fiK3gXkIfXSJmuwG3CmRNfOCjiBtY9gQ0OyzJ2X3pjctnW9zkoq5yfumtYASOw0pcNyug2DVq0BYKNSmam91LnO0C2mB3xak2M/RsxyKwYWktjpSByE9JD46i7oIGxRlKZnCbISwXXsarnUXnZaAOH2I+nerZeaCFUzY
 97fG7OGN
 r74Z4F23ab9A2VT3GpS10Sw6VqoMZE8bV2AFW8JlvKTKNWK1eZsy2GZnhzHGxoDJTbwSz1zQzkIPEunQghvk2ULp0P5/Inj8psc6zcBVvxPdtJDs7cbih/NHC0UGlbnLMajNuz1ICPoRjGUCOQZtJ0pXJmaV8KwMCxLzwsOdTXgXAv1Y1QzVnScVVq23hC4QtpUNqOe/y6voO58ztgorb46KC2tJrLUtZX6PpXR4xFTBY7bPpj6oNKn2riUVl29MZeWYBNSGLUx5ymGKBJ9RXHtx6bT/lmXK8H86gkVu0xnNQTQzFDCuiCRObsuBNuHW8gzuRXao2hHvGIuxeXEv3CKOR5lggtk7K0ilubfIAM9xTkXf/FziQs/dzz88wkpB74Wso4HXEsWYVPz3w9c5QR4q0h4A+JnaVtO6Q86nTM1gQ5MMzZTSfnBeHYXyHwyELVc0p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 03:09:00PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 24, 2026 at 01:36:03PM +0100, Kiryl Shutsemau wrote:
> > On Mon, Aug 24, 2026 at 02:28:39PM +0200, David Hildenbrand (Arm) wrote:
> > > On 8/24/26 14:10, Kiryl Shutsemau wrote:
> > > > On Mon, Aug 24, 2026 at 01:47:54PM +0200, David Hildenbrand (Arm) wrote:
> > > >> On 8/20/26 13:11, Kiryl Shutsemau wrote:
> > > >>>
> > > >>> I went for a clean collapse.c on purpose: the engine is new code, and a
> > > >>> new file keeps it readable while both mechanisms are in the tree, with 28
> > > >>> as a plain delete from khugepaged.c.
> > > >>>
> > > >>> Your shape is less churn, though, and it keeps blame: 29-35 move about
> > > >>> 1700 lines as add-and-delete today, and most of that would stay put, with
> > > >>> only the daemon -- mm_slot, the scan loop, sysfs -- extracted into a new
> > > >>> khugepaged.c.
> > > >>>
> > > >>> If you prefer it that way, I can give it a try for v2.
> 
> Please don't respin this as a 57 patch series.

I didn't plan to.

The goal of this RFC was to show the final form I want to reach.

I will move cleanups and refactoring to the front of the patchset and
submit in small self-contained chunks while keeping the rest working in
a private branch.

> You need to break this into a smaller initial series that lays some
> foundations.
> 
> Cf. what I've done with scalable CoW series as an example.
> 
> > > >>>
> > > >>> The rename has to open the series, so it will collide with anything in
> > > >>> flight that touches khugepaged.c.
> > > >>>
> > > >>
> > > >> Kiryl, I have to ask, are you using AI to write your replies?
> > > >
> > > > Yes. I use it check my claims and fix my grammar.
> > > >
> > > > Why?
> > > >
> > >
> > > It doesn't read the way you would usually write. In a bad way.
> > >
> > > E.g., "Your shape", "has to open the series"
> > >
> > > Consider telling the LLM to not change your writing style and focus only on
> > > fixing grammar.
> >
> > Right. Asking for rewrite with proper grammar was a bad move on my part.
> 
> Even this reads as AI-generated... Consider writing the replies yourself
> please.

Seriously? This is border-line insult.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

