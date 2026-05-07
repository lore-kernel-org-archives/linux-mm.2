Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E86CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C84A6B00AF; Thu,  7 May 2026 18:10:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79FFB6B00B2; Thu,  7 May 2026 18:10:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC5F6B00B6; Thu,  7 May 2026 18:10:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6766B00AF
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:10:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C7AFA0634
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:10:03 +0000 (UTC)
X-FDA: 84742017486.04.696890F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id E80D3C000B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:10:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DgGG2vvs;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778191801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjZN7svZ/ttQYK2d+vmuC8xvflup/KYh/ZoF2N7aYSM=;
	b=wNE3UMUdoHcHcjSf0p045p1TW/+bJcxhbXf1AC4A+dtUl1iOVqRY2CyPWDabAirQ0aufS0
	v7S1Y5Lc5shtHcbDJohSsSpp4+Ct1dvZaMgNJrwrZpJshebruz8yHKBnCX7Pp3I3hlSwMX
	EB04mVJXbMFGdhfA8fbZV8BknBWlrv0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778191801; a=rsa-sha256;
	cv=none;
	b=nsSI2qJ+N+SZasnoBBmpz79fokkub8TuUSpw6rry5xe/0cwT1Q3Maqae22vn7RcFq2D6Dv
	0vSSClAerSFFlQ5KaTrDELlE8or4GEEwIIrm64i9X8ms153uu9TbUbjDtPvvJZZ9yNtgGU
	hNbLJryuRPvJng400E7B6NfwwaHiaZ0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DgGG2vvs;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4925C19F0;
	Thu,  7 May 2026 15:09:54 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3090A3F763;
	Thu,  7 May 2026 15:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778191799; bh=jTOX2TqyeO2cWkSnac14LlKPe5V5EVCnWKW2ovINUB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DgGG2vvsVyzMfSGvMdlwVIEzP3CbT0HmzJKIO9QbZQmR/128UWPhZcbay7Ad8oSQK
	 S6YJNfbK60E98hpW5pRgQt24WSLV9NnPtbtg/1/O2TWDHSJ6zhFpTLjpQXDlYJGEGI
	 867B0mfya1qXjN68cKQnC9FyR+jxegDUxxLfJCNQ=
Date: Thu, 7 May 2026 23:09:48 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 2/2] Documentation: maple_tree: Clarify behavior when
 using reserved values
Message-ID: <q2dtphja7i45kknjk3bs4hn2bpictyoaideyjfbdh4sz4pxllo@xtsyvo3eztdb>
References: <20260504165746.1422057-1-weilin.chang@arm.com>
 <20260504165746.1422057-3-weilin.chang@arm.com>
 <5qnwgdcxqat2zo5qe7qy63xm5awo5l4lkdkf4umbj3sl2ct5sj@v5c3szzdbbq3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5qnwgdcxqat2zo5qe7qy63xm5awo5l4lkdkf4umbj3sl2ct5sj@v5c3szzdbbq3>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E80D3C000B
X-Stat-Signature: 9re4bun5u1ggax6rox8wmki473f1afk9
X-Rspam-User: 
X-HE-Tag: 1778191800-268625
X-HE-Meta: U2FsdGVkX1+nLGZXBXNs6AzEIDEGIfKjNY/kdtr2poRdFuac0BhHDt3XCGskB6ckpc6Lzbn6pwuxeKl23oSSWQ06pkZwNaLtEdm3rNbEpl9bZCjBA5SIqM0tqy4SU6ikQX9VFxPW4+G7z03kV9dd+mlvBranDjTOFiHIEwWSZgmVIb39CQ3D3ii04oD56YPIkowO8HqUVFEJ+iZ9NyHeSpeW0XdQX5327f2IfM2xJ89YAIukUFmWpPo8t9AyIRv6mwm+4w3TUu43U69S6JP2VKrVdPRom13qohIm5mKTrmg4ypdogdyz4/G8C/rZSQgJz5YkRsua0/yzZSGrV5PxiQYHpr2a+2sMpeiv9UiEcJUHdEZvrn8kkkcJ9AxeiuJgNqFM/MpZWHUCUw6F33DfCtp9RrmnOSR61a4ioQxK6iFtS5mfytYfECjunWVG1O3+cqEhwMU1DNmJ1MPHu+2/lSJ2MAbAT9wz0E2REJikkibjlkq0PzIhCGLtjinchUvKJ/5XLc6fBGh5qLzvnNQ7Urm+n4IuSZHRuxm8rmodvX07aPjXaI92j9KLfQN4XWNFlRcMKWFvZlRwtKzC/2R6rzeYhfJHLx9X+ljnYWc3aNLUExluRmmwSNOErFD44mDoqS3gjVt75ZbKN1aQhO+rHqUmL6xcTPAskQG66R7G7zqADIWUt3lFWFqR3L1wksDaIoZPZVk0gTFdQY33WBPdwOgs4CLAZHMUO2lB25zMtN7BqBBqyINJSPhbdFj+AWqXbgtx9XMpg7eV5GMc7WCwbIwkhfElgHYZz48JPR8nXSJmF46Mg3HX3dmfB/kOpmMTxSgleXy//6TUr9nnV4T1Tjc8fvwxDJXisVCEwWnaJwViW5cZSfRYSuWrBdR4vf/joZf7STMoQVDvnfCIFajw51qI1D5efOJStDqvW51BmwjdYR+leei5enwKQCK1/O7cPTMFl3nYlD/unQQdnni
 0mHM+lRY
 hGFTuDvVOGBS70jTU25p+OtmAZQfvjXfklIU01Got/RUeS1ri25RQbHXl74XchDd3PXZdesYUeMFmGihI/ToYyXcWaneaTsqtdlaT7muQ/rPqq/SVNncyyfYyKx6au4RO/MfaOmbkdDIW1hpEifxD/0s8Vr+De4m0MCFIiT/hjki3kvps/dnzXsZ796WP1Ug2jrbwNGNVpOxfd8FC84bMqpYEQCzs/xk9r433l3t/v10/OlYBGVkOyvbLa4ISRvldlcvyoOEjShV4GhfsXtB2tIf1jdlXljp/ainMulQwsv7DzRXyQjXxMPA8FciQ+GMviVSs/hpmMvb1stUIbcmJ/jlyBTfCLuD9wxClWTjNQ+7lniyfiv23wOalqtus0+C8+WszEGkk5fNbxXI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 07, 2026 at 05:24:11AM +0200, Liam R. Howlett wrote:
> On 26/05/04 05:57PM, Wei-Lin Chang wrote:
> > It doesn't matter whether the normal or the advanced API is used if the
> > user uses xa_{mk, to}_value when storing and retrieving the values. Just
> > specify that the normal API blocks usages of reserved values while the
> > advanced API does not.
> 
> Your comment above is incorrect.
> 
> The normal API will filter out reserved values on return while the
> advanced API will return whatever is stored there regardless of the
> value.
> 
> Meaning, if you store a reserved value with the advanced API, it will
> not be returned by the normal API.

This is valuable information, thanks for explaining.
However, I'm confused how this shows my comment incorrect?

From the original doc:

<quote>
If the user needs to use a reserved value, then the user can convert the
value when using the :ref:`maple-tree-advanced-api`, but are blocked by
the normal API.
</quote>

To me this is conveying the following points:

1. User can convert the value with xa_{mk, to}_value() when using the
   advanced API if reserved values are being stored. This works because
   those functions transform the reserved values into non-reserved ones.
2. User can not use reserved values with or without xa_{mk, to}_value()
   with the normal API.
3. What happens when reserved values are stored is not clearly stated,
   but the normal API will block it.

In my understanding 2. is incorrect because if xa_{mk, to}_value() are
deployed, it doesn't matter whether the normal or advanced API is used,
they both work since the values stored aren't reserved.

Please do you mind pointing out what I am getting wrong here?

I was genuinely confused when I was reading the doc and trying to use
this data structure.

> 
> > 
> > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > ---
> >  Documentation/core-api/maple_tree.rst | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
> > index 87020a30ba69..e5ccafb84804 100644
> > --- a/Documentation/core-api/maple_tree.rst
> > +++ b/Documentation/core-api/maple_tree.rst
> > @@ -30,9 +30,9 @@ Tree reserves values with the bottom two bits set to '10' which are below 4096
> >  (ie 2, 6, 10 .. 4094) for internal use.  If the entries may use reserved
> >  entries then the users can convert the entries using xa_mk_value() and convert
> >  them back by calling xa_to_value().  Note that xa_{mk, to}_value() bit shifts
> > -the given data, so the top bit will be lost.  If the user needs to use a
> > -reserved value, then the user can convert the value when using the
> > -:ref:`maple-tree-advanced-api`, but are blocked by the normal API.
> > +the given data, so the top bit will be lost.  Usage of reserved values is
> > +blocked by the normal API, and will cause undefined behavior if used with the
> > +:ref:`maple-tree-advanced-api`.
> 
> Which behaviour is undefined?

I originally thought storing reserved values could break the tree
because of its internal use (see 3. above).

Thanks,
Wei-Lin Chang

> 
> >  
> >  The Maple Tree can also be configured to support searching for a gap of a given
> >  size (or larger).
> > -- 
> > 2.43.0
> > 
> > 
> > -- 
> > maple-tree mailing list
> > maple-tree@lists.infradead.org
> > https://lists.infradead.org/mailman/listinfo/maple-tree

