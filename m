Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12500F364B2
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE0A6B0005; Thu,  9 Apr 2026 14:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F1B6B0089; Thu,  9 Apr 2026 14:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D876B008A; Thu,  9 Apr 2026 14:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 564DA6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:54:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1634E16015F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:54:33 +0000 (UTC)
X-FDA: 84639918426.23.FD89000
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id B5A92140008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:54:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ZAtJSsKj;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775760870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sw6GwRk7Qp2WRM++iKaHx+hBQAaMKviN9vTfKu8ETKo=;
	b=lbr0nbvslaMNMc2Nhus841xbmdY77HjygzeuedXpnYdE8B7Rwc6rS+6Uu5kKAJOEjiNgJU
	LeVGGU5rTmdTpBV0hsB7gPNw7XeM8hULMQXfH/KfmQxmLx88WVGXD9P/9j+9u/lQpbhH43
	gKjDfXnbjDTF6J0zJvf/LCv6V7cmoAg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ZAtJSsKj;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775760870; a=rsa-sha256;
	cv=none;
	b=yHTySs9OsrXWp69xnYltf9FfOOTP7Jb84tbqsyQURtjg5GCH2DzK2jo2IBoExCAlta4rrY
	9z5Hnq7lf+/5GO0LL4DP71QE/Su4K7mGtXVKVNHRv+8TTK99Z4RERwUgDLIE2/9zlD0Lo2
	oP/86ErGCvGLyC349vnOkysjhB0wUt8=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639Ig9eF3019955
	for <linux-mm@kvack.org>; Thu, 9 Apr 2026 14:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=sw6G
	wRk7Qp2WRM++iKaHx+hBQAaMKviN9vTfKu8ETKo=; b=ZAtJSsKjbJ+Hx52hia8V
	5BMqLKGKSsStdVWtGKARsi0D128R4JPKsI86AourUUAoTURwWTj35qcQxipX3bWP
	a6q3sdKorNc6YRrCwTJb/TCMxv3p+mxXbU/gTz0zRx16uUBEfpyeh9ojfIrrl1aq
	v46cmPYqZ9ZsuXvF5ZJpb2hQ0JPDNtX0YlfISoHeTAQyYnZZ09MubrDOhccs0Z3H
	/91KAb3XVWlenwMNgfnasO8BAjtbph26AK473sh5c15lh7ocLkyw8qQDtKZiOtI3
	kyLlhC3ioSigG1ElxYY76Q5lLYGJj27fPkR12FO/wB9Z+gml0Y8wUuiIjTb8Ele2
	7g==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dee5d2f1g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 09 Apr 2026 14:54:29 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-89ebd9e1ee4so23976416d6.1
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 11:54:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775760869; x=1776365669;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sw6GwRk7Qp2WRM++iKaHx+hBQAaMKviN9vTfKu8ETKo=;
        b=FdcgQu5MYXsIIvUY88mMas5DkewiPcqpf/VuTYQvXK8IiOh+p+jmsB1P18hWGEobff
         E+5NS3N+Q+bk3FEZJEao7Goei0WLpnri4kRWc9PO+0Fqvl7lJf3UdrSnfoUBlIK2ZlMt
         iT4XSrGWYRPu2EeVW/cLsfs+g3H5voiAkPnv7JrIqa0Urs9pp+ud2Jttp8T60nSFiIGS
         vXqdSqxyXtlZSstTsOPASWEYwfZkvToCdkB2vC/4tiyGBUV5pSvHnHmSqDGZ0lVjt4Li
         bfIkZm7PCncvaf/5adIHE2qGrshJ3Q4Q9xV3rxXzeJ/OSvWzsTelbK/aZ4SCmf27alcB
         GVRw==
X-Forwarded-Encrypted: i=1; AJvYcCWSfcuTN3/y8IZDxWegFg814tLJcSJD3Feh3/oF0aL16LvIL4NkE0oZuL+7IbuimcT5SgNZXjxYmg==@kvack.org
X-Gm-Message-State: AOJu0YzZdvErmnb3orq7wSpYqAbzPJOAInopj1vF6cSEQs9tpXEdlaiZ
	FJuIMonJzsYLe669fzOWQl94G8a+raCdvjP73de99ww5nbv0929UsBHoVtPTZ3RTfXuQmt1gA0f
	eRdk/h5VqGt32vwARh/ogpKUMhd5MgwnNFPrAG7mG53jQEcbe
