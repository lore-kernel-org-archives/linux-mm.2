Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D93C4C54FCD
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 22:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7186B008C; Wed, 29 Jul 2026 18:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957DA6B0092; Wed, 29 Jul 2026 18:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E5A6B0093; Wed, 29 Jul 2026 18:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B2156B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 18:59:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F3441C110C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:59:03 +0000 (UTC)
X-FDA: 85043331366.29.6562E49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8DF0B1C0009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:59:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="KQH5/lG6";
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785365941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHp8vjg8AUcQ9RYWhSmkMpxvojYRQuqhX6Yx6R+1bvk=;
	b=d27+FVi7wiYnbG2lMKsNDa98UQ0RVdIP3SUrHPkWr2Ek74haggntJsqyP4qn+vGyy95Y+b
	NVH/mB+I86PJwurkH+dta5ddVwAKn1cPjcCp8Pj2wIB3KvoKem0Ydo4tIBKox9lxu0clK5
	wc52Eufv2gVSijmRp9kvgGPr07Kre1k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="KQH5/lG6";
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785365941;
	b=qbl+dI8+7tPcciCNGfPtfzVW/GQTQo51kNSqU27Gzt6XMTFM7CxGSY4qdgqaK79r8a4h52
	piurx3EOdH/1b+gm7pcT9rVsIZ9GC6RDbRoqLyYi2K0zA+0nxpPZTIdnzw2Q/ng2DX0zJn
	tYm6KW0pkM0IRRzRc+gCviCRGbBALmI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 34E0D406C0;
	Wed, 29 Jul 2026 22:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9661F000E9;
	Wed, 29 Jul 2026 22:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785365939;
	bh=xHp8vjg8AUcQ9RYWhSmkMpxvojYRQuqhX6Yx6R+1bvk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KQH5/lG6Mpu71bBDfjFDZgTI0KIL1OjfRfZugop8MUjzLILb6CG4pzwBJeQzMG+9B
	 QwhWncbq4rhhjQXDM2f7C7OuKxI0I/2B9c9xraILMqkyOQ+a3Wctt95vGZsXrYslhW
	 HAZtvKUgdgyR+Ln7MGPCMvkzOYN7dzCKYvltY34E=
Date: Wed, 29 Jul 2026 15:58:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com, nphamcs@gmail.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
Message-Id: <20260729155858.c7aabff48166a9bca4d68ac3@linux-foundation.org>
In-Reply-To: <20260729084206.77793-2-jiahao.kernel@gmail.com>
References: <20260729084206.77793-1-jiahao.kernel@gmail.com>
	<20260729084206.77793-2-jiahao.kernel@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8DF0B1C0009
