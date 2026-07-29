Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9EB1C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 06:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968CD6B0088; Wed, 29 Jul 2026 02:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A7D6B008A; Wed, 29 Jul 2026 02:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1316B008C; Wed, 29 Jul 2026 02:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A53B6B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:11:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E346C1A0604
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:11:24 +0000 (UTC)
X-FDA: 85040792088.01.FF1C666
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id B9CA0A0009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:11:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=TMkaVCOG;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785305482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u855+fk6kISuaKSmfaV9vv5egbGgNKlzL+lMI+HDIuo=;
	b=UFqZS8sEzD2TAQHwwk7gXXAT0/JffvuH9z1Zj6tPClIJiEvcuLuFKmzQurkCwRTTcIPyo/
	0pYyGsOHFjNFN+rgYRTmcbmfC0+fx1SqOsRAQ9J9xqg9aV+6F7g2GDFeBwua9roG2iEsoo
	SKU7pL7dO4QEy8l/uV+KGtFeNtVcoNo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=TMkaVCOG;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785305482;
	b=FLle7otus86BRTSt1VQszvVVzVv+whwJp2zFSTTveOQoEL+HHjrFmJG+FCQUqMDrTPRHBm
	SItGhQ3oN7q0561kx950zlmOz/hHkHzLdC5FD3O/LizLM3DadzoIq9xACptiMpsXSkw8Xh
	rfpjWjSCmSN6sXPma8SfCKB529cvQ4E=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T5i6NU2998114
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:11:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=u855
	+fk6kISuaKSmfaV9vv5egbGgNKlzL+lMI+HDIuo=; b=TMkaVCOG/I7k1Flsl7WB
	1/4xg5/HFiDiQFPLjuJWN3AiqnVbPUdSlUhzkO0+2PbFTKoc64/HJazFYL+Bk3Ie
	jaUR+PrDYJUmpaynWYN1UqypZxTHko8jlnCRnD63ReiW5R5FDJClh9hHCMtPpeBG
	phTjvZzEeW6qzRJLgxv/5tEdvt3c72MZ6jHL2gt2bQgrN0oM3IDRW/dHrnJrqLlo
	c8YBlycb5MPJRxcbKbsQA08Td001HRFEPibV1SHwiFwuTm+J7ag+AuU4n5FlojHT
	Dn5z1gRJORA9FjapXBYzS6r0QaYg3xNo2fai5itZVSXsVnyOOGbBXhM8I1wAC6WQ
	9A==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fpx3xvrxq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:11:19 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-522de3c645dso11999011cf.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:11:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785305479; x=1785910279;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u855+fk6kISuaKSmfaV9vv5egbGgNKlzL+lMI+HDIuo=;
        b=ihRwLUf9G6tG700v8bp9vNA/2jBgcBBNi3S2AdNt9V/UQEiMH2dgX6F8Dxzgk6/CMa
         AqT0ebAdS3yosuKeSS3087JkJjToG6tbS9yVg5TF5uHdrwwy/vwNJ1Lpz0SqGV5/9zxb
         0EzCg0waxaDR3ZH9nbcMYxMTCrluz6gLdgWpwGlog2+MgY2Ee7MCxrM1nOYlLnaByN42
         vbLxqrtkA7Imoi3pWxrcqR1xtjUSpIJkS7fkQPtgN79MB9aKOePcZep5Jm5VNmebzlY5
         SwDPuAsq/FCtydMwz6xEa/4/g/iDu+GKUWuoCAEX+nUV0ej2utJUNvr/To6xjIGLppSZ
         EM1Q==
X-Forwarded-Encrypted: i=1; AHgh+RqfBPYdl2c0AadVJutMgaqk2dDAjAtXz0huljdbu8i4fYZsWM97XXmPLTiOwXhoPTWqWrGYorhY0w==@kvack.org
X-Gm-Message-State: AOJu0Ywz+6pfjTit29v62hHpKbAQhSuJtGUYOG4O7SCdJT9yApYEYWIh
	ULBNKZcVVzc8OXLPSGdkWvYFo7xVwxfX9POihM+GyD/8uR+K+Fj7C15v44FmyddqkIRw0fPT7c5
	PDynfadunWBIKIGsr/YypXFNICYMNXcFCP+vOslgLEo1Ob601
