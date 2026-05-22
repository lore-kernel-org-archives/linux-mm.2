Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70936CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 23:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF3386B0093; Fri, 22 May 2026 19:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA4D6B0095; Fri, 22 May 2026 19:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8F06B0096; Fri, 22 May 2026 19:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 88B8F6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 19:10:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B65AC24BA
	for <linux-mm@kvack.org>; Fri, 22 May 2026 23:10:06 +0000 (UTC)
X-FDA: 84796600812.26.D1D7C17
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id A5575C0006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 23:10:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ajmjPiss;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779491403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dDWh6Dh7CO21d9q3MhBCeH86IkvYOU13lZmvzOI+9/A=;
	b=wQGjugqXbz5Q5de1ogAHGTGWVXW6bBq3UhBasDeHyQceYw+VoXN9KO8w2cDA9d1NkYe2mM
	p9zQ/XEFwnySclhhr+18lEieliklP8HGIQZoMDtg6tcc+zIUTbzTf89IoG5hmUCSSf9JfO
	1xLi+NtIBubA3o7vG+uDgu1iNGkmWX8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ajmjPiss;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779491403; a=rsa-sha256;
	cv=none;
	b=3lAIaYs6HqmMIQEEFua+kNVtGaIsOtVB5uut/uA+bcl2UjZLCfY/MnHo2YIjIG4WWJ91gp
	mSYSHje1zGWgE01hyS2NUZ4NNFqhfhxv77xO28OJjTCUAHTCJ0odUSfeIif74E0HnhTBym
	udb6nnY2AjoQ2GD7mz3t/cyi26NVTMI=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MMS8uY874916
	for <linux-mm@kvack.org>; Fri, 22 May 2026 19:10:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=dDWh
	6Dh7CO21d9q3MhBCeH86IkvYOU13lZmvzOI+9/A=; b=ajmjPissWjpyXLr/vZXu
	zq8Z77zJg2cNWNY9gYDMPHcZtBEJwS0mxuEnLvhXReIUVIMYt22PlUWI0bOaGZFB
	+GRLyECvgOEmOvfQPPX9M5sWF6kUyybK/S1CAy9avnLcaVtm11hSGWfSfGTAbq35
	347K0vKIPDvDhrm1oQ/QLHuj0xwxcJEC+1E8T21Uzdc1/n8rlP7t5gczNkdrZtXh
	vuxSd3obWfDn8R9bs7YDAW2BbKqD+mv6B0igUq6e4bXwDInwMg5eMLH5nLH837Zf
	sUxaO/LVeYrURhusIGU/d+2u6Ra7U9BDcFRknpWaEnuod8lROXS2GgfV0z4KxGM5
	IQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4eat0hav22-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 22 May 2026 19:10:02 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-514ae0e3ad6so198309711cf.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 16:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779491402; x=1780096202;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dDWh6Dh7CO21d9q3MhBCeH86IkvYOU13lZmvzOI+9/A=;
        b=LhUV7k11zJj9H+Tivb1xK1ZDRi8pePzuPq2tgKQV15kxDhtXRkcHdBJwp/04o70Z6a
         G2f+mFIQax3c8mMSawE66zl+Jav9HmtZ1Q3BqjT9P5CF52a4ypbjVr+Bpwb/qQd2/jFf
         lakEnLr5jF+uGRWdUxa0LgcvGdAsf1Xti0OO5EkMyPPrYBUB+ctI8Xoqn4WHdyCF59+U
         AeTKsvkLHJu1fj+gIR6Hi9I/oWblxZFg+98nJMpMkodBjj2Qgvpiot1/6pe601gmodzh
         0aJOF85OdOV8G/ujWh2DeYcEtEgGvE4tIoJY+GUuFK+S7oRxd+C5lYdnwDefE9mChbFP
         Yd3w==