X-Rspam-User: 
X-Stat-Signature: qssbaffy5aep41o4t4emiyr8i6d4a78p
X-Rspamd-Server: rspam04
X-HE-Tag: 1785365941-484326
X-HE-Meta: U2FsdGVkX19OovB7WAnYDCwGiBED8Z+I8WH5FnJzt0v915kpVna6uCeWiciPSp8YTSgxsMWGkNhsPfAeSUdCZMXbrDL2NOMlhh+06VG0Py7ijSF9ws/hQdbC2lchjnyWJNDpvkbjsdhKaeb+6y2aG3z+mU6w4Zm9Fj5YAwFyt9RmTR84VkmJBzMOffu11ClHPvztWfiEUlikmuwRQeoyO2hMXunQjM9IEyeBxOX3rUmLiMTpG1LHCe6KYJwmVsV01bcpQCkqw7NShfL9CbViMH4fPfh/c4b9MtNuOkSBZWraDPdTAiH3uBr+kwXVTdUOej2UO0PlG6UJezCXyBRPTV1nkScpVn3vTsDner2+OQaJg9gXBfvtec+DTkjCL9XCXb7k6ourK8GGJHSzmDKOU8pQ+ggo78t310ppwlzuJr9tURf97IIghnUCcCsfGtUGzXYms7vRLk3EJPzVhvy5YSk4oLGMdV7i3i4bbLX52/sYHzFV2gSID7U6/VVop3POh85O7Fn/nQcBpN+zMAYIwQh8tcUU5vh9Yd/gAlk/2LMEhz8q/nLbYK8rlC3Gjnwpy/r8Q0OKGUBUVxAQPWPmbCGao7WF5/KRU4BhXJwfMNYVhqs3ggGz9HIH0NcWpW06M/qftzCcuZa86N10laoLPziIrRz9UQiugaJRAYLbIZWvREnU2IdQ5VAtqRKSg5/R88sJ+TKCyA3HXht/F80eLcwceFm0TRAkOiNzb/j/n+XGS2vky22vOIJm4TDOa+Hb0H0V66B+8BLUh62kqkffJ+Qagmiq07XOGF0dAKxR4ruJzp4j5mcfSp4ZU1G9MXK/hiIno7RYa4xgPdDID7u6gNPY7uj41dTlCSpx4Frnjey74FtLQYwOqBbIPtlFbrBncwIPFFb3VLSXIFpmpGgSN6UMhJJhO8b7Q9vBf50TQx+hnuSvg0vSn/HcX3BFndi5XKjLBg8OmpkuKK3xW/3
 zZeu/ZWd
 SXK96mvbxBXopTFpnmxthJpcGebwhvkjS0Lh3Pol0UYHXv+y7hDR0xpLSYKOm6ig09qF6neCjRljKFY9Pkk6cTeFKwumnWSeF/8Ng/oxne32rLRUZ+kT4WaC5plxRaZ00FoTwoZFpJdyt89o8DY4OZnpyZuhubJvKdaXNi9yfufAh9aeHZqzFoj0B7sWp+UMDmS1jOq7r4xhQ8JNVxjVG4HUn8Mz57/U2WJm/X/5S62X95J5NSq8m5ZtPwhAptXJDl5KRdNFI2zhY8fUgDdh55uDlVFovYTYjdLAb3BPrcleQ0ICh08p9Lb/v/litAxFMiZYSDDbSi6A6jTNbJInoAS4ZePbX1guJngpiei4BXpA478vZ6z5dl/s7kgXpr4BAhLtSYkBYvfaxcUA9ZP6ckt/zONzQjRfTryxGt/zDwiv0o5l/uSy8F3DbLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Jul 2026 16:42:05 +0800 Hao Jia <jiahao.kernel@gmail.com> wrote:

> Zswap writeback when the global pool limit is hit fails when memory
> cgroup is disabled. The pool remains full until it is organically
> drained by swapins or memory freeing, leading to zswap store failures
> and pages bypassing getting written directly to the backing swap device,
> causing LRU inversion (hotter pages with higher fault latency).
> 
> This happens because mem_cgroup_iter() always returns NULL when
> memory cgroups are disabled. As a result, the global shrinker
> shrink_worker() repeatedly takes empty walks. After MAX_RECLAIM_RETRIES
> failed attempts, the worker gives up without writing back any pages.
> 
> Therefore, when memory cgroup is disabled, fall through with the !memcg
> branch and shrink the root memcg directly.
> 
> With memcg disabled, shrink_memcg() only returns -ENOENT when the root
> LRU is empty, which means the total pages are already below thr. In the
> absence of heavy concurrent zswap stores, the loop then safely bails out
> via the zswap_total_pages() <= thr check; otherwise, it will resume
> shrinking the memcg after processing the reschedule check. For any other
> return value from shrink_memcg(), the loop is guaranteed to terminate,
> either after MAX_RECLAIM_RETRIES failures or once the threshold is met.
> 
> Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
> Cc: stable@vger.kernel.org

How does this affect users?  What behavior do they observe when it
occurs?

> Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com

hm, that isn't really a bug report and doesn't answer the above
question.


AI review asked a couple of questions:
	https://sashiko.dev/#/patchset/20260729084206.77793-1-jiahao.kernel@gmail.com

Thanks.

