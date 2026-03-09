Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF3BFF3C263
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45BAB6B00A3; Mon,  9 Mar 2026 09:45:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425CC6B00A5; Mon,  9 Mar 2026 09:45:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3282C6B00A6; Mon,  9 Mar 2026 09:45:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21E626B00A3
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:45:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EDC0E1BFD2
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:45:53 +0000 (UTC)
X-FDA: 84526647786.20.A3585D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3DB53100004
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:45:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f+uB5+io;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773063952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdpkBVXQqaztcRpunxmS+20ynH4iIZbOg126QmuMCVg=;
	b=tPE46wvCKm2JgCY6sFooMuUZsuJG8yyEaycdpxIEwu/6+YI6CagYqdnZIKel7YVNBxfHFB
	7+diwgSLsW/qNfLmB8BSoQXxa6pbd4JNUon/xOStQQVe9/wGz4xM/WEro5sXW28+AWMnlp
	ocoG/ssiuAVUwCgKpvOxL4/Tje78IME=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f+uB5+io;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773063952; a=rsa-sha256;
	cv=none;
	b=3usMF+q2qaZqYJGNKlw+Q6ww1CaMvJilYk27NUi6LfcBF5FPWPqK0MjlNcAXPnJW3DKRU5
	oaTEH8vuJLuznAsLVNyv0Np3FX/nJKorsqV7ffiXnhNbemCr2Tc3URsrnXuOUrq17MJal+
	gDLjkDDrMzi2kG78H9bVphj6qwrSMRE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9ED4C60133;
	Mon,  9 Mar 2026 13:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D6CC2BC9E;
	Mon,  9 Mar 2026 13:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773063951;
	bh=uJhVNt32IndBelFxb/TnWkfy5J8A3tuWwwNGBogcLSc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f+uB5+ioxZ2uQUIYl3Oc1O86bfYtlfqKUyT18pDwStUjEAZx1x9m3kVkZb9pFnqAl
	 LNlCZhd42Jjm8zM5AysYSUHz26XAiQoa5iSRYTSVeHP5pgOj9cw2Qof5jk1ydrhut6
	 YboNQL8470tawD40gNEm0uOAMY1fOqC+gY1Ly2sczhYaxyQe6bFaWO0DUN0FKQz9GY
	 SFXF2fbINuhEwy14PERotM0MUtofd8SNsLoYNXaZj+t6DfbWNkylkjEBd8wXJdZ0lr
	 opLi9yTow4uaBOeYOniL3XcGKcGH0QZiEDh5JnmEDMdTvCVxOtDcQaAwBrJ0jm4Xq4
	 YFtuw+/FHjj3g==
Message-ID: <1b61cbcc-d062-4475-8763-e415e821fd14@kernel.org>
Date: Mon, 9 Mar 2026 14:45:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
 <20260309-thp_logs-v4-3-926b9840083e@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260309-thp_logs-v4-3-926b9840083e@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3DB53100004
