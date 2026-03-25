Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DE56109C048
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 17:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BAE06B0089; Wed, 25 Mar 2026 13:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B7F6B008C; Wed, 25 Mar 2026 13:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8810F6B0092; Wed, 25 Mar 2026 13:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74F5C6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:08:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D55A1A0A62
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:08:58 +0000 (UTC)
X-FDA: 84585220356.06.744F8F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 853BE40016
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:08:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rGSQfdk4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774458536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCqnZJ8+jhaDA1fij37NyzSrCEptCjL00xQs9pHR95Y=;
	b=FvTq5rC3IqTegePxGKrIbcQOi9v0RjfV5I20dkjVyzL9q1Nkja79LmS3oUxgnG2V7ir9SS
	u04fPSpAr4DOtjFymvM83LSPayqC6PnvK0PXh4zF001Cc9nar4+5gyJj60JimZt7wDepm+
	16x7pPttG3xgvJ3FRg7ZDNJ2AeJJB78=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774458536; a=rsa-sha256;
	cv=none;
	b=miYtr4CZI+KMcaJlhpBf3vQKsvV1I24r6EJNNwjJWYw5bbaWZEp0Gluh2CaXFQp4jAZSrP
	yFbD75WUgPKFFkkBgLBB5RGSyf7bL/D6fR+Cv2SESwNzUtHtOhzf0mGsC+8FcbBEKsH6Xp
	xe8ag91XSbN+V7qs2rGAYBDYtEQNEPY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rGSQfdk4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D13E060103;
	Wed, 25 Mar 2026 17:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2DDC19423;
	Wed, 25 Mar 2026 17:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774458535;
	bh=xvg9oYhWMrrgWgxopkhQLs2ebX3H/C408lUVcS0/G2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rGSQfdk4kl61AAInBU9OuNy4wPAO6DTWVVt0j4+pTxfwJHromGBVSecfN37A1R4X5
	 WgyNWJwzvA5QZk0QkOnfhLErtluNvgAcgQgitXe6QVa4qUEzmRKM1pyHbvYUmxJoz2
	 w3vZNy7RhCjDh9oJ3T12u+l0G5hw4FQP63W6zTCYFA0FNaDMFHHpBD+w62ltSQngNa
	 6Ts8uQKa93JaWwz0uswV9SvsUdr0G0P9VBlZTRoUPTSo8e1yMR5t/ofsNQ+8TGdTLI
	 rZc7VLudyYxwBS2PGi0sHo5l8WeP13iPUFy3lEnM0p0NlXwismzKpT24W+LMP+aozN
	 Z+ST+Cpe8Vf2A==
Date: Wed, 25 Mar 2026 17:08:50 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
Message-ID: <8c746bad-3af3-45cf-b110-2c7103fdd44f@lucifer.local>
References: <1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org>
 <hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
 <8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
 <CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
 <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
 <20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
 <3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
 <8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
 <0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
 <CACZaFFMb_1u7ckb5+7=wWApOx-u5kBxx-+2Y1Cjd1Qad4kgHRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACZaFFMb_1u7ckb5+7=wWApOx-u5kBxx-+2Y1Cjd1Qad4kgHRg@mail.gmail.com>
