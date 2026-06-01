Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C3ECD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39766B0401; Mon,  1 Jun 2026 11:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE9DD6B0403; Mon,  1 Jun 2026 11:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFFBD6B0404; Mon,  1 Jun 2026 11:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF5976B0401
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:04:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6BEC31C0C9F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:04:37 +0000 (UTC)
X-FDA: 84831665394.24.0331DE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A5EEC40013
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:04:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4m6Qqxk;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780326274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQNb61zXpFFD8XIW8mUB4tbuSQn52A/JTs9JRBZ5O14=;
	b=1BAryAaRnfnvQduU/+vrUR2d7LteZBsYVwWF7qtjdb2a+4s5bsNtfiHeTzNjvXATeutuni
	YLlRRiZHrT9tkbHZkgP0fJOgPoR9ims6MrqaWfanAh3NnqW4amBVqIHR9gswt8sDMXYmVB
	y0biS//Y3fUlHKT2cHNRF0iIyBjsQQo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780326274;
	b=sqPtB0FLT7WF8V2yagsTlfBDYckjk902Ou8OuklV/4ajJ9/R5HxBrdeLnelDrLN0QaTOBm
	ScoU+M4bdZ8IRuNBBqOhDdBAeMoUFaeXlgjHfqb+5cXmTYf8xJYh4nqipFkq2sPoSdoap6
	NpXj1c9RToyfozo7e+9XsNgtu9cNrRs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4m6Qqxk;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 19986601DE;
	Mon,  1 Jun 2026 15:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6763A1F00893;
	Mon,  1 Jun 2026 15:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780326274;
	bh=eQNb61zXpFFD8XIW8mUB4tbuSQn52A/JTs9JRBZ5O14=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O4m6QqxkfAc7sZtGUsfcPFq6rt1bPHxItmWHGnIY1kRKfohjkwgeeKEq9Z3JlZapM
	 OP1eD7/+CX2FqcJFZtb4WXxwz8csERM73dB6r1GhFDDnGPCyiwL5jQmo1RQJdnBCeI
	 lsve2YpejjEaunrSnCW/OE4uFfDR+FUp+Re41vcuw56utSryBKBSCZDmTSoXJMSoF9
	 o0+9XB5neNrQFz1wfYXagNIF+iMxWE79hWNL2mTqRHfLICjdKzc7lRKd02MlWUHDdJ
	 FPBUEvv+QBz0i+M4nOe/WTFIFKhXPN3k+rOFrqcIN4g1qfn+FiaMbMUtqe41yflnfH
	 H490zBtefElwg==
Message-ID: <04875b82-6671-4f43-aa59-190fd09c7108@kernel.org>
Date: Mon, 1 Jun 2026 17:04:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] userfaultfd/pagemap: pre-existing fixes
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529173448.40a37785ecbecb6868fdd6a2@linux-foundation.org>
 <ah2S7MJ2VK6R-NSN@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ah2S7MJ2VK6R-NSN@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A5EEC40013
