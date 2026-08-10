Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0CB8C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55806B007B; Mon, 10 Aug 2026 12:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06196B008A; Mon, 10 Aug 2026 12:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CEA66B008C; Mon, 10 Aug 2026 12:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDDE26B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:10:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37DC2A020C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:10:26 +0000 (UTC)
X-FDA: 85085847252.10.7878853
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id A9E07140008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:10:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=CyN46gAF;
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786378223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0bZditIahGukFZnD48c1dgtAdNiTQKz0eXUlzu/oaY=;
	b=ieLW68N/POZoSw60a5ZPxZ9YUdEdtmQRgGuXoO6NQM8gvIbrF/qDzoWqRewPRMc9+mLOA1
	rCp+q+GeTIv5OVn3nHNF6ZMjXX/Y8RkWSuVZqPLmrQyrrTdKqwNU+iYT3UIYzU7D6R/MP5
	HP1ibfOJ8O6JfunM0wGsgIMacShzB3A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=CyN46gAF;
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786378223;
	b=K8lSi46F5oFifxTTVWAgDOoa4u72WLCEqg1cQU/mTXPjwBCbix2oiTNcVTYXXx6FtQQkfv
	dGNuP5c++arsjxMj9quDIOFLSN+C6RzgrHfHmVKdyviGnXjHJMPaa9/sqk9An3yD0YV6Ar
	FQXQWkHm8ixxLMqA+mUzH/7tGZ9xNo8=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AFdRRx3480561
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=f0bZ
	ditIahGukFZnD48c1dgtAdNiTQKz0eXUlzu/oaY=; b=CyN46gAFzGTv5sCQAiJ+
	xhJD7DYCrTeiGETf4yox+1+3CDtlrqNvkTFW4J4vobHmLbXUHDE3doFn2xz6glN6
	k3BaKUBMntJiRVVcyGVM+aPSYqFm+iaf0XYNNoNBeRDmY9JppLG3h/hrnHSqxXvv
	vjK8KVgvBMjsQt6iPYPncBt/4wLvSNnFasjiicrFClgJgyo8becIWZAI0ulxYnrR
	6gWJbEIwkZVX0gc0uqUhLZ6UiI8xM4a2dmU0T4jB029Z7GGdBlXVd/OkAW3bqRIn
	Cc8m/OyKwiMnlPkQ7RPRQxLQ1PMxJu4vRWd97Of20SU/QcoKr4fq6yE9zIqHq0a3
	1Q==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fxv0pwbat-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:10:22 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c07f25de2so16120611cf.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786378221; x=1786983021;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f0bZditIahGukFZnD48c1dgtAdNiTQKz0eXUlzu/oaY=;
        b=A7w69OfH9XJGk89+omsShekxwzb+92CK+j4EHoq5Xo70R215UXl5i+VPjFZRXzL3Ra
         Yra0sG86t3SmPrE+Pfq676LeKnKHXtfHPAJFR+pZwfgLa/nqiMcARvBS8UPURhze1sTm
         dxY05l54/C3y6jWtnZFGv51rR1sn210OV2XkTnkU7Oh6IhwJvxknEw46FbtENh1eo8Cr
         UsYp/ZQ9ENizjBEzMo1nHhxWRd+Z86fiNGr860k3oDMuoBRCEmXBhcSBGmnHzW/5518t
         S9T/FXHs1TTs59cQBzLRbdbSaDLLQxrT4bac+W6Gdxvc2qwqegNXjNC8j4UwsCpr1Dgp
         CnLg==
X-Forwarded-Encrypted: i=1; AHgh+RoEEp9U0FDyJqCDsLWEI1eKQC4o3UJ/p9DPRJdu5IYf0hIT+MMPaDji+6sgW9dIpB3sWKRIIECTXw==@kvack.org
X-Gm-Message-State: AOJu0Yyzxu0QkdhQbax4fIt4Tx20Ssig6wRNNW/8pS95p8Qa4ctf+Atl
	jJWr3i9g+NfeNhxKQ/kULI1rnfGwC+Jv+BqDRdkQcMBtsHTZQP3RCZZb1k3KTyQ5r8oGdqyk+KK
	fmKNLWA+KgIUxy7pSIsLDWZRMpvDMlpAHxc4lo3AL8lvykDEv
