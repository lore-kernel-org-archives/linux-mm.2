Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62B88EA3F28
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 09:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B4E96B0005; Tue, 10 Feb 2026 04:33:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958A26B0088; Tue, 10 Feb 2026 04:33:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83A646B0089; Tue, 10 Feb 2026 04:33:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2186B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:33:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1766F1C3EF
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:33:17 +0000 (UTC)
X-FDA: 84428033634.22.E5A8949
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4B0B74000C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:33:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lVWeB8fb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770715995; a=rsa-sha256;
	cv=none;
	b=DjIc9QrMg4HwhcOMqfq/QW0zGWBmtowZBkOGYYJQzU2ilcEpTz0kVqf7m2WEDS7LO4GjqR
	y1dXvSFqLlePh5aZAtgXXlqybD7I4iY7Q4Z1YdtrNZ9o39BD+gsTgIyPKlC2SvcVKGv75e
	jZY6yDgEplgK/maNd4TcNrWNpkYNhew=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lVWeB8fb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770715995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/37PSU/A2pbGhjAhe0+TtP7X5niIhYp83UtOsqvKB80=;
	b=3fknspIhaC53gjXlzkDS5ET2k1ZBC3GSvPv0y70oodupdqeVU6+UTHAtUZFfgxS2sRi8kL
	VslopBj2YdI/5ZMNBK1rFSzyWwM9hZNvkGyn0HrZQg32M3+7dhcCJE9CeicaMTcTboJ/KP
	2bQfml8revKYBgjO2yrEkWSZ6NIQgRY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A79BD60136;
	Tue, 10 Feb 2026 09:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF90C116C6;
	Tue, 10 Feb 2026 09:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770715994;
	bh=BgcKV7dHeHVbm20HV3VLA5plyusJ9ZbXOgJvxKDGDeI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lVWeB8fbPSQmk5ZnZjfxYmqJ5aSP0JS3vYx0Vqq74YYPmMlYbtoJrGFZDnc1/x2LW
	 eWPYxgha49wLuGMjUawePYF21z0O7tARazj+R23XvBeiIxqu5/08V8WNHwlXfIBbW4
	 Q/Y5ItJaRyFpZCHp/TgKRLWclZCDLA7jknQSUFb0t1x5Vp1w0zC45URa/kOvi+Gtgl
	 VROBoaqKpS67RBMIRO0QJNxVBZdxYHmGF4SUXfmTOHXEQekBj3WKz2HRZra79+AO+5
	 yIHLpZcxzuFGhCdMLZcj+n3/cUaSRsU/T6I1p5PfHrUeaTAT30hJ246g723Ly2zprh
	 STeJCP5RYZSoQ==
Message-ID: <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org>
Date: Tue, 10 Feb 2026 10:33:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
To: Ackerley Tng <ackerleytng@google.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 vannapurve@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
References: <20260209033558.22943-1-kartikey406@gmail.com>
 <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org>
 <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org>
 <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4B0B74000C
