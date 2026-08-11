Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B558CC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA8F66B008A; Tue, 11 Aug 2026 12:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81586B0092; Tue, 11 Aug 2026 12:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97576B0093; Tue, 11 Aug 2026 12:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 815F06B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:58:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECEAB12014E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:58:53 +0000 (UTC)
X-FDA: 85089598146.04.91B17CF
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf11.hostedemail.com (Postfix) with ESMTP id E44D740014
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:58:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="h SQFwMB";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Gts6PYdY;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786467532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjyAvX7Mugue+C5cYh+R1a7/5p4l8Irr+ax7oHoUcio=;
	b=8YIvurIKuupOuJwWXFlEOsPCo70POgEk6ow3Yy2qFhP2b83RufJ3g+fNoH3zsybZgv5heR
	dapxh7/oVsU9tHDEZe/SJd0KOClIMurTy42mwrUxWh6WqR9elKN7+/3N02Mm8DtmByKgcS
	mcajluIXGHn7+6AxnDWjJqUqx2RfGYo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="h SQFwMB";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Gts6PYdY;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786467532;
	b=4CAJkStTOd9xSrX1Z0+3GuXriA2IeqhHNf9PTMwUB4X7Wri9VOGgbFnYm+K+M3I33XJAFi
	OMPrAOTiSWJ4GvQkVuok6quKAf5do8woYeWh/la2TV1Usk50j1a8kipTW9L9q4cMMCK/t3
	gVF4ATgx+zKdJ/fuaNHWzE0mu9qivXU=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 25FB31380437;
	Tue, 11 Aug 2026 12:58:51 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 11 Aug 2026 12:58:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786467531; x=
	1786474731; bh=TjyAvX7Mugue+C5cYh+R1a7/5p4l8Irr+ax7oHoUcio=; b=h
	SQFwMB+XetV9+hyyHHxogEKB2YDwOPjRDNI52tI2w9feqalcTr+bd1BTZ1sKa4xr
	gGF+EbMb614itLTZR7PNJMNVVog+FIL5bN65sU2N+VbAzEIgaJSJ/5HMvHhFaypi
	RuM2kzzFKlB3YZjsYuARHTQUQHusi3SkT6AWc8Boji4E0IIWPWJ+90ZEHcj/UM21
	KsYgsxk6iDjjTB8h19N459e+aYJJMt++4ljEoQxjkTf9MIhseLXYNO1saFwHHEFW
	ahLuTOf2uFXS1NyJlLwC0T6EIn5iigzG8+Sr+b4Uy9Vcb2YkF4hb/0nuqe6eUJug
	zstTBrBulAfPRws80dqww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1786467531; x=1786474731; bh=TjyAvX7Mugue+C5cYh+R1a7/5p4l8Irr+ax
	7oHoUcio=; b=Gts6PYdYpzbZm+JHlw4zdQRDReNiMeaypzlpXJ7DISg8QYcr41q
	/7xkSl0T82xmcaWXOq79yORI5DJBL0YCbNu803OYoPQO3/WoykwcJiFgRVOO0zvX
	xdJvKSxUSbVOG9aYeOKjEZKUDgdFpWP8HuGuNzIqjN8lt83P/O3Q+9bGkJbcxyAy
	bOk31cyOpsCi2CVM7PXITBBuUG7FA8igyNEq2MHoleRD+mRtuSvfpyT+YHspYgMY
	KBFnz2XBx+wYzP5BabvbwVt1HskfUTNCOLEyBJ7rHUbbXKajrzOAsT84CD+VJERn
	s/iaEV0DBlM1PqS+6YKIi+SKOo7xVujNkHw==
X-ME-Sender: <xms:ylR7agnVyLXt57mfNJTAqkJUVRgSEZtjj0VSTBC6_pF3zvYwmqqrVA>
    <xme:ylR7atdV6iRwGP556xrHjmG8zmONPqURMAYY7h3qZpqnw21P_hHQpbBvKwDicVa83
    CAjMhwarW5i7abFupQotQMcxv7vSq37h9bkTjZP4S47uPT6ksvmTF0>
