Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C0BCCCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 01:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306386B0005; Fri,  1 May 2026 21:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6A86B008A; Fri,  1 May 2026 21:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7C56B008C; Fri,  1 May 2026 21:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08D2C6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:52:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60998A04AB
	for <linux-mm@kvack.org>; Sat,  2 May 2026 01:52:45 +0000 (UTC)
X-FDA: 84720805890.15.B8B9A1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id CF4D9C0004
	for <linux-mm@kvack.org>; Sat,  2 May 2026 01:52:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JsJLhfNC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777686763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umHnM422MOC8FUOZRFQS6741IF5K+XXz8kWILKA0nQo=;
	b=6UAN2spmG12StDaggZk6om0kdtwM6YLPDWAid7k8EYKk7NRRewJ4ZFj6fadIee11EqIqZ7
	r5rZaGfJ5gU2CG4qOeGqZBR8bnSqaB+KSRn9KH7TBNQ+neefUWO+4GTC7PCdpASfL7bilP
	l1HTWytIqcoPWGng3wcD8XGSV7mL0fs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777686763; a=rsa-sha256;
	cv=none;
	b=rFXvxVs6/bqjQ67OMiglZy0mN1v+6dpY/Y8nMcK9Tyz9g8nok2YnJt62FjmqGs4Co2HARL
	S8h5lGMgRq+oyAEiaLb0F1dj+9MaBwV0FEQOektKPy9lrbHxfwWiTZiu9wQFPV8Kjd+tAv
	gxmDfaeFG5/K74bFfNkarn9Jna7GIKM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JsJLhfNC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4972D600AE;
	Sat,  2 May 2026 01:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67ABC2BCB4;
	Sat,  2 May 2026 01:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777686763;
	bh=bgpyMW1Ap8z75ihGWc9/YMYetN9A4obE3XY677Ommvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsJLhfNCrzhNpQBlak3df86wNUBKx97zsLMG1cIScJBGCkiuCSrzLsVxU9mtUfFOd
	 xPQZ+lbx+kydHrxTF+vsStUJYSUt/d1oCheyQFCAJcz7RsCOy7lw8ZTRdb8+haTQUm
	 YOemuhmFAXOKWnWmVJ7HW6dgojKyILaHTFz1szMOMyidwnwNOjBFYuOwx/nmzDiLhD
	 bRIZ+1X8FVHEVSYYWpJH4VgbgSplOiDeXXPNsrHCQfXR4e8hak7ZeBW2hg3JWxHYbW
	 9tphIsO+pUeVFZ0VYLSrpeAEHvhZxPLcAmOGgaqM/zdXSJ0YxE2CUOdNj25v+IgJ5f
	 yHat6WiXbR36A==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 2/2] mm/damon/reclaim: validate min_region_size to be power of 2
Date: Fri,  1 May 2026 18:52:34 -0700
Message-ID: <20260502015235.78679-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501013750.71704-3-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CF4D9C0004
X-Rspamd-Server: rspam04
X-Stat-Signature: erpifd5rzy65wimt1ne8cnqzjxabpg5j
X-HE-Tag: 1777686763-504251
X-HE-Meta: U2FsdGVkX19RIr/TeQrjo164037hej2wj4InfChNwSoX11HyiqtXd8BgdIi6a1FMRq1sATvxJXj/h+XqXL4Szy+hQqXPSyEG5kT7funNbdTAjUHgC4AqoZkCcPEF3zl4/rjON7ZIpGnSofasCJiCUICz1GVgyKWyWeHaQurVyabWZdoUtR0zKHCC123lqoppOkhI3j821cA62GvjnAwcnSj3Nh2vcAxoSv5x/mIvEum8yb0HRmFYNR8rBIx96K0O+0g4G6o9lvacu7hPwcT0D00VIKcOAnMPPFOXGNRP3kL4QMP9vyQMUALupimlXs1Y9sJ4t+Yc14E9wLjooEhZEAnZkVn3X8CZ0xtgKwIh+2VuoLVVAMvkYc0fM/QVr88csS8f1flWJZTHdaHlX0xd8Bjx+MpbwRulJQ99z+57FFM9RM5Bx3yV7YcpirNs/mE2u9ZyYYpxNzc3+F+/llWDI/RkYdVQ+x1n0GCc10rqzCrpBK7x3sRDCC2HD8GHXFpII2Fx6mh/htrClySX0uJzNgb82MahB7HHu1Hu3/FR7wR3+EKPuzpy5yUSDcxufos7mSoy7x0adIA0gtvSX2QmnpklOhDlMDJXpZ2oWIFXSzi52OIEKKDxuKIo9tdckD/ufv1dYOhK7A9GZ8hbDjtLgm2HbcIfsbzRuWPMXPqDqQK8hmCizamsaogCrRHNu7ImAGxFFqOKRBzGJOkpk6G16lAsnUlTpIApia+Ha9dXajK1GFgch/p2JY3+Gzgyq+Zqb1KT+YaezRhNEoWvwapukQQwcLOo3pFDLbnPUQxrBvA4nY/jXbYEY5Ahx7srwUgxALkhooojNUVhuq6qfH88Avz1ODR6iqIlutI86yYkcFHGR/zYFQ+L/cYxt7k9jU1voIhIIohQInEpVJWxwUaGjenWfU2Wd1VPSH8wHWvvsaDgNV/ltVt07DT9+LqmbkHOc3fPXTzvnRtV4HBANAf
 SUGN9qI0
 Yp2Fho9VxAj8fksodUPqmuOiipLroqiParQnh6/Qh0Bbwp5vGv2rpXlXmrsJotyidUsMdhBdgA5JKGl/QlIPA3AJMHc6mBgYGviWenk0mS8mUFVDoZ3qNSVNOtS18LBV7v2oycaK74vQzIMqL5aCIK2dIK/Wu0ORa0EWZmjwb7/d1+1qRalQeBSzlx/2cUb2lp4I4e63ECcNxgY0I/JWLIIYEHQ0vN0cJ7wd+zZlBE5tkMDSvBZZ0Yz2XXm37fObtnN7j7020QyHfZAhWzu9wBTPeiSd3PkH0WQZZhgP3OvGv0MI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  1 May 2026 09:37:50 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> When a user sets an invalid 'addr_unit' (e.g., 3) via DAMON_RECLAIM,
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
> 1. Enable DAMON_RECLAIM
> 2. Set addr_unit=3
> 3. Commit inputs via 'commit_inputs'
> 4. Observe kdamond termination
> 
> Solution
> ========
> Add an early validation in damon_reclaim_apply_parameters() to check
> 'min_region_sz' before any state change occurs. If it is non-power-of-2,
> return -EINVAL immediately, preventing 'maybe_corrupted' from being set.

Looks good to me.

> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

