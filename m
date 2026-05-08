Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61186CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 19:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F716B026F; Fri,  8 May 2026 15:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99AA26B0271; Fri,  8 May 2026 15:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861A56B0272; Fri,  8 May 2026 15:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 69C986B026F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:51:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3122812029C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:51:26 +0000 (UTC)
X-FDA: 84745296972.30.294F095
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 704454000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:51:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V+dzhrei;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778269884; a=rsa-sha256;
	cv=none;
	b=uD6J4mizkqF93Kq8Pe1gPeugJUJmX32R2V8Qf8p9LXCKtBiJ1jXq6oGcdUgbwrNhBYhOxl
	zy6DLj5TypRUFeh59w3tbOZy90JjStANu3v6rtbAdUfa3+syV5GHBX2+7PluZGUhG/jUJL
	TXkjQH0+do3VX+Bg7BXDvZVDxBWB5S8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V+dzhrei;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778269884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/e4Pj0Z+LPDKPd3ICJliqSwu3xNOilHTY6zDI/QJspw=;
	b=SoUEEpJ/efNrTahUKRd8Gz9aY0s3as9KLtNARkmL27DQ+OTzkTLRGu0yq4gxat6iYOeE/w
	t6E4noY+X4Je8nxlz1+3Kl7LjlLBv+gahB2pOC+6jvGCQKbftzlENQqBqnZv69MrV1B6wR
	zp0NJP7PSZ+KiIaIVg0prEQ2C0j59o4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE1F160181;
	Fri,  8 May 2026 19:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA632C2BCC9;
	Fri,  8 May 2026 19:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778269883;
	bh=PfPVaXtOST+42MLwWKjU6/YBt1LpjmZuUVzVH3dWXgc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V+dzhreiEDm5vzRrmxEzK8eVxjtEy8Y1S4z+ehSeoqWFxDzQLKRyyp/XXPTtqNGGD
	 2au6zybgMm3zGs3siVvRCWKQaykwDjDdY75Raf9pol24ze2gejUOTt3vvdLEXOuuLe
	 R3L5MOX9xvNU63nW0Kz2xJmZr4XNkdcxtjGel6FGxiv7q7wD9rx4pHdtB/T2atVAx/
	 oWl7CBGdcKHQyO2izlRGmxpL5l+XRGdPA3WcAoW+zQ1hffiQiXby5rMyO5pe2paWvp
	 p0izb3FQaNLn8kGw7lUEMXZOnkFNWWH4gLU7xlHHpUqPor2w1tvDJejx0x1jc1N6Hp
	 Ri4R6PyBtP2Ow==
Message-ID: <22831162-abe7-4498-9e81-7f5aa3526d00@kernel.org>
Date: Fri, 8 May 2026 21:51:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
To: Zi Yan <ziy@nvidia.com>, Nico Pache <npache@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-7-ziy@nvidia.com>
 <52285e2c-af42-4c0d-9926-017f80b6614c@redhat.com>
 <E2400A6C-C0F8-44FB-B8F8-92B5371737B6@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <E2400A6C-C0F8-44FB-B8F8-92B5371737B6@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b5eqwwgxq4jc1icrsgcdntfgk1ya3kbu
