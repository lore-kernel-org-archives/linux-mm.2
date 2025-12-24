Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B81FCE74905
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 01:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 104BA6B0005; Tue, 23 Dec 2025 20:43:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3336B0088; Tue, 23 Dec 2025 20:43:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00E16B008A; Tue, 23 Dec 2025 20:43:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC05F6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:43:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9EBB11386F9
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 01:43:16 +0000 (UTC)
X-FDA: 84252666792.06.0AC7A41
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 79E6A1A0003
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 01:43:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wujlsNOD;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766540595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTBbu/2wTfEwRaeB/LIZ7XgTg0+gpS5cMbulWwscrZA=;
	b=3KZHCr6qGrhzuZ1+DZHYwneLi7V0baAGM2QTDq5FrLym/tYc/6PqfOO73+hfa52z1ixzwM
	0ggtKNOZSrx/KAwzumJuOSruH4gQKb86fbFLLpN3+HWPE4SBcI+q7DHBqHBJ4drz8jt5tl
	BnqvIQgIT9uKZKgrFPJ7G6C9n4U7C+o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wujlsNOD;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766540595; a=rsa-sha256;
	cv=none;
	b=VSPhhkqmpQ1Vgcs4ygNYuUmxl5iUINCOmAuymxsg/wMJT457wiNqN9t+MUm1kr0jDhWVF9
	5QCenYOnLlwWeKJat1VpMymR7ub5GZC+ytjlWM2U8sWqij47AsfxsLvfwjhTl0CD05jE8u
	qN4ssgHzfc/1dLCaN/LS0wnXySCmzBU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766540588; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RTBbu/2wTfEwRaeB/LIZ7XgTg0+gpS5cMbulWwscrZA=;
	b=wujlsNOD6LMcLBpfggX3/YiGokCv3chtlUR4Rd7UCrtld61gHlXzQ0mlf0hMoVJ2iTzHaJS1V7GNEEVyTZHobK6Qvi3GeOVFAyBUGBor/Lwx6pQ9XchtP+x6udbqV8TqqwGZs1fMC5DJAHdoydK2mdB8JBt90LsL5JmrrpX3QjA=
Received: from 30.74.144.133(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvZJ6O2_1766540585 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 24 Dec 2025 09:43:05 +0800
Message-ID: <9bbc1962-5f6f-4e3c-a672-d80565aa5157@linux.alibaba.com>
Date: Wed, 24 Dec 2025 09:43:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] KMSAN: uninit-value in swap_writeout
To: Barry Song <21cnbao@gmail.com>, pfalcato@suse.de
Cc: akpm@linux-foundation.org, bhe@redhat.com, chrisl@kernel.org,
 hughd@google.com, kasong@tencent.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <7ng6tntadu62ls32r54aetyevgbghta4oufyzxtq5ym6bprjai@hc2ozb2mbcyb>
 <20251224001617.45293-1-21cnbao@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251224001617.45293-1-21cnbao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79E6A1A0003
X-Stat-Signature: y9gczzs99519gc7rjf8q7qumoabsihh3
X-HE-Tag: 1766540592-559986
X-HE-Meta: U2FsdGVkX1/8MPaGT8CxRHeoO4b9I3B2+GJtYDg6n3ETlbN1DUk/x10M6hlhcMC+orWXFfh3RnHbllCnWhazIvm4fA9Bc/JEXmfV5EFv8d3R4hjRmC4dz5E7suoqvoRneUiE8r1i0RRXXcilo2ZC3G/KnoKfFwJ+LNLiuW2mZ2sO72jUpTavOogObXxiVYL0CVIWd02aFGs6/TlHj3g6tMg4VDumP7QHuPxoS1JZ2qmbw9N/kV4ieC30sE9elm6Uz/JotfhdGZyMOUQC1AjGcMn8PKXEReFmE5FKqJsq2OC5jmaYQXQJY6t5b5zThp7vqQDcSS1TS9wTBpJVSnoWogXHUQPIsEAcO5V36dJRhNvM5LQOE85AtQ07InUSPSWZqxTbeirkqtTdBGZIhRO9MI7Lkj4O9tl4G03aYPad5+p8qbnyNBiH2WQtSl4BZdkweSaQ0+knYHM0NZuoXjcQslbCoHqEkRjoKxAFZusB9SeAO6dE+CqeNUWGoV8vhxK8UeFoo7o6S3xNVSEIrH6NH2/WBBm+5P1wxZi+uw/HGmmdHaAOSPiOFSua9ESn+R+kYcwlyrsz+cWEHw22c6ojmlfX0zajs+uTyeflRflkoOlmJPttDvjJA01P+mK3Z+UpYvXcJFI4EgT0XOltxxnw5s0GpUGoia9NpqEbOQ4xKBNaHRd7TuXSMmImS+OuTxjvWq8cXyqKtDAUmlpR0ir9Hd4NfRtjPDUNldjhdJNloMgtBojmkB7ZCuvWwCAqX8hd0kun2NEtScPjfwDSsTV/ZmZGIoVk5ZdQ0Mehz48EwNxgaVu5YYo3XQ251nmYo/Vi1KiWxanC/W+3rQXJmL9cf3bSYy3p6FDfhWKSeWIpwZpYwfPNL4l8cHjNrlcwdcX/JFOML0wefRspAjnjRUOf98VbtyldLRZ26qz68t+qeQkb9tInSrDqsVin5R2/D0cy12KtixJFVOobh7I77Sn
 KUU1YvJ8
 uskvFgfu6ad5di2sextIkUgDA8Bgfx1VLzAi53GEgfqHNRrdcYFJfv1gTdsl7SBNiRpxCEZyXMSzAg4pm9kegYWzWzzG40wirXhT2KspavG50AW75JqhuJz316Jio2lx9058dxMN+KMsuONmhmlOWID0vU9lT8jQ+h/e7luhL75UspPLGlq/wG9xzSGq4+D2ax6Y0qehl+LfzbEoTfc1r0i5HsetnxdVg5XHcHfvNtJOjzCP3gdwRo8flu7XSxUARWW6aBuMUh72o/AXkVCOT3pUeq2uXtyJ1IocnOssYwqNJDnjJpHj/OkQHJq9vTjHgO3SrMxja6dL7RWkTfZ6JBNwIVPKSHFDzU7PqxJZX7raT8GaC/uFf7GzrKfZT+h+jlRGhw6C/Rb2vhOUlhJq0SUrT6mjgXkPbtc5y/F2cmE/CrzsOvfLS9Iy6QKXJ9xB4NHcBmkFugXuofYzzuSQk+psk0uVjaZ0YRbOzlFlbGOvGuehjSxxfciQVQ7juprNdezFwgfGVjhWrgNwmQgsbeCTQ5sENVB8BeMXFLPVngcgGLc/+t3qDROftPsx0uYyB5TpB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/24 08:16, Barry Song wrote:
> On Wed, Dec 24, 2025 at 12:43 PM Pedro Falcato <pfalcato@suse.de> wrote:
>>
>> On Wed, Dec 24, 2025 at 11:46:44AM +1300, Barry Song wrote:
>>>>
>>>> Uninit was created at:
>>>>   __alloc_frozen_pages_noprof+0x421/0xab0 mm/page_alloc.c:5233
>>>>   alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2486
>>>>   folio_alloc_mpol_noprof+0x56/0x1d0 mm/mempolicy.c:2505
>>>>   shmem_alloc_folio mm/shmem.c:1890 [inline]
>>>>   shmem_alloc_and_add_folio+0xc56/0x1bd0 mm/shmem.c:1932
>>>>   shmem_get_folio_gfp+0xad3/0x1fc0 mm/shmem.c:2556
>>>>   shmem_get_folio mm/shmem.c:2662 [inline]
>>>>   shmem_symlink+0x562/0xad0 mm/shmem.c:4129
>>>>   vfs_symlink+0x42f/0x4c0 fs/namei.c:5514
>>>>   do_symlinkat+0x2ae/0xbb0 fs/namei.c:5541
>>>
>>> +Hugh and Baolin.

Thanks for CCing me.

>>>
>>> This happens in the shmem symlink path, where newly allocated
>>> folios are not cleared for some reason. As a result,
>>> is_folio_zero_filled() ends up reading uninitialized data.
>>>
>>
>> I'm not Hugh nor Baolin, but I would guess that letting
>> is_folio_zero_filled() skip/disable KMSAN would also work. Since all we want
>> is to skip writeout if the folio is zero, whether it is incidentally zero, or not,
>> does not really matter, I think.
> 
> Hi Pedro, thanks! You’re always welcome to chime in.
> 
> You are probably right. However, I still prefer the remaining
> data to be zeroed, as it may be more compression-friendly.
> 
> Random data could potentially lead to larger compressed output,
> whereas a large area of zeros would likely result in much smaller
> compressed data.

Thanks Pedro and Barry. I remember Hugh raised a similar issue before 
(See [1], but I did not investigate further:(). I agree with Hugh's 
point that the uninitialized parts should be zeroed before going the 
outside world.

[1] 
https://lore.kernel.org/all/02a21a55-8fe3-a9eb-f54b-051d75ae8335@google.com/

> Not quite sure if the below can fix the issue:
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ec6c01378e9d..0ca2d4bffdb4 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4131,6 +4131,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
>   			goto out_remove_offset;
>   		inode->i_op = &shmem_symlink_inode_operations;
>   		memcpy(folio_address(folio), symname, len);
> +		memset(folio_address(folio) + len, 0, folio_size(folio) - len);
>   		folio_mark_uptodate(folio);
>   		folio_mark_dirty(folio);
>   		folio_unlock(folio);

That looks reasonable to me, though I prefer to use the more readable 
helper: folio_zero_range(). Barry, could you send out a formal patch？ 
Thanks.

