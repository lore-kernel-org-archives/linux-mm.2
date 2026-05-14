Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 586C7CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 18:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796C86B0005; Thu, 14 May 2026 14:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9A86B0088; Thu, 14 May 2026 14:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A976B008A; Thu, 14 May 2026 14:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4852E6B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:30:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB01D140634
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:30:55 +0000 (UTC)
X-FDA: 84766866870.12.01FEBA6
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 35B9CA0012
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:30:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=aEiW1vgo;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778783453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dqkiLvRS0biC8wDTf7mWRqTHG4xr6lw6pw3nx+LivZU=;
	b=5Bjgcc/zXwptoFlbXTbt9dfTq63IXEPQsGNe3FZwWBoNsMbd1yu5NwzTfHwMehqRo8G6SO
	cnlKMVC9s0uDZGEny/EUEXXkyieFXQEf0iodCrghWZeV+QXVamkHz6SjYiGNETXodSwtNp
	lTGkVhgo39BQgW5ye+IBzV1r49ycPZc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778783453; a=rsa-sha256;
	cv=none;
	b=6Sji3f0IrOS3TigNtf+nnFLQV4UNfLlf9TQ6io+FVbi9ulySEg/kLzAUc3glq3nGaE/Zmg
	nEWjWtsNeixFV3NoeQUEG/NfFHWUpMOwpMy5j9PTFXYbd2PHCGp3vOSEhpmD+fP2BNzVLs
	Fd6coXtvG3vcX1EFTG88cwXacx2US3Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=aEiW1vgo;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64EHukNP1699604
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:30:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=dqki
	LvRS0biC8wDTf7mWRqTHG4xr6lw6pw3nx+LivZU=; b=aEiW1vgogj7n5YcW6NHF
	YbDTonW54xw3FqAAekPPADUwCORx5bTzh7grpXCPPXfwnH6gVmeTcev+Dnh0bG44
	Il1GBqAswROlkVnubEUDPgMfEWWkWMpwoTuXyoaWapqNM4RLXTGrhbIRlnATX3Oz
	RhYkbCg+r8A3AD6O0954cUbQwfKwGI774KaY1uZ2jMw+pFfk2tbhcisGBL2Ez+5e
	gTCP3AyeSdrj5oaw3jxqG/tI7y1jI07auVhmJqvKafZ0nm67VdKe2Caet6gdgAyn
	DfuVt3CESQv1iyvQHkMmz1MwNC6RvKQMkvR5PeKvn323GXRBuH58ptK/j1ZnBdfC
	XA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4e5fu7j817-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:30:51 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51650041428so13305481cf.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 11:30:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778783451; x=1779388251;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dqkiLvRS0biC8wDTf7mWRqTHG4xr6lw6pw3nx+LivZU=;
        b=b9TFaTmJGPokggQBE7wu/SHqLUhB1umVeJ6xrwpBp4yK6RiC2Cj6GDj8n4AqaVyemG
         +gHHPckl90tuAy1dymJRoh76tgo3D2F1cLXNKJRrnply5LmELI+CO2TOoMFjY2vlSPCY
         YvjpSljfFo4IQ4iKf3hn96WZ3x/tEk0PwbumDxVKlsMArCKoyUUUSIZkJtatH01cpS0U
         VkUgJ9MKTzuL04Am/Trg2Ld7Bqk44Oe18koWqHEh9XxHq1EEZWDf8s+g4GY/qEsut3Ci
         W0iOkWRpHJ8SS2JTscPQbIgXnNd0606epi8qp95q0P6h/M/gzjTYrs4UXf6310e5XSX/
         3Vxw==
X-Forwarded-Encrypted: i=1; AFNElJ+xWS7ZTVRa1/SKDCulXoxwNOQI6KCspTof4Ykm5ERiiCgg7H7SeOQx65KyRnPma41I8Xp/Ow0Puw==@kvack.org
X-Gm-Message-State: AOJu0Yx96rHGhY9/TU+PxH733M4h+7GpOWAu3/EgXaO8hRCI18FUmM5e
	fux8y3jEL4XilOcu7sJRHupwRLzjVWSN7aaYgBEkNV0nvjQaKBSK+K9aQpRqZYQwHgkpZOv3Plc
	ffmUQiarxYgVbwAHf9qotGgl2k/6TmG7Ce9eJeSRaQeEpp46t
X-Gm-Gg: Acq92OF/0nNXbzhR1Ye50gPDn07MFW3ILmvvVvCLTpvnrJYq/rnvEtL5mPCtbFBbHRo
	3h7R8vre7hmDq9Mdgza4Os1R4wqRVg/jx9dszK7LAv7RD03co+7mpn+VStrzWYu1eIhHkUt7A9m
	GYgDJ9LjndSxcx1M0gayasXW6shKNQq6SInmsgu9Spp7EB1xw7m1D1RZabRp4AhQnQCn2SwAOOm
	y6mOX80mSJTKcTgEV8FjLS35dnj33T09sqyQx7WX6XLSeLI9/lYqAH2HavUpDgpqfVLpjmhG5ZP
	0M9HFVR7DHY6kUXrZliQjYoPTYb8dDQVI6bgcWHaSdjyzVuwXPYMvtp4lE0Pb1XSu5T3tgpdQLc
	NH0z5pqndpUZuvqwHv8kdrjtV0zJS/hfoOY93/uC0w+0DOgs=