X-Gm-Gg: AR+sD13ZRkFtrlIwHJJEKPCwsnPymD1GEBsLdxYwWnOI8ECBvZpQpzdGvGqsfe4Mns/
	5Dgfnfzdt7UPZ1Qf33Gp35TFa41XjMXLLkJmAyxxMzEoS5rfVfvZuiq0Ve4M+yQbyZ4k+hQWBMf
	bQ9q9dATJd8FqR6GjALLYvgTN8AZI+qqfPniSKT6tmzL6+FoaXCNN2nOyCEPaW9LB0W/OfYDkTJ
	MgewI/7F7h08mTGz3N6K98j/eEQWWg+hafWGSJqg0Z1m67GkaqHBfl1P4FaLc00KJwKbEvc32CC
	7AM0uIYY3zbdBfbal8+LctievjdSS3K8c/aYqLF/rsa1dDSbMTknZfLV9hsh6+wzpn7rP4Gy0Ec
	LJB6EKniVkOLcHs6XF82AWrEc6V1xlRcafSJSTFh3u4iWn7grgg==
X-Received: by 2002:a05:622a:111:b0:51c:1811:6eae with SMTP id d75a77b69052e-529d70eb754mr49138411cf.47.1785305479109;
        Tue, 28 Jul 2026 23:11:19 -0700 (PDT)
X-Received: by 2002:a05:622a:111:b0:51c:1811:6eae with SMTP id d75a77b69052e-529d70eb754mr49138181cf.47.1785305478580;
        Tue, 28 Jul 2026 23:11:18 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dc890c7sm16972566d6.19.2026.07.28.23.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 23:11:17 -0700 (PDT)
Message-ID: <8124341f-3af2-4a16-897d-38db5ab5a9d4@columbia.edu>
Date: Wed, 29 Jul 2026 02:11:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
To: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
References: <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
 <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
 <ahbq0RdUyLIPiItB@infradead.org>
 <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
 <cuyklvhnt37xwk3jlr2iyyxxkzvt4bsf5iqv2gag4ixdicnbk2@rfqgjlclwesz>
 <4jtsjd2sbsn2w7fzfwb7wwowz72r4kc6345ckkkcjoxjbbwjwn@rkl44x3o3sgy>
 <cc58a101-6d09-4e42-b99d-673271934c29@columbia.edu>
 <amgrwn0yQoFvJP4u@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <amgrwn0yQoFvJP4u@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: y2dCyctvzhXpWEgjMAly4V8oOajzkrIU
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA0NyBTYWx0ZWRfX5myTP+LDGrCX
 BAm+cL7fMBfcr2pDfqZ/sQl+LKl0euzLbpTpzP0R5VZFGc7S0QAjvnjKjIuo5D1XWlkyKFKUror
 P92Xz83lEQdVdBcsHvj4p2aISRP/zZmjkwSEHxmrfVevEQOcGuyn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA0NyBTYWx0ZWRfX8XsjWq96fV0G
 Kv6hIoFSZNG+alF0sEBghR3n0hbVDeR/BO3tXpgGlWKZygK2qOXxYVjSvW/7pMEsH+Ar7kAIYxF
 deIffw1NU4wZYXqMdgDGaUUG8DxQLScpQeojdFyHp8lnkjz7DdcvRd5ndKOPl/9bACs/2qr5wgk
 Icznbm6u2ezypZ8UKtA6L+WWSFtqvjKKXfQzkQIw4FdXD/ZUYVCMKVSskLQnbAwaCQNQygbJ/e0
 qn6KRvL6zHEaT7oDvDge8lYuUQFm9C86iaXKXl5WRM6lM7gjPl3NzVi3U90APm7mk2NhfSfjUkl
 5xJlYbpLSh3ytoLBzsXCcNJ3a7iXEF6eYt6/xwT+x+S114Dfavjsf/KurY5shEPJ1T+3bMB7zwY
 m7TdK1HW/T31O+RcgaMlIm2KCML8UaEtO1joAV8iqMtZLI9h5sm75siUkEZjzkPxJBuyPzeCFpI
 6yYn/CxJtiZlZXaIfGQ==
