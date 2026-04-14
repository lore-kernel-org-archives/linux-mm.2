Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8524F9D0F2
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 20:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB1E6B0088; Tue, 14 Apr 2026 16:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282196B0089; Tue, 14 Apr 2026 16:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1982F6B0092; Tue, 14 Apr 2026 16:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07BD26B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:29:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A65DB16013F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:29:39 +0000 (UTC)
X-FDA: 84658302078.10.2E24C49
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id B10A8180010
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:29:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=k22q0YhV;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776198577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXFqnVJ4T9hxAVeyiDV1ooSXjwN82kyD0WFAZyEIayY=;
	b=E2lv/2qGJa16PdCDqLDDLVU6e0aS/T5fj1ZW/KrYZmrxVYHUp0+/+D2XBXW90XdjlyQt2t
	7+TCxkPvbyYxtjYItjOY008X2BsrZILRFRJuQ2eyM6yM9D6tGmOlEqDpSwzKHmDXTHWrHJ
	POR+LVO90/BFQjKv0ZdSSeom3F/5ayw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=k22q0YhV;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776198577; a=rsa-sha256;
	cv=none;
	b=PFH3B6DfNQQOVUz/9IfMj94hQVQEMx2b+XARaTQ/mXfUo/QW2TWbL/H0PVQEguKRL+VRNL
	19+0tSUUQcymzm6ujzKt4qluXeiVVOmRNYsIKvVkSHsRZSzIHCWPjE5n2NhnGmZizuf3C7
	V669kaA+VV/hO3YhoRjByV8krNux+9g=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63EKRbcK2606688
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:29:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=WXFq
	nVJ4T9hxAVeyiDV1ooSXjwN82kyD0WFAZyEIayY=; b=k22q0YhVQZiPT7EsK4qY
	kXKKf20d6Eyoq5zv/bCMosbe1p6ZTAAFqGYN1jql5TMO79N5C7HaZt6Z/cwriJjh
	i908rxBG1P3Tp2CF3EvYaZY5/Hh5bH5gz+cbWycowOy/ULW12oZEyg7fnlzlbtCW
	g1tmittXLgbbnNnyoVTcES5p2xk8gc68UqDO+MLS2VTyn0RAe4ulKHNSip2O7W0f
	wus22rwT2+tQnLCpj7WtrZzSZq7OwUEon5xcKGVHybeez2whx+pca7FQyi3SR4Su
	EhEEbwNysh4gXoSo/YVDtxTkm4zxUm6aRBUNyXOKjCaGjPahOa1IEuFxK2LP5O6s
	qg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4dh85dr3b6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:29:35 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8d4c2906fdfso656558885a.2
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:29:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776198574; x=1776803374;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WXFqnVJ4T9hxAVeyiDV1ooSXjwN82kyD0WFAZyEIayY=;
        b=l0gFnrz3U9YCR6fepsGYMhJeJR/o5bAGCgnmFZfmgrwuWSRr6sHo7fOO113jXZNas6
         Qq8LKMCivA7q8M7fkJPkSmPqK3C6Pw0c4yz9PssUvcfMrzwdbp3E9R1VYIt119YANgor
         3UvAYmmjOiz6vZQzF40LU2WmE1W8Tk6dydmE74f8ssmM/BQlBoXdxK1sWP/4XuVUwY57
         LxyQEZ4Fk47wsZbZY+1cmIVdLDaZiDnejz5E8c4h7bTbja6+3rw8hGg5u/BF8bOmqN+V
         e4+TTzD65SwKSkd5PthvFCLTOIuJatTNR9sZaR76zM0qy9gjRD9nuC4gLnmpsE5XAL5S
         Fadg==
X-Forwarded-Encrypted: i=1; AFNElJ/BGCFvk/OA4E95+YXYS70++IxpDoj9FeusT8/PyZpDysIVKbHg5jp24meiMkvZCpDirf1u9CMLZw==@kvack.org
X-Gm-Message-State: AOJu0YyXwFZLMzBmFRUE8LEsWDR7bfv7bf+BpgWDxvSCK/0ppb+gJGqj
	Z44UC1E3MNEKhfIvR4RaY7S+7Wdxn96aMtgJkIS17+h+G+AXFqpeWdD2D0WboVoKuo8ZY3ySZZY
	p9J7pfns/Fr8IVO+ByT5DxWZX4IMJUN44VcRdC43ydMD6Q6/qsam2dk3C
