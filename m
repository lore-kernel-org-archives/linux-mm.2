Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47B5C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 04:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5914E6B0088; Wed,  2 Sep 2026 00:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569136B0092; Wed,  2 Sep 2026 00:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47F196B0095; Wed,  2 Sep 2026 00:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1FF6A6B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:19:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8628F120728
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:19:07 +0000 (UTC)
X-FDA: 85167517134.17.2AFF864
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 03F9340006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:19:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zzzt1f9D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788322746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43iYBd+5tkBDbCmBuYzijZla7qQPqLGtI/WeTFqT7iY=;
	b=xZBqwr1SggexYLp4WbLu7RCe87ri+jJojXu0uG25JGtZ/Z3jvAHZtBDvhb9AqXWy84nVqL
	Ho1e8MBmoptmdO9LJkjnsPzCAtwptfzH44ADOqzmYMpym/npzZMGpa/NwGilZE76ceNdP1
	6XAY8OKpfCT/nqFcJ/j5pdbVHkMwvQU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zzzt1f9D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788322746;
	b=hQRwMkAstBve3txby1ACr/7hoDeWhLbwvccE4SEDI6ThoP59fmuwpBFo1B79sJymQq/iQi
	GKHGv3dIphc3blcv86Vo902Noxa+HrIkz9jhq9U0NTgt8CpeIYs1TGRPdnKMfz++H5V59T
	66ronT904cxy5jagB71gVclJySk48eg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75DF7600C8;
	Wed,  2 Sep 2026 04:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B1A1F000E9;
	Wed,  2 Sep 2026 04:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788322745;
	bh=43iYBd+5tkBDbCmBuYzijZla7qQPqLGtI/WeTFqT7iY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zzzt1f9DAyv6cX+5revKYxP0iKU1GMsyF+WqyOiJJfw4HO63HHnyvop1Xi473zRNH
	 5IH3H3WUyW8fUUc6Xhpo2bYOb041oJWG/v/zxO8firAifnSAjZfp8Rc50rUSHD2lCc
	 kLtvGfDK4vCxfomPFpezg1oF+GEb8cbxsjwL9rfXArJJT91CCusvHnXsKxaEzoUIlA
	 q1uGfV4StuTb5t1Uj0485XpcoYiNpIY9nZmxFHJ4trxhtxKk5R7xzr8s3ZeSqOuAlB
	 Hp4WyaJDa796rHz+KEQ3KZ7sfH9pQvziy6ylWwHLy0qOQsyIBYiBeIb4gvE8YaLIak
	 mNxrBkjeiLX8g==
Date: Wed, 2 Sep 2026 07:18:56 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
	balbirs@nvidia.com, bp@alien8.de, dave.hansen@linux.intel.com,
	david@kernel.org, kees@kernel.org, mingo@redhat.com,
	muchun.song@linux.dev, tglx@kernel.org, linux-arch@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v11 4/7] mm: extend the template fast path to zone-device
 compound tails
Message-ID: <apejsLXJGvV9sxOt@kernel.org>
References: <20260831111638.76012-1-lizhe.67@bytedance.com>
 <20260831111638.76012-5-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831111638.76012-5-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 03F9340006
