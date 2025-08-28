Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23EEDCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 02:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC1D8E0005; Wed, 27 Aug 2025 22:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3840B8E0001; Wed, 27 Aug 2025 22:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0968E0005; Wed, 27 Aug 2025 22:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 14ACA8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:47:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B021013A3C6
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:47:12 +0000 (UTC)
X-FDA: 83824629504.14.823EE3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B5A6A0004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:47:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cOfC1CjP;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756349231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KO4nXDSpysiBIIpgDqsNG00pGKq5i+L2iTJbgRczwwA=;
	b=GA1I2xiThylMnYU6VcFZTJ/f5MT0SDeeSRCs/U+sTFz7b65uGS0TZfosw/BR/DRReXnWnu
	4DRXNHHoZ/blkTR9t+uMAUO3Z4ZJkSkmWAV9HX62SjghwvILGsTdhTFnMuIRepWvNY0R/A
	S7FGTmVPxDpsy7fIejkFGkCH/3stJQo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cOfC1CjP;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756349231; a=rsa-sha256;
	cv=none;
	b=pTlTALSPBMmn4aALEAWUSkHI8Hexpup/sNuy+YfAQV/Eq1+UX61mDmTsFAa2LV5XE6Z4VX
	zYcjFU5Iw5HFUoK1AWxnmc0MAX5xe/E0IUqkh//JQaIExzHqvVIw1SqQx1LMl/LewFsAVJ
	qx4Q+8GEH2MWqYASyytQ3Z9bOkfrN48=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A8BF1448F6;
	Thu, 28 Aug 2025 02:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDC0C4CEF0;
	Thu, 28 Aug 2025 02:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756349229;
	bh=HVAspzzIyXQO7ejlpQfZ3LLojc9WoAMq6Oq10fW25tg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cOfC1CjPY1XGtl5QD0Ms8YHq3PrbKJ8MQ1aKaktqjL+o6lBig9vVsm/9DATHWYbJW
	 4qq4dLnxEwou4MXf9z76CFL8q3pzhn9Za8s51czlHSMP/zBhAw/AObUXPYHrPQlLDY
	 /3CovCY2ev42W0eJDr1smcb0YOoIuippJ13c1C90=
Date: Wed, 27 Aug 2025 19:47:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Max Kellermann <max.kellermann@ionos.com>, david@redhat.com,
 lorenzo.stoakes@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add `const` to lots of pointer parameters
Message-Id: <20250827194708.a6a87ecae6a992b4c92b6451@linux-foundation.org>
In-Reply-To: <wmxlcvxqx5qmkzpk6x5fducmmv7giget2nwsvspw3uouufngvs@kxoyppwsyxrv>
References: <20250827192233.447920-1-max.kellermann@ionos.com>
	<20250827144832.87d2f1692fe61325628710f4@linux-foundation.org>
	<wmxlcvxqx5qmkzpk6x5fducmmv7giget2nwsvspw3uouufngvs@kxoyppwsyxrv>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1B5A6A0004
X-Stat-Signature: iew68y65bei3jp3abfu9myzpurtbcfst
X-Rspam-User: 
X-HE-Tag: 1756349230-786636
X-HE-Meta: U2FsdGVkX19mWs8LzQtLQu2YUj8CSHGLzxShH9UBhjWiHZPCETfWmyZBgMgQnNolwt67ciU6FMoXa2OSjJMFFigeP12F4Xc7WiQIvxBt2vQRnTq27RLvbHLWAlTSELBM9G0b246xL1cud8mHhfHjx/u88aSZabiUibcWknLsTnBYADWSArzk3T6pJp10ayPdQKga17Igb/dfJA71y7dpcQG7yXlqnHP0uECc8W9Ccb5qNWHS/NE85mmk/zO4pb5Q+hs0Kedik03i3pROMPKEFBXCknsVx2+7jPm0q/CobKiFS4LGvPKs9BFhtBHip/bT0kU4HvDQOY/w54FPwv5dkGKRR+fn7CqlGdKHl6hZsziUmhnUIcLT3WPa7EWtoPPT2Hc3AtvMvXDLiDvw8Iio8cxwqjUN0IZwckj2W550NGE9zJto3VtovHUXWS49nrK+APFOeQbTnaWWIG5q87wlfm5nriUfNQCC0YQGgxP+nmxVYbZZoNa2Gk8b2MqNwVfG7GK70Lodxoj0IJsG1LVF0q3G3SeBUoz9X8bqHgbofPBaMASVEfUYPqv7A5lPDVZyNwncAM6hE22FALQ8u1ceUryFp+NT2qooWUQxy03zvWoItWYcyLUR7yQBTHCsb0J3YWTMyZlXmsnPWqiEFxM9zp5Q0ZSQLWv4r3mrl7rFT+UzcBxR2hw9dFOrH9V46u/ZHPBkcweRg+TUcJLUwCQHcxR6hhy5GYLtu3SDWiYo7nPUacnWU38eem7gUdkJ/Djx2r53wk4L34rdLuOh9OkfBYs1XEPHKq1oE2b+Yal/TQwDHmk+oGXNYIcQ3UzkwNgmunJ+wU2iSZSQp29awHP1+4RTs2An7PU3Py9oy6BhYtvqT68645JezD5Nd2Eqor4r+hDyTgRWlBUuXWD/Z4Un0wD6gUtK0D6mlu7xR8kStyg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 Aug 2025 21:48:21 -0400 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> > I'd actually be in favor of making all incoming args const (C should
> > have made this the default).
> > 
> > Because modifying an incoming arg is just obnoxious.  That value should
> > be viewed as part of the calling environment and should not be altered.
> > 
> > Try modifying a lengthy function and wanting to get at an incoming arg
> > only to find that something in the preceding 100 lines has gone and
> > messed with it.  Or forget to check fr this and get a nasty surprise when
> > testing.
> > 
> > Not that I'm suggesting that someone go in and make this change.
> > 
> > On the other hand, it would be neat if gcc had an option to warn when
> > someone does this.  I bet it would be simple to add.
> 
> But what of the lazy programmer that just uses the variable at hand
> instead of declaring another one?

Sure, I'd say that's OK for a small function (home-made strcpy) but for
a larger function, expecting other developers to read back through
everything to make sure that Nobody Did That is way unacceptable.  It's
laying a trap.

> I also wonder how this would affect inlining choices?

I'd be surprised if the compiler didn't trivially optimize through such
things.

