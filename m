Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C700EC87FCA
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 18:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495D06B0089; Tue, 29 Jul 2025 14:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F876B008A; Tue, 29 Jul 2025 14:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E466B008C; Tue, 29 Jul 2025 14:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1DF2D6B0089
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:35:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6335C01FE
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:35:05 +0000 (UTC)
X-FDA: 83718154170.14.6C9A31F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 02A8E1C000E
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:35:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FqcTBmrz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753814104; a=rsa-sha256;
	cv=none;
	b=JbH2QtHywaH1UtDac2OEpwpF5rizNWEOxV+ZnHpYUY6l3Xa1lrxUp2cKvGAsaK+MvZK5H9
	8oqAT3rqeJvdjhDvx7aWTkwMtrTGOiX9DOFi3pBB8CLHj2VD3A09nkf7VTXQAL4+7oqVkH
	elk5cbC3w7TwiEY5JSjlIN8DvmBEloU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FqcTBmrz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753814104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=86EtJrRDDi41hIxnr8VsBt2yyEIaqRZmpLENSjFJ6i0=;
	b=s8UztSN0rTsCvaKsp/7/nMfAtNSGsj3GaDl54ESZdp5OLbvHWUZh+f578fAkOObWavmZJ3
	iRKHIopyr9HdnfTYZCfc0B6XjK5jQN7ET/gqetQKVj1x4kRpkHjp9FRj5auMEBL+1rgizZ
	Tf2OLTGy9hjM2NOm+LggjRhoik2dFHs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B9F2B43AFF;
	Tue, 29 Jul 2025 18:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694C4C4CEEF;
	Tue, 29 Jul 2025 18:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753814102;
	bh=Ad+h/78ZxwD6mSt4jRq861L+6lQvlmuf+yPcWZOe2h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqcTBmrzzYZcUzhXReID4UeShTvo4pQhNy/0QoDsD0t0I9owoNH47SutX7xO4TQn3
	 xUA++PYUb9hFYYVcJbmoYsyZfUYHHV+3mcsCsmErI8quymCd2i1YBnTDJLXh31bQ00
	 jUgJ1Cfr8ediO95VkPThcZuMZqH4AXiLGhLDFpiixssuvvgyobJTVaHyXDbdqvCXnc
	 suyTMmswiUIK7mOFQIHWdGjqQE4nSg8/UqxEDozjioML+egMuP4RcD8a6Tol937srf
	 HPVkLnKrYfxrCXtJPW2nPUS4FAIVj2EftUpWV7YrS5o49txRN6QV4fqLd4kkv34BOA
	 oe8uRgVLTPutA==
From: SeongJae Park <sj@kernel.org>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] mm/damon: Add damos_stat support for vaddr
Date: Tue, 29 Jul 2025 11:34:59 -0700
Message-Id: <20250729183459.56512-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1753794408.git.pyyjason@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 02A8E1C000E
X-Stat-Signature: z3jf96nmc7jz17ne4rec9gbco8in1pws
X-Rspam-User: 
X-HE-Tag: 1753814103-566998
X-HE-Meta: U2FsdGVkX1/beEl9Ksuw9QLQGKGSaniAro/YVUUB+A8oNkAaMchqEw1e4J1zx8Sjn+P1b7qCD/nGx4EBZxXuej28WfkLmlTTBWyP3ClaD3yZU7JUuiGtTDdVtvxwWq0X9xiY7hw1NmmoMWx0WK3bAoxMU8XaMD4g96CIUlxup1WMhnm0zBDGmYwQV+FzeBLeaIz87YVOHke+23SspDwQMmQwWxmrh5O4+9obJI98SE67BYMJmmHX2spAiyAeNcW7kgk5yV1uFkYnWi2rkLviFa1S611sSqPJWmTsjNq0vQjWq04ag1/a4eMmED//1SqNA4Nq7MvMP3l07T1vtTqUeJ2FRxcy+fkNuGQFteCbxO9pFAEItRYEBUNnXRe/3ZTOQrs10n8YXVAwaxXYKQ9GN269RdovOk5IUX1q20BGQUFX8c7STs7nEfPVc1H7uV2cJ8vF2E1DoPM2Zwgo/l+Vs4nD0jB/8ydd0Uk5CB7DJY6wXdJwpnxIBV3EjAaFmxVRMnHeta7aLEAws/5CcggWBLxnwnpSVMdFklylwP9rdbDhAWf5iHipN3OLlLT3HvUrRyROT8quZjeESZDgmVp0AKQmD7lFajMxeLOiLVd5XXprHvHa84OmUXzWviD52Zhj+VDrW/xpYKate/qM/3L3tmWAoK1JK9p7yiiGb6S4KSI3NHq2XmVDICtB4NVLccvwKvKAmINQdA6HnxPm61ga4tsMtA4qPzjdaHExUdgi3+t3Y+HrHGGpi2oePeU9F544IpbCDES06CKdc67XMjqSJaTTCjmP8eoJgPIM36MXUBxZ5BusAydmm2t3ILwWTcf6jkqjOnAHifkh1vxnt+pXo/M5bYTMtj/bbl1mFPie6f55umEhv3plfhkSwy/OQUgzD+iajHuA//8/30fLFZrfqgv1BHTQ0q0e4vZJOFVpgRjOfWdBAcg1NFXGlbsLox95Cx+1OfvOK90pQvELyTi
 XZEAzS23
 3UGm2O/Pcz3NicD2R0n2hwzU8Nc6rQApJ9JcDTBQJzGYB5hnYOrOObIxppSMtFE8Yvknj4XJLxA/wcNK4uEQ1zgcsdNDTvThQSCDkhh3t2u6QlRSXlRBoXHFq2muF0TjtA1m5UUCopbroPe1LJSoRfFXcI6mTjk5Ac2T30x8+gkrqPCKAgsfSDjfc2pVW7VJnlEkiwNPIHufrfiaws+4bckUPt5idQwMsU7NWx7XKr54YTORVi6GuLvFK9pxaP1T42xoSKqh7ysG1ImiaiHaHv0drsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Pan (Or, should I call you Yueyang or Jason?  Please let me know your
preferrence if you have),

