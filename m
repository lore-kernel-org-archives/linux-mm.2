Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2120CD232E4
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 06:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7876B0088; Fri,  9 Jan 2026 01:05:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6750D6B0089; Fri,  9 Jan 2026 01:05:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 557D36B008A; Fri,  9 Jan 2026 01:05:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 438AB6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 01:05:47 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E0FF35890B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:05:46 +0000 (UTC)
X-FDA: 84311389092.13.F6272CB
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id F15BF180007
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:05:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=abILgAFT;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767938745; a=rsa-sha256;
	cv=none;
	b=fv1H6t6U6MLuQUTOQVmNYMO0Smp35DojPjB8hLYOVo67oYJ1+RHt58rOV9WQ9gG0NatMay
	jf1/cuaFrrIs97pyFGGuI3WinnP/HFqJ3Da7Ju0essWOv+PgwjF5TRokLsPJ4Zqi3VFRzL
	h1wcphZF/P8+QyIdAB/gSxAduS8SFSU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=abILgAFT;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767938745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMAB7hPYrAln1BrSRyZimijuqiIVG7Q06uo7KZiinUo=;
	b=GXIDyH3RKzNZM9w0JAejnYBx4gwvwqMrMLUqvzpqsDv1VJ86i4t01j7AQEBoiKKgRG0/q6
	j8FWivjyGRGClIvqV0M1MGfYU1N0ib8oH8jGCX3Mj3DvUOp4iJl/sJo6nsUOurNLBUkAoO
	N+a86qy+QJ/+Qw/dnqDrCVAf+8mBtQQ=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767938742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMAB7hPYrAln1BrSRyZimijuqiIVG7Q06uo7KZiinUo=;
	b=abILgAFTq4PjJUDsGYYnBs0PNuqofwrvp0kHav05bioXupTMP96W4BsJ27VGvi6v+UcWYe
	YgATqUZf90x4OfN/cIylsIn7H47QCMB/Mhb3cPDHjBLAiDlVNH12wfNx02tCxP3i7v6SqU
	69C9DzxaFuqDKoc94HuUM/OebAfSkwM=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260107113130.37231-1-lizhe.67@bytedance.com>
Date: Fri, 9 Jan 2026 14:05:01 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 fvdl@google.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1981A332-0585-49AB-9ADE-99FA2FB32DD4@linux.dev>
References: <20260107113130.37231-1-lizhe.67@bytedance.com>
To: Li Zhe <lizhe.67@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1s4rum3phfz75do8b7b695saxfusf4y4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F15BF180007
X-Rspam-User: 
X-HE-Tag: 1767938744-596111
X-HE-Meta: U2FsdGVkX1+Gc4OIQlQrQXapK2349rkBdaKyxr7M3/IeI3jiXNPXH4s7nRV31Snw6o8F9syf8Mlw4RVufD/lKx7uFpN585rE0OMdadat7KcWLxQ5/kr3XDJdmJfjmyxzegbG9O9tRaO6dBAZvrJA0XEaQ43fwdVXW+SozEdCd0vwLqtZHytu0F5zF0/2PwvDkNHTVhqWGqgh0bBUcUIPTZ2OcAo0cqvk4aL70fTP5w+Asq7aZ7312U8OSrFq2K34HXXqxcC6LOugPiTTApDQLLs5DIyTN6ugGZLVuUFIvcNwvkwBTWkydgEpJhlz09oEsxgtH+eEahsl0Y+jbBI69ngknGscRUb2PyKfQanRmZe7puQnCB0p4IdQaEq9cp58SdbPOSvZMwEgZ7vbzJ7xfcXWAT3pLU7EA9I1FmgUBYLA2+UAOmnzJP+SEJwuFs1ObaR1vMqswUotaiHm39DC0kfnDTZY/50xO3CL6AsAKbKd5s/FIifVBt+5wVfFbvBIP9H0adfdr8tyHJ0LJYx8gXUIrnqT3sZqkmDke8xQhV4ZOaMk/9ZGBXomTFali627jXb1zU0h05FhzuM0S+vo7y4h1IYGXZ+wM0BeLBkToWp0Sxj4kAcwxnCrZ1lXiqtufO6YSy5h+tYeBd9ZKOURu6uYVAz7JY4R6Oyey9BF/2FAT5VfechbeADXFt/YfZXClUXnrCDF4bq7pR0VFRvljKbsTUWRkNZBWTYxI66pTOM21/q6q3wtA96D2x0PiALEz93+py4CACC9i6awhyxwG8nRCWDHtTvGsPe2o4xzVOnzZaeBG4veyORAJUvi9TrqFpxMpikT0+r27fo0ztTq/E6FO6GUnIJh9QnJKmoMM4iVjIegwqRhn0wVif4nIv27HyNDCIf1jCHVG2okyCSsBv82076O61POUN3434fAA3B8Y+gaLlxiqPvyt6n9z8ybOjmj0+WJyT0I9mnJCAh
 3gyyHKRO
 jLg/dNITPW4Kzsz/GhY3TYFLgnHWXA8Y/ERsSEu9Omto5OX2OECL/CbOiWkHLqzgr7QJI8CVW86/cFQ4jwDVDHnDZawr6s9A+nznYxJQoi9puL2rHpH4A9gqyAAVJkrK/TgriyEuGYBVrR5GHd5gKGdXRUob3DQQTcaHIGBiGDqq3f/r48t7ZayubdJswfMw1b0Z7KJBrynqd+cjhSVdT1X8R50woQf4ORCYzfEJ1qlpp4JcDGDqd/QYBucJIyHb9I6PDlAdIbyqvKNEmNRxTX3lbtk/nouN0ns7PW1G8X1PKJmfJTQVAqd6mhAKijiIeZWFifxNiL1SIWyM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 7, 2026, at 19:31, Li Zhe <lizhe.67@bytedance.com> wrote:
