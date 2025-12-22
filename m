Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BB7E6ADF9
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 21:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35B976B0005; Mon, 22 Dec 2025 16:18:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 309206B0089; Mon, 22 Dec 2025 16:18:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B336B008A; Mon, 22 Dec 2025 16:18:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CCBC6B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 16:18:23 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF508B8724
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:18:22 +0000 (UTC)
X-FDA: 84248370444.21.A25CBDA
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id B964040015
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:18:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XXc8sb9N;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766438300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AaxUjlZxSdQz9/5dRF6Cc68Fz36EXnwL9Uc3LhEeHkM=;
	b=oxVx9GR1hmcDChx/l+voj6advur8GSiRTXyVrcVHLrHOelj/ilfts27d7nu5WIAHhcoZAv
	L+QNEgpHrlVmJwPS3nV6vCXfPF7O3nAagbGNlBfKBCFHTLXX+I3PFKchgWuIR+mWPHh+O4
	uWnnl6NxUg/hdcg+mQZCnG6n0xg8DR4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XXc8sb9N;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766438300; a=rsa-sha256;
	cv=none;
	b=LEHDmLj8XoJjA+e9NQnMpCAgVaiY0xTGZtf0Q0ntk6yNUmSdcV/N7LkIc6miRNEGMMbk0c
	6C4cSZa7hkincIDa6AvNd5rX3r6+t1SsABnCs45b0GIBJH9+usKugErx7AzZ6upacEgQ8N
	Skx2gz5l44w94XHh4/fuo3i4orQFbg0=
Date: Mon, 22 Dec 2025 13:18:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766438298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AaxUjlZxSdQz9/5dRF6Cc68Fz36EXnwL9Uc3LhEeHkM=;
	b=XXc8sb9NyRg7njft/+mJ44wRJyMaMGjFqvXQSSqukW9hsuDuYBVGMhKnxkNAc3w+MM3YzI
	E3f3eHGP7RLPm2E+XMINKkwPm6wtt35Meyhyh572Afp0YFmi1ks3ZYGHfyQpwtensNeX4Y
	+kwmwRnsCwqmV6Orlgi6NIpWqTdZitU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, hannes@cmpxchg.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, zhengqi.arch@bytedance.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	lujialin4@huawei.com, zhongjinji@honor.com
Subject: Re: [PATCH -next 1/5] mm/mglru: use mem_cgroup_iter for global
 reclaim
Message-ID: <c4fjngkwbjlfnbjl5merldg5k2fiu43p46osagmy3ibr62cgxh@oesgt5l35kns>
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
 <20251209012557.1949239-2-chenridong@huaweicloud.com>
 <gkudpvytcc3aa5yjaigwtkyyyglmvnnqngrexfuqiv2mzxj5cn@e7rezszexd7l>
 <702b6c0b-5e65-4f55-9a2f-4d07c3a84e39@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <702b6c0b-5e65-4f55-9a2f-4d07c3a84e39@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: 49zbcxgn6hx49ibw9bfodisc1utkzbba
X-Rspam-User: 
X-Rspamd-Queue-Id: B964040015
X-HE-Tag: 1766438300-446140
X-HE-Meta: U2FsdGVkX18ewp74RE5rAYCQ1al1EFdBDtt4PQbyRNsO1Yhzitcuv+DaFD6oKefuTcWXz6okWwZ5oTLmZx+FBZRVXUHu/lzILx2cBNUL9KihiWXKjOE1PtyLY44RH9uAr8mr0ByZ7k/f4hx6N6hvBZHRnC7TCFDuUbd2BrE8Tzk2CQPvDmCLZrX+oCFQ5kn5IrphZtRFfyyn7QyrKuUtH5AD0UybPEmySojcwlh6Mw88JPU9v+kTLfhEA6jZuwwUzC9Ud7m2lqfGfyRrQUhfkxZesIJVgmkmc/xXF9uk06qr5/aLJCXZCU4klb1zSVIK0gfuh3KldH3WfkBYoIcHtAKd8CXFGqQ8nyme4ALd+x8KCNvk7gXjEpMc82U2xVz6KCYQtVY/Az7FLYpQt9HapO9VasYrkkOrjLMW6E7k3wbcOLXbYCD0/mpuGkRu0Qqrnkulw0sdkBiczlv87oeb0fNIIVgLq4pKjrRFkwVZyu2LS/4bmuf3qndUaz8CecL/z3489rxI0KTTh8KxVU3W1/2vGoeSOVl0mGb+2NIKQaJhrhhYvtg7J3QQqerwoX0vUE1jyMqItxSwGAoM3zqsmb46EP9EwOp149sRdBh5WNnmW4SIloc4BZA5T1VtzTM5o83pr19ajDqxL1TS8iKAx6wyIYW6SrUk2W/n032WP2WW0vMCPF/7Z9X9eEX+ZAH4kE+LnDb6yePFUZDe7dxDD/0wXqwCOx34goFR4xEuIX5tVZmx2uCnEEF5mASeU5v1ac/hJorbv7OrCH1ilXtZeDaSeud7y5x5/Ff4wWUEhohsQ1Ij5e2e/Ak14gJaMeeI+M3m2kgTYALRDK63riS5KYvQhS26lT1iZQT5fDQXEfk27kpstiNGL1yR6V1Ax4/HuUT7nNq0rVaM8H7oqc5ggHF8+5mWpOZjCe76vT7j9MARfSpiMIVUsE2F4lnngDQuHKya58xE6h9l9gDXg8G
 dRHYEUeU
 3t+239oT8LVQWhfbqQqGTG6svH0+IT5AfXNuDmd0ecBOJF/3OxWWc7GFIKiLEoV97OIPdt3X98W9c/mNbvbcNJYGv2R1mhikyIX3U/98qwmc3j5g7LYqTqpKBoLWfbqePv2dhFCpCpTIE7cRSq+BDaw/Du7rJcbOniqxlCg0go16oRZuL10KEDUHnBbamfgpvJzQVw2JpgUCas2JpgWRZc/hdGgeYFdou5/VojHKADg6BQs5JKepLKvuAWWxEBTdXUqlExGBYi0Flu21uIFx9rM5/Vw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 03:27:26PM +0800, Chen Ridong wrote:
> 
[...]
> 
> >> -		if (should_abort_scan(lruvec, sc))
> >> +		if (should_abort_scan(lruvec, sc)) {
> >> +			if (cookie)
> >> +				mem_cgroup_iter_break(target, memcg);
> >>  			break;
> > 
> > This seems buggy as we may break the loop without calling
> > mem_cgroup_iter_break(). I think for kswapd the cookie will be NULL and
> > if should_abort_scan() returns true, we will break the loop without
> > calling mem_cgroup_iter_break() and will leak a reference to memcg.
> > 
> 
> Thank you for catching that—my mistake.
> 
> This also brings up another point: In kswapd, the traditional LRU iterates through all memcgs, but
> stops for the generational LRU (GENLRU) when should_abort_scan is met (i.e., enough pages are
> reclaimed or the watermark is satisfied). Shouldn't both behave consistently?
> 
> Perhaps we should add should_abort_scan(lruvec, sc) in shrink_node_memcgs for the traditional LRU as
> well?

We definitely should discuss about should_abort_scan() for traditional
reclaim but to keep things simple, let's do that after this series. For
now, follow Johannes' suggestion of lru_gen_should_abort_scan().

