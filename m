Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0240FCA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 12:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CDD66B009B; Fri,  9 Oct 2026 08:45:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930996B009D; Fri,  9 Oct 2026 08:45:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81F7E6B009E; Fri,  9 Oct 2026 08:45:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 603F66B009B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:45:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E853880342
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:45:56 +0000 (UTC)
X-FDA: 85303059912.01.394A1B4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 02D091A0003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:45:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nIAKcm4E;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791549955;
	b=OnmfF1/rv/qTbEvZVqnJbNBRB9kysG6KI1qZ5OYGqWY1swcz4MdCO+Iz9ycOmiaCdDB35A
	5A51cw1w+37EW/zSunAJyGDIV83sCvr3xti/fJIeX65Azp+KfGNJk+ANMLz7MwR5WvlN/b
	pm1X/7pQteTLCPATWNNrfuUFEjK6vb0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nIAKcm4E;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791549955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgixxsqwaATihbPk/CkvSOE/LALNPeYn/vk/XmJ+1xQ=;
	b=5NAmWh9rB5MBzqxDBNhHi4EcAG5Ir4u9bksBKnV6pRHx6qBTBn26laWv/gteEZQmbCl62L
	MxAQYHXPQq6+NxqWk6XIA+pXMXEqXtDmvumuzlaTRoJ0l3dqt8jyRaoNBbo/5il/xneY5K
	wg3yXe6T1cnYPvI5g4MXMLu1seXKxFY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=fgixxsqwaATihbPk/CkvSOE/LALNPeYn/vk/XmJ+1xQ=; b=nIAKcm4ERKAlzvT5xAnorMTsuo
	GHrrvWqqhnPWRcpKJtwmt/t/2to5cUNdZ56sJjxQf3V1bHv1Auoo1zszZCU3V1soLela1D/4GeDMd
	+L65G8IDugGDzc2dsTgJs/7SIkSXJ3Rk4buktEcui7cPdwzoKSuK5CXOaVvG+ZZ6gbrUQXuOEu4NU
	Z6bvwmTM/SL24mJ57CFVkrJZaHxwtMDcukxSIRMpYIDQZa1R2lCYwknWHVc8XZj+E5uR/NRC8+gsx
	cos7SonUWLwg3x4qSlDohQdXnES0x5lKReCRh7tSZJOK8BvokqoFzFG+Tu+2yf+gEFw4UA6TPrJcg
	jqvX+kvA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xF9yv-0000000EmdN-1xf2;
	Fri, 09 Oct 2026 12:45:50 +0000
Date: Fri, 9 Oct 2026 13:45:49 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Arnav Goel <ArnavGoel@woodstock.ac.in>
Cc: "damon@lists.linux.dev" <damon@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Research use of =?utf-8?B?RMSATU8=?= =?utf-8?Q?S?= Linear B texts
Message-ID: <asjh_RkmMyEUZUiP@casper.infradead.org>
References: <SI6PR06MB74745E4D61CF3341BF6958CEE7922@SI6PR06MB7474.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SI6PR06MB74745E4D61CF3341BF6958CEE7922@SI6PR06MB7474.apcprd06.prod.outlook.com>
X-Stat-Signature: 7pmhy8ac8ncmbrr4adrpnu5xrp6i997j
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 02D091A0003
X-HE-Tag: 1791549953-935123
X-HE-Meta: U2FsdGVkX1+G9eGDsPJCG87YVqL+pVQVdnBtS8zhxqL8Ws6fCI9DB+LIBcvre7UTrrNGzRMtEPhaA+VnkCBHj7OFrf15r3EqKDtky12kxBdS4vs9uXT+778joxVbwvT9+1wMJrwJiNw8J3mcGU8ys0X+cCc1EObx2Zr0Xkd5NunOI0h1k0gy78Iotqe30Z1lm5U+SKjkqV5Jsxlm+q4zZEJ4DNUYMTaG/NB8+M2xzsBq1LLZ2dyytFZsVFttrloaCplyLy065eK0Hqmd21SmE42wnnxbaScfPlgDDysV2nBX7bjeqA/je7zWC3P19LEFEMah69vopeYU9TWNiZM7ATS9r7dv2kTCgw6tTyjF4ppfhlWlZcIyLYoSuPlPmTmI813Hd0E7yRnsF5J3GoVK+d/RZataCNtB3vGdk3yh7sZfCTl7ZjabxKDQ2SWHYgQmVAD5/PESk1U3bJ63dTp8mjOymcPMYMWRmI8v/IwLgxjo/jJ8A6dIMeJ+c7Kg20tEPrXskm/z6+M65u8juLWGw14vu15VVlHJCmlJAZw3oPlTIJCjAXAfia2gDzirc9zBei8FzzhtCJwNY6l16qAMYk85VZasRI0o5iPN/JhABF/mtK4UlfXjiy38sURSrvVSb3CYQYo8bCQFJ9+klPt1flJt5YRt+Dlow6S8QMR28wsg+PY/UxQ5eYekzopsdlAJVmswcdtvtcWZaq7evrjq/j2qECKL9XHP6VAoqH7mnG87tIwv+8dEOZzdzrRAUqjueDUQiZhtWOYk8MZwXzYTuD6OA2m9nvQUnfYxhHsJ0xS2k/Xiz3QuLXKGsfub4HZ3mF3amKCFF/O0kpj9xZ0nPX3tOE+wOMW09hit+aRjvy16KbzlO29pMo0b/3D8L/YUOXuqXDlme7/KvZYdNPsS8zZQ/K7Of+M+m2Df5zAnRQ2B5XR6Tq8EEcJjT9yFTXTQjGDQx1OLcD7KYPUZcc7
 FYm8dUNX
 BEcTMyJFhh/xs3sYTKFVzEjz5zWZtFs4psfp6Eb2kGUiz2ToKu3Q4/fmz3JhQcAsQ6vNz6WdXMJjRK5MRvL3NzPdHcUh2vu1aFecFwmFtbs6EDZs7SMoIIEnE0g11mkAsMjWrOESfJV2M9Y9yf1llBUeYMBA9S5G2WLn+8bdzxIJYtvDCoY5Gnulva5TdcXjUmIHoD2P0Nl1EktKBTaS8asURzgdcVincN84Nfqq3njQ47GgDo/ku0sRv41s6eRhNEUvv1bUkXhHxO0b85peXx73P9NJB5boLDmOEB7voK3xi9zc12rM7c7ZNuHipCTZDZxJK3gok7yituv0xNl5S4dHW4yxiZGo2luPtCtzCnNBcnjG8Vpn8kDLwc2TP2aO+n9ai23nvxdtNFdQz2IOXyqq55cI+PQ4Du+dkIHU/dLONv7UzSw5Ql3wUclTTdj499cBR9cVEijQXoLh8db845p+p5xZ7/iE3WVzt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 05:42:41AM +0000, Arnav Goel wrote:
> Dear DĀMOS team,
> 
> I am a high school student in India building a benchmark that tests decipherment methods on short-text corpora. Linear B would be an ideal real-world check, since its texts are short and its language is known.
> 
> I understand DĀMOS is available under CC BY-NC-SA 4.0. Is there a way to export the transliterated texts in bulk for non-commercial research use? I would cite DĀMOS fully and not redistribute the data beyond what the licence allows.

I'm afraid you're asking the wrong people.  This is the Linux DAMOS
which is a Data Access Monitoring tool.  You should probably be talking
to these people instead:

https://damos.hf.uio.no/about/content/

