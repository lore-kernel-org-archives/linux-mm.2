Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00879CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578F86B0005; Mon, 25 May 2026 23:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550E46B0088; Mon, 25 May 2026 23:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48DFA6B008A; Mon, 25 May 2026 23:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D51B6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:35:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDA021C0167
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:35:17 +0000 (UTC)
X-FDA: 84808155474.05.FF72864
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4B5A64000C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:35:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="n7//IyJl";
	spf=none (imf11.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779766516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=527TQNohQgXTy7ya7qpWQCeh7V6iZfuABrEHgfWiUv0=;
	b=fDIETnHn5UESB1A5RRTj/UtX5CDNa+ETDBDtExmum8tL1wI35xceDdozfYud+hG4BiDnEw
	JoF3YXsi7r0UUBvj2hiYyR8m/s2LiaO1PoI9yZnTvJsJW5DTr0V6x4o/teeg0mzp02wE+0
	usq7w2amzLA6RR47/y21G4xXj2ujEKY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="n7//IyJl";
	spf=none (imf11.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779766516; a=rsa-sha256;
	cv=none;
	b=OCAs+5ChWCSyCKWUP1RcQDrCuB0uEIKXSR8OCeY71T0bgJNqzyuRv3TIz/h4ZD1r6cijUM
	QPfUsD7k5hPpw2ytHpeQmAifACtYewwYDAUOM+MLk4O0JquspkYb+WF9qoOFRu3Vm763rc
	iPxrly5mM30B8N32cZ6fDbXMCkjtps4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=527TQNohQgXTy7ya7qpWQCeh7V6iZfuABrEHgfWiUv0=; b=n7//IyJl/zK+ighao5zYHcv2xi
	9yzBpONPFgEHn+jpAeMzWdxE39d6MIzzhkwuotgCXfHy4eZO6iawJEp8vIgipOoGVDKqLx8ntWT37
	UK01O4TKEmSRq/SPGb2BxY4Kc8ynVjr1HEvHZp/e/vktJyuTd9U5DtUK9tD3tHC/UH3IoxnZwpRVs
	JwCVBAKH81qxp8aM6P3A9L5jJahSJkXzfqISPRV/6T5CpWfUwqswoAWHHzzRk3PXWgX/OsfCErbQK
	STsy75nGeF5ZjUSwdkiEnpFARej4s9SSM845gK7T2zKZLyy2MFaPLEczhZMoi6zaiiOuos9pcOQtG
	UqU8YnwA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRiZS-00000000wa1-1OnB;
	Tue, 26 May 2026 03:35:10 +0000
Message-ID: <8a42abed-8289-44ec-a144-dfe531a4af71@infradead.org>
Date: Mon, 25 May 2026 20:35:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
To: Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Tso <tytso@mit.edu>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>,
 linux-f2fs-devel@lists.sourceforge.net, Christoph Hellwig
 <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 Akilesh Kailash <akailash@google.com>,
 Christian Brauner <christian@brauner.io>
References: <adhPZxtbZxgU-37v@google.com> <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com> <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org> <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com> <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com> <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <ahTzHyHBL8t0iNBR@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9mpbb6mttk7dyz5ckoem8goaxw7tpn7k
X-Rspamd-Queue-Id: 4B5A64000C
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779766515-65438
X-HE-Meta: U2FsdGVkX18ttAbuX7yYNIVLuAp9sIdS2NmmyIApv8ijYvSYGJ/WtnMB4EIiLjfrzJitvU6/otMVK3MtLpi5iqACsZSwrBvjiHteNkhgWB7H9DFxOw6ksCAgFjvgfXAD4UeK/deq/ko9HQjWVkhnuIYwNz5Pddwt1gSBPZE/qRo+dR2WPvEAnpSfpq/ACmGjpH5jG9we8iz2gFeRjMjBi8npZp+BuZGnhn+Tu3IzC7kk/eeWZWZm/kof2VNa58gQL/LFJfrXIYaqSwmN3lLInJW2fT+I8OrztCbwaCPIwW0KQkvcUj9rTQ+HpYoEGEiEeJlgPBMxkUnlqxeRKwE6/ihOahxfjvx2Cj5BWGHTaDRZIOyAx9kKCWsP0Rs+jDls3HU9iHwPaLhxQTNJups5uaBbNuA9r5Ixz3cE7G4MPeCm2YK38I4IeqZa+6XJ4t1TgjkQlAg/MlaKGnlDktMdvmql9NZW9uohHAGucjQdCLygzUSKH07QNW7gdkChCuo7zvFCxp/oPjZHPCexXfkWD/jAg6CC5dKkcoWcL9L3Zh4HJ7Kp9dmB200naCKsdDnI6NlKhzP/DhNHJ5TlT6m4chKJ7ywvI5syK0OI9VADcTdnhFpRZe9XCC4UOwc9944QrD/GEvlnP6eh/9r4mpKuYgCS6tZDvgRdFhVOqiBiHlEOsqKEyc+7QxsXDg63wYof5hqhn5gm3GxHtMONfJkdoMxSJGMjUBrxTcPdAFd+CR1aB6yhxbSgNk45jYmfuDhAkxryLz3XUY2P3BeF3+g+JX3eCAfO4KUM6/lnXaqLFrw2ItnanP/pc3S6AfvjYu4g7EagJwCvvlQetU5DwpnAacaOco97nYcHLhZJ6BeQnwl/PT4smXyjMFwI40z8uqOmkAWUjDK4Z5NaUsaYMKs+d0l2VP3BSg/7k6GDDm0X6YpOis8bK5PcmQu50t0OQU+11UrBEwbYJa/NR02u8CI
 swK9Xw1Y
 7Osa8hvBIBENgXUE/0X9kNc7u8D14zrVhlAZd50gVDagpy9jxJu+79xTtwgObTDrityfPrllgZ+UdKofqYln0TwxfKocfN4FM2Rkq3oVRgR6z88DRpF2H5Zq4IR9uMOi6LnZ9997Y/b2a8EyPn8SNet7b08ZfMLIbWszGW0mIhhLUhk1Mq4mh4L3QoDst8+IBomi9Julx8ji75Nd2mlJb/YGQvSQNqZhnXihr+JsWQsOCJzSBmYrnwuuz3vJHyUrNltoh3Vx7RofPziD9DjosPinApoeDs4txwYCtRLYxvvipzxAHXU/15RTYBQnhbfBudIB6ozeiPxgzkcFNy7ncaW2/VwC/l7QYyj7uOS8ir/ZmPgi7s1YJwCxGX0w2zmAgZqIWF5AaFlYkRDiO/8hhFGlaiaBcTngUkw+Cv1QUq+3gJpw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/25/26 6:10 PM, Jaegeuk Kim wrote:
> On 05/22, Theodore Tso wrote:
>> On Fri, May 22, 2026 at 05:08:41PM +0000, Jaegeuk Kim wrote:
>>>
>>> Thank you for the explanation. It seems I made a wrong assumption on the
>>> usage of "user." prefix where each filesystem can support in different
>>> ways.
>>
>> The "user." prefix is used by all userspace applications that wish to
>> store extended attributes.  For example, user.mime_type,
>> user.xdg.origin_url, user.charset, user.appache_handler, etc
>>
>> For more information, see:
>>
>>     https://www.freedesktop.org/wiki/CommonExtendedAttribute
>>     https://wiki.archlinux.org/title/Extended_attributes
>>
>> I certainly assumed this was common knowledge across all file system
>> maintainers, but this was apparently not true in your case.  I don't
>> know how this could be the case given that f2fs implements extended
>> attributes, and I would have thought you would have known that when
>> testing that feature.
>>
>>> I shared some motivation when replying to Darrick's feedback [1], but yes,
>>> it was not enough for all heads-up. The problem started that some speicific
>>> application needs as many high-order pages as possible mostly for reads. So,
>>> I thought we can turn on large folio on the specific files per hints. One way
>>> for the hints was using immutable bit, but it turned out it's very hard to
>>> manage disabling the bit whenever deleting the files. Along with limited
>>> ioctl() and requiring inode eviction to manage large folio activation, I had
>>> to implement this path.
>>>
>>> [1] https://lore.kernel.org/lkml/aeA5C8byIpXWla7f@google.com/
>>
>> Actually, you still haven't explained your use case, at least, not
>> well enough for me to understand what you are trying to do.
>>
>> So an application wants a particular file to use as many high-order
>> pages as possible.  Why?  What sort of guarantees do you need to
>> provide?  What happens if they can't be provided?  What happens if a
>> possibly malicious, or at least gready, application uses this
>> interface to grab a lot of high-order pages?
>>
>> >From your patch:
>>
>> 1. setxattr(file, "user.fadvise", &value, sizeof(unsigned int), 0)
>>  -> register the inode number for large folio
>> 2. chmod(0400, file)
>>  -> make Read-Only
>> 3. open()
>>  -> f2fs_iget() with large folio
>> 4. open(WRITE), mkwrite on mmap, chmod(WRITE)
>>  -> return error
>> 5. iput() and open()
>>  -> goto #3
>> 6. unlink
>>  -> deregister the inode number
>>
>> Why should making the file read-only matter?  And when you say
>> "derigster the inode number", why should this be related to deleting
>> the inode?
>>
>> This is an interface which seems to be very specific to your use case.
>> What if those requirements change over time?  What if you want pull in
>> a file without making it be read-only?  And what if you want to
>> release the large-order pages without deleting the file?
> 
> Let me try to write more details, helped with Gemini.

[as an interested reader:]

If this idea is so good, why shouldn't it be done in the VFS/MM so that
other filesystems could do the same thing instead of just in f2fs?


-- 
~Randy


