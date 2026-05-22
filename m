Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672E3CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 23:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A9B6B0093; Fri, 22 May 2026 19:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB3B6B0095; Fri, 22 May 2026 19:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9CF6B0096; Fri, 22 May 2026 19:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D88E6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 19:17:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17A7A160673
	for <linux-mm@kvack.org>; Fri, 22 May 2026 23:17:21 +0000 (UTC)
X-FDA: 84796619082.15.F64B955
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id C149AA0005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 23:17:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=QCzNXMoc;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779491838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XolIxwfsVJBVBpTPhnOybhIeNs+9oP88EwbFpg7C0dI=;
	b=3IkyWLADo+UkX0laOSXlHpcfkNwLnkvjnDtmbUxlZ9pSddBbVyxvRQ9z5hU3qIODkUjnP+
	habf7VP3+Jb405jtTk8SBP21kR8tFFxLIhm0/Q7Gj5WAjtG8JjvbC1FK+/oWiJitnxzDdo
	nzWE+DiCqtIZpZLZrSYCOlf8h12BREU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=QCzNXMoc;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779491838; a=rsa-sha256;
	cv=none;
	b=hHMZiHLO3oLvs4LBj1h+2qooqW1AO3ds/LjVLgcU8iDB53ETnJLfeTKWOcIH/BIIAF1lsY
	StLOV0IM68MIVXnR5Ow0+qTsWk99SyT6fujY0Natf/3qgPbNvdmYLhlAgxz7hda408OayG
	D/v9RU5rqsSESR2V48XrA9DMp2Idb7A=
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MMRu7S005559
	for <linux-mm@kvack.org>; Fri, 22 May 2026 19:17:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=XolI
	xwfsVJBVBpTPhnOybhIeNs+9oP88EwbFpg7C0dI=; b=QCzNXMocAxNFTmwB5r82
	Iqr6KeBeNApgLe1JbrJXqMTH7Hv0Jt/WD3PXKZ/QXCCaHxNZnn7Cil8P0gyKLaZv
	DWa07xsv7CrqPRbXnIU40NAL0kpe5neyU5MB0D0nSvHNPjBZq1at98019jHZbOE3
	9g6gkdgK+gyYrvYu1WCQVHRC1VK7MVRiBOCNXxobfa1CXAaZYTlihRJo2JKZpq8E
	AI1jZOOmEZE6eGOhYGuOC2N/WUrRf67sQd7RyFsswLHPrLlCbfd44HeFHwp6RxpT
	j8T6/BvDioIehEh0yVkyfu3Y4ybyW3Q/KGibGcM/+R8a2gbWyj/1VhE1uhi2jsxH
	Mg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ear3akygw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 22 May 2026 19:17:17 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-516d19f68acso36871831cf.2
        for <linux-mm@kvack.org>; Fri, 22 May 2026 16:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779491837; x=1780096637;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XolIxwfsVJBVBpTPhnOybhIeNs+9oP88EwbFpg7C0dI=;
        b=bdqjAmz91Eu6TCGyZ43/LIDbcrcKaCzLWHC0LiVFKmEKfti808Cnsgzf8Td3p0jATJ
         IHs7a9VZB1V9IvqpCDse/uLKzMljrr8EOrzykX8IQvv7eMtmOwybKOEgx57NOwVOX0ng
         K5DfRqmEEkU6GZ8xs6u21aUhWAbE3sb3jsUvOPDqRMeKXDhRa/VVTUdIwjiGgiVx2r0v
         gEW0QJLzs7BNdbpdCu5N/2RE/aEPtLO+OIyWJobwC3nrW6mvDEj5vpCnUNa7T09GGLqQ
         4vZV22mZT0WUzxa2wAfd3slYKE31eHhBCmwaeUaj7+HKyT0QVVbOwCDJg2Y7khkhoXe8
         J3kg==
X-Forwarded-Encrypted: i=1; AFNElJ9/wC/MQqo0/0bdmpdpof1g0M0IaLvTGeCUTSC3iZ/avRNRodjuSSalhul2MCmF1UXYuCeZAg8ezg==@kvack.org
X-Gm-Message-State: AOJu0YyADBZFr1MKuqzWWcx+pebxwCPKbb+PIVF5YyM0h22HB+jv2wtL
	QlIgeaZovD/P7UWUrXROqiH7M/AYNrmiaLs26AqyDCnj2JXn8UNjOrEJaA2ohcG+n5WQ1dmyipr
	hSBw6GUYrkWUtxYs9OgB5K5pmgPaETO1vs3K3fAzseT2WxQ6K
