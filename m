Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C3B0E7E0C0
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 10:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E5E6B0005; Mon,  9 Feb 2026 05:24:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54C606B0088; Mon,  9 Feb 2026 05:24:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 403956B0089; Mon,  9 Feb 2026 05:24:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 303ED6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 05:24:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8012CBAE2E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:24:16 +0000 (UTC)
X-FDA: 84424533312.16.F72A175
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id BF63940003
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:24:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P+g7HWxD;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770632654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxSg+rr3i+FIcdzPsCtk7hEL6tJivIsIL2+u16mFvNg=;
	b=pOFqLKRCBqdTRIm9b0y19tQVYjfu7jml/f2cU2u/L/CybPjNi0iLv8ru0pRw9u1UhOjpWG
	Kf8kBk62Lka44Jcyd4B0z1RKLuIGHQbAKTSjEERG0s5AS+21ZiUZZmhZrT0q9nsbuAljtU
	Q+ttNaLinzfCXOprtsk7DU1wVWgah9o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P+g7HWxD;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770632654; a=rsa-sha256;
	cv=none;
	b=jWJ7ELnWvY3jEDKJK21BbjAD/RYK5i1ru8bssTYIWOZSxLA6ZlQDtS61rlWaCdeh2mVcjo
	1A66LqBzftVY9ad9H5Y/JcELchqwHoCedpdg63SxI2AlBrd8D5YgRZmL2k1gekPzvGyHVp
	1q1HJGy053RT4mtcQ+OSxxXIRMxaA6c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2298F60008;
	Mon,  9 Feb 2026 10:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E48C116C6;
	Mon,  9 Feb 2026 10:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770632653;
	bh=7byzve2KBPNejNVzw6d0LoR5buYIQZxd6d4ggi5K93A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P+g7HWxDLSrBmFXhK2pT4GUqEBwZQxUiz5UcND2+oXAr8lBgnBxRYWVr0fYzUHtAS
	 fY9DwTYePgsWD1AI52ZXywDOgq/25at8l5oMYXFUjnkiFD1EQ+eT6bqQUmAZdGu1dz
	 gWOJ7rkQyA/RJKZCbCUxImYsNfs8U/tDf7jCdHb8qcCnALaOOKIB5zLXK/O4omGU0z
	 IB7LJWWwUaL+S7K/MNDXmjZJI8g6ga9WyvxYcVeZmYnjRnrv57kTgaZqUj93WwKL6F
	 w8Mr+jmFy6riGcZnKEk6up5imkQnaiL+aQPh4Vr/qOw71TC6mAkOkROyTYQWA/31Ee
	 VeHutgLTteC+Q==
Message-ID: <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
Date: Mon, 9 Feb 2026 11:24:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
To: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ackerleytng@google.com,
 seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 vannapurve@google.com
