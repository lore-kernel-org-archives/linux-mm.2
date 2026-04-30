Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E40FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 17:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EEF26B0088; Thu, 30 Apr 2026 13:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6816B008A; Thu, 30 Apr 2026 13:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DCCC6B008C; Thu, 30 Apr 2026 13:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FAE86B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:33:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D176A0189
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:33:46 +0000 (UTC)
X-FDA: 84715919652.27.EA693EB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 99C41140003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:33:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mw06pZJU;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777570423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmMXCvWSvShhSGiDPE3bbKH2xIBX1MBTYvUc5Sk23wc=;
	b=2fAedDsib+p1CovhWX0rCuj8YIUoeBWZXocxXbSRVmJpxXXyda40ZJift+9fQ0PRIIzG9i
	OaHiWUUlDJ0XNePKHNy2dXkYHNgtc+4UgP8owcpcZXMxDuMIBosSHsbEH5gN4ENEP+liEb
	vrDreRbF3x+fsqY8YcMQPhiRK6oPrMU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mw06pZJU;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777570423; a=rsa-sha256;
	cv=none;
	b=4puJJAypMrGJ+YaF3YVfjXSX29SZm9QGZ2bs2ZX16Ihycl2fb15K7fMOF0hehky4qHFaEs
	0XEpdkQMR0sFKEWYWF5qKK6sW7vgMLcSBew8IY3WJNvRKtpaLX4jzv29leA/1FnjBhFIrE
	y5gECLEdwQ5V4ZIpOGO7pk+tiXeRQJc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777570422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nmMXCvWSvShhSGiDPE3bbKH2xIBX1MBTYvUc5Sk23wc=;
	b=Mw06pZJUddj/w+OmOdYk0bDhVXb8pxnCbpCgPIyt5uJ/E218RxUoBooMj8bdlsZrKg8BaP
	H7qCDLAE7KKyuFkUS1JGW0mHa+CpOPNi3CgxmVyjf5/gSBhh22hpU1B/2FGgJ+8PyzNinE
	ESq3+wRBqGw8AHVLrR8h5ppEymlvUaQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-2Pua1p-IOOWGFD_zLZONkg-1; Thu, 30 Apr 2026 13:33:40 -0400
X-MC-Unique: 2Pua1p-IOOWGFD_zLZONkg-1
X-Mimecast-MFC-AGG-ID: 2Pua1p-IOOWGFD_zLZONkg_1777570420
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8eaee67d1afso135676385a.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:33:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777570420; x=1778175220;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nmMXCvWSvShhSGiDPE3bbKH2xIBX1MBTYvUc5Sk23wc=;
        b=hBmM56ojc8MSnUuejb51J3yULMSwDtngoo8foZ/dBM4Lt1FyXI88Hcs3u6XraqR4on
         F9/IaEcyGBJXw07fxR1/8D3YAMAIG0CkVUpT0R4/nU5+9VxaXz6BXxwa16gmUREcfBSe
         iOG1wgJ+ISaDTd7Tqcp5Y3FWvL/e+UbkI9ysS/RDpks+mvORoH9r9r6GsHN8AgNv8xGf
         044JiOTNRDLl/gVhr7nvgJntDJsz9mTn2sj+WjOYH94KRH/ha0Xatr1gHhJBPaMU6rIS
         AfoeRKw4uSpXJwQX9KqClfRHUPY2NrgYx2q3qGwCA8kihq7C+8yRPof9dlWg0OhQaTQl
         ZZSQ==
X-Forwarded-Encrypted: i=1; AFNElJ8RRrKDHE4JvOQE+7oc3Q0itZYnOrbLELidJaYQBXn/VaEfdg8pGrlKpuSw3Vs9Gg5Acj1vF3kLGA==@kvack.org
X-Gm-Message-State: AOJu0Yy6tFDujYB+PtvUNceiBEF0nNMeoYrk2Oxt+d9kSeuZFnQ9zZtg
	3HtAFocB5Rmdrv46nX/7EEBOHwA3hYnnGzZFipDHGtifTHYrRnXDT++fepahXo7+o97YlTv3Vy/
	Bwws70XlJ0DrzXKHlnWXstiGU79LEMT7KRZ+HIPyBc3XGSRjJP6hr
