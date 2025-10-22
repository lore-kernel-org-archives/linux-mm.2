Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56B7ACCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 11:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9844E8E0010; Wed, 22 Oct 2025 07:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934AF8E0002; Wed, 22 Oct 2025 07:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824F68E0010; Wed, 22 Oct 2025 07:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E35E8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:15:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D0D4C0800
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:15:36 +0000 (UTC)
X-FDA: 84025494672.12.14740DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9B6141A0007
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:15:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ou7Su6GC;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761131734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVvBSM1LcDG3909yzsvtel5Vl2sXioEXEa1Acm5waqo=;
	b=6oW4jpQyhuGFjNiNeBFcbjddO/pq2HwYg4JejLlJuQNHCmGeK+gfHa5cYtRibpG85QGfoD
	UMlHQyyhoSteF9VRpbiVb9Y0mUmmN0SKil55XQZ56e+Gc7PFLmrqy+JsNfxX7sEDGhqqlh
	7YaGH5HtzOw0DRT3eu/PiUA9wlqBRqw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ou7Su6GC;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761131734; a=rsa-sha256;
	cv=none;
	b=OaJwrDb0n0ftA1S+zrQNU2byVx8iZd4qA7KflZ2GBJdsUSZqlQcdWp6fSbCZypm1U3VanG
	8rWZCeGnvTD1hwLcUaefYSk8hgd+zgtKNFy5NEIJlACyXyEy1py5XBeJ0mXp3YXH/8tF1u
	4BH2e2qoV/WqinwwKrkvqu9BPYHsdy8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B92D34460C;
	Wed, 22 Oct 2025 11:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9767EC4CEE7;
	Wed, 22 Oct 2025 11:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761131733;
	bh=QJH5l7/QfRaBN4zYaquzGrr8H9aALZ24iuSHMe+PgVA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ou7Su6GC0HgcXE91A7ybE8rVrAL/ds7lBgRUPKFdr8xf8W+ro3p5Rf0JTKAuV/7pM
	 tav/40d80NMF8uKrh1eiYH4tUq9156kNTU+Zhe4c/4v8n76653PSTWQPQwsSJAAfdH
	 n+ikFBTgaZHETW3x/XzFgaNcAq4+I8uZk5lVqZ5FVFr5JvgAdDBhGohZqXw6BJKvWx
	 cUUMNRCLxMQJc5eIcMOsfGzUj3u+E/590ZdrPxib7whbxMhb3GKMN4G4uGXbfqKcYA
	 RqdfcClr06xWf6PGxHO6MenJi67hnRqmmGPrGpglmeCA1YstxY1n4HfRCZnZWkHIMd
	 QDw1JYkizpolQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org
Subject: Re: [PATCHv7 5/7] kho: don't unpreserve memory during abort
In-Reply-To: <20251022005719.3670224-6-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 21 Oct 2025 20:57:17 -0400")
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
	<20251022005719.3670224-6-pasha.tatashin@soleen.com>
Date: Wed, 22 Oct 2025 13:15:30 +0200
Message-ID: <mafs0a51jfar1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9B6141A0007
X-Stat-Signature: nh4woucdtp6xj9w5m1s5zdrfsangjr8u
X-Rspam-User: 
X-HE-Tag: 1761131734-510759
X-HE-Meta: U2FsdGVkX18F6dMoyiDPLJvY4hK/uUxN9rHabSqCBzNkYEjvKA5QpRSxYdjZYFVkBN+X+ftcHv/APMcV4tqTPcxSAE20X6I50vEl3IPh6OwXAbP/BP5K0VfyjtL3Cpn3Nx2fTnK/M/TmsRkysgOOc4CXCKMQRQBYN4kpmYJSP65gBiMIqHLyLs+mumDdoOn5DAXlee7IkR88+0qpelCaphh/uZBeBLUS//BQBIikDNd429rtumqTQ3Kkdap1dH0V7QcZP3It15ZX+juOcH77kdg3/I8tczIU9TpRs2srEkIUH6SFP70K6sD60tsjqQD+MJEcFfHracgL9VUiT39BYT5HDt4kP4EZrdj1FYR0SNvAJ2JAXCnrADr54s0K8VqMHXLOhlx/JY8DwQ+6UWX7X0QYGPTJVJvjezSsn72Lhmuu+y4jQEcLGYQj2DiYyj4caDeIrfxA8c3tM80bYnre+lU5ANQOL/y9sZEgGuolbgcJZbfq/dqbFIvgRJY07UeWRN6gyX8igAhgNSvN0+sxoCWmRcXCPGLWp9arNdpMtYgGISq/P7S2Y8CPYyNqbecCe+NDtvvhfBd3eYZNvJF9EnT6c9X8ifMEX/aQmyg+aGtsI3X4sW3VDv1aZDgylSAF6KHISU9iV+EqYxMVc9oLq7yOHS13lFxXkYSBAPC6A5Il5Fsi5xUpOjZMTVexznHsPKqlVdaYtaqw39A5Ng8bAEIcsyIxfJOgd5HB82fgp1Ym9jwJiPCShaVCXrO84RnqCxlXgIZq7VgqQqsarFGhk1U3d9peCFE/RXbydZcZ93l9vlQ/3PZAsDGdYSTQRUdwfC3cy1RNxQpKmAhbYxaU3NAPUi/v0X9adyOB/KPUlSkGFXkl/0DwT4vj5TIsQCrxwAse0L+aIumUqjElpWJrVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21 2025, Pasha Tatashin wrote:

> KHO allows clients to preserve memory regions at any point before the
> KHO state is finalized. The finalization process itself involves KHO
> performing its own actions, such as serializing the overall
> preserved memory map.
>
> If this finalization process is aborted, the current implementation
> destroys KHO's internal memory tracking structures
> (`kho_out.ser.track.orders`). This behavior effectively unpreserves
> all memory from KHO's perspective, regardless of whether those
> preservations were made by clients before the finalization attempt
> or by KHO itself during finalization.
>
> This premature unpreservation is incorrect. An abort of the
> finalization process should only undo actions taken by KHO as part of
> that specific finalization attempt. Individual memory regions
> preserved by clients prior to finalization should remain preserved,
> as their lifecycle is managed by the clients themselves. These
> clients might still need to call kho_unpreserve_folio() or
> kho_unpreserve_phys() based on their own logic, even after a KHO
> finalization attempt is aborted.

I think you also need to update test_kho and reserve_mem to do this
since right now they assume all memory gets unpreserved on failure.

>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
[...]

-- 
Regards,
Pratyush Yadav

