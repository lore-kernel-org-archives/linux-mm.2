Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D107A1093170
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 446386B0425; Thu, 19 Mar 2026 22:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41DE36B042B; Thu, 19 Mar 2026 22:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A726B042D; Thu, 19 Mar 2026 22:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2476A6B0425
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:43:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C9A931E082
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:43:51 +0000 (UTC)
X-FDA: 84564896262.25.8D55D67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1368B12000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:43:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Hgkr4hg7;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773974630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7IV3PhKZaJDFpn+P+ehB69IjxlZCq4uzKyFwVoiDw2k=;
	b=H5SStQuYqBGvtEKURu2y/+f4za3jvU5FYXDEQN1GgziHprvsQlskogDZWNxex3t6seE67m
	Z8e6KpyjTU9jtBwd2OrKF0JESXBW3accHZE1MH2Yk0Ip2aI4Jy1OT4jzmBJQrZiVqZcr1e
	8x17EwZSO+DpMVHpi+zdgQ9juz2NOQQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773974630; a=rsa-sha256;
	cv=none;
	b=HDxdkE8vR/n0OGo+uBEDoUKs/iTpJ7+foVCk3ePRLKTGRzmbN11G0JB9Oi6GCSNzcGrxn+
	2lRCHKXfDSDovpkKGWLfa1/WG+FwIXOdCYY48eKEmsfm4NtUlCapYN2m1DawSKv8evveOn
	5YjqEu8A3PSgfUVGA81wSfahsOXHLF0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Hgkr4hg7;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12F0C44292;
	Fri, 20 Mar 2026 02:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D87C19424;
	Fri, 20 Mar 2026 02:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773974628;
	bh=IM7odbRo5JmXvV35WSNt2mLDPESwML5Li6T+qlytX5s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Hgkr4hg7zQXTt/YOkRxPkZIHUtK1zTNcywzH1MTqkkREzmi+9td5X05r118VG/gIv
	 EUhIpque6aM/JP1B3c6Vr0hPdX5qI+jqzi3lt2YguscLplbGdsloC37l/N6PfVU0CG
	 3BB+Li1V5rF2Lm7aIiOKKHmYDkcoC8MS2OnOO6CE=
Date: Thu, 19 Mar 2026 19:43:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo
 <tj@kernel.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Shuah
 Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 James Houghton <jthoughton@google.com>, Sebastian Chlad
 <sebastianchlad@gmail.com>, Guopeng Zhang <zhangguopeng@kylinos.cn>, Li
 Wang <liwan@redhat.com>
Subject: Re: [PATCH 0/7] selftests: memcg: Fix test_memcontrol test failures
 with large page sizes
