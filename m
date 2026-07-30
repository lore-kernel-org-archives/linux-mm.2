Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 717BAC55167
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 20:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879966B0096; Thu, 30 Jul 2026 16:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC7F6B0098; Thu, 30 Jul 2026 16:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D346B0099; Thu, 30 Jul 2026 16:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40ED16B0096
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:39:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB52814029C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:39:09 +0000 (UTC)
X-FDA: 85046607618.16.5FDD3B6
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0F45914000F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:39:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=WQ7HnPHx;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785443947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T8e8k+5EzrTp13lWK2mQytn9hp17i2RRCkab9M9He5A=;
	b=vu85si+4wBmaDCw2Oj8a/YNQ+qGq+ZGKnIa59miild/X0DlLHSk6pd5f9ENKHF5pB8y/Id
	wq8mmc8ZC3YPoZA14BgdeaHfZ2stI5GG8D0nfy3q5PdDSsrvUT+gCCwJr2f9ORGiXJ3FA/
	ZVZXTv5MdHh9AI1ZOYCqjyrJPEGcQ1k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=WQ7HnPHx;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785443947;
	b=dx+/oWWDz5isXZ7S5XRvpBo2yqe2LipG/VldG7DmDwY04RdAAxM5RstDP3twZkgxXDVRfF
	uF5e/hcC6Qfl70NXvcOQR3gle0tgxiP9546ufmGz1uAPEf+jgShR3Z5vHXfr/zr+VTKxAX
	1qpRwGKHFO6NuWgeehQzKR0ZKjtdC18=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UKXwgY4069686
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:39:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=T8e8
	k+5EzrTp13lWK2mQytn9hp17i2RRCkab9M9He5A=; b=WQ7HnPHxqZL+jR81XllF
	JTKnzPju6U39UyyWhhTcphUfZ+xAg2wqUa791ebQ1v5NhvW0IuF//dLqtiOJvHMi
	fmyKW7M+TGXkdSy8yhCZpU5HL/IpFm8hExjB6Zd8ZTnCZBp0FfiM/4VmQMN3Nyjj
	wy9qKWJdLe5TFEiS34dauGmL0aNhbdETHjmjDl6ehafIPC0BA5I6nCfjcLjVALJk
	9EAViui9QVuK3SVhaPP15FKa4Vxbk1NUe/8NEuykcAZ7ZyTVvPKKcmrPB5R0nGP7
	1xqHFPEmX+ojBlGjFW+JqGfOPxg4M0VGW9uE0F4ziDhKljsql7UvZhC9GapkEQy5
	vw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4frbrr9199-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:39:05 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-520a00c7a03so3518261cf.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785443945; x=1786048745;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T8e8k+5EzrTp13lWK2mQytn9hp17i2RRCkab9M9He5A=;
        b=jiWb8bHULV3RL5om4sCsw3TvLQjg9clRyT4bsyviHhpuUEBR7kaHHClaJ43nRB+LYu
         TcgqbpD9sk0BUgJKwR7pX4McYLbHM05XsK7+NWkq0J8NGe8ZX2QHlyCh9wM2+i+SUJX5
         alB8m3rJU6vtbYGRqXNC8YIxAazCmXbTw1okqW8OQ5Wt5D1pHrHA9Y1q/D3vkSzoYYSI
         aqBmwa3TW9L591GQHCE0Q1SCDRjlsgR5+9tfqwhjAPKxxhsLLhoZFZV4eCGgtCYB5Hnu
         9qse35iyUY3aTZWqk3yNsxfBOhtnlIYY5woH5PO0yj2FaUxRlZJXqxJ5OTE9fhkklCDz
         Izcg==
X-Forwarded-Encrypted: i=1; AHgh+Rrrz5vEbWqyTxTeaOXnqlGKeaCVpu+hyaH4kWh8B7qFy+IL6Rk6iF8kP+jBIDvFxgWIPkWJ0Hn1ZA==@kvack.org
X-Gm-Message-State: AOJu0Yzn+kPhsdfIhNSLlPc24+owWRyBJ/D/scE7kzb7C/j+Wtg+DdRy
	9zt6/y4HAccJBeF3x7vNqiRuxOilbNE2DDx3KjwixhWJI9r+2SEDdFshxsAn0zn73HIF3j+ECSS
	BJH+voKox7HZ56t2B1vG2V4+kIVLIbF1TxJ1FtIPwqS24aOh7
