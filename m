Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EACC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 05:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700856B0098; Tue, 22 Jul 2025 01:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8546B009A; Tue, 22 Jul 2025 01:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6156F6B009B; Tue, 22 Jul 2025 01:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 508BB6B0098
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:59:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEBDE1A02A7
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:59:51 +0000 (UTC)
X-FDA: 83690849382.11.631024A
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8BCC518000A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:59:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="vuIvF/Ua";
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753163990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySiCGZAtj55OzR0IrY3iVRy0mm6ioSQe3uf0JRqArwE=;
	b=sl2dLodqBu6F4PFpZCZCWXB586j4+dpuDNui6kltkgMswXJjD/ndbk5X3dtpXsPxDWueQz
	vIOrgm4PS41GRMfbzB798W1v3DFVb/3k9MjfCEk2LnEzvE6PEuOSrja2JGBxh/eD8L35QW
	khi/vN/4gzSLhnJz+vSuzM+d6jqoABk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="vuIvF/Ua";
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753163990; a=rsa-sha256;
	cv=none;
	b=69KOMj3JWfNU2lkAlZrjo7maF9LL5gFJeWKgPAiHq8rgoBtHJKT3iY4qcWNieQhrrhQW7x
	cHTtdeu5WXLOygRcv/cNwIKyN51BV4G1yT/nB0KaZwbeWXg/UxO98dt7QhY94Q8kl5uqbO
	6Zcu24OIrljqF6q4AJSCzfyP8h4qpJY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753163985; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ySiCGZAtj55OzR0IrY3iVRy0mm6ioSQe3uf0JRqArwE=;
	b=vuIvF/UaQTc3wtsY4ytJ4jHFV4tEjqPsCWdejektLv/z4kx7PpRpsHDI0r+VlgnAPlm4v+SEh/Z4fXM50uyAYqV8KH8fRas6WuAoNkaJOjpHyap/+dXBiyeSw7D27v6w4SSg+bT2r4mQTZ6oaKDiJsvLVjyw5lXkQK7UzoB6t54=
