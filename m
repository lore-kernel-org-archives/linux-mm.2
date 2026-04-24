Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C31E0FE51FB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 10:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397226B008C; Fri, 24 Apr 2026 06:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347386B0092; Fri, 24 Apr 2026 06:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C206B0093; Fri, 24 Apr 2026 06:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 170C46B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:06:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A4154120882
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:06:17 +0000 (UTC)
X-FDA: 84693019194.26.FE6AE28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C5583A0006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:06:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pvMGiBob;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777025175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDED5CeprBZJ9CqQDLjkUucaBx81z+cbtaZKnlV4GjU=;
	b=YY0n72OWU8ZQkx53EbiswBc73R1bQCrY7JgTPwOwOgDUucgF9QUf6urdLmR62aVcQ1IXxT
	+5/gYAjXkZtHDTJgqz5zYQTa2wvlsxW7kBggOxnMA/uIpDMl/cjIpUO8zbHR/iZlbKFVat
	FXDsoa2ntyBK9z+D7IKC+ZUnKdbfoq0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pvMGiBob;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777025175; a=rsa-sha256;
	cv=none;
	b=nVfL9Q7tfc91gvzKM2yJPCDGafC6dgn5O0PykdSSfkHWP1b2KhmAL1/96Ozao+kZgDxya8
	CoGSjUS1PBw/KL3f+EJN0lJifZDIomtl9rPjCT7UgiWw4j6dRTNFstyC4CxQWH8dCTruPa
	7tvVTWcTUHTWvIkIvqfN6SbKKMZlN28=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AA0741886;
	Fri, 24 Apr 2026 10:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998FFC19425;
	Fri, 24 Apr 2026 10:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777025174;
	bh=cLMEH9r4eUFR8njZKIrq9aXR9F9GRMRNAAzjDKRDFNE=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=pvMGiBob4Lap2EESrAoLaXiFcRYjh9Fxms506WL72Zbu5IQR+fXM3Zo06SiOaoNyb
	 8iciPSARpAQG5/PVL05J1bBP0aarhFoI0D5bblZQhXvvEmRPoaArEkgEosvoWOrsJd
	 GYouGdyPluSIivfhgxV1SbjSHvOXKDMC5zfmw2KUUtZpgAipikjw0uh+fcX8G87mY5
	 NdkPZYIIBAc5C2hZr/JEZMDvo8tl5XmdazVXAsKqrBnu3l8ch/gbjL+CPUu1Y+Ezg7
	 m/dyiy6ug4MlHDPZt6JedUpzawtUZcY9prdH+c0XHWJcipamBSATd2CXsuNOH9GPN0
	 1gJpl2CmBnIkA==
Message-ID: <627ffac8-e41f-4843-9eb7-0e742a91ecac@kernel.org>
Date: Fri, 24 Apr 2026 12:06:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] slab hotfix for 7.1
Content-Language: en-US
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <2123729b-578c-4f47-a33d-d1706dfd2712@kernel.org>
In-Reply-To: <2123729b-578c-4f47-a33d-d1706dfd2712@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C5583A0006
X-Stat-Signature: 5igcso54a7mb3qifm65wwf9nk3fsktkz
X-Rspam-User: 
X-HE-Tag: 1777025175-511541
X-HE-Meta: U2FsdGVkX18Znzw2LeEur4kkhRT12PhQ2Vw3ku2tw5hvfmlSFQ1lDdgOE2EWYu/I4PXeTWjAOQ77mm7ldpy1Oau1aNkyvv8tDTQb0XAd9T6ZSRT6SOwvOcXCXuTbyBo2UTjBn7/OoL5sT0HHDw2llhvk/siyBvAl+dfm6fZE4Zz+s27zVMk044lZgPL7o40knFFxuVrqT4cgC44qglOBkECIugir8WMyT5JCwlpwcXO8HBnqgI1+57B4stH6S+wMBcXNdmnn9Sk4fZWxaYiKUAtDrONIAwAOXha5yLpqsdVt4Dfzv8isufQrFMZ93sy8r8lOv/hY/2EMEt0vMJXyTXJ8B2Y7SI8c806e+2iBNSxxEWa1lt6DEjOSSoh5mwigEYgN/QpIlHHHFRWTia+lrXzhIE9acsWvVCu3O0cTWXrEvd8h/892PlaWNbD15j7ni+a0Z5q90h9PRoM9HJu9lSQMiVxHeaAuU0L3MjpAnhHXez2G0I5i0Ss2ICC+Hnw0VUGRjJVpt0pcfTuhrMvpbfYeACyzKWXEGZV0O0jD/NQrHNpWiOnUy2Xd9XUdYcwNv1vvp5Thzv0PvvJCEAKHDUjx/EFDAa0OF4wYjRB2O90pILgIUzIOAkDDuzVQwAJabqM3pmiLOyaMIMoUk26J3QJuMavGLO9KJhzgJyRCIhjPje0VT0Mm/TwnoI7WfEDT6x0yBjPgEcipI9eCasqkt1c4uSPzN2B3KfQH8pB9rs1tTWHGBRk3sixB4zb7TKmLNQd8vUvq+Q1NCmI3Htqapct75JqDAeOeZuxbW7Wky4KQbPbcG3yz0jt1HXTbwhFe+rjyXd8w5AbXx0jUCB9Sexd6iclqsUoGq4RmLqd7JtPd3TFf8Ck/zn9d5BvcrtsMt0UQFtRxtQ5Z4r85bFYBZm6DNdargzif9KZ4H2GW4NGo0n9DS6vHL6AJwM5ZN+Npm3U55nDM0jBG1Jsue4w
 iLORcSX4
 yPWUHPwX6Pl3pwuaNW3A13pRIs/U+eNMCOLNmnhoO7NVHQtWT4ov4igkek3F6b/YJ2qAHmOANKCmk6L0c/3UfmU3opOq08B8htvDCbFoIm4uTnejgrk8AIRd7eiWroAjag3YkO8wdMfI5RWbdz29/7x4M3gAfw49978ECMFgcNKmBmFAe5vdyxVU6OAe/YnzYukKn6+RFix5hmmOqb9Ca3KBUwlqw9r7mzhW+NTfj2aOL8mSZIsqfHEv1sNUy1zWT4BdngOud5bt+M5uF8fY9Bn4rXDnRTZkVwJBasE1tKyXTPThsmeDHg2wm8JdJZFVdkpNC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 12:05, Vlastimil Babka (SUSE) wrote:
> Hi Linus,
> 
> please pull the latest slab hotfix from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc3

Sorry, it's tags/slab-for-7.1-fix obviously (as in the unchanged git output
below).

> 
> Thanks,
> Vlastimil
> 
> ======================================
> 
> - A stable fix for k(v)ealloc() where reallocating on a different node
>   or shrinking the object can result in either losing the original data
>   or a buffer overflow. (Marco Elver)
> 
> ----------------------------------------------------------------
> The following changes since commit 43cfbdda5af60ffc6272a7b8c5c37d1d0a181ca9:
> 
>   Merge tag 'for-linus-iommufd' of git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd (2026-04-16 21:21:55 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.1-fix
> 
> for you to fetch changes up to 082a6d03a2d685a83a332666b500ad3966349588:
> 
>   slub: fix data loss and overflow in krealloc() (2026-04-17 11:07:48 +0200)
> 
> ----------------------------------------------------------------
> slab fix for 7.1
> 
> ----------------------------------------------------------------
> Marco Elver (1):
>       slub: fix data loss and overflow in krealloc()
> 
>  mm/slub.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)


