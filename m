Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0EDD6ACD7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461126B0088; Thu, 18 Dec 2025 04:32:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 417E56B008A; Thu, 18 Dec 2025 04:32:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3372F6B008C; Thu, 18 Dec 2025 04:32:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 247476B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:32:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D16B9BE191
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:32:05 +0000 (UTC)
X-FDA: 84232075410.30.E7EBF11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1512A1C0009
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:32:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KtsUoT7A;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766050324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rXWmSIfXlQ7vL4nNPaXqvXpmWRTfX9Ph9usvbZhcEAY=;
	b=f9nHhv3Ih6IEJB0V4DEGAQnxYlQbsJIw01wAVVvIJ3RPi+3M+aTwMsMYQosl3j3yIbJa7f
	VswwnHAyFfCRPA+92pKV8+YYKEysneXz/IEsUCdwKaxUgJxuUjriv/lBs2fiIISkHdf8WH
	+qlMMS40aCXF2ycHxQpxt45B6i5kEHQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KtsUoT7A;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766050324; a=rsa-sha256;
	cv=none;
	b=2R9DPYEeJwUtURfw40OPapw6AumvjPEkhNBG+kho+qq88vCAQSwjzfRW6ful0ienNmecB0
	qL+Ep0du4owGjskM/hoESsQ6qWYJ0WFyQ9gI2LK6ePI0ygw5zdrU0BxGvt7WqSCj+MGj6g
	4KMOEEyeJ4XEX0XNSjXs+H2lTS5bBPs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 201EF403B4;
	Thu, 18 Dec 2025 09:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A5CC4CEFB;
	Thu, 18 Dec 2025 09:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766050323;
	bh=dvhG8sfqEYygPleLeUK3D7CNQ7o0b/Y0O54NJkeV+oE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KtsUoT7AWc3bULPITga265ziXXiV/R3yhm5a8E4tusf/EZWNgwrka83/YJFz2fFyx
	 bSjuQ0m2+BCkTgJAOVUgZ79m3eAXplk8mJYIWJvadCIvdzUDy1ohT7ac2aF1u3RaNa
	 lS1lb/8oPb7IVFhy5XSDPLarKvZ2DYgMWPHvv0rn0Yd/UnunEkUo9GcVeGs41v+FrR
	 krAV9W+Yw95i62ezY+8FvhhEbPtx5kxw2mtirFZM7252gx+eeGNfn5Dxg010vqIjEG
	 hsjkPLeWVXut3SlsuGGp1b24KACgT8iwhV/5c9xNV9kXg8lCM9RdZxiekFwm12ouTz
	 VP+QVK4SHiVwQ==
