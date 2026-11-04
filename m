Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3891606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V/vrYRp0
Received: by kanga.kvack.org (Postfix)
	id CDA166B05B7; Wed,  4 Nov 2026 05:02:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB70E6B05B9; Wed,  4 Nov 2026 05:02:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC79C6B05BF; Wed,  4 Nov 2026 05:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A16AA6B05B7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:02:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9C47160672
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:02:45 +0000 (UTC)
X-FDA: 85396997490.01.B61432A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 15BD1180006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:02:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V/vrYRp0";
	spf=pass (imf16.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793786564;
	b=eLKlFrsuzWM3Vn/yUdLcXyJkogic2U55q/B7MRJJqzarmfWvuJ5YXhXzHbIz5hfuIjOT5k
	vhD30Ar8BaK8WTskNfr2d5C+9V3/QMlT/qSUoeKLfhdDbfVBZGrPs+7Y+i1hOOAQhvvkaH
	vcB2OOdsqeiZwW671IRBtDc0B/UOCWg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V/vrYRp0";
	spf=pass (imf16.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793786564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gsMsIdsVful1BlmTIAizWyUZ84e/BlfvPlGTZJwyYZo=;
	b=QS+CS146saQ37pR/FMXhnIp8fQLenahuyZuAznos7xqngW69ajELQiu2wXzpGwAu0/RU07
	HfbDqw3nXufFPnTHi2mrAvczN+ykcSak8Lw4rN1fMeqg1L74pnNHUPnRPPMEyy2idgI2Uk
	PQM6pp7QdQHtksoubTGTzC2YApDS1OU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81DB64341D;
	Wed,  4 Nov 2026 10:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5A51F000C1;
	Wed,  4 Nov 2026 10:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793786562;
	bh=gsMsIdsVful1BlmTIAizWyUZ84e/BlfvPlGTZJwyYZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V/vrYRp0MYR3H+LKzmfFDqD/fLBwB3C5OIC2C/3QFYR4pkt151g8I4L2ubXnpDYzS
	 jqlDUYgty+BebpKbd4uwaqVdMtN9XeNXHlSCxyXz25/V7fXSiLINzTr1SJMFIq/m+2
	 n4ih3ckd26s9najTUSTzlx/TnyU32tGdT4NYbCCjQQuiXY6t41uv8EhdpjhfhJkajE
	 mnagPWy5P9KhWGo+9MlY5XxlImzi7tzMZZAywGnl2f1y5W0pYnUVHQjcvOi97Fz4xf
	 Ni6oMAQEiM+IW+mxOHWIjJyPkeS4IEFZiD8RWGIpuc53LL9E2NHKt7zOkpH8JNLwUq
	 MyqqO6i2sNlLw==
Date: Wed, 4 Nov 2026 11:02:37 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/12] mm: hugetlb_vmemmap: unify writable vmemmap
 page preparation
Message-ID: <ausCvbbDFKFC4oIi@localhost.localdomain>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-6-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104023510.260766-6-songmuchun@bytedance.com>
X-Stat-Signature: 5jy6qhsfrssyas49nx3wsjt1u94jycq8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 15BD1180006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793786563-583229
X-HE-Meta: U2FsdGVkX19570EEhNey+0zHlYbEu4FEbldWucPrl2P2RvbrKf/NPh9jv9ME/OEfGFfNv5/v/NkWHDezqY1dAXnzgyXPtpsPty0Ihtr+0kNEHtZK/eflFixtWVxeFwRRXYCc8L6IAwX1PJ3Bu+zM0F3mG8gp8onpUdICjAQjMPL3B5G5uai4Nu3Co40y17kb0j4LNOCGmitMR1Y/xdpa6hRxDo1/UKqW9RBxJ2gPjT78Fk/zN1n+pkZKNOHKF5kk1e3TO7OOVtXNyGszDkNT6TN5Kt/JA/OM1qnMDUy2p3uzN9MX8akZOermoIpbvvPtQADz7K2YtowdG/tk7WupkbLisAjIm0SeMC5LMrBJRbQvwBo7sE/fJZ2ZzcSPHoK6pGtlkoCUFTeiSygOJR72cDvxt6TTs7cBD2CAIh2u2BKX5N2JGPZRXCJCBMHI1XRmpCJoDQVK3LasrFIZM11eCSX5RtzEBFB52eL9l4w1GTFa4Uq/TmbXWeMi2AxGs2MpzjQOqXRA8Rfkekz52cWx38ACfHitZ5lH+2Iz/hjLsW9YvHKzOzx/orzvRq6pjLaUiFWeEX32fDg3LltfeZqkRX/fi/7r6bEfV8XZMmMtM1syBsKXMYMwcDCTearP5tiiaO8gVBVTbYxEyjRqboFdvFAdTfYeswBcc2Ew0TiHOFUVdb3wJo9SCbUdyr1ZbgSaPa6jzF1j4AlaL+/NPo/w8O2zykG/AxApryy46iqUWStSz56IqCGgC+0Gdb5IiRvM7W0c1c8x06hVal77+XjzGp03PvFEGQQP9cbvJETIZtDE4Pe+AglbSKBAlREdOosCh+ZxMMtmrsF47dWezhOUbj4IijvZYNH/H4e4JFTu4P42c9bkZSCb3dJa8960hrLukZULV1Y7YGU1Pi0fq652rWx0r4CgOl0miQGF8pO21TuyBXEEZDpjNkor61EuR/NmdGHyeXEATFpc/fyOznJ
 ZcOpA51t
 YwHrExvHwwY2mgdLrBzex9Yksk8/2J1uar6b1/7oCGk0Vk3EtwAKYqi39f2APu2nmyrsDJAK6u9NArVbxx3uGVqycK6QitU5LLr/OGWQUjYXutNTmb3rOF+cUvpgL64Buno146pW7fd5Bev5x5Gwy+QSG1wFCV9SToQOGBt2tvATL56p22SE09WcacIJt7Xr+XrtTxj9yYthz5nuuuZVys5NqKNZ8EVe8WQK7t2ePLPme5VR5f21KSv8q1HMTdEaIS9ZXrC2PeW7+P8MUIuPtQEn6nmz/iBQhrrAELLtW7rwoJcU/uUv31/fvQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:35:03AM +0800, Muchun Song wrote:
> Installing a writable vmemmap page requires consuming a replacement page,
> copying the current contents into it and making the copy visible before
> publishing the new mapping.  HVO currently splits this sequence between
> the page-table walker and its caller depending on the remap path.
> 
> Centralize the sequence in the walker so all writable replacements follow
> the same copy-and-publish protocol.  This keeps page preparation with the
> mapping update and removes path-specific handling from higher-level HVO
> code.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

