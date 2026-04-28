Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 207C5FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A80C6B0092; Tue, 28 Apr 2026 09:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884336B0093; Tue, 28 Apr 2026 09:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BCE46B0095; Tue, 28 Apr 2026 09:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF386B0092
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:13:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F8181B6F6E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:13:09 +0000 (UTC)
X-FDA: 84708005298.25.C4B9E96
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id 366318000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:13:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf02.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777381987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AHeJeNCcBAQWdFJf3j3BRX8RKXh1jp7Op6rvFSXlp5E=;
	b=pFIO3vo6D2V4M8+rzeaZd/Wryn38mX0SLlJmCGalB+AgDwPYjhhPjVIzFbBd31fysZNlQ+
	r+cI+TcTbpQKPi67CEY/Rr76Nt3gHeFi1+8FF+Y+xAtPdrkKYb2pgqL1npH4Sl6YgkulIh
	eHOMhuaCt4s836VHq3vjFLwLHuZyd50=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777381987; a=rsa-sha256;
	cv=none;
	b=OjEB7WiDz0FIPhys6C1eyjYIi8I0ksOZJ3t1YrBdAw5XkyO9zEORiN48yZLgZ/mgkJE6Ya
	Xj+P/8hKdKhQ3iiRnz8sYL+SHRM9Qkru7pd7iYX+f0xCIvPyC0RII8XZOi7iuH+7fBmcR+
	SfFxRW1rItw+GqtLYQARK6lTx+egwgs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf02.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g4gnz35sLzHnH5d;
	Tue, 28 Apr 2026 21:12:23 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 47D2140571;
	Tue, 28 Apr 2026 21:13:05 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Apr 2026 16:13:04 +0300
Message-ID: <246657e0-62b0-45e6-88e5-b3a770cea3aa@huawei-partners.com>
Date: Tue, 28 Apr 2026 16:13:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 04/19] mm/damon/core: commit probes
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260428003914.113299-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260428003914.113299-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 366318000C
X-Rspam-User: 
X-Stat-Signature: xzc5a457zgi5ns1nxhoxi799rcx14h3r
X-HE-Tag: 1777381986-987869
X-HE-Meta: U2FsdGVkX1+n+ZEUS7LPRfsWXrLiLlmpNNkFqXer6ekk3VoUyZY1s3xfGreuMr1FNoVST+tpDMTTwP2ZBoWA1pKi198yfcincEcFA6uQOSh24al7qBPdCyBIsi162B+LlElpYqkSV9zP2JMyhSvsidHesLHCp6uRutzaXcOfNtf5NSHcyTFRaD4AgKEo89nX2H9kSDJ/5qv0Xo5gMseIn9+i4mbYbaxmNSd/x6uk9m1O9JM2zCCPK1bsPHJIvT8ZhnZH+yFFZWIiX4uL0kGUZNlRDa0TNt33RcQZ+873qUkoVXIZuv+HHMQSGk5//T6lUNpJIf5Q2CV/9uvgJMoOUe0qrwK6d/JeNCykpdov3sO1fkx9vouTVOwUqJ37c0KhCdkQ9P/NPxDjMVupaEc63ItxONFdHE7Z4mBlScTibJbWRAd9LIjO8MPWOrIVRsYRf91/aOZigrmZtj2NInMIy1HXVblbYrzmqBkXHcpD05a8Qcr+y5koTyrY2vGKtV9KiqXBic1RWA2MDU+YocUoN3hoiA3lArgHDuN8oFLxIoIZNs32sgIKf53CCcfJ3DMvKqVlw7TPaLSXXfxgkTjogKto91F+PP6AeYtOv6x4y/GjGrPHE8CaMrhOizdT6oeHcw9cEtk2iRD0LxmFbAqKSoZWez2CjXHNWf2XIKWul9y+az4zNWDc8g73mfHntYcL27nQ83+SNXWSn6lkRq+ENiG6M0/cFLclj1FrUZ0A/YyqQoByTDy25V805mJjmIbn/wDydHagOWyLZHAJHD4vJmcoNG8chyf+vkBiVc8RzpF5NcIu5ppQwW31FmyF9LqGr66tQ+OOBxPn1N+GKeXu/I1TkiWTydS1vS0ujSlxIVme5Hre5YUPr+hG14p1NtTDEcPPfUZ6qgIfBNxwoD7wwW6bsmWGglorP/9lGFfu4PPJaOCgvtiCfvRh8+flTJy3oMB+aMhpKhf8hAcwdl0
 fgDzocV3
 gevODEU2XVtQsNFtsE6K05doWBOLzrV7r8L/9+bXBvTeG089Hv4LD/lcUHPfSW2E1lydKIG7Qwe9ps03lBJzMLhVg12G5hjzT+rxmyx3oiwD6Wn50H64bI5MrfmS5St/6pt2R8lG/56C3hYNbmmfJJ/Ci5NmMrVUl9SUZXrPfcTzVOLxhT3LWSXH1ht14MpB+yT1ACBnYtu7zR8njuEVRCEH24ipa2qb+O2Zk/r5sDHdpgRqZdzNEjf1kV3l9L4cUfRdTonr5HsYJmNJetCJL50PyPiFgMiJxtdliPbglORP07JCwc17YJDVf9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/28/2026 3:39 AM, SeongJae Park wrote:
