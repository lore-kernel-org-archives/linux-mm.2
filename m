Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12046FB5178
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 00:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32DEB6B0088; Mon,  6 Apr 2026 20:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3059D6B0089; Mon,  6 Apr 2026 20:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243CF6B008A; Mon,  6 Apr 2026 20:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 179646B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 20:19:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C304BA070
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 00:19:50 +0000 (UTC)
X-FDA: 84629851740.16.88DD502
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id F0C3EC000D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 00:19:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rIPg5sHR;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775521189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oaZoNVUlJNqrTr2JhUwZ1Jn20+kwe4oSg5VXDVG/Qks=;
	b=Z32bd78T5RTFKR1Um7xamJB3AgO0CqdRVfojQYbsUF9RQV5qipmbx285QSdz5q7bStvtRz
	NRTXK+T3gCQiPjueXjpFigzPHqJOXtqmMojlnBgwgdSVhtG1wY0rRVgiRigCjFTJ6zf5P3
	6mleS9qYVtWgJ6Sd++Pk4xiqUTB9B/0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rIPg5sHR;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775521189; a=rsa-sha256;
	cv=none;
	b=RD4/B/ls4DZaoKKtxtfAqREVEcX7DdERKQbpdp3ibkRcfUY8WdUDwqIpvJkTY3y1g6vsuq
	SrGocyObz7dMsewGUBvRTOrrcaZaijtE3njIXcr0eP/do07LO5F8Qu2OczfGJfp3Lmaiib
	Q0gCFqUwbh2UnjqIdxA8VF3jlL5h6QI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6435B61336;
	Tue,  7 Apr 2026 00:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA09FC4CEF7;
	Tue,  7 Apr 2026 00:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775521188;
	bh=83YKfagqUe6mGC1/lGFW4JIoByHR+C6YNG28dM7Z90Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIPg5sHR1AIgtQXwl/VsD8oQZEvsWSGfsqA4PmN+MQ8bVXJEgtc2qbnc9bdqTc89W
	 kLQDfMwesHec4GEOVpq5C0K+PUMbFTu320Y68jJwUmiRrcew0AEWANcDfWRlzx/h1I
	 NwZGsFKvbk3ngKn6BUeFkp1PytdPCVVS5Iil7idhW36IUd8R3HFw2micfYT8HkAITr
	 EGLl+g3BjaYAcy3HKWM2lojqV+666DTU+MivisMJj1yrtLdoopT23dv1D3YBCpAr1d
	 YtxYiBo3xUghjFcsCHSbeSGgdajw4pOdTnfZdJYpclBcMuX1HQx14NSAsh4tlO+yOr
	 sloggGqd78GzA==
From: SeongJae Park <sj@kernel.org>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH V2 1/2] MAINTAINERS: add lib/tests/slub_kunit.c to SLAB ALLOCATOR section
Date: Mon,  6 Apr 2026 17:19:37 -0700
Message-ID: <20260407001938.78761-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260406090907.11710-2-harry@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F0C3EC000D
X-Stat-Signature: 19ai1ii6rxahepnrxufcx415jqimdb46
X-Rspamd-Server: rspam06
X-HE-Tag: 1775521188-389463
X-HE-Meta: U2FsdGVkX1+EXwtYYeLml/+PI1loDXcKKr0k8qJyXvhW+4HqbC+7bD8w58ZiK7AID4TOPb8bn9yD8PU1inExEkjx+0kiVWj9ZB/HAjkFUAXvimIb/1CEXqv4XufYrbTf4Q07OsoRsKovE1bhtz7yH5ImdykCq8LtbZ2C/W8GBTNWydqnRFCFecJghFyHTGklAX/LnAC5GNEwIny0U9HmYHGhAG+thaiMOgFf9Phrl0fHyJBH6qf4WOkvOb3BMo+ZZiYA/L3e1/fA9j5Bv7T7JzCV3VLuhsdYeDfv9P0K6lhQyKRBaYDDUrEtggcz7Imhcv39qsar/8wPx2BSDvXA/mrafyGHpzEFee88J3HN6d1AGuYOzM6vWS0GuwP5e658i9MatDSw9hHe+OzBikxQm+z8vjyoO+gjaEsb062PdmM/N3pqm3oyPb+KQHi0tapswSMvHnLoccS/dMt3OOW6WSgsgtABLBeYJV//4uqGnqaRcHW8Tvfl/MyhbfVbyCvHRFeiP2pF1/y5YsNmQTMTYzgev6irecLQQ8QORCTKPHIEq4qBKqt+kOhBQaBO1vJPmJLhBDNLnxMGZh5SUlUGvFR7KApHJU5swrGhdL0Vi8xu1TTeyqLyht2sVC3Ud4bannioRfydnRKjO46EXZavYGWKUrobN6lGw9rtGo3TGRtrgY7nqcP6KlEFNsBlfxXPX6d0vvZ5yrCKGqYV8B2Xeu8s4XjEhAGc3jWpb43vwYghzlGsyQd4aqA6uGOqbhLeR7D9unBLtx9cEX4W/dN9IyI6QlMUPhGOmVA36n6GfPMEqaJiKctRwS/zgwSltpyLxciayZsmTGgnYLrIEamsBSQSrbqISv3yQfCYKzVg34arG6X9+tUXs0gdj5QOzS2i6cMDMCLQz4FBL8WgGuWDm7cl1LRP3XQV78+Yigep4viVT3WW4ZILPLFqK0/lnYj3qdFZmmBdfNmlbOilMEc
 uft53DLQ
 B4sy7jQks7GVkPVgD4xUL197fq60q4c7FQHGUazeWcE+1A2itMquobhqSrdNyPJXbV14kwPxWMpPTt00GAcO0rlZ/1ad8V2AXldquEaJVE2p3AytJM+Iwl8zaUbBAS68AcgPSpu2y/lCsKdcH+wMzVA/cEOFjcxk8H2BOnqfXxToTTEoPY9sJsN1RjPb5fCyWus7FdGjTA2RUo6Mh0ytDJ/EAtYJKzjhbMuGh04WGBaVsL5NuwClEU32K2C43z+bjwicNuZG1XufDZPnhoiJnTcbbBpn7dEc9VbTtJC/C6pP9+nE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Apr 2026 18:09:06 +0900 "Harry Yoo (Oracle)" <harry@kernel.org> wrote:

> The slub_kunit module has been maintained by SLAB ALLOCATOR folks,
> but is missing in the MAINTAINERS file. Add the missing entry.
> 
> Acked-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

