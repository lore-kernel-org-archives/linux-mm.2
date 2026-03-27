Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EE4810ED676
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAE206B0095; Fri, 27 Mar 2026 09:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85A56B0098; Fri, 27 Mar 2026 09:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2D06B0099; Fri, 27 Mar 2026 09:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE5366B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:06:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BA9A1A1145
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:06:03 +0000 (UTC)
X-FDA: 84591865806.17.7B6245A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 88F4E18001D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:06:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jzLXndaw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774616761; a=rsa-sha256;
	cv=none;
	b=PL/duJZ+tSsp+uFWR52u+b0FMAYLCgH9ZxY7Ea/JCIY1L0xUgCCuTieGrXd7gKs6WR3aE5
	cQV4wjRlQnI/0xpyBO1CT7aDeErws6++d7ZQu31sTQkifWXNUyFoPVNIejGVjDkdrvscfB
	QrM8ABvUMHjdJdBFa525l2s2zP14/V8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jzLXndaw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774616761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcZNd9n7ZpcJRS4dpaPz6P06uazlZ9mvModFiNYWbK8=;
	b=T7JTm87A9zqANfkMlL5aeUy2UYZVlr7LWxexktmXJ+WbePGd0usS3yrjmc43j6iickz/wK
	ntwQ6fzvC1Wnnxxh7vc80/bOYQHBg9o9hbEvuG8/N8bLXYEPmYmfCiGgs/4Szy032vYvC5
	8it5sPuiPHp5M+tqEo3obDkHaHqEgeY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E30960103;
	Fri, 27 Mar 2026 13:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E173AC19423;
	Fri, 27 Mar 2026 13:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774616760;
	bh=d9Up/u6razcCkBI/74+4G1ND2cTaNh5pT3UQX+rht0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jzLXndawfLJkQValNjTETBv475Kvw4SFYaKpEkaMfFtUyVIlUSL5BSb/j9M9KpFWU
	 kjzXid+okYLCGy2z8DBdKrN5AMamZUBP50gFVKG5jQsVlqU5koXyq4I8NabJL4PLyw
	 rbdCO1qdXp8wI4u4Dh1BML9zKWaMXm3iJtEAZlGlGn6pp+8BbtIj0M4TcKI8QJVDRA
	 ZssEKV+HUeH94mXoiDdXXkyOQbiMaIlK8oEd+6VuqJ3m4sSWUV2E93R4H1GBfXdKAM
	 KhMvbaTDEVERPTAnYC0osbzS1sOTOVB4/64w2SYUhRIOC3iFGZjvQvj1tZF0i9x6q3
	 z7H3ivtU1VeVA==
Date: Fri, 27 Mar 2026 13:05:58 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 09/10] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
Message-ID: <4e00d7a8-0504-44aa-ac8a-6a2269228525@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-10-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-10-ziy@nvidia.com>
X-Rspamd-Queue-Id: 88F4E18001D
X-Stat-Signature: 1cptp9sriw56qqhts44ypi3yqnn8exae
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774616761-8891
X-HE-Meta: U2FsdGVkX1/wxLWk06fy8+n5ivrSnSa0wXHfHnMI4PPW5B7Hm8xxA38f+6jjIKt0ihodaNeAzqHHpL741RfQowojLXnSfLEMFtSJbbVZ8Ln+8dcfydoZUuOc9mkP4hfeTaoNq/M0Uo7kyT6kZr6MUlEF6Sl8Yjwu+T5osuSWdXk+X80vWAJGN5vxMvMGZbSnN0wRRenLpkPwhsEDuaNGemwLQb8HsE8334/lbD+L2PgmFDJloPNGRT75WIpPkCqMlwRbzU5buLRTmLsvseTSLYUxmqinwkIWzzMGWEB9VC1EHY2q9sUyuBQ/dswVJQtjSDA9ASY/q+mcyGaysltiySr0ViIoL4nqdCuEK3qJyy1+HrNbI+xm/rjxVp06pcXQ3kYh6C9iHnRsPzmRGFSM74v8eRLll13IERS9gIJfx51d+DT3LGuP9qFJr4R4YLM5REFMQZVf93/+NiKz2iw73BTaZ7NG3Op8P+dPhfZOMn18TQKn5rhpL1KR4AIC+0Bxo6MDz9P9hsVOJYg33cBD7hSb8oNZ0mirSehTKYKcw7TKAvi0fUaPzbTJKnD3hviXTfyJUKqXRrXlm+A5uJ8btEXeU77TgPxsCOBr6WeUBbdmDSnc/9g8N67hIWkfl/tM/RdNdMGU80ZBBuMn80RsKeDw7tyjOeRteH01ck33LsHVAfIMhL2CXcsIdB0vkVi2teUhCIQOMkf5UWumHhouRbbQICjt0wIH5xt1qgsTPMpDd4mkCIBIUavwoF5/McXVx0GXos3Q5Ih8yodfKhL3f1Rxp6EDAPF1LDf0PzbB0acxp35GUrhC0I6oo4EcQuK8CW40+z8fB2gtTAJ5qSYYPVqETTaM3tq7q1/f8mkRiCAPLvPJvySGGtpK7I/TiHQ8WzrSMTI7DCFQ9ZMxeOOXPy+40p6rWjT9dpCvMYpYEsN7vHbNIYxcuubDtsdusMRAuzK83SomxR0yTZF0Sbu
 yimkkLBL
 fbJ4QyByr2aewSOzUsYeFy35bjuYRwLQgGLmctycknWN5p2iezJsl6QJMkDE0hhypk5q76RxKyPFEr8RgWO0+y0em3DphDBFCjtDqXE5kUf/UCzjLEC/QsmWU9uUHxn/jGUsP15ny/SePa7zStw4uAlrT0IaEvOtwthAoyNWi86JEG0vWKtzdBMqb+ka+8E2rLjbd8BNY3ZY2BliD6I6hXKSqeX5wfo21s32ca4F24ThMqxXntkPWisf+G+k9V4qvNRNboiEAxXuTKMgQpJsUWfrWQ7snSAUB46hoXgbDQDnShXKfedVB3RTz7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:42:54PM -0400, Zi Yan wrote:
> Change the requirement to a file system with large folio support and the
> supported order needs to include PMD_ORDER.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/khugepaged.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 3fe7ef04ac62..bdcdd31beb1e 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1086,8 +1086,8 @@ static void usage(void)
>  	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
>  	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
>  	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
> -	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built with\n");
> -	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
> +	fprintf(stderr, "\n\t\"file,all\" mem_type requires a file system\n");
> +	fprintf(stderr,	"\twith large folio support (order >= PMD order)\n");
>  	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
>  	fprintf(stderr,	"\tmounted with huge=advise option for khugepaged tests to work\n");
>  	fprintf(stderr,	"\n\tSupported Options:\n");
> --
> 2.43.0
>

