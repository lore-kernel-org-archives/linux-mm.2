Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC46D68BED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 08:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33546B008C; Thu, 18 Dec 2025 03:09:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07026B0092; Thu, 18 Dec 2025 03:09:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E8F6B0093; Thu, 18 Dec 2025 03:09:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 860EA6B008C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:09:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4CF48BE140
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:09:01 +0000 (UTC)
X-FDA: 84231866082.20.90BC4E6
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4EFEC4000D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:08:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JiH8P5e5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766045339; a=rsa-sha256;
	cv=none;
	b=2Ff0r5lBsUkywdlkJzvQh3VUdlxEkCh0Hz+0ESFyjwWuvXc6LyddUBXx4qJ3SEJ2nyt/cC
	Eg4FMXQ3pOVziV/L75dP3jzxZimYSD/TkBv5chIIFBkn/3KrEN4kqLrLeXr7L5EucvVDzl
	ebAZhhatNHOjcRnPrEjd5/8GF0Vn5Sw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JiH8P5e5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766045339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zx7UqAOuwin0dqb+uy4QaGD9HzyrCUqCBoMKpn3Ho6w=;
	b=KPkGg2/+DVOUmWg8RQk9GzRAGBu27HkAf9Hxbsy1Qs1vriR8biAbEDOiUX5bePBSt9aQRp
	4QOgXARKgT8UQIu2L7YMO0KBz8sscA+nNw5Rp307q99jdc3Af69OMTdWH/BDUlHqaq7WvN
	UQI9FfW3kKpE2ps4jQzHxYSoIBVh41Y=
Date: Thu, 18 Dec 2025 00:08:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766045337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zx7UqAOuwin0dqb+uy4QaGD9HzyrCUqCBoMKpn3Ho6w=;
	b=JiH8P5e584SNbUt7OVXwb/8flTqfcGsam0ywhkxnuG8Skmw1Ha937jhOGrr7hS/+/h4ula
	fCxVEaMVnD/4MeQCtT/TFmx852t/ilSQFihzt/Z91TbiR8ba4C75cxf4FX+l1lgaXVwECl
	PvbesD5wl2qYAbJ2Xx7rBwZg0snDaPU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dipendra Khadka <kdipendra88@gmail.com>
Cc: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev
Subject: Re: [PATCH] mm/memcg: reorder retry checks for clarity in
 try_charge_memcg
Message-ID: <gktuqmvopl7pgbcaw3rwiq77vb2zguae3jfdxmwfgtetf3twu4@gcb5bubhxq64>
References: <hibelxfvkdvm6b2a6vmgdmwcne6e2z2hrshshacepgedduyejn@7kfdegbmwyvs>
 <20251218073613.5145-1-kdipendra88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251218073613.5145-1-kdipendra88@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4EFEC4000D
