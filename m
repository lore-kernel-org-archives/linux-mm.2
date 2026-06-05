Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63042CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 11:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24FB6B008A; Fri,  5 Jun 2026 07:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFCC36B008C; Fri,  5 Jun 2026 07:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3A556B0092; Fri,  5 Jun 2026 07:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9794D6B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:32:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E39F1C23B0
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:32:03 +0000 (UTC)
X-FDA: 84845644926.11.39701B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 86FFA18000C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:32:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LpgVnwBS;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780659121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fc9vcaYFGx4VJWN/qkM/ZED/XUOAhAtzfGEMOALwC10=;
	b=tPNsjUXFqUrNT1mGZL3Yd+BCswmw/9tdO5CzHULtY1fJF4vfQdCNkMWY+f+pKUMuuDFStW
	TNIlTO3zlcdNUNjjEwDlxH5XBZL50+qUB6gkK4lwEXpcGc83k/4U8hgAJxn524VMSxa3vM
	5ULUhweshRfWuwr9t/UIYrqWmwOgNKE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780659121;
	b=VgKpka5SaesB6Svq0oASI5gm9FoCp1h36eJoTKXjHo/IuuV6PEi2XAY9ygEa0lNg1TVswf
	2qOrN/0rm2bb1w5bwcIpCI1wSFyyhyvp2/sYnmYlzCfMjQG84rGLI0oUURR2I9OCCx05DL
	H9TTw8pf2lUg2aazbJZ/uQlx19RTr8Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LpgVnwBS;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AB3F44251;
	Fri,  5 Jun 2026 11:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FA61F00893;
	Fri,  5 Jun 2026 11:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780659120;
	bh=Fc9vcaYFGx4VJWN/qkM/ZED/XUOAhAtzfGEMOALwC10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LpgVnwBSDBMv2ZCVDsEcjfQRjXldbcrdFN6YWC0rquZ76JA4WLAVGYdrU2Hg0J0lu
	 b9l48jH/dtdOxXSdPpiNOqWudkX7H+Dmk6Tu9z2LXgLyILK31qQOLW7KZ2lLLYAx3I
	 fUYlaYaQdJ3iXTb1M1TogOngIKpo02yqpbd2QnvxpVH038t+JW9MFZDkhAV1DQCDii
	 dOyl2XK8+BhGI4nDZpgsWPVpoFWUOyBIbuadfyTaVSYMIvySJTlLYbadUiM4xtF7KN
	 8RLN2HjeI1uJyOM2NAk8ouza4Wv8Bl+HS7G4okRB0cqcK7sKPLJJVHjh9v1hcoxnp2
	 dAjEYyWjWwq7A==
Date: Fri, 5 Jun 2026 12:31:52 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, jgg@ziepe.ca, 
	leon@kernel.org, david@kernel.org, shuah@kernel.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, balbirs@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-kselftest@vger.kernel.org, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com, usama.arif@linux.dev
Subject: Re: [PATCH v3 2/2] selftests/mm/hmm-tests: test pagemap reads of PMD
 device-private entries
Message-ID: <aiKdccWcgUaWCMes@lucifer>
References: <20260604055308.1947679-1-dev.jain@arm.com>
 <20260604055308.1947679-3-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604055308.1947679-3-dev.jain@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 86FFA18000C
