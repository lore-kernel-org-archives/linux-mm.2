Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 031F1CFA749
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 08:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CF8A6B009D; Fri, 21 Nov 2025 03:27:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3805B6B009E; Fri, 21 Nov 2025 03:27:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 296A66B009F; Fri, 21 Nov 2025 03:27:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A03B6B009D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 03:27:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE23A12FBDF
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:27:50 +0000 (UTC)
X-FDA: 84133935900.24.99E3310
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id EE9321C0009
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:27:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=av1gtC5H;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763713669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1bJgHbg/2L4/RVaiIJCXSCr8hCjenVdUDVCyD9ABkk=;
	b=J5emEBRNZ61s8t9CTguhOj0ZKluxvil5Cn4gjqt38tIhF3FPsgOFkAMqog8/2cXSq15nqz
	wrN6YlgXfwDvmK0mXvT7UeNd5lIoYjwmtAqzK8ij+z4TXKvQ/oDim0k9OfnvJ+Yyx8PlLQ
	tCrii7owpwmmr+ZJxG9eyFTQfi33wgA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=av1gtC5H;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763713669; a=rsa-sha256;
	cv=none;
	b=iCIi0oaT9POlHXfGG15N5iW4UCoEDjF9ZwYX5HxcpI3flqMB+fRk0SdfspliCx/tDulhuO
	qmSzMeGqR3o8T4W5Z9WKCfqxr33jQbh4+Im49hEQ4oZGNRX7Aw0HCXM6uX7z8rawjCLrN2
	fqL3qo0EWy5YHGA7SqK3PknczgJcJdk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E808741A96;
	Fri, 21 Nov 2025 08:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE7DC4CEF1;
	Fri, 21 Nov 2025 08:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763713667;
	bh=q3avj8C0x+5TrGoMHRvsJCSM84EjvZAloW/aJ1VY3gI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=av1gtC5HoA0gXaHSqb5Sg01Zfc8XdsemjJTwT2tB3cz1I7ITELrT8f9BP9V/W/g16
	 y5O7TOmgOzywI21SnV2x60/GhIec6u2uFTXvNYLZ7Nr6HAvwZPJs8GddjQ8cR70cE8
	 hYogf8PXLMfptGRMZieTKuK1mUVXGHFcRpBWmimjFjFtYscDRA2anwBDgY9ITQAz8P
	 AfpjmyftRXerV6smR8lbDNaVxj+VjSqihrYbQIRRyLd+F7nIGQ93g7VD+A3Y2rnAoN
	 0aQ4rObuKsprBk0F4k6qGX1VavfTGGhDl2mtF/+w6ni39n+dAZGAL8lGDjfGvI3KR+
	 78zxm7PuxB0ZA==
Message-ID: <528997fd-5dcb-4332-845b-18828931417d@kernel.org>
Date: Fri, 21 Nov 2025 09:27:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 39/44] mm: use min() instead of min_t()
To: Eric Biggers <ebiggers@kernel.org>,
 David Laight <david.laight.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Christoph Lameter
 <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Tejun Heo <tj@kernel.org>,
 Yuanchu Xie <yuanchu@google.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
 <20251119224140.8616-40-david.laight.linux@gmail.com>
 <7430fd6f-ead2-4ff8-8329-0c0875a39611@kernel.org>
 <20251120095946.2da34be9@pumpkin> <20251120234522.GB3532564@google.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251120234522.GB3532564@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EE9321C0009
X-Stat-Signature: umn5dfrmahi3kd7tpggta87uxxeey77h
X-Rspam-User: 
X-HE-Tag: 1763713668-458924
X-HE-Meta: U2FsdGVkX1+l1gFWHl0MzXv32ljrSsrnupROAc9zLtK1DJePnxIhhZEJCsfjF13ElRYFAxI855I54kzmrShRRc8+YpuH6KD1Cpjt7QlDDIc7JPFf1OHYVpc80ic4kdSL0LUWaYU3ngZOyjsTdZw4a9Kv1cnafCXSYj8R5zohNMEYjXaxqVWzeu5Ubgcpe8u+xegg6Ben3P+6IGULq6yFYD/IN06ovKbx+W+bh3mMBmLuVSqF2b3KlftVILGhiTXla/sFkBd9A3+zlKXaFPhHrnixnroNFld9X5MJJdsqZgpUeWM/marVyttEAwHtxBsX/puJ9foa/SEY5JSMR4Ccyu252aE13buWvV5FZpcxp0uy2yWV5sqaK1jeCs/x9eCQ0zXItkLiNK9Z/j8KBDn1H0udcQJBxLsW+etNeJjYIRCKb0nZSniF6UEGeBY2QSIZM+3VkkEzZqpVoLKnx63W4JSaMiRYlXxqHbXqDsMEiUy06cSWAsmgfN1mVbo+p+2Ud/993x9N8SrvBr6SjpF+XrWmscJUA10XDPOtOTnrctitMuDO8wJqWmKAubc45/8jCv+nAn4ZDnn8X8WgCPWsNxemZIyQT3kaBmbC7tT9CxSvViyKUZAKJgv8xpiTlg8dK5YVlDAAXh3IWUJsGJGDpEKWIvMJ9bJAp3DOLEtbiK0d5u6x+U0m9PtnEZpEAZujZFg2YwZOF6jFVajpQwzwDV3qY4PrkEXkiRp8ttuRTxGrleBtvjr8qyN462yf4JiwSY+QR6vfDMWon87juh8gCxZSJblqpa5wrv3iqZaYsJT66XGqO31RJs8o7PNjtpks0NBjINQJQWOmfc+f7C+b/jR28rmqSa5Z2Fhs/XUy19Z8RwpQ4eub+pZYyrfVWqajGgHap+l9T4EUvHeEkcQG2/1JN1qlDNqHV0HCRB4ktOsDtZP6oqFqemS+MJcb4SvqJA5iCYSRdTF6LJKIHjG
 I9bBmxnI
 y1cjoiB6nwOcVdV+x+RYCVI0suG855Giqn9cylvazoaXpOr2zPiUMWvcM/ctq99sejBuCfdcaA3o/1R3UYz1w0jcWArdpvnOJtLcum6FKz+6BYzujvkwvSyhapayh2szGct8Y9YKXC5eyGVv70Cu4icJh5L97wzl7i8GsPOQzDOa/xpaQivEwjOw+EFG+4ss4IB8vbJCGn4vT58EL4JqlG7o+RMnrdO8ZFDqmVKzbIK9q1hmrgLkwIOXWjrwECIZYC1qilaj/qTe2ysWa/esAzo/Hd9jaMfZuUgwxvkdPUjj6ENkg/GgwyVaCNXnekhn0Pzd2WNJIzDcLajz5OkN1F79kXEHCVZ1KH1J3dbvkBBNx+zZrqhTWcM2nxbSsYfxNVyQswK3YLe8TtffQqoE+scS/MOp4LLbL1szaMU6nyM0R7uRNdQaNtk/2eKE9cY3d8F/srJ6kXrTN+pJP3yURongnBWiIj4e8ZBA699AU0uVmxFQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/21/25 00:45, Eric Biggers wrote:
> On Thu, Nov 20, 2025 at 09:59:46AM +0000, David Laight wrote:
>> On Thu, 20 Nov 2025 10:20:41 +0100
>> "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
>>
>>> On 11/19/25 23:41, david.laight.linux@gmail.com wrote:
>>>> From: David Laight <david.laight.linux@gmail.com>
>>>>
>>>> min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
>>>> Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
>>>> and so cannot discard significant bits.
>>>
>>> I thought using min() was frowned upon and we were supposed to use
>>> min_t() instead to make it clear which type we want to use.
>>
>> I'm not sure that was ever true.
>> min_t() is just an accident waiting to happen.
>> (and I found a few of them, the worst are in sched/fair.c)
>>
>> Most of the min_t() are there because of the rather overzealous type
>> check that used to be in min().
>> But even then it would really be better to explicitly cast one of the
>> parameters to min(), so min_t(T, a, b) => min(a, (T)b).
>> Then it becomes rather more obvious that min_t(u8, x->m_u8, expr)
>> is going mask off the high bits of 'expr'.
>>
>>> Do I misremember or have things changed?
>>>
>>> Wasn't there a checkpatch warning that states exactly that?
>>
>> There is one that suggests min_t() - it ought to be nuked.
>> The real fix is to backtrack the types so there isn't an error.
>> min_t() ought to be a 'last resort' and a single cast is better.
>>
>> With the relaxed checks in min() most of the min_t() can just
>> be replaced by min(), even this is ok:
>> 	int len = fun();
>> 	if (len < 0)
>> 		return;
>> 	count = min(len, sizeof(T));
>>
>> I did look at the history of min() and min_t().
>> IIRC some of the networking code had a real function min() with
>> 'unsigned int' arguments.
>> This was moved to a common header, changed to a #define and had
>> a type added - so min(T, a, b).
>> Pretty much immediately that was renamed min_t() and min() added
>> that accepted any type - but checked the types of 'a' and 'b'
>> exactly matched.
>> Code was then changed (over the years) to use min(), but in many
>> cases the types didn't quite match - so min_t() was used a lot.
>>
>> I keep spotting new commits that pass too small a type to min_t().
>> So this is the start of a '5 year' campaign to nuke min_t() (et al).
> 
> Yes, checkpatch suggests min_t() or max_t() if you cast an argument to
> min() or max().  Grep for "typecasts on min/max could be min_t/max_t" in
> scripts/checkpatch.pl.

Right, that's the one I recalled.

> 
> And historically you could not pass different types to min() and max(),
> which is why people use min_t() and max_t().  It looks like you fixed
> that a couple years ago in
> https://lore.kernel.org/all/b97faef60ad24922b530241c5d7c933c@AcuMS.aculab.com/,
> which is great!  It just takes some time for the whole community to get
> the message.  Also, it seems that checkpatch is in need of an update.

Exactly.

And whenever it comes to such things, I wonder if we want to clearly 
spell them out somewhere (codying-style): especially, when to use 
min/max and when to use min_t/max_t.

coding-style currently mentions:

"There are also min() and max() macros that do strict type checking ..." 
is that also outdated or am I just confused at this point?

> 
> Doing these conversions looks good to me, but unfortunately this is
> probably the type of thing that shouldn't be a single kernel-wide patch
> series.  They should be sent out per-subsystem.

Agreed!

In particular as there is no need to rush and individual subsystems can 
just pick it up separately.

> 
> I suggest also putting a sentence in the commit message that mentions
> that min() and max() have been updated to accept arguments with
> different types.  (Seeing as historically that wasn't true.)  I suggest
> also being extra clear about when each change is a cleanup vs a fix.

+1

-- 
Cheers

David

