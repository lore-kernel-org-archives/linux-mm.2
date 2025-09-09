Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A6CECAC581
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 02:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C024A8E0007; Mon,  8 Sep 2025 22:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2998E0001; Mon,  8 Sep 2025 22:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEFB18E0007; Mon,  8 Sep 2025 22:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A0F108E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:35:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4952913A6B3
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:35:51 +0000 (UTC)
X-FDA: 83868146502.07.7180E96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B896640006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:35:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="GD/hCEEp";
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757385349; a=rsa-sha256;
	cv=none;
	b=ynJuO6XsbELA6kM2Cknkbm+S/9o4HnASKzxk8/viZvzjWhUsmq4ovlNAjQGv0j18XM06vQ
	7tXS5elXFU+inxxSoyhTL47YqFqbMwruDW3BcKcvw5zDdNMSlMHKRP5xDrY468qhTRBXaD
	zkIVWlnrECawPQ8DZCNSlGdaIvonPJk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="GD/hCEEp";
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757385349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kX2gVRPt0ld7WO0kAVI808awU781zhGB4jOZusO6IPg=;
	b=I3sK0vKkEFXusQONTEkTCS/GWqEr3HuzD54LyW5G/uRNZfDClLIJgAUTEvxkDVASOfPW2V
	yAWiVSyuS9dkYmQrPnBn1qmoioTPjPmnwmVv1mH85ivw1KhtXoOfMBzZnyYxUpGAfCdox7
	Ct+aAznbTZqEcm/jEAwKjB3Dk47uYDc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 32C0160194;
	Tue,  9 Sep 2025 02:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A124FC4CEF1;
	Tue,  9 Sep 2025 02:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757385348;
	bh=cZfhit3GglnSzityCsrp1a+znZusyvIgBXCsdOzHIjk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GD/hCEEp1s2INnkmtrSAcc+zYBtJH/pBF3LTNFDTrsZ0R+g/QXl6aJtMiG/Qp4IPB
	 4J8iWMfZwt5ezrsBu79fw2bzRLZgle5UHb6evyvUzMionuuQHZkPpVkLgGMIWsNapm
	 id94aOdJixFJ4SMt1hB5LoHQPf2wBHWTfBKd/H7o=
Date: Mon, 8 Sep 2025 19:35:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 17-rc1" <stable@vger.kernel.org>, damon@lists.linux.dev,
 kernel-team@meta.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] samples/damon: fix boot time enable handling fixup
 merge mistakes
Message-Id: <20250908193548.a153ef39d85cc54816950f71@linux-foundation.org>
In-Reply-To: <20250909022238.2989-1-sj@kernel.org>
References: <20250909022238.2989-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B896640006
X-Stat-Signature: y57hfkrc55f38z4fxx1e96rnkqokqt9w
X-Rspam-User: 
X-HE-Tag: 1757385349-736412
X-HE-Meta: U2FsdGVkX1+2j9TOv2u68Yln64AgQ5PJup0Pdqa5y+FYT2L5EO/XGGo7D73VmmDmOcUpD3I7NhqB2EH0Jo4XI+DGIIJ6fWcKg9DAD7P1Jz59oKiwVgZQIjeIGIYw93Jj3hbnP/cK2y2/6R9s8vNIYpGA66O+01BRLbdP7unadDMTwgr9sw3uPVb27fSIzaOHBUlN3RD1K9d1DtOipU7n4vk11/pKyfdoalsHHGNZfbmdlFhWuHZVqqEdsug6YtrCLBps9REihE+3fak2sOu0PqlLr9BOjAlEvSe0sXAgpWm7DtfrRnp7U5NIcukFFft7P0trDdADVAj0tZIz1u/DrFI1ZMOKBjwx4Ek0U9jyUO5aGYQ2kTEhv3lGGUsg9JJ5OaK4FsvywA9QT0UXmU/dE3/k25M83SGMQFl4vjL0IGDr4EzLA33Dptj3a1jleFKJOg57oegF1FePxj73+IBZvRU1w/Z4+pN30/vgT3k7l2S/Gz6XqM6eqpa07TScDEsusy4aeqdY36g01Y/5kyolqfXb8i1aJCNO0ZUMzSFUOSQUVYb5dp/BJtlgyrsXz9ewKpdPr87000x24iexuguwUUXP3i2OL3DkSNLEkVDiSQqdtdPc38P8WsL4VpkWpSU40he3tcxpcK5WeHsYzusA7BwR2bArEijWS071xr1fnT3YFNqkEoKnJkoEjy/2X8VUdppCacnhZdDM3/3YWc7kkj5CQHpB8Se5pG8oLbesZr5LT/LyFHJOYlKnXcBUXZro1gwb7SaVL4gwTxDTg5OX2PHtHyijR03vTB36yX/MEUfF6G38bwXl73RkbxOyv+9B5rNqXOZ9LvPFjm7lSHMnXT3hwwJGp/Jx96yDdlyHn2p53tMOSfM1AWin3zcjojS90b0hBAkU+m+oq+ObZ+4mxl6uC1wFbciz1p+bWkLDJUZ31WmZjA31ZvvQ9T7dSPtHybE6SlNSd37VJJ7Xwsa
 O/9emGGw
 RUIO3Dj0x/ctag0rpWSE/afqEzQXmnPsZqay4lZnpaqC4CMOaXrxLbOPMd3s9wOoYFVh9xiXq8udNzqJlYFIe1rSV4NYY2raSIDvpXDe2T70xA7pOFWe9uJ4+RBcDy/yN7A197cEVyHC3K93oLIwQKA5dF7r+kpf3SSeYvXuJqPdV3zOB3w2++CAinv/xxius9UoOY0vN7BvMkEl+rQDQu6N5CSGVj3osZxe+Aysl0/Gadxe5AlqcKkoe6zvHpGIy8bpBwggnJnsDBJ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Sep 2025 19:22:35 -0700 SeongJae Park <sj@kernel.org> wrote:

> First three patches of the patch series "mm/damon: fix misc bugs in
> DAMON modules" [1] was trying to fix boot time DAMON sample modules
> enabling issues by avoiding starting DAMON before the module
> initialization phase.  However, probably by a mistake during a merge,
> only half of the change is merged, and the part for avoiding the
> starting of DAMON before the module initialized is missed.  So the
> problem is not solved.  Fix those.
> 
> Note that the broken commits are merged into 6.17-rc1, but also
> backported to relevant stable kernels.  So this series also need to be
> merged into the stable kernels.  Hence Cc-ing stable@.

That's unfortunate, but the about doesn't actually tell us what this
series does.  

> [1] https://lore.kernel.org/20250706193207.39810-1-sj@kernel.org

Presumably it's in there somewhere?

