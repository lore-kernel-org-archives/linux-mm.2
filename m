Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0641AC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 00:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C7DC6B0088; Mon, 14 Sep 2026 20:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877E66B008C; Mon, 14 Sep 2026 20:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C726B0092; Mon, 14 Sep 2026 20:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 565A26B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:37:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 299EDA02B3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:37:05 +0000 (UTC)
X-FDA: 85214132010.30.38E54F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 60511180009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:37:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0kjRP8tz;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789432623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ohmby5G3e6ifkVjc4vuFLhgRo5DzLqDybCdY33dqOpo=;
	b=ggyy4P9EpZvaz6Nz6TdjjbP0//nT9HmCI96ZudUjE0NJV3aH49ePis9wGCpAoK2nvazWgQ
	2JERGGUg9LvWyRrHljVdOZXgSWx713+Umd8FMvE4ImKFhttaZHsmOZwbCKDY/nKdOvswJq
	sfgvHDXGtE030j/KuHo6ANN3DFx66aI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789432623;
	b=z+0sN3OsqTW7huTHh7MRDfSS1iXloxEuETvvKbgINX64zXlgpOq9QjLU2jFa1RpC0/bQDP
	imte0v2nMB9UO6UYhji990Ix/E32k6K8Gdtgjk/sha0/0Z87o6NLZWh2q9XZvJ48SETd+J
	NnexcZbFojotE7XTiU4RjcKA0oMrDOA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0kjRP8tz;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB4A26025F;
	Tue, 15 Sep 2026 00:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F441F000FF;
	Tue, 15 Sep 2026 00:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789432622;
	bh=ohmby5G3e6ifkVjc4vuFLhgRo5DzLqDybCdY33dqOpo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0kjRP8tzG+b8wa8QbL2/el4odhJfqEWqwcgV4vIBPsytvQFtemQj8Hsm69ZkIfRTN
	 fOh72hTkudcbh+3jYO8BaN3ibRfctUxdqnWFGY7Z52aUSh+jyv3i9xevJ9+2k3JTNa
	 VLWY5RlraRxYNUxXnalqXXZudSBgnSBtNwkCl26U=
Date: Mon, 14 Sep 2026 17:37:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyle Meyer <kyle.meyer@hpe.com>
Cc: corbet@lwn.net, david@redhat.com, linmiaohe@huawei.com,
 shuah@kernel.org, tony.luck@intel.com, jane.chu@oracle.com,
 jiaqiyan@google.com, Liam.Howlett@oracle.com, bp@alien8.de,
 hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org,
 laoar.shao@gmail.com, lorenzo.stoakes@oracle.com, mclapinski@google.com,
 mhocko@suse.com, nao.horiguchi@gmail.com, osalvador@suse.de,
 rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com,
 shawn.fan@intel.com, surenb@google.com, vbabka@suse.cz,
 linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/memory-failure: Support disabling soft offline
 for HugeTLB pages
