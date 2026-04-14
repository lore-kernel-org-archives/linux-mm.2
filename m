Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FE95F9D0CD
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51866B008A; Tue, 14 Apr 2026 10:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01C66B00A4; Tue, 14 Apr 2026 10:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918A66B00AC; Tue, 14 Apr 2026 10:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82DF46B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:30:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2CE401603A2
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:30:19 +0000 (UTC)
X-FDA: 84657396558.23.33D83B1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9C53114001A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:30:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d57me9yp;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776177017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8Veh/9HaXvgLpLkuOlp2yJ9j/Jm23Km1mX1QamQRas=;
	b=fwL45ums7T0Bg0qy/bHSHsIGvJZSdDWayo9jXGbCq8EPgukFJ/qqs4uoypj7ORYMYbuUko
	0iy7rsoNpYmavdQ8+WJk2zjuRRLZrVwgo+GGPNAvVQhPFFEemZ2Qw4qeedRPMT7PT4VgKe
	4giCSJRsR3Ly8Pc0aQoT1iRrRPR2U2I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776177017; a=rsa-sha256;
	cv=none;
	b=CdwTryFk13CZDKkLBKmeIMX5Dh0dMuxmpnOoPNkuYW1CHWQQQhyNaOdnGyto2hx2D8ePfX
	sSMMAb4kKIZLTIHTnzv2qyZM1z20FlrFu7pYUgC+OfHCgLfnEqFt8XkhqALKEPXLxqAqYO
	V5hQymmRIEw5p5vWPlIWBpYXsqM3dfM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d57me9yp;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1A3635ED;
	Tue, 14 Apr 2026 07:30:09 -0700 (PDT)
Received: from [10.57.33.35] (unknown [10.57.33.35])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E8A9F3F641;
	Tue, 14 Apr 2026 07:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776177015; bh=mhLwe7rhb27l/HdrKF1gzHFmrEeMIXkxvSA/h0P7cnE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d57me9ypwIuAeo2BDArS47N/bQv23nqprOSE9DiGPHMe6WxMtnT9+ii+MNl8xxsiN
	 +HIT/OdY31VGaGIVMjXbR15Eq1BACXaUZkDgXLe2mRwy79bDHAgUiJ8xKAwpiGYxcX
	 sra3mtYusApDJKnzgAgLLEbTm2UgFuozTC/JsPI0=
Message-ID: <17505ac4-c5e5-4046-b362-830369b8d401@arm.com>
Date: Tue, 14 Apr 2026 16:30:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm: make lazy MMU mode context-aware
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774420056.git.agordeev@linux.ibm.com>
 <de89fd353a8dcd5e3bef4d91e9b6682d132ed9a0.1774420057.git.agordeev@linux.ibm.com>
 <44dd86c0-1845-4dd9-b4b4-2cef6d1c6357@kernel.org>
 <e096e88b-f1fe-44a1-bfa6-451eef028203-agordeev@linux.ibm.com>
 <665a19a0-47c2-404c-bd2b-482ab51b8f64@kernel.org>
 <896b3d93-8e60-42e2-b8bb-d3d4e8c99927-agordeev@linux.ibm.com>
 <534ed892-a6ab-454e-831b-e207930c35cc@kernel.org>
 <584f0f88-aef9-4a70-b0bb-abc797f741ed-agordeev@linux.ibm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <584f0f88-aef9-4a70-b0bb-abc797f741ed-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9C53114001A
