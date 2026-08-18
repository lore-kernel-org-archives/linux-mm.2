Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39F7BC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624A16B07D5; Tue, 18 Aug 2026 10:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF596B07D6; Tue, 18 Aug 2026 10:12:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512716B07DA; Tue, 18 Aug 2026 10:12:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 264446B07D5
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:12:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3E9B802B4
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:30 +0000 (UTC)
X-FDA: 85114580460.08.A6110FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id DA66C140009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k7fgtiew;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDXqL7k+knl0jkjn1/aRQLOgRCL9XqV9SBb/yRhLycU=;
	b=krTxLJmthVx/4o5jAQt3kXHqYJY/zcU07ojB1b+8yRy2j5d997szWZA1XCpGxnTJQ0FvMg
	WvbCqJlXjjNuL5WT9Z7K9fgkt0r/76Fyhq53kRkns65VCa3vhkm+dij3D2LqiTFDNX5zuX
	eZcbzeMdiHc78iDbcfKFoq9YLbdO57k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k7fgtiew;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062348;
	b=vfZgax3NQlCSwbav3FfIZuFtMVfk1aowQnL1MHFZ1SHe4cyA5ZH/m8FDmhhj0dTEvqtsXZ
	tb75bSzfkC84ghG4fFaLvIJh5X9rM5ipg+oveevhaS8s1l7Hsl8LXSKc2N4hnRVf1MQkqC
	EPANyW8qPfb3qvr7z125hZXCKietQ+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57297601E0;
	Tue, 18 Aug 2026 14:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE7C1F000E9;
	Tue, 18 Aug 2026 14:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787062348;
	bh=VDXqL7k+knl0jkjn1/aRQLOgRCL9XqV9SBb/yRhLycU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=k7fgtiew3sQROMKATfkzeYmZ8lMA4FEFtSOWmgJKmHlC/KVM8bYABwCDJOILFZn8V
	 4+PlOo5WhEFiD/6YT5j0I6aydDO3hY20SxflBZhvNvviV3nhiYixa6zaVU3M1UYw7B
	 u1P2Isq+pze0hJRmlUtlbXehWcf6OvBiv3JICbLfmjh9SrMLd8Qub92HH2/FUdu1cX
	 htZUt+eqVM6BXdGGJ9FFX5m5gOYR0v/NSF3bzz/qbgMGVCGQLbUUimvC1YgJ1u46nG
	 ctUj6ckK8JIYMgsg250bFMC6JBRgVSiAqSoqk1EY6npKMtCjYDtgzevhVBkECLsAbd
	 Q2TdWq+hJFwWQ==
Message-ID: <0153303d-f9d6-45ea-a276-fbf2e5625ef9@kernel.org>
Date: Tue, 18 Aug 2026 16:12:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, nico.pache@linux.dev,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com,
 usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 jannh@google.com, willy@infradead.org, pfalcato@suse.de,
 rostedt@goodmis.org, mhiramat@kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260816224609.308019-1-kirill@shutemov.name>
 <aoLAly-oL2OAa4n8@lucifer> <aoLkMUtmzRVuv2Hx@thinkstation>
 <aoQ77EcD3M2kjeya@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aoQ77EcD3M2kjeya@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DA66C140009
