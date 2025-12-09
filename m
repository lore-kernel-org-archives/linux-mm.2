Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C60AD1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 10:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68FC26B0005; Tue,  9 Dec 2025 05:49:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640786B0007; Tue,  9 Dec 2025 05:49:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 557156B0008; Tue,  9 Dec 2025 05:49:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 485CA6B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 05:49:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE62C52A07
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 10:49:58 +0000 (UTC)
X-FDA: 84199612476.20.1EF552E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1FFD61C0018
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 10:49:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UPvrCAz5;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765277397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rLRCFEkVybIvvP0Xp+zOESAUZzmXjmYvnDu1S1ILJU=;
	b=gQisSGhMkASlI5TH/sd64kRmOZvLDAHmeXezmPk8inTTi4wesIn1myLHc1OKS/xUEv9iwL
	GAdlLD2sai8LD7RaqZNNNgRdcYrdYsiAT0duF0D5roYZqbjiZlM0s/wKso8+kWciHMoYei
	sFdvtgljR3Ik2a8GdviQJxRAPjXs3vc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UPvrCAz5;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765277397; a=rsa-sha256;
	cv=none;
	b=2PU85VryR0tVzD5kvMNovWRfLfs+zIeaKg0TxHsXuIWCvPHyjhdgPnFFQHhvAfBE/NUIKw
	aq6EMHvu0QPGVNAg88EnXHb5dRsjY3dJidtFxbRycHC68L3SXOcQj1BSsSPWCRL1AQ9cbT
	L0FfDd8ymgX1OAdnKxaJIjHfRtziC14=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51A9B6001A;
	Tue,  9 Dec 2025 10:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE21EC4CEF5;
	Tue,  9 Dec 2025 10:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765277396;
	bh=5JSL8kPkVv0kostgrjkUlhoSwShzRt+ceXPrqvQIUSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPvrCAz5ius3PvIltupEswBs5UZtH/0nmef6nzsW8CajXvksXVrEhJvlrEPpg8vRp
	 i69Bz2BfpcWbo3WqgEBxwJ14pxRB/lZ5SWkB1T0XQrlI4payRRTajELbnWLKLzdMcA
	 hc/5EexM4bzYCtmDnIT+cvNIMXxBt0WulCl1wd4KOqkwMPgsY46YnkCCBsnBvjvH1d
	 xe+yVzrXIpj63tHcI7yfwLiIzc6i9dru3PDaeyaTNk2UItPTkG9b1FRrriNCJU6WBP
	 Pyp6PcJlrtiflb1dv6hyDnuAicKlERHtgk5GnRVnUdaaPdHK3Dsw6/pKaUL5DdpwDX
	 dCv73HAtlgK3A==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH] mm/damon/core: delete damon_target when detected invalid
