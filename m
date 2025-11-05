Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A3B2CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 10:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72B188E000C; Wed,  5 Nov 2025 05:48:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DB0A8E0003; Wed,  5 Nov 2025 05:48:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A3648E000C; Wed,  5 Nov 2025 05:48:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 459B98E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 05:48:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DBDDCC0296
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:48:57 +0000 (UTC)
X-FDA: 84076230714.06.1D9C1A2
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id F41504000F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:48:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762339736; a=rsa-sha256;
	cv=none;
	b=Ol22LStLOrZ0bBPFRBYjDnFOIK2DoqGs7WI6ktC8s+jZ17KEA35ch4NzFB4VxwK/Ao65bO
	8pBVlF5iewQQqSBDoVF5fnQkp2hj/E0W3xaDhfj7I2OzybNKy6pppufOaMah/9xB8Uoboj
	wlRZNbeuSk/yyBMWX01UzY3XehgwdyI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762339736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f5IIblVSQX0g26nPoJg2gL6cEdz8oZGgNLd32BPYy78=;
	b=yi0I5Eq+AKtTk3j4ansC5DAoevDByOeXYCKOv96OuiVlCwzC8CAio7d03JRuYNiBmcnZMP
	KLIiDzNGGQfJUy2gxBq7p8HH+HAw6JLiI2LBgj/V7Egwu3fdDCDrJE5n7kO+IOGyrHKF8Q
	ylskltvlB5hRseV08CYjbUFuLT3eRdc=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d1hrC5mYTzYQvhj
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:48:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 61F621A1755
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:48:44 +0800 (CST)
Received: from [10.174.178.152] (unknown [10.174.178.152])
	by APP2 (Coremail) with SMTP id Syh0CgBnCEGJKwtpT+YjCw--.1462S3;
	Wed, 05 Nov 2025 18:48:43 +0800 (CST)
Message-ID: <8041da1f-2ea6-4c66-8042-81076f5fc9d3@huaweicloud.com>
Date: Wed, 5 Nov 2025 18:48:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/25] ext4: make online defragmentation support large
 block size
To: Jan Kara <jack@suse.cz>, libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 linux-kernel@vger.kernel.org, kernel@pankajraghav.com, mcgrof@kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, yangerkun@huawei.com,
 chengzhihao1@huawei.com, libaokun1@huawei.com
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-22-libaokun@huaweicloud.com>
 <vkbarfyd6ozrrljhvwhmy2cq23mby6mxl2kxlsxp2wqgmvxvgi@6sgmqhhdnmru>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <vkbarfyd6ozrrljhvwhmy2cq23mby6mxl2kxlsxp2wqgmvxvgi@6sgmqhhdnmru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgBnCEGJKwtpT+YjCw--.1462S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAw4fWF4kKF4fWrW8KF15Arb_yoW5XryDpF
	WxAr15Kws8W3W0grsrXFsrZr1rK3W7CF4UXrW8W34fXFyjy3sIgFn7A3W5uFyj9rWxCry0
	vF42yrnrWay5J3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F41504000F
