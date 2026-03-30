Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D89641061B20
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 21:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09A256B008A; Mon, 30 Mar 2026 17:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B3C6B0095; Mon, 30 Mar 2026 17:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2CA6B0096; Mon, 30 Mar 2026 17:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB7E96B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 17:46:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 80D4FE1175
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:46:44 +0000 (UTC)
X-FDA: 84604064328.12.30AB4B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id AE63814000A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:46:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kuGpwU1l;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774907202; a=rsa-sha256;
	cv=none;
	b=iuF7JeXSPPltmY/G+PkrciMBL3O6xWJsHh/nBp1N0kzajrD2eJlap7xPh5f3eiVLbF5IUl
	0f7DsRbIgMZ+8tHkEauIqb4rmz4D3+Hosscv8J7Qfdr2o3tsSockXsg7pUjkp+p80L0VbT
	Emke5htBxiM5J8sJN5Ty2sEB2RHKYOQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kuGpwU1l;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774907202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQ68BezDSy6uMOJzbqpvhdM82vUnSRCqZpxt+vfHYzY=;
	b=Ig3vHxTx5zuObw5HxYHAjL/KzgfV5lNHOTW9t8p9fscaTvMLfBYuz7TixROf6sKDavmZL9
	ESbDZQdQTFPn0J/txDDLj7WCzNQjvumvQ53UOemw3rDJi7YUDLvewYH83seDDsFv7h9rJ9
	KEmIjiSoBHZmhYi7sfbOZeTGGOkYmdM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A45F14426C;
	Mon, 30 Mar 2026 21:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEF4C4CEF7;
	Mon, 30 Mar 2026 21:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774907201;
	bh=p0Ky5bZRAoBg1rNqNR7UMmanDEON+/dh3M7UQ6lJ7YM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kuGpwU1lV3znQxQPn/hdTO0gUyfcsyLhmSKR+/kzzTKoUGn5AW51PjO513mXxYT/K
	 9lK9RDyMmonCpXhvg1RCFHAqpqn4UZ5TzwuQkwt0sxiWulN1rtenubUjzIgUMfrFu7
	 2uaX+DY3wS8tANv4nx/nj2bqComwmPJIuCiMP7WU=
Date: Mon, 30 Mar 2026 14:46:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Li <hao.li@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, david@kernel.org,
 osalvador@suse.de, vbabka@suse.cz, joshua.hahnjy@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
Message-Id: <20260330144640.161ca53e94b37b3252de2e95@linux-foundation.org>
In-Reply-To: <23feu42lqvc7iymgaxmnywea7c3qie5vmjm4aijbgdiazwvrcb@mmlxjowgtotv>
References: <20260330035941.518186-1-hao.li@linux.dev>
	<aco0MtqpysMXMZdy@hyeyoo>
	<23feu42lqvc7iymgaxmnywea7c3qie5vmjm4aijbgdiazwvrcb@mmlxjowgtotv>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ux8986pq9ib7d4djhpnhhiqok9uyorju
