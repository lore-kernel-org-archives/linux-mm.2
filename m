Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70385CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71A476B0272; Fri,  8 May 2026 16:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4346B0273; Fri,  8 May 2026 16:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51DBC6B0274; Fri,  8 May 2026 16:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B9C26B0272
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:06:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6BFD1C0CA3
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:06:45 +0000 (UTC)
X-FDA: 84745335570.12.E03B11A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id CFF8F4000D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:06:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tPFMz45U;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778270804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WcmrKR/ljIRbZ4lTMKj4IGcIl2opGSHLPJ2DzDDXjFI=;
	b=yRlOSQvEFv1uoSC1mjL0oCogdr1+zRZwEnh8RIymWCJIcDawnDysb6B9KrCxWUkvnG4Tro
	Q+uS5Db8/9nHRq4Mk2M5ytuQy1Mv0QPmN0Zm5eCZ/M880Fw2Siog+lq8VVc4K5pRfOC/Nb
	FbvGiUBbJPz+cfSVSulBncoNUJ8JHqs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tPFMz45U;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778270804; a=rsa-sha256;
	cv=none;
	b=EQGVuHC9Hyjhd+RIyrntXKpoP3vH3dnlnHRfwV38Nn0oNodDRwSCFnZyj4AoEs/BZLDcJf
	h8Gi+ipHC60jgb6Ou7sMFr+lyPeWu/fZArZscCUXFFwa0jVBtnnCGJKYcT16txPlDBBP6o
	SEjgUPMht3pEDSvf3Wm7BWnipYNIqHI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B971437FD;
	Fri,  8 May 2026 20:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC31C2BCB0;
	Fri,  8 May 2026 20:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778270802;
	bh=XoKCtDyAsysYM2m56CYbR2tC/u6F2RRr2poVZxR90ck=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tPFMz45UKSMe7D0hay3QxIng4NEIFwlkQ1q2o3Tkwmr9CA7QF7xmAmUow00YVyuGM
	 5rUSOPO0QEXD7rxCm94fLuxJRwxQ1lZ/J+2R7adKl4cgEmPW286BM1VBRXjU+O2bU6
	 gu0aL/aoX77UOAlco1NP+DpMqbLNGWFh7GaL4qN+sRYblJTbHUgNlyUWAPoXHOmGeE
	 7sbCx+Gd72QUU7VeO/bzHmdIA3lodZpvL9q08DeFQ6i5psys2Sy+oSMovJGp8OHCEi
	 oTV/NE4N28YykCcM9Qfe1NBH0W0jyizbupNoiRSXAbXJWp+ZQDrtBwrOdGXAd5fGZ6
	 ezdHNH2iIhdGg==
