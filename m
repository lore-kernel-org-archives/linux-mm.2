Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B907EC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93F556B0098; Wed,  9 Sep 2026 06:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916E16B0099; Wed,  9 Sep 2026 06:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82EBC6B00A4; Wed,  9 Sep 2026 06:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 636A86B0098
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:01:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 352BC14016F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:01:25 +0000 (UTC)
X-FDA: 85193781330.10.4C322C7
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf23.hostedemail.com (Postfix) with ESMTP id 94272140013
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:01:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="rqB/UWXa";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rAhR1QM/zeuhEomiumpssWgA9rCCG1Ag1irSYP33RaY=;
	b=kO++VZ+X5OHzZP/OGMRRAADUSnV/fbqzqOes/SYbVKqADnIc2sjjEUKAhOZxShiOEYbuiJ
	lkzVLMa4hwhTN0gWvFdTJKd14y/vt63uDfyHldabquynYqRW7z3P6zOmf6DCaG5sSfnXyq
	ydIPnbv27H799CMGsHSk53U3Li7Xffo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948083;
	b=h74wNTc8RHAb1OsxWxVBBYEXcmLW6Ke8jcwLzxaXXBhzB71hB0P4jKfjgx7/fuh9B+Vg3L
	QltiuSZhIiJTcdRL1yv2h6EskdU+0vHcthiDZm94h0lGxby3ka9mSKQGm3aW+J8K3FlMZj
	93w2S0+K8Dn5w/TYYDDNhMZebGmQfiQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="rqB/UWXa";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788948076; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=rAhR1QM/zeuhEomiumpssWgA9rCCG1Ag1irSYP33RaY=;
	b=rqB/UWXa2fZI+xuinX/rhU3iAORGmuzaLhK/eeY8CYVEOtvRt9BdFXzYWIwQmUEHJzTkeuXB3V1dcmX54zR8IIekqJw3WqIM5qWELpGdncawfFZYKvK3FE39xJO6dSNRzkoMf/La6Rz3iJlpzBTfOQ/Y5riCjiRcf2ivby+E34I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XAefrqA_1788948073;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAefrqA_1788948073 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 09 Sep 2026 18:01:15 +0800
Message-ID: <feb76c81-db9d-4a36-9a31-0b2b31e3c3fb@linux.alibaba.com>
Date: Wed, 9 Sep 2026 18:01:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/19] selftests/mm: add folio-order check for address
 ranges
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, rppt@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-9-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260908125105.1510704-9-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 94272140013
X-Stat-Signature: nydexrtm86ajo9xior7394aqqgpobtyr
X-HE-Tag: 1788948080-17867
X-HE-Meta: U2FsdGVkX18I9315eGK55M4I1hiUeQon24a0g/aJqim5SanguG26Pk9PVLvlb5fpCLwazZ/k0WSrhSuLysneRLAGSbHPmeyE25nn/9HVDCziwrifhF4WV/vWKspLX7ppe5h2LlYlUIFLsGVcsxE105xRREOYqH1Snf2RVkiSHFHRAvCmY/HLYm+OJNe7T1R9JHkjjtwXRKq7Y7650EviSkByZki8ELlo0H/73E6Hq0Fcf67sm9Wqr9auOYJ8idiFrK1Y+KmolzXo++mpbge8gKStgfvyl2DOXl5vz0JiujO9zRkoOY9y9vJ59q4O8MIqXH+74y6LJdHxYkofHiD0Q1Q+FvAVcaC7rKBnEqyWwhszoKDyS+m6FJfplmWDd1y8ZjPkFLW79VzKqpzOdgV8p66pLRs3IPxU1JwkjcE5J1r5MIzCo8RoncaRKrbUmH7557SUKTVMAxRBgfz5eby7KO1Oa6F7sc7YmW6Y4a60MRNA8mfMlLHZbYqwyLV3lyZBlQGAe/zjb9pf08m2NPBHNlB5mY8DAPWSYOpieP8EusSe66ur1sGk9i70sa/SRsO7SMwxciqYwrS73iUZhr8EB1VC0g2fqV6U3d5u30hl4LoKue9uZXv2i1KsNm2tPybPtgf0OwxlJvlnjbOgDYHdfPZce8ipeMS4ooYrfbxOVtAP6jXwwwLbuzvwGuy8GA7Lu1I+5xqFsY7Uq/riTomsMSH2Fn7lWSqPqagS6gzbVyaKLHwiSxeNy4Gg5yjPOox5oQDhSGxYa3Cy/tKx8yDEca9Zc0wjFUo5vHJaxrOkAGrirOdXqHhVXR3L7dWX+69vdQMdhuaatPC+9u3CQQSPQ+c0NQWI/Ozi+7C+Va80cdrXd68ANYPk4DZusD0L3NtxkCzbwUkUvi7ocOY/PU2TkdWxUZVreTLVr27ahRH6fbadcS6bhUpWzh6og2NSnaemwHSUZg3FN6LKIEOFzHm
 HLPlZWA8
 c0Qu3zUmbLpRdt/CXD8ZYIyULdNm0wd/SPMK182vmdaMwBJXq/JRMw4Rsk4otkKLR20ZAgvukQNQfO+ihX4SO5ero858E8weOUjoxJJShN105I2OaEaXPU9QLeSofF7C9HbqLZYeN9R2+3zJLzPWdS/KFULi0n+OYsJecfugrwq0+O9K9I5EBm7MFM67lZDZMMLZ3Phcs78sy3HwQwUeeUwdr9bH5ZLZ6wIDetz0WFk1XDxt2J+IdLZz79b3aFJhkY0KUBfhRVdrBFBODYEH2XmHNDwDI/fhP13MyXZQWRVy/GeND35RACohbiaRguCaYXDP3Jp4Ne8b9UGK/GoHWqKUVzkZDsinXgFsUavvzoZl7g9aR5DRdzeU5VQVFaGSTdqfSJ/IAJ0uYuElxNreh+ZCGyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> An mTHP collapse test needs to know that a range is backed by folios of the
