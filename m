Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1C7DCFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 15:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88436B0011; Tue,  2 Dec 2025 10:51:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5F6E6B0024; Tue,  2 Dec 2025 10:51:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94E8B6B0026; Tue,  2 Dec 2025 10:51:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81C686B0011
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:51:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8DE861399C0
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:51:08 +0000 (UTC)
X-FDA: 84174969816.21.0878EBA
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6C03140014
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:51:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BGajvX77;
	spf=pass (imf11.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764690666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0jF0fLRJNMBnQ1rT5kegL2zQL7JDmOAYD7gzv1mgMQ=;
	b=O51S7u2klgKnHid/dNgZeV5MhfziN7MU+Gh74bzPcaE09dHIv9DZ9qpSkqX7+fqjifCqMC
	VVG5yVxgU7tO8ZaABZ9UPx4iviL0/iXssUesCTE67PQgkxbcpcFj2J1w16ZJlgpfgCXwIy
	/PI381+vkVt0c2Jspn1m4fcXh618T0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764690666; a=rsa-sha256;
	cv=none;
	b=GeF4+TylSG6QFEPwcH1cFOCfSRoWunSEfdHZSyFEUdlCK2h5pHPJdjMABxxf85TySeWxKY
	pEq69ckQ3kIHLgZ7zApyPkfYFxuoSOmeb2CGGQu5U+W2SYagom6w8GgTKuDySoAVGT4JNr
	5Q9FPFgpYn3TbFz/o3V8oK7monzYJHE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BGajvX77;
	spf=pass (imf11.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477a219dbcaso51516365e9.3
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 07:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764690665; x=1765295465; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B0jF0fLRJNMBnQ1rT5kegL2zQL7JDmOAYD7gzv1mgMQ=;
        b=BGajvX777qLVE8zVn3MNfHwg39Ekf5npsQfejanGvaf58t0uJjx2IXmEP3U+7w/2IV
         oqGyNa1SHo1w8hwhdjQxYKgvANlD55uo9SEkXRi32MBeAoE0Ys0AcQPiQbVsuXdC069n
         bWSgDon8WIKsSYFuABZ+Mi7jr52r7Z6vud/2eKCXpnktfscgIO4DJle7jk7idwZkRFYG
         JDAaUFroDw5mMd/yt0Jor2Vzt4UOGafx/aQHcZmlarJ+ombqSqNlz29pPGz+lPlre0Dq
         cajtT4lmBWgfgpvaHa5c/iNKVvm50b25o+C5eppg3TEjvkbbUSFLDTjIQ7+ISUOt1wep
         0xYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764690665; x=1765295465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B0jF0fLRJNMBnQ1rT5kegL2zQL7JDmOAYD7gzv1mgMQ=;
        b=E6gNArX+34vpD82b8+IHSM0y3UPhxugcF9rM0o+GOb+IS90K5NATw95yc8Zz+gYOxd
         ezLoSXxEbL4QMcmCUtZUK9QryL4+h4OVF3PPPo/kOcBfR3uDBh/t9ahADaWyobW9I5C1
         jGIw4U12W+ryCEBXbia6I0YN4G9gKAUfR7q2Ou4qIPh+o2pa+pMGAn/zUC1JnS6ma3LT
         hYN06aLmhTvVIp1cq/iAX+P7EL55JDKrGgUrbQ4iuU1Au2v+xO8UyT6n/s8JrFE8Apfs
         hEFdRC6Kq+SpZkt0/Ce+8vhmMo2mkBEz1Z/Ky98K1WBCNk6hgmlcV6X/obqPgMLTUk4E
         XvkA==
X-Forwarded-Encrypted: i=1; AJvYcCVpHtFy6RY9u8ClreJa+7H5j1/YBtUWI24Ak9a617pCeLX1yATa7xQ3mnHqlEcAu5ct94+Nv/jsiw==@kvack.org
X-Gm-Message-State: AOJu0YzV2zA2Td1LLoKIH6+zrdux+C9dQtAlTvmVmg84o/TMpxugMZa1
	Bqka0vFFCmwyF44begr9vGGHIc33WtK4/l7cop+2fbqn/l75LW0nG3Ho70b5QQZHJKw=
X-Gm-Gg: ASbGncv6HPYkQzEEQjAJfWqFtYx5T7okHyyhUVMzHW/vB+R/1/QuUSKUwRWulvyvm6o
	dOby8eQ/7MkPnfY8pgiO+/akomdC9BYLayiFaMNAtK3m7qj6os68J4dXcqpWhb1y2aoENW5rdbF
	Qq4tXbYyNIi3fzNkICik+Tezt6kgSx164V3zSInLuzeUMx3AvxDW3tarG2TtwVKQbK0zaGk9j9s
	SJTqP003NF+YTbe9zDSdt4dLbbBI7+O5PqCReOVsLsZyCGZOWv/8ROo5/lijmQO50Gru7/wbG/v
	pEymMQhmT2SyZuoi+8VpTeANib7iEFaA5gkZ7945grLid1AV/saCINrpa9w8mU0622kA6/gXiBO
	rTq5/pCDD07Cz5zdXlCL3X1cBff8WxyPk51JAOvl681ljb6xY23ydSiUUGhNbjxW30AQb/hCa4+
	d6EfyImRzGyjuf+A==
X-Google-Smtp-Source: AGHT+IHebbf5Vw9lZaq6IFuFTBYRPHyOz2I2Hu7QCHyEQlP3wRlC/78XfKOVh0LrRV4BfxEgcaUNNw==
X-Received: by 2002:a05:600c:4e88:b0:46e:7247:cbc0 with SMTP id 5b1f17b1804b1-477c01d4af2mr422946075e9.18.1764690664742;
        Tue, 02 Dec 2025 07:51:04 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479279d930dsm18024735e9.6.2025.12.02.07.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 07:51:04 -0800 (PST)
Date: Tue, 2 Dec 2025 16:51:00 +0100
From: Petr Mladek <pmladek@suse.com>
To: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v2 3/5] drivers/core: simplify variadic args handling
Message-ID: <aS8K5DnumUA6XUs9@pathway.suse.cz>
References: <20251201-va_format_call-v2-0-2906f3093b60@intel.com>
 <20251201-va_format_call-v2-3-2906f3093b60@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201-va_format_call-v2-3-2906f3093b60@intel.com>
X-Rspamd-Queue-Id: 6C03140014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: jaxebfzua7ewxrgtyme5yf6tp41fcbqg
X-HE-Tag: 1764690666-278249
X-HE-Meta: U2FsdGVkX1+w162r1pW3XkfVGY3fKtSS0kcGaBBZ5j/4q/melW1LBLTSwvEbHt4gdCMzg3LVh5Ax1zMhuWF6712TaHTb79w79aAO6YUUcC41nR1bzD/XYyeM8pNk44W5+8rVG4dE7bRTFJQ2wPCMJf62lVLWPQDpfYesdpqcapJoS6YInkUyloyt31WjAmKIkpIKwFvlIvKkVGylhqxgMgmmqrQ+Af+exEoqCupcBojORAwSmK1m63paKmaF5JR0AkINZi6gKUKS9rKlEwxpk6ZGtC4vr4cXjR/BKxU5YPefzM+r9+kq3M7P8vsOCBp3uQGkHXiCrII7r3iyiKGRFCF66wzNY6HIRIJ3XHgwviu2anJfqjvVoCiywueKxAjOrLGMBHDpgqZItbUagvKFsd2GhBxJ+DuhSgDWf4wMN+h2NerAI6ttvu5VQSPZ0cNzWKMbY1WI/8MbsGHarDZuvDk5rvmNWrkk5iMSE6N40t+PhfSmPL4xvjux1tyEGWUT13CNtexi31wvp0cvy4w+T/xzV1BGAlgXLm2Jgbe2Xa5OApeadUw4oo9/BgneFdIdrl2KEml+E0dN4sg6S7pjUiknqdQfrBXD3zrWZAiaBIVnoqLDkk3y6SiI66bEiZUVpzHX624Zc9ofe2zi4pufmP3AS0uI1IjTxlb/ghcLs8sSCrrX1uRpggJkXPadcKK0eXh/AtcOyzf4D42zrjnHuHWyBinJcm8h+B+G5va5sTcpoB7JnYKJ2pAFFGZf3D/KPMzCC2biWmZbA4uNAOsopPTlj5zKyXqux4vVOUHAnIhD2QLaD+3JTf1SWrBG8FMA7uSyspHrjSP25o2FGyFJkUSnmZhYxKA5cn69AHHObu5M9VrKqTd44MDWtJayEA2nsBRNNLWK6LItnhj5znI+iN0X+dlzFVqPuP7FOcVjMzXoi8fxLcPE89pFiIvJo3lIgn2iRGKMgHCMMZwg8Wk
 RIag2Opw
 fewDiI9XaLzVO2oSxCUyztXOFhYzlwwfTts6UQDqjYlWmvPrD07Rf+mOSG3vvAWodNigW+T6jTE3dt/5J3Cm1pgno0okFlOgGY/WSeW2kfiPJYawJqTLOoTczimO7eUIgIZ7UWJNpWXTOCEmESZl/DBXl9iGcCp4v6WjkQNyIrDohDm6VdHfMEsB/4QNvEefVqyu9XK0xgmw/Q0on+VbYDzqNgm/29CYdTcYaBgo4KWfBV1vRVcDiAZneNhq37FA7EynjjeX0MkiTJfe8/Fy1Q6QUBlWI7tCw/7ghgAyy/hyhF3RJWRmu9Ct6/nsA80Wb+12G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I am adding Andy and Rasmus into Cc who are active vsprintf-related
code reviewers...

You might see the entire patchset at
https://lore.kernel.org/all/20251201-va_format_call-v2-0-2906f3093b60@intel.com/

On Mon 2025-12-01 10:31:24, Andrzej Hajda wrote:
> Changing argument type from va_list to struct va_format * allows
> to simplify variadic argument handling with va_format_call helper.
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 513e5ef8a6da..4d76b67a87e3 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -4965,30 +4965,12 @@ define_dev_printk_level(_dev_info, KERN_INFO);
>  #endif
>  
>  static void __dev_probe_failed(const struct device *dev, int err, bool fatal,
> -			       const char *fmt, va_list vargsp)
> +			       const char *fmt, struct va_format *vaf)
>  {
> -	struct va_format vaf;
> -	va_list vargs;
> -
> -	/*
> -	 * On x86_64 and possibly on other architectures, va_list is actually a
> -	 * size-1 array containing a structure.  As a result, function parameter
> -	 * vargsp decays from T[1] to T*, and &vargsp has type T** rather than
> -	 * T(*)[1], which is expected by its assignment to vaf.va below.
> -	 *
> -	 * One standard way to solve this mess is by creating a copy in a local
> -	 * variable of type va_list and then using a pointer to that local copy
> -	 * instead, which is the approach employed here.
> -	 */
> -	va_copy(vargs, vargsp);
> -
> -	vaf.fmt = fmt;
> -	vaf.va = &vargs;

I am always a bit lost when using this API.
Why is it safe to remove the va_copy() here, please?

The va_format_call() uses va_start()/va_end() which is replacing
these calls in dev_err_probe() and dev_warn_probe().

It is possible that the original code was actually wrong because
it uses the same copy (&vaf) everywhere, see below.

>  	switch (err) {
>  	case -EPROBE_DEFER:
> -		device_set_deferred_probe_reason(dev, &vaf);

This function processes the arguments via:

  + device_set_deferred_probe_reason()
    + kasprintf()
      + va_start()/va_end()

> -		dev_dbg(dev, "error %pe: %pV", ERR_PTR(err), &vaf);

This function uses the already processed copy of the arguments.
IMHO, it might print a garbage because of this. IMHO, it should use
the original va_list() or might need its own copy.

Note that this call does not modify the va_list because it uses "%pV"
and vsprintf() creates its own copy in this case, see va_format()
in lib/vsprintf.c.

> +		device_set_deferred_probe_reason(dev, vaf);
> +		dev_dbg(dev, "error %pe: %pV", ERR_PTR(err), vaf);
>  		break;
>  
>  	case -ENOMEM:
> @@ -4998,13 +4980,11 @@ static void __dev_probe_failed(const struct device *dev, int err, bool fatal,
>  	default:
>  		/* Log fatal final failures as errors, otherwise produce warnings */
>  		if (fatal)
> -			dev_err(dev, "error %pe: %pV", ERR_PTR(err), &vaf);
> +			dev_err(dev, "error %pe: %pV", ERR_PTR(err), vaf);
>  		else
> -			dev_warn(dev, "error %pe: %pV", ERR_PTR(err), &vaf);
> +			dev_warn(dev, "error %pe: %pV", ERR_PTR(err), vaf);

This should be fine because of using "%pV".

>  		break;
>  	}
> -
> -	va_end(vargs);
>  }
>  
>  /**
> @@ -5042,15 +5022,7 @@ static void __dev_probe_failed(const struct device *dev, int err, bool fatal,
>   */
>  int dev_err_probe(const struct device *dev, int err, const char *fmt, ...)
>  {
> -	va_list vargs;
> -
> -	va_start(vargs, fmt);
> -
> -	/* Use dev_err() for logging when err doesn't equal -EPROBE_DEFER */
> -	__dev_probe_failed(dev, err, true, fmt, vargs);
> -
> -	va_end(vargs);
> -
> +	va_format_call(fmt, __dev_probe_failed, dev, err, true, fmt, va_format_arg);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(dev_err_probe);
> @@ -5090,15 +5062,7 @@ EXPORT_SYMBOL_GPL(dev_err_probe);
>   */
>  int dev_warn_probe(const struct device *dev, int err, const char *fmt, ...)
>  {
> -	va_list vargs;
> -
> -	va_start(vargs, fmt);
> -
> -	/* Use dev_warn() for logging when err doesn't equal -EPROBE_DEFER */
> -	__dev_probe_failed(dev, err, false, fmt, vargs);
> -
> -	va_end(vargs);
> -
> +	va_format_call(fmt, __dev_probe_failed, dev, err, false, fmt, va_format_arg);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(dev_warn_probe);

Best Regards,
Petr