X-Gm-Gg: AeBDietgTOTYNmxusWi/y6qObigCtXCfl/wi1mJu4DJOF3BpL8YNxBB9ZSJGt7ENnvC
	7UOvyuZu7ebqKdFoERFTgzR0whKbh2HepdN9x9HRC6lpGzVcLHMjOkKQ7oJ7sSdfvf9rzGlt8TW
	AriZtFzm+QvcguTr1vmL2YHbsbhMTrd4UnAnGUHsjRHZF1T1E17Se/2HrwJxDJuV6Cj8dVVJFze
	dkCmaP/+xlNx72rlp1IxAvVvPLn3Nec4CiuaITZBeyMCWFDuCgaLkzsAzaChjpS+w8fhiCJGiWx
	1VDZnCGPMDlOLXibCAJwWHdV1uLiRpuncKbqO6KUgQEpmtu2B6byl6FlCk2MrqCfmqC2f4GGydc
	thuTJkQkblXF2LOuJlTS2a/H89waux400eRp0FUWLzmYOKKTWfsvMReN1JN3gXzaPMdHTvaw=
X-Received: by 2002:a05:620a:a281:10b0:8de:b9dd:8528 with SMTP id af79cd13be357-8deb9dd85ebmr1694558885a.24.1776198573927;
        Tue, 14 Apr 2026 13:29:33 -0700 (PDT)
X-Received: by 2002:a05:620a:a281:10b0:8de:b9dd:8528 with SMTP id af79cd13be357-8deb9dd85ebmr1694555685a.24.1776198573428;
        Tue, 14 Apr 2026 13:29:33 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac849db4e6sm131911086d6.4.2026.04.14.13.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 13:29:31 -0700 (PDT)
Message-ID: <fd94b108-22c1-4eb6-8fb4-b009214976dc@columbia.edu>
Date: Tue, 14 Apr 2026 16:29:29 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
To: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <97b81868-6410-4c79-a242-679a9f04f073@columbia.edu>
 <95F28FA1-5CEF-4E80-BBB7-A429B4437D12@kernel.dk>
 <7e468bd2-e52b-4165-95c6-3f04e1dca21e@columbia.edu>
 <fb64ba71-7284-4768-979b-84919f2aa5f0@kernel.dk>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <fb64ba71-7284-4768-979b-84919f2aa5f0@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDE5MCBTYWx0ZWRfX5mSF5VuZ2xjN
 /50JnZxbgnptL2Om7KuJbzBj2GuQKlxtM9bkJ/RTDGAr6w6Vty8WqAeK7/5wta6jSFpPU+E+0Ku
 uO2BehuXbSmwLPT3IxD7ZEMorzIW3f8ekN+CK3u16pv3oVaeCtF/FcciTp54tLFaUg5AUO/Ba05
 AL4vKGJegsuW2KeTzBacYSdCZjK2mFmvQr3dRqKWP78F2f5g0fxftmfV77P34Q2VNBUaCcDFip7
 0HkdGdTsqRfc3jwPZWp/FK8LoJH7x4tziimV/5Pt3w0LDc4ZoyyeZsMtoRsKA5VYMZQa9WDAgcg
 lCSWJQVwltfwtIpuC8FaWAiVZuVYFUc2itbsgJDRdsUDOzoRR23CyvdheRZH+74WPm+PXhFZOcn
 CEWEnOwDrXJX71bcYFKNAH1k2a1w+sYl2lWcZCoFHBWlOe63Uh/Jh7qmXmlVNFB2AiOikISm8d3
 53ga01gdTp9AVKiLZEQ==
