Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F528C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C0AB6B00CD; Tue,  4 Aug 2026 17:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4716C6B00CE; Tue,  4 Aug 2026 17:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339386B00CF; Tue,  4 Aug 2026 17:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12E9E6B00CD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:37:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8F43A161B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:37:36 +0000 (UTC)
X-FDA: 85064898912.13.14DB817
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf05.hostedemail.com (Postfix) with ESMTP id 060D810000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:37:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=Ih+A+O9u;
	spf=pass (imf05.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785879455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YwgPW4vgXkOtwCrUFfOx8SqTrD0YbybXeQIXMZk7Uo=;
	b=nnIcpXMkjzZ0cZFndV2T8x+rYU+ANYbljAWDyhTsivpxRiif/C9gagwfmhkUUR9UR8HUsr
	hq4dB1rUbb/SRAQd0rARR77/ci9cklG1ibd9anWX59Tsx6ODN0o37V5uNzaIwzARpORBXI
	1rQIUbFlMZ1FSOltvCzpxnL9ra1oJ3U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785879455;
	b=JqPHxZPEu7nCneFgeLQLDzFia6+vQvKpcKZbmWgTahZRBIyAoPgsA38975zwa2a+GbpLnZ
	6YWq7aSIXWRJN0w0NA6sqM+JO80aL0xGGpPzqw/S0c7dEYfpDEAs9KQ19ybYhHzzno7y0g
	bAgaIuLp/mnFkqbeiUN7+myJKIvyzc4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=Ih+A+O9u;
	spf=pass (imf05.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1785878717;
	bh=M/vpVfOy0ZJgZObdzgYIGpqP1l9lPmPwrb1z7aUnbOU=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=Ih+A+O9u/vqY3y2yQbQLUy9ZGbUCaRGM9+alosQw4rgd1vTGEQWgSORSDb3CeHAv8
	 k5cKagTzvV67klavjupMCCotkRDvhlTsNDtODCpQVZpx63uh+H5llAefcJzIHvfbLT
	 hpEPtn06WQr13xj26rknRumyVv9OVS/yINQPJLaA=
Received: by gentwo.org (Postfix, from userid 1003)
	id 57B10408AE; Tue, 04 Aug 2026 14:25:17 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 5686F40287;
	Tue, 04 Aug 2026 14:25:17 -0700 (PDT)
Date: Tue, 4 Aug 2026 14:25:17 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
    Mark Rutland <mark.rutland@arm.com>, 
    Yang Shi <yang@os.amperecomputing.com>, 
    Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org, 
    urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org, 
    akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, 
    agordeev@linux.ibm.com, linux-mm@kvack.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
In-Reply-To: <84b31836-1d10-4bec-a469-468b91fd4645@kernel.org>
Message-ID: <9f146ce0-4adc-0c00-a2d8-c01b47edc9d1@gentwo.org>
References: <20260715180455.515692-1-yang@os.amperecomputing.com> <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com> <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com> <amCPBrdltFSE_fEf@J2N7QTR9R3> <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer> <63ea8156-a109-b2a2-6d35-1c17ad7f1a9d@gentwo.org> <84b31836-1d10-4bec-a469-468b91fd4645@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 060D810000C
X-Stat-Signature: 1xc3f6pyzt8kp4owm48rnu9f946gruwg
X-HE-Tag: 1785879454-12264
X-HE-Meta: U2FsdGVkX1+A0fEDF/bnC9Yack6ZC5YI0u+xhyrVDdVmAO56yVlzugOG9hwE7yz8zT/pCJAgk9yuIowvyVc+4Z/yFnFt94A8r1VS8oUP7hbDa9uJy5Xmaw+vw3+XNIMCH5ZSv8iIUAC7T5+nH78XyyRtQDSFOnVm3pq1mvvPdD+QWVm/aE5hGFN4KC4NJazBqffmpt0vG3U82Wr+HpJw09DwjfdZSNbLV3/ErWJ0Na74dhrF7vav06mg6o7oS86/0e06asedtyYqGazogSSKCsOKKcJzWh7Q9HtwRg/VPMW4W2f5pTXkZrG0Gf2nRMPIFcv6IFGIEVyMUWDfwjR3sxEcwVFV9uCJW9lHLywhmihpJTA2GnZOPFVhV1XNl/RdBvIV9oPpbki5xWoaTH0DaftDOF6ji59LmiPJXtuLV2FHz0K6teSBWjBFRyXI/ZO+j6lQmLF4pQNCTvYja7g4RUM4qjudc/v3ZEwErWOxEGNTijDmjP+byxRvXUlWUoTBWocNUPRjP7bGgeud3RI9is3AW2XiTftBhnOzNK7kt4LlZTKOO61bli/J5lJLHultl+bLL8cIupwU5DcyZEyCHzcLXmE2HRBIamqUDprLWO8hVNqmNIFEwiCtDWXnE02uDU8FGj/wDgcaVrBzyPqhep0JXMW+WKJ2sue7PnsZ0Wg54m/lmGbWGoTk9s2YuvgAiIJFFjNuV9TZgki/qaWAze1p5ea9zzUX9VFqibFji8AbXSSWmqSe9S+SvqzC2K3RdhETQorSO4rOpOhPJYwdZq4kHVabsBkC+KS4oroSZEqb91CxwcL8/1I3wIm0AKzM48DLiqYs4kxHi7o+wHLYfLvW37WXpISXCibHincX+cvtii1gmV6dkNt93IEuMg+uo41OT9EQlDkh0uHQ5bkowWUSrVmBwoRw1R+Ztjh6apqLaHyTWknkqfqbuJczkm450pFlhD9r6/k8jokT5cm
 OQD2nX37
 pw/n6YiSWxcfpcxskEMqpo4TcQFtvMN4SUr8CxucZVlFpOZCVmcxXCiqhft3t6l+GbiUGKuz1xzz3Kd7lwBtJh49YBsH4QclQtObdWUtM9/oId1X+Tmfik8K7dDDjdxrVekEQ/DVwthNbcPBT57g58KYJP01fDZz+K+vaOlQ3lc/MdsY3atKuQmrWD2g72ZhKEbpmR4g/NzrJ/5aKmhKtGXmYJxW8U6j/1Cdh0NLjspMvEXjaX7VLKlJbDxY78ZyjkPFcnfMU4W2PjksTcDE4CyY0StuDngSHcudIHrwHNjjg+5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026, David Hildenbrand (Arm) wrote:

> > rather hacky restart logic. It relies on a long preemable and postscript
> > to each per cpu operations.

> But I am sure you did you homework and have data to back up your claims. Please
> share that data, because I am very curious.

The comparison here is a single instruction on one side and abnd the per
cpu operation prefixed with a preeamble and another instruction / set of
instructions on the other side.

Even if its only one before and one after then we are still looking at 3
instructions instead of one. This is a frequently used operation in the
VM.

You need data to show that one instruction  is faster than 3???

> Mark's solution is the obvious improvement to the problem, doing it just like
> s390 already does.

Well there is interest by the S390 folks to move to what we proposed from
what I can tell.


> If the proposed solution has a significant benefit over Mark's solution it could
> be discussed as a next step; and it must be backed with sufficient data to
> warrant all this complexity here.

You cannot accept that one instruction is faster than the same
instruction prefixed with another and something else at its tail?


