Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE34D6CFA2
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 22:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13BCE6B036E; Thu, 22 Jan 2026 17:20:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BFA96B0370; Thu, 22 Jan 2026 17:20:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F033A6B0371; Thu, 22 Jan 2026 17:20:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC42A6B036E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:20:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E55114886B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:20:45 +0000 (UTC)
X-FDA: 84361020450.15.FE9A16A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B1B4420007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:20:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bot4zvaC;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769120443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8z8xGH6bXPgyCs41qa7c/SBy5H2xt6ozRAIrxxfMDXU=;
	b=D+O1gUzMEKhmJATwFFWx0O2wvV0/+X1N3y/3K3pc3hOAst+6/E4tJC4MWglIF1Z/AR0HHs
	Oxo9Px7rTfiYZnSD+mi46J3jaY/uMiMgEA+aPM2INAN1fYfRjxY3jMIfnQEto7tZ5ebly3
	go5G8RwxYREdIKr08HsaSJaSOl/JYII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769120443; a=rsa-sha256;
	cv=none;
	b=ZgwKGEzEUyMyka8/vXVI2c/Wpy7Kc2foZKPjk+HOlUOBgEyF75kN4J+5NMF/MjV0I6joji
	PcgyyVMAfK4Eq0YCG2PdqxHW+8k9sMIGSaFt7/cBcN39ZMgDmKjs9Gjq7q7HGTljL51eb7
	MHO/DTvDQDicofraXUkcF9gjqEe+/6U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bot4zvaC;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBA68442D8;
	Thu, 22 Jan 2026 22:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFBEC116D0;
	Thu, 22 Jan 2026 22:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769120442;
	bh=jzu4EH9RtPfER/4dAwUxG4EpQcz1B60rHGCR3ANTIko=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Bot4zvaC3VKoQCkLVxiMMW57UXfYBtgw0ff/qIvN9YUd5PizoNdJ2lOXAB7I+Eq5P
	 GeQGgKlAh/CUAujvoR5vWMknR84HktdPw+yWM+Np72+1j9pSpEGXwR4ftwFU684A+T
	 b66lWoDIiNsxQfM+n+7c034mIxqKRz/I3iw86yAtC9ovWh/obpnQkojQRyH/YM5M0U
	 vIgBpuqbmjAtcNyC2bXLyWchPWAa8ypelg+YehL5g/sha5YZrTXacEr2ej8490a5/g
	 du51+Rr54b/fwdu7okY3/2IC833rg6+rmcv21mpD+JypUnekAoqv6F7/HF+sqNnLqe
	 c/tNK2R8Np7lA==
Message-ID: <a4c83b16-3307-497d-9690-0e31672f3202@kernel.org>
Date: Thu, 22 Jan 2026 23:20:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/9] selftests/mm: introduce helper to read every page
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Mark Brown <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
 <20260122170224.4056513-7-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260122170224.4056513-7-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B1B4420007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: bkeco6mn7bgr9hy3my4sbcyz8txupe1y
