Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5E0FFF885A
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 01:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451B96B008C; Tue, 28 Apr 2026 21:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429766B0092; Tue, 28 Apr 2026 21:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366786B0093; Tue, 28 Apr 2026 21:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 22B1C6B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 21:39:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE2B6120516
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:39:12 +0000 (UTC)
X-FDA: 84709885344.01.111C811
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0F67640005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:39:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rf1nhXdY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777426751; a=rsa-sha256;
	cv=none;
	b=ti4BQn7gPul5NtvKgTjpCYf82X15fadytkdsJEF9JCa1uIgB16un/S0gWiF9q6OMFztOAZ
	orPYavH1mV9Xm+1RN34TB+Y0DFo62DPpPVeCkAac5yFb58kOlGp7JXyNsWOfYPR4bdoSQo
	8wyBcvHN/Ev6fP9ARHL7SHI3UFIuk+w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rf1nhXdY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777426751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9BoEF5GA5qi/kF0ERLQDSATIAV5brLnhfed7LwEqZRA=;
	b=hMlAYX27wkPlxY0ZhiSQz4afNix7nez9SDEllpdhERzfCZNepUkueAg00ARIdZ/58DkIIa
	1E3fV260qPqMjqdk3DOwPkJFcGVSfTAvKmnT44PnaJURkN38kXB0CE/sxcoVIcpp4c4boq
	IZVdxbga6JnHCgiAqXbASlnzW5HoEqk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 68C5860180;
	Wed, 29 Apr 2026 01:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF71C2BCC4;
	Wed, 29 Apr 2026 01:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777426750;
	bh=NuKdDMXxMHFfADUrXSz37+tncEQGzkzv+UR6zBbTJQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rf1nhXdYaZuPNSDKEjrXwSowqcANaZsvJDB4tbwF20WzWrEDsJaewE+jJp7uzGObs
	 t/sSX9iRxGSYdjF5Oeoi1IhPsoAjK0Qn8swXcJXLAt/89Wx7On7VNq3T8+doULmLPn
	 0OnGVmbdKvs3oSvrROP9bFT+hlGbcQhgjYkHK9WgNDXSWe2PI7nbuRllHXeqwhrLKT
	 h9Hq8S+pU5BTXzEtIGftQuKjL1AbG2j4bJP25gvvDNphft0c9UjVC+fk7o/XT4D0GO
	 bT3AClZL13UsNc6yHPWBHPegnWW4yhwRHeMHqGjR3RRsyVIzEyTvSMSeUsUUtvmGbg
	 UJ6CLy9HgqFuQ==
From: SeongJae Park <sj@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>,
	"zhen.ni" <zhen.ni@easystack.cn>,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/page_owner: add filter infrastructure
