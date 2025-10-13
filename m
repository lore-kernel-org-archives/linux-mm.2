Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B384CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 11:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A354B8E0030; Mon, 13 Oct 2025 07:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D1F8E0007; Mon, 13 Oct 2025 07:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922858E0030; Mon, 13 Oct 2025 07:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7EA2F8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:19:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 137661DE851
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:19:06 +0000 (UTC)
X-FDA: 83992844292.03.879960E
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2325840008
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:19:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pj2eDnLP;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760354344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=THxCn//FsVj5ixy/ZrIlSuWPhiYR+PURiUuNomHjfd0=;
	b=I4IsPDxqeaHqA780AcOKWQgrPbI0ZI5rNYFwdcdJsV16irLweHPgger4wa5rH3FSFMAJaf
	wz0JPcBdd2ciByHWazONMgpJTpl/quAPfRMv8GvFBn71gzM4C9GrBkh3lujnpoot5XEmth
	Mi+r+0oVkOjoq13V08b+sPiJgl944/U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pj2eDnLP;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760354344; a=rsa-sha256;
	cv=none;
	b=mkU0w4E3gMpbxN413u+oZT0TNY4R5sojkpQlJUpH5hy+Olnc09j47wQlo191slYR0qvJUX
	ftpKauZ2eh6pf+d0ozRDZUuiLzAHCxIv7Ezc/UbnvklR7FShqSll7+Yje6cVtEcY29oukR
	XcRj7s9VeI6+qYO4rGps66+8Nhz25TY=
Message-ID: <bb92b36f-f1fc-425d-a6ae-f4b4cd6df37c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760354341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=THxCn//FsVj5ixy/ZrIlSuWPhiYR+PURiUuNomHjfd0=;
	b=pj2eDnLPEzrdXUtMyJunN6N9B9iV5uLaBDVLCoI0J9i6lNgHlS3rHAkQ7CwCxNQM+yGCL5
	JRk9ch7wAfzLYBHPK1uhBzX0vGEstQ0aOzYDmNPSMMZdYFyNQRJr9Mzkfg+JLZecThfrYq
	MVAXiDQg+YvY/ulbRyDvErGv7DMjauw=
Date: Mon, 13 Oct 2025 19:18:54 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC 1/1] mm/ksm: Add recovery mechanism for memory
 failures
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: Longlong Xia <xialonglong2025@163.com>, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, wangkefeng.wang@huawei.com, xu.xin16@zte.com.cn,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, Miaohe Lin <linmiaohe@huawei.com>, qiuxu.zhuo@intel.com
References: <20251009070045.2011920-1-xialonglong2025@163.com>
 <20251009070045.2011920-2-xialonglong2025@163.com>
 <CABzRoyYfx0QPgGG4WYEYmT8-J10ToRCUStd3tWC0CtT_D8ctiQ@mail.gmail.com>
 <CABzRoyYK38imLh6zN2DZKPRyQrJkKyvpswqJAsWzEeECtOxaMA@mail.gmail.com>
 <55370eb6-9798-0f46-2301-d5f66528411b@huawei.com>
 <077882e3-f69f-44f3-aa74-b325721beb42@linux.dev>
 <839b72b8-55dc-4f4e-b1da-6f24ecf9446f@huawei.com>
 <f12dfacb-05dd-4b22-90eb-fcc1a8ed552b@linux.dev>
 <bd374ac3-05a2-41ae-8043-cc3575fb13c0@linux.dev>
 <3e6500dc-723f-4682-9e37-b28bc78a2bdb@redhat.com>
 <c129e522-853e-45c7-a064-34c25e63e610@linux.dev>
 <356ec45b-6ec9-4eb4-b5db-ca98964d8f3b@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <356ec45b-6ec9-4eb4-b5db-ca98964d8f3b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2325840008