X-HE-Tag: 1769120443-48043
X-HE-Meta: U2FsdGVkX1/YlmWwPNZervrk83MjxH2errhy7a3uwEwMCTeWYHnjUcjyF+P3LLVrwogbn4npXzP8Pby+U+ukOR/3g84sd0KVAHdktP6s8SRfn7Ggi9YJktiBAOvE2nCr/4nzYWXhLSf4eF1AA/xMf+OV08CrSOdT4jFCfXCs1Rp2ioVDRr/5SqMlzD0dw/q9qoKNxPE3mhpft3hcA0JGr5huicu5nr8WJ7Dqk6vWH3aoQ/WG8ioyUnSC7aOyow/Ord876tTF/wZupA+9hFRmvnsbgjz/Y5GZgGstSiNHINshPhs4S+IsJQIHnkxY/peAlempkmQaqocjLXsVZ1qaurXsX9kUSBz19DiedDrJ1M51QMhGSbeeX5GV19ujd+9yAHYtYThMrHpocKfbW55mBZ7KhoOvyXhOKmuEHtkTHuToSY6NhnS4wYGmMFRSBXcY180dguU9qYChbZj4+mAaLb2URHUkum1oKqY2wzlsNZQ4IOyd+yofrAW898zQDQxQorYVndxWUxvr4Ox1ZcuDbru05RhsLG6BA4kwcfeISfx05My74Pti9HcTtp6lJD18MCxJ3RGbg3BBFl5OSGlfCGTpkkLGowzH08SC/5iF/SoFVGw8RW1/IPpQUABPFN/Kp79P5vp9B/dzd7X3maEHig1kstYQeKqA5E3dSv0AcCwBjpWBR4XaGjT+HCAGZvrqrxGEQJtTDm/VlyW6p+k+eYjKXTi2aiLZKWqFaQFpr3J51AYdou5D6UXskse+kSA4Jkn8WKJIGVcTyTFnhDtBFeV7ygQlht78MBOGSSOYmSJ+jvNIRskHnQkm2VJ1SZRqD0dzS/wQgdpoxqtlPA5p5slTYus/muAek/4NgCqJt0bgWJSHX6l5ABnoZI+aoHkdWv4suIN99voSRXBUJ+4p/IHoer0Zp8JO32E7bgEyA6tzGfcuY0NfMTDBc+NbrpL7xtJDiv+v1y2cjUPMKve
 y0HjZSyM
 sHcnroAjx+kIoRj8hVPw5yvJv7MtBHY2t1/W+RJ1nTrzVdmXUB5Fo9XyYLbIuNRq6f3IvI3wuFwyZQnknrS6mWAEUl+XfkLfTYSiyhbWNCw4Iehg2BDiZoaMwhEAD4AMqoBpJkX1fydYz1Kkcxr6vGQ6cTUyK56krt+bHI3Cqghp2wtfd1p7CH7xxKR0VmTOjT5aU7tEkTKV7Dhoiseb46sW7mzN/+UWkhp/SpRGy/7zTJMmj2FM8Lctq0IIe/2c8Q+PYtzZbgM52zSrgxpDypmtxk4hjTUCmCvySk62qsVNF8W+hFblCq0ap2DkqH3oqrQppw5Yy0rjocyOSSYBlj0IeBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 18:02, Kevin Brodsky wrote:
> FORCE_READ(*addr) ensures that the compiler will emit a load from
> addr. Several tests need to trigger such a load for a range of
> pages, ensuring that every page is faulted in, if it wasn't already.
> 
> Introduce a new helper force_read_pages() that does exactly that and
> replace existing loops with a call to it.
> 
> The step size (regular/huge page size) is preserved for all loops,
> except in split_huge_page_test. Reading every byte is unnecessary;
> we now read every huge page, matching the following call to
> check_huge_file().
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   tools/testing/selftests/mm/hugetlb-madvise.c      | 9 +--------
>   tools/testing/selftests/mm/pfnmap.c               | 9 +++------
>   tools/testing/selftests/mm/split_huge_page_test.c | 6 +-----
>   tools/testing/selftests/mm/vm_util.h              | 7 +++++++
>   4 files changed, 12 insertions(+), 19 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
> index 05d9d2805ae4..5b12041fa310 100644
> --- a/tools/testing/selftests/mm/hugetlb-madvise.c
> +++ b/tools/testing/selftests/mm/hugetlb-madvise.c
> @@ -47,14 +47,7 @@ void write_fault_pages(void *addr, unsigned long nr_pages)
>   
>   void read_fault_pages(void *addr, unsigned long nr_pages)
>   {
> -	unsigned long i;
> -
> -	for (i = 0; i < nr_pages; i++) {
> -		unsigned long *addr2 =
> -			((unsigned long *)(addr + (i * huge_page_size)));
> -		/* Prevent the compiler from optimizing out the entire loop: */
> -		FORCE_READ(*addr2);
> -	}
> +	force_read_pages(addr, nr_pages, huge_page_size);
>   }

Likely we could get rid of read_fault_pages() completely and simply let 
the callers call force_read_pages() now?

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>


-- 
Cheers

David

