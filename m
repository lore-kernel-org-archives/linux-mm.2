Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76A81F327AB
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 06:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A0E66B00A3; Tue, 21 Apr 2026 02:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978A56B00A4; Tue, 21 Apr 2026 02:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4846B00A5; Tue, 21 Apr 2026 02:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6FB6B00A3
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:27:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EC42C3A4A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:27:29 +0000 (UTC)
X-FDA: 84681581418.15.327C70C
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2131D40007
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:27:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mEokBGrd;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776752847; a=rsa-sha256;
	cv=none;
	b=dIFxldoegT3nxW4azr51B1Fpq0URJvuUWFlE6UQHLi7a70zzWwHP4KWKaznLS4rx6UT2El
	ClH6rjr7w3IuIbou1wWuGjHj17tWi2tIMb4CoSx8Zw77G0zTdhcN7jBn15uMGXzgXjUNzF
	PWRiYk9cQHhpwGg6Z10FuoaRrXNQZj4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mEokBGrd;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776752847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+aWGRtKLkfO/yrjpaFf4WBItCdnCDojE39GH29+8S4=;
	b=Aq7CveU7fGK4PaZ/Odz9Thh3Yv5xe6l+Iv0qopXXvOSnMdKkXSv5EXvgrvKngkiN7m6oqa
	3irXJOBIY/FP2kpROzVJ+DdmhxlBoHADjGeYKeGB5pPb31DTYt2HJr4xUUBglwkWCo7JCW
	bFUetoJ6u2MjIgaiErNziFad+JRT8t4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776752843; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=G+aWGRtKLkfO/yrjpaFf4WBItCdnCDojE39GH29+8S4=;
	b=mEokBGrdsUau43hRvckSReYHfX1cJdufgMwPkm6cupbR1I4hSxxS3G8HZrAlUqPtMaDz6+fv0/WLx6k6twcsmZJsyPd2R17i+Lu9XeX/sTI7lWRJIgz0962dxEBZgfrUDWzpgSHEwdXtCIdBzgJ7gkbXS+K6xeiCkfJOiIVT474=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X1Ryo0o_1776752841;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1Ryo0o_1776752841 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Apr 2026 14:27:22 +0800
Message-ID: <f9508e75-789e-4eb8-b09e-b66a8676a6b0@linux.alibaba.com>
Date: Tue, 21 Apr 2026 14:27:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: shmem: always support large folios for internal
 shmem mount
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <26f954be62348591e720c4e8b7a9099b74dc1d6d.1776331555.git.baolin.wang@linux.alibaba.com>
 <1b3c0401-6d10-4a28-97c8-8e3858d8dc3d@kernel.org>
 <015de194-99b9-4f9e-8c89-d35807c6fd08@linux.alibaba.com>
 <ec6aaf0e-90c4-44e6-97db-041bff8644e3@kernel.org>
 <dee02e5b-653e-451b-8f59-7196bdae8f88@linux.alibaba.com>
 <07e26d39-6155-4661-b3df-c2419535ed43@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <07e26d39-6155-4661-b3df-c2419535ed43@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2131D40007
