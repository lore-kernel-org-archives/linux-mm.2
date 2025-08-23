Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04DC6CA0EEB
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 00:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EAB68E0020; Fri, 22 Aug 2025 20:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2098E0018; Fri, 22 Aug 2025 20:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FEFB8E0020; Fri, 22 Aug 2025 20:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1838E0018
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 20:43:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A45E5160402
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 00:43:04 +0000 (UTC)
X-FDA: 83806172688.08.DA9BD6E
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9B54040004
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 00:43:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S8hZWVU6;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755909782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpLXHOhq7VVSPWOqro21Ta67IQ8IMqaTYxa6KczFO94=;
	b=kpeFbMc9Tv7+Eu1fuFkMC7/JN4P2F7cqskII7bp+s13JCuKyTHaHoYnQ6FnElRGB/p0Vlw
	9Aw8eoewtgUUD8CXM4N8SzpR+hoXMw5SR6RZnz7w3FUS+R1I5wEGNyQw/pz5w3md2rzyQy
	3Tw9ahsU+SoWktESJpvaPgc2mNxjkO8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S8hZWVU6;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755909782; a=rsa-sha256;
	cv=none;
	b=aVsP6QgFdCSfJhNhq7a72hBPDykcYCBruTASItlWfRjcP+ADNrlx1+fJCwVj2rjYtGOCK1
	fr5R0ZuRTNOuq0UmTbCk4j3BKmcUqFuxImt2uXeDm4j7kQa3w+HMYoV8lYrQdzfCRQPH/q
	BXGIXHmF/PUVi12lr0Q6jrUPGh/K2yE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id B9068A566E7;
	Sat, 23 Aug 2025 00:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7C6C4CEED;
	Sat, 23 Aug 2025 00:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755909781;
	bh=EKwFARSCxE6DW/3EQ5i9Wr8vmKaZVfVfckT18HUdQE8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=S8hZWVU6hakZ1AbQJY4qDd9ZvCnTU2Gw+bC1eFg4cq0BeGVUmBchZh/wksiAWI8pu
	 +XFkJju44Ls9/D8MWUzK+x4U/k8MLbI6bDadFCqMj2rSDYTHoSNyxSMXs7k1OJ9ML/
	 3HkdUAtQiBgCUKib2sOu+2fDGf1bDvrdTvP73/d4=
Date: Fri, 22 Aug 2025 17:42:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Leon Romanovsky
 <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, Palmer
 Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Alexandre
 Ghiti <alex@ghiti.fr>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, kevin.brodsky@arm.com,
 kernel@collabora.com
Subject: Re: [PATCH v3 0/8] selftests/mm: Add compiler flags and fix found
 warnings
Message-Id: <20250822174259.bf4ed76a0da7d0d6f80ba2c1@linux-foundation.org>
In-Reply-To: <20250822082145.4145617-1-usama.anjum@collabora.com>
References: <20250822082145.4145617-1-usama.anjum@collabora.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 75gcriont8qfogqjufsicrsrbqqic8zk
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B54040004
X-Rspamd-Server: rspam01
X-HE-Tag: 1755909782-218611
X-HE-Meta: U2FsdGVkX18vbtUXkqRjLmhOUiLrCgAHQb0L5ypK0ybAYcYDhyrihuK0omuGGOsNSxrpGt3X7HZnm6slsotqY7JVhuLFdC1c3+qiUsjHfE3DZLuve7A82DCx0qFSCkj4qNWNyRoZwKkonvbKyZzW/tQWX3DTkVeyfXvNOKLJyLCUWCtUtfXXEMivfGSnpBupEpDh+cNLkEXcxhUnO9gct/8E0hLcjuQ51X0d4dKRV8Ctf3R+v+e9xOjMfUGC8V/uH3jujnqk6NAwmeLNDm6XpE/LLkqiRPB53Lk/y8P/kUZSkj2KseN6b4cktX9j/xP+H5gJrToCOS6bVMIFDH4wHIiPtnd0pXlj3esSHSRooKwxHSUmxVhs7Rn4Ox7jGd94XoD7XmH8awbUseeWi/8U233YUYw1f4IQMYiz5z6z4k5xvn54lXg0PWBDOj+zn8VrGVBueJtGgsWcF0kCOujlbzhWNnWtZ1DhGqVZzLn/hvzZ2NpLl5De+COD0bwkBOUBb1Dvu8gS78qtlNp0ViJnKbqXJAe4rijPAqjTU36ltJxBPJuvxExHc+OqYQk0dmJtWjR9Siq7dHgcD+V8jffXRrYLQZEAxvBTrWFapyNv64Dy1FeZPJncSJoH8/eqeZ7y5449BTyPUTkl9BMZboX1V0kprBPOSm+eM6baPqO9e6ifDjY7qbBKpc6zw5Rp3uLIyO9z9hbS7IdjQ64h2XAtEAk5sr4F9Ayen94MzmRaO/qvMJnb4iDf30FTBgUlC4AgIXdRxW5qYT/XFl0ZA7pWcZWjz3Wb9CuaYdXv+7s1sd5+IpVpWaET2JyS5Im9fkhbks2TVwEDG4Attz5EXYpFNteccIxLyZyGarEqCf7/FP33abvxOc+Z0XRwWHwonMDZWoNzwsZBpnSsPjy3uD4pvPHYuq8dPYp0wf5+KILpBGMFYE3DrN7vAk1lgVn6YJOmq5dy322btnxCUrdzPtt
 sl3TAzW0
 lTNGR+IImynvdap9bNj2NXSiFdXrjMpCmbrTLylpM5zyQoduTUOMA0/Sto7Wev26h3XOoXOe4YNRDo02bAuNjhE3DCnzjBhgyXAAWXebLMerM7zN7RuECEfZFYSo8mWA+hLcigNTrx2bGAfr1fNOmIEsci2kxGS1J0K22jBECo+xvHLIvmseSQSQ1Csq/EOCT1jwvd7GqRc+mf5jBBm9rqvmxOfQNP/+qNuSZ05uQCTsU65r9mfXfElgECc1MssHZIf/EdUTHU6TS8J3pUmywvzoFkSgxJhVZ0PkDRVDZy1ghVeQNoaBRXlPy2dIu3UUf5p54ne96ctYxJU4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 13:20:57 +0500 Muhammad Usama Anjum <usama.anjum@collabora.com> wrote:

> Recently, I reviewed a patch on the mm/kselftest mailing list about a
> test which had obvious type mismatch fix in it. It was strange why that
> wasn't caught during development and when patch was accepted. This led
> me to discover that those extra compiler options to catch these warnings
> aren't being used. When I added them, I found tens of warnings in just
> mm suite.
> 
> In this series, I'm adding these flags and fixing those warnings. In the
> last try several months ago [1], I'd patches for individual tests. I've
> made patches better by grouping the same type of fixes together. Hence
> there is no changelog for individual patches.

I think it would be best to avoid adding warnings to selftests which
aren't present in the main kernel code.  If only to avoid surprising
people over what isn't permissible in selftests/.

In particular, there's an expectation that we can do

#else
static inline int some_stub(type1 arg1, type2 arg2)
{
}
#endif

without warning.  We do this extensively.

Also, please be aware that there's already a patch in mm-new which
centralizes selftests' __maybe_unused definition.
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-centralise-maybe-unused-definition-in-kselftesth.patch

