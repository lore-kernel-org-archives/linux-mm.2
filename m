Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F3E9CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E948E002D; Mon, 20 Oct 2025 11:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27AC8E0002; Mon, 20 Oct 2025 11:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEFD88E002D; Mon, 20 Oct 2025 11:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B9C698E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:07:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C1C4B6F0C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:07:35 +0000 (UTC)
X-FDA: 84018821670.08.9D79DB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 281BB1C000C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:07:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uCTjzl4x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760972854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2skaeUkL77/FUJfOfmBRF9HdR0Tv/kd21LXDhLUItZo=;
	b=R6kpiBfysLGBY4UN6QW5RWk54edrVR6SNKXpHbB/bmsRvMUXYftowDq9Bc8D60WuuznWJg
	EdOSBsfNc3ziC+PSTqm/XqL+T9hFTm20XZyqstuZ54zChtJyPEzVd//0uF2bBeevKKV3OY
	TqLdAri913/zOQhA/qNiuqrxpJN5t9s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760972854; a=rsa-sha256;
	cv=none;
	b=Qe5j0ex6REK4P1LzYpOtDvUNr1RHtL1QOwnRDdKr0eQbu3DQpviHyWp7/HVKycXvBCNzCQ
	jdtJ/B4o+2xmOsGO/EIol1+UoSq2e1LA4zSXaBeHHBC5/oVsQTeKDyn2PHLeams0fJYqLv
	mRKJIRmRUjujfhzCZ//33Q11ip7Y6kc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uCTjzl4x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AB4D61FB3;
	Mon, 20 Oct 2025 15:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FB3C4CEF9;
	Mon, 20 Oct 2025 15:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760972853;
	bh=bwQhCkgMC99Zv8LyOcM3w8mRBTrpsRR+wIqeIhD4C98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCTjzl4xQQLSCh8BfOGlfloYGuPhOktRQn9TYbo7BRbisO/vuuEnbusYZxtHVts0S
	 Ap0LGagK2ejJlbWOt3zmBHsfNvJmwAJ1N1021RdYA8oh0TO4cvf094l2r+LYtuZlrk
	 Db+Mew64WEk7VQgTyAcldwPAXa4XInE7swqqVHm+hrhkNnbk6PiAjysjEV8AzWsMyq
	 45k9uGsnpbVx0JWgYrufPGtAnJ7f/o3R/bXyd6lX4uCIB3jQtk5yhEF+L6YAasSpT/
	 YpARKswuOiiqvqokaSHQrOEfwE9enhX+bqTNoLD2HT+jWJEEWLA0HHSVtZ5ID5Hj8V
	 JOjM4cgWAEHqQ==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH v2 2/2] mm/damon/reclaim: use min_sz_region for core address alignment when setting regions
Date: Mon, 20 Oct 2025 08:07:30 -0700
Message-ID: <20251020150731.45034-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251020130125.2875164-3-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 281BB1C000C
X-Rspamd-Server: rspam02
X-Stat-Signature: qg67xj8sx9c9uid97qahrxqnw7kgx87i
X-HE-Tag: 1760972854-417394
X-HE-Meta: U2FsdGVkX19hoVB0xwspBYUfSxk3lbrJ7+p0Y6sVIAuqZb+JuDb1sXx0N4wkRnL5y7lpwuPigAZBsWEaF0BKJwdZl0837/X+UqULqATjcbCcFDbIuLdNsbc8UwhwSIQk5o1Fzzeetw+5RevEO9EM87v5yGkMcVtihZG85ftR9FuJxZDUrzYfT9F+kwiI63vrBaEHmY3emxBh4BACHaIbfZzp4zrk7O6PnIYF8IiOuFzjRER1hyCAAuOIBpSHoQXP1UYxpNtZsZJe/gWo+kxoNIXLxdFGaUijS0hgV2J/kZ9IK+flBRehwz2lpxnRIqjezN7ECYAuiwELekKtHQAAbMKbe1kLxjYBh0RJeCqHMpayQi6ZMSMGckk0XzIDPG5JlvuFy0nKGexla/okIZH9fC2x6mwNqGvbUZpnlyMrWo4IiWomAOkRNu7orJE9U4rLTSNsBtvf89sBm83TUgIpVW7Nj/eX7f1sbUwoESPjyy3gJIJTHkx5pVxqc28AWK5UMlC7TIULwd/joN96hYwijcza/z+JvphYCGFpReDGrzHr3zNtFTQh3IvUEX+XaN5bxGmZWkz1tzRuHDXeOWda1Qw7Hw0Dv8yw8U9NNWCJW4Qfr3RpoMJHYg5GxbdVLVDCGpHKT2yDsQ+Vnh0pgVbMHFrglkj6khwWfGGEd4hZyDM5rTBRbwo6NSuCjMw8EaG81grjF1voUwqnnk1EKRvJqmXH7fcsoey+Lw5hf5NjYdJMiPTRZDOC3fvm8yMRIj6l961Js7bLV6ejgPoN9IWavQo1HXzdMgBWw95J4ZF9c+vaDI2ZjRP896sLgTBYmXStq3q1vA9L4QuMRsGdfetPvhXcpmp7kUFpz3Jl+hnF6NRljnQLuPQfVKjnQwHaH8wFwdYRBLZyGkxWbrTx+/q8Cb+AYuh2hCg5QUHrkxr6dMJ3p9aOBSo75lk78OIjNB7Bt9Uq+zMkX/hjS/b9lHz
 tsASaK4y
 eF0WR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Oct 2025 21:01:25 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> When setting regions in DAMON_RECLAIM, DAMON_MIN_REGION will be applied
> as the core address alignment, and the monitoring target address ranges
> would be aligned on DAMON_MIN_REGION * addr_unit. When users 1) set
> addr_unit to a value larger than 1, and 2) set the monitoring target
> address range as not aligned on DAMON_MIN_REGION * addr_unit, it will
> cause DAMON_RECLAIM to operate on unexpectedly large physical address
> ranges.
> 
> For example, if the user sets the monitoring target address range to
> [4, 8) and addr_unit as 1024, the aimed monitoring target address range
> is [4 KiB, 8 KiB). Assuming DAMON_MIN_REGION is 4096, so resulting
> target address range will be [0, 4096) in the DAMON core layer address
> system, and [0, 4 MiB) in the physical address space, which is an
> unexpected range.
> 
> To fix the issue, use min_sz_region for core address alignment when
> setting regions.
> 
> Fixes: 7db551fcfb2a ("mm/damon/reclaim: support addr_unit for DAMON_RECLAIM")
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

