Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB051CD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F39D6B0096; Fri, 22 May 2026 06:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CAC26B0098; Fri, 22 May 2026 06:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308316B0099; Fri, 22 May 2026 06:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F12D6B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:35:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C27B61C0799
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:35:04 +0000 (UTC)
X-FDA: 84794698128.15.66F0D44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 23D5E100005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:35:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FVkO1+71;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779446103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5oSznGJd9kahjuR5wlJHn+DNoeoTiNjPUdlEP8QnSbI=;
	b=m1/Hi8+gI2gFLbytm3DHmOGkyhHYgIAb9QJ1ZUdib/+OpadL3o5JP4jCOOlObX1qkwT+oS
	hKG5sqZN6ANpXQhq+DOmU77bFrf/SedCGvVYoOor33IL2HI8trWSpzVT+ECZsmNest8I9w
	iLC7osMmJrJESGPun1ERmxre4qkZG0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779446103; a=rsa-sha256;
	cv=none;
	b=4GPduCZzNi5B0jOXffkk0eQOaEMG/Vcu027JDptt0Ql8mmQN6Pas5NfbPp/BDSzXhecfyu
	lSc0vgzHxQmlldkHj7QgrXcFbHUyonFxKNFKwYVE98D2ittYi0COSDBokYhSzBYMOBrkQj
	cyzye/AMgt8WsfZch26fWf6zArRQxMo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FVkO1+71;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4ED18441B8;
	Fri, 22 May 2026 10:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1481F000E9;
	Fri, 22 May 2026 10:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779446102;
	bh=5oSznGJd9kahjuR5wlJHn+DNoeoTiNjPUdlEP8QnSbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FVkO1+71t89AwW42m+uw3Pxh9/wk2R1blObwE8ChYsBS5oG2UIG3SOUBR7k9Lss3z
	 zIvjNT6mt9zPjyFgvUhRaZtmyJWskdQUiS3bO5h9H8FL5JI3cYSSyQotWnwAIu2dCp
	 YZJkbBRWlfu2D+zJKXv7Ou3S/Y1Ixdle1cwWn72qd66o1LeJfsweCZh9lNc2IYY3R3
	 TJITEkJb7G7c7cXVWw9zfgALXwy76xJmS261k7aixm4DVSdEMtWeYlm878LkYiBSPM
	 pXiAkR9JmIw25zrmVnL7FbO2TWLNGY0Wd/TcwPKlNR+5HGo4P5XksA4Gib/15b9IEI
	 K44bRJYUwClZw==
Date: Fri, 22 May 2026 11:34:54 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: ranxiaokai627@163.com
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, leitao@debian.org, ziy@nvidia.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, david@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v3 2/2] mm: shmem: refactor thpsize_shmem_enabled_show()
 with helper arrays
Message-ID: <ahAwLxwW3ki9cOjw@lucifer>
References: <20260518123238.56344-1-ranxiaokai627@163.com>
 <20260518123238.56344-3-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518123238.56344-3-ranxiaokai627@163.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 23D5E100005