> target order, and that they sit where a collapse would put them.  Nothing
> answers that today: is_backed_by_folio() classifies the folio behind a
> single page, and check_huge_anon() reads smaps AnonHugePages, which only
> accounts PMD mappings.

Have you checked check_large_folios() in vm_util.c? It seems to meet 
your requirements, or am I missing something?

> Add is_range_backed_by_order().  It requires every folio-sized, folio-
> aligned part of the range to map one folio of that order, head to tail,
> with the head at the start of the part.
> 
> A part backed by two smaller folios fails, and so does a folio mapped off
> its natural alignment.  The mTHP cases need both to tell a collapsed range
> from the one beside it.
> 
> Assisted-by: LLM
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>   tools/testing/selftests/mm/vm_util.c | 47 ++++++++++++++++++++++++++++
>   tools/testing/selftests/mm/vm_util.h |  2 ++
>   2 files changed, 49 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 3ea42a7a2a3e..4947612e8b3d 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -552,6 +552,53 @@ bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
>   	return false;
>   }
>   
> +/**
> + * is_range_backed_by_order() - check that a range is backed by @order folios
> + * @start: start of the range, a multiple of the folio size
> + * @len: length of the range in bytes, a multiple of the folio size
> + * @order: the folio order to check for
> + * @pagemap_fd: open /proc/<pid>/pagemap of the range's owner
> + * @kpageflags_fd: open /proc/kpageflags
> + *
> + * Every folio-sized, folio-aligned part of the range must map one folio of
> + * @order, head to tail, with the head at the start of the part.  A part
> + * backed by several smaller folios fails, and so does a folio mapped off
> + * its natural alignment.
> + *
> + * Returns: true if the whole range is backed that way, false otherwise.
> + */
> +bool is_range_backed_by_order(char *start, size_t len, int order,
> +			      int pagemap_fd, int kpageflags_fd)
> +{
> +	const unsigned long nr_pages = 1UL << order;
> +	const size_t folio_size = nr_pages * psize();
> +	char *vaddr;
> +
> +	if ((uintptr_t)start % folio_size || len % folio_size)
> +		return false;
> +
> +	for (vaddr = start; vaddr < start + len; vaddr += folio_size) {
> +		const unsigned long pfn = pagemap_get_pfn(pagemap_fd, vaddr);
> +		unsigned long i;
> +
> +		/* Not present, or a tail page */
> +		if (pfn == -1UL || pfn % nr_pages)
> +			return false;
> +
> +		for (i = 1; i < nr_pages; i++) {
> +			char *page = vaddr + i * psize();
> +
> +			if (pagemap_get_pfn(pagemap_fd, page) != pfn + i)
> +				return false;
> +		}
> +
> +		if (!is_backed_by_folio(vaddr, order, pagemap_fd, kpageflags_fd))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>   /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
>   int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
>   			      bool miss, bool wp, bool minor, uint64_t *ioctls)
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 56a28ce7d029..e509fc4012a5 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -99,6 +99,8 @@ int gather_folio_orders(char *vaddr_start, size_t len,
>   		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
>   bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
>   			int kpageflags_fd);
> +bool is_range_backed_by_order(char *start, size_t len, int order,
> +			      int pagemap_fd, int kpageflags_fd);
>   
>   int uffd_register(int uffd, void *addr, uint64_t len,
>   		  bool miss, bool wp, bool minor);


