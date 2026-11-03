Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D8D2606A328
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XyTgdQWb
Received: by kanga.kvack.org (Postfix)
	id AC01A6B05B2; Tue,  3 Nov 2026 11:08:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A97666B05B3; Tue,  3 Nov 2026 11:08:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ADB36B05B6; Tue,  3 Nov 2026 11:08:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74B726B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:08:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E58F14049B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:08:37 +0000 (UTC)
X-FDA: 85394290674.20.953FA5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id CF26D140004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:08:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XyTgdQWb;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UmsU380Tx/0AcknFjjF0B+jgdvRuMkPqh52dp469PY=;
	b=q64Yycv2dIHC7a2bXLw7XXpo8rkEZqDQaYMoUQpULxKfb8j6y5IvoE5ReMZRiu/xELx/2C
	tC58zdWFDB6LUkmTzV5ldFNFH8HhnHAWpa3siNnshX8S/r5WTSxZgrukKETtKWmx6L4/ed
	4d49NYBvjGaseimHe0xZ1RvYJfh5JBA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793722115;
	b=z7C2rt5Ilhv8nLlg1A3RMeGtMCXR2fSwV0Z1CdJoifpfCfkcvtuS5S9004BSaUaGa9RNyr
	8xvUUI5dAVwzD73+3hduoAcR7bYvsi/awLiefLt3jR3OjKNq2lPaCbh88O3p/iMUN3mf9y
	N7VSE0GLXIIPdkQMe7O9pSpACZekGG4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XyTgdQWb;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 202A740762;
	Tue,  3 Nov 2026 16:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DECD1F000C1;
	Tue,  3 Nov 2026 16:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722115;
	bh=2UmsU380Tx/0AcknFjjF0B+jgdvRuMkPqh52dp469PY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XyTgdQWb9HCTddV1G3L44R58/3OaVtRDUWaTm0CzlSS5n3dfE0ttDE/QvABp3FcsB
	 vtH5KDREUC6w7BI9UaeI4pnY0tNfWYXp5a8jpyPc7WeR2OTcy/YIybtY31beC564Yn
	 w8eWzTCQTD+LBtoiI79mJN0Iq3gXd8R1rB02InO0eRmdjmpN9h6dFPLAb4JtEcu7Zm
	 4vUfLXXMrEIQYdALapFWis9EBtp1WuZqAvbS76Id5vK6MhYCbYU72XNCa2zUrzkLzy
	 vFLdMRN/+22sIPqtdU91ENyfBAMs/erPyfh1PSBFnQK5RxgrknuyomCTyWpsp9fsCc
	 2TEtvGYKl9Slg==