X-Stat-Signature: cotswbrjrgxwhdudznutbcnb564p5fyi
X-HE-Tag: 1762339732-652864
X-HE-Meta: U2FsdGVkX18QdT7TKTcWJWgVFK+KLE4Ssb5a7HCF2VtWqq5zd8EKCg8MEc+K8wWdLupFXoS2gIYQV6TtQDRx3/xv62vn7pz3oT12B+OUFS0CCmAFAU2Z9HZwUMA8g/v+lKvNy3pktLf2A0QZgugNYHCo2VJyXzKIsULN4uy0RvAi6jxnNa0ei24l5QG3hDQcYQ5KB1u3v9jZZLBQDZTewknVyMQehlMBERfC9110aNHj8OVGPJJPGhGSKSX9/j2hqGfnlzRDmiJj4xWHzPI0NqVIEtJclry1sAi1E7IbxCZwmnhg6YEBkNrZ5GP9YN2BHKDK1iCQt5usEndEaGjl8V9pqs5//2ej+IkMx6e1bK131PNN6eIhHtZJfn3r47oHJDalFcHDbSK790UIei2kGqsMcYCmhqePGSpbADZMjG89+6VPXuLKZ4Y/vtBC9ktXmz92bsc1bW+iL0Tvol1lHgHEOaxXqA9AVQ40BKKZQAx80kgRY2vQCW7F3lXyJW5gbvdZqPQZz9kDZUEeT/JjPD2lSbP+z2YiC7o8Wo8Mu27fEwt/f6tj4ZRnokUFqkwSAQFCRX+dKQZ0TNUfG0GGg7jVQP/4S+t8jpSRHS+zfcuj/UinJiVHjTp8Of3y+rpmzEP12lIZCqq7u3F+d52yFRNfCIQOqbI9K9do+dt4ki/6P3Betc6pmOwEsRCfIn5wwUDujPJtuSfzQOmykimoKJHk7T6V02zfvO17pPEnKMThdkMAIaR98UyF25SE9aPgwwNcFgQo4J6xzgrBsnyWy7AjdQzHAgaq194uzV2zSBpBXaaP7ZOHviTf9h8KbYbvMNmPerRUHqj7VEpMBkorB+ZiOuZ/wIa7JTlWyLAou0dtIHv3jwvDjaV6xb3cBXrmkUoHILkLmiFGS7ocFkGvkheb6rDVdqaB3aAhSQAqg5VPn+TCtRlkBTYPioEGgLkp90pGaPIDYibAaSKKnBU
 sJJvdagv
 ga7dimkG0b06buE0yavhtNI6Zo0cma7xNryoKo32NPeC/OBUWN6T9x4Jxj9zBrpS7YPZR03B1L7zEoCwmoDqYUfyY0D+6TlWp3IYfs/r6Gl0odp/GwG+gNElk/95v3Znrs+Hm7cSkQqdnyJqfZHCf8G7XGGdREa4IDzy6vTKWO68b6qSKhaJ4KugFTPOmQnnKKZd8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/5/2025 5:50 PM, Jan Kara wrote:
> On Sat 25-10-25 11:22:17, libaokun@huaweicloud.com wrote:
>> From: Zhihao Cheng <chengzhihao1@huawei.com>
>>
>> There are several places assuming that block size <= PAGE_SIZE, modify
>> them to support large block size (bs > ps).
>>
>> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> 
> ...
> 
>> @@ -565,7 +564,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
>>  	struct inode *orig_inode = file_inode(o_filp);
>>  	struct inode *donor_inode = file_inode(d_filp);
>>  	struct ext4_ext_path *path = NULL;
>> -	int blocks_per_page = PAGE_SIZE >> orig_inode->i_blkbits;
>> +	int blocks_per_page = 1;
>>  	ext4_lblk_t o_end, o_start = orig_blk;
>>  	ext4_lblk_t d_start = donor_blk;
>>  	int ret;
>> @@ -608,6 +607,9 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
>>  		return -EOPNOTSUPP;
>>  	}
>>  
>> +	if (i_blocksize(orig_inode) < PAGE_SIZE)
>> +		blocks_per_page = PAGE_SIZE >> orig_inode->i_blkbits;
>> +
> 
> I think these are strange and the only reason for this is that
> ext4_move_extents() tries to make life easier to move_extent_per_page() and
> that doesn't really work with larger folios anymore. I think
> ext4_move_extents() just shouldn't care about pages / folios at all and
> pass 'cur_len' as the length to the end of extent / moved range and
> move_extent_per_page() will trim the length based on the folios it has got.
> 
> Also then we can rename some of the variables and functions from 'page' to
> 'folio'.
> 
> 								Honza

Hi, Jan!

Thank you for the suggestion. However, after merging my online defragmentation
optimization series[1], we don't need this patch at all. Baokun will rebase it
onto my series in the next iteration.

[1] https://lore.kernel.org/linux-ext4/20251013015128.499308-1-yi.zhang@huaweicloud.com/

Thanks,
Yi.

> 
>>  	/* Protect orig and donor inodes against a truncate */
>>  	lock_two_nondirectories(orig_inode, donor_inode);
>>  
>> @@ -665,10 +667,8 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
>>  		if (o_end - o_start < cur_len)
>>  			cur_len = o_end - o_start;
>>  
>> -		orig_page_index = o_start >> (PAGE_SHIFT -
>> -					       orig_inode->i_blkbits);
>> -		donor_page_index = d_start >> (PAGE_SHIFT -
>> -					       donor_inode->i_blkbits);
>> +		orig_page_index = EXT4_LBLK_TO_P(orig_inode, o_start);
>> +		donor_page_index = EXT4_LBLK_TO_P(donor_inode, d_start);
>>  		offset_in_page = o_start % blocks_per_page;
>>  		if (cur_len > blocks_per_page - offset_in_page)
>>  			cur_len = blocks_per_page - offset_in_page;
>> -- 
>> 2.46.1
>>


