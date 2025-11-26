Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B1D6D1039A
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 09:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C181B6B0011; Wed, 26 Nov 2025 04:49:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEFB26B0012; Wed, 26 Nov 2025 04:49:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2DD76B0022; Wed, 26 Nov 2025 04:49:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A47DF6B0011
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 04:49:22 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41916160435
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:49:22 +0000 (UTC)
X-FDA: 84152285364.02.A1FBECE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9AFE9A0005
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:49:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K7uytnyb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764150560; a=rsa-sha256;
	cv=none;
	b=gxPnm/qYOC/CO4xBSznx9hdDkYcsAjCrQ4uNTiWKb4UNUec8zIPYzJrWB58waxsxG4BffH
	Y+RTgLKLvFpxJAYxKl3vtHj4BzDN3eIMQRoDSEJq/K3SavC6WUrfsI7hRMm5ZQu0U9SD7d
	CZtiPig9avVTuGNn2dAT7XJfnomci+g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K7uytnyb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764150560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1gqdAtKOGGntaaHbJ8vWMDkQv3IXnnCRWVQW2WHZkpI=;
	b=KGX5VG4D3RJjDUYftAtpTSdndwTgpauGQjLcRbeb7AuvXiMF3Ns58nXuCQs3vZldsUy5/a
	WHp9R0LXxThutKskLj4O+3xO3TnD4VFOr7PNfJhh266929thX1LVwHUrisCbj9Q/6vxCfk
	GMVmMv56FWgGUyldXJ7bsG+RrogTBmI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C952F60146;
	Wed, 26 Nov 2025 09:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75150C113D0;
	Wed, 26 Nov 2025 09:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764150559;
	bh=cGK1V5cr2XtVBUIwxDOJ1VtDwImhH9JCyGkX+QSHrAg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K7uytnybsQ+iB+pXK7FSU23a44D0slh30ic/Mgcvibmyqq8lNuMOmLfTdpFKHvGDr
	 qzvcyxgovIPuzNa9eHN8p3DQdbvr+upZbn5SklLVGY6nT3shefbLVzrBq2l6ZSsRAJ
	 I8oFmC0t2ohpHUi9wj54qsU0tofRwgDVBHL76khriWLT0cCAQvVWt9L8Trg1QS8DRI
	 yzaEKS5km8gWcIv+1dUYLy1S6ZU6OYQdTPGq1h0748Yo+cSWKnu/wxXuwac9e95tVd
	 YTq6nRZ4xj/Hfh5BmCn1V+GfsYFnRhBb/T9SDBBxqNTmgE4C3Itc54r6nrqHJx/aQ2
	 agegWz5R/FcBQ==
Message-ID: <16995732-b7b9-4121-be36-e912a4154958@kernel.org>
Date: Wed, 26 Nov 2025 10:49:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mm] f66e2727dd:
 stress-ng.rawsock.ops_per_sec 46.9% regression
To: kernel test robot <oliver.sang@intel.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
 Andrew Morton <akpm@linux-foundation.org>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 Liam Howlett <liam.howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
References: <202511252236.33b899b3-lkp@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <202511252236.33b899b3-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9AFE9A0005
X-Stat-Signature: x9338ppuntyqq45wg9irtqkj8mysn4qa
X-Rspam-User: 
X-HE-Tag: 1764150560-548887
X-HE-Meta: U2FsdGVkX185BkZZP7dMOPCWUccdQcI9VtBKFq5/zgAVtDBbCOkH7zUEtw8lEnhm2SDCZx06ZDpdkgUyox2NCpeyWHrAz/7KeeGGtlxiIngk7wz1EOIspYXsLlL03iov4Jir14u4XPEvzXPDsBhxeDV0P0TGb4dOKTGkkQZt11BmTrU7PI84u9AuAxi+nHYz123EAIY3bUuwuWccwe4DqqyoHlDSVDRS32ewqpdefcqqIJD3f1Ss5/cX6JQL1KpQdRN1RAwmIe94ZhL4GJMQvzWRfYnuELLp+GXVeSS3AdcoCjBz8WK0t9aN356uVxI/Xr3ytDV/ghjWgGia9jTK+WxMjpbWctgEJnHJZ2SajwzRzGIC4rOylkR2ufLAFmWFPRY799NaCox+q02EvmQXnIsmXG2hiBoTNiHBE2+59ZNNDuVU1gkG9AGHpL5IAPn45HlXNgOM9Fm6ItbfEA7Ifge8s2XqAz5LYRsl4N6MlHb7uy4g64mQrbFSyWR1i6YE+ThtbLo5bk1LM0jE7qpara4Ho10OMXodNfrUwiUJCGYLXZjbmrwvsCPitRPuR6jGvoUbLQCJkhYZ6hKVyWo5/6888FmHagGv8TlgfA4VzoXVyEWCptoiv+QMPeuVuBY/umtfXSBRYtJcMX7FJPXKpl3pLqt2+vJ3/fPY0rgFsmzmtBZUdyHg2lImodSAB3KXFWh8BaaXKgHkQZ65QMVEzYZ5uvNp3Ys3qfPsS5q8hgc/mMn4ycCU5kAcoSqtmMqtJaFOf1KH73qV4b41Zg+WN1tG/nUduXWwPoBMoSaFQTJL1z3EyvxAb2Bikn4Ok8y1KZct28Pb8l0O+WAp3xa/9CVSMaOHz49J74n2q5XodYxepCyblpxV8D/QKaZK1773QcO2bRkHlHz1sa1qxcZJCV/brHWE0C+OtplY26op1VMxt/q54sVrWPe88yvpwxMY8fSHnVddg7V5357Xri+
 /H7XT/tR
 sdCGGc0JDY5HyCa0wIju8KvuWMW7Pey4dXu/jEbVkzijzK2MIsw1B9a59Geq+gpSOHl4Wp+z2gI9iTu9GBdRzKcbnXollhCrbKoiX+mFDEcmMAmkPfAmputydWUNemJl5VK1OVu+A2Ul9yi+n1wkJTlzpbmjMNasHwMeQ+Ih+U+exByGXhnrXpe3qCazVSfgLuxMo4jl4vhfRa0EgCd/qvyrC8tJKru62tCeqIc0AYZEhvN3vYN9fY9vTot6E+B+m+mXI7lNybO/3pi4/DL4AFqQxByaz6P3xy3T+mlTW8CtMY1dZpfZtOAiYnz7/jWylltuw+LOoYfNSUqg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/25/25 15:46, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 46.9% regression of stress-ng.rawsock.ops_per_sec on:
> 
> 
> commit: f66e2727ddfcbbe3dbb459e809824f721a914464 ("mm: huge_memory: use folio_can_map_prot_numa() for pmd folio")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

Unexpected, but maybe simple a symptom of doing the right thing?

"which skips unsuitable folio, i.e.  zone device, shared folios (KSM, 
CoW), non-movable dma pinned, dirty file folio and folios that already 
have the expected node affinity."

I suspect skipping shared folios or dirty file folios might make the 
difference. The benchmark results would be misleading in that case: as 
we shouldn't have migrated these pages in the first place beforehand.

-- 
Cheers

David

