Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32C9AC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F01A76B008A; Mon, 29 Jun 2026 04:41:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1976B0092; Mon, 29 Jun 2026 04:41:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF5F6B0093; Mon, 29 Jun 2026 04:41:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB2D56B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:41:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37F07C2C63
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:41:18 +0000 (UTC)
X-FDA: 84932305836.20.CC61D54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A5148100005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:41:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H0HRWXtu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782722476;
	b=vm+aPOXAeCoBaKb8DN8gd3Jxle7PAo7md+eoCVL5YmC9KFGXd6YH1Fqp9NbH6n/l5Vxah2
	rcdmqEpCUs9HSt+vRDMaC4cYqMHd4gUfOLmCnn8zM2+er5X8umxbNrpVzy929rxF0To29X
	Oknb2ykPnHwSVkhqAv0+VTJmYnSTxuM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782722476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfkssgBoiQ6bVfPaoqfkHc4dekis+Bm6SNpXHbgRJFA=;
	b=gwqpch75eZkrUhkjjFh2d5OqAHh/7i7voi3c8MVibFp8R80y6+xg3jfSN25ljmvhYRb/UG
	aYsVLOg8ZVgPnwyE46ZECjo9JME9fud6DyXnwncjWeoTJR3UzJVb9DGdJXNwcY9MzrIfYG
	x8w68b6UgKnfNY2N7FKvnVgf4cH4+Z8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H0HRWXtu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF0EB40431;
	Mon, 29 Jun 2026 08:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5581F000E9;
	Mon, 29 Jun 2026 08:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782722475;
	bh=yfkssgBoiQ6bVfPaoqfkHc4dekis+Bm6SNpXHbgRJFA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=H0HRWXtuJ2HLeUnPWK4mdYB2zisrtpwGufv0M4V/iKLqrq5n1WACDZ2o2xj5SXrHV
	 HwK+KkD541OO7p7m5tYnemIhi+nC9NYHm4XgFUYTfP3IxzCyt9UQcT4YiZEjLy10Yo
	 wdYMhJzw2PT0bEv4AOxv0Ep0/zjfMqR1jJgLbEla4avhJ66Y0qK3A8m/EJrUgYIHGH
	 fA4NLMFj2l7oP/PlsdOqZqCYFGMmY/DI94iI9+hPkGW+9/nlbYGBJFbM7X0ylrBAIs
	 FmmydQMoXplVeO4r3x1ceaNS656nARlDZVUKxdIEnEgmfiEOCvLARz0KwRnk0dfzEq
	 jxMsfiAXRwRSA==
From: Thomas Gleixner <tglx@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, David Stevens <stevensd@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij
 <linus.walleij@linaro.org>, Will Deacon <willdeacon@google.com>, Quentin
 Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 12/13] x86: Add support for dynamic kernel stacks via
 FRED
In-Reply-To: <888C322E-BF59-4C72-BFD2-2E71FD8605C0@zytor.com>
References: <20260424191456.2679717-1-stevensd@google.com>
 <20260424191456.2679717-13-stevensd@google.com> <87zf0hgc3r.ffs@fw13>
 <CAOiLmNGD08mLKAJvRZdaS7b+3BeR8Ln2G0sEqNCmbD6cRFzAxA@mail.gmail.com>
 <87ldbyhatz.ffs@fw13> <888C322E-BF59-4C72-BFD2-2E71FD8605C0@zytor.com>
Date: Mon, 29 Jun 2026 10:41:13 +0200
Message-ID: <878q7xspqu.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A5148100005
X-Rspam-User: 
X-Stat-Signature: wr73t9m6n94u88wnyrx5xhzupx19zfoa
X-HE-Tag: 1782722476-334501
X-HE-Meta: U2FsdGVkX19pl8MIfHS9s9ICrURlJE9jYpY2nYvlHVCSolQ3A+bMM9sWpz/ksJVFgTUv1iHWDN7OHSMWgLc0j+Per+au5YUAr1PeQgB7XVVaM6SQFer1c49t11ZYtDU65NXZqSNfkquCiIMKLntJsiYszZJVGoLKZ9xrTRMDeWndRFoijoxbVfj/Iws8C/tjazZJSKMhb+tY2H08+I1OIG5XvbJsVbT/QMJoBjUN9QO/Hkf7QweQMuNqAljtLjjST5E/XtdRunbl+3u8zN3Hi4DOJeqEjF8jVZf5mN2VuH1Q4MlSDav36y3DgFh+DeWypOqqtUdgi3F6GKhM6NrhxKZOcvKRzTnfA5oP7wSejQTaAdLmtJbtMCaG42U0QrZXnnFLC7fXQqmPk/c2JS8ybvhanGirps3zKSrboawbLuT2FAp8XsLSz2z736zE70BYVVQxvLAylhL809AFVFk7lmrfJOk5ZKcWWHD3+3N+kFqvkZo9lbYKmudXX1d0WHmofnrmRNK+y/rsyD1MjUIZ78FKicV5N2LOPjUx2FwPSI0kDLaBCP7QESUg5ar8Y4MehYobcxNjuNP/l2xboSy83K84c5WjR39vmbpBWJPiird0F7KyA9RhxLyWiSClputKEf6N0mjjb7gaIj2YpYN3TBR/n8aAbCMJuNQ4kN73TUWOVaYeZjpGQjPlzSpvpbDg/PUREtxiBuNFLJZeW57n6Hwcc81IdwHAhteYY6WLei6783iSO3TKQIG59MR0Zqh5mBX6cMr/ALbyXnJjXwXlOrNwl31HzUTv2P+/pGl9P303nWeduR3UINmTi0f0zUE58IBrghej2Q+wYk3+Qg3deWaFo5QMiZ4kHcGdYWZRmorUM89x3jdO6F+pszRHtmuKDw7g/AxkaqLNKCBhcJc4XcS7Q5Vb3nL5qoSjOIMM1AamDU4aNAd3shzTTyhiRe/dFOroM2cgjgQlr+cVphM
 dh6QLXHs
 JKkh8jmHzyu2pGeEsTtCgzgzl+gvn2fT16wPUP1npitW6VKFFrHemSt6szOD9KY8M8yOr2sdjMj/9JxcOxuKYPyr/GQfZl0qxsOOSRatEEPq0gPPfw4F5M5ZIy5N93RYHwviEabzEyDKaTclyupm3DvVbK5OD4DS1sLaRHWNNC3SmFUGSS5XFObm40wM7/qWcycQY/C7/ff2mnXMDeZzuPBesXPHX7zBt89MAsL2BHHpCD5SxCy6CTLTXIW3D7GcB0iUsm5z+d0E/QuvUiUx/xeTXwCdcg4Zu4HifBpztgm5xWO/6bg6j+4BX/XMAwRJKgqJJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 28 2026 at 13:33, H. Peter Anvin wrote:
> On June 28, 2026 9:46:32 AM PDT, Thomas Gleixner <tglx@kernel.org> wrote:
>>> That sort of fault would probably end up either with a
>>> page_fault_oops() or risk a context switch with SL>0, but we shouldn't
>>> make debugging harder with UB.
>>
>>Definitely not :)
>>
>>You can avoid quite some of the problems right in the ASM entry code.
>>Instead of checking event type/vector and then going to the stack switch
>>logic, you can check the stack level on which the event happened
>>first. If it's not 0, then there is nothing to do.
>>
>>
>
> To be fair, for this *specific* case, memmove() does exist for a reason :)

It does, but why bother doing actual work, if you know upfront that it's
not required :)