X-Rspamd-Queue-Id: AE63814000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774907202-283066
X-HE-Meta: U2FsdGVkX1+OGxZY6+RrNsJs0WLdyZDHcCJ5EDTj24qK0NAWu3Jf7/4STMFon3vSvCYzo2FWQwoDEj6RySzv9HE8qvvIGZWtKmAB2HSSYSoOurDfjipoJAa3lxwXxIAb/l0ko89cTPj5R5+OK5Sws8xfPOWGomODhWpwe8qu27vYkRzJCweUZU2QeBlWDVAo84o7lXwTurwXB/7kvDmW3hzGexyplJUFOdF5B0/y2O+zoMj+T14H/EXV1I9OzN6v60rjTT/GF2eEWVhFgDwyf1miHOu/B2OC19V1SVsON3DuOWrFs3nYltTXEvby2oM6wYx/POxqgRPAxhA5DTpijgrLOAnPoHBa0r2gIBm2rxfgQZYyBr5JTyc8wNhVx+gtaxwzHsAL1UgTGpo9MDi8TAnhevLxptsBKbQQpQdfaEdFoqOg3T9h/+P4516ZYL3u2kkK8WQn6xB2me8T6klCPPi3kR068D8j8R6fH3nNBxT9te0SLOp0dahWNb4YpTcFtcvJturmHanX0u0Nqj0h0GeqAh+xJyQWcut1Mu9jf4N6XxshnoumXi0HSqh9y2Oca8jehEzSzxYTu9IvS01OMv9UMGNonaVZwdP/sY1RMgM52cEWHa3YJP+BlEohvH2Sy7rS6BgwxrYjBPwgm4zdWv1xhTiVBFvRBetKVugnjgIfOm/SPb/KjuZKHZ3giXaQnLGks/qPcSyWu0KBJL+NeHBXElxANtUYpxT7zbyuMJYcw/pT1cf1h5WMd2a2pHT/W35S7K1Wl8mepgIlaI2aphXzmrqzaVMDQYpcdgTdfYaYiBZLggYfeECiP82dPzOUwBtgtK8j0HeqH5G1Ey2HDQWAnzdKC4DS+OaThNtRj3sSkTz92d74VpRC6Qx5e+xfaDeNpIBPmNvoWC/tskNFUGcBxFvhVZnq32F2ldi9OnMire1rh841u77NDNmTI+QyquGYnbiyM33JsdSKrv4
 rsjBdINJ
 WwHE5ESkJXu+l+7GBWFxdTuLFUo2by6culT2oPLuq1jH5nV+8zV8kvNszIT8yA1sh3T69q4fVbjdVtvb3e2GGOK0h7HVRXhd6EZkYpK6A0kPuGeMLTdsrDOmAjEEFtNGXU0j/JuAGe50+PrLgGoFDvup7DdXJXJajCF9AsCpuEzwGKrnqMbIUCcBC/S7dSSB1DzD6CFInN15OaJ6ndZ/0tlIKX1LdFyJa6A1H8GCEmCHW2U4Tx2NtEhz4qgZ0ce18Yv9t3TGH7snUdJb8Rt9j+4PrOgBf4F3wU1ljZNnRV5ggBzLzD68n1Su8vK9O3x+uKMmNhnSez3RHTz9lORnMw6VxdgBQCEGZXomy5p701hJco8+97oCYtK5dg+tprxTGoQrbrHfctWWFoyY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 17:34:21 +0800 Hao Li <hao.li@linux.dev> wrote:

> > > Current users that benefit include list_lru, zswap, nfsd filecache,
> > > hugetlb_cgroup, and has_normal_memory sysfs reporting.
> > > 
> > > Fixes: 8d2882a8edb8 ("mm,memory_hotplug: remove status_change_nid_normal and update documentation")
> > 
> > The Fixes: tag indeed looks correct to me.
> > 
> > By the way, MM needs an explicit Cc: stable@vger.kernel.org for backporting.
> > 
> > Since this commit was introduced in v6.17 and we have v6.18 as LTS,
> > this should to be backported to v6.18.
> 
> I had gone back and forth on whether to add the Cc tag, but I'm happy to
> include it now!

That's OK, I'm very cc:stable-vigilant. Thanks,  I'll get this upstreamed during
this -rc cycle.

I do like our cc:stable patches to include a clear description of the
userspace-visible impacts of the bug.  Two reasons:

- To explain to -stable maintainers why we're requesting the
  backport.  If they care.  Heck, and to explain to me why I'm doing
  this!

- To help out someone who is using an older kernel (there are many)
  who is dealing with a bug report.  They're looking at this changelog
  thinking "hm, I wonder if this patch will fix that bug".  Let's add a
  few words in there to help out with their pattern matching.

So, and not for the first time ;), what are the userspace-visible
runtime effects of this bug?


