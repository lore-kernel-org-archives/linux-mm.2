Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA67F531DE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 00:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4EE96B0088; Mon, 13 Apr 2026 20:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7876B008A; Mon, 13 Apr 2026 20:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F476B0092; Mon, 13 Apr 2026 20:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A25DA6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:47:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 34C6AC17AB
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:47:49 +0000 (UTC)
X-FDA: 84655323858.30.4FBF138
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9FCE58000C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:47:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFbPd3zO;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776127667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aiYsXtgceDGaHJteYmEM3PECp06FEs5dMiF0DCsRI8s=;
	b=HW/UcoP90NSgAnyzMerzGQu45167bw+ytm7IFVDT3p4iPLM3emyRPvUOmUjtnvu7gcxpY9
	DgADFbqT2LKwAH/qJTYxAeMcQijm5fda8/4oqQjf/BGCgXwaHqkL2cOYSNtMOEC2hZf1hP
	lLNZkeDKxhwPR5XYOXGbjAEdPrcN7/w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776127667; a=rsa-sha256;
	cv=none;
	b=kYus3KpBAFGHg2CL4uLIEDMADODW0RqPTrddt9TybEFaGqPMetzOB/tcKGsIi6n16fbuDe
	w96/4dinK0K5n2lr4ZsmwDzKg4uB3Yo5WfSgKtaQ2w+uCoGuDySs/yymq/rv5kixh5unLu
	uIOk4GdSmzVtDUdUsA7WjPNsFdxQG+w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFbPd3zO;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ECC10600AE;
	Tue, 14 Apr 2026 00:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C89C2BCAF;
	Tue, 14 Apr 2026 00:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776127666;
	bh=kwCR6jNJyCy5Cp/beB01W/9pSDx/xZgjV5/dwIyldN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFbPd3zON/QBBLjsaBL9P4bAEnAhFOjdcnQ1A91hGh1Dgrup8rO7XCvvVgB5Rk4Qd
	 VURnfGuEv9yb9o8FcefA/FAeMjj6vv0nmBYrigQSE0A2mRjpib11zJa7rKsJr3KXBU
	 k74GIc5CLK9Hc09IePt5XQKVuGwf1dmNJ68rqAQQpsNI2F/cJFGILlt3GZ+vIhSBeL
	 n6xlOpnR1FZZAfIO7B1Socc3uoPZ5QvuDr5JHieb6HPN5EvQVca1+tvuwZJ6TxmxAT
	 0Nd8qyZ70fzfOgYeiDIhwCoU0G46U4Fxj9/rNCCns5YwfBUiW2A2nSeOh3V6KNqXLx
	 4H2I/ATLJOLyw==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/1] mm/damon: generalize ctx_target creation for damon_ops_id and add vaddr support
Date: Mon, 13 Apr 2026 17:47:38 -0700
Message-ID: <20260414004739.83961-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260413145943.512192-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9FCE58000C
X-Stat-Signature: xw18heppbkfjyocbp5ecbuisbgfz7ydk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776127667-428275
X-HE-Meta: U2FsdGVkX19+574is08D3XmcrnAnny6AsyjDNqpG93eJz9iDMhSSKcffRHWNAzGIEI89q5R5HtxaZEoTOkid8GE43khQ3xmmG77eY0MFHxvcalCxpSD4tfFHsKuSsEOmITaJBPLB2JvU42uamLvuI5KTb/kp9AgribZGsLXamW3IIH00pmZgbLNASjHgQMLO9Mbr3g+/O7EO0oYbp0+5GJMUbkBh5NDf5HJUCmGOQBVQAARp/NoB2u5er6+65+WyvnH+9Dli5QSMibdTY6slQfkIzm4DFSAaoI3Tq0YjoDEXUUldKv7odTFj48LUNfkd6qAL3F9or41S9XrLnlCH6i7I0y3EoHFga3xatMMZzzSRgAYNwc2ieYPSOuL+XgS/VGu/8X8+DIqL8EAMAMaX0n7zeV42Toi2bU8fpNE9yYKjvQCcZ6lUC2D0NpWUt0Q/8ajUyMtIpvwdhJjGHArR4shyRLXBNOwEPAHvHXXKOlyC0dEdfaN+f4iSu1Wdx8yh1UYqWTLsIa0XalsB4VxaOErRHiRRlutJviK6jMvCjJK9NxM+vG9wJpPXTELBPxYK33ZChrKCeJCTv4J0/M4NsIXhDBqEAgC/1YysE9OBnTDYe8I9LIcOCqhOZh0hy+6z6pwejqqp3gQL62C4HuVScti3VEoKZXLptIeRpQuuHSysc5qLxbd+5jbMju0Y7iOflQb5tsYmiZPjDqk9qZ+fdhFqVhuIR7AZlbsyv2xlqwVMbQxo3T95Mi5eMMq+m0Mx/O8eI+2Or/PZOfvzxkRixuw/VmWmb3k1ab3jmF3DCCmQiWjCSuN70plVT0qsVYIIID4FLJZ6DnAUIkVbxmjQFoPqVoA/24558VhY2XsS2HGA9hgxt/8QBW8k65s/fBDwNPkKEC5nagbW205mN2M8+ipNDLXnQUFT4NwJTCOgbo2v0TCBNDCFOyYOokKtqVwTyhYbIU6L7/aXFqzPBrE
 O8Kx2P6G
 o1K+WdnVnmDgKuIBtEif5od4XTHskCyYr0saMFB/Jh2qw13AmY4uOEr0ojiUSumR8x0xsU2jfCLGPHtS5jxB92RMg3xC1GtK2Z/vjE42M/gu1pkHdehi9eqxoBxD0hQReHNKwgCCSAO0vwvDpTk4DaKn3LXE1UEbQdX3up4OqH8ilm/Kfqv0wZ/eNSYHQnZbbavSGHkr+Dv9vjgT5cbxrwBFclWcQMPZNFbbk2OaYJ/Csu4LO+hA0w8h8rcPSPwGi6nMpKyaicT9YB+LWT+mAB3ZB30eKJa7W3OTe9FUbAnG1sHfMIjNLBn0L++d9QR6aLWn1Ox9Vdo0U58kQVmLQF2cKcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Apr 2026 14:59:43 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> This patch adds a new function damon_modules_new_vaddr_ctx_target.
> Since ctx_target creation for vaddr and paddr is almost identical,
> the logic is extracted to a new function,
> damon_modules_new_ctx_target, and vaddr and paddr functions are left
> just as interfaces.
> 
> This change was suggested earlier[1] and it is needed to allow
> developers to create DAMON modules that use DAMON_OPS_PADDR targets.

You mean DAMON_OPS_VADDR?

And I agree this can be useful if we will make a DAMON module that runs for
virtual address spaces.  But we don't add new functions without their callers.
So this patch should be submitted only together with the caller of the
function.

> 
> [1]: https://lore.kernel.org/damon/20260311005759.90440-1-sj@kernel.org/


Thanks,
SJ

[...]