X-Gm-Gg: AeBDieuKmHGN5XHbaz9vIQ/Ri5/9sZ4qbX1ZYRvpyLjUKJowtjOWmDzjC+4wfcKKFm1
	wkmikDDqD+khPx3ZUpvLStmJ0JesdqRmMhaXAPUKVkjNGICUfAKNqlJtSJlawqGPnkfUsTbQ1K1
	eWUVswEsT8ZQowsZzSG1AdhUPEak18OWoX58IdcCYVODE1lVk07PVQDSMJjT9ymd9126GUTCCxR
	0dhbd+++j4GdHUc0XfqVeBn5z6cJ/+BVGfyLovbZRSzP3XF3XRJgWRYpNK0D7D1O/aEu32g5Rcq
	qKUUdgJaYmDkF3llCHqH0FCkr+iRTA08hU3d9GYWsiczh7M/Yr39Fdnx+o9ej9HAYmwP7Fe6X24
	t+hr5+pRimB/IgQQU5AiJ7CTdxUwlfTXyKO/EVhqwc4n9WVGEWpDaDlYOYpgDjRUg9yzATpn+nD
	EwnlxH+TRXaMNzD+e6EbY5Z3Y=
X-Received: by 2002:ac8:58d2:0:b0:50e:6054:bc with SMTP id d75a77b69052e-5102ab43dc2mr57370541cf.16.1777570420035;
        Thu, 30 Apr 2026 10:33:40 -0700 (PDT)
X-Received: by 2002:ac8:58d2:0:b0:50e:6054:bc with SMTP id d75a77b69052e-5102ab43dc2mr57369551cf.16.1777570419456;
        Thu, 30 Apr 2026 10:33:39 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5103d1c657bsm812311cf.3.2026.04.30.10.33.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 10:33:39 -0700 (PDT)
Message-ID: <1ad27a46-543b-4799-924a-c13147bf68ca@redhat.com>
Date: Thu, 30 Apr 2026 13:33:37 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 25/54] selftests/mm: hugepage_settings: add APIs to get
 and set nr_hugepages
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
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-26-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260428204240.1924129-26-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JgJzVEsypoZWpbasKFqz-vnCcVQTN-JYYfUAr5BcEIk_1777570420
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3egj3nsd5sgcpt4it4rxzcwxnqwmot5q
X-Rspamd-Queue-Id: 99C41140003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777570423-914706
X-HE-Meta: U2FsdGVkX18yC5lZrRxXuOaB1ll1J9syVXPdTluKNCw1byKALVJ7+OcYJUqVt+qfESDu/rVjQnaobGQL2PyKK9BTMgOhRL/ZGAR0Pgp7RKxB4UC+W3eO4+CaNC1NNejT+iLPKQrYvQQd6xzm268BRhIr9t3yKZuLmgv94MlcBJ34WCj+XU646r5wQi6UTlxyfL74ZiZ6++FgtbpVeQ7yDIsqDrAkuTFYhCrxBbyE5lzx+N07RdVtr474+eepakbfBFmueDqnt2XMknjg/RO5fXngam0bSyCJRxWBp9XF/etKB0TqXaB98iZxRZLhU/rbUiy1KerYDXe4f24em0r39HfDPT7x+1yIfFLXFMj5DPszXBbyPQkmpUL5U2FIjijzVkeApMbceilO8sHtQPRoFTdlAhVVOZj/d1rB7FyYeZIIgGijpl6rY/+G8kxd9k/r8dKg57cySAazefv9G708do9aq08LwoN4Ehub9I3sTbV6a8gkHqvtxMJwy/wAG1fPV8R7axpnRX1ZbDSt3GQWnSg7omdDvu8gy+C3ftUyQEVARLzk5M5mBo1X0Nj6LrUka8/bwOwodIb7XLTvYt1gCqpXxJjvZ6FifBxWQ/DlGpKQJul8aM/Rz5KZHOtH69laPE0gsgmn28jrpUPxeSPqo1ghtG0wT5E4vP0bM6uOXK3ZafakC51Mdx3quruvwIv9IQcNjDueNfQEQVagmAFfLzzylpuXp4BCm9gqwLFhpxDp4XlsVzDjywXLP1zNFFSyYsgSHNQX4V/i8Y/2qwqku/LG5ucIYVjBxyuuPvVzOJesp8DEVDWte+g6mTJEaY8cyihaGHc86Dkn6GSLTCxmIrCr3glR9ZVmx5w5XG7Y0LgIeP83Ms05/g4VGfJmDGucDq9azV5mgPwpCt2lyMoFY33Uw0e7lafgn3b9lnSTad6fhj+a/bTrK5d4e1kYbKGspQkEx8fxlN91wdwuTxZ
 bwgMrfyd
 q0A/WiQvCaZ0PkZJBdgpIcSLH+b0SgB70ICrg3CtgAp/5Szvs/+1Sy/88uBRYFNn2Mzig7KTu3wR/4M5+fcuRQe+mvRh98dkXNyKP9XXuNG841YyjhzGcXjIXom9qCfmQYKaBqNmjUDTU5EhNG9Lghj0CdxJx3Z0GzuUnR/ELFQ+3WaUwMmMKD6zU+zdTPR21s4l5x4mYplSX5avTOhdHiFiA0H5XoAAYuy88G/KR9SpsQgjtDRehzRlHNb5fSAIj733FxRxeSXbGa4+LcbG02c8itTErv1sNdbPAv4GhqfW5Nup10TF79p0Qiw+U+W9CJB5eR2+QqDN6lsrQq69zB8pHDB8biAQapLfrBG8P/wxKjVTBEPpSs3jR41uFIr4MGd2heaU9Ax0nK9xeTc4oEcRSriZ+jzvDeYZMgULIep4NCgE0pV7+KXrRBu3u/OvXR3utqGv4F5nQBxzusidgWMqRuPCGEG9yOgpNcXKROR/TDLD6WyUOxNagYtuQZEqNCZtfRhd233BU5hDu4cmka+lL/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 16:42, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Add APIs that allow reading and writing of
