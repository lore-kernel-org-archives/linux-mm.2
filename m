Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46F10C531F9
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 10:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F6856B0088; Tue, 28 Jul 2026 06:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CE796B008A; Tue, 28 Jul 2026 06:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E75C6B008C; Tue, 28 Jul 2026 06:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D04436B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:46:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 529B31402AA
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:46:35 +0000 (UTC)
X-FDA: 85037856750.12.C42496A
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3FDF920006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:46:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FPsBSXfM;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf31.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785235593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIC3b/7o8AMFrBQ283uf6ujNtCi93IZpkLlkVl6wgK0=;
	b=2lTZHhec/sOj0RJdOtpxUG156aJt4MZ6aphGWXTh7L8hC5c7Xu+DmyG74uYihT3TdMPCc/
	ray2WDsAnPuGBgbHGZ8ErxiixPeiC1DHlVXZ5PkNK6cSVGkPuzpOT5HGSKrSPr2mBFwgLb
	mJN0+EZWX+az4h1Gz297TODUzd2JDQo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FPsBSXfM;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf31.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785235593;
	b=8etpyzQ9TuY8tIjbe0Ig3cPG+V3GtD5vJF73jdODGghZgbQ+S6Jh3nnyx0MAQC/bOKDilk
	LH47pYhy7lryJK6XB0+Ipu19fM068ME6bHTS3l7f8Ttandg0X5GsnN5ClfbKKuXqe5VMNk
	ck7bGuHQaA5VOwMFEssRclo7o1om5Ys=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4728c12ba97so2208249f8f.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785235592; x=1785840392; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FIC3b/7o8AMFrBQ283uf6ujNtCi93IZpkLlkVl6wgK0=;
        b=FPsBSXfMiGRbYXrR0PI1/D+veiJBWAo+6vP/Rhm8Ni9Hl5TphbZnrOB+vIwFECdNRB
         mvEifJNLKEFQmoJ1+Cx4V7BwkDxKRzCdCIz2vzSnpg9s3EHglvBizgas24b3bHo0wQ65
         Ixe9pk7Q46ozIBUHeCKrf6cFTIImM3bAsn4FLmRUrgTG9yL7XEVbt4uSvRyV2hmc5nEt
         +hQktMQI/zEwS8vRLEOYVlIPnT7/CQUz0H6fOqspmtP2EUjKWlBEwn87NP9ehVfK6QJE
         W+awGkieD8wv3ZpnnqHjEgM22LOjHJ7UveVw4AkRmsiLeic5mdxzu1ZoY/9JrmVrmygs
         LZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785235592; x=1785840392;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FIC3b/7o8AMFrBQ283uf6ujNtCi93IZpkLlkVl6wgK0=;
        b=fUmVaT4sgh0Sqs0jtL7WK8Z1XAO8WT1+PROpb+g5h72Tzdis+CStuIQ4/5ogazoLu2
         iiYtkTUWtf6EUeum3fGsd2Ex1n8kzgitnH8CbpoMoY25mY7fwKueptAfZgfR9W66GiKW
         01uC2PCAAJFmnlnzkzAgFFMg8BHx8ts1Oid7Ca/nLAabjkVdgT7nBC4wes4kg+cdjPUK
         88ovI6Zxqx7z4qnTfTLrPDFVbre1PHXDNpJUgZUGxBgoKFffg+CMD9Jz8OAw5qw2ygEk
         7XWqtTq+LGPdOyqATO0xBtn7+EbiIGdmMsgGUvSmyqEy/OQjRaFNkjNBz6oE9qgDX3vN
         gTnw==
X-Forwarded-Encrypted: i=1; AHgh+RouLnNYyhrlJc7GxIzczT57krOBUCz/k+r4dWWcvDRqq2Ra+SavQnvuhIUIYlHXsZJipIjz/MAV9Q==@kvack.org
X-Gm-Message-State: AOJu0YxaiQW0zgKcUy3X9L3CdHoOI2fDKW/lDfpxEBXwnsfGgJ9jc1aV
	6t06+9490p1TZMN0hNi2lzbf8YW3ecHN29wV2COVT8LZtF+ZCVMZotZNNqlkWSrpb1Q=
