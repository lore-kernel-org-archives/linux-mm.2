Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D406F44871
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA2C6B00A8; Fri, 10 Apr 2026 10:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A926B00AD; Fri, 10 Apr 2026 10:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562526B00B0; Fri, 10 Apr 2026 10:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 40A056B00A8
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:02:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBFF98BF03
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:02:37 +0000 (UTC)
X-FDA: 84642811554.01.C833FB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7FB45C001A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:02:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BjSUjjLk;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775829755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/yPO7tF84novx/ZKn0aImhfQpcraoCgdwDIisBdm1I=;
	b=Dn/iHPwUvlRu6xPg9499tQTdYXjLoZbGrfLjZg3GNfWyOxpwvY25fPzCuTY7cqZ+m4pkY4
	mxhYGNlSEpYcYGuWP7PZldSSfBzSmIL/44bZrl4oXhhH1ivaIC6UIdJ0krENpoifq3n7wF
	Yd8JiTyp38FE4JrpS0EvCNsYIGdZnlg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BjSUjjLk;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775829755; a=rsa-sha256;
	cv=none;
	b=PGDbCnmoXWx6LAVDR+Q8CD2vsay4uUFONnixt/O0736nk6timmIc2BzzIBh311iTRY6AhK
	KZ1TX/GKSz1+C2NkaRzqYNK5IabvDzvx033yTTpMGK6lfHpoVYOV0GeYuxyXRWD2Xfk6q9
	TkbUftU2RzeQKJVe5xcDDT4bUktQt8c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4158043358;
	Fri, 10 Apr 2026 14:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4261AC19421;
	Fri, 10 Apr 2026 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775829754;
	bh=ssRJaIuBwssRP56ZSjMSL5ZmTpEC0Ki63PHBvEJjheA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BjSUjjLkTGOFGPpvVff8toBUQXVvQiqRxOXytlYiAaMNUnJcKf1ROUqciOQr6Rve1
	 sBBT2vZY/BLBqpVt7r+KWfq9S6OoLsUjF/IADhkv6rO/xmujxFhydjZWd5P3B/mIxB
	 kx8JO/koizERhCeOm5pDtkZVHVez1v4Sebmv4fWDoMK6oLEsa6/cFdbtFLn9RhBMEH
	 awRZcIR9xEhe5UHagO9GcCKJ391u/4h7qb0p+1HO3QhNUyLH+Y/v7Q4VjNQ+GB9Vvn
	 60MX9RoZN9n4qwtKAUdRPAkOiqHIX/fMXKvagmbGJg76FdTpF2se45dGEPufGNcWBR
	 sPVh7HvMjg/UQ==
Message-ID: <62dc05ec-9e6e-492f-b1bc-540c19b434dd@kernel.org>
Date: Fri, 10 Apr 2026 16:02:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] mm: improve large folio readahead and alignment
 for exec memory
To: Lorenzo Stoakes <ljs@kernel.org>, Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
 ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc, jack@suse.cz,
 ajd@linux.ibm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com,
 dev.jain@arm.com, kees@kernel.org, kevin.brodsky@arm.com,
 lance.yang@linux.dev, Liam.Howlett@oracle.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, mhocko@suse.com, npache@redhat.com,
 pasha.tatashin@soleen.com, rmclure@linux.ibm.com, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 leitao@debian.org, kernel-team@meta.com
References: <20260402181326.3107102-1-usama.arif@linux.dev>
 <803a0c15-0a6a-4c00-b6b3-eaae56d5fc15@linux.dev> <adjkCOiLgZ_-zovg@lucifer>
 <adjllNan2vgBNBHJ@lucifer> <5f99b289-629c-47c4-bef0-966d6678a2a8@linux.dev>
 <adjrKwgiZwXR9epk@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <adjrKwgiZwXR9epk@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7FB45C001A