X-ME-Received: <xmr:ylR7akN8kCwbLJyXMylgfSEiHFj84_8l_yR5EmUP9E-Nf3g3H-MN7s3GuZc>
X-ME-Proxy-Cause: dmFkZTGw/dvbcaEj2HngP33VDAg9eCbiq0lwbqHTn2QAHQczq+P2RKDp+L8ud0Spkr0mhk
    3uDL/BCZgN9VBSnXxgqgZmjprKpgFZCp9D7x5ua2QdXa8Y3zq2jFdoTz+wMcpgHeI+dZMv
    SH3nFGwlFziDUIaHYaLWqOBy0TSFxRiM+s9hg1mDYkmth4uP8oXNyv6Xr7cFS7ZMYoupr+
    JjHmtkfeO0jrGgEmm5N1yLT5ZvMVq5j3TaMJMixbHC3ieE50Rn1Tzv6oyFX+2ZghkjdR60
    h2pwdEs6Y2LSL3tQnMz/EVeo4YapSMlo4GYY0Y44Ov9KhB6d1btj8zbKNkgL/98kdsDhGK
    D9atn1Her8TmYPe+HvKEbXY9gJdp+hFiEy997w9uyjKgg108vLs/nEPVEm7oeI+Cud0fVv
    2uLCiuBNEGs9i+C+6gyKxbBxh0jpKynfpA0PZHJ7SLVbotgrX6StpXKMu6/j2GVfriPnmR
    TilxE+3Ojf+x17pITfhU9f+KyC0dJHpk2oemh1NHBYYNUT1fMK5BzB3i4L4Ji13rD96OfW
    NobxrnpwSmEkA/7i/yfqzT2KE4YqdAVn+BDGgZaJBPBYyMMjBoqCGKB9OOjKHn3oxI++1O
    3AiTfaFLnGJzkzZi9A9GjXD6CNsgRQpR2HzCjSqvmKFys3rZxggvsj0uFXiw
X-ME-Proxy: <xmx:ylR7agMuyidBzdKUldr4igDduleH70rXOyrDW3rWnWvhXvl9XawgNA>
    <xmx:ylR7at6YfL_eTGP9rvVq5nQgu1IxIhGjY0I9NuGwqQ-WsFIUn5tBGg>
    <xmx:ylR7asam06tmpINrcvxWcvE4IgplarF_0SIgGJng6doHA_gaRupRDg>
    <xmx:ylR7atF0lHg9u-3aYD32lFFRjKhvAnSfStaB3KF6mSwgr3RO-fiXYg>
    <xmx:y1R7akL3f04RQ37VXqAHBMwA5ZZZQG_hpcbyQggrqITDtd4YK2ykpBZV>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 12:58:49 -0400 (EDT)
Date: Tue, 11 Aug 2026 17:58:48 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, 
	usama.anjum@arm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/17] selftests/mm: improve khugepaged coverage
Message-ID: <antUso_Mfdh3EiHk@thinkstation>
References: <20260807113647.3744609-1-kirill@shutemov.name>
 <f9e0fe38-47de-4577-b638-1142d4ffbe6c-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9e0fe38-47de-4577-b638-1142d4ffbe6c-agordeev@linux.ibm.com>
