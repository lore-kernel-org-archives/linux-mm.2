Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 939C61099B52
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 00:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA1B6B0092; Fri, 20 Mar 2026 20:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A726B0093; Fri, 20 Mar 2026 20:23:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0296B0095; Fri, 20 Mar 2026 20:23:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC96B6B0092
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:23:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79E40C02F0
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:23:16 +0000 (UTC)
X-FDA: 84568170792.26.7D3A9D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AF44740007
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:23:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E8YKLdyY;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774052594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Xv7Ih3hHaJwhAS3SL62+qYccrjz1JnG/Jq5JIt0p2c=;
	b=lxYOv8jRnnHYyiPT7cnnczvi9+TO3bNG0YDVZWWkfMXuK+tIHkZfsBrQrZlF+CH+UyXnax
	iH/dm0tNdrksGxts6dhq6xik1GghV8BcqSelnj6PFyEpkQjBsC6k2BHHnAy0yZGwK3h2sC
	shPEDFjyXi0X6y+9GeprudeHCFPuPqw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774052594; a=rsa-sha256;
	cv=none;
	b=WZYmnMtsJVjzBHvmeEVf6GbCc+MLyV4BxO2remqF82pcd9FI/MOfQRXTm/NqpcX7fNq5pZ
	+YgfObC58s28vQpy/6yAtnKMCo5sJWhZ4HFXDOGfRiGa0Mu8TrlI69fQ3gsgMnXNplz1UV
	eeZYPoGVnHc1K+zj38H7McotmR+9aLs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E8YKLdyY;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CB1D40A72;
	Sat, 21 Mar 2026 00:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB21C4CEF7;
	Sat, 21 Mar 2026 00:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774052593;
	bh=GOJeUyjjWVogE75PISrYKLd8uFw9FCzsAE2nXsMF4/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8YKLdyYGvJQV4eZNVaBQEK1dDC9jER7ugOH8Bh121qdvztgW1GYCjPUp6nYn/l+J
	 TsGH5gHnvqJ8+8BsLKPZ1Y4hKQtYexECZth4XtS9F5c2UfpZq1tYpVrUUfEAcaphQU
	 Q9oEBdj2aP3X1NV0ceoSqAjfxmYc/zwhQ5ioNcKPTXOYxXKAb3+WMm00P1Oh7QaOyY
	 sd62j/JdsEnhmYP7yv+Tc0Qqnzt+Mm6nwCiK+mVLRQRcxZ3U7P92umQO4xEp+WbVu8
	 EpcO7mBB3pPQwSAaVVmahkF46nW7uZnSx2v27DS6q1JLqv7mTI0jaBwHLxy0t0VZUz
	 JCiIR02Cia6fw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm/damon/ops-common: optimize damon_hot_score() using ilog2()
