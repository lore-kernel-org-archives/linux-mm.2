Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 777D2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 17:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C906B00F7; Mon, 29 Jun 2026 13:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517216B00F8; Mon, 29 Jun 2026 13:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DE036B00FA; Mon, 29 Jun 2026 13:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 106956B00F7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:59:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 805E34023F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:59:48 +0000 (UTC)
X-FDA: 84933713256.25.8A39169
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id A9C152000E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:59:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bkpD3wsE;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782755986;
	b=M/Mcf3v+6Ur6Keqm92gE+rwUVCE4gHOKwGZwkSKK7D0ETUt0thLB1O+0Etz20ALUgwkED9
	gYkCo57BURm/qgpxuGnKQpHdzwZauuhp75dK5FsOD6F6PMxDJa87WqFwvuiotOP8vSXtUO
	l7+It19EIaFtJgxn9jXQFChf4IkGy9s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782755986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h9Yhc8Z7dfCeWR08HYYvVeN4gNBQUwzZk9IGQ1OytMs=;
	b=AIkjiiddlSDehzxQwzga8mwbYT9p3aF/urB8yoL4hnEMLBTxDoVpXYA3ivigXM3yWsN6x7
	wLQjp8N6Nap2YxmWZplfPBSfNmgo+aeL/8Hz3cOD8yGrFvLi0nBQZ5R5Z/MORWQMOzu9qs
	/cx2W2tU7Y8qg2o1lw83caiHFn7seZQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bkpD3wsE;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c0cea8883so4900201cf.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782755986; x=1783360786; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h9Yhc8Z7dfCeWR08HYYvVeN4gNBQUwzZk9IGQ1OytMs=;
        b=bkpD3wsETs5L18KVT5mpsxncW2JwImuAne19dIgvHmChy6GGQJ9464b3tD9SrggzuN
         /BSxtnyd/RdGt9ztr06K1GN5beJI4lWzavVagNqAEvQ41FHpVNq4fww5syG1260sX+ea
         bVBWKU4oV1eM77gaPiq2ez1B/ryvQNmRB8yp1HOdxR0F2Co3bi4ZytgC5ZPCUrRZMA81
         PNsrob5FQ9tHpGTLO7+zJ6TUDU4VC3rXXFxqJVY//PTd8aLAlqdlFNDU+CBP86X9b/v7
         M8RJJtwiYgtBr2mowHKIvK0tvxUIYbyJlVzXmP3J4zJO48FZMHC5PfqagjQVUVRhT2xx
         5Ngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782755986; x=1783360786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h9Yhc8Z7dfCeWR08HYYvVeN4gNBQUwzZk9IGQ1OytMs=;
        b=nK5vYriwSr+XMw/ZO6/V4u5egi6nJLEq3RV8b0RoiO14VFIpm+mV1nU84baqgsGSTu
         GR/0pYdaGaSk/lSwCTCTB15wUJKnIVGa77+Lw9u7o+bE5GkJ3dmbbiZDVkHE9R0Gowtl
         t9Up0zSag6+XU5X9l38Qc7qXM1nCki+wDCakwCApi6fPeN5vUmAuDBXSzwZwrX3DKxDf
         NE5s0I2IHVuiyzBK/oup8ADKkCvmszfWBP0+BC8gR7QUvTwWKNsfG/JQHpIonOvanx+l
         X/9HhzOPWk1eaYYWVn26ef8ypd5nr1Fd9WVT0lUry4bPqAm5IuII67gd/ZCotDHArpN+
         fhDg==
X-Forwarded-Encrypted: i=1; AFNElJ+fmf5v3W/Xtj9oajoNgegkvHB2eY0TsndoKOqF4pG3ti6Vf6eU0n1HXUJ2g4dYrn2TjCicrYXObw==@kvack.org
X-Gm-Message-State: AOJu0Yyv+kwFaJistJpcPFBvE9cqLLhZ/+qW79llusf7vDRQps+Kvl8P
	f5pb+pmZCgqKlSc4CpM+kCb4eGqeOA9txjr+UFAhBlvpxFPYRQb/cNLz98cEgzoQvUY=
