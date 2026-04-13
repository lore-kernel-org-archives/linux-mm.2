Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0D7CF34C47
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 11:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1714B6B008A; Mon, 13 Apr 2026 07:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 147556B0092; Mon, 13 Apr 2026 07:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037106B0093; Mon, 13 Apr 2026 07:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E8E056B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:58:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C6BC16017B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:58:04 +0000 (UTC)
X-FDA: 84653384088.09.F5FA324
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf01.hostedemail.com (Postfix) with ESMTP id C3B2E4000F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:58:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cLISFnuC;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776081482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+bad71lwt55pbEushAAY3am/8JVpJ937KnhdbjHPvM=;
	b=WNpCu4D4QVMFGvu25ZnKQw50ljgC27SYyK6i5iLcnpdg/hG55Dw5BuGAU7VgusGTLCJ0Vo
	Klx84FhJxlnapOMoa7ASv4xgQMnVnyoqR4ptGrEkEtqx8eaMOikXrq2RtqId85UtPyxvQ6
	s5gRF2fcOZyzjs2soLviBmrRK7zZmn4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776081482; a=rsa-sha256;
	cv=none;
	b=C0gcXwx2DdcSNAu3pfNyLHHIIs1KSJUGc2DM6nPyXnzrZ+QIqqiMY441BazlisnJo58iw9
	1X9+QBJoUz9bcrq78T4bN2uPneV8iSj9XvQKHuS1jHQgELpxI/7LjjM2H7MrsgFtvzh2en
	FpuycjoMFGrEqRJFinD06G5opCi7TUM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cLISFnuC;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=t+bad71lwt55pbEushAAY3am/8JVpJ937KnhdbjHPvM=;
	b=cLISFnuCWUTjZvk4SBtq7ODsuprDgjfmxkCpvb7LxeAXAmgzF2kau5DX00qeLLRo9PxIsNXuE
	K2S9p1PD091doJlRCQU0GJHUK+rCSWnCpL38RVUhSXswBHze8XJbVXo5aE580yrfuoZ/NPXQF3T
	MibccXLXF5nqQrFqy3KVlYg=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4fvQjn2GXmz1cyQc;
	Mon, 13 Apr 2026 19:51:41 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id B01BC4055B;
	Mon, 13 Apr 2026 19:57:57 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Apr 2026 19:57:57 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Apr 2026 19:57:56 +0800
Subject: Re: [PATCH RFC v3 5/7] mm: selftests: Add shmem into memory failure
 test
To: Lisa Wang <wyihan@google.com>
CC: <rientjes@google.com>, <seanjc@google.com>, <ackerleytng@google.com>,
	<vannapurve@google.com>, <michael.roth@amd.com>, <jiaqiyan@google.com>,
	<tabba@google.com>, <dave.hansen@linux.intel.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins
	<hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, <linux-kselftest@vger.kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
References: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
 <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-5-718f45eb7c75@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <9effbeca-3453-f0fe-571f-85f8923e1385@huawei.com>
