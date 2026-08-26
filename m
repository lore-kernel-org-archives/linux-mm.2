Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E816DC61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 10:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D29C36B0092; Wed, 26 Aug 2026 06:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01156B0095; Wed, 26 Aug 2026 06:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF7F6B0096; Wed, 26 Aug 2026 06:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 966806B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:26:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2048880300
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:26:18 +0000 (UTC)
X-FDA: 85143040836.03.7653431
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5FF6540003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:26:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fAiGVgVE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787739976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZzPzaQOoXaYEVoYLogItx0viGNTCTJ/8a/CbB8x3kBM=;
	b=t9H4+UJwdBOcioomfsXhFQjldrD1Q71okIM+dZAbQXOe51UfpnSsTHVtCyDb5BCJi9RuSD
	Z2a9qh8GtJLag9xHRJVKQ1BUr67XLtbnhQbAa5bxCIMzzENZ1tHX6ymvPyTeRiLjh1PPtM
	1kr0WMnbOgtA3Y81kARyO/3rxearEyM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fAiGVgVE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787739976;
	b=eypsyRls87dNzljN+d+wXkXgQuYGuT9rp5EApdvkePlGPxEn+RpLTnIuNdJO6flGUgp9tH
	czc3tLMFmjAjgzDgUmeHkWNd/JLYBmJlHA/i0ICEFkZPSQDzKVuN1FAiE4Hv73BZpB0fRV
	+EN8cXcKixD0zK1t9LglxDXH1AL5Yn4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BFEEA601E9;
	Wed, 26 Aug 2026 10:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BD31F000E9;
	Wed, 26 Aug 2026 10:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787739975;
	bh=ZzPzaQOoXaYEVoYLogItx0viGNTCTJ/8a/CbB8x3kBM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fAiGVgVECPqcAhs97DVvyJ6sVWl94Hg/LZgwPbnkAVbHokg/SnVXt3owQSgxwXwLH
	 JcEfrZXMoajK4lt9Gegen1S2L7SlgdF/nSWtUjh6qJ6I8QovCGuCkOlR2310ni2F2g
	 Gs6RSMoetM94NEfuREDb03iyJPMscvUm84mvA7A4qC4XgNC2ConhRJ41hGGPO7dch1
	 M5QaOfuV9SW20ds31Hr8B82LfMwC1BeY2S1blewCN5FrjOgA89gmqTgKmtvoENONqI
	 QLnD7hrK2N9T5KOc8wH9cUUoX8eIe9gINNYo1qRCHG3HLv/uIqVFRKqbUQkLvnFEtN
	 gCyJZDnOoZ+8w==
Message-ID: <733d4be4-2983-4591-9769-e2ccd64191d6@kernel.org>
Date: Wed, 26 Aug 2026 12:26:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, David Laight <david.laight.linux@gmail.com>,
 Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
 apopple@nvidia.com, byungchul@sk.com, david@kernel.org, gourry@gourry.net,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com,
 ying.huang@linux.alibaba.com, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
 <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
 <20260821093039.04538795@pumpkin> <DKUOVAQ3T03S.14GFWAHY0I6HO@nvidia.com>
 <20260821161310.28255793@pumpkin>
 <BA5425C6-1906-4938-AE75-93719AAFA45D@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <BA5425C6-1906-4938-AE75-93719AAFA45D@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5FF6540003