X-Gm-Gg: AeBDievt1BYD81K9Bt7mdpnBTY27ksZYYhm6iMqlGmqetLr7Ap55i+2Hkg1au95A90h
	qdER8fYrAJQfN+ysXNE8feKQUSfxL7CW/I+OJ6mCSsTTp0xbyiWYqWxTCBJPM+g+w/J/mshTNOm
	zvAE0YBotszEo9wJXVOQ2BXtoLtZYodzx98pRrs3KsfpHZ84fjcPGr0pRvCjK/frs2HDxXuOQLf
	d2B/Q/TlHBPRLoi+iB4IZc/4acQY6TudFWMn/SENKIqSdzwmPGbtGKijw3oY2TwMvAvAzr5iCVF
	4fUPCiKwMyD+OpxPLI/ZArBVJWK3zs4PqWsifdUMIpN5Gp+QvPKvKRF6ftZJybFoDSgvySXdS9u
	xnaW5vpstOySITbi2uG54GfcniCI92kSOnmKLlW33
X-Received: by 2002:a0c:f114:0:b0:8a3:221d:9095 with SMTP id 6a1803df08f44-8ac743038b7mr72761266d6.15.1775760868938;
        Thu, 09 Apr 2026 11:54:28 -0700 (PDT)
X-Received: by 2002:a0c:f114:0:b0:8a3:221d:9095 with SMTP id 6a1803df08f44-8ac743038b7mr72760866d6.15.1775760868507;
        Thu, 09 Apr 2026 11:54:28 -0700 (PDT)
Received: from [10.206.71.59] ([129.236.231.31])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac849db4b8sm3093516d6.7.2026.04.09.11.54.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:54:27 -0700 (PDT)
Message-ID: <7e468bd2-e52b-4165-95c6-3f04e1dca21e@columbia.edu>
Date: Thu, 9 Apr 2026 14:54:27 -0400
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
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <95F28FA1-5CEF-4E80-BBB7-A429B4437D12@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 6_cjmjfyBv-JYVvey9M294lnWxUG6Lr5
X-Proofpoint-ORIG-GUID: 6_cjmjfyBv-JYVvey9M294lnWxUG6Lr5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE3MyBTYWx0ZWRfXxDySIab3T+YU
 q1AT2AQPP+/n1T3fSZ4lPtFkiimehVMdjuOo2qBLJRVQnaYTWyF5Vn5bCG1oaXRChAxEFzCH+09
 mXep5bPlGP9s/AHxDFAr50nPEvly1cZyx+lDe73N+B6JTSSaSO7tD9Kn7UNiuYvxKIT9y73ZGCQ
 Bl7TZvU9YabSZAZ4L7aXNvTVgFlPzNHIeKcHBP+k4oFV1ZkMD6rS0WUhhzzzpMLTtH/wWfzTwKN
 ULUFSWokuGOfY8R9U2c19pxQ1roaOPOfvWs6akOZPyTE4KYEHoZ/CAFmUqKGruSGR5I4Jwtl3D7
 ZFXzTnhGuXgiGGKR1h4siI55vL3cGiUd9hSR/n1MVKMt5SLMC4cyoE8QJchs15f0Yq0p5KIjj8Z
 MjTMyyHXjfdFCA2hyH3beX6y06THw5QrCpUCnmIdWGHIqEM3w9NokPOfLwzhzcaCb+Ir2upXoHH
 pwByUwAUZm7Bwvj/bXw==
