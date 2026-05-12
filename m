Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52717CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904006B0088; Tue, 12 May 2026 08:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4FC6B008A; Tue, 12 May 2026 08:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB8D6B008C; Tue, 12 May 2026 08:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2D26B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:21:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EA2F4042E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:21:39 +0000 (UTC)
X-FDA: 84758678718.15.8CFDA5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6257B12000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:21:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j83PBPm9;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778588497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/rOFx8fP/g0553IE8eeAsVhGXObHgM23EMozFGNOA+A=;
	b=4sWWb7uD055kurTnPw8bpGReUma84EiPIeAJwOR/G3oXSl8wNRWAsYrmHRN5fla6UTcufy
	xjU+tfqxWF4MLeVprUx7lGE8dWr0rGOlj/Snq/HPLyDaKwVmWdAAA4L0SskAwSUQyKnbaX
	nTvsK/Ib6zYhJwKdVNocQfJdPWTnQAM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j83PBPm9;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778588497; a=rsa-sha256;
	cv=none;
	b=ucIcIpu/ax/sYZ4cL8IMbSRLk0LDqAZTuqvVKE2TxV1nJHbPxgO6IFErz7K3JX31H+wgkg
	oul8D/AKeBEkGBIzlUWNqmFdA1wFjysHnZjpItA10StIPHu7kZoiGQcx0Tz7yO/cKJ/slq
	Dt3Mm8s7ccnEZWDuA6fkVf4/A778SKU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BEA29600CB;
	Tue, 12 May 2026 12:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65147C2BCB0;
	Tue, 12 May 2026 12:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778588496;
	bh=wqAIUXGNRFLlciEzYLfd74vbbJTuTmippmPLs7dX3ss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j83PBPm90V70Z5DzvXF/3ALqo6TXArDPPwEh49VBE2prM9PIC8+QiZm8wPP1vX0ES
	 fEqsbz26nHNAhiXOyR/MEJHOLhUDrAYgycH4Ep0mcOx3E9YfLFeMqUYxC2FNw7ed7T
	 /TLDLKuSf9FZPO7ncyuDSSmzbXMdJlN3DtvRM7ZbFxkvWOkMS4NEiczktj0VWg9WZf
	 LG+kjWyYJhnmfZ2EXeJ8ynXUMi+f/tPRQ3poYQ0ez2jSAZj24dxEtXnGE5yP6ChUZd
	 yUxcB/Z91qGqxb3a46U6SDuzlEU5e7yTVJmX5lozqtxmRqXmpvtTx3ERcZH5Ap4a6d
	 HfZkFvN4Hg3EQ==
Date: Tue, 12 May 2026 15:21:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, vbabka@kernel.org,
	surenb@google.com, mhocko@suse.com, shuah@kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix mmap() return value check in
 run_migration_benchmark
Message-ID: <agMbSBgaBRoh2-xn@kernel.org>
References: <20260512101305.139509-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512101305.139509-1-lihongfu@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6257B12000B
X-Stat-Signature: 3jzdtsapz7k41ktugzbynsizeg9tezez
X-HE-Tag: 1778588497-687247
X-HE-Meta: U2FsdGVkX18vRgJ8TWmgY2/vASWfiaBgfaAvClABdBaj0QLokOx7uNoBNJQs3voPZFKm65MUNfwZrP8Bu1xDd/F9oeu4K2ot+6NcykIZp2V3n6sSvYQHwFH5YnjqwliH02a4vaE6oZTlVDYkopnV2Lks5ih4JpQdY+dslFcQ5A28gKBkCK6idOOXhBu5llBxL0LoqBtQ78AxC4+MsfigP/78s47AlWWH5ox9GvlQK6i7ykDZokxauPFGhll8/9RM+TTouv0A5KfjQ+NoQZ7eFtx3OSjE5m+SvV1FqhI+nZWgahIu24RhxGrIEJGMAfJdnLBUmrtX+xetaQHDu769n+uXwaq/Zz7VRO4n16krGjMLucfgYFtz22f3InUclbooj2rf81FtYo+w+xs6n4ynlGNkV5Ji72sIS7sesvyrz2Ar548VjeA2HemOwjTBHuC4ok4BCl/wFYJf2ST3K576W6ojBJmSlAZWL+YgMKrIbFfncUwiS164Nz7d943+wsO9OUA/klOUrpW7g939rtl2CkIqqDrPhuFWf31JZ8FvLJJZBLcz1oYYM6lzcpGLFtZXnlVbdvtc33f0KvmGri7HTXhPsEyIdB3wIgmmRx99kI7d3D9VpW6iXoxCDQhPbSvfeSodWUwLpQ/Bh24wHQzFqE5yn/e0AzxLgbAZIP29C4FoTcN/Hocnb0qdQuZlQ6JWZ1qJ+jE47lMFPM+4iRNL/KtzHQj6Y92/M33g4s5IzTpbx9cyajzpsIlC5//CNJ3kz468vKpI+CqFwZGkNOxh1ekIZq6prCX0UrfoJtkQB9m8dD6M2pm+JeY9NS2xfUzLXlyScJpSmo+E7P80YBRraPduQ03lHRTEjU3KFv655zB/YtAwAJDYugArndd/SUg3O2S7n3OJ4iijwZNMvjFYJq5lTp9lAyEGFZLwEYNUmrZyQO/X7vJ0UeN1F4Q82gmYqULqpK+ziW0PkdhCtIE
 YZzoBMqa
 k28cDoAwchpyx0lHImAkCYhC43FI0lKg38QUzgXzml907kHWIVreoZubSe8hyUQIYCc2KKSzHNMCbjbcw+3TFQy3+ohckWZlzUs+EQBY27IYzXKTpiCU72GmDOnkbyK+ijzinDgGnBZcEZ316tcrIWhk4T1qvLNatfdzZYBU5AjMQviCWGB4hOA4AydTN3IiN6Erq03PzTxc9S2Nzq4cu+BL5WGPZA2wL13im+j7sIGHZiKkD+0/44hQeasLWRVKeUgDlcV7YRupSGI9Lk3o4aPd1QtJP9OIXLcVNriqO2PlBKUY/a+cE6Ci/JQa+DM9xXiFuMulee8tXnK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 06:13:05PM +0800, Hongfu Li wrote:
> mmap() returns MAP_FAILED on error, not NULL.  The current check uses
> !buffer->ptr, which evaluates to false when mmap() fails (since
> MAP_FAILED is (void *)-1, not 0), so the error path is never taken.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/hmm-tests.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index 788689497e92..d72adba5c74e 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -2688,7 +2688,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>  	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
>  			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>  
> -	if (!buffer->ptr)
> +	if (buffer->ptr == MAP_FAILED)
>  		return -1;
>  
>  	/* Apply THP hint if requested */
> -- 
> 2.25.1
> 

-- 
Sincerely yours,
Mike.

