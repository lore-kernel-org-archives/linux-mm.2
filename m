Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09ADC10F9968
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 19:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CD676B0005; Wed,  8 Apr 2026 15:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17E2A6B0088; Wed,  8 Apr 2026 15:44:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06DEA6B0089; Wed,  8 Apr 2026 15:44:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E926E6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:44:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 867521401D5
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:44:43 +0000 (UTC)
X-FDA: 84636416046.19.C7FE1A7
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0389DA0009
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:44:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="iUwfPg//";
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="iUwfPg//";
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775677481; a=rsa-sha256;
	cv=none;
	b=D30FKDKFGy1GrTLIux6SP9v15rd5oO0XuTwu2QeoztE5Q3z2A1omnENlvFfmDh4E+c4Ch2
	Jbbmc3ehuX0Wav2XCmRxGcelKmLIkMICNTc9x2c1ySyLemg9A8v37nY2tzeZCX/3A/V9DY
	qIDtRi17uRUBP7gtnw7j8Rp3Zw7eYy0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775677481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQ/TG8NyYW11ar8cP2zAAoS1p0Xy/yaGNX7PKSKfnNI=;
	b=anHuST7/VLFe7f+Zdd2x2NkEa4EECK66KDauUzwhW2FSL/x9B79/dvyao/MehTb7wihVQ7
	pUCCe/LGuKf5h1+YILsTfDZ8lawDVS0iZIROmnFurwB2UT4FPGcN7M4zhs3EGqxNXQhqeY
	eYeyFXtmlcE1MAupNAjkgqgxHg0JRFo=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638JN7Cr495495
	for <linux-mm@kvack.org>; Wed, 8 Apr 2026 15:44:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=cQ/T
	G8NyYW11ar8cP2zAAoS1p0Xy/yaGNX7PKSKfnNI=; b=iUwfPg//iz4QeOnNBzRS
	26n2mXDCUin867E41bkq6MbXzJHVhjIy/JEpfgrWMmzpIsMffhoxNVTijCNdayK/
	omdxmyQIaWWqjhhsoGUDrlftst5MjFj746hiLNxRoVv72HAOs+GhT20N0600pdSJ
	u5kM8hnYgRkZX6K4bIoCR7Qo/G/l5U/VGm6eJWpF8tJjbvRicduLndw2xV5BJFV6
	2MO5int4NAEXn+ocjmyXJjwWv5Zn7wusO7sw/CSCjPjDYkxyp/CFH6qM1gnEVUvO
	4Dt9o5W5NtfMdq6ljtr/V5OX8jy9ZDscvwkt3yUFXutNGJ/muM2RT9QZnmgA/w5E
	Zg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3nyayb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Apr 2026 15:44:39 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50d76f460b2so6776511cf.2
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 12:44:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775677478; x=1776282278;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cQ/TG8NyYW11ar8cP2zAAoS1p0Xy/yaGNX7PKSKfnNI=;
        b=U2nrga7yHGck6/cHOLTjGO0ZO2I++9lgDWB6Nci2ITYdD3XjstDJzWM/xjQaP98Hhl
         ibvhZM3GtILjnhj1airIqTBcewyTviFMSKsEAiGkKdio+nQ1Qg6ES7I8WOSk+ayl5CFD
         ENbPfgiqJq+1pOuRLmIRW5A83Ey8pioVgcWB8ANRpLbpvEs/LSLwR1L4FWKKh+9/VeFd
         4/ZOx+qCjisEVPz5WYTcSIXgRL8+3QiPpr8LTbmkVt4jnAG6PCDcgUHBeuuvbN5CD3sj
         Tos1LZDNu94d1i1+pcIcTCvC7Rle0sT8TnanoLRVcw0zQ6CmsieMocP4h2ZbD3Xwxhrg
         SDyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgWmmweWm+iVVGnSoSB6OXASL2vhdJBVZUmX1QxiGPZpsJl8cSSds46zgrcsxwwVAxR0pImbRHyg==@kvack.org
X-Gm-Message-State: AOJu0YxgfI2w/UhWZpX1rJOQiHD1k9jFU1a5Ni7r/qsLJSfMZ2zaXOZ0
	FkPau7oZLrUmPJMfzlIGGLAZUZW3jZhmYzma33QasyoiKp4QlLdSCJk3a+6XhpyNo1qMNMDxX/A
	swPiatpvbJI1zxmEopzgSE0RccLXdfOn5W8nINFtCmOS9OR+4
