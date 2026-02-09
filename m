Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ACA4E7E0C3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 10:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5953B6B0005; Mon,  9 Feb 2026 05:42:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576396B0088; Mon,  9 Feb 2026 05:42:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 461EB6B0089; Mon,  9 Feb 2026 05:42:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35F076B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 05:42:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF30FBAEDF
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:42:03 +0000 (UTC)
X-FDA: 84424578126.05.F010E41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 36DE68000D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:42:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S5DYD3/r";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770633722; a=rsa-sha256;
	cv=none;
	b=5+TxMOKQifrV1+6gmA/JS/+A8yILnz44TacjQPRrgr+v46yW9yexOuq9yTSTj86dz6WXRH
	A9CwsBYVc0XYbAJ5WCohfbkJs5nWJwhUPnzyXU1ekNx4hahjWePzXPRhPA4Ysn5jfZLnV3
	J+OSUrI3mmpPRyOcmCr308wDXJO5oMA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S5DYD3/r";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770633722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTdpMTI9/k0JFaYn8COZsXJ8AkDzsZ0je9g4NxTUGLE=;
	b=5GoRWKTTE11VSuu4uU4uPE0kVcC2sucqMB+EU18R8uODwpyKyho1ShPJmYAfoFcW0KpDHy
	qVPRYrq2ssQz9WnO9qgEW3+FBDkCpSyw2E5+c6mD1sMWui+NLupjcrfp0ZzaHHDi8W2LdB
	iU9CdP12OTN8H2N22vFl7832zzL8Cno=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB0E2440D2;
	Mon,  9 Feb 2026 10:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDA5C116C6;
	Mon,  9 Feb 2026 10:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770633720;
	bh=ywJCRbCgffCqqfChHalI2gIpjQYUmGoILfzVpNH7JE0=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=S5DYD3/rPRNhXUdylNPOOMeREFxP8EedkjL2Dg/gOs00I8eQtLP0qPh/M4UxzV9ab
	 CArMqgdfjrcXuo+UI5gA7uiE0brOcn+HSbyjc84vW7Pnq7LaHpPgpBqOutHaa3XWZr
	 W/5JXn4Ts0RRjiQbnl6rFqMct6lrc/w2ezbWVbpYS5hVs62XsnNR9ap62QdkBH5bHz
	 qVezcj4G9FLHPoFT9vdzw+d2AvbYpafurb4QCZfGIss493gctvno/ipg9yDTMlHiZ5
	 BTkbVXw5ZRnC8d8AC7YacM5Vsk4Dj6py8U942CFVad9c+3bQjFFA91UyKbUcxGm1lJ
	 X0MSJ5w3+cOSA==
Message-ID: <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org>
Date: Mon, 9 Feb 2026 11:41:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ackerleytng@google.com,
 seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 vannapurve@google.com
Cc: ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
References: <20260209033558.22943-1-kartikey406@gmail.com>
 <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 36DE68000D