X-Stat-Signature: 1butmmqr8xtuem5zd3amznqed7j6xipe
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776752845-480486
X-HE-Meta: U2FsdGVkX1+EJdEzdDdag2Ec/vk60qLWoIQYO5NcmzYJXAWFIA8hKU5dO9V6sW9yTK9LxUYZcl2xcNHttH2uqg9EimjTSOHyReSflgx2JIK2yoPIZVAgGvifV3NiBOSGl7YAqZLSnOAPQRqG2axKDVYH2Ac5apvPhjwYqgYDOfNBQPfiBWjlAQtTqcLx4I1EDUzEdSFyxfiqxqtdsyup/4GofhH8QYBk+mnAZYLA/XIz/MCG9InychvmZ2BdKQIQElsOIJd0PyB9TwErK+JWVFh6rmNZsLtavINdro2Vh1wlWlSdjAs/S2Ng1LCOPYINg/gLREyB5bKMhz/4Z6/ukIfsqNvV730xBGDqKIfQxHJMn9Su+hI8c4bdYZA9Ez+PkoZ6n4vC7PbtmPzSCee1x9SG28t798UdrTjcQNKLe+1cg4hdCvJmJy1ngGsEX8180YW91bbReoke07PT68ruTboFD9yJV2Gmn/2SJp2891HM3MIq/3QPfWhnu8JHFNUyhRaar2iUg1heJKQqqX/8opdsRfUiq2hITIKFLOYGTkj5pefH4KF8Oa1E7Mm+H80kVX9EwQiaDZ/Zh6PCetjQpCf9yka3IsuhbM7yLfL/s0vdwNAieNTauXuKATV0HhFCSUEJkEWteG1gP7rSbK7DBFwsa2qHGjZEh/NKvLsL5YC/nb275qKdlqyKAZ7mGWHh6JH7pGe7syvmUr2PJVBsY0xrFNUz/xMe2pVUybDZwLdcJ0SNc5gaOTsModO6bphsLDtzTEbVZNF5/fY6dFA/zXDGtAXa1pKu3lGig6L9qk3jgHeYRbFNhgHYONTLL7xZrbcQndaUqUr4pgc9NUzCEiBtYVUEKkA1VTfw20TwecE3bGm4jkOILzmtLijJppMJ97bWHM0uMMAJ/MIdnO3G8wQq0yDLCBxCmDW06fWRMuoHK3+f/rw/u80ViEbUeJL5WnytRRtEsRt8ixL28Ry
 Ozts0Jwp
 rptCSrHvwAep898hou/fSm3lBn8ZWRgSMYnqKNgH013hMwu5YZWXxOoP7iajH9OZPTTL0hobeUlFbffATCButwMsoCQ5yyDteSk2TuAWkKxkOERutMCKXW+gEjsDDAEvVkF34sHKkx5NGVIcD5B3qdJvNM9xygngSYiPzNdf4Z49ROB6vRVbjk36M+/LGb4KUEC4buDPuXYdKBx8WIn5aTxHEe1BaCiEHBZOT2S2wL2jFrNX0n7P8hgS9wJBIJN+5dFZsd6NKe6+kGBwTpCOyazFrqrnMTCA8sAKGfJq1y/VAwJexdpn0Le+4/xT8jbVdamgkOrMtaeNfTv8HlxyqIy2I+9uhyeHGMNAn1appINA1qEhukZFfozUrc7cvF+JPpweP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/21/26 3:00 AM, David Hildenbrand (Arm) wrote:
> On 4/17/26 14:45, Baolin Wang wrote:
>>
>>
>> On 4/17/26 5:52 PM, David Hildenbrand (Arm) wrote:
>>> On 4/17/26 11:27, Baolin Wang wrote:
>>>>
>>>>
>>>>
>>>> For tmpfs, yes.
>>>
>>> So, we could pass this check here, not setting
>>> mapping_set_large_folios(), but later someone toggles it and we missed
>>> to set mapping_set_large_folios()?
>>
>> Indeed. Good point.
>>
>>>
>>> Or would we always go through another __shmem_get_inode() after a
>>> remount?
>>
>> Not really. There could be files created before remount whose mappings
>> don't support large folios (with 'huge=never' option), while files
>> created after remount will have mappings that support large folios (if
>> remounted with 'huge=always' option).
>>
>> It looks like the previous commit 5a90c155defa was also problematic. The
>> huge mount option has introduced a lot of tricky issues:(
>>
>> Now I think Zi's previous suggestion should be able to clean up this
>> mess? That is, calling mapping_set_large_folios() unconditionally for
>> all shmem mounts, and revisiting Kefeng's first version to fix the
>> performance issue.
> 
> Okay, so you'll send a patch to just set mapping_set_large_folios()
> unconditionally?

I'm still hesitating on this. If we set mapping_set_large_folios() 
unconditionally, we need to re-fix the performance regression that was 
addressed by commit 5a90c155defa.

But it's hard for me to convince myself to add a new flag similar to 
IOCB_NO_LARGE_CHUNK for this hack (like the patch in [1] does).

>> [1] https://lore.kernel.org/all/20240914140613.2334139-1-
>> wangkefeng.wang@huawei.com/
> 
> Is that really required? Which call path would be the problematic bit
> with the above?
> 
> I'd say, we'd check in the large folio allocation code whether ->huge is
> set to never instead?

Yes, this is exactly our current logic. When allocating large folios, 
we'll check the ->huge setting in shmem_huge_global_enabled(), which 
means large folio allocations always respect the ->huge setting.

But as I mentioned earlier, the ->huge setting cannot keep the 
mapping_set_large_folios() setting consistent across all mappings in the 
entire tmpfs mount. My concern is that under the same tmpfs mount, after 
remount, we might end up with some mappings supporting large folios 
(calling mapping_set_large_folios()) while others don't.

However, I got some insights from 
Documentation/admin-guide/mm/transhuge.rst. Does this mean that after 
remount, whether the mappings of existing files support large folios 
should remain unchanged?

“
``mount -o remount,huge= /mountpoint`` works fine after mount: 
remounting ``huge=never`` will not attempt to break up huge pages at 
all, just stop more from being allocated.
”

Do you think this makes sense?

