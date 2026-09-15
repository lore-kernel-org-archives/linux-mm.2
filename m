Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B83E5C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 16:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472E46B0088; Tue, 15 Sep 2026 12:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424076B008C; Tue, 15 Sep 2026 12:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339286B0092; Tue, 15 Sep 2026 12:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FDF96B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:28:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F2991404B8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:27:59 +0000 (UTC)
X-FDA: 85216528278.06.F20FDF7
Received: from mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	by imf28.hostedemail.com (Postfix) with ESMTP id 13BC0C0012
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:27:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aaDciXGj;
	spf=pass (imf28.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789489677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPCrMUGnpn8R2ypCIpaYTa7ilO/DP1aGUQ1rNOw3WDo=;
	b=8WbAbRNI+bk4yhX/GE6oXY2aGVPhqhG1DV3VG97m08j3PKVGhjwmesUKM8ccdXvwQ54cEl
	2OvXpfFWG4mRX9S0QUNDoHd8ZfdHHx3xgx/4OSEnq3cAUu1sBmxNJCzXqfX0le+aMEsjnv
	dwCXCfKBFPVeRGLMyD2S9bXTBuaH2Xg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aaDciXGj;
	spf=pass (imf28.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789489677;
	b=T1+EHVdBCUvCLS2rM5XaDsz1CtTfHeb/X3puAzXTpqDkhCw+xabLUCHkbp5rlJhRsLyZmz
	jhnAu43GW94HUdFhS9+9UwhZeDh6517WP+IkBam0jG499lGwhXxDLRqYlPxH2Rh3il5MJE
	Xjn2o9r1ytOvE+Xl00bHkd16eg64430=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5aAOwXTYMykx5gxXWRId8scEdWimaCHbC2wDxGMxApw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789489675; v=1; x=1790094475;
 b=aaDciXGj//CpMTkGjwOYER+DQTexXuFR5qvdm2eqrq8Vfq1ZkZ/0Umej2dtR4wcwuPR3egUY
 r/cER8O0q+sJ8+FYJCXYpev06UMAqgDTgp+mLVL8nB/Oo32AI3proogaeAM8qgUzo2iPdx8S9x0
 x7QOsp53q1REMDl+Krh8hH0o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7bfd351e13a25abb;
	Tue, 15 Sep 2026 16:27:45 +0000
X-Mizu-Trace-ID: 7bfd351e13a25abb
X-Migadu-Flow: FLOW_OUT
Message-ID: <9568025b-7a99-4404-a371-65f26a29a411@linux.dev>
Date: Wed, 16 Sep 2026 00:27:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm: refactor zonelist constructors and iterators
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
 ziy@nvidia.com
References: <20260912030424.2889731-1-gourry@gourry.net>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260912030424.2889731-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 13BC0C0012
X-Stat-Signature: maw5jckh9za35j3xn56ayramujfnpqgr
X-Rspam-User: 
X-HE-Tag: 1789489676-7401
X-HE-Meta: U2FsdGVkX1+1TrpYPKCd7Zal4gabTI1k45TVFqZJaasCQ57J5P9RaHFCTAjTzfYPKKUtbjKfHxIWkn0H2wq4gRBIHB0Mt+DYSPRNq4wM7ydL1ADnRpWa63qff7/USVJu1HoO6zjbqzZOYLdH+L1aicWp/QUnii5Dnfd4Dl7i+Y0f6g5nO48F0bmW74i21FKNoeZVTFPVUDruh9cw0oe67K8NfynEohEF+CZfy1d95efbmKJoY9JdYzOlWG5EMFn9Tt5npOal6+omRbPU5BRtAai3UTtvhU8DcxHO9TSmUG3Y/OK1Ycrtg7Hew5HJpaY4eHq4CT4uqvkKGWWSr8ZLED+AwExq+Bpns/53SV077NMo68SUsWintwLn0N7c5hq7uXC7uvIrQvW4TPx8SS92rcbxMcf+hfZonm9WVLGG/3BR+rXrg5FnQUuyFCNbt9urzIXXwRjCL7BRztu0t8YJANoW3bDzUeWqR0qXGslyqMZZIx0nzF/2E5kyCIRR/TheRFNAHHmJ5aqv6II4ie1ym85rCVYDwKIPvBNvP/S5hICclDClHdCWJBIlrj7WV840zn0cOYGoauisU2fUVUJX+CWXVGJkG5OHcm8x3keahw05aPtVCIAFgzDnoF1mZAv5LwUSB+oNpqNyM7x6E4UrpOrhBR5iFAuLzDS6MCsq/xCjaGH8pUktfykDnQ+IhNT1/zsaNLF/cYysabvPtMEV7xWXe0saz2za0EY102NCQ7N2ViXAILfGZek0w0xneofdgkK+7t9CVtCAWaqW8UESdlc2UAWKprRgwRG9s3hHmdzEBqw8/K8oE0CyZMbsb7Rm0TZkqMzTqY5Qp6aBTcpU+O73UbF9IWFGIatu0TfTfs7oyfm0uH8ViNGkIgmwf5Sdq036HOSXj7PvIGVL3eMgQneWHnUqYusaQ2mNTwkzTCkObx8YefZ8EbKUXoZUlQW7uiZfEZ8EuvaDBdqR/Bs
 azq+JWIc
 nHFvy2HjsqGKQ3osm3j2Vr/XGmjOzKbTXlFphsS225dJmQbe4DTX6EKiZS3fyp6xpKQINwvUfXWBdCGJpg/4LdYigK2WCVMfj+NSZ82KViemkP3n4pQxY2yDHUD9ZGLdALcDrUoz+6slZenpZaDaQTDDaopiIz6DKhxzyvRkdtlQ1V1qyy7Nnj1OFCXCT+AvAEMAroxQ/ZgE4goTmBZOJHZO2w7Un04iv3jEIBqXCFnsX9wGPzInSgMcrrLijDA6daPZGBD0XZt9edBgRALFxtx0nWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/12/26 11:04 AM, Gregory Price wrote:
> find_next_best_node() picks the next-closest node when building a
> fallback list, and hardcodes N_MEMORY as the set it picks from.
> 
> Refactor it into find_next_best_node_in(), which takes the candidate
> set explicitly.
> 
> This makes the existing behaviour explicit at both mm/memory-tiers.c
> call sites - they select demotion targets in fallback order from
> N_MEMORY - and lets callers narrow that set.
> 
> Then extract the per-node construction loop out of build_zonelists()
> into build_node_zonelist(),i parameterised on the candidate nodemask
> and destination zonelist index.
> 
> Together these allow a zonelist to be built over a candidate set other
> than N_MEMORY, into a zonelist other than FALLBACK, and iterated in
> fallback order over a caller-defined subset.
> 
> These are prerequisites for generating a private node zonelist (nodes
> unreachable by default), but are otherwise general improvements to
> the existing interfaces so I'm proposing them separately.
> 
> No functional change intended - purely refactor commits.
> 
> Verified on x86_64:
> 
>   - find_next_best_node_in() compiles to the same 319 bytes as
>     find_next_best_node().
>   - Both mm/memory-tiers.c callers grow a single instruction - the
>     added argument.
>   - Boot-time fallback orders are identical on a 4-node guest with an
>     asymmetric distance matrix.
> 
> Gregory Price (2):
>   mm: refactor find_next_best_node to find_next_best_node_in
>   mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
> 
>  mm/internal.h     |  6 ++--
>  mm/memory-tiers.c |  7 +++--
>  mm/page_alloc.c   | 74 +++++++++++++++++++----------------------------
>  3 files changed, 38 insertions(+), 49 deletions(-)

Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Thanks,
Zenghui