Date: Mon, 13 Apr 2026 19:57:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-5-718f45eb7c75@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: C3B2E4000F
X-Stat-Signature: yz8ftcdtf1hbadgpbadueygqaxkxswqx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776081481-785431
X-HE-Meta: U2FsdGVkX18dy0/DoY++LXkvVobTx8jYh8bInmL+pq2KXRSM7+UteX/G0bmAG+oP+Cg3lVsDAr33GuDayB+IbIZ5CvJoXZvAHkbB23O9S1GPhmo8jtLLfp/n7PdQKtOrSeUK4nim/jmZFcsCHds8u1i1i+KBOygYqk/+oIixf0hBPjunqLUjo6TSYFn1P6MED4kSn3QwmdbDB85rHFTo1U6+ZK0mp0XocexIy0itYo4gRT4Acs4wuVfnaQdfE8cgEjJeL+w52tcI2JPKR8FrOlm1qsU3pQrUAqtARg4OYzrhbNgU99hdi9wHds4WIFZVlCXX37NTJ/lvhI6kWMEUgWJtVLS2mZEyrAHj9JDCsUAc/4N46jy5RhM9bf5GO2VHJ2wqGa5TG8pbuuwExa0Wpm7NHv4wDQS49FimdJZVZAIKPcKijt9NXsvo5WwwPgDqNYuonRlkA+K3nTmGBHshofUZtijWmic6NpXu3PDm6iVNkPYQpcgE59ArGkxUXDBwZXEwjvXA+e9yA6bC+XPGm8h4+e5t9OI3DtRvPjotGpzaVIrXbrUNimc5mB42pDxXJkzo7/TFkDLkmyalnLUcg9WYO/kLzXI3peHSVXowU8QdpstKhPADUH/F6l9DASA9Nc0QvKjPnPpEJIRQJAwcxh2jKyEcO1fe9WuPz99+8bG8n47Me/mR7xgLE8nTD5xe5WRsUU5nFkXVW4yiAmThrfjCalu6n9UqRWZEyjjdbC3I6ij8v4GOvDC7hOssnkfGhUKAYFWnC7jkOdqv5v10l7uzYfitkfjrCe/OV/Ic6RC/GOq1TKdLA/rz3mTg6aBcEVrCfOJ0rOPSiZxbOGcgM3ZNlAJ8OeonVc7kBh36ePzqUx8CvBA/eM7VpV7Uq1YKy7rPDqZ8KbnQG8bCu8wTm2KGaND7qqT+ZU1KiTn/odCVagb94nXnAiKP+gPliaDPAfLzNVLESn6lUDqjUbf
 8RD+CmcF
 V+mMBl0qR+W2EkxxZtt9i3BvTmyEgFV11odg8Lu9C0r2dBTcIIzfled7BHrh+JKrBuHjNiAt+GB43yKVKzG5eW3p/1gA8t289y+Wy2brQFglWZPyd54ud4Zm9SXPMiGVIqaeLbqkyIA0TxAqsTSVGG9XDzD5t1gyTaHloW3z4dRCCCM7fbji7B5gDO3RQOuU3EeVO0xhLSY4FY3et4ECX1GJRdsVb0UtpYr+4YnjOYp7QQ7QTR7Lc5zeOYblpTal2m/Ealvd+dQbHn9/ET06NAo9RBRIxSZrOMSfkVa2N1kqeUN5r2naNIE7EQEipiwmVzQ5E5i4X1tUOmLT7PtW75N1Tld8KCWr+f/UZeSaH9rmPTvwBv29urKmg3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/9 1:24, Lisa Wang wrote:
> Add a shmem memory failure selftest to test the shmem memory failure is
> correct after modifying shmem return value.
> 
> Test that
> + madvise() call returns 0 when the poisoned shmem page is clean
> + trigger a SIGBUS when the poisoned shmem page is dirty
> + trigger another SIGBUS when the poisoned shmem page is fault-in again.
> 
> Signed-off-by: Lisa Wang <wyihan@google.com>

Thanks for your patch. Two questions below.

> ---
>  tools/testing/selftests/mm/memory-failure.c | 109 +++++++++++++++++++++++++++-
>  1 file changed, 106 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
> index 3d9e0b9ffb41..eb3f8d98f6c9 100644
> --- a/tools/testing/selftests/mm/memory-failure.c
> +++ b/tools/testing/selftests/mm/memory-failure.c
> @@ -30,9 +30,14 @@ enum result_type {
>  	MADV_HARD_ANON,
>  	MADV_HARD_CLEAN_PAGECACHE,
>  	MADV_HARD_DIRTY_PAGECACHE,
> +	MADV_HARD_CLEAN_SHMEM,
> +	MADV_HARD_DIRTY_SHMEM,
>  	MADV_SOFT_ANON,
>  	MADV_SOFT_CLEAN_PAGECACHE,
>  	MADV_SOFT_DIRTY_PAGECACHE,
> +	MADV_SOFT_CLEAN_SHMEM,
> +	MADV_SOFT_DIRTY_SHMEM,
> +	READ_ERROR,
>  };
>  
>  static jmp_buf signal_jmp_buf;
> @@ -165,17 +170,21 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
>  	case MADV_HARD_CLEAN_PAGECACHE:
>  	case MADV_SOFT_CLEAN_PAGECACHE:
>  	case MADV_SOFT_DIRTY_PAGECACHE:
> -		/* It is not expected to receive a SIGBUS signal. */
> -		ASSERT_EQ(setjmp, 0);
> -
> +	case MADV_SOFT_DIRTY_SHMEM:
>  		/* The page content should remain unchanged. */
>  		ASSERT_TRUE(check_memory(vaddr, self->page_size));

Why we skip check_memory() for case MADV_SOFT_CLEAN_SHMEM?

