Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A953DC5DF9D
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 17:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD346B0099; Mon, 24 Aug 2026 13:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57E096B009B; Mon, 24 Aug 2026 13:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4933A6B009D; Mon, 24 Aug 2026 13:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2568A6B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:02:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B0CEB1A01EC
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:02:28 +0000 (UTC)
X-FDA: 85136781576.12.11F52E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0D05418000F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:02:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IAo04CVt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787590947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Po/EBS3/pNf6ny6UA0CtZDiiSC2hgFFm/KHvckMz5gA=;
	b=tl4Seurcq92WACDmxN0AQO0/dlgnJ8WUCQS02fMY3A2Bh3ABEZZ5ZUi5CEbYGaYtJcr/U6
	3lSfbCWbS3N83bw0rX28dNT0dK7X1EfC1uQCR+RwmTvDGOfthHds7Tqoi2z4aQu9mElt2D
	IoGRpKTIzlzYu81XU1/bs5fZ/ozoEKU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IAo04CVt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787590947;
	b=MJ33a/41wkqFTtvz+uL0REPFbYUrp83QHlGSjCzkqHTKQqCy0R/3JJVhSiMDuJZ8ky014g
	kYbsYhWG7jKG0R1/nHD5eOYBK9EpQjDQUhpfT5xofIdBGZH6l/3gNTh5nAlcnZ5iHB4qSA
	8dLIAGTZem+iHIJff5Zd5Ar4KRMtf9Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FF5F601DE;
	Mon, 24 Aug 2026 17:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06E81F00A3A;
	Mon, 24 Aug 2026 17:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787590946;
	bh=Po/EBS3/pNf6ny6UA0CtZDiiSC2hgFFm/KHvckMz5gA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=IAo04CVth6uyxcjPKlt91Qrgesgnkvlji/G0fZ3OCqWiB9lVZITWQSjCMc+mtJnRV
	 pc7/otIbLaaTKlB3uoPXtc3rKm27sdsspaQEr5ExO94i4aAKIKexBR9GIsJ1JoGHI8
	 1UmVnA5mY9Ebw6FUu3dBpMdBhOaFIRmNV73dMF/+9kwXN2e9MRiHTd6Esp6I9hjon6
	 HNgOTfcQpEVsfTaf0nD6rXfdnP4BfWWd0u2I2V39ePN9j98/wnKhet4+lebEaIYbqs
	 T1eN0e3IA93evY/loedm3lnqyszPp51jEJG+63KpYUrZuKtWx7Gim29TuT/2FQaz8u
	 16wrS2TMS7XkA==
