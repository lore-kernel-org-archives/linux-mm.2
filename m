Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 055ADC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 05:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FF096B0005; Sun, 28 Jun 2026 01:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFED6B0088; Sun, 28 Jun 2026 01:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79DF96B008A; Sun, 28 Jun 2026 01:34:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 549346B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 01:34:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD6A78D227
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 05:34:08 +0000 (UTC)
X-FDA: 84928205376.20.E60F6EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id F1607120003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 05:34:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=q9AWHfkW;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782624847;
	b=H2yOpOsIco9B2LszfPMi8NB6ExtnqSwwCsizs9Nc3a1oy9sim1CLGfx3cyc8Ttx8WykK4f
	JnJUU9sb+8pLWIF6wHoxY8NXVW7H3JcxQ28Rci91bZRM8cK89cWVs37uP43+GK6aMxfkt3
	q7uvuh1QsCGr1w4gj8Fj/w/RW89FC/I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782624847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8GvqtPsONGiqrdSgng3Dl86u7BfkOlwSjotfA+CRVc=;
	b=eFnz621/8ZVlpf6Eqmy/+zT9fNKNX6YQ77OpLsJ1HHqqp2TewSL1bqI0E/PvAlX6LT4O3m
	qO1wiZZ91gi1o4Nizsx2Fg3BiZ0eYuoXrVnsnQc+4eYJmjPE9rAyfMFRciWRWcvYboVTC0
	8IybSEGSMDkluFUPQZmYJD73K4GBpCo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=q9AWHfkW;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DA1F601E0;
	Sun, 28 Jun 2026 05:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C321F000E9;
	Sun, 28 Jun 2026 05:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782624845;
	bh=U8GvqtPsONGiqrdSgng3Dl86u7BfkOlwSjotfA+CRVc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=q9AWHfkWK3xyQiwev8Qy9xYMgHiUtblF/aXyVNjeozZq3oC7HZUZV0RXG5dmrZSfU
	 Q2A7Wwign3MChDNVu4cyloKW6zTvUeoymXR646u2TO6eIQZ3iKz5jbT1ltsUah/zj3
	 0qRwmI1KpMm1lr3DOLWSOhIGECDop207dPOPrjpM=
Date: Sat, 27 Jun 2026 22:34:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Arnd Bergmann <arnd@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, Justin
 Stitt <justinstitt@google.com>, Ravi Jonnalagadda
 <ravis.opensrc@gmail.com>, Quanmin Yan <yanquanmin1@huawei.com>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev
Subject: Re: [PATCH] mm/damon/core: reduce kernel stack usage
Message-Id: <20260627223405.3533412b4010b6ce658da01f@linux-foundation.org>
In-Reply-To: <20260611135608.66888-1-sj@kernel.org>
References: <20260611125704.3386176-1-arnd@kernel.org>
	<20260611135608.66888-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: am1nh967mcajojj953pxoq87ukped37h