Cc: ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
References: <20260209033558.22943-1-kartikey406@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260209033558.22943-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BF63940003
X-Stat-Signature: ppub8w5d3dknm18ty4ce1yuywcmuaeff
X-Rspam-User: 
X-HE-Tag: 1770632654-773448
X-HE-Meta: U2FsdGVkX19bka8se3wHOZDbHq/KmUBarJn/IawPZ+YHhV2UChXGEAaHlth/oQht0xWKECfs8y4ODT8hQBoAFItcJvuL5ruXmVzg6fsFYDHg3/3X80KqO5/98GySSoyRrjjjAetQVvsK5GXqZZIUrVd2zm/8NKPIqEG0Xsv9hNuIuk3I6M2iYD/yLpnzRFmqwvUSB+OI945/n7rvFmfEg9NWxS+78X5595bVvNt60p7w6QbEm2DeT6EJrxvP944GDch3whxl1Eo8DvMxwz1Jh7AD6OntdsBoGQgKTWSqdYb7chkFYzA3XlnnZ0cCxw4GY6Vc4Hp7ybLCLKuxGwiaDa07mp1vTQRZcCW2e+rceMvk4YEDUT42ms8AzTcmjrXXKUSmgox0iWuaZ0BaYOtQ/TILaByKKILn2VzGWGn6caSvGA6rBUGRIObjCWP5ptKzoNBFNyqvYK+XCyo4IgfAyyTwDn5V3h46BusGFifqZDT7uWa4Nuwu29N+B2LiD6x4Y0cBo/Z1aj5QgikIkXjM0FaYRTjAnc78Dy4VkoiTmDcWrYH6XS22WgRhvquXnSxtqBYkFA2gby9vHg72g82H9royQHAtKDcidaiukLIbe9qnGx6wZIkIFXKz9hOMQtIpJpGFPj79wPvo2lhzs9yJPqLJEjbLATcaIrcTzBJkjJOn8QgkbwqB8sD5a6QUo5GVWkoS2LO/CPvqesZqmfdpYFGG1uZsQjaJQviivx3oOZL6zi86AI1zseaZElwjqR7096ZHk9teBF9oa/r8GZLfptfACLOuqwhm8Vw/Kb5bAPjLge8VxWx3sbvzzNZYp61XE42ZPr4yj/IUCYKqYre7lv3lEzZE/K84d3xnIb3DUV60352u3CumH/gwmYZ0+HXNmTRFFqdJ2SYz4/LbVBNXTEal5eP1hVjsLeirH1qBLwwzX5zhuss4AfoGMH0FOuVBxsfAwjai9BWhr1xEnwR
 OpoWiW04
 G2S7XB5b3grIKRAPaZZUOkyw4M3XgYBbHfeSHvLx0UNgGFvfm74XzIWgmCBhrPk0riK0Qa6G4uZ0+d1lLlrLiZ0Ip8TfY4Pa4K3W5B810It0GarfVEahrLb81hi14kYMg/+3HcI7dQeO0d0VudTJt/H3dOxQa5B+IuTIAUBZXR3dpguPnb3xPYP0rvRQcqUSCtM71rgDvAS8rr5fUuK7Y/MGzJYynZzBWrVTLaedMtDm4uLqDoqNao4ujgndHrRCC514sPzSWbHN1y9Ig7W6AF5+BbTi4frxpQVqCcAVjbRDgJKlXoAfBRFIDH2PyuRzc+zm5LNui8YX0uuLoyDxWF6H97LRsbbrLacaFAQd3PWH03NtGoV6GA9kqwjbaeYC6OvctDOFRaxOH75ejwgl2PB3Nm4WZUBUZyRMRzyaoDaAeoba6FssRynqdlruJ8tTYQs48PBhmeYlQA89aBV54zqld8QmyoDXNJ3vRyEGluRMHPWaMCaYS8FWJFGGJzpDUquYYD/UTrXFFEgMIscLXtqh6BXPFQ+ZaEhgkpYD5CJBMIhvxvqVlP8cGczMlTGlcyz0mnak61bc7x97x4/0tlrdNUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 04:35, Deepanshu Kartikey wrote:
> file_thp_enabled() incorrectly returns true for guest_memfd and secretmem
> inodes because they appear as regular read-only files when
> CONFIG_READ_ONLY_THP_FOR_FS is enabled. This allows khugepaged and
> MADV_COLLAPSE to create large folios in the page cache, but their fault
> handlers do not support large folios.
> 
> Add explicit checks for GUEST_MEMFD_MAGIC and SECRETMEM_MAGIC to reject
> these filesystems early in file_thp_enabled().
> 
> Reported-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
> Tested-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>

So we were able to reproduce this with secretmem, right?

We want to add "Fixes:" for the introducing commits, which would be he 
commits that enable secretmem and mapping of guest_memfd pages to user 
space. Can you identify them?

And also

	Cc: stable@vger.kernel.org

> ---
>   mm/huge_memory.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 40cf59301c21..4f57c78b57dd 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -93,6 +93,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>   		return false;
>   
>   	inode = file_inode(vma->vm_file);
> +	if (inode->i_sb->s_magic == GUEST_MEMFD_MAGIC ||
> +	    inode->i_sb->s_magic == SECRETMEM_MAGIC)
> +		return false;

That's nasty. We want some way to identify that through the mapping.

Unfortunately CONFIG_READ_ONLY_THP_FOR_FS ignores any 
mapping_set_large_folios() configs by design.

And CONFIG_READ_ONLY_THP_FOR_FS might go away soon, but we need a fix 
until then.

While we can identify secretmem through vma_is_secretmem(), we can't do 
the same for guest_memfd as it's built as a module.

Unfortunately AS_NO_DIRECT_MAP[1] won't work.

Maybe introduce a AS_NO_READ_ONLY_THP_FOR_FS, which we can just easily 
rip out along with CONFIG_READ_ONLY_THP_FOR_FS later?


[1] https://lore.kernel.org/r/20260126164445.11867-6-kalyazin@amazon.com

-- 
Cheers,

David

