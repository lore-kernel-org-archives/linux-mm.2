Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A7CFC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42C616B03A6; Tue, 18 Aug 2026 00:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4049F6B05E3; Tue, 18 Aug 2026 00:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31AA16B08B6; Tue, 18 Aug 2026 00:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 073B06B03A6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:50:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89662A3094
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:50:13 +0000 (UTC)
X-FDA: 85113163506.11.192502D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id ECA7E1C0006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:50:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C7skpJ8C;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787028612;
	b=PIzEqrmhG6BC4wtBTeH08MinOcbr5ZnLK0p1JyREUbqAY+zg2l4WKk67x0+n9BydD9IADd
	CaoIwo5+Kdfj41WUYxoq9j/tOgdmLxHw0bUfpHWdqGirJex8zaZZaHqGJGctixpwXKaG1H
	DUZbfmsIhqFP+omaV2hlwlCJip+1JF4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C7skpJ8C;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787028612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtX13R1ypyiRL9Ftkla+zVGEDE/fgvp5SvpwPGOAv0Q=;
	b=Dj/V9EqBdKgj6FuHyKMC9kbfIXwVM6elKbcIyfW+NbwR5/igVCSNAL6PB7IjFCCEMBP+El
	YI8PsP3h7AWH7dVsGyBJKmcCEUkUUK1MDXlGb4SsqrEcV25zslJ6pYbhwBSn5Fkehtcyjx
	XdSjN7bzwmBo7G6wy2qdeNoyuwjn8WY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CD4D413B1;
	Tue, 18 Aug 2026 04:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DA01F000E9;
	Tue, 18 Aug 2026 04:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787028610;
	bh=mtX13R1ypyiRL9Ftkla+zVGEDE/fgvp5SvpwPGOAv0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7skpJ8CRdoWeL9Xpft+bSu1GIg7/8RxNkaxcxxIRGu2Kf62eO7InNqx07MbqjFR9
	 5KAKBLTvVJEG03u9nLWu29S2c60OvWmHrJibO7LtuKc8jr4W188jhsds8ho7n0Eg4G
	 ZH4zKHwzgMdCulh/BOUGUoCSOD6eYw8SaXJ/DBsfZ3NNE2M9/2vdCCNwHQMi0m9LcN
	 puHO42CT/syK5qF1qqfCGyY2mLdysSkLUSKHFbxpOCY369NspJe2Mek05XdKfe0YFv
	 l1zfucMx1Ry0u+6coch5pi9FBIGVns3t7tMxcT2RsEhxczIZJUv1tOMZqe3ut9bFow
	 LHXRsXN0a4M+A==
From: SJ Park <sj@kernel.org>
To: Jason Angelov <jasonangelov@ucla.edu>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	shu17az@gmail.com,
	jiayuan.chen@shopee.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core-kunit: test probe_hits handling at region split and merge
Date: Mon, 17 Aug 2026 21:50:02 -0700
Message-ID: <20260818045002.97073-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260818034552.11975-2-jasonangelov@ucla.edu>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ECA7E1C0006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ajpnxofmrppmk7qfwkm4ucrrtszmkr1p
X-HE-Tag: 1787028611-475530
X-HE-Meta: U2FsdGVkX1/hMLSMfMZ/7fq1fhOuDsc6DWbbsagwTnvDbSImhTJShEZLCls5vEpAjDH3//TIZRy6FbZbJmPGPmU3VC2443Vse8h6aavYlQpJoepkgQ4QEfcDn4+bIcna0No53DPlYTS46xJp706C4buHIRXcPPrz9sqchLJ3vA2cGKkRiF7G7A8saK7/REmAr6INSlslaj0iXh+gnPCXEAwWPPTMTiqxs/Bz1XY9hae35NRbqbbvdTOug8+CRl4Wv/C2Ss1cHcxJOAQ5OShh4v/3RkZBiN6SbSkEVLPILKFYOnA8VBuL49GYci/c5HxDFXgH+mdks4UBroOGY4k6pCOYmVewU/yOPMjravLdDUHIJvf9Px4LZOBqbevkd5BkwCs+ZOq3iigQ7F/TRsOIDa46IsqVCoTlHP7WWYeLRQlLrNX5HjFyAyrgvW3Q3oCZnkGtme7nfuggVPyniKnKB9OyxWfvil1Q6u3C5raRhV4w+UyJZfViMPHKtdMp0qcP3jzHSnO9e6njq/cmuZu3xvKqSzGDMyH//UEt8d1t1r3QbaNWGsGGbU02nTt7WZxK+VT/hRgmFdPv1QvWhTmaY75KyMwxiyfEMg9zKYsZCfeZYIYKf0o1La2KnO2z1jXh69mG7sP8fTglZJ5p/XUxpVsiU7+Psg9AdOoEn0eYXEMaA/y2xVelDAhrRNLJWMAyeu2IdjyNwhCXq4S1OFMPO/mwGcz+oXGoe/ReqTkpOmjAp6FoWfFVU606TCLo0SLC4AGZam9g4wNzHRHL2OlA0hsnHaq29fAGoQWLd8Hj6QNUsuEuEzBXlAIwtn8l4ZfD79xwySxG8RTB0Ny04H4CUVhFyzg0Q6Xf2vwTofJthBCWBL+Qv8s4Obz3qKpMvZgLrYqlO+FbTL0lx+OcVLZ+G07Vs3/DlZAleflxg7+rlrenhJs5WaYoaw7kYTSZ4glOILBDRZ7UCZaiBF6l6Ve
 pJ90Hymj
 2ONuNBafyV14B7F2li1Nth0fUnvxyJhtg/7jPAGUA/5Db+92Z7hPPwnaXtGQQeQ+MpXuW1qH0n3gfMzF8YRxghQ6+Wwyj8ce5JwaA/BdqGqURQwMAj2hJ2ZCM0skb+OMvMf/hdi7ZxDr39M6T9PgJcKzhTf20WDTD9+GNBysmJiHccczU0vS1/m2sMt+QJgLjHMxjAjfql5AZbtMyuUTqHVAnorAZ1K9bVPBABW9lnDMqJ9/Xo7vggtiS2zXSI5jbOk0XXM4TG31I3OoQ2pm+HxVuXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 03:45:51 +0000 Jason Angelov <jasonangelov@ucla.edu> wrote:

> damon_split_region_at() copies probe_hits[] and last_probe_hits[] to
> the new split region.
> damon_merge_two_regions() sets probe_hits[] to the size-weighted
> average of the merged regions.
> 
> Extend damon_test_split_at() and damon_test_merge_two() tests to
> cover those fields.

Thank you for adding these tests!

> 
> Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

