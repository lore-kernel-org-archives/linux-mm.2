Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE64DF557F1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 09:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2382E6B0005; Mon, 20 Apr 2026 05:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E9A46B0089; Mon, 20 Apr 2026 05:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126DC6B008A; Mon, 20 Apr 2026 05:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0369C6B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:20:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 767A3C293B
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:20:05 +0000 (UTC)
X-FDA: 84678387570.04.44F0CE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D3695C0008
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:20:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AHwAnR+k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776676803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRKGg82iGXnOz/cF77HfM+l9MMiiRT8274vp4ZRUURg=;
	b=wjS70DJ2qFdWKu/HeYLpTo4+CrtzYxFRCAVIM60J3UwBqDxxiDUzdV/oJTjAHuTAwyfhnQ
	5v4zwD9F9HdYbbVBj+jw9iTmcFcMCC1gH8BE4Q7P2sJ/8wUQgsyBl4G4HH8mHYil7OZf+b
	9wIIowqgH2kGuZhna8f/M2SXEbff91Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AHwAnR+k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776676803; a=rsa-sha256;
	cv=none;
	b=M6iinRb3RsUNbTGZZj4K0wGWl0ugkbvh9nBksDADMP8E5BG3ikYHrSFwUqxDf404g66iuF
	s7PZ7e4XSocVEQdciPiMdPdcfm2sPzU+DaO0QDxQkh/Qovbcw3lZp6YmakngV51z7et8j7
	fP7i1N8bGfTFVQ8hJYeeQA5iTEFps+Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A1B860055;
	Mon, 20 Apr 2026 09:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB54C19425;
	Mon, 20 Apr 2026 09:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776676802;
	bh=l7We2lzrn0rwykgmQ297ASg/aplyptJQ9fcEc9kC5wI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AHwAnR+kA/5sGR9O98GtTLl9HG/iXsHupIIGjGjLrepNxyB2UZrSbWpi3bTO/wUpn
	 ruBsJzi+li8gcRsxOfD3/BbwAcSafZeEmRp+knTdW0nOTOk3tQ0K9MCxwBLXJX5Hl5
	 I3CyuIcy8QJnXesb6HUF5FNWwO9ViCHZhbVjp/72wDgL26nccfqL/9SLfcO7l/6seS
	 30Ot4C0zKgD3JCf8hvZsgWS3+lb1eNVbISrhnkiBFnpECEeAlcwQcUn4GWSx1ifLQ3
	 JBdA9XvAhdJkEf0jicvSjiOfzt0HDB8AWH14KlDKXlUhRCttiqgU2c/0+/S+r4fyXY
	 Of/wLNA1eoNiQ==
Date: Mon, 20 Apr 2026 12:19:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 00/53] selftests/mm: make MM selftests more CI friendly
Message-ID: <aeXvty_LE4v5XLq3@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <ee6bbac9-b375-4413-a771-6d32c7afda67@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee6bbac9-b375-4413-a771-6d32c7afda67@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D3695C0008
X-Stat-Signature: xgjuz67ow7wt3ike5d4txormox3jo1it
X-HE-Tag: 1776676803-890695
X-HE-Meta: U2FsdGVkX1/9eujnCIZGI0RE1q/ipEHHPbymoSS56hypoR9Gz/39LpmH/fK2WlDhqzaRtBGXykYNdDc246BXVnFahmC6Nu0nYE2WcnC0qoGcwjrgL/Z1lfryGI11IXM4/rVETqZol1y3wRk7etj6r9/55x68pGSE26lWQ+Fi8qDmPOvF+drLmYWEnMBRgJOMtcH3PWLf2PVTZjciq/2NB5xE95Pn0mYVMU+xenpKDF7/LFpnHqZhTQDPXTFXyGYiWm3ZA0fGFrUzrPV8jLJfVa5UpdIZ+nNJEaLnVZIfMhYaKcT0bBslVjXN/2DtP8pF/icSpujCgTZuipc63Je7j1AUIAKx7YNilIRviMeT0kdGmmLNhLtz4m6wdk3egx34sFD/AZ8Td5+cB3wPLU1N2sPVGx281I3h7u883K1tuu05elzuE2sRmNk0+pUPPictcUYLSgzUuaKhXbWRw93SV6f6liac4fJUR7xg4YiKiBcRrhoVdkYGTW9VN3lt87a0js51kIIDLHrk28Jy13MGY9i5/CiLPflOC3RNUW1ZH64ls5jDSnxe59Vvsy+uAuBrXnOtbLrpj3EIjftV8fnGn50Vx8w4Un8N0VDIsYfGnZi3tybwJkzRnxRUWkOyqkyPQEl/EFjK6hVl5CCS/Ocqgo85kaIQjvzTmM4RK9ql/y6w2XTUcM3klFCliAb9oqUt0vMQkawOM7u8iFLU7VkDzxda1439xbuusfV/ptfoV9HwewOzamGzEPN6lAIVThr2EcoaSsuEwvST+ma9mdoowfVelmaUigaxeMpEhaeswCCzqSNpu0hcsQyJZ5PKKxPPLZwKtE86tzz5BvYHrLNPFbmYBxnZ//tE2juIhII4RGsY8HJ2uqDDvNSCuXSgn5IJKBUDtbtlNqTq/1eLprTF1vB2aDW7xLGb//4VlIvVHdA/S0fkAm7i7isSGnY/HAPegE0/Lbfn14LkfZFnQdT
 Su6bzJP1
 6Q/UBxx/SSg0T8a8/OHx12rdDXYcSa/ObKAAv+/0xdzrFiNfxonTbhjRJ4sL2iK1vFYd5SU38aDIrXlK28pXj/MenQKLwya0P9LseHmdqndHKiurua0+5wKjtcuWXZ0XWWrJtMUwsBJ2XDUfR7wSc8iAjNkGAgu2+g/1Yv6vkQsEOmTURW8F4GaZ6+PLTxwQQLI68/Z9MuZliOTtjbQowsMYAqpE2HU662g7GpxjHycwmcaH8Peqd2HENtSE+tvOgafB6M75jLYg5XTWaHNjHuyJLGB3iKsdUZZLqCk9n0LFqo9+bxtWexAMJnSeyLu6sGsRrQa1pfkXngpL5EGoEsBxFjurw6+DOxuBkPdzUi8CKW7nreEcLLffUrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ryan,