Content-Type: multipart/mixed; boundary="===============1021056670152118957=="
MIME-Version: 1.0
Message-Id: <a154e55437095a325d5bd815f88d5ee61b07adcac8ed64e7f153dde1472340fb@mail.kernel.org>
In-Reply-To: <20260824160523.3907021-3-usama.anjum@arm.com>
References: <20260824160523.3907021-3-usama.anjum@arm.com>
Subject: Re: [PATCH 2/7] uaccess: Add scope guard for bare kernel nofault regions
From: bot+bpf-ci@kernel.org
To: usama.anjum@arm.com,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,akpm@linux-foundation.org,david@kernel.org,ljs@kernel.org,liam@infradead.org,vbabka@kernel.org,rppt@kernel.org,surenb@google.com,mhocko@suse.com,linux-arm-kernel@lists.infradead.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org
Cc: usama.anjum@arm.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 24 Aug 2026 17:02:25 +0000 (UTC)
X-Stat-Signature: idk9u5nthidaoia6sckwh8sfwd5oo81p
X-Rspamd-Queue-Id: 0D05418000F
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787590946-842173
X-HE-Meta: U2FsdGVkX19DhIzjptdlrxIZFletxt3lOzatGkEtqwhQHJT10Y9ShNcoJ4KytbfWE6K27B9wv7tz4hQyf0/3adUZLsVKqz4Lnr455KgBHTO8ilTbGKu5nyBfp5TP8DauwWx8TF2dZLe1JDxhGTjQ1f/a3vQh2qs8wFrivTFUntpywUSL9/4QVgi+VSuh+R92dGhPa2w/W2kyqxQI5GahzzooJDuE94U1OhUkinwkyY1xPVdlpeA7axEa2byEwcgqO2Oe4d/INySqP2MQFmMbyHHAWjOfQEA096AV8v9jc2nNMCZiKO2jsMazJbduY5sqjLduD/kOggXfrX0L92KIUfH2N7sjUTij/AOAkcJg/zdEBk5+EicYbpHc5Nf3FuEOAqwX6np7mwNaVzWRKB7ZzXnYFpXuHU0c7usoNCW201MtLhJT26lWiswchTz0JJA/nCNZVYeCE79e8Xc3OUHPx5/M8BRm5I9u2hkmb+RI7uAvqtsrY0isicgpxR4DUsu1S2uKm46gUjEbJAzhYPKbYXur6gQWlzRK6m5+YAEanVn9IlX3MttoGS4LwggYCb8CyI8zxP9OIod/Je9u3WTRCAiBPuWR2QbQqsDcgFHo1EmTuGpJVccKrK5DgOAZ5YrmoU2ei56SUrxAT51lyO+bf4ruBmZMA7wTmmylWZHFTI0KxCXEVEF6qk1CsQxcJc9Z1t7Jv+ZJur5pHyqAzJwF39x1gidPfOBZqDW8yeS7PglBYwHvYmuVZmWb7Bax91fNa0U+JyOevQ+ds1lO8/d8vCLDEna6Bfp0/5kizu+mij7BwFEQCatuZmawTqXEqgTXeqKElnbepEevsSrR75q4M/eEyYJEivaKw8W04bkDn41biN558aJ22CWTS2rZusutf+zn9DGI/vSSJzKvXE1WFd2aFwb/ILJb/9VMDtJ9tvmfWzivi2gAkCT8Cb7dsS3C14L2ZQ+3mFz5iEIpfCl
 sOh9ZHs8
 kORCwIYnssqofCj2ukZ8c+bfNEbVrRP+k1lA7zrsK+TPjYjOkQhXokjhO3CBAkjyNYFYb36aIw3dIMrkYa5a9bzUKoQPcfa4ruPgGlnqcqaQRb+ha60bD6xibXWXO4D99r8Gw5YXNyXUf/bz8wzL+eeHDJHhs/aWJlB01XhGgLpMNohhedWO4vOyNpOg/LxYcsvSCE50GPbN1PnzOVbxpIHyxB8uSw65FYcM2dffc0sVmzr2XgikhpO0861sA4vCpu2WyspII1KRkVKuu5ahWJRwb1WdIJk5hhmhQd89g4rvjuykI1dClOP0OXbaYdaNybTIYp63IGHJISNcNZru1v7ZNMxxc9+jUxWYtp3Qa72un51cF5e8ZiLdWIMiDMwqQEC3h3hzX+60tuB84Voc8Xak0PzFUDXNlxhBpG9A3MwKpLRRQA8aSt6ltSntc/rKCMDFyMrsXXVrV4b0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1021056670152118957==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> index 7ae185467347..b25e778ddc38 100644
> --- a/include/linux/uaccess.h
> +++ b/include/linux/uaccess.h
> @@ -653,6 +653,10 @@ do {							\
>  #define __end_kernel_nofault_bare()	do {} while (0)
>  #endif
>
> +DEFINE_LOCK_GUARD_0(__kernel_nofault_bare,
> +		    __begin_kernel_nofault_bare(),
> +		    __end_kernel_nofault_bare())
> +

This isn't a bug, but would an unprefixed guard name such as
kernel_nofault_bare read more consistently at the call sites, alongside
guard(pagefault) a few hundred lines up in the same header?

Every other guard class in the tree uses an unprefixed name, including
the directly comparable one at line 303 in this same file:
DEFINE_LOCK_GUARD_0(pagefault, pagefault_disable(), pagefault_enable()).
The '__' prefix is meaningful on __begin/__end_kernel_nofault_bare()
because those are arch-implementation hooks, but the guard name is the
caller-facing spelling.

>  /**
>   * get_kernel_nofault(): safely attempt to read from a location
>   * @val: read into this variable


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32751368606
--===============1021056670152118957==--

