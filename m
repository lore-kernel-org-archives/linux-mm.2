Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F40C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19E96B0093; Mon, 21 Jul 2025 21:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF11F6B0095; Mon, 21 Jul 2025 21:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2DB96B0098; Mon, 21 Jul 2025 21:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D32F16B0093
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:30:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87D07160217
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:30:27 +0000 (UTC)
X-FDA: 83690170494.25.0D2B2FF
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf24.hostedemail.com (Postfix) with ESMTP id EC2B9180004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:30:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o4gphrwF;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753147825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yDsSa2vpjdL6lUQSt7fc1x97fEipTiYa9vEWTQ5DbBQ=;
	b=VUqNhmk2V3hCBLFQ2FZj9TmCF3DFljN312j62o5zaAMQnXFp0Py9cHktwDMHlNMnFwqzbS
	2fJZ+4Eow8Jvlgfm/dcx2sTo0uzaNgmUGWZ04V3dSAZFx2ww4gUMzP/hHPzzEet1yzHzRV
	+Se+uKjztmcy2agEIJhknxGutKvu7Mo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753147825; a=rsa-sha256;
	cv=none;
	b=LcwAD+cXgiGFm0Mph0TSieJM3UfYX+WDINsZJzM5+z6Wvm94n0y49jqPwfl7savTewkOf+
	Vr9MIeiTZZ5/C5I6W75Ah+KBli3mTiQNf3CY19L8L+CnajS542lc5u6BEKqHSgpB1y+6Hh
	jLTwtnlVIN1Vvhixb5kHQlsmaFzPMn8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o4gphrwF;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753147820; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yDsSa2vpjdL6lUQSt7fc1x97fEipTiYa9vEWTQ5DbBQ=;
	b=o4gphrwFiXp9nizZMQiw+jqj6vAvh6WC5WSuMc+fux5+3av9CyYTCr2l17kLOpkKVzxMkeQ6dDqSRbGAok6VGNCydL2grKGY+goZAvh1jmxefLiIVEuiTTqHd4DyoJoa15k9kRzKh9s59TqFLGXL16e3cvnuj3F7Hp8vo/m6t/k=
