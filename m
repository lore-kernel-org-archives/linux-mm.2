Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2065CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7E996B009E; Wed, 27 May 2026 07:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F686B00A1; Wed, 27 May 2026 07:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44F66B00A3; Wed, 27 May 2026 07:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFA966B009E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:33:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 484FEC2013
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:33:02 +0000 (UTC)
X-FDA: 84812988204.19.D2A621B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A65C4160012
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:33:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gbZo5//S";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779881580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gJ26zK78eOdBOgt7O7AAaGauSQe0tx46erorLEnJdk=;
	b=f7kRSyFrSpTiREBlgB0o7Ph7n2/hvBQaOP51e9GhWQBIZxRGxSXkvJw8/pU5NPKjjR2MuA
	bQxxU4Vr4GbcctS9S1QUGMIkuiJsa34qFs0vFxPYl1/SzRG8GDtFtvDWNUE8E+jSJuMC+f
	uULbntGYR5DP047PJF/gk5KNhXztk4A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gbZo5//S";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779881580; a=rsa-sha256;
	cv=none;
	b=hoKTdqV53IqRyYLBfEqy8z9xvlKTiM4lCEOfQBOivSbxDqysmT5rzq7i9ZCCkJfIvQfvSi
	b2NevY7FAjIzgdfU1Ig+PUQNBX3kTXcGs5vysjQy5jqF/rS5w9eHdb/bMOJRgmweyQur06
	I6LpVyP1Bv0Rayvv28gjoRTPcWlScXM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AB95600B0;
	Wed, 27 May 2026 11:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B98D1F000E9;
	Wed, 27 May 2026 11:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779881579;
	bh=7gJ26zK78eOdBOgt7O7AAaGauSQe0tx46erorLEnJdk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gbZo5//SYSZ3Re7PzPSWAssnThka7UKS7VIuBMvgX3Y6legw7Yo0Sw8rL+MuaFZj4
	 KYRE4watjleMRLfisx2wXId8cIT3doiDZN6LJG4NtXq7xvEmjUH/fPMMzJ3WEUmG0p
	 xCjBJumTJIfwCzt3hN9lYhwE78VUVE3Z1EeCUsitw6IUfxh3HU3ZOlpHCUIQ+PqQx5
	 RQNdD0oAbgh3TS50It08QsonlP0ibIPQhMC80HtHZeeU6ikWVqz00AydKAR4Kamkjq
	 vXlFNihcBrWDlTDPWQUhh+aEo0dDvOgc/fv/PxGYhGSkyhYvWh2zevh6X27K7XhuMw
	 /xXOZKyTveS0Q==
Date: Wed, 27 May 2026 14:32:52 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] selftests/mm: refactor pkey test helpers and
 unify assertions
Message-ID: <ahbWZJ2BbR8mmDd_@kernel.org>
References: <20260527013825.1134225-1-lihongfu@kylinos.cn>
 <20260527013825.1134225-2-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527013825.1134225-2-lihongfu@kylinos.cn>
X-Stat-Signature: hmcjfigkpak8y7rh3dgzza75guf7a6an
X-Rspamd-Queue-Id: A65C4160012
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779881580-550731
X-HE-Meta: U2FsdGVkX18FONKq9A55Q5JL15iOl52eMGGsNpt3AemN8wmQlivFEVVGIaBI56nYIpZy8p5h9R1I7SEgbqQd0g1y1Fk3A6cpx773OxwZMd/W4inSVoAUrezDH5xcWfAdTr9Tm/siglSmrcDxbgWShn6WevmN9C0xKK3guTMm0+pyIaKnU9qyu1+7yTAyu2mWVc9jSHm0TXWDghM5UuMGZFj26enrsUb9yn1pvhObO5H5aBSpnKToAIj9fxRt+ismOT8EIJhOuZ0O91F35cXKmAnLq49SdrJtlkNyrPyKGZHM1wQAglQTaE4SlOuRCJ4CKcHk+lwnwH+8vqyttZON68lwf/fv2jyEXyWPKwmSO+lVflJEeKkW6TOrAUNlZnKuOwPs4p4N5xdQEFZyJAFkXodmsaCVLXcvfLet11mkUj34ageKpBhoTCfTlQFSQS2XUEGXOWeuiRjPkFA+Kyjk2gM8R+R2GQvl4FHUtlZvBBjkY3edZnacZWbwId2qiVC3+URONfhf5dnAQ1Rs4XXPkCN3XbIn9xxqCW627iZWQuqKApOr+y5/Z/yRNH2w6lZxmS7rsJyQfdqELPPWQwyuUUMWyYjcrvU9rdxwQlzR5rV7ZNWFnlV+6pL4Q4mORjmFij6LUJYUF15aVG15BJp6mzappIprDqYJ3V3OO0N9G87rqMEaU2kFLKYmGxo0Gig0AbcBDNfJ2Mwgg/IHssQxVh26yB3d8Q7Ea2VQol/TMkpe/Y0Snw4tx5GMw9Dv2t2XKidyYeDEB4HkOQwo3Yw8ZCTcNIeZd4HT7jxeDbJO9n008vKKYmVt0hVmsKwe5f+f0XRyH5qsB8sF66OqcPhLTf/PSRVFEgpgpXIqUJyNE8EMu/TEpQpti4cWrVErq+t0YXU7nFLS90KBjejLRmrMJcaEGxxPhAoYK8IBkjCbvMEx3+yhJRYlRaa5e210NsuF3yf3BTT8oXnGhNi9P5r
 ZcPPJ1ng
 undREpTCCrv9+1OIeDoYXN60hQYXklqsd0c3Lk0Z9YA/EHP0qbFfWylnVqk1M7uOoNTWh66zYiOGeTGClPPgALhlUAKJlXx+A60YDluuN4QMtoe/V5kvik7w9HZzbesgWpen4TS2KIszokBnI5xvz2NkmqQNkD75zYDqdD92PGQgKrBiNypU5pcUyY19kjB56nRthppf2Ug7vEjQz4rVQoz8S5OutI/+wlIZ1Ef/Y3EFd+38IPyKkFtA5UKXrPABypdhu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Wed, May 27, 2026 at 09:38:24AM +0800, Hongfu Li wrote:
> Move shared tracing and assertion helpers to a common file, then
> convert the sighandler test to use pkey_assert() for consistent
> diagnostic output, and add per-test tracing around test execution.

This sounds like three patches to me.
 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  tools/testing/selftests/mm/pkey-helpers.h     |   5 +-
>  .../selftests/mm/pkey_sighandler_tests.c      | 108 +++++++++---------
>  tools/testing/selftests/mm/pkey_util.c        |  81 +++++++++++++
>  tools/testing/selftests/mm/protection_keys.c  |  82 -------------
>  4 files changed, 137 insertions(+), 139 deletions(-)

-- 
Sincerely yours,
Mike.