X-Stat-Signature: iiusm45d6gqxkdcr7zx1nmhoyb1imerc
X-HE-Tag: 1770715995-644468
X-HE-Meta: U2FsdGVkX19TfW9BfkEo5lJSZJtS92grNH66I1BhvGGklxSq6IsCbZQhsMBfFiBbcYc4/Vrzw5PZz0b0KRjHVUFeHS17Vs2UEHh/omAEto2hstPCOFVR87K6c+oPKBP4c567tBm9e5txr0gLHR+wewN2Be4NZKyhDd3yn/wLnFBSmT9JRNioMShiQnXRUazXIwMqjA8q9B9l2Te/szVx2Ul8RU3LdqA5rt7K515G7n4GPwiIDaVMSVKSECwT55hxvXJwGvzY2WpDWmSXUvSia28Q+pFLmURWy8b55cP2NVTZVprqrZeiVNGihpr3JwYDbQpaogCpWiaBA94HQXvvpCcW3rPMaVt1oHQwmx9Xqn4G5rrJ5WHH0C/IF8TTT9v/SzEeekk+MEW1McppYrvNJ0Iq3swtBqwV2n4hcpMmJPtGpdq7YDG0A9NmTZGYRD+8v9MgY1YQi5zp1rC7wNMNLZlyAXfJO47vFUskjxQ05DRfS0WPokfdc1EbdplzdPkdpydXmjzIOr7/HdrZ/I7On8un7jTKnZ8tYzkPZ8ciQgsWg8GlvW2c91XCcGD7zkgqA8ij5DIx+vZHReOuq2eKT6UqbJypbmVj53I4HPyPJyFRubyDOlaLuefyH/9JtbWgYK739ALm/XMeJEf8GhNITe0jPyWv7QfV+0gMFxIvFNqhPvvluFPpAIPKlAKZWWTwUvrDc7MuEMZXsQUJ7sXG/yo5b3ecEDQHc3qWPSEW88+m1/cZ4jrh8VOi9+AjAevO1iKCfYL2PD7A0C+LJ6tcYvgI+uuftayBrYkmFY2cIXdXvC+w9LpqTmfFfo4bKJoVXHEO7A+zxvKEsob7ev9lbP7agWPryP+OddVGdEPbBsfZL8ImVi6CVLuNf/GIpHOpOVvdId55ZEulBcaXrFmc8H7Z5zh4u/9pqjvg710MRwc5/pgprgzGRvDhcqUZnHFMmWDE6b3leopDlqLsUov
 HlHg2QPu
 fzdbbubXQXNgupeo31J5+pq2QlvymtdIs4wC9rGnB6814lQgpSYdDXdSd7D5YlKiYV2OEP1hKKe9NZiSNQN6sxLSoAx7PlI5RKXKm+LfYHaULALFEJyituKA0L1Hu9tde3MSteO7MDH3Xy0dHuZKZOLYaccruqUyWmu+CZmdHiFV6uKGI/ufse5xLEEGgFho5Xpz2eqEd+Vl+TzzEYUpXint5M0XULJKtULsqoAOLvUso9Z93h5xx53P4nK82+TokA9msblUhAyi6ZU1+QKkekr1/RpiMcPkqYIVhrLH/V5HgudCfNG+q6fwHLO+TBnSGPHJm2zZvHobJVbx1pVXH6TNpBrZzl2Rw9+KBAhWbRDbGM00yhSJP9/TPp0tIIch7mZXxiGOdYcgwYohFTbnKEWMPqQdKFDwGbaFpMsXaq/NPPilq2ehM3p849Nmoq5NhRZnAMcLc9VXsyl2bOBJcMUfXJ218zeB8QZPDPbA7elSpecKgcHWz2A6UWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> BUT, something just occurred to me.
>>
>> We added the mc-handling in
>>
>> commit 98c76c9f1ef7599b39bfd4bd99b8a760d4a8cd3b
>> Author: Jiaqi Yan <jiaqiyan@google.com>
>> Date:   Wed Mar 29 08:11:19 2023 -0700
>>
>>       mm/khugepaged: recover from poisoned anonymous memory
>>
>> ..
>>
>> So I assume kernels before that would crash when collapsing?
>>
>> Looking at 5.15.199, it does not contain 98c76c9f1e [1].
>>
>> So I suspect we need a fix+stable backport.
>>
>> Who volunteers to try a secretmem reproducer on a stable kernel? :)
>>
> 
> I could give this a shot. 5.15.199 doesn't have AS_INACCESSIBLE. Should
> we backport AS_INACCESSIBLE there or could the fix for 5.15.199 just be
> special-casing secretmem like you suggested below?

Yes. If there is no guest_memfd we wouldn't need it.

> 
>>
>> The following is a bit nasty as well but should do the trick until we rip
>> out the CONFIG_READ_ONLY_THP_FOR_FS stuff.
>>
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 03886d4ccecc..4ac1cb36b861 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -40,6 +40,7 @@
>>    #include <linux/pgalloc.h>
>>    #include <linux/pgalloc_tag.h>
>>    #include <linux/pagewalk.h>
>> +#include <linux/secretmem.h>
>>
>>    #include <asm/tlb.h>
>>    #include "internal.h"
>> @@ -94,6 +95,10 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>
>>           inode = file_inode(vma->vm_file);
>>
>> +       if (mapping_inaccessible(inode->i_mapping) ||
>> +           secretmem_mapping(inode->i_mapping))
>> +               return false;
>> +
> 
> Regarding the degradation of filesystems that don't support large folios
> yet: Do you mean having the collapse function respect AS_FOLIO_ORDER_MAX
> would disable collapsing for filesystems that actually want pages to be
> collapsed, but don't update max folio order and hence appear to not
> support large folios yet?
> 
> What about a check like this instead
> 
> 	if (!mapping_large_folio_support())
>          	return false;

That would essentially disable CONFIG_READ_ONLY_THP_FOR_FS (support for 
THP before filesystems started supporting large folios officially), no?

-- 
Cheers,

David