X-Stat-Signature: 7b3u1waj4yn4hk14fmbf9y3ti5n8kuxr
X-HE-Tag: 1770633721-148127
X-HE-Meta: U2FsdGVkX18jE+PlfaIwdMXdiimkQEpwpmv8pcVRTY0Y93v8iW2QpEwY3l2nLgYJMBMe5jTyjkXf6GOu2eOsW0AvGtqB6H0kaxxvTrQ+AZ+iGO+FU0YRy/X/uTt0MraqRTOX2uxA4Al6uRkEK/EWxHGG2zk5VEmNea9giS1SYpOgvnBYaZhFi88vmvHMQTj+ebgK7qahLb/Yan3YMk5hBrn8XjOPd27RLVOokS9KlXesXTjrpfDi/0v55L8oRsDNnnW6nRhNeQ755qp4Lk8yN/7kAUwDaXEuPfNquo38AYJOTPtUPqtviIbypPDoQJOBJkYZRKZbwGZbIstx5ygZ826SdOQUz4TnGhGUhz6u8dZ4/fSNksxtreDX3biCdgQDnhf8RZks5aWqK/jYHyefU+ZIpmGLSzuCIEV7wTN/jUcMcAlkfAy6S4RNi6zecx8K6Fpn9PLJB+baVTUb/+35ydvUZFVMIuV9To625+XMP2zQ9TZnhclUKIG927J6P/TH1sDxI1dVxBG25q7d+SAdPH/L58BsNVw4Ut/NHHl5pwbVwGdumSE2NLALMy3MwVG8TshJu4Fs64Ev8rfEV2FQ4oM1VXUqW0h06qF5YF64VMUgXmmowPLuo7nWTHiRjuu97zPlaqFKE3ERZDGPp7UnHH4xs2DvEDrmdZKCpfINATa4y8CI6vFUuwqPsMvsD6Zg96opCIUc69qrcGGpNQeNWqftieNSQK2roAYXBnmytcTuFg9TOJcTqrZko0sQI/pvhesqfJvcIRdStZKWAr2Qib5rhNBGcxOhTJ6RgCdEr+U9VTzqdLX3IV+nH9aEEMFFrqEKTMf03sS1wgVQwY3lIJ5jOui05c7SAWljD2F27hJkLdPSFP46BCTOCgIDhqmt9PaIm/6hZSenddB9oeQ1auaKErKpMceokhEXV3jnEPlol4z0xJ93B3YwRUDVNqMVUgwvHhxNwnsAgnvWV6D
 DtXx311A
 nISCaQYcTMcrN2ZGUJvORwlFrI836hoL/BCgawTYQc0zj/2MrRwf1ffWCw9lUfQO10zTfmyfEjeUlzyw3HdH0rR+5M6p+5KPLlQ1OGdRtC5VW9Vs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 11:24, David Hildenbrand (Arm) wrote:
> On 2/9/26 04:35, Deepanshu Kartikey wrote:
>> file_thp_enabled() incorrectly returns true for guest_memfd and secretmem
>> inodes because they appear as regular read-only files when
>> CONFIG_READ_ONLY_THP_FOR_FS is enabled. This allows khugepaged and
>> MADV_COLLAPSE to create large folios in the page cache, but their fault
>> handlers do not support large folios.
>>
>> Add explicit checks for GUEST_MEMFD_MAGIC and SECRETMEM_MAGIC to reject
>> these filesystems early in file_thp_enabled().
>>
>> Reported-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
>> Tested-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
>> Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
> 
> So we were able to reproduce this with secretmem, right?
> 
> We want to add "Fixes:" for the introducing commits, which would be he 
> commits that enable secretmem and mapping of guest_memfd pages to user 
> space. Can you identify them?
> 
> And also
> 
>      Cc: stable@vger.kernel.org
> 
>> ---
>>   mm/huge_memory.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 40cf59301c21..4f57c78b57dd 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -93,6 +93,9 @@ static inline bool file_thp_enabled(struct 
>> vm_area_struct *vma)
>>           return false;
>>       inode = file_inode(vma->vm_file);
>> +    if (inode->i_sb->s_magic == GUEST_MEMFD_MAGIC ||
>> +        inode->i_sb->s_magic == SECRETMEM_MAGIC)
>> +        return false;
> 
> That's nasty. We want some way to identify that through the mapping.
> 
> Unfortunately CONFIG_READ_ONLY_THP_FOR_FS ignores any 
> mapping_set_large_folios() configs by design.
> 
> And CONFIG_READ_ONLY_THP_FOR_FS might go away soon, but we need a fix 
> until then.
> 
> While we can identify secretmem through vma_is_secretmem(), we can't do 
> the same for guest_memfd as it's built as a module.
> 
> Unfortunately AS_NO_DIRECT_MAP[1] won't work.
> 
> Maybe introduce a AS_NO_READ_ONLY_THP_FOR_FS, which we can just easily 
> rip out along with CONFIG_READ_ONLY_THP_FOR_FS later?

On second thought, why do we pass the

	!inode_is_open_for_write(inode)

in file_thp_enabled()?

Isn't that the main problem for these memfd things?

Maybe a get_write_access() is missing somewhere?

-- 
Cheers,

David

