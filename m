Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01AE5FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 04:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310826B0088; Mon,  4 May 2026 00:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1486B008A; Mon,  4 May 2026 00:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AFEF6B008C; Mon,  4 May 2026 00:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA466B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 00:23:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 86B511C13E7
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:23:07 +0000 (UTC)
X-FDA: 84728442414.10.3E75FEA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 40D8B40002
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:23:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DoPAFXR8;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777868585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8JUpxs4HHb5TNL47sn37+M30nm78WhRCS5Q6b7JSuI=;
	b=8Kx8uHx8CuTNnv5xbkrHoI3FB2FMz3XzsBYQ5axnkdzAQMl9Q0zYDNSDVwCD871Hi+EGAU
	j4Yz2wLsW5wYPtgV/vaj8ine6BDO2eLyB+/ENOvXofPQtpYXBR4ROc1q9pM5q9gJF5kSfa
	0bN4wWvIaTBVunTAE8SzxiSHadLyr0M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777868585; a=rsa-sha256;
	cv=none;
	b=Exb8N5Bgy6j1004Pw38OeX7ZOjGbSqgNlok/QzPLSQGTvbCduhgP39wGuQiojAOwKXh/8R
	BcDKQxKs1mfsp4u5oi13X6jNHJdcW0YAtjJ9RCaXr3NSj+3t3dsVmcFR363NYk4V6XCq8s
	s4hxwP9GK/az4vV5NtxOyJqRf1AUE4g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DoPAFXR8;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777868584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U8JUpxs4HHb5TNL47sn37+M30nm78WhRCS5Q6b7JSuI=;
	b=DoPAFXR8xWYFwZ4g2UnorqZSgf60zNoOSp0XV/szFB60I/TBzXmAUeEmFLJ84LMo/a6do6
	QaN+iqO5ITUkhk95JQSvNFZgLoPvYQ1u9kxCg/IQ8Kfhw8bYXzJVvluwGzC7etKFV9gzh1
	5umxOcHWzgW1UUfg3bFUr4es7y0Z8rk=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-aYp1JYaNNtaMeIkDftdDgg-1; Mon, 04 May 2026 00:23:03 -0400
X-MC-Unique: aYp1JYaNNtaMeIkDftdDgg-1
X-Mimecast-MFC-AGG-ID: aYp1JYaNNtaMeIkDftdDgg_1777868583
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7bd66ec877aso20688457b3.1
        for <linux-mm@kvack.org>; Sun, 03 May 2026 21:23:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777868583; x=1778473383;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U8JUpxs4HHb5TNL47sn37+M30nm78WhRCS5Q6b7JSuI=;
        b=oFJSTH8XE8MatAPou7FICVTHtgQuVRPFRNa+hZr9gUsry+Q/MZ31GWc7NsPZDjMKWZ
         tNptGZyGGeRYKXqo8TV7SlgWBLUR+fQ8QFR3zrnLEveeaZG6GyEAZ765aWSzFEyRZLJG
         KheYb57YC9N2udr55T3ce5/H/jmdgFKm2vmHypyugGEK3DuOa3n9uvsOL410mf0x5YSi
         /PRC2FObONrdkQfqMUPTrCFFnFJojusUWzWCS5uuNapJGfMUlWvhok4xIjs4fkvmBkk7
         kHXqjovrsmKX7HDpBlNUv17nyaaxeIiKwz/LtJtu+Y8CZfbIgZ2VTkOK7cwtUaV+jAX/
         sB6A==
X-Forwarded-Encrypted: i=1; AFNElJ8JLDqQJsBG34F8ZpVsv5/R7MaqwKtkjhb6G5x/1aJJfSNcqU3oEmK/MsWEBIWHH36ElJEm02FN8A==@kvack.org
X-Gm-Message-State: AOJu0Yw0FS2/XEdZSIJz6ZUR0x5GKClrmeufamSA39FqFZy/nxpMdo52
	Wy6jE7HK90G2LjZtcMIKOxDb3h7eYiGXM8PhmHXr+IiGgNSuFwW3hldUglihlIUhNBhIEu4nLMZ
	B8aWZfyf2jHk7JLkSM2rYISa3V7OxZxYh1ogypdqRRRtNI2NHbnbw
X-Gm-Gg: AeBDievowKvGsjxRyMC1O7b6dnqt+IHosZpceJL4rJjtVdiR2EE/z31jCSNWLEzBuG0
	WlOuypUW1C4xki4fHVtHh0cr0ttaotVAm7JBId+Bzf9ARNF3Kb2b41VFSOmJKw5aLv70/GmKMkh
	+lwVR2t6ozYL1IV69fHeapT90X53QuewdYNn7BriECxRV7Fgkbm2+ZQg42EIs//IfKQgEDzXTP2
	cXXa9vzkTGb30yhxG0Ytj2jnN4zXr3R2OPEAKfVLcsxUO7VpyIsAKg/KqqrEEgoMB1TXPaovsT2
	RJ3hIRK09rDvlkITPNPcK3BvMdcddU430QDpL/dXNdT/YPQH24MwpUvfE9RyI0EMyzxpXZQw80P
	lFiYRta9skd1zqIyrrJntBXVrnwRg7DdOd9AGDeXo0Iz4OJrx1TcTP6VdD+o0L5aeoes=
