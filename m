Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2555CA5FF5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 21:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B5A6B0088; Mon,  5 Oct 2026 17:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC086B008C; Mon,  5 Oct 2026 17:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD866B0092; Mon,  5 Oct 2026 17:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 620766B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 17:35:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D36351C3425
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 21:35:22 +0000 (UTC)
X-FDA: 85289878884.01.C862931
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1140B140006
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 21:35:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=P6Wc7Jxy;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791236121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZ52pUPtOfeAPAn2Ck6Sgm1SDj6aR1P1uVv4/GKks+U=;
	b=4OZBRUAcxDk/AG8G4hHfiBPmt2/t+kQCZ/kAnkHPRDlHLAuCc8lDMYzyRmwXYRHhaimnL5
	ceAVcy6w7O13X0RYb3FV2HyTfjgIdxdzrZmM1+OW6pL5FD9creBCiOUaEP4eLGqSw9OfNO
	5YOp8diVJMvEOBVXhcA18RgR1crqKFI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=P6Wc7Jxy;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791236121;
	b=TCG6Ub5EJVlhofEg5ZQ+c5Mq3no32NBALKYVuFVLNfMcpLljWlAsWcjROyJxFHbGO8wVrm
	/6E3A+ZUQm2k1vEC7t64b1oGJJZkCjgSHlyzd8gjhJrON8Gdyr5zo/3KQN1hD56LnEqALd
	qiJYvK8Zq7uAyJHuDrehBiiGIbi4H3o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD9104089C;
	Mon,  5 Oct 2026 21:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5A21F000FF;
	Mon,  5 Oct 2026 21:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791236119;
	bh=yZ52pUPtOfeAPAn2Ck6Sgm1SDj6aR1P1uVv4/GKks+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P6Wc7Jxy+1ZID/sXiTgAHGuUNpQ/E2plLnrv8YW6H44xwVV2zjVF2KMjxSerXas3O
	 ELrFYnOTKa74Cl9ESuUEZ51asjQbAD2siHFnLxvZg4C79wMvpPWGPQJO8yDbAWUp73
	 I93AkL++LY7yM3DhVxV5JidS31ydjb0XCgAx7U00=
Date: Mon, 5 Oct 2026 23:35:16 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <kees@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	driver-core@lists.linux.dev, linux-hardening@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] devres: Provide kmalloc_obj*-style API for
 devm_kmalloc
Message-ID: <2026100532-stench-enrage-0b81@gregkh>
References: <20260914223212.i.829-kees@kernel.org>
 <20260914223219.901347-2-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914223219.901347-2-kees@kernel.org>
X-Stat-Signature: cpnpch1d8ajmriy31a5fjuoj3gnpffcj
X-Rspam-User: 
X-Rspamd-Queue-Id: 1140B140006
X-Rspamd-Server: rspam08
X-HE-Tag: 1791236120-62557
X-HE-Meta: U2FsdGVkX1+qENcQuJtLBQdkGdsyiOJ3S5uvNEXmUla1xWOscYzyFa7PuAZwumCbCVqgodJ1sz2JuIsk686K/9H5XU82DEWKksA2F+9CB9aGDFcgHe07nw0vxKI91urNtXHvZVeqIrbZbC+AM98x5E/iSlnIdr+n45Ao2Bbo2jTvucqkrduldiNVZsD+bva301Anqsf1P85891RZ8E08dPmLpTL3qOh611HPMFrO3TZqIKf9bumOg+TZl1ay1rnc3XYeev4txWKD62SVDgYoW+6ekVbIDkAZeUzquyktRRmtURhj5Jd6hiQcMj6XmpmLRKPS8JNIWljagUpNhwDzrD4dYvCSGi8yBXyybMEGe+UibrcvG1Win//wRT7HHIvYiJL8A6PTiG8lgjFtgQw31JgpqhnqeRGeLI9P50e3jT4WOAzbhyKXPgtAj2jgi041LWJI9S8J4kuYgrjogB4pHiVptiFe9hNuD1d7isdMHuvjjduhBVnhGZOVgTju98PwwRpE0AhXr3/08/yfZpPAOpox1hPTlEl5FeadZaP0fnmpYMgzAzF2OtwJM1KXA4TY6lSLHTXnUecTghnBmm7KB/Z4yFzcjjlqwx3hJSUHtBtX8CW3GUR0ALgwcPEZIlKIHRBhgjayACah3TXkr6Nizbe9Zlm/JbjxErko5qr71uYDcQPvTAVZzdXfRC0r35onOCS8JLhB6hZKgQu9pFbbWnvJuy32jpONvzFh+XGcjOFja4fl3/wItKxS1A8zd/qHWwUvkvUh7XDjW6nXL9cCYO9GdmZXRKGZtbUTYAwHG/1qgQWY68gD0ywyLA8tzFaFDZijSXqIPLB0FMiu3hqNRy7kJK9wERdTfgIMM7RQalKhT7Bdyzc7MJlJQxlDHvul3wW52nRplAzTSGMX1OvNwGmmxaw3KWprnCCysHOzaKTPIubLxaSSOwJUmHviGX/pbPhQjvruMGGpV3b6sZA
 lcudJw7C
 M3MyRgL79na0rd4JfcsMlMtm6roR9cl04FHroTaS+9E98CxjcQ32/1IImPa2PtNBiKUiol6pN9QLqPPPx3DxZ18E31c+32elUgI2hsE/uVji3/c2v74YuHpm5NfPF6t8qBEBS+D4ueMH6UQAOG7ANbIz4e/h31XMdhCBtrm3g+bIHKDI9BeFB8eIa9TW4ig9elKFhnJIlfN7K7DbNs/lT96id45RdsruavlcvpYxG+x+wRIu6GNZ5qzM8glEaiwDRCuIPlhxai5qn6XcbXcyHixu1984AO7X1ZFr6Pqcms0xvx8ZJWozEttO0dqarHtpTequP+hqkNfdjWxzTGOngAi7wOnN9XrezFXCIPsc1cNd0lDQngMiUZMOT9TvOlfX8zjeggP+lrX/0u5wmN3vVTfwBCFAAlHBgPYeXxxKB9usu3ZwNM2flndFCGU8yCvX50C9YZs8cI31Zwkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 03:32:17PM -0700, Kees Cook wrote:
> Mirroring the type-based allocation now in use for the kmalloc family of
> APIs, provide the same for the devm_kmalloc family of APIs. This will
> allow for future plumbing of type information (e.g. alignment) into the
> underlying allocations. This immediately gains type check on return
> values (instead of the prior "void *" return type).
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: <driver-core@lists.linux.dev>
> Cc: <linux-hardening@vger.kernel.org>
> ---
>  include/linux/device/devres.h | 102 ++++++++++++++++++++++++++++++++++
>  1 file changed, 102 insertions(+)


I'm guessing you want this to go through your tree?  If so, that's
great:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Otherwise let us know and we can take it through the driver core tree.

thanks,

greg k-h

