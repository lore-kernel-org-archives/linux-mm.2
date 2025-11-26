Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7874D1037B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 10:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88DFB6B002F; Wed, 26 Nov 2025 05:55:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865B86B0030; Wed, 26 Nov 2025 05:55:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A21B6B0031; Wed, 26 Nov 2025 05:55:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 687536B002F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:55:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16CEAB9CD0
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:55:48 +0000 (UTC)
X-FDA: 84152452776.13.5ADF3F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 764EBC000B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:55:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=obh8NNkv;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764154546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fD1JjuL7+sH/PzdsYfYtMefuDKkSsff/GLA6AOlmmxk=;
	b=CIy2GmZQaVFjG/HDWi4phDv/dWHK0dKtgbn1GWo7ZLXuKX+Ya4z12UWZMMdiKlGrcpx06n
	8Mcw0yFmXGzNijG9cc/E3qxAZtWtVRzqAYANmsOiVaU0rolD2LffsjPe3rCFJX1kKHjf5Y
	jO/qb1+bN9vPBimtvXP7kjhODcXBlyc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=obh8NNkv;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764154546; a=rsa-sha256;
	cv=none;
	b=FjbS0jFXFYY2j1Ck/AGkSYwQVZL8xz/Wv+pMSuG6IgJyyWifTKsYGrEHGDy0vy1JAoBemz
	YKVC+m2TUcdfcm7mNo/FnQeYSGU2Q/n1vy4q/DRZxvK+nrd0+RvGm6z/QGHHTcpSve15Yt
	rk7ZwrIBm4WXCs3peptrJHHfsCg8L+0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C3FA66019F;
	Wed, 26 Nov 2025 10:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF45C113D0;
	Wed, 26 Nov 2025 10:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764154545;
	bh=oGNv4DyKpHq5ZR78KiElZqO4gwYu9D3vDwjUdT9pq4k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=obh8NNkvbnfnbdcrZ9WUzAGHtyjtQpfYmwSR1TeSgzK2uJBxa4nvsvz8jiLzUIUfA
	 eYEvXMSwhOPd6YZtGUgV72mBMwt7290qj7Xzk+3SXVW5Iqed3Jqso/eWEFPFIXJsNQ
	 VzN+Y3P0UJw0FZR6eMuQbZjMCXXzzFm9NFuKTa+mTzele1pE64fjfWd1JRLrxbQqwH
	 uW84X0lpriczaGFeSOeDBb9XTLF0a83pEhS1E+1RzL+FF+vU/7K+qzoFZzNvPu8q+0
	 wvtTxWum6Z20RmJv+PNQYQT74koy/BaPeEWvmQbX2YsNE3o4uNQGEhiJl2s1/N0HwD
	 s1/+Aq7G5/P1w==
Message-ID: <504d100d-b8f3-475b-b575-3adfd17627b5@kernel.org>
Date: Wed, 26 Nov 2025 11:55:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] fs/writeback: skip inodes with potential writeback
 hang in wait_sb_inodes()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, shakeel.butt@linux.dev,
 athul.krishna.kr@protonmail.com, miklos@szeredi.hu, stable@vger.kernel.org
References: <20251120184211.2379439-1-joannelkoong@gmail.com>
 <20251120184211.2379439-3-joannelkoong@gmail.com>
 <5c1630ac-d304-4854-9ba6-5c9cc1f78be5@kernel.org>
 <CAJnrk1Zsdw9Uvb44ynkfWLBvs2vw7he-opVu6mzJqokphMiLSQ@mail.gmail.com>
 <f8da9ee0-f136-4366-b63a-1812fda11304@kernel.org>
 <CAJnrk1aJeNmQLd99PuzWVp8EycBBNBf1NZEE+sM6BY_gS64DCw@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CAJnrk1aJeNmQLd99PuzWVp8EycBBNBf1NZEE+sM6BY_gS64DCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y4tx4z43tgk83brors489egoxyp9iub9
