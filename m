Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 081D9EFCE3D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 19:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062606B0005; Wed,  4 Mar 2026 14:32:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00FE56B0088; Wed,  4 Mar 2026 14:32:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33886B0089; Wed,  4 Mar 2026 14:32:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3BC96B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:32:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 242611C91F
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:32:18 +0000 (UTC)
X-FDA: 84509376756.26.476D480
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8759B140005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:32:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t+fioJu8;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772652736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbCqFJK4h0kGqfT0g9sfvBhgQ81LtEyUoWqXemhf4Ac=;
	b=H0fAzg7e0i1eu9f8qu/G0fqNgrYjtaVC4ARuOSLE15Ts1iAv9rM7zmfTQvfVKv9epDBKox
	peNwjSd221o+W+4V4Xr0ql0qCLC6JmlXMtIjCAglAkrGPTtaOS61LGKVqQYe8jZA7krN/t
	bItH6bPnlZxebmXIAa0vhXvWniK3gyA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772652736; a=rsa-sha256;
	cv=none;
	b=TBwIGsIslUtnumGzFx6ayRKvV60G7nuVjMInQZf6Cjnz6/LAHUj+d25vQ2PxFtvUAPbaXI
	oIDZM3UYSINsIGpHWfnNGc9p2DyNjM3y9qr1sOF1Qa5Uxuo7ojQOgcuQtV8B6f5Say1mRW
	H9jVE9Og7uSWGE6V99gGm4U1ElfwKEk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t+fioJu8;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E78CD600AE;
	Wed,  4 Mar 2026 19:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6284C4CEF7;
	Wed,  4 Mar 2026 19:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772652735;
	bh=jIK/V8edRWZRYZX6TpXv6QL2xOOo2prhEFwnEQ2oFhk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=t+fioJu8cxusW5HUmI+qRjVer4epSgbAu+rBGXpRInQe6TfEXb09oXPFbiPUj5xKS
	 AyF4hH3Gdf94hFzo5KivUMY3y3Ae1vtPdK1sLSK/iQuRJ/l88V42VdwIgUwN77Ohu0
	 Tu1K7aWgzXNUokRdPsu4wEMIc2wgGJe3dqpnzS8Ub38OSJWcsPKZ9/Npkb7NwOWtfR
	 EFU+1jk1Vj3zsKra5KIYZcLTwG78XkABxknw97k73WOEqsBYNHryYSHD8RrWXb5145
	 /oGI5DJqbpvdAUmmlAfE/MOIzW640nhQbw51LUu6InV/m1odD7OVHwYqzoq/Yk5ByT
	 +wPYqW7ZEYVzg==
Message-ID: <07fb6811-68fe-4cb9-95e5-ded58a082493@kernel.org>
Date: Wed, 4 Mar 2026 20:32:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm/mmu_notifier: Allow two-pass struct
 mmu_interval_notifiers
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton
 <akpm@linux-foundation.org>, Simona Vetter <simona.vetter@ffwll.ch>,
 Dave Airlie <airlied@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
References: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
 <20260303133409.11609-2-thomas.hellstrom@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260303133409.11609-2-thomas.hellstrom@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8759B140005
X-Stat-Signature: a4dfpems7dy1617jdzetdpss6ajqhjru
X-Rspam-User: 
X-HE-Tag: 1772652736-884998
X-HE-Meta: U2FsdGVkX1+R9qLRmkl+8gtVpBM2/rlwE0TO5hmIwZWwOIU+OJEdncucFYU63BaNbwvTk/XWeQha5JCIKsh9Ntoz5N3m6VKesHuo/HfpVqfiKAbaILu/fFfc9sxycujyotKsKqhSXEXrdTlMmRHM5wdWetepnO8gBNVaDGfHY+WBdQQh+6gLaHt+4lOUM4+v54anDbZJeRRuk05RHXiLiFgiXuXwZkj4LHzcpK6f0hr8npIdq4guj9KCcjsht/vVJbbMpjRLJ9z5YZmw+vGpXSKdvCjVqrsVHxi/cX6o/bLt4WnWct2OK6eT3NOe3birRmi3tX27FgTYztoDiFd9WAuQJVCcQZaaq9tz2Q5BrbXKCxObIC+YK5w98BuY3s7dWI3gWWZ66OrHBjwUfDnsGCYXnD03xaMu1pXvsaLb1efxBEKuDCmpKuDYKtNvPYVrvc432C9ajU4DMuzexGvJuz0OBF6/w1Y4esyWz0tugyByBpkKVopgeXalkMTUP4//gWSp3h5tfXmJk4hpuiAH5exJYtSlBz5WoTpeoYW1jx9KH/vHF+SLdy2PnVTfhKk/l6ElE8R0Ptr8YQlpO3HZ9mDsF2oz4h/Nd+nbqQTg9u8ix3ZjE8REfDAhlfrv35XLxVBYXUz5Sia6aDQyLkCOgpP+W2hTGxgTb9IgT4aTR+FZsdczTzVWaFDeAgw3ZVwCaX4rDlRrdrKuBOd+ADRMEQsjh/HyAg61P79PUsRFBTb2MQ8r1ZrnDrmIt3RZ7BpKopTw4ztEIxzXVACSQMRWy8SmRGXqKhqupY4ojxUl9AjHEtooigzpGA8RdeIxqV1SBDOl0Mm4Xq6xnymzhPlAo1YjlrD2yOuxcleYy3JAMhZi9F1e3H2U16MV6Q3jk6YK/zGECHnx3S/MqQqC0ZXOi1DHJLXGU3S5WeNBKBhclgvjQd4WUJLKg9211JZ3H1r82b/3gVpJ/nj244ZrSaT
 yGnl3m7P
 IF6fz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 14:34, Thomas Hellström wrote:
> GPU use-cases for mmu_interval_notifiers with hmm often involve
> starting a gpu operation and then waiting for it to complete.
> These operations are typically context preemption or TLB flushing.
> 
> With single-pass notifiers per GPU this doesn't scale in
> multi-gpu scenarios. In those scenarios we'd want to first start
> preemption- or TLB flushing on all GPUs and as a second pass wait
> for them to complete.
> 
> One can do this on per-driver basis multiplexing per-driver
> notifiers but that would mean sharing the notifier "user" lock
> across all GPUs and that doesn't scale well either, so adding support
> for multi-pass in the core appears to be the right choice.
> 
> Implement two-pass capability in the mmu_interval_notifier. Use a
> linked list for the final passes to minimize the impact for
> use-cases that don't need the multi-pass functionality by avoiding
> a second interval tree walk, and to be able to easily pass data
> between the two passes.

Please CC all maintainers+reviewers that MAINTAINERS recommends you to cc.

-- 
Cheers,

David

