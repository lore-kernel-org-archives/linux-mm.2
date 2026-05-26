Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FCECD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 19:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97016B0005; Tue, 26 May 2026 15:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47866B0088; Tue, 26 May 2026 15:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936396B008A; Tue, 26 May 2026 15:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 846C96B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:29:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 238411A0487
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:29:35 +0000 (UTC)
X-FDA: 84810560310.23.196D77E
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8962E180003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:29:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=CJmfJgDF;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779823772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eF+K4idBW/n0FbUPDI/65dz93xILVqw4x2CBPyoeCog=;
	b=lCJzR+HaOcMKmBt7JKrqrCzUJYeD8daL4PV37gaNcJ0kODT4XK5ZEDp3zOQnaE4cH//Yz5
	4S85A064mJBRD9N5R5cQ3TfaDXBsqUZk7OMEmWSfwpyqzYt66NcyNshQDJCP8zpOtdVuQI
	kHZlZyM6f/BSBdSH7LZxUVW2jPq5lkM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779823772; a=rsa-sha256;
	cv=none;
	b=ar3dknuq3XA2voUXoPyKRR3FkAM//uyZ+qVipMnJFa7mrvRJjEuvli9mnHuV8lFR/VJmQv
	USjXQHpTI5Du+1L+KvXKneMgyCuDz2Tz7QlTe7qr8GAyjHX6X0caGHrOBDPPW2EjGLCned
	dhTiAEZEs1z2dfOiI7DalkkWtCP6s/0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=CJmfJgDF;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64QJOXvv2319013
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:29:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=eF+K
	4idBW/n0FbUPDI/65dz93xILVqw4x2CBPyoeCog=; b=CJmfJgDF9wkJxW8aXSyQ
	0B+hZoErmDeQkinFJzySRXNs6xQEtaVCnU/03iz2lLkrvD+TPU+eGuO6BuRKPSB0
	5UFPLgMcbTTx2GZBbnnAPvW9kCmbr9JyGfOAucCDObHMEgI+fKZzCeyXAeODJZhw
	B261pEN5ksJXXIYupmyxejPqEeo6LKxF2BBGHyCrm4K3duQa7cl6dIAP+2JoxWv3
	Ny1czsoCe7fBznDDMfPUpF5rF6tqDB6QUgPlStwfcWZ6bgtyonMJtDFrguqjrFQW
	UD0HtYAGaejf9lFFUAoUShDSeOJJXoMPJnzFHmLlgZzcjYO0BvyxwecxPqdXRO5X
	DA==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4edev6hnv3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:29:31 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8cc616cd846so64429526d6.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 12:29:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779823770; x=1780428570;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eF+K4idBW/n0FbUPDI/65dz93xILVqw4x2CBPyoeCog=;
        b=HdE5ZuBhTc62/1Tq9LnXX+Elo+wvMdK/u2BZHhm9GARrJS+lGLXgrK9hKKbEiUUftP
         lUrXApu1OXOVXR32mRRyuIo7gJlsK9MSu98p0Fj/JPj8AybJM3uOgYW/zyGR3TNBXj08
         9eEBsuOovH6zg/5jfg16maCA2c85PNTAAYgZehTcGaHDFLYTsbcHW+n+Q/qblk4O/qXq
         NplXlFvr5FtzH8w+OJ1VvCjrqaKnNuTYuNw7L8TLI8+2nVotbboWv0SOLCMtJPracZr0
         /FhoAs79tJ8x+tl5upE83GUb0hUa2/RaXYbl3Q2g/8s2qgquPAdacw1wJ3qA++OoVoax
         JQog==
X-Forwarded-Encrypted: i=1; AFNElJ88BFqLigWO8wRA1GFn80OwAfoQ+LLK5ft3Ghg+o76krGqc5+EVo3lxpiTE3U/FmpEHEX2M9dZBqg==@kvack.org
X-Gm-Message-State: AOJu0Yz5UQzka14st3KC+7Ix7ZtR1ok9edBl02OXXPVZXmXQcgLXk4nG
	18q53QKX794u2vYyHCnyIrjmZRcjkogTMSdThdoPj03Cv1BqpNVjJJ59emMRX+Ar85AX4F87l+o
	PrmR8LthmE2X3vcuudr3EgQNdYltTNvHRP7hE9YEH9gqnH4wC