X-Rspam-User: 
X-Rspamd-Queue-Id: 704454000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778269884-302642
X-HE-Meta: U2FsdGVkX195Vz9thgVEFKGNVMw13cJlkkrVpFCLVbtF40Gd9O+J8ks5ZE/fs9KnGOppobisQBiCWGhPrPfPawksoYt1oorHhZS9csK0RqJ1R9StFo9QKuZVSCEwzaYH7EQQyG+kgQqpYc6+x18+lJT24UUmTmbqQI3r8RRwK4hvYqlrcdpPH25tfzy/smxU29VhtlkrO2oWXEK262m3Nzo8hwFzACQ81s7N0qeoWMSXzue81gvbrNSGio/h2BTISoL68dffWmsO6gQzA9sTlsvwl8J5O0eAr//J6mb0ZpTNEfBbrgQcDCJJ/JkHurABb5lPjlaLiBo5OzQZTheLusPtiq4z0YbkG5txXgFQfOo3bJTcf73GyvHjc8J8ec5ZmgxUNBiXiQnGkyFfPvQe2uPr5QqFSAQ3N8WAv5VEiDwt3+2e7eejhaT6rPZUJqfoWsEEet5DS7UN9Z75k6JqoFw8ewF4Bdxjjt/VYv4xiIaT/88yDsQkytU/vYHlR1G6i+dlLTX0QsMZ8P7ld4cLm25COWOYPbf5yaxv+IG7knY1MxUcpESL6E2VenNujh/4Vcuv9A89nGztAoyBx5tlkK9LcOWCnB3yWQ84cL5B8QWuSaManokgxFsaIA8lMvmDXgafbOTvPOBDxPt7Whkj79OOiet7yPgd7S06jxAposj+AsdPoH/Au99HTrcNDNOf3uqRHbMbPuUvumGvyX4pebMQzQu7gnSqnvOC4QNyKT9IkEjbFHK7lQviWTMwUrh0V3oHMj89Bp7UfhbKizqkV6ozhX6Act0aGJjV1dHrIKb7+gz1oUFAjPRwRNyVeldC7hxosjcVcpjrrgkeo1+rnEbzHVt70JER+A0o3fzmGiik9b72MOjyvnlEZ8RAsEJMreZgm+rBZ81dJiZMTFyU1YfyGB4/Bf/ff5oppgu2YxQpGrteDar9d4cuT5wWUJvEByANPvJElZuQyhj5m1a
 gONwJvTT
 b68dfT501rCBUoQFH6zm4M0BZ8fRiFL/qDz8aMNugRSfPnZvphsZfN+USHR2XoAHn83JZ2K2tOfFfmnKYawVm4S2zTNe8ESlCx+xU9LhRkSdzqQdyrWP6XWITn4HbjNznFAocNcX6HKmgNLZbvg2fK0KajuQSXMiHbbbtL5x3kk9q2sz+Vn08bwMfQh2hXbHBqm1BrmyLSsztSQqxaVk4F+sg1z0yIK3HlY8oCVCITIrURkhpTarDY3IsuuZ5XIosnaXD+j7qL4naMofRZMaa2qySfSoSemAJr/UAZDdZz0mmIXGb4FYgRSA8DXy6RBI/fGWXPM15hx76GNo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/6/26 15:11, Zi Yan wrote:
> On 4 May 2026, at 12:23, Nico Pache wrote:
> 
>> On 4/29/26 9:35 AM, Zi Yan wrote:
>>> Change the requirement to a file system with large folio support and the
>>> supported order needs to include PMD_ORDER.
>>>
>>> Also add tests of opening a file with read write permission and populating
>>> folios with writes. Reuse the XFS image from split_huge_page_test.
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>   tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++-------
>>>   tools/testing/selftests/mm/run_vmtests.sh |  12 +-
>>>   2 files changed, 102 insertions(+), 41 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
>>> index a6bb9d50363d2..80b913185c643 100644
>>> --- a/tools/testing/selftests/mm/khugepaged.c
>>> +++ b/tools/testing/selftests/mm/khugepaged.c
>>> @@ -49,7 +49,8 @@ struct mem_ops {
>>>   	const char *name;
>>>   };
>>>  -static struct mem_ops *file_ops;
>>> +static struct mem_ops *read_only_file_ops;
>>> +static struct mem_ops *read_write_file_ops;
>>>   static struct mem_ops *anon_ops;
>>>   static struct mem_ops *shmem_ops;
>>>  @@ -112,7 +113,8 @@ static void restore_settings(int sig)
>>>   static void save_settings(void)
>>>   {
>>>   	printf("Save THP and khugepaged settings...");
>>> -	if (file_ops && finfo.type == VMA_FILE)
>>> +	if ((read_only_file_ops || read_write_file_ops) &&
>>> +	    finfo.type == VMA_FILE)
>>>   		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
>>>   	thp_save_settings();
>>>  @@ -364,11 +366,14 @@ static bool anon_check_huge(void *addr, int nr_hpages)
>>>   	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
>>>   }
>>>  -static void *file_setup_area(int nr_hpages)
>>> +static void *file_setup_area_common(int nr_hpages, bool read_only)
>>>   {
>>>   	int fd;
>>>   	void *p;
>>>   	unsigned long size;
>>> +	int open_opt = read_only ? O_RDONLY : O_RDWR;
>>> +	int mmap_prot = read_only ? PROT_READ : (PROT_READ | PROT_WRITE);
>>> +	int mmap_opt = read_only ? MAP_PRIVATE : MAP_SHARED;
>>>    	unlink(finfo.path);  /* Cleanup from previous failed tests */
>>>   	printf("Creating %s for collapse%s...", finfo.path,
>>> @@ -399,14 +404,15 @@ static void *file_setup_area(int nr_hpages)
>>>   	munmap(p, size);
>>>   	success("OK");
>>>  -	printf("Opening %s read only for collapse...", finfo.path);
>>> -	finfo.fd = open(finfo.path, O_RDONLY, 777);
>>> +	printf("Opening %s %s for collapse...", finfo.path,
>>> +	       read_only ? "read only" : "read-write");
>>> +	finfo.fd = open(finfo.path, open_opt, 777);
>>>   	if (finfo.fd < 0) {
>>>   		perror("open()");
>>>   		exit(EXIT_FAILURE);
>>>   	}
>>> -	p = mmap(BASE_ADDR, size, PROT_READ,
>>> -		 MAP_PRIVATE, finfo.fd, 0);
>>> +	p = mmap(BASE_ADDR, size, mmap_prot,
>>> +		 mmap_opt, finfo.fd, 0);
>>>   	if (p == MAP_FAILED || p != BASE_ADDR) {
>>>   		perror("mmap()");
>>>   		exit(EXIT_FAILURE);
>>> @@ -418,6 +424,16 @@ static void *file_setup_area(int nr_hpages)
>>>   	return p;
>>>   }
>>>  +static void *file_setup_read_only_area(int nr_hpages)
>>> +{
>>> +	return file_setup_area_common(nr_hpages, /* read_only= */ true);
>>> +}
>>> +
>>> +static void *file_setup_read_write_area(int nr_hpages)
>>> +{
>>> +	return file_setup_area_common(nr_hpages, /* read_only= */ false);
>>> +}
>>> +
>>>   static void file_cleanup_area(void *p, unsigned long size)
>>>   {
>>>   	munmap(p, size);
>>> @@ -425,14 +441,25 @@ static void file_cleanup_area(void *p, unsigned long size)
>>>   	unlink(finfo.path);
>>>   }
>>>  -static void file_fault(void *p, unsigned long start, unsigned long end)
>>> +static void file_fault_common(void *p, unsigned long start, unsigned long end,
>>> +		int madv_ops)
>>>   {
>>> -	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {
>>> +	if (madvise(((char *)p) + start, end - start, madv_ops)) {
>>>   		perror("madvise(MADV_POPULATE_READ");
>>>   		exit(EXIT_FAILURE);
>>>   	}
>>>   }
>>>  +static void file_fault_read(void *p, unsigned long start, unsigned long end)
>>> +{
>>> +	file_fault_common(p, start, end, MADV_POPULATE_READ);
>>> +}
>>> +
>>> +static void file_fault_write(void *p, unsigned long start, unsigned long end)
>>> +{
>>> +	file_fault_common(p, start, end, MADV_POPULATE_WRITE);
>>> +}
>>> +
>>>   static bool file_check_huge(void *addr, int nr_hpages)
>>>   {
>>>   	switch (finfo.type) {
>>> @@ -488,10 +515,18 @@ static struct mem_ops __anon_ops = {
>>>   	.name = "anon",
>>>   };
>>>  -static struct mem_ops __file_ops = {
>>> -	.setup_area = &file_setup_area,
>>> +static struct mem_ops __read_only_file_ops = {
>>> +	.setup_area = &file_setup_read_only_area,
>>>   	.cleanup_area = &file_cleanup_area,
>>> -	.fault = &file_fault,
>>> +	.fault = &file_fault_read,
>>> +	.check_huge = &file_check_huge,
>>> +	.name = "file",
>>> +};
>>> +
>>> +static struct mem_ops __read_write_file_ops = {
>>> +	.setup_area = &file_setup_read_write_area,
>>> +	.cleanup_area = &file_cleanup_area,
>>> +	.fault = &file_fault_write,
>>>   	.check_huge = &file_check_huge,
>>>   	.name = "file",
>>>   };
>>> @@ -504,6 +539,18 @@ static struct mem_ops __shmem_ops = {
>>>   	.name = "shmem",
>>>   };
>>>  +static bool is_tmpfs(struct mem_ops *ops)
>>> +{
>>> +	return (ops == &__read_only_file_ops ||
>>> +		ops == &__read_write_file_ops) &&
>>> +	       finfo.type == VMA_SHMEM;
>>> +}
>>> +
>>> +static bool is_anon(struct mem_ops *ops)
>>> +{
>>> +	return ops == &__anon_ops;
>>> +}
>>> +
>>>   static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>>>   			       struct mem_ops *ops, bool expect)
>>>   {
>>> @@ -512,6 +559,10 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>>>    	printf("%s...", msg);
>>>  +	/* read&write file collapse always fail */
>>
>> Just to confirm, you are adding the write part here so that before commit 13 & 14, the behavior is that it will fail. Whereas after with patch 13/14, we expect this behavior to be supported correct?
> Yes.

Confusing, we usually add new test after adding new functionality, not the other
way around? :)

-- 
Cheers,

David