X-Gm-Gg: AR+sD13bqz7QpoFeayODADE0OMoV0E8YEtPxs2bvU2x7NYuOek8oo+pGhXyN9Dr1pd8
	jVSGenLRigW7D65jgq8g5G0HpVfTDkXEd6d0VFqGkZ968PtugO/493GfExIA5Udwz58cGNQad7C
	Idt6nIXndMxvDREhlUPkxgTbnbFcNC1ivXC2J54RtxlnzqOpeBJyZo2zQM/g/v6vJmMyIg8KsDN
	58eh0G236drJVmp77kxN5rAkv1yohyk0eXDaBE9FwVeMrcdxq0AfIU+0q+fGq1sgH2+Ig6xkirD
	udy8PhMkT91geZI9nLN/f1/LhVcfnhc6YsSveaRR3ptVYIic2EXhcsH8Apuqo9LOap0KdrwvlYS
	WbpN0RgavA7GYiGY=
X-Received: by 2002:a05:622a:3d0:b0:51c:7b11:41a9 with SMTP id d75a77b69052e-52b38757e60mr44335351cf.86.1785443945514;
        Thu, 30 Jul 2026 13:39:05 -0700 (PDT)
X-Received: by 2002:a05:622a:3d0:b0:51c:7b11:41a9 with SMTP id d75a77b69052e-52b38757e60mr44335011cf.86.1785443945082;
        Thu, 30 Jul 2026 13:39:05 -0700 (PDT)
