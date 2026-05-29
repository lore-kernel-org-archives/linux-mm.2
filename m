Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50064CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 16:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB6816B00C4; Fri, 29 May 2026 12:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66F86B00C8; Fri, 29 May 2026 12:45:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97CEC6B00C9; Fri, 29 May 2026 12:45:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 835CE6B00C4
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:45:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C197C1298
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:45:35 +0000 (UTC)
X-FDA: 84821033430.04.1D74890
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 712E4A000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:45:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+6m3z+x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780073133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GI/3CxbtRcVE+9zBOcv6zZDBqjLvSiyQcrxy+I1s2kY=;
	b=8JmCyg3K6wKsVW6DTrRgo96xRjy3mQBvk6HEz/vCgDkloqvRJRBX1yM4c09EX5DV/q++el
	zWqySAQIj/aZI8u8iaCliXOHQkINypIUoUQVSl3f1bae+avwWD4gREWY0o72w21/dyx7HP
	HhYSe5Z7a1f4kEP4XGVlNV4tR2VJVjA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+6m3z+x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780073133; a=rsa-sha256;
	cv=none;
	b=N1gr6b4a7UQcApj4G/U71fk+7Fw9ZYkx7eW1xldKRxI9c033p4SMLZhrJgjA9VtbpSclIy
	gxsZKNyvmIl4WUdVfL7L8CEdjGjD3q4QWlxrcoP5sOOYXO2ejhaxhLfe8Vn9aU89OoOM3w
	MX8ypvrTsDmn3l69wTFO4h6mewTpIz8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 546B543681;
	Fri, 29 May 2026 16:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8389C1F00899;
	Fri, 29 May 2026 16:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780073132;
	bh=GI/3CxbtRcVE+9zBOcv6zZDBqjLvSiyQcrxy+I1s2kY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F+6m3z+xQ394skheiMjunzJhlBgB+CzilkptCdn5ktna0OC9prPxP1/JKJw82p+YI
	 UXVqD0hCer/BB0QybutXjH03Y5iQs+hfrBjQIOsoUaUwmy4zCcGVTKTiD+3qLFeILI
	 dJosqiE6T+i1kzFoqbVlDw9pf1t0BnX6hulULUji5sihczml9EFhDc/VCXiPMlB47N
	 nn0n2fVF7KDRNWHHf6uD4hn09Uo+C96XSmN4PRA67PjSlObXIW+qgLxqzYFOm82NRZ
	 x+UgPpKrUPQW82c2RprpiyLwOu2aYKuxRl1lSijFKgSHKXlSixB2r4swYDEj+GDr4H
	 7sD6NQXv88zBg==
Date: Fri, 29 May 2026 17:45:24 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, jgg@ziepe.ca, 
	leon@kernel.org, david@kernel.org, shuah@kernel.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, balbirs@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com, stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: do not warn on seeing non-migration
 pmd entry
