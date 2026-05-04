Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E02DFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 10:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 827BF6B0098; Mon,  4 May 2026 06:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DBA36B009B; Mon,  4 May 2026 06:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F18F6B009D; Mon,  4 May 2026 06:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5156B0098
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:11:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00E3C120491
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:11:04 +0000 (UTC)
X-FDA: 84729319290.25.8D74205
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id AE865C0014
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:11:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eIA0xtYF;
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777889462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=81kZB1lQDdoEwhatA9igFuYifA9DMVlrGv5S79TABrk=;
	b=EmxbMlYwessB2xjZGgNg30EKbDByVU/tIoIjBFMo9LET8LSST1jxrkTTzjBmLiDL0uJU89
	O8EAAc8cTwCIZTubdTcwA9aPPSshfzAP8MW1Icxa2WPAWHg49T8HixzbNcgcJIcHe+e3wt
	m4ke1FO1Ltq9I79LkjrG3G9duRebdY8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eIA0xtYF;
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777889462; a=rsa-sha256;
	cv=none;
	b=Lifekl3OvK6AT7G+LkS08MH/u1a4lCIZEMnGp5nyHeAK3HuRwA76Crpqmy1mY+ASB4vpn8
	f9g6swebp1ynW09K1vqyHd3BBZPMh9yyMxNmUULBBUzUSx+xLSXzKCLhDX8Nvz8+Y2kfcm
	Rvwfm9uWoQ6asTO+PW5LRBLBYAuPt2c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777889462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=81kZB1lQDdoEwhatA9igFuYifA9DMVlrGv5S79TABrk=;
	b=eIA0xtYF2RYOhax6fP8bAg11jX8ozzbyqmxGucKn0M7kPtduKHVEtzN9Pg6+VuhaUtNqX2
	BWXloxO/9GyfMdFDr0p/iyEzBsWGdzy2cDDQlfS0820gV49vkONiZWVUlWWalXu+QVcHJG
	ZygqcqvYNDaZFPL3ktpWVnqDeowa9Qk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-yiWT_fu1P0CngdV90sbxkA-1; Mon, 04 May 2026 06:10:58 -0400
X-MC-Unique: yiWT_fu1P0CngdV90sbxkA-1
X-Mimecast-MFC-AGG-ID: yiWT_fu1P0CngdV90sbxkA_1777889458
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-44bf1ac8893so1705253f8f.0
        for <linux-mm@kvack.org>; Mon, 04 May 2026 03:10:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777889457; x=1778494257;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=81kZB1lQDdoEwhatA9igFuYifA9DMVlrGv5S79TABrk=;
        b=oMDmEka4AISgob/HBnsJr8ksScbivWEzzZK8+FxW8urBP41TYgQQpd7JEsVwrv72GJ
         YmsvSOxSn7yFsV16QWD4mXSOposxuT1Ds+g12A4SS7rqKmIWh8A77lltJOsGjJEF8cDW
         V4j7y/+bcH7gm4S5LhIF81x0XOwROK0N06Apu9WbYKutlq+Gfacpa44OxtfC8eckVVDu
         6nYVMBlcnXGE4baY/mA9pthS8hxP2N6sXzjhG9awwtdWqpTNB9Tj/cx+8e3Og5NJ0e8v
         mPeZBFNVjSz1m81Jzlu4wRvG0MA5aBDnY14H6RYECzfIQHO2NANRPLTt3QobmePoKAhv
         chjA==
X-Forwarded-Encrypted: i=1; AFNElJ+lXSPX5tBpSMuNRze/F9qLtRfbbSYswB86d/kWxjgkxLTGldFiNSoe5zJ1B3kWRoOuvcqETqtMag==@kvack.org
X-Gm-Message-State: AOJu0YyhxXkaREhmnMlox7T9YgdRJ2/btCT1ARC83NMh8AGrojb7cL4l
	uTUHrJDFEmyqcudBAFVGq3z+6wClNwaRNogRPp5b6WQZE6hM6v99g9ao+rCz+t/7tcgqhk8B3a7
	yCDWTP2cbyCFxVaeO6G3tWlhlnqWYxHbU3+p9WQK0kvL6SgmVMgJo
