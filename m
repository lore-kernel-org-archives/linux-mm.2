Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 549D0CFA464
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 01:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B686B0028; Thu, 20 Nov 2025 20:17:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BC0A6B0029; Thu, 20 Nov 2025 20:17:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9546B002A; Thu, 20 Nov 2025 20:17:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4E4C66B0028
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:17:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3B9A5663F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:17:42 +0000 (UTC)
X-FDA: 84132851964.02.C7BB740
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2EDEBC000C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:17:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Cowy9MsB;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763687861; a=rsa-sha256;
	cv=none;
	b=Pg6tyOGoz43Ozvy9cd1m4WfVMmdsQd3s4qyBJO7vaq++4zbBWA4ribUjQWxJMhJK1ZkMK/
	QeOfZhltd5AVlDavwHzmYjVTm64ABnc7yHh4DaC0PPp0DnbucTQGpZ9diIPfcupXoZ/N1Z
	eW0I7lj8zpn7vbwAqo0CpqVVFNtYees=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Cowy9MsB;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763687861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EVCPquu2mzRlqKUwfc3X42GlqjTk2ABVz1wZ4VG04Cw=;
	b=NVkJs2B3BS9B8oyV78/UMTBKMAMNafBsShm0m0Lhe6oEjMX2JJS9Urvxr10u+9B+U+uzQo
	Mj2nbiOEQ58Py72Tu9naSVtQO89CVR5WynliCXWVOEJ/hpW8Hvf6J0sL4tbOucJhvMoN3J
	cp3kOsIlKl1gswntKnfec9bDjI/WWss=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E68BA4381A;
	Fri, 21 Nov 2025 01:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B856C4CEF1;
	Fri, 21 Nov 2025 01:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763687859;
	bh=ZT6q0M63/4cXHdV+BClRzPOJA/u0+wdnrOMc5HYUXIw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Cowy9MsBY3XZQQ1HS6JF8Te3k7jLI7mAAtVWJHKLH7sU5r8T7sHapjoFGr8TgJGdi
	 yWCas/O3bmgijmoco3s2D2Kg/fLcA/crWp4RBM9gmBFBeyxeJn6z+TEQKuU95dr0wH
	 nZXfIF3ABlJnTwV7lSgzMRlWv1z2ekjrnzK39HuA=
Date: Thu, 20 Nov 2025 17:17:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>, Yuwen Chen <ywen.chen@foxmail.com>,
 Richard Chang <richardycc@google.com>, Brian Geffon <bgeffon@google.com>,
 Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-block@vger.kernel.org
Subject: Re: [PATCHv4 2/6] zram: add writeback batch size device attr
Message-Id: <20251120171738.84516c55e4aaeea0bf3b7725@linux-foundation.org>
In-Reply-To: <20251118073000.1928107-3-senozhatsky@chromium.org>
References: <20251118073000.1928107-1-senozhatsky@chromium.org>
	<20251118073000.1928107-3-senozhatsky@chromium.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2EDEBC000C
X-Rspamd-Server: rspam07
X-Stat-Signature: as4g4etj1dtiku7j5574mchhnotrw67k
X-Rspam-User: 
X-HE-Tag: 1763687860-954171
X-HE-Meta: U2FsdGVkX19csihTKvmYUDEet3SPO0bouYYC2si8ZmBcNDFcXUMrUOS4qOXKZ0b3bApOtWOipXz/uSBExmrdTFaLY0LYp/d+jwDet5XD61VtQicH1APJl66Qq5kqg3m+mea+r7QJ+Br4RycS1Pzt5FajzGIpi4iprqvcHF3JQThfzKh7StEd190Nnj2KfnfKZapDfUNVGZ8bEJASp6v/KSQv1ntwj2L4fQGpFV+z9zfQTXu1nY47DBKvRoKagN8iejAK1GNkfbJ/hRos978f+7fnPvvovyy/vXfYE+55KZhAsQPU0n6bylfhio3okqgS5zbPKGhzf0W2s9ESoGElX13i8okS7e/f+sIYV8aonMBed7nyMHcx5wB7EkZVNz3s1HSr+THkolD6jFZQOo13j6Z5iN/iKvF+tOa9ycG++VZBdpziBH5sZrQ7f7A1PV8+igrhxk6sKkNpYEzM4+1gkEVyEI758tBPgDqgTf/XVb55xjRtnBq4WKpbza0gJPraJMZ8mc8pAk+04oGpMKFefNCeo2Y6J2efO0nza+U/3Dcana7RWMWYPD5duA5KBuwNE8GrOLm3F32E9ClcX1IqMEgk/453UinbfAd9dxvbRNtTAiPM370/6DoH5+7KpzrI0cJdAqhWGGwVTiLISRTK0IdOPxdBrRY8OuuY6w6ijFpMn+fy0+zFRR/zJVNHivlchTvUzdkRAq+YN5U8s3WAIVB2ansEKxu6OZtq7TgPP5srl/EPoEa+6kkYCt61bzJeBy8e+lORmdsQvGMgCw6xUNTOZmyx8fF+E50dFdMxVUybJmbBMXPUTGeAD20I8bU14D00eTC3vGHy2KdwkjlyM5iJVed8fqvznA8TArF4C4o4/Bn0UKNK+McSs5B6OmABquMdBfcsyl+shtHE6Vy/hs4OJ/YcX+Mu10MOWXwd8Gz/KLMnAcJ4tVdQioBdKlaFUgsxh8wuGFeMzr/kieT
 C5CXFwxV
 XWer1phADDNSpyJGHTMAW5RvQt6wRVfjkz4G9PZA54kyfgcLpCsmQCjrUfpNIofW3HcNwJiX9yJQok5kBJx8rk+v49JiFJaEBtdhfnwMe/O10sgkBbJTTH04/ptyjimaPBrzFqS+p0E2uhO1NLs7wnMIKY+CduIXWPujPIi93QJdAeSUUCG4KKCdlUFD2y/lcZBep9OwCRzlk7tvxVJzD0IYcaSmGmOMTtq+E/eftoHE1XVyLYaRyrUap7AfcxZB6tKtVadOLTPMg3KyAXO5rY/Ygww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 16:29:56 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> Introduce writeback_batch_size device attribute so that
> the maximum number of in-flight writeback bio requests
> can be configured at run-time per-device.  This essentially
> enables batched bio writeback.
> 
> ...
>
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -588,6 +588,42 @@ static ssize_t writeback_limit_show(struct device *dev,
>  	return sysfs_emit(buf, "%llu\n", val);
>  }
>  
> +static ssize_t writeback_batch_size_store(struct device *dev,
> +					  struct device_attribute *attr,
> +					  const char *buf, size_t len)
> +{
> +	struct zram *zram = dev_to_zram(dev);
> +	u32 val;
> +	ssize_t ret = -EINVAL;
> +
> +	if (kstrtouint(buf, 10, &val))
> +		return ret;
> +
> +	if (!val)
> +		val = 1;
> +
> +	down_read(&zram->init_lock);

down_write()?

> +	zram->wb_batch_size = val;
> +	up_read(&zram->init_lock);
> +	ret = len;
> +
> +	return ret;
> +}


