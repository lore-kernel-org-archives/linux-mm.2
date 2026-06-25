Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CFABCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 06:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10C906B0092; Thu, 25 Jun 2026 02:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7B96B0093; Thu, 25 Jun 2026 02:36:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16A16B0095; Thu, 25 Jun 2026 02:36:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C280D6B0092
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:36:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DB0E167650
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:36:20 +0000 (UTC)
X-FDA: 84917475720.10.9CB73CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 56A43C0009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:36:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APJozXZa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782369378;
	b=cI7/suWQ+g/WAQm0IQgMJA441xHb848FiV53Cmnshnwbn1VOTcbRqVzmotUPQQOH0DVSX+
	esLw9bQao/hZkNiKy19FNeSfq25xf3MbbbSDmuJjr+WxfnwguJmBWj+f3isgeNDMbRMjAZ
	XIO4y3Zy836QXYjcKMQxc5r7TLc+WKI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782369378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOAqiyINFM7BvEx1IqRR602mqf9YbVI7DhcqXxXDijc=;
	b=cBiJWXBs8q5vUGm+g5O6TDlNjf7bfg1AS5UmA0AnREo/xAhT1OQ7ZHrKrGENITI+9sPMVq
	MjB2v2UmD0zNmuEVoG2kRcxfMUZNSDeADqhix5fd0Ev4l3GE1Y1/n4CEzEY/SDXFTkWIas
	c38wkojyy7ya1oyxeS4NkcLZe01wGTc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APJozXZa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FF4D418FD;
	Thu, 25 Jun 2026 06:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436241F00A3A;
	Thu, 25 Jun 2026 06:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782369377;
	bh=jOAqiyINFM7BvEx1IqRR602mqf9YbVI7DhcqXxXDijc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=APJozXZaP4+cwoR/EeSal3GKX+6x3ob1+AqrEbl5SS37YvzvMh+QkKtFICbTIgUsO
	 gW7G+XmaXb8Oe84nyPRdNrzKv9Ky+AO0ysPm8aBooPQ+QEMHQ9X92ToFgc9AZfBUFV
	 tuhxaUot00q3eYnLMdwoYLtefglVDGgs3eLrk7jOvdt8pTuS9lCbbkYThzoRQ37/+8
	 t4x3p0szb1BIZ40QKAs00+gJ/6S2SsEcP7ZprjyQuXfExFRvy+V1eneDOqfZvI6Ukb
	 Ou/T8FpUDerxB9DQsBsxy4s34iv5pm9zZjZVASQcj4+w0aVUw8Qb2bAtlBcEWm/Izu
	 t/SDBY48C5CbQ==
Message-ID: <d9f0896d-f5ea-48c7-9df9-bbdbc4fc8c0c@kernel.org>
Date: Thu, 25 Jun 2026 08:36:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC Patch 0/3] mm/mm_init: fix and cleanup mirrored_kernelcore
To: Wei Yang <richard.weiyang@gmail.com>, rppt@kernel.org,
 akpm@linux-foundation.org, izumi.taku@jp.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, yuan1.liu@intel.com
