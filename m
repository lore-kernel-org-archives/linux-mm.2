Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0929B10F9972
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 19:36:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62ECD6B0005; Wed,  8 Apr 2026 15:36:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DF636B0088; Wed,  8 Apr 2026 15:36:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5A96B0089; Wed,  8 Apr 2026 15:36:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4324C6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:36:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA5EAE0B0D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:36:51 +0000 (UTC)
X-FDA: 84636396222.23.C357E8F
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id B42A14000D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:36:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=QA99faMh;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775677009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96l/i7uyqouj4dytN5MpYVZKfSy3eXi7wDZWJb62Zz8=;
	b=U3XjZ/RBWeAAzb23KVvaRDcQ7dszPkrD5q0SOOhfxZ2fncVYMpzrwqmevyOR+4NSUXeFiM
	yEA15mzo1rW8W6V1atp4Hk574dnan+wuA7eMU44JULdGIbwqU551e0NpTR4IR1tB6LlMAK
	0u0+7d+fMLgfVKB+Q5iMW/yMyv9urM0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=QA99faMh;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775677009; a=rsa-sha256;
	cv=none;
	b=ANvZzzadrWuT6ChkI/p4lN99b04H75H2LjDr/khRuWAPNGKCgyWkMdYvnwPFGjJxvZyHzs
	6sk3C9VuDXgEHiDg0v1G07pw/ZtDf27c/jq0pupdPPXUcDwabOsJ8Q3okWtxNmlHL7fcK7
	tkN1pIkzahWDB0LCjaj7COOgpwXozE0=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638JN6rX1682075
	for <linux-mm@kvack.org>; Wed, 8 Apr 2026 15:36:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=96l/
	i7uyqouj4dytN5MpYVZKfSy3eXi7wDZWJb62Zz8=; b=QA99faMhBQ2CRLNNFL8L
	qRU0KP4xnwNqn7cMfDQW5hCPv6hts7r/Xd5kZaAY3dSC43v6ijdCL1tNUW26zeG0
	i00xv5/w0hQP+E/6FmGItYboGNRG00oqthfvGcLHUjewrJYPfEU7rIUhb+rrH3ZI
	E7MY1V9FjX/Rjvqq6Buhdtpm+GujTj7zgsZPqlGlaK9OmmMVEoPJ8/8i9H/r++Ew
	xasVMLD228PIgjw2pkPCzEZbfiWSUlXyI0hlkxJ+Un5rnqSYBqPbHFeq+tEtIyhj
	R4oX1MgQkBQVvA1CNbDR1nsrNcP1286385FwkRZAdf/g5IG6aI/qI16ZN0btyleO
	5w==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3n7bxb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Apr 2026 15:36:48 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50b44f7b7bbso5160831cf.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 12:36:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775677008; x=1776281808;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=96l/i7uyqouj4dytN5MpYVZKfSy3eXi7wDZWJb62Zz8=;
        b=rXkxOdut2nBdR08wMT+oQdQJzS1Yk2LbTiLOgP52zFbk8GrOL63aq6A0b2H38qkVhd
         Qncxl1MDWSPR+NSs9gks4YNyCv35fkKq/xBtCjNBVbsNkAIipXJyhQVXuIkdcP2f/o90
         u8EcPg2nrv6M6fZKl1zLJ9mdfCqD/84nuQj++H1F5ks9VcOgRFAYW9+8qrRjK7TFjgZL
         ewyDa2cj2rwr3PnqLOvMNyirqin+LLHv/PDniR1mel6Qm2yISNOScEk+apcMiEDVYnnX
         /Gf8AANnk3tHBI5PGgA0m+tDIKRqEEkNZ4OzXiMwKa5OAYZcdKtJnCbaFeSKHTsqjD/5
         9DDA==
X-Forwarded-Encrypted: i=1; AJvYcCUuDb9DXy750XF5VtWediye0lFq4Np9XbjQQBy7zc2sQ9LguvyQul0ou14Q3S+aXA89TgVAii9lzA==@kvack.org
X-Gm-Message-State: AOJu0YwMvbKCTIoTEUEdbXOMJTmU5MwN4RNQh5uHlB6nMKPlLtRVIyL3
	RwzZnzcCInJgMPtHYl4gX18GpcLs9ZPNcoxVXjc/SeVVqC2KH7hIsq+cgcZ+KSyVRh85Bj+bxds
	O3RPKchMXdReglt9GO/AsPlL0Z8C4sMJZCNN75BOONfQkdnnH
X-Gm-Gg: AeBDievUmWsCpcsXt9Crha2pPk+RHnZl4UHXTmdwUjeY+kG0dUcNnPL4ooArpC970a0
	NVedpsOhvSoMTQFyhdV3Q/e8dM4C+++0QYyd4Xex8irN2YNO+RKJ6H6rg+jSCvHOBXeP8WGMbbd
	EzEE7r1CVAX8r0t/Z4d5tuFPeFQDMBft5H2LyDQSCMbj0uGoKk7+DDrVD6+f2ux+CeZAT83dj1+
	o3xqjTT1y4oLSK0BKWdl7PNMGdx3eob9KHyEU5IaB1m7qF6dlOJnAgitAiTFAW4n8zB9x4F08AM
	q4PSr9TvXjlArl6BLv3Oxc2AYKO9HKW++tYiDZSkmde32VjslgePVQ9kapv/asKH43hvfg0fTdW
	DD5y47qhA71YFcbjYwOEnYY83l0rq8Ma8Sze6fZbo
