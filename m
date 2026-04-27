Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE40EFF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19A106B0088; Mon, 27 Apr 2026 16:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A206B008A; Mon, 27 Apr 2026 16:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0623D6B008C; Mon, 27 Apr 2026 16:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E66546B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:12:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE750A0306
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:12:16 +0000 (UTC)
X-FDA: 84705432672.02.95661BD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8552540007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:12:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OLU8csb1;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777320734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qi57hKTHhV/3NllK7hjHOaSFLPLM3ZMT89/dw5Cb45w=;
	b=1SL5tV/i3r8FSufoAL6TC0u6k/Ce7ntkg/2FxknYuvCuw6C/OTBJssopE4qhODxZPSH2d4
	lNHLSrwh2tAv3MVZH5X3gBOHBf/ICAkJ4HLNuM/V1kn1oTmY7ZDA/csBiGCJJPzp84t3p7
	DhWi63fL5yMC7HZ4ZsWONkHvmlG60Ug=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OLU8csb1;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777320734; a=rsa-sha256;
	cv=none;
	b=2N1jLfj+nTWdjBz1dugAjx8selLOzaJPw2k2pEJ0aqMbuVOr5FwsTMyMTXVCIuO6FCx3Pe
	vY1stPkYqUoDfNLGt+MupKQuTa8ePVxLJfAn20yMl+M+utoPKb8cxLJt8dQs5bPzww9GFn
	drQb25EcpMsuLzGuxIVFgL6Xm1McRcQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777320733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qi57hKTHhV/3NllK7hjHOaSFLPLM3ZMT89/dw5Cb45w=;
	b=OLU8csb16kNHoCxC1HoEAlibYgViHLQ+pZ6muA6Bt0mBymiL0otBGZTaKWune5OGE+RUgi
	jOZA1N6bSAykkWaMn1lgdWe45edn+sOy3rB8B1Pvq3QzI6STP2MFB7bgauUd8OUlM/heZM
	yrmq2egvjHkr9zKpg35soM76YSF3fDg=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32-Js9otmFOMsW5vvZon09gRw-1; Mon, 27 Apr 2026 16:12:12 -0400
X-MC-Unique: Js9otmFOMsW5vvZon09gRw-1
X-Mimecast-MFC-AGG-ID: Js9otmFOMsW5vvZon09gRw_1777320732
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-56f6e1969c8so13470449e0c.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:12:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777320732; x=1777925532;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qi57hKTHhV/3NllK7hjHOaSFLPLM3ZMT89/dw5Cb45w=;
        b=Od+nulYjhhG/WyT7zEAQ6VwLmc7s18bDNjmZSrRFGvefnniArLFyKJ4m5sLzxn72Cw
         Vj4+s0jM6BN/JQDhkQHpI60av433kIOUtPYq8P+yWlUm8TQMAXldOW6tJkRsLhGFVRst
         5ZqvTtrSTDCGkdWIcmRyrCTRZOWABEr8UkDxntzat190Nhtqf0U0EMboqoN91Sy9E46R
         5n+nDVg3JKKkpO8aT10tvV95aHob7/idcpDEW/yu8vq3SAvnsXBbFCUYj0MI7wtwkVWZ
         YXRZVsHutpznkBqAYpTACJ2IsKJ8LgrLy8zl0ZXszHPgoieHnNnlMOS2wpxxYkSgnh+/
         Eq8w==
X-Forwarded-Encrypted: i=1; AFNElJ9w9KRJv5teJePZBn4Rl0N25UWimoquJD6t0wD7woVGASNB8wBdBny8Vfymf/1dKmwfZu+HQ6CDOA==@kvack.org
X-Gm-Message-State: AOJu0YzPHVoLjV+A/2PP8VkOcL3qFdHSw3eM9U1Aopj/xnWfz+stM/Zl
	PVTbYvf1ko8ISmDx/gRbtkZVggHUYJE8IAaM2w9vqOOOyRuEMY/AtqfqEtG+uBjrO1Zmr2z2K+v
	BYuS1NfnjUDyp309wWt8dzuMRnTW7nDHfEWSZ5HeCHVMd3ubNitb/