References: <20260623092351.13031-1-richard.weiyang@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260623092351.13031-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 56A43C0009
X-Stat-Signature: bgqmh5xjqe1rac1g6zxtk889zoxwude1
X-HE-Tag: 1782369378-240751
X-HE-Meta: U2FsdGVkX1/rqkHH3xoXWPgMthlpNUzlVp5M2WhgCOrmtIbXl2t76zHfd9YgbG/skyLsiiL3ckV4uOnB+50YtUlp4E4i7f+Eb4vkrBiKRgkcKaIMGGHhVDyQ4EMCssy8e6MAvy3iOibQH8ms7gzklEg793wstd9V3cSK+0ysThOrc9BXar2YoriqnPXfviNhjBPebCmzGc6snzxtFXbE6FAbPF3q3zkizHp2l5RCr8SiJpejwgRY6dvrL3b0iDvRJQHap8129aKbkEHYqiJsFftJGW5giVb5852kXUPdh9NiWJgHr7yVBTGw0RmQvIiB344fqlaawWlRoS0dJM9eVmOFqjM0Nw83ERkYkfJCTp1wWfSNBBvAqiKmJtjU2FEkaVZkgmeXCEC+nrM3fYBGKpayoBRNqYvkDanl1SJLDTPsjeL/Bx4PUt0zEFF+acRfi79ZpAgiTByJpQJ9nYQKL8eJ1JFlCTwkX+dU0C/NJ8dujYH2eRvAmU4A+3jD5fUb83t3CJzY+ow/gqXhsf8lctk1IApGksZMayGIanyvV2QvjSS7h+cfZxeNHEY1GI2nB/+veIb3Gn0EU4sQyNDbkaESnb+JI+Q7p/tkTZvbPJNfiHH+brT3TZMwLsnycZL5cx3d6QDQpLISWBbFcpldX5p/zJFygOqHTqYorqzQbhsKl2t0cr3CKxZhNSorc68JHCrdoQvdcsrsbUqZcHltVnw3t1yqmBbrb0SE23i6S2TKUrunWABOGO5mrOMGpBrMnlg/Ms771UzpqaKb9yXW7WFTDHY4LMA/X3+vmPv/y+eyau1Do68XaRVzW+/VAns4Iebk5ddp2CLmQX0XHtKtWyc0WBfa1DbbvlC2F3LQgr1Kbtsf12WG3abexP/CRt/dcsShEIrGA7dJ/Siax1c5DhpQL7kJVq1f0OW+IW4wIn6GgD1DgEVfkeuEf4N79oEogaBBh6m/oisUeLIfQZV
 Uo6WaIv9
 Qf4cUhzoa4ch6UCJcnhblmhp62BzOSWk+If0Ux/XUOZHOIIIbrCqSSvh4oIpLKwZNkz46PXkG2SY2X7fEQm/BotKLiD+aR6BE1ekEZPPfD2ts4vOWAOYpohYZOT1+OKl9uo+eJ74eBHgXRzqC9A4J+jrQZndsLTfuJp9M0tx+pEHhaSLhBY1IolCfoIeEWzp9b/fQ7usABFLb0q1rVQoQ0NJdNvSPCrfo7+cz4tFl9oM5pqa3UOZGh8HZcVLGTlV3TeRD6kS/43zdNrsztBK2DfjEKXwFxkCMiGSqjZd5/iExuEqZ4mjRqRELvm2b6ZYHX4LYl4e+iOFzz2YrgCuLhwYXJLXsA8gV9pHrdwLmpFCYmednEGPj0CcUKPB4aq8pGMIj7TbC4OiCwV+F0FmT2AKQW0FMIZEfJohWS5ys1/ljdbg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 11:23, Wei Yang wrote:
> When reviewing patch set "mm/memory_hotplug: optimize zone contiguous check
> when changing pfn range" [1], we notice mirrored_kernelcore introduced some
> special case to handle.
> 
> While during the discussion and test, it shows current mirrored_kernelcore
> implementation breaks other memmap_init() behavior:
> 
>   * disturbs defer_init()
>   * some Movable zone range would be initialized twice
> 
> The reason is Zone Movable and Zone Normal overlaps and current logic doesn't
> handle it well.
> 
> As Yuan shows in [2], physical overlapped zone seems not exist in practice. If
> remove the possibility of overlapped zone, problem could be solved. And also
> could benefit zone contiguous optimization, IIUC.
> 
> Patch [1]: remove the overlapped zone, which fix the above two problem
> Patch [2]: remove overlap_memmap_init() as there is no overlapped zone, but
>            record current double initialize problem for reference
> Patch [3]: remove absent pages calculation for mirrored_kernelcore
> 
> [1]: https://lore.kernel.org/all/20260520093457.3719960-1-yuan1.liu@intel.com/T/#u
> [2]: https://lore.kernel.org/all/20260520093457.3719960-1-yuan1.liu@intel.com/T/#mb0bd07ffd562a5b029f0f07751e580ca339c5b51
> 

IIUC, Mike will send an alternative.

-- 
Cheers,

David

