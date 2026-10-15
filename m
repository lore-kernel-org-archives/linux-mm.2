Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4109CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C12286B008C; Thu, 15 Oct 2026 10:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1726B0092; Thu, 15 Oct 2026 10:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE116B0095; Thu, 15 Oct 2026 10:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97D736B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:39:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 35441A74B8
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:39:53 +0000 (UTC)
X-FDA: 85325119866.27.5A357B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 35FD840002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:39:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ehxEHhNM;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792075191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmiUyqmsfSRg6ClwR6Q6JMr/UJ3nE7Qv5AHeR45H+eU=;
	b=S+8osq+UgcTyL/nJhvGNoDL+TnjDXOO4nGWlZ2TyoXnqBKyA8C8BwTMvYFg5cIfpPtdchu
	O+wIrnNFVBfOKKonNMHCc3eIoov93rbhx6++prO7x85Ga4JPC4fDdQpHFZYhDM1eh6QNda
	16OhttGTP5kDCHMODcsna3qT81m1UGg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792075191;
	b=tyOkKGAvMSpFqFRvw4hBHK7Muwcnb4Sp/lYQx2qgCAyDtYARts/EDkVT74iDNH4EtrG6/M
	YpHrYnnvMkxmWjxDTX8aQwXHgZuLaxSbBiHV26vmp0l85wiwgkP0O9PswXX+d6WmYlNYNQ
	qAHbI57aZYjpUckSrKwE/wGUxo2ILqE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ehxEHhNM;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78B4943B84;
	Thu, 15 Oct 2026 14:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81CE1F000C4;
	Thu, 15 Oct 2026 14:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075190;
	bh=mmiUyqmsfSRg6ClwR6Q6JMr/UJ3nE7Qv5AHeR45H+eU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ehxEHhNMPvEzprsuKPf0KyV72AqmkoT0cFkugddWqDR1jW16KcjT4sO/ySSxEfGWT
	 DIlBxD4Y3HvPqj7a4dnfqU+9/yusDtBRALtYlZ6ZcU+KYo9SE6SCsXrezt0eLqlFmL
	 zHSGOIl3ezj7Y7sJzdbmtAKWHo0ylKdS2ihWXtbD12TecBWekas7wDvGVsybx3q7hF
	 CDEK611Eh9ePcP90Uo37gH6RHHEd2RsIfFuEJOrqJhMXTcKw7ljsXYYVR7VuV2983j
	 gvSQOJ0Ujn2HLOmoXOdlbU5rgRmZZmg3JNA5Oaq4h9Ly6f3xUUsg+CXrpr/vlP2q+O
	 ZD+UwhvY4/X9Q==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id E8C531980047;
	Thu, 15 Oct 2026 10:39:45 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 15 Oct 2026 10:39:48 -0400
X-ME-Sender: <xms:seXQatj6yK-vAkGfz3nmtzKfQEFz5k8BX2NImvxWqUbYpsHkFTQ01g>
    <xme:seXQakYEg9wygmgO8qd9seG4qnI9uV1FznHgR73T2LqaINe9lH9e9JGyjRIcvPgjN
    5-UyZOH9z1AE_w28SJ8XhztMPG7VFPG3N8OvnMXYuxZwrCPNLPl8Wtm>
X-ME-Received: <xmr:seXQamW3ujf5cRPatCqmaVHg7mAYJNu8yUpSsSsDY4CYvzzTGX5vBv0WB3A>
X-ME-Proxy-Cause: dmFkZTErd8TIAjJGupJmPa7o/yBWPPRT5ZQiaOhRc5EH22t7peU7D1eeODEsp8i629tNhO
    r4mHy21KV0D6RvfIOkH3orkwlPlVaAN6jAj64nPwE5LJH03cLu0deasjjvmPESP5FrRnyw
    jePRXgR+deIN9SCGY3LKnpTMhEl80DUyZsvo/zt9GQ4FZXq0CZ278f5cLt9/f6ZRqhOO0z
    MW3niMw169KWxeTjSDwTUJBvQbp6c2o9+777eazijSZpKAhWCsSh1+j1yQFNgkZxgW+JEC
    QKT4R1QjCQZxBw+xy0ZP+qQNv2hi8RFl5iAbv4eFLhMdaBxtKPy3D7BBsuG5AGTzp6ocfO
    gW9/rTewo5ZjF/I7btK8pdenXh4Pai1Tp+eppPQBJmhh3h7qPtwjCu46ta7YXgDVbSS8Vl
    Xy1vFOQa3hVQkaD8aDr9nO2Ru8V8jtY1ADsw+jwmfKujikDA1gymEpH8JSR9zF2Tk6Mq+y
    0GHFZ7J9Fy+MbjhVfRFODtQDDx8VwCvZoWDuk7YUY4YDiZbLhZeOkPECpmVW0meovVfYBn
    LxrVGtlOuAgpbe2FWut7pkilEntTgIphkhOEz28RSG8XGZXjvH721/OJrwz1gxUriBmlpx
    kglVxqDks+d8Lgi2rTjnr2fXqEkKG0pk69Anuc0vT+mD8dIqRl+/rUEDT3HQ
