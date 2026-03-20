Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D211099B30
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 21:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36C06B00F8; Fri, 20 Mar 2026 17:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0DF96B00FA; Fri, 20 Mar 2026 17:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A240B6B00FB; Fri, 20 Mar 2026 17:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 93EB46B00F8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:09:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 90EEF8B59F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:09:43 +0000 (UTC)
X-FDA: 84567683046.28.54C6A76
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf19.hostedemail.com (Postfix) with ESMTP id 98E151A0002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:09:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WhFREyC8;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774040982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LdazZRUKPM4vpFTCoVH7q3Sgf/OigaeYxeWW6aTMgO8=;
	b=i/aofPBPJPXoRWYXL/eEW+s0k1WOOPpeBLu4l3ALaPJia9XVBtq5VJJLjYAA87ro1Q7UMv
	Q+fUAupNRs4aUGLWvDbay4fpc62qf/i69n2WZkexTjORdwxpkOtVntsOo1wDiomsyf2NJ9
	GdYC96xWiRfEdjoQCMtK3qn9xvj6b7s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774040982; a=rsa-sha256;
	cv=none;
	b=p4dxxq6de3DESvDVtjPKZcAbB5TDRtsUzyK82Pcb7CvX+B3jkADEGl0KujlJ9QGc1ckBfp
	qPmpFxJxtEpUXoCatMUd88F3RNldYAF98bXddo7zTYBpU6gddClnmRtetWtJN5Sg1Zqdmv
	BsOdAxoW53JaDLe7W5gTeruCdM8/fU4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WhFREyC8;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774040979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LdazZRUKPM4vpFTCoVH7q3Sgf/OigaeYxeWW6aTMgO8=;
	b=WhFREyC8EnejfQg0iYOyCaFeE33b9AE6YqRim1Rhn9Wbph6l+wN0VeURU3qVaNhQV41mgQ
	FyzgM8JaReUxeqVyGfXoOBZojJgz98by+LeJkBVkplS47HDa+KDx0rAHO+ieGqnfj+k7Nx
	BDZevr1nxMjXvNghK7H5iFKYuuIt4wU=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: "Gary Guo" <gary@garyguo.net>
Cc: "John Hubbard" <jhubbard@nvidia.com>,  "Miguel Ojeda"
 <ojeda@kernel.org>,  "rust-for-linux@vger.kernel.org"
 <rust-for-linux@vger.kernel.org>,  "Alexandre Courbot"
 <acourbot@nvidia.com>,  "Zi Yan" <ziy@nvidia.com>,  "Andrew Morton"
 <akpm@linux-foundation.org>,  "Jason Gunthorpe" <jgg@nvidia.com>,  "Leon
 Romanovsky" <leonro@nvidia.com>,  "linux-mm@kvack.org"
 <linux-mm@kvack.org>
Subject: Re: Sashiko.dev for Rust for Linux
In-Reply-To: <DH7W8TLZAKUB.2E0Q2VS546HBS@garyguo.net> (Gary Guo's message of
	"Fri, 20 Mar 2026 20:32:10 +0000")
References: <1f94cf47-9898-405d-bdf2-29e21cd87528@nvidia.com>
	<87ldfmtfk7.fsf@linux.dev> <DH7W8TLZAKUB.2E0Q2VS546HBS@garyguo.net>
