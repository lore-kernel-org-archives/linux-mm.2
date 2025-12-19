Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0DE4D711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 516FA6B0088; Thu, 18 Dec 2025 19:39:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F82C6B0089; Thu, 18 Dec 2025 19:39:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425806B008A; Thu, 18 Dec 2025 19:39:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FE6C6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:39:59 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD673135D83
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:39:58 +0000 (UTC)
X-FDA: 84234363276.18.AED6CA0
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id E7CDF40010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:39:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=naB8jumT;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766104797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DX8UZ9nAjSqZr1ylGrCQ7YdlWA+s06UqA90SNHMJ9o4=;
	b=zg/rwBod77dsZF4+xabL7bSTPmBXnoEgt/G/s3u2yc3jOl+J1rKNoZhaXIFA6PoQSpy8rT
	URZV+cNYWwMIPiQN5SwQAtJkGwXLtPWuVQVlvs/VSI65vecKotla4578nCiAq8dHxNzuK5
	8vMF7MUlEcO6qUMZHtT0ZKLsVrj8reg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=naB8jumT;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766104797; a=rsa-sha256;
	cv=none;
	b=oXh0a1XybJKr/LQbx42msmsLFO39r2QDp0l8jYJzXGq32hCGnqgqfvM1ODXiOoGzB6luSc
	x2yNRPicpqD+C+Q6aCmgbJrWp88Pj8ubwlGU7Ygel7eL8LJrh5rWRxPPeeVUsrojJGr9Ng
	epFuSeVPeITQOBpeDrtHa5t2Ihq0qnI=
Date: Thu, 18 Dec 2025 16:39:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766104789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DX8UZ9nAjSqZr1ylGrCQ7YdlWA+s06UqA90SNHMJ9o4=;
	b=naB8jumT44LZK8RrrvHQrofXxVtFDl6w0O38ksVxFmDDkt3uWkYR5RnXqq0O8aw+O6Po2a
	1KLukNm6ce93Yv0Imv09yBb6tljuVv+ORKra++jbAEfcpRek6Kc9BdW4HzHzTmEPaaGqj9
	NuApjAjaedRV17OClIdlSz7/dYgz2+c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 07/28] mm: memcontrol: return root object cgroup for
 root memory cgroup
Message-ID: <rpr65jo6oa6aismuhkhimj5ne3gquvo7rpok5qnd5jif5iqbya@uar7qwaox7fc>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <3e454b151f3926dbd67d5df6dc2b129edd927101.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e454b151f3926dbd67d5df6dc2b129edd927101.1765956025.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7CDF40010
X-Stat-Signature: qr74hhduhcxx3rypsdgj47uaoad3e6jr
X-HE-Tag: 1766104796-639520
X-HE-Meta: U2FsdGVkX18xpuwx3szHlIcCV7WHv/6NjNSLoaMvzq+N6xE8YKN7LG1tNAgXLQHiF1aM5divuq9mwFUeL5o5v6dUBmjbDMhR6iW/nJkD5vqhsCH5RRsna7WnHKWbc7M6qJccAC/t6GR4WwX/EIiwr6qsdLDyAolQV2yJeZK3c/96TPXA2LLJKAz2wWYr15RgA28AqJ8pufxbD2gh+zA0yA/Zuu02A70zIono84LrhW56KjnhbrqT/LrV1Mgxk68b1N+FaJI6hM0L1IONDqrt4Skg+bQXhcGRzUXr7G0dqgPeTfz1z3htYr7S7Yq+xy+fFL9Esv6iS5K5JkMpJglG4mYg3hPU1QAcp21cq93RnHv5qe2+yO0n/n5PDS92/l/tVqMp71X36GfWugtPnbaCxG+37Bpya7/8gUQvRC1oSiTb8dAzD+CdCHsL13ogWlgMAJ9K2i2FrrpYFME2ljDCa0D7LRftoKgshC+/P6xw0IiK/sPouJn7BjyksCSXs1/AAT+aunwamaO5GVAcHl9GjNuYtCj0jV3KQdE/JlrLicsPuvWLxYObYsgpCT9SoHcns692KwpBfXr6biqyik510SyMsVXlt+aWW13cR3iPrtiFCGgeIrT51Skd8Q9d4FhZq4Bm/es2ZU8TKZL6tyUznNGMHODnMJfBb/Scf9KSApFu7VaSfZZKq+r85PH3361d+xflWLV2Rq4VedwA6jUn+Bq+J/6uu9F++FGODJIME9QyAFV779ME6MfJ1qLhUN4SIJj81HgwhY7YRD0PkSUihe1Z6s5XyrIMBk2KbPYy5M78kCjmV1H2gE82E4lH4U90SeDc2+maJBN4PGhjKj53VTIgdz0ReFnpq3swa/5a3FSKiqXGFInJZmzPiuTRC5bwc0PmU9VuCiExnpQ78GagvrY4amgndIL21fgCPEHPuj83x8gsxnZr5ITY0p4ci6w/lwYRtcCgAqLMt4/OdZL
 AoiZ5hQ3
 0rUJc1dacZrahR5IPLkUSZ0xyIQIA6JFQkawZGMyo0a4BpsnbpQhRv/zc4LF4bUBw4IXvT57X4fkHOPGTTJfhmx56U6J/bfnLt3XXwF/hMVq7FG/22wOGptkzEdr5FxdjvFNO17vJGVVyBjNIg0JNlfz4QqbmaeyGHHHKkPPxmGxjHhLk/5nPfvKsq70YoqJSKnuqHrG4+tZHatiVAgyXVZ40eLf8PVsfTUUbP2TpXLAM43q/4HeYJnlKsImDUtVjuNUhKcnau5T36HI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:31PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> Memory cgroup functions such as get_mem_cgroup_from_folio() and
> get_mem_cgroup_from_mm() return a valid memory cgroup pointer,
> even for the root memory cgroup. In contrast, the situation for
> object cgroups has been different.
> 
> Previously, the root object cgroup couldn't be returned because
> it didn't exist. Now that a valid root object cgroup exists, for
> the sake of consistency, it's necessary to align the behavior of
> object-cgroup-related operations with that of memory cgroup APIs.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