X-Stat-Signature: m8dw56g17ft153g31sy7g8fnzgetia9t
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775829755-155848
X-HE-Meta: U2FsdGVkX18Y9j5dunuMiuZA2rU4m/8ytkcuCbvq+I6CJkP3aRjY5sfF+shI2lFd7AELCwpzaZxhVfQxTYnhX7eZOgIoZNx5mXSVxsZKb+WAI9TE7lpeN247ije/YcNNWXTmGey2IZdy3cqnsWSpzSj6pSY6mhzmbCQ9oqpiu0TJRaOOz+2dSkf71NeA5Jj57EVpe6cViexTa37AbKVOTiLBejjqR35OS4nqKwx0rXshGJ2Y1lxtg6orhw4Y63UBVzVnr6VJQZPnlYvKlrrY0eukvEe3uMLRLcRQdsO/oRePKdySYJUqQU/5KHji3VTA+YDCks1bY8P/Jvz7htdL48waIV0Zt6l07nqIBbD3K0FSc5CaHPKXmdDbi5DGzABLGvsMwqnwCSnx5wxY0gamXWf0j54nrx2OLL7Ny5dqc0S6aH6HVSwVuGzt3aBR3zfK5S7BWBSZz9kzJC4hHI1FXukHwoQT14dzmnAe7M9i7XYhIk4A5JrDT+eGcKTbh/krLVpISC6fpDsiTfyq4d0GboBW55/cBeMWmxxhKexKJk3wC8t4WeIQM3U523o314efUMyU3LLQrpZoAHIaRVIWCCPV1XCaVvPiqpD6CMgls2BIwqSEWnw3cYIGUWBIrr5nqHpmWKbcsYESNUO3ywHib0Tk6LSul8QwhovCf0g/1E5sjsBKGBApJgqOBrqPyJUjNV/dVHno2Pa+ydm/h5EoiG/kNI3/DihBM546nFlE51rskpDJlEjZW1bRK3O9yyNuQsOuIb47uVKJ9Qy143u7Nsxiv23rc9dfH4yV7MtJxo1aS3FbnVBUMHzRs+hDEzPubl/1EBN3uZaDaa9xBXaX0/NsMaGxHhHVR2JocJUgKkFiL6JgfhuKZniT8OdI/S4pGcRtxYUxz0MutYz00HV/BbtWn7rUtkcriwf/DpW3UZsZ7SUvTAp3rTIvXgbqxfIXZhllQmqgQ4+ICgvhFHd
 9irJLcdl
 I7h/S3J2BsiA4/iwxiVa7gGxjOSMzrJAFNzi73QIf9Oixc3QC0AheITHi/JtMGRHq6YPgInICk9LnkCBGVlEiYsLSohzz3Pf8Nt+WFf8MHfkcMyhEViS5Zzn8IzMxZIDyah6euxKt53aH0YLIoMnNBvPk5bTtAON7+013vM5PSVOnT4BPyVl/Kpm+zkyxKQvJmFPV09QGwYNV4qNRQqW6XwIBuKX+ohRI+Rei1766UU4TbpBczAGiqh8AxmdDoiuECtGj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 14:24, Lorenzo Stoakes wrote:
> On Fri, Apr 10, 2026 at 01:19:08PM +0100, Usama Arif wrote:
>>
>>
>> On 10/04/2026 12:57, Lorenzo Stoakes wrote:
>>>
>>> (Note that we're in a 'quiet period' from here until -rc1 of next cycle and
>>> won't be taking anything new until then. We plan to do this from around rc5 or
>>> rc6 of each cycle in future).
>>
>> Thanks! Just wanted to check, as I am always confused about this. Is it ok
>> to send patches for review for next release at this time? So that they
>> are in a good state when rc1 comes. I wanted to send PMD swap entries
>> for review after I am finished testing, but I want them for review for
>> next release.
> 
> I think different people have different views on that :)
> 
> I mean it's debateable whether having a glut of new material on day one of -rc1
> is preferable to having a bunch come in that might or might not get lost along
> the way :)
> 
> I personally feel it'd be better to send during the cycle window rather than
> before but I suspect others disagree with that!
> 
> So from your point of view, feel free to do what you like, but maybe David +
> others would want to chime in with their opinions?

I personally don't care that much. People just have to be prepared that
there will be little review on new (non-fix) material during the quiet
period.

It will sit in my inbox one way or the other :)

-- 
Cheers,

David

