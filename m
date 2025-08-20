Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83B4CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 19:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6609A6B010A; Wed, 20 Aug 2025 15:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6386E6B010B; Wed, 20 Aug 2025 15:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576346B010C; Wed, 20 Aug 2025 15:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 461436B010A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:57:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD1B5114CF1
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:57:26 +0000 (UTC)
X-FDA: 83798195292.08.5733CA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3D426A0013
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:57:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BpYq/SIj";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755719845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ItFmsXcuGINtWrma9HPKtTLy8SF+UDh4IcCr23p6rg=;
	b=qFrw4L250/0HBbcJOgdqab5hbXwe3hAxvIMdbL4sn5AiLogULc2PClflA7+WcfPldJXmKI
	Ps9hetK3Gv3QZL6CtC35uA/kBX93/4wcmnbnPhKbsk41XyjTvlNVyL0UgRT//HqsMBFi1s
	MJKdHe9fzHajsnsgWk9XEx+/PodBmKA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755719845; a=rsa-sha256;
	cv=none;
	b=ztVrtqZE8Ri/4C+XheSBdgh0TfD5QBAkDH8mNQ8Gdd1q5RoB8KcqUgl9rC7fG4Zf0Vj9Hc
	xr6YG47xjXikkrqOp/7JNW5s1lL6Brz66AoMioCiQL0P5yvfuLkRxnJ4t0R0wLE99QM4zk
	GHNOUAovvwnrjahaJ/8VqvHfZQGYVg8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BpYq/SIj";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B8EA601D7;
	Wed, 20 Aug 2025 19:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20FEC116C6;
	Wed, 20 Aug 2025 19:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755719844;
	bh=/7toDdEpBhsQBqYTyTJdjzxa4ZHZpXy/zoIFE07ExQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpYq/SIjO/qimCxn4qbvlE0wka6mshMcGxyb0WLRSHJug0/GgX4ZHUfnuJ9+KhyBL
	 JD+GCx3fT7NvlIwTKnJxISRbKR78JtCEux8juij0Zy3Wv/3LmLB/AZ7wu2IWbl8T1M
	 nQSc1xKSYkpS0eeUAX9CKuYnE3PYSY8FI7Pofn19zhEu03j/B+MVs2dSAQn8vutnvX
	 hofsbROuKU4qjNe07s3alWNWmxtUaRxXg1qJcKhHK2XCaabMFLqiK8CiApPT6gQNOO
	 GqGJ5HYWZ9cITpvD9VGmo+xtLLevgKyOyhX6p/wdJK1ciW+z2NJ9YwQw7GNwGvH08G
	 NY5oGp0Hy1Urg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 15/16] mm/damon: the byte statistics data type in damos_stat uses unsigned long long
