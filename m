Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5725BC5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978396B03E8; Tue,  2 Jun 2026 04:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9287D6B03E9; Tue,  2 Jun 2026 04:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 817616B03F1; Tue,  2 Jun 2026 04:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71D936B03E8
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:25:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 213E11208B3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:25:14 +0000 (UTC)
X-FDA: 84834287748.10.C04FD0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6DE2E20004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:25:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QlNXRHxS;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780388712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfYwKww7FMGPbJDqSUJQdQvreM42hX75a3ElXylSb7I=;
	b=btu14gAwuHhItaTp8ecCT86xM4Q9JP662fjv7FqGyawlPM5wzV5kxrAhjAftKany8prP4u
	H/nuGL/55oDa4NqgshDikSG0lnZjUucONsIopu33jzHaoFzZ0B8YIi8GjWS3ZW2Mtgzk2K
	EzL2ffOMJ992ccDji5qmc5mIFdWmkh0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780388712;
	b=t+taVLeYWMots2xVaLxuDO0i+v/TEtuykxUXgLw68GR4hiRzzrTcqjHnG3Mnqlu/+hXdF/
	1DaVkUR2UgH52zCdloqrWKd6JDbYXhI2VtB/YxH3mJxvc8MfqqeDEOsXXnD1F28Vp+p+rF
	fT7YB2/InyjZItdMnBrg9Xrv3aQKJBo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QlNXRHxS;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA6D56001A;
	Tue,  2 Jun 2026 08:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BCD1F00893;
	Tue,  2 Jun 2026 08:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780388711;
	bh=GfYwKww7FMGPbJDqSUJQdQvreM42hX75a3ElXylSb7I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QlNXRHxSiVLWRkqR3Q83ejTs3EHdyrR1prTvQZYTL8YtFs0PR52piVz8fyJEJM2uC
	 hJ0TWK8wgrljJbxRonpFInx6SFOlMhVMZDhiW7rHu/6VGdbp/Oy15a+GKR94qHGpTS
	 VCQM4Fhfkz0Sa0rxZoUqWUjjPxcva4ax7udZsjeOqX0J3reXgreOaDMiaJvCPgC0j2
	 meOw6D3lKrik3jhF+vZJn3oeQsp7CD5E41F2hw99M6ee25Iou8YF8cZwu/HsyhxEqf
	 FWnXd70Qv5lqK5b7AmTLci9xmpmuJwDz8nTPaMds7BQqU2ZMFJhKvEBeT4RFna+atK
	 6NwEOEfbTStiw==
Message-ID: <821ed41e-5b2f-4d17-aeb2-71b0361f8e7f@kernel.org>
Date: Tue, 2 Jun 2026 10:25:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
To: Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>, Askar Safin <safinaskar@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org,
 netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 David Howells <dhowells@redhat.com>, Pedro Falcato <pfalcato@suse.de>,
 Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6DE2E20004
X-Stat-Signature: jhbehme1pm19erg3qmmzxe4k5cydz8tn
X-HE-Tag: 1780388712-191981
X-HE-Meta: U2FsdGVkX1+o5PGLIXnGBELWECFDLUJ1jaCZJLuWhec1P+1hXYHmF9mpK/uXy7jRczXWxMISW4BdcqnGJ/E+7XDvQq7WyZPRTTD+I6u4BvPg5K93ggi4hqITFQB5Hz1YVWCsLqQ85dtBJXgkfbEcgoeJLW8emoUPC1Xuj0o7q3yr5o5MGclqPXrpNIpb5c1Lfqdgs0NtP6gQc8xMO5kefqaZ0XsFHVLLmjTv70svu+no7BdEoC2YGp3TpMZ10LMbTRCPlEahX3C5Qq5De2ohF3rLsQl87CKCrwNVZebT4kGgFFK+75v0eGmDvNW5PCbcUtSipOQqruSlxWABcVG/vAPsuezCxX8etK8QGhQCSBF70FyDm9iV2YSnLNPzNhYR0oVER+B8d/rx4aUnoTBoiB4h3L9tBeNnmAa1YuaV6ZpA3Wl4byTie6TnuwB+f4UoM/ndRXYTsLpv6b1wdY1wcnpGuKyJvFl4BgBbNkthr8KISwj0WHQfZv6HmHPT7Rr8cx+1W1NC013faaldSV9pZTfxkL+j1GBlwsiKt5Af/3nprATUuOA4T2peh3Jk3+b6kXYk658xl8P8uU4rzVygf2a6yUW2LtcBxf19rwdXtKJjOQPCeyZl0IFsErkhYiUjMDB8eiYeFvogCLh6B2K4NOVKh9fNd8IJ1apzS4VLMN0sLbZQCBOoBHkOuBLvjwzCGdFKsUCx4N2VhIqpVF3cVy9rrGaiILM5jJ2iFp15EgL2Our2Tuh6q5pw97iryeDL+H19teeAOlhQjFfevDX8qhFUycFcLy24I2P63ZnLE6IatDDHNeIXU8GeTG4oQwRE1sV/fepl4HYK48i4hjppMoz79vBs5T6DF4gq/R4fRlnB52VI27ELRu//5grmSF2sJo/Wwum3BpGs44ATIpTZ/KZtf8/PZEZeht9YwjB+gxYpgCSpGCygbz9ql3gmgyCuANCsCEPVy31cL+euEN6
 PLlxFkJf
 BpMK1G5Q5spKj9L/PtycHyTXg4I7BrAxuSj//JLIg5gvqa5E4IB8Hgh0ulh0ncvIZ/JezVGiBtMQCR9bUTWAGDrDNa7cC/EMrJhUhGvKloN0Xs1myi+pPu5oyISq2AuqUwTeRSUt2xzM/1kUOccHQPQ5kNhA0lMBPV6b1a0oPEDcTpV4QnJyzUVfrNBrF5UEtE+SIaiMeBdUvr0mBn56tInjhuUmQT2xb7mOI3F09rDRicAxTDeUBV1G0q8z+PrIhmFklfsLzKFafLSlWrwDdOSazYA9zfK9WWeMIKLnd9oK395PhjQ2neOXEs2w77jS6zqXjpZMjzfYXSwaoQXCInV/na16mCzF2riP+ebjxkRt9mzpc3FjGuW7tN7hFE8tzHLF4JX/lMETzz/pjgT/xFvKNZIPjinm8khYkjbypNIRpcFcLVF0eX0ZUkkTxPKfg10e2Adi9LWYjNzNmVcpW6b+6YtbA8pl8wX9gzCOj8toEZViuQJ+C5dTfQcl76ZeOeTndFFjlRViYg5VcoeaDf/+Oog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 02:28, Andrew Morton wrote:
> On Mon, 1 Jun 2026 16:04:55 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Mon, 1 Jun 2026 18:33:25 +0100
>> Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>>>
>>>
>>> FUSE might be interesting - fuse_dev_splice_read() and its ilk.
>>> Communications between the kernel and fuse server at least used to
>>> seriously want that, so that would be one place to look for unhappy
>>> userland...
>>>
>>> splice-related logics in fs/fuse/dev.c is interesting; another place
>>> like this is kernel/trace/, but I'm less familiar with that one.
>>>
>>> rostedt Cc'd (miklos already had been)
>>
>> Thanks for the Cc. The tracing ring buffer was specifically made to be used
>> by splice and the libtracefs has a lot of code to use it as well. As
>> reading the ring buffer literally swaps out the write portion with a blank
>> read portion, that portion (sub-buffer) is used to be directly fed into
>> splice, providing a zero-copy of the trace data from the write of the event
>> to going into a file.
>>
>> trace-cmd defaults to using splice to copy the tracing ring buffer directly
>> into files to avoid as much copying during live recordings as possible.
>>
>> Whatever changes we make, I would like to make sure there's no regressions
>> in performance of trace-cmd record.
> 
> Well yes, The patchset seems sensible from a quality POV.  But to make
> a decision we should first have a decent understanding of its downside
> impact.

I guess most (all?) of us ... dislike ... vmsplice(), so trying to remove it
entirely is certainly very appealing ...

> 
> I haven't seen a description of that impact in the discussion thus far.
> And that description is owed, please.
> 
> I assume a small number of specialized applications are using
> vmsplice() to great effect?  What are those applications?  What is the
> impact of this change?


I did some digging, and the kernel crypto API documents using splice/vmsplice
for zero-copy[1] and libkcapi [2].

I did not find performance numbers, how much vmsplice/splice actually gives us.
Playing with the kcapi-speed tool [3] (specifying --vmsplice vs. --sendmsg)
doesn't really reveal a big difference at least on my notebook. Not sure if the
parameters I specify are reasonable.

I don't know whether downgrading vmsplice to preadv2/pwritev2 would perform
significantly worse than sendmsg ... and I don't know what the default would
usually be (default to vmsplice or sendmsg). I might try finding some time to
play with it more, but I doubt it, so if anybody else has time ... :)


I'll note that we have a bunch of selftests (mostly around COW handling) that
rely on vmsplice to test R/O pinning behavior. For R/W pinning, we can use
iouring fixed buffers easily. The only alternative for R/O pinning is using the
gup_test infrastructure that needs to be compiled into the kernel, unfortunately ...

So we'll have to adjust some tests there to use a different interface. I'm sure
I can find someone to work on that once this change here landed and doesn't have
to be yanked immediately again.


[1] https://www.kernel.org/doc/html/latest/crypto/userspace-if.html
[2] https://github.com/smuellerDD/libkcapi/blob/master/lib/kcapi-kernel-if.c
[3] https://github.com/smuellerDD/libkcapi/tree/master/speed-test

-- 
Cheers,

David