X-Stat-Signature: gm815oofy8costqnnkuwnfskmofm3d85
X-Rspam-User: 
X-HE-Tag: 1787739976-544675
X-HE-Meta: U2FsdGVkX1+k0oz5yMfaddANJPa2TgDW+L+l3IpaiO3OmHNqMZ4DglxN+fDKqd6PCEoRSVy7fYTYifoaQpMwMgVKfFsPnxnjPUCR8Vv+sKxZNEO/+8x9JbKsf8ez2ms+7xlHzZQ4CCPep7PcH9iRgiDWrA/2jzHjPlz65UPM4XXTUxckuRJRDmylRgnByffPgH/sXptoPABHzwPb+WS0+sUgH3LkCkLMZI2D/rkFbhak/TgCTXd/sGoq1+H3Rl4OZJjtSw/SjDXI0XExCX8GoP0Q0yHxExCpfyz3MTWlTQzw2Ve+0oRA0LS5LhKhp5okO1YrbDQ/5Q9ra4w/Bs+8JJ4ai0O4RvsSql5BXkyF/SqfDgOkdT5ztMmOuQEihC9GwuAZfl22+GZChSR6BemRVcJnSIWLtJzDZEg/3/7+5YhScVTsns6iEOfyWlArBY9F2up7WHvV/mGD3BJ2shX/6BLCRmTRtkj9dI5Xfelch1R6QaJBp2ROde2orcJaLm/GvHfrbEQ8XMWr611KrkfwRrhEfIsDDy62AAMmkAZZ23Ffy1596ZQbiUgVnUvXfr7759bR/JYHPiNu4snFO9sV6CdJjApUvlDR4fPerBcHBwkY10jbYXDi7CxP2PzZwpgMn7JK/Wh0DdM7a2qascS8BafJnIRwPg6bUF8V6KymJq2lpwMGKIPgscuM/TqMVMHSxmqxSN3OwnLTQJSv+EVLI2rRlPyzZB/OYB64qCyz4CU2q5ZM7lyx7WPv04oFrLqxoLWLPma0NwMzUAA7ZIa5KR6QFxWj04yEdC1cF5I75KGW5vJRXf9Ls6TnE9zw5ZCvucsTP/gS+zdwIdFQ6+tEbvRuu2QZq6MEDjJsgQ7jvjgSCVKsEzFJU3m3OgvfhLzRFkItFstj5vfH+BxaMsLCGHuMeT6tWjvnMDs22xTO8OtKUC7tRAqoTE8qZc9TJFl4gUgnCABgJbdMG7RxVf4
 /0jwyUL7
 PI22U3OcUEl7+MNii1RJClJ4aIOKW+yeLm+tm4tJdSb5HJSsmXE8RYEXBsMIXWvi5HT1fdsdfSzia3uoPD695pvjGHadRHBZx7xBEb18YCKJYRPJp3t8A5Yifw8EAIf5KGpVlIWojJ7Cs7GaWqsfZ3zTo38gRDuWai+ziq/g/VsK4Be98KUIkMusXxO/C3Tmlopl8FRwgvI9LoFE1P8R2irokfjuea9Z2UsjYR4gRF7GpDw9kZKFLODm9u6KtsTMzVIkepU5DhqqEmmDz2l/c4CvOziXlCzK3C92yEJxzC1Z52VxrYNOv7mkOOaud1xEY8A7acyn9bTgI8nnp58wzI2hcT1tCHdgAxf0urY3fi3eLojgj2ztHlGYJr1A05CqQZLtB7jLqEblePjlbEfGRY7WnUrjTWaau5aZegvNTzQJ9Q0vzh7IYB99ZbX6CKe6UWeG64nT8NbEoEJaNTZV77b2pUGGrU2HoA5mvMIJUCk7TZIVNPSWV44/sDCqs0vnD3I/qLORNYX8xYjK0ovu7i4QOAuRlxV9saR237/7os8kHm0WXSuQ6PSI/BHbAOiXIuKRpnluuZboUpGQ/WP9qo5Yb+t14hxa8BjieD4boc5KgfRBieFnNOz/cGsB7FDsArI15Ptf0KO39DMhHUD8GTkD8+fVdDxkwHqO1kT1ifrjS+RSxd3e74NU6LwyvmhDMU4Y7+Vo7hfvINkLPCmG5vhgpqIT9bJdSQh/p/eLGT+M4tZ9SoP1W6zJeBGSJl04M0k9Q5yqKxKvNHskNyGN8hKPLSb5sxJfmDKfWgRyYkCn74amdME0SK3zuzS5OiguHPoOBFw9wqkoewl7hFvi7vSHiBcCo7WSbgfw4+w7HFMQAof6xgugP3E/WgtckSQKxSoee7c8THBc47w0fKSvFBVWMdsj6TBhGw7KWkxz3gfezAb2WGVvSvxhkGnk2qdk6RMyI6kW+2F424u6BOrzUXWfNYG8k
 BHXVarbM
 w8Y3Srx2dbYBnZltZ3Nicy19GnZIPcwUFeLxtDY+aMiMRt3AHFNV/569v51bm+OAq8mHNAG8FXfOWrY6CGTk4+NOZW2FSzlBLxpLUq3SEetnWuTgZeeA2bEgPEXlX7tgSG3JIvMbCBObtcN2mndG8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/26 17:31, Zi Yan wrote:
> On 21 Aug 2026, at 11:13, David Laight wrote:
> 
>> On Fri, 21 Aug 2026 10:24:36 -0400
>> "Zi Yan" <ziy@nvidia.com> wrote:
>>
>>> On Fri Aug 21, 2026 at 4:30 AM EDT, David Laight wrote:
>>>> On Sun, 16 Aug 2026 13:52:01 -0700
>>>> Andrew Morton <akpm@linux-foundation.org> wrote:
>>>>
>>>>> On Sun, 16 Aug 2026 12:25:48 -0700 syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com> wrote:
>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> syzbot found the following issue on:
>>>>>>
>>>>>> HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.kernel.or..
>>>>>> git tree:       upstream
>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=15927479580000
>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=a59830cba91a1981
>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=805630f1453e490427fa
>>>>>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>>>>>>
>>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>>>
>>>>>> Downloadable assets:
>>>>>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-3d6d8176.raw.xz
>>>>>> vmlinux: https://storage.googleapis.com/syzbot-assets/d19e0514c02a/vmlinux-3d6d8176.xz
>>>>>> kernel image: https://storage.googleapis.com/syzbot-assets/f6da706811f4/bzImage-3d6d8176.xz
>>>>>>
>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>>> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
>>>>>>
>>>>>> gadgetfs: bound to dummy_udc driver
>>>>>> ------------[ cut here ]------------
>>>>>> 1
>>>>>> WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280, CPU#0: syz.0.0/5319
>>>>>
>>>>> Thanks.  drivers/usb/gadget is the offender.
>>>>>
>>>>> Gemini sums it up well.  "ep_write_iter() needs a bounds check prior to
>>>>> memory allocation".  https://share.gemini.google/5NzjyttO0ULc
>>>>>
>>>>> I expect an easy fix would be
>>>>>
>>>>> --- a/drivers/usb/gadget/legacy/inode.c~a
>>>>> +++ a/drivers/usb/gadget/legacy/inode.c
>>>>> @@ -666,7 +666,7 @@ ep_write_iter(struct kiocb *iocb, struct
>>>>>  		return -EBADMSG;
>>>>>  	}
>>>>>
>>>>> -	buf = kmalloc(len, GFP_KERNEL);
>>>>> +	buf = kmalloc(len, GFP_KERNEL|__GFP_NOWARN);
>>>>>  	if (unlikely(!buf)) {
>>>>>  		mutex_unlock(&epdata->lock);
>>>>>  		return -ENOMEM;
>>>>>
>>>>> or do what Gemini said.  Me, I'll add some cc's and run away.
>>>>
>>>> Should there be a separate flags for 'request too large' and
>>>> 'no memory available' ?
>>>
>>> What flags? Are you suggesting kmalloc should return an ERR_PTR to
>>> distinguish different error types?
>>
>> That would break to much...
> 
> +Vlastimil and Harry on this. Maybe worth giving it a try.

We would have to change every existing caller to check for ERR_PTR instead
of just NULL check? Not worth it IMHO.

>> I was thinking of a GFP_NOWARN_TOOBIG.
>>
>> That isn't enough to change the errno though.
>> But a smaller sanity limit may make sense anyway.
> 
> Maybe. I am not sure if we want to spend a GFP flag for that.

Agreed, those are scarce and this is not worth it either.

Maybe a wrapper for kmalloc() for "allocations with potentially untrusted
unsanitized size" could be made (we can always increase the existing wrapper
hell...).

> Best Regards,
> Yan, Zi


