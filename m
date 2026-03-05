Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4717F47CB5
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 18:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 213B96B0005; Thu,  5 Mar 2026 13:59:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D47E6B0089; Thu,  5 Mar 2026 13:59:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE3D6B008A; Thu,  5 Mar 2026 13:59:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 005086B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:59:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 879FB1C179
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:59:25 +0000 (UTC)
X-FDA: 84512922690.24.D06A3FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C69AF100007
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:59:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cb4kQ1JA;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772737163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ms/ulOqa+QKXpvziDGaGe2CHDCqEubb3NjhezrxJ+9I=;
	b=L6+9f9Bp6L6vBg8HiXHdb9KBOvdxy/mMFFYSKpEo43PYGYQJTDElF7XB6/j2nwsUDAzwMy
	HD3purkMj3iKyAVf9BBjhO2G4yZXJxj80kQRkEnThSYILj+/SavAclerxr+i1lvZy+BRqY
	d5sqQm2yNGMl4mj3PuJfnW5pB6sFZ1Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cb4kQ1JA;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772737163; a=rsa-sha256;
	cv=none;
	b=bi+RzhZ8urMFZo6gkWhgoEs08ImJ0W31PobBygh2OJv5eegtOC9Sja9TibmSINoJcW6SpY
	0pNZCq3VLpxMd2k9rbwt2N8zCnujlRaubuGJ49YPOO09rMNmuCNxbxx4vlUilzQXFo5/Ps
	VAuQ+WH5ykydrv3NduBm31hIy1Wijtk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DAC6360053;
	Thu,  5 Mar 2026 18:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9BBC116C6;
	Thu,  5 Mar 2026 18:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772737162;
	bh=rkRfD6VcnDbOWmGXT9dEd6pLpExZh1lBbZzBr4RpzrI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Cb4kQ1JADpegZqRJjJv6ho55cCfXaFkJ62EGyLUFZNx1QtUudOHPIQ3I0aLOZXju6
	 3XsmebWYwmT63NLyArWBYnqAyclbz92AXcEsAcB93ZXm3E9xdOx1n17hDeAyK27eMR
	 WcBawrb5B0Du5RPvAX5AD51OjQVzIR+VZF1ovKlpYiC4+9fH9R6F5Pre0+iB1dOMUy
	 1Jv4MOabbDRbYarm3B2aQYf6mRH6J6oH+ZdA7fPr4B2vJJWCcsTNFfRqRgV4tFtstp
	 H4E1XEmy3faB709NrUttcJ9ThEfkVTsIx/624RH4/XfFAYz4x1QudZPklaBgbfJ7cS
	 3oL2ta1G6znrQ==
