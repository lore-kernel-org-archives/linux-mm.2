Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24723CCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 02:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668B58E000F; Wed,  5 Nov 2025 21:44:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640978E0002; Wed,  5 Nov 2025 21:44:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5565F8E000F; Wed,  5 Nov 2025 21:44:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 442528E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:44:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4E99B9E93
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 02:44:21 +0000 (UTC)
X-FDA: 84078638322.28.691051D
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf16.hostedemail.com (Postfix) with ESMTP id 95FDF180006
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 02:44:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xgwHqogv;
	spf=pass (imf16.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=libaokun1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762397060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SmiGeerJpItekeBrZ0vp8zm0YzZ1kocpU6u3YhL4BMc=;
	b=iMgatINTJ1O3J0zwTrpdfm/FlbTdSC0mqSLYGiCvfIoz8vHr5Oz1M1oXR33ZI/bHTmWxf9
	MSqhtJ0HtU8l34DszXs0/yfxGpmzhFtf884McUSq+C4te8926yOhCl28tYoWRZB+OaoEZc
	3ypBSLRO7cCHlUAEnox4jrRqfoAf7NI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xgwHqogv;
	spf=pass (imf16.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=libaokun1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762397060; a=rsa-sha256;
	cv=none;
	b=FLtY0/PZC9T9s8kPcR/BaLoCSRNO3euSxK5Mh+HvYL3cxi/5juylyvETzimij1PMgqeno0
	O52YntQ/cIcINTKwTHW9ZGd93uweMnkGcN+A+4h6v9Ax0U1wTxvAGZ212QNT36EH3Z2l7p
	I+DC3z672x9GqMI8vaDinjX+kE/W/rg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SmiGeerJpItekeBrZ0vp8zm0YzZ1kocpU6u3YhL4BMc=;
	b=xgwHqogvKdjdSjQOEiNXt3yMJngtWo0Y3iXn2mRqv7EpqxcVd312T/rdqLXC8B4Ld5dCDQJdA
	X16AvLmzek4Fl5/+heqACTw+WUdIqjjuNZrTxJVMbinUXaT0bUyaJ/Ii3lrIm7lg+Ev+H+0MyZb
	Uq/4Xu/yXujZiDi+0Wfnd1s=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4d261908K0z1prKm;
	Thu,  6 Nov 2025 10:42:37 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 4B608140276;
	Thu,  6 Nov 2025 10:44:13 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.254) by dggpemf500013.china.huawei.com
 (7.185.36.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 6 Nov
 2025 10:44:12 +0800
Message-ID: <242f4438-d84d-46a6-86fe-8629c7e028cf@huawei.com>
Date: Thu, 6 Nov 2025 10:44:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/25] ext4: enable block size larger than page size
Content-Language: en-GB
To: Jan Kara <jack@suse.cz>
CC: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<linux-kernel@vger.kernel.org>, <kernel@pankajraghav.com>,
	<mcgrof@kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yi.zhang@huawei.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
	<libaokun1@huawei.com>, Baokun Li <libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-26-libaokun@huaweicloud.com>
 <yp4gorgjhh6c3qeopjabmknimeifhnpbz63irrrtjpplatnk4k@ycofoucc4ry3>
From: Baokun Li <libaokun1@huawei.com>
In-Reply-To: <yp4gorgjhh6c3qeopjabmknimeifhnpbz63irrrtjpplatnk4k@ycofoucc4ry3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.254]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500013.china.huawei.com (7.185.36.188)
X-Rspamd-Queue-Id: 95FDF180006
X-Stat-Signature: is3m96wnbobyne4th53zw1hkjzaos7yk
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762397058-140660
X-HE-Meta: U2FsdGVkX18ZdVXUXjUp9IljzqJV2fQYcXqUD0yzzWlFUGjUtU59I441FuBRHGfuG8fFtnSe48Kaidp8x+HqinFtFMRsNdsB3WZPqcOjuLpXZyd8sb1Yz2nST8gvXLLvwqgz7VOA+DDO4CF/od7u6JLzbYnx5ccH38R4GdUwaBbcda+uzZ40pdrdBPjDFBMIW9pQX1WXFYyL+4opavgQ04MuM7HViCPtdvT1+KZ7mLqCNYL3acHEHYT2qphza64rd1clATISg8U3wGNdRt+f6nHA3cgiCjnDAp6iGbFbXQQDqofuVMV9H0ndxUfrdZTBnuuxm5KQFRenlLluZgsakru+LbGdEHMmZ5hUahGrDMzeMCO3AH/uzIaJ723VVgBMKn33YGPPoVrKCmwX8BBnALMWMuyKXhUnX8fj9GCTNKmwyC2gjI/wdvrAD3K5L6ExVJ0X8LpkN9Zj7xoeCq699VX9fPCeUQyhmjSvfknvoHYI1i9W5hLrqq7PDcGfUT0LDZK23zmLsCm/YDhajvzqaO7oHARhhxKW3IMC/L2KOD7VYhFJn1FLTbTxSmmr73sycHLknQi97cwjpCTxCe28D0uwWYSjCzE4jsaHwLWUUrvnVOD0Oq8t1Sy8/IspS2dnc4O9E0vAy61kNmDNkXtMx+IAYgzIMHBJbRvyX0wmo28WnONWHIWSTY34xNh7tfvX0csXFVJGbBvm2ODJHhPO2GBBoj+bnQYhd5kp/qvnmaB5eddlH1FFj+8XCTxp3tAQrA04z3x/quzcWmB0aBYyxvCU+q5HS1l7VVCuLuDkeA9HvuUEeMYFQRViwvm0jUx87NxXR2F0Ca5QOflDRlJQT8EYrOEZMzYJo6NcvbHIJZ7SNhuvtJ+oGGIwfKxcNZ9zKr0IBm37iPhNeKNaxBMz3n2CkIKiQIP2gteAd2Yc9Ul+SE2P3ZGXxNRfg8tFgMKVvC3nj93eOYuZqaEm1G3
 Hbbxw7zM
 QDZ4e2cyGT6a/QTiTUoK+qzo69YFE9AQYsGWM0Hz0PPvSSfkV/rN0M+M30xmmytnbiN1j2x/YxOygRHjuUOhEQ5FeCsyi96RPc03H+Xn/q7HIE0ODzIbybanlW52RFSyymnzGr1nfkR4iYcd4wxERv0Z8c3WOB7Gz1xnkYnycvE0AlNUI0tU0xbhUoEj0L68giM0ZcVzpwreF7gUM/jbAhgpSEbcwgFcnAQpj5MqorPjL5xVbqFHmQqVVaYFz/ID2hVP5RRrBCD83oVa2vH0DyoBl5e0uAB93pw01iTjvJmwvZVTbUc1hurE7nrHzkQ3Dl2a9BfvVNuy3aC0xf09FCa/nI6OFkPEsYPSPKEWxXQbWzX1et+djI6D12IQcq0dwGSgh8JOgBzZiuayIRXDmM6WK+vT4ubEuYYKpqf/7DMOERiLUr7hYu1eR+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-05 18:14, Jan Kara wrote:
> On Sat 25-10-25 11:22:21, libaokun@huaweicloud.com wrote:
>> From: Baokun Li <libaokun1@huawei.com>
>>
>> Since block device (See commit 3c20917120ce ("block/bdev: enable large
>> folio support for large logical block sizes")) and page cache (See commit
>> ab95d23bab220ef8 ("filemap: allocate mapping_min_order folios in the page
>> cache")) has the ability to have a minimum order when allocating folio,
>> and ext4 has supported large folio in commit 7ac67301e82f ("ext4: enable
>> large folio for regular file"), now add support for block_size > PAGE_SIZE
>> in ext4.
>>
>> set_blocksize() -> bdev_validate_blocksize() already validates the block
>> size, so ext4_load_super() does not need to perform additional checks.
>>
>> Here we only need to enable large folio by default when s_min_folio_order
>> is greater than 0 and add the FS_LBS bit to fs_flags.
>>
>> In addition, mark this feature as experimental.
>>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
>> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> ...
>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 04f9380d4211..ba6cf05860ae 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -5146,6 +5146,9 @@ static bool ext4_should_enable_large_folio(struct inode *inode)
>>  	if (!ext4_test_mount_flag(sb, EXT4_MF_LARGE_FOLIO))
>>  		return false;
>>  
>> +	if (EXT4_SB(sb)->s_min_folio_order)
>> +		return true;
>> +
> But now files with data journalling flag enabled will get large folios
> possibly significantly greater that blocksize. I don't think there's a
> fundamental reason why data journalling doesn't work with large folios, the
> only thing that's likely going to break is that credit estimates will go
> through the roof if there are too many blocks per folio. But that can be
> handled by setting max folio order to be equal to min folio order when
> journalling data for the inode.
>
> It is a bit scary to be modifying max folio order in
> ext4_change_inode_journal_flag() but I guess less scary than setting new
> aops and if we prune the whole page cache before touching the order and
> inode flag, we should be safe (famous last words ;).
>
Good point! This looks feasible.

We just need to adjust the folio order range based on the journal data,
and in ext4_inode_journal_mode only ignore the inode’s journal data flag
when max_order > min_order.

I’ll make the adaptation and run some tests.
Thank you for your review!


Cheers,
Baokun

>
>>  	if (!S_ISREG(inode->i_mode))
>>  		return false;
>>  	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index fdc006a973aa..4c0bd79bdf68 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -5053,6 +5053,9 @@ static int ext4_check_large_folio(struct super_block *sb)
>>  		return -EINVAL;
>>  	}
>>  
>> +	if (sb->s_blocksize > PAGE_SIZE)
>> +		ext4_msg(sb, KERN_NOTICE, "EXPERIMENTAL bs(%lu) > ps(%lu) enabled.",
>> +			 sb->s_blocksize, PAGE_SIZE);
>>  	return 0;
>>  }
>>  
>> @@ -7432,7 +7435,8 @@ static struct file_system_type ext4_fs_type = {
>>  	.init_fs_context	= ext4_init_fs_context,
>>  	.parameters		= ext4_param_specs,
>>  	.kill_sb		= ext4_kill_sb,
>> -	.fs_flags		= FS_REQUIRES_DEV | FS_ALLOW_IDMAP | FS_MGTIME,
>> +	.fs_flags		= FS_REQUIRES_DEV | FS_ALLOW_IDMAP | FS_MGTIME |
>> +				  FS_LBS,
>>  };
>>  MODULE_ALIAS_FS("ext4");
>>  
>> -- 
>> 2.46.1
>>