Message-Id: <20260319194347.1048fc8d737b6e8f9d82663d@linux-foundation.org>
In-Reply-To: <20260319173752.1472864-1-longman@redhat.com>
References: <20260319173752.1472864-1-longman@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: je5adg6pgxbstaeez14qph1meapdfkyc
X-Rspamd-Queue-Id: 1368B12000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1773974629-766196
X-HE-Meta: U2FsdGVkX19ffkXJgdc2rGPNeAxLUCUNY7lPueMz2Q+v5Yghw2kNqxZM84KExX2MYr1//z1JoCaniW/lQ2JZAq1054xLVaBAq7IQ+1DmycmdFF99Gy40SbVSJrJLUmCBZSApc6y2ijvlnq5GuPIZNG+WuPnvfjEIzaQG8cU7rdGbvFQsdtcA6YYjLykv+QISOWZ1Wogp4b1YrFJ5gCG63+NINhk9N4A4y83rGR7GJd8R7G/SE7B1o8FYTvdWJs/+JFGq3zKjLdwfItWXi4Ep8JZ81oT5yTD/GbmSGGwj5s6cTiF1pHfiNZ3By7tFABUXdrEiIP3Nan3uZ/rrLHEMg2vxr6M0sIYwXuNx22vBA8Ch9rJZ+8r9iQYW9J/7SRQ+NEcXF72xOYnAxvs6lmrLXkK7sZjxV73+n1p9jpbYoBPKRTaOh+rno0plaMhe0oYtQ9jn3tIT8AiqOgSu6iNIX8vQ2IiWuqhoSkFMZT4swxIsJTaXglJniuDly39e1zcthPiqWsardbzT3LYuOdPJeWQfm8VRMUZdEm5yiv9rpN97+0sse0ez/pox5goGT5PBDtKKbF15TuwBwChvVrYFbYRk9HHomaof+k39PDy9I80NOG8yyj6OTdeqcRrR0aMLd+UVH9LyHZudo7ykEIZdeMl38r9r1gZ13IFpnaJN6PKNNjRoipwWUTlhl7XepHbxMjPOhPwEFOpEeT8EqQBMZszs14iKNzoWV28m2YZNeGcng6jAdHkU7RVeH1ES4VnnVas0mawkjoLLsM/2Guqqt8uYnzDym5IGjPQ06uxUnyJpXmJ90FdxB2P4k/Q41YwHrR0N01PoRtGWqVJFdEcIHZftWJ819Cyrbdwr9fIm7Ix/DOs4qN5CyJ1JxgsK2XUusQ5jeSvr8JHABszgbH8bEsHS6vu5xzgTXPpJ+74e6piMWwPkWizh9gVC/dFrpO+/Lst1/oVTOIHFI9bB2/q
 zkpKhHk5
 8Ro+y/sPntbuft0+pSp3MjXlCtOFLFJh3yZc+L4dahgrvDTZrE1y3ovhhnGpNkajisdKhD9kiwWz/n9FylPVR7MMmbaLz8d8THje3eK28ROK5o2u8OzggcXpa8VVHb3QLEs3rEi0AkMZCcIbkYPdYIUiSGu7vXwM0SdkE2+j30F1lluQdiAs0SdA453LBw6HGHyz6m6YO9o3wWkANTzaYe6b6n4kegi7mgng1tb6mjtKCqZVvsaU5QKDcpeYxKducqk8WV9zJ6JZcpc0hRTExvqavNA9hrDg67yWQHsLz8YuUR1U7wTwk3PxmADiz2p/1FydvZNKtGbr/3NtosfKL32AbSJTzHTE9Iocn6MnI5Qc0lJxchYrBM0GmlxA+vCogihMq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 13:37:45 -0400 Waiman Long <longman@redhat.com> wrote:

> There are a number of test failures with the running of the
> test_memcontrol selftest on a 128-core arm64 system on kernels with
> 4k/16k/64k page sizes. This patch series makes some minor changes to
> the kernel and the test_memcontrol selftest to address these failures.
> 
> The first kernel patch scales the memcg vmstats flush threshold
> logarithmetically instead of linearly with the total number of CPUs. The
> second kernel patch scale down MEMCG_CHARGE_BATCH with increases in page
> size. These 2 patches help to reduce the discrepancies between the
> reported usage data with the real ones.
> 
> The next 5 test_memcontrol selftest patches adjust the testing code to
> greatly reduce the chance that it will report failure, though some
> occasional failures is still possible.
> 
> To verify the changes, the test_memcontrol selftest was run 100
> times each on a 128-core arm64 system on kernels with 4k/16k/64k
> page sizes.  No failure was observed other than some failures of the
> test_memcg_reclaim test when running on a 16k page size kernel. The
> reclaim_until() call failed because of the unexpected over-reclaim of
> memory. This will need a further look but it happens with the 16k page
> size kernel only and I don't have a production ready kernel config file
> to use in buildinig this 16k page size kernel. The new test_memcontrol
> selftest and kernel were also run on a 96-core x86 system to make sure
> there was no regression.

AI reviewbot asks questions:
	https://sashiko.dev/#/patchset/20260319173752.1472864-1-longman%40redhat.com

