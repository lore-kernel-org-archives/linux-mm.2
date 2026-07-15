Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B864C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 02:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4F26B008C; Tue, 14 Jul 2026 22:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4B26B0092; Tue, 14 Jul 2026 22:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2316B0093; Tue, 14 Jul 2026 22:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 852856B008C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:31:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E249C160595
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 02:31:33 +0000 (UTC)
X-FDA: 84989434866.30.03DD489
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 203ED80002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 02:31:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gmDU5hMl;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784082692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PETTDer1Lz0zU/rZ0npgKBBCQhBtVIsuhyXSioi/2do=;
	b=oLk6gh3fMPMnM4mpKACnOEKc2k+WULqzNmEXR7guQ79N+PmKDE+u1RMzyeF8SmF7IaRx9b
	zmfTh0gZA1CV83Ds0LZ9QqHLoWGOwDdsBGIogfzDfyH3coEHNpAZZT5V83aTXqGTOG2VGF
	I9hTg/8103X8dS6qS6kcwUiTBMxz5rE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gmDU5hMl;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784082692;
	b=8XCdpNNi7ieERq2wmNj1W+fYR0OtsVFfMvZT5XMauvNOurDXVjhJ+KdmgE/IpjngEQ1lPU
	XeFHYxprSlunhCZVjoz6KtUh5EGawCGYs0RfAzCo+7zXb699j/Ozu1ZWB88xtqqPej02AC
	PWM2jT1CbMZKnT+kf9BTygB0QPWFQow=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2CE940DE8;
	Wed, 15 Jul 2026 02:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1161F000E9;
	Wed, 15 Jul 2026 02:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784082690;
	bh=PETTDer1Lz0zU/rZ0npgKBBCQhBtVIsuhyXSioi/2do=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gmDU5hMllGW2Vs9zJT6ACfKxhTPgVM312oSQWjAaeSuMAu11MFBxD2dBVKEr/ZvS0
	 mBcnXHoIKVG5cZxnxxtz7zPZDw2ljoxQAvS2/d4zucxgKRoklEZHeMU4HO5XlaSyZZ
	 0qqN60qj59XccC9LcCGAx0O7ZpsA+Nl65N/zGeiU=
Date: Tue, 14 Jul 2026 19:31:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/zswap: Fix global shrinker when memory cgroup is
 disabled
Message-Id: <20260714193129.f81711f516504b659d544741@linux-foundation.org>
In-Reply-To: <CAO9r8zM5nzDqNcx5UoDgGexvR6jf8MmJV9SomM4AS7n-rZ2o5Q@mail.gmail.com>
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
	<20260714081510.16895-2-jiahao.kernel@gmail.com>
	<CAO9r8zM5nzDqNcx5UoDgGexvR6jf8MmJV9SomM4AS7n-rZ2o5Q@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1bbwdmibtbx33t9i4ce9zodckz6711iz