X-Gm-Gg: Acq92OGPK5mIg3CJorntTBw6qxfiaEOeWEtx/z7xXdG4tlRD/aszUKFd/vJbRa3B/YB
	bfPUuK6mjMwnR3TcuPGVK1qlubIEgMGRNOu6CKlSKRDPE9Gytn14siUCjj7UvMf7tfVRidv2pfb
	xmsHLv3ivQScPlylOmsaqLHrf5CB8Phs9n2HeyoBfKix5PsuyrJpno35FhIkbLH0p3SQRikXHF0
	AasWapLfvBXgSxioxPK4k4DA8lpwpFaasWxBi0IPFNpsux+Do41RJueQYq0s7bQ12oHLpdkuWRT
	Lun26xKynYxAriLwxcy7llZebpVaFNp5BxS0iCpMDiAAu5c96CBj2jrTHFFMpkeRVzwJmxgzFX4
	tCM/aW/PwQP+LpfQWz4thU2VzJZwalBsP02fV4VJc6VX4K6OJMsL8uxRNJrKBLGcLv0Wcypo=
X-Received: by 2002:a05:6214:2dc7:b0:8cc:6aa6:704e with SMTP id 6a1803df08f44-8cc7b51c1f6mr303884596d6.11.1779823770169;
        Tue, 26 May 2026 12:29:30 -0700 (PDT)
X-Received: by 2002:a05:6214:2dc7:b0:8cc:6aa6:704e with SMTP id 6a1803df08f44-8cc7b51c1f6mr303884056d6.11.1779823769667;
        Tue, 26 May 2026 12:29:29 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc80ded529sm149485386d6.16.2026.05.26.12.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 12:29:29 -0700 (PDT)
Message-ID: <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
Date: Tue, 26 May 2026 15:29:28 -0400
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
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
 <ahPbaSEoNA755Nt3@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <ahPbaSEoNA755Nt3@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDE3MiBTYWx0ZWRfX9tKIhKOulgnc
 RElaDKN1nHs8wrIDImKPPLqEheXvfh+jpkidF82O13XJY9BJC2s5jj1HYmwiGYamlnmDjLZqBd8
 EO8ndy5nJWlLCZRSzL45LHSMGebiqrSa+dwfNGbAljNbDguQ1EZqPoutyb6h3jsuCfDhnSB7QiM
 cF/7VOz05tLRiE9df61eBtp0GcF2AdyhiEJSKxCTK2W1j4nNjrt47HzH45G4E2FuArjKzl4W+Pc
 RtAgeQ68Olo8RqTV9esRNt8J67hWHtTZFu8FikXnTMZyu6DXT+B4oKUUolMlnmY3aQKtuFlwMSg
 3FYSi5/hWVM7zNy7OUd7A320kLA9M1A6RVDmoxp1Zt9RFOuJ8ooOe0pfRWTax7EvjRTR5UNgoAn
 leD6b+TbRiUTTDa9ghq41t3BLdFyKVpt/oNxJseH5XcS37a1YRhVnluZ7J8LFIXiuOlnkssy8qI
 OyfhsTY7VHLjxlmVvHA==
X-Proofpoint-ORIG-GUID: hxBDRF_s8oihg3vUAtvOIzf70FHRx7FJ
X-Authority-Analysis: v=2.4 cv=N4oZ0W9B c=1 sm=1 tr=0 ts=6a15f49b cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=xJqtjSYic485Zj8o0nAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-GUID: hxBDRF_s8oihg3vUAtvOIzf70FHRx7FJ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11798
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 clxscore=1015 phishscore=0 impostorscore=10 priorityscore=1501
 spamscore=0 lowpriorityscore=10 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260172
