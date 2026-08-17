Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A20AC5DF7D
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 22:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071A46B0119; Mon, 17 Aug 2026 18:12:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049826B011A; Mon, 17 Aug 2026 18:12:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECAC66B011C; Mon, 17 Aug 2026 18:12:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C45426B0119
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:12:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5812C160907
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:12:07 +0000 (UTC)
X-FDA: 85112160294.11.44F0E45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B5EF6C0008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:12:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hMOtHPnz;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787004725;
	b=arr2LCW39EY8Wkx0YGI2wQgedvMieufJTaMFNErXprHtoEc/WUTn/ZxLVux4mPJ18EiWDH
	7eNHGNyUsK3l7YyeeNNfXIomjRJmNGPly9b4O/fDcPpkz8eXKI64Ld/xVQ/H4rGypVbqOz
	mYIfjAc7XFo21BJ2kDOm2+GELs/I9QY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hMOtHPnz;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787004725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qDUxGBkk44tOjpfh9EXGkQkAJonIYZKKED1bmZdyP9I=;
	b=dSCiofuVFLyQBiqCHrZ8/cG30CFDLPFLxQZH+xdqRtMk02uWlqv7DsZ5sVQzo0EefWvioE
	zB7yiPRobYNTPE9Eh1qZfj0NSWJzeDQbi8tMTMWQ7n9kCeT3uZiJu6FjY86s/WfZDpripv
	LrL08fI8U8+M1kdK/keowDSYkVdq9xY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F405601DE;
	Mon, 17 Aug 2026 22:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954961F000E9;
	Mon, 17 Aug 2026 22:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787004725;
	bh=qDUxGBkk44tOjpfh9EXGkQkAJonIYZKKED1bmZdyP9I=;
	h=Date:From:To:Subject:In-Reply-To:References;
	b=hMOtHPnze4qedvrdjm0cpkZabhZxEXLK4VPdmuyNtKV4pc/tLykmuM5sdH94rcq4+
	 m3iaEQRJv/0Luv7TMWuXSMzR9ps5wi7Kq8U9wuhf+ebhR0Ubs/63mlDYYo9/Ro0CWx
	 WOLv7oHaIMQu+v5N8oZOHkGfdvOaQRwtyowf6ctc=
Date: Mon, 17 Aug 2026 15:12:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Su <sh_def@163.com>, apopple@nvidia.com, balbirs@nvidia.com,
 byungchul@sk.com, david@kernel.org, gourry@gourry.net,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 matthew.brost@intel.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com
Subject: Re: [PATCH] mm/migrate_device: fix cache flush when replacing huge
 zero PMD
Message-Id: <20260817151204.50749d6a3e16e322e6f05d7d@linux-foundation.org>
In-Reply-To: <20260817143415.60bedb09819d13a2dc0fbe63@linux-foundation.org>
References: <20260817090640.287a9a415da49e3974797aa4@linux-foundation.org>
	<20260817163646.929678-1-sh_def@163.com>
	<20260817143415.60bedb09819d13a2dc0fbe63@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B5EF6C0008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: grqbzdb5xfentjqfdsea7wn4u455ctus
X-HE-Tag: 1787004725-649015
X-HE-Meta: U2FsdGVkX1+u65YsLKExoKW28RqlXHi9TYa62IUP4cc8UVv7LhDYmtmHNJ17JpHv/lxyZqxgp8f1BUZFU7MeiH9WqNiev21XQB1wS/ithXYSb3jQvz5dWIxURAextoGy7QlnkaSae3Kn9XD4Qc2ygrB5hJTwx1LSHbZWsBxBlSUOgxp0QlXpgHjTXTB1uy4hO9vqN3QHV6nH35Aj1hjKUM1HwkZBsebcoVnJ/j+Nd5KNDk6hMqJ6tGEwvyVCOZgtoVpMX2oFqMdPoMOAYxdBJqP6HbMREJ/s4kw1vDd2L28THkWUs4cTobA5B0wIrKaLnzbt5L+uRE9nmOnqI+vwd+tGMvTDt7DryoUTyaMGgOi05CQtMA4s/zxaknRJw8+jt2BFiebvwv+5BvqQW5vaF1vn2M/r+RnXugxNwmgNGCOJuMhPjZSwl+skYRi2URVfP9f5FU23bP7fX3Hob52u6i5kvNZM/uOIA7U+zBDXHPZiQicDhS4iqhZcs8vXd0Czcdqta38JVmyVfiw+EeOKFlsw1GARQAD/AmScMt50oxD/YY5ChLxJE5VNBVDh6hGP3kaEIMREJkvxtWregEXjjdu07tX28+ZgttZ6APjDTg0jkLtLK6dLxF0Kj3aqRRIiwI/uLO6NA4HqtRraCiusWA/icItxecGnLCvuxz/B2KzVSmJIlpbmgvb5iieWXTCRBQS0d9vI85p+idHSsDVUtzzv8uuRJcTFoqAC5mImcHNGmUFPStTGe85gwGqnObmaIwcjSNRCOTbiMp7Edu/3QcXLpz7Ye8RNk9QpF0Vu9SmqoJvKruysKcTc3U/NaeLrzk2Zwt3Xt4WSQVvf9xArG9wzdFx8ELV4bItPSUPtsGIHPj4oyBXVc56ai3B32B3zuEKF8jeZVaescps4Zp7cAVhN7VV2vqlyVbXC36+JtQTNZi8NuKJVeOYgHJvG/p7Yv05t5oL8Mg1qbRL456+
 t0Xe0w37
 fELVeaGtPq4aEA8OQ+rlcwWCmkJQOi0hjxwP6cy2akWSyYB7lKiiRPfQNSCnOjETWhIRNh8RiAtXURb1GIRhHRw6FOuSN3Q+RO5PkxOGHXl6EK/NEITQj8ZzB9SmDtxPORDi0BNlo0wsrbSt9sLjySfNEHEkx/8Ol+WdNC19jDgBJIUGuYA516kPSsVSdT1ttafl07PxdeVWloXY+HASXdXQAX68/12bWKfy4K1s9M/GCM9U0hfiNCr+334QCHRk6LETfQUXjTV1s1Mwnwov2vn3cGeo9A/tc4ilQfzKhjNO5U7vIYcDtDw23bua6f2gpH08/0MOQPiMcN+IfCv6lvq8neNNSYTlerzUqydn8upB3tBmGt+AAXn6IVoFY4+wPFeeaL792yN8Nym2/chSvHvRtuNRc6a1On1cWQotHWaobEtLVjy0HAtpan+aty3cOpV/D47xjUmDYEYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 14:34:15 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> > Hi,
> > 
> > I took a closer look at this, there is no userspace-visible effect today.
> > 
> > The architectures that currently enable ARCH_ENABLE_THP_MIGRATION use
> > no-op implementations of flush_cache_page()/flush_cache_range().
> > 32-bit ARM has non-trivial implementations, but does not enable
> > ARCH_ENABLE_THP_MIGRATION.
> > 
> > So this appears to be a latent API misuse rather than a currently
> > observable bug, and I don't think a stable backport is necessary.
> 
> OK, thanks for checking.
> 
> > Should I resend a v2 clarifying the userspace-visible effect in the
> > changelog?
> 
> Yes please, after 7.3-rc1.

Actually, I updated the changelog and added it to next week's
queue-for-Linus.


