Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73CCCCA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 08:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C48B6B0095; Sat, 10 Oct 2026 04:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E366B0096; Sat, 10 Oct 2026 04:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 616806B0098; Sat, 10 Oct 2026 04:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 266AA6B0095
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:51:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD5FC1A06B5
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:51:27 +0000 (UTC)
X-FDA: 85306097814.02.331F692
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id BD6EB40006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:51:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jn5HG6Um;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791622285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UKe6Pwi9aosqd/1BTRv65g5XrEe0PTDfARKnWKqLqRc=;
	b=qF5J/k1A+pWB5jLxfcWWCAcXTJ3cjorGfvBsHQ9EUUztG5d8aOo09PcZZs66EiRcxeoyPf
	u6E/tWeANXaVu/bv/idB7LVGCgYH6E3o3orgrx+xMNC6RQKbMCv4gt6jYdsOsT07AQLdVP
	r51lCxwLKtyVhdod3qt/to+wZDkPV8A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791622285;
	b=6d97Shzp4xwtHuOx8ITWZyHKtXtXoXbF1cQqqrX5g34dbqLE8eGjP11JOpIgC7qOgSoyPn
	WhHA0wKIrTrwa1sPbHCp4QEdWN79dvz5qKJ5OftNQ3E2PB8+5JwQDpaNuJ/P6ikP4Bs7VQ
	SHPgryZGKGVc/+eZ2KQdS/9jUqisSDM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jn5HG6Um;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1195440530
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75031F0089D
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791622284;
	bh=UKe6Pwi9aosqd/1BTRv65g5XrEe0PTDfARKnWKqLqRc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jn5HG6UmsbnE9zPFBj+0DNSKudJj1RtW1omIoSVrkEPEZUb6NUTcKiPWqxXZpfPgS
	 FvvndyPealnW/DLxCFOySjV0/kldgEYtidP3qXCQTD74be9c9vv/T02weypRrRfX7j
	 GX96sJDUkLEX4sgQcgCGiulhPJQRMmGuo0JrebBWY8HWkCTlkSFUY2e8VtzCOR35zp
	 Ur6HTirTKm7PQUpMII4O44Zy73/oh9TxWaIp2TVmbbZfT8tanCElIvJxbAy9gKC2nP
	 NNR34CEGIYU2jK5XnfQQMsHX1JLnvPoCpanefI/X3wU6XJz0s6DfnoQ/gzQG6eefTj
	 iYPykS4YYvBmg==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93e762768f3so58693685a.0
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 01:51:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx8ckv7y9yLNb7fSCe2JOuvm1oJ2Law2gk+EOFZumUSe1qk4hI2qE+AfmmO755miO38cnL2CrR3TQ==@kvack.org
X-Gm-Message-State: AFq9FYKso0b+oyKQkYfuRfYL3mv4MSoXnH+aa4z2IjKS2H6H2y/dCehJ
	DDZCUhUPpnMKJHTEuvrKZA37eRZLcpRY9AXnY1YExQwAv8wSMwVPjNbpk4l2WTBXsUY4fiuhz2k
	gx5Un3AC9TPv8+n+3qbrCaJJ51Xj1kGQ=
X-Received: by 2002:a05:620a:4510:b0:93e:c12c:f13a with SMTP id
 af79cd13be357-93ec12d0631mr572328185a.68.1791622283896; Sat, 10 Oct 2026
 01:51:23 -0700 (PDT)
