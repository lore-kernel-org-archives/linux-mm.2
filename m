Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E37BCCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 14:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4AF08E005C; Mon,  3 Nov 2025 09:37:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A226F8E005A; Mon,  3 Nov 2025 09:37:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95EFD8E005C; Mon,  3 Nov 2025 09:37:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 887738E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:37:57 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08E0AC0198
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:37:57 +0000 (UTC)
X-FDA: 84069550194.27.A609174
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5755A10000B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:37:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WrwQlH8l;
	spf=pass (imf05.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=libaokun1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762180675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGGeoWjftywpXqd25cgi9W6Zo6I329qDMqJRqqnzkTY=;
	b=Y8/r89odu4MA8tdFXai8L1OEf/alsc9coa3qnv+HOQJrKCT2xMHbJcJuXe0C+ChYhG1ONe
	e9aWXfDk9X7uDVgP4mC7ktTQKgmjElFwPpr8odfkS/bgffxJ/6Hu6huwLklBU+8kq3QtTR
	9bjjs/QuSm6dMB2phESVPxNgsVa/Q/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762180675; a=rsa-sha256;
	cv=none;
	b=3qBa+Ahzj3dssgaCBphsZwiTcbZrlwc62XT2w8P7k9f/kkY1iSjEH3R9m3IHlKQBaYaXMI
	r7tbYMYoDYL7n6/RY1yHnsVliC0VtG/WwEaEOwOP/j769VPLLcWyXLRkgdze1p35MLVIEy
	IMYYLvBgEkwgNSu21k++e2KQso0i1Ck=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WrwQlH8l;
	spf=pass (imf05.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=libaokun1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=eGGeoWjftywpXqd25cgi9W6Zo6I329qDMqJRqqnzkTY=;
	b=WrwQlH8lSAQpoTyjNCrbB3iphcJzncWZfRlf74sQrgsPbwsTrLH2SgEbAsATlmSzSw6vT0jLM
	l2158lRS4FQrFSsxnYpnGG7I719b2wRMI8nvfXfV2sLuvkmks3qJsnNK2TTwyfCOrzgQu1nRYFD
	CR/FzoirvzJ1aIvIPQTLlAc=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4d0Yzy64WSzcb1J;
	Mon,  3 Nov 2025 22:36:14 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 3FB2E180064;
	Mon,  3 Nov 2025 22:37:48 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.254) by dggpemf500013.china.huawei.com
 (7.185.36.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 3 Nov
 2025 22:37:46 +0800
Message-ID: <70fd2f0e-8fac-4be7-9597-7072a36a58bc@huawei.com>
Date: Mon, 3 Nov 2025 22:37:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/25] ext4: support large block size in
 ext4_calculate_overhead()
To: Jan Kara <jack@suse.cz>
CC: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<linux-kernel@vger.kernel.org>, <kernel@pankajraghav.com>,
	<mcgrof@kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yi.zhang@huawei.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
	<libaokun1@huawei.com>, Baokun Li <libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-8-libaokun@huaweicloud.com>
 <qmsx753xemvacoaghwhv6emusazmlynv54qqxwsdfsoaoeqre4@bp2lgrdufaim>
Content-Language: en-GB
From: Baokun Li <libaokun1@huawei.com>
In-Reply-To: <qmsx753xemvacoaghwhv6emusazmlynv54qqxwsdfsoaoeqre4@bp2lgrdufaim>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.254]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500013.china.huawei.com (7.185.36.188)
X-Stat-Signature: ufbnmp86kfpnuzatwtf5bej49mqh36ip
X-Rspam-User: 
X-Rspamd-Queue-Id: 5755A10000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1762180672-177954
X-HE-Meta: U2FsdGVkX18ew+6NYwMdW8SE9DQv9NnMZ50kXp4yVdztJz6J/CwD02gpEsIVyDGxNBJVaMMuWX0drJIFEZjy1r9iPFiw1172TU7SNfCTFOAiANbTzbbmLvlrFhdwB7ikbacvuK12Sh8aUDT6r+502G3aDW4vkvk1eRmy1ZHzRu+ArT2sVJbwrqroR4/VqyermcxCPHMFL+5xJcZMJ2e2MQn/bnCTw5nZYNA10r83P/tU1/+6kcfDsREWUcGQPSSLNwqCYlb8wxd3oB/JDvm2zh0ZbDTnjshVaQVLUQ13YMEmMSHpdvn+ZbFIi/C3M1MmtzFj3Fezm5Y1lsg9CW0UnaPWwOZ9jqbL9hpu3Hn9o5uqxRzx+/jkU/WRMykxIMJVi8rlKzrB1PpaYOqKLI3prDpPZ3gTLCx/FNhvX9gy54dqonQO+KbB5SUxpXHL3TZ8Slw4JYJNQcRuiqRR/Ltuw/BEDCStfwBMLQH8QFxsaMP9fJaA5URf+J74xZJ/4XKhQ3Kq3yIVMiHtE78rMigIIFkH5YN+vJNKKZhVXoHnLZ/HlUee2mqMI13wg3HXfJBtfQ27jdh5KAFsKAsJIvfzWT7pDYXZS1dcyFq8iJjI1ArKHxPaAFKKs5k0RqqFrnwsacwos6TSAxD7J1mn5wrgeZ5oJU3ISfvetWzeHJsorqg2t08CU5VbFV4Z/kArKbfFZwXtRATkePrCFcyOnccJBQdGbZu0MI4h7sXVx1j7Dgn9UsRjxQfKbM9W2n4NHqWiac69Wec5OrgdBssQBzQXRsRa3oVw0Kti75h5ixTMusW0ttlSLTIfiF0VVVODFC6ARKzBvAVRl6jB+TycsDp+4vaIaHCmEB/ZR0eDQFjnCUj9/JmNM4UwUsitja5pt5MZ9BOtkruAD2SrbISBdXge17ZHr77B/318zOfRzXU0gbMIfXKISL/+a1BdAHM7VzUvrA+EwaFvInya/UUtx8q
 LsyORgqB
 rvbS0VBahO9j+w7cl67VYSvH9ctysYn85YgtzZ3kmEFX15K6d9DzOxBJUfOpmYgFs5fbJqSZu8ux4sFc/eUNc7MHWyVA8Nr9o1IzOXMzAR6TN7yowiIKzrhmk2501xQ/vXHAVPy1qRbyyX5oDuIaC50c0ybD1V20bGjW0z1bXQ57CCU2dhO7yTum2aOvJI9cb8SreULvB3MjZY70gUzIlxw6Zs9735KsUKSMhMZ5eA24Vl/xFKqMnzNdsnSOFmYFJ1yFzqtNkcL+oHk3Jx971Jzjseqxk5HfbjWkUbl/7WaqSGU2jO8xwF6g2vNDdQ8VdNk9mr9f6HLKf6IBi7WyKzl88ZUfVERIm/HYnvNYUS6fLqdgg+7odYQdzcmSkDxMlTjVVXl/n3T8ElcKZntK4PPRp7JpuMHXlD63j4opAj5THKwhiL0/ulpRdFeT2kji81362HXeNBrQE6xg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-03 16:14, Jan Kara wrote:
> On Sat 25-10-25 11:22:03, libaokun@huaweicloud.com wrote:
>> From: Baokun Li <libaokun1@huawei.com>
>>
>> ext4_calculate_overhead() used a single page for its bitmap buffer, which
>> worked fine when PAGE_SIZE >= block size. However, with block size greater
>> than page size (BS > PS) support, the bitmap can exceed a single page.
>>
>> To address this, we now use __get_free_pages() to allocate multiple pages,
>> sized to the block size, to properly support BS > PS.
>>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
>> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> One comment below:
>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index d353e25a5b92..7338c708ea1d 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -4182,7 +4182,8 @@ int ext4_calculate_overhead(struct super_block *sb)
>>  	unsigned int j_blocks, j_inum = le32_to_cpu(es->s_journal_inum);
>>  	ext4_group_t i, ngroups = ext4_get_groups_count(sb);
>>  	ext4_fsblk_t overhead = 0;
>> -	char *buf = (char *) get_zeroed_page(GFP_NOFS);
>> +	gfp_t gfp = GFP_NOFS | __GFP_ZERO;
>> +	char *buf = (char *)__get_free_pages(gfp, sbi->s_min_folio_order);
> I think this should be using kvmalloc(). There's no reason to require
> physically contiguous pages for this...
>
> 								Honza

Makes sense, I will use kvmalloc() in the next version.


Thanks,
Baokun


