Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F183C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28D836B008C; Thu, 24 Sep 2026 04:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264E26B0096; Thu, 24 Sep 2026 04:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A24F6B0099; Thu, 24 Sep 2026 04:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F20F76B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:41:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 524A5C02B0
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:41:33 +0000 (UTC)
X-FDA: 85248012066.29.72D9231
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B9D4780005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:41:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U/F/1Ar6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790239291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pUnkSJWOm05fY56ErOz1EyuSwZYkIRaW/IFmvgi8dOg=;
	b=yDSdHsSpYI+IeuLjW0Aa/9b11+LUTQUT6Z420V5k1+lWFcIlCPzN40ClZ5P+ewEx0jPWTH
	kUT8y18ztfPKrGLwgvUeUB1I+yxBZxBkZ4B6mKGyQQ6F/etcKMS+v0zAh3LoGIWsjO7q0c
	AddX0p8t+tWwzLpYgQyzKk7huaK1vOI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U/F/1Ar6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790239291;
	b=eAr1wHkEkVfuYbnFguLWFZAtmNcgvLdbODv08z2Jwz6P+smeURyxZq7ioYFNJF3CK2I+vx
	JzA5PuR+gZg/CEWake9QS1VtqilWIc39SRAJN/jbMl9LqUkVFQTHZhrUy4fctHFY19HLFQ
	o5iAccq+XrNNjisJOiRVkaf7fOkEUW8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DAED5418E6;
	Thu, 24 Sep 2026 08:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E1C1F00893;
	Thu, 24 Sep 2026 08:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790239290;
	bh=pUnkSJWOm05fY56ErOz1EyuSwZYkIRaW/IFmvgi8dOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/F/1Ar6Ux8m52QixNR2WaT2CtMJqTUPv68Z/Zsi9/Y6reLgNdovGv9C35T8QC0H0
	 Ic0BDWK+weOwytEjz3h/v1Pif3OApXnhTnrBVxtRZ//gQ2LditMqmQ0FNogfH4U9e8
	 nCZnNzuXvxS3pAcVTwaoiD9uWszO8IIv4D+APB6FIwhJaVPdU7C6DC3qzpGuaYkQvY
	 eNGcoyUeKzDB6htfx8j68SLNTe0dCClRFGhrlzDDf6jH4K33R/mY71LDvjus+2idPd
	 DvjLQ78N31oObM+4Iso9LF8PU01EfmTvczl+hI79qauYigZR3s+GIF6VWelugBZfx3
	 52LPmACZcxKuw==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RESEND PATCH] mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
Date: Thu, 24 Sep 2026 01:41:26 -0700
Message-ID: <20260924084127.3620-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260924075754.6839-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: rzs13o5ijfzhu8jhbsgjakxk3uxinqz4
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B9D4780005
X-HE-Tag: 1790239291-88786
X-HE-Meta: U2FsdGVkX1/whTzy5JnrundUVnGZ/lrDIvO6KUlNrOkeeth0g21qEXrj05giWN+bGkW2crYp+FkD0q+esrgLiAA/g/cZg9x9Ob0ifS4XEhaJD6fIqcdBZ+pnrmOoVPIbUvjIx0NH1l+w7/E3hE/GsFzREKC0FMfEub9iVGKgDtlJAq1rRRvX5tg82WgOOk+ncpo1zSiPRxkUNPpi9qDfLp7AWeRe1QXXkQgPeM4S2D6naaAJnN1NThCyXX+WY8ar1daG6U4AKjkG+XgbSCcYd9P2mmnncP0d49D9ogQm9rHg81Nx44Hx95hJrYtiKy72YUWMI3yAxVunjmqRAU2WN+fS4bD0aaOfAv2JKt53a+LUPW/no+TkiqbpEfu3H/XSTtq3ap2y+gymVl7f85/zPSzN6afv+KnBRsUJn8QiNTRBYUsm5u65yyoJcFgb5JbIK0yRiJHdpMNhJzebcdlZl8p4wHOi8fo6sKZyxVzK3T6VEtHiR/KUcJ9B+gYNk3d9WOZOFlzX3slgzKhgcmadXKJcOKmN/5AKXd1Df8UTCtzAFzNP+bq3QaKcvkWJN7/YfLAm2b4UgesDX/och6cNvGLAoHvoSFxSmZDW/i0CBbUS4TyLDjXD897TxzUvaST9mghHJ8Iiocq/AaWLt4uS36isjvs89/oTAr6D7h/diMiOKo/4/0OoYFM7oWsmsUp51/znsyuAcTyfzffh3XNQc1JlgphwR4rMn2ClLGHQLLbMmZ/U1oDGH22pAvXHx0rutgU9aORyG7HDEwkW/g3GFlb1hbdqlPQcDr+NR8ei7YDX5eby58T3PTBzJABQBkiWPYwp8ZkP+LNp+SKi5kIk0ypEHOEdy56rVUtiPO0BYG0NW3AgJrHYud54xv4Cc2ICBxV+KmLIWXfWNTMZJDs9wT9hihP/69mt+kADRNpQgNNsxcsJeKjXXrMRJmssxRo1SDlupacy3F2AbyWjnZ+
 UpWHVi2R
 xyJlcUPDTmylc0PbN+t6aeeuCexxBkdRQulja0sRXeK0RPNJC6Us+hrRoKXicv8iGqkzztL91coxB/V6a0zTyIQ6NUM36bFxrjeZkGioH0Ynen4Dcpdq04N2R/+VoBma8eXFC2tj9bINJjC8+FHk1tBSwLDsotM+cChzb2KyK+Oh8Sf0MwJZA9kokNhWZbsDTWRF3LqwPTGDsBJ+B63FsEqI+ACU1foeNVhvomZUfer6HY9s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Sep 2026 15:57:42 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SJ,
> 
> Just a reminder, I think you might have missed the question I asked.

Sorry, I dropped the ball.  Thank you for reminding, Liew!

> 
> On Sun, 20 Sep 2026 03:09:10 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
[...]
> > By the way, Sashiko reported an issue [1]: min_region_sz is not
> > power-of-2.  While this do not cause any real issue in this test,
> > non-power-of-2's min_region_sz is not legal.  Should min_region_sz
> > initial value set to power-of-2 value (e.g., PAGE_SIZE) in the next
> > revision?

Yes, let's use a power-of-2 value.  '1' should also be suffice.


Thanks,
SJ

[...]

