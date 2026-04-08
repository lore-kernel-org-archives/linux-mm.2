Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E743210F996A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 18:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413306B0089; Wed,  8 Apr 2026 14:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA456B009E; Wed,  8 Apr 2026 14:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9746B009F; Wed,  8 Apr 2026 14:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3AF6B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:48:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8313160249
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:48:36 +0000 (UTC)
X-FDA: 84636274632.03.4793EFD
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 359C41C0009
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:48:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=sR4smn5j;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775674114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqueR3VMcaZMrGBpK+9TubzW0DI74xoKUrfLcydSJjc=;
	b=KHXy3d1tp9giLViwqFRDR7QY+mKxHi21zemnBLAiRQdZA9gN9Z3wKaG6/nc3IgPusA+J0v
	DB8/mcGcQEOhNk/c2jUWRSn27CTLDF0p50CRVb1lqojKi6ka5g2ogJdJLsPDGB9c+QtNXT
	glDo++vIlCU2b7/DcKQF5IVjQarmtNE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=sR4smn5j;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775674114; a=rsa-sha256;
	cv=none;
	b=2Cr00XiuN0xzhwJbO4LIOOH9mYz35sOQcFg8yvc2AZHcVIBGZGo77ud1h0IdkJqEZ2ogMB
	XJv/e28H/HT66riBM0CaEBgTDG6LGZFSroVE7d+A5DJ/sxKmMOprV51F1oKZVbojFUjk47
	7OYT8FxkowiwiJ/ANXW3dzHUtyADZHA=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638IfwtZ390108
	for <linux-mm@kvack.org>; Wed, 8 Apr 2026 14:48:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Dque
	R3VMcaZMrGBpK+9TubzW0DI74xoKUrfLcydSJjc=; b=sR4smn5j86SJPqwuEiyD
	tiO3LrwmcnhTzYNq/puVbFVkdQ23hxVuhAkUQf+XO03Laic8F0LMMB0w65VG4DOi
	MjEHK9uj7aeFv/l1TdDJ7gbuo31iIbP5xUFzSH0CJ0T9ITcDfIVwPZDh10am+5b7
	ehPmyJTYiEI9yXGyzY5/G53LdBLNQNKv2p0tRQwtE/byTMVhqGihaAEgsZNWdGjO
	tyt+uX+NZg+/F+Q+Biwz3IinlnvjWz7wEkUB7z/BDtWx7ZoKXZ5ckuDdC944zQRS
	FkzIre59ahDNjblioAHT4fKYGPnEl1A9nuKVn1p4YOzRdPlEyPskoRX4KJ4JK+zd
	rA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3nxu4a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Apr 2026 14:48:32 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50d831e8083so3411161cf.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 11:48:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775674112; x=1776278912;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DqueR3VMcaZMrGBpK+9TubzW0DI74xoKUrfLcydSJjc=;
        b=ACYmcaJ+bGl9FBdX9Jaez58PQN8J0OXOZEmIiybgMRFTeQ7xUj6mM7mCeCIr9n0HeG
         RPjL5c1qIOEnInOpBb7iVcz6yJbUP1AJ6U+I2qccW69KqiSmmnU6zI8vlJf/Zjes06pK
         yDHwU+r1XAelT2Ths57XQieBUAja22W24rwZtnt+tEm01fj9OIblZIBQm98WlcZtufnG
         nyylUBnhZeimb0D4z6xqlaJRluUy0N1rbCm7ifLE5MChul47AW5eb0rAcXJw8XX8tXkW
         PB0CKRFdsX9Y5GY7aIXHhDm1n17rYGG7WIoMqRxjlYaofziyOQhbfSctwhsEI0YGfE2V
         tKXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXr0XvDkcPkgsV0zlYib5vZ4S2BO7uuTeE8Yxq+ZNjMi+f6n/BYdLhcrbZKJH4kR6jK82frovpS3Q==@kvack.org
