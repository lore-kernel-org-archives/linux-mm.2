Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1792D10F52
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 13:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F03DF6B0012; Wed, 26 Nov 2025 08:55:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDBC86B0023; Wed, 26 Nov 2025 08:55:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF13D6B0024; Wed, 26 Nov 2025 08:55:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC0736B0012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 08:55:17 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C8DB13156E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:55:17 +0000 (UTC)
X-FDA: 84152905074.19.63449BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C775A180006
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:55:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=xH23ha1j;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764165315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AtiBOtjkszow1+mwJMzjBhqs0X6D6A6qju+OcXmeltI=;
	b=HfXOMhARBJdaxeXzl2/6HGZ06wltylMknIJcflllEtuyfKgKepKI0J7Tbe97YZLt/+vL+V
	CzRl57J8UVA5oo7KYyhaNYz3dkaAzMWEIHKqCCD9YMvjALqRyxa53HOxMCvGKQhQQ0T4/Z
	PzleIZsUjyATx/02D/C/nFIS1ieY+do=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=xH23ha1j;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764165315; a=rsa-sha256;
	cv=none;
	b=kdDZc6GO1IYHIrW6Jp5rl4Nr+vdVh0BiMVDbo/QZsoHwVNxONHf+DykYuSxtPSHHZg7DUJ
	bjG3B6hHNSvLsO+dUx+WDrrBOrIQesYUBtWeqG8FaDvRm94GQfK2Xj4HX3CiW9SS6wUtCR
	WtP+6UPwYP/9vWfiKdX8BA09jUA1j1w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF31E601B2;
	Wed, 26 Nov 2025 13:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09007C4CEF8;
	Wed, 26 Nov 2025 13:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764165314;
	bh=I+TScRoNbd7FG0IWAZIoQseK2RrdKsM+sqKB4TIxaG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xH23ha1jcoyROXLVBmErwbr+/N2i2YI6GVuUy3wBhbAdyhXBCHLcM44Vu6hXi7erD
	 vPi3ytkvLOx4YZXX3G65ghF9qx9e/Zt/CVoI5m1V2hSFGdHcP3ooibTzWvTpnNTp+t
	 7iHZZpHoKQ6XoGJP5QA6NT1+BbnRGJBG+RycrZac=
Date: Wed, 26 Nov 2025 14:55:11 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Chuck Wolber <chuckwolber@gmail.com>
Cc: Gabriele Paoloni <gpaoloni@redhat.com>, shuah@kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	corbet@lwn.net, linux-doc@vger.kernel.org, linux-mm@kvack.org,
	safety-architecture@lists.elisa.tech, acarmina@redhat.com,
	kstewart@linuxfoundation.org, chuck@wolber.net
Subject: Re: [RFC PATCH v2 0/3] Add testable code specifications
Message-ID: <2025112631-repeated-crafty-207d@gregkh>
References: <20250910170000.6475-1-gpaoloni@redhat.com>
 <2025102111-facility-dismay-322e@gregkh>
 <CA+wEVJZEho_9kvaGYstc=5f6iHGi69x=_0zT+jrC2EqSFUQMWQ@mail.gmail.com>
 <2025102124-punctuate-kilogram-da50@gregkh>
 <CA+wEVJajSGzb85YTiv98yAY3bcJFS0Qp_xjLc++wnU8t=wDAOg@mail.gmail.com>
 <2025102211-wolverine-cradling-b4ec@gregkh>
 <CAB=6tBSaGfKq4RgV=nbw28Yq59jHMrVOkm_dx2bqD1AjU37oaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB=6tBSaGfKq4RgV=nbw28Yq59jHMrVOkm_dx2bqD1AjU37oaw@mail.gmail.com>