X-Rspam-User: 
X-Rspamd-Queue-Id: 8962E180003
X-Stat-Signature: k5rnh56asc6ndw5whbeffbjh469nu9kp
X-Rspamd-Server: rspam06
X-HE-Tag: 1779823772-89821
X-HE-Meta: U2FsdGVkX19ZFutLlkUmH1BWuNldN7zIuE2KPckLoNXoGEt9IEVGBDXd52JkdHsp+38OOlXtYJiWJU/Hf7hQeFOnwYYrQ0ERkfN/Z9+xjAwgxrPsTytmrwKOiClRCRE4E6h7/xUwv6jNFkl4MN321LdnQvezXtCILz/PzR7gQwZ74j/W3f/wC4hmNaMOmMCirP372h2lwiWMgpU+2WLFnS3uxQbAGCJUjXx0oRb6MFIuKWXmWpOmD0aLhxdpPD1qVSFs15KvrrgVeZOli/aiuVU3b/xGFtQNdqiHRKqM8Cw8qUwh6VpnrRxwFrsZDwOHMDCfUqo/5fg/aoM2ZebqUQrTIWs2uhAiDQHPBJPFS3CKiuQKDAI/vV8yTLKDujTGPS2woMvQYhGT9rtxg0fxN0NSNBbwx9MG1d9RwaelsAZSLnJR11fOKHMIOPjVOmwcLid1CAQYd9cRXIFA2rkpH7hz7E7McHkqtxyz1iLjMeIKsk59/g5Q2rCGhRaA1kG7WKxlqG0papAY9w72Ev8L6B7+bvbvF0U7bXONYvn7J7n8jVUy56xhV7IKzAvnqhY2mt6U205aiM+wu4IEn0Gdv+x5dcCVhjiouDnRPgE9a2o2FfQOpmXUX2mZiizr7RpjgTwHOX6b7kO7uDiDmqTKWMKAc+CrpkNM0+Rs9MYBv0NAguRFp6AXeRZCTlZHFjHdPCkhMHJL19MVjzI8RNUvvLjhkfb/PMTX3nrKbtfIN1a3y/N0QV2Py0RmwjSPeP7bIiD2RkkTLz2KcDvmBDA99HiAb1WIFTFylir/oFOsF38H1j1l39/+iWRyOgSxDZ+t0gM9s/QNFPuRXK+Iz7eak0wnTN9A+T8oN9sMMSYDOKw81TCL0PL+PP9/gFUUz/Ol/3KzL2vsVBFzK+n8x8tdlBctRBMptNk/nC0sXf34S9WNojw9NSgoLZXEPhTVzpaA688z6Y1M+O4lvZ1dVFN
 X3KGKZ8f
 sNtx5WaCPnCtwFOd7NnVT9DbqmKvNKg5jBALzC/aTwyPrW8EFhLepqNuSDDE4ihGvVZzKPIlEOdGa9sO5Ifz8IHKwc8Lu0CKRavUhK51y5vLgxk7PYpz1AB9EXmLoUEjgdtPM+KoGOKxZtLWUNSlj4DZL/LKVQMxJKxh3BTtSZdeoUhAXky/rOHqhkO6ijyQDbOhfKhDlpLezeZGgWuJ79S3e3hlvuTC5Eu2Hy6CDiG8N2bG+44vvDL08rHebPVgULTfJZ0WY2wYjfFP16BVcPzDDsnMQGcY4uVPB4dR810g/+f+TAxw4PCGQLNvQ31bsEAE+aLYcrv1Y29Flkv/LzyCa3GNa3g3xexRwOLhIU6FZnQFVTN+/OUSsz2hEHZ6qPFGEw4tW50bKJV8cM/oPU4FHd+dfmBeHDIzPWlfC7755QxlU5EPO0AWHhEJPQHoLTfJZo54M1w5jQYjlSVfx79hdZbEeM3fKiNqUqNcVMnMliPafodLTqVkLnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 1:17 AM, Christoph Hellwig wrote:
> On Fri, May 22, 2026 at 06:47:43PM -0400, Tal Zussman wrote:
>> > But this 1-jiffie delay also means we unconditionally increase
>> > completion latency, which feels like a bad idea.  Do you have any
>> > measurements that show where it does benefit?  Note that queing work
>> > already often has very measurable latency on it's own.  This also
>> > directly contradics the erofs experience that even went to a RT
>> > thread to reduce the latency.
>> 
>> I added this per Dave's feedback on v4, where he noted that XFS inodegc
>> uses a delayed work item to avoid context switch storms. There's only a
>> delay for the first bio in a batch to complete, as we only delay when the
>> list is empty. I'll run some experiments and measure context switches,
>> completion latency, etc. to see if this is necessary.
> 
> The difference is that XFS inodegc is not latency bound.  Most of the
> time no one cares if it is delayed a bit, in the cases where someone
> cares we explicitly flush the queues.  I/O completion on the other hand
> is something where users very much care about latency.
> 

I ran some experiments with fio on both XFS and a raw block device. Five
iterations each for 60s. Results below.

TLDR: Removing the delay doesn't significantly decrease user-visible
latency or otherwise improve performance, but does significantly reduce
throughput and increase context switches in some workloads (e.g. C).
I think it makes sense to leave the delay as-is. Thoughts?