> Thank you for reviewing, Asier!
> 
> On Mon, 27 Apr 2026 16:21:19 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> 
>>
>>
>> On 4/26/2026 11:52 PM, SeongJae Park wrote:
>>> Update damon_commit_ctx() to commit installed data probes, too.
>>>
>>> Signed-off-by: SeongJae Park <sj@kernel.org>
>>> ---
> [...]
>>> +static int damon_commit_filters(struct damon_probe *dst,
>>> +		struct damon_probe *src)
>>> +{
>>> +	struct damon_filter *dst_filter, *next, *src_filter, *new_filter;
>>> +	int i = 0, j = 0;
>>> +
>>> +	damon_for_each_filter_safe(dst_filter, next, dst) {
>>> +		src_filter = damon_nth_filter(i++, src);
>>> +		if (src_filter)
>>> +			damon_commit_filter(dst_filter, src_filter);
>>> +		else
>>> +			damon_destroy_filter(dst_filter);
>>> +	}
>>> +
>>> +	damon_for_each_filter_safe(src_filter, next, src) {
>>> +		if (j++ < i)
>>> +			continue;
>>> +
>>> +		new_filter = damon_new_filter(src_filter->type,
>>> +				src_filter->matching, src_filter->allow);
>>> +		if (!new_filter)
>>> +			return -ENOMEM;
>> We should bail out here. If we return an error, we have already
>> committed some of the filters already. If there is an error, we
>> should remove any fill that was already added.
> 
> The cleanup will be done by the caller.  That is, damon_commit_ctx() caller
> should destroy the ctx when the return value is imposing a commit failure.
> 

Acked. I reviewed all the callers for damon_commit_ctx, and you are right,
they all destroy ctx in case of an error.

>>> +		damon_add_filter(dst, new_filter);
>>> +	}
>>> +	return 0;
>>> +}
>>> +
>>> +static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
>>> +{
>>> +	struct damon_probe *dst_probe, *next, *src_probe, *new_probe;
>>> +	int i = 0, j = 0, err;
>>> +
>>> +	damon_for_each_probe_safe(dst_probe, next, dst) {
>>> +		src_probe = damon_nth_probe(i++, src);
>>> +		if (src_probe) {
>>> +			err = damon_commit_filters(dst_probe, src_probe);
>>> +			if (err)
>>> +				return err;
>>> +		} else {
>>> +			damon_destroy_probe(dst_probe);
>>> +		}
>>> +	}
>>> +
>>> +	damon_for_each_probe_safe(src_probe, next, src) {
>>> +		if (j++ < i)
>>> +			continue;
>>> +
>>> +		new_probe = damon_new_probe();
>>> +		if (!new_probe)
>>> +			return -ENOMEM;
>> The same as before, we should bail out.
> 
> Ditto.
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


