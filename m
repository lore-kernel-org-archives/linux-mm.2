Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3836E9D828
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 22:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23086B0088; Sun,  5 Apr 2026 18:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFAA96B0089; Sun,  5 Apr 2026 18:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37806B008A; Sun,  5 Apr 2026 18:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B6EDC6B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 18:51:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6631EB50FD
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 22:51:15 +0000 (UTC)
X-FDA: 84625999710.16.DFA897A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id CFBFE1C0003
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 22:51:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZMifXabe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775429473; a=rsa-sha256;
	cv=none;
	b=wjab4908A5ththUA9RZdeBTv+MWqcYbjmmB7ooE4M4iUf/BAwF9RWu2SQ5ihkVnkvS9Sdv
	46lBtXJ1cH74ywQFuGI4jumkUAcWmqxYXrpR9/30wW1H8K2TYnftE4Y84mUXAoJQNa/9PG
	gELBTeOZGzzQK2OdNp7f80HGTcfRmXI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZMifXabe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775429473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNxpOAGXoMfJKCkcwSESgtWHc+hGTRttwmMAHFPTbQA=;
	b=SZeXHO3si90rDImeZ5hO91XX2fo1LFUuylqiW7XsInu1L7tqwMXp5+w8US6/5iO72+QRcF
	OTJGXNY8Yo0j112rv7JQIjg9qWHPnMqAZUCP4TkBwCASqgBC7as0tsxf+hQ17gIL/4Dfga
	VkJdga0Swy3yBZe7krHpMD8mE1K0eJQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F36B9600AC;
	Sun,  5 Apr 2026 22:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DE5C116C6;
	Sun,  5 Apr 2026 22:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775429472;
	bh=icJXO+dguzj3tCxQ2UENNDdkRp09jjDpXJo1shy09+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMifXabezcDMLwlpRLIpwF7kD3ghLvBeRwLysSukzn3w8Spq7tYh9KsnafrMuoco3
	 Zg0EOqnG1ezOGuRQfMm1BGHQsMswc5/G0ToV35eDla+yV8cEbAxpjG200nJv5MVE41
	 lfMy8iZmq8GVPws+H/ltiNGg3IrJRx1otbOtyfzydaYPd8SqCqQUkbaa6ncA8p7aDu
	 5bD4gXcfeQvjtr1PiuTtFddG5aUyWvy88C1bvtqIVy6rNNGa8w26JAI44e3gA1iQA+
	 XcYbD9goI0DPTGt9hFJCkK42ZTzquF32DTAuz2mhyK9bKSuiz7IzaFVtSueY0tbSSJ
	 DzDSlhYJKuzhA==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [PATCH v6 0/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Sun,  5 Apr 2026 15:51:04 -0700
Message-ID: <20260405225104.76350-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405184247.2690-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CFBFE1C0003
X-Stat-Signature: nu5zh77aje1x4zfhmr1aqbyybnbzs389
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775429473-955795
X-HE-Meta: U2FsdGVkX1//gp6ehfugOva2BAoogPzECzy+H2hkV51T4VWE+hCtFkWFm4xqu994eOB4hXh8amfTVOZ00fboWq4wWn4ec+JjPCGg8qPuwuuapUcxC3MOijTmrHKdHWLkhvZyOwzxCodR7jgjYV4fe4eaMkZVc+XQilkxX42oJsbh9GgTw8eLWtFSP1Aj/g6gZcI0xcOBO6lrcAjayJuKNN21WPhJlGYL3W3q6714aXlTWi/wu1vMr/3eI2XguNQcbodyut5KoKiq+Cb9wEXZZdbUmBqZOMIq8/qjdpCTmD0LGVh3+Cn7Pz4gRF8bNBuQCZEih35S5pisXo/38IB6yQ9TpScg6nO2eJUSpwCgHyd0vXpNVKeJG7M6Sp9vdWC4jMiyYyMZO6ageKVArUdYSr5rjD/1sXgzi4jDM8IWgyJIHuvPJTh3koeU3TgZqXIBrnVEzmJJnr2c0P6+mc3rpzBTKA0eZOzKGp4m4bdTMbzyD3IZHyvS5gmhppIdvtQwigvnxDGO0VmqIrTH0Pugv6YbBFEuQp53EC9t/2F4eR3dNWs2+yKqGZI3GRsKKMQ+FtmO8JlmGp+kVYPST9p/Tz8YRYp4MsOeVbBqejy4xk3sc0WdrAlKgbzxQ2y04rOvGx1RUQOhaUSdf88HfmE1WVImFQAghabkCCP8nB9RxXytrbLjydfguWcxEqj/iEL8chTmiPu2esjm4/VNHipZvuL8Z4iDBEYAaxioKmS1eyDnh+m5K+VDLcuWnmDW/CLR7wrAA3JI09oQed+Zijl+jN5WIfCmQCcv9eXsMIam7Hswa2e+eOxSU2dAmlAo7Scos1EEjqDo6ax5wvf52ZyIak6PEojMOF5cJVHPUMNuBahgcBlmQHntUdkjq67Vda6gCqUGrHfMi9YVrY6fBHUSOlAZimwsrGHsIdCQYxm9S0h5HRy3n5z0Bf4AuH3Xxm5LJO5iRFQftrS85mtzKlH
 oiR+PQZ4
 2kIINO5cI8oCwsmEcEcvuyewmoKha35db/rgNCFWuxwQmWr3XVDQy+2+Cb8bSQpHGzFmdXI2GxKT4t9JCh3Sc0TJWdZxxwhnOXd50nEg8rAMTkqe4yukrUPfFzIQUP0M3XKs3yRUGiztR5pcLOD+gXqfQvoacrHKAGJQzmlJ9xd4XA+Oap7TZhhb5KS+Q8UlRdHwAXr07ojNWapIa1KT/rBAiFP0VLOfau+J7k+m2P+ttyebyiqyHBVz2tUvtdsZ4omSQgO85+zE69src5natQM5UpDrFE9qYQhYnAXeeTURrA/pChpxrs/VG5EwWLwOL9QIYZPb71HtyKD3k+98cMWUnhOa3ahHD6SOxDSXXiaODJWPAwEN6ZCExag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Ravi,

On Sun,  5 Apr 2026 11:42:46 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Changes since v5:
> =================
> https://lore.kernel.org/linux-mm/20260404012215.1539-1-ravis.opensrc@gmail.com/
> 
> - Rebased onto mm-new instead of damon/next for sashiko review

Thank you for doing this.  sashiko was able to review and find some good
points.  I shared the full review with my opinions as a reply to the patch 1.
Please check and reply.

> - Removed Reported-by/Closes tags per maintainer feedback (not needed
>   for bugs found before merge)
> 
> Changes since v4:
> =================
> https://lore.kernel.org/linux-mm/20260320190453.1430-1-ravis.opensrc@gmail.com/
> 
> - Fixed commit message description for DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP
>   per review feedback
> - Added clarifying comment for ops-common.h include (for damon_get_folio())
> - Fixed build error when CONFIG_DAMON_PADDR is disabled by adding
>   #ifdef CONFIG_DAMON_PADDR guards around functions using damon_get_folio()
> - Dropped RFC tag per maintainer feedback
> 
> This patch is based on top of mm-new.
> 
> Background and Motivation
> =========================
> 
> In heterogeneous memory systems, controlling memory distribution across
> NUMA nodes is essential for performance optimization. This patch enables
> system-wide page distribution with target-state goals such as "maintain
> 30% of scheme-eligible memory on CXL" using PA-mode DAMON schemes.
> 
> What These Metrics Measure
> ==========================
> 
> node_eligible_mem_bp:
>     scheme_eligible_bytes_on_node / total_scheme_eligible_bytes * 10000
> 
> node_ineligible_mem_bp:
>     (total - scheme_eligible_bytes_on_node) / total * 10000
> 
> These metrics are complementary: eligible_bp + ineligible_bp = 10000 bp.

As I mentioned on sashiko review, I now think node_ineligible_mem_bp is a
confusing name, and thinking a new name, maybe node_eligible_mem_bp_complement
is better.  Let's further discuss on sashiko review reply thread.

> 
> Two-Scheme Setup for Hot Page Distribution
> ==========================================
> 
> For maintaining hot memory on DRAM (node 0) and CXL (node 1) in a 7:3
> ratio:
> 
>     PUSH scheme: migrate_hot from node 0 -> node 1
>       goal: node_ineligible_mem_bp, nid=0, target=3000
>       "Move hot pages from DRAM to CXL if more than 70% of hot data is
>        in DRAM"
> 
>     PULL scheme: migrate_hot from node 1 -> node 0
>       goal: node_eligible_mem_bp, nid=0, target=7000
>       "Move hot pages from CXL to DRAM if less than 70% of hot data is
>        in DRAM"
> 
> The complementary goals create a feedback loop that converges to the
> target distribution.
> 
> Testing Results
> ===============
> 
> Functionally tested on a two-node heterogeneous memory system with DRAM
> (node 0) and CXL memory (node 1). A PUSH+PULL scheme configuration using
> migrate_hot actions was used to reach a target hot memory ratio between
> the two tiers. Testing used the TEMPORAL goal tuner available in
> damon/next and mm-unstable.
> 
> With the TEMPORAL tuner, the system converges quickly to the target
> distribution. The tuner drives esz to maximum when under goal and to
> zero once the goal is met, forming a simple on/off feedback loop that
> stabilizes at the desired ratio.
> 
> With the CONSIST tuner, the scheme still converges but more slowly, as
> it migrates and then throttles itself based on quota feedback. The time
> to reach the goal varies depending on workload intensity.
> 
> Note: These metrics work with both TEMPORAL and CONSIST goal tuners.
> 
> Ravi Jonnalagadda (1):
>   mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal
>     metrics
> 
>  include/linux/damon.h    |   6 ++
>  mm/damon/core.c          | 188 ++++++++++++++++++++++++++++++++++++---
>  mm/damon/sysfs-schemes.c |  12 +++
>  3 files changed, 192 insertions(+), 14 deletions(-)

Btw, having a cover letter for single patch looks odd.  Why don't you add this
cover letter to the patch's commit message?


Thanks,
SJ

[...]