X-Stat-Signature: 3817cccqggfbpw5yzgbfi4m5ifok4nzk
X-Rspam-User: 
X-HE-Tag: 1760354343-618453
X-HE-Meta: U2FsdGVkX19XtNsm61zJRM6IUHVQeR7SuWFEpivl1U9nCS8OAsFoSXAhhEaboE4Amzuwih32UdjVC7T7EGjFZ5Y1Vb3u+uvSE+RZHNxukvuHWEUy0AqvM3FIPmR1sCMMhDXYWtXRISdEEdC7QCnRZ9rE9ILnjoKqfZf5+sozE/IzY5jDVu9lqDaBvvyiliilDEsNqqtAIZhNPdbAeP2dHcF5WP8RKy3j8vz5vj6r5WO4sPeacgWA5ha+pjb7B6SxHPCKBJTz+OrsXGONJjnwmrfn5eUshiQK8l7kX8Q+YMf5uNaeLsuT4VzeRIFpYl/sHRWKykfNBUcncR9E17x3X6b/ATcwlZXxi3jhuaAXeIr7pIgY22wI2mM8Mz4FdFnOKpObv7BKYmGmdjurhgc38WQuGDXnr3Pjr1Q02VTw42dwaEoOD2EEf5FHjjB7RRIvUzbZ3uRHhtEyjKdM1zaJhGXvDpEQvZarlU7PNUNqnlSiLxFuVJAk4utreDO0aYu9fMXcgyWxP2jVKbwmnS3hjr+293gdjPESEgsbEUd5WUfzAsxk9FfXNAl7CGQd+3gZkPNjJIrjyCEuBcKKKcBA125A2UPkoOmFVM66XH1H1Kj3UPOEzEDpbRAtOEpPlitzVi5c6nS3IH+iILNvor0jAVtYJnTfOkVzeSAptwND+YyamHqOBGtqpo7uwvhXPW4W1UXYtEN5cBYowCwgg3NUXNJ1X6VNUidfIDiGgp3JFePA76kVzkH4PXDRX4tqk9eM/6zKJt2m0NVoP3I3oLQM9BSj5vIULE964IDj6HJrdhNQ/nhaeWFw78ffOhGQuL//WVnHMItdlLGNYWbzV1N7kG4Y9CL24oSMCjp4barTLzHp2HISeWRmf/AY+3GN9P0V9aMfCMW0B4GZUmDdTmB4qiw4nIXpMLzEJcc5vmAX1g2uSCf9aWDIDA5VK0YlOdoJ4LXe6bAMDlx/BdFRDAL
 Mc5r4Hfr
 Ke65zxDhD8ETk+l7o/o2zDXM0/HI4WbmSCv9oD+m7CIiCd2nygkYSXqkMzm3shaklNjfiwfDjEEHvcJ2cGNncOEZNwcmCSxwLlNX/9lLXaRgXPKC9Gx7Cy+ibJVu/kL2sxUKC3nSqRRa5fKEjK1Fv/X3J2/Jhjb/5b104oHpwy+OkNZ1aTl9rg5WM1k7FDt4JTHBOKOkE6b33hr+a2rNlnvofHurvw1mdnmlJtfDwaJQ9ye/KvtbLIYBHArNKAoZqJyLHwnyq/fN2LoBKQznmgDsw2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/13 19:13, David Hildenbrand wrote:
> On 13.10.25 13:00, Lance Yang wrote:
>>
>>
>> On 2025/10/13 17:25, David Hildenbrand wrote:
>>> On 13.10.25 11:15, Lance Yang wrote:
>>>> @David
>>>>
>>>> Cc: MM CORE folks
>>>>
>>>> On 2025/10/13 12:42, Lance Yang wrote:
>>>> [...]
>>>>
>>>> Cool. Hardware error injection with EINJ was the way to go!
>>>>
>>>> I just ran some tests on the shared zero page (both regular and huge),
>>>> and
>>>> found a tricky behavior:
>>>>
>>>> 1) When a hardware error is injected into the zeropage, the process 
>>>> that
>>>> attempts to read from a mapping backed by it is correctly killed with a
>>>> SIGBUS.
>>>>
>>>> 2) However, even after the error is detected, the kernel continues to
>>>> install
>>>> the known-poisoned zeropage for new anonymous mappings ...
>>>>
>>>>
>>>> For the shared zeropage:
>>>> ```
>>>> [Mon Oct 13 16:29:02 2025] mce: Uncorrected hardware memory error in
>>>> user-access at 29b8cf5000
>>>> [Mon Oct 13 16:29:02 2025] Memory failure: 0x29b8cf5: Sending SIGBUS to
>>>> read_zeropage:13767 due to hardware memory corruption
>>>> [Mon Oct 13 16:29:02 2025] Memory failure: 0x29b8cf5: recovery action
>>>> for already poisoned page: Failed
>>>> ```
>>>> And for the shared huge zeropage:
>>>> ```
>>>> [Mon Oct 13 16:35:34 2025] mce: Uncorrected hardware memory error in
>>>> user-access at 1e1e00000
>>>> [Mon Oct 13 16:35:34 2025] Memory failure: 0x1e1e00: Sending SIGBUS to
>>>> read_huge_zerop:13891 due to hardware memory corruption
>>>> [Mon Oct 13 16:35:34 2025] Memory failure: 0x1e1e00: recovery action 
>>>> for
>>>> already poisoned page: Failed
>>>> ```
>>>>
>>>> Since we've identified an uncorrectable hardware error on such a
>>>> critical,
>>>> singleton page, should we be doing something more?
>>>
>>> I mean, regarding the shared zeropage, we could try walking all page
>>> tables of all processes and replace it be a fresh shared zeropage.
>>>
>>> But then, the page might also be used for other things (I/O etc), the
>>> shared zeropage is allocated by the architecture, we'd have to make
>>> is_zero_pfn() succeed on the old+new page etc ...
>>>
>>> So a lot of work for little benefit I guess? The question is how often
>>> we would see that in practice. I'd assume we'd see it happen on random
>>> kernel memory more frequently where we can really just bring down the
>>> whole machine.
>>
>> Thanks for your thoughts!
>>
>> I agree, fixing the regular zeropage is a really mess ...
>>
>> But for the huge zeropage, what if we just stop installing it once it's
>> poisoned? We could just disable it globally. Something like this:
> 
> We now have the static huge zero folio that could silently be used for 
> I/O without a reference etc.
> 
> So I'm afraid this is all just making corner cases slightly better.

Ah, I see. Appreciate you taking the time to explain that!