Results:

Workloads (all `uncached=1`):
  A: rw=write     bs=128k iodepth=1   ioengine=pvsync2     # XFS
  B: rw=write     bs=128k iodepth=128 ioengine=io_uring    # XFS
  C: rw=randwrite bs=4k   iodepth=32  ioengine=io_uring    # XFS
  D: rw=rw 50/50  bs=64k  iodepth=32  ioengine=io_uring    # XFS
  E: rw=write     bs=128k iodepth=128 ioengine=io_uring    # raw /dev/nvmeXn1
  F: rw=write     bs=128k iodepth=128 numjobs=4
     + vm.dirty_bytes=64MB, vm.dirty_background_bytes=32MB # XFS

Mean ± stddev across 5 iterations:

    metric                     delay=1           delay=0     delta
    --------------------------------------------------------------

  A seq 128k qd1
    BW (MB/s)                4333 ± 27         4374 ± 34     +0.9%
    p99   (us)              36.2 ± 0.8        35.8 ± 0.4     -1.1%
    p999  (us)               3260 ± 75         3228 ± 29     -1.0%
    ctx-switches          184 k ± 59 k     3.68 M ± 65 k    +1903%
    cs / io                0.09 ± 0.03       1.86 ± 0.03    +1888%
    avg bios/run            80.4 ± 0.6         1.1 ± 0.0    -98.7%

  B seq 128k qd128
    BW (MB/s)               4393 ± 3.3        4311 ± 5.3     -1.9%
    p99   (us)               8461 ± 73        8638 ± 105     +2.1%
    p999  (us)             12465 ± 213       12386 ± 299     -0.6%
    ctx-switches        6.90 M ± 186 k    9.72 M ± 184 k    +40.7%
    cs / io                3.43 ± 0.10       4.92 ± 0.10    +43.4%
    avg bios/run            51.9 ± 2.2         1.3 ± 0.0    -97.4%

  C rand 4k qd32
    BW (MB/s)               66.2 ± 0.8        44.6 ± 7.4    -32.7%
    p99   (us)              8002 ± 174      17990 ± 6800   +124.8%
    p999  (us)             11390 ± 554     31890 ± 11076   +180.0%
    ctx-switches         3.67 M ± 45 k    3.59 M ± 106 k     -2.2%
    cs / io                3.78 ± 0.04       5.62 ± 0.83    +48.7%
    avg bios/run            32.3 ± 1.0         3.1 ± 0.3    -90.5%

  D mixed 50/50 r/w 64k qd32
    write BW (MB/s)       892.4 ± 20.9      925.3 ± 18.3     +3.7%
    write p99 (us)          3562 ± 107         3601 ± 82     +1.1%
    write p999 (us)         4673 ± 217        4647 ± 107     -0.6%
    read BW (MB/s)        893.6 ± 20.8      926.6 ± 18.4     +3.7%
    read p99 (us)            1003 ± 48         1035 ± 39     +3.2%
    read p999 (us)           1545 ± 63         1476 ± 50     -4.5%
    ctx-switches         5.15 M ± 75 k    5.79 M ± 230 k    +12.6%
    cs / io                6.32 ± 0.15       6.85 ± 0.20     +8.5%
    avg bios/run            23.9 ± 0.3         2.5 ± 0.0    -89.4%

  E raw 128k qd128
    BW (MB/s)               1043 ± 1.0        1045 ± 0.5     +0.1%
    p99   (us)             26922 ± 105       27027 ± 128     +0.4%
    p999  (us)            37906 ± 4527      37408 ± 2464     -1.3%
    ctx-switches          3.20 M ± 6 k     3.33 M ± 10 k     +3.8%
    cs / io                6.71 ± 0.01       6.95 ± 0.02     +3.7%
    avg bios/run            38.0 ± 0.1        32.0 ± 0.0    -15.6%

  F mem-pressure (dirty_bytes=64MB, 4 writers)
    BW (MB/s)                4361 ± 24         4444 ± 40     +1.9%
    p99   (us)             29439 ± 419       30173 ± 788     +2.5%
    p999  (us)            35704 ± 1773       36648 ± 535     +2.6%
    ctx-switches        20.8 M ± 1.6 M    27.1 M ± 1.4 M    +30.1%
    cs / io                6.94 ± 0.49       8.87 ± 0.46    +27.8%
    avg bios/run            23.6 ± 0.3         1.2 ± 0.0    -94.9%