Message-ID: <959238dd-2493-4d9c-ac35-6d04460a8239@kernel.org>
Date: Fri, 8 May 2026 22:06:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-7-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260429153538.727855-7-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jkkr1rujp31r7deuxty6k4tc514qiiu6
X-Rspamd-Queue-Id: CFF8F4000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778270803-701993
X-HE-Meta: U2FsdGVkX18WixKhg6X5QZvrKrNoSEppVlFwStFCijxOHHGIxHgc9wRt78xtyGQn6QUNeu8pQ9P1JIXUrFIlnMWvOhx4LyD90cgCq6aoPiee5rRWqFxE1hjoSgcTP/Zvk5nyr0ONwIIw0DRmlFbCMzhF/mme0ZpLw6XN2exqs/hvPWBM+NV35npz67wpH0rEBx86eRMZopAuvw8za0LOi1sdQ4f4amupky82+59FTkSnuCSsBECab/uY0RiWnptD/4DXE+DFyqMWbfP6yQvxXNRiCb/tKKuaSHANZaYihTcXj4EZsKQamfCUzhEoinHpIRvTXNOxYiBQ8+ndmObJ2SP8O90mWRvJLmnavD7ID+Ke6U39ERfpurM5AluwveoC1jrjWYXdNOpOj10grqIDlp8ZsAakcrt99VZQd2tfxZ/vYvW3k2wkN5roC9P4crt4VuP7qv5d69i9Y1afOePIhO333YY3J9gW0AIS/HvtBKjTcsYrz33e8mB7gZ3nFeJczfSNHer+Zy7iBO7A4OK3mJ37OW/EJ5eCs+wtc7HROFMtZCkChu9xr7cLls5quoJQzrhcJcglhHF32ogEXUcEsBEsfZ2FhmI/r77f3/tipkHJRpIzx2xwldTorTrJAFzUER3nd4yO7tJcRtgUmcjc+Behva5847U7oZZRIPdX9DNECWX+BV5rOsoBCGFVI7cceTS6l5iRTeJ8g//T6BQrogRfKd0z6OW3XT5LY1o8r+fHQ1NiuOocBQLw3AESMgUqFB5oHEhF7hrFhwJZVKIZ8YOUg+zzYIUlsLcRtnxTPYfUcFam73iYeUfMA0bq0brTkKT1eciJNFAIcpJ6HMidXd0wPR8GnNjQzWQ0LBThHihR3GFjE5ua8Xml6eCzheznm6YqUxi+KBaBIgRXxLOhDHzr0YvSqPQeD5SPZt3HTMN5Jj24tGGho37tW7QTGGyhMqc0N8wnK+8Y6LgYibf
 B6lMGXC3
 tI1r/KFHptBdb0nbIK8chGTypsHJOPipFX6FOq9avDLOzZict/RZvDlxL10zcMrApqNWIMmHxdnUrjrDOj3lAMqlaay7VXlzuuTMnnxLAOD2J18yjH1h/738xW0HkZLRHIQ4PQCAob65kDhwvHFu2fRKfRRgXUPO9bk32HYqwlDhepxj748pUBe44Rz+5nZWDjY85KNU8VVtc5IF2H5v5dfl1+6NdonkNvzpYt5Uy41/5WlXau84JOnD7HtAArI1dcd+kHIwDYzvCZJqBQGdYDsk+Ec4dMDRyaut4yRBXMDGphqF43Zhe6wrsneK6fTD76+gAv+GwqkZSRtg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 17:35, Zi Yan wrote:
> Change the requirement to a file system with large folio support and the
> supported order needs to include PMD_ORDER.
> 
> Also add tests of opening a file with read write permission and populating
> folios with writes. Reuse the XFS image from split_huge_page_test.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++-------
>  tools/testing/selftests/mm/run_vmtests.sh |  12 +-
>  2 files changed, 102 insertions(+), 41 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index a6bb9d50363d2..80b913185c643 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -49,7 +49,8 @@ struct mem_ops {
>  	const char *name;
>  };
>  
> -static struct mem_ops *file_ops;
> +static struct mem_ops *read_only_file_ops;
> +static struct mem_ops *read_write_file_ops;
>  static struct mem_ops *anon_ops;
>  static struct mem_ops *shmem_ops;
>  
> @@ -112,7 +113,8 @@ static void restore_settings(int sig)
>  static void save_settings(void)
>  {
>  	printf("Save THP and khugepaged settings...");
> -	if (file_ops && finfo.type == VMA_FILE)
> +	if ((read_only_file_ops || read_write_file_ops) &&
> +	    finfo.type == VMA_FILE)
>  		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
>  	thp_save_settings();
>  
> @@ -364,11 +366,14 @@ static bool anon_check_huge(void *addr, int nr_hpages)
>  	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
>  }
>  
> -static void *file_setup_area(int nr_hpages)
> +static void *file_setup_area_common(int nr_hpages, bool read_only)
>  {
>  	int fd;
>  	void *p;
>  	unsigned long size;
> +	int open_opt = read_only ? O_RDONLY : O_RDWR;
> +	int mmap_prot = read_only ? PROT_READ : (PROT_READ | PROT_WRITE);
> +	int mmap_opt = read_only ? MAP_PRIVATE : MAP_SHARED;

Can all be const and read better at the very top of the list.

Why do we go from private->shared depending on "read_only" parameter? I'd assume
we'd want to test MAP_SHARED for both (read-only + read-write)?


>  
>  	unlink(finfo.path);  /* Cleanup from previous failed tests */
>  	printf("Creating %s for collapse%s...", finfo.path,
> @@ -399,14 +404,15 @@ static void *file_setup_area(int nr_hpages)
>  	munmap(p, size);
>  	success("OK");
>  
> -	printf("Opening %s read only for collapse...", finfo.path);
> -	finfo.fd = open(finfo.path, O_RDONLY, 777);
> +	printf("Opening %s %s for collapse...", finfo.path,
> +	       read_only ? "read only" : "read-write");

"read-only" ?

> +	finfo.fd = open(finfo.path, open_opt, 777);
>  	if (finfo.fd < 0) {
>  		perror("open()");
>  		exit(EXIT_FAILURE);
>  	}
> -	p = mmap(BASE_ADDR, size, PROT_READ,
> -		 MAP_PRIVATE, finfo.fd, 0);
> +	p = mmap(BASE_ADDR, size, mmap_prot,
> +		 mmap_opt, finfo.fd, 0);

While at it, can fit that into a single line.

>  	if (p == MAP_FAILED || p != BASE_ADDR) {
>  		perror("mmap()");
>  		exit(EXIT_FAILURE);
> @@ -418,6 +424,16 @@ static void *file_setup_area(int nr_hpages)
>  	return p;
>  }
>  
> +static void *file_setup_read_only_area(int nr_hpages)
> +{
> +	return file_setup_area_common(nr_hpages, /* read_only= */ true);
> +}
> +
> +static void *file_setup_read_write_area(int nr_hpages)
> +{
> +	return file_setup_area_common(nr_hpages, /* read_only= */ false);
> +}
> +
>  static void file_cleanup_area(void *p, unsigned long size)
>  {
>  	munmap(p, size);
> @@ -425,14 +441,25 @@ static void file_cleanup_area(void *p, unsigned long size)
>  	unlink(finfo.path);
>  }
>  
> -static void file_fault(void *p, unsigned long start, unsigned long end)
> +static void file_fault_common(void *p, unsigned long start, unsigned long end,
> +		int madv_ops)
>  {
> -	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {
> +	if (madvise(((char *)p) + start, end - start, madv_ops)) {
>  		perror("madvise(MADV_POPULATE_READ");
>  		exit(EXIT_FAILURE);
>  	}
>  }
>  
> +static void file_fault_read(void *p, unsigned long start, unsigned long end)
> +{
> +	file_fault_common(p, start, end, MADV_POPULATE_READ);

Do we really want file_fault_common()? I'd say, just inline it. In particular
avoids checking the madv_ops to figure out the error message ...

> +}
> +
> +static void file_fault_write(void *p, unsigned long start, unsigned long end)
> +{
> +	file_fault_common(p, start, end, MADV_POPULATE_WRITE);
> +}
> +
>  static bool file_check_huge(void *addr, int nr_hpages)
>  {
>  	switch (finfo.type) {
> @@ -488,10 +515,18 @@ static struct mem_ops __anon_ops = {
>  	.name = "anon",
>  };

[...]

>  };
>  
> +static bool is_tmpfs(struct mem_ops *ops)
> +{
> +	return (ops == &__read_only_file_ops ||
> +		ops == &__read_write_file_ops) &&

Can't this fit into two lines?

> +	       finfo.type == VMA_SHMEM;
> +}
> +
> +static bool is_anon(struct mem_ops *ops)
> +{
> +	return ops == &__anon_ops;
> +}
> +
>  static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>  			       struct mem_ops *ops, bool expect)
>  {

> -
>  static void alloc_at_fault(void)
>  {
>  	struct thp_settings settings = *thp_current_settings();
> @@ -1097,8 +1142,8 @@ static void usage(void)
>  	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
>  	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
>  	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
> -	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built with\n");
> -	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
> +	fprintf(stderr, "\n\t\"file,all\" mem_type requires a file system\n");
> +	fprintf(stderr,	"\twith large folio support (order >= PMD order)\n");

"with PMD-sized large folio support"?

>  	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
>  	fprintf(stderr,	"\tmounted with huge=advise option for khugepaged tests to work\n");
>  	fprintf(stderr,	"\n\tSupported Options:\n");
> @@ -1154,20 +1199,22 @@ static void parse_test_type(int argc, char **argv)
>  		usage();
-- 
Cheers,

David