X-Gm-Gg: AR+sD123d3Xov/B5OFi/2QopfxGKuvupZNs4CKzkHZ1U9uVL/8Awhdal6OSAiK8W47S
	udkgWdjYPDC8yMMNTGBExxmgiI8CZuIB77P7bePGWBjLyV2YRirrWblNZBqNZ54Ic0S/RXbsp9l
	BKToYeilHyxzQglcbA96uzx6dRkIA/m6aQg3ICxLPPMlo0vmUEbaxM0vXWj9LRD5aF0SOv57nH/
	y4J577vy/M9hw4gq3fk0EkAFrC6INiIYLQp3ljN+5Ksog99wDRr+FMY5UqIS3fmW2h2BcqcDC38
	92uZgNRxam3U9YRt75fDHkO/JBC4Z/yLaMt7cVqTyWYtr62iqOV1pO8VZ1YrWG9Ep0w6d0w/JKp
	P4PAGgODe+rh8GTI3QTcmC5Sh/fOyhNLI4tYe+Qu/g6DS7ThNbB0zow==
X-Received: by 2002:ac8:7fc7:0:b0:519:89b6:78b4 with SMTP id d75a77b69052e-52d20a819bamr234404651cf.40.1786378221626;
        Mon, 10 Aug 2026 09:10:21 -0700 (PDT)
X-Received: by 2002:ac8:7fc7:0:b0:519:89b6:78b4 with SMTP id d75a77b69052e-52d20a819bamr234403791cf.40.1786378221085;
        Mon, 10 Aug 2026 09:10:21 -0700 (PDT)
Received: from [192.168.0.165] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997402a89bsm4159805e9.0.2026.08.10.09.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 09:10:19 -0700 (PDT)
Message-ID: <8eb00a03-d6c6-423e-9768-48fd2566f11d@columbia.edu>
Date: Mon, 10 Aug 2026 19:10:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RWF_DONTCACHE regression fix for xfs
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
 <annkDbhXBEeMoNVT@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <annkDbhXBEeMoNVT@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEzOSBTYWx0ZWRfX5+cYSAzOHr0o
 UaCQTfMOtoFYADNdA0ppbOpDdLhFjjnDvW5X6iXyXah1CXz7A+XD2EkUHG11bthpYfPEIaXNOiL
 OznG1wE/HvvxHKA1k+6auBeg+RjXbbIlWWM+DdsmiLfKL23UJNvQ
X-Proofpoint-GUID: 4Dpujif3J-nm_6mBfwFpTAekJv1N1Mmy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEzOSBTYWx0ZWRfX4ogvijsg3Yva
 7KDxO6nS88VZI5y6j1QsiXgXaF8v8mXytUhur3ANkW0zyLcnABpLFpGBRR+uFuUKJUCjjEaSCo0
 JXssj8kVVN8frsI2ShCxUuaij/9WY2P3cgUOCP9tczT0cnU1PooCt0YFwyaQ0yU17yUZITkqEEq
 s6oSc47PYEeMQLyxJd1gXagFUF4C8RqXW/wGRiWxKOrW018n1jRbjoFKy++T46GveKAJcRPYEEy
 Yb9EPZfrlIZbh32F14oTU4tBOWd84poTHBHo355dU5dPpGLEgK6U/msbTaxEgkwb0S1HqDrvUXI
 xRiM8bEULMK5i2b0tQ1L5flVv6bByzd48yeKhnLCz2kkGt66r+GwQ4kxSIavvhsskGT/rsqPcGa
 +X/DdEYHjfIIImdshZOH1MFkllPPqdzkR8weRG8lpWtho0OOmRftp0yt/zZ8fcZCuLF54SZBUvI
 Gi1NJwUOCjY43vWHBuw==
X-Proofpoint-ORIG-GUID: 4Dpujif3J-nm_6mBfwFpTAekJv1N1Mmy
X-Authority-Analysis: v=2.4 cv=dcuwG3Xe c=1 sm=1 tr=0 ts=6a79f7ee cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=dys9yn6NND9hJ5TNHOUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11871
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 adultscore=0 priorityscore=1501 phishscore=0
 impostorscore=10 spamscore=0 bulkscore=10 clxscore=1015 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100139
