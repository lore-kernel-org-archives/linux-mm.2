Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C3ADE94625
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 02:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DFE16B00A2; Mon,  9 Feb 2026 21:44:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D436B00A4; Mon,  9 Feb 2026 21:44:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48BA96B00A5; Mon,  9 Feb 2026 21:44:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 369FD6B00A2
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 21:44:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB2D714035D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:44:05 +0000 (UTC)
X-FDA: 84427002450.24.9905E4F
Received: from mail.eskimo.com (mail.eskimo.com [66.114.134.197])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1026040002
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:44:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of nanook@eskimo.com designates 66.114.134.197 as permitted sender) smtp.mailfrom=nanook@eskimo.com;
	dmarc=pass (policy=reject) header.from=eskimo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770691444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=57D3aozZGydyC3o2B06Ijhxqagl0Q7XGsxlA/7zXkyw=;
	b=lzZSaudyAJOo+zDdNuNl0GE9JH9obHge5YnnLAIaEMF6qJXd5VhMNjGj3TdUTlzbujOXiI
	ygnk6JSXzKWcDaJmDEYUKcn4r+mzqOEEfbGqWUQKpOEY9EG1UQahasyvjxxa1ttsnwuvqb
	ge3idaNGYMbFWScs9ZZCX2ex0AiMHvY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of nanook@eskimo.com designates 66.114.134.197 as permitted sender) smtp.mailfrom=nanook@eskimo.com;
	dmarc=pass (policy=reject) header.from=eskimo.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770691444; a=rsa-sha256;
	cv=none;
	b=nyU1T/n63ibL4dYwkDmz2sCxGto3PsgwYGy3Lz3aL3vcx+8NNqwkWgUY0Wiv507vJXd7+Q
	QEqkSyrjog29h96mBdzEj1gRIyGiBRES6MNLwpF0J21mj4qvlt/625zbNNin5AzXNy4ezy
	eBjwO/q8yuKtaEGmOqOyP3zvJye1O7w=
Received: from ubuntu.eskimo.com (ubuntu.eskimo.com [IPv6:2001:560:4407:1::106])
	by mail.eskimo.com (Postfix) with ESMTPS id 2E2513C4198;
	Mon,  9 Feb 2026 18:44:02 -0800 (PST)
Date: Mon, 9 Feb 2026 18:44:02 -0800 (PST)
From: Robert Dinse <nanook@eskimo.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@kvack.org, Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Subject: Regression: CONFIG_ASYNC_KERNEL_PGTABLE_FREE causes
 memory exhaustion and stalls on busy Cascade Lake server (6.18.7 only)