> +	case MADV_HARD_CLEAN_SHMEM:
> +	case MADV_SOFT_CLEAN_SHMEM:
> +		/* It is not expected to receive a SIGBUS signal. */
> +		ASSERT_EQ(setjmp, 0);
>  
>  		/* The backing pfn of addr should have changed. */
>  		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
>  		break;
>  	case MADV_HARD_ANON:
>  	case MADV_HARD_DIRTY_PAGECACHE:
> +	case MADV_HARD_DIRTY_SHMEM:
> +	case READ_ERROR:
>  		/* The SIGBUS signal should have been received. */
>  		ASSERT_EQ(setjmp, 1);
>  
> @@ -260,6 +269,20 @@ static int prepare_file(const char *fname, unsigned long size)
>  	return fd;
>  }
>  
> +static int prepare_shmem(const char *fname, unsigned long size)
> +{
> +	int fd;
> +
> +	fd = memfd_create(fname, 0);
> +	if (fd < 0)
> +		return -1;
> +	if (ftruncate(fd, size) < 0) {
> +		close(fd);
> +		return -1;
> +	}
> +	return fd;
> +}
> +
>  /* Borrowed from mm/gup_longterm.c. */
>  static int get_fs_type(int fd)
>  {
> @@ -356,4 +379,84 @@ TEST_F(memory_failure, dirty_pagecache)
>  	ASSERT_EQ(close(fd), 0);
>  }
>  
> +TEST_F(memory_failure, dirty_shmem)
> +{
> +	int fd;
> +	char *addr;
> +	int ret;
> +
> +	fd = prepare_shmem("shmem-file", self->page_size);
> +	if (fd < 0)
> +		SKIP(return, "failed to open test shmem-file.\n");
> +
> +	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
> +		    MAP_SHARED, fd, 0);
> +	if (addr == MAP_FAILED) {
> +		close(fd);
> +		SKIP(return, "mmap failed, not enough memory.\n");
> +	}
> +	memset(addr, 0xce, self->page_size);
> +
> +	prepare(_metadata, self, addr);
> +
> +	ret = sigsetjmp(signal_jmp_buf, 1);
> +	if (ret == 0)
> +		ASSERT_EQ(variant->inject(self, addr), 0);
> +
> +	if (variant->type == MADV_HARD) {
> +		check(_metadata, self, addr, MADV_HARD_DIRTY_SHMEM, ret);
> +		ret = sigsetjmp(signal_jmp_buf, 1);
> +		if (ret == 0)
> +			FORCE_READ(*addr);
> +		check(_metadata, self, addr, READ_ERROR, ret);
> +	} else {

Should we always add a FORCE_READ() just after variant->inject to verify the accessibility
to the addr for soft-offline case ?

Thanks.
.

> +		check(_metadata, self, addr, MADV_SOFT_DIRTY_SHMEM, ret);> +	}
> +
> +	ASSERT_EQ(munmap(addr, self->page_size), 0);
> +
> +	ASSERT_EQ(close(fd), 0);
> +	cleanup(_metadata, self, addr);
> +}
> +
> +TEST_F(memory_failure, clean_shmem)
> +{
> +	int fd;
> +	char *addr;
> +	int ret;
> +
> +	fd = prepare_shmem("shmem-file", self->page_size);
> +	if (fd < 0)
> +		SKIP(return, "failed to open test shmem-file.\n");
> +
> +	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
> +		    MAP_SHARED, fd, 0);
> +	if (addr == MAP_FAILED) {
> +		close(fd);
> +		SKIP(return, "mmap failed, not enough memory.\n");
> +	}
> +	FORCE_READ(*addr);
> +
> +	prepare(_metadata, self, addr);
> +
> +	ret = sigsetjmp(signal_jmp_buf, 1);
> +	if (ret == 0)
> +		ASSERT_EQ(variant->inject(self, addr), 0);
> +
> +	if (variant->type == MADV_HARD) {
> +		check(_metadata, self, addr, MADV_HARD_CLEAN_SHMEM, ret);
> +		ret = sigsetjmp(signal_jmp_buf, 1);
> +		if (ret == 0)
> +			FORCE_READ(*addr);
> +		check(_metadata, self, addr, READ_ERROR, ret);
> +	} else {
> +		check(_metadata, self, addr, MADV_SOFT_CLEAN_SHMEM, ret);
> +	}
> +
> +	ASSERT_EQ(munmap(addr, self->page_size), 0);
> +
> +	ASSERT_EQ(close(fd), 0);
> +	cleanup(_metadata, self, addr);
> +}
> +
>  TEST_HARNESS_MAIN
> 


