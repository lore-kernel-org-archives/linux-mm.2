Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FADC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 535528E000C; Wed,  6 Aug 2025 12:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE4D8E0003; Wed,  6 Aug 2025 12:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ADA18E000C; Wed,  6 Aug 2025 12:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 271D78E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:35:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0C7114039F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:35:37 +0000 (UTC)
X-FDA: 83746883514.14.6E01A14
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4AE4040006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:35:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="d/y054IB";
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754498136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6PGwkPN1m03yNUmjXX+S7DgMOztA33pE3TTR42oD2k=;
	b=SOQK9Ns6fJ2UUMyhBs0i+v5znlRNXDR0kKxACLpEoFpLUW7YuXv7n+D2xdkTVMxw/pJ2x9
	hC6xsR0g0pMCW3GPm/F5hbRp+UFFsA5jTWV8idT/yuVrh1xNBt11tOw7Faovleydj6XqjK
	4mpMJNzYOPQHGvruNDJtRlMFYwgHFw8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754498136; a=rsa-sha256;
	cv=none;
	b=tyXWOD2yNFCW/HGjgh4b4GPublIKacntIoycZZ/c2SDAPnUURDzhaW38aXTt4HdtYPfVGk
	l/meizWLBRAxjVWlMO4Mz/UrGUtH7YqKY21XXjMrxajyes9YtqOzQIskoSz+fjb88NXFNG
	M5lwEyOhB6h9/GR9m8ds/UZMhDXD5Q4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="d/y054IB";
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 70C4BA569CB;
	Wed,  6 Aug 2025 16:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4AFC4CEE7;
	Wed,  6 Aug 2025 16:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754498135;
	bh=xGGpA95XAeb0WwdxHKDD91ns9hkx0Ye7AgEA8IpfDQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/y054IB3WTivroNoV2FuA+UveCHLltCgYNZqm23SCuo2K9wGbGR2ca6JyInOgSVe
	 LYLjRM5pnbKC0QeVcHViZHHqT64AmrA7+rN4vgnhFxrEqyFoh23I1CaVCHNR80/chv
	 +DuIUQynVIwoERpz8iCWEZg9uf1Nzr1Y2HH1TTNynQwuiRE2+hMbXXLE/j98m3NiCq
	 INKjI9cpu4MAYIcc0N2+F4aHVyHz4y4h7OQdop9sNR0xVL7gnaINkSav9ExiAYebtU
	 eivKoe6UotebTQfZDgo8QyQIrou2wX9HPTkpDlfL71wIAEzMUlsuOnJ0fwyvZXDGOq
	 +rTtZl13re3PA==
From: SeongJae Park <sj@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	david@redhat.com,
	vbabka@suse.cz,
	peterx@redhat.com,
	jannh@google.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	paulmck@kernel.org,
	shuah@kernel.org,
	adobriyan@gmail.com,
	brauner@kernel.org,
	josef@toxicpanda.com,
	yebin10@huawei.com,
	linux@weissschuh.net,
	willy@infradead.org,
	osalvador@suse.de,
	andrii@kernel.org,
	ryan.roberts@arm.com,
	christophe.leroy@csgroup.eu,
	tjmercier@google.com,
	kaleshsingh@google.com,
	aha310510@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 3/3] fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under per-vma locks
Date: Wed,  6 Aug 2025 09:35:32 -0700
Message-Id: <20250806163532.82466-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250806155905.824388-4-surenb@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4AE4040006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 495zrkkpktjxnzwx5qsydtahqj7yc6ty
X-HE-Tag: 1754498136-591877
X-HE-Meta: U2FsdGVkX1/+AVynAUzfgVIcdqWJrl+C3whiRJXjBUt0blP4CBg5TGSTbmb6uXuQeYeUwFQoq6GdRIPRPKcE2omyILYJRAyckNHZXRJiwuPMShMuWexk6hAUrlDHN8f/tpUaSS/AYoS60VTfMftOP0vt+W9MC7upvWDFapx6cvjfKb+AGgJQcSwDlnkg9WtvrfikMgyXbHSZ5+gn9IE6jTzvqpNapJFTEjF/07Nnt3puIZXqzqFnLEEc3guuRVJ4KxoCsn5CiyKmqUboBfvV9b+5xraoDSkc/REhu+cJacQ8OfYrCrJE9hJx78tXA4YW4KAHWfGxc14nQbd6cw/sJGuxWuaqxacbm/fyogUHYVo4l/cZNrykTP/K2aC1YpuemUCBGqz01h9sNvTwosAn06JD24Q88Uh/CXQ1jfTkUU6h6cKH33zsT0QDziS6k4GM02dG0F0qbIwT+DMDHUR+Fun+hfx9yi7xTsQZ6ycLvhj7Y4ZgK2cYtJFEIcZDRyQ0bGebebVMBSTW85vKBNHq2ePz5rPxqI+6+zDICJBh5Zgg1Mch7g8bpJN1XygdE4EnzX+1HGijwqhe4uN+M+GJqahwWyOlTBnLrSjvgmTYuH+3JmZKg4rNpuhmw1IuqugvwlnubgcoFUBpGFzWI5C05TNYBpQwBn6wi7yRaVLYJgHL/6cx3RVUr51H0YbQb7TM2leNQKGyhKOO9lCKr5zkhHvxyBvAiW5bxDO+0j9+ENzu+5vkzoLYh99dv2ACpByG8Y1pp8YuniHcl+xlZ7VyZabh9UAdoD4Ef5Jiz9hcWwKZG4PmlfLtte7PoLJfcGLMWJQpZ6xqsBQcHTjf0UduHfzeNoXM9xYk8P2FillYHu6DUxG9MUNQ4+HUpv4aRO7W7fUbSr+7oynPq2tJFCWuaMmFE7ct3/dbgDrYEsS6t5HwBiMjl/qnhg++Gsz8w89MXFBqiNavorPtKYXWoII
 L7rdKemK
 /Kr9P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  6 Aug 2025 08:59:04 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> Utilize per-vma locks to stabilize vma after lookup without taking
> mmap_lock during PROCMAP_QUERY ioctl execution. If vma lock is
> contended, we fall back to mmap_lock but take it only momentarily
> to lock the vma and release the mmap_lock. In a very unlikely case
> of vm_refcnt overflow, this fall back path will fail and ioctl is
> done under mmap_lock protection.
> 
> This change is designed to reduce mmap_lock contention and prevent
> PROCMAP_QUERY ioctl calls from blocking address space updates.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