Date: Fri, 20 Mar 2026 14:09:33 -0700
Message-ID: <87a4w2tdgy.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 98E151A0002
X-Stat-Signature: qymjosd8rze8orsmi6kfhgm66i7ctef6
X-HE-Tag: 1774040981-209043
X-HE-Meta: U2FsdGVkX19XTzFsdJr6eeH8OMn61rwkrKLOPb85kpxF+AKQhK+n4cls7eIu9P7UzZCFnbzBgByfBN6xJwmv4BnanrR8tRbkGLt+r0tjq+Zfg65SbhJ5YxtT/vKTTs6efhwMziGcL7P0hJ+hghau3FyxBzDTZRf/kZJHRvIOwd2Hypen5dXyDz//TGIOY4Dix2M/s0K92cbgZFrhs/UTbJJauxu46lblEU3LquqwfjwoOhRHKvE7mqmFBmEGEbMD6ulwcIMpdlEsgtmDvT+UL9nnX+6fpi8QMT5Wl4WTHAGJHh18PLghCiGuoRqR7McS2b46xz1ZB7l7fY41ZONCTLEkfUtVZhl9NuFJE7i8HL1zXixEPgsJbg2+Bg8WovWVhj2YO2Sok2MrWDo3KnjJyNZlARmBkgjwZyF1nLOA3/LU2foGLvnwZnVe8fKfYtBz80clqFqLYuWOmIRWNWkKA51OEEgxzfFmBkor9wCbIUBe/WkzKs0Yy0n0U0J9Pp6x8sePMUs3Hulg8pemACrvuG7qy27xGt5ouT3b6Z58SGm+D0yp1lT4rVyK3YWJm+sRegWSVkmwA9L6FiEAhhVjKdXuGLKol3AnHEq2nlHyBYm4StHOA4kk2edWiJZg8zF5XBXEzdB6WI/EcDGZminYYVsnq/rwJQP4TD15xsR18FGs+ZGYroxCT3uP5+Gx5OcEiq7lvUHspiIOt6fke8ai/afzEg4zTsGZAuLDFb1OKzuz8ppGdLKW1VKXPwSPBHtdrP3HWv9YHb2cRs9MFVxtWGP0MHf/U83FHGDGP1I3d4kdvs6ifWQBXl4++P6KqxVDKGNq3F4pVua96YKBvKn0BhPmOj96P6P9CDj/1IYfWH7yyDy5pcShyofNvR3Z5fZDiWEYhUhAhb0B8WlVgqsa64Sh2q6dY+FGxdCPNLRGOHxukL9Ok5DkymIsgaHwtqyRG+HlEceBRXfnb1LlT6t
 76g1PBcG
 hWG4rGB7htU3ZoODQjRGk3Ofl90AxPHFhPxIUd1x5cOuToXaIzNU7ORkhW2kP8PBTyU+8ftvq/vzjomualAH9XF9DivWypvxvAekLNOLiGztWpFXSPf7U9mhQV9XBMAC1YyHkrJt5XVWfbQoediY9au021o/K8P+Hcu4UqIh1DsLcKcvHE+cV97wehL+gmHDFbj0s3vCGDSFmtVsms9anUGFflCVnWAiiZWwuiHAVlR9WIoOtljvpwuzZVmuZKjgG/dxEwbmjo0TR0v4DMeqMKEWnZcaUza+AMgOj17bK+1tqN8PhyUX/4FocLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Gary Guo" <gary@garyguo.net> writes:

> On Fri Mar 20, 2026 at 8:24 PM GMT, Roman Gushchin wrote:
>> John Hubbard <jhubbard@nvidia.com> writes:
>>
>>> Hi Roman, Miguel,
>>
>> Hi John!
>>
>>> I was delighted with sashiko.dev after just a very quick peek at a
>>> few of its linux-mm reviews. Up until now, the AI code reviewers
>>> have often fixated on trivia, but this one goes right to real
>>> issues that actually matter. Sweeeet!
>>
>> Thank you!
>>
>>> So what would it take to get similar results for Rust for Linux?
>>> (A bunch of us are working on drivers/gpu/nova-core and 
>>> drivers/gpu/drm/nova, which are written in Rust.)
>>>
>>> I'm guessing a combination of "add rust-for-linux to the list
>>> of mailing lists", and a whole bunch of new Rules/Skills?
>>
>> Yes, I'm going to add rust-for-linux (will appear ~tomorrow), but a
>> bunch of patchsets which cc'ed lkml have already been reviewed, please,
>> take a look.
>>
>> We don't need any rules/skills to get *some* reviews, but we certainly
>> might need some prompts to get *better* reviews, both in terms of bug
>> discovery and false positives. If you'll master something, I'm more than
>> happy to give it a try.
>>
>> Thanks,
>> Roman
>
> Hi Roman,
>
> First of all, great work. It has already produced useful review on my
> patchsets.

Thanks!

> I've seen a few false positives on Sashiko which seems to be that it understands
> the Rust code from an userspace Rust perspective and doesn't know some of our
> unique constructs (most notably, the way we handling bindings/FFI).

Yeah, I'd imagine that adding some rust-for-kernel prompts should help a lot.
>
> I'm preparing some prompt changes locally and am testing these out, to see if it
> reduces false positives. It appears to me that the prompt for Sashiko is from
> https://github.com/masoncl/review-prompts? If I made a PR there it would
> eventually land in Sashiko, too, right?

Yes, I'm using some prompts from Chris's repository, but not all of
them. We're in touch with Chris and thinking how to better share them.
As of now, anything works, send them either way, we'll figure out the
syncing part.

Thanks,
Roman