X-Stat-Signature: utbpteo98m8xypxckq6bhz3ydsxc994t
X-Rspamd-Queue-Id: E44D740014
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786467531-564452
X-HE-Meta: U2FsdGVkX1/0qBrf0DCwqC339SMgSVWtI/zgWbfiSnYOG6jtMA/m7yPz1wRKw23xzXyRsrPPbWD/MT8rFIuMJYTfm1IIKhhR1QDgF37MHsbZYjNCPZK+GTUawcvZRK3+6Tt4Qmsqs/uCWJQZ2GqZEiY+b3G7egb1RTgIgEKuz+WcK6vMoLXefL6B3khLc4uEve5nicsfFmfULd+XiaJh/8OHLVxKpHxZPcyYJgiN7CCm05zYFyrILR28kJ5kl/xTz/CnkDjyagb3ChZpVX3Udis09gXOkVB5MThaM7egvMgTTYnBxvPNEKL+Qu6XuShz9yk2lkptDciB7pa+ZEX/q+iOrPmNmGDK21AwL9GFGZSe810E1HYxtiXnKP+G3RuyS0das5nklLztVepAkjoLX/ldn9hltcRFRB2cCc2KIDO71H2wUlGuteOIxxu/WFiEdeoowhx8jwuE67RMRCAvU0I6gyb8ZvK+VQY7H8clNYsXSr8bTQVVZ3cxgiNvnvYC0yvKOx6+GV++aSbaF+OhI6P6/ZSN9RMEdnfHLzmMDl08/VmLTwtqtMGHTRh5vmMPHBycGIq0EXd4ppmJOkBCqtBvNB0bTQzcxHlb8xXzT5U5Z0LxnB0i9l4GS6yweZ4LR78n3ixcpVkszsjKOy52ME+NHTTjP1H7EmlQR9Q1rASI+KG3DtFRTLCcn9wGpHf6mt3Ya4VAZwPWrZ875jIGj8xb58AbsXGfSENzDhyHH+rHAT0YUPNnnyxEVK2uDd6T6SYdLScJdlaYiyrS0ZlFXQJDN78kqxUY8A2U7gvuZLI1mSafeo0PGa45TdvsNAs56zjneNwuzecm4KLisrTCno+XLJMgH1/JQJ6DgrU2z0L1ePs3IqGSI/zMRXnYEmxbadWLqy2eAU9UZo8ZajE1CxcpBB5ys8IQfBRk6e/tmRIu2X8HGS/ylZ4zE2e/WsNezerBpZOUa8Zuc6frO1o
 TNKGmL41
 aBRdDBgdTgKqXOvCk7y34z/bUqCcGVAz95w452EyUH9MFzdPHJah26w3lt4acS6ckFVSzr0Kc+K411QCiRkYcpqcmSuXyAlrHhXu4nRgWSmLDJAHHhs2MN6hwpbptIcotrbW5WcRoPCswolP90pn6H9uVZqTtoy4bAKvVZKPFXi+sgeiU4SFRBfktz6s1/17hfy3/VjdwmKitAydkDYUs4oQywSTffsvIOV3O0In2Na8dbNUb7Nb1kQwQzHpHPG2kz6sP8O9aOHIvIiw61uOdBsKpfBlLTUwcQTgB9nGeET4NssrzSgaN6Lkv2xntRC4MsVrh1U9YtoJX6pOQqbsiwgh6XVlCZolqF+n6XrkTmL1cPzFaC0IRdEgVef/EixNl0CCwFoDCtm46Fxgj2vszCazjqCT6ClnkpiSF3BqODiSJ50ndbglEF7qYL+wR+PKKbsxG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 02:58:43PM +0200, Alexander Gordeev wrote:
> On Fri, Aug 07, 2026 at 12:36:30PM +0100, Kiryl Shutsemau wrote:
> 
> Hi Kiryl,
> 
> ...
> >  - Dropped the swap-skip patch, an equivalent has landed
> >    (Alexander Gordeev).
> 
> And dropped [1] following David feedback [2]. Would you pursue the proper fix?

Yes.  v3 will handle the failure rather than predict it.

is_swap_enabled() already skips these cases when no swap is active, so what
is left is swap that exists but cannot take what the case asks for.  The
series already has swapout_range(), which reissues MADV_PAGEOUT for up to two
seconds and reports whether the count arrived; I will make the two cases skip
when it does not.  That covers swap too small, swap full, a memcg limit and a
folio still under writeback, without reading /proc/meminfo for any of them.

An error from madvise() itself stays a hard failure -- that is the kernel
refusing, not the machine being short of swap.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