X-Stat-Signature: 6etzwq1pzp6b1k3wbb6jbzk33qdbd5kg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776177016-902531
X-HE-Meta: U2FsdGVkX19OCKPdQqF03FxjgigPFt0E5QNdPqRWEdV+54mKLK5AgT+2mF0rO72pTlIblWyTii3KwKNY84BCl/eyYJpDlR3xd1qoK7qu+tfgNN7fYX3PuHy70FgDW0fmhy3ZxEO7XDMFhD2DLAMgcCBGzRth40voa13qlWQTNmdtq6fdx3dlDsBdG+ygccDCo+BJBpa0m5X29QDUckUNh/ExQ9OFxbhgRUwQtwpmbaaI0J/IgtqpJiK3EOcBryDInCQmHaOV3Ci/Q9YhvxjXQ6WfscPfJjjRU0z2jjJlGtBamUKxvZLIiWk5OPTPRD3GKPGMp8dTX41kyiQikZJfJdcqTEkcOIaAyXeaKlaK8xYxA7Nf/xDHyZP9kuDEoX8v81t5/5Bm4DrF4k3vWqp0ljkakJXiw3KUudNdoQK0WggeGi9/WKX08tBdwT4Py08t2FHPA9Lh/ghIbFFOY2JWIOlVshnvPYXKUANvjtHXSRBJ4Aw1wFBYuO2uOZ4BqhSJmd6otLLJnL0Gma+YONp4SpzmS6ACsBi5zLoQCC2QCTflnKKYQ7smx9k31/jmAEnHhgUWWwZdbQGC6uwR5hr3HG1qQjL0fAEZFPnn+RLKTwgJoE5/EaLwZmi8/CeDragYxdAMzYVuRFzdvZzIHLHlKqPP0ni6PbGsvUZYYyR9FfCY4r67+mhs287u4ebNjWvKvKL3UQ8+m/h9+RNT0UoauNsQQNcGMl+mYp7o2//0V4pNmBGWFqxSZy+MKyoZ8LywUkj0mRqBvNsPbWULOvQEIQoQp/fNClcQwZ9f+MbOKgFjAeLQK/4Fg2a8LdAj7Go3c1mwDZZnzoPG9v5GXJKyQpn7geu7Z5tTfNtXv/KY3Y0g3YH64Uzs3TeQjvFbra4dSnqQ5370MR7Lh7VTsnZ1nm6Fx5u2JAGspkejjCymF8NL1m5HC9xhS2RKzBz+yyP6bqryPPv8zufdUYU/IcS
 yxJlVSJM
 BG/cMcBeh/Pd2Q4ZiDmFI8sXUqJ472eMF1WsVSGCzqnRp4U4fDuLC2GGaLjDL/XE1dtDl0owxuZWFa9rdnDyU0CJf5JEe4yxU8+7dWebCYxLOspEork3wOEwZcsH6CdhT7E42Y3KVJX5lZKEcahd8X4WJlIvoG3KRTjJt13BNMdVwU+I+//FAUCpLlCExPNq7eAWS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/04/2026 09:53, Alexander Gordeev wrote:
> /**                                                                             
>  * lazy_mmu_mode_enable_for_pte_range() - Enable the lazy MMU mode with a speedup hint.
>  * @mm: Address space the ptes represent.

Not sure that makes sense, maybe something like "Address space the PTEs
belong to"?

>  * @addr: Address of the first pte.

Isn't it the address of the underlying memory rather?

>  * @end: End address of the range.                                              
>  * @ptep: Page table pointer for the first entry.                               
>  *                                                                              
>  * Enters a new lazy MMU mode section; if the mode was not already enabled,         
>  * enables it and calls arch_enter_lazy_mmu_mode_for_pte_range().               
>  *                                                                              
>  * PTEs that fall within the specified range might observe update speedups.         
>  * The PTE range must belong to the specified memory space and do not cross         

s/do not/not/

>  * a page table boundary.                                                       
>  *                                                                              
>  * There are no requirements on the order or range completeness of PTE          
>  * updates for the specified range.                                             
>  *                                                                              
>  * Must be paired with a call to lazy_mmu_mode_disable().                       
>  *                                                                                  
>  * Has no effect if called:                                                     
>  * - While paused - see lazy_mmu_mode_pause()                                   
>  * - In interrupt context                                                       
>  */                             

Looks reasonable to me otherwise.

- Kevin

