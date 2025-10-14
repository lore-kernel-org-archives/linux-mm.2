Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12AA3CCD185
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 03:15:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55B318E0064; Mon, 13 Oct 2025 23:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532FC8E0007; Mon, 13 Oct 2025 23:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4704D8E0064; Mon, 13 Oct 2025 23:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 34CA18E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:15:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B981813B9DA
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:15:56 +0000 (UTC)
X-FDA: 83995255512.08.A345ACA
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf22.hostedemail.com (Postfix) with ESMTP id A68E3C000B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:15:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DKKLGgE4;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760411755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LiV6b7SrtuoVZx67W0BalusG8NaB9Pi8HQ4FuVqaPtA=;
	b=tm6HowNCHMYMtiqZeoluCiH7rUvdVpzlW3XWXXX8VkwfjDb0aV4b++2PtzCAlpNLIXYZl/
	Ax+4H2OKoXqLoY64VHvDgW7XjlnBeZ/4zQrn5CIHxYHJT6GWJCca2pXu23tbpjV1QU4Eal
	lenPclKcnqe7KmhwCHKSjDsMg4TFcc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760411755; a=rsa-sha256;
	cv=none;
	b=t8j/+7QkNQhwp/X1ymXo1nXxPBcZFlo3wI1Zzh+rLAwlC0Q369mnG3O5+8vVtu1tw8+K1+
	hK4nELsNTXQmbOxm8N+KTfQRaJnPGHhY3w44jC8SbvhLZd8/bppfQ5vZav1TQFNIWjPgdr
	NcN+evgCpZG1KMPiDIsA67/PXQKKrtI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DKKLGgE4;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760411751; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LiV6b7SrtuoVZx67W0BalusG8NaB9Pi8HQ4FuVqaPtA=;
	b=DKKLGgE4q4rdFqpI8kuUC1pbl10cCWyiMeBFdtc47J+NSMynG7T0Yk0ULi5fYjR24+sCoVBX3yFYgPwqprIRUX0CpGeud74IiawcoBZthSxkUpEi7x5u7a5GS3+MdPFygmpnI5H/P3QC32aveW9wBvuQhBafknydVo5Z7+XzbQg=
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WqA1jiw_1760411750 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Oct 2025 11:15:50 +0800
Message-ID: <35e79f7f-5197-44fe-93f6-f172a95e0906@linux.alibaba.com>
Date: Tue, 14 Oct 2025 11:15:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm/migrate, swap: drop usage of folio_index
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@redhat.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Ying Huang <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-4-74860ef8ba74@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-4-74860ef8ba74@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: pasp6r1gtg9jyw7ubd73kd7xtini1ypy
X-Rspam-User: 
X-Rspamd-Queue-Id: A68E3C000B
X-HE-Tag: 1760411754-894736
X-HE-Meta: U2FsdGVkX1/pKCCcTV9PAIFmezel7ezJur/gMGG26vAUpl4P3GpYZgqD8AucwgOw2Y0f+WIJ9t70aaYnOcSdtLGlrzBdzoITn6QczGJHmZmyC+o8I77yNsqeP2l0VNkALNr/d7GNZmue7pBCsnUSIXfqWxdBB6begYP8MLatw0KmU+qnjBvKlTGoN5r3+ejMqnD1zoq4Qy6/XYNni4XKNabT10kHVs0fgAz1UrsExNuDUFz9kC7yCddQzpJRiTJamHSy6YDkCmchQ2hkBrJ7qPymB8wWZPlVJMu1nXRK8JkILnsN17LLkBodPznpQ+uFL4/i2EAN5sQZ+a9ef3gReX1GGas4+A2wsW9+sOq3KQfA6T41GK3g8tDcvvM4jDAg5AQr8zInju6TROPrCxRmj1EAPEOMa1H7DQg1+o6fy7tT3103nTtpIrVj6anEuoDFVlnnZrbrAoTwU6XnZHBrSc/PuViSgt5TsKwyRxg5gYxfeu8XihIqk5PkMAs/o56ccgJt13ATpNFvlSWivV9bvaseJlLJNHq2Lc8mOGs7JzMvIPhwyxlSC1AL4pfT1D9wtKmF7IfIJUSII5tn5KWZPf80EWKOyhSX+88efHCebRCMeGRPjRy6cZMfcwx4IV53mx6idRyZjQ9LRTNUpqdnEp3/+1zGouOzRkYojKa57ExzTUnHC8yheItBSYU2sc/GiJi8hnHAD1pnNfYx4gszvyjJl1IxEveahzf1sho34Zr3o5CWZk3VPfA/k43oiUKmKSElt1EOhm6qiWl3Jerz6mT7+mQiP9RzZUQU2FLMq3QPylhPWcDA2CSXRaW5A3u8lh1sVG7O+ema1b6VM0HDb4JHzUlM+5OBCGO+2Kmh96Aa3dXCG9g1Kvx9wZ3eXGToNfmv2dqEOC3k4O5itLWe+TqZgeu1uWgGleatyqrCqyNSnne2zKyn0JS9zzRm+70VHOTCVWWWriX2H4pcSEL
 eVfMft/W
 /MOkdratfGeqzIy7DKnB1quqf+tq4j4lP+GgkUzUWYzgtinb604iDQsPQaqnQ9wiSHrW4fFrQap17HM4KU7K/53Vtdd/NvealueZRJFR4PiXBBIOuaGwkCTFTQS3pdMsHgSbwjMxRkw9rtjILKs8fjM7RsFMqALC2JrQt0JKBvkV6aLp4Tru1MKOOtGFPVSY524Yj/lQ4uP++9IfLMoY4f4Hud0kMaEu/YmODLGO2XFTNg7nOyEUz207WTHTOee/6GOoizB2dMmzvb33k6nd7MmEYrYw3v0N0JCSrHqlhrnRiugD1IrBmWKupbupsgeUS7hpQ5CW+z9303B/UQl7NfLNaim7N4wfJQuogABfzOsMdsEs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/7 04:02, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> This helper was used when swap cache was mixed with swap cache. Now they
> are completely separate from each other, access to the swap cache is all
> wrapped by the swap_cache_* helpers, which expect the folio's swap entry
> as a parameter.
> 
> This helper is no longer used, remove the last redundant user and drop it.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

With the commit message fixed, LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>


