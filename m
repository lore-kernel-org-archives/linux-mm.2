Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23D4AF53D8B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B9386B00CC; Mon, 16 Mar 2026 15:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666EE6B00CD; Mon, 16 Mar 2026 15:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593536B00CE; Mon, 16 Mar 2026 15:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4916C6B00CC
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:34:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8204160458
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:34:53 +0000 (UTC)
X-FDA: 84552928866.07.C7AC4B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4E91E140011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:34:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dOTDcPAN;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773689692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVfX4i4b4LXkLYgED59SuvKh2drNOICiAdKp+OJ92+s=;
	b=p83Zuzh9bEILsMfg576WbSbgipU2aSZt656fx5K7s71Xh+QNfPO/WdhMMS0KU2GilzAE6i
	vyV+vyJ6sFdQu3d6v14oGfYj+DO67TJuAWH4TibbAfIJtWpVAsRF1s2lxYuY3jjd1UX7ss
	HdLcRkCsik9ywUGkJYm804PoMkiHzjc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773689692; a=rsa-sha256;
	cv=none;
	b=zK7/+2CMYp9AYG1h4YLkP7nb4qnVhJ9w4HBd7/y7SMET9RtPlvWvKvOmhGXYazuooMzmYd
	cEhtxXaBc8XGd2/hXjiVLSIxgLTVbaR3bWxzN3yAraNt20p+dQRCn3WCMFNSlAEihxb+5Q
	fAeQEGy4dOa3zIO2LlPowKSc19RwK/k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dOTDcPAN;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A355060142;
	Mon, 16 Mar 2026 19:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55360C2BCB0;
	Mon, 16 Mar 2026 19:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773689691;
	bh=ypMADP71DX2Iy1YOt9Ke+EpLL8A4YBFUr74ekNFQ57U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dOTDcPAN27JEc0aoYvLAzmR+L1LIxNUknSz4dQ1rJSa02UmlZG3h8g8cd9j4r51pC
	 YRrUzY3/OA0NehmrglV+le3T7pHax2YBcDVljkFi5zLAcFP7lyRw/UNr/CxbHotPdS
	 R2ScqitwzblTJF4bxXgZ1eJq3+oEOvNf+9/Mob/HJiUPkagnLKyMSz4DpRJRdJHUYq
	 RsSwrEhz6+OtOQXBrxGaAHK/5brpTdYOP93RIdxL9vg5MUD6vhp+K3JP/RTta0TZ1R
	 8V5r2SZ6dRkRH1XmkRnVsc+rCbLCp1YpLQPiHyChBXxgo38oqG/ebKa3bve8U+uf7t
	 2baotgtsoaBVw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/damon/stat: monitor all System RAM resources
Date: Mon, 16 Mar 2026 12:34:49 -0700
Message-ID: <20260316193449.6053-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316102539.2af039f5ca7ce1164da34b47@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4E91E140011
X-Stat-Signature: pk4tqydsbgp6sq6ki5daq74d37k5xks4
X-HE-Tag: 1773689692-754484
X-HE-Meta: U2FsdGVkX19d/BL55qhAI1iyjyvwghgE0CL3JcNGsMZTXWthKdKq6v9YFXeiDTpwKucjt3KeKZmJbHO0qT2/FVxj/pE0xlPjWTuzTRtWTbLPRRIUW7VX/DdohVt2grDR66IJ6XN3vFYeSiolSjJN8pLaQaCaWbzFlWEgOIDq/edIEdpPjaXV7pCx7MGCUlosFFF0R0sJuh7xCHFRiYWL8hayVSCgUnrkWiOFYjG3YC6S8hBkp2+YzJOiMTgSX2ZCkGPkHFW4bqYX+nlbQA7T5ltnqSX7eaSUbdaBmfy5HvP1LDoeK0d1IAP9HPcIuxk6NKWkwyCcb+qDwQBXRqsZVgopfL2TGW1VfRbTBWLhLjgOkthmJOu1n8NCKyDyZXf6yQQNBxiNJzKjpxfVr61TAGi97Ols/4TwOOC8lMboOoHS713uWSJtHKnuVLg734OytAMCXH6cfLgn80SNO1INBnlvNkzRQXmkRcxUIAI9R/CsNtoVM6Mgn7qYmnsOIVCNPnZynoSWrkRZ+aPgh1dDZr7vaogOrgt5gok/74nLgc9qBFm1iZwt7lViDDGT3YKkEMi8lieacFRfLCy3rPJ0xV4f+Z+daJhaybXtVlT8xJyd2EQgmG+4EpmKPsknCUjhwz8L4ZRc+ru/5xMXqiqlwhJCAp+DUeAsRBAbUjjsGaaAMU/D+wo4NZl3K1IX/Ek70B0RiYlJEPwi7vIbKiR3/LuD1SMiWnRbEVOZBS63IqtSi821EkWxeQbRM0dKhEHvwG5FVf590PF122yKxgL1VMWd1AxcFP0pvlBVzzQNV0zJjXax35Bnev84eh5FeuRTGLNwOZYt8wt5W2CAZv7z0e6aVyeh35CDMNruXoximJXkjHdboRr5+B6hi6NjthTvUjP/LTVxrQdrdmEyIaPS71dLqzQMgmTa9jQDHuyYVIyAreWLwbDYTRHJ0MdKMjoIZ3bCegC3BFLwhI2d6Wv
 KZT2Skjv
 Tyyb9D647IpRUuBBZbq1v3gJcuIrbQ0UmaOw24LZ83e8xIr2TkkZ8IO8fJukqLEc0CbYelaYzmUJcGe9aUXnxrmBc/HysBe5LFdRKfG7qrZdRRaaBquL4Kp4zdXb68CTqn6+u1MyyU3lVTC/tUIIxnqqpNvt1V5M0NVPJvW9KieXN+u4vu3R8op1zuuDBNqo5DAkNng4hHUrNs0LschkGfeKxpmJViRABxL0cm54/KkiD2tMgA7w+hfj0mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 10:25:39 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 15 Mar 2026 09:27:15 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > DAMON_STAT usage document (Documentation/admin-guide/mm/damon/stat.rst)
> > says it monitors the system's entire physical memory.  But, it is
> > monitoring only the biggest System RAM resource of the system.  When
> > there are multiple System RAM resources, this results in monitoring only
> > an unexpectedly small fraction of the physical memory.  For example,
> > suppose the system has a 500 GiB System RAM, 10 MiB non-System RAM, and
> > 500 GiB System RAM resources in order on the physical address space.
> > DAMON_STAT will monitor only the first 500 GiB System RAM.  This
> > situation is particularly common on NUMA systems.
> > 
> > Select a physical address range that covers all System RAM areas of the
> > system, to fix this issue and make it work as documented.
> > 
> > Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
> > Cc: <stable@vger.kernel.org> # 6.17.x
> 
> This doesn't apply to current mainline?

Ah, you're right.  Sorry for this noise.

I will rebase it to mm-hotfixes-unstable and post it as v3, by tonight.  If you
prefer mainline or another tree other than mm-hotfixes-unsable as the baseline
of v3, please let me know.


Thanks,
SJ

