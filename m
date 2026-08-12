Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9137C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D641D6B00A7; Wed, 12 Aug 2026 04:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D423E6B00B3; Wed, 12 Aug 2026 04:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C77E66B00B6; Wed, 12 Aug 2026 04:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8FC46B00A7
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:41:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B17A802E9
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:41:09 +0000 (UTC)
X-FDA: 85091972658.06.2C4BD82
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf12.hostedemail.com (Postfix) with ESMTP id DFB3940007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:41:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lniMTV+6;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786524067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9x325DipK2ypH2fNGZ/mp/01KH+en2kf0GHRtk/+Iyo=;
	b=cY/AhrpV0iXUzNMzSkoVp5/r8mMlY7R/+FT1EMsXWKzHQX+7APL5INEq8HaRXOk3+eqxI5
	CH9q4oV0JHZiicV7IxuzAXuquWdaK0UNc4jveeOA+CVyFiLtZSJiq2rYtUcGXMC3w+05Nq
	UJ6ojrplQMCQ4AC2Af/VrTDvO34lWnE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lniMTV+6;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786524067;
	b=UarhsZkc2w3U/X5hhRRtEaF6618BssOCLDSXjPiegw/4qCjMzU8/GCk9KT7NfGIWnEivb3
	Q7rvopN2FV544RIokcVXSuk/kFB1SWNp+mCUJI8DAVE+G/8zzRpYM8xca12YIKE7/conY6
	72GUX8fK5USJICqtpqZwPehiILVl0UY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786524063; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9x325DipK2ypH2fNGZ/mp/01KH+en2kf0GHRtk/+Iyo=;
	b=lniMTV+62DfgcC14sCxvhWjH2Rtdp+I/AUb3+a/yQqE3n+3caueTjdDOYqbSIissoi0QATrLzF8lZGBGyTNeB6ybbaLp3UUeHFxJr+Sdt7UvfvscCsm1XxidGfJqUHNd3apjKlIuQuYSNUMQMuZs3gJvj4q91qhdzr9Jy9PKWJ4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0X8r1qkw_1786524061;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8r1qkw_1786524061 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Aug 2026 16:41:02 +0800
Message-ID: <d49ced6c-5ea0-4458-8886-09308b606483@linux.alibaba.com>
Date: Wed, 12 Aug 2026 16:41:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] Docs/mm: fix THP policy counts in transhuge
To: Song Hu <husong@kylinos.cn>, linux-mm@kvack.org, akpm@linux-foundation.org
Cc: david@kernel.org, ljs@kernel.org, ziy@nvidia.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260812080313.330413-1-husong@kylinos.cn>
 <20260812080313.330413-3-husong@kylinos.cn>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260812080313.330413-3-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DFB3940007