X-Gm-Gg: AeBDietsk/a9mLgzAiKBf/L4JYRSzjeQwWuoIg+qSk25OWHHkmzKwbm42YO+sc0oIPj
	iYSmbvfTUKTrF6VwDQnHxkpBfvmMJMDMmO2jfJZYnHlpNY1kUD+GrCVpdNemowEBF8txulE1ZYB
	zw79wPKxDPy9PiOuIKYw0IZRbdMIADrlbzAgJSzaM/+v3SufMWEkV0P8tNCe6EtDjN4PdIXeDj0
	uZ4SjcIesAKXeMc5X5zC1aWtZRmym1lKA6sTjzcafEqg6+y6/H0FvhjUgSojTTm8YopdWmDhcf1
	GP2ryiYcd8Iqo3EW9i+stMG7nmLTzd1fVglPrhyFotdiGM8LT6dkndvNdRclUKc29QspTckOael
	v2U8p/QFSEyYbdsd7I83K24DSiJ3qpbzyIUGosX4B
X-Received: by 2002:a05:622a:558b:b0:509:3098:819a with SMTP id d75a77b69052e-50dc22dd2a7mr10872191cf.44.1775677478533;
        Wed, 08 Apr 2026 12:44:38 -0700 (PDT)
X-Received: by 2002:a05:622a:558b:b0:509:3098:819a with SMTP id d75a77b69052e-50dc22dd2a7mr10871821cf.44.1775677478076;
        Wed, 08 Apr 2026 12:44:38 -0700 (PDT)
Received: from [192.168.129.206] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d4b1a3fc7sm215560781cf.5.2026.04.08.12.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 12:44:37 -0700 (PDT)
Message-ID: <9631d652-fd3a-45ac-b8a3-b632b26f6fa5@columbia.edu>
Date: Wed, 8 Apr 2026 15:44:37 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
To: Matthew Wilcox <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRDyJrkJhnHHMSe@casper.infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <acRDyJrkJhnHHMSe@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: XMjLC-rGGWxzyE0bP0h8cNE-jSkxbq1v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE4NCBTYWx0ZWRfX0yDfog+LDeDg
 GR5+AosVQrjTdwJZSKXx33aUipLi/yp0i7Uj/KQfD7Mf/BJ3GzXLLhd3oZxdZnAkLxgxu6kJapx
 ervWD6eMeuYZwdppnFoum4Cbpl3mGLQ/zILedRdFbyDi4dNKhYLlp7G20mISf0F9OXzrs+CD5ku
 2FZgC/nsResOYq8/PyKw25ai9cAzKAV/BRrSqCEbMEmB3vzx5JITUmBpCD37+Rsmth/AKa/hoar
 Rf4k2kqCET3j62rY2eMtIwUk5vgLI90if79lao59e1vZJFs6EbjRM19nm60dT+Hl9WEDjK1oxXM
 Rin6HI/8+sqnW+6Mmnja8+UtuvT1JKvOOZqR0AKbxrhp/IZfOtT1ZN1J0bFPaA5rsX3dpnjqvPR
 9G5O0YLttv862pAZqLR7rVPhTkF00qlkK50MrMZvu50rcPR4WE9X0YdV1nqNNJ7x9NqTZ4Hc2vA
 HtXgVdwvFWUuvsdvGhg==
