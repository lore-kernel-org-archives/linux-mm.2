Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60C50FF4958
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 07:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F906B0092; Mon, 30 Mar 2026 03:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999486B0095; Mon, 30 Mar 2026 03:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860556B0096; Mon, 30 Mar 2026 03:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 719436B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:51:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13DC25A780
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:51:07 +0000 (UTC)
X-FDA: 84601958574.24.4D04B6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 22633C0004
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:51:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HDJnGaha;
	spf=pass (imf10.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HDJnGaha;
	spf=pass (imf10.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774857065; a=rsa-sha256;
	cv=none;
	b=smGd+Ejo2jdEDh+DSuxvuTaDzSLiPb3laUv90xvKLxOFbJaersfvXFi5oFyXLBAvqqQSCo
	Yc/Wxsd2Kq6hgA7yXzTUUxpwmji1G2PNCS/oGOJOr+N60yPqB/hgnaQ8JBahO4VCxtIjMJ
	r5H9gYVMpbNcXLBr9mFubHiNmyjvb/I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774857065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LybNHri57ibbB08+92BCF4qoN3iJ1KcFsIeYLRMzSc8=;
	b=QnfKE+LZcnb/2Ka+AWDVFL0IqhE1DFWnSNsLjJ/rUo6cuXlnv7hXGADmj7VAi2zXJzGt82
	y35gEIWW0nugcKQt7DGQ9TVAHxjhdugLGSm+ckesSeGVfeJQbuxMK1pi+KEhXdiNbFAjt4
	LALOxTxukr0CPGaXoQ+dPDmzPQhn39c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C5ACF4173C;
	Mon, 30 Mar 2026 07:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2510C4CEF7;
	Mon, 30 Mar 2026 07:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774857063;
	bh=aSND71WTHLvwOtpQkv4oV8DqBi3VtucNGh0c33HMhYo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HDJnGahahU80YqdZytEMzX0I8UW4i6n3ZkgbyjNQsrOgdjM4YMfDJg30J17MDVc5/
	 EyodK7bHo21B1Nla+a28prw4dVZzKMUIf9L5x7shdm2YNPabz3lUjHyjiV+AClIJVf
	 2bp1O2k71KJZzZKPtFVuK70h9hpfwSqrGd/+WqSNPIhAarcAxJxM0sL6/SC/KDIiPn
	 OFdHXNtAFSqW0imHwpZUFAswh41KTVfpK/ZxMWfEnjJFElOg4CLMhQlJ0hjgsWJDQk
	 23D/DqzwtbEN1emjkz2Vs+ZMMJ4DJLYqdDb74t3kS6bsUusHcAorxIJVv+L9NRAjng
	 ZBiZysfzfnPGg==
Message-ID: <6deb290e-b168-4de2-95f8-fc784ed31c27@kernel.org>
Date: Mon, 30 Mar 2026 09:50:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Josh Law <objecting@objecting.org>, "Lorenzo Stoakes (Oracle)"
 <ljs@kernel.org>
Cc: Josh Law <hlcj1234567@gmail.com>, SeongJae Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>, Christian Brauner <brauner@kernel.org>
References: <20260326072737.341964-1-objecting@objecting.org>
 <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
 <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
 <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
 <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org>
 <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local>
 <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org>
 <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org>
 <043CED5F-7014-4776-824E-07E027B7BDC3@objecting.org>
 <cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local>
 <E1A667AB-DCE4-4034-A36B-DAA458780A81@objecting.org>
 <e5d45f3c-4f46-40d1-bb7a-0a2f930fd7ae@kernel.org>
 <82256A72-42FD-475E-935C-629964FA80E7@objecting.org>
 <11429699-81b4-4c1e-b247-480136fd1faf@kernel.org>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <11429699-81b4-4c1e-b247-480136fd1faf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 22633C0004
X-Stat-Signature: n7qrjn8wem1ntnpdbspezaacfnapmnmq
X-Rspam-User: 
X-HE-Tag: 1774857064-214347
X-HE-Meta: U2FsdGVkX18L6Ueij11hnm9IjpOzbIMgFijh2wH1nsyip79qmWZ+C3bEf+RUB+5QPaaQZgAQ3Oy8rwsJCXr4genpQnmo7QG3ffG8UtxsGDKid56u7nFnUXvhZugMFLAw6YNh/ElUuq2MQRgligx5E2dOc2HzS7TzsfxHO1by7ZoeYGC8IhP4reVynF5sRa2zsf1J4yN7OSJUuw/KTRKPDNtkLukv4URLp7fyKm2IsZzeIEskq0w+ZYEmiyiTn8a25NqYJ1PTu/k25RHykPLN24IXJekxOXMmNGLszUTPbEASg1uJbAQvOCA9Pxk+Uy8aC7q6N1uCLa6c4suLYtqU30mhPLs/3PVR4fb5WMVHspPczJIpZdmkt6Fba3zmGwv7TU/DQYuloBzHH9V6HPtanik8IyFrPiCbcAuRRSLhfX+CfYmxLpZQGpyP3atLQb9NLvq+TAUYrupNFW5oAZ/VGMu+wV+uiHPk9gw3siE9QC9dX84HppIIrFmP0ri23ZMijS5PUcmYcO5P3oG1QRsK71XRKTXfkSzmcfhd5/4+yVMaC+HvzJWx1Mw5pdTlSdzr1pMJoJzkPvPf2HqDvnVhGnE3efu3d1T21PWyI6zw/ekCGTcYCMoPnLv+wysHxJNRjRHy5v/I/O8Ml/egapLHuSjs+wmQjzGWntjW/pHgO66+HvZOxN40mZmPRnge3in0MvZ+TZLr8/Yqu0oJqFkTt+n7DNMAxQsi/8eoeAaDsoxs5BGnc3zwYSwK9m0fhyt69fqpAaYJ2Fpwk6HosvhhpYNLTi/Ggl+QrX7pDp80ovzxr+asj2dwWyEQ4xQnVYu8U71DeKIDOEhmSo8Kcqzx2RrZwXInwD/JIO40BwbWtWRj9G/7uBF+eIefrSFPT7Td7prGiVjcBXuV9t4UtT1IYld2ZQK62/9JblsLc/eQwKnXhw9YFzhJt41X8Tkzg4Y0wLYr6Mdjk9uUVDoUcev
 s8gsQcP5
 VhALIvR+q2p1ImE55HIlAx3Hjevk8UHK0IHlxkjauXkSRHJ6KK+vrWZn5IAZEonKWTeB0yWG9bk5KOy92BdA1/12WZyqS5vslg96f9+KBpIFBr7Oo0ZlzUgdUKW0Hf5eLAed1c76wILTqL2stDgUjcizWvEwefPHout3XRPH2jPAQfzCZJAeObe4XnqwuX+1EiEn/mUOYvZz3QbF9+BTtzCFCUe3lEABxI7EGefR3dolP4U9ErYHogLdbpEEgn8zza96f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/03/2026 08:27, David Hildenbrand (Arm) wrote:
> On 3/27/26 16:22, Josh Law wrote:
>>
>>
>>>
>>> Josh,
>>>
>>> in general we try to be a welcoming upstream community. Finding people
>>> that are willing to work on the low-level bits and stick around is rare.
>>>
>>> At the same time, we need people that are willing to get familiar with
>>> the code base and technology, so they can help out with review and
>>> provide long-term value to the project. AI use is only partially useful
>>> in that context. Certainly not for writing patches as a newbie. At best,
>>> to double-check your understanding (e.g., AI review), help you learn
>>> (e.g., explore the code base), or improve your writing if your English
>>> is really, really bad.
>>>
>>> I prefer someone trying to use their own words to compose a change log
>>> and actually learn something on the way over some AI slop that reads
>>> nicer any day. Often, when you write a changelog you actually realize
>>> which corner cases you might be missing, that the design might be overly
>>> complicated, that, maybe, the reasoning or motivation is bad etc. It
>>> takes time but you actually learn something and are forced to think
>>> (crazy, right?).
>>>
>>> The same is particularly true when it comes to writing documentation, as
>>> people raised earlier in other context.
>>>
>>> Having that said, your actions made a lot of people's alarms go off and
>>> there is pretty much 0 trust now. As Lorenzo says, even now we are not
>>> really sure if you are saying the truth right now, which is a big problem.
>>>
>>> If you are, in fact, a real person, and are passionate to work on the
>>> kernel, it would be best if you would start things very slowly and don't
>>> use any AI for crafting your patches (including patch descriptions).
>>> Stick to one subsystem and ask people what good starting tasks/projects
>>> could be.
>>>
>>> Ideally, you'd find someone people trust around here, that can verify
>>> your identity (i.e., have a video chat etc) and start mentoring you on
>>> how to start working in the kernel community and gain trust.
>>>
>>> Now, I am still not sure whether I am talking to a bot here (there are
>>> too many things Lorenzo points out above that are very suspicious), but
>>> I just wanted to say that there are ways to become a trusted
>>> contributor, and that information might be useful for other people that
>>> might be interested in working on the kernel.
>>>
>>> It's certainly not by flooding the list with AI slop.
>>>
>>
>>
>> Hello david, thanks for being polite about this whole thing!
>>
>>
>> so, you are talking to a real human, i promise you that now
> 
> That's exactly, what I would say if I were a bot ;)
> 
> As a first step, fix the line wrapping. The following document was
> helpful to me in the past:
> 
> 	Documentation/process/email-clients.rst

Yeah, good luck. Several people asked for that already, like 10 or 20
times. Andrew asked that a few times.

And yesterday we got another sloppy posting, so that would be it for
having some time off to learn things and take slowly. 3 days after this
AI slop which does not even build.

Best regards,
Krzysztof

