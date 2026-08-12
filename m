Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0098BC5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8496B00B5; Wed, 12 Aug 2026 04:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AF2A6B00B7; Wed, 12 Aug 2026 04:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D25A6B00B9; Wed, 12 Aug 2026 04:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD696B00B5
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:58:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B188212014A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:58:56 +0000 (UTC)
X-FDA: 85092017472.13.A31D57A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1F7E320006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:58:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oaAm6ZoL;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786525135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lv+2Z/1Wduwhy5AzrXisK5gs2st/FQotGoYG6sp0EPg=;
	b=exJQuI9OYz1qprI+eqqLagJJlaB5lYhDc5w90KgOeIDU1pucCIypoHtP2PgHlFIJjFMaWs
	/FbO8Ism3POd6sLm/SncOAWB+ILQOPo9WX4vABuru5dd867ahtNIX0on+ardOBwGZBIqFX
	Lo0E5ELA14t6IuUdC87npM5c92AU8TY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786525135;
	b=mzpujKjqMb7WXN1SIWHk9j0X4eXI4ThTj3is92LJJB/4Ib4rl9hy9CizvVtRsGhUrCCge8
	oAUVloXK0Vzxxn+DEzqngf3+p9hrA0M85/MMZUw1bnrAYS8lCMnzxUzDoKw8YffxI2dLUw
	p+AcwC1tvJIru380ML9kDzptnobG9sc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oaAm6ZoL;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32E6843A22;
	Wed, 12 Aug 2026 08:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FF41F000E9;
	Wed, 12 Aug 2026 08:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786525134;
	bh=Lv+2Z/1Wduwhy5AzrXisK5gs2st/FQotGoYG6sp0EPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oaAm6ZoL0bGjZNnnDPIJ7BXckZpQ3BmpgPnW5gWbYQfp7gpAkJNt7lLc+JWkrobJn
	 brbcqfuvNBIv9dWGRsvq7NaFzyKYSvtcA2/8a94AHmaMA2JWt+y0hwvPw24TtPQBoC
	 hLPYaqBg2GMJg7oJ5SWcWjj7huO84D6OKabzAxEKGI6uFbYT7oCrAkt1d+FuRG6KhG
	 SDUGkoKUPa8OQhqp3rSW2FAQ8h/H0FGSWNdL/F+eP00BJ6sfSLNVvY3PjdpC9phucQ
	 MX8Bbtq0Ra45++zyGyAZpYMm7RwgR/q+Ve4aMEGj65gnhNnCoCe4f9D6z+txZcM+nU
	 TeJQCS0LT9DXQ==
Date: Wed, 12 Aug 2026 09:58:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Docs/ABI: document
 transparent_hugepage/shrink_underused
Message-ID: <anw0mM2YVPRRM2Ff@lucifer>
References: <20260812080313.330413-1-husong@kylinos.cn>
 <20260812080313.330413-2-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812080313.330413-2-husong@kylinos.cn>