MIME-Version: 1.0
References: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <cover.1791577417.git.ehab.ababneh@intel.com> <ca68c5188e133af575302f797e7e8bd9f054709a.1791577417.git.ehab.ababneh@intel.com>
In-Reply-To: <ca68c5188e133af575302f797e7e8bd9f054709a.1791577417.git.ehab.ababneh@intel.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 10 Oct 2026 16:51:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wur9YqS1QY6b15uvFVkA8xFAV04Oi+peMGKCu4uY1y2A@mail.gmail.com>
X-Gm-Features: AclHuK_FqLAQ3bNXPcYkH27-EtFb41er8DDHIvFhRvBTX7SlUV2ZDCmcIci4y4A
Message-ID: <CAGsJ_4wur9YqS1QY6b15uvFVkA8xFAV04Oi+peMGKCu4uY1y2A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/5] vmscan: Support multiple kswapd threads per node
To: Ehab Ababneh <ehab.ababneh@intel.com>
Cc: ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	buddy.lumpkin@oracle.com, akpm@linux-foundation.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	baoquan.he@linux.dev, baolin.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BD6EB40006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: srn17dq9y69y8dtg1ipi8fn3rbo4iy78
X-HE-Tag: 1791622285-697094
X-HE-Meta: U2FsdGVkX18vS43+DtUq7L57wVgVfkThRJV64UXb6BwODB1QyvX+aVKyVjtLveLdDaPHl29/OCK6StRayTLCt9ynQgw5bIvjUsHRzLA8kvrkkLhBZ7/sAnRNTQWO+fFMMttGk9w3UpcorTbCS/HpisSSmoktL46qlQSUSHcGhT6bWG+7CXRCbiuQZCNwUMVQJM/isgPFAig+PWcR6RNKn5EyjhHOZoIAISmScZm0Fs9AQY77xOqlJUOkwNaGYUppsBiGiSioc/xIpnYbdI9B/30MfRqYpRSIFSZb9uhPl0xT6oXshVKNkNjc9xsqT9PtgChCq7OuaXSqZB29t6jrS1MC8rqc/7xFLf/ZgWrQmaGP1MJ5fkrfEVpLXU1MrivAZhu6ldOOHI1mFkfCFP20/HQOEjmoqUOi9WSViEYZOZHfp9VT5etHDRBurOsi9oPAj934plyrKtLIpQSkId3uAAufG+AsKLy7kn2QlBFIESOVJhlecSskrJLXx183h+1gmnOaWgg6Xl0k3mKwnYLvz29tYC5cDYonPWYfSwew3XsTOZZAOiWwyt/wmdEimcHrU9VzLlYkr6RUAuEDT4tRUXQ/bc7stdebN9TmLoQkbfDTcCpd0/7LBy5ZY1DWkcXVxWauBZ1rcvUI0CLXda5rvRAeULhShAtsQarKHkX0ZC6c2I/3Oj9D7lYHAHEIRu1SX2X4hcZHA0ZS9aXdEC9h5hrAd5N9l1Co6qwqSzB8nizTkojplWvxCqTWPclno0ACk4xk2ruk2L1i/oGm8m/elZUs+Sx6AIFQAaY04QP0jO9vih5i+zWl8ul8g+MRUeI++UuRv6bZNPr87iD8WEkWRkTfzGCUBQ0npCb1BOuyytVXPe6MJ3KFq9fZo8P34i43xl152rWfe7m0Q+n+9M1EkNCDKG0l3tKOE5x1GREfpMRi4PXPaTjEooqtN9y4Ar6OKpErJwPvR2VH+7aTaA8
 aaH0d4mz
 rvhyNcIjszVKiebTmS+8BMlLK1QCd/IbVRbwky0W3SgwZxZyr06jTooHXSs7iDzb8tYwCLuxvB8867q3oCVWubOcPZmdAqaN2Xc69n6jBQnhRzBRH1geGbVQDeB5hPDsjGiQNwvJfGToGUqlSKnFFlNsBy/zO+rdulprzXk1MWLUiJFcGJcvIJ5zy0AXRFv8Lz55KrwiaStGsGZfjCSjyqryy89XIwH8w/UwfjdfPYw5rUIBmgxG7rGU/lble3Hkjju+2AkIuh1OP+wvkTjzDUd1gNmj5URM1ESDXKqukJGcrJ8p60kjIdfLde6Unm/rTuhFuyCkZHK6qWYkY5OLhN9nRWE34/wM/yR1cukg4XzHCK8oKwfVYTjFTIic7tnKtB6na
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 4:30=E2=80=AFAM Ehab Ababneh <ehab.ababneh@intel.co=
m> wrote:
>
> From: Buddy Lumpkin <buddy.lumpkin@oracle.com>
>
> Page replacement is handled in the Linux Kernel in one of two ways:
>
> 1) Asynchronously via kswapd
> 2) Synchronously, via direct reclaim
>
> At page allocation time the allocating task is immediately given a page
> from the zone free list allowing it to go right back to work doing
> whatever it was doing; Probably directly or indirectly executing business
> logic.
>
> Just prior to satisfying the allocation, free pages is checked to see if
> it has reached the zone low watermark and if so, kswapd is awakened.
> Kswapd will start scanning pages looking for inactive pages to evict to
> make room for new page allocations. The work of kswapd allows tasks to
> continue allocating memory from their respective zone free list without
> incurring any delay.
>
> When the demand for free pages exceeds the rate that kswapd tasks can
> supply them, page allocation works differently. Once the allocating task
> finds that the number of free pages is at or below the zone min watermark=
,
> the task will no longer pull pages from the free list. Instead, the task
> will run the same CPU-bound routines as kswapd to satisfy its own
> allocation by scanning and evicting pages. This is called a direct reclai=
m.
>
> The time spent performing a direct reclaim can be substantial, often
> taking tens to hundreds of milliseconds for small order0 allocations to
> half a second or more for order9 huge-page allocations. In fact, kswapd i=
s
> not actually required on a linux system. It exists for the sole purpose o=
f
> optimizing performance by preventing direct reclaims.
>
> When memory shortfall is sufficient to trigger direct reclaims, they can
> occur in any task that is running on the system. A single aggressive
> memory allocating task can set the stage for collateral damage to occur i=
n
> small tasks that rarely allocate additional memory. Consider the impact o=
f
> injecting an additional 100ms of latency when nscd allocates memory to
> facilitate caching of a DNS query.
>
> The presence of direct reclaims 10 years ago was a fairly reliable
> indicator that too much was being asked of a Linux system. Kswapd was
> likely wasting time scanning pages that were ineligible for eviction.
> Adding RAM or reducing the working set size would usually make the proble=
m
> go away. Since then hardware has evolved to bring a new struggle for
> kswapd. Storage speeds have increased by orders of magnitude while CPU
> clock speeds stayed the same or even slowed down in exchange for more
> cores per package. This presents a throughput problem for a single
> threaded kswapd that will get worse with each generation of new hardware.
>
> Test Details
>
> NOTE: The tests below were run with shadow entries disabled. See the
> associated patch and cover letter for details
>
> The tests below were designed with the assumption that a kswapd bottlenec=
k
> is best demonstrated using filesystem reads. This way, the inactive list
> will be full of clean pages, simplifying the analysis and allowing kswapd
> to achieve the highest possible steal rate. Maximum steal rates for kswap=
d
> are likely to be the same or lower for any other mix of page types on the
> system.
>
> Tests were run on a 2U Oracle X7-2L with 52 Intel Xeon Skylake 2GHz cores=
,
> 756GB of RAM and 8 x 3.6 TB NVMe Solid State Disk drives. Each drive has
> an XFS file system mounted separately as /d0 through /d7. SSD drives
> require multiple concurrent streams to show their potential, so I created
> eleven 250GB zero-filled files on each drive so that I could test with
> parallel reads.
>
> The test script runs in multiple stages. At each stage, the number of dd
> tasks run concurrently is increased by 2. I did not include all of the
> test output for brevity.
>
> During each stage dd tasks are launched to read from each drive in a roun=
d
> robin fashion until the specified number of tasks for the stage has been
> reached. Then iostat, vmstat and top are started in the background with 1=
0
> second intervals. After five minutes, all of the dd tasks are killed and
> the iostat, vmstat and top output is parsed in order to report the
> following:
>
> CPU consumption
> - sy - aggregate kernel mode CPU consumption from vmstat output. The valu=
e
>        doesn't tend to fluctuate much so I just grab the highest value.
>        Each sample is averaged over 10 seconds
> - dd_cpu - for all of the dd tasks averaged across the top samples since
>            there is a lot of variation.
>
> Throughput
> - in Kbytes
> - Command is iostat -x -d 10 -g total
>
> This first test performs reads using O_DIRECT in order to show the maximu=
m
> throughput that can be obtained using these drives. It also demonstrates
> how rapidly throughput scales as the number of dd tasks are increased.
>
> The dd command for this test looks like this:
>
> Command Used: dd iflag=3Ddirect if=3D/d${i}/$n of=3D/dev/null bs=3D4M
>
> Test #1: Direct IO
> dd sy dd_cpu throughput
> 6  0  2.33   14726026.40
> 10 1  2.95   19954974.80
> 16 1  2.63   24419689.30
> 22 1  2.63   25430303.20
> 28 1  2.91   26026513.20
> 34 1  2.53   26178618.00
> 40 1  2.18   26239229.20
> 46 1  1.91   26250550.40
> 52 1  1.69   26251845.60
> 58 1  1.54   26253205.60
> 64 1  1.43   26253780.80
> 70 1  1.31   26254154.80
> 76 1  1.21   26253660.80
> 82 1  1.12   26254214.80
> 88 1  1.07   26253770.00
> 90 1  1.04   26252406.40
>
> Throughput was close to peak with only 22 dd tasks. Very little system CP=
U
> was consumed as expected as the drives DMA directly into the user address
> space when using direct IO.
>
> In this next test, the iflag=3Ddirect option is removed and we only run t=
he
> test until the pgscan_kswapd from /proc/vmstat starts to increment. At
> that point metrics are parsed and reported and the pagecache contents are
> dropped prior to the next test. Lather, rinse, repeat.
>
> Test #2: standard file system IO, no page replacement
> dd sy dd_cpu throughput
> 6  2  28.78  5134316.40
> 10 3  31.40  8051218.40
> 16 5  34.73  11438106.80
> 22 7  33.65  14140596.40
> 28 8  31.24  16393455.20
> 34 10 29.88  18219463.60
> 40 11 28.33  19644159.60
> 46 11 25.05  20802497.60
> 52 13 26.92  22092370.00
> 58 13 23.29  22884881.20
> 64 14 23.12  23452248.80
> 70 15 22.40  23916468.00
> 76 16 22.06  24328737.20
> 82 17 20.97  24718693.20
> 88 16 18.57  25149404.40
> 90 16 18.31  25245565.60
>
> Each read has to pause after the buffer in kernel space is populated whil=
e
> those pages are added to the pagecache and copied into the user address
> space. For this reason, more parallel streams are required to achieve pea=
k
> throughput. The copy operation consumes substantially more CPU than direc=
t
> IO as expected.
>
> The next test measures throughput after kswapd starts running. This is th=
e
> same test only we wait for kswapd to wake up before we start collecting
> metrics. The script actually keeps track of a few things that were not
> mentioned earlier. It tracks direct reclaims and page scans by watching
> the metrics in /proc/vmstat. CPU consumption for kswapd is tracked the
> same way it is tracked for dd.
>
> Since the test is 100% reads, you can assume that the page steal rate for
> kswapd and direct reclaims is almost identical to the scan rate.
>
> Test #3: 1 kswapd thread per node
> dd sy dd_cpu kswapd0 kswapd1 throughput  dr    pgscan_kswapd pgscan_direc=
t
> 10 4  26.07  28.56   27.03   7355924.40  0     459316976     0
> 16 7  34.94  69.33   69.66   10867895.20 0     872661643     0
> 22 10 36.03  93.99   99.33   13130613.60 489   1037654473    11268334
> 28 10 30.34  95.90   98.60   14601509.60 671   1182591373    15429142
> 34 14 34.77  97.50   99.23   16468012.00 10850 1069005644    249839515
> 40 17 36.32  91.49   97.11   17335987.60 18903 975417728     434467710
> 46 19 38.40  90.54   91.61   17705394.40 25369 855737040     582427973
> 52 22 40.88  83.97   83.70   17607680.40 31250 709532935     724282458
> 58 25 40.89  82.19   80.14   17976905.60 35060 657796473     804117540
> 64 28 41.77  73.49   75.20   18001910.00 39073 561813658     895289337
> 70 33 45.51  63.78   64.39   17061897.20 44523 379465571     1020726436
> 76 36 46.95  57.96   60.32   16964459.60 47717 291299464     1093172384
> 82 39 47.16  55.43   56.16   16949956.00 49479 247071062     1134163008
> 88 42 47.41  53.75   47.62   16930911.20 51521 195449924     1180442208
> 90 43 47.18  51.40   50.59   16864428.00 51618 190758156     1183203901
>
> In the previous test where kswapd was not involved, the system-wide kerne=
l
> mode CPU consumption with 90 dd tasks was 16%. In this test CPU consumpti=
on
> with 90 tasks is at 43%. With 52 cores, and two kswapd tasks (one per NUM=
A
> node), kswapd can only be responsible for a little over 4% of the increas=
e.
> The rest is likely caused by 51,618 direct reclaims that scanned 1.2
> billion pages over the five minute time period of the test.
>
> Same test, more kswapd tasks:
>
> Test #4: 4 kswapd threads per node
> dd sy dd_cpu kswapd0 kswapd1 throughput  dr    pgscan_kswapd pgscan_direc=
t
> 10 5  27.09  16.65   14.17   7842605.60  0     459105291     0
> 16 10 37.12  26.02   24.85   11352920.40 15    920527796     358515
> 22 11 36.94  37.13   35.82   13771869.60 0     1132169011     0
> 28 13 35.23  48.43   46.86   16089746.00 0     1312902070     0
> 34 15 33.37  53.02   55.69   18314856.40 0     1476169080     0
> 40 19 35.90  69.60   64.41   19836126.80 0     1629999149     0
> 46 22 36.82  88.55   57.20   20740216.40 0     1708478106     0
> 52 24 34.38  93.76   68.34   21758352.00 0     1794055559     0
> 58 24 30.51  79.20   82.33   22735594.00 0     1872794397     0
> 64 26 30.21  97.12   76.73   23302203.60 176   1916593721     4206821
> 70 33 32.92  92.91   92.87   23776588.00 3575  1817685086     85574159
> 76 37 31.62  91.20   89.83   24308196.80 4752  1812262569     113981763
> 82 29 25.53  93.23   92.33   24802791.20 306   2032093122     7350704
> 88 43 37.12  76.18   77.01   25145694.40 20310 1253204719     487048202
> 90 42 38.56  73.90   74.57   22516787.60 22774 1193637495     545463615
>
> By increasing the number of kswapd threads, throughput increased by ~50%
> while kernel mode CPU utilization decreased or stayed the same, likely du=
e
> to a decrease in the number of parallel tasks at any given time doing pag=
e
> replacement.
>
> Signed-off-by: Buddy Lumpkin <buddy.lumpkin@oracle.com>
> Signed-off-by: Ehab Ababneh <ehab.ababneh@intel.com>
> (cherry picked from commit 9ca50cb821f07627d555d31311f1c296bcd415d0)
> ---

Hi Buddy, Ehab,

I'm not quite sure we want to increase the number of
kswapd threads. It seems you want to reclaim memory more
aggressively in the background to reduce direct reclaim.
However, do we really need more kswapd threads when userspace
can use other proactive reclamation approaches? For Android,
we also have mechanisms like lmkd.

Also, if the bottleneck is aging or compression, we could consider
something like `kcompressd` for asynchronous compression, which
has been on hold for a while.
https://lore.kernel.org/linux-mm/20250430082651.3152444-1-qun-wei.lin@media=
tek.com/

Or perhaps something like `kaged` for aging? Those could be much lighter
than running multiple `kswapd` threads in parallel.

Best Regards
Barry

