Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1CCC87FCC
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 02:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793366B007B; Thu, 24 Jul 2025 22:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741EF6B0088; Thu, 24 Jul 2025 22:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630406B0089; Thu, 24 Jul 2025 22:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 540B96B007B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:16:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C74A211381A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:16:54 +0000 (UTC)
X-FDA: 83701173948.11.EF279D8
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id BAB922000D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:16:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CFULoBuE;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753409812;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZA63aka7MYo1ZbQZ1nPvLQD/7kZf1kEK+caGbIMVnE=;
	b=Kh626CXYzTp/N5Xn5+yfBSzpJ+PJFy8ANoG47s2ovcCNHqhZROqPmB3cOPqcVpEV4JvDy8
	XXmB8CpO3QkD2dCklkDFbi5Sk1yVlwe5OJShz6xXNQYOt83HSgQc2yj8qsgBPgwWFUv6/u
	aa5IRwMezAWvy3FqjhBef8vmc6CVGbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753409812; a=rsa-sha256;
	cv=none;
	b=QJCOUttAf3c0Pb42N2xpl7A1zYU7dBsvdk9qcF+KmJ8xAbuU26/arBXtp4zjk10IIcyG0c
	mcq/JTle4MeMgyiPOnU+b7bpf87+YyZIL9kQ/AUQ1ue3AXMckVQX2xq3qamHIgSPYTprSd
	i5EEHunrXqnudYJZyqBUnc87FsfyofI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CFULoBuE;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ae360b6249fso273664966b.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753409811; x=1754014611; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZA63aka7MYo1ZbQZ1nPvLQD/7kZf1kEK+caGbIMVnE=;
        b=CFULoBuEz+nU8qsI+/SDP9hU52MlD4yG/8po525b2EpB7ftMvd+dQE4zFykISZTpLG
         Cy5DYW3TqouybGmVPoehG81unwYZzUfpwMu1VKEekTlJv/U7/G2e88Vf8uiVBfIGSbOa
         bfDVAh6F7lueUDprLTlAu7LtZJtWHXRXsNIqyXJCfbX3ZvuvWvQWHyK4Rv738MH8nLRS
         lQrkWiX2FNMuEJU6RO/nxfMVhL0PalGDyAbxfvYxUNA9gygbGgRslf8guH5ohRo1X9Dm
         29YHhVuxUYnGabHO1VSOM1az/Rb4+MUNW8BPAd6kcSgCDD2SpjM5qxdBugG6jg+oxTRa
         sWWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753409811; x=1754014611;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rZA63aka7MYo1ZbQZ1nPvLQD/7kZf1kEK+caGbIMVnE=;
        b=Tah144rP5A289OD+AqtTlbs35IRcic+F4XPmvLP4TjSAFFzcQ5M4/VeONpgi5yZ7V4
         ql9oX+UHwwsodA/2icdZi6wAZxfp0azDFdi+TyN9OhFl579iyCXAEXYEL1m7xMmPauY9
         1/qiWu0mbAeJ10kXcuOez8eoBPsujdTIT/uIBGhP4+4/eiinEBKt6g3EbZFPKSxTMuui
         6eSaK4TOwAAqmWvUiMJShDj6m50vnVjOogHC4pACAGQRzQXLInheJK5Jouz5mth8SJcp
         0Vy0+abnq63ZSGbYmjNbpupJmgzh5xjMIzrHqJ3RuT98grDo1wR/mRi1ix5YpS3IYVr+
         abQw==
X-Forwarded-Encrypted: i=1; AJvYcCWCygmk5cH6ioSRckacQNrlWUDJ6+R76D1X5GPPcgCnbfCa9udqhMTRlugp6FKCtrvff9e0POm5+g==@kvack.org
X-Gm-Message-State: AOJu0Yy9TQ2d8gYnoH88OsMBetUSyol2N+aqHjdGKSjDISnvLUirRUir
	aUCm+ZPUENk7dxGdxDGnk45ytRlnBcekJiZIujgFCAebtp/a7swrHjml