Message-ID: <1bf7784c-49ee-4f18-b1fb-205dc064f40f@kernel.org>
Date: Tue, 3 Nov 2026 17:08:30 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] shmem: skip empty unmap ranges when punching holes
To: Hungyu Lin <dennylin0707@gmail.com>, hughd@google.com
Cc: baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261027171753.1485-1-dennylin0707@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027171753.1485-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 19xmwreydt7inbbwh7d7wkaycargbj4b
X-Rspamd-Queue-Id: CF26D140004
X-Rspam-User: 
X-HE-Tag: 1793722115-227652
X-HE-Meta: U2FsdGVkX1/rN6EFICRCzFmmEnw9PXfkMqIzZ4bX5jhyD3x/e+8Pix++i2/JzcKN5oqNL+0imhrZbJFlK5PnwG+M72hBwSrx9TpkOdl8dytTCPSmdt7sG1bSatEBTbxSVxF61u77o9zyZZ0QRdE2+KaG4E2E1T7YXhjnqlyxpcIK1Rgzf94BUFoCkNBYImXKj1G9eS2ois5XuCemAm0labVmzDfX4zW+vWKy4SiGUJlAq3AEg9iWTcX8kbWmKHM8m7Jorty8+L8qtq9xH3w13yW95wm9vJ6Vq3dgWxcwwgDguZTWrwzwLK/bJJzoq6uP8k7GjbPK2OsmMufYzx+j2y7pQoqL6lt0FBg2FEEExHRYOSHhmqkgkjgdSzYciEcso2PJ5pWM5mX69KgrSWp1PgSen0X8tndmWC8MOylUsIjE0I5gQD02JzMC0Bgq9jTHJKXyupsRG27xDYXKHVNuwLZYYA0b+j8cvuUvLXlRuxSuNIstH8Okr5X/chOTOEXktu4VUvBJRSZmm+9WCkqXxDIvSVxVwIHrOObCH3+ziBAydDFnDPdVOTyRs3yjW3zVvROZ+7B1Ks7Wtt3wJMlYeP9oFRevlU7C0aKRA6kXTA11dOMVzWyngulv44Cb4z7OtA4gAI47+ojHL+iKKSh8/UT4GWvvrTmiw118vv9ecWndbEvFOXC6bL3YM9A13MyewLDG0n+8nIo9uIVHHX673qToMAO7BF5XJuGu1pFXUtqslAFmJp4OZ0PrTk3BKMWHFcqX1Jug4lPR+HE9iPY/h89LEywgPWRy0DpoI46Aubj/olJ3YSvdfaWhGP+7NuThPLuQrs6Zaue9G32DM2sTea+vtJZYwFSqOwcfvw9FdVvJGBCbbHwEy73NAbxD9l9M/Alu2+LKk8BBCJVHivP3juDp6Q9iV0qzvQ1jeTo/Aog1JbgMr2SNWCeVLhZDvy41GUapbZManGAr6nXqEz8
 RV7tORgD
 zgzuoLOAkUewyYabr5vEp/KWvg2UQOJ5J+6W1Jw6gcs3W789igIZYGepMzulgIW3vnT12+k60RsIgFmb1SLi/LxjlTlQhF26HposTRWw0E1vj9VccGMbuvScNeZhe5H/rAQq4c71rSseOK/kymwanAxUyUJupjMAAzEnh2ip0M62uKb10DYoLZvaZnxZBWAsP3w8+YSze72t/J0omeCZY8iUEA/WVuwhJ6SJcqpDBO8KDQCIdSSKnmAO7ImsYQjbQVF+LJWkYiyZv1pLQrFFk9XVEuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 18:17, Hungyu Lin wrote:
> When a hole ends within the first page, shmem_fallocate() calculates
> unmap_end as -1. Casting it to u64 makes the range check succeed even
> though the hole contains no complete pages.
> 
> For example, punching one byte at offset zero calls unmap_mapping_range()
> with a zero length, which means unmap to the end of the file. The file
> contents are preserved outside the hole, but unrelated mappings are
> removed and must fault back in. This can be reproduced with fallocate -p
> -o 0 -l 1 on a mapped tmpfs file.
> 
> Compare the exclusive rounded end against the rounded start to skip
> empty ranges. Keep the unsigned comparison so rounding the start near
> the maximum file offset continues to be handled correctly.
> 
> Fixes: 83e4fa9c16e4 ("tmpfs: support fallocate FALLOC_FL_PUNCH_HOLE")

I would pick this for the next merge window. Given that this issue is ... 14
years old I don't think we need to Cc stable.

Other opinions?

> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
>  mm/shmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d97fc32e7c94..08d5336c27a0 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3864,7 +3864,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>  		WRITE_ONCE(inode->i_private, &shmem_falloc);
>  		spin_unlock(&inode->i_lock);
>  
> -		if ((u64)unmap_end > (u64)unmap_start)
> +		if ((u64)(unmap_end + 1) > (u64)unmap_start)

Can this be >= ?

>  			unmap_mapping_range(mapping, unmap_start,
>  					    1 + unmap_end - unmap_start, 0);
>  		shmem_truncate_range(inode, offset, offset + len - 1);


-- 
Cheers,

David