X-Stat-Signature: noqdf55mhjzy5a9m48pmy4wy8dbm6bdw
X-Rspam-User: 
X-HE-Tag: 1788322745-891165
X-HE-Meta: U2FsdGVkX19I7S++lQIIwId1M3O5zwxno/kiWrUzrC2QRj+5TaUThWWiS7sBsZEqvXtcl0WH4yTIiY1Ejv/pAGVqOvPdz0FMoByuB8xjfQGb2vGxmXkLmx/fPftK3jmoOdkkuLwCiHLcCZFNtfzrzurq9xZl2m1/pxevAGLgDFWLVcNq+B/V2gJnc80iHPyDldZAYypIU8xzd4QoJ5Oochv5l6538Y1XpikG1XlfdzuEMpxnB8tGZe5eRAwJk8gFZRK8D/51mx0WgDsVRQp0fZ4dN88yILULqDZcljCOgcMA03K1/EHln9qafKmsPS4tHmh/43sSK7h1fR9JhC1jDOMOWUbECaM/UELoWlMg3MhFcEHMqineRnZbw2g6NUqiplXHgz0Png6a1ssXZtwbp+a4iyCKCKCnCPKL+PgVUKZIngJcx8yi3FICgp65+AgyMMC6TQSWtOmM+uMddQon/EebcGQaJQhBJc+QmJGYpnvxpGvWZJ+KEmeIP+c4BdTlB/jNhIt3ML9wq8TPmL6VzonAqgVD7JydrXsXJRU9AD+qh37FyjomP6m2utN+Rvjfa4Zbt3bWjnLVM/dgST7MyrsXtddKBEiL1N43uxEgBaPSK3aF+RW49U59MMrhHPwlwV4o+FvWuZ3Iy9YFsE11UC7vXzuwf+kmP9hkgKhA2yRMg2pRw+sXWEosQ0lubW3xJOteEW3qc4VBusZOIYzUd06vTMsqHfcx+qrc1fxuO+sUOo3uACLafYfnFUDjPLv05S62o+ArWthmsIVYGTpqmfOBselHMm95NVhGCz1VNuCWKLTLkPu9AfgwqY4MtPf1zt3uK4dHxHAVMGWVFCAyQ84mDoT0Hxe7c/PVESbmy7s4xM3lCQ2rUiqzaAU6hkCPojw8KoL2V7kyN3ZJj7kpWW3JFv/uei98t1fdq5lKT11p8wnS9yiHzDGZbvQGN7BBMScT4qbvpDpbutA5jG7
 gSLnmLEx
 oGffYr0XgnEjouUcc6jCeB/UPGdfd3OdHUw9gbG/EMO1uLJQtkG6YgnkzUVEfQ3Z1PGbyMufAo7JFPircN+H+AFSAxQMXUVeQ+j7t3JAeUEzdq2du9b8WDbQSSlLh2iMbcw1tf5bx+9/K7Q2mayYrpZNPhcp1LsVJTqV2UvwlBxLz5i2K4MKiIb2agal9sSCPU8aviXaSZBdkpSY1RV3RbrRAToq9fX2c9FljL1Q4mlNqvHxOALtNYvnNSQW3rtsP2qDb7h2HsPLgQ/W0/WVegSyaPwHwnMEG9mhJ5DdCT3iAfa8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 07:16:35PM +0800, Li Zhe wrote:
> The template fast path from the previous patch only accelerates head
> pages. Compound tails in memmap_init_compound() still go through the
> normal initialization path one by one.
> 
> Build separate head and tail templates and reuse one prepared tail
> template across the tail pages in a compound range. Head pages preserve
> the existing refcount policy, while compound tails always start with a
> refcount of 0 after prep_compound_tail().
> 
> This extends the template-copy fast path to pfns_per_compound > 1.
> Tail-page PFN-dependent fields are refreshed in the reusable tail
> template before each copy.
> 
> Do not keep a separate non-template fallback for compound tails either.
> These pages are still under memmap initialization, and the
> initialization-time refcount updates are not part of the observable
> lifetime of pages handed out later.
> 
> The impact is controlled for the same reason as for head pages. The
> first tail page still seeds the reusable tail template through the
> normal tail initialization sequence, and the copied tail pages have the
> same final initialized state except for the PFN-dependent fields
> refreshed before each copy.
> 
> Tested in a VM with a 100 GB devdax namespace (align=2097152) on Intel
> Ice Lake server. This test exercises the dax_pmem rebind path and
> measures memmap initialization latency.
> 
> Test procedure:
> Unbind and rebind the dax_pmem driver 30 times, collect memmap
> initialization time from the pr_debug() output of
> memmap_init_zone_device().
> 
> Base(v7.3-rc1):
>   Average of rebinds for dax_pmem driver: 191.20 ms
> 
> With this patch and its prerequisites applied:
>   Average of rebinds for dax_pmem driver: 176.87 ms
> 
> This reduces the average memmap initialization time measured during
> rebind from 191.20 ms to 176.87 ms, or about 7.5%.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/mm_init.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)

-- 
Sincerely yours,
Mike.

