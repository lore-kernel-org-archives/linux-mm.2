Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5DDDCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 21:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E896B0088; Mon, 25 May 2026 17:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80FBA6B008A; Mon, 25 May 2026 17:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725CA6B008C; Mon, 25 May 2026 17:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE046B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:31:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA2E31A01D0
	for <linux-mm@kvack.org>; Mon, 25 May 2026 21:31:30 +0000 (UTC)
X-FDA: 84807238740.12.F829F56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 349502000C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 21:31:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fLZTMUYJ;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779744689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waL9qdEIRr0p6BZbXVVpZtKihSWhyIz/3lvf1fgmL+M=;
	b=DjUXs96herUxVJEnHApaPFo6Nfn88etzkMjvW7I+bQbeo2pB6GSIN3W/iCDsgV54lvsDDX
	MRK1xRS43IHBoL9p8/ETlQdDi8f20f4ge5FP9iDFN8aEKh6arQ4fklbn4/z26rwXqncTLH
	SHOXmKLzsyWfIUYr9kz+LjA9PCa9nOk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779744689; a=rsa-sha256;
	cv=none;
	b=0DKz3PTobCrEOv+9Grp9vRUFEB8UDH5aF6nhDZnAMs6ewTe19U5oYXSKJrw42mPliKd1QW
	G/vNnVaksb521ociBOwGI9GLo8GxCNSzxLhk8sbY02sclHRZuD2rQ06Dhc082sZySChC8s
	MFS/C6PTKdFt/aRJ/Jyttvfm5HD0fvs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fLZTMUYJ;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8ACB960008;
	Mon, 25 May 2026 21:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148191F000E9;
	Mon, 25 May 2026 21:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779744688;
	bh=waL9qdEIRr0p6BZbXVVpZtKihSWhyIz/3lvf1fgmL+M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fLZTMUYJMH09ycEyPeoNgMuc0Rh0s7ijAW5+G+0cgZCYDVhKlawXK0eBjqOvTJX2U
	 i/hYHRO5Oigah1iY3vwGOIi6GPW2BxVYaKAholNgvcNd1absnAA1Q75So35Xb3u6Nh
	 Z24+vPjZT4fGLIPp50yOeA9Qe5IDq9AaPL1+CyIY=
Date: Mon, 25 May 2026 14:31:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>,
 Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 0/2] zram: writeback fixes
Message-Id: <20260525143127.9f8ff15e31df71bdb494ab61@linux-foundation.org>
In-Reply-To: <20260525044639.1888561-1-senozhatsky@chromium.org>
References: <20260525044639.1888561-1-senozhatsky@chromium.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: e1tr4cj93of34woeqxjrdkmcx65rcntw
X-Rspamd-Queue-Id: 349502000C
X-Rspam-User: 
X-HE-Tag: 1779744689-766541
X-HE-Meta: U2FsdGVkX18vrmVK+gRX0/aOiRccXS00R+MmCyLNj0ytDfgI5FPz7n7+mFefbzX33uIJh8AdD4a3ixKyPfDqRQnv3rrAWOwUZqOBAiVLPgfNLItB9VE8IFTxx6UeS50TQI0kXwhLkZdWOty+RxUDe4E4CLrHU/6onC/vBsSzq9yILojKlWuQKvIXovg1RKSnr3/vc4Pxzs1vfcI/eBKBeL/QJG9qDPi1y0+XNwA5hAQbGtkXQ1rvlon8+kxRy7zXrv5cbnTeDy3elhyd4omB+Huo8LCVtCG/AoCY7D5u0eozf9+o7rNFLcKxI3sD5oIurmhGZDpCM1u2YINQ9WNXKoDRGYWRiyBmkghh9LBCnmJNfXt/PNc4vZ4Nx0e5vSQ6TXw4ZDmkT9iKhxBj7fl/sMfHa9f20zHQDOtg3ffp6FhDiJqyK60P/Lnt1y8mFd0unPTtdqhDa1jumX1Trwv3fH6IsLiZTfaGlJaVn8JcyrkUaUMFkHYDWyBMm0yJ4J+T2PUc1vyz15foNkivkx8h7xay+jEXhXEVTMeGNO1AFB/zjMm5qzJ3MA06F2as4/Df8OqMWJIlho1Bx4ciTwzrTMU4Mc0qTMZWUp2VJ0G7txOzVgSzx4lvUcmMc8v+WEgKD1Wx5dZ0MxXjPrQ2zzcw/8mmC1TKxkN3ikvEl4qvgtFTkb2dCzBxJtM+nLDfeg6R1ZbIpjEFXW+2zpYRYGvdUS8diLy75sfoZpDFMUOU2lWPjqGAFyj9JrBtHAMO4Qarv76Hl7vgLvIBdRjbbJJbGj5ZJ9cOws4kQn88Rcsza/i41Ks7/+2hdsXqpctE5NVqMvZm0yNNijTsezCfzi6WbS86WvEzUVCI8fXAyur4JBBSsWoBCWNr54W4fucVOq2chk1bQw9lEHxEoTEb6Ef0I74MaBcIOF5oFtF0+MkrBsojrHt5wRGKsFz96g1akT5PB+JHJIra1pN/f1YO+Ai
 qdT6GR90
 TjKdqiJg6fD0JIi8NKwZUA8pLVwusgL44KqTbABpvLP/FO3w/YRK3XbUEcjtZ5myGK4r0hMLvxllizXGleeMAXpQKBNgbhsjolFUt3Pc7bVXMjTQynGUvWV3jcTUelVfVAKv/sJzlP9IIlS0H7vlWvLB76ifc4kh4ltouGaJ51xvUYbxSkVPS8ynYpXiyoBubArnODjrCsjlQHMYyrNZ6+oizEVslBklSHNVMZW9l/fE2GL7WU/IBEaK/zH1cgyT/lcXaDmWl8MYft3q0mFgcrRBzQczuwNwR0Wx8B5XXZihVq8XFulbZXIuLT92Dk8TFshtfh6eV+oQyvJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 13:46:00 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> Brian reported several issues with zram's writeback implementation.
> This small series addresses those issues.

I hate to go all bureaucratic, but there's quite a lot missing here,
and it's rather important, to some.  It's all about taking care of
people who are using kernels prior to 7.2 (or 7.1).

- Link: to Brian's reports?

- Description of user-visible runtime effects of the bugs?

- Fixes: targets?

- Decision on whether we should backport the fixes into earlier kernels?

Anyway, I'll queue these in mm-new, but please give some thought to the
above?

Also, AI review didn't find anything to complain about with these
changes, but it might have found a pre-existing issue:

	https://sashiko.dev/#/patchset/20260525044639.1888561-1-senozhatsky@chromium.org

Thanks.

