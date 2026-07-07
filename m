Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF0C4C44500
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44DC6B009D; Tue,  7 Jul 2026 09:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1BC56B00A5; Tue,  7 Jul 2026 09:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E3ED6B00A6; Tue,  7 Jul 2026 09:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7663A6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:45:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8BFDC2AB4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:45:54 +0000 (UTC)
X-FDA: 84962103828.23.7CD4A1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 27EC140008
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:45:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q95lGb91;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783431953;
	b=Eic3BKWrigiTZqK28hFcIr8WmvBP7af4eJTYuW6QPmOQTwpkoWdzS4dDeeQ4vdVTmJKDYE
	Wzq+/2m6Hp2TFGfLBX8b6cAdcs7WV0aEdtoSMl5e1yLejxnEYxGu78RhiCRUgmLGjM3yQF
	a3jZKiD+qUe3Bh7eG8NGXDOebt3JIVI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q95lGb91;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783431953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rM0EBVxGJ8M9ullpFRAPvwAgrK02mbep7O7PE152JPo=;
	b=c2Arh9ZyLpLFO9PSmw7wAX3H/odwWiBasKuGqUuwf9jKDn1P58iwNYWIkEOVTg6GaoO5Ub
	OOlsQTTJGyWsoSJyhxtHKxRJHCnT/ztlLIGmkcqpj5Fpk55ve+RL+s0I61f+rnIUVMsPNv
	8wOj3jMhhFxuUn9w0CbfLDt6f87iy78=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B3B2B600BB;
	Tue,  7 Jul 2026 13:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65571F000E9;
	Tue,  7 Jul 2026 13:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783431952;
	bh=rM0EBVxGJ8M9ullpFRAPvwAgrK02mbep7O7PE152JPo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q95lGb9166BzEJyLfy0LLHvUuYPGWc+Z6W/MAXsCT3gAU7fCm7+Kb8/wMtypdT629
	 lriPCYYOuOwA5gaQEXVTd1fDGd7EB3wAiw3y/p8FgLOYu20NvLzsJbqVKGcl2vRHUz
	 fZo+1MVjpvlRW1xDw+wXrDVPDiG+twK7AYRFu9oc/8PFa7JYE67cnjqgGp6l5l9gCJ
	 eGmwZyX4IiT4e5C5dzle6Et6a+4i8KygE8tNTxvNfJp9fttrYOL4yLqIPr+eYin5q4
	 Q3kX4G/PwlpY5Kxwb3SRo9ptdOj/uPcMPjPYQRfuM6tMBBM1Bb+o3PS94scXYLD2Ww
	 ERhEGpmbEJyaA==
Message-ID: <e93008a4-ea6d-4420-b38d-5cd918c8b25a@kernel.org>
Date: Tue, 7 Jul 2026 15:45:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/mm_init: don't overlap NORMAL and MOVABLE zones
 with kernelcore=mirror
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Taku Izumi <izumi.taku@jp.fujitsu.com>, Wei Yang
 <richard.weiyang@gmail.com>, Yuan Liu <yuan1.liu@intel.com>,
 linux-kernel@vger.kernel.org
References: <20260630072212.624305-1-rppt@kernel.org>
 <20260630072212.624305-2-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260630072212.624305-2-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 27EC140008
X-Rspam-User: 
X-Stat-Signature: uba6ed4mqm4ooitay7kro1agiy1a5y4m
X-Rspamd-Server: rspam03
X-HE-Tag: 1783431953-541371
X-HE-Meta: U2FsdGVkX18auoL1XZfLBff4MWwqX7sEZHf/7XPeNWwYmpfzxSq+JcEk5/hoq8utZyy2KWZXPvmHkNUdMY03TrBldIDPaqAcXUx9CIlcvqojM+l/nP+UAaleGgwsfS8IDx0Hx5XjAbb/Y78tDJCfUOErWJFf2qCYbA7HEUM1Tl9tdO6iyqWtpIlVKv+gT4eYhmQqp41yi5VPSNeuCKw3sTck8IBZI+ZfuiEBYzaQxybyz26wDIKFDJOqeEfdDK3fOJSV3PJt5tW7RxPv3QBa/x+ilOy60c7TeU3lCNvEUZOYK4KRNOh98r1aiGZ3DWWyolnFcfRBV7vIQG2u3E6J7ypkgIpDeXWeAwh1GyjrsOztpxZPpjvHTShiuBiaCUs51Jm7EoyAg71gDLNWCGxSyikBwZ050RvHGA7tjiIeId2rlXyIPuTgqBrN540DrbecdmQdBvNwMtZQBdUmbismaAaY3EBAEzPEMiRPHG++PuWDOEzNyAvjpWP7rkzFX63SmcXR3vhat4wQrU/f0ZrDS1W2cDtrwraZluYbbCy+sgIW/alLOKqZSpKwojS5kSauOP9aEckSv/BTEWyDT+gaiC5X1rk0nHR5ZZ7Xtg6gg8VyXPg9EX9OaxyYmV2PiqdfKYGgEb6ktZ1bzjvUAPMYp6Pkvot+LjaBMwBY2ps/BIAvMLumn6TzZoIjWipBW26KgSNFLt8MB3S6hu+urHPFXbXGleE9VrhS4Sl3/DRWVzHCCY9OWJEptA/OQ/smm9BGjB7EMfVx3RX1wxVNTFNi6dCXsf1674hE0KrJLbu0ZhBFdBwwvuJYF1K/551jBzTPPSpQmC2D19Tu1C+zED2RV6xOnbiMmWShC6QxjtvNjg7at7hYGN9o1TEz89IDClvgIswBNm/189s/Elzt3JMHVZQ2qbeNRCt1Z/LVFUOuWc+mk2sJQwMDWG7iVcTW2uuL4W1IWMIC7bNJ8ghYl1Y
 YfDBIIEE
 h7lQ8uGojUaDoeFa8YX5BQygxSDxAEYwFaDJZ91DSP0RJb0+a8mHZuFKAJQols1Bt1AB2T8YTrXWo+1SgouppWSP8o8mPaF8FWGZ+yasYZ3tbFYFti895TYfvZa7/+iNslW2bIYJs6pPAQx8f7tvQ/uRdeMispawP74412IZfNzoqzHfpIyn7lKG7T/8pAx+VzeFs5rnFivrVF590bxf7wTIt2mIYSt71qyHMKkJsO5Pz1HMhIcm9bGqWjCUsMMKEgnpRnMapHfMYRLDiyYbYp5tYbcybBZePE766sdu+iMbC1Na+D0LjzsZwNXdad3GrY4PeehrdFlpFe7/ib62lIBS/9ZzhkoTl4HeLgOfTuSH9tX/FiUSEQxylDVsbg78j08MW00Z2zUQc9ml4NUtgCdoW2i9CPpZZW2nppPQJozoTT+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 09:22, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> When kernelcore or movablecore kernel parameters define size of the
> NORMAL and MOVABLE zones as percents of the total memory or by absolute
> value, ZONE_NORMAL is clamped at the beginning of ZONE_MOVABLE.
> 
> However, when kernelcore=mirror the ZONE_NORMAL span is not changed but
> rather pages from ZONE_MOVABLE counted as absent in ZONE_NORMAL.
> 
> Make the behaviour of kernelcore= parameter uniform and treat mirror
> just as another way to size the zones.
> 
> Co-developed-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

