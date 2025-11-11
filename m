Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BE45CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C968E001D; Tue, 11 Nov 2025 13:58:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DCCD8E001B; Tue, 11 Nov 2025 13:58:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F32A8E001D; Tue, 11 Nov 2025 13:58:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 776768E001B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:58:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2626E1DFD41
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:58:19 +0000 (UTC)
X-FDA: 84099236718.13.AF6B064
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3D4A340005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:58:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rHob7y7U;
	spf=pass (imf27.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762887497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kx+FXBuhKKRAGKrr5/plFPqCKumMeNYYYtkhE4HBypE=;
	b=wEL4Q1EgJRJC+a/pStFjzvb6H/ESpt3mr9Ee+AAdfLJsxaLvoMTaC9lFA3OUUlTbq61Qm7
	npKodrUHrJOsDlJrxRUWue34U9COk78k37kpVZBtfQ8ZYGsJsgDklDJUS03WwVAY3Go8Od
	RyAHlU71JysyOz6heH9ec8L2T3QhLY0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rHob7y7U;
	spf=pass (imf27.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762887497; a=rsa-sha256;
	cv=none;
	b=YoN25FOiD3EBQUjAOE4A+vvP5nlZP/kh4tWtQmE/SCVDoBC7752or1WtIim7nWsddUg/4E
	7aSO8DfwzZ2/5ONRyobklUKPBH0H2SBRa+KQP8CbloiZZk1nu9BcKryQJrq0v+tNHJ1L+G
	ns4CUfy6Du2XhebFhldUYLfHJ5lr33U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762887495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kx+FXBuhKKRAGKrr5/plFPqCKumMeNYYYtkhE4HBypE=;
	b=rHob7y7UWymH1inhA1ByOYabtPCUkfecfAjIaljlgEHiACDBJFHtSRnSanQ5oSsgZ5Z1fH
	z8kMqD4pdBecZSRUvP+pOZ00ZD+9iEjeQ8tA9GB2z/gu5UR5HxNvSKYl0XRxAuNjm27kt4
	d/V9G4AruJodXnPdobBbAcDYHa4jikc=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Muchun Song
 <muchun.song@linux.dev>,  Harry Yoo <harry.yoo@oracle.com>,  Qi Zheng
 <qi.zheng@linux.dev>,  Vlastimil Babka <vbabka@suse.cz>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
In-Reply-To: <20251110232008.1352063-2-shakeel.butt@linux.dev> (Shakeel Butt's
	message of "Mon, 10 Nov 2025 15:20:05 -0800")
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
	<20251110232008.1352063-2-shakeel.butt@linux.dev>
Date: Tue, 11 Nov 2025 10:58:08 -0800
Message-ID: <87zf8ss8fz.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3D4A340005
X-Stat-Signature: sggh56w8bpi8w4u8b9mp6a85r4bo5dqc
X-Rspam-User: 
X-HE-Tag: 1762887496-515786
X-HE-Meta: U2FsdGVkX18jKtSDODgpicS7Gwe0QbemVvUN4HO8az5H77o0UOwOWLde5xczo5S2lBuSH4YKwaYuw+wx5LdQL8y4vSBKahQGnLRyzKJ1zUewO7k4YCHZs0UnAChn+PlGde/+SozR8CF8hTWaimqRpvuQGcc4RIz0fjvM4r9V2hk4XFXCNmlp+I3L+EJAOSvPqyiUILfffhaTMex2v3a/ZxccqARZ0szJrL62u4dM4Ijl1qp4C8wREZaIiAJ4h2QTHaEqol0CtXIJ7+v3EPUr0lSTK4ZcU/4ZZLLRvh7EQhRt5WkePCZtqBpQXUY34ABP6tKRhoCMveqXq8YGeZh5ogoBCVis0MqtUM2ht42sMWDcegY6+q+WHwGfprdo2yz848vOrLf1K0ZTdvGwzVH0CVFWiK01q2e6aHTGmjF9Fvgx7EkjKhfYDFurpgEGN9y8bGl4VB/XN67/rn/Lqs4uAQqelh/EKkx9qrGbrVCAXPCsHsOHbwWdauzN2aCLDFhoH+wnzOeH7sp5FFfvKNZgC7ChQNlx5W8juWK7BmVSdeD6eEDH3iUufg/dER7SjgzR7rJL0vfhiWiHrpdly013Gxr20eyiEFMMg59BE/qb/N6mI9SnRjLZWLwNi1rvmj5jsqxoAgrMXVk/3+avk+K8RtQGbbEFlenFLbEknxNgkMqP1LrhpIjQpXtIMwlvj2L8zYtEY8x8lddWeajtozdVFlYvYMiXTy+K5n/GeBdHIkgFIn/j4wAqOaerRoERQ+w6LzR8wwxzH2VUCwE7guMdEBkb/6A4t2YRCjhtu+QaCrQvAZjbXJEif2azyvvnzOAa7K/MgJKcAgboaPO1KPgWBBmyGcAdyuxCWnkLH9ocrbdRxX2Dfm7PXWT5ButcDlpkdjcqSEi8TbVFKYeV8rCq6LIq1BoalWXkV5L0LAH2iK4kAvXk33VOVs5IM4x7G9YzNUiSFEWC1TcBP/GD8QO
 kaRqh37s
 S8bM++xc7gCeKp9/yY6TPf/Q2M1WKeNTC3pja0busLHAlcOL9G4E4oKRR2wKXhF9mGNFizrEB8FXHsNHpCrXOghV2EVshLUtd7Pw6KWVDtWa1FgkGfTh28ZBD6epH/UebhAIayJTuWjrLeplKBhVJqWy6XRHuI1zfolx4kS3iT39/6w/Ht0AVHqfVtZZR4QtFpDeoZQ4yKnvKwq0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> The memcg stats are safe against irq (and nmi) context and thus does not
> require disabling irqs. However some code paths for memcg stats also
> update the node level stats and use irq unsafe interface and thus
> require the users to disable irqs. However node level stats, on
> architectures with HAVE_CMPXCHG_LOCAL (all major ones), has interface
> which does not require irq disabling. Let's move memcg stats code to
> start using that interface for node level stats.
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

