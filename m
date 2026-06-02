Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C1B4C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 686766B0488; Tue,  2 Jun 2026 00:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6366B6B048B; Tue,  2 Jun 2026 00:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525166B048D; Tue,  2 Jun 2026 00:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7ED6B0488
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:21:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D878F14067A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:21:24 +0000 (UTC)
X-FDA: 84833673288.06.310C7DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4B45D180003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:21:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tpqk5/rq";
	spf=pass (imf16.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780374083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FG6uaynttx+7wL75om2XoMHvK6wM5vAOEXDW7jnm7sE=;
	b=hftQhTYdL1T/Ya8QqVq5OIfR+1QeroRA79YXUiuRn4fCaXJQMRQGyjVaGa959UplaqJWVT
	FdMbahUltNtKuHbCrYKsjsacC2+ilz+HK1m7g1JWiB+dBrGFuxHql97pnGMPmDKFMCCI6T
	GIHrWtqv5aYSAGYlL7wb96Eo9F2WsQU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tpqk5/rq";
	spf=pass (imf16.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780374083;
	b=BNGs6E+YxMpoBMzjigHw7m1P51ztcFr7u5lvk08YKUBNhePrVnTZ4O3AmL1GbfB2Q/Ozkg
	0qEvrv/RTU3xQiEC1n9GPN0ShDGImj0e/Go/P8PxpCcMMT7yyLbpgyLb1LLBj5bBJVrDX/
	X+yNoOkgEvB+S2wcRhGGcBDJJaxnqAM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC8556001A;
	Tue,  2 Jun 2026 04:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4351F00893;
	Tue,  2 Jun 2026 04:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780374082;
	bh=FG6uaynttx+7wL75om2XoMHvK6wM5vAOEXDW7jnm7sE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Tpqk5/rqismZ1mVczwfr+hex8navjFRtNT0GQdQ+HL8MmufzKlsGp2JNqYb1PgVLg
	 tpeRX80+x+GwnujKarHY8k97sZSSJ5Y29Oka3hY/ApvhdWUUTcnYvDQI8ylGoYkCJ7
	 7G7M7+Yv627VnZqwvJJbpuX7fdkb5mj+N/MkoY2DxHlxHLm6hRcy1uVRBQwQ71TC33
	 DzEOH/c5EPU7OfNuGfMAaQ3cK++DKIVhYjkjbVxXEMRnR7a5v/6mDWphe9rLV1Iqoi
	 4uxzTGNruCd1kecpId37rMNDYPtUfdn61JqBbDPv+2SzQ1PkUdnbVMentg7sInUfbt
	 BeouJ7KXMBo6A==
Date: Tue, 2 Jun 2026 06:21:14 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org,
	jgg@ziepe.ca, leon@kernel.org, david@kernel.org, shuah@kernel.org,
	vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	balbirs@nvidia.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: do not warn on seeing non-migration
 pmd entry
Message-ID: <ah5aOoroOs2FpLhr@localhost.localdomain>
References: <20260529111704.1078346-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529111704.1078346-1-dev.jain@arm.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4B45D180003
X-Stat-Signature: zzeyuh9xn7obaxuf11t343tzjp89ntdt
X-Rspam-User: 
X-HE-Tag: 1780374083-926718
X-HE-Meta: U2FsdGVkX1/APKYak2j4OpOoRag6ZLRjrXDByrrKRMI+iGJJ18TDJX0Qbe3x+QgaDvnpt86qcbQ8Jrre/6EqmxDnBy82+ZfqVAIsan2l950j3AZI/FpSNaZL73V2h0a1YsO0QZDX/DibxTsrGyj+sAs2UGGMncoxmUAvPZ3kJssNjuBVorOHH4lTGj1tUzRVwBtRcM5Z2QYh5EH6czHpr4acVNovDI4K5wpZKniXamXXUvFOrgK4aGIUkSF00JdjbHuIx2nhEWEEY47K1pe84UdJweZbzePWCyWp1h7n5yViNMgHbfhtcwxrDOJBIWcq+Ng2zT7Rvhhk0UbS11h6hXb4fnMEY4nRtmkO66ZimoijBgO0FPNzr4EEB3dYxs91NL0NL7faodi0F2Tl3kWvsQHqBXO+islUQnSjKBw8njfrWZvXesZ2lr5ysYx5+sbrDXynGHfDwdLLzceGhqsdPQx2Eisbqyqb2edneAhxAQrUloZiyj18jZhfnx24+6Yp/p5860se1GjuYCHqYT/7Eod6/bz91bnUmCllyO59DNAQew5+0GGP0u89/Io+mdVlvFF3NuuYjPDt1rUWaQaMeXxNHfiFMX+U2A12wHP5DP2FQ4hkwVjeuQ49DWUOk1zAM35vl/uRHvljnjKOP2DD33VUJHjzvTt5SDBmLhbarP8uUq5urjAdTtdVyJRthko4B94rKO1RjHGPFbGf9KDnSRaDjNkSVrNfVAMlFkhv+jFV5A1kL3k9DaCPgf5uEM/qJm4SJ40t9Go8agc19g/9m9foJtKshKZoe/upMo2S0obsHP1rXVlwX1JkXmIWTA+6gRJ6/x3O7g/WoFCVdpUmyLIH2zs7qOhQcDkIdpi4PIpPhrhZ8lkQRAC7Ev+9wRCgFFpnNFTw8DUcMYBpRk7Wn9zW7PS12aQJkmcDTFvtukIjKNmgWb6Abd6eLWzMbb1lv6qEtiMWqKy1m/VlIn6
 M9EZ5qi/
 Zs5XERFgmC58rUP3I6PkVFtFfYjfMBhpay7wKmqVOs1eZ1gxxZ2QWkUanfPnvdw20RW3fsJQ8lIQ4DTjRc5NihhAsp4DNkUigIzypF2WZJAU4Zd7KKXaLL+3OmH9Bx78E53r3k8sn9b+FzAHqQFlMJvOVVxfWSPMOJoPH4de4mmjTZxKNRHNuywWG1sh7TZ0IzqX8iHUCM5mq3A9h7wpWndSuCmKBf7NK1WLgEv9k0eX4JGqkpBDN06UMi/AABX9hBvnax8fFg5C6pO9rtjxdn0/oq/l4QP1grqoI7hz+9DMgqObufNvQxapzc7Zo61P2vENnvII3QkFDiXy8ExahSCn8eGrqngvTGCGWtwy6F2opMHKMqAsBiecCBvtLNVUDHhRz0RkM7U0HyAo=
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
> 
> 
> Therefore, remove the stale migration-only assertion.
> 
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dev Jain <dev.jain@arm.com>

LGTM,

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>



-- 
Oscar Salvador
SUSE Labs

