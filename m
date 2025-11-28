Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6650D116F3
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 11:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A03F6B0029; Fri, 28 Nov 2025 06:06:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350B56B002A; Fri, 28 Nov 2025 06:06:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266D76B002C; Fri, 28 Nov 2025 06:06:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 152466B0029
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 06:06:21 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A013DC0518
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:06:20 +0000 (UTC)
X-FDA: 84159736920.13.D84CE2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id DBC41A0012
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:06:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aQ4tY4xS;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764327978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/uuVSoz/3gWxogasvQr1mz5qyTmJ7xpuc4isHbYti5M=;
	b=bhLXeqEVraHLUV8JEZ+oujj6VBYgn0+EWoRKI/j9QpPegrk+flHmeMHm6yWYas5TZrDKvs
	npgpdt5jzLsncQDkJWrXo4WH4CPdXaXwghze6BTeXM4p04MnA9Q3kSSy7bIonSkZaLQWqk
	9KwzN8gmdKbL9meLlULInj0nbzb32+Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aQ4tY4xS;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764327978; a=rsa-sha256;
	cv=none;
	b=K1Tm06dhdWo8/B1iSYk/HlfaSFl0HwHFMd2RkwMoEjsBoFMNV2uotOZGocPqXwFX9cAlti
	c31TwjpFemg7DPZFcxNMmByd0aSn/byOqjNP3zQIVqdQZdrAWTJJqIws/EHDm954wkhoFo
	sloTUYdNAz7j0jF67/NYaliqapw0EVE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 29FAC601FD;
	Fri, 28 Nov 2025 11:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB04C4CEF1;
	Fri, 28 Nov 2025 11:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764327977;
	bh=bnGH5YqaHzHdBMv1tt+JBBOupxeg96Hc9ZEdYLVi+mg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aQ4tY4xSxQDg408u1gftenqcBUao8Du9Q6/Eb7+LbO1+3Tu6Uak0jrSPGEFkDmhaf
	 WO0c8tiCkGSuoMIaHTCIS89NwFrxhJmeqtcCUQdJGFQF7DYCP4tV87JQ2oGChfxRbJ
	 x4JDFrcxDk4nKq714W2DIvi2RK2c0mBnGwTAVklf9H4OIWaDh+a7Lg0nDRNs1qlzWE
	 Qk+U9lKVZ5aiBWmXhp2A8HfkaEbiOW8lVb4boVHDPnAEbcovuUS7LTYHY/1iTd8Vud
	 FiB1n0yLEu0FZouLSuiJD0EmdTlqyc55O4jpSoBWw+D72bt1SZmVg1ijPyxNWD6dW8
	 LLm09t4bVV7+Q==
Message-ID: <9cb0a602-69ca-400f-890c-e9dd5b44f53b@kernel.org>
Date: Fri, 28 Nov 2025 12:06:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlb: Add guard support
To: Fushuai Wang <fushuai.wang@linux.dev>, muchun.song@linux.dev,
 osalvador@suse.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, wangfushuai@baidu.com