X-Gm-Gg: AeBDieuPOz5M4kWVWpDONhrEtKyz+Nc5wYB+gbYGtGTO8ezKRDGx6MjoDTR3dBrAldt
	IdjYrHVzGq/u+T9nNq0ra1N80DECiSwXqy+5+B7gLTmAmR1xmhGdErVk43tllQ49wLW0J/hbs0M
	1pc6GAEWkpCd7DdQ1X1O5MOAD9XQWDPFQWInhzB7ZJwJTgc1YClrsMsRZI/oBY2bsxcZ/DjI3Rd
	n8GwrO1BqfOEJWXYbdWZGdhzb3FkMdISSXIcQRuUIZfWmrK7C/SrPv8fltEKor4AzmH0LxjuBKN
	VmGQ0ITeQFBTlca1V1RYrXR8rw82VqBcZG1Wh4TJT6fzAhibQ2oewdE5fDD8Kn0Vt5fAV2haAG9
	eGfnCTKqIfw8HbDoXa6DV/OX82uubC2Ox8NkNdudbta2dWwbMI24QfevMqI3p/4PpcABBUZVbFT
	Mw5TZCSC0ftPY7qfzUFTE2MtrWlw==
X-Received: by 2002:a05:6122:614a:b0:56c:e871:31a8 with SMTP id 71dfb90a1353d-573a55c7eb5mr132465e0c.7.1777320731965;
        Mon, 27 Apr 2026 13:12:11 -0700 (PDT)
X-Received: by 2002:a05:6122:614a:b0:56c:e871:31a8 with SMTP id 71dfb90a1353d-573a55c7eb5mr132437e0c.7.1777320731397;
        Mon, 27 Apr 2026 13:12:11 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-53-69-159-169-238.dsl.bell.ca. [69.159.169.238])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-573a45d5f25sm279986e0c.10.2026.04.27.13.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 13:12:11 -0700 (PDT)
Message-ID: <6188aaac-0792-4ffb-a5a7-739adc9fd516@redhat.com>
Date: Mon, 27 Apr 2026 16:12:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 46/53] selftests/mm: thuge-gen: add setup of HugeTLB
 pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sarthak Sharma
 <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-47-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260418105539.1261536-47-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 01ZgOmTyxIMIAUvSs4zQI8iTvnVtYMvLB6uiYk3GOew_1777320732
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8552540007
X-Stat-Signature: o5i8fhas58oocky7ixmdco3p7i1c78ir
X-HE-Tag: 1777320734-414592
X-HE-Meta: U2FsdGVkX18g0NWyffebuttWTSAN91QD2d3K0+G1iorBZ27EduRunvITtBk8uQSskCPOK0nwGXBxNZ4wVrlmjM8iW1ho9L15nZ8B0+3RNBgKgCu3BBs3l2qzg3ZlePRk5j37IzRlKq4IPSbyBqSc2t8VUmhfSLrzK58R3M6KQQgQpPpYw+DcJZu7KLCtbeS9I6lzS45lvOO12wWa6OYMqGV41S57f71R1X3YiW42rIKCH2eXslomJ0gEx6IQCZA4+/8LYYq1Sp3wdEhaIMU8KEV1bRlQ5ZAYIHyCryZbMmV+OsQI8zznUGoQ720W6wkTWDZb/fmfqdnUCOqfftAiqQzIxPg0kibDz+pMHpRQiabG2yurRQD92c6KFLQRsqe3GjVhsywL23jpibHR6govTf64dE+kGg0K3BR/k2yQA/FmdibivgPMq+9O0mJ+9ui7nmlZplbHOOo0w/irIi59cJUI0zgRU0Uq+NUhPt0JIH6ZpamRhpmDrh+0VbZUA+salo/9tXXBw/FM8UnnZghgMPjQIJYbj0WJ7UtByawyjydp3rePT+4HyWxXW0xU1qtJjTUgukbeETWq/OYkzGqdGRUYVBcKVm86PosBo4WLjL1mFuh0YmJvSTf8j/mhHbmBSBtDz2cyt8m6kHTVbz6Aj+fKs9bEo1SPS066XJUe88iWJEtc5ZkL4yqas36EhGLIOi6GQXe9CtHwpSr9NvSMMHm40v9k+djiTNkmxEMFS2He19Knqd8n9n3KTGWiaED6dVbcwTg7eUndMRbdgxJDallouVoG/sIpt4h1FcD8iHyG/fbPhLFaa6edbVpI4pO76cAX2PJb6NZiF4oFu4lZs9sOTf6SQfw1/HPlQL6HLn6Q2VwVDQ4Wvy99TvtDmFgw6l3DK0Eg3LTnI2be/uyuos7iWB9ToOqwhqVXXI8FDbBf/OfZIrPLM/xLyXHv6edgvZFnY5RzPu+mxRpkeX4
 xrCyU0l3
 VdAs5bLwbPd1lygjQ1dh4g0z7v5opKftCk/gBqV3UpMm4Na9c1jMkoH7BjhjB1C6+dVJHmClraSUTy+YhLLaMzaHUs4SSTOvBCmoSsBQZlw9DJcc6OCqA43SWvdRpXVvk4TUZ6X7mrLL2bYk2bAf1aR3z0MI42h1/oFjwyEHm3YbuGUfgc85Z27bElX0lWykF8tc7qBxBFg9dNCDwb4+1QDucekjeos+gqpAm66K6M31H1vf7xYKVe7UZG+o/Mcza2TLebfWALzTOEYQqSFlulVXCC2eFZ5GvF2uvh0OifuGFf3ul6aK3G+jbLwmsi/niKjfmM3g3RzIHudptUF4jmVFs88ZjMMYZvjGMR9rFcyOFtFS6PaSJ+YMHdcBtJUt+q0EFd9AC1sjIoLpMTFa6FkeyPoQ7w5eNmPo9SvbuoSgssF9tjPl3drpuit+LRigG1Va2mKCHrMF0Z6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-18 06:55, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> thuge-gen skips tests if there are no free huge pages prepared by a wrapper