X-Stat-Signature: dyzsk5731ku1rdzipe61iidhmbfe8bpe
X-Rspam-User: 
X-Rspamd-Queue-Id: C775A180006
X-Rspamd-Server: rspam09
X-HE-Tag: 1764165315-393979
X-HE-Meta: U2FsdGVkX1/UoTysOp4MfF8r/YtWeO4nYbNz9S60D194pT2ZqLcTMjIt5jRIzMDvSm2C8za/NQdW3YRGgKDxeYJYT6EcTRD3qi4i2j5VKDVTNwb/k6aomgTPW/cTuJjmU6tc49EUHdCJ031MpAF5LalvLt/9rBtmzdPxMYpepTC80kXdcnA9KUDkOplZeA11dbJ62JOaRUXOIb7iQV+NREbdWA4yOtn+DG6QMdvK3Z+jApTVfS9sO5dhmhSjO5mcfQytv7nk1XPz9nYReCVdjxZCd8P750SqSwPMsshW3iBJ7GMN/JnALfbkfIUGMjMZyohV/FTRRkNLZa9FJLJw4zKMWGiL+yxnV4pXzhB0UKZMZun9cqBoLEayUOhIGxov7cqNqPxC6VepwPmVdUBJZI7N/zBPWFEFm02BUfFJmBtONux8d9Dkm7/RF7Qc8uW80dRHdzDF8X3puNcDLWdJsgVrB7SSD/DLsIFxQklopppQC/IPqag5CU06RCp8rJcQ3PHZTIfHnTQeoGcoWh8FMlnFm0sphhLjiGwgpNSVOkReTUrBR3bY06nimNKiybda2qkRs3UcnJxBCACOF5elszuBTEGy6Dgag1tINVrwKOOX7qv9DHLmgmGIVQjM4O15eL20eiH4uS53wRtGyRheLE/8pxH0q4QKkTXVo8CMxSL2hsYfWDeJFoFMIJS7JYJHa1jESBac8qVh65TjbKgZXqMPULYIxzn7MvW1uchro5EwLRqe/fhvRLbZhOSM1yQcZG41wQlvTZ1cs7H0m/wJTUT0qQa7YNrSJ93/K12XPHFYdEGwuMuQV+/laWN0rEK5CYZmi5icRObm0Gq6mj8OuNvoDgmWY8YFPfxTIGeiF7uYi7t7XDPyyj+Iuhg8UAsit9vh1pPxQmaks9JQ1LftQ9B74gZffQrMGFf4kD/I9rbec/SdB0QebYOhhhsd+4lZvgdmmK7VLyQkzk1vGPX
 rtjDm69B
 ZqFFDbG+RSJutM2dQi8n178uDqPZvsCQsv0WSJVdmeDXCCzyZjWAVr9Bpigi4m4+VfSSR6Pb5nYNfmQNs0v2nOuyBMUzAyTFsOkxci1ABf4HalnXsyau6ubo3Ge93hoVQFFIIS6J+JYttr1VgqeCtIvr3hi7fwQU1IYkKStgIux20KMrVBy9bgsmXIB/VwuCLGP0/Ao98l+rR09oXJ//CkX/h9TO6aFYnjpM3oq0VtIMPU5khfbSeYj1zZLUwxXZAuD476H7C8Ih0H6wYSFftOBaUTpVxHXf1mNSQc6/zR6i/fdxNfVNKSckPGWF/mRi3tuls/mEc/ssLU1ubsUZOGqeVWlEbZlIZtOgnRRtRdG8mC+Q99HO5DJAvPnSQMwpQQGIvJrMTkSNbGM00QU/rMZwJlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 04:29:13PM +0000, Chuck Wolber wrote:
> On Wed, Oct 22, 2025 at 5:13 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Oct 22, 2025 at 04:06:10PM +0200, Gabriele Paoloni wrote:
> > > > Every in-kernel api documented in a "formal" way like this?  Or a subset?
> > > > If a subset, which ones specifically?  How many?  And who is going to do
> > > > that?  And who is going to maintain it?  And most importantly, why is it
> > > > needed at all?
> 
> I appreciate the questions. I sense there may be some confusion over who this
> is intended to benefit.
> 
> The design of the Linux kernel is emergent. This is a fundamental property of
> the way it is developed, and the source of its greatest strength. But it has
> some shortcomings that place a burden on kernel maintainers, all kernel
> testing, and even people who wish to contribute.