X-Received: by 2002:a05:690c:110:b0:7bd:77a7:8292 with SMTP id 00721157ae682-7bd77a78b77mr62285907b3.7.1777868582863;
        Sun, 03 May 2026 21:23:02 -0700 (PDT)
X-Received: by 2002:a05:690c:110:b0:7bd:77a7:8292 with SMTP id 00721157ae682-7bd77a78b77mr62285667b3.7.1777868582351;
        Sun, 03 May 2026 21:23:02 -0700 (PDT)
Received: from [192.168.178.105] (78-0-206-107.adsl.net.t-com.hr. [78.0.206.107])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6654e464sm44622987b3.14.2026.05.03.21.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 21:23:01 -0700 (PDT)
Message-ID: <52285e2c-af42-4c0d-9926-017f80b6614c@redhat.com>
Date: Sun, 3 May 2026 22:23:33 -0600
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
X-Mimecast-MFC-PROC-ID: 2yDJsQep68K2ePgT1Wv0jkcFya8RUqRZ4VkEjtSSNvk_1777868583
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 40D8B40002
X-Rspam-User: 
X-Stat-Signature: az4ddcj8jgx9um9mttxgzkik6145qx33
X-HE-Tag: 1777868585-221171
X-HE-Meta: U2FsdGVkX1+3I+QuRjkiJGEwV+vuC+6xHZzMy/x2CgnwL5Iyno/aN8r57SBcnjzNfEw5hL2OS/EII+DuSRRqSlMOgFxROwIcWp4yOoS2Y3Ch9NNpuqg/OT3s972uuJFg7QWJCUIieQRflFzT66mx7q+P4LQ6zfFRYkjyYiNoLj8grDms0dAYHCXi64algco4mFoQrBSHC/8DVnK6mPGmnqc6jXRk5rDvUSUNUMj5KO/I17x2UGcyEkgoSOFNsQ2u9EWz+1yg/5KJ/KUdINWlEyohXQ+KEzPJTh3vs/HS58gEUZWg7A9OcxTVbdqHYC3F3B8va76uvln9NjwLoXhYhg/CKVyfGdNTN+HpUPc8VFkJjVPX27ujm/ukDkBnExrRcyL5yTNHSanhzgOJuHA9m1a3nGGW2HTAtXM4RbMhOZVZQPr3P5LqWndkuZF8wK4fj2w/fQrbwUghBRl5CnhTpbrbhsAT9BY438nV0hWSzdr5DWEs6P3d1nYGO/DEpQGJEsWwMqogXUwgSjg8O9fFmGCQofuvFfS6A8nlP/8NMI7L/m2GVgxOcoQ5WIISwGXXu762dB+umqyNavMOvBGdlIfbxf35I8kU0pZJyMaEHEUdoXMSJYSUkkGi9T/MMmLKX74RLMeayI8bCOilOReZqOyHm+BiwpTjePIp1YNnV56EGcuy60fYfDQcKPUOhw63hgR3ZHuWrsKjPQOPIZ7eAKzBME7xZAHRocEdQ4Gwxb/CobdT+xJJgYK4w2mPRUUQ08HqBcw9Dnh78EqwvUktRGANWv5bZAlrjpay4xTb6rdpcWyJNp4/L7qdHUjc6TTwnrtJA+WGtas2SoEdhnLDY4PLszfSztOe045qmRiM7tjukdfQYAKhsxrrvAzjFQE20yJHda7wxMrYsH4k9LVAOdJZfplo4XsZG7rer3+4ZmYXnx/58kWKTXugDi7Q01dFwjZHNqgCkKXdFyBcYnM
 pw8axeGx
 +Q/fY1aGTZDve1MJ8NWWkzDjqFyoBIZf0wzRPWD/q1eUszlJjh0qGGqAD87eM9n5aLAr49OrgZF6DCoEso3xCqtmDAOON6QlUJGV19XIMrW3vMOaEt+nEfRqxTSL/tNjPY9Ecs3i2/9e3Zuj1sOVn8iTpB+s9Wv5jV6SiiPmH1L9LZp3Vr6/wfNO6lW0z0UeIX0h125q0LNwLilD1nrTMNBeNyeOva0/zc4Wc+jHOz+PzwlR+mvqWZIKYZ24WxZKzhwfKojivXldu5MW1UYFLx1+9qu9ty5yTAHRvlq6/R5gc8BUfE5dgQeznFu2OVaBOMw4SzCds4FaPXQLCqjQqQiJDisbiW4xVESjZDzuQ4vhX6kaRZ25Vc/ZvJnZBxE5YJ3UPdauNyiGiCmI0P56RZi5xMFhJT2c4udryG2kmY3RcTuuLz/P0yvY3MKkMIdA5dwjJ2p4oXTRx0VL+DvQPm1NHc/K3GWylUyU4tUbZ4GVBYeUrOo+CDtW78Q==
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

Just to confirm, you are adding the write part here so that before 
commit 13 & 14, the behavior is that it will fail. Whereas after with 
patch 13/14, we expect this behavior to be supported correct?

Thanks for working on this :)

I plan on testing the selftests changes at some point this week (if I 
find some downtime during LSFMM), and finishing my review here.

Cheers,
-- Nico


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


