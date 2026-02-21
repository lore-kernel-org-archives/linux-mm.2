Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C45C61DE3
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 18:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3354F6B0088; Sat, 21 Feb 2026 13:08:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3C36B0096; Sat, 21 Feb 2026 13:08:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EF186B0098; Sat, 21 Feb 2026 13:08:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 08DB06B0088
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 13:08:06 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68FBE8BAD1
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 18:08:05 +0000 (UTC)
X-FDA: 84469247730.10.0477833
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B8F05100004
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 18:08:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DdZcYRDF;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771697283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPzQx21V/we35w66JCHEVqoFg7dX4MoY+Ku4InKpaBU=;
	b=BQtQrrHlNyFFjUUynP0OoSVlNdSKjf2amR7CwE2QVb9NjyBw2UgR03usC/KMuewUVBxjqh
	I8Q6imp4dwxPJyikEiLjA7pZoPBfHyGa7TvLITez8GpByFcTAd+W9LOJJjXF4wyyc25L9T
	2nxeeckLqvzpaCILdCkoOreWTDF1OkQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771697283; a=rsa-sha256;
	cv=none;
	b=JVBIHisyZQgIRhpgB09ozJWgrEFqkOwsgx2tMDDDhBlQzTrL2cJ4AVyFVG2sqSiLVIyl+/
	iP/5/MkK9PhobDPF3XOAMSIbFEGzOV18BpOpqDTGdnZZ58Nt8bBKMEsKKnsxWRJQ9x07Ib
	LgzfGYV/zFzaP2O8NJ4ccY20U9BfK1M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DdZcYRDF;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B720E43D3D;
	Sat, 21 Feb 2026 18:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EAEC4CEF7;
	Sat, 21 Feb 2026 18:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771697282;
	bh=BPzQx21V/we35w66JCHEVqoFg7dX4MoY+Ku4InKpaBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdZcYRDFdDDod4Ylxzd6FUP3KNcZ3/n8AypcPv1RyjZ+W4wfw/KfVd84c/VtTvAau
	 tUCEDNnzKueD+mOzVIJl/E7JxGAiyu0UJFHY0TwKsEbl1nEHYPDvLkAAfh5hY3/T2d
	 yINBPVtZceE7vfBeC8GVRA84vKh5uDzNoDjym5BS88navj4YHY/HyI/9hBD3e4BYhW
	 pJkT5czeZfNdWg271WExdWGmy05pwyU3mmR+QJyDmQ9CuekLJUgYWiq/8WSglI5yV4
	 s3greZkZ/hRatkmAskwhW+0vQZRtmgeWf4RdsusLlizFUBWT69yh5DpJMZbhXiS0rO
	 TKxEWT6W7jwRg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 1/3] mm/damon/core: split regions for min_nr_regions at beginning
Date: Sat, 21 Feb 2026 10:07:54 -0800
Message-ID: <20260221180755.10505-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260220151301.58159-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: 3nmcfgq48fj1z7bnxgwfutk9djm333dn
X-Rspamd-Queue-Id: B8F05100004
X-Rspam-User: 
X-HE-Tag: 1771697283-544544
X-HE-Meta: U2FsdGVkX18oMwLS00FN6+ApDi1fIQKDBVc8MM30oG53AC1kgdHIQk41S1AA/DC72mkV+xAq6TKx2pEe/7fvhpEuz6vE7JKoo6fGRi8UA/4/f8XNUdyBHLO3SvZ95h9VDNn01XeuLCg9R0f4XsHKgLcM6FMrv+q6I4pjR65nQvVK+eZQ28AFLzjYwM3WTaPxd2a5QcXH/zVXyxw+JBRaz043I0eUBRP+NlTgMjc7zfFp57Q5zm6Lc8XyjdU9Iflbp7bwWaLz1xINKsOIR12lKSfhgfg/tHkDKYbtHCj781vEvzsVd7UHDpBnKkC9hYVo9lkge3nNXQT3u9T2jKZhpaYzy2HkhBs1DKu56dMlvaecrKQZz1U5K4FOKIrZrMYSBzeWWoHW8H2QUi1hop6mMGHjGHHbMNn3IPsAEHaFe2T8Nvd/SC7tdO5ZuUz2A8HrGuyYn/qy6GugeZbakOhbRdJijCUQIdCt+VIINtkdYH08i6aKbP7pzIp2MLgJABEPOOsQdWdcdVcl1RAgurvhK4rq1qYf8/PlFDmsk2IbnerWjTgI0pR1AeLn5e/XvYcTDH8MMaI/hjRdu6M6QffVMbfcxkB8aY1lEDmxB8gOrFnhdKJ5cHUvgCkiLYtuvQhtAR1dgIHOQTYatib5qPv/uSMIq44dXzSLO05+JlC7eO2su3gQ7hoCv9Wz6xKkCeITFRjbO5/Ks0SUERPvTu9dHU6teAQc/qZ9M9BOc/2seK0vH5ZEvTjtEJBgAlVavAFWYAvUU42rB8ED4+cFk+cmZriYQV88UzI00Dkhoxlxv8OXTWq1AIrt2rwrhbnXuOSii+fFFWA+UimahYo5DXq8i4nbHO4JOm+uAnBXGQdPBLuK1Z1/IsBMcRdb3+HMZ+H+eDvAJNebpeqmyCxDC6qnLWFmQMbteRpgBebv9ez/bCqHBu+ncSyHMWEyRs+ZtJBqThIGJyfsxTTrmvIF3sf
 l7hQ/TYB
 1oWv4+qJUYVoT4nrXc4DrrCzBgWAaOkP6fm0btHIYdL4gJFDb9MBSQaggYiuZWSTISJe+4VmS6u79leydIzfLBpX/lKijgqWP+85kr7C8GgXAwugcBRLtymO13+uPuNvCcxirBpXuliPOk7BXvjxZRVA/oZFBPVY+Yv1xbYvWWThWqCUGhC3Gt7tQF55RzLIYGejTLU/yIZXua2+e6HI3xORgZt5mn7lwNx6Gf2BrGXUi/aMDkGRbcddhX8OZcpFRmv7MwpaMmqDMzZtmbQxZGM+UQM1rz3IU5nC2xeARWHoV5HVC+Y3QxyhuIVHG8a+GbDzEz3dknz4KC0CjE1mgIJ7K0NpRFAMYQhM7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Feb 2026 07:13:01 -0800 SeongJae Park <sj@kernel.org> wrote:

[...]
> If nobodys finds some problems on this, I will post RFC v2 of this after
> squashing the above diff into this patch, probably within this weekend.

The RFC v2 is posted:
https://lore.kernel.org/20260221180341.10313-1-sj@kernel.org


Thanks,
SJ

[...]