X-Gm-Gg: AR+sD11Fb/2V2WWhg6vPKdttuTBuZqQAa/JVOI5xs9wqM+HrmB07+zVluh8cWZkqyn/
	gbxtJdqKdxTzN8mvsttStJ7OWQBe+S42sp5Z0O7SAJIEeMyjDcTo09chxQ3kATKL4EuXDnirWIj
	m6HTXKVWTo9Ttpnvot2SJbxAoFbswOHV5droL2IRSDC5KQE+WSnfSR9zJ/f/aSWpOveJaJ6Qx3x
	l1wSm3eVqlUgkR5JwOxRMV66vi0GG39EX2l6CIDH4+13T/YdLhqF0gs1wf5+tmP4Wo4pVzr2KCk
	GIaz4g//3wS3SH7aoVbcSpGICa/HZTD/n+3I/om7YVi41gsuwv7UnJhE1n4Y6OU9+SNzsJz4FCS
	HKZFdJLsxk/hvdzKZ0IlW3XoqVOhch00xOh0IQ0SwAjkWoJQXU82w0zUfk93/wuuyPnkkn0KMPS
	lSsmPr7Tzsa6k6U1N0aKQy71zyIE11AH6PZWaZj7I=
X-Received: by 2002:a05:6000:1884:b0:47f:9096:3c54 with SMTP id ffacd0b85a97d-47fb1ecc318mr2141112f8f.11.1785235591768;
        Tue, 28 Jul 2026 03:46:31 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:fc6c:f9a2:4a0a:6354? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c6e9a2sm59717727f8f.35.2026.07.28.03.46.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 03:46:31 -0700 (PDT)
Message-ID: <dfe25916-0f2e-44ed-8f49-d7448a0e28fa@suse.com>
Date: Tue, 28 Jul 2026 12:46:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] params: fix charp corruption on allocation failure
To: Jiacheng Yu <yujiacheng3@huawei.com>
Cc: samitolvanen@google.com, rusty@rustcorp.com.au, hannes@cmpxchg.org,
 yosry@kernel.org, nphamcs@gmail.com, liuyongqiang13@huawei.com,
 linux-modules@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260728085518.3865621-1-yujiacheng3@huawei.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260728085518.3865621-1-yujiacheng3@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3FDF920006
X-Rspam-User: 
X-Stat-Signature: ry1t1rfe6p3ozykascadw6by66einz9e
X-HE-Tag: 1785235593-730174
X-HE-Meta: U2FsdGVkX18E35A5CBe2+O/l1XpyEhsLouOl8NgxEDpgcZ3xppLvTDBTtEC3MyglBDpYapX7A5mwmDVsA00ZWmYTgb1WhsbNODkpuUR5OG7LOCLKUCLcGQjkDu5lxLmEKzhSQF7PeSZCP8iquMnJF6UMd5/HZNTmP8Y90wnjGruAVgFzmlbX0W27OeUspLYnLU4FvABRLrk3Quh/9vGYWN8xZaz3Tulw9cfjfEVAVKaBSwa7WINg01ZhOF4uACrJ0iXYd9EVy+ZqoET6mTxErhS6pCaNuaObCd3WX4MeMHVvc24+sppAO1d7u53iT/yoEboIfd1xwzLydKXpqyYaBtPjjCqi2ZlWGqCYmD9Lm9NAo1zQV+ux+OvGy1FY8ZI76WY/8jbWb9hrBYclE8vW9OglSQsYZcJFZGjIbh5ETvzTjhp56p6sKcBnq7f+ln2HS0DZ0m206073+veNVIWH25w/VvQtIDQwe8J/i/acSjgkKEpmhNfNORCZMPaAukfp8wbdk+pa7PNViM8cWbVVvJLr5XFvf+JNZz8lCoy0ckq53tNVfkOZ/VujmEllOmcIlZsxkmwkQeFgeOGzqBdjkRmaVDTHmurr9Lv76rViZR4G+/VqKWfFm6uKit6+hsC/U3N6N40f3Pn3+Sv2RNSp6Q3H7F48oc0W6ZKLwhbRZQ+izZ9eS25jbWGhfAzj6CKf8RoNS+eJLW680jiPrXUWSVWPP2152D6OEmVlCe53Cj9DxWlcjfXpaVsFbN6g0fRKtJUbqKSAkDqTIcF/zhUynayNq+ayYGYZt0S3GK7uP0NXtpr5EZTWM0D16Wy15J/eAfq24+gTRCjVUljOot1AcGBznLKUUNE5B3MO7kUnYwckx+Z9f9VDq2WQ2W/reu4QlSwF49eJ7Gg/jb5oxk74IY1ZO52MQGo++ya7Jzcmmm21OoDlqS3eyQo83LiMAJN1OnVSTs2J4ubKafSYDAN
 bsagXbbY
 JkMjW/jqqaHwG63Tob61ZIOt3r3VzoDR9D/TglwZmYFTUqmCszbj2+9trDJchzvY2Mq+cSoi96E85AEHo9pXqQMJ1hJpSbjRsfV8pptTUfkUpCcVqB31gMZYC40Q5FxMVGA2qWV+Zzbs/h26o8Q1XpLI2Fx969Q/fRqoc7GBObxwJQkrY0jJfIVgh6k/7XA4wGxemrizw4O0R1IoIYrKU38vC51rFVQhzPd47KbL+kv+4i22QLUuWznZDvWao9eW6WDB+LfNm2O/DYstzB4ko5UEclBT4HCRg71HxjqtemBnTz0oGf3IEtsFQlSL0EsHIW7WYtKHqanh3vGJDGwrUpeeGRGhJAW+7gywCNp8K7RscxuHH/gBYKrInvIo1SqWySSTs3yxiWgQ/hLX/c6P7RObV9O99Oi8CJGlEFWAeZMAtEImzClkdbui/NyzrbM6eit8Fh4EYCC5HwtO9G7kGYASp+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 10:55 AM, Jiacheng Yu wrote:
> param_set_charp() stores charp parameters in allocated memory after slab is
> available, and releases the previous value when the parameter is updated.
> 
> The previous value is released before the replacement allocation succeeds.
> If kmalloc_parameter() fails, the setter returns -ENOMEM with the parameter
> left as NULL.
> 
> Failing zswap's compressor update before zswap is initialized can later
> trigger:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:strcmp+0x10/0x30
>   Call Trace:
>     zswap_setup+0x3b1/0x490
>     zswap_enabled_param_set+0x5b/0xa0
>     param_attr_store+0x93/0xe0
>     module_attr_store+0x1c/0x30
>     kernfs_fop_write_iter+0x116/0x1f0
> 
> Allocate and copy the replacement first, then replace the parameter value
> only after allocation succeeds.
> 
> Fixes: e180a6b7759a ("param: fix charp parameters set via sysfs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>

It makes sense to me for param_set_charp() to have commit-or-rollback
semantics. The set callbacks of other standard parameters behave this
way, with the exception of array parameters.

> ---
>  kernel/params.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/params.c b/kernel/params.c
> index a668863a4bb6..e4f2b71dde1e 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -261,6 +261,7 @@ EXPORT_SYMBOL_GPL(param_set_uint_minmax);
>  
>  int param_set_charp(const char *val, const struct kernel_param *kp)
>  {
> +	char *tmp;
>  	size_t len, maxlen = 1024;
>  
>  	len = strnlen(val, maxlen + 1);
> @@ -269,19 +270,20 @@ int param_set_charp(const char *val, const struct kernel_param *kp)
>  		return -ENOSPC;
>  	}
>  
> -	maybe_kfree_parameter(*(char **)kp->arg);
> -
>  	/*
>  	 * This is a hack. We can't kmalloc() in early boot, and we
>  	 * don't need to; this mangled commandline is preserved.
>  	 */
>  	if (slab_is_available()) {
> -		*(char **)kp->arg = kmalloc_parameter(len + 1);
> -		if (!*(char **)kp->arg)
> +		tmp = kmalloc_parameter(len + 1);
> +		if (!tmp)
>  			return -ENOMEM;
> -		strcpy(*(char **)kp->arg, val);
> +		strscpy(tmp, val, len + 1);

What's wrong with the plain strcpy() here?

>  	} else
> -		*(const char **)kp->arg = val;
> +		tmp = (char *)val;
> +
> +	maybe_kfree_parameter(*(char **)kp->arg);
> +	*(char **)kp->arg = tmp;

Sashiko reports [1] that there is a pre-existing use-after-free window
between freeing the old parameter and updating kp->arg. However, this
issue doesn't appear to be valid because any concurrent access to
a writable charp parameter should be protected by kernel_param_lock().
This is documented include/linux/moduleparam.h [2].

>  
>  	return 0;
>  }

[1] https://lore.kernel.org/linux-modules/20260728075803.AA13C1F000E9@smtp.kernel.org/
[2] https://github.com/torvalds/linux/blob/v7.2-rc5/include/linux/moduleparam.h#L124

-- 
Thanks,
Petr