What specific burden?  A lack of documentation?  Something else?  How
are we surviving without this "standardized" interface so far?  Are you
a maintainer that runs into this issue in the past?

> We intend this as a tool to address those areas.

What tool exactly?  And who is asking for this?

> > > > For some reason Linux has succeeded in pretty much every place an
> > > > operating system is needed for cpus that it can run on (zephyr for those
> > > > others that it can not.)  So why are we suddenly now, after many decades,
> > > > requiring basic user/kernel stuff to be formally documented like this?
> 
> You are correct, the kernel has succeeded over many decades, and will continue
> succeeding for many decades to come.
> 
> With the exception of some very narrow situations, the emergent design (or
> "nuanced complexity" if you prefer that term) of the Linux kernel is not
> communicated in a broadly consistent way. This affects the way the kernel is
> tested, and also the way it is developed. Even veteran kernel maintainers are
> tripping over nuance and complexity.

We all trip over nuance and complexity, but I do not belive that adding
more formal comments is going to solve that (hint, the proof is on
you...)

> > > Let me try to answer starting from the "why".
> >
> > Let's ignore the "why" for now, and get to the "how" and "what" which you
> > skipped from my questions above.
> >
> > _Exactly_ how many in-kernel functions are you claiming is needed to be
> > documented in this type of way before Linux would become "acceptable" to
> > these regulatory agencies, and which ones _specifically_ are they?
> 
> Exactly zero. This is not for regulators.

Great!  Then we don't have to do anything and you all can stop it with
the "we need this to pass certification reviews" nonsense.  :)

> > Without knowing that, we could argue about the format all day long, and
> > yet have nothing to show for it.
> 
> As this is not intended for regulators, it is not clear to me that catering to
> their desires would be a good use of anyone's time.

Agreed!

> > And then, I have to ask, exactly "who" is going to do that work.
> 
> The intent is to allow for a separate maintainer path. There is more to it than
> that, but I do not want to bury the lede here.

But that's the real issue.  We've seen loads of proposals in the past
that have gone no where as no one actually does the real work.

Heck, look at SPDX, that "simple" work isn't yet done because no one
actually funded it, they just "demanded" that we implement SPDX tags for
all files, and when the work got hard, everyone ran away.

What makes you believe that documenting something that is orders of
magnitude more complex than something as "simple" as SPDX is going to
actually happen to our codebase?

> > So, try to answer that, with lots and lots of specifics, and then, if we
> > agree that it is a sane thing to attempt (i.e. you are going to do all the
> > work and it actually would be possible to complete), then we can argue about
> > the format of the text :)
> 
> I respect what you are saying here, and perhaps the point of confusion came
> from the safety related source? As is often the case in science and
> engineering, we are borrowing (and _heavily_ modifying) a technique that is
> found in a different domain.
> 
> The intent is to target technical debt and maintainer burnout by filling in a
> semantic gap that occurs when a human idea is turned into code. Ironically,
> this is why the safety regulations were written in the first place, but little
> consideration was given to development methodology during that process.

So I don't see the real goal here.  You all for some reason want to
"formalize" a documentation process of all kernel apis internally, for
the sole reason of making developer's and maintainer's lives easier?

Again, who is actually going to do that work?  And if you are, great,
just start sending out patches today using the format that we already
have for kerneldoc and the like.  No need for formal language
requirements here as obviously no tool is going to be parsing this, nor
as you said, any regulator is going to be reading this.

So let's just stick with the style that we have already, no need to
change anything, just start sending documentation patches!

thanks,

greg k-h