Date: Wed, 20 Aug 2025 12:57:21 -0700
Message-Id: <20250820195721.85577-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <3b5a37a7-af37-4108-a0c5-bc147bb77842@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D426A0013
X-Stat-Signature: kyiyzx439jxdgedp4tbam5pidut9e4s7
X-Rspam-User: 
X-HE-Tag: 1755719845-651982
X-HE-Meta: U2FsdGVkX1/PnimsqjqF06Tm6UF62xo0TPFJiwiqIJcmnaeXjpbnpBbwxvBi/oxKgS1UDoGjjww4DYPMMqi1hfRpLtl9N0oI7GnAFuP8M3E/3maZLhdh1youkjc4SJelcdaw2BNZPn32elwbtCMXXhrYMjGMSv1eN/8W1er9s3ruPFUMrjuZoAqHZpmtRxjDq+03gDxGnaqsalDU4RqMbB+MDKjVmcD7twGfzZPUJdDKz58oPKYeVCgVmnxXVzzemTrxUyfeYTLs+yazo85N88ZpIPosTOp7oRLXXHlAaHDxe/AlUp7/TnD9yxH05pVZW7ULgCrWpAy/ZsGZXFDpBdghkCqaceqouWc+0uaKRYJXWTKsHxUsjshtpQYI8UeEDgvNIQnvcTKA6zyOwCozb69XbPiO5VwI2ZdCy+bMBy9VzrcT1xoyLMXRHMkCwXUcjgTQWCuv8jdBL+NgPbNNYBf9pymoBVr42axSn2XjNYKwwAe5vMSnldow4efVtzQbGCrvCovelm/+77bxWvxN652olmav2W3i7Y2Y0zQTN8idf3Q72U8UMoOg5RCWSUQuPuosxkFlNfEPnADjWlWd8YMkVEn2riKqMLmolu1SLjRYa2nUAwLJB1Te/TW/ST4kyJZpJ3kMf7QMKetaWhznCMfkiFCots6wK9KEdoHpHHLnnVSM5OdGTg9YJZkA8tM2YYMvrPcV0kd//HMvwB4mqcUw3YukZjU5JWhy84CHeC35xunU6j+jl3Hk/qDsTPyYvpPHhyZU5YA3lD0sV8u0HVMzjKNjVV+cYvPWhA0Z0G18I4/yndtDx8+ZwH1DQ/1lUeHnk4tXuHqnIEv+DV8RzH67711TkrLcB+spAUKE5YOmTjsIXoiwfvGGkPu3kbsuzZOt2eySQjT+ygFkedDs38VZvHc4ch+FRJWkJcDZb3nWGcMyHPoT9vatJ7UikbObSrLntoOOLAeUY3PGGCN
 bp162ZPY
 3oEKbn6vJslc51q27F+Et5t5p8XqDbSPlNf6+GhZGXQAxTDtWmbjpcaY1TAPvndBYy9u2tyhmocLcGIhHn88wHIqELUgTDj4qafdlzioBiedMcjEh0VTXYnH7eilZPvVOYVtj0Eq3daVID7Z6yP8sLTFUsFi1We5X9RvCw9gLkgMtVVfcyuFE1TavsruUGqDdUNvBenPspStxMqXuPh4UOCY1GN89hLPMF3By6yJ0EC4UpZwRKjTKVbe6aKHkr/D6JmH0DV2hKt3xHaM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 Aug 2025 17:54:32 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Hi SJ,
> 
> 在 2025/8/14 1:10, SeongJae Park 写道:
> > On Wed, 13 Aug 2025 13:07:05 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> >
> >> For 32-bit systems, damos_stat now uses unsigned long long for byte
> >> statistics data to avoid integer overflow risks inherent in the
> >> previous design.
> > I suggested using the core-layer address unit on stat, and ask users to
> > multiply the addr_unit value to stat values if they want bytes value.  If we
> > agree on it, I think this patch wouldn't really be required.
> 
> Thank you for the guidance, I agree with your perspective. However, this patch doesn't actually belong in the addr_unit series, my apologies
> for the confusion. It is actually intended to address potential overflow issues
> in statistical data on 32-bit systems, and it is not directly related to addr_unit.
> This patch has been dropped from the v2 series.
> 
> After introducing addr_unit, if it is set to a larger value, it can help mitigate
> the overflow issue. However, under the default setting of addr_unit=1, statistical
> data may still overflow after a sufficiently long runtime, for example, when sz_tried
> exceeds 4GB.

Thank you for clarifying this!  My opinion is that, since we use core-layer
address unit for DAMOS stats, as long as users set appropriate addr_unit, I
think the overflow wouldn't really happen in real problematic ways?

For example, if addr_unit is 2**10 (=1024) and the scheme has tried to 4 *
2**30 bytes (4 GiB) of region, the sz_tried value will be 4 * 2**20, so far
from overflowing.

I think still the chance to overflow is higher than 64bit, but maybe the user
space tools can monitor and handle the overflow...?  Maybe we can discuss
further, but let's focus on the essential part for now.

> 
> Besides, please allow me to mention one point in advance: if addr is extended for
> use in modules(e.g. DAMON_RECLAIM, LRU_SORT) in the future, the term "bytes" in
> module_param_named(bytes_##try_name...), although multiplied by addr would yield
> the actual byte count, might cause confusion due to its seemingly direct naming.

Thank you for heasdup!  I agree it could be confusing, but I have no real good
idea at the moment, sorry.  Let's revisit after the essential part work is
done.

> 
> Overall, this patch isn’t critically important at the moment, nor does it offer a
> sufficiently robust solution, but I’d still appreciate hearing your perspective on
> the matter — I’m all ears.

Thank you again for headsup of the remaining issues.  Yes, let's keep eyes and
revisit those later.


Thanks,
SJ