X-ME-Proxy: <xmx:seXQalZ_Ia4dtdBh7Y0MNSkyV_tmDrSX11oLZzx7oE4qV226opti-w>
    <xmx:seXQatKEZXVI8WusdGaszIdpzIltlRXDnHaqnVKMgn-ZBWuxeYomNQ>
    <xmx:seXQag1p6-xpzk_G1Uh6kjlQ1B1pIFbQs_lyg4K2NR9OivETPJTidQ>
    <xmx:seXQarj-N8TiYs_mhj8M4epjZVN4_2UGXOyOyXn9eH-y7_7aVVs8UA>
    <xmx:seXQavwGIxfp-zTAD4JRC20qfXYX_ZVHXgCfdyXS2sTR8wDiK9Y_eUPY>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Oct 2026 10:39:44 -0400 (EDT)
Date: Thu, 15 Oct 2026 15:39:43 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <atDlYr_RM4WRlMqG@thinkstation>
References: <20261009125503.126202-1-kas@kernel.org>
 <15a9e03e-c748-4e51-b8cc-583a3610c897@kernel.org>
 <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
 <as5q14OsbK2CmOrh@thinkstation>
 <20261014202936.GC371161@cmpxchg.org>
 <78238103-3a7f-432c-b1df-bd14d7cf4bb1@kernel.org>
 <atDMN5MoGrwJNpAj@thinkstation>
 <a809956b-9775-4667-be60-f635b9a72ee6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a809956b-9775-4667-be60-f635b9a72ee6@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 35FD840002
X-Rspam-User: 
X-Stat-Signature: 6ofqpf6n93wnc83k15jgs8t4kh3oq13p
X-HE-Tag: 1792075191-421266
X-HE-Meta: U2FsdGVkX19BKNeG5OAjOkofL6KOraLZAJ+3bs7KjI+giGQwCNz39txqVPY5cPDoM1eFXxXgeQVZi3loz/DXVx3Xc96edUoQsLCN2y/CyOHoHMNBE3seCs+NzXU+1WviXlMbeEEDbRVa8P96Km3hVcV237awpRHRT6GphJG2MxBewZz5c0Csj7AcO4OIWfu3VXEO0U/tjls4bjc5GnApAIxhR6IBx/t82Ru3cCzGycH+WmWjtxTLzxOymDH2wL9Snv25hbgILRcH0ZJ/6Bx0OVLFjd1hPOBFXlkY8asLz3x3KDstFe8pgHhKvcRXwo0p9gCjjS1oca71Dgn90lld7d9xyarnSN6OiNl/QnM78T2/dWeZSFQmj8VU+xoKpaJribylqz7bvmxwZ9SrTq4ldrsvhzTLjJMxw7gvwRR5jFzjzMkDhXQQRzwatzJ4PZR9XvkwkZzCGxMl66QDYGwt8anx37gRA0zvaE8BbV0Ou/rORm4lM3l1viLoUZyZXNjC4p98kxhe3e7G53mLiPO/JT2rrnT6t6LGBAtUEsfWGm3qW6d8imIy1ncezoN5UcTcknauuG0lxUnBxp54YFd3fMgbgZxALcW2Iv9RtgKGihRFFuYjPEa3y7YlD1wMnDro2awNx9ZMz9XFRTikcfOPTr+JLnXgIemY96V+Q6BNx0FFiow991ghUBl28WGHVfb4JmPGsNPax3ID4rp/PxQo9VM25XRYxu0DKHKm1lAIaAuMr4Nrxsn3FV8xcj3806APcA9TQoyYcc/nNQx/VRQY22Sw/jP9pTkUkw6QPNqkDzI8GxScZ8ZhWhFDDlxdexHqdWE0izSnhXExWhUnnE49aYjKBDaqicLs9lz2g+YSeesEsUr91oqubp7aCr6i2Ik6jvREZ8gAcC6xO5NnRFC/fPZhLj76niEYIzwFYxJdTIQ2k1EQ7NlYSymYTJ8UjvKDGG8aL6jPbrKQqwszroH
 tDIDW9iF
 8LHCSzXQ2DmK87cUNhw/N1x68h5ZD3d4oXjrKA7oLdVD91xQ5qvYBsymgNNRbiVHFmdbvTov9VKj31+AUTGs1ALNr5EI52mg5F5sqbIkAbfb1EKDtGMyEUPCakXSZY0uqqs2j9fs5Dwv6UDSvOTQ2b5304vSkSGar6AaSdDwBWvOZTWEcmdoEZc6LwC/Nm4Fy7nhK6nRseFycZiF2jqU1FohjPVmhrteZP5dZm25JdP9vn2KZ6eGaMybcn/lsCDrAuJ7WL8cwQ9Ec3q4OyIbekmZ9/Oh7xBD/foOXOVF3BJMKTdwhIvhg7mDtCZWWga5XOMz4Rcwqj7QnjFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 03:53:30PM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/15/26 14:55, Kiryl Shutsemau wrote:
> > On Thu, Oct 15, 2026 at 09:16:36AM +0200, Vlastimil Babka (SUSE) wrote:
> >> > And agree 7.4-rc1 with CC stable is fine. Sadly, not sure if anyone
> >> > but Meta is using the feature right now.
> >> 
> >> I thought it was there for a long time but it was only added in 2025 :) At
> >> least the enterprise world is slow to adopt things, AFAICS.
> > 
> > I was thinking to propose a patch after merge window to make defrag_mode
> > default. Do you think it is too early? I don't think it is ever going
> > to be truly stabilized without wider exposure.
> 
> We can try it, but preferably with arguments (and best, numbers).

Will do.

> > We also discussed with Johannes to make a stricter (defrag_mode=2?) mode
> > that will not give up on fragmentation ever, but OOM instead.
> 
> Would you use that mode at Meta? That however most likely wouldn't be
> general purpose enough to become default.

Yes, we consider it to be preferable to fragmentation. But it requires
experimentation.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

