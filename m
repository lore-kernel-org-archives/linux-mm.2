Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6599C10F9969
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 18:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D27F6B009B; Wed,  8 Apr 2026 14:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A97F6B009D; Wed,  8 Apr 2026 14:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797906B00A0; Wed,  8 Apr 2026 14:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 682406B009B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:50:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F08541B7110
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:50:48 +0000 (UTC)
X-FDA: 84636280176.27.E182A20
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7009C120011
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:50:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=im1YecM4;
	spf=pass (imf29.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775674246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLV/VVxZXil8J0HLTMUXd1+6JdBH4scZJMZYCy57u0g=;
	b=x/4dQxa77Wt6kDeEu4Yfue/lgiqeDIQCqQ2KzocIx9Hsl2s1r59ygoFPAh20aF+pJb14s3
	ATPXg91dkuJ6QpBcKPKGtB5yBaMGdba+JWcpYartql3PHVggejE3aPIldn/Q/R1e1xuzGw
	l38l0IaJjo5BPSLSkEXaRzOFDxqR8Wk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775674246; a=rsa-sha256;
	cv=none;
	b=5OXvIziAlLkSK/+euLAsSbDd9cDm3ds53jQabqk5z7hUS3bR5DrELE5ymLdM3pdnyrEZZ4
	HO40WtJNjIKSvq3HysDzA0RaP6j+/+mHXgIi5R42Ejbvsxf/+UxpHelX9l9TiGDBkdsbkl
	cR1/mqVAXiP0ENA9wfpPdarzpEPwlio=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=im1YecM4;
	spf=pass (imf29.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638IfvfF3154873
	for <linux-mm@kvack.org>; Wed, 8 Apr 2026 14:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=WLV/
	VVxZXil8J0HLTMUXd1+6JdBH4scZJMZYCy57u0g=; b=im1YecM4tYnwU3cp+l94
	/ilwcemuWi7FpGFRSqYCYA5GZceUKxrLU+c6Fh/L0pc8XlgZuE3LGJDOFTnD9pAz
	xMSVh4/kELzqe4bPmmNRsuuUi4Gmr/sMkpC/BrYfhSYctkb2Mz7+90S8zbrcWXAv
	TIVdwxVWLJ1RjOkjt2+0OLUXZbdzQH65IN6CvXs5loGdKb4hAz29CuJTynbwvDuW
	3TFC24cOvqGRrXKQByQC31IYVJEY47leYIvp5Og4R2DDlO0Yc9wYNYd5XcH60Aow
	xXF95Yfny01hF/UNFGlNYqreBmYhq0E3Vo8Eaimg6aYCLiww08Vd33VvMOAERzIA
	zQ==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3mey8p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Apr 2026 14:50:45 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8a4f18b1b5aso4140816d6.0
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 11:50:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775674245; x=1776279045;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WLV/VVxZXil8J0HLTMUXd1+6JdBH4scZJMZYCy57u0g=;
        b=nMqXSObuNX3QKA14oEXpZjuqHMqFMkKRZQnrpXFrBSvG5/2PbgzztH95iWMTjmTTCS
         wz1d23nNfe3busbjkth9uk98vhxbdx07tkzIGJE9YynW4qpyk0eogIa3hLWwKON2F2S9
         1LE3ZcaqsW+9y9SoFmu3yH9qrc3eKsHy9LlUHA5ARbCh8J6ZajT0N11awvYKltySIPvk
         kE1Tu6kLT7uGKQ5EAMfTygGu8PuozonfNalz65K1gLC0eKPSURQE2Utj/qph6+tvqB5/
         i0JoFkHndFmyPhD3Mxlwqc2P/4nqhg+bZiYDuMkWF5f2tMBml40m1ALI/BHBPygJ5zif
         k6dA==
X-Forwarded-Encrypted: i=1; AJvYcCVXlRwvosTu17POqSG73SMQvIJbFMTSY+XSxkvtDobj1BJpCMSmWhBSIi/d5eyu9H+DDUPJ47OGww==@kvack.org
X-Gm-Message-State: AOJu0Yw9gOtWBcdSWPK2/AJZFf78B8CiYfddi2h8c/ONOmWLI8IXK630
	tmLQQH0CjbvPGpltViTCxoK+kA4RkxorTiCjzPHyJRNG1jhVq5z75SXN8iWjKzmHszDGoVHLt5p
	qC3WLu6wxZz2DTHGTDv6Dnsk35zOLDhMh6i5ecpTgjK8WXSw4ZRet5yiS
X-Gm-Gg: AeBDietewdewC1zckaXvUSOcxupt4A9FOamqZ9KtomgQE5ilMBxxZEKQgIAZ96cAi6m
	jYRHgT5+AA83htOhNMTVOuzgFwk99l+HvA8rlc+JUBIhln60f4qLrAKigmvLcpTU2wbBASGFlrn
	+6uCA57fKJIlFaflOruVS/2t7me/hgXSlv8mF7CfXBDydV3aLejWImyS3U9A4mIzxNPo1vv/nHF
	+5vB1BAHVP+OYtGQvpPzHKLJB8r9AQjaxRSqXQ0ZtFpNV9pUEk6VPfalrDo8ZGSkctcC6f2GxAt
	a4bE/BCJ1CK0i75YVNyMs8DckUPuA4jNIO/ZE3znrxWTo3cPdWZVJeZZnOsjCalBI6G0sQjNx0W
	cQ27JkdchGzzh3Cysuaid8kJkKgxSmgHUcQMg4Bce
X-Received: by 2002:a0c:f204:0:b0:8a0:e086:64d1 with SMTP id 6a1803df08f44-8ac7447cea9mr11723136d6.53.1775674244590;
        Wed, 08 Apr 2026 11:50:44 -0700 (PDT)
X-Received: by 2002:a0c:f204:0:b0:8a0:e086:64d1 with SMTP id 6a1803df08f44-8ac7447cea9mr11722756d6.53.1775674244086;
        Wed, 08 Apr 2026 11:50:44 -0700 (PDT)
Received: from [192.168.129.206] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8aa70136e87sm90361846d6.22.2026.04.08.11.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 11:50:43 -0700 (PDT)
Message-ID: <9fa7a89e-2461-4c58-a2df-d61af60b1b42@columbia.edu>
Date: Wed, 8 Apr 2026 14:50:43 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
To: Dave Chinner <dgc@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
 <acRE8pp6HxjK7Z74@dread>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <acRE8pp6HxjK7Z74@dread>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=OdWoyBTY c=1 sm=1 tr=0 ts=69d6a385 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=JfrnYn6hAAAA:8 a=PFLxJxkoOJ40U2LAvKUA:9 a=QEXdDO2ut3YA:10
 a=1HOtulTD9v-eNWfpl4qZ:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: ukjMgE1aH9klWCQNSM7a_7pc_yleuDC-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE3NCBTYWx0ZWRfX7HpPhFE6/Gcf
 Ra4cqS9uSNwbgnKCthbJme6dj6jhhr1BBT+Elx7fRXycnOxRTBME5xv9G/xWO+ibO4Lg1m10WNb
 sRfI34EwiiXKi/4x8E0ltjSCydzXwWCIQjNaqn+w5wdQOWDb3naFE/q+Mrmypa6PqTsZw7/wRxo
 bqkOEl23ghojoAbypXQWVT+dwhByL27GoAwuBt9wqmdTOB78abmq3nx2nqPA9Hdk8JU4NrKasqm
 h4ma6RAk5Lb2Ao0oMKEfKOH9hBiy0Nk6ZdRl7vDpvHrTCFq94NuWO9bV11Voel1EVkDa8L2HRWv
 M8bQ+VZIPKHqgu0nsKIC5bC9I4CRFdWmhxc3+R/0RAluZqyqKdjYRNEUg/EK1EUeSR9UVdNDKlQ
 nAzVSH03cRgrnAD0EXFY2QXDQYx22+74PdWQz0ykCB+IdMgzp1JqNR0yeUNTLZbovwjqkeL3yvs
 5sLTWYUG74VWZ/lvyFA==
X-Proofpoint-GUID: ukjMgE1aH9klWCQNSM7a_7pc_yleuDC-
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 priorityscore=1501 malwarescore=0 bulkscore=10
 impostorscore=10 lowpriorityscore=10 adultscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080174
X-Rspamd-Queue-Id: 7009C120011
X-Stat-Signature: 1te38amsdfygutq1atte3u83pp57rkmy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775674246-544801
X-HE-Meta: U2FsdGVkX18KNBdXVJc84d+r8lbt+etO2ArZiVWFcmqj+t9rk6kegbCwIekOe87PmVEq8X1eLTeB3umMob0jMuqCtTG1yPBnwBfRvofsByNGRVNOxN0/s1X72SOIFLzutD5sVEGQNOoPk2MSFU7uxyoX+iZN59Nf5KOAkMqcyOwoayeA8gFc3VMXIRfRV1sJ7uslYm0bXfcY+NcYp+ZDyVuPjiw2ZWiU6xDtqCTU0D5EyAh6IMkQDag9Mlt7fi4xjNr7wkrtUQs3nCIHoexEzi2Xg24yggnFaSHti8yuMBuFeSUCig7Pwgo8Xsg9+jqfcD89PF7NLCvrR9l7+UlMDuZvuzice55C5Wbvlr7wSNLoy92IUmVOdG6L7c0B0AmF8Swp6KpYzdVAThN9wwqqwNwzBKsnGTj592xA90/tB/gNW16d+lRl5Hvc4IdgQreAdANv/o+YfbUtcIk1VJnD/RgY1uaL6R1xcEPssE+Dm4MV6WPsOnooQLAsc7emC9Atnb7FGwT0tkw9QkEqC5g00vWWs2dOClZ+IzeCdmokt68Vkcxri4LYXoKa+PmJmBx9WFvRTfxq8J/hzCQ0fkhzvOIT/sHvOz/HgVgRID/5pQgOsCloXtv329ZxKnd5JzkhV1O4+MAavj5k/172zS55Gc5pjCFMVAMC1byNazd8LjayzbGySxQR6k3O+HVbG2rZhVMLLjGqY2qKPpVXdNuMpTuElURHCQ8jU06LMfc//S7mjBxjj5RRHG82MYeazz5aTCvN/4CdW1SiAdhJUSs7h3KEmVAt+1InvAlRUdsl1HK3JHwNSWtKVH0bh+DxIOfIKYP+Fu2id5hlfcekWKcOcKhEj0Bsum1AJi8fvqbQP619gChnIopSvzIffijinH73XGO8apU+YMi0ezdGr77HVGGfhd3xhpmkSh/my4jCPRF8tvwX2SsPHDOK62HMnszPO1uHZg3XhkKFQNrWLmE
 wc1NdzFp
 HY49cdSVvfjkDxHz8YH7wQnH1zsgdB/bSl3gV9kAypTKhGroDBCFlMSCKGLgd3lexk5Z/25sJZX3bKqNwE2gbe4SkTCuQl8Zz5ACb9PJjLhxFPZ3g/AUsdzTvSpW57F01nEXj2QhHPaQ8iG54CAtdQBoCtLEMo/Kbl2QnnsIBMSjvmAZNQLLuWsZvAxIzejG4Ez3Wd/IsjicnF2uB5OcDrBete/qYK2LX2bQ7EAuU6vCJAoLMjjVW1clMA98RByPaBPbEkaegKPUMbU4d83OsvBV9WkDLgqlbYUFxPysHMFGWYT9kAU0aO8kmk7B/hdh5XvO0XYh3jA3ggA5VqXcOYeaVvu08bjmRcASaVg2LVGS4qkm5SkwONmuohitEirajflfM82Ig1n4JSiJNCKoyxMJsTt0QUyvxPFh6m2rem/W6jwfbUQJPNlkZ0sy9Ehz/whEFe76gEBha44dZzq5APYBRzIML0G3aj+tNtR1SkBVpquW6jm7h8h1cDr5tIZLlAzMqMjaoAx+fHf7zopptUz+o1ZjvUg5HFldoy7tlGcBWMl/wP2EALgvjFwWoYNd2ahB5h+2LstW7+fE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/26 4:26 PM, Dave Chinner wrote:
> On Wed, Mar 25, 2026 at 02:43:00PM -0400, Tal Zussman wrote:
>> Some bio completion handlers need to run in task context but bio_endio()
>> can be called from IRQ context (e.g. buffer_head writeback). Add a
>> BIO_COMPLETE_IN_TASK flag that bio submitters can set to request
>> task-context completion of their bi_end_io callback.
>> 
>> When bio_endio() sees this flag and is running in non-task context, it
>> queues the bio to a per-cpu list and schedules a work item to call
>> bi_end_io() from task context. A CPU hotplug dead callback drains any
>> remaining bios from the departing CPU's batch.
>> 
>> This will be used to enable RWF_DONTCACHE for block devices, and could
>> be used for other subsystems like fscrypt that need task-context bio
>> completion.
>> 
>> Suggested-by: Matthew Wilcox <willy@infradead.org>
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> ---
>>  block/bio.c               | 84 ++++++++++++++++++++++++++++++++++++++++++++++-
>>  include/linux/blk_types.h |  1 +
>>  2 files changed, 84 insertions(+), 1 deletion(-)
>> 
>> diff --git a/block/bio.c b/block/bio.c
>> index 8203bb7455a9..69ee0d93041f 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -18,6 +18,7 @@
>>  #include <linux/highmem.h>
>>  #include <linux/blk-crypto.h>
>>  #include <linux/xarray.h>
>> +#include <linux/local_lock.h>
>>  
>>  #include <trace/events/block.h>
>>  #include "blk.h"
>> @@ -1714,6 +1715,60 @@ void bio_check_pages_dirty(struct bio *bio)
>>  }
>>  EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
>>  
>> +struct bio_complete_batch {
>> +	local_lock_t lock;
>> +	struct bio_list list;
>> +	struct work_struct work;
>> +};
>> +
>> +static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch) = {
>> +	.lock = INIT_LOCAL_LOCK(lock),
>> +};
>> +
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
> 
> This is just a FIFO processing queue, and it is so wanting to be a
> struct llist for lockless queuing and dequeueing.
> 
> We do this lockless per-cpu queue + per-cpu workqueue in XFS for
> background inode GC processing. See struct xfs_inodegc and all the
> xfs_inodegc_*() functions - it may be useful to have a generic
> lockless per-cpu queue processing so we don't keep open coding this
> repeating pattern everywhere.
> 
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
> 
> We've learnt that immediately scheduling per-cpu batch
> processing work can cause context switch storms as the queue/dequeue
> steps one work item at a time.
> 
> Hence we use a delayed work with a scheduling delay of a singel
> jiffie to allow batches of queue work from a single context to
> complete before (potentially) being pre-empted by the per-cpu
> kworker task that will process the queue...
> 
>> +		return;
>> +	}
>> +	local_unlock_irq(&bio_complete_batch.lock);
>> +}
>> +
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
> Yeah, we definitely want to queue all the pending bio completions
> the interrupt is delivering before we run the batch processing...
> 
>> +
>>  static inline bool bio_remaining_done(struct bio *bio)
>>  {
>>  	/*
>> @@ -1788,7 +1843,9 @@ void bio_endio(struct bio *bio)
>>  	}
>>  #endif
>>  
>> -	if (bio->bi_end_io)
>> +	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
>> +		bio_queue_completion(bio);
>> +	else if (bio->bi_end_io)
>>  		bio->bi_end_io(bio);
>>  }
>>  EXPORT_SYMBOL(bio_endio);
>> @@ -1974,6 +2031,21 @@ int bioset_init(struct bio_set *bs,
>>  }
>>  EXPORT_SYMBOL(bioset_init);
>>  
>> +/*
>> + * Drain a dead CPU's deferred bio completions. The CPU is dead so no locking
>> + * is needed -- no new bios will be queued to it.
>> + */
>> +static int bio_complete_batch_cpu_dead(unsigned int cpu)
>> +{
>> +	struct bio_complete_batch *batch = per_cpu_ptr(&bio_complete_batch, cpu);
>> +	struct bio *bio;
>> +
>> +	while ((bio = bio_list_pop(&batch->list)))
>> +		bio->bi_end_io(bio);
>> +
>> +	return 0;
>> +}
> 
> If you use a llist for the queue, this code is no different to the
> normal processing work.
> 

Thanks Dave, these suggestions + the pointer to the XFS GC code were helpful.
I'll incorporate them into the next version.

- Tal


