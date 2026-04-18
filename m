Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C19F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 09:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46AA86B01F6; Sat, 18 Apr 2026 05:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C236B01F7; Sat, 18 Apr 2026 05:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E53A6B01F8; Sat, 18 Apr 2026 05:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18EDF6B01F6
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 05:48:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B441EB94FC
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:48:01 +0000 (UTC)
X-FDA: 84671200362.28.8FEE5B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2F6A21C0012
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:48:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HTJ40XXE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776505680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exo2RLqRrvlolQ6JiiMtCPZa0lCRoF4BR2L5jFw9z/k=;
	b=BxUn+JzPqgTFWL0EesklEBXoFUB1CWtDfRj4LqpsDW5UMKtNLeqqQLOFf+fSmgV7vreH4u
	9Eh+cY5KsXiCWpky8zICkEV1gzCE92Wz+ZW3UvU/zjez2Qb31r3wqLgqf+i5MqJ0bR6OzO
	6zG1k5pESPpbrNAHrswxlV7CSbAXL5U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HTJ40XXE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776505680; a=rsa-sha256;
	cv=none;
	b=61/hUwFqBJ7wBffLll2gnmGhWPMSpir6YoBx9ABkTfj+zmdUABcVF2fwxaOMr9Rlr7LU1q
	Y0hftzHDWUchn1kShFcmDBlXRc9aujG2IISscspTjow72mGe7c1PPnjRpuEA4/cs4mkdLB
	KM4DRjWEfzdPmlogdHoM4EHQxEdvHRk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A4B7960138;
	Sat, 18 Apr 2026 09:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10795C19424;
	Sat, 18 Apr 2026 09:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776505679;
	bh=Gr2wCUkhBuFLYSduAVwfU0AMe/thEKZSc0aVIupHPmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HTJ40XXEKe5czTUJ5UtDf4bTMtPyY/J1YE+ahwZhRJtTCBRb0BNABxyM6FGdQl+UI
	 D2mCcxobFSXRu4bxYzE9It28kzW3nU3GeAGuf0gTlKjiWoBBgp+Y4W32ll7a4GsN2C
	 wMlPs7DccMPVIsk3aVuLZonUaPkSUCpIxj/Jtqyi4c+8TbT6euAnWp+tjDzvc2Zqo/
	 7wR84fUlm+WIO2YgoKJ1huAAP/F+rp2caHIgDndF3zD+2CIr3tX/y1bcqgbniBlIgD
	 aeYdSgUkrAd/34p7kcJc/cktOW089IeFygHURD5LIDovtkT9PWPOth3jKBNL0xMOgz
	 NyheGZ7X2vt3Q==
Date: Sat, 18 Apr 2026 10:47:53 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm: huge_memory: refactor defrag_show() to use
 defrag_flags[]
Message-ID: <aeNSquoJ9gjTJ90p@lucifer>
References: <20260408-thp_defrag-v2-0-bc544c1bde4e@debian.org>
 <20260408-thp_defrag-v2-2-bc544c1bde4e@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408-thp_defrag-v2-2-bc544c1bde4e@debian.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2F6A21C0012
