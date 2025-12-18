Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB89DD6ACF1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E1106B0089; Thu, 18 Dec 2025 06:55:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E976B008A; Thu, 18 Dec 2025 06:55:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166F36B008C; Thu, 18 Dec 2025 06:55:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 048026B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:55:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FB5A140E55
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:54:56 +0000 (UTC)
X-FDA: 84232435392.20.D6BE40E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E7B5420010
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:54:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RYoyBTDo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766058894; a=rsa-sha256;
	cv=none;
	b=gx+Xn9Zl1dxj/U5jTn9ZHaTYYPYYJZseblZRCqx7IqUjpfkwCK9cKP4X5PN3FetMAmymYJ
	lbTArFoDYk1Hg8mNChsZbYjzcfFZjbHC4lkup2SgkGe61nKqXyFvVTZKEzVguQAcDeDaI9
	A0z0CH++iIzSi+vzLEYf2T/NwYPbOjo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RYoyBTDo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766058894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MT5Y+l3zN7MhS6H0hJMNtYjUYdo2ZASv9d4PS6EC4Q=;
	b=P9XwApYJ/zEHIbJq+UMNQ2ma0znBcs3Xqw0jMaNZ8Hbm+InjQFWORJ9jY32Qc6MulRmLFU
	JpfFWvmloik7VkRRMOR18+REmFqwhP2TW4E1haiI/t7fgBoCnAxs4CMuzVl1toCqgzA6H9
	xYX34e4s4DpYGBnVz7j8HcN8uWYX1oE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 54D0C60123;
	Thu, 18 Dec 2025 11:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20ACAC4CEFB;
	Thu, 18 Dec 2025 11:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766058894;
	bh=SonOI2ELpXScZVBdAmdBm/jN2Fbd8My/Tjr+oj+Sop0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RYoyBTDo1W0L5yO1kfmdjgMzAX75CEIbsb+LSyhKgC+U3lvBgIczMEf0svW0raHvH
	 SmJI+3XFsriu9P6cT6DMVgkxn7Xf3Uwz3tMaNQXQ/rlgpnTbXM6/6ZPRFTtafSQmv0
	 71Rdwgj4LCTySoqnkQBSCiG1yHTqZXIWn+Blx07OC5x1D+pn+muI/A2nHTurEo5+0w
	 stpQQnQlJaJLJAV0zjbuDacTSDMHnesanVADFwHfPggnjLEaFilN7WhP9cV+m/MIEM
	 3xgYNsLi3tMU7NIpDg1QKlXl2l+SNLvChhRvr5el8T8RVvx7gryzRthuC4hJQdEfg+
	 MFkHkxGkaE5Ng==
Message-ID: <0544a9e4-bfef-4af8-9f68-a5aade840adf@kernel.org>
Date: Thu, 18 Dec 2025 12:54:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Correct minor spelling mistake in huge_memory.c.
To: klourencodev@gmail.com, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com
References: <20251218112016.9613-1-klourencodev@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251218112016.9613-1-klourencodev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E7B5420010
X-Stat-Signature: ybgbdz8m39xtqfn88cbyju7osntmggyw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766058894-210650
X-HE-Meta: U2FsdGVkX18YQMWP8Gq8yyys0G/FHqtybh0ODECddyaLoN+5zFIQs47VSKzJnus1qdLwTuQMxd3r/0xWm0TspOiQxL8lkTjehe80s2sFGP9mWqTKe7CvjDW3xNzv7etYHmgL460U2KGxHqQexsvSVix35JkstumUB2u3+f2vDp17ni9348qfFFDfwGXNeU8wnG/cK4kL+YGhtrIzXn3ylsabvgd35Yf8tLm4leZI3KJb49nwTg+zXpmrCzk+yOaIc6QW6K4yrPYN2X6wcUN0Cxbp6cBBwsqppFAf7xvDMVboY4dU6MWB+3Uj/BSfxgui+XkUteivaPyLMShaulG3no3ZT1sHxHPB2Y2YTACMaO+g1QMEv0oS5r+5KH6kXRQpJrUKlMLcrSraERAJwd4RHSurCZDYsXLB5ZuzZ6y6Ftj9+IiJ+gJdBiTDM/4zVlj8sUdEKaVodD5iS01k3b6f+LGkdRetb8m1hRkXseh1fDc/dexxpi3gRbCElclihwlLxfoFZlv3gdzzryr4KXQIA3WiK89o3yWwiqdSUyQIKiyVTFlCxGsSkU2aabqdb9Yr++I3YcNsnX2GTQMJ40RE2HPFsvOdOJZDHisM4kHJQsP9CmrXEy+IFxPzCOVyLJFfnQzKH4CJc76bkkE9W4eu90I7GF0kzb6qHfbz+QwkU2Y//+k89KNizxtQWxF1SgTeuS4aa93KxST3CROTE5AEXraAinXAEj4j4nu0Ss/2SeXhGtmzhlngYI7aEQ0VpM9kDhlQNzlh//uLSV6Oc2mPjzPHLVZnq1Vd/m/lwv2fTCxxT3n/95X7hkPD9DBGPUJ/bJgW0hbv6XjD88ZJvrpSKK1D6WXQtCBYaQcwJCXnh1kzP84CED5oeyvt4NeQL7QEYonA7g3tG2xEnrD51lYq0pur6ohAhGq+kZQCIEY7HhXA60+g4qm5/TTQvhQ48JT6IF2wJIDJ5yYvOIpOtlO
 RuE4+yGW
 IOe+1s2z4/kzJfw6591D/cZQQRsK4iz8FWEordpKD/anETpbRvgFbt7WygHsuNKFZDdxixpvo+x6IWy38zVALFe53D9lz2ovR292OkpqacpkSzfB5KsLfuxINaskGUk8sV+Sb59Sw9Vzv9K4fO++ws2fO8C5v6G41tlbhgUJ6nVOWWTnkn5F/9E7YDk7d+q10M0T6CB2O0LtmBN9w0GIS1d0j7/nEEVdrxBFbPHYtnvLGdTRcrrZ0sTITmzgXqPBXOnZ3Mu6yOteJ030Tzf/ZorKrgWEQ1iS1lzWV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 12:20, klourencodev@gmail.com wrote:
> From: Kevin Lourenco <klourencodev@gmail.com>
> 
> No functional changes.

Subject: "mm/huge_memory: correct minor spelling mistake"

Then a simple "Let's correct progated -> propagated in a comment."

You can drop the "no functional change" part as you only modify a comment.

> 
> Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
> ---
>   mm/huge_memory.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 40cf59301c21..5efd2cf4f073 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3220,7 +3220,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>   				swp_entry = make_readable_device_private_entry(
>   							page_to_pfn(page + i));
>   			/*
> -			 * Young and dirty bits are not progated via swp_entry
> +			 * Young and dirty bits are not propagated via swp_entry
>   			 */
>   			entry = swp_entry_to_pte(swp_entry);
>   			if (soft_dirty)

Are there any other spelling issues in that file so we can avoid more of 
these patches that don't add a lot of value and only consume reviewer time?

-- 
Cheers

David