X-Stat-Signature: m8t6qydo87694a5eksix7mgsc3fpirtd
X-Rspam-User: 
X-HE-Tag: 1787062348-595034
X-HE-Meta: U2FsdGVkX18VxFGM8EyGIK+6YIfPOrzI5hXzLU2jedNJPQqRMyOtc8e48cA8aakZasU3VdqeqJkfhLQwIZU+5cp4As3SzMNn9SMBB4XAWO0UTBDFPxCnoadXXmYI5aIm+xxyi7jeANhlhxnbElOnWFzCb6Mo9CfkX+w2WQTqOU2dPkd6NsMaklXPPWR97Clf6c5OL8hGrDYL/qeomRmcKVm66322m8YdbWjKLVdD6ljCrNXyhpC5tDr4O0DqPp3GpsvZHUzpW6p0bmQAZDpTpWALQDCH1o7WPCJiX56givNfm17QIjyNchguVOKDjekAPbsI3l9bU3lUxZiQCVNEo5FG7+/TlQ78d3NaxpEgUa3Z48Tv0NhEPfbqWG4joA9oLwrWpxQO2vTgYK35c+aZYLcK0Sg1BDpZU0bBjnax6Ujlpcj/2GBSM5HokTnfdpC4ABMhWPcv+k+JW0IZ7hBafFRVdqWU2LFPoi6MfDC8GHTWzelp9nD5CcwRyyK8gm2+GtFYlBlm1PkZTpiQsLnAHzMoMeZ//sVldfFXntDFOJ5nSv8luq3TOYvy0vMTtE1MTVnevj/5R5+xT9y0PqLexngxm+fmclbmgaDtZjBkSsQL6WakipRsIsvLRb5DxxwDuhr1HiURmIxBXRAg4FgaihvpF4eD/WMuDzewpbLakwUImfWxQy4lmBsO8ApL75MO0MiSycR9SJUbUHWz05qy/yr+lkBdzZhEhZgNLOwjIzBVt5bXI8R1wBFUkF7k+DywwaQqYIfVrsnFFaOnJ99VqJZ5BNYh0Ii0aA3BYIs37esA7XoPHDuktS7RGGgXZgkPQMGUcXWVR71Gs/jolJDTX8Edp6dYwfb0bkLd5FUtIB7ggzQIQXpFtbQwrkpcnFxlYEyZENOH6N96bfVrfcCDzcxuoM9qRPIrCrQT4AConV0aSBk+hTszWKL7oQrb3eLrSl+R52Ar+G0WLIk/E/5
 Wl0+Aftn
 cay7VFbyRqV6JlFC6d+vbaEGOvKXqgoLCJFhCesvKIDHidl7ilUcvgCJuXslldDMztJob1rfEF0xYu3syMxuUUTtfIWWiC0vbeKFT8hkLslQ+vQS3p5qPujxAbMqfczeENlgCLbXxVrpx6dCeMgWdsbvaB6ePQj9Udct07xURe64kqjKUdy35uhGycvLEjpfwLR6UM6Tkb+lhzvi9VM88Iy+bCA4MNHwOb2rf81MPFrs3dJvJWV0mS8yjpX3BWapW4znN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 15:06, Lorenzo Stoakes (ARM) wrote:
> (I'll reply to the rest of this later)
> 
> On Mon, Aug 17, 2026 at 02:38:44PM +0100, Kiryl Shutsemau wrote:
>> David and I talked about this at LSF/MM.  I can give it a try if it fits
>> your idea of "feature freeze" -- and if it doesn't collide with the series
>> you have in flight, in which case I'd rather go after yours than around it.
> 
> Whether intended or not you sound rather like you are trying to override me
> in favour of my co-maintainer here and it's... not helpful.

I think Kiryl tried to say that we discussed at LSF/MM which areas of MM scream
for an improvement, and we discussed that khugepaged is just horrible code.

I think we all agree that there is a lot of room for improvement, but the big
question is:

(a) When does it stop being a cleanup and is a new feature in disguise that
    makes the code more complicated and even harder to maintain.

(b) Can it just naturally be made looking like a cleanup.

Ideally, we'd get b), in small, nice-to-review chunks that incrementally improve
the code without inflating it heavily or moving everything around.

The current locking is nasty, so anything that moves us one step closer into
something that is not only simpler but also more scalable is nice. I am a bit
concerned with the churn in the series as is.

After this series, mm/collapse.c itself is way larger than just mm/khugepaged.c
originally, which raises some eyebrows.

We should also be aware that people are proposing file/shmem mTHP collapse, so
ideally what we refactor would naturally unify some of these code paths.

I am wondering whether shmem mTHP collapse should come first. (I'm hoping that
shmem mTHP collapse can unify some of the anon+file collapse code in a nice way,
to similarly just look like a cleanup while enabling a new scenario. Which is
really what I am hoping for because the current code is A MESS with weirdly
named functions all over the place. I hope it can be unified somehow ... and
that needs some proper thought)

> 
> David and I co-maintain THP together, are in constant communication, and
> have a great working relationship :)

Yes! :)

> 
> IOW - if one of us states a position on the sub(sub?)system - then take
> that to be the actual position.
> 
> I have poured what must be hundreds of hours now into THP maintainership -
> it's by far my biggest workload on the maintenance front, by far the most
> painful and by far the most thankless.
> 
> I do it because I care about mm a great deal and am, frankly, driven by a
> desire to see THP turn from a flaming trash pile of a code base with
> confusing semantics and many, many broken parts into something that serves
> the community's needs with far less maintenance burden.
> 
> Looking over your series it seems some of the patches works in this
> direction (great!), but much else of it fundamentally changes key
> behaviour.

Agreed, I think we really should unify+cleanup the existing code first before
doing more drastic changes.

Having a series that throws all of khugepaged.c into a mixer and pours something
new into collapse.c is ... concerning :)

But I am sure there is a way to incrementally improve the code? At least that's
what I hope.

> 
> So it's just a question of deferring the latter until we get to a sane
> point with the former.
Thanks Lorenzo.

-- 
Cheers,

David