X-Gm-Message-State: AOJu0YykVDTkP1jUkmYXFZbfhFx3b9svEwsSjawx8daOoesUrbPcMZ+k
	WU4pF8771UiSwDqwjPuUApNUfstFKGEGvN6zH61fCr3kOIxRnKDXq+XJI98j1Bd0F/8E2ZCIAEk
	C1HUccNXYwGW04XZjQtj3aPMjTLkoYZIEHJZJ0Cbv71fPLo22
X-Gm-Gg: AeBDieu2SQ6b7+QUBcWPAvYMnZ1tMlFl35kYnWAnsF9b2FfKPOtja7iK+k4OJN/wia+
	/mtgttWLlBcZVb4aufx033kfRTOTSbIGdGMu1+t81HGy2f06v7zbGjrV5HdIN50SSKmNU9CK/EL
	pAtzFpJETFZgveXXlj3PP2IegLEcjLhO2hpvs31d5wvY3Ga4HFd754zkIq73pUTRUUKa/yiuIB3
	lzLT4wEHN1pE6f/hZXhlwgllFMCJBidDRlWdKzaAQOTtd5eVVxsZzC8fjOomQkVGajlfg5yFmZO
	0HX9T+nNMv/dkDHA98KJ9aiEwy/e99+rYPjj4GUXkyUroXNZkQOTMen40fXvYCB+2WcmA0ls7jz
	qpsGuMIPOKmTp346Ibk69+d9nyn5MdDgcEmSlYg2Y
X-Received: by 2002:ac8:5813:0:b0:50b:551d:ca7a with SMTP id d75a77b69052e-50d62d18253mr330224401cf.52.1775674111612;
        Wed, 08 Apr 2026 11:48:31 -0700 (PDT)
X-Received: by 2002:ac8:5813:0:b0:50b:551d:ca7a with SMTP id d75a77b69052e-50d62d18253mr330224011cf.52.1775674111155;
        Wed, 08 Apr 2026 11:48:31 -0700 (PDT)
Received: from [192.168.129.206] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d5ea136a1sm148904291cf.25.2026.04.08.11.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 11:48:30 -0700 (PDT)
Message-ID: <01e6c582-fbab-40ec-97ac-02675e6a08ed@columbia.edu>
Date: Wed, 8 Apr 2026 14:48:30 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
 <c4453f4e-c1a2-4f5a-b278-76b63d5dc4a3@kernel.dk>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <c4453f4e-c1a2-4f5a-b278-76b63d5dc4a3@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Maz_C1zLSrIzk5I_E60-l02aVTR3dseA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE3NCBTYWx0ZWRfXwGlpiUk21sX3
 sYdOqhcsQ/bFwfhNeEu4hnPOHfkMZqGEvJy3WEYPNuRAjDCG6yiqDa2babd1I0m+Qm+g0KejPko
 bDhY8vR7MceYttvdhLYVniiJ0CwyCBG+ci6Rnnat0KH36qPS+iMtvIuthyRvRefzeXAagqeZvXJ
 xtrIpJMTkS1C2jZmJYVwyOBQsI0ybu9GMWZZz/8ATIfMKJ3F+Kf+2gNJMk9m3o6BHNdPIyf/hEM
 /K4OuliyXYBhOWgUEF+KqNMu6vrqZ4yGItXudNJ+eZXfIlj7Jgk0VNMpyfP/ehhcI7cZ5hxRkuo
 ZoBn0RqF6QAy54tLaSkvMHqVW3KheD7K5/RVMDEybUMcoAkIJ2zo53FL+XLLCDab+0SvcgsN4JH
 6AZwKnoTHuqSLG4xFRtkBoAbarUh5W/2gHuzbk7yEsnt2MOoI1yVN0UQ4v4xcXH7+6wuH9MJUjk
 8jHRNPCMWrmeUelmP9Q==