X-Authority-Analysis: v=2.4 cv=bepbluPB c=1 sm=1 tr=0 ts=69d7f5e5 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=RFpAoTwO7tzpE9r8PTiuXw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=y2ETOFklOQM5vU7YwEUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11754
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=10
 phishscore=0 lowpriorityscore=10 adultscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090173
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B5A92140008
X-Stat-Signature: rmeefhras7hu3nuwnxmg6d7gfsyz39e6
X-Rspam-User: 
X-HE-Tag: 1775760870-957638
X-HE-Meta: U2FsdGVkX1/saqZNttwYjt+jSXpuAMiJAqY8dFzbTEa9Az+41zbq3P7OPzW24g/4U6f3Upof8xTS0iEkWTsTYX6nYEg8QLG+/9Z1qjRRm51flXFnX8dn0Z8VLtc/AAHsaW8hTvjWmSC3qSXaMQleSnyXD1Sdj7MjWjIIzFtSZAMghi3rRbq7bLyhkgdAd4txNbjzvQJsD/ijI8XFpe9wl9KIBjZ1hBjKbBH7RfTPg6ZwhRI1YXEQQs6UVtHvmUFAeZkQuQi09acOK5naUkE9HFi0GJK0vNUQxkpTyD2FngCd7T8V1PC/9Vgf2cBuflkqhmKyzbOU8jWQcpNWppe/CV5K7/NW5Drz6oSYwG25ZFkBlL73KWf3QhpHd50uRGdIgvV59ZQ6EaUZraiKrIoUbmh7tLPMYxyKlyds7G6v6jOLMS8Au5CEHtoZbh4n0Wqu3+RuSBiJHeAdJRl1rgo/n3SVLmKH6BAdTCb2YdNVSZ/fIuGA/6HEAf2My6xfwbbCydff9H3TmcCY4QzhbYhuGFhakG8o0Ht+zbWN0r7a4tbaqQw9VdWpquH6muBkUZpKki7nBUY2ehtZQV1VL7s3IOQ6ejAEaNrgRYWQDFmoKQqWLoFx3i9G/0boVMB3iKE3rZB4StrZ5gtI10LOlkXeErwiiNeQikaOCoVQCBpyLAmMMKBhyr9Qd1v2/KJgdiE0vCTFhXeMk0NhHKLuiGfGPUQAVFM5u/JjT3wLt4jQ8in15ngZrRC4uDLLk9NORDb44l0jXkEPHOOwzVaZCF08zvjTCLypg+jE8jsIwt4QDQAscnVrz3+HEpMhHfEjPV9A4MY/Pu6EqbcoJqWEWPX/jX5AkAymDrtGpI54uG3FyBkR3YG+3GC5JXs1h/QMhbeBNGvtUUCEDGAi+m99H2IwU9qooqk5CNocQkP6WlGUbe01c555C+i3l2NL+rsCbsRAVbOItLc8OIA/xxxfJvE
 SDD/nF8n
 RVYR79vs9dXmO5G5znafHE776MIxzRU3rCqUuoSAxT8eM3KXSHdPRL0bIhIz4kBaK7TP4AkVyjh5Rx4+xar0870OZAStSTdkC+fRMad7NyIc6G6MVMjZUdCZi9JSoJ5sK6HQJ4Ok7TXJLurek7jBzfQ2MEQPJjxW5Fb2P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/8/26 7:36 PM, Jens Axboe wrote:
> On Apr 8, 2026, at 4:51 PM, Tal Zussman <tz2294@columbia.edu> wrote:
>>> On 4/8/26 3:51 PM, Jens Axboe wrote:
>>>> On 4/8/26 12: 48 PM, Tal Zussman wrote: > On 3/25/26 4: 14 PM, Jens Axboe wrote:
>>>> 
>>>> Thanks! I'm going to give Dave's llist suggestion a shot on top of
>>>> this as it seems like it'll simplify this nicely. Looks like that'll
>>>> involve turning bio::bi_next into a union with a struct llist_node.
>>> 
>>> Since these lists can get long, I'd keep an eye on llist reversal
>>> overhead there...
>>> 
>> 
>> Going to send v5 shortly -- tested with and without the llist reversal and
>> it didn't seem to make much of a difference. This was on a single-disk VM
>> though, so any stress testing you could do would be very helpful.
>> 
> 
> With all due respect, a single test like that isn’t going to be that useful. I’d be wary of making that change willy nilly and just thinking “it’s fine, worked fine on the one case I tested”.

Understood -- unfortunately that's what I have access to at the moment. I
can requisition a machine with 2, maybe 3 disks, and test more thoroughly on
that before sending the next version, but that'll take a few days. You had
previously offered to test on your big box, so was hoping that was still on
the table :)
(Although Christoph seems to have proposed moving away from llist again)

> —
> Jens Axboe
> 


