Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B2D2CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5FB6B0005; Mon, 25 May 2026 15:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57DA06B0088; Mon, 25 May 2026 15:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493336B008A; Mon, 25 May 2026 15:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 398966B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:24:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB53F1201CC
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:24:27 +0000 (UTC)
X-FDA: 84806918574.20.0804498
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 17CB2120009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:24:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZSOLjv27;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779737066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TKlA8hHoa2n8yz5CbnFJQhuo/fhrP2H+HP0o5NvJ06o=;
	b=1854WhT+7m+p+Wx1rqlfF+EWGHdFP5N0SYuvmEGbkxXWnSU62w2sYX5hq2Ekjil7EzxlMU
	Dai4/G9YpwQypzNF/eGjJl/e6aqNwcgigGwfcJvOPD54RqSR5zYJSIm3/7U1Gs+uc2j6bj
	Nk3iOmTGiVh0b3E43M8mJa9KXQy6rSk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZSOLjv27;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779737066; a=rsa-sha256;
	cv=none;
	b=Hl3yV1wcZPwTbaHahJNktbG2YXs5500KCWTDAryNRmGqga9aldoPXl7qEnXhcEvcr3wt7q
	niJtF41en7LHxiEIrV2xVEZTro5yj7kKvstTGueK2udYbSQSr8xkGTZfMZFVqCc32fNyLW
	1SvWMvMJ5l5/9pEixs0uzh/AFbkEDk0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1248E43D1C;
	Mon, 25 May 2026 19:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BFA1F000E9;
	Mon, 25 May 2026 19:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779737064;
	bh=TKlA8hHoa2n8yz5CbnFJQhuo/fhrP2H+HP0o5NvJ06o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZSOLjv27xFVHWtdplcli0bikszi0EUeOxKRdE571PnbtV9XARQw9qYmlFe7KL5bC2
	 BUMtvdE9gNFsrYp6BbrufSWmyVk0KyNvCM6yIj7EqmjW1n8enj+GCpqrwhCvgBovSb
	 tp+n3yQ8qWwvRW/hG5UskkdhuIcF9u3q7Z29rKrU=
Date: Mon, 25 May 2026 12:24:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com, nphamcs@gmail.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v2 0/4] mm/zswap: Implement per-cgroup proactive
 writeback
Message-Id: <20260525122424.3b2818f06832d9d55da8d69b@linux-foundation.org>
In-Reply-To: <20260525122242.36127-1-jiahao.kernel@gmail.com>
References: <20260525122242.36127-1-jiahao.kernel@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 17CB2120009
X-Stat-Signature: oi9mk19xraouzm946881p4sbiqcfdgm8
X-HE-Tag: 1779737065-553321
X-HE-Meta: U2FsdGVkX18yTUs3DUcd1/iEgKKHUDugaTo5EA6DBYhNL8vZigpAwtLnzoelBywJwNOS7OM/IL0jSpcfy3kuhtA4DzcAr3QeLNZXg/UeOE9AJLQnQHX5jRVKycsy98zLzN/qVB/LMIx4ZqgLne156IWzPMNQwyY20cR2R5atL8Av6J7o4OCbCRgOnlHFjmXMPkPLS7wYtQZZrm9HICPdk1JLttBNb/c99v3ZVQadomvRoqjMIVW8ZDvIrX8qd4qQ5WTcdqk6hSAgC0E6foPqAtUGgOWTIbOoh83yOQ12DtLCcmiP4lPQUMPmW0fjk2yIqy91a4jyAMg5BTxT0eIVMtbMRcby2j+/VR5g0LrteTA5KIocN8IC0zzwo0xumH4H6qgN1M66rBlcVU4VXaf/l1w5Mrx4fSiZET80rqWUto09XYNaCjPe9GIsxNHMohJOxrTeNx+g72p3z0/0ibKbiYfEKY3NyDIE+O1tUlh50+qOttIytp6tKVp/xT4L5BlbUMwvPvRJNE8Oxc3nvuXa43vlPAzUEG7LWbMfdm5OLGkooEb1HyghGaSc4lfO1lshbLWdmuBdZSowtq5ctYwFLVeY8ZqKX1ePJUmAHXnXTtC8/yRe3Y0Mzd2NXC/hdfcsAA0i6uvdB07/X7AhZJp6178A3wF+a3z00y0XTsqytPdMl+gIcAICjCmfnkX2HPZV2voZpdGsnzogWPI/TaAWQ5IK+im/0Rs7cJFmtw8amPJZpJqE9wz3+2YMHqYBy09LCjHIj9TlLqcaDVQE4ktySgRFq6U/cpVea6huyqW8dR0FS/Rqu0/8ZsyxetiMQqxQOX7owvQeMTGz48WWo8UlZ42HIIKAoRGGa3G7XZuCLJHn63NO4vu4iE3tunMFw1oGU/Fat2DTmmckSPW742qLX2e+soLj0qVl/lBm9vf0T29d/HdFaWNZoXHlHJoK0XyhdRiJ+ikpMF9ZBBlrd5M
 d4xIzfpG
 qIPbgsDRYOk98fMjKASthy/cp3ET3BhADJNXhX/mjCM5/agdZUcjZpJgj2Xnzz5iE6g3QKRSaTXaiNvDC3htcrnu6MaWKyGvBKsw3gs4RE5POjnFC3cOpUTUWgeJcCv4ZVmhUzqnkYwKz2Hf25hcKslL3XOJTzaPFrV7PuhWiYUFOgoK0MTlxpf48i94o52gmVKIQPdpEJkp5lTz5ELZCQqf9YQUqia839WwdMGV2V7lTHsbgj38MXGduFfQpiAv5+2X3YDqgnGRdOUjPyRSDkdcR91xa/ne58964sNCs3CFcUo0uICZoT5T8P3p/Y/3bl3B4hlz3IwoeT6jnoSui7MHVOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 20:22:38 +0800 Hao Jia <jiahao.kernel@gmail.com> wrote:

> Zswap currently writes back pages to backing swap reactively, triggered
> either by the shrinker or by the pool reaching its size limit. Although
> proactive memory reclaim can automatically write back a portion of zswap
> pages via the shrinker, it cannot explicitly control the amount of
> writeback for a specific memory cgroup. Moreover, proactive memory reclaim
> may not always be triggered during a steady state.
> 
> In certain scenarios, it is desirable to trigger writeback in advance to
> free up memory. For example, users may want to prepare for an upcoming
> memory-intensive workload by flushing cold memory to the backing storage
> when the system is relatively idle.
> 
> This patch series introduces a "zswap_writeback_only" key to memory.reclaim
> cgroup interface, allowing users to proactively write back cold compressed
> pages from zswap to the backing swap device. When specified, this key
> bypasses standard memory reclaim and exclusively performs proactive zswap
> writeback up to the requested budget. If omitted, the default reclaim
> behavior remains unchanged.

Thanks.  AI review found a few things to complain about, one of them
described as "preexisting".