On Tue, 29 Jul 2025 06:53:28 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:

> From: PanJason <pyyjason@gmail.com>
> 
> Previously damos_stat only supoort paddr. This patch set adds support 
> for damos_stat for vaddr. Also all different types of filters are 
> supported. 
> 
> Functionality Test
> ==================
> I wrote a small test program which allocates 10GB of DRAM, use 
> madvise(MADV_HUGEPAGE) to convert the base pages to 2MB huge pages
> Then my program does the following things in order:
> 1. Write sequentially to the whole 10GB region
> 2. Read the first 5GB region sequentially for 10 times
> 3. Sleep 5s
> 4. Read the second 5GB region sequentially for 10 times
> 
> With a proper damon setting, we are expected to see df-passed to be 10GB
> and hot region move around with the read
> 
> $ # Start damon record
> $sudo ./damo/damo record "./my_test/test" --monitoring_intervals 100000\
> 1000000 2000000

You can use 'start' instead of 'record' for this test purpose.

--monitoring_intervals receive more human-friendly format, so you can do
'--monitoring_intervals 100ms 1s 2s'.

> 
> $ # damon report
> $sudo ./damo/damo report access --snapshot_damos_filter reject none \
> hugepage_size 2MiB 2MiB

The --snapshot_damos_filter option means you want to make folios that not
having size 2 MiB not passed by the filter.  You can ask same thing in more
intuitive way, like below.

    --snapshot_damos_filter allow hugepage_size 2MiB 2MiB

> heatmap:
> # min/max temperatures: -900,000,000, 100,002,000, column size: 136.564 MiB

checkpatch.pl gives me below warning:

    WARNING: Commit log lines starting with '#' are dropped by git as comments

I'd suggest adding four spaces prefix to quoted command outputs like this.

> intervals: sample 100 ms aggr 1 s (max access hz 10)
> # damos filters (df): reject none hugepage_size [2.000 MiB, 2.000 MiB]
> df-pass:
> # min/max temperatures: -663,075,528, 100,002,000, column size: 128.037 MiB
> 0   addr 86.082 TiB   size 682.039 MiB access 0 hz   age 9 s           df-passed 0 B
> 1   addr 127.225 TiB  size 466.039 MiB access 1.000 hz age 0 ns          df-passed 468.000 MiB
[...]
> memory bw estimate: 3.615 GiB per second  df-passed: 3.615 GiB per second
> total size: 10.669 GiB  df-passed 10.000 GiB
> record DAMON intervals: sample 100 ms, aggr 1 s
> 
> $ # damon report again
> $sudo ./damo/damo report access --snapshot_damos_filter reject none \
> hugepage_size 2MiB 2MiB
> heatmap:
> # min/max temperatures: -1,100,000,000, 300,001,000, column size: 136.564 MiB
> intervals: sample 100 ms aggr 1 s (max access hz 10)
> # damos filters (df): reject none hugepage_size [2.000 MiB, 2.000 MiB]
> df-pass:
> # min/max temperatures: -800,000,000, 300,001,000, column size: 128.037 MiB
> 0   addr 86.082 TiB   size 682.039 MiB access 0 hz   age 11 s          df-passed 0 B
> 1   addr 127.225 TiB  size 10.355 MiB  access 1.000 hz age 0 ns          df-passed 12.000 MiB
> 2   addr 127.225 TiB  size 93.207 MiB  access 1.000 hz age 0 ns          df-passed 92.000 MiB
> 3   addr 127.225 TiB  size 414.262 MiB access 1.000 hz age 0 ns          df-passed 414.000 MiB
> 4   addr 127.225 TiB  size 706.695 MiB access 1.000 hz age 3 s           df-passed 708.000 MiB
> 5   addr 127.226 TiB  size 78.523 MiB  access 1.000 hz age 3 s           df-passed 78.000 MiB
[...]
> total size: 10.669 GiB  df-passed 10.000 GiB
> record DAMON intervals: sample 100 ms, aggr 1 s
> 
> As you can see the total df-passed region is 10GiB and the hot region
> moves as the seq read keeps going
> 
> PanJason (2):
>   mm/damon: Move invalid folio and has filter to ops-common
>   mm/damon: Add damos_stat support for vaddr

The changes look good overall, though I left a few comments for formatting and
unnecessary folio references that inherited from my original sin.  Looking
forward to more discussions and next version of this great patch series!


Thanks,
SJ

[...]