X-Rspam-User: 
X-Stat-Signature: m9fnqtadqryr8hbe4f87r1n5zhkx5ox9
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1F7E320006
X-HE-Tag: 1786525134-62541
X-HE-Meta: U2FsdGVkX18/9sfm1NaYMZws3icKQfv4uLQpRtSUgBDT6eATx5e54dAwwU+pvSNTqct+bxHPSYmVqnzXCvutpo7soFBtwDc6dwz5BaN0N1tnLONYQmy+DsoLAz1rcRFZsoELiyq69+tLziyrtET2zj8l2tSZHunyniPvi8yNnLs0/Wv8izbgtkVUmRjVQnge8L1lugZYzpOHuiod1uGj4azhC6pVSGmNXWBxkVYuIklaipYHaFnG8xI4frJL45W6HgS1am3HVEHDCS2mQ9/qEdWKdBOzoMjjpDk1swvzix2TNxSKJnfXAV8jDjITyVMNPa1JexNVL3XsKDBuKtC7e8wY3G7ztwqRsOfw5u+Fu6iXeK3reHJfkvFeZ3h21SBuvLr0w1uH0/RD56hP9LAcSm95Z56vC+aARQRDaCFEwHFEJ1ZqwOOto3Bx4uKEliprwHjujiv4MMXFtmYANk4Md/PmIk8ijB2wVQO3ZccH+Cfy6i3hvzFUDNLRy3VyzXzmpBJPofuQWG1DEkF8HhNaWZSVjAd9bPds81W2OLwA7wl5QuU+yxntKl1fMCUieRaf5+/Gd2+Z/2sibuSt+yjq87OBmQ3hrM05sYBj5M8ALgVJ1B527hDjrDRmhsRL60LjIqxvmejD09g8OIcWK8eJ0VGBDIdnFppVi/2+xumcU6rBEwlqMv0ZjlaTFj0CWMXJqmIwAizRvRgEe9BLCsLkoc9FQvtV3iGON1D1cjYYmdMwI3V1lqYrmoc3BlSpzPYef8PZ/yRFvWOW8fy9bBkcuFKujOW1hepuuDH6qB3Y++9F4M68v1nYeB85g67Xa2Rx02ueGbz4LxIx7+kAKvgdHxv9ZulC/l1ynHlK7oVS0x5gwCfUGCmaGvOqIlgIwASZIqTHUCL2A1pGyGl9gyzgmXZwH73/A8/34aBWFJX9EaKt363kVORQHQwSWYNxvHvpFxVoHIX/fN2LiZO8fys
 qOz3E1k3
 ftuQY+ZNpBNmhI8GR4xGGGKy8+ptzyGxtL+3Zpfs+mY3/yV6TMH945X9iljwYvr8n3hayxd0KhDMsW/L5Vv3RcoeuuHn0wBSvSIZ55EPHlVUDK0XBU+yx6ZMn+fC0eplzJujUMUWU1KImMij/LsxC8Vju22rJkPA/9S770zYWjj9MRZ5Ke+cthB3/gRz3G0WwPUyhTbuzi9WPoZSVe+K0aMjkJZrUKd3rx4Fi3nr1axPU3wNI8Wpfvb2fHFGALtst1iRzco1POrH+hREjTuJKUw/xP18Iqw3qJKfMpGgdBIBhV7oiZLNY33NF3QFEdxGGrUKSunth4HBWetDoRJou6Luq3alzwWn4F2axSRy0nMzhNaI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please don't send patch series like this - we really require a cover letter if
patch count > 1, and every patch should reply to the cover letter.

On Wed, Aug 12, 2026 at 04:03:12PM +0800, Song Hu wrote:
> The shrink_underused knob was added in commit 81d3ff3c6f76 ("mm: add
> sysfs entry to disable splitting underused THPs") but is missing from
> Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage, although
> transhuge.rst already documents it.  Add the ABI entry.

Hmm what even is this file? :) What is the contract on this file?

>
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  .../ABI/testing/sysfs-kernel-mm-transparent-hugepage   | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage b/Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
> index 7bfbb9cc2c11..bbdfae2c0caa 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
> +++ b/Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
> @@ -10,9 +10,19 @@ Description:
>  			- hpage_pmd_size
>  			- khugepaged
>  			- shmem_enabled
> +			- shrink_underused

I mean I guess fine for consistency.

>  			- use_zero_page
>  			- subdirectories of the form hugepages-<size>kB, where <size>
>  			  is the page size of the hugepages supported by the kernel/CPU
>  			  combination.

But we already handwave literally everything else here....


>
>  		See Documentation/admin-guide/mm/transhuge.rst for details.
> +
> +What:		/sys/kernel/mm/transparent_hugepage/shrink_underused
> +Date:		Sep 2024
> +Contact:	Linux memory management mailing list <linux-mm@kvack.org>
> +Description:	Reading and writing this file controls whether khugepaged
> +		splits underused transparent huge pages (THPs) under memory
> +		pressure.  A THP is considered underused when its number of
> +		zero-filled pages is above max_ptes_none.  Enabled by default;
> +		writing 0 disables the splitting and 1 enables it.

Nothing else is documented in this file so why is this getting special
treatment? And why is it backdated to Sep 2024?...

Drop it please.

> --
> 2.43.0
>

--
Cheers, Lorenzo

