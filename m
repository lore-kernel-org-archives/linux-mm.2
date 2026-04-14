Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF797F531DE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F56A6B0093; Tue, 14 Apr 2026 07:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD156B0096; Tue, 14 Apr 2026 07:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3976B0098; Tue, 14 Apr 2026 07:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F14F06B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:07:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B8B16E39C5
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:07:38 +0000 (UTC)
X-FDA: 84656885796.16.A4A560E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1750D1C0004
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:07:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ATMBctj0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776164857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkQuziA8q4s91pV1YIU4gFsCibXgPQvYBrRhaFrX4bs=;
	b=67iGjWC/2iklmJ/AbNPNJ25ZoPjPhYb6ZISjCiKVtix389fqQ6W44jylN+4w55UsVLqf4c
	FfZ7hc5NXIzzl7ZxvSXqEnGCEWsIDTz8DDCvC1iChqulOVJJ7zdwbLOK1Wp3eROiXa+y3O
	JAWrFfzKZLn8QpLvmtpCha7y4KQx7hY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776164857; a=rsa-sha256;
	cv=none;
	b=cNHUqXayreL3Nm4GjTkI/MXio4ca2K7zd+iO7vc7MHD5w5s3hveAg5MYVIwQBjQfXP9iNB
	8efX/gifKkEn4s45QNHT+SzBrUR2+X+xnVZPTuBzdxFyoysGw3PV3SazqfZESi/qA7vuRr
	YmcQuGkX7n4j8TnIQum20cqZHQAvu54=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ATMBctj0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 78800600AD;
	Tue, 14 Apr 2026 11:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75810C19425;
	Tue, 14 Apr 2026 11:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776164856;
	bh=h6mc8jie8MzEoUPQ7I5cFnzZRgkEfbbKtBuB4QW0hdo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ATMBctj0z8nZzAlbXRzoxXf7mJ5bwP9C0BW2ZMnXcMCbybkluttXeTKiqejmyihIV
	 VVRH3SfyueBNDK5NXhwU+fJKip4wxKsbqWHJrCKoi25JO1dg8/Cay6iiQmFokpPh3L
	 T7wRiyoozKMcD5mTvV5q92GrJrQUVxmlkT/EaLJT62UDGHhG5wngwYDyHeoSIntN+V
	 CEhcGCA0LEgjQFyIORw5/fekzZnL+LyLVPGCD+mm/dC1p4xPzeAhW+bj1Dq7MgPK0z
	 u+LEmIZb6HnEfVdMeMTyUBQ8HrTYmeyOnZTdKLojLeBscrNlDrQlpuiF9wSCAKrpbZ
	 ixqVEyj5ZKsVQ==
Message-ID: <342ea75b-4b96-4f80-9e48-9c9a019081ea@kernel.org>
Date: Tue, 14 Apr 2026 13:07:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS
 from comments in guard-regions
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-13-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413192030.3275825-13-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1750D1C0004
X-Stat-Signature: 7enshf5wbmxtnx9zwzr1y7mt9tcj463j
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776164856-457856
X-HE-Meta: U2FsdGVkX18//YhYvonQD98Fi5+qPcllPYDgjq4Okfy1iq1pslYzf8laIoLk5QkGRfP1/LrrL2GmOqusrGM2R6OAa2mQaC0ku0UfBMaPB6h2zOEX5SnswGpuHE8vaEYgH9eyFXh4L3hvE6OWmm2jliqVzYuSUOs5JSWeJqX28sMopr3RFh+e2cZT7gFY6jf/jGQkctHfZsA6eNlLLBsSdJJKGyEiCLD9KbOMfcgzje0chVU+u18YvUiYRigoBYTuLiieLqfXnnL+ne4ru2AsiSFvZ+WDaI3Oei8rKwtJ5o9aVuqMB9ul5I1qvH/bA5nkccF8xM/8Hynt/66ImDmJAx22pTNJ2FgBBLuJcEmJrn8jxhIrYIXDTMVpsoaIWMawE8mKllguvFFj92B7kwDUq3BXLWyVbhTsXHF/CLWyr6MTG6VT/w7A8jgY/4cAR19lkigyuapCdqgFYlfXhIn+8Z8SYynmJEdVRiJlfAW+qRhjfKtRP8H/qRrlJMtVbp3scjHv4tRUEr5S+bgZ1IradhyAEgnA5RicJlNRlMxY8ZAaNnh9AEZceRDaLc/M4OYPuttrs3WCqszBn6XQjOM04sraDKEE7/eLG872D+iREnfeMTvhzdUPftkBrU7EgMxIik2Fpak5bXh5Tpy4sHpStuw/35TBeIrVuWlC2VRebGHdGiwRmgt6jLoXqUT86UFVDVqwr0L1EZXgWmyOU4eAP5xM8XSd9l7fnmwKI53U08TvoPlBW33AkFMpOjE0oKgK9+0x+C0brJ4g6+9wvLOP6PtSKqc2uz4YyDNfoy8uV7R+QZTgN/uO1v0ZHj81AI47xZRxeQmZbaQth2t76aTOYu5HVuu6+h34ix96T7F/YZ9lNkfz/GKxQPgFjjYTz0SODbuRVEPc98EHFM78tRDU2mPPlSw0LTgQCPsApq3WLatd1tRAIysrqA5ibkTTOaSmptZ3Ljeq6JIj9M+bK21
 stnsa3cG
 kgIP8TL1XqlVm6nUtZR2UaXZEuzZ5JdKfFVRBTPeUhD4MVLI0TeDjmWhkRbFM9OM6dNyLFBR7nT8ttY95w4SAMQa0p0qzAafeJDj0OTbCe1sq/ypzPyx9QTRsVVeREWLt4dtUUZhCSBJyZYBMAatjjW4rA8CnA0vWak++RloL1ppAhXQ4sU1/IrM+uBza7jubeB1lXrrb3+JdJzRIzdLKC4CfCGu3hxtDtlKRPETU08zfkuRiXP2hMcUQ7y+QuF92QTitnLVExdUNbOFKQJHTYaJikkpZEXff6Cs3MB7QsqmqefG2tCjdVlsmaifXkW6rpTG5ZBuDycPRbmTN6h/cjfWuz++HN/Ce/9PL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 21:20, Zi Yan wrote:
> Any file system with large folio support and the supported orders include
> PMD_ORDER can be used.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  tools/testing/selftests/mm/guard-regions.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index 48e8b1539be3..13e77e48b6ef 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -2205,7 +2205,7 @@ TEST_F(guard_regions, collapse)
>  
>  	/*
>  	 * We must close and re-open local-file backed as read-only for
> -	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
> +	 * MADV_COLLAPSE to work.
>  	 */
>  	if (variant->backing == LOCAL_FILE_BACKED) {
>  		ASSERT_EQ(close(self->fd), 0);
> @@ -2237,9 +2237,10 @@ TEST_F(guard_regions, collapse)
>  	/*
>  	 * Now collapse the entire region. This should fail in all cases.
>  	 *
> -	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
> -	 * not set for the local file case, but we can't differentiate whether
> -	 * this occurred or if the collapse was rightly rejected.
> +	 * The madvise() call will also fail if the file system does not support
> +	 * large folio or the supported orders do not include PMD_ORDER for the

"folios"

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