Date: Tue, 28 Apr 2026 18:39:01 -0700
Message-ID: <20260429013902.89104-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <F8F8A2DA-CC65-491B-B69A-2716186D0495@nvidia.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r5grabza4zk61pubd936kjwkomg5o7tb
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F67640005
X-Rspamd-Server: rspam07
X-HE-Tag: 1777426750-358316
X-HE-Meta: U2FsdGVkX1/wIvTr+qDnuy6aX6y8m+PF+ysfc+5RwvSmVfYn3uY2zcQr5Zd9TjarwcJNd79vScj5N8fa7hxb2DJzjy9ZAhHUffnTx+niCojPQKhSmZDs2ZAOdpwxROKQrkAXWwo4EXgG/ep2sJMe4YYUkEdR1A/jlOdhV2Ekxxil6GcrvjuDPwuyozPlpTig9gvq2j0HEgLLp+KJZvsnYNIOpM3o9p/YQvDdT5Gxl1WK6dYeH5pZE14HZCIqVLucdMkr5bokWeDreLIwgTWCJIva5ZuomjHplC1m/IHpyUXASJ40rKsMR4WnU4MFY0HVAelFp6afRMRXU1SwVaSILZ3EuQIsB2tCzlRNLgoxMN7fcDTAmNrhSnCmlP0cb7j7ypYCN7pes/xD1r+GlbRcWfbyCgGUx93tmzFDRjFTk1d3aKEK5uKcBwaDFzasbPKqEDGVtGDqFk6Lg0qfNZE7s4kbQg0rnV6pmpKnJ1OYXBqIC+4FT8/+6gX5lvCbwsmcaoK3BQCwUtIHCJsHlkKBf0gkhs3odsmdMfpB05eWQYvRBGlw2kodVsVMIuyfmWCfs/LNXq8FtT0osLS8BBl58hpiDfpivyjJwBePg3OidVVnNQ2ZJQP5UzCGSoYU8zN5J2PL8BpSwtHmbLhKM4WrPsiedmkUUWfzt/WVYE7sDJclb3o5WV+Uyo5Uf66gq9CbtDMlNyZ3EgnszsevzFgRst6Ti60pkIJe8aA33ZBgiSDKX/4K2Gw99F1qKpeto8DLEStScZzNkejvuhnhq6NSy5d/l4JT6yC3NaCvHYDqyKP4tb1/Hr/WMfws4EuvyMVT9Aww79SNNsdxr5fCsqLuWEW0dhegaD/HMVeM1Df2UifxRJhM7Yt0UrLuqzT8Jul7j+igNjC9ZvK/XijClLVQtxYDZDJkGD54M5zIGWeZNMHYwjLDv+Tvg+r8pf3Uuse0YLTH1fz2PQFVTvux18Q
 Gl8Dkk5H
 wvkmscKgOWdGcE1b9mHX1KXg8Svj84UmT2VJu/Rx6Vc4Or7pv65HZEeBADTGvtJdHzbCBrWkWDg+V5afJtSoqKBhFCkQEjZuoSFuksBHjoYMWsN4X3eRTImTCGdpKrIlz5X5jEncLm7yt6c1UR07YgwX+ijRuaj4dxSygV3MgRaTpBJnBENBaxryTSnb80tTZmAaHZAbgINFdnDAfKQtNTs/38BqszHKB3iecUgBW96w/8vcQ7LV1ZO6zi8pJ7734Dw2VrZ28Em0o9Qm4h0jzzRgmS3VrWd43h/wgEdG8eIwvjum4xq4JGwhWIk8iMKWYZPhWqzFfd/xQth2CUUctx4/gPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 09:13:03 -0400 Zi Yan <ziy@nvidia.com> wrote:

> On 27 Apr 2026, at 23:33, zhen.ni wrote:
> 
> > 在 2026/4/27 23:35, Zi Yan 写道:
> >> On 19 Apr 2026, at 11:55, Zhen Ni wrote:
> >>
> >>> Add data structure for page_owner filtering functionality and create
> >>> debugfs directory for filter controls.
> >>>
> >>> This adds:
> >>> - enum page_owner_print_mode with values for full_stack and stack_handle
> >>> - struct page_owner_filter with print_mode and nid_mask fields
> >>> - Static owner_filter instance initialized with default values
> >>> - page_owner_filter debugfs directory
> >>>
> >>> The filter infrastructure will be used to add print_mode and NUMA node
> >>> filtering capabilities in subsequent commits.
> >>>
> >>> Link: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni@easystack.cn/
> >>> Suggested-by: Zi Yan <ziy@nvidia.com>
> >>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> >>> ---
> >>>
> >>> Changes in v2:
> >>> - Use enum page_owner_print_mode instead of bool 'compact' for better clarity
> >>> - Use nodemask_t instead of int 'nid' to support multi-node filtering
> >>> ---
> >>>   mm/page_owner.c | 20 +++++++++++++++++++-
> >>>   1 file changed, 19 insertions(+), 1 deletion(-)
> >>
> >> The patch can be folded into Patch 2. Otherwise, these new types are not
> >> used and page_owner_filter folder is just empty.
> >>
> >
> >
> > Thanks for your review and suggestion.
> >
> > I kept the 3-patch structure mainly for clear functional separation,
> > which also makes review easier. Patch 1 adds the infrastructure,
> 
> What is the point of adding unused code in a separate patch?
> Patch 1 has no functional addition and should be part of Patch 2.

I agree.

While I was reviewing the v3 of this series, I had to move between the patch 2
and patch 1 to check the value of the print_mode enum.  Having those on single
patch will be easier to read for people like me.


Thanks,
SJ

[...]