X-Proofpoint-ORIG-GUID: 0oGq-q8sC3Yf_-LlpX4jbUtrcqvS5s82
X-Authority-Analysis: v=2.4 cv=eJYjSnp1 c=1 sm=1 tr=0 ts=69dea3af cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=g0XPL2zXmNQOemVH8wcA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: 0oGq-q8sC3Yf_-LlpX4jbUtrcqvS5s82
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11759
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 lowpriorityscore=10 phishscore=0 bulkscore=10 malwarescore=0 adultscore=0
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604140190
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B10A8180010
X-Stat-Signature: 9kt78iaqjpmes5xk3qettxtd8s694keb
X-HE-Tag: 1776198576-562213
X-HE-Meta: U2FsdGVkX1/WtnN2c5OowbJL5fU54jGq14B/FihkM7uhXWN+w7hFCZwk7r+SQRy+mWOAONb+DGpXQswDdTHpKq9D/RWN+Oa0wRnMTEiql+Q2TWIYf05C7sg+sTILM2UalMIsPrEh8deSbOoJSMHf4XhyASVE8c0ZlYtLXESVBY2GrCfgn9NAmu0X+ycTDAaYTmEiM3r6wwJDHq4Hznk91+Z3XASkVbSstWDUMfFBVGngtYnLQfIh8F89NNzrXU/DbnNj4XC8g3egNQnAEPpF/daI1gMcFYs9APZyDvZyhmUOH4nFN2w/y0gcb3JpXtMQ4YcgrBaLo1yEkYN5vSzDnsyTiG9Mb/zdABPDegthQ1w38nRu49vPbc/AufwfK1jVvi98JNxwzDrefa9z+wPcj/mbUbBFlKSBNKPTeV4OMazY2dFHLDXuGnuSd+yFoStKB1WVw5t4AHeQ+1aM0hGWs6xq3EzERRmwt/LKQ9xjWKWN/LDPnV4C/f7qeVgjB5zn4ijysp5ph2fe+XCxgMpSRy4gWWaT1YDqUiDUCGIrl3malBov1qKv3uK2jVOAZ9gHbjpnIw5Fae4D1zpTGbgf3RItAAkwg4sotU8A2q+Cg9meP8EccuTbqQ65rKHVM22vPva4VnDEQPaHmty5YxNVM/SqYb2u5esFXd9c+DI7oYvFAmjmFM8FS4GjyR8MYtMo7Rup7xvfZnTZ93+X8HHdmg+cJCAs9pTpAjffkptklE8+PwjYTs/bX3SvFqke1lDMqkWptJQzMtpFRXOI2KUlqBRrAVuESWhMSeXJdzdpYsEB41iVh04c/hJUwAa1BDD+COj8Der/X37q87rf5CvA4AqSz6nV+vSyu6iCZvt73gR7q7iIe7NJun2Jd+gy+GqThafn3TgAidH4aYmNQUztLs1BJx5XLtodBPEb0NXEdjvjbJV5CugtX3ugd/81VfTBjM/g7oMQqtA5HXOfnu7
 yOx38gwr
 t9M9a5+KHevHNdJTvuyH4neioola/EV8AfEihrMD216htF21VnsExttlajCpxXu0HnfaGKwyEJHMusi4chNjCiJh/qabBcOt55Rx7fSA4tFuqEYGwTRSdhfiOvAG+kvWdfJtR3L+E+Bsamu84w+tCe8L9IZawt569SPBB9otxSDgQdPziApw8HNvwggQJf4Rji2MDZbKGym68XcgKl6jSQ2xl/8SY4qjWxUGnSP9qeRHTlLYZU/knVgpkBi2Rp6cGSwY8nVgPGJ418bo+RMFOwUuecrG2VUgYKuESvBx0Ae3poUzgkcC65a5T2s4807qosAiEIfAT+BBJW50PGBvXCvmwIFf7WyPAsUHUV3feHV4q8ATkgpf24iAu0YZEKv5NxtZKnv47mKd1WdkAuI7jUeVDJSyIbgdFsavn7O61NeMJ2kBXDy0yTAr/OrQleA/AE3jawgtr7AZ6fZQCVsh9rB1iim4ETrTCFpEBQTCsuQXvDR0umrVgm+3/AAHYVrI21zv8xP1bYzC0iT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/9/26 8:46 PM, Jens Axboe wrote:
> On 4/9/26 12:54 PM, Tal Zussman wrote:
>> On 4/8/26 7:36 PM, Jens Axboe wrote:
>>> On Apr 8, 2026, at 4:51PM, Tal Zussman <tz2294@columbia.edu> wrote:
>>>>
>>>> Going to send v5 shortly -- tested with and without the llist reversal and
>>>> it didn't seem to make much of a difference. This was on a single-disk VM
>>>> though, so any stress testing you could do would be very helpful.
>>>>
>>>
>>> With all due respect, a single test like that isn?t going to be that useful. I'd be wary of making that change willy nilly and just thinking it's fine, worked fine on the one case I tested?.
>> 
>> Understood -- unfortunately that's what I have access to at the moment. I
>> can requisition a machine with 2, maybe 3 disks, and test more thoroughly on
>> that before sending the next version, but that'll take a few days. You had
>> previously offered to test on your big box, so was hoping that was still on
>> the table :)
> 
> I can do that, but I'm OOO for the next week, so won't be until I'm
> back.
> 

No problem, thanks!

>> (Although Christoph seems to have proposed moving away from llist again)
> 
> I think that's a good idea, not a fan of using llist for this, in case
> that wasn't clear. These are per-cpu lists anyway, and having a constant
> overhead is better than needing to reverse an llist. IMHO.

Will change it back for the next version.

> -- 
> Jens Axboe
> 