X-Rspamd-Queue-Id: 203ED80002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784082691-560499
X-HE-Meta: U2FsdGVkX1/78e1LgsPfteFtacHNx4LNuNQrPwGoGaaE3U8CtYbs4bxlfMgycKGlip47READTd2ja/1mef8/INOAUZmvPH4zefQQnmtqopQMnkGoxRi0nsVfjFPVZHDQTDnjCMFdCfPHzK3cfrxmva0UdK789lqQ/vCWEJZE2mg19t7sNdUg/pTiounWT8lsoxa7yJeRtlgoR7+uGGCjb1Lg8a4czQkemFQnCHYVTJ2OidUrq98aKJS3IkaSIeMvWQgsLBOF5r1J2Zaw6wx2OpCOqNw+ywLCP7CpgLUVMBf2v0RfhVPZfLqEX52VpmpSIkZHjRMNGt376hOSTWL86V6LxBq1hYuhwfzvnRyufANt9r4EeIXTJTqRzHIXf60iTcg/AWjNSq5h4KdvyFFVWpA47Vh/KjvNvVipBZ0K6t6qdRQnh926O+WBd+bX85+v9Gw3RI1CvTT+pEBhr16KVp2Ut3Es/8mlhV8hSfiCnADEd6jMVJJjNjZl4oFr6/m5C7ZH2o7pNgfsRWLlWTEeUKyUe4LHp++BiySH8DiHg5zi3sHQ6OowG7Dn55HDXsMfgtj45jnVIiqSt1wr2yv26wuSc3MIz/6/p/rIzPmdpUBn/2t26rkLYDBJZTLr3arOaQJ3+t5KYVRwUuAoYsWtFmpTS9UDGStU0TCsB6U6QFg7KTOnM5EcSXC4aMEnelK8iT3uLuDc4Tda/g5Kute03Id0CJPmlkNEAdw88WeIvd/z35bUJuI4BfT03Pcx90CGspKPCYK7fIV8HRIlRJc7RO+rnM7etNPYL7VnS5+FOBznki9fNk5wb9rpjdCugrwyMt3KDgfPZl1kl/7dybGK+YiacDe1CpxQM4bIFrPUo1MpAjk7IJQYuXjgcWziDfCrUTwPb81+s8DLBKT32LkuQtgmFi0EMkudPBEOK3QRclVJfBPM9xEzc+E84x72euBAxS10SjLlz0qzGFO1All
 IUh2W9FU
 nkTZh+iBR/s3MRE3W3KLDVUm8nYKE1O5PHnga/wfI4VPvVyIiUHH6xfwJWPaZ8p2dKKLy+4/LYwXKM2iZ1beavvP82UctKP9QFyedLm7FrEFNl5+AY7BltturuwQ3Z1dfAVM7tHxYpECp45h0Qsz4UXyALGKnrakJ90N1EBDCK+lbGotB7C3k8il2D+6XVXYJg3NfVulLtHkq/u8vZdsjrEcg6Jw6JNDhwIeWzRyckwyyLtgw/kgMMRoMiUUuuqDIwZgDoir33ClvJe3mkHpmNnzfHx4VR2p8C1HJ5nakHC3Tho6qkrGrZ8HbdtyURwNUMiQ2J1O4FmzfecDxIBp34rnSXnXFJQ1pR1Xudpbf90CfzDIq4tH7qeLKWCFO6Pxj6inIOHE2ZWzIClfLwmb4G5Sz9IB0FqtmQEpn6W1QzoaNoWfLISCm7x6TXhy54YD46bf/z0cBEjUEA1iTkeU0j2JALRSSQoRDBsYzrqsC89ofK10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 09:52:59 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> > When memory cgroup is disabled, mem_cgroup_iter() always returns NULL.
> > Therefore, the global shrinker shrink_worker() always takes the !memcg
> > branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply gives up,
> > so it fails to write back anything.
> >
> > Therefore, when memory cgroup is disabled, fall through with the !memcg
> > branch and shrink the root memcg directly.
> >
> > With memcg disabled, shrink_memcg() only returns -ENOENT when the root
> > LRU is empty, which means the total pages are already below thr. The
> > loop then safely bails out via the zswap_total_pages() <= thr check.
> > For any other return value from shrink_memcg(), the loop is guaranteed
> > to terminate, either after MAX_RECLAIM_RETRIES failures or once the
> > threshold is met.
> >
> > Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
> > Cc: stable@vger.kernel.org
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Acked-by: Nhat Pham <nphamcs@gmail.com>
> > Acked-by: Yosry Ahmed <yosry@kernel.org>
> > Reported-by: Yosry Ahmed <yosry@kernel.org>
> > Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com
> > Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> 
> Patch 2 doesn't really depend on this one, right?
> 
> If that's the case I think this can (and should be) picked up
> separately as a hotfix. Andrew, WDYT?

Please update the changelog to clearly describe the userspace-visible
effects of the bug, thanks.

Also, AI review has flagged several possible issues, all appear to be
serious:
	https://sashiko.dev/#/patchset/20260714081510.16895-1-jiahao.kernel@gmail.com

