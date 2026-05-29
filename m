Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E8EACD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 20:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE786B009D; Fri, 29 May 2026 16:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F806B009E; Fri, 29 May 2026 16:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38DF96B009F; Fri, 29 May 2026 16:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27C656B009D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:46:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3A301C0DE4
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:46:21 +0000 (UTC)
X-FDA: 84821640162.05.3713195
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf31.hostedemail.com (Postfix) with ESMTP id 632C22000C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:46:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=fNdL0jd2;
	spf=pass (imf31.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780087579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tu3yzxbzT574lf/x8+7GuddK+9mUu+iNaUikqjzhrDc=;
	b=Vly+pX8Q2CumHZiXLFFXlfwwOIZ7nD6d01P5QFhTB0vp378FkN1ogBE8Vup+rbbK3NI5Kw
	AE7xcnlAk5nPk3JlZqqCAwNGltwBldERkkVM0lDuuMnHUPNWENnG28sW6fBOBOZBPJCjdp
	svQhffxfoPQtOQprxAaWg4VkyOjxw+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780087579; a=rsa-sha256;
	cv=none;
	b=iFSXbCqAX8jM3A7ADyLuEVX8/J8hevvWFWUOAU/HLkP4+QKXxK1Cpr2KwvSBTs7xHCxxGr
	eK1qagWLOqzDthXkHM1j0F3LFao4cCYQANceX7Yfm43lyGX2vdIsGY/teu3jARm9aPhnVw
	2RMdFIAcW6NJX0y8m+v9NReI0RFnKkA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=fNdL0jd2;
	spf=pass (imf31.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64TKgLAu140690
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:46:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Tu3y
	zxbzT574lf/x8+7GuddK+9mUu+iNaUikqjzhrDc=; b=fNdL0jd2jEZLLdEDzHwo
	hg9oAn2A09Nc/UhTjZBmS2wSISfSJcrx7iHnycx2ggqMsmdYhM48Qp6dn8zJwdYB
	985sLAgkwtmSCT8teAzwTA6OhaIFRxvl6MhKiUIHzXRQSYgRkuDKU0XNg2X2RpBr
	0P7NHA2+A2rGk69mahYeBod1zrBCcJUIzU4maJzE4t8BG1N9Hc/8nKnhiSDo4Nh4
	Ch5XzOjEOBE/jVetXJBtepua7x9ftMeGTiaGWhJ+DI1yELSJMypkbL8bJpLS0OQb
	sCO7ehhxuKMpXZEyP0t++n/X9s8DuU67L6dejzRsJ12iZiflWRTJYEZgsZtHx+T6
	gg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4efd7kthyg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:46:18 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-914b616c670so982700785a.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 13:46:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780087578; x=1780692378;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tu3yzxbzT574lf/x8+7GuddK+9mUu+iNaUikqjzhrDc=;
        b=BBrMfcmKMgHHpxQJ4eC/kbpn8v6tOWRaNwQ//fEvRM69cPtByIQplZ6LM0X/B9ewFc
         glTZZ5jgUPi8EwULr/TSCikgRhvB/maLu7ENvjZMpX39XImt/JMjqYT6mW8xeBfyv7L2
         3Gyr7GteOsKB2Oma8a+XvDkxGYJy+rxeDOPTuf85skgeOxspcRzrNpCmm2itV113PYDK
         znb8ldPAsYOGUH4hkDDqYlN/yQYqO39pg1jnwALjMuHWj2pt6vVaEBYf1p4HYpVw18Pm
         kFmm35vlOrgaX8dWCQ8l8J96jXrvxFoeQHgKS6nDnMtaMiCF+BQpQTpwZAPDHWVY84hQ
         M5Mg==
X-Forwarded-Encrypted: i=1; AFNElJ9/UJER/hZCphu0iPX3zzJRpX5v4LwyBAa+r0Epsilz2nHowJ6806FM8mwO5CrN5S7OSMz/ln1Ndg==@kvack.org
X-Gm-Message-State: AOJu0YxRALOJ9cHFxMdGZM+vE/u38Gb84carrFl8KCL+CTluETFMBow6
	6NlhZf0oEOVoaRKCu29WLH+fGFFXUX4neDyMVqzLb5Qgu6ofqSO5DtGhCgmG9Ho6vZop+Yl+P5l
	sB39O1/YLywCBmEA/9RtLtEJ9enuLoUjIu3IrMJ7buxggBrFW
X-Gm-Gg: Acq92OGYzTmByLy7VZ7lCTEDkI7Yu5PLKSFCvTCahzR6qBCl0zq3Him9TWLbxw5JwER
	w3jdkOcn+P8LOAf09Z0T6XQc3N+7YnTLR7Pksb7rUt8x9AMU9dmVjMxwSlSJQMH5qa1FMq8Yw4n
	4gHiWGQEORmR8pECvoUOSgB6QTQobop2tjDASAjGYMdSCoNh88RyA77Evpog4zAc5yRD5FDgIWo
	KpvoFVq0I9ezqgacAdHdSjeUKq70QW16fd87XgAgagiy80BJ/n2Lu9V7Ct2MG4zvl+vgWgf2m8u
	Cut2eYmgia3miTO3AlL5wv7RN8W0Tw+OdPJUnR6NeL11Bs9EOKOozJB4gH6TGjDJC/RLnuflWJ4
	7xsJQSrKblcw9M/9jEqtsdiBTafLksria6NpkCusyl2VRYrQ5Ek3lPpt3ohhc76VT9lpWHTdLSi
	CHTSjUsZ2eu7lCZ/JSmmglk0YscQ==
X-Received: by 2002:a05:620a:27cf:b0:914:b65f:6afe with SMTP id af79cd13be357-9153d93295cmr223977685a.1.1780087577723;
        Fri, 29 May 2026 13:46:17 -0700 (PDT)
X-Received: by 2002:a05:620a:27cf:b0:914:b65f:6afe with SMTP id af79cd13be357-9153d93295cmr223970285a.1.1780087577139;
        Fri, 29 May 2026 13:46:17 -0700 (PDT)
Received: from ?IPV6:2600:4040:974e:fe00:c8bb:325f:9d37:a5f? ([2600:4040:974e:fe00:c8bb:325f:9d37:a5f])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915324a5502sm300290485a.21.2026.05.29.13.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 13:46:16 -0700 (PDT)
Message-ID: <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
Date: Fri, 29 May 2026 16:46:15 -0400
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
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
 <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
 <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
 <ahbq0RdUyLIPiItB@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <ahbq0RdUyLIPiItB@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDIwNiBTYWx0ZWRfX7EFmnFLvamY4
 s/kWk9npBAbnfZnfVdNUO13zuSvbPdvjrtwP7aPaUtsgEF60kOb3TpyAmEyDU7vhvLtftPABg1e
 HAm+av1PSG54CLT2o/8fEUe9sF/bhQznnDxWold0U4Ur/BAlSH0RfieUTugWx0ktv+ilEPirzOG
 zejwR0uR0NMjq21yVFKgfH3OO3sCQvanG82K0ZPBFbERwmUm94/WgndTbu28Njpw7UrMlx7mdUJ
 bNRInGlibYih/57meXwDXuseEl9JrGBTjTyTvDszOVYLVLl/XXcBOYWfXcNlUYz5Vb9HJ+NGofA
 tEHeRMYFxXE4l3+9ClrA6cS6xr0TQuaNIzaD5ukmcZO9cLm45DuF3m8QcfNRUOBucxqpvO9egDI
 EB2xyGZMxnN1wtoaN9GQQfWP8wcVj6kLupyhiBo+FIaCqzKQSxo4Tsnvxl1RBlbzWh6aJ/QMJZn
 fv8NilStn73Il2xkYqg==
X-Proofpoint-ORIG-GUID: 1CJAzrJVpMIo-r9xXX0Cu95VIHw-EbzU
X-Proofpoint-GUID: 1CJAzrJVpMIo-r9xXX0Cu95VIHw-EbzU
X-Authority-Analysis: v=2.4 cv=FbYHAp+6 c=1 sm=1 tr=0 ts=6a19fb1a cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22 a=glsx1xNwX7j2ZVJJCoYA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11801
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 malwarescore=0 lowpriorityscore=10 suspectscore=0
 adultscore=0 bulkscore=10 clxscore=1015 priorityscore=1501 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2605290206
X-Rspamd-Server: rspam11
X-Stat-Signature: eekxz8bxfwsjbyfoynjgy31cnxhygeyw
X-Rspamd-Queue-Id: 632C22000C
X-Rspam-User: 
X-HE-Tag: 1780087579-13003
X-HE-Meta: U2FsdGVkX19xroYvtQqKN1SsmLxLHT84NBbQ6gaUEUmwrJYCJOkpLVDj4WPVhkNpJdBcqxqO0+Yk+j22+SGm3BV8UPGkgmWDB2DTyFJCy6v0WXXKIPXsHJNnCwbCxF2fos0ffXkI61eRMxOFROi8p901kblmv/IAXqlL575s6KZzHDGEffjwjUVMINzxkccrk4WSSIIErbeaCXj6UlCA4MFaV8NwyqTBAdEIk9Ju/dz1tK1BbxnVVfGokul3B0PlrGLpGFnAM2TIhdj5TGB3FY6O45N4+/G+GC1TNQoeafJC8i220kLN6ljOKNA+CHuGeUSEzUzqCZ0YzOLU3lHdfF+y6fwgvhl6NddKVMmH06sB5+T7dxwRVb9mrbB9jnwWUA1csJqugdZavXvRrVkRoAyUkhEsdV2HYdNlGojx8N8DWCF3tx6g9uOXqfRsHcampdiEdXFEXTQT/dEYNALdaLrAg3CXu9bb6FXC0krxcCb5eiHQBoJji39OF++tX2hhi+wXYtzg9Zt7/JAYqU+bsU2Q0k4Zfraxihy6mPeje3x8ZDsfR2PhrPD4+2noOyIcPzw4J5NDa5HK/wJJYjONiNaILzxwPYQXaCPP2W84DRtaV7x6Ohb6a24Y9e3br9JFfKmvjY7193wwa93j2hc6fC4WksOPsRruhD1Qxq/c+5CxRiYmWGeqSG2cURy7Br5C10SWi7+RzgI00cL7LkKKzYMvzKFZcBqt7jdzj5IfxtMglpSyFHmNxgKSvcaHpCOz2DL298AgKLX88EkfqevkpI6zJ7d5WHKkxt5McHZzGtBrTey9kLKGvomQprgv/6ETNUMJNAF7zrFRikhJ6XD5HreRY3WRtSFwKJskkW1JIiHacybF6KHudCquWk15plKUr1u4oulTgsjamrUQho7pk5rFPGmCXJTb7elatEASxA6iinyToeRehlSTLLKQ+z8Mjc+xCFa1/bpOMfuuhmA
 Yi5Ro8lY
 iUusbr9m5iplg8YlVy8ZIoCI6PvqwEgNajGvFkG40yqlbG/T2FSPC1qGFS5QIvsYgyRaziqWAjDBpEDTWvA9zmGWEA8qBJJmv1mY2MkoUkzoKp1Eqy069l2bO5rD7XnxxnKc35brcAd9Os28JOCaZrdcbNukRze23alCZzy/TPIge+HaBQv1FLzH8QqEpJ/SkW4PU1fmvhM9x+dRCBAI9GCxOfQ7GCEB7/6ydsBaa/z7tqWyF08rlMTu6Ve9LzTJ4VH0Ph0kwChxAjEGsptT89tOp/h5WKzjnwXS3KBpZtobw6lfAJHVbPgVUO+VNShVa5Osv3fBfCevj9XN7HyaFztUQuSCNvtvUMa9psPNKc2lnmrXdKilG5pLSZ1L+g56n60Wt9/tuvPGfV98UdOmzMYha7YH1goG2V8X0xrMzbEsEaz25+jkjD0rRcpjm80uVxjY/mzfNXou9rVuMj29MuoOeZEtrkd+BQOY+Ka4B6ZmiXn75UBxBoAZHL9HYsgMzIOMfSXI2hwOSCPyQsvwkerU5mUL9YY6Xm4M96JPu7fybbmJqHsuniHXoLTe7yJbXhZGIFZ9wNalLbVYgcTKaTtf3pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 9:00 AM, Christoph Hellwig wrote:
> On Wed, May 27, 2026 at 11:42:28AM +0200, Jan Kara wrote:
>> > I ran some experiments with fio on both XFS and a raw block device. Five
>> > iterations each for 60s. Results below.
>> > 
>> > TLDR: Removing the delay doesn't significantly decrease user-visible
>> > latency or otherwise improve performance, but does significantly reduce
>> > throughput and increase context switches in some workloads (e.g. C).
>> > I think it makes sense to leave the delay as-is. Thoughts?
>> 
>> Thanks for the test! One question below:
> 
> Thanks from me as well!
> 
>> 
>> > Results:
>> > 
>> > Workloads (all `uncached=1`):
>> >   A: rw=write     bs=128k iodepth=1   ioengine=pvsync2     # XFS
>> >   B: rw=write     bs=128k iodepth=128 ioengine=io_uring    # XFS
>> >   C: rw=randwrite bs=4k   iodepth=32  ioengine=io_uring    # XFS
>> >   D: rw=rw 50/50  bs=64k  iodepth=32  ioengine=io_uring    # XFS
>> >   E: rw=write     bs=128k iodepth=128 ioengine=io_uring    # raw /dev/nvmeXn1
>> >   F: rw=write     bs=128k iodepth=128 numjobs=4
>> >      + vm.dirty_bytes=64MB, vm.dirty_background_bytes=32MB # XFS
>> > 
>> > Mean ± stddev across 5 iterations:
>> > 
>> >     metric                     delay=1           delay=0     delta
>> >     --------------------------------------------------------------
>> > 
>> >   A seq 128k qd1
>> >     BW (MB/s)                4333 ± 27         4374 ± 34     +0.9%
>> >     p99   (us)              36.2 ± 0.8        35.8 ± 0.4     -1.1%
>> >     p999  (us)               3260 ± 75         3228 ± 29     -1.0%
>> >     ctx-switches          184 k ± 59 k     3.68 M ± 65 k    +1903%
>> >     cs / io                0.09 ± 0.03       1.86 ± 0.03    +1888%
>> >     avg bios/run            80.4 ± 0.6         1.1 ± 0.0    -98.7%
>> 
>> So 1 jiffie delay is (with default HZ=1000) 1ms. That means for this load
>> the completion latency should be at least 1000us but your results show p99
>> latency of 36. What am I missing?
> 
> Yes, this looks a bit odd.  Unless there's multiple threads submitting
> and somehow the completions get batched this should complete one
> bio at a time and be the worst case for the delay scheme.

Sorry, I should've clarified - the latency here is the userspace-visible
I/O completion latency (i.e. fio's clat value).

I ran again and traced to get the actual time from __bio_complete_in_task()
to calling ->bi_end_io(). The results match the 1 jiffie delay now:

  metric                  delay=1  delay=0

  A seq 128k qd1
    fio clat p99             38us     36us
    bio cb p50             1.23ms    2.5us
    bio cb p99             4.13ms   1.44ms
    bio cb p999            5.01ms   2.63ms

  B seq 128k qd128
    fio clat p99           8.74ms   8.85ms
    bio cb p50             1.27ms    3.1us
    bio cb p99             4.05ms   2.27ms
    bio cb p999            4.91ms   2.77ms

  C rand 4k qd32
    fio clat p99           8.16ms   8.11ms
    bio cb p50             1.09ms   97.7us
    bio cb p99             3.73ms   2.06ms
    bio cb p999           11.87ms   3.79ms

  D mixed 64k qd32
    fio clat p99            981us   1.03ms
    bio cb p50             1.14ms   39.5us
    bio cb p99             2.83ms    275us
    bio cb p999            3.06ms    595us

  E raw 128k qd128
    fio clat p99          26.97ms  27.34ms
    bio cb p50             1.58ms   41.5us
    bio cb p99             2.98ms    325us
    bio cb p999            3.02ms    575us

  F mem-pressure
    fio clat p99          29.75ms  30.43ms
    bio cb p50             1.32ms    2.5us
    bio cb p99             3.73ms   2.48ms
    bio cb p999            4.62ms   2.83ms

Note that in the above, the C degradation didn't reproduce as much. The
bandwidth does go down from 64.5 MB/s with delay=1 to 54.9 MB/s with delay=0,
but it's a much smaller drop. I ran it several more times and ran into the
degradation ~20% of the time. The lack of batching means the completion
kworker fires for nearly every bio, leading to heavier preemption when a
writer is placed on a CPU that receives many completion IRQs. The degradation
seems to occur when the writers are migrated less often, leading to more
preemption. But I haven't dug into why the scheduler chooses to migrate more
in some runs vs. others. However, when pinning to 16 cores, the difference
between delay=0 and delay=1 goes away.

C specifically also seems to get worse because we're doing random writes to a
sparse file, so each bio goes through the IOMAP_IOEND_UNWRITTEN path and the
completion path is heavier, leading to more CPU stealing from the writing
threads compared to the other workloads.

>> >   C rand 4k qd32
>> >     BW (MB/s)               66.2 ± 0.8        44.6 ± 7.4    -32.7%
>> >     p99   (us)              8002 ± 174      17990 ± 6800   +124.8%
>> >     p999  (us)             11390 ± 554     31890 ± 11076   +180.0%
>> >     ctx-switches         3.67 M ± 45 k    3.59 M ± 106 k     -2.2%
>> >     cs / io                3.78 ± 0.04       5.62 ± 0.83    +48.7%
>> >     avg bios/run            32.3 ± 1.0         3.1 ± 0.3    -90.5%
>> 
>> I'm somewhat surprised how larger is the completion latency is here without
>> the delay. Is that due to a contention on local lock between the IO completion
>> interrupt and the worker? Or why is the completion latency so big here when
>> the case B with more IOs in flight, less bios per run, still had significantly
>> lower latency in the delay=0 case?
> 
> Note that in the past we had major problems with workqueue scheduling
> latency.  At some point these got mitigated a lot, but if they are back
> for this workload that might be one reason.
> 