X-Stat-Signature: 8quwsfa9cnu976nek9mq8w6pcagci7wz
X-Rspam-User: 
X-HE-Tag: 1776505680-959526
X-HE-Meta: U2FsdGVkX1+knWprKjTtBxDMAr38i2iDU/kH9UHPMOBWWhq1wMoz1ORGOF8tcxyQLpzIpsZbvaCv+wQ2tcoK+PSwJXwQ2xcTwDmJHFoWT7qLTQt4dgqj+fOGWE4G0YEoqNRBn+2CIMVcuyDdZ3QiGqzqPHuUS52UB4X5e204NWXweNJVDwIILZKT6LWmThU7I5hUfa1wFNPv8Nq92mIxBLcEZdIKrmOAMlT9nX/qcnEsa9TjjWI4gHNdEgJCo2dFYOgOrIaQO+Sc6kVGvmXZmRDjzlXqOrmBD2t5tojWRSZHV/VQLTVw7jfEyiJZLApshSBp33bbNiOUV3CRi+lDz8uXk07//9cgedhSzhO+f+DNXgh+3oqg+gYN8jh2zA4MEB428QSIEJMJK9fAkk/NGxxZoTggTGH8MSFgNyUFMXGsxtk3IgiNcVpXRhehmJUMIM7fL8pgOAaQkvqMm/Z1UXpnNRfVdus1DHXMkK0OLXO/RD4c3WMTClrtN9jLe/z8sUxd6wyWBfTvaFWtEX4ZQtagp1CChLgf58409oLN+eXjhtXHPkCzciftQ0cBUcmf1XA5zgkH/Y/m8mzoZFyvzKFdX3cc3yaElD89qJmdZMAuVb/tsrdYzZ+rQU/apVAzRV9oquf/pSnmIGVbqbMBda/bsCbhVZD4B6Hd/z8vXhtIliMgl6oKoD+4v/jszCjAok38D2Zuf0hpiTxwurNkmeGkzz7uqqlw6fHNtZmFvWD8ohxvPIGMzF7iJrN0LXrokxDQVVzsuZyLv3e2p75BdVvxZOb16Zu6u3TLxp+Lz0w77txH8PtQBfcoAwC9JvOhPtq2DBv7SJel13GMpMqDMdcI1C8j8mOGzUlMcY2gzxymH0YXOHENVP/j9mCI1C2FgG4s+JEuVJomVSHelFAMGga2ZyZkOvj0VE0IhDzN3RMdG3kZPdTNzUETJow2vY6ckYdYtdhpskGcpGCgFTG
 mgWdzFHQ
 PEkzaGleh40m+e+zBfXxghophDktRbLM7a6SKo+P9tdBB89YHYXuS+unluu9LwSclCe3TxnV9uP0knCvBGG7+DPjsLY2/P9WhFl37mxFuEK9ykggpqckGG8/RQLWNpzi9biUVKmKmbLR52k5hTltcIXp4LyGc3eTqIhY7k2jJbO2OxQq32sMZHjPZXZjeNTzyjPdfnZ34jrPT+9Dli1lhURavq9/Kp7k//mhv7Swor8T3w04c/DIp22uE4AyJdjXniyKUEaPKK6spLsVbUMCiMl3JLrYl5jYN9HrX8BcqYvyWi5EllcKYqPg0oxgfT+FiZSFemzBNXlKce6QrXq//Aaj37g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 08:47:01AM -0700, Breno Leitao wrote:
> Replace the hardcoded if/else chain of test_bit() calls and string
> literals in defrag_show() with a loop over defrag_flags[] and
> defrag_mode_strings[] arrays introduced in the previous commit.
>
> This makes defrag_show() consistent with defrag_store() and eliminates
> the duplicated mode name strings.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

I almost made a comment, but then realised it was fine :P so LGTM and:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/huge_memory.c | 38 ++++++++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 16 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 76f2d32428c7f..6993c6d8709dc 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -455,24 +455,30 @@ static const enum transparent_hugepage_flag defrag_flags[] = {
>  static ssize_t defrag_show(struct kobject *kobj,
>  			   struct kobj_attribute *attr, char *buf)
>  {
> -	const char *output;
> +	int active = DEFRAG_NEVER;
> +	int len = 0;
> +	int i;
>
> -	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
> -		     &transparent_hugepage_flags))
> -		output = "[always] defer defer+madvise madvise never";
> -	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
> -			  &transparent_hugepage_flags))
> -		output = "always [defer] defer+madvise madvise never";
> -	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG,
> -			  &transparent_hugepage_flags))
> -		output = "always defer [defer+madvise] madvise never";
> -	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
> -			  &transparent_hugepage_flags))
> -		output = "always defer defer+madvise [madvise] never";
> -	else
> -		output = "always defer defer+madvise madvise [never]";
> +	for (i = 0; i < ARRAY_SIZE(defrag_flags); i++) {
> +		if (test_bit(defrag_flags[i], &transparent_hugepage_flags)) {
> +			active = i;
> +			break;
> +		}
> +	}
>
> -	return sysfs_emit(buf, "%s\n", output);
> +	for (i = 0; i < ARRAY_SIZE(defrag_mode_strings); i++) {
> +		if (i == active)
> +			len += sysfs_emit_at(buf, len, "[%s] ",
> +					     defrag_mode_strings[i]);
> +		else
> +			len += sysfs_emit_at(buf, len, "%s ",

I mean, we'll end up with a single trailing space, but I think we can
probably... oh wait hang on...

> +					     defrag_mode_strings[i]);
> +	}
> +
> +	/* Replace trailing space with newline */
> +	buf[len - 1] = '\n';

...OK :)

> +
> +	return len;
>  }
>
>  static ssize_t defrag_store(struct kobject *kobj,
>
> --
> 2.52.0
>

Cheers, Lorenzo

