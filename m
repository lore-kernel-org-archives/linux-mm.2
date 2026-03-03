Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE15EB3648
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 02:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D2946B00BF; Mon,  2 Mar 2026 21:16:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355B96B00C0; Mon,  2 Mar 2026 21:16:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B5A6B00C1; Mon,  2 Mar 2026 21:16:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 168936B00BF
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:16:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DAF113B1B6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:16:08 +0000 (UTC)
X-FDA: 84503136816.02.1FACAC1
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf28.hostedemail.com (Postfix) with ESMTP id 81F65C0009
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:16:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LY1UZt+l;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772504166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yV4vZDGDVVlhjOAdU9w5q9Pwayzq2sJKIaf2Eslzy9E=;
	b=Ct/xhgZOXVj3jlZyT5bxiXIDwhejn6FbUCzbaguN4VPLFDTZaoJTo4zt3Ten80Q1ff0tu9
	ASPWh7EkdVYt8VRBvUJREMl3M9e92tcuCHJR56joBnFeNHfwMzF4qx9ofhD+6qxGOJnWQr
	r7NMmDLncevsjYY61anpEXFjE2S6ik4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LY1UZt+l;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772504166; a=rsa-sha256;
	cv=none;
	b=me63o/wFYATrwDZJ1hd8AFIiEJ8SoQ7fUxU4R2oGsGujwZUDGl4ZtJsm8gSANtM9IzWi85
	ClQxViW8tfaqNoWqIDY+ez83jeL48jnjxae91qyKUvXJyuQzQiNCJHgYki4uvlUGKLi68C
	Ul/WRibUtwvKacilxe8/joizZlYOl9c=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772504162; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yV4vZDGDVVlhjOAdU9w5q9Pwayzq2sJKIaf2Eslzy9E=;
	b=LY1UZt+llyc55502iarm1ioW+05mku0F8Rf2pKh8rLe3An9F3go2hrkFyDugaWMea29T0CEBAocw+zpZyjc15zsT5tWoSVf4hjvlvXjXfoZTwWg+RRLToxO6kaaWrMOYwWGIfnyIHjL1YF1GsZq9CdF8bLTY/iOKobhmGapjmZw=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-80hnW_1772504161 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Mar 2026 10:16:01 +0800
Message-ID: <0c742d98-82ee-4085-bf3b-26fac5897bde@linux.alibaba.com>
Date: Tue, 3 Mar 2026 10:16:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] khugepaged: remove redundant index check for
 pmd-folios
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@kernel.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260227143501.1488110-1-dev.jain@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260227143501.1488110-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 81F65C0009
X-Stat-Signature: hks1duhwc1kszbm3d4w17z9cj8316rmf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772504165-217059
X-HE-Meta: U2FsdGVkX19lRyt3ArOHxoc12DsBjEGE9hwYzDQ/YRg8TR9AVxIFe6uD35P15AzYttdApXEltyLlVFJu3MpAEne0RhMs+KFk8lEBdTPwl6Hjh44Doi2ZwFw0fKeKKwxetZ7Mh78sreGqpU5wb4MzXNmTP0OyfMVl7lXLIwVOu4FYvp/FgmDJPHhS2p1EhZQ9c1/42xIdiW/GGrGPJDITyS9MCRs9ZahMCO8pTaZbZhGyMr21Nq4g3WEg0bZDp0nM8Y3gl01yXcd1JVZtZm/EhWzx93g+pDzJKiNmMgWQu+MlCaXjOoQcWO0lCy3UeYakCffKekAkTH8Mc8hDKm5eZDjion4NwP21oYgAVi2hxS+CzS1Q7PX+fUM3ezF51WXnDWv1Uu9hZ1WFSam89jBHJ/inSt46cAh4Gx/ckX1r/Ve+cp8UjfAisjsvzXX+gN3Afl7cE2fh3ePIJawAjPtPPhHMGa7bzlFuF2lxG4e62J/jOHsmzL7ENIjgsZukaKiQh1pLJsq5AUUYKqUob/Tc1OSBN2+DYugCpG9WoCDani8kycSYFgwnbnopeIk1NtcoojzW5kg1r0sRLEejafTgrrM4Jl/TGE76fsLRw6rkuUruj5IaUmxfWSKKlPAAdAa3Q2SLgT6tMctYrFVOLP6Uz5q/lwSiU2dpo1kIFNv+q3in+JuphGGkysu3HLS+mTEPpGQl4bDGY/j2Qqj5/ub0bJBJx6RR2BQhGxppJyCAeUcrz+hkULq5QvSafyC4g/dvaguxSa/LTLi4u/4d2eewaSgWNEnEW8dvTn//R9gJKwYNAeX2WZCMSo+dvouJswYo6H4Lg8O9H+Y9ONIuMSGih3B81O7Qys9KQusDbBIeZ1uz7DqOpssK5VMKeJGTNFYNZbaa7gPIH12J/eXDxUrI7D8z2X8fum4qpphPDsCxtoBMMjpWRukd7cKxE/J9PXtM3ovBK/O/f2oCsRGHdyp
 XIr84wU4
 6gf0pyuGS0AD1bxf6qUApoASLyHPuPwae80ITghmrVOZkOJG5SacCf4eac2sp+yjbKD32fW4qSqVXqgS1pLogL7/7D3vhmQF4pftLMMZh7Hht6Cn3AntycDj+4MoINei+76GR17HMY8xM77Wke1pS5P8Or5z8lu1YZtGHjGYdhGw6LchiQPrZhA3n3m2sNXM+yulcO/WRS6Q2e/TqtWBMa5DWwkgEI5qAPpWJeSZ4JLYa9buPD+VcFx8P07zVTvovRj6tajpu4FeHmeWhPbdmPSmX66jNF9Dps3ZLIp+fdVazh4RyA1oAWFKDPNnysQb9Hle5vFaiJaP+9g1cdIobCYOOYiv6at78crNGKT/t81H/7PY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/27/26 10:35 PM, Dev Jain wrote:
> Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.
> 
> Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
> iterate on the xarray, have the invariant that
> start <= folio->index < start + HPAGE_PMD_NR ... (i)
> 
> A folio is always naturally aligned in the pagecache, therefore
> folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, HPAGE_PMD_NR) == true ... (ii)
> 
> thp_vma_allowable_order -> thp_vma_suitable_order requires that the virtual
> offsets in the VMA are aligned to the order,
> => IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)
> 
> Combining (i), (ii) and (iii), the claim is proven.
> 
> Therefore, remove this check.
> While at it, simplify the comments.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

