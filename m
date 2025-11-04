Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D1F8CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 06:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4558B8E00EF; Tue,  4 Nov 2025 01:55:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406848E00E7; Tue,  4 Nov 2025 01:55:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31CE28E00EF; Tue,  4 Nov 2025 01:55:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20A5E8E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:55:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C0CD81403D8
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:55:51 +0000 (UTC)
X-FDA: 84072014502.10.1547012
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf22.hostedemail.com (Postfix) with ESMTP id C4EEFC0005
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:55:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4yyPL4xi;
	spf=pass (imf22.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=libaokun1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762239350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MY0q0WzHzhej6e9lThaMmg4zC+Z3TXTsGd/cLJf2rak=;
	b=x2ieFX30VDue+MoP8ogBlZA5aRWf3wAeR+l02E5OQYxINOpRGE7VfuwyGQQKaPXfdzLbtR
	JT1SVpnMMW0VRXFGsR1iSeh5MUvIBKnJk7XUOJ2C+dwS94vTXu4E11iOIKJk/STYFxZQdh
	h9lo2cQIXoFebFG9hlpyMjvGhU+MUnQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4yyPL4xi;
	spf=pass (imf22.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=libaokun1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762239350; a=rsa-sha256;
	cv=none;
	b=Dg6HvxRzk9FunAjNvL+fI3NUBV0rfNw2sG25MXuE5q1w5VPECzCXLPi5ti9nVFC4ZVn6i4
	hNOMTwoUr0Md4iWcPzghe9tGC4hcWPPkAX1t532TMut3p3hRdA278TRG0NdbwZVQ5/4VsG
	CR7fn9jXCuigfLms09yzWdp9kogHK4c=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MY0q0WzHzhej6e9lThaMmg4zC+Z3TXTsGd/cLJf2rak=;
	b=4yyPL4xi/ls053nVqnalitPx7VgIaq/rBG8XJASRMmS2b7Cw10ZVBz3UkPwm66Plu5391QSC+
	B0jFPLdUO7Z7GOvz5NuNCAUSmOSxAAa445EKsEB8lrd0G8Bt+WHoGqs3fMeYu4GLF2IJCuNJR5/
	g2l0nI5e6JspjfsegSUCtOQ=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4d0zhN3DzczpStT;
	Tue,  4 Nov 2025 14:54:12 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 41CCF140EE4;
	Tue,  4 Nov 2025 14:55:41 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.254) by dggpemf500013.china.huawei.com
 (7.185.36.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 4 Nov
 2025 14:55:39 +0800
Message-ID: <4eb369fa-b03c-4883-8e01-2233dac81044@huawei.com>
Date: Tue, 4 Nov 2025 14:55:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/25] ext4: make ext4_punch_hole() support large block
 size
To: Jan Kara <jack@suse.cz>
CC: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<linux-kernel@vger.kernel.org>, <kernel@pankajraghav.com>,
	<mcgrof@kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yi.zhang@huawei.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
	<libaokun1@huawei.com>, Baokun Li <libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-5-libaokun@huaweicloud.com>
 <v55t7ujgvjf2wfrlbyiva4zuu6xv5pjl7lac5ykgzvgrgluipc@moyoiqdnyinl>
Content-Language: en-GB
From: Baokun Li <libaokun1@huawei.com>
In-Reply-To: <v55t7ujgvjf2wfrlbyiva4zuu6xv5pjl7lac5ykgzvgrgluipc@moyoiqdnyinl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.254]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500013.china.huawei.com (7.185.36.188)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C4EEFC0005
X-Stat-Signature: t9r8rawch99u3j8e9hq4ze53czsm5cnt
X-Rspam-User: 
X-HE-Tag: 1762239347-445606
X-HE-Meta: U2FsdGVkX1/6M54QyB/C3Eryet79fyo0KxhmVeryGzj1pQfEjWGE7tF6p/sofSw98Lt/dthzZkdLWJEbykHTz6fA7OLbP22nD3/guqAsStO23u6P3Xwgzt5Fb0PtDPB29GfD9tltgtuQcKHMsuR/0KU16sBPgfW2OHZFEVMJkypyXXjV1OL8dGtXyh3fECl8EAQ5rf1EPnm+ztY1BqME/au50ScUlKx19QD9ffWGm2zRleZN6XctHNg0welZPJHE39G76tKBi9cvRgn43EDTPh4SuFRhPCvGLNT2yE6eoki2O2vcbYBtUwbZLcnijqh7mKl2mIw+ZtHSWdwW5Q7fpH5dA9ytD/3ZaIwP8pBP5xllNJsqxeGtpv7aE4Vm04m+CGGCVImrILj6xxC/OhGVOtUHch+jHBdWNopOZ9wj0/54aosA7b2+JCzqKeMRg3Z3Q5qbYcIN0WfIDtTnzSKfq3UWFpSbihmsLVoKRTGIkrXJm6cQ+gusVnneUEmUyN46KaWk280Djp4VlL14QkQMVPwJpB6KfpeUAH5Vo9xApakpwRK+RhJTNxBiQsyeNcN5LOQ+6DDVUfB/38gIzjSxQH+oz2CXkwxSbRtngrO1JA4zPj9cWwd1kOxeyN8sUjj3q4/75Sj1FmdOwDAAKE4JSvItHKmTo447ZgDdKH5ZtjNyY4Egiofn5etxuZU0/5jlnqtzMGRc8a358VzQ3aFAsQhFZw1v3CJHvQViuY7K6DBprOMXUV/lLytyvV05QAboRLwEWk/5aqtc04rdLW2z7HT65xFAzyP69J1vZMISmhFenKbXDcVnqH0A9VJVauf7U9s3nMdsJ05M6glBSfJx6OVBxF8TIu5RjbZTL1UO084Hdq/gn/YBfESn2DO0G4nx4dbeh/7fezQktlAetNX7LbcRYYXhxCe1JumQIY0vvJLSO5sGPi6McrNoW0Ckf1e5iUuYx4rtvTg5FyvJf+V
 LYIX+t/6
 AaJJ3crg1lGpjEt9AMZuFOua2GhDVJsfapPLl/CwnQ48exSsQiuXymyXY7s29G8nAWAlXqgxAwgFyopwfg/miniYrlaheSFGjcezja2NpZRoXa3+4Op9DcK8K77nn8VRj8LmpznnbU6CxCqULh/nrq2Me2sNThZ5EnVz8GqDV9ijqSYqxJ8ReLl25Lysifo+qF88crxyx1bkGyKL8DOgPcc3mFMzpULNVYOsRSbnvfXtM1zZnyx/74EwQoxJjPrBFs8h1e2orLeAAFyxg0JBTFWHvJ90u6MAJAorbWj+usQOVA1GWkH0XjX1/xgzFsTVEeI0D0oUhqwy7j4uuZntrqWPir1xad02hDJ3+ly0GznzhFh5ZCqXxHXH6WioBNYg+1h7tBq/09rKlacBnlz+rBYh1T8NaYeyY2L8Gu8sVmw856KalP7XTP0An7rkBjODQlHwC02Bml0uExlE5pFRSAMu4DEhdzqyxoduEDULp4LNHOQo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-03 16:05, Jan Kara wrote:
> On Sat 25-10-25 11:22:00, libaokun@huaweicloud.com wrote:
>> From: Baokun Li <libaokun1@huawei.com>
>>
>> Since the block size may be greater than the page size, when a hole
>> extends beyond i_size, we need to align the hole's end upwards to the
>> larger of PAGE_SIZE and blocksize.
>>
>> This is to prevent the issues seen in commit 2be4751b21ae ("ext4: fix
>> 2nd xfstests 127 punch hole failure") from reappearing after BS > PS
>> is supported.
>>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
>> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> When going for bs > ps support, I'm very suspicious of any code that keeps
> using PAGE_SIZE because it doesn't make too much sense anymore. Usually that
> should be either appropriate folio size or something like that. For example
> in this case if we indeed rely on freeing some buffers then with 4k block
> size in an order-2 folio things would be already broken.
>
> As far as I'm checking truncate_inode_pages_range() already handles partial
> folio invalidation fine so I think we should just use blocksize in the
> rounding (to save pointless tail block zeroing) and be done with it.

Right. I missed that truncate_inode_pages_range already handles this.

I will directly use the blocksize in v2.

Thank you for your review!

>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 4c04af7e51c9..a63513a3db53 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4401,7 +4401,8 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>>  	 * the page that contains i_size.
>>  	 */
>>  	if (end > inode->i_size)
> BTW I think here we should have >= (not your fault but we can fix it when
> changing the code).

Yes, I didn’t notice this bug. I will fix it together in v2.


Cheers,
Baokun

>
>> -		end = round_up(inode->i_size, PAGE_SIZE);
>> +		end = round_up(inode->i_size,
>> +			       umax(PAGE_SIZE, sb->s_blocksize));
>>  	if (end > max_end)
>>  		end = max_end;
>>  	length = end - offset;
> 								Honza

