Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DA16F433D2
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 01:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64A06B0088; Wed, 15 Apr 2026 21:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14CB6B008A; Wed, 15 Apr 2026 21:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2AE86B008C; Wed, 15 Apr 2026 21:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A1A096B0088
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:02:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B8C08C1B6
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:02:57 +0000 (UTC)
X-FDA: 84662619594.23.82E73E3
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf19.hostedemail.com (Postfix) with ESMTP id 768881A0012
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:02:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Uig85Owz;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776301375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tvR6j+WnM9Rqg1W+aSR1Bip5pdx0V3AQgd1HBaA/BM=;
	b=cVtjSOWx0AEpWKm/xS4LaKP8aArbUyhSs08tTKG1YOpJIohTDkD9uaWQbMDwykZ0+mZaaj
	v82qxlbEa10qbHiFDY7CRdhZBIFfU0QOWjVegbTi5Nb5mbXerwpY6rgGjTStkw0WfO8JpF
	cxWpgOlXW5ZxmX4v60WlOlKnzdbmf3k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Uig85Owz;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776301375; a=rsa-sha256;
	cv=none;
	b=O/YF523vqtnC6Pn07KgzN2ARGrscKUGLOF2L3HpubomCYFSwo9o7GQ9vDaSPOxhKbUoJ42
	K1ysOhTkGoy/UM/jUxp77uSEH9Y4BZBDlQDQ6csBpcmV79UblOOmIoI0vavW7Oyi/V2u/J
	wHy0GzaQsy6uRb7a0A/kT0V73MMavM0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776301371; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8tvR6j+WnM9Rqg1W+aSR1Bip5pdx0V3AQgd1HBaA/BM=;
	b=Uig85Owz2qrPGTPbhph4jy/e29B9PvJSgqZtbz9ZPhI/35eZ/TmF/mJGIGSvk/og6fRi/WKoeHfhx/uqBnu3hR0XLLDc4yNrdhCHmAG4Z1cWK27CiYUbJjOOamqbta7sFBVbsTDkvuGfh7Wfdyw1TEjNEde9dO8Nmr2z63HIt1U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X162oXY_1776301370;
Received: from 30.74.144.131(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X162oXY_1776301370 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Apr 2026 09:02:51 +0800
Message-ID: <760c048b-8da3-435b-a28f-fa8ec519cdc6@linux.alibaba.com>
Date: Thu, 16 Apr 2026 09:02:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, hughd@google.com, ziy@nvidia.com,
 david@kernel.org, ljs@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
 <ad-WY2B_9OxyWlzX@casper.infradead.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ad-WY2B_9OxyWlzX@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rf9df7rcisx8bnx4ndzk8cwhiq79wcg9
X-Rspamd-Queue-Id: 768881A0012
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776301374-900096
X-HE-Meta: U2FsdGVkX18N2yh4xFDifWYK78ZWP+m+Urreh64E+299eX1aRNNH7MzBGkqvOArQbYglCEpJQQXf7SeEvYGF/MQj4/b3bOiFijHgy+Jxt4Zf+A2Q7WpukETw+P7Qc8sHXtLUTyGadILFvEJCkFLFhI691TgZqMeJdV0StHK1ooFgAKtIS2L7+3/73l8L0jVZJDi0lv70W1H9i7Gh3i48758Y48EzRVpRFqDe2AJj11yS4LRr0BCyA4w535ewfAdU1YlbC27KGtcH6WX2KB/UniUk/5zDVtCaQVgokTac4WMVkLq1FA3AgS0YYK3nJPOauR6EZpAoVdUnTI5+wj14MOFW/QMOjoRJf3TbCRTy3MXhaehfFzwruvmonYvHnRrIAPp5ZFBOzI2yhHCvuDA3CZjclND6l8FWptt8D/u7c63TsjB8uNFxYGJgQKa6aSsaXVlAWzgbfjN+BWpdJ9Mfr2q0UuWGhE5WoXFE7hWtQ1KOtrrEXktSfwAFE10smrFlH+c/C1I0Z/Cvt89vnO4fjZqHkTfhMPd7Nsbjcgwzo32l4qs1mie1+3bYLr4HPDEP/wMJdBDHS4z/GdKT23Xdo0puO7CQr6on4/PC8Y+PLC3Lxu2iC3soTfoGWA8TyCs8K8ewja+nGhDVAmTA5yZy1lDESPF+qYYQp4H4f6OuQjrazsJ+BOk6frxG7zF35Nc2oVpL7eZprqGrydfZFARuuHj5ChAXxmiro0RywmtysACmyoI6GEKOju7qjoxYn5hu8TX06lMHcNk4MStu/c/IdYAygE74C15bFFJgHT/54bZYvYaC5gLKXCPUmDVaEBGFqf45lpFoAzkPzk5p57j5q2ZdS/BEVkC7+c7ahuedbcu1F2gFnKl0GD2jXwlrSWJUys7PvphQu4m1gigGome4pmxvy3XNB4Iv7dwuVkA6jTBQ3m9mhJsgI8YuuozHfUMTiAeP9uvfoi17Tvo9MCD
 RtuevMOy
 HnwiNA+hezvEDLRAPm4Ejy8QTy1EYilQzdBB6Z59J6NiQRsICrpgKwhb9m48OfuEZTC0UaIN7Lw3ycyerxeAH+hCX12gFxIvmax6sPZHj6ERZomoYhfSOBlF97eTj+89+Bv5YKyBo1BlUwkMXAr2bIxzxujvgdR4qJcEfRJbpHA7DtftVNTuMTG9P9mHHG7zfZaSIVNFla3MrfwMsoZylKs+IafS2hPt3nB+qWtrLzWPBet4uYmYUIJXweWK3wIQHz5DBBnnajySmoWp+PZAldvb0b7VEY80p5RdM260i/z04buhLwzfL5mPI5PJ2VJrskV0ECEvW7LubVWIwMPxHq4TYeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/15/26 9:45 PM, Matthew Wilcox wrote:
> On Wed, Apr 15, 2026 at 04:22:53PM +0800, Baolin Wang wrote:
>> +	/*
>> +	 * Only set the large order range for tmpfs mounts. The large order
>> +	 * selection for the internal shmem mount is configured dynamically
>> +	 * via the 'shmem_enabled' interfaces, so there is no need to set a
>> +	 * large order range for the internal shmem mount's mapping.
>> +	 *
>> +	 * Note: Don't consider 'deny' for emergencies and 'force' for
>> +	 * testing.
>> +	 */
>> +	if (sbinfo->huge && !(sb->s_flags & SB_KERNMOUNT))
>>   		mapping_set_large_folios(inode->i_mapping);
> 
> This isn't how mapping_set_large_folios() is supposed to be used.
> It's supposed to indicate "does the filesystem support large folios".
> shmem should be setting it unconditionally and if there needs to be some
> other way to prevent large folios from being created, we should do that
> instead.

As discussed with David, we’ve agreed that for anonymous shmem we should 
set mapping_set_large_folios() unconditionally.

However, for tmpfs mounts, we should still respect the 'huge=' mount 
option. This was a previous performance fix, see commit 5a90c155defa 
("tmpfs: don't enable large folios if not supported").