X-Stat-Signature: e15upmerooa8tutu5wznup6uiasps3u9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773063952-51551
X-HE-Meta: U2FsdGVkX1+WtKwTTp70thpGPImsjwvEAk4qGgI8LzwMuG/NDrTmYdiww2wNYpg7+30iqlS88VRSBfPA+jHqbJ+/bqEj46k/UnqAb80aiH/jtjPZMwyGCr2NSYxtjJOLYFDbILJNJUbP+u3opNjSqLO8Yu3udoPGKeg04XVZwBT3UY+sUeZmF5H8aXno5Ywul5NpnW+Qzu/LrVYAZgCWl3FW9rL53dFMRU2LbDpjEguHpHOilvM6KwMv2PdTHAOrwzXV1m0y2BwFxOoJIETF+XoSmgu/ueYWHni0GCZn1V0KDANgm16GzYZNRDix7eSrQQhyPkFAiTt5w1QdCbeRGIS1x31j4tVJw4/nBFvCAyKb73YTJ5JSA9oUlF8NZPYpc5lp11SSrvsA3uip/jzSQfqFfgyfJd7N0lOpvgqtXT1moP3jVfwYrE9wstiGxovh0PWCibj4YpQ5/OVieT7KH6TM0Fghtvwd1/s33uVd2BqS4Q9nYva5CT4s4r6JPtKI1QexnCbJZiXUlxm2KebfNjSPPbXsvM4ZtT3pVHvEETjD/uUQoEbcIDF7isslQ69GCpkvlQvo0u2Op6q1P/3Q8zzLHgUqzq+HrsIZi+5NJ2uv1viYOxuWWbhu1Qq6Z3k6JxwoENFUtp676kzjLmIa5oCpiOXvAOxuk5jStqIUiFJJo+FAfI89J5lupu61u8RIoPNgDO+9BGvqSeMd+khHe6XWYU+L+W5qonv0fSNfnks6PLcTT77EePnTZ+SUn4wuVQS1lSOuJuVCzmgfpxMl5zr2pIPwm/T0f6JclJJR0XRrmKN4r6Kc8wagwA1SSb+VnpEfwmass2PI6WU6iO6ffo9p3xVHtWP4Ymbln4Qw7iorhZQM0IkYpMF0VRv8qD21i+Kr7X89nPMLbreF2T6Uzrf57gLu4GeYI9TAJMC+Ldzx+eCAjILJsekb3jxRiXjG92TfWp2oWVp3u6lhfy9
 ycWh+j/k
 6UrICE5FSELQxUc1ONV39fOFWU8mp6X4AgQqcUml0vfwG5H0NLm7jCg+O51/jLB9CXp7J5qcybb14Esna7aFhER4HsNqD1P9a2c68XtK9xDqcO0qGrMXZstz4jf6gMsW1DC7kh4TESBpk1r8tt64Zm0Xv74GVODExP4mJI4ZNrIlazaiStFOofKNP1CsoHHsg9EHT8Eg4CsBo+lQmEXALosJeWQuamLu0/ZVmYDtwbSUcnrRpoGZYEhI8GiTcea2tb1bJsR2asFxvIIMEnV/6bAlHuhPiqeyFf54Gs2q6gd7cKRwYLOfDFXhuL0FO7OzprKW/kdq0pnsczV+SV0FrMGZpt8IuwqOjYuOG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 12:07, Breno Leitao wrote:
> Refactor enabled_store() to use a new change_enabled() helper.
> Introduce a separate enum global_enabled_mode and
> global_enabled_mode_strings[], mirroring the anon_enabled_mode
> pattern from the previous commit.
> 
> A separate enum is necessary because the global THP setting does
> not support "inherit", only "always", "madvise", and "never".
> Reusing anon_enabled_mode would leave a NULL gap in the string
> array, causing sysfs_match_string() to stop early and fail to
> match entries after the gap.
> 
> The helper uses the same loop pattern as change_anon_orders(),
> iterating over an array of flag bit positions and using
> test_and_set_bit()/test_and_clear_bit() to track whether the state
> actually changed.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 48 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2d5b05a416dab..be42a28da31d8 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -330,30 +330,63 @@ static const char * const anon_enabled_mode_strings[] = {
>  	[ANON_ENABLED_NEVER]	= "never",
>  };
>  
> +enum global_enabled_mode {
> +	GLOBAL_ENABLED_ALWAYS	= 0,
> +	GLOBAL_ENABLED_MADVISE	= 1,
> +	GLOBAL_ENABLED_NEVER	= 2,
> +};
> +
> +static const char * const global_enabled_mode_strings[] = {
> +	[GLOBAL_ENABLED_ALWAYS]		= "always",
> +	[GLOBAL_ENABLED_MADVISE]	= "madvise",
> +	[GLOBAL_ENABLED_NEVER]		= "never",
> +};
> +
> +static bool change_enabled(enum global_enabled_mode mode)

I'd similarly call this something like "set_global_enabled_mode"


-- 
Cheers,

David

