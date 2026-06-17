Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD9B5CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5986B0005; Wed, 17 Jun 2026 11:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E286B0088; Wed, 17 Jun 2026 11:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71FC16B008C; Wed, 17 Jun 2026 11:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB176B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:17:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 897C31C1442
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:17:38 +0000 (UTC)
X-FDA: 84889758996.15.97C8840
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf26.hostedemail.com (Postfix) with ESMTP id 64E28140007
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:17:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BhVlvqQu;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781709457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35F7EX/8BxCUeTVGt42dT6UYLV8vordOiPVBdgmTrGc=;
	b=knW/iezaMWhDp3CHDG9Q7IKdoP9b+smpSSathGZYuieGUiyAnGHHudjfKmhDElwbfB6H0X
	oDokXQEwZYurc9Qk0jJT3ceadfF+PUlGqah8fGQALF9+FxL01U38dSgWcixFUMRMvrwuWn
	/5z0A0mdBMCFJ45mgtaaDAxe8rEObFE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781709457;
	b=SWe2CYvyHp8W5TjhjYZpM0M1r1pHFpl74EeoN2KVsq+J6MWVgL2Mk+mn+2VTP3vs6t68oG
	/PnM5yrFO47Ovc58TqwM/saCZmt8KcAwvIRTy1rzENG/E/GLUFuh35GSx7ZiRp5kdji0mv
	fLjc72DNh5R92D4VxOSr3VZWw8AKySs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BhVlvqQu;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 17 Jun 2026 08:17:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781709453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=35F7EX/8BxCUeTVGt42dT6UYLV8vordOiPVBdgmTrGc=;
	b=BhVlvqQuGtIwg/eIyaTR1yb9BZ4K7Yr7n+aE21IDtC1zCU3e7W7oFIwq2MWnVGklF9r7Ud
	PirBUoXd2nB/p2MjrCsbQ5aOfTHljqjsnEgdmfOdoINzCNI9O1vtpwI8lF3yBqgpO0mdg5
	IMxP0ObgY47zzvphvYoQ7rnc8oecaj8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, jp.kobryn@linux.dev, usama.arif@linux.dev
Subject: Re: [RFC PATCH 1/3] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
Message-ID: <ajK6cYzAHNd2e0QD@linux.dev>
References: <20260611105124.98668-1-baohua@kernel.org>
 <20260611105124.98668-2-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611105124.98668-2-baohua@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64E28140007
X-Stat-Signature: a67ncr1mqq7dbyxwjjse9wjpfd8f88ff
X-HE-Tag: 1781709455-235862
X-HE-Meta: U2FsdGVkX1+zuToJF7oDJlF0OJnueaSbTYPpnd/NTAnnSWWhDdfC0HBAwVlK9m1d9EQZdN9gta7p3XgPOWbpHntS8uyd2SFZ7Q6c90vwqv2shS1Oc/vHG7qiRokpvUBq7AD2c0l8EbFoFQ06IQp2o5Hs71H+jKYoi8QGssQ90QEG1QoePHYPlOHR2kjnjABvdBV/BR6v8S2KPw6G/K54iE8m6DMfKIfWx2hpj1LRgexC1qr2NkmkUsn1hwiuKahyVUPLAyA4AFBmUkcLU0zDzTUQmMC31hM1muMbeSHBDyC2BKFvfrYROSUntHRgUs2PNYrFMsxvyosptL6vS/mV6rv8TKbB3kHYHncu4bKZ0cNSkBc474W+x7H1bxJMoLUXS1a0C1UwGdUvVHwfyfGmrfXJOSXUqx5TXre3um1m7m11Pf7zqr//tkb0c3XVuyMcRMvxm/QJZh2kM6PuiXASVqZiAyImLMgtrj8Ual2PWOUQQwGfIU8Z/leW3rDuHajkUo5l9SKXPFKSx8f/iXG4xg4KdeKJJjE4J6d8WRgLhe9Pl02XpWQ5aGQuoNmTOEByCtp3/5sJI669d6WoWXqRey18o0h8Tlr0s7ADw3K9itZ/6+bAYRwEWjFF7xZxz/nwb9A+XNWUrMf3A47gExvhLq0RKKRlHq8gDescSdV0HZ0o3n8w4a0TzdgIY/Cz3DOKqN5hPPu6PvsZCakSHOgQJxuSmwsnKyP3XaNRVIN21eI27fAb11oTUITF6PBbSwcvPKmISaFEs5K9MuqUa/CfoTtR5kK/uh4LYG00WRd0gop8Re85MejLnaPLxoWZvCa/HXO5Bj62Wd6ukxOyfJIQoMTDHSkCZFVXJrNejAJh/ZJHiFvj7k5dhm1lSmA8dy+SIbIsL4yk6UB3N0sEjB89uhGU8lBC+fz3LDlAG0dLG7JyQEch81/NjacvzGgZjNnbdPLHhuB7gUOLYzbOr7D
 kJjGW2rB
 hkPoYef4H+wJlHOjupmihRaZFi10VjM4pdEDwBGyymNFS0wi+B9EO4upPgWALGz99H9PGgQn0eQz7bxli/NTfZnTCkCR9uUs0npgxqn9d914I55nk/lZQbmPKowC2gNWR5+J2+FOL/pTiR9qsBW18+BOLHM8BLq2BRHop8Hr4oZb+Ubxg17uRl6Ux532wQshzvRAKOo5EHA61OGVMFfbxd/I3jkBwCdt2WDXRORJmclu0hF4p9rC4jCM75vVfd1q/DRwh8YvKvYh/uYoW99ji/GbFJZUDnuU0BZjHHqoEdkPP1rehQrJAPniNSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 06:51:22PM +0800, Barry Song (Xiaomi) wrote:
> We always unconditionally drain the LRU before retrying anon folio
> reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
> are in lru_cache, and use the refcount to avoid many unnecessary LRU
> drains.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

