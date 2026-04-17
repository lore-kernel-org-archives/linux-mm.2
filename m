Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E75BDF43689
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 09:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10A9E6B00C0; Fri, 17 Apr 2026 05:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBAB6B00C1; Fri, 17 Apr 2026 05:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13296B00C2; Fri, 17 Apr 2026 05:27:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3D916B00C0
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:27:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BB148CCC2
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:27:52 +0000 (UTC)
X-FDA: 84667520784.24.95CCD15
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf28.hostedemail.com (Postfix) with ESMTP id 13568C000F
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:27:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="nIuCsFM/";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776418070; a=rsa-sha256;
	cv=none;
	b=sNVrtbnNPZZrNUfIcaUjV4IgcmOKbQdJjs84eMdPiM6ngkZatCoRMp7hg+lgkFRLMbnYlH
	GSlzJ/80e9Z99tnZqRLc73f2r39AGDl6dHqXFca46afLZDAiEnZM8OjL8Z8AAoI/0/8axJ
	q7pX9wElu/8ih1bh/anvo00iFq31OsA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="nIuCsFM/";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776418070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ban2GK06J3qXdLSyjEj2d7nc7DweKDpF3MVxWR6RWc=;
	b=6khJUrTADvi/Hjtz+W02+1GJs3NIqf9IOf1pTCmsjYLmZU0AjwTETAaiMpp/SlBdZjR7UA
	kzt3m2sPkX3CWa+rTZyDE3EuCWzD5nW0ywYQR/zz6tIQ7QxMeBYqLif45lXNvLv/8Bbbhl
	fXA3aXq9T0J4BccfuIxWFBMjIHe/AhA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776418066; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9ban2GK06J3qXdLSyjEj2d7nc7DweKDpF3MVxWR6RWc=;
	b=nIuCsFM/m0E0iUKUw+m2SPc2HYc9Xy/3LMLj5AdgRUWm/vWQ0wfOQbZdPFGiNm5w8ESHLUIeNK20KjxpWT0MVR/2v8mYn4+3sojbRCy6hvXtcJFS+lr9kWSvE8h9+XMuSK4Ygoy9ByJCnoI3BSEqXG4nJzimceyY7dn6Jk3w5hk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X1AxuDU_1776418064;