On Mon, Apr 20, 2026 at 09:37:03AM +0100, Ryan Roberts wrote:
> On 06/04/2026 15:16, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Hi,
> > 
> > There's a lot of dancing around HugeTLB settings in run_vmtests.sh.
> > Some test need just a few default huge pages, some require at least 256 MB, and
> > some just skip lots of tests if huge pages of all supported sizes are not
> > available.
> > 
> > The goal of this set is to make tests deal with HugeTLB setup and teardown.
> 
> Hi Mike,
> 
> I haven't had a chance to review this series properly, but the intent certainly
> seems extremely valuable!
> 
> I thought I'd share some configuration magic that I always use when running on
> arm64. Appologies if I'm teaching you to suck eggs...
> 
> arm64 supports multiple hugetlb sizes and (at least in the past) the magic in
> run_vmtests.sh only reserves for the default size. As a consequence, whenever I
> run these tests on arm64, I always boot with:
> 
> hugepagesz=1G hugepages=0:2,1:2
> hugepagesz=32M hugepages=0:2,1:2
> default_hugepagesz=2M hugepages=0:64,1:64
> hugepagesz=64K hugepages=0:2,1:2
> 
> Which reserves 2 pages of each supported non-default size in each of 2 NUMA
> nodes, and 64 of the default size in each NUMA node. (This would need adjusting
> if using a different base page size).
> 
> My recollection is that this effectively overrides what the script was doing and
> is sufficient to make all hugetlb tests run for all hugepage sizes.

My goal is to let the tests themself set up the right hugetlb configuration
without forcing it neither in command line nor in the wrapper scripts.

On x86 I can run all the tests in a virtio-ng VM with two nodes and no
kernel command line overrides. I suppose that should work on arm64 too.

There are some additional settings that such a VM would need to avoid
skipping tests that presume swap or a real filesystem, but that's more of
virtio-ng limitation.

> If it's possible to get this non-default hugepage size reservation logic into
> the tests themselves, this will make the mm selftests much easier to run on
> arm64 with full coverage.

That's what the second half of series do. E.g for cow tests:

https://lore.kernel.org/linux-mm/ee6bbac9-b375-4413-a771-6d32c7afda67@arm.com/T/#m62f23b835061449bc6249afacf993bb32ea11234
 
> Another observation is that "secretmem.enable" is currently needed on the
> cmdline to enable secretmem so that the associated tests run. Not sure what can
> be done to make that simpler?

Looks like you're testing really old kernels :)
The secretmem default changed to "enabled" from 6.5 ;-)
 
> And there are tests that depend on having more than 1 NUMA node; I always run
> under QEMU with 2 emulated NUMA nodes. I guess that's really just a property of
> the HW, so nothing to be done from the test harness.

Right, test harness can't do much about it. It's either run in a virtual
machines with 2 (or more) nodes or enable NUMA emulation in the kernel
configuration and the kernel command line.

> Thanks,
> Ryan

-- 
Sincerely yours,
Mike.