X-Rspam-User: 
X-Rspamd-Queue-Id: 764EBC000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1764154546-484689
X-HE-Meta: U2FsdGVkX1/wpaSfW7F2U0dCDhPXtGLGNEiCeuHgstklWeTX6Pjh/jCMvslHPDIhJEpxmGwSEef5OXvk4rXRP5VPRrcuOjzpzIytCktuBUv8l+h7v9W/JkD0AymhKcp7d0iWYLT6K0HNHcDkmv8xY0JeN8fa7iS9AaL6NpWmfiGn7kRVnAVXg+ksYgPTmI/lJn7f8ZXnQctTlZ/UCRMxtp2kPLvv9FY3n1ttihiPd2Snflm5pidsAjq1kqqbtXO0VgQmm8HT//AfDxxLgBmK2IX/KGbnc84cY75AsQJKc2utalIi5IFr/RZLL1bddKebCAvStUAuURctdOuvI8iRxls9GhpcCeTwiM8+3rBfUyO7pyn3m5x6n9OrgGgK5gqNJmfNAon80ObbChDPx0a3qwAM4W/J17Kz/f/kZfhRZ78Lqwj23vWn6lUDpmPUbIKsjcT43H1AQLKCF/u83TCYV+C6Pk5mimGF2653bhC/up4XIrpS/S2Ge7dqko6tRk9IuEE2CQi4vT8teITP0OsykV7dHj528M1LQeYlXJGXzAPEtzv1Ku0QRBRCqG9jQdCApcFSDtq5UIYG6DimThuEsKRoKc112Dkcw/Lx1+gLTWC5LaTbzb3Vfa/U28dX5ZWlNfFMCFdjZE6mbl9Tpxniyqpv3G3WzQveLEJwaMrA+0tdVMmdij8HTlkZ2K5oQdi4VuWPJD6xO3Gs8VDqTXtZAv5mx2G4YNd6iNwybypz6kukJQuRxLEe78T/IH4gLO/PcLSenO0ycKT82sMLBEExtY5XVTzKPCxAfP3eQXKksBOdWUpvrfc2m3sW4iizA2u+ClpsEY+dlAlDkrAbpD7QrjCkKRH7dhzAkkK+gMiHsZcnI8LBvwAmA+y19Kk0lTFwLdOnOQmIyFTRcdGvqzNYiiy6i7kG5/XwKZwaO0/C68eR75EX7qOjWovh9mU2bA8V3eeo7sdF3PsbaJtMek8
 dBYydM+/
 ZW3qj4iDWzqGJZ6sJzwL5otmNZf38OwOGPnQqtTR477tT1MpaaIMJrdCHIK5H97PCGelqpqMX/0SchLiYOyVl4tOZZ4mtJPD431BlmXvH7b016w3wvuuNpjpjhR3Oa596EHtHJPoqkMYxiFNTYKBN4yoBPoyWjBU7eOSlx3QqSpUT49fK16wWCHAkORz00g5OP2CLTGkz2ZbbppFvIVp/DZd3mhtoYMPN12cNs5DvCg9HaZjzAPr/eOmmuJuDsG9T/zHzApF833HCFnWTTqQEmBjU7KC5VecX3rmAUoenUUpknxzOC7Lms382YA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> I understand that it might make one of the weird fuse scenarios (buggy
>> fuse server) work again, but it sounds like we are adding more hacks on
>> top of broken semantics. If we want to tackle the writeback problem, we
>> should find a proper way to deal with that for good.
> 
> I agree that this doesn't solve the underlying problem that folios
> belonging to a malfunctioning fuse server may be stuck in writeback
> state forever. To properly and comprehensively address that and the
> other issues (which you alluded to a bit in section 3 below) would I
> think be a much larger effort, but as I understand it, a userspace
> regression needs to be resolved more immediately. 

Right, and that should have be spelled out more clearly in the patch 
description.

The "Currently, fuse is the only filesystem with this flag set. For a
properly functioning fuse server, writeback requests are completed and
there is no issue." part doesn't emphasis that there is no need to wait 
for a different reason: there are no data integrity guarantees with 
fuse, and trying to provide them is currently shaky.

> I wasn't aware that
> if the regression is caused by a faulty userspace program, that rule
> still holds, but I was made aware of that.

Yeah, that is weird though. But I don't understand the details there. 
Hanging the kernel in any case is beyond nasty.