>=20
> This patchset is based on this commit[1]("mm/hugetlb: optionally
> pre-zero hugetlb pages").

I=E2=80=99d like you to add a brief summary here that roughly explains
what concerns the previous attempts raised and whether the
current proposal has already addressed those concerns, so more
people can quickly grasp the context.

>=20
> Fresh hugetlb pages are zeroed out when they are faulted in,
> just like with all other page types. This can take up a good
> amount of time for larger page sizes (e.g. around 250
> milliseconds for a 1G page on a Skylake machine).
>=20
> This normally isn't a problem, since hugetlb pages are typically
> mapped by the application for a long time, and the initial
> delay when touching them isn't much of an issue.
>=20
> However, there are some use cases where a large number of hugetlb
> pages are touched when an application starts (such as a VM backed
> by these pages), rendering the launch noticeably slow.
>=20
> On an Skylake platform running v6.19-rc2, faulting in 64 =C3=97 1 GB =
huge
> pages takes about 16 seconds, roughly 250 ms per page. Even with
> Ankur=E2=80=99s optimizations[2], the time drops only to ~13 seconds,
> ~200 ms per page, still a noticeable delay.

I did see some comments in [1] about QEMU supporting user-mode
parallel zero-page operations; I=E2=80=99m just not sure what the =
current
state of that support looks like, or what the corresponding benchmark
numbers are.

>=20
> To accelerate the above scenario, this patchset exports a per-node,
> read-write "zeroable_hugepages" sysfs interface for every hugepage =
size.
> This interface reports how many hugepages on that node can currently
> be pre-zeroed and allows user space to request that any integer number
> in the range [0, max] be zeroed in a single operation.
>=20
> This mechanism offers the following advantages:
>=20
> (1) User space gains full control over when zeroing is triggered,
> enabling it to minimize the impact on both CPU and cache utilization.
>=20
> (2) Applications can spawn as many zeroing processes as they need,
> enabling concurrent background zeroing.
>=20
> (3) By binding the process to specific CPUs, users can confine zeroing
> threads to cores that do not run latency-critical tasks, eliminating
> interference.
>=20
> (4) A zeroing process can be interrupted at any time through standard
> signal mechanisms, allowing immediate cancellation.
>=20
> (5) The CPU consumption incurred by zeroing can be throttled and =
contained
> with cgroups, ensuring that the cost is not borne system-wide.
>=20
> Tested on the same Skylake platform as above, when the 64 GiB of =
memory
> was pre-zeroed in advance by the pre-zeroing mechanism, the faulting
> latency test completed in negligible time.
>=20
> In user space, we can use system calls such as epoll and write to zero
> huge folios as they become available, and sleep when none are ready. =
The
> following pseudocode illustrates this approach. The pseudocode spawns
> eight threads (each running thread_fun()) that wait for huge pages on
> node 0 to become eligible for zeroing; whenever such pages are =
available,
> the threads clear them in parallel.
>=20
>  static void thread_fun(void)
>  {
>   	epoll_create();
>   	epoll_ctl();
>   	while (1) {
>   		val =3D =
read("/sys/devices/system/node/node0/hugepages/hugepages-1048576kB/zeroabl=
e_hugepages");
>   		if (val > 0)
>   			system("echo max > =
/sys/devices/system/node/node0/hugepages/hugepages-1048576kB/zeroable_huge=
pages");
>   		epoll_wait();
>   	}
>  }
>=20
>  static void start_pre_zero_thread(int thread_num)
>  {
>   	create_pre_zero_threads(thread_num, thread_fun)
>  }
>=20
>  int main(void)
>  {
>   	start_pre_zero_thread(8);
>  }
>=20
> [1]: =
https://lore.kernel.org/linux-mm/202412030519.W14yll4e-lkp@intel.com/T/#t
> [2]: =
https://lore.kernel.org/all/20251215204922.475324-1-ankur.a.arora@oracle.c=
om/T/#u
>=20
> Li Zhe (8):
>  mm/hugetlb: add pre-zeroed framework
>  mm/hugetlb: convert to prep_account_new_hugetlb_folio()
>  mm/hugetlb: move the huge folio to the end of the list during enqueue
>  mm/hugetlb: introduce per-node sysfs interface "zeroable_hugepages"
>  mm/hugetlb: simplify function hugetlb_sysfs_add_hstate()
>  mm/hugetlb: relocate the per-hstate struct kobject pointer
>  mm/hugetlb: add epoll support for interface "zeroable_hugepages"
>  mm/hugetlb: limit event generation frequency of function
>    do_zero_free_notify()
>=20
> fs/hugetlbfs/inode.c    |   3 +-
> include/linux/hugetlb.h |  26 +++++
> mm/hugetlb.c            | 131 ++++++++++++++++++++++---
> mm/hugetlb_internal.h   |   6 ++
> mm/hugetlb_sysfs.c      | 206 ++++++++++++++++++++++++++++++++++++----
> 5 files changed, 337 insertions(+), 35 deletions(-)
>=20
> ---
> Changelogs:
>=20
> v1->v2 :
> - Use guard() to simplify function hpage_wait_zeroing(). (pointed by
>  Raghu)
> - Simplify the logic of zero_free_hugepages_nid() by removing
>  redundant checks and exiting the loop upon encountering a
>  pre-zeroed folio. (pointed by Frank)
> - Include in the cover letter a performance comparison with Ankur's
>  optimization patch[2]. (pointed by Andrew)
>=20
> v1: =
https://lore.kernel.org/all/20251225082059.1632-1-lizhe.67@bytedance.com/
>=20
> --=20
> 2.20.1


