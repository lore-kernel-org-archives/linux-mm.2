Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4956D37E44
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 15:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468EC6B0005; Wed, 14 Jan 2026 10:46:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40FAC6B0088; Wed, 14 Jan 2026 10:46:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C7D6B0089; Wed, 14 Jan 2026 10:46:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 205346B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:46:33 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8C2113B41B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:46:32 +0000 (UTC)
X-FDA: 84330996624.18.E18F66E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 51BC94000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:46:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rs9IGEnt;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768405591; a=rsa-sha256;
	cv=none;
	b=zlKgkYBoZ7iqpeLYOofL1BCauZHu7lDDbfWmhgDYBqZinl9s5J7VBAvWCGuasJKjy4ADMk
	VkugE3Kv9e//NtJyOyxRg4xwXRxIGUxaR2xVi/tOoQn7QVlBn5/GIp+BTaBuoPCPNSsZoF
	cooSFB8JQHVSDzABI8O0CmZQOgZMWMM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rs9IGEnt;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768405591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KIT4BLkFfLRhaZKjfa9PuMhoLY/dRz2awcqlRxIqRkw=;
	b=L185Q0wS7zhmUmbvwbRL2IRbvu1ItTKNRIAkxYQlevw/7o0cluG8VTSBkV4aOK6Xygx6YO
	FBXZRK5I4ekaGthQVwYHR8ktBU9BVqcx7YyH+m0Kq8YfjlQJzp3HXuJhqiX+BR8yqL1xon
	dP8BUkYQTMUBub0DRKoSGvfWkk5uY40=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CC036000A;
	Wed, 14 Jan 2026 15:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391DFC19422;
	Wed, 14 Jan 2026 15:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768405590;
	bh=j2ky40jno61TnJrLoMTlC2emFFzgQJSeqNa7tzJbpMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rs9IGEnt0mEVXhJIpYAUo7LYNmJHYh8psDGVHFS+qmbNyYzpR12tFbsIYwBVBmoeE
	 JtKjTxlne79AnOLUPHJypfdsBK2FR70A8gZsytebi5Rugv1w1pIpGz1Ykuaz9BN0zx
	 TrACdWA6osRN+Wv93M+3nMR8iQy96ubYHUB+u6IMvGJdZF0p1mjHsdJuNA94HUbzaX
	 zjo6iFbABsrnLIt3dA3F04LeTKl3yGlhNv9H6qLWEOn/3drVyFnjhEmmUpn0L/Zk23
	 yChV/wTh76m6m4+ywO11qtnmYiWvwDP33ktWZFG6vbz8JxIk3U5+x5onqrlM0Z/MWW
	 FO4ejJZBtxhxw==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rgbi3307@nate.com
Subject: Re: [PATCH 1/2] mm/damon/core: modified and tunning damon_split_regions_of()
Date: Wed, 14 Jan 2026 07:46:21 -0800
Message-ID: <20260114154622.100466-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113121646.31441-1-rgbi3307@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8yert9hd7hua4qqoxr1u3jin3ydrx65a
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51BC94000D
X-Rspam-User: 
X-HE-Tag: 1768405591-257315
X-HE-Meta: U2FsdGVkX18WA2eBwtn1PmJMRyWGDeQubHeHPQHbIbKF4xdXsABfOjPcmu8ufcX11aMmg/Lxl0q6w/yf4ncYbtmbjESGdJUYnktK59Y2usNiTIL2duU3a6jNFGGjXPm7m/Gxf2cwMYInL8PNby0+8eC0GWxJypN/TpScxvlZlPBpobyMqlo8z9DUZVMWz7keDCr0fW2pyGzmj6IjeN8uQ7bOxVWEj7aW/bnqGlsDiaM19jHgyudG4XapALP1DtTYx/vtzJA4WiIXaCxaMDKfNZb6zNNMhhoTmeB5x2/drAkS1l/qWzvQ9GVpK8kZxCJRaZzuuTcGp4Xlso7/RzbSSNhBiag/e7b73MqBL1z8xbAVBONPZ3vVRjLlTlxeC5EnLkr7qLHmJTO+Hw+y7S9SkHtZwGwuaHTG6KHPIF6PpWkwoAx02PXsVsnoT+Zv8G9i/J9bAeXXueAOTDO2VcqmDms+ig1oDg2dTdhLxNr5g+sEaTAkLISjfOtv2hDeTmTj1X6HvbwP8tCKrCqRiApnREZqr7/50UkeOWOFmIWozyvENTFJw5hcKJdQ2UW5Z9A2yomHuCZEmnNGnt6oPaUIENEQnMOA10EJjt5S3z1Jr93y31bsiYzX6X9al6jifIB5aWT5Fm9GtLWz1iMCO2cTHt4OVDFGBOz+s861NrcQ5+sAYhw19tHdrV4uu+wMZOINdJWYby0xHOYOQybcZy5BDzdYeSBCSKiEZ7zV30px5bhTErsd7/vkXivSnB3aMDNaRPK+79JOUKQz7cx/fPtvGtNvfTgef4Df9cpE9MDPT1TCax40F/9veEZv1a69UDAqPpuOQrxzVrEBrdLatGCmJws990j8Icr1RkFMaJArHwWSkOCCzyfjYpLVRORjPvMpR0lggYvssrpN+DTb16RgGmfjQUVF1sI904MEFhFggesIVlifcWzRMIGroZNnOz1F90DBI02bdlLgKLlenZ/
 WqpYGOaV
 tk/Do
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello JaeJoon, thank you for continued interest in DAMON.

On Tue, 13 Jan 2026 21:16:42 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> Before modification:
>                                                              sz_region
>     |--------|--------|--------||--------|--------|--------|--------|
> nr_subs:     1        2        3        4        5                  9
> split random:    <----------- (*] randmon        LOST -------------->
> 
> When dividing sz_region at rand, the random value may be small, such as
> 1 or 2.  At this time, there is a problem that only the front areas
> corresponding to 1 and 2 are divided, and the remaining back area
> becomes too wide.  If the area is too wide, there will be many missed
> address access judgments.
> 
> After modification:
>                                                              sz_region
>     |--------|--------|--------|--------|--------|--------|--------||
> nr_subs:     1        2        3        4        5                  9
> split from   <------------ (sz_region / nr_subs) ------------------>
> 
> It is recommended to divide sz_region evenly in the ratio (sz_region /
> nr_subs) rather than using rand.  In this way, if you decide nr_subs well,
> you can logically match the number of divisions and their sizes.

I was thinking about how to reply to this patch.  Since it is taking unusually
long time, let me add short comments for direct future of this patch.

The existing code uses random() for a reason.  This change might break it.  Can
you further explain what was the point of the use of random(), and why this
change is not breaking it?

> 
> Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>

Unless you can give me a convincing answer to my above question,

Nacked-by: SeongJae Park <sj@kernel.org>

Same for your followup patch [1].  Btw, please send patches of same series as
one thread from next time.

[1] https://lore.kernel.org/20260113121731.31468-1-rgbi3307@gmail.com


Thanks,
SJ

[...]