Date: Fri, 20 Mar 2026 17:23:10 -0700
Message-ID: <20260321002311.69009-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320192020.33004-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AF44740007
X-Stat-Signature: rsqhruwdod9fbzxhyuqxuiw3af3sehdq
X-Rspam-User: 
X-HE-Tag: 1774052594-865517
X-HE-Meta: U2FsdGVkX19NkDuwl0BQtcIgfoIJyQ/nGMPepAF89j2n9tDs0hXzxx8MnLWHUF7U34CrqpzsTkBYsGeijXUpwAwqmohY1FM0wlvc1ilVrm95BYRm/oc6aON0Q6ZhTfVzGvSj1sQFJ+zV7v6CZjmAsUeLSYDuDhpUTg1mltY5ZxhcoSg7+k+AOobtzz+nrSkW7+bGGdoTfgRysBCAKwBJBVc7YyNMcNWcw1noEfARLQuxxJntqyj+fkORVSyPf/6iJhlxXdm++gnVm1zE7dmwqcPO+IikoKULRjY+OgNzu2fBthbtN04ms8aIlgtrrVxG2sVj3t7Kkc7M4TmmMnYE0E5xe8AwHJKxRfRFnXAlh2yQxyiHH3BUTQFhLHR1cdB29G1rSY/IrChYJpKvW3pAROu6LKdUlQ/p8eLICkJg/l1q0Dk1vlR5FH6DXvJ80EaE0MG1pbDGc7FGP/uH/izw6kHG8SCO/5k1ZO7eZUIOru5HGWpVv33TnHYCrBWttWb+bDQQEdY6cKIsbGn38y6IjZ3SDqBuH99f1X+NpppbHEtUg19aFyqIzOOCKR5vvvxMuaMuwyC7m+8PMyLt8ETPYQfkhKP0buFT1hMp7pARgSFD4tY1Vc4aIuL9OjBUTMrnhmxVFRDZvX+pzXhwmuqeiz3PtsciBBQZ2T1BUy0jKa7r9Gq+MpbxTTckpc0aicBZn7/i382nPztBbb0sPjvN/CT/yu+E4Gu/WO3HNTX73GwEcVUb5Mwy+ecKPRryquuqeaedexlmeGG0aYEzv/2fSdLk1iML6GQRUKjkZuPPEZI3h8x1iYw/OxSo2qgYCrzY5K2RPobefACfxn4j5K7g2GFGXcHrcTdCbvRfWqOCvetN3a+zdEspvPaBzWHXqktcVHwbfoFmC4HokbgljMfd2n3yXScCQWDCcPUPCr2lSqeZFU9s/6yeUas/k0Xj5n5zQWowDBjeeuRxgNqKlil
 RSlJt4RW
 IQoNfbcb10ZlnLIoQTUV2KlAtXUtj86KnOcBOs2nFOzfn+7pAmF8JPbAAckF2+wyLbo2dVk1yl7M6YeMizlg9BGtSSg2qLB0dtrh1D0sjrCxUgZyQcDiCSriHofjP0T8QBtVl9S1snHpIW3HhZ4EvkAutIiDkl/7p+VSmKuHVh5ZwzFN6Hsiq6dpVyLnSJElyjOYspMmfnFCGCQUrAif00xPCraf4a3y1/YtFJaswWeWVoFHdubmerlhkdJI/TEmXkoBuu1zVaJAe8Hxf2PqyYA9w1sxqu60WneHs/tuQdU//bCsw41nTQEAaBtrN4pZ5MJCp2xj7j2Qb9oxclN45EgOtpJLCCAMZLRnR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liew,


When you send a new version of patches, please send those as new thread, rather
than as a reply to the previous version.

On Sat, 21 Mar 2026 03:20:20 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> The current implementation of damon_hot_score() uses a manual for-loop
> to calculate the value of 'age_in_log'. This can be efficiently replaced
> by ilog2(), which is semantically more appropriate for calculating the
> logarithmic value of age.
> 
> In a simulated-kernel-module performance test with 10,000,000 iterations,
> this optimization showed a significant reduction in latency (average
> latency reduced from ~12ns to ~1ns).
> 
> Test results from the simulated-kernel-module:
> - ilog2:
>     DAMON Perf Test: Starting 10000000 iterations
>     =============================================
>      Total Iterations : 10000000
>      Average Latency  : 1 ns
>      P95 Latency      : 41 ns
>      P99 Latency      : 41 ns
>     ---------------------------------------------
>      Range (ns)      | Count        | Percent
>     ---------------------------------------------
>      0-19            | 0            |      0%
>      20-39           | 2625000      |     26%
>      40-59           | 7374000      |     73%
>      60-79           | 0            |      0%
>      80-99           | 0            |      0%
>      100+            | 1000         |      0%
>     =============================================
> 
> - for-loop:
>     DAMON Perf Test: Starting 10000000 iterations
>     =============================================
>      Total Iterations : 10000000
>      Average Latency  : 12 ns
>      P95 Latency      : 51 ns
>      P99 Latency      : 60 ns
>     ---------------------------------------------
>      Range (ns)      | Count        | Percent
>     ---------------------------------------------
>      0-19            | 0            |      0%
>      20-39           | 0            |      0%
>      40-59           | 9862000      |     98%
>      60-79           | 135000       |      1%
>      80-99           | 1000         |      0%
>      100+            | 2000         |      0%
>     =============================================

Nice!

> 
> Full raw benchmark results can be found at [1].
> 
> [1] https://github.com/aethernet65535/damon-hot-score-fls-optimize/tree/master/result-raw
> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> Changes from v1:
> - Replace fls() with ilog2() per SeongJae Park's suggestion for better
>   semantic clarity.
> - Move performance benchmark results into the commit message and add 
>   comparison between for-loop and ilog2.

As I mentioned at the beginning, please send new versions as new thread from
the next time.  And, in the case, consider adding a link to the previous
versions.

[1] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