X-Received: by 2002:a05:622a:1a86:b0:50d:6b6d:bc17 with SMTP id d75a77b69052e-50dc212b2e3mr10299451cf.23.1775677007889;
        Wed, 08 Apr 2026 12:36:47 -0700 (PDT)
X-Received: by 2002:a05:622a:1a86:b0:50d:6b6d:bc17 with SMTP id d75a77b69052e-50dc212b2e3mr10298851cf.23.1775677007355;
        Wed, 08 Apr 2026 12:36:47 -0700 (PDT)
Received: from [192.168.129.206] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d64752857sm142454931cf.21.2026.04.08.12.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 12:36:46 -0700 (PDT)
Message-ID: <c7342d7f-5c92-4a2c-9d00-5f9cf478f4e1@columbia.edu>
Date: Wed, 8 Apr 2026 15:36:45 -0400
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE4MyBTYWx0ZWRfXxuPLvPBvarMM
 Y+eysrhEWiuutDBE/KhAkUPFdrRcY+eSNb5+GQR0ZfyJnpeb+8/lFL+pl+5mDefsAnM+fUsUjEq
 cDCm3rK3ZkxS4t77p6dgMuMYf7ijCiJI4DxvD8FJGnAVO5wd9wAO3Ge3BgmDf5c1YrvBVJTvSf0
 yNiuMvj5G3/C+H/BetzB91Yz4YH9vlZ5PmU0Ujijo8vq7jbGJWsJ6cLYoRs1IIVazblA5rJF5Mu
 OCXUFaFgO+Fx8/ZmOPMhVkQEu/uFfy/IZ8kXa5/Cc0/uebwl8VN+r/Wuc0QIm2Ki8BCPyJTPOza
 VFBlu9nENNwLtnJUSVIoinvho7ADiRbY9xit0no7sAjH3UYswq6Hvdfnh7vDhYr77EDvr2ULdg9
 sgmudx7Hxv96PsVUZ3mw8fzGVc/msCIIpclOgNyy9s6I9L9WX9af5HyQMTIOgyVk9y6LRplLK2M
 7JVGFZcUKO4Tii9I3yg==
X-Proofpoint-GUID: x_8NIJfs0ShlA_gYASPYBacZT1pM9QTi
X-Proofpoint-ORIG-GUID: x_8NIJfs0ShlA_gYASPYBacZT1pM9QTi
X-Authority-Analysis: v=2.4 cv=N9AZ0W9B c=1 sm=1 tr=0 ts=69d6ae50 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=fDzNMwFgse8Xf2NrkjQA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=10 bulkscore=10 priorityscore=1501 clxscore=1015
 phishscore=0 impostorscore=10 suspectscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080183
X-Rspamd-Queue-Id: B42A14000D
X-Stat-Signature: yndr5urhpcpn8d4m3wojmx3pq6nh99hs
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775677009-165060
X-HE-Meta: U2FsdGVkX1/DMHZwtmC7vwuScMqYweJc20LyJuYd9CMYFE8bbDUihWsw2uMMjN6TJXipiqP9vkJjfV3kTlTjB9Dk9CcBZGUe1ehbXrhmgdwDPMWuQQ2TDLNkp6ceZi84e3jXzV6h8EmVr5EiwCj4z0ozZcrha+va1jXcxyI/FwYjReF43eoAP6oOxQYMHMKmbyZ4UDTTjLasLg5i+sM216+x1vFaDI/3Omtjc4/JSWzcQtK5AO6Oo8L+Yxj30984P9g+DtM8cRIGp98HdsAGtnoMGb2PfesSslDnVErXIXor5cZSCt0rP9eLakDVMJ+Gf/2GVot505R/CZde5bnnZUGEWISd2mlVv8CZ9TUhv3PTK4WNJspcYIsrbeePf7bshlGIntGqWh45RJoHFiAvfXUoI20q25JFejGufMXfUPOKDH95dOnRDbQsNiU271DOYkaKy+cIjDxri/6agabKBnjwzetv6x0/DvsGAb2fHaslCQWkuhZFeOyU53tqkOGciVqIhF7nW32nw6lMRyXCNk1HManD0NgQZWhGvoEk4xQ4OsZNFYBL+Gua8w1TLk7tgUlEVn9ILn4PfxI5dGWYZRPBEW9oY645RL1r7nXBzRNUTr0J8QSDss8iBsFR8fvOkz9BrYuUc8RGb6qnc47NX8wuAKydnr6A6PWb+TsmRkOy9k5DlIdY2SKA/LPk46FoOHisJKcyppiLTqm7LE+jrw/hxEdY7FRRvNXzxDi7iJ2B3DOtDOanbobR+BXd/7j412VOt4GvQTp3fW0ZQpK9G4bhhHOO6EZUDRJYnYu9DJj9tbSI6FLN7LL6eDN3DqamyXzK9M4+pUn8LqC78sh3xsP5O2IWgPaSsRiFAySk4MBNhXWcqipUtyqZLTH5YGSHLcakaJ3ezQNS28wR4lyoT3KvsHhUx6nP1y1wbId5t2VlNwT1coD5eGtK+mZszTyOIyhKYFJYBAv3S7oInD4
 lAVY73sg
 EL0KJdQi5t6i3dHmJD2EjH/lEBK3djFCnCNizKGfrolt5RUgppcv/VXt9LtzNuANcLxlz1P74yOmn4cgmqFPvfNbuQ/rVb+qRJZeglbU6x6jaWdaXQ+GYcGyA8OG3c5HEG50T1jzl8CDweM7Hhe0X1ksuXG17Zl7APor4FZaI0CPcFPc=
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

Will do, thanks Matthew!