Received: from 30.74.144.138(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1AxuDU_1776418064 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Apr 2026 17:27:45 +0800
Message-ID: <015de194-99b9-4f9e-8c89-d35807c6fd08@linux.alibaba.com>
Date: Fri, 17 Apr 2026 17:27:44 +0800
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <1b3c0401-6d10-4a28-97c8-8e3858d8dc3d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 13568C000F
X-Rspamd-Server: rspam12
X-Stat-Signature: tmub5gibxudicau8rc3amx8pqpuj9rz5
X-Rspam-User: 
X-HE-Tag: 1776418068-291195
X-HE-Meta: U2FsdGVkX195CMphrMwhOn0nHKcTANc109IDSc8V02sVm6GF2jnbvLgo6b0+XVkXtcY9MCNuYABVxW4vsPuKmeSmtRoV6ZKelHIdfxiEvlZw5QB8gpVFcLoX3WNjqgzYD/VtjC/XKtd39+0RAcvp4+CBu8bj+v/+i8lxbSyo0WE2sNcb9rGN2YMEUQ4guM2yBJ2wVT4mBe/KoWezs+erW38bfZm1XhHC2ykdg4LCFGa1z8iSTfaL7zXfj1mE80CcbA5jfuBzYLrfLIR4H1JWwAfs9P6FRb/iXlSzfsizBDXnSTzMeiHqA39Z045AxwOHkDm7BRhOajBSePflNg9NKNr6P13LooQofO32L6E6NK3xvWjVqqeoOh5VfcLY+woBKPx+RZxLwKLqZHrC8MgeUXueGXLRLMjCHyL0A/qL8RkbPj9X8/PCqbZmQfoO02X8ygmLNEoY3JGVPS6CrBamc2YlA3xB4F8BSNALOxH3v2yZlmch6M5TRymbj77HnKZlsvojDU5+GzmWb66a0dYwhUoSVdz8aCL7qOyLpyD4VdpE2KxMt3iPeu1nRiBBIT6bhlvd04hGvCAZy+uUqf8Xcm+zKFgfs6AiBt4hbJ685JpVO5Mfx4LSNLlyVJVMaqqtJGSf1+3DNZ/wZUSU3lgB9Kd8cOPoGk2E1yQZ6Bab/3UQnE9M8TIVb4NR/NSAIw+LDCXELgBQyGRkWuBr2PCW8XUYAjv3chOPuMD2BJzZ8DM2eFCNsk6yyqtoy00i1Ns+4DSC8nDpamVSzWnsj/TbnuMFZmB6P9rShincRH9cZkFoP4B6IwB8IktXiHhKMsei1nfLQFVAP8YNTqLiHZEegmguUTHND/pGg6SSGfnuQqTKhyXMmZ3vnB+0av0ROZS3yCJJYqmTzEp5xow3loGdqW8YvwSsHJ5Bz9U6wMcYgRdMG320OUjw7OixtJGLlhHHkQDADsUDuYiEakQmtts
 CGAVKZsf
 lpbnVdGJCYeKd3NWjmP0TPAoAT3j7Tj4eY4qwMwDUahkrFD4GVVXLxNGiG7COehXhPP7mhhfwd8uKwA0STOO0bGqH2GDXyg1aJeIrOeHgCMJQYano5URCGmy6IBMlobaQTcdoITS0cOFDZGjb8WRW5maZow6K3qlEP7i8sq9K1OnC+Hs0tIJY91umI9gj5f6N1DzILq0fMoVu/AllaYyXVwSgtNmbJA/JLWIMS+ORyRMwRjrgJVH2l+vMqazs3CYFHCUKhT+nrpHkYPZHY3yECVzvlwSPd5pLz/ddYBm1azDlERlRopMufxuSyZ/+T0PDRh5M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/17/26 5:21 PM, David Hildenbrand (Arm) wrote:
> On 4/17/26 05:25, Baolin Wang wrote:
>> Currently, when shmem mounts are initialized, they only use 'sbinfo->huge' to
>> determine whether the shmem mount supports large folios. However, for anonymous
>> shmem, whether it supports large folios can be dynamically configured via sysfs
>> interfaces, so setting or not setting mapping_set_large_folios() during initialization
>> cannot accurately reflect whether anonymous shmem actually supports large folios,
>> which has already caused some confusion[1].
>>
>> As discussed with David[2], for anonymous shmem we can treat it as always potentially
>> having large folios. Therefore, always support large folios for the internal shmem
>> mount (e.g., anonymous shmem), and which large order allocations are allowed can be
>> configured dynamically via the 'shmem_enabled' interfaces.
>>
>> [1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
>> [2] https://lore.kernel.org/all/875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org/
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>> Changes from v2:
>>   - Always support large folios for internal shmem mount, per David.
>> Changes from v1:
>>   - Update the comments and commit message, per Lance.
>> ---
>>   mm/shmem.c | 13 +++++++++++--
>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 4ecefe02881d..769ef37b1ea9 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -3088,8 +3088,17 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
>>   	if (sbinfo->noswap)
>>   		mapping_set_unevictable(inode->i_mapping);
>>   
>> -	/* Don't consider 'deny' for emergencies and 'force' for testing */
>> -	if (sbinfo->huge)
>> +	/*
>> +	 * Always support large folios for the internal shmem mount (e.g.,
>> +	 * anonymous shmem), and which large order allocations are allowed
>> +	 * can be configured dynamically via the 'shmem_enabled' interfaces.
>> +	 *
>> +	 * For tmpfs, honour the 'huge=' mount option to determine whether
>> +	 * large folios are supported.
>> +	 *
>> +	 * Note: don't consider 'deny' for emergencies and 'force' for testing.
>> +	 */
>> +	if (sbinfo->huge || (sb->s_flags & SB_KERNMOUNT))
>>   		mapping_set_large_folios(inode->i_mapping);
> 
> Two questions from a non-fs person about the semantics here:
> 
> a) Can sbinfo->huge be triggered later, for example, through a remount
> (staring at shmem_reconfigure())

For tmpfs, yes.

> b) Do we cover all cases with the SB_KERNMOUNT where sbinfo->huge cannot
> be changed later?

For mounts with the SB_KERNMOUNT flag set, which is essentially the 
internal shmem mount, as we discussed, we don't care about sbinfo->huge. 
Because for the internal shmem mount, we always consider it as 
potentially having large folios.