> Even though there are other
> ways that sync could be held up by a faulty/malicious userspace
> program prior to the changes that were added in commit 0c58a97f919c
> ("fuse: remove tmp folio for writebacks and internal rb tree"), I
> think the issue is that that commit gives malfunctioning servers
> another way, which may be a way that some well-intended but buggy
> servers could trigger, which is considered a regression. If it's
> acceptable to delay addressing this until the actual solution that
> addresses the entire problem, then I agree that this patchset is
> unnecessary and we should just wait for the more comprehensive
> solution.
> 
>>
>>
>> (1) AS_WRITEBACK_MAY_HANG semantics
>>
>> As discussed in the past, writeeback of pretty much any filesystem might
>> hang forever on I/O errors.
>>
>> On network filesystems apparently as well fairly easily.
>>
>> It's completely unclear when to set AS_WRITEBACK_MAY_HANG.
>>
>> So as writeback on any filesystem may hang, AS_WRITEBACK_MAY_HANG would
>> theoretically have to be set on any mapping out there.
>>
>> The semantics don't make sense to me, unfortuantely.
> 
> I'm not sure what a better name here would be unfortunately. I
> considered AS_WRITEBACK_UNRELIABLE and AS_WRITEBACK_UNSTABLE but I
> think those run into the same issue where that could technically be
> true of any filesystem (eg the block layer may fail the writeback, so
> it's not completely reliable/stable).

See below, I think this here is really about "no data integrity 
guarantees, so no need to wait even if writeback would be working 
perfectly".

The reproduced hang is rather a symptom of us now trying to achieve data 
integrity when it was never guaranteed.

At least that's my understanding after reading Miklos reply.

> 
>>
>>
>> (2) AS_WRITEBACK_MAY_HANG usage
>>
>> It's unclear in which scenarios we would not want to wait for writeback,
>> and what the effects of that are.
>>
>> For example, wait_sb_inodes() documents "Data integrity sync. Must wait
>> for all pages under writeback, because there may have been pages dirtied
>> before our sync call ...".
>>
>> It's completely unclear why it might be okay to skip that simply because
>> a mapping indicated that waiting for writeback is maybe more sketchy
>> than on other filesystems.
>>
>> But what concerns me more is what we do about other
>> folio_wait_writeback() callers. Throwing in AS_WRITEBACK_MAY_HANG
>> wherever somebody reproduced a hang is not a good approach.
> 
> If I'm recalling this correctly (I'm looking back at this patchset [1]
> to trigger my memory), there were 3 cases where folio_wait_writeback()
> callers run into issues: reclaim, sync, and migration. 

I suspect there are others where we could hang forever, but maybe 
limited to operations where an operation would be stuck forever. Or new 
ones would simply be added in the future.

For example, memory_failure() calls folio_wait_writeback() and I don't 
immediately see why that one would not be able to hit fuse.

So my concern remains. We try to fix the fallout while we really need a 
long term plan of how to deal with that mess.

Sorry that you are the poor soul that opened this can of worms,

[...]

>>
>> Regarding the patch here, is there a good reason why fuse does not have
>> to wait for the "Data integrity sync. Must wait for all pages under
>> writeback ..."?
>>
>> IOW, is the documented "must" not a "must" for fuse? In that case,
> 
> Prior to the changes added in commit 0c58a97f919c ("fuse: remove tmp
> folio for writebacks and internal rb tree"), fuse didn't ensure that
> data was written back for sync. The folio was marked as not under
> writeback anymore, even if it was still under writeback.

Okay, so this really is a fuse special thing.

> 
>> having a flag that states something like that that
>> "AS_NO_WRITEBACK_WAIT_ON_DATA_SYNC" would probable be what we would want
>> to add to avoid waiting for writeback with clear semantics why it is ok
>> in that specific scenario.
> 
> Having a separate AS_NO_WRITEBACK_WAIT_ON_DATA_SYNC mapping flag
> sounds reasonable to me and I agree is more clearer semantically.

Good. Then it's clear that we are not waiting because writeback is 
shaky, but because even if it would be working, because we don't have to 
because there are no such guarantees.

Maybe

AS_NO_DATA_INTEGRITY

or similar would be cleaner, I'll have to leave that to you and Miklos 
to decide what exactly the semantics are that fuse currently doesn't 
provide.


-- 
Cheers

David