Message-Id: <20260914173700.346dc533f1f21ef170b7722f@linux-foundation.org>
In-Reply-To: <aqiIEkrc6aDBOqRg@hpe.com>
References: <aqiIEkrc6aDBOqRg@hpe.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 60511180009
X-Stat-Signature: rzcd43rru4yk15ee5ok8npt3czsqwwqr
X-HE-Tag: 1789432623-768590
X-HE-Meta: U2FsdGVkX1+2A4n5UeUPIlbXVqfwwXoxyaK0lKr5NO+helGh3O3zZxQMJU47fJNqTmEcsheNAo/xCCupZNARzxPMMOxBvpHRDP8O76VW9RjJnex+Ix+/GhGPtEkFO+DrdxwaTTD3NzVdyy8FIg7l2KxXkNxQWaKZj3DPJKUG7DCXnPydJWw0FWERDjTAeV9uJ9NZE/9QkNpftvCTH0FR+wIBe/4OaDjGWmef74hfQVcodvII3cM79zeEb4sTcgNXj6UETiounCBhELUBMj5JnOu+6ORs/NEZQ9rRXeYEm/xnzGJGO1Rcof/aDz6f+OV0lM0uvs/Z+N4zIFq3gdNWL0I2cCUbPOOkq7tJEXo9UEhvvciOciILM6VpqeNGrwu3imYAFRB/sUcNncik+wPUbQWzjtFCf/VeROD/qivJ69cG7D5WkJm93RNhPq3yruJE/ToX08aI/LbBpQAk2z9XS5c2MJBJN7Tv0EdSVgvPtovjWD4bL2Mv9l/HtZsmiU4uqYrDRPx78xu7Xavs+cGDpqGHkk8F9coHjS4Goa0LvBxIEGo+zyCjT7N56nN4OyLRZ9VeEqzTGdgxZ1BzXfQ7Q4WDYyewrgdbax3Pc6GCP8i/YtQTUqhpnhXPEdYi8XkrBrquCLIzfcLjFfBw2bWW/FYP80Eyg35WIjVCDX41+ksISUABsVh139nvxQPeAlKJqdWDiHO3xPXQ8j1P8EZICWaSKEdMxqWfnUQHFLmDXEFJdy3KBz6pZjl98C/c7t/c4fEiOgd6MOXStlHYzu6f667GujmYJd71cWEpm/YRPq7iEle0KWUZh0ifiwuJWbZKiN70Q1U0uRytPjda3U69cQQm3CH+DcT//wSj/2jNbU1yOahAxDtcj25oeahm9zwTREL0vyP8HTWjwTLUCy0oAiT5YbvfQDstN2RV9hlpmtMM6VcaaV128N1b3E4Ws/Kr5m9s41NY86wxKqdSy2I
 cNDRqZW2
 tXQSie5KvTrvVWtk6UrdAQxrUEaSQ3xr9uQr4iM2R+odMZVTy9Nck12X1DOkgvIlu0oErrc2bzjBRQiMEssg536IBZIZBWE0ELW/cegESBZQyONhX1JBXWXLnFBs3g9F/i/8NPPaIO9Ae060SWqmhefbFBSr5ffT8ZiZ3LQTqMrrx+CAXne5fN2DiiOXrgPS+8p9jtXE25m7RF6C0XP0Hf4I7NzWmJZYhZT3o0W8SRFjyGj1euyiD77YoWZNxtuv5gakQJyzETvxmaXOx0houOGyd6+6dTNfXOxiZ3WVgWGF0XhW067dgqtfWT7+BfvQQVeawoQZNSjE+EeDCgGSS6RFq+ZuAnauykDu/4Ef+/ahOrPOzKR6fEuML5CTYGHoPATt2cG6ZpOeWcsc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 18:49:38 -0500 Kyle Meyer <kyle.meyer@hpe.com> wrote:

> Soft offlining a HugeTLB page dissolves it, permanently reducing the
> HugeTLB page pool. This can be problematic for workloads that depend on
> a fixed number of HugeTLB pages.
> 
> Currently, soft offline must be disabled to prevent HugeTLB pages from
> being soft offlined.
> 
> This patch allows soft offline to be disabled for HugeTLB pages while
> remaining enabled for non-HugeTLB pages.
> 
> Commit 56374430c5dfc ("mm/memory-failure: userspace controls
> soft-offlining pages") introduced the following sysctl interface to
> control soft offline:
> 
> /proc/sys/vm/enable_soft_offline
> 
> The interface does not distinguish between page types:
> 
>     0 - Soft offline is disabled
>     1 - Soft offline is enabled
> 
> Convert enable_soft_offline to a bitmask and support disabling soft
> offline for HugeTLB pages:
> 
> Bits:
> 
>     0 - Enable soft offline
>     1 - Disable soft offline for HugeTLB pages
> 
> Supported values:
> 
>     0 - Soft offline is disabled
>     1 - Soft offline is enabled
>     3 - Soft offline is enabled (disabled for HugeTLB pages)
> 
> Existing behavior is preserved.
> 
> Update documentation and HugeTLB soft offline selftests.

I'm hitting some rejects against
https://lore.kernel.org/20260825085756.63030-4-husong@kylinos.cn. 
Please update this against mm.git's mm-unstalbe branch or linux-next.

I'd updated v2's changelog with this:


Tony said:

: Recap of original problem is that some BIOS keep track of error
: threshold per-rank and use this GHES mechanism to report threshold
: exceeded on the rank.
: 
: Systems that stay up a long time can accumulate enough soft errors to
: trigger this threshold.  But the action of taking a page offline isn't
: going to help.  For a 4K page this is merely annoying.  For 1G page it
: can mess things up badly.
: 
: My original patch for this just skipped the GHES->offline process for
: huge pages.  But I wasn't aware of the sysctl control.  That provides a
: better solution.

Which is cumbersome but I think there's useful info here so please
incorporate in some way.

> Suggested-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>

v2 had

Reported-by: Shawn Fan <shawn.fan@intel.com>

which got lost.