X-Authority-Analysis: v=2.4 cv=dqrrzVg4 c=1 sm=1 tr=0 ts=6a699987 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=4b9XAn8bT_W39vTbWQgA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: y2dCyctvzhXpWEgjMAly4V8oOajzkrIU
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 clxscore=1015 malwarescore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=10 impostorscore=10 bulkscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290047
X-Rspamd-Queue-Id: B9CA0A0009
X-Rspam-User: 
X-Stat-Signature: sc37z8z48qxuq4mypub64n7durso5nts
X-Rspamd-Server: rspam04
X-HE-Tag: 1785305481-499659
X-HE-Meta: U2FsdGVkX19CISz0Jvth9LSFHTCoHPnrLjHnXe8j327HWlYzd22oC6CSeZe6yOhmjHznPV3qBxZkovjAt/O121lLQmEZhQCsK5noQseqXmV1iWMOkC9fNYQbalptTpsY4MSxX921raU+g+xLDp2+qQsbaGNJDP+TknuE9JcjBJdcZN21IH8nhpFewLD7wmVRQvQYlXJPbHCFD1kkFBznN2PgeRPRWR9ZkFlTNxmeGG+zcZx8Kk3Z/OnnwzXPT5g9oa/A4jOli19SzSmRU6J3Y8dYtOmKrjnvOlGkBZbSVRCCnKugAHvTe+xZOIGw+Qf8rqi6buNG04KGXxuvbvQhE0SEhc+yMd9LLWBOG+w1JN8RF1McA4NkL1qmjqtw1WtS/VaRba8GIXp3tOC23BHkFWZ3AHVU8bpp6htWu7sJSZNL4WgiNzrIcYN2Fccdzb1P/Nm4kOHvdHYreYEUP6k+ySJSAMpuvlZn89zncKhpefG78RH1/z/WgBExwbWjZoc5c+BT6XseJhWOKqe5rGtfmfP8jAaJimzB3iW8utMGhbd2qg0ybF586z+G5TIoh5W2001gp2PizyJ62pDZYUYpfs/Kp1Y9d429VQ9pXGTX8Kp5gt1jrSVVjGzA+2q5HHQ93lqC+f1lVEcAaIIXRatB302APZwAM2Lz7WZyT1jO/NxL13F+34RaavPJjGCmD5oKAMVVYlx+E+AYPXts4rsSGm7ezDkVgwF1C3+Q4Pwes9yWiT4bIqJS7oXz/gTV+VcpCdBKhAnEv/BWAi6rrd62hycV2Bqb8XpZVKMPKxUofoasUe0Y9ZqCsXs5R85DFXMK2pgXNO0sJCXAmbd5Ey50a1/i8xS7Xtd9KqiV1TT5qztTOIG+vAoGq3OP9Xve6M0CK9xnxJPORRsoEwQWSHiS0i1qY4Z5S7DTdPWOwi9op5qDKb5eTkKDxbs7bX/IuDnWSfOrxxXFyK9pzxEqICv
 kmAaofod
 kMSDU22h0BH2/63UXVURFEOmKhJGtIToBKFUaJ6pajLqvNxSJQA6bYvmAuw2GVNdSF/gI9yUVuuD4r61pX7gBzvfijG0AwnKLmOnkMnEB6q/iLoAMfD0gInmZk2/EaGTmTZCOU9if5Fq6KhgkddPgeaGF4PDazn5fCPnb/1ZfbXOIRQcUWHKzzKTjZ8RpdH+uHeyvuJJktSpUe3DV74kQWUQVTbMVVPMOXyp05MHTb4a8dtBW3NSE3B46EjsbeQ9s7cRJ30RujQx+0EaCKxIi/wcvNsBpe5mXnVkcZRlQWHzKyNr4ZiPrAWb8QI2dkiqijcsOhV3VdMW/SUk2BShJjbJURzHB6diWOpwBEYYiLM0ShBCAVghJyXKGMmhTF0LBUnhH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 12:10 AM, Christoph Hellwig wrote:
> On Mon, Jun 22, 2026 at 12:45:25PM -0400, Tal Zussman wrote:
>> > 
>> > Any progress here? The patchset looks really promising so I'd love to have
>> > it completed :)
>> > 
>> Sorry for the delay - got caught up with some other work and had to set this
>> aside for a couple weeks, but haven't forgotten about this. Planning to pick
>> it back up some time this week.
> 
> Sorry for another ping, but we have a lot of code waiting on this
> kind of infrastructure now, it would be great to get a version in.
> 

No worries, and apologies again for the delay. I had some deadlines and
travel that kept me busy, but I have some additional results below:

First, I investigated the workload C behavior further. The underlying
problem is that ioends routed to the XFS completion workqueue were also
carrying BIO_COMPLETE_IN_TASK, so unwritten completions bounced through the
block-layer worker (plus its delay) only to be queued on
m_unwritten_workqueue afterwards. The ioend workqueue already provides the
task context the flag asks for, so something like this avoids the bounce:

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -552,8 +552,10 @@ xfs_writeback_submit(
        /*
         * Send ioends that might require a transaction to the completion wq.
         */
-       if (xfs_ioend_needs_wq_completion(ioend))
+       if (xfs_ioend_needs_wq_completion(ioend)) {
                ioend->io_bio.bi_end_io = xfs_end_bio;
+               bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+       }

        return iomap_ioend_writeback_submit(wpc, error);
 }
@@ -664,6 +666,7 @@ xfs_zoned_writeback_submit(
        struct iomap_ioend              *ioend = wpc->wb_ctx;

        ioend->io_bio.bi_end_io = xfs_end_bio;
+       bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
        if (error) {
                ioend->io_bio.bi_status = errno_to_blk_status(error);
                bio_endio(&ioend->io_bio);

(Diffs may be whitespace-damaged, for illustrative purpose only)

On a fresh-file run of workload C (every completion doing an unwritten
conversion) this stops conversion-heavy writeback from entering the
block-layer deferral entirely and cuts write p50/p99 by 7-8% (3381 -> 3151us
/ 6761 -> 6193us) at equal bandwidth. I tested a sync waiter workload on a
fresh file too, and it also hit this even harder: a 4k write+fdatasync loop
goes from 2.0 to 17.0 MB/s with this change on top of v6.

I don't love this patch, as it feels a little hacky as currently
constructed, but the perf impact on this worst case is substantial.

I also implemented (a version) of Jan's suggestion of only delaying the
completion work when the offload rate hits a threshold, and tested it
against both delay=1 and delay=0.

We keep a per-CPU count of completions offloaded during the current jiffie
and dispatch the worker immediately unless that count crosses
BIO_COMPLETE_BATCH_RATE (16000/s per CPU, i.e. 16 per jiffie at HZ=1000):

diff --git a/block/bio.c b/block/bio.c
--- a/block/bio.c
+++ b/block/bio.c
@@ -1749,10 +1749,15 @@ void bio_check_pages_dirty(struct bio *bio)
  */
+#define BIO_COMPLETE_BATCH_RATE                16000   /* per second, per CPU */
+#define BIO_COMPLETE_BATCH_THRESH      (BIO_COMPLETE_BATCH_RATE / HZ)

 struct bio_complete_batch {
        struct bio_list list;
        struct delayed_work work;
        int cpu;
+       unsigned long window;   /* jiffie that count refers to */
+       unsigned int count;     /* completions offloaded during window */
 };

@@ -1784,16 +1789,27 @@ void __bio_complete_in_task(struct bio *bio)
 {
        struct bio_complete_batch *batch;
+       unsigned long now = jiffies;
+       unsigned long delay = 0;
        unsigned long flags;
        bool was_empty;

        local_irq_save(flags);
        batch = this_cpu_ptr(&bio_complete_batch);
+
+       if (batch->window != now) {
+               batch->count = 0;
+               batch->window = now;
+       }
+       batch->count++;
+       if (batch->count > BIO_COMPLETE_BATCH_THRESH)
+               delay = 1;
+
        was_empty = bio_list_empty(&batch->list);
        bio_list_add(&batch->list, bio);
        local_irq_restore(flags);

        if (was_empty)
                mod_delayed_work_on(batch->cpu, bio_complete_wq,
-                                   &batch->work, 1);
+                                   &batch->work, delay);
 }
 EXPORT_SYMBOL_GPL(__bio_complete_in_task);


I used 16000/s (at HZ=1000) as the threshold rather than the 1000/s
suggested. For async completions the 1-jiffie delay would at most double the
latency, but a sync waiter that can reach the threshold instead gets stuck
at it. Each deferral adds a jiffie, which drops its rate back below the
threshold, which re-arms a few ms later. This has a significant impact on
the qd1 fdatasync workload below (W1). My main concern is that this turns
out to be device-specific and 16000 is too low for faster drives.

Results are below.
fdatasync latencies are fio's sync percentiles. All three kernels
include the xfs patch above: delay=1 is the current unconditional
delay, delay=0 unconditional immediate dispatch, and gated is the diff above.
C and D are the same workloads as in the previous results.

                                 delay=1     delay=0       gated
W1) 4k write+fdatasync, qd1 (~14k completions/s)
  bandwidth (MB/s)                   2.0        52.6        52.5
  fdatasync p50 (us)              1990.7        69.8        70.1
  fdatasync p99.9 (us)            2965.5       118.3       119.6
  context switches                  212k       4.17M       4.18M
  cycles                          13.8e9     119.3e9     122.2e9