> script and shm liimts in proc are too low.
> 
> Replace custom detection of huge pages with the library functions and add
> setup of HugeTLB pages and shm limits to the test and make sure that the
> original settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/thuge-gen.c | 79 ++++----------------------
>   1 file changed, 11 insertions(+), 68 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/thuge-gen.c b/tools/testing/selftests/mm/thuge-gen.c
> index 1007bc8aa57c..b63d87d72a7d 100644
> --- a/tools/testing/selftests/mm/thuge-gen.c
> +++ b/tools/testing/selftests/mm/thuge-gen.c
> @@ -38,15 +38,6 @@
>   #ifndef SHM_HUGE_SHIFT
>   #define SHM_HUGE_SHIFT  26
>   #endif
> -#ifndef SHM_HUGE_MASK
> -#define SHM_HUGE_MASK   0x3f
> -#endif
> -#ifndef SHM_HUGE_2MB
> -#define SHM_HUGE_2MB    (21 << SHM_HUGE_SHIFT)
> -#endif
> -#ifndef SHM_HUGE_1GB
> -#define SHM_HUGE_1GB    (30 << SHM_HUGE_SHIFT)
> -#endif
>   
>   #define NUM_PAGESIZES   5
>   #define NUM_PAGES 4
> @@ -64,32 +55,10 @@ int ilog2(unsigned long v)
>   
>   void show(unsigned long ps)
>   {
> -	char buf[100];
> -
>   	if (ps == getpagesize())
>   		return;
>   
> -	ksft_print_msg("%luMB: ", ps >> 20);
> -
> -	fflush(stdout);
> -	snprintf(buf, sizeof buf,
> -		"cat /sys/kernel/mm/hugepages/hugepages-%lukB/free_hugepages",
> -		ps >> 10);
> -	system(buf);
> -}
> -
> -unsigned long read_free(unsigned long ps)
> -{
> -	unsigned long val = 0;
> -	char buf[100];
> -
> -	snprintf(buf, sizeof(buf),
> -		 "/sys/kernel/mm/hugepages/hugepages-%lukB/free_hugepages",
> -		 ps >> 10);
> -	if (read_sysfs(buf, &val) && ps != getpagesize())
> -		ksft_print_msg("missing %s\n", buf);
> -
> -	return val;
> +	ksft_print_msg("%luMB: %ld\n", ps >> 20, hugetlb_free_pages(ps));
>   }
>   
>   void test_mmap(unsigned long size, unsigned flags)
> @@ -97,14 +66,14 @@ void test_mmap(unsigned long size, unsigned flags)
>   	char *map;
>   	unsigned long before, after;
>   
> -	before = read_free(size);
> +	before = hugetlb_free_pages(size);
>   	map = mmap(NULL, size*NUM_PAGES, PROT_READ|PROT_WRITE,
>   			MAP_PRIVATE|MAP_ANONYMOUS|MAP_HUGETLB|flags, -1, 0);
>   	if (map == MAP_FAILED)
>   		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
>   
>   	memset(map, 0xff, size*NUM_PAGES);
> -	after = read_free(size);
> +	after = hugetlb_free_pages(size);
>   
>   	show(size);
>   	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
> @@ -121,7 +90,7 @@ void test_shmget(unsigned long size, unsigned flags)
>   	struct shm_info i;
>   	char *map;
>   
> -	before = read_free(size);
> +	before = hugetlb_free_pages(size);
>   	id = shmget(IPC_PRIVATE, size * NUM_PAGES, IPC_CREAT|0600|flags);
>   	if (id < 0) {
>   		if (errno == EPERM) {
> @@ -142,7 +111,7 @@ void test_shmget(unsigned long size, unsigned flags)
>   	shmctl(id, IPC_RMID, NULL);
>   
>   	memset(map, 0xff, size*NUM_PAGES);
> -	after = read_free(size);
> +	after = hugetlb_free_pages(size);
>   
>   	show(size);
>   	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
> @@ -154,43 +123,15 @@ void test_shmget(unsigned long size, unsigned flags)
>   void find_pagesizes(void)
>   {
>   	unsigned long largest = getpagesize();
> -	unsigned long shmmax_val = 0;
>   	int i;
> -	glob_t g;
>   
> -	glob("/sys/kernel/mm/hugepages/hugepages-*kB", 0, NULL, &g);
> -	assert(g.gl_pathc <= NUM_PAGESIZES);
> -	for (i = 0; (i < g.gl_pathc) && (num_page_sizes < NUM_PAGESIZES); i++) {
> -		sscanf(g.gl_pathv[i], "/sys/kernel/mm/hugepages/hugepages-%lukB",
> -				&page_sizes[num_page_sizes]);
> -		page_sizes[num_page_sizes] <<= 10;
> -		ksft_print_msg("Found %luMB\n", page_sizes[i] >> 20);
> +	num_page_sizes = hugetlb_setup(NUM_PAGES, page_sizes, ARRAY_SIZE(page_sizes));

Are we missing a call to hugetlb_save_settings()?

>   
> -		if (page_sizes[num_page_sizes] > largest)
> +	for (i = 0; i < num_page_sizes; i++)
> +		if (page_sizes[i] > largest)
>   			largest = page_sizes[i];
>   
> -		if (read_free(page_sizes[num_page_sizes]) >= NUM_PAGES)
> -			num_page_sizes++;
> -		else
> -			ksft_print_msg("SKIP for size %lu MB as not enough huge pages, need %u\n",
> -				       page_sizes[num_page_sizes] >> 20, NUM_PAGES);
> -	}
> -	globfree(&g);
> -
> -	read_sysfs("/proc/sys/kernel/shmmax", &shmmax_val);
> -	if (shmmax_val < NUM_PAGES * largest) {
> -		ksft_print_msg("WARNING: shmmax is too small to run this test.\n");
> -		ksft_print_msg("Please run the following command to increase shmmax:\n");
> -		ksft_print_msg("echo %lu > /proc/sys/kernel/shmmax\n", largest * NUM_PAGES);
> -		ksft_exit_skip("Test skipped due to insufficient shmmax value.\n");
> -	}
> -
> -#if defined(__x86_64__)
> -	if (largest != 1U<<30) {
> -		ksft_exit_skip("No GB pages available on x86-64\n"
> -				   "Please boot with hugepagesz=1G hugepages=%d\n", NUM_PAGES);
> -	}
> -#endif
> +	shm_limits_prepare(NUM_PAGES * largest);
>   }
>   
>   int main(void)
> @@ -233,3 +174,5 @@ int main(void)
>   
>   	ksft_finished();
>   }
> +
> +SHM_LIMITS_RESTORE()