> 
> /sys/kernel/mm/hugepages/hugepages-NkB/nr_hugepages
> 
> to detect and change the amount of HugeTLB pages of different sizes.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> ---
>   .../testing/selftests/mm/hugepage_settings.c  | 25 +++++++++++++++++++
>   .../testing/selftests/mm/hugepage_settings.h  | 23 +++++++++++++++++
>   2 files changed, 48 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index 8f563315b1fc..5961229b9931 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -464,3 +464,28 @@ unsigned long get_free_hugepages(void)
>   	fclose(f);
>   	return fhp;
>   }
> +
> +static void hugetlb_sysfs_path(char *buf, size_t buflen,
> +			       unsigned long size, const char *attr)
> +{
> +	snprintf(buf, buflen, "/sys/kernel/mm/hugepages/hugepages-%lukB/%s",
> +		 size / 1024, attr);
> +}
> +
> +unsigned long hugetlb_nr_pages(unsigned long size)
> +{
> +	char path[PATH_MAX];
> +
> +	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
> +
> +	return read_num(path);
> +}
> +
> +void hugetlb_set_nr_pages(unsigned long size, unsigned long nr)
> +{
> +	char path[PATH_MAX];
> +
> +	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
> +
> +	write_num(path, nr);
> +}
> diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
> index 9357d07e6c1b..d6f41a45e8ee 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.h
> +++ b/tools/testing/selftests/mm/hugepage_settings.h
> @@ -94,4 +94,27 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max);
>   unsigned long default_huge_page_size(void);
>   unsigned long get_free_hugepages(void);
>   
> +unsigned long hugetlb_nr_pages(unsigned long size);
> +void hugetlb_set_nr_pages(unsigned long size, unsigned long nr);
> +
> +static inline unsigned long hugetlb_nr_default_pages(void)
> +{
> +	unsigned long size = default_huge_page_size();
> +
> +	if (!size)
> +		return 0;
> +
> +	return hugetlb_nr_pages(size);
> +}
> +
> +static inline void hugetlb_set_nr_default_pages(unsigned long nr)
> +{
> +	unsigned long size = default_huge_page_size();
> +
> +	if (!size)
> +		return;
> +
> +	hugetlb_set_nr_pages(size, nr);
> +}
> +
>   #endif /* __THP_SETTINGS_H__ */


