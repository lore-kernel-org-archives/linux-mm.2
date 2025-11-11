Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E70CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 19:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D915B8E0018; Tue, 11 Nov 2025 14:01:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D421F8E0015; Tue, 11 Nov 2025 14:01:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7EF18E0018; Tue, 11 Nov 2025 14:01:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B67618E0015
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:01:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 816351DFCF4
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:01:57 +0000 (UTC)
X-FDA: 84099245874.18.2AD9AEE
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf23.hostedemail.com (Postfix) with ESMTP id AF73D140018
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:01:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zg6iOzgw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762887715; a=rsa-sha256;
	cv=none;
	b=CkVOtM21KV4NR6l9o1KNLYnYLDy6tyWPNFW/cqdsclN/XZAeV4crKbns99O4Ti0O6I/V6B
	Af591HL+NPmxdUW6GLh6ImiXNynrGK6u1GbiQB/1p2FnOZmPvYyWN6W0MCTO405Au0SRFR
	nwQhcjMenarZysHKPycloiVLbIStMhg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zg6iOzgw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762887715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X3p0OHTe0vlUjyhDWhZhm6oTZ1C1L+keJX+PJWob0hk=;
	b=pBLTOXU4jGc3I0nePOFteA5NfXwATW5grEF5OPZOOgb5MQBXAv37qVUZ5a7qQ3UGt/QAef
	ISLfB7kjLEBHCcN5jzfzRXdz2WDdUllyy2ahzg2MO37uTROSEVIUnydgfdmwNgK/6ueDbA
	TUv+wV9Jv2kfLO48I8cLWxRSfrxoy2s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762887714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X3p0OHTe0vlUjyhDWhZhm6oTZ1C1L+keJX+PJWob0hk=;
	b=Zg6iOzgwfbrFafmG6DBIIvIS6DBeLRm6Sopz75Lft2XojfXoTDjLb5lA4KUWmxyE+akzZq
	L3lqa9rGljR2bmGx6tMT30TfUHA7vjS3K2hsIgOxPH/lQ0f2S+Cqb4t4w5E9tZZz4qX8le
	gnjpDmDj0GMG5gDFQ0SkqBFkI7O/HRw=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Muchun Song
 <muchun.song@linux.dev>,  Harry Yoo <harry.yoo@oracle.com>,  Qi Zheng
 <qi.zheng@linux.dev>,  Vlastimil Babka <vbabka@suse.cz>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
In-Reply-To: <20251110232008.1352063-1-shakeel.butt@linux.dev> (Shakeel Butt's
	message of "Mon, 10 Nov 2025 15:20:04 -0800")
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
Date: Tue, 11 Nov 2025 11:01:47 -0800
Message-ID: <87pl9oqtpg.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AF73D140018
X-Stat-Signature: 3kqqd1khj6skpwf4bj3bia3txx98a6zq
X-Rspam-User: 
X-HE-Tag: 1762887715-103040
X-HE-Meta: U2FsdGVkX1+/TemksOdjI3hDubA/icAtYehJ984c/z5sIKKq/K5GiaAZq3iaYL33OfyB/Z1ZKKGgWE0jboLi9U4KtSGsJn4S4q5NLxpdj4YajqfS7rwTQuwxR/w61eEfTQNGhZpzmfJYcPC87XqR0shPms68GJEfqACelrIWRwRpjpqGrJnOQXaq/VxY8HJD0rztwz2mExyHJOSxpd7vqbwnBWQfuhxeUZaN4M+O2RDrsEKW5H6m1sZf2F1ZC+9RHtl5dWb+QhPnjOng/6SSN86UI9fTDn5PsSPl79Uh6+DgFoel5BfJiHH23wJ1gSqi5sAFvfj7M3XyjnHLtRjKEVeKFpYdM5Br7EZhPv8wJ7wGHMI2TLf7Jp4napuukI/XDyp6xSLBTG0dkgHbBA7mXH97E7r5+Hl1QHIO/WUj00Q9VbDGA06ptqvqyrLEfkI9ypww/1GreqCGYZX4acOtQ6KTUq/imd/T019gi6YywEpSJML8WXNf1qzW6N6q11xFtRX9qFY5FPe+L83X61IGH4qsQwYBwOaof7qMo+xMMIX0HIIX8yGfA09cpwdVcdRapQD5x2Jzf8d/hrkjB6g9Ix2R9LDpS3QZKwPmxoHTlco41R3XmDbxn3JYTRDm/rvfWHau+DxprKG5pGObevWo51wkOQXkbU5hts28KmIeEbdl1tkmvnWbrqf6tDvYD930KyEgcVf2nigxcfz5tgSaRbOvpYhGi28VfzQGC6I1jB1QoVsEA6m8pUAwS0CSqF/XlLQnP5sgqfj0kwI5+R8wYC9cxt2tmAazCLvnTSqQcH5X/tDX+4lwgV4kpJJdKLKnEED0pvkoiyBVtepOYnlbT8JtKFGzualK2vNpgu4BPjLDs82ZNE2gaqA1e16oNe+iu3anH9v/3KjpZSzLpkR7FnX3k4NIfoGpMtBuHgPxeFj0d8bMuYt0KO/EdXAP6goODEo2YGEw4Bkm3nFgF36
 l/FWhwqC
 UmjZI+t441H62hOIn25e6Mu/qDsKl+uNbofcPvn8lVRku63xYnmVz+s/q6qn7UInXEqxuTj4PVXrGhzntkcATxQeqHBV518wzcOo7sgAb4/yTnPCNn5yK/R/1gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> The memcg stats are safe against irq (and nmi) context and thus does not
> require disabling irqs. However for some stats which are also maintained
> at node level, it is using irq unsafe interface and thus requiring the
> users to still disables irqs or use interfaces which explicitly disables
> irqs. Let's move memcg code to use irq safe node level stats function
> which is already optimized for architectures with HAVE_CMPXCHG_LOCAL
> (all major ones), so there will not be any performance penalty for its
> usage.

Do you have any production data for this or it's theory-based?

In general I feel we need a benchmark focused on memcg stats:
there was a number of performance improvements and regressions in this
code over last years, so a dedicated benchmark can help with measuring
them.

Nice cleanup btw, thanks!