In-Reply-To: <20260209182049.74695cae76dfdf7718a12877@linux-foundation.org>
Message-ID: <954a502a-7c20-4db3-3dab-be0c0b24be70@eskimo.com>
References: <06843c7a-909b-41e5-9359-2be51cf9dffa@eskimo.com> <20260209182049.74695cae76dfdf7718a12877@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1916979846-702765108-1770691442=:5705"
X-Virus-Scanned: clamav-milter 1.4.3 at mail.eskimo.com
X-Virus-Status: Clean
X-Stat-Signature: hpe6uwc1z78zxzndrkbfpzka9egq4ipb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1026040002
X-HE-Tag: 1770691443-345069
X-HE-Meta: U2FsdGVkX1+/mrI1lowgU9aNw9Em9e6NCrfFZ10UJ4zwwk8v5u/74zlkoOxQab/xvjVYZrndBARd1NyuhRHXN/aLkX9YxaTZx62oXKses7RrXpvXUcMp6+5uLvHxQRc6TyFcaW3XBYMrzEHE9tIkDDR+Z17aEmx40LnM+vHZM1IkSD2y/si7QggVsA+0puilewq+02jwy2ptA1NZh0YBFff0wvL53ae9CUgL9X9qe/mUV5q2PzepIvwWRvt1RDcWLFL9sIs68FGIKgFwLF7KeWGbLPZ8haz1a+2ll2Ko18q06liSjl92KE9HGfsutwjeAvtnkBLQMh0tJEOScDjIg1dUYBpFYP4v2TaluW+6qwJ3Vp02HDaeOgpJckn+Tqgp42Xo83EgDKCIG/lX4HOxFn8L2kBBksT2weA1RJaqVpg4Zrobkx+KWRAXKSu+LpcF+w7wRwPAQ01sUfMlitASqymZ3REDJxZqXbHyFv7E67k4tAC8+qDdFikibRGXWD6sjggljkS7UOrK18rfAGPa10Z0n7SWSrYTdu8pwqSHJG1K8sKXSFXdH+2R+a8Z6zNmiRzsY3huZjJ6KFSG3B5XPRpwU435k2QZdkdevZ6J7sYfM53nB14JtYbah3p/OAzngmPneOPNdgEEW1S99xEYGBu10yQk3sczlSSOWD6kdZ0zwQoccpMmOXlEVGCMiXLiMrK2yDFEWhbXa1LnNFabVNY9GxZsVXxKR/TNHQ19g70g5XgaSoXxlmkp8Q3jyGRHHrgtIkJpOXr8RyDvYy9iOybDMIGKLqqqbBQUtheSpPvbGgUf8fEX6PNg5N8IIaiInb3U3vuB/8pAVS1WxLx5runQoL4bukT7rS6xx/ygieC/FfgkeFXLqM9AZ14Kip+z7IV9TvzkYftRN0PuMSQbJkaaxIlWGCl9FkROJLcoSjpn1FWbCXhBnjQU8O4H16XoVSmu3Lhz01BVo36JI+K
 28/fIQf4
 wDiwE8q1ZopzadDvqHiLDIim+5Q604ZaS3RrphxKs+xxnYNZtvbIpdR8pbVPW+8NoDZcTmuBfEtf3h1yOIPSyzBtQRpL+6hsUseZiO7GOkr24AkLlt5NKmbSp4Kt1ugb6FfXZzDFPcKlRvCus7IHGoiV/QiT1BuekEWwY0/SwXL0gphF0DIFznUqBsh2991L4kDz1qwZgz2aJvw1GR+NHSGG02OWMoHIwmdgSlHEEztqTmwP0zruONvUIxLOPgHitBlOq3BYXKBQJq1k6O955dejJgAEiDJ9PO4U2VJeEn+9R4TbDH7CcvqqtJyJ50PpKHlVN3WHD2hFZQwKMLuBnbLS6w4OuMHxfxx+Ciq3NvR6FRs36zqvpSK0t0wCKLMA0ZsNffgXv54ApmQn3ta7ny6y8RIfYl68xB9IKeYpYVbrGapXbPEDqW9AHjASdXRkGeRW0y/WLjuE9Vkgvsy49m0CUpsHJadcfBnY3wlGHRQ9qBgx2gmHQrN9SaH53MwsQZXEz+TYxmMk3xs4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1916979846-702765108-1770691442=:5705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT


      Whatever WAS the issue was resolved in 6.18.8 so I withdraw this bug
report as it is no longer applicable.

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
  Eskimo North Linux Friendly Internet Access, Shell Accounts, and Hosting.
    Knowledgeable human assistance, not telephone trees or script readers.
  See our web site: http://www.eskimo.com/ (206) 812-0051 or (800) 246-6874.

On Mon, 9 Feb 2026, Andrew Morton wrote:

> Date: Mon, 9 Feb 2026 18:20:49 -0800
> From: Andrew Morton <akpm@linux-foundation.org>
> To: Robert Dinse <nanook@eskimo.com>
> Cc: linux-mm@kvack.org, Dave Hansen <dave.hansen@linux.intel.com>
> Subject: Re: Subject: Regression: CONFIG_ASYNC_KERNEL_PGTABLE_FREE causes
>     memory exhaustion and stalls on busy Cascade Lake server (6.18.7 only)
> 
> On Wed, 28 Jan 2026 22:10:11 -0800 Robert Dinse <nanook@eskimo.com> wrote:
>
>>
>> Hardware / setup
>> ----------------
>> - CPU: Intel i9-10980XE (Cascade Lake), all cores overclocked to 4.5 GHz
>> - Motherboard: Gigabyte Aorus Master X299
>> - PSU: 1200W Seasonic
>> - RAM: 256 GB
>> - Storage:
>>    - MariaDB: RAID1 of two 1 TB NVMe drives
>>    - Other storage: RAID1 arrays of spinning disks
>>
>> Software
>> --------
>> - OS: Ubuntu 24.04, with most userland and kernel replaced by
>> self-compiled upstream
>> - Kernel:
>>    - 6.18.6: stable, previously in production
>>    - 6.18.7: regression
>> - Toolchain: gcc 15.2
>> - Services:
>>    - Apache 2.4.65 (self-compiled), with modified exec-php to allow
>> per-user PHP versions via handlers
>>    - MariaDB with ~60 GB of tables
>>    - InnoDB buffer pool: ~70 GB
>>    - Several social media sites and other complex web hosting workloads
>>
>> Baseline behavior (6.18.6)
>> --------------------------
>> Under 6.18.6, the machine behaves as expected:
>> - Roughly half of the 256 GB RAM in use, half available
>> - Memory usage stable over time
>> - Swap usage negligible
>> - Web server and database remain responsive under normal production load
>
> Thanks.
>
>> Regression behavior (6.18.7)
>> ----------------------------
>> After upgrading from 6.18.6 to 6.18.7, the system initially runs
>> normally, but after
>> approximately 24 hours of production load:
>> - Total memory usage climbs until RAM is fully consumed
>> - System goes ~10 GB into swap
>> - Web server and database stall intermittently
>> - Overall system responsiveness degrades severely
>>
>> Reverting to 6.18.6 immediately restores the previous stable behavior.
>>
>> Attempt to disable CONFIG_ASYNC_KERNEL_PGTABLE_FREE
>
> I don't understand why you believe this issue was caused by the
> CONFIG_ASYNC_KERNEL_PGTABLE_FREE code?
>
>> ---------------------------------------------------
>> I attempted to disable the new async kernel page table freeing feature:
>>
>> - The symbol `CONFIG_ASYNC_KERNEL_PGTABLE_FREE` appears in `.config`
>> - However, it does not appear in xconfig or other configuration frontends
>> - Manually editing `.config` to disable it works only until the next `make`:
>>    - As soon as I re-run the build, the option is silently re-enabled
>> - I tried to chase the Kconfig dependencies, but the chain was too
>> convoluted; it appears to be effectively non-user-selectable and forced
>> on by default for my architecture.
>
> Yes, CONFIG_ASYNC_KERNEL_PGTABLE_FREE is always-on for x86.
> arch/x86/Kconfig has
>
> 	select ASYNC_KERNEL_PGTABLE_FREE	if IOMMU_SVA
>
> so removing that line will permit you to disable
> ASYNC_KERNEL_PGTABLE_FREE.
>
> I don't know why this is conditioned on IOMMU_SVA=y - that was an
> unchangelogged alteration.
>
> Please do persist with the CONFIG_ASYNC_KERNEL_PGTABLE_FREE=n testing.
>
>>  From an operator perspective, this feature as currently implemented is
>> not workable on a busy machine like this, and the inability to disable
>> it makes it difficult to bisect or run with a known-good configuration.
>>
>> Current status
>> --------------
>> - I have reverted to 6.18.6, which remains functional and stable under
>> the same workload.
>> - I have attached the '.config' for the affected 6.18.7 kernel.
>> - I can also collect additional data (vmstat, /proc/meminfo, slabinfo,
>> etc.) if you tell me what would be most useful.
>>
>> Request
>> -------
>> 1. Is this a known issue with CONFIG_ASYNC_KERNEL_PGTABLE_FREE on
>> large-memory, high-load systems?
>
> Not as far as I know.
>
>> 2. Is there a supported way to disable this feature on x86_64, or could
>> it be made user-selectable for debugging/regression purposes?
>
> That would be good.
>
>> 3. Are there specific traces or statistics you would like me to gather
>> when the system is in the "memory maxed + swap in use + stalls" state?
>
> A starting point would be /proc/*info - try to spot something which
> increased a lot.
>
--1916979846-702765108-1770691442=:5705--