X-Stat-Signature: u34coj5zz9gczxumbmsy8jqdp6j3or7h
X-HE-Tag: 1780659121-48684
X-HE-Meta: U2FsdGVkX1+sy6NH8wpzvfGUXyNw5H3NsUJgXtSMqnIx1Xd7U9ZlKhSjEpK0PADZDBEVSUt6PIHfCldMm5Pkmnr1OqIVzBgYWc7LEfIqUPk8W9++gj3wtIg1wNJKNcTgUF/jqjwOmQUVOdi+xOU0Bqmm54JG9Y+D378IZgs6rkAwmmgqG4YItN1JHDhOu6Gdp8VfvGKCS6kCtLE6julISOshnmhBHeFCA7a1cMaGZqqSHtV+z59CgtXVzosSl2TQs7fZCIr+BK8EcIVTzoGcpcSnbFBT4Fx8IyxZ0JsXp506eEYRc8GvWB5zdxm/VvPq8OZT36D+WO1eSLfPBCyIoZizOh8XQwN/SCHK7hjH+Lx/6mrszqHVakx5xSKF/F9ViOQ2QFSx56UK2+fTCT8qdGMmDNGle497vUpi6Hd3MdK7dOBPrlMl53fdtXG6BbNxGV2rJ71m3JkFxye0L8+d4V2Q18NyEBJZrCjAx6AQ0rj9p+lLVw0g54/M70rU2F4JTdAVo6umMRY78vgchONhQ1jHrSyUNOyftNUNHW145S6cilVMUJQJkFdhMYBXw/tdV17AzWHyeCY4xZfVWzYzN9dRFSrGOIg2rydBNmf/xDWzcXMnhBCvbwNCbEH3Svl5prXvkQxYobckXShT3cwJDqXTUl1Tz0YDux4PjPhoDEgjcYeN7KJ3ukNwo6rXyTPLK5LpCzpLhUl2fljP7/wjlttv1X5XTFEFY98aWNkqJkBzBr82ij0O0f9Ckib6SMtPM1HI1TcE38/4NJ2htV4s/bje1TiIrkQrY8caNuYvoxXeoTlndvFhimr0+mu/y6R1OPu48FtIZz9qTgwoqjnqhkD7UDVyeVC9+W4B/usRO/5o09CUiZ6MrV+zHNN0dCFdjbIcog/C6AvlAuDvSMTJqoFp85/s7YeOnYHOqxsRRVbnSRH0+ffvNl0ZuQqfylMUcXpDLoIFGMXxpUdBtaV
 xcK3tR3a
 iJsYJsWFzoppuDM8nMFzS34o5Bu7XSEPIqYeeB2CoBDsNNPAyJ/IFvaFDsiVyFVvXxNUVyiHrbBgiPmrATN+Fqh+y5dqUyupPsyADJzge71ELGg4/D6emxuFl7q2ew/QP23i+v5ieLWRmvGXQcuX7vl2+9w5QOo4bEAPJ0/3guEqbeqSFWp9RXQcYjBkYNonNW5ZWoz8dsXZunqd1+NXcmJ63ksPgsBh5SGpkPGwzYSD20BrmnPLqvh7F/r+cLgPP1b4jvrQh1hX8vNdN246veWQ5o0w47EF+gswungeiQZTw1qwl6XXc9+JpmwZZGd5EOe6ZYB5WjcmxnW9Pkd4XsyfWHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 05:53:06AM +0000, Dev Jain wrote:
> To cover pagemap paths scanning PMD entries, add assertions to check
> whether a device-private PMD entry has the correct pagemap information -
> the PM_SWAP bit must be on in the pagemap entry. Before that, we must
> assert through HMM_DMIRROR_SNAPSHOT snapshot that the leaf entry is
> at PMD level and not PTE level.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

LGTM, and confirmed this triggers the issue locally so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/hmm-tests.c | 34 ++++++++++++++++++++++++--
>  1 file changed, 32 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index e1c8a679a4cf3..46e0c8c921c3d 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -2276,8 +2276,11 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  	unsigned long npages;
>  	unsigned long size;
>  	unsigned long i;
> +	unsigned char *m;
> +	uint64_t entry;
>  	void *old_ptr;
>  	void *map;
> +	int pagemap_fd;
>  	int *ptr;
>  	int ret;
>
> @@ -2300,8 +2303,6 @@ TEST_F(hmm, migrate_anon_huge_fault)
>
>  	npages = size >> self->page_shift;
>  	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
> -	ret = madvise(map, size, MADV_HUGEPAGE);
> -	ASSERT_EQ(ret, 0);
>  	old_ptr = buffer->ptr;
>  	buffer->ptr = map;
>
> @@ -2309,6 +2310,9 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
>  		ptr[i] = i;
>
> +	ret = madvise(map, size, MADV_COLLAPSE);
> +	ASSERT_EQ(ret, 0);
> +
>  	/* Migrate memory to device. */
>  	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
>  	ASSERT_EQ(ret, 0);
> @@ -2318,6 +2322,32 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
>  		ASSERT_EQ(ptr[i], i);
>
> +	if (!hmm_is_coherent_type(variant->device_number)) {
> +		ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT,
> +				      buffer, npages);
> +		ASSERT_EQ(ret, 0);
> +		ASSERT_EQ(buffer->cpages, npages);
> +
> +		m = buffer->mirror;
> +		for (i = 0; i < npages; ++i)
> +			ASSERT_EQ(m[i], HMM_DMIRROR_PROT_DEV_PRIVATE_LOCAL |
> +					HMM_DMIRROR_PROT_WRITE |
> +					HMM_DMIRROR_PROT_PMD);
> +
> +		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +		ASSERT_GE(pagemap_fd, 0);
> +
> +		for (i = 0; i < npages; ++i) {
> +			entry = pagemap_get_entry(pagemap_fd,
> +					(char *)buffer->ptr + i * self->page_size);
> +
> +			ASSERT_NE(entry & PM_SWAP, 0);
> +			ASSERT_FALSE(PAGEMAP_PRESENT(entry));
> +		}
> +
> +		close(pagemap_fd);
> +	}
> +
>  	/* Fault pages back to system memory and check them. */
>  	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
>  		ASSERT_EQ(ptr[i], i);
> --
> 2.43.0
>