W2) 64k write+fdatasync, qd1 (~10k completions/s)
  bandwidth (MB/s)                  32.7       657.5       655.4
  fdatasync p50 (us)              1974.3        82.8        83.1
  fdatasync p99.9 (us)            2987.3       137.6       136.9
  context switches                  403k       3.30M       3.30M
  cycles                          22.8e9     144.9e9     144.5e9

C) 4k buffered randwrite, qd32 (~118k completions/s)
  bandwidth (MB/s)                 649.5       655.7       643.4
  write lat p50 (us)               215.4       214.7       216.1
  write lat p99.9 (us)             703.1       984.4       730.5
  context switches                20.69M      21.98M      21.44M
  cycles                         922.5e9     838.1e9     911.3e9

D) 64k buffered mixed r/w, qd32 (~11k completions/s)
  bandwidth (MB/s)                 761.2       753.2       757.2
  write lat p50 (us)              2605.1      2637.8      2605.1
  write lat p99.9 (us)            4358.1      4358.1      4358.1
  context switches                 5.99M       6.92M       6.92M
  cycles                         399.0e9     414.3e9     414.4e9

On W1/W2 the delay=1 caps a sync waiter at ~500 syncs/s, since every
fdatasync takes a full jiffie. The gated version never fires on either
workload, so it matches delay=0.

For C, delay=0 regresses write p99.9 by 40%, while the gated version stays
within 4% of delay=1's tail.

D is similar across configurations, but adds +3.9% cycles and +15% context
switches vs. delay=1.

Again, my main concern with this approach is that 16000 (or 1000) is a
somewhat arbitrary value that depends on disk performance. If the C p99.9
perf is an acceptable trade-off, I think we can get rid of the delay, but
I'd appreciate more thoughts on that and the XFS diff above.

I'll send v7 with the rest of the changes (Sashiko review, etc.) in a day or
two, pending any additional feedback.

Thanks,
Tal