X-Received: by 2002:a05:622a:5910:b0:50f:c26d:f309 with SMTP id d75a77b69052e-5165a007037mr6567411cf.9.1778783450596;
        Thu, 14 May 2026 11:30:50 -0700 (PDT)
X-Received: by 2002:a05:622a:5910:b0:50f:c26d:f309 with SMTP id d75a77b69052e-5165a007037mr6566801cf.9.1778783450039;
        Thu, 14 May 2026 11:30:50 -0700 (PDT)
Received: from [10.206.44.99] ([129.236.229.175])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516514e0b91sm12008351cf.15.2026.05.14.11.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 11:30:49 -0700 (PDT)
Message-ID: <18dd3936-9ca7-4c34-976a-a0fa09dde238@columbia.edu>
Date: Thu, 14 May 2026 14:30:48 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] iomap: use bio_complete_in_task for buffered read
 errors
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-7-hch@lst.de>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260409160243.1008358-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: RxFcsul2VBco4LJvgPhyAmy1prTDX3kp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDE4NSBTYWx0ZWRfX0sZrap/hBI2u
 HneMtAiyVlu7aOey89IRHc7bKPNSWVHV7q5XT28BceW2pZOKqeGEmQdNpE84N6+FvSC4uIcCVqk
 RYOral2c/UuODaN6H8f7F3GrHneDGixqxhYLeaf/814gKexlJwesC6bhmMeNxKHYqh/wV4kpqyU
 OxL4BCwKGhgtsxb2sHfbuRyHzOGZ12Zjc78wc/GQehzy0MkUoZkYuVmC2e7UPo8xrD5GsH4Sy2q
 HYD/G7fgUSHLGAtsM2RHk6clb+9VI6r3OSlr6j9aKyqUJ994IVlTuDUBc9gdvn+5S2Va1dGmzsh
 TnckHFZPtpGulpSyel6Rsd5F868OUBbvypjZXPCq3VIq+daaZIKcu5lcY9tWmqOBjjwv3EmMG4C
 MotbWDTIc/3O1erOrccyITEtln0JY1Mt4iLDKrOAHjLnNaIKVyRrM5+bdJf9pmIYLZgj0wMVCxr
 nJn9abC2BXPj4YmtZ5A==
X-Authority-Analysis: v=2.4 cv=GN041ONK c=1 sm=1 tr=0 ts=6a0614db cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=nkegbr1AwBRna+m8FBH0UQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=f7q37D0tNRou1Q5H7aAA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: RxFcsul2VBco4LJvgPhyAmy1prTDX3kp
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11786
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 malwarescore=0 impostorscore=10 lowpriorityscore=10
 clxscore=1015 priorityscore=1501 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605050000
 definitions=main-2605140185
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35B9CA0012
X-Rspam-User: 
X-Stat-Signature: chtw5c3gxytsmg8ice51p1r3s1sf84uj
X-HE-Tag: 1778783452-280432
X-HE-Meta: U2FsdGVkX18IaAtYp+/w+9tp+OCu4n8lip+UoDeDJJurShWIaTFUr3Yjn/elEzJDG0OXB4p8ccR/+YMa0EOE9o4t6v2Ncoapb6qUByhDyAHlh4nOjdv/pkJz9hgeTwrj0dstS7eqUGqjZVfG5kLaReRlc2cw2oXrogkDGP9pqZ/J5m3ZkW92Ki7j6NY7V+4dLofSWE4IydkqOwHT6rb/CPu6y0mydFfmPT6yF2pyyPSpOfGv+zzg9pEOT50xMR58wT8UyOQLwrce72r0HFBrr22IxJnw3Dw93dbxXO9QkecmjiIU4PKOSvVeZT70n+6LY0PI2LVLsVcM/EqobjUVxgyGMzGpydbiYR8e8aYGKZK0PA1vRNhPwCtQoYYPOGy69NKW57gbyu0HOMAMR5kPEM6q0fDZAc432rgpBg3RQWaAmqrCfMn5E3Ne/O23Q0hn0PchgzeNSE36TpSjyRA9ppjXvIISZtCCaopCf3dJrzixDhUl5QIFZEpMnx7rbV+XZqpELPnSS5Oxskh5oHIsXjlmh6VRamuI6JZm0n0zEJ3j6D5XBOd2eDGKTsa14ibSgG7bwrVreIMCBo/Jr8pDorWjkaw8mMFjK9LErVRPRpHgimqf7fqpd1oXVIc9zih+AoO5X36eMzCIoJkfUav0wap2/LQcgmipMqyV/pTJu6fU40rYBZYsrNL5b+n02l4eX+steRBhUNI1/pS+W8eq3wz/dmwqeatwKkcCNrjgSCMmQqH/Tp7d10E1Lcl3w0RMAsnCFwoYPmxrVxgadsFiYFNYbvmKQs5Nv6MGAng7L6aZoaMkP7/UN4JOOV3fhk/BQuDIKES8ZH6xR96dNFbbwKb/Rm1TqaHJ1sKKDwNzLAedeuJQ8yQyisMANmyXdHpdKk+Kw/ZUKbOfWRmdGkwro9476hdxih/yQkCpBWFubsIWKJnQ2D+kL8Ju7f9NmUXeVMqqB3hAjSIj6j70KxD
 9Tzq3h6H
 WebCS9APCRLi+xuhI9Ia4X7a4KWP6ZXJBdPTUuIF7CIEBuItxfe+QrozYi7jhoFxZs7K4y/8UWXhhqXtrGvwy8GjgoUtI52ESxtCRtO9zYTXIBwYqHe0uR2O4jixBB6haCCPJZ09SHHZJcUjqDZM5t9mgg6BvbzoPoxBbaogy/7wxUdTa7kEEhXlvrnAdGCqsoNRCK53MmyYL9YSvja4SLWf43FCDaig/r7dt/ewAfPsqyBrMErDe0TP3cmj+eOdB7q9HJ+tZXB7iYUWSAHqv9xb+Iy2Zte4JV3qLnbMqPdnWt2toJgpkxDymZlQ7cBDfvO3fWzBj2Ibd2UYZma+n8qaHwDofhSiBzkvWCXrluepdiSRznY4vAK+E5+6kolEGuyHuKEirik3QCfsd3vtxgmHk8psbsDNidxsM9PQjZjuCZB4E+lw653wFTW0s0rqyLGIDbSL0lT6dlhwSbOK65FE5vIrsOzI/QmKGjdlqNlCONT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 12:02 PM, Christoph Hellwig wrote:
> Replace out own hand-crafted complete in task context scheme with the
> generic block code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/iomap/bio.c | 44 +-------------------------------------------
>   1 file changed, 1 insertion(+), 43 deletions(-)
> 
> diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> index 4504f4633f17..5b9b91198ec8 100644
> --- a/fs/iomap/bio.c
> +++ b/fs/iomap/bio.c
> @@ -9,9 +9,6 @@
>   #include "internal.h"
>   #include "trace.h"
>   
> -static DEFINE_SPINLOCK(failed_read_lock);
> -static struct bio_list failed_read_list = BIO_EMPTY_LIST;
> -
>   static u32 __iomap_read_end_io(struct bio *bio, int error)
>   {
>   	struct folio_iter fi;
> @@ -27,49 +24,10 @@ static u32 __iomap_read_end_io(struct bio *bio, int error)
>   	return folio_count;
>   }
>   
> -static void
> -iomap_fail_reads(
> -	struct work_struct	*work)
> -{
> -	struct bio		*bio;
> -	struct bio_list		tmp = BIO_EMPTY_LIST;
> -	unsigned long		flags;
> -
> -	spin_lock_irqsave(&failed_read_lock, flags);
> -	bio_list_merge_init(&tmp, &failed_read_list);
> -	spin_unlock_irqrestore(&failed_read_lock, flags);
> -
> -	while ((bio = bio_list_pop(&tmp)) != NULL) {
> -		__iomap_read_end_io(bio, blk_status_to_errno(bio->bi_status));
> -		cond_resched();
> -	}
> -}
> -
> -static DECLARE_WORK(failed_read_work, iomap_fail_reads);
> -
> -static void iomap_fail_buffered_read(struct bio *bio)
> -{
> -	unsigned long flags;
> -
> -	/*
> -	 * Bounce I/O errors to a workqueue to avoid nested i_lock acquisitions
> -	 * in the fserror code.  The caller no longer owns the bio reference
> -	 * after the spinlock drops.
> -	 */
> -	spin_lock_irqsave(&failed_read_lock, flags);
> -	if (bio_list_empty(&failed_read_list))
> -		WARN_ON_ONCE(!schedule_work(&failed_read_work));
> -	bio_list_add(&failed_read_list, bio);
> -	spin_unlock_irqrestore(&failed_read_lock, flags);
> -}
> -
>   static void iomap_read_end_io(struct bio *bio)
>   {
> -	if (bio->bi_status) {
> -		iomap_fail_buffered_read(bio);
> +	if (bio->bi_status && bio_complete_in_task(bio))
>   		return;
> -	}
> -
>   	__iomap_read_end_io(bio, 0);

I think this should be something like:

	__iomap_read_end_io(bio, blk_status_to_errno(bio->bi_status));

Otherwise the error is never propagated when iomap_read_end_io() is later
called from task context. Maybe worth rearranging slightly to avoid the
blk_status_to_errno() call for non-error I/Os?

I was planning on carrying this and 7/8 in the next version of my series
so that the procedural version has users, but I'll send without for now.

>   }
>   
> -- 
> 2.47.3
> 