X-Gm-Gg: AeBDiesHgVLm2vKYZlam7gJvIEhWmYe0qQ7sLCxV1kD941gwliQjYn1PfCRhV19sgYR
	HtlrlnZXc/uHab8b6vdeajwRimH5H8jUv7cRvg7J0qdly3Zm6WdNueJR6QmXcB8P1nQb31jt/Jd
	ljCskh96FOJmxteBtgbc0AOHshiD/XBe60EsQ3JAswnp72s6jM/z00lYbgiPAVrZgQrhR1bZ/w6
	sIZ6Us9XghhBL+mcoZl3gBOBemn4yD8AGQWLrEvV1ZaCDAWcpJf5LwHCw+iHwdzw30dpDdl63eS
	jIaqBS7vjtCp+4r39C0YUr6NLW7YEM8XafM0gjqwN1+Tuzkzm5n0cbEBzhUjwl7qDd9Mx9h5bZG
	8K79c22nHJzfzmun41aeQadgmihd6zqPl
X-Received: by 2002:a05:6000:22c4:b0:441:36b7:725f with SMTP id ffacd0b85a97d-44bb33f1b4emr15775219f8f.5.1777889457459;
        Mon, 04 May 2026 03:10:57 -0700 (PDT)
X-Received: by 2002:a05:6000:22c4:b0:441:36b7:725f with SMTP id ffacd0b85a97d-44bb33f1b4emr15775159f8f.5.1777889456963;
        Mon, 04 May 2026 03:10:56 -0700 (PDT)
Received: from [10.211.10.91] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a8ea7cf6asm25084303f8f.8.2026.05.04.03.10.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 03:10:54 -0700 (PDT)
Message-ID: <7e42faea-9f55-4722-a426-94be7fc3a49b@redhat.com>
Date: Mon, 4 May 2026 04:11:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
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
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260429153538.727855-7-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aE_ah40QRAARGV2dXQUZW8c4HHoS-lLTgNLAVx9Nq9E_1777889458
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE865C0014
X-Stat-Signature: zc97iis68x3i3bqe7xwwqwrst8xd4fpj
X-HE-Tag: 1777889462-753777
X-HE-Meta: U2FsdGVkX186PNXRRVgmIyOCeaJD3BUZlXG0KWG3NV+2i+7xD5aqYXkRrbChdCedChne6dAbilt6chHVy3ooZ6D4nFgoFTyD12IO1JIbPqt0RGDosxqnAbiOTVgBP4PCZtwThdgIIYNfWunN/h0qmIzafNW98Kd5FrOOgU7Yb4t+RY4Ro7cvsKxaUc6HZ0eWJsyF52lx72RExa5LwEcTlDSiJmJEz6ZqfbSOM2QTV97ToHQINxgprMBhdgFmYIpG6CD5KTyQd7TgrTUD9iSn7M33DLOD48V+TaGSIc63kt1r0omuQYvwFpS6Y5x/yoyho5sFN2SjX7bq6kavrDk36q/2NappXoc84aGveudO+GOgvru0WSWX6j17wfWoC2UfcV0d2ExY4BA2U6015m6AZ8TXo9yGFDmar9BdmuFhhX1nQkQv0LD7f3aVKiZzjLGgMKARPC8FxGqsmoNR8Hf/n6uf2bWpHEnkeQYhPHrcgiFiPW8OYS1BrqM0nHcbp+bi5dMgjFIxwIBBYSCfB4TXsGF3YgEWemcUn0BTTAZ6Uit4WE2tzFjqCDxnLPVMH7QwQcd2K7Pe2bMof7VIoqJUU2UDuGs+tE0h4HctdAkCYG8k7NWSE7LpBU1XwRjxU1Bqn2fwcxknJOlwVDD72+p8oJNI3MxGDrS8emjUaDmN8jTW/zdsXi36nAmTQfpizRuIEa4nzLuhRhK5Nkgv/n53qnpZFXZamvDROAKcOnsCo6BV122p5Qzg4bOkTnVChfRva/NcL8MEuzxZBMn+xL50MXNBgQJrgKJ34777pX5/6/KWhSqpC5r0CKQdayv+6C0wgKhBPMcAwdFVUcWy1V6a9czU6M6bY0SnJo63hlUrBDot/X2Y5oB+BzCbPRE+lAfawcDDXRzhVCT1H+GlJOsBEEBT1xe3WoqQ5eh04hH/3ilNO6jHlhBIMgf4wqvWb3MsF2XDyt3nZplCm22e3D+
 Rpo73qyP
 QFqb78xdLyUhJGfQVIOGfGvIo563tXYnuNmDJkbzYAH7e9S3FWt1uabwL2e2Fk07YJ8PMO0alCv0QvzRQUV8yZT1um8XM91CVvWLlI48nWk630LGSGhaPhRB3IAHEZoSOQ/kAHpadNmwDACEr70JFbD/s5bwnvEZk7093A41Qiqpy7duQXtjHDXt7uVu+BTGkyjCQPj07+3supILk4hynT4UL2PIoaSptzWllNgKQ+Yi2ylfRKqEAbXrbjnbiO+VHwrBKMw8VR9ZCCZ91h9NnVbieKBqA/qXNQGlo/bRN0EFbETDv5HV14K7ByJilHHSiATNvhLop+vFpL5pzX2uLTjGiVbG4XTpa9mINTZim932F5f0G3TxvDpU4Fofv4gJDNMfMtyn8mzOEOI8lsI+m+MInbQDP4nR1zUBd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 9:35 AM, Zi Yan wrote:
> Change the requirement to a file system with large folio support and the
> supported order needs to include PMD_ORDER.
> 
> Also add tests of opening a file with read write permission and populating
> folios with writes. Reuse the XFS image from split_huge_page_test.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++-------
>   tools/testing/selftests/mm/run_vmtests.sh |  12 +-
>   2 files changed, 102 insertions(+), 41 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index a6bb9d50363d2..80b913185c643 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -49,7 +49,8 @@ struct mem_ops {
>   	const char *name;
>   };
>   
> -static struct mem_ops *file_ops;
> +static struct mem_ops *read_only_file_ops;
> +static struct mem_ops *read_write_file_ops;
>   static struct mem_ops *anon_ops;
>   static struct mem_ops *shmem_ops;
>   
> @@ -112,7 +113,8 @@ static void restore_settings(int sig)
>   static void save_settings(void)
>   {
>   	printf("Save THP and khugepaged settings...");
> -	if (file_ops && finfo.type == VMA_FILE)
> +	if ((read_only_file_ops || read_write_file_ops) &&
> +	    finfo.type == VMA_FILE)
>   		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
>   	thp_save_settings();
>   
> @@ -364,11 +366,14 @@ static bool anon_check_huge(void *addr, int nr_hpages)
>   	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
>   }
>   
> -static void *file_setup_area(int nr_hpages)
> +static void *file_setup_area_common(int nr_hpages, bool read_only)
>   {
>   	int fd;
>   	void *p;
>   	unsigned long size;
> +	int open_opt = read_only ? O_RDONLY : O_RDWR;
> +	int mmap_prot = read_only ? PROT_READ : (PROT_READ | PROT_WRITE);
> +	int mmap_opt = read_only ? MAP_PRIVATE : MAP_SHARED;
>   
>   	unlink(finfo.path);  /* Cleanup from previous failed tests */
>   	printf("Creating %s for collapse%s...", finfo.path,
> @@ -399,14 +404,15 @@ static void *file_setup_area(int nr_hpages)
>   	munmap(p, size);
>   	success("OK");
>   
> -	printf("Opening %s read only for collapse...", finfo.path);
> -	finfo.fd = open(finfo.path, O_RDONLY, 777);
> +	printf("Opening %s %s for collapse...", finfo.path,
> +	       read_only ? "read only" : "read-write");
> +	finfo.fd = open(finfo.path, open_opt, 777);
>   	if (finfo.fd < 0) {
>   		perror("open()");
>   		exit(EXIT_FAILURE);
>   	}
> -	p = mmap(BASE_ADDR, size, PROT_READ,
> -		 MAP_PRIVATE, finfo.fd, 0);
> +	p = mmap(BASE_ADDR, size, mmap_prot,
> +		 mmap_opt, finfo.fd, 0);
>   	if (p == MAP_FAILED || p != BASE_ADDR) {
>   		perror("mmap()");
>   		exit(EXIT_FAILURE);
> @@ -418,6 +424,16 @@ static void *file_setup_area(int nr_hpages)
>   	return p;
>   }
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
>   static void file_cleanup_area(void *p, unsigned long size)
>   {
>   	munmap(p, size);
> @@ -425,14 +441,25 @@ static void file_cleanup_area(void *p, unsigned long size)
>   	unlink(finfo.path);
>   }
>   
> -static void file_fault(void *p, unsigned long start, unsigned long end)
> +static void file_fault_common(void *p, unsigned long start, unsigned long end,
> +		int madv_ops)
>   {
> -	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {
> +	if (madvise(((char *)p) + start, end - start, madv_ops)) {
>   		perror("madvise(MADV_POPULATE_READ");
>   		exit(EXIT_FAILURE);
>   	}
>   }
>   
> +static void file_fault_read(void *p, unsigned long start, unsigned long end)
> +{
> +	file_fault_common(p, start, end, MADV_POPULATE_READ);
> +}
> +
> +static void file_fault_write(void *p, unsigned long start, unsigned long end)
> +{
> +	file_fault_common(p, start, end, MADV_POPULATE_WRITE);
> +}
> +
>   static bool file_check_huge(void *addr, int nr_hpages)
>   {
>   	switch (finfo.type) {
> @@ -488,10 +515,18 @@ static struct mem_ops __anon_ops = {
>   	.name = "anon",
>   };
>   
> -static struct mem_ops __file_ops = {
> -	.setup_area = &file_setup_area,
> +static struct mem_ops __read_only_file_ops = {
> +	.setup_area = &file_setup_read_only_area,
>   	.cleanup_area = &file_cleanup_area,
> -	.fault = &file_fault,
> +	.fault = &file_fault_read,
> +	.check_huge = &file_check_huge,
> +	.name = "file",
> +};
> +
> +static struct mem_ops __read_write_file_ops = {
> +	.setup_area = &file_setup_read_write_area,
> +	.cleanup_area = &file_cleanup_area,
> +	.fault = &file_fault_write,
>   	.check_huge = &file_check_huge,
>   	.name = "file",
>   };
> @@ -504,6 +539,18 @@ static struct mem_ops __shmem_ops = {
>   	.name = "shmem",
>   };
>   
> +static bool is_tmpfs(struct mem_ops *ops)
> +{
> +	return (ops == &__read_only_file_ops ||
> +		ops == &__read_write_file_ops) &&
> +	       finfo.type == VMA_SHMEM;
> +}
> +
> +static bool is_anon(struct mem_ops *ops)
> +{
> +	return ops == &__anon_ops;
> +}
> +
>   static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>   			       struct mem_ops *ops, bool expect)
>   {
> @@ -512,6 +559,10 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>   
>   	printf("%s...", msg);
>   
> +	/* read&write file collapse always fail */
> +	if (!is_tmpfs(ops) && ops == &__read_write_file_ops)
> +		expect = false;
> +
>   	/*
>   	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
>   	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
> @@ -578,6 +629,10 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
>   static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
>   				struct mem_ops *ops, bool expect)
>   {
> +	/* read&write file collapse always fail */
> +	if (!is_tmpfs(ops) && ops == &__read_write_file_ops)
> +		expect = false;
> +
>   	if (wait_for_scan(msg, p, nr_hpages, ops)) {
>   		if (expect)
>   			fail("Timeout");
> @@ -612,16 +667,6 @@ static struct collapse_context __madvise_context = {
>   	.name = "madvise",
>   };
>   
> -static bool is_tmpfs(struct mem_ops *ops)
> -{
> -	return ops == &__file_ops && finfo.type == VMA_SHMEM;
> -}
> -
> -static bool is_anon(struct mem_ops *ops)
> -{
> -	return ops == &__anon_ops;
> -}
> -
>   static void alloc_at_fault(void)
>   {
>   	struct thp_settings settings = *thp_current_settings();
> @@ -1097,8 +1142,8 @@ static void usage(void)
>   	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
>   	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
>   	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
> -	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built with\n");
> -	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
> +	fprintf(stderr, "\n\t\"file,all\" mem_type requires a file system\n");
> +	fprintf(stderr,	"\twith large folio support (order >= PMD order)\n");
>   	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
>   	fprintf(stderr,	"\tmounted with huge=advise option for khugepaged tests to work\n");
>   	fprintf(stderr,	"\n\tSupported Options:\n");
> @@ -1154,20 +1199,22 @@ static void parse_test_type(int argc, char **argv)
>   		usage();
>   
>   	if (!strcmp(buf, "all")) {
> -		file_ops =  &__file_ops;
> +		read_only_file_ops =  &__read_only_file_ops;
> +		read_write_file_ops =  &__read_write_file_ops;
>   		anon_ops = &__anon_ops;
>   		shmem_ops = &__shmem_ops;
>   	} else if (!strcmp(buf, "anon")) {
>   		anon_ops = &__anon_ops;
>   	} else if (!strcmp(buf, "file")) {
> -		file_ops =  &__file_ops;
> +		read_only_file_ops =  &__read_only_file_ops;
> +		read_write_file_ops =  &__read_write_file_ops;
>   	} else if (!strcmp(buf, "shmem")) {
>   		shmem_ops = &__shmem_ops;
>   	} else {
>   		usage();
>   	}
>   
> -	if (!file_ops)
> +	if (!read_only_file_ops && !read_write_file_ops)
>   		return;
>   
>   	if (argc != 2)
> @@ -1239,37 +1286,43 @@ int main(int argc, char **argv)
>   	} while (0)
>   
>   	TEST(collapse_full, khugepaged_context, anon_ops);
> -	TEST(collapse_full, khugepaged_context, file_ops);
> +	TEST(collapse_full, khugepaged_context, read_only_file_ops);
> +	TEST(collapse_full, khugepaged_context, read_write_file_ops);
>   	TEST(collapse_full, khugepaged_context, shmem_ops);
>   	TEST(collapse_full, madvise_context, anon_ops);
> -	TEST(collapse_full, madvise_context, file_ops);
> +	TEST(collapse_full, madvise_context, read_only_file_ops);
> +	TEST(collapse_full, madvise_context, read_write_file_ops);
>   	TEST(collapse_full, madvise_context, shmem_ops);
>   
>   	TEST(collapse_empty, khugepaged_context, anon_ops);
>   	TEST(collapse_empty, madvise_context, anon_ops);
>   
>   	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
> -	TEST(collapse_single_pte_entry, khugepaged_context, file_ops);
> +	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
> +	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_ops);
>   	TEST(collapse_single_pte_entry, khugepaged_context, shmem_ops);
>   	TEST(collapse_single_pte_entry, madvise_context, anon_ops);
> -	TEST(collapse_single_pte_entry, madvise_context, file_ops);
> +	TEST(collapse_single_pte_entry, madvise_context, read_only_file_ops);
> +	TEST(collapse_single_pte_entry, madvise_context, read_write_file_ops);
>   	TEST(collapse_single_pte_entry, madvise_context, shmem_ops);
>   
>   	TEST(collapse_max_ptes_none, khugepaged_context, anon_ops);
> -	TEST(collapse_max_ptes_none, khugepaged_context, file_ops);
> +	TEST(collapse_max_ptes_none, khugepaged_context, read_only_file_ops);
> +	TEST(collapse_max_ptes_none, khugepaged_context, read_write_file_ops);
>   	TEST(collapse_max_ptes_none, madvise_context, anon_ops);
> -	TEST(collapse_max_ptes_none, madvise_context, file_ops);
> +	TEST(collapse_max_ptes_none, madvise_context, read_only_file_ops);
> +	TEST(collapse_max_ptes_none, madvise_context, read_write_file_ops);
>   
>   	TEST(collapse_single_pte_entry_compound, khugepaged_context, anon_ops);
> -	TEST(collapse_single_pte_entry_compound, khugepaged_context, file_ops);
> +	TEST(collapse_single_pte_entry_compound, khugepaged_context, read_only_file_ops);
>   	TEST(collapse_single_pte_entry_compound, madvise_context, anon_ops);
> -	TEST(collapse_single_pte_entry_compound, madvise_context, file_ops);
> +	TEST(collapse_single_pte_entry_compound, madvise_context, read_only_file_ops);
>   
>   	TEST(collapse_full_of_compound, khugepaged_context, anon_ops);
> -	TEST(collapse_full_of_compound, khugepaged_context, file_ops);
> +	TEST(collapse_full_of_compound, khugepaged_context, read_only_file_ops);
>   	TEST(collapse_full_of_compound, khugepaged_context, shmem_ops);
>   	TEST(collapse_full_of_compound, madvise_context, anon_ops);
> -	TEST(collapse_full_of_compound, madvise_context, file_ops);
> +	TEST(collapse_full_of_compound, madvise_context, read_only_file_ops);
>   	TEST(collapse_full_of_compound, madvise_context, shmem_ops);
>   
>   	TEST(collapse_compound_extreme, khugepaged_context, anon_ops);
> @@ -1291,10 +1344,10 @@ int main(int argc, char **argv)
>   	TEST(collapse_max_ptes_shared, madvise_context, anon_ops);
>   
>   	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
> -	TEST(madvise_collapse_existing_thps, madvise_context, file_ops);
> +	TEST(madvise_collapse_existing_thps, madvise_context, read_only_file_ops);
>   	TEST(madvise_collapse_existing_thps, madvise_context, shmem_ops);
>   
> -	TEST(madvise_retracted_page_tables, madvise_context, file_ops);
> +	TEST(madvise_retracted_page_tables, madvise_context, read_only_file_ops);
>   	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
>   
>   	restore_settings(0);
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 3b61677fe9840..854c5c3e3a6ae 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -490,8 +490,6 @@ CATEGORY="thp" run_test ./khugepaged all:shmem
>   
>   CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
>   
> -CATEGORY="thp" run_test ./transhuge-stress -d 20
> -
>   # Try to create XFS if not provided
>   if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>       if [ "${HAVE_HUGEPAGES}" = "1" ]; then
> @@ -508,6 +506,14 @@ if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>       fi
>   fi
>   
> +if [ -n "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
> +CATEGORY="thp" run_test ./khugepaged all:file ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
> +else
> +	count_total=$(( count_total + 1 ))
> +	count_skip=$(( count_skip + 1 ))
> +	echo "[SKIP] ./khugepaged all:file" | tap_prefix

This leads selftest runs to always litter the output with SKIP when 
running this with the wrapper

make -C tools/testing/selftests TARGETS=mm run_tests

> +fi
> +
>   CATEGORY="thp" run_test ./split_huge_page_test ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
>   
>   if [ -n "${MOUNTED_XFS}" ]; then
> @@ -516,6 +522,8 @@ if [ -n "${MOUNTED_XFS}" ]; then
>       rm -f ${XFS_IMG}
>   fi
>   
> +CATEGORY="thp" run_test ./transhuge-stress -d 20
> +
>   CATEGORY="thp" run_test ./folio_split_race_test
>   
>   CATEGORY="migration" run_test ./migration