X-Gm-Gg: Acq92OFMT7UD+FIwVg8QddtRtZ+ezlNLZKTdNZ4Lnt2fuv31vnizFJIQLilJUsOhVG+
	QFw3Eykpzy67xRwFsQbKj+uDqFzv08WweulqCWDVNMAgLJ8ac/R8G0vAC8tWvTJplyvcYvCq8np
	1Ql4tHtwBWp14EQvJvPovqsCIXNGxUjDtYmTI9bGPhKolqT3LjjYe696pqwrvnA7csFaN4uVALP
	22fD9aCmBD5YfT4UIpX7RuBoEh7U8wWZKtTxJ6rmLr1UtPTsRWYuqdq43i/YbXIgYN/uNr5bJHy
	F8l+vZNFFFyIkkElZr2pKU8iIkcJ6qMPTDY2DasDXIFa9xh2QGwQUrpI2uaf5cnpv2nI9ZfZOtL
	ZfgEvqYqsFsmHUlRHvAUsUZEFm+UyDyxCk9Jk9JJ8nDsneqB1awaDW3W/Cyxo99evKeeNZ5qpAj
	c=
X-Received: by 2002:ac8:58cd:0:b0:516:d8c6:3e64 with SMTP id d75a77b69052e-516d8c6436fmr59502421cf.53.1779491837059;
        Fri, 22 May 2026 16:17:17 -0700 (PDT)
X-Received: by 2002:ac8:58cd:0:b0:516:d8c6:3e64 with SMTP id d75a77b69052e-516d8c6436fmr59501831cf.53.1779491836515;
        Fri, 22 May 2026 16:17:16 -0700 (PDT)
Received: from [10.207.65.224] (nat-128-59-177-214.net.columbia.edu. [128.59.177.214])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516d8b0065asm25972531cf.2.2026.05.22.16.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 16:17:16 -0700 (PDT)
Message-ID: <f8d509c7-c0c0-4196-9a82-a6f8ae24ffc2@columbia.edu>
Date: Fri, 22 May 2026 19:17:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/4] block: enable RWF_DONTCACHE for block devices
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-4-782e2fa7477b@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260514-blk-dontcache-v6-4-782e2fa7477b@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDIzMiBTYWx0ZWRfX7Dk/PwrRvWE2
 ow0RtMUMwAb8hxelfLkjVQQmC/lR1MQa8zKEliU9qMXyGqUxo+Ao/hIG/jNnMHKMaY0chGSOtH2
 T2TPlWUn+ONQfqqEwVlExveIgooqVuZJsRQ3ebMx6rjv5FTwLtEZyVrnWHlTcRIhM0Xejcu84Jx
 MIe+6us2qKX7PNnJ2feQRYbYok2ksgW4AZ4evHJguzODOk3pvQihJlbmYDcYY+abOuYS2wb4+LY
 AV5vUOxToVkxniYdauhOiemgBjdaQCm8d8ud9/I5RppLFuu06BPoLOVyniyq17lzxNJer0cKJag
 Amt5S+5/x/ZhtsB1/cyK9xmsDCRNAI0ZgQb/0dQFUZYsa6KyxvEHBhpJl0ixsgM7l3Qo1d1W0hq
 /x9DF/Yao6mEBUGprtuQzthdJAW8Pl0mZ1hhz1Pqv/iD4B3IcvuJ060P3TlIIZL7zmIPtizdkNX
 SAF8EvvueD8kQFPKgrQ==