References: <20251128110241.78580-1-fushuai.wang@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251128110241.78580-1-fushuai.wang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DBC41A0012
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: qp149dfp4aaf9rpg19umo6u9gmwzpmex
X-HE-Tag: 1764327978-665339
X-HE-Meta: U2FsdGVkX19DbnvKHhLPNOC9P+6MHGmAZ/oO1GVRcpskhEDtUjXbegjU9GOgVIoVzY+mIGlddjYFCvovLyJP7jtPve2+nfcpqnyzJ2B+Vzw05SlohZX15gnsOcFBW3gOMJlzN2SMLSQzc7ui1+iG5T1PYnO9V0cUpFtqXjTVluu6J+55Kv8gMVy7BZmTJjXF++jN31iPFwDWEuDShP8Gucrd6Q0DeF6SAp+/dghEbGI9ksq427VXNqh240ovuRkZ4XFh+PVhhWvmaeR+72hvBA6Do1neaMSDVwjr1cZT59M6yeWs/C/iD23vxBzP0UnlMisua3z2rifboNqGohYq6zz9g7KNMA66ZVbQ80MtK5dKHVg2dDODCXuFDqbTLOMqgnqv5ncSnPHHRRRz0ZEvI2/B4U/5pfuI74bfU3OaAevHbxEKNS+3wNG9bQH9UI8i/kJUghhi9JHLQkv9zYzfFnW/JUNsXiKniCv3qWR7k3zzEa9gG8qEnqIJIL1A6nJ0hu/rvoJhAkbvz26vmP6BrYe27ACJsOyNpLV+tYybuQ9UlsBBUgf5Nh3L7CXqd1gLn6K2ux88MQSRdqs2BLTUv7FewWv3ZECq3b4aqzlUWGwb3UD+FfSjQvDeIRfZ5LPEexvf02nPtPOcLYj+oFDxj1ngAV15Gyj/PO+AERZSmPlCfP5QA8pI2N7/Q6RC0WKxXcjmUKppZfJDpZ/LLnevrt26NWlMn3AZduY9Xd1njhBhwNJfcTz1098H6sjjrYKsOIGy1/vdiVqsig96D+zFIdMYhMGVf+zcIcmiBOQAdEZP5X6H+qovBPBagVi4tZgNRGROBUVtsloHn5urcdW4V1OjjcOg9sSQNovoTpXS6Wqsr/PrWKhsuvcgP6acyCkA+gtpVzkWK04hg2skbzIxBxDEEMNsD6sqp3EBGcwrPuI3NehuEJRMXndEBwCoXN55JflurBLaIPmMuw+Pez8
 eFiZNYJw
 nCKIKTf1dz7rizwmT0vcDYE0kRHdty8h6EeDT/ynVPMvccO96DAiqlKNNOQ5pZD/osKUvLvadx/F/8G6Sv11rNx6uh2Dqo3ce0DngdJUaecu8g7t+CRoCz8lrzMXYePEec+nAd3JpfrXgG0bau7ew1y/TVvjk1ctCSdkBRCZIyNwCUEdZcHEnxYLHr9f3K9ylwiCiqN6lps6eGVsI+utTzfH6UpCm2YValwltkH9fhm1Nm/BVvVlQlCfNLB/rrjYF7rO4wMVZt4VpgwOE5/usG49y+0AMsgaQuANuaz2G/ZuMnfqipfiPL9+JjFoyfsJkWiiEZQw+MMLu+KTHB7CVQAhOIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/28/25 12:02, Fushuai Wang wrote:
> Introduce guard support to simplify the usage of the
> hugetlb_vma_{lock,unlock}_{read,write}.
> 
> Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
> ---
>   include/linux/hugetlb.h | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 8e63e46b8e1f..f97cb2f123a3 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -15,6 +15,7 @@
>   #include <linux/gfp.h>
>   #include <linux/userfaultfd_k.h>
>   #include <linux/nodemask.h>
> +#include <linux/cleanup.h>
>   
>   struct ctl_table;
>   struct user_struct;
> @@ -468,6 +469,13 @@ static inline void hugetlb_split(struct vm_area_struct *vma, unsigned long addr)
>   
>   #endif /* !CONFIG_HUGETLB_PAGE */
>   
> +DEFINE_GUARD(hugetlb_vma_read, struct vm_area_struct *,
> +	     hugetlb_vma_lock_read(_T), hugetlb_vma_unlock_read(_T))
> +
> +DEFINE_GUARD(hugetlb_vma_write, struct vm_area_struct *,
> +	     hugetlb_vma_lock_write(_T), hugetlb_vma_unlock_write(_T))
> +DEFINE_GUARD_COND(hugetlb_vma_write, _try, hugetlb_vma_trylock_write(_T))

Do I understand correctly that the code you are introducing does not 
have any users?

-- 
Cheers

David