Received: from [10.206.71.35] ([129.236.231.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529e2d8251asm48127221cf.19.2026.07.30.13.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 13:39:04 -0700 (PDT)
Message-ID: <15506dc8-e5b8-4fa8-a85f-912a92edb83f@columbia.edu>
Date: Thu, 30 Jul 2026 16:39:03 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/5] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
        Christoph Hellwig <hch@lst.de>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
 <amsHrVCJnuXzeGG1@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <amsHrVCJnuXzeGG1@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: a-SEk2EkX8kD9vLhMqyPIhTCCBVGA1kD
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDE0OSBTYWx0ZWRfXxHP/gg9jE59c
 FPXI5wy7h96N2uajUFOVatw7YxJO86GLZ0HhL13/BIPt7KR/aolQLlxs9zbZuTISdngfg8E0hOR
 5HXUtPYuk5sieEHn9thKFL7gm5kVsvMoIPQ6ebzIXcvONxa4XbJJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDE0OSBTYWx0ZWRfX9/7EgaeBrmYI
 A4/AUZ7IFWv8+tGo20vX0p/885zvX/HvEOgd+gfilzpuIGldFSnSfVMUWe3pT+JSDYKicNPfhiN
 vTxSgmbW57HKOYFyuuKZY2aVFuB0LtJWqObtheX32vspc/DGFi1P8GKAz7F/skIpfqfp8ZCIlox
 P0HSOD9GZs9WT1m7ef3Poei7U+TZ/GsQGkSLuYR3Uf4crgW+bYB7LsXOECB2ab2Urrufao/Iwtb
 eIQTtWudcJEGQJG1qoqroMTQ2b3/bHV+U24dcdqZBXTg+ytzQD0Tg9aTrROfMig4WKhcYLTau+G
 vl2dFR1HnBqgLpYjPgJwlGrY6s3Hip2NTQlxkIH+U3UV1/haEE1WcV+Wlwt+QPO7EzpgpznnTKD
 WjFUEy42xkxOVr2kPzzzpDLzrhAod1J6EPdf0e3QR5BRMKCtQG3XTTyd/k7Dog67BfU4bU1277I
 CRtHNtqF6e4PBDxEF3A==
X-Authority-Analysis: v=2.4 cv=ZIjnX37b c=1 sm=1 tr=0 ts=6a6bb66a cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=Mx06nvryMUGB95QVe9e23A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=qsXxR-sLYAu0WPx4Yu8A:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: a-SEk2EkX8kD9vLhMqyPIhTCCBVGA1kD
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11860
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 impostorscore=10 adultscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=10 bulkscore=10
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300149
X-Rspamd-Queue-Id: 0F45914000F
X-Rspam-User: 
X-Stat-Signature: r68b45nj8kccaimbzzdkfgo51xprdcs5
X-Rspamd-Server: rspam04
X-HE-Tag: 1785443946-61478
X-HE-Meta: U2FsdGVkX18vpWTW+W4RA19GwRO6OXOBesWVsnBhAoayeQZ14W7/Z9zDM7VSaZGaPg9p5FZx/E+ZNmRN3HjG9yUoxoK3f+gtHY7snfO3ONaFDMOIVzpk8nDxggf3R+K9TCMlbE3j6DGB9n7g2GJs7BKDOUbdf+o0I1MpfMuia2M3SQgimFg6/M1ebSUVQ8Zy3HSlSonD56d0SCDJEZ8N1hM/jzhsofVhbkczrrLBxHKBnjJ3ENEXwSAR2jlGGWwNnEyjTOdmxJ29OqVWSSvTZirVaXmD5uMaCK90e4XxPrY5kBSKOoc8o2muFyHaNGZ425GBDY/q0Oux/9weW+Q37ABrPTUIOTPJPgM8BBdtgJ/euzux2xoLFfwPKLUohjWQe/nSfCaKsFJenzh3eFVJGKT+HlvlVmdzm5L7brIIC8XS4TDDGQBP7Is2+S2RGzWFSYezmCVQFzMCrWwVDCExafZepo+rDiYTRB/N8+BDKEW0oALyoPrESCYiNqNzC4hPP70HqazxvFSRLtsEMDN9lqJ96S0Hxp47y7XXY9OOQHdJeDt9e4TyGb0nLEKAPJkPxeU12h+8CCCc4f4yaj6VlOf+dpsqwzahbcd8zRy6VKlVGvxgXT4IVysVtAYnJsD10g/K78RyXD6PtXc0xLtFDC3e4q4kBwBrlFRNdkTCz/edPrUyiyQjEKapbgaXdZu8gQkFDl83JugqQjQsiv8KJOYHrwCjYv06pvunLOqMxDKPrHqBoP0FT43qC+HYvD9sr+6WmhWsLgtr1OOHzRUD9LaTnrLqHTkAmKUjizhw10KB+ZJv3yulkeYKJprZx9cL17C9Q6buMOAqzAF9wN3+DihE8gnzpCcAQzNV4WhszxhudBmA9wq9KCuTwZrdnPaDF84VovlhOAicTCp4jzPgItRCqHeBrqFUpyh0GFK3geh9hXe4/AIYhDmehhJn7t8Eosqz0i3b4xASUAITOcz
 CG2BlAmj
 aUBMhxeb5q9u6ZOdwXvdc1AkQDNQMOuAN7naks/k1rf8NsPDYG+aM1U0EoD2FiBvxHw7fYlhbm3wGMyCGOx0VF2Sq/DmxHYCmJIZ1mKhv0H6sFUDPb9YGB2fTrlrD9UJQBi93CVU2Jg+Dg4zKxiDGZqEKr5cOcXszNnL4VeQ7i3uIfEVnkdVBmiQVq98QcLs/Su5uQ9biwESrr+VcfkIcPH2Em0UrROwbt3nvZgA9GmGjr6IkADJXAn/YPFbSwIOjbtq8/IpG89Ur+rTYgdnEUKLmbeY+z8+7lZMLC5OvKfJR3z5wE2WrrH44h1j55jidoPG6QzjxIaYb9NCvzrOtLwffk/UlSvEscoGF1pWv5xIxks1OiVqnmjTmTMfD1+iDqLx26gA2GHKkSC1moPlFSZYfCr4EfTelgbuSn6De0DnvsnJiQuquMmdhRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 4:13 AM, Christoph Hellwig wrote:
> On Thu, Jul 30, 2026 at 02:57:53AM -0400, Tal Zussman wrote:
>> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when a dropbehind folio
>> is added. This ensures that bi_end_io runs in task context, where
>> folio_end_dropbehind() can safely invalidate folios.
>> 
>> With the bio layer now handling task-context deferral generically,
>> IOMAP_IOEND_DONTCACHE is no longer needed, as XFS no longer needs to
>> route DONTCACHE ioends through its completion workqueue. Remove the flag
>> and its NOMERGE entry.
>> 
>> Without the NOMERGE, regular I/Os that get merged with a dropbehind
>> folio will also have their completion deferred to task context.
>> 
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> This seems to be missing the bug fix you identified for the double
> deferral?

Sorry, I misunderstood and assumed you'd take care of it in a follow-up.
I'll adjust it as below and send v8.

> I although thought a bit how that could be done cleaner, see below:
> 
>>  		ioend_flags |= IOMAP_IOEND_SHARED;
>> -	if (folio_test_dropbehind(folio))
>> -		ioend_flags |= IOMAP_IOEND_DONTCACHE;
> 
> I'd keep this flag.
> 
>>  	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
>>  		ioend_flags |= IOMAP_IOEND_BOUNDARY;
>>  
>> @@ -256,6 +254,9 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
>>  	if (!bio_add_folio(&ioend->io_bio, folio, map_len, poff))
>>  		goto new_ioend;
>>  
>> +	if (folio_test_dropbehind(folio))
>> +		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> 
> And move setting the flag to iomap_ioend_writeback_submit, and only
> for the case where no io_bio.bi_end_io is already assigned.
> 

To confirm, this would only work because XFS provides its own task context
and is the only consumer of iomap that sets its own io_bio.bi_end_io.
If another filesystem set it and didn't provide task context, this would
break, right? I can add a comment about this requirement, but I want to
confirm the intent, as it feels a little fragile as-is.


