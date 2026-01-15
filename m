Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E211DD3CCB3
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 06:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35FB36B0088; Thu, 15 Jan 2026 01:15:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303DD6B0089; Thu, 15 Jan 2026 01:15:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219396B008A; Thu, 15 Jan 2026 01:15:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF896B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 01:15:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83D45139C5C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:15:36 +0000 (UTC)
X-FDA: 84333186672.28.AA497FF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf19.hostedemail.com (Postfix) with ESMTP id C1A4B1A0006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:15:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="NaslNM/S";
	spf=pass (imf19.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768457734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7mxtx95bNFWg2AnURExf581bZg9Cg3y9NPp3jkEy9k=;
	b=rl0wsH0PFbD13n/iZbxERL61SpllQM4YGHxaWOGjA8lYZFF211MILteF7RdlOebig18L9e
	7dpJ9QtQJMFd62IspexGQUZ1B6yr6ASnvYzINwVOC9sN3USwsnm26vqtGgmGsjfCFRx2Wj
	Zcvs5WxPvf/U8Fxplm9gaI5YhqCCQeU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="NaslNM/S";
	spf=pass (imf19.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768457734; a=rsa-sha256;
	cv=none;
	b=x4R7rVIIK2dVHT/QHyWeb6Jg3/fi9rTp452Nk+T0N9nWpInOhF79phri7Wd23XZVKi5lDJ
	A+AX6oA2mDg68LK1VF/mnVrAlR49TqlO0DqdsyG+r0xLWua/SIk5Nl6+dUPi9+MUWCmZwg
	2dA0GqVtjHf2/VkfIzV8hY4w6NApHxE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768457734; x=1799993734;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3J7tIy8k8Bcf/iUPBVTRCC72t2DHrr8dVnhgEH9Q9ug=;
  b=NaslNM/S/dUhruhfBdy0bkoyrCCSs4uTu/YGOJyghymJRZslRABCmJJm
   bjKiF2W7Y5jdeVOyuDh8CGnecmJbRbR8CiuhpggGd926vPL2a76Ip4suE
   GZBYytTkwTB/5Dzq/7CVdj5qwulyJITShIaPfSvS8356QQ2Lutv21d8Ti
   bMdxXYos8R+p8kXlJJYJekayGQ7qC5o9tofR2gJg6H5ImZvvGbLwsnKJq
   WCb3apSF1NQ+stFCW/sTHA5OwUd+j3I8xTZ3O7GQGzmnyeE8X5UomKj/J
   0aOpAxDXlHTchrjq48eUNuNHxmOK6DQvEd0GzJ54+CLl6aOYIPlGO6CU6
   g==;
X-CSE-ConnectionGUID: 9HUIYa+QRumS9GpRaI6KYA==
X-CSE-MsgGUID: cynXhkRTTE6Hj4I/SDtqQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="72345751"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="72345751"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 22:15:32 -0800
X-CSE-ConnectionGUID: Pj1GQVOFRsqZrvJuRHsaaw==
X-CSE-MsgGUID: DapuPcptS7yR3gSSG93FjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="236129327"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 22:15:28 -0800
Message-ID: <f3ab0156-3d7c-470d-9c1e-922195ea27af@linux.intel.com>
Date: Thu, 15 Jan 2026 14:15:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/5] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com, rdunlap@infradead.org
References: <20260114164322.787125-1-smostafa@google.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20260114164322.787125-1-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C1A4B1A0006
X-Stat-Signature: fb4bqs5g893nxumjjmy6z97z3r91ys7t
X-HE-Tag: 1768457733-203591
X-HE-Meta: U2FsdGVkX1+mYdtfAjadq06LrchWpiqeYRN7CHzhgH1w9ujzqwdhJYWqN9qcmDKfUjLlnYkdc2Zw2XkBcMmfGd3m0uzKpQ3Au4rDzoVOdphtWg7Jkqppw8iGp5EAYM57u0Lmr/GTCDyWOuJxelk4EwcrZke7FL77EN466EJmw4376/y9B7iXEfhlmyhlgLeTzhN+HQUsSFBvPzCzQkQRHCT2ykSagQwikKbEb0B75MGBPV2EqsaSl3o8QTOYapiiDA+qcxRg2x9H9pFzNPJ3ATIbz1PeD7Ji9S+2DZBvQBkLx76rjmbXRh0gANmCBGdbr/Nun9HOo8pyA5H9IitM5KlQHGHdVi8Wq/f9dy+WKTe2RMhpIb2CzZpbCrQnV3G5qzAn+lieEEr0pGigL+biE1Sxm0FUemaAW4cuX+yJ3Cj2u4KktD+RoWg/ZbUNN8JVBF0ReEI52bCzx3vcXRkIt4UxpEX5qmFO8cg42EKoA3Nj1z/GM/iBEMcL4pBR1sGahQmdD+C321iv0NeCZXwZvPrQpdDcs+Prjt7lT1hCCs7eyKKF51vam+/kbY4N7E6Z4mh4w87FgHqiXP+y1Q6GAm6+znXxsrfY1T3n7KEKW2i/DOktjVznGkg2Mp8FmytyiztBNiL8+hrfbZafDucUJBNiEqoo6kY8ioKWiGcwElz8gywu5EUz5uic2HC81Dh1BZAB/RWzftZhj4xDs/pyO4Shlw/wrhBvirelQhUX7Z2vd5xXLsWd0lp/d5nx6mSnUkRAv9QgUZbyKCW6TNhPeF7vLGRys3EGDk5NRZLN85hak+HZxYZbMl+1V1pa4KsatjOgONYcNx8pziGIYP9oi2veCTTSpcqYJOfrHIPIKwCfZ1SOYKzdZKTXz7s0BJGquuM/C9YYuHPA8JjlKnfpERVzC3ne9r2a78erw8T8CJ+w1SAqoiRsS0g1oMLXyOhR+5URszVfNlS6X2QJpUB
 ylFJvxGB
 vbJMymQ+afoKpT4JpKo6GHKB0qW7VqmdIffawjd7x9yZf/cfmy3PHHddBSL3IHhdu3WyBelDxImJrv9IB5tjFD8XGvjnV7N3IET1PwO++MxdMF1ZdpBYfO1VzWdq2KYHkiG9A7w8JHpV+gOhKhMtzw9bjWFFWRcYM8CCKMI+b752eCTe2jjGbulDDdfkm2bUU++Xhho4UG3kEaFRlH3VSBoWxjJlJ2Y+sEa5PApIvjxN0SrlMbeKombP/ZLdbA7Pr6iBiHVjLB+Mq9E0907qjMknmywujUR8HUq0fWzY8cbKYTi8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 00:43, Mostafa Saleh wrote:
> Changes in v7:
> v6:https://lore.kernel.org/linux-iommu/20260109171805.901995-1- 
> smostafa@google.com/
> - Add a new function page_ext_get_phys() and use it instead of
>    pfn_valid() + phys_to_page().
> - Drop R-bs on patch 4.

This series has been applied. If you have any further fixups, it's
better to submit them as follow-up patches.

Thanks,
baolu

