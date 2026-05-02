Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B51CCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 01:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12986B0005; Fri,  1 May 2026 21:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C986B008A; Fri,  1 May 2026 21:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB17B6B008C; Fri,  1 May 2026 21:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C71A06B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:51:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D50371C0357
	for <linux-mm@kvack.org>; Sat,  2 May 2026 01:51:49 +0000 (UTC)
X-FDA: 84720803538.16.B6E1E03
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0B88780002
	for <linux-mm@kvack.org>; Sat,  2 May 2026 01:51:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oig1iwIp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777686708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wglN49z632dx00k0O8B/P9NoY7NewfX3MV9Wynsl5mQ=;
	b=BAn3j89aD8Q2MFOqhN/icH08C0ev+cORLf8odHUu920y/PMnMw3bRfaoJyCKkCoynoCOru
	/ECeXuZRxghywfXDluUQHruqEUyiYkArOZEUghYVrzc2ojLelcsYEaeKzjCg/YdbPWF+hg
	g/AUT8xbEMvrVfT7BeFbD5FO4yyz4D4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777686708; a=rsa-sha256;
	cv=none;
	b=hTokhOvPbNobXsO7vIhPHliNe5xhqmwpNMTTqvXUisAgI6velOt8eGJTglHpUAbymHSodv
	8dLVXzbcLHf9a6KkDdMQKpwfLlNIH4nKFcZAZ2QdoT7H2TgDytR/D34Gci5uQbdF3tEyxH
	HV1f28kCawiqDctIOEjbHBPx2x+w/cU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oig1iwIp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 33C20600AE;
	Sat,  2 May 2026 01:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8454C2BCB4;
	Sat,  2 May 2026 01:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777686706;
	bh=t8Z7xK5A6tKGFKdT0lgn7E7AJKpyNn35b6497y/htpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oig1iwIpdrkj/8Mfse/ppBN+IIrjv6wDZuDTKHtKNF0zBmJgkSL7qmpgwNGWnLc4h
	 m3GPQLfywqmVh5GoENJfNgzVZhuEXNNEHyLbbD1RfKMsc/iqa4/e8W6F/DwXTcaqHT
	 yFrTuZzmxN6pTg5lcYGhnec2M2bp9WFPRGIlcDs9EQXra7kv960AswriYtJhyfWP+l
	 NDZCAggD/6Dkirvbjj0pOGZl7iMdZjOB8oKMQ3i/DoeUwD6nAfkshl6iCFEWW8ZsXZ
	 FyMrDSi1w/KJJ21+yj+W1GXf9LMTnCE65Lewolt8dHX00auKfAfBRLJkYiND2FNvzL
	 zL8MHON6ourKA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Fri,  1 May 2026 18:51:37 -0700
Message-ID: <20260502015138.78551-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501013750.71704-2-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B88780002
X-Rspamd-Server: rspam04
X-Stat-Signature: ybwgaf3rw1umu9tg5j3caxc6q8fzsu45
X-HE-Tag: 1777686707-275240
X-HE-Meta: U2FsdGVkX1+3VmbgwstGP9XvUfVPw02kjIomSoWUN+ObJA1tIR0nidmXwbPjeQ8dHeGWZ+VQtiJnCG4BVfUAKf0Spl9m4WPkWjQGmcAPlXpoQg+uvNfSzcdPpUC+4fmY0PhXecVcZzn00DGV/tjX4SHdIlAwsfRiTt2+Fxzk5UoH+52IKK+OizPMJxGj6AUFkr+X6k7J13L//OSu2QQP55VcNp0Fr24naX0ZObkClzAtMIyvanPoCu/Dxposi6llpd9IN5M6jZS3EXn+bTBvcacfSh9MoKgXtN6jT0OUfJskArwykKLUjunf+lUdzz83tX+ZbKvSrxtRFREP+XSTTVbgapY/ZcBTDhYLCe56FMtTTIIEtHr45cHJq5GU/hL7tqZb7AfzabNVgE9ZO7p4WPFEpw0rhSdK6e5cxRZDepz6vgqJ31A76O5Z5evlIICjZ66f6niwqcBL0Hc1otEPDFcOJZ6lvMlBYyh7f0IrQEYPkk0NPyTc9cPuwPfD8vyw0FtITe6xZTHqLTNYopaKEs9UWDEGI+DXazlTyeC1PnuysY3QCCXYrg49q/GZDZf7XiGo6um2WMKGj+lG79ptGM57ZH9aFyxSlLS6MhLdqwnAMvA1KXe4CzfmvBzo2zqNq9UFROdrwKtRdqlxyP66v+nHiQyB8f2s7U6HWQhods0Af7SHaGgCVKcw96ys0EHmuEVKyjAxzvMZwAioz5OdPKDm+873En4tTyQnd/LSIwQVLblTwRBSEg4LEcQlMGcJPPb8JMJI7k6mFU2Ku2CsrG/J4VMSPR2yXHXA+O/LUWxD2YhkvdJBJnFj3oMvPvMOoPGOh36NRbu9otKeZuWrhLfHPp8n3iaSk3Qszz9TxEgXDl6t2Zsz8ZLBeICgJ5sY8fVm8Q+NpTkrnvVeOe13Nb0loqEPAF3ZXE1XcIANTe8gb5h9MIJzpOUwwgn3hTIyeBBHZzgASoRdQM2tnqP
 Vdn76u8N
 Wy1W0L3TOxfmJ2weCer3gwF/zkD+DvCsLbZLYb/suc2wG+haq1yUWxlpsVucWkzSjYUiy07XLR+iftz1maGchY1AF9D5pPYG8l2v4g4zqjVmOFZFXLQgB7jegXPsvtqe3G5bVkn257lh0nZ+ATZHzeZP3btaFpADsx7xzkvvJnn/h5VFUgCMRIKIK+lR+bgbie8gqGFsAWbf9nXp6QrVVDR6VGeb74dUDQkTq5zvAJLAsIMdC1aDZ3FBaDVP1av/uaLx3hwC2DwKJg7vQ0GD+9jKXqSivAcmM/95/7l8PFhDM4f4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  1 May 2026 09:37:49 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> When a user sets an invalid 'addr_unit' (e.g., 3) via DAMON_LRU_SORT,
> 'min_region_sz' becomes a non-power-of-2 value. While damon_commit_ctx()
> correctly detects this and returns -EINVAL, it sets the
> 'maybe_corrupted' flag during this process.
> 
> This flag causes the running kdamond to terminate. While the termination
> is a safety measure, it is suboptimal in this case because the error is
> just a simple invalid input from the user, which shouldn't neccessitate
> stopping the kdamond.
> 
> Reproduction
> ============
> 1. Enable DAMON_LRU_SORT
> 2. Set addr_unit=3
> 3. Commit inputs via 'commit_inputs'
> 4. Observe kdamond termination
> 
> Solution
> ========
> Add an early validation in damon_lru_sort_apply_parameters() to check
> 'min_region_sz' before any state change occurs. If it is non-power-of-2,
> return -EINVAL immediately, preventing 'maybe_corrupted' from being set.
> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