X-Gm-Gg: AfdE7clRyApIyUcqCif/T0uDhpmC77hpYwwF0tr6u/kx1Sc8pYE1rAs8HYM7iRzA0Po
	tQojLENE4F97+W7DzFTOonNRzv98brEFOjtjNWmWLo2p7nAwWf+yeXso/lKH3B+rImej2SgboZh
	3OlLqTPSRAP2qTH7xtPBrxJJ8pZ71pSNagdUHUBrPAmimM+FcNAXMrMF/LXoW+WIfGeNCwORmuM
	g7TL2DJOrcAWFyjZYmcOvAK0u+UwxaYyMapE/4Q/Jrl7SnHEFcHdjsZEWJJDnua5rnI3tkZSbk9
	WgtdA0YeoY5ghc6/Vp1l4slwzz4nPpXI38e54MFz+IGP8cYh8DsYVPaV4P+DNPddzqp+fUWtRrF
	Jq0u7rDV36/cyPzBUk5wIJM008lIq9FRv80u+KRnKrcCj4Onaro8gKTZ1/RHnn536hTyhaiP2JO
	zFVuybYRJBwfAk1jIBjtIp6W72EPNrXyk8fvd6Qjd5net8zMXSHmtvVY4WXgtFJTomDCZL
X-Received: by 2002:ac8:570d:0:b0:51a:8c86:bd2f with SMTP id d75a77b69052e-51c10e34decmr3389891cf.36.1782755985715;
        Mon, 29 Jun 2026 10:59:45 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c10a3307csm1345581cf.29.2026.06.29.10.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 10:59:45 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:59:41 -0400
From: Gregory Price <gourry@gourry.net>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <akKyjUbFg6ETqUao@gourry-fedora-PF4VCD3F>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629163337.1264881-1-hannes@cmpxchg.org>
X-Stat-Signature: bnuo3gw49bigika9u85xouhkb4fo8fsg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A9C152000E
X-HE-Tag: 1782755986-588344
X-HE-Meta: U2FsdGVkX1+YA6RVaAystTx4ojbsdZyqJpEwJrNa3+KKWAbbYsZ9R1GRQYW2Wt34WULr1o0FIaqr4T87/tmrsbPd1GNM5LuTShzjV85hMmII3qOJqW6LnvAWJ+B+fkR3YLtmegHx9uvHLP2hRjc3pkJgiLM2zGramKpgdfIPLKGnUsiw8xMoXMZBnyj4gMRJ3JThIZjIqM97Dp70exnvN+e7mq4F9h07WPPqWi69LStNvqYLiWhcVDC3HbZDAKv5bzlEqopx4atii4dRxmmf/5q/NTnT8rByGjls/bHH0dlor3gDgHboDNvOrAO8W4B3XZTLEyPE0LmQgDvqgImKbZ7NWOWhtJOUaKqjGikf2x/nteGMxB2O8K+cpjNx9Ox7d9tApaoVWXR2WdFjqvdiM1ZJJfhDbOLpJTLDTj57w2N9yPYcznsODHLQr15nSs/8gjoXfhbnHMyfaeHDLg5nJIBvcdgoDiW+70PHg1+n2K/P3lG4PEYE1nfSri0j2dV//Q22H0Bep1gSn6El+4mTe4Ht+sPiAvvocjHVo1e+As7mTDRZ3IJDgZSjP7ywlM6BZjem92OMKrAR9LEj4RmvsuRMZG2grADlIvzP11AeDKUdorjbmGjb8L9FB+yX4yIi6c5rccLbaQEFJrt33RyDZwUGh2yZtGjOrPY4hGWQIDfAELWbvaWnrJYfLqgpkEwPiKIPj0erTqdBeANIpO4jNH63bPImDmTMQCogx1DH4yJM6OlDc6W/HYJy+4P6G2kPz3Vy3dDFHUY5jT/7GMdYGl/1QPWvfW9oQ8sOhXqRC+wUGNs8XJ5KFeXkLnWOHdu5iQwLsGz3u6DfvtZxr7ACzp4rL4TM4fpdBM2EEBrdV7njPojz7VDSAnxpRKKoiqumNiqwXvFvBUM6NSVF+DCp1GSyIwinATIGSdMcYGOaQQJCkelNLHzCBEa6nldJ6DAvGilwPn7WxJFtQCIgbX1
 T9YJylKw
 BgGmKn8eHUb9rdbmW3WAj/h/Z9eyeRWZH2TMjr9+HH4WDBs8hsv5TDrg+Ah9lratA/2f0LkE+V52ieP2Zf/ir8rKY3ls3XoSm9seDSKvyMZ4KpUBTz8pHCl/ABwkL3FXaHwtsO2dtKGMl3VkQp5fYEiVuwsazxb7rM1PKqzCFjyyyPei0Wt0Qxh8KDIs2vjFUiUIGqlDCEmySDJ4hrQTTXZ0J3+J1cuiUjGVvutXFX+pT449WTNM08IHHv2JrV14cqWLUJBLU7LUsdjggH3dxSE7ABkMQ8kr4O6ofWg6iEMsG/dpIKQq2c+MT8aYfz4PRuUQ//Jko0MpAn4zH2NnFSdVkva1QZLY6GsF4hlbdAcDhLeuWi10SZoUpzoneOYoK9NY13UEbjGZNkvJ1O237q31WODgjTfVk63Z/kG0F/WQsIGsLDLblzKLjbbBd8sfVrbrQWLAi4glCIcdIhVnO3XpNrT0nIioirkSqUm2nttaIV1v5brBaPUel1eHP3MG+AF9jDu7n6zMxWz0T5K8t7wCQQjfpgu9d5i+vpBoXz8xnUR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 12:33:37PM -0400, Johannes Weiner wrote:
> Neha reports that mapped shmem aren't considered for NUMA balancing,
> noting convergence problems and bandwidth bottlenecking for cachelib
> based workloads on tiered memory systems.
> 
> Looking at the code and going through the git history, this doesn't
> actually seem intentional:
> 
> Commit fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault
> VMAs") added a vma_policy_mof() gate to task_numa_work() so VMAs whose
> policy lacks MPOL_F_MOF are skipped from NUMA balancing scans. The
> motivation was a real usecase: Oracle was pinning shared segments with
> mbind(MPOL_BIND) so trapping faults was both expensive and pointless.
> 
> The handling of NULL from vm_ops->get_policy, however, treated "user
> explicitly opted out" the same as "user never specified anything." For
> VMAs whose shared policy is absent - the common case for shmem - the
> scan was disabled too.
> 
> This issue is old. It probably hurts less in conventional NUMA. But it's
> very noticable on tiered systems, where entire tmpfs workingsets can get
> stuck on lower-bandwidth memory.
> 

Eugh.

Demotions don't care about mempolicy, so opting shmem out of NUMA
balancing and mbind'ing on a tiered system is just full sadness.

This is all just more evidence that demotion needs to be completely
redone, it's creating a mess of undefined behavior for memory placement.

> Fix this by having vma_policy_mof() use __get_vma_policy() directly, and
> thereby handle the fallback to task policy (-> preferred_node_policy()
> has MPOL_F_MOF per default). Every other consumer of vm_ops->get_policy
> already handles it this way, the scan-eligibility check was the outlier.
> 
> This preserves Mel's intended fix: don't scan stuff the user explicitly
> pinned. But allow default policy vmas to participate in balancing.
> 
> Reported-by: Neha Gholkar <nehagholkar@gmail.com>
> Tested-by: Neha Gholkar <nehagholkar@gmail.com>
> Fixes: fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault VMAs")
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


