Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC1D6F364AF
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 19:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C062A6B0005; Thu,  9 Apr 2026 15:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6E16B0089; Thu,  9 Apr 2026 15:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7E736B008A; Thu,  9 Apr 2026 15:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 955FF6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:06:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 469D0E09DD
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:06:55 +0000 (UTC)
X-FDA: 84639949590.03.0CEFC5F
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9C46712000E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:06:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=SHkTUWBV;
	spf=pass (imf29.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775761612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0TE3BpM0SejjMSyXXnavLwv4WumjR4yqmxJerJDH+M=;
	b=zcFJUTHLd2QWsq+XqH6LbmJbNQ9RqaKhQhh5LwZigjo6u/Mx+6VfuwSaVY66gQrY+6iIIC
	xai030JpLv2tZZ8Y4cf7hxlPc0sFgF3z9m0/LVcAgiVn7kQ0Gvc0uVY/it8wiWgZAEBcOf
	ANUllUyxrIFeEv1EK5D9AMfe04hOQTs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=SHkTUWBV;
	spf=pass (imf29.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775761612; a=rsa-sha256;
	cv=none;
	b=AN049fya3aUw+elTh6ClEab320Z4X4RDwZ+RI/pWkLgEkGEycd+4YXK+GJt92l6qD8Ebnm
	Y/0mTu7TMv9B7kkmlFkVukjKesc2zNjfF3XjTLNCE1bvb4ibgBbZvDsNkNgb3WjWRg9vwQ
	LPGptDaG8Npw/Jtt9FA3BASEgnxzhGM=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639Iu0pr502676
	for <linux-mm@kvack.org>; Thu, 9 Apr 2026 15:06:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=X0TE
	3BpM0SejjMSyXXnavLwv4WumjR4yqmxJerJDH+M=; b=SHkTUWBVb5JV+5wswx/3
	fv3VdJgOn6EtZ9VVGJlmI/22efGQJpycDNew19wu+FXgt7Za/gyUhXJJMlSUYAPC
	29HU3fCO9N88R9N5oxKVh12v49IMAzQ2ew+abamYRLUaNbyZTDGuZKwVmD2GUWjK
	c61x1PU925wali6CMgdXbOXu6Y8+8a3ro2C664uFJUBjm8WCYRkOEumIrCIQm9b5
	RXZIUcycY+g0+4EB2yt/rCBNQcYA28a5aWplv/gv+Qvosr3aC7DvRDl8mT+j24cT
	fpTLl9x8pJbu0ndQochguTkPSfsZ7eqjuVURAQ/IRf1T/QZlRt7fR5cxBARE+yQS
	KQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4ded1gk43n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 09 Apr 2026 15:06:51 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50d984c74a8so32490111cf.1
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 12:06:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775761610; x=1776366410;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X0TE3BpM0SejjMSyXXnavLwv4WumjR4yqmxJerJDH+M=;
        b=tF4B7+xx5eHxU/IOXz2cJrPYG+8g/crNrrDjZFGEZzb5Ni3a3SWFanNKexi8V/Wnqp
         p+uk0Df2LubH7PtSGdq0LhLuoggh2JhRoJZAjWlrjtbtBfvD4cRhkr/2KNrN7jschNXy
         +eb9CWxV49q/vKjQGsYOZ5TI+huwsNhY+GhOCc36IxGfOpRehd16ThHWFtenujOtUaK8
         mnfz5cBQH+NPm224OpnsF/kFbkJEOpN+enPlL64pt0AK9ayYxTOZailjQsL/sMGEKFT0
         AKuRxwF8OheqRbLeUs6ESuiDf05iFAooH5fRs9abLdmEy1IGBzSOFgnAx4w8snnCoVQn
         tuZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDLmMdP3qXeZnP1x5hYr3Ct+piCQw1sW/6thAKZKnbG4y9JXVRStlnu7zOeD9BCY/0zwRu0G+Bkw==@kvack.org
X-Gm-Message-State: AOJu0YyzSoaog0hs79DSexMxX8YlsW8N/PFry7mL5DITI4v1LqHjXY0h
	Yu8GA1l2RfLOjW6TkjRpxVV4plIZIOcE4brwnoNym55H+6iSLfpXf9O25XBJV0J/SNjHBqnDgO0
	uw0YXt4/y3LRUgRvPiSPYLJulqswaNnXyPi2MgoOmeXxdFWCk
X-Gm-Gg: AeBDiev+/hfTlwhLsrdrdUXl9iMlk2xs/tjRyXXqfkSmeeY8sI/pteYnVpTBiV8cV5u
	1WcUPY7Dm2uDqvrbAEu7sC9Fj30eCcEs4rCYD+m8sXlNqp8GBjRvdGNd/bmXERcOzk93TmsYFal
	GEcrIL8gmZm+8BRNEJIkkSJp3QVYU1C/CdCg+rLCxaNzDyJqCjv2J0DGn5GtJN/GTblKvRwqksB
	VyyAuAoNM45v+ltLwxw3EDV0gzezak2kQg9kMU+wfgFYchrrVBM8VDowF+NUHu3GVwi82pV8Qel
	/6Ykdc4MOPbNF5qPkphi1wjGA+LAsr7hpixg3USD6WTWR7aUkWGG+PZxSjcLm5eqmkcDpfdXI4w
	1EvX59Kptu6DH46BHLSe/rxWtT0+AxAKcO+vkQVpI
X-Received: by 2002:a05:620a:4453:b0:8cf:d441:c7c0 with SMTP id af79cd13be357-8ddcefc12bbmr8529185a.34.1775761610143;
        Thu, 09 Apr 2026 12:06:50 -0700 (PDT)
X-Received: by 2002:a05:620a:4453:b0:8cf:d441:c7c0 with SMTP id af79cd13be357-8ddcefc12bbmr8523385a.34.1775761609626;
        Thu, 09 Apr 2026 12:06:49 -0700 (PDT)
Received: from [10.206.71.59] ([129.236.231.31])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb6949954sm23897685a.21.2026.04.09.12.06.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 12:06:49 -0700 (PDT)
Message-ID: <2cdaa767-c071-4e84-b9d7-1c944407f5bb@columbia.edu>
Date: Thu, 9 Apr 2026 15:06:47 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
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
 <20260409160243.1008358-9-hch@lst.de>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260409160243.1008358-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=b7CCJNGx c=1 sm=1 tr=0 ts=69d7f8cb cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=RFpAoTwO7tzpE9r8PTiuXw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=JydwF5vtCPpp8KBJ6BUA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE3NSBTYWx0ZWRfXxu9xibrLCyir
 r9tHp/TQEmvAB6G0ipdyhtVnmnBmSgF9QBMb9pf+Nb0p0mGRr0tVdLDtDr6B1twsJhg+SfEy/UF
 MeZ2HpE0hqhV/xNKXlvWCLFppej0MgzHNaooMpMRHYN9cBGx+RXL9hDumMymxaqSHr86zRlyaZi
 +YkYX/NfqYwcX2hYW4E+C/l4q7NpWw4g5t23bY8ZTipjFREqkqzfvtkPl1CCeR3NpB1d9xlHtLR
 P0N0gJIdulDMy+nuWATPY+skRqjz18zoc4c6gCgCKxqqIp8IWgjEYRUcnnG7F7w3oYxW88e7uhV
 JOlldzSQKEN+Ipi0FfUceU/vNNN1Jqb0DLhJmsJ7/A1GB5v48Xo02ZHqHt7TxI82I8cRoVhoX8L
 pwrpam0K906FV5tx3oL+K7hr5nQ2t0ksSTdhBLRHsqFL+holEDVKWqgK/v8qSToBjRDWdfcbjSF
 iFPj12+KIY4vMw/8qZQ==
X-Proofpoint-ORIG-GUID: gnWhJRg3od8gnYinT3BcpH1IT_hesxSJ
X-Proofpoint-GUID: gnWhJRg3od8gnYinT3BcpH1IT_hesxSJ
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11754
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=10 clxscore=1015
 impostorscore=10 priorityscore=1501 adultscore=0 bulkscore=10 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090175
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9C46712000E
X-Stat-Signature: d34nhazaxn64h9555h9yboumas8g856z
X-Rspam-User: 
X-HE-Tag: 1775761612-620848
X-HE-Meta: U2FsdGVkX18Zu1SRGI2dAUloUPL+gwn8kQXQDBWWyo1rF4IhvvX44ukTIsd+Zr+tWhf6l8cZZIOdrZS7Y/2QePOOM+2KtJcuQs/ePNNDtvV/b0p0cSGAnKzYn/Mw08bm3dT2MpGmwpIiqgM7qjnGRkbXBr1m52E3lG0rHfIQy52mnvYw44XekXPkTHrKEXDkmbbCe15VWvGLy2RrnDizylQPsq9dZwTgOEMvRuvkaoeLzf5x9yXuHMwC08CcCVodugaVLXlRwGaRoI4fuEt8jLc2vtuRTwiboYEJSmwITxdwiUgo8Qoql6v01CRFdaTXb/j7DsSn6thYvB2zTF8bFqT42w9vZW8Kwro4nuvfk6AxKYr8dROVIYaa0Fe051XJWV6W1DccI6QvsiLY2wha/2qy1Yy+FW3D9gf6KovQT8+6nAVEf0ZPESDDIIq3qoK2wmoh+BWEZe/usZbL2pZYU785I0gdh7JNxduI3fersNxeavHYKxIuSdnGWMJue/PUOhwaVf81O9UJsbHN+xcoNhrgiU9Wov6njdK/v8SSpPxyEZQ9t1oczdu4hPu/OHHwhI+yvayMtYsxWsUASwURj3r5uvS02gcrpLnIIvKpibeiWrtcDEWXPTQyFhTqF4gXITPhTfbbNzicb+toiWhFrpJ8IHvlenaN7wW92mU3qtzpmlyHkciKJmK8ZNG8bo9ARv6GIm8uFx7jlsA41xFChNC8onn7gnbf7N0Kh7Ax73jcW4KRvaOc9YjvnY4IxSdst3nQjii5rwJiCPQACRMNvXrDZWtNySmkrzmxKFwMEflQ9Ta2t6M68rJt3NpMvbOH0Z/HnCi9KD5pTalb7nMgm7cWaWDklFEaX/pAIyYQI61MkK8srwFU8Q/sdFm6SWW6MDD4XfBtBvHiB2jpdrpDZ6YP1rG826/bvlo9FH2pVCZF2RZda4J1UO9biH6Tofr5qqWrjUbcn/catNtrkf1
 9aNFdvW2
 q993ZfDWlU332XDnACb0CXPQ2iq7f0Epp4+meQRvaloxXd+0Jie0TLX6y5pq8y58dRugOl5b5eGQgAu7aloi0Sig+yW9rXJF24aRV6iYA5SYFhvJqcGRwyW//vLV28qZ/zclANTljfCRFpiFHaZDW0/9fJHe6KJ30SI1MxBENmEQWtP+X+06AKWYvl7Z39NKJF7TJk8RWckO7mrRGuyWzxfWAuJD6Q0Y4ttXOJ3uPDSJ0rEekPO8SCxV3UfWLYGFPQE22zgxe0yrzXUjSev1kNqRU5iGX5+98FdKSs6buBijhsMNYIWbXbVdwoFxiVdxF1lRWlFXFHHS6XDWCBNcfYq25J9z2RyQTj0S2PTbLLmDaUBhzx/d/NRmKj7g18u1dvxrjs6DRKldQs0GclktLt/onNcZCZ+MyOHIhzgq71qe7KWhKKyUMwHHQUesjKe9/Z4ukW49xfpIUmCsFrXpddxNus6/gJ36nc8D90jP1Hb4+XI2jop5t/ndcUP1wJN5hQvyIScPkMLzihwY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/9/26 12:02 PM, Christoph Hellwig wrote:
> Commit 3fffb589b9a6 ("erofs: add per-cpu threads for decompression as an
> option") explains why workqueue aren't great for low-latency completion
> handling.  Switch to a per-cpu kthread to handle it instead.  This code
> is based on the erofs code in the above commit, but further simplified
> by directly using a kthread instead of a kthread_work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/bio.c | 117 +++++++++++++++++++++++++++++-----------------------
>   1 file changed, 65 insertions(+), 52 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 88d191455762..6a993fb129a0 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -19,7 +19,7 @@
>   #include <linux/blk-crypto.h>
>   #include <linux/xarray.h>
>   #include <linux/kmemleak.h>
> -#include <linux/llist.h>
> +#include <linux/freezer.h>

Why freezer.h and not kthread.h?

>   #include <trace/events/block.h>
>   #include "blk.h"
> @@ -1718,51 +1718,83 @@ void bio_check_pages_dirty(struct bio *bio)
>   EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
>   
>   struct bio_complete_batch {
> -	struct llist_head list;

If we go with this approach, we should remove the newly-added bi_llist from
struct bio too.

> -	struct delayed_work work;
> -	int cpu;
> +	spinlock_t lock;
> +	struct bio_list bios;
> +	struct task_struct *worker;
>   };
>   
>   static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch);
> -static struct workqueue_struct *bio_complete_wq;
>   
> -static void bio_complete_work_fn(struct work_struct *w)
> +static bool bio_try_complete_batch(struct bio_complete_batch *batch)
>   {
> -	struct delayed_work *dw = to_delayed_work(w);
> -	struct bio_complete_batch *batch =
> -		container_of(dw, struct bio_complete_batch, work);
> -	struct llist_node *node;
> -	struct bio *bio, *next;
> +	struct bio_list bios;
> +	unsigned long flags;
> +	struct bio *bio;
>   
> -	do {
> -		node = llist_del_all(&batch->list);
> -		if (!node)
> -			break;
> +	spin_lock_irqsave(&batch->lock, flags);
> +	bios = batch->bios;
> +	bio_list_init(&batch->bios);
> +	spin_unlock_irqrestore(&batch->lock, flags);
>   
> -		node = llist_reverse_order(node);
> -		llist_for_each_entry_safe(bio, next, node, bi_llist)
> -			bio->bi_end_io(bio);
> +	if (bio_list_empty(&bios))
> +		return false;
>   
> -		if (need_resched()) {
> -			if (!llist_empty(&batch->list))
> -				mod_delayed_work_on(batch->cpu,
> -						    bio_complete_wq,
> -						    &batch->work, 0);
> -			break;
> -		}
> -	} while (1);
> +	__set_current_state(TASK_RUNNING);
> +	while ((bio = bio_list_pop(&bios)))
> +		bio->bi_end_io(bio);
> +	return true;
> +}
> +
> +static int bio_complete_thread(void *private)
> +{
> +	struct bio_complete_batch *batch = private;
> +
> +	for (;;) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		if (!bio_try_complete_batch(batch))
> +			schedule();
> +	}
> +
> +	return 0;
>   }
>   
>   void __bio_complete_in_task(struct bio *bio)
>   {
> -	struct bio_complete_batch *batch = this_cpu_ptr(&bio_complete_batch);
> +	struct bio_complete_batch *batch;
> +	unsigned long flags;
> +	bool wake;
> +
> +	get_cpu();
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	spin_lock_irqsave(&batch->lock, flags);
> +	wake = bio_list_empty(&batch->bios);
> +	bio_list_add(&batch->bios, bio);
> +	spin_unlock_irqrestore(&batch->lock, flags);
> +	put_cpu();
>   
> -	if (llist_add(&bio->bi_llist, &batch->list))
> -		mod_delayed_work_on(batch->cpu, bio_complete_wq,
> -				    &batch->work, 1);
> +	if (wake)
> +		wake_up_process(batch->worker);
>   }
>   EXPORT_SYMBOL_GPL(__bio_complete_in_task);
>   
> +static void __init bio_complete_batch_init(int cpu)
> +{
> +	struct bio_complete_batch *batch =
> +		per_cpu_ptr(&bio_complete_batch, cpu);
> +	struct task_struct *worker;
> +
> +	worker = kthread_create_on_cpu(bio_complete_thread,
> +			per_cpu_ptr(&bio_complete_batch, cpu),
> +			cpu, "bio_worker/%u");
> +	if (IS_ERR(worker))
> +		panic("bio: can't create kthread_work");
> +	sched_set_fifo_low(worker);
> +
> +	spin_lock_init(&batch->lock);
> +	bio_list_init(&batch->bios);
> +	batch->worker = worker;
> +}
> +
>   static inline bool bio_remaining_done(struct bio *bio)
>   {
>   	/*
> @@ -2028,16 +2060,7 @@ EXPORT_SYMBOL(bioset_init);
>    */
>   static int bio_complete_batch_cpu_dead(unsigned int cpu)
>   {
> -	struct bio_complete_batch *batch =
> -		per_cpu_ptr(&bio_complete_batch, cpu);
> -	struct llist_node *node;
> -	struct bio *bio, *next;
> -
> -	node = llist_del_all(&batch->list);
> -	node = llist_reverse_order(node);
> -	llist_for_each_entry_safe(bio, next, node, bi_llist)
> -		bio->bi_end_io(bio);
> -
> +	bio_try_complete_batch(per_cpu_ptr(&bio_complete_batch, cpu));
>   	return 0;
>   }
>   
> @@ -2055,18 +2078,8 @@ static int __init init_bio(void)
>   				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
>   	}
>   
> -	for_each_possible_cpu(i) {
> -		struct bio_complete_batch *batch =
> -			per_cpu_ptr(&bio_complete_batch, i);
> -
> -		init_llist_head(&batch->list);
> -		INIT_DELAYED_WORK(&batch->work, bio_complete_work_fn);
> -		batch->cpu = i;
> -	}
> -
> -	bio_complete_wq = alloc_workqueue("bio_complete", WQ_MEM_RECLAIM, 0);
> -	if (!bio_complete_wq)
> -		panic("bio: can't allocate bio_complete workqueue\n");
> +	for_each_possible_cpu(i)
> +		bio_complete_batch_init(i);
>   
>   	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "block/bio:complete:dead",
>   				NULL, bio_complete_batch_cpu_dead);
> -- 
> 2.47.3
> 


