Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C759CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 14:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3848E0085; Mon,  3 Nov 2025 09:45:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB428E005A; Mon,  3 Nov 2025 09:45:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7D18E0085; Mon,  3 Nov 2025 09:45:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 989578E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:45:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5797114017A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:45:56 +0000 (UTC)
X-FDA: 84069570312.07.20892F3
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf16.hostedemail.com (Postfix) with ESMTP id BA3A2180010
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:45:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZrVfyp0j;
	spf=pass (imf16.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=libaokun1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762181154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LC8BaVmEmaGtKa9JcwOiElMRg81zujwUDW5FoPzdQI=;
	b=Xy/upSWjG3pjiu+YULRa8Rd50mZk7L8k0StTgvEHomg8j3QT9cq3gf4+xfDCL52qC6Efbx
	LcPZbgAjkhCPdp313D8NpKLw5wsXMJPl5macolSdysRhFDTbiO0OI7ZLXSzLI3jqtWxfUE
	3j3WRlYs7nd8iKnwy1Hi9D02SsGMZw0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762181154; a=rsa-sha256;
	cv=none;
	b=rH3xdphQVuhb6Mw+41qP8/jncfP1qkF+dMFtZQbNsvHTPuQ1mwbXCdXRltbwESr3Mx9PNN
	47qTJAAg2+RbZwkjaGwaqYjhYmikr4tTPJ2Q3Q1wQM+5GIvp2kacg/dRpmvnnY7y6FMWTk
	hD1FSXlkuNHFNjgHF1JlXX5JwHV8QuQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZrVfyp0j;
	spf=pass (imf16.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=libaokun1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0LC8BaVmEmaGtKa9JcwOiElMRg81zujwUDW5FoPzdQI=;
	b=ZrVfyp0j0n+oW0sutIipbJeS8S4W3Wge73tR8pElvBWhuZvtKYACoB7FRnnL6B7bBymggBA+a
	4jILv5r2D4DzvBg45yzGoxCGYRxCZGOTsSUglQVwDCbEnV+qli1fYSIMcIBUnpdo8UPdM+M7Ntx
	en0YEvk8IfHNl+RcM+5dO7c=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4d0Z993nq4z1cyPL;
	Mon,  3 Nov 2025 22:44:13 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 07D32140297;
	Mon,  3 Nov 2025 22:45:48 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.254) by dggpemf500013.china.huawei.com
 (7.185.36.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 3 Nov
 2025 22:45:46 +0800
Message-ID: <761b447d-6e34-4a6d-b1d8-9f744ab548db@huawei.com>
Date: Mon, 3 Nov 2025 22:45:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/25] ext4: add EXT4_LBLK_TO_P and EXT4_P_TO_LBLK for
 block/page conversion
Content-Language: en-GB
To: Jan Kara <jack@suse.cz>
CC: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<linux-kernel@vger.kernel.org>, <kernel@pankajraghav.com>,
	<mcgrof@kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yi.zhang@huawei.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
	<libaokun1@huawei.com>, Baokun Li <libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-11-libaokun@huaweicloud.com>
 <pgrk2x54egzxcvmfi4rra3exooxe3yxuvug6yvbtrgxm2oppym@fy52xh4weeww>
From: Baokun Li <libaokun1@huawei.com>
In-Reply-To: <pgrk2x54egzxcvmfi4rra3exooxe3yxuvug6yvbtrgxm2oppym@fy52xh4weeww>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.254]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500013.china.huawei.com (7.185.36.188)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA3A2180010
X-Stat-Signature: 4eu9pggbwmucyk8ufaudfuckmi19wk95
X-Rspam-User: 
X-HE-Tag: 1762181153-247256
X-HE-Meta: U2FsdGVkX19fdRbCiCDMBxE4FJyziNvs1Qp0lKqkYlt5rEOx2PCmLQMI00XaGdz37gPmg+qr3WI6tN0HAPIGqKskAGiSX7/j/tlUEVlqcAZraThegHz8DjDJa+F2+J04pxNg91kVwrt7EYZRhzqqDSGOtVukZkXCoKo+ngz/Omd5BlURNoGIXyg6zWcZEdwxBpHy7eFYwjzx1WbR7DpGpG50EncA9B/juRvbXTZMJort45bbqZg4qnm7gEqw3SYiKiYrEmNlbhQX50ddgq4rUHXnqv8KSmwkEEGUCpD3sO417xysxkeBv+lEAez6YyPPSaXTqjsjzrOhZWQmTQUi/Br99zoZUeAUGGhIi9YLprNXDXhjmUrSu7DGrY9dPD4HIy6/kD7qQQSo/09CE+5XmXEwR646S9Aq/wkcy/LGhYgSNSLN20qo3mCFRj3Lm1MWRCvcSgHo/f3EkCIYmg1nFUTrqpmxB8UUe0ncBjydLIdey1Rzx9h8uG86Y0MrOVohevdiNqXLqAcAohMST9Rhfdh+u21TdXDgsZeIyYwopLr1b0vKiGH8omuCqsppVpKYcz4xs08cbzcPZDTE40bAkmRvW78sOohmDWIIcoOspQdkKZ4e6MSKvItgnBu5zyql9+inVJpuvsFBlq8eq90X6DcOa0s9sROjGp9/M8FtKt6cpv91mwQJqAgEEB6iIZMIdEQabxNwEmDCX3OqFj9BDevHBPN/WvkBk0kKwIQo3QyCVUC4KhTdGHEgRdMyBmTvs0Fgk4qGxoP4YwMRd/NCCYAnLU78cSviMGZGVGUvjBbeA4P4zbBYSI02ba/tUXjmENBmQFqh4aFteKVN7vfhM5HJngzHFt65tzOCbs7ubghVaJyRrP+3SEXNFWOflN7It/C5FtMZt55/QF/H3MTbojfaIfIoswfe+wae3XzgNYfQU18yw6LDH1IHQvF2AViDFeM47rO7H/KjeY6UDwx
 bvFv4HSM
 +4IKsFWEiS5TdCclrbR5L90x2CTYf2X96QtrKt9w+r5vcH3cQubq51ZVv2JO7TRSuRVrlGFx06YlffYER2It0cLvLTmLPon9fepg0JQlWUoao8AwrqfZ8thkkvMpvYV/Q9l42qQzmE0vrbDl5Y+/lAyW7sft/gNJnz69SADe1zdL2dAoC8F1eus8rZkgZYGPJIktEm0j0fzKu/3WAgZ9ETOho4SnsfICIqh/q+N09a0JeHL6pY3+0vdhM+IW+8n+WOSHqKqXguZyjIrIiKiDQ4dWNYrBBt3NaKRUxM/LfKBrHLkPhYWOGVwwJIt+GPLAwVVPigcjxM7uyKn1MyDDcAGe2wBaS2ohp7cBqbLRHjeDSmHM2AmzPFoADiZhjQDF4kyQGpbMF8ctvrLn9GshUsbowWvWwa0Uo34yx/IC8A/M5DgQWD8FFNPoV9jgepJuQC3VbX0Wn/XD7TuQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-03 16:26, Jan Kara wrote:
> On Sat 25-10-25 11:22:06, libaokun@huaweicloud.com wrote:
>> From: Baokun Li <libaokun1@huawei.com>
>>
>> As BS > PS support is coming, all block number to page index (and
>> vice-versa) conversions must now go via bytes. Added EXT4_LBLK_TO_P()
>> and EXT4_P_TO_LBLK() macros to simplify these conversions and handle
>> both BS <= PS and BS > PS scenarios cleanly.
>>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
>> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> 'P' in the macro names seems too terse :). I'd probably use PG to give a
> better hint this is about pages? So EXT4_LBLK_TO_PG() and
> EXT4_PG_TO_LBLK(). 

Indeed, EXT4_LBLK_TO_PG reads much clearer. I will use it in v2.

> BTW, patch 8 could already use these macros...
>
> 								Honza

In Patch 8, the conversion is for a physical block number, which has a
different variable type than lblk. Since this is the only location where
this conversion is used in the code, I made a dedicated modification there.

Thank you for your review!


Cheers,
Baokun

>> ---
>>  fs/ext4/ext4.h | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 9b236f620b3a..8223ed29b343 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -369,6 +369,12 @@ struct ext4_io_submit {
>>  	(round_up((offset), i_blocksize(inode)) >> (inode)->i_blkbits)
>>  #define EXT4_LBLK_TO_B(inode, lblk) ((loff_t)(lblk) << (inode)->i_blkbits)
>>  
>> +/* Translate a block number to a page index */
>> +#define EXT4_LBLK_TO_P(inode, lblk)	(EXT4_LBLK_TO_B((inode), (lblk)) >> \
>> +					 PAGE_SHIFT)
>> +/* Translate a page index to a block number */
>> +#define EXT4_P_TO_LBLK(inode, pnum)	(((loff_t)(pnum) << PAGE_SHIFT) >> \
>> +					 (inode)->i_blkbits)
>>  /* Translate a block number to a cluster number */
>>  #define EXT4_B2C(sbi, blk)	((blk) >> (sbi)->s_cluster_bits)
>>  /* Translate a cluster number to a block number */
>> -- 
>> 2.46.1
>>


