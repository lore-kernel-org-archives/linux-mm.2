Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF207C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB93F6B0098; Thu,  6 Aug 2026 16:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69D26B0099; Thu,  6 Aug 2026 16:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95B696B009D; Thu,  6 Aug 2026 16:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 732FE6B0098
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:03:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B029A1559
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:03:43 +0000 (UTC)
X-FDA: 85071919926.16.8618B46
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0D02E20006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:03:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wDDwWbNA;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786046621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPKg8QMwwWLCGGZZI8KkM6QbnBXtsMGOQLkRtcQ339w=;
	b=FfTZHcmC541Vjwh5cw0xyRAeqy3geoRnQMNZwGJttf1GoULhbGkbCF85YJyGgt+sMLG88v
	rdIPkWRxUDvZj6TZ9kSg5GGJhD2Yl6qfaV9UNkFTlxUjOrGYC4iLjYqkq6Bcp6wu4gboiR
	OdskWQtKf+w9AA8GRRPe7ysHZd3epfc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wDDwWbNA;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786046621;
	b=nWj8IzOzdxDf+U1zCtkkEEK350sw1uESzYQ+AzSluHSd1HJ7OYBy30xuC5pKaIjoZWRzR6
	jHDZVFDtIRQEhwwe0hiPzR/Q6XK/E+Epnh1cYbBAQXTPw8pM4TxmM8mU0pdOH5BClJWvys
	cYS7ER4Cj4NMeV99v6RiJUFP82ydcqI=
Date: Thu, 6 Aug 2026 13:03:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786046616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UPKg8QMwwWLCGGZZI8KkM6QbnBXtsMGOQLkRtcQ339w=;
	b=wDDwWbNAa/jORPyFOSxyRdpfHizF+0Hq9u+chRZy2pz09OrGkjgSLKIAC5yIJDqC7rJapQ
	muXt42AKEYpyLrxuoz86VHcRPezv78Dki35zG4NGfMzirTy28sWPUQlOct1iy3f4YH8YlN
	ZFkho8hYtKdGRRqu2a43OkGgNktuh/s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Karl Erik Hofseth <karl.e.hofseth@opoint.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] memcg: keep folio's objcg same as its node
Message-ID: <anToOuVZ-xF6onE6@linux.dev>
References: <20260806165813.2526415-1-shakeel.butt@linux.dev>
 <anTPPr5hVV4aQLRD@cmpxchg.org>
 <anTfChWlK998-7sY@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anTfChWlK998-7sY@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0D02E20006
X-Stat-Signature: 7mhbzuizy4wtcospdwc3zb8hb5d7h8h9
X-HE-Tag: 1786046619-460778
X-HE-Meta: U2FsdGVkX1+u5Rcp+J7a5AvDFAg0sWIO2nhWeq2mGkl9dmNJAaCWgxUI7YgcjAtlOPMu80R7tZW61dh7PrCmLSvX9l8dgL0SolHl7EGc5sqjaNWQ4dSXoWqTvFRanO2VTh8cOLjiHEiu+McCGGFJ1T7mqxXg6DJGwgrwfJSyE2RSZ1/OFFUsM3j/w3lNoeoiG865auuTdtR896z4QytzDCzLXeB8QwtLT5Ym6Q+PFAIvgeeMduf6GwL/DLalSydxSq/ZJbLbg4rya4Ku8DaEtcM7BQ6qe19S3uctrj+ya/rA8L8sm68PA9UBOObRr8CgSVdMXDV2odnZNJBfas7kDwl6xpkz07ZX7OnHftrbP1HFg9icBIODDnC1JaHxYaAPxJIosox4gHlANuyNbf8tuyiEFKZu5cH84wCj0D1ED7+376npVzaTZp5MwLFRUkMJhkMCCd5Ym1N/j+RM08IadZvhb/SonAPloAciRlQOPW5dYxbKw+l+Q0fEKXB+UNyFWPh59Eg7pQz6Eukt44hZAZ4468GbkaJTJNMx4HUKVf0T3S4Xap7cjOB3hUyr/CelWvvOh7RPAMwV/flLKI4wod+uZJcw1llac/3cmt3VVxhB50sWaFuOWgcJ16YJL5UCuC+YLQDpwFoL+1Emp7HnRJEL/t+hboeKwzHqqiRMygFQhMRMpO/gyl3fnXPfcdUciol8VxxgPAGGGxWMfCR931Y+M9fXCLX46c5OGmyU6QGUneOkkhDMNgvQVuiPHRXSYXkYoRBr9AiS4Cgo8kZR10SgACY8hnhQ2NtAkntpbhmsGT/8GhhDB8JdDuvxLdLxesY/ColtdrQ9Gt7LTlOkgRgQs5uKrUbSyH9rYgbW5825JT5u7NN2EbV5uHbTxc2v7XS4o/jFYD/DKYOa54WIqNGD7jo99TfT1VyjfsMHgDXZdcLFCuZJ2lYeqyNOOKFlOzacz6toAmuv8hDzsVo
 FRFK3tCQ
 Kt8AIzGptItIIH/lEN5swGEsdW5mQOKS7d9m4zi+3w0Hv8HZrG4ze3APjJewlOG9EKi8fEWxb3JGtriXeXMAh12vr1ocrPmx7bPQ36w7E46yJRVYskXJ5Jp2JIa+n/03KCBCtAYWTS9RjI8oW/AR5phkwEM2j0RTpiKyh/RfWEkDdExuaEHDrIV/nk1ukXhMmaPRoP2WjckIaEpC9BC2PqNMJIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 03:22:50PM -0400, Johannes Weiner wrote:
> Hm, it's still not quite right.
> 
> When there is a root mismatch, we cannot fall back to committing the
> old objcg. That would reintroduce Karl's issue. Not as broadly as
> before, but can still happen if the memcg tree died up to the root.
> 
> So we have to commit to the new objcg, always.
> 
> What obj_cgroup_is_root() then comes down to is whether uncharge will
> balance the page counters or not.
> 
> mem_cgroup_replace_folio() gets a new charge for the new page. We can
> just conditionalize that right away on whether the new objcg will
> actually uncharge.
> 
> mem_cgroup_migrate() currently trades the charge, but that won't work
> if the new objcg is root and won't uncharge. So we have to settle it
> right then and there.
> 
> This?

Thanks a lot Johannes, this looks much better. I will incorporate this and run
through the reproducer before sending out the v3.