X-Rspam-User: 
X-Stat-Signature: wr1g65yynpw83q81tb9otzyu74r3zznd
X-Rspamd-Server: rspam08
X-HE-Tag: 1780326275-772051
X-HE-Meta: U2FsdGVkX1/s527bUsI37PajR04Jli+T3jFbDfmPSyvVbUM/eN/tMrvbieAkE3qAvwdHFAXGkK0xInTPPzV4JTLMk7/EBX/HC6kJO8y8JFSk4c/dDdHtcO0AuhIth3fifdbeyCoLpZ4oonnCRznfpbOeH1y55BzxyNSWKs0sawkbqBjmWKyNCHcEGQPdz3JRxm3LkGLFK9Jxn1tDPDucOGUIn6Ou1NO0/P89cbHXljqM7tvRdWBQpevuLhwQjwGXEQUA6H4KAk8NR/OTuViiN3mHCS511oBd979PPRNVkGf0q+PBMkjmBWjscGJOavCC5krIQHX7MbyJLninroRLsp1gYYZFUgApMFJVlNywDjH3HQTxmVCpZaQZL05JdPFZLCTE52+Td4IksB2jp8Y/pmfkQpQvbhx4Q822E0SqGl/the1UGUAalzruTC0Bc9gGqJwHYfEgf5c7rUhW2FqRySHqjJ7d+yisru1kz8Hi2WXHEFO/doHslCCBmsUVxR1UmvbVs/QwV83bOwa/pjWM0Uv1lDsEilDcjtg9Seasxphy8YJJ16ymmL3gMLZ1otR4Xs8Q4GRzJSYu8viN0PUNMnhcxg5zeO6+4xPmpk17NXKQQfgpiQmdV3UKNjMPTQb5Q+DLlddKaJIU3zi+rTpbg4S4BykxfNjwvTVB/Gt5I43SMgjleWbuYeTq+AQWilqrboAwwN2EeRga6HSX4s1435O4i3Y2QDCjTRWMubU2dVN33VZl1pMBKy8tzxZk+K5Zi8FMiEtkkVEoKMdHFvfVcbKWv5nTjPuvm+ejSduIMFEYhsgxA5Pihwf17U1OOmxiOpfEWi8bN5LbHyGs1SifIAFBPVGNVuk6olsJipDhT9nU2BuWIkaSVMHUCKWY7oq40Mt4t/RDIOlnTbgIOndJzAGkaRtzVrfQuHnNpwQ6hoCRZzUJWh7D3VcEjWs1dGP38Q9cc0epG9x0M7frq+4
 M7uTWHFn
 5dhtXMtMwy1ZQYq3jfOtUKbJuQ/hEjGS4R/Mn7UcnXXDJdhqfe2LAg+2Y2j2AMGor8XSGJlvStDtOCXtPowMFPxCg1drWnpk+20p2KhFTZjfvFyoeH+laWQe90czUrXKpHiOWPbsyztwXI0yx1TWb17DzPpHfPmMkO5lB0WwgiLFfxo4Dok9zqksaj6JdGiDpBBWDlH5xrytk6ZROLHedcLOZIf0gJkcCft3O/0ONqECNaGRrShcvLJTd+yHS2Jy05QDAfzjhFsiO1MGpNygYfhIZYNJZGQNQCwKR8BlSX3WawGReftVkOIPOO1XtEGv7uFuzJQw3U5XyYYUOE6dOc2H7kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 16:17, Kiryl Shutsemau wrote:
> On Fri, May 29, 2026 at 05:34:48PM -0700, Andrew Morton wrote:
>> On Fri, 29 May 2026 18:23:24 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:
>>
>>> These are pre-existing bug fixes that were carried at the front of the
>>> userfaultfd RWP working-set-tracking series up to v5 [1]. Per review
>>> feedback that fixes should not sit in the middle of a feature series,
>>> they are split out and sent on their own; the RWP series is reposted
>>> rebased on top of this.
>>>
>>> All six were flagged by the Sashiko AI review of the RWP series and
>>> carry Reported-by: Sashiko AI review <sashiko-bot@kernel.org>. They are
>>> independent of RWP, apply to mm-new directly, and carry Cc: stable@.
>>
>> And...  this made Sashiko point at other stuff:
>> 	https://sashiko.dev/#/patchset/20260529172331.356655-1-kas@kernel.org
>>
>> I can't figure out why four of the scans failed - "View Raw Log" comes up empty.
> 
> Seems to be passed now.
> 
>> It's concerning how frequently Sashiko is finding pre-existing things.  What
>> would a full scan of mm/ tell us?  Gulp.
> 
> Yeah... :/
> 
> I will look at the new batch of pre-existing issues when I have spare
> cycles. I am not sure I have the bandwidth to find the bottom of this
> rabbit hole.
> 
> What do you want me to with the main userfaultfd patchset? Sashiko
> failed to apply it because it is on top of the pre-existing fixes.

I suspect it might have a minor conflict with another incoming fix from Lorenzo
as well.

Probably put it into mm-unstable early after the next release? At least I think
it's not in mm-unstable yet and we are approaching the net release quickly ...

-- 
Cheers,

David

