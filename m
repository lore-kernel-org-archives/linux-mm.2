Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B22651093170
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2849B6B0429; Thu, 19 Mar 2026 23:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B9D6B0432; Thu, 19 Mar 2026 23:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C01A6B0433; Thu, 19 Mar 2026 23:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6356B0429
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:22:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7E861A07DB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:22:06 +0000 (UTC)
X-FDA: 84564992652.29.BD18189
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B4C3A0003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:22:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=liSR0cAN;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773976925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tNvWcRoPqJmADdDuPWkDyH/P9AXSfH8VPQdU3mljt+A=;
	b=vTp1W5Vmf6ERECha/xUqAFcBelEGmo8esWebCnBKAgubpciykMdya/jrOl0fTlfhiFYR10
	k3luNV/cymE+H5AkNYpRIdCulUB5jk6en8DY66KZwKblg40N73mHpz3vRkm8gzzVb9VEao
	5DPrTwUykMmgPQR/ooEhgT3X82EwR0M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=liSR0cAN;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773976925; a=rsa-sha256;
	cv=none;
	b=aCRKzX21dVWFhe+3oyXnuA9Cs3+igttOUQGKf8/NNCGlbagcyscL5PrHh47AXmCS8RjDr3
	Yw4/6UZFqZ5Cbv2kkk4Cow5p15bZlkjsDMpZFz/G9/kQV99Fcggt6MNwZXD8+gsl5ZXWj1
	XEJaKVGSLyy2jgZqKDRVTP48hoqWedY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FA7260097;
	Fri, 20 Mar 2026 03:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF34C19424;
	Fri, 20 Mar 2026 03:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773976924;
	bh=tNvWcRoPqJmADdDuPWkDyH/P9AXSfH8VPQdU3mljt+A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=liSR0cANMTwkDMdoW2FjbpUZyrAwXp0H7o39UOLvlz5l7mbord9p9g8vzASgXFXwv
	 VkeS2vwN2zmY9Ew/2dOjyqcbOXKC1yHeFyp9mmdPLEmS9HqQ9ofT3qeeqlfZPZAuRB
	 7vuEtGjVkgN2RvYYb9ab8BrhOL2IOBrvRgDgOva8=
Date: Thu, 19 Mar 2026 20:22:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>,
 Richard Chang <richardycc@google.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v2] zram: do not slot_free() written-back slots
Message-Id: <20260319202203.710aa4a4c111f12f802e425e@linux-foundation.org>
In-Reply-To: <20260320023143.2372879-1-senozhatsky@chromium.org>
References: <20260320023143.2372879-1-senozhatsky@chromium.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1B4C3A0003
X-Stat-Signature: i4m3pe3xtpa4wrw1k5dk9kb1du3icbam
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773976924-593112
X-HE-Meta: U2FsdGVkX18IxxgVpUol80Tvn1HSfmUh58XSgrAs7CFnJ4E4AMNBup0dwk54vFYeXKZ0gufPRUAfNK0UTq0gPd3cT4QC5xN1RZKi6znw+nIKjLpJABVEfGWBT2IlLQ1tc+dRELWBkBthzo8o0J6MnMyGKvpDkgebRbDynYp4CPgPd5yO8ce8nKWl/fd1dwjzppHiSTjroIV+xp7fWnl3+G7UE7xQ4j1kFe1vuESiZ0K0JfOuatVvFe/uQN+BPJmzOx0iR6K047BZVZSdoB2q0+7oXkmfgxZMqTAkdvVeR7dtnJGUezvD/LKBaf51WWymwN/BjUozxA6butTVBj0Fg2MbAB7Cy6ftYUZGNdY1c3Na0E26QwsEvsJSBWrwVSZXGgdIMbB8UHwAHmh3JdaKhaXmVyMhRlXdAa48TRsU66bapEr0GoYqwd+oIiHQilJB/alT28Slj2hLUIkBA9/q87NtFUFxqKdQbEpKOL59db4kWPjKVjZODs9FGLUbk35llrXkk0fF+mLKnBNrgf7gXgI6vxwJlddNGxgSH0doS/TK6liT1jZrxM0RcPABIEhoUNSbe1d2Ltm1FpWd+N/5ToL4wApeswBBn/lGpOZGrSnBwCIhB96AGhs94oB7vl+V6l5pkLgP4N7DFkNGKt5J2JW9vFwGJKYiNk5MujyyxlGghPC+3/cXtuG4PDJbE3L48iE9q/YlEjRtolzWtEn7iUYg4sUwxl1d1UjnM/g6GH+btg6HWeRbP+u+CUAAU5E5BQYf6wO1N/3orD76OB5EQ7KxJVLznoX+HtqKP0CdK+q5lXCrpmk+IU2qiCyeNPbxqbHJs5f8D4Wf/qRe+cKQvQRYA/3xvpHkDkX9Ht1zaeDZkyq8f9vJXkYdQMPJ2pbFYEQRoRaHRaAuNsuZ0Fn0HOsGCSXXLoPvHRvAyEwe61ycfWo7FEASvU1rG/rs13OSSB8hA3xy6WCi0Royyz/
 ljisQ5RI
 6kHO5EC4LWflvD2C/cw5FzYq/Zs8Tp3JUcVaxbadwcstTKGFU72e+viR32/3WqhfQEsad9A9CDJRmRf7vmPILbR0xLxdnmJXhziTmIHgaRT5xSFLQ6ooa1OPPHWJxwamT7r3LmDp5+9W7/zhmSLLJ04jhueHn/T6ZsBy2i8j0IudneLTzHqinSbwrWAxG/jRhOAqhj91p/X7ovJ774dd4kEW2wDkOA+/S5gByMlgwAUPLO2iDxO0PI7gl/0ePUuVylX611jOVkpeZ05cM9g4QQZ0XsYPJn4AQRkpF/OmNRpmrLk+A1kxLQpdOUXFEVAwQBxlpNOVONkhWTDFcuzPPxwURWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 11:31:31 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> v1 - >v2:
> - Updated commit message.

thanks, I lazily updated v1.