Message-ID: <3c75d915-5d7f-4e80-975f-4479393e7139@kernel.org>
Date: Thu, 18 Dec 2025 10:31:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: khugepaged: move mm to list tail when
 MADV_COLD/MADV_FREE
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, npache@redhat.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-4-yanglincheng@kylinos.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251215090419.174418-4-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1512A1C0009
X-Stat-Signature: djino458cmcof19cpjsi49qiaf3zszo3
X-HE-Tag: 1766050323-180380
X-HE-Meta: U2FsdGVkX1++L933DQRSLf7c66QB/GEfLBrHI4BpZjB1X//Xx8R5UeBxMVpy/+Ny/pE7BKthO1BxMzOCtyIcuf1g6l6NysohebNoetvlnxC5wZrWZ5Q0d3eVReUubQaPUKFP5e3IqvcKmgvqCbfsFkRWeCWm0crOfKm0DxyVr88YGIMet0ORZg9mTcVoq3DPPyqOF9sVQgVkR4O2EflYOWQnHLqYQ0VDmn/1NxwaqDJcWJ7nx6z2odmVMeU0SIkURbm4KKFOZTvN6NjuWetJXL80xFV0gGkso8XN2i1dg3FV8huYvICXb8lSWAvAq3IZgpnUnI/jEFLPO5PIYKzn3EBGZuEJyLape+cXst6edcmFRqycHBc0KHM1rzkxEgLFo5LsMtMMyLtNMsvL4/lH/0KYO77Cz26s1wAeHphIA6Wm2UFidcjcH12GgXUheegm1ODGl67zXMcNRF4kp9UnM10adXY+f57dW/ScC/+vFAZLzEIINvXjjmGltm90jQIq+dWGbaJAW8puadAbG+IlLCCO9ZUaRozN4vXJGhe3G2dRwnBBizn6EgmTMqXf3554z9BsN47m8oSTo0H/eJ229uu8jkg1Rkb/vhs4hDqOTfkUJ/jh5e5N8ffEgpeUWa0XTMY34JFrP919OY60MeNS93FenUhSTeuqdD8KyzawxCV2unGt1szl1xWJPfDSGkBqE7YF3jejT5BkHeApS0vri1LLgbBGjtzD5YiV7qcZrQTV5dOQ/6HtmkEQK3K+56n8PypCYx+GW+Re5WsSWAy5Wm/15axtL+cTbgTbgHx/30z3pwtq8pOmobe1Rwe2NW2q7xtKfGA12i0MV37CCXYPeoKWNA+D24olEIDPSbWPONrZgfgAewUobsqlVIlNOR1riM8A4UG+u9PJ+xVc/fGtI0pgRIMty8YBqBBmzouGLCgimH22BuUtfffLuX2XnhexJmihYaYeFUfdBS/kwQt
 +LYSn2b7
 0fi5Ti+rcQXy4sxKGrzjFGn4WdOv7XUY+AgxGMIubb5Q/3uHzQsb229+eoeyNn8MwlbqYT3tau0d9CTvuAN9HsGWjyc51XU1yCcyne6wsc3PokoCYVndPJtZM81MlBeY10+772lvzKYhZKAWW9FsacMvvFkmfwb73qGuUX8wTLyYlj/9Lgh8n4ywNmKPoMH3lEjlkNzem0geTDeP/ncLUkJ0dHrHa8WslAfZRvC/TbsxofKSiyrgf1FrtCXOV32oj74FYJH+fL0XjnNjsX+qOrH+zchF8WO8/8xCJ6cTuUm5OQ64LReijRaD9xw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 10:04, Vernon Yang wrote:
> For example, create three task: hot1 -> cold -> hot2. After all three
> task are created, each allocate memory 128MB. the hot1/hot2 task
> continuously access 128 MB memory, while the cold task only accesses
> its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
> still prioritizes scanning the cold task and only scans the hot2 task
> after completing the scan of the cold task.
> 
> So if the user has explicitly informed us via MADV_COLD/FREE that this
> memory is cold or will be freed, it is appropriate for khugepaged to
> scan it only at the latest possible moment, thereby avoiding unnecessary
> scan and collapse operations to reducing CPU wastage.
> 
> Here are the performance test results:
> (Throughput bigger is better, other smaller is better)
> 
> Testing on x86_64 machine:
> 
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.14 sec     |  2.92 sec     | -7.01%  |
> | cycles per access   |  4.91         |  2.07         | -57.84% |
> | Throughput          |  104.38 M/sec |  112.12 M/sec | +7.42%  |
> | dTLB-load-misses    |  288966432    |  1292908      | -99.55% |
> 
> Testing on qemu-system-x86_64 -enable-kvm:
> 
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> | cycles per access   |  7.23         |  2.12         | -70.68% |
> | Throughput          |  97.88 M/sec  |  110.76 M/sec | +13.16% |
> | dTLB-load-misses    |  237406497    |  3189194      | -98.66% |

Again, I also don't like that because you make assumptions on a full 
process based on some part of it's address space.

E.g., if a library issues a MADV_COLD on some part of the memory the 
library manages, why should the remaining part of the process suffer as 
well?

This seems to be an heuristic focused on some specific workloads, no?

-- 
Cheers

David

