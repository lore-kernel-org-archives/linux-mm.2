Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB34CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7AA6B0093; Fri, 22 May 2026 18:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A588D6B0095; Fri, 22 May 2026 18:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9207C6B0096; Fri, 22 May 2026 18:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C25E6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:47:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27DE81C06D0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:47:50 +0000 (UTC)
X-FDA: 84796544700.24.1BECE9E
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 753E7180004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:47:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=vFpYLWSb;
	spf=pass (imf24.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779490067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TT8glPTJWpZIUOrxyHUumKTmUNTeW5g1ZoNuE+A9ihg=;
	b=D742AxAuhm9S4Ch2YHg/fel072PwwGue4fi9nK1Xc0GajpVk211l0xTIPl3uFou1blQ81k
	TxlXzUQfO+ueU5uoW3IkQJPdd0JhbuNFCGByuUn/xEO80yCFZm3XsT41SPVwJ/+hVKPVIv
	o5IIolQfCg/387dm1acOMku0BtLeKzw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=vFpYLWSb;
	spf=pass (imf24.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779490067; a=rsa-sha256;
	cv=none;
	b=ZJ7o4SLMkLG2rrBICJWTEm7QUOMxDAo4dBlAQu5REkGEHtAtOlc3YU+G0fmVvDzlaBs2ZP
	+vZpUUPD1C8F+5LRhobhAUtFEYkRh3cQav6356s/llz77e1XAZnS/CbuTLgGttE3UX46KM
	znGJ1WusYx4ZAPmBx43D1SJ8Gj/Grf0=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MMS5621915254
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:47:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=TT8g
	lPTJWpZIUOrxyHUumKTmUNTeW5g1ZoNuE+A9ihg=; b=vFpYLWSbBpFKJ85ciFEi
	u2SR/IdqoXjnN6kLyLFAjIYNXlFduNAnKzlEOJyqebGO0BXFOXjsCKKQJvRpDhUH
	aUpuTGjW4y5shIkVkdDenX3gvbQPh7KZhgEc7Hc9vmM/v9gxlvZ3XsuWfoK58UbO
	vrXMR30AVDvhb9znjiDddAxgzDhPpb0AbCsj0BEwoahpaDGgnCWx3G+WBTDbFEXh
	YAtoaNiOY/hYZBSdZmzrj4AAJ4rTdfh2MY+l1WWXcYKdOY+FTwg32JJcgVrKzrxm
	fz3jOddrfZIJJZdVvcWgGxEk0/qjEKpkEhlr2iPrthjaCzM9KuhM1MTjfH79+HsB
	/Q==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4eawwu0ry9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:47:46 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-514ae0e3ad6so197895941cf.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 15:47:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779490066; x=1780094866;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TT8glPTJWpZIUOrxyHUumKTmUNTeW5g1ZoNuE+A9ihg=;
        b=siW7qOFPT2zyB4Zq9p4jrUgpfVNy7BbWOoX2nyb39cgiYJw0q4GtFRBUy+sgYkhZWo
         HsGyHiXbmC5UgblT9opeaW6DopDPts3Pg2Pi8av/iXN0w48yvtO/QnxtfK9vG2loqUJW
         yPW8fHdtGoSDHa5VULk64FV4i1zarEPcc9TmOcXgMVBJimzQxEqGOFd+WlNnofY1tETo
         /zVdYDEcy5utOG96mLOQM5sSUgWJHz66wolZz36s8J+bPt4cQ0NJ3K4rQLpwbJUTdpmQ
         tFacIU9vClLdkiAYE8B9fpYgHdTfSHKqUlHtRQjvclZFn3RzniMDuiT7BhoMAj2VAvvA
         VR6A==
X-Forwarded-Encrypted: i=1; AFNElJ+RWkrWhI/9sS/6TAHrQVRQizrlpD8o2qMQTpiNaKyHBEtqQMOfBe54Ckp7Gn29ZZTQwrLkWTcVdw==@kvack.org
X-Gm-Message-State: AOJu0YyEg+ulSwKudPrILrrVV9I8MmdNTaPyruqMtD1x/DLxMneYrgDo
	gOmeg7h038gCk3vz/3JiNET6CmSJG9W4OfQOd8V8bMpXO6LueHjqdfO/Fb6XIHCayMY5tPP6fC3
	DlJbW+veSQqVO1kb7WbnBxfAwWx1yrDR5XrjKAd99VWe4R9A6
X-Gm-Gg: Acq92OHqjzNtoOg6kNr2vjlkrZRUCD8T7StRpxE2LmVmR+OIZStNagSPzSagWpus9vy
	Gob3WJ9Oe+n1gpC3jtnBA7+NsMgsL+mqdaIAn8jWq79nmbhXjsk75rQGQhB2mkYgqgLXqYpxQK3
	opVNQuBtlDYdcIhvMKi6GX6eO3bX7uSN3br4BU8I+llLAkUF0XCGdCgCnk++IRV7PHfi5246uZR
	e40cyRJMhi7nG1HzU+ZosRTkBLJyqcL9cuO7NVuyq+P1pYYt6Ryucgm+//00Jk6esZ6gnNMczs8
	KMwWJAGMLOSXbwzb0Tzyn1wSYAOtNyNaqBH74+PJZgueiwhp1vKikBGgadBTthxrBZDx+f0Yb9X
	z7tc2u2idS9IB3Hm5sH1YcpQjYPiH4WLIVEAOz/q3e1IubCKelwDqTUJ9yZ+y7i2O8CG50UhjiT
	uW1n4EexMKIA==
X-Received: by 2002:a05:622a:647:b0:50d:987c:8174 with SMTP id d75a77b69052e-516c54ce3famr103506801cf.4.1779490065808;
        Fri, 22 May 2026 15:47:45 -0700 (PDT)
X-Received: by 2002:a05:622a:647:b0:50d:987c:8174 with SMTP id d75a77b69052e-516c54ce3famr103506511cf.4.1779490065251;
        Fri, 22 May 2026 15:47:45 -0700 (PDT)
Received: from [10.207.65.224] (nat-128-59-177-214.net.columbia.edu. [128.59.177.214])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516d8b00143sm26022671cf.3.2026.05.22.15.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 15:47:44 -0700 (PDT)
Message-ID: <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
Date: Fri, 22 May 2026 18:47:43 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
 <agq2KRd8RkP1TAf5@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <agq2KRd8RkP1TAf5@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDIyNyBTYWx0ZWRfX9WPatTNWdJ92
 EChkYOQehL9f/3YIo9yvdVXE+LP8TZD7h7b5HSvpT0fTHnq2wf5O4mjW+fU/t5M882TcekMe7Dr
 XRwWwL0UxPsjvb3IIe6NZH/HXrkgVwdlH2imzjhH8EJIoh7Y9ojuvIndkbSzv7Zjgk+6vFR05rd
 LjJDQdA5SEUbght7s7SpJFizkWQj7Tp4gaJNEWD1RFvIDqRoD7bNktUc7XspAjD5AhqrpwHB8wO
 g0HR7umm75tWqsKKlCu3jQ4SM8Uiz75XnvzNaFi39DErHH4LGtixRaod7kEh/tHskzf3CKg3+Pt
 Q6Y0uvVBKalud00LrSPOBf1bmMobbrk5o2QzeoP1/fmtE40xuuKPKGegSFXHln62ZiQrL/BUU6P
 uvktmRbafF0j+iKuQKcGE3I2qBvF4jkL1LWiABfxuKn4jv7HLHmJHca/wzs9A3zHFAk4xvnOv9q
 C3avgD4evFiVImPIhCw==
X-Authority-Analysis: v=2.4 cv=a40AM0SF c=1 sm=1 tr=0 ts=6a10dd12 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=n4JpGxNP30DHW88kdRRHAg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=76MgQrUCaxHmrnKOjHwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: Z3lntH4KmxoJFCJfh9jlXv4DsmxDb4s5
X-Proofpoint-ORIG-GUID: Z3lntH4KmxoJFCJfh9jlXv4DsmxDb4s5
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11794
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=10 clxscore=1015 suspectscore=0
 impostorscore=10 adultscore=0 phishscore=0 bulkscore=10 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605220227
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 753E7180004
X-Stat-Signature: fnxqxfwyn8xyc4rysf88rmkp7urjfgup
X-HE-Tag: 1779490067-538374
X-HE-Meta: U2FsdGVkX1/4ktAqY/3ZJiMtWO1R90+LushvbPhnLdgn4T1Z5W5SS82NgGAeOfyRH35MnGwjAAWsFi2nw1gF/k4cc7zI2LLKC3EhdEFwvLiwaPetSvTHl7kUnI7sDizWZSVDl/4Ng37vREg6hyD6S15PJR/U9eTon5worE3CgK1a+DrQcuEH4MvMJ7sWalFfZwHYRc/AcoxUg7KZs/SOJfJcmFPF0FpL2mIRwWWPEFxgcWP6nyA1LbGa37bVRB+1Fv51qpeMdYk++VF8fwrhKIDvHZqpzBUiti0g7jDw09+Ekzru1klHmfugaAPRmp4eb2Dh2P6vz65yaSB7wb5afVpuSOC7jYLvbEW/in8bucHE0TnxEb9EVCxhHiz/bURdVLBwEtALBH0+kSof4AgI2pLGAyWXZHUNEAyOKBTFz3wUBkeVZcWRx3Iu0xhzpwpGcFR2h0DF4umpeVslT81z+VDok6ghIN3KLtKbtFWeGEUSejLvgVIZb2/0N9yHK672sgX9u5k9w4Oq9zEN3zfEHrhO/efRYLck1V6TlRwCORiwHbVLoW/LHNNVCaRQqo+xyU8wZFb1YhzIocRsaS6XUKxJkb6wLGs3wsWWiGuT9KdHqAJ7Jj8flOajZ+upSNEyMVMIqKY+R2pLi6LvCQ0oZBmarPzIqDCquVKlSIvKtrPZ19y4vSmpBa0pfGiysDn5nA0UqWOrktE0JXopDxFpnXAEPXmkqYlKzFvbsjmyyQwt8QdWIq+rX58jGaO+aOePUbd9ZAWIOYlBLNUu23Vqnp/dnSslu0hZ+U7Rcby0BPsAzcFKsV6fqIhN2KqfmdKDk9nId7poeuyY5K0IvGv3/ov4J2LKnzAuZ5KDrkaU/cQ6zqy9O1J4ExxcqLGmNJnScpVwZPjcLiMWdr0lIlnunqdhUuxJ8gikl+1b4iN+sedC1VZH8DH3hm8bdXx021y4G8Mm74JmlomtG/6h/HZ
 sCCXshYB
 7TSAsH5xtWfD94951pytTqNrgJxeKsGUFS2zTrOoViopml52NO3bo8s6e76ytKN5kcpolg9w1wSnD2HuHkYN+a5Xg0ril4CtCM6jwkZEBWR+vAY+jAx6zi//OpqCy8J9ECqRF57yHMRrzm439aUnYg2iiRmHqoocABdSU7iHCBHtQB0lSXgQkp1zJfrGB9m8o36mGr68QNaSAu9nOcyfamPgpljLMN+/FDEwEZcrmP/cx3p/lGgDH+TdaI8BzNFbqnuAYET5PykaAXwLgAicfW6mIXd9sBMPSydgOS+5wSNsTuUt8aSEA8QrYURc1VYbITx5Dut8ulxRHvdntnWlMORsrhEfZugfRMJjcwLhTu9X+x2yXRaxTi81S0Iij5YerVEFO1hOTkiqvP4dozSULB0QWmh2JhO1Die2JO03Bw1T0E/yc/7SZZpDwQAERf1Lxr+8Rz1jbSOlNnmrGjogNjJc1XnK6AAFVfhWilz2ZJ6F8EhJEmLtkXZ5dTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/18/26 2:48 AM, Christoph Hellwig wrote:
> On Thu, May 14, 2026 at 05:51:14PM -0400, Tal Zussman wrote:
>> Some bio completion handlers need to run from preemptible task context,
>> but bio_endio() may be called from IRQ context (e.g., buffer_head
>> writeback). Callers need a way to ensure their callback eventually runs
>> from a sleepable context. Add infrastructure for that, in two forms:
>> 
>>   1. BIO_COMPLETE_IN_TASK, a bio flag the submitter sets when it knows
>>      in advance that its callback needs task context (e.g., dropbehind
>>      writeback). bio_endio() sees the flag and offloads completion to a
>>      worker automatically.
>> 
>>   2. bio_complete_in_task(), a helper that completion callbacks can
>>      invoke from within bi_end_io() when the deferral decision is
>>      dynamic (e.g., fserror reporting).
> 
> Note that method 2 is unused as of this series.  I do plan to add users
> ASAP, and at one or two could even land through the block layer in this
> merge window.
> 
>> Both share a per-CPU batch list drained by a delayed work item on a
>> WQ_PERCPU workqueue. Producers push the bio onto the local CPU's batch
>> and schedule the work item, which then dispatches each bio's bi_end_io()
>> from task context. The delayed work item uses a 1-jiffie delay to allow
>> batches of completions to accumulate before processing.
> 
> But this 1-jiffie delay also means we unconditionally increase
> completion latency, which feels like a bad idea.  Do you have any
> measurements that show where it does benefit?  Note that queing work
> already often has very measurable latency on it's own.  This also
> directly contradics the erofs experience that even went to a RT
> thread to reduce the latency.

I added this per Dave's feedback on v4, where he noted that XFS inodegc
uses a delayed work item to avoid context switch storms. There's only a
delay for the first bio in a batch to complete, as we only delay when the
list is empty. I'll run some experiments and measure context switches,
completion latency, etc. to see if this is necessary.

>> Both methods are gated on bio_in_atomic(), which returns true in any
>> context where a sleeping bi_end_io() is unsafe, including
>> non-preemptible task context. This logic is copied from commit
>> c99fab6e80b7 ("erofs: fix atomic context detection when
>> !CONFIG_DEBUG_LOCK_ALLOC").
> 
> Let's not copy it, but have a prep patch that moves the erofs logic
> into the block layer under the new bio_in_atomic name.

Will do.

>> +		while ((bio = bio_list_pop(&list)))
>> +			bio->bi_end_io(bio);
>> +
>> +		if (need_resched()) {
>> +			bool is_empty;
>> +
>> +			local_lock_irq(&bio_complete_batch.lock);
>> +			is_empty = bio_list_empty(&batch->list);
>> +			local_unlock_irq(&bio_complete_batch.lock);
>> +			if (!is_empty)
>> +				mod_delayed_work_on(batch->cpu,
>> +						    bio_complete_wq,
>> +						    &batch->work, 0);
>> +			break;
>> +		}
>> +	}
> 
> Ån all mainstream architetures we now default to lazy preempt, which
> should remove the need for need_resched() calls.  Do you have evidence
> that we actually need this handling on recent kernels?

No evidence - I added this per feedback on v3, but agreed that it can be
simplified.

> Otherwise this looks good to me.
> 

Thanks - AI review found a couple more small things, which I'll respond to
in a separate message.