X-Stat-Signature: y4syeanpwo5c8qzgn9jwg5q5959q3smj
X-Rspamd-Server: rspam06
X-HE-Tag: 1779446102-889343
X-HE-Meta: U2FsdGVkX195DKLC2UaQqXMXRhsu3sg0M+0DjwkTfzA4hj2W5uMge1dG0qSvGV9M1u2BP25NmHqrRdQg75Ame37KyH5mEN391+cei5NKOfzG5Xaoo3K+u/EDp6xve8XVObCeU4h5dAoaoDsBe1K9POhYX5Kh5mTlOY0KTdF0PuKbPecfOuQGjiN+V6sh13V6Jw/WHjNn2Iq+Oym+PsSIIrpXHlYhgOIb6aBssmfywDA0bWwcmpDfHC1THXF6ISSETFI43Y8REIix+7hmlQMr8YOsVSS5yBkC//diAPUzoABXOPar9W1O5BrQKcF0TqqOpjBHr4rlCN0QrEcZucPok98e1458wH22syQBd9KpmxCS//5LVCfi8k+BY5gdU3IK+XcmWcXquhQ4MtnblXR9BMjNWbdcn/NiZc1ciJNKOM/XL2uvzPx2d/L7DiSm/nPNMkrflfWRSji6YiIA66H1dUy3GWGL5ehSqCe2UA5Be9b37GGWgrHmNs1MKNO5YfbTpjbc0fAoU7Aukw0RlBIEpy+/dfn0bsJ1q/JzZn7JNKjJNHY87me6/maLTVDOZvmcoZ6z788IMWSZfyuovjyr07OFK6kjh5t+E728MDfN6hJjS12JI5QYTh+LI0pLhmMq7WsTkQ1ibuukv7vY67WrwZ5SqS5AsbIdFYH1K80OXc9YLNvedK4gojXhXpmCuVwhjZOAf74xtHxlMgdnRK8p9bO0u7uEtcMyt64h2KSesmm9tH6hm/ose+FjBJ5Fab5Q2iMXEystiAuxPubWXp0Hn7AYDr1F0fF5xNIsltSQTLr8gZqgNB39BoSCG/a0kaTR5cN8C354bmAlV0h4XOeUHrek5Exp/8fiDoWwQk99LZNFjZze+13RoTHvJJ0aR72bE2WnfJfrHU8ci7+srv+vElDKIr7hUpweek6nc6s8MPOTs/DRXUNdsKSwu66zbTLjGiqwZcc42KV5K9yF2Nt
 UtSXzHte
 ZMr6ahkXdFCgQ3bauATrEOB4jc8l0C7NJKD6ybvdaIWqptW8wPsjmspYNrd0wy+nwd6FKaV/Y3mgqLtzRzYQ/hsn/KTzj7x6iyevpmSa4WnAC1EYR8Bh55r9nP08WlpC7ejRv/OrUc/PDxfa5kLwJxGiZeobPKYaeRe0AcusCezUIZ4fSCVddhC9ZgR3VaccByqup8ddE5eKYxoYck6o+LSJIasuYX1nvUPFqP/BvV+EtCw9+NDLtHwLotEMrA+s6iUGUJcMIXRYoPi0nGltluZKyOYsSdh8jLgXq2omdwrYZzhgIyTcpKz4Ww1pike5KqIW6goqyVRl9mrSWip6iAX0q3qLRZUc3MC1Q7Fcp+qxq3lEFyWCBkswtF2bUJKLxTrxnMgp+pEluX6593v8sY4nmaFzpTfm79DyLeE5Tje4JuEeeErpwlOn+/IiSnSJ9p6JlwKeVZA/Rp8AX7ePPcoJOkD8Spg5kakA8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 12:32:38PM +0000, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> Replace the hardcoded if/else chain of test_bit() calls and string
> literals in thpsize_shmem_enabled_show() with a loop over
> huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.
>
> This makes thpsize_shmem_enabled_show() consistent with
> thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.
>
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

From: ranxiaokai627@163.com

This does not match the From: field of the email.

This is violating kernel process. See
https://docs.kernel.org/process/submitting-patches.html

Please either update this to your 163 email account or resend from your
zte.com.cn address, otherwise we can't take this.

Cheers, Lorenzo

> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/shmem.c | 36 +++++++++++++++++++++++-------------
>  1 file changed, 23 insertions(+), 13 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 46d2cfc30823..197c9cc314c5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5553,20 +5553,30 @@ static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
>  					  struct kobj_attribute *attr, char *buf)
>  {
>  	int order = to_thpsize(kobj)->order;
> -	const char *output;
> -
> -	if (test_bit(order, &huge_shmem_orders_always))
> -		output = "[always] inherit within_size advise never";
> -	else if (test_bit(order, &huge_shmem_orders_inherit))
> -		output = "always [inherit] within_size advise never";
> -	else if (test_bit(order, &huge_shmem_orders_within_size))
> -		output = "always inherit [within_size] advise never";
> -	else if (test_bit(order, &huge_shmem_orders_madvise))
> -		output = "always inherit within_size [advise] never";
> -	else
> -		output = "always inherit within_size advise [never]";
> +	int active = HUGE_SHMEM_ENABLED_NEVER;
> +	int len = 0;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(huge_shmem_orders_by_mode); i++) {
> +		if (test_bit(order, huge_shmem_orders_by_mode[i])) {
> +			active = i;
> +			break;
> +		}
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(huge_shmem_enabled_mode_strings); i++) {
> +		if (i == active)
> +			len += sysfs_emit_at(buf, len, "[%s] ",
> +					     huge_shmem_enabled_mode_strings[i]);
> +		else
> +			len += sysfs_emit_at(buf, len, "%s ",
> +					     huge_shmem_enabled_mode_strings[i]);
> +	}
> +
> +	/* Replace trailing space with newline */
> +	buf[len - 1] = '\n';
>
> -	return sysfs_emit(buf, "%s\n", output);
> +	return len;
>  }
>
>  static bool set_shmem_enabled_mode(int order, enum huge_shmem_enabled_mode mode)
> --
> 2.25.1
>
>

