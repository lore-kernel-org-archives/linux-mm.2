Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B09ADCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 20:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFABE6B0005; Wed, 13 May 2026 16:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABAA6B0088; Wed, 13 May 2026 16:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC15A6B008A; Wed, 13 May 2026 16:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BAC66B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:45:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DBF81C011E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:45:01 +0000 (UTC)
X-FDA: 84763576002.06.1B0B187
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id BB2E8C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:44:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MwsS+Xa0;
	spf=pass (imf10.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778705099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=hK59TklJ3r7JacXrdSpS9889H0qpgYzPE9M9TYuJ0n4=;
	b=KeNHqgfsRQlJpe38PLyBFl31nFTw+i9YEwPccWMCgZ2lmRzf6sohi2aOOtJNuS9KV8eAKW
	xgo21wLAuYYcz52T1xnoVgffcy/AljIs2+1RWX3SRObISEXJi+JG+BvsN7TqENkF7yGe55
	cS9XDi4ypvUUYT58P66YlAfOJCE/VXM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778705099; a=rsa-sha256;
	cv=none;
	b=hmTrcaUlX/5svmcWxDAVbxZ9vgZPl6EEpAxcJ1/5NoeDrWnmiyL44n90pmT1A0kVylSkFs
	JfzTsuZZyOVM9KWquH7dzk1Md764zvKXQWjRR36n+SclOH3Z4IE96E03smq2ctkCdlANYb
	4/gnGUu7A4mnVWZIySoJdq6h7L7CdNM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MwsS+Xa0;
	spf=pass (imf10.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F3817600AE;
	Wed, 13 May 2026 20:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C499C19425;
	Wed, 13 May 2026 20:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778705098;
	bh=hK59TklJ3r7JacXrdSpS9889H0qpgYzPE9M9TYuJ0n4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MwsS+Xa0ve7JCeRzGoYjxyFKLIECSSEzJfYMPQBm5oVeYiLGSXLTpVQnMIEhTfA7+
	 1QS5UVfvr88oG9z8SeUtfZjA5O8CsyJIj8vK01ihh3oNcl0T1XZJDMCkIdtf9eqOIo
	 4Oh4ftvn7W66wA2AEqIEZ2yP+oCcJuc/4gsSX64Js6zdr6JFdFIzWJi0iaK5dfALv5
	 K2WV48WoE1xfrfv5BXkHgiqdFosoNQ51EtyRmDPfVNm3XSszy58YA4UYC2fH1cNZaC
	 L3r7aAuRNntBvwJwjG4h2xgxaVJBL/IC6s2/mmRkSI0+Zs+cuJMu274jB1ZTsccuQ9
	 3pJXIVyzoQXSg==
Date: Wed, 13 May 2026 10:44:57 -1000
Message-ID: <a4f68c0ea0accdcacc6cafe444ee786f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Maarten Lankhorst <dev@lankhorst.se>,
 Maxime Ripard <mripard@kernel.org>,
 Natalie Vock <natalie.vock@gmx.de>,
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 dri-devel@lists.freedesktop.org, kernel-dev@igalia.com
Subject: Re: [PATCH v2] cgroup/dmem: introduce a peak file
In-Reply-To: <20260513-dmem_peak-v2-1-dac06999db9e@igalia.com>
References: <20260513-dmem_peak-v2-1-dac06999db9e@igalia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB2E8C0005
X-Stat-Signature: jnp1ckz9u1yi7p7crk7j1feg4zcnw4hd
X-Rspam-User: 
X-HE-Tag: 1778705099-14773
X-HE-Meta: U2FsdGVkX1/EPAMPRMYQNAzAq76zN9NFuQhFVQMEclYbWSBkUtPcYXE1QUq1ktZFJL8dKfQhNX6t0FzNRTeexIVyyzXo/v/tVjaYA8jezkIovEOqKzBixkwl1y/3MI2lvAxZ2+XvuxhTQAPUAdovjZ6tL0SAY5p4cYiRM/IsmGxh4SsHrQ+USeAFZRKZ2wQXciTqsoxOyIFF9PMKL2DQEacKUwws47U1OiaZy/CiOSbFqmr68MQjvcfxlA6koCIvWXs0eoLOaVHUH7NFkm4pFBh1+yfEWbDwxJlyK5kvzqHflCHV+vCRmGDLyAXxmithslftZoQ+Z3pzrbYNb/vC5WPgH9zNZqAS7ZDw9iexB7ZOBiuOVSkTNuAqUOu0OKFw5Dy4FVuUkK+qn+qTFRVu3Z8H9IECTL6JWm2Zldj6X9EKFE0GZ91kpryLHVl69mLQuG7Bd/6Fl4Gqcmd3aguH7BSLEYwANbsg2OKmuDpPq8+OOjjycbzbLogtXjle+QAz5MOl6hZdgbj/CM+JiZTUTMQQKX+xwgHWQq4gCJ/rKakyNlLat8EvnUTzExObCvYAjmmFz4EWK7EsR/g4BMNc+kk1VB8W6xC0EXOrA22Y7E6fjz1ijn1EoVaW0jgJlQTjCNC/SutiSrSatfLi8MPNyxotDmXwIECMqS0rzjG9jJunELRkGQrFpDs/q6muZGEhlKhzDyu9tX1j2VgaClI1ZXcTyu1/GdXs5UC7mqgqrvAxRPQmlUlAJRuTX96SifqDJzZ1GG8ray6+j0clh1MfPkL2NaUZRQKFcgotkZPtpo50sjhkSaPlspDedtohOJOPK5rK64TwuTg1qCIKNOAtUNx4fDHwKfclkWnJvfwEaPHYjr7NRh71c3AQR/X+msZ3x0sQc+LtPDGCl524nPsjSIfKuA6B1ViF48fOJ8gZ06dqJwtIN7oJSl/Yd3QYX+biFZP1nDXZvAQ+Qn0ayMO
 qAG5b20+
 +TtZJvvgasATGDR1d3y62oHaYe50S6TLofoJBLVZykO8E7XkOy7t9dMoqjpCxNeTokuO64myH+kXNAqr7hN7hKj5DJ3DxZa2bwZNudugq7XwxtVHiwVyhKusLuz2WoVOHVUK1TelbCS5eoxSDxcicTJzCGdrG4bDCBn06ZJKxey5OnMQdvKwlLLwUg8kSaFkAQsCjCgZNer47Lqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

The patch looks fine to me, but please flesh out the motivation in the
commit description - what's the use case, why do we want this?

Thanks.

--
tejun

