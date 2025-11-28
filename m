Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B25DD116F3
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 11:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8886B0026; Fri, 28 Nov 2025 06:49:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A05B6B0029; Fri, 28 Nov 2025 06:49:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6D76B002A; Fri, 28 Nov 2025 06:49:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 792A06B0026
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 06:49:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1442989C91
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:49:49 +0000 (UTC)
X-FDA: 84159846498.01.92E848C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 374E440008
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:49:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PPMWjTxR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764330587; a=rsa-sha256;
	cv=none;
	b=kRZVend3SGAh2nMSwkjUxhEE7nmY92KIiXRYueV+cEkd1Lt/NOwhL50HWNfXTOefEcMs2o
	wgJQBrjugO/YU3PjM+hwb441KfctNSzBzNBaQIN8ddRG7qoY3WnshDxTAm7FFN25FBHWcF
	R0Yh+NQv+sSIzUY1HshXw5OwwSRdank=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PPMWjTxR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764330587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QyU6YqoM+uwm/iYd7qOK4T1wenU/e1RUU1gkNfHPPDk=;
	b=40/YeFIfYUy3Og+lOhQpzS0T1FjgNzLHbl7Sr1t6Q+XPrMl8njCdYGs7IftwLc6XPJn9/S
	n0vuPSrbfvpIBAEdT2OAlvutbG7Qs2paYItDSK8R4aFP/nebNggOKMGCri9EQlGfE83OVo
	vxN0AYDAwRbdIi4i07HqJ85Sqz2+4Ss=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 418FF42A6F;
	Fri, 28 Nov 2025 11:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2410C116B1;
	Fri, 28 Nov 2025 11:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764330586;
	bh=gTdTUDoD9xTa4NyvRIT+3MniD1D4UuDs9sY87csi6Bs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PPMWjTxRdaIIjLV0A26o0ru7HcDObl37cyDsXSN1AwzNwaYfBPGeKrUyP5fwWuHwu
	 Pexs3aIWbI403rxXAS+SN8gTqGIs5Q4h7HpPD9NhwlmxzLYUnle117U4qmvNbdLfoi
	 batuc1m+JZa7v9qRc3zegqPN45IgKIkdeZgWB8ZVb09egJA0Z1pjaOWnfzDRjUqYW0
	 zvCSUPxMI46GZkdN6XVYJk195WnGaqwSdHVc9IBhEqyc5zEoqngnNSpaTan9wKrMd1
	 9oO/YzWhSXvNIXDe4nD8UAM+UVbtkVcp7TwijqstFepIf3PFip3vuc/I0C1iNUg7gr
	 J0TnzTh3VNy8Q==
Message-ID: <d70f4bd6-0e52-490b-8237-a2d87f24c3c8@kernel.org>
Date: Fri, 28 Nov 2025 12:49:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: "Li, Tianyou" <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <aRwAjSQBby614Itx@kernel.org>
 <20251119040718.2735199-1-tianyou.li@intel.com>
 <38d90dac-982a-4adb-a4aa-3b8caa6d81c8@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <38d90dac-982a-4adb-a4aa-3b8caa6d81c8@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 374E440008
X-Stat-Signature: x3uod1k7scfn7hk5531jx1umarx7nbyb
X-Rspam-User: 
X-HE-Tag: 1764330587-251352
X-HE-Meta: U2FsdGVkX1/PRpeMwnLbEPqmEtr2KLAvZooLGLUge5dvq2wQobyP5dl8G2X53/HIV0nYpd2A4AcIxu+X6DvgXJ/w88R7QKTv45i+cxYpRVqOgBJy3vs9M+64fQMIVbjze6v7LnFUSYOdRAKvwxMtN9CS8p55XnGy2hJLPHnyvChRnuWWn5b+hvDtyFIpqtzn6y9wBQRe8YUFmkVMWZBi/lVbVhw+RmMwzSnhvPPCwvlYd20B4yAkfk8Lgx2gnkXcPmx1nFMyrYo/BuRBctuv9un7F0sNCigGDdP9IbkUhU2vInE/uCEit6lYkGDQh6GfGrTfdhJsweGqMQ5pYGxL/y9V1bNlB4g0H9CXbDetJwkOgjZbunkOQIaZfdO1Gi3+7Z8RseIIyGotGQsm+xrM8U6VPJUE/aoUeoZS3teVuxmVzE8N6v/pWJu0CgCmSRRW1cVBjRL3pB4tvkSHwNHkfAY+TnxwyfubKGrA0UoqeOWnBXyYtywGtZaB5YEGUs08135la/WZM+jHXAOWEPAjf+gZwa/DvKdYiUERvvCMs+oqnqqvMMQAU/wJyFcjacJ9jgPrN2lAOe5AwsjCPLu6fVnWcn5RMG3tryg9h2BzJaeZDQPwRpqGJyKDiScqQgvC7e3ro0omu5LNoJUdqFa4VYCLciMa8+Lmm5AaAPUztcIiTT89dcgWlhhA72MfLc+2T5t1fGBk5JGd38uM6sAV4CvavjE3CN9q6XkuiIlIVVHud3dh6zuQv+ApqhYQebJ16XOJ2ppQzr9/QxbMs+mkcPxJOY7R9p2vZxmdIBahXI0MaGf9gYSSzxFnHHpz2ZySVU2Muxox3rbMMl3Sl7mesmeHHPdfqbiw4cS/OxnYmKQSURo0Tf6hcmXw8WWoAkYPPxbIs1P4i7blFe4PsPq/fqrHp6dIvqE3M71azcf6MBb8UwFCOcxmssnvPn1g8BI/kVPusH19yB2bN+pSNbH
 ssi9RzN0
 OspG1j6zXmoPNnJU0f34xdCImF1DymZOZIpqxJZQNseKBsnndufZLemOjdAm8pecCQITvrzmlbwU8mWkooj3OOHBnaIC13CRf0rnd+2xop0qZaQw3oNarDKyknIPMA2EyMTZDHKnMUzieXHWBA1cCnEicjSw+Iw0wzHiompqG+uGAwIChq/3NtoU1X39eWKTGCwy+eQ+wIY2YjVnO1Oj8Z3oOcRFPSfFCakLUpYc8si1pPbQL4O6KU3dHAKDoMyLIgkxG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/19/25 04:13, Li, Tianyou wrote:
> Hi All,
> 
> Patch v2 with the changes suggested from David and Mike, which
> simplified the code and also performance get further improved on
> Icelake. Appreciated for your review. Thanks.

Now about to review v3 :)

-- 
Cheers

David