Message-ID: <ahmdJFCw2arBdsd9@lucifer>
References: <20260529111704.1078346-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529111704.1078346-1-dev.jain@arm.com>
X-Stat-Signature: 6dqrsawq1qh43mj1efwytqwfa4f3j93d
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 712E4A000E
X-Rspam-User: 
X-HE-Tag: 1780073133-421469
X-HE-Meta: U2FsdGVkX18jBBoFsuKnKer9cgoZF8XAxjidE8qiOoZi/nucPyvFKVWdfrxQ5PXG3P/3z6hkbbEj4oUQq/EqpjXaERm2C20p0lWnTmmrQHw0T7sgVGQNOCdAKSC3s3a3OKtCKIxYpGm7Uga3Ml4D+RLuK58ZH+IOzScMI/UHT6OkhNROq4q1J0woOEBpZl1tTi5Jm97CwxCfgk5kJm2YHDJDqe/L3bmE+CtZuN0AEj48n418VRTINrwFynlVrvLA6bqC0XOtvS0S6j+XIkbQ7nGK0hzqnnOxoLT7PQeNuqJS3ioradBK0B9JYuhFkZnNa+Z1gFkGwFz5QBGXXyDcLjetdMljc+DJPfZK4i8R+pU2eYwENx91txbk1D2rEizbsHAWPYfCX4G3uBiB2wnBqwZzakQcjFLGoDc40d65RW0CWWyG2pPnPzq/UpaJ/eaBYrGtNCe+8F/RhXMQyhAhQBslx6MkQrF9OLDCKJqw0fDBHJsbpkm9a7dbkzeZZ+VTUYeUOXnfkKWW8vTfhf54jJq9G1ohb/xA7yLeStzVzTyIXsE9oNzJfu4jDlraiFxcrx0ATuB3US1jYm5X7sSB8LmLZRe5tjSnBGs0Hmb23Ch5bz8YO5GjkU/GPx2AEK7MRbUcZnawrqX1/xqSRZ5DrrmXprj1n9LIwp092y4XX4daLsy4a3wRRg39rjWCGpSPI30f+5zb2DydvCi1PNC0c6UF45mGRqmp++RQ5cw4KvEQcfthry5HSafI0JrzPMhwEnhMx0iVBHWzgOufZno/8h9mwpjIMFEmaYbXLdl32MAZ25GeUxgBKY7659e04dW+BOdkQqlsDCMwZvF98JJOTdaO7Utk40IiMUlO9x5iDrnYEiq9AQmPq3OOfR1NYZlkAk31OMOa/kqV4LcYTVkGoPjWDzDU1CC1JgVT8GfLGcBlyIRtRdeLGro/FAk6K/ca7rAVbFP4+2Q/Wt4sKkp
 X5EwkidL
 +gEEG0sElOfP2xdUN5+l5LsTByDI1ExOKWgbPJt+9cVR4FIbP7DU9VMoYzjNYPBrd82MY7ZKMcUz8EYUTDxlg2dlq8BOGzcyErkAYw8GnnYnVX1kQbclwvF9FtAz7SHl5RpYtf2NbXvD6d+ZtoimI8FTagdtzI928qDmmqASWGFtkPTsBpjJYPWN8Hd6dpRbkDm8GXdUNXt2n3Q/LYRQtB6kNQzjiJWwlegjvyuwivDHF3tW6asCKU+AtvajoP/dQv0BLeVTI3pjmS1CW5Cu9BawH88nBnK6Bhz8cPtlN2FxjflKj+1mjuw9Tfqn4ls80d8vhNLHVc6B8oAq262ds8mBPhI/up7wJeqSmcysUnoZqMMdD/cXPdK5IdVylnq8rbKs+tCCJ9UJSgyk0z8FNFQlP2NlSzfj22j9Yvcyu2wn3tN4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 11:17:03AM +0000, Dev Jain wrote:
> pagemap_pmd_range_thp() warns if a non-present PMD is not a migration
> entry. This became false once device-private entries at the PMD level were
> added.
>
> One can hit the warning by patching hmm-tests.c with the following:
>
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index e1c8a679a4cf3..7f0a3384f3c5f 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -209,6 +209,37 @@ static int hmm_dmirror_cmd(int fd,
>  	return 0;
>  }
>
> +static int hmm_read_self_pagemap(void *addr, unsigned long npages,
> +				 unsigned long page_size)
> +{
> +	const size_t entry_size = sizeof(uint64_t);
> +	const off_t offset = ((uintptr_t)addr / page_size) * entry_size;
> +	uint64_t *entries;
> +	ssize_t nread;
> +	int fd;
> +
> +	entries = malloc(npages * entry_size);
> +	if (!entries)
> +		return -ENOMEM;
> +
> +	fd = open("/proc/self/pagemap", O_RDONLY);
> +	if (fd < 0) {
> +		free(entries);
> +		return -errno;
> +	}
> +
> +	nread = pread(fd, entries, npages * entry_size, offset);
> +	close(fd);
> +	free(entries);
> +
> +	if (nread < 0)
> +		return -errno;
> +	if ((size_t)nread != npages * entry_size)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
>  static void hmm_buffer_free(struct hmm_buffer *buffer)
>  {
>  	if (buffer == NULL)
> @@ -2314,6 +2345,10 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  	ASSERT_EQ(ret, 0);
>  	ASSERT_EQ(buffer->cpages, npages);
>
> +	/* Exercise pagemap on a PMD device-private entry. */
> +	ret = hmm_read_self_pagemap(buffer->ptr, npages, self->page_size);
> +	ASSERT_EQ(ret, 0);
> +
>  	/* Check what the device read. */
>  	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
>  		ASSERT_EQ(ptr[i], i);

Thanks for this!

though, hmm it really feels like you maybe want to add this as a test and
make this a series :)

Andrew is usually fine with adding tests as part of a fix I believe!

>
>
> Therefore, remove the stale migration-only assertion.
>
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dev Jain <dev.jain@arm.com>

The logic does seem sense, it does seem like something of an oversight here
and I can repro the assert (though I have to fix something else first on my
system, patch incoming for that...!)

> ---
> Applies on mm-unstable (404fb4f38e8f).
>
>  fs/proc/task_mmu.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 1e3a15bf46f4e..58938e62154d9 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2129,7 +2129,6 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
>  			flags |= PM_SOFT_DIRTY;
>  		if (pmd_swp_uffd_wp(pmd))
>  			flags |= PM_UFFD_WP;
> -		VM_WARN_ON_ONCE(!pmd_is_migration_entry(pmd));
>  		page = softleaf_to_page(entry);

>  	}
>
> --
> 2.43.0
>

Cheers, Lorenzo

