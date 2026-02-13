Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A10CEEA860
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 17:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790116B0005; Fri, 13 Feb 2026 12:26:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713BD6B0088; Fri, 13 Feb 2026 12:26:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F55B6B008A; Fri, 13 Feb 2026 12:26:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0BE6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:26:51 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D283EC2142
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:26:50 +0000 (UTC)
X-FDA: 84440113380.15.47C461C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 57A8480011
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:26:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W62OQ1ai;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771003609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfaCKijQcT5A1lDcGYwp22+4kKYfAdpHrh2rBd+s2Ng=;
	b=0m7XbprsEGRrP9ecSBEZkQB/kubh6CfBD4uNEG+6Yoft6DIH9NKy6OIKzIaXJcKszq72dn
	QwR6VVLsN47mbDGX4Oq78h8reaUXSHaTf9nkoqiyyQGyTtNvqBEJ0cePbu0J3br0APmKiF
	A4PsKPH7WdfM97pj459YHfiMwiSiKKI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W62OQ1ai;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771003609; a=rsa-sha256;
	cv=none;
	b=rPys2q47J00jNL1KMTBeh32GjTjh0JokbdLu8kcG1O5bLfdOEzWLviy2aDFNv4ziPJk8F+
	+D7RIW0/mNUtMqMaaTMj6ad/G++LRYJABLfhTsFviwkCk081SxatSRjNkol6JPcF3RnVD7
	wNrg51Eo/pjsHOXut7cUMcsM84crAr4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 78A0860054;
	Fri, 13 Feb 2026 17:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF58C116C6;
	Fri, 13 Feb 2026 17:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771003608;
	bh=l1r8VLb/JxuCT8M2BTEbNThkHetvDmAF8/je/HgRiAg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W62OQ1aiCmeKbDa2usSHRJV+w71QVJ84yJcAl7azk5OfW2VgB1aqQgh6u6nRPL3Km
	 P21Sv7sVvIE//qb64Qx0F+7Lm60IMNHf/Wz8lUVFo8nuDgeAmpjXocLv9u5JPxojHu
	 LfwzNKlZw7NVo3quoFz/2i3m55dPOVJ3Kg3sqTrey8UAt9TyacHjMFpAKUpmuzaP5S
	 IMN9Ngapfkef35TWY9cw1772DBbcDi4/hM4kibm5jaV178nw+TwmAGDO+4Z04/PgNW
	 IRIkir7WKM/0FxD5fV5QUPj2cqmO2AXf+1PJhFFnYrYg9yKuM31mhEp872/CH2+aWT
	 NK9KR5kfDzPpg==
Message-ID: <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
Date: Fri, 13 Feb 2026 18:26:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions since
 PTE batching (cac1db8c3aad)
To: Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: Luke Yang <luyang@redhat.com>, dev.jain@arm.com, jhladky@redhat.com,
 akpm@linux-foundation.org, Liam.Howlett@oracle.com, willy@infradead.org,
 vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
 <c450ee86-4c34-449d-b144-6b4dcb996998@kernel.org>
 <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
 <CAJuCfpHJyHH4=kcQcc_RUPhmLBN8HckoDW0DHiUe+FdQ+tr2NA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpHJyHH4=kcQcc_RUPhmLBN8HckoDW0DHiUe+FdQ+tr2NA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 57A8480011
X-Stat-Signature: i9i1hnoqqdgp9i5jo8yzshj88bnhj663
X-Rspam-User: 
X-HE-Tag: 1771003609-311182
X-HE-Meta: U2FsdGVkX1+eHfY0n/QHdf+F6A7wFk7edK59OLHsNg6luwzoRql0THYJAixSdE5zCjv/bw30PedS8RXiJNxGsP9nE2m1YLGv0abQgw8MQk04y40bH2qUx832DHV2i9cb0zWwMXSAx5jZd4ZE6LGZBhN6c0anchjp3yOYBq9IkRvL7UTetw8cmQmKh/fQZqglNBVOIdR9gNJ44tIVz8Qm765PLzOZnhStGatvwKiuOBrrRERXeA/afV1KverdxsNoyWCoIBVWvz9v035Jx7G6iKGvMT/1Z9v+KYyVx+sZrpMGNb5ocnK19woYJgp/KbVyOvZQNB9lZLxQcHtSHoUlY7gZYV8fb5pZbduLFNYLjhIxmkBytiF5TVsrub8JQ1AhiJH4xbrMBjGYp+uwLvz6pgkaM8/bsspXpKsQMfEzjojR9HKRTgEE8J74aZYnljV9j/JjyqeSgokYBMqAB0oWmPjC05tfKbSFqdmdn311JbXjsWRSfBzndFpjtBVkMlJl8qdRoR/L72O4/Uh67zJkl/65X2412S0oL0mg94lSE4sDJaCW2+MMip84GS2tdPZMSkDYpymAXPfk+v21sV+VeIaHQUyZA3zuBLXZHoLu8+vwtxuFiag3H2yeqQua0YG9ApHaJGqWBuxDcDWLaKosYCuZ9C6vUR+iRhAzziRS+Q9wpKYsBCD60bFpjhGwQPJtwtWM4zH4utq4LHTIWbPgmUsQdfdAF8/+ZUfmWh3qegg/PZ4273UNP52qPm6QSn9rXLYOPp3XFvwQbOlpPx/TxS3WTLChO4Xw8YYMeoOe3rAHaWaIIhWJMQvG1MQgx2JftKc3KIT+rrryLDxDXCTvznimkCWk+llMVWfP7r734zDx45xgHtHtxa19fR1BtUL8dFDgMGQr7sN1dDb235303RY6OFhIOqK24tt2iY+XOE589v27x/EI9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/13/26 18:16, Suren Baghdasaryan wrote:
> On Fri, Feb 13, 2026 at 4:24 PM Pedro Falcato <pfalcato@suse.de> wrote:
>>
>> On Fri, Feb 13, 2026 at 04:47:29PM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> Hi!
>>>
>>>
>>> Micro-benchmark results are nice. But what is the real word impact? IOW, why
>>> should we care?
>>
>> Well, mprotect is widely used in thread spawning, code JITting,
>> and even process startup. And we don't want to pay for a feature we can't
>> even use (on x86).
> 
> I agree. When I straced Android's zygote a while ago, mprotect() came
> up #30 in the list of most frequently used syscalls and one of the
> most used mm-related syscalls due to its use during process creation.
> However, I don't know how often it's used on VMAs of size >=400KiB.

See my point? :) If this is apparently so widespread then finding a real 
reproducer is likely not a problem. Otherwise it's just speculation.

It would also be interesting to know whether the reproducer ran with any 
sort of mTHP enabled or not.

> 
>>
>> In any case, I think I see the problem. Namely, that we now need to call
>> vm_normal_folio() for every single PTE (this seems similar to the mremap
>> problem caught in 0b5be138ce00f421bd7cc5a226061bd62c4ab850). I'll try to
>> draft up a patch over the weekend if I can.

I think we excessively discussed that during review and fixups of the 
commit in question. You might want to dig through that because I could 
have sworn we might already have discussed how to optimize this.

When going from none -> writable we always did a vm_normal_folio() with 
anonymous folios. For the other direction not.

-- 
Cheers,

David

