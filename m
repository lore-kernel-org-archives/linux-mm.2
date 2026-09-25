Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FAA7C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 16:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4A96B0088; Fri, 25 Sep 2026 12:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E096B008A; Fri, 25 Sep 2026 12:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1160F6B008C; Fri, 25 Sep 2026 12:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC8556B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:31:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4EB90C055D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:31:00 +0000 (UTC)
X-FDA: 85252823880.04.F8FFBFD
Received: from dog.elm.relay.mailchannels.net (dog.elm.relay.mailchannels.net [23.83.212.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id CF38E120016
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:30:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=N8pcz9sB;
	spf=softfail (imf29.hostedemail.com: 23.83.212.48 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790353858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKeAs2zV3r/lq+fhQtjl3K+UFdMpT18rtwW4BFj6Syc=;
	b=1YmUg4x/i1AofjuSFRmxGMXRRpjJSLLKPEyHNlxK35hZx8w+7a1Bvi2ATfeE1DernauTuP
	hBPnDVP5WDwZO0C9zMDZQHfFpRMxOBsDR3G+7yX//RF8uImw5f6LuXfM7wXy4olkV0CFEE
	RYzPzsa53w32U7ZLpKd6b+G2WbiF2x0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790353858;
	b=uXBVAbbgTcZ/9B8YPwLDXwwhf3Wu9hX9UfEUGVfTw8wet1co1DvT1GocrpR/KViTRPTJDs
	9HBgznDi3E4MpIiwhCSQNXdu2yzzPSHYSLWErgs2EYJ0+XmQUHezi7mzA/tL8cUWrZJdFZ
	aX6eNSThg6JYHY1UqmFyEpCyPYAxl9Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=N8pcz9sB;
	spf=softfail (imf29.hostedemail.com: 23.83.212.48 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 7FF474614AE;
	Fri, 25 Sep 2026 16:30:56 +0000 (UTC)
Received: from pdx1-sub0-mail-a203.dreamhost.com (trex-green-2.trex.outbound.svc.cluster.local [100.96.17.233])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 14F84463C29;
	Fri, 25 Sep 2026 16:30:56 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Bored-Vacuous: 259512dc6e1f7a89_1790353856352_2394590540
X-MC-Loop-Signature: 1790353856351:934502152
X-MC-Ingress-Time: 1790353856351
Received: from pdx1-sub0-mail-a203.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.17.233 (trex/8.0.2);
	Fri, 25 Sep 2026 16:30:56 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a203.dreamhost.com (Postfix) with ESMTPSA id 4hrx5p3ynfzRx;
	Fri, 25 Sep 2026 09:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1790353855;
	bh=yKeAs2zV3r/lq+fhQtjl3K+UFdMpT18rtwW4BFj6Syc=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=N8pcz9sBaMDUFey2o3wPXCO2GNjaxU1g4fV1LDSYsVlYlejOhTE7y2S5X1K/x2Jk3
	 QLsCKYgf3V9QMwe/ghjlrbAGGlXexwJd4/ADgRFCoWklxv+KWIYmPaTkQBFZVPvf+t
	 tpU4E4FaaKmlbkuXvJF/qaQW2bxlqOnINXTrRu9Nm/eOnVRrbKrG54bYTONrUEKgTA
	 YKgDYrQPYnWPRdcNsxg2iKQA+1D/Hem818eHc0NLCpTKrh44Vf9buGE1oA5vpodQ8o
	 ajcQVZNbRk5dGt7U6SwR/an/s+fbeN3egGdjv1znTuzCjxWV44vYE/gAJv3Xxwk+72
	 6ZRpmMJcZYtNw==
Date: Fri, 25 Sep 2026 09:30:51 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: SJ Park <sj@kernel.org>
Cc: Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, jic23@kernel.org, dave.hansen@intel.com,
	gourry@gourry.net, mgorman@techsingularity.net, mingo@redhat.com,
	peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com,
	rientjes@google.com, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, nifan.cxl@gmail.com,
	xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com,
	donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Message-ID: <20260925163051.vuh5y33xemwqgohc@offworld>
Mail-Followup-To: SJ Park <sj@kernel.org>, Bharata B Rao <bharata@amd.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, jic23@kernel.org,
	dave.hansen@intel.com, gourry@gourry.net,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, nifan.cxl@gmail.com,
	xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com,
	donettom@linux.ibm.com
References: <20260925021226.52kpnmvfylw73dz4@offworld>
 <20260925095039.48831-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260925095039.48831-1-sj@kernel.org>
User-Agent: NeoMutt/20220429
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CF38E120016
X-Stat-Signature: nyaxaj6wxsdz6qnnt44t8ja8cuojtnsm
X-Rspam-User: 
X-HE-Tag: 1790353857-335105
X-HE-Meta: U2FsdGVkX19iAFr0TVHB5EM/i2p4Q7JL2DE2ym+Mx8f1SuzFQtAekVT1eUJVLa1JDVDGywyI8DnvhX2ek1zmI8oVyTL+xv72NnavtsFoXTjJxc/LWuo1/VfF28NrXcPKK73tVTCYzoA2PFBmvpIAuE0l55Sh0kd3m37ass75vnGTuHVuVjgYlOHKoIZU8mCab349alXDh3uV4WXn8pJbE+g1cLjFX7kHaq8lcl5shsSdEPs7TugUcPQha7dBghgoOflAM+Isx2vMMfTxT4AcTnj71E0DqM/uk4HFBTOUPn/0we0lPocuDBSgfZHDkB3CIl7Rk7MpwG9P/jx2tP2zhe5WmsWQxwxpJFJEwIf8523KMBWjGfNuaoBbqlTyNk1KohetGq5isF85rhgW6ZNjuo+IL7zoHLeALKlktUaNTxCqWAbhtnRPxlRDFALo7SWj5j8fV+2cSvuaEgOKNzc0/FKSpML/Nn1OmF38zAM/+97s16MP7ALRVdNHGhyGgf7tbDPSPDYhq3vhOJEkR/2sUxA4NKvPJf9DWLcOr6ESb3C4jSBx3rGPi8jvAE6QCRVi7oVlBKDYBAyrlo2L+YmyPs4OvBYGrKuksf7V+7oh4fvNCgN6yRjuE/igZku9GnzSmeXsZgslMGOH6j+WVbL7sO2WxhcukHwqOxmowoibCxQX3aIiY7taxtaejwTaoErHbuq7Jtrhs9wU9zI+KRatBtngQ1M59XOw83+qufMaq0L1liR9BIwS0JVNl4Eqgt2Kv4YI8Vp+dOwkTjVKoKVwTV92B4Wws/klvhnyCjKGplbAtKThc+iQgd7P9y2/uSkvixFp2QqncHCyA+PnSdf6f08ftRSinL0PZIals9EPeUvW7ZQOSBAb/J5sDW52+1q+/L2uaPjouKADpBjKfekFCwtS4oAGnVFvOmxNsE785ACHQ1ZxDQdEHMnFT7R0vYLGTN9wmqSWngu6OPrFnDl
 q+LBRufM
 dC9l4/YyoYujV0UfFZoOtU3pt1QyaF1JBnzADsHRfZ7ng4COmkwukpvcofN/KqQA84fDfp2ApC8932mfz+h/Q7KbtZfIFWw11MR306vjpeG92WXQ/GrXGJKfBU0otxD3fDgoBzE4XnmGiJ1IfqrRwvA0IoSUvSgSqUT3u+AdxRigbJQaDyHe4CWKCzZnQv0PXPV/BMohczAVNOQKYO7TrFxKgK7cZbxgj1bm03dIJrUjaR5kocfR8aKgNGw9GSfDYklJw37Fut9CQFCQw0BIrWMoxnOBv/2jJftMBhbEDVfm/USotxgHwtuM0YChmbI5Vf6ImYfidVUpD9Ltyrb3WwFSulUo99vWiNKEw5BwbfwfRodDGDcO+bOwEBwTL1/raICyoA8mJtPrR6l8IxyZ2G7hKFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Sep 2026, SJ Park wrote:

>Hello Davidlohr,
>
>On Thu, 24 Sep 2026 19:12:26 -0700 Davidlohr Bueso <dave@stgolabs.net> wrote:
>[...]
>> So perhaps any mm interface for this stuff should just not be designed
>> around sampling, and instead proper hardware sources?
>
>Makes sense to me.  I proposed [1] damos_add_folios() in LSFMMBPF'25 for a
>reason that is similar to your points in my humble view.  To quote from the
>slide [2],
>
>    +/**
>    + * damos_add_folios - Add a list of folios as highest priority target for given
>    + *                    damos.
>    + * @scheme:    DAMOS scheme for the specific access-aware operation.
>    + * @folios:    List of folios to apply the access-aware operation.
>    + *
>    + * If a kernel component finds folios that eligible for a specific memory
>    + * management operation (e.g., CXL-promotion or demotion), execution of the
>    + * operation can be requested to be done by DAMOS using this function.  The
>    + * execution of the operation will be asynchronously done by DAMOS worker
>    + * thread.  DAMOS features for resource control (DAMOS quotas) will also be
>    + * applied.
>    + */
>    +void damos_add_folios(struct damos *scheme, struct list_head *folios)

Considering chmu alone would not justify a generic mm interface, I am more and more
inclined to go with the chmu <-> DAMON option (I recall your presentation) + do
NUMAB async (1 and 2) and that would solve most problems in a practical manner.

Thanks,
Davidlohr