X-Stat-Signature: 5gxwnoqftaynnyk5r9431tnxyhf3w45f
X-Rspam-User: 
X-HE-Tag: 1786524065-332501
X-HE-Meta: U2FsdGVkX18QbtM5t4FSkHRuWnmvlbi0JpA+H6Kyu9Z9T3tkCiUqpwloB6PvzCbM8pRk+j8s/a8so3YJ1h+HHrqgcam6cIGXgxcuUGAj2QMNwp6KFJe/OP1ABHiOU9JWrriagBF1CUtsVbVM12rQup+iXc0b1DzJZpK7L8kS6nRsnQzaVPRXUFOBiD+xgb2LidAQ8P0d0WpBaosWxGku/QjT5jrroIatmwn1Zh9HI2QLT6THeK8NqIKOA6cOMAJjpZgZctqG7gex6Lh2Dz7QScNlqdJOIPzBtNgnL1bCDjoNKHFQ4ShZBGhFaKKuTmZZDj0y4C4TPhzdtJ9eVAkN+P/DB05Ysc1sZWtT5Vl7rfK30ekJ9nzkoJ/uVG4Z6Irpf8BhKI/d8ZMUXW8Cm0D51ax1E42+JpA39+RP7meS/E2QXJQYpvFjMsABokB/Ci+vG0OPhBHTJy4jY+XHDQebkZXrPfPNiqHDZuX2ixXyPxUJsrMGRF5pmIZgJ24Jq4VtG+gFVxIBSE5QQKme0/ZSAURTF+jLL2CQffAiJet1pU6Zl6ZW1IZb4hQ914yNgH1G7islSSbu4bqYenYIXf1QXWwKf5PfC7yaGu+SyIHeVrlYgIv9KtS8VnnujGfo+yvk8PWHFKiLtZs3S3GXz5DFsr4wDQYlLArWjvV/eAWP5lGoYdK2Oa/I9MXDke3QUSISbz3ucZgTEZyFL0KmSFQBFRIq2tgSL5IxIR+IoIdD5F36T2HUQDsr3N4NJD6MWSra6XQCpr5z8W9jF12T0CTcAnDgM1hBoLl7SUUyoIIhD+0wJR2tx5ib9w1yFiFZ+U07CcZYu3HlfGi3Rp5z69WJVfU1xEuNh51lZg7EPC2GB8jk//9Vp0IBRqFe/eP6G5R+RN84JlY6q8m/FWf7UWx/dyrvUFCSyrqUMRr6PPH14Okn9uvW86w+N4sMLlF3JbbHsyb9aDTCuYi6rcO5gNy
 rEbj8Gcb
 Axclp0o8zlKkUMozHD6Qwi14NY1WIuHDYQgUtpd2ZaWtUFf1NAVJz4uJOK8nTxGSHOMRUwqhuVDpQ/ClVVdtayf5MOJbihPqnCm3tcYIN0+uNMBbFEf81dov/R0Ne76dJruk3BxRieWw7Ury/f2QIebhPb4sbJdhA/KvLgqSdDkowXBMP/HRp90uww7l5d33j87H6Q+X9qd5n2ZswecBTe3wDSDvxARMr31Wwd6vucw3x105ikK3jStbj/yUJCWJfl9ggCwSkjgL3t5WjsEiVE3dP8ez1/89OyvJVTSOE/bdxGxLpY46nty8HHzLYXJp4nWAl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/12/26 4:03 PM, Song Hu wrote:
> transhuge.rst claims seven policies for transparent_hugepage_shmem= and
> four for transparent_hugepage_tmpfs=.  Both boot parameters are parsed by
> shmem_parse_huge(), which accepts six: always, within_size, advise, never,
> deny and force.  The "four" applies only to the per-mount huge= option
> (shmem_param_enums_huge).  Fix both counts to six.
> 
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>   Documentation/admin-guide/mm/transhuge.rst | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index b187d618452f..72e944f49da5 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -389,14 +389,14 @@ is not defined within a valid ``thp_anon``, its policy will default to
>   Similarly to ``transparent_hugepage``, you can control the hugepage
>   allocation policy for the internal shmem mount by using the kernel parameter
>   ``transparent_hugepage_shmem=<policy>``, where ``<policy>`` is one of the
> -seven valid policies for shmem (``always``, ``within_size``, ``advise``,
> +six valid policies for shmem (``always``, ``within_size``, ``advise``,
>   ``never``, ``deny``, and ``force``).

Right.


>   Similarly to ``transparent_hugepage_shmem``, you can control the default
>   hugepage allocation policy for the tmpfs mount by using the kernel parameter
>   ``transparent_hugepage_tmpfs=<policy>``, where ``<policy>`` is one of the
> -four valid policies for tmpfs (``always``, ``within_size``, ``advise``,
> -``never``). The tmpfs mount default policy is ``never``.
> +six valid policies for tmpfs (``always``, ``within_size``, ``advise``,
> +``never``, ``deny``, and ``force``). The tmpfs mount default policy is ``never``.

But this is wrong. Original comments are correct.