X-Authority-Analysis: v=2.4 cv=TPt1jVla c=1 sm=1 tr=0 ts=6a10e3fd cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=n4JpGxNP30DHW88kdRRHAg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=c92rfblmAAAA:8 a=7QGR7LCADlPcIrvLOjwA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-GUID: ZjBIcjH9gEY3ow5yiy30YO3jjL_V7WPj
X-Proofpoint-ORIG-GUID: ZjBIcjH9gEY3ow5yiy30YO3jjL_V7WPj
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11794
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=10 impostorscore=10 suspectscore=0 lowpriorityscore=10
 phishscore=0 clxscore=1015 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220232
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C149AA0005
X-Stat-Signature: giwruf5hchar7ruowat4kn8hien1h14b
X-Rspam-User: 
X-HE-Tag: 1779491838-683661
X-HE-Meta: U2FsdGVkX1+Ao95Bry8ZmDpnk4WRdopiezXsLybuYLHbzRdcX0EY8u+jARNalX0aZ3UJ0aIqrSHJtf/oDX2UA9U+Jfd+AMXdlDLwwcCnnM8hh3aT5sSiZhcNyO2ymW5YbP8TxwNBUJx1AqSt4wlJFc8TFALfG/fm+weJgVb/naOzGwutRNeSyd1XkwDWSrcVmGkqTS9N7vVSpi759EiTavURzzKtqrFnQdlctuY1MHh7kgecR47H5p+ftuTiilClV99VmyVCy51NLNDC7MkWcsZfkE9XyvGjppUXZkzorycv2oQmCIaUDAWYMsHVVunm33oBjgPB0G639Ldw5FF2N2zSbNhtA/ALam7YG6EkMkVD9IJqtu0665NgxVbajLKtayc9De0qtLkNW2xdNMdTFNquwqoONhd6jIBtuNXXrTYXld8W9LjH3/qdLEqni8jHEYU4cBmp+XBQGrZGk24QkZ25CKWhQm3kQT5xNIadI2OxWWoG3rd69Y1KYWm2cGvDOAwvvPa42HqRWr46Ix3PstXYErsuOAj3XrgSHgVQf4j55gjLkR6x5U/17xzs1heP7r0zwACNOhUMAZaW6tKjWyrC5vCMMn+axLYCmWVthjnzfHvoNKt07k2iJj/0y8FRNjd8lOyEpyxko5wiZM7YhlVcU/0kojfauX6bUwoJp+zhdDg6fYCU42E+m/Ud3akkYcObQ2+DavdTxustmjoGmDI38MxgPzSPaS25QxX3qa8mg+rG0p5knREDoJ5Ge+b8+Vb4trSyoJ5Oxpx2ZCyJwEKCjK+6rDdcmSHi4BwTW3MbGPeKgWaTTMvAuOjiuM2xXZYEnwn58HWFyB80+6MsGZzBCOM0UsAI0EC/6dHO6reBU+dWfm59Tu25ikSTtlPOkHlO42nZKL7YV7RfQhCxtxnocQpjtw2YaeffvFx9WzLGE5GaS+7RYgAbJhWHt10gEJfLm8pBGIkaH8mv7eK
 YGsNN9Af
 Wk8SAdZY1ugp3VmKgt6uB1lYBQSrxQTAVUBKywmuOI2Oxen2c/MCturvCi1ckfDsrKyzLsLLwcMB2g9WG28KvrCIk3T4mRHMGWKFpWGS6K0fEDhAFc820/7U64fR2nqolZGkxRsN1IpNmpDkiBPsuGS+LhMin8Pj4kSxGx9jzz8S/7KSqESoVgZMdxF4ADnnTWshC69jvc9aJdMsYHApBd1c7W1YuKvBLrQXpQYjr5SjBycfHk5XqEq7/YSM0lfidhT6AkvOmP67xvQJ82l3uteSguVe342GHDlZFdDFh3kIFjW6JP7OXtfdKafxAffskChfs/BS7SOru47iZw/CCP2BecrAbvs0/Kx/NDCxpstMXHavXIPZZDNi8n4eVC/tpjohs2SZ6HCHKNoXcwaaLS1/xAF0jikRm1005pSd4rc58930+t+KKIPMXka9Eu348YVRABvB6zzYh6Qh+bDPD6RVGRWlucpRsLhZJbl4eu9NgyNGKNcdpBZWSoM0e11X84Xli2+k1XALzyH6qkpOzs2Zld9yUrZycvSYGammw3nFIGQ731e+Jk2hwj8SOqdOu2WoADQNP24aZjPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/14/26 5:51 PM, Tal Zussman wrote:
> Block device buffered reads and writes already pass through
> filemap_read() and iomap_file_buffered_write() respectively, both of
> which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
> by setting FOP_DONTCACHE in def_blk_fops.
> 
> For CONFIG_BUFFER_HEAD=y paths, use block_write_begin_iocb() in
> blkdev_write_begin() to thread the kiocb through so that buffer_head
> writeback gets dropbehind support.
> 
> CONFIG_BUFFER_HEAD=n paths are handled by the previously added iomap
> BIO_COMPLETE_IN_TASK support.
> 
> This support is useful for databases that operate on raw block devices,
> among other userspace applications.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Responding to Sashiko review inline:

Link: https://sashiko.dev/#/patchset/20260514-blk-dontcache-v6-0-782e2fa7477b%40columbia.edu

Q: "Could this code path be unreachable during block device writes?
Block device buffered writes use blkdev_write_iter(), which unconditionally
delegates to blkdev_buffered_write() and subsequently
iomap_file_buffered_write(). The iomap infrastructure bypasses the legacy
address_space_operations .write_begin method.
During a write, iomap_write_begin() handles buffer head allocation internally
by calling __block_write_begin_int() directly. This naturally inherits the
FGP_DONTCACHE flag passed down from the kiocb via iomap_get_folio().
If the VFS write paths were actually calling .write_begin for block devices, a
CONFIG_BUFFER_HEAD=n kernel would crash with a NULL pointer dereference since
def_blk_aops does not define .write_begin or .write_end in that configuration."

A: So this actually seems legit... doesn't look like anything actually calls 
blkdev_write_begin() or blkdev_write_end(), unless I'm missing something.
block_write_begin_iocb() usage seems necessary for bh-based filesystems, but
block devices seem to use iomap for writes unconditionally.

> ---
>  block/fops.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index bb6642b45937..31b073181d87 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -504,7 +504,8 @@ static int blkdev_write_begin(const struct kiocb *iocb,
>  			      unsigned len, struct folio **foliop,
>  			      void **fsdata)
>  {
> -	return block_write_begin(mapping, pos, len, foliop, blkdev_get_block);
> +	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
> +				     blkdev_get_block);
>  }
>  
>  static int blkdev_write_end(const struct kiocb *iocb,
> @@ -966,7 +967,7 @@ const struct file_operations def_blk_fops = {
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= blkdev_fallocate,
>  	.uring_cmd	= blkdev_uring_cmd,
> -	.fop_flags	= FOP_BUFFER_RASYNC,
> +	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
>  };
>  
>  static __init int blkdev_init(void)
> 


