Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B0BBC98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DB166B0088; Thu, 24 Sep 2026 03:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18BFB6B0095; Thu, 24 Sep 2026 03:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07E6E6B0099; Thu, 24 Sep 2026 03:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C73D76B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:50:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F25314025C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:50:15 +0000 (UTC)
X-FDA: 85247882790.11.42FA5B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9393340006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:50:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eRT+7H9A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790236213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XDvywVc6Ep1SuVeW2SGy85kW0rD7YUN5EGSklkhHzQk=;
	b=29CmoVeHhfKe+BnHT6lWkenGNSyvGGC2qiGYzo1um4I8x3HgV7zLfeYQw3tq8HB9wDqwAx
	7Dvp8UEuNXeH43B58x+9elbKFQe+TQOn3G+lQWbLPROnOjAiyug3r4fz2uYqsMOaonFX1O
	EX0Ny9042CtthmiGWimD/g9Gj15cR+I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eRT+7H9A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790236213;
	b=16LHvuqxzWKeC1AMI88slI84MMD5lsvZ6ydpLtmc8SuyRlO4XdKXBi2qIxjNfoAsmdyHna
	e3WM5WO6I2ORCtKf0DsjZe9LlRbH0ymV1au7HU5ZixgvcbQkCNO07YQoKNzZDNRRF7WSy4
	7mvbNQfnU8GsHZBnBkY2/DkWw8OjBDU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 244D9601FF;
	Thu, 24 Sep 2026 07:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D691F000FF;
	Thu, 24 Sep 2026 07:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790236212;
	bh=XDvywVc6Ep1SuVeW2SGy85kW0rD7YUN5EGSklkhHzQk=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=eRT+7H9ABPwFjh7BVERhP8cozvQ4MQhStKNB7IRvgfIVy1HpxDFA1S9CLNaBl5pzI
	 KbWjS+JLXuC1wfFOu3O1kKNSLzYoFlGe7Tv2kGJimLChc4ZoVJCdySlQ6e/Tz0sL1D
	 U0iYGLcnxGjb2dU5iqN0HCoSkRnXP9Xme2baHRJ40E4KIM8t0wkAmMfPUSppRNQrim
	 DTNpz+zdjksrk7NtzRiTQlySjLsTl2p+yx+bYXTEnPJmuk8zk0/jV46rM7nWCxR/1h
	 T2pphZq6jbBIsqIE5qVV+FHA7Q1fgJbsv1XCiH44gQdnf98X4nCMENM2ur68i1YPoB
	 mW+MzuRrfmFrA==
Message-ID: <08bbb615-a054-472c-9873-787cc0f7a4d7@kernel.org>
Date: Thu, 24 Sep 2026 09:50:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] [ext4?] WARNING in __folio_set_anon
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Lance Yang <lance.yang@linux.dev>, ljs@kernel.org,
 akpm@linux-foundation.org
Cc: harry@kernel.org, jannh@google.com, liam@infradead.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, riel@surriel.com, syzkaller-bugs@googlegroups.com,
 vbabka@kernel.org, syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
References: <6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com>
 <20260924065458.49698-1-lance.yang@linux.dev>
 <0a0a07f8-8ac9-4d75-b4c6-c403865f0be9@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0a0a07f8-8ac9-4d75-b4c6-c403865f0be9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9393340006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: uicahkhdqh5e8713tikb4qeppaudkx8k