X-Authority-Analysis: v=2.4 cv=QPRYgALL c=1 sm=1 tr=0 ts=69d6a300 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=Da_CJWPV6nPH503sPTwA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: Maz_C1zLSrIzk5I_E60-l02aVTR3dseA
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 bulkscore=10 malwarescore=0 phishscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 impostorscore=10
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604080174
X-Rspamd-Queue-Id: 359C41C0009
X-Stat-Signature: 8w77rbixwaqrtpgswwbzhhgsra3du86m
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775674114-455741
X-HE-Meta: U2FsdGVkX1+2z4vC4mz/L7eTw0NQz1Ub1NYJPUVyVwYkWnH1WrM6P6hPdPoKhMlRZbcL3IJ1/dAwhMTmEfU0w1UXIWZRL8PxQfj1I+dvraJD3+QbAMVUV+VDOlszIfn66gqo6m1yuKTqghU8IVqVF90q7H9Ral/y1KpPHsjzQvhvsAbf1BQfVB1iy2IhydBkk4WaV30Ica124NGlE3+JGejQe5339lhFJVP2SiNHQrocDMVzJjALbWXxt1o6TO81cr0KeYJFkXmlrRBAnqEPcLemrhqGvSIaakt7C/PNdMMUe2EowvWFMNwWuVV26pXHclUceNbiUl9l7JcHO+2oRRldbHbn5lmMP8tTJmvGLmjKjhW3aMS08J3cegmtY+RMvPjbFMzirCtIgLPB85ibEESbC/L+dOU75J3GMBm4tk7fJmuS5sit9OK84r/ClSfaMZSCoIxTcFq7hKkpFwVop0+vSuCrBxWC4hBr6adyB20/t5HO9dYTRtEgitUTJ6aM3ozfZfc0Yvuegd3G6JKqtK77D3MIaDwQeBF0U2DvdsRLuuymIo81UX1MNPk/sjZuTC6Hh5uiS3dZ9LlH0qsR20aVvnYqY8bZiS5jdD6kn/m3RwA+MsMh55yjJ9yW9TsqfU2fXQ1NbTRc5/yOXhzcz2XmQQaHyHkAuWSOjC5QCwOQpC/XM0ghXLl3xsbfcquI0JAj0nHKjjlb3HaZG0mQz4KaV+wyOMddm7UZEdl1bhuzwHmNs7Oed++juI5dYgkMH0+Unj+a+fPbfc/KpfF6iD+yqRZOzTcSO4TV0RU6FXF5lhhj9ZwPY8PcMazsJ6oX6qPELloSx96MCjDA4aOE8xq4hRinvWbaMXfWDBOzXbxZ1gF/VaFDTGx7egaUMI1YIKKmbqSN9avEDsw2kcrs5G4nxP4rRTJMxceTABd8nMJbLsR+yGEr4mojmStOuAhSAaQyvbCInLBuph2YUug
 MxS5mQBs
 S+OfjAYFXsiIs/yes3DNcs2Er4CXiMHzQE6lyGIsfHB9F97vmhr/hXjtn4qzivspsFJM/lA00CmffspqVX72QcicqcZavKv3M2B7UPYJE02ZjIfp50tUkV220UzMQhTzSQog2vxXsCm4bNHtVsRJzazDmNFtsreNORQUF9WOvIFYNEVmmujSeHWpoxYK1IFw5SGLH/dGlU1SpT0dswayKOCJNHWwIWUJE7nnIVxeCRBCyPTWC/bqHI6TTR7AzoaIZrSdUd1ktB3TS5Py+nup62d4I694SuJhHno+Vcq3MeDIjqVZfA9y/s3DKCmAssPpafwgemWOuS1KJTqOmofdZ6tDAEB/hW2EwPv9UFbXHRqm3JevLxp6JMhWUENd0lvU/lVA3yatBVZ4stc6mNCne4n9BALo76e7hvKYuNpQO7yUd5ecQXctWvGjv83wX09EEdGDaFnXoC91taGqfexolkpJ+02TaeQUntFWKJ9FJXTmlzK3s+nNjYHbRjTOt2eCNVt/bEogtiPBRaMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 4:14 PM, Jens Axboe wrote:
