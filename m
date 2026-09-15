Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24AD9C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BAAC6B008C; Tue, 15 Sep 2026 05:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 191DA6B0095; Tue, 15 Sep 2026 05:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0B66B0096; Tue, 15 Sep 2026 05:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9C736B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:55:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B8B74038B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:55:55 +0000 (UTC)
X-FDA: 85215540270.30.349B48A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 394021C0004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:55:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JE6cUinM;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789466153;
	b=2LsEYPA4V21rZhldQsVKVNIXiqf1D6MJgCoOZKjS2n7/62gJwfP3wVoowg013q15ZgYhvQ
	afxHpStDejqmbbY8rJnj75t4TMxDmFwPyOPFqbfslcOkHpR62l/+LaAr+NMKtnA93Q+9n6
	uM/nB7zW1ccycnm+v7qxg8kGeQkrSS8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JE6cUinM;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789466153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QY48oIyuJ4fkQYXSSUftiW/IIoW2VL/bCYBrazKi6sA=;
	b=6OTZAC1jgxLxJ+QHVteak6ScmZQBouLHedrLT9HQRvwRkr8+uuJqsHzfAWuPFnoGi/buxc
	jxTNT7528c9lUEsac1rRTczz+fV4pJSLNhttKCnJj8DLcjvRyOd1SvGnNoQofqqMv1rWeU
	mfKMmn/KLuA03WtzPdPGnCrUQ81jwZ0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C13372F;
	Tue, 15 Sep 2026 02:55:48 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48EC33F86F;
	Tue, 15 Sep 2026 02:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789466152; bh=EMX0qo0UVNl8ZepEUC0xv4Vnnqu93XsGXG70yuuxNL0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JE6cUinMBVzNN/8G8PAV+q/DwLtm+ojw5bdV9l6TOJOydpHbph85gxXY1F7jFZ4vG
	 /YwhPyNEYiG5oNo2F7+/18eIKpdrhCPCxHVqPbFUphvjwZcnAJ+BP1VPZLpyHZhG4z
	 PFIPbTHfDiKNsqVc7+Nl/mmYxwcXR8PBoZetoyMw=
Date: Tue, 15 Sep 2026 10:55:46 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] kselftest: mm: remove check_huge_shmem()
Message-ID: <aqkWIrqfuHDop8P4@e129823.arm.com>
References: <20260914-fix_split-v6-0-16ed7123800b@arm.com>
 <20260914-fix_split-v6-3-16ed7123800b@arm.com>
 <1be327b0-aec3-4b46-9a96-c701e87d3c3a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1be327b0-aec3-4b46-9a96-c701e87d3c3a@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 394021C0004
X-Stat-Signature: ih98amxnm9wjcbqdbkf6tkzz6h7i1p3n
X-Rspam-User: 
X-HE-Tag: 1789466153-723285
X-HE-Meta: U2FsdGVkX19e10HQbXxt1TvlzZ1O1baVIFsSmMVd94y6U9auvbBRjfiGrRnGz3p6JzAs8OjKVgqWPJaYBrBXniO90SGAieMSNOTjIAzE7ds1Y4mwzZPM1x0fcg5RDTUtni7L8cGvkzCvuo56xPtiY0hNRI3yT2j9r8j3wDP/Rj4QTnWtptPU7hCzuc7r2hTnZ/9cahtEQO+OZpwl1WhobuUMxe8gg44s3/qVcyUernYggCiWrse/qS8FRnySYdxdwi8UN4mCfj68/F98ow4EHewqDpX39zGl83/Pne9OoXlCFTzCyboNYlsspOVGGetZ/1DFvygSy2oOqXVtWhQosNxyKjh8+xDXTenQfN4U5NKRFk/XOOR5VhtGaXrBUbKWwbP0v4X9k71/pH9bYVepQQKxgbRzVV7lrEu286QD4wQZur0mSC8ZUuXoc6DBl73uOzttgw11Rg6g2EjRrIRwJnLEmVqCkQr3+U9vWvfqNR82DQrUDZm5Xm99VblYI1pOsI0iQ+MLaY3/k96GDJJb9YZEQQ0IL17zqRVGPsl5UqwK2Md/GWFV1e3sBvVvx30ZXzBmHMj0HSpkNkehwDfip5jTuX7SJlrGjx2vDKwpRpuQAzz2w9Ji5JU6A0iv9viKzlBA/5CXI9k0FO22aH45Isr+EhWbQjgrEFiO1d9R6YwlnPvlD5JhQIzkR3MiifzPOLRKp4RAbjtFEe9nAHsBCiJUB5pQwVCcGbabUgdfZCHdQg2CmfPlgZrLRb4BB3Kr7r6hbktkygw/aw5nOLlxXO+qEDoepLpWdLk8gl8zhOOvfPsDZm8JWBpoRALBsrxLDkGwCTY+Yaha5uLXOf8XQ2sLP2LNefOZMzt9RLGs39+oWbQfE+SAfyqc78vWjm+JRxShygrQU5SAevF7lwU2Sswln3J9ETovrXNpzyIHj9VaTdb0bVKrkdP4OLws2uhrK4HCJA1OXRNiaFdKDoJ
 bUczmC8k
 6MPbVNKqAbed003j3UVViY2pgNxteENGVn+47WoAaE1vPhUDTL0rGtrhMatuqUVOFgD2j/sCA3bPKRB+VlQSRYn+z9vH1XpnMn5ERLfPuexCFSKtxQ/qr6R7ahuMoWGvLX5O7AavNRug99xYj4ysbiBkuRM4kR9XHQU99tVIrP5z7V53bwVOxF/PmkZOa7+v8o5vfjtq5wdC7JRIfiV67YsD5DuqDA1FuhiR0ZMo4WTKyLuEQWqDaGTbi8Fk7AZeszOkB0Oueh7GBRNpFNtXHZqsf8pEHD8PeeY9kFIlTBw+9ZQyb1VgGShs7TIo9dkd6spzuX4LssfjVEH/yw96d/oPqqsB/aTZUw7Cw7VQM4VnX1qwmJpwoYIqUW4GAgZInzjxTomiQJcDxbRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 04:16:40PM +0200, David Hildenbrand (Arm) wrote:
> On 9/14/26 09:30, Yeoreum Yun wrote:
> > check_huge_shmem() was required to distinguish shmem huge pages because
> > /proc/self/smaps reports them using a dedicated “ShmemPmdMapped” entry,
> > as opposed to “FilePmdMapped” for file-backed huge pages.
> > 
> > Now that /proc/self/smaps is no longer used to detect huge pages and
> > /proc/kpageflags is used instead, it is sufficient to distinguish
> > between file-backed and anonymous pages since the ShmemPmdMapped is also
> > kind of file-backed.
> > 
> > Therefore, remove check_huge_shmem() and use check_huge_file() instead.
> > 
> > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  tools/testing/selftests/mm/folio_split_race_test.c |  2 +-
> >  tools/testing/selftests/mm/khugepaged.c            |  5 ++---
> >  tools/testing/selftests/mm/uffd-common.c           |  4 ++--
> >  tools/testing/selftests/mm/vm_util.c               | 11 +----------
> >  tools/testing/selftests/mm/vm_util.h               |  2 --
> >  5 files changed, 6 insertions(+), 18 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
> > index 1960635a953e..4c0d3b6a411b 100644
> > --- a/tools/testing/selftests/mm/folio_split_race_test.c
> > +++ b/tools/testing/selftests/mm/folio_split_race_test.c
> > @@ -182,7 +182,7 @@ static uint64_t run_iteration(void)
> >  	for (i = 0; i < TOTAL_PAGES; i++)
> >  		fill_page(mmap_base, i);
> >  
> > -	if (!check_huge_shmem(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
> > +	if (!check_huge_file(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
> >  		ksft_exit_fail_msg("No shmem THP is allocated\n");
> >  
> >  	if (pthread_barrier_init(&ctl.barrier, NULL, NUM_READER_THREADS + 1) != 0)
> > diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> > index f82673f5f6b4..6cd1effea465 100644
> > --- a/tools/testing/selftests/mm/khugepaged.c
> > +++ b/tools/testing/selftests/mm/khugepaged.c
> > @@ -416,9 +416,8 @@ static bool file_check_huge(void *addr, size_t len, int nr_hpages,
> >  {
> >  	switch (finfo.type) {
> >  	case VMA_FILE:
> > -		return check_huge_file(addr, len, nr_hpages, hpage_size);
> >  	case VMA_SHMEM:
> > -		return check_huge_shmem(addr, len, nr_hpages, hpage_size);
> > +		return check_huge_file(addr, len, nr_hpages, hpage_size);
> >  	default:
> >  		ksft_exit_fail_msg("Unknown VMA type\n");
> >  		return false;
> 
> 
> Assuming we do:
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index f82673f5f6b47..9542173a748e2 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -53,7 +53,7 @@ struct mem_ops {
>         void *(*setup_area)(int nr_hpages);
>         void (*cleanup_area)(void *p, unsigned long size);
>         void (*fault)(void *p, unsigned long start, unsigned long end);
> -       bool (*check_huge)(void *addr, size_t len, int nr_hpages, unsigned long hpage_size);
> +       bool (*check_huge)(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
>         const char *name;
>  };
> 
> 
> Could we then simply use check_huge_anon/check_huge_file directly and get rid of
> these helpers anon_check_huge + check_huge_file entirely?

Yeap. I'll follow your suggetion. Thanks!

-- 
Sincerely,
Yeoreum Yun

