Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7FBFC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 832206B009D; Tue,  7 Jul 2026 06:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8091A6B009E; Tue,  7 Jul 2026 06:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E876B00A1; Tue,  7 Jul 2026 06:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED296B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:08:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2D181C7F40
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:08:34 +0000 (UTC)
X-FDA: 84961556148.21.F2F0D87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 28AC61C0003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:08:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X6bW6IZ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783418913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWPuPHES2Vj+Hpx9x4PpWWKB9PNpoKVRJlr6DknglJ0=;
	b=pzSeVRQL7F/VhypslcTdBZfB+siaZMyqC6l1hS0g2lVfrjXFq3yIF81iKZawMXN0Te+JvN
	35+WDVVw/2Yh56Ocy7LJpeX6hGe7HDPHcIzPhFNpprLVK1PTea32QJzSnFcfbewPFuyC1V
	Rv8SaWnvUQ73m5tMcH9Hvntt5T8AfL8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X6bW6IZ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783418913;
	b=nqyPnXSVhxjaBTeJORWSCWF2Ru3MAFs8Z0bR1ebo9u1nNPnez/S1NmHyKGZhShp2rKJMFc
	mfcIh2gruBWWXc4KTAuUaYGwrhPis5zpRioGVFKAhMn//HUaaB/wn9rzEamF5LzUKOHrSb
	fm+WP9pSS89CRdwzrQU4AVltAPuJkC8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4A83618A6;
	Tue,  7 Jul 2026 10:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55E11F000E9;
	Tue,  7 Jul 2026 10:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783418912;
	bh=iWPuPHES2Vj+Hpx9x4PpWWKB9PNpoKVRJlr6DknglJ0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X6bW6IZ7dFcKRgkT/2wU1TgO3ksnK3HpyVnM+mmOXcYwtJu6Jz+4NhKYoPSRiVqCW
	 HIj+aky7TYvJJYoMpMcc6X4RVH2zototSzP5XjTqp8gkSQDQfP6Y7XvRDcfiPFXqQn
	 jph461cm0SwaF0FvLf/ndNwDEXxreM+rO8d0P0EO8VWFN9gYaYzLFuimJiSyM+pzKu
	 wKEvqLI/peX3H6x2RLAJOZj/vwmbdi6VlByxZKHChlMD9dYp8utVoXeKXL1pUyQiHM
	 iYe57d1imqAss5kvOXDP935Y05SAhmftxl0i2QgHoAIYaPkPYjRczu8gMsDpsnixt1
	 AdO4iyaPao2FQ==
Message-ID: <ea713b4c-b248-4191-9ed2-c9e2d0f83ad9@kernel.org>
Date: Tue, 7 Jul 2026 12:08:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate: Avoid copying hwpoisoned folios during
 migration
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>, Andi Kleen
 <ak@linux.intel.com>, Muchun Song <muchun.song@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260707090136.52904-1-kaitao.cheng@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707090136.52904-1-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 28AC61C0003
X-Stat-Signature: b1bc888zucocwkg7chr8pnbsufq8nknm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783418912-163587
X-HE-Meta: U2FsdGVkX1/dBFFqeJKKBUgoiM6nQ2ERt4o8ux1NvnEb7cprsPTRNYEYHNL0XbqTS93U03ZC5FcV7yciUbchD9dGpBNPIa5JeskQlIPxp4yO7an9bkfI2d5Q/LOD01LfZlL8bWJEK/M7t5jkgH52Scd4UXTffRxkWPL6MyPT8hcOtzO/fRAOWDR8m6ifxFv6EkMkbjPq2VQND/s+RYRauK09/BAqJSke9XTTJEwVVjz0/awnstjca+MG4XThTdBHicvzMNL9LFyrUWgij+Uzd0fG3bcU6jGvXxy9+c3aSRyKFzE0xoYihAmeSWAgG31QJwFzsAXYLAUcqmMyV2RocuwIPMXU5b0aV2WRD1Fw8DgX1bOfNvQK/aAaedXeHw8w4oz0SeT/jA9wbDjRdu5xP98AJSGB9qV6kzisOw/6rwaEUdUVrTwNRns0VsUsUwCu3qlEFSLtX7qXpwHDo+xZtMdEJ7MdyIuR1OdnOtHyl5zS0Hfot60fb28vlesywJDcL79B3d8MSbIf4X3g6pKiKkcmDHqv3qJcfLPuBtYWt/NSS4MM3QXZjS48+CSqAGv/u2DwejrfC9pEv0NTZeAJuMpzzn5Qm86Z5Ny0v4nZnsWbFOpgSGqyS9AwtZ6+hPnlIgSoiG3w8wX04JahPRk3DiVzt4MUYu67FL+RRMXE0au2xHzzIYmlvL2pS212gRrwlKq6UhlGL2O1P5rVkYvvvwX/xd5QzqCDvcuMSuO9EzTYlQqv6TgAOoYhq+p6KGieltX2VcYDP1a+R+yCNlUX9+Lj+5KAC2IZ2tPqvpVka5NMh4pDnjwAKDx8rvjDZmC9bc+BKnWmnfl6OTeOUVfQ5ZECYiIwLnK7NddNEE07Q5oFshW4Eu8a+AqgRClS6SeFeqveldP1aujlHuMgqfnZLV6mGTPvvSlX1YPj+QFGdLQnPXOvG7FTsqrdOVCJ7k2HskzEg8ExROiEUpcZu/1
 dla3nA3i
 3kvR0iLCtqm71Rv7a+m4zXCM8cuefgHOwITLkYZbSxHriyPQWHD1XVVdn7EZZ/gObhvgr9sAcC0LKIlAj8XySGtRrKkdIvknzO5TGXu3snL6goznhdXKPG3Oo/PaPndgDUBXJaXV62AsEn0p2J6A5NzaXYpfTXV3axqNPi64Poqjj9MRDI7qeRVnvetD4Eyg1G70hM56D/ay9rl+07CpnjXNi13ns7ezyf9ulHl02yLjdJmqe/vsPChZjJgtbR/IinMknkSSAETIJbdsTz9aRzynh7PLeMCfm5ZqI08E42AbfATHBCCbkqeWa5wEyP6Jh7awQ/ZgYtPf4GPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 11:01, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> The generic folio migration path can copy the source folio after it has
> been unmapped.  For normal and THP folios this goes through
> move_to_new_folio(), then the filesystem or anonymous migration callback,
> and commonly reaches folio_mc_copy().
> 
> folio_mc_copy() uses copy_mc_highpage(), but architectures without
> copy_mc_to_kernel support fall back to copy_highpage().  If the source
> folio already contains a hwpoisoned page, a normal copy can consume the
> poisoned memory and trigger a synchronous machine check.

Well, but the code can still race with memory_failure() IIUC, so it's not really
safe either?

-- 
Cheers,

David

