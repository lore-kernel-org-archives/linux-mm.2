Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F6FCC982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 22:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E38D6B0098; Thu, 17 Sep 2026 18:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4426B0099; Thu, 17 Sep 2026 18:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF6C6B009B; Thu, 17 Sep 2026 18:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 422A76B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:04:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94CAF1404D3
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:04:47 +0000 (UTC)
X-FDA: 85224634614.20.CB11248
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6192B18000D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:04:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lH3U3sA7;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789682686;
	b=kKgi0fcnyZZhHgrq6J5S1oSYhE2sfujilO0KSl/aTYsi0UgHAHDPZE3+nN3zS5SbA+I/vq
	4UtB8U1DgSXxWtfy23wOuBIrEx7Z9fT38xg6yzLhihvryLGN5iFxaUozm7n7OGCgn8clPW
	0+pSp4e8O/8Kfs/8Uz5l95uuEQGEUvs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lH3U3sA7;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789682686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sit5dXgTLfs5SZTHMDJB36zhXNOrd/YRYjrGNUNPW7Q=;
	b=tBnT8FBZG0JRZtccA5H/I2omoj+A8c3H+qosi+gHRsz1cDQ3/CgeVVnWBXTFvCGAiAqhvd
	7ET+Vcyhrog75DSo57v0CGHNcaL0Op+oVAJ5i8pbyPao4FJ83vUZfGrNKK7Fon0ctbo1bG
	kxVSJbfQbgr6DFRE89sYblnHzT7n3GM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C717740F13;
	Thu, 17 Sep 2026 22:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6951A1F000FF;
	Thu, 17 Sep 2026 22:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789682683;
	bh=Sit5dXgTLfs5SZTHMDJB36zhXNOrd/YRYjrGNUNPW7Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lH3U3sA7tXBSJpQNADy8QF2OUE6QzGtoSMlQOkfETtznsSSAaCIFEnaqmD4Cpq1Df
	 hKrrRPFDQ5POnjSuKefCfTrDXb8evzmlVlpUMvAXQd3qPG/UtBkhU5QqO+jAWCaD71
	 8U0z2OCbwjOL913H45G3aJjGWm03WnbgaJtrQgWE=
Date: Thu, 17 Sep 2026 15:04:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH 3/3] mm: kmemleak: raise min_unref_scans to 3 for
 verbose auto-scan
Message-Id: <20260917150443.a872ea0fd692503c53b2b773@linux-foundation.org>
In-Reply-To: <20260917-b4-kmemleak-doc-v1-3-84fde6d1f749@debian.org>
References: <20260917-b4-kmemleak-doc-v1-0-84fde6d1f749@debian.org>
	<20260917-b4-kmemleak-doc-v1-3-84fde6d1f749@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6192B18000D
X-Stat-Signature: xyd9taxkueij836x6bw843g4yebeqybx
X-HE-Tag: 1789682685-360285
X-HE-Meta: U2FsdGVkX1/uo5QaCeoFKhehsMebM9HLojhize6EsNXEHu+afc6ABDSKVjQWQBdFDZKNNoHyQDKj8ElciT7bjZvlLyK+23MXTA0izk+BpWJJpUmjIdNe3Ipx2UJ0PhmF8gjuYio9trh0k3BpU5uekxQYQpsAnVG/YNHYEDOAfojASrTNSkAmqJomQm3CMtb6HWefSZ8ERvpFSl6lCxrRZ45sROMIRIOhtUbf+H39gG463tj5OrwOvu7s1clwOaE3HBS8lnhw3eI8lMkRsHAak8Xfl2IkYG78OMbi9MKpnw0kycpQF4y4h0G1g3y12CX+y2FbnkM+GFN6Zzqarzf48nixuprA4JEjTnnUbFq8i1HvN8UUBJtlvZFJOhOXZUHM9zofSax9uipcNdgbBCYN+RA8QjZBdP//91gMLIvUhjcKEgd1KXaAjfV4uXqjyuArzfJNiZIHMai83jlOyk+tluKl4mq3Or5IaOMNKl5z4tk9ljGTvKwsAYJA68dRkN0Y49bcUCdBl5njxSdNtGxE0HMVOQnJkw+1eJsDhw7eQw4h+SDu2Lcmyi7d4PKP3uLJy8YaxCoFJr/RkWgHSKv5xr5KdfKYOfP9fUe/lHjUhS2KR1Xge2tLbN61M0OCLyCDC9r2kCSiDRkjGb2QkdcxWrX+HGo3sk553dRH+pIK2JuDYyXI+F9GMWEjLi3VuI1jy7WUMFieVdCe2Ww2LzCvBSJXhdhN6xb6Q3BSb+4bvoCX7wk5RN8Lji43pRXmlk4YwWFow5WxPqXtzdqQ/2qi5F6Mt7nbWptNMOAHSSZBcnEYS8XRQFpFAZ1mjZtcdh+Pln07YYg4w1FXzWWIr2YYswxkd01Vglss6f7lTflw11CIpT8cc0SdUt8hp9zv7Fe/5o5EFojgT+7ezr3Z01KiVbwVeXMwOIlfwiRRTkzx/araR5IaAy/PPlhzJXbuRQBTCakVwNaoSht3AvqWyFJ
 dpvFMq9t
 k/iwouNpVJE95l+qLhDaTjlYTtjn7qTP+M5DWyFN73yrDTuOKXGz3WbB33yAKYY79rsryY0BnETGjKPfa5zfndmoCiv6xy2DZuGCm8F7xw9gF3KWjy0zUpaoJU34FFpKfkZrGAKjA5UdAkiiEmKSIbwQoxcb6fSzNmIsgrV9H3rp0Uaq6Mx9PRtTKuNybft6FLtqLl7OyzRkdJ0VALaib3/7I+J6cjoTjT/4yE0FiZb6OABvbepMgIdKnepw5F9RYrNHaGVaPd+lQLpKqZUSMkZGawZ2mEasYz1K5JVMGzM2ZpwDpNBakTuYU0FyTnLFjREVF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 06:47:37 -0700 Breno Leitao <leitao@debian.org> wrote:

> CONFIG_DEBUG_KMEMLEAK_VERBOSE sends every report to the console, so a
> transient false positive there is broadcast to whatever collects the
> kernel log rather than sitting in the debugfs file until someone looks.
> That asymmetry justifies being more conservative than the general case.
> 
> Require one more consecutive unreferenced scan before reporting. The
> only cost is that a genuine leak is reported one scan interval later
> (600s by default); the value stays writable at run time through the
> module parameter.
> 
> Kernels without CONFIG_DEBUG_KMEMLEAK_VERBOSE keep reporting on the
> first unreferenced scan.
> 
> I've been running constant upstream kernel with
> CONFIG_DEBUG_KMEMLEAK_VERBOSE set, and I am still seeing some rare false
> positive, that goes away with min_unref_scans=3, so, making it the
> default based on my heuristic.

I'm guessing going from 2 to 3 reduces the false-positive reporting
rate, but they're still possible.

It all sounds rather rubbery.  Why do these false positives occur,
anyway?  Are we papering over a fundamental problem by filtering out
its user-visible effects?