Received: from 30.74.144.108(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WjTedEk_1753147818 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 22 Jul 2025 09:30:19 +0800
Message-ID: <35df32ae-dc95-48e1-bdb1-90f17bfd4d5c@linux.alibaba.com>
Date: Tue, 22 Jul 2025 09:30:18 +0800
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250721155530.75944-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EC2B9180004
X-Stat-Signature: zo97fdqkmrm7xwktita5g9yzxjtq1a44
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753147823-943899
X-HE-Meta: U2FsdGVkX18Rb1N9mMED1mi5rXmEgEVn7iFuXlY01iSl5ykxpZRpZoiLN20zYUPS5baZ30gRW8X48jZA4LbrcEvV00huwytLqsWtg0AeBc548Whrs0B4yCOJbnoeGmM09w5Vej1wOan/KqKi2/EaVn9fMhEjExcOYlnKrUS6L4RleA+QrBzZguqCvGY4HGZmhyP5dqldjS5MjJ6QyGhmxikEgXeoPAKKLK6Bmd9J360AdTZzJG8vd82rUGrEU/djgtPjo5FhmHvs/h/7Qi7/dI8qdkPpmSQJf4Hfr20uHl5Ox59G3dnMiZsMAiKW366e4+20i7IKzUbuhJpeBKPmVWA0cgmFSruvZfkQU+JPdgDXrpjzhF6q+CF0T10+M48r4b68gV4zdsAMWPQGqElgm68ZV1SBXyquZwMydcGZpKR0Sl1ERi6EYHCLlbOmHtx/8Rf3cpL8wAONdC5bH4vA03Q3G8E5riT5LuUzhxxbWRszWj4xaWvw6bPZBp+S4YRjXFrDvzvb2CjBKpPgMR967+ZsmU40o8ZSNTphmuUC9ManLcO+HbrJe+COEhklzVio0pN+9GGo1Jojgs7i7i092kmKYWXm/yBZlkz1ebfyzu0UjLBBe8RXVn73JQ3qE2ac6WZiRVLxVUUHlklQ4flPsRR0laOtpk3KSzoD0HMgWnSOrYhaQsvpM5LvJf6USnNbg0YEnmOw3dYPq8uvdk6gz/3q11nui2apvn/nthvX/8XoOYEeqDXHNcPTbF35v/SSJXGTlbxsO6CGm4m/XnbOiC716HPdCgL0ficIl3q1mcsmXx/wqMGAEZgA2+KkobYffP3sGCWttwBVsolZjr/r4kBsYWpLlyTmURNJjIj/7d1eKYzVNWreffnN2yRVq18889So4I898RzRZSmFG2zCl4FA5NH00MeD2ujDcYiU6N0/I4ECOmwh/gzt4H8q+ehZqdkXnviF42zqmN04+9Y
 yTrA80lz
 cKQhbkexk2pY370Or+Fgef40P9JJsaUFUvFOcoxSKjo5mtm+D+zmRyKyCnVCgzzRIatagk4304rn/Nn+1MtkVS+kviNoCx+l3uO+JAOx6Z5+55Cw2Vdl8MWSVoe2NiEyBOCIxOyRzh7diYTeWKIdPNwY6MuO8JsklUb1wBk2FmDBSr158ExF8RyP0UcfoA7FDydEJ5N0+rj1FZy8QUXzsJa2fGYde1rmcvOBzZ+LcRqjnxTE6qfpcyoop0l3l+I/wftLE2FX2jKSg+4jhH8D/nQO9nsns7zc2zl/Yzi5tmZB5ws5qnTEyHYbSTAClh/ILA7GWPS4jFHKCypurZOiaw9j/7LwxklSUZQBT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/21 23:55, Lorenzo Stoakes wrote:
> Rather confusingly, setting all Transparent Huge Page sysfs settings to
> "never" does not in fact result in THP being globally disabled.
> 
> Rather, it results in khugepaged being disabled, but one can still obtain
> THP pages using madvise(..., MADV_COLLAPSE).
> 
> This is something that has remained poorly documented for some time, and it
> is likely the received wisdom of most users of THP that never does, in
> fact, mean never.
> 
> It is therefore important to highlight, very clearly, that this is not the
> ase.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   Documentation/admin-guide/mm/transhuge.rst | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index dff8d5985f0f..182519197ef7 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -107,7 +107,7 @@ sysfs
>   Global THP controls
>   -------------------
>   
> -Transparent Hugepage Support for anonymous memory can be entirely disabled
> +Transparent Hugepage Support for anonymous memory can be disabled
>   (mostly for debugging purposes) or only enabled inside MADV_HUGEPAGE
>   regions (to avoid the risk of consuming more memory resources) or enabled
>   system wide. This can be achieved per-supported-THP-size with one of::
> @@ -119,6 +119,11 @@ system wide. This can be achieved per-supported-THP-size with one of::
>   where <size> is the hugepage size being addressed, the available sizes
>   for which vary by system.
>   
> +.. note:: Setting "never" in all sysfs THP controls does **not** disable
> +          Transparent Huge Pages globally. This is because ``madvise(...,
> +          MADV_COLLAPSE)`` ignores these settings and collapses ranges to
> +          PMD-sized huge pages unconditionally.
> +
>   For example::
>   
>   	echo always >/sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled
> @@ -187,7 +192,9 @@ madvise
>   	behaviour.
>   
>   never
> -	should be self-explanatory.
> +	should be self-explanatory. Note that ``madvise(...,
> +	MADV_COLLAPSE)`` can still cause transparent huge pages to be
> +	obtained even if this mode is specified everywhere.

I hope this part of the explanation is also copy-pasted into the 
'Hugepages in tmpfs/shmem' section. Otherwise look good to me. Thanks.

