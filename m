Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B316ECA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 14:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888436B008C; Thu,  1 Oct 2026 10:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85FEA6B0092; Thu,  1 Oct 2026 10:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776676B0093; Thu,  1 Oct 2026 10:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 594276B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:27:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9FA0140426
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:27:25 +0000 (UTC)
X-FDA: 85274285250.07.9D5081E
Received: from mta1.migadu.com (out-92.mta1.migadu.com [95.215.58.92])
	by imf24.hostedemail.com (Postfix) with ESMTP id 68F7B180013
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:27:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LVTy4xtf;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.92 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790864843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJMXlOX6G72KgzwR6NBXyCt54iCm9KoR+tZW/E7WXfU=;
	b=2P+Wb2t7E2o4H/kWaef2KW/ziLNm+NgZiyyzHx7Rp838tFVzvBcYICHeyNPTXjrgZAB290
	l21iYq+5c23vi7/vu+bRO+zG1erexv99W8/R/aVkMXhclWRqY2yTP7SKWfdzQMz5lOKKua
	GrqFwnk+DdhzlDHweyQg/EzKVwTySuU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LVTy4xtf;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.92 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790864843;
	b=LY4zWV/AyH2AI4SWU1swGRrQj4+aOPB3fs5uh/sCgMoooBkh4ZyJCdd/V+Oeb4Nq/ikXrQ
	hbBCaqEQj2poB0nh6kV+VwK3zpRvxolV2os/X0UrDK1SzfgIk6CSnAKgIfHtBHSJ656RiN
	JjgwF3J2JXUg7qi2ExmLAYcYeblT5S8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LJMXlOX6G72KgzwR6NBXyCt54iCm9KoR+tZW/E7WXfU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790864841; v=1; x=1791469641;
 b=LVTy4xtfopRyUlAYWDLVtKCMj+4EgWXO1nQ0fG46RqRJUjp7fIqMLXmqhthN8jMJf1/v7612
 u9rC6eAzFrlpDUf1pKXbolfDhx9//AQxU/kwLWzht8cVvDU7g1MdZm+gCxheL1w846vXQGwKpW2
 4KX1fUZwDb+3jUNdDVZ1rTH4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 37d698b651d6e08d;
	Thu, 01 Oct 2026 14:27:21 +0000
X-Mizu-Trace-ID: 37d698b651d6e08d
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: maddy@linux.ibm.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 3/6] mm/sparse-vmemmap: drop Device DAX-specific population path
Date: Thu,  1 Oct 2026 22:27:14 +0800
Message-ID: <20261001142714.17172-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260929053231.66085-4-songmuchun@bytedance.com>
References: <20260929053231.66085-4-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68F7B180013
X-Stat-Signature: awaa54wpn1tw5yri8baufchauph43egq
X-HE-Tag: 1790864843-793782
X-HE-Meta: U2FsdGVkX188oaNFAb251c2sca9vM/S/I+LxRdZVjg+UuvP8il24aMN0P83gt+MORsg2oF1nQSLcphzi2xDXZb73jZk6wDvFS7hEWMe3bqt8RoyvWrwYPTXkU02gVdlHaB7yqCjopGOEn3kge1WSng2TpyPPC6M9/7p+e0sSOc0n6sf5fCfLBmD24K1cEptQhn3AO2Z1ETBoQX78MimOJNiC9EEr8d8ZnYR3eioK2HOBQGXG4mPv5Z6Av6SG8JrDiecUvJ35OCLEWcsb+LrDJqSey9uIwLUkvjCKVb/ygz67MXpmD8MYAhG9nILtn26AuNp1DjRHp/CRQIckonV9EgN0h8ffQjfk4/JqZzhmKudwkz5ZXMTEfC63MO1hSt9w4gqnInmuoVfobTy/Rypo0KXvxtpQ9x2/cPdAKSDy7EG3HisjA7gwAIyyrhmo+RBGKGBE3ccLtJCKlmAU+RL23gfDLa7Y9jGQfv8lt1u0BWYKmpa0zYRDUtLZ5z9j6Kh42E9k0z7QEr62Z0MLbOH3tw6rxg2x0m9cAPqFqHyWkZHMAA82trmtRSDjZH9O3E0NtoXVOKc9+QlN2zlXe/18MsKuAwnX+cfYyZIwBz+qYGa+6Z/uKwNeGuhFOwRWPH8AH9BEgW27UGoaBRrI/tsM//Hk87tj1NW6qXUw5i9xRTAjYau4lRqhs42bnxVJxoVJRJqqseXKJfna1aw4dEek/aYATFY2nOP2ELjABcjNSAsb9rcAUhi98S911RTyDWeXM1aP5yQMoI/RK0Tfh2aJl5DT0zXYyARnTQBetFWcD+I3rhQY+ejMetONF1FhQrZ5q2cXVKVy9qqhZQ5NSinTIZc+wvId8B28k/q63qclgs1X35f/DGb3AJMKvGjBMTq+z/KBhyjObtKhFJU9uH8bN681aIOE18qZtUCVghgdl/6oXRYgMYLepefxcQCYJTWdEbA7AHNyghuCs1vREef
 u0Q2rEUo
 1O7LOfnqE+OIVOPovuL4uDxRG4VeEUXNl+hD4wVQJ8eNhzwVZbIIAgghRVPZtZ+jPFBEfsGWPRJDR0zIO/9371/ow//zc2pUTNzv/mGL4zcF/SkAwqhc/3KYBZPXC1mOCFPNXQD6Za4J+eM1IHKWz4iTwt+B7BdDfpvftLog5w/9VPtgJp48TLALXwH2ZtY03M+QSz+jClFB1qZ2TDMxjBsyN0oxrnkgIPoSdZuqAjwSzEulMvY0jbbGoHIxRLB7rVEBM/YSfKR4uMlGDbznxhUScFpXIGsUhLpUrY79x5JfQm5lV6ImnIMtXdZ9sVpeK2YRnb7q9L0C4IPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 29, 2026 at 01:32:28PM +0800, Muchun Song wrote:
>The common vmemmap path selects the shared page for optimized mappings
>itself, so Device DAX no longer needs vmemmap_populate_compound_pages()
>to find a shared tail page and pass its backing PFN through the generic
>population helpers.
>
>Remove the Device DAX-specific population path and let section memmap
>population always use vmemmap_populate(). The powerpc retains an
>architecture-specific compound-page implementation, so select it directly
>from radix__vmemmap_populate() for optimizable sections.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>Acked-by: Qi Zheng <qi.zheng@linux.dev>
>---

LGTM! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