X-Rspamd-Queue-Id: 853BE40016
X-Stat-Signature: pmr3whck8r74nn94ai8yge1cbzitgt8f
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774458536-254335
X-HE-Meta: U2FsdGVkX19trp21X0VN7iUTfIxnaMAvuwc7Ah8LZqgwDOM3sEG0ATT+WxhOG8C0x+Z3lHwELj7kg9UEn0vaJIrQJ0nfKrcSpO7t13z+9yuS22DxVT1JbnxaDpwUFXPcVrA7jNol/BF0WIs7wAViAIWwa+thGeY41HyXIrt5fjAjQjkRQ5JNNqqxidk2XhEE72IqOMCkVbl8Eqf0aNPxdgdaYTMSMKsmzMa5NKbZqPAgc3N9X/yayjaNvlONoDYA77E6d251/OrK6fNnOj47UfUAShSV4Rko3EFbOjIiyEQpo30fAxWEjTwZR+349IrzhApomnq6kbR5L5O7rlIZ6/L7drNKpqiRHcuww++ASJ+h9ALw1EYYn+uR0Vf8oJM/JvLUKKbnvbOBSx9yJeClW6QYg+2xx0k1VIGS3ZiTf8fr/n2qD2rLvGV9HHjgOj2EweDgiTDhQnpb3xYY4tpPfH9Z4Ya8gKshCyOgU+S7zPyAmB3l9CeRe+KTDDMAL7g3trUXedQYnyflHXh6cvQ+tcGe2+Ci1kBarslbdRTQ2yhfBk2bRILv43eCEhmP/8Z3PElzVcgCLBWVEDYXLeZA1v+XQWzCcVSIDpCd/a9O1KlCSgbBdQYfh4LRoPN/iLeRzDRazmCpBoSZDcHy2mTKD2uj0qXfA1LwQixWxyNDBs33+b7Jvt5qQNwm1bU+O/XHvxSJPV6cIeEO9aUbczB997WtfUumEZnpcGZD+ovLed88KnWuaDs+gEFH3xPPDsR0I0/BNmCToK6Llw2a+aP92QIpevBmFqp659JaZFMfHVrDh/0L8n6UhVKYT/aqcfi5L6UOUIUGUPzcYM0DvEHrpRgAO3UtIHX+emTxrbMzdkTPQ2RfNDVX4GCDZlHUm1e5abH4Z+18A9patdZNYUijl9BQWnplcbps859lDvV17DA32pkKL+E0FZ2oxV2Sc/d+0iPjr/s5sIaPTBDr+3R
 ayVpeAVo
 ZXDoy/aFe89YisyjxBebwt52YviiBX19mUx2swniCsOeGJyF8xC+tXKNqCq4i5CszoTkMifgGvMNcwfNj0WZlZ8e8VxMEpm0Yh/8Mizxg/4YSwYDfV1b4wmmn3TaIqZDa1EgEhFTXimfYC735uz5jTexuUNEsz+Q8Cu+CHcvNBPP0IUA9RJEtcUhoJkLZxnq9jLrJOWtA44ISwRH1/JDaXbQr2wxzw++lVWzNgNNk1Idy2ZCsnxhL+DylFNygt8naHx9+w7oY7LFqIxy1Sz4OTvzdXvjtSIE3NFx5vTmjoT+BUexgI2mebPk0NQnMW9920ueE7CoqZHDRRJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 01:00:23AM +0800, Vernon Yang wrote:
> On Wed, Mar 25, 2026 at 11:23 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 3/25/26 16:20, Lorenzo Stoakes (Oracle) wrote:
> > > On Wed, Mar 25, 2026 at 04:17:21PM +0100, David Hildenbrand (Arm) wrote:
> > >> On 3/25/26 16:09, Andrew Morton wrote:
> > >>>
> > >>
> > >> +1, I could have sworn we brought that up before. :)
> > >>
> > >>>
> > >>> Oh.  I've never really received that message, at least not at all
> > >>> clearly.
> > >>>
> > >>> I've been hoping that the -fix patches are actually pro-reviewer, for
> > >>> those reviewers who have looked at the previous version.  A full resend
> > >>> of something you've already looked at is quite annoying!
> > >>>
> > >>> I try to mitigate that by sending the
> > >>> heres-what-you-changed-since-last-time replies.  It's a little more
> > >>> work at this end, but that's not at all a problem.
> > >>>
> > >>> I see a couple of options here
> > >>>
> > >>> a) I can fold the -fix into the base patch then send out the
> > >>>    resulting diff as a reply-to-all.
> > >>>
> > >>> b) We can just deprecate the -fix things and ask people for full
> > >>>    resends.
> > >>>
> > >>> It depends on what people prefer.  How do we determine that?
> > >>
> > >> I like "fix" for smaller "obvious" stuff where a resend is really just
> > >> noise.
> > >>
> > >> But for bigger stuff I prefer a full resend (we can still have these
> > >> temporary fixups, but for reviewers a follow-up resend is better).
>
> Yeah, I completely agree with this policy.
>
> Initially, I thought it was just cleanup without functional changes, but
> I didn't consider the new reviewers (haven't seen the previous version).
> Sorry.
>
> Although this patchset is already in the mm-stable branch, if we want to
> resend V9 version, I'd be happy to do so. Please let me know. Thanks!

There's no need don't worry :) this isn't about your series, just a general
point.

Thanks, Lorenzo

