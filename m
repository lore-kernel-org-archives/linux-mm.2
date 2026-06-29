Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53EA8C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2296B008A; Mon, 29 Jun 2026 04:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38A2F6B0092; Mon, 29 Jun 2026 04:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0C56B0093; Mon, 29 Jun 2026 04:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0566E6B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:11:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F7168F786
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:11:06 +0000 (UTC)
X-FDA: 84932229732.23.5BCBB0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8165740007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:11:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VDUGzzQM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782720664;
	b=zXahufaW1zrIdECvk4IVOGhmMBgFb6gjavYvcD5PKsr8JC6/jv/J8O0wVftfP0Shagvtdd
	XAurq5pbwS16CAnIcbmp/LK8ohHxXkkF3d0HPIg+q9QEz4b3MVlYkn1aBV9oaWPpqlq1ZG
	VWzMblULGHywzfCHRhTLvdQ17uyswQg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782720664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+jBQjPJZmAlCtqnFf40iK5seOSNG8oTGwm/faM8mqOI=;
	b=38TgycOfN9DvA0gdCDJW36zNOTkXJgkz+/tNR8OX9DNoRmKKsy/kZrZGxz1nxlxO2ja1fF
	miwV718dGNoZ3LBR9LVIWjIRTiTV1LEJ2vl1OxjdXzfvsa8wddyDJZ73g+YdUdmrWcbyCD
	Pz04Y3ANV2FJWFdL6eNOtzYPc8V01gY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VDUGzzQM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68AB2416BA;
	Mon, 29 Jun 2026 08:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9541E1F000E9;
	Mon, 29 Jun 2026 08:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782720663;
	bh=+jBQjPJZmAlCtqnFf40iK5seOSNG8oTGwm/faM8mqOI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VDUGzzQMkYDul0HFxLctO2239s1nAGzcIaINsNdtpctKiZfelV838tuDKCRl8y10V
	 m5Poiaz/gtgGq1KXOSDvnyNjwkdtqk0kPJ/p0oSK1UVMTOUTR7B6dJE2z8A3FilLDn
	 wCIwadRMXMkLAOX1N2B0OdwuNBlj6hK+6Y5xc4Qz25svmpUoS3oeyFbF3yt1QRPVc7
	 5zTdVOsbJa+H8veQtVbktsLVa/m2fQFTfCejBQwzAB+k1FOHby6GzTXuEke4b7nhUS
	 6hdKcprYk6dLEDuHmCOU+a/fSvWJuibj1h+AB8Fp/G9BRci2pOszgK0JglAGAtSC5I
	 j7q/gzvTHu/aw==
Message-ID: <608150e1-c33d-4364-8e0e-40194cb073ff@kernel.org>
Date: Mon, 29 Jun 2026 10:11:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] mm/page_owner: add missing newline to
 count_threshold format string
Content-Language: en-US
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-5-ye.liu@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260626024550.25677-5-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8165740007
X-Rspam-User: 
X-Stat-Signature: sz3zmjb8f8u6nh9mjgfbd8wx7tt7p98j
X-HE-Tag: 1782720664-98155
X-HE-Meta: U2FsdGVkX1+kXJXX0V4969EhV1OK/z45Mo2BgFmEoYUUxOWkdiP+fzfEB8b2y1Zg/lRc1McIzgirid8P4P7ZHa+q6w3owkg6iRtnenAnNyDV/6vDnoOoGpvRjre6Ya4A3aPBPVxQqnrN7DP1YJj7/07bvTiS4ikxKB7hv9TDUkSVgSF9sSSXaot06FF1P95Z0NtbLi+vONyciG4YJ/PZLEjYDclYw+/qiU5rg64U9XgS/wMMvBDWG8YdYrYsSKJqGnZ9nePk/ANP/SIKth6h3WT4hhIOkG+hemoo/00H0kDaV/CW5F1qFXwAEq05gDfGbRuu/JwklnqqaSlw+2/lfHLShixNSfRIqsfQbsqM8VhHM2GHTpn8xRbh4xARhN7IPWD2q7wXIeRwugHHJzM+1rZtL83CtKSPvcRp2hIZgLN9K2BdxnD/kYHGUtXpC4zudRAUW2eTZ6E8BlYTTE+8CzCj5BRvPjNQ0GA1GOVk0nrggBe5i1gM+M13jQAz+9igbHWmqIQ6hlco61so6AXpzLboOZIDHQK71pAIHtjQQz4Z/RK7KA2u0A9gievMRIYMf3pFuGvqjQDOsqN/4JpI5EnqApvuz1Ts7FOX8N+fWR0s4ZOTPSEfPFFVFmqwTsRfj4e8UStLnoEyinxNDv8jPpngJcYyRleHzeYM0OgiDHsD35DAunjCtw0Mh8l0NZqBtML3Atl/BwdiHVh/UuhqHqoJPEklNNc+QTb4eVpXcaG7vjwML4ln/BIWyihETeKgF47o5LHAtILVReZpbQEm1S/0Qv4qsQ15kXfMppkbRtICYNIoS7RR1hJ7Fn+zw8v1v+7P/DEMqs1lFxjD/GvdyEroogqesJcoBX8Wnp4/BeDdxfj/ts0FuBSKHYf2pNr78c5hs3d/UDmSPcd1Qa+Jwv6s7UorbxJw6GMoa9WhmZ3uHkGdmcky6SVoz+Shgwd2lUBFCalglaQsbRcyZRt
 vhjryB9K
 YYOj7NFybssWX2oe3iqrBVlPt1OGQmPGw6tRiFUy2AKLZZwHrWoJlyBfqH10XYhrUhGC4VB8h7rRYO3d4Jn+tHxjop8L9wMTCBHUVcHMnovyxDSbWUTJHjuRhd7NIvT9BYGBFb/zRttCtbN4/K8kbsR9nOG93KNdmrVbU10nL57aDz8ibEkutL6+9a82SLCQdYSdNIKpPKwLkd75pq5B+RvE0oVTf+6hZzkra2pd3hY3nmgGtAxa/jGDAhtcUIPx6JYai64J/tsygExK7HHgf+MxqpPJiBKWyUJTOpPEzLTwUCpPBJI6qlpX/aPUkJ4jIIGm19Wqa05crgmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 04:45, Ye Liu wrote:
> The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops
> is missing a trailing \n.  simple_attr_read() uses scnprintf() with the
> format string, which does not append a newline, so reading
> /sys/kernel/debug/page_owner_stacks/count_threshold produces output
> without a terminating newline.  Add the missing \n to match the
> standard debugfs attribute convention.
> 
> Signed-off-by: Ye Liu <ye.liu@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_owner.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 5d8773c90cd9..958151ccb587 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -981,7 +981,7 @@ static int page_owner_threshold_set(void *data, u64 val)
>  }
>  
>  DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
> -			&page_owner_threshold_set, "%llu");
> +			&page_owner_threshold_set, "%llu\n");
>  
>  
>  static int __init pageowner_init(void)


