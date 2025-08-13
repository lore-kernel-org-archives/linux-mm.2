Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E570AC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 17:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833D99000BA; Wed, 13 Aug 2025 13:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E49F900088; Wed, 13 Aug 2025 13:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9FC9000BA; Wed, 13 Aug 2025 13:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD19900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:28:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F30C5B9844
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:28:41 +0000 (UTC)
X-FDA: 83772418842.14.1988322
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4F18E100009
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:28:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YodXG5bM;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755106120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bSIRJ+h9a5rpIEuuBWo21y/uhs3SQaTh/g5I9EslgBk=;
	b=Qy4gt3bVfGlhgnmD2xR9N9UV0A/QByAq3Dkj9JHh7cG8GTjqyHpM1Ceqx9Trf688kLhI5d
	zcjDXpymnKPIoSNBTx7xrBZWF40JxqagTO/hAVQ0x508HaUxD5giDFJ2g+euU5nA6omWQV
	s7dpo4vYxdj60S4L/AxEtpDl5JywHdQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YodXG5bM;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755106120; a=rsa-sha256;
	cv=none;
	b=HLLebJYenEwwyO74MBBpQe2vwd5BDslyY2kgtp0BGrF7TUVqhzgCR0mxrK+ejTh4k+XhuP
	MVrzYDUjDBckwob6MGY79Q0oz4Q6bjaixciDqt2P7eu948cUmayP+zd4KXzhcHXBa21VlH
	G0aUH8qDaKalv4ksbsxKVF8Ez0ItZqI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 26AD64432C;
	Wed, 13 Aug 2025 17:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46D2C4CEEB;
	Wed, 13 Aug 2025 17:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755106119;
	bh=0cgYvn5Ljx/oaqxoyW3chdgTsnV3nXNB0fX+rUyitBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YodXG5bM2fcZD/K6wAH7xEBEGAR6RYAmbyX1dkPyrf2NIbkx1R93CQDZLDPYW5lN7
	 3F52mhkNx3Aw+0X+LzU7d4wmz9QLalW+r06IUDYvDNf8HbD6EQOHU8tFSCBRcYywGw
	 OVRIYymL+TsMnKHqvm3qs0hInbm+VH2Wq36+18BC1QiCb5zaOXO2efrvRq9qzzBtmE
	 JJyURSeNnfKOxnJ3cWTM9S75rH3G2Vqhx0s0IrZXLVbO+2lEwud0nlor+awaBa2a0V
	 8FYPTVZXlPDoJcWsL5+gtrdt2XbHWdBmMpPOXksXbbh/bCuCfrF+lOnhCmfxsH12y1
	 8C0Df9i2iBIrw==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 00/16] mm/damon: support ARM32 with LPAE
Date: Wed, 13 Aug 2025 10:28:36 -0700
Message-Id: <20250813172836.6743-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8zf9ong9qupop4y1fgawgatphcrm11hm
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F18E100009
X-Rspamd-Server: rspam01
X-HE-Tag: 1755106120-372692
X-HE-Meta: U2FsdGVkX19T/gZkPy/BVYugGcyoak7U14KXrAV7QnhWhhItdBp4k8SfNJY0Jen4Moz4SBo02PIP7STECmuwI/LAEMsYvAUMJp8rSEp3xCGUfo/h3qClpeLtc8kJc/Yqtu9ju/zx0eFGv4mAf/2WXmUEptAqgwTKjIPz/G8GKDyaeSXc8GgP48W7qUhQuwEXskbvvILNohTtmKeS+Mz9i6mRJjqBj4BLbOPDk+A+Sw2XyI5ZMrT2aYA2DIdDZESP40YfJ6YvlRwckV6HsZRevKAOEiBa9hVAqXvpX1PNUtSa8HkIyAex1T2wBSmVTm8MeagsuGd3vYlGcpUmvqK7jCIFkCtIxHSf6KpOwg+1Vj99gNrMcuyYL9macNsz4rdNxnm98u/jA3BB02C9cBoo5iYQWq3KIJyrupz0p6cvtR0oxX2eIJ0z/HM7oNH1Y9FYEosC1LaKaZCpXZuiyryVw9ba3trt/I5t5tA/y35g70OoTGYkkUejvy/4Da8RkOMiYM4SrIhRvTbFuG5xtjalrYOgUUB/kFBTb3rcmtp7gIRTZUTymGcpQccH7YaS3ptgcr2ZiQ1D/fPi81oK8ZznmQWIZFdPsNsY/Zp1UbmhM4eaWyJgV+VK45/F1KGHeiivsUF2QUGINcXcO8s3ZGoOTJII44Y+WArTT5yQG/Rr+6Ii9d2yMWDPfDOvGzfrUMJ5VUyBZHXA+RCbNobwZHe0IDWTgjbc68GVcX3xOXLqUxIWiVztZyjv+Ufd5/FL1W7cWf7zYCpGCJFnINd+n8nbMA4uka7wXrs7oU8OhtlmojcnZBk+t0Zsd/X2jsWjPUQPhyfnmLpP46+8EMIvO5Mse+vXna0sQQazUQ0xcgqHfb9xD9iGOqo1yh4PvuCcyNEaM1hD4X+NT4Op/KO/DRTgK/26RYiMJw+Q66MlwdNnxYPYraiBXUdKwBQOT1W7Tsd0YgrMzWOYr8u86b8M67B
 1cMwahra
 J8CixSz23xv9AZiKnMonjTuytdcNFKEIFc4+swqoIrPZrhml/toY1t1JG0xynje5s6/RUe+so4uIlIVd0hI+X4c9LT0feTBfPjr5xwW5Vkhc3u6lC/AVlgZNaMFnk/D1hU2Eg930R1Yl+fw9ejJJ7gOQoHc360gqeLvR/yNZM0mHlj7w0mYEq6aMrKosEgpNSeBjLzfp7bgKy7oKDZRxrVsSycSvBFytyd/1Pc0jCaIaWPoj+90hlQKjxxqaHGHhiO8oJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 13:06:50 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Previously, DAMON's physical address space monitoring only supported
> memory ranges below 4GB on LPAE-enabled systems. This was due to
> the use of 'unsigned long' in 'struct damon_addr_range', which is
> 32-bit on ARM32 even with LPAE enabled.
> 
> Implements DAMON compatibility for ARM32 with LPAE enabled.
> 
> Patches 01/16 through 10/16 are from the mailing list[1], add a new core
> layer parameter called 'addr_unit'. Operations set layer can translate a
> core layer address to the real address by multiplying the parameter value
> to the core layer address.
> 
> Patches 11/16 through 14/16 extend and complement patches 01~10, addressing
> various issues introduced by the addr_unit implementation.
> 
> Patches 15/16 and 16/16 complete native DAMON support for 32-bit systems.
> 
> [1] https://lore.kernel.org/all/20250416042551.158131-1-sj@kernel.org/

It would be nice to add more history about this nice work here, with links.


Thanks,
SJ

[...]