Date: Tue,  9 Dec 2025 02:49:51 -0800
Message-ID: <20251209104952.43233-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <87v7igm2hq.fsf@>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z3q6mwor4i8ixx1t19ujgrrzgzhbf8ci
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1FFD61C0018
X-HE-Tag: 1765277396-91299
X-HE-Meta: U2FsdGVkX18uDsMjgg+94XhQBPS3ga3oxg/hVFm6iQn5xSl+Jmq04TVb8h6eP5vV33JO9QhXiOGHI1YYGGAI8j9MtERvUHXqvodgovs3JeyhLqv5GD9JI6i2lm2EuV2RQYsQjy8085Dx1bOCbdJpfr4TTtaWNB6wfKnGbf1VFA7HXkwHOKClBh5SMBACLhQWmAWcp1xrRbrJjZ3bChupaJfIbBWIwzcTVZWJVRgB7DMjOe5oHl2qLRceQa6STvg7OxuGMSc/ebcM87ome28jVk7e2IantwMooq9v8ITv9FaSwVg2iQDD4GqzTuvJ98vtyBOF5b/3uN6J6DMGzsdeOJtflxAOnxCxdzaItgScXSSEg8++TOuPhXbpiIf2Kt7/9c/jtvIQQTYkyt3hKMjdyHS6G5PwgeRRRpgwPhPAgy/poWf7F69opkjVZYR+RTHMdej3Gh1gt02sa5VedIvi/5pngUbZ9DMxGkdQZhaIa7z+qQvSxAvr8FRm9/jQ+EuGQ/xg27vAkyFjce/K1AcE7aCWlH6+EQsJdj6qwcq1oIqkMeIomicOcBrB1m8RSA2CLW1kgnKChS0KFLQHid+J8JUd0a1Xrq5sNW0GQIO+gMQXjIAI2oF/a10I9Ndu/ENk204teOWJ2GA/6CVQXJLtJ+41iDzhUplJ7syaUWszYl2xpHW/8BDDf8dSwiZiOk0DXCZ8lx5xoR9nq1EgjKhbSitWasmK9w3oGIkAfSvHaCrSAIUSOVpLPyBCsdm8g1ildz0dN6NkbMqjMrmNzqBIRlpCv31krPMvvhCfg4onkcIr2RrqUKytW1siHMwqnM1J6SW2lWQ7NYUkQe7mKrKFvwIusutQgg7iCw33K9Fn7iPFitr2qZlu26Cw4KBjNJ5V9vyTmkOmhkeDb1ZsV27ODs1db8hH/Re2qXa48xHcVysjPjE5exXgFsG6Rxn554Z4hOfw3+HTuXTrCdQpGEY
 yPGnvHvr
 dL58n48LBxdf2ybBaK667/OLjTMTgPIavDGbC7+PfUwJDEYDOhxp/PmxPDgr4BBSEVQ15Mj1MssgvdQZOq/KHH1r+8sfI1NTdpIfO5z1zLGEJ8v05i1mE5lMv6hTw+5a75WCCrzKgos0QyWHB74EVobr0ZmL8jKG+48WUSmZ7NZH01tDt/uKNJC0L2zh59vMu03dE3ydMFhta4uyySc8zK5GyDtLmxSYiS/yIhLcXg3kOT4XXIvlWvt7W7/LZiJH3iwon
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 09 Dec 2025 17:24:49 +0800 Enze Li <lienze@kylinos.cn> wrote:

> Hi SJ,
> 
> On Mon, Dec 08 2025 at 11:21:45 PM -0800, SeongJae Park wrote:
> 
> > On Tue,  9 Dec 2025 13:57:13 +0800 Enze Li <lienze@kylinos.cn> wrote:
> >
> >> Currently, DAMON does not proactively clean up invalid monitoring
> >> targets during its runtime.  When some monitored targets exit, DAMON
> >> still makes the following unnecessary function calls,
> >> 
> >>   --damon_for_each_target--
> >>   --damon_for_each_region--
> >>       damon_do_apply_schemes
> >>         damos_apply_scheme
> >>           damon_va_apply_scheme
> >>             damos_madvise
> >>               damon_get_mm
> >> 
> >> and it is only in the damon_get_mm() that it may finally discover that
> >> the monitoring target no longer exists.
[...]
> > So, from the beginning part of the patch description, I understand your concern
> > is the unnecessary function calls in kdamond_apply_schemes().  What about
> > checking the target validness using ctx->ops.target_valid() and avoid going
> > deeper if it is invalid?  Seems the damon_for_each_target() loop is a good
> > point to do this.
> >
> > What do you think?
> 
> Excellent suggestion!  Moving the validity check to the
> damon_for_each_target() loop via ctx->ops.target_valid() would indeed
> prevent all unnecessary function calls, which is more efficient and
> architecturally cleaner than my original approach. :)
> 
> I will implement this change shortly.
> 
> By the way, I'll add a "Suggested-by" tag to the commit message, if
> that's okay with you.

Surely that's okay and my honor :)


Thanks,
SJ

[...]