X-Stat-Signature: ftpaka6awzftyfgnkffi1qjax1f8eo39
X-Rspamd-Queue-Id: A9E07140008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786378223-725807
X-HE-Meta: U2FsdGVkX1/8EDa3ZjA/yJ1E2RZCOcfndru+aTwgVIqvWHn3OKAFAVvg0WiuX8GqUp4HK4UT1rkx8dxwf2+F6olWCk9Ealx3DVH2A//nKf0ZIL5OsOKc9pU4n0f43+Dua5wa2Vqu/SSX+rOHNdVnU3X2Zwfem+rjvtrCRVcMzl5EY4lXrMj7lLq8sq7ZYQoOCl7jUYv2uLDMLnaRA5EDVvgJgNq8IARArWwtw2lA7uLXMbSE0dYC4zbMgbTiuOy7wMJ9I4FyAnIQpdbbHAmFUWmh3schtReZiFdaqYT4HI1cm24oNIlyyRL4qxI5SOHjgWUk3UDhpbBcuz99wVuKonzV6kvCxH0S6W5QUB5XX92F+g0F65EOtUgJ2O+h4fsrVFafecUy3aRfkcWa2US091tttlroiD77ULtMwRzceZ5x2jNDoisZnl7wVrWJGQIJtsZLq24O2vCSTasyk1hMLpB4DeZ0qIfhDiCisQKVRozkNqzjT83zo+4M2Vz8YukPiDGeqJPV2102VI97bTQswAg1I3MjUKr0SIpiQxvCXVZ5sL9QOKnH9gK/J9XLYMzc5kqWVyvf1wieVUP3AS9VLcTr1BltauNMyE6iVfjRkcLLfZ/Aal3nrrOkD8GZ1QZ23bbEOvbO39NEAMYm14F+MB1YzS0DEl0bfk7BiPdztforNKw+xqLqDm67Rfxuh6WDN1YlbHerfVZ+YUikfPqTEjaO8zztkjoRc9KwYXE6bOMtlKUBWQTLpEOQo3J9zNCOp6aF37B22uhAlYNvXOfA+JIQ1gESdd4g9cNhR3T5rKWVc4etBivQP1RNzoD7FfYL1ovRpba24RLcF2qnEvUfwTOSXvPFSEIBZtIK3U+5Lfm8wb0ODYkiCf4m8qJ2suKrZ3I42lbaneUzuihVru+zgIuQt1a7uF2DUeKe2F2ErFGM3JNMcxTCMpThL5qZsj0PmsMNNajDd1cpvbwuMO9
 qNVcPRjb
 S1rObG3/iQtvWxF/65UZ7JZ4bzOTbrRu1Pa/1FxrhW2h2fVyED85ugM4ue8OeqlwFWwPLZiRJeZsWMjQ8f2i+X7Pjdg2aZWYazNjGyuQ9UmF7rP/ZjFgadWG83afaCFXfweEGsyS5PKyxnpNI/VrGtm8Z5QUHr6UVRmlbhVd9YKvkJW+RSZMy10DfRtOwmcnbfM/VWpoSAtf3t4rAzW/7/krU9Rzyf0ND7ym8tGyDBKoeXM9W/SLyZuSHzEPNuu6ktH549FeW5YzEdyqnvYrKytfEDbZtLSRjAcbeszB1NLoxLhw/LzKYdl0WuojxLNNQMdwzf0XemKI8Uy7gI6Af6t32yqdn09dU/98zaG5AN/Q6QzBXj3ZSyKc6RsMFCiGWzilwlmG7VBwiEmIYeXDIIXKPQKg6F6bK8SJCie3RAru0xzaBwsXO6CKg7IHWJTXcaSDQW0D57s2z6is=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 10:45 AM, Christoph Hellwig wrote:
> Below is Tal's suggested fixup for xfs with the whitespace damage fixeѕ.
> It should probably be attributed to Tal instead.  Can you handled it
> from here and send it to Jens with your signoff/authorship to avoid
> the performance regression in XFS?
> 

Yes, will do shortly. Thanks Christoph!

> From: Christoph Hellwig <hch@lst.de>
> Subject: xfs: avoid double deferrals for RWF_DONTCACHE writes
> 
> XFS already defers some writes to a workqueue when transactions are
> needed to process the I/O completion.  Disable the block layer bio
> task completion in this case to avoid a major performance drop.
> 
> Fixes: efbde6f9f449 ("iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback")
> ---
>   fs/xfs/xfs_aops.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f73e26d9c9f9..059846a8d65c 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -372,10 +372,14 @@ xfs_writeback_submit(
>   	}
>   
>   	/*
> -	 * Send ioends that might require a transaction to the completion wq.
> +	 * Send ioends that might require a transaction to the completion wq,
> +	 * and disable the block layer task completion for them as there is no
> +	 * need to defer twice.
>   	 */
> -	if (xfs_ioend_needs_wq_completion(ioend))
> +	if (xfs_ioend_needs_wq_completion(ioend)) {
>   		ioend->io_bio.bi_end_io = xfs_end_bio;
> +		bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> +	}
>   
>   	return iomap_ioend_writeback_submit(wpc, error);
>   }
> @@ -481,7 +485,14 @@ xfs_zoned_writeback_submit(
>   {
>   	struct iomap_ioend		*ioend = wpc->wb_ctx;
>   
> +	/*
> +	 * Defer all completions to our workqueue as all zoned writes require a
> +	 * transaction to be persisted.  This also means we never need the block
> +	 * layer in-task completion for a task context.
> +	 */
>   	ioend->io_bio.bi_end_io = xfs_end_bio;
> +	bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> +
>   	if (error) {
>   		ioend->io_bio.bi_status = errno_to_blk_status(error);
>   		bio_endio(&ioend->io_bio);
> -- 
> 2.53.0
> 