X-Forwarded-Encrypted: i=1; AFNElJ+01tSjbbvckiscYYlHK0TDPkvM3oyAHfFKOCGRyhUqwQjdjMZhhz2dB5BhHiNA67F6nGlr0Uj14A==@kvack.org
X-Gm-Message-State: AOJu0YwFITFErKuEUCGR5blPaMIqMA8R7ZxfVj8Jpd1ZJ9Y05nGuQDxW
	iO8J3StxLPGSsgVl2Ba1lMcsueXOhueXS0PtnX+b/JBKuuONSwC1cWTOkZUr6rs7rpMczGYnTlo
	W+nj6a8XUzD/FN5g9I20PCXEwNsYgeU6tBivskY3VK+oTRp86
X-Gm-Gg: Acq92OG4HAHWXJORyvidwmTCpC1LNyW/KKDYJPF1mPDLSYAwOfRY2OjfqSzVkQ/eeLm
	Viq4SUgkj6caaF5uMCpngRfGY1OKWdVhZvEbuXMLnsbg4tEebA3arDHXKB7Bbb4/hrP3cWrfAmx
	AsPEJg1gcyRflSYAjVpblWesETRqGeCFbwdGyhzup1KGribBee9V7mD0331sbxtlxMSMuBFl3dY
	AfK5MrbVvkTICcLOefbREVbay4RM4CKLe2uQWiYkrfdA1WYWtn5ZTrcAG3u157wNDO+9uswoBNO
	y/Vj75HxrU2ieaXK04V9BIB48sEup+yh6eI/w1qqrHmV6ZDLNVO6Mkopj+XXR+Y7O4lF+W6a9Mj
	YRkgNoMhHLXgQbdEKtX0O2R1Hpt8uOzgEKLlanAAixl+sWfiOxNxvelatYHz27mzKI1eJfSqSZ3
	0=
X-Received: by 2002:a05:622a:110f:b0:50e:600a:638c with SMTP id d75a77b69052e-516d573f74fmr62658891cf.17.1779491401789;
        Fri, 22 May 2026 16:10:01 -0700 (PDT)
X-Received: by 2002:a05:622a:110f:b0:50e:600a:638c with SMTP id d75a77b69052e-516d573f74fmr62658321cf.17.1779491401082;
        Fri, 22 May 2026 16:10:01 -0700 (PDT)
