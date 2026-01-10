Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 080BFD277C9
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 01:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F7D06B0088; Fri,  9 Jan 2026 20:28:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B5C6B0089; Fri,  9 Jan 2026 20:28:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC91B6B008A; Fri,  9 Jan 2026 20:28:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DA0156B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 20:28:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 659F4C5544
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:28:20 +0000 (UTC)
X-FDA: 84314318760.30.3F2A556
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C6612140007
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:28:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jDHEbAhO;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768008498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhGnR0/vx0hEQCQvVcoVyJuFaz/ljeBIfw1XoZd+LS8=;
	b=td1NytQ2m8dkLpYieCMegKDnDNdUIEkY7+5RKJiPqQyyXKv2HyaQwTzLc4O08gQVkuSC32
	V8a370fiufZun7U2aysYp+hUMOVQXwng3ZndED6B9BzHWgH+y1WWaDzKzUkWLRQDOsd9pK
	F3ffgmEo+Vosd2Q7LPmTiYt/5+3p0t0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jDHEbAhO;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768008498; a=rsa-sha256;
	cv=none;
	b=DwlpQnMhvulooHaY9Vxr1M0X2anyJDL4McbgIvsy021UakHJ6O2jEQ9LmJ3rWZ7hG0nzSx
	M+KEK4WG5r6+8fXc6RVbovF3O77HYHWUTULB7MUoNI4A5+FvTQVnq2sbIkpFZMEyElYwI8
	xyI46ir+8GKYoXjPt7tP4Q3MjSqr3Oc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 436AF600B0;
	Sat, 10 Jan 2026 01:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D936CC4CEF1;
	Sat, 10 Jan 2026 01:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768008498;
	bh=2c/sFQx3dFKJ8r7R25DAkJMqmSpmkAbap/ZQrLMjgI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDHEbAhOrZSqrtBSfjCBhsa0UL/MbVfi1+bzpRDI0dAHNw/TWqCYWnwDEod9RbyHD
	 YMfbYSYRZ+QqHCvy0CkWqHel+2P5M22ZaO1QpxNq6YKh6RF8NmdOL7etLRFp48GSP7
	 76spMzXs6ds4cMrfbHQS29vpJzfDN1FyiGlTCExJjWMtikUjLuz1AipcQj+DK3C8Xp
	 tPO/XoVg8AnYDjz32RGkhHdzSBT0FI87/fQFPho9TM+YkBa3QLHDFoV3pazm8V9DBH
	 EOOYBNSmo1VNXLxiCaFtzz/4cFL0IWCI5IUQ/aKiDXymwSLXxWBVQGx8YmUhFJ1l/3
	 f18RP4v2xdsDA==
From: SeongJae Park <sj@kernel.org>
To: Bing Jiao <bingjiao@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/vmscan: fix uninitialized variable in demote_folio_list()
Date: Fri,  9 Jan 2026 17:28:11 -0800
Message-ID: <20260110012812.81501-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109055937.3739860-1-bingjiao@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C6612140007
X-Stat-Signature: 6ursdr3hzh3tj77utsbmeirxnjs3si3w
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768008498-174483
X-HE-Meta: U2FsdGVkX1++J15QxOY20CebmFqJz66MxxDmzpENPFDYybi27RL+4XBFfVCE9ISnmtU/9Mm9Fk3uB54HUxEGZ1wmFgebT2HpzYCrCDzfvyiWYe7LovxR82dj8PQOwUl2w+A2YtBa7fHK5+5z5ZESjlFgHVa9y2xUtxKsOSmrDTvUrBvXf7xlOi1qI3RYg1IF9iajXxE9X8qOaF8QRh0VZMDDZOUwHlaLMWV3ve1jvves4WNnHboyWg/ugFCj15vx9sbHGPoDXKHmTJPLDaWqDmR++dzofRsicYLXk4ixAwSbISNEIbUvTc623mH0Qd/zgCUD4zcTMMioTJtmksvNBXnw6UN8m+mkebdcgmNkZsfPqiy6btUJ/jNM33Sz/jXdKZrzsX3y4caR+rl/pevOGVANaJhC4+7cI2F97+z4a/QlmdXoXSopLvhBByegUInRzU2oXdkiAX7SaUW4FzAL7QKT3bKX6aZycqN1t9a/+PMqPLocBmRIxq/qjOMGZU+ljmjprDRs3FQFm/VbXuowOVGF+31Z6bv+1IxCOmRbNWpT3M6tYli56R2petcvjYBcbolB/nnXTB3rMVCIp81kHrFoV7/NzAjp/eC/Do7dkeH9xFo3HeynG31GvXY4pqAXONnLdq9tki+NAfSeMaPe+fL5a65BIdiMmYQHuLeV53HHmM6ihyTXoWE/W2L0FwVVKbbgw2wk7bejrAgHKk9ELsqJisTgBvq6pRKAnb1MplITuiRBv3Gh0foxelzKQRhJu4DXfEt+BEpHR/O1ex6qbEcOHSTR/ca+Nej73JHn3PEDWXnp22PMBzM53VCkZVZ4/29JS9elymnfv5MoE8gjGc2ERdZWS7Uh3R5xFd+VSroIPACW4MsJMX71uqMdX+g8diH+QQARxx2jLPkow5hlKhbH4LXH9hQLedGSTCmBkH8V2RyXJwtX6NaPV0ZOSftuTpN6BQ9vat3IQoxTLU8
 ukg5Gx5S
 GszFUZeEnA9hJCGFo+9zrE/u5JkLFylvUXw0ETTtd1A4rKbxW2ovSjDgBYiG1IhfF5AiJxiB4fGR9GhdQUhLg1CFyBx9xgVLcQt9q0NtsF5fUJYvc6rhowZMdo+6OxwEY8IWbvTbcVMTPKF8wtIL7zUierOXxSWcafimVnrOt16lOPtmK1V6YjhT/97c1eydwSFGqSOhbG0pHyLa1Vk1MVFYpeuLyTSVjli7OMqlEzSWoCwZNzu0iLBHK+2iUpEly8DyIJLdvt+OXKrzs6GPNe4QSzh/veNbiFhYhEKdFGtp++N2Xepuv0CW3pBXLiv3pAeAe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  9 Jan 2026 05:59:37 +0000 Bing Jiao <bingjiao@google.com> wrote:

> Commit d92027a5f30a6c ("mm/vmscan: select the closest preferred node in
> demote_folio_list()") refactored the selection logic for demotion target
> nodes. However, it removed the initial assignment of 'target_nid' while
> leaving a premature check for 'NUMA_NO_NODE' in place.
> 
> Since 'target_nid' is now assigned further down in the function based on
> preferred and allowed node masks, the initial check at line 1046 is
> redundant.
> 
> Remove the redundant check to resolve the compiler warning.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202601091037.vUSHeJCH-lkp@intel.com/
> Fixes: d92027a5f30a6c ("mm/vmscan: select the closest preferred node in demote_folio_list()")

Seems the broken commit is on mm-new, and therefore no need to Cc stable@.  I
think explicitly clarifying that would be nice.  Also, as this fixup may need
to be squashed into the broken commit before it is pulled into the mainline,
sending this kind of fixup as a reply to the patch mail [1] of the commit would
also be nice, and usual in mm.

[1] https://lkml.kernel.org/r/20260108033248.2791579-3-bingjiao@google.com

> Signed-off-by: Bing Jiao <bingjiao@google.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

