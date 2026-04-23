Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB3D2F589A4
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CEBA6B008A; Thu, 23 Apr 2026 08:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37EEF6B008C; Thu, 23 Apr 2026 08:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295356B0092; Thu, 23 Apr 2026 08:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B26B6B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:12:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB4D2C02B7
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:12:49 +0000 (UTC)
X-FDA: 84689709258.10.E6299EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0055340014
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:12:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="a1bIpr/O";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776946368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q8dARveY5eRJRzeLX5WCEVF1Vhc1Bq5zRZWYA55dV20=;
	b=bvMHqsSoZ5xTBNTA+EZWDyhS1UvJqVEAFQxge2utb2j0bZpNHt/UYxry0vL+PaksQsEGaF
	8vVVlm0WYwOG84nqfiwGHVsXZgsVs/T51d9nXwwG0DrXlF4+cDTXvAHxDVpvLAKSL+Zr6Q
	toQEctKsMrBaeleza/Jq/xk7Hay6vT0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="a1bIpr/O";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776946368; a=rsa-sha256;
	cv=none;
	b=MBUXd1DFUSTjK2q6QM0M3RprOQx1P2lu+3oA+KeuIcLybib6cczQMWFXSW5seufIh5BbZR
	opsAbnl4mlWgjigarEAW6hPgmiqvDjkch+0y6NRwE0uPqcSDKDARKcGNYVEGYTpr+MioJz
	JWGKZlQSYOOArijSNlG2QrSNsHTS5VQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E8F160125;
	Thu, 23 Apr 2026 12:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6364C2BCAF;
	Thu, 23 Apr 2026 12:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776946366;
	bh=r2asbMybGDVKY94ODHXpQXCuLqqLQpPqFVYp/o4uWKs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=a1bIpr/Oen6eV+OGCwfZkaptIFNISLzMXthuMTOgLvUAF4LUfRj/k91KiWOGGT/LS
	 j0UXoF1AMnV6JTTk7RXRxn9wtL9v3a/poQo0LWs2/2jna897LweCTnFsm4s4WDGq+O
	 iT0rfOuBQlfeMRYbtH1DMAKp8+mYadD0IJcQ68d4=
Date: Thu, 23 Apr 2026 05:12:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 7.1-rc1
Message-Id: <20260423051246.5de8968ca017eeb8f053fbff@linux-foundation.org>
In-Reply-To: <20260422-aquatic-chital-of-wealth-8b7fa3@meerkat>
References: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
	<CAHk-=wjMroU7PofBOC52f5u5bTjTO2tm5ehycf9evmjeq-hq3Q@mail.gmail.com>
	<20260416011820.18f5a11bbed7fff54be761e2@linux-foundation.org>
	<20260422-aquatic-chital-of-wealth-8b7fa3@meerkat>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0055340014
X-Stat-Signature: zxdqun9rye6deoeqegucfzzenuifr9oz
X-Rspam-User: 
X-HE-Tag: 1776946367-322098
X-HE-Meta: U2FsdGVkX182NuBKt1zddlytFBRC/GOsRSrvpHmJIX2nlEeuVEpdaNdYsBFpova0rKUWjPP0wWx45YveJG4BFD0+6Lqu/cevzdFskCmKQUvYXmH9LlCWYmtn5MaHTcejI7FPuGNdzxjCPILY6C1CXnd3CZTe7SU6lIuz79n8NNmwC55BfvazzlvtNFcyOzfx4KzWhpQHtWWqwA2ZT4APUbTe0AsdIKN0bM0INzpxarHJki5KlhPUH/oZcUuJ7Fi5DncM45otwtIqxBPM69oFjCpgznCETZBfdqmVTRHq6FYSS4EK0PMfle1n6FZjG6fxHuf7eDadisY9DcxZN/VRq6hKYUsfOIHz/MZ5viWDO3Hi9J6OqX3jrg+o/R2EIg9k3unkHW5jMAbQrErBkevG8jifFSTx6Oz4CCrYrtbN6jruK0ggWe5JF3rlkPr95WsgJu3YVk42YXD5JmIrG9FsXJVpB0f7m1fgD1+2hfOr7XaUbUalWkGIYV1vA1msAFpWECuAVgnnCVc2mTdNkarvrBz8rGMOBBtVGA5OonSOtiqE9ctnm4c6La9ScYNzw04bRx68uR/FSy/fiyZR6GSdgiXOTEHSUMWwLUq08a0zfOZz9gIPcCzDFtfS850/cehjJpdcK5Xc93bquIFDqLQ0lg4kku+aNBN481PTFWU055prjeRFqZO7Qd4YuXWJhlTLufYBLpQqirY2P0SXSlaiqPJKbcJdkVxVyamZq1G8idM+v+93RShe4oyKFYoEKQ2+bQ5R+Ez38s+zJ0U7c9Zh41u3shwmnvwENkGgkk9EXrJSukqgB3dFnfun37ucqmL9P8oTkiQ9JZ8GQguP+mB781jFdL1nRtZHEmy9RrREdbl5Jcs6YpUrIiIOu3c73hx4dyZUlTTn/mhyZfkR7e1TTNt+cHuSTTCprNwkbIvpveT2q5Erp/fB9nQSmJDvoyN20XExp83+z+26IMRPpW/
 /Ze/ibLV
 i1cg+oel6Eyuytkkse4jJ3O6CWirfsE8NOErrBde6zSpqqpDsCSWnoboBL+jnQRIZmobqaBr7duDg4oh65bGH3Z6T8IoArsVN6kP27Z+A2WIgvjPH2XPNCm6oPX8KHbYLy/KV82WQbYIwiDkh76scEqsZXZ7hqkgDL6hBbsUg4sbNc3IQvqDhuLdWp2gp/a9MAlZ3f7ITT38sHlzGqoXtWMY81knFgILrqE65T5NzPbqI+Epud6ZPnXxL0KVu+uXEUURmrV14WZ0op562kFlYJiBvV6hqTmKCggizw5F5vQ3vkhBUAfpQJ5CXkytCXVfvUwCTQkZ1LsDFGhLfCzsrjnMk0EALYCnbPsdA8WN1Y3+Q5crhl8VNuu9MHuXE4hwoJwC0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Apr 2026 16:38:52 -0400 Konstantin Ryabitsev <konstantin@linuxfoundation.org> wrote:

> On Thu, Apr 16, 2026 at 01:18:20AM -0700, Andrew Morton wrote:
> > > The proper format would seem to be
> > > 
> > >     https://lore.kernel.org/all/aaGiDINfnUexT9Px@sirena.org.uk/
> > > 
> > > (or "lkml" instead of "all" if you want to be more specific).
> > > 
> > > Maybe something changed recently, or maybe your scripting for this is
> > > just broken?
> > > 
> > 
> > Something changed recently.  Maybe Konstantin knows.
> 
> It's a temporary blocking measure against aggressive crawlers. We'll restore
> this functionality shortly.
> 
> > I've always used https://lkml.kernel.org/r/MSGID.  So at present there
> > are many thousands of broken links in the kernel tree.
> 
> Well, the upside of this scheme is that they are only broken for clicking, but
> they can all still be found using the MSGID. However, as I said, this will
> soon be restored once we migrate the system serving lkml.kernel.org hits.

OK, thanks.

But what is the preferred, official URL?   Any preferences?

