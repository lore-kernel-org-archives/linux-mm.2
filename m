Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83661CC6B30
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 08:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAB836B0088; Thu,  2 Apr 2026 04:24:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5BF56B0089; Thu,  2 Apr 2026 04:24:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4A7E6B008A; Thu,  2 Apr 2026 04:24:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9CFE16B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:24:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 552D98BFC4
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:24:16 +0000 (UTC)
X-FDA: 84612928512.16.1A76EB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9414B20003
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:24:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jmhBxman;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775118254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYja+zDiIpIeEji2i/cgLJofV+EYUANYKR0gRUHfWss=;
	b=EqELq+iZnc8hvJsP+gIqguLhF/KePrsNCFfVbQBVn/NLE74f1yuMYvnA6F0M5FXu67Tt7Y
	3ufJ5pgd/4Jqhv4ZmHXeCE5Q4x/5Q64SYKf6ZIlJdesnHvqtJz9MNUyUxBG28OAgBXPIw3
	HDKv5ZhHDpmajFTquMBqbdl7UvwMUwU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775118254; a=rsa-sha256;
	cv=none;
	b=r6ygBgW+NRP7UrG8oaEW4qwOz57wZKcrZQpz9T5WixW3jW3Oesrjp33o9A8uJP79kBhfum
	YtGXpDetjJr8nW6csfWV1gluLfSzFp8nmu9UydFCwU4omiurFScowhtG7fR6l0KV37XUhX
	UXB7azHs8lcevmuAq6PO4ZxxoqmnXQo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jmhBxman;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB2396186E;
	Thu,  2 Apr 2026 08:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7F0C116C6;
	Thu,  2 Apr 2026 08:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775118253;
	bh=jA06gc5Pe4IVkLtx5H9gdixrMkeAfECyoYC1fHc//zc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jmhBxmanWyjZ1Wdt4K2SJ1STrNnEm6Izu97jH+1vmNyGxmieonjfDmBr7jnOoKerf
	 pwkHp9SgetcYJti68BD+aTcNPmX54eNkuRRWzzesZbjkBpySTA7TR2g6M8i5UcszOv
	 CJ0gBkHXn8J+f7jyl88XtEW9BejRvQBE48ev7Z5OdMndlU1MB++oYxK7ELFDlCFA6T
	 NeBCKxIrJh6mWhBW/v9wlq7Og9obDAxq8xK/ZNOS4NZnSfZZBFwnXOi3ww1QVbFOQa
	 xnM2DPM2UtqtfwqGnsJuXwcAuKBhZdWcfnZjjzbIi6Oyc1KhNW++F4rAoDsxESMSTW
	 zTyLUSwi2wWMw==
Message-ID: <03686997-f3d2-4e6a-b4a8-99543a9f8a27@kernel.org>
Date: Thu, 2 Apr 2026 10:24:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: huge_memory: refactor defrag_show() to use
 defrag_flags[]
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org>
 <20260320-thp_defrag-v1-2-6ab15d0d26eb@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260320-thp_defrag-v1-2-6ab15d0d26eb@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9414B20003
X-Stat-Signature: uhdrq649ipbi1f8b1thgn9hc9119cghu
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775118254-900536
X-HE-Meta: U2FsdGVkX1/B/z8yIzb0XwvTeFuig63r6ZKS80NBIltUXD/Ph+NIF17QTBVtqLSTa6tDDF16/t8G0g+BFdEYMduWat0KAAbZuFRxaUrU5NgoPBkJs1GxK4Ts1t4qmEImDlwuRijh0IdL8c63BeEUVUcHqr4+ZCOX0N8+XyH5tDp2l7Af3MfdFvPx4XBrOVwGNfih2+ySvm+I62kPcQVgUNadv8tKvrBSFJbWZfJ26j+n+kQPoVBiaElyOKN+1IDiEmDdMjrjxkoLuvYPriCEnr1qthX9+fK6ablbLjEd6KOc3QeOfH+7KeMIqUbh4N1VuxWSSJiHY0/QG73hdbblzfanSkK8TdfQFY9IBpnlxcnB7uZYJRLFFK7aBTZEIZkG2Dbhpyh7WoWN1bgO8cebGzjy5xdvfKAYbDa+c8CLmbOgPXrZ1umDtf6JM/swWmFpOWYIjF6zbZaZgK7r233ydSHKfHYFyWXuIOp9grNinD2zPaGzfw9cYz5MP40B49MD7jZbsJBLqOhr2e+uAKPDR5jMDor73TdR1OPFGTC2NfZNbv688zRRvKq0EJ5FJkNLJe+rcYkTHJE6ERPEHrEhYvtMoCrzeJXS63syQ1bsDkS+oZ3SiEOnpf4ytn4WzrVy54egc+qMyWqHjmjw23+MPBiQffYcfACZ8gikoYRQfqQZGSKuTrip/4l/NQ1NawxE5lJUhDsybPdjFVbx0E5g5atApbmYqogzdqkfg6xpTRHoj1oT7N+a9EhxholgaLHvY/0b/W5DH8KQhSQ+Ze3Bl6De1uQsNENyHc/SLUcegcqojRMFUj9V8jG4mtqPZjpPgzlnH6BekojKNRdyuUjIgKdA/GKzRrmOV+CuaTSV6y3wy2V2L+BOlOuN0V+s9guPoyNlucHLUBEG4ubth4ASkFPJ5HTkHjoepw19DlKiwQ2NlPKDg5RSNDWi7aqmxtYXyw+45Jtsg0TdVGd0PCW
 K3uVL8fT
 Xha6jYv0vQKprYmaxZWHTDI3UvJZwKFqFsxp9tWSlP+lAfQKlgF0Mi+58Jed834eGJ0yR20GxIQgesU4dS/jTzSisU3UPHYdVErJNJslRKPWaH/9jN8ejMou8StN1LRzjQRez8uwXgySPA6Udf6lrv6EjjX4h3cnSZRSww5YOvv5AKXk6OU1O4y2txKywBnaJucwNCHP5ZyWelxDm2tEvuXzadA7YB+v6J9fS9F7BcLg7MQLBIzCpX6lgSFETmc7P4zJZB0+sFMwkYCzhgjUfFbu34pu8Fp6z8qNZGXhlYFpVpghyWf8vLLA+1Dq8HnsZFNtKBF2v7xDhFbxW86szhYdUxf3HkuvIVg28
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 17:05, Breno Leitao wrote:
> Replace the hardcoded if/else chain of test_bit() calls and string
> literals in defrag_show() with a loop over defrag_flags[] and
> defrag_mode_strings[] arrays introduced in the previous commit.
> 
> This makes defrag_show() consistent with defrag_store() and eliminates
> the duplicated mode name strings.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/huge_memory.c | 38 ++++++++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 4843e2154038f..eaa6623fa49e2 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -447,24 +447,30 @@ static const enum transparent_hugepage_flag defrag_flags[] = {
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
> +					     defrag_mode_strings[i]);
> +	}
> +
> +	/* Replace trailing space with newline */
> +	buf[len - 1] = '\n';
> +
> +	return len;

The old code was certainly way easier to get. But this one here looks
good to me.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

