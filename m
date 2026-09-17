Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB004C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75876B008A; Thu, 17 Sep 2026 10:44:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFECB6B0092; Thu, 17 Sep 2026 10:44:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE056B0093; Thu, 17 Sep 2026 10:44:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9AD886B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:44:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6B58C0388
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:43:59 +0000 (UTC)
X-FDA: 85223523798.04.473DE6B
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0389E1C0007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:43:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=fTCLQKuW;
	spf=pass (imf18.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789656237;
	b=TImgWdx62ljoK0IXTgJ6hQBy8TJpk4Rek8lHkVJ8Zfpyc6xEL09m7vnR1l5z7cx51E9Kul
	oJU55BoDmx/nM7dVH0FNyzzUbFVPi7J1R0WKHRg6Pv2Zdz6EBYI6em2N5pfjCvsW1v4L3Y
	Dc+EhRB+swR/OExQUMSDXEQsjEuS74g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=fTCLQKuW;
	spf=pass (imf18.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789656237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i93/h80AlAOJhM1IVnZquGXYeyAbH8OiH5T1yHv0Eug=;
	b=ky0zrQJV16orX3Qw2ZAi0qDJJqSuwMHKJHIMZTJpdvWbhB+OXX2ZR78OQuDW2/4sRdgPnW
	sNtvJnqxr33MVlmzdd8ragB3PJW7tjeCfrmrkmeuJDcKqm1jPYwmcq30gmDm+uTKQ7FNs1
	9H6b7qSW3b2UQeLH8xY8UHzFI3sXXas=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=i93/h80AlAOJhM1IVnZquGXYeyAbH8OiH5T1yHv0Eug=;
	b=fTCLQKuW3z1DHdPHokT+OISreU9xFW2wXMpb/r4DFyAd2MI3J2yp/LZrWMfFxAuUWFLFgWhpT
	HVcxPAjOJqlO6Z6Am30KGV4Q8sGVR4FozZ7vT2ss0x1jcIG5b0M5ddMmJVJNcPet7e//fCgqRrX
	vIsmUp0qp2F10RsJkF3hXqI=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hlz4r5BfGzJ46dV;
	Thu, 17 Sep 2026 22:42:52 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 0EA3840584;
	Thu, 17 Sep 2026 22:43:49 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 17:43:48 +0300
Message-ID: <9cc251f3-028f-471a-b12c-17c98f868ab9@huawei-partners.com>
Date: Thu, 17 Sep 2026 17:43:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] mm/damon/api: remove NR_DAMOS_FILTER_TYPES
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: <damon@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260917142210.90829-1-sj@kernel.org>
 <20260917142210.90829-2-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260917142210.90829-2-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0389E1C0007
X-Stat-Signature: nrd8r3aiokqne9785kybcc5zp168cmpw
X-HE-Tag: 1789656234-122936
X-HE-Meta: U2FsdGVkX18VES01rpn9nTw3LXFSo3yY52vTO/B/MXsTl28LQGo9pAhKDmm+gY1oN4EmlEnrXNeIfirdMvwCrOy30G2kgfL8kCPxlzkpA7Cd/G8ITZ2wNuD07Dwxjm9uxzalUrmv7+ayKh7VGyk9SdQ5UKqYy/o3RcCuLSR/h01ECYenSoL88CO8Y0pGhJCyx3M8In3JWhXuCMxooj9jw6Nh/9PNwI2UQCwOkK0QvwpDJzpDXgRtnm2nFuYF3ieyNWbrEA59qB3G9k1khIxFxXMXN5mRGxO2zD1MDmiva7rWcOXkRKtoe0pqAgCWXCmviuRagPriAzlhuOWqktYJSw8TnUlcepf5w4Mbxpi/Dy/Exu7RaE7oFVvec4v79f57ecEap7VbgUtbrERSKUyizSfNKmuhBUifeu083Vlq/k/0EYZ/oggCMzJtv2x8FT1CMnPouPtim1fJhRPYHMuLfXMRz3fnKVFxi+bYfctMBFjS8X9hm6EGhFmOkDXa0ZGYSV1aicEcGF4cYBHVbcWj4ubfou2SrXNX4XlglebAX6F5zzg/lPRxTgM0nv+rQlFMJDXlLJ/D8gxQiqwHxEWWRKZxkUb+ss/a1JVEcrnLds3cDCsSa+AuHxQ8j7lz7oGSarNaEw/8nzJnWtYCBcw7TAlAWwSlg8eJPCCfJFwUu3Q4M8GWmtAbya14iTyCXMULfFAnzuETg1/HfCZynEfYcfEd2Tl/gWuEXDmUiGdWoNo9omV98UMjlxbv91kgivhfMNvQI+4Ob1O1E8Xdn3Cu6zQWx+uR/Dx5BHNkTn9HqRBTdxaG2s1Z2tJdKuk9i4+3oJNGkUZFz1JkZyuweINfNIsb+cBq6eCpgINBMdWptLVjrz/sI5Qy8dK/sYraceTTSjMQ3XrC5112U8tNJol48zxZwl9ziqOLhDDQxW52K9GomIRz/wBqoEVF5r74I01Dy918IeyV0m1jnmuxtul
 ogmX1dqm
 CMhLzb5bH3zhxBi+3cqwGrW9/rfleWc1/1sNib69W4D6tE0PlhmS/YymLC1oX1kDvsRrXO2eRwPIo6qYrqvNXdRj/aGEQSnhUxihlal6hUD9Bg4fX/ZwIV9iTUN37fMF7ViL+LchI4W5A8GGYaDQ6Nf/SRdtl+nyTYtPKmJpUMFc14K0ssl7fne98qYsBGMA4g4lVpW9Lmt55eJ+/CANb0IK0MoEUY3bEwwREXJPDRSi+nzN/Rj39yrJdYd444Em/p7CdCfvNls28n++3Da4fChZ4ScArnsMbJZnUkN3OeWY46oKK67dcJgNJ8C+s8IQgAlwymeOTQiVNeBgkqvsgLL59L4Mx/pkbdrX9LdeL6ohceMP+YrEoFjrR8mZHrhJZOOhH/zgdI4ZpuxERwZy9g0jPS66gHjHNDz/afZwitDo1H7z0Qmmz/jVrZqPw3T4pG7ea7/XkiLqL5fuZth/NyRendOHAYOnIR0Bf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 9/17/2026 5:21 PM, SJ Park wrote:
> Nobody uses NR_DAMOS_FILTER_TYPES.  Remove it.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  include/linux/damon.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index bbb190b474015..836353c4ab9aa 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -400,7 +400,6 @@ struct damos_stat {
>   * @DAMOS_FILTER_TYPE_ADDR:	Address range.
>   * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
>   * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
> - * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
>   *
>   * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
>   * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
> @@ -422,7 +421,6 @@ enum damos_filter_type {
>  	DAMOS_FILTER_TYPE_ADDR,
>  	DAMOS_FILTER_TYPE_TARGET,
>  	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
> -	NR_DAMOS_FILTER_TYPES,
>  };
>  
>  /**

Reviewed-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

-- 
Asier Gutierrez
Huawei


