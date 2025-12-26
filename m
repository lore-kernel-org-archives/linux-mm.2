Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65FBEE8FDA5
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 08:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5F906B0088; Fri, 26 Dec 2025 03:40:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36746B0089; Fri, 26 Dec 2025 03:40:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6EDB6B008A; Fri, 26 Dec 2025 03:40:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 970446B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 03:40:38 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29F8BC2654
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 08:40:38 +0000 (UTC)
X-FDA: 84260976156.13.0121B95
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf24.hostedemail.com (Postfix) with ESMTP id B070C180003
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 08:40:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Df5ZsSSQ;
	spf=pass (imf24.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766738436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfHDUPHLpb//CYvTTsSDlTKvWibGdWvqGHEMZe8sFu8=;
	b=C/GXCRL2v4tV0NiJrdSP/zLN5xqpoV6/dTW0+v8MsnQ4J6t9oXiDGkhQ14bYdgiuA2WwS4
	3vj30Lar0LL8b45QWRIPtAMQh3O7d0/QfeuQDAMEge8ZIyWhxuuyAU8eGhnZZSrDGDanLM
	xhoyiR0r/YODVIhZHZgWeP8QuJAzmqQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Df5ZsSSQ;
	spf=pass (imf24.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766738436; a=rsa-sha256;
	cv=none;
	b=7bVSFK3bGbG3z0Bk3O1xlkOXL6/2/fZ0wwBWbP1GV3zkoVgS4Mfu4umSwnJ2ZDzzSiITm0
	uWrp4ldnPEXCrXkobXACG4JJND7QH0oxttgQIesuarj+01bZ72LBClcNfa3aBw5fzJjFKA
	cvLhI7xSBmO/yxD0UPV/GzUFJKJxH1A=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766738432; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yfHDUPHLpb//CYvTTsSDlTKvWibGdWvqGHEMZe8sFu8=;
	b=Df5ZsSSQoMI56ae9lFt4TnQ1Kv7bzapIu1MCqaMtuM0GPKJ3HeT8lAWsO3vFcmmO+w7KVvteOkF5KUxyD1ajc5egA78ywCEPq58wpsiaita0fzPbXAfe9QBtHaiGKaz8x2rj4erypaTj6mKNpshi07/sNQg7urzAECYUVd/svtw=
Received: from 30.74.129.66(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0Wvh15pX_1766738431 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Dec 2025 16:40:32 +0800
Message-ID: <a91e09e5-9735-4539-ba83-661674e7f728@linux.alibaba.com>
Date: Fri, 26 Dec 2025 16:40:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] arm64: Kconfig: enable ARCH_WANTS_THP_SWAP for all
 pagesizes
To: Barry Song <21cnbao@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com
References: <20251226063759.4020782-2-tongweilin@linux.alibaba.com>
 <CAGsJ_4zd+SMa4Mj23tjF5OwsP3LQyvYTrwN4y81=k8FSFgbH3Q@mail.gmail.com>
 <915dc88b-9131-4520-a2f2-facadc887bbd@linux.alibaba.com>
 <CAGsJ_4yQtFK8wtMuJ72ce8KFRT7mB4SZxqS1MKi6RA1WDNkm1Q@mail.gmail.com>
Content-Language: en-US
From: Weilin Tong <tongweilin@linux.alibaba.com>
In-Reply-To: <CAGsJ_4yQtFK8wtMuJ72ce8KFRT7mB4SZxqS1MKi6RA1WDNkm1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 73mp49sh9g74oun3jc6ao88xbnr7xpsh
X-Rspam-User: 
X-Rspamd-Queue-Id: B070C180003
X-HE-Tag: 1766738435-345966
X-HE-Meta: U2FsdGVkX19sb5OUbeJgdYRGYctnK/b5hAOBR1kAyL6IoSSmG1eh7TQNYF2LU/EWiHSkFBgHYk3kXsrWYsuttcmZbGlznVHwCbFrJQ3EGNQf6Y18bIR8923n5YeJkrq/lYT8DtyQJP8eSwt82h9WInR7AFRYU2XUxhoeVx5M91VPVL/Vs7/Bxwpq0wirda3Hmp+AHo5RQxbHVIcssWJ6DbDZffQ9bG7xPSvTmI0oq+oE7uow4+TlT2Eh3rP4epKiZhc9QgESM01RHWWIPFv/dRXeo1JGrsOw6Zqu9x9wtAd+Ne5exSJVhYb9cuxjJbgnX/lW3uyyTPRi41oAWtunRFp5cnaFH9qsGa5iA9wmlkYLa7RoyM+0e+2WUCjxBnycyYIreOnzkIQKSe5ydq3oJZxUu21U9g1J62cxzUAR5cjErmIdseBvTariayh66uljSKOHDnoWmrGDY5NDPc9JWv2Z0pca16GYNbcbCl4Vi+zVtumQPpTjLgyeyFVH+0TCTQs6REbqZlLhDIhUzsGWbpPcmY0cUsc25iUVVZVe6N2VI+Vfu6iIAZjZnQmYm2xbaXM7QixT4vT/MxnRY3jSJmIHWzLz0oMd1xzWEo1aghNuGwWlOCESJHPs6xn7qRXav+RXC2B9txWRqJU7xhSi0ESoWLM0KoDbl0EPk1NwJBYZNueSIMG8dnGE6ae8FwR5yxmZc0MR0A3jw2V1q3LZqTEuLKmwyiIX5NsNbQ4AMZUOFDYcY7aXK4dPxZpXXz3VdrPj70K3f3mYEovcHDM+2Yy9YKL8dbdNkArTQ4vMwp/yudMhx81Mo8XFEKc2Q/5guc/NsgJJrf+SYgKDAmBPzxCmE9niRhWL0OIA9haZ7sPz/Y+nr3i4AqErLGixfa2m4F298s7lpuRDXvXse8lvxphDA7SEA1Ezj6lsUmY0DCFHh7b8jqoS/Rw0V+LWiYkZ62ZeXvzV9ZniEpzDU8v
 f9RPgCW6
 a4gbYa2v85Yx9ep/Uyv2yPCBVvgFZsJK5DVc1i3gjpbOQP8ouqIOC8re8lwzlgnff1IeCm81lvwfP7wWlnT7wQCsk4p6Aez/nSH5C6W2nZWWlUUC4fNIbIFqYK0iKfFm0gJuojUEIWiZnIp//KA6grkZlHxN5er+/14VPwta2161w29RlKZc7WfN7HraxVygBN2TbnYSnIOenzL3eZEaKMNX8P2tZbArmNwHLzDS3LAZ5YLCSj25aZa+inCHuot/JpE43EYWmIU7m5+rf7p9aanFSU+b1mHAk3xJNl7gxTwkwBv3za4PJam1yswMimsExSOm3T2elu97eMFhLuhA6J3tnTPCmuEBzkPxJkU4g9OqSgfO2lEC4yG8buQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/12/26 16:31, Barry Song 写道:
> On Fri, Dec 26, 2025 at 9:18 PM Weilin Tong
> <tongweilin@linux.alibaba.com> wrote:
>>
>> 在 2025/12/26 14:52, Barry Song 写道:
>>
>> On Fri, Dec 26, 2025 at 7:39 PM Weilin Tong
>> <tongweilin@linux.alibaba.com> wrote:
>>
>> Currently, ARCH_WANTS_THP_SWAP was limited to 4K page size ARM64 kernels, but
>> large folios requiring swapping also exist in other page size configurations
>> (e.g. 64K). Without this config, large folios in these kernels cannot be swapped
>> out.
>>
>> Here we enable ARCH_WANTS_THP_SWAP for all ARM64 page sizes.
>>
>> I no longer recall why this was not enabled for sizes other than
>> 4 KB in commit d0637c505f8a ("arm64: enable THP_SWAP for arm64"), but
>> it appears to be fine, and the swap cluster size should also be
>> more friendly to PMD alignment.
>>
>>
>> #ifdef CONFIG_THP_SWAP
>> #define SWAPFILE_CLUSTER        HPAGE_PMD_NR
>> #define swap_entry_order(order) (order)
>> #else
>> #define SWAPFILE_CLUSTER        256
>> #define swap_entry_order(order) 0
>> #endif
>>
>>
>> Thank you very much for taking the time to review this patch during the holiday. Wishing you a happy holiday as well!
>>
>> I appreciate you pointing out this optimization. We initially noticed the issue because, on ARM64 kernels with 64K page size, if large folios are used in shmem, they cannot be swapped out as a whole during shmem_writeout() due to the config limitation,
>> and are forced to split instead—which is something we wanted to avoid.
>>
>> It seems that this change will help enable better swap operations for large folios. Thank you again for your feedback!
> Right, I believe this is the correct direction. Just double-check that
> the MTE-related functionality works. Take a look at commit
> f238b8c33c6738 ("arm64: mm: swap: support THP_SWAP on hardware with MTE").
Thanks, I will take a look.

