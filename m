Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF314CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 11:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D6F08E000B; Wed,  5 Nov 2025 06:28:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386F08E0003; Wed,  5 Nov 2025 06:28:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2763B8E000B; Wed,  5 Nov 2025 06:28:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 12D248E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:28:11 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C512F1602DA
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:28:10 +0000 (UTC)
X-FDA: 84076329540.11.64D2BEE
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2ABEB1C0012
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:28:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GCfExblq;
	spf=pass (imf20.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=libaokun1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762342089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SkZh9i1Zfd/xokAhDMNj3UEulbb0AiWAB3EnRI9sUYA=;
	b=KFs6y8bFSXXmaCl9EwQS9G5/34rWaeBfak4eBwCIRFSWtnVXMCV7NaY7XqujvwTVEgjeb/
	PAqhR0rxC5lGI4AOaCJB0qQ6CSjnHh+1bU4qEmmTD130e1DjILI/VenEvSZlVSNCzwH1rM
	821t9LYzB0JxJ34ZuLa8rwsk7GugVgc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762342089; a=rsa-sha256;
	cv=none;
	b=CORRbBWjF2SggTbVJMZJ7PW+m1HRtgxZyKbLaYZUHGwvWjRerQ4+eVoFSewcx+vfFL5Mlj
	9UxpDFolUUzt5Cw+HnYEn2hkbkM8tIPl2vbQk8EtQCkSfqOMrIJUuKyBuVOJTOv9Tc7RTF
	sV7nmi6rI8C9d74DT4OtN0ZUQBNW34Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GCfExblq;
	spf=pass (imf20.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=libaokun1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SkZh9i1Zfd/xokAhDMNj3UEulbb0AiWAB3EnRI9sUYA=;
	b=GCfExblq2jRclquDnThI5trTH0weauEHZb90UtA93ev+Gnzmd6/deHREjW7lXJMXrjid1t7/I
	N9pFy1xaIwGfgtNCFCHDle105TULT54fq4fvsf3vgTHxPu7FR6AGboixBcZKxT5nBqNqh9cHEm+
	cUGFLsBYIKCri3FBSfnWJHI=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4d1jh26ldtz12LCs;
	Wed,  5 Nov 2025 19:26:26 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 695A918006C;
	Wed,  5 Nov 2025 19:28:02 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.254) by dggpemf500013.china.huawei.com
 (7.185.36.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 5 Nov
 2025 19:28:01 +0800
Message-ID: <adbcac4d-e1fc-47a0-ad36-4672ff3c71f5@huawei.com>
Date: Wed, 5 Nov 2025 19:28:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/25] ext4: make online defragmentation support large
 block size
Content-Language: en-GB
To: Jan Kara <jack@suse.cz>
CC: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<linux-kernel@vger.kernel.org>, <kernel@pankajraghav.com>,
	<mcgrof@kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yi.zhang@huawei.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
	<libaokun1@huawei.com>, Baokun Li <libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-22-libaokun@huaweicloud.com>
 <vkbarfyd6ozrrljhvwhmy2cq23mby6mxl2kxlsxp2wqgmvxvgi@6sgmqhhdnmru>
From: Baokun Li <libaokun1@huawei.com>
In-Reply-To: <vkbarfyd6ozrrljhvwhmy2cq23mby6mxl2kxlsxp2wqgmvxvgi@6sgmqhhdnmru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.254]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500013.china.huawei.com (7.185.36.188)
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2ABEB1C0012
X-Stat-Signature: 7irzx1a51qco9cqseqabariefia8owwm
X-HE-Tag: 1762342086-912090
X-HE-Meta: U2FsdGVkX18Uk4x6qTqfFTFyj9Z4u/FV7onLqePBgJjjgpgLpY+xGcQTQ4vRaXxTJf0neT2+p6my4BqSUUx2TIpwoibcwgdyaa5fEKBI+4DPPcZF0oSJwOp/dsZf9JD87ApLzMcMfdqEDsRw5ToQbKvzuyrhkajPAhpwHQipX+S/qpWNtjfQwaUg6+YA1IAXjRVVrGfdIFnKOLfwo7ZQ4/Q7feviYG2Kd/s5sgmPzPDvXAcqqfvuLXZ7I4qjhvl5nezembv+NCECtwGwCuXHAYvv2/0lVEosGO6lSa9BeqO5QA3SDlbu6dR3cEXC4wZpRyqXFYF4Tr2KOtKqBTHzG6vLZD2Uk9eIEzbgKqdjEsyUn+TwvfvsPRZcQPSIZTkj1fwmVuNcuBM4aPQv4QbGLKqg84N7Yoa5d+33v8zyNjeYSCTIO8fTyEbqLA+ktnQAktbYsmFLvTEVQXycWwil/MKyGzrl8gFFSJfFLT7SMqypODHKcw8dvFFn6sNs5f3s9n/PBz2pzNAe4pamVU9/BMyYfQ5CH2EWoKHxKdSK9G6o5F9cBWfOMWizYCgIkG1+Yhg8gj1JnAMl0AtY1PvlavCLwmB9Dhs9tGjFeMc4UJU420i2jxtmYGPNHy+4WJ+lIgFRlWXoqLLhVcv75rD9oyuuUAmhizcqMPw/EtgEuFZJDIJirRsMpgYTSJOgzNfkZe1j9UQ2JCkDyA8AgBJQEd4OK7ooGEzzDSnq2nsyXyvAnBrDtZugzcgcKye/ZlxNNZWX2BzP63IgkG4F4xlwcBNyyJiAFa6cyW2Kp7CkZIfP/Yq/haDXSMss/V3RpTZnlix+pQiH/5tzeE81Q72vgHL8i92J91wiyV1y09dJg9u5EPLnPE43k/O+D6obkuIG2TQGJi4T9L79f/d6HrIJ+3HRpgOBwi2ZNwDZPDIXR+hZCf8co7G5V3b2MtkHL6QEe5xTkSHv27PoqSjXYAl
 K+fc9L+H
 gI8q26Ml57D6OSjhXu053xaLVLxqLFb+/fZNADNdnQ6kOo2ujKeGfrBCpLR5kdwrTsQxOO8o5lCGhs87E8wifxmXh7iQQ/07VztiZFc4bB8WZuDd14rEGRkV5Rkolf4ztYsBzSnrHBNM9W+9vJTQhD/8V9XjB+fQ7N0seDZImJFKOLE3KlHfFPc6AhOrGb5a4cbMwmA5U0jhJJk95jI3TbJh36dKfmWVTj5HMpJg1Ilq7Sx+IvERceQ2OIvLQ41/+lnauK1HtuMFSLL34P2p+cQd81tMm45p+ojg7goOCPZsD447E/ewt5XQilij/FVGP1G7vpGOlKgVNlW/tLufkaXzXQjeOaLBRtnHY34+hptU9vtT6k6J1psJf9T8zRSvkXmZ6MyUvXXe5JNz06C0+olJ/oiw8n8HfBCG+IQaNTlFb1U5n+KsRwMakwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-05 17:50, Jan Kara wrote:
> On Sat 25-10-25 11:22:17, libaokun@huaweicloud.com wrote:
>> From: Zhihao Cheng <chengzhihao1@huawei.com>
>>
>> There are several places assuming that block size <= PAGE_SIZE, modify
>> them to support large block size (bs > ps).
>>
>> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
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
> I think these are strange and the only reason for this is that
> ext4_move_extents() tries to make life easier to move_extent_per_page() and
> that doesn't really work with larger folios anymore. I think
> ext4_move_extents() just shouldn't care about pages / folios at all and
> pass 'cur_len' as the length to the end of extent / moved range and
> move_extent_per_page() will trim the length based on the folios it has got.
>
> Also then we can rename some of the variables and functions from 'page' to
> 'folio'.

Yes, the code here doesn’t really support folios. YI mentioned earlier
that he would make online defragmentation support large folios. So in
this patch I only avoided shifting negative values, without doing a
deeper conversion.

YI’s conversion work looks nearly complete, so in the next version I will
rebase on top of his patches. Since his patch already removes the
function modified here, the next version will likely drop this patch or
adapt it accordingly.

Thanks for your review!


Cheers,
Baokun

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