X-Authority-Analysis: v=2.4 cv=QPRYgALL c=1 sm=1 tr=0 ts=69d6b027 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=X-nALmS6JCAzqVr0gswA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: XMjLC-rGGWxzyE0bP0h8cNE-jSkxbq1v
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 bulkscore=10 malwarescore=0 phishscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 impostorscore=10
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604080184
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0389DA0009
X-Stat-Signature: qorxc3t6y1ffusnu8k373e7c3ut5iohr
X-Rspam-User: 
X-HE-Tag: 1775677480-815902
X-HE-Meta: U2FsdGVkX1/QfYpUGHPrTQpcBDlCwvb0HeS79M9+rYOlgs0Pwig+t6/TgKSd+FBY2QcTp7Q0PENk4zJyQU2wn/6xwXr2cxSgKfWj0A8am2mL/o978uEc6tWPNUGqCq4ZiubzC/adUdvg2XN9TRQiGulYNPrdNecP3wk9uDuYIjeqH7hhXmNBzEKeCdACCeeM+dwmCSYObIup4lfLnNoxk4tMH+ZSuXlYY46L1vS8EUrSbs5haefPSipIp/6n9D0y6/Z9jnHGo4cKqa7/TxSjCHvl0s8eF1SgCgyksfYIheBq4BC55mbTRxwnaCoPcQmmzblTm9ioO4NBXBdOVBay+xIBmTeiqkIJ2jX1L3cxiN22B6/a3J6/Uu2/ibPEuo8xLDja5PXpoe8x13TodgRIDAzF4t0eZTGrvK7VvlZps9BEO3rHR/rF/eIoPcPC9F3KMA/rSzhVj9yBO74OzJesuncLqHBzeDsPyzo2OSu0rjJvTRpafggNDQLVmbk5hF4LMrUfJFPgaDBdbbCCQsznmaeIvOxwRPmVoDr1ULPwkjFa8T6ZJteoyNtYzz9ZZyZO4pYQwxbsea5wGrD5z9lsBXXqf5xldK2zOqpxfUBOrVMVT1oQjqCrgx4R8ETTmWNTut6lCsMzw2xBGPfSkRMl+S8A7kLwnRsWAqpRwTspt4CWr9t9IOoewDMZV5JbEd4qmEAqOMeQK3QOcDx7XVtVnNPmEdDCs56Xr4FbQ7NanGQ+abff8LIRCoaGMNSe718T92LFI35DfCefCH+ryZvpTKkpf52UYHOWDH6lpHEEOyYFurlOp9GiBD6kpqZPHGHR1yEIdUHA+aMVfRkvyuESGEj8FHx7sbuor8G78e3GWTVS7jS/NS9nEidB5y96IqrFFx1axhkzeLIwUZQ2c92SCgh9G5zOyEudh123ujVn0d9FdeXDEP9VQmjG6qmGdsF5gpjh21n7B7zGWeesY12
 5Eimf/T8
 NbEHW+SOAhcBton8s3doOYgcAG9rRbxXuvh17LJo//G2LbkVOINBN8OoLFRBxx0ulGu1JGFc5R5TJuizcc2vgtnzgO8Xq8MoZXZRgobQYlv1xr3BlqeTbXmC1WmzhlHbWerlmeJ4ofixKgGcMrIf10M3r3fC5bwTkWsCDOVmgnB4MHGxF5LESbfDxM98PfPvn1Ew1MI1w++InTNl5SUlsL/8kFZymJzQUIdVa7ruXo36bxwu1mvt/0z9mLtBx3CkSyC8kSz53IPla70K2+zRqao7BJsLsM9OlJ762bXVUaKdZ5cOOVkt+YDOkPXQZ1Vd9RPymTkJTZDz3Be/KRiqkSwh1U5dkeqMkWcsb/J1KAa/coCSz4zeJpod4dcQL+Sf/acZ4zadeW7cHuHBBK10Io7+LJ0t0DucwCziXaxXtmczhV8ym450ZKjtmc0m4iKR3Celxo373luE3cWaxfvbBK+5ZcnR7Bv0AmwWWcoB5u+k2woaf1h1FlG5jioTirpqrAXkxBumIzDSYDxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/26 4:21 PM, Matthew Wilcox wrote:
> On Wed, Mar 25, 2026 at 02:43:01PM -0400, Tal Zussman wrote:
>> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when
>> IOMAP_IOEND_DONTCACHE is set. This ensures that bi_end_io runs in task
>> context, where folio_end_dropbehind() can safely invalidate folios.
>> 
>> With the bio layer now handling task-context deferral generically, XFS
>> no longer needs to route DONTCACHE ioends through its completion
>> workqueue for page cache invalidation. Remove the DONTCACHE check from
>> xfs_ioend_needs_wq_completion().
>> 
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> ---
>>  fs/iomap/ioend.c  | 2 ++
>>  fs/xfs/xfs_aops.c | 4 ----
>>  2 files changed, 2 insertions(+), 4 deletions(-)
>> 
>> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
>> index e4d57cb969f1..6b8375d11cc0 100644
>> --- a/fs/iomap/ioend.c
>> +++ b/fs/iomap/ioend.c
>> @@ -113,6 +113,8 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
>>  			       GFP_NOFS, &iomap_ioend_bioset);
>>  	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
>>  	bio->bi_write_hint = wpc->inode->i_write_hint;
>> +	if (ioend_flags & IOMAP_IOEND_DONTCACHE)
>> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>>  	wbc_init_bio(wpc->wbc, bio);
>>  	wpc->nr_folios = 0;
>>  	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
> 
> Can't we delete IOMAP_IOEND_DONTCACHE, and just do:
> 
> 	if (folio_test_dropbehind(folio))
> 		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> 
> It'd need to move down a few lines in iomap_add_to_ioend() to after
> bio_add_folio() succeeds.
> 

Actually, looking into it more, IOMAP_IOEND_DONTCACHE is used as part of
IOMAP_IOEND_NOMERGE_FLAGS. I think deleting it while maintaining the
no-merge behavior would be uglier than leaving it in.