> On 3/25/26 12:43 PM, Tal Zussman wrote:
>> +static void bio_complete_work_fn(struct work_struct *w)
>> +{
>> +	struct bio_complete_batch *batch;
>> +	struct bio_list list;
>> +
>> +again:
>> +	local_lock_irq(&bio_complete_batch.lock);
>> +	batch = this_cpu_ptr(&bio_complete_batch);
>> +	list = batch->list;
>> +	bio_list_init(&batch->list);
>> +	local_unlock_irq(&bio_complete_batch.lock);
>> +
>> +	while (!bio_list_empty(&list)) {
>> +		struct bio *bio = bio_list_pop(&list);
>> +		bio->bi_end_io(bio);
>> +	}
>> +
>> +	local_lock_irq(&bio_complete_batch.lock);
>> +	batch = this_cpu_ptr(&bio_complete_batch);
>> +	if (!bio_list_empty(&batch->list)) {
>> +		local_unlock_irq(&bio_complete_batch.lock);
>> +
>> +		if (!need_resched())
>> +			goto again;
>> +
>> +		schedule_work_on(smp_processor_id(), &batch->work);
>> +		return;
>> +	}
>> +	local_unlock_irq(&bio_complete_batch.lock);
>> +}
> 
> bool looped = false;
> 
> do {
> 	if (looped && need_resched()) {
>      		schedule_work_on(smp_processor_id(), &batch->work);
> 		break;
> 	}
> 
> 	local_lock_irq(&bio_complete_batch.lock);
> 	batch = this_cpu_ptr(&bio_complete_batch);
> 	list = batch->list;
> 	bio_list_init(&batch->list);
> 	local_unlock_irq(&bio_complete_batch.lock);
> 
> 	if (bio_list_empty(&list))
> 		break;
> 
> 	do {
> 		struct bio *bio = bio_list_pop(&list);
> 		bio->bi_end_io(bio);
> 	} while (!bio_list_empty(&list));
> 	looped = true;
> } while (1);
> 
> would be a lot easier to read, and avoid needing the list manipulation
> included twice.

Yep, that looks cleaner. Although do we really need the looped variable?
Can't we just move the need_resched() check right before the while (1)?

>> +static void bio_queue_completion(struct bio *bio)
>> +{
>> +	struct bio_complete_batch *batch;
>> +	unsigned long flags;
>> +
>> +	local_lock_irqsave(&bio_complete_batch.lock, flags);
>> +	batch = this_cpu_ptr(&bio_complete_batch);
>> +	bio_list_add(&batch->list, bio);
>> +	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
>> +
>> +	schedule_work_on(smp_processor_id(), &batch->work);
>> +}
> 
> Maybe do something ala:
> 
> static void bio_queue_completion(struct bio *bio)
> {
> 	struct bio_complete_batch *batch;
> 	unsigned long flags;
> 	bool was_empty;
> 
> 	local_lock_irqsave(&bio_complete_batch.lock, flags);
> 	batch = this_cpu_ptr(&bio_complete_batch);
> 	was_empty = bio_list_empty(&batch->list);
> 	bio_list_add(&batch->list, bio);
> 	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
> 
> 	if (was_empty)
> 		schedule_work_on(smp_processor_id(), &batch->work);
> }

Makes sense, will do!

> Outside of these mostly nits, I like this approach. It avoids my main
> worry with this, which was contention on the list locks. And on the
> io_uring side, we'll never hit the !in_task() path anyway, as the
> completions are run from the task always. The bio flag makes sense for
> this.

Thanks! I'm going to give Dave's llist suggestion a shot on top of this as
it seems like it'll simplify this nicely. Looks like that'll involve turning
bio::bi_next into a union with a struct llist_node.

- Tal