Received: from [10.207.65.224] (nat-128-59-177-214.net.columbia.edu. [128.59.177.214])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516d8cc6212sm26448231cf.25.2026.05.22.16.09.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 16:10:00 -0700 (PDT)
Message-ID: <ea6fc01f-5cb7-4a04-9f92-bbd2791fea51@columbia.edu>
Date: Fri, 22 May 2026 19:09:59 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
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
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: yGLQRD0U-grZxzXvgwo2HfoIzDJwN6pI
X-Authority-Analysis: v=2.4 cv=f6l4wuyM c=1 sm=1 tr=0 ts=6a10e24a cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=n4JpGxNP30DHW88kdRRHAg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=c92rfblmAAAA:8 a=iwgvYRDhkiyaR0dmeYsA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-GUID: yGLQRD0U-grZxzXvgwo2HfoIzDJwN6pI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDIzMSBTYWx0ZWRfX51FksJAe5K/U
 AR3X81iA1QpKw2LtpWqPxdvHoGZgEf2kYc3sewmdcd81Vei1h+74Mwk70hOOvw8H5aZt/AI5no0
 5n3VW3N0j0wrdfDfRW8Bng0YQaM4DZabj+j+ebxkKNIGaPD7iMtt1/1BxrfeqMlOEKATQigBPGE
 lcihqUjARKerBOtv9eVEYkRPr0dWgd9z4YsYYaoiFASMyQoJtpVsQlnXA7ewSrYC7lXXFIZrIsN
 WIc3fPP9p5UDgPkx9mInKsoBGJ1ZNsxBIfWL4OIdi+A+OaOJlBpBgnmoBuXGIL2n10pobl6zHTm
 E/lo/Ff93ekDMZvT6l0vdUGhOodduZcr1TwDdRPy5GmEtEqzg2Pz7QgsvT8WAuQ9sJvUG4WIOAb
 A5I2CUJ+mrKpQuVIEmOjhrP+BD4GUOXILMavpPi6Wtj8IXcPEmrPRfGQWhF2ImjKa+oY1JMAnPz
 YWv2vFANRUJUkTgeqBQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11794
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 clxscore=1015 impostorscore=10 malwarescore=0
 lowpriorityscore=10 bulkscore=10 suspectscore=0 priorityscore=1501
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605220231
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A5575C0006
X-Stat-Signature: mgegr3nkeabei3mqqs8z8qs3unct6ddx
X-Rspam-User: 
X-HE-Tag: 1779491403-189701
X-HE-Meta: U2FsdGVkX18aGxJHe4KeXt462aq5pmApNb8s2k1Q5gAyo5HMA4tVf3xqsk0WUmwXvyjRe9hkmVIG2awSlkjScs36yg/I2l0NkiNBwTBwIQYX2UaRuWjddxWphXSNsYA2bsXwcVOEXMMP37s//3ZzHqW/8m8zNWF1LgcddKyQgsmLE8A/DVt24yj0pcxOTxTP3wntyJQNfUQH3bAFhuxDLuQ89JtsWKm0zAY4moKb/poxu+vgrV+OnnHfeQzz0LHsnhSCfPH/AFMF5jdAwrimp6QCVDrycQ7lYx1GDNZZj42+sRG01h8+8UWscBz1ky1uhXfoBdFKXw2PhPz5Yxji++SClMMQePeJl7U3ruNRZAZVUjB6DGSuPkblZbE+ehA+KWOCRSCZvyiH11WME5cG2fiGCS0jEq8XDSG91wR4AEejvAnK+SPssn6/cK4gn+C45SilCfpmFB3nVn9ubSidbBC2zeHXolWm7oIr0jBsVS0WfBYWOVPQ+55Tev7FHSh+8MI0jB/YE85rAtVoNOppxMScA32Au1uB84pC6Y4ps+8auyxMwtgIY9X6ekK9dp1GGiwJm9CohfbQztuf9PrRaJFS8O5pBSeGwPNKQKxYH+gw6KkGXth7KABpc+z63Q5a3JIs+Q+NbH3lxZQumBEW8Nwlk+5EnHlBE6vIAI0UXqodarwC0I+FIGUf9DhRkanJg8QFUs203F26algHQEn+mvn06MYRaTS3FLdHku9pPUDtKtUaswitreOfvncnDfIBpfwCsy2LZXxeQl8+vUkssMt1Onfmr9njmgB+0Q2d5W4Oxns7taCZ6KePhDgZHNe8ediXBEQI4B5/jfmqXadUrws8N657Ehu0JUJwpOGIbcIrN66x5ykkscBIhic3Zvjutm0I+1iZ3y8qRr15rZL2Qbe3MM2evWZsW3aG0KzefnQa+0kyvXK7fKElQKPqWIrGfn/ANmihrYSkshfb/4K
 oP999SBR
 fOT8OuvvDb/w4EHtFFh86C/vFRddYtrN03LfwM/tEIpzJUhNTwcyMcTS11ZZ+sfUgnOJskZ+oOvhtVNIFNJM9T57+UIbYULq0Poo35hzN0s1B+ONoGqZORCMxCcHST9IT2LwmAffYszZ5WutQyj1svqLN3wNZil2n84h3MPYGJqmIB32qUISNdihnLwWA5TELNxwqNlNmXjarYYRGixyOZ/z1tshqX1hp7PC7dEhqwlwOQNUZlnsVsDhQ3GWkc4T3I2krWf+rF/Db+8/dbnCL9o+UbKbnuDwL/Uh34gsPVePxbAtBfyivAodASSiUs81IV6HjIfWGpiNXriYk2xppKc4rBlMYxod3BJCmCrDSudnCyFU5k5sgKgk4AsKMb++cHOE2ZLmn+9hL8Xw9/RM81oAPsRkcmLGoELLFHqTLiPNMEBwPI0W7BVxQF+11mOQoLGBcGOnDE2ccJsPYZOiHw7LBsQsVOPdAy9LuaAytWwiO3qzZiVw6RIVVmtf32me9Lj4H0HbOk7Uy70ht2BZMGnAADfOXn9KzCQwt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/14/26 5:51 PM, Tal Zussman wrote:

Responding to Sashiko review inline:

Link: https://sashiko.dev/#/patchset/20260514-blk-dontcache-v6-0-782e2fa7477b%40columbia.edu

> +static void bio_complete_work_fn(struct work_struct *w)
> +{
> +	struct delayed_work *dw = to_delayed_work(w);
> +	struct bio_complete_batch *batch =
> +		container_of(dw, struct bio_complete_batch, work);
> +
> +	while (1) {
> +		struct bio_list list;
> +		struct bio *bio;
> +
> +		local_lock_irq(&bio_complete_batch.lock);
> +		list = batch->list;
> +		bio_list_init(&batch->list);
> +		local_unlock_irq(&bio_complete_batch.lock);
> +
> +		if (bio_list_empty(&list))
> +			break;
> +
> +		while ((bio = bio_list_pop(&list)))
> +			bio->bi_end_io(bio);

Q: "Does this code handle bios that do not have a completion callback?
If a bio is submitted with the BIO_COMPLETE_IN_TASK flag but has a NULL
bi_end_io pointer (like some flush or discard bios), executing
bio->bi_end_io(bio) directly will cause a NULL pointer dereference.
The synchronous completion path in bio_endio() checks if bio->bi_end_io is
non-NULL before calling it. Should a similar check be added here?"

A: Every bio that reaches this point should have bi_end_io set. There's no
point in deferring a bio without a completion handler.

Q: "Could this loop also monopolize the CPU and cause latency spikes?
Because the work uses a 1-jiffie delay, tens of thousands of bios might
accumulate under heavy I/O load. Processing the entire batch sequentially
without yielding or calling cond_resched() inside the inner loop could
lead to scheduler latency or watchdog warnings on non-preemptible kernels."

A: With PREEMPT_LAZY as the default, the worker is preemptible, as per 
Hillf and Christoph, so this is unnecessary.

> +		if (need_resched()) {
> +			bool is_empty;
> +
> +			local_lock_irq(&bio_complete_batch.lock);
> +			is_empty = bio_list_empty(&batch->list);
> +			local_unlock_irq(&bio_complete_batch.lock);
> +			if (!is_empty)
> +				mod_delayed_work_on(batch->cpu,
> +						    bio_complete_wq,
> +						    &batch->work, 0);
> +			break;
> +		}
> +	}
> +}
> +
> +void __bio_complete_in_task(struct bio *bio)
> +{
> +	struct bio_complete_batch *batch;
> +	unsigned long flags;
> +	bool was_empty;
> +
> +	local_lock_irqsave(&bio_complete_batch.lock, flags);

Q: "Is it safe to use local_lock_irqsave() here when called from an atomic
context?
On CONFIG_PREEMPT_RT kernels, local_lock_t maps to a per-CPU spinlock_t,
which is a sleepable rt_mutex. Since __bio_complete_in_task() is specifically
called when bio_in_atomic() is true (which includes hardware interrupts or
execution under a raw_spinlock_t), attempting to acquire a sleepable lock
here would trigger an "Invalid wait context" lockdep warning.
Would a lockless list (llist) be more appropriate here to avoid sleeping
in atomic contexts?"

A: This seems legit, but I'm not super familiar with PREEMPT_RT. I don't want
to switch to raw_spinlock_t, as it seems like that would add unnecessary
overhead on non-PREEMPT_RT kernels. I think switching to use local_irq_save()
(as is done for the per-CPU bio allocation cache) should work.

> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	was_empty = bio_list_empty(&batch->list);
> +	bio_list_add(&batch->list, bio);
> +	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
> +
> +	if (was_empty)
> +		mod_delayed_work_on(batch->cpu, bio_complete_wq,
> +				    &batch->work, 1);
> +}
> +EXPORT_SYMBOL_GPL(__bio_complete_in_task);
> +
>  static inline bool bio_remaining_done(struct bio *bio)
>  {
>  	/*
> @@ -1791,7 +1865,9 @@ void bio_endio(struct bio *bio)
>  	}
>  #endif
>  
> -	if (bio->bi_end_io)
> +	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK) && bio_in_atomic())
> +		__bio_complete_in_task(bio);
> +	else if (bio->bi_end_io)
>  		bio->bi_end_io(bio);
>  }
>  EXPORT_SYMBOL(bio_endio);
> @@ -1977,6 +2053,51 @@ int bioset_init(struct bio_set *bs,
>  }
>  EXPORT_SYMBOL(bioset_init);
>  
> +static int bio_complete_batch_cpu_online(unsigned int cpu)
> +{
> +	enable_delayed_work(&per_cpu(bio_complete_batch, cpu).work);
> +	return 0;
> +}
> +

Q: "Could a CPU hotplug rollback strand deferred bios indefinitely?
During the early teardown phase (CPUHP_AP_ONLINE_DYN),
bio_complete_batch_cpu_down_prep() disables the delayed work. However, the
CPU remains active and can continue completing bios. When these bios
complete, __bio_complete_in_task() adds them to the list with
was_empty = true, but mod_delayed_work_on() fails to queue the work
because it is disabled.
If the CPU offline operation is aborted, bio_complete_batch_cpu_online()
re-enables the delayed work but does not explicitly queue it. Because the
list is no longer empty, any future bio completions will see
was_empty == false and skip calling mod_delayed_work_on(), permanently
stranding the bios."

A: This is legit. The solution is to requeue the work if the list isn't
empty on CPU online.

> +/*
> + * Disable this CPU's delayed work so that it cannot run on an unbound worker
> + * after the CPU is offlined.
> + */
> +static int bio_complete_batch_cpu_down_prep(unsigned int cpu)
> +{
> +	disable_delayed_work_sync(&per_cpu(bio_complete_batch, cpu).work);
> +	return 0;
> +}
> +
> +/*
> + * Drain a dead CPU's deferred bio completions. The CPU is dead and the worker
> + * is canceled so no locking is needed.
> + */
> +static int bio_complete_batch_cpu_dead(unsigned int cpu)
> +{
> +	struct bio_complete_batch *batch =
> +		per_cpu_ptr(&bio_complete_batch, cpu);
> +	struct bio *bio;
> +
> +	while ((bio = bio_list_pop(&batch->list)))
> +		bio->bi_end_io(bio);
> +

Q: "Is it possible to hit the same NULL pointer dereference issue here if the
bio lacks a bi_end_io callback?"

A: Same as above.

> +	return 0;
> +}
> +
> +static void __init bio_complete_batch_init(int cpu)
> +{
> +	struct bio_complete_batch *batch =
> +		per_cpu_ptr(&bio_complete_batch, cpu);
> +
> +	bio_list_init(&batch->list);
> +	INIT_DELAYED_WORK(&batch->work, bio_complete_work_fn);
> +	batch->cpu = cpu;
> +
> +	if (!cpu_online(cpu))
> +		disable_delayed_work_sync(&batch->work);
> +}
> +
>  static int __init init_bio(void)
>  {
>  	int i;
> @@ -1991,6 +2112,30 @@ static int __init init_bio(void)
>  				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
>  	}
>  
> +	for_each_possible_cpu(i)
> +		bio_complete_batch_init(i);
> +
> +	bio_complete_wq = alloc_workqueue("bio_complete",
> +					   WQ_MEM_RECLAIM | WQ_PERCPU, 0);

Q: "Does creating this workqueue with WQ_MEM_RECLAIM break the local_lock_irq()
protection in bio_complete_work_fn()?
When a workqueue has WQ_MEM_RECLAIM, it spawns a global rescuer thread that
can execute per-CPU work items during worker pool congestion. This rescuer
thread executes unbound, meaning it could run on CPU B while processing
CPU A's work item.
Since local_lock operates strictly on the currently executing CPU, the
rescuer thread on CPU B would acquire CPU B's lock, while popping elements
from CPU A's list (derived via container_of()).
If an interrupt on CPU A concurrently calls __bio_complete_in_task(),
it will acquire CPU A's lock and modify the same list without mutual
exclusion, potentially causing list corruption."

A: The rescuer should run on the same CPU, not unbound, so this is not an
issue.

> +	if (!bio_complete_wq)
> +		panic("bio: can't allocate bio_complete workqueue\n");
> +
> +	/*
> +	 * bio task-context completion draining on hot-unplugged CPUs:
> +	 *
> +	 *   1. Stop the per-CPU delayed work while the CPU is still online, so
> +	 *      that it cannot run on an unbound worker later.
> +	 *   2. Drain leftover bios added between worker disabling and CPU
> +	 *      offlining.
> +	 */
> +	cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
> +				  "block/bio:complete:online",
> +				  bio_complete_batch_cpu_online,
> +				  bio_complete_batch_cpu_down_prep);
> +	cpuhp_setup_state_nocalls(CPUHP_BP_PREPARE_DYN,
> +				  "block/bio:complete:dead",
> +				  NULL, bio_complete_batch_cpu_dead);
> +
>  	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
>  					bio_cpu_dead);
>  
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 97d747320b35..c0214d6c28d6 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -369,6 +369,38 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
>  
>  void submit_bio(struct bio *bio);
>  
> +/**
> + * bio_in_atomic - check if the current context is unsafe for bio completion
> + *
> + * Return: %true in atomic contexts (e.g. hard/soft IRQ, preempt-disabled);
> + * %false when a bio can be safely completed in the current context.
> + */
> +static inline bool bio_in_atomic(void)
> +{
> +	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> +		return true;
> +	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> +		return true;

Q: "Will this cause an infinite loop of bio offloading on kernels with
CONFIG_PREEMPT_COUNT disabled?
Because bio_in_atomic() unconditionally returns true without preempt count
support, a dynamic call to bio_complete_in_task() from within a bi_end_io()
callback will always offload the bio to the workqueue.
When the workqueue executes bio->bi_end_io(bio), the callback will evaluate
bio_complete_in_task() again, which will return true again, creating a
permanent offloading loop."

A: Legit issue. This can be solved by changing bio_complete_in_task() to:

static inline bool bio_complete_in_task(struct bio *bio)
{
	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK))
		return false;
	if (!bio_in_atomic())
		return false;
	bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
	__bio_complete_in_task(bio);
	return true;
}

We can use the BIO_COMPLETE_IN_TASK flag to indicate that it's already
been deferred to the workqueue as is safe to run.

> +	return !preemptible();
> +}
> +
> +void __bio_complete_in_task(struct bio *bio);
> +
> +/**
> + * bio_complete_in_task - ensure a bio is completed in preemptible task context
> + * @bio: bio to complete
> + *
> + * If called from non-task context, offload the bio completion to a worker
> + * thread and return %true. Else return %false and do nothing.
> + */
> +static inline bool bio_complete_in_task(struct bio *bio)
> +{
> +	if (!bio_in_atomic())
> +		return false;
> +	__bio_complete_in_task(bio);
> +	return true;
> +}
> +
>  extern void bio_endio(struct bio *);
>  
>  static inline void bio_io_error(struct bio *bio)
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 8808ee76e73c..d49d97a050d0 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -322,6 +322,7 @@ enum {
>  	BIO_REMAPPED,
>  	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
>  	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
> +	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */
>  	BIO_FLAG_LAST
>  };
>  
> 