X-Rspam-User: 
X-Rspamd-Queue-Id: F1607120003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782624846-555092
X-HE-Meta: U2FsdGVkX1/lxfXMZfk2KivgHGvmJHUolB0oCLC8gWqHPLyvnWDoe4fCICjb/VAKqMne5euOdAu/IKU96igbVjtvmdYKKtCjv93p3nuSVpKi0f0rFHfzM0owVxay32mJKx/SU9kn91CgSVtxcxtfrAbNEoM45ayj49Yx2ced7DpXAKbhG6vwzYjbb0j+7znIADybCB4q8PY/DxyNwo8lruzYEnzs9vZFyJZ0pwkhCsqdgqeLimo8kP+wN3jlfx9nKfUD4qh0YWp6ejZW+iBGR/zP/374gAHZs/wjmYqUo/ajd0nbL8jzoJlvIqhKIcvSbdtoiQdbM7ks6om6N1BmElWE07kZLykyK4K6IL81NbKEAj5R0ALHBiyvfhMZz+VdpJjh2T26I+gdBAvhEoJ/kSDzkegatN+bQMZfqg9EhntIRB6Tkm8jGr3zUSlDNZSwFJq+H+P9W6csH/dR5vLvgHNfhxslTxfJz/h0qm0nCrR3ED3OW0JeofEncAIF58i4EGkqdDrmDvW+Q/kLHN1XMFHtEyBSDyGuJqNgGzRMdreaAg/vGm5OGvoYhWh/QUhdl8t7iMOBvLeRYzB+9W9EUVUOVorUFfdL3fj3686F/KiFDFLcrWTExDLJR3HEDEC2vozS2EKc0UqAlwTvGC2QjpwRiuu1Na/fJdrFqsdChFr7OxDn3dq8vP8pi/YU5u+jam15vqBXhphGjUEDtXW5ml/n3YcgtSdd2m1MbjRPjoOu3xheQajRYkroqZEz4BQ+YjypIAhgyBrUp1CquzNpH5+R1RizFzWuR6jwlotVqHRy77o5QPuHtq/DAq41cPagES7uYSvRmw4yzT+edaJVVf6giFvuSKiv2/L1J184v1CSVzFh6Y5fIlGeXZnv/WFmvAzFNrHKOKwIS2nftxH64pXR4LEFdAY40Mst9tww//5HoK33PAn1Al0wdFO0m6J9VwluwOCdduyte+MVkwY
 1hB4b+Ux
 I+ETBRMd9mdL1Vw3W5U2IbyOJXyp1DKHZQ5hBHjOZv5ikFqNb7piY4/q6j9cDlrOYmdhXWCkp9qE8AQa2niCe7cQZp/ItDYNuymPXJ3a0gHxknECZ4wZ4cK+dxT7QikaVderX4SMPR1nps3OC+PPeAZgVQSJ8rtM3m9TRXEyZBjuCPh55D1FMS0n6gBwTWWo4GI4lpiGKyciKabN55215XrTo8jK5y/7g3XzlQW03lYxb80/QkTV7F9FXe/qc8rKxTVJitnMPRJ9x+Csw7tLy5w6U9sdSch/3jMfKE5cTj1A6ZXLWSQmwVIEETK7zJhvIv8RVpBMORdnOMrWI8DCjwG2tPGwKQdqnuAVpWMdEgL9kuOwHR5Y23R7nHbTUcUy+WuMVopNZ0D4IhtX9gQql36gOiu9gBc3scRndUrkVfmIlHuw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Jun 2026 06:56:07 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 11 Jun 2026 14:56:57 +0200 Arnd Bergmann <arnd@kernel.org> wrote:
> 
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > The main thread function has recently grown to the point of
> > exceeding stack frame size warning limits in some configurations.
> > This is what I hit on s390 with clang and CONFIG_KASAN:
> > 
> > mm/damon/core.c:3440:31: error: stack frame size (1352) exceeds limit (1280) in 'kdamond_fn' [-Werror,-Wframe-larger-than]
> >  3440 | static int kdamond_fn(struct damon_ctx *ctx)

Well cheers to s390 for using a nice tight stack limit.

> > The largest stack usage here is inside of the kdamond_tune_intervals(),
> > so by marking that one as noinline_for_stack, the functions individually
> > stay below the warning limit, though kdamond_fn() itself still uses
> > hundreds of kilobytes for some reason.

Wait what wut.  This cannot mean that kdamond_fn() uses x00,000 bytes of
stack, so what does it mean?

> Thank you for this fix, Arnd!  I will also take a look in kdamond_fn() to see
> if there are more things to reduce.
> 
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 
> Should we add Fixes: and Cc: stable@ too?  This function was introduced by
> commit f04b0fedbe71 ("mm/damon/core: implement intervals auto-tuning") which
> was merged into 6.15.

I don't think so - kernel is full of these offenders and it will be a
long and painstaking process to weed them out.