Received: from 30.74.144.108(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WjUhTET_1753163982 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 22 Jul 2025 13:59:43 +0800
Message-ID: <bea04294-3302-42f1-ade1-e4ec6aa80b99@linux.alibaba.com>
Date: Tue, 22 Jul 2025 13:59:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: update THP documentation to clarify sysfs "never"
 setting
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250721155530.75944-1-lorenzo.stoakes@oracle.com>
 <d54d1dfb-f06d-4979-983b-73998f05867e@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <d54d1dfb-f06d-4979-983b-73998f05867e@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BCC518000A
X-Rspamd-Server: rspam06
X-Stat-Signature: 9wufyhpkoc5ycueu4t4mc67uhcfkcwge
X-HE-Tag: 1753163988-758075
X-HE-Meta: U2FsdGVkX1/iFj54DLNYx98KITr49LDug2nXoN3sUvspAcg6sq+XpkuZap4pYBFvQN/1UrhhFOxp4PobENAPCCgxyBXtMP72ZXYI2ZwWIUp6GsD2BOAoezn3zoXTjXrqk6+jzO6lKlKi4ExpP8T2hLYNsnZE3Ang0VPuCF95fClo0t06nOtxr0IxFiopBugvqBf49PIVXm7m/IBeen+P8B3QP46XxxiAH19S7PTcS1Wdx8hEXnYVVdRwQCZC4Vi6FB1QD7VKj+Tl19FsjGH4pjiubz3iShX2tRWPDxX6MK1bWX79p81a7lIHM+F6PLziarKZXJlkTeNEfW3EDqO2OunFK2E8oE75e8PjtB0qhvw1yNjPAdTezI5J9np1rgygxmmPs8f5/18UTeZ2omoBI1uugck+/e/vaqxt0o/p4Xz+PCQQjC+0FVqDljSvhrircFPLnlJNjW3af/kp1hsUE78oKsS0OnYpXfh+fNu52CYulJt2RZ9gT+JuIFJA3ovJaIXV9QVlA1usp3rKTxTM2HAbPXCD4XWuHHJ3nh8W67z1lerDiNL6L4Xgyrf/JGI8OXL+Xqc7mBmhh/elkA7pjzebo8hCBfOycpnCDb37YbzghWqudLPIyH3Bq4+bJUPfuZ/E3P1UbfHEybCsZ+h6Npmjm5vE/YUawFkJN5QeD9emfSKO8m9utG8qPtpmjpgBsFbWtzP0zqZmzVi+JOMT1mpzO8ahYuq8Twh6bYB8s0UnuM0MYHNQbutuswraKl65pWYNWshLl3SjpgluWTEnAxq6gZ+5Ij78AN83PfRL7fppgxR5950UiwpgogYsF1SANXbBMX8ZmrhWictgdnLN4F0rlq5ckTW6/DMCe9HlzMkAt6MjpW5A6mrrEXYQUUcOGpdQFc+hqRFO25g53KxLz9ABDxbj+X72Y1koPlWNmBRGFFi9QGzHlAHhgi2gxCyuexlIwDKzN4UJdKsRT8c
 eC72H63b
 h0cOCzi/edzZ5DPy27acVjqv87ZMY7HPlP5t16FtiAHhqdzXbt/vTx84/Sr0GkdmfS3w6XoqPrZ3VnvQazVceGvzRxFgSUwHzEUql5NX3cvV+aUt66Lrpcyz0wfUbUAXxpc0uWdtRgIIhdWHQTqFb83aS1WodC8TW0YxWIvQfEAVgBklCN1Fv3JEB1r38TsFImN9leSl35SjjXtCng5oh0QhSB+yjYxrwMCXfASEYdtiEN5fV0VOF3SKKu9TsfDqEh1JtwGvrp42JkS2YTOtfJ4BDN3+Vjj9ppXpHarXDSm1uVrOiLtWLP2oYR3WZKFXPR4RfRcdrCSOaov7aWmfnM4M0Dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/22 13:34, Lorenzo Stoakes wrote:
> Hi Andrew,
> 
> Could you apply this fix-patch? It adds the caveat regarding MADV_COLLAPSE in a
> couple other places whwere the sysfs 'never' mode is mentioned.
> 
> Thanks, Lorenzo
> 
> ----8<----
>  From 7c0bdda6a633bc38e7d5a3b0acf2cef7bdc961af Mon Sep 17 00:00:00 2001
> From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Date: Tue, 22 Jul 2025 06:32:18 +0100
> Subject: [PATCH] docs: update admin guide transhuge page to mention
>   MADV_COLLAPSE everywhere
> 
> We previously missed a couple places where the 'never' mode was described,
> put the caveat regarding MADV_COLLAPSE in these locations also.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

> ---
>   Documentation/admin-guide/mm/transhuge.rst | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index 182519197ef7..370fba113460 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -385,7 +385,9 @@ always
>       Attempt to allocate huge pages every time we need a new page;
> 
>   never
> -    Do not allocate huge pages;
> +    Do not allocate huge pages. Note that ``madvise(..., MADV_COLLAPSE)``
> +    can still cause transparent huge pages to be obtained even if this mode
> +    is specified everywhere;
> 
>   within_size
>       Only allocate huge page if it will be fully within i_size.
> @@ -441,7 +443,9 @@ inherit
>       have enabled="inherit" and all other hugepage sizes have enabled="never";
> 
>   never
> -    Do not allocate <size> huge pages;
> +    Do not allocate <size> huge pages. Note that ``madvise(...,
> +    MADV_COLLAPSE)`` can still cause transparent huge pages to be obtained
> +    even if this mode is specified everywhere;
> 
>   within_size
>       Only allocate <size> huge page if it will be fully within i_size.
> --
> 2.50.1