X-HE-Tag: 1790236213-880269
X-HE-Meta: U2FsdGVkX1+QnjWrNTWA4FSY4hCBlj065ujqIp7xemswTS5wG4yZ7jtnGGVz4j+4xDxZ4oJgRfdpqWn9p+guCUmMdP7uQ7YYizx2tv+xe+guqKrUOA0rFW9KGyiAUzoS113VSMSMn8+aZnc1GW33YYzQSREOks1DnsrWkJ8QcbO9nFuplC4KeZ6TFiYGi701zviMsmdWL5V0TqrrBqKrNce9PbmevaWIfZzd5XgcpG3vqy3RyGW1E1kAC5YS+f8tI//zDsddpLkRIlJRVRpQgBY3QYAzhAsC/8iQ9XieXkUQdiO6anvk9HGEfcAF/X6JXKnbkCYdmS7afBVhBWu3KJ+c9w8q30ooVlBW9QItUJpkjHwI2K89bZ6AreSNGpHqrp8DfzMHc1gl4o0J/g1WyF/4DByEf6QVMcJazpN7o3Qo/po1yLs1PCFy3itYCco6t0kuIc/RoqyWs5n5+buzxq944E16Sags8gx/gwlp0AGqYiKNO5mxlghzVmcCLt/ixxcxNs4yslWMX71p1kTORa5MHyuYHGJUH6jdh/6n6CQ5FiZo44PR4xoGYuHPAfiLkYJ8R/pPMFTVVzssWXcWWy2apGZuK0QZVlfdKjkOKXXs9cLA5Py5Gz70mg0fcxE9zPcE+QMFEJYtLqUE2uRvNgkCihgmfBdgBERmfYjb2si5xgXDop75WE52EAxL0O2PM82A+Lte0EZ8gjKqob/IL9jlymWSW7/9b+iKMPPphArMtuliIgxWwOFUWzrR+fk9jOa036xiqJ3o8DgXoCCd6NuY6EeV685tmiAEvedfuk0SSPgyILIitVzC28tlC3joKbKgSw2eyshX1KcmjkaaLQPpXsqfKG6p/IusYScWbfwPecBpfF+5DcM5WpAO0ISIABoNOFMow5k+13vdjmC46k3w2/5VYsZDC4C3GYeNBX6xUgcls0d/fE7L0vD6VVSB7h1FUhTnmM+SIjG1yJe
 NoTP9ahe
 qq7GzrDTN4+cFlWZETfCL7hf8bj26dykpAu/zomRQ5MCKo7NK9yOp7FGJFM3kUuJf4zSiUSx0E8qNyVz0TOlB0MsI8RfB/whfpg/8rfxZCoFUEapVDvFNq7D0QUbruuy6rtxOf41gsQ9SZzbxA05cwirUZbQ2l5bgtsmZTIsiDloBFesUzE8HeajY+2ptu9xDbZ9gl+VqfPuIkGB+rQitx6eG/OqOxEn8R5fQxVj1RaXSlsAbDjTZBw//WQ5ZYZ9Ak+C4eaWfteeh9ObpD2Z8qEwosLgnq1wVwQVxnOH2hfessjgZ6tOuUi+jUsyv4lWCHqxRYX8Ol4ppEqgjak7aQk9QyxtCYLMNkM7HyMJ+a1/8JZ59sUm6Z9kE4AilomqsL8ZcqQ0u14dKv3GoZGdmtj6Ig8pNI5kXix7exSyA7DW/mnkjT210zYZig4r2U8urB/+Zzc3ETIjPIAvhO69PibHAFz7q0f3y/TncOSPyp3Bo5lKB6CssxIlADB+sIim9D0415hyTrmtqUSmpCNRlO7z3sWcpfNPwtveNLPjlrsTjxz1+UmiKabJY4kEAnNTo2QGo61ypd1s5gDqHR9v3OSpQtwGUZEGeLPhd4HMrzRy1vHdF55QI7jjjckgGzz8Qh+bMI+jY+ja/6vjFuQYIFPDioRarRNk9Y9FOt+9nGtBEbw+Tp2AC8LdcuvoT8BkLznLyDgtJLP5+SHBp3HX9lw++2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 09:43, David Hildenbrand (Arm) wrote:
> On 9/24/26 08:54, Lance Yang wrote:
>>
>> On Wed, Sep 23, 2026 at 10:00:37PM -0700, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    38872197cae2 Merge branch 'for-next/fixes' into for-kernelci
>>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=17a44d25580000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=c181d3198e98f8aef8b9
>>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>>> userspace arch: arm64
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a36515580000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16dcf4c9580000
>>
>> Looking at the repro, emm ... the repro maps an O_RDONLY /dev/zero fd with
> 
> Does this trigger upstream or only after Lorenzo's rework (not upstream yet IIRC)
> 
> 46827ac1ab221 mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
> db7438ea23180 mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
> 54e8e096ea86b mm: implement file_is_dev_zero() to uniquely identify /dev/zero
> fb24843cfd9eb mm: move drivers/char/mem.c to mm/char-mem.c
> 
> I assume it triggers upstream. Does it also trigger with lorenzo's changes?
> 
>> MAP_SHARED | PROT_READ. do_mmap() clears VM_SHARED and VM_MAYWRITE, so
> 
> Clearing VM_MAYWRITE for a private mapping is odd. Can you point me at the code
> that clears both things?
> 
> I assume we still have the file pointer, and as the file is read-only we remove
> VM_MAYWRITE. But why are we removing MAP_SHARED? (where?)

Looking at the code, it's the

	if (!(file->f_mode & FMODE_WRITE))
		vma_flags_clear(&vma_flags, VMA_MAYWRITE_BIT, VMA_SHARED_BIT);

So we end up with VMA_MAYSHARE_BIT but without VMA_MAYWRITE_BIT and without
VMA_SHARED_BIT.

So it's by definition not a COW mapping. But it's marked anonymous and confuses
the system :)

-- 
Cheers,

David