X-Gm-Gg: ASbGnctsUhDcetdfOCORs36iioj8mDAlruewPjVgcj3I4KZYprQZzSn18P1eJMgc+6s
	psPSX2VABSESU8lfm/pi1vKcLiLBWGOzgtAqcYj8+bAang0XKb+BXIjk51+/bWNp6OhVJyGdCUm
	ZfM7rsTpxrJRXr4zKZQW9R/K8+md+pbJcthW5QN+qkkg8y4pFGiTsdLicsphwf126qCOB04e0DX
	sUOdFZvTwUrhi5Km2HS+2+vnQ5ioTGsvKZjLbHizqaFGczpENMUBa+iZbn2F6263MWdXWXL0jho
	yQEGZLt8fmfphYwmuTVLPHchdrcXAK6GMJq4JeRHen8YEnmFPkNTBEPQxeVdKmi5glu1kt/0AAZ
	Ujmb+6X7ZlqMkBNcJGfybdg==
X-Google-Smtp-Source: AGHT+IE2lPGywxevj91tgS5tcwNxmaH4Ey/oSj1XuQFji1ge9XHZu/lG2r/TEF4ou395oiWIR7P0Ng==
X-Received: by 2002:a17:907:6d18:b0:aec:4ba4:7893 with SMTP id a640c23a62f3a-af61c4bd82bmr25198266b.2.1753409810774;
        Thu, 24 Jul 2025 19:16:50 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af47ff43294sm192761366b.140.2025.07.24.19.16.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jul 2025 19:16:50 -0700 (PDT)
Date: Fri, 25 Jul 2025 02:16:49 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [PATCH 3/3] selftests/mm: assert rmap behave as expected
Message-ID: <20250725021649.eetoa4sev7r4uweh@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250716082710.2801-1-richard.weiyang@gmail.com>
 <20250716082710.2801-4-richard.weiyang@gmail.com>
 <c4f339de-64d8-456b-bcdf-3719bea08fb1@redhat.com>
 <20250717031748.27eic7qxotft6uko@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717031748.27eic7qxotft6uko@master>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BAB922000D
X-Stat-Signature: igfs43ppdum3p4a44fk8ktqrm3tuqrgn
X-Rspam-User: 
X-HE-Tag: 1753409812-720249
X-HE-Meta: U2FsdGVkX1+mna4qumj0e8I0fwKkRUZFeQ93UtoEs7ofHexZVdnrfcdRLJlm9OgB6nMewvE0gDmFMnLCP5kdhcr6DYh1qP1EZgdV7QYZ5vXwNT6ZGLNV0BsNH5gRkzx5fA83Bt++QgATnWEqSPdig/vgKzlwsyEI+pyEBvmXdK/qAh/5E54+TjFEEfmMg2V6c8/Fh48HuUVA8lXh5TrJzRwNe3ZYU787TF0oABulf5Y5kB7F1O+FEufljkRT/IFos11ZIXJkLZAax9nyH2jaAll+1+RLvT0ACcUHsN7/PSZ6NtQIZ7xUindLnXvj2pHVExDqHv5Mc0HnNaQpexwZXt8rOe9+AaDWQXdqgpcup1wiAn0fWc4TBMgdeHQI1J01ga3HaIAJHPWtXFUc///TOxRuFQ9pjO5vJ1HblkSxELVzJsGGG8OD3LKDPzLQZbEMdA36w+/oUZU+q3V+eBtEv9utCm5wl2MuVCTDAA8joBOxWRoNE4zQHqe9mwYQKyejalUAGPQwel0d2e4N/nYIx9YOJIRtXAby39/EYVwjNNUMePNGSF04fymjFEtHIoeLhpz4TTQihUgqXmAPU3dik/7hN7yEnP/IkHXlgJ+Odjpy+LNW4wdfwRfyV5+rsgbp/ZQlKzjNZKCUEBqFtJOW5lls8Edt2zVM2SQzjxStTDtQHObcvfrWisYXfpjFwRraGkuatvs40QlBCkgrtfB7KYzuji7mariTu35spROz5N74Nyekpgw2Dq11ByTK7tOtx74tGe0leGc0ljVhwkRt10ZWQrWR8Ea7helELLMSwh1bLRclQLWojbChtlzq/paH2thUdiiLB4UOHgmK7RjH4K9zH9uqKBbxWjMKx9aqJbYyh+bg7ZRpIXJRS4yPe8UauhjGlzhis/I0TfPmIVT8YRzWuNbfExTj7R+6F4S71mpcjyCWTSI1Qb0EzLqn1nFd0Ogge4xZwbaP4iTAVxb
 4ORWi9Zq
 IoXZytmRbvOKoj8+T8QDE+CwSBDk9mlPbcEo42Kd+H65Lsy7sFTtqRJhf3JcPNwHkws9aR9Q2sDy3IpAPuDjsBuxnzhIFNnwUzS5c74fcYYpE41qZurL2b0Y0BKTAGcxCnzK54zAcuyfK+uHrIpRr+MLMpHRSmyqCUeYGNiT7+tUdOmkeSpii632pQKSQGI7VvZSVjlFjLqHAhhHZwiYKVlP4V3R25qgV+/3UE99E05/TZw8B/qAMFp0UezixakHsQjB4s8Q+CYgn7M81dqBPL4AD2Vbbcgwe6FEkl+MSPl1Q29CzwESNW6mqKj2+s84F/ivU/AdpmUEJ6E8LmWJfLRB8dnGngH6pCq/dBUA4pHdGF5deZNn19FEUiDyl0gZ0lv3ToKSH5GK30QIF2OHT0gMc4Y0XTVp9V2Gmw88wIX8Jrj6wsfqATjZi5LO+AMFrEM82wYppk4wdI+K1iIxNd2c2WjsrrrbEfn7KH7Hbopqgw21HXYS7ESBaT03+wqTVqOmhB7J8BQDWW1npNTCOOtBH/68ekM8QZnRvbjOd45FtY/j2VRF1X/Vxynvh9hC+tfGmXGapo4OdKr347PtQ+PZqTSrULpYcb5d1r6GyVAEu5rXH1TAoyc1bbBXSnI1ATeAoK5dhFYgxYdZ8GpaBLZvexAs5y2AHuPJVX1wb5UobeQx2cdyewuVAwa7sNhr2V3+Mj7K4dlj2+t6VYzlC/vjpmXsQe8Ipwq71zu0qy7Zsu6S/b7k8noqb6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 17, 2025 at 03:17:48AM +0000, Wei Yang wrote:
>On Wed, Jul 16, 2025 at 03:34:11PM +0200, David Hildenbrand wrote:
>>On 16.07.25 10:27, Wei Yang wrote:
>[..]
>>> +
>>> +FIXTURE(migrate)
>>> +{
>>> +	struct global_data data;
>>> +};
>>> +
>>> +FIXTURE_SETUP(migrate)
>>> +{
>>> +	struct global_data *data = &self->data;
>>> +
>>> +	ASSERT_EQ(numa_available(), 0);
>>
>>if (numa_available() < 0)
>>	SKIP(return, "NUMA not available");
>>
>>Should that be a skip instead?
>>
>
>You are right, will fix it.
>
>>> +	if (numa_bitmask_weight(numa_all_nodes_ptr) <= 1)
>>> +		SKIP(return, "Not enough NUMA nodes available");
>>> +
>>> +	data->mapsize = getpagesize();> +
>>> +	/* Prepare semaphore */
>>> +	data->semid = semget(IPC_PRIVATE, 1, 0666 | IPC_CREAT);
>>> +	ASSERT_NE(data->semid, -1);
>>> +	ASSERT_NE(semctl(data->semid, 0, SETVAL, 0), -1);
>>> +
>>> +	/* Prepare pipe */
>>> +	ASSERT_NE(pipe(data->pipefd), -1);
>>> +
>>> +	data->rand_seed = time(NULL);
>>> +	srand(data->rand_seed);
>>> +
>>> +	data->worker_level = rand() % TOTAL_LEVEL + 1;
>>> +
>>> +	data->do_prepare = NULL;
>>> +	data->do_work = NULL;
>>> +	data->do_check = NULL;
>>> +
>>> +	data->backend = ANON;
>>> +};
>>> +
>>> +FIXTURE_TEARDOWN(migrate)
>>> +{
>>> +	struct global_data *data = &self->data;
>>> +
>>> +	if (data->region != MAP_FAILED)
>>> +		munmap(data->region, data->mapsize);
>>> +	data->region = MAP_FAILED;
>>> +	if (data->expected_pfn != MAP_FAILED)
>>> +		munmap(data->expected_pfn, sizeof(unsigned long));
>>> +	data->expected_pfn = MAP_FAILED;
>>> +	semctl(data->semid, 0, IPC_RMID);
>>> +	data->semid = -1;
>>> +
>>> +	close(data->pipefd[0]);
>>> +
>>> +	data->do_work = NULL;
>>> +	data->do_check = NULL;
>>> +
>>> +	switch (data->backend) {
>>> +	case ANON:
>>> +		break;
>>> +	case SHM:
>>> +		shm_unlink(data->filename);
>>> +		break;
>>> +	case NORM_FILE:
>>> +		unlink(data->filename);
>>> +		break;
>>> +	}
>>> +}
>>> +
>>> +int try_to_move_page(char *region)
>>> +{
>>> +	int ret;
>>> +	int node;
>>> +	int status = 0;
>>> +	volatile unsigned long dummy = 0;
>>> +
>>> +	/*
>>> +	 * Fault in page in case it is not, otherwise move_pages() would
>>> +	 * return -ENOENT.
>>> +	 */
>>> +	dummy = *((unsigned long *)region);
>>
>>Use FORCE_READ() here
>>
>>https://lkml.kernel.org/r/20250716123126.3851-1-lianux.mm@gmail.com
>>
>>But, this really must happen in all children before actually performing the
>>move in the worker. Otherwise the other processes don't map the page and will
>>just ... fault it in later.
>>
>
>Ok, will access the region in all child before migrate.
>
>>> +	/* Prevent the compiler from optimizing out the entire loop: */
>>> +	asm volatile("" : "+r" (dummy));
>>> +
>>> +	ret = move_pages(0, 1, (void **)&region, NULL, &status, MPOL_MF_MOVE_ALL);
>>> +	if (ret != 0)
>>> +		return FAIL_ON_WORK;
>>> +
>>> +	/* Pick up a different target node */
>>> +	for (node = 0; node <= numa_max_node(); node++) {
>>> +		if (numa_bitmask_isbitset(numa_all_nodes_ptr, node) && node != status)
>>> +			break;
>>> +	}
>>> +
>>> +	if (node > numa_max_node()) {
>>> +		ksft_print_msg("Couldn't find available numa node for testing\n");
>>> +		return FAIL_ON_WORK;
>>> +	}
>>> +
>>> +	ret = move_pages(0, 1, (void **)&region, &node, &status, MPOL_MF_MOVE_ALL);
>>> +	if (ret != 0)
>>> +		return FAIL_ON_WORK;
>>
>>Probably, if we don't manage to migrate, we should retry a couple of times
>>and then SKIP.
>>
>>Point is, migration might fail for various reasons (e.g., 2 NUMA nodes but
>>one of them doesn't even have memory) etc.
>>
>>Migration failures might indicate other problems, yes, but false failures
>>from the test are suboptimal.
>>
>
>Will add retry logic.
>
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +int move_and_update(struct global_data *data)
>>> +{
>>> +	int ret;
>>> +
>>> +	ret = try_to_move_page(data->region);
>>> +	if (ret != 0)
>>> +		return ret;
>>> +
>>> +	/* Change the content */
>>> +	strcpy(data->region, updated_data);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +int data_updated(struct global_data *data)
>>> +{
>>> +	if (data->region == MAP_FAILED)
>>> +		return 0;
>>> +
>>> +	if (strncmp((char *)data->region, updated_data, strlen(updated_data)))
>>> +		return FAIL_ON_CHECK;
>>> +	return 0;
>>> +}
>>
>>I assume checking the PFN is sufficient. No need for the additional data
>>content. In particular, with proper anon pages (CoW, see below) that doesn't
>>work either way.
>>
>>> +
>>> +TEST_F(migrate, anon)
>>> +{
>>> +	pid_t root_pid;
>>> +	int ret;
>>> +	struct global_data *data = &self->data;
>>> +
>>> +	/* Map a shared area and fault in */
>>> +	data->region = mmap(0, data->mapsize, PROT_READ | PROT_WRITE,
>>> +				MAP_SHARED | MAP_ANONYMOUS, -1, 0);
>>
>>That is anon_shmem. We should test proper anon memory (MAP_PRIVATE), whereby
>>pages are shared using CoW.
>>
>
>So the case should be 
>
>  * mapping (MAP_PRIVATE | MAP_ANONYMOUS)
>  * write some content in root parent
>  * fault in for each child
>  * do migration and record pfn
>  * then check pfn is the same in each child
>

Hi, David

Is my understanding correct? If so, may I send a new version?

-- 
Wei Yang
Help you, Help me