X-Stat-Signature: 3rb7sw35r3cxytkjbztwtuprzro67r7u
X-Rspam-User: 
X-HE-Tag: 1766045339-321200
X-HE-Meta: U2FsdGVkX1921M6h3aAkQndCK1J+ADLNNt4QgJP07H2nWmtr0hMotUU6XqkB5cTxtIisl0ExrNnw4xlFExVE+DqIWNkTi1vZDrx+AOC0Ec5ShrC856alas0ETdKGV9Z62Lem1QwBF+Fqqqq4E9k19DYd+d/A5jqS58ohy88aQe9quWpF9GKTbW4tl0jBNIAlISISPUefh+HFvYcyeLgu8tcRiVWcZLsC6k79xiZoeAyCcblylTMJW7ApJRc0JynSIKkn8NZT2cQaq8+ac7gPHTZicbgRk/fmaGqgP61xqeTttN8yGIv5o5xq3YlhK/NyQCUIaiDbIa7f4tHCISPcfDlNv1VAmQUh+36p97hq/JbH0gMVBY2ANHU2EwWRIuEjAkBEPC63H7Huh0aWCFak34Vdzoqf6lieLf8K5LG0ZaNnmJruahe0bakURFAj/yYMeucMvCuT2wXlhxb/E2PY/zzfre9+mTOCr+JJjI7SMIIZifcRxBSYyzTL268bBlIOpqU1vqrJctIUL2sNzhhXxXZqW8++0bmE8Tbtx5JVpfTC3UCzFkXtka0JPB+MtMk3gwTnvQ9XmQIEcT1ATAZpOwIjEG1Qw1sWrk7he5FHn2E9qli50qj5OuK1ra5cJAUnL+Ccdavx0L3FIwz6hmX6VwZhiyCOua1slMGt7SLq+ulrIHeSWTYNLSPGX2ZOLcgPtRrOpDxyPVcGJ+QXGs+vtP3OffxPbaev2Q6KLSMyNOcIo7Gcs6X1AZeIMQaYqaH0Jv7Mjb15//HhDKuIrkGd15hdEhXU8fXQ1wY+GXvUPo+qR0Nm0OG6mxcBpLBdK51i2POIccoQETOIVOgqjC4wP5KTsG4yu5Yjxnatq5yNQHIYluuB3o0z9EU3jKHHWfWqNUEC3wy/MeLGp6nY4+6W5OEU2swnI6HM2TcP0eyYuaNYypI2MYjzytTcXu57TwH88vixWl+9xMtdKfHGbJl
 EQad923H
 sbNyLLwF0etctKcc2zFFOowXsOmdndudQylUOKESM/kIp9csZQ2VrpQCp4H1WvI5EmbtCA/+o3v393VZokIV++r3WEpGaiWBm6A5SHAhOuHke1Kl+FdNXOXf1ceyp5fX8BVVeWY6wXzyuTIklWBdHouXDR7FzCeQNgT9UB1UcKdYdOfgAzh3UaTVCiq52zBTQmzyXhwNMQeHzGnDZoOu+VSwb2kGzHLdtg7xoGeq3k7ZuScf1kkVVeLFsJ5GdR9MYEKmFHne+F3U62LN+mUSwjZ01vA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This feels like AI generated responses and giving me the impression that
you are not really understanding what you have written here.

On Thu, Dec 18, 2025 at 07:36:13AM +0000, Dipendra Khadka wrote:
> > Why hopeless?
> 
> Because in this specific path the allocating task is already the OOM
> victim (TIF_MEMDIE set). Any reclaim attempt performed by that task is
> unlikely to make progress for its own allocation, since the kernel has
> already decided that freeing this task’s memory is the resolution
> mechanism. Reclaim may free some pages globally, but the victim itself
> will still be exiting shortly, making retries for its own allocation
> non-actionable.

Beside its own allocation, these retries also keep the usage of the
container below its limit. Under extreme condition we allow allocations
above the limit. Here we are failing the charge request. Will we start
seeing more ENOMEM in the exit path? Do you have a call stack where such
retries are happening?

> 
> > Why optimize for this case?
> 
> I agree this is a narrow case, but it is also a delicate one.

How is it a delicate one and what exactly delicate mean here?

> The
> motivation is not performance in the general sense, but avoiding extra
> complexity and repeated reclaim attempts in a code path that is already
> operating under exceptional conditions. The early exit reduces retry
> churn for a task that is guaranteed to terminate, without affecting
> non-victim allocators.
> 
> > Since oom_reaper will reap the memory of the killed process, do we
> > really care about if killed process is delayed a bit due to reclaim?
> 
> Not strongly from a functional standpoint. The concern is more about
> control flow clarity and avoiding unnecessary reclaim loops while the
> task is already in a terminal state. I agree that this is not a
> correctness issue by itself, but rather an attempt to avoid redundant
> work in an already resolved situation.

How is it a resolved situation? The dying process is in reclaim due to
limit.

> 
> > How is this relevant here?
> 
> This was meant to explain why exiting early does not introduce new
> failure modes for the victim task.

More chances of ENOMEMs?

> Even if the victim still performs
> allocations briefly, the slowpath mechanisms 

What slowpath mechanisms?

> already allow limited
> forward progress. I agree this does not directly justify the reordering
> by itself.
> 
> > Same, how is this relevant to victim safety?
> 
> Same answer here — these mechanisms ensure that the victim does not
> regress functionally if retries are skipped,

How GFP_NOFAIL doing force charge is relevant to the case you are trying
to optimize?