Message-ID: <a21ea7c3-fbdb-4ac7-8be5-0173f54890c7@kernel.org>
Date: Thu, 5 Mar 2026 19:59:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] tracing: Fixes for 7.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Huiwen He <hehuiwen@kylinos.cn>, Jerome Marchand <jmarchan@redhat.com>,
 Qing Wang <wangqing7171@gmail.com>, Shengming Hu <hu.shengming@zte.com.cn>,
 Linux-MM <linux-mm@kvack.org>, linux-rdma <linux-rdma@vger.kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20260305103941.11f1b27d@gandalf.local.home>
 <CAHk-=wggaToeRYv6B5L9ob=wBdVW9_gFudYxH_WJDTuhyX_Ueg@mail.gmail.com>
 <a8907468-d7e9-4727-af28-66d905093230@kernel.org>
 <CAHk-=whW890h4m8r0iYwXEJK=MUJx9nLxuOduttRJNCLrMdz7A@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHk-=whW890h4m8r0iYwXEJK=MUJx9nLxuOduttRJNCLrMdz7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5nucngit8j95diq6r47xxcb4n4gdgy9a
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C69AF100007
X-HE-Tag: 1772737163-337013
X-HE-Meta: U2FsdGVkX1+iJe3EuZyIMuNa4U2AFBd+jEDrgnRjYFlqehWDxk8vYSEU7PxQ/d9Dw/FgJfyNdDWNGGdyH3X5Q3FL38C0EkMyW0kixZa1U6W8rXx35GBXVF0tBtVNn40M1oOynkg5LabRAVw79mWLkjZfhIEqAuvBi8agke/CV7v86YlsXQMGAVp5AaMBiqq16Vh7/wNU65/9z2rzcUt7RViaT2aEexhmKdqohlqIUJ4I9DmUsg7IsNnxrnER4+vn+vhl+FW/R19b9t/1X4qmwZSV9arWL8r6KeW0BsOgJ5nwG1VpiExOYuQUSa0vdNUYrfKFgQsPxd8w0hYStPNRAcSZG+mLYDGugBAP77TbH27V5hfa72YyNNst61/Xgfyo/6qAivyYe0oYinUL2oOzwjkKQCRf0x00EcPjkv8AyPSUSMfAAO+hNtjjty2JxjPvt6kYyJZUxOv4KItckPB4lulFTil1UHHxuIOn/RwJIDqn/3UFuxkTis8pFv+1ddgYGDXmIJohsVK8aU+vNK+b1QqpXAZrmqZz0Xn6E8wBHtTcGzFdKasuPRtnwCkSqVgPrhlCHaVovyEtW1xchGPQVdvM2aT18kC925/kMpipsC0Ge5AEQg+jdhTBeWhpeJK1+ORSmXPtHOVFKdqTUexcPYD9XdfCV7+cHLHxXhjnKXaYRC2xuBFACSzhdnTj+mgtSBBee6l1ZaYzEHNDDYcuYfifZ9JBe+TNy7EuBFJukXFgXY2YYupV7wl9t1jSkZwQCZb1akj2XQEnj7rpSVHMZCrkhBrx6RzCXeQCk4oE3oG+rU4+yCx8umIkYxw3Lfips57QwEIGdmnSdBQZLegB+WdVvsHfwhVWcDmMzIlRvufYvSKEvuR45nZCDhVY1dTff/HHZCNyAAIUNZ5fLQ2RtbTgn0aGe5DQRB8gBcCIU8rrXgjXdK64msSrnba60ZonwMBR0dQa3DklUvGajKL
 OxpxCb7N
 cseBmUuuqGnpL3fz3ZGyTCVdxyUCNVv80qmguyBYOYa7vx5zlhyvIdRsiZUfVp56nkYFoorWV4nWFNSHzxMiWRHWnBq6/D72pU9qG6O7N3wgItR4xxAC69UGmV5PPelZKa3kITMjyIrl6/6anE20d50biirt+XFRtg0MEKgJWNRQfVX0NtgCggfasuX3k8kDaTgtUQTmzrIklgnEDluFAPXNHwOSP6H5lneXRz0un6AZ9PIX1Gp+omSm0Ej0VObDQA4cCeJnNZ63sTkBossjUsog1tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 18:17, Linus Torvalds wrote:
> On Thu, 5 Mar 2026 at 09:00, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> QEMU traditionally sets MADV_DONTFORK on guest RAM. One reason is to
>> speed up fork(), because it doesn't need all the guest RAM in fork'ed
>> child processes.
> 
> Yes, I think the MADV_DONTFORK thing makes sense on its own - more so
> than MADV_DOFORK does.
> 
> Because it's a very valid thing for user space to do exactly for that
> "speed up fork()" case.
> 
> It's similar to how we also export a MADV_WIPEONFORK - for a different
> use-case, where we don't want the copying behavior (typically because
> we want the child to re-create its own set of data: I thin the main
> reason tends to be for things like reseeding random number generation
> after fork etc).
> 
> So it's just MADV_DOFORK I don't particularly like, because it had
> pre-existing kernel semantics (the VM_DONTCOPY bit predates the MADV_*
> bits by many many years).
> 
> Not copying on fork is always safe. But copying something that the
> kernel has said "don't copy" just sounds *wrong*.
> 
>>> But I get the feeling that maybe we should at least limit MADV_DOFORK
>>> only to the case where the *source* of the DONTFORK was the user, not
>>> some kernel mapping.
>>
>> ... that makes sense. Forbid toggling it on something that has
>> VM_SPECIAL set, maybe.

CCing Lorenzo.

> 
> Yeah, I think VM_SPECIAL would be a better match than just checking
> VM_IO.  At least it would also catch things like that VM_DONTEXPAND,
> and PFN mappings.
> 
> So just changing the existing VM_IO test to cover all the VM_SPECIAL
> bits would be a simple improvement.

Ack.

> 
> Maybe I should just do that and see if anybody even notices (and
> revert and re-think if somebody does)

Agreed. We could think about letting it sit a bit in -next before moving
it to mainline.

-- 
Cheers,

David

